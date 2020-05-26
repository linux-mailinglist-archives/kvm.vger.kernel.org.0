Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 695C81C1FC7
	for <lists+kvm@lfdr.de>; Fri,  1 May 2020 23:41:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727121AbgEAVjm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 May 2020 17:39:42 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:44685 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727086AbgEAVjl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 May 2020 17:39:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588369179;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8RzprcLYXvxG8Cqp6oniAolY+yQH2tQdMC7Bs/1ps/g=;
        b=TxteaQOXZphnHpCpY6B+Tpn/Kn7Ik9JPzSk1l53i77EIGhsWCyggb7kKotdxiGhT5h0w9i
        ZX1LD3/bWA+2CKfvHO+7UB5cf3Arla08T4E3PjS51mhw66ehFUuPsshGNiWLAUtpFEnw1D
        P45HEeE/iexoXb4eS2w9x09n7B4Il60=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-66-dehBXczoM9Gcqgt5thKSsw-1; Fri, 01 May 2020 17:39:37 -0400
X-MC-Unique: dehBXczoM9Gcqgt5thKSsw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4E20F100CCC4;
        Fri,  1 May 2020 21:39:36 +0000 (UTC)
Received: from gimli.home (ovpn-113-95.phx2.redhat.com [10.3.113.95])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AF90560BE1;
        Fri,  1 May 2020 21:39:30 +0000 (UTC)
Subject: [PATCH 3/3] vfio-pci: Invalidate mmaps and block MMIO access on
 disabled memory
From:   Alex Williamson <alex.williamson@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, cohuck@redhat.com, jgg@ziepe.ca,
        peterx@redhat.com
Date:   Fri, 01 May 2020 15:39:30 -0600
Message-ID: <158836917028.8433.13715345616117345453.stgit@gimli.home>
In-Reply-To: <158836742096.8433.685478071796941103.stgit@gimli.home>
References: <158836742096.8433.685478071796941103.stgit@gimli.home>
User-Agent: StGit/0.19-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Accessing the disabled memory space of a PCI device would typically
result in a master abort response on conventional PCI, or an
unsupported request on PCI express.  The user would generally see
these as a -1 response for the read return data and the write would be
silently discarded, possibly with an uncorrected, non-fatal AER error
triggered on the host.  Some systems however take it upon themselves
to bring down the entire system when they see something that might
indicate a loss of data, such as this discarded write to a disabled
memory space.

To avoid this, we want to try to block the user from accessing memory
spaces while they're disabled.  We start with a semaphore around the
memory enable bit, where writers modify the memory enable state and
must be serialized, while readers make use of the memory region and
can access in parallel.  Writers include both direct manipulation via
the command register, as well as any reset path where the internal
mechanics of the reset may both explicitly and implicitly disable
memory access, and manipulation of the MSI-X configuration, where the
MSI-X vector table resides in MMIO space of the device.  Readers
include the read and write file ops to access the vfio device fd
offsets as well as memory mapped access.  In the latter case, we make
use of our new vma list support to zap, or invalidate, those memory
mappings in order to force them to be faulted back in on access.

Our semaphore usage will stall user access to MMIO spaces across
internal operations like reset, but the user might experience new
behavior when trying to access the MMIO space while disabled via the
PCI command register.  Access via read or write while disabled will
return -EIO and access via memory maps will result in a SIGBUS.  This
is expected to be compatible with known use cases and potentially
provides better error handling capabilities than present in the
hardware, while avoiding the more readily accessible and severe
platform error responses that might otherwise occur.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/pci/vfio_pci.c         |  200 ++++++++++++++++++++++++++++++++---
 drivers/vfio/pci/vfio_pci_config.c  |   31 +++++
 drivers/vfio/pci/vfio_pci_intrs.c   |   18 +++
 drivers/vfio/pci/vfio_pci_private.h |    4 +
 drivers/vfio/pci/vfio_pci_rdwr.c    |   12 ++
 5 files changed, 246 insertions(+), 19 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index da2fef666d9c..ce2bb3e62b18 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -26,6 +26,7 @@
 #include <linux/vfio.h>
 #include <linux/vgaarb.h>
 #include <linux/nospec.h>
+#include <linux/sched/mm.h>
 
 #include "vfio_pci_private.h"
 
@@ -184,6 +185,7 @@ static void vfio_pci_probe_mmaps(struct vfio_pci_device *vdev)
 
 static void vfio_pci_try_bus_reset(struct vfio_pci_device *vdev);
 static void vfio_pci_disable(struct vfio_pci_device *vdev);
