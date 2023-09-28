Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B23AB7B119D
	for <lists+kvm@lfdr.de>; Thu, 28 Sep 2023 06:32:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230212AbjI1Ec0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Sep 2023 00:32:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230357AbjI1Eb7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Sep 2023 00:31:59 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 644CE10FA;
        Wed, 27 Sep 2023 21:31:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695875505; x=1727411505;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eeu8S/a5RFXcVTu8TVhpB6n955jAoFthdEXgEkNqByQ=;
  b=C6pc3P1de2CCaXFU85l0Ls+1KF36TVmDhraNJgsRAQdgDUt4Y7xd1gMX
   uh3L5kTT/T0Rw0JZK0ljg4+Z0VAdV4vz+41I1puohHFL89hmrN601s/t0
   bxTr80UeOOE5Q7IEPYFWWKMXGDcpwtf2njZ8coi43z9lTC+ZkWZWGk8WI
   /ltxlBVClklwD2SfEUzjIdHrhUMmsfJLQIOMovhd2tPS40qdzKZuRT0e6
   dzPssHX5RHAvniT+TU4ZZ94uR4uri4/6RSW1t7nwQm1F3GnfZ+redNn8O
   OE/WhTpjRX0vyb+T8yWLyBYcetHtmYbPKvB0z+/xES44OAnujbVnDw3/z
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10846"; a="379260573"
X-IronPort-AV: E=Sophos;i="6.03,182,1694761200"; 
   d="scan'208";a="379260573"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2023 21:31:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10846"; a="923069090"
X-IronPort-AV: E=Sophos;i="6.03,182,1694761200"; 
   d="scan'208";a="923069090"
Received: from allen-box.sh.intel.com ([10.239.159.127])
  by orsmga005.jf.intel.com with ESMTP; 27 Sep 2023 21:31:41 -0700
From:   Lu Baolu <baolu.lu@linux.intel.com>
To:     Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Kevin Tian <kevin.tian@intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Nicolin Chen <nicolinc@nvidia.com>
Cc:     Yi Liu <yi.l.liu@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        iommu@lists.linux.dev, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lu Baolu <baolu.lu@linux.intel.com>
Subject: [PATCH v6 12/12] iommu: Improve iopf_queue_flush_dev()
Date:   Thu, 28 Sep 2023 12:27:34 +0800
Message-Id: <20230928042734.16134-13-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230928042734.16134-1-baolu.lu@linux.intel.com>
References: <20230928042734.16134-1-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The iopf_queue_flush_dev() is called by the iommu driver before releasing
a PASID. It ensures that all pending faults for this PASID have been
handled or cancelled, and won't hit the address space that reuses this
PASID. The driver must make sure that no new fault is added to the queue.

The SMMUv3 driver doesn't use it because it only implements the
Arm-specific stall fault model where DMA transactions are held in the SMMU
while waiting for the OS to handle iopf's. Since a device driver must
complete all DMA transactions before detaching domain, there are no
pending iopf's with the stall model. PRI support requires adding a call to
iopf_queue_flush_dev() after flushing the hardware page fault queue.

The current implementation of iopf_queue_flush_dev() is a simplified
version. It is only suitable for SVA case in which the processing of iopf
is implemented in the inner loop of the iommu subsystem.

Improve this interface to make it also work for handling iopf out of the
iommu core. Rename the function with a more meaningful name. Remove a
warning message in iommu_page_response() since the iopf queue might get
flushed before possible pending responses.

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
---
 include/linux/iommu.h      |  4 +--
 drivers/iommu/intel/svm.c  |  2 +-
 drivers/iommu/io-pgfault.c | 60 ++++++++++++++++++++++++++++++--------
 3 files changed, 51 insertions(+), 15 deletions(-)

diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index de35a5393f4f..bcec7e91dfc4 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -1282,7 +1282,7 @@ iommu_sva_domain_alloc(struct device *dev, struct mm_struct *mm)
 #ifdef CONFIG_IOMMU_IOPF
 int iopf_queue_add_device(struct iopf_queue *queue, struct device *dev);
 int iopf_queue_remove_device(struct iopf_queue *queue, struct device *dev);
-int iopf_queue_flush_dev(struct device *dev);
+int iopf_queue_discard_dev_pasid(struct device *dev, ioasid_t pasid);
 struct iopf_queue *iopf_queue_alloc(const char *name);
 void iopf_queue_free(struct iopf_queue *queue);
 int iopf_queue_discard_partial(struct iopf_queue *queue);
@@ -1302,7 +1302,7 @@ iopf_queue_remove_device(struct iopf_queue *queue, struct device *dev)
 	return -ENODEV;
 }
 
-static inline int iopf_queue_flush_dev(struct device *dev)
+static inline int iopf_queue_discard_dev_pasid(struct device *dev, ioasid_t pasid)
 {
 	return -ENODEV;
 }
