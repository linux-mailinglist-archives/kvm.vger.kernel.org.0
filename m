Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 072BD10C25F
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2019 03:30:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729248AbfK1CaS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Nov 2019 21:30:18 -0500
Received: from mga18.intel.com ([134.134.136.126]:17935 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728387AbfK1CaP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Nov 2019 21:30:15 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Nov 2019 18:30:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,251,1571727600"; 
   d="scan'208";a="221176239"
Received: from allen-box.sh.intel.com ([10.239.159.136])
  by orsmga002.jf.intel.com with ESMTP; 27 Nov 2019 18:30:12 -0800
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
Subject: [PATCH v2 7/8] iommu/vt-d: Identify domains using first level page table
Date:   Thu, 28 Nov 2019 10:25:49 +0800
Message-Id: <20191128022550.9832-8-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191128022550.9832-1-baolu.lu@linux.intel.com>
References: <20191128022550.9832-1-baolu.lu@linux.intel.com>
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
 drivers/iommu/intel-iommu.c | 63 +++++++++++++++++++++++++++++++++++--
 1 file changed, 60 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 695a7a5fbe8e..68b2f98ecd65 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -417,6 +417,11 @@ const struct iommu_ops intel_iommu_ops;
 static const struct pgtable_ops first_lvl_pgtable_ops;
 static const struct pgtable_ops second_lvl_pgtable_ops;
 
+static inline bool domain_pgtable_first_lvl(struct dmar_domain *domain)
+{
+	return domain->ops == &first_lvl_pgtable_ops;
+}
+
 static bool translation_pre_enabled(struct intel_iommu *iommu)
 {
 	return (iommu->flags & VTD_FLAG_TRANS_PRE_ENABLED);
@@ -1702,6 +1707,44 @@ static bool first_lvl_5lp_support(void)
 	return first_level_5lp_supported;
 }
 
+/*
+ * Check and return whether first level is used by default for
+ * DMA translation.
+ */
+static bool first_level_by_default(void)
+{
+	struct dmar_drhd_unit *drhd;
+	struct intel_iommu *iommu;
+	static int first_level_support = -1;
+
+	if (likely(first_level_support != -1))
+		return first_level_support;
+
+	first_level_support = 1;
+
+	rcu_read_lock();
+	for_each_active_iommu(iommu, drhd) {
+		if (!sm_supported(iommu) || !ecap_flts(iommu->ecap)) {
+			first_level_support = 0;
+			break;
+		}
+#ifdef CONFIG_X86
+		/*
+		 * Currently we don't support paging mode missmatching.
+		 * Could be turned on later if there is a case.
+		 */
+		if (cpu_feature_enabled(X86_FEATURE_LA57) &&
+		    !cap_5lp_support(iommu->cap)) {
+			first_level_support = 0;
+			break;
+		}
+#endif /* #ifdef CONFIG_X86 */
+	}
+	rcu_read_unlock();
+
+	return first_level_support;
+}
+
 static struct dmar_domain *alloc_domain(int flags)
 {
 	struct dmar_domain *domain;
@@ -1714,7 +1757,10 @@ static struct dmar_domain *alloc_domain(int flags)
 	domain->nid = NUMA_NO_NODE;
 	domain->flags = flags;
 	domain->has_iotlb_device = false;
-	domain->ops = &second_lvl_pgtable_ops;
+	if (first_level_by_default())
+		domain->ops = &first_lvl_pgtable_ops;
+	else
+		domain->ops = &second_lvl_pgtable_ops;
 	domain->first_lvl_5lp = first_lvl_5lp_support();
 	spin_lock_init(&domain->page_table_lock);
 	INIT_LIST_HEAD(&domain->devices);
@@ -2710,6 +2756,11 @@ static struct dmar_domain *dmar_insert_one_dev_info(struct intel_iommu *iommu,
 		if (hw_pass_through && domain_type_is_si(domain))
 			ret = intel_pasid_setup_pass_through(iommu, domain,
 					dev, PASID_RID2PASID);
+		else if (domain_pgtable_first_lvl(domain))
+			ret = intel_pasid_setup_first_level(iommu, dev,
+					domain->pgd, PASID_RID2PASID,
+					domain->iommu_did[iommu->seq_id],
+					PASID_FLAG_SUPERVISOR_MODE);
 		else
 			ret = intel_pasid_setup_second_level(iommu, domain,
 					dev, PASID_RID2PASID);
@@ -5597,8 +5648,14 @@ static int aux_domain_add_dev(struct dmar_domain *domain,
 		goto attach_failed;
 
 	/* Setup the PASID entry for mediated devices: */
-	ret = intel_pasid_setup_second_level(iommu, domain, dev,
-					     domain->default_pasid);
+	if (domain_pgtable_first_lvl(domain))
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
-- 
2.17.1

