Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AD6329FCED
	for <lists+kvm@lfdr.de>; Fri, 30 Oct 2020 06:05:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726499AbgJ3FFS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Oct 2020 01:05:18 -0400
Received: from mga06.intel.com ([134.134.136.31]:5284 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725978AbgJ3FFQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Oct 2020 01:05:16 -0400
IronPort-SDR: 6zpxCDfRkqeZVQOrydZ86FSWS7Vs0t5jKlmptaIsuYc9n4pWZbsrh6UJemLVj+9wrl+5y4f+0w
 CPhmOA8wGmVQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9789"; a="230196555"
X-IronPort-AV: E=Sophos;i="5.77,432,1596524400"; 
   d="scan'208";a="230196555"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2020 22:05:14 -0700
IronPort-SDR: G8E/0mYvLC1+b++D/DhfPqGPBK3LULJNtVwSwI8/9IjbjF52aIuv63hbW43vu1HvrC73Zh+vOv
 ymuJ0FnBAKsQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,432,1596524400"; 
   d="scan'208";a="425261555"
Received: from allen-box.sh.intel.com ([10.239.159.139])
  by fmsmga001.fm.intel.com with ESMTP; 29 Oct 2020 22:05:11 -0700
From:   Lu Baolu <baolu.lu@linux.intel.com>
To:     Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     Robin Murphy <robin.murphy@arm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Liu Yi L <yi.l.liu@intel.com>, Zeng Xin <xin.zeng@intel.com>,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Lu Baolu <baolu.lu@linux.intel.com>
Subject: [PATCH v6 3/5] iommu/vt-d: Make some static functions global
Date:   Fri, 30 Oct 2020 12:58:07 +0800
Message-Id: <20201030045809.957927-4-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201030045809.957927-1-baolu.lu@linux.intel.com>
References: <20201030045809.957927-1-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

So that they could be used in other files as well. No functional changes.

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
---
 drivers/iommu/intel/iommu.c | 74 +++++++------------------------------
 include/linux/intel-iommu.h | 49 ++++++++++++++++++++++++
 2 files changed, 62 insertions(+), 61 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 8f5e7b31b3fb..1454fe74f3ba 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -330,10 +330,6 @@ static void domain_exit(struct dmar_domain *domain);
 static void domain_remove_dev_info(struct dmar_domain *domain);
 static void dmar_remove_one_dev_info(struct device *dev);
 static void __dmar_remove_one_dev_info(struct device_domain_info *info);
-static int intel_iommu_attach_device(struct iommu_domain *domain,
-				     struct device *dev);
-static phys_addr_t intel_iommu_iova_to_phys(struct iommu_domain *domain,
-					    dma_addr_t iova);
 
 #ifdef CONFIG_INTEL_IOMMU_DEFAULT_ON
 int dmar_disabled = 0;
@@ -4423,7 +4419,7 @@ static int md_domain_init(struct dmar_domain *domain, int guest_width)
 	return 0;
 }
 
-static struct iommu_domain *intel_iommu_domain_alloc(unsigned type)
+struct iommu_domain *intel_iommu_domain_alloc(unsigned int type)
 {
 	struct dmar_domain *dmar_domain;
 	struct iommu_domain *domain;
@@ -4462,7 +4458,7 @@ static struct iommu_domain *intel_iommu_domain_alloc(unsigned type)
 	return NULL;
 }
 
