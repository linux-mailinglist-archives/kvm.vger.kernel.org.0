Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDA957D9E7A
	for <lists+kvm@lfdr.de>; Fri, 27 Oct 2023 19:01:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346354AbjJ0RBz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Oct 2023 13:01:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346053AbjJ0RBk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Oct 2023 13:01:40 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76CA21BE;
        Fri, 27 Oct 2023 10:01:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698426095; x=1729962095;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bBS/18bRpnFhIcmeDxdHepWbJUmanHfqzWI9dXFjxAQ=;
  b=DtLvWDjN65As9exdCw7oFr3h/bFyxLTTuihrqueZpzvct90z6ucfRw6H
   jyhav7sW3EIaG75AsIQzVo8OPv463o7E5Sf7T5/BhNDE6gol0SBoIcXBt
   7161Avl9IYRWmvImQS4eR/uSEY1dEmfusGG/2uilAZZHKjQMqQuKA4xsk
   FZQQ2nog/F56pGwFOVobqeN8D1NgiAcKiP0W/E/9qS728JAeABStGWKJs
   6dEl/9neoukAtji1hUMFEWztkmHwP0EsrnNLkHFrB31qd/wAyKmD+kaSl
   AQ8yCdKLIl0JMLcxywh89cEjgGqIc+roFphgjjB3HPQIGVCRtwjKh8Ew0
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10876"; a="611958"
X-IronPort-AV: E=Sophos;i="6.03,256,1694761200"; 
   d="scan'208";a="611958"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2023 10:01:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10876"; a="1090988200"
X-IronPort-AV: E=Sophos;i="6.03,256,1694761200"; 
   d="scan'208";a="1090988200"
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
Subject: [RFC PATCH V3 14/26] vfio/pci: Let interrupt management backend interpret interrupt index
Date:   Fri, 27 Oct 2023 10:00:46 -0700
Message-Id: <aa54a18aafef2e672ec50771b9694ca60312a7fc.1698422237.git.reinette.chatre@intel.com>
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
and can be shared by different interrupt backends. This implies
that these functions should not interpret user provided parameters
but instead pass them to the backend specific code for interpretation.

Instead of assuming that only MSI or MSI-X can be provided via the
index and passing a boolean based on what was received, pass the
actual index to backend for interpretation.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
Changes since RFC V2:
- New patch

 drivers/vfio/pci/vfio_pci_intrs.c | 38 +++++++++++++++++--------------
 1 file changed, 21 insertions(+), 17 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index ad3f9c1baccc..d2b80e176651 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -346,17 +346,20 @@ static irqreturn_t vfio_msihandler(int irq, void *arg)
 	return IRQ_HANDLED;
 }
 
