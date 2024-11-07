Return-Path: <kvm+bounces-31111-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AE0F29C05A7
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 13:23:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 64CC81F239DF
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 12:23:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7678212624;
	Thu,  7 Nov 2024 12:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Khz3ObmS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68A762101AE
	for <kvm@vger.kernel.org>; Thu,  7 Nov 2024 12:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730982167; cv=none; b=apfEjtsBnwgbNTIjHRohhTc7ZOr5RA5ZEGbs4RQGWaVqwvTOzRblZ8LSw91aefJ8S6MmK0w9yKedBa5zC7LRC8zM173wjwd6IHiUQ1n5NPT0TxMCdOXXM2Kfd2N/3lNWDkIVe8i9AYt0ZYSoYEEljZBCpbuoTd64v0l2gpo7bDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730982167; c=relaxed/simple;
	bh=RXe1e0lpDmoY4yOdlKQD+FyrfZS6AMGHeVy4+CirLKU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=l2wvnlk4kpiLztrf92Uv45pVhAISHHezJ6dtD852we6Y5Pl6+Asc49PlZ9OZhO8TlUZ+0sLliZY/DvZ+LdfVlOLghMf3oanM72r/pwgZNzsAjW/EFpmVXpCaRmNgkyTUfZBhhA1S5BRe2nbTmAWj9tHuolfE+bZA7JIwvbBLCKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Khz3ObmS; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730982164; x=1762518164;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RXe1e0lpDmoY4yOdlKQD+FyrfZS6AMGHeVy4+CirLKU=;
  b=Khz3ObmSzNLG8SMo16lmkqU84IuSDrvipkGH9FtV2ZYMW0a6rXe20cIy
   yjaHjaWr2iokgib6YDsZArKlLBwScYB4DeLQyFgIT13hUWmt5ibBtAby1
   9QOfJG+wjNS7xxKYZNJ2qHvu7pySrUdmwEGjMSWE72hgulMORxAS3ATEr
   Yr5TAN4cjuIu2oBOf/tp+2qfrC6dtXEPf0TD6m3BIvZpDjxw05S9Bg+0D
   nv1y790dch95Csk8zcvje31lx2f3IwAHgoE5cuQm8g/ylMm16yYjRtt1M
   IRb03baHr+ROqV3vkY76axpLSq5pBiZevx0a0WQDtD+omYVjKxat91dOy
   Q==;
X-CSE-ConnectionGUID: bQDL8tW7Q2O9VK9GeNs1xA==
X-CSE-MsgGUID: qYEDkPpOQw6VWEmFxkOZDQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11249"; a="34744668"
X-IronPort-AV: E=Sophos;i="6.12,265,1728975600"; 
   d="scan'208";a="34744668"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2024 04:22:42 -0800
X-CSE-ConnectionGUID: fZegnVb4Tz6RExKCRozIZQ==
X-CSE-MsgGUID: yPwV+2mwQOKgqV9NJ4xIUQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,265,1728975600"; 
   d="scan'208";a="90180615"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orviesa004.jf.intel.com with ESMTP; 07 Nov 2024 04:22:43 -0800
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
Subject: [PATCH v6 12/13] iommu/arm-smmu-v3: Make set_dev_pasid() op support replace
Date: Thu,  7 Nov 2024 04:22:33 -0800
Message-Id: <20241107122234.7424-13-yi.l.liu@intel.com>
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
index a66d9a044e52..7ee3cbbe3744 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2901,7 +2901,7 @@ static int arm_smmu_s1_set_dev_pasid(struct iommu_domain *domain,
 	 */
 	arm_smmu_make_s1_cd(&target_cd, master, smmu_domain);
 	return arm_smmu_set_pasid(master, to_smmu_domain(domain), id,
-				  &target_cd);
+				  &target_cd, old);
 }
 
 static void arm_smmu_update_ste(struct arm_smmu_master *master,
@@ -2931,16 +2931,13 @@ static void arm_smmu_update_ste(struct arm_smmu_master *master,
 
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
index c9e5290e995a..1e96d4af03f8 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -879,7 +879,7 @@ void arm_smmu_write_cd_entry(struct arm_smmu_master *master, int ssid,
 
 int arm_smmu_set_pasid(struct arm_smmu_master *master,
 		       struct arm_smmu_domain *smmu_domain, ioasid_t pasid,
-		       struct arm_smmu_cd *cd);
+		       struct arm_smmu_cd *cd, struct iommu_domain *old);
 
 void arm_smmu_tlb_inv_asid(struct arm_smmu_device *smmu, u16 asid);
 void arm_smmu_tlb_inv_range_asid(unsigned long iova, size_t size, int asid,
-- 
2.34.1


