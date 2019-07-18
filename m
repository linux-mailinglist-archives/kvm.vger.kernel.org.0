Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F1D86CA71
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2019 09:58:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389278AbfGRH5a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Jul 2019 03:57:30 -0400
Received: from mga12.intel.com ([192.55.52.136]:15259 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726423AbfGRH5a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Jul 2019 03:57:30 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Jul 2019 00:57:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,276,1559545200"; 
   d="scan'208";a="158713064"
Received: from gvt-optiplex-7060.bj.intel.com ([10.238.158.89])
  by orsmga007.jf.intel.com with ESMTP; 18 Jul 2019 00:57:27 -0700
From:   Kechen Lu <kechen.lu@intel.com>
To:     intel-gvt-dev@lists.freedesktop.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Tina Zhang <tina.zhang@intel.com>, kraxel@redhat.com,
        zhenyuw@linux.intel.com, zhiyuan.lv@intel.com,
        zhi.a.wang@intel.com, kevin.tian@intel.com, hang.yuan@intel.com,
        alex.williamson@redhat.com, Eric Auger <eric.auger@redhat.com>
Subject: [RFC PATCH v4 1/6] vfio: Define device specific irq type capability
Date:   Thu, 18 Jul 2019 23:56:35 +0800
Message-Id: <20190718155640.25928-2-kechen.lu@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190718155640.25928-1-kechen.lu@intel.com>
References: <20190718155640.25928-1-kechen.lu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tina Zhang <tina.zhang@intel.com>

Cap the number of irqs with fixed indexes and use capability chains
to chain device specific irqs.

Signed-off-by: Tina Zhang <tina.zhang@intel.com>
Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 include/uapi/linux/vfio.h | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 8f10748dac79..be6adab4f759 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -448,11 +448,27 @@ struct vfio_irq_info {
 #define VFIO_IRQ_INFO_MASKABLE		(1 << 1)
 #define VFIO_IRQ_INFO_AUTOMASKED	(1 << 2)
 #define VFIO_IRQ_INFO_NORESIZE		(1 << 3)
+#define VFIO_IRQ_INFO_FLAG_CAPS		(1 << 4) /* Info supports caps */
 	__u32	index;		/* IRQ index */
 	__u32	count;		/* Number of IRQs within this index */
+	__u32	cap_offset;	/* Offset within info struct of first cap */
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
 /**
  * VFIO_DEVICE_SET_IRQS - _IOW(VFIO_TYPE, VFIO_BASE + 10, struct vfio_irq_set)
  *
@@ -554,7 +570,8 @@ enum {
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

