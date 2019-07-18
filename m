Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C9D16CA79
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2019 09:59:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726933AbfGRH5u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Jul 2019 03:57:50 -0400
Received: from mga03.intel.com ([134.134.136.65]:59108 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726572AbfGRH5t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Jul 2019 03:57:49 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Jul 2019 00:57:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,276,1559545200"; 
   d="scan'208";a="158713104"
Received: from gvt-optiplex-7060.bj.intel.com ([10.238.158.89])
  by orsmga007.jf.intel.com with ESMTP; 18 Jul 2019 00:57:46 -0700
From:   Kechen Lu <kechen.lu@intel.com>
To:     intel-gvt-dev@lists.freedesktop.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Tina Zhang <tina.zhang@intel.com>, kraxel@redhat.com,
        zhenyuw@linux.intel.com, zhiyuan.lv@intel.com,
        zhi.a.wang@intel.com, kevin.tian@intel.com, hang.yuan@intel.com,
        alex.williamson@redhat.com, Kechen Lu <kechen.lu@intel.com>
Subject: [RFC PATCH v4 4/6] drm/i915/gvt: Deliver vGPU refresh event to userspace
Date:   Thu, 18 Jul 2019 23:56:38 +0800
Message-Id: <20190718155640.25928-5-kechen.lu@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190718155640.25928-1-kechen.lu@intel.com>
References: <20190718155640.25928-1-kechen.lu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tina Zhang <tina.zhang@intel.com>

Deliver the display refresh events to the user land. Userspace can use
the irq mask/unmask mechanism to disable or enable the event delivery.

As we know, delivering refresh event at each vblank safely avoids
tearing and unexpected event overwhelming, but there are still spaces
to optimize.

For handling the normal case, deliver the page flip refresh
event at each vblank, in other words, bounded by vblanks. Skipping some
events bring performance enhancement while not hurting user experience.

For single framebuffer case, deliver the refresh events to userspace at
all vblanks. This heuristic at each vblank leverages pageflip_count
incresements to determine if there is no page flip happens after a certain
period and so that the case is regarded as single framebuffer one.
Although this heuristic makes incorrect decision sometimes and it depends
on guest behavior, for example, when no cursor movements happen, the
user experience does not harm and front buffer is still correctly acquired.
Meanwhile, in actual single framebuffer case, the user experience is
enhanced compared with page flip events only.

Addtionally, to mitigate the events delivering footprints, one eventfd and
8 byte eventfd counter partition are leveraged.

Signed-off-by: Tina Zhang <tina.zhang@intel.com>
Signed-off-by: Kechen Lu <kechen.lu@intel.com>
---
 drivers/gpu/drm/i915/gvt/display.c |  21 ++++
 drivers/gpu/drm/i915/gvt/gvt.h     |   7 ++
 drivers/gpu/drm/i915/gvt/kvmgt.c   | 154 +++++++++++++++++++++++++++--
 3 files changed, 173 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/i915/gvt/display.c b/drivers/gpu/drm/i915/gvt/display.c
index 1a0a4ae4826e..036db8199983 100644
--- a/drivers/gpu/drm/i915/gvt/display.c
+++ b/drivers/gpu/drm/i915/gvt/display.c
@@ -387,6 +387,8 @@ void intel_gvt_check_vblank_emulation(struct intel_gvt *gvt)
 	mutex_unlock(&gvt->lock);
 }
 
+#define PAGEFLIP_INC_COUNT 5
+
 static void emulate_vblank_on_pipe(struct intel_vgpu *vgpu, int pipe)
 {
 	struct drm_i915_private *dev_priv = vgpu->gvt->dev_priv;
@@ -396,7 +398,10 @@ static void emulate_vblank_on_pipe(struct intel_vgpu *vgpu, int pipe)
 		[PIPE_B] = PIPE_B_VBLANK,
 		[PIPE_C] = PIPE_C_VBLANK,
 	};
+	int pri_flip_event = SKL_FLIP_EVENT(pipe, PLANE_PRIMARY);
 	int event;
+	u64 eventfd_signal_val = 0;
+	static int pageflip_count;
 
 	if (pipe < PIPE_A || pipe > PIPE_C)
 		return;
@@ -407,11 +412,27 @@ static void emulate_vblank_on_pipe(struct intel_vgpu *vgpu, int pipe)
 		if (!pipe_is_enabled(vgpu, pipe))
 			continue;
 
+		if (event == pri_flip_event) {
+			eventfd_signal_val += DISPLAY_PRI_REFRESH_EVENT_INC;
+			pageflip_count += PAGEFLIP_INC_COUNT;
+		}
+
 		intel_vgpu_trigger_virtual_event(vgpu, event);
 	}
 
