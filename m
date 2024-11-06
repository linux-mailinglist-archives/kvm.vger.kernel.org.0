Return-Path: <kvm+bounces-30976-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5916A9BF20F
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 16:47:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8BA3E1C259DB
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 15:47:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAAFD20696A;
	Wed,  6 Nov 2024 15:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Pds6h79h"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07E53205154
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 15:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730907973; cv=none; b=sm2mdtE3T1oyY79n0PRO/GX9bBFkHdhnOdcUJauvEbu9n4DG+61FBnC4BCVMGZXpvsUyrTm4pnrlA+xSfCCvmceu3B4fSRQCqHZDRG+rBxe+/Ro6TSTWqnXhDhKx+GazVnviyO79MvQBaisColh3B0gpA/OesjVc6MuNJ1EmHWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730907973; c=relaxed/simple;
	bh=zMyYyGV96waleHLoH66ytmlOPKGevNq9jSgZE32loaw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iwis3AGTox1J1acdrhFC66futp0evTfY/N67vov4bF8+Ndi4ycvSfz+mojQR2gtiR6rotYdzqjIMBooEPVFVaxMm+5uB/0nABlCEVS2elqOWc2ohyKB2HwmWFpbjfaeYnIemewUySPzPBrXPXsPEt8o9EPx+abp4BB6hoCkIC00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Pds6h79h; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730907972; x=1762443972;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zMyYyGV96waleHLoH66ytmlOPKGevNq9jSgZE32loaw=;
  b=Pds6h79hYn1X3+hQocMnbiG0KB+9nWRSnDHAUuuD08x6Bm0K+tZEzc9O
   ZVACbiZrZGsjPE1tT9k66So2Bc9Jck0qwPmaFvONBdESfwl388g6I9gVD
   74fi3mAUvdTBx54jo8HfpVnvstrlNdght7oIlAZL1qNC3lIfjfuNNgdcY
   hi/M5VeoTQFQrDfsDZgrQvcK9QSV3zoHHH93JnL0W6ghyc6v9GiPISpNA
   DztWAgc8E9+f2vDEhFc0JZFjq3Oeqald02nWzGyYpG7ESKtGPUcw0Nx6P
   2hPh35PPCZDRcdPfsq5GpsL73Lj2L0RG6SDEM9Du+SKp933tHHe7oTuSL
   Q==;
X-CSE-ConnectionGUID: Q3WTiOj9Tza8Ek+fviJRnw==
X-CSE-MsgGUID: /VH0Uc9pQPqaXLpvd3aveg==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="48174219"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="48174219"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2024 07:46:09 -0800
X-CSE-ConnectionGUID: gI6wWj/PTEmgnvAdAM7wdw==
X-CSE-MsgGUID: MyRJX/U6Q/WQdAOaguIrrQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,263,1725346800"; 
   d="scan'208";a="89468176"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orviesa005.jf.intel.com with ESMTP; 06 Nov 2024 07:46:09 -0800
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
Subject: [PATCH v5 02/13] iommu/vt-d: Add a helper to flush cache for updating present pasid entry
Date: Wed,  6 Nov 2024 07:45:55 -0800
Message-Id: <20241106154606.9564-3-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241106154606.9564-1-yi.l.liu@intel.com>
References: <20241106154606.9564-1-yi.l.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Generalize the logic for flushing pasid-related cache upon changes to
bits other than SSADE and P which requires a different flow according
to VT-d spec.

No functional change is intended.

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/iommu/intel/pasid.c | 52 ++++++++++++++++++++++++-------------
 1 file changed, 34 insertions(+), 18 deletions(-)

diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/pasid.c
index 31665fb62e1c..8d11701c2e76 100644
--- a/drivers/iommu/intel/pasid.c
+++ b/drivers/iommu/intel/pasid.c
@@ -287,6 +287,39 @@ static void pasid_flush_caches(struct intel_iommu *iommu,
 	}
 }
 
+/*
+ * This function is supposed to be used after caller updates the fields
+ * except for the SSADE and P bit of a pasid table entry. It does the
+ * below:
+ * - Flush cacheline if needed
+ * - Flush the caches per Table 28 ”Guidance to Software for Invalidations“
+ *   of VT-d spec 5.0.
+ */
+static void intel_pasid_flush_present(struct intel_iommu *iommu,
+				      struct device *dev,
+				      u32 pasid, u16 did,
+				      struct pasid_entry *pte)
+{
+	if (!ecap_coherent(iommu->ecap))
+		clflush_cache_range(pte, sizeof(*pte));
+
+	/*
+	 * VT-d spec 5.0 table28 states guides for cache invalidation:
+	 *
+	 * - PASID-selective-within-Domain PASID-cache invalidation
+	 * - PASID-selective PASID-based IOTLB invalidation
+	 * - If (pasid is RID_PASID)
+	 *    - Global Device-TLB invalidation to affected functions
+	 *   Else
+	 *    - PASID-based Device-TLB invalidation (with S=1 and
+	 *      Addr[63:12]=0x7FFFFFFF_FFFFF) to affected functions
+	 */
+	pasid_cache_invalidation_with_pasid(iommu, did, pasid);
+	qi_flush_piotlb(iommu, did, pasid, 0, -1, 0);
+
+	devtlb_invalidation_with_pasid(iommu, dev, pasid);
+}
+
 /*
  * Set up the scalable mode pasid table entry for first only
  * translation type.
@@ -526,24 +559,7 @@ void intel_pasid_setup_page_snoop_control(struct intel_iommu *iommu,
 	did = pasid_get_domain_id(pte);
 	spin_unlock(&iommu->lock);
 
-	if (!ecap_coherent(iommu->ecap))
-		clflush_cache_range(pte, sizeof(*pte));
-
-	/*
-	 * VT-d spec 3.4 table23 states guides for cache invalidation:
-	 *
-	 * - PASID-selective-within-Domain PASID-cache invalidation
-	 * - PASID-selective PASID-based IOTLB invalidation
-	 * - If (pasid is RID_PASID)
-	 *    - Global Device-TLB invalidation to affected functions
-	 *   Else
-	 *    - PASID-based Device-TLB invalidation (with S=1 and
-	 *      Addr[63:12]=0x7FFFFFFF_FFFFF) to affected functions
-	 */
-	pasid_cache_invalidation_with_pasid(iommu, did, pasid);
-	qi_flush_piotlb(iommu, did, pasid, 0, -1, 0);
-
-	devtlb_invalidation_with_pasid(iommu, dev, pasid);
+	intel_pasid_flush_present(iommu, dev, pasid, did, pte);
 }
 
 /**
-- 
2.34.1


