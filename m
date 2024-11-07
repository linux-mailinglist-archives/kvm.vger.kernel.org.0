Return-Path: <kvm+bounces-31105-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B532A9C05A0
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 13:23:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7ACF8283F06
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 12:23:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE53C210191;
	Thu,  7 Nov 2024 12:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Gu6VI1CX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1634720FA98
	for <kvm@vger.kernel.org>; Thu,  7 Nov 2024 12:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730982162; cv=none; b=s2Ye02Z3UUo8/4IZfKcizkeaaEqEDCjbad3k99kjOj+uZF+aMqbXtEQ20r+LYiDXAjFsMELOyDiBiwxWwMNFaEteBb4+TtTc2K6Wy3Q8xit/EVEz9qYNKjkTs8Cour0ZDI8jiUztRlKRcA29y6U66iDlVEHOJ38NTDg7Mjaz5jI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730982162; c=relaxed/simple;
	bh=BGpYuh/YYhfW/hLpJaRocFAPmWSngUp5Fa1W/C5ceWc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DXfqwpzy58dbdFqlRm+aZQ4VCLQIgQPO9OSKRgG61XaUyTorDO2JHirxecpvk6/hsKVAJU1kdWNDFR6NA7GQ8q+DNgn0r5kuliQvk6wwRgvZxlRlRlQOrDEiB1ub86/ic6r4rapCTD2OOxW9cMWcoWWCzwgAlPksyuuw3J3GEjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Gu6VI1CX; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730982161; x=1762518161;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BGpYuh/YYhfW/hLpJaRocFAPmWSngUp5Fa1W/C5ceWc=;
  b=Gu6VI1CXLZ3PgyHseWmujHlW6pQlI3y+zgS5la+WK3N0fTXftR5/L8pB
   P/XSlXXJbXC2lZaYOfG0C8ufrCJOUQnbfdkXKxT3Ofw8CtfSpho3npTAF
   GX+0moAHNgwBGk9GOK38l16kxI6gXagiL7ysiIkXL3lrEan8Jh9Vp+48W
   66M9dHEdm+ySeLp9EWbWxCUzWGD4GwhiLZM5wIum0C/NyUka8etn63ugZ
   HcCoiHvvWQlSiIQhEhVnsfwzX32cFNGDLVITTdVkkoWH+pV46bnWXtmyP
   IbSlRo7vigm3FRDpNC/a4aWzecMj7hItkEjuwiM1VWyv/xK9+e+t9U+Ep
   g==;
X-CSE-ConnectionGUID: WANliw10SACp6A7mT0s9Iw==
X-CSE-MsgGUID: yFHRrXNUSnuZj71ZBJC6rA==
X-IronPort-AV: E=McAfee;i="6700,10204,11249"; a="34744615"
X-IronPort-AV: E=Sophos;i="6.12,265,1728975600"; 
   d="scan'208";a="34744615"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2024 04:22:38 -0800
X-CSE-ConnectionGUID: dDcCdXDfTOuEBg9DrT/h4w==
X-CSE-MsgGUID: nO8csxGES2W7eDa47BoNuw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,265,1728975600"; 
   d="scan'208";a="90180576"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orviesa004.jf.intel.com with ESMTP; 07 Nov 2024 04:22:39 -0800
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
Subject: [PATCH v6 06/13] iommu/vt-d: Add iommu_domain_did() to get did
Date: Thu,  7 Nov 2024 04:22:27 -0800
Message-Id: <20241107122234.7424-7-yi.l.liu@intel.com>
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


