Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F27893E1A07
	for <lists+kvm@lfdr.de>; Thu,  5 Aug 2021 19:07:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237315AbhHERH7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Aug 2021 13:07:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:52964 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237222AbhHERH7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 5 Aug 2021 13:07:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628183264;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TrIcgTaar+7Hjqmh1348IEVpYyHSuu9GUjxCpyciw8k=;
        b=Zvy5HgJojIbEcyzzEihvpeS6Ef8cES81Orj16OuKAoDHJSCO++GLWAALVKzOM2WiwNfm3s
        KfQmBKrm9ashcHcK+fkypQQRjYdEC1qxal4DhNE4f0f3xRuY7y2E8ToNGVJEW9FONJzhBw
        oi4cyjIuuf4MaOoT/yFwiq2kf3r+yEE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-144-HJigzVWqO36oHH9pqNAFLg-1; Thu, 05 Aug 2021 13:07:43 -0400
X-MC-Unique: HJigzVWqO36oHH9pqNAFLg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5F6291007B36;
        Thu,  5 Aug 2021 17:07:42 +0000 (UTC)
Received: from [172.30.41.16] (ovpn-113-77.phx2.redhat.com [10.3.113.77])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5AFFC226FB;
        Thu,  5 Aug 2021 17:07:35 +0000 (UTC)
Subject: [PATCH 3/7] vfio/pci: Use vfio_device_unmap_mapping_range()
From:   Alex Williamson <alex.williamson@redhat.com>
To:     alex.williamson@redhat.com
Cc:     Jason Gunthorpe <jgg@nvidia.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, jgg@nvidia.com, peterx@redhat.com
Date:   Thu, 05 Aug 2021 11:07:35 -0600
Message-ID: <162818325518.1511194.1243290800645603609.stgit@omen>
In-Reply-To: <162818167535.1511194.6614962507750594786.stgit@omen>
References: <162818167535.1511194.6614962507750594786.stgit@omen>
User-Agent: StGit/1.0-8-g6af9-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

With the vfio device fd tied to the address space of the pseudo fs
inode, we can use the mm to track all vmas that might be mmap'ing
device BARs, which removes our vma_list and all the complicated lock
ordering necessary to manually zap each related vma.

Note that we can no longer store the pfn in vm_pgoff if we want to use
unmap_mapping_range() to zap a selective portion of the device fd
corresponding to BAR mappings.

This also converts our mmap fault handler to use vmf_insert_pfn()
because we no longer have a vma_list to avoid the concurrency problem
with io_remap_pfn_range().  This is a step towards removing the fault
handler entirely, at which point we'll return to using
io_remap_pfn_range().

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/pci/vfio_pci.c         |  238 +++++++----------------------------
 drivers/vfio/pci/vfio_pci_private.h |    2 
 2 files changed, 49 insertions(+), 191 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 318864d52837..c526edbf1173 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -225,7 +225,7 @@ static void vfio_pci_probe_mmaps(struct vfio_pci_device *vdev)
 
 static void vfio_pci_try_bus_reset(struct vfio_pci_device *vdev);
 static void vfio_pci_disable(struct vfio_pci_device *vdev);
-static int vfio_pci_try_zap_and_vma_lock_cb(struct pci_dev *pdev, void *data);
+static int vfio_pci_mem_trylock_and_zap_cb(struct pci_dev *pdev, void *data);
 
 /*
  * INTx masking requires the ability to disable INTx signaling via PCI_COMMAND
@@ -1141,7 +1141,7 @@ static long vfio_pci_ioctl(struct vfio_device *core_vdev,
 		struct vfio_pci_group_info info;
 		struct vfio_devices devs = { .cur_index = 0 };
 		bool slot = false;
-		int i, group_idx, mem_idx = 0, count = 0, ret = 0;
+		int i, group_idx, count = 0, ret = 0;
 
 		minsz = offsetofend(struct vfio_pci_hot_reset, count);
 
@@ -1241,39 +1241,22 @@ static long vfio_pci_ioctl(struct vfio_device *core_vdev,
 		}
 
 		/*
-		 * We need to get memory_lock for each device, but devices
-		 * can share mmap_lock, therefore we need to zap and hold
-		 * the vma_lock for each device, and only then get each
-		 * memory_lock.
+		 * Try to get the memory_lock write lock for all devices and
+		 * zap all BAR mmaps.
 		 */
 		ret = vfio_pci_for_each_slot_or_bus(vdev->pdev,
-					    vfio_pci_try_zap_and_vma_lock_cb,
+					    vfio_pci_mem_trylock_and_zap_cb,
 					    &devs, slot);
