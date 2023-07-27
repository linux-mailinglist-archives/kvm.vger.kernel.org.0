Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AD06764648
	for <lists+kvm@lfdr.de>; Thu, 27 Jul 2023 07:53:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232428AbjG0FxY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jul 2023 01:53:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231292AbjG0Fwq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jul 2023 01:52:46 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 122C72D78;
        Wed, 26 Jul 2023 22:52:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690437124; x=1721973124;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bo7j5BLXIN5mLcOYYAhlexshciJVhnanhx6HW6/JcJg=;
  b=KbxjEi6NTK6PyFCTeh+ptNLBBTot7vveJVOE3GzWEVSsxRzZBbE5nYER
   f3kP+m6aFZTstVVLF2Mnw/ME23D+PRGXFqOZqslg1b6NwkK7tb9aIzNqT
   MFNL9R6d6cI1CbM8BJ5kVsM4r03mlbjZl7ZwJr2ZGl/0Cu4L/NA5fcBy/
   IgLHLvEG2eZpXElNLNizJMLJzEg7NE7W4CSBYaKpoqWlXadLUHmD7PDVs
   /wDjIFoZljG1L6+tz/kjcJKrIl4TLJ6+VZssQOHtLVSYsAXlPSc0VCWUp
   IzwSziATdO9EEKKV/URqAvmy07DNIAIYZ5zRAx7E3+DTKeKUhjG6uYtEr
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10783"; a="399152624"
X-IronPort-AV: E=Sophos;i="6.01,234,1684825200"; 
   d="scan'208";a="399152624"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2023 22:51:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10783"; a="840585320"
X-IronPort-AV: E=Sophos;i="6.01,234,1684825200"; 
   d="scan'208";a="840585320"
Received: from allen-box.sh.intel.com ([10.239.159.127])
  by fmsmga002.fm.intel.com with ESMTP; 26 Jul 2023 22:51:18 -0700
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
Subject: [PATCH v2 10/12] iommu: Make iommu_queue_iopf() more generic
Date:   Thu, 27 Jul 2023 13:48:35 +0800
Message-Id: <20230727054837.147050-11-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230727054837.147050-1-baolu.lu@linux.intel.com>
References: <20230727054837.147050-1-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This completely separates the IO page fault handling framework from the
SVA implementation. Previously, the SVA implementation was tightly coupled
with the IO page fault handling framework. This makes SVA a "customer" of
the IO page fault handling framework by converting domain's page fault
handler to handle a group of faults and calling it directly from
iommu_queue_iopf().

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
---
 include/linux/iommu.h      |  5 +++--
 drivers/iommu/iommu-sva.h  |  8 --------
 drivers/iommu/io-pgfault.c | 16 +++++++++++++---
 drivers/iommu/iommu-sva.c  | 11 ++---------
 drivers/iommu/iommu.c      |  2 +-
 5 files changed, 19 insertions(+), 23 deletions(-)

diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 607740e548f2..1dafe031a56c 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -40,6 +40,7 @@ struct notifier_block;
 struct iommu_sva;
 struct iommu_fault_event;
 struct iommu_dma_cookie;
+struct iopf_group;
 
 #define IOMMU_FAULT_PERM_READ	(1 << 0) /* read */
 #define IOMMU_FAULT_PERM_WRITE	(1 << 1) /* write */
