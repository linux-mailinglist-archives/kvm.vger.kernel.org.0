Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 622C0764643
	for <lists+kvm@lfdr.de>; Thu, 27 Jul 2023 07:52:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232599AbjG0Fwg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jul 2023 01:52:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231600AbjG0FwI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jul 2023 01:52:08 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6576B3A85;
        Wed, 26 Jul 2023 22:51:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690437107; x=1721973107;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wmvhOYuYE3uALXjAh/oLQV5kbPyvlH/DZyMYNAYmziM=;
  b=OvZ3EhI8hoIzRRcxw0zuHnM6LVqL6qB2Ng0xBzwmjRrOUW+zQ8wdbTRF
   WSnGSPnjpm6RwMMpSUdQwJea+0bL2SOj75fCplJ3sIW6XFH8XvMPsJWlQ
   h53UjJULERJ6FZK6zEpFbHCkcKIHZ6caX03iQLjBHWmmgoDeV6VgS1+em
   6r8OVGYq3u+9rW1sa8PWY/XTjmEOjfT63Qjn59/qZScwIZLOSFMiDfkk3
   xRdF+r8fFM6qPRhQ6ltLbeSBT6fw+0UN3Mn1LerLttORHB5yjcU6vRbGo
   DXp+QNOrZulIpvbEz7f7ebcnbzxJo1YfWvJ/Bu7twp/ARON8u6uW1i50z
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10783"; a="399152589"
X-IronPort-AV: E=Sophos;i="6.01,234,1684825200"; 
   d="scan'208";a="399152589"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2023 22:51:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10783"; a="840585305"
X-IronPort-AV: E=Sophos;i="6.01,234,1684825200"; 
   d="scan'208";a="840585305"
Received: from allen-box.sh.intel.com ([10.239.159.127])
  by fmsmga002.fm.intel.com with ESMTP; 26 Jul 2023 22:51:12 -0700
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
Subject: [PATCH v2 08/12] iommu: Prepare for separating SVA and IOPF
Date:   Thu, 27 Jul 2023 13:48:33 +0800
Message-Id: <20230727054837.147050-9-baolu.lu@linux.intel.com>
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

Move iopf_group data structure to iommu.h. This is being done to make it
a minimal set of faults that a domain's page fault handler should handle.

Add two new helpers for the domain's page fault handler:
- iopf_free_group: free a fault group after all faults in the group are
  handled.
- iopf_queue_work: queue a given work item for a fault group.

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
---
 include/linux/iommu.h      | 12 ++++++++++
 drivers/iommu/io-pgfault.c | 48 ++++++++++++++++++++++----------------
 2 files changed, 40 insertions(+), 20 deletions(-)

diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index cb12bab38365..607740e548f2 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -503,6 +503,18 @@ struct dev_iommu {
 	u32				pci_32bit_workaround:1;
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
index 7e6697083f9d..1432751ff4d4 100644
--- a/drivers/iommu/io-pgfault.c
+++ b/drivers/iommu/io-pgfault.c
@@ -40,17 +40,17 @@ struct iopf_device_param {
 	struct list_head		partial;
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
@@ -71,9 +71,9 @@ static int iopf_complete_group(struct device *dev, struct iopf_fault *iopf,
 
 static void iopf_handler(struct work_struct *work)
 {
+	struct iopf_fault *iopf;
 	struct iopf_group *group;
 	struct iommu_domain *domain;
-	struct iopf_fault *iopf, *next;
 	enum iommu_page_response_code status = IOMMU_PAGE_RESP_SUCCESS;
 
 	group = container_of(work, struct iopf_group, work);
@@ -82,7 +82,7 @@ static void iopf_handler(struct work_struct *work)
 	if (!domain || !domain->iopf_handler)
 		status = IOMMU_PAGE_RESP_INVALID;
 
-	list_for_each_entry_safe(iopf, next, &group->faults, list) {
+	list_for_each_entry(iopf, &group->faults, list) {
 		/*
 		 * For the moment, errors are sticky: don't handle subsequent
 		 * faults in the group if there is an error.
@@ -90,14 +90,20 @@ static void iopf_handler(struct work_struct *work)
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
+	struct iopf_device_param *iopf_param = group->dev->iommu->iopf_param;
+
+	INIT_WORK(&group->work, func);
+	queue_work(iopf_param->queue->wq, &group->work);
+
+	return 0;
 }
 
 /**
@@ -190,7 +196,6 @@ int iommu_queue_iopf(struct iommu_fault *fault, struct device *dev)
 	group->last_fault.fault = *fault;
 	INIT_LIST_HEAD(&group->faults);
 	list_add(&group->last_fault.list, &group->faults);
-	INIT_WORK(&group->work, iopf_handler);
 
 	/* See if we have partial faults for this group */
 	list_for_each_entry_safe(iopf, next, &iopf_param->partial, list) {
@@ -199,8 +204,11 @@ int iommu_queue_iopf(struct iommu_fault *fault, struct device *dev)
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

