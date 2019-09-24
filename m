Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0481BBC1F1
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2019 08:43:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503801AbfIXGnM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Sep 2019 02:43:12 -0400
Received: from mga02.intel.com ([134.134.136.20]:25186 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2503719AbfIXGnK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Sep 2019 02:43:10 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Sep 2019 23:43:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,543,1559545200"; 
   d="scan'208";a="203306309"
Received: from gvt.bj.intel.com ([10.238.158.180])
  by fmsmga001.fm.intel.com with ESMTP; 23 Sep 2019 23:43:07 -0700
From:   Tina Zhang <tina.zhang@intel.com>
To:     intel-gvt-dev@lists.freedesktop.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Tina Zhang <tina.zhang@intel.com>, kraxel@redhat.com,
        zhenyuw@linux.intel.com, zhiyuan.lv@intel.com,
        zhi.a.wang@intel.com, kevin.tian@intel.com, hang.yuan@intel.com,
        alex.williamson@redhat.com, yi.l.liu@intel.com
Subject: [PATCH v6 2/6] vfio: Introduce vGPU display irq type
Date:   Tue, 24 Sep 2019 14:41:39 +0800
Message-Id: <20190924064143.9282-3-tina.zhang@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190924064143.9282-1-tina.zhang@intel.com>
References: <20190924064143.9282-1-tina.zhang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce vGPU specific irq type VFIO_IRQ_TYPE_GFX, and
VFIO_IRQ_SUBTYPE_GFX_DISPLAY_IRQ as the subtype for vGPU display.

Introduce vfio_irq_info_cap_display_plane_events capability to notify
user space with the vGPU's plane update events

v3:
- Add more description to VFIO_IRQ_SUBTYPE_GFX_DISPLAY_IRQ and
  VFIO_IRQ_INFO_CAP_DISPLAY. (Alex & Gerd)

v2:
- Add VFIO_IRQ_SUBTYPE_GFX_DISPLAY_IRQ description. (Alex & Kechen)
- Introduce vfio_irq_info_cap_display_plane_events. (Gerd & Alex)

Signed-off-by: Tina Zhang <tina.zhang@intel.com>
---
 include/uapi/linux/vfio.h | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index aa6850f1daef..2946a028b0c3 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -476,6 +476,44 @@ struct vfio_irq_info_cap_type {
 	__u32 subtype;  /* type specific */
 };
 
+/* vGPU IRQ TYPE */
+#define VFIO_IRQ_TYPE_GFX			(1)
+
+/* sub-types for VFIO_IRQ_TYPE_GFX */
+/*
+ * vGPU device display refresh interrupt request. This irq asking for
+ * a user space display refresh, covers all display updates events,
+ * i.e. user space can stop the display update timer and fully depend
+ * on getting the notification if an update is needed.
+ */
+#define VFIO_IRQ_SUBTYPE_GFX_DISPLAY_IRQ	(1)
+
+/*
+ * Display capability of reporting display refresh interrupt events.
+ * This gives user space the capability to identify different display
+ * updates events of the display refresh interrupt request.
+ *
+ * When notified by VFIO_IRQ_SUBTYPE_GFX_DISPLAY_IRQ, user space can
+ * use the eventfd counter value to identify which plane has been
+ * updated.
+ *
+ * Note that there might be some cases like counter_value >
+ * (cur_event_val + pri_event_val), if notifications haven't been
+ * handled on time in user mode. These cases can be handled as all
+ * plane updated case or signle plane updated case depending on the
+ * value.
+ *
+ * cur_event_val: eventfd counter value for cursor plane change event.
+ * pri_event_val: eventfd counter value for primary plane change event.
+ */
+#define VFIO_IRQ_INFO_CAP_DISPLAY	2
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

