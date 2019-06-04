Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5536343A4
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2019 12:01:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727179AbfFDKBZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jun 2019 06:01:25 -0400
Received: from mga06.intel.com ([134.134.136.31]:46146 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727197AbfFDKBW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jun 2019 06:01:22 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Jun 2019 03:01:22 -0700
X-ExtLoop1: 1
Received: from gvt.bj.intel.com ([10.238.158.187])
  by orsmga005.jf.intel.com with ESMTP; 04 Jun 2019 03:01:19 -0700
From:   Tina Zhang <tina.zhang@intel.com>
To:     intel-gvt-dev@lists.freedesktop.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Tina Zhang <tina.zhang@intel.com>, kraxel@redhat.com,
        zhenyuw@linux.intel.com, zhiyuan.lv@intel.com,
        zhi.a.wang@intel.com, kevin.tian@intel.com, hang.yuan@intel.com,
        alex.williamson@redhat.com
Subject: [RFC PATCH v2 3/3] drm/i915/gvt: Send plane flip events to user space
Date:   Tue,  4 Jun 2019 17:55:34 +0800
Message-Id: <20190604095534.10337-4-tina.zhang@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190604095534.10337-1-tina.zhang@intel.com>
References: <20190604095534.10337-1-tina.zhang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Send the primary plane and the cursor plane flip events to user space.

Signed-off-by: Tina Zhang <tina.zhang@intel.com>
---
 drivers/gpu/drm/i915/gvt/handlers.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/gvt/handlers.c b/drivers/gpu/drm/i915/gvt/handlers.c
index 18f01eeb2510..67129de8bc45 100644
--- a/drivers/gpu/drm/i915/gvt/handlers.c
+++ b/drivers/gpu/drm/i915/gvt/handlers.c
@@ -763,6 +763,20 @@ static int pri_surf_mmio_write(struct intel_vgpu *vgpu, unsigned int offset,
 	else
 		set_bit(event, vgpu->irq.flip_done_event[pipe]);
 
+	if (vgpu->vdev.pri_flip_trigger)
+		eventfd_signal(vgpu->vdev.pri_flip_trigger, 1);
+
+	return 0;
+}
+
+static int cur_surf_mmio_write(struct intel_vgpu *vgpu, unsigned int offset,
+		void *p_data, unsigned int bytes)
+{
+	write_vreg(vgpu, offset, p_data, bytes);
+
+	if (vgpu->vdev.cur_flip_trigger)
+		eventfd_signal(vgpu->vdev.cur_flip_trigger, 1);
+
 	return 0;
 }
 
@@ -1969,9 +1983,9 @@ static int init_generic_mmio_info(struct intel_gvt *gvt)
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
-- 
2.17.1

