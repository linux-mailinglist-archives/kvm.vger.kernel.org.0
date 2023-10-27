Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 984187D9E80
	for <lists+kvm@lfdr.de>; Fri, 27 Oct 2023 19:02:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345949AbjJ0RCA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Oct 2023 13:02:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346191AbjJ0RBl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Oct 2023 13:01:41 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CBB9D40;
        Fri, 27 Oct 2023 10:01:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698426095; x=1729962095;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HCox2ulOzQiGBwuU9Q0+MtUDv4dr89lG8sCECB6xAZg=;
  b=irpCT1kpOa6OhvIECJu5dDqdHvgAUrTc0x/EokN3O2lv2fNofUMZId9i
   upguZw5cs4zt2VC4Fbat3yoPu91WLgcD6OHVydFrkiUw88nCSi4UHzZqO
   rw8qou+MfQxSsDLVP+HEteh0XXDK7lAG76YCduKpllZnn+XQ6VtVD9RSj
   zVy+ierq9agmYTB/qXgnPhlZieXVfMWVLO3P8DNMzfSlH0nc4Xrh1EM/T
   +z5qo53Ue1/Zn8jXY2Q7vVNUQpi+1lBE91Ab94sGTKtc0IUFypHFWz0aD
   fn7n0DZdCMEfuVcsRWTtlf+VphQOnGUX00Fu71C8WYJxNsK20Kr2w37o9
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10876"; a="611981"
X-IronPort-AV: E=Sophos;i="6.03,256,1694761200"; 
   d="scan'208";a="611981"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2023 10:01:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10876"; a="1090988205"
X-IronPort-AV: E=Sophos;i="6.03,256,1694761200"; 
   d="scan'208";a="1090988205"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2023 10:01:17 -0700
From:   Reinette Chatre <reinette.chatre@intel.com>
To:     jgg@nvidia.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        alex.williamson@redhat.com
Cc:     kvm@vger.kernel.org, dave.jiang@intel.com, jing2.liu@intel.com,
        ashok.raj@intel.com, fenghua.yu@intel.com,
        tom.zanussi@linux.intel.com, reinette.chatre@intel.com,
        linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: [RFC PATCH V3 15/26] vfio/pci: Move generic code to frontend
Date:   Fri, 27 Oct 2023 10:00:47 -0700
Message-Id: <8c1d36376cbfade8576d72ef148ea842322ec375.1698422237.git.reinette.chatre@intel.com>
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

vfio_pci_set_msi_trigger() and vfio_msi_set_block() are generic
and thus appropriate to be frontend code. This means that they
should operate on the interrupt context, not backend specific
data.

Provide the interrupt context as parameter to vfio_pci_set_msi_trigger()
and vfio_msi_set_block() and remove all references to the PCI interrupt
management data from these functions. This enables these functions to
form part of the interrupt management frontend shared by different
interrupt management backends.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
Changes since RFC V2:
- New patch

 drivers/vfio/pci/vfio_pci_intrs.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index d2b80e176651..adad93c31ac6 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -415,18 +415,19 @@ static int vfio_msi_alloc_irq(struct vfio_pci_core_device *vdev,
 	return map.index < 0 ? map.index : map.virq;
 }
 
-static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
+static int vfio_msi_set_vector_signal(struct vfio_pci_intr_ctx *intr_ctx,
 				      unsigned int vector, int fd,
 				      unsigned int index)
 {
 	bool msix = (index == VFIO_PCI_MSIX_IRQ_INDEX) ? true : false;
+	struct vfio_pci_core_device *vdev = intr_ctx->priv;
 	struct pci_dev *pdev = vdev->pdev;
 	struct vfio_pci_irq_ctx *ctx;
 	struct eventfd_ctx *trigger;
 	int irq = -EINVAL, ret;
 	u16 cmd;
 
-	ctx = vfio_irq_ctx_get(&vdev->intr_ctx, vector);
+	ctx = vfio_irq_ctx_get(intr_ctx, vector);
 
 	if (ctx) {
 		irq_bypass_unregister_producer(&ctx->producer);
@@ -437,7 +438,7 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
 		/* Interrupt stays allocated, will be freed at MSI-X disable. */
 		kfree(ctx->name);
 		eventfd_ctx_put(ctx->trigger);
-		vfio_irq_ctx_free(&vdev->intr_ctx, ctx, vector);
+		vfio_irq_ctx_free(intr_ctx, ctx, vector);
 	}
 
 	if (fd < 0)
@@ -450,7 +451,7 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
 			return irq;
 	}
 
