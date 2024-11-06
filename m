Return-Path: <kvm+bounces-30983-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5EB359BF216
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 16:48:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E21B61F23C9D
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 15:48:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96D8D20821C;
	Wed,  6 Nov 2024 15:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AGJqTnq/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16E0C2076AA
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 15:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730907977; cv=none; b=VjBxfy9OFL6HHVqAhQvbAGAiTT7Az9DLVVpJd/i79FKNM6rI6OIPuiYiMyRspjgy+5zfZpBGdIKORW8Ej3wW/NrHPBORaNXZoCe91G9X/H9RhvSf8kUN3mIlhCEH2fZ/3qQjheZ5a0K3Vz3CAE3mgjBF9XXps37SIa9SEGJJTas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730907977; c=relaxed/simple;
	bh=eN1brumGZm1DOEHRsvSaTj1vMJ7Ez8a6+p6iWljH5ac=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FOIQZpimIbFt9AUYvfQ51E+47HTzX03pj7xPVnUNZljK4xuAZxjkeEQ1XGkbXodOPZ3Y/0bEI8s6OBOIUPeqzYst75f7HLfh41Ygyi1FjpSCZDMeKRbqj7KeRgv+ORgnH+/qf+vPB2QJ8KpJKbAOgu1SRqjcMQeP8A+VKAsBdvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AGJqTnq/; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730907976; x=1762443976;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eN1brumGZm1DOEHRsvSaTj1vMJ7Ez8a6+p6iWljH5ac=;
  b=AGJqTnq/nkYvoLl8oUcqY+2abQxveAK9EUV9N0UJ2QoyUiYarBdJx8PC
   sTGhVHCPr7VNVvXoBqTdlVDU2ZRaef9FPRQ1okYTvO34NmA7XraLs1wIj
   fEJdUVLik2l5RaRzyhVoRL0HX6Zqjxj9V1DznynpAWMhTdCZ2ZpOW0cqj
   a290r4K1ELV2BM2yGQlnZIhw2RFjAIKHbo0PGYpqSZ5xvFoKa1Yszs4Pe
   tSSAsvpitMb3E94XsLsSav7Ycwv2kKY2DOJ4eaxaqzSOukuv1cxNK6vgb
   C0vk/EXlN7FsCxDpPxHcMOdQLHqnDOT8gA4pjlz1WMjufR1xZvPoNkPNR
   w==;
X-CSE-ConnectionGUID: +KBrFEVQR1SRZjTZTNNQMg==
X-CSE-MsgGUID: wNPOHO/LSMekNh14Mq2BgQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="48174276"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="48174276"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2024 07:46:11 -0800
X-CSE-ConnectionGUID: 92EqyUk0RYCs1jDvWazIbw==
X-CSE-MsgGUID: iAcFbbohRfuwqorbLWFQQA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,263,1725346800"; 
   d="scan'208";a="89468245"
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
Subject: [PATCH v5 09/13] iommu/vt-d: Make intel_svm_set_dev_pasid() support domain replacement
Date: Wed,  6 Nov 2024 07:46:02 -0800
Message-Id: <20241106154606.9564-10-yi.l.liu@intel.com>
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

Make intel_svm_set_dev_pasid() support replacement.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/iommu/intel/iommu.c | 8 ++++----
 drivers/iommu/intel/iommu.h | 5 +++++
 drivers/iommu/intel/svm.c   | 5 +++--
 3 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 3c1b92fa5877..06a7c4bf31e0 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -1752,10 +1752,10 @@ static void domain_context_clear_one(struct device_domain_info *info, u8 bus, u8
 	intel_context_flush_present(info, context, did, true);
 }
 
-static int __domain_setup_first_level(struct intel_iommu *iommu,
-				      struct device *dev, ioasid_t pasid,
-				      u16 did, pgd_t *pgd, int flags,
-				      struct iommu_domain *old)
+int __domain_setup_first_level(struct intel_iommu *iommu,
+			       struct device *dev, ioasid_t pasid,
+			       u16 did, pgd_t *pgd, int flags,
+			       struct iommu_domain *old)
 {
 	if (!old)
 		return intel_pasid_setup_first_level(iommu, dev, pgd,
diff --git a/drivers/iommu/intel/iommu.h b/drivers/iommu/intel/iommu.h
index cdca7d5061a7..d23977cc7d90 100644
--- a/drivers/iommu/intel/iommu.h
+++ b/drivers/iommu/intel/iommu.h
@@ -1250,6 +1250,11 @@ domain_add_dev_pasid(struct iommu_domain *domain,
 void domain_remove_dev_pasid(struct iommu_domain *domain,
 			     struct device *dev, ioasid_t pasid);
 
+int __domain_setup_first_level(struct intel_iommu *iommu,
+			       struct device *dev, ioasid_t pasid,
+			       u16 did, pgd_t *pgd, int flags,
+			       struct iommu_domain *old);
+
 int dmar_ir_support(void);
 
 void iommu_flush_write_buffer(struct intel_iommu *iommu);
diff --git a/drivers/iommu/intel/svm.c b/drivers/iommu/intel/svm.c
index 6c0685ea8466..f5569347591f 100644
--- a/drivers/iommu/intel/svm.c
+++ b/drivers/iommu/intel/svm.c
@@ -127,8 +127,9 @@ static int intel_svm_set_dev_pasid(struct iommu_domain *domain,
 
 	/* Setup the pasid table: */
 	sflags = cpu_feature_enabled(X86_FEATURE_LA57) ? PASID_FLAG_FL5LP : 0;
-	ret = intel_pasid_setup_first_level(iommu, dev, mm->pgd, pasid,
-					    FLPT_DEFAULT_DID, sflags);
+	ret = __domain_setup_first_level(iommu, dev, pasid,
+					 FLPT_DEFAULT_DID, mm->pgd,
+					 sflags, old);
 	if (ret)
 		goto out_remove_dev_pasid;
 
-- 
2.34.1


