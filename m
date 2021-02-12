Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BFCF31A565
	for <lists+kvm@lfdr.de>; Fri, 12 Feb 2021 20:30:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232086AbhBLT3v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Feb 2021 14:29:51 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:51462 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232065AbhBLT3q (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 12 Feb 2021 14:29:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613158099;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1YuTGZbTwR1WBlvZwFuKyi6rNVLUvL5QcgrEv/9sJpk=;
        b=g/j5SixqpOcgnpPvNWHXN0w1sHOSmV7I9JbvwsgHSIoQYVxJ0rq28G/OpR2MoexRUVI89n
        QZR1K4LeFua7AlMyFIRW4CSAAtHgU3Y75S5LzUvlnwmydbBZ9RQUVnpV/PaUBGOOm5y8PJ
        iLQ/eFtDjzdE5hR7TZAFtveLCrmXtY0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-298-WTcre85hMlWkVuAV9yg9YQ-1; Fri, 12 Feb 2021 14:28:17 -0500
X-MC-Unique: WTcre85hMlWkVuAV9yg9YQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 77BFD801962;
        Fri, 12 Feb 2021 19:28:16 +0000 (UTC)
Received: from gimli.home (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F17295D9DB;
        Fri, 12 Feb 2021 19:28:09 +0000 (UTC)
Subject: [PATCH 3/3] vfio/type1: Implement vma registration and restriction
From:   Alex Williamson <alex.williamson@redhat.com>
To:     alex.williamson@redhat.com
Cc:     cohuck@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jgg@nvidia.com, peterx@redhat.com
Date:   Fri, 12 Feb 2021 12:28:09 -0700
Message-ID: <161315808144.7320.2973346461158505515.stgit@gimli.home>
In-Reply-To: <161315658638.7320.9686203003395567745.stgit@gimli.home>
References: <161315658638.7320.9686203003395567745.stgit@gimli.home>
User-Agent: StGit/0.21-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use the new vma registration interface to configure a notifier for DMA
mappings to device memory.  On close notification, remove the mapping.
This allows us to implement a new default policy to restrict PFNMAP
mappings to only those vmas whose vm_ops is registered with vfio-core
to provide this support.  A new module option is provided to opt-out
should this conflict with existing use cases.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/vfio_iommu_type1.c |  192 +++++++++++++++++++++++++++++++--------
 1 file changed, 155 insertions(+), 37 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 90715413c3d9..137aab2a00fd 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -62,6 +62,11 @@ module_param_named(dma_entry_limit, dma_entry_limit, uint, 0644);
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
@@ -89,6 +94,13 @@ struct vfio_domain {
 	bool			fgsp;		/* Fine-grained super pages */
 };
 
+struct pfnmap_obj {
+	struct notifier_block	nb;
+	struct work_struct	work;
+	struct vfio_iommu	*iommu;
+	void			*opaque;
+};
+
 struct vfio_dma {
 	struct rb_node		node;
 	dma_addr_t		iova;		/* Device address */
@@ -101,6 +113,7 @@ struct vfio_dma {
 	struct task_struct	*task;
 	struct rb_root		pfn_list;	/* Ex-user pinned pfn list */
 	unsigned long		*bitmap;
+	struct pfnmap_obj	*pfnmap;
 };
 
 struct vfio_group {
@@ -495,15 +508,108 @@ static int follow_fault_pfn(struct vm_area_struct *vma, struct mm_struct *mm,
 	return ret;
 }
 
-static int vaddr_get_pfn(struct mm_struct *mm, unsigned long vaddr,
-			 int prot, unsigned long *pfn)
+static void unregister_vma_bg(struct work_struct *work)
+{
+	struct pfnmap_obj *pfnmap = container_of(work, struct pfnmap_obj, work);
+
+	vfio_unregister_vma_nb(pfnmap->opaque);
+	kfree(pfnmap);
+}
+
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
+/* Return 1 if iommu->lock dropped and notified, 0 if done */
+static int unmap_dma_pfn_list(struct vfio_iommu *iommu, struct vfio_dma *dma,
+			      struct vfio_dma **dma_last, int *retries)
+{
+	if (!RB_EMPTY_ROOT(&dma->pfn_list)) {
+		struct vfio_iommu_type1_dma_unmap nb_unmap;
+
+		if (*dma_last == dma) {
+			BUG_ON(++(*retries) > 10);
+		} else {
+			*dma_last = dma;
+			*retries = 0;
+		}
+
+		nb_unmap.iova = dma->iova;
+		nb_unmap.size = dma->size;
+
+		/*
+		 * Notify anyone (mdev vendor drivers) to invalidate and
+		 * unmap iovas within the range we're about to unmap.
+		 * Vendor drivers MUST unpin pages in response to an
+		 * invalidation.
+		 */
+		mutex_unlock(&iommu->lock);
+		blocking_notifier_call_chain(&iommu->notifier,
+					    VFIO_IOMMU_NOTIFY_DMA_UNMAP,
+					    &nb_unmap);
+		return 1;
+	}
+
+	return 0;
+}
+
+static void vfio_remove_dma(struct vfio_iommu *iommu, struct vfio_dma *dma);
+
+static int vfio_vma_nb_cb(struct notifier_block *nb,
+			  unsigned long action, void *unused)
+{
+	struct pfnmap_obj *pfnmap = container_of(nb, struct pfnmap_obj, nb);
+
+	switch (action) {
+	case VFIO_VMA_NOTIFY_CLOSE:
+	{
+		struct vfio_dma *dma, *dma_last = NULL;
+		int retries = 0;
+
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
+		INIT_WORK(&pfnmap->work, unregister_vma_bg);
+		schedule_work(&pfnmap->work);
+
+		break;
+	}
+	}
+
+	return NOTIFY_OK;
+}
+
+static int vaddr_get_pfn(struct vfio_iommu *iommu, struct vfio_dma *dma,
+			 struct mm_struct *mm, unsigned long vaddr,
+			 unsigned long *pfn)
 {
 	struct page *page[1];
 	struct vm_area_struct *vma;
 	unsigned int flags = 0;
 	int ret;
 
-	if (prot & IOMMU_WRITE)
+	if (dma->prot & IOMMU_WRITE)
 		flags |= FOLL_WRITE;
 
 	mmap_read_lock(mm);
@@ -521,12 +627,40 @@ static int vaddr_get_pfn(struct mm_struct *mm, unsigned long vaddr,
 	vma = find_vma_intersection(mm, vaddr, vaddr + 1);
 
 	if (vma && vma->vm_flags & VM_PFNMAP) {
-		ret = follow_fault_pfn(vma, mm, vaddr, pfn, prot & IOMMU_WRITE);
+		ret = follow_fault_pfn(vma, mm, vaddr, pfn,
+				       dma->prot & IOMMU_WRITE);
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
+			void *opaque;
+
+			pfnmap = kzalloc(sizeof(*pfnmap), GFP_KERNEL);
+			if (!pfnmap) {
+				ret = -ENOMEM;
+				goto done;
+			}
+
+			pfnmap->iommu = iommu;
+			pfnmap->nb.notifier_call = vfio_vma_nb_cb;
+			opaque = vfio_register_vma_nb(vma, &pfnmap->nb);
+			if (IS_ERR(opaque)) {
+				kfree(pfnmap);
+				if (strict_mmio_maps) {
+					ret = PTR_ERR(opaque);
+					goto done;
+				}
+			} else {
+				pfnmap->opaque = opaque;
+				dma->pfnmap = pfnmap;
+			}
+		}
 	}
 done:
 	mmap_read_unlock(mm);
@@ -593,7 +727,8 @@ static int vfio_wait_all_valid(struct vfio_iommu *iommu)
  * the iommu can only map chunks of consecutive pfns anyway, so get the
  * first page and all consecutive pages with the same locking.
  */
-static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
+static long vfio_pin_pages_remote(struct vfio_iommu *iommu,
+				  struct vfio_dma *dma, unsigned long vaddr,
 				  long npage, unsigned long *pfn_base,
 				  unsigned long limit)
 {
@@ -606,7 +741,7 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
 	if (!current->mm)
 		return -ENODEV;
 
-	ret = vaddr_get_pfn(current->mm, vaddr, dma->prot, pfn_base);
+	ret = vaddr_get_pfn(iommu, dma, current->mm, vaddr, pfn_base);
 	if (ret)
 		return ret;
 
@@ -633,7 +768,7 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
 	/* Lock all the consecutive pages from pfn_base */
 	for (vaddr += PAGE_SIZE, iova += PAGE_SIZE; pinned < npage;
 	     pinned++, vaddr += PAGE_SIZE, iova += PAGE_SIZE) {
-		ret = vaddr_get_pfn(current->mm, vaddr, dma->prot, &pfn);
+		ret = vaddr_get_pfn(iommu, dma, current->mm, vaddr, &pfn);
 		if (ret)
 			break;
 
@@ -693,7 +828,8 @@ static long vfio_unpin_pages_remote(struct vfio_dma *dma, dma_addr_t iova,
 	return unlocked;
 }
 
-static int vfio_pin_page_external(struct vfio_dma *dma, unsigned long vaddr,
+static int vfio_pin_page_external(struct vfio_iommu *iommu,
+				  struct vfio_dma *dma, unsigned long vaddr,
 				  unsigned long *pfn_base, bool do_accounting)
 {
 	struct mm_struct *mm;
@@ -703,7 +839,7 @@ static int vfio_pin_page_external(struct vfio_dma *dma, unsigned long vaddr,
 	if (!mm)
 		return -ENODEV;
 
-	ret = vaddr_get_pfn(mm, vaddr, dma->prot, pfn_base);
+	ret = vaddr_get_pfn(iommu, dma, mm, vaddr, pfn_base);
 	if (!ret && do_accounting && !is_invalid_reserved_pfn(*pfn_base)) {
 		ret = vfio_lock_acct(dma, 1, true);
 		if (ret) {
@@ -811,8 +947,8 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
 		}
 
 		remote_vaddr = dma->vaddr + (iova - dma->iova);
-		ret = vfio_pin_page_external(dma, remote_vaddr, &phys_pfn[i],
-					     do_accounting);
+		ret = vfio_pin_page_external(iommu, dma, remote_vaddr,
+					     &phys_pfn[i], do_accounting);
 		if (ret)
 			goto pin_unwind;
 
@@ -1071,6 +1207,10 @@ static long vfio_unmap_unpin(struct vfio_iommu *iommu, struct vfio_dma *dma,
 static void vfio_remove_dma(struct vfio_iommu *iommu, struct vfio_dma *dma)
 {
 	WARN_ON(!RB_EMPTY_ROOT(&dma->pfn_list));
+	if (dma->pfnmap) {
+		vfio_unregister_vma_nb(dma->pfnmap->opaque);
+		kfree(dma->pfnmap);
+	}
 	vfio_unmap_unpin(iommu, dma, true);
 	vfio_unlink_dma(iommu, dma);
 	put_task_struct(dma->task);
@@ -1318,29 +1458,7 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
 			continue;
 		}
 
-		if (!RB_EMPTY_ROOT(&dma->pfn_list)) {
-			struct vfio_iommu_type1_dma_unmap nb_unmap;
-
-			if (dma_last == dma) {
-				BUG_ON(++retries > 10);
-			} else {
-				dma_last = dma;
-				retries = 0;
-			}
-
-			nb_unmap.iova = dma->iova;
-			nb_unmap.size = dma->size;
-
-			/*
-			 * Notify anyone (mdev vendor drivers) to invalidate and
-			 * unmap iovas within the range we're about to unmap.
-			 * Vendor drivers MUST unpin pages in response to an
-			 * invalidation.
-			 */
-			mutex_unlock(&iommu->lock);
-			blocking_notifier_call_chain(&iommu->notifier,
-						    VFIO_IOMMU_NOTIFY_DMA_UNMAP,
-						    &nb_unmap);
+		if (unmap_dma_pfn_list(iommu, dma, &dma_last, &retries)) {
 			mutex_lock(&iommu->lock);
 			goto again;
 		}
@@ -1404,7 +1522,7 @@ static int vfio_pin_map_dma(struct vfio_iommu *iommu, struct vfio_dma *dma,
 
 	while (size) {
 		/* Pin a contiguous chunk of memory */
-		npage = vfio_pin_pages_remote(dma, vaddr + dma->size,
+		npage = vfio_pin_pages_remote(iommu, dma, vaddr + dma->size,
 					      size >> PAGE_SHIFT, &pfn, limit);
 		if (npage <= 0) {
 			WARN_ON(!npage);
@@ -1660,7 +1778,7 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
 				size_t n = dma->iova + dma->size - iova;
 				long npage;
 
-				npage = vfio_pin_pages_remote(dma, vaddr,
+				npage = vfio_pin_pages_remote(iommu, dma, vaddr,
 							      n >> PAGE_SHIFT,
 							      &pfn, limit);
 				if (npage <= 0) {

