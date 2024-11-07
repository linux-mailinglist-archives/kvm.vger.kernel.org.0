Return-Path: <kvm+bounces-31100-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BB21D9C059A
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 13:22:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 474981F237E2
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 12:22:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCEB720FA95;
	Thu,  7 Nov 2024 12:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cGD/8/xk"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E987F1F4708
	for <kvm@vger.kernel.org>; Thu,  7 Nov 2024 12:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730982160; cv=none; b=lS65TBWKz6fXuEKNRUP23uL4v0CsIWlYOMLJ987XY6DROVn7J9NX6f2IRZPNqTLbvXSrshu1rWxeuzHH59DlE3xd5biW/AlYC9l95whoYu4K5YJQyMH7gH44gNB1yEb/ogNBZh5d2aRVQbC33dAjdL2FalTvIOyjpVDbxpAmguI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730982160; c=relaxed/simple;
	bh=PID8oWvO+CFTF9qbbcIthacYaug1t+ww1apSwKWA758=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=eSh8nr9lO4cRaHbLPHDrm/bKgsTmULEm4Av0fWsQ8j1y7scup1Ml3r1/NnM2iT2Ly6p0bLdYPw7GSFO4WVuzYCJFI33HZnAvqKuxE1l8qB3wdoVRa47HY7bnrYM9vdyIMCTQzWBX6IFc/D4wK4kkApjDhqBHz/pDU8/FbfzUq6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cGD/8/xk; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730982158; x=1762518158;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PID8oWvO+CFTF9qbbcIthacYaug1t+ww1apSwKWA758=;
  b=cGD/8/xk/cm+6KBZ5Cnle2hndzAZLgHQMCfYr2XUIVmXPyPVAlz103nz
   bv3WcQqmuOEU16X85opth1CXaGSTsZEXvrChY0jJzX2mj2k9i/fuAl9NZ
   B1dfYhklMYc/kO9TOel5LFdxsT8I0Z5onIwnkQT/YZkSjFRbKMDb1JcNK
   NYBzc8Gz+SYR1W1FKZtlxjmK3zwg5vn9RNPUi+eYfgT+Bp+AWzR3FKMoz
   XmW9h2dOiDPy5tzP8XtolPIft6EGWuGu+6U5I0o9mTdlADsrRtr9lAXhN
   iWoQOzuJQnX80Rw6Kdk/GKNurmqCYo4q00DPW8qI0F9qR7gVf49WMo9jJ
   Q==;
X-CSE-ConnectionGUID: jxQObNmKT/uilcgPaZtIjA==
X-CSE-MsgGUID: bgbfROrdTz+UAPrAxTpJ9g==
X-IronPort-AV: E=McAfee;i="6700,10204,11249"; a="34744572"
X-IronPort-AV: E=Sophos;i="6.12,265,1728975600"; 
   d="scan'208";a="34744572"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2024 04:22:36 -0800
X-CSE-ConnectionGUID: 0PIKCtsOQ4Gu1faqPkIoSA==
X-CSE-MsgGUID: jgIdHLwyTHOoVarNkTmAYw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,265,1728975600"; 
   d="scan'208";a="90180545"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orviesa004.jf.intel.com with ESMTP; 07 Nov 2024 04:22:37 -0800
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
Subject: [PATCH v6 01/13] iommu: Pass old domain to set_dev_pasid op
Date: Thu,  7 Nov 2024 04:22:22 -0800
Message-Id: <20241107122234.7424-2-yi.l.liu@intel.com>
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

To support domain replacement for pasid, the underlying iommu driver needs
to know the old domain hence be able to clean up the existing attachment.
It would be much convenient for iommu layer to pass down the old domain.
Otherwise, iommu drivers would need to track domain for pasids by themselves,
this would duplicate code among the iommu drivers. Or iommu drivers would
rely group->pasid_array to get domain, which may not always the correct
one.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/iommu/amd/amd_iommu.h                   | 3 ++-
 drivers/iommu/amd/pasid.c                       | 3 ++-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c | 3 ++-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c     | 3 ++-
 drivers/iommu/intel/iommu.c                     | 6 ++++--
 drivers/iommu/intel/svm.c                       | 3 ++-
 drivers/iommu/iommu.c                           | 3 ++-
 include/linux/iommu.h                           | 2 +-
 8 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/drivers/iommu/amd/amd_iommu.h b/drivers/iommu/amd/amd_iommu.h