-		if (ret)
-			goto hot_reset_release;
-
-		for (; mem_idx < devs.cur_index; mem_idx++) {
-			struct vfio_pci_device *tmp = devs.devices[mem_idx];
-
-			ret = down_write_trylock(&tmp->memory_lock);
-			if (!ret) {
-				ret = -EBUSY;
-				goto hot_reset_release;
-			}
-			mutex_unlock(&tmp->vma_lock);
-		}
 
 		/* User has access, do the reset */
-		ret = pci_reset_bus(vdev->pdev);
+		if (!ret)
+			ret = pci_reset_bus(vdev->pdev);
 
 hot_reset_release:
 		for (i = 0; i < devs.cur_index; i++) {
 			struct vfio_pci_device *tmp = devs.devices[i];
 
-			if (i < mem_idx)
-				up_write(&tmp->memory_lock);
-			else
-				mutex_unlock(&tmp->vma_lock);
+			up_write(&tmp->memory_lock);
 			vfio_device_put(&tmp->vdev);
 		}
 		kfree(devs.devices);
@@ -1424,100 +1407,18 @@ static ssize_t vfio_pci_write(struct vfio_device *core_vdev, const char __user *
 	return vfio_pci_rw(vdev, (char __user *)buf, count, ppos, true);
 }
 
-/* Return 1 on zap and vma_lock acquired, 0 on contention (only with @try) */
-static int vfio_pci_zap_and_vma_lock(struct vfio_pci_device *vdev, bool try)
+static void vfio_pci_zap_bars(struct vfio_pci_device *vdev)
 {
-	struct vfio_pci_mmap_vma *mmap_vma, *tmp;
-
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
+	vfio_device_unmap_mapping_range(&vdev->vdev,
+			VFIO_PCI_INDEX_TO_OFFSET(VFIO_PCI_BAR0_REGION_INDEX),
+			VFIO_PCI_INDEX_TO_OFFSET(VFIO_PCI_ROM_REGION_INDEX) -
+			VFIO_PCI_INDEX_TO_OFFSET(VFIO_PCI_BAR0_REGION_INDEX));
 }
 
 void vfio_pci_zap_and_down_write_memory_lock(struct vfio_pci_device *vdev)
 {
-	vfio_pci_zap_and_vma_lock(vdev, false);
 	down_write(&vdev->memory_lock);
-	mutex_unlock(&vdev->vma_lock);
+	vfio_pci_zap_bars(vdev);
 }
 
 u16 vfio_pci_memory_lock_and_enable(struct vfio_pci_device *vdev)
@@ -1539,95 +1440,58 @@ void vfio_pci_memory_unlock_and_restore(struct vfio_pci_device *vdev, u16 cmd)
 	up_write(&vdev->memory_lock);
 }
 
-/* Caller holds vma_lock */
-static int __vfio_pci_add_vma(struct vfio_pci_device *vdev,
-			      struct vm_area_struct *vma)
+static int vfio_pci_bar_vma_to_pfn(struct vm_area_struct *vma,
+				   unsigned long *pfn)
 {
-	struct vfio_pci_mmap_vma *mmap_vma;
-
-	mmap_vma = kmalloc(sizeof(*mmap_vma), GFP_KERNEL);
-	if (!mmap_vma)
-		return -ENOMEM;
+	struct vfio_pci_device *vdev = vma->vm_private_data;
+	struct pci_dev *pdev = vdev->pdev;
+	int index;
+	u64 pgoff;
 
-	mmap_vma->vma = vma;
-	list_add(&mmap_vma->vma_next, &vdev->vma_list);
+	index = vma->vm_pgoff >> (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT);
 
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
-	struct vfio_pci_device *vdev = vma->vm_private_data;
-	struct vfio_pci_mmap_vma *mmap_vma;
+	*pfn = (pci_resource_start(pdev, index) >> PAGE_SHIFT) + pgoff;
 
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
 	struct vfio_pci_device *vdev = vma->vm_private_data;
-	struct vfio_pci_mmap_vma *mmap_vma;
-	vm_fault_t ret = VM_FAULT_NOPAGE;
+	unsigned long vaddr, pfn;
+	vm_fault_t ret = VM_FAULT_SIGBUS;
 
-	mutex_lock(&vdev->vma_lock);
-	down_read(&vdev->memory_lock);
-
-	if (!__vfio_pci_memory_enabled(vdev)) {
-		ret = VM_FAULT_SIGBUS;
-		goto up_out;
-	}
-
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
+	if (vfio_pci_bar_vma_to_pfn(vma, &pfn))
+		return ret;
 
-	if (io_remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
-			       vma->vm_end - vma->vm_start,
-			       vma->vm_page_prot)) {
-		ret = VM_FAULT_SIGBUS;
-		zap_vma_ptes(vma, vma->vm_start, vma->vm_end - vma->vm_start);
-		goto up_out;
-	}
+	down_read(&vdev->memory_lock);
 
