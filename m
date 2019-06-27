Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C819057A2A
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2019 05:44:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727082AbfF0DoJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jun 2019 23:44:09 -0400
Received: from mga17.intel.com ([192.55.52.151]:21244 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726989AbfF0DoJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jun 2019 23:44:09 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Jun 2019 20:44:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,422,1557212400"; 
   d="scan'208";a="360560991"
Received: from gvt.bj.intel.com ([10.238.158.187])
  by fmsmga005.fm.intel.com with ESMTP; 26 Jun 2019 20:44:06 -0700
From:   Tina Zhang <tina.zhang@intel.com>
To:     intel-gvt-dev@lists.freedesktop.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Tina Zhang <tina.zhang@intel.com>, kraxel@redhat.com,
        zhenyuw@linux.intel.com, zhiyuan.lv@intel.com,
        zhi.a.wang@intel.com, kevin.tian@intel.com, hang.yuan@intel.com,
        alex.williamson@redhat.com
Subject: [RFC PATCH v3 3/4] drm/i915/gvt: Register vGPU display vblank irq
Date:   Thu, 27 Jun 2019 11:38:01 +0800
Message-Id: <20190627033802.1663-4-tina.zhang@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190627033802.1663-1-tina.zhang@intel.com>
References: <20190627033802.1663-1-tina.zhang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Gvt-g emulates and injects the vGPU's display vblank interrupts in
kernel space. However the dma-buf based framebuffer consumer in the
user land (e.g. Qemu vfio/display) may also need to be notified by
this event.

Register the display irq as VFIO_IRQ_SUBTYPE_GFX_DISPLAY_IRQ to
each vGPU, so that the display interrupt event can be delivered to
userspace through eventfd.

Signed-off-by: Tina Zhang <tina.zhang@intel.com>
---
 drivers/gpu/drm/i915/gvt/display.c   | 10 +++++--
 drivers/gpu/drm/i915/gvt/gvt.h       |  2 ++
 drivers/gpu/drm/i915/gvt/hypercall.h |  1 +
 drivers/gpu/drm/i915/gvt/kvmgt.c     | 43 ++++++++++++++++++++++++++++
 drivers/gpu/drm/i915/gvt/mpt.h       | 17 +++++++++++
 5 files changed, 71 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/gvt/display.c b/drivers/gpu/drm/i915/gvt/display.c
index e1c313da6c00..1a0a4ae4826e 100644
--- a/drivers/gpu/drm/i915/gvt/display.c
+++ b/drivers/gpu/drm/i915/gvt/display.c
@@ -506,16 +506,22 @@ void intel_vgpu_clean_display(struct intel_vgpu *vgpu)
 int intel_vgpu_init_display(struct intel_vgpu *vgpu, u64 resolution)
 {
 	struct drm_i915_private *dev_priv = vgpu->gvt->dev_priv;
+	int ret;
 
 	intel_vgpu_init_i2c_edid(vgpu);
 
 	if (IS_SKYLAKE(dev_priv) || IS_KABYLAKE(dev_priv) ||
 	    IS_COFFEELAKE(dev_priv))
-		return setup_virtual_dp_monitor(vgpu, PORT_D, GVT_DP_D,
+		ret = setup_virtual_dp_monitor(vgpu, PORT_D, GVT_DP_D,
 						resolution);
 	else
-		return setup_virtual_dp_monitor(vgpu, PORT_B, GVT_DP_B,
+		ret = setup_virtual_dp_monitor(vgpu, PORT_B, GVT_DP_B,
 						resolution);
+
+	if (ret == 0)
+		intel_gvt_hypervisor_register_display_irq(vgpu);
+
+	return ret;
 }
 
 /**
diff --git a/drivers/gpu/drm/i915/gvt/gvt.h b/drivers/gpu/drm/i915/gvt/gvt.h
index f5a328b5290a..cd29ea28d7ed 100644
--- a/drivers/gpu/drm/i915/gvt/gvt.h
+++ b/drivers/gpu/drm/i915/gvt/gvt.h
@@ -201,6 +201,8 @@ struct intel_vgpu {
 		struct mdev_device *mdev;
 		struct vfio_region *region;
 		int num_regions;
+		struct vfio_irq *irq;
+		int num_irqs;
 		struct eventfd_ctx *intx_trigger;
 		struct eventfd_ctx *msi_trigger;
 
diff --git a/drivers/gpu/drm/i915/gvt/hypercall.h b/drivers/gpu/drm/i915/gvt/hypercall.h
index 4862fb12778e..be33f20f3bc1 100644
--- a/drivers/gpu/drm/i915/gvt/hypercall.h
+++ b/drivers/gpu/drm/i915/gvt/hypercall.h
@@ -68,6 +68,7 @@ struct intel_gvt_mpt {
 			     bool map);
 	int (*set_opregion)(void *vgpu);
 	int (*set_edid)(void *vgpu, int port_num);
+	int (*register_display_irq)(void *vgpu);
 	int (*get_vfio_device)(void *vgpu);
 	void (*put_vfio_device)(void *vgpu);
 	bool (*is_valid_gfn)(unsigned long handle, unsigned long gfn);
diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
index a68addf95c23..f222c9cd7a56 100644
--- a/drivers/gpu/drm/i915/gvt/kvmgt.c
+++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
@@ -78,6 +78,13 @@ struct vfio_region {
 	void				*data;
 };
 
+struct vfio_irq {
+	u32	type;
+	u32	subtype;
+	u32	flags;
+	u32	count;
+};
+
 struct vfio_edid_region {
 	struct vfio_region_gfx_edid vfio_edid_regs;
 	void *edid_blob;
@@ -635,6 +642,37 @@ static int kvmgt_set_edid(void *p_vgpu, int port_num)
 	return ret;
 }
 
+static int intel_vgpu_register_irq(struct intel_vgpu *vgpu,
+		unsigned int type, unsigned int subtype, u32 count, u32 flags)
+{
+	struct vfio_irq *irq;
+
+	irq = krealloc(vgpu->vdev.irq,
+			(vgpu->vdev.num_irqs + 1) * sizeof(*irq),
+			GFP_KERNEL);
+	if (!irq)
+		return -ENOMEM;
+
+	vgpu->vdev.irq = irq;
+	vgpu->vdev.irq[vgpu->vdev.num_irqs].type = type;
+	vgpu->vdev.irq[vgpu->vdev.num_irqs].subtype = subtype;
+	vgpu->vdev.irq[vgpu->vdev.num_irqs].count = count;
+	vgpu->vdev.irq[vgpu->vdev.num_irqs].flags = flags;
+	vgpu->vdev.num_irqs++;
+	return 0;
+}
+
+static int kvmgt_register_display_irq(void *p_vgpu)
+{
+	struct intel_vgpu *vgpu = (struct intel_vgpu *)p_vgpu;
+
+	intel_vgpu_register_irq(vgpu, VFIO_IRQ_TYPE_GFX,
+				VFIO_IRQ_SUBTYPE_GFX_DISPLAY_IRQ,
+				1,
+				VFIO_IRQ_INFO_MASKABLE | VFIO_IRQ_INFO_EVENTFD);
+	return 0;
+}
+
 static void kvmgt_put_vfio_device(void *vgpu)
 {
 	if (WARN_ON(!((struct intel_vgpu *)vgpu)->vdev.vfio_device))
@@ -1838,6 +1876,10 @@ static void kvmgt_detach_vgpu(void *p_vgpu)
 	vgpu->vdev.num_regions = 0;
 	kfree(vgpu->vdev.region);
 	vgpu->vdev.region = NULL;
+
+	vgpu->vdev.num_irqs = 0;
+	kfree(vgpu->vdev.irq);
+	vgpu->vdev.irq = NULL;
 }
 
 static int kvmgt_inject_msi(unsigned long handle, u32 addr, u16 data)
@@ -2039,6 +2081,7 @@ static struct intel_gvt_mpt kvmgt_mpt = {
 	.dma_unmap_guest_page = kvmgt_dma_unmap_guest_page,
 	.set_opregion = kvmgt_set_opregion,
 	.set_edid = kvmgt_set_edid,
+	.register_display_irq = kvmgt_register_display_irq,
 	.get_vfio_device = kvmgt_get_vfio_device,
 	.put_vfio_device = kvmgt_put_vfio_device,
 	.is_valid_gfn = kvmgt_is_valid_gfn,
diff --git a/drivers/gpu/drm/i915/gvt/mpt.h b/drivers/gpu/drm/i915/gvt/mpt.h
index 0f9440128123..abf4a69920d3 100644
--- a/drivers/gpu/drm/i915/gvt/mpt.h
+++ b/drivers/gpu/drm/i915/gvt/mpt.h
@@ -330,6 +330,23 @@ static inline int intel_gvt_hypervisor_set_edid(struct intel_vgpu *vgpu,
 	return intel_gvt_host.mpt->set_edid(vgpu, port_num);
 }
 
+/**
+ * intel_gvt_hypervisor_set_irq - register vgpu specific irq
+ * @vgpu: a vGPU
+ * @port_num: display port number
+ *
+ * Returns:
+ * Zero on success, negative error code if failed.
+ */
+static inline int intel_gvt_hypervisor_register_display_irq(
+						struct intel_vgpu *vgpu)
+{
+	if (!intel_gvt_host.mpt->register_display_irq)
+		return 0;
+
+	return intel_gvt_host.mpt->register_display_irq(vgpu);
+}
+
 /**
  * intel_gvt_hypervisor_get_vfio_device - increase vfio device ref count
  * @vgpu: a vGPU
-- 
2.17.1

