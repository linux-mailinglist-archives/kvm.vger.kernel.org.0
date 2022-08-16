Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD8D1596125
	for <lists+kvm@lfdr.de>; Tue, 16 Aug 2022 19:29:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236356AbiHPR2m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Aug 2022 13:28:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235928AbiHPR2S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Aug 2022 13:28:18 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E642262C2;
        Tue, 16 Aug 2022 10:28:15 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 819F71424;
        Tue, 16 Aug 2022 10:28:16 -0700 (PDT)
Received: from e121345-lin.cambridge.arm.com (e121345-lin.cambridge.arm.com [10.1.196.40])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 9C2373F67D;
        Tue, 16 Aug 2022 10:28:13 -0700 (PDT)
From:   Robin Murphy <robin.murphy@arm.com>
To:     joro@8bytes.org
Cc:     will@kernel.org, catalin.marinas@arm.com, jean-philippe@linaro.org,
        inki.dae@samsung.com, sw0312.kim@samsung.com,
        kyungmin.park@samsung.com, tglx@linutronix.de, maz@kernel.org,
        alex.williamson@redhat.com, cohuck@redhat.com,
        iommu@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
        linux-acpi@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH 2/3] iommu/dma: Move public interfaces to linux/iommu.h
Date:   Tue, 16 Aug 2022 18:28:04 +0100
Message-Id: <9cd99738f52094e6bed44bfee03fa4f288d20695.1660668998.git.robin.murphy@arm.com>
X-Mailer: git-send-email 2.36.1.dirty
In-Reply-To: <cover.1660668998.git.robin.murphy@arm.com>
References: <cover.1660668998.git.robin.murphy@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The iommu-dma layer is now mostly encapsulated by iommu_dma_ops, with
only a couple more public interfaces left pertaining to MSI integration.
Since these depend on the main IOMMU API header anyway, move their
declarations there, taking the opportunity to update the half-baked
comments to proper kerneldoc along the way.

Signed-off-by: Robin Murphy <robin.murphy@arm.com>
---

Note that iommu_setup_dma_ops() should also become internal in a future
phase of the great IOMMU API upheaval - for now as the last bit of true
arch code glue I consider it more "necessarily exposed" than "public".

 arch/arm64/mm/dma-mapping.c       |  2 +-
 drivers/iommu/dma-iommu.c         | 15 ++++++++++--
 drivers/irqchip/irq-gic-v2m.c     |  2 +-
 drivers/irqchip/irq-gic-v3-its.c  |  2 +-
 drivers/irqchip/irq-gic-v3-mbi.c  |  2 +-
 drivers/irqchip/irq-ls-scfg-msi.c |  2 +-
 drivers/vfio/vfio_iommu_type1.c   |  1 -
 include/linux/dma-iommu.h         | 40 -------------------------------
 include/linux/iommu.h             | 36 ++++++++++++++++++++++++++++
 9 files changed, 54 insertions(+), 48 deletions(-)

diff --git a/arch/arm64/mm/dma-mapping.c b/arch/arm64/mm/dma-mapping.c
index 599cf81f5685..7d7e9a046305 100644
--- a/arch/arm64/mm/dma-mapping.c
+++ b/arch/arm64/mm/dma-mapping.c
@@ -7,7 +7,7 @@
 #include <linux/gfp.h>
 #include <linux/cache.h>
 #include <linux/dma-map-ops.h>
-#include <linux/dma-iommu.h>
+#include <linux/iommu.h>
 #include <xen/xen.h>
 
 #include <asm/cacheflush.h>
diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index 17dd683b2fce..6809b33ac9df 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -1633,6 +1633,13 @@ static struct iommu_dma_msi_page *iommu_dma_get_msi_page(struct device *dev,
 	return NULL;
 }
 
+/**
+ * iommu_dma_prepare_msi() - Map the MSI page in the IOMMU domain
+ * @desc: MSI descriptor, will store the MSI page
+ * @msi_addr: MSI target address to be mapped
+ *
+ * Return: 0 on success or negative error code if the mapping failed.
+ */
 int iommu_dma_prepare_msi(struct msi_desc *desc, phys_addr_t msi_addr)
 {
 	struct device *dev = msi_desc_to_dev(desc);
@@ -1661,8 +1668,12 @@ int iommu_dma_prepare_msi(struct msi_desc *desc, phys_addr_t msi_addr)
 	return 0;
 }
 
