Return-Path: <kvm+bounces-30539-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AC2B09BB5F3
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 14:26:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D01AC1C210D1
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 13:26:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8103F13D24D;
	Mon,  4 Nov 2024 13:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jQdMSokK"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 078E4139CFA
	for <kvm@vger.kernel.org>; Mon,  4 Nov 2024 13:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730726724; cv=none; b=l/HOiOyLz3tu5ylvOMYzJ8VN/qP1JtUusChk1ugTRGN1ADmvQ/UDiGyIkDfylXrjXQtNUII38zUw3EZMx4vPuNcU9hDLtFlug2GXL6L+AaLFABy39Z24euNFsyfO0AytR7g90bu6pRmBEepA5mNfjWKlf3gE3MhtY+MavDR6YVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730726724; c=relaxed/simple;
	bh=BcJNnKcdyTF5yjmj2IotBTGqGiR3ueh+E/24lMauZu4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XDSDS1wpurEMg0tSqHNu5D3chtoya4kH1AFAGwXjjuWIcyYw1j90Wt2MQobeu8upnEP9EjGFNjX8oqiOFPwoY8tdltX4dYKhhc7bI3Esk5DCnUz2NtrHt7kfdCFDMr7JU9ouyPNDNeAOBeP3AtqzLd4g2V1uZ3KMf6AQJ/S+4Qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jQdMSokK; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730726723; x=1762262723;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BcJNnKcdyTF5yjmj2IotBTGqGiR3ueh+E/24lMauZu4=;
  b=jQdMSokKXJQjKbACQyfsOa+Y7nnaU46iClcj58qoHIVM3F2VbfPTcht9
   tz1n9jy5PSqFFqhr37kEF9mXja/UIO5ke6alKHpZzWLEHaUd7cCj7JpZq
   08oz9ZLEPww1n/VND53i8yrHLV1FLLnD1mlgpNego8Dv7Y6w6r49STyZN
   9QQgpcY+gs4WRffHUD8KyWFkNQmsUOwFaEnfQ9rbAyQ4bhS6zzOLsTIil
   cY9Q5JCjgtc3vU/6TaTAbYbx7/g5/DXy0/i2tDDp+do5YYWoVtCryu4MQ
   WH9HhYAHjq2FFX5bziZhs2OKOTgm6YBJwvP4Hho5561pPPvhAM7aNLOU0
   g==;
X-CSE-ConnectionGUID: BHYdyuwPTseZ8tmUrVPJzw==
X-CSE-MsgGUID: cXOqme6zTUuVgVjszi2/7g==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="47884070"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="47884070"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 05:25:20 -0800
X-CSE-ConnectionGUID: JYx5kUXgQLuSOrvfAtbx1g==
X-CSE-MsgGUID: bBc1mJOFRw+mM5MeGPqowQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,257,1725346800"; 
   d="scan'208";a="84100464"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orviesa007.jf.intel.com with ESMTP; 04 Nov 2024 05:25:20 -0800
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
	vasant.hegde@amd.com
Subject: [PATCH v5 08/12] iommufd: Enforce pasid compatible domain for PASID-capable device
Date: Mon,  4 Nov 2024 05:25:09 -0800
Message-Id: <20241104132513.15890-9-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241104132513.15890-1-yi.l.liu@intel.com>
References: <20241104132513.15890-1-yi.l.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

iommu hw may have special requirement on the domain attached to PASID
capable device. e.g. AMD IOMMU requires the domain allocated with the
IOMMU_HWPT_ALLOC_PASID flag. Hence, iommufd should enforce it when the
domain is used by PASID-capable device.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/iommu/intel/iommu.c             | 6 ++++--
 drivers/iommu/iommufd/hw_pagetable.c    | 7 +++++--
 drivers/iommu/iommufd/iommufd_private.h | 7 +++++++
 3 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index a1341078b962..d24e21a757ff 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -3545,13 +3545,15 @@ intel_iommu_domain_alloc_user(struct device *dev, u32 flags,
 
 	/* Must be NESTING domain */
 	if (parent) {
-		if (!nested_supported(iommu) || flags)
+		if (!nested_supported(iommu) ||
+		    flags & ~IOMMU_HWPT_ALLOC_PASID)
 			return ERR_PTR(-EOPNOTSUPP);
 		return intel_nested_domain_alloc(parent, user_data);
 	}
 
 	if (flags &
-	    (~(IOMMU_HWPT_ALLOC_NEST_PARENT | IOMMU_HWPT_ALLOC_DIRTY_TRACKING)))
+	    (~(IOMMU_HWPT_ALLOC_NEST_PARENT | IOMMU_HWPT_ALLOC_DIRTY_TRACKING |
+	       IOMMU_HWPT_ALLOC_PASID)))
 		return ERR_PTR(-EOPNOTSUPP);
 	if (nested_parent && !nested_supported(iommu))
 		return ERR_PTR(-EOPNOTSUPP);
