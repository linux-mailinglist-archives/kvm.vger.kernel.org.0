Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D2CA26447E
	for <lists+kvm@lfdr.de>; Thu, 10 Sep 2020 12:46:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730434AbgIJKqn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Sep 2020 06:46:43 -0400
Received: from mga06.intel.com ([134.134.136.31]:21915 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729781AbgIJKoR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Sep 2020 06:44:17 -0400
IronPort-SDR: Dph+X2i3ttP0PpjSQjNgvKiqDNbuFEjsOM104460z+CZkgRopI/pZs0zSgHdps8pvIR1Zk6BNB
 +EAMCSebGn6g==
X-IronPort-AV: E=McAfee;i="6000,8403,9739"; a="220066288"
X-IronPort-AV: E=Sophos;i="5.76,412,1592895600"; 
   d="scan'208";a="220066288"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2020 03:43:35 -0700
IronPort-SDR: hIpErZXas1+1eh5NDELcljYXkXUQ3wfNuY9KSFzzRdQOa0JZX9fZvP9o8+cfGoMgY+HiNswkS7
 7kmqTFGwMY1Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,412,1592895600"; 
   d="scan'208";a="334137206"
Received: from jacob-builder.jf.intel.com ([10.7.199.155])
  by orsmga008.jf.intel.com with ESMTP; 10 Sep 2020 03:43:34 -0700
From:   Liu Yi L <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, eric.auger@redhat.com,
        baolu.lu@linux.intel.com, joro@8bytes.org
Cc:     kevin.tian@intel.com, jacob.jun.pan@linux.intel.com,
        ashok.raj@intel.com, yi.l.liu@intel.com, jun.j.tian@intel.com,
        yi.y.sun@intel.com, jean-philippe@linaro.org, peterx@redhat.com,
        jasowang@redhat.com, hao.wu@intel.com, stefanha@gmail.com,
        iommu@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: [PATCH v7 09/16] iommu/vt-d: Check ownership for PASIDs from user-space
Date:   Thu, 10 Sep 2020 03:45:26 -0700
Message-Id: <1599734733-6431-10-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1599734733-6431-1-git-send-email-yi.l.liu@intel.com>
References: <1599734733-6431-1-git-send-email-yi.l.liu@intel.com>
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
v6 -> v7:
*) acquire device_domain_lock in bind/unbind_gpasid() to ensure dmar_domain
   is not modified during bind/unbind_gpasid().
*) the change to svm.c varies from previous version as Jacob refactored the
   svm.c code.
