Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B015230297
	for <lists+kvm@lfdr.de>; Tue, 28 Jul 2020 08:21:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727895AbgG1GVD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jul 2020 02:21:03 -0400
Received: from mga06.intel.com ([134.134.136.31]:26362 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727858AbgG1GVB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jul 2020 02:21:01 -0400
IronPort-SDR: mgrLp2z0grm/SPRkKHccutReDKuBXQf0BS3f6To7okMzTqj2PFkMcpHwSFecrNVF8FZ1U7J9SU
 qPsCkVdA7+wg==
X-IronPort-AV: E=McAfee;i="6000,8403,9695"; a="212681244"
X-IronPort-AV: E=Sophos;i="5.75,405,1589266800"; 
   d="scan'208";a="212681244"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2020 23:20:56 -0700
IronPort-SDR: bSZ/IpSZ47/59Pp6Z8flCbeJecHWqkqEG6+nJtJfto9eYRq+ASfGoM1yjtN71evo6/RoN+QPI7
 KztwgJlZteWg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,405,1589266800"; 
   d="scan'208";a="320274405"
Received: from jacob-builder.jf.intel.com ([10.7.199.155])
  by orsmga008.jf.intel.com with ESMTP; 27 Jul 2020 23:20:55 -0700
From:   Liu Yi L <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, eric.auger@redhat.com,
        baolu.lu@linux.intel.com, joro@8bytes.org
Cc:     kevin.tian@intel.com, jacob.jun.pan@linux.intel.com,
        ashok.raj@intel.com, yi.l.liu@intel.com, jun.j.tian@intel.com,
        yi.y.sun@intel.com, jean-philippe@linaro.org, peterx@redhat.com,
        hao.wu@intel.com, stefanha@gmail.com,
        iommu@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v6 08/15] iommu: Pass domain to sva_unbind_gpasid()
Date:   Mon, 27 Jul 2020 23:27:37 -0700
Message-Id: <1595917664-33276-9-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1595917664-33276-1-git-send-email-yi.l.liu@intel.com>
References: <1595917664-33276-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Yi Sun <yi.y.sun@intel.com>

Current interface is good enough for SVA virtualization on an assigned
physical PCI device, but when it comes to mediated devices, a physical
device may attached with multiple aux-domains. Also, for guest unbind,
the PASID to be unbind should be allocated to the VM. This check requires
to know the ioasid_set which is associated with the domain.

So this interface needs to pass in domain info. Then the iommu driver is
able to know which domain will be used for the 2nd stage translation of
the nesting mode and also be able to do PASID ownership check. This patch
passes @domain per the above reason. Also, the prototype of &pasid is
changed frnt" to "u32" as the below link.

https://lore.kernel.org/kvm/27ac7880-bdd3-2891-139e-b4a7cd18420b@redhat.com/

Cc: Kevin Tian <kevin.tian@intel.com>
CC: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Eric Auger <eric.auger@redhat.com>
Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Yi Sun <yi.y.sun@intel.com>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
---
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
index c27d16a..c85b8d5 100644
--- a/drivers/iommu/intel/svm.c
+++ b/drivers/iommu/intel/svm.c
@@ -436,7 +436,8 @@ int intel_svm_bind_gpasid(struct iommu_domain *domain, struct device *dev,
 	return ret;
 }
 
-int intel_svm_unbind_gpasid(struct device *dev, int pasid)
+int intel_svm_unbind_gpasid(struct iommu_domain *domain,
+			    struct device *dev, u32 pasid)
 {
 	struct intel_iommu *iommu = intel_svm_device_to_iommu(dev);
 	struct intel_svm_dev *sdev;
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 1ce2a61..bee79d7 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -2145,7 +2145,7 @@ int iommu_sva_unbind_gpasid(struct iommu_domain *domain, struct device *dev,
 	if (unlikely(!domain->ops->sva_unbind_gpasid))
 		return -ENODEV;
 
-	return domain->ops->sva_unbind_gpasid(dev, data->hpasid);
+	return domain->ops->sva_unbind_gpasid(domain, dev, data->hpasid);
 }
 EXPORT_SYMBOL_GPL(iommu_sva_unbind_gpasid);
 
diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
index 0d0ab32..f98146b 100644
--- a/include/linux/intel-iommu.h
+++ b/include/linux/intel-iommu.h
@@ -738,7 +738,8 @@ extern int intel_svm_enable_prq(struct intel_iommu *iommu);
 extern int intel_svm_finish_prq(struct intel_iommu *iommu);
 int intel_svm_bind_gpasid(struct iommu_domain *domain, struct device *dev,
 			  struct iommu_gpasid_bind_data *data);
-int intel_svm_unbind_gpasid(struct device *dev, int pasid);
+int intel_svm_unbind_gpasid(struct iommu_domain *domain,
+			    struct device *dev, u32 pasid);
 struct iommu_sva *intel_svm_bind(struct device *dev, struct mm_struct *mm,
 				 void *drvdata);
 void intel_svm_unbind(struct iommu_sva *handle);
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index b1ff702..80467fc 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -303,7 +303,8 @@ struct iommu_ops {
 	int (*sva_bind_gpasid)(struct iommu_domain *domain,
 			struct device *dev, struct iommu_gpasid_bind_data *data);
 
-	int (*sva_unbind_gpasid)(struct device *dev, int pasid);
+	int (*sva_unbind_gpasid)(struct iommu_domain *domain,
+				 struct device *dev, u32 pasid);
 
 	int (*def_domain_type)(struct device *dev);
 
-- 
2.7.4

