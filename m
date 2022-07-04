Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCFC656560A
	for <lists+kvm@lfdr.de>; Mon,  4 Jul 2022 14:53:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234588AbiGDMwz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Jul 2022 08:52:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234694AbiGDMwn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Jul 2022 08:52:43 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A63481209C;
        Mon,  4 Jul 2022 05:52:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=+NMk+1+nXmBkAxtB8wl4mdh4yDuZ+5SARjB27vJ2B+M=; b=t5fac5OryFWiG2ASGrhOsbshfd
        cGULG/rFEEOycOeRFXCLr0+JwwCL+idUnx7OOAhpCwUuosNNPQXCtPv+IO4KOUBomFjNlpeO6ldwP
        MKbSApX9/n5VQwye9qMJpejFMnibiDbQfYhXWlGZ31HVRRCG3DRlapSkpCSH9IHGHcsBWNFNqZRDy
        ijoTO/gbpxEo6ipNBw02Hta2t13mz/D8G0UKHMGG9tgAARy+CH8VSVlbVmhiFY+utjxJn77uYKmGE
        zGQiHjENTFz0Bgfkyg4RPeRPgj+ay5pgBSzR83GdLvmPkH1OIQIXcsLf41+gUSvvfQecPl+DtN4nn
        KBaxjn7w==;
Received: from [2001:4bb8:189:3c4a:8758:74d9:4df6:6417] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o8LYv-008wiI-7M; Mon, 04 Jul 2022 12:52:25 +0000
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
Subject: [PATCH 13/14] vfio/mdev: consolidate all the description sysfs into the core code
Date:   Mon,  4 Jul 2022 14:51:43 +0200
Message-Id: <20220704125144.157288-14-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220704125144.157288-1-hch@lst.de>
References: <20220704125144.157288-1-hch@lst.de>
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

Every driver just emits a string, simply add a method to the mdev_driver
to return it and provide a standard sysfs show function.

Remove the now unused types_attrs field in struct mdev_driver and the
support code for it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Kirti Wankhede <kwankhede@nvidia.com>
---
 .../driver-api/vfio-mediated-device.rst       |  4 +-
 drivers/gpu/drm/i915/gvt/kvmgt.c              | 18 +++------
 drivers/vfio/mdev/mdev_driver.c               |  2 +-
 drivers/vfio/mdev/mdev_sysfs.c                | 40 +++++++++++++++----
 include/linux/mdev.h                          | 19 +--------
 samples/vfio-mdev/mbochs.c                    | 11 +----
 samples/vfio-mdev/mdpy.c                      | 11 +----
 7 files changed, 46 insertions(+), 59 deletions(-)

diff --git a/Documentation/driver-api/vfio-mediated-device.rst b/Documentation/driver-api/vfio-mediated-device.rst
index 1e19ba588a34f..4f1b9ec6e0ccb 100644
--- a/Documentation/driver-api/vfio-mediated-device.rst
+++ b/Documentation/driver-api/vfio-mediated-device.rst
@@ -106,7 +106,7 @@ structure to represent a mediated device's driver::
 	     int  (*probe)  (struct mdev_device *dev);
 	     void (*remove) (struct mdev_device *dev);
 	     unsigned int (*get_available)(struct mdev_type *mtype);
-	     const struct attribute * const *types_attrs;
+	     ssize_t (*show_description)(struct mdev_type *mtype, char *buf);
 	     struct device_driver    driver;
      };
 
@@ -224,7 +224,7 @@ Directories and files under the sysfs for Each Physical Device
 
 * description
 
-  This attribute should show brief features/description of the type. This is
+  This attribute can show brief features/description of the type. This is an
   optional attribute.
 
 Directories and Files Under the sysfs for Each mdev Device
diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
index b523daf048e1f..992a34ec51960 100644
--- a/drivers/gpu/drm/i915/gvt/kvmgt.c
+++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
@@ -113,8 +113,7 @@ static void kvmgt_page_track_flush_slot(struct kvm *kvm,
 		struct kvm_memory_slot *slot,
 		struct kvm_page_track_notifier_node *node);
 
-static ssize_t description_show(struct mdev_type *mtype,
-				struct mdev_type_attribute *attr, char *buf)
+static ssize_t intel_vgpu_show_description(struct mdev_type *mtype, char *buf)
 {
 	struct intel_vgpu_type *type =
 		container_of(mtype, struct intel_vgpu_type, type);
@@ -128,13 +127,6 @@ static ssize_t description_show(struct mdev_type *mtype,
 		       type->conf->weight);
 }
 
-static MDEV_TYPE_ATTR_RO(description);
-
-static const struct attribute *gvt_type_attrs[] = {
-	&mdev_type_attr_description.attr,
-	NULL,
-};
-
 static void gvt_unpin_guest_page(struct intel_vgpu *vgpu, unsigned long gfn,
 		unsigned long size)
 {
@@ -1586,10 +1578,10 @@ static struct mdev_driver intel_vgpu_mdev_driver = {
 		.owner		= THIS_MODULE,
 		.dev_groups	= intel_vgpu_groups,
 	},
-	.probe		= intel_vgpu_probe,
-	.remove		= intel_vgpu_remove,
-	.get_available	= intel_vgpu_get_available,
-	.types_attrs	= gvt_type_attrs,
+	.probe			= intel_vgpu_probe,
+	.remove			= intel_vgpu_remove,
+	.get_available		= intel_vgpu_get_available,
+	.show_description	= intel_vgpu_show_description,
 };
 
 int intel_gvt_page_track_add(struct intel_vgpu *info, u64 gfn)
