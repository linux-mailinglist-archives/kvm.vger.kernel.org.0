Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB003331F29
	for <lists+kvm@lfdr.de>; Tue,  9 Mar 2021 07:23:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbhCIGW6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Mar 2021 01:22:58 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:13075 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbhCIGW0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Mar 2021 01:22:26 -0500
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DvlS86Y4MzMkgq;
        Tue,  9 Mar 2021 14:20:08 +0800 (CST)
Received: from DESKTOP-7FEPK9S.china.huawei.com (10.174.184.135) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.498.0; Tue, 9 Mar 2021 14:22:15 +0800
From:   Shenming Lu <lushenming@huawei.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Eric Auger <eric.auger@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <iommu@lists.linux-foundation.org>, <linux-api@vger.kernel.org>
CC:     Kevin Tian <kevin.tian@intel.com>, <yi.l.liu@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Barry Song <song.bao.hua@hisilicon.com>,
        <wanghaibin.wang@huawei.com>, <yuzenghui@huawei.com>,
        <zhukeqian1@huawei.com>, <lushenming@huawei.com>
Subject: [RFC PATCH v2 1/6] iommu: Evolve to support more scenarios of using IOPF
Date:   Tue, 9 Mar 2021 14:22:02 +0800
Message-ID: <20210309062207.505-2-lushenming@huawei.com>
X-Mailer: git-send-email 2.27.0.windows.1
In-Reply-To: <20210309062207.505-1-lushenming@huawei.com>
References: <20210309062207.505-1-lushenming@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.184.135]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch follows the discussion here:

https://lore.kernel.org/linux-acpi/YAaxjmJW+ZMvrhac@myrica/

In order to support more scenarios of using IOPF (mainly consider
the nested extension), besides keeping IOMMU_DEV_FEAT_IOPF as a
general capability for whether delivering faults through the IOMMU,
we extend iommu_register_fault_handler() with flags and introduce
IOPF_REPORT_FLAT and IOPF_REPORT_NESTED to describe the page fault
reporting capability under a specific configuration.
IOPF_REPORT_NESTED needs additional info to indicate which level/stage
is concerned since the fault client may be interested in only one
level.

Signed-off-by: Shenming Lu <lushenming@huawei.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   |  3 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 11 ++--
 drivers/iommu/io-pgfault.c                    |  4 --
 drivers/iommu/iommu.c                         | 56 ++++++++++++++++++-
 include/linux/iommu.h                         | 21 ++++++-
 include/uapi/linux/iommu.h                    |  3 +
 6 files changed, 85 insertions(+), 13 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index ee66d1f4cb81..5de9432349d4 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -482,7 +482,8 @@ static int arm_smmu_master_sva_enable_iopf(struct arm_smmu_master *master)
 	if (ret)
 		return ret;
 
-	ret = iommu_register_device_fault_handler(dev, iommu_queue_iopf, dev);
+	ret = iommu_register_device_fault_handler(dev, iommu_queue_iopf,
+						  IOPF_REPORT_FLAT, dev);
 	if (ret) {
 		iopf_queue_remove_device(master->smmu->evtq.iopf, dev);
 		return ret;
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 363744df8d51..f40529d0075d 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1447,10 +1447,6 @@ static int arm_smmu_handle_evt(struct arm_smmu_device *smmu, u64 *evt)
 		return -EOPNOTSUPP;
 	}
 
-	/* Stage-2 is always pinned at the moment */
-	if (evt[1] & EVTQ_1_S2)
-		return -EFAULT;
-
 	if (evt[1] & EVTQ_1_RnW)
 		perm |= IOMMU_FAULT_PERM_READ;
 	else
@@ -1468,13 +1464,18 @@ static int arm_smmu_handle_evt(struct arm_smmu_device *smmu, u64 *evt)
 			.flags = IOMMU_FAULT_PAGE_REQUEST_LAST_PAGE,
 			.grpid = FIELD_GET(EVTQ_1_STAG, evt[1]),
 			.perm = perm,
-			.addr = FIELD_GET(EVTQ_2_ADDR, evt[2]),
 		};
 
 		if (ssid_valid) {
 			flt->prm.flags |= IOMMU_FAULT_PAGE_REQUEST_PASID_VALID;
 			flt->prm.pasid = FIELD_GET(EVTQ_0_SSID, evt[0]);
 		}
