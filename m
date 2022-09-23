Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76DBB5E770F
	for <lists+kvm@lfdr.de>; Fri, 23 Sep 2022 11:27:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231797AbiIWJ1w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Sep 2022 05:27:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230500AbiIWJ1j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Sep 2022 05:27:39 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6411AEE67A;
        Fri, 23 Sep 2022 02:27:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=6o7YBp3otUhkk8eKv2Apw4+SkTmT7q7l8uzpfsYk6jM=; b=HzjVqG3/QzbWGAjZTXDJSrAS6r
        qYy5Gklbv0jPFl5EyxhXPyNl7NQ7+Cp4T8HW+TzxFASvD1MqAkyGDQa8KQ1BHuHmbdhsg/0k1uQvj
        8oEYvS11nS8CZpsQRL/bDd4tqd+YruBITYEVQVczSxV3JhLosEKqt3tUw5CsTLh8C7qdBwwvfu3XU
        4tIPkY8Msr1LdxnRtuPNNQq6rUZ+Vc1y9w8PQPwBQXS0IiBDp/tma0OghmJLQ3pyMcASgDEPaYiGX
        6lOw90dkcglvjQ8mKEcQD4ST2ebJqKPzrXqh4M9mLf/UFmirjitl/1ihZhCe1dXKrort8xcdwWYHR
        SG8lY/+g==;
Received: from ip4d15bec4.dynamic.kabel-deutschland.de ([77.21.190.196] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1obexv-003Jtu-2A; Fri, 23 Sep 2022 09:27:23 +0000
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
Date:   Fri, 23 Sep 2022 11:26:49 +0200
Message-Id: <20220923092652.100656-12-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220923092652.100656-1-hch@lst.de>
References: <20220923092652.100656-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
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
 drivers/s390/crypto/vfio_ap_ops.c             | 10 +--------
 drivers/vfio/mdev/mdev_sysfs.c                | 10 +++++++++
 include/linux/mdev.h                          |  1 +
 samples/vfio-mdev/mbochs.c                    | 20 ++++--------------
 samples/vfio-mdev/mdpy.c                      | 21 +++++--------------
 samples/vfio-mdev/mtty.c                      | 18 ++++------------
 10 files changed, 27 insertions(+), 72 deletions(-)

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
index 9b2d3b078a2c9..08fe7458b3610 100644
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
index 4c7b181519228..394aab60dbd0a 100644
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
index d440acfbb261e..5d8dd7e837f3d 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -790,14 +790,6 @@ static void vfio_ap_mdev_remove(struct mdev_device *mdev)
 	vfio_put_device(&matrix_mdev->vdev);
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
@@ -809,7 +801,6 @@ static ssize_t available_instances_show(struct mdev_type *mtype,
 static MDEV_TYPE_ATTR_RO(available_instances);
 
 static const struct attribute *vfio_ap_mdev_type_attrs[] = {
-	&mdev_type_attr_name.attr,
 	&mdev_type_attr_available_instances.attr,
 	NULL,
 };
@@ -1813,6 +1804,7 @@ int vfio_ap_mdev_register(void)
 		return ret;
 
 	matrix_dev->mdev_type.sysfs_name = VFIO_AP_MDEV_TYPE_HWVIRT;
+	matrix_dev->mdev_type.pretty_name = VFIO_AP_MDEV_NAME_HWVIRT;
 	matrix_dev->mdev_types[0] = &matrix_dev->mdev_type;
 	ret = mdev_register_parent(&matrix_dev->parent, &matrix_dev->device,
 				   &vfio_ap_matrix_driver,
diff --git a/drivers/vfio/mdev/mdev_sysfs.c b/drivers/vfio/mdev/mdev_sysfs.c
index 60fc52ff92448..34583e6a97f27 100644
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
index a2fc13fade757..0b7585f16d8ab 100644
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
@@ -556,7 +555,7 @@ static int mbochs_init_dev(struct vfio_device *vdev)
 	mbochs_reset(mdev_state);
 
 	dev_info(vdev->dev, "%s: %s, %d MB, %ld pages\n", __func__,
-		 type->name, type->mbytes, mdev_state->pagecount);
+		 type->type.pretty_name, type->mbytes, mdev_state->pagecount);
 	return 0;
 
 err_vconfig:
@@ -1351,16 +1350,6 @@ static const struct attribute_group *mdev_dev_groups[] = {
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
@@ -1385,7 +1374,6 @@ static ssize_t available_instances_show(struct mdev_type *mtype,
 static MDEV_TYPE_ATTR_RO(available_instances);
 
 static const struct attribute *mdev_types_attrs[] = {
-	&mdev_type_attr_name.attr,
 	&mdev_type_attr_description.attr,
 	&mdev_type_attr_available_instances.attr,
 	NULL,
diff --git a/samples/vfio-mdev/mdpy.c b/samples/vfio-mdev/mdpy.c
index f9069ed2750fa..90c6fed200b19 100644
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
@@ -256,8 +255,8 @@ static int mdpy_init_dev(struct vfio_device *vdev)
 	mdpy_create_config_space(mdev_state);
 	mdpy_reset(mdev_state);
 
-	dev_info(vdev->dev, "%s: %s (%dx%d)\n", __func__, type->name, type->width,
-		 type->height);
+	dev_info(vdev->dev, "%s: %s (%dx%d)\n", __func__, type->type.pretty_name,
+		 type->width, type->height);
 
 	mdpy_count++;
 	return 0;
@@ -662,15 +661,6 @@ static const struct attribute_group *mdev_dev_groups[] = {
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
@@ -690,7 +680,6 @@ static ssize_t available_instances_show(struct mdev_type *mtype,
 static MDEV_TYPE_ATTR_RO(available_instances);
 
 static const struct attribute *mdev_types_attrs[] = {
-	&mdev_type_attr_name.attr,
 	&mdev_type_attr_description.attr,
 	&mdev_type_attr_available_instances.attr,
 	NULL,
diff --git a/samples/vfio-mdev/mtty.c b/samples/vfio-mdev/mtty.c
index 064e71b28dd19..eab1b4442a96e 100644
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
@@ -1255,16 +1256,6 @@ static const struct attribute_group *mdev_dev_groups[] = {
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
@@ -1278,7 +1269,6 @@ static ssize_t available_instances_show(struct mdev_type *mtype,
 static MDEV_TYPE_ATTR_RO(available_instances);
 
 static const struct attribute *mdev_types_attrs[] = {
-	&mdev_type_attr_name.attr,
 	&mdev_type_attr_available_instances.attr,
 	NULL,
 };
-- 
2.30.2

