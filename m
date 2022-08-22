Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A71D359B941
	for <lists+kvm@lfdr.de>; Mon, 22 Aug 2022 08:22:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232927AbiHVGWv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Aug 2022 02:22:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231415AbiHVGWs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Aug 2022 02:22:48 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A46B426AED;
        Sun, 21 Aug 2022 23:22:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=z4hA749ygwrE/um9RFH7Ot84HFZXnCqamhyKsVFjXz0=; b=wmPQGFRNPKvJ7debiiYhECBpfM
        PIkw2usKTXMsdJ6Ry9y07emMZUnJxl8Qtnx72mZyi2zI3V1C/qmaWYY69oE/k0mLc2n+rfddHGOUI
        i+uZccV8pNkEqvkHomwk5aVPdfPFGlmg9JB6fkFFmODEFk1mLfkSgv6vs+voZCg10gKRGof7XiSvF
        A2xNQfe9JbWJIMdwjTr6mOieyIZ6WI2F3hIvzm9f1CiCW7v/QOwP160yBjNaq9iDZvFtGsJeeCbZ+
        NBiQVl9Vg6OlC8W0fx+S1kzOo/FGhwVZaR/qYwbCYwhogqe/cucQ4UYE8IwMAkqY4ojtDENGMLgkh
        wI3xno4w==;
Received: from [2001:4bb8:198:6528:7eb3:3a42:932d:eeba] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oQ0pg-005Ndk-0e; Mon, 22 Aug 2022 06:22:44 +0000
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
Subject: [PATCH 11/14] vfio/mdev: consolidate all the name sysfs into the core code
Date:   Mon, 22 Aug 2022 08:22:05 +0200
Message-Id: <20220822062208.152745-12-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220822062208.152745-1-hch@lst.de>
References: <20220822062208.152745-1-hch@lst.de>
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

Every driver just emits a static string, simply add a field to the
mdev_type for the driver to fill out or fall back to the sysfs name and
provide a standard sysfs show function.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Kirti Wankhede <kwankhede@nvidia.com>
---
 .../driver-api/vfio-mediated-device.rst       |  2 +-
 drivers/gpu/drm/i915/gvt/kvmgt.c              |  8 -------
 drivers/s390/cio/vfio_ccw_drv.c               |  1 +
 drivers/s390/cio/vfio_ccw_ops.c               |  8 -------
 drivers/s390/crypto/vfio_ap_ops.c             |  9 --------
 drivers/vfio/mdev/mdev_sysfs.c                | 10 +++++++++
 include/linux/mdev.h                          |  1 +
 samples/vfio-mdev/mbochs.c                    | 20 ++++--------------
 samples/vfio-mdev/mdpy.c                      | 21 +++++--------------
 samples/vfio-mdev/mtty.c                      | 18 ++++------------
 10 files changed, 26 insertions(+), 72 deletions(-)

diff --git a/Documentation/driver-api/vfio-mediated-device.rst b/Documentation/driver-api/vfio-mediated-device.rst
index b0c29e37f61b4..dcd1231a6fa84 100644
--- a/Documentation/driver-api/vfio-mediated-device.rst
+++ b/Documentation/driver-api/vfio-mediated-device.rst
@@ -217,7 +217,7 @@ Directories and files under the sysfs for Each Physical Device
 
 * name
 
-  This attribute should show human readable name. This is optional attribute.
+  This attribute shows a human readable name.
 
 * description
 
diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
index 1ed99091165a4..e24e72527c9aa 100644
--- a/drivers/gpu/drm/i915/gvt/kvmgt.c
+++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
@@ -138,20 +138,12 @@ static ssize_t description_show(struct mdev_type *mtype,
 		       type->conf->weight);
 }
 
-static ssize_t name_show(struct mdev_type *mtype,
-			 struct mdev_type_attribute *attr, char *buf)
-{
-	return sprintf(buf, "%s\n", mtype->sysfs_name);
-}
-
 static MDEV_TYPE_ATTR_RO(available_instances);
 static MDEV_TYPE_ATTR_RO(description);
-static MDEV_TYPE_ATTR_RO(name);
 
 static const struct attribute *gvt_type_attrs[] = {
 	&mdev_type_attr_available_instances.attr,
 	&mdev_type_attr_description.attr,
-	&mdev_type_attr_name.attr,
 	NULL,
 };
 
diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
index 25a5de08b3902..e5f21c725326b 100644
--- a/drivers/s390/cio/vfio_ccw_drv.c
+++ b/drivers/s390/cio/vfio_ccw_drv.c
@@ -221,6 +221,7 @@ static int vfio_ccw_sch_probe(struct subchannel *sch)
 	dev_set_drvdata(&sch->dev, private);
 
 	private->mdev_type.sysfs_name = "io";
+	private->mdev_type.pretty_name = "I/O subchannel (Non-QDIO)";
 	private->mdev_types[0] = &private->mdev_type;
 	ret = mdev_register_parent(&private->parent, &sch->dev,
 				   &vfio_ccw_mdev_driver,
diff --git a/drivers/s390/cio/vfio_ccw_ops.c b/drivers/s390/cio/vfio_ccw_ops.c
index 9ced2063720e6..854e0aaefc022 100644
--- a/drivers/s390/cio/vfio_ccw_ops.c
+++ b/drivers/s390/cio/vfio_ccw_ops.c
@@ -44,13 +44,6 @@ static void vfio_ccw_dma_unmap(struct vfio_device *vdev, u64 iova, u64 length)
 	vfio_ccw_mdev_reset(private);
 }
 
-static ssize_t name_show(struct mdev_type *mtype,
-			 struct mdev_type_attribute *attr, char *buf)
-{
-	return sprintf(buf, "I/O subchannel (Non-QDIO)\n");
-}
-static MDEV_TYPE_ATTR_RO(name);
-
 static ssize_t available_instances_show(struct mdev_type *mtype,
 					struct mdev_type_attribute *attr,
 					char *buf)
@@ -62,7 +55,6 @@ static ssize_t available_instances_show(struct mdev_type *mtype,
 static MDEV_TYPE_ATTR_RO(available_instances);
 
 static const struct attribute *mdev_types_attrs[] = {
-	&mdev_type_attr_name.attr,
 	&mdev_type_attr_available_instances.attr,
 	NULL,
 };
diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 728a0ada4928f..9dedb0db8ee84 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -784,14 +784,6 @@ static void vfio_ap_mdev_remove(struct mdev_device *mdev)
 	atomic_inc(&matrix_dev->available_instances);
 }
 
-static ssize_t name_show(struct mdev_type *mtype,
-			 struct mdev_type_attribute *attr, char *buf)
-{
-	return sprintf(buf, "%s\n", VFIO_AP_MDEV_NAME_HWVIRT);
-}
-
-static MDEV_TYPE_ATTR_RO(name);
-
 static ssize_t available_instances_show(struct mdev_type *mtype,
 					struct mdev_type_attribute *attr,
 					char *buf)
