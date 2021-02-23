Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B85A32330B
	for <lists+kvm@lfdr.de>; Tue, 23 Feb 2021 22:13:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233330AbhBWVKr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Feb 2021 16:10:47 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:24235 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234143AbhBWVJ7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 23 Feb 2021 16:09:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614114508;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qFP5nFR+/smWrpyvruF7DaQSu9I3ZKUJKdS1H7Zq1W4=;
        b=LoAHZDWKo5bEVUR3x8bpr8a3MGg+AaTHHgy5z3upWhXdXD2iTYTdH37zYWQOaJjcEHxSlo
        pVf9rTh8TJq2gg5q7BvAD7nyzqDwv1FpMtb7X5Wlm4WX0jzINr2NeOyVJh1SoRDKuZX//X
        G8xC94itd83CLBlWy1acuONvXeIdC2s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-524-v_nRRCSwMtOsq-P17rQgiQ-1; Tue, 23 Feb 2021 16:08:26 -0500
X-MC-Unique: v_nRRCSwMtOsq-P17rQgiQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 30FE6801985;
        Tue, 23 Feb 2021 21:08:23 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-114-34.ams2.redhat.com [10.36.114.34])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AB1A45D9D0;
        Tue, 23 Feb 2021 21:08:12 +0000 (UTC)
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
Subject: [PATCH v12 13/13] vfio/pci: Inject page response upon response region fill
Date:   Tue, 23 Feb 2021 22:06:25 +0100
Message-Id: <20210223210625.604517-14-eric.auger@redhat.com>
In-Reply-To: <20210223210625.604517-1-eric.auger@redhat.com>
References: <20210223210625.604517-1-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When the userspace increments the head of the page response
buffer ring, let's push the response into the iommu layer.
This is done through a workqueue that pops the responses from
the ring buffer and increment the tail.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 drivers/vfio/pci/vfio_pci.c         | 40 +++++++++++++++++++++++++++++
 drivers/vfio/pci/vfio_pci_private.h |  7 +++++
 drivers/vfio/pci/vfio_pci_rdwr.c    |  1 +
 3 files changed, 48 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 9f1f5008e556..a41497779a68 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -552,6 +552,32 @@ static int vfio_pci_dma_fault_init(struct vfio_pci_device *vdev)
 	return ret;
 }
 
+static void dma_response_inject(struct work_struct *work)
+{
+	struct vfio_pci_dma_fault_response_work *rwork =
+		container_of(work, struct vfio_pci_dma_fault_response_work, inject);
+	struct vfio_region_dma_fault_response *header = rwork->header;
+	struct vfio_pci_device *vdev = rwork->vdev;
+	struct iommu_page_response *resp;
+	u32 tail, head, size;
+
+	mutex_lock(&vdev->fault_response_queue_lock);
+
+	tail = header->tail;
+	head = header->head;
+	size = header->nb_entries;
+
+	while (CIRC_CNT(head, tail, size) >= 1) {
+		resp = (struct iommu_page_response *)(vdev->fault_response_pages + header->offset +
+						tail * header->entry_size);
+
+		/* TODO: properly handle the return value */
+		iommu_page_response(&vdev->pdev->dev, resp);
+		header->tail = tail = (tail + 1) % size;
+	}
+	mutex_unlock(&vdev->fault_response_queue_lock);
+}
+
 #define DMA_FAULT_RESPONSE_RING_LENGTH 512
 
 static int vfio_pci_dma_fault_response_init(struct vfio_pci_device *vdev)
@@ -597,8 +623,22 @@ static int vfio_pci_dma_fault_response_init(struct vfio_pci_device *vdev)
 	header->nb_entries = DMA_FAULT_RESPONSE_RING_LENGTH;
 	header->offset = PAGE_SIZE;
 
+	vdev->response_work = kzalloc(sizeof(*vdev->response_work), GFP_KERNEL);
+	if (!vdev->response_work)
+		goto out;
+	vdev->response_work->header = header;
+	vdev->response_work->vdev = vdev;
+
+	/* launch the thread that will extract the response */
+	INIT_WORK(&vdev->response_work->inject, dma_response_inject);
+	vdev->dma_fault_response_wq =
+		create_singlethread_workqueue("vfio-dma-fault-response");
+	if (!vdev->dma_fault_response_wq)
+		return -ENOMEM;
+
 	return 0;
 out:
+	kfree(vdev->fault_response_pages);
 	vdev->fault_response_pages = NULL;
 	return ret;
 }
diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/vfio_pci_private.h
index 82a883c101c9..5944f96ced0c 100644
--- a/drivers/vfio/pci/vfio_pci_private.h
+++ b/drivers/vfio/pci/vfio_pci_private.h
@@ -52,6 +52,12 @@ struct vfio_pci_irq_ctx {
 	struct irq_bypass_producer	producer;
 };
 
+struct vfio_pci_dma_fault_response_work {
+	struct work_struct inject;
+	struct vfio_region_dma_fault_response *header;
+	struct vfio_pci_device *vdev;
+};
+
 struct vfio_pci_device;
 struct vfio_pci_region;
 
@@ -146,6 +152,7 @@ struct vfio_pci_device {
 	u8			*fault_pages;
 	u8			*fault_response_pages;
 	struct workqueue_struct *dma_fault_response_wq;
+	struct vfio_pci_dma_fault_response_work *response_work;
 	struct mutex		fault_queue_lock;
 	struct mutex		fault_response_queue_lock;
 	struct list_head	dummy_resources_list;
diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
index efde0793360b..78c494fe35cc 100644
--- a/drivers/vfio/pci/vfio_pci_rdwr.c
+++ b/drivers/vfio/pci/vfio_pci_rdwr.c
@@ -430,6 +430,7 @@ size_t vfio_pci_dma_fault_response_rw(struct vfio_pci_device *vdev, char __user
 		mutex_lock(&vdev->fault_response_queue_lock);
 		header->head = new_head;
 		mutex_unlock(&vdev->fault_response_queue_lock);
+		queue_work(vdev->dma_fault_response_wq, &vdev->response_work->inject);
 	} else {
 		if (copy_to_user(buf, base + pos, count))
 			return -EFAULT;
-- 
2.26.2

