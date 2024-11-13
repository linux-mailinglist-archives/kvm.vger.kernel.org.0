Return-Path: <kvm+bounces-31759-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 315F89C7155
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 14:49:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E9E6A28B494
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 13:49:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43E192022CD;
	Wed, 13 Nov 2024 13:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VLsrJdtJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F30621FF035
	for <kvm@vger.kernel.org>; Wed, 13 Nov 2024 13:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731505581; cv=none; b=MDBsrnegQxR5c4jo78T7svw/AxLfkzjId+LALxFp3wUSVIDPN63nPm0Q+RxYbeCQhos2uHjh5Eojju4Q3ewi/WoPUbolLJPBwxlpfy9yvBfxrOzmSucsk/zKb9xwyfNExpAq1TZCrThaTuQGQiRKZ+GsBWtAqvPQ/AIgrrS/ums=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731505581; c=relaxed/simple;
	bh=Mejinn7dwxrWFJJxi0gYE+6CIjdQ4PZ7QCUJBDIlsZY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=II48trqZhHf0ZTc9QD8Z5v83xqh5FXmqtA5kLmGjTtk5r5na+K5jblOtKBdBfNuSMEAC6YgsILcjpyrSP0ObrPDmMEz83bb1v1Og5TEhKGBleXkv06cSi2YrbcErqviWklS5Gmxc86+On/YXyOybRFhNUELzKU8RPqdl3Lxi08w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VLsrJdtJ; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731505580; x=1763041580;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Mejinn7dwxrWFJJxi0gYE+6CIjdQ4PZ7QCUJBDIlsZY=;
  b=VLsrJdtJegLlYwNWo/AiV79Dpan/K2Y8BzI0Cb/6qCfRKKfrdCohRjEN
   3DZSQniHlbnhl6OJv4itsVXiQJcHYr++oBesLcQxS+3nL3khbVBkpua81
   1n4hnqLClq1n1VM8PMXRZVhWg7HhdCZxxlNAr5X2jA76zjGsDSTMTlfbe
   xA4391qmDkQskls99OqsKglQiw0SwT0sUEadg7mVNIZGAHjmpmj2QRw9l
   dmMkx9F07V2BNwABGbkP6fouIH1C7yHVDo1Rhel0uE/rRJ96POCfExx+E
   LYUG+BCUhudHBMxoK7HjDzlaC8R4SsZK7aoRz2aDarDh4JmWatnyCudbe
   w==;
X-CSE-ConnectionGUID: oZ95hqt8R2KQ8KtNh8hL5g==
X-CSE-MsgGUID: Tmj+I6K4SWWBFoif2MMrag==
X-IronPort-AV: E=McAfee;i="6700,10204,11254"; a="42025726"
X-IronPort-AV: E=Sophos;i="6.12,151,1728975600"; 
   d="scan'208";a="42025726"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2024 05:46:17 -0800
X-CSE-ConnectionGUID: vJiFkR5CROu4rv9N5ga33w==
X-CSE-MsgGUID: swwAPy1JSyePTy0ZfrT4bg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,151,1728975600"; 
   d="scan'208";a="87445608"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmviesa006.fm.intel.com with ESMTP; 13 Nov 2024 05:46:16 -0800
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
Subject: [PATCH v5 6/7] iommu/amd: Make the blocked domain support PASID
Date: Wed, 13 Nov 2024 05:46:12 -0800
Message-Id: <20241113134613.7173-7-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241113134613.7173-1-yi.l.liu@intel.com>
References: <20241113134613.7173-1-yi.l.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The blocked domain can be extended to park PASID of a device to be the
DMA blocking state. By this the remove_dev_pasid() op is dropped.

Remove PASID from old domain and device GCR3 table. No need to attach
PASID to the blocked domain as clearing PASID from GCR3 table will make
sure all DMAs for that PASID are blocked.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/iommu/amd/iommu.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 5ce8e6504ba7..d216313b6d44 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -2468,10 +2468,19 @@ static int blocked_domain_attach_device(struct iommu_domain *domain,
 	return 0;
 }
 
+static int blocked_domain_set_dev_pasid(struct iommu_domain *domain,
+					struct device *dev, ioasid_t pasid,
+					struct iommu_domain *old)
+{
+	amd_iommu_remove_dev_pasid(dev, pasid, old);
+	return 0;
+}
+
 static struct iommu_domain blocked_domain = {
 	.type = IOMMU_DOMAIN_BLOCKED,
 	.ops = &(const struct iommu_domain_ops) {
 		.attach_dev     = blocked_domain_attach_device,
+		.set_dev_pasid  = blocked_domain_set_dev_pasid,
 	}
 };
 
@@ -2894,7 +2903,6 @@ const struct iommu_ops amd_iommu_ops = {
 	.def_domain_type = amd_iommu_def_domain_type,
 	.dev_enable_feat = amd_iommu_dev_enable_feature,
 	.dev_disable_feat = amd_iommu_dev_disable_feature,
-	.remove_dev_pasid = amd_iommu_remove_dev_pasid,
 	.page_response = amd_iommu_page_response,
 	.default_domain_ops = &(const struct iommu_domain_ops) {
 		.attach_dev	= amd_iommu_attach_device,
-- 
2.34.1


