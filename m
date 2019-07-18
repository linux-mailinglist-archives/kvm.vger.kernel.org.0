Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A1266CA7B
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2019 09:59:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389446AbfGRH5z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Jul 2019 03:57:55 -0400
Received: from mga03.intel.com ([134.134.136.65]:59108 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726572AbfGRH5y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Jul 2019 03:57:54 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Jul 2019 00:57:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,276,1559545200"; 
   d="scan'208";a="158713118"
Received: from gvt-optiplex-7060.bj.intel.com ([10.238.158.89])
  by orsmga007.jf.intel.com with ESMTP; 18 Jul 2019 00:57:51 -0700
From:   Kechen Lu <kechen.lu@intel.com>
To:     intel-gvt-dev@lists.freedesktop.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Kechen Lu <kechen.lu@intel.com>, kraxel@redhat.com,
        zhenyuw@linux.intel.com, zhiyuan.lv@intel.com,
        zhi.a.wang@intel.com, kevin.tian@intel.com, hang.yuan@intel.com,
        alex.williamson@redhat.com
Subject: [RFC PATCH v4 5/6] drm/i915/gvt: Deliver async primary plane page flip events at vblank
Date:   Thu, 18 Jul 2019 23:56:39 +0800
Message-Id: <20190718155640.25928-6-kechen.lu@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190718155640.25928-1-kechen.lu@intel.com>
References: <20190718155640.25928-1-kechen.lu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Only sync primary plane page flip events are checked and delivered
as the display refresh events before, this patch tries to deliver async
primary page flip events bounded by vblanks.

To deliver correct async page flip, the new async flip bitmap is
introduced and in vblank emulation handler to check bitset.

Signed-off-by: Kechen Lu <kechen.lu@intel.com>
---
 drivers/gpu/drm/i915/gvt/cmd_parser.c |  5 +++--
 drivers/gpu/drm/i915/gvt/display.c    | 12 ++++++++++++
 drivers/gpu/drm/i915/gvt/gvt.h        |  2 ++
 drivers/gpu/drm/i915/gvt/handlers.c   |  5 +++--
 4 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/i915/gvt/cmd_parser.c b/drivers/gpu/drm/i915/gvt/cmd_parser.c
index 5cb59c0b4bbe..e504cc7be559 100644
--- a/drivers/gpu/drm/i915/gvt/cmd_parser.c
+++ b/drivers/gpu/drm/i915/gvt/cmd_parser.c
@@ -1334,9 +1334,10 @@ static int gen8_update_plane_mmio_from_mi_display_flip(
 	if (info->plane == PLANE_PRIMARY)
 		vgpu_vreg_t(vgpu, PIPE_FLIPCOUNT_G4X(info->pipe))++;
 
-	if (info->async_flip)
+	if (info->async_flip) {
 		intel_vgpu_trigger_virtual_event(vgpu, info->event);
-	else
+		set_bit(info->plane, vgpu->display.async_flip_event[info->pipe]);
+	} else
 		set_bit(info->event, vgpu->irq.flip_done_event[info->pipe]);
 
 	return 0;
diff --git a/drivers/gpu/drm/i915/gvt/display.c b/drivers/gpu/drm/i915/gvt/display.c
index 036db8199983..df52e4b4c1b0 100644
--- a/drivers/gpu/drm/i915/gvt/display.c
+++ b/drivers/gpu/drm/i915/gvt/display.c
@@ -420,6 +420,18 @@ static void emulate_vblank_on_pipe(struct intel_vgpu *vgpu, int pipe)
 		intel_vgpu_trigger_virtual_event(vgpu, event);
 	}
 
+	for_each_set_bit(event, vgpu->display.async_flip_event[pipe],
+			I915_MAX_PLANES) {
+		clear_bit(event, vgpu->display.async_flip_event[pipe]);
+		if (!pipe_is_enabled(vgpu, pipe))
+			continue;
+
+		if (event == PLANE_PRIMARY) {
+			eventfd_signal_val += DISPLAY_PRI_REFRESH_EVENT_INC;
+			pageflip_count += PAGEFLIP_INC_COUNT;
+		}
+	}
+
 	if (--pageflip_count < 0) {
 		eventfd_signal_val += DISPLAY_PRI_REFRESH_EVENT_INC;
 		pageflip_count = 0;
diff --git a/drivers/gpu/drm/i915/gvt/gvt.h b/drivers/gpu/drm/i915/gvt/gvt.h
index b654b6fa0663..98a3dc309acb 100644
--- a/drivers/gpu/drm/i915/gvt/gvt.h
+++ b/drivers/gpu/drm/i915/gvt/gvt.h
@@ -128,6 +128,8 @@ struct intel_vgpu_display {
 	struct intel_vgpu_i2c_edid i2c_edid;
 	struct intel_vgpu_port ports[I915_MAX_PORTS];
 	struct intel_vgpu_sbi sbi;
+	DECLARE_BITMAP(async_flip_event[I915_MAX_PIPES],
+		       I915_MAX_PLANES);
 };
 
 struct vgpu_sched_ctl {
diff --git a/drivers/gpu/drm/i915/gvt/handlers.c b/drivers/gpu/drm/i915/gvt/handlers.c
index e09bd6e0cc4d..6ad29c4f08e5 100644
--- a/drivers/gpu/drm/i915/gvt/handlers.c
+++ b/drivers/gpu/drm/i915/gvt/handlers.c
@@ -758,9 +758,10 @@ static int pri_surf_mmio_write(struct intel_vgpu *vgpu, unsigned int offset,
 
 	vgpu_vreg_t(vgpu, PIPE_FLIPCOUNT_G4X(pipe))++;
 
-	if (vgpu_vreg_t(vgpu, DSPCNTR(pipe)) & PLANE_CTL_ASYNC_FLIP)
+	if (vgpu_vreg_t(vgpu, DSPCNTR(pipe)) & PLANE_CTL_ASYNC_FLIP) {
 		intel_vgpu_trigger_virtual_event(vgpu, event);
-	else
+		set_bit(PLANE_PRIMARY, vgpu->display.async_flip_event[pipe]);
+	} else
 		set_bit(event, vgpu->irq.flip_done_event[pipe]);
 
 	return 0;
-- 
2.17.1

