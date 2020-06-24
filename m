Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BA03206F68
	for <lists+kvm@lfdr.de>; Wed, 24 Jun 2020 10:51:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389136AbgFXIuP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Jun 2020 04:50:15 -0400
Received: from mga01.intel.com ([192.55.52.88]:1312 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388488AbgFXIs7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Jun 2020 04:48:59 -0400
IronPort-SDR: P4sOO4Us0GBiX+/+1FiPGtQiAygTPUeqjqy+1djJrAAMP7cfGsRtNU7d5oK8qjE4qYXwd17BAK
 1Yyul5k2dt5Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9661"; a="162484876"
X-IronPort-AV: E=Sophos;i="5.75,274,1589266800"; 
   d="scan'208";a="162484876"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2020 01:48:57 -0700
IronPort-SDR: piGJ++LaamA9YfyuMqCwvU5vZ7l/wzJwV4Bw4Dq47ONOCUSOEPD/GlUNxfV5Vrfp/NSTbReAMh
 1qWzMEW5nQGw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,274,1589266800"; 
   d="scan'208";a="275624514"
Received: from jacob-builder.jf.intel.com ([10.7.199.155])
  by orsmga003.jf.intel.com with ESMTP; 24 Jun 2020 01:48:56 -0700
From:   Liu Yi L <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, eric.auger@redhat.com,
        baolu.lu@linux.intel.com, joro@8bytes.org
Cc:     kevin.tian@intel.com, jacob.jun.pan@linux.intel.com,
        ashok.raj@intel.com, yi.l.liu@intel.com, jun.j.tian@intel.com,
        yi.y.sun@intel.com, jean-philippe@linaro.org, peterx@redhat.com,
        hao.wu@intel.com, iommu@lists.linux-foundation.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 08/14] iommu/vt-d: Check ownership for PASIDs from user-space
Date:   Wed, 24 Jun 2020 01:55:21 -0700
Message-Id: <1592988927-48009-9-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1592988927-48009-1-git-send-email-yi.l.liu@intel.com>
References: <1592988927-48009-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When an IOMMU domain with nesting attribute is used for guest SVA, a
system-wide PASID is allocated for binding with the device and the domain.
For security reason, we need to check the PASID passsed from user-space.
e.g. page table bind/unbind and PASID related cache invalidation.

Cc: Kevin Tian <kevin.tian@intel.com>
CC: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Eric Auger <eric.auger@redhat.com>
Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
---
 drivers/iommu/intel/iommu.c | 10 ++++++++++
 drivers/iommu/intel/svm.c   |  7 +++++--
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index b139ab4..b50395e 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -5429,6 +5429,7 @@ intel_iommu_sva_invalidate(struct iommu_domain *domain, struct device *dev,
 		int granu = 0;
 		u64 pasid = 0;
 		u64 addr = 0;
+		void *pdata;
 
 		granu = to_vtd_granularity(cache_type, inv_info->granularity);
 		if (granu == -EINVAL) {
@@ -5448,6 +5449,15 @@ intel_iommu_sva_invalidate(struct iommu_domain *domain, struct device *dev,
 			 (inv_info->granu.addr_info.flags & IOMMU_INV_ADDR_FLAGS_PASID))
 			pasid = inv_info->granu.addr_info.pasid;
 
+		pdata = ioasid_find(dmar_domain->ioasid_sid, pasid, NULL);
+		if (!pdata) {
+			ret = -EINVAL;
+			goto out_unlock;
+		} else if (IS_ERR(pdata)) {
+			ret = PTR_ERR(pdata);
+			goto out_unlock;
+		}
+
 		switch (BIT(cache_type)) {
 		case IOMMU_CACHE_INV_TYPE_IOTLB:
 			/* HW will ignore LSB bits based on address mask */
diff --git a/drivers/iommu/intel/svm.c b/drivers/iommu/intel/svm.c
index 1e567a1..aa2e1aa 100644
--- a/drivers/iommu/intel/svm.c
+++ b/drivers/iommu/intel/svm.c
@@ -323,7 +323,7 @@ int intel_svm_bind_gpasid(struct iommu_domain *domain, struct device *dev,
 	dmar_domain = to_dmar_domain(domain);
 
 	mutex_lock(&pasid_mutex);
-	svm = ioasid_find(INVALID_IOASID_SET, data->hpasid, NULL);
+	svm = ioasid_find(dmar_domain->ioasid_sid, data->hpasid, NULL);
 	if (IS_ERR(svm)) {
 		ret = PTR_ERR(svm);
 		goto out;
@@ -440,6 +440,7 @@ int intel_svm_unbind_gpasid(struct iommu_domain *domain,
 			    struct device *dev, ioasid_t pasid)
 {
 	struct intel_iommu *iommu = intel_svm_device_to_iommu(dev);
+	struct dmar_domain *dmar_domain;
 	struct intel_svm_dev *sdev;
 	struct intel_svm *svm;
 	int ret = -EINVAL;
@@ -447,8 +448,10 @@ int intel_svm_unbind_gpasid(struct iommu_domain *domain,
 	if (WARN_ON(!iommu))
 		return -EINVAL;
 
+	dmar_domain = to_dmar_domain(domain);
+
 	mutex_lock(&pasid_mutex);
-	svm = ioasid_find(INVALID_IOASID_SET, pasid, NULL);
+	svm = ioasid_find(dmar_domain->ioasid_sid, pasid, NULL);
 	if (!svm) {
 		ret = -EINVAL;
 		goto out;
-- 
2.7.4

