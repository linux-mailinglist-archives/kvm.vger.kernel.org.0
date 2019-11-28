Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC27710C256
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2019 03:30:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728299AbfK1CaF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Nov 2019 21:30:05 -0500
Received: from mga18.intel.com ([134.134.136.126]:17935 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728290AbfK1CaE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Nov 2019 21:30:04 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Nov 2019 18:30:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,251,1571727600"; 
   d="scan'208";a="221176157"
Received: from allen-box.sh.intel.com ([10.239.159.136])
  by orsmga002.jf.intel.com with ESMTP; 27 Nov 2019 18:30:01 -0800
From:   Lu Baolu <baolu.lu@linux.intel.com>
To:     Joerg Roedel <joro@8bytes.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     ashok.raj@intel.com, sanjay.k.kumar@intel.com,
        jacob.jun.pan@linux.intel.com, kevin.tian@intel.com,
        yi.l.liu@intel.com, yi.y.sun@intel.com,
        Peter Xu <peterx@redhat.com>, iommu@lists.linux-foundation.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: [PATCH v2 3/8] iommu/vt-d: Implement second level page table ops
Date:   Thu, 28 Nov 2019 10:25:45 +0800
Message-Id: <20191128022550.9832-4-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191128022550.9832-1-baolu.lu@linux.intel.com>
References: <20191128022550.9832-1-baolu.lu@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This adds the implementation of page table callbacks for
the second level page table.

Cc: Ashok Raj <ashok.raj@intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Liu Yi L <yi.l.liu@intel.com>
Cc: Yi Sun <yi.y.sun@linux.intel.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
---
 drivers/iommu/intel-iommu.c | 81 +++++++++++++++++++++++++++++++++++++
 1 file changed, 81 insertions(+)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 7752ff299cb5..96ead4e3395a 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -413,6 +413,7 @@ int for_each_device_domain(int (*fn)(struct device_domain_info *info,
 }
 
 const struct iommu_ops intel_iommu_ops;
+static const struct pgtable_ops second_lvl_pgtable_ops;
 
 static bool translation_pre_enabled(struct intel_iommu *iommu)
 {
@@ -1720,6 +1721,7 @@ static struct dmar_domain *alloc_domain(int flags)
 	domain->nid = NUMA_NO_NODE;
 	domain->flags = flags;
 	domain->has_iotlb_device = false;
+	domain->ops = &second_lvl_pgtable_ops;
 	INIT_LIST_HEAD(&domain->devices);
 
 	return domain;
@@ -2334,6 +2336,85 @@ static int __domain_mapping(struct dmar_domain *domain, unsigned long iov_pfn,
 	return 0;
 }
 
+static int second_lvl_domain_map_range(struct dmar_domain *domain,
+				       unsigned long iova, phys_addr_t paddr,
+				       size_t size, int prot)
+{
+	return __domain_mapping(domain, iova >> VTD_PAGE_SHIFT, NULL,
+				paddr >> VTD_PAGE_SHIFT,
+				aligned_nrpages(paddr, size), prot);
+}
+
+static struct page *
+second_lvl_domain_unmap_range(struct dmar_domain *domain,
+			      unsigned long iova, size_t size)
+{
+	unsigned long start_pfn, end_pfn, nrpages;
+
+	start_pfn = mm_to_dma_pfn(IOVA_PFN(iova));
+	nrpages = aligned_nrpages(iova, size);
+	end_pfn = start_pfn + nrpages - 1;
+
+	return dma_pte_clear_level(domain, agaw_to_level(domain->agaw),
+				   domain->pgd, 0, start_pfn, end_pfn, NULL);
+}
+
+static phys_addr_t
+second_lvl_domain_iova_to_phys(struct dmar_domain *domain,
+			       unsigned long iova)
+{
+	struct dma_pte *pte;
+	int level = 0;
+	u64 phys = 0;
+
+	pte = pfn_to_dma_pte(domain, iova >> VTD_PAGE_SHIFT, &level);
+	if (pte)
+		phys = dma_pte_addr(pte);
+
+	return phys;
+}
+
+static void
+second_lvl_domain_flush_tlb_range(struct dmar_domain *domain,
+				  struct intel_iommu *iommu,
+				  unsigned long addr, size_t size,
+				  bool ih)
+{
+	unsigned long pages = aligned_nrpages(addr, size);
+	u16 did = domain->iommu_did[iommu->seq_id];
+	unsigned int mask;
+
+	if (pages) {
+		mask = ilog2(__roundup_pow_of_two(pages));
+		addr &= (u64)-1 << (VTD_PAGE_SHIFT + mask);
+	} else {
+		mask = MAX_AGAW_PFN_WIDTH;
+		addr = 0;
+	}
+
+	/*
+	 * Fallback to domain selective flush if no PSI support or the size is
+	 * too big.
+	 * PSI requires page size to be 2 ^ x, and the base address is naturally
+	 * aligned to the size
+	 */
+	if (!pages || !cap_pgsel_inv(iommu->cap) ||
+	    mask > cap_max_amask_val(iommu->cap))
+		iommu->flush.iotlb_inv(iommu, did, 0, 0, DMA_TLB_DSI_FLUSH);
+	else
+		iommu->flush.iotlb_inv(iommu, did, addr | ((int)ih << 6),
+				       mask, DMA_TLB_PSI_FLUSH);
+
+	iommu_flush_dev_iotlb(domain, addr, mask);
+}
+
+static const struct pgtable_ops second_lvl_pgtable_ops = {
+	.map_range		= second_lvl_domain_map_range,
+	.unmap_range		= second_lvl_domain_unmap_range,
+	.iova_to_phys		= second_lvl_domain_iova_to_phys,
+	.flush_tlb_range	= second_lvl_domain_flush_tlb_range,
+};
+
 static int domain_mapping(struct dmar_domain *domain, unsigned long iov_pfn,
 			  struct scatterlist *sg, unsigned long phys_pfn,
 			  unsigned long nr_pages, int prot)
-- 
2.17.1

