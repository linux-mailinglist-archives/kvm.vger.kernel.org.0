Return-Path: <kvm+bounces-30978-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A55CD9BF211
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 16:47:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 353F71F24065
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 15:47:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EFEB20721E;
	Wed,  6 Nov 2024 15:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VE9DXKfI"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1CBB20605D
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 15:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730907975; cv=none; b=msX1/euMBEpLfFtojC4hqgS9/ItaneMZMPHzProLsj+YoXDraGLr3vw9YrLv6SSq80IEjHL++bFQYYStq9iSpBpNOS4RBZk8ClVrzmVkvwoHYVjKtGbjV8IN7L8lOin4YA+UVyPM1MoA+9MxLc6oJf1BSoCcbIpl9b3igf6PenA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730907975; c=relaxed/simple;
	bh=0I9CVz13hnRK+5KlO77zaYQGiTadCRWLm+oL6A43ois=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VyfQk89BZlE2l3p+mUyGua/t/OHPavefPFjdPosUDe4deBGEPcPomIQ0ipyd0QiT+vVQ1m/G6sZFLhSampM9yyrhK26en+A4zDy/hF/HTipWqFdWH/6bOAb8d8drpexUiGPVfP0DuIXYcqqIILYM5IJjFJOPFj/ZmagSBshHv+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VE9DXKfI; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730907973; x=1762443973;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0I9CVz13hnRK+5KlO77zaYQGiTadCRWLm+oL6A43ois=;
  b=VE9DXKfID+jmATgUm1Yjyn2ItaYs7Cp6LDPCbhN+73EqVtv0YGtmyhEl
   8XOg2VqttgwQGPe1Oy2nah9y40k6+jaw5NjgYWyiviqaM98kdE6Nm/gcr
   WHq9Ybuipb0cj9kysOmdLgicpC6oqczoOEG5QMbOhu25+ul2NqimfYb1A
   eelL73cdXlyuIY+U+y+OqfMK67It8Pavw4bIH4/c5zx9dRlLCC9AapIPV
   Di/LYP18Uk7fL5iYvVvZxbSic241iJeSHtKGSn6A5abiTOxpW7T5R1PdS
   RVNxSWKL1AJgLQvLlCgnFWsY2O9ktVJRcqWAtl8+JJse0lTqD0I4yERo7
   g==;
X-CSE-ConnectionGUID: pvnTpp2xTTGOErjk+PkLRg==
X-CSE-MsgGUID: Z6udxNZeRviu3qAD4668gA==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="48174235"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="48174235"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2024 07:46:10 -0800
X-CSE-ConnectionGUID: uApo15SFSRql/7dKoutwuQ==
X-CSE-MsgGUID: 6AnO8xfoTFaOTzwXtvx0ZA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,263,1725346800"; 
   d="scan'208";a="89468203"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orviesa005.jf.intel.com with ESMTP; 06 Nov 2024 07:46:10 -0800
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
Subject: [PATCH v5 04/13] iommu/vt-d: Add pasid replace helpers
Date: Wed,  6 Nov 2024 07:45:57 -0800
Message-Id: <20241106154606.9564-5-yi.l.liu@intel.com>
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

pasid replacement allows converting a present pasid entry to be FS, SS,
PT or nested, hence add helpers for such operations.

Suggested-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/iommu/intel/pasid.c | 182 ++++++++++++++++++++++++++++++++++++
 drivers/iommu/intel/pasid.h |  15 +++
 2 files changed, 197 insertions(+)

diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/pasid.c
index 6841b9892d55..777e70b539b1 100644
--- a/drivers/iommu/intel/pasid.c
+++ b/drivers/iommu/intel/pasid.c
@@ -389,6 +389,48 @@ int intel_pasid_setup_first_level(struct intel_iommu *iommu,
 	return 0;
 }
 
