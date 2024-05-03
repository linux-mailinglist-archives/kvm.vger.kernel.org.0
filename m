Return-Path: <kvm+bounces-16518-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C1BD48BAF08
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 16:32:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4B2A31F2121E
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 14:32:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E1DE8C1A;
	Fri,  3 May 2024 14:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WZYmJrPV"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 612766FC7
	for <kvm@vger.kernel.org>; Fri,  3 May 2024 14:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714746707; cv=none; b=jxk9+frWaEEWLcFClZp8YEFC/u7DEb3XUVmGAV7HkJNnIPzWGSi0zGXMdJRoaWU7lz0UdJd/doJlVWbwWvc/kFAtAaEC7qoaOubSKyjfrHzU12YW4H4ruGyl5U88LZgvZuHuSUQKZQ1sUoggCjKgnCGcnVH4bJqfzqS2/s/FiMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714746707; c=relaxed/simple;
	bh=eRzKq3Gx+U+9jglfXYsioqit1FAtAYy7rTYxDEOp+Co=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Jm20nl6St5Wy28erI50JtFMp1b297CvML9Rb7ETA85aiJeI8uawcR5wNzM+clOb8bxUVeeEBfn++21to0SfM1EKlf605KfjH+91qP0HvNXcuZ175LB6SNRssudPYYK82K46TJWUwKNm2nzxJ20axmSwWankUe3WpeAxI2PIngHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WZYmJrPV; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714746704;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=17rGke10baWoO4JzEGXkhZz0n0MpQJ6MM0QUBdSxzPk=;
	b=WZYmJrPV8NlP/sOJ+tL0FMZXPXWjKlC/OCccN2kOUHV9MU6mkMHpDCvI1BnrpaDXjYEeka
	7Y4XPz3wIw9xln1OXFMWkA7vwL9k7tB7VjoUwDlQ534PmyIypZ53eaR1j6WMj4wSrgIA3h
	3uPDPknalWiwhBFo/NUyinnpI7WFUc4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-586-o4pkby7NNpy4-U64Cf70zg-1; Fri, 03 May 2024 10:31:42 -0400
X-MC-Unique: o4pkby7NNpy4-U64Cf70zg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 67B3A886F11
	for <kvm@vger.kernel.org>; Fri,  3 May 2024 14:31:42 +0000 (UTC)
Received: from omen.home.shazbot.org (unknown [10.22.32.116])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1DEDB112131D;
	Fri,  3 May 2024 14:31:41 +0000 (UTC)
From: Alex Williamson <alex.williamson@redhat.com>
To: alex.williamson@redhat.com
Cc: kvm@vger.kernel.org
Subject: [PATCH] vfio/pci: Collect hot-reset devices to local buffer
Date: Fri,  3 May 2024 08:31:36 -0600
Message-ID: <20240503143138.3562116-1-alex.williamson@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3

Lockdep reports the below circular locking dependency issue.  The
mmap_lock acquisition while holding pci_bus_sem is due to the use of
copy_to_user() from within a pci_walk_bus() callback.

Building the devices array directly into the user buffer is only for
convenience.  Instead we can allocate a local buffer for the array,
bounded by the number of devices on the bus/slot, fill the device
information into this local buffer, then copy it into the user buffer
outside the bus walk callback.

======================================================
WARNING: possible circular locking dependency detected
6.9.0-rc5+ #39 Not tainted
------------------------------------------------------
CPU 0/KVM/4113 is trying to acquire lock:
ffff99a609ee18a8 (&vdev->vma_lock){+.+.}-{4:4}, at: vfio_pci_mmap_fault+0x35/0x1a0 [vfio_pci_core]

but task is already holding lock:
ffff99a243a052a0 (&mm->mmap_lock){++++}-{4:4}, at: vaddr_get_pfns+0x3f/0x170 [vfio_iommu_type1]

which lock already depends on the new lock.

the existing dependency chain (in reverse order) is:

-> #3 (&mm->mmap_lock){++++}-{4:4}:
       __lock_acquire+0x4e4/0xb90
       lock_acquire+0xbc/0x2d0
       __might_fault+0x5c/0x80
       _copy_to_user+0x1e/0x60
       vfio_pci_fill_devs+0x9f/0x130 [vfio_pci_core]
       vfio_pci_walk_wrapper+0x45/0x60 [vfio_pci_core]
       __pci_walk_bus+0x6b/0xb0
       vfio_pci_ioctl_get_pci_hot_reset_info+0x10b/0x1d0 [vfio_pci_core]
       vfio_pci_core_ioctl+0x1cb/0x400 [vfio_pci_core]
       vfio_device_fops_unl_ioctl+0x7e/0x140 [vfio]
       __x64_sys_ioctl+0x8a/0xc0
       do_syscall_64+0x8d/0x170
       entry_SYSCALL_64_after_hwframe+0x76/0x7e

