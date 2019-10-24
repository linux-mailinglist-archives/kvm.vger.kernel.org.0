Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03BB6E29C2
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2019 07:08:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437455AbfJXFIg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Oct 2019 01:08:36 -0400
Received: from mga11.intel.com ([192.55.52.93]:7748 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725298AbfJXFIg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Oct 2019 01:08:36 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Oct 2019 22:08:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,223,1569308400"; 
   d="scan'208";a="197627634"
Received: from debian-nuc.sh.intel.com ([10.239.160.133])
  by fmsmga007.fm.intel.com with ESMTP; 23 Oct 2019 22:08:34 -0700
From:   Zhenyu Wang <zhenyuw@linux.intel.com>
To:     kvm@vger.kernel.org
Cc:     alex.williamson@redhat.com, kwankhede@nvidia.com,
        kevin.tian@intel.com, cohuck@redhat.com
Subject: [PATCH 1/6] vfio/mdev: Add new "aggregate" parameter for mdev create
Date:   Thu, 24 Oct 2019 13:08:24 +0800
Message-Id: <20191024050829.4517-2-zhenyuw@linux.intel.com>
X-Mailer: git-send-email 2.24.0.rc0
In-Reply-To: <20191024050829.4517-1-zhenyuw@linux.intel.com>
References: <20191024050829.4517-1-zhenyuw@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For special mdev type which can aggregate instances for mdev device,
this extends mdev create interface by allowing extra "aggregate=xxx"
parameter, which is passed to mdev device model to be able to create
bundled number of instances for target mdev device.

Cc: Kirti Wankhede <kwankhede@nvidia.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Cornelia Huck <cohuck@redhat.com>
Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
---
v2: create new create_with_instances operator for vendor driver
v3:
- Change parameter name as "aggregate="
- Fix new interface comments.
- Parameter checking for new option, pass UUID string only to
  parse and properly end parameter for kstrtouint() conversion.
v4:
- rebase
- just call create_with_instances if exists, otherwise call create

 drivers/vfio/mdev/mdev_core.c    | 17 +++++++++++++++--
 drivers/vfio/mdev/mdev_private.h |  4 +++-
 drivers/vfio/mdev/mdev_sysfs.c   | 27 +++++++++++++++++++++++----
 include/linux/mdev.h             | 11 +++++++++++
 4 files changed, 52 insertions(+), 7 deletions(-)

diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
index b558d4cfd082..4926a99f664d 100644
--- a/drivers/vfio/mdev/mdev_core.c
+++ b/drivers/vfio/mdev/mdev_core.c
@@ -270,7 +270,8 @@ static void mdev_device_release(struct device *dev)
 }
 
 int mdev_device_create(struct kobject *kobj,
-		       struct device *dev, const guid_t *uuid)
+		       struct device *dev, const guid_t *uuid,
+		       unsigned int instances)
 {
 	int ret;
 	struct mdev_device *mdev, *tmp;
@@ -281,6 +282,13 @@ int mdev_device_create(struct kobject *kobj,
 	if (!parent)
 		return -EINVAL;
 
+	if (instances > 1 &&
+	    !parent->ops->create_with_instances) {
+		dev_warn(dev, "Non-supported aggregate instances create\n");
+		ret = -EINVAL;
+		goto mdev_fail;
+	}
+
 	mutex_lock(&mdev_list_lock);
 
 	/* Check for duplicate */
@@ -319,8 +327,13 @@ int mdev_device_create(struct kobject *kobj,
 	dev_set_name(&mdev->dev, "%pUl", uuid);
 	mdev->dev.groups = parent->ops->mdev_attr_groups;
 	mdev->type_kobj = kobj;
+	mdev->type_instances = instances;
 
-	ret = parent->ops->create(kobj, mdev);
+	if (parent->ops->create_with_instances)
+		ret = parent->ops->create_with_instances(kobj, mdev,
+							 instances);
+	else
+		ret = parent->ops->create(kobj, mdev);
 	if (ret)
 		goto ops_create_fail;
 
diff --git a/drivers/vfio/mdev/mdev_private.h b/drivers/vfio/mdev/mdev_private.h
index 7d922950caaf..56cbe9ea8817 100644
--- a/drivers/vfio/mdev/mdev_private.h
+++ b/drivers/vfio/mdev/mdev_private.h
@@ -33,6 +33,7 @@ struct mdev_device {
 	struct kobject *type_kobj;
 	struct device *iommu_device;
 	bool active;
+	unsigned int type_instances;
 };
 
 #define to_mdev_device(dev)	container_of(dev, struct mdev_device, dev)
@@ -58,7 +59,8 @@ int  mdev_create_sysfs_files(struct device *dev, struct mdev_type *type);
 void mdev_remove_sysfs_files(struct device *dev, struct mdev_type *type);
 
 int  mdev_device_create(struct kobject *kobj,
-			struct device *dev, const guid_t *uuid);
+			struct device *dev, const guid_t *uuid,
+			unsigned int instances);
 int  mdev_device_remove(struct device *dev);
 
 #endif /* MDEV_PRIVATE_H */
diff --git a/drivers/vfio/mdev/mdev_sysfs.c b/drivers/vfio/mdev/mdev_sysfs.c
index 7570c7602ab4..6c2693dd4022 100644
--- a/drivers/vfio/mdev/mdev_sysfs.c
+++ b/drivers/vfio/mdev/mdev_sysfs.c
@@ -48,17 +48,27 @@ static const struct sysfs_ops mdev_type_sysfs_ops = {
 	.store = mdev_type_attr_store,
 };
 
+#define MDEV_CREATE_BUF 4096
 static ssize_t create_store(struct kobject *kobj, struct device *dev,
 			    const char *buf, size_t count)
 {
-	char *str;
+	char *str, *param;
 	guid_t uuid;
 	int ret;
+	unsigned int instances = 1;
 
-	if ((count < UUID_STRING_LEN) || (count > UUID_STRING_LEN + 1))
+	if (count < UUID_STRING_LEN)
 		return -EINVAL;
+	if (count > MDEV_CREATE_BUF - 1)
+		return -E2BIG;
 
-	str = kstrndup(buf, count, GFP_KERNEL);
+	if ((param = strnchr(buf, count, ',')) == NULL) {
+		if (count > UUID_STRING_LEN + 1)
+			return -EINVAL;
+	} else if (param - buf != UUID_STRING_LEN)
+		return -EINVAL;
+
+	str = kstrndup(buf, UUID_STRING_LEN, GFP_KERNEL);
 	if (!str)
 		return -ENOMEM;
 
@@ -67,7 +77,16 @@ static ssize_t create_store(struct kobject *kobj, struct device *dev,
 	if (ret)
 		return ret;
 
-	ret = mdev_device_create(kobj, dev, &uuid);
+	if (param) {
+		param++;
+		if (strncmp(param, "aggregate=", 10))
+			return -EINVAL;
+		param += 10;
+		if (kstrtouint(param, 0, &instances))
+			return -EINVAL;
+	}
+
+	ret = mdev_device_create(kobj, dev, &uuid, instances);
 	if (ret)
 		return ret;
 
diff --git a/include/linux/mdev.h b/include/linux/mdev.h
index 0ce30ca78db0..0dbb7ec27009 100644
--- a/include/linux/mdev.h
+++ b/include/linux/mdev.h
@@ -42,6 +42,14 @@ struct device *mdev_get_iommu_device(struct device *dev);
  *			@mdev: mdev_device structure on of mediated device
  *			      that is being created
  *			Returns integer: success (0) or error (< 0)
+ * @create_with_instances: Allocate aggregated instances' resources in parent device's
+ *			driver for a particular mediated device. Optional if aggregated
+ *                      resources are not supported.
+ *			@kobj: kobject of type for which 'create' is called.
+ *			@mdev: mdev_device structure of mediated device
+ *			      that is being created
+ *                      @instances: number of instances to aggregate
+ *			Returns integer: success (0) or error (< 0)
  * @remove:		Called to free resources in parent device's driver for a
  *			a mediated device. It is mandatory to provide 'remove'
  *			ops.
@@ -82,6 +90,9 @@ struct mdev_parent_ops {
 	struct attribute_group **supported_type_groups;
 
 	int     (*create)(struct kobject *kobj, struct mdev_device *mdev);
+	int     (*create_with_instances)(struct kobject *kobj,
+					 struct mdev_device *mdev,
+					 unsigned int instances);
 	int     (*remove)(struct mdev_device *mdev);
 	int     (*open)(struct mdev_device *mdev);
 	void    (*release)(struct mdev_device *mdev);
-- 
2.24.0.rc0

