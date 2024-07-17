Return-Path: <kvm+bounces-21792-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FAFE9343FA
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2024 23:34:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 45F6F284484
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2024 21:34:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9546618E76E;
	Wed, 17 Jul 2024 21:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HWEza6fS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E68E188CB4
	for <kvm@vger.kernel.org>; Wed, 17 Jul 2024 21:33:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721252034; cv=none; b=LQevCsXAB8JVz6VuXaX9UYNS21R7z1OZoJRSWe60ibrApfVixS5eAX/vGMCg24zLDQuXcYpO9/fGCIiY7aWX8VB33SIEY6P5aG/UqKoXf3LQ3TSnqX4FUNZGYveiB7fLgJ/9q3RTKC63xcdlzUWSV1nXF2ueN0lqkQISCUq6ZTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721252034; c=relaxed/simple;
	bh=oUY9YZ7+1Y80EyjnkDUTvjvElG3foBbnBfb5pC2rB+4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DylKFjLd+wVJhu1kd+0NusqU3Stnqvw3gvnLmOi9FzQ25NfEZRGJpsRzrlIleV20jPvyIK67lYWPDSXo1MGLbF1oO2y5jEbgVMRiL9dHNZdxFr1id/WG0S3RLuhgskFRGH60supDLiBPzBPsAqAeMiCY8v+UlP5JATtoktNOqV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--axelrasmussen.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HWEza6fS; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--axelrasmussen.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-65be82a3241so2597567b3.0
        for <kvm@vger.kernel.org>; Wed, 17 Jul 2024 14:33:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721252028; x=1721856828; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tOMgioDNg2+iaY9KwtuqRHZqjFKTM2Uwixm6NyxetKM=;
        b=HWEza6fSaGBQdFlw8+L9zkTYzWx1JCeoo0pzbz163REbNAyw75TQ6PNSzXEdcQnPrI
         Ed2Amm3uS1T2I6KNnkL830tIhipR401uMiELyZGdN3788nkM/zXENeLPq6jIEOw75TCJ
         pQT0VSfvaELKZFziObDCAX4VzFFPMUTX+PAc7H8heTZf/F4q8nYrFW/svTyImrJR/467
         uLUYR8Yucy5g562ptIWrkPC811flga3aYYoTr8BdzzAbzS5UI8QN332zLcrAH9DSJQtE
         jaruzAf1dLW+MRgJz/YSiokGqS6SIkHCyfUrDKCJZHbMXKCJ/r7oElKoqZvM1Pem3h/U
         jQag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721252028; x=1721856828;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tOMgioDNg2+iaY9KwtuqRHZqjFKTM2Uwixm6NyxetKM=;
        b=tNsvUBG+EPVu5jsMoDOOx3Oj/W2rLIvDI1OFN0QS5o8ryHm/7gy5pr2gPxlPpus8YT
         LIpCze3OdpzRbhVNPURkxOa6K6NlXjAwan48MJeOCUguWZUbTEyP3o+RpYJhm9KdCXQ7
         ngG4S6xO1e4QOlK3tad8XeFyc28WccrJseRYiYQEmNiQi70zi4p7ER0m9cv3OFJI4q6T
         rs566Ai1d8+w/UGmTW4vfFdyK+9GruYLnoKL05Lmp1GBzaXaLYWZ+XvgWvkLR2BsF6jP
         5KiS5c8M8eseL3qyJhUN1TvVFGUXiRaIcH75YSyS/LOzX5yuRKS46P2X6dPOaJy2Wl7h
         Jy0w==
X-Forwarded-Encrypted: i=1; AJvYcCW1YzF/lYMwX8+PB2LO2DUrBxRE8S0E3qFYr3lzK2Lq0ECf8LXJpUpJOjabIGOoHWdg7wj2fu54nkI6FZXAImJMSKiq
X-Gm-Message-State: AOJu0Yz5hZO9FSrctCH3ArSRrgQtbYHN5b8xzFWWb4+bkbw5fbD6kmQQ
	C/hQ/2mrStkoH6CaySmKirbevhf9+G5peKAzxs6sAIqrW7wYTwZUKj+CH6PSs9w7ttLTzjG5Gl4
	qI/7fu51Svplt+T7ttpbD+/23b5uxcQ==