+int intel_pasid_replace_first_level(struct intel_iommu *iommu,
+				    struct device *dev, pgd_t *pgd,
+				    u32 pasid, u16 did, u16 old_did,
+				    int flags)
+{
+	struct pasid_entry *pte;
+
+	if (!ecap_flts(iommu->ecap)) {
+		pr_err("No first level translation support on %s\n",
+		       iommu->name);
+		return -EINVAL;
+	}
+
+	if ((flags & PASID_FLAG_FL5LP) && !cap_fl5lp_support(iommu->cap)) {
+		pr_err("No 5-level paging support for first-level on %s\n",
+		       iommu->name);
+		return -EINVAL;
+	}
+
+	spin_lock(&iommu->lock);
+	pte = intel_pasid_get_entry(dev, pasid);
+	if (!pte) {
+		spin_unlock(&iommu->lock);
+		return -ENODEV;
+	}
+
+	if (!pasid_pte_is_present(pte)) {
+		spin_unlock(&iommu->lock);
+		return -EINVAL;
+	}
+
+	WARN_ON(old_did != pasid_get_domain_id(pte));
+
+	pasid_pte_config_first_level(iommu, pte, pgd, did, flags);
+	spin_unlock(&iommu->lock);
+
+	intel_pasid_flush_present(iommu, dev, pasid, old_did, pte);
+	intel_iommu_drain_pasid_prq(dev, pasid);
+
+	return 0;
+}
+
 /*
  * Set up the scalable mode pasid entry for second only translation type.
  */
@@ -456,6 +498,55 @@ int intel_pasid_setup_second_level(struct intel_iommu *iommu,
 	return 0;
 }
 
+int intel_pasid_replace_second_level(struct intel_iommu *iommu,
+				     struct dmar_domain *domain,
+				     struct device *dev, u16 old_did,
+				     u32 pasid)
+{
+	struct pasid_entry *pte;
+	struct dma_pte *pgd;
+	u64 pgd_val;
+	int agaw;
+	u16 did;
+
+	/*
+	 * If hardware advertises no support for second level
+	 * translation, return directly.
+	 */
+	if (!ecap_slts(iommu->ecap)) {
+		pr_err("No second level translation support on %s\n",
+		       iommu->name);
+		return -EINVAL;
+	}
+
+	pgd = domain->pgd;
+	pgd_val = virt_to_phys(pgd);
+	did = domain_id_iommu(domain, iommu);
+
+	spin_lock(&iommu->lock);
+	pte = intel_pasid_get_entry(dev, pasid);
+	if (!pte) {
+		spin_unlock(&iommu->lock);
+		return -ENODEV;
+	}
+
+	if (!pasid_pte_is_present(pte)) {
+		spin_unlock(&iommu->lock);
+		return -EINVAL;
+	}
+
+	WARN_ON(old_did != pasid_get_domain_id(pte));
+
+	pasid_pte_config_second_level(iommu, pte, pgd_val, agaw,
+				      did, domain->dirty_tracking);
+	spin_unlock(&iommu->lock);
+
+	intel_pasid_flush_present(iommu, dev, pasid, old_did, pte);
+	intel_iommu_drain_pasid_prq(dev, pasid);
+
+	return 0;
+}
+
 /*
  * Set up dirty tracking on a second only or nested translation type.
  */
@@ -568,6 +659,36 @@ int intel_pasid_setup_pass_through(struct intel_iommu *iommu,
 	return 0;
 }
 
+int intel_pasid_replace_pass_through(struct intel_iommu *iommu,
+				     struct device *dev, u16 old_did,
+				     u32 pasid)
+{
+	u16 did = FLPT_DEFAULT_DID;
+	struct pasid_entry *pte;
+
+	spin_lock(&iommu->lock);
+	pte = intel_pasid_get_entry(dev, pasid);
+	if (!pte) {
+		spin_unlock(&iommu->lock);
+		return -ENODEV;
+	}
+
+	if (!pasid_pte_is_present(pte)) {
+		spin_unlock(&iommu->lock);
+		return -EINVAL;
+	}
+
+	WARN_ON(old_did != pasid_get_domain_id(pte));
+
+	pasid_pte_config_pass_through(iommu, pte, did);
+	spin_unlock(&iommu->lock);
+
+	intel_pasid_flush_present(iommu, dev, pasid, old_did, pte);
+	intel_iommu_drain_pasid_prq(dev, pasid);
+
+	return 0;
+}
+
 /*
  * Set the page snoop control for a pasid entry which has been set up.
  */
