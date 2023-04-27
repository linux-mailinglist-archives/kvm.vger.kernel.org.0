Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CFCA6F0AF9
	for <lists+kvm@lfdr.de>; Thu, 27 Apr 2023 19:37:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244518AbjD0Rgy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Apr 2023 13:36:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244443AbjD0Rg2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Apr 2023 13:36:28 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 751393A91;
        Thu, 27 Apr 2023 10:36:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682616987; x=1714152987;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Sngpy7QSRRwSxWcsLL2pb0sag7VSeHhyYvrzzFIvniE=;
  b=c43hC4sSIXLnF+iIj3AQkVtVJVcdXEn5QXXgisGepKmg9OIz/S+oqKwz
   /KxR0CtVLT2TudIouddtoLsyi++eMJlB6ug0y1uv7FKSGxw4z2V/zmXd9
   6XcB5lFR6EBkNvSGD+xr39DYBpu5ypQUA0NeavqY6ay0620S2bzrQn7Cm
   q7BDun374/geJXs5bOTZsv/63fEJiWg7sRf3wlm0dCLpRka952ycdPF8m
   welnTj+wPEbBaxHRZtk+lbz8+fXoCNq+Y7OVSYphHAkBLWpopCA33MC7P
   UrJeP6XQDxzt6DktFoBzdpOQmbMWgMAbZiup5YFJfScSPLD9wiZg1YuUi
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10693"; a="349496937"
X-IronPort-AV: E=Sophos;i="5.99,232,1677571200"; 
   d="scan'208";a="349496937"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2023 10:36:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10693"; a="697172998"
X-IronPort-AV: E=Sophos;i="5.99,232,1677571200"; 
   d="scan'208";a="697172998"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2023 10:36:22 -0700
From:   Reinette Chatre <reinette.chatre@intel.com>
To:     jgg@nvidia.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        alex.williamson@redhat.com
Cc:     tglx@linutronix.de, darwi@linutronix.de, kvm@vger.kernel.org,
        dave.jiang@intel.com, jing2.liu@intel.com, ashok.raj@intel.com,
        fenghua.yu@intel.com, tom.zanussi@linux.intel.com,
        reinette.chatre@intel.com, linux-kernel@vger.kernel.org
Subject: [PATCH V4 10/11] vfio/pci: Support dynamic MSI-X
Date:   Thu, 27 Apr 2023 10:36:07 -0700
Message-Id: <c4c582970fbeaf4b6000845c400aa4c6b7bb2f13.1682615447.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1682615447.git.reinette.chatre@intel.com>
References: <cover.1682615447.git.reinette.chatre@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

pci_msix_alloc_irq_at() enables an individual MSI-X interrupt to be
allocated after MSI-X enabling.

Use dynamic MSI-X (if supported by the device) to allocate an interrupt
after MSI-X is enabled. An MSI-X interrupt is dynamically allocated at
the time a valid eventfd is assigned. This is different behavior from
a range provided during MSI-X enabling where interrupts are allocated
for the entire range whether a valid eventfd is provided for each
interrupt or not.

The PCI-MSIX API requires that some number of irqs are allocated for
an initial set of vectors when enabling MSI-X on the device. When
dynamic MSIX allocation is not supported, the vector table, and thus
the allocated irq set can only be resized by disabling and re-enabling
MSI-X with a different range. In that case the irq allocation is
essentially a cache for configuring vectors within the previously
allocated vector range. When dynamic MSI-X allocation is supported,
the API still requires some initial set of irqs to be allocated, but
also supports allocating and freeing specific irq vectors both
within and beyond the initially allocated range.

For consistency between modes, as well as to reduce latency and improve
reliability of allocations, and also simplicity, this implementation
only releases irqs via pci_free_irq_vectors() when either the interrupt
mode changes or the device is released.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Link: https://lore.kernel.org/lkml/20230403211841.0e206b67.alex.williamson@redhat.com/
---
Changes since V3:
- Remove vfio_msi_free_irq(). (Alex)
- Rework changelog. (Alex)

Changes since V2:
- Move vfio_irq_ctx_free() to earlier in series to support
  earlier usage. (Alex)
