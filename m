Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD15D13293D
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2020 15:47:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728326AbgAGOrM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jan 2020 09:47:12 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:9120 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728080AbgAGOrM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jan 2020 09:47:12 -0500
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 3A7811D2FC4068FC053E;
        Tue,  7 Jan 2020 22:47:07 +0800 (CST)
Received: from localhost (10.177.98.84) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.439.0; Tue, 7 Jan 2020
 22:46:58 +0800
From:   weiqi <weiqi4@huawei.com>
To:     <alexander.h.duyck@linux.intel.com>, <alex.williamson@redhat.com>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <pbonzini@redhat.com>, <x86@kernel.org>, wei qi <weiqi4@huawei.com>
Subject: [PATCH 2/2] KVM: add support for page hinting
Date:   Tue, 7 Jan 2020 22:46:39 +0800
Message-ID: <1578408399-20092-3-git-send-email-weiqi4@huawei.com>
X-Mailer: git-send-email 1.8.4.msysgit.0
In-Reply-To: <1578408399-20092-1-git-send-email-weiqi4@huawei.com>
References: <1578408399-20092-1-git-send-email-weiqi4@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.177.98.84]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: wei qi <weiqi4@huawei.com>

add support for page hinting.

Signed-off-by: wei qi <weiqi4@huawei.com>
---
 arch/x86/kvm/mmu/mmu.c   | 79 +++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.c       | 96 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/kvm_host.h | 41 +++++++++++++++++++++
 include/uapi/linux/kvm.h |  7 ++++
 virt/kvm/vfio.c          | 11 ------
 5 files changed, 223 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 6f92b40..0cf2584 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4259,6 +4259,71 @@ int kvm_handle_page_fault(struct kvm_vcpu *vcpu, u64 error_code,
 	return kvm_mtrr_check_gfn_range_consistency(vcpu, gfn, page_num);
 }
 
+#include <linux/vfio.h>
+static void kvm_vfio_mmap_range(struct kvm_vcpu *vcpu, struct kvm_device *tmp,
+				gfn_t gfn, kvm_pfn_t pfn)
+{
+	struct kvm_vfio *kv = tmp->private;
+	struct kvm_vfio_group *kvg;
+
+	list_for_each_entry(kvg, &kv->group_list, node) {
+		struct vfio_group *group = kvg->vfio_group;
+		struct vfio_device *it, *device = NULL;
+
+		list_for_each_entry(it, &group->device_list, group_next) {
+			int flags;
+			unsigned long page_size;
+			struct kvm_memory_slot *memslot;
+			int size;
+			unsigned long old_pfn = 0;
+			gfn_t gfn_base;
+			kvm_pfn_t pfn_base;
+
+			device = it;
+			memslot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
+			page_size = kvm_host_page_size(vcpu->kvm, gfn);
+
+			/* only discard free pages, just check 2M hugetlb */
+			if (page_size >> PAGE_SHIFT != 512)
+				return;
+
+			gfn_base = ((gfn << PAGE_SHIFT) & (~(page_size - 1)))
+					>> PAGE_SHIFT;
+			pfn_base = ((pfn << PAGE_SHIFT) & (~(page_size - 1)))
+					>> PAGE_SHIFT;
+
+			while ((gfn << PAGE_SHIFT) & (page_size - 1))
+				page_size >>= 1;
+
+			while (__gfn_to_hva_memslot(memslot, gfn) &
+						(page_size - 1))
+				page_size >>= 1;
+
+			size = vfio_dma_find(device->dev, gfn_base,
+					page_size >> PAGE_SHIFT, &old_pfn);
+			if (!size) {
+				pr_err("%s:not find dma: gfn: %llx, size: %lu.\n",
+					__func__, gfn_base,
+					page_size >> PAGE_SHIFT);
+				return;
+			}
+			if (!old_pfn)
+				pr_err("%s: not find pfn: gfn: %llx, size: %lu.\n",
+					__func__, gfn_base,
+					page_size >> PAGE_SHIFT);
+
+			if (pfn_base == old_pfn)
+				return;
+
+			flags = IOMMU_READ;
+			if (!(memslot->flags & KVM_MEM_READONLY))
+				flags |= IOMMU_WRITE;
+			vfio_mmap_pages(device->dev, gfn,
+					page_size, flags, pfn);
+		}
+	}
+}
+
 static int tdp_page_fault(struct kvm_vcpu *vcpu, gva_t gpa, u32 error_code,
 			  bool prefault)
 {
@@ -4317,6 +4382,20 @@ static int tdp_page_fault(struct kvm_vcpu *vcpu, gva_t gpa, u32 error_code,
 			 prefault, lpage_disallowed);
 out_unlock:
 	spin_unlock(&vcpu->kvm->mmu_lock);
+
+	if (!is_noslot_pfn(pfn) && gfn) {
+		struct kvm_device *tmp;
+
+		list_for_each_entry(tmp, &vcpu->kvm->devices, vm_node) {
+			if (tmp->ops && tmp->ops->name &&
+				(!strcmp(tmp->ops->name, "kvm-vfio"))) {
+				spin_lock(&vcpu->kvm->discard_lock);
+				kvm_vfio_mmap_range(vcpu, tmp, gfn, pfn);
+				spin_unlock(&vcpu->kvm->discard_lock);
+			}
+		}
+	}
+
 	kvm_release_pfn_clean(pfn);
 	return r;
 }
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index cf91713..264c65e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4837,6 +4837,92 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 	return r;
 }
 
