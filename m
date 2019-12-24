Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1A4D129EA0
	for <lists+kvm@lfdr.de>; Tue, 24 Dec 2019 08:47:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727076AbfLXHrA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Dec 2019 02:47:00 -0500
Received: from mga03.intel.com ([134.134.136.65]:49687 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726271AbfLXHqW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Dec 2019 02:46:22 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Dec 2019 23:46:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,350,1571727600"; 
   d="scan'208";a="223177085"
Received: from allen-box.sh.intel.com ([10.239.159.136])
  by fmsmga001.fm.intel.com with ESMTP; 23 Dec 2019 23:46:20 -0800
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
Subject: [PATCH v5 5/9] iommu/vt-d: Flush PASID-based iotlb for iova over first level
Date:   Tue, 24 Dec 2019 15:44:58 +0800
Message-Id: <20191224074502.5545-6-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191224074502.5545-1-baolu.lu@linux.intel.com>
References: <20191224074502.5545-1-baolu.lu@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When software has changed first-level tables, it should invalidate
the affected IOTLB and the paging-structure-caches using the PASID-
based-IOTLB Invalidate Descriptor defined in spec 6.5.2.4.

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
---
 drivers/iommu/dmar.c        | 41 +++++++++++++++++++++++++++
 drivers/iommu/intel-iommu.c | 56 +++++++++++++++++++++++++++----------
 include/linux/intel-iommu.h |  2 ++
 3 files changed, 84 insertions(+), 15 deletions(-)

diff --git a/drivers/iommu/dmar.c b/drivers/iommu/dmar.c
index 3acfa6a25fa2..fb30d5053664 100644
--- a/drivers/iommu/dmar.c
+++ b/drivers/iommu/dmar.c
@@ -1371,6 +1371,47 @@ void qi_flush_dev_iotlb(struct intel_iommu *iommu, u16 sid, u16 pfsid,
 	qi_submit_sync(&desc, iommu);
 }
 
+/* PASID-based IOTLB invalidation */
+void qi_flush_piotlb(struct intel_iommu *iommu, u16 did, u32 pasid, u64 addr,
+		     unsigned long npages, bool ih)
+{
+	struct qi_desc desc = {.qw2 = 0, .qw3 = 0};
+
+	/*
+	 * npages == -1 means a PASID-selective invalidation, otherwise,
+	 * a positive value for Page-selective-within-PASID invalidation.
+	 * 0 is not a valid input.
+	 */
+	if (WARN_ON(!npages)) {
+		pr_err("Invalid input npages = %ld\n", npages);
+		return;
+	}
+
+	if (npages == -1) {
+		desc.qw0 = QI_EIOTLB_PASID(pasid) |
+				QI_EIOTLB_DID(did) |
+				QI_EIOTLB_GRAN(QI_GRAN_NONG_PASID) |
+				QI_EIOTLB_TYPE;
+		desc.qw1 = 0;
+	} else {
+		int mask = ilog2(__roundup_pow_of_two(npages));
+		unsigned long align = (1ULL << (VTD_PAGE_SHIFT + mask));
+
+		if (WARN_ON_ONCE(!ALIGN(addr, align)))
+			addr &= ~(align - 1);
+
+		desc.qw0 = QI_EIOTLB_PASID(pasid) |
+				QI_EIOTLB_DID(did) |
+				QI_EIOTLB_GRAN(QI_GRAN_PSI_PASID) |
+				QI_EIOTLB_TYPE;
+		desc.qw1 = QI_EIOTLB_ADDR(addr) |
+				QI_EIOTLB_IH(ih) |
+				QI_EIOTLB_AM(mask);
+	}
+
+	qi_submit_sync(&desc, iommu);
+}
+
 /*
  * Disable Queued Invalidation interface.
  */
diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 071cbc172ce8..54db6bc0b281 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -1509,6 +1509,20 @@ static void iommu_flush_dev_iotlb(struct dmar_domain *domain,
 	spin_unlock_irqrestore(&device_domain_lock, flags);
 }
 
+static void domain_flush_piotlb(struct intel_iommu *iommu,
+				struct dmar_domain *domain,
+				u64 addr, unsigned long npages, bool ih)
+{
+	u16 did = domain->iommu_did[iommu->seq_id];
+
+	if (domain->default_pasid)
+		qi_flush_piotlb(iommu, did, domain->default_pasid,
+				addr, npages, ih);
+
+	if (!list_empty(&domain->devices))
+		qi_flush_piotlb(iommu, did, PASID_RID2PASID, addr, npages, ih);
+}
+
 static void iommu_flush_iotlb_psi(struct intel_iommu *iommu,
 				  struct dmar_domain *domain,
 				  unsigned long pfn, unsigned int pages,
@@ -1522,18 +1536,23 @@ static void iommu_flush_iotlb_psi(struct intel_iommu *iommu,
 
 	if (ih)
 		ih = 1 << 6;
-	/*
-	 * Fallback to domain selective flush if no PSI support or the size is
-	 * too big.
-	 * PSI requires page size to be 2 ^ x, and the base address is naturally
-	 * aligned to the size
-	 */
-	if (!cap_pgsel_inv(iommu->cap) || mask > cap_max_amask_val(iommu->cap))
-		iommu->flush.flush_iotlb(iommu, did, 0, 0,
-						DMA_TLB_DSI_FLUSH);
-	else
-		iommu->flush.flush_iotlb(iommu, did, addr | ih, mask,
-						DMA_TLB_PSI_FLUSH);
+
+	if (domain_use_first_level(domain)) {
+		domain_flush_piotlb(iommu, domain, addr, pages, ih);
+	} else {
+		/*
+		 * Fallback to domain selective flush if no PSI support or
+		 * the size is too big. PSI requires page size to be 2 ^ x,
+		 * and the base address is naturally aligned to the size.
+		 */
+		if (!cap_pgsel_inv(iommu->cap) ||
+		    mask > cap_max_amask_val(iommu->cap))
+			iommu->flush.flush_iotlb(iommu, did, 0, 0,
+							DMA_TLB_DSI_FLUSH);
+		else
+			iommu->flush.flush_iotlb(iommu, did, addr | ih, mask,
+							DMA_TLB_PSI_FLUSH);
+	}
 
 	/*
 	 * In caching mode, changes of pages from non-present to present require
@@ -1548,8 +1567,11 @@ static inline void __mapping_notify_one(struct intel_iommu *iommu,
 					struct dmar_domain *domain,
 					unsigned long pfn, unsigned int pages)
 {
-	/* It's a non-present to present mapping. Only flush if caching mode */
-	if (cap_caching_mode(iommu->cap))
+	/*
+	 * It's a non-present to present mapping. Only flush if caching mode
+	 * and second level.
+	 */
+	if (cap_caching_mode(iommu->cap) && !domain_use_first_level(domain))
 		iommu_flush_iotlb_psi(iommu, domain, pfn, pages, 0, 1);
 	else
 		iommu_flush_write_buffer(iommu);
@@ -1566,7 +1588,11 @@ static void iommu_flush_iova(struct iova_domain *iovad)
 		struct intel_iommu *iommu = g_iommus[idx];
 		u16 did = domain->iommu_did[iommu->seq_id];
 
-		iommu->flush.flush_iotlb(iommu, did, 0, 0, DMA_TLB_DSI_FLUSH);
+		if (domain_use_first_level(domain))
+			domain_flush_piotlb(iommu, domain, 0, -1, 0);
+		else
+			iommu->flush.flush_iotlb(iommu, did, 0, 0,
+						 DMA_TLB_DSI_FLUSH);
 
 		if (!cap_caching_mode(iommu->cap))
 			iommu_flush_dev_iotlb(get_iommu_domain(iommu, did),
diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
index 454c69712131..3a4708a8a414 100644
--- a/include/linux/intel-iommu.h
+++ b/include/linux/intel-iommu.h
@@ -650,6 +650,8 @@ extern void qi_flush_iotlb(struct intel_iommu *iommu, u16 did, u64 addr,
 			  unsigned int size_order, u64 type);
 extern void qi_flush_dev_iotlb(struct intel_iommu *iommu, u16 sid, u16 pfsid,
 			u16 qdep, u64 addr, unsigned mask);
+void qi_flush_piotlb(struct intel_iommu *iommu, u16 did, u32 pasid, u64 addr,
+		     unsigned long npages, bool ih);
 extern int qi_submit_sync(struct qi_desc *desc, struct intel_iommu *iommu);
 
 extern int dmar_ir_support(void);
-- 
2.17.1