+static int vfio_pci_lock_mem(struct pci_dev *pdev, void *data);
 
 /*
  * INTx masking requires the ability to disable INTx signaling via PCI_COMMAND
@@ -736,6 +738,12 @@ int vfio_pci_register_dev_region(struct vfio_pci_device *vdev,
 	return 0;
 }
 
+struct vfio_devices {
+	struct vfio_device **devices;
+	int cur_index;
+	int max_index;
+};
+
 static long vfio_pci_ioctl(void *device_data,
 			   unsigned int cmd, unsigned long arg)
 {
@@ -984,8 +992,17 @@ static long vfio_pci_ioctl(void *device_data,
 		return ret;
 
 	} else if (cmd == VFIO_DEVICE_RESET) {
-		return vdev->reset_works ?
-			pci_try_reset_function(vdev->pdev) : -EINVAL;
+		int ret;
+
+		if (!vdev->reset_works)
+			return -EINVAL;
+
+		down_write(&vdev->memory_lock);
+		vfio_pci_zap_mmap_vmas(vdev);
+		ret = pci_try_reset_function(vdev->pdev);
+		up_write(&vdev->memory_lock);
+
+		return ret;
 
 	} else if (cmd == VFIO_DEVICE_GET_PCI_HOT_RESET_INFO) {
 		struct vfio_pci_hot_reset_info hdr;
@@ -1065,6 +1082,7 @@ static long vfio_pci_ioctl(void *device_data,
 		int32_t *group_fds;
 		struct vfio_pci_group_entry *groups;
 		struct vfio_pci_group_info info;
+		struct vfio_devices devs = { .cur_index = 0 };
 		bool slot = false;
 		int i, count = 0, ret = 0;
 
@@ -1153,11 +1171,39 @@ static long vfio_pci_ioctl(void *device_data,
 		ret = vfio_pci_for_each_slot_or_bus(vdev->pdev,
 						    vfio_pci_validate_devs,
 						    &info, slot);
-		if (!ret)
-			/* User has access, do the reset */
-			ret = pci_reset_bus(vdev->pdev);
+		if (ret)
+			goto hot_reset_release;
+
+		devs.max_index = count;
+		devs.devices = kcalloc(count, sizeof(struct vfio_device *),
+				       GFP_KERNEL);
+		if (!devs.devices) {
+			ret = -ENOMEM;
+			goto hot_reset_release;
+		}
+
+		ret = vfio_pci_for_each_slot_or_bus(vdev->pdev,
+						    vfio_pci_lock_mem,
+						    &devs, slot);
+		if (ret)
+			goto hot_reset_release;
+
+		/* User has access, do the reset */
+		ret = pci_reset_bus(vdev->pdev);
 
 hot_reset_release:
+		while (devs.cur_index) {
+			struct vfio_device *device;
+			struct vfio_pci_device *tmp;
+
+			device = devs.devices[--devs.cur_index];
+			tmp = vfio_device_data(device);
+
+			up_write(&tmp->memory_lock);
+			vfio_device_put(device);
+		}
+		kfree(devs.devices);
+
 		for (i--; i >= 0; i--)
 			vfio_group_put_external_user(groups[i].group);
 
@@ -1299,6 +1345,64 @@ static ssize_t vfio_pci_write(void *device_data, const char __user *buf,
 	return vfio_pci_rw(device_data, (char __user *)buf, count, ppos, true);
 }
 
