Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4D477B1195
	for <lists+kvm@lfdr.de>; Thu, 28 Sep 2023 06:31:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230352AbjI1Eb6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Sep 2023 00:31:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230264AbjI1Ebi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Sep 2023 00:31:38 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C325813A;
        Wed, 27 Sep 2023 21:31:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695875489; x=1727411489;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4Ykh3IfobVAyYm1xfBoLatIcMHIeX/eT3tr+EqrZTvM=;
  b=aVJmRrIwu9CPJoGxtPbHoAsiRM6LogwwWdXVybuBQ5qFCC6GZ9BJzOg4
   nn5Qv89K4FZOtOTkYoPeb5YDWbHX2QA6lGkfGORoOF213sK9ZtN1O5mMs
   ctie8O/G6VGzxszFiAANXMa0ctVBAtN7/pjk/6ajv1AY+VGzDUo2pXV1K
   wjREwn2PcL5b8tomulK8eoNXu3OPSdfg2v4/HAXBXkrkDuGwkLnWKCtFX
   GDbPbrb/xgN0eyB18hM3jQ370m2lWOS7RF2OegiRoRwVaohVpMkZbef3S
   bIB+pmswe30OGwgHZqqfeE7USLX8ahtr3/1Kcsw2o2AMIwtw0NHKFqMCx
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10846"; a="379260525"
X-IronPort-AV: E=Sophos;i="6.03,182,1694761200"; 
   d="scan'208";a="379260525"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2023 21:31:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10846"; a="923068999"
X-IronPort-AV: E=Sophos;i="6.03,182,1694761200"; 
   d="scan'208";a="923068999"
Received: from allen-box.sh.intel.com ([10.239.159.127])
  by orsmga005.jf.intel.com with ESMTP; 27 Sep 2023 21:31:25 -0700
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
        linux-kernel@vger.kernel.org, Lu Baolu <baolu.lu@linux.intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH v6 08/12] iommu: Prepare for separating SVA and IOPF
Date:   Thu, 28 Sep 2023 12:27:30 +0800
Message-Id: <20230928042734.16134-9-baolu.lu@linux.intel.com>
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

Move iopf_group data structure to iommu.h to make it a minimal set of
faults that a domain's page fault handler should handle.

Add a new function, iopf_free_group(), to free a fault group after all
faults in the group are handled. This function will be made global so
that it can be called from other files, such as iommu-sva.c.

Move iopf_queue data structure to iommu.h to allow the workqueue to be
scheduled out of this file.

This will simplify the sequential patches.

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
---
 include/linux/iommu.h      | 20 +++++++++++++++++++-
 drivers/iommu/io-pgfault.c | 37 +++++++++++++------------------------
 2 files changed, 32 insertions(+), 25 deletions(-)

diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 53fe4b2c8e64..d1f5b3cba831 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -39,7 +39,6 @@ struct iommu_domain_ops;
 struct notifier_block;
 struct iommu_sva;
 struct iommu_dma_cookie;
-struct iopf_queue;
 
 #define IOMMU_FAULT_PERM_READ	(1 << 0) /* read */
 #define IOMMU_FAULT_PERM_WRITE	(1 << 1) /* write */
@@ -124,6 +123,25 @@ struct iopf_fault {
 	struct list_head list;
 };
 
+struct iopf_group {
+	struct iopf_fault last_fault;
+	struct list_head faults;
+	struct work_struct work;
+	struct device *dev;
+};
+
+/**
+ * struct iopf_queue - IO Page Fault queue
+ * @wq: the fault workqueue
+ * @devices: devices attached to this queue
+ * @lock: protects the device list
+ */
+struct iopf_queue {
+	struct workqueue_struct *wq;
+	struct list_head devices;
+	struct mutex lock;
+};
+
 /* iommu fault flags */
 #define IOMMU_FAULT_READ	0x0
 #define IOMMU_FAULT_WRITE	0x1
diff --git a/drivers/iommu/io-pgfault.c b/drivers/iommu/io-pgfault.c
index c45977bb7da3..09e05f483b4f 100644
--- a/drivers/iommu/io-pgfault.c
+++ b/drivers/iommu/io-pgfault.c
@@ -13,24 +13,17 @@
 
 #include "iommu-sva.h"
 
-/**
- * struct iopf_queue - IO Page Fault queue
- * @wq: the fault workqueue
- * @devices: devices attached to this queue
- * @lock: protects the device list
- */
-struct iopf_queue {
-	struct workqueue_struct		*wq;
-	struct list_head		devices;
-	struct mutex			lock;
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
@@ -50,9 +43,9 @@ static int iopf_complete_group(struct device *dev, struct iopf_fault *iopf,
 
 static void iopf_handler(struct work_struct *work)
 {
+	struct iopf_fault *iopf;
 	struct iopf_group *group;
 	struct iommu_domain *domain;
-	struct iopf_fault *iopf, *next;
 	enum iommu_page_response_code status = IOMMU_PAGE_RESP_SUCCESS;
 
 	group = container_of(work, struct iopf_group, work);
@@ -61,7 +54,7 @@ static void iopf_handler(struct work_struct *work)
 	if (!domain || !domain->iopf_handler)
 		status = IOMMU_PAGE_RESP_INVALID;
 
-	list_for_each_entry_safe(iopf, next, &group->faults, list) {
+	list_for_each_entry(iopf, &group->faults, list) {
 		/*
 		 * For the moment, errors are sticky: don't handle subsequent
 		 * faults in the group if there is an error.
@@ -69,14 +62,10 @@ static void iopf_handler(struct work_struct *work)
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
 }
 
 /**
-- 
2.34.1

