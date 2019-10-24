Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 744E5E29C8
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2019 07:08:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437472AbfJXFIm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Oct 2019 01:08:42 -0400
Received: from mga11.intel.com ([192.55.52.93]:7748 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437478AbfJXFIm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Oct 2019 01:08:42 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Oct 2019 22:08:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,223,1569308400"; 
   d="scan'208";a="197627663"
Received: from debian-nuc.sh.intel.com ([10.239.160.133])
  by fmsmga007.fm.intel.com with ESMTP; 23 Oct 2019 22:08:40 -0700
From:   Zhenyu Wang <zhenyuw@linux.intel.com>
To:     kvm@vger.kernel.org
Cc:     alex.williamson@redhat.com, kwankhede@nvidia.com,
        kevin.tian@intel.com, cohuck@redhat.com
Subject: [PATCH 6/6] drm/i915/gvt: Add new type with aggregation support
Date:   Thu, 24 Oct 2019 13:08:29 +0800
Message-Id: <20191024050829.4517-7-zhenyuw@linux.intel.com>
X-Mailer: git-send-email 2.24.0.rc0
In-Reply-To: <20191024050829.4517-1-zhenyuw@linux.intel.com>
References: <20191024050829.4517-1-zhenyuw@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

New aggregation type is created for KVMGT which can be used
to combine minimal resource number for target instances, to create
user defined number of resources. For KVMGT, aggregated resource
is determined by memory and fence resource allocation for target
number of instances.

Cc: Kirti Wankhede <kwankhede@nvidia.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Cornelia Huck <cohuck@redhat.com>
Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
---
v2:
- apply for new hooks
v3:
- show aggregation info in description

 drivers/gpu/drm/i915/gvt/gvt.c   |  4 +--
 drivers/gpu/drm/i915/gvt/gvt.h   | 11 +++++--
 drivers/gpu/drm/i915/gvt/kvmgt.c | 53 ++++++++++++++++++++++++++++--
 drivers/gpu/drm/i915/gvt/vgpu.c  | 56 ++++++++++++++++++++++++++++++--
 4 files changed, 114 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/i915/gvt/gvt.c b/drivers/gpu/drm/i915/gvt/gvt.c
index 8f37eefa0a02..e8b82c925bba 100644
--- a/drivers/gpu/drm/i915/gvt/gvt.c
+++ b/drivers/gpu/drm/i915/gvt/gvt.c
@@ -98,11 +98,11 @@ static ssize_t description_show(struct kobject *kobj, struct device *dev,
 
 	return sprintf(buf, "low_gm_size: %dMB\nhigh_gm_size: %dMB\n"
 		       "fence: %d\nresolution: %s\n"
-		       "weight: %d\n",
+		       "weight: %d\naggregation: %s\n",
 		       BYTES_TO_MB(type->low_gm_size),
 		       BYTES_TO_MB(type->high_gm_size),
 		       type->fence, vgpu_edid_str(type->resolution),
-		       type->weight);
+		       type->weight, type->aggregation ? "gm" : "none");
 }
 
 static MDEV_TYPE_ATTR_RO(available_instances);
