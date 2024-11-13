Return-Path: <kvm+bounces-31754-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AB4379C714B
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 14:48:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 61E881F21D6B
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 13:48:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 184BF1EB39;
	Wed, 13 Nov 2024 13:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hctZ7xpX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 844841F77BD
	for <kvm@vger.kernel.org>; Wed, 13 Nov 2024 13:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731505578; cv=none; b=GJlb2DwW2CdP/UTqRyyB36CDNuAynfqIRLZP7PnW93ZFkmUugw6x1rScVcZLG60aDXEhg07vhGeIU5jD5Vi7Tcz22/jM4quHdWqP+U1KIuo+LiGQ56yq259bJQ3xdW7V0w3P5HXm7SUIujcV7UxOeUB9jRO1xUyn//flw6RE3cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731505578; c=relaxed/simple;
	bh=4b8Io+s7nkbd6XDJjuILasFFqi95yUE1DNtobrQoHh0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PJJZHDH6bakcyVxh1E8E3UWqt3+cww3/vQl0/+5G7vqQIv8HiB5IvZotyius8ieb9FHsghDhTSfJNaJtyYeQyLfdY/2Z4hJaFJEWHziRFEK0XgKfFVaqo0wuLPhEeCdBHNMgZiedANQ8PKkoZA9/oMuaWJFmmJ+oH+w5R6thjw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hctZ7xpX; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731505577; x=1763041577;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4b8Io+s7nkbd6XDJjuILasFFqi95yUE1DNtobrQoHh0=;
  b=hctZ7xpXCxxXSQR0s2j8WTMkn+u3cUsUM2EBCh+3pDeWgcYdbHZF8KKV
   KFhaGs1UdIfDRbmC2mYyGHIlhRpmHWG+ZbEJXl/lLwr95jzXyBrbbuvlD
   jg8kQsYJTPMQ3hVrST4tM8GfOrFz0tK+NCQPqAa6Qao/f7np953KEgBAs
   8A1muQSWo5wVI+uT93QvVD2m0P2+ub6gsA5c9os0DfmL9eDcfdjPmpiuf
   YFE9Jf7Deq0SuHFLHIFmF1kSquxEoG+dLoS3+YTvo4eU4jpxHziNqyPs8
   fTkgsNFdTUUshFj8SwGy+G3bH4bAvChW+aOWasa7TzjZiMtNV8LZEpMla
   g==;
X-CSE-ConnectionGUID: Kd9oIraERQqrEimwK2gzPQ==
X-CSE-MsgGUID: Sw3Ebc4kQ6CjW7EeMVephA==
X-IronPort-AV: E=McAfee;i="6700,10204,11254"; a="42025687"
X-IronPort-AV: E=Sophos;i="6.12,151,1728975600"; 
   d="scan'208";a="42025687"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2024 05:46:15 -0800
X-CSE-ConnectionGUID: 9U++DY4JSdGiGizApnQzZA==
X-CSE-MsgGUID: 30Lp228rQTW+HdTVERX7Fg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,151,1728975600"; 
   d="scan'208";a="87445584"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmviesa006.fm.intel.com with ESMTP; 13 Nov 2024 05:46:14 -0800
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
Subject: [PATCH v5 1/7] iommu: Prevent pasid attach if no ops->remove_dev_pasid
Date: Wed, 13 Nov 2024 05:46:07 -0800
Message-Id: <20241113134613.7173-2-yi.l.liu@intel.com>
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

driver should implement both set_dev_pasid and remove_dev_pasid op, otherwise
it is a problem how to detach pasid. In reality, it is impossible that an
iommu driver implements set_dev_pasid() but no remove_dev_pasid() op. However,
it is better to check it.

Move the group check to be the first as dev_iommu_ops() may fail when there
is no valid group. Also take the chance to remove the dev_has_iommu() check
as it is duplicated to the group check.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/iommu/iommu.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 13fcd9d8f2df..b743fe612441 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -3354,16 +3354,19 @@ int iommu_attach_device_pasid(struct iommu_domain *domain,
 	/* Caller must be a probed driver on dev */
 	struct iommu_group *group = dev->iommu_group;
 	struct group_device *device;
+	const struct iommu_ops *ops;
 	int ret;
 
-	if (!domain->ops->set_dev_pasid)
-		return -EOPNOTSUPP;
-
 	if (!group)
 		return -ENODEV;
 
-	if (!dev_has_iommu(dev) || dev_iommu_ops(dev) != domain->owner ||
-	    pasid == IOMMU_NO_PASID)
+	ops = dev_iommu_ops(dev);
+
+	if (!domain->ops->set_dev_pasid ||
+	    !ops->remove_dev_pasid)
+		return -EOPNOTSUPP;
+
+	if (ops != domain->owner || pasid == IOMMU_NO_PASID)
 		return -EINVAL;
 
 	mutex_lock(&group->mutex);
-- 
2.34.1


