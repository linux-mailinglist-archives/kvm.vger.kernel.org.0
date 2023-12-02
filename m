Return-Path: <kvm+bounces-3237-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 247C7801BE8
	for <lists+kvm@lfdr.de>; Sat,  2 Dec 2023 10:55:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C26671F211A3
	for <lists+kvm@lfdr.de>; Sat,  2 Dec 2023 09:55:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FBDD14A8D;
	Sat,  2 Dec 2023 09:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GpvP4aUk"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AA98CC;
	Sat,  2 Dec 2023 01:55:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701510901; x=1733046901;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=qum6bCO8m1UvZ+EuWUSsWmgfywLvc9j17rJU1lVG7vc=;
  b=GpvP4aUkodMLkK1ZQa9oV57K5vnj9XouXDzVO88zrBYZmeFNyEiViWle
   8ipuBfa4HMy7sAhQEsJzA9Ll1SUB95xxj7I+BlcTZR3kEHHbc3C47T544
   ZmI4MaqS/GimDRi9JRi5T1moEgsBZ8OndUm78AcL+dFaw5sR1TVt+Fj3A
   fTg9Ulp22qN6AjvNBBD6rAFOqoFZoCXG36o89v/gNcqQmL+ILc0so4+mp
   CdEL5jQBzBC2J/e9NNoNJeZOsvMxteQTv1tMcUHS9cjI0R7QPhMDL0dSU
   f0B2L9x82rKuUOIyTZJfbYyQU3EdLrYG+GtlrrPbGqVrOcOtkvo9u23B/
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10911"; a="393322186"
X-IronPort-AV: E=Sophos;i="6.04,245,1695711600"; 
   d="scan'208";a="393322186"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2023 01:55:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10911"; a="804336985"
X-IronPort-AV: E=Sophos;i="6.04,245,1695711600"; 
   d="scan'208";a="804336985"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2023 01:54:56 -0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: iommu@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: alex.williamson@redhat.com,
	jgg@nvidia.com,
	pbonzini@redhat.com,
	seanjc@google.com,
	joro@8bytes.org,
	will@kernel.org,
	robin.murphy@arm.com,
	kevin.tian@intel.com,
	baolu.lu@linux.intel.com,
	dwmw2@infradead.org,
	yi.l.liu@intel.com,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: [RFC PATCH 21/42] iommu/vt-d: Check reserved bits for IOMMU_DOMAIN_KVM domain
Date: Sat,  2 Dec 2023 17:26:02 +0800
Message-Id: <20231202092602.14704-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20231202091211.13376-1-yan.y.zhao@intel.com>
References: <20231202091211.13376-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

Compatibility check between IOMMU driver and KVM.
rsvd_bits_mask is provided by KVM to guarantee that the set bits are
must-be-zero bits in PTEs. Intel vt-d driver can check it to see if all
must-be-zero bits required by IOMMU side are included.

In this RFC, only bit 11 is checked for simplicity and demo purpose.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 drivers/iommu/intel/kvm.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/iommu/intel/kvm.c b/drivers/iommu/intel/kvm.c
index 1ce334785430b..998d6daaf7ea1 100644
--- a/drivers/iommu/intel/kvm.c
+++ b/drivers/iommu/intel/kvm.c
@@ -32,6 +32,18 @@ static bool is_iommu_cap_compatible_to_kvm_domain(struct dmar_domain *domain,
 	return true;
 }
 
+static int check_tdp_reserved_bits(const struct kvm_exported_tdp_meta_vmx *tdp)
+{
+	int i;
+
+	for (i = PT64_ROOT_MAX_LEVEL; --i >= 0;) {
+		if (!(tdp->rsvd_bits_mask[0][i] & BIT(11)) ||
+		    !(tdp->rsvd_bits_mask[1][i] & BIT(11)))
+			return -EFAULT;
+	}
+	return 0;
+}
+
 int prepare_kvm_domain_attach(struct dmar_domain *domain, struct intel_iommu *iommu)
 {
 	if (is_iommu_cap_compatible_to_kvm_domain(domain, iommu))
@@ -90,6 +102,11 @@ intel_iommu_domain_alloc_kvm(struct device *dev, u32 flags, const void *data)
 		return ERR_PTR(-EOPNOTSUPP);
 	}
 
+	if (check_tdp_reserved_bits(tdp)) {
+		pr_err("Reserved bits incompatible between KVM and IOMMU\n");
+		return ERR_PTR(-EOPNOTSUPP);
+	}
+
 	dmar_domain = alloc_domain(IOMMU_DOMAIN_KVM);
 	if (!dmar_domain)
 		return ERR_PTR(-ENOMEM);
-- 
2.17.1


