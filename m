Return-Path: <kvm+bounces-1723-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id F084E7EBB8B
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 04:08:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4EB63B20A3D
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 03:08:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B06D73C3D;
	Wed, 15 Nov 2023 03:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NyGfydX+"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1929633D5
	for <kvm@vger.kernel.org>; Wed, 15 Nov 2023 03:07:42 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D344D73;
	Tue, 14 Nov 2023 19:07:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700017641; x=1731553641;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CA6Kny8VTkfBXa91+UCPGoQmMx2wuiGvqsK0qaK31zA=;
  b=NyGfydX+mkHPAN7/gI/HWyAQByuPA+PUKiM+p1OppF3e1jNLmysQQy90
   MvyJg0LKEeaf7kNoFwhpDMhOS1pr87Z3/woS0yvRtWlOK/nKH/a7VlM96
   OQc3MCuSNwcQDqdTJZWQ56oq6t31AYIQjEmDHsJBrx4sjmrucXS39b3dk
   Kml/IY4l/eL4X9WvqxEjhSkN1UqgfoaD1yMI/92nK6XKkUXdmzHYrl9Vs
   eqx6ZyDI9hmXBSepVf5c/thA/vJBobpgn9DegtwtfjYlfETj1gLfwWe2c
   fcuUwMQsbGltNzHWVKNigzU23L5w0hEBNd3E/VEMh4I+1G6zap1vpMVmT
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10894"; a="394715488"
X-IronPort-AV: E=Sophos;i="6.03,303,1694761200"; 
   d="scan'208";a="394715488"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2023 19:07:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10894"; a="1012128889"
X-IronPort-AV: E=Sophos;i="6.03,303,1694761200"; 
   d="scan'208";a="1012128889"
Received: from allen-box.sh.intel.com ([10.239.159.127])
  by fmsmga006.fm.intel.com with ESMTP; 14 Nov 2023 19:07:15 -0800
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
	Yan Zhao <yan.y.zhao@intel.com>,
	iommu@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH v7 10/12] iommu: Separate SVA and IOPF
Date: Wed, 15 Nov 2023 11:02:24 +0800
Message-Id: <20231115030226.16700-11-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231115030226.16700-1-baolu.lu@linux.intel.com>
References: <20231115030226.16700-1-baolu.lu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add CONFIG_IOMMU_IOPF for page fault handling framework and select it
from its real consumer. Move iopf function declaration from iommu-sva.h
to iommu.h and remove iommu-sva.h as it's empty now.

Consolidate all SVA related code into iommu-sva.c:
- Move iommu_sva_domain_alloc() from iommu.c to iommu-sva.c.
- Move sva iopf handling code from io-pgfault.c to iommu-sva.c.

Consolidate iommu_report_device_fault() and iommu_page_response() into
io-pgfault.c.

Export iopf_free_group() and iopf_group_response() for iopf handlers
implemented in modules. Some functions are renamed with more meaningful
names. No other intentional functionality changes.

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Tested-by: Yan Zhao <yan.y.zhao@intel.com>
---
 include/linux/iommu.h                         |  98 ++++++---
 drivers/iommu/iommu-sva.h                     |  69 -------
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   |   1 -
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   |   1 -
 drivers/iommu/intel/iommu.c                   |   1 -
 drivers/iommu/intel/svm.c                     |   1 -
 drivers/iommu/io-pgfault.c                    | 188 +++++++++++++-----
 drivers/iommu/iommu-sva.c                     |  63 +++++-
 drivers/iommu/iommu.c                         | 132 ------------
 drivers/iommu/Kconfig                         |   4 +
 drivers/iommu/Makefile                        |   3 +-
 drivers/iommu/intel/Kconfig                   |   1 +
 12 files changed, 274 insertions(+), 288 deletions(-)
 delete mode 100644 drivers/iommu/iommu-sva.h

diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 96f6f210093e..d19031c1b0e6 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -728,10 +728,6 @@ extern struct iommu_group *iommu_group_get(struct device *dev);
 extern struct iommu_group *iommu_group_ref_get(struct iommu_group *group);
 extern void iommu_group_put(struct iommu_group *group);
 
