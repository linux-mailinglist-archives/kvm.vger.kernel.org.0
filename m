Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E4A6343A1
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2019 12:01:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727249AbfFDKBU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jun 2019 06:01:20 -0400
Received: from mga06.intel.com ([134.134.136.31]:46146 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727240AbfFDKBU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jun 2019 06:01:20 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Jun 2019 03:01:19 -0700
X-ExtLoop1: 1
Received: from gvt.bj.intel.com ([10.238.158.187])
  by orsmga005.jf.intel.com with ESMTP; 04 Jun 2019 03:01:16 -0700
From:   Tina Zhang <tina.zhang@intel.com>
To:     intel-gvt-dev@lists.freedesktop.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Tina Zhang <tina.zhang@intel.com>, kraxel@redhat.com,
        zhenyuw@linux.intel.com, zhiyuan.lv@intel.com,
        zhi.a.wang@intel.com, kevin.tian@intel.com, hang.yuan@intel.com,
        alex.williamson@redhat.com
Subject: [RFC PATCH v2 2/3] drm/i915/gvt: Leverage irq capability chain to get eventfd
Date:   Tue,  4 Jun 2019 17:55:33 +0800
Message-Id: <20190604095534.10337-3-tina.zhang@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190604095534.10337-1-tina.zhang@intel.com>
References: <20190604095534.10337-1-tina.zhang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

GVT-g display model leverages vfio irq capability chain to get eventfd
from the user space. With the eventfd, GVT-g display model in kernel
can deliver a plane update event to user space.

Signed-off-by: Tina Zhang <tina.zhang@intel.com>
---
 drivers/gpu/drm/i915/gvt/display.c   |  10 +-
 drivers/gpu/drm/i915/gvt/gvt.h       |   4 +
 drivers/gpu/drm/i915/gvt/hypercall.h |   1 +
 drivers/gpu/drm/i915/gvt/kvmgt.c     | 208 +++++++++++++++++++++++++--
 drivers/gpu/drm/i915/gvt/mpt.h       |  16 +++
 5 files changed, 229 insertions(+), 10 deletions(-)

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
index f5a328b5290a..1951fc6b029f 100644
--- a/drivers/gpu/drm/i915/gvt/gvt.h
+++ b/drivers/gpu/drm/i915/gvt/gvt.h
@@ -201,8 +201,12 @@ struct intel_vgpu {
 		struct mdev_device *mdev;
 		struct vfio_region *region;
 		int num_regions;
+		struct vfio_irq *irq;
+		int num_irqs;
 		struct eventfd_ctx *intx_trigger;
 		struct eventfd_ctx *msi_trigger;
+		struct eventfd_ctx *pri_flip_trigger;
+		struct eventfd_ctx *cur_flip_trigger;
 
 		/*
 		 * Two caches are used to avoid mapping duplicated pages (eg.
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
index a68addf95c23..7d89d69fff20 100644
--- a/drivers/gpu/drm/i915/gvt/kvmgt.c
+++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
@@ -78,6 +78,12 @@ struct vfio_region {
 	void				*data;
 };
 
+struct vfio_irq {
+	u32				type;
+	u32				subtype;
+	u32				flags;
+};
+
 struct vfio_edid_region {
 	struct vfio_region_gfx_edid vfio_edid_regs;
 	void *edid_blob;
@@ -635,6 +641,41 @@ static int kvmgt_set_edid(void *p_vgpu, int port_num)
 	return ret;
 }
 
+static int intel_vgpu_register_irq(struct intel_vgpu *vgpu,
+		unsigned int type, unsigned int subtype, u32 flags)
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
+				VFIO_IRQ_SUBTYPE_GFX_PRI_PLANE_FLIP,
+				VFIO_IRQ_INFO_EVENTFD);
+
+	intel_vgpu_register_irq(vgpu, VFIO_IRQ_TYPE_GFX,
+				VFIO_IRQ_SUBTYPE_GFX_CUR_PLANE_FLIP,
+				VFIO_IRQ_INFO_EVENTFD);
+
+
+	return 0;
+}
+
 static void kvmgt_put_vfio_device(void *vgpu)
 {
 	if (WARN_ON(!((struct intel_vgpu *)vgpu)->vdev.vfio_device))
@@ -1182,7 +1223,11 @@ static int intel_vgpu_mmap(struct mdev_device *mdev, struct vm_area_struct *vma)
 
 static int intel_vgpu_get_irq_count(struct intel_vgpu *vgpu, int type)
 {
-	if (type == VFIO_PCI_INTX_IRQ_INDEX || type == VFIO_PCI_MSI_IRQ_INDEX)
+	if (type == VFIO_PCI_INTX_IRQ_INDEX ||
+	    type == VFIO_PCI_MSI_IRQ_INDEX ||
+	    ((type >= VFIO_PCI_NUM_IRQS) &&
+	     (type < VFIO_PCI_NUM_IRQS +
+	      vgpu->vdev.num_irqs)))
 		return 1;
 
 	return 0;
@@ -1231,6 +1276,58 @@ static int intel_vgpu_set_msi_trigger(struct intel_vgpu *vgpu,
 	return 0;
 }
 
+static int intel_vgpu_set_pri_flip_trigger(struct intel_vgpu *vgpu,
+		unsigned int index, unsigned int start, unsigned int count,
+		u32 flags, void *data)
+{
+	struct eventfd_ctx *trigger;
+
+	if (flags & VFIO_IRQ_SET_DATA_EVENTFD) {
+		int fd = *(int *)data;
+
+		trigger = eventfd_ctx_fdget(fd);
+		if (IS_ERR(trigger)) {
+			gvt_vgpu_err("eventfd_ctx_fdget failed\n");
+			return PTR_ERR(trigger);
+		}
+		vgpu->vdev.pri_flip_trigger = trigger;
+	} else if ((flags & VFIO_IRQ_SET_DATA_NONE) && !count) {
+		trigger = vgpu->vdev.pri_flip_trigger;
+		if (trigger) {
+			eventfd_ctx_put(trigger);
+			vgpu->vdev.pri_flip_trigger = NULL;
+		}
+	}
+
+	return 0;
+}
+
+static int intel_vgpu_set_cur_flip_trigger(struct intel_vgpu *vgpu,
+		unsigned int index, unsigned int start, unsigned int count,
+		u32 flags, void *data)
+{
+	struct eventfd_ctx *trigger;
+
+	if (flags & VFIO_IRQ_SET_DATA_EVENTFD) {
+		int fd = *(int *)data;
+
+		trigger = eventfd_ctx_fdget(fd);
+		if (IS_ERR(trigger)) {
+			gvt_vgpu_err("eventfd_ctx_fdget failed\n");
+			return PTR_ERR(trigger);
+		}
+		vgpu->vdev.cur_flip_trigger = trigger;
+	} else if ((flags & VFIO_IRQ_SET_DATA_NONE) && !count) {
+		trigger = vgpu->vdev.cur_flip_trigger;
+		if (trigger) {
+			eventfd_ctx_put(trigger);
+			vgpu->vdev.cur_flip_trigger = NULL;
+		}
+	}
+
+	return 0;
+}
+
 static int intel_vgpu_set_irqs(struct intel_vgpu *vgpu, u32 flags,
 		unsigned int index, unsigned int start, unsigned int count,
 		void *data)
@@ -1264,8 +1361,47 @@ static int intel_vgpu_set_irqs(struct intel_vgpu *vgpu, u32 flags,
 			break;
 		}
 		break;
-	}
+	default:
+	{
+		int i;
 
+		if (index >= VFIO_PCI_NUM_IRQS +
+					vgpu->vdev.num_irqs)
+			return -EINVAL;
+		index =
+			array_index_nospec(index,
+						VFIO_PCI_NUM_IRQS +
+						vgpu->vdev.num_irqs);
+
+		i = index - VFIO_PCI_NUM_IRQS;
+		if (vgpu->vdev.irq[i].type == VFIO_IRQ_TYPE_GFX &&
+		    vgpu->vdev.irq[i].subtype ==
+		    VFIO_IRQ_SUBTYPE_GFX_PRI_PLANE_FLIP) {
+			switch (flags & VFIO_IRQ_SET_ACTION_TYPE_MASK) {
+			case VFIO_IRQ_SET_ACTION_MASK:
+			case VFIO_IRQ_SET_ACTION_UNMASK:
+				/* XXX Need masking support exported */
+				break;
+			case VFIO_IRQ_SET_ACTION_TRIGGER:
+				func = intel_vgpu_set_pri_flip_trigger;
+				break;
+			}
+		} else if (vgpu->vdev.irq[i].type == VFIO_IRQ_TYPE_GFX &&
+		    vgpu->vdev.irq[i].subtype ==
+			   VFIO_IRQ_SUBTYPE_GFX_CUR_PLANE_FLIP) {
+			switch (flags & VFIO_IRQ_SET_ACTION_TYPE_MASK) {
+			case VFIO_IRQ_SET_ACTION_MASK:
+			case VFIO_IRQ_SET_ACTION_UNMASK:
+				/* XXX Need masking support exported */
+				break;
+			case VFIO_IRQ_SET_ACTION_TRIGGER:
+				func = intel_vgpu_set_cur_flip_trigger;
+				break;
+			}
+		}
+	}
+	}
+	/* Add set_vgpu_irq here */
 	if (!func)
 		return -ENOTTY;
 
