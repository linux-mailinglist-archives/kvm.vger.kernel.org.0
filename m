Return-Path: <kvm+bounces-20644-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 01F4891BA7B
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 10:56:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2C4FF1C22541
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 08:56:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F1CB150997;
	Fri, 28 Jun 2024 08:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="C65vqCX2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CD6914EC60
	for <kvm@vger.kernel.org>; Fri, 28 Jun 2024 08:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719564945; cv=none; b=RVx6oRIDZ+DnkuC1utrz8J1UyRa4/hKUdtJhN5wPE+ZlEO41w7/2RHKBh2DDdTA3lT9ekMc3QWBZ+Ej2eJ2yTJB918fGknsXIeYCn3yN0cEuT65P7ofHVX4vsMvxI+o4kk/a5Vi0mRsbAQVvtzFBxknsDR0VGXvrD9UNjoFBPeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719564945; c=relaxed/simple;
	bh=WECR+t3WhJT0cBqX1JQoZlytxxXaOwNd/piXWNJC30w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZZ6ft1PROwvkejtXLUR/SL0fxk1opwQKS0v9gbvU1C7u0HOS4BtOf8IWoYgGpFKA5UlvBkSc04X2avzC+RjL7ycfjvy0qvQlRCGzI8H+BSTwlMEfLQsqYxl9xXWvjSQAnGVfRjPn1tehiGtqPaPVndz0Ys462hZlwtHDl/J51EY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=C65vqCX2; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719564944; x=1751100944;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WECR+t3WhJT0cBqX1JQoZlytxxXaOwNd/piXWNJC30w=;
  b=C65vqCX24oGCu8q6m7/wJX4xdzf9kjVODgnb/3+6sDWD/w8YJyrcNA2F
   Dds+jAu73hMgQskcosEsmdxiFXbWUH0iBiWWv4ehBI3fL/6WBy/2+Nu77
   gTfOn99m3GvI0RPp/On2eD7p9/7MJsjB1+PeSlldJdJ92LR2u6BqMp2mW
   MNxmP8OS3jLmHxPmBq7k9LnKf0abvOlrtVeRqcSzhEo/8gSG493zQrYx3
   0fPsDiEdXs1tMZAGXAwUoFm8PGd2FMqUADCWR3yI1g8hhk4OJFJp3PCZQ
   Jl3HGqN/X2v77LMLMaasR9RFtg5sOxE4+1scwtRgLU3IZM96SyEytXe7p
   A==;
X-CSE-ConnectionGUID: OzUAF3TsQXKDnaqBrF5OPA==
X-CSE-MsgGUID: 9aCk013rS8Guf0sxLr4P4g==
X-IronPort-AV: E=McAfee;i="6700,10204,11116"; a="34277496"
X-IronPort-AV: E=Sophos;i="6.09,168,1716274800"; 
   d="scan'208";a="34277496"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2024 01:55:42 -0700
X-CSE-ConnectionGUID: 9X7rN3uDT0i19Qd4iS83Kg==
X-CSE-MsgGUID: edarF2NlR62RyXUgx2aPDA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,168,1716274800"; 
   d="scan'208";a="44584533"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orviesa010.jf.intel.com with ESMTP; 28 Jun 2024 01:55:43 -0700
From: Yi Liu <yi.l.liu@intel.com>
To: joro@8bytes.org,
	jgg@nvidia.com,
	kevin.tian@intel.com,
	baolu.lu@linux.intel.com
Cc: alex.williamson@redhat.com,
	robin.murphy@arm.com,
	eric.auger@redhat.com,
	nicolinc@nvidia.com,
	kvm@vger.kernel.org,
	chao.p.peng@linux.intel.com,
	yi.l.liu@intel.com,
	iommu@lists.linux.dev
Subject: [PATCH 3/6] iommu/vt-d: Make helpers support modifying present pasid entry
Date: Fri, 28 Jun 2024 01:55:35 -0700
Message-Id: <20240628085538.47049-4-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240628085538.47049-1-yi.l.liu@intel.com>
References: <20240628085538.47049-1-yi.l.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

To handle domain replacement, set_dev_pasid op needs to modify a present
pasid entry. One way is sharing the most logics of remove_dev_pasid() in
the beginning of set_dev_pasid() to remove the old config. But this means
the set_dev_pasid path needs to rollback to the old config if it fails to
set up the new pasid entry. This needs to invoke the set_dev_pasid op of
the old domain. It breaks the iommu layering a bit. Another way is
implementing the set_dev_pasid() without rollback to old hardware config.
This can be achieved by implementing it in the order of preparing the
dev_pasid info for the new domain, modify the pasid entry, then undo the
dev_pasid info of the old domain, and if failed, undo the dev_pasid info
of the new domain. This would keep the old domain unchanged.

