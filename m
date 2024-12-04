Return-Path: <kvm+bounces-33014-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 17F3D9E39F8
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 13:30:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E8BB81651F0
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 12:30:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 830E51C3F34;
	Wed,  4 Dec 2024 12:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hXTLHZex"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E915E1BBBD7
	for <kvm@vger.kernel.org>; Wed,  4 Dec 2024 12:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733315376; cv=none; b=YVCI3wkje5uAP2mIdf+mcWMa48LeROLzCG9TTSVBf8HOWicmXLWLEhf1KxulGzW+kQRI32JLRC0ECzhcE3CJHChSquLpI6xi0c1vtxO5pMR8YJi9bjTKFD2VwOWA6bxX7CD7bgA65vVa0ahX6CZ4ZjjJwG08AxSZMTrf3jowLNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733315376; c=relaxed/simple;
	bh=SIs5FZktMC7aBVud1qJKzHFNR+gqN79SDzKJmiPNwp8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EpwaTlA1zpcyfAGorKXeJIgy7C+TLC6RymYqDy9iwG34pK6PXAcYUMCRjAth4rXHj2WJ/qhJYR5Mn95qjfgYavNKDQKm37Or+fQ5ARHQ199bECySviPp5dFB3lvrIgk3c2ugMjn8C36NwUZDHDSSkxJqTer4FE56u+3NEUdPnQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hXTLHZex; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733315375; x=1764851375;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SIs5FZktMC7aBVud1qJKzHFNR+gqN79SDzKJmiPNwp8=;
  b=hXTLHZexswPIZlFWoAt0IqYAJo/ildAyMJi+tYOP3ga4L1AcgLuzCIYi
   FYcVebfaktT2Y2xPkK4lFjuyU8XgpMDgiG6CQaTZVoaTy48OeEFCCMCqW
   RWoCKrtUiU6E4vuPgSx7/lJAiNpByvSYF6rNOpp4ICTGq5ro9jpC4byDO
   fzUAve1T/ch5IfGSNrpxnNiBdrdP1coTMG6qTBHIcXHFV3MDzzEGVJRUa
   zK85sl/s9niuUSVS5+Ru/nmk68t4zEvxmafkuw/qJ+Fug5VIVdX77s5JF
   nttKoBDiqYcjAa5OTJ/i2CBbIbBOBYr5VIy/3+P5k7B5yWEN/M8wnsZjE
   A==;
X-CSE-ConnectionGUID: knMv3MEcTcq0zGuEq6vR7Q==
X-CSE-MsgGUID: 0aXgvpo2TA+LB2oJ+C8E8g==
X-IronPort-AV: E=McAfee;i="6700,10204,11276"; a="32937901"
X-IronPort-AV: E=Sophos;i="6.12,207,1728975600"; 
   d="scan'208";a="32937901"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2024 04:29:33 -0800
X-CSE-ConnectionGUID: PWI0gzFxReC+/Eo/zYPUMA==
X-CSE-MsgGUID: O7oytZ3LQjKebXY2TnFp9w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,207,1728975600"; 
   d="scan'208";a="93599076"
Received: from unknown (HELO 984fee00a4c6.jf.intel.com) ([10.165.58.231])
  by orviesa010.jf.intel.com with ESMTP; 04 Dec 2024 04:29:33 -0800
From: Yi Liu <yi.l.liu@intel.com>
To: joro@8bytes.org,
	jgg@nvidia.com,
	kevin.tian@intel.com,
	baolu.lu@linux.intel.com
Cc: eric.auger@redhat.com,
	nicolinc@nvidia.com,
	kvm@vger.kernel.org,
	chao.p.peng@linux.intel.com,
	yi.l.liu@intel.com,
	iommu@lists.linux.dev,
	zhenzhong.duan@intel.com,
	vasant.hegde@amd.com,
	will@kernel.org
Subject: [PATCH v6 4/7] iommu/arm-smmu-v3: Make the blocked domain support PASID
Date: Wed,  4 Dec 2024 04:29:25 -0800
Message-Id: <20241204122928.11987-5-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241204122928.11987-1-yi.l.liu@intel.com>
References: <20241204122928.11987-1-yi.l.liu@intel.com>
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

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index e4ebd9e12ad4..ff1d9bbf6d94 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -3016,13 +3016,12 @@ int arm_smmu_set_pasid(struct arm_smmu_master *master,
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
@@ -3043,6 +3042,7 @@ static void arm_smmu_remove_dev_pasid(struct device *dev, ioasid_t pasid,
 		    sid_domain->type == IOMMU_DOMAIN_BLOCKED)
 			sid_domain->ops->attach_dev(sid_domain, dev);
 	}
+	return 0;
 }
 
 static void arm_smmu_attach_dev_ste(struct iommu_domain *domain,
@@ -3124,6 +3124,7 @@ static int arm_smmu_attach_dev_blocked(struct iommu_domain *domain,
 
 static const struct iommu_domain_ops arm_smmu_blocked_ops = {
 	.attach_dev = arm_smmu_attach_dev_blocked,
+	.set_dev_pasid = arm_smmu_blocking_set_dev_pasid,
 };
 
 static struct iommu_domain arm_smmu_blocked_domain = {
@@ -3551,7 +3552,6 @@ static struct iommu_ops arm_smmu_ops = {
 	.device_group		= arm_smmu_device_group,
 	.of_xlate		= arm_smmu_of_xlate,
 	.get_resv_regions	= arm_smmu_get_resv_regions,
-	.remove_dev_pasid	= arm_smmu_remove_dev_pasid,
 	.dev_enable_feat	= arm_smmu_dev_enable_feature,
 	.dev_disable_feat	= arm_smmu_dev_disable_feature,
 	.page_response		= arm_smmu_page_response,
-- 
2.34.1


