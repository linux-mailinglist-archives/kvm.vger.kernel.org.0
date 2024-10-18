Return-Path: <kvm+bounces-29135-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 20B0C9A34D7
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2024 07:58:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 991941F24DBF
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2024 05:58:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42940191F75;
	Fri, 18 Oct 2024 05:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Pj9quu45"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2F73185B67
	for <kvm@vger.kernel.org>; Fri, 18 Oct 2024 05:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729230850; cv=none; b=aDnJ73ZdHEZvin5fbwGXWSf9fp0OMRc9E5b7l4az8stPylwp491z3XEqjwUgKlISyCHHwI4FU7naeY1v4RLJ4mxfYt6m19T/yGGKROKjXnzIb3IDpx13hylxSrSEZbZp4aDg0fI1elmaj0F/HxfTgS8Qev4rquHMCxYTm4hUfns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729230850; c=relaxed/simple;
	bh=yVqaIp2WMQHV7/dNBS2jr8RfBZCkhM7wRbK2Qwl1S6o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rWrX6pPUnKxo3MUd51Z9y8b0kuD9Snp27ffqzZndKHD3FKcC4f8J7/TDz/gHvnKQdy3PeymdmVkKMMQGaEMtciQgXK8RPXTw8AUkFDbN8zx3pp4Baq+zpX16mwxguDMHf2JdQ4Qwy5lIAEY9iW51MYMaIhoaHjYSzeprT8PUTRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Pj9quu45; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729230849; x=1760766849;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yVqaIp2WMQHV7/dNBS2jr8RfBZCkhM7wRbK2Qwl1S6o=;
  b=Pj9quu456s9yQsfYB1YLGAZW/kl+QNiAxW7SYbTwsCDxAiRQ8tYfd6Iq
   RXFKK0FBho3NyK8DXn9jMzNHt5QCVmOp5J+7dRA1UCs95c8dY5EdtlJf5
   fIw8xQb90QelNmUEHfP/+ilUme8TrvJ/jwXBpPAPeOk4qWhv18sWdOTnT
   jykzYSPFDOkH+s4lmIQo9B37gtzggXCfZNfrjnsK2TbWyZJMYVIvZAmtI
   CPgjZ/myQLLGNtzQPMhLrWDhrMzPAIpxd0vDnl48I7cv5FdWLD1kYmG8e
   KvwRsXa12SoZdvTQSI6hJmMfy1eJDIEDuTWDo+YpM114WFqJBc5FUbKQ7
   w==;
X-CSE-ConnectionGUID: OcBNh0JEQO61ZmbRNx2CHA==
X-CSE-MsgGUID: o9vG8Z/tSXSAzMrVAToRKg==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="28708811"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="28708811"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2024 22:54:07 -0700
X-CSE-ConnectionGUID: F9ZX8GLPRSKN6aZ8LpiDqw==
X-CSE-MsgGUID: fPFOsZ9pSvuxapOIzEUtpg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,212,1725346800"; 
   d="scan'208";a="79188583"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orviesa007.jf.intel.com with ESMTP; 17 Oct 2024 22:54:07 -0700
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
Subject: [PATCH v3 5/9] iommu/vt-d: Rename prepare_domain_attach_device()
Date: Thu, 17 Oct 2024 22:53:58 -0700
Message-Id: <20241018055402.23277-6-yi.l.liu@intel.com>
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

This helper is to ensure the domain is compatible with the device's iommu,
so it is more sanity check than preparation. Hence, rename it.

Suggested-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/iommu/intel/iommu.c  | 8 ++++----
 drivers/iommu/intel/iommu.h  | 4 ++--
 drivers/iommu/intel/nested.c | 2 +-
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index ae3522a1e025..8d92a221d020 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -3581,8 +3581,8 @@ static void intel_iommu_domain_free(struct iommu_domain *domain)
 	domain_exit(dmar_domain);
 }
 
-int prepare_domain_attach_device(struct iommu_domain *domain,
-				 struct device *dev)
+int domain_attach_device_sanitize(struct iommu_domain *domain,
+				  struct device *dev)
 {
 	struct device_domain_info *info = dev_iommu_priv_get(dev);
 	struct dmar_domain *dmar_domain = to_dmar_domain(domain);
@@ -3632,7 +3632,7 @@ static int intel_iommu_attach_device(struct iommu_domain *domain,
 
 	device_block_translation(dev);
 
-	ret = prepare_domain_attach_device(domain, dev);
+	ret = domain_attach_device_sanitize(domain, dev);
 	if (ret)
 		return ret;
 
@@ -4304,7 +4304,7 @@ static int intel_iommu_set_dev_pasid(struct iommu_domain *domain,
 	if (context_copied(iommu, info->bus, info->devfn))
 		return -EBUSY;
 
-	ret = prepare_domain_attach_device(domain, dev);
+	ret = domain_attach_device_sanitize(domain, dev);
 	if (ret)
 		return ret;
 
diff --git a/drivers/iommu/intel/iommu.h b/drivers/iommu/intel/iommu.h
index 1497f3112b12..b020ae90c47e 100644
--- a/drivers/iommu/intel/iommu.h
+++ b/drivers/iommu/intel/iommu.h
@@ -1230,8 +1230,8 @@ void __iommu_flush_iotlb(struct intel_iommu *iommu, u16 did, u64 addr,
 int domain_attach_iommu(struct dmar_domain *domain, struct intel_iommu *iommu);
 void domain_detach_iommu(struct dmar_domain *domain, struct intel_iommu *iommu);
 void device_block_translation(struct device *dev);
-int prepare_domain_attach_device(struct iommu_domain *domain,
-				 struct device *dev);
+int domain_attach_device_sanitize(struct iommu_domain *domain,
+				  struct device *dev);
 void domain_update_iommu_cap(struct dmar_domain *domain);
 
 int dmar_ir_support(void);
diff --git a/drivers/iommu/intel/nested.c b/drivers/iommu/intel/nested.c
index 433c58944401..c1e97ad6be24 100644
--- a/drivers/iommu/intel/nested.c
+++ b/drivers/iommu/intel/nested.c
@@ -40,7 +40,7 @@ static int intel_nested_attach_dev(struct iommu_domain *domain,
 	 * The s2_domain will be used in nested translation, hence needs
 	 * to ensure the s2_domain is compatible with this IOMMU.
 	 */
-	ret = prepare_domain_attach_device(&dmar_domain->s2_domain->domain, dev);
+	ret = domain_attach_device_sanitize(&dmar_domain->s2_domain->domain, dev);
 	if (ret) {
 		dev_err_ratelimited(dev, "s2 domain is not compatible\n");
 		return ret;
-- 
2.34.1


