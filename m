Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9998F6CCC58
	for <lists+kvm@lfdr.de>; Tue, 28 Mar 2023 23:54:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230041AbjC1Vyf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 17:54:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230037AbjC1Vy2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 17:54:28 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 228322701;
        Tue, 28 Mar 2023 14:54:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680040453; x=1711576453;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4Fjay3jnRQL5RqHD02xmo6UTR+EpsLej553IAjnbsts=;
  b=lbE+yCOHLh4b7Ej/VaggU7611+VMkXjmoPvC+t7YV1Hb3Um1TMYQPWGa
   gdEfHzZ2hV+qxoIV4xVGfi6oA4zRhfGZJqEsVk4yrQepPpEltgTx7W0hF
   ir6lbd+eBnrhHCAF2k6agl3wRBiGfHg5TPmGHNyFZ5y3h6xdXrXaeNJHW
   8Fk4A9gJyKSefhEeTkPSIuKL2tB1BrQak0daXHq1/GRmzHBtnJxb2qFId
   3aMnnLdZJy91cklIVpX7gA2H8zkhVvMWgKfm4YoLnqH4sTdXXhDVNgH/R
   S7uY7gwrJJM1V7Y/AP/11rjp5wDykmvNdhOAwRCp6C8qt9m9z3iKrTNm5
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10663"; a="403316932"
X-IronPort-AV: E=Sophos;i="5.98,297,1673942400"; 
   d="scan'208";a="403316932"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2023 14:53:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10663"; a="748543782"
X-IronPort-AV: E=Sophos;i="5.98,297,1673942400"; 
   d="scan'208";a="748543782"
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
Subject: [PATCH V2 5/8] vfio/pci: Remove interrupt context counter
Date:   Tue, 28 Mar 2023 14:53:32 -0700
Message-Id: <dfe4d0b38de40a053ccf681d11b287371be9cfa8.1680038771.git.reinette.chatre@intel.com>
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
Changes since RFC V1:
- Remove vfio_irq_ctx_range_allocated(). (Alex and Kevin).

 drivers/vfio/pci/vfio_pci_intrs.c | 13 +------------
 include/linux/vfio_pci_core.h     |  1 -
 2 files changed, 1 insertion(+), 13 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 00119641aa19..b86dce0f384f 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -264,8 +264,6 @@ static int vfio_intx_enable(struct vfio_pci_core_device *vdev)
 	if (!ctx)
 		return -ENOMEM;
 
-	vdev->num_ctx = 1;
-
 	/*
 	 * If the virtual interrupt is masked, restore it.  Devices
 	 * supporting DisINTx can be masked at the hardware level
@@ -352,7 +350,6 @@ static void vfio_intx_disable(struct vfio_pci_core_device *vdev)
 	}
 	vfio_intx_set_signal(vdev, -1);
 	vdev->irq_type = VFIO_PCI_NUM_IRQS;
-	vdev->num_ctx = 0;
 	vfio_irq_ctx_free_all(vdev);
 }
 
@@ -393,7 +390,6 @@ static int vfio_msi_enable(struct vfio_pci_core_device *vdev, int nvec, bool msi
 	}
 	vfio_pci_memory_unlock_and_restore(vdev, cmd);
 
-	vdev->num_ctx = nvec;
 	vdev->irq_type = msix ? VFIO_PCI_MSIX_IRQ_INDEX :
 				VFIO_PCI_MSI_IRQ_INDEX;
 
@@ -417,9 +413,6 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
 	int irq, ret;
 	u16 cmd;
 
-	if (vector >= vdev->num_ctx)
-		return -EINVAL;
-
 	ctx = vfio_irq_ctx_get(vdev, vector);
 	if (!ctx)
 		return -EINVAL;
@@ -494,9 +487,6 @@ static int vfio_msi_set_block(struct vfio_pci_core_device *vdev, unsigned start,
 	int i, ret = 0;
 	unsigned int j;
 
-	if (start >= vdev->num_ctx || start + count > vdev->num_ctx)
-		return -EINVAL;
-
 	for (i = 0, j = start; i < count && !ret; i++, j++) {
 		int fd = fds ? fds[i] : -1;
 		ret = vfio_msi_set_vector_signal(vdev, j, fd, msix);
@@ -535,7 +525,6 @@ static void vfio_msi_disable(struct vfio_pci_core_device *vdev, bool msix)
 		pci_intx(pdev, 0);
 
 	vdev->irq_type = VFIO_PCI_NUM_IRQS;
-	vdev->num_ctx = 0;
 	vfio_irq_ctx_free_all(vdev);
 }
 
@@ -671,7 +660,7 @@ static int vfio_pci_set_msi_trigger(struct vfio_pci_core_device *vdev,
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

