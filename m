Return-Path: <kvm+bounces-26077-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CC5B970703
	for <lists+kvm@lfdr.de>; Sun,  8 Sep 2024 13:43:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A66231C20FF0
	for <lists+kvm@lfdr.de>; Sun,  8 Sep 2024 11:43:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B316B15C143;
	Sun,  8 Sep 2024 11:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gZrOrMxK"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B90692E634
	for <kvm@vger.kernel.org>; Sun,  8 Sep 2024 11:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725795781; cv=none; b=mQVtCNkQPUM5HtB9QayYX9An2VUy22k65r5etDsxEOsbR8SXCLWnRxaVitsz7Tl1D2cIdm8K0immu/8naxdhCF83XGxO5fXRFl2nTg3KncX+Hs9p5bCjTGcA0HsWJzKOp+/nLOLqzprDGgoKR8TRKc7JHQbFZI3CT0nDLy/nw1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725795781; c=relaxed/simple;
	bh=g/SSBnmxr6BtSLGzjLNz5QJEGxfg2sdMnLHrOgBNYGc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=brsQ1xvJYDRlHatyk/aJ8x/07n9Im9/M97Mex9MkGxsOchM+6xukScKF+nIsFUqPLL7jndJrol1FKXGOCw6yATc9WrWFxGLsDgB63VZRDZe2a7PPKzSuRpycEXf9iAOuxxccEVX3RfEcVRGk0MBRmYT7zlxmgLqalkTo9Okv/Vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gZrOrMxK; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725795780; x=1757331780;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=g/SSBnmxr6BtSLGzjLNz5QJEGxfg2sdMnLHrOgBNYGc=;
  b=gZrOrMxKDPQHTm6aVN9HY+662t0GR0hugaupIQPEK37ZSwOTx1x0MTzD
   5xSm4a3y5loUCaLcSizXa0DafuGTe6TgeY1EfP0TYZksR1R4rTzSjfi1z
   gnnwvXTc6dHal3qPaHP/SvDBbplAxrDMklvMpuydtifolrAL3Yjv2jLtG
   f9WW4dOBs2NE2KfvUZ/CQOiGiHszNaoH05Ly7Wbaz/oUY5clL57gcIrLk
   MFqYrGBsfcsGWfqZqV6EJH76FMPZMzPVmI3hmYh8GOByP8SkUjYjSPouC
   szm9gPN6hEMbcf1rYr3YEbfQ4IbcYfb2HsGabpTC/ZkH72ryZP4aX9Nfq
   Q==;
X-CSE-ConnectionGUID: ijXWAmO9TlyVjWu3rXf0NA==
X-CSE-MsgGUID: hkONm03iRo+VLTYnsbUCdQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11188"; a="27418269"
X-IronPort-AV: E=Sophos;i="6.10,212,1719903600"; 
   d="scan'208";a="27418269"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2024 04:42:59 -0700
X-CSE-ConnectionGUID: GacXIldjSdiqbvs+224ZLQ==
X-CSE-MsgGUID: Z//FvtdbT9K4tu+k/5j3Iw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,212,1719903600"; 
   d="scan'208";a="89668164"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmviesa002.fm.intel.com with ESMTP; 08 Sep 2024 04:42:58 -0700
From: Yi Liu <yi.l.liu@intel.com>
To: joro@8bytes.org,
	jgg@nvidia.com,
	kevin.tian@intel.com
Cc: nicolinc@nvidia.com,
	kvm@vger.kernel.org,
	yi.l.liu@intel.com,
	iommu@lists.linux.dev,
	baolu.lu@linux.intel.com
Subject: [PATCH 1/2] iommufd: Avoid duplicated __iommu_group_set_core_domain() call
Date: Sun,  8 Sep 2024 04:42:55 -0700
Message-Id: <20240908114256.979518-2-yi.l.liu@intel.com>
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

For the fault-capable hwpts, the iommufd_hwpt_detach_device() calls both
iommufd_fault_domain_detach_dev() and iommu_detach_group(). This would have
duplicated __iommu_group_set_core_domain() call since both functions call
it in the end. This looks no harm as the __iommu_group_set_core_domain()
returns if the new domain equals to the existing one. But it makes sense to
avoid such duplicated calls in caller side.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/iommu/iommufd/iommufd_private.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/iommufd/iommufd_private.h b/drivers/iommu/iommufd/iommufd_private.h
index 92efe30a8f0d..1141c0633dc9 100644
--- a/drivers/iommu/iommufd/iommufd_private.h
+++ b/drivers/iommu/iommufd/iommufd_private.h
@@ -490,8 +490,10 @@ static inline int iommufd_hwpt_attach_device(struct iommufd_hw_pagetable *hwpt,
 static inline void iommufd_hwpt_detach_device(struct iommufd_hw_pagetable *hwpt,
 					      struct iommufd_device *idev)
 {
-	if (hwpt->fault)
+	if (hwpt->fault) {
 		iommufd_fault_domain_detach_dev(hwpt, idev);
+		return;
+	}
 
 	iommu_detach_group(hwpt->domain, idev->igroup->group);
 }
-- 
2.34.1


