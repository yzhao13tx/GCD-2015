## Read Training Data
setwd("~/Analytics/GetCleanData/UCI HAR Dataset")
alabel<-read.table("activity_labels.txt")
feat<-read.table("features.txt")
setwd("~/Analytics/GetCleanData/UCI HAR Dataset/train")
sub_tr<-read.table("subject_train.txt")
y_tr<-read.table("y_train.txt")
training<-read.table("x_train.txt")
colnames(training)<-feat$V2
training[,"activity"]<-y_tr
training[,"subject"]<-sub_tr$V1
for (i in 1:length(training)) {training$activity[i]<-as.character(alabel[training$activity[i],2])}

## Read Test Data
setwd("~/Analytics/GetCleanData/UCI HAR Dataset/test")
test<-read.table("X_test.txt")
y_te<-read.table("y_test.txt")
colnames(test)<-feat$V2
sub_te<-read.table("subject_test.txt")
test[,"activity"]<-y_te
test[,"subject"]<-sub_te
for (i in 1:length(test)) {test$activity[i]<-as.character(alabel[test$activity[i],2])}

## Merge training and test data
complete<-merge(training,test,all=T)
# Measurement in each data set was on different subject, therefore, two data sets were simply added

# Extract only variables that containing mean() and std()
num1<-grep("mean",feat$V2)
num2<-grep("std",feat$V2)
number<-c(num1,num2)
tidydata<-complete[,number]
tidydata[,"activity"]<-complete$activity
tidydata[,"subject"]<-complete$subject
## Resulting dataset is cleandata[10299 X 81]

# Average all other variables for each subject and each activity
library(reshape2)
subact = melt(tidydata, id = c("subject", "activity"))
tidydata_mean<-dcast(subact, subject+activity ~ variable, mean)
write.table(tidydata_mean,"tidydata.txt",row.names = FALSE)

