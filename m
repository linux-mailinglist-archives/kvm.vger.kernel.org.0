Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92634BC1EC
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2019 08:43:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503898AbfIXGn3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Sep 2019 02:43:29 -0400
Received: from mga02.intel.com ([134.134.136.20]:25186 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2503891AbfIXGnS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Sep 2019 02:43:18 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Sep 2019 23:43:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,543,1559545200"; 
   d="scan'208";a="203306331"
Received: from gvt.bj.intel.com ([10.238.158.180])
  by fmsmga001.fm.intel.com with ESMTP; 23 Sep 2019 23:43:15 -0700
From:   Tina Zhang <tina.zhang@intel.com>
To:     intel-gvt-dev@lists.freedesktop.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Kechen Lu <kechen.lu@intel.com>, kraxel@redhat.com,
        zhenyuw@linux.intel.com, zhiyuan.lv@intel.com,
        zhi.a.wang@intel.com, kevin.tian@intel.com, hang.yuan@intel.com,
        alex.williamson@redhat.com, yi.l.liu@intel.com,
        Tina Zhang <tina.zhang@intel.com>
Subject: [PATCH v6 5/6] drm/i915/gvt: Deliver async primary plane page flip events at vblank
Date:   Tue, 24 Sep 2019 14:41:42 +0800
Message-Id: <20190924064143.9282-6-tina.zhang@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190924064143.9282-1-tina.zhang@intel.com>
References: <20190924064143.9282-1-tina.zhang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Kechen Lu <kechen.lu@intel.com>

Only sync primary plane page flip events are checked and delivered
as the display refresh events before, this patch tries to deliver async
primary page flip events bounded by vblanks.

To deliver correct async page flip, the new async flip bitmap is
introduced and in vblank emulation handler to check bitset.

Signed-off-by: Kechen Lu <kechen.lu@intel.com>
Signed-off-by: Tina Zhang <tina.zhang@intel.com>
---
 drivers/gpu/drm/i915/gvt/cmd_parser.c |  6 ++++--
 drivers/gpu/drm/i915/gvt/display.c    | 10 ++++++++++
 drivers/gpu/drm/i915/gvt/gvt.h        |  2 ++
 drivers/gpu/drm/i915/gvt/handlers.c   |  5 +++--
 4 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/i915/gvt/cmd_parser.c b/drivers/gpu/drm/i915/gvt/cmd_parser.c
index e753b1e706e2..1abb05431177 100644
--- a/drivers/gpu/drm/i915/gvt/cmd_parser.c
+++ b/drivers/gpu/drm/i915/gvt/cmd_parser.c
@@ -1365,9 +1365,11 @@ static int gen8_update_plane_mmio_from_mi_display_flip(
 	if (info->plane == PLANE_PRIMARY)
 		vgpu_vreg_t(vgpu, PIPE_FLIPCOUNT_G4X(info->pipe))++;
 
-	if (info->async_flip)
+	if (info->async_flip) {
 		intel_vgpu_trigger_virtual_event(vgpu, info->event);
-	else
+		set_bit(info->plane,
+			vgpu->display.async_flip_event[info->pipe]);
+	} else
 		set_bit(info->event, vgpu->irq.flip_done_event[info->pipe]);
 
 	return 0;
diff --git a/drivers/gpu/drm/i915/gvt/display.c b/drivers/gpu/drm/i915/gvt/display.c
index 9f2c2cd10369..9acde0bdd5f4 100644
--- a/drivers/gpu/drm/i915/gvt/display.c
+++ b/drivers/gpu/drm/i915/gvt/display.c
@@ -419,6 +419,16 @@ static void emulate_vblank_on_pipe(struct intel_vgpu *vgpu, int pipe)
 		intel_vgpu_trigger_virtual_event(vgpu, event);
 	}
 
+	for_each_set_bit(event, vgpu->display.async_flip_event[pipe],
+			I915_MAX_PLANES) {
+		clear_bit(event, vgpu->display.async_flip_event[pipe]);
+		if (!pipe_is_enabled(vgpu, pipe))
+			continue;
+
+		if (event == PLANE_PRIMARY)
+			eventfd_signal_val |= DISPLAY_PRI_REFRESH_EVENT_VAL;
+	}
+
 	if (eventfd_signal_val)
 		vgpu->no_pageflip_count = 0;
 	else if (!eventfd_signal_val && vgpu->no_pageflip_count > PAGEFLIP_DELAY_THR)
diff --git a/drivers/gpu/drm/i915/gvt/gvt.h b/drivers/gpu/drm/i915/gvt/gvt.h
index cc39b449b061..73769a87b407 100644
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
index 45a9124e53b6..e5a022c2e7bb 100644
--- a/drivers/gpu/drm/i915/gvt/handlers.c
+++ b/drivers/gpu/drm/i915/gvt/handlers.c
@@ -760,9 +760,10 @@ static int pri_surf_mmio_write(struct intel_vgpu *vgpu, unsigned int offset,
 
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

