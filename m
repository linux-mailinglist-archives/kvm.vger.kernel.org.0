Return-Path: <kvm+bounces-7804-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E3BA1846741
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 06:00:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 149E71C2637E
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 05:00:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B5FD1863B;
	Fri,  2 Feb 2024 04:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="C1deUzSI"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6909817589;
	Fri,  2 Feb 2024 04:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706849855; cv=none; b=kZKviJM1ssHtqE0QOYkSjRoux4YvURB6kmXCN40FezkUawvwDgO35skyZOF5OL0+EAJbNMrtEEOX1ErHmRh4UaoxrnM1QwdfzjXeyB+kwC22ZibSzG01kyRWpvH7sFjIIZrwPoCX6mt8omCYDrlCAm5kXVrohZuTBpSan90lj04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706849855; c=relaxed/simple;
	bh=hPTVpULSZEGp+qlRQ7yydOeKGAslemxYjjTwBe0NPao=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=T0x4YZ9TaOiAQtHPCulHJQbKIELkN0hIP+YtniNyjj9LUZUx/Ql4er5GQIqLWYD/ngXTfmN4rMtlRhudq9CtMbfL1SzBuzQpQ/+r5bCK5QKLhMuQMT3YPm/FC9QyGmhcEnNTMOFFHgmY3mAeRq8OIsGTBnJ6MdjZJelgCm2KExY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=C1deUzSI; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706849854; x=1738385854;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hPTVpULSZEGp+qlRQ7yydOeKGAslemxYjjTwBe0NPao=;
  b=C1deUzSI5rrujqcoF2dIGoBuWU1jD/6bAhBMdd/Eu15ipU1sopLF73KI
   uG4A1ldnxqnG6Tvhdb5nGOqgUnzqx+rmRQ8ZeIxwkSsIA9lyHEP2/HD2H
   ovHHri4FeZ29vhvyNZaY/mGUn/7PbqXjCfRyrw2xoGLDEQUtU8OscwBvj
   zuC4D5RL6RT/2EFLD8mWL9KS4l1EURmZpFFJJRIYyxrS+PHKc1ThxlH0e
   vVCaC3XKm8VYcmdW1yPH2dZHDjL/Fr/5SHHMH4B2whLlqlskUe+dxinsI
   52IagxZcYw1ptS/5d9SG1/L2LFHi5lovXSTxbpCmMZ6Ntk2qurKol/ryr
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10971"; a="17615834"
X-IronPort-AV: E=Sophos;i="6.05,237,1701158400"; 
   d="scan'208";a="17615834"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2024 20:57:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10971"; a="912339780"
X-IronPort-AV: E=Sophos;i="6.05,237,1701158400"; 
   d="scan'208";a="912339780"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2024 20:57:24 -0800
From: Reinette Chatre <reinette.chatre@intel.com>
To: jgg@nvidia.com,
	yishaih@nvidia.com,
	shameerali.kolothum.thodi@huawei.com,
	kevin.tian@intel.com,
	alex.williamson@redhat.com
Cc: kvm@vger.kernel.org,
	dave.jiang@intel.com,
	ashok.raj@intel.com,
	reinette.chatre@intel.com,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH 08/17] vfio/pci: Extract MSI/MSI-X specific code from common flow
Date: Thu,  1 Feb 2024 20:57:02 -0800
Message-Id: <79aec9a35a494dcd11be059021a3c4c3f4f74b40.1706849424.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1706849424.git.reinette.chatre@intel.com>
References: <cover.1706849424.git.reinette.chatre@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

vfio_intx_set_signal() and vfio_msi_set_signal() have similar code
flow mixed with actions specific to the interrupt type.

Code that is similar between MSI, MSI-X, and INTx management can
be shared instead of duplicated. Start by replacing the MSI/MSI-X
specific code within vfio_msi_set_signal() with functions. These
functions that are specific to the management of MSI/MSI-X can
later be called from a shared flow.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
Note to maintainers:
This is similar to "vfio/pci: Separate frontend and backend code during
interrupt enable/disable" that was submitted as part of IMS changes,
but is not specific to IMS.
https://lore.kernel.org/lkml/cover.1696609476.git.reinette.chatre@intel.com

 drivers/vfio/pci/vfio_pci_intrs.c | 134 ++++++++++++++++++++----------
 1 file changed, 89 insertions(+), 45 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 7ca2b983b66e..70f2382c9c0c 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -414,26 +414,99 @@ static int vfio_msi_alloc_irq(struct vfio_pci_core_device *vdev,
 	return map.index < 0 ? map.index : map.virq;
 }
 
