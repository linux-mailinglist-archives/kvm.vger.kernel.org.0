Return-Path: <kvm+bounces-14399-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E1A28A28FD
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 10:16:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EC36A283143
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 08:15:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE46550293;
	Fri, 12 Apr 2024 08:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dc+MmoFh"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97B605025A
	for <kvm@vger.kernel.org>; Fri, 12 Apr 2024 08:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712909736; cv=none; b=N3ebKvGQROuuc6S7mfIGkPxlIyaCsoJC2dtHtTpqU849CR6jDe1eU1td/olVI9IpGKO/f+XbFsJR1VUWdGOQm8PeSO9fNKczDIQhQiGiHr1kfwTcvLtROH1eQWJfUWZQJQCM0B6y0azt5Nv3hiURyQXGySF/KuUOrPjNaQnXsNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712909736; c=relaxed/simple;
	bh=9+733uWB7Bw+JboyGYQ9tafFmKQKqArPjT3L3IX1sZg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=uXECApRQHXFKGMXmSYjuCok22yHjkUFRrX7ThRIcTI97kV3FycHlHaQp7LGEzFG6Uip9Vf90VeFcDCFW/H0VXhnP/2omjCGOWf2TiZoOChGmIqqvNUYI0bt9dLy2ToV7JOH1ND8c8VxkEAmPixh/fSrK+tPQINn8T6LgCPll2tY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dc+MmoFh; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712909735; x=1744445735;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9+733uWB7Bw+JboyGYQ9tafFmKQKqArPjT3L3IX1sZg=;
  b=dc+MmoFhyME3mH1s3TJ4UkBEX6ZT2mfXf92bTpWI2aQImfMYQZCdF7ZV
   1pH3xJykhhJQRXoj5mXwS9cuh7LHOUzUOhkK/t/VXWEmUX0N+knDPlrqf
   7z4QMFl1hhWjxgcnQuVQKUuo3UNiyHX97fo+XydiFrCPaU3WpoMGAaZq6
   aicaUH3OBrTCZLiCtXnX2VuGaoVhfQrrD+2uFmOHuvBqRf5+HR+W2c4cg
   co6nvDZKHn96GfEyA192BvIVpmGBCLnDpv6HmwI5dmrW1l0/W/VeyTQzA
   n+yvDr2I8OGPdUEbVIt1ECwq59JWJiu3cJT8kHiF6hHC7NEhi340zIB34
   w==;
X-CSE-ConnectionGUID: p/UMrbpNSpOVUDtp6in/vQ==
X-CSE-MsgGUID: XY1wH+dVS/qwbuN9zOaxIg==
X-IronPort-AV: E=McAfee;i="6600,9927,11041"; a="8465069"
X-IronPort-AV: E=Sophos;i="6.07,195,1708416000"; 
   d="scan'208";a="8465069"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2024 01:15:34 -0700
X-CSE-ConnectionGUID: lPIpN6rGRa6tNjYsWckn9Q==
X-CSE-MsgGUID: fuZgDp5GTAm95lAS8kpTPg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,195,1708416000"; 
   d="scan'208";a="52137843"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orviesa002.jf.intel.com with ESMTP; 12 Apr 2024 01:15:33 -0700
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
	iommu@lists.linux.dev,
	zhenzhong.duan@intel.com,
	jacob.jun.pan@intel.com
Subject: [PATCH v2 05/12] iommu: Allow iommu driver to populate the max_pasids
Date: Fri, 12 Apr 2024 01:15:09 -0700
Message-Id: <20240412081516.31168-6-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240412081516.31168-1-yi.l.liu@intel.com>
References: <20240412081516.31168-1-yi.l.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Today, the iommu layer gets the max_pasids by pci_max_pasids() or reading
the "pasid-num-bits" property. This requires the non-PCI devices to have a
"pasid-num-bits" property. Like the mock device used in iommufd selftest,
otherwise the max_pasids check would fail in iommu layer.

While there is an alternative, the iommu layer can allow the iommu driver
to set the max_pasids in its probe_device() callback and populate it. This
is simpler and has no impact on the existing cases.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/iommu/iommu.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 343683e646e0..dc85c251237f 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -368,9 +368,9 @@ static bool dev_has_iommu(struct device *dev)
 	return dev->iommu && dev->iommu->iommu_dev;
 }
 
-static u32 dev_iommu_get_max_pasids(struct device *dev)
+static void dev_iommu_set_max_pasids(struct device *dev)
 {
-	u32 max_pasids = 0, bits = 0;
+	u32 max_pasids = dev->iommu->max_pasids, bits = 0;
 	int ret;
 
 	if (dev_is_pci(dev)) {
@@ -383,7 +383,8 @@ static u32 dev_iommu_get_max_pasids(struct device *dev)
 			max_pasids = 1UL << bits;
 	}
 
-	return min_t(u32, max_pasids, dev->iommu->iommu_dev->max_pasids);
+	dev->iommu->max_pasids = min_t(u32, max_pasids,
+				       dev->iommu->iommu_dev->max_pasids);
 }
 
 void dev_iommu_priv_set(struct device *dev, void *priv)
@@ -433,7 +434,7 @@ static int iommu_init_device(struct device *dev, const struct iommu_ops *ops)
 	}
 	dev->iommu_group = group;
 
-	dev->iommu->max_pasids = dev_iommu_get_max_pasids(dev);
+	dev_iommu_set_max_pasids(dev);
 	if (ops->is_attach_deferred)
 		dev->iommu->attach_deferred = ops->is_attach_deferred(dev);
 	return 0;
-- 
2.34.1


