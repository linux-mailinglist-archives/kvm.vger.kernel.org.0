Return-Path: <kvm+bounces-30512-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id F32D49BB5A9
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 14:19:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 59F6CB2284A
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 13:19:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0CD22AE72;
	Mon,  4 Nov 2024 13:18:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MYQUPvQa"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C10B282FA
	for <kvm@vger.kernel.org>; Mon,  4 Nov 2024 13:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730726332; cv=none; b=SSq69KQD5AnQ9aVvXvd6C/hHaDuiseJU3i/DTXvD45sHFvOAbHzZKJXgxtACVmBkeZUzJzEjXKREGcAm6VJ7N1RMMK08Pfs1PwrmtZDv+tq5V7kjAFX8KS/41k5wNgWhVn8KbwW21/q54LajyUipDOhe/QVary/PZJnk3yKOQAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730726332; c=relaxed/simple;
	bh=IMnecncKJGIm/cNKa568toKL4lD6ZGPRi67KmpCl/oc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jvgvXf+l05R5MZJDWHjR7HN98I3gVatEGiWdDK018311VzhfWi8Dx4y/GInwCV/DN+T9VWqrmLvDJWlAyrpqcD31wlxsm0zTKFFm5KWWtzUOoWO9mXnv05/I3sYy8ykUMu8IsLqkCA8uRhixDqnOCrGqcUVeVmuSlHP33y111nI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MYQUPvQa; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730726331; x=1762262331;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IMnecncKJGIm/cNKa568toKL4lD6ZGPRi67KmpCl/oc=;
  b=MYQUPvQa1uyHaiWTo7cXpADPxGsobX8VSXfszpDYl1vHwN1jHQzjlUqc
   d/X3PK4Tqpb+DT36+gO1j5CC76PGtq+dXGvjxUndl7LfVpNWN6Dn0Fwe9
   azLo46pywuo7cYp+qLy4C7zbczZEHrnzXuQTXxz3AZSa6DnkPtZU3A/uz
   hCfCsoC0Po4IF0NiBf2t4vqZUIzaoXd5jhlpIVS9UuOIdbLxWbQD9eR7E
   wqC1HkQ+4pAUO9BSW5I2iR/4cc/oyP5yIbIxbOyy/ie1fjLu2CkROAOcD
   ieG3xw/lG4p5GeRsCyuD6VJtaFOl5VWTgB82NZqJ9LQcMPqkofhypzfJ8
   w==;
X-CSE-ConnectionGUID: No0i28zPRh+MdvfQ4xzYbg==
X-CSE-MsgGUID: nhXZMgs8QcKGWeZM5GMvaQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11246"; a="41003726"
X-IronPort-AV: E=Sophos;i="6.11,257,1725346800"; 
   d="scan'208";a="41003726"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 05:18:51 -0800
X-CSE-ConnectionGUID: eqERbHApR/qmsDp/WB0Exg==
X-CSE-MsgGUID: vxuyrOhaQ3etWHZxo3x1XQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,257,1725346800"; 
   d="scan'208";a="83999483"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmviesa010.fm.intel.com with ESMTP; 04 Nov 2024 05:18:47 -0800
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
	will@kernel.org
Subject: [PATCH v4 04/13] iommu/vt-d: Add pasid replace helpers
Date: Mon,  4 Nov 2024 05:18:33 -0800
Message-Id: <20241104131842.13303-5-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241104131842.13303-1-yi.l.liu@intel.com>
References: <20241104131842.13303-1-yi.l.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

pasid replacement allows converting a present pasid entry to be FS, SS,
PT or nested, hence add helpers for such operations. This simplifies the
callers as well since the caller can switch the pasid to the new domain
by one-shot.

Suggested-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/iommu/intel/pasid.c | 173 ++++++++++++++++++++++++++++++++++++
 drivers/iommu/intel/pasid.h |  12 +++
 2 files changed, 185 insertions(+)

diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/pasid.c
index 65fd2fee01b7..b7c2d65b8726 100644
--- a/drivers/iommu/intel/pasid.c
+++ b/drivers/iommu/intel/pasid.c
@@ -390,6 +390,40 @@ int intel_pasid_setup_first_level(struct intel_iommu *iommu,
 	return 0;
 }
 