- Use consistent terms in changelog: MSI-x changed to MSI-X.
- Make dynamic interrupt context creation generic across all
  MSI/MSI-X interrupts. This resulted in code moving to earlier
  in series as part of xarray introduction patch. (Alex)
- Remove the local allow_dyn_alloc and direct calling of
  pci_msix_can_alloc_dyn(), use the new vdev->has_dyn_msix
  introduced earlier instead. (Alex)
- Stop tracking new allocations (remove "new_ctx"). (Alex)
- Introduce new wrapper that returns Linux interrupt number or
  dynamically allocate a new interrupt. Wrapper can be used for
  all interrupt cases. (Alex)
- Only free dynamic MSI-X interrupts on MSI-X teardown. (Alex)

Changes since RFC V1:
- Add pointer to interrupt context as function parameter to
  vfio_irq_ctx_free(). (Alex)
- Initialize new_ctx to false. (Dan Carpenter)
- Only support dynamic allocation if device supports it. (Alex)

 drivers/vfio/pci/vfio_pci_intrs.c | 47 +++++++++++++++++++++++++++----
 1 file changed, 41 insertions(+), 6 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index bdda7f46c2be..8340135b09fa 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -372,27 +372,56 @@ static int vfio_msi_enable(struct vfio_pci_core_device *vdev, int nvec, bool msi
 	return 0;
 }
 
+/*
+ * Return Linux IRQ number of an MSI or MSI-X device interrupt vector.
+ * If a Linux IRQ number is not available then a new interrupt will be
+ * allocated if dynamic MSI-X is supported.
+ */
+static int vfio_msi_alloc_irq(struct vfio_pci_core_device *vdev,
+			      unsigned int vector, bool msix)
+{
+	struct pci_dev *pdev = vdev->pdev;
+	struct msi_map map;
+	int irq;
+	u16 cmd;
+
+	irq = pci_irq_vector(pdev, vector);
+	if (irq > 0 || !msix || !vdev->has_dyn_msix)
+		return irq;
+
+	cmd = vfio_pci_memory_lock_and_enable(vdev);
+	map = pci_msix_alloc_irq_at(pdev, vector, NULL);
+	vfio_pci_memory_unlock_and_restore(vdev, cmd);
+
+	return map.index < 0 ? map.index : map.virq;
+}
+
+/*
+ * Where is vfio_msi_free_irq() ?
+ *
+ * Allocated interrupts are maintained, essentially forming a cache that
+ * subsequent allocations can draw from. Interrupts are freed using
+ * pci_free_irq_vectors() when MSI/MSI-X is disabled.
+ */
+
 static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
 				      unsigned int vector, int fd, bool msix)
 {
 	struct pci_dev *pdev = vdev->pdev;
 	struct vfio_pci_irq_ctx *ctx;
 	struct eventfd_ctx *trigger;
-	int irq, ret;
+	int irq = -EINVAL, ret;
 	u16 cmd;
 
-	irq = pci_irq_vector(pdev, vector);
-	if (irq < 0)
-		return -EINVAL;
-
 	ctx = vfio_irq_ctx_get(vdev, vector);
 
 	if (ctx) {
 		irq_bypass_unregister_producer(&ctx->producer);
-
+		irq = pci_irq_vector(pdev, vector);
 		cmd = vfio_pci_memory_lock_and_enable(vdev);
 		free_irq(irq, ctx->trigger);
 		vfio_pci_memory_unlock_and_restore(vdev, cmd);
+		/* Interrupt stays allocated, will be freed at MSI-X disable. */
 		kfree(ctx->name);
 		eventfd_ctx_put(ctx->trigger);
 		vfio_irq_ctx_free(vdev, ctx, vector);
@@ -401,6 +430,12 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
 	if (fd < 0)
 		return 0;
 
+	if (irq == -EINVAL) {
+		irq = vfio_msi_alloc_irq(vdev, vector, msix);
+		if (irq < 0)
+			return irq;
+	}
+
 	ctx = vfio_irq_ctx_alloc(vdev, vector);
 	if (!ctx)
 		return -ENOMEM;
-- 
2.34.1

