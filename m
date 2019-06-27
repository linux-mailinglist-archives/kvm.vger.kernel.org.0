Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F62357A29
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2019 05:44:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727110AbfF0DoM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jun 2019 23:44:12 -0400
Received: from mga17.intel.com ([192.55.52.151]:21244 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726989AbfF0DoL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jun 2019 23:44:11 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Jun 2019 20:44:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,422,1557212400"; 
   d="scan'208";a="360561007"
Received: from gvt.bj.intel.com ([10.238.158.187])
  by fmsmga005.fm.intel.com with ESMTP; 26 Jun 2019 20:44:08 -0700
From:   Tina Zhang <tina.zhang@intel.com>
To:     intel-gvt-dev@lists.freedesktop.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Tina Zhang <tina.zhang@intel.com>, kraxel@redhat.com,
        zhenyuw@linux.intel.com, zhiyuan.lv@intel.com,
        zhi.a.wang@intel.com, kevin.tian@intel.com, hang.yuan@intel.com,
        alex.williamson@redhat.com
Subject: [RFC PATCH v3 4/4] drm/i915/gvt: Deliver vGPU vblank event to userspace
Date:   Thu, 27 Jun 2019 11:38:02 +0800
Message-Id: <20190627033802.1663-5-tina.zhang@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190627033802.1663-1-tina.zhang@intel.com>
References: <20190627033802.1663-1-tina.zhang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Deliver the display vblank event to the user land. Userspace can use
the irq mask/unmask mechanism to disable or enable the event delivery.

Signed-off-by: Tina Zhang <tina.zhang@intel.com>
---
 drivers/gpu/drm/i915/gvt/display.c |   4 +
 drivers/gpu/drm/i915/gvt/gvt.h     |   4 +
 drivers/gpu/drm/i915/gvt/kvmgt.c   | 150 +++++++++++++++++++++++++++--
 3 files changed, 149 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/i915/gvt/display.c b/drivers/gpu/drm/i915/gvt/display.c
index 1a0a4ae4826e..e62313b5f8a6 100644
--- a/drivers/gpu/drm/i915/gvt/display.c
+++ b/drivers/gpu/drm/i915/gvt/display.c
@@ -412,6 +412,10 @@ static void emulate_vblank_on_pipe(struct intel_vgpu *vgpu, int pipe)
 
 	if (pipe_is_enabled(vgpu, pipe)) {
 		vgpu_vreg_t(vgpu, PIPE_FRMCOUNT_G4X(pipe))++;
+		if (vgpu->vdev.vblank_trigger &&
+		    !(vgpu->vdev.display_event_mask & DISPLAY_VBLANK_EVENT))
+			eventfd_signal(vgpu->vdev.vblank_trigger, 1);
+
 		intel_vgpu_trigger_virtual_event(vgpu, vblank_event[pipe]);
 	}
 }
diff --git a/drivers/gpu/drm/i915/gvt/gvt.h b/drivers/gpu/drm/i915/gvt/gvt.h
index cd29ea28d7ed..b3b476ee5acf 100644
--- a/drivers/gpu/drm/i915/gvt/gvt.h
+++ b/drivers/gpu/drm/i915/gvt/gvt.h
@@ -165,6 +165,8 @@ struct intel_vgpu_submission {
 	bool active;
 };
 
