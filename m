Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E23472302AC
	for <lists+kvm@lfdr.de>; Tue, 28 Jul 2020 08:22:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726840AbgG1GVv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jul 2020 02:21:51 -0400
Received: from mga06.intel.com ([134.134.136.31]:26366 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727843AbgG1GVA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jul 2020 02:21:00 -0400
IronPort-SDR: RsOp3H5EilCTJU/fzQlfQwGybB2yFTbpiV+kDSC6oBfjDW6aF0EFNjrt6KFlS1a6fRfjHZ/Zek
 MoNz4fBufX1g==
X-IronPort-AV: E=McAfee;i="6000,8403,9695"; a="212681243"
X-IronPort-AV: E=Sophos;i="5.75,405,1589266800"; 
   d="scan'208";a="212681243"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2020 23:20:56 -0700
IronPort-SDR: VyiBPr0vNrmCxDGcQ4QUdenaeG+1yPbpJCBMsRehXlNnm35WfPyqKxQLtiAyFNi/MAWs+5uP1I
 7ICjs52dC6Iw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,405,1589266800"; 
   d="scan'208";a="320274409"
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
Subject: [PATCH v6 09/15] iommu/vt-d: Check ownership for PASIDs from user-space
Date:   Mon, 27 Jul 2020 23:27:38 -0700
Message-Id: <1595917664-33276-10-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1595917664-33276-1-git-send-email-yi.l.liu@intel.com>
References: <1595917664-33276-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When an IOMMU domain with nesting attribute is used for guest SVA, a
system-wide PASID is allocated for binding with the device and the domain.
For security reason, we need to check the PASID passed from user-space.
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
index b2fe54e..88f4647 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -5436,6 +5436,7 @@ intel_iommu_sva_invalidate(struct iommu_domain *domain, struct device *dev,
 		int granu = 0;
 		u64 pasid = 0;
 		u64 addr = 0;
+		void *pdata;
 
 		granu = to_vtd_granularity(cache_type, inv_info->granularity);
 		if (granu == -EINVAL) {
@@ -5456,6 +5457,15 @@ intel_iommu_sva_invalidate(struct iommu_domain *domain, struct device *dev,
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
index c85b8d5..b9b29ad 100644
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
 			    struct device *dev, u32 pasid)
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