diff --git a/drivers/iommu/iommufd/hw_pagetable.c b/drivers/iommu/iommufd/hw_pagetable.c
index 48639427749b..e4932a5a87ea 100644
--- a/drivers/iommu/iommufd/hw_pagetable.c
+++ b/drivers/iommu/iommufd/hw_pagetable.c
@@ -107,7 +107,8 @@ iommufd_hwpt_paging_alloc(struct iommufd_ctx *ictx, struct iommufd_ioas *ioas,
 			  const struct iommu_user_data *user_data)
 {
 	const u32 valid_flags = IOMMU_HWPT_ALLOC_NEST_PARENT |
-				IOMMU_HWPT_ALLOC_DIRTY_TRACKING;
+				IOMMU_HWPT_ALLOC_DIRTY_TRACKING |
+				IOMMU_HWPT_ALLOC_PASID;
 	const struct iommu_ops *ops = dev_iommu_ops(idev->dev);
 	struct iommufd_hwpt_paging *hwpt_paging;
 	struct iommufd_hw_pagetable *hwpt;
@@ -128,6 +129,7 @@ iommufd_hwpt_paging_alloc(struct iommufd_ctx *ictx, struct iommufd_ioas *ioas,
 	if (IS_ERR(hwpt_paging))
 		return ERR_CAST(hwpt_paging);
 	hwpt = &hwpt_paging->common;
+	hwpt->pasid_compat = flags & IOMMU_HWPT_ALLOC_PASID;
 
 	INIT_LIST_HEAD(&hwpt_paging->hwpt_item);
 	/* Pairs with iommufd_hw_pagetable_destroy() */
@@ -223,7 +225,7 @@ iommufd_hwpt_nested_alloc(struct iommufd_ctx *ictx,
 	struct iommufd_hw_pagetable *hwpt;
 	int rc;
 
-	if ((flags & ~IOMMU_HWPT_FAULT_ID_VALID) ||
+	if ((flags & ~(IOMMU_HWPT_FAULT_ID_VALID | IOMMU_HWPT_ALLOC_PASID)) ||
 	    !user_data->len || !ops->domain_alloc_user)
 		return ERR_PTR(-EOPNOTSUPP);
 	if (parent->auto_domain || !parent->nest_parent ||
@@ -235,6 +237,7 @@ iommufd_hwpt_nested_alloc(struct iommufd_ctx *ictx,
 	if (IS_ERR(hwpt_nested))
 		return ERR_CAST(hwpt_nested);
 	hwpt = &hwpt_nested->common;
+	hwpt->pasid_compat = flags & IOMMU_HWPT_ALLOC_PASID;
 
 	refcount_inc(&parent->common.obj.users);
 	hwpt_nested->parent = parent;
diff --git a/drivers/iommu/iommufd/iommufd_private.h b/drivers/iommu/iommufd/iommufd_private.h
index 11773cef5acc..81a95f869e10 100644
--- a/drivers/iommu/iommufd/iommufd_private.h
+++ b/drivers/iommu/iommufd/iommufd_private.h
@@ -296,6 +296,7 @@ struct iommufd_hw_pagetable {
 	struct iommufd_object obj;
 	struct iommu_domain *domain;
 	struct iommufd_fault *fault;
+	bool pasid_compat : 1;
 };
 
 struct iommufd_hwpt_paging {
@@ -531,6 +532,9 @@ static inline int iommufd_hwpt_attach_device(struct iommufd_hw_pagetable *hwpt,
 					     struct iommufd_device *idev,
 					     ioasid_t pasid)
 {
+	if (idev->dev->iommu->max_pasids && !hwpt->pasid_compat)
+		return -EINVAL;
+
 	if (hwpt->fault)
 		return iommufd_fault_domain_attach_dev(hwpt, idev, pasid);
 
@@ -564,6 +568,9 @@ static inline int iommufd_hwpt_replace_device(struct iommufd_device *idev,
 	struct iommufd_attach_handle *curr;
 	int ret;
 
+	if (idev->dev->iommu->max_pasids && !hwpt->pasid_compat)
+		return -EINVAL;
+
 	if (old->fault || hwpt->fault)
 		return iommufd_fault_domain_replace_dev(idev, pasid,
 							hwpt, old);
-- 
2.34.1


