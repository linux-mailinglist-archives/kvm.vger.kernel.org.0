Return-Path: <kvm+bounces-47945-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A6B1FAC7820
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 07:47:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5254D1C07F40
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 05:47:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 786942550BB;
	Thu, 29 May 2025 05:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GbL4Tf6u"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B8BD2417D9;
	Thu, 29 May 2025 05:43:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748497389; cv=none; b=lpLwAmZ1dsxcVUxCCeOl68eSINQswhCXk9w1zVQYH2BIg3arVShVKVZemSMZJ7B7Y0f9ZptRnZr46Q6uf6fwZfqq4wAmFnRMmyc8YfkZONmEXPshHI1HA4pPWK7OBOEOk8AsVlkk1ykvGIiZVVVS9EPMeasC9E1FHJiXP3c0tTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748497389; c=relaxed/simple;
	bh=4hunogpNwciqFH+bSwtWb6TQfi33+KNtBwWBoXqV5M4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pj5odGzjRKbuuLUjwlyer7LhcN9lXtbuUfavrye4y/mJVzinGnSlHP4EJDkqmA3sWa6IcJl8AinMw57g0EbtNnY7eXiJ0hSW5yShKCsrhW3MktigLes3zfEti4ANWGJ8EAlF2J50y/c2Sg7pzgmsrPs5S0Yq1ZsZh1CranOVLkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GbL4Tf6u; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748497389; x=1780033389;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4hunogpNwciqFH+bSwtWb6TQfi33+KNtBwWBoXqV5M4=;
  b=GbL4Tf6uH4Nvc73pNMn6tOHwHD6AFxL/Dopbm9oX4KqwkOgCYEYhOWWl
   fFNpbCma0i2eaP1VsXb8g0y1G/oLQZwXeGZNJ62mGFw7taxlZ/AK/M3Xm
   uPEHU4klWWKCIw1VopCxp0f4NN6QwGUynPmvTs/NEDgRqvAqW88wSoXbM
   JAJZBqaVtyBwgCKO36BVxYPqRlLq8iufiyWVScFiOXWLzP3F7Ospl9NUy
   gk6CtPEA/xdQ5kbRL+KUtz3GFZubQFsotzFKjDjaWV7rmUPNiY01CVjKr
   8Z61i5gTZ5u+Rip4NfEBwRaDmIZVCyhNuZxySYedBllgKKa9fCk9aBOT/
   w==;
X-CSE-ConnectionGUID: WepAyHhOQC6JBa6h7b/TSg==
X-CSE-MsgGUID: xrdFvCa8Q8KzAHTUtsOPoA==
X-IronPort-AV: E=McAfee;i="6700,10204,11447"; a="67963134"
X-IronPort-AV: E=Sophos;i="6.15,323,1739865600"; 
   d="scan'208";a="67963134"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2025 22:43:08 -0700
X-CSE-ConnectionGUID: ZmANZOTgTEGCPxcNuqIHBg==
X-CSE-MsgGUID: hzXAEOUOQ/O6ZKvbdS4Gcg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,323,1739865600"; 
   d="scan'208";a="144443399"
Received: from yilunxu-optiplex-7050.sh.intel.com ([10.239.159.165])
  by fmviesa009.fm.intel.com with ESMTP; 28 May 2025 22:43:01 -0700
From: Xu Yilun <yilun.xu@linux.intel.com>
To: kvm@vger.kernel.org,
	sumit.semwal@linaro.org,
	christian.koenig@amd.com,
	pbonzini@redhat.com,
	seanjc@google.com,
	alex.williamson@redhat.com,
	jgg@nvidia.com,
	dan.j.williams@intel.com,
	aik@amd.com,
	linux-coco@lists.linux.dev
