Return-Path: <kvm+bounces-18081-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A0D1A8CDB24
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 21:57:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C36FB1C20EF6
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 19:57:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87C4B84D27;
	Thu, 23 May 2024 19:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XYDveyGm"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B120084A40
	for <kvm@vger.kernel.org>; Thu, 23 May 2024 19:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716494206; cv=none; b=OLr1BgJhKOagVy1cQKpu28PO0BD53DUx3RDPxMiPjGrxvSxAW/+BuNLjTaSVBAjqCzci8TKwHHycHBFxZ2fIS2HkbwcTa+OeSi3O9RFQgCSrk7o95QWvpQK6EKZQJIdNg4SZD3UOOz6YCbsW48DiDzW/6CCc3DTv0hi4FrEqrKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716494206; c=relaxed/simple;
	bh=vimVJkhLSDJkmM8OUSAWTCwIVYW9QCFVX8agqE6pDCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XhhknC7VAGPobfYk+eYHKg2eBpusRFfaJN4vi4o7plUvgH1aIxWggPtVXyTwq0LSUlOG71MXM0iFVgzI/ZetFlvkUoKNO4V0Ridgrt+UNj3Ov8TCP7n+kxXUNNCnvh8H+WBws1Z/Vyvy7EAziTCSj28heYw4UxOobezKL6pw8XM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XYDveyGm; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716494203;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=djDjyWf0dGnGsdIVoYQiUrfvW7pqCnKUi679Uolm04A=;
	b=XYDveyGm4j0ujfm8kVvbAjLm1Ib1pu6K1vyN20XH6hj9Q8m4+cvcCKa4e64gODmbtGmjvL
	NlKqLNG8URZQabplBFWfFCmm5ebhmdhgIp7izlT/db2zIxM6dexLaaQZVrlV3pVSN7+8/M
	RgM7EcvkXlzoYIYr6QdLg/yJtySPA2s=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-159-Vg6vIAbcO1eKuKYxKgp2_g-1; Thu,
 23 May 2024 15:56:41 -0400
X-MC-Unique: Vg6vIAbcO1eKuKYxKgp2_g-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6EAFF3C025B9;
	Thu, 23 May 2024 19:56:40 +0000 (UTC)
Received: from omen.home.shazbot.org (unknown [10.22.34.52])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 74148492BC6;
	Thu, 23 May 2024 19:56:39 +0000 (UTC)
From: Alex Williamson <alex.williamson@redhat.com>
To: kvm@vger.kernel.org
Cc: Alex Williamson <alex.williamson@redhat.com>,
	ajones@ventanamicro.com,
	yan.y.zhao@intel.com,
	kevin.tian@intel.com,
	jgg@nvidia.com,
	peterx@redhat.com
Subject: [PATCH 2/2] vfio/pci: Use unmap_mapping_range()
Date: Thu, 23 May 2024 13:56:27 -0600
Message-ID: <20240523195629.218043-3-alex.williamson@redhat.com>
In-Reply-To: <20240523195629.218043-1-alex.williamson@redhat.com>
References: <20240523195629.218043-1-alex.williamson@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9

With the vfio device fd tied to the address space of the pseudo fs
inode, we can use the mm to track all vmas that might be mmap'ing
device BARs, which removes our vma_list and all the complicated lock
ordering necessary to manually zap each related vma.

Note that we can no longer store the pfn in vm_pgoff if we want to use
unmap_mapping_range() to zap a selective portion of the device fd
corresponding to BAR mappings.

This also converts our mmap fault handler to use vmf_insert_pfn()
because we no longer have a vma_list to avoid the concurrency problem
with io_remap_pfn_range().  The goal is to eventually use the vm_ops
huge_fault handler to avoid the additional faulting overhead, but
vmf_insert_pfn_{pmd,pud}() need to learn about pfnmaps first.

