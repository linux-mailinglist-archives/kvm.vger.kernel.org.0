Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C706C53C4ED
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 08:33:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241506AbiFCGdv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jun 2022 02:33:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241490AbiFCGdp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Jun 2022 02:33:45 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38D3B2BF3;
        Thu,  2 Jun 2022 23:33:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=73O46R1bXGA3eZbxIX9SO3j/0Te6wk3op4LDRO2QTjI=; b=Wn/8DdiEI47XcNxzmLeDfnBHkm
        3GWJiMw1hESzFpwPqC8zWkbnVcnmfK+gfMTgkmZairx302kJDkLyuMA7xaLFIXt1+FIu6VjofmXsa
        eCkKy9RyIBCLenKpM8TjywVEskLjPZAxyphcAMDx3WtDr1CFBPJF4yxgaA6kgsWlFcUElJoO2NzEm
        4dnTeW3yKbfE79+sIkBmYo1dAd+p0ePHMVxsc2rtXdMgVuRIytAufGifCz70Q1UZZ2tpwqbyCMXg4
        rhReu8qWAQcnY27FjitlSFjSzSRwDu0APmqVLjJhqV42LoWR1iSPYK2wWyADmTDZjSCfx/NOylAd1
        9F4BktdA==;
Received: from [2001:4bb8:185:a81e:b29a:8b56:eb9a:ca3b] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nx0sM-00611e-Lb; Fri, 03 Jun 2022 06:33:39 +0000
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
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        intel-gvt-dev@lists.freedesktop.org
Subject: [PATCH 3/8] vfio/mdev: simplify mdev_type handling
Date:   Fri,  3 Jun 2022 08:33:23 +0200
Message-Id: <20220603063328.3715-4-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220603063328.3715-1-hch@lst.de>
References: <20220603063328.3715-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Allocate the mdev_type structures in the caller and add them one-by one.
This allows the caller to use container_of to get at the containing
struture and thus significantly simplify the code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 .../driver-api/vfio-mediated-device.rst       |   1 -
 drivers/gpu/drm/i915/gvt/gvt.h                |   1 +
 drivers/gpu/drm/i915/gvt/kvmgt.c              | 113 +++++------------
 drivers/s390/cio/cio.h                        |   1 +
 drivers/s390/cio/vfio_ccw_ops.c               |  27 ++--
 drivers/s390/crypto/vfio_ap_ops.c             |  20 ++-
 drivers/s390/crypto/vfio_ap_private.h         |   1 +
 drivers/vfio/mdev/mdev_core.c                 |  33 +----
 drivers/vfio/mdev/mdev_private.h              |  11 --
 drivers/vfio/mdev/mdev_sysfs.c                | 117 +++---------------
 include/linux/mdev.h                          |  17 ++-
 samples/vfio-mdev/mbochs.c                    |  64 +++++-----
 samples/vfio-mdev/mdpy.c                      |  56 ++++-----
 samples/vfio-mdev/mtty.c                      |  71 ++++++-----
 14 files changed, 184 insertions(+), 349 deletions(-)

diff --git a/Documentation/driver-api/vfio-mediated-device.rst b/Documentation/driver-api/vfio-mediated-device.rst
index 3749f59c855fa..8ff463aa9e2be 100644
--- a/Documentation/driver-api/vfio-mediated-device.rst
+++ b/Documentation/driver-api/vfio-mediated-device.rst
@@ -105,7 +105,6 @@ structure to represent a mediated device's driver::
      struct mdev_driver {
 	     int  (*probe)  (struct mdev_device *dev);
 	     void (*remove) (struct mdev_device *dev);
-	     struct attribute_group **supported_type_groups;
 	     struct device_driver    driver;
      };
 