Cc: dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org,
	vivek.kasireddy@intel.com,
	yilun.xu@intel.com,
	yilun.xu@linux.intel.com,
	linux-kernel@vger.kernel.org,
	lukas@wunner.de,
	yan.y.zhao@intel.com,
	daniel.vetter@ffwll.ch,
	leon@kernel.org,
	baolu.lu@linux.intel.com,
	zhenzhong.duan@intel.com,
	tao1.su@intel.com,
	linux-pci@vger.kernel.org,
	zhiw@nvidia.com,
	simona.vetter@ffwll.ch,
	shameerali.kolothum.thodi@huawei.com,
	aneesh.kumar@kernel.org,
	iommu@lists.linux.dev,
	kevin.tian@intel.com
Subject: [RFC PATCH 14/30] iommu/arm-smmu-v3-iommufd: Pass in kvm pointer to viommu_alloc
Date: Thu, 29 May 2025 13:34:57 +0800
Message-Id: <20250529053513.1592088-15-yilun.xu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250529053513.1592088-1-yilun.xu@linux.intel.com>
References: <20250529053513.1592088-1-yilun.xu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>

No functional changes.

This will be used in a later patch to add support to use
KVM VMID in ARM SMMUv3 s2 stage configuration.

Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c | 1 +
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h         | 1 +
 drivers/iommu/iommufd/viommu.c                      | 3 ++-
 include/linux/iommu.h                               | 4 +++-
 4 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
index e4fd8d522af8..5ee2b24e7bcf 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
@@ -383,6 +383,7 @@ static const struct iommufd_viommu_ops arm_vsmmu_ops = {
 };
 
 struct iommufd_viommu *arm_vsmmu_alloc(struct device *dev,
+				       struct kvm *kvm,
 				       struct iommu_domain *parent,
 				       struct iommufd_ctx *ictx,
 				       unsigned int viommu_type)
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index dd1ad56ce863..94b695b60c26 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -1060,6 +1060,7 @@ struct arm_vsmmu {
 #if IS_ENABLED(CONFIG_ARM_SMMU_V3_IOMMUFD)
 void *arm_smmu_hw_info(struct device *dev, u32 *length, u32 *type);
 struct iommufd_viommu *arm_vsmmu_alloc(struct device *dev,
+				       struct kvm *kvm,
 				       struct iommu_domain *parent,
 				       struct iommufd_ctx *ictx,
 				       unsigned int viommu_type);
diff --git a/drivers/iommu/iommufd/viommu.c b/drivers/iommu/iommufd/viommu.c
index 01df2b985f02..488905989b7c 100644
--- a/drivers/iommu/iommufd/viommu.c
+++ b/drivers/iommu/iommufd/viommu.c
@@ -47,7 +47,8 @@ int iommufd_viommu_alloc_ioctl(struct iommufd_ucmd *ucmd)
 		goto out_put_hwpt;
 	}
 
-	viommu = ops->viommu_alloc(idev->dev, hwpt_paging->common.domain,
+	viommu = ops->viommu_alloc(idev->dev, idev->kvm,
+				   hwpt_paging->common.domain,
 				   ucmd->ictx, cmd->type);
 	if (IS_ERR(viommu)) {
 		rc = PTR_ERR(viommu);
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index ccce8a751e2a..3675a5a6cea0 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -47,6 +47,7 @@ struct iommufd_ctx;
 struct iommufd_viommu;
 struct msi_desc;
 struct msi_msg;
+struct kvm;
 
 #define IOMMU_FAULT_PERM_READ	(1 << 0) /* read */
 #define IOMMU_FAULT_PERM_WRITE	(1 << 1) /* write */
@@ -661,7 +662,8 @@ struct iommu_ops {
 	int (*def_domain_type)(struct device *dev);
 
 	struct iommufd_viommu *(*viommu_alloc)(
-		struct device *dev, struct iommu_domain *parent_domain,
+		struct device *dev, struct kvm *kvm,
+		struct iommu_domain *parent_domain,
 		struct iommufd_ctx *ictx, unsigned int viommu_type);
 
 	const struct iommu_domain_ops *default_domain_ops;
-- 
2.25.1


