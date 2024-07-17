Return-Path: <kvm+bounces-21800-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3021D9344C6
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 00:24:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DAE5E2837A3
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2024 22:24:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8419B59167;
	Wed, 17 Jul 2024 22:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="y+rV8BRs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBB4454662
	for <kvm@vger.kernel.org>; Wed, 17 Jul 2024 22:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721255078; cv=none; b=G5AAlOI3R0N/lEVSbOKaVg8A/WsgX7qTOBdTuuQIJpaPNrEu5T9P0v4JJk86BJW9p271nNW/QNCMvaM96YLtM2EMhFHcjcsFyve6dNy58/JeyQUazR+QtJ5uMIgw00RahkwpI9wx966mUZeFVEmu99Z25HOZgR3mq2Tsac2ybJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721255078; c=relaxed/simple;
	bh=TtH3XLpYUdffZi+3ZQKLYC8ZepilY49siwBCRQ2/iGA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aO34drkp2ljBTecENKv72hQ/Wx2vZbxAUEuXrjoIQoKPKO4wHFUaoT+cBCoz6EYp+lPNiCDYc2kSpDVR/pwDaymAjBnBlLxozfWBgpxdOwnpBxRpuz1qAvEuS+QWQJeqo+hzrONpolvi0r54Xt/XIsW2ovpzkUcgnZlzTvby32Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--axelrasmussen.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=y+rV8BRs; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--axelrasmussen.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e05f08adcacso505720276.0
        for <kvm@vger.kernel.org>; Wed, 17 Jul 2024 15:24:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721255076; x=1721859876; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VAihi2NLrhsl9QonAbqxzxv5quN04e33lYpCxidSW1I=;
        b=y+rV8BRsQjkbGlRpmTGLldswqWn8Z4Pxb5gtkukvBV/YVmb4kitA9IoOaqj0E72qyW
         G8Kx18qepqrIytIw9b+iPkqsHiKqSEZc2Sn+dXTeuR9Oxm9ylmeN9QxLrzjBqY2LVUMD
         A4nZsUXUSQoWIZVXPOQOxKX64/0ZT4ACQOG2zjfI6QjLU3wuBvny0p7Io6Sn66aIwheI
         t1yNA3FFDmJoJ81RPaMC5gZLNCRwfBsMymFuPi9RrimihTbS4SXf6+QMBikQg+V7heel
         QGT1Fsw+iLyT/rzWrGfdf7Yj5QHIXfPVeoc+RFr0k3YXjQqkPP7jpm6CM0zHAgZ5LmxP
         OX9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721255076; x=1721859876;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VAihi2NLrhsl9QonAbqxzxv5quN04e33lYpCxidSW1I=;
        b=RUv/6fXg5qSRX3Q1znT/5rsQHsoGfQxPrbBLtvOWvG/fP66CAFteYDaAMKYruSxGkO
         JYPBzm/Kq2/MmuDufV9svjl8Vmocbx11+dR2VXhGwQbpWKRIOuuL32ZHJ1pY58Hm6W5z
         MSOnFdPQbiaCZijqfpz8IqsEtxzL2lSbpWiFFvJuJ0F7ebp88dKXJM23A6vyYYDHqPU0
         gxHwXMPWskU7DGTMZG8dz4vwh2+5/PbLC1AANgVopapDrFMF2bUf5JNUotPdekNXxlwh
         NO6L4yrWSkQPv2k0icrAFKLaCHV0Rp+9SgWQ5LCNwfR4hMSRGhYAFqYMPTqbstJJ9KGP
         KB1Q==
X-Forwarded-Encrypted: i=1; AJvYcCXyRzEjCMB24Jv87vOu7utmMU4Nnak8WsZu8VBfKtMIz4+fLghSAK96TZAyjA+6EYRWc1AJo3K/GIA5sZShGU/Jpv33
X-Gm-Message-State: AOJu0YyrOJiZoO9CjCIZ3IWu62KHAARrZQ+5F29oFC7HoTEyruZWGBXP
	a75VMDqKoZPmc4rT4F2tfDGOVC/hAyiOfDovjZ56N04d4hgcMG27ttzD0ASTd98WduuJASjS+R8
	fCcP4otfgGCb15ncXsbGnV+A8V3ru9Q==
X-Google-Smtp-Source: AGHT+IHO+Ae3NjnrwpiDjqOu3v+RM540yt4wUFe0mWmEmLo4mHb2p4sqDQwyimrQcr6k8xCK609bsoaV4wUIj5HbIRmg
X-Received: from axel.svl.corp.google.com ([2620:15c:2a3:200:a503:d697:557b:840c])
 (user=axelrasmussen job=sendgmr) by 2002:a25:660e:0:b0:e03:5dfe:45bb with
 SMTP id 3f1490d57ef6-e05fedb2a03mr1483276.12.1721255075506; Wed, 17 Jul 2024
 15:24:35 -0700 (PDT)
Date: Wed, 17 Jul 2024 15:24:28 -0700
In-Reply-To: <20240717222429.2011540-1-axelrasmussen@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240717222429.2011540-1-axelrasmussen@google.com>
X-Mailer: git-send-email 2.45.2.993.g49e7a77208-goog
Message-ID: <20240717222429.2011540-3-axelrasmussen@google.com>
Subject: [PATCH 6.6 2/3] vfio/pci: Use unmap_mapping_range()
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
index a3c545dd174e..7b74c71a3169 100644
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
 	 */
 	vm_flags_set(vma, VM_IO | VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP);
 	vma->vm_ops = &vfio_pci_mmap_ops;
@@ -2181,8 +2044,6 @@ int vfio_pci_core_init_dev(struct vfio_device *core_vdev)
 	mutex_init(&vdev->ioeventfds_lock);
 	INIT_LIST_HEAD(&vdev->dummy_resources_list);
 	INIT_LIST_HEAD(&vdev->ioeventfds_list);
-	mutex_init(&vdev->vma_lock);
-	INIT_LIST_HEAD(&vdev->vma_list);
 	INIT_LIST_HEAD(&vdev->sriov_pfs_item);
 	init_rwsem(&vdev->memory_lock);
 	xa_init(&vdev->ctx);
@@ -2198,7 +2059,6 @@ void vfio_pci_core_release_dev(struct vfio_device *core_vdev)
 
 	mutex_destroy(&vdev->igate);
 	mutex_destroy(&vdev->ioeventfds_lock);
-	mutex_destroy(&vdev->vma_lock);
 	kfree(vdev->region);
 	kfree(vdev->pm_save);
 }
@@ -2476,26 +2336,15 @@ static int vfio_pci_dev_set_pm_runtime_get(struct vfio_device_set *dev_set)
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
@@ -2512,7 +2361,7 @@ static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
 	if (ret)
 		goto err_unlock;
 
-	list_for_each_entry(cur_vma, &dev_set->device_list, vdev.dev_set_list) {
+	list_for_each_entry(vdev, &dev_set->device_list, vdev.dev_set_list) {
 		bool owned;
 
 		/*
@@ -2536,38 +2385,38 @@ static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
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
@@ -2578,25 +2427,22 @@ static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
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
index 562e8754869d..4f283514a1ed 100644
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