diff --git a/drivers/vfio/mdev/mdev_driver.c b/drivers/vfio/mdev/mdev_driver.c
index 60e8b9f6474e8..7825d83a55f8c 100644
--- a/drivers/vfio/mdev/mdev_driver.c
+++ b/drivers/vfio/mdev/mdev_driver.c
@@ -55,7 +55,7 @@ struct bus_type mdev_bus_type = {
  **/
 int mdev_register_driver(struct mdev_driver *drv)
 {
-	if (!drv->types_attrs || !drv->device_api)
+	if (!drv->device_api)
 		return -EINVAL;
 
 	/* initialize common driver fields */
diff --git a/drivers/vfio/mdev/mdev_sysfs.c b/drivers/vfio/mdev/mdev_sysfs.c
index 9238d92738d5b..c5cd035d591d0 100644
--- a/drivers/vfio/mdev/mdev_sysfs.c
+++ b/drivers/vfio/mdev/mdev_sysfs.c
@@ -14,7 +14,19 @@
 
 #include "mdev_private.h"
 
-/* Static functions */
+struct mdev_type_attribute {
+	struct attribute attr;
+	ssize_t (*show)(struct mdev_type *mtype,
+			struct mdev_type_attribute *attr, char *buf);
+	ssize_t (*store)(struct mdev_type *mtype,
+			 struct mdev_type_attribute *attr, const char *buf,
+			 size_t count);
+};
+
+#define MDEV_TYPE_ATTR_RO(_name) \
+	struct mdev_type_attribute mdev_type_attr_##_name = __ATTR_RO(_name)
+#define MDEV_TYPE_ATTR_WO(_name) \
+	struct mdev_type_attribute mdev_type_attr_##_name = __ATTR_WO(_name)
 
 static ssize_t mdev_type_attr_show(struct kobject *kobj,
 				     struct attribute *__attr, char *buf)
@@ -100,16 +112,35 @@ static ssize_t available_instances_show(struct mdev_type *mtype,
 }
 static MDEV_TYPE_ATTR_RO(available_instances);
 
+static ssize_t description_show(struct mdev_type *mtype,
+				struct mdev_type_attribute *attr,
+				char *buf)
+{
+	return mtype->parent->mdev_driver->show_description(mtype, buf);
+}
+static MDEV_TYPE_ATTR_RO(description);
+
 static struct attribute *mdev_types_core_attrs[] = {
 	&mdev_type_attr_create.attr,
 	&mdev_type_attr_device_api.attr,
 	&mdev_type_attr_name.attr,
 	&mdev_type_attr_available_instances.attr,
+	&mdev_type_attr_description.attr,
 	NULL,
 };
 
+static umode_t mdev_types_core_is_visible(struct kobject *kobj,
+					  struct attribute *attr, int n)
+{
+	if (attr == &mdev_type_attr_description.attr &&
+	    !to_mdev_type(kobj)->parent->mdev_driver->show_description)
+		return 0;
+	return attr->mode;
+}
+
 static struct attribute_group mdev_type_core_group = {
 	.attrs = mdev_types_core_attrs,
+	.is_visible = mdev_types_core_is_visible,
 };
 
 static const struct attribute_group *mdev_type_groups[] = {
@@ -156,13 +187,8 @@ static int mdev_type_add(struct mdev_parent *parent, struct mdev_type *type)
 		goto attr_devices_failed;
 	}
 
-	ret = sysfs_create_files(&type->kobj, parent->mdev_driver->types_attrs);
-	if (ret)
-		goto attrs_failed;
 	return 0;
 
-attrs_failed:
-	kobject_put(type->devices_kobj);
 attr_devices_failed:
 	kobject_del(&type->kobj);
 	kobject_put(&type->kobj);
@@ -171,8 +197,6 @@ static int mdev_type_add(struct mdev_parent *parent, struct mdev_type *type)
 
 static void mdev_type_remove(struct mdev_type *type)
 {
-	sysfs_remove_files(&type->kobj, type->parent->mdev_driver->types_attrs);
-
 	kobject_put(type->devices_kobj);
 	kobject_del(&type->kobj);
 	kobject_put(&type->kobj);
diff --git a/include/linux/mdev.h b/include/linux/mdev.h
index 68b4a132b1523..dc38ad2b07883 100644
--- a/include/linux/mdev.h
+++ b/include/linux/mdev.h
@@ -52,28 +52,13 @@ static inline struct mdev_device *to_mdev_device(struct device *dev)
 	return container_of(dev, struct mdev_device, dev);
 }
 
-/* interface for exporting mdev supported type attributes */
-struct mdev_type_attribute {
-	struct attribute attr;
-	ssize_t (*show)(struct mdev_type *mtype,
-			struct mdev_type_attribute *attr, char *buf);
-	ssize_t (*store)(struct mdev_type *mtype,
-			 struct mdev_type_attribute *attr, const char *buf,
-			 size_t count);
-};
-
-#define MDEV_TYPE_ATTR_RO(_name) \
-	struct mdev_type_attribute mdev_type_attr_##_name = __ATTR_RO(_name)
-#define MDEV_TYPE_ATTR_WO(_name) \
-	struct mdev_type_attribute mdev_type_attr_##_name = __ATTR_WO(_name)
-
 /**
  * struct mdev_driver - Mediated device driver
  * @device_api: string to return for the device_api sysfs
  * @probe: called when new device created
  * @remove: called when device removed
  * @get_available: Return the max number of instances that can be created
- * @types_attrs: attributes to the type kobjects.
+ * @show_description: Print a description of the mtype
  * @driver: device driver structure
  **/
 struct mdev_driver {
@@ -81,7 +66,7 @@ struct mdev_driver {
 	int (*probe)(struct mdev_device *dev);
 	void (*remove)(struct mdev_device *dev);
 	unsigned int (*get_available)(struct mdev_type *mtype);
-	const struct attribute * const *types_attrs;
+	ssize_t (*show_description)(struct mdev_type *mtype, char *buf);
 	struct device_driver driver;
 };
 
diff --git a/samples/vfio-mdev/mbochs.c b/samples/vfio-mdev/mbochs.c
index e61be7f8a9863..0f9b9cf46f05b 100644
--- a/samples/vfio-mdev/mbochs.c
+++ b/samples/vfio-mdev/mbochs.c
@@ -1333,8 +1333,7 @@ static const struct attribute_group *mdev_dev_groups[] = {
 	NULL,
 };
 
-static ssize_t description_show(struct mdev_type *mtype,
-				struct mdev_type_attribute *attr, char *buf)
+static ssize_t mbochs_show_description(struct mdev_type *mtype, char *buf)
 {
 	struct mbochs_type *type =
 		container_of(mtype, struct mbochs_type, type);
@@ -1342,7 +1341,6 @@ static ssize_t description_show(struct mdev_type *mtype,
 	return sprintf(buf, "virtual display, %d MB video memory\n",
 		       type ? type->mbytes  : 0);
 }
-static MDEV_TYPE_ATTR_RO(description);
 
 static unsigned int mbochs_get_available(struct mdev_type *mtype)
 {
@@ -1352,11 +1350,6 @@ static unsigned int mbochs_get_available(struct mdev_type *mtype)
 	return atomic_read(&mbochs_avail_mbytes) / type->mbytes;
 }
 
-static const struct attribute *mdev_types_attrs[] = {
-	&mdev_type_attr_description.attr,
-	NULL,
-};
-
 static const struct vfio_device_ops mbochs_dev_ops = {
 	.close_device = mbochs_close_device,
 	.read = mbochs_read,
@@ -1376,7 +1369,7 @@ static struct mdev_driver mbochs_driver = {
 	.probe = mbochs_probe,
 	.remove	= mbochs_remove,
 	.get_available = mbochs_get_available,
-	.types_attrs = mdev_types_attrs,
+	.show_description = mbochs_show_description,
 };
 
 static const struct file_operations vd_fops = {
diff --git a/samples/vfio-mdev/mdpy.c b/samples/vfio-mdev/mdpy.c
index 2f59078909c9d..250b7ea2df2e4 100644
--- a/samples/vfio-mdev/mdpy.c
+++ b/samples/vfio-mdev/mdpy.c
@@ -650,26 +650,19 @@ static const struct attribute_group *mdev_dev_groups[] = {
 	NULL,
 };
 
-static ssize_t description_show(struct mdev_type *mtype,
-				struct mdev_type_attribute *attr, char *buf)
+static ssize_t mdpy_show_description(struct mdev_type *mtype, char *buf)
 {
 	struct mdpy_type *type = container_of(mtype, struct mdpy_type, type);
 
 	return sprintf(buf, "virtual display, %dx%d framebuffer\n",
 		       type->width, type->height);
 }
-static MDEV_TYPE_ATTR_RO(description);
 
 static unsigned int mdpy_get_available(struct mdev_type *mtype)
 {
 	return max_devices - mdpy_count;
 }
 
-static const struct attribute *mdev_types_attrs[] = {
-	&mdev_type_attr_description.attr,
-	NULL,
-};
-
 static const struct vfio_device_ops mdpy_dev_ops = {
 	.read = mdpy_read,
 	.write = mdpy_write,
@@ -688,7 +681,7 @@ static struct mdev_driver mdpy_driver = {
 	.probe = mdpy_probe,
 	.remove	= mdpy_remove,
 	.get_available = mdpy_get_available,
-	.types_attrs = mdev_types_attrs,
+	.show_description = mdpy_show_description,
 };
 
 static const struct file_operations vd_fops = {
-- 
2.30.2

