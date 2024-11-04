Return-Path: <kvm+bounces-30513-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BBFC9BB5AA
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 14:19:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 42904B2277B
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 13:19:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8F00339A1;
	Mon,  4 Nov 2024 13:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Qq6TohRE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 736D029CFB
	for <kvm@vger.kernel.org>; Mon,  4 Nov 2024 13:18:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730726334; cv=none; b=b4rMRdtpQ+Um2B1BkuDCGgQpD5HiQ7hJxhzDeP9RyhOhIbk67YCV/OyapuBo+7LqG/DDUCrRyiafzvlQKIgz/R9BGp2I3zHEAx09oftxEdmtPIlFzgNW6eAhn0L1OIaNPBcHXoMOr+MqIdxfcc2kiN8eB0KY81vqbDJp3gtTTlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730726334; c=relaxed/simple;
	bh=j/IFtYN3cPWcqNL6sXKNCbElO9HTUKg9WYrf5ddq7M0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TjZzVOD39b6cUyvbEkGUD/N9hgn546ajG4LRc9AoTA5AEUIxpu2PTaJ/LgP8WoaNXop633sQnz+w7TF3TGIQyqlmOTDyh/7Yjz4Fdkiqg5pmeaAOpIduU6xFo4LGlzfqdOvo3NWqpnRoXlkZbDVT8QI2eVRZTXbKTp06YdbM8yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Qq6TohRE; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730726333; x=1762262333;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=j/IFtYN3cPWcqNL6sXKNCbElO9HTUKg9WYrf5ddq7M0=;
  b=Qq6TohREoBNU6hMS+TIa377tAQRWvSK1lANlW8TQfqly5x3S3nr00cpd
   KlpD/R4SpjjdVnUxBnEN72Bz8CK2eSOIO8FnNrNvb471YLQBog7r9otpb
   dDP5e/3bZ1z7O5NzHW7/j7FTxioezdIwsHuQRLLxLjoDw+2Y75MhcyOdX
   IrdOhbAtRgmVOaVoFSv4fCmdwKdQZzszFu8C8h8fOkrAe+4PWHvEu7xaO
   zQi9x6Iq5L03idm+6HtDt7nH/YQYB3UfJD9mtfoGs4xuoECdnlFcm7sfz
   j3nOyN5KntPmmxzE6kwvkuo0aDW1/7fdF9A8agAgJXEjk6WLHgnerrBhq
   w==;
X-CSE-ConnectionGUID: AMB//GQ7Sv+oNrA9KXnzPA==
X-CSE-MsgGUID: e7i8eeDmQgub05lKqPFd0A==
X-IronPort-AV: E=McAfee;i="6700,10204,11246"; a="41003740"
X-IronPort-AV: E=Sophos;i="6.11,257,1725346800"; 
   d="scan'208";a="41003740"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 05:18:53 -0800
X-CSE-ConnectionGUID: dCAG9n6ZSjqhhukvvjOCYQ==
X-CSE-MsgGUID: 9wzkUz/4TYmFkWaYAOw6AA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,257,1725346800"; 
   d="scan'208";a="83999494"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmviesa010.fm.intel.com with ESMTP; 04 Nov 2024 05:18:49 -0800
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
Subject: [PATCH v4 06/13] iommu/vt-d: Make intel_iommu_set_dev_pasid() to handle domain replacement
Date: Mon,  4 Nov 2024 05:18:35 -0800
Message-Id: <20241104131842.13303-7-yi.l.liu@intel.com>
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

Let intel_iommu_set_dev_pasid() call the pasid replace helpers hence be
able to do domain replacement.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/iommu/intel/iommu.c | 17 +++++++++++------
 drivers/iommu/intel/pasid.h | 11 +++++++++++
 2 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 6bc5ce03c6f5..29a3d9de109c 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -1908,7 +1908,7 @@ static void domain_context_clear_one(struct device_domain_info *info, u8 bus, u8
 static int domain_setup_first_level(struct intel_iommu *iommu,
 				    struct dmar_domain *domain,
 				    struct device *dev,
-				    u32 pasid)
+				    u32 pasid, struct iommu_domain *old)
 {
 	struct dma_pte *pgd = domain->pgd;
 	int agaw, level;
@@ -1934,6 +1934,11 @@ static int domain_setup_first_level(struct intel_iommu *iommu,
 	if (domain->force_snooping)
 		flags |= PASID_FLAG_PAGE_SNOOP;
 
+	if (old)
+		return intel_pasid_replace_first_level(iommu, dev,
+							  (pgd_t *)pgd, pasid,
+							  domain_id_iommu(domain, iommu),
+							  flags);
 	return intel_pasid_setup_first_level(iommu, dev, (pgd_t *)pgd, pasid,
 					     domain_id_iommu(domain, iommu),
 					     flags);
@@ -1968,9 +1973,9 @@ static int dmar_domain_attach_device(struct dmar_domain *domain,
 	if (!sm_supported(iommu))
 		ret = domain_context_mapping(domain, dev);
 	else if (domain->use_first_level)
-		ret = domain_setup_first_level(iommu, domain, dev, IOMMU_NO_PASID);
+		ret = domain_setup_first_level(iommu, domain, dev, IOMMU_NO_PASID, NULL);
 	else
-		ret = intel_pasid_setup_second_level(iommu, domain, dev, IOMMU_NO_PASID);
+		ret = domain_setup_second_level(iommu, domain, dev, IOMMU_NO_PASID, NULL);
 
 	if (ret)
 		goto out_block_translation;
@@ -4363,10 +4368,10 @@ static int intel_iommu_set_dev_pasid(struct iommu_domain *domain,
 
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
 
diff --git a/drivers/iommu/intel/pasid.h b/drivers/iommu/intel/pasid.h
index 228938f3be51..3f82f69a7bce 100644
--- a/drivers/iommu/intel/pasid.h
+++ b/drivers/iommu/intel/pasid.h
@@ -315,6 +315,17 @@ int intel_pasid_replace_nested(struct intel_iommu *iommu,
 			       struct device *dev, u32 pasid,
 			       struct dmar_domain *domain);
 
+static inline int domain_setup_second_level(struct intel_iommu *iommu,
+					    struct dmar_domain *domain,
+					    struct device *dev, ioasid_t pasid,
+					    struct iommu_domain *old)
+{
+	if (old)
+		return intel_pasid_replace_second_level(iommu, domain,
+							dev, pasid);
+	return intel_pasid_setup_second_level(iommu, domain, dev, pasid);
+}
+
 void intel_pasid_tear_down_entry(struct intel_iommu *iommu,
 				 struct device *dev, u32 pasid,
 				 bool fault_ignore);
-- 
2.34.1