+int intel_pasid_replace_first_level(struct intel_iommu *iommu,
+				    struct device *dev, pgd_t *pgd,
+				    u32 pasid, u16 did, int flags)
+{
+	struct pasid_entry *pte;
+	u16 old_did;
+
+	if (!ecap_flts(iommu->ecap) ||
+	    ((flags & PASID_FLAG_FL5LP) && !cap_fl5lp_support(iommu->cap)))
+		return -EINVAL;
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
+	old_did = pasid_get_domain_id(pte);
+
+	pasid_pte_config_first_level(iommu, pte, pgd, did, flags);
+	spin_unlock(&iommu->lock);
+
+	intel_pasid_flush_present(iommu, dev, pasid, old_did, pte);
+	intel_drain_pasid_prq(dev, pasid);
+
+	return 0;
+}
+
 /*
  * Skip top levels of page tables for iommu which has less agaw
  * than default. Unnecessary for PT mode.
@@ -483,6 +517,55 @@ int intel_pasid_setup_second_level(struct intel_iommu *iommu,
 	return 0;
 }
 
+int intel_pasid_replace_second_level(struct intel_iommu *iommu,
+				     struct dmar_domain *domain,
+				     struct device *dev, u32 pasid)
+{
+	struct pasid_entry *pte;
+	struct dma_pte *pgd;
+	u16 did, old_did;
+	u64 pgd_val;
+	int agaw;
+
+	/*
+	 * If hardware advertises no support for second level
+	 * translation, return directly.
+	 */
+	if (!ecap_slts(iommu->ecap))
+		return -EINVAL;
+
+	pgd = domain->pgd;
+	agaw = iommu_skip_agaw(domain, iommu, &pgd);
+	if (agaw < 0)
+		return -EINVAL;
+
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
+	old_did = pasid_get_domain_id(pte);
+
+	pasid_pte_config_second_level(iommu, pte, pgd_val, agaw,
+				      did, domain->dirty_tracking);
+	spin_unlock(&iommu->lock);
+
+	intel_pasid_flush_present(iommu, dev, pasid, old_did, pte);
+	intel_drain_pasid_prq(dev, pasid);
+
+	return 0;
+}
+
 /*
  * Set up dirty tracking on a second only or nested translation type.
  */
@@ -595,6 +678,35 @@ int intel_pasid_setup_pass_through(struct intel_iommu *iommu,
 	return 0;
 }
 
+int intel_pasid_replace_pass_through(struct intel_iommu *iommu,
+				     struct device *dev, u32 pasid)
+{
+	u16 did = FLPT_DEFAULT_DID, old_did;
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
+	old_did = pasid_get_domain_id(pte);
+
+	pasid_pte_config_pass_through(iommu, pte, did);
+	spin_unlock(&iommu->lock);
+
+	intel_pasid_flush_present(iommu, dev, pasid, old_did, pte);
+	intel_drain_pasid_prq(dev, pasid);
+
+	return 0;
+}
+
 /*
  * Set the page snoop control for a pasid entry which has been set up.
  */
@@ -725,6 +837,67 @@ int intel_pasid_setup_nested(struct intel_iommu *iommu, struct device *dev,
 	return 0;
 }
 
+int intel_pasid_replace_nested(struct intel_iommu *iommu,
+			       struct device *dev, u32 pasid,
+			       struct dmar_domain *domain)
+{
+	struct iommu_hwpt_vtd_s1 *s1_cfg = &domain->s1_cfg;
+	u16 did = domain_id_iommu(domain, iommu), old_did;
+	struct dmar_domain *s2_domain = domain->s2_domain;
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
+	old_did = pasid_get_domain_id(pte);
+
+	pasid_pte_config_nestd(iommu, pte, s1_cfg, s2_domain, did);
+	spin_unlock(&iommu->lock);
+
+	intel_pasid_flush_present(iommu, dev, pasid, old_did, pte);
+	intel_drain_pasid_prq(dev, pasid);
+
+	return 0;
+}
+
 /*
  * Interfaces to setup or teardown a pasid table to the scalable-mode
  * context table entry:
diff --git a/drivers/iommu/intel/pasid.h b/drivers/iommu/intel/pasid.h
index dde6d3ba5ae0..228938f3be51 100644
--- a/drivers/iommu/intel/pasid.h
+++ b/drivers/iommu/intel/pasid.h
@@ -303,6 +303,18 @@ int intel_pasid_setup_pass_through(struct intel_iommu *iommu,
 				   struct device *dev, u32 pasid);
 int intel_pasid_setup_nested(struct intel_iommu *iommu, struct device *dev,
 			     u32 pasid, struct dmar_domain *domain);
+int intel_pasid_replace_first_level(struct intel_iommu *iommu,
+				    struct device *dev, pgd_t *pgd,
+				    u32 pasid, u16 did, int flags);
+int intel_pasid_replace_second_level(struct intel_iommu *iommu,
+				     struct dmar_domain *domain,
+				     struct device *dev, u32 pasid);
+int intel_pasid_replace_pass_through(struct intel_iommu *iommu,
+				     struct device *dev, u32 pasid);
+int intel_pasid_replace_nested(struct intel_iommu *iommu,
+			       struct device *dev, u32 pasid,
+			       struct dmar_domain *domain);
+
 void intel_pasid_tear_down_entry(struct intel_iommu *iommu,
 				 struct device *dev, u32 pasid,
 				 bool fault_ignore);
-- 
2.34.1


