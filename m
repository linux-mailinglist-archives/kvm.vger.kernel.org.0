Return-Path: <kvm+bounces-31101-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 57CBA9C059C
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 13:23:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1D1B7283D97
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 12:23:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5549820FAA1;
	Thu,  7 Nov 2024 12:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bQgJaGlT"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A32B7200BA6
	for <kvm@vger.kernel.org>; Thu,  7 Nov 2024 12:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730982160; cv=none; b=VbIL2aoA/Zs3CrJo3vJc+rrOlHheoZNlPzPCy/F50XexyHJB9UyZM4ggGVQgNfhA7rCKw8s57FppCUyRaw0IGPcU8TkOiBeoTj05M+6uP+5Ys9yc/eHCjbKCw5EywOuJn3HDvzWFCPn4Hxi3pupLdbZfYXaf8TRx06U6r4b9MAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730982160; c=relaxed/simple;
	bh=zMyYyGV96waleHLoH66ytmlOPKGevNq9jSgZE32loaw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ad8vCocwSl+Xj8SaY3q02Wv7Oe9YjdD++ltT/8GRd80wtVLWTqReOlijcXAHl2xI9eIsTi04Kjl9En84z7ZlGjvpjj7rwuJ2nwUr1TPatxnykyH4N6fqtLiBBQXMSyvHhGj2EOQau9EJU94HR9Ymto0hlwj/qSWsKGoE4tCfjyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bQgJaGlT; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730982158; x=1762518158;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zMyYyGV96waleHLoH66ytmlOPKGevNq9jSgZE32loaw=;
  b=bQgJaGlT5qfxqLZTLY+PwkTYOg5j0J8Kc+uP5to2Nae2ZpN8TiD3FgzQ
   h/pb2G1VgG0RioAFDt55JcC5T5wfo+0boVGonC3rcspIK1WrY78lRwyq7
   zSG0Yyc5f0vK7gfXNv6dVbnTm3gMWX5I7o7nzrKigW5VyHg2WqQkkIaTw
   DW0KBcdhnOl4o2mdS8mhQwBs1p1N7rKbvg2ig8n3KUjY5aodhC8Ov5/0W
   qzj8HUyxesJ1eLqQpuOqVY9xrx+s/8pV0D9SS85c63XgqyvudpZbV3hAC
   PafXyFxVwfqjt554DcvXk+413Wub1kEjxXnSMbiJhnzxciqStYQsNY8sO
   g==;
X-CSE-ConnectionGUID: tW11cY+ATYma7FQYCYQnaA==
X-CSE-MsgGUID: CVLRpGd/S2qYgwnxOK5tMA==
X-IronPort-AV: E=McAfee;i="6700,10204,11249"; a="34744579"
X-IronPort-AV: E=Sophos;i="6.12,265,1728975600"; 
   d="scan'208";a="34744579"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2024 04:22:36 -0800
X-CSE-ConnectionGUID: CzCO482FTmW9OZwY65b3bg==
X-CSE-MsgGUID: Yd3CVGsGTlOifSqKngOZHg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,265,1728975600"; 
   d="scan'208";a="90180552"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orviesa004.jf.intel.com with ESMTP; 07 Nov 2024 04:22:37 -0800
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
Subject: [PATCH v6 02/13] iommu/vt-d: Add a helper to flush cache for updating present pasid entry
Date: Thu,  7 Nov 2024 04:22:23 -0800
Message-Id: <20241107122234.7424-3-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241107122234.7424-1-yi.l.liu@intel.com>
References: <20241107122234.7424-1-yi.l.liu@intel.com>
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


