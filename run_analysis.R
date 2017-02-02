# This file must be run from the folder below UCI HAR Dataset
dataset_exists <- dir.exists("UCI HAR Dataset")

if(!dataset_exists){
  stop("UCI HAR Dataset folder is not in the current directory")
}

# If it reaches this point it means that the folder exists and we can proceed with tidying data

# Loading Test Data
test_data_x <- read.table("./UCI HAR Dataset/test/X_test.txt")
test_data_y <- read.table("./UCI HAR Dataset/test/y_test.txt")
test_subject <- read.table("./UCI HAR Dataset/test/subject_test.txt")

#Loading Training Data
training_data_x <- read.table("./UCI HAR Dataset/train/X_train.txt")
training_data_y <- read.table("./UCI HAR Dataset/train/y_train.txt")
training_subject <- read.table("./UCI HAR Dataset/train/subject_train.txt")

#Loading Variables Names
data_names <- read.table("./UCI HAR Dataset/features.txt")

#Merge Data
data_x <- rbind(training_data_x, test_data_x)
data_y <- rbind(training_data_y, test_data_y)
data_subject <- rbind(test_subject, training_subject)
names(data_x) <- data_names[, 2]

#Extracts measurements on mean and std
filtered_data_x <- data_x[, grep("mean\\(|std\\(", names(data_x))]

#Merge data_y, and subject
filtered_data_x <- cbind(data_subject, data_y, filtered_data_x)
names(filtered_data_x)[1:2] <- c("subject", "activity")

#Load activity names
activity_names <- read.table("./UCI HAR Dataset/activity_labels.txt")

#Merge activity names
filtered_data <- merge(activity_names, filtered_data_x, by.x = "V1", by.y = "activity", all=T)
names(filtered_data)[c(1,2)] <- c("Activity Id", "ActivityDescription")

# Independant Tidy data set with average of each variable for each activity and each subject
library(dplyr)
to_export <- tbl_df(filtered_data) %>% 
                group_by(subject, ActivityDescription) %>%
                summarize_all(mean)

# Exporting Independant Tidy Data Set and Merged Filtered Data
write.table(filtered_data, "Tidy Merged Data.txt")
write.table(to_export, "independant_tidy_data_set.txt")