+	if (--pageflip_count < 0) {
+		eventfd_signal_val += DISPLAY_PRI_REFRESH_EVENT_INC;
+		pageflip_count = 0;
+	}
+
+	if (vgpu->vdev.vblank_trigger && !(vgpu->vdev.display_event_mask
+		& (DISPLAY_PRI_REFRESH_EVENT | DISPLAY_CUR_REFRESH_EVENT)) &&
+		eventfd_signal_val)
+		eventfd_signal(vgpu->vdev.vblank_trigger, eventfd_signal_val);
+
 	if (pipe_is_enabled(vgpu, pipe)) {
 		vgpu_vreg_t(vgpu, PIPE_FRMCOUNT_G4X(pipe))++;
+
 		intel_vgpu_trigger_virtual_event(vgpu, vblank_event[pipe]);
 	}
 }
diff --git a/drivers/gpu/drm/i915/gvt/gvt.h b/drivers/gpu/drm/i915/gvt/gvt.h
index 64d1c1aaa42a..b654b6fa0663 100644
--- a/drivers/gpu/drm/i915/gvt/gvt.h
+++ b/drivers/gpu/drm/i915/gvt/gvt.h
@@ -165,6 +165,11 @@ struct intel_vgpu_submission {
 	bool active;
 };
 
+#define DISPLAY_PRI_REFRESH_EVENT	(1 << 0)
+#define DISPLAY_PRI_REFRESH_EVENT_INC	(1UL << 56)
+#define DISPLAY_CUR_REFRESH_EVENT	(1 << 1)
+#define DISPLAY_CUR_REFRESH_EVENT_INC	(1UL << 48)
+
 struct intel_vgpu {
 	struct intel_gvt *gvt;
 	struct mutex vgpu_lock;
@@ -205,6 +210,8 @@ struct intel_vgpu {
 		int num_irqs;
 		struct eventfd_ctx *intx_trigger;
 		struct eventfd_ctx *msi_trigger;
+		struct eventfd_ctx *vblank_trigger;
+		u32 display_event_mask;
 
 		/*
 		 * Two caches are used to avoid mapping duplicated pages (eg.
diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
index 6fe825763d05..61c634618217 100644
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
@@ -1269,7 +1271,62 @@ static int intel_vgpu_set_msi_trigger(struct intel_vgpu *vgpu,
 	return 0;
 }
 
-static int intel_vgpu_set_irqs(struct intel_vgpu *vgpu, u32 flags,
+static int intel_vgu_set_display_irq_mask(struct intel_vgpu *vgpu,
+		unsigned int index, unsigned int start, unsigned int count,
+		u32 flags, void *data)
+{
+	if (start != 0 || count > 2)
+		return -EINVAL;
+
+	if (flags & VFIO_IRQ_SET_DATA_NONE)
+		vgpu->vdev.display_event_mask |= DISPLAY_PRI_REFRESH_EVENT |
+			DISPLAY_CUR_REFRESH_EVENT;
+
+	return 0;
+}
+
+static int intel_vgu_set_display_irq_unmask(struct intel_vgpu *vgpu,
+		unsigned int index, unsigned int start, unsigned int count,
+		u32 flags, void *data)
+{
+	if (start != 0 || count > 2)
+		return -EINVAL;
+
+	if (flags & VFIO_IRQ_SET_DATA_NONE)
+		vgpu->vdev.display_event_mask &= ~(DISPLAY_PRI_REFRESH_EVENT |
+			   DISPLAY_CUR_REFRESH_EVENT);
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
@@ -1302,6 +1359,35 @@ static int intel_vgpu_set_irqs(struct intel_vgpu *vgpu, u32 flags,
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
@@ -1333,7 +1419,7 @@ static long intel_vgpu_ioctl(struct mdev_device *mdev, unsigned int cmd,
 		info.flags |= VFIO_DEVICE_FLAGS_RESET;
 		info.num_regions = VFIO_PCI_NUM_REGIONS +
 				vgpu->vdev.num_regions;
-		info.num_irqs = VFIO_PCI_NUM_IRQS;
+		info.num_irqs = VFIO_PCI_NUM_IRQS + vgpu->vdev.num_irqs;
 
 		return copy_to_user((void __user *)arg, &info, minsz) ?
 			-EFAULT : 0;
@@ -1493,32 +1579,81 @@ static long intel_vgpu_ioctl(struct mdev_device *mdev, unsigned int cmd,
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
+				if (offsetofend(struct vfio_irq_info, cap_offset) > minsz)
+					minsz = offsetofend(struct vfio_irq_info, cap_offset);
+			}
+
+			kfree(caps.buf);
+		}
 
 		return copy_to_user((void __user *)arg, &info, minsz) ?
 			-EFAULT : 0;
@@ -1537,7 +1672,8 @@ static long intel_vgpu_ioctl(struct mdev_device *mdev, unsigned int cmd,
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

