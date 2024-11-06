Return-Path: <kvm+bounces-30977-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FF1B9BF210
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 16:47:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EDDE92857A0
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 15:47:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 058E7206948;
	Wed,  6 Nov 2024 15:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dW5JIiwB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28FE5205AC9
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 15:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730907974; cv=none; b=uvqu+q/AbspuA/SMrUY2rGREH5R6KsUgVKtms0Q719BrbThX1JWoA71NGAQLKRpOZsLmpuTsBoW740chgWE70Tv/IzeXTkVamHZIECwxF/tbG63Krmuy9vuiFasDn3zOqAr5PAJDYS57VgL/GQ6oWxXIdc5mb1Ipmzv2gsMqgAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730907974; c=relaxed/simple;
	bh=9wLdXw3BVxZSTT4bVE3slrEcCOSGdlD522bUo7Fydxs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=S9GU/8D0nFONHva9J8dU8A2ytFyHW4/G0EoSDGK4LFnQT8Pgs7LhK1Ucj1YJvEI/M8OIUfP6zhEcQ02HufrfOsaVyzPwhzR3kpIcrddZgExlhU3R9X0j1GMcXxjgFnq5eM3y0xq7QA8n9rigDQktiBt7spjHoxRJEj/u2/KAwQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dW5JIiwB; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730907972; x=1762443972;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9wLdXw3BVxZSTT4bVE3slrEcCOSGdlD522bUo7Fydxs=;
  b=dW5JIiwB92vu58+hTf/p+pL9nXkOezVQDQv5Dmbw7no9hJPrmZpHSE8Z
   5A+ZG/asC1MpObLy4b1Qiufjc2ATLJq2pNix77LQCA79C8njGaLex2deu
   S81Cihe8nvGu+BiEU2VRzRFt2TLqQ48HHS15GBVxxqKj2ADikMUiiw+iJ
   31v3caqP4Heirk+pRnsOgvJ4P7Gm7FBBhMExrjHWMBr15MWoQ5/oZcIFw
   wNCI69ijgMjTnJXOc2QM/TsUPF3oc+ZQW0aaPOgM/RK9b3ItV7V7+mb3h
   9giOF7TjCkhWXk0ayD46dkLe0rn5lRI9n94IAm6lJ3baI88aYjmWqCO2s
   w==;
X-CSE-ConnectionGUID: +zSQd9EFT6qk/brANepeGA==
X-CSE-MsgGUID: mMgB+oVuSuSUtgsxhIhBpQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="48174228"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="48174228"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2024 07:46:10 -0800
X-CSE-ConnectionGUID: mmY+faWRR72aTLHOqISh6g==
X-CSE-MsgGUID: O3B8YwKNTKiVm0UfPgv8+w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,263,1725346800"; 
   d="scan'208";a="89468195"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orviesa005.jf.intel.com with ESMTP; 06 Nov 2024 07:46:09 -0800
From: Yi Liu <yi.l.liu@intel.com>
To: joro@8bytes.org,
	jgg@nvidia.com,
	kevin.tian@intel.com,
	baolu.lu@linux.intel.com
Cc: alex.williamson@redhat.com,
	eric.auger@redhat.com,
	nicolinc@nvidia.com,
	kvm@vger.kernel.org,
	chao.p.peng@linux.intel.com,
	yi.l.liu@intel.com,
	iommu@lists.linux.dev,
	zhenzhong.duan@intel.com,
	vasant.hegde@amd.com,
	willy@infradead.org
Subject: [PATCH v5 03/13] iommu/vt-d: Refactor the pasid setup helpers
Date: Wed,  6 Nov 2024 07:45:56 -0800
Message-Id: <20241106154606.9564-4-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241106154606.9564-1-yi.l.liu@intel.com>
References: <20241106154606.9564-1-yi.l.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It is clearer to have a new set of pasid replacement helpers other than
extending the existing ones to cover both initial setup and replacement.
Then abstract out the common code for manipulating the pasid entry as
preparation.

No functional change is intended.

Suggested-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/iommu/intel/pasid.c | 169 ++++++++++++++++++++++--------------
 1 file changed, 105 insertions(+), 64 deletions(-)

diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/pasid.c
index 8d11701c2e76..6841b9892d55 100644
--- a/drivers/iommu/intel/pasid.c
+++ b/drivers/iommu/intel/pasid.c
@@ -324,6 +324,32 @@ static void intel_pasid_flush_present(struct intel_iommu *iommu,
  * Set up the scalable mode pasid table entry for first only
  * translation type.
  */
+static void pasid_pte_config_first_level(struct intel_iommu *iommu,
+					 struct pasid_entry *pte,
+					 pgd_t *pgd, u16 did, int flags)
+{
+	lockdep_assert_held(&iommu->lock);
+
+	pasid_clear_entry(pte);
+
+	/* Setup the first level page table pointer: */
+	pasid_set_flptr(pte, (u64)__pa(pgd));
+
+	if (flags & PASID_FLAG_FL5LP)
+		pasid_set_flpm(pte, 1);
+
+	if (flags & PASID_FLAG_PAGE_SNOOP)
+		pasid_set_pgsnp(pte);
+
+	pasid_set_domain_id(pte, did);
+	pasid_set_address_width(pte, iommu->agaw);
+	pasid_set_page_snoop(pte, !!ecap_smpwc(iommu->ecap));
+
+	/* Setup Present and PASID Granular Transfer Type: */
+	pasid_set_translation_type(pte, PASID_ENTRY_PGTT_FL_ONLY);
+	pasid_set_present(pte);
+}
+
 int intel_pasid_setup_first_level(struct intel_iommu *iommu,
 				  struct device *dev, pgd_t *pgd,
 				  u32 pasid, u16 did, int flags)
@@ -354,24 +380,8 @@ int intel_pasid_setup_first_level(struct intel_iommu *iommu,
 		return -EBUSY;
 	}
 
-	pasid_clear_entry(pte);
-
-	/* Setup the first level page table pointer: */
-	pasid_set_flptr(pte, (u64)__pa(pgd));
-
-	if (flags & PASID_FLAG_FL5LP)
-		pasid_set_flpm(pte, 1);
-
-	if (flags & PASID_FLAG_PAGE_SNOOP)
-		pasid_set_pgsnp(pte);
-
-	pasid_set_domain_id(pte, did);
-	pasid_set_address_width(pte, iommu->agaw);
-	pasid_set_page_snoop(pte, !!ecap_smpwc(iommu->ecap));
+	pasid_pte_config_first_level(iommu, pte, pgd, did, flags);
 
-	/* Setup Present and PASID Granular Transfer Type: */
-	pasid_set_translation_type(pte, PASID_ENTRY_PGTT_FL_ONLY);
-	pasid_set_present(pte);
 	spin_unlock(&iommu->lock);
 
 	pasid_flush_caches(iommu, pte, pasid, did);
@@ -382,6 +392,26 @@ int intel_pasid_setup_first_level(struct intel_iommu *iommu,
 /*
  * Set up the scalable mode pasid entry for second only translation type.
  */
+static void pasid_pte_config_second_level(struct intel_iommu *iommu,
+					  struct pasid_entry *pte,
+					  u64 pgd_val, int agaw, u16 did,
+					  bool dirty_tracking)
+{
+	lockdep_assert_held(&iommu->lock);
+
+	pasid_clear_entry(pte);
+	pasid_set_domain_id(pte, did);
+	pasid_set_slptr(pte, pgd_val);
+	pasid_set_address_width(pte, agaw);
+	pasid_set_translation_type(pte, PASID_ENTRY_PGTT_SL_ONLY);
+	pasid_set_fault_enable(pte);
+	pasid_set_page_snoop(pte, !!ecap_smpwc(iommu->ecap));
+	if (dirty_tracking)
+		pasid_set_ssade(pte);
+
+	pasid_set_present(pte);
+}
+
 int intel_pasid_setup_second_level(struct intel_iommu *iommu,
 				   struct dmar_domain *domain,
 				   struct device *dev, u32 pasid)
@@ -417,17 +447,8 @@ int intel_pasid_setup_second_level(struct intel_iommu *iommu,
 		return -EBUSY;
 	}
 
-	pasid_clear_entry(pte);
-	pasid_set_domain_id(pte, did);
-	pasid_set_slptr(pte, pgd_val);
-	pasid_set_address_width(pte, domain->agaw);
-	pasid_set_translation_type(pte, PASID_ENTRY_PGTT_SL_ONLY);
-	pasid_set_fault_enable(pte);
-	pasid_set_page_snoop(pte, !!ecap_smpwc(iommu->ecap));
-	if (domain->dirty_tracking)
-		pasid_set_ssade(pte);
-
-	pasid_set_present(pte);
+	pasid_pte_config_second_level(iommu, pte, pgd_val, domain->agaw,
+				      did, domain->dirty_tracking);
 	spin_unlock(&iommu->lock);
 
 	pasid_flush_caches(iommu, pte, pasid, did);
@@ -507,6 +528,20 @@ int intel_pasid_setup_dirty_tracking(struct intel_iommu *iommu,
 /*
  * Set up the scalable mode pasid entry for passthrough translation type.
  */
+static void pasid_pte_config_pass_through(struct intel_iommu *iommu,
+					  struct pasid_entry *pte, u16 did)
+{
+	lockdep_assert_held(&iommu->lock);
+
+	pasid_clear_entry(pte);
+	pasid_set_domain_id(pte, did);
+	pasid_set_address_width(pte, iommu->agaw);
+	pasid_set_translation_type(pte, PASID_ENTRY_PGTT_PT);
+	pasid_set_fault_enable(pte);
+	pasid_set_page_snoop(pte, !!ecap_smpwc(iommu->ecap));
+	pasid_set_present(pte);
+}
+
 int intel_pasid_setup_pass_through(struct intel_iommu *iommu,
 				   struct device *dev, u32 pasid)
 {
@@ -525,13 +560,7 @@ int intel_pasid_setup_pass_through(struct intel_iommu *iommu,
 		return -EBUSY;
 	}
 
-	pasid_clear_entry(pte);
-	pasid_set_domain_id(pte, did);
-	pasid_set_address_width(pte, iommu->agaw);
-	pasid_set_translation_type(pte, PASID_ENTRY_PGTT_PT);
-	pasid_set_fault_enable(pte);
-	pasid_set_page_snoop(pte, !!ecap_smpwc(iommu->ecap));
-	pasid_set_present(pte);
+	pasid_pte_config_pass_through(iommu, pte, did);
 	spin_unlock(&iommu->lock);
 
 	pasid_flush_caches(iommu, pte, pasid, did);
@@ -562,6 +591,46 @@ void intel_pasid_setup_page_snoop_control(struct intel_iommu *iommu,
 	intel_pasid_flush_present(iommu, dev, pasid, did, pte);
 }
 
+static void pasid_pte_config_nestd(struct intel_iommu *iommu,
+				   struct pasid_entry *pte,
+				   struct iommu_hwpt_vtd_s1 *s1_cfg,
+				   struct dmar_domain *s2_domain,
+				   u16 did)
+{
+	struct dma_pte *pgd = s2_domain->pgd;
+
+	lockdep_assert_held(&iommu->lock);
+
+	pasid_clear_entry(pte);
+
+	if (s1_cfg->addr_width == ADDR_WIDTH_5LEVEL)
+		pasid_set_flpm(pte, 1);
+
+	pasid_set_flptr(pte, s1_cfg->pgtbl_addr);
+
+	if (s1_cfg->flags & IOMMU_VTD_S1_SRE) {
+		pasid_set_sre(pte);
+		if (s1_cfg->flags & IOMMU_VTD_S1_WPE)
+			pasid_set_wpe(pte);
+	}
+
+	if (s1_cfg->flags & IOMMU_VTD_S1_EAFE)
+		pasid_set_eafe(pte);
+
+	if (s2_domain->force_snooping)
+		pasid_set_pgsnp(pte);
+
+	pasid_set_slptr(pte, virt_to_phys(pgd));
+	pasid_set_fault_enable(pte);
+	pasid_set_domain_id(pte, did);
+	pasid_set_address_width(pte, s2_domain->agaw);
+	pasid_set_page_snoop(pte, !!ecap_smpwc(iommu->ecap));
+	if (s2_domain->dirty_tracking)
+		pasid_set_ssade(pte);
+	pasid_set_translation_type(pte, PASID_ENTRY_PGTT_NESTED);
+	pasid_set_present(pte);
+}
+
 /**
  * intel_pasid_setup_nested() - Set up PASID entry for nested translation.
  * @iommu:      IOMMU which the device belong to
@@ -579,7 +648,6 @@ int intel_pasid_setup_nested(struct intel_iommu *iommu, struct device *dev,
 	struct iommu_hwpt_vtd_s1 *s1_cfg = &domain->s1_cfg;
 	struct dmar_domain *s2_domain = domain->s2_domain;
 	u16 did = domain_id_iommu(domain, iommu);
-	struct dma_pte *pgd = s2_domain->pgd;
 	struct pasid_entry *pte;
 
 	/* Address width should match the address width supported by hardware */
@@ -622,34 +690,7 @@ int intel_pasid_setup_nested(struct intel_iommu *iommu, struct device *dev,
 		return -EBUSY;
 	}
 
-	pasid_clear_entry(pte);
-
-	if (s1_cfg->addr_width == ADDR_WIDTH_5LEVEL)
-		pasid_set_flpm(pte, 1);
-
-	pasid_set_flptr(pte, s1_cfg->pgtbl_addr);
-
-	if (s1_cfg->flags & IOMMU_VTD_S1_SRE) {
-		pasid_set_sre(pte);
-		if (s1_cfg->flags & IOMMU_VTD_S1_WPE)
-			pasid_set_wpe(pte);
-	}
-
-	if (s1_cfg->flags & IOMMU_VTD_S1_EAFE)
-		pasid_set_eafe(pte);
-
-	if (s2_domain->force_snooping)
-		pasid_set_pgsnp(pte);
-
-	pasid_set_slptr(pte, virt_to_phys(pgd));
-	pasid_set_fault_enable(pte);
-	pasid_set_domain_id(pte, did);
-	pasid_set_address_width(pte, s2_domain->agaw);
-	pasid_set_page_snoop(pte, !!ecap_smpwc(iommu->ecap));
-	if (s2_domain->dirty_tracking)
-		pasid_set_ssade(pte);
-	pasid_set_translation_type(pte, PASID_ENTRY_PGTT_NESTED);
-	pasid_set_present(pte);
+	pasid_pte_config_nestd(iommu, pte, s1_cfg, s2_domain, did);
 	spin_unlock(&iommu->lock);
 
 	pasid_flush_caches(iommu, pte, pasid, did);
-- 
2.34.1


