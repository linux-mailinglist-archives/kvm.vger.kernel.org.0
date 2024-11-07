Return-Path: <kvm+bounces-31112-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0AF529C05AA
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 13:24:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 94E67B21299
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 12:23:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85612212627;
	Thu,  7 Nov 2024 12:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lZ1/r+Kb"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BD1D212181
	for <kvm@vger.kernel.org>; Thu,  7 Nov 2024 12:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730982168; cv=none; b=K+s+bajfGiVklkfb2mKEmyH3eq2io2jF9V0HxlgrkoJLJnVKugQF2mqRJ1G/RMxrzezlOLyCzjx7XvVF/WJqP57g7ox1l1lAAaCfhSV1BKfx2HDuWbUIBuuDbTKIq02l7dUc2W9lmR+1ziUpQrixx8+vaII2zW1YkYe3J+1FtNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730982168; c=relaxed/simple;
	bh=YQbNiBetTn/f7PT9oR9wqLpSCGd2nngC6kfX9asM9Go=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BB9GmMJvA5rXdQNeaSxDwp7mrLJAgMOtxB9f7L0h3MvFdiaaW65ffB2suFqvG7gLN4tyGv/hpy4EF1ZgwtmisTZs6SDJu7Ry4OpjHLMoD8I2AGDkSxtkEZ+sDrdPajZfgoOmmN311qnowP2otkG0mpcthOPxFeSuFLkXvCJj91o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lZ1/r+Kb; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730982166; x=1762518166;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YQbNiBetTn/f7PT9oR9wqLpSCGd2nngC6kfX9asM9Go=;
  b=lZ1/r+Kb1sj9p/6e67SXj1CqrrPo1SUxzHi1ePO36rAqAHvPPQK3vdPm
   BfH/taM59usLflmoj21Aub63o9AMBhhxdvTVs5FbG18GJddFUi/ch6Xxo
   0H9C8oZeCnNE9JMBaZ/XXO/IWYKucPpfJ6x8h7lhlY3XMyzYTOgXnKj8c
   jKLpd028vZoaIfOaDrAwAoayo/ZzDVfaz0cpGuSBKEk1G5skACKvbZAz8
   +/HAO0tsGR5MbhfIQvi+1xoa3M5ZKV8xgfvKBUwSAPIZGas3O/U6IrucK
   Rc5tyzxnWEDJ13KemhDswolF6AECC1uj9BGsMBGSGxiHgEo2fhKCVPRMq
   A==;
X-CSE-ConnectionGUID: tMEEd+cmSZi/B5U/KPPOfw==
X-CSE-MsgGUID: l5So+0viS8K5oGphic3Nmw==
X-IronPort-AV: E=McAfee;i="6700,10204,11249"; a="34744677"
X-IronPort-AV: E=Sophos;i="6.12,265,1728975600"; 
   d="scan'208";a="34744677"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2024 04:22:45 -0800
X-CSE-ConnectionGUID: WnZG3+jnR1228Auuhpb6bg==
X-CSE-MsgGUID: TxScV+IWSwGO3atxxPsj7A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,265,1728975600"; 
   d="scan'208";a="90180627"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orviesa004.jf.intel.com with ESMTP; 07 Nov 2024 04:22:46 -0800
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
Subject: [PATCH v6 13/13] iommu: Make set_dev_pasid op support domain replacement
Date: Thu,  7 Nov 2024 04:22:34 -0800
Message-Id: <20241107122234.7424-14-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241107122234.7424-1-yi.l.liu@intel.com>
References: <20241107122234.7424-1-yi.l.liu@intel.com>
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

AMD iommu driver does not support domain replacement for pasid yet, so it
would fail the set_dev_pasid op to keep the old config if the input @old
is non-NULL. Till now, all the set_dev_pasid callbacks can handle the old
parameter and can keep the old config when failed, so update the kdoc of
set_dev_pasid op.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/iommu/amd/pasid.c | 3 +++
 include/linux/iommu.h     | 3 ++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/amd/pasid.c b/drivers/iommu/amd/pasid.c
index d1dfc745f55e..8c73a30c2800 100644
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
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 56653af5edcb..0c3bfb66dc7c 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -614,7 +614,8 @@ struct iommu_ops {
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