Following the second way, needs to make the pasid entry set up helpers
support modifying present pasid entry.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/iommu/intel/pasid.c | 37 ++++++++++++-------------------------
 1 file changed, 12 insertions(+), 25 deletions(-)

diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/pasid.c
index b18eebb479de..5d3a12b081a2 100644
--- a/drivers/iommu/intel/pasid.c
+++ b/drivers/iommu/intel/pasid.c
@@ -314,6 +314,9 @@ int intel_pasid_setup_first_level(struct intel_iommu *iommu,
 		return -EINVAL;
 	}
 
+	/* Clear the old configuration if it already exists */
+	intel_pasid_tear_down_entry(iommu, dev, pasid, false, true);
+
 	spin_lock(&iommu->lock);
 	pte = intel_pasid_get_entry(dev, pasid);
 	if (!pte) {
@@ -321,13 +324,6 @@ int intel_pasid_setup_first_level(struct intel_iommu *iommu,
 		return -ENODEV;
 	}
 
-	if (pasid_pte_is_present(pte)) {
-		spin_unlock(&iommu->lock);
-		return -EBUSY;
-	}
-
-	pasid_clear_entry(pte);
-
 	/* Setup the first level page table pointer: */
 	pasid_set_flptr(pte, (u64)__pa(pgd));
 
@@ -378,6 +374,9 @@ int intel_pasid_setup_second_level(struct intel_iommu *iommu,
 	pgd_val = virt_to_phys(pgd);
 	did = domain_id_iommu(domain, iommu);
 
+	/* Clear the old configuration if it already exists */
+	intel_pasid_tear_down_entry(iommu, dev, pasid, false, true);
+
 	spin_lock(&iommu->lock);
 	pte = intel_pasid_get_entry(dev, pasid);
 	if (!pte) {
@@ -385,12 +384,6 @@ int intel_pasid_setup_second_level(struct intel_iommu *iommu,
 		return -ENODEV;
 	}
 
-	if (pasid_pte_is_present(pte)) {
-		spin_unlock(&iommu->lock);
-		return -EBUSY;
-	}
-
-	pasid_clear_entry(pte);
 	pasid_set_domain_id(pte, did);
 	pasid_set_slptr(pte, pgd_val);
 	pasid_set_address_width(pte, domain->agaw);
@@ -488,6 +481,9 @@ int intel_pasid_setup_pass_through(struct intel_iommu *iommu,
 	u16 did = FLPT_DEFAULT_DID;
 	struct pasid_entry *pte;
 
+	/* Clear the old configuration if it already exists */
+	intel_pasid_tear_down_entry(iommu, dev, pasid, false, true);
+
 	spin_lock(&iommu->lock);
 	pte = intel_pasid_get_entry(dev, pasid);
 	if (!pte) {
@@ -495,12 +491,6 @@ int intel_pasid_setup_pass_through(struct intel_iommu *iommu,
 		return -ENODEV;
 	}
 
-	if (pasid_pte_is_present(pte)) {
-		spin_unlock(&iommu->lock);
-		return -EBUSY;
-	}
-
-	pasid_clear_entry(pte);
 	pasid_set_domain_id(pte, did);
 	pasid_set_address_width(pte, iommu->agaw);
 	pasid_set_translation_type(pte, PASID_ENTRY_PGTT_PT);
@@ -606,18 +596,15 @@ int intel_pasid_setup_nested(struct intel_iommu *iommu, struct device *dev,
 		return -EINVAL;
 	}
 
+	/* Clear the old configuration if it already exists */
+	intel_pasid_tear_down_entry(iommu, dev, pasid, false, true);
+
 	spin_lock(&iommu->lock);
 	pte = intel_pasid_get_entry(dev, pasid);
 	if (!pte) {
 		spin_unlock(&iommu->lock);
 		return -ENODEV;
 	}
-	if (pasid_pte_is_present(pte)) {
-		spin_unlock(&iommu->lock);
-		return -EBUSY;
-	}
-
-	pasid_clear_entry(pte);
 
 	if (s1_cfg->addr_width == ADDR_WIDTH_5LEVEL)
 		pasid_set_flpm(pte, 1);
-- 
2.34.1


