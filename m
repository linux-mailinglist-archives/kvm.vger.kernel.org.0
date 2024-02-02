Return-Path: <kvm+bounces-7809-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CC50884674C
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 06:01:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 37D1F1F23696
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 05:01:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E86DF2943F;
	Fri,  2 Feb 2024 04:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TRPBhh8h"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3216A182D4;
	Fri,  2 Feb 2024 04:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706849859; cv=none; b=qiflQxr7kNAkOKh+lSr1wtZaO9cOrKxInGD7xDSRYIifYMUJRPoJoHfX2lRvu9l8NTFNXW4DZ15vgaC/LwJlsw7DAlqhs7bQBdw4K1VHsZRDjym/0j4QJCC2SuXhAuyZHW+H371b2sP+1CDg+3fMuCQTBGJycu9CPwON2VUZQg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706849859; c=relaxed/simple;
	bh=j7fvY/2gZZFN9ycFck7Q2a4mMpEwf8X0nASlEstU/wQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Ijdcj7KlvoyMKgmkXw9RNdv/vG0x9kABH5vZDdSsY+044DdkZFaFMSNAEzDeNr1YzsDSFOKb7oo4RaW3Qe6fyYo6oWqXhWrhB9Ig9BT7JBZqFZP+81k4BsiEd6pie/iWBncyCQ3b7mz97CBOyvKLBa0zNai0K6wcDOegMlel3po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TRPBhh8h; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706849856; x=1738385856;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=j7fvY/2gZZFN9ycFck7Q2a4mMpEwf8X0nASlEstU/wQ=;
  b=TRPBhh8hVWlGV3pVkqhREqPlwYQoEnaoYL57eSL30nFAo//s+AfSb5Un
   h6z9VeDM44LX7ct0u7KKB35V0pUjAKojZ6ssRcKzzyYi+0UwSHEf9+OXH
   WhCds5Fi1nVYQ/o56Tv6CFelvyPH0TWgMgEXVsVBtm21wASFiGmlDE3RQ
   Wry9JsrCWQDr+yDo69SPJETMGWNZKKgXr95Wm6UbrSizmKA5Nj48xVPk1
   kCBG+CYf+oiqNNQ8beymRHW9+9GqAogK44A6lahm3FUrtWga1i1Jn7C+R
   iyfLIbegFFzLxMEWmv2057ucC43+L+IAo7iIaxY8cySA60GpvqNl/Deso
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10971"; a="17615858"
X-IronPort-AV: E=Sophos;i="6.05,237,1701158400"; 
   d="scan'208";a="17615858"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2024 20:57:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10971"; a="912339794"
X-IronPort-AV: E=Sophos;i="6.05,237,1701158400"; 
   d="scan'208";a="912339794"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2024 20:57:25 -0800
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
Subject: [PATCH 13/17] vfio/pci: Remove vfio_intx_set_signal()
Date: Thu,  1 Feb 2024 20:57:07 -0800
Message-Id: <c6ce51e7e588cb3f6ceb732fd59f55c8e72fdf17.1706849424.git.reinette.chatre@intel.com>
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

The interrupt management flow of vfio_intx_set_signal() is available
from the now generic vfio_irq_set_signal().

Initialize the INTx specific management ops so that vfio_irq_set_signal()
can be used to manage INTx interrupts and point all existing
INTx specific interrupt management calls to vfio_irq_set_signal().

Use vfio_irq_set_block() within vfio_pci_set_intx_trigger() to
highlight its similarities with vfio_pci_set_msi_trigger() for the
next stage of uniting the interrupt management code.
vfio_pci_set_intx_trigger() ensures that start == 0 and count == 1
before vfio_irq_set_block() is called so the loop within it is
essentially a direct call to vfio_irq_set_vector_signal().

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/vfio/pci/vfio_pci_intrs.c | 62 +++++++------------------------
 1 file changed, 13 insertions(+), 49 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 7f9dc81cb97f..d7c2cd739d74 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -46,6 +46,10 @@ struct vfio_pci_intr_ops {
 	void (*unregister_producer)(struct vfio_pci_irq_ctx *ctx);
 };
 
