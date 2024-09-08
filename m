Return-Path: <kvm+bounces-26076-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 19F01970702
	for <lists+kvm@lfdr.de>; Sun,  8 Sep 2024 13:43:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 15EC81C21183
	for <lists+kvm@lfdr.de>; Sun,  8 Sep 2024 11:43:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AE1615C13D;
	Sun,  8 Sep 2024 11:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="G5nlDl2g"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBA8B157A4D
	for <kvm@vger.kernel.org>; Sun,  8 Sep 2024 11:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725795781; cv=none; b=g+1H+9SQ6i6KUrYjTNw0JDArMPdoHjxAn20896kDtuicckoPuQEzTtOsFzD79twCFucdk5bvL4dGqNL88HEIz3ba94c8WHNgocN85VcVFCdDs7iUBWRkrG4rx1wwN+TTEPEF+NpVgw/JArrnBJ8unItna/FBTkodaIwkomPJOAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725795781; c=relaxed/simple;
	bh=6D32PgrLosIh6OCfg0v2IHbZTTFBABwzW9sc9tl2E9s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DuaBLsbuBEv6kBcczXL26XmuUfvTkyVTtQIhpg9+9qEN6tXlH+KdOc1Gbltz9wNm2dwrRB4ViUcez5Hw48V5ndbX/TFOu6OubZb3dM2gYYaNabPxO6wssdReNA3JSCpRgC3hA54WSFuu5s4SY0anwR+x5dDQGiHAmtrrC8Zzs6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=G5nlDl2g; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725795780; x=1757331780;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6D32PgrLosIh6OCfg0v2IHbZTTFBABwzW9sc9tl2E9s=;
  b=G5nlDl2g+ZYwlbcQgoWDk0/3J9NgSJUfH8R+ctIPjYdswC2ynF7ReU+v
   fmrD6VySdGHUaE8Kt+ZSdIvszUb/MPLPAQ5WxiTBGA6yssm7qKU3Xl7ek
   5k5quHtNH9r54mVHsDyp/04e1xWD2sfWamANXbZFlM8/pVd6ltyIfVnq/
   xNjuA1aAq7F7kwpDiawTcMt8v57DH2lqQneyBvF1E6irkCSe5QK6fNRx+
   zBwWt8+eLzDAY5mm03Mlv/tU60E2KZCfuKL2/wADRkdh6omm1x5KLNw3W
   7tME0Vxvgr0FyeQs2qkNOt2FZnLhtoWPuAFDthcpJVgUyKpQ4QZLlfRkI
   w==;
X-CSE-ConnectionGUID: IoBpp/mSQf2czxopQW5biQ==
X-CSE-MsgGUID: 01owSwnjRiOI4j3/HSUO5g==
X-IronPort-AV: E=McAfee;i="6700,10204,11188"; a="27418274"
X-IronPort-AV: E=Sophos;i="6.10,212,1719903600"; 
   d="scan'208";a="27418274"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2024 04:42:59 -0700
X-CSE-ConnectionGUID: b3L7dxTWQXG7yM1C1n4FVA==
X-CSE-MsgGUID: S6ibyVC8Q5S2dKesRJIsVg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,212,1719903600"; 
   d="scan'208";a="89668168"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmviesa002.fm.intel.com with ESMTP; 08 Sep 2024 04:42:59 -0700
From: Yi Liu <yi.l.liu@intel.com>
To: joro@8bytes.org,
	jgg@nvidia.com,
	kevin.tian@intel.com
Cc: nicolinc@nvidia.com,
	kvm@vger.kernel.org,
	yi.l.liu@intel.com,
	iommu@lists.linux.dev,
	baolu.lu@linux.intel.com
Subject: [PATCH 2/2] iommu: Set iommu_attach_handle->domain in core
Date: Sun,  8 Sep 2024 04:42:56 -0700
Message-Id: <20240908114256.979518-3-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240908114256.979518-1-yi.l.liu@intel.com>
References: <20240908114256.979518-1-yi.l.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The IOMMU core sets the iommu_attach_handle->domain for the
iommu_attach_group_handle() path, while the iommu_replace_group_handle()
sets it on the caller side. Make the two paths aligned on it.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/iommu/iommu.c         | 1 +
 drivers/iommu/iommufd/fault.c | 1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index ed6c5cb60c5a..83c8e617a2c5 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -3578,6 +3578,7 @@ int iommu_replace_group_handle(struct iommu_group *group,
 		ret = xa_reserve(&group->pasid_array, IOMMU_NO_PASID, GFP_KERNEL);
 		if (ret)
 			goto err_unlock;
+		handle->domain = new_domain;
 	}
 
 	ret = __iommu_group_set_domain(group, new_domain);
diff --git a/drivers/iommu/iommufd/fault.c b/drivers/iommu/iommufd/fault.c
index a643d5c7c535..c4715261f2c7 100644
--- a/drivers/iommu/iommufd/fault.c
+++ b/drivers/iommu/iommufd/fault.c
@@ -161,7 +161,6 @@ static int __fault_domain_replace_dev(struct iommufd_device *idev,
 		if (!handle)
 			return -ENOMEM;
 
-		handle->handle.domain = hwpt->domain;
 		handle->idev = idev;
 		ret = iommu_replace_group_handle(idev->igroup->group,
 						 hwpt->domain, &handle->handle);
-- 
2.34.1


