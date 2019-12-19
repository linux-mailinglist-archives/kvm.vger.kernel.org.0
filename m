Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99C391259EC
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2019 04:18:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726890AbfLSDRn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Dec 2019 22:17:43 -0500
Received: from mga11.intel.com ([192.55.52.93]:60212 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726463AbfLSDRn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Dec 2019 22:17:43 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Dec 2019 19:17:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,330,1571727600"; 
   d="scan'208";a="222160419"
Received: from allen-box.sh.intel.com ([10.239.159.136])
  by fmsmga001.fm.intel.com with ESMTP; 18 Dec 2019 19:17:40 -0800
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
Subject: [PATCH v4 4/7] iommu/vt-d: Setup pasid entries for iova over first level
Date:   Thu, 19 Dec 2019 11:16:31 +0800
Message-Id: <20191219031634.15168-5-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191219031634.15168-1-baolu.lu@linux.intel.com>
References: <20191219031634.15168-1-baolu.lu@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Intel VT-d in scalable mode supports two types of page tables for
IOVA translation: first level and second level. The IOMMU driver
can choose one from both for IOVA translation according to the use
case. This sets up the pasid entry if a domain is selected to use
the first-level page table for iova translation.

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
---
 drivers/iommu/intel-iommu.c | 48 +++++++++++++++++++++++++++++++++++--
 include/linux/intel-iommu.h | 16 ++++++++-----
 2 files changed, 56 insertions(+), 8 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 2b5a47584baf..f0813997dea2 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -571,6 +571,11 @@ static inline int domain_type_is_si(struct dmar_domain *domain)
 	return domain->flags & DOMAIN_FLAG_STATIC_IDENTITY;
 }
 
+static inline bool domain_use_first_level(struct dmar_domain *domain)
+{
+	return domain->flags & DOMAIN_FLAG_USE_FIRST_LEVEL;
+}
+
 static inline int domain_pfn_supported(struct dmar_domain *domain,
 				       unsigned long pfn)
 {
@@ -2288,6 +2293,8 @@ static int __domain_mapping(struct dmar_domain *domain, unsigned long iov_pfn,
 		return -EINVAL;
 
 	prot &= DMA_PTE_READ | DMA_PTE_WRITE | DMA_PTE_SNP;
+	if (domain_use_first_level(domain))
+		prot |= DMA_FL_PTE_PRESENT | DMA_FL_PTE_XD;
 
 	if (!sg) {
 		sg_res = nr_pages;
@@ -2515,6 +2522,36 @@ dmar_search_domain_by_dev_info(int segment, int bus, int devfn)
 	return NULL;
 }
 
+static int domain_setup_first_level(struct intel_iommu *iommu,
+				    struct dmar_domain *domain,
+				    struct device *dev,
+				    int pasid)
+{
+	int flags = PASID_FLAG_SUPERVISOR_MODE;
+	struct dma_pte *pgd = domain->pgd;
+	int agaw, level;
+
+	/*
+	 * Skip top levels of page tables for iommu which has
+	 * less agaw than default. Unnecessary for PT mode.
+	 */
+	for (agaw = domain->agaw; agaw > iommu->agaw; agaw--) {
+		pgd = phys_to_virt(dma_pte_addr(pgd));
+		if (!dma_pte_present(pgd))
+			return -ENOMEM;
+	}
+
+	level = agaw_to_level(agaw);
+	if (level != 4 && level != 5)
+		return -EINVAL;
+
+	flags |= (level == 5) ? PASID_FLAG_FL5LP : 0;
+
+	return intel_pasid_setup_first_level(iommu, dev, (pgd_t *)pgd, pasid,
+					     domain->iommu_did[iommu->seq_id],
+					     flags);
+}
+
 static struct dmar_domain *dmar_insert_one_dev_info(struct intel_iommu *iommu,
 						    int bus, int devfn,
 						    struct device *dev,
@@ -2614,6 +2651,9 @@ static struct dmar_domain *dmar_insert_one_dev_info(struct intel_iommu *iommu,
 		if (hw_pass_through && domain_type_is_si(domain))
 			ret = intel_pasid_setup_pass_through(iommu, domain,
 					dev, PASID_RID2PASID);
+		else if (domain_use_first_level(domain))
+			ret = domain_setup_first_level(iommu, domain, dev,
+					PASID_RID2PASID);
 		else
 			ret = intel_pasid_setup_second_level(iommu, domain,
 					dev, PASID_RID2PASID);
@@ -5369,8 +5409,12 @@ static int aux_domain_add_dev(struct dmar_domain *domain,
 		goto attach_failed;
 
 	/* Setup the PASID entry for mediated devices: */
-	ret = intel_pasid_setup_second_level(iommu, domain, dev,
-					     domain->default_pasid);
+	if (domain_use_first_level(domain))
+		ret = domain_setup_first_level(iommu, domain, dev,
+					       domain->default_pasid);
+	else
+		ret = intel_pasid_setup_second_level(iommu, domain, dev,
+						     domain->default_pasid);
 	if (ret)
 		goto table_failed;
 	spin_unlock(&iommu->lock);
diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
index aaece25c055f..454c69712131 100644
--- a/include/linux/intel-iommu.h
+++ b/include/linux/intel-iommu.h
@@ -34,10 +34,13 @@
 #define VTD_STRIDE_SHIFT        (9)
 #define VTD_STRIDE_MASK         (((u64)-1) << VTD_STRIDE_SHIFT)
 
-#define DMA_PTE_READ (1)
-#define DMA_PTE_WRITE (2)
-#define DMA_PTE_LARGE_PAGE (1 << 7)
-#define DMA_PTE_SNP (1 << 11)
+#define DMA_PTE_READ		BIT_ULL(0)
+#define DMA_PTE_WRITE		BIT_ULL(1)
+#define DMA_PTE_LARGE_PAGE	BIT_ULL(7)
+#define DMA_PTE_SNP		BIT_ULL(11)
+
+#define DMA_FL_PTE_PRESENT	BIT_ULL(0)
+#define DMA_FL_PTE_XD		BIT_ULL(63)
 
 #define CONTEXT_TT_MULTI_LEVEL	0
 #define CONTEXT_TT_DEV_IOTLB	1
@@ -610,10 +613,11 @@ static inline void dma_clear_pte(struct dma_pte *pte)
 static inline u64 dma_pte_addr(struct dma_pte *pte)
 {
 #ifdef CONFIG_64BIT
-	return pte->val & VTD_PAGE_MASK;
+	return pte->val & VTD_PAGE_MASK & (~DMA_FL_PTE_XD);
 #else
 	/* Must have a full atomic 64-bit read */
-	return  __cmpxchg64(&pte->val, 0ULL, 0ULL) & VTD_PAGE_MASK;
+	return  __cmpxchg64(&pte->val, 0ULL, 0ULL) &
+			VTD_PAGE_MASK & (~DMA_FL_PTE_XD);
 #endif
 }
 
-- 
2.17.1

