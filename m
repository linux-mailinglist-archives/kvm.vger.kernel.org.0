Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CC085E76F2
	for <lists+kvm@lfdr.de>; Fri, 23 Sep 2022 11:27:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231448AbiIWJ1S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Sep 2022 05:27:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231704AbiIWJ1N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Sep 2022 05:27:13 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF96312F74C;
        Fri, 23 Sep 2022 02:27:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=SY+Ocgn1/VwpnVnaRPaLEWEa7aHzVsm3mMyP6QY+xmA=; b=RBCGif9KUItyVq0tZNf4FLtwUs
        NIb26/UxSZXbi2iqqZKQ03Fyi0AC6YtL/GfAs/4hgOPEirHJ9w+QyAN4tgc/bckOvbK+gS1l72/QV
        /X/SdgJIPsv09KjNIEisa2EZJDVtNbHG/NSo+KUB20Khxc3ChhANq2bI6uSLJPVTgkIVpPdTFoFAN
        20LkBuilXb9B+psF8yQr89sReFpP0gK/TW+XNFZj+/stR9Fa3fjvtoQ9PuOxZ5FtroXa+6dCTgvy1
        rWYEKRUBT895RgwEdESmbxvEZemjF0hvZFsR3F/BW8TFcaXhymAOnWmKlQvrWo5VBehLzx2LRewwD
        4Se6EZPw==;