+#define DISPLAY_VBLANK_EVENT	(1 << 0)
+
 struct intel_vgpu {
 	struct intel_gvt *gvt;
 	struct mutex vgpu_lock;
@@ -205,6 +207,8 @@ struct intel_vgpu {
 		int num_irqs;
 		struct eventfd_ctx *intx_trigger;
 		struct eventfd_ctx *msi_trigger;
+		struct eventfd_ctx *vblank_trigger;
+		u32 display_event_mask;
 
 		/*
 		 * Two caches are used to avoid mapping duplicated pages (eg.
diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
index f222c9cd7a56..7a84222d7d2d 100644
--- a/drivers/gpu/drm/i915/gvt/kvmgt.c
+++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
@@ -1222,6 +1222,8 @@ static int intel_vgpu_get_irq_count(struct intel_vgpu *vgpu, int type)
 {
 	if (type == VFIO_PCI_INTX_IRQ_INDEX || type == VFIO_PCI_MSI_IRQ_INDEX)
 		return 1;
+	else if (type < VFIO_PCI_NUM_IRQS + vgpu->vdev.num_irqs)
+		return vgpu->vdev.irq[type - VFIO_PCI_NUM_IRQS].count;
 
 	return 0;
 }
@@ -1269,7 +1271,60 @@ static int intel_vgpu_set_msi_trigger(struct intel_vgpu *vgpu,
 	return 0;
 }
 
-static int intel_vgpu_set_irqs(struct intel_vgpu *vgpu, u32 flags,
+static int intel_vgu_set_display_irq_mask(struct intel_vgpu *vgpu,
+		unsigned int index, unsigned int start, unsigned int count,
+		u32 flags, void *data)
+{
+	if (start != 0 || count != 1)
+		return -EINVAL;
+
+	if (flags & VFIO_IRQ_SET_DATA_NONE)
+		vgpu->vdev.display_event_mask |= DISPLAY_VBLANK_EVENT;
+
+	return 0;
+}
+
+static int intel_vgu_set_display_irq_unmask(struct intel_vgpu *vgpu,
+		unsigned int index, unsigned int start, unsigned int count,
+		u32 flags, void *data)
+{
+	if (start != 0 || count != 1)
+		return -EINVAL;
+
+	if (flags & VFIO_IRQ_SET_DATA_NONE)
+		vgpu->vdev.display_event_mask &= ~DISPLAY_VBLANK_EVENT;
+
+	return 0;
+}
+
+static int intel_vgpu_set_display_event_trigger(struct intel_vgpu *vgpu,
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
+		vgpu->vdev.vblank_trigger = trigger;
+		vgpu->vdev.display_event_mask = 0;
+	} else if ((flags & VFIO_IRQ_SET_DATA_NONE) && !count) {
+		trigger = vgpu->vdev.vblank_trigger;
+		if (trigger) {
+			eventfd_ctx_put(trigger);
+			vgpu->vdev.vblank_trigger = NULL;
+		}
+	}
+
+	return 0;
+}
+
+int intel_vgpu_set_irqs(struct intel_vgpu *vgpu, u32 flags,
 		unsigned int index, unsigned int start, unsigned int count,
 		void *data)
 {
@@ -1302,6 +1357,35 @@ static int intel_vgpu_set_irqs(struct intel_vgpu *vgpu, u32 flags,
 			break;
 		}
 		break;
+	default:
+	{
+		int i;
+
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
+		    VFIO_IRQ_SUBTYPE_GFX_DISPLAY_IRQ) {
+			switch (flags & VFIO_IRQ_SET_ACTION_TYPE_MASK) {
+			case VFIO_IRQ_SET_ACTION_MASK:
+				func = intel_vgu_set_display_irq_mask;
+				break;
+			case VFIO_IRQ_SET_ACTION_UNMASK:
+				func = intel_vgu_set_display_irq_unmask;
+				break;
+			case VFIO_IRQ_SET_ACTION_TRIGGER:
+				func = intel_vgpu_set_display_event_trigger;
+				break;
+			}
+		}
+	}
 	}
 
 	if (!func)
@@ -1333,7 +1417,7 @@ static long intel_vgpu_ioctl(struct mdev_device *mdev, unsigned int cmd,
 		info.flags |= VFIO_DEVICE_FLAGS_RESET;
 		info.num_regions = VFIO_PCI_NUM_REGIONS +
 				vgpu->vdev.num_regions;
-		info.num_irqs = VFIO_PCI_NUM_IRQS;
+		info.num_irqs = VFIO_PCI_NUM_IRQS + vgpu->vdev.num_irqs;
 
 		return copy_to_user((void __user *)arg, &info, minsz) ?
 			-EFAULT : 0;
@@ -1493,32 +1577,79 @@ static long intel_vgpu_ioctl(struct mdev_device *mdev, unsigned int cmd,
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
 
 		if (info.index == VFIO_PCI_INTX_IRQ_INDEX)
 			info.flags |= (VFIO_IRQ_INFO_MASKABLE |
 				       VFIO_IRQ_INFO_AUTOMASKED);
-		else
-			info.flags |= VFIO_IRQ_INFO_NORESIZE;
+
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
 
 		return copy_to_user((void __user *)arg, &info, minsz) ?
 			-EFAULT : 0;
@@ -1537,7 +1668,8 @@ static long intel_vgpu_ioctl(struct mdev_device *mdev, unsigned int cmd,
 			int max = intel_vgpu_get_irq_count(vgpu, hdr.index);
 
 			ret = vfio_set_irqs_validate_and_prepare(&hdr, max,
-						VFIO_PCI_NUM_IRQS, &data_size);
+					VFIO_PCI_NUM_IRQS + vgpu->vdev.num_irqs,
+								 &data_size);
 			if (ret) {
 				gvt_vgpu_err("intel:vfio_set_irqs_validate_and_prepare failed\n");
 				return -EINVAL;
-- 
2.17.1

