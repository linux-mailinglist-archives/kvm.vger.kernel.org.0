Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78BDF1D36FB
	for <lists+kvm@lfdr.de>; Thu, 14 May 2020 18:52:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726067AbgENQwK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 May 2020 12:52:10 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:36641 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726046AbgENQwJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 May 2020 12:52:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589475127;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0cBlEyN+N4Yp8SqlcEWmTzn29c4RHTyzWyxxzGkYcYs=;
        b=GgrahZ6CAmBuP9rirw6S42IoIiCp6ddEBRSNntyj9dc2KXLqcO5QpJqUWgfyo6l2I5C76e
        rnWkyXMfXwMQ+kEB9K55onBSMcLcA/tFFmo9EudJ/pL7TnajQV5WwkdFjU48zcEIbasxFR
        djGR2cCGytPXwIxYvMP2DPucb0bAS+I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-433-2XPFKq8ZNbqZt_HPQ1DmuA-1; Thu, 14 May 2020 12:52:05 -0400
X-MC-Unique: 2XPFKq8ZNbqZt_HPQ1DmuA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 61B4F1005510;
        Thu, 14 May 2020 16:52:04 +0000 (UTC)
Received: from gimli.home (ovpn-113-111.phx2.redhat.com [10.3.113.111])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AF9AF620AF;
        Thu, 14 May 2020 16:51:58 +0000 (UTC)
Subject: [PATCH 1/2] vfio: Introduce bus driver to IOMMU invalidation
 interface
From:   Alex Williamson <alex.williamson@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, cohuck@redhat.com, jgg@ziepe.ca,
        peterx@redhat.com
Date:   Thu, 14 May 2020 10:51:58 -0600
Message-ID: <158947511830.12590.15083888449284990563.stgit@gimli.home>
In-Reply-To: <158947414729.12590.4345248265094886807.stgit@gimli.home>
References: <158947414729.12590.4345248265094886807.stgit@gimli.home>
User-Agent: StGit/0.19-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

VFIO bus drivers, like vfio-pci, can allow mmaps of non-page backed
device memory, such as MMIO regions of the device.  The user may then
map these ranges through the IOMMU, for example to enable peer-to-peer
DMA between devices.  When these ranges are zapped or removed from the
user, such as when the MMIO region is disabled or the device is
released, we should also remove the IOMMU mapping.  This provides
kernel level enforcement of the behavior we already see from userspace
drivers like QEMU, where these ranges are unmapped when they become
inaccessible.  This userspace behavior is still recommended as this
support only provides invalidation, dropping unmapped vmas.  Those
vmas are not automatically re-installed when re-mapped.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/pci/vfio_pci.c         |   34 +++++++++-
 drivers/vfio/pci/vfio_pci_private.h |    1 
 drivers/vfio/vfio.c                 |   14 ++++
 drivers/vfio/vfio_iommu_type1.c     |  123 ++++++++++++++++++++++++++---------
 include/linux/vfio.h                |    5 +
 5 files changed, 142 insertions(+), 35 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 49ae9faa6099..100fe5f6bc22 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -521,6 +521,8 @@ static void vfio_pci_release(void *device_data)
 		vfio_pci_vf_token_user_add(vdev, -1);
 		vfio_spapr_pci_eeh_release(vdev->pdev);
 		vfio_pci_disable(vdev);
+		vfio_group_put_external_user(vdev->group);
+		vdev->group = NULL;
 	}
 
 	mutex_unlock(&vdev->reflck->lock);
@@ -539,6 +541,15 @@ static int vfio_pci_open(void *device_data)
 	mutex_lock(&vdev->reflck->lock);
 
 	if (!vdev->refcnt) {
+		struct pci_dev *pdev = vdev->pdev;
+
+		vdev->group = vfio_group_get_external_user_from_dev(&pdev->dev);
+		if (IS_ERR_OR_NULL(vdev->group)) {
+			ret = PTR_ERR(vdev->group);
+			vdev->group = NULL;
+			goto error;
+		}
+
 		ret = vfio_pci_enable(vdev);
 		if (ret)
 			goto error;
@@ -549,8 +560,13 @@ static int vfio_pci_open(void *device_data)
 	vdev->refcnt++;
 error:
 	mutex_unlock(&vdev->reflck->lock);
-	if (ret)
+	if (ret) {
 		module_put(THIS_MODULE);
+		if (vdev->group) {
+			vfio_group_put_external_user(vdev->group);
+			vdev->group = NULL;
+		}
+	}
 	return ret;
 }
 
