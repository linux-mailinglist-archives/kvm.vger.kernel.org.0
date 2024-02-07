Return-Path: <kvm+bounces-8182-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5703584C211
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 02:44:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0E1D628C6F4
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 01:44:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC87F208BC;
	Wed,  7 Feb 2024 01:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gK/mS+gu"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 284EE208B4;
	Wed,  7 Feb 2024 01:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707270015; cv=none; b=uXGaju6sWQKUp3HbQWaHkPhGcVp43BiO/RQIa4fKN37b6Zujs6+kxcNPaRu9BGHurO61rAfBO0EmxEIR3zdFAtfZng2IJxFmM0WRz0s2ybSL2P7iOaWP5h8Wi+SEIPRNGlHG5P5Wt3FK51gICDVdUBxG46s3ZUPxPsGJ3kMcfNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707270015; c=relaxed/simple;
	bh=TzOHqmaUPJ+X7pyu6piz7QynhbpdJeB4kCh+FTS2xoU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=j5c9VWr2W98Pf1p8bw4lOewVeegHug5nRrVN+1V8Mi+RxXqJV8mGcz7utEjGhjQ/YQTDn8pInrg+UyA6a4MTOHfq+fMuJ4Bf9SbOeZ2QawjZfkDiG17u4BbQ/R3pBAxW1kbOVfvtnX/ZwLv5as5QwovucZk+WZ7OFifN3QjLwgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gK/mS+gu; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707270013; x=1738806013;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TzOHqmaUPJ+X7pyu6piz7QynhbpdJeB4kCh+FTS2xoU=;
  b=gK/mS+guNFhC+8lXPMXR3tb9kh+6CwLmW6Bj+hzrgr8dEZf6yMP24BjO
   FzpOlhCcZiP43TDPTEGVsFu4mwj85CJwWLU98UIX2d9+OL3QwBQIhSv7P
   sykaoPppgTNG9HPRnbizF6xSW+xyrQ6b2wvPZb/76+30jLlq/pKb+YqSq
   jLjFK6S3peEv/68spTsGKo2Ro/iMfS5u3GzQ/KNBsRm96byMZ64BjAP2/
   AZXmsdTpkPz235zV/uKsSwo61OWtL74Dvm1N8CMeeRLJK0xQdVfcb/EB4
   Fovqb/aaBOVSL1S800Q6imDMZiND+saAasHfgRk3X9E2x1q73PUi9zdXm
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10976"; a="11534286"
X-IronPort-AV: E=Sophos;i="6.05,248,1701158400"; 
   d="scan'208";a="11534286"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2024 17:40:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,248,1701158400"; 
   d="scan'208";a="1190878"
Received: from allen-box.sh.intel.com ([10.239.159.127])
  by fmviesa010.fm.intel.com with ESMTP; 06 Feb 2024 17:40:08 -0800
From: Lu Baolu <baolu.lu@linux.intel.com>
To: Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Kevin Tian <kevin.tian@intel.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Nicolin Chen <nicolinc@nvidia.com>
Cc: Yi Liu <yi.l.liu@intel.com>,
	Jacob Pan <jacob.jun.pan@linux.intel.com>,
	Longfang Liu <liulongfang@huawei.com>,
	Yan Zhao <yan.y.zhao@intel.com>,
	Joel Granados <j.granados@samsung.com>,
	iommu@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH v12 13/16] iommu: Improve iopf_queue_remove_device()
Date: Wed,  7 Feb 2024 09:33:22 +0800
Message-Id: <20240207013325.95182-14-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240207013325.95182-1-baolu.lu@linux.intel.com>
References: <20240207013325.95182-1-baolu.lu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Convert iopf_queue_remove_device() to return void instead of an error code,
as the return value is never used. This removal helper is designed to be
never-failed, so there's no need for error handling.

Ack all outstanding page requests from the device with the response code of
IOMMU_PAGE_RESP_INVALID, indicating device should not attempt any retry.

Add comments to this helper explaining the steps involved in removing a
device from the iopf queue and disabling its PRI. The individual drivers
are expected to be adjusted accordingly. Here we just define the expected
behaviors of the individual iommu driver from the core's perspective.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Tested-by: Yan Zhao <yan.y.zhao@intel.com>
---
 include/linux/iommu.h       |  5 ++--
 drivers/iommu/intel/iommu.c |  7 +----
 drivers/iommu/io-pgfault.c  | 59 ++++++++++++++++++++++++-------------
 3 files changed, 41 insertions(+), 30 deletions(-)

diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 1e9161ae95da..92dfd9b94577 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -1542,7 +1542,7 @@ iommu_sva_domain_alloc(struct device *dev, struct mm_struct *mm)
 
 #ifdef CONFIG_IOMMU_IOPF
 int iopf_queue_add_device(struct iopf_queue *queue, struct device *dev);
-int iopf_queue_remove_device(struct iopf_queue *queue, struct device *dev);
+void iopf_queue_remove_device(struct iopf_queue *queue, struct device *dev);
 int iopf_queue_flush_dev(struct device *dev);
 struct iopf_queue *iopf_queue_alloc(const char *name);
 void iopf_queue_free(struct iopf_queue *queue);
