Return-Path: <kvm+bounces-20646-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D44691BA7D
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 10:56:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2055C1F2314A
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 08:56:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89D6C14F133;
	Fri, 28 Jun 2024 08:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aVyTL/7m"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FA1114F9C7
	for <kvm@vger.kernel.org>; Fri, 28 Jun 2024 08:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719564946; cv=none; b=GGC+X4Bsq9FnETeVVj5wHqZugBglMglXvg1F0dMEMFawDMKPmPwdWkzhDgshwea0Uf4d+fvg+fhbJ4SravuUgKrlh6iAP5b2sJ/6elyBmcHG0K7qe8m17krNfvbPmKuC04mniFPbSDJs5yD93wGYL4sTdoHijyL2o6jO7RWVr50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719564946; c=relaxed/simple;
	bh=Js/4DBsuO1vV4uLmXd2p4KDWTVZjkjEPu4jfbEQtC9Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FmgV5AWf/75D5mzgMy9USebKqUSni5FMU+r493eY4e2H4xny/Kp2wTorKvHxXYrcy2CaFtWb+bQ6WwxiYuwvEHSGB9qtTWwkYyAlFbqsNgcObuhve8k0WyvjRlQB6v9sK9hqdzK00cAYJRTJVljfDwIKbUNsqn+lSXU7sSGChgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aVyTL/7m; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719564945; x=1751100945;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Js/4DBsuO1vV4uLmXd2p4KDWTVZjkjEPu4jfbEQtC9Y=;
  b=aVyTL/7mZ2nA+S0FDwFF/t0wz6C5ZqHZuZfVnixQqEaKisPInicO+kfI
   AffOo8qCrpOXbTsvFCkYmp3dj3KVCF430XZyHlprEmOtdWrge5uT8eqyK
   uDuYekJD1tybwKwFZppx9wO5vOVZ6XE5ckCmslUUHargSkCeuNxhJq166
   8wWvv2VfIxRpNFWL35s+1A8y0Y0+6+j3CfOxJvFfj5T+X0yQC1gaBHW2X
   2lgwd+4LTtTTfFuOEeA9KnxeBNWtxUNcxQd67KjHOM48z6QYC5mH/E3B+
   FyfFGtV8y8DaQ7NzSZoSyEtmVGs5tUuvp+GN40IKCnHRUzm4FiqXjEuqk
   w==;
X-CSE-ConnectionGUID: eiOXGPwXTaCOZd4+TbYj5A==
X-CSE-MsgGUID: X3bsL3CfSlSwhLD4I2XLqw==
X-IronPort-AV: E=McAfee;i="6700,10204,11116"; a="34277510"
X-IronPort-AV: E=Sophos;i="6.09,168,1716274800"; 
   d="scan'208";a="34277510"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2024 01:55:44 -0700
X-CSE-ConnectionGUID: 7TcxbM0cRhWmknKmvCgdOQ==
X-CSE-MsgGUID: 774rk1KvTpWiSWWiHYK+Ag==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,168,1716274800"; 
   d="scan'208";a="44584543"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orviesa010.jf.intel.com with ESMTP; 28 Jun 2024 01:55:44 -0700
From: Yi Liu <yi.l.liu@intel.com>
To: joro@8bytes.org,
	jgg@nvidia.com,
	kevin.tian@intel.com,
	baolu.lu@linux.intel.com
Cc: alex.williamson@redhat.com,
	robin.murphy@arm.com,
	eric.auger@redhat.com,
	nicolinc@nvidia.com,
	kvm@vger.kernel.org,
	chao.p.peng@linux.intel.com,
	yi.l.liu@intel.com,
	iommu@lists.linux.dev
Subject: [PATCH 5/6] iommu/vt-d: Add set_dev_pasid callback for nested domain
Date: Fri, 28 Jun 2024 01:55:37 -0700
Message-Id: <20240628085538.47049-6-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240628085538.47049-1-yi.l.liu@intel.com>
References: <20240628085538.47049-1-yi.l.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Lu Baolu <baolu.lu@linux.intel.com>

