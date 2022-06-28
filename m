Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E72455C1B0
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 14:45:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244827AbiF1FRk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 01:17:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244810AbiF1FRM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 01:17:12 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E593D227;
        Mon, 27 Jun 2022 22:15:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=WXNDi6MJsGPkUZHH8pqvwPmMHpnwEDPtVlRxNGRHdMs=; b=TzWbPZSMGzIXnRVewVHRaWTGNS
        TNexdzaTZcCZnMcDUvfd5Pw6JbHdryssTCxbv2KAbPd0NAH1d5M3FWw9wEdOUGql9pA8YsPDcd8Py
        UpcL+eHObYcMBrF934erHB0iuWUCiO6WaA6Y5qvCHEJSrBGV1hxZsCMT3DyfaZQK7LWTeIS/YkR/k
        iBujpJcY4m/yJtsBesGDqgAgBCLOsX1N4jOY0CEHck6CglHVg5/U+C6H3jfs6iAYVm6dbOQUmnVxO
        yv9mqkEVL2qBHpPklwQBBQzPpFuxpFCcIcTX1+Uak6jBTNA7qDfkWALeLkJvkzkk9jC2b+1SDUATh
        DO2cxbZA==;
Received: from [2001:4bb8:199:3788:e965:1541:b076:2977] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o63Z6-004KuH-7s; Tue, 28 Jun 2022 05:15:08 +0000
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
Subject: [PATCH 11/13] vfio/mdev: consolidate all the available_instance sysfs into the core code
Date:   Tue, 28 Jun 2022 07:14:33 +0200
Message-Id: <20220628051435.695540-12-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220628051435.695540-1-hch@lst.de>
References: <20220628051435.695540-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Every driver just print a number, simply add a method to the mdev_driver
to return it and provide a standard sysfs show function.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Kirti Wankhede <kwankhede@nvidia.com>
---
 .../driver-api/vfio-mediated-device.rst       |  3 +-
 drivers/gpu/drm/i915/gvt/gvt.h                |  1 -
 drivers/gpu/drm/i915/gvt/kvmgt.c              | 34 +++++++++-----
 drivers/gpu/drm/i915/gvt/vgpu.c               | 44 ++-----------------
 drivers/s390/cio/vfio_ccw_ops.c               | 14 ++----
 drivers/s390/crypto/vfio_ap_ops.c             | 16 ++-----
 drivers/vfio/mdev/mdev_sysfs.c                | 11 +++++
 include/linux/mdev.h                          |  2 +
 samples/vfio-mdev/mbochs.c                    | 10 ++---
 samples/vfio-mdev/mdpy.c                      |  9 ++--
 samples/vfio-mdev/mtty.c                      | 16 ++-----
 11 files changed, 55 insertions(+), 105 deletions(-)

diff --git a/Documentation/driver-api/vfio-mediated-device.rst b/Documentation/driver-api/vfio-mediated-device.rst
index 334e649360353..1e19ba588a34f 100644
--- a/Documentation/driver-api/vfio-mediated-device.rst
+++ b/Documentation/driver-api/vfio-mediated-device.rst
@@ -105,6 +105,7 @@ structure to represent a mediated device's driver::
      struct mdev_driver {
 	     int  (*probe)  (struct mdev_device *dev);
 	     void (*remove) (struct mdev_device *dev);
+	     unsigned int (*get_available)(struct mdev_type *mtype);
 	     const struct attribute * const *types_attrs;
 	     struct device_driver    driver;
      };
@@ -209,7 +210,7 @@ Directories and files under the sysfs for Each Physical Device
 
 * available_instances
 
-  This attribute should show the number of devices of type <type-id> that can be
+  This attribute shows the number of devices of type <type-id> that can be
   created.
 
 * [device]
