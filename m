Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1123EE29C4
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2019 07:08:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437465AbfJXFIj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Oct 2019 01:08:39 -0400
Received: from mga11.intel.com ([192.55.52.93]:7748 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437452AbfJXFIi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Oct 2019 01:08:38 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Oct 2019 22:08:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,223,1569308400"; 
   d="scan'208";a="197627651"
Received: from debian-nuc.sh.intel.com ([10.239.160.133])
  by fmsmga007.fm.intel.com with ESMTP; 23 Oct 2019 22:08:37 -0700
From:   Zhenyu Wang <zhenyuw@linux.intel.com>
To:     kvm@vger.kernel.org
Cc:     alex.williamson@redhat.com, kwankhede@nvidia.com,
        kevin.tian@intel.com, cohuck@redhat.com
Subject: [PATCH 3/6] vfio/mdev: Add "aggregated_instances" attribute for supported mdev device
Date:   Thu, 24 Oct 2019 13:08:26 +0800
Message-Id: <20191024050829.4517-4-zhenyuw@linux.intel.com>
X-Mailer: git-send-email 2.24.0.rc0
In-Reply-To: <20191024050829.4517-1-zhenyuw@linux.intel.com>
References: <20191024050829.4517-1-zhenyuw@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For mdev device created by "aggregate" parameter, this creates new mdev
device attribute "aggregated_instances" to show number of aggregated
instances allocated.

Cc: Kirti Wankhede <kwankhede@nvidia.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Cornelia Huck <cohuck@redhat.com>
Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
---
v2:
- change attribute name as "aggregated_instances"
v3:
- create only for aggregated allocation
v4:
- fix remove

 drivers/vfio/mdev/mdev_sysfs.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/drivers/vfio/mdev/mdev_sysfs.c b/drivers/vfio/mdev/mdev_sysfs.c
index acd3ec2900b5..f131480a767a 100644
--- a/drivers/vfio/mdev/mdev_sysfs.c
+++ b/drivers/vfio/mdev/mdev_sysfs.c
@@ -289,6 +289,17 @@ static ssize_t remove_store(struct device *dev, struct device_attribute *attr,
 
 static DEVICE_ATTR_WO(remove);
 
+static ssize_t
+aggregated_instances_show(struct device *dev,
+			  struct device_attribute *attr,
+			  char *buf)
+{
+	struct mdev_device *mdev = to_mdev_device(dev);
+	return sprintf(buf, "%u\n", mdev->type_instances);
+}
+
+static DEVICE_ATTR_RO(aggregated_instances);
+
 static const struct attribute *mdev_device_attrs[] = {
 	&dev_attr_remove.attr,
 	NULL,
@@ -296,6 +307,7 @@ static const struct attribute *mdev_device_attrs[] = {
 
 int  mdev_create_sysfs_files(struct device *dev, struct mdev_type *type)
 {
+	struct mdev_device *mdev = to_mdev_device(dev);
 	int ret;
 
 	ret = sysfs_create_link(type->devices_kobj, &dev->kobj, dev_name(dev));
@@ -310,8 +322,17 @@ int  mdev_create_sysfs_files(struct device *dev, struct mdev_type *type)
 	if (ret)
 		goto create_files_failed;
 
+	if (mdev->type_instances > 1) {
+		ret = sysfs_create_file(&dev->kobj,
+					&dev_attr_aggregated_instances.attr);
+		if (ret)
+			goto create_aggregated_failed;
+	}
+
 	return ret;
 
+create_aggregated_failed:
+	sysfs_remove_files(&dev->kobj, mdev_device_attrs);
 create_files_failed:
 	sysfs_remove_link(&dev->kobj, "mdev_type");
 type_link_failed:
@@ -321,6 +342,10 @@ int  mdev_create_sysfs_files(struct device *dev, struct mdev_type *type)
 
 void mdev_remove_sysfs_files(struct device *dev, struct mdev_type *type)
 {
+	struct mdev_device *mdev = to_mdev_device(dev);
+	if (mdev->type_instances > 1)
+		sysfs_remove_file(&dev->kobj,
+				  &dev_attr_aggregated_instances.attr);
 	sysfs_remove_files(&dev->kobj, mdev_device_attrs);
 	sysfs_remove_link(&dev->kobj, "mdev_type");
 	sysfs_remove_link(type->devices_kobj, dev_name(dev));
-- 
2.24.0.rc0