-extern int iommu_report_device_fault(struct device *dev, struct iopf_fault *evt);
-extern int iommu_page_response(struct device *dev,
-			       struct iommu_page_response *msg);
-
 extern int iommu_group_id(struct iommu_group *group);
 extern struct iommu_domain *iommu_group_default_domain(struct iommu_group *);
 
@@ -944,8 +940,6 @@ bool iommu_group_dma_owner_claimed(struct iommu_group *group);
 int iommu_device_claim_dma_owner(struct device *dev, void *owner);
 void iommu_device_release_dma_owner(struct device *dev);
 
-struct iommu_domain *iommu_sva_domain_alloc(struct device *dev,
-					    struct mm_struct *mm);
 int iommu_attach_device_pasid(struct iommu_domain *domain,
 			      struct device *dev, ioasid_t pasid);
 void iommu_detach_device_pasid(struct iommu_domain *domain,
@@ -1134,18 +1128,6 @@ static inline void iommu_group_put(struct iommu_group *group)
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
@@ -1294,12 +1276,6 @@ static inline int iommu_device_claim_dma_owner(struct device *dev, void *owner)
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
@@ -1421,6 +1397,8 @@ struct iommu_sva *iommu_sva_bind_device(struct device *dev,
 					struct mm_struct *mm);
 void iommu_sva_unbind_device(struct iommu_sva *handle);
 u32 iommu_sva_get_pasid(struct iommu_sva *handle);
+struct iommu_domain *iommu_sva_domain_alloc(struct device *dev,
+					    struct mm_struct *mm);
 #else
 static inline struct iommu_sva *
 iommu_sva_bind_device(struct device *dev, struct mm_struct *mm)
@@ -1439,6 +1417,78 @@ static inline u32 iommu_sva_get_pasid(struct iommu_sva *handle)
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
+int iopf_group_response(struct iopf_group *group,
+			enum iommu_page_response_code status);
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
+
+static inline int iopf_group_response(struct iopf_group *group,
+				      enum iommu_page_response_code status)
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
index 84c9554144cb..c8bdbb9ec8de 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -10,7 +10,6 @@
 #include <linux/slab.h>
 
 #include "arm-smmu-v3.h"
-#include "../../iommu-sva.h"
 #include "../../io-pgtable-arm.h"
 
 struct arm_smmu_mmu_notifier {
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 46780793b743..0c15161bc005 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -29,7 +29,6 @@
 
 #include "arm-smmu-v3.h"
 #include "../../dma-iommu.h"
-#include "../../iommu-sva.h"
 
 static bool disable_bypass = true;
 module_param(disable_bypass, bool, 0444);
diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index cbe65827730d..05490fe21b16 100644
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
index 544653de0d45..3c119bfa1d4a 100644
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
@@ -199,18 +159,117 @@ int iommu_queue_iopf(struct iommu_fault *fault, struct device *dev)
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
@@ -245,6 +304,31 @@ int iopf_queue_flush_dev(struct device *dev)
 }
 EXPORT_SYMBOL_GPL(iopf_queue_flush_dev);
 
+/**
+ * iopf_group_response - Respond a group of page faults
+ * @group: the group of faults with the same group id
+ * @status: the response code
+ *
+ * Return 0 on success and <0 on error.
+ */
+int iopf_group_response(struct iopf_group *group,
+			enum iommu_page_response_code status)
+{
+	struct iopf_fault *iopf = &group->last_fault;
+	struct iommu_page_response resp = {
+		.pasid = iopf->fault.prm.pasid,
+		.grpid = iopf->fault.prm.grpid,
+		.code = status,
+	};
+
+	if ((iopf->fault.prm.flags & IOMMU_FAULT_PAGE_REQUEST_PASID_VALID) &&
+	    (iopf->fault.prm.flags & IOMMU_FAULT_PAGE_RESPONSE_NEEDS_PASID))
+		resp.flags = IOMMU_PAGE_RESP_PASID_VALID;
+
+	return iommu_page_response(group->dev, &resp);
+}
+EXPORT_SYMBOL_GPL(iopf_group_response);
+
 /**
  * iopf_queue_discard_partial - Remove all pending partial fault
  * @queue: the queue whose partial faults need to be discarded
diff --git a/drivers/iommu/iommu-sva.c b/drivers/iommu/iommu-sva.c
index ba0d5b7e106a..f3fbafb50159 100644
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
@@ -202,10 +210,53 @@ iommu_sva_handle_mm(struct iommu_fault *fault, struct mm_struct *mm)
 	return status;
 }
 
-void mm_pasid_drop(struct mm_struct *mm)
+static void iommu_sva_handle_iopf(struct work_struct *work)
 {
-	if (likely(!mm_valid_pasid(mm)))
-		return;
+	struct iopf_fault *iopf;
+	struct iopf_group *group;
+	enum iommu_page_response_code status = IOMMU_PAGE_RESP_SUCCESS;
 
-	iommu_free_global_pasid(mm->pasid);
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
+	iopf_group_response(group, status);
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
index 36b597bb8a09..47ee2b891982 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -36,8 +36,6 @@
 #include "dma-iommu.h"
 #include "iommu-priv.h"
 
-#include "iommu-sva.h"
-
 static struct kset *iommu_group_kset;
 static DEFINE_IDA(iommu_group_ida);
 static DEFINE_IDA(iommu_global_pasid_ida);
@@ -1301,117 +1299,6 @@ void iommu_group_put(struct iommu_group *group)
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
@@ -3437,25 +3324,6 @@ struct iommu_domain *iommu_get_domain_for_dev_pasid(struct device *dev,
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
index 7673bb82945b..4d6291664ca6 100644
--- a/drivers/iommu/Kconfig
+++ b/drivers/iommu/Kconfig
@@ -162,6 +162,9 @@ config IOMMU_DMA
 config IOMMU_SVA
 	bool
 
+config IOMMU_IOPF
+	bool
+
 config FSL_PAMU
 	bool "Freescale IOMMU support"
 	depends on PCI
@@ -397,6 +400,7 @@ config ARM_SMMU_V3_SVA
 	bool "Shared Virtual Addressing support for the ARM SMMUv3"
 	depends on ARM_SMMU_V3
 	select IOMMU_SVA
+	select IOMMU_IOPF
 	select MMU_NOTIFIER
 	help
 	  Support for sharing process address spaces with devices using the
diff --git a/drivers/iommu/Makefile b/drivers/iommu/Makefile
index 95ad9dbfbda0..542760d963ec 100644
--- a/drivers/iommu/Makefile
+++ b/drivers/iommu/Makefile
@@ -26,6 +26,7 @@ obj-$(CONFIG_FSL_PAMU) += fsl_pamu.o fsl_pamu_domain.o
 obj-$(CONFIG_S390_IOMMU) += s390-iommu.o
 obj-$(CONFIG_HYPERV_IOMMU) += hyperv-iommu.o
 obj-$(CONFIG_VIRTIO_IOMMU) += virtio-iommu.o
-obj-$(CONFIG_IOMMU_SVA) += iommu-sva.o io-pgfault.o
+obj-$(CONFIG_IOMMU_SVA) += iommu-sva.o
+obj-$(CONFIG_IOMMU_IOPF) += io-pgfault.o
 obj-$(CONFIG_SPRD_IOMMU) += sprd-iommu.o
 obj-$(CONFIG_APPLE_DART) += apple-dart.o
diff --git a/drivers/iommu/intel/Kconfig b/drivers/iommu/intel/Kconfig
index 012cd2541a68..a4a125666293 100644
--- a/drivers/iommu/intel/Kconfig
+++ b/drivers/iommu/intel/Kconfig
@@ -51,6 +51,7 @@ config INTEL_IOMMU_SVM
 	depends on X86_64
 	select MMU_NOTIFIER
 	select IOMMU_SVA
+	select IOMMU_IOPF
 	help
 	  Shared Virtual Memory (SVM) provides a facility for devices
 	  to access DMA resources through process address space by
-- 
2.34.1


