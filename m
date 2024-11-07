Return-Path: <kvm+bounces-31106-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D700F9C05A1
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 13:23:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9E0C22840C0
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 12:23:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D53A62101BC;
	Thu,  7 Nov 2024 12:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="S+11C/UG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42BEC20FAB3
	for <kvm@vger.kernel.org>; Thu,  7 Nov 2024 12:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730982163; cv=none; b=LjZK5uolsHca+SkaeRgxXMZRvgzoz8H/8bG0L2QyUgsWcOBo/syCZvYVQkTHsYpAZ9QfKN/1KH/wtKGJJXPf/1uKQhmSDMAux+qw3+YwHe7wVTMxD7oS2foidAqMQnj4vv5i73U4+upiqEPIzMunuV1Uivc9La0hHOQJpJP5Wxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730982163; c=relaxed/simple;
	bh=TE0EXri3MvlR5MFyARkMwD0LsdIOzK7qr275C2hDmQs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OlzxVtl/8z1lXaH5hdgez8eMi/MUNYTd0q3QtMsq9MsWNYrUb2FOyydahZLA0AgRGc/GcOrzSK3JkM2pK4gFYh+QjyGM/Fn6wGjrCBd4BjZB0T/2/JHKbk0QL65I+XLMbVFuFogXcUCx/jnHCb+CYjRLdDbMYQ2ARNjZBFMzqiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=S+11C/UG; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730982162; x=1762518162;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TE0EXri3MvlR5MFyARkMwD0LsdIOzK7qr275C2hDmQs=;
  b=S+11C/UGy3u+bQ2LUS1NsBT0rmrQjJWw3NOX+xSFHlLahGoxOU61wdVq
   71dTHEi3TJA5H8MEktjlWtSHJVdmXk6EWiN629kNs73swPEvqhn9a6+8/
   kbQ/FHh9hMROtRQoWkaCEgoQW/Gb+s0gicrzXzKwdz3OB3v6UVrsGVWSd
   KqCTWTyw7uIlX5Z2RZtB8Db8FQRtPYnWbGoyhLqHbisXvdt5PE6jXBeLB
   sj7hp505gRQttPCvQjuLf6vyds6VNQreIF9NrW67LD7CkcpVqQJzZ6HIL
   x8qIydS35BxUB/HCeYoauR51YE6fchBkXqqY+7wqrXby5wDYnlAHPg0pk
   w==;
X-CSE-ConnectionGUID: Asqqv/FaSaKBCnDas7YO4A==
X-CSE-MsgGUID: 0s/WpftVT/i1wPHimhu4qw==
X-IronPort-AV: E=McAfee;i="6700,10204,11249"; a="34744627"
X-IronPort-AV: E=Sophos;i="6.12,265,1728975600"; 
   d="scan'208";a="34744627"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2024 04:22:39 -0800
X-CSE-ConnectionGUID: ln6S6OkdSFaawu46lRK7Vw==
X-CSE-MsgGUID: UUkot5GjSw6SsgD/gyp6qg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,265,1728975600"; 
   d="scan'208";a="90180585"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orviesa004.jf.intel.com with ESMTP; 07 Nov 2024 04:22:40 -0800
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
Subject: [PATCH v6 07/13] iommu/vt-d: Make intel_iommu_set_dev_pasid() to handle domain replacement
Date: Thu,  7 Nov 2024 04:22:28 -0800
Message-Id: <20241107122234.7424-8-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241107122234.7424-1-yi.l.liu@intel.com>
References: <20241107122234.7424-1-yi.l.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Let intel_iommu_set_dev_pasid() call the pasid replace helpers hence be
able to do domain replacement.

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/iommu/intel/iommu.c | 46 +++++++++++++++++++++++++++++--------
 1 file changed, 37 insertions(+), 9 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index a1e9dbca6561..6b7f48119502 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -1752,10 +1752,36 @@ static void domain_context_clear_one(struct device_domain_info *info, u8 bus, u8
 	intel_context_flush_present(info, context, did, true);
 }
 
+static int __domain_setup_first_level(struct intel_iommu *iommu,
+				      struct device *dev, ioasid_t pasid,
+				      u16 did, pgd_t *pgd, int flags,
+				      struct iommu_domain *old)
+{
+	if (!old)
+		return intel_pasid_setup_first_level(iommu, dev, pgd,
+						     pasid, did, flags);
+	return intel_pasid_replace_first_level(iommu, dev, pgd, pasid, did,
+					       iommu_domain_did(old, iommu),
+					       flags);
+}
+
+static int domain_setup_second_level(struct intel_iommu *iommu,
+				     struct dmar_domain *domain,
+				     struct device *dev, ioasid_t pasid,
+				     struct iommu_domain *old)
+{
+	if (!old)
+		return intel_pasid_setup_second_level(iommu, domain,
+						      dev, pasid);
+	return intel_pasid_replace_second_level(iommu, domain, dev,
+						iommu_domain_did(old, iommu),
+						pasid);
+}
+
 static int domain_setup_first_level(struct intel_iommu *iommu,
 				    struct dmar_domain *domain,
 				    struct device *dev,
-				    u32 pasid)
+				    u32 pasid, struct iommu_domain *old)
 {
 	struct dma_pte *pgd = domain->pgd;
 	int level, flags = 0;
@@ -1770,9 +1796,9 @@ static int domain_setup_first_level(struct intel_iommu *iommu,
 	if (domain->force_snooping)
 		flags |= PASID_FLAG_PAGE_SNOOP;
 
-	return intel_pasid_setup_first_level(iommu, dev, (pgd_t *)pgd, pasid,
-					     domain_id_iommu(domain, iommu),
-					     flags);
+	return __domain_setup_first_level(iommu, dev, pasid,
+					  domain_id_iommu(domain, iommu),
+					  (pgd_t *)pgd, flags, old);
 }
 
 static bool dev_is_real_dma_subdevice(struct device *dev)
@@ -1804,9 +1830,11 @@ static int dmar_domain_attach_device(struct dmar_domain *domain,
 	if (!sm_supported(iommu))
 		ret = domain_context_mapping(domain, dev);
 	else if (domain->use_first_level)
-		ret = domain_setup_first_level(iommu, domain, dev, IOMMU_NO_PASID);
+		ret = domain_setup_first_level(iommu, domain, dev,
+					       IOMMU_NO_PASID, NULL);
 	else
-		ret = intel_pasid_setup_second_level(iommu, domain, dev, IOMMU_NO_PASID);
+		ret = domain_setup_second_level(iommu, domain, dev,
+						IOMMU_NO_PASID, NULL);
 
 	if (ret)
 		goto out_block_translation;
@@ -4147,10 +4175,10 @@ static int intel_iommu_set_dev_pasid(struct iommu_domain *domain,
 
 	if (dmar_domain->use_first_level)
 		ret = domain_setup_first_level(iommu, dmar_domain,
-					       dev, pasid);
+					       dev, pasid, old);
 	else
-		ret = intel_pasid_setup_second_level(iommu, dmar_domain,
-						     dev, pasid);
+		ret = domain_setup_second_level(iommu, dmar_domain,
+						dev, pasid, old);
 	if (ret)
 		goto out_remove_dev_pasid;
 
-- 
2.34.1


