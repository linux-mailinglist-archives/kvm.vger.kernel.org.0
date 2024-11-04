Return-Path: <kvm+bounces-30515-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A7E099BB5B3
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 14:19:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5D8CB1F2251E
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 13:19:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 652BF487BF;
	Mon,  4 Nov 2024 13:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eWP97bpk"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B4DA2B9BC
	for <kvm@vger.kernel.org>; Mon,  4 Nov 2024 13:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730726336; cv=none; b=i2fgBoWcSSDG5R790ZU2wsl6OMc31gi2zw2/9KDEWIx9jBhIGY/7B2JvllarmuFMd7FbWJex/HHnoLtJ5lk5Cvhm5/EvcrjdNFNj1FJvTOb3Vm+eZbk8Fz0/XUSKKi6XArNm60zCMwxmmZTAQimnIUiOVDFpBlu32F1NR/5J1Qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730726336; c=relaxed/simple;
	bh=e4X7a17BQA3CE/pG8qiH6PFO3PoRwLXWBTresK09WO4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=COHqcRezH9kngT/p7MTECXxio7v4vPIW7ike9u3bWFluSHzq4q9b0Vmv66dH12za6lMaYtGMnGaiZYKGXMVPGjyyPnpqPK8vsjeIwzvKAeiO8863WBTl5bkamcn3WpRslbQ5HOYJ9NyK2tc6ytz6TRoKTvlCTG5CXvPOUgnnqf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eWP97bpk; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730726335; x=1762262335;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=e4X7a17BQA3CE/pG8qiH6PFO3PoRwLXWBTresK09WO4=;
  b=eWP97bpkQfKUQra5S2ePFjHPL9lEdCURykVlplGfL/BGT3nX2u0v76Ar
   kYbiMd7ndylyCMRx3c6Oz8iC9I2Oh+xDLg4qr0NINpbzQsqUChMkds97/
   s6UNddFyVi6gnfpEu+QAmbeZ/KI9InzL6ABE6f656sTb65zBVTtX3zHGU
   YjKDPro2ZkXZStDiT9zeed4O3LOnl72qdy4RWbCyjhQNmB/tMtZKD/Br+
   JutvldHfZX8MRaiKg/pnPnbEOPRDjyVsIqzVkqFL7tz6VTH7mPkERMTPh
   GUwADbK/2AWK4CPt8Duo9AWeA94bzUQyQQEuX84P/1p1lGJjoqmEBMOzu
   g==;
X-CSE-ConnectionGUID: uULv7P8JTpivhrPh61P3Pg==
X-CSE-MsgGUID: 7fMMf3rzSZiY1e0Y7DHiBA==
X-IronPort-AV: E=McAfee;i="6700,10204,11246"; a="41003754"
X-IronPort-AV: E=Sophos;i="6.11,257,1725346800"; 
   d="scan'208";a="41003754"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 05:18:53 -0800
X-CSE-ConnectionGUID: Mm6p03FoQUmhiRcWCqXhDA==
X-CSE-MsgGUID: RObtENLbQb62uCMIusXNUQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,257,1725346800"; 
   d="scan'208";a="83999503"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmviesa010.fm.intel.com with ESMTP; 04 Nov 2024 05:18:51 -0800
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
Subject: [PATCH v4 08/13] iommu/vt-d: Make identity_domain_set_dev_pasid() to handle domain replacement
Date: Mon,  4 Nov 2024 05:18:37 -0800
Message-Id: <20241104131842.13303-9-yi.l.liu@intel.com>
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

Let identity_domain_set_dev_pasid() call the pasid replace helpers hence
be able to do domain replacement.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/iommu/intel/iommu.c | 8 +++++++-
 drivers/iommu/intel/pasid.h | 9 +++++++++
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 58df1cbc1590..c5b07ccbe621 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -4618,11 +4618,17 @@ static int identity_domain_set_dev_pasid(struct iommu_domain *domain,
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
diff --git a/drivers/iommu/intel/pasid.h b/drivers/iommu/intel/pasid.h
index 3f82f69a7bce..a3b5945a1812 100644
--- a/drivers/iommu/intel/pasid.h
+++ b/drivers/iommu/intel/pasid.h
@@ -326,6 +326,15 @@ static inline int domain_setup_second_level(struct intel_iommu *iommu,
 	return intel_pasid_setup_second_level(iommu, domain, dev, pasid);
 }
 
+static inline int domain_setup_passthrough(struct intel_iommu *iommu,
+					   struct device *dev, ioasid_t pasid,
+					   struct iommu_domain *old)
+{
+	if (old)
+		return intel_pasid_replace_pass_through(iommu, dev, pasid);
+	return intel_pasid_setup_pass_through(iommu, dev, pasid);
+}
+
 void intel_pasid_tear_down_entry(struct intel_iommu *iommu,
 				 struct device *dev, u32 pasid,
 				 bool fault_ignore);
-- 
2.34.1