Received: from ip4d15bec4.dynamic.kabel-deutschland.de ([77.21.190.196] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1obexX-003Jgo-IB; Fri, 23 Sep 2022 09:27:00 +0000
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
        linux-s390@vger.kernel.org, intel-gvt-dev@lists.freedesktop.org
Subject: [PATCH 02/14] drm/i915/gvt: simplify vgpu configuration management
Date:   Fri, 23 Sep 2022 11:26:40 +0200
Message-Id: <20220923092652.100656-3-hch@lst.de>
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

Instead of copying the information from the vgpu_types arrays into each
intel_vgpu_type structure, just reference this constant information
with a pointer to the already existing data structure, and pass it into
the low-level VGPU creation helpers intead of copying the data into yet
anothe params data structure.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Zhenyu Wang <zhenyuw@linux.intel.com>
---
 drivers/gpu/drm/i915/gvt/aperture_gm.c |  20 ++--
 drivers/gpu/drm/i915/gvt/gvt.h         |  37 +++---
 drivers/gpu/drm/i915/gvt/kvmgt.c       |  10 +-
 drivers/gpu/drm/i915/gvt/vgpu.c        | 159 ++++++++-----------------
 4 files changed, 81 insertions(+), 145 deletions(-)

diff --git a/drivers/gpu/drm/i915/gvt/aperture_gm.c b/drivers/gpu/drm/i915/gvt/aperture_gm.c
index 3b81a6d35a7b2..076c779f776a6 100644
--- a/drivers/gpu/drm/i915/gvt/aperture_gm.c
+++ b/drivers/gpu/drm/i915/gvt/aperture_gm.c
@@ -240,13 +240,13 @@ static void free_resource(struct intel_vgpu *vgpu)
 }
 
 static int alloc_resource(struct intel_vgpu *vgpu,
-		struct intel_vgpu_creation_params *param)
+		const struct intel_vgpu_config *conf)
 {
 	struct intel_gvt *gvt = vgpu->gvt;
 	unsigned long request, avail, max, taken;
 	const char *item;
 
-	if (!param->low_gm_sz || !param->high_gm_sz || !param->fence_sz) {
+	if (!conf->low_mm || !conf->high_mm || !conf->fence) {
 		gvt_vgpu_err("Invalid vGPU creation params\n");
 		return -EINVAL;
 	}
@@ -255,7 +255,7 @@ static int alloc_resource(struct intel_vgpu *vgpu,
 	max = gvt_aperture_sz(gvt) - HOST_LOW_GM_SIZE;
 	taken = gvt->gm.vgpu_allocated_low_gm_size;
 	avail = max - taken;
-	request = MB_TO_BYTES(param->low_gm_sz);
+	request = conf->low_mm;
 
 	if (request > avail)
 		goto no_enough_resource;
@@ -266,7 +266,7 @@ static int alloc_resource(struct intel_vgpu *vgpu,
 	max = gvt_hidden_sz(gvt) - HOST_HIGH_GM_SIZE;
 	taken = gvt->gm.vgpu_allocated_high_gm_size;
 	avail = max - taken;
-	request = MB_TO_BYTES(param->high_gm_sz);
+	request = conf->high_mm;
 
 	if (request > avail)
 		goto no_enough_resource;
@@ -277,16 +277,16 @@ static int alloc_resource(struct intel_vgpu *vgpu,
 	max = gvt_fence_sz(gvt) - HOST_FENCE;
 	taken = gvt->fence.vgpu_allocated_fence_num;
 	avail = max - taken;
-	request = param->fence_sz;
+	request = conf->fence;
 
 	if (request > avail)
 		goto no_enough_resource;
 
 	vgpu_fence_sz(vgpu) = request;
 
-	gvt->gm.vgpu_allocated_low_gm_size += MB_TO_BYTES(param->low_gm_sz);
-	gvt->gm.vgpu_allocated_high_gm_size += MB_TO_BYTES(param->high_gm_sz);
-	gvt->fence.vgpu_allocated_fence_num += param->fence_sz;
+	gvt->gm.vgpu_allocated_low_gm_size += conf->low_mm;
+	gvt->gm.vgpu_allocated_high_gm_size += conf->high_mm;
+	gvt->fence.vgpu_allocated_fence_num += conf->fence;
 	return 0;
 
 no_enough_resource:
@@ -340,11 +340,11 @@ void intel_vgpu_reset_resource(struct intel_vgpu *vgpu)
  *
  */
 int intel_vgpu_alloc_resource(struct intel_vgpu *vgpu,
-		struct intel_vgpu_creation_params *param)
+		const struct intel_vgpu_config *conf)
 {
 	int ret;
 
-	ret = alloc_resource(vgpu, param);
+	ret = alloc_resource(vgpu, conf);
 	if (ret)
 		return ret;
 
diff --git a/drivers/gpu/drm/i915/gvt/gvt.h b/drivers/gpu/drm/i915/gvt/gvt.h
index 89fab7896fc6a..563ffc2fdfb7a 100644
--- a/drivers/gpu/drm/i915/gvt/gvt.h
+++ b/drivers/gpu/drm/i915/gvt/gvt.h
@@ -294,15 +294,26 @@ struct intel_gvt_firmware {
 	bool firmware_loaded;
 };
 
+struct intel_vgpu_config {
+	unsigned int low_mm;
+	unsigned int high_mm;
+	unsigned int fence;
+
+	/*
+	 * A vGPU with a weight of 8 will get twice as much GPU as a vGPU with
+	 * a weight of 4 on a contended host, different vGPU type has different
+	 * weight set. Legal weights range from 1 to 16.
+	 */
+	unsigned int weight;
+	enum intel_vgpu_edid edid;
+	const char *name;
+};
+
 #define NR_MAX_INTEL_VGPU_TYPES 20
 struct intel_vgpu_type {
 	char name[16];
+	const struct intel_vgpu_config *conf;
 	unsigned int avail_instance;
-	unsigned int low_gm_size;
-	unsigned int high_gm_size;
-	unsigned int fence;
-	unsigned int weight;
-	enum intel_vgpu_edid resolution;
 };
 
 struct intel_gvt {
@@ -436,19 +447,8 @@ int intel_gvt_load_firmware(struct intel_gvt *gvt);
 /* ring context size i.e. the first 0x50 dwords*/
 #define RING_CTX_SIZE 320
 
-struct intel_vgpu_creation_params {
-	__u64 low_gm_sz;  /* in MB */
-	__u64 high_gm_sz; /* in MB */
-	__u64 fence_sz;
-	__u64 resolution;
-	__s32 primary;
-	__u64 vgpu_id;
-
-	__u32 weight;
-};
-
 int intel_vgpu_alloc_resource(struct intel_vgpu *vgpu,
-			      struct intel_vgpu_creation_params *param);
+			      const struct intel_vgpu_config *conf);
 void intel_vgpu_reset_resource(struct intel_vgpu *vgpu);
 void intel_vgpu_free_resource(struct intel_vgpu *vgpu);
 void intel_vgpu_write_fence(struct intel_vgpu *vgpu,
@@ -494,7 +494,8 @@ void intel_gvt_clean_vgpu_types(struct intel_gvt *gvt);
 
 struct intel_vgpu *intel_gvt_create_idle_vgpu(struct intel_gvt *gvt);
 void intel_gvt_destroy_idle_vgpu(struct intel_vgpu *vgpu);
-int intel_gvt_create_vgpu(struct intel_vgpu *vgpu, struct intel_vgpu_type *type);
+int intel_gvt_create_vgpu(struct intel_vgpu *vgpu,
+			  const struct intel_vgpu_config *conf);
 void intel_gvt_destroy_vgpu(struct intel_vgpu *vgpu);
 void intel_gvt_release_vgpu(struct intel_vgpu *vgpu);
 void intel_gvt_reset_vgpu_locked(struct intel_vgpu *vgpu, bool dmlr,
diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
index 41bba40feef8f..aa329f8bfe420 100644
--- a/drivers/gpu/drm/i915/gvt/kvmgt.c
+++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
@@ -151,10 +151,10 @@ static ssize_t description_show(struct mdev_type *mtype,
 	return sprintf(buf, "low_gm_size: %dMB\nhigh_gm_size: %dMB\n"
 		       "fence: %d\nresolution: %s\n"
 		       "weight: %d\n",
-		       BYTES_TO_MB(type->low_gm_size),
-		       BYTES_TO_MB(type->high_gm_size),
-		       type->fence, vgpu_edid_str(type->resolution),
-		       type->weight);
+		       BYTES_TO_MB(type->conf->low_mm),
+		       BYTES_TO_MB(type->conf->high_mm),
+		       type->conf->fence, vgpu_edid_str(type->conf->edid),
+		       type->conf->weight);
 }
 
 static ssize_t name_show(struct mdev_type *mtype,
@@ -1559,7 +1559,7 @@ static int intel_vgpu_init_dev(struct vfio_device *vfio_dev)
 		return -EINVAL;
 
 	vgpu->gvt = gvt;
-	return intel_gvt_create_vgpu(vgpu, type);
+	return intel_gvt_create_vgpu(vgpu, type->conf);
 }
 
 static void intel_vgpu_release_dev(struct vfio_device *vfio_dev)
diff --git a/drivers/gpu/drm/i915/gvt/vgpu.c b/drivers/gpu/drm/i915/gvt/vgpu.c
index dbb2a971ba5d8..1b67328c714f1 100644
--- a/drivers/gpu/drm/i915/gvt/vgpu.c
+++ b/drivers/gpu/drm/i915/gvt/vgpu.c
@@ -73,24 +73,21 @@ void populate_pvinfo_page(struct intel_vgpu *vgpu)
 	drm_WARN_ON(&i915->drm, sizeof(struct vgt_if) != VGT_PVINFO_SIZE);
 }
 
+/*
+ * vGPU type name is defined as GVTg_Vx_y which contains the physical GPU
+ * generation type (e.g V4 as BDW server, V5 as SKL server).
+ *
+ * Depening on the physical SKU resource, we might see vGPU types like
+ * GVTg_V4_8, GVTg_V4_4, GVTg_V4_2, etc. We can create different types of
+ * vGPU on same physical GPU depending on available resource. Each vGPU
+ * type will have a different number of avail_instance to indicate how
+ * many vGPU instance can be created for this type.
+ */
 #define VGPU_MAX_WEIGHT 16
 #define VGPU_WEIGHT(vgpu_num)	\
 	(VGPU_MAX_WEIGHT / (vgpu_num))
 
-static const struct {
-	unsigned int low_mm;
-	unsigned int high_mm;
-	unsigned int fence;
-
-	/* A vGPU with a weight of 8 will get twice as much GPU as a vGPU
-	 * with a weight of 4 on a contended host, different vGPU type has
-	 * different weight set. Legal weights range from 1 to 16.
-	 */
-	unsigned int weight;
-	enum intel_vgpu_edid edid;
-	const char *name;
-} vgpu_types[] = {
-/* Fixed vGPU type table */
+static const struct intel_vgpu_config intel_vgpu_configs[] = {
 	{ MB_TO_BYTES(64), MB_TO_BYTES(384), 4, VGPU_WEIGHT(8), GVT_EDID_1024_768, "8" },
 	{ MB_TO_BYTES(128), MB_TO_BYTES(512), 4, VGPU_WEIGHT(4), GVT_EDID_1920_1200, "4" },
 	{ MB_TO_BYTES(256), MB_TO_BYTES(1024), 4, VGPU_WEIGHT(2), GVT_EDID_1920_1200, "2" },
@@ -106,63 +103,34 @@ static const struct {
  */
 int intel_gvt_init_vgpu_types(struct intel_gvt *gvt)
 {
-	unsigned int num_types;
-	unsigned int i, low_avail, high_avail;
-	unsigned int min_low;
-
-	/* vGPU type name is defined as GVTg_Vx_y which contains
-	 * physical GPU generation type (e.g V4 as BDW server, V5 as
-	 * SKL server).
-	 *
-	 * Depend on physical SKU resource, might see vGPU types like
-	 * GVTg_V4_8, GVTg_V4_4, GVTg_V4_2, etc. We can create
-	 * different types of vGPU on same physical GPU depending on
-	 * available resource. Each vGPU type will have "avail_instance"
-	 * to indicate how many vGPU instance can be created for this
-	 * type.
-	 *
-	 */
-	low_avail = gvt_aperture_sz(gvt) - HOST_LOW_GM_SIZE;
-	high_avail = gvt_hidden_sz(gvt) - HOST_HIGH_GM_SIZE;
-	num_types = ARRAY_SIZE(vgpu_types);
+	unsigned int low_avail = gvt_aperture_sz(gvt) - HOST_LOW_GM_SIZE;
+	unsigned int high_avail = gvt_hidden_sz(gvt) - HOST_HIGH_GM_SIZE;
+	unsigned int num_types = ARRAY_SIZE(intel_vgpu_configs);
+	unsigned int i;
 
 	gvt->types = kcalloc(num_types, sizeof(struct intel_vgpu_type),
 			     GFP_KERNEL);
 	if (!gvt->types)
 		return -ENOMEM;
 
-	min_low = MB_TO_BYTES(32);
 	for (i = 0; i < num_types; ++i) {
-		if (low_avail / vgpu_types[i].low_mm == 0)
-			break;
-
-		gvt->types[i].low_gm_size = vgpu_types[i].low_mm;
-		gvt->types[i].high_gm_size = vgpu_types[i].high_mm;
-		gvt->types[i].fence = vgpu_types[i].fence;
+		const struct intel_vgpu_config *conf = &intel_vgpu_configs[i];
 
-		if (vgpu_types[i].weight < 1 ||
-					vgpu_types[i].weight > VGPU_MAX_WEIGHT)
+		if (low_avail / conf->low_mm == 0)
+			break;
+		if (conf->weight < 1 || conf->weight > VGPU_MAX_WEIGHT)
 			goto out_free_types;
 
-		gvt->types[i].weight = vgpu_types[i].weight;
-		gvt->types[i].resolution = vgpu_types[i].edid;
-		gvt->types[i].avail_instance = min(low_avail / vgpu_types[i].low_mm,
-						   high_avail / vgpu_types[i].high_mm);
-
-		if (GRAPHICS_VER(gvt->gt->i915) == 8)
-			sprintf(gvt->types[i].name, "GVTg_V4_%s",
-				vgpu_types[i].name);
-		else if (GRAPHICS_VER(gvt->gt->i915) == 9)
-			sprintf(gvt->types[i].name, "GVTg_V5_%s",
-				vgpu_types[i].name);
+		sprintf(gvt->types[i].name, "GVTg_V%u_%s",
+			GRAPHICS_VER(gvt->gt->i915) == 8 ? 4 : 5, conf->name);
+		gvt->types->conf = conf;
+		gvt->types[i].avail_instance = min(low_avail / conf->low_mm,
+						   high_avail / conf->high_mm);
 
 		gvt_dbg_core("type[%d]: %s avail %u low %u high %u fence %u weight %u res %s\n",
-			     i, gvt->types[i].name,
-			     gvt->types[i].avail_instance,
-			     gvt->types[i].low_gm_size,
-			     gvt->types[i].high_gm_size, gvt->types[i].fence,
-			     gvt->types[i].weight,
-			     vgpu_edid_str(gvt->types[i].resolution));
+			     i, gvt->types[i].name, gvt->types[i].avail_instance,
+			     conf->low_mm, conf->high_mm, conf->fence,
+			     conf->weight, vgpu_edid_str(conf->edid));
 	}
 
 	gvt->num_types = i;
@@ -195,16 +163,16 @@ static void intel_gvt_update_vgpu_types(struct intel_gvt *gvt)
 		gvt->fence.vgpu_allocated_fence_num;
 
 	for (i = 0; i < gvt->num_types; i++) {
-		low_gm_min = low_gm_avail / gvt->types[i].low_gm_size;
-		high_gm_min = high_gm_avail / gvt->types[i].high_gm_size;
-		fence_min = fence_avail / gvt->types[i].fence;
+		low_gm_min = low_gm_avail / gvt->types[i].conf->low_mm;
+		high_gm_min = high_gm_avail / gvt->types[i].conf->high_mm;
+		fence_min = fence_avail / gvt->types[i].conf->fence;
 		gvt->types[i].avail_instance = min(min(low_gm_min, high_gm_min),
 						   fence_min);
 
 		gvt_dbg_core("update type[%d]: %s avail %u low %u high %u fence %u\n",
 		       i, gvt->types[i].name,
-		       gvt->types[i].avail_instance, gvt->types[i].low_gm_size,
-		       gvt->types[i].high_gm_size, gvt->types[i].fence);
+		       gvt->types[i].avail_instance, gvt->types[i].conf->low_mm,
+		       gvt->types[i].conf->high_mm, gvt->types[i].conf->fence);
 	}
 }
 
@@ -365,37 +333,38 @@ void intel_gvt_destroy_idle_vgpu(struct intel_vgpu *vgpu)
 	vfree(vgpu);
 }
 
-static int __intel_gvt_create_vgpu(struct intel_vgpu *vgpu,
-				   struct intel_vgpu_creation_params *param)
+int intel_gvt_create_vgpu(struct intel_vgpu *vgpu,
+		const struct intel_vgpu_config *conf)
 {
 	struct intel_gvt *gvt = vgpu->gvt;
 	struct drm_i915_private *dev_priv = gvt->gt->i915;
 	int ret;
 
-	gvt_dbg_core("low %llu MB high %llu MB fence %llu\n",
-			param->low_gm_sz, param->high_gm_sz,
-			param->fence_sz);
+	gvt_dbg_core("low %u MB high %u MB fence %u\n",
+			BYTES_TO_MB(conf->low_mm), BYTES_TO_MB(conf->high_mm),
+			conf->fence);
 
+	mutex_lock(&gvt->lock);
 	ret = idr_alloc(&gvt->vgpu_idr, vgpu, IDLE_VGPU_IDR + 1, GVT_MAX_VGPU,
 		GFP_KERNEL);
 	if (ret < 0)
-		return ret;
+		goto out_unlock;;
 
 	vgpu->id = ret;
-	vgpu->sched_ctl.weight = param->weight;
+	vgpu->sched_ctl.weight = conf->weight;
 	mutex_init(&vgpu->vgpu_lock);
 	mutex_init(&vgpu->dmabuf_lock);
 	INIT_LIST_HEAD(&vgpu->dmabuf_obj_list_head);
 	INIT_RADIX_TREE(&vgpu->page_track_tree, GFP_KERNEL);
 	idr_init_base(&vgpu->object_idr, 1);
-	intel_vgpu_init_cfg_space(vgpu, param->primary);
+	intel_vgpu_init_cfg_space(vgpu, 1);
 	vgpu->d3_entered = false;
 
 	ret = intel_vgpu_init_mmio(vgpu);
 	if (ret)
 		goto out_clean_idr;
 
-	ret = intel_vgpu_alloc_resource(vgpu, param);
+	ret = intel_vgpu_alloc_resource(vgpu, conf);
 	if (ret)
 		goto out_clean_vgpu_mmio;
 
@@ -409,7 +378,7 @@ static int __intel_gvt_create_vgpu(struct intel_vgpu *vgpu,
 	if (ret)
 		goto out_clean_gtt;
 
-	ret = intel_vgpu_init_display(vgpu, param->resolution);
+	ret = intel_vgpu_init_display(vgpu, conf->edid);
 	if (ret)
 		goto out_clean_opregion;
 
@@ -434,6 +403,9 @@ static int __intel_gvt_create_vgpu(struct intel_vgpu *vgpu,
 	if (ret)
 		goto out_clean_sched_policy;
 
+	intel_gvt_update_vgpu_types(gvt);
+	intel_gvt_update_reg_whitelist(vgpu);
+	mutex_unlock(&gvt->lock);
 	return 0;
 
 out_clean_sched_policy:
@@ -452,45 +424,8 @@ static int __intel_gvt_create_vgpu(struct intel_vgpu *vgpu,
 	intel_vgpu_clean_mmio(vgpu);
 out_clean_idr:
 	idr_remove(&gvt->vgpu_idr, vgpu->id);
-	return ret;
-}
-
-/**
- * intel_gvt_create_vgpu - create a virtual GPU
- * @gvt: GVT device
- * @type: type of the vGPU to create
- *
- * This function is called when user wants to create a virtual GPU.
- *
- * Returns:
- * pointer to intel_vgpu, error pointer if failed.
- */
-int intel_gvt_create_vgpu(struct intel_vgpu *vgpu, struct intel_vgpu_type *type)
-{
-	struct intel_gvt *gvt = vgpu->gvt;
-	struct intel_vgpu_creation_params param;
-	int ret;
-
-	param.primary = 1;
-	param.low_gm_sz = type->low_gm_size;
-	param.high_gm_sz = type->high_gm_size;
-	param.fence_sz = type->fence;
-	param.weight = type->weight;
-	param.resolution = type->resolution;
-
-	/* XXX current param based on MB */
-	param.low_gm_sz = BYTES_TO_MB(param.low_gm_sz);
-	param.high_gm_sz = BYTES_TO_MB(param.high_gm_sz);
-
-	mutex_lock(&gvt->lock);
-	ret = __intel_gvt_create_vgpu(vgpu, &param);
-	if (!ret) {
-		/* calculate left instance change for types */
-		intel_gvt_update_vgpu_types(gvt);
-		intel_gvt_update_reg_whitelist(vgpu);
-	}
+out_unlock:
 	mutex_unlock(&gvt->lock);
-
 	return ret;
 }
 
-- 
2.30.2

