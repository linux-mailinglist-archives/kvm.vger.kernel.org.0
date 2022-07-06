Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB93F568038
	for <lists+kvm@lfdr.de>; Wed,  6 Jul 2022 09:42:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231747AbiGFHmp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jul 2022 03:42:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231720AbiGFHmm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jul 2022 03:42:42 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 497CB22BDB;
        Wed,  6 Jul 2022 00:42:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=eqxJdjotx87VYDKFy1LpbwXaXHaiZQCZrXeIr0SR4gQ=; b=gEvgwfOEdJ5Cg8wfcuyrzmhILJ
        cAuFVWyLO9UDr9l3p6Fl4qHVRAm1jQQIAPTSaWFVbkMWaC6kssCMjoeCDnEAcvDSCXnEdqDwkq9sP
        F+DF7J6uD90KDJrP/beaeNxDsUcasezUylx/Q8Ol5TPx+H/XzkMj24IdC4qIS6grQ7tUbVs6ofCMj
        aZeI1NA5UWAgBFQ8Pg4KyCfPM7h14gy9JcD22Gc72K+ngA5nQ7eu6vwZCtKexRIN6UXorRlcCej2p
        EukThvwBZkNLRErZxI3+YVFCxugEqyQejsy7ram/LB7CCgSyoC9qrotMHF6cFbTn8ohX/jCMx1PW2
        quMA7CFw==;
Received: from [2001:4bb8:189:3c4a:34cd:2d1d:8766:aad] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o8zgB-0079mx-OI; Wed, 06 Jul 2022 07:42:36 +0000
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
Subject: [PATCH 05/15] vfio/mdev: simplify mdev_type handling
Date:   Wed,  6 Jul 2022 09:42:09 +0200
Message-Id: <20220706074219.3614-6-hch@lst.de>
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

Instead of abusing struct attribute_group to control initialization of
struct mdev_type, just define the actual attributes in the mdev_driver,
allocate the mdev_type structures in the caller and pass them to
mdev_register_parent.

This allows the caller to use container_of to get at the containing
structure and thus significantly simplify the code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
---
 .../driver-api/vfio-mediated-device.rst       |  2 +-
 drivers/gpu/drm/i915/gvt/gvt.h                |  3 +-
 drivers/gpu/drm/i915/gvt/kvmgt.c              | 98 +++----------------
 drivers/gpu/drm/i915/gvt/vgpu.c               | 13 ++-
 drivers/s390/cio/cio.h                        |  2 +
 drivers/s390/cio/vfio_ccw_ops.c               | 19 ++--
 drivers/s390/crypto/vfio_ap_ops.c             | 19 ++--
 drivers/s390/crypto/vfio_ap_private.h         |  2 +
 drivers/vfio/mdev/mdev_core.c                 | 31 ++----
 drivers/vfio/mdev/mdev_driver.c               |  5 +-
 drivers/vfio/mdev/mdev_private.h              |  8 --
 drivers/vfio/mdev/mdev_sysfs.c                | 90 +++++------------
 include/linux/mdev.h                          | 26 +++--
 samples/vfio-mdev/mbochs.c                    | 57 +++++------
 samples/vfio-mdev/mdpy.c                      | 50 ++++------
 samples/vfio-mdev/mtty.c                      | 62 ++++++------
 16 files changed, 165 insertions(+), 322 deletions(-)

diff --git a/Documentation/driver-api/vfio-mediated-device.rst b/Documentation/driver-api/vfio-mediated-device.rst
index 62a82afce161b..82a4007bd7207 100644
--- a/Documentation/driver-api/vfio-mediated-device.rst
+++ b/Documentation/driver-api/vfio-mediated-device.rst
@@ -105,7 +105,7 @@ structure to represent a mediated device's driver::
      struct mdev_driver {
 	     int  (*probe)  (struct mdev_device *dev);
 	     void (*remove) (struct mdev_device *dev);
-	     struct attribute_group **supported_type_groups;
+	     const struct attribute * const *types_attrs;
 	     struct device_driver    driver;
      };
 
diff --git a/drivers/gpu/drm/i915/gvt/gvt.h b/drivers/gpu/drm/i915/gvt/gvt.h
index bbf0116671ecb..f9690dca0a857 100644
--- a/drivers/gpu/drm/i915/gvt/gvt.h
+++ b/drivers/gpu/drm/i915/gvt/gvt.h
@@ -311,8 +311,8 @@ struct intel_vgpu_config {
 	const char *name;
 };
 
