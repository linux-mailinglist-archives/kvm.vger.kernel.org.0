Return-Path: <kvm+bounces-30980-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B3679BF213
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 16:47:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5D1D51C25CA2
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 15:47:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DAE2720605D;
	Wed,  6 Nov 2024 15:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZunJChEY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AFAD20651B
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 15:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730907976; cv=none; b=D3wncMvgZTfu9e7IqV+8lWpkM00PYqtWg82c2f10PvHJtn6BVGgjz9lVr0ZyLgDjKxbdAWsxtoYzazbRFNvAtxAHcn5Xiq74WZzMuiE75wggu6emRPOkuDFpq6/RLwJLwPdd/mgsSB9lS3Fuw/9d0+XcVcI9Ef3Ny5elfqwTJ7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730907976; c=relaxed/simple;
	bh=BGpYuh/YYhfW/hLpJaRocFAPmWSngUp5Fa1W/C5ceWc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JX/MN4bI/rl37pOYDzCg50V8PdYmAUtpuKab7+ameLmCE1NOHXx5ap8Bs2hmWmnYYTcmvMQgfJUAj8cU2GpGAoCZyz0D7ufI1Tm1TDczeBGT2Uo3MBMG0hXOQVDMwCCoLomgm/kLa3HD310ZF26rpE/KMLExJQB584MkVsvam9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZunJChEY; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730907974; x=1762443974;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BGpYuh/YYhfW/hLpJaRocFAPmWSngUp5Fa1W/C5ceWc=;
  b=ZunJChEYl2PGisQfOcoFL0gFK/RFsMq4nUNgA4PycQx/JXiFuTn9I9lo
   z0zC25sfnhSXaZ77JknkR9JhQQnd7G8oSTA7vl/r/s2bWD/vx+1KueGGR
   B626m5BCb4sq/6p80JPECipNFabn3MMwaLNSg9Q2g+Y6at6M5oCZ/NTcl
   vT0UycwWbEQtc6Ti7s5j+LS7ijC81TT+ziGvDfxXKoFj7HYEpFx7kTtuN
   Skw0Jy3S2MDNciGlxyxXgkY200NgsvWbq9I5vVVxToD9Eesiit0axVIEH
   zZjyIkV/QNuZGdlZSAFR1S4O8suggKUKvqqFvvytunrf/+MtE8J5Voj5G
   Q==;
X-CSE-ConnectionGUID: oxi7LG30SmmJLYiti8ZxXg==
X-CSE-MsgGUID: D9owRr7wSyOTh3ZMo46ZFg==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="48174251"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="48174251"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2024 07:46:11 -0800
X-CSE-ConnectionGUID: wgn8GBlbR5SNjZ3prmBI1g==
X-CSE-MsgGUID: Bl5HrxfVRO20X5LFR36Efw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,263,1725346800"; 
   d="scan'208";a="89468222"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orviesa005.jf.intel.com with ESMTP; 06 Nov 2024 07:46:10 -0800
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
Subject: [PATCH v5 06/13] iommu/vt-d: Add iommu_domain_did() to get did
Date: Wed,  6 Nov 2024 07:45:59 -0800
Message-Id: <20241106154606.9564-7-yi.l.liu@intel.com>
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

domain_id_iommu() does not support SVA type and identity type domains.
Add iommu_domain_did() to support all domain types.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/iommu/intel/iommu.h | 16 ++++++++++++++++
 drivers/iommu/intel/pasid.h |  7 -------
 2 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/iommu/intel/iommu.h b/drivers/iommu/intel/iommu.h
index df0261e03fad..cdca7d5061a7 100644
--- a/drivers/iommu/intel/iommu.h
+++ b/drivers/iommu/intel/iommu.h
@@ -806,6 +806,13 @@ static inline struct dmar_domain *to_dmar_domain(struct iommu_domain *dom)
 	return container_of(dom, struct dmar_domain, domain);
 }
 
+/*
+ * Domain ID reserved for pasid entries programmed for first-level
+ * only and pass-through transfer modes.
+ */
+#define FLPT_DEFAULT_DID		1
+#define NUM_RESERVED_DID		2
+
 /* Retrieve the domain ID which has allocated to the domain */
 static inline u16
 domain_id_iommu(struct dmar_domain *domain, struct intel_iommu *iommu)
@@ -816,6 +823,15 @@ domain_id_iommu(struct dmar_domain *domain, struct intel_iommu *iommu)
 	return info->did;
 }
 
+static inline u16
+iommu_domain_did(struct iommu_domain *domain, struct intel_iommu *iommu)
+{
+	if (domain->type == IOMMU_DOMAIN_SVA ||
+	    domain->type == IOMMU_DOMAIN_IDENTITY)
+		return FLPT_DEFAULT_DID;
+	return domain_id_iommu(to_dmar_domain(domain), iommu);
+}
+
 /*
  * 0: readable
  * 1: writable
diff --git a/drivers/iommu/intel/pasid.h b/drivers/iommu/intel/pasid.h
index 06d1f7006d01..082f4fe20216 100644
--- a/drivers/iommu/intel/pasid.h
+++ b/drivers/iommu/intel/pasid.h
@@ -22,13 +22,6 @@
 #define is_pasid_enabled(entry)		(((entry)->lo >> 3) & 0x1)
 #define get_pasid_dir_size(entry)	(1 << ((((entry)->lo >> 9) & 0x7) + 7))
 
-/*
- * Domain ID reserved for pasid entries programmed for first-level
- * only and pass-through transfer modes.
- */
-#define FLPT_DEFAULT_DID		1
-#define NUM_RESERVED_DID		2
-
 #define PASID_FLAG_NESTED		BIT(1)
 #define PASID_FLAG_PAGE_SNOOP		BIT(2)
 
-- 
2.34.1


