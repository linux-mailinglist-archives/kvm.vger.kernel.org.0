Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8257C79FF62
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 11:01:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236723AbjINJBc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 05:01:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236664AbjINJAw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 05:00:52 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F7A52D59;
        Thu, 14 Sep 2023 02:00:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694682029; x=1726218029;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZtOXclHsAEIRIFEpox6fhTrVNI+nxlXlWz9EfU2LP9M=;
  b=U7/uUt6vzfMkk3xVHij06Q5y6vBrvjKMedpOs8mEnX1GM2+HKvDfpX4Q
   AN+TX6lR02m1LFo4Uxm+2QUbtnPEu/mg5vwxhRDwUOv0KXXmuqvIZ624t
   dInEcQ6mV/YtnOvISRA4dDj1jfjilbBpEn+Sr/gNSvPd6AU0DXB/TgTrQ
   fITPgUGAXXyG7jG1kKitoU//fvoJstLkqVKcLlXAV4XO/uA0Oq2aWKdY4
   mrVMPSKVG8YMS/3kksvvNT/hEOqaOUzhOcq64I5gRhWexoGGRRK6GdkLt
   iIx1I9PJWbFrguxFs6pphOd8Qg0g9LjgBk9k4L8JTz8e75q1hnk26taVA
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="465266533"
X-IronPort-AV: E=Sophos;i="6.02,145,1688454000"; 
   d="scan'208";a="465266533"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2023 02:00:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="859613429"
X-IronPort-AV: E=Sophos;i="6.02,145,1688454000"; 
   d="scan'208";a="859613429"
Received: from allen-box.sh.intel.com ([10.239.159.127])
  by fmsmga002.fm.intel.com with ESMTP; 14 Sep 2023 02:00:25 -0700
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
Subject: [PATCH v5 12/12] iommu: Improve iopf_queue_flush_dev()
Date:   Thu, 14 Sep 2023 16:56:38 +0800
Message-Id: <20230914085638.17307-13-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230914085638.17307-1-baolu.lu@linux.intel.com>
References: <20230914085638.17307-1-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
iommu core. Remove a warning message in iommu_page_response() since the
iopf queue might get flushed before possible pending responses.

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
---
 include/linux/iommu.h      |  4 ++--
 drivers/iommu/intel/svm.c  |  2 +-
 drivers/iommu/io-pgfault.c | 46 +++++++++++++++++++++++++++++++++-----
 3 files changed, 44 insertions(+), 8 deletions(-)

diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 77ad33ffe3ac..465e23e945d0 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -1275,7 +1275,7 @@ iommu_sva_domain_alloc(struct device *dev, struct mm_struct *mm)
 #ifdef CONFIG_IOMMU_IOPF
 int iopf_queue_add_device(struct iopf_queue *queue, struct device *dev);
 int iopf_queue_remove_device(struct iopf_queue *queue, struct device *dev);
-int iopf_queue_flush_dev(struct device *dev);
+int iopf_queue_flush_dev(struct device *dev, ioasid_t pasid);
 struct iopf_queue *iopf_queue_alloc(const char *name);
 void iopf_queue_free(struct iopf_queue *queue);
 int iopf_queue_discard_partial(struct iopf_queue *queue);
@@ -1295,7 +1295,7 @@ iopf_queue_remove_device(struct iopf_queue *queue, struct device *dev)
 	return -ENODEV;
 }
 
-static inline int iopf_queue_flush_dev(struct device *dev)
+static inline int iopf_queue_flush_dev(struct device *dev, ioasid_t pasid)
 {
 	return -ENODEV;
 }
diff --git a/drivers/iommu/intel/svm.c b/drivers/iommu/intel/svm.c
index 780c5bd73ec2..4c3f4533e337 100644
--- a/drivers/iommu/intel/svm.c
+++ b/drivers/iommu/intel/svm.c
@@ -495,7 +495,7 @@ void intel_drain_pasid_prq(struct device *dev, u32 pasid)
 		goto prq_retry;
 	}
 
-	iopf_queue_flush_dev(dev);
+	iopf_queue_flush_dev(dev, pasid);
 
 	/*
 	 * Perform steps described in VT-d spec CH7.10 to drain page
diff --git a/drivers/iommu/io-pgfault.c b/drivers/iommu/io-pgfault.c
index 3e6845bc5902..8d81688f715d 100644
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
@@ -300,6 +299,7 @@ EXPORT_SYMBOL_GPL(iommu_page_response);
 /**
  * iopf_queue_flush_dev - Ensure that all queued faults have been processed
  * @dev: the endpoint whose faults need to be flushed.
+ * @pasid: the PASID of the endpoint.
  *
  * The IOMMU driver calls this before releasing a PASID, to ensure that all
  * pending faults for this PASID have been handled, and won't hit the address
@@ -309,17 +309,53 @@ EXPORT_SYMBOL_GPL(iommu_page_response);
  *
  * Return: 0 on success and <0 on error.
  */
-int iopf_queue_flush_dev(struct device *dev)
+int iopf_queue_flush_dev(struct device *dev, ioasid_t pasid)
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
 EXPORT_SYMBOL_GPL(iopf_queue_flush_dev);
 
-- 
2.34.1