@@ -1558,10 +1558,9 @@ iopf_queue_add_device(struct iopf_queue *queue, struct device *dev)
 	return -ENODEV;
 }
 
-static inline int
+static inline void
 iopf_queue_remove_device(struct iopf_queue *queue, struct device *dev)
 {
-	return -ENODEV;
 }
 
 static inline int iopf_queue_flush_dev(struct device *dev)
diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 29a12f289e2e..a81a2be9b870 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -4455,12 +4455,7 @@ static int intel_iommu_disable_iopf(struct device *dev)
 	 */
 	pci_disable_pri(to_pci_dev(dev));
 	info->pri_enabled = 0;
-
-	/*
-	 * With PRI disabled and outstanding PRQs drained, removing device
-	 * from iopf queue should never fail.
-	 */
-	WARN_ON(iopf_queue_remove_device(iommu->iopf_queue, dev));
+	iopf_queue_remove_device(iommu->iopf_queue, dev);
 
 	return 0;
 }
diff --git a/drivers/iommu/io-pgfault.c b/drivers/iommu/io-pgfault.c
index ce7058892b59..b20f49bd5e4a 100644
--- a/drivers/iommu/io-pgfault.c
+++ b/drivers/iommu/io-pgfault.c
@@ -448,50 +448,67 @@ EXPORT_SYMBOL_GPL(iopf_queue_add_device);
  * @queue: IOPF queue
  * @dev: device to remove
  *
- * Caller makes sure that no more faults are reported for this device.
+ * Removing a device from an iopf_queue. It's recommended to follow these
+ * steps when removing a device:
  *
- * Return: 0 on success and <0 on error.
+ * - Disable new PRI reception: Turn off PRI generation in the IOMMU hardware
+ *   and flush any hardware page request queues. This should be done before
+ *   calling into this helper.
+ * - Acknowledge all outstanding PRQs to the device: Respond to all outstanding
+ *   page requests with IOMMU_PAGE_RESP_INVALID, indicating the device should
+ *   not retry. This helper function handles this.
+ * - Disable PRI on the device: After calling this helper, the caller could
+ *   then disable PRI on the device.
+ * - Call iopf_queue_remove_device(): Calling iopf_queue_remove_device()
+ *   essentially disassociates the device. The fault_param might still exist,
+ *   but iommu_page_response() will do nothing. The device fault parameter
+ *   reference count has been properly passed from iommu_report_device_fault()
+ *   to the fault handling work, and will eventually be released after
+ *   iommu_page_response().
  */
-int iopf_queue_remove_device(struct iopf_queue *queue, struct device *dev)
+void iopf_queue_remove_device(struct iopf_queue *queue, struct device *dev)
 {
-	int ret = 0;
 	struct iopf_fault *iopf, *next;
+	struct iommu_page_response resp;
 	struct dev_iommu *param = dev->iommu;
 	struct iommu_fault_param *fault_param;
+	const struct iommu_ops *ops = dev_iommu_ops(dev);
 
 	mutex_lock(&queue->lock);
 	mutex_lock(&param->lock);
 	fault_param = rcu_dereference_check(param->fault_param,
 					    lockdep_is_held(&param->lock));
-	if (!fault_param) {
-		ret = -ENODEV;
-		goto unlock;
-	}
-
-	if (fault_param->queue != queue) {
-		ret = -EINVAL;
-		goto unlock;
-	}
 
-	if (!list_empty(&fault_param->faults)) {
-		ret = -EBUSY;
+	if (WARN_ON(!fault_param || fault_param->queue != queue))
 		goto unlock;
-	}
-
-	list_del(&fault_param->queue_list);
 
-	/* Just in case some faults are still stuck */
+	mutex_lock(&fault_param->lock);
 	list_for_each_entry_safe(iopf, next, &fault_param->partial, list)
 		kfree(iopf);
 
+	list_for_each_entry_safe(iopf, next, &fault_param->faults, list) {
+		memset(&resp, 0, sizeof(struct iommu_page_response));
+		resp.pasid = iopf->fault.prm.pasid;
+		resp.grpid = iopf->fault.prm.grpid;
+		resp.code = IOMMU_PAGE_RESP_INVALID;
+
+		if (iopf->fault.prm.flags & IOMMU_FAULT_PAGE_RESPONSE_NEEDS_PASID)
+			resp.flags = IOMMU_PAGE_RESP_PASID_VALID;
+
+		ops->page_response(dev, iopf, &resp);
+		list_del(&iopf->list);
+		kfree(iopf);
+	}
+	mutex_unlock(&fault_param->lock);
+
+	list_del(&fault_param->queue_list);
+
 	/* dec the ref owned by iopf_queue_add_device() */
 	rcu_assign_pointer(param->fault_param, NULL);
 	iopf_put_dev_fault_param(fault_param);
 unlock:
 	mutex_unlock(&param->lock);
 	mutex_unlock(&queue->lock);
-
-	return ret;
 }
 EXPORT_SYMBOL_GPL(iopf_queue_remove_device);
 
-- 
2.34.1


