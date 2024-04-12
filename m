Return-Path: <kvm+bounces-14395-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DA8078A28F9
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 10:15:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 086571C2231B
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 08:15:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF87650291;
	Fri, 12 Apr 2024 08:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JNc+ZQbn"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B7614F20C
	for <kvm@vger.kernel.org>; Fri, 12 Apr 2024 08:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712909723; cv=none; b=KYtE9K5vmFcl08xJK0U/P4L8dxf6uFeXr+aDzliqZyr+C4Yj74Wm75SxOKGSeBf5pGRVY5DzVcGSzaEjl3rAqQOvUyoA2ViQTzhLAMd3wmfJCwHW8nDWG7XqvUXsAJTZTEhhT3iPT80fjba+jvs1pXN9RUMhtmC9H7ygbCI8xDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712909723; c=relaxed/simple;
	bh=qoyJpcJ2+w+2yEzQ/z6sOf/WYiiOnrEms+md8VARlN8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=b6kQl4E6xzHqLMbYCsCAvUBkzngPlCk/BaoUyS52++20JfmKcN9GfaXW2fayQDz+SUl9R8IjhcA2q91qlZFH8S1nsW2cPryzYl4+QfMTkOS1/4Ej4hlro/Yc18GISTK88X11eJpFqlg7Dgui/k+EpoRyoXhNaCKv+QANPAYHhT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JNc+ZQbn; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712909722; x=1744445722;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qoyJpcJ2+w+2yEzQ/z6sOf/WYiiOnrEms+md8VARlN8=;
  b=JNc+ZQbnC2YgVZup0PaTrZ0Cvbuv3DLS/1jRtEd1PzeRbgWObAT97I1l
   70Ng7DTfJOds5ekvLPLj/UI5lGzaLDLoiUbL7SCpCK9yQcJoNMsi/IBq6
   YtQ4pfIi1klna1WlUPtvmxsvLKkxRl0b9E4xLmg/evMCawkEOLn0gwK6r
   5PuFLrx2xNxlRfto6hB4puVvAAKNrQQM1xJA1vPVLBFKojE93j7M+1xID
   UpnVoohje21qSFI2fYZ8Pla5eCuTt5jxC15ENswznxKka7X173jgHxLxQ
   moK+5jWNgogWU2ui41rOYhAK06vaKjKhsNt5xFUxWrq24tzFt49yTglZi
   w==;
X-CSE-ConnectionGUID: vZrel8jdQKC/jRHGw1L2fw==
X-CSE-MsgGUID: 8yKNJ3/ZTiCt/qhTGcx2+g==
X-IronPort-AV: E=McAfee;i="6600,9927,11041"; a="8465033"
X-IronPort-AV: E=Sophos;i="6.07,195,1708416000"; 
   d="scan'208";a="8465033"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2024 01:15:19 -0700
X-CSE-ConnectionGUID: 6JbL2KX/QNCZ8hE7I5tECg==
X-CSE-MsgGUID: VbfGTSwmT2aRO1XYXZUWkQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,195,1708416000"; 
   d="scan'208";a="52137757"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orviesa002.jf.intel.com with ESMTP; 12 Apr 2024 01:15:18 -0700
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
	iommu@lists.linux.dev,
	zhenzhong.duan@intel.com,
	jacob.jun.pan@intel.com
Subject: [PATCH v2 01/12] iommu: Pass old domain to set_dev_pasid op
Date: Fri, 12 Apr 2024 01:15:05 -0700
Message-Id: <20240412081516.31168-2-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240412081516.31168-1-yi.l.liu@intel.com>
References: <20240412081516.31168-1-yi.l.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

To support domain replacement for pasid, the underlying iommu driver needs
to know the old domain hence be able to clean up the existing attachment.
It would be much convenient for iommu layer to pass down the old domain.
Otherwise, iommu drivers would need to track domain for pasids by themselves,
this would duplicate code among the iommu drivers. Or iommu drivers would
rely group->pasid_array to get domain, which may not always the correct
one.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/iommu/intel/iommu.c | 3 ++-
 drivers/iommu/intel/svm.c   | 3 ++-
 drivers/iommu/iommu.c       | 3 ++-
 include/linux/iommu.h       | 2 +-
 4 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 45c75a8a0ef5..df49aed3df5e 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -4626,7 +4626,8 @@ static void intel_iommu_remove_dev_pasid(struct device *dev, ioasid_t pasid,
 }
 
 static int intel_iommu_set_dev_pasid(struct iommu_domain *domain,
-				     struct device *dev, ioasid_t pasid)
+				     struct device *dev, ioasid_t pasid,
+				     struct iommu_domain *old)
 {
 	struct device_domain_info *info = dev_iommu_priv_get(dev);
 	struct dmar_domain *dmar_domain = to_dmar_domain(domain);
diff --git a/drivers/iommu/intel/svm.c b/drivers/iommu/intel/svm.c
index c1bed89b1026..ac8733b61470 100644
--- a/drivers/iommu/intel/svm.c
+++ b/drivers/iommu/intel/svm.c
@@ -315,7 +315,8 @@ static int pasid_to_svm_sdev(struct device *dev, unsigned int pasid,
 }
 
 static int intel_svm_set_dev_pasid(struct iommu_domain *domain,
-				   struct device *dev, ioasid_t pasid)
+				   struct device *dev, ioasid_t pasid,
+				   struct iommu_domain *old)
 {
 	struct device_domain_info *info = dev_iommu_priv_get(dev);
 	struct intel_iommu *iommu = info->iommu;
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 3183b0ed4cdb..701b02a118db 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -3321,7 +3321,8 @@ static int __iommu_set_group_pasid(struct iommu_domain *domain,
 	int ret;
 
 	for_each_group_device(group, device) {
-		ret = domain->ops->set_dev_pasid(domain, device->dev, pasid);
+		ret = domain->ops->set_dev_pasid(domain, device->dev,
+						 pasid, NULL);
 		if (ret)
 			goto err_revert;
 	}
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 40dd439307e8..1e5e9249c93f 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -631,7 +631,7 @@ struct iommu_ops {
 struct iommu_domain_ops {
 	int (*attach_dev)(struct iommu_domain *domain, struct device *dev);
 	int (*set_dev_pasid)(struct iommu_domain *domain, struct device *dev,
-			     ioasid_t pasid);
+			     ioasid_t pasid, struct iommu_domain *old);
 
 	int (*map_pages)(struct iommu_domain *domain, unsigned long iova,
 			 phys_addr_t paddr, size_t pgsize, size_t pgcount,
-- 
2.34.1


