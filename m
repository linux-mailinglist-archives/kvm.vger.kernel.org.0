Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B06E71D6F38
	for <lists+kvm@lfdr.de>; Mon, 18 May 2020 05:02:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726932AbgERDCk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 17 May 2020 23:02:40 -0400
Received: from mga14.intel.com ([192.55.52.115]:21760 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726639AbgERDCk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 17 May 2020 23:02:40 -0400
IronPort-SDR: azQmqO2J10SWh3CDZEpUtxNnQChCZqYdKov4OTiyY0QLMpUN2kgrbrLMFBD0TnzZZgrmZUjv/O
 UZHdkbneOqRg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2020 20:02:39 -0700
IronPort-SDR: v8ZzGhIZ1YZDRT0sKRTjnVYJT+D0/Zt0Y3ti7/50UogXp1khFlTEvLd4WraU4XCMk6j1qwl8GY
 ljDFSQ/Dp/jg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,405,1583222400"; 
   d="scan'208";a="411106132"
Received: from joy-optiplex-7040.sh.intel.com ([10.239.13.16])
  by orsmga004.jf.intel.com with ESMTP; 17 May 2020 20:02:36 -0700
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        zhenyuw@linux.intel.com, zhi.a.wang@intel.com,
        kevin.tian@intel.com, shaopeng.he@intel.com, yi.l.liu@intel.com,
        xin.zeng@intel.com, hang.yuan@intel.com,
        Yan Zhao <yan.y.zhao@intel.com>
Subject: [RFC PATCH v4 07/10] vfio/pci: introduce a new irq type VFIO_IRQ_TYPE_REMAP_BAR_REGION
Date:   Sun, 17 May 2020 22:52:45 -0400
Message-Id: <20200518025245.14425-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200518024202.13996-1-yan.y.zhao@intel.com>
References: <20200518024202.13996-1-yan.y.zhao@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is a virtual irq type.
vendor driver triggers this irq when it wants to notify userspace to
remap PCI BARs.

1. vendor driver triggers this irq and packs the target bar number in
   the ctx count. i.e. "1 << bar_number".
   if a bit is set, the corresponding bar is to be remapped.

2. userspace requery the specified PCI BAR from kernel and if flags of
the bar regions are changed, it removes the old subregions and attaches
subregions according to the new flags.

3. userspace notifies back to kernel by writing one to the eventfd of
this irq.

Please check the corresponding qemu implementation from the reply of this
patch, and a sample usage in vendor driver in patch [10/10].

Cc: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 include/uapi/linux/vfio.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 2d0d85c7c4d4..55895f75d720 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -704,6 +704,17 @@ struct vfio_irq_info_cap_type {
 	__u32 subtype;  /* type specific */
 };
 
+/* Bar Region Query IRQ TYPE */
+#define VFIO_IRQ_TYPE_REMAP_BAR_REGION			(1)
+
+/* sub-types for VFIO_IRQ_TYPE_REMAP_BAR_REGION */
+/*
+ * This irq notifies userspace to re-query BAR region and remaps the
+ * subregions.
+ */
+#define VFIO_IRQ_SUBTYPE_REMAP_BAR_REGION	(0)
+
+
 /**
  * VFIO_DEVICE_SET_IRQS - _IOW(VFIO_TYPE, VFIO_BASE + 10, struct vfio_irq_set)
  *
-- 
2.17.1