-void iommu_dma_compose_msi_msg(struct msi_desc *desc,
-			       struct msi_msg *msg)
+/**
+ * iommu_dma_compose_msi_msg() - Apply translation to an MSI message
+ * @desc: MSI descriptor prepared by iommu_dma_prepare_msi()
+ * @msg: MSI message containing target physical address
+ */
+void iommu_dma_compose_msi_msg(struct msi_desc *desc, struct msi_msg *msg)
 {
 	struct device *dev = msi_desc_to_dev(desc);
 	const struct iommu_domain *domain = iommu_get_domain_for_dev(dev);
diff --git a/drivers/irqchip/irq-gic-v2m.c b/drivers/irqchip/irq-gic-v2m.c
index b249d4df899e..6e1ac330d7a6 100644
--- a/drivers/irqchip/irq-gic-v2m.c
+++ b/drivers/irqchip/irq-gic-v2m.c
@@ -13,7 +13,7 @@
 #define pr_fmt(fmt) "GICv2m: " fmt
 
 #include <linux/acpi.h>
-#include <linux/dma-iommu.h>
+#include <linux/iommu.h>
 #include <linux/irq.h>
 #include <linux/irqdomain.h>
 #include <linux/kernel.h>
diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 5ff09de6c48f..e7d8d4208ee6 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -11,9 +11,9 @@
 #include <linux/cpu.h>
 #include <linux/crash_dump.h>
 #include <linux/delay.h>
-#include <linux/dma-iommu.h>
 #include <linux/efi.h>
 #include <linux/interrupt.h>
+#include <linux/iommu.h>
 #include <linux/iopoll.h>
 #include <linux/irqdomain.h>
 #include <linux/list.h>
diff --git a/drivers/irqchip/irq-gic-v3-mbi.c b/drivers/irqchip/irq-gic-v3-mbi.c
index a2163d32f17d..e1efdec9e9ac 100644
--- a/drivers/irqchip/irq-gic-v3-mbi.c
+++ b/drivers/irqchip/irq-gic-v3-mbi.c
@@ -6,7 +6,7 @@
 
 #define pr_fmt(fmt) "GICv3: " fmt
 
-#include <linux/dma-iommu.h>
+#include <linux/iommu.h>
 #include <linux/irq.h>
 #include <linux/irqdomain.h>
 #include <linux/kernel.h>
diff --git a/drivers/irqchip/irq-ls-scfg-msi.c b/drivers/irqchip/irq-ls-scfg-msi.c
index b4927e425f7b..527c90e0920e 100644
--- a/drivers/irqchip/irq-ls-scfg-msi.c
+++ b/drivers/irqchip/irq-ls-scfg-msi.c
@@ -11,6 +11,7 @@
 #include <linux/module.h>
 #include <linux/msi.h>
 #include <linux/interrupt.h>
+#include <linux/iommu.h>
 #include <linux/irq.h>
 #include <linux/irqchip/chained_irq.h>
 #include <linux/irqdomain.h>
@@ -18,7 +19,6 @@
 #include <linux/of_pci.h>
 #include <linux/of_platform.h>
 #include <linux/spinlock.h>
-#include <linux/dma-iommu.h>
 
 #define MSI_IRQS_PER_MSIR	32
 #define MSI_MSIR_OFFSET		4
diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index c766aa683110..e65861fdba7b 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -37,7 +37,6 @@
 #include <linux/vfio.h>
 #include <linux/workqueue.h>
 #include <linux/notifier.h>
-#include <linux/dma-iommu.h>
 #include <linux/irqdomain.h>
 #include "vfio.h"
 
diff --git a/include/linux/dma-iommu.h b/include/linux/dma-iommu.h
index 24607dc3c2ac..e83de4f1f3d6 100644
--- a/include/linux/dma-iommu.h
+++ b/include/linux/dma-iommu.h
@@ -15,27 +15,10 @@
 
 /* Domain management interface for IOMMU drivers */
 int iommu_get_dma_cookie(struct iommu_domain *domain);
-int iommu_get_msi_cookie(struct iommu_domain *domain, dma_addr_t base);
 void iommu_put_dma_cookie(struct iommu_domain *domain);
 
-/* Setup call for arch DMA mapping code */
-void iommu_setup_dma_ops(struct device *dev, u64 dma_base, u64 dma_limit);
 int iommu_dma_init_fq(struct iommu_domain *domain);
 
-/* The DMA API isn't _quite_ the whole story, though... */
-/*
- * iommu_dma_prepare_msi() - Map the MSI page in the IOMMU device
- *
- * The MSI page will be stored in @desc.
- *
- * Return: 0 on success otherwise an error describing the failure.
- */
-int iommu_dma_prepare_msi(struct msi_desc *desc, phys_addr_t msi_addr);
-
-/* Update the MSI message if required. */
-void iommu_dma_compose_msi_msg(struct msi_desc *desc,
-			       struct msi_msg *msg);
-
 void iommu_dma_get_resv_regions(struct device *dev, struct list_head *list);
 
 void iommu_dma_free_cpu_cached_iovas(unsigned int cpu,
@@ -46,15 +29,8 @@ extern bool iommu_dma_forcedac;
 #else /* CONFIG_IOMMU_DMA */
 
 struct iommu_domain;
-struct msi_desc;
-struct msi_msg;
 struct device;
 
-static inline void iommu_setup_dma_ops(struct device *dev, u64 dma_base,
-				       u64 dma_limit)
-{
-}
-
 static inline int iommu_dma_init_fq(struct iommu_domain *domain)
 {
 	return -EINVAL;
@@ -65,26 +41,10 @@ static inline int iommu_get_dma_cookie(struct iommu_domain *domain)
 	return -ENODEV;
 }
 
-static inline int iommu_get_msi_cookie(struct iommu_domain *domain, dma_addr_t base)
-{
-	return -ENODEV;
-}
-
 static inline void iommu_put_dma_cookie(struct iommu_domain *domain)
 {
 }
 
-static inline int iommu_dma_prepare_msi(struct msi_desc *desc,
-					phys_addr_t msi_addr)
-{
-	return 0;
-}
-
-static inline void iommu_dma_compose_msi_msg(struct msi_desc *desc,
-					     struct msi_msg *msg)
-{
-}
-
 static inline void iommu_dma_get_resv_regions(struct device *dev, struct list_head *list)
 {
 }
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 70393fbb57ed..79cb6eb560a8 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -1059,4 +1059,40 @@ void iommu_debugfs_setup(void);
 static inline void iommu_debugfs_setup(void) {}
 #endif
 
+#ifdef CONFIG_IOMMU_DMA
+#include <linux/msi.h>
+
+/* Setup call for arch DMA mapping code */
+void iommu_setup_dma_ops(struct device *dev, u64 dma_base, u64 dma_limit);
+
+int iommu_get_msi_cookie(struct iommu_domain *domain, dma_addr_t base);
+
+int iommu_dma_prepare_msi(struct msi_desc *desc, phys_addr_t msi_addr);
+void iommu_dma_compose_msi_msg(struct msi_desc *desc, struct msi_msg *msg);
+
+#else /* CONFIG_IOMMU_DMA */
+
+struct msi_desc;
+struct msi_msg;
+
+static inline void iommu_setup_dma_ops(struct device *dev, u64 dma_base, u64 dma_limit)
+{
+}
+
+static inline int iommu_get_msi_cookie(struct iommu_domain *domain, dma_addr_t base)
+{
+	return -ENODEV;
+}
+
+static inline int iommu_dma_prepare_msi(struct msi_desc *desc, phys_addr_t msi_addr)
+{
+	return 0;
+}
+
+static inline void iommu_dma_compose_msi_msg(struct msi_desc *desc, struct msi_msg *msg)
+{
+}
+
+#endif	/* CONFIG_IOMMU_DMA */
+
 #endif /* __LINUX_IOMMU_H */
-- 
2.36.1.dirty

