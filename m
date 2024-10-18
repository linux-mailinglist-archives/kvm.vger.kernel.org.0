Return-Path: <kvm+bounces-29139-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 64D2A9A34DC
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2024 07:59:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 93EB51C209A4
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2024 05:59:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3CBD1922DF;
	Fri, 18 Oct 2024 05:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="feZ7c+4B"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 904D7191F79
	for <kvm@vger.kernel.org>; Fri, 18 Oct 2024 05:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729230853; cv=none; b=DX3+n4foLkQzkT+JaesPldFY0SR9j73iDhXRoxSCPnh4peoVPXrkudgBmeplldtqJDd89ycGsUOF3vEn3vVveqz2gBjfP2hJIgw9AGeP6TWSdehXme3OtOMqyHzTDfmoVyvt/3hdtCWronsVhplfImxNbGYiZIt09qeYUeylb9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729230853; c=relaxed/simple;
	bh=7iKgbnql9TVwiX7VYuXhhW+8bsWx4PXvI9Qt1OiOP40=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KbL2c5nnL/vXeOCWYrXcgsH8v0GBse1fYYm/q/+wU8QbXH/a9oMYYI3L0fAOyveYYdlHHC9+HB57QzKWbYxkufs8ocght0uiLgLLf8QKPFsxX3UVDUTAgH5othF4+NR5862VrAhDEiZDTbzfCsif1glfUh2xuvW/PxVNn44ASl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=feZ7c+4B; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729230852; x=1760766852;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7iKgbnql9TVwiX7VYuXhhW+8bsWx4PXvI9Qt1OiOP40=;
  b=feZ7c+4BCxT37HdwHrq597k0vQFCO7zLWZEPXis+lQn34TgM0S6oaY2G
   OBDcJI1LjypKPIhzwMOZ7kYeAKIElE828hD5vjogCSYVE9GmQX7HbqOa+
   HWrnWMSwf8kLSgGLp9EOgczhrS+1i6n5DHloEe5xix1RIXF/N22KAASl5
   JvG9xxS31+mQ4ofbHxVSnTZHRpqqyGPh8pnO2ClzLnR4WBky8zNJi9iCR
   EqidIiZJ6ai3GUof7UB8r4fH2c8yKI9jLWWUnFxiiihA2z4NjyVYYMzW9
   LjF1ItayTUWtvKtdnFNKniqHOOh7nPHji/Pwq3P0FUpxxhV0eQJhkxMYH
   A==;
X-CSE-ConnectionGUID: cDgzBoGQQ9uKMLhiGCM4TQ==
X-CSE-MsgGUID: WXOeuQ0NQ12t5wunQqQc2g==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="28708842"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="28708842"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2024 22:54:10 -0700
X-CSE-ConnectionGUID: krBm4ja6THG1wuQiigxGDw==
X-CSE-MsgGUID: 9BBr2ac4SoebUnQl2Ofn8w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,212,1725346800"; 
   d="scan'208";a="79188602"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orviesa007.jf.intel.com with ESMTP; 17 Oct 2024 22:54:09 -0700
From: Yi Liu <yi.l.liu@intel.com>
To: joro@8bytes.org,
	jgg@nvidia.com,
	kevin.tian@intel.com,
	baolu.lu@linux.intel.com,
	will@kernel.org
Cc: alex.williamson@redhat.com,
	eric.auger@redhat.com,
	nicolinc@nvidia.com,
	kvm@vger.kernel.org,
	chao.p.peng@linux.intel.com,
	yi.l.liu@intel.com,
	iommu@lists.linux.dev,
	zhenzhong.duan@intel.com,
	vasant.hegde@amd.com
Subject: [PATCH v3 9/9] iommu: Make set_dev_pasid op support domain replacement
Date: Thu, 17 Oct 2024 22:54:02 -0700
Message-Id: <20241018055402.23277-10-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241018055402.23277-1-yi.l.liu@intel.com>
References: <20241018055402.23277-1-yi.l.liu@intel.com>
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
is non-NULL.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
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
index 32dce80aa7fd..27f923450a7c 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -616,7 +616,8 @@ struct iommu_ops {
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