@@ -698,6 +819,67 @@ int intel_pasid_setup_nested(struct intel_iommu *iommu, struct device *dev,
 	return 0;
 }
 
+int intel_pasid_replace_nested(struct intel_iommu *iommu,
+			       struct device *dev, u32 pasid,
+			       u16 old_did, struct dmar_domain *domain)
+{
+	struct iommu_hwpt_vtd_s1 *s1_cfg = &domain->s1_cfg;
+	struct dmar_domain *s2_domain = domain->s2_domain;
+	u16 did = domain_id_iommu(domain, iommu);
+	struct pasid_entry *pte;
+
+	/* Address width should match the address width supported by hardware */
+	switch (s1_cfg->addr_width) {
+	case ADDR_WIDTH_4LEVEL:
+		break;
+	case ADDR_WIDTH_5LEVEL:
+		if (!cap_fl5lp_support(iommu->cap)) {
+			dev_err_ratelimited(dev,
+					    "5-level paging not supported\n");
+			return -EINVAL;
+		}
+		break;
+	default:
+		dev_err_ratelimited(dev, "Invalid stage-1 address width %d\n",
+				    s1_cfg->addr_width);
+		return -EINVAL;
+	}
+
+	if ((s1_cfg->flags & IOMMU_VTD_S1_SRE) && !ecap_srs(iommu->ecap)) {
+		pr_err_ratelimited("No supervisor request support on %s\n",
+				   iommu->name);
+		return -EINVAL;
+	}
+
+	if ((s1_cfg->flags & IOMMU_VTD_S1_EAFE) && !ecap_eafs(iommu->ecap)) {
+		pr_err_ratelimited("No extended access flag support on %s\n",
+				   iommu->name);
+		return -EINVAL;
+	}
+
+	spin_lock(&iommu->lock);
+	pte = intel_pasid_get_entry(dev, pasid);
+	if (!pte) {
+		spin_unlock(&iommu->lock);
+		return -ENODEV;
+	}
+
+	if (!pasid_pte_is_present(pte)) {
+		spin_unlock(&iommu->lock);
+		return -EINVAL;
+	}
+
+	WARN_ON(old_did != pasid_get_domain_id(pte));
+
+	pasid_pte_config_nestd(iommu, pte, s1_cfg, s2_domain, did);
+	spin_unlock(&iommu->lock);
+
+	intel_pasid_flush_present(iommu, dev, pasid, old_did, pte);
+	intel_iommu_drain_pasid_prq(dev, pasid);
+
+	return 0;
+}
+
 /*
  * Interfaces to setup or teardown a pasid table to the scalable-mode
  * context table entry:
diff --git a/drivers/iommu/intel/pasid.h b/drivers/iommu/intel/pasid.h
index dde6d3ba5ae0..06d1f7006d01 100644
--- a/drivers/iommu/intel/pasid.h
+++ b/drivers/iommu/intel/pasid.h
@@ -303,6 +303,21 @@ int intel_pasid_setup_pass_through(struct intel_iommu *iommu,
 				   struct device *dev, u32 pasid);
 int intel_pasid_setup_nested(struct intel_iommu *iommu, struct device *dev,
 			     u32 pasid, struct dmar_domain *domain);
+int intel_pasid_replace_first_level(struct intel_iommu *iommu,
+				    struct device *dev, pgd_t *pgd,
+				    u32 pasid, u16 did, u16 old_did,
+				    int flags);
+int intel_pasid_replace_second_level(struct intel_iommu *iommu,
+				     struct dmar_domain *domain,
+				     struct device *dev, u16 old_did,
+				     u32 pasid);
+int intel_pasid_replace_pass_through(struct intel_iommu *iommu,
+				     struct device *dev, u16 old_did,
+				     u32 pasid);
+int intel_pasid_replace_nested(struct intel_iommu *iommu,
+			       struct device *dev, u32 pasid,
+			       u16 old_did, struct dmar_domain *domain);
+
 void intel_pasid_tear_down_entry(struct intel_iommu *iommu,
 				 struct device *dev, u32 pasid,
 				 bool fault_ignore);
-- 
2.34.1


