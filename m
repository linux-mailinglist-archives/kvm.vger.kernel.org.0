Return-Path: <kvm+bounces-30524-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 238E69BB5C6
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 14:21:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 555081C21455
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 13:21:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD6D122092;
	Mon,  4 Nov 2024 13:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FM1HbV1B"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8023A33FE
	for <kvm@vger.kernel.org>; Mon,  4 Nov 2024 13:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730726439; cv=none; b=JzfRQsll+Sru2teQxqCSOc5xcezAYE/wLFgFl1FEFpCFmO960Pgnb9V10Y2SzBvAMBa1jJYOlWKqtmb6BVSWCbVVTz1IvD4TPte6L9+5xhlhAVoEtjb7giyUiC4c++m4UCS3wzvz9ZlmBWF0zs5P4wB4Nk+RFbiVNO5+uzGPaMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730726439; c=relaxed/simple;
	bh=xkEJ7LX4Du0vjHFbotmFTpDVY1H3dZx3uqknKCSEr3g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=S7RgTxvQjT9U26bPlzby0u/sLW94A8LjZ6NMvrgTkYWsAiMBBU6GyCQ+PEXYQnjdswMn7J8OciKQuKhU66pjKJIMKQyGI1OxPzUqzLB5xHOPWfDtwPBIWg4AME8ZyKV+zp/aydhXmkvW6/c+f+Qh/9KyHo8z/gSqzonETUBlGv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FM1HbV1B; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730726438; x=1762262438;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xkEJ7LX4Du0vjHFbotmFTpDVY1H3dZx3uqknKCSEr3g=;
  b=FM1HbV1BFT2OSHTq76sj22sCzdkQhk5Rxf3he62mjSpje8mVk1z4nIQ6
   rZ49vlEQc2ibPTosEAhX6agrCmZX0jFisVmHcaxMxssBgdAHuIUTPnhoP
   m5PcQuFLJ50RLomnCjNstPB4McvkJ4oywkli6PcwaRIkv1glPyjrE19p1
   yzztOZRfV/i830p0dJ8ZnExk+w5K8joyI4cNL5jSMdTS3pPNfpRGAhl1u
   Vv/vir+ha1idXbmHKjnbmcyedMV3OpEK17DfL7YhGxcs9/7njmoi+Bbln
   KneU+5RaTqrsBw/uWwXxMBUsoCdGOza1+zhrsX9DEMWnYafkObJ6qw86n
   Q==;
X-CSE-ConnectionGUID: mmIYP6hzTYW77JkY+1Y2Cg==
X-CSE-MsgGUID: yTRW7ADfTeeZToork9LoqQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="47883260"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="47883260"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 05:20:37 -0800
X-CSE-ConnectionGUID: LBIDXiKSRn6eAT0gBvwFzQ==
X-CSE-MsgGUID: UR61g/0kTDK9fFzJKZ6Qzw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,257,1725346800"; 
   d="scan'208";a="84099710"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orviesa007.jf.intel.com with ESMTP; 04 Nov 2024 05:20:36 -0800
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
Subject: [PATCH v3 1/7] iommu: Prevent pasid attach if no ops->remove_dev_pasid
Date: Mon,  4 Nov 2024 05:20:27 -0800
Message-Id: <20241104132033.14027-2-yi.l.liu@intel.com>
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

driver should implement both set_dev_pasid and remove_dev_pasid op, otherwise
it is a problem how to detach pasid. In reality, it is impossible that an
iommu driver implements set_dev_pasid() but no remove_dev_pasid() op. However,
it is better to check it.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/iommu/iommu.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index ea6b4a96186d..866559bbc4e4 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -3454,11 +3454,13 @@ int iommu_attach_device_pasid(struct iommu_domain *domain,
 			      struct iommu_attach_handle *handle)
 {
 	/* Caller must be a probed driver on dev */
+	const struct iommu_ops *ops = dev_iommu_ops(dev);
 	struct iommu_group *group = dev->iommu_group;
 	struct group_device *device;
 	int ret;
 
-	if (!domain->ops->set_dev_pasid)
+	if (!domain->ops->set_dev_pasid ||
+	    !ops->remove_dev_pasid)
 		return -EOPNOTSUPP;
 
 	if (!group)
-- 
2.34.1


