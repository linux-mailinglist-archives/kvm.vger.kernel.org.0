Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20A043439C
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2019 12:01:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727228AbfFDKBS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jun 2019 06:01:18 -0400
Received: from mga06.intel.com ([134.134.136.31]:46146 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727180AbfFDKBR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jun 2019 06:01:17 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Jun 2019 03:01:16 -0700
X-ExtLoop1: 1
Received: from gvt.bj.intel.com ([10.238.158.187])
  by orsmga005.jf.intel.com with ESMTP; 04 Jun 2019 03:01:14 -0700
From:   Tina Zhang <tina.zhang@intel.com>
To:     intel-gvt-dev@lists.freedesktop.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Tina Zhang <tina.zhang@intel.com>, kraxel@redhat.com,
        zhenyuw@linux.intel.com, zhiyuan.lv@intel.com,
        zhi.a.wang@intel.com, kevin.tian@intel.com, hang.yuan@intel.com,
        alex.williamson@redhat.com
Subject: [RFC PATCH v2 1/3] vfio: Use capability chains to handle device specific irq
Date:   Tue,  4 Jun 2019 17:55:32 +0800
Message-Id: <20190604095534.10337-2-tina.zhang@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190604095534.10337-1-tina.zhang@intel.com>
References: <20190604095534.10337-1-tina.zhang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Caps the number of irqs with fixed indexes and uses capability chains
to chain device specific irqs.

VFIO vGPU leverages this mechanism to trigger primary plane and cursor
plane page flip event to the user space.

Signed-off-by: Tina Zhang <tina.zhang@intel.com>
---
 include/uapi/linux/vfio.h | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 02bb7ad6e986..9b5e25937c7d 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -444,11 +444,31 @@ struct vfio_irq_info {
 #define VFIO_IRQ_INFO_MASKABLE		(1 << 1)
 #define VFIO_IRQ_INFO_AUTOMASKED	(1 << 2)
 #define VFIO_IRQ_INFO_NORESIZE		(1 << 3)
+#define VFIO_IRQ_INFO_FLAG_CAPS		(1 << 4) /* Info supports caps */
 	__u32	index;		/* IRQ index */
+	__u32	cap_offset;	/* Offset within info struct of first cap */
 	__u32	count;		/* Number of IRQs within this index */
 };
 #define VFIO_DEVICE_GET_IRQ_INFO	_IO(VFIO_TYPE, VFIO_BASE + 9)
 
+/*
+ * The irq type capability allows irqs unique to a specific device or
+ * class of devices to be exposed.
+ *
+ * The structures below define version 1 of this capability.
+ */
+#define VFIO_IRQ_INFO_CAP_TYPE      3
+
+struct vfio_irq_info_cap_type {
+	struct vfio_info_cap_header header;
+	__u32 type;     /* global per bus driver */
+	__u32 subtype;  /* type specific */
+};
+
+#define VFIO_IRQ_TYPE_GFX				(1)
+#define VFIO_IRQ_SUBTYPE_GFX_PRI_PLANE_FLIP		(1)
+#define VFIO_IRQ_SUBTYPE_GFX_CUR_PLANE_FLIP		(2)
+
 /**
  * VFIO_DEVICE_SET_IRQS - _IOW(VFIO_TYPE, VFIO_BASE + 10, struct vfio_irq_set)
  *
@@ -550,7 +570,8 @@ enum {
 	VFIO_PCI_MSIX_IRQ_INDEX,
 	VFIO_PCI_ERR_IRQ_INDEX,
 	VFIO_PCI_REQ_IRQ_INDEX,
-	VFIO_PCI_NUM_IRQS
+	VFIO_PCI_NUM_IRQS = 5	/* Fixed user ABI, IRQ indexes >=5 use   */
+				/* device specific cap to define content */
 };
 
 /*
-- 
2.17.1

