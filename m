Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7B023232FE
	for <lists+kvm@lfdr.de>; Tue, 23 Feb 2021 22:09:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234427AbhBWVI7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Feb 2021 16:08:59 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:57823 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234375AbhBWVIo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 23 Feb 2021 16:08:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614114437;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=genscmgMsjlA4KiTDkitCw7fvwsL/tsui1bdhDkf9uw=;
        b=SJUvVy8EftGdXGb22XlBz+oxCTbZIkbj4c9JOAgny69CQNgu/GxNWjNFln2bkCr04LyQPU
        v2Q7UA1zduXxQ4YcFPClnPaZOybIyrYpEaCz/DWz7SjgxCr4dDo/ievsP24HtlOVFQacOX
        KH1ilKk+F9F8uBAzghTtz6JESPxo4xw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-500-Scu5nHSbMFubdgZcbsVi4w-1; Tue, 23 Feb 2021 16:07:13 -0500
X-MC-Unique: Scu5nHSbMFubdgZcbsVi4w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CA6E31020C2B;
        Tue, 23 Feb 2021 21:07:10 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-114-34.ams2.redhat.com [10.36.114.34])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D8AC75D9D0;
        Tue, 23 Feb 2021 21:07:01 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, will@kernel.org,
        maz@kernel.org, robin.murphy@arm.com, joro@8bytes.org,
        alex.williamson@redhat.com, tn@semihalf.com, zhukeqian1@huawei.com
Cc:     jacob.jun.pan@linux.intel.com, yi.l.liu@intel.com,
        wangxingang5@huawei.com, jiangkunkun@huawei.com,
        jean-philippe@linaro.org, zhangfei.gao@linaro.org,
        zhangfei.gao@gmail.com, vivek.gautam@arm.com,
        shameerali.kolothum.thodi@huawei.com, yuzenghui@huawei.com,
        nicoleotsuka@gmail.com, lushenming@huawei.com, vsethi@nvidia.com
Subject: [PATCH v12 05/13] vfio/pci: Register an iommu fault handler
Date:   Tue, 23 Feb 2021 22:06:17 +0100
Message-Id: <20210223210625.604517-6-eric.auger@redhat.com>
In-Reply-To: <20210223210625.604517-1-eric.auger@redhat.com>
References: <20210223210625.604517-1-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Register an IOMMU fault handler which records faults in
the DMA FAULT region ring buffer. In a subsequent patch, we
will add the signaling of a specific eventfd to allow the
userspace to be notified whenever a new fault has shown up.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---
v11 -> v12:
- take the fault_queue_lock before reading header (Zenghui)
- also record recoverable errors
- only WARN_ON if the unregistration returns -EBUSY
- make vfio_pci_iommu_dev_fault_handler static

v10 -> v11:
- move iommu_unregister_device_fault_handler into
  vfio_pci_disable
- check fault_pages != 0

v8 -> v9:
- handler now takes an iommu_fault handle
- eventfd signaling moved to a subsequent patch
- check the fault type and return an error if != UNRECOV
- still the fault handler registration can fail. We need to
  reach an agreement about how to deal with the situation

v3 -> v4:
- move iommu_unregister_device_fault_handler to vfio_pci_release
---
 drivers/vfio/pci/vfio_pci.c | 48 ++++++++++++++++++++++++++++++++++++-
 1 file changed, 47 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index e9a4a1c502c7..ad3fe0ce2e64 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -27,6 +27,7 @@
 #include <linux/vgaarb.h>
 #include <linux/nospec.h>
 #include <linux/sched/mm.h>
+#include <linux/circ_buf.h>
 
 #include "vfio_pci_private.h"
 
@@ -333,6 +334,41 @@ static const struct vfio_pci_regops vfio_pci_dma_fault_regops = {
 	.add_capability = vfio_pci_dma_fault_add_capability,
 };
 
+static int
+vfio_pci_iommu_dev_fault_handler(struct iommu_fault *fault, void *data)
+{
+	struct vfio_pci_device *vdev = (struct vfio_pci_device *)data;
+	struct vfio_region_dma_fault *reg =
+		(struct vfio_region_dma_fault *)vdev->fault_pages;
+	struct iommu_fault *new;
+	u32 head, tail, size;
+	int ret = -EINVAL;
+
+	if (WARN_ON(!reg))
+		return ret;
+
+	mutex_lock(&vdev->fault_queue_lock);
+
+	head = reg->head;
+	tail = reg->tail;
+	size = reg->nb_entries;
+
+	new = (struct iommu_fault *)(vdev->fault_pages + reg->offset +
+				     head * reg->entry_size);
+
+	if (CIRC_SPACE(head, tail, size) < 1) {
+		ret = -ENOSPC;
+		goto unlock;
+	}
+
+	*new = *fault;
+	reg->head = (head + 1) % size;
+	ret = 0;
+unlock:
+	mutex_unlock(&vdev->fault_queue_lock);
+	return ret;
+}
+
 #define DMA_FAULT_RING_LENGTH 512
 
 static int vfio_pci_dma_fault_init(struct vfio_pci_device *vdev)
@@ -377,6 +413,13 @@ static int vfio_pci_dma_fault_init(struct vfio_pci_device *vdev)
 	header->entry_size = sizeof(struct iommu_fault);
 	header->nb_entries = DMA_FAULT_RING_LENGTH;
 	header->offset = sizeof(struct vfio_region_dma_fault);
+
+	ret = iommu_register_device_fault_handler(&vdev->pdev->dev,
+					vfio_pci_iommu_dev_fault_handler,
+					vdev);
+	if (ret) /* the dma fault region is freed in vfio_pci_disable() */
+		goto out;
+
 	return 0;
 out:
 	kfree(vdev->fault_pages);
@@ -500,7 +543,7 @@ static void vfio_pci_disable(struct vfio_pci_device *vdev)
 	struct pci_dev *pdev = vdev->pdev;
 	struct vfio_pci_dummy_resource *dummy_res, *tmp;
 	struct vfio_pci_ioeventfd *ioeventfd, *ioeventfd_tmp;
-	int i, bar;
+	int i, bar, ret;
 
 	/* Stop the device from further DMA */
 	pci_clear_master(pdev);
@@ -509,6 +552,9 @@ static void vfio_pci_disable(struct vfio_pci_device *vdev)
 				VFIO_IRQ_SET_ACTION_TRIGGER,
 				vdev->irq_type, 0, 0, NULL);
 
+	ret = iommu_unregister_device_fault_handler(&vdev->pdev->dev);
+	WARN_ON(ret == -EBUSY);
+
 	/* Device closed, don't need mutex here */
 	list_for_each_entry_safe(ioeventfd, ioeventfd_tmp,
 				 &vdev->ioeventfds_list, next) {
-- 
2.26.2