@@ -179,8 +180,7 @@ struct iommu_domain {
 	unsigned long pgsize_bitmap;	/* Bitmap of page sizes in use */
 	struct iommu_domain_geometry geometry;
 	struct iommu_dma_cookie *iova_cookie;
-	enum iommu_page_response_code (*iopf_handler)(struct iommu_fault *fault,
-						      void *data);
+	int (*iopf_handler)(struct iopf_group *group);
 	void *fault_data;
 	union {
 		struct {
@@ -513,6 +513,7 @@ struct iopf_group {
 	struct list_head		faults;
 	struct work_struct		work;
 	struct device			*dev;
+	void				*data;
 };
 
 int iommu_device_register(struct iommu_device *iommu,
diff --git a/drivers/iommu/iommu-sva.h b/drivers/iommu/iommu-sva.h
index 510a7df23fba..cf41e88fac17 100644
--- a/drivers/iommu/iommu-sva.h
+++ b/drivers/iommu/iommu-sva.h
@@ -22,8 +22,6 @@ int iopf_queue_flush_dev(struct device *dev);
 struct iopf_queue *iopf_queue_alloc(const char *name);
 void iopf_queue_free(struct iopf_queue *queue);
 int iopf_queue_discard_partial(struct iopf_queue *queue);
-enum iommu_page_response_code
-iommu_sva_handle_iopf(struct iommu_fault *fault, void *data);
 void iopf_free_group(struct iopf_group *group);
 int iopf_queue_work(struct iopf_group *group, work_func_t func);
 int iommu_sva_handle_iopf_group(struct iopf_group *group);
@@ -65,12 +63,6 @@ static inline int iopf_queue_discard_partial(struct iopf_queue *queue)
 	return -ENODEV;
 }
 
-static inline enum iommu_page_response_code
-iommu_sva_handle_iopf(struct iommu_fault *fault, void *data)
-{
-	return IOMMU_PAGE_RESP_INVALID;
-}
-
 static inline void iopf_free_group(struct iopf_group *group)
 {
 }
diff --git a/drivers/iommu/io-pgfault.c b/drivers/iommu/io-pgfault.c
index 3614a800638c..c5cfa3dfa77b 100644
--- a/drivers/iommu/io-pgfault.c
+++ b/drivers/iommu/io-pgfault.c
@@ -11,8 +11,6 @@
 #include <linux/slab.h>
 #include <linux/workqueue.h>
 
-#include "iommu-sva.h"
-
 /**
  * struct iopf_queue - IO Page Fault queue
  * @wq: the fault workqueue
@@ -106,6 +104,7 @@ int iommu_queue_iopf(struct iommu_fault *fault, struct device *dev)
 {
 	int ret;
 	struct iopf_group *group;
+	struct iommu_domain *domain;
 	struct iopf_fault *iopf, *next;
 	struct iopf_device_param *iopf_param;
 	struct dev_iommu *param = dev->iommu;
@@ -137,6 +136,16 @@ int iommu_queue_iopf(struct iommu_fault *fault, struct device *dev)
 		return 0;
 	}
 
+	if (fault->prm.flags & IOMMU_FAULT_PAGE_REQUEST_PASID_VALID)
+		domain = iommu_get_domain_for_dev_pasid(dev, fault->prm.pasid, 0);
+	else
+		domain = iommu_get_domain_for_dev(dev);
+
+	if (!domain || !domain->iopf_handler) {
+		ret = -ENODEV;
+		goto cleanup_partial;
+	}
+
 	group = kzalloc(sizeof(*group), GFP_KERNEL);
 	if (!group) {
 		/*
@@ -150,6 +159,7 @@ int iommu_queue_iopf(struct iommu_fault *fault, struct device *dev)
 
 	group->dev = dev;
 	group->last_fault.fault = *fault;
+	group->data = domain->fault_data;
 	INIT_LIST_HEAD(&group->faults);
 	list_add(&group->last_fault.list, &group->faults);
 
@@ -160,7 +170,7 @@ int iommu_queue_iopf(struct iommu_fault *fault, struct device *dev)
 			list_move(&iopf->list, &group->faults);
 	}
 
-	ret = iommu_sva_handle_iopf_group(group);
+	ret = domain->iopf_handler(group);
 	if (ret)
 		iopf_free_group(group);
 
diff --git a/drivers/iommu/iommu-sva.c b/drivers/iommu/iommu-sva.c
index ab42cfdd7636..668f4c2bcf65 100644
--- a/drivers/iommu/iommu-sva.c
+++ b/drivers/iommu/iommu-sva.c
@@ -157,7 +157,7 @@ EXPORT_SYMBOL_GPL(iommu_sva_get_pasid);
 /*
  * I/O page fault handler for SVA
  */
-enum iommu_page_response_code
+static enum iommu_page_response_code
 iommu_sva_handle_iopf(struct iommu_fault *fault, void *data)
 {
 	vm_fault_t ret;
@@ -241,23 +241,16 @@ static void iopf_handler(struct work_struct *work)
 {
 	struct iopf_fault *iopf;
 	struct iopf_group *group;
-	struct iommu_domain *domain;
 	enum iommu_page_response_code status = IOMMU_PAGE_RESP_SUCCESS;
 
 	group = container_of(work, struct iopf_group, work);
-	domain = iommu_get_domain_for_dev_pasid(group->dev,
-				group->last_fault.fault.prm.pasid, 0);
-	if (!domain || !domain->iopf_handler)
-		status = IOMMU_PAGE_RESP_INVALID;
-
 	list_for_each_entry(iopf, &group->faults, list) {
 		/*
 		 * For the moment, errors are sticky: don't handle subsequent
 		 * faults in the group if there is an error.
 		 */
 		if (status == IOMMU_PAGE_RESP_SUCCESS)
-			status = domain->iopf_handler(&iopf->fault,
-						      domain->fault_data);
+			status = iommu_sva_handle_iopf(&iopf->fault, group->data);
 	}
 
 	iopf_complete_group(group->dev, &group->last_fault, status);
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 157a28a49473..535a36e3edc9 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -3330,7 +3330,7 @@ struct iommu_domain *iommu_sva_domain_alloc(struct device *dev,
 	domain->type = IOMMU_DOMAIN_SVA;
 	mmgrab(mm);
 	domain->mm = mm;
-	domain->iopf_handler = iommu_sva_handle_iopf;
+	domain->iopf_handler = iommu_sva_handle_iopf_group;
 	domain->fault_data = mm;
 
 	return domain;
-- 
2.34.1

