Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88DB96CCC5F
	for <lists+kvm@lfdr.de>; Tue, 28 Mar 2023 23:55:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230106AbjC1VzB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 17:55:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbjC1Vys (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 17:54:48 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2789C30E8;
        Tue, 28 Mar 2023 14:54:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680040467; x=1711576467;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7zreZsByDSz6HOKWv+RGhtYj9t2usm/KvzrQLe5byiA=;
  b=AQ8AA71AzA4Q67as9Q5R88Ajhji6w3AAgd1jlgN3z/0unqCtlc12CsYZ
   WdPZIjMVCDMNAoQiS5Qp7ZfPCCfmZ462Ch9IHMGIPiqyua1v5YQd360fW
   UJhQp6ID/IvuEBinXeXITTdCiPrBwuLdtzAEshUkhlMPhHDJw9lMry9r/
   Mr82dSzu7x2/a0aQhIU9HLLX9XJYG6X6HCNp4YCmVZhYARybVtulJjZdp
   f5PkKOWhNJrwBTgo08/Hr+i3JrXFKvFSMsGkgv7LBqd2IbZ/52Ufic0+d
   VkjZcjWHhx2lHh7sbewjqtHOM/2NZp+ZxjXPWF6zhwEYbT+gBZsdOUk2Y
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10663"; a="403316946"
X-IronPort-AV: E=Sophos;i="5.98,297,1673942400"; 
   d="scan'208";a="403316946"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2023 14:53:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10663"; a="748543789"
X-IronPort-AV: E=Sophos;i="5.98,297,1673942400"; 
   d="scan'208";a="748543789"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2023 14:53:51 -0700
From:   Reinette Chatre <reinette.chatre@intel.com>
To:     jgg@nvidia.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        alex.williamson@redhat.com
Cc:     tglx@linutronix.de, darwi@linutronix.de, kvm@vger.kernel.org,
        dave.jiang@intel.com, jing2.liu@intel.com, ashok.raj@intel.com,
        fenghua.yu@intel.com, tom.zanussi@linux.intel.com,
        reinette.chatre@intel.com, linux-kernel@vger.kernel.org
Subject: [PATCH V2 7/8] vfio/pci: Support dynamic MSI-x
Date:   Tue, 28 Mar 2023 14:53:34 -0700
Message-Id: <419f3ba2f732154d8ae079b3deb02d0fdbe3e258.1680038771.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1680038771.git.reinette.chatre@intel.com>
References: <cover.1680038771.git.reinette.chatre@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Recently introduced pci_msix_alloc_irq_at() and pci_msix_free_irq()
enables an individual MSI-X index to be allocated and freed after
MSI-X enabling.

Support dynamic MSI-X if supported by the device. Keep the association
between allocated interrupt and vfio interrupt context. Allocate new
context together with the new interrupt if no interrupt context exist
for an MSI-X interrupt. Similarly, release an interrupt with its
context.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
Changes since RFC V1:
- Add pointer to interrupt context as function parameter to
  vfio_irq_ctx_free(). (Alex)
- Initialize new_ctx to false. (Dan Carpenter)
- Only support dynamic allocation if device supports it. (Alex)

 drivers/vfio/pci/vfio_pci_intrs.c | 93 +++++++++++++++++++++++++------
 1 file changed, 76 insertions(+), 17 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index b3a258e58625..755b752ca17e 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -55,6 +55,13 @@ struct vfio_pci_irq_ctx *vfio_irq_ctx_get(struct vfio_pci_core_device *vdev,
 	return xa_load(&vdev->ctx, index);
 }
 
+static void vfio_irq_ctx_free(struct vfio_pci_core_device *vdev,
+			      struct vfio_pci_irq_ctx *ctx, unsigned long index)
+{
+	xa_erase(&vdev->ctx, index);
+	kfree(ctx);
+}
+
 static void vfio_irq_ctx_free_all(struct vfio_pci_core_device *vdev)
 {
 	struct vfio_pci_irq_ctx *ctx;
@@ -409,33 +416,62 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
 {
 	struct pci_dev *pdev = vdev->pdev;
 	struct vfio_pci_irq_ctx *ctx;
+	struct msi_map msix_map = {};
+	bool allow_dyn_alloc = false;
 	struct eventfd_ctx *trigger;
+	bool new_ctx = false;
 	int irq, ret;
 	u16 cmd;
 
+	/* Only MSI-X allows dynamic allocation. */
+	if (msix && pci_msix_can_alloc_dyn(vdev->pdev))
+		allow_dyn_alloc = true;
+
 	ctx = vfio_irq_ctx_get(vdev, vector);
-	if (!ctx)
+	if (!ctx && !allow_dyn_alloc)
 		return -EINVAL;
+
 	irq = pci_irq_vector(pdev, vector);
+	/* Context and interrupt are always allocated together. */
+	WARN_ON((ctx && irq == -EINVAL) || (!ctx && irq != -EINVAL));
 
-	if (ctx->trigger) {
+	if (ctx && ctx->trigger) {
 		irq_bypass_unregister_producer(&ctx->producer);
 
 		cmd = vfio_pci_memory_lock_and_enable(vdev);
 		free_irq(irq, ctx->trigger);
+		if (allow_dyn_alloc) {
+			msix_map.index = vector;
+			msix_map.virq = irq;
+			pci_msix_free_irq(pdev, msix_map);
+			irq = -EINVAL;
+		}
 		vfio_pci_memory_unlock_and_restore(vdev, cmd);
 		kfree(ctx->name);
 		eventfd_ctx_put(ctx->trigger);
 		ctx->trigger = NULL;
+		if (allow_dyn_alloc) {
+			vfio_irq_ctx_free(vdev, ctx, vector);
+			ctx = NULL;
+		}
 	}
 
 	if (fd < 0)
 		return 0;
 
+	if (!ctx) {
+		ctx = vfio_irq_ctx_alloc_single(vdev, vector);
+		if (!ctx)
+			return -ENOMEM;
+		new_ctx = true;
+	}
+
 	ctx->name = kasprintf(GFP_KERNEL_ACCOUNT, "vfio-msi%s[%d](%s)",
 			      msix ? "x" : "", vector, pci_name(pdev));
-	if (!ctx->name)
-		return -ENOMEM;
+	if (!ctx->name) {
+		ret = -ENOMEM;
+		goto out_free_ctx;
+	}
 
 	trigger = eventfd_ctx_fdget(fd);
 	if (IS_ERR(trigger)) {
@@ -443,25 +479,38 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
 		goto out_free_name;
 	}
 
-	/*
-	 * The MSIx vector table resides in device memory which may be cleared
-	 * via backdoor resets. We don't allow direct access to the vector
-	 * table so even if a userspace driver attempts to save/restore around
-	 * such a reset it would be unsuccessful. To avoid this, restore the
-	 * cached value of the message prior to enabling.
-	 */
 	cmd = vfio_pci_memory_lock_and_enable(vdev);
 	if (msix) {
-		struct msi_msg msg;
-
-		get_cached_msi_msg(irq, &msg);
-		pci_write_msi_msg(irq, &msg);
+		if (irq == -EINVAL) {
+			msix_map = pci_msix_alloc_irq_at(pdev, vector, NULL);
+			if (msix_map.index < 0) {
+				vfio_pci_memory_unlock_and_restore(vdev, cmd);
+				ret = msix_map.index;
+				goto out_put_eventfd_ctx;
+			}
+			irq = msix_map.virq;
+		} else {
+			/*
+			 * The MSIx vector table resides in device memory which
+			 * may be cleared via backdoor resets. We don't allow
+			 * direct access to the vector table so even if a
+			 * userspace driver attempts to save/restore around
+			 * such a reset it would be unsuccessful. To avoid
+			 * this, restore the cached value of the message prior
+			 * to enabling.
+			 */
+			struct msi_msg msg;
+
+			get_cached_msi_msg(irq, &msg);
+			pci_write_msi_msg(irq, &msg);
+		}
 	}
 
 	ret = request_irq(irq, vfio_msihandler, 0, ctx->name, trigger);
-	vfio_pci_memory_unlock_and_restore(vdev, cmd);
 	if (ret)
-		goto out_put_eventfd_ctx;
+		goto out_free_irq_locked;
+
+	vfio_pci_memory_unlock_and_restore(vdev, cmd);
 
 	ctx->producer.token = trigger;
 	ctx->producer.irq = irq;
@@ -477,11 +526,21 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
 
 	return 0;
 
+out_free_irq_locked:
+	if (allow_dyn_alloc && new_ctx) {
+		msix_map.index = vector;
+		msix_map.virq = irq;
+		pci_msix_free_irq(pdev, msix_map);
+	}
+	vfio_pci_memory_unlock_and_restore(vdev, cmd);
 out_put_eventfd_ctx:
 	eventfd_ctx_put(trigger);
 out_free_name:
 	kfree(ctx->name);
 	ctx->name = NULL;
+out_free_ctx:
+	if (allow_dyn_alloc && new_ctx)
+		vfio_irq_ctx_free(vdev, ctx, vector);
 	return ret;
 }
 
-- 
2.34.1

