Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6AD079FF5E
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 11:01:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237057AbjINJBE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 05:01:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236820AbjINJAo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 05:00:44 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A88BC2703;
        Thu, 14 Sep 2023 02:00:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694682025; x=1726218025;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xBus2XQHm+QiOijukIatmsfevy9MrEDC2tbd9ra4s3A=;
  b=LOu8p7GdMkPr34xHLGLTHCj3DfKU21/LqCnup6FSemjvw9o604jWknG5
   0Upkd28POIsBtnIk5S2H7B03Oq3MOAdb2ODfIyFe1V+JUzIdEg9MfrzPF
   m8hcV82JA19ZIqfb/bwmVK1moJXd+1JS1mmqj8RY7ihb8kiYYPMRXLe2u
   J/MCYu5TPhNTsFUKfmmKqC+YvKktrstPJQZdH2PKy3fjULNUsA1dDqpXU
   eZ4XlyCxAm2AptGif6TciQoGXxXCeHZrw4QJY5zJXusPkJLw70OD+bI0j
   eXn0yo3AYtzuMOs0HG0B7u8DHtLEIj9cp6JncjLzHinQPfohlaEWp3qq8
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="465266488"
X-IronPort-AV: E=Sophos;i="6.02,145,1688454000"; 
   d="scan'208";a="465266488"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2023 02:00:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="859613376"
X-IronPort-AV: E=Sophos;i="6.02,145,1688454000"; 
   d="scan'208";a="859613376"
Received: from allen-box.sh.intel.com ([10.239.159.127])
  by fmsmga002.fm.intel.com with ESMTP; 14 Sep 2023 02:00:18 -0700
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
Subject: [PATCH v5 10/12] iommu: Separate SVA and IOPF
Date:   Thu, 14 Sep 2023 16:56:36 +0800
Message-Id: <20230914085638.17307-11-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230914085638.17307-1-baolu.lu@linux.intel.com>
References: <20230914085638.17307-1-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add CONFIG_IOMMU_IOPF for page fault handling framework and select it
from its real consumer. Move iopf function declaration from iommu-sva.h
to iommu.h and remove iommu-sva.h as it's empty now.

Consolidate all SVA related code into iommu-sva.c:
- Move iommu_sva_domain_alloc() from iommu.c to iommu-sva.c.
- Move sva iopf handling code from io-pgfault.c to iommu-sva.c.

Consolidate iommu_report_device_fault() and iommu_page_response() into
io-pgfault.c.

Export iopf_free_group() for iopf handlers implemented in modules. Some
functions are renamed with more meaningful names. No other intentional
functionality changes.

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
---
 include/linux/iommu.h                         |  90 +++++++---
 drivers/iommu/iommu-sva.h                     |  69 --------
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   |   1 -
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   |   1 -
 drivers/iommu/intel/iommu.c                   |   1 -
 drivers/iommu/intel/svm.c                     |   1 -
 drivers/iommu/io-pgfault.c                    | 163 ++++++++++++------
 drivers/iommu/iommu-sva.c                     |  79 ++++++++-
 drivers/iommu/iommu.c                         | 133 --------------
 drivers/iommu/Kconfig                         |   4 +
 drivers/iommu/Makefile                        |   3 +-
 drivers/iommu/intel/Kconfig                   |   1 +
 12 files changed, 257 insertions(+), 289 deletions(-)
 delete mode 100644 drivers/iommu/iommu-sva.h

diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index da47813c2e4c..1697ac168f05 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -609,10 +609,6 @@ extern struct iommu_group *iommu_group_get(struct device *dev);
 extern struct iommu_group *iommu_group_ref_get(struct iommu_group *group);
 extern void iommu_group_put(struct iommu_group *group);
 
-extern int iommu_report_device_fault(struct device *dev, struct iopf_fault *evt);
-extern int iommu_page_response(struct device *dev,
-			       struct iommu_page_response *msg);
-
 extern int iommu_group_id(struct iommu_group *group);
 extern struct iommu_domain *iommu_group_default_domain(struct iommu_group *);
 
