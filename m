Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C1342B096
	for <lists+kvm@lfdr.de>; Mon, 27 May 2019 10:49:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725908AbfE0Ist (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 May 2019 04:48:49 -0400
Received: from mga03.intel.com ([134.134.136.65]:65534 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726500AbfE0Ist (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 May 2019 04:48:49 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 May 2019 01:48:48 -0700
X-ExtLoop1: 1
Received: from gvt.bj.intel.com ([10.238.158.187])
  by fmsmga004.fm.intel.com with ESMTP; 27 May 2019 01:48:45 -0700
From:   Tina Zhang <tina.zhang@intel.com>
Cc:     Tina Zhang <tina.zhang@intel.com>,
        intel-gvt-dev@lists.freedesktop.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kraxel@redhat.com,
        zhenyuw@linux.intel.com, alex.williamson@redhat.com,
        hang.yuan@intel.com, zhiyuan.lv@intel.com
Subject: [PATCH 2/2] drm/i915/gvt: Support delivering page flip event to userspace
Date:   Mon, 27 May 2019 16:43:12 +0800
Message-Id: <20190527084312.8872-3-tina.zhang@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190527084312.8872-1-tina.zhang@intel.com>
References: <20190527084312.8872-1-tina.zhang@intel.com>
To:     unlisted-recipients:; (no To-header on input)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use the eventfd based signaling mechanism provided by vfio/display
to deliver vGPU framebuffer page flip event to userspace.

Signed-off-by: Tina Zhang <tina.zhang@intel.com>
---
 drivers/gpu/drm/i915/gvt/dmabuf.c   | 31 +++++++++++++++++++++++++++++
 drivers/gpu/drm/i915/gvt/dmabuf.h   |  1 +
 drivers/gpu/drm/i915/gvt/gvt.c      |  1 +
 drivers/gpu/drm/i915/gvt/gvt.h      |  2 ++
 drivers/gpu/drm/i915/gvt/handlers.c |  2 ++
 drivers/gpu/drm/i915/gvt/kvmgt.c    |  7 +++++++
 6 files changed, 44 insertions(+)

diff --git a/drivers/gpu/drm/i915/gvt/dmabuf.c b/drivers/gpu/drm/i915/gvt/dmabuf.c
index 4e1e425189ba..f2ed45616d72 100644
--- a/drivers/gpu/drm/i915/gvt/dmabuf.c
+++ b/drivers/gpu/drm/i915/gvt/dmabuf.c
@@ -538,6 +538,35 @@ int intel_vgpu_get_dmabuf(struct intel_vgpu *vgpu, unsigned int dmabuf_id)
 	return ret;
 }
 
+static void release_flip_eventfd_ctx(struct intel_vgpu *vgpu)
+{
+	struct eventfd_ctx **trigger = &vgpu->page_flip_trigger;
+
+	if (*trigger) {
+		eventfd_ctx_put(*trigger);
+		*trigger = NULL;
+	}
+}
+
+int intel_vgpu_set_flip_eventfd(struct intel_vgpu *vgpu, int fd)
+{
+	struct eventfd_ctx *trigger;
+
+	if (fd == -1) {
+		release_flip_eventfd_ctx(vgpu);
+	} else if (fd >= 0) {
+		trigger = eventfd_ctx_fdget(fd);
+		if (IS_ERR(trigger)) {
+			gvt_vgpu_err("eventfd_ctx_fdget failed\n");
+			return PTR_ERR(trigger);
+		}
+		vgpu->page_flip_trigger = trigger;
+	} else
+		return -EINVAL;
+
+	return 0;
+}
+
 void intel_vgpu_dmabuf_cleanup(struct intel_vgpu *vgpu)
 {
 	struct list_head *pos, *n;
@@ -561,4 +590,6 @@ void intel_vgpu_dmabuf_cleanup(struct intel_vgpu *vgpu)
 
 	}
 	mutex_unlock(&vgpu->dmabuf_lock);
+
+	release_flip_eventfd_ctx(vgpu);
 }
diff --git a/drivers/gpu/drm/i915/gvt/dmabuf.h b/drivers/gpu/drm/i915/gvt/dmabuf.h
index 5f8f03fb1d1b..4d9caa3732d2 100644
--- a/drivers/gpu/drm/i915/gvt/dmabuf.h
+++ b/drivers/gpu/drm/i915/gvt/dmabuf.h
@@ -62,6 +62,7 @@ struct intel_vgpu_dmabuf_obj {
 
 int intel_vgpu_query_plane(struct intel_vgpu *vgpu, void *args);
 int intel_vgpu_get_dmabuf(struct intel_vgpu *vgpu, unsigned int dmabuf_id);
+int intel_vgpu_set_flip_eventfd(struct intel_vgpu *vgpu, int fd);
 void intel_vgpu_dmabuf_cleanup(struct intel_vgpu *vgpu);
 
 #endif
diff --git a/drivers/gpu/drm/i915/gvt/gvt.c b/drivers/gpu/drm/i915/gvt/gvt.c
index 43f4242062dd..7fd4afa432ef 100644
--- a/drivers/gpu/drm/i915/gvt/gvt.c
+++ b/drivers/gpu/drm/i915/gvt/gvt.c
@@ -184,6 +184,7 @@ static const struct intel_gvt_ops intel_gvt_ops = {
 	.get_gvt_attrs = intel_get_gvt_attrs,
 	.vgpu_query_plane = intel_vgpu_query_plane,
 	.vgpu_get_dmabuf = intel_vgpu_get_dmabuf,
+	.vgpu_set_flip_eventfd = intel_vgpu_set_flip_eventfd,
 	.write_protect_handler = intel_vgpu_page_track_handler,
 	.emulate_hotplug = intel_vgpu_emulate_hotplug,
 };
diff --git a/drivers/gpu/drm/i915/gvt/gvt.h b/drivers/gpu/drm/i915/gvt/gvt.h
index f5a328b5290a..86ca223f9a60 100644
--- a/drivers/gpu/drm/i915/gvt/gvt.h
+++ b/drivers/gpu/drm/i915/gvt/gvt.h
@@ -229,6 +229,7 @@ struct intel_vgpu {
 	struct completion vblank_done;
 
 	u32 scan_nonprivbb;
+	struct eventfd_ctx *page_flip_trigger;
 };
 
 /* validating GM healthy status*/
@@ -570,6 +571,7 @@ struct intel_gvt_ops {
 			struct attribute_group ***intel_vgpu_type_groups);
 	int (*vgpu_query_plane)(struct intel_vgpu *vgpu, void *);
 	int (*vgpu_get_dmabuf)(struct intel_vgpu *vgpu, unsigned int);
+	int (*vgpu_set_flip_eventfd)(struct intel_vgpu *vgpu, int fd);
 	int (*write_protect_handler)(struct intel_vgpu *, u64, void *,
 				     unsigned int);
 	void (*emulate_hotplug)(struct intel_vgpu *vgpu, bool connected);
diff --git a/drivers/gpu/drm/i915/gvt/handlers.c b/drivers/gpu/drm/i915/gvt/handlers.c
index 18f01eeb2510..1b5455888bdf 100644
--- a/drivers/gpu/drm/i915/gvt/handlers.c
+++ b/drivers/gpu/drm/i915/gvt/handlers.c
@@ -763,6 +763,8 @@ static int pri_surf_mmio_write(struct intel_vgpu *vgpu, unsigned int offset,
 	else
 		set_bit(event, vgpu->irq.flip_done_event[pipe]);
 
+	eventfd_signal(vgpu->page_flip_trigger, 1);
+
 	return 0;
 }
 
diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
index a68addf95c23..00c75bd76bc0 100644
--- a/drivers/gpu/drm/i915/gvt/kvmgt.c
+++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
@@ -1547,6 +1547,13 @@ static long intel_vgpu_ioctl(struct mdev_device *mdev, unsigned int cmd,
 		dmabuf_fd = intel_gvt_ops->vgpu_get_dmabuf(vgpu, dmabuf_id);
 		return dmabuf_fd;
 
+	} else if (cmd == VFIO_DEVICE_SET_GFX_FLIP_EVENTFD) {
+		__s32 event_fd;
+
+		if (get_user(event_fd, (__s32 __user *)arg))
+			return -EFAULT;
+
+		return intel_gvt_ops->vgpu_set_flip_eventfd(vgpu, event_fd);
 	}
 
 	return -ENOTTY;
-- 
2.17.1

