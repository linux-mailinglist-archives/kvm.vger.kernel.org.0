Return-Path: <kvm+bounces-29133-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B7579A34D5
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2024 07:58:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 03CC2B23B8A
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2024 05:58:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D77121917E6;
	Fri, 18 Oct 2024 05:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BFOtUE/C"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 444B517E019
	for <kvm@vger.kernel.org>; Fri, 18 Oct 2024 05:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729230849; cv=none; b=tZBw/X1XBE839iWDJMOhw+4hRVIw2ThURKGasIuT2HjrE7UHBa+ckIQcosGstb1bUk85UXxZC+ZISNkVZ9J0Yn9GQG44XqtCTVMCGLRg9PUF8JTbHSegMIn+FVHRE9d1ipOND4kLdWCLHZcegRcSudZP/cRzTAYOnKNp3WUF8eQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729230849; c=relaxed/simple;
	bh=wUPQLKVX1bjTKQzLd4tMHIGDR5aBztDgLszriqgvMGc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Z+zDn4gfS9fdAOTjjerQujH+e0/EsTScEUHDFutTvfBKHZFOEp1hev4uUfzrEWwnFY3mZlWiLdlG1caQtki6gyXwa/AMzDfJ42MNp4rlTR7+EvXBjzVA4j9p+jskF5sXCgCVnEO3IGqvKbHNRzI5Z/zpYtFmmuXyRw+WP36ruus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BFOtUE/C; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729230848; x=1760766848;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wUPQLKVX1bjTKQzLd4tMHIGDR5aBztDgLszriqgvMGc=;
  b=BFOtUE/CdASFXnZ570nb7a8hsBBj0tdH2XM4yUwbcWngJgtoFPGRMtSQ
   TwCe7I/FIfV3sulaaQwW0STGhDwrHLhoKgFJpziqnXd0UR3nXHTw8M8Vc
   sCOGZ8nkikDai+i4DrVtaC6zxsb2MPdvGIh0b0qQmF4YWKGjaeNglwwTR
   iJqoLsi2pO7VbU8XHUj2bhrxsl31tmn+rzK27CDCO7Fw97Peo80RNe63I
   dKsFtnV0CyWEoMPxL2yUs49MbP2Ki1kfK5FZLffs5bL4NBWi1tpEuSfjq
   vxKB2+RcVnKRRQNpvsTS5OFwVL0h9RDmSZebvluZBbGADhE1HDG8QxmYF
   g==;
X-CSE-ConnectionGUID: YzfuAF/gQBWIAnGIlYnCUA==
X-CSE-MsgGUID: 3h/zy00CRTS+H3Jarg2Hzw==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="28708793"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="28708793"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2024 22:54:07 -0700
X-CSE-ConnectionGUID: aMUj7PjxRVqurb9kp9IwMg==
X-CSE-MsgGUID: QITt8g7iQbKLCMP1+8zJ1A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,212,1725346800"; 
   d="scan'208";a="79188568"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orviesa007.jf.intel.com with ESMTP; 17 Oct 2024 22:54:06 -0700
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
Subject: [PATCH v3 3/9] iommu/vt-d: Let intel_pasid_tear_down_entry() return pasid entry
Date: Thu, 17 Oct 2024 22:53:56 -0700
Message-Id: <20241018055402.23277-4-yi.l.liu@intel.com>
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

intel_pasid_tear_down_entry() finds the pasid entry and tears it down.
There are paths that need to get the pasid entry, tear it down and
re-configure it. Letting intel_pasid_tear_down_entry() return the pasid
entry can avoid duplicate codes to get the pasid entry. No functional
change is intended.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/iommu/intel/pasid.c | 11 ++++++++---
 drivers/iommu/intel/pasid.h |  5 +++--
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/pasid.c
index 2898e7af2cf4..336f9425214c 100644
--- a/drivers/iommu/intel/pasid.c
+++ b/drivers/iommu/intel/pasid.c
@@ -239,9 +239,12 @@ devtlb_invalidation_with_pasid(struct intel_iommu *iommu,
 /*
  * Caller can request to drain PRQ in this helper if it hasn't done so,
  * e.g. in a path which doesn't follow remove_dev_pasid().
+ * Return the pasid entry pointer if the entry is found or NULL if no
+ * entry found.
  */
-void intel_pasid_tear_down_entry(struct intel_iommu *iommu, struct device *dev,
-				 u32 pasid, u32 flags)
+struct pasid_entry *
+intel_pasid_tear_down_entry(struct intel_iommu *iommu, struct device *dev,
+			    u32 pasid, u32 flags)
 {
 	struct pasid_entry *pte;
 	u16 did, pgtt;
@@ -250,7 +253,7 @@ void intel_pasid_tear_down_entry(struct intel_iommu *iommu, struct device *dev,
 	pte = intel_pasid_get_entry(dev, pasid);
 	if (WARN_ON(!pte) || !pasid_pte_is_present(pte)) {
 		spin_unlock(&iommu->lock);
-		return;
+		goto out;
 	}
 
 	did = pasid_get_domain_id(pte);
@@ -273,6 +276,8 @@ void intel_pasid_tear_down_entry(struct intel_iommu *iommu, struct device *dev,
 
 	if (flags & INTEL_PASID_TEARDOWN_DRAIN_PRQ)
 		intel_drain_pasid_prq(dev, pasid);
+out:
+	return pte;
 }
 
 /*
diff --git a/drivers/iommu/intel/pasid.h b/drivers/iommu/intel/pasid.h
index 7dc9e4dfbd88..9b2351325b0e 100644
--- a/drivers/iommu/intel/pasid.h
+++ b/drivers/iommu/intel/pasid.h
@@ -306,8 +306,9 @@ int intel_pasid_setup_nested(struct intel_iommu *iommu, struct device *dev,
 
 #define INTEL_PASID_TEARDOWN_IGNORE_FAULT	BIT(0)
 #define INTEL_PASID_TEARDOWN_DRAIN_PRQ		BIT(1)
-void intel_pasid_tear_down_entry(struct intel_iommu *iommu, struct device *dev,
-				 u32 pasid, u32 flags);
+struct pasid_entry *
+intel_pasid_tear_down_entry(struct intel_iommu *iommu, struct device *dev,
+			    u32 pasid, u32 flags);
 void intel_pasid_setup_page_snoop_control(struct intel_iommu *iommu,
 					  struct device *dev, u32 pasid);
 int intel_pasid_setup_sm_context(struct device *dev);
-- 
2.34.1


