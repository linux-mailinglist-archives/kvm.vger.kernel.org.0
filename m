Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B5BD6BBE54
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 22:00:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232656AbjCOVAG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 17:00:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232498AbjCOU7o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 16:59:44 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E780900B3;
        Wed, 15 Mar 2023 13:59:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678913983; x=1710449983;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=j7plS9ITT8roz2joqbCS1lpsy17/bXANdR8t6kDnulg=;
  b=E3UsmQCiMcWdyW1wAxNvUQFxJ8gvF3cBRFkpFljnC3vbIyWaY9clqiiI
   /lTbNWGpZQSXopz0Is1lvrQz+Mzt8t1pnAO72R7oVDPKBB2GvlAptb+Sk
   4haoMhBdjxDjsllTl/KpvYXgcRCGWs30xEapHgqb7MeykJCssHlBYAwqw
   TC8OTXbE7AWt7bF4F+tiLbHffOxSeDPIDnuVJtVuL+khjdIPOom8GaJ9u
   TmDsJGVlQ0iLtZbaps3AmAkTl0F/AKMcR2gdegucLzuqeZ1ynPG8hpbSu
   H1G00pXlKUicpC65vIDsNXph9Uwl8XIv9rveWG+pFVgI5ROaMiGdGHw8a
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10650"; a="326176524"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="326176524"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2023 13:59:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10650"; a="853747225"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="853747225"
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
Subject: [RFC PATCH 5/8] vfio/pci: Remove interrupt context counter
Date:   Wed, 15 Mar 2023 13:59:25 -0700
Message-Id: <3154c63905481b5747a7457b275e2bce403b6f84.1678911529.git.reinette.chatre@intel.com>
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

struct vfio_pci_core_device::num_ctx counts how many interrupt
contexts have been allocated. When all interrupt contexts are
allocated simultaneously num_ctx provides the upper bound of all
vectors that can be used as indices into the interrupt context
array.

With the upcoming support for dynamic MSI-X the number of
interrupt contexts does not necessarily span the range of allocated
interrupts. Consequently, num_ctx is no longer a trusted upper bound
for valid indices.

Stop using num_ctx to determine if a provided vector is valid, use
the existence of interrupt context directly.

Introduce a helper that ensures a provided interrupt range is
allocated before any user requested action is taken. This maintains
existing behavior (early exit without modifications) when user
space attempts to modify a range of vectors that includes unallocated
interrupts.

The checks that ensure that user space provides a range of vectors
that is valid for the device are untouched.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---

Existing behavior on error paths is not maintained for MSI-X
when adding support for dynamic MSI-X. Please see maintainer
comments associated with "vfio/pci: Support dynamic MSI-x".

 drivers/vfio/pci/vfio_pci_intrs.c | 30 ++++++++++++++++++++----------
 include/linux/vfio_pci_core.h     |  1 -
 2 files changed, 20 insertions(+), 11 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index bfcf5cb6b435..187a1ba34a16 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -107,6 +107,21 @@ static int vfio_irq_ctx_alloc_num(struct vfio_pci_core_device *vdev,
 	return ret;
 }
 
+static bool vfio_irq_ctx_range_allocated(struct vfio_pci_core_device *vdev,
+					 unsigned int start, unsigned int count)
+{
+	struct vfio_pci_irq_ctx *ctx;
+	unsigned int i;
+
+	for (i = start; i < start + count; i++) {
+		ctx = xa_load(&vdev->ctx, i);
+		if (!ctx)
+			return false;
+	}
+
+	return true;
+}
+
 /*
  * INTx
  */
@@ -270,8 +285,6 @@ static int vfio_intx_enable(struct vfio_pci_core_device *vdev)
 		return -EINVAL;
 	}
 
-	vdev->num_ctx = 1;
-
 	/*
 	 * If the virtual interrupt is masked, restore it.  Devices
 	 * supporting DisINTx can be masked at the hardware level
@@ -358,7 +371,6 @@ static void vfio_intx_disable(struct vfio_pci_core_device *vdev)
 	}
 	vfio_intx_set_signal(vdev, -1);
 	vdev->irq_type = VFIO_PCI_NUM_IRQS;
-	vdev->num_ctx = 0;
 	vfio_irq_ctx_free_all(vdev);
 }
 
@@ -399,7 +411,6 @@ static int vfio_msi_enable(struct vfio_pci_core_device *vdev, int nvec, bool msi
 	}
 	vfio_pci_memory_unlock_and_restore(vdev, cmd);
 
-	vdev->num_ctx = nvec;
 	vdev->irq_type = msix ? VFIO_PCI_MSIX_IRQ_INDEX :
 				VFIO_PCI_MSI_IRQ_INDEX;
 
@@ -423,9 +434,6 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
 	int irq, ret;
 	u16 cmd;
 
-	if (vector >= vdev->num_ctx)
-		return -EINVAL;
-
 	ctx = vfio_irq_ctx_get(vdev, vector);
 	if (!ctx)
 		return -EINVAL;
@@ -500,7 +508,7 @@ static int vfio_msi_set_block(struct vfio_pci_core_device *vdev, unsigned start,
 	int i, ret = 0;
 	unsigned int j;
 
-	if (start >= vdev->num_ctx || start + count > vdev->num_ctx)
+	if (!vfio_irq_ctx_range_allocated(vdev, start, count))
 		return -EINVAL;
 
 	for (i = 0, j = start; i < count && !ret; i++, j++) {
@@ -541,7 +549,6 @@ static void vfio_msi_disable(struct vfio_pci_core_device *vdev, bool msix)
 		pci_intx(pdev, 0);
 
 	vdev->irq_type = VFIO_PCI_NUM_IRQS;
-	vdev->num_ctx = 0;
 	vfio_irq_ctx_free_all(vdev);
 }
 
@@ -677,7 +684,10 @@ static int vfio_pci_set_msi_trigger(struct vfio_pci_core_device *vdev,
 		return ret;
 	}
 
-	if (!irq_is(vdev, index) || start + count > vdev->num_ctx)
+	if (!irq_is(vdev, index))
+		return -EINVAL;
+
+	if (!vfio_irq_ctx_range_allocated(vdev, start, count))
 		return -EINVAL;
 
 	for (i = start; i < start + count; i++) {
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index 61d7873a3973..148fd1ae6c1c 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -60,7 +60,6 @@ struct vfio_pci_core_device {
 	spinlock_t		irqlock;
 	struct mutex		igate;
 	struct xarray		ctx;
-	int			num_ctx;
 	int			irq_type;
 	int			num_regions;
 	struct vfio_pci_region	*region;
-- 
2.34.1