X-Google-Smtp-Source: AGHT+IHl7VEXiuTMfXBTUCoIEm9IDfpuV6m8OAXLJi9hiucwOmQzjToTbaJb1sPjGm42j+OPlY+lUdITqHtJ5AXiEgL1
X-Received: from axel.svl.corp.google.com ([2620:15c:2a3:200:a503:d697:557b:840c])
 (user=axelrasmussen job=sendgmr) by 2002:a05:690c:dd0:b0:648:db87:13d8 with
 SMTP id 00721157ae682-66602a57c98mr229847b3.2.1721252028002; Wed, 17 Jul 2024
 14:33:48 -0700 (PDT)
Date: Wed, 17 Jul 2024 14:33:38 -0700
In-Reply-To: <20240717213339.1921530-1-axelrasmussen@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240717213339.1921530-1-axelrasmussen@google.com>
X-Mailer: git-send-email 2.45.2.993.g49e7a77208-goog
Message-ID: <20240717213339.1921530-3-axelrasmussen@google.com>
Subject: [PATCH 6.9 2/3] vfio/pci: Use unmap_mapping_range()
From: Axel Rasmussen <axelrasmussen@google.com>
To: stable@vger.kernel.org
Cc: Alex Williamson <alex.williamson@redhat.com>, Ankit Agrawal <ankita@nvidia.com>, 
	Eric Auger <eric.auger@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Kevin Tian <kevin.tian@intel.com>, 
	Kunwu Chan <chentao@kylinos.cn>, Leah Rumancik <leah.rumancik@gmail.com>, 
	Miaohe Lin <linmiaohe@huawei.com>, Stefan Hajnoczi <stefanha@redhat.com>, Yi Liu <yi.l.liu@intel.com>, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Jason Gunthorpe <jgg@nvidia.com>, Axel Rasmussen <axelrasmussen@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Alex Williamson <alex.williamson@redhat.com>