Also, Jason notes that a race exists between unmap_mapping_range() and
the fops mmap callback if we were to call io_remap_pfn_range() to
populate the vma on mmap.  Specifically, mmap_region() does call_mmap()
before it does vma_link_file() which gives a window where the vma is
populated but invisible to unmap_mapping_range().

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 256 +++++++------------------------
 include/linux/vfio_pci_core.h    |   2 -
 2 files changed, 56 insertions(+), 202 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 80cae87fff36..234e23ecaa94 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1610,100 +1610,20 @@ ssize_t vfio_pci_core_write(struct vfio_device *core_vdev, const char __user *bu
 }
 EXPORT_SYMBOL_GPL(vfio_pci_core_write);
 
-/* Return 1 on zap and vma_lock acquired, 0 on contention (only with @try) */
-static int vfio_pci_zap_and_vma_lock(struct vfio_pci_core_device *vdev, bool try)
+static void vfio_pci_zap_bars(struct vfio_pci_core_device *vdev)
 {
-	struct vfio_pci_mmap_vma *mmap_vma, *tmp;
+	struct vfio_device *core_vdev = &vdev->vdev;
+	loff_t start = VFIO_PCI_INDEX_TO_OFFSET(VFIO_PCI_BAR0_REGION_INDEX);
+	loff_t end = VFIO_PCI_INDEX_TO_OFFSET(VFIO_PCI_ROM_REGION_INDEX);
+	loff_t len = end - start;
 
-	/*
-	 * Lock ordering:
-	 * vma_lock is nested under mmap_lock for vm_ops callback paths.
-	 * The memory_lock semaphore is used by both code paths calling
-	 * into this function to zap vmas and the vm_ops.fault callback
-	 * to protect the memory enable state of the device.
-	 *
-	 * When zapping vmas we need to maintain the mmap_lock => vma_lock
-	 * ordering, which requires using vma_lock to walk vma_list to
-	 * acquire an mm, then dropping vma_lock to get the mmap_lock and
-	 * reacquiring vma_lock.  This logic is derived from similar
-	 * requirements in uverbs_user_mmap_disassociate().
-	 *
-	 * mmap_lock must always be the top-level lock when it is taken.
-	 * Therefore we can only hold the memory_lock write lock when
-	 * vma_list is empty, as we'd need to take mmap_lock to clear
-	 * entries.  vma_list can only be guaranteed empty when holding
-	 * vma_lock, thus memory_lock is nested under vma_lock.
-	 *
-	 * This enables the vm_ops.fault callback to acquire vma_lock,
-	 * followed by memory_lock read lock, while already holding
-	 * mmap_lock without risk of deadlock.
-	 */
-	while (1) {
-		struct mm_struct *mm = NULL;
-
-		if (try) {
-			if (!mutex_trylock(&vdev->vma_lock))
-				return 0;
-		} else {
-			mutex_lock(&vdev->vma_lock);
-		}
-		while (!list_empty(&vdev->vma_list)) {
-			mmap_vma = list_first_entry(&vdev->vma_list,
-						    struct vfio_pci_mmap_vma,
-						    vma_next);
-			mm = mmap_vma->vma->vm_mm;
-			if (mmget_not_zero(mm))
-				break;
-
-			list_del(&mmap_vma->vma_next);
-			kfree(mmap_vma);
-			mm = NULL;
-		}
-		if (!mm)
-			return 1;
-		mutex_unlock(&vdev->vma_lock);
-
-		if (try) {
-			if (!mmap_read_trylock(mm)) {
-				mmput(mm);
-				return 0;
-			}
-		} else {
-			mmap_read_lock(mm);
-		}
-		if (try) {
-			if (!mutex_trylock(&vdev->vma_lock)) {
-				mmap_read_unlock(mm);
-				mmput(mm);
-				return 0;
-			}
-		} else {
-			mutex_lock(&vdev->vma_lock);
-		}
-		list_for_each_entry_safe(mmap_vma, tmp,
-					 &vdev->vma_list, vma_next) {
-			struct vm_area_struct *vma = mmap_vma->vma;
-
-			if (vma->vm_mm != mm)
-				continue;
-
-			list_del(&mmap_vma->vma_next);
-			kfree(mmap_vma);
-
-			zap_vma_ptes(vma, vma->vm_start,
-				     vma->vm_end - vma->vm_start);
-		}
-		mutex_unlock(&vdev->vma_lock);
-		mmap_read_unlock(mm);
-		mmput(mm);
-	}
+	unmap_mapping_range(core_vdev->inode->i_mapping, start, len, true);
 }
 
 void vfio_pci_zap_and_down_write_memory_lock(struct vfio_pci_core_device *vdev)
 {
-	vfio_pci_zap_and_vma_lock(vdev, false);
 	down_write(&vdev->memory_lock);
-	mutex_unlock(&vdev->vma_lock);
+	vfio_pci_zap_bars(vdev);
 }
 
 u16 vfio_pci_memory_lock_and_enable(struct vfio_pci_core_device *vdev)