---
 drivers/iommu/intel/iommu.c | 29 +++++++++++++++++++++++++----
 drivers/iommu/intel/svm.c   | 33 ++++++++++++++++++++++++---------
 include/linux/intel-iommu.h |  2 ++
 3 files changed, 51 insertions(+), 13 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index d1c77fc..95740b9 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -5451,6 +5451,7 @@ intel_iommu_sva_invalidate(struct iommu_domain *domain, struct device *dev,
 		int granu = 0;
 		u64 pasid = 0;
 		u64 addr = 0;
+		void *pdata;
 
 		granu = to_vtd_granularity(cache_type, inv_info->granularity);
 		if (granu == -EINVAL) {
@@ -5470,6 +5471,15 @@ intel_iommu_sva_invalidate(struct iommu_domain *domain, struct device *dev,
 			 (inv_info->granu.addr_info.flags & IOMMU_INV_ADDR_FLAGS_PASID))
 			pasid = inv_info->granu.addr_info.pasid;
 
+		pdata = ioasid_find(dmar_domain->pasid_set, pasid, NULL);
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
@@ -5787,12 +5797,14 @@ static void intel_iommu_get_resv_regions(struct device *device,
 	list_add_tail(&reg->list, head);
 }
 
-int intel_iommu_enable_pasid(struct intel_iommu *iommu, struct device *dev)
+/*
+ * Caller should have held device_domain_lock
+ */
+int intel_iommu_enable_pasid_locked(struct intel_iommu *iommu, struct device *dev)
 {
 	struct device_domain_info *info;
 	struct context_entry *context;
 	struct dmar_domain *domain;
-	unsigned long flags;
 	u64 ctx_lo;
 	int ret;
 
@@ -5800,7 +5812,6 @@ int intel_iommu_enable_pasid(struct intel_iommu *iommu, struct device *dev)
 	if (!domain)
 		return -EINVAL;
 
-	spin_lock_irqsave(&device_domain_lock, flags);
 	spin_lock(&iommu->lock);
 
 	ret = -EINVAL;
@@ -5833,11 +5844,21 @@ int intel_iommu_enable_pasid(struct intel_iommu *iommu, struct device *dev)
 
  out:
 	spin_unlock(&iommu->lock);
-	spin_unlock_irqrestore(&device_domain_lock, flags);
 
 	return ret;
 }
 
+int intel_iommu_enable_pasid(struct intel_iommu *iommu, struct device *dev)
+{
+	unsigned long flags;
+	int ret;
+
+	spin_lock_irqsave(&device_domain_lock, flags);
+	ret = intel_iommu_enable_pasid_locked(iommu, dev);
+	spin_unlock_irqrestore(&device_domain_lock, flags);
+	return ret;
+}
+
 static void intel_iommu_apply_resv_region(struct device *dev,
 					  struct iommu_domain *domain,
 					  struct iommu_resv_region *region)
diff --git a/drivers/iommu/intel/svm.c b/drivers/iommu/intel/svm.c
index d39fafb..80f58ab 100644
--- a/drivers/iommu/intel/svm.c
+++ b/drivers/iommu/intel/svm.c
@@ -293,7 +293,9 @@ static LIST_HEAD(global_svm_list);
 	list_for_each_entry((sdev), &(svm)->devs, list)	\
 		if ((d) != (sdev)->dev) {} else
 
-static int pasid_to_svm_sdev(struct device *dev, unsigned int pasid,
+static int pasid_to_svm_sdev(struct device *dev,
+			     struct ioasid_set *set,
+			     unsigned int pasid,
 			     struct intel_svm **rsvm,
 			     struct intel_svm_dev **rsdev)
 {
@@ -307,7 +309,7 @@ static int pasid_to_svm_sdev(struct device *dev, unsigned int pasid,
 	if (pasid == INVALID_IOASID || pasid >= PASID_MAX)
 		return -EINVAL;
 
-	svm = ioasid_find(NULL, pasid, NULL);
+	svm = ioasid_find(set, pasid, NULL);
 	if (IS_ERR(svm))
 		return PTR_ERR(svm);
 
@@ -344,6 +346,7 @@ int intel_svm_bind_gpasid(struct iommu_domain *domain, struct device *dev,
 	struct intel_svm_dev *sdev = NULL;
 	struct dmar_domain *dmar_domain;
 	struct intel_svm *svm = NULL;
+	unsigned long flags;
 	int ret = 0;
 
 	if (WARN_ON(!iommu) || !data)
@@ -377,7 +380,9 @@ int intel_svm_bind_gpasid(struct iommu_domain *domain, struct device *dev,
 	dmar_domain = to_dmar_domain(domain);
 
 	mutex_lock(&pasid_mutex);
-	ret = pasid_to_svm_sdev(dev, data->hpasid, &svm, &sdev);
+	spin_lock_irqsave(&device_domain_lock, flags);
+	ret = pasid_to_svm_sdev(dev, dmar_domain->pasid_set,
+				data->hpasid, &svm, &sdev);
 	if (ret)
 		goto out;
 
@@ -395,7 +400,7 @@ int intel_svm_bind_gpasid(struct iommu_domain *domain, struct device *dev,
 
 	if (!svm) {
 		/* We come here when PASID has never been bond to a device. */
-		svm = kzalloc(sizeof(*svm), GFP_KERNEL);
+		svm = kzalloc(sizeof(*svm), GFP_ATOMIC);
 		if (!svm) {
 			ret = -ENOMEM;
 			goto out;
@@ -415,7 +420,7 @@ int intel_svm_bind_gpasid(struct iommu_domain *domain, struct device *dev,
 		ioasid_attach_data(data->hpasid, svm);
 		INIT_LIST_HEAD_RCU(&svm->devs);
 	}
-	sdev = kzalloc(sizeof(*sdev), GFP_KERNEL);
+	sdev = kzalloc(sizeof(*sdev), GFP_ATOMIC);
 	if (!sdev) {
 		ret = -ENOMEM;
 		goto out;
@@ -427,7 +432,7 @@ int intel_svm_bind_gpasid(struct iommu_domain *domain, struct device *dev,
 		sdev->users = 1;
 
 	/* Set up device context entry for PASID if not enabled already */
-	ret = intel_iommu_enable_pasid(iommu, sdev->dev);
+	ret = intel_iommu_enable_pasid_locked(iommu, sdev->dev);
 	if (ret) {
 		dev_err_ratelimited(dev, "Failed to enable PASID capability\n");
 		kfree(sdev);
@@ -462,6 +467,7 @@ int intel_svm_bind_gpasid(struct iommu_domain *domain, struct device *dev,
 	init_rcu_head(&sdev->rcu);
 	list_add_rcu(&sdev->list, &svm->devs);
  out:
+	spin_unlock_irqrestore(&device_domain_lock, flags);
 	if (!IS_ERR_OR_NULL(svm) && list_empty(&svm->devs)) {
 		ioasid_attach_data(data->hpasid, NULL);
 		kfree(svm);
@@ -480,15 +486,22 @@ int intel_svm_unbind_gpasid(struct iommu_domain *domain,
 			    struct device *dev, u32 pasid)
 {
 	struct intel_iommu *iommu = device_to_iommu(dev, NULL, NULL);
+	struct dmar_domain *dmar_domain;
 	struct intel_svm_dev *sdev;
 	struct intel_svm *svm;
+	unsigned long flags;
 	int ret;
 
 	if (WARN_ON(!iommu))
 		return -EINVAL;
 
+	dmar_domain = to_dmar_domain(domain);
+
 	mutex_lock(&pasid_mutex);
-	ret = pasid_to_svm_sdev(dev, pasid, &svm, &sdev);
+	spin_lock_irqsave(&device_domain_lock, flags);
+	ret = pasid_to_svm_sdev(dev, dmar_domain->pasid_set,
+				pasid, &svm, &sdev);
+	spin_unlock_irqrestore(&device_domain_lock, flags);
 	if (ret)
 		goto out;
 
@@ -712,7 +725,8 @@ static int intel_svm_unbind_mm(struct device *dev, int pasid)
 	if (!iommu)
 		goto out;
 
-	ret = pasid_to_svm_sdev(dev, pasid, &svm, &sdev);
+	ret = pasid_to_svm_sdev(dev, host_pasid_set,
+				pasid, &svm, &sdev);
 	if (ret)
 		goto out;
 
@@ -1204,7 +1218,8 @@ int intel_svm_page_response(struct device *dev,
 		goto out;
 	}
 
-	ret = pasid_to_svm_sdev(dev, prm->pasid, &svm, &sdev);
+	ret = pasid_to_svm_sdev(dev, host_pasid_set,
+				prm->pasid, &svm, &sdev);
 	if (ret || !sdev) {
 		ret = -ENODEV;
 		goto out;
diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
index ce0b33b..db7fc59 100644
--- a/include/linux/intel-iommu.h
+++ b/include/linux/intel-iommu.h
@@ -730,6 +730,8 @@ struct intel_iommu *domain_get_iommu(struct dmar_domain *domain);
 int for_each_device_domain(int (*fn)(struct device_domain_info *info,
 				     void *data), void *data);
 void iommu_flush_write_buffer(struct intel_iommu *iommu);
+int intel_iommu_enable_pasid_locked(struct intel_iommu *iommu,
+				    struct device *dev);
 int intel_iommu_enable_pasid(struct intel_iommu *iommu, struct device *dev);
 struct dmar_domain *find_domain(struct device *dev);
 struct device_domain_info *get_domain_info(struct device *dev);
-- 
2.7.4

