Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0E45BC1EA
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2019 08:43:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503900AbfIXGnW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Sep 2019 02:43:22 -0400
Received: from mga02.intel.com ([134.134.136.20]:25208 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2503906AbfIXGnV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Sep 2019 02:43:21 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Sep 2019 23:43:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,543,1559545200"; 
   d="scan'208";a="203306339"
Received: from gvt.bj.intel.com ([10.238.158.180])
  by fmsmga001.fm.intel.com with ESMTP; 23 Sep 2019 23:43:17 -0700
From:   Tina Zhang <tina.zhang@intel.com>
To:     intel-gvt-dev@lists.freedesktop.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Kechen Lu <kechen.lu@intel.com>, kraxel@redhat.com,
        zhenyuw@linux.intel.com, zhiyuan.lv@intel.com,
        zhi.a.wang@intel.com, kevin.tian@intel.com, hang.yuan@intel.com,
        alex.williamson@redhat.com, yi.l.liu@intel.com,
        Tina Zhang <tina.zhang@intel.com>
Subject: [PATCH v6 6/6] drm/i915/gvt: Add cursor plane reg update trap emulation handler
Date:   Tue, 24 Sep 2019 14:41:43 +0800
Message-Id: <20190924064143.9282-7-tina.zhang@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190924064143.9282-1-tina.zhang@intel.com>
References: <20190924064143.9282-1-tina.zhang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Kechen Lu <kechen.lu@intel.com>

This patch adds the cursor plane CURBASE reg update trap handler
in order to:

- Deliver the cursor refresh event at each vblank emulation,
the flip_done_event bit check is supposed to do here. If cursor
plane updates happen, deliver the cursor refresh events.

- Support the sync and async cursor plane updates and
corresponding cursor plane flip interrupts reporting.

v2:
- As the suggestion from Zhenyu, the experiments show that
Windows driver programs the CURBASE and CURPOS at one time as
well as the Linux i915 driver. So only track the CURBASE is
enough.

Signed-off-by: Kechen Lu <kechen.lu@intel.com>
Signed-off-by: Tina Zhang <tina.zhang@intel.com>
---
 drivers/gpu/drm/i915/gvt/display.c   |  7 +++++++
 drivers/gpu/drm/i915/gvt/handlers.c  | 27 ++++++++++++++++++++++++---
 drivers/gpu/drm/i915/gvt/interrupt.c |  7 +++++++
 drivers/gpu/drm/i915/gvt/interrupt.h |  3 +++
 4 files changed, 41 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/gvt/display.c b/drivers/gpu/drm/i915/gvt/display.c
index 9acde0bdd5f4..12a03c3b9051 100644
--- a/drivers/gpu/drm/i915/gvt/display.c
+++ b/drivers/gpu/drm/i915/gvt/display.c
@@ -401,6 +401,7 @@ static void emulate_vblank_on_pipe(struct intel_vgpu *vgpu, int pipe)
 		[PIPE_C] = PIPE_C_VBLANK,
 	};
 	int pri_flip_event = SKL_FLIP_EVENT(pipe, PLANE_PRIMARY);
+	int cur_flip_event = CURSOR_A_FLIP_DONE + pipe;
 	int event;
 	u64 eventfd_signal_val = 0;
 
@@ -416,6 +417,9 @@ static void emulate_vblank_on_pipe(struct intel_vgpu *vgpu, int pipe)
 		if (event == pri_flip_event)
 			eventfd_signal_val |= DISPLAY_PRI_REFRESH_EVENT_VAL;
 
+		if (event == cur_flip_event)
+			eventfd_signal_val |= DISPLAY_CUR_REFRESH_EVENT_VAL;
+
 		intel_vgpu_trigger_virtual_event(vgpu, event);
 	}
 
@@ -427,6 +431,9 @@ static void emulate_vblank_on_pipe(struct intel_vgpu *vgpu, int pipe)
 
 		if (event == PLANE_PRIMARY)
 			eventfd_signal_val |= DISPLAY_PRI_REFRESH_EVENT_VAL;
+
+		if (event == PLANE_CURSOR)
+			eventfd_signal_val |= DISPLAY_CUR_REFRESH_EVENT_VAL;
 	}
 
 	if (eventfd_signal_val)
diff --git a/drivers/gpu/drm/i915/gvt/handlers.c b/drivers/gpu/drm/i915/gvt/handlers.c
index e5a022c2e7bb..deb1bf5ba028 100644
--- a/drivers/gpu/drm/i915/gvt/handlers.c
+++ b/drivers/gpu/drm/i915/gvt/handlers.c
@@ -769,6 +769,27 @@ static int pri_surf_mmio_write(struct intel_vgpu *vgpu, unsigned int offset,
 	return 0;
 }
 