Extend intel_iommu_set_dev_pasid() to set a nested type domain to a PASID
of a device.

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Co-developed-by: Yi Liu <yi.l.liu@intel.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/iommu/intel/iommu.c  | 22 +++++++++++++++++-----
 drivers/iommu/intel/iommu.h  |  3 +++
 drivers/iommu/intel/nested.c |  1 +
 3 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 8ef6c06f7e73..b7051d9460cd 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -284,6 +284,11 @@ static int __init intel_iommu_setup(char *str)
 }
 __setup("intel_iommu=", intel_iommu_setup);
 
+static int domain_type_is_nested(struct dmar_domain *domain)
+{
+	return domain->domain.type == IOMMU_DOMAIN_NESTED;
+}
+
 static int domain_pfn_supported(struct dmar_domain *domain, unsigned long pfn)
 {
 	int addr_width = agaw_to_width(domain->agaw) - VTD_PAGE_SHIFT;
@@ -4081,7 +4086,12 @@ domain_prepare_dev_pasid(struct iommu_domain *domain,
 	unsigned long flags;
 	int ret;
 
-	ret = prepare_domain_attach_device(domain, dev);
+	/* Nested type domain should prepare its parent domain */
+	if (domain_type_is_nested(dmar_domain))
+		ret = prepare_domain_attach_device(
+				&dmar_domain->s2_domain->domain, dev);
+	else
+		ret = prepare_domain_attach_device(domain, dev);
 	if (ret)
 		return ERR_PTR(ret);
 
@@ -4111,9 +4121,9 @@ domain_prepare_dev_pasid(struct iommu_domain *domain,
 	return ERR_PTR(ret);
 }
 
-static int intel_iommu_set_dev_pasid(struct iommu_domain *domain,
-				     struct device *dev, ioasid_t pasid,
-				     struct iommu_domain *old)
+int intel_iommu_set_dev_pasid(struct iommu_domain *domain,
+			      struct device *dev, ioasid_t pasid,
+			      struct iommu_domain *old)
 {
 	struct device_domain_info *info = dev_iommu_priv_get(dev);
 	struct dmar_domain *dmar_domain = to_dmar_domain(domain);
@@ -4134,7 +4144,9 @@ static int intel_iommu_set_dev_pasid(struct iommu_domain *domain,
 	if (IS_ERR(dev_pasid))
 		return PTR_ERR(dev_pasid);
 
-	if (dmar_domain->use_first_level)
+	if (domain_type_is_nested(dmar_domain))
+		ret = intel_pasid_setup_nested(iommu, dev, pasid, dmar_domain);
+	else if (dmar_domain->use_first_level)
 		ret = domain_setup_first_level(iommu, dmar_domain,
 					       dev, pasid);
 	else
diff --git a/drivers/iommu/intel/iommu.h b/drivers/iommu/intel/iommu.h
index eaf015b4353b..63ef3a8a8832 100644
--- a/drivers/iommu/intel/iommu.h
+++ b/drivers/iommu/intel/iommu.h
@@ -1104,6 +1104,9 @@ void device_block_translation(struct device *dev);
 int prepare_domain_attach_device(struct iommu_domain *domain,
 				 struct device *dev);
 void domain_update_iommu_cap(struct dmar_domain *domain);
+int intel_iommu_set_dev_pasid(struct iommu_domain *domain,
+			      struct device *dev, ioasid_t pasid,
+			      struct iommu_domain *old);
 
 int dmar_ir_support(void);
 
diff --git a/drivers/iommu/intel/nested.c b/drivers/iommu/intel/nested.c
index 16a2bcf5cfeb..179868d34a4b 100644
--- a/drivers/iommu/intel/nested.c
+++ b/drivers/iommu/intel/nested.c
@@ -133,6 +133,7 @@ static int intel_nested_cache_invalidate_user(struct iommu_domain *domain,
 
 static const struct iommu_domain_ops intel_nested_domain_ops = {
 	.attach_dev		= intel_nested_attach_dev,
+	.set_dev_pasid		= intel_iommu_set_dev_pasid,
 	.free			= intel_nested_domain_free,
 	.cache_invalidate_user	= intel_nested_cache_invalidate_user,
 };
-- 
2.34.1


