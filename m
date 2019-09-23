Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 815E4BB3B5
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2019 14:27:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393628AbfIWM1d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Sep 2019 08:27:33 -0400
Received: from mga06.intel.com ([134.134.136.31]:4334 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732441AbfIWM1c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Sep 2019 08:27:32 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Sep 2019 05:27:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,539,1559545200"; 
   d="scan'208";a="203116684"
Received: from allen-box.sh.intel.com ([10.239.159.136])
  by fmsmga001.fm.intel.com with ESMTP; 23 Sep 2019 05:27:26 -0700
From:   Lu Baolu <baolu.lu@linux.intel.com>
To:     Joerg Roedel <joro@8bytes.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     ashok.raj@intel.com, sanjay.k.kumar@intel.com,
        jacob.jun.pan@linux.intel.com, kevin.tian@intel.com,
        yi.l.liu@intel.com, yi.y.sun@intel.com,
        iommu@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: [RFC PATCH 4/4] iommu/vt-d: Identify domains using first level page table
Date:   Mon, 23 Sep 2019 20:24:54 +0800
Message-Id: <20190923122454.9888-5-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190923122454.9888-1-baolu.lu@linux.intel.com>
References: <20190923122454.9888-1-baolu.lu@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This checks whether a domain should use first level page table
for map/unmap. And if so, we should attach the domain to the
device in first level translation mode.

Cc: Ashok Raj <ashok.raj@intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Liu Yi L <yi.l.liu@intel.com>
Cc: Yi Sun <yi.y.sun@linux.intel.com>
Cc: Sanjay Kumar <sanjay.k.kumar@intel.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
---
 drivers/iommu/intel-iommu.c | 41 ++++++++++++++++++++++++++++++++++---
 1 file changed, 38 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 103480016010..d539e6a6c3dd 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -1722,6 +1722,26 @@ static void free_dmar_iommu(struct intel_iommu *iommu)
 #endif
 }
 
+/*
+ * Check and return whether first level is used by default for
+ * DMA translation.
+ */
+static bool first_level_by_default(void)
+{
+	struct dmar_drhd_unit *drhd;
+	struct intel_iommu *iommu;
+
+	rcu_read_lock();
+	for_each_active_iommu(iommu, drhd)
+		if (!sm_supported(iommu) ||
+		    !ecap_flts(iommu->ecap) ||
+		    !cap_caching_mode(iommu->cap))
+			return false;
+	rcu_read_unlock();
+
+	return true;
+}
+
 static struct dmar_domain *alloc_domain(int flags)
 {
 	struct dmar_domain *domain;
@@ -1736,6 +1756,9 @@ static struct dmar_domain *alloc_domain(int flags)
 	domain->has_iotlb_device = false;
 	INIT_LIST_HEAD(&domain->devices);
 
+	if (first_level_by_default())
+		domain->flags |= DOMAIN_FLAG_FIRST_LEVEL_TRANS;
+
 	return domain;
 }
 
@@ -2625,6 +2648,11 @@ static struct dmar_domain *dmar_insert_one_dev_info(struct intel_iommu *iommu,
 		if (hw_pass_through && domain_type_is_si(domain))
 			ret = intel_pasid_setup_pass_through(iommu, domain,
 					dev, PASID_RID2PASID);
+		else if (domain_type_is_flt(domain))
+			ret = intel_pasid_setup_first_level(iommu, dev,
+					domain->pgd, PASID_RID2PASID,
+					domain->iommu_did[iommu->seq_id],
+					PASID_FLAG_SUPERVISOR_MODE);
 		else
 			ret = intel_pasid_setup_second_level(iommu, domain,
 					dev, PASID_RID2PASID);
@@ -5349,8 +5377,14 @@ static int aux_domain_add_dev(struct dmar_domain *domain,
 		goto attach_failed;
 
 	/* Setup the PASID entry for mediated devices: */
-	ret = intel_pasid_setup_second_level(iommu, domain, dev,
-					     domain->default_pasid);
+	if (domain_type_is_flt(domain))
+		ret = intel_pasid_setup_first_level(iommu, dev,
+				domain->pgd, domain->default_pasid,
+				domain->iommu_did[iommu->seq_id],
+				PASID_FLAG_SUPERVISOR_MODE);
+	else
+		ret = intel_pasid_setup_second_level(iommu, domain, dev,
+						     domain->default_pasid);
 	if (ret)
 		goto table_failed;
 	spin_unlock(&iommu->lock);
@@ -5583,7 +5617,8 @@ static phys_addr_t intel_iommu_iova_to_phys(struct iommu_domain *domain,
 	int level = 0;
 	u64 phys = 0;
 
-	if (dmar_domain->flags & DOMAIN_FLAG_LOSE_CHILDREN)
+	if ((dmar_domain->flags & DOMAIN_FLAG_LOSE_CHILDREN) ||
+	    (dmar_domain->flags & DOMAIN_FLAG_FIRST_LEVEL_TRANS))
 		return 0;
 
 	pte = pfn_to_dma_pte(dmar_domain, iova >> VTD_PAGE_SHIFT, &level);
-- 
2.17.1

