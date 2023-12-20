Return-Path: <kvm+bounces-4889-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DE3DB819652
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 02:33:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 97CC7284954
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 01:33:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88F2C20B1D;
	Wed, 20 Dec 2023 01:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iwxlJzof"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41F1EBE5E;
	Wed, 20 Dec 2023 01:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1703035762; x=1734571762;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WKlKS3p/SZedIro35MaEj5PNDGzsO2BvzmYV3MpEgxg=;
  b=iwxlJzof1xYp2d/Ne5XERot8F2+PKg/jMrB6Uyy98mwwrIlBtQIjVuom
   nf9HXQ2zn4oh1p85q4zFgSBTrZM1a8bjU0pUHrkC/XZgHDy2HsyZNYJlA
   Jcj82AoBZqZPjjy9lds6uJ9h8cYxYDgeTYM0L5NCxoi3l9NN1p80eENoS
   JUS6fTUmWNbiNt/8La/SLM636QJyaDAWHtldUFCLD2OytLiSohBgyP0or
   mVhmNnwoCkAVPX8RRpaoFHCcIUG9PzP2Tqu3g23COWWUTwhGM0AFhjlIs
   14MtwJshDeJvR4d/LZInsrHUEj8UBAt9sJjYdnfQwmO8f3RsrrbfQzm59
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10929"; a="2965864"
X-IronPort-AV: E=Sophos;i="6.04,290,1695711600"; 
   d="scan'208";a="2965864"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2023 17:29:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10929"; a="1023319208"
X-IronPort-AV: E=Sophos;i="6.04,290,1695711600"; 
   d="scan'208";a="1023319208"
Received: from allen-box.sh.intel.com ([10.239.159.127])
  by fmsmga006.fm.intel.com with ESMTP; 19 Dec 2023 17:29:17 -0800
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
	iommu@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH v9 13/14] iommu: Improve iopf_queue_remove_device()
Date: Wed, 20 Dec 2023 09:23:31 +0800
Message-Id: <20231220012332.168188-14-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231220012332.168188-1-baolu.lu@linux.intel.com>
References: <20231220012332.168188-1-baolu.lu@linux.intel.com>
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
device from the iopf queue and disabling its PRI.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Tested-by: Yan Zhao <yan.y.zhao@intel.com>
---
 include/linux/iommu.h       |  5 ++--
 drivers/iommu/intel/iommu.c |  7 +----
 drivers/iommu/io-pgfault.c  | 59 ++++++++++++++++++++++++-------------
 3 files changed, 41 insertions(+), 30 deletions(-)

diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index c2416aa79922..d8d173309469 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -1465,7 +1465,7 @@ iommu_sva_domain_alloc(struct device *dev, struct mm_struct *mm)
 
 #ifdef CONFIG_IOMMU_IOPF
 int iopf_queue_add_device(struct iopf_queue *queue, struct device *dev);
-int iopf_queue_remove_device(struct iopf_queue *queue, struct device *dev);
+void iopf_queue_remove_device(struct iopf_queue *queue, struct device *dev);
 int iopf_queue_flush_dev(struct device *dev);
 struct iopf_queue *iopf_queue_alloc(const char *name);
 void iopf_queue_free(struct iopf_queue *queue);
@@ -1481,10 +1481,9 @@ iopf_queue_add_device(struct iopf_queue *queue, struct device *dev)
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
index 3a907bad2fcb..3221f6387beb 100644
--- a/drivers/iommu/io-pgfault.c
+++ b/drivers/iommu/io-pgfault.c
@@ -449,42 +449,61 @@ EXPORT_SYMBOL_GPL(iopf_queue_add_device);
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
+ * - Tear down the iopf infrastructure: Calling iopf_queue_remove_device()
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
 	if (refcount_dec_and_test(&fault_param->users))
@@ -492,8 +511,6 @@ int iopf_queue_remove_device(struct iopf_queue *queue, struct device *dev)
 unlock:
 	mutex_unlock(&param->lock);
 	mutex_unlock(&queue->lock);
-
-	return ret;
 }
 EXPORT_SYMBOL_GPL(iopf_queue_remove_device);
 
-- 
2.34.1


