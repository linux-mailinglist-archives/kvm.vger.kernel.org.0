Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96DABE29C3
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2019 07:08:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437460AbfJXFIh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Oct 2019 01:08:37 -0400
Received: from mga11.intel.com ([192.55.52.93]:7748 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437457AbfJXFIh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Oct 2019 01:08:37 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Oct 2019 22:08:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,223,1569308400"; 
   d="scan'208";a="197627645"
Received: from debian-nuc.sh.intel.com ([10.239.160.133])
  by fmsmga007.fm.intel.com with ESMTP; 23 Oct 2019 22:08:35 -0700
From:   Zhenyu Wang <zhenyuw@linux.intel.com>
To:     kvm@vger.kernel.org
Cc:     alex.williamson@redhat.com, kwankhede@nvidia.com,
        kevin.tian@intel.com, cohuck@redhat.com
Subject: [PATCH 2/6] vfio/mdev: Add "aggregation" attribute for supported mdev type
Date:   Thu, 24 Oct 2019 13:08:25 +0800
Message-Id: <20191024050829.4517-3-zhenyuw@linux.intel.com>
X-Mailer: git-send-email 2.24.0.rc0
In-Reply-To: <20191024050829.4517-1-zhenyuw@linux.intel.com>
References: <20191024050829.4517-1-zhenyuw@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For supported mdev driver to create aggregated device, this creates
new "aggregation" attribute for target type, which will show maximum
number of instance resources that can be aggregated.

Cc: Kirti Wankhede <kwankhede@nvidia.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Cornelia Huck <cohuck@redhat.com>
Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
---
 drivers/vfio/mdev/mdev_core.c    | 19 +++++++++++++++++++
 drivers/vfio/mdev/mdev_private.h |  2 ++
 drivers/vfio/mdev/mdev_sysfs.c   | 27 +++++++++++++++++++++++++++
 include/linux/mdev.h             |  8 ++++++++
 4 files changed, 56 insertions(+)

diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
index 4926a99f664d..f8687893bff8 100644
--- a/drivers/vfio/mdev/mdev_core.c
+++ b/drivers/vfio/mdev/mdev_core.c
@@ -131,6 +131,25 @@ static int mdev_device_remove_cb(struct device *dev, void *data)
 	return 0;
 }
 
+int mdev_max_aggregated_instances(struct kobject *kobj, struct device *dev,
+				  unsigned int *m)
+{
+	struct mdev_parent *parent;
+	struct mdev_type *type = to_mdev_type(kobj);
+	int ret;
+
+	parent = mdev_get_parent(type->parent);
+	if (!parent)
+		return -EINVAL;
+
+	if (parent->ops->max_aggregated_instances) {
+		ret = parent->ops->max_aggregated_instances(kobj, dev, m);
+	} else
+		ret = -EINVAL;
+	mdev_put_parent(parent);
+	return ret;
+}
+
 /*
  * mdev_register_device : Register a device
  * @dev: device structure representing parent device.
diff --git a/drivers/vfio/mdev/mdev_private.h b/drivers/vfio/mdev/mdev_private.h
index 56cbe9ea8817..5dcbd00f3a46 100644
--- a/drivers/vfio/mdev/mdev_private.h
+++ b/drivers/vfio/mdev/mdev_private.h
@@ -63,4 +63,6 @@ int  mdev_device_create(struct kobject *kobj,
 			unsigned int instances);
 int  mdev_device_remove(struct device *dev);
 
+int  mdev_max_aggregated_instances(struct kobject *kobj, struct device *dev,
+				   unsigned int *m);
 #endif /* MDEV_PRIVATE_H */