@@ -1725,99 +1645,48 @@ void vfio_pci_memory_unlock_and_restore(struct vfio_pci_core_device *vdev, u16 c
 	up_write(&vdev->memory_lock);
 }
 
-/* Caller holds vma_lock */
-static int __vfio_pci_add_vma(struct vfio_pci_core_device *vdev,
-			      struct vm_area_struct *vma)
+static int vma_to_pfn(struct vm_area_struct *vma, unsigned long *pfn)
 {
-	struct vfio_pci_mmap_vma *mmap_vma;
-
-	mmap_vma = kmalloc(sizeof(*mmap_vma), GFP_KERNEL_ACCOUNT);
-	if (!mmap_vma)
-		return -ENOMEM;
-
-	mmap_vma->vma = vma;
-	list_add(&mmap_vma->vma_next, &vdev->vma_list);
+	struct vfio_pci_core_device *vdev = vma->vm_private_data;
+	int index = vma->vm_pgoff >> (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT);
+	u64 pgoff;
 
-	return 0;
-}
+	if (index >= VFIO_PCI_ROM_REGION_INDEX ||
+	    !vdev->bar_mmap_supported[index] || !vdev->barmap[index])
+		return -EINVAL;
 
-/*
- * Zap mmaps on open so that we can fault them in on access and therefore
- * our vma_list only tracks mappings accessed since last zap.
- */
-static void vfio_pci_mmap_open(struct vm_area_struct *vma)
-{
-	zap_vma_ptes(vma, vma->vm_start, vma->vm_end - vma->vm_start);
-}
+	pgoff = vma->vm_pgoff &
+		((1U << (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
 
-static void vfio_pci_mmap_close(struct vm_area_struct *vma)
-{
-	struct vfio_pci_core_device *vdev = vma->vm_private_data;
-	struct vfio_pci_mmap_vma *mmap_vma;
+	*pfn = (pci_resource_start(vdev->pdev, index) >> PAGE_SHIFT) + pgoff;
 
-	mutex_lock(&vdev->vma_lock);
-	list_for_each_entry(mmap_vma, &vdev->vma_list, vma_next) {
-		if (mmap_vma->vma == vma) {
-			list_del(&mmap_vma->vma_next);
-			kfree(mmap_vma);
-			break;
-		}
-	}
-	mutex_unlock(&vdev->vma_lock);
+	return 0;
 }
 
 static vm_fault_t vfio_pci_mmap_fault(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
 	struct vfio_pci_core_device *vdev = vma->vm_private_data;
-	struct vfio_pci_mmap_vma *mmap_vma;
-	vm_fault_t ret = VM_FAULT_NOPAGE;
+	unsigned long pfn, pgoff = vmf->pgoff - vma->vm_pgoff;
+	vm_fault_t ret = VM_FAULT_SIGBUS;
 
-	mutex_lock(&vdev->vma_lock);
-	down_read(&vdev->memory_lock);
-
-	/*
-	 * Memory region cannot be accessed if the low power feature is engaged
-	 * or memory access is disabled.
-	 */
-	if (vdev->pm_runtime_engaged || !__vfio_pci_memory_enabled(vdev)) {
-		ret = VM_FAULT_SIGBUS;
-		goto up_out;
-	}
+	if (vma_to_pfn(vma, &pfn))
+		return ret;
 
-	/*
-	 * We populate the whole vma on fault, so we need to test whether
-	 * the vma has already been mapped, such as for concurrent faults
-	 * to the same vma.  io_remap_pfn_range() will trigger a BUG_ON if
-	 * we ask it to fill the same range again.
-	 */
-	list_for_each_entry(mmap_vma, &vdev->vma_list, vma_next) {
-		if (mmap_vma->vma == vma)
-			goto up_out;
-	}
+	down_read(&vdev->memory_lock);
 
-	if (io_remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
-			       vma->vm_end - vma->vm_start,
-			       vma->vm_page_prot)) {
-		ret = VM_FAULT_SIGBUS;
-		zap_vma_ptes(vma, vma->vm_start, vma->vm_end - vma->vm_start);
-		goto up_out;
-	}
+	if (vdev->pm_runtime_engaged || !__vfio_pci_memory_enabled(vdev))
+		goto out_disabled;
 
-	if (__vfio_pci_add_vma(vdev, vma)) {
-		ret = VM_FAULT_OOM;
-		zap_vma_ptes(vma, vma->vm_start, vma->vm_end - vma->vm_start);
-	}
+	ret = vmf_insert_pfn(vma, vmf->address, pfn + pgoff);
 
-up_out:
+out_disabled:
 	up_read(&vdev->memory_lock);
-	mutex_unlock(&vdev->vma_lock);
+
 	return ret;
 }
 
 static const struct vm_operations_struct vfio_pci_mmap_ops = {
-	.open = vfio_pci_mmap_open,
-	.close = vfio_pci_mmap_close,
 	.fault = vfio_pci_mmap_fault,
 };
 
@@ -1880,11 +1749,12 @@ int vfio_pci_core_mmap(struct vfio_device *core_vdev, struct vm_area_struct *vma
 
 	vma->vm_private_data = vdev;
 	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
-	vma->vm_pgoff = (pci_resource_start(pdev, index) >> PAGE_SHIFT) + pgoff;
+	vma->vm_page_prot = pgprot_decrypted(vma->vm_page_prot);
 
 	/*
-	 * See remap_pfn_range(), called from vfio_pci_fault() but we can't
-	 * change vm_flags within the fault handler.  Set them now.
+	 * Set vm_flags now, they should not be changed in the fault handler.
+	 * We want the same flags and page protection (decrypted above) as
+	 * io_remap_pfn_range() would set.
 	 *
 	 * VM_ALLOW_ANY_UNCACHED: The VMA flag is implemented for ARM64,
 	 * allowing KVM stage 2 device mapping attributes to use Normal-NC
@@ -2202,8 +2072,6 @@ int vfio_pci_core_init_dev(struct vfio_device *core_vdev)
 	mutex_init(&vdev->ioeventfds_lock);
 	INIT_LIST_HEAD(&vdev->dummy_resources_list);
 	INIT_LIST_HEAD(&vdev->ioeventfds_list);
-	mutex_init(&vdev->vma_lock);
-	INIT_LIST_HEAD(&vdev->vma_list);
 	INIT_LIST_HEAD(&vdev->sriov_pfs_item);
 	init_rwsem(&vdev->memory_lock);
 	xa_init(&vdev->ctx);
@@ -2219,7 +2087,6 @@ void vfio_pci_core_release_dev(struct vfio_device *core_vdev)
 
 	mutex_destroy(&vdev->igate);
 	mutex_destroy(&vdev->ioeventfds_lock);
-	mutex_destroy(&vdev->vma_lock);
 	kfree(vdev->region);
 	kfree(vdev->pm_save);
 }
@@ -2506,17 +2373,11 @@ static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
 				      struct vfio_pci_group_info *groups,
 				      struct iommufd_ctx *iommufd_ctx)
 {
-	struct vfio_pci_core_device *cur_mem;
-	struct vfio_pci_core_device *cur_vma;
-	struct vfio_pci_core_device *cur;
+	struct vfio_pci_core_device *vdev;
 	struct pci_dev *pdev;
-	bool is_mem = true;
 	int ret;
 
 	mutex_lock(&dev_set->lock);
-	cur_mem = list_first_entry(&dev_set->device_list,
-				   struct vfio_pci_core_device,
-				   vdev.dev_set_list);
 
 	pdev = vfio_pci_dev_set_resettable(dev_set);
 	if (!pdev) {
@@ -2533,7 +2394,7 @@ static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
 	if (ret)
 		goto err_unlock;
 
-	list_for_each_entry(cur_vma, &dev_set->device_list, vdev.dev_set_list) {
+	list_for_each_entry(vdev, &dev_set->device_list, vdev.dev_set_list) {
 		bool owned;
 
 		/*
@@ -2557,38 +2418,36 @@ static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
 		 * Otherwise, reset is not allowed.
 		 */
 		if (iommufd_ctx) {
-			int devid = vfio_iommufd_get_dev_id(&cur_vma->vdev,
+			int devid = vfio_iommufd_get_dev_id(&vdev->vdev,
 							    iommufd_ctx);
 
 			owned = (devid > 0 || devid == -ENOENT);
 		} else {
-			owned = vfio_dev_in_groups(&cur_vma->vdev, groups);
+			owned = vfio_dev_in_groups(&vdev->vdev, groups);
 		}
 
 		if (!owned) {
 			ret = -EINVAL;
-			goto err_undo;
+			break;
 		}
 
 		/*
 		 * Locking multiple devices is prone to deadlock, runaway and
 		 * unwind if we hit contention.
 		 */
-		if (!vfio_pci_zap_and_vma_lock(cur_vma, true)) {
+		if (!down_write_trylock(&vdev->memory_lock)) {
 			ret = -EBUSY;
-			goto err_undo;
+			break;
 		}
+
+		vfio_pci_zap_bars(vdev);
 	}
-	cur_vma = NULL;
 
-	list_for_each_entry(cur_mem, &dev_set->device_list, vdev.dev_set_list) {
-		if (!down_write_trylock(&cur_mem->memory_lock)) {
-			ret = -EBUSY;
-			goto err_undo;
-		}
-		mutex_unlock(&cur_mem->vma_lock);
+	if (!list_entry_is_head(vdev,
+				&dev_set->device_list, vdev.dev_set_list)) {
+		vdev = list_prev_entry(vdev, vdev.dev_set_list);
+		goto err_undo;
 	}
-	cur_mem = NULL;
 
 	/*
 	 * The pci_reset_bus() will reset all the devices in the bus.
@@ -2599,25 +2458,22 @@ static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
 	 * cause the PCI config space reset without restoring the original
 	 * state (saved locally in 'vdev->pm_save').
 	 */
-	list_for_each_entry(cur, &dev_set->device_list, vdev.dev_set_list)
-		vfio_pci_set_power_state(cur, PCI_D0);
+	list_for_each_entry(vdev, &dev_set->device_list, vdev.dev_set_list)
+		vfio_pci_set_power_state(vdev, PCI_D0);
 
 	ret = pci_reset_bus(pdev);
 
+	vdev = list_last_entry(&dev_set->device_list,
+			       struct vfio_pci_core_device, vdev.dev_set_list);
+
 err_undo:
-	list_for_each_entry(cur, &dev_set->device_list, vdev.dev_set_list) {
-		if (cur == cur_mem)
-			is_mem = false;
-		if (cur == cur_vma)
-			break;
-		if (is_mem)
-			up_write(&cur->memory_lock);
-		else
-			mutex_unlock(&cur->vma_lock);
-	}
+	list_for_each_entry_from_reverse(vdev, &dev_set->device_list,
+					 vdev.dev_set_list)
+		up_write(&vdev->memory_lock);
+
+	list_for_each_entry(vdev, &dev_set->device_list, vdev.dev_set_list)
+		pm_runtime_put(&vdev->pdev->dev);
 
-	list_for_each_entry(cur, &dev_set->device_list, vdev.dev_set_list)
-		pm_runtime_put(&cur->pdev->dev);
 err_unlock:
 	mutex_unlock(&dev_set->lock);
 	return ret;
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index a2c8b8bba711..f87067438ed4 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -93,8 +93,6 @@ struct vfio_pci_core_device {
 	struct list_head		sriov_pfs_item;
 	struct vfio_pci_core_device	*sriov_pf_core_dev;
 	struct notifier_block	nb;
-	struct mutex		vma_lock;
-	struct list_head	vma_list;
 	struct rw_semaphore	memory_lock;
 };
 
-- 
2.45.0


