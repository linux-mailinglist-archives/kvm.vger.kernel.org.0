Return-Path: <kvm+bounces-30520-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E1429BB5BA
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 14:20:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3FD531C212DE
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 13:20:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26A5533997;
	Mon,  4 Nov 2024 13:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SQjRjttE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C980C7DA7F
	for <kvm@vger.kernel.org>; Mon,  4 Nov 2024 13:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730726341; cv=none; b=jloShrX7eO5wWVvdWQWr1ZRgzkBS7jEvLexsRlgk7pbIPnLBp7SB4vAwJkJww6Z5IOF8jw10z8j4gNGvWSBONHFWOV8iqN1YMMLwTyP5X/uJu+DKjkMftZhpbmMKik1UTRIdwLrTXERZmzYqdCoqwDvjNmN5hWcOuU1hz94hOaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730726341; c=relaxed/simple;
	bh=SYj15z/ogv6J4fbQg9p7v/RpHc+betXLufbfOn3+VwM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oyU/bTpqzG0Ru9EpSE7+xyPk0SSiEnYEiNhjmbrzWjE0/yhFp8v9yCfEMg6QSyndfZUrVABXhRfiDSYHk0NedREnYCnOwJsibj2Gc7DenPiLVbxqVJgvoWiORI9BJtJHWm/5GBVBkxjPm51q6plHfgeeOdJxRsEvSlFE780em7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SQjRjttE; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730726340; x=1762262340;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SYj15z/ogv6J4fbQg9p7v/RpHc+betXLufbfOn3+VwM=;
  b=SQjRjttEAFnpU4Nctne8/N0UXNK7PuX2qAq1oWC4gymQvRllL99Xa9Sm
   5AC681GNj6Nph6oPWRiqCj2jmtMtBrzSGWEDbdgOL/y1pqBBXxExTuWyi
   rNKzPFy/RF1QuPCiwoCAm6mQn2ong0Lkkqb+g3one1PvbW7PlCpCrBaej
   i+o7jVwaAJ4fv6aZ6qIRbXJ/Ek+TFI7keepNVppwmxcsWKx4EKzwKTWJ8
   i0/mEI46YRaW4Tf9DN07Lb44U3SeezBLijLcoXHiKJtAj8emSOKUpAmrD
   86dJrQBPZMXBonjelrdfzGrgT00oaCncrh4jmtZDfa9zMhBc4K02YDkj8
   A==;
X-CSE-ConnectionGUID: VuxPD2qOSVSWDWoRnJZqyg==
X-CSE-MsgGUID: IkbStMZYRQGrthHWCwxbrw==
X-IronPort-AV: E=McAfee;i="6700,10204,11246"; a="41003796"
X-IronPort-AV: E=Sophos;i="6.11,257,1725346800"; 
   d="scan'208";a="41003796"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 05:18:59 -0800
X-CSE-ConnectionGUID: ajABMCAJRzOoHW+2If8dmw==
X-CSE-MsgGUID: fnRj1eeqTH2s10t7mwZVKg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,257,1725346800"; 
   d="scan'208";a="83999556"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmviesa010.fm.intel.com with ESMTP; 04 Nov 2024 05:18:58 -0800
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
Subject: [PATCH v4 12/13] iommu/arm-smmu-v3: Make set_dev_pasid() op support replace
Date: Mon,  4 Nov 2024 05:18:41 -0800
Message-Id: <20241104131842.13303-13-yi.l.liu@intel.com>
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

From: Jason Gunthorpe <jgg@nvidia.com>

set_dev_pasid() op is going to be enhanced to support domain replacement
of a pasid. This prepares for this op definition.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c | 2 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c     | 9 +++------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h     | 2 +-
 3 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index 645da7b69bed..1d3e71569775 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -349,7 +349,7 @@ static int arm_smmu_sva_set_dev_pasid(struct iommu_domain *domain,
 	 * get reassigned
 	 */
 	arm_smmu_make_sva_cd(&target, master, domain->mm, smmu_domain->cd.asid);
-	ret = arm_smmu_set_pasid(master, smmu_domain, id, &target);
+	ret = arm_smmu_set_pasid(master, smmu_domain, id, &target, old);
 
 	mmput(domain->mm);
 	return ret;
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index a40681f8c348..2d188d12f85c 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2883,7 +2883,7 @@ static int arm_smmu_s1_set_dev_pasid(struct iommu_domain *domain,
 	 */
 	arm_smmu_make_s1_cd(&target_cd, master, smmu_domain);
 	return arm_smmu_set_pasid(master, to_smmu_domain(domain), id,
-				  &target_cd);
+				  &target_cd, old);
 }
 
 static void arm_smmu_update_ste(struct arm_smmu_master *master,
@@ -2913,16 +2913,13 @@ static void arm_smmu_update_ste(struct arm_smmu_master *master,
 
 int arm_smmu_set_pasid(struct arm_smmu_master *master,
 		       struct arm_smmu_domain *smmu_domain, ioasid_t pasid,
-		       struct arm_smmu_cd *cd)
+		       struct arm_smmu_cd *cd, struct iommu_domain *old)
 {
 	struct iommu_domain *sid_domain = iommu_get_domain_for_dev(master->dev);
 	struct arm_smmu_attach_state state = {
 		.master = master,
-		/*
-		 * For now the core code prevents calling this when a domain is
-		 * already attached, no need to set old_domain.
-		 */
 		.ssid = pasid,
+		.old_domain = old,
 	};
 	struct arm_smmu_cd *cdptr;
 	int ret;
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 1e9952ca989f..52eaa0bedee1 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -875,7 +875,7 @@ void arm_smmu_write_cd_entry(struct arm_smmu_master *master, int ssid,
 
 int arm_smmu_set_pasid(struct arm_smmu_master *master,
 		       struct arm_smmu_domain *smmu_domain, ioasid_t pasid,
-		       struct arm_smmu_cd *cd);
+		       struct arm_smmu_cd *cd, struct iommu_domain *old);
 
 void arm_smmu_tlb_inv_asid(struct arm_smmu_device *smmu, u16 asid);
 void arm_smmu_tlb_inv_range_asid(unsigned long iova, size_t size, int asid,
-- 
2.34.1


