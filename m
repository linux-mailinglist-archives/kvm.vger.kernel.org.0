Return-Path: <kvm+bounces-30530-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7591B9BB5CC
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 14:21:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EF34E1F21FC2
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 13:21:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6835578C6C;
	Mon,  4 Nov 2024 13:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Btik7K/h"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D97342AA6
	for <kvm@vger.kernel.org>; Mon,  4 Nov 2024 13:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730726444; cv=none; b=n2ZKG79MoQ/up7sz+TyVPBXPq9581pMxHuVORj13bIuLafH5+23Rw01ZwkFoL+YPkoROo5Fi1GZFmjokKrvUrslNeSYmscIKKLsIcbwwfQQK1NLWr79qM6NaPF1tSGllvVwYFXxHKtfzXdALdW1GW3cCwuyfVImD+Ce3I+BFYPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730726444; c=relaxed/simple;
	bh=DBZ4yu49lmyJHEN3ldOTte/tR4q3nt/9R5Z+0qj5pig=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UA5z1lALqpQ9D6og8W4nnheJsmXYTS+ejjxF8bZQCb5tYrnMYMUFbaJeP1uVLtsAHfXVItm2senrlQ6jcv/Oz2DBu1MA0YQH1JPKL8dQ7tAat3Ts0pAO8S1B+yaG47kgh0ZAlntwQ45UB6JnkHh7F/onw0bqXzBfMCUODSzf61o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Btik7K/h; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730726444; x=1762262444;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DBZ4yu49lmyJHEN3ldOTte/tR4q3nt/9R5Z+0qj5pig=;
  b=Btik7K/hGrZaplcMlEux5zmaZxEtLp0XGk+nZSyIQhgLDHdX5zLwB4cn
   1DuEl74qk9wVaZur6Rss869RlcyQbCAVGLGW5a+CKZTsag43QIlw7wUFy
   V38ld5ylxygzDvfRIO9fMV8Og4lZjVjkfPZrZm2AytdpuGk2HBksS4wiV
   87dzpFAneeggDDq3E0qw8yPpLlX0Hsq4/lCEbIuUBXSx5LCRjaxpcXC0+
   spJOj6jQItA4dQEA22jCYuUel2zjYW9NcBshA+gcTxvMSeKy6w4gedpSX
   NSLLQurTCW3dLN25biBrbnL/qCeSXAHYCsxyiGxu2K8F4/wvRw+IbMWuy
   w==;
X-CSE-ConnectionGUID: yBtM3S42Qmmf7kfO04Sg+g==
X-CSE-MsgGUID: brC6PHPkTNWKXJcJLaYiUw==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="47883309"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="47883309"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 05:20:43 -0800
X-CSE-ConnectionGUID: Rn7m0x/hSHSs+jgA0pAw3Q==
X-CSE-MsgGUID: l5B6/ourQKyZVUACJxvUHg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,257,1725346800"; 
   d="scan'208";a="84099754"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orviesa007.jf.intel.com with ESMTP; 04 Nov 2024 05:20:43 -0800
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
Subject: [PATCH v3 7/7] iommu: Remove the remove_dev_pasid op
Date: Mon,  4 Nov 2024 05:20:33 -0800
Message-Id: <20241104132033.14027-8-yi.l.liu@intel.com>
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

The iommu drivers that supports PASID have supported attaching pasid to the
blocked_domain, hence remove the remove_dev_pasid op from the iommu_ops.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/iommu/iommu.c | 17 ++++-------------
 include/linux/iommu.h |  5 -----
 2 files changed, 4 insertions(+), 18 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index e8b2850cc61f..53f8e60acf30 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -3405,17 +3405,9 @@ static void iommu_remove_dev_pasid(struct device *dev, ioasid_t pasid,
 {
 	const struct iommu_ops *ops = dev_iommu_ops(dev);
 	struct iommu_domain *blocked_domain = ops->blocked_domain;
-	int ret = 1;
 
-	if (blocked_domain && blocked_domain->ops->set_dev_pasid) {
-		ret = blocked_domain->ops->set_dev_pasid(blocked_domain,
-							 dev, pasid, domain);
-	} else if (ops->remove_dev_pasid) {
-		ops->remove_dev_pasid(dev, pasid, domain);
-		ret = 0;
-	}
-
-	WARN_ON(ret);
+	WARN_ON(blocked_domain->ops->set_dev_pasid(blocked_domain,
+						   dev, pasid, domain));
 }
 
 static int __iommu_set_group_pasid(struct iommu_domain *domain,
@@ -3474,9 +3466,8 @@ int iommu_attach_device_pasid(struct iommu_domain *domain,
 	int ret;
 
 	if (!domain->ops->set_dev_pasid ||
-	    (!ops->remove_dev_pasid &&
-	     (!ops->blocked_domain ||
-	      !ops->blocked_domain->ops->set_dev_pasid)))
+	    !ops->blocked_domain ||
+	    !ops->blocked_domain->ops->set_dev_pasid)
 		return -EOPNOTSUPP;
 
 	if (!group)
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 2ec0c9915aa5..257b1a53879a 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -537,9 +537,6 @@ static inline int __iommu_copy_struct_from_user_array(
  *		- IOMMU_DOMAIN_DMA: must use a dma domain
  *		- 0: use the default setting
  * @default_domain_ops: the default ops for domains
- * @remove_dev_pasid: Remove any translation configurations of a specific
- *                    pasid, so that any DMA transactions with this pasid
- *                    will be blocked by the hardware.
  * @pgsize_bitmap: bitmap of all possible supported page sizes
  * @owner: Driver module providing these ops
  * @identity_domain: An always available, always attachable identity
@@ -586,8 +583,6 @@ struct iommu_ops {
 			      struct iommu_page_response *msg);
 
 	int (*def_domain_type)(struct device *dev);
-	void (*remove_dev_pasid)(struct device *dev, ioasid_t pasid,
-				 struct iommu_domain *domain);
 
 	const struct iommu_domain_ops *default_domain_ops;
 	unsigned long pgsize_bitmap;
-- 
2.34.1


