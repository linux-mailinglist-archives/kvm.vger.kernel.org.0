Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC25E2B4202
	for <lists+kvm@lfdr.de>; Mon, 16 Nov 2020 12:05:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729515AbgKPLBZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Nov 2020 06:01:25 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:56688 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728876AbgKPLBZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Nov 2020 06:01:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605524484;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gJAyj1O39GWEktSYG4Dy1c2uuRhlZx8GksmnaSasy+w=;
        b=J1ihUNn+QTTV5CY9f4HOjc/LlcsruDVhSeYJ/gYZXQeWrG6u54FrmHX3GeuMgn/o70lL5u
        BT3B+PI3TYmgrZazt4wyTmq84QnOmaWisS6nqYxDkqM0ckd9oZ9FXezIesTKlY5DCjw2/b
        lKgIrcNXixVyIpD33y0ShWJhAMqB+Ko=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-152-Ayz2YOF0M3Ki6K-PO-n9pg-1; Mon, 16 Nov 2020 06:01:22 -0500
X-MC-Unique: Ayz2YOF0M3Ki6K-PO-n9pg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1CDE46D241;
        Mon, 16 Nov 2020 11:01:20 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-113-230.ams2.redhat.com [10.36.113.230])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A05DC5C716;
        Mon, 16 Nov 2020 11:01:14 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, will@kernel.org,
        joro@8bytes.org, maz@kernel.org, robin.murphy@arm.com,
        alex.williamson@redhat.com
Cc:     jean-philippe@linaro.org, zhangfei.gao@linaro.org,
        zhangfei.gao@gmail.com, vivek.gautam@arm.com,
        shameerali.kolothum.thodi@huawei.com,
        jacob.jun.pan@linux.intel.com, yi.l.liu@intel.com, tn@semihalf.com,
        nicoleotsuka@gmail.com, yuzenghui@huawei.com
Subject: [PATCH v11 05/13] vfio/pci: Register an iommu fault handler
Date:   Mon, 16 Nov 2020 12:00:22 +0100
Message-Id: <20201116110030.32335-6-eric.auger@redhat.com>
In-Reply-To: <20201116110030.32335-1-eric.auger@redhat.com>
References: <20201116110030.32335-1-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Register an IOMMU fault handler which records faults in
the DMA FAULT region ring buffer. In a subsequent patch, we
will add the signaling of a specific eventfd to allow the
userspace to be notified whenever a new fault as shown up.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---
v11 -> v12:
- take the fault_queue_lock before reading header (Zenghui)
- also record recoverable errors

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
 drivers/vfio/pci/vfio_pci.c | 45 +++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 7546a81e7fb6..b39d6ed66c71 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -27,6 +27,7 @@
 #include <linux/vgaarb.h>
 #include <linux/nospec.h>
 #include <linux/sched/mm.h>
+#include <linux/circ_buf.h>
 
 #include "vfio_pci_private.h"
 
@@ -335,6 +336,41 @@ static const struct vfio_pci_regops vfio_pci_dma_fault_regops = {
 	.add_capability = vfio_pci_dma_fault_add_capability,
 };
 
+int vfio_pci_iommu_dev_fault_handler(struct iommu_fault *fault, void *data)
+{
+	struct vfio_pci_device *vdev = (struct vfio_pci_device *)data;
+	struct vfio_region_dma_fault *reg =
+		(struct vfio_region_dma_fault *)vdev->fault_pages;
+	struct iommu_fault *new;
+	u32 head, tail, size;
+	int ret = -EINVAL;
+
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
@@ -376,6 +412,13 @@ static int vfio_pci_dma_fault_init(struct vfio_pci_device *vdev)
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
@@ -508,6 +551,8 @@ static void vfio_pci_disable(struct vfio_pci_device *vdev)
 				VFIO_IRQ_SET_ACTION_TRIGGER,
 				vdev->irq_type, 0, 0, NULL);
 
+	WARN_ON(iommu_unregister_device_fault_handler(&vdev->pdev->dev));
+
 	/* Device closed, don't need mutex here */
 	list_for_each_entry_safe(ioeventfd, ioeventfd_tmp,
 				 &vdev->ioeventfds_list, next) {
-- 
2.21.3

