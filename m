Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB96B10C24B
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2019 03:30:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728014AbfK1CaA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Nov 2019 21:30:00 -0500
Received: from mga18.intel.com ([134.134.136.126]:17935 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726695AbfK1C37 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Nov 2019 21:29:59 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Nov 2019 18:29:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,251,1571727600"; 
   d="scan'208";a="221176111"
Received: from allen-box.sh.intel.com ([10.239.159.136])
  by orsmga002.jf.intel.com with ESMTP; 27 Nov 2019 18:29:57 -0800
From:   Lu Baolu <baolu.lu@linux.intel.com>
To:     Joerg Roedel <joro@8bytes.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     ashok.raj@intel.com, sanjay.k.kumar@intel.com,
        jacob.jun.pan@linux.intel.com, kevin.tian@intel.com,
        yi.l.liu@intel.com, yi.y.sun@intel.com,
        Peter Xu <peterx@redhat.com>, iommu@lists.linux-foundation.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lu Baolu <baolu.lu@linux.intel.com>
Subject: [PATCH v2 1/8] iommu/vt-d: Add per domain page table ops
Date:   Thu, 28 Nov 2019 10:25:43 +0800
Message-Id: <20191128022550.9832-2-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191128022550.9832-1-baolu.lu@linux.intel.com>
References: <20191128022550.9832-1-baolu.lu@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The Intel VT-d in scalable mode supports two types of
page talbes for DMA translation: the first level page
table and the second level page table. The IOMMU driver
is able to choose one of them for DMA remapping according
to the use case. The first level page table uses the same
format as the CPU page table, while the second level page
table keeps compatible with previous formats.

This abstracts the page tables used in Intel IOMMU driver
by defining a per domain page table ops structure which
contains callbacks for various page table operations.

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
---
 include/linux/intel-iommu.h | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
index 326146a36dbf..e8bfe7466ebb 100644
--- a/include/linux/intel-iommu.h
+++ b/include/linux/intel-iommu.h
@@ -499,6 +499,28 @@ struct context_entry {
 	u64 hi;
 };
 
+struct dmar_domain;
+
+/*
+ * struct pgtable_ops - page table ops
+ * @map_range: map a physically contiguous memory region to iova
+ * @unmap_range: unmap a physically contiguous memory region
+ * @iova_to_phys: return the physical address mapped to @iova
+ * @flush_tlb_range: flush the tlb caches as the result of map or unmap
+ */
+struct pgtable_ops {
+	int (*map_range)(struct dmar_domain *domain,
+			 unsigned long iova, phys_addr_t paddr,
+			 size_t size, int prot);
+	struct page *(*unmap_range)(struct dmar_domain *domain,
+				    unsigned long iova, size_t size);
+	phys_addr_t (*iova_to_phys)(struct dmar_domain *domain,
+				    unsigned long iova);
+	void (*flush_tlb_range)(struct dmar_domain *domain,
+				struct intel_iommu *iommu,
+				unsigned long iova, size_t size, bool ih);
+};
+
 struct dmar_domain {
 	int	nid;			/* node id */
 
@@ -517,8 +539,10 @@ struct dmar_domain {
 	struct list_head auxd;		/* link to device's auxiliary list */
 	struct iova_domain iovad;	/* iova's that belong to this domain */
 
+	/* page table used by this domain */
 	struct dma_pte	*pgd;		/* virtual address */
 	int		gaw;		/* max guest address width */
+	const struct pgtable_ops *ops;	/* page table ops */
 
 	/* adjusted guest address width, 0 is level 2 30-bit */
 	int		agaw;
-- 
2.17.1

