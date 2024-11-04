Return-Path: <kvm+bounces-30521-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EEE959BB5BB
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 14:20:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2CD541C21589
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 13:20:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 348B8139D04;
	Mon,  4 Nov 2024 13:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DzwYtfA5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D201086AE3
	for <kvm@vger.kernel.org>; Mon,  4 Nov 2024 13:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730726342; cv=none; b=tVkFWJeuJRl1OAstNH78wzhrnhyGIaQaqGVlCx6K/L2NwOm0QpdWP5BL99sIiZNFRh3a3CObzw0M4Dac4VKgKmE/jEIBz9qjQfclg+SY+29rscmjnFLAHOtS7pptKJ/lCoXZXYYSfOt9951sD41IuUWeVYL3XQ+e8Ny+1Qbj1zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730726342; c=relaxed/simple;
	bh=MROwMDqu2Sa+gM1LE0UPUlJ4Sjp/3p7HJPGD7Dw3RTM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ltXKpNB56r083K2u0wfMs1khteQfk+9ByW0vXQBxHmWbBD6PSuzQGqkRgYJWWpN6dnIl6FmvnX/pfDvo2pXz3mDpO2wTED2GRHfBp1mxEbbL5Fd35FFF8slNabdsApdDbkWvTFH3rpUnjnhgfDAaH0vHxNa4V6kKPdYoEbBYcqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DzwYtfA5; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730726341; x=1762262341;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MROwMDqu2Sa+gM1LE0UPUlJ4Sjp/3p7HJPGD7Dw3RTM=;
  b=DzwYtfA5c1UzgltX1lLp79nNPwJtFTgXXyGfi5ocMQnyFsPKir/XfC5L
   4qQvAN7lOLwY4V7I8EWhfHZVREtH/pfEyErL9NGjz4VImKtiWt9kJKkQG
   iw2MTo9xo2O71HH+bvdagtILcNQi3AD97of9nfSvcLIsfXTI+la4SlgvW
   tegywnUorztlZujsUUehsoqpr0TgLxSw7gCC5qeISZXGBElw8mfq9enzK
   wgKwLZ0FePfA1vKfb3zrl2pYdjYzwlM9/7bKEiMkR89Cvz8COLsmXYOX7
   HUYtCGzeSvCXNfWEN7AKecBBFRqANMVrCXF+aT+eZG8o9xq1wCz7zHwxV
   w==;
X-CSE-ConnectionGUID: foY8d6oxQx6VSJ6ckL7ctg==
X-CSE-MsgGUID: TC9FZt9tTyOC2875CuBKgg==
X-IronPort-AV: E=McAfee;i="6700,10204,11246"; a="41003803"
X-IronPort-AV: E=Sophos;i="6.11,257,1725346800"; 
   d="scan'208";a="41003803"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 05:19:00 -0800
X-CSE-ConnectionGUID: w4Ymx3kTRIecxqSyzuShtQ==
X-CSE-MsgGUID: /SxzB56GSx2gRNKDALkAYg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,257,1725346800"; 
   d="scan'208";a="83999561"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmviesa010.fm.intel.com with ESMTP; 04 Nov 2024 05:18:59 -0800
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
Subject: [PATCH v4 13/13] iommu: Make set_dev_pasid op support domain replacement
Date: Mon,  4 Nov 2024 05:18:42 -0800
Message-Id: <20241104131842.13303-14-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241104131842.13303-1-yi.l.liu@intel.com>
References: <20241104131842.13303-1-yi.l.liu@intel.com>
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
index e1c8e92170e9..2ec0c9915aa5 100644
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