+static int vfio_irq_set_vector_signal(struct vfio_pci_core_device *vdev,
+				      unsigned int vector, int fd,
+				      unsigned int index);
+
 static bool irq_is(struct vfio_pci_core_device *vdev, int type)
 {
 	return vdev->irq_type == type;
@@ -321,51 +325,6 @@ static char *vfio_intx_device_name(struct vfio_pci_core_device *vdev,
 	return kasprintf(GFP_KERNEL_ACCOUNT, "vfio-intx(%s)", pci_name(pdev));
 }
 
-static int vfio_intx_set_signal(struct vfio_pci_core_device *vdev,
-				unsigned int vector, int fd,
-				unsigned int index)
-{
-	struct vfio_pci_irq_ctx *ctx;
-	struct eventfd_ctx *trigger;
-	int ret;
-
-	ctx = vfio_irq_ctx_get(vdev, 0);
-	if (WARN_ON_ONCE(!ctx))
-		return -EINVAL;
-
-	if (ctx->trigger) {
-		vfio_intx_free_interrupt(vdev, ctx, vector);
-		kfree(ctx->name);
-		eventfd_ctx_put(ctx->trigger);
-		ctx->trigger = NULL;
-	}
-
-	if (fd < 0) /* Disable only */
-		return 0;
-
-	ctx->name = vfio_intx_device_name(vdev, vector, index);
-	if (!ctx->name)
-		return -ENOMEM;
-
-	trigger = eventfd_ctx_fdget(fd);
-	if (IS_ERR(trigger)) {
-		kfree(ctx->name);
-		return PTR_ERR(trigger);
-	}
-
-	ctx->trigger = trigger;
-
-	ret = vfio_intx_request_interrupt(vdev, ctx, vector, index);
-	if (ret) {
-		ctx->trigger = NULL;
-		kfree(ctx->name);
-		eventfd_ctx_put(trigger);
-		return ret;
-	}
-
-	return 0;
-}
-
 static void vfio_intx_disable(struct vfio_pci_core_device *vdev)
 {
 	struct vfio_pci_irq_ctx *ctx;
@@ -376,7 +335,7 @@ static void vfio_intx_disable(struct vfio_pci_core_device *vdev)
 		vfio_virqfd_disable(&ctx->unmask);
 		vfio_virqfd_disable(&ctx->mask);
 	}
-	vfio_intx_set_signal(vdev, 0, -1, VFIO_PCI_INTX_IRQ_INDEX);
+	vfio_irq_set_vector_signal(vdev, 0, -1, VFIO_PCI_INTX_IRQ_INDEX);
 	vdev->irq_type = VFIO_PCI_NUM_IRQS;
 	vfio_irq_ctx_free(vdev, ctx, 0);
 }
@@ -541,6 +500,11 @@ static void vfio_msi_unregister_producer(struct vfio_pci_irq_ctx *ctx)
 }
 
 static struct vfio_pci_intr_ops intr_ops[] = {
+	[VFIO_PCI_INTX_IRQ_INDEX] = {
+		.request_interrupt = vfio_intx_request_interrupt,
+		.free_interrupt = vfio_intx_free_interrupt,
+		.device_name = vfio_intx_device_name,
+	},
 	[VFIO_PCI_MSI_IRQ_INDEX] = {
 		.request_interrupt = vfio_msi_request_interrupt,
 		.free_interrupt = vfio_msi_free_interrupt,
@@ -735,17 +699,17 @@ static int vfio_pci_set_intx_trigger(struct vfio_pci_core_device *vdev,
 		return -EINVAL;
 
 	if (flags & VFIO_IRQ_SET_DATA_EVENTFD) {
-		int32_t fd = *(int32_t *)data;
+		int32_t *fds = data;
 		int ret;
 
 		if (is_intx(vdev))
-			return vfio_intx_set_signal(vdev, start, fd, index);
+			return vfio_irq_set_block(vdev, start, count, fds, index);
 
 		ret = vfio_intx_enable(vdev);
 		if (ret)
 			return ret;
 
-		ret = vfio_intx_set_signal(vdev, start, fd, index);
+		ret = vfio_irq_set_block(vdev, start, count, fds, index);
 		if (ret)
 			vfio_intx_disable(vdev);
 
-- 
2.34.1