diff --git a/drivers/gpu/drm/i915/gvt/gvt.h b/drivers/gpu/drm/i915/gvt/gvt.h
index aee1a45da74bc..dc5183ab0175e 100644
--- a/drivers/gpu/drm/i915/gvt/gvt.h
+++ b/drivers/gpu/drm/i915/gvt/gvt.h
@@ -297,6 +297,7 @@ struct intel_gvt_firmware {
 
 #define NR_MAX_INTEL_VGPU_TYPES 20
 struct intel_vgpu_type {
+	struct mdev_type type;
 	char name[16];
 	unsigned int avail_instance;
 	unsigned int low_gm_size;
diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
index 37bda01c1bb97..06b8acc6a995d 100644
--- a/drivers/gpu/drm/i915/gvt/kvmgt.c
+++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
@@ -119,17 +119,10 @@ static ssize_t available_instances_show(struct mdev_type *mtype,
 					struct mdev_type_attribute *attr,
 					char *buf)
 {
-	struct intel_vgpu_type *type;
-	unsigned int num = 0;
-	struct intel_gvt *gvt = kdev_to_i915(mtype_get_parent_dev(mtype))->gvt;
+	struct intel_vgpu_type *type =
+		container_of(mtype, struct intel_vgpu_type, type);
 
-	type = &gvt->types[mtype_get_type_group_id(mtype)];
-	if (!type)
-		num = 0;
-	else
-		num = type->avail_instance;
-
-	return sprintf(buf, "%u\n", num);
+	return sprintf(buf, "%u\n", type->avail_instance);
 }
 
 static ssize_t device_api_show(struct mdev_type *mtype,
@@ -141,12 +134,8 @@ static ssize_t device_api_show(struct mdev_type *mtype,
 static ssize_t description_show(struct mdev_type *mtype,
 				struct mdev_type_attribute *attr, char *buf)
 {
-	struct intel_vgpu_type *type;
-	struct intel_gvt *gvt = kdev_to_i915(mtype_get_parent_dev(mtype))->gvt;
-
-	type = &gvt->types[mtype_get_type_group_id(mtype)];
-	if (!type)
-		return 0;
+	struct intel_vgpu_type *type =
+		container_of(mtype, struct intel_vgpu_type, type);
 
 	return sprintf(buf, "low_gm_size: %dMB\nhigh_gm_size: %dMB\n"
 		       "fence: %d\nresolution: %s\n"
@@ -160,12 +149,8 @@ static ssize_t description_show(struct mdev_type *mtype,
 static ssize_t name_show(struct mdev_type *mtype,
 			 struct mdev_type_attribute *attr, char *buf)
 {
-	struct intel_vgpu_type *type;
-	struct intel_gvt *gvt = kdev_to_i915(mtype_get_parent_dev(mtype))->gvt;
-
-	type = &gvt->types[mtype_get_type_group_id(mtype)];
-	if (!type)
-		return 0;
+	struct intel_vgpu_type *type =
+		container_of(mtype, struct intel_vgpu_type, type);
 
 	return sprintf(buf, "%s\n", type->name);
 }
@@ -175,7 +160,7 @@ static MDEV_TYPE_ATTR_RO(device_api);
 static MDEV_TYPE_ATTR_RO(description);
 static MDEV_TYPE_ATTR_RO(name);
 
-static struct attribute *gvt_type_attrs[] = {
+static const struct attribute *gvt_type_attrs[] = {
 	&mdev_type_attr_available_instances.attr,
 	&mdev_type_attr_device_api.attr,
 	&mdev_type_attr_description.attr,
@@ -183,51 +168,6 @@ static struct attribute *gvt_type_attrs[] = {
 	NULL,
 };
 
-static struct attribute_group *gvt_vgpu_type_groups[] = {
-	[0 ... NR_MAX_INTEL_VGPU_TYPES - 1] = NULL,
-};
-
-static int intel_gvt_init_vgpu_type_groups(struct intel_gvt *gvt)
-{
-	int i, j;
-	struct intel_vgpu_type *type;
-	struct attribute_group *group;
-
-	for (i = 0; i < gvt->num_types; i++) {
-		type = &gvt->types[i];
-
-		group = kzalloc(sizeof(struct attribute_group), GFP_KERNEL);
-		if (!group)
-			goto unwind;
-
-		group->name = type->name;
-		group->attrs = gvt_type_attrs;
-		gvt_vgpu_type_groups[i] = group;
-	}
-
-	return 0;
-
-unwind:
-	for (j = 0; j < i; j++) {
-		group = gvt_vgpu_type_groups[j];
-		kfree(group);
-	}
-
-	return -ENOMEM;
-}
-
-static void intel_gvt_cleanup_vgpu_type_groups(struct intel_gvt *gvt)
-{
-	int i;
-	struct attribute_group *group;
-
-	for (i = 0; i < gvt->num_types; i++) {
-		group = gvt_vgpu_type_groups[i];
-		gvt_vgpu_type_groups[i] = NULL;
-		kfree(group);
-	}
-}
-
 static void gvt_unpin_guest_page(struct intel_vgpu *vgpu, unsigned long gfn,
 		unsigned long size)
 {
@@ -1616,14 +1556,11 @@ static int intel_vgpu_probe(struct mdev_device *mdev)
 {
 	struct device *pdev = mdev_parent_dev(mdev);
 	struct intel_gvt *gvt = kdev_to_i915(pdev)->gvt;
-	struct intel_vgpu_type *type;
+	struct intel_vgpu_type *type =
+		container_of(mdev->type, struct intel_vgpu_type, type);
 	struct intel_vgpu *vgpu;
 	int ret;
 
-	type = &gvt->types[mdev_get_type_group_id(mdev)];
-	if (!type)
-		return -EINVAL;
-
 	vgpu = intel_gvt_create_vgpu(gvt, type);
 	if (IS_ERR(vgpu)) {
 		gvt_err("failed to create intel vgpu: %ld\n", PTR_ERR(vgpu));
@@ -1662,7 +1599,6 @@ static struct mdev_driver intel_vgpu_mdev_driver = {
 	},
 	.probe		= intel_vgpu_probe,
 	.remove		= intel_vgpu_remove,
-	.supported_type_groups	= gvt_vgpu_type_groups,
 };
 
 int intel_gvt_page_track_add(struct intel_vgpu *info, u64 gfn)
@@ -1956,12 +1892,14 @@ static int init_service_thread(struct intel_gvt *gvt)
 static void intel_gvt_clean_device(struct drm_i915_private *i915)
 {
 	struct intel_gvt *gvt = fetch_and_zero(&i915->gvt);
+	int i;
 
 	if (drm_WARN_ON(&i915->drm, !gvt))
 		return;
 
+	for (i = 0; i < gvt->num_types; i++)
+		mdev_type_remove(&gvt->types[i].type, gvt_type_attrs);
 	mdev_unregister_parent(&i915->vgpu.parent);
-	intel_gvt_cleanup_vgpu_type_groups(gvt);
 	intel_gvt_destroy_idle_vgpu(gvt->idle_vgpu);
 	intel_gvt_clean_vgpu_types(gvt);
 
@@ -1994,6 +1932,7 @@ static int intel_gvt_init_device(struct drm_i915_private *i915)
 	struct intel_gvt *gvt;
 	struct intel_vgpu *vgpu;
 	int ret;
+	int i;
 
 	if (drm_WARN_ON(&i915->drm, i915->gvt))
 		return -EEXIST;
@@ -2061,20 +2000,30 @@ static int intel_gvt_init_device(struct drm_i915_private *i915)
 
 	intel_gvt_debugfs_init(gvt);
 
-	ret = intel_gvt_init_vgpu_type_groups(gvt);
-	if (ret)
-		goto out_destroy_idle_vgpu;
-
 	ret = mdev_register_parent(&i915->vgpu.parent, i915->drm.dev,
 				   &intel_vgpu_mdev_driver);
 	if (ret)
-		goto out_cleanup_vgpu_type_groups;
+		goto out_destroy_idle_vgpu;
+
+	for (i = 0; i < gvt->num_types; i++) {
+		struct intel_vgpu_type *type = &gvt->types[i];
+
+		ret = mdev_type_add(&i915->vgpu.parent, &type->type, type->name,
+				    gvt_type_attrs);
+		if (ret)
+			goto out_remove_type_groups;
+	}
 
 	gvt_dbg_core("gvt device initialization is done\n");
 	return 0;
 
-out_cleanup_vgpu_type_groups:
-	intel_gvt_cleanup_vgpu_type_groups(gvt);
+out_remove_type_groups:
+	while (--i >= 0) {
+		struct intel_vgpu_type *type = &gvt->types[i];
+
+		mdev_type_remove(&type->type, gvt_type_attrs);
+	}
+	mdev_unregister_parent(&i915->vgpu.parent);
 out_destroy_idle_vgpu:
 	intel_gvt_destroy_idle_vgpu(gvt->idle_vgpu);
 	intel_gvt_debugfs_clean(gvt);
diff --git a/drivers/s390/cio/cio.h b/drivers/s390/cio/cio.h
index 4ae462da7b45b..fb0c283a975a7 100644
--- a/drivers/s390/cio/cio.h
+++ b/drivers/s390/cio/cio.h
@@ -106,6 +106,7 @@ struct subchannel {
 	u64 dma_mask;
 	char *driver_override; /* Driver name to force a match */
 	struct mdev_parent parent;
+	struct mdev_type mdev_type;
 } __attribute__ ((aligned(8)));
 
 DECLARE_PER_CPU_ALIGNED(struct irb, cio_irb);
diff --git a/drivers/s390/cio/vfio_ccw_ops.c b/drivers/s390/cio/vfio_ccw_ops.c
index 9192a21085ce4..e219ea3c62fc6 100644
--- a/drivers/s390/cio/vfio_ccw_ops.c
+++ b/drivers/s390/cio/vfio_ccw_ops.c
@@ -95,23 +95,13 @@ static ssize_t available_instances_show(struct mdev_type *mtype,
 }
 static MDEV_TYPE_ATTR_RO(available_instances);
 
-static struct attribute *mdev_types_attrs[] = {
+static const struct attribute *mdev_types_attrs[] = {
 	&mdev_type_attr_name.attr,
 	&mdev_type_attr_device_api.attr,
 	&mdev_type_attr_available_instances.attr,
 	NULL,
 };
 
-static struct attribute_group mdev_type_group = {
-	.name  = "io",
-	.attrs = mdev_types_attrs,
-};
-
-static struct attribute_group *mdev_type_groups[] = {
-	&mdev_type_group,
-	NULL,
-};
-
 static int vfio_ccw_mdev_probe(struct mdev_device *mdev)
 {
 	struct vfio_ccw_private *private = dev_get_drvdata(mdev->dev.parent);
@@ -654,16 +644,25 @@ struct mdev_driver vfio_ccw_mdev_driver = {
 	},
 	.probe = vfio_ccw_mdev_probe,
 	.remove = vfio_ccw_mdev_remove,
-	.supported_type_groups  = mdev_type_groups,
 };
 
 int vfio_ccw_mdev_reg(struct subchannel *sch)
 {
-	return mdev_register_parent(&sch->parent, &sch->dev,
-				    &vfio_ccw_mdev_driver);
+	int ret;
+
+	ret = mdev_register_parent(&sch->parent, &sch->dev,
+				   &vfio_ccw_mdev_driver);
+	if (ret)
+		return ret;
+	ret = mdev_type_add(&sch->parent, &sch->mdev_type, "io",
+			    mdev_types_attrs);
+	if (ret)
+		mdev_unregister_parent(&sch->parent);
+	return ret;
 }
 
 void vfio_ccw_mdev_unreg(struct subchannel *sch)
 {
+	mdev_type_remove(&sch->mdev_type, mdev_types_attrs);
 	mdev_unregister_parent(&sch->parent);
 }
diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 834945150dc9f..caaa4fcb00460 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -537,23 +537,13 @@ static ssize_t device_api_show(struct mdev_type *mtype,
 
 static MDEV_TYPE_ATTR_RO(device_api);
 
-static struct attribute *vfio_ap_mdev_type_attrs[] = {
+static const struct attribute *vfio_ap_mdev_type_attrs[] = {
 	&mdev_type_attr_name.attr,
 	&mdev_type_attr_device_api.attr,
 	&mdev_type_attr_available_instances.attr,
 	NULL,
 };
 
-static struct attribute_group vfio_ap_mdev_hwvirt_type_group = {
-	.name = VFIO_AP_MDEV_TYPE_HWVIRT,
-	.attrs = vfio_ap_mdev_type_attrs,
-};
-
-static struct attribute_group *vfio_ap_mdev_type_groups[] = {
-	&vfio_ap_mdev_hwvirt_type_group,
-	NULL,
-};
-
 struct vfio_ap_queue_reserved {
 	unsigned long *apid;
 	unsigned long *apqi;
@@ -1472,7 +1462,6 @@ static struct mdev_driver vfio_ap_matrix_driver = {
 	},
 	.probe = vfio_ap_mdev_probe,
 	.remove = vfio_ap_mdev_remove,
-	.supported_type_groups = vfio_ap_mdev_type_groups,
 };
 
 int vfio_ap_mdev_register(void)
@@ -1489,8 +1478,14 @@ int vfio_ap_mdev_register(void)
 				   &vfio_ap_matrix_driver);
 	if (ret)
 		goto err_driver;
+	ret = mdev_type_add(&matrix_dev->parent, &matrix_dev->mdev_type,
+			    VFIO_AP_MDEV_TYPE_HWVIRT, vfio_ap_mdev_type_attrs);
+	if (ret)
+		goto err_parent;
 	return 0;
 
+err_parent:
+	mdev_unregister_parent(&matrix_dev->parent);
 err_driver:
 	mdev_unregister_driver(&vfio_ap_matrix_driver);
 	return ret;
@@ -1498,6 +1493,7 @@ int vfio_ap_mdev_register(void)
 
 void vfio_ap_mdev_unregister(void)
 {
+	mdev_type_remove(&matrix_dev->mdev_type, vfio_ap_mdev_type_attrs);
 	mdev_unregister_parent(&matrix_dev->parent);
 	mdev_unregister_driver(&vfio_ap_matrix_driver);
 }
diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
index b97dc548a7c95..0e9b576e63db5 100644
--- a/drivers/s390/crypto/vfio_ap_private.h
+++ b/drivers/s390/crypto/vfio_ap_private.h
@@ -47,6 +47,7 @@ struct ap_matrix_dev {
 	struct mutex lock;
 	struct ap_driver  *vfio_ap_drv;
 	struct mdev_parent parent;
+	struct mdev_type mdev_type;
 };
 
 extern struct ap_matrix_dev *matrix_dev;
diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
index 8b5a2b3f0c882..ff38c9549a55e 100644
--- a/drivers/vfio/mdev/mdev_core.c
+++ b/drivers/vfio/mdev/mdev_core.c
@@ -31,26 +31,6 @@ struct device *mdev_parent_dev(struct mdev_device *mdev)
 }
 EXPORT_SYMBOL(mdev_parent_dev);
 
-/*
- * Return the index in supported_type_groups that this mdev_device was created
- * from.
- */
-unsigned int mdev_get_type_group_id(struct mdev_device *mdev)
-{
-	return mdev->type->type_group_id;
-}
-EXPORT_SYMBOL(mdev_get_type_group_id);
-
-/*
- * Used in mdev_type_attribute sysfs functions to return the index in the
- * supported_type_groups that the sysfs is called from.
- */
-unsigned int mtype_get_type_group_id(struct mdev_type *mtype)
-{
-	return mtype->type_group_id;
-}
-EXPORT_SYMBOL(mtype_get_type_group_id);
-
 /*
  * Used in mdev_type_attribute sysfs functions to return the parent struct
  * device
@@ -97,10 +77,6 @@ int mdev_register_parent(struct mdev_parent *parent, struct device *dev,
 	char *envp[] = { env_string, NULL };
 	int ret;
 
-	/* check for mandatory ops */
-	if (!mdev_driver->supported_type_groups)
-		return -EINVAL;
-
 	memset(parent, 0, sizeof(*parent));
 	init_rwsem(&parent->unreg_sem);
 	parent->dev = dev;
@@ -112,9 +88,10 @@ int mdev_register_parent(struct mdev_parent *parent, struct device *dev,
 			return -ENOMEM;
 	}
 
-	ret = parent_create_sysfs_files(parent);
-	if (ret)
-		return ret;
+	parent->mdev_types_kset = kset_create_and_add("mdev_supported_types",
+					       NULL, &parent->dev->kobj);
+	if (!parent->mdev_types_kset)
+		return -ENOMEM;
 
 	ret = class_compat_create_link(mdev_bus_compat_class, dev, NULL);
 	if (ret)
@@ -140,7 +117,7 @@ void mdev_unregister_parent(struct mdev_parent *parent)
 	down_write(&parent->unreg_sem);
 	class_compat_remove_link(mdev_bus_compat_class, parent->dev, NULL);
 	device_for_each_child(parent->dev, NULL, mdev_device_remove_cb);
-	parent_remove_sysfs_files(parent);
+	kset_unregister(parent->mdev_types_kset);
 	up_write(&parent->unreg_sem);
 
 	kobject_uevent_env(&parent->dev->kobj, KOBJ_CHANGE, envp);
diff --git a/drivers/vfio/mdev/mdev_private.h b/drivers/vfio/mdev/mdev_private.h
index 297f911fdc890..476cc0379ede0 100644
--- a/drivers/vfio/mdev/mdev_private.h
+++ b/drivers/vfio/mdev/mdev_private.h
@@ -13,14 +13,6 @@
 int  mdev_bus_register(void);
 void mdev_bus_unregister(void);
 
-struct mdev_type {
-	struct kobject kobj;
-	struct kobject *devices_kobj;
-	struct mdev_parent *parent;
-	struct list_head next;
-	unsigned int type_group_id;
-};
-
 extern const struct attribute_group *mdev_device_groups[];
 
 #define to_mdev_type_attr(_attr)	\
@@ -28,9 +20,6 @@ extern const struct attribute_group *mdev_device_groups[];
 #define to_mdev_type(_kobj)		\
 	container_of(_kobj, struct mdev_type, kobj)
 
-int  parent_create_sysfs_files(struct mdev_parent *parent);
-void parent_remove_sysfs_files(struct mdev_parent *parent);
-
 int  mdev_create_sysfs_files(struct mdev_device *mdev);
 void mdev_remove_sysfs_files(struct mdev_device *mdev);
 
diff --git a/drivers/vfio/mdev/mdev_sysfs.c b/drivers/vfio/mdev/mdev_sysfs.c
index becce814aabfb..fb058755d85b8 100644
--- a/drivers/vfio/mdev/mdev_sysfs.c
+++ b/drivers/vfio/mdev/mdev_sysfs.c
@@ -82,8 +82,6 @@ static void mdev_type_release(struct kobject *kobj)
 	struct mdev_type *type = to_mdev_type(kobj);
 
 	pr_debug("Releasing group %s\n", kobj->name);
-	/* Pairs with the get in add_mdev_supported_type() */
-	put_device(type->parent->dev);
 	kfree(type);
 }
 
@@ -92,36 +90,19 @@ static struct kobj_type mdev_type_ktype = {
 	.release = mdev_type_release,
 };
 
-static struct mdev_type *add_mdev_supported_type(struct mdev_parent *parent,
-						 unsigned int type_group_id)
+
+int mdev_type_add(struct mdev_parent *parent, struct mdev_type *type,
+		const char *name, const struct attribute * const *attrs)
 {
-	struct mdev_type *type;
-	struct attribute_group *group =
-		parent->mdev_driver->supported_type_groups[type_group_id];
 	int ret;
 
-	if (!group->name) {
-		pr_err("%s: Type name empty!\n", __func__);
-		return ERR_PTR(-EINVAL);
-	}
-
-	type = kzalloc(sizeof(*type), GFP_KERNEL);
-	if (!type)
-		return ERR_PTR(-ENOMEM);
-
-	type->kobj.kset = parent->mdev_types_kset;
+	memset(type, 0, sizeof(*type));
 	type->parent = parent;
-	/* Pairs with the put in mdev_type_release() */
-	get_device(parent->dev);
-	type->type_group_id = type_group_id;
-
-	ret = kobject_init_and_add(&type->kobj, &mdev_type_ktype, NULL,
-				   "%s-%s", dev_driver_string(parent->dev),
-				   group->name);
-	if (ret) {
-		kobject_put(&type->kobj);
-		return ERR_PTR(ret);
-	}
+	type->kobj.kset = parent->mdev_types_kset;
+	ret = kobject_init_and_add(&type->kobj, &mdev_type_ktype, NULL, "%s-%s",
+				   dev_driver_string(parent->dev), name);
+	if (ret)
+		return ret;
 
 	ret = sysfs_create_file(&type->kobj, &mdev_type_attr_create.attr);
 	if (ret)
@@ -133,13 +114,10 @@ static struct mdev_type *add_mdev_supported_type(struct mdev_parent *parent,
 		goto attr_devices_failed;
 	}
 
-	ret = sysfs_create_files(&type->kobj,
-				 (const struct attribute **)group->attrs);
-	if (ret) {
-		ret = -ENOMEM;
+	ret = sysfs_create_files(&type->kobj, attrs);
+	if (ret)
 		goto attrs_failed;
-	}
-	return type;
+	return 0;
 
 attrs_failed:
 	kobject_put(type->devices_kobj);
@@ -148,79 +126,20 @@ static struct mdev_type *add_mdev_supported_type(struct mdev_parent *parent,
 attr_create_failed:
 	kobject_del(&type->kobj);
 	kobject_put(&type->kobj);
-	return ERR_PTR(ret);
+	return ret;
 }
+EXPORT_SYMBOL_GPL(mdev_type_add);
 
-static void remove_mdev_supported_type(struct mdev_type *type)
+void mdev_type_remove(struct mdev_type *type,
+		const struct attribute * const *attrs)
 {
-	struct attribute_group *group =
-		type->parent->mdev_driver->supported_type_groups[type->type_group_id];
-
-	sysfs_remove_files(&type->kobj,
-			   (const struct attribute **)group->attrs);
+	sysfs_remove_files(&type->kobj, attrs);
 	kobject_put(type->devices_kobj);
 	sysfs_remove_file(&type->kobj, &mdev_type_attr_create.attr);
 	kobject_del(&type->kobj);
 	kobject_put(&type->kobj);
 }
-
-static int add_mdev_supported_type_groups(struct mdev_parent *parent)
-{
-	int i;
-
-	for (i = 0; parent->mdev_driver->supported_type_groups[i]; i++) {
-		struct mdev_type *type;
-
-		type = add_mdev_supported_type(parent, i);
-		if (IS_ERR(type)) {
-			struct mdev_type *ltype, *tmp;
-
-			list_for_each_entry_safe(ltype, tmp, &parent->type_list,
-						  next) {
-				list_del(&ltype->next);
-				remove_mdev_supported_type(ltype);
-			}
-			return PTR_ERR(type);
-		}
-		list_add(&type->next, &parent->type_list);
-	}
-	return 0;
-}
-
-/* mdev sysfs functions */
-void parent_remove_sysfs_files(struct mdev_parent *parent)
-{
-	struct mdev_type *type, *tmp;
-
-	list_for_each_entry_safe(type, tmp, &parent->type_list, next) {
-		list_del(&type->next);
-		remove_mdev_supported_type(type);
-	}
-
-	kset_unregister(parent->mdev_types_kset);
-}
-
-int parent_create_sysfs_files(struct mdev_parent *parent)
-{
-	int ret;
-
-	parent->mdev_types_kset = kset_create_and_add("mdev_supported_types",
-					       NULL, &parent->dev->kobj);
-
-	if (!parent->mdev_types_kset)
-		return -ENOMEM;
-
-	INIT_LIST_HEAD(&parent->type_list);
-
-	ret = add_mdev_supported_type_groups(parent);
-	if (ret)
-		goto create_err;
-	return 0;
-
-create_err:
-	kset_unregister(parent->mdev_types_kset);
-	return ret;
-}
+EXPORT_SYMBOL_GPL(mdev_type_remove);
 
 static ssize_t remove_store(struct device *dev, struct device_attribute *attr,
 			    const char *buf, size_t count)
diff --git a/include/linux/mdev.h b/include/linux/mdev.h
index 327ce3e5c6b5f..cbb53dcd20d9d 100644
--- a/include/linux/mdev.h
+++ b/include/linux/mdev.h
@@ -23,12 +23,17 @@ struct mdev_device {
 	bool active;
 };
 
+struct mdev_type {
+	struct kobject kobj;
+	struct kobject *devices_kobj;
+	struct mdev_parent *parent;
+};
+
 /* embedded into the struct device that the mdev devices hang off */
 struct mdev_parent {
 	struct device *dev;
 	struct mdev_driver *mdev_driver;
 	struct kset *mdev_types_kset;
-	struct list_head type_list;
 	/* Synchronize device creation/removal with parent unregistration */
 	struct rw_semaphore unreg_sem;
 };
@@ -38,8 +43,11 @@ static inline struct mdev_device *to_mdev_device(struct device *dev)
 	return container_of(dev, struct mdev_device, dev);
 }
 
-unsigned int mdev_get_type_group_id(struct mdev_device *mdev);
-unsigned int mtype_get_type_group_id(struct mdev_type *mtype);
+int mdev_type_add(struct mdev_parent *parent, struct mdev_type *type,
+		const char *name, const struct attribute * const *attrs);
+void mdev_type_remove(struct mdev_type *type,
+		const struct attribute * const *attrs);
+
 struct device *mtype_get_parent_dev(struct mdev_type *mtype);
 
 /* interface for exporting mdev supported type attributes */
@@ -66,15 +74,12 @@ struct mdev_type_attribute mdev_type_attr_##_name =		\
  * struct mdev_driver - Mediated device driver
  * @probe: called when new device created
  * @remove: called when device removed
- * @supported_type_groups: Attributes to define supported types. It is mandatory
- *			to provide supported types.
  * @driver: device driver structure
  *
  **/
 struct mdev_driver {
 	int (*probe)(struct mdev_device *dev);
 	void (*remove)(struct mdev_device *dev);
-	struct attribute_group **supported_type_groups;
 	struct device_driver driver;
 };
 
diff --git a/samples/vfio-mdev/mbochs.c b/samples/vfio-mdev/mbochs.c
index f0967a81eabe7..32fd6f385fafd 100644
--- a/samples/vfio-mdev/mbochs.c
+++ b/samples/vfio-mdev/mbochs.c
@@ -100,23 +100,28 @@ MODULE_PARM_DESC(mem, "megabytes available to " MBOCHS_NAME " devices");
 #define MBOCHS_TYPE_2 "medium"
 #define MBOCHS_TYPE_3 "large"
 
-static const struct mbochs_type {
+static struct mbochs_type {
+	struct mdev_type type;
+	const char *fname;
 	const char *name;
 	u32 mbytes;
 	u32 max_x;
 	u32 max_y;
 } mbochs_types[] = {
 	{
+		.fname	= MBOCHS_TYPE_1,
 		.name	= MBOCHS_CLASS_NAME "-" MBOCHS_TYPE_1,
 		.mbytes = 4,
 		.max_x  = 800,
 		.max_y  = 600,
 	}, {
+		.fname	= MBOCHS_TYPE_2,
 		.name	= MBOCHS_CLASS_NAME "-" MBOCHS_TYPE_2,
 		.mbytes = 16,
 		.max_x  = 1920,
 		.max_y  = 1440,
 	}, {
+		.fname	= MBOCHS_TYPE_3,
 		.name	= MBOCHS_CLASS_NAME "-" MBOCHS_TYPE_3,
 		.mbytes = 64,
 		.max_x  = 0,
@@ -509,8 +514,8 @@ static int mbochs_reset(struct mdev_state *mdev_state)
 static int mbochs_probe(struct mdev_device *mdev)
 {
 	int avail_mbytes = atomic_read(&mbochs_avail_mbytes);
-	const struct mbochs_type *type =
-		&mbochs_types[mdev_get_type_group_id(mdev)];
+	struct mbochs_type *type =
+		container_of(mdev->type, struct mbochs_type, type);
 	struct device *dev = mdev_dev(mdev);
 	struct mdev_state *mdev_state;
 	int ret = -ENOMEM;
@@ -1329,8 +1334,8 @@ static const struct attribute_group *mdev_dev_groups[] = {
 static ssize_t name_show(struct mdev_type *mtype,
 			 struct mdev_type_attribute *attr, char *buf)
 {
-	const struct mbochs_type *type =
-		&mbochs_types[mtype_get_type_group_id(mtype)];
+	struct mbochs_type *type =
+		container_of(mtype, struct mbochs_type, type);
 
 	return sprintf(buf, "%s\n", type->name);
 }
@@ -1339,8 +1344,8 @@ static MDEV_TYPE_ATTR_RO(name);
 static ssize_t description_show(struct mdev_type *mtype,
 				struct mdev_type_attribute *attr, char *buf)
 {
-	const struct mbochs_type *type =
-		&mbochs_types[mtype_get_type_group_id(mtype)];
+	struct mbochs_type *type =
+		container_of(mtype, struct mbochs_type, type);
 
 	return sprintf(buf, "virtual display, %d MB video memory\n",
 		       type ? type->mbytes  : 0);
@@ -1351,8 +1356,8 @@ static ssize_t available_instances_show(struct mdev_type *mtype,
 					struct mdev_type_attribute *attr,
 					char *buf)
 {
-	const struct mbochs_type *type =
-		&mbochs_types[mtype_get_type_group_id(mtype)];
+	struct mbochs_type *type =
+		container_of(mtype, struct mbochs_type, type);
 	int count = atomic_read(&mbochs_avail_mbytes) / type->mbytes;
 
 	return sprintf(buf, "%d\n", count);
@@ -1366,7 +1371,7 @@ static ssize_t device_api_show(struct mdev_type *mtype,
 }
 static MDEV_TYPE_ATTR_RO(device_api);
 
-static struct attribute *mdev_types_attrs[] = {
+static const struct attribute *mdev_types_attrs[] = {
 	&mdev_type_attr_name.attr,
 	&mdev_type_attr_description.attr,
 	&mdev_type_attr_device_api.attr,
@@ -1374,28 +1379,6 @@ static struct attribute *mdev_types_attrs[] = {
 	NULL,
 };
 
-static struct attribute_group mdev_type_group1 = {
-	.name  = MBOCHS_TYPE_1,
-	.attrs = mdev_types_attrs,
-};
-
-static struct attribute_group mdev_type_group2 = {
-	.name  = MBOCHS_TYPE_2,
-	.attrs = mdev_types_attrs,
-};
-
-static struct attribute_group mdev_type_group3 = {
-	.name  = MBOCHS_TYPE_3,
-	.attrs = mdev_types_attrs,
-};
-
-static struct attribute_group *mdev_type_groups[] = {
-	&mdev_type_group1,
-	&mdev_type_group2,
-	&mdev_type_group3,
-	NULL,
-};
-
 static const struct vfio_device_ops mbochs_dev_ops = {
 	.close_device = mbochs_close_device,
 	.read = mbochs_read,
@@ -1413,7 +1396,6 @@ static struct mdev_driver mbochs_driver = {
 	},
 	.probe = mbochs_probe,
 	.remove	= mbochs_remove,
-	.supported_type_groups = mdev_type_groups,
 };
 
 static const struct file_operations vd_fops = {
@@ -1427,7 +1409,7 @@ static void mbochs_device_release(struct device *dev)
 
 static int __init mbochs_dev_init(void)
 {
-	int ret = 0;
+	int i, ret = 0;
 
 	atomic_set(&mbochs_avail_mbytes, max_mbytes);
 
@@ -1461,9 +1443,19 @@ static int __init mbochs_dev_init(void)
 	ret = mdev_register_parent(&mbochs_parent, &mbochs_dev, &mbochs_driver);
 	if (ret)
 		goto err_device;
+	for (i = 0; i < ARRAY_SIZE(mbochs_types); i++) {
+		ret = mdev_type_add(&mbochs_parent, &mbochs_types[i].type,
+				    mbochs_types[i].fname, mdev_types_attrs);
+		if (ret)
+			goto err_types;
+	}
 
 	return 0;
 
+err_types:
+	while (--i >= 0)
+		mdev_type_remove(&mbochs_types[i].type, mdev_types_attrs);
+	mdev_unregister_parent(&mbochs_parent);
 err_device:
 	device_unregister(&mbochs_dev);
 err_class:
@@ -1478,7 +1470,11 @@ static int __init mbochs_dev_init(void)
 
 static void __exit mbochs_dev_exit(void)
 {
+	int i;
+
 	mbochs_dev.bus = NULL;
+	for (i = 0; i < ARRAY_SIZE(mbochs_types); i++)
+		mdev_type_remove(&mbochs_types[i].type, mdev_types_attrs);
 	mdev_unregister_parent(&mbochs_parent);
 
 	device_unregister(&mbochs_dev);
diff --git a/samples/vfio-mdev/mdpy.c b/samples/vfio-mdev/mdpy.c
index 8ab88a1d149cb..a6aa7f6f97095 100644
--- a/samples/vfio-mdev/mdpy.c
+++ b/samples/vfio-mdev/mdpy.c
@@ -52,7 +52,9 @@ MODULE_PARM_DESC(count, "number of " MDPY_NAME " devices");
 #define MDPY_TYPE_2 "xga"
 #define MDPY_TYPE_3 "hd"
 
-static const struct mdpy_type {
+static struct mdpy_type {
+	struct mdev_type type;
+	const char *fname;
 	const char *name;
 	u32 format;
 	u32 bytepp;
@@ -60,18 +62,21 @@ static const struct mdpy_type {
 	u32 height;
 } mdpy_types[] = {
 	{
+		.fname 	= MDPY_TYPE_1,
 		.name	= MDPY_CLASS_NAME "-" MDPY_TYPE_1,
 		.format = DRM_FORMAT_XRGB8888,
 		.bytepp = 4,
 		.width	= 640,
 		.height = 480,
 	}, {
+		.fname 	= MDPY_TYPE_2,
 		.name	= MDPY_CLASS_NAME "-" MDPY_TYPE_2,
 		.format = DRM_FORMAT_XRGB8888,
 		.bytepp = 4,
 		.width	= 1024,
 		.height = 768,
 	}, {
+		.fname 	= MDPY_TYPE_3,
 		.name	= MDPY_CLASS_NAME "-" MDPY_TYPE_3,
 		.format = DRM_FORMAT_XRGB8888,
 		.bytepp = 4,
@@ -220,7 +225,7 @@ static int mdpy_reset(struct mdev_state *mdev_state)
 static int mdpy_probe(struct mdev_device *mdev)
 {
 	const struct mdpy_type *type =
-		&mdpy_types[mdev_get_type_group_id(mdev)];
+		container_of(mdev->type, struct mdpy_type, type);
 	struct device *dev = mdev_dev(mdev);
 	struct mdev_state *mdev_state;
 	u32 fbsize;
@@ -645,8 +650,7 @@ static const struct attribute_group *mdev_dev_groups[] = {
 static ssize_t name_show(struct mdev_type *mtype,
 			 struct mdev_type_attribute *attr, char *buf)
 {
-	const struct mdpy_type *type =
-		&mdpy_types[mtype_get_type_group_id(mtype)];
+	struct mdpy_type *type = container_of(mtype, struct mdpy_type, type);
 
 	return sprintf(buf, "%s\n", type->name);
 }
@@ -655,8 +659,7 @@ static MDEV_TYPE_ATTR_RO(name);
 static ssize_t description_show(struct mdev_type *mtype,
 				struct mdev_type_attribute *attr, char *buf)
 {
-	const struct mdpy_type *type =
-		&mdpy_types[mtype_get_type_group_id(mtype)];
+	struct mdpy_type *type = container_of(mtype, struct mdpy_type, type);
 
 	return sprintf(buf, "virtual display, %dx%d framebuffer\n",
 		       type->width, type->height);
@@ -678,7 +681,7 @@ static ssize_t device_api_show(struct mdev_type *mtype,
 }
 static MDEV_TYPE_ATTR_RO(device_api);
 
-static struct attribute *mdev_types_attrs[] = {
+static const struct attribute *mdev_types_attrs[] = {
 	&mdev_type_attr_name.attr,
 	&mdev_type_attr_description.attr,
 	&mdev_type_attr_device_api.attr,
@@ -686,28 +689,6 @@ static struct attribute *mdev_types_attrs[] = {
 	NULL,
 };
 
-static struct attribute_group mdev_type_group1 = {
-	.name  = MDPY_TYPE_1,
-	.attrs = mdev_types_attrs,
-};
-
-static struct attribute_group mdev_type_group2 = {
-	.name  = MDPY_TYPE_2,
-	.attrs = mdev_types_attrs,
-};
-
-static struct attribute_group mdev_type_group3 = {
-	.name  = MDPY_TYPE_3,
-	.attrs = mdev_types_attrs,
-};
-
-static struct attribute_group *mdev_type_groups[] = {
-	&mdev_type_group1,
-	&mdev_type_group2,
-	&mdev_type_group3,
-	NULL,
-};
-
 static const struct vfio_device_ops mdpy_dev_ops = {
 	.read = mdpy_read,
 	.write = mdpy_write,
@@ -724,7 +705,6 @@ static struct mdev_driver mdpy_driver = {
 	},
 	.probe = mdpy_probe,
 	.remove	= mdpy_remove,
-	.supported_type_groups = mdev_type_groups,
 };
 
 static const struct file_operations vd_fops = {
@@ -738,7 +718,7 @@ static void mdpy_device_release(struct device *dev)
 
 static int __init mdpy_dev_init(void)
 {
-	int ret = 0;
+	int i, ret = 0;
 
 	ret = alloc_chrdev_region(&mdpy_devt, 0, MINORMASK + 1, MDPY_NAME);
 	if (ret < 0) {
@@ -770,9 +750,19 @@ static int __init mdpy_dev_init(void)
 	ret = mdev_register_parent(&mdpy_parent, &mdpy_dev, &mdpy_driver);
 	if (ret)
 		goto err_device;
+	for (i = 0; i < ARRAY_SIZE(mdpy_types); i++) {
+		ret = mdev_type_add(&mdpy_parent, &mdpy_types[i].type,
+				    mdpy_types[i].fname, mdev_types_attrs);
+		if (ret)
+			goto err_types;
+	}
 
 	return 0;
 
+err_types:
+	while (--i >= 0)
+		mdev_type_remove(&mdpy_types[i].type, mdev_types_attrs);
+	mdev_unregister_parent(&mdpy_parent);
 err_device:
 	device_unregister(&mdpy_dev);
 err_class:
@@ -787,7 +777,11 @@ static int __init mdpy_dev_init(void)
 
 static void __exit mdpy_dev_exit(void)
 {
+	int i;
+
 	mdpy_dev.bus = NULL;
+	for (i = 0; i < ARRAY_SIZE(mdpy_types); i++)
+		mdev_type_remove(&mdpy_types[i].type, mdev_types_attrs);
 	mdev_unregister_parent(&mdpy_parent);
 
 	device_unregister(&mdpy_dev);
diff --git a/samples/vfio-mdev/mtty.c b/samples/vfio-mdev/mtty.c
index 20136def93fdb..28c0811cf2312 100644
--- a/samples/vfio-mdev/mtty.c
+++ b/samples/vfio-mdev/mtty.c
@@ -145,6 +145,16 @@ struct mdev_state {
 	int nr_ports;
 };
 
+static struct mtty_type {
+	struct mdev_type type;
+	int nr_ports;
+	const char *fname;
+	const char *name;
+} mtty_types[2] = {
+	{ .nr_ports = 1, .fname = "1", .name = "Single port serial" },
+	{ .nr_ports = 2, .fname = "2", .name = "Dual port serial" },
+};
+
 static atomic_t mdev_avail_ports = ATOMIC_INIT(MAX_MTTYS);
 
 static const struct file_operations vd_fops = {
@@ -706,16 +716,18 @@ static ssize_t mdev_access(struct mdev_state *mdev_state, u8 *buf, size_t count,
 
 static int mtty_probe(struct mdev_device *mdev)
 {
+	struct mtty_type *type =
+		container_of(mdev->type, struct mtty_type, type);
 	struct mdev_state *mdev_state;
-	int nr_ports = mdev_get_type_group_id(mdev) + 1;
 	int avail_ports = atomic_read(&mdev_avail_ports);
 	int ret;
 
 	do {
-		if (avail_ports < nr_ports)
+		if (avail_ports < type->nr_ports)
 			return -ENOSPC;
 	} while (!atomic_try_cmpxchg(&mdev_avail_ports,
-				     &avail_ports, avail_ports - nr_ports));
+				     &avail_ports,
+				     avail_ports - type->nr_ports));
 
 	mdev_state = kzalloc(sizeof(struct mdev_state), GFP_KERNEL);
 	if (mdev_state == NULL) {
@@ -725,13 +737,13 @@ static int mtty_probe(struct mdev_device *mdev)
 
 	vfio_init_group_dev(&mdev_state->vdev, &mdev->dev, &mtty_dev_ops);
 
-	mdev_state->nr_ports = nr_ports;
+	mdev_state->nr_ports = type->nr_ports;
 	mdev_state->irq_index = -1;
 	mdev_state->s[0].max_fifo_size = MAX_FIFO_SIZE;
 	mdev_state->s[1].max_fifo_size = MAX_FIFO_SIZE;
 	mutex_init(&mdev_state->rxtx_lock);
-	mdev_state->vconfig = kzalloc(MTTY_CONFIG_SPACE_SIZE, GFP_KERNEL);
 
+	mdev_state->vconfig = kzalloc(MTTY_CONFIG_SPACE_SIZE, GFP_KERNEL);
 	if (mdev_state->vconfig == NULL) {
 		ret = -ENOMEM;
 		goto err_state;
@@ -754,7 +766,7 @@ static int mtty_probe(struct mdev_device *mdev)
 	vfio_uninit_group_dev(&mdev_state->vdev);
 	kfree(mdev_state);
 err_nr_ports:
-	atomic_add(nr_ports, &mdev_avail_ports);
+	atomic_add(type->nr_ports, &mdev_avail_ports);
 	return ret;
 }
 
@@ -1235,11 +1247,9 @@ static const struct attribute_group *mdev_dev_groups[] = {
 static ssize_t name_show(struct mdev_type *mtype,
 			 struct mdev_type_attribute *attr, char *buf)
 {
-	static const char *name_str[2] = { "Single port serial",
-					   "Dual port serial" };
+	struct mtty_type *type = container_of(mtype, struct mtty_type, type);
 
-	return sysfs_emit(buf, "%s\n",
-			  name_str[mtype_get_type_group_id(mtype)]);
+	return sysfs_emit(buf, "%s\n", type->name);
 }
 
 static MDEV_TYPE_ATTR_RO(name);
@@ -1248,9 +1258,10 @@ static ssize_t available_instances_show(struct mdev_type *mtype,
 					struct mdev_type_attribute *attr,
 					char *buf)
 {
-	unsigned int ports = mtype_get_type_group_id(mtype) + 1;
+	struct mtty_type *type = container_of(mtype, struct mtty_type, type);
 
-	return sprintf(buf, "%d\n", atomic_read(&mdev_avail_ports) / ports);
+	return sprintf(buf, "%d\n", atomic_read(&mdev_avail_ports) /
+			type->nr_ports);
 }
 
 static MDEV_TYPE_ATTR_RO(available_instances);
@@ -1263,29 +1274,13 @@ static ssize_t device_api_show(struct mdev_type *mtype,
 
 static MDEV_TYPE_ATTR_RO(device_api);
 
-static struct attribute *mdev_types_attrs[] = {
+static const struct attribute *mdev_types_attrs[] = {
 	&mdev_type_attr_name.attr,
 	&mdev_type_attr_device_api.attr,
 	&mdev_type_attr_available_instances.attr,
 	NULL,
 };
 
-static struct attribute_group mdev_type_group1 = {
-	.name  = "1",
-	.attrs = mdev_types_attrs,
-};
-
-static struct attribute_group mdev_type_group2 = {
-	.name  = "2",
-	.attrs = mdev_types_attrs,
-};
-
-static struct attribute_group *mdev_type_groups[] = {
-	&mdev_type_group1,
-	&mdev_type_group2,
-	NULL,
-};
-
 static const struct vfio_device_ops mtty_dev_ops = {
 	.name = "vfio-mtty",
 	.read = mtty_read,
@@ -1302,7 +1297,6 @@ static struct mdev_driver mtty_driver = {
 	},
 	.probe = mtty_probe,
 	.remove	= mtty_remove,
-	.supported_type_groups = mdev_type_groups,
 };
 
 static void mtty_device_release(struct device *dev)
@@ -1312,7 +1306,7 @@ static void mtty_device_release(struct device *dev)
 
 static int __init mtty_dev_init(void)
 {
-	int ret = 0;
+	int i, ret = 0;
 
 	pr_info("mtty_dev: %s\n", __func__);
 
@@ -1357,8 +1351,19 @@ static int __init mtty_dev_init(void)
 				   &mtty_driver);
 	if (ret)
 		goto err_device;
+	for (i = 0; i < ARRAY_SIZE(mtty_types); i++) {
+		ret = mdev_type_add(&mtty_dev.parent, &mtty_types[i].type,
+				    mtty_types[i].fname, mdev_types_attrs);
+		if (ret)
+			goto err_types;
+	}
+
 	return 0;
 
+err_types:
+	while (--i >= 0)
+		mdev_type_remove(&mtty_types[i].type, mdev_types_attrs);
+	mdev_unregister_parent(&mtty_dev.parent);
 err_device:
 	device_unregister(&mtty_dev.dev);
 err_class:
@@ -1373,7 +1378,11 @@ static int __init mtty_dev_init(void)
 
 static void __exit mtty_dev_exit(void)
 {
+	int i;
+
 	mtty_dev.dev.bus = NULL;
+	for (i = 0; i < ARRAY_SIZE(mtty_types); i++)
+		mdev_type_remove(&mtty_types[i].type, mdev_types_attrs);
 	mdev_unregister_parent(&mtty_dev.parent);
 
 	device_unregister(&mtty_dev.dev);
-- 
2.30.2

