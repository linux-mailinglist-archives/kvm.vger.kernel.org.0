Return-Path: <kvm+bounces-13009-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D3B8A88FF02
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 13:30:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 021581C287AF
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 12:30:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A52AE7EF02;
	Thu, 28 Mar 2024 12:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="O84zvP6z"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF95B7F46C
	for <kvm@vger.kernel.org>; Thu, 28 Mar 2024 12:30:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711629004; cv=none; b=gvZZAFoGeXHk0JIL3nsFhmDviC76UAebzOvi/QuK0ab2uBA8Qz4vrTxyHcBlbOBLHAjs42QO9cq0+ul3j6g/AP9Ij47Q3zHqpiyLMp9ANBcSyh9jkoLeZf1OZvDsf1Zz1C+G7S6Co5Vh+KvvKRosXL2Hdz6vmvQEWwld6TPO0wM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711629004; c=relaxed/simple;
	bh=bCpwAcF+Sjeh+Vw+kqhzPtzhhuWMHA0h0jZ+49oOciQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jNprcDbrQ2Z6DBHJHHfpBC0g9JQsKQI2TOBMvnbCbPNelm+xzEWnlDH5La+rGsQdXAa+NIp0GATYYqwZVEaL9qz5ZGbIoFpxa4zUJ6/q2a6WZ+zNrZI+fEoQVLwm+eacbq/fiCqMUTNASOP6ZhC0Z2NnscRA1Ieuw/GD9oeTOug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=O84zvP6z; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711629003; x=1743165003;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bCpwAcF+Sjeh+Vw+kqhzPtzhhuWMHA0h0jZ+49oOciQ=;
  b=O84zvP6zznvseF+Bv/OV+fyGTIzmuDhSfyWrd4gveWoGvrmrOVBCKMPX
   UWLkBqZngAcxfLO/P+VT7guIyEO6d/uAqCUz2TqaIeRKye9uDiOPxAYGD
   MW69DoSqBPLP4EoEMgGgdzXZsenKVkO/NN8GvwlswnbUS+lhIqHWQXPHg
   1XJ2WlNSTCtqgei+cQXt7syhzVOtxJzD+slzU8X2jOCg7WffuXPYIGQ7d
   tQ+p0YGHFtm/UACnfur4ygSMjKgUMXaMKbJAtsowuD8w84ZQ81RQEAv5r
   9IKNVaybVVK1cMGtxUIVm4wc1Vctu2kZr9meTUfieFiL3SagYb1ShszK5
   Q==;
X-CSE-ConnectionGUID: Gz/o0WejSkuPjzJmP7kOhw==
X-CSE-MsgGUID: JD1CL+LcRzivvKjswDQ6Tw==
X-IronPort-AV: E=McAfee;i="6600,9927,11026"; a="18212549"
X-IronPort-AV: E=Sophos;i="6.07,161,1708416000"; 
   d="scan'208";a="18212549"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 05:30:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,161,1708416000"; 
   d="scan'208";a="17038492"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orviesa007.jf.intel.com with ESMTP; 28 Mar 2024 05:30:02 -0700
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
	iommu@lists.linux.dev,
	zhenzhong.duan@intel.com,
	jacob.jun.pan@intel.com
Subject: [PATCH v2 2/2] iommu: Pass domain to remove_dev_pasid() op
Date: Thu, 28 Mar 2024 05:29:58 -0700
Message-Id: <20240328122958.83332-3-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240328122958.83332-1-yi.l.liu@intel.com>
References: <20240328122958.83332-1-yi.l.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Existing remove_dev_pasid() callbacks of the underlying iommu drivers
get the attached domain from the group->pasid_array. However, the domain
stored in group->pasid_array is not always correct in all scenarios.
A wrong domain may result in failure in remove_dev_pasid() callback.
To avoid such problems, it is more reliable to pass the domain to the
remove_dev_pasid() op.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c |  9 ++-------
 drivers/iommu/intel/iommu.c                 | 11 +++--------
 drivers/iommu/iommu.c                       |  9 +++++----
 include/linux/iommu.h                       |  3 ++-
 4 files changed, 12 insertions(+), 20 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 5ed036225e69..ced041777ec0 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -3044,14 +3044,9 @@ static int arm_smmu_def_domain_type(struct device *dev)
 	return 0;
 }
 