+
+		if (evt[1] & EVTQ_1_S2) {
+			flt->prm.flags |= IOMMU_FAULT_PAGE_REQUEST_L2;
+			flt->prm.addr = FIELD_GET(EVTQ_3_IPA, evt[3]);
+		} else
+			flt->prm.addr = FIELD_GET(EVTQ_2_ADDR, evt[2]);
 	} else {
 		flt->type = IOMMU_FAULT_DMA_UNRECOV;
 		flt->event = (struct iommu_fault_unrecoverable) {
diff --git a/drivers/iommu/io-pgfault.c b/drivers/iommu/io-pgfault.c
index 1df8c1dcae77..abf16e06bcf5 100644
--- a/drivers/iommu/io-pgfault.c
+++ b/drivers/iommu/io-pgfault.c
@@ -195,10 +195,6 @@ int iommu_queue_iopf(struct iommu_fault *fault, void *cookie)
 
 	lockdep_assert_held(&param->lock);
 
-	if (fault->type != IOMMU_FAULT_PAGE_REQ)
-		/* Not a recoverable page fault */
-		return -EOPNOTSUPP;
-
 	/*
 	 * As long as we're holding param->lock, the queue can't be unlinked
 	 * from the device and therefore cannot disappear.
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index d0b0a15dba84..cb1d93b00f7d 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -1056,6 +1056,40 @@ int iommu_group_unregister_notifier(struct iommu_group *group,
 }
 EXPORT_SYMBOL_GPL(iommu_group_unregister_notifier);
 
+/*
+ * iommu_update_device_fault_handler - Update the device fault handler via flags
+ * @dev: the device
+ * @mask: bits(not set) to clear
+ * @set: bits to set
+ *
+ * Update the device fault handler installed by
+ * iommu_register_device_fault_handler().
+ *
+ * Return 0 on success, or an error.
+ */
+int iommu_update_device_fault_handler(struct device *dev, u32 mask, u32 set)
+{
+	struct dev_iommu *param = dev->iommu;
+	int ret = 0;
+
+	if (!param)
+		return -EINVAL;
+
+	mutex_lock(&param->lock);
+
+	if (param->fault_param) {
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+
+	param->fault_param->flags = (param->fault_param->flags & mask) | set;
+
+out_unlock:
+	mutex_unlock(&param->lock);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(iommu_update_device_fault_handler);
+
 /**
  * iommu_register_device_fault_handler() - Register a device fault handler
  * @dev: the device
@@ -1076,11 +1110,14 @@ EXPORT_SYMBOL_GPL(iommu_group_unregister_notifier);
  */
 int iommu_register_device_fault_handler(struct device *dev,
 					iommu_dev_fault_handler_t handler,
-					void *data)
+					u32 flags, void *data)
 {
 	struct dev_iommu *param = dev->iommu;
 	int ret = 0;
 
+	if (flags & IOPF_REPORT_FLAT && flags & IOPF_REPORT_NESTED)
+		return -EINVAL;
+
 	if (!param)
 		return -EINVAL;
 
@@ -1099,6 +1136,7 @@ int iommu_register_device_fault_handler(struct device *dev,
 		goto done_unlock;
 	}
 	param->fault_param->handler = handler;
+	param->fault_param->flags = flags;
 	param->fault_param->data = data;
 	mutex_init(&param->fault_param->lock);
 	INIT_LIST_HEAD(&param->fault_param->faults);
@@ -1177,6 +1215,22 @@ int iommu_report_device_fault(struct device *dev, struct iommu_fault_event *evt)
 		goto done_unlock;
 	}
 
+	/* The unrecoverable fault reporting is not supported at the moment. */
+	if (evt->fault.type != IOMMU_FAULT_PAGE_REQ)
+		return -EOPNOTSUPP;
+
+	if (evt->fault.type == IOMMU_FAULT_PAGE_REQ) {
+		if (fparam->flags & IOPF_REPORT_NESTED) {
+			if (evt->fault.prm.flags & IOMMU_FAULT_PAGE_REQUEST_L2 &&
+			    !(fparam->flags & IOPF_REPORT_NESTED_L2_CONCERNED))
+				return -EOPNOTSUPP;
+			if (!(evt->fault.prm.flags & IOMMU_FAULT_PAGE_REQUEST_L2) &&
+			    !(fparam->flags & IOPF_REPORT_NESTED_L1_CONCERNED))
+				return -EOPNOTSUPP;
+		} else if (!(fparam->flags & IOPF_REPORT_FLAT))
+			return -EOPNOTSUPP;
+	}
+
 	if (evt->fault.type == IOMMU_FAULT_PAGE_REQ &&
 	    (evt->fault.prm.flags & IOMMU_FAULT_PAGE_REQUEST_LAST_PAGE)) {
 		evt_pending = kmemdup(evt, sizeof(struct iommu_fault_event),
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 86d688c4418f..f03d761e8310 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -352,12 +352,21 @@ struct iommu_fault_event {
 /**
  * struct iommu_fault_param - per-device IOMMU fault data
  * @handler: Callback function to handle IOMMU faults at device level
+ * @flags: Indicates whether the fault reporting is available under a
+ *	   specific configuration (1st/2nd-level-only(FLAT), or nested).
+ *	   IOPF_REPORT_NESTED needs to additionally know which level/stage
+ *	   is concerned.
  * @data: handler private data
  * @faults: holds the pending faults which needs response
  * @lock: protect pending faults list
  */
 struct iommu_fault_param {
 	iommu_dev_fault_handler_t handler;
+#define IOPF_REPORT_FLAT			(1 << 0)
+#define IOPF_REPORT_NESTED			(1 << 1)
+#define IOPF_REPORT_NESTED_L1_CONCERNED		(1 << 2)
+#define IOPF_REPORT_NESTED_L2_CONCERNED		(1 << 3)
+	u32 flags;
 	void *data;
 	struct list_head faults;
 	struct mutex lock;
@@ -509,9 +518,11 @@ extern int iommu_group_register_notifier(struct iommu_group *group,
 					 struct notifier_block *nb);
 extern int iommu_group_unregister_notifier(struct iommu_group *group,
 					   struct notifier_block *nb);
+extern int iommu_update_device_fault_handler(struct device *dev,
+					     u32 mask, u32 set);
 extern int iommu_register_device_fault_handler(struct device *dev,
 					iommu_dev_fault_handler_t handler,
-					void *data);
+					u32 flags, void *data);
 
 extern int iommu_unregister_device_fault_handler(struct device *dev);
 
@@ -873,10 +884,16 @@ static inline int iommu_group_unregister_notifier(struct iommu_group *group,
 	return 0;
 }
 
+static inline int iommu_update_device_fault_handler(struct device *dev,
+						    u32 mask, u32 set)
+{
+	return -ENODEV;
+}
+
 static inline
 int iommu_register_device_fault_handler(struct device *dev,
 					iommu_dev_fault_handler_t handler,
-					void *data)
+					u32 flags, void *data)
 {
 	return -ENODEV;
 }
diff --git a/include/uapi/linux/iommu.h b/include/uapi/linux/iommu.h
index e1d9e75f2c94..0ce0dfb7713e 100644
--- a/include/uapi/linux/iommu.h
+++ b/include/uapi/linux/iommu.h
@@ -85,6 +85,8 @@ struct iommu_fault_unrecoverable {
  *         When IOMMU_FAULT_PAGE_RESPONSE_NEEDS_PASID is set, the page response
  *         must have the same PASID value as the page request. When it is clear,
  *         the page response should not have a PASID.
+ *         If IOMMU_FAULT_PAGE_REQUEST_L2 is set, the fault occurred at the
+ *         second level/stage, otherwise, occurred at the first level.
  * @pasid: Process Address Space ID
  * @grpid: Page Request Group Index
  * @perm: requested page permissions (IOMMU_FAULT_PERM_* values)
@@ -96,6 +98,7 @@ struct iommu_fault_page_request {
 #define IOMMU_FAULT_PAGE_REQUEST_LAST_PAGE	(1 << 1)
 #define IOMMU_FAULT_PAGE_REQUEST_PRIV_DATA	(1 << 2)
 #define IOMMU_FAULT_PAGE_RESPONSE_NEEDS_PASID	(1 << 3)
+#define IOMMU_FAULT_PAGE_REQUEST_L2		(1 << 4)
 	__u32	flags;
 	__u32	pasid;
 	__u32	grpid;
-- 
2.19.1

