Return-Path: <kvm+bounces-30528-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E0F749BB5CA
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 14:21:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A6196281112
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 13:21:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90E837082A;
	Mon,  4 Nov 2024 13:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KfrPLCRv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34BA12D05E
	for <kvm@vger.kernel.org>; Mon,  4 Nov 2024 13:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730726443; cv=none; b=XCZfLNPh8hv4U3kRVMVVPXYRwHYtsehtqrk7K6QRKNLb5Chxe1NMwefQAJs4NNVkCNlgEdEDHzGzv6+DV+fkYCcOnINwhznYagGa7xTeJagCwUsGO4mlb6qH87jRQzOHwf0FxZbhsgTuClUMQHcf9Y5Q+FkJI1FEOAhjbL7Eluk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730726443; c=relaxed/simple;
	bh=STwQNNlpnSNSJ9AYhnQKss8CVJ6vzxvWbO4ctAdc2S0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Bvsa/w+GHMQeq62tlmcDJyTbrQ26Ke/ECeCc90Yh/jk9OOgAbLbB7DHC+1FNq+SF/Q/IUH54pxfvPvmHvBEunD5ysxG/glq2Q6zuka7LQMjq0ssKifZLxkG5Q9qM2mPkApcTKszYN4J6bzoIiRmmhcgN1rF6NVEFIaWansMqRUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KfrPLCRv; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730726443; x=1762262443;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=STwQNNlpnSNSJ9AYhnQKss8CVJ6vzxvWbO4ctAdc2S0=;
  b=KfrPLCRvSpi9QfvbxTxBi+sXjjx54X+h9I0HUUqhx4c3d3Ir76BMVLcn
   4t/CJsV+PLlyUkPA5Odg5q9mTV46QgV2doGxZx6x10yAuAgcVd/Qe3tUq
   7/cFHVtVTUgxsJSJ90xndWXcr9OLQlYNdIqSI+CsexOAzmHFhyD/h5L7A
   nl6NUP3Vk9WT5CqJjSGz5c1anBs7t4GXyLLxJtt2BvlCgrDru3Lovm4T0
   Gh84kpNugkFe31dbB8ybJdgUASb++1fu8OS4OUN3WuON8FdqdLXvvo2i2
   R6lBBfbRg3kj2DmgsfiH0gaXAhcuYYGUKKCyl2AhsaBaWk7Gb8grwvXS9
   A==;
X-CSE-ConnectionGUID: jaZso0EtTMmvPwXlp3ikbA==
X-CSE-MsgGUID: bzF+mVZXT8eY6SOqOUULaA==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="47883293"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="47883293"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 05:20:41 -0800
X-CSE-ConnectionGUID: l/3qv5tnT/6O+vKxeVdHgg==
X-CSE-MsgGUID: 4fCyQ77KR76IAjcITe+LqQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,257,1725346800"; 
   d="scan'208";a="84099736"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orviesa007.jf.intel.com with ESMTP; 04 Nov 2024 05:20:41 -0800
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
Subject: [PATCH v3 5/7] iommu/vt-d: Make the blocked domain support PASID
Date: Mon,  4 Nov 2024 05:20:31 -0800
Message-Id: <20241104132033.14027-6-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241104132033.14027-1-yi.l.liu@intel.com>
References: <20241104132033.14027-1-yi.l.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The blocked domain can be extended to park PASID of a device to be the
DMA blocking state. By this the remove_dev_pasid() op is dropped.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/iommu/intel/iommu.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 7f1ca3c342a3..a1341078b962 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -3414,10 +3414,15 @@ static int blocking_domain_attach_dev(struct iommu_domain *domain,
 	return 0;
 }
 
+static int blocking_domain_set_dev_pasid(struct iommu_domain *domain,
+					 struct device *dev, ioasid_t pasid,
+					 struct iommu_domain *old);
+
 static struct iommu_domain blocking_domain = {
 	.type = IOMMU_DOMAIN_BLOCKED,
 	.ops = &(const struct iommu_domain_ops) {
 		.attach_dev	= blocking_domain_attach_dev,
+		.set_dev_pasid	= blocking_domain_set_dev_pasid,
 	}
 };
 
@@ -4291,15 +4296,18 @@ void domain_remove_dev_pasid(struct iommu_domain *domain,
 	kfree(dev_pasid);
 }
 
-static void intel_iommu_remove_dev_pasid(struct device *dev, ioasid_t pasid,
-					 struct iommu_domain *domain)
+static int blocking_domain_set_dev_pasid(struct iommu_domain *domain,
+					 struct device *dev, ioasid_t pasid,
+					 struct iommu_domain *old)
 {
 	struct device_domain_info *info = dev_iommu_priv_get(dev);
 	struct intel_iommu *iommu = info->iommu;
 
 	intel_pasid_tear_down_entry(iommu, dev, pasid, false);
 	intel_drain_pasid_prq(dev, pasid);
-	domain_remove_dev_pasid(domain, dev, pasid);
+	domain_remove_dev_pasid(old, dev, pasid);
+
+	return 0;
 }
 
 struct dev_pasid_info *
@@ -4664,7 +4672,6 @@ const struct iommu_ops intel_iommu_ops = {
 	.dev_disable_feat	= intel_iommu_dev_disable_feat,
 	.is_attach_deferred	= intel_iommu_is_attach_deferred,
 	.def_domain_type	= device_def_domain_type,
-	.remove_dev_pasid	= intel_iommu_remove_dev_pasid,
 	.pgsize_bitmap		= SZ_4K,
 #ifdef CONFIG_INTEL_IOMMU_SVM
 	.page_response		= intel_svm_page_response,
-- 
2.34.1