-#define NR_MAX_INTEL_VGPU_TYPES 20
 struct intel_vgpu_type {
+	struct mdev_type type;
 	char name[16];
 	const struct intel_vgpu_config *conf;
 	unsigned int avail_instance;
@@ -340,6 +340,7 @@ struct intel_gvt {
 	struct notifier_block shadow_ctx_notifier_block[I915_NUM_ENGINES];
 	DECLARE_HASHTABLE(cmd_table, GVT_CMD_HASH_BITS);
 	struct mdev_parent parent;
+	struct mdev_type **mdev_types;
 	struct intel_vgpu_type *types;
 	unsigned int num_types;
 	struct intel_vgpu *idle_vgpu;
diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
index e9dba4c0fe6b5..ead56e4d30650 100644
--- a/drivers/gpu/drm/i915/gvt/kvmgt.c
+++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
@@ -117,17 +117,10 @@ static ssize_t available_instances_show(struct mdev_type *mtype,
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
@@ -139,12 +132,8 @@ static ssize_t device_api_show(struct mdev_type *mtype,
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
@@ -158,14 +147,7 @@ static ssize_t description_show(struct mdev_type *mtype,
 static ssize_t name_show(struct mdev_type *mtype,
 			 struct mdev_type_attribute *attr, char *buf)
 {
-	struct intel_vgpu_type *type;
-	struct intel_gvt *gvt = kdev_to_i915(mtype_get_parent_dev(mtype))->gvt;
-
-	type = &gvt->types[mtype_get_type_group_id(mtype)];
-	if (!type)
-		return 0;
-
-	return sprintf(buf, "%s\n", type->name);
+	return sprintf(buf, "%s\n", mtype->sysfs_name);
 }
 
 static MDEV_TYPE_ATTR_RO(available_instances);
@@ -173,7 +155,7 @@ static MDEV_TYPE_ATTR_RO(device_api);
 static MDEV_TYPE_ATTR_RO(description);
 static MDEV_TYPE_ATTR_RO(name);
 
-static struct attribute *gvt_type_attrs[] = {
+static const struct attribute *gvt_type_attrs[] = {
 	&mdev_type_attr_available_instances.attr,
 	&mdev_type_attr_device_api.attr,
 	&mdev_type_attr_description.attr,
@@ -181,51 +163,6 @@ static struct attribute *gvt_type_attrs[] = {
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
@@ -1614,14 +1551,11 @@ static int intel_vgpu_probe(struct mdev_device *mdev)
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
 	vgpu = intel_gvt_create_vgpu(gvt, type->conf);
 	if (IS_ERR(vgpu)) {
 		gvt_err("failed to create intel vgpu: %ld\n", PTR_ERR(vgpu));
@@ -1660,7 +1594,7 @@ static struct mdev_driver intel_vgpu_mdev_driver = {
 	},
 	.probe		= intel_vgpu_probe,
 	.remove		= intel_vgpu_remove,
-	.supported_type_groups	= gvt_vgpu_type_groups,
+	.types_attrs	= gvt_type_attrs,
 };
 
 int intel_gvt_page_track_add(struct intel_vgpu *info, u64 gfn)
@@ -1959,7 +1893,6 @@ static void intel_gvt_clean_device(struct drm_i915_private *i915)
 		return;
 
 	mdev_unregister_parent(&gvt->parent);
-	intel_gvt_cleanup_vgpu_type_groups(gvt);
 	intel_gvt_destroy_idle_vgpu(gvt->idle_vgpu);
 	intel_gvt_clean_vgpu_types(gvt);
 
@@ -2059,20 +1992,15 @@ static int intel_gvt_init_device(struct drm_i915_private *i915)
 
 	intel_gvt_debugfs_init(gvt);
 
-	ret = intel_gvt_init_vgpu_type_groups(gvt);
-	if (ret)
-		goto out_destroy_idle_vgpu;
-
 	ret = mdev_register_parent(&gvt->parent, i915->drm.dev,
-				   &intel_vgpu_mdev_driver);
+				   &intel_vgpu_mdev_driver,
+				   gvt->mdev_types, gvt->num_types);
 	if (ret)
-		goto out_cleanup_vgpu_type_groups;
+		goto out_destroy_idle_vgpu;
 
 	gvt_dbg_core("gvt device initialization is done\n");
 	return 0;
 
-out_cleanup_vgpu_type_groups:
-	intel_gvt_cleanup_vgpu_type_groups(gvt);
 out_destroy_idle_vgpu:
 	intel_gvt_destroy_idle_vgpu(gvt->idle_vgpu);
 	intel_gvt_debugfs_clean(gvt);
diff --git a/drivers/gpu/drm/i915/gvt/vgpu.c b/drivers/gpu/drm/i915/gvt/vgpu.c
index 8e136dcc70112..ff240503d4125 100644
--- a/drivers/gpu/drm/i915/gvt/vgpu.c
+++ b/drivers/gpu/drm/i915/gvt/vgpu.c
@@ -113,13 +113,18 @@ int intel_gvt_init_vgpu_types(struct intel_gvt *gvt)
 	if (!gvt->types)
 		return -ENOMEM;
 
+	gvt->mdev_types = kcalloc(num_types, sizeof(*gvt->mdev_types),
+			     GFP_KERNEL);
+	if (!gvt->mdev_types)
+		goto out_free_types;
+
 	for (i = 0; i < num_types; ++i) {
 		const struct intel_vgpu_config *conf = &intel_vgpu_configs[i];
 
 		if (low_avail / conf->low_mm == 0)
 			break;
 		if (conf->weight < 1 || conf->weight > VGPU_MAX_WEIGHT)
-			goto out_free_types;
+			goto out_free_mdev_types;
 
 		sprintf(gvt->types[i].name, "GVTg_V%u_%s",
 			GRAPHICS_VER(gvt->gt->i915) == 8 ? 4 : 5, conf->name);
@@ -131,11 +136,16 @@ int intel_gvt_init_vgpu_types(struct intel_gvt *gvt)
 			     i, gvt->types[i].name, gvt->types[i].avail_instance,
 			     conf->low_mm, conf->high_mm, conf->fence,
 			     conf->weight, vgpu_edid_str(conf->edid));
+
+		gvt->mdev_types[i] = &gvt->types[i].type;
+		gvt->mdev_types[i]->sysfs_name = gvt->types[i].name;
 	}
 
 	gvt->num_types = i;
 	return 0;
 
+out_free_mdev_types:
+	kfree(gvt->mdev_types);
 out_free_types:
 	kfree(gvt->types);
 	return -EINVAL;
@@ -143,6 +153,7 @@ int intel_gvt_init_vgpu_types(struct intel_gvt *gvt)
 
 void intel_gvt_clean_vgpu_types(struct intel_gvt *gvt)
 {
+	kfree(gvt->mdev_types);
 	kfree(gvt->types);
 }
 
diff --git a/drivers/s390/cio/cio.h b/drivers/s390/cio/cio.h
index 22be5ac7d23c1..1da45307a1862 100644
--- a/drivers/s390/cio/cio.h
+++ b/drivers/s390/cio/cio.h
@@ -110,6 +110,8 @@ struct subchannel {
 	 */
 	const char *driver_override;
 	struct mdev_parent parent;
+	struct mdev_type mdev_type;
+	struct mdev_type *mdev_types[1];
 } __attribute__ ((aligned(8)));
 
 DECLARE_PER_CPU_ALIGNED(struct irb, cio_irb);
diff --git a/drivers/s390/cio/vfio_ccw_ops.c b/drivers/s390/cio/vfio_ccw_ops.c
index 9192a21085ce4..1bb30313a630c 100644
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
@@ -654,13 +644,16 @@ struct mdev_driver vfio_ccw_mdev_driver = {
 	},
 	.probe = vfio_ccw_mdev_probe,
 	.remove = vfio_ccw_mdev_remove,
-	.supported_type_groups  = mdev_type_groups,
+	.types_attrs = mdev_types_attrs,
 };
 
 int vfio_ccw_mdev_reg(struct subchannel *sch)
 {
+	sch->mdev_type.sysfs_name = "io";
+	sch->mdev_types[0] = &sch->mdev_type;
 	return mdev_register_parent(&sch->parent, &sch->dev,
-				    &vfio_ccw_mdev_driver);
+				    &vfio_ccw_mdev_driver, sch->mdev_types,
+				    1);
 }
 
 void vfio_ccw_mdev_unreg(struct subchannel *sch)
diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 834945150dc9f..41e8ecb7f56b9 100644
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
@@ -1472,7 +1462,7 @@ static struct mdev_driver vfio_ap_matrix_driver = {
 	},
 	.probe = vfio_ap_mdev_probe,
 	.remove = vfio_ap_mdev_remove,
-	.supported_type_groups = vfio_ap_mdev_type_groups,
+	.types_attrs = vfio_ap_mdev_type_attrs,
 };
 
 int vfio_ap_mdev_register(void)
@@ -1485,8 +1475,11 @@ int vfio_ap_mdev_register(void)
 	if (ret)
 		return ret;
 
+	matrix_dev->mdev_type.sysfs_name = VFIO_AP_MDEV_TYPE_HWVIRT;
+	matrix_dev->mdev_types[0] = &matrix_dev->mdev_type;
 	ret = mdev_register_parent(&matrix_dev->parent, &matrix_dev->device,
-				   &vfio_ap_matrix_driver);
+				   &vfio_ap_matrix_driver,
+				   matrix_dev->mdev_types, 1);
 	if (ret)
 		goto err_driver;
 	return 0;
diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
index 0191f6bc973a4..5dc5050d03791 100644
--- a/drivers/s390/crypto/vfio_ap_private.h
+++ b/drivers/s390/crypto/vfio_ap_private.h
@@ -46,6 +46,8 @@ struct ap_matrix_dev {
 	struct mutex lock;
 	struct ap_driver  *vfio_ap_drv;
 	struct mdev_parent parent;
+	struct mdev_type mdev_type;
+	struct mdev_type *mdev_types[];
 };
 
 extern struct ap_matrix_dev *matrix_dev;
diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
index fa05ac3396950..2d95a497fd3b2 100644
--- a/drivers/vfio/mdev/mdev_core.c
+++ b/drivers/vfio/mdev/mdev_core.c
@@ -29,26 +29,6 @@ struct device *mdev_parent_dev(struct mdev_device *mdev)
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
@@ -85,6 +65,8 @@ static int mdev_device_remove_cb(struct device *dev, void *data)
  * @parent: parent structure registered
  * @dev: device structure representing parent device.
  * @mdev_driver: Device driver to bind to the newly created mdev
+ * @types: Array of supported mdev types
+ * @nr_types: Number of entries in @types
  *
  * Registers the @parent stucture as a parent for mdev types and thus mdev
  * devices.  The caller needs to hold a reference on @dev that must not be
@@ -93,20 +75,19 @@ static int mdev_device_remove_cb(struct device *dev, void *data)
  * Returns a negative value on error, otherwise 0.
  */
 int mdev_register_parent(struct mdev_parent *parent, struct device *dev,
-		struct mdev_driver *mdev_driver)
+		struct mdev_driver *mdev_driver, struct mdev_type **types,
+		unsigned int nr_types)
 {
 	char *env_string = "MDEV_STATE=registered";
 	char *envp[] = { env_string, NULL };
 	int ret;
 
-	/* check for mandatory ops */
-	if (!mdev_driver->supported_type_groups)
-		return -EINVAL;
-
 	memset(parent, 0, sizeof(*parent));
 	init_rwsem(&parent->unreg_sem);
 	parent->dev = dev;
 	parent->mdev_driver = mdev_driver;
+	parent->types = types;
+	parent->nr_types = nr_types;
 
 	if (!mdev_bus_compat_class) {
 		mdev_bus_compat_class = class_compat_register("mdev_bus");
diff --git a/drivers/vfio/mdev/mdev_driver.c b/drivers/vfio/mdev/mdev_driver.c
index 7bd4bb9850e81..1da1ecf76a0d5 100644
--- a/drivers/vfio/mdev/mdev_driver.c
+++ b/drivers/vfio/mdev/mdev_driver.c
@@ -56,10 +56,9 @@ EXPORT_SYMBOL_GPL(mdev_bus_type);
  **/
 int mdev_register_driver(struct mdev_driver *drv)
 {
-	/* initialize common driver fields */
+	if (!drv->types_attrs)
+		return -EINVAL;
 	drv->driver.bus = &mdev_bus_type;
-
-	/* register with core */
 	return driver_register(&drv->driver);
 }
 EXPORT_SYMBOL(mdev_register_driver);
diff --git a/drivers/vfio/mdev/mdev_private.h b/drivers/vfio/mdev/mdev_private.h
index 297f911fdc890..ba1b2dbddc0bc 100644
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
diff --git a/drivers/vfio/mdev/mdev_sysfs.c b/drivers/vfio/mdev/mdev_sysfs.c
index b71ffc5594870..80b2d546a3d98 100644
--- a/drivers/vfio/mdev/mdev_sysfs.c
+++ b/drivers/vfio/mdev/mdev_sysfs.c
@@ -90,35 +90,21 @@ static struct kobj_type mdev_type_ktype = {
 	.release = mdev_type_release,
 };
 
-static struct mdev_type *add_mdev_supported_type(struct mdev_parent *parent,
-						 unsigned int type_group_id)
+static int mdev_type_add(struct mdev_parent *parent, struct mdev_type *type)
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
 	type->kobj.kset = parent->mdev_types_kset;
 	type->parent = parent;
 	/* Pairs with the put in mdev_type_release() */
 	get_device(parent->dev);
-	type->type_group_id = type_group_id;
 
 	ret = kobject_init_and_add(&type->kobj, &mdev_type_ktype, NULL,
 				   "%s-%s", dev_driver_string(parent->dev),
-				   group->name);
+				   type->sysfs_name);
 	if (ret) {
 		kobject_put(&type->kobj);
-		return ERR_PTR(ret);
+		return ret;
 	}
 
 	ret = sysfs_create_file(&type->kobj, &mdev_type_attr_create.attr);
@@ -131,13 +117,10 @@ static struct mdev_type *add_mdev_supported_type(struct mdev_parent *parent,
 		goto attr_devices_failed;
 	}
 
-	ret = sysfs_create_files(&type->kobj,
-				 (const struct attribute **)group->attrs);
-	if (ret) {
-		ret = -ENOMEM;
+	ret = sysfs_create_files(&type->kobj, parent->mdev_driver->types_attrs);
+	if (ret)
 		goto attrs_failed;
-	}
-	return type;
+	return 0;
 
 attrs_failed:
 	kobject_put(type->devices_kobj);
@@ -146,78 +129,49 @@ static struct mdev_type *add_mdev_supported_type(struct mdev_parent *parent,
 attr_create_failed:
 	kobject_del(&type->kobj);
 	kobject_put(&type->kobj);
-	return ERR_PTR(ret);
+	return ret;
 }
 
-static void remove_mdev_supported_type(struct mdev_type *type)
+static void mdev_type_remove(struct mdev_type *type)
 {
-	struct attribute_group *group =
-		type->parent->mdev_driver->supported_type_groups[type->type_group_id];
+	sysfs_remove_files(&type->kobj, type->parent->mdev_driver->types_attrs);
 
-	sysfs_remove_files(&type->kobj,
-			   (const struct attribute **)group->attrs);
 	kobject_put(type->devices_kobj);
 	sysfs_remove_file(&type->kobj, &mdev_type_attr_create.attr);
 	kobject_del(&type->kobj);
 	kobject_put(&type->kobj);
 }
 
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
 /* mdev sysfs functions */
 void parent_remove_sysfs_files(struct mdev_parent *parent)
 {
-	struct mdev_type *type, *tmp;
-
-	list_for_each_entry_safe(type, tmp, &parent->type_list, next) {
-		list_del(&type->next);
-		remove_mdev_supported_type(type);
-	}
+	int i;
 
+	for (i = 0; i < parent->nr_types; i++)
+		mdev_type_remove(parent->types[i]);
 	kset_unregister(parent->mdev_types_kset);
 }
 
 int parent_create_sysfs_files(struct mdev_parent *parent)
 {
-	int ret;
+	int ret, i;
 
 	parent->mdev_types_kset = kset_create_and_add("mdev_supported_types",
 					       NULL, &parent->dev->kobj);
-
 	if (!parent->mdev_types_kset)
 		return -ENOMEM;
 
-	INIT_LIST_HEAD(&parent->type_list);
-
-	ret = add_mdev_supported_type_groups(parent);
-	if (ret)
-		goto create_err;
+	for (i = 0; i < parent->nr_types; i++) {
+		ret = mdev_type_add(parent, parent->types[i]);
+		if (ret)
+			goto out_err;
+	}
 	return 0;
 
-create_err:
-	kset_unregister(parent->mdev_types_kset);
-	return ret;
+out_err:
+	while (--i >= 0)
+		mdev_type_remove(parent->types[i]);
+	return 0;
 }
 
 static ssize_t remove_store(struct device *dev, struct device_attribute *attr,
diff --git a/include/linux/mdev.h b/include/linux/mdev.h
index 327ce3e5c6b5f..cc70cc1e25d91 100644
--- a/include/linux/mdev.h
+++ b/include/linux/mdev.h
@@ -23,14 +23,27 @@ struct mdev_device {
 	bool active;
 };
 
+struct mdev_type {
+	/* set by the driver before calling mdev_register parent: */
+	const char *sysfs_name;
+
+	/* set by the core, can be used drivers */
+	struct mdev_parent *parent;
+
+	/* internal only */
+	struct kobject kobj;
+	struct kobject *devices_kobj;
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
+	struct mdev_type **types;
+	unsigned int nr_types;
 };
 
 static inline struct mdev_device *to_mdev_device(struct device *dev)
@@ -38,8 +51,6 @@ static inline struct mdev_device *to_mdev_device(struct device *dev)
 	return container_of(dev, struct mdev_device, dev);
 }
 
-unsigned int mdev_get_type_group_id(struct mdev_device *mdev);
-unsigned int mtype_get_type_group_id(struct mdev_type *mtype);
 struct device *mtype_get_parent_dev(struct mdev_type *mtype);
 
 /* interface for exporting mdev supported type attributes */
@@ -66,15 +77,13 @@ struct mdev_type_attribute mdev_type_attr_##_name =		\
  * struct mdev_driver - Mediated device driver
  * @probe: called when new device created
  * @remove: called when device removed
- * @supported_type_groups: Attributes to define supported types. It is mandatory
- *			to provide supported types.
+ * @types_attrs: attributes to the type kobjects.
  * @driver: device driver structure
- *
  **/
 struct mdev_driver {
 	int (*probe)(struct mdev_device *dev);
 	void (*remove)(struct mdev_device *dev);
-	struct attribute_group **supported_type_groups;
+	const struct attribute * const *types_attrs;
 	struct device_driver driver;
 };
 
@@ -86,7 +95,8 @@ static inline const guid_t *mdev_uuid(struct mdev_device *mdev)
 extern struct bus_type mdev_bus_type;
 
 int mdev_register_parent(struct mdev_parent *parent, struct device *dev,
-		struct mdev_driver *mdev_driver);
+		struct mdev_driver *mdev_driver, struct mdev_type **types,
+		unsigned int nr_types);
 void mdev_unregister_parent(struct mdev_parent *parent);
 
 int mdev_register_driver(struct mdev_driver *drv);
diff --git a/samples/vfio-mdev/mbochs.c b/samples/vfio-mdev/mbochs.c
index 30b3643b3b389..1069f561cb012 100644
--- a/samples/vfio-mdev/mbochs.c
+++ b/samples/vfio-mdev/mbochs.c
@@ -99,23 +99,27 @@ MODULE_PARM_DESC(mem, "megabytes available to " MBOCHS_NAME " devices");
 #define MBOCHS_TYPE_2 "medium"
 #define MBOCHS_TYPE_3 "large"
 
-static const struct mbochs_type {
+static struct mbochs_type {
+	struct mdev_type type;
 	const char *name;
 	u32 mbytes;
 	u32 max_x;
 	u32 max_y;
 } mbochs_types[] = {
 	{
+		.type.sysfs_name	= MBOCHS_TYPE_1,
 		.name	= MBOCHS_CLASS_NAME "-" MBOCHS_TYPE_1,
 		.mbytes = 4,
 		.max_x  = 800,
 		.max_y  = 600,
 	}, {
+		.type.sysfs_name	= MBOCHS_TYPE_2,
 		.name	= MBOCHS_CLASS_NAME "-" MBOCHS_TYPE_2,
 		.mbytes = 16,
 		.max_x  = 1920,
 		.max_y  = 1440,
 	}, {
+		.type.sysfs_name	= MBOCHS_TYPE_3,
 		.name	= MBOCHS_CLASS_NAME "-" MBOCHS_TYPE_3,
 		.mbytes = 64,
 		.max_x  = 0,
@@ -123,6 +127,11 @@ static const struct mbochs_type {
 	},
 };
 
+static struct mdev_type *mbochs_mdev_types[] = {
+	&mbochs_types[0].type,
+	&mbochs_types[1].type,
+	&mbochs_types[2].type,
+};
 
 static dev_t		mbochs_devt;
 static struct class	*mbochs_class;
@@ -508,8 +517,8 @@ static int mbochs_reset(struct mdev_state *mdev_state)
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
@@ -1328,8 +1337,8 @@ static const struct attribute_group *mdev_dev_groups[] = {
 static ssize_t name_show(struct mdev_type *mtype,
 			 struct mdev_type_attribute *attr, char *buf)
 {
-	const struct mbochs_type *type =
-		&mbochs_types[mtype_get_type_group_id(mtype)];
+	struct mbochs_type *type =
+		container_of(mtype, struct mbochs_type, type);
 
 	return sprintf(buf, "%s\n", type->name);
 }
@@ -1338,8 +1347,8 @@ static MDEV_TYPE_ATTR_RO(name);
 static ssize_t description_show(struct mdev_type *mtype,
 				struct mdev_type_attribute *attr, char *buf)
 {
-	const struct mbochs_type *type =
-		&mbochs_types[mtype_get_type_group_id(mtype)];
+	struct mbochs_type *type =
+		container_of(mtype, struct mbochs_type, type);
 
 	return sprintf(buf, "virtual display, %d MB video memory\n",
 		       type ? type->mbytes  : 0);
@@ -1350,8 +1359,8 @@ static ssize_t available_instances_show(struct mdev_type *mtype,
 					struct mdev_type_attribute *attr,
 					char *buf)
 {
-	const struct mbochs_type *type =
-		&mbochs_types[mtype_get_type_group_id(mtype)];
+	struct mbochs_type *type =
+		container_of(mtype, struct mbochs_type, type);
 	int count = atomic_read(&mbochs_avail_mbytes) / type->mbytes;
 
 	return sprintf(buf, "%d\n", count);
@@ -1365,7 +1374,7 @@ static ssize_t device_api_show(struct mdev_type *mtype,
 }
 static MDEV_TYPE_ATTR_RO(device_api);
 
-static struct attribute *mdev_types_attrs[] = {
+static const struct attribute *mdev_types_attrs[] = {
 	&mdev_type_attr_name.attr,
 	&mdev_type_attr_description.attr,
 	&mdev_type_attr_device_api.attr,
@@ -1373,28 +1382,6 @@ static struct attribute *mdev_types_attrs[] = {
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
@@ -1412,7 +1399,7 @@ static struct mdev_driver mbochs_driver = {
 	},
 	.probe = mbochs_probe,
 	.remove	= mbochs_remove,
-	.supported_type_groups = mdev_type_groups,
+	.types_attrs = mdev_types_attrs,
 };
 
 static const struct file_operations vd_fops = {
@@ -1457,7 +1444,9 @@ static int __init mbochs_dev_init(void)
 	if (ret)
 		goto err_class;
 
-	ret = mdev_register_parent(&mbochs_parent, &mbochs_dev, &mbochs_driver);
+	ret = mdev_register_parent(&mbochs_parent, &mbochs_dev, &mbochs_driver,
+				   mbochs_mdev_types,
+				   ARRAY_SIZE(mbochs_mdev_types));
 	if (ret)
 		goto err_device;
 
diff --git a/samples/vfio-mdev/mdpy.c b/samples/vfio-mdev/mdpy.c
index 132bb055628a6..2052cc27b1c6d 100644
--- a/samples/vfio-mdev/mdpy.c
+++ b/samples/vfio-mdev/mdpy.c
@@ -51,7 +51,8 @@ MODULE_PARM_DESC(count, "number of " MDPY_NAME " devices");
 #define MDPY_TYPE_2 "xga"
 #define MDPY_TYPE_3 "hd"
 
-static const struct mdpy_type {
+static struct mdpy_type {
+	struct mdev_type type;
 	const char *name;
 	u32 format;
 	u32 bytepp;
@@ -59,18 +60,21 @@ static const struct mdpy_type {
 	u32 height;
 } mdpy_types[] = {
 	{
+		.type.sysfs_name 	= MDPY_TYPE_1,
 		.name	= MDPY_CLASS_NAME "-" MDPY_TYPE_1,
 		.format = DRM_FORMAT_XRGB8888,
 		.bytepp = 4,
 		.width	= 640,
 		.height = 480,
 	}, {
+		.type.sysfs_name 	= MDPY_TYPE_2,
 		.name	= MDPY_CLASS_NAME "-" MDPY_TYPE_2,
 		.format = DRM_FORMAT_XRGB8888,
 		.bytepp = 4,
 		.width	= 1024,
 		.height = 768,
 	}, {
+		.type.sysfs_name 	= MDPY_TYPE_3,
 		.name	= MDPY_CLASS_NAME "-" MDPY_TYPE_3,
 		.format = DRM_FORMAT_XRGB8888,
 		.bytepp = 4,
@@ -79,6 +83,12 @@ static const struct mdpy_type {
 	},
 };
 
+static struct mdev_type *mdpy_mdev_types[] = {
+	&mdpy_types[0].type,
+	&mdpy_types[1].type,
+	&mdpy_types[2].type,
+};
+
 static dev_t		mdpy_devt;
 static struct class	*mdpy_class;
 static struct cdev	mdpy_cdev;
@@ -219,7 +229,7 @@ static int mdpy_reset(struct mdev_state *mdev_state)
 static int mdpy_probe(struct mdev_device *mdev)
 {
 	const struct mdpy_type *type =
-		&mdpy_types[mdev_get_type_group_id(mdev)];
+		container_of(mdev->type, struct mdpy_type, type);
 	struct device *dev = mdev_dev(mdev);
 	struct mdev_state *mdev_state;
 	u32 fbsize;
@@ -644,8 +654,7 @@ static const struct attribute_group *mdev_dev_groups[] = {
 static ssize_t name_show(struct mdev_type *mtype,
 			 struct mdev_type_attribute *attr, char *buf)
 {
-	const struct mdpy_type *type =
-		&mdpy_types[mtype_get_type_group_id(mtype)];
+	struct mdpy_type *type = container_of(mtype, struct mdpy_type, type);
 
 	return sprintf(buf, "%s\n", type->name);
 }
@@ -654,8 +663,7 @@ static MDEV_TYPE_ATTR_RO(name);
 static ssize_t description_show(struct mdev_type *mtype,
 				struct mdev_type_attribute *attr, char *buf)
 {
-	const struct mdpy_type *type =
-		&mdpy_types[mtype_get_type_group_id(mtype)];
+	struct mdpy_type *type = container_of(mtype, struct mdpy_type, type);
 
 	return sprintf(buf, "virtual display, %dx%d framebuffer\n",
 		       type->width, type->height);
@@ -677,7 +685,7 @@ static ssize_t device_api_show(struct mdev_type *mtype,
 }
 static MDEV_TYPE_ATTR_RO(device_api);
 
-static struct attribute *mdev_types_attrs[] = {
+static const struct attribute *mdev_types_attrs[] = {
 	&mdev_type_attr_name.attr,
 	&mdev_type_attr_description.attr,
 	&mdev_type_attr_device_api.attr,
@@ -685,28 +693,6 @@ static struct attribute *mdev_types_attrs[] = {
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
@@ -723,7 +709,7 @@ static struct mdev_driver mdpy_driver = {
 	},
 	.probe = mdpy_probe,
 	.remove	= mdpy_remove,
-	.supported_type_groups = mdev_type_groups,
+	.types_attrs = mdev_types_attrs,
 };
 
 static const struct file_operations vd_fops = {
@@ -766,7 +752,9 @@ static int __init mdpy_dev_init(void)
 	if (ret)
 		goto err_class;
 
-	ret = mdev_register_parent(&mdpy_parent, &mdpy_dev, &mdpy_driver);
+	ret = mdev_register_parent(&mdpy_parent, &mdpy_dev, &mdpy_driver,
+				   mdpy_mdev_types,
+				   ARRAY_SIZE(mdpy_mdev_types));
 	if (ret)
 		goto err_device;
 
diff --git a/samples/vfio-mdev/mtty.c b/samples/vfio-mdev/mtty.c
index 8ba5f6084a093..029a19ef8ce7b 100644
--- a/samples/vfio-mdev/mtty.c
+++ b/samples/vfio-mdev/mtty.c
@@ -143,6 +143,20 @@ struct mdev_state {
 	int nr_ports;
 };
 
+static struct mtty_type {
+	struct mdev_type type;
+	int nr_ports;
+	const char *name;
+} mtty_types[2] = {
+	{ .nr_ports = 1, .type.sysfs_name = "1", .name = "Single port serial" },
+	{ .nr_ports = 2, .type.sysfs_name = "2", .name = "Dual port serial" },
+};
+
+static struct mdev_type *mtty_mdev_types[] = {
+	&mtty_types[0].type,
+	&mtty_types[1].type,
+};
+
 static atomic_t mdev_avail_ports = ATOMIC_INIT(MAX_MTTYS);
 
 static const struct file_operations vd_fops = {
@@ -704,16 +718,18 @@ static ssize_t mdev_access(struct mdev_state *mdev_state, u8 *buf, size_t count,
 
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
@@ -723,13 +739,13 @@ static int mtty_probe(struct mdev_device *mdev)
 
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
@@ -752,7 +768,7 @@ static int mtty_probe(struct mdev_device *mdev)
 	vfio_uninit_group_dev(&mdev_state->vdev);
 	kfree(mdev_state);
 err_nr_ports:
-	atomic_add(nr_ports, &mdev_avail_ports);
+	atomic_add(type->nr_ports, &mdev_avail_ports);
 	return ret;
 }
 
@@ -1233,11 +1249,9 @@ static const struct attribute_group *mdev_dev_groups[] = {
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
@@ -1246,9 +1260,10 @@ static ssize_t available_instances_show(struct mdev_type *mtype,
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
@@ -1261,29 +1276,13 @@ static ssize_t device_api_show(struct mdev_type *mtype,
 
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
@@ -1300,7 +1299,7 @@ static struct mdev_driver mtty_driver = {
 	},
 	.probe = mtty_probe,
 	.remove	= mtty_remove,
-	.supported_type_groups = mdev_type_groups,
+	.types_attrs = mdev_types_attrs,
 };
 
 static void mtty_device_release(struct device *dev)
@@ -1352,7 +1351,8 @@ static int __init mtty_dev_init(void)
 		goto err_class;
 
 	ret = mdev_register_parent(&mtty_dev.parent, &mtty_dev.dev,
-				   &mtty_driver);
+				   &mtty_driver, mtty_mdev_types,
+				   ARRAY_SIZE(mtty_mdev_types));
 	if (ret)
 		goto err_device;
 	return 0;
-- 
2.30.2

