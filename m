Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 355927D9E72
	for <lists+kvm@lfdr.de>; Fri, 27 Oct 2023 19:01:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346140AbjJ0RBt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Oct 2023 13:01:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346126AbjJ0RBj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Oct 2023 13:01:39 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B8E71B1;
        Fri, 27 Oct 2023 10:01:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698426092; x=1729962092;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GkJBWrxAiWSak7q/17XkI04lJCWO+cXFv4bwhrGKIvE=;
  b=KbiGsC+5QHYZ6KjgJB+NDISXh/rQ7DzO6yXLLLrx6NkHD+q8b2mlPP4d
   SGYS60aolfYxm6bwYoPIo+Ui6lAVR0DdD3kJdRtv9EjQWwBNq1flrUNl2
   p1HQmzogvimHa+YSSa9CpGN5vpADlQ81IoGQ5rms1fVKRcCYTbw4+EK9k
   4TEzaN5LnD3tpUQHGsh30kppG3/qrwTVMk8zjA8u9Amu8132Co0/Lg6w4
   x2dpf8aDm6ZvDiIXWhEH3BkAcW9sPv9htJeAMkjMY3v54dRjZf2W1Ppsl
   ZG2+VhUc2+RPaWzEMXVLliCEJnXOe3741fexC5NptUNpigCa37f0uiXsp
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10876"; a="611928"
X-IronPort-AV: E=Sophos;i="6.03,256,1694761200"; 
   d="scan'208";a="611928"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2023 10:01:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10876"; a="1090988186"
X-IronPort-AV: E=Sophos;i="6.03,256,1694761200"; 
   d="scan'208";a="1090988186"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2023 10:01:16 -0700
From:   Reinette Chatre <reinette.chatre@intel.com>
To:     jgg@nvidia.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        alex.williamson@redhat.com
Cc:     kvm@vger.kernel.org, dave.jiang@intel.com, jing2.liu@intel.com,
        ashok.raj@intel.com, fenghua.yu@intel.com,
        tom.zanussi@linux.intel.com, reinette.chatre@intel.com,
        linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: [RFC PATCH V3 11/26] vfio/pci: Provide interrupt context to irq_is() and is_irq_none()
Date:   Fri, 27 Oct 2023 10:00:43 -0700
Message-Id: <a64d1acc474087b1947de910d23acf3b7985f9a7.1698422237.git.reinette.chatre@intel.com>
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

The IRQ type moved to the interrupt context, struct vfio_pci_intr_ctx.

Let the tests on the IRQ type use the interrupt context directly without
any assumption about the containing structure. Doing so makes these
generic utilities available to all interrupt management backends.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
Changes since RFC V2:
- New patch

 drivers/vfio/pci/vfio_pci_intrs.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 858795ba50fe..9aff5c38f198 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -31,9 +31,9 @@ struct vfio_pci_irq_ctx {
 	struct irq_bypass_producer	producer;
 };
 
-static bool irq_is(struct vfio_pci_core_device *vdev, int type)
+static bool irq_is(struct vfio_pci_intr_ctx *intr_ctx, int type)
 {
-	return vdev->intr_ctx.irq_type == type;
+	return intr_ctx->irq_type == type;
 }
 
 static bool is_intx(struct vfio_pci_core_device *vdev)
@@ -41,11 +41,11 @@ static bool is_intx(struct vfio_pci_core_device *vdev)
 	return vdev->intr_ctx.irq_type == VFIO_PCI_INTX_IRQ_INDEX;
 }
 
-static bool is_irq_none(struct vfio_pci_core_device *vdev)
+static bool is_irq_none(struct vfio_pci_intr_ctx *intr_ctx)
 {
-	return !(vdev->intr_ctx.irq_type == VFIO_PCI_INTX_IRQ_INDEX ||
-		 vdev->intr_ctx.irq_type == VFIO_PCI_MSI_IRQ_INDEX ||
-		 vdev->intr_ctx.irq_type == VFIO_PCI_MSIX_IRQ_INDEX);
+	return !(intr_ctx->irq_type == VFIO_PCI_INTX_IRQ_INDEX ||
+		 intr_ctx->irq_type == VFIO_PCI_MSI_IRQ_INDEX ||
+		 intr_ctx->irq_type == VFIO_PCI_MSIX_IRQ_INDEX);
 }
 
 static
@@ -235,7 +235,7 @@ static int vfio_intx_enable(struct vfio_pci_core_device *vdev)
 {
 	struct vfio_pci_irq_ctx *ctx;
 
-	if (!is_irq_none(vdev))
+	if (!is_irq_none(&vdev->intr_ctx))
 		return -EINVAL;
 
 	if (!vdev->pdev->irq)
@@ -353,7 +353,7 @@ static int vfio_msi_enable(struct vfio_pci_core_device *vdev, int nvec, bool msi
 	int ret;
 	u16 cmd;
 
-	if (!is_irq_none(vdev))
+	if (!is_irq_none(&vdev->intr_ctx))
 		return -EINVAL;
 
 	/* return the number of supported vectors if we can't get all: */
@@ -621,7 +621,7 @@ static int vfio_pci_set_intx_trigger(struct vfio_pci_intr_ctx *intr_ctx,
 		return 0;
 	}
 
-	if (!(is_intx(vdev) || is_irq_none(vdev)) || start != 0 || count != 1)
+	if (!(is_intx(vdev) || is_irq_none(intr_ctx)) || start != 0 || count != 1)
 		return -EINVAL;
 
 	if (flags & VFIO_IRQ_SET_DATA_EVENTFD) {
@@ -665,12 +665,12 @@ static int vfio_pci_set_msi_trigger(struct vfio_pci_intr_ctx *intr_ctx,
 	unsigned int i;
 	bool msix = (index == VFIO_PCI_MSIX_IRQ_INDEX) ? true : false;
 
-	if (irq_is(vdev, index) && !count && (flags & VFIO_IRQ_SET_DATA_NONE)) {
+	if (irq_is(intr_ctx, index) && !count && (flags & VFIO_IRQ_SET_DATA_NONE)) {
 		vfio_msi_disable(vdev, msix);
 		return 0;
 	}
 
-	if (!(irq_is(vdev, index) || is_irq_none(vdev)))
+	if (!(irq_is(intr_ctx, index) || is_irq_none(intr_ctx)))
 		return -EINVAL;
 
 	if (flags & VFIO_IRQ_SET_DATA_EVENTFD) {
@@ -692,7 +692,7 @@ static int vfio_pci_set_msi_trigger(struct vfio_pci_intr_ctx *intr_ctx,
 		return ret;
 	}
 
-	if (!irq_is(vdev, index))
+	if (!irq_is(intr_ctx, index))
 		return -EINVAL;
 
 	for (i = start; i < start + count; i++) {
-- 
2.34.1

