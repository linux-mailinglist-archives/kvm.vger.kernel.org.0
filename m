Return-Path: <kvm+bounces-31261-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D031F9C1CA1
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 13:05:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 962F128421C
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 12:05:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EE111E884E;
	Fri,  8 Nov 2024 12:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HWdhtepZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C75E81E2834
	for <kvm@vger.kernel.org>; Fri,  8 Nov 2024 12:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731067484; cv=none; b=JqAtHjuhU234DON+8H6sX0v944oWjEVAehCMr65D2TTV0jF0vUWeLaAOg59eE7p52lkAP8svSeqt3v7n4pthc/tGb/SsD+3AmIJiqjhmLxigu6F+fOX5PBcKds6nu7pwZQQuDq5nfYO9bUIUGANQJnINm3623ZzDXu4c2MdRekg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731067484; c=relaxed/simple;
	bh=2s1wQPEzFpmggA2jawJvQiccvDr/ayphBD/48j9DeAE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=IX9gjvePcUGc7zhyCT1glCNWg3rk96v7N37nGQkHXNRqSXLhWROUxMhH4A2ON9cZTB1b8OTWrC2ThnBk0cocA8fmkNpuxgd64sBBIiUCMd7ElukQSFZYH0QPyKqtWNLwZQqD4B36RcPp9mwsMMEOaIZM66VDwJB7XVMA4jxZCik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HWdhtepZ; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731067484; x=1762603484;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2s1wQPEzFpmggA2jawJvQiccvDr/ayphBD/48j9DeAE=;
  b=HWdhtepZFf9CMY/6YSUc1S/JR/FoDzme9YgbmCyQfHHNmIqFrI0Z78Bv
   aCjoSguv0caP0LDwqUzenb9CBLdQm+I/QiKeHBRz2/3k7Ic6h7I5c+1tk
   1J7m0SWt3JDZX81OSIAvE4Gz7hZnLnQVjmYKuX5CmKzYBadJpaZ0mvFkO
   cImcRPo9BKghT1ykMJJP2c1OUgXsxi0AchF+2e3juIDd4djAFI1z4Euk2
   QeY4MqXzdsLueVomQyeVvHt177gsfh9aCdc0w6uxmQ7MrniGzJoY5ciJT
   0lhnMIVD+VC0Qh2J9xHmCJey4zTDfCnup3BPnBv2DT0rxLZ4QQ7XW26pW
   g==;
X-CSE-ConnectionGUID: r+j/jhg5Sj2Gx+4kxTzQ8w==
X-CSE-MsgGUID: +xae70bfScGhelrkccjU4Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="31116455"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="31116455"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2024 04:04:35 -0800
X-CSE-ConnectionGUID: x/xJPLzuR/OL30nH6Ryz0g==
X-CSE-MsgGUID: LFS4smFFRXO+0Ncx01WDww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,137,1728975600"; 
   d="scan'208";a="85679056"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmviesa008.fm.intel.com with ESMTP; 08 Nov 2024 04:04:34 -0800
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
Subject: [PATCH v4 7/7] iommu: Remove the remove_dev_pasid op
Date: Fri,  8 Nov 2024 04:04:27 -0800
Message-Id: <20241108120427.13562-8-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241108120427.13562-1-yi.l.liu@intel.com>
References: <20241108120427.13562-1-yi.l.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The iommu drivers that supports PASID have supported attaching pasid to the
blocked_domain, hence remove the remove_dev_pasid op from the iommu_ops.

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/iommu/iommu.c | 17 ++++-------------
 include/linux/iommu.h |  5 -----
 2 files changed, 4 insertions(+), 18 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 6fd4b904f270..e970893168d8 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -3303,17 +3303,9 @@ static void iommu_remove_dev_pasid(struct device *dev, ioasid_t pasid,
 {
 	const struct iommu_ops *ops = dev_iommu_ops(dev);
 	struct iommu_domain *blocked_domain = ops->blocked_domain;
-	int ret = 1;
 
-	if (blocked_domain && blocked_domain->ops->set_dev_pasid) {
-		ret = blocked_domain->ops->set_dev_pasid(blocked_domain,
-							 dev, pasid, domain);
-	} else {
-		ops->remove_dev_pasid(dev, pasid, domain);
-		ret = 0;
-	}
-
-	WARN_ON(ret);
+	WARN_ON(blocked_domain->ops->set_dev_pasid(blocked_domain,
+						   dev, pasid, domain));
 }
 
 static int __iommu_set_group_pasid(struct iommu_domain *domain,
@@ -3371,9 +3363,8 @@ int iommu_attach_device_pasid(struct iommu_domain *domain,
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
index 0c3bfb66dc7c..1d033121bf00 100644
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