+/* Zap and remove vma tracking */
+void vfio_pci_zap_mmap_vmas(struct vfio_pci_device *vdev)
+{
+	struct vfio_pci_mmap_vma *mmap_vma, *tmp;
+
+	/*
+	 * vma_lock is necessarily nested under the mmap_sem as the latter
+	 * is implicitly held for the vm_ops callbacks.  Therefore we need
+	 * to do a little dance to keep the locks in the same order here.
+	 * All vmas will typically use the same mm.  Trickery derived from
+	 * uverbs_user_mmap_disassociate()
+	 */
+	while (1) {
+		struct mm_struct *mm = NULL;
+
+		mutex_lock(&vdev->vma_lock);
+		while (!list_empty(&vdev->vma_list)) {
+			mmap_vma = list_first_entry(&vdev->vma_list,
+						    struct vfio_pci_mmap_vma,
+						    vma_next);
+			mm = mmap_vma->vma->vm_mm;
+			if (mmget_not_zero(mm))
+				break;
+
+			list_del(&mmap_vma->vma_next);
+			kfree(mmap_vma);
+			mm = NULL;
+		}
+		mutex_unlock(&vdev->vma_lock);
+
+		if (!mm)
+			return;
+
+		down_read(&mm->mmap_sem);
+		if (!mmget_still_valid(mm))
+			goto skip_mm;
+
+		mutex_lock(&vdev->vma_lock);
+		list_for_each_entry_safe(mmap_vma, tmp,
+					 &vdev->vma_list, vma_next) {
+			struct vm_area_struct *vma = mmap_vma->vma;
+
+			if (vma->vm_mm != mm)
+				continue;
+
+			list_del(&mmap_vma->vma_next);
+			kfree(mmap_vma);
+
+			zap_vma_ptes(vma, vma->vm_start,
+				     vma->vm_end - vma->vm_start);
+		}
+		mutex_unlock(&vdev->vma_lock);
+skip_mm:
+		up_read(&mm->mmap_sem);
+		mmput(mm);
+	}
+}
+
 static int vfio_pci_add_vma(struct vfio_pci_device *vdev,
 			    struct vm_area_struct *vma)
 {
@@ -1346,15 +1450,49 @@ static vm_fault_t vfio_pci_mmap_fault(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
 	struct vfio_pci_device *vdev = vma->vm_private_data;
+	vm_fault_t ret = VM_FAULT_NOPAGE;
 
-	if (vfio_pci_add_vma(vdev, vma))
-		return VM_FAULT_OOM;
+	/*
+	 * Zap callers hold memory_lock and acquire mmap_sem, we hold
+	 * mmap_sem and need to acquire memory_lock to avoid races with
+	 * memory bit settings.  Release mmap_sem, wait, and retry, or fail.
+	 */
+	if (unlikely(!down_read_trylock(&vdev->memory_lock))) {
+		if (vmf->flags & FAULT_FLAG_ALLOW_RETRY) {
+			if (vmf->flags & FAULT_FLAG_RETRY_NOWAIT)
+				return VM_FAULT_RETRY;
+
+			up_read(&vma->vm_mm->mmap_sem);
+
+			if (vmf->flags & FAULT_FLAG_KILLABLE) {
+				if (!down_read_killable(&vdev->memory_lock))
+					up_read(&vdev->memory_lock);
+			} else {
+				down_read(&vdev->memory_lock);
+				up_read(&vdev->memory_lock);
+			}
+			return VM_FAULT_RETRY;
+		}
+		return VM_FAULT_SIGBUS;
+	}
+
+	if (!__vfio_pci_memory_enabled(vdev)) {
+		ret = VM_FAULT_SIGBUS;
+		goto up_out;
+	}
+
+	if (vfio_pci_add_vma(vdev, vma)) {
+		ret = VM_FAULT_OOM;
+		goto up_out;
+	}
 
 	if (remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
 			    vma->vm_end - vma->vm_start, vma->vm_page_prot))
-		return VM_FAULT_SIGBUS;
+		ret = VM_FAULT_SIGBUS;
 
-	return VM_FAULT_NOPAGE;
+up_out:
+	up_read(&vdev->memory_lock);
+	return ret;
 }
 
 static const struct vm_operations_struct vfio_pci_mmap_ops = {
@@ -1680,6 +1818,7 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	INIT_LIST_HEAD(&vdev->ioeventfds_list);
 	mutex_init(&vdev->vma_lock);
 	INIT_LIST_HEAD(&vdev->vma_list);
+	init_rwsem(&vdev->memory_lock);
 
 	ret = vfio_add_group_dev(&pdev->dev, &vfio_pci_ops, vdev);
 	if (ret)
@@ -1933,12 +2072,6 @@ static void vfio_pci_reflck_put(struct vfio_pci_reflck *reflck)
 	kref_put_mutex(&reflck->kref, vfio_pci_reflck_release, &reflck_lock);
 }
 
-struct vfio_devices {
-	struct vfio_device **devices;
-	int cur_index;
-	int max_index;
-};
-
 static int vfio_pci_get_unused_devs(struct pci_dev *pdev, void *data)
 {
 	struct vfio_devices *devs = data;
@@ -1969,6 +2102,43 @@ static int vfio_pci_get_unused_devs(struct pci_dev *pdev, void *data)
 	return 0;
 }
 
