Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB9D076464C
	for <lists+kvm@lfdr.de>; Thu, 27 Jul 2023 07:54:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232621AbjG0Fyw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jul 2023 01:54:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231704AbjG0Fwu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jul 2023 01:52:50 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8C2B3A99;
        Wed, 26 Jul 2023 22:52:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690437125; x=1721973125;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UfYTL+iIAIu/lHBN66OKbWFgQeOjg6hZYmXp6lBi0UE=;
  b=V3PTXIPXU2unUEUjCT8E5xQTRucugom5VK4lLK79H3W5nmjWSMK2qopD
   odmN7wk7vrxbaxXZwdBHBoSTPTl1e8OepbOy2JGIgKSAPHd6+hkYpx6eW
   qJRVlBfTXToVDjHqirImx0WNxIxRcjONX67I9UdtibOzkyxthMGKiJdNj
   3g274TwoEAXv3Zo7zaTygiKSRZYz0aQlnogj7OBhyyR8XmLBhv9LF6c38
   IGU/1hAekMC7fOKHYlYIwHi/oICJfkOf5jAWnG9FOMMTQ7sFk+zGsYpJj
   rY/Y18cRXbe5sGkbLoo1qCSic0oUfjGer+FldIcdTlPmQrna0FNwhciIF
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10783"; a="399152640"
X-IronPort-AV: E=Sophos;i="6.01,234,1684825200"; 
   d="scan'208";a="399152640"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2023 22:51:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10783"; a="840585327"
X-IronPort-AV: E=Sophos;i="6.01,234,1684825200"; 
   d="scan'208";a="840585327"
Received: from allen-box.sh.intel.com ([10.239.159.127])
  by fmsmga002.fm.intel.com with ESMTP; 26 Jul 2023 22:51:21 -0700
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
Subject: [PATCH v2 11/12] iommu: Separate SVA and IOPF in Makefile and Kconfig
Date:   Thu, 27 Jul 2023 13:48:36 +0800
Message-Id: <20230727054837.147050-12-baolu.lu@linux.intel.com>
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

Add CONFIG_IOMMU_IOPF for page fault handling framework and select it
from its real consumer. Move iopf function declaration from iommu-sva.h
to iommu.h and remove iommu-sva.h as it's empty now.

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
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
index 1dafe031a56c..d725500344a4 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -41,6 +41,7 @@ struct iommu_sva;
 struct iommu_fault_event;
 struct iommu_dma_cookie;
 struct iopf_group;
+struct iopf_queue;
 
 #define IOMMU_FAULT_PERM_READ	(1 << 0) /* read */
 #define IOMMU_FAULT_PERM_WRITE	(1 << 1) /* write */
@@ -1259,6 +1260,7 @@ struct iommu_sva *iommu_sva_bind_device(struct device *dev,
 					struct mm_struct *mm);
 void iommu_sva_unbind_device(struct iommu_sva *handle);
 u32 iommu_sva_get_pasid(struct iommu_sva *handle);
+int iommu_sva_handle_iopf_group(struct iopf_group *group);
 #else
 static inline struct iommu_sva *
 iommu_sva_bind_device(struct device *dev, struct mm_struct *mm)
@@ -1277,6 +1279,67 @@ static inline u32 iommu_sva_get_pasid(struct iommu_sva *handle)
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
index fa8ab9d413f8..003426327e20 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -10,7 +10,6 @@
 #include <linux/slab.h>
 
 #include "arm-smmu-v3.h"
-#include "../../iommu-sva.h"
 #include "../../io-pgtable-arm.h"
 
 struct arm_smmu_mmu_notifier {
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 1a43f904b6b8..cc4223692537 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -29,7 +29,6 @@
 
 #include "arm-smmu-v3.h"
 #include "../../dma-iommu.h"
-#include "../../iommu-sva.h"
 
 static bool disable_bypass = true;
 module_param(disable_bypass, bool, 0444);
diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index e94e833638a7..5a8949d01391 100644
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
index e95b339e9cdc..8d409dcda166 100644
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
index 668f4c2bcf65..3328f00963de 100644
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
 static DEFINE_IDA(iommu_global_pasid_ida);
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 535a36e3edc9..9d964d16d0ad 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -35,8 +35,6 @@
 
 #include "dma-iommu.h"
 
-#include "iommu-sva.h"
-
 static struct kset *iommu_group_kset;
 static DEFINE_IDA(iommu_group_ida);
 
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

