Return-Path: <kvm+bounces-29134-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DE309A34D6
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2024 07:58:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DFF60281B1A
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2024 05:58:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A15D8185B69;
	Fri, 18 Oct 2024 05:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AfZxNt0J"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19F2E185923
	for <kvm@vger.kernel.org>; Fri, 18 Oct 2024 05:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729230849; cv=none; b=at8wI8t/ESx9IhNuaUOt8JW/vAFUmOCPKvaqIcuAiu3EhFFlJSvwngFKBEMngkH5uq5hElL4uhVtzV08PDbWEi8mfr5DGiH6us7KV0i6X/qD2+FXwaKRo0nzr7o5FrVflv77SmuVLp8nhVdPCyiMpFlOFpTdBovQAPXf8h0KNpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729230849; c=relaxed/simple;
	bh=I6cnPBBGWjMWUQaXMoEXHfwqgyfLYPyWD5CjlkWSc7g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=H0Dcapb5NgdnrhtWtPLnJs3HGdzXdVW1dduscbRJC7cHuIhdcKSSpNKOn+rUmz711835f6jdVIRmi85yFXCvO6AuCHm8gOOZZK1tT+cJg6I5uTgEzS0GHxRPTzRgPTa2wMppBXSYYi8ahQoibsZgGHzF6tKj6gMKJXur5l60WEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AfZxNt0J; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729230848; x=1760766848;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=I6cnPBBGWjMWUQaXMoEXHfwqgyfLYPyWD5CjlkWSc7g=;
  b=AfZxNt0JlDvASBqA67+VxzA5AGUVqnlN744JdHKYkgeRzIAKKJfuPgPp
   amElqhNNAkeFWC73YhgmvyBNtFhSDTpW7tcoO7wzXhel02cGKKLtwZTiD
   7oVVDFe2XxaZnP3v8XOM/Cjc7KN/95+Op+EZpcL9U6Uf0cSVyoQao3ADu
   VeqXFmMsQNwB+iatYyrEu/fUas+aVYAeI78ftaGLvQkF/aCHMRDe6O4pr
   oiMCxj7YfVVoAKW485BUiFbjDF8chTr1H52Yj0NTsbQv+uvMKBO121IAo
   tguGGDG+Thq9YBql8Flm76XE8RAiCosj5sKI7heAom7hpevclyxVipH/O
   Q==;
X-CSE-ConnectionGUID: 14Nx4yOLROqu4DloJnLKhg==
X-CSE-MsgGUID: KQA/ccSrST61xE820Mdj4Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="28708803"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="28708803"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2024 22:54:07 -0700
X-CSE-ConnectionGUID: xJo1nfudRai9w+gARPmeIw==
X-CSE-MsgGUID: UZQ/o2fHT3+OBP68kdxu2Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,212,1725346800"; 
   d="scan'208";a="79188578"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orviesa007.jf.intel.com with ESMTP; 17 Oct 2024 22:54:06 -0700
From: Yi Liu <yi.l.liu@intel.com>
To: joro@8bytes.org,
	jgg@nvidia.com,
	kevin.tian@intel.com,
	baolu.lu@linux.intel.com,
	will@kernel.org
Cc: alex.williamson@redhat.com,
	eric.auger@redhat.com,
	nicolinc@nvidia.com,
	kvm@vger.kernel.org,
	chao.p.peng@linux.intel.com,
	yi.l.liu@intel.com,
	iommu@lists.linux.dev,
	zhenzhong.duan@intel.com,
	vasant.hegde@amd.com
Subject: [PATCH v3 4/9] iommu/vt-d: Make pasid setup helpers support modifying present pasid entry
Date: Thu, 17 Oct 2024 22:53:57 -0700
Message-Id: <20241018055402.23277-5-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241018055402.23277-1-yi.l.liu@intel.com>
References: <20241018055402.23277-1-yi.l.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

To handle domain replacement, the set_dev_pasid() op needs to modify a
present pasid entry.

A natural way to implement the set_dev_pasid() op is to reuse the logic
of remove_dev_pasid() in the beginning to remove the old configuration.
Then set up the new pasid entry. Roll back to the old domain if it fails
to set up the new pasid entry. This needs to invoke the set_dev_pasid op
of the old domain. While this breaks the iommu layering a bit.

An alternative is implementing the set_dev_pasid() without rollback to the
old domain. This requires putting all the pasid entry modifications in
the pasid setup helpers. While the set_dev_pasid() op calls the helpers when
all the preparation work such as memory allocation, and sanity check has been
done.