-> #2 (pci_bus_sem){++++}-{4:4}:
       __lock_acquire+0x4e4/0xb90
       lock_acquire+0xbc/0x2d0
       down_read+0x3e/0x160
       pci_bridge_wait_for_secondary_bus.part.0+0x33/0x2d0
       pci_reset_bus+0xdd/0x160
       vfio_pci_dev_set_hot_reset+0x256/0x270 [vfio_pci_core]
       vfio_pci_ioctl_pci_hot_reset_groups+0x1a3/0x280 [vfio_pci_core]
       vfio_pci_core_ioctl+0x3b5/0x400 [vfio_pci_core]
       vfio_device_fops_unl_ioctl+0x7e/0x140 [vfio]
       __x64_sys_ioctl+0x8a/0xc0
       do_syscall_64+0x8d/0x170
       entry_SYSCALL_64_after_hwframe+0x76/0x7e

-> #1 (&vdev->memory_lock){+.+.}-{4:4}:
       __lock_acquire+0x4e4/0xb90
       lock_acquire+0xbc/0x2d0
       down_write+0x3b/0xc0
       vfio_pci_zap_and_down_write_memory_lock+0x1c/0x30 [vfio_pci_core]
       vfio_basic_config_write+0x281/0x340 [vfio_pci_core]
       vfio_config_do_rw+0x1fa/0x300 [vfio_pci_core]
       vfio_pci_config_rw+0x75/0xe50 [vfio_pci_core]
       vfio_pci_rw+0xea/0x1a0 [vfio_pci_core]
       vfs_write+0xea/0x520
       __x64_sys_pwrite64+0x90/0xc0
       do_syscall_64+0x8d/0x170
       entry_SYSCALL_64_after_hwframe+0x76/0x7e

-> #0 (&vdev->vma_lock){+.+.}-{4:4}:
       check_prev_add+0xeb/0xcc0
       validate_chain+0x465/0x530
       __lock_acquire+0x4e4/0xb90
       lock_acquire+0xbc/0x2d0
       __mutex_lock+0x97/0xde0
       vfio_pci_mmap_fault+0x35/0x1a0 [vfio_pci_core]
       __do_fault+0x31/0x160
       do_pte_missing+0x65/0x3b0
       __handle_mm_fault+0x303/0x720
       handle_mm_fault+0x10f/0x460
       fixup_user_fault+0x7f/0x1f0
       follow_fault_pfn+0x66/0x1c0 [vfio_iommu_type1]
       vaddr_get_pfns+0xf2/0x170 [vfio_iommu_type1]
       vfio_pin_pages_remote+0x348/0x4e0 [vfio_iommu_type1]
       vfio_pin_map_dma+0xd2/0x330 [vfio_iommu_type1]
       vfio_dma_do_map+0x2c0/0x440 [vfio_iommu_type1]
       vfio_iommu_type1_ioctl+0xc5/0x1d0 [vfio_iommu_type1]
       __x64_sys_ioctl+0x8a/0xc0
       do_syscall_64+0x8d/0x170
       entry_SYSCALL_64_after_hwframe+0x76/0x7e

other info that might help us debug this:

Chain exists of:
  &vdev->vma_lock --> pci_bus_sem --> &mm->mmap_lock

 Possible unsafe locking scenario:

block dm-0: the capability attribute has been deprecated.
       CPU0                    CPU1
       ----                    ----
  rlock(&mm->mmap_lock);
                               lock(pci_bus_sem);
                               lock(&mm->mmap_lock);
  lock(&vdev->vma_lock);

 *** DEADLOCK ***

2 locks held by CPU 0/KVM/4113:
 #0: ffff99a25f294888 (&iommu->lock#2){+.+.}-{4:4}, at: vfio_dma_do_map+0x60/0x440 [vfio_iommu_type1]
 #1: ffff99a243a052a0 (&mm->mmap_lock){++++}-{4:4}, at: vaddr_get_pfns+0x3f/0x170 [vfio_iommu_type1]

