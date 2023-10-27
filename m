Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5C027D9E7C
	for <lists+kvm@lfdr.de>; Fri, 27 Oct 2023 19:02:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346377AbjJ0RCK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Oct 2023 13:02:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346225AbjJ0RBn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Oct 2023 13:01:43 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D51CCD4C;
        Fri, 27 Oct 2023 10:01:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698426097; x=1729962097;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dCYNGaS6u8lNWArc0rXK+9yXFKPwyzJs8u5KXSyF0Rc=;
  b=B0qa6+aRaZkEUOAng/x41z/x4Ib8d89tIVRrswwYFYSnHFlRExkpZQ14
   ydJPDIQvjHRBZLneZPhJxUxHdZltWqBqOnJ/x1jeLeTOLanXPOUyYZCuB
   uZ1QwcRJ4d3kbTEiwuBqGIsCsLb6jkKuMFd1OR5PWt64f4vnKPrsA+c40
   v6YdTMm+eAteZyNh0egUXJd4uNWMkQvMqpzn/HVoiIT4fo0h6QkrzD1Vk
   PoYD93vZy2MMSCWCLTAD3oqdmpggTgxRdxfjWXL67RhD0R3t+IxAXd+tE
   bYeYqBi2qOIYIGnxTB8ARo07BgPT/hb/cxVPADLwMMlzBXKGh/5vJFf4C
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10876"; a="612064"
X-IronPort-AV: E=Sophos;i="6.03,256,1694761200"; 
   d="scan'208";a="612064"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2023 10:01:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10876"; a="1090988215"
X-IronPort-AV: E=Sophos;i="6.03,256,1694761200"; 
   d="scan'208";a="1090988215"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2023 10:01:18 -0700
From:   Reinette Chatre <reinette.chatre@intel.com>
To:     jgg@nvidia.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        alex.williamson@redhat.com
Cc:     kvm@vger.kernel.org, dave.jiang@intel.com, jing2.liu@intel.com,
        ashok.raj@intel.com, fenghua.yu@intel.com,
        tom.zanussi@linux.intel.com, reinette.chatre@intel.com,
        linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: [RFC PATCH V3 18/26] vfio/pci: Preserve per-interrupt contexts
Date:   Fri, 27 Oct 2023 10:00:50 -0700
Message-Id: <12630e207092c11a69efe691a9273abcef831c18.1698422237.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1698422237.git.reinette.chatre@intel.com>
References: <cover.1698422237.git.reinette.chatre@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Interrupt management for PCI passthrough devices create a new
per-interrupt context every time an interrupt is allocated, freeing
it when the interrupt is freed.

The per-interrupt context contains the properties of a particular
interrupt. Without a property that guides interrupt allocation and
free it is acceptable to always create a new per-interrupt context.

Maintain per-interrupt context across interrupt allocate and free
events in preparation for per-interrupt properties that guide
interrupt allocation and free. Examples of such properties are:
(a) whether the interrupt is emulated or not, which guides whether
the backend should indeed allocate and/or free an interrupt, (b)
an instance cookie associated with the interrupt that needs to be
provided to interrupt allocation when the interrupt is backed by IMS.

This means that existence of per-interrupt context no longer implies
a valid trigger, pointers to freed memory should be cleared, and a new
per-interrupt context cannot be assumed needing allocation when an
interrupt is allocated.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
Changes since RFC V2:
- New patch

 drivers/vfio/pci/vfio_pci_intrs.c | 41 ++++++++++++++++++++++---------
 1 file changed, 29 insertions(+), 12 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 80040fde6f6b..8d84e7d62594 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -429,7 +429,7 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_intr_ctx *intr_ctx,
 
 	ctx = vfio_irq_ctx_get(intr_ctx, vector);
 
-	if (ctx) {
+	if (ctx && ctx->trigger) {
 		irq_bypass_unregister_producer(&ctx->producer);
 		irq = pci_irq_vector(pdev, vector);
 		cmd = vfio_pci_memory_lock_and_enable(vdev);
@@ -437,8 +437,9 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_intr_ctx *intr_ctx,
 		vfio_pci_memory_unlock_and_restore(vdev, cmd);
 		/* Interrupt stays allocated, will be freed at MSI-X disable. */
 		kfree(ctx->name);
+		ctx->name = NULL;
 		eventfd_ctx_put(ctx->trigger);
-		vfio_irq_ctx_free(intr_ctx, ctx, vector);
+		ctx->trigger = NULL;
 	}
 
 	if (fd < 0)
@@ -451,16 +452,17 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_intr_ctx *intr_ctx,
 			return irq;
 	}
 
-	ctx = vfio_irq_ctx_alloc(intr_ctx, vector);
-	if (!ctx)
-		return -ENOMEM;
+	/* Per-interrupt context remain allocated. */
+	if (!ctx) {
+		ctx = vfio_irq_ctx_alloc(intr_ctx, vector);
+		if (!ctx)
+			return -ENOMEM;
+	}
 
 	ctx->name = kasprintf(GFP_KERNEL_ACCOUNT, "vfio-msi%s[%d](%s)",
 			      msix ? "x" : "", vector, pci_name(pdev));
-	if (!ctx->name) {
-		ret = -ENOMEM;
-		goto out_free_ctx;
-	}
+	if (!ctx->name)
+		return -ENOMEM;
 
 	trigger = eventfd_ctx_fdget(fd);
 	if (IS_ERR(trigger)) {
@@ -504,8 +506,7 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_intr_ctx *intr_ctx,
 	eventfd_ctx_put(trigger);
 out_free_name:
 	kfree(ctx->name);
-out_free_ctx:
-	vfio_irq_ctx_free(intr_ctx, ctx, vector);
+	ctx->name = NULL;
 	return ret;
 }
 
@@ -704,7 +705,7 @@ static int vfio_pci_set_msi_trigger(struct vfio_pci_intr_ctx *intr_ctx,
 
 	for (i = start; i < start + count; i++) {
 		ctx = vfio_irq_ctx_get(intr_ctx, i);
-		if (!ctx)
+		if (!ctx || !ctx->trigger)
 			continue;
 		if (flags & VFIO_IRQ_SET_DATA_NONE) {
 			eventfd_signal(ctx->trigger, 1);
@@ -810,6 +811,22 @@ static void _vfio_pci_init_intr_ctx(struct vfio_pci_intr_ctx *intr_ctx)
 
 static void _vfio_pci_release_intr_ctx(struct vfio_pci_intr_ctx *intr_ctx)
 {
+	struct vfio_pci_irq_ctx *ctx;
+	unsigned long i;
+
+	/*
+	 * Per-interrupt context remains allocated after interrupt is
+	 * freed. Per-interrupt context need to be freed separately.
+	 */
+	mutex_lock(&intr_ctx->igate);
+	xa_for_each(&intr_ctx->ctx, i, ctx) {
+		WARN_ON_ONCE(ctx->trigger);
+		WARN_ON_ONCE(ctx->name);
+		xa_erase(&intr_ctx->ctx, i);
+		kfree(ctx);
+	}
+	mutex_unlock(&intr_ctx->igate);
+
 	mutex_destroy(&intr_ctx->igate);
 }
 
-- 
2.34.1