@@ -802,8 +798,6 @@ bool iommu_group_dma_owner_claimed(struct iommu_group *group);
 int iommu_device_claim_dma_owner(struct device *dev, void *owner);
 void iommu_device_release_dma_owner(struct device *dev);
 
-struct iommu_domain *iommu_sva_domain_alloc(struct device *dev,
-					    struct mm_struct *mm);
 int iommu_attach_device_pasid(struct iommu_domain *domain,
 			      struct device *dev, ioasid_t pasid);
 void iommu_detach_device_pasid(struct iommu_domain *domain,
@@ -990,18 +984,6 @@ static inline void iommu_group_put(struct iommu_group *group)
 {
 }
 
-static inline
-int iommu_report_device_fault(struct device *dev, struct iopf_fault *evt)
-{
-	return -ENODEV;
-}
-
-static inline int iommu_page_response(struct device *dev,
-				      struct iommu_page_response *msg)
-{
-	return -ENODEV;
-}
-
 static inline int iommu_group_id(struct iommu_group *group)
 {
 	return -ENODEV;
@@ -1138,12 +1120,6 @@ static inline int iommu_device_claim_dma_owner(struct device *dev, void *owner)
 	return -ENODEV;
 }
 
-static inline struct iommu_domain *
-iommu_sva_domain_alloc(struct device *dev, struct mm_struct *mm)
-{
-	return NULL;
-}
-
 static inline int iommu_attach_device_pasid(struct iommu_domain *domain,
 					    struct device *dev, ioasid_t pasid)
 {
@@ -1265,6 +1241,8 @@ struct iommu_sva *iommu_sva_bind_device(struct device *dev,
 					struct mm_struct *mm);
 void iommu_sva_unbind_device(struct iommu_sva *handle);
 u32 iommu_sva_get_pasid(struct iommu_sva *handle);
+struct iommu_domain *iommu_sva_domain_alloc(struct device *dev,
+					    struct mm_struct *mm);
 #else
 static inline struct iommu_sva *
 iommu_sva_bind_device(struct device *dev, struct mm_struct *mm)
@@ -1283,6 +1261,70 @@ static inline u32 iommu_sva_get_pasid(struct iommu_sva *handle)
 static inline void mm_pasid_init(struct mm_struct *mm) {}
 static inline bool mm_valid_pasid(struct mm_struct *mm) { return false; }
 static inline void mm_pasid_drop(struct mm_struct *mm) {}
+
+static inline struct iommu_domain *
+iommu_sva_domain_alloc(struct device *dev, struct mm_struct *mm)
+{
+	return NULL;
+}
 #endif /* CONFIG_IOMMU_SVA */
 
+#ifdef CONFIG_IOMMU_IOPF
+int iopf_queue_add_device(struct iopf_queue *queue, struct device *dev);
+int iopf_queue_remove_device(struct iopf_queue *queue, struct device *dev);
+int iopf_queue_flush_dev(struct device *dev);
+struct iopf_queue *iopf_queue_alloc(const char *name);
+void iopf_queue_free(struct iopf_queue *queue);
+int iopf_queue_discard_partial(struct iopf_queue *queue);
+void iopf_free_group(struct iopf_group *group);
+int iommu_report_device_fault(struct device *dev, struct iopf_fault *evt);
+int iommu_page_response(struct device *dev, struct iommu_page_response *msg);
+#else
+static inline int
+iopf_queue_add_device(struct iopf_queue *queue, struct device *dev)
+{
+	return -ENODEV;
+}
+
+static inline int
+iopf_queue_remove_device(struct iopf_queue *queue, struct device *dev)
+{
+	return -ENODEV;
+}
+
+static inline int iopf_queue_flush_dev(struct device *dev)
+{
+	return -ENODEV;
+}
+
+static inline struct iopf_queue *iopf_queue_alloc(const char *name)
+{
+	return NULL;
+}
+
+static inline void iopf_queue_free(struct iopf_queue *queue)
+{
+}
+
+static inline int iopf_queue_discard_partial(struct iopf_queue *queue)
+{
+	return -ENODEV;
+}
+
+static inline void iopf_free_group(struct iopf_group *group)
+{
+}
+
+static inline int
+iommu_report_device_fault(struct device *dev, struct iopf_fault *evt)
+{
+	return -ENODEV;
+}
+
+static inline int
+iommu_page_response(struct device *dev, struct iommu_page_response *msg)
+{
+	return -ENODEV;
+}
+#endif /* CONFIG_IOMMU_IOPF */
 #endif /* __LINUX_IOMMU_H */
diff --git a/drivers/iommu/iommu-sva.h b/drivers/iommu/iommu-sva.h
deleted file mode 100644
index 27c8da115b41..000000000000
--- a/drivers/iommu/iommu-sva.h
+++ /dev/null
@@ -1,69 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-/*
- * SVA library for IOMMU drivers
- */
-#ifndef _IOMMU_SVA_H
-#define _IOMMU_SVA_H
-
-#include <linux/mm_types.h>
-
-/* I/O Page fault */
-struct device;
-struct iommu_fault;
-struct iopf_queue;
-
-#ifdef CONFIG_IOMMU_SVA
-int iommu_queue_iopf(struct iommu_fault *fault, struct device *dev);
-
-int iopf_queue_add_device(struct iopf_queue *queue, struct device *dev);
-int iopf_queue_remove_device(struct iopf_queue *queue,
-			     struct device *dev);
-int iopf_queue_flush_dev(struct device *dev);
-struct iopf_queue *iopf_queue_alloc(const char *name);
-void iopf_queue_free(struct iopf_queue *queue);
-int iopf_queue_discard_partial(struct iopf_queue *queue);
-int iommu_sva_handle_iopf(struct iopf_group *group);
-
-#else /* CONFIG_IOMMU_SVA */
-static inline int iommu_queue_iopf(struct iommu_fault *fault, struct device *dev)
-{
-	return -ENODEV;
-}
-
-static inline int iopf_queue_add_device(struct iopf_queue *queue,
-					struct device *dev)
-{
-	return -ENODEV;
-}
-
-static inline int iopf_queue_remove_device(struct iopf_queue *queue,
-					   struct device *dev)
-{
-	return -ENODEV;
-}
-
-static inline int iopf_queue_flush_dev(struct device *dev)
-{
-	return -ENODEV;
-}
-
-static inline struct iopf_queue *iopf_queue_alloc(const char *name)
-{
-	return NULL;
-}
-
-static inline void iopf_queue_free(struct iopf_queue *queue)
-{
-}
-
-static inline int iopf_queue_discard_partial(struct iopf_queue *queue)
-{
-	return -ENODEV;
-}
-
-static inline int iommu_sva_handle_iopf(struct iopf_group *group)
-{
-	return IOMMU_PAGE_RESP_INVALID;
-}
-#endif /* CONFIG_IOMMU_SVA */
-#endif /* _IOMMU_SVA_H */
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index 4238c97ba07a..9b720334ede0 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -10,7 +10,6 @@
 #include <linux/slab.h>
 
 #include "arm-smmu-v3.h"
-#include "../../iommu-sva.h"
 #include "../../io-pgtable-arm.h"
 
 struct arm_smmu_mmu_notifier {
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index e537b6c046c5..d0d349bfdba3 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -29,7 +29,6 @@
 
 #include "arm-smmu-v3.h"
 #include "../../dma-iommu.h"
-#include "../../iommu-sva.h"
 
 static bool disable_bypass = true;
 module_param(disable_bypass, bool, 0444);
diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 7b0ed6cdd6b9..e9b3f309273d 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -27,7 +27,6 @@
 #include "iommu.h"
 #include "../dma-iommu.h"
 #include "../irq_remapping.h"
-#include "../iommu-sva.h"
 #include "pasid.h"
 #include "cap_audit.h"
 #include "perfmon.h"
diff --git a/drivers/iommu/intel/svm.c b/drivers/iommu/intel/svm.c
index 9de349ea215c..780c5bd73ec2 100644
--- a/drivers/iommu/intel/svm.c
+++ b/drivers/iommu/intel/svm.c
@@ -22,7 +22,6 @@
 #include "iommu.h"
 #include "pasid.h"
 #include "perf.h"
-#include "../iommu-sva.h"
 #include "trace.h"
 
 static irqreturn_t prq_event_thread(int irq, void *d);
diff --git a/drivers/iommu/io-pgfault.c b/drivers/iommu/io-pgfault.c
index 6533f9d0e37b..7e5c6798ce24 100644
--- a/drivers/iommu/io-pgfault.c
+++ b/drivers/iommu/io-pgfault.c
@@ -11,12 +11,9 @@
 #include <linux/slab.h>
 #include <linux/workqueue.h>
 
-#include "iommu-sva.h"
+#include "iommu-priv.h"
 
-enum iommu_page_response_code
-iommu_sva_handle_mm(struct iommu_fault *fault, struct mm_struct *mm);
-
-static void iopf_free_group(struct iopf_group *group)
+void iopf_free_group(struct iopf_group *group)
 {
 	struct iopf_fault *iopf, *next;
 
@@ -27,47 +24,10 @@ static void iopf_free_group(struct iopf_group *group)
 
 	kfree(group);
 }
-
-static int iopf_complete_group(struct device *dev, struct iopf_fault *iopf,
-			       enum iommu_page_response_code status)
-{
-	struct iommu_page_response resp = {
-		.pasid			= iopf->fault.prm.pasid,
-		.grpid			= iopf->fault.prm.grpid,
-		.code			= status,
-	};
-
-	if ((iopf->fault.prm.flags & IOMMU_FAULT_PAGE_REQUEST_PASID_VALID) &&
-	    (iopf->fault.prm.flags & IOMMU_FAULT_PAGE_RESPONSE_NEEDS_PASID))
-		resp.flags = IOMMU_PAGE_RESP_PASID_VALID;
-
-	return iommu_page_response(dev, &resp);
-}
-
-static void iopf_handler(struct work_struct *work)
-{
-	struct iopf_fault *iopf;
-	struct iopf_group *group;
-	enum iommu_page_response_code status = IOMMU_PAGE_RESP_SUCCESS;
-
-	group = container_of(work, struct iopf_group, work);
-	list_for_each_entry(iopf, &group->faults, list) {
-		/*
-		 * For the moment, errors are sticky: don't handle subsequent
-		 * faults in the group if there is an error.
-		 */
-		if (status != IOMMU_PAGE_RESP_SUCCESS)
-			break;
-
-		status = iommu_sva_handle_mm(&iopf->fault, group->domain->mm);
-	}
-
-	iopf_complete_group(group->dev, &group->last_fault, status);
-	iopf_free_group(group);
-}
+EXPORT_SYMBOL_GPL(iopf_free_group);
 
 /**
- * iommu_queue_iopf - IO Page Fault handler
+ * iommu_handle_iopf - IO Page Fault handler
  * @fault: fault event
  * @dev: struct device.
  *
@@ -106,7 +66,7 @@ static void iopf_handler(struct work_struct *work)
  *
  * Return: 0 on success and <0 on error.
  */
-int iommu_queue_iopf(struct iommu_fault *fault, struct device *dev)
+static int iommu_handle_iopf(struct iommu_fault *fault, struct device *dev)
 {
 	int ret;
 	struct iopf_group *group;
@@ -193,18 +153,117 @@ int iommu_queue_iopf(struct iommu_fault *fault, struct device *dev)
 	}
 	return ret;
 }
-EXPORT_SYMBOL_GPL(iommu_queue_iopf);
 
-int iommu_sva_handle_iopf(struct iopf_group *group)
+/**
+ * iommu_report_device_fault() - Report fault event to device driver
+ * @dev: the device
+ * @evt: fault event data
+ *
+ * Called by IOMMU drivers when a fault is detected, typically in a threaded IRQ
+ * handler. When this function fails and the fault is recoverable, it is the
+ * caller's responsibility to complete the fault.
+ *
+ * Return 0 on success, or an error.
+ */
+int iommu_report_device_fault(struct device *dev, struct iopf_fault *evt)
 {
-	struct iommu_fault_param *fault_param = group->dev->iommu->fault_param;
+	struct dev_iommu *param = dev->iommu;
+	struct iopf_fault *evt_pending = NULL;
+	struct iommu_fault_param *fparam;
+	int ret = 0;
 
-	INIT_WORK(&group->work, iopf_handler);
-	if (!queue_work(fault_param->queue->wq, &group->work))
-		return -EBUSY;
+	if (!param || !evt)
+		return -EINVAL;
 
-	return 0;
+	/* we only report device fault if there is a handler registered */
+	mutex_lock(&param->lock);
+	fparam = param->fault_param;
+
+	if (evt->fault.type == IOMMU_FAULT_PAGE_REQ &&
+	    (evt->fault.prm.flags & IOMMU_FAULT_PAGE_REQUEST_LAST_PAGE)) {
+		evt_pending = kmemdup(evt, sizeof(struct iopf_fault),
+				      GFP_KERNEL);
+		if (!evt_pending) {
+			ret = -ENOMEM;
+			goto done_unlock;
+		}
+		mutex_lock(&fparam->lock);
+		list_add_tail(&evt_pending->list, &fparam->faults);
+		mutex_unlock(&fparam->lock);
+	}
+
+	ret = iommu_handle_iopf(&evt->fault, dev);
+	if (ret && evt_pending) {
+		mutex_lock(&fparam->lock);
+		list_del(&evt_pending->list);
+		mutex_unlock(&fparam->lock);
+		kfree(evt_pending);
+	}
+done_unlock:
+	mutex_unlock(&param->lock);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(iommu_report_device_fault);
+
+int iommu_page_response(struct device *dev,
+			struct iommu_page_response *msg)
+{
+	bool needs_pasid;
+	int ret = -EINVAL;
+	struct iopf_fault *evt;
+	struct iommu_fault_page_request *prm;
+	struct dev_iommu *param = dev->iommu;
+	const struct iommu_ops *ops = dev_iommu_ops(dev);
+	bool has_pasid = msg->flags & IOMMU_PAGE_RESP_PASID_VALID;
+
+	if (!ops->page_response)
+		return -ENODEV;
+
+	if (!param || !param->fault_param)
+		return -EINVAL;
+
+	/* Only send response if there is a fault report pending */
+	mutex_lock(&param->fault_param->lock);
+	if (list_empty(&param->fault_param->faults)) {
+		dev_warn_ratelimited(dev, "no pending PRQ, drop response\n");
+		goto done_unlock;
+	}
+	/*
+	 * Check if we have a matching page request pending to respond,
+	 * otherwise return -EINVAL
+	 */
+	list_for_each_entry(evt, &param->fault_param->faults, list) {
+		prm = &evt->fault.prm;
+		if (prm->grpid != msg->grpid)
+			continue;
+
+		/*
+		 * If the PASID is required, the corresponding request is
+		 * matched using the group ID, the PASID valid bit and the PASID
+		 * value. Otherwise only the group ID matches request and
+		 * response.
+		 */
+		needs_pasid = prm->flags & IOMMU_FAULT_PAGE_RESPONSE_NEEDS_PASID;
+		if (needs_pasid && (!has_pasid || msg->pasid != prm->pasid))
+			continue;
+
+		if (!needs_pasid && has_pasid) {
+			/* No big deal, just clear it. */
+			msg->flags &= ~IOMMU_PAGE_RESP_PASID_VALID;
+			msg->pasid = 0;
+		}
+
+		ret = ops->page_response(dev, evt, msg);
+		list_del(&evt->list);
+		kfree(evt);
+		break;
+	}
+
+done_unlock:
+	mutex_unlock(&param->fault_param->lock);
+	return ret;
 }
+EXPORT_SYMBOL_GPL(iommu_page_response);
 
 /**
  * iopf_queue_flush_dev - Ensure that all queued faults have been processed
diff --git a/drivers/iommu/iommu-sva.c b/drivers/iommu/iommu-sva.c
index ba0d5b7e106a..c58d67956ec9 100644
--- a/drivers/iommu/iommu-sva.c
+++ b/drivers/iommu/iommu-sva.c
@@ -7,7 +7,7 @@
 #include <linux/sched/mm.h>
 #include <linux/iommu.h>
 
-#include "iommu-sva.h"
+#include "iommu-priv.h"
 
 static DEFINE_MUTEX(iommu_sva_lock);
 
@@ -145,10 +145,18 @@ u32 iommu_sva_get_pasid(struct iommu_sva *handle)
 }
 EXPORT_SYMBOL_GPL(iommu_sva_get_pasid);
 
+void mm_pasid_drop(struct mm_struct *mm)
+{
+	if (likely(!mm_valid_pasid(mm)))
+		return;
+
+	iommu_free_global_pasid(mm->pasid);
+}
+
 /*
  * I/O page fault handler for SVA
  */
-enum iommu_page_response_code
+static enum iommu_page_response_code
 iommu_sva_handle_mm(struct iommu_fault *fault, struct mm_struct *mm)
 {
 	vm_fault_t ret;
@@ -202,10 +210,69 @@ iommu_sva_handle_mm(struct iommu_fault *fault, struct mm_struct *mm)
 	return status;
 }
 
-void mm_pasid_drop(struct mm_struct *mm)
+static int iommu_sva_complete_group(struct device *dev, struct iopf_fault *iopf,
+				    enum iommu_page_response_code status)
 {
-	if (likely(!mm_valid_pasid(mm)))
-		return;
+	struct iommu_page_response resp = {
+		.pasid			= iopf->fault.prm.pasid,
+		.grpid			= iopf->fault.prm.grpid,
+		.code			= status,
+	};
 
-	iommu_free_global_pasid(mm->pasid);
+	if ((iopf->fault.prm.flags & IOMMU_FAULT_PAGE_REQUEST_PASID_VALID) &&
+	    (iopf->fault.prm.flags & IOMMU_FAULT_PAGE_RESPONSE_NEEDS_PASID))
+		resp.flags = IOMMU_PAGE_RESP_PASID_VALID;
+
+	return iommu_page_response(dev, &resp);
+}
+
+static void iommu_sva_handle_iopf(struct work_struct *work)
+{
+	struct iopf_fault *iopf;
+	struct iopf_group *group;
+	enum iommu_page_response_code status = IOMMU_PAGE_RESP_SUCCESS;
+
+	group = container_of(work, struct iopf_group, work);
+	list_for_each_entry(iopf, &group->faults, list) {
+		/*
+		 * For the moment, errors are sticky: don't handle subsequent
+		 * faults in the group if there is an error.
+		 */
+		if (status != IOMMU_PAGE_RESP_SUCCESS)
+			break;
+
+		status = iommu_sva_handle_mm(&iopf->fault, group->domain->mm);
+	}
+
+	iommu_sva_complete_group(group->dev, &group->last_fault, status);
+	iopf_free_group(group);
+}
+
+static int iommu_sva_iopf_handler(struct iopf_group *group)
+{
+	struct iommu_fault_param *fault_param = group->dev->iommu->fault_param;
+
+	INIT_WORK(&group->work, iommu_sva_handle_iopf);
+	if (!queue_work(fault_param->queue->wq, &group->work))
+		return -EBUSY;
+
+	return 0;
+}
+
+struct iommu_domain *iommu_sva_domain_alloc(struct device *dev,
+					    struct mm_struct *mm)
+{
+	const struct iommu_ops *ops = dev_iommu_ops(dev);
+	struct iommu_domain *domain;
+
+	domain = ops->domain_alloc(IOMMU_DOMAIN_SVA);
+	if (!domain)
+		return NULL;
+
+	domain->type = IOMMU_DOMAIN_SVA;
+	mmgrab(mm);
+	domain->mm = mm;
+	domain->iopf_handler = iommu_sva_iopf_handler;
+
+	return domain;
 }
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 22600a5e8262..f3231042954b 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -36,9 +36,6 @@
 #include "dma-iommu.h"
 #include "iommu-priv.h"
 
-#include "iommu-sva.h"
-#include "iommu-priv.h"
-
 static struct kset *iommu_group_kset;
 static DEFINE_IDA(iommu_group_ida);
 static DEFINE_IDA(iommu_global_pasid_ida);
@@ -1294,117 +1291,6 @@ void iommu_group_put(struct iommu_group *group)
 }
 EXPORT_SYMBOL_GPL(iommu_group_put);
 
-/**
- * iommu_report_device_fault() - Report fault event to device driver
- * @dev: the device
- * @evt: fault event data
- *
- * Called by IOMMU drivers when a fault is detected, typically in a threaded IRQ
- * handler. When this function fails and the fault is recoverable, it is the
- * caller's responsibility to complete the fault.
- *
- * Return 0 on success, or an error.
- */
-int iommu_report_device_fault(struct device *dev, struct iopf_fault *evt)
-{
-	struct dev_iommu *param = dev->iommu;
-	struct iopf_fault *evt_pending = NULL;
-	struct iommu_fault_param *fparam;
-	int ret = 0;
-
-	if (!param || !evt)
-		return -EINVAL;
-
-	/* we only report device fault if there is a handler registered */
-	mutex_lock(&param->lock);
-	fparam = param->fault_param;
-
-	if (evt->fault.type == IOMMU_FAULT_PAGE_REQ &&
-	    (evt->fault.prm.flags & IOMMU_FAULT_PAGE_REQUEST_LAST_PAGE)) {
-		evt_pending = kmemdup(evt, sizeof(struct iopf_fault),
-				      GFP_KERNEL);
-		if (!evt_pending) {
-			ret = -ENOMEM;
-			goto done_unlock;
-		}
-		mutex_lock(&fparam->lock);
-		list_add_tail(&evt_pending->list, &fparam->faults);
-		mutex_unlock(&fparam->lock);
-	}
-
-	ret = iommu_queue_iopf(&evt->fault, dev);
-	if (ret && evt_pending) {
-		mutex_lock(&fparam->lock);
-		list_del(&evt_pending->list);
-		mutex_unlock(&fparam->lock);
-		kfree(evt_pending);
-	}
-done_unlock:
-	mutex_unlock(&param->lock);
-	return ret;
-}
-EXPORT_SYMBOL_GPL(iommu_report_device_fault);
-
-int iommu_page_response(struct device *dev,
-			struct iommu_page_response *msg)
-{
-	bool needs_pasid;
-	int ret = -EINVAL;
-	struct iopf_fault *evt;
-	struct iommu_fault_page_request *prm;
-	struct dev_iommu *param = dev->iommu;
-	const struct iommu_ops *ops = dev_iommu_ops(dev);
-	bool has_pasid = msg->flags & IOMMU_PAGE_RESP_PASID_VALID;
-
-	if (!ops->page_response)
-		return -ENODEV;
-
-	if (!param || !param->fault_param)
-		return -EINVAL;
-
-	/* Only send response if there is a fault report pending */
-	mutex_lock(&param->fault_param->lock);
-	if (list_empty(&param->fault_param->faults)) {
-		dev_warn_ratelimited(dev, "no pending PRQ, drop response\n");
-		goto done_unlock;
-	}
-	/*
-	 * Check if we have a matching page request pending to respond,
-	 * otherwise return -EINVAL
-	 */
-	list_for_each_entry(evt, &param->fault_param->faults, list) {
-		prm = &evt->fault.prm;
-		if (prm->grpid != msg->grpid)
-			continue;
-
-		/*
-		 * If the PASID is required, the corresponding request is
-		 * matched using the group ID, the PASID valid bit and the PASID
-		 * value. Otherwise only the group ID matches request and
-		 * response.
-		 */
-		needs_pasid = prm->flags & IOMMU_FAULT_PAGE_RESPONSE_NEEDS_PASID;
-		if (needs_pasid && (!has_pasid || msg->pasid != prm->pasid))
-			continue;
-
-		if (!needs_pasid && has_pasid) {
-			/* No big deal, just clear it. */
-			msg->flags &= ~IOMMU_PAGE_RESP_PASID_VALID;
-			msg->pasid = 0;
-		}
-
-		ret = ops->page_response(dev, evt, msg);
-		list_del(&evt->list);
-		kfree(evt);
-		break;
-	}
-
-done_unlock:
-	mutex_unlock(&param->fault_param->lock);
-	return ret;
-}
-EXPORT_SYMBOL_GPL(iommu_page_response);
-
 /**
  * iommu_group_id - Return ID for a group
  * @group: the group to ID
@@ -3393,25 +3279,6 @@ struct iommu_domain *iommu_get_domain_for_dev_pasid(struct device *dev,
 }
 EXPORT_SYMBOL_GPL(iommu_get_domain_for_dev_pasid);
 
-struct iommu_domain *iommu_sva_domain_alloc(struct device *dev,
-					    struct mm_struct *mm)
-{
-	const struct iommu_ops *ops = dev_iommu_ops(dev);
-	struct iommu_domain *domain;
-
-	domain = ops->domain_alloc(IOMMU_DOMAIN_SVA);
-	if (!domain)
-		return NULL;
-
-	domain->type = IOMMU_DOMAIN_SVA;
-	mmgrab(mm);
-	domain->mm = mm;
-	domain->iopf_handler = iommu_sva_handle_iopf;
-	domain->fault_data = mm;
-
-	return domain;
-}
-
 ioasid_t iommu_alloc_global_pasid(struct device *dev)
 {
 	int ret;
diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
index 2b12b583ef4b..e7b87ec525a7 100644
--- a/drivers/iommu/Kconfig
+++ b/drivers/iommu/Kconfig
@@ -158,6 +158,9 @@ config IOMMU_DMA
 config IOMMU_SVA
 	bool
 
+config IOMMU_IOPF
+	bool
+
 config FSL_PAMU
 	bool "Freescale IOMMU support"
 	depends on PCI
@@ -404,6 +407,7 @@ config ARM_SMMU_V3_SVA
 	bool "Shared Virtual Addressing support for the ARM SMMUv3"
 	depends on ARM_SMMU_V3
 	select IOMMU_SVA
+	select IOMMU_IOPF
 	select MMU_NOTIFIER
 	help
 	  Support for sharing process address spaces with devices using the
diff --git a/drivers/iommu/Makefile b/drivers/iommu/Makefile
index 769e43d780ce..6d114fe7ae89 100644
--- a/drivers/iommu/Makefile
+++ b/drivers/iommu/Makefile
@@ -27,6 +27,7 @@ obj-$(CONFIG_FSL_PAMU) += fsl_pamu.o fsl_pamu_domain.o
 obj-$(CONFIG_S390_IOMMU) += s390-iommu.o
 obj-$(CONFIG_HYPERV_IOMMU) += hyperv-iommu.o
 obj-$(CONFIG_VIRTIO_IOMMU) += virtio-iommu.o
-obj-$(CONFIG_IOMMU_SVA) += iommu-sva.o io-pgfault.o
+obj-$(CONFIG_IOMMU_SVA) += iommu-sva.o
+obj-$(CONFIG_IOMMU_IOPF) += io-pgfault.o
 obj-$(CONFIG_SPRD_IOMMU) += sprd-iommu.o
 obj-$(CONFIG_APPLE_DART) += apple-dart.o
diff --git a/drivers/iommu/intel/Kconfig b/drivers/iommu/intel/Kconfig
index 2e56bd79f589..613f149510a7 100644
--- a/drivers/iommu/intel/Kconfig
+++ b/drivers/iommu/intel/Kconfig
@@ -50,6 +50,7 @@ config INTEL_IOMMU_SVM
 	depends on X86_64
 	select MMU_NOTIFIER
 	select IOMMU_SVA
+	select IOMMU_IOPF
 	help
 	  Shared Virtual Memory (SVM) provides a facility for devices
 	  to access DMA resources through process address space by
-- 
2.34.1

