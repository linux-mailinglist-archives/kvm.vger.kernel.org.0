Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2199F8F90B
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2019 04:37:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726668AbfHPCgE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Aug 2019 22:36:04 -0400
Received: from mga07.intel.com ([134.134.136.100]:39512 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726414AbfHPCgC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Aug 2019 22:36:02 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Aug 2019 19:35:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,391,1559545200"; 
   d="scan'208";a="194894840"
Received: from gvt.bj.intel.com ([10.238.158.180])
  by fmsmga001.fm.intel.com with ESMTP; 15 Aug 2019 19:35:47 -0700
From:   Tina Zhang <tina.zhang@intel.com>
To:     intel-gvt-dev@lists.freedesktop.org
Cc:     Tina Zhang <tina.zhang@intel.com>, kraxel@redhat.com,
        alex.williamson@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, hang.yuan@intel.com,
        zhiyuan.lv@intel.com
Subject: [PATCH v5 2/6] vfio: Introduce vGPU display irq type
Date:   Fri, 16 Aug 2019 10:35:24 +0800
Message-Id: <20190816023528.30210-3-tina.zhang@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190816023528.30210-1-tina.zhang@intel.com>
References: <20190816023528.30210-1-tina.zhang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce vGPU specific irq type VFIO_IRQ_TYPE_GFX, and
VFIO_IRQ_SUBTYPE_GFX_DISPLAY_IRQ as the subtype for vGPU display.

Introduce vfio_irq_info_cap_display_plane_events capability to notify
user space with the vGPU's plane update events

v2:
- Add VFIO_IRQ_SUBTYPE_GFX_DISPLAY_IRQ description. (Alex & Kechen)
- Introduce vfio_irq_info_cap_display_plane_events. (Gerd & Alex)

Signed-off-by: Tina Zhang <tina.zhang@intel.com>
---
 include/uapi/linux/vfio.h | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index d83c9f136a5b..21ac69f0e1a9 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -465,6 +465,27 @@ struct vfio_irq_info_cap_type {
 	__u32 subtype;  /* type specific */
 };
 
+#define VFIO_IRQ_TYPE_GFX				(1)
+/*
+ * vGPU vendor sub-type
+ * vGPU device display related interrupts e.g. vblank/pageflip
+ */
+#define VFIO_IRQ_SUBTYPE_GFX_DISPLAY_IRQ		(1)
+
+/*
+ * Display capability of using one eventfd to notify user space with the
+ * vGPU's plane update events.
+ * cur_event_val: eventfd value stands for cursor plane change event.
+ * pri_event_val: eventfd value stands for primary plane change event.
+ */
+#define VFIO_IRQ_INFO_CAP_DISPLAY	4
+
+struct vfio_irq_info_cap_display_plane_events {
+	struct vfio_info_cap_header header;
+	__u64 cur_event_val;
+	__u64 pri_event_val;
+};
+
 /**
  * VFIO_DEVICE_SET_IRQS - _IOW(VFIO_TYPE, VFIO_BASE + 10, struct vfio_irq_set)
  *
-- 
2.17.1