diff --git a/drivers/gpu/drm/i915/gvt/gvt.h b/drivers/gpu/drm/i915/gvt/gvt.h
index 0ccb9bb7180cd..91d1da18bdf40 100644
--- a/drivers/gpu/drm/i915/gvt/gvt.h
+++ b/drivers/gpu/drm/i915/gvt/gvt.h
@@ -299,7 +299,6 @@ struct intel_gvt_firmware {
 #define NR_MAX_INTEL_VGPU_TYPES 20
 struct intel_vgpu_type {
 	struct mdev_type type;
-	unsigned int avail_instance;
 	unsigned int low_gm_size;
 	unsigned int high_gm_size;
 	unsigned int fence;
diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
index 191e64ef70acf..0e14bf94534c4 100644
--- a/drivers/gpu/drm/i915/gvt/kvmgt.c
+++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
@@ -113,16 +113,6 @@ static void kvmgt_page_track_flush_slot(struct kvm *kvm,
 		struct kvm_memory_slot *slot,
 		struct kvm_page_track_notifier_node *node);
 
-static ssize_t available_instances_show(struct mdev_type *mtype,
-					struct mdev_type_attribute *attr,
-					char *buf)
-{
-	struct intel_vgpu_type *type =
-		container_of(mtype, struct intel_vgpu_type, type);
-
-	return sprintf(buf, "%u\n", type->avail_instance);
-}
-
 static ssize_t description_show(struct mdev_type *mtype,
 				struct mdev_type_attribute *attr, char *buf)
 {
@@ -138,11 +128,9 @@ static ssize_t description_show(struct mdev_type *mtype,
 		       type->weight);
 }
 
-static MDEV_TYPE_ATTR_RO(available_instances);
 static MDEV_TYPE_ATTR_RO(description);
 
 static const struct attribute *gvt_type_attrs[] = {
-	&mdev_type_attr_available_instances.attr,
 	&mdev_type_attr_description.attr,
 	NULL,
 };
@@ -1570,6 +1558,27 @@ static void intel_vgpu_remove(struct mdev_device *mdev)
 	intel_gvt_destroy_vgpu(vgpu);
 }
 
+static unsigned int intel_vgpu_get_available(struct mdev_type *mtype)
+{
+	struct intel_vgpu_type *type =
+		container_of(mtype, struct intel_vgpu_type, type);
+	struct intel_gvt *gvt = kdev_to_i915(mtype->parent->dev)->gvt;
+	unsigned int low_gm_avail, high_gm_avail, fence_avail;
+
+	mutex_lock(&gvt->lock);
+	low_gm_avail = gvt_aperture_sz(gvt) - HOST_LOW_GM_SIZE -
+		gvt->gm.vgpu_allocated_low_gm_size;
+	high_gm_avail = gvt_hidden_sz(gvt) - HOST_HIGH_GM_SIZE -
+		gvt->gm.vgpu_allocated_high_gm_size;
+	fence_avail = gvt_fence_sz(gvt) - HOST_FENCE -
+		gvt->fence.vgpu_allocated_fence_num;
+	mutex_unlock(&gvt->lock);
+
+	return min3(low_gm_avail / type->low_gm_size,
+		    high_gm_avail / type->high_gm_size,
+		    fence_avail / type->fence);
+}
+
 static struct mdev_driver intel_vgpu_mdev_driver = {
 	.device_api	= VFIO_DEVICE_API_PCI_STRING,
 	.driver = {
@@ -1579,6 +1588,7 @@ static struct mdev_driver intel_vgpu_mdev_driver = {
 	},
 	.probe		= intel_vgpu_probe,
 	.remove		= intel_vgpu_remove,
+	.get_available	= intel_vgpu_get_available,
 	.types_attrs	= gvt_type_attrs,
 };
 
diff --git a/drivers/gpu/drm/i915/gvt/vgpu.c b/drivers/gpu/drm/i915/gvt/vgpu.c
index cea8113d2200e..77757f539ac31 100644
--- a/drivers/gpu/drm/i915/gvt/vgpu.c
+++ b/drivers/gpu/drm/i915/gvt/vgpu.c
@@ -151,8 +151,6 @@ int intel_gvt_init_vgpu_types(struct intel_gvt *gvt)
 
 		gvt->types[i].weight = vgpu_types[i].weight;
 		gvt->types[i].resolution = vgpu_types[i].edid;
-		gvt->types[i].avail_instance = min(low_avail / vgpu_types[i].low_mm,
-						   high_avail / vgpu_types[i].high_mm);
 
 		if (GRAPHICS_VER(gvt->gt->i915) == 8)
 			sprintf(gvt->types[i].type.sysfs_name, "GVTg_V4_%s",
@@ -163,7 +161,8 @@ int intel_gvt_init_vgpu_types(struct intel_gvt *gvt)
 
 		gvt_dbg_core("type[%d]: %s avail %u low %u high %u fence %u weight %u res %s\n",
 			     i, gvt->types[i].type.sysfs_name,
-			     gvt->types[i].avail_instance,
+			     min(low_avail / vgpu_types[i].low_mm,
+				 high_avail / vgpu_types[i].high_mm),
 			     gvt->types[i].low_gm_size,
 			     gvt->types[i].high_gm_size, gvt->types[i].fence,
 			     gvt->types[i].weight,
@@ -188,36 +187,6 @@ void intel_gvt_clean_vgpu_types(struct intel_gvt *gvt)
 	kfree(gvt->types);
 }
 
-static void intel_gvt_update_vgpu_types(struct intel_gvt *gvt)
-{
-	int i;
-	unsigned int low_gm_avail, high_gm_avail, fence_avail;
-	unsigned int low_gm_min, high_gm_min, fence_min;
-
-	/* Need to depend on maxium hw resource size but keep on
-	 * static config for now.
-	 */
-	low_gm_avail = gvt_aperture_sz(gvt) - HOST_LOW_GM_SIZE -
-		gvt->gm.vgpu_allocated_low_gm_size;
-	high_gm_avail = gvt_hidden_sz(gvt) - HOST_HIGH_GM_SIZE -
-		gvt->gm.vgpu_allocated_high_gm_size;
-	fence_avail = gvt_fence_sz(gvt) - HOST_FENCE -
-		gvt->fence.vgpu_allocated_fence_num;
-
-	for (i = 0; i < gvt->num_types; i++) {
-		low_gm_min = low_gm_avail / gvt->types[i].low_gm_size;
-		high_gm_min = high_gm_avail / gvt->types[i].high_gm_size;
-		fence_min = fence_avail / gvt->types[i].fence;
-		gvt->types[i].avail_instance = min(min(low_gm_min, high_gm_min),
-						   fence_min);
-
-		gvt_dbg_core("update type[%d]: %s avail %u low %u high %u fence %u\n",
-		       i, gvt->types[i].type.sysfs_name,
-		       gvt->types[i].avail_instance, gvt->types[i].low_gm_size,
-		       gvt->types[i].high_gm_size, gvt->types[i].fence);
-	}
-}
-
 /**
  * intel_gvt_active_vgpu - activate a virtual GPU
  * @vgpu: virtual GPU
@@ -313,10 +282,6 @@ void intel_gvt_destroy_vgpu(struct intel_vgpu *vgpu)
 	intel_vgpu_dmabuf_cleanup(vgpu);
 	mutex_unlock(&vgpu->vgpu_lock);
 
-	mutex_lock(&gvt->lock);
-	intel_gvt_update_vgpu_types(gvt);
-	mutex_unlock(&gvt->lock);
-
 	vfree(vgpu);
 }
 
@@ -503,11 +468,8 @@ struct intel_vgpu *intel_gvt_create_vgpu(struct intel_gvt *gvt,
 
 	mutex_lock(&gvt->lock);
 	vgpu = __intel_gvt_create_vgpu(gvt, &param);
-	if (!IS_ERR(vgpu)) {
-		/* calculate left instance change for types */
-		intel_gvt_update_vgpu_types(gvt);
+	if (!IS_ERR(vgpu))
 		intel_gvt_update_reg_whitelist(vgpu);
-	}
 	mutex_unlock(&gvt->lock);
 
 	return vgpu;
diff --git a/drivers/s390/cio/vfio_ccw_ops.c b/drivers/s390/cio/vfio_ccw_ops.c
index 35389f4b67dc5..94cc62b808088 100644
--- a/drivers/s390/cio/vfio_ccw_ops.c
+++ b/drivers/s390/cio/vfio_ccw_ops.c
@@ -70,20 +70,12 @@ static int vfio_ccw_mdev_notifier(struct notifier_block *nb,
 	return NOTIFY_DONE;
 }
 
-static ssize_t available_instances_show(struct mdev_type *mtype,
-					struct mdev_type_attribute *attr,
-					char *buf)
+static unsigned int vfio_ccw_get_available(struct mdev_type *mtype)
 {
 	struct vfio_ccw_private *private = dev_get_drvdata(mtype->parent->dev);
 
-	return sprintf(buf, "%d\n", atomic_read(&private->avail));
+	return atomic_read(&private->avail);
 }
-static MDEV_TYPE_ATTR_RO(available_instances);
-
-static const struct attribute *mdev_types_attrs[] = {
-	&mdev_type_attr_available_instances.attr,
-	NULL,
-};
 
 static int vfio_ccw_mdev_probe(struct mdev_device *mdev)
 {
@@ -628,7 +620,7 @@ struct mdev_driver vfio_ccw_mdev_driver = {
 	},
 	.probe = vfio_ccw_mdev_probe,
 	.remove = vfio_ccw_mdev_remove,
-	.types_attrs = mdev_types_attrs,
+	.get_available = vfio_ccw_get_available,
 };
 
 int vfio_ccw_mdev_reg(struct subchannel *sch)
diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index d6b2e819a615e..5e6cc43413117 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -511,21 +511,11 @@ static void vfio_ap_mdev_remove(struct mdev_device *mdev)
 	atomic_inc(&matrix_dev->available_instances);
 }
 
-static ssize_t available_instances_show(struct mdev_type *mtype,
-					struct mdev_type_attribute *attr,
-					char *buf)
+static unsigned int vfio_ap_mdev_get_available(struct mdev_type *mtype)
 {
-	return sprintf(buf, "%d\n",
-		       atomic_read(&matrix_dev->available_instances));
+	return atomic_read(&matrix_dev->available_instances);
 }
 
-static MDEV_TYPE_ATTR_RO(available_instances);
-
-static const struct attribute *vfio_ap_mdev_type_attrs[] = {
-	&mdev_type_attr_available_instances.attr,
-	NULL,
-};
-
 struct vfio_ap_queue_reserved {
 	unsigned long *apid;
 	unsigned long *apqi;
@@ -1445,7 +1435,7 @@ static struct mdev_driver vfio_ap_matrix_driver = {
 	},
 	.probe = vfio_ap_mdev_probe,
 	.remove = vfio_ap_mdev_remove,
-	.types_attrs = vfio_ap_mdev_type_attrs,
+	.get_available = vfio_ap_mdev_get_available,
 };
 
 int vfio_ap_mdev_register(void)
diff --git a/drivers/vfio/mdev/mdev_sysfs.c b/drivers/vfio/mdev/mdev_sysfs.c
index 76b0c6f8f0c6b..3d87447b67484 100644
--- a/drivers/vfio/mdev/mdev_sysfs.c
+++ b/drivers/vfio/mdev/mdev_sysfs.c
@@ -91,10 +91,21 @@ static ssize_t name_show(struct mdev_type *mtype,
 
 static MDEV_TYPE_ATTR_RO(name);
 
+static ssize_t available_instances_show(struct mdev_type *mtype,
+					struct mdev_type_attribute *attr,
+					char *buf)
+{
+	struct mdev_driver *drv = mtype->parent->mdev_driver;
+
+	return sysfs_emit(buf, "%u\n", drv->get_available(mtype));
+}
+static MDEV_TYPE_ATTR_RO(available_instances);
+
 static struct attribute *mdev_types_core_attrs[] = {
 	&mdev_type_attr_create.attr,
 	&mdev_type_attr_device_api.attr,
 	&mdev_type_attr_name.attr,
+	&mdev_type_attr_available_instances.attr,
 	NULL,
 };
 
diff --git a/include/linux/mdev.h b/include/linux/mdev.h
index 21e869a951050..9e7a2296431d5 100644
--- a/include/linux/mdev.h
+++ b/include/linux/mdev.h
@@ -72,6 +72,7 @@ struct mdev_type_attribute {
  * @device_api: string to return for the device_api sysfs
  * @probe: called when new device created
  * @remove: called when device removed
+ * @get_available: Return the max number of instances that can be created
  * @types_attrs: attributes to the type kobjects.
  * @driver: device driver structure
  **/
@@ -79,6 +80,7 @@ struct mdev_driver {
 	const char *device_api;
 	int (*probe)(struct mdev_device *dev);
 	void (*remove)(struct mdev_device *dev);
+	unsigned int (*get_available)(struct mdev_type *mtype);
 	const struct attribute * const *types_attrs;
 	struct device_driver driver;
 };
diff --git a/samples/vfio-mdev/mbochs.c b/samples/vfio-mdev/mbochs.c
index c8271168a96ad..e61be7f8a9863 100644
--- a/samples/vfio-mdev/mbochs.c
+++ b/samples/vfio-mdev/mbochs.c
@@ -1344,21 +1344,16 @@ static ssize_t description_show(struct mdev_type *mtype,
 }
 static MDEV_TYPE_ATTR_RO(description);
 
-static ssize_t available_instances_show(struct mdev_type *mtype,
-					struct mdev_type_attribute *attr,
-					char *buf)
+static unsigned int mbochs_get_available(struct mdev_type *mtype)
 {
 	struct mbochs_type *type =
 		container_of(mtype, struct mbochs_type, type);
-	int count = atomic_read(&mbochs_avail_mbytes) / type->mbytes;
 
-	return sprintf(buf, "%d\n", count);
+	return atomic_read(&mbochs_avail_mbytes) / type->mbytes;
 }
-static MDEV_TYPE_ATTR_RO(available_instances);
 
 static const struct attribute *mdev_types_attrs[] = {
 	&mdev_type_attr_description.attr,
-	&mdev_type_attr_available_instances.attr,
 	NULL,
 };
 
@@ -1380,6 +1375,7 @@ static struct mdev_driver mbochs_driver = {
 	},
 	.probe = mbochs_probe,
 	.remove	= mbochs_remove,
+	.get_available = mbochs_get_available,
 	.types_attrs = mdev_types_attrs,
 };
 
diff --git a/samples/vfio-mdev/mdpy.c b/samples/vfio-mdev/mdpy.c
index 6091c642ee102..2f59078909c9d 100644
--- a/samples/vfio-mdev/mdpy.c
+++ b/samples/vfio-mdev/mdpy.c
@@ -660,17 +660,13 @@ static ssize_t description_show(struct mdev_type *mtype,
 }
 static MDEV_TYPE_ATTR_RO(description);
 
-static ssize_t available_instances_show(struct mdev_type *mtype,
-					struct mdev_type_attribute *attr,
-					char *buf)
+static unsigned int mdpy_get_available(struct mdev_type *mtype)
 {
-	return sprintf(buf, "%d\n", max_devices - mdpy_count);
+	return max_devices - mdpy_count;
 }
-static MDEV_TYPE_ATTR_RO(available_instances);
 
 static const struct attribute *mdev_types_attrs[] = {
 	&mdev_type_attr_description.attr,
-	&mdev_type_attr_available_instances.attr,
 	NULL,
 };
 
@@ -691,6 +687,7 @@ static struct mdev_driver mdpy_driver = {
 	},
 	.probe = mdpy_probe,
 	.remove	= mdpy_remove,
+	.get_available = mdpy_get_available,
 	.types_attrs = mdev_types_attrs,
 };
 
diff --git a/samples/vfio-mdev/mtty.c b/samples/vfio-mdev/mtty.c
index b95a4491265c5..f6e8ec8240066 100644
--- a/samples/vfio-mdev/mtty.c
+++ b/samples/vfio-mdev/mtty.c
@@ -1247,23 +1247,13 @@ static const struct attribute_group *mdev_dev_groups[] = {
 	NULL,
 };
 
-static ssize_t available_instances_show(struct mdev_type *mtype,
-					struct mdev_type_attribute *attr,
-					char *buf)
+static unsigned int mtty_get_available(struct mdev_type *mtype)
 {
 	struct mtty_type *type = container_of(mtype, struct mtty_type, type);
 
-	return sprintf(buf, "%d\n", atomic_read(&mdev_avail_ports) /
-			type->nr_ports);
+	return atomic_read(&mdev_avail_ports) / type->nr_ports;
 }
 
-static MDEV_TYPE_ATTR_RO(available_instances);
-
-static const struct attribute *mdev_types_attrs[] = {
-	&mdev_type_attr_available_instances.attr,
-	NULL,
-};
-
 static const struct vfio_device_ops mtty_dev_ops = {
 	.name = "vfio-mtty",
 	.read = mtty_read,
@@ -1281,7 +1271,7 @@ static struct mdev_driver mtty_driver = {
 	},
 	.probe = mtty_probe,
 	.remove	= mtty_remove,
-	.types_attrs = mdev_types_attrs,
+	.get_available = mtty_get_available,
 };
 
 static void mtty_device_release(struct device *dev)
-- 
2.30.2

