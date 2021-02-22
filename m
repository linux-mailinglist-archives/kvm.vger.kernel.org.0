Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A33A321D84
	for <lists+kvm@lfdr.de>; Mon, 22 Feb 2021 17:56:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231635AbhBVQzK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Feb 2021 11:55:10 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:38096 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230008AbhBVQyL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 22 Feb 2021 11:54:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614012762;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CMKYi977B1ceJjf8ogDnhhIiFZDTPthFKkUwzRtjKSk=;
        b=N2B0X0acUB8iAfbl5YpfADfJIkCVIYChY53LTbmo3c9aEug16ANWwtaiVq6NST+w79gaXI
        dfUHjo+H769KUcCkg/P7y+gObr+mEPxX3/gZvG+No6AHhpW8nqQqTDJFuG8GRWNtKlR1KC
        04Fjy4YbTAsAuUC8nOnfwu5mOBNjWiY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-6-8r2AjvF6N0S4Z3izvkOrgA-1; Mon, 22 Feb 2021 11:52:40 -0500
X-MC-Unique: 8r2AjvF6N0S4Z3izvkOrgA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9B4A6100CCC0;
        Mon, 22 Feb 2021 16:52:39 +0000 (UTC)
Received: from gimli.home (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2BA0C5D6B1;
        Mon, 22 Feb 2021 16:52:33 +0000 (UTC)
Subject: [RFC PATCH 10/10] vfio/type1: Register device notifier
From:   Alex Williamson <alex.williamson@redhat.com>
To:     alex.williamson@redhat.com
Cc:     cohuck@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jgg@nvidia.com, peterx@redhat.com
Date:   Mon, 22 Feb 2021 09:52:32 -0700
Message-ID: <161401275279.16443.6350471385325897377.stgit@gimli.home>
In-Reply-To: <161401167013.16443.8389863523766611711.stgit@gimli.home>
References: <161401167013.16443.8389863523766611711.stgit@gimli.home>
User-Agent: StGit/0.21-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce a new default strict MMIO mapping mode where the vma for
a VM_PFNMAP mapping must be backed by a vfio device.  This allows
holding a reference to the device and registering a notifier for the
device, which additionally keeps the device in an IOMMU context for
the extent of the DMA mapping.  On notification of device release,
automatically drop the DMA mappings for it.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/vfio_iommu_type1.c |  124 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 123 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index b34ee4b96a4a..2a16257bd5b6 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -61,6 +61,11 @@ module_param_named(dma_entry_limit, dma_entry_limit, uint, 0644);
 MODULE_PARM_DESC(dma_entry_limit,
 		 "Maximum number of user DMA mappings per container (65535).");
 
+static bool strict_mmio_maps = true;
+module_param_named(strict_mmio_maps, strict_mmio_maps, bool, 0644);
+MODULE_PARM_DESC(strict_mmio_maps,
+		 "Restrict to safe DMA mappings of device memory (true).");
+
 struct vfio_iommu {
 	struct list_head	domain_list;
 	struct list_head	iova_list;
@@ -88,6 +93,14 @@ struct vfio_domain {
 	bool			fgsp;		/* Fine-grained super pages */
 };
 
+/* Req separate object for async removal from notifier vs dropping vfio_dma */
+struct pfnmap_obj {
+	struct notifier_block	nb;
+	struct work_struct	work;
+	struct vfio_iommu	*iommu;
+	struct vfio_device	*device;
+};
+
 struct vfio_dma {
 	struct rb_node		node;
 	dma_addr_t		iova;		/* Device address */
@@ -100,6 +113,7 @@ struct vfio_dma {
 	struct task_struct	*task;
 	struct rb_root		pfn_list;	/* Ex-user pinned pfn list */
 	unsigned long		*bitmap;
+	struct pfnmap_obj	*pfnmap;
 };
 
 struct vfio_group {
@@ -517,6 +531,68 @@ static int unmap_dma_pfn_list(struct vfio_iommu *iommu, struct vfio_dma *dma,
 	return 0;
 }
 
+static void unregister_device_bg(struct work_struct *work)
+{
+	struct pfnmap_obj *pfnmap = container_of(work, struct pfnmap_obj, work);
+
+	vfio_device_unregister_notifier(pfnmap->device, &pfnmap->nb);
+	vfio_device_put(pfnmap->device);
+	kfree(pfnmap);
+}
+
+/*
+ * pfnmap object can exist beyond the dma mapping referencing it, but it holds
+ * a container reference assuring the iommu exists.  Find the dma, if exists.
+ */
+struct vfio_dma *pfnmap_find_dma(struct pfnmap_obj *pfnmap)
+{
+	struct rb_node *n;
+
+	for (n = rb_first(&pfnmap->iommu->dma_list); n; n = rb_next(n)) {
+		struct vfio_dma *dma = rb_entry(n, struct vfio_dma, node);
+
+		if (dma->pfnmap == pfnmap)
+			return dma;
+	}
+
+	return NULL;
+}
+
+static void vfio_remove_dma(struct vfio_iommu *iommu, struct vfio_dma *dma);
+
+static int vfio_device_nb_cb(struct notifier_block *nb,
+			     unsigned long action, void *unused)
+{
+	struct pfnmap_obj *pfnmap = container_of(nb, struct pfnmap_obj, nb);
+
+	switch (action) {
+	case VFIO_DEVICE_RELEASE:
+	{
+		struct vfio_dma *dma, *dma_last = NULL;
+		int retries = 0;
+again:
+		mutex_lock(&pfnmap->iommu->lock);
+		dma = pfnmap_find_dma(pfnmap);
+		if (dma) {
+			if (unmap_dma_pfn_list(pfnmap->iommu, dma,
+					       &dma_last, &retries))
+				goto again;
+
+			dma->pfnmap = NULL;
+			vfio_remove_dma(pfnmap->iommu, dma);
+		}
+		mutex_unlock(&pfnmap->iommu->lock);
+
+		/* Cannot unregister notifier from callback chain */
+		INIT_WORK(&pfnmap->work, unregister_device_bg);
+		schedule_work(&pfnmap->work);
+		break;
+	}
+	}
+
+	return NOTIFY_OK;
+}
+
 static int vaddr_get_pfn(struct vfio_iommu *iommu, struct vfio_dma *dma,
 			 struct mm_struct *mm, unsigned long vaddr,
 			 unsigned long *pfn)
@@ -549,8 +625,48 @@ static int vaddr_get_pfn(struct vfio_iommu *iommu, struct vfio_dma *dma,
 		if (ret == -EAGAIN)
 			goto retry;
 
-		if (!ret && !is_invalid_reserved_pfn(*pfn))
+		if (!ret && !is_invalid_reserved_pfn(*pfn)) {
 			ret = -EFAULT;
+			goto done;
+		}
+
+		if (!dma->pfnmap) {
+			struct pfnmap_obj *pfnmap;
+			struct vfio_device *device;
+
+			pfnmap = kzalloc(sizeof(*pfnmap), GFP_KERNEL);
+			if (!pfnmap) {
+				ret = -ENOMEM;
+				goto done;
+			}
+
+			pfnmap->iommu = iommu;
+			pfnmap->nb.notifier_call = vfio_device_nb_cb;
+
+			device = vfio_device_get_from_vma(vma);
+			if (IS_ERR(device)) {
+				kfree(pfnmap);
+				if (strict_mmio_maps)
+					ret = PTR_ERR(device);
+
+				goto done;
+			}
+
+			pfnmap->device = device;
+			ret = vfio_device_register_notifier(device,
+							    &pfnmap->nb);
+			if (ret) {
+				vfio_device_put(device);
+				kfree(pfnmap);
+				if (!strict_mmio_maps)
+					ret = 0;
+
+				goto done;
+			}
+
+			dma->pfnmap = pfnmap;
+		}
+
 	}
 done:
 	mmap_read_unlock(mm);
@@ -1097,6 +1213,12 @@ static long vfio_unmap_unpin(struct vfio_iommu *iommu, struct vfio_dma *dma,
 static void vfio_remove_dma(struct vfio_iommu *iommu, struct vfio_dma *dma)
 {
 	WARN_ON(!RB_EMPTY_ROOT(&dma->pfn_list));
+	if (dma->pfnmap) {
+		vfio_device_unregister_notifier(dma->pfnmap->device,
+						&dma->pfnmap->nb);
+		vfio_device_put(dma->pfnmap->device);
+		kfree(dma->pfnmap);
+	}
 	vfio_unmap_unpin(iommu, dma, true);
 	vfio_unlink_dma(iommu, dma);
 	put_task_struct(dma->task);

