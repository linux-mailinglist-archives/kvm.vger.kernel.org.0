Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86F012B4213
	for <lists+kvm@lfdr.de>; Mon, 16 Nov 2020 12:05:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729619AbgKPLC3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Nov 2020 06:02:29 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46126 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729601AbgKPLC0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Nov 2020 06:02:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605524544;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MhjX1xdeElZvc/s7sgs405VJ1vEVIYhz1k37uHGfV1I=;
        b=fgj8SrDF8TUj/94L3gQOqMAExVcywZ8FFqTrJbuIYv0kn34nmlAS6GtfijCCD+pCK5CX4e
        PfEl1huGomvJl8oEDMjhyaKOslqzMpPgPz+PgzWdssyMJZz2XzIWA2OJP6MnVDasCX1CWA
        IgjOCo8Z1oUteEShK2QPcItpgOgoR5c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-107-kQyGVpalPNKUQKTIDLLDvw-1; Mon, 16 Nov 2020 06:02:21 -0500
X-MC-Unique: kQyGVpalPNKUQKTIDLLDvw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AC57C84639D;
        Mon, 16 Nov 2020 11:02:18 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-113-230.ams2.redhat.com [10.36.113.230])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 32E9B5C5AF;
        Mon, 16 Nov 2020 11:02:14 +0000 (UTC)
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
Subject: [PATCH v11 13/13] vfio/pci: Inject page response upon response region fill
Date:   Mon, 16 Nov 2020 12:00:30 +0100
Message-Id: <20201116110030.32335-14-eric.auger@redhat.com>
In-Reply-To: <20201116110030.32335-1-eric.auger@redhat.com>
References: <20201116110030.32335-1-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
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
 drivers/vfio/pci/vfio_pci_private.h |  8 ++++++
 drivers/vfio/pci/vfio_pci_rdwr.c    |  1 +
 3 files changed, 49 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index e9a904ce3f0d..beea70d70151 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -542,6 +542,32 @@ static int vfio_pci_dma_fault_init(struct vfio_pci_device *vdev)
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
@@ -585,8 +611,22 @@ static int vfio_pci_dma_fault_response_init(struct vfio_pci_device *vdev)
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
index 035634521cd0..5944f96ced0c 100644
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
 
@@ -145,6 +151,8 @@ struct vfio_pci_device {
 	struct eventfd_ctx	*req_trigger;
 	u8			*fault_pages;
 	u8			*fault_response_pages;
+	struct workqueue_struct *dma_fault_response_wq;
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
2.21.3

