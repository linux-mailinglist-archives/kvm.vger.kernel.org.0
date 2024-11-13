Return-Path: <kvm+bounces-31755-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D4DA19C714C
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 14:48:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8D8491F22245
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 13:48:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF4951F77BD;
	Wed, 13 Nov 2024 13:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EMXLJKEZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 776631DED47
	for <kvm@vger.kernel.org>; Wed, 13 Nov 2024 13:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731505579; cv=none; b=uzy7R2NUsUjCxVwhH989aDYCuZhpiHPLtVQby/kCro4q6elmylNI6bWKUHqyryuZdAJ4I80MmQTVF0X7zJPGCytDAEROd/4sSsIpa/QliqI4ABANPUQnacUQB8eylOwV5R7UVL2440gGnpTrEhRfRxsi+bhOQ2cvQ3cvMt0oGu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731505579; c=relaxed/simple;
	bh=jE/kU3yz9Y06hZZtEYTjoofLn3fDGlh9QxovaYHV4zM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=n5n5rb09p6ibcw1wDXsDbODBWjxB6gOpDqJ7ovO56pF+M9OuC4X2SjlEUnzsZNl0XMMUBAeqKMAARnosHtpqfehxDueJb5aqg64Ydx0QGyCNDz+HeRzMc4T3e2tKbeChDudVlNmByTH6V8F5z2WpyNwTMXKdsI5yUfXPPbXawRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EMXLJKEZ; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731505578; x=1763041578;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jE/kU3yz9Y06hZZtEYTjoofLn3fDGlh9QxovaYHV4zM=;
  b=EMXLJKEZhDBUueR3bwk5hyL8MyHzU87ZtW9/3y4ejEeQTcMCeU9mNVx0
   kY0tgxtJv7LKDli4c75XVwDc2vhFTTnVYjJZtkmTscM42WFFrPqrQ+Lig
   O/Gcwto9fbpEUOuneeYyQm+brikwYYZjQ9UI8hSYipCJP8Pa4bGMDzAJr
   M8EaGu9BrlnkSMlcOb+YI//7H4mWO0Ub/OL55Vw7imOIUtjBfV+X2uVTK
   WOJuJaiTmvvAVZG9QGpkbfARK7115QRSVL5C89ZTi5trIvZLTiClEbHD6
   5p7zMyt7GUQJE16XzJOz2wkZcLGFa4Q4gUrhx652CToJe+Z3LIUNcYaJL
   A==;
X-CSE-ConnectionGUID: zwjnBHFkQyGipUKFkWirVw==
X-CSE-MsgGUID: NBn5vh9GSIS2rzy9YuK8sA==
X-IronPort-AV: E=McAfee;i="6700,10204,11254"; a="42025694"
X-IronPort-AV: E=Sophos;i="6.12,151,1728975600"; 
   d="scan'208";a="42025694"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2024 05:46:16 -0800
X-CSE-ConnectionGUID: 9oSvCC2ySo6Q3v8jEqrZ6A==
X-CSE-MsgGUID: IGg4UCxjSzisow3CRoqDjA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,151,1728975600"; 
   d="scan'208";a="87445589"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmviesa006.fm.intel.com with ESMTP; 13 Nov 2024 05:46:15 -0800
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
Subject: [PATCH v5 2/7] iommu: Consolidate the ops->remove_dev_pasid usage into a helper
Date: Wed, 13 Nov 2024 05:46:08 -0800
Message-Id: <20241113134613.7173-3-yi.l.liu@intel.com>
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

Add a wrapper for the ops->remove_dev_pasid, this consolidates the iommu_ops
fetching and callback invoking. It is also a preparation for starting the
transition from using remove_dev_pasid op to detach pasid to the way using
blocked_domain to detach pasid.

Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/iommu/iommu.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index b743fe612441..c1ab42ff5c4b 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -3298,6 +3298,14 @@ bool iommu_group_dma_owner_claimed(struct iommu_group *group)
 }
 EXPORT_SYMBOL_GPL(iommu_group_dma_owner_claimed);
 
+static void iommu_remove_dev_pasid(struct device *dev, ioasid_t pasid,
+				   struct iommu_domain *domain)
+{
+	const struct iommu_ops *ops = dev_iommu_ops(dev);
+
+	ops->remove_dev_pasid(dev, pasid, domain);
+}
+
 static int __iommu_set_group_pasid(struct iommu_domain *domain,
 				   struct iommu_group *group, ioasid_t pasid)
 {
@@ -3316,11 +3324,9 @@ static int __iommu_set_group_pasid(struct iommu_domain *domain,
 err_revert:
 	last_gdev = device;
 	for_each_group_device(group, device) {
-		const struct iommu_ops *ops = dev_iommu_ops(device->dev);
-
 		if (device == last_gdev)
 			break;
-		ops->remove_dev_pasid(device->dev, pasid, domain);
+		iommu_remove_dev_pasid(device->dev, pasid, domain);
 	}
 	return ret;
 }
@@ -3330,12 +3336,9 @@ static void __iommu_remove_group_pasid(struct iommu_group *group,
 				       struct iommu_domain *domain)
 {
 	struct group_device *device;
-	const struct iommu_ops *ops;
 
-	for_each_group_device(group, device) {
-		ops = dev_iommu_ops(device->dev);
-		ops->remove_dev_pasid(device->dev, pasid, domain);
-	}
+	for_each_group_device(group, device)
+		iommu_remove_dev_pasid(device->dev, pasid, domain);
 }
 
 /*
-- 
2.34.1


