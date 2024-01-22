Return-Path: <kvm+bounces-6508-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 10216835A90
	for <lists+kvm@lfdr.de>; Mon, 22 Jan 2024 06:53:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5C934B2482C
	for <lists+kvm@lfdr.de>; Mon, 22 Jan 2024 05:53:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64AFE38FB2;
	Mon, 22 Jan 2024 05:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="d+9Mt52L"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F53A38F8B;
	Mon, 22 Jan 2024 05:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=134.134.136.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705902569; cv=none; b=NsBkaXD9M3o/uBH7sSfLrai5xL09ywnrOw64W0Ya7LBPssODJQOzpKRO45BXRRMHNE/JYY5doQFjeit+WgIynV7nSBnLuCa5nB+j2mu84FY58UORRu747M+2j9orsRYH+VD5YIvkMZkQS2xqbVjjzIov9Ax8wPxGtTU9GOvv9RE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705902569; c=relaxed/simple;
	bh=eynhCIed9/weS0mwTxqMY1dQrxlU+C17Xz2HQyB+fR8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TivcjbtByNXcshWa2Vfu0vp0LM+flRq4F9s8w37y2uFzWg4UlJQ1WEdzbfqsjo6FJlClEBKBvPhuatrHSq4G0asyGnkwCvFCXYZ7u8pJxYa9AkOcwJ2FQK7dxCV70MzUKzi34cKlqn3O3hBNN2nNJl8kfMO0xMNowJJMy8lwc6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=d+9Mt52L; arc=none smtp.client-ip=134.134.136.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705902568; x=1737438568;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eynhCIed9/weS0mwTxqMY1dQrxlU+C17Xz2HQyB+fR8=;
  b=d+9Mt52LExm1lgI1x9Jp6NIECUgFqAuDmLLxAVcfHYCi1jtYlRuw13g/
   KmYqt4z2+HXuLR+uXW04w/YL9EfzZjzFY54Sv2BuN+o0EZlqp/YNoJRMj
   tlyLZjLwkeTmN/11xileQkxG4DX2sbaV9wiOa/g336J7QqhcysXBUYqoV
   LKIKljuJUMUaxNDijJV/EW5SQfTgynHl/ZMANzAIxZX3lCwkQUaroIXiv
   K8n4nqBDEYe7Zh0mxF3WHYs7gApbMi6rnuU93fOJfWuA1R20TmJWwqivJ
   Trla5dWf+lMl0qrH4vPj3MUQB6CmcpfW5nsWjrA21AzmGFl8eiL2GZG/U
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10960"; a="467487237"
X-IronPort-AV: E=Sophos;i="6.05,211,1701158400"; 
   d="scan'208";a="467487237"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2024 21:49:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10960"; a="1116764031"
X-IronPort-AV: E=Sophos;i="6.05,211,1701158400"; 
   d="scan'208";a="1116764031"
Received: from allen-box.sh.intel.com ([10.239.159.127])
  by fmsmga005.fm.intel.com with ESMTP; 21 Jan 2024 21:49:23 -0800
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
Subject: [PATCH v10 13/16] iommu: Improve iopf_queue_remove_device()
Date: Mon, 22 Jan 2024 13:43:05 +0800
Message-Id: <20240122054308.23901-14-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240122054308.23901-1-baolu.lu@linux.intel.com>
References: <20240122054308.23901-1-baolu.lu@linux.intel.com>
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
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Tested-by: Yan Zhao <yan.y.zhao@intel.com>
---
 include/linux/iommu.h       |  5 ++--
 drivers/iommu/intel/iommu.c |  7 +----
 drivers/iommu/io-pgfault.c  | 59 ++++++++++++++++++++++++-------------
 3 files changed, 41 insertions(+), 30 deletions(-)

diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 396d7b0d88b2..d9a99a978ffa 100644
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
index ce7058892b59..26e100ca3221 100644
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