+static void vfio_msi_free_interrupt(struct vfio_pci_core_device *vdev,
+				    struct vfio_pci_irq_ctx *ctx,
+				    unsigned int vector)
+{
+	struct pci_dev *pdev = vdev->pdev;
+	int irq;
+	u16 cmd;
+
+	irq = pci_irq_vector(pdev, vector);
+	cmd = vfio_pci_memory_lock_and_enable(vdev);
+	free_irq(irq, ctx->trigger);
+	vfio_pci_memory_unlock_and_restore(vdev, cmd);
+	/*Interrupt stays allocated, will be freed at MSI/MSI-X disable. */
+}
+
+static int vfio_msi_request_interrupt(struct vfio_pci_core_device *vdev,
+				      struct vfio_pci_irq_ctx *ctx,
+				      unsigned int vector, unsigned int index)
+{
+	bool msix = (index == VFIO_PCI_MSIX_IRQ_INDEX) ? true : false;
+	int irq, ret;
+	u16 cmd;
+
+	irq = vfio_msi_alloc_irq(vdev, vector, msix);
+	if (irq < 0)
+		return irq;
+
+	/*
+	 * If the vector was previously allocated, refresh the on-device
+	 * message data before enabling in case it had been cleared or
+	 * corrupted (e.g. due to backdoor resets) since writing.
+	 */
+	cmd = vfio_pci_memory_lock_and_enable(vdev);
+	if (msix) {
+		struct msi_msg msg;
+
+		get_cached_msi_msg(irq, &msg);
+		pci_write_msi_msg(irq, &msg);
+	}
+
+	ret = request_irq(irq, vfio_msihandler, 0, ctx->name, ctx->trigger);
+	vfio_pci_memory_unlock_and_restore(vdev, cmd);
+
+	return ret;
+}
+
+static char *vfio_msi_device_name(struct vfio_pci_core_device *vdev,
+				  unsigned int vector, unsigned int index)
+{
+	struct pci_dev *pdev = vdev->pdev;
+
+	return kasprintf(GFP_KERNEL_ACCOUNT, "vfio-msi%s[%d](%s)",
+			 index == VFIO_PCI_MSIX_IRQ_INDEX ? "x" : "",
+			 vector, pci_name(pdev));
+}
+
+static void vfio_msi_register_producer(struct vfio_pci_core_device *vdev,
+				       struct vfio_pci_irq_ctx *ctx,
+				       unsigned int vector)
+{
+	struct pci_dev *pdev = vdev->pdev;
+	int ret;
+
+	ctx->producer.token = ctx->trigger;
+	ctx->producer.irq = pci_irq_vector(pdev, vector);
+	ret = irq_bypass_register_producer(&ctx->producer);
+	if (unlikely(ret)) {
+		dev_info(&pdev->dev,
+			 "irq bypass producer (token %p) registration fails: %d\n",
+			 ctx->producer.token, ret);
+		ctx->producer.token = NULL;
+		ctx->producer.irq = 0;
+	}
+}
+
+static void vfio_msi_unregister_producer(struct vfio_pci_irq_ctx *ctx)
+{
+	irq_bypass_unregister_producer(&ctx->producer);
+}
+
 static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
 				      unsigned int vector, int fd,
 				      unsigned int index)
 {
-	bool msix = (index == VFIO_PCI_MSIX_IRQ_INDEX) ? true : false;
-	struct pci_dev *pdev = vdev->pdev;
 	struct vfio_pci_irq_ctx *ctx;
 	struct eventfd_ctx *trigger;
-	int irq = -EINVAL, ret;
-	u16 cmd;
+	int ret;
 
 	ctx = vfio_irq_ctx_get(vdev, vector);
 
 	if (ctx && ctx->trigger) {
-		irq_bypass_unregister_producer(&ctx->producer);
-		irq = pci_irq_vector(pdev, vector);
-		cmd = vfio_pci_memory_lock_and_enable(vdev);
-		free_irq(irq, ctx->trigger);
-		vfio_pci_memory_unlock_and_restore(vdev, cmd);
-		/* Interrupt stays allocated, will be freed at MSI-X disable. */
+		vfio_msi_unregister_producer(ctx);
+		vfio_msi_free_interrupt(vdev, ctx, vector);
 		kfree(ctx->name);
 		ctx->name = NULL;
 		eventfd_ctx_put(ctx->trigger);
@@ -443,13 +516,6 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
 	if (fd < 0)
 		return 0;
 
-	if (irq == -EINVAL) {
-		/* Interrupt stays allocated, will be freed at MSI-X disable. */
-		irq = vfio_msi_alloc_irq(vdev, vector, msix);
-		if (irq < 0)
-			return irq;
-	}
-
 	/* Per-interrupt context remain allocated. */
 	if (!ctx) {
 		ctx = vfio_irq_ctx_alloc(vdev, vector);
@@ -457,8 +523,7 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
 			return -ENOMEM;
 	}
 
-	ctx->name = kasprintf(GFP_KERNEL_ACCOUNT, "vfio-msi%s[%d](%s)",
-			      msix ? "x" : "", vector, pci_name(pdev));
+	ctx->name = vfio_msi_device_name(vdev, vector, index);
 	if (!ctx->name)
 		return -ENOMEM;
 
@@ -468,40 +533,19 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
 		goto out_free_name;
 	}
 
-	/*
-	 * If the vector was previously allocated, refresh the on-device
-	 * message data before enabling in case it had been cleared or
-	 * corrupted (e.g. due to backdoor resets) since writing.
-	 */
-	cmd = vfio_pci_memory_lock_and_enable(vdev);
-	if (msix) {
-		struct msi_msg msg;
-
-		get_cached_msi_msg(irq, &msg);
-		pci_write_msi_msg(irq, &msg);
-	}
+	ctx->trigger = trigger;
 
-	ret = request_irq(irq, vfio_msihandler, 0, ctx->name, trigger);
-	vfio_pci_memory_unlock_and_restore(vdev, cmd);
+	ret = vfio_msi_request_interrupt(vdev, ctx, vector, index);
 	if (ret)
 		goto out_put_eventfd_ctx;
 
-	ctx->producer.token = trigger;
-	ctx->producer.irq = irq;
-	ret = irq_bypass_register_producer(&ctx->producer);
-	if (unlikely(ret)) {
-		dev_info(&pdev->dev,
-		"irq bypass producer (token %p) registration fails: %d\n",
-		ctx->producer.token, ret);
-
-		ctx->producer.token = NULL;
-	}
-	ctx->trigger = trigger;
+	vfio_msi_register_producer(vdev, ctx, vector);
 
 	return 0;
 
 out_put_eventfd_ctx:
-	eventfd_ctx_put(trigger);
+	eventfd_ctx_put(ctx->trigger);
+	ctx->trigger = NULL;
 out_free_name:
 	kfree(ctx->name);
 	ctx->name = NULL;
-- 
2.34.1