@@ -803,7 +795,6 @@ static ssize_t available_instances_show(struct mdev_type *mtype,
 static MDEV_TYPE_ATTR_RO(available_instances);
 
 static const struct attribute *vfio_ap_mdev_type_attrs[] = {
-	&mdev_type_attr_name.attr,
 	&mdev_type_attr_available_instances.attr,
 	NULL,
 };
diff --git a/drivers/vfio/mdev/mdev_sysfs.c b/drivers/vfio/mdev/mdev_sysfs.c
index 89637bc85462a..0f3d0bbf36f75 100644
--- a/drivers/vfio/mdev/mdev_sysfs.c
+++ b/drivers/vfio/mdev/mdev_sysfs.c
@@ -81,9 +81,19 @@ static ssize_t device_api_show(struct mdev_type *mtype,
 }
 static MDEV_TYPE_ATTR_RO(device_api);
 
+static ssize_t name_show(struct mdev_type *mtype,
+			 struct mdev_type_attribute *attr, char *buf)
+{
+	return sprintf(buf, "%s\n",
+		mtype->pretty_name ? mtype->pretty_name : mtype->sysfs_name);
+}
+
+static MDEV_TYPE_ATTR_RO(name);
+
 static struct attribute *mdev_types_core_attrs[] = {
 	&mdev_type_attr_create.attr,
 	&mdev_type_attr_device_api.attr,
+	&mdev_type_attr_name.attr,
 	NULL,
 };
 
diff --git a/include/linux/mdev.h b/include/linux/mdev.h
index af1ff0165b8d3..4bb8a58b577b3 100644
--- a/include/linux/mdev.h
+++ b/include/linux/mdev.h
@@ -26,6 +26,7 @@ struct mdev_device {
 struct mdev_type {
 	/* set by the driver before calling mdev_register parent: */
 	const char *sysfs_name;
+	const char *pretty_name;
 
 	/* set by the core, can be used drivers */
 	struct mdev_parent *parent;
diff --git a/samples/vfio-mdev/mbochs.c b/samples/vfio-mdev/mbochs.c
index 199846f01de92..c8271168a96ad 100644
--- a/samples/vfio-mdev/mbochs.c
+++ b/samples/vfio-mdev/mbochs.c
@@ -101,26 +101,25 @@ MODULE_PARM_DESC(mem, "megabytes available to " MBOCHS_NAME " devices");
 
 static struct mbochs_type {
 	struct mdev_type type;
-	const char *name;
 	u32 mbytes;
 	u32 max_x;
 	u32 max_y;
 } mbochs_types[] = {
 	{
 		.type.sysfs_name	= MBOCHS_TYPE_1,
-		.name	= MBOCHS_CLASS_NAME "-" MBOCHS_TYPE_1,
+		.type.pretty_name	= MBOCHS_CLASS_NAME "-" MBOCHS_TYPE_1,
 		.mbytes = 4,
 		.max_x  = 800,
 		.max_y  = 600,
 	}, {
 		.type.sysfs_name	= MBOCHS_TYPE_2,
-		.name	= MBOCHS_CLASS_NAME "-" MBOCHS_TYPE_2,
+		.type.pretty_name	= MBOCHS_CLASS_NAME "-" MBOCHS_TYPE_2,
 		.mbytes = 16,
 		.max_x  = 1920,
 		.max_y  = 1440,
 	}, {
 		.type.sysfs_name	= MBOCHS_TYPE_3,
-		.name	= MBOCHS_CLASS_NAME "-" MBOCHS_TYPE_3,
+		.type.pretty_name	= MBOCHS_CLASS_NAME "-" MBOCHS_TYPE_3,
 		.mbytes = 64,
 		.max_x  = 0,
 		.max_y  = 0,
@@ -547,7 +546,7 @@ static int mbochs_probe(struct mdev_device *mdev)
 		goto err_mem;
 
 	dev_info(dev, "%s: %s, %d MB, %ld pages\n", __func__,
-		 type->name, type->mbytes, mdev_state->pagecount);
+		 type->type.pretty_name, type->mbytes, mdev_state->pagecount);
 
 	mutex_init(&mdev_state->ops_lock);
 	mdev_state->mdev = mdev;
@@ -1334,16 +1333,6 @@ static const struct attribute_group *mdev_dev_groups[] = {
 	NULL,
 };
 
-static ssize_t name_show(struct mdev_type *mtype,
-			 struct mdev_type_attribute *attr, char *buf)
-{
-	struct mbochs_type *type =
-		container_of(mtype, struct mbochs_type, type);
-
-	return sprintf(buf, "%s\n", type->name);
-}
-static MDEV_TYPE_ATTR_RO(name);
-
 static ssize_t description_show(struct mdev_type *mtype,
 				struct mdev_type_attribute *attr, char *buf)
 {
@@ -1368,7 +1357,6 @@ static ssize_t available_instances_show(struct mdev_type *mtype,
 static MDEV_TYPE_ATTR_RO(available_instances);
 
 static const struct attribute *mdev_types_attrs[] = {
-	&mdev_type_attr_name.attr,
 	&mdev_type_attr_description.attr,
 	&mdev_type_attr_available_instances.attr,
 	NULL,
diff --git a/samples/vfio-mdev/mdpy.c b/samples/vfio-mdev/mdpy.c
index b8d6eeff2033d..6091c642ee102 100644
--- a/samples/vfio-mdev/mdpy.c
+++ b/samples/vfio-mdev/mdpy.c
@@ -53,7 +53,6 @@ MODULE_PARM_DESC(count, "number of " MDPY_NAME " devices");
 
 static struct mdpy_type {
 	struct mdev_type type;
-	const char *name;
 	u32 format;
 	u32 bytepp;
 	u32 width;
@@ -61,21 +60,21 @@ static struct mdpy_type {
 } mdpy_types[] = {
 	{
 		.type.sysfs_name 	= MDPY_TYPE_1,
-		.name	= MDPY_CLASS_NAME "-" MDPY_TYPE_1,
+		.type.pretty_name	= MDPY_CLASS_NAME "-" MDPY_TYPE_1,
 		.format = DRM_FORMAT_XRGB8888,
 		.bytepp = 4,
 		.width	= 640,
 		.height = 480,
 	}, {
 		.type.sysfs_name 	= MDPY_TYPE_2,
-		.name	= MDPY_CLASS_NAME "-" MDPY_TYPE_2,
+		.type.pretty_name	= MDPY_CLASS_NAME "-" MDPY_TYPE_2,
 		.format = DRM_FORMAT_XRGB8888,
 		.bytepp = 4,
 		.width	= 1024,
 		.height = 768,
 	}, {
 		.type.sysfs_name 	= MDPY_TYPE_3,
-		.name	= MDPY_CLASS_NAME "-" MDPY_TYPE_3,
+		.type.pretty_name	= MDPY_CLASS_NAME "-" MDPY_TYPE_3,
 		.format = DRM_FORMAT_XRGB8888,
 		.bytepp = 4,
 		.width	= 1920,
@@ -256,8 +255,8 @@ static int mdpy_probe(struct mdev_device *mdev)
 		ret = -ENOMEM;
 		goto err_vconfig;
 	}
-	dev_info(dev, "%s: %s (%dx%d)\n", __func__, type->name, type->width,
-		 type->height);
+	dev_info(dev, "%s: %s (%dx%d)\n", __func__, type->type.pretty_name,
+		 type->width, type->height);
 
 	mutex_init(&mdev_state->ops_lock);
 	mdev_state->mdev = mdev;
@@ -651,15 +650,6 @@ static const struct attribute_group *mdev_dev_groups[] = {
 	NULL,
 };
 
-static ssize_t name_show(struct mdev_type *mtype,
-			 struct mdev_type_attribute *attr, char *buf)
-{
-	struct mdpy_type *type = container_of(mtype, struct mdpy_type, type);
-
-	return sprintf(buf, "%s\n", type->name);
-}
-static MDEV_TYPE_ATTR_RO(name);
-
 static ssize_t description_show(struct mdev_type *mtype,
 				struct mdev_type_attribute *attr, char *buf)
 {
@@ -679,7 +669,6 @@ static ssize_t available_instances_show(struct mdev_type *mtype,
 static MDEV_TYPE_ATTR_RO(available_instances);
 
 static const struct attribute *mdev_types_attrs[] = {
-	&mdev_type_attr_name.attr,
 	&mdev_type_attr_description.attr,
 	&mdev_type_attr_available_instances.attr,
 	NULL,
diff --git a/samples/vfio-mdev/mtty.c b/samples/vfio-mdev/mtty.c
index 2a470424628af..b95a4491265c5 100644
--- a/samples/vfio-mdev/mtty.c
+++ b/samples/vfio-mdev/mtty.c
@@ -146,10 +146,11 @@ struct mdev_state {
 static struct mtty_type {
 	struct mdev_type type;
 	int nr_ports;
-	const char *name;
 } mtty_types[2] = {
-	{ .nr_ports = 1, .type.sysfs_name = "1", .name = "Single port serial" },
-	{ .nr_ports = 2, .type.sysfs_name = "2", .name = "Dual port serial" },
+	{ .nr_ports = 1, .type.sysfs_name = "1",
+	  .type.pretty_name = "Single port serial" },
+	{ .nr_ports = 2, .type.sysfs_name = "2",
+	  .type.pretty_name = "Dual port serial" },
 };
 
 static struct mdev_type *mtty_mdev_types[] = {
@@ -1246,16 +1247,6 @@ static const struct attribute_group *mdev_dev_groups[] = {
 	NULL,
 };
 
-static ssize_t name_show(struct mdev_type *mtype,
-			 struct mdev_type_attribute *attr, char *buf)
-{
-	struct mtty_type *type = container_of(mtype, struct mtty_type, type);
-
-	return sysfs_emit(buf, "%s\n", type->name);
-}
-
-static MDEV_TYPE_ATTR_RO(name);
-
 static ssize_t available_instances_show(struct mdev_type *mtype,
 					struct mdev_type_attribute *attr,
 					char *buf)
@@ -1269,7 +1260,6 @@ static ssize_t available_instances_show(struct mdev_type *mtype,
 static MDEV_TYPE_ATTR_RO(available_instances);
 
 static const struct attribute *mdev_types_attrs[] = {
-	&mdev_type_attr_name.attr,
 	&mdev_type_attr_available_instances.attr,
 	NULL,
 };
-- 
2.30.2