-static int vfio_msi_enable(struct vfio_pci_intr_ctx *intr_ctx, int nvec, bool msix)
+static int vfio_msi_enable(struct vfio_pci_intr_ctx *intr_ctx, int nvec,
+			   unsigned int index)
 {
 	struct vfio_pci_core_device *vdev = intr_ctx->priv;
 	struct pci_dev *pdev = vdev->pdev;
-	unsigned int flag = msix ? PCI_IRQ_MSIX : PCI_IRQ_MSI;
+	unsigned int flag;
 	int ret;
 	u16 cmd;
 
 	if (!is_irq_none(intr_ctx))
 		return -EINVAL;
 
+	flag = (index == VFIO_PCI_MSIX_IRQ_INDEX) ? PCI_IRQ_MSIX : PCI_IRQ_MSI;
+
 	/* return the number of supported vectors if we can't get all: */
 	cmd = vfio_pci_memory_lock_and_enable(vdev);
 	ret = pci_alloc_irq_vectors(pdev, 1, nvec, flag);
@@ -368,10 +371,9 @@ static int vfio_msi_enable(struct vfio_pci_intr_ctx *intr_ctx, int nvec, bool ms
 	}
 	vfio_pci_memory_unlock_and_restore(vdev, cmd);
 
-	intr_ctx->irq_type = msix ? VFIO_PCI_MSIX_IRQ_INDEX :
-				VFIO_PCI_MSI_IRQ_INDEX;
+	intr_ctx->irq_type = index;
 
-	if (!msix) {
+	if (index == VFIO_PCI_MSI_IRQ_INDEX) {
 		/*
 		 * Compute the virtual hardware field for max msi vectors -
 		 * it is the log base 2 of the number of vectors.
@@ -414,8 +416,10 @@ static int vfio_msi_alloc_irq(struct vfio_pci_core_device *vdev,
 }
 
 static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
-				      unsigned int vector, int fd, bool msix)
+				      unsigned int vector, int fd,
+				      unsigned int index)
 {
+	bool msix = (index == VFIO_PCI_MSIX_IRQ_INDEX) ? true : false;
 	struct pci_dev *pdev = vdev->pdev;
 	struct vfio_pci_irq_ctx *ctx;
 	struct eventfd_ctx *trigger;
@@ -506,25 +510,26 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
 
 static int vfio_msi_set_block(struct vfio_pci_core_device *vdev,
 			      unsigned int start, unsigned int count,
-			      int32_t *fds, bool msix)
+			      int32_t *fds, unsigned int index)
 {
 	unsigned int i, j;
 	int ret = 0;
 
 	for (i = 0, j = start; i < count && !ret; i++, j++) {
 		int fd = fds ? fds[i] : -1;
-		ret = vfio_msi_set_vector_signal(vdev, j, fd, msix);
+		ret = vfio_msi_set_vector_signal(vdev, j, fd, index);
 	}
 
 	if (ret) {
 		for (i = start; i < j; i++)
-			vfio_msi_set_vector_signal(vdev, i, -1, msix);
+			vfio_msi_set_vector_signal(vdev, i, -1, index);
 	}
 
 	return ret;
 }
 
-static void vfio_msi_disable(struct vfio_pci_intr_ctx *intr_ctx, bool msix)
+static void vfio_msi_disable(struct vfio_pci_intr_ctx *intr_ctx,
+			     unsigned int index)
 {
 	struct vfio_pci_core_device *vdev = intr_ctx->priv;
 	struct pci_dev *pdev = vdev->pdev;
@@ -535,7 +540,7 @@ static void vfio_msi_disable(struct vfio_pci_intr_ctx *intr_ctx, bool msix)
 	xa_for_each(&intr_ctx->ctx, i, ctx) {
 		vfio_virqfd_disable(&ctx->unmask);
 		vfio_virqfd_disable(&ctx->mask);
-		vfio_msi_set_vector_signal(vdev, i, -1, msix);
+		vfio_msi_set_vector_signal(vdev, i, -1, index);
 	}
 
 	cmd = vfio_pci_memory_lock_and_enable(vdev);
@@ -666,10 +671,9 @@ static int vfio_pci_set_msi_trigger(struct vfio_pci_intr_ctx *intr_ctx,
 	struct vfio_pci_core_device *vdev = intr_ctx->priv;
 	struct vfio_pci_irq_ctx *ctx;
 	unsigned int i;
-	bool msix = (index == VFIO_PCI_MSIX_IRQ_INDEX) ? true : false;
 
 	if (irq_is(intr_ctx, index) && !count && (flags & VFIO_IRQ_SET_DATA_NONE)) {
-		vfio_msi_disable(intr_ctx, msix);
+		vfio_msi_disable(intr_ctx, index);
 		return 0;
 	}
 
@@ -682,15 +686,15 @@ static int vfio_pci_set_msi_trigger(struct vfio_pci_intr_ctx *intr_ctx,
 
 		if (vdev->intr_ctx.irq_type == index)
 			return vfio_msi_set_block(vdev, start, count,
-						  fds, msix);
+						  fds, index);
 
-		ret = vfio_msi_enable(intr_ctx, start + count, msix);
+		ret = vfio_msi_enable(intr_ctx, start + count, index);
 		if (ret)
 			return ret;
 
-		ret = vfio_msi_set_block(vdev, start, count, fds, msix);
+		ret = vfio_msi_set_block(vdev, start, count, fds, index);
 		if (ret)
-			vfio_msi_disable(intr_ctx, msix);
+			vfio_msi_disable(intr_ctx, index);
 
 		return ret;
 	}
-- 
2.34.1

