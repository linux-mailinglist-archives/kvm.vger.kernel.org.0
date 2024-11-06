Return-Path: <kvm+bounces-30982-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D5579BF215
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 16:48:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A929AB20F58
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 15:48:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AE4B20820E;
	Wed,  6 Nov 2024 15:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QPgPiyZs"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5AE320721C
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 15:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730907977; cv=none; b=cYDclswslcmKu5Ya5YkleIEJbHrptJ/Z1vYWmui/dxMBEF0RaFHUvtav8CRwI2X0UOcUVhCoW3LevjQWUllncwOSjzdYxsjeHMt1lr/y3JnLQW1gf1OihT15JC3cOhU0tTFrQBcFxN+11tUkFByeHf3wmtCzXfLH9E7J4Cj+oN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730907977; c=relaxed/simple;
	bh=StPLIHdHMILZf4wA2ehuHqX9QaXNphD0GtF6wSM9b0E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Ybg0mox15vVyNSnraaVG9ZMwIDLTucQasD1M++zOnIkWGFu3BiKwLsAL4/rJK6wlFVCUO1TyAUhauRfk423+/kuZUIWN73lquSkGJdq95mIwWoHRsjfVAeDCOM/y0CrAOkXFzxNs1AE+XEErALfmdamNohYDFmedIB4BLnCPoVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QPgPiyZs; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730907976; x=1762443976;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=StPLIHdHMILZf4wA2ehuHqX9QaXNphD0GtF6wSM9b0E=;
  b=QPgPiyZspaptemuj8eqUDtH4sELvRiVu6q61WBQNFdKZ2tRYDdbnTQtt
   tTZYttY4sx0FPuqceS8Ffbgq5HvHmTFr/XRlBnTix7zRd+CGPLq7T24Cw
   z6faJHS7EyvmJyNDY8ffo7tEUE0+GUOxKogtLbVsVvtQmovhd18bLPre5
   J+DER3EDxcbQ4PZ8HCD8J95Rlk3H9C1pVkyKwNdSv/ZdkN2aMO8jnqFvs
   5HxWHLAuO40xVJ88xRlnBUdLZuC/TkNexmnSqNUO8D9PCaN6lB3jNF2Lv
   T6hzjsuYO7QpjrZbtYOxJHnwSjETyjCkmzoHsf+ajQNIAm88Vgslligb8
   g==;
X-CSE-ConnectionGUID: NkvZn7z6SjCqWxzkkdJsmw==
X-CSE-MsgGUID: browshQoRxquVQFPAS9KUQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="48174269"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="48174269"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2024 07:46:11 -0800
X-CSE-ConnectionGUID: Ijf6F0wPQGCEY0G8aT+wlw==
X-CSE-MsgGUID: iuTUwI+QQuy2tECElwfFgQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,263,1725346800"; 
   d="scan'208";a="89468240"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orviesa005.jf.intel.com with ESMTP; 06 Nov 2024 07:46:11 -0800
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
Subject: [PATCH v5 08/13] iommu/vt-d: Limit intel_iommu_set_dev_pasid() for paging domain
Date: Wed,  6 Nov 2024 07:46:01 -0800
Message-Id: <20241106154606.9564-9-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241106154606.9564-1-yi.l.liu@intel.com>
References: <20241106154606.9564-1-yi.l.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

intel_iommu_set_dev_pasid() is only supposed to be used by paging domain,
so limit it.

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/iommu/intel/iommu.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 6b7f48119502..3c1b92fa5877 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -4156,6 +4156,9 @@ static int intel_iommu_set_dev_pasid(struct iommu_domain *domain,
 	struct dev_pasid_info *dev_pasid;
 	int ret;
 
+	if (WARN_ON_ONCE(!(domain->type & __IOMMU_DOMAIN_PAGING)))
+		return -EINVAL;
+
 	if (!pasid_supported(iommu) || dev_is_real_dma_subdevice(dev))
 		return -EOPNOTSUPP;
 
@@ -4184,8 +4187,7 @@ static int intel_iommu_set_dev_pasid(struct iommu_domain *domain,
 
 	domain_remove_dev_pasid(old, dev, pasid);
 
-	if (domain->type & __IOMMU_DOMAIN_PAGING)
-		intel_iommu_debugfs_create_dev_pasid(dev_pasid);
+	intel_iommu_debugfs_create_dev_pasid(dev_pasid);
 
 	return 0;
 
-- 
2.34.1


