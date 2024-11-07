Return-Path: <kvm+bounces-31109-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 89FDB9C05A5
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 13:23:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 426211F23B84
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 12:23:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80D3121218C;
	Thu,  7 Nov 2024 12:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cQcZkrMJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04D332101A6
	for <kvm@vger.kernel.org>; Thu,  7 Nov 2024 12:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730982165; cv=none; b=N5GST/qpbYH9+v3nbTWR5eDm7HgR/9v7T/eSO8OuHt86VGFJTIJscHqFh92SyCHzc6gaDhORXuqpnHW8ZRDbUj0T2uJJfDjTMPxTHq/1ehgGqrDVPDbhkao3mygWTeuiYI18bH1s+3epSb+Inepc1pOT67LMJb7XE6dysgDsBO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730982165; c=relaxed/simple;
	bh=0dXEP774t5JUA/b7B8Un96vzXSbyWCFBwGmkRxdccvQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UhrMJIqh4VJKxZCLScJWEReQAo8gm36Ux6WOFxln2w35yVksdMzkhplXjmAiB7c3PxNgilMV8kCQ0SJgQ29ULnuMT6Z4HGMfpnGvcHqvRCO/2/VfweDRaejQM1WwRG0PFLGPIPaInNUBQVfUmpj5hvod2weS9k5dAMxPxF+JK3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cQcZkrMJ; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730982164; x=1762518164;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0dXEP774t5JUA/b7B8Un96vzXSbyWCFBwGmkRxdccvQ=;
  b=cQcZkrMJKTCH6ZmkXNAsuCBvTIK9smArQh+FhkTJivwbPNeGzRCLBONm
   E/dBto8vOZrjViqjoa2ES/3g0j+WE5omsbsEpXexwU7u45Y+yQ1zECB7z
   9Yv6uNN+snKm8Ud1d18APZavtu8DOb4XV8CMttYQKjSdwxE66jcGQZ0qN
   d1Dk0OrBAdyYExId/v2a12bOJDGjXDC/2XPFxrRe896kNhs9u/BSI3eJx
   j81RWPPFOm0KdSLLIlVUsUKHrYT0x6+yl/rRxNO0mqjafqS1KHhOhPEmm
   gyZPntOQTcbVc2janxr2a5E6f65hA0kosheXW0lOynSM021O5+jo1rZcA
   A==;
X-CSE-ConnectionGUID: we2lf3SmRxK3p7dOlFKelQ==
X-CSE-MsgGUID: SVi+1yX9Q/C9N/a05vvmxA==
X-IronPort-AV: E=McAfee;i="6700,10204,11249"; a="34744654"
X-IronPort-AV: E=Sophos;i="6.12,265,1728975600"; 
   d="scan'208";a="34744654"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2024 04:22:40 -0800
X-CSE-ConnectionGUID: BdZorJjoTL28SMYbp1/B1Q==
X-CSE-MsgGUID: 15guzmw/S8W0eSbELT7wTg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,265,1728975600"; 
   d="scan'208";a="90180601"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orviesa004.jf.intel.com with ESMTP; 07 Nov 2024 04:22:41 -0800
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
Subject: [PATCH v6 10/13] iommu/vt-d: Make identity_domain_set_dev_pasid() to handle domain replacement
Date: Thu,  7 Nov 2024 04:22:31 -0800
Message-Id: <20241107122234.7424-11-yi.l.liu@intel.com>
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

Let identity_domain_set_dev_pasid() call the pasid replace helpers hence
be able to do domain replacement.

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/iommu/intel/iommu.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 06a7c4bf31e0..f69ea5b48ee8 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -1778,6 +1778,17 @@ static int domain_setup_second_level(struct intel_iommu *iommu,
 						pasid);
 }
 
+static int domain_setup_passthrough(struct intel_iommu *iommu,
+				    struct device *dev, ioasid_t pasid,
+				    struct iommu_domain *old)
+{
+	if (!old)
+		return intel_pasid_setup_pass_through(iommu, dev, pasid);
+	return intel_pasid_replace_pass_through(iommu, dev,
+						iommu_domain_did(old, iommu),
+						pasid);
+}
+
 static int domain_setup_first_level(struct intel_iommu *iommu,
 				    struct dmar_domain *domain,
 				    struct device *dev,
@@ -4425,11 +4436,17 @@ static int identity_domain_set_dev_pasid(struct iommu_domain *domain,
 {
 	struct device_domain_info *info = dev_iommu_priv_get(dev);
 	struct intel_iommu *iommu = info->iommu;
+	int ret;
 
 	if (!pasid_supported(iommu) || dev_is_real_dma_subdevice(dev))
 		return -EOPNOTSUPP;
 
-	return intel_pasid_setup_pass_through(iommu, dev, pasid);
+	ret = domain_setup_passthrough(iommu, dev, pasid, old);
+	if (ret)
+		return ret;
+
+	domain_remove_dev_pasid(old, dev, pasid);
+	return 0;
 }
 
 static struct iommu_domain identity_domain = {
-- 
2.34.1


