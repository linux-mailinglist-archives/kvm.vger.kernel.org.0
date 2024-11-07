Return-Path: <kvm+bounces-31108-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B11F89C05A2
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 13:23:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E2CE51C21E89
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 12:23:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 447B621216A;
	Thu,  7 Nov 2024 12:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="W0B2ulZd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF98C210180
	for <kvm@vger.kernel.org>; Thu,  7 Nov 2024 12:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730982164; cv=none; b=iJP666oRWRb/NbzYXUnhwiKVz5gWhx9nsDj79Ao77sHY1Nu81PNcpN/OrndaLHGzVgAes5g8NDJwmBKR3rjoadwXlnqGe70kFQxqnvA1GrIvIbm7A+MsNa3GQ19MyOov9OklHc7r8F77xHp3AJDNyyr4qMiMDulzPo3U9VAWHZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730982164; c=relaxed/simple;
	bh=eN1brumGZm1DOEHRsvSaTj1vMJ7Ez8a6+p6iWljH5ac=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ot9A5cs3IqyBq0Tt659cPBQo7048yGhuc8O33OlWZVedrmActdDlVdnBDqfPLYC6563DxjEdTQqLn95O0aDOZ0toGZgMHgXtMv/aYi+hRggJmOB2cB+z7qcGx0JNifaE1Ll6wFDRCGbGxtOOzSs73omAlUzsDdGrhztxD9DvW3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=W0B2ulZd; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730982162; x=1762518162;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eN1brumGZm1DOEHRsvSaTj1vMJ7Ez8a6+p6iWljH5ac=;
  b=W0B2ulZd7ao2kJhO3fh0QY84barI+dG+VP/qLDd0NA9ICeILLQ+L1fTV
   U/VwirMKu+Lv5fbYlVklUQ/50f+YzdIwxrUMTkHQ6qi4zdboX9WtTc5PC
   tWP8QDy3+B7/I8eqNw4HMDnCD5Vp7ycW1u4qvjvn4Fa50FD/9hX37BT4e
   MNIx9HIwTHikNTuxI89eT4tTo/eUz37lLISM6105oSanRzhthlxmGgJKT
   BsDgSBY5IdfzXoia8Vx4xy5QnX2zlKzYB771yKT7NwH0SF51uxAJK692f
   NJwPFvh1UUxPAnWEI1y6Mx8HchpuISimz5KQwQy7lS1hb3Cz8luuW8EtZ
   w==;
X-CSE-ConnectionGUID: E1UQXF6oR7CmBsvwUuAPMg==
X-CSE-MsgGUID: PAp7ehLITGS5q09ZM9MZgw==
X-IronPort-AV: E=McAfee;i="6700,10204,11249"; a="34744646"
X-IronPort-AV: E=Sophos;i="6.12,265,1728975600"; 
   d="scan'208";a="34744646"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2024 04:22:40 -0800
X-CSE-ConnectionGUID: Z5LRhY+9RWKaAiOTCaOfug==
X-CSE-MsgGUID: kgrfU8pSS+SNokB0q93yJg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,265,1728975600"; 
   d="scan'208";a="90180596"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orviesa004.jf.intel.com with ESMTP; 07 Nov 2024 04:22:41 -0800
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
Subject: [PATCH v6 09/13] iommu/vt-d: Make intel_svm_set_dev_pasid() support domain replacement
Date: Thu,  7 Nov 2024 04:22:30 -0800
Message-Id: <20241107122234.7424-10-yi.l.liu@intel.com>
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