diff --git a/drivers/vfio/mdev/mdev_sysfs.c b/drivers/vfio/mdev/mdev_sysfs.c
index 6c2693dd4022..acd3ec2900b5 100644
--- a/drivers/vfio/mdev/mdev_sysfs.c
+++ b/drivers/vfio/mdev/mdev_sysfs.c
@@ -95,6 +95,18 @@ static ssize_t create_store(struct kobject *kobj, struct device *dev,
 
 MDEV_TYPE_ATTR_WO(create);
 
+static ssize_t
+aggregation_show(struct kobject *kobj, struct device *dev, char *buf)
+{
+	unsigned int m;
+
+	if (mdev_max_aggregated_instances(kobj, dev, &m))
+		return sprintf(buf, "1\n");
+	else
+		return sprintf(buf, "%u\n", m);
+}
+MDEV_TYPE_ATTR_RO(aggregation);
+
 static void mdev_type_release(struct kobject *kobj)
 {
 	struct mdev_type *type = to_mdev_type(kobj);
@@ -137,6 +149,14 @@ static struct mdev_type *add_mdev_supported_type(struct mdev_parent *parent,
 	if (ret)
 		goto attr_create_failed;
 
+	if (parent->ops->create_with_instances &&
+	    parent->ops->max_aggregated_instances) {
+		ret = sysfs_create_file(&type->kobj,
+					&mdev_type_attr_aggregation.attr);
+		if (ret)
+			goto attr_aggregate_failed;
+	}
+
 	type->devices_kobj = kobject_create_and_add("devices", &type->kobj);
 	if (!type->devices_kobj) {
 		ret = -ENOMEM;
@@ -157,6 +177,8 @@ static struct mdev_type *add_mdev_supported_type(struct mdev_parent *parent,
 attrs_failed:
 	kobject_put(type->devices_kobj);
 attr_devices_failed:
+	sysfs_remove_file(&type->kobj, &mdev_type_attr_aggregation.attr);
+attr_aggregate_failed:
 	sysfs_remove_file(&type->kobj, &mdev_type_attr_create.attr);
 attr_create_failed:
 	kobject_del(&type->kobj);
@@ -166,9 +188,14 @@ static struct mdev_type *add_mdev_supported_type(struct mdev_parent *parent,
 
 static void remove_mdev_supported_type(struct mdev_type *type)
 {
+	struct mdev_parent *parent = type->parent;
+
 	sysfs_remove_files(&type->kobj,
 			   (const struct attribute **)type->group->attrs);
 	kobject_put(type->devices_kobj);
+	if (parent->ops->create_with_instances &&
+	    parent->ops->max_aggregated_instances)
+		sysfs_remove_file(&type->kobj, &mdev_type_attr_aggregation.attr);
 	sysfs_remove_file(&type->kobj, &mdev_type_attr_create.attr);
 	kobject_del(&type->kobj);
 	kobject_put(&type->kobj);
diff --git a/include/linux/mdev.h b/include/linux/mdev.h
index 0dbb7ec27009..6808f24286dc 100644
--- a/include/linux/mdev.h
+++ b/include/linux/mdev.h
@@ -50,6 +50,11 @@ struct device *mdev_get_iommu_device(struct device *dev);
  *			      that is being created
  *                      @instances: number of instances to aggregate
  *			Returns integer: success (0) or error (< 0)
+ * @max_aggregated_instances: Return max number for aggregated resources
+ *			@kobj: kobject of type
+ *                      @dev: mdev parent device for target type
+ *                      @max: return max number of instances which can be aggregated
+ *			Returns integer: success (0) or error (< 0)
  * @remove:		Called to free resources in parent device's driver for a
  *			a mediated device. It is mandatory to provide 'remove'
  *			ops.
@@ -93,6 +98,9 @@ struct mdev_parent_ops {
 	int     (*create_with_instances)(struct kobject *kobj,
 					 struct mdev_device *mdev,
 					 unsigned int instances);
+	int     (*max_aggregated_instances)(struct kobject *kobj,
+					    struct device *dev,
+					    unsigned int *max);
 	int     (*remove)(struct mdev_device *mdev);
 	int     (*open)(struct mdev_device *mdev);
 	void    (*release)(struct mdev_device *mdev);
-- 
2.24.0.rc0

