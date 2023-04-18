Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10F966E6B04
	for <lists+kvm@lfdr.de>; Tue, 18 Apr 2023 19:29:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232599AbjDRR3x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Apr 2023 13:29:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231877AbjDRR3t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Apr 2023 13:29:49 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FEB1AF06;
        Tue, 18 Apr 2023 10:29:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681838988; x=1713374988;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4kEJ197nr6yM9IPTGo2RuhmxMJUO//xhEu591g3IFAE=;
  b=ZVtwveBfnSrDwSMVErY7Rq3XFWqB2oZD+Y8aPDmDKmBYjYp2Qo4K1LeQ
   C2U6GtvfDs13qXPHJskdrG4aFx79uM9HJkXI4gfWNKjOwJDte3I9/P0Sh
   47F2QK+C1jDJXBjKMIsw+ad7NHYiIuMTk2FGfRhIxzazFDr/LtpAN0vbk
   dSXK5LbAONI1PK5CzvNNfSm7alzVQZ8HcbYH0JeJqdJpph/kC7ungMx9I
   xQnmXiocPSwSzTaHsnMgAp0bAXPJZMQP49vjBTiRQ7ZDlAooS5Y9xQvO2
   BC2iVT4jJPzxuuE7YiyXawc770iq/M+uP8rArd8Z+1vtRZms8gNjU41JE
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10684"; a="410466475"
X-IronPort-AV: E=Sophos;i="5.99,207,1677571200"; 
   d="scan'208";a="410466475"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2023 10:29:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10684"; a="865503484"
X-IronPort-AV: E=Sophos;i="5.99,207,1677571200"; 
   d="scan'208";a="865503484"
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
Subject: [PATCH V3 06/10] vfio/pci: Remove interrupt context counter
Date:   Tue, 18 Apr 2023 10:29:17 -0700
Message-Id: <056fbd6c7c5161fb912d60b3f75e379ab3255d75.1681837892.git.reinette.chatre@intel.com>
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

struct vfio_pci_core_device::num_ctx counts how many interrupt
contexts have been allocated. When all interrupt contexts are
allocated simultaneously num_ctx provides the upper bound of all
vectors that can be used as indices into the interrupt context
array.

With the upcoming support for dynamic MSI-X the number of
interrupt contexts does not necessarily span the range of allocated
interrupts. Consequently, num_ctx is no longer a trusted upper bound
for valid indices.

Stop using num_ctx to determine if a provided vector is valid. Use
the existence of allocated interrupt.

This changes behavior on the error path when user space provides
an invalid vector range. Behavior changes from early exit without
any modifications to possible modifications to valid vectors within
the invalid range. This is acceptable considering that an invalid
range is not a valid scenario, see link to discussion.

The checks that ensure that user space provides a range of vectors
that is valid for the device are untouched.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Link: https://lore.kernel.org/lkml/20230316155646.07ae266f.alex.williamson@redhat.com/
---
Changes since V2:
- Update changelog to reflect change in policy that existence of
  allocated interrupt is validity check, not existence of context
  (which is now dynamically allocated).

Changes since RFC V1:
- Remove vfio_irq_ctx_range_allocated(). (Alex and Kevin).

 drivers/vfio/pci/vfio_pci_intrs.c | 13 +------------
 include/linux/vfio_pci_core.h     |  1 -
 2 files changed, 1 insertion(+), 13 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 117cd384b3ad..5e3de004f4cb 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -237,8 +237,6 @@ static int vfio_intx_enable(struct vfio_pci_core_device *vdev)
 	if (!ctx)
 		return -ENOMEM;
 
-	vdev->num_ctx = 1;
-
 	/*
 	 * If the virtual interrupt is masked, restore it.  Devices
 	 * supporting DisINTx can be masked at the hardware level
@@ -325,7 +323,6 @@ static void vfio_intx_disable(struct vfio_pci_core_device *vdev)
 	}
 	vfio_intx_set_signal(vdev, -1);
 	vdev->irq_type = VFIO_PCI_NUM_IRQS;
-	vdev->num_ctx = 0;
 	vfio_irq_ctx_free(vdev, ctx, 0);
 }
 
@@ -361,7 +358,6 @@ static int vfio_msi_enable(struct vfio_pci_core_device *vdev, int nvec, bool msi
 	}
 	vfio_pci_memory_unlock_and_restore(vdev, cmd);
 
-	vdev->num_ctx = nvec;
 	vdev->irq_type = msix ? VFIO_PCI_MSIX_IRQ_INDEX :
 				VFIO_PCI_MSI_IRQ_INDEX;
 
@@ -385,9 +381,6 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
 	int irq, ret;
 	u16 cmd;
 
-	if (vector >= vdev->num_ctx)
-		return -EINVAL;
-
 	irq = pci_irq_vector(pdev, vector);
 	if (irq < 0)
 		return -EINVAL;
@@ -474,9 +467,6 @@ static int vfio_msi_set_block(struct vfio_pci_core_device *vdev, unsigned start,
 	unsigned int i, j;
 	int ret = 0;
 
-	if (start >= vdev->num_ctx || start + count > vdev->num_ctx)
-		return -EINVAL;
-
 	for (i = 0, j = start; i < count && !ret; i++, j++) {
 		int fd = fds ? fds[i] : -1;
 		ret = vfio_msi_set_vector_signal(vdev, j, fd, msix);
@@ -515,7 +505,6 @@ static void vfio_msi_disable(struct vfio_pci_core_device *vdev, bool msix)
 		pci_intx(pdev, 0);
 
 	vdev->irq_type = VFIO_PCI_NUM_IRQS;
-	vdev->num_ctx = 0;
 }
 
 /*
@@ -650,7 +639,7 @@ static int vfio_pci_set_msi_trigger(struct vfio_pci_core_device *vdev,
 		return ret;
 	}
 
-	if (!irq_is(vdev, index) || start + count > vdev->num_ctx)
+	if (!irq_is(vdev, index))
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

