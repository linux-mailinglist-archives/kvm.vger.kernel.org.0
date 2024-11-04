Return-Path: <kvm+bounces-30527-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 745A19BB5C9
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 14:21:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 36CCA280A50
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 13:21:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2122B433A4;
	Mon,  4 Nov 2024 13:20:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="n7FEJRdE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2B2C22612
	for <kvm@vger.kernel.org>; Mon,  4 Nov 2024 13:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730726442; cv=none; b=NKQOfkOEMeFVh6TjGh8ab52e8Btjrz+d/mYMVUz0yE4QRV2vFUmk/jGrN0gOK0OnhiPJirxIk/WEiNYEpxSTcDOzYMTwS/BLw+jdi2gqNz0S3WvudrFxX8FiuLJwecoj3ZO2FzHMxBE5bC5nB4DsZ6kmift7OkqQK5ocJw8+HO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730726442; c=relaxed/simple;
	bh=kf1xvgtT9lTHmXp9iJNKEmi3xTpRAeqY1wh8VAk9QV0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=A+HgliMgZwr2DW8nfhRPF5likarO/lXRpq3Ki6vL9UQOtCUMUpNY6uOozWwkCQWqiD29VzqQsunntVtG2GEIbzVGvyUAOfA33A9Zk+Jv/JtWusGU1pzIOBaktCCHexFSq4bef0iWNFNfnrPSKUk0UqPk7wjvXz89znk1c+arAiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=n7FEJRdE; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730726441; x=1762262441;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kf1xvgtT9lTHmXp9iJNKEmi3xTpRAeqY1wh8VAk9QV0=;
  b=n7FEJRdEVX/NBo9se+SPdU8gjFRk26WBZRX/Ims80Kei9R5Ns3gVxwIR
   NkvXQMBWlqhGz8NCapzsOt0/c5Wm65qZXO7hD8CUzcWtwkpdxNLAjg2uO
   rYSriAaKrw/261JolF77cB4wMq+aaAHo+VLuUeBFxUQFVFczsew7uMH17
   DRHLWtx+I5fPm5nhFWEKS9rfIIUJk2iMzohP05NVgT3qrUZoh7YXhjUS5
   QIjQWt7EGJENmaSN7X0ANT3QySDya0HzmwzE4ilgL71rrmb6OpMmK2EQ7
   8R7x/TKLOlHEIxgqUqjsK+vBcjVeeSCUmFP3jJrgpIW1m/nCCDgA8Wyw+
   A==;
X-CSE-ConnectionGUID: ZdAkFNaYQk23W2GRbPqkdA==
X-CSE-MsgGUID: 3slKhHD0S76cNHBt9W30rw==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="47883283"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="47883283"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 05:20:40 -0800
X-CSE-ConnectionGUID: VTmIaPpIT5Wr3lwfZUKQrg==
X-CSE-MsgGUID: hYPFcJESR6SmGkxKWeYaDg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,257,1725346800"; 
   d="scan'208";a="84099726"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orviesa007.jf.intel.com with ESMTP; 04 Nov 2024 05:20:40 -0800
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
Subject: [PATCH v3 4/7] iommu/arm-smmu-v3: Make the blocked domain support PASID
Date: Mon,  4 Nov 2024 05:20:30 -0800
Message-Id: <20241104132033.14027-5-yi.l.liu@intel.com>
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

From: Jason Gunthorpe <jgg@nvidia.com>

The blocked domain is used to park RID to be blocking DMA state. This
can be extended to PASID as well. By this, the remove_dev_pasid() op
of ARM SMMUv3 can be dropped.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 2d188d12f85c..57627ba44f6d 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2961,13 +2961,12 @@ int arm_smmu_set_pasid(struct arm_smmu_master *master,
 	return ret;
 }
 
-static void arm_smmu_remove_dev_pasid(struct device *dev, ioasid_t pasid,
-				      struct iommu_domain *domain)
+static int arm_smmu_blocking_set_dev_pasid(struct iommu_domain *new_domain,
+					   struct device *dev, ioasid_t pasid,
+					   struct iommu_domain *old_domain)
 {
+	struct arm_smmu_domain *smmu_domain = to_smmu_domain(old_domain);
 	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
-	struct arm_smmu_domain *smmu_domain;
-
-	smmu_domain = to_smmu_domain(domain);
 
 	mutex_lock(&arm_smmu_asid_lock);
 	arm_smmu_clear_cd(master, pasid);
@@ -2988,6 +2987,7 @@ static void arm_smmu_remove_dev_pasid(struct device *dev, ioasid_t pasid,
 		    sid_domain->type == IOMMU_DOMAIN_BLOCKED)
 			sid_domain->ops->attach_dev(sid_domain, dev);
 	}
+	return 0;
 }
 
 static void arm_smmu_attach_dev_ste(struct iommu_domain *domain,
@@ -3069,6 +3069,7 @@ static int arm_smmu_attach_dev_blocked(struct iommu_domain *domain,
 
 static const struct iommu_domain_ops arm_smmu_blocked_ops = {
 	.attach_dev = arm_smmu_attach_dev_blocked,
+	.set_dev_pasid = arm_smmu_blocking_set_dev_pasid,
 };
 
 static struct iommu_domain arm_smmu_blocked_domain = {
@@ -3501,7 +3502,6 @@ static struct iommu_ops arm_smmu_ops = {
 	.device_group		= arm_smmu_device_group,
 	.of_xlate		= arm_smmu_of_xlate,
 	.get_resv_regions	= arm_smmu_get_resv_regions,
-	.remove_dev_pasid	= arm_smmu_remove_dev_pasid,
 	.dev_enable_feat	= arm_smmu_dev_enable_feature,
 	.dev_disable_feat	= arm_smmu_dev_disable_feature,
 	.page_response		= arm_smmu_page_response,
-- 
2.34.1


