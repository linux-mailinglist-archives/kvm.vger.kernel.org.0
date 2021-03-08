Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7442C3319A4
	for <lists+kvm@lfdr.de>; Mon,  8 Mar 2021 22:50:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231891AbhCHVty (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Mar 2021 16:49:54 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31369 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232010AbhCHVtb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Mar 2021 16:49:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615240170;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=26XCLb7rid7Ukjix3izHq6+LQuV7mac/ZWZOJ4MKVFg=;
        b=hE0BLamUTKmw+ZV8MOzdf/KAx2OctWdGC+pgpar7nDHYhMVNfYpCbk7HrFIM3XzkRgUi+S
        5wi7bof9T3smfxh0PJFS6q6Wpy+/8XhwAMzL7Jeb4LnywX9gaiLTjQ+kpGGyzkJn3OWHha
        /Q1yU27RbYy2hgv4v4ybRYkrR6j+B8c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-343-iZIVxP7tPTi3hfqJvY5P5A-1; Mon, 08 Mar 2021 16:49:27 -0500
X-MC-Unique: iZIVxP7tPTi3hfqJvY5P5A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CE0981084D69;
        Mon,  8 Mar 2021 21:49:25 +0000 (UTC)
Received: from gimli.home (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 227D960C04;
        Mon,  8 Mar 2021 21:49:19 +0000 (UTC)
Subject: [PATCH v1 11/14] vfio/type1: Register device notifier
From:   Alex Williamson <alex.williamson@redhat.com>
To:     alex.williamson@redhat.com
Cc:     cohuck@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jgg@nvidia.com, peterx@redhat.com
Date:   Mon, 08 Mar 2021 14:49:18 -0700
Message-ID: <161524015876.3480.18404153016941080011.stgit@gimli.home>
In-Reply-To: <161523878883.3480.12103845207889888280.stgit@gimli.home>
References: <161523878883.3480.12103845207889888280.stgit@gimli.home>
User-Agent: StGit/0.21-2-g8ef5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Impose a new default strict MMIO mapping mode where the vma for
a VM_PFNMAP mapping must be backed by a vfio device.  This allows
holding a reference to the device and registering a notifier for the
device, which additionally keeps the device in an IOMMU context for
the extent of the DMA mapping.  On notification of device release,
automatically drop the DMA mappings for it.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/vfio_iommu_type1.c |  163 ++++++++++++++++++++++++++++-----------
 1 file changed, 116 insertions(+), 47 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index f22c07a40521..e89f11141dee 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -101,6 +101,20 @@ struct vfio_dma {
 	struct task_struct	*task;
 	struct rb_root		pfn_list;	/* Ex-user pinned pfn list */
 	unsigned long		*bitmap;
+	struct pfnmap_obj	*pfnmap;
+};
+
+/*
+ * Separate object used for tracking pfnmaps to allow reference release and
+ * unregistering notifier outside of callback chain.
+ */
+struct pfnmap_obj {
+	struct notifier_block	nb;
+	struct work_struct	work;
+	struct vfio_iommu	*iommu;
+	struct vfio_dma		*dma;
+	struct vfio_device	*device;
+	unsigned long		base_pfn;
 };
 
 struct vfio_batch {
@@ -506,42 +520,6 @@ static void vfio_batch_fini(struct vfio_batch *batch)
 		free_page((unsigned long)batch->pages);
 }
 
-static int follow_fault_pfn(struct vm_area_struct *vma, struct mm_struct *mm,
-			    unsigned long vaddr, unsigned long *pfn,
-			    bool write_fault)
-{
-	pte_t *ptep;
-	spinlock_t *ptl;
-	int ret;
-
-	ret = follow_pte(vma->vm_mm, vaddr, &ptep, &ptl);
-	if (ret) {
-		bool unlocked = false;
-
-		ret = fixup_user_fault(mm, vaddr,
-				       FAULT_FLAG_REMOTE |
-				       (write_fault ?  FAULT_FLAG_WRITE : 0),
-				       &unlocked);
-		if (unlocked)
-			return -EAGAIN;
-
-		if (ret)
-			return ret;
-
-		ret = follow_pte(vma->vm_mm, vaddr, &ptep, &ptl);
-		if (ret)
-			return ret;
-	}
-
-	if (write_fault && !pte_write(*ptep))
-		ret = -EFAULT;
-	else
-		*pfn = pte_pfn(*ptep);
-
-	pte_unmap_unlock(ptep, ptl);
-	return ret;
-}
-
 /* Return 1 if iommu->lock dropped and notified, 0 if done */
 static int unmap_dma_pfn_list(struct vfio_iommu *iommu, struct vfio_dma *dma,
 			      struct vfio_dma **dma_last, int *retries)
@@ -575,6 +553,52 @@ static int unmap_dma_pfn_list(struct vfio_iommu *iommu, struct vfio_dma *dma,
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
+		struct vfio_dma *dma_last = NULL;
+		int retries = 0;
+again:
+		mutex_lock(&pfnmap->iommu->lock);
+		if (pfnmap->dma) {
+			struct vfio_dma *dma = pfnmap->dma;
+
+			if (unmap_dma_pfn_list(pfnmap->iommu, dma,
+					       &dma_last, &retries))
+				goto again;
+
+			dma->pfnmap = NULL;
+			pfnmap->dma = NULL;
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
 /*
  * Returns the positive number of pfns successfully obtained or a negative
  * error code.
@@ -601,21 +625,60 @@ static int vaddr_get_pfns(struct vfio_iommu *iommu, struct vfio_dma *dma,
 
 	vaddr = untagged_addr(vaddr);
 
-retry:
 	vma = find_vma_intersection(mm, vaddr, vaddr + 1);
 
 	if (vma && vma->vm_flags & VM_PFNMAP) {
-		ret = follow_fault_pfn(vma, mm, vaddr, pfn,
-				       dma->prot & IOMMU_WRITE);
-		if (ret == -EAGAIN)
-			goto retry;
-
-		if (!ret) {
-			if (is_invalid_reserved_pfn(*pfn))
-				ret = 1;
-			else
-				ret = -EFAULT;
+		if ((dma->prot & IOMMU_WRITE && !(vma->vm_flags & VM_WRITE)) ||
+		    (dma->prot & IOMMU_READ && !(vma->vm_flags & VM_READ))) {
+			ret = -EFAULT;
+			goto done;
+		}
+
+		if (!dma->pfnmap) {
+			struct vfio_device *device;
+			unsigned long base_pfn;
+			struct pfnmap_obj *pfnmap;
+
+			device = vfio_device_get_from_vma(vma);
+			if (IS_ERR(device)) {
+				ret = PTR_ERR(device);
+				goto done;
+			}
+
+			ret = vfio_vma_to_pfn(vma, &base_pfn);
+			if (ret) {
+				vfio_device_put(device);
+				goto done;
+			}
+
+			pfnmap = kzalloc(sizeof(*pfnmap), GFP_KERNEL);
+			if (!pfnmap) {
+				vfio_device_put(device);
+				ret = -ENOMEM;
+				goto done;
+			}
+
+			pfnmap->nb.notifier_call = vfio_device_nb_cb;
+			pfnmap->iommu = iommu;
+			pfnmap->dma = dma;
+			pfnmap->device = device;
+			pfnmap->base_pfn = base_pfn;
+
+			dma->pfnmap = pfnmap;
+
+			ret = vfio_device_register_notifier(device,
+							    &pfnmap->nb);
+			if (ret) {
+				dma->pfnmap = NULL;
+				kfree(pfnmap);
+				vfio_device_put(device);
+				goto done;
+			}
 		}
+
+		*pfn = ((vaddr - vma->vm_start) >> PAGE_SHIFT) +
+							dma->pfnmap->base_pfn;
+		ret = 1;
 	}
 done:
 	mmap_read_unlock(mm);
@@ -1189,6 +1252,12 @@ static long vfio_unmap_unpin(struct vfio_iommu *iommu, struct vfio_dma *dma,
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

