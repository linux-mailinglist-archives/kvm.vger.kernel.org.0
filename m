Return-Path: <kvm+bounces-20647-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DCB8691BA7E
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 10:56:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 988AA282253
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 08:56:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 202B91514DD;
	Fri, 28 Jun 2024 08:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jMA3D7jV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1ACE14F9F2
	for <kvm@vger.kernel.org>; Fri, 28 Jun 2024 08:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719564947; cv=none; b=U7sTlIsSX+DW68+E1hqO4VB0RszoDdiobyAqg02J/y82Fk75tINx4RPVr4qZ+ioMB+mBl+tWJor3d95bTpSVj5X8EGBFo0HXSyKP8508AwPkG0sJ3Us5bgIc1zSVFS59Ub7Lkh58nD8HZLDWqSxkpu4oIQyZdYw5n+mxqTDWH0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719564947; c=relaxed/simple;
	bh=Sy1iOiUAINOB5pM86Qihc499Jn7wpkAKigfPOK53ZEI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=AOAo0EJaTNFKSfgoKtTdqSY/vfMUszqSX3w91sbaG9C6teuXBR2+C41yPA1hFDGUlZrebUGB9ujhZP1J50zHa2Ny56ZjiizQCXWayJ02+BK6XO4S5qU+D/59G2E4SvxlqyzoSJ4hKYIDNezjf+kH8vCGQ3y+qSFdF1WGjkGZdjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jMA3D7jV; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719564946; x=1751100946;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Sy1iOiUAINOB5pM86Qihc499Jn7wpkAKigfPOK53ZEI=;
  b=jMA3D7jVp0ScsoVK9/OyPSqv9yihnm3PimJgUDPbACcp62VbJzxt6JDL
   jr0z/eY3Kmy4UIJsJ22Yy/5fZzrk6vYTvZ2ZTSXJk49Kmvj0k680rko0M
   bXsTokWo7vyQj0eNDhOpFcGWWZ7Z9YQJw3QicnPBUg2/TZFj2Zh52ILLL
   VWE2v8WbZAAGClCekYSqWK1HEUGXa07H9I6QTJ4jMMLP62dANMH64JNcc
   BnQnAGd4obiDdULlYo2yWREtq/R+hcrc77PmGWaBXKWX0y57D2fjzIDh+
   4pVko1H3MyyY7HLC7odyiPS8zggAjSdWGPTSIrtHpWIX1MhUj6eWv+9t2
   w==;
X-CSE-ConnectionGUID: qTZpBeCARVq/sKF1C7qFRA==
X-CSE-MsgGUID: Yk45qciARmmK/Tvhf11ROQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11116"; a="34277517"
X-IronPort-AV: E=Sophos;i="6.09,168,1716274800"; 
   d="scan'208";a="34277517"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2024 01:55:45 -0700
X-CSE-ConnectionGUID: FrLdcPiLSMOUbzPH/tG4OQ==
X-CSE-MsgGUID: VZdZXAD+SemHanRMb3o1QQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,168,1716274800"; 
   d="scan'208";a="44584547"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orviesa010.jf.intel.com with ESMTP; 28 Jun 2024 01:55:45 -0700
From: Yi Liu <yi.l.liu@intel.com>
To: joro@8bytes.org,
	jgg@nvidia.com,
	kevin.tian@intel.com,
	baolu.lu@linux.intel.com
Cc: alex.williamson@redhat.com,
	robin.murphy@arm.com,
	eric.auger@redhat.com,
	nicolinc@nvidia.com,
	kvm@vger.kernel.org,
	chao.p.peng@linux.intel.com,
	yi.l.liu@intel.com,
	iommu@lists.linux.dev
Subject: [PATCH 6/6] iommu: Make set_dev_pasid op support domain replacement
Date: Fri, 28 Jun 2024 01:55:38 -0700
Message-Id: <20240628085538.47049-7-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240628085538.47049-1-yi.l.liu@intel.com>
References: <20240628085538.47049-1-yi.l.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The iommu core is going to support domain replacement for pasid, it needs
to make the set_dev_pasid op support replacing domain and keep the old
domain config in the failure case.

Currently only the Intel iommu driver supports the latest set_dev_pasid
op definition. ARM and AMD iommu driver do not support domain replacement
for pasid yet, both drivers would fail the set_dev_pasid op to keep the
old config if the input @old is non-NULL.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/iommu/amd/pasid.c                       | 3 +++
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c | 3 +++
 include/linux/iommu.h                           | 3 ++-
 3 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/amd/pasid.c b/drivers/iommu/amd/pasid.c
index 77bf5f5f947a..30e27bda3fac 100644
--- a/drivers/iommu/amd/pasid.c
+++ b/drivers/iommu/amd/pasid.c
@@ -109,6 +109,9 @@ int iommu_sva_set_dev_pasid(struct iommu_domain *domain,
 	unsigned long flags;
 	int ret = -EINVAL;
 
+	if (old)
+		return -EOPNOTSUPP;
+
 	/* PASID zero is used for requests from the I/O device without PASID */
 	if (!is_pasid_valid(dev_data, pasid))
 		return ret;
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index c058949749cb..a1e411c71efa 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -637,6 +637,9 @@ static int arm_smmu_sva_set_dev_pasid(struct iommu_domain *domain,
 	int ret = 0;
 	struct mm_struct *mm = domain->mm;
 
+	if (old)
+		return -EOPNOTSUPP;
+
 	if (mm_get_enqcmd_pasid(mm) != id)
 		return -EINVAL;
 
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index a33f53aab61b..3259f77ff2e3 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -607,7 +607,8 @@ struct iommu_ops {
  * * EBUSY	- device is attached to a domain and cannot be changed
  * * ENODEV	- device specific errors, not able to be attached
  * * <others>	- treated as ENODEV by the caller. Use is discouraged
- * @set_dev_pasid: set an iommu domain to a pasid of device
+ * @set_dev_pasid: set or replace an iommu domain to a pasid of device. The pasid of
+ *                 the device should be left in the old config in error case.
  * @map_pages: map a physically contiguous set of pages of the same size to
  *             an iommu domain.
  * @unmap_pages: unmap a number of pages of the same size from an iommu domain
-- 
2.34.1