stack backtrace:
CPU: 1 PID: 4113 Comm: CPU 0/KVM Not tainted 6.9.0-rc5+ #39
Hardware name: Dell Inc. PowerEdge T640/04WYPY, BIOS 2.15.1 06/16/2022
Call Trace:
 <TASK>
 dump_stack_lvl+0x64/0xa0
 check_noncircular+0x131/0x150
 check_prev_add+0xeb/0xcc0
 ? add_chain_cache+0x10a/0x2f0
 ? __lock_acquire+0x4e4/0xb90
 validate_chain+0x465/0x530
 __lock_acquire+0x4e4/0xb90
 lock_acquire+0xbc/0x2d0
 ? vfio_pci_mmap_fault+0x35/0x1a0 [vfio_pci_core]
 ? lock_is_held_type+0x9a/0x110
 __mutex_lock+0x97/0xde0
 ? vfio_pci_mmap_fault+0x35/0x1a0 [vfio_pci_core]
 ? lock_acquire+0xbc/0x2d0
 ? vfio_pci_mmap_fault+0x35/0x1a0 [vfio_pci_core]
 ? find_held_lock+0x2b/0x80
 ? vfio_pci_mmap_fault+0x35/0x1a0 [vfio_pci_core]
 vfio_pci_mmap_fault+0x35/0x1a0 [vfio_pci_core]
 __do_fault+0x31/0x160
 do_pte_missing+0x65/0x3b0
 __handle_mm_fault+0x303/0x720
 handle_mm_fault+0x10f/0x460
 fixup_user_fault+0x7f/0x1f0
 follow_fault_pfn+0x66/0x1c0 [vfio_iommu_type1]
 vaddr_get_pfns+0xf2/0x170 [vfio_iommu_type1]
 vfio_pin_pages_remote+0x348/0x4e0 [vfio_iommu_type1]
 vfio_pin_map_dma+0xd2/0x330 [vfio_iommu_type1]
 vfio_dma_do_map+0x2c0/0x440 [vfio_iommu_type1]
 vfio_iommu_type1_ioctl+0xc5/0x1d0 [vfio_iommu_type1]
 __x64_sys_ioctl+0x8a/0xc0
 do_syscall_64+0x8d/0x170
 ? rcu_core+0x8d/0x250
 ? __lock_release+0x5e/0x160
 ? rcu_core+0x8d/0x250
 ? lock_release+0x5f/0x120
 ? sched_clock+0xc/0x30
 ? sched_clock_cpu+0xb/0x190
 ? irqtime_account_irq+0x40/0xc0
 ? __local_bh_enable+0x54/0x60
 ? __do_softirq+0x315/0x3ca
 ? lockdep_hardirqs_on_prepare.part.0+0x97/0x140
 entry_SYSCALL_64_after_hwframe+0x76/0x7e
RIP: 0033:0x7f8300d0357b
Code: ff ff ff 85 c0 79 9b 49 c7 c4 ff ff ff ff 5b 5d 4c 89 e0 41 5c c3 66 0f 1f 84 00 00 00 00 00 f3 0f 1e fa b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 75 68 0f 00 f7 d8 64 89 01 48
RSP: 002b:00007f82ef3fb948 EFLAGS: 00000206 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f8300d0357b
RDX: 00007f82ef3fb990 RSI: 0000000000003b71 RDI: 0000000000000023
RBP: 00007f82ef3fb9c0 R08: 0000000000000000 R09: 0000561b7e0bcac2
R10: 0000000000000000 R11: 0000000000000206 R12: 0000000000000000
R13: 0000000200000000 R14: 0000381800000000 R15: 0000000000000000
 </TASK>

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 78 ++++++++++++++++++++------------
 1 file changed, 49 insertions(+), 29 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index d94d61b92c1a..d8c95cc16be8 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -778,25 +778,26 @@ static int vfio_pci_count_devs(struct pci_dev *pdev, void *data)
 }
 
 struct vfio_pci_fill_info {
-	struct vfio_pci_dependent_device __user *devices;
-	struct vfio_pci_dependent_device __user *devices_end;
 	struct vfio_device *vdev;
+	struct vfio_pci_dependent_device *devices;
+	int nr_devices;
 	u32 count;
 	u32 flags;
 };
 
 static int vfio_pci_fill_devs(struct pci_dev *pdev, void *data)
 {
-	struct vfio_pci_dependent_device info = {
-		.segment = pci_domain_nr(pdev->bus),
-		.bus = pdev->bus->number,
-		.devfn = pdev->devfn,
-	};
+	struct vfio_pci_dependent_device *info;
 	struct vfio_pci_fill_info *fill = data;
 
-	fill->count++;
-	if (fill->devices >= fill->devices_end)
-		return 0;
+	/* The topology changed since we counted devices */
+	if (fill->count >= fill->nr_devices)
+		return -EAGAIN;
+
+	info = &fill->devices[fill->count++];
+	info->segment = pci_domain_nr(pdev->bus);
+	info->bus = pdev->bus->number;
+	info->devfn = pdev->devfn;
 
 	if (fill->flags & VFIO_PCI_HOT_RESET_FLAG_DEV_ID) {
 		struct iommufd_ctx *iommufd = vfio_iommufd_device_ictx(fill->vdev);
@@ -809,19 +810,19 @@ static int vfio_pci_fill_devs(struct pci_dev *pdev, void *data)
 		 */
 		vdev = vfio_find_device_in_devset(dev_set, &pdev->dev);
 		if (!vdev) {
-			info.devid = VFIO_PCI_DEVID_NOT_OWNED;
+			info->devid = VFIO_PCI_DEVID_NOT_OWNED;
 		} else {
 			int id = vfio_iommufd_get_dev_id(vdev, iommufd);
 
 			if (id > 0)
-				info.devid = id;
+				info->devid = id;
 			else if (id == -ENOENT)
-				info.devid = VFIO_PCI_DEVID_OWNED;
+				info->devid = VFIO_PCI_DEVID_OWNED;
 			else
-				info.devid = VFIO_PCI_DEVID_NOT_OWNED;
+				info->devid = VFIO_PCI_DEVID_NOT_OWNED;
 		}
 		/* If devid is VFIO_PCI_DEVID_NOT_OWNED, clear owned flag. */
-		if (info.devid == VFIO_PCI_DEVID_NOT_OWNED)
+		if (info->devid == VFIO_PCI_DEVID_NOT_OWNED)
 			fill->flags &= ~VFIO_PCI_HOT_RESET_FLAG_DEV_ID_OWNED;
 	} else {
 		struct iommu_group *iommu_group;
@@ -830,13 +831,10 @@ static int vfio_pci_fill_devs(struct pci_dev *pdev, void *data)
 		if (!iommu_group)
 			return -EPERM; /* Cannot reset non-isolated devices */
 
-		info.group_id = iommu_group_id(iommu_group);
+		info->group_id = iommu_group_id(iommu_group);
 		iommu_group_put(iommu_group);
 	}
 
-	if (copy_to_user(fill->devices, &info, sizeof(info)))
-		return -EFAULT;
-	fill->devices++;
 	return 0;
 }
 