+#define CURBASE_TO_PIPE(offset) \
+	calc_index(offset, _CURABASE, _CURBBASE, 0, CURBASE(PIPE_C))
+
+static int cur_surf_mmio_write(struct intel_vgpu *vgpu, unsigned int offset,
+		void *p_data, unsigned int bytes)
+{
+	struct drm_i915_private *dev_priv = vgpu->gvt->dev_priv;
+	u32 pipe = CURBASE_TO_PIPE(offset);
+	int event = CURSOR_A_FLIP_DONE + pipe;
+
+	write_vreg(vgpu, offset, p_data, bytes);
+
+	if (vgpu_vreg_t(vgpu, CURCNTR(pipe)) & PLANE_CTL_ASYNC_FLIP) {
+		intel_vgpu_trigger_virtual_event(vgpu, event);
+		set_bit(PLANE_CURSOR, vgpu->display.async_flip_event[pipe]);
+	} else
+		set_bit(event, vgpu->irq.flip_done_event[pipe]);
+
+	return 0;
+}
+
 #define SPRSURF_TO_PIPE(offset) \
 	calc_index(offset, _SPRA_SURF, _SPRB_SURF, 0, SPRSURF(PIPE_C))
 
@@ -1990,9 +2011,9 @@ static int init_generic_mmio_info(struct intel_gvt *gvt)
 	MMIO_D(CURPOS(PIPE_B), D_ALL);
 	MMIO_D(CURPOS(PIPE_C), D_ALL);
 
-	MMIO_D(CURBASE(PIPE_A), D_ALL);
-	MMIO_D(CURBASE(PIPE_B), D_ALL);
-	MMIO_D(CURBASE(PIPE_C), D_ALL);
+	MMIO_DH(CURBASE(PIPE_A), D_ALL, NULL, cur_surf_mmio_write);
+	MMIO_DH(CURBASE(PIPE_B), D_ALL, NULL, cur_surf_mmio_write);
+	MMIO_DH(CURBASE(PIPE_C), D_ALL, NULL, cur_surf_mmio_write);
 
 	MMIO_D(CUR_FBC_CTL(PIPE_A), D_ALL);
 	MMIO_D(CUR_FBC_CTL(PIPE_B), D_ALL);
diff --git a/drivers/gpu/drm/i915/gvt/interrupt.c b/drivers/gpu/drm/i915/gvt/interrupt.c
index 11accd3e1023..8e43490c88d6 100644
--- a/drivers/gpu/drm/i915/gvt/interrupt.c
+++ b/drivers/gpu/drm/i915/gvt/interrupt.c
@@ -113,6 +113,9 @@ static const char * const irq_name[INTEL_GVT_EVENT_MAX] = {
 	[SPRITE_A_FLIP_DONE] = "Sprite Plane A flip done",
 	[SPRITE_B_FLIP_DONE] = "Sprite Plane B flip done",
 	[SPRITE_C_FLIP_DONE] = "Sprite Plane C flip done",
+	[CURSOR_A_FLIP_DONE] = "Cursor Plane A flip done",
+	[CURSOR_B_FLIP_DONE] = "Cursor Plane B flip done",
+	[CURSOR_C_FLIP_DONE] = "Cursor Plane C flip done",
 
 	[PCU_THERMAL] = "PCU Thermal Event",
 	[PCU_PCODE2DRIVER_MAILBOX] = "PCU pcode2driver mailbox event",
@@ -593,6 +596,10 @@ static void gen8_init_irq(
 		SET_BIT_INFO(irq, 4, SPRITE_A_FLIP_DONE, INTEL_GVT_IRQ_INFO_DE_PIPE_A);
 		SET_BIT_INFO(irq, 4, SPRITE_B_FLIP_DONE, INTEL_GVT_IRQ_INFO_DE_PIPE_B);
 		SET_BIT_INFO(irq, 4, SPRITE_C_FLIP_DONE, INTEL_GVT_IRQ_INFO_DE_PIPE_C);
+
+		SET_BIT_INFO(irq, 6, CURSOR_A_FLIP_DONE, INTEL_GVT_IRQ_INFO_DE_PIPE_A);
+		SET_BIT_INFO(irq, 6, CURSOR_B_FLIP_DONE, INTEL_GVT_IRQ_INFO_DE_PIPE_B);
+		SET_BIT_INFO(irq, 6, CURSOR_C_FLIP_DONE, INTEL_GVT_IRQ_INFO_DE_PIPE_C);
 	}
 
 	/* GEN8 interrupt PCU events */
diff --git a/drivers/gpu/drm/i915/gvt/interrupt.h b/drivers/gpu/drm/i915/gvt/interrupt.h
index 5313fb1b33e1..158f1c7a23f2 100644
--- a/drivers/gpu/drm/i915/gvt/interrupt.h
+++ b/drivers/gpu/drm/i915/gvt/interrupt.h
@@ -92,6 +92,9 @@ enum intel_gvt_event_type {
 	SPRITE_A_FLIP_DONE,
 	SPRITE_B_FLIP_DONE,
 	SPRITE_C_FLIP_DONE,
+	CURSOR_A_FLIP_DONE,
+	CURSOR_B_FLIP_DONE,
+	CURSOR_C_FLIP_DONE,
 
 	PCU_THERMAL,
 	PCU_PCODE2DRIVER_MAILBOX,
-- 
2.17.1

