Return-Path: <kvm+bounces-31758-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E71D9C7153
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 14:49:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4394D28B3BA
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 13:49:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CB32201279;
	Wed, 13 Nov 2024 13:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Pb8u1yy0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CC571F8EEB
	for <kvm@vger.kernel.org>; Wed, 13 Nov 2024 13:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731505580; cv=none; b=benW4sm7cpRe9SmOUmAwHyStU6dY6Vjkqn5H5beyKTEVcGbjPA36NzzuKozWf+nXGBScc3DCShPY+bsgEPWGI9po9j2iObr580tPGrKmdfnYZ06AQtXBqVHhoO8j2NvQ/+gzy3sND4rrUSY0EtIDiHNcgRnNIdZ4DqR13oSZ7LE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731505580; c=relaxed/simple;
	bh=3AqbtmLCwoM3c8F9WaTD6rvQENqm318ez1vv4b46eK8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pEXEtCK5YuaApnGLALwiyckfe5ifaoncVO3ztZKvEkHDoLH+pZWW3j3bsHt0pJJdnbvR57kWYQaDRGnmux9GYP0IRHk/Nk0QE/hvCH5hrbUNPofDrSB8ZI4zaMr325V7jbTNmAAAPwiVnyMOCztl0i2OFvIH+ql+zLrJBvMzpZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Pb8u1yy0; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731505579; x=1763041579;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3AqbtmLCwoM3c8F9WaTD6rvQENqm318ez1vv4b46eK8=;
  b=Pb8u1yy0Uq9l+uaJ2YEEKlVR+5CFwIy2ZCqYMmN4t7VLwxn8odSNtUv1
   XnRA5HnNFMW5lUlI+FAHTMBZ6St8ZphxCRSW8l1bEp1rMuMhtAf6sLcHL
   Binc2HXj97eAmSG8+BzQOzImIs86vM73mVuL/YW/FwmhE+aoIwS7Qi1VB
   K4ecT7N3P8Lt1LV9NetFT+GVtH9MzlmDxiH/cYWPTrDCG28/Ym7pK4i1B
   uDo34syuM6N1w5pBFrNBlQC16hBpZ0nQOL2ouCoLkINYJy8gJGUx6+5E+
   0o3fXeM9GABj3OLG1FuNREo3hv8MxBtyhwDbtx/NcY06tk5ClVyVaHHtH
   Q==;
X-CSE-ConnectionGUID: 2lkPTuDkRj6dvYOIsr8h7g==
X-CSE-MsgGUID: 3VGRiQJmQB67jMdcbtbJ/w==
X-IronPort-AV: E=McAfee;i="6700,10204,11254"; a="42025719"
X-IronPort-AV: E=Sophos;i="6.12,151,1728975600"; 
   d="scan'208";a="42025719"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2024 05:46:17 -0800
X-CSE-ConnectionGUID: A0vWsUhvQyq7FMt8COVkfw==
X-CSE-MsgGUID: QRgU68J5SaiMX9n2iN5TCw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,151,1728975600"; 
   d="scan'208";a="87445604"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmviesa006.fm.intel.com with ESMTP; 13 Nov 2024 05:46:16 -0800
From: Yi Liu <yi.l.liu@intel.com>
To: joro@8bytes.org,
	jgg@nvidia.com,
	kevin.tian@intel.com,
	baolu.lu@linux.intel.com
Cc: eric.auger@redhat.com,
	nicolinc@nvidia.com,
	kvm@vger.kernel.org,
	chao.p.peng@linux.intel.com,
	yi.l.liu@intel.com,
	iommu@lists.linux.dev,
	zhenzhong.duan@intel.com,
	vasant.hegde@amd.com,
	will@kernel.org
Subject: [PATCH v5 5/7] iommu/vt-d: Make the blocked domain support PASID
Date: Wed, 13 Nov 2024 05:46:11 -0800
Message-Id: <20241113134613.7173-6-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241113134613.7173-1-yi.l.liu@intel.com>
References: <20241113134613.7173-1-yi.l.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The blocked domain can be extended to park PASID of a device to be the
DMA blocking state. By this the remove_dev_pasid() op is dropped.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/iommu/intel/iommu.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 527f6f89d8a1..b08981bbd5ca 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -3248,10 +3248,15 @@ static int blocking_domain_attach_dev(struct iommu_domain *domain,
 	return 0;
 }
 
+static int blocking_domain_set_dev_pasid(struct iommu_domain *domain,
+					 struct device *dev, ioasid_t pasid,
+					 struct iommu_domain *old);
+
 static struct iommu_domain blocking_domain = {
 	.type = IOMMU_DOMAIN_BLOCKED,
 	.ops = &(const struct iommu_domain_ops) {
 		.attach_dev	= blocking_domain_attach_dev,
+		.set_dev_pasid	= blocking_domain_set_dev_pasid,
 	}
 };
 
@@ -4105,13 +4110,16 @@ void domain_remove_dev_pasid(struct iommu_domain *domain,
 	kfree(dev_pasid);
 }
 
-static void intel_iommu_remove_dev_pasid(struct device *dev, ioasid_t pasid,
-					 struct iommu_domain *domain)
+static int blocking_domain_set_dev_pasid(struct iommu_domain *domain,
+					 struct device *dev, ioasid_t pasid,
+					 struct iommu_domain *old)
 {
 	struct device_domain_info *info = dev_iommu_priv_get(dev);
 
 	intel_pasid_tear_down_entry(info->iommu, dev, pasid, false);
-	domain_remove_dev_pasid(domain, dev, pasid);
+	domain_remove_dev_pasid(old, dev, pasid);
+
+	return 0;
 }
 
 struct dev_pasid_info *
@@ -4483,7 +4491,6 @@ const struct iommu_ops intel_iommu_ops = {
 	.dev_disable_feat	= intel_iommu_dev_disable_feat,
 	.is_attach_deferred	= intel_iommu_is_attach_deferred,
 	.def_domain_type	= device_def_domain_type,
-	.remove_dev_pasid	= intel_iommu_remove_dev_pasid,
 	.pgsize_bitmap		= SZ_4K,
 	.page_response		= intel_iommu_page_response,
 	.default_domain_ops = &(const struct iommu_domain_ops) {
-- 
2.34.1