diff --git a/drivers/iommu/intel/svm.c b/drivers/iommu/intel/svm.c
index 780c5bd73ec2..659de9c16024 100644
--- a/drivers/iommu/intel/svm.c
+++ b/drivers/iommu/intel/svm.c
@@ -495,7 +495,7 @@ void intel_drain_pasid_prq(struct device *dev, u32 pasid)
 		goto prq_retry;
 	}
 
-	iopf_queue_flush_dev(dev);
+	iopf_queue_discard_dev_pasid(dev, pasid);
 
 	/*
 	 * Perform steps described in VT-d spec CH7.10 to drain page
diff --git a/drivers/iommu/io-pgfault.c b/drivers/iommu/io-pgfault.c
index 59555dc5ac50..1dbacc4fdf72 100644
--- a/drivers/iommu/io-pgfault.c
+++ b/drivers/iommu/io-pgfault.c
@@ -254,10 +254,9 @@ int iommu_page_response(struct device *dev,
 
 	/* Only send response if there is a fault report pending */
 	mutex_lock(&fault_param->lock);
-	if (list_empty(&fault_param->faults)) {
-		dev_warn_ratelimited(dev, "no pending PRQ, drop response\n");
+	if (list_empty(&fault_param->faults))
 		goto done_unlock;
-	}
+
 	/*
 	 * Check if we have a matching page request pending to respond,
 	 * otherwise return -EINVAL
@@ -298,30 +297,67 @@ int iommu_page_response(struct device *dev,
 EXPORT_SYMBOL_GPL(iommu_page_response);
 
 /**
- * iopf_queue_flush_dev - Ensure that all queued faults have been processed
- * @dev: the endpoint whose faults need to be flushed.
+ * iopf_queue_discard_dev_pasid - Discard all pending faults for a PASID
+ * @dev: the endpoint whose faults need to be discarded.
+ * @pasid: the PASID of the endpoint.
  *
  * The IOMMU driver calls this before releasing a PASID, to ensure that all
- * pending faults for this PASID have been handled, and won't hit the address
- * space of the next process that uses this PASID. The driver must make sure
- * that no new fault is added to the queue. In particular it must flush its
- * low-level queue before calling this function.
+ * pending faults for this PASID have been handled or dropped, and won't hit
+ * the address space of the next process that uses this PASID. The driver
+ * must make sure that no new fault is added to the queue. In particular it
+ * must flush its low-level queue before calling this function.
  *
  * Return: 0 on success and <0 on error.
  */
-int iopf_queue_flush_dev(struct device *dev)
+int iopf_queue_discard_dev_pasid(struct device *dev, ioasid_t pasid)
 {
 	struct iommu_fault_param *iopf_param = iopf_get_dev_fault_param(dev);
+	const struct iommu_ops *ops = dev_iommu_ops(dev);
+	struct iommu_page_response resp;
+	struct iopf_fault *iopf, *next;
+	int ret = 0;
 
 	if (!iopf_param)
 		return -ENODEV;
 
 	flush_workqueue(iopf_param->queue->wq);
+
+	mutex_lock(&iopf_param->lock);
+	list_for_each_entry_safe(iopf, next, &iopf_param->partial, list) {
+		if (!(iopf->fault.prm.flags & IOMMU_FAULT_PAGE_REQUEST_PASID_VALID) ||
+		    iopf->fault.prm.pasid != pasid)
+			break;
+
+		list_del(&iopf->list);
+		kfree(iopf);
+	}
+
+	list_for_each_entry_safe(iopf, next, &iopf_param->faults, list) {
+		if (!(iopf->fault.prm.flags & IOMMU_FAULT_PAGE_REQUEST_PASID_VALID) ||
+		    iopf->fault.prm.pasid != pasid)
+			continue;
+
+		memset(&resp, 0, sizeof(struct iommu_page_response));
+		resp.pasid = iopf->fault.prm.pasid;
+		resp.grpid = iopf->fault.prm.grpid;
+		resp.code = IOMMU_PAGE_RESP_INVALID;
+
+		if (iopf->fault.prm.flags & IOMMU_FAULT_PAGE_RESPONSE_NEEDS_PASID)
+			resp.flags = IOMMU_PAGE_RESP_PASID_VALID;
+
+		ret = ops->page_response(dev, iopf, &resp);
+		if (ret)
+			break;
+
+		list_del(&iopf->list);
+		kfree(iopf);
+	}
+	mutex_unlock(&iopf_param->lock);
 	iopf_put_dev_fault_param(iopf_param);
 
-	return 0;
+	return ret;
 }
-EXPORT_SYMBOL_GPL(iopf_queue_flush_dev);
+EXPORT_SYMBOL_GPL(iopf_queue_discard_dev_pasid);
 
 /**
  * iopf_queue_discard_partial - Remove all pending partial fault
-- 
2.34.1