index 38509e1019e9..1bef5d55b2f9 100644
--- a/drivers/iommu/amd/amd_iommu.h
+++ b/drivers/iommu/amd/amd_iommu.h
@@ -53,7 +53,8 @@ struct iommu_domain *amd_iommu_domain_alloc_sva(struct device *dev,
 						struct mm_struct *mm);
 void amd_iommu_domain_free(struct iommu_domain *dom);
 int iommu_sva_set_dev_pasid(struct iommu_domain *domain,
-			    struct device *dev, ioasid_t pasid);
+			    struct device *dev, ioasid_t pasid,
+			    struct iommu_domain *old);
 void amd_iommu_remove_dev_pasid(struct device *dev, ioasid_t pasid,
 				struct iommu_domain *domain);
 
diff --git a/drivers/iommu/amd/pasid.c b/drivers/iommu/amd/pasid.c
index 0657b9373be5..d1dfc745f55e 100644
--- a/drivers/iommu/amd/pasid.c
+++ b/drivers/iommu/amd/pasid.c
@@ -100,7 +100,8 @@ static const struct mmu_notifier_ops sva_mn = {
 };
 
 int iommu_sva_set_dev_pasid(struct iommu_domain *domain,
-			    struct device *dev, ioasid_t pasid)
+			    struct device *dev, ioasid_t pasid,
+			    struct iommu_domain *old)
 {
 	struct pdom_dev_data *pdom_dev_data;
 	struct protection_domain *sva_pdom = to_pdomain(domain);
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index a7c36654dee5..645da7b69bed 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -332,7 +332,8 @@ void arm_smmu_sva_notifier_synchronize(void)
 }
 
 static int arm_smmu_sva_set_dev_pasid(struct iommu_domain *domain,
-				      struct device *dev, ioasid_t id)
+				      struct device *dev, ioasid_t id,
+				      struct iommu_domain *old)
 {
 	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
 	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 54c26f9f05db..a66d9a044e52 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2874,7 +2874,8 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 }
 
 static int arm_smmu_s1_set_dev_pasid(struct iommu_domain *domain,
-				      struct device *dev, ioasid_t id)
+				     struct device *dev, ioasid_t id,
+				     struct iommu_domain *old)
 {
 	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
 	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 3878f35be09d..402ba1058794 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -4072,7 +4072,8 @@ static void intel_iommu_remove_dev_pasid(struct device *dev, ioasid_t pasid,
 }
 
 static int intel_iommu_set_dev_pasid(struct iommu_domain *domain,
-				     struct device *dev, ioasid_t pasid)
+				     struct device *dev, ioasid_t pasid,
+				     struct iommu_domain *old)
 {
 	struct device_domain_info *info = dev_iommu_priv_get(dev);
 	struct dmar_domain *dmar_domain = to_dmar_domain(domain);
@@ -4358,7 +4359,8 @@ static int identity_domain_attach_dev(struct iommu_domain *domain, struct device
 }
 
 static int identity_domain_set_dev_pasid(struct iommu_domain *domain,
-					 struct device *dev, ioasid_t pasid)
+					 struct device *dev, ioasid_t pasid,
+					 struct iommu_domain *old)
 {
 	struct device_domain_info *info = dev_iommu_priv_get(dev);
 	struct intel_iommu *iommu = info->iommu;
diff --git a/drivers/iommu/intel/svm.c b/drivers/iommu/intel/svm.c
index 3cc43a958b4d..4a2bd65614ad 100644
--- a/drivers/iommu/intel/svm.c
+++ b/drivers/iommu/intel/svm.c
@@ -111,7 +111,8 @@ static const struct mmu_notifier_ops intel_mmuops = {
 };
 
 static int intel_svm_set_dev_pasid(struct iommu_domain *domain,
-				   struct device *dev, ioasid_t pasid)
+				   struct device *dev, ioasid_t pasid,
+				   struct iommu_domain *old)
 {
 	struct device_domain_info *info = dev_iommu_priv_get(dev);
 	struct dmar_domain *dmar_domain = to_dmar_domain(domain);
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index d241bfdbf1f8..13fcd9d8f2df 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -3305,7 +3305,8 @@ static int __iommu_set_group_pasid(struct iommu_domain *domain,
 	int ret;
 
 	for_each_group_device(group, device) {
-		ret = domain->ops->set_dev_pasid(domain, device->dev, pasid);
+		ret = domain->ops->set_dev_pasid(domain, device->dev,
+						 pasid, NULL);
 		if (ret)
 			goto err_revert;
 	}
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 6bcab2c43014..56653af5edcb 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -639,7 +639,7 @@ struct iommu_ops {
 struct iommu_domain_ops {
 	int (*attach_dev)(struct iommu_domain *domain, struct device *dev);
 	int (*set_dev_pasid)(struct iommu_domain *domain, struct device *dev,
-			     ioasid_t pasid);
+			     ioasid_t pasid, struct iommu_domain *old);
 
 	int (*map_pages)(struct iommu_domain *domain, unsigned long iova,
 			 phys_addr_t paddr, size_t pgsize, size_t pgcount,
-- 
2.34.1