@@ -1258,10 +1256,11 @@ static int vfio_pci_ioctl_get_pci_hot_reset_info(
 {
 	unsigned long minsz =
 		offsetofend(struct vfio_pci_hot_reset_info, count);
+	struct vfio_pci_dependent_device *devices = NULL;
 	struct vfio_pci_hot_reset_info hdr;
 	struct vfio_pci_fill_info fill = {};
 	bool slot = false;
-	int ret = 0;
+	int ret, count;
 
 	if (copy_from_user(&hdr, arg, minsz))
 		return -EFAULT;
@@ -1277,9 +1276,23 @@ static int vfio_pci_ioctl_get_pci_hot_reset_info(
 	else if (pci_probe_reset_bus(vdev->pdev->bus))
 		return -ENODEV;
 
-	fill.devices = arg->devices;
-	fill.devices_end = arg->devices +
-			   (hdr.argsz - sizeof(hdr)) / sizeof(arg->devices[0]);
+	ret = vfio_pci_for_each_slot_or_bus(vdev->pdev, vfio_pci_count_devs,
+					    &count, slot);
+	if (ret)
+		return ret;
+
+	if (count > (hdr.argsz - sizeof(hdr)) / sizeof(*devices)) {
+		hdr.count = count;
+		ret = -ENOSPC;
+		goto header;
+	}
+
+	devices = kcalloc(count, sizeof(*devices), GFP_KERNEL);
+	if (!devices)
+		return -ENOMEM;
+
+	fill.devices = devices;
+	fill.nr_devices = count;
 	fill.vdev = &vdev->vdev;
 
 	if (vfio_device_cdev_opened(&vdev->vdev))
@@ -1291,16 +1304,23 @@ static int vfio_pci_ioctl_get_pci_hot_reset_info(
 					    &fill, slot);
 	mutex_unlock(&vdev->vdev.dev_set->lock);
 	if (ret)
-		return ret;
+		goto out;
+
+	if (copy_to_user(arg->devices, devices,
+			 sizeof(*devices) * fill.count)) {
+		ret = -EFAULT;
+		goto out;
+	}
 
 	hdr.count = fill.count;
 	hdr.flags = fill.flags;
-	if (copy_to_user(arg, &hdr, minsz))
-		return -EFAULT;
 
-	if (fill.count > fill.devices - arg->devices)
-		return -ENOSPC;
-	return 0;
+header:
+	if (copy_to_user(arg, &hdr, minsz))
+		ret = -EFAULT;
+out:
+	kfree(devices);
+	return ret;
 }
 
 static int
-- 
2.44.0