-static void arm_smmu_remove_dev_pasid(struct device *dev, ioasid_t pasid)
+static void arm_smmu_remove_dev_pasid(struct device *dev, ioasid_t pasid,
+				      struct iommu_domain *domain)
 {
-	struct iommu_domain *domain;
-
-	domain = iommu_get_domain_for_dev_pasid(dev, pasid, IOMMU_DOMAIN_SVA);
-	if (WARN_ON(IS_ERR(domain)) || !domain)
-		return;
-
 	arm_smmu_sva_remove_dev_pasid(domain, dev, pasid);
 }
 
diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 50eb9aed47cc..45c75a8a0ef5 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -4587,19 +4587,15 @@ static int intel_iommu_iotlb_sync_map(struct iommu_domain *domain,
 	return 0;
 }
 
-static void intel_iommu_remove_dev_pasid(struct device *dev, ioasid_t pasid)
+static void intel_iommu_remove_dev_pasid(struct device *dev, ioasid_t pasid,
+					 struct iommu_domain *domain)
 {
 	struct device_domain_info *info = dev_iommu_priv_get(dev);
+	struct dmar_domain *dmar_domain = to_dmar_domain(domain);
 	struct dev_pasid_info *curr, *dev_pasid = NULL;
 	struct intel_iommu *iommu = info->iommu;
-	struct dmar_domain *dmar_domain;
-	struct iommu_domain *domain;
 	unsigned long flags;
 
-	domain = iommu_get_domain_for_dev_pasid(dev, pasid, 0);
-	if (WARN_ON_ONCE(!domain))
-		goto out_tear_down;
-
 	/*
 	 * The SVA implementation needs to handle its own stuffs like the mm
 	 * notification. Before consolidating that code into iommu core, let
@@ -4610,7 +4606,6 @@ static void intel_iommu_remove_dev_pasid(struct device *dev, ioasid_t pasid)
 		goto out_tear_down;
 	}
 
-	dmar_domain = to_dmar_domain(domain);
 	spin_lock_irqsave(&dmar_domain->lock, flags);
 	list_for_each_entry(curr, &dmar_domain->dev_pasids, link_domain) {
 		if (curr->dev == dev && curr->pasid == pasid) {
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index bb3244df525e..c0b615f68a75 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -3335,20 +3335,21 @@ static int __iommu_set_group_pasid(struct iommu_domain *domain,
 
 		if (device == last_gdev)
 			break;
-		ops->remove_dev_pasid(device->dev, pasid);
+		ops->remove_dev_pasid(device->dev, pasid, domain);
 	}
 	return ret;
 }
 
 static void __iommu_remove_group_pasid(struct iommu_group *group,
-				       ioasid_t pasid)
+				       ioasid_t pasid,
+				       struct iommu_domain *domain)
 {
 	struct group_device *device;
 	const struct iommu_ops *ops;
 
 	for_each_group_device(group, device) {
 		ops = dev_iommu_ops(device->dev);
-		ops->remove_dev_pasid(device->dev, pasid);
+		ops->remove_dev_pasid(device->dev, pasid, domain);
 	}
 }
 
@@ -3409,7 +3410,7 @@ void iommu_detach_device_pasid(struct iommu_domain *domain, struct device *dev,
 	struct iommu_group *group = dev->iommu_group;
 
 	mutex_lock(&group->mutex);
-	__iommu_remove_group_pasid(group, pasid);
+	__iommu_remove_group_pasid(group, pasid, domain);
 	WARN_ON(xa_erase(&group->pasid_array, pasid) != domain);
 	mutex_unlock(&group->mutex);
 }
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 2e925b5eba53..40dd439307e8 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -578,7 +578,8 @@ struct iommu_ops {
 			      struct iommu_page_response *msg);
 
 	int (*def_domain_type)(struct device *dev);
-	void (*remove_dev_pasid)(struct device *dev, ioasid_t pasid);
+	void (*remove_dev_pasid)(struct device *dev, ioasid_t pasid,
+				 struct iommu_domain *domain);
 
 	const struct iommu_domain_ops *default_domain_ops;
 	unsigned long pgsize_bitmap;
-- 
2.34.1


