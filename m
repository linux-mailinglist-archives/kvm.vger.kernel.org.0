Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E7B96FF65A
	for <lists+kvm@lfdr.de>; Thu, 11 May 2023 17:46:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238827AbjEKPph (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 May 2023 11:45:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238809AbjEKPpL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 May 2023 11:45:11 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92EAC65A7;
        Thu, 11 May 2023 08:45:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683819903; x=1715355903;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1cm72Cy6xlAgprevh8lMD1M+IJolhBAjk36Mv4o6NE4=;
  b=kVTHr/ASWwMxS8GyvHXlzs9RHhWGkBumFwNn03EDfyub/tX2bVdLr9IY
   DTo+q35et5u0DY52oy1SIVjap8X/783PWmEHRosBhnFWjYciCBinqJOOH
   5QZKDY2c+LQG+LOICfogMfp9aiVFxFHpLVmGa38+xJ3iC4JoFucmzEFtn
   XiDFSGx5sK9hEa3YBdkDxY8F061rHaAr8ZPgMCDXblrQFKurHD7En6ls+
   WfwaxbOCCYpomVL+mCw1VMKGDqLeOFrJy+1kau9Vd2zn1ECUdYzmCWt5s
   ROgZQY6dXpeHmMEygxjDx5MFqrWpDtKsiyB+NTwuMBRTULnLanMWGA615
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10707"; a="335046696"
X-IronPort-AV: E=Sophos;i="5.99,266,1677571200"; 
   d="scan'208";a="335046696"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2023 08:44:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10707"; a="699776247"
X-IronPort-AV: E=Sophos;i="5.99,266,1677571200"; 
   d="scan'208";a="699776247"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2023 08:44:48 -0700
From:   Reinette Chatre <reinette.chatre@intel.com>
To:     jgg@nvidia.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        alex.williamson@redhat.com
Cc:     tglx@linutronix.de, darwi@linutronix.de, kvm@vger.kernel.org,
        dave.jiang@intel.com, jing2.liu@intel.com, ashok.raj@intel.com,
        fenghua.yu@intel.com, tom.zanussi@linux.intel.com,
        reinette.chatre@intel.com, linux-kernel@vger.kernel.org
Subject: [PATCH V5 10/11] vfio/pci: Support dynamic MSI-X
Date:   Thu, 11 May 2023 08:44:37 -0700
Message-Id: <956c47057ae9fd45591feaa82e9ae20929889249.1683740667.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1683740667.git.reinette.chatre@intel.com>
References: <cover.1683740667.git.reinette.chatre@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
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
Changes since V4:
- Treat pci_irq_vector() returning '0' for Linux IRQ number as kernel
  bug with a WARN. (Kevin)
- Move comment about missing vfio_msi_free_irq() to description of
  vfio_msi_alloc_irq(). (Kevin)
- Add comment at vfio_msi_alloc_irq() call that indicates the allocation
  is maintained until MSI-X disable to explain the absence of its
  release in error path. (Kevin)

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
index 867327e159c1..cbb4bcbfbf83 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -381,27 +381,55 @@ static int vfio_msi_enable(struct vfio_pci_core_device *vdev, int nvec, bool msi
 	return 0;
 }
 
+/*
+ * vfio_msi_alloc_irq() returns the Linux IRQ number of an MSI or MSI-X device
+ * interrupt vector. If a Linux IRQ number is not available then a new
+ * interrupt is allocated if dynamic MSI-X is supported.
+ *
+ * Where is vfio_msi_free_irq()? Allocated interrupts are maintained,
+ * essentially forming a cache that subsequent allocations can draw from.
+ * Interrupts are freed using pci_free_irq_vectors() when MSI/MSI-X is
+ * disabled.
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
+	if (WARN_ON_ONCE(irq == 0))
+		return -EINVAL;
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
@@ -410,6 +438,13 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
 	if (fd < 0)
 		return 0;
 
+	if (irq == -EINVAL) {
+		/* Interrupt stays allocated, will be freed at MSI-X disable. */
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

