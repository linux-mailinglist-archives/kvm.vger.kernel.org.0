Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13C006E6B07
	for <lists+kvm@lfdr.de>; Tue, 18 Apr 2023 19:30:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232563AbjDRR36 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Apr 2023 13:29:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232578AbjDRR3u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Apr 2023 13:29:50 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82A3844BC;
        Tue, 18 Apr 2023 10:29:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681838989; x=1713374989;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=oMfakM0i/B5Q/gryK7ofBQXHR1G72EZy+CSdZ2o9fNM=;
  b=YEuByj/DMj3ZucwxUtZ6luDlPfNjLh/sdQpcehKBest7/o6cArsswcXB
   4EPSNWcIHrAqoOU7l4vQvajKXu6vT6t9cOMKKndKgcfRVicCNBL0lNcak
   flPXaAG0CPInV2FloMeRzIfIjTZa/Y5uXZxhIoBdmgu1NVaDRFy5aYK6U
   ykjJ3+hgYKKxGO5aRtt4kNo7ornnhJUPfU2L4W4AXfcz75uQa9vgB0HrG
   MOcVsD2qccGOewwFf8/jnYF+BEBjxWjqmQG2YvtV2bkbnBNoD0K8dTqaz
   e1TXUcPRMmV8ozioKIxG48kbM0Ak5vaKSGxhFU6Cr5hJnxZxu/tn2/bY3
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10684"; a="410466492"
X-IronPort-AV: E=Sophos;i="5.99,207,1677571200"; 
   d="scan'208";a="410466492"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2023 10:29:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10684"; a="865503494"
X-IronPort-AV: E=Sophos;i="5.99,207,1677571200"; 
   d="scan'208";a="865503494"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2023 10:29:42 -0700
From:   Reinette Chatre <reinette.chatre@intel.com>
To:     jgg@nvidia.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        alex.williamson@redhat.com
Cc:     tglx@linutronix.de, darwi@linutronix.de, kvm@vger.kernel.org,
        dave.jiang@intel.com, jing2.liu@intel.com, ashok.raj@intel.com,
        fenghua.yu@intel.com, tom.zanussi@linux.intel.com,
        reinette.chatre@intel.com, linux-kernel@vger.kernel.org
Subject: [PATCH V3 09/10] vfio/pci: Support dynamic MSI-X
Date:   Tue, 18 Apr 2023 10:29:20 -0700
Message-Id: <86cda5cf2742feff3b14954284fb509863355050.1681837892.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1681837892.git.reinette.chatre@intel.com>
References: <cover.1681837892.git.reinette.chatre@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Recently introduced pci_msix_alloc_irq_at() and pci_msix_free_irq()
enables an individual MSI-X interrupt to be allocated and freed after
MSI-X enabling.

Use dynamic MSI-X (if supported by the device) to allocate an interrupt
after MSI-X is enabled. An MSI-X interrupt is dynamically allocated at
the time a valid eventfd is assigned. This is different behavior from
a range provided during MSI-X enabling where interrupts are allocated
for the entire range whether a valid eventfd is provided for each
interrupt or not.

Do not dynamically free interrupts, leave that to when MSI-X is
disabled.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Link: https://lore.kernel.org/lkml/20230403211841.0e206b67.alex.williamson@redhat.com/
---
The get_cached_msi_msg()/pci_write_msi_msg() behavior is kept
similar to the scenario when MSI-X is enabled with triggers
provided for new interrupts. get_cached_msi_msg()/pci_write_msi_msg()
follows for interrupts recently allocated with pci_msix_alloc_irq_at()
just like get_cached_msi_msg()/pci_write_msi_msg() is done for
interrupts recently allocated with pci_alloc_irq_vectors().

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

 drivers/vfio/pci/vfio_pci_intrs.c | 73 +++++++++++++++++++++++++++----
 1 file changed, 65 insertions(+), 8 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index bdda7f46c2be..c1a3e224c867 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -372,27 +372,74 @@ static int vfio_msi_enable(struct vfio_pci_core_device *vdev, int nvec, bool msi
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
+ * Free interrupt if it can be re-allocated dynamically (while MSI-X
+ * is enabled).
+ */
+static void vfio_msi_free_irq(struct vfio_pci_core_device *vdev,
+			      unsigned int vector, bool msix)
+{
+	struct pci_dev *pdev = vdev->pdev;
+	struct msi_map map;
+	int irq;
+	u16 cmd;
+
+	if (!msix || !vdev->has_dyn_msix)
+		return;
+
+	irq = pci_irq_vector(pdev, vector);
+	map = (struct msi_map) { .index = vector, .virq = irq };
+
+	if (WARN_ON(irq < 0))
+		return;
+
+	cmd = vfio_pci_memory_lock_and_enable(vdev);
+	pci_msix_free_irq(pdev, map);
+	vfio_pci_memory_unlock_and_restore(vdev, cmd);
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
@@ -401,9 +448,17 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
 	if (fd < 0)
 		return 0;
 
+	if (irq == -EINVAL) {
+		irq = vfio_msi_alloc_irq(vdev, vector, msix);
+		if (irq < 0)
+			return irq;
+	}
+
 	ctx = vfio_irq_ctx_alloc(vdev, vector);
-	if (!ctx)
-		return -ENOMEM;
+	if (!ctx) {
+		ret = -ENOMEM;
+		goto out_free_irq;
+	}
 
 	ctx->name = kasprintf(GFP_KERNEL_ACCOUNT, "vfio-msi%s[%d](%s)",
 			      msix ? "x" : "", vector, pci_name(pdev));
@@ -456,6 +511,8 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
 	kfree(ctx->name);
 out_free_ctx:
 	vfio_irq_ctx_free(vdev, ctx, vector);
+out_free_irq:
+	vfio_msi_free_irq(vdev, vector, msix);
 	return ret;
 }
 
-- 
2.34.1