To support modifying present pasid entry, the setup helpers needs to call
intel_pasid_tear_down_entry() to destroy the old configuration, which also
includes the necessary cache flushing and PRQ draining.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/iommu/intel/pasid.c | 61 +++++++++++++------------------------
 1 file changed, 21 insertions(+), 40 deletions(-)

diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/pasid.c
index 336f9425214c..ce0a3bf701df 100644
--- a/drivers/iommu/intel/pasid.c
+++ b/drivers/iommu/intel/pasid.c
@@ -321,18 +321,13 @@ int intel_pasid_setup_first_level(struct intel_iommu *iommu,
 		return -EINVAL;
 	}
 
-	spin_lock(&iommu->lock);
-	pte = intel_pasid_get_entry(dev, pasid);
-	if (!pte) {
-		spin_unlock(&iommu->lock);
+	/* Destroy the old configuration if it already exists */
+	pte = intel_pasid_tear_down_entry(iommu, dev, pasid,
+					  INTEL_PASID_TEARDOWN_DRAIN_PRQ);
+	if (!pte)
 		return -ENODEV;
-	}
-
-	if (pasid_pte_is_present(pte)) {
-		spin_unlock(&iommu->lock);
-		return -EBUSY;
-	}
 
+	spin_lock(&iommu->lock);
 	pasid_clear_entry(pte);
 
 	/* Setup the first level page table pointer: */
@@ -407,21 +402,16 @@ int intel_pasid_setup_second_level(struct intel_iommu *iommu,
 		return -EINVAL;
 	}
 
+	/* Destroy the old configuration if it already exists */
+	pte = intel_pasid_tear_down_entry(iommu, dev, pasid,
+					  INTEL_PASID_TEARDOWN_DRAIN_PRQ);
+	if (!pte)
+		return -ENODEV;
+
 	pgd_val = virt_to_phys(pgd);
 	did = domain_id_iommu(domain, iommu);
 
 	spin_lock(&iommu->lock);
-	pte = intel_pasid_get_entry(dev, pasid);
-	if (!pte) {
-		spin_unlock(&iommu->lock);
-		return -ENODEV;
-	}
-
-	if (pasid_pte_is_present(pte)) {
-		spin_unlock(&iommu->lock);
-		return -EBUSY;
-	}
-
 	pasid_clear_entry(pte);
 	pasid_set_domain_id(pte, did);
 	pasid_set_slptr(pte, pgd_val);
@@ -518,18 +508,13 @@ int intel_pasid_setup_pass_through(struct intel_iommu *iommu,
 	u16 did = FLPT_DEFAULT_DID;
 	struct pasid_entry *pte;
 
-	spin_lock(&iommu->lock);
-	pte = intel_pasid_get_entry(dev, pasid);
-	if (!pte) {
-		spin_unlock(&iommu->lock);
+	/* Destroy the old configuration if it already exists */
+	pte = intel_pasid_tear_down_entry(iommu, dev, pasid,
+					  INTEL_PASID_TEARDOWN_DRAIN_PRQ);
+	if (!pte)
 		return -ENODEV;
-	}
-
-	if (pasid_pte_is_present(pte)) {
-		spin_unlock(&iommu->lock);
-		return -EBUSY;
-	}
 
+	spin_lock(&iommu->lock);
 	pasid_clear_entry(pte);
 	pasid_set_domain_id(pte, did);
 	pasid_set_address_width(pte, iommu->agaw);
@@ -634,17 +619,13 @@ int intel_pasid_setup_nested(struct intel_iommu *iommu, struct device *dev,
 		return -EINVAL;
 	}
 
-	spin_lock(&iommu->lock);
-	pte = intel_pasid_get_entry(dev, pasid);
-	if (!pte) {
-		spin_unlock(&iommu->lock);
+	/* Destroy the old configuration if it already exists */
+	pte = intel_pasid_tear_down_entry(iommu, dev, pasid,
+					  INTEL_PASID_TEARDOWN_DRAIN_PRQ);
+	if (!pte)
 		return -ENODEV;
-	}
-	if (pasid_pte_is_present(pte)) {
-		spin_unlock(&iommu->lock);
-		return -EBUSY;
-	}
 
+	spin_lock(&iommu->lock);
 	pasid_clear_entry(pte);
 
 	if (s1_cfg->addr_width == ADDR_WIDTH_5LEVEL)
-- 
2.34.1