+static int vfio_pci_lock_mem(struct pci_dev *pdev, void *data)
+{
+	struct vfio_devices *devs = data;
+	struct vfio_device *device;
+	struct vfio_pci_device *vdev;
+	int locked;
+
+	if (devs->cur_index == devs->max_index)
+		return -ENOSPC;
+
+	device = vfio_device_get_from_dev(&pdev->dev);
+	if (!device)
+		return -EINVAL;
+
+	if (pci_dev_driver(pdev) != &vfio_pci_driver) {
+		vfio_device_put(device);
+		return -EBUSY;
+	}
+
+	vdev = vfio_device_data(device);
+
+	/*
+	 * Locking multiple devices is prone to deadlock, runaway and
+	 * unwind if we hit contention.
+	 */
+	locked = down_write_trylock(&vdev->memory_lock);
+	if (!locked) {
+		vfio_device_put(device);
+		return -EBUSY;
+	}
+
+	vfio_pci_zap_mmap_vmas(vdev);
+
+	devs->devices[devs->cur_index++] = device;
+	return 0;
+}
+
 /*
  * If a bus or slot reset is available for the provided device and:
  *  - All of the devices affected by that bus or slot reset are unused
diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
index 90c0b80f8acf..87d0cc8c86ad 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -395,6 +395,14 @@ static inline void p_setd(struct perm_bits *p, int off, u32 virt, u32 write)
 	*(__le32 *)(&p->write[off]) = cpu_to_le32(write);
 }
 
+/* Caller should hold memory_lock semaphore */
+bool __vfio_pci_memory_enabled(struct vfio_pci_device *vdev)
+{
+	u16 cmd = le16_to_cpu(*(__le16 *)&vdev->vconfig[PCI_COMMAND]);
+
+	return cmd & PCI_COMMAND_MEMORY;
+}
+
 /*
  * Restore the *real* BARs after we detect a FLR or backdoor reset.
  * (backdoor = some device specific technique that we didn't catch)
@@ -560,6 +568,10 @@ static int vfio_basic_config_write(struct vfio_pci_device *vdev, int pos,
 		virt_mem = !!(le16_to_cpu(*virt_cmd) & PCI_COMMAND_MEMORY);
 		new_mem = !!(new_cmd & PCI_COMMAND_MEMORY);
 
+		down_write(&vdev->memory_lock);
+		if (!new_mem)
+			vfio_pci_zap_mmap_vmas(vdev);
+
 		phys_io = !!(phys_cmd & PCI_COMMAND_IO);
 		virt_io = !!(le16_to_cpu(*virt_cmd) & PCI_COMMAND_IO);
 		new_io = !!(new_cmd & PCI_COMMAND_IO);
@@ -579,8 +591,11 @@ static int vfio_basic_config_write(struct vfio_pci_device *vdev, int pos,
 	}
 
 	count = vfio_default_config_write(vdev, pos, count, perm, offset, val);
-	if (count < 0)
+	if (count < 0) {
+		if (offset == PCI_COMMAND)
+			up_write(&vdev->memory_lock);
 		return count;
+	}
 
 	/*
 	 * Save current memory/io enable bits in vconfig to allow for
@@ -591,6 +606,8 @@ static int vfio_basic_config_write(struct vfio_pci_device *vdev, int pos,
 
 		*virt_cmd &= cpu_to_le16(~mask);
 		*virt_cmd |= cpu_to_le16(new_cmd & mask);
+
+		up_write(&vdev->memory_lock);
 	}
 
 	/* Emulate INTx disable */
@@ -828,8 +845,12 @@ static int vfio_exp_config_write(struct vfio_pci_device *vdev, int pos,
 						 pos - offset + PCI_EXP_DEVCAP,
 						 &cap);
 
