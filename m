Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38EF96BBE58
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 22:00:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230266AbjCOVAN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 17:00:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232588AbjCOU7q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 16:59:46 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA55F80E0C;
        Wed, 15 Mar 2023 13:59:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678913985; x=1710449985;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JSa8iDgjg3H/aceoIH3gESDgqHFGMkkzi2yi2ZVLSyY=;
  b=bIqebSfytjUc45WSje+w3ymKYJixik+vQ/zgMZAJqK5s5qB0kaXV4e5z
   56sa0o/EIeAXJm7Et+p/YX/MjSTM4KMAJmobEAtqMUCJOzhowHpr/mYcG
   gDAFvWESdbOQq0x8VuWo3XjpAf8uEXyhQ/9eA9JDSGrwqYS2j0V2iLwou
   ZtpnXiHr7oVVroTZJFYGteuYNg3fK6sPKZFEQiZ3NQY6ClPVbZLW+Eavz
   gYQnd0th10nOBOVtNpvPDCWuB/rVdfx9HJdMaNPg7LqLiTOTtMsjXb3OV
   087oph8XIZ1NT9+jUtuBSavcuiAkCydte6L0GZNzDudmaywNg7BYN5sS5
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10650"; a="326176534"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="326176534"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2023 13:59:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10650"; a="853747232"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="853747232"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2023 13:59:39 -0700
From:   Reinette Chatre <reinette.chatre@intel.com>
To:     jgg@nvidia.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        alex.williamson@redhat.com
Cc:     tglx@linutronix.de, darwi@linutronix.de, kvm@vger.kernel.org,
        dave.jiang@intel.com, jing2.liu@intel.com, ashok.raj@intel.com,
        fenghua.yu@intel.com, tom.zanussi@linux.intel.com,
        reinette.chatre@intel.com, linux-kernel@vger.kernel.org
Subject: [RFC PATCH 7/8] vfio/pci: Support dynamic MSI-x
Date:   Wed, 15 Mar 2023 13:59:27 -0700
Message-Id: <591ce11f4a33e022fc9242324ebdc077202bedaf.1678911529.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1678911529.git.reinette.chatre@intel.com>
References: <cover.1678911529.git.reinette.chatre@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Recently introduced pci_msix_alloc_irq_at() and pci_msix_free_irq()
enables an individual MSI-X index to be allocated and freed after
MSI-X enabling.

Support dynamic MSI-X by keeping the association between allocated
interrupt and vfio interrupt context. Allocate new context together
with the new interrupt if no interrupt context exist for an MSI-X
interrupt. Similarly, release an interrupt with its context.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---

Guidance is appreciated on expectations regarding maintaining
existing error behavior. Earlier patch introduced the
vfio_irq_ctx_range_allocated() helper to maintain existing error
behavior. Now, this helper needs to be disabled for MSI-X. User
space not wanting to dynamically allocate MSI-X interrupts, but
providing invalid range when providing a new ACTION will now
obtain new interrupts or new failures (potentially including freeing
of existing interrupts) if the allocation of the new interrupts fail.

 drivers/vfio/pci/vfio_pci_intrs.c | 101 ++++++++++++++++++++++++------
 1 file changed, 83 insertions(+), 18 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index b375a12885ba..954a70575802 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -55,6 +55,18 @@ struct vfio_pci_irq_ctx *vfio_irq_ctx_get(struct vfio_pci_core_device *vdev,
 	return xa_load(&vdev->ctx, index);
 }
 
+static void vfio_irq_ctx_free(struct vfio_pci_core_device *vdev,
+			      unsigned long index)
+{
+	struct vfio_pci_irq_ctx *ctx;
+
+	ctx = xa_load(&vdev->ctx, index);
+	if (ctx) {
+		xa_erase(&vdev->ctx, index);
+		kfree(ctx);
+	}
+}
+
 static void vfio_irq_ctx_free_all(struct vfio_pci_core_device *vdev)
 {
 	struct vfio_pci_irq_ctx *ctx;
@@ -430,33 +442,63 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
 {
 	struct pci_dev *pdev = vdev->pdev;
 	struct vfio_pci_irq_ctx *ctx;
+	struct msi_map msix_map = {};
 	struct eventfd_ctx *trigger;
+	bool new_ctx;
 	int irq, ret;
 	u16 cmd;
 
 	ctx = vfio_irq_ctx_get(vdev, vector);
-	if (!ctx)
+	/* Only MSI-X allows dynamic allocation. */
+	if (!msix && !ctx)
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
+		if (msix) {
+			msix_map.index = vector;
+			msix_map.virq = irq;
+			pci_msix_free_irq(pdev, msix_map);
+			irq = -EINVAL;
+		}
 		vfio_pci_memory_unlock_and_restore(vdev, cmd);
 		kfree(ctx->name);
 		eventfd_ctx_put(ctx->trigger);
 		ctx->trigger = NULL;
+		if (msix) {
+			vfio_irq_ctx_free(vdev, vector);
+			ctx = NULL;
+		}
 	}
 
 	if (fd < 0)
 		return 0;
 
+	if (!ctx) {
+		ret = vfio_irq_ctx_alloc_single(vdev, vector);
+		if (ret)
+			return ret;
+		ctx = vfio_irq_ctx_get(vdev, vector);
+		if (!ctx) {
+			ret = -EINVAL;
+			goto out_free_ctx;
+		}
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
@@ -464,25 +506,38 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
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
@@ -498,11 +553,21 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
 
 	return 0;
 
+out_free_irq_locked:
+	if (msix && new_ctx) {
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
+	if (msix && new_ctx)
+		vfio_irq_ctx_free(vdev, vector);
 	return ret;
 }
 
@@ -512,7 +577,7 @@ static int vfio_msi_set_block(struct vfio_pci_core_device *vdev, unsigned start,
 	int i, ret = 0;
 	unsigned int j;
 
-	if (!vfio_irq_ctx_range_allocated(vdev, start, count))
+	if (!msix && !vfio_irq_ctx_range_allocated(vdev, start, count))
 		return -EINVAL;
 
 	for (i = 0, j = start; i < count && !ret; i++, j++) {
-- 
2.34.1

