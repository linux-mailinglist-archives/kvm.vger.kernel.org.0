Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 414E07801DE
	for <lists+kvm@lfdr.de>; Fri, 18 Aug 2023 01:45:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356185AbjHQXo1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Aug 2023 19:44:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356210AbjHQXn7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Aug 2023 19:43:59 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A543235A7;
        Thu, 17 Aug 2023 16:43:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692315836; x=1723851836;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=y/z7zJucyrwowTDIwuIT1UUN4PWR9t1a/OA+Ip560pg=;
  b=aM+6WW2MbPFRSS/nzoSw+A4qVS2YWZI7kALv0/BXA9T75UL0ft7zhXPx
   l40eSmrwdcnmQtfoQk1I/DDH1R84WewYwjgywKEi8T8qSpDI7Owws03PA
   wy8XQTgnZFNrA5VCKQkaDoE6zVamcVBSNU+NxqVzbotBKksh1tq73MK2M
   bjBemdgF5HjOn8uIY1P9J7CJ+YIiwKWQ77tO83OdfxEPa1sgxDgLe+sUd
   IQ1tLLbGhe4zCoMQnpB/gY7YYcgeZFkbDGZSfgQC1CSsIYbELhlsY9AbM
   uFqf7OLDncpsCTajX0ADSIUyMSsQArQU9MYDQ/2iUvOu+Ki+LJV79giBg
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10805"; a="352552080"
X-IronPort-AV: E=Sophos;i="6.01,181,1684825200"; 
   d="scan'208";a="352552080"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2023 16:43:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10805"; a="849051857"
X-IronPort-AV: E=Sophos;i="6.01,181,1684825200"; 
   d="scan'208";a="849051857"
Received: from allen-box.sh.intel.com ([10.239.159.127])
  by fmsmga002.fm.intel.com with ESMTP; 17 Aug 2023 16:43:51 -0700
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
Subject: [PATCH v3 07/11] iommu: Prepare for separating SVA and IOPF
Date:   Fri, 18 Aug 2023 07:40:43 +0800
Message-Id: <20230817234047.195194-8-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230817234047.195194-1-baolu.lu@linux.intel.com>
References: <20230817234047.195194-1-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move iopf_group data structure to iommu.h. This is being done to make it
a minimal set of faults that a domain's page fault handler should handle.

Add two new helpers for the domain's page fault handler:
- iopf_free_group: free a fault group after all faults in the group are
  handled.
- iopf_queue_work: queue a given work item for a fault group.

This will simplify the sequential patches.

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
---
 include/linux/iommu.h      | 12 ++++++++++
 drivers/iommu/io-pgfault.c | 49 ++++++++++++++++++++++----------------
 2 files changed, 41 insertions(+), 20 deletions(-)

diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 8243d72098ea..ff292eea9d31 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -516,6 +516,18 @@ struct dev_iommu {
 	u32				require_direct:1;
 };
 
+struct iopf_fault {
+	struct iommu_fault		fault;
+	struct list_head		list;
+};
+
+struct iopf_group {
+	struct iopf_fault		last_fault;
+	struct list_head		faults;
+	struct work_struct		work;
+	struct device			*dev;
+};
+
 int iommu_device_register(struct iommu_device *iommu,
 			  const struct iommu_ops *ops,
 			  struct device *hwdev);
diff --git a/drivers/iommu/io-pgfault.c b/drivers/iommu/io-pgfault.c
index 31832aeacdba..d07586cd37fd 100644
--- a/drivers/iommu/io-pgfault.c
+++ b/drivers/iommu/io-pgfault.c
@@ -25,17 +25,17 @@ struct iopf_queue {
 	struct mutex			lock;
 };
 
-struct iopf_fault {
-	struct iommu_fault		fault;
-	struct list_head		list;
-};
+static void iopf_free_group(struct iopf_group *group)
+{
+	struct iopf_fault *iopf, *next;
 
-struct iopf_group {
-	struct iopf_fault		last_fault;
-	struct list_head		faults;
-	struct work_struct		work;
-	struct device			*dev;
-};
+	list_for_each_entry_safe(iopf, next, &group->faults, list) {
+		if (!(iopf->fault.prm.flags & IOMMU_FAULT_PAGE_REQUEST_LAST_PAGE))
+			kfree(iopf);
+	}
+
+	kfree(group);
+}
 
 static int iopf_complete_group(struct device *dev, struct iopf_fault *iopf,
 			       enum iommu_page_response_code status)
@@ -55,9 +55,9 @@ static int iopf_complete_group(struct device *dev, struct iopf_fault *iopf,
 
 static void iopf_handler(struct work_struct *work)
 {
+	struct iopf_fault *iopf;
 	struct iopf_group *group;
 	struct iommu_domain *domain;
-	struct iopf_fault *iopf, *next;
 	enum iommu_page_response_code status = IOMMU_PAGE_RESP_SUCCESS;
 
 	group = container_of(work, struct iopf_group, work);
@@ -66,7 +66,7 @@ static void iopf_handler(struct work_struct *work)
 	if (!domain || !domain->iopf_handler)
 		status = IOMMU_PAGE_RESP_INVALID;
 
-	list_for_each_entry_safe(iopf, next, &group->faults, list) {
+	list_for_each_entry(iopf, &group->faults, list) {
 		/*
 		 * For the moment, errors are sticky: don't handle subsequent
 		 * faults in the group if there is an error.
@@ -74,14 +74,21 @@ static void iopf_handler(struct work_struct *work)
 		if (status == IOMMU_PAGE_RESP_SUCCESS)
 			status = domain->iopf_handler(&iopf->fault,
 						      domain->fault_data);
-
-		if (!(iopf->fault.prm.flags &
-		      IOMMU_FAULT_PAGE_REQUEST_LAST_PAGE))
-			kfree(iopf);
 	}
 
 	iopf_complete_group(group->dev, &group->last_fault, status);
-	kfree(group);
+	iopf_free_group(group);
+}
+
+static int iopf_queue_work(struct iopf_group *group, work_func_t func)
+{
+	struct iommu_fault_param *fault_param = group->dev->iommu->fault_param;
+
+	INIT_WORK(&group->work, func);
+	if (!queue_work(fault_param->queue->wq, &group->work))
+		return -EBUSY;
+
+	return 0;
 }
 
 /**
@@ -174,7 +181,6 @@ int iommu_queue_iopf(struct iommu_fault *fault, struct device *dev)
 	group->last_fault.fault = *fault;
 	INIT_LIST_HEAD(&group->faults);
 	list_add(&group->last_fault.list, &group->faults);
-	INIT_WORK(&group->work, iopf_handler);
 
 	/* See if we have partial faults for this group */
 	list_for_each_entry_safe(iopf, next, &iopf_param->partial, list) {
@@ -183,8 +189,11 @@ int iommu_queue_iopf(struct iommu_fault *fault, struct device *dev)
 			list_move(&iopf->list, &group->faults);
 	}
 
-	queue_work(iopf_param->queue->wq, &group->work);
-	return 0;
+	ret = iopf_queue_work(group, iopf_handler);
+	if (ret)
+		iopf_free_group(group);
+
+	return ret;
 
 cleanup_partial:
 	list_for_each_entry_safe(iopf, next, &iopf_param->partial, list) {
-- 
2.34.1