commit aac6db75a9fc2c7a6f73e152df8f15101dda38e6 upstream.

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
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Link: https://lore.kernel.org/r/20240530045236.1005864-3-alex.williamson@redhat.com
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Axel Rasmussen <axelrasmussen@google.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 264 +++++++------------------------
 include/linux/vfio_pci_core.h    |   2 -
 2 files changed, 55 insertions(+), 211 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index d8c95cc16be8..74a3499a8a2e 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1607,100 +1607,20 @@ ssize_t vfio_pci_core_write(struct vfio_device *core_vdev, const char __user *bu
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
@@ -1722,99 +1642,41 @@ void vfio_pci_memory_unlock_and_restore(struct vfio_pci_core_device *vdev, u16 c
 	up_write(&vdev->memory_lock);
 }
 
-/* Caller holds vma_lock */
-static int __vfio_pci_add_vma(struct vfio_pci_core_device *vdev,
-			      struct vm_area_struct *vma)
-{
-	struct vfio_pci_mmap_vma *mmap_vma;
-
-	mmap_vma = kmalloc(sizeof(*mmap_vma), GFP_KERNEL_ACCOUNT);
-	if (!mmap_vma)
-		return -ENOMEM;
-
-	mmap_vma->vma = vma;
-	list_add(&mmap_vma->vma_next, &vdev->vma_list);
-
-	return 0;
-}
-
-/*
- * Zap mmaps on open so that we can fault them in on access and therefore
- * our vma_list only tracks mappings accessed since last zap.
- */
-static void vfio_pci_mmap_open(struct vm_area_struct *vma)
-{
-	zap_vma_ptes(vma, vma->vm_start, vma->vm_end - vma->vm_start);
-}
-
-static void vfio_pci_mmap_close(struct vm_area_struct *vma)
+static unsigned long vma_to_pfn(struct vm_area_struct *vma)
 {
 	struct vfio_pci_core_device *vdev = vma->vm_private_data;
-	struct vfio_pci_mmap_vma *mmap_vma;
+	int index = vma->vm_pgoff >> (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT);
+	u64 pgoff;
 
-	mutex_lock(&vdev->vma_lock);
-	list_for_each_entry(mmap_vma, &vdev->vma_list, vma_next) {
-		if (mmap_vma->vma == vma) {
-			list_del(&mmap_vma->vma_next);
-			kfree(mmap_vma);
-			break;
-		}
-	}
-	mutex_unlock(&vdev->vma_lock);
+	pgoff = vma->vm_pgoff &
+		((1U << (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
+
+	return (pci_resource_start(vdev->pdev, index) >> PAGE_SHIFT) + pgoff;
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
+	pfn = vma_to_pfn(vma);
 
-	/*
-	 * Memory region cannot be accessed if the low power feature is engaged
-	 * or memory access is disabled.
-	 */
-	if (vdev->pm_runtime_engaged || !__vfio_pci_memory_enabled(vdev)) {
-		ret = VM_FAULT_SIGBUS;
-		goto up_out;
-	}
+	down_read(&vdev->memory_lock);
 
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
+	if (vdev->pm_runtime_engaged || !__vfio_pci_memory_enabled(vdev))
+		goto out_disabled;
 
-	if (io_remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
-			       vma->vm_end - vma->vm_start,
-			       vma->vm_page_prot)) {
-		ret = VM_FAULT_SIGBUS;
-		zap_vma_ptes(vma, vma->vm_start, vma->vm_end - vma->vm_start);
-		goto up_out;
-	}
+	ret = vmf_insert_pfn(vma, vmf->address, pfn + pgoff);
 
-	if (__vfio_pci_add_vma(vdev, vma)) {
-		ret = VM_FAULT_OOM;
-		zap_vma_ptes(vma, vma->vm_start, vma->vm_end - vma->vm_start);
-	}
-
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
 
@@ -1877,11 +1739,12 @@ int vfio_pci_core_mmap(struct vfio_device *core_vdev, struct vm_area_struct *vma
 
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
@@ -2199,8 +2062,6 @@ int vfio_pci_core_init_dev(struct vfio_device *core_vdev)
 	mutex_init(&vdev->ioeventfds_lock);
 	INIT_LIST_HEAD(&vdev->dummy_resources_list);
 	INIT_LIST_HEAD(&vdev->ioeventfds_list);
-	mutex_init(&vdev->vma_lock);
-	INIT_LIST_HEAD(&vdev->vma_list);
 	INIT_LIST_HEAD(&vdev->sriov_pfs_item);
 	init_rwsem(&vdev->memory_lock);
 	xa_init(&vdev->ctx);
@@ -2216,7 +2077,6 @@ void vfio_pci_core_release_dev(struct vfio_device *core_vdev)
 
 	mutex_destroy(&vdev->igate);
 	mutex_destroy(&vdev->ioeventfds_lock);
-	mutex_destroy(&vdev->vma_lock);
 	kfree(vdev->region);
 	kfree(vdev->pm_save);
 }
@@ -2494,26 +2354,15 @@ static int vfio_pci_dev_set_pm_runtime_get(struct vfio_device_set *dev_set)
 	return ret;
 }
 
-/*
- * We need to get memory_lock for each device, but devices can share mmap_lock,
- * therefore we need to zap and hold the vma_lock for each device, and only then
- * get each memory_lock.
- */
 static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
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
@@ -2530,7 +2379,7 @@ static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
 	if (ret)
 		goto err_unlock;
 
-	list_for_each_entry(cur_vma, &dev_set->device_list, vdev.dev_set_list) {
+	list_for_each_entry(vdev, &dev_set->device_list, vdev.dev_set_list) {
 		bool owned;
 
 		/*
@@ -2554,38 +2403,38 @@ static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
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
-		 * Locking multiple devices is prone to deadlock, runaway and
-		 * unwind if we hit contention.
+		 * Take the memory write lock for each device and zap BAR
+		 * mappings to prevent the user accessing the device while in
+		 * reset.  Locking multiple devices is prone to deadlock,
+		 * runaway and unwind if we hit contention.
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
@@ -2596,25 +2445,22 @@ static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
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
2.45.2.993.g49e7a77208-goog


