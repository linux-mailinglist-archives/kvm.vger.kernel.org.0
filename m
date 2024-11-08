Return-Path: <kvm+bounces-31257-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F0079C1C9D
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 13:04:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 344661F244B3
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 12:04:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BD451E7C19;
	Fri,  8 Nov 2024 12:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FkYfO9Nn"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FD311E570A
	for <kvm@vger.kernel.org>; Fri,  8 Nov 2024 12:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731067477; cv=none; b=oKu3WhvXdcLRrYb2bYplyT32mPRlO3jm7L1DzLnK2tGHfONWwTP872QkrvJUN0i37cKF11Pzxx5KJZ82iHs2KU6eYdR401ctYmo5T4cISBdcDKK6RvQOaiXy/UFOA+o+edxfBe8O3zi94nl9DgUbo3626aUC1T/ljMD6G0Njsw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731067477; c=relaxed/simple;
	bh=Ztqkn6YB5KTFuQ7dpEC8XYRiiVU3SJZ6g0Npm58rDr0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=iWh+76v0dZ5dVlx6ZcsmQImrkOawC9u0Iyecrb8wzFEZ//fXxMFfFPn6Vd5b3zLTJgXKXX31xI+r5hYN829ATwNt81dOw3FzclW3vpd8+zriPIj45g4o7TeHBALww/9BRLbCocRuiGsKJcOahfQeF3851i8sVJgbCX5R/OT5nH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FkYfO9Nn; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731067475; x=1762603475;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Ztqkn6YB5KTFuQ7dpEC8XYRiiVU3SJZ6g0Npm58rDr0=;
  b=FkYfO9NnDvtsu7mNHd/RhdrH2nBOG3vr64AAsFCMsNEpIt0VzjO56d68
   wckjTZmnQQ1iTuUqZWHTeDgZcJHtmC01UKdGJnhpIO3leRAquwK9nZnp0
   7u4n6wdcjrUIvRavsjdmxadCTxvppXJmtv9EmeoHeGy5pd7I/x1JATnm9
   xq2tNniUC4c7VOisCpKQo2u1jUEwxovh40NV0YQD7GKibo8/q1RM418m3
   4HjwA0e/FqP1sYsmFBNR/vqnoyFciYcp0sTBBOQ3dwW0wcqH3oM9qvo81
   bnzIEjAq+RPrTkkoZIIFDu0zTxl18gRJRXOxwB5yOYPFGXOTdHP0e4Gmn
   A==;
X-CSE-ConnectionGUID: UCd46McQRTS2PfnlAyQMhQ==
X-CSE-MsgGUID: sIsU9gtBRTm99dBtEzlFWw==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="31116423"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="31116423"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2024 04:04:32 -0800
X-CSE-ConnectionGUID: BvjJf2gaSj6pwhLWq9KBvA==
X-CSE-MsgGUID: CKvdFd2ySC21KJndqgmptw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,137,1728975600"; 
   d="scan'208";a="85679028"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmviesa008.fm.intel.com with ESMTP; 08 Nov 2024 04:04:30 -0800
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
Subject: [PATCH v4 3/7] iommu: Detaching pasid by attaching to the blocked_domain
Date: Fri,  8 Nov 2024 04:04:23 -0800
Message-Id: <20241108120427.13562-4-yi.l.liu@intel.com>
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

The iommu drivers are on the way to detach pasid by attaching to the blocked
domain. However, this cannot be done in one shot. During the transition, iommu
core would select between the remove_dev_pasid op and the blocked domain.

Suggested-by: Kevin Tian <kevin.tian@intel.com>
Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/iommu/iommu.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 819c6e0188d5..6fd4b904f270 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -3302,8 +3302,18 @@ static void iommu_remove_dev_pasid(struct device *dev, ioasid_t pasid,
 				   struct iommu_domain *domain)
 {
 	const struct iommu_ops *ops = dev_iommu_ops(dev);
+	struct iommu_domain *blocked_domain = ops->blocked_domain;
+	int ret = 1;
 
-	ops->remove_dev_pasid(dev, pasid, domain);
+	if (blocked_domain && blocked_domain->ops->set_dev_pasid) {
+		ret = blocked_domain->ops->set_dev_pasid(blocked_domain,
+							 dev, pasid, domain);
+	} else {
+		ops->remove_dev_pasid(dev, pasid, domain);
+		ret = 0;
+	}
+
+	WARN_ON(ret);
 }
 
 static int __iommu_set_group_pasid(struct iommu_domain *domain,
@@ -3361,7 +3371,9 @@ int iommu_attach_device_pasid(struct iommu_domain *domain,
 	int ret;
 
 	if (!domain->ops->set_dev_pasid ||
-	    !ops->remove_dev_pasid)
+	    (!ops->remove_dev_pasid &&
+	     (!ops->blocked_domain ||
+	      !ops->blocked_domain->ops->set_dev_pasid)))
 		return -EOPNOTSUPP;
 
 	if (!group)
-- 
2.34.1