-	if (__vfio_pci_add_vma(vdev, vma)) {
-		ret = VM_FAULT_OOM;
-		zap_vma_ptes(vma, vma->vm_start, vma->vm_end - vma->vm_start);
+	if (__vfio_pci_memory_enabled(vdev)) {
+		for (vaddr = vma->vm_start;
+		     vaddr < vma->vm_end; vaddr += PAGE_SIZE, pfn++) {
+			ret = vmf_insert_pfn(vma, vaddr, pfn);
+			if (ret != VM_FAULT_NOPAGE) {
+				zap_vma_ptes(vma, vma->vm_start,
+					     vaddr - vma->vm_start);
+				break;
+			}
+		}
 	}
 
-up_out:
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
 
@@ -1690,7 +1554,7 @@ static int vfio_pci_mmap(struct vfio_device *core_vdev, struct vm_area_struct *v
 
 	vma->vm_private_data = vdev;
 	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
-	vma->vm_pgoff = (pci_resource_start(pdev, index) >> PAGE_SHIFT) + pgoff;
+	vma->vm_page_prot = pgprot_decrypted(vma->vm_page_prot);
 
 	/*
 	 * See remap_pfn_range(), called from vfio_pci_fault() but we can't
@@ -2016,8 +1880,6 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	mutex_init(&vdev->ioeventfds_lock);
 	INIT_LIST_HEAD(&vdev->dummy_resources_list);
 	INIT_LIST_HEAD(&vdev->ioeventfds_list);
-	mutex_init(&vdev->vma_lock);
-	INIT_LIST_HEAD(&vdev->vma_list);
 	init_rwsem(&vdev->memory_lock);
 
 	ret = vfio_pci_reflck_attach(vdev);
@@ -2261,7 +2123,7 @@ static int vfio_pci_get_unused_devs(struct pci_dev *pdev, void *data)
 	return 0;
 }
 
-static int vfio_pci_try_zap_and_vma_lock_cb(struct pci_dev *pdev, void *data)
+static int vfio_pci_mem_trylock_and_zap_cb(struct pci_dev *pdev, void *data)
 {
 	struct vfio_devices *devs = data;
 	struct vfio_device *device;
@@ -2281,15 +2143,13 @@ static int vfio_pci_try_zap_and_vma_lock_cb(struct pci_dev *pdev, void *data)
 
 	vdev = container_of(device, struct vfio_pci_device, vdev);
 
-	/*
-	 * Locking multiple devices is prone to deadlock, runaway and
-	 * unwind if we hit contention.
-	 */
-	if (!vfio_pci_zap_and_vma_lock(vdev, true)) {
+	if (!down_write_trylock(&vdev->memory_lock)) {
 		vfio_device_put(device);
 		return -EBUSY;
 	}
 
+	vfio_pci_zap_bars(vdev);
+
 	devs->devices[devs->cur_index++] = vdev;
 	return 0;
 }
diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/vfio_pci_private.h
index bbc56c857ef0..0aa542fa1e26 100644
--- a/drivers/vfio/pci/vfio_pci_private.h
+++ b/drivers/vfio/pci/vfio_pci_private.h
@@ -140,8 +140,6 @@ struct vfio_pci_device {
 	struct list_head	ioeventfds_list;
 	struct vfio_pci_vf_token	*vf_token;
 	struct notifier_block	nb;
-	struct mutex		vma_lock;
-	struct list_head	vma_list;
 	struct rw_semaphore	memory_lock;
 };
 


