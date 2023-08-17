Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E45D7801E2
	for <lists+kvm@lfdr.de>; Fri, 18 Aug 2023 01:45:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356268AbjHQXod (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Aug 2023 19:44:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356246AbjHQXoT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Aug 2023 19:44:19 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDF062D64;
        Thu, 17 Aug 2023 16:44:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692315857; x=1723851857;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hZYjTxXsSS+GXYTfZtV2nYXNAWLk3xhd7Zw0FlN9HdI=;
  b=bpnM5VkHbX09djaqUypJLmr7E6oLLidtF/ddvb+x49Fz2NY0z7YiMgjs
   MY32xcZ/C/S83Hkdt/1A8rqtxH2P4PMZifIjSljfkDQasMs6SjMlIxuTP
   PMGICzOdGeD6Jdw2Ayql1EvfS8isuCzGyhiweI6maA/Jlermp7gl6qjlq
   tbP6fVhNm/wfhAiDaRGawtUJYP/dlPeZzwuBmz+d/PNK6c65ZYOAhJ6+H
   sxzFCVdYuDrBuG0lpB5jULrIMRdYilos8K5Gbc3iv5xunehfKv2G9w6oy
   cAVgstdq8D4gZZ30PcAZhl35yD/DtNRmEC14X0TFp5mQwHJb0vXLv8QYf
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10805"; a="352552151"
X-IronPort-AV: E=Sophos;i="6.01,181,1684825200"; 
   d="scan'208";a="352552151"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2023 16:44:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10805"; a="849052008"
X-IronPort-AV: E=Sophos;i="6.01,181,1684825200"; 
   d="scan'208";a="849052008"
Received: from allen-box.sh.intel.com ([10.239.159.127])
  by fmsmga002.fm.intel.com with ESMTP; 17 Aug 2023 16:44:11 -0700
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
Subject: [PATCH v3 11/11] iommu: Separate SVA and IOPF in Makefile and Kconfig
Date:   Fri, 18 Aug 2023 07:40:47 +0800
Message-Id: <20230817234047.195194-12-baolu.lu@linux.intel.com>
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

Add CONFIG_IOMMU_IOPF for page fault handling framework and select it
from its real consumer. Move iopf function declaration from iommu-sva.h
to iommu.h and remove iommu-sva.h as it's empty now.

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
---
 include/linux/iommu.h                         | 63 +++++++++++++++
 drivers/iommu/iommu-sva.h                     | 80 -------------------
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   |  1 -
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   |  1 -
 drivers/iommu/intel/iommu.c                   |  1 -
 drivers/iommu/intel/svm.c                     |  1 -
 drivers/iommu/iommu-sva.c                     |  3 +-
 drivers/iommu/iommu.c                         |  2 -
 drivers/iommu/Kconfig                         |  4 +
 drivers/iommu/Makefile                        |  3 +-
 drivers/iommu/intel/Kconfig                   |  1 +
 11 files changed, 71 insertions(+), 89 deletions(-)
 delete mode 100644 drivers/iommu/iommu-sva.h

diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index cf1cb0bb46af..5349e1a9fc12 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -42,6 +42,7 @@ struct iommu_fault_event;
 struct iommu_dma_cookie;
 struct iopf_queue;
 struct iopf_group;
+struct iopf_queue;
 
 #define IOMMU_FAULT_PERM_READ	(1 << 0) /* read */
 #define IOMMU_FAULT_PERM_WRITE	(1 << 1) /* write */
@@ -1284,6 +1285,7 @@ struct iommu_sva *iommu_sva_bind_device(struct device *dev,
 					struct mm_struct *mm);
 void iommu_sva_unbind_device(struct iommu_sva *handle);
 u32 iommu_sva_get_pasid(struct iommu_sva *handle);
+int iommu_sva_handle_iopf_group(struct iopf_group *group);
 #else
 static inline struct iommu_sva *
 iommu_sva_bind_device(struct device *dev, struct mm_struct *mm)
@@ -1302,6 +1304,67 @@ static inline u32 iommu_sva_get_pasid(struct iommu_sva *handle)
 static inline void mm_pasid_init(struct mm_struct *mm) {}
 static inline bool mm_valid_pasid(struct mm_struct *mm) { return false; }
 static inline void mm_pasid_drop(struct mm_struct *mm) {}
+static inline int iommu_sva_handle_iopf_group(struct iopf_group *group)
+{
+	return -ENODEV;
+}
 #endif /* CONFIG_IOMMU_SVA */
 
+#ifdef CONFIG_IOMMU_IOPF
+int iommu_queue_iopf(struct iommu_fault *fault, struct device *dev);
+int iopf_queue_add_device(struct iopf_queue *queue, struct device *dev);
+int iopf_queue_remove_device(struct iopf_queue *queue,
+			     struct device *dev);
+int iopf_queue_flush_dev(struct device *dev);
+struct iopf_queue *iopf_queue_alloc(const char *name);
+void iopf_queue_free(struct iopf_queue *queue);
+int iopf_queue_discard_partial(struct iopf_queue *queue);
+void iopf_free_group(struct iopf_group *group);
+int iopf_queue_work(struct iopf_group *group, work_func_t func);
+#else /* CONFIG_IOMMU_IOPF */
+static inline int iommu_queue_iopf(struct iommu_fault *fault, struct device *dev)
+{
+	return -ENODEV;
+}
+
+static inline int iopf_queue_add_device(struct iopf_queue *queue,
+					struct device *dev)
+{
+	return -ENODEV;
+}
+
+static inline int iopf_queue_remove_device(struct iopf_queue *queue,
+					   struct device *dev)
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
+static inline int iopf_queue_work(struct iopf_group *group, work_func_t func)
+{
+	return -ENODEV;
+}
+#endif /* CONFIG_IOMMU_IOPF */
 #endif /* __LINUX_IOMMU_H */
diff --git a/drivers/iommu/iommu-sva.h b/drivers/iommu/iommu-sva.h
deleted file mode 100644
index cf41e88fac17..000000000000
--- a/drivers/iommu/iommu-sva.h
+++ /dev/null
@@ -1,80 +0,0 @@
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
-void iopf_free_group(struct iopf_group *group);
-int iopf_queue_work(struct iopf_group *group, work_func_t func);
-int iommu_sva_handle_iopf_group(struct iopf_group *group);
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
-static inline void iopf_free_group(struct iopf_group *group)
-{
-}
-
-static inline int iopf_queue_work(struct iopf_group *group, work_func_t func)
-{
-	return -ENODEV;
-}
-
-static inline int iommu_sva_handle_iopf_group(struct iopf_group *group)
-{
-	return -ENODEV;
-}
-#endif /* CONFIG_IOMMU_SVA */
-#endif /* _IOMMU_SVA_H */
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index 7748ee30f8c0..fad7de25d28a 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -10,7 +10,6 @@
 #include <linux/slab.h>
 
 #include "arm-smmu-v3.h"
-#include "../../iommu-sva.h"
 #include "../../io-pgtable-arm.h"
 
 struct arm_smmu_mmu_notifier {
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index e08d2e27a9e5..b78738fc3f0e 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -29,7 +29,6 @@
 
 #include "arm-smmu-v3.h"
 #include "../../dma-iommu.h"
-#include "../../iommu-sva.h"
 
 static bool disable_bypass = true;
 module_param(disable_bypass, bool, 0444);
diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 35839ef69089..bddc060aa615 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -26,7 +26,6 @@
 #include "iommu.h"
 #include "../dma-iommu.h"
 #include "../irq_remapping.h"
-#include "../iommu-sva.h"
 #include "pasid.h"
 #include "cap_audit.h"
 #include "perfmon.h"
diff --git a/drivers/iommu/intel/svm.c b/drivers/iommu/intel/svm.c
index 9fbae9af6615..99b74033fd15 100644
--- a/drivers/iommu/intel/svm.c
+++ b/drivers/iommu/intel/svm.c
@@ -22,7 +22,6 @@
 #include "iommu.h"
 #include "pasid.h"
 #include "perf.h"
-#include "../iommu-sva.h"
 #include "trace.h"
 
 static irqreturn_t prq_event_thread(int irq, void *d);
diff --git a/drivers/iommu/iommu-sva.c b/drivers/iommu/iommu-sva.c
index 2811f34947ab..4cd376227678 100644
--- a/drivers/iommu/iommu-sva.c
+++ b/drivers/iommu/iommu-sva.c
@@ -6,8 +6,7 @@
 #include <linux/mutex.h>
 #include <linux/sched/mm.h>
 #include <linux/iommu.h>
-
-#include "iommu-sva.h"
+#include <linux/mm_types.h>
 
 static DEFINE_MUTEX(iommu_sva_lock);
 
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index c170bcd3f05e..80fef24cf215 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -35,8 +35,6 @@
 
 #include "dma-iommu.h"
 
-#include "iommu-sva.h"
-
 static struct kset *iommu_group_kset;
 static DEFINE_IDA(iommu_group_ida);
 static DEFINE_IDA(iommu_global_pasid_ida);
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