-	ctx = vfio_irq_ctx_alloc(&vdev->intr_ctx, vector);
+	ctx = vfio_irq_ctx_alloc(intr_ctx, vector);
 	if (!ctx)
 		return -ENOMEM;
 
@@ -504,11 +505,11 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
 out_free_name:
 	kfree(ctx->name);
 out_free_ctx:
-	vfio_irq_ctx_free(&vdev->intr_ctx, ctx, vector);
+	vfio_irq_ctx_free(intr_ctx, ctx, vector);
 	return ret;
 }
 
-static int vfio_msi_set_block(struct vfio_pci_core_device *vdev,
+static int vfio_msi_set_block(struct vfio_pci_intr_ctx *intr_ctx,
 			      unsigned int start, unsigned int count,
 			      int32_t *fds, unsigned int index)
 {
@@ -517,12 +518,12 @@ static int vfio_msi_set_block(struct vfio_pci_core_device *vdev,
 
 	for (i = 0, j = start; i < count && !ret; i++, j++) {
 		int fd = fds ? fds[i] : -1;
-		ret = vfio_msi_set_vector_signal(vdev, j, fd, index);
+		ret = vfio_msi_set_vector_signal(intr_ctx, j, fd, index);
 	}
 
 	if (ret) {
 		for (i = start; i < j; i++)
-			vfio_msi_set_vector_signal(vdev, i, -1, index);
+			vfio_msi_set_vector_signal(intr_ctx, i, -1, index);
 	}
 
 	return ret;
@@ -540,7 +541,7 @@ static void vfio_msi_disable(struct vfio_pci_intr_ctx *intr_ctx,
 	xa_for_each(&intr_ctx->ctx, i, ctx) {
 		vfio_virqfd_disable(&ctx->unmask);
 		vfio_virqfd_disable(&ctx->mask);
-		vfio_msi_set_vector_signal(vdev, i, -1, index);
+		vfio_msi_set_vector_signal(intr_ctx, i, -1, index);
 	}
 
 	cmd = vfio_pci_memory_lock_and_enable(vdev);
@@ -668,7 +669,6 @@ static int vfio_pci_set_msi_trigger(struct vfio_pci_intr_ctx *intr_ctx,
 				    unsigned int count, uint32_t flags,
 				    void *data)
 {
-	struct vfio_pci_core_device *vdev = intr_ctx->priv;
 	struct vfio_pci_irq_ctx *ctx;
 	unsigned int i;
 
@@ -684,15 +684,15 @@ static int vfio_pci_set_msi_trigger(struct vfio_pci_intr_ctx *intr_ctx,
 		int32_t *fds = data;
 		int ret;
 
-		if (vdev->intr_ctx.irq_type == index)
-			return vfio_msi_set_block(vdev, start, count,
+		if (intr_ctx->irq_type == index)
+			return vfio_msi_set_block(intr_ctx, start, count,
 						  fds, index);
 
 		ret = vfio_msi_enable(intr_ctx, start + count, index);
 		if (ret)
 			return ret;
 
-		ret = vfio_msi_set_block(vdev, start, count, fds, index);
+		ret = vfio_msi_set_block(intr_ctx, start, count, fds, index);
 		if (ret)
 			vfio_msi_disable(intr_ctx, index);
 
@@ -703,7 +703,7 @@ static int vfio_pci_set_msi_trigger(struct vfio_pci_intr_ctx *intr_ctx,
 		return -EINVAL;
 
 	for (i = start; i < start + count; i++) {
-		ctx = vfio_irq_ctx_get(&vdev->intr_ctx, i);
+		ctx = vfio_irq_ctx_get(intr_ctx, i);
 		if (!ctx)
 			continue;
 		if (flags & VFIO_IRQ_SET_DATA_NONE) {
-- 
2.34.1

