Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E4DE10C259
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2019 03:30:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728257AbfK1CaH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Nov 2019 21:30:07 -0500
Received: from mga18.intel.com ([134.134.136.126]:17935 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728313AbfK1CaH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Nov 2019 21:30:07 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Nov 2019 18:30:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,251,1571727600"; 
   d="scan'208";a="221176172"
Received: from allen-box.sh.intel.com ([10.239.159.136])
  by orsmga002.jf.intel.com with ESMTP; 27 Nov 2019 18:30:04 -0800
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
Subject: [PATCH v2 4/8] iommu/vt-d: Apply per domain second level page table ops
Date:   Thu, 28 Nov 2019 10:25:46 +0800
Message-Id: <20191128022550.9832-5-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191128022550.9832-1-baolu.lu@linux.intel.com>
References: <20191128022550.9832-1-baolu.lu@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This applies per domain page table ops to various domain
mapping and unmapping interfaces.

Cc: Ashok Raj <ashok.raj@intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
---
 drivers/iommu/intel-iommu.c | 118 ++++++++++++++++--------------------
 1 file changed, 52 insertions(+), 66 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 96ead4e3395a..66f76f6df2c2 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -80,6 +80,7 @@
 #define IOVA_START_PFN		(1)
 
 #define IOVA_PFN(addr)		((addr) >> PAGE_SHIFT)
+#define PFN_ADDR(pfn)		((pfn) << PAGE_SHIFT)
 
 /* page table handling */
 #define LEVEL_STRIDE		(9)
@@ -1153,8 +1154,8 @@ static struct page *domain_unmap(struct dmar_domain *domain,
 	BUG_ON(start_pfn > last_pfn);
 
 	/* we don't need lock here; nobody else touches the iova range */
-	freelist = dma_pte_clear_level(domain, agaw_to_level(domain->agaw),
-				       domain->pgd, 0, start_pfn, last_pfn, NULL);
+	freelist = domain->ops->unmap_range(domain, PFN_ADDR(start_pfn),
+					    PFN_ADDR(last_pfn - start_pfn + 1));
 
 	/* free pgd */
 	if (start_pfn == 0 && last_pfn == DOMAIN_MAX_PFN(domain->gaw)) {
@@ -1484,39 +1485,6 @@ static void iommu_flush_dev_iotlb(struct dmar_domain *domain,
 	spin_unlock_irqrestore(&device_domain_lock, flags);
 }
 
-static void iommu_flush_iotlb_psi(struct intel_iommu *iommu,
-				  struct dmar_domain *domain,
-				  unsigned long pfn, unsigned int pages,
-				  int ih, int map)
-{
-	unsigned int mask = ilog2(__roundup_pow_of_two(pages));
-	uint64_t addr = (uint64_t)pfn << VTD_PAGE_SHIFT;
-	u16 did = domain->iommu_did[iommu->seq_id];
-
-	BUG_ON(pages == 0);
-
-	if (ih)
-		ih = 1 << 6;
-	/*
-	 * Fallback to domain selective flush if no PSI support or the size is
-	 * too big.
-	 * PSI requires page size to be 2 ^ x, and the base address is naturally
-	 * aligned to the size
-	 */
-	if (!cap_pgsel_inv(iommu->cap) || mask > cap_max_amask_val(iommu->cap))
-		iommu->flush.iotlb_inv(iommu, did, 0, 0, DMA_TLB_DSI_FLUSH);
-	else
-		iommu->flush.iotlb_inv(iommu, did, addr | ih,
-				       mask, DMA_TLB_PSI_FLUSH);
-
-	/*
-	 * In caching mode, changes of pages from non-present to present require
-	 * flush. However, device IOTLB doesn't need to be flushed in this case.
-	 */
-	if (!cap_caching_mode(iommu->cap) || !map)
-		iommu_flush_dev_iotlb(domain, addr, mask);
-}
-
 /* Notification for newly created mappings */
 static inline void __mapping_notify_one(struct intel_iommu *iommu,
 					struct dmar_domain *domain,
@@ -1524,7 +1492,8 @@ static inline void __mapping_notify_one(struct intel_iommu *iommu,
 {
 	/* It's a non-present to present mapping. Only flush if caching mode */
 	if (cap_caching_mode(iommu->cap))
-		iommu_flush_iotlb_psi(iommu, domain, pfn, pages, 0, 1);
+		domain->ops->flush_tlb_range(domain, iommu, PFN_ADDR(pfn),
+					     PFN_ADDR(pages), 0);
 	else
 		iommu_flush_write_buffer(iommu);
 }
@@ -1536,16 +1505,8 @@ static void iommu_flush_iova(struct iova_domain *iovad)
 
 	domain = container_of(iovad, struct dmar_domain, iovad);
 
-	for_each_domain_iommu(idx, domain) {
-		struct intel_iommu *iommu = g_iommus[idx];
-		u16 did = domain->iommu_did[iommu->seq_id];
-
-		iommu->flush.iotlb_inv(iommu, did, 0, 0, DMA_TLB_DSI_FLUSH);
-
-		if (!cap_caching_mode(iommu->cap))
-			iommu_flush_dev_iotlb(get_iommu_domain(iommu, did),
-					      0, MAX_AGAW_PFN_WIDTH);
-	}
+	for_each_domain_iommu(idx, domain)
+		domain->ops->flush_tlb_range(domain, g_iommus[idx], 0, 0, 0);
 }
 
 static void iommu_disable_protect_mem_regions(struct intel_iommu *iommu)
@@ -2419,13 +2380,43 @@ static int domain_mapping(struct dmar_domain *domain, unsigned long iov_pfn,
 			  struct scatterlist *sg, unsigned long phys_pfn,
 			  unsigned long nr_pages, int prot)
 {
-	int iommu_id, ret;
 	struct intel_iommu *iommu;
+	int iommu_id, ret;
 
 	/* Do the real mapping first */
-	ret = __domain_mapping(domain, iov_pfn, sg, phys_pfn, nr_pages, prot);
-	if (ret)
-		return ret;
+	if (!sg) {
+		ret = domain->ops->map_range(domain, PFN_ADDR(iov_pfn),
+					     PFN_ADDR(phys_pfn),
+					     PFN_ADDR(nr_pages),
+					     prot);
+		if (ret)
+			return ret;
+	} else {
+		unsigned long pgoff, pgs;
+		unsigned long start = iov_pfn, total = nr_pages;
+
+		while (total && sg) {
+			pgoff = sg->offset & ~PAGE_MASK;
+			pgs = aligned_nrpages(sg->offset, sg->length);
+
+			ret = domain->ops->map_range(domain, PFN_ADDR(start),
+						     sg_phys(sg) - pgoff,
+						     PFN_ADDR(pgs), prot);
+			if (ret) {
+				domain->ops->unmap_range(domain,
+							 PFN_ADDR(iov_pfn),
+							 PFN_ADDR(nr_pages));
+				return ret;
+			}
+
+			sg->dma_address = ((dma_addr_t)start << VTD_PAGE_SHIFT) + pgoff;
+			sg->dma_length = sg->length;
+
+			total -= pgs;
+			start += pgs;
+			sg = sg_next(sg);
+		}
+	}
 
 	for_each_domain_iommu(iommu_id, domain) {
 		iommu = g_iommus[iommu_id];
@@ -3837,8 +3828,8 @@ static void intel_unmap(struct device *dev, dma_addr_t dev_addr, size_t size)
 	freelist = domain_unmap(domain, start_pfn, last_pfn);
 	if (intel_iommu_strict || (pdev && pdev->untrusted) ||
 			!has_iova_flush_queue(&domain->iovad)) {
-		iommu_flush_iotlb_psi(iommu, domain, start_pfn,
-				      nrpages, !freelist, 0);
+		domain->ops->flush_tlb_range(domain, iommu, dev_addr,
+					     size, !freelist);
 		/* free iova */
 		free_iova_fast(&domain->iovad, iova_pfn, dma_to_mm_pfn(nrpages));
 		dma_free_pagelist(freelist);
@@ -4927,9 +4918,9 @@ static int intel_iommu_memory_notifier(struct notifier_block *nb,
 
 			rcu_read_lock();
 			for_each_active_iommu(iommu, drhd)
-				iommu_flush_iotlb_psi(iommu, si_domain,
-					iova->pfn_lo, iova_size(iova),
-					!freelist, 0);
+				si_domain->ops->flush_tlb_range(si_domain,
+					iommu, PFN_ADDR(iova->pfn_lo),
+					PFN_ADDR(iova_size(iova)), !freelist);
 			rcu_read_unlock();
 			dma_free_pagelist(freelist);
 
@@ -5732,8 +5723,9 @@ static size_t intel_iommu_unmap(struct iommu_domain *domain,
 	npages = last_pfn - start_pfn + 1;
 
 	for_each_domain_iommu(iommu_id, dmar_domain)
-		iommu_flush_iotlb_psi(g_iommus[iommu_id], dmar_domain,
-				      start_pfn, npages, !freelist, 0);
+		dmar_domain->ops->flush_tlb_range(dmar_domain,
+						  g_iommus[iommu_id],
+						  iova, size, !freelist);
 
 	dma_free_pagelist(freelist);
 
@@ -5747,18 +5739,12 @@ static phys_addr_t intel_iommu_iova_to_phys(struct iommu_domain *domain,
 					    dma_addr_t iova)
 {
 	struct dmar_domain *dmar_domain = to_dmar_domain(domain);
-	struct dma_pte *pte;
-	int level = 0;
-	u64 phys = 0;
 
-	if (dmar_domain->flags & DOMAIN_FLAG_LOSE_CHILDREN)
+	if ((dmar_domain->flags & DOMAIN_FLAG_LOSE_CHILDREN) ||
+	    !dmar_domain->ops->iova_to_phys)
 		return 0;
 
-	pte = pfn_to_dma_pte(dmar_domain, iova >> VTD_PAGE_SHIFT, &level);
-	if (pte)
-		phys = dma_pte_addr(pte);
-
-	return phys;
+	return dmar_domain->ops->iova_to_phys(dmar_domain, iova);
 }
 
 static inline bool scalable_mode_support(void)
-- 
2.17.1