-static void intel_iommu_domain_free(struct iommu_domain *domain)
+void intel_iommu_domain_free(struct iommu_domain *domain)
 {
 	if (domain != &si_domain->domain)
 		domain_exit(to_dmar_domain(domain));
@@ -4639,8 +4635,7 @@ static int prepare_domain_attach_device(struct iommu_domain *domain,
 	return 0;
 }
 
-static int intel_iommu_attach_device(struct iommu_domain *domain,
-				     struct device *dev)
+int intel_iommu_attach_device(struct iommu_domain *domain, struct device *dev)
 {
 	int ret;
 
@@ -4669,8 +4664,7 @@ static int intel_iommu_attach_device(struct iommu_domain *domain,
 	return domain_add_dev_info(to_dmar_domain(domain), dev);
 }
 
-static int intel_iommu_aux_attach_device(struct iommu_domain *domain,
-					 struct device *dev)
+int intel_iommu_aux_attach_device(struct iommu_domain *domain, struct device *dev)
 {
 	int ret;
 
@@ -4684,14 +4678,12 @@ static int intel_iommu_aux_attach_device(struct iommu_domain *domain,
 	return aux_domain_add_dev(to_dmar_domain(domain), dev);
 }
 
-static void intel_iommu_detach_device(struct iommu_domain *domain,
-				      struct device *dev)
+void intel_iommu_detach_device(struct iommu_domain *domain, struct device *dev)
 {
 	dmar_remove_one_dev_info(dev);
 }
 
-static void intel_iommu_aux_detach_device(struct iommu_domain *domain,
-					  struct device *dev)
+void intel_iommu_aux_detach_device(struct iommu_domain *domain, struct device *dev)
 {
 	aux_domain_remove_dev(to_dmar_domain(domain), dev);
 }
@@ -4875,9 +4867,8 @@ intel_iommu_sva_invalidate(struct iommu_domain *domain, struct device *dev,
 }
 #endif
 
-static int intel_iommu_map(struct iommu_domain *domain,
-			   unsigned long iova, phys_addr_t hpa,
-			   size_t size, int iommu_prot, gfp_t gfp)
+int intel_iommu_map(struct iommu_domain *domain, unsigned long iova,
+		    phys_addr_t hpa, size_t size, int iommu_prot, gfp_t gfp)
 {
 	struct dmar_domain *dmar_domain = to_dmar_domain(domain);
 	u64 max_addr;
@@ -4913,9 +4904,8 @@ static int intel_iommu_map(struct iommu_domain *domain,
 	return ret;
 }
 
-static size_t intel_iommu_unmap(struct iommu_domain *domain,
-				unsigned long iova, size_t size,
-				struct iommu_iotlb_gather *gather)
+size_t intel_iommu_unmap(struct iommu_domain *domain, unsigned long iova,
+			 size_t size, struct iommu_iotlb_gather *gather)
 {
 	struct dmar_domain *dmar_domain = to_dmar_domain(domain);
 	unsigned long start_pfn, last_pfn;
@@ -4963,8 +4953,7 @@ static void intel_iommu_tlb_sync(struct iommu_domain *domain,
 	dma_free_pagelist(gather->freelist);
 }
 
-static phys_addr_t intel_iommu_iova_to_phys(struct iommu_domain *domain,
-					    dma_addr_t iova)
+phys_addr_t intel_iommu_iova_to_phys(struct iommu_domain *domain, dma_addr_t iova)
 {
 	struct dmar_domain *dmar_domain = to_dmar_domain(domain);
 	struct dma_pte *pte;
@@ -4980,42 +4969,6 @@ static phys_addr_t intel_iommu_iova_to_phys(struct iommu_domain *domain,
 	return phys;
 }
 
-static inline bool scalable_mode_support(void)
-{
-	struct dmar_drhd_unit *drhd;
-	struct intel_iommu *iommu;
-	bool ret = true;
-
-	rcu_read_lock();
-	for_each_active_iommu(iommu, drhd) {
-		if (!sm_supported(iommu)) {
-			ret = false;
-			break;
-		}
-	}
-	rcu_read_unlock();
-
-	return ret;
-}
-
-static inline bool iommu_pasid_support(void)
-{
-	struct dmar_drhd_unit *drhd;
-	struct intel_iommu *iommu;
-	bool ret = true;
-
-	rcu_read_lock();
-	for_each_active_iommu(iommu, drhd) {
-		if (!pasid_supported(iommu)) {
-			ret = false;
-			break;
-		}
-	}
-	rcu_read_unlock();
-
-	return ret;
-}
-
 static inline bool nested_mode_support(void)
 {
 	struct dmar_drhd_unit *drhd;
@@ -5034,7 +4987,7 @@ static inline bool nested_mode_support(void)
 	return ret;
 }
 
-static bool intel_iommu_capable(enum iommu_cap cap)
+bool intel_iommu_capable(enum iommu_cap cap)
 {
 	if (cap == IOMMU_CAP_CACHE_COHERENCY)
 		return domain_update_iommu_snooping(NULL) == 1;
@@ -5084,8 +5037,7 @@ static void intel_iommu_probe_finalize(struct device *dev)
 		set_dma_ops(dev, NULL);
 }
 
-static void intel_iommu_get_resv_regions(struct device *device,
-					 struct list_head *head)
+void intel_iommu_get_resv_regions(struct device *device, struct list_head *head)
 {
 	int prot = DMA_PTE_READ | DMA_PTE_WRITE;
 	struct iommu_resv_region *reg;
diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
index fbf5b3e7707e..d3928ba87986 100644
--- a/include/linux/intel-iommu.h
+++ b/include/linux/intel-iommu.h
@@ -693,6 +693,42 @@ static inline int first_pte_in_page(struct dma_pte *pte)
 	return !((unsigned long)pte & ~VTD_PAGE_MASK);
 }
 
+static inline bool scalable_mode_support(void)
+{
+	struct dmar_drhd_unit *drhd;
+	struct intel_iommu *iommu;
+	bool ret = true;
+
+	rcu_read_lock();
+	for_each_active_iommu(iommu, drhd) {
+		if (!sm_supported(iommu)) {
+			ret = false;
+			break;
+		}
+	}
+	rcu_read_unlock();
+
+	return ret;
+}
+
+static inline bool iommu_pasid_support(void)
+{
+	struct dmar_drhd_unit *drhd;
+	struct intel_iommu *iommu;
+	bool ret = true;
+
+	rcu_read_lock();
+	for_each_active_iommu(iommu, drhd) {
+		if (!pasid_supported(iommu)) {
+			ret = false;
+			break;
+		}
+	}
+	rcu_read_unlock();
+
+	return ret;
+}
+
 extern struct dmar_drhd_unit * dmar_find_matched_drhd_unit(struct pci_dev *dev);
 extern int dmar_find_matched_atsr_unit(struct pci_dev *dev);
 
@@ -737,6 +773,19 @@ int intel_iommu_enable_pasid(struct intel_iommu *iommu, struct device *dev);
 struct dmar_domain *find_domain(struct device *dev);
 struct device_domain_info *get_domain_info(struct device *dev);
 struct intel_iommu *device_to_iommu(struct device *dev, u8 *bus, u8 *devfn);
+bool intel_iommu_capable(enum iommu_cap cap);
+struct iommu_domain *intel_iommu_domain_alloc(unsigned int type);
+void intel_iommu_domain_free(struct iommu_domain *domain);
+int intel_iommu_attach_device(struct iommu_domain *domain, struct device *dev);
+int intel_iommu_aux_attach_device(struct iommu_domain *domain, struct device *dev);
+void intel_iommu_detach_device(struct iommu_domain *domain, struct device *dev);
+void intel_iommu_aux_detach_device(struct iommu_domain *domain, struct device *dev);
+int intel_iommu_map(struct iommu_domain *domain, unsigned long iova,
+		    phys_addr_t hpa, size_t size, int iommu_prot, gfp_t gfp);
+size_t intel_iommu_unmap(struct iommu_domain *domain, unsigned long iova,
+			 size_t size, struct iommu_iotlb_gather *gather);
+phys_addr_t intel_iommu_iova_to_phys(struct iommu_domain *domain, dma_addr_t iova);
+void intel_iommu_get_resv_regions(struct device *device, struct list_head *head);
 
 #ifdef CONFIG_INTEL_IOMMU_SVM
 extern void intel_svm_check(struct intel_iommu *iommu);
-- 
2.25.1

