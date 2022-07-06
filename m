Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5D41568051
	for <lists+kvm@lfdr.de>; Wed,  6 Jul 2022 09:43:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231812AbiGFHnJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jul 2022 03:43:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231799AbiGFHnF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jul 2022 03:43:05 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 976CB22BF9;
        Wed,  6 Jul 2022 00:42:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=lVagAPfoO63wEbACNG75sCLHp24V9bLZUutprN8OT0M=; b=ZHosj2M29POvalYNiZfyk/8NPj
        szKpZPy2rpi9Oah703mEsP57yerfl035Rxi8JHhkVHNpAQn+VvV9iqXOQbnpvWDMh72SGouGWVaem
        6aLOpCDCRXL9LIVqbj3yrDtk1myn7VW6+A0Aq28KcUtcFb+MNfl78FBL2Wc41Z6cRbjQGjWsPAnjv
        YJ3+Y1iYJn+aUY01hnymJXQctqtVDTSREZtGEVJU1fcE1G10bpTTz3g2l/C5x+kPZjOTlXumZg4LG
        i/vIbB7DRFvFRrXmdwB/MyNF8fHkWxaRH+JGpFUNQuVZe3eVTBDpkH+7YctsShZTvm02MJjkgSBMZ
        teNct+9A==;
Received: from [2001:4bb8:189:3c4a:34cd:2d1d:8766:aad] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o8zgU-0079uQ-AN; Wed, 06 Jul 2022 07:42:54 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Kirti Wankhede <kwankhede@nvidia.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, intel-gvt-dev@lists.freedesktop.org,
        Kevin Tian <kevin.tian@intel.com>
Subject: [PATCH 10/15] vfio/mdev: consolidate all the device_api sysfs into the core code
Date:   Wed,  6 Jul 2022 09:42:14 +0200
Message-Id: <20220706074219.3614-11-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220706074219.3614-1-hch@lst.de>
References: <20220706074219.3614-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Every driver just emits a static string, simply feed it through the ops
and provide a standard sysfs show function.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Kirti Wankhede <kwankhede@nvidia.com>
---
 .../driver-api/vfio-mediated-device.rst       |  2 +-
 drivers/gpu/drm/i915/gvt/kvmgt.c              |  9 +----
 drivers/s390/cio/vfio_ccw_ops.c               |  9 +----
 drivers/s390/crypto/vfio_ap_ops.c             | 10 +-----
 drivers/vfio/mdev/mdev_driver.c               |  4 ++-
 drivers/vfio/mdev/mdev_sysfs.c                | 35 +++++++++++++------
 include/linux/mdev.h                          |  7 ++--
 samples/vfio-mdev/mbochs.c                    |  9 +----
 samples/vfio-mdev/mdpy.c                      |  9 +----
 samples/vfio-mdev/mtty.c                      | 10 +-----
 10 files changed, 37 insertions(+), 67 deletions(-)

diff --git a/Documentation/driver-api/vfio-mediated-device.rst b/Documentation/driver-api/vfio-mediated-device.rst
index a4c3a4a168ec6..c30cb1092bdfb 100644
--- a/Documentation/driver-api/vfio-mediated-device.rst
+++ b/Documentation/driver-api/vfio-mediated-device.rst
@@ -204,7 +204,7 @@ Directories and files under the sysfs for Each Physical Device
 
 * device_api
 
-  This attribute should show which device API is being created, for example,
+  This attribute shows which device API is being created, for example,
   "vfio-pci" for a PCI device.
 
 * available_instances
diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
index 3473d4bafd61e..a70610929fed2 100644
--- a/drivers/gpu/drm/i915/gvt/kvmgt.c
+++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
@@ -123,12 +123,6 @@ static ssize_t available_instances_show(struct mdev_type *mtype,
 	return sprintf(buf, "%u\n", type->avail_instance);
 }
 