diff --git a/drivers/gpu/drm/i915/gvt/gvt.h b/drivers/gpu/drm/i915/gvt/gvt.h
index b47c6acaf9c0..9eb410257216 100644
--- a/drivers/gpu/drm/i915/gvt/gvt.h
+++ b/drivers/gpu/drm/i915/gvt/gvt.h
@@ -238,6 +238,9 @@ struct intel_vgpu {
 struct intel_gvt_gm {
 	unsigned long vgpu_allocated_low_gm_size;
 	unsigned long vgpu_allocated_high_gm_size;
+	unsigned long low_avail;
+	unsigned long high_avail;
+	unsigned long fence_avail;
 };
 
 struct intel_gvt_fence {
@@ -289,13 +292,15 @@ struct intel_gvt_firmware {
 
 #define NR_MAX_INTEL_VGPU_TYPES 20
 struct intel_vgpu_type {
-	char name[16];
+	const char *drv_name;
+	char name[32];
 	unsigned int avail_instance;
 	unsigned int low_gm_size;
 	unsigned int high_gm_size;
 	unsigned int fence;
 	unsigned int weight;
 	enum intel_vgpu_edid resolution;
+	unsigned int aggregation;
 };
 
 struct intel_gvt {
@@ -481,7 +486,7 @@ void intel_gvt_clean_vgpu_types(struct intel_gvt *gvt);
 struct intel_vgpu *intel_gvt_create_idle_vgpu(struct intel_gvt *gvt);
 void intel_gvt_destroy_idle_vgpu(struct intel_vgpu *vgpu);
 struct intel_vgpu *intel_gvt_create_vgpu(struct intel_gvt *gvt,
-					 struct intel_vgpu_type *type);
+					 struct intel_vgpu_type *type, unsigned int);
 void intel_gvt_destroy_vgpu(struct intel_vgpu *vgpu);
 void intel_gvt_release_vgpu(struct intel_vgpu *vgpu);
 void intel_gvt_reset_vgpu_locked(struct intel_vgpu *vgpu, bool dmlr,
@@ -562,7 +567,7 @@ struct intel_gvt_ops {
 	int (*emulate_mmio_write)(struct intel_vgpu *, u64, void *,
 				unsigned int);
 	struct intel_vgpu *(*vgpu_create)(struct intel_gvt *,
-				struct intel_vgpu_type *);
+					  struct intel_vgpu_type *, unsigned int);
 	void (*vgpu_destroy)(struct intel_vgpu *vgpu);
 	void (*vgpu_release)(struct intel_vgpu *vgpu);
 	void (*vgpu_reset)(struct intel_vgpu *);
diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
index 04a5a0d90823..99b77f4d775c 100644
--- a/drivers/gpu/drm/i915/gvt/kvmgt.c
+++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
@@ -643,7 +643,9 @@ static void kvmgt_put_vfio_device(void *vgpu)
 	vfio_device_put(((struct intel_vgpu *)vgpu)->vdev.vfio_device);
 }
 
-static int intel_vgpu_create(struct kobject *kobj, struct mdev_device *mdev)
+static int intel_vgpu_create_internal(struct kobject *kobj,
+				      struct mdev_device *mdev,
+				      unsigned int instances)
 {
 	struct intel_vgpu *vgpu = NULL;
 	struct intel_vgpu_type *type;
@@ -662,7 +664,14 @@ static int intel_vgpu_create(struct kobject *kobj, struct mdev_device *mdev)
 		goto out;
 	}
 
-	vgpu = intel_gvt_ops->vgpu_create(gvt, type);
+	if (instances > 1 && instances > type->aggregation) {
+		gvt_vgpu_err("wrong aggregation specified for type %s\n",
+			     kobject_name(kobj));
+		ret = -EINVAL;
+		goto out;
+	}
+
+	vgpu = intel_gvt_ops->vgpu_create(gvt, type, instances);
 	if (IS_ERR_OR_NULL(vgpu)) {
 		ret = vgpu == NULL ? -EFAULT : PTR_ERR(vgpu);
 		gvt_err("failed to create intel vgpu: %d\n", ret);
@@ -682,6 +691,44 @@ static int intel_vgpu_create(struct kobject *kobj, struct mdev_device *mdev)
 	return ret;
 }
 
+static int intel_vgpu_create(struct kobject *kobj, struct mdev_device *mdev)
+{
+       return intel_vgpu_create_internal(kobj, mdev, 1);
+}
+
+static int intel_vgpu_create_with_instances(struct kobject *kobj,
+                                           struct mdev_device *mdev,
+                                           unsigned int instances)
+{
+       return intel_vgpu_create_internal(kobj, mdev, instances);
+}
+
+static int intel_vgpu_max_aggregated_instances(struct kobject *kobj,
+					       struct device *dev,
+					       unsigned int *max)
+{
+	struct intel_vgpu_type *type;
+	struct intel_gvt *gvt;
+	int ret = 0;
+
+	gvt = kdev_to_i915(dev)->gvt;
+
+	type = intel_gvt_ops->gvt_find_vgpu_type(gvt, kobject_name(kobj));
+	if (!type) {
+		gvt_err("failed to find type %s to create\n",
+						kobject_name(kobj));
+		ret = -EINVAL;
+		goto out;
+	}
+
+	if (type->aggregation == 0)
+		*max = 1;
+	else
+		*max = type->aggregation;
+out:
+	return ret;
+}
+
 static int intel_vgpu_remove(struct mdev_device *mdev)
 {
 	struct intel_vgpu *vgpu = mdev_get_drvdata(mdev);
@@ -1584,6 +1631,8 @@ static const struct attribute_group *intel_vgpu_groups[] = {
 static struct mdev_parent_ops intel_vgpu_ops = {
 	.mdev_attr_groups       = intel_vgpu_groups,
 	.create			= intel_vgpu_create,
+	.create_with_instances  = intel_vgpu_create_with_instances,
+	.max_aggregated_instances = intel_vgpu_max_aggregated_instances,
 	.remove			= intel_vgpu_remove,
 
 	.open			= intel_vgpu_open,
diff --git a/drivers/gpu/drm/i915/gvt/vgpu.c b/drivers/gpu/drm/i915/gvt/vgpu.c
index d5a6e4e3d0fd..d0780a2f7e69 100644
--- a/drivers/gpu/drm/i915/gvt/vgpu.c
+++ b/drivers/gpu/drm/i915/gvt/vgpu.c
@@ -108,6 +108,7 @@ int intel_gvt_init_vgpu_types(struct intel_gvt *gvt)
 	unsigned int num_types;
 	unsigned int i, low_avail, high_avail;
 	unsigned int min_low;
+	const char *driver_name = dev_driver_string(&gvt->dev_priv->drm.pdev->dev);
 
 	/* vGPU type name is defined as GVTg_Vx_y which contains
 	 * physical GPU generation type (e.g V4 as BDW server, V5 as
@@ -125,11 +126,15 @@ int intel_gvt_init_vgpu_types(struct intel_gvt *gvt)
 	high_avail = gvt_hidden_sz(gvt) - HOST_HIGH_GM_SIZE;
 	num_types = sizeof(vgpu_types) / sizeof(vgpu_types[0]);
 
-	gvt->types = kcalloc(num_types, sizeof(struct intel_vgpu_type),
+	gvt->types = kcalloc(num_types + 1, sizeof(struct intel_vgpu_type),
 			     GFP_KERNEL);
 	if (!gvt->types)
 		return -ENOMEM;
 
+	gvt->gm.low_avail = low_avail;
+	gvt->gm.high_avail = high_avail;
+	gvt->gm.fence_avail = 32 - HOST_FENCE;
+
 	min_low = MB_TO_BYTES(32);
 	for (i = 0; i < num_types; ++i) {
 		if (low_avail / vgpu_types[i].low_mm == 0)
@@ -147,6 +152,7 @@ int intel_gvt_init_vgpu_types(struct intel_gvt *gvt)
 		gvt->types[i].resolution = vgpu_types[i].edid;
 		gvt->types[i].avail_instance = min(low_avail / vgpu_types[i].low_mm,
 						   high_avail / vgpu_types[i].high_mm);
+		gvt->types[i].aggregation = 0;
 
 		if (IS_GEN(gvt->dev_priv, 8))
 			sprintf(gvt->types[i].name, "GVTg_V4_%s",
@@ -154,6 +160,7 @@ int intel_gvt_init_vgpu_types(struct intel_gvt *gvt)
 		else if (IS_GEN(gvt->dev_priv, 9))
 			sprintf(gvt->types[i].name, "GVTg_V5_%s",
 						vgpu_types[i].name);
+		gvt->types[i].drv_name = driver_name;
 
 		gvt_dbg_core("type[%d]: %s avail %u low %u high %u fence %u weight %u res %s\n",
 			     i, gvt->types[i].name,
@@ -164,7 +171,32 @@ int intel_gvt_init_vgpu_types(struct intel_gvt *gvt)
 			     vgpu_edid_str(gvt->types[i].resolution));
 	}
 
-	gvt->num_types = i;
+	/* add aggregation type */
+	gvt->types[i].low_gm_size = MB_TO_BYTES(32);
+	gvt->types[i].high_gm_size = MB_TO_BYTES(192);
+	gvt->types[i].fence = 2;
+	gvt->types[i].weight = 16;
+	gvt->types[i].resolution = GVT_EDID_1024_768;
+	gvt->types[i].avail_instance = min(low_avail / gvt->types[i].low_gm_size,
+					   high_avail / gvt->types[i].high_gm_size);
+	gvt->types[i].avail_instance = min(gvt->types[i].avail_instance,
+					   (32 - HOST_FENCE) / gvt->types[i].fence);
+	if (IS_GEN(gvt->dev_priv, 8))
+		strcat(gvt->types[i].name, "GVTg_V4_aggregate");
+	else if (IS_GEN(gvt->dev_priv, 9))
+		strcat(gvt->types[i].name, "GVTg_V5_aggregate");
+	gvt->types[i].drv_name = driver_name;
+
+	gvt_dbg_core("type[%d]: %s avail %u low %u high %u fence %u weight %u res %s\n",
+		     i, gvt->types[i].name,
+		     gvt->types[i].avail_instance,
+		     gvt->types[i].low_gm_size,
+		     gvt->types[i].high_gm_size, gvt->types[i].fence,
+		     gvt->types[i].weight,
+		     vgpu_edid_str(gvt->types[i].resolution));
+
+	gvt->types[i].aggregation = gvt->types[i].avail_instance;
+	gvt->num_types = ++i;
 	return 0;
 }
 
@@ -195,6 +227,8 @@ static void intel_gvt_update_vgpu_types(struct intel_gvt *gvt)
 		fence_min = fence_avail / gvt->types[i].fence;
 		gvt->types[i].avail_instance = min(min(low_gm_min, high_gm_min),
 						   fence_min);
+		if (gvt->types[i].aggregation > 1)
+			gvt->types[i].aggregation = gvt->types[i].avail_instance;
 
 		gvt_dbg_core("update type[%d]: %s avail %u low %u high %u fence %u\n",
 		       i, gvt->types[i].name,
@@ -468,7 +502,8 @@ static struct intel_vgpu *__intel_gvt_create_vgpu(struct intel_gvt *gvt,
  * pointer to intel_vgpu, error pointer if failed.
  */
 struct intel_vgpu *intel_gvt_create_vgpu(struct intel_gvt *gvt,
-				struct intel_vgpu_type *type)
+					 struct intel_vgpu_type *type,
+					 unsigned int instances)
 {
 	struct intel_vgpu_creation_params param;
 	struct intel_vgpu *vgpu;
@@ -485,6 +520,21 @@ struct intel_vgpu *intel_gvt_create_vgpu(struct intel_gvt *gvt,
 	param.low_gm_sz = BYTES_TO_MB(param.low_gm_sz);
 	param.high_gm_sz = BYTES_TO_MB(param.high_gm_sz);
 
+	if (instances > 1 && instances <= type->aggregation) {
+		if (instances > type->avail_instance)
+			return ERR_PTR(-EINVAL);
+		param.low_gm_sz = min(param.low_gm_sz * instances,
+				      (u64)BYTES_TO_MB(gvt->gm.low_avail));
+		param.high_gm_sz = min(param.high_gm_sz * instances,
+				       (u64)BYTES_TO_MB(gvt->gm.high_avail));
+		param.fence_sz = min(param.fence_sz * instances,
+				     (u64)gvt->gm.fence_avail);
+		type->aggregation -= instances;
+		gvt_dbg_core("instances %d, low %lluMB, high %lluMB, fence %llu, left %u\n",
+			     instances, param.low_gm_sz, param.high_gm_sz, param.fence_sz,
+			     type->aggregation);
+	}
+
 	mutex_lock(&gvt->lock);
 	vgpu = __intel_gvt_create_vgpu(gvt, &param);
 	if (!IS_ERR(vgpu))
-- 
2.24.0.rc0

