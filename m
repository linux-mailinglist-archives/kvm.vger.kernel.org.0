Return-Path: <kvm+bounces-33011-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 759729E3A2D
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 13:44:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A78E1B3589F
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 12:29:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3CEA1BD4E5;
	Wed,  4 Dec 2024 12:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LmH0x65s"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D1211B6CFF
	for <kvm@vger.kernel.org>; Wed,  4 Dec 2024 12:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733315374; cv=none; b=GsEHZx+goa7gT8RnIlrtW4IReU+muWIbScwXnPhT5xLYsxmWeoXgY/uabCXJ3acpQZau8uNguIz0iTpDQ+4GjwQNtCEMPBHZbAM1pfyEcJRrl1yZ4VVkVF+PDoV3JYNa9ACw3xLWC0In8eUXvYnjg+QeYNhswbOuGtzm+i2/ctE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733315374; c=relaxed/simple;
	bh=YOo7EVh87rnwHYdcmhCtZ2+qKHDekfy1krTEhcj6ymo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VNzvuVSqQPE+Oy7SKNjRSCHuKsmJrEHUXiEKLcb961YtuvVk4jnOEpG3fr9v52iG8ADPoCS7mUVi+egLgmdXXuycwVVMFSEMW0/n2znABQiFNa7wdBKY/OOUUOwk/5ipfqSIP6e3RsIFrZ5Af/oz85NMnqXQlIp5VFrIlzl3URk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LmH0x65s; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733315373; x=1764851373;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YOo7EVh87rnwHYdcmhCtZ2+qKHDekfy1krTEhcj6ymo=;
  b=LmH0x65sfJBNaza2sKCgvIvNtENQZlTspgPyoNEsOeCn7YkxbhDOR+kd
   F3El9a+FWXES0GmVKRN+BwWn4i+1G8n7+i1fq6CC65Khpc3pLnoSeSXXh
   beEt3n6Y7mEpycgu5e//Xfe7TpqIzCQcXmB0p/aPL30Ofmx2Qmlp1bREF
   ViQBeHyuy1h6Jz6v81yspZnczasJoJxrA04kY9wxCNuQZdKh00EdVtQ8m
   dVO1eaV/M+UfqC/iRkXuD7gfC3nfwYHi4Q0OlWuCVnwk8Hx6LZNr5V5zt
   CxmM/SedYSHff5/SDeClIZfC0VUYWQpvJwX2MfxArW8wlZWWHz1XEJ3gh
   g==;
X-CSE-ConnectionGUID: eA0cYNgRQZmDTGB/2aveYA==
X-CSE-MsgGUID: bFsYB8ghREqAQ5TjMYX0Dg==
X-IronPort-AV: E=McAfee;i="6700,10204,11276"; a="32937886"
X-IronPort-AV: E=Sophos;i="6.12,207,1728975600"; 
   d="scan'208";a="32937886"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2024 04:29:32 -0800
X-CSE-ConnectionGUID: 6rvywbw8QpKNNUz2UuyNig==
X-CSE-MsgGUID: JvbBeR9USxGvupboqeabxQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,207,1728975600"; 
   d="scan'208";a="93599069"
Received: from unknown (HELO 984fee00a4c6.jf.intel.com) ([10.165.58.231])
  by orviesa010.jf.intel.com with ESMTP; 04 Dec 2024 04:29:32 -0800
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
Subject: [PATCH v6 2/7] iommu: Consolidate the ops->remove_dev_pasid usage into a helper
Date: Wed,  4 Dec 2024 04:29:23 -0800
Message-Id: <20241204122928.11987-3-yi.l.liu@intel.com>
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
index 38c3f67e441f..0331dc30eb64 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -3312,6 +3312,14 @@ bool iommu_group_dma_owner_claimed(struct iommu_group *group)
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
@@ -3330,11 +3338,9 @@ static int __iommu_set_group_pasid(struct iommu_domain *domain,
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
@@ -3344,12 +3350,9 @@ static void __iommu_remove_group_pasid(struct iommu_group *group,
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


