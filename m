Return-Path: <kvm+bounces-30981-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 352589BF214
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 16:48:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 75D38B25354
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 15:48:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0050A207A3A;
	Wed,  6 Nov 2024 15:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DRdyfCyQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32A21206E87
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 15:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730907976; cv=none; b=B/iHT2TMkkf5goUF39AEDvozhTWGI3lbjoyAuYk1TKTawnnFGz9Nms7LbzrUigcB+Y1QMYRSoHho/7swOWvBG7Gj4VJX01L6DYRQyzJm1VRkb7SJGFutzAHwVhKFPRRzWcAA1v2T5fRKRoG3HWCPBz6j44u5/f8Z92T1UWoJ4rs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730907976; c=relaxed/simple;
	bh=TE0EXri3MvlR5MFyARkMwD0LsdIOzK7qr275C2hDmQs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Ow4w0VWOfoq11d0KZ+6L7G6vG73UJaCtcorsxlzGpapsJIOxJ3ZjzThSio/oZ+SKyC64AzzHvVx+RWlEuNwdjenYPRu0WFkOXW90A3uxCzEZ4oahOuGwl1YyOj7oJFI8OFsEQcWQrNmYL1m7THpkF+wVOeRzTXOt2YRQMKLvHpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DRdyfCyQ; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730907975; x=1762443975;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TE0EXri3MvlR5MFyARkMwD0LsdIOzK7qr275C2hDmQs=;
  b=DRdyfCyQbIlplM6ZV3Q+AetzNwfmWV0JBlAoaCyPN0mC2aPH0vGoHSue
   zmOffZ+y6aSA3HytkL8oWTL67ewo9u1SGT2ozcMNatO1YES43baadYO+E
   ceLvHXYcN6q6D6qvXLYyYf/JCWQK84iWDTJ4wdoKcheiDxxGafTp6FHxu
   QqSHtYnUPX5Y9YgcYaGLk2ck6OnTuzun60fRVHJjypyS091QvNKoIRq+1
   XJtFz5uCTg7FXxV+jT+QkepMTzdXldZk2exJ4Kq9y0yXNd0wLXyQNidCO
   DKm9B+UmYgiwglIz9H3WU67h8I4Pr40aMUMmE24SOC16EYB0MRObCB76s
   A==;
X-CSE-ConnectionGUID: GhPvBN21Q7yHY5pI1is49Q==
X-CSE-MsgGUID: FCgz0FigQTuaOIAMnLGaNQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="48174260"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="48174260"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2024 07:46:11 -0800
X-CSE-ConnectionGUID: ctgje85jQcukxEeHgilCZA==
X-CSE-MsgGUID: nohJWA6WRueq+WMsqCQaNw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,263,1725346800"; 
   d="scan'208";a="89468233"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orviesa005.jf.intel.com with ESMTP; 06 Nov 2024 07:46:11 -0800
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
Subject: [PATCH v5 07/13] iommu/vt-d: Make intel_iommu_set_dev_pasid() to handle domain replacement
Date: Wed,  6 Nov 2024 07:46:00 -0800
Message-Id: <20241106154606.9564-8-yi.l.liu@intel.com>
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


