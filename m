Return-Path: <kvm+bounces-7448-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D456841D75
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 09:19:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 44E8F28C51E
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 08:19:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6429267A12;
	Tue, 30 Jan 2024 08:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PfaS8UoB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BF20679FC;
	Tue, 30 Jan 2024 08:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706602505; cv=none; b=ajNsH8H44czN8dUChU8aYsdgo4HW1Ul8eWaCjDheAZP/hiupqVWzEFDozEMHnyg2eJj7XHMIcAG9yPrZfh/nWo+E0ztFhhv+WKZk3vr6+Osd2oE5wP/6Wbjx/lmqev1g9ZRwEMGxq0bbWEGE5DKK+QS+gscCygFJRPsj36S3A4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706602505; c=relaxed/simple;
	bh=eynhCIed9/weS0mwTxqMY1dQrxlU+C17Xz2HQyB+fR8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pHnm3nkSkthFMbEAeTa7o08F/XwW/oD/bDypeJVxtlwN5Bcaw/myjY5VsjiVfOMq77jOdCYOEA0XCztO/pRESw9AXP+U1KL22Cj+iVfvwyQSPiaHoNnljB0/IYx/7mv2ytNUB6AEMSna7QOnUzpRJHHStNIF1o91+7TiLbdtDCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PfaS8UoB; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706602505; x=1738138505;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eynhCIed9/weS0mwTxqMY1dQrxlU+C17Xz2HQyB+fR8=;
  b=PfaS8UoBDCPcEEXVkVRKrjBOSlvTus1V3NZgoubL/+5I+D9/d8nzBR+x
   tt2GxZ9zPE7ZjJkOpUvtczdChrP7l98iVME6/c8Vv/l4GJYnAQQts50Bo
   KpmAm1UVNsjhCy7OfgDiaccNX4wKUNNyR5MbGyCOXqZGwzzcd28TqvE7U
   L7DdFQJodCuSgAvGsZ/emoZxQ3Y3dAoZz6ly/G6nRDx5R4Lh+rvKcanBF
   H+IskF7vGhHRafuFqRQVw4O/kz30oRSQ4uSwa9dmZ0s91MTfxHz7vHRj7
   Bq8lqIQx9ocLp09E63L6ue7UpgBsf9z+FE3VYWI0PcZXIzQcLaerU5Y9Y
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10968"; a="10588491"
X-IronPort-AV: E=Sophos;i="6.05,707,1701158400"; 
   d="scan'208";a="10588491"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2024 00:15:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,707,1701158400"; 
   d="scan'208";a="3633892"
Received: from allen-box.sh.intel.com ([10.239.159.127])
  by fmviesa003.fm.intel.com with ESMTP; 30 Jan 2024 00:15:00 -0800
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
Subject: [PATCH v11 13/16] iommu: Improve iopf_queue_remove_device()
Date: Tue, 30 Jan 2024 16:08:32 +0800
Message-Id: <20240130080835.58921-14-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240130080835.58921-1-baolu.lu@linux.intel.com>
References: <20240130080835.58921-1-baolu.lu@linux.intel.com>
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