-static ssize_t device_api_show(struct mdev_type *mtype,
-			       struct mdev_type_attribute *attr, char *buf)
-{
-	return sprintf(buf, "%s\n", VFIO_DEVICE_API_PCI_STRING);
-}
-
 static ssize_t description_show(struct mdev_type *mtype,
 				struct mdev_type_attribute *attr, char *buf)
 {
@@ -151,13 +145,11 @@ static ssize_t name_show(struct mdev_type *mtype,
 }
 
 static MDEV_TYPE_ATTR_RO(available_instances);
-static MDEV_TYPE_ATTR_RO(device_api);
 static MDEV_TYPE_ATTR_RO(description);
 static MDEV_TYPE_ATTR_RO(name);
 
 static const struct attribute *gvt_type_attrs[] = {
 	&mdev_type_attr_available_instances.attr,
-	&mdev_type_attr_device_api.attr,
 	&mdev_type_attr_description.attr,
 	&mdev_type_attr_name.attr,
 	NULL,
@@ -1587,6 +1579,7 @@ static void intel_vgpu_remove(struct mdev_device *mdev)
 }
 
 static struct mdev_driver intel_vgpu_mdev_driver = {
+	.device_api	= VFIO_DEVICE_API_PCI_STRING,
 	.driver = {
 		.name		= "intel_vgpu_mdev",
 		.owner		= THIS_MODULE,
diff --git a/drivers/s390/cio/vfio_ccw_ops.c b/drivers/s390/cio/vfio_ccw_ops.c
index fb62049471ee2..74ff2d9719d02 100644
--- a/drivers/s390/cio/vfio_ccw_ops.c
+++ b/drivers/s390/cio/vfio_ccw_ops.c
@@ -77,13 +77,6 @@ static ssize_t name_show(struct mdev_type *mtype,
 }
 static MDEV_TYPE_ATTR_RO(name);
 
-static ssize_t device_api_show(struct mdev_type *mtype,
-			       struct mdev_type_attribute *attr, char *buf)
-{
-	return sprintf(buf, "%s\n", VFIO_DEVICE_API_CCW_STRING);
-}
-static MDEV_TYPE_ATTR_RO(device_api);
-
 static ssize_t available_instances_show(struct mdev_type *mtype,
 					struct mdev_type_attribute *attr,
 					char *buf)
@@ -96,7 +89,6 @@ static MDEV_TYPE_ATTR_RO(available_instances);
 
 static const struct attribute *mdev_types_attrs[] = {
 	&mdev_type_attr_name.attr,
-	&mdev_type_attr_device_api.attr,
 	&mdev_type_attr_available_instances.attr,
 	NULL,
 };
@@ -636,6 +628,7 @@ static const struct vfio_device_ops vfio_ccw_dev_ops = {
 };
 
 struct mdev_driver vfio_ccw_mdev_driver = {
+	.device_api = VFIO_DEVICE_API_CCW_STRING,
 	.driver = {
 		.name = "vfio_ccw_mdev",
 		.owner = THIS_MODULE,
diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 41e8ecb7f56b9..023b659c812c9 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -529,17 +529,8 @@ static ssize_t available_instances_show(struct mdev_type *mtype,
 
 static MDEV_TYPE_ATTR_RO(available_instances);
 
-static ssize_t device_api_show(struct mdev_type *mtype,
-			       struct mdev_type_attribute *attr, char *buf)
-{
-	return sprintf(buf, "%s\n", VFIO_DEVICE_API_AP_STRING);
-}
-
-static MDEV_TYPE_ATTR_RO(device_api);
-
 static const struct attribute *vfio_ap_mdev_type_attrs[] = {
 	&mdev_type_attr_name.attr,
-	&mdev_type_attr_device_api.attr,
 	&mdev_type_attr_available_instances.attr,
 	NULL,
 };
@@ -1454,6 +1445,7 @@ static const struct vfio_device_ops vfio_ap_matrix_dev_ops = {
 };
 
 static struct mdev_driver vfio_ap_matrix_driver = {
+	.device_api = VFIO_DEVICE_API_AP_STRING,
 	.driver = {
 		.name = "vfio_ap_mdev",
 		.owner = THIS_MODULE,
diff --git a/drivers/vfio/mdev/mdev_driver.c b/drivers/vfio/mdev/mdev_driver.c
index 5b3c94f4fb13d..60e8b9f6474e8 100644
--- a/drivers/vfio/mdev/mdev_driver.c
+++ b/drivers/vfio/mdev/mdev_driver.c
@@ -55,8 +55,10 @@ struct bus_type mdev_bus_type = {
  **/
 int mdev_register_driver(struct mdev_driver *drv)
 {
-	if (!drv->types_attrs)
+	if (!drv->types_attrs || !drv->device_api)
 		return -EINVAL;
+
+	/* initialize common driver fields */
 	drv->driver.bus = &mdev_bus_type;
 	return driver_register(&drv->driver);
 }
diff --git a/drivers/vfio/mdev/mdev_sysfs.c b/drivers/vfio/mdev/mdev_sysfs.c
index 80b2d546a3d98..89637bc85462a 100644
--- a/drivers/vfio/mdev/mdev_sysfs.c
+++ b/drivers/vfio/mdev/mdev_sysfs.c
@@ -72,9 +72,30 @@ static ssize_t create_store(struct mdev_type *mtype,
 
 	return count;
 }
-
 static MDEV_TYPE_ATTR_WO(create);
 
+static ssize_t device_api_show(struct mdev_type *mtype,
+			       struct mdev_type_attribute *attr, char *buf)
+{
+	return sysfs_emit(buf, "%s\n", mtype->parent->mdev_driver->device_api);
+}
+static MDEV_TYPE_ATTR_RO(device_api);
+
+static struct attribute *mdev_types_core_attrs[] = {
+	&mdev_type_attr_create.attr,
+	&mdev_type_attr_device_api.attr,
+	NULL,
+};
+
+static struct attribute_group mdev_type_core_group = {
+	.attrs = mdev_types_core_attrs,
+};
+
+static const struct attribute_group *mdev_type_groups[] = {
+	&mdev_type_core_group,
+	NULL,
+};
+
 static void mdev_type_release(struct kobject *kobj)
 {
 	struct mdev_type *type = to_mdev_type(kobj);
@@ -86,8 +107,9 @@ static void mdev_type_release(struct kobject *kobj)
 }
 
 static struct kobj_type mdev_type_ktype = {
-	.sysfs_ops = &mdev_type_sysfs_ops,
-	.release = mdev_type_release,
+	.sysfs_ops	= &mdev_type_sysfs_ops,
+	.release	= mdev_type_release,
+	.default_groups	= mdev_type_groups,
 };
 
 static int mdev_type_add(struct mdev_parent *parent, struct mdev_type *type)
@@ -107,10 +129,6 @@ static int mdev_type_add(struct mdev_parent *parent, struct mdev_type *type)
 		return ret;
 	}
 
-	ret = sysfs_create_file(&type->kobj, &mdev_type_attr_create.attr);
-	if (ret)
-		goto attr_create_failed;
-
 	type->devices_kobj = kobject_create_and_add("devices", &type->kobj);
 	if (!type->devices_kobj) {
 		ret = -ENOMEM;
@@ -125,8 +143,6 @@ static int mdev_type_add(struct mdev_parent *parent, struct mdev_type *type)
 attrs_failed:
 	kobject_put(type->devices_kobj);
 attr_devices_failed:
-	sysfs_remove_file(&type->kobj, &mdev_type_attr_create.attr);
-attr_create_failed:
 	kobject_del(&type->kobj);
 	kobject_put(&type->kobj);
 	return ret;
@@ -137,7 +153,6 @@ static void mdev_type_remove(struct mdev_type *type)
 	sysfs_remove_files(&type->kobj, type->parent->mdev_driver->types_attrs);
 
 	kobject_put(type->devices_kobj);
-	sysfs_remove_file(&type->kobj, &mdev_type_attr_create.attr);
 	kobject_del(&type->kobj);
 	kobject_put(&type->kobj);
 }
diff --git a/include/linux/mdev.h b/include/linux/mdev.h
index 29fc1c853dacc..51a6f2ddcf9c6 100644
--- a/include/linux/mdev.h
+++ b/include/linux/mdev.h
@@ -61,11 +61,6 @@ struct mdev_type_attribute {
 			 size_t count);
 };
 
-#define MDEV_TYPE_ATTR(_name, _mode, _show, _store)		\
-struct mdev_type_attribute mdev_type_attr_##_name =		\
-	__ATTR(_name, _mode, _show, _store)
-#define MDEV_TYPE_ATTR_RW(_name) \
-	struct mdev_type_attribute mdev_type_attr_##_name = __ATTR_RW(_name)
 #define MDEV_TYPE_ATTR_RO(_name) \
 	struct mdev_type_attribute mdev_type_attr_##_name = __ATTR_RO(_name)
 #define MDEV_TYPE_ATTR_WO(_name) \
@@ -73,12 +68,14 @@ struct mdev_type_attribute mdev_type_attr_##_name =		\
 
 /**
  * struct mdev_driver - Mediated device driver
+ * @device_api: string to return for the device_api sysfs
  * @probe: called when new device created
  * @remove: called when device removed
  * @types_attrs: attributes to the type kobjects.
  * @driver: device driver structure
  **/
 struct mdev_driver {
+	const char *device_api;
 	int (*probe)(struct mdev_device *dev);
 	void (*remove)(struct mdev_device *dev);
 	const struct attribute * const *types_attrs;
diff --git a/samples/vfio-mdev/mbochs.c b/samples/vfio-mdev/mbochs.c
index 1069f561cb012..199846f01de92 100644
--- a/samples/vfio-mdev/mbochs.c
+++ b/samples/vfio-mdev/mbochs.c
@@ -1367,17 +1367,9 @@ static ssize_t available_instances_show(struct mdev_type *mtype,
 }
 static MDEV_TYPE_ATTR_RO(available_instances);
 
-static ssize_t device_api_show(struct mdev_type *mtype,
-			       struct mdev_type_attribute *attr, char *buf)
-{
-	return sprintf(buf, "%s\n", VFIO_DEVICE_API_PCI_STRING);
-}
-static MDEV_TYPE_ATTR_RO(device_api);
-
 static const struct attribute *mdev_types_attrs[] = {
 	&mdev_type_attr_name.attr,
 	&mdev_type_attr_description.attr,
-	&mdev_type_attr_device_api.attr,
 	&mdev_type_attr_available_instances.attr,
 	NULL,
 };
@@ -1391,6 +1383,7 @@ static const struct vfio_device_ops mbochs_dev_ops = {
 };
 
 static struct mdev_driver mbochs_driver = {
+	.device_api = VFIO_DEVICE_API_PCI_STRING,
 	.driver = {
 		.name = "mbochs",
 		.owner = THIS_MODULE,
diff --git a/samples/vfio-mdev/mdpy.c b/samples/vfio-mdev/mdpy.c
index 2052cc27b1c6d..b8d6eeff2033d 100644
--- a/samples/vfio-mdev/mdpy.c
+++ b/samples/vfio-mdev/mdpy.c
@@ -678,17 +678,9 @@ static ssize_t available_instances_show(struct mdev_type *mtype,
 }
 static MDEV_TYPE_ATTR_RO(available_instances);
 
-static ssize_t device_api_show(struct mdev_type *mtype,
-			       struct mdev_type_attribute *attr, char *buf)
-{
-	return sprintf(buf, "%s\n", VFIO_DEVICE_API_PCI_STRING);
-}
-static MDEV_TYPE_ATTR_RO(device_api);
-
 static const struct attribute *mdev_types_attrs[] = {
 	&mdev_type_attr_name.attr,
 	&mdev_type_attr_description.attr,
-	&mdev_type_attr_device_api.attr,
 	&mdev_type_attr_available_instances.attr,
 	NULL,
 };
@@ -701,6 +693,7 @@ static const struct vfio_device_ops mdpy_dev_ops = {
 };
 
 static struct mdev_driver mdpy_driver = {
+	.device_api = VFIO_DEVICE_API_PCI_STRING,
 	.driver = {
 		.name = "mdpy",
 		.owner = THIS_MODULE,
diff --git a/samples/vfio-mdev/mtty.c b/samples/vfio-mdev/mtty.c
index 029a19ef8ce7b..2a470424628af 100644
--- a/samples/vfio-mdev/mtty.c
+++ b/samples/vfio-mdev/mtty.c
@@ -1268,17 +1268,8 @@ static ssize_t available_instances_show(struct mdev_type *mtype,
 
 static MDEV_TYPE_ATTR_RO(available_instances);
 
-static ssize_t device_api_show(struct mdev_type *mtype,
-			       struct mdev_type_attribute *attr, char *buf)
-{
-	return sprintf(buf, "%s\n", VFIO_DEVICE_API_PCI_STRING);
-}
-
-static MDEV_TYPE_ATTR_RO(device_api);
-
 static const struct attribute *mdev_types_attrs[] = {
 	&mdev_type_attr_name.attr,
-	&mdev_type_attr_device_api.attr,
 	&mdev_type_attr_available_instances.attr,
 	NULL,
 };
@@ -1291,6 +1282,7 @@ static const struct vfio_device_ops mtty_dev_ops = {
 };
 
 static struct mdev_driver mtty_driver = {
+	.device_api = VFIO_DEVICE_API_PCI_STRING,
 	.driver = {
 		.name = "mtty",
 		.owner = THIS_MODULE,
-- 
2.30.2

