Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F1E638D26E
	for <lists+kvm@lfdr.de>; Sat, 22 May 2021 02:20:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231161AbhEVAWK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 May 2021 20:22:10 -0400
Received: from mga04.intel.com ([192.55.52.120]:56043 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230429AbhEVAVp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 May 2021 20:21:45 -0400
IronPort-SDR: K35w6VC0hlQX9d2mettQWPSDGB902fE2ncvqx4YHCnIcuqaxB1vQaAMWrjbCQ8Y3bCWfvR8qLL
 Y2ASgy9rYUvg==
X-IronPort-AV: E=McAfee;i="6200,9189,9991"; a="199661232"
X-IronPort-AV: E=Sophos;i="5.82,319,1613462400"; 
   d="scan'208";a="199661232"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2021 17:20:21 -0700
IronPort-SDR: UkWvMMWLQ2DdpdHYUq2/Q0h8ON+Cj0jkwViQ5ds8S1zGJV6+shLzce+s7LHrKRkSnG3p9dtTBF
 5ezXbcRifusw==
X-IronPort-AV: E=Sophos;i="5.82,319,1613462400"; 
   d="scan'208";a="434500908"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2021 17:20:20 -0700
Subject: [PATCH v6 12/20] vfio: move VFIO PCI macros to common header
From:   Dave Jiang <dave.jiang@intel.com>
To:     alex.williamson@redhat.com, kwankhede@nvidia.com,
        tglx@linutronix.de, vkoul@kernel.org, jgg@mellanox.com
Cc:     megha.dey@intel.com, jacob.jun.pan@intel.com, ashok.raj@intel.com,
        yi.l.liu@intel.com, baolu.lu@intel.com, kevin.tian@intel.com,
        sanjay.k.kumar@intel.com, tony.luck@intel.com,
        dan.j.williams@intel.com, eric.auger@redhat.com,
        pbonzini@redhat.com, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Date:   Fri, 21 May 2021 17:20:19 -0700
Message-ID: <162164281969.261970.17759783730654052269.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <162164243591.261970.3439987543338120797.stgit@djiang5-desk3.ch.intel.com>
References: <162164243591.261970.3439987543338120797.stgit@djiang5-desk3.ch.intel.com>
User-Agent: StGit/0.23-29-ga622f1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move some VFIO_PCI macros to a common header as they will be shared between
mdev and vfio_pci.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/vfio/pci/vfio_pci_private.h |    6 ------
 include/linux/vfio.h                |    6 ++++++
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/vfio_pci_private.h
index a17943911fcb..e644f981509c 100644
--- a/drivers/vfio/pci/vfio_pci_private.h
+++ b/drivers/vfio/pci/vfio_pci_private.h
@@ -18,12 +18,6 @@
 #ifndef VFIO_PCI_PRIVATE_H
 #define VFIO_PCI_PRIVATE_H
 
-#define VFIO_PCI_OFFSET_SHIFT   40
-
-#define VFIO_PCI_OFFSET_TO_INDEX(off)	(off >> VFIO_PCI_OFFSET_SHIFT)
-#define VFIO_PCI_INDEX_TO_OFFSET(index)	((u64)(index) << VFIO_PCI_OFFSET_SHIFT)
-#define VFIO_PCI_OFFSET_MASK	(((u64)(1) << VFIO_PCI_OFFSET_SHIFT) - 1)
-
 /* Special capability IDs predefined access */
 #define PCI_CAP_ID_INVALID		0xFF	/* default raw access */
 #define PCI_CAP_ID_INVALID_VIRT		0xFE	/* default virt access */
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 3b372fa57ef4..ed5ca027eb49 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -15,6 +15,12 @@
 #include <linux/poll.h>
 #include <uapi/linux/vfio.h>
 
+#define VFIO_PCI_OFFSET_SHIFT   40
+
+#define VFIO_PCI_OFFSET_TO_INDEX(off)	((off) >> VFIO_PCI_OFFSET_SHIFT)
+#define VFIO_PCI_INDEX_TO_OFFSET(index)	((u64)(index) << VFIO_PCI_OFFSET_SHIFT)
+#define VFIO_PCI_OFFSET_MASK	(((u64)(1) << VFIO_PCI_OFFSET_SHIFT) - 1)
+
 struct vfio_device {
 	struct device *dev;
 	const struct vfio_device_ops *ops;