@@ -1370,7 +1386,7 @@ static ssize_t vfio_pci_write(void *device_data, const char __user *buf,
 /* Return 1 on zap and vma_lock acquired, 0 on contention (only with @try) */
 static int vfio_pci_zap_and_vma_lock(struct vfio_pci_device *vdev, bool try)
 {
-	struct vfio_pci_mmap_vma *mmap_vma, *tmp;
+	struct vfio_pci_mmap_vma *mmap_vma;
 
 	/*
 	 * Lock ordering:
@@ -1420,6 +1436,7 @@ static int vfio_pci_zap_and_vma_lock(struct vfio_pci_device *vdev, bool try)
 			return 1;
 		mutex_unlock(&vdev->vma_lock);
 
+again:
 		if (try) {
 			if (!down_read_trylock(&mm->mmap_sem)) {
 				mmput(mm);
@@ -1438,8 +1455,8 @@ static int vfio_pci_zap_and_vma_lock(struct vfio_pci_device *vdev, bool try)
 			} else {
 				mutex_lock(&vdev->vma_lock);
 			}
-			list_for_each_entry_safe(mmap_vma, tmp,
-						 &vdev->vma_list, vma_next) {
+			list_for_each_entry(mmap_vma,
+					    &vdev->vma_list, vma_next) {
 				struct vm_area_struct *vma = mmap_vma->vma;
 
 				if (vma->vm_mm != mm)
@@ -1450,6 +1467,10 @@ static int vfio_pci_zap_and_vma_lock(struct vfio_pci_device *vdev, bool try)
 
 				zap_vma_ptes(vma, vma->vm_start,
 					     vma->vm_end - vma->vm_start);
+				mutex_unlock(&vdev->vma_lock);
+				up_read(&mm->mmap_sem);
+				vfio_invalidate_pfnmap_vma(vdev->group, vma);
+				goto again;
 			}
 			mutex_unlock(&vdev->vma_lock);
 		}
@@ -1494,16 +1515,21 @@ static void vfio_pci_mmap_close(struct vm_area_struct *vma)
 {
 	struct vfio_pci_device *vdev = vma->vm_private_data;
 	struct vfio_pci_mmap_vma *mmap_vma;
+	bool found = false;
 
 	mutex_lock(&vdev->vma_lock);
 	list_for_each_entry(mmap_vma, &vdev->vma_list, vma_next) {
 		if (mmap_vma->vma == vma) {
 			list_del(&mmap_vma->vma_next);
 			kfree(mmap_vma);
+			found = true;
 			break;
 		}
 	}
 	mutex_unlock(&vdev->vma_lock);
+
+	if (found)
+		vfio_invalidate_pfnmap_vma(vdev->group, vma);
 }
 
 static vm_fault_t vfio_pci_mmap_fault(struct vm_fault *vmf)
diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/vfio_pci_private.h
index c4f25f1e80d7..abfb60674506 100644
--- a/drivers/vfio/pci/vfio_pci_private.h
+++ b/drivers/vfio/pci/vfio_pci_private.h
@@ -140,6 +140,7 @@ struct vfio_pci_device {
 	struct mutex		vma_lock;
 	struct list_head	vma_list;
 	struct rw_semaphore	memory_lock;
+	struct vfio_group	*group;
 };
 
 #define is_intx(vdev) (vdev->irq_type == VFIO_PCI_INTX_IRQ_INDEX)
diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 765e0e5d83ed..0fff057b7cd9 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -2151,6 +2151,20 @@ int vfio_dma_rw(struct vfio_group *group, dma_addr_t user_iova,
 }
 EXPORT_SYMBOL(vfio_dma_rw);
 
+void vfio_invalidate_pfnmap_vma(struct vfio_group *group,
+				struct vm_area_struct *vma)
+{
+	struct vfio_container *container;
+	struct vfio_iommu_driver *driver;
+
+	container = group->container;
+	driver = container->iommu_driver;
+
+	if (likely(driver && driver->ops->invalidate_pfnmap_vma))
+		driver->ops->invalidate_pfnmap_vma(container->iommu_data, vma);
+}
+EXPORT_SYMBOL(vfio_invalidate_pfnmap_vma);
+
 static int vfio_register_iommu_notifier(struct vfio_group *group,
 					unsigned long *events,
 					struct notifier_block *nb)
diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 4a4cb7cd86b2..62ba6bd8a486 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -91,6 +91,7 @@ struct vfio_dma {
 	bool			lock_cap;	/* capable(CAP_IPC_LOCK) */
 	struct task_struct	*task;
 	struct rb_root		pfn_list;	/* Ex-user pinned pfn list */
+	struct vm_area_struct	*pfnmap_vma;
 };
 
 struct vfio_group {
@@ -343,21 +344,25 @@ static int follow_fault_pfn(struct vm_area_struct *vma, struct mm_struct *mm,
 	return ret;
 }
 
-static int vaddr_get_pfn(struct mm_struct *mm, unsigned long vaddr,
-			 int prot, unsigned long *pfn)
+static int vaddr_get_pfn(struct vfio_dma *dma, struct mm_struct *mm,
+			 unsigned long vaddr, unsigned long *pfn)
 {
 	struct page *page[1];
 	struct vm_area_struct *vma;
 	unsigned int flags = 0;
 	int ret;
 
-	if (prot & IOMMU_WRITE)
+	if (dma->prot & IOMMU_WRITE)
 		flags |= FOLL_WRITE;
 
 	down_read(&mm->mmap_sem);
 	ret = pin_user_pages_remote(NULL, mm, vaddr, 1, flags | FOLL_LONGTERM,
 				    page, NULL, NULL);
 	if (ret == 1) {
+		if (dma->pfnmap_vma) {
+			unpin_user_page(page[0]);
+			return -EINVAL;
+		}
 		*pfn = page_to_pfn(page[0]);
 		ret = 0;
 		goto done;
@@ -369,7 +374,15 @@ static int vaddr_get_pfn(struct mm_struct *mm, unsigned long vaddr,
 	vma = find_vma_intersection(mm, vaddr, vaddr + 1);
 
 	if (vma && vma->vm_flags & VM_PFNMAP) {
-		ret = follow_fault_pfn(vma, mm, vaddr, pfn, prot & IOMMU_WRITE);
+		if ((dma->pfnmap_vma && dma->pfnmap_vma != vma) ||
+		    (!dma->pfnmap_vma && vaddr != dma->vaddr)) {
+			ret = -EPERM;
+			goto done;
+		}
+
+		dma->pfnmap_vma = vma;
+
+		ret = follow_fault_pfn(vma, mm, vaddr, pfn, flags & FOLL_WRITE);
 		if (ret == -EAGAIN)
 			goto retry;
 
@@ -399,7 +412,7 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
 	if (!current->mm)
 		return -ENODEV;
 
-	ret = vaddr_get_pfn(current->mm, vaddr, dma->prot, pfn_base);
+	ret = vaddr_get_pfn(dma, current->mm, vaddr, pfn_base);
 	if (ret)
 		return ret;
 
@@ -426,7 +439,7 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
 	/* Lock all the consecutive pages from pfn_base */
 	for (vaddr += PAGE_SIZE, iova += PAGE_SIZE; pinned < npage;
 	     pinned++, vaddr += PAGE_SIZE, iova += PAGE_SIZE) {
-		ret = vaddr_get_pfn(current->mm, vaddr, dma->prot, &pfn);
+		ret = vaddr_get_pfn(dma, current->mm, vaddr, &pfn);
 		if (ret)
 			break;
 
@@ -496,7 +509,7 @@ static int vfio_pin_page_external(struct vfio_dma *dma, unsigned long vaddr,
 	if (!mm)
 		return -ENODEV;
 
-	ret = vaddr_get_pfn(mm, vaddr, dma->prot, pfn_base);
+	ret = vaddr_get_pfn(dma, mm, vaddr, pfn_base);
 	if (!ret && do_accounting && !is_invalid_reserved_pfn(*pfn_base)) {
 		ret = vfio_lock_acct(dma, 1, true);
 		if (ret) {
@@ -860,6 +873,75 @@ static unsigned long vfio_pgsize_bitmap(struct vfio_iommu *iommu)
 	return bitmap;
 }
 
+static struct vfio_dma *vfio_find_dma_by_pfnmap_vma(struct vfio_iommu *iommu,
+						    struct vm_area_struct *vma)
+{
+	struct rb_node *node = rb_first(&iommu->dma_list);
+
+	for (; node; node = rb_next(node)) {
+		struct vfio_dma *dma = rb_entry(node, struct vfio_dma, node);
+
+		if (dma->pfnmap_vma == vma)
+			return dma;
+	}
+
+	return NULL;
+}
+
+/*
+ * Called with iommu->lock
+ * Return 1 if lock dropped to notify pfn holders, zero otherwise
+ */
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
+	return 0;
+}
+
+static void vfio_iommu_type1_invalidate_pfnmap_vma(void *iommu_data,
+						   struct vm_area_struct *vma)
+{
+	struct vfio_iommu *iommu = iommu_data;
+	struct vfio_dma *dma, *dma_last = NULL;
+	int retries = 0;
+
+again:
+	mutex_lock(&iommu->lock);
+
+	while ((dma = vfio_find_dma_by_pfnmap_vma(iommu, vma))) {
+		if (unmap_dma_pfn_list(iommu, dma, &dma_last, &retries))
+			goto again;
+
+		vfio_remove_dma(iommu, dma);
+	}
+	mutex_unlock(&iommu->lock);
+}
+
 static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
 			     struct vfio_iommu_type1_dma_unmap *unmap)
 {
@@ -936,31 +1018,9 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
 		if (dma->task->mm != current->mm)
 			break;
 
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
+		if (unmap_dma_pfn_list(iommu, dma, &dma_last, &retries))
 			goto again;
-		}
+
 		unmapped += dma->size;
 		vfio_remove_dma(iommu, dma);
 	}
@@ -2423,6 +2483,7 @@ static const struct vfio_iommu_driver_ops vfio_iommu_driver_ops_type1 = {
 	.register_notifier	= vfio_iommu_type1_register_notifier,
 	.unregister_notifier	= vfio_iommu_type1_unregister_notifier,
 	.dma_rw			= vfio_iommu_type1_dma_rw,
+	.invalidate_pfnmap_vma	= vfio_iommu_type1_invalidate_pfnmap_vma,
 };
 
 static int __init vfio_iommu_type1_init(void)
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 5d92ee15d098..13abfecc1530 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -88,6 +88,8 @@ struct vfio_iommu_driver_ops {
 					       struct notifier_block *nb);
 	int		(*dma_rw)(void *iommu_data, dma_addr_t user_iova,
 				  void *data, size_t count, bool write);
+	void		(*invalidate_pfnmap_vma)(void *iommu_data,
+						 struct vm_area_struct *vma);
 };
 
 extern int vfio_register_iommu_driver(const struct vfio_iommu_driver_ops *ops);
@@ -124,6 +126,9 @@ extern int vfio_group_unpin_pages(struct vfio_group *group,
 extern int vfio_dma_rw(struct vfio_group *group, dma_addr_t user_iova,
 		       void *data, size_t len, bool write);
 
+extern void vfio_invalidate_pfnmap_vma(struct vfio_group *group,
+				       struct vm_area_struct *vma);
+
 /* each type has independent events */
 enum vfio_notify_type {
 	VFIO_IOMMU_NOTIFY = 0,