+#include <linux/vfio.h>
+static void kvm_vfio_ummap_range(struct kvm *kvm, struct kvm_device *tmp,
+				gfn_t gfn, int npages, unsigned long hva)
+{
+	struct kvm_vfio *kv = tmp->private;
+	struct kvm_vfio_group *kvg;
+
+	list_for_each_entry(kvg, &kv->group_list, node) {
+		struct vfio_group *group = kvg->vfio_group;
+		struct vfio_device *it, *device = NULL;
+
+		list_for_each_entry(it, &group->device_list, group_next) {
+			unsigned long page_size, page_size_base;
+			unsigned long addr;
+			int size;
+			unsigned long old_pfn = 0;
+			int ret = 0;
+			size_t unmapped = npages;
+			gfn_t iova_gfn = gfn;
+			unsigned long iova_hva = hva;
+
+			device = it;
+			while (unmapped) {
+				addr = gfn_to_hva(kvm, iova_gfn);
+				page_size_base = page_size =
+						kvm_host_page_size(kvm,
+						iova_gfn);
+
+				if (addr != iova_hva)
+					return;
+
+				while ((iova_gfn << PAGE_SHIFT) &
+					(page_size - 1))
+					page_size >>= 1;
+
+				while (addr & (page_size - 1))
+					page_size >>= 1;
+
+				if (page_size_base != page_size)
+					return;
+
+				size = vfio_dma_find(device->dev, iova_gfn,
+						page_size >> PAGE_SHIFT,
+						&old_pfn);
+				if (!size)
+					return;
+
+				if (!old_pfn)
+					return;
+
+				ret = vfio_munmap_pages(device->dev,
+						iova_gfn, page_size);
+				unmapped -= page_size >> PAGE_SHIFT;
+				iova_hva += page_size;
+				iova_gfn += page_size >> PAGE_SHIFT;
+			}
+		}
+	}
+}
+
+
+static int kvm_vm_ioctl_discard_range(struct kvm *kvm,
+				struct kvm_discard_msg *msg)
+{
+	gfn_t gfn, end_gfn;
+	int idx;
+	struct kvm_device *tmp;
+	unsigned long hva = msg->iov_base;
+	int npages = msg->iov_len >> PAGE_SHIFT;
+
+	gfn = gpa_to_gfn(msg->in_addr);
+	end_gfn = gpa_to_gfn(msg->in_addr + msg->iov_len);
+
+	idx = srcu_read_lock(&kvm->srcu);
+
+	list_for_each_entry(tmp, &kvm->devices, vm_node) {
+		if (tmp->ops->name && (!strcmp(tmp->ops->name, "kvm-vfio"))) {
+			spin_lock(&kvm->discard_lock);
+			kvm_vfio_ummap_range(kvm, tmp, gfn, npages, hva);
+			spin_unlock(&kvm->discard_lock);
+		}
+	}
+	srcu_read_unlock(&kvm->srcu, idx);
+	return 0;
+}
+
 long kvm_arch_vm_ioctl(struct file *filp,
 		       unsigned int ioctl, unsigned long arg)
 {
@@ -5134,6 +5220,16 @@ long kvm_arch_vm_ioctl(struct file *filp,
 	case KVM_SET_PMU_EVENT_FILTER:
 		r = kvm_vm_ioctl_set_pmu_event_filter(kvm, argp);
 		break;
+	case KVM_DISCARD_RANGE: {
+		struct kvm_discard_msg discard_msg;
+
+		r = -EFAULT;
+		if (copy_from_user(&discard_msg, argp, sizeof(discard_msg)))
+			goto out;
+
+		r = kvm_vm_ioctl_discard_range(kvm, &discard_msg);
+		break;
+	}
 	default:
 		r = -ENOTTY;
 	}
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 538c25e..6667e6b 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -442,6 +442,7 @@ struct kvm_memslots {
 
 struct kvm {
 	spinlock_t mmu_lock;
+	spinlock_t discard_lock;
 	struct mutex slots_lock;
 	struct mm_struct *mm; /* userspace tied to this vm */
 	struct kvm_memslots __rcu *memslots[KVM_ADDRESS_SPACE_NUM];
@@ -502,6 +503,46 @@ struct kvm {
 	struct srcu_struct irq_srcu;
 	pid_t userspace_pid;
 };
+struct vfio_device {
+	struct kref                     kref;
+	struct device                   *dev;
+	const struct vfio_device_ops    *ops;
+	struct vfio_group               *group;
+	struct list_head                group_next;
+	void                            *device_data;
+};
+
+struct vfio_group {
+	struct kref                     kref;
+	int                             minor;
+	atomic_t                        container_users;
+	struct iommu_group              *iommu_group;
+	struct vfio_container           *container;
+	struct list_head                device_list;
+	struct mutex                    device_lock;
+	struct device                   *dev;
+	struct notifier_block           nb;
+	struct list_head                vfio_next;
+	struct list_head                container_next;
+	struct list_head                unbound_list;
+	struct mutex                    unbound_lock;
+	atomic_t                        opened;
+	wait_queue_head_t               container_q;
+	bool                            noiommu;
+	struct kvm                      *kvm;
+	struct blocking_notifier_head   notifier;
+};
+
+struct kvm_vfio_group {
+	struct list_head node;
+	struct vfio_group *vfio_group;
+};
+
+struct kvm_vfio {
+	struct list_head group_list;
+	struct mutex lock;
+	bool noncoherent;
+};
 
 #define kvm_err(fmt, ...) \
 	pr_err("kvm [%i]: " fmt, task_pid_nr(current), ## __VA_ARGS__)
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index f0a16b4..53331fe 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1264,6 +1264,13 @@ struct kvm_vfio_spapr_tce {
 					struct kvm_userspace_memory_region)
 #define KVM_SET_TSS_ADDR          _IO(KVMIO,   0x47)
 #define KVM_SET_IDENTITY_MAP_ADDR _IOW(KVMIO,  0x48, __u64)
+struct kvm_discard_msg {
+	__u64 iov_len;
+	__u64 iov_base;
+	__u64 in_addr;
+};
+#define KVM_DISCARD_RANGE   _IOW(KVMIO, 0x49, struct kvm_discard_msg)
+
 
 /* enable ucontrol for s390 */
 struct kvm_s390_ucas_mapping {
diff --git a/virt/kvm/vfio.c b/virt/kvm/vfio.c
index 8fcbc50..f6dc61e 100644
--- a/virt/kvm/vfio.c
+++ b/virt/kvm/vfio.c
@@ -21,17 +21,6 @@
 #include <asm/kvm_ppc.h>
 #endif
 
-struct kvm_vfio_group {
-	struct list_head node;
-	struct vfio_group *vfio_group;
-};
-
-struct kvm_vfio {
-	struct list_head group_list;
-	struct mutex lock;
-	bool noncoherent;
-};
-
 static struct vfio_group *kvm_vfio_group_get_external_user(struct file *filep)
 {
 	struct vfio_group *vfio_group;
-- 
1.8.3.1