-		if (!ret && (cap & PCI_EXP_DEVCAP_FLR))
+		if (!ret && (cap & PCI_EXP_DEVCAP_FLR)) {
+			down_write(&vdev->memory_lock);
+			vfio_pci_zap_mmap_vmas(vdev);
 			pci_try_reset_function(vdev->pdev);
+			up_write(&vdev->memory_lock);
+		}
 	}
 
 	/*
@@ -907,8 +928,12 @@ static int vfio_af_config_write(struct vfio_pci_device *vdev, int pos,
 						pos - offset + PCI_AF_CAP,
 						&cap);
 
-		if (!ret && (cap & PCI_AF_CAP_FLR) && (cap & PCI_AF_CAP_TP))
+		if (!ret && (cap & PCI_AF_CAP_FLR) && (cap & PCI_AF_CAP_TP)) {
+			down_write(&vdev->memory_lock);
+			vfio_pci_zap_mmap_vmas(vdev);
 			pci_try_reset_function(vdev->pdev);
+			up_write(&vdev->memory_lock);
+		}
 	}
 
 	return count;
diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 2056f3f85f59..54102a7eb9d3 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -626,6 +626,8 @@ int vfio_pci_set_irqs_ioctl(struct vfio_pci_device *vdev, uint32_t flags,
 	int (*func)(struct vfio_pci_device *vdev, unsigned index,
 		    unsigned start, unsigned count, uint32_t flags,
 		    void *data) = NULL;
+	int ret;
+	u16 cmd;
 
 	switch (index) {
 	case VFIO_PCI_INTX_IRQ_INDEX:
@@ -673,5 +675,19 @@ int vfio_pci_set_irqs_ioctl(struct vfio_pci_device *vdev, uint32_t flags,
 	if (!func)
 		return -ENOTTY;
 
-	return func(vdev, index, start, count, flags, data);
+	if (index == VFIO_PCI_MSIX_IRQ_INDEX) {
+		down_write(&vdev->memory_lock);
+		pci_read_config_word(vdev->pdev, PCI_COMMAND, &cmd);
+		pci_write_config_word(vdev->pdev, PCI_COMMAND,
+				      cmd | PCI_COMMAND_MEMORY);
+	}
+
+	ret = func(vdev, index, start, count, flags, data);
+
+	if (index == VFIO_PCI_MSIX_IRQ_INDEX) {
+		pci_write_config_word(vdev->pdev, PCI_COMMAND, cmd);
+		up_write(&vdev->memory_lock);
+	}
+
+	return ret;
 }
diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/vfio_pci_private.h
index 9b25f9f6ce1d..9e10e6ba8682 100644
--- a/drivers/vfio/pci/vfio_pci_private.h
+++ b/drivers/vfio/pci/vfio_pci_private.h
@@ -139,6 +139,7 @@ struct vfio_pci_device {
 	struct notifier_block	nb;
 	struct mutex		vma_lock;
 	struct list_head	vma_list;
+	struct rw_semaphore	memory_lock;
 };
 
 #define is_intx(vdev) (vdev->irq_type == VFIO_PCI_INTX_IRQ_INDEX)
@@ -181,6 +182,9 @@ extern int vfio_pci_register_dev_region(struct vfio_pci_device *vdev,
 extern int vfio_pci_set_power_state(struct vfio_pci_device *vdev,
 				    pci_power_t state);
 
+extern bool __vfio_pci_memory_enabled(struct vfio_pci_device *vdev);
+extern void vfio_pci_zap_mmap_vmas(struct vfio_pci_device *vdev);
+
 #ifdef CONFIG_VFIO_PCI_IGD
 extern int vfio_pci_igd_init(struct vfio_pci_device *vdev);
 #else
diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
index a87992892a9f..f58c45308682 100644
--- a/drivers/vfio/pci/vfio_pci_rdwr.c
+++ b/drivers/vfio/pci/vfio_pci_rdwr.c
@@ -162,6 +162,7 @@ ssize_t vfio_pci_bar_rw(struct vfio_pci_device *vdev, char __user *buf,
 	size_t x_start = 0, x_end = 0;
 	resource_size_t end;
 	void __iomem *io;
+	struct resource *res = &vdev->pdev->resource[bar];
 	ssize_t done;
 
 	if (pci_resource_start(pdev, bar))
@@ -200,8 +201,19 @@ ssize_t vfio_pci_bar_rw(struct vfio_pci_device *vdev, char __user *buf,
 		x_end = vdev->msix_offset + vdev->msix_size;
 	}
 
+	if (res->flags & IORESOURCE_MEM) {
+		down_read(&vdev->memory_lock);
+		if (!__vfio_pci_memory_enabled(vdev)) {
+			up_read(&vdev->memory_lock);
+			return -EIO;
+		}
+	}
+
 	done = do_io_rw(io, buf, pos, count, x_start, x_end, iswrite);
 
+	if (res->flags & IORESOURCE_MEM)
+		up_read(&vdev->memory_lock);
+
 	if (done >= 0)
 		*ppos += done;
 

