Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6510232A74A
	for <lists+kvm@lfdr.de>; Tue,  2 Mar 2021 18:08:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1839232AbhCBQGM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Mar 2021 11:06:12 -0500
Received: from mga01.intel.com ([192.55.52.88]:38901 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1447198AbhCBMvW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Mar 2021 07:51:22 -0500
IronPort-SDR: gdnfEeSWk0MTyXGNpg/5H08zXylrXEkJJxOinDk5sjbXSSY/ZVF5l+nGsCXTij06VvVGErcagO
 RdaKDCBmZSpA==
X-IronPort-AV: E=McAfee;i="6000,8403,9910"; a="206431204"
X-IronPort-AV: E=Sophos;i="5.81,216,1610438400"; 
   d="scan'208";a="206431204"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2021 04:37:16 -0800
IronPort-SDR: r75wCfq+nex2exFmk/NZJGbTHr4BjDIzLy/Q74d6zVaE6tNjx6Elc2nSTm24GNG2KS3Zo2uPke
 KMHFoYkLenPQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,216,1610438400"; 
   d="scan'208";a="427472104"
Received: from yiliu-dev.bj.intel.com (HELO dual-ub.bj.intel.com) ([10.238.156.135])
  by fmsmga004.fm.intel.com with ESMTP; 02 Mar 2021 04:37:12 -0800
From:   Liu Yi L <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, eric.auger@redhat.com,
        baolu.lu@linux.intel.com, joro@8bytes.org
Cc:     kevin.tian@intel.com, jacob.jun.pan@linux.intel.com,
        ashok.raj@intel.com, yi.l.liu@intel.com, jun.j.tian@intel.com,
        yi.y.sun@intel.com, jean-philippe@linaro.org, peterx@redhat.com,
        jasowang@redhat.com, hao.wu@intel.com, stefanha@gmail.com,
        iommu@lists.linux-foundation.org, kvm@vger.kernel.org,
        jgg@nvidia.com, Lingshan.Zhu@intel.com, vivek.gautam@arm.com
Subject: [Patch v8 06/10] iommu: Pass domain to sva_unbind_gpasid()
Date:   Wed,  3 Mar 2021 04:35:41 +0800
Message-Id: <20210302203545.436623-7-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210302203545.436623-1-yi.l.liu@intel.com>
References: <20210302203545.436623-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Yi Sun <yi.y.sun@intel.com>

Current interface is good enough for SVA virtualization on an assigned
physical PCI device, but when it comes to mediated devices, a physical
device may be attached with multiple aux-domains. Also, for guest unbind,
the PASID to be unbind should be allocated to the VM. This check requires
to know the ioasid_set which is associated with the domain.

So this interface needs to pass in domain info. Then the iommu driver is
able to know which domain will be used for the 2nd stage translation of
the nesting mode and also be able to do PASID ownership check. This patch
passes @domain per the above reason.

Cc: Kevin Tian <kevin.tian@intel.com>
CC: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Eric Auger <eric.auger@redhat.com>
Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Yi Sun <yi.y.sun@intel.com>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
---
v7 -> v8:
*) tweaked the commit message.

v6 -> v7:
*) correct the link for the details of modifying pasid prototype to bve "u32".
*) hold off r-b from Eric Auger as there is modification in this patch, will
   seek r-b in this version.

v5 -> v6:
*) use "u32" prototype for @pasid.
*) add review-by from Eric Auger.

v2 -> v3:
*) pass in domain info only
*) use u32 for pasid instead of int type

v1 -> v2:
*) added in v2.
---
 drivers/iommu/intel/svm.c   | 3 ++-
 drivers/iommu/iommu.c       | 2 +-
 include/linux/intel-iommu.h | 3 ++-
 include/linux/iommu.h       | 3 ++-
 4 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/intel/svm.c b/drivers/iommu/intel/svm.c
index 561d011c7287..7521b4aefd16 100644
--- a/drivers/iommu/intel/svm.c
+++ b/drivers/iommu/intel/svm.c
@@ -496,7 +496,8 @@ int intel_svm_bind_gpasid(struct iommu_domain *domain, struct device *dev,
 	return ret;
 }
 
-int intel_svm_unbind_gpasid(struct device *dev, u32 pasid)
+int intel_svm_unbind_gpasid(struct iommu_domain *domain,
+			    struct device *dev, u32 pasid)
 {
 	struct intel_iommu *iommu = device_to_iommu(dev, NULL, NULL);
 	struct intel_svm_dev *sdev;
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index d46f103a1e4b..822e485683ae 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -2185,7 +2185,7 @@ int iommu_sva_unbind_gpasid(struct iommu_domain *domain, struct device *dev,
 	if (unlikely(!domain->ops->sva_unbind_gpasid))
 		return -ENODEV;
 
-	return domain->ops->sva_unbind_gpasid(dev, pasid);
+	return domain->ops->sva_unbind_gpasid(domain, dev, pasid);
 }
 EXPORT_SYMBOL_GPL(iommu_sva_unbind_gpasid);
 
diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
index 554aa946f142..aaf403966444 100644
--- a/include/linux/intel-iommu.h
+++ b/include/linux/intel-iommu.h
@@ -755,7 +755,8 @@ extern int intel_svm_enable_prq(struct intel_iommu *iommu);
 extern int intel_svm_finish_prq(struct intel_iommu *iommu);
 int intel_svm_bind_gpasid(struct iommu_domain *domain, struct device *dev,
 			  struct iommu_gpasid_bind_data *data);
-int intel_svm_unbind_gpasid(struct device *dev, u32 pasid);
+int intel_svm_unbind_gpasid(struct iommu_domain *domain,
+			    struct device *dev, u32 pasid);
 struct iommu_sva *intel_svm_bind(struct device *dev, struct mm_struct *mm,
 				 void *drvdata);
 void intel_svm_unbind(struct iommu_sva *handle);
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 5e7fe519430a..4840217a590b 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -299,7 +299,8 @@ struct iommu_ops {
 	int (*sva_bind_gpasid)(struct iommu_domain *domain,
 			struct device *dev, struct iommu_gpasid_bind_data *data);
 
-	int (*sva_unbind_gpasid)(struct device *dev, u32 pasid);
+	int (*sva_unbind_gpasid)(struct iommu_domain *domain,
+				 struct device *dev, u32 pasid);
 
 	int (*def_domain_type)(struct device *dev);
 
-- 
2.25.1