@@ -1295,7 +1431,7 @@ static long intel_vgpu_ioctl(struct mdev_device *mdev, unsigned int cmd,
 		info.flags |= VFIO_DEVICE_FLAGS_RESET;
 		info.num_regions = VFIO_PCI_NUM_REGIONS +
 				vgpu->vdev.num_regions;
-		info.num_irqs = VFIO_PCI_NUM_IRQS;
+		info.num_irqs = VFIO_PCI_NUM_IRQS + vgpu->vdev.num_irqs;
 
 		return copy_to_user((void __user *)arg, &info, minsz) ?
 			-EFAULT : 0;
@@ -1455,24 +1591,55 @@ static long intel_vgpu_ioctl(struct mdev_device *mdev, unsigned int cmd,
 			-EFAULT : 0;
 	} else if (cmd == VFIO_DEVICE_GET_IRQ_INFO) {
 		struct vfio_irq_info info;
+		struct vfio_info_cap caps = { .buf = NULL, .size = 0 };
+		unsigned int i;
+		int ret;
 
 		minsz = offsetofend(struct vfio_irq_info, count);
 
 		if (copy_from_user(&info, (void __user *)arg, minsz))
 			return -EFAULT;
 
-		if (info.argsz < minsz || info.index >= VFIO_PCI_NUM_IRQS)
+		if (info.argsz < minsz)
 			return -EINVAL;
 
 		switch (info.index) {
 		case VFIO_PCI_INTX_IRQ_INDEX:
 		case VFIO_PCI_MSI_IRQ_INDEX:
+			info.flags = VFIO_IRQ_INFO_EVENTFD;
 			break;
-		default:
+		case VFIO_PCI_MSIX_IRQ_INDEX:
+		case VFIO_PCI_ERR_IRQ_INDEX:
+		case VFIO_PCI_REQ_IRQ_INDEX:
 			return -EINVAL;
-		}
+		default:
+		{
+			struct vfio_irq_info_cap_type cap_type = {
+				.header.id = VFIO_IRQ_INFO_CAP_TYPE,
+				.header.version = 1 };
 
-		info.flags = VFIO_IRQ_INFO_EVENTFD;
+			if (info.index >= VFIO_PCI_NUM_IRQS +
+					vgpu->vdev.num_irqs)
+				return -EINVAL;
+			info.index =
+				array_index_nospec(info.index,
+						VFIO_PCI_NUM_IRQS +
+						vgpu->vdev.num_irqs);
+
+			i = info.index - VFIO_PCI_NUM_IRQS;
+
+			info.flags = vgpu->vdev.irq[i].flags;
+
+			cap_type.type = vgpu->vdev.irq[i].type;
+			cap_type.subtype = vgpu->vdev.irq[i].subtype;
+
+			ret = vfio_info_add_capability(&caps,
+						&cap_type.header,
+						sizeof(cap_type));
+			if (ret)
+				return ret;
+		}
+		}
 
 		info.count = intel_vgpu_get_irq_count(vgpu, info.index);
 
@@ -1482,6 +1649,25 @@ static long intel_vgpu_ioctl(struct mdev_device *mdev, unsigned int cmd,
 		else
 			info.flags |= VFIO_IRQ_INFO_NORESIZE;
 
+		if (caps.size) {
+			info.flags |= VFIO_IRQ_INFO_FLAG_CAPS;
+			if (info.argsz < sizeof(info) + caps.size) {
+				info.argsz = sizeof(info) + caps.size;
+				info.cap_offset = 0;
+			} else {
+				vfio_info_cap_shift(&caps, sizeof(info));
+				if (copy_to_user((void __user *)arg +
+						  sizeof(info), caps.buf,
+						  caps.size)) {
+					kfree(caps.buf);
+					return -EFAULT;
+				}
+				info.cap_offset = sizeof(info);
+			}
+
+			kfree(caps.buf);
+		}
+
 		return copy_to_user((void __user *)arg, &info, minsz) ?
 			-EFAULT : 0;
 	} else if (cmd == VFIO_DEVICE_SET_IRQS) {
@@ -1499,7 +1685,8 @@ static long intel_vgpu_ioctl(struct mdev_device *mdev, unsigned int cmd,
 			int max = intel_vgpu_get_irq_count(vgpu, hdr.index);
 
 			ret = vfio_set_irqs_validate_and_prepare(&hdr, max,
-						VFIO_PCI_NUM_IRQS, &data_size);
+					VFIO_PCI_NUM_IRQS + vgpu->vdev.num_irqs,
+								 &data_size);
 			if (ret) {
 				gvt_vgpu_err("intel:vfio_set_irqs_validate_and_prepare failed\n");
 				return -EINVAL;
@@ -1838,6 +2025,10 @@ static void kvmgt_detach_vgpu(void *p_vgpu)
 	vgpu->vdev.num_regions = 0;
 	kfree(vgpu->vdev.region);
 	vgpu->vdev.region = NULL;
+
+	vgpu->vdev.num_irqs = 0;
+	kfree(vgpu->vdev.irq);
+	vgpu->vdev.irq = NULL;
 }
 
 static int kvmgt_inject_msi(unsigned long handle, u32 addr, u16 data)
@@ -2039,6 +2230,7 @@ static struct intel_gvt_mpt kvmgt_mpt = {
 	.dma_unmap_guest_page = kvmgt_dma_unmap_guest_page,
 	.set_opregion = kvmgt_set_opregion,
 	.set_edid = kvmgt_set_edid,
+	.register_display_irq = kvmgt_register_display_irq,
 	.get_vfio_device = kvmgt_get_vfio_device,
 	.put_vfio_device = kvmgt_put_vfio_device,
 	.is_valid_gfn = kvmgt_is_valid_gfn,
diff --git a/drivers/gpu/drm/i915/gvt/mpt.h b/drivers/gpu/drm/i915/gvt/mpt.h
index 0f9440128123..03b31ce87ae1 100644
--- a/drivers/gpu/drm/i915/gvt/mpt.h
+++ b/drivers/gpu/drm/i915/gvt/mpt.h
@@ -330,6 +330,22 @@ static inline int intel_gvt_hypervisor_set_edid(struct intel_vgpu *vgpu,
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
+static inline int intel_gvt_hypervisor_register_display_irq(struct intel_vgpu *vgpu)
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

