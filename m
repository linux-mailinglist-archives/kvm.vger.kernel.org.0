Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F00F6128672
	for <lists+kvm@lfdr.de>; Sat, 21 Dec 2019 02:50:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727102AbfLUBuI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Dec 2019 20:50:08 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:22132 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727031AbfLUBuE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Dec 2019 20:50:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576893001;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wEpiTAXa52nbyr0HfKis/BYP1bYtv5k7ov5YPyzos1k=;
        b=fVJEFCaQ6oRG8j/58Dm6EBYPQsjoYb8LdtR5qUkTaaZSXm6WO5UOp8tLBuzY91U5dYttgI
        eEk8zXAUsZzQ+dixQAROsXKsrBp4pnj/RYFEb5bJ7uLxdix8mRY5bMuNWsl7icHaw0aAfC
        vvu2AgX4HWx3Iocz31mTLuzjL86+iJQ=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-409-TdMqzhzrO6W2BIgg2DMs8Q-1; Fri, 20 Dec 2019 20:49:59 -0500
X-MC-Unique: TdMqzhzrO6W2BIgg2DMs8Q-1
Received: by mail-qv1-f69.google.com with SMTP id di5so2068028qvb.3
        for <kvm@vger.kernel.org>; Fri, 20 Dec 2019 17:49:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wEpiTAXa52nbyr0HfKis/BYP1bYtv5k7ov5YPyzos1k=;
        b=MLpak6kclrDvizWBkFQnMmFuSt0vWVl3douxh35rpIRaZZjA9y8FrBhInB3vRjO0pE
         MiFGt31rmBdd0V/AboV8UzvQ76GqaoTbdFBYL3EHqjJLVXFzZUio0wX54P5jimzvN1qm
         9IG0Ud+xzD/XOVz2L3ideRx4MoyzUpBVamkZHieYFm/p/LEmdj3EsW0xaM7Qzfx0qFit
         wjM4QSt2ZHVTnJNK+e1dwZ1vuFV87LrB+nMVgLopnpCpkZx174iOrhbf01gbwuw8sNkK
         dEeUKi3hCh6FV2wYM/Ww63rr4NS+SasICaaAHKxycU5N66J5JOoIFIvMsZcTl21t/eQH
         KRqg==
X-Gm-Message-State: APjAAAVskGvrpU7xTddu88E+W3zPfNlHj9K2+zwCSecHc3Z/C8y46J8D
        naI4pKOwGyqeHKN6CeCRdyZ0g85jJj6ZR0nJamAshY9VdrPYJnrkt6wGdsbvuOp2cpObA7OX6AG
        SSA7j0P7yKdDj
X-Received: by 2002:ac8:1a19:: with SMTP id v25mr14591951qtj.146.1576892998540;
        Fri, 20 Dec 2019 17:49:58 -0800 (PST)
X-Google-Smtp-Source: APXvYqzSIB0J1Ds2Jn3h4oMYDn5ye+C/BsNblwk+pdGEuCt8GM3qQW6EM2S23C09K2pkg4W2JxK3Fw==
X-Received: by 2002:ac8:1a19:: with SMTP id v25mr14591914qtj.146.1576892997584;
        Fri, 20 Dec 2019 17:49:57 -0800 (PST)
Received: from xz-x1.hitronhub.home (CPEf81d0fb19163-CMf81d0fb19160.cpe.net.fido.ca. [72.137.123.47])
        by smtp.gmail.com with ESMTPSA id e21sm3396932qkm.55.2019.12.20.17.49.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Dec 2019 17:49:56 -0800 (PST)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        peterx@redhat.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Lei Cao <lei.cao@stratus.com>
Subject: [PATCH RESEND v2 08/17] KVM: X86: Implement ring-based dirty memory tracking
Date:   Fri, 20 Dec 2019 20:49:29 -0500
Message-Id: <20191221014938.58831-9-peterx@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191221014938.58831-1-peterx@redhat.com>
References: <20191221014938.58831-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch is heavily based on previous work from Lei Cao
<lei.cao@stratus.com> and Paolo Bonzini <pbonzini@redhat.com>. [1]

KVM currently uses large bitmaps to track dirty memory.  These bitmaps
are copied to userspace when userspace queries KVM for its dirty page
information.  The use of bitmaps is mostly sufficient for live
migration, as large parts of memory are be dirtied from one log-dirty
pass to another.  However, in a checkpointing system, the number of
dirty pages is small and in fact it is often bounded---the VM is
paused when it has dirtied a pre-defined number of pages. Traversing a
large, sparsely populated bitmap to find set bits is time-consuming,
as is copying the bitmap to user-space.

A similar issue will be there for live migration when the guest memory
is huge while the page dirty procedure is trivial.  In that case for
each dirty sync we need to pull the whole dirty bitmap to userspace
and analyse every bit even if it's mostly zeros.

The preferred data structure for above scenarios is a dense list of
guest frame numbers (GFN).  This patch series stores the dirty list in
kernel memory that can be memory mapped into userspace to allow speedy
harvesting.

This patch enables dirty ring for X86 only.  However it should be
easily extended to other archs as well.

[1] https://patchwork.kernel.org/patch/10471409/

Signed-off-by: Lei Cao <lei.cao@stratus.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Peter Xu <peterx@redhat.com>
---
 Documentation/virt/kvm/api.txt  |  89 ++++++++++++++
 arch/x86/include/asm/kvm_host.h |   3 +
 arch/x86/include/uapi/asm/kvm.h |   1 +
 arch/x86/kvm/Makefile           |   3 +-
 arch/x86/kvm/mmu.c              |   6 +
 arch/x86/kvm/vmx/vmx.c          |   7 ++
 arch/x86/kvm/x86.c              |   9 ++
 include/linux/kvm_dirty_ring.h  |  57 +++++++++
 include/linux/kvm_host.h        |  28 +++++
 include/trace/events/kvm.h      |  78 +++++++++++++
 include/uapi/linux/kvm.h        |  31 +++++
 virt/kvm/dirty_ring.c           | 201 ++++++++++++++++++++++++++++++++
 virt/kvm/kvm_main.c             | 172 ++++++++++++++++++++++++++-
 13 files changed, 682 insertions(+), 3 deletions(-)
 create mode 100644 include/linux/kvm_dirty_ring.h
 create mode 100644 virt/kvm/dirty_ring.c

diff --git a/Documentation/virt/kvm/api.txt b/Documentation/virt/kvm/api.txt
index 4833904d32a5..c141b285e673 100644
--- a/Documentation/virt/kvm/api.txt
+++ b/Documentation/virt/kvm/api.txt
@@ -231,6 +231,7 @@ Based on their initialization different VMs may have different capabilities.
 It is thus encouraged to use the vm ioctl to query for capabilities (available
 with KVM_CAP_CHECK_EXTENSION_VM on the vm fd)
 
+
 4.5 KVM_GET_VCPU_MMAP_SIZE
 
 Capability: basic
@@ -243,6 +244,18 @@ The KVM_RUN ioctl (cf.) communicates with userspace via a shared
 memory region.  This ioctl returns the size of that region.  See the
 KVM_RUN documentation for details.
 
+Besides the size of the KVM_RUN communication region, other areas of
+the VCPU file descriptor can be mmap-ed, including:
+
+- if KVM_CAP_COALESCED_MMIO is available, a page at
+  KVM_COALESCED_MMIO_PAGE_OFFSET * PAGE_SIZE; for historical reasons,
+  this page is included in the result of KVM_GET_VCPU_MMAP_SIZE.
+  KVM_CAP_COALESCED_MMIO is not documented yet.
+
+- if KVM_CAP_DIRTY_LOG_RING is available, a number of pages at
+  KVM_DIRTY_LOG_PAGE_OFFSET * PAGE_SIZE.  For more information on
+  KVM_CAP_DIRTY_LOG_RING, see section 8.3.
+
 
 4.6 KVM_SET_MEMORY_REGION
 
@@ -5302,6 +5315,7 @@ CPU when the exception is taken. If this virtual SError is taken to EL1 using
 AArch64, this value will be reported in the ISS field of ESR_ELx.
 
 See KVM_CAP_VCPU_EVENTS for more details.
+
 8.20 KVM_CAP_HYPERV_SEND_IPI
 
 Architectures: x86
@@ -5309,6 +5323,7 @@ Architectures: x86
 This capability indicates that KVM supports paravirtualized Hyper-V IPI send
 hypercalls:
 HvCallSendSyntheticClusterIpi, HvCallSendSyntheticClusterIpiEx.
+
 8.21 KVM_CAP_HYPERV_DIRECT_TLBFLUSH
 
 Architecture: x86
@@ -5322,3 +5337,77 @@ handling by KVM (as some KVM hypercall may be mistakenly treated as TLB
 flush hypercalls by Hyper-V) so userspace should disable KVM identification
 in CPUID and only exposes Hyper-V identification. In this case, guest
 thinks it's running on Hyper-V and only use Hyper-V hypercalls.
+
+8.22 KVM_CAP_DIRTY_LOG_RING
+
+Architectures: x86
+Parameters: args[0] - size of the dirty log ring
+
+KVM is capable of tracking dirty memory using ring buffers that are
+mmaped into userspace; there is one dirty ring per vcpu.
+
+One dirty ring is defined as below internally:
+
+struct kvm_dirty_ring {
+	u32 dirty_index;
+	u32 reset_index;
+	u32 size;
+	u32 soft_limit;
+	struct kvm_dirty_gfn *dirty_gfns;
+	struct kvm_dirty_ring_indices *indices;
+	int index;
+};
+
+Dirty GFNs (Guest Frame Numbers) are stored in the dirty_gfns array.
+For each of the dirty entry it's defined as:
+
+struct kvm_dirty_gfn {
+        __u32 pad;
+        __u32 slot; /* as_id | slot_id */
+        __u64 offset;
+};
+
+Most of the ring structure is used by KVM internally, while only the
+indices are exposed to userspace:
+
+struct kvm_dirty_ring_indices {
+	__u32 avail_index; /* set by kernel */
+	__u32 fetch_index; /* set by userspace */
+};
+
+The two indices in the ring buffer are free running counters.
+
+Userspace calls KVM_ENABLE_CAP ioctl right after KVM_CREATE_VM ioctl
+to enable this capability for the new guest and set the size of the
+rings.  It is only allowed before creating any vCPU, and the size of
+the ring must be a power of two.  The larger the ring buffer, the less
+likely the ring is full and the VM is forced to exit to userspace. The
+optimal size depends on the workload, but it is recommended that it be
+at least 64 KiB (4096 entries).
+
+Just like for dirty page bitmaps, the buffer tracks writes to
+all user memory regions for which the KVM_MEM_LOG_DIRTY_PAGES flag was
+set in KVM_SET_USER_MEMORY_REGION.  Once a memory region is registered
+with the flag set, userspace can start harvesting dirty pages from the
+ring buffer.
+
+To harvest the dirty pages, userspace accesses the mmaped ring buffer
+to read the dirty GFNs up to avail_index, and sets the fetch_index
+accordingly.  This can be done when the guest is running or paused,
+and dirty pages need not be collected all at once.  After processing
+one or more entries in the ring buffer, userspace calls the VM ioctl
+KVM_RESET_DIRTY_RINGS to notify the kernel that it has updated
+fetch_index and to mark those pages clean.  Therefore, the ioctl
+must be called *before* reading the content of the dirty pages.
+
+However, there is a major difference comparing to the
+KVM_GET_DIRTY_LOG interface in that when reading the dirty ring from
+userspace it's still possible that the kernel has not yet flushed the
+hardware dirty buffers into the kernel buffer (which was previously
+done by the KVM_GET_DIRTY_LOG ioctl).  To achieve that, one needs to
+kick the vcpu out for a hardware buffer flush (vmexit) to make sure
+all the existing dirty gfns are flushed to the dirty rings.
+
+If one of the ring buffers is full, the guest will exit to userspace
+with the exit reason set to KVM_EXIT_DIRTY_LOG_FULL, and the KVM_RUN
+ioctl will return to userspace with zero.
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 4fc61483919a..7e5e2d3f0509 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1159,6 +1159,7 @@ struct kvm_x86_ops {
 					   struct kvm_memory_slot *slot,
 					   gfn_t offset, unsigned long mask);
 	int (*write_log_dirty)(struct kvm_vcpu *vcpu);
+	int (*cpu_dirty_log_size)(void);
 
 	/* pmu operations of sub-arch */
 	const struct kvm_pmu_ops *pmu_ops;
@@ -1641,4 +1642,6 @@ static inline int kvm_cpu_get_apicid(int mps_cpu)
 #define GET_SMSTATE(type, buf, offset)		\
 	(*(type *)((buf) + (offset) - 0x7e00))
 
+int kvm_cpu_dirty_log_size(void);
+
 #endif /* _ASM_X86_KVM_HOST_H */
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 503d3f42da16..b59bf356c478 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -12,6 +12,7 @@
 
 #define KVM_PIO_PAGE_OFFSET 1
 #define KVM_COALESCED_MMIO_PAGE_OFFSET 2
+#define KVM_DIRTY_LOG_PAGE_OFFSET 64
 
 #define DE_VECTOR 0
 #define DB_VECTOR 1
diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index 31ecf7a76d5a..a66ddb552208 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -5,7 +5,8 @@ ccflags-y += -Iarch/x86/kvm
 KVM := ../../../virt/kvm
 
 kvm-y			+= $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o \
-				$(KVM)/eventfd.o $(KVM)/irqchip.o $(KVM)/vfio.o
+				$(KVM)/eventfd.o $(KVM)/irqchip.o $(KVM)/vfio.o \
+				$(KVM)/dirty_ring.o
 kvm-$(CONFIG_KVM_ASYNC_PF)	+= $(KVM)/async_pf.o
 
 kvm-y			+= x86.o mmu.o emulate.o i8259.o irq.o lapic.o \
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 2ce9da58611e..5f7d73730f73 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1818,7 +1818,13 @@ int kvm_arch_write_log_dirty(struct kvm_vcpu *vcpu)
 {
 	if (kvm_x86_ops->write_log_dirty)
 		return kvm_x86_ops->write_log_dirty(vcpu);
+	return 0;
+}
 
+int kvm_cpu_dirty_log_size(void)
+{
+	if (kvm_x86_ops->cpu_dirty_log_size)
+		return kvm_x86_ops->cpu_dirty_log_size();
 	return 0;
 }
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 1ff5a428f489..c3565319b481 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7686,6 +7686,7 @@ static __init int hardware_setup(void)
 		kvm_x86_ops->slot_disable_log_dirty = NULL;
 		kvm_x86_ops->flush_log_dirty = NULL;
 		kvm_x86_ops->enable_log_dirty_pt_masked = NULL;
+		kvm_x86_ops->cpu_dirty_log_size = NULL;
 	}
 
 	if (!cpu_has_vmx_preemption_timer())
@@ -7750,6 +7751,11 @@ static __exit void hardware_unsetup(void)
 	free_kvm_area();
 }
 
+static int vmx_cpu_dirty_log_size(void)
+{
+	return enable_pml ? PML_ENTITY_NUM : 0;
+}
+
 static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
 	.cpu_has_kvm_support = cpu_has_kvm_support,
 	.disabled_by_bios = vmx_disabled_by_bios,
@@ -7873,6 +7879,7 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
 	.flush_log_dirty = vmx_flush_log_dirty,
 	.enable_log_dirty_pt_masked = vmx_enable_log_dirty_pt_masked,
 	.write_log_dirty = vmx_write_pml_buffer,
+	.cpu_dirty_log_size = vmx_cpu_dirty_log_size,
 
 	.pre_block = vmx_pre_block,
 	.post_block = vmx_post_block,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5d530521f11d..f93262025a61 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7965,6 +7965,15 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 
 	bool req_immediate_exit = false;
 
+	/* Forbid vmenter if vcpu dirty ring is soft-full */
+	if (unlikely(vcpu->kvm->dirty_ring_size &&
+		     kvm_dirty_ring_soft_full(&vcpu->dirty_ring))) {
+		vcpu->run->exit_reason = KVM_EXIT_DIRTY_RING_FULL;
+		trace_kvm_dirty_ring_exit(vcpu);
+		r = 0;
+		goto out;
+	}
+
 	if (kvm_request_pending(vcpu)) {
 		if (kvm_check_request(KVM_REQ_GET_VMCS12_PAGES, vcpu)) {
 			if (unlikely(!kvm_x86_ops->get_vmcs12_pages(vcpu))) {
diff --git a/include/linux/kvm_dirty_ring.h b/include/linux/kvm_dirty_ring.h
new file mode 100644
index 000000000000..06db2312b383
--- /dev/null
+++ b/include/linux/kvm_dirty_ring.h
@@ -0,0 +1,57 @@
+#ifndef KVM_DIRTY_RING_H
+#define KVM_DIRTY_RING_H
+
+/**
+ * kvm_dirty_ring: KVM internal dirty ring structure
+ *
+ * @dirty_index: free running counter that points to the next slot in
+ *               dirty_ring->dirty_gfns, where a new dirty page should go
+ * @reset_index: free running counter that points to the next dirty page
+ *               in dirty_ring->dirty_gfns for which dirty trap needs to
+ *               be reenabled
+ * @size:        size of the compact list, dirty_ring->dirty_gfns
+ * @soft_limit:  when the number of dirty pages in the list reaches this
+ *               limit, vcpu that owns this ring should exit to userspace
+ *               to allow userspace to harvest all the dirty pages
+ * @dirty_gfns:  the array to keep the dirty gfns
+ * @indices:     the pointer to the @kvm_dirty_ring_indices structure
+ *               of this specific ring
+ * @index:       index of this dirty ring
+ */
+struct kvm_dirty_ring {
+	u32 dirty_index;
+	u32 reset_index;
+	u32 size;
+	u32 soft_limit;
+	struct kvm_dirty_gfn *dirty_gfns;
+	struct kvm_dirty_ring_indices *indices;
+	int index;
+};
+
+u32 kvm_dirty_ring_get_rsvd_entries(void);
+int kvm_dirty_ring_alloc(struct kvm_dirty_ring *ring,
+			 struct kvm_dirty_ring_indices *indices,
+			 int index, u32 size);
+struct kvm_dirty_ring *kvm_dirty_ring_get(struct kvm *kvm);
+void kvm_dirty_ring_put(struct kvm *kvm,
+			struct kvm_dirty_ring *ring);
+
+/*
+ * called with kvm->slots_lock held, returns the number of
+ * processed pages.
+ */
+int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring);
+
+/*
+ * returns =0: successfully pushed
+ *         <0: unable to push, need to wait
+ */
+int kvm_dirty_ring_push(struct kvm_dirty_ring *ring, u32 slot, u64 offset);
+
+/* for use in vm_operations_struct */
+struct page *kvm_dirty_ring_get_page(struct kvm_dirty_ring *ring, u32 offset);
+
+void kvm_dirty_ring_free(struct kvm_dirty_ring *ring);
+bool kvm_dirty_ring_soft_full(struct kvm_dirty_ring *ring);
+
+#endif
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index b4f7bef38e0d..dff214ab72eb 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -34,6 +34,7 @@
 #include <linux/kvm_types.h>
 
 #include <asm/kvm_host.h>
+#include <linux/kvm_dirty_ring.h>
 
 #ifndef KVM_MAX_VCPU_ID
 #define KVM_MAX_VCPU_ID KVM_MAX_VCPUS
@@ -321,6 +322,7 @@ struct kvm_vcpu {
 	bool ready;
 	struct kvm_vcpu_arch arch;
 	struct dentry *debugfs_dentry;
+	struct kvm_dirty_ring dirty_ring;
 };
 
 static inline int kvm_vcpu_exiting_guest_mode(struct kvm_vcpu *vcpu)
@@ -502,6 +504,9 @@ struct kvm {
 	struct srcu_struct srcu;
 	struct srcu_struct irq_srcu;
 	pid_t userspace_pid;
+	u32 dirty_ring_size;
+	struct spinlock dirty_ring_lock;
+	wait_queue_head_t dirty_ring_waitqueue;
 };
 
 #define kvm_err(fmt, ...) \
@@ -813,6 +818,8 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
 					gfn_t gfn_offset,
 					unsigned long mask);
 
+void kvm_reset_dirty_gfn(struct kvm *kvm, u32 slot, u64 offset, u64 mask);
+
 int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm,
 				struct kvm_dirty_log *log);
 int kvm_vm_ioctl_clear_dirty_log(struct kvm *kvm,
@@ -1392,4 +1399,25 @@ int kvm_vm_create_worker_thread(struct kvm *kvm, kvm_vm_thread_fn_t thread_fn,
 				uintptr_t data, const char *name,
 				struct task_struct **thread_ptr);
 
+/*
+ * This defines how many reserved entries we want to keep before we
+ * kick the vcpu to the userspace to avoid dirty ring full.  This
+ * value can be tuned to higher if e.g. PML is enabled on the host.
+ */
+#define  KVM_DIRTY_RING_RSVD_ENTRIES  64
+
+/* Max number of entries allowed for each kvm dirty ring */
+#define  KVM_DIRTY_RING_MAX_ENTRIES  65536
+
+/*
+ * Arch needs to define these macro after implementing the dirty ring
+ * feature.  KVM_DIRTY_LOG_PAGE_OFFSET should be defined as the
+ * starting page offset of the dirty ring structures, while
+ * KVM_DIRTY_RING_VERSION should be defined as >=1.  By default, this
+ * feature is off on all archs.
+ */
+#ifndef KVM_DIRTY_LOG_PAGE_OFFSET
+#define KVM_DIRTY_LOG_PAGE_OFFSET 0
+#endif
+
 #endif
diff --git a/include/trace/events/kvm.h b/include/trace/events/kvm.h
index 2c735a3e6613..3d850997940c 100644
--- a/include/trace/events/kvm.h
+++ b/include/trace/events/kvm.h
@@ -399,6 +399,84 @@ TRACE_EVENT(kvm_halt_poll_ns,
 #define trace_kvm_halt_poll_ns_shrink(vcpu_id, new, old) \
 	trace_kvm_halt_poll_ns(false, vcpu_id, new, old)
 
+TRACE_EVENT(kvm_dirty_ring_push,
+	TP_PROTO(struct kvm_dirty_ring *ring, u32 slot, u64 offset),
+	TP_ARGS(ring, slot, offset),
+
+	TP_STRUCT__entry(
+		__field(int, index)
+		__field(u32, dirty_index)
+		__field(u32, reset_index)
+		__field(u32, slot)
+		__field(u64, offset)
+	),
+
+	TP_fast_assign(
+		__entry->index          = ring->index;
+		__entry->dirty_index    = ring->dirty_index;
+		__entry->reset_index    = ring->reset_index;
+		__entry->slot           = slot;
+		__entry->offset         = offset;
+	),
+
+	TP_printk("ring %d: dirty 0x%x reset 0x%x "
+		  "slot %u offset 0x%llx (used %u)",
+		  __entry->index, __entry->dirty_index,
+		  __entry->reset_index,  __entry->slot, __entry->offset,
+		  __entry->dirty_index - __entry->reset_index)
+);
+
+TRACE_EVENT(kvm_dirty_ring_reset,
+	TP_PROTO(struct kvm_dirty_ring *ring),
+	TP_ARGS(ring),
+
+	TP_STRUCT__entry(
+		__field(int, index)
+		__field(u32, dirty_index)
+		__field(u32, reset_index)
+	),
+
+	TP_fast_assign(
+		__entry->index          = ring->index;
+		__entry->dirty_index    = ring->dirty_index;
+		__entry->reset_index    = ring->reset_index;
+	),
+
+	TP_printk("ring %d: dirty 0x%x reset 0x%x (used %u)",
+		  __entry->index, __entry->dirty_index, __entry->reset_index,
+		  __entry->dirty_index - __entry->reset_index)
+);
+
+TRACE_EVENT(kvm_dirty_ring_waitqueue,
+	TP_PROTO(bool enter),
+	TP_ARGS(enter),
+
+	TP_STRUCT__entry(
+	    __field(bool, enter)
+	),
+
+	TP_fast_assign(
+	    __entry->enter = enter;
+	),
+
+	TP_printk("%s", __entry->enter ? "wait" : "awake")
+);
+
+TRACE_EVENT(kvm_dirty_ring_exit,
+	TP_PROTO(struct kvm_vcpu *vcpu),
+	TP_ARGS(vcpu),
+
+	TP_STRUCT__entry(
+	    __field(int, vcpu_id)
+	),
+
+	TP_fast_assign(
+	    __entry->vcpu_id = vcpu->vcpu_id;
+	),
+
+	TP_printk("vcpu %d", __entry->vcpu_id)
+);
+
 #endif /* _TRACE_KVM_MAIN_H */
 
 /* This part must be outside protection */
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 52641d8ca9e8..5ea98e35a129 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -235,6 +235,7 @@ struct kvm_hyperv_exit {
 #define KVM_EXIT_S390_STSI        25
 #define KVM_EXIT_IOAPIC_EOI       26
 #define KVM_EXIT_HYPERV           27
+#define KVM_EXIT_DIRTY_RING_FULL  28
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -246,6 +247,11 @@ struct kvm_hyperv_exit {
 /* Encounter unexpected vm-exit reason */
 #define KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON	4
 
+struct kvm_dirty_ring_indices {
+	__u32 avail_index; /* set by kernel */
+	__u32 fetch_index; /* set by userspace */
+};
+
 /* for KVM_RUN, returned by mmap(vcpu_fd, offset=0) */
 struct kvm_run {
 	/* in */
@@ -415,6 +421,8 @@ struct kvm_run {
 		struct kvm_sync_regs regs;
 		char padding[SYNC_REGS_SIZE_BYTES];
 	} s;
+
+	struct kvm_dirty_ring_indices vcpu_ring_indices;
 };
 
 /* for KVM_REGISTER_COALESCED_MMIO / KVM_UNREGISTER_COALESCED_MMIO */
@@ -1000,6 +1008,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_PMU_EVENT_FILTER 173
 #define KVM_CAP_ARM_IRQ_LINE_LAYOUT_2 174
 #define KVM_CAP_HYPERV_DIRECT_TLBFLUSH 175
+#define KVM_CAP_DIRTY_LOG_RING 176
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -1461,6 +1470,9 @@ struct kvm_enc_region {
 /* Available with KVM_CAP_ARM_SVE */
 #define KVM_ARM_VCPU_FINALIZE	  _IOW(KVMIO,  0xc2, int)
 
+/* Available with KVM_CAP_DIRTY_LOG_RING */
+#define KVM_RESET_DIRTY_RINGS     _IO(KVMIO, 0xc3)
+
 /* Secure Encrypted Virtualization command */
 enum sev_cmd_id {
 	/* Guest initialization commands */
@@ -1611,4 +1623,23 @@ struct kvm_hyperv_eventfd {
 #define KVM_HYPERV_CONN_ID_MASK		0x00ffffff
 #define KVM_HYPERV_EVENTFD_DEASSIGN	(1 << 0)
 
+/*
+ * The following are the requirements for supporting dirty log ring
+ * (by enabling KVM_DIRTY_LOG_PAGE_OFFSET).
+ *
+ * 1. Memory accesses by KVM should call kvm_vcpu_write_* instead
+ *    of kvm_write_* so that the global dirty ring is not filled up
+ *    too quickly.
+ * 2. kvm_arch_mmu_enable_log_dirty_pt_masked should be defined for
+ *    enabling dirty logging.
+ * 3. There should not be a separate step to synchronize hardware
+ *    dirty bitmap with KVM's.
+ */
+
+struct kvm_dirty_gfn {
+	__u32 pad;
+	__u32 slot;
+	__u64 offset;
+};
+
 #endif /* __LINUX_KVM_H */
diff --git a/virt/kvm/dirty_ring.c b/virt/kvm/dirty_ring.c
new file mode 100644
index 000000000000..c614822493ff
--- /dev/null
+++ b/virt/kvm/dirty_ring.c
@@ -0,0 +1,201 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * KVM dirty ring implementation
+ *
+ * Copyright 2019 Red Hat, Inc.
+ */
+#include <linux/kvm_host.h>
+#include <linux/kvm.h>
+#include <linux/vmalloc.h>
+#include <linux/kvm_dirty_ring.h>
+#include <trace/events/kvm.h>
+
+int __weak kvm_cpu_dirty_log_size(void)
+{
+	return 0;
+}
+
+u32 kvm_dirty_ring_get_rsvd_entries(void)
+{
+	return KVM_DIRTY_RING_RSVD_ENTRIES + kvm_cpu_dirty_log_size();
+}
+
+static u32 kvm_dirty_ring_used(struct kvm_dirty_ring *ring)
+{
+	return READ_ONCE(ring->dirty_index) - READ_ONCE(ring->reset_index);
+}
+
+bool kvm_dirty_ring_soft_full(struct kvm_dirty_ring *ring)
+{
+	return kvm_dirty_ring_used(ring) >= ring->soft_limit;
+}
+
+bool kvm_dirty_ring_full(struct kvm_dirty_ring *ring)
+{
+	return kvm_dirty_ring_used(ring) >= ring->size;
+}
+
+struct kvm_dirty_ring *kvm_dirty_ring_get(struct kvm *kvm)
+{
+	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
+
+        /*
+	 * TODO: Currently use vcpu0 as default ring.  Note that this
+	 * should not happen only if called by kvmgt_rw_gpa for x86.
+	 * After the kvmgt code refactoring we should remove this,
+	 * together with the kvm->dirty_ring_lock.
+	 */
+	if (!vcpu) {
+		pr_warn_once("Detected page dirty without vcpu context. "
+			     "Probably because kvm-gt is used. "
+			     "May expect unbalanced loads on vcpu0.");
+		vcpu = kvm->vcpus[0];
+	}
+
+	WARN_ON_ONCE(vcpu->kvm != kvm);
+
+	if (vcpu == kvm->vcpus[0])
+		spin_lock(&kvm->dirty_ring_lock);
+
+	return &vcpu->dirty_ring;
+}
+
+void kvm_dirty_ring_put(struct kvm *kvm,
+			struct kvm_dirty_ring *ring)
+{
+	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
+
+	if (!vcpu)
+		vcpu = kvm->vcpus[0];
+
+	WARN_ON_ONCE(vcpu->kvm != kvm);
+	WARN_ON_ONCE(&vcpu->dirty_ring != ring);
+
+	if (vcpu == kvm->vcpus[0])
+		spin_unlock(&kvm->dirty_ring_lock);
+}
+
+int kvm_dirty_ring_alloc(struct kvm_dirty_ring *ring,
+			 struct kvm_dirty_ring_indices *indices,
+			 int index, u32 size)
+{
+	ring->dirty_gfns = vmalloc(size);
+	if (!ring->dirty_gfns)
+		return -ENOMEM;
+	memset(ring->dirty_gfns, 0, size);
+
+	ring->size = size / sizeof(struct kvm_dirty_gfn);
+	ring->soft_limit = ring->size - kvm_dirty_ring_get_rsvd_entries();
+	ring->dirty_index = 0;
+	ring->reset_index = 0;
+	ring->index = index;
+	ring->indices = indices;
+
+	return 0;
+}
+
+int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring)
+{
+	u32 cur_slot, next_slot;
+	u64 cur_offset, next_offset;
+	unsigned long mask;
+	u32 fetch;
+	int count = 0;
+	struct kvm_dirty_gfn *entry;
+	struct kvm_dirty_ring_indices *indices = ring->indices;
+	bool first_round = true;
+
+	fetch = READ_ONCE(indices->fetch_index);
+
+	/*
+	 * Note that fetch_index is written by the userspace, which
+	 * should not be trusted.  If this happens, then it's probably
+	 * that the userspace has written a wrong fetch_index.
+	 */
+	if (fetch - ring->reset_index > ring->size)
+		return -EINVAL;
+
+	if (fetch == ring->reset_index)
+		return 0;
+
+	/* This is only needed to make compilers happy */
+	cur_slot = cur_offset = mask = 0;
+	while (ring->reset_index != fetch) {
+		entry = &ring->dirty_gfns[ring->reset_index & (ring->size - 1)];
+		next_slot = READ_ONCE(entry->slot);
+		next_offset = READ_ONCE(entry->offset);
+		ring->reset_index++;
+		count++;
+		/*
+		 * Try to coalesce the reset operations when the guest is
+		 * scanning pages in the same slot.
+		 */
+		if (!first_round && next_slot == cur_slot) {
+			s64 delta = next_offset - cur_offset;
+
+			if (delta >= 0 && delta < BITS_PER_LONG) {
+				mask |= 1ull << delta;
+				continue;
+			}
+
+			/* Backwards visit, careful about overflows!  */
+			if (delta > -BITS_PER_LONG && delta < 0 &&
+			    (mask << -delta >> -delta) == mask) {
+				cur_offset = next_offset;
+				mask = (mask << -delta) | 1;
+				continue;
+			}
+		}
+		kvm_reset_dirty_gfn(kvm, cur_slot, cur_offset, mask);
+		cur_slot = next_slot;
+		cur_offset = next_offset;
+		mask = 1;
+		first_round = false;
+	}
+	kvm_reset_dirty_gfn(kvm, cur_slot, cur_offset, mask);
+
+	trace_kvm_dirty_ring_reset(ring);
+
+	return count;
+}
+
+int kvm_dirty_ring_push(struct kvm_dirty_ring *ring, u32 slot, u64 offset)
+{
+	struct kvm_dirty_gfn *entry;
+	struct kvm_dirty_ring_indices *indices = ring->indices;
+
+	/*
+	 * Note: here we will start waiting even soft full, because we
+	 * can't risk making it completely full, since vcpu0 could use
+	 * it right after us and if vcpu0 context gets full it could
+	 * deadlock if wait with mmu_lock held.
+	 */
+	if (kvm_get_running_vcpu() == NULL &&
+	    kvm_dirty_ring_soft_full(ring))
+		return -EBUSY;
+
+	/* It will never gets completely full when with a vcpu context */
+	WARN_ON_ONCE(kvm_dirty_ring_full(ring));
+
+	entry = &ring->dirty_gfns[ring->dirty_index & (ring->size - 1)];
+	entry->slot = slot;
+	entry->offset = offset;
+	smp_wmb();
+	ring->dirty_index++;
+	WRITE_ONCE(indices->avail_index, ring->dirty_index);
+
+	trace_kvm_dirty_ring_push(ring, slot, offset);
+
+	return 0;
+}
+
+struct page *kvm_dirty_ring_get_page(struct kvm_dirty_ring *ring, u32 offset)
+{
+	return vmalloc_to_page((void *)ring->dirty_gfns + offset * PAGE_SIZE);
+}
+
+void kvm_dirty_ring_free(struct kvm_dirty_ring *ring)
+{
+	vfree(ring->dirty_gfns);
+	ring->dirty_gfns = NULL;
+}
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 5c606d158854..4050631d05f3 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -64,6 +64,8 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/kvm.h>
 
+#include <linux/kvm_dirty_ring.h>
+
 /* Worst case buffer size needed for holding an integer. */
 #define ITOA_MAX_LEN 12
 
@@ -148,6 +150,9 @@ static void kvm_io_bus_destroy(struct kvm_io_bus *bus);
 static void mark_page_dirty_in_slot(struct kvm *kvm,
 				    struct kvm_memory_slot *memslot,
 				    gfn_t gfn);
+static void mark_page_dirty_in_ring(struct kvm *kvm,
+				    struct kvm_memory_slot *slot,
+				    gfn_t gfn);
 
 __visible bool kvm_rebooting;
 EXPORT_SYMBOL_GPL(kvm_rebooting);
@@ -357,11 +362,22 @@ int kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
 	vcpu->preempted = false;
 	vcpu->ready = false;
 
+	if (kvm->dirty_ring_size) {
+		r = kvm_dirty_ring_alloc(&vcpu->dirty_ring,
+					 &vcpu->run->vcpu_ring_indices,
+					 id, kvm->dirty_ring_size);
+		if (r)
+			goto fail_free_run;
+	}
+
 	r = kvm_arch_vcpu_init(vcpu);
 	if (r < 0)
-		goto fail_free_run;
+		goto fail_free_ring;
 	return 0;
 
+fail_free_ring:
+	if (kvm->dirty_ring_size)
+		kvm_dirty_ring_free(&vcpu->dirty_ring);
 fail_free_run:
 	free_page((unsigned long)vcpu->run);
 fail:
@@ -379,6 +395,8 @@ void kvm_vcpu_uninit(struct kvm_vcpu *vcpu)
 	put_pid(rcu_dereference_protected(vcpu->pid, 1));
 	kvm_arch_vcpu_uninit(vcpu);
 	free_page((unsigned long)vcpu->run);
+	if (vcpu->kvm->dirty_ring_size)
+		kvm_dirty_ring_free(&vcpu->dirty_ring);
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_uninit);
 
@@ -693,6 +711,7 @@ static struct kvm *kvm_create_vm(unsigned long type)
 		return ERR_PTR(-ENOMEM);
 
 	spin_lock_init(&kvm->mmu_lock);
+	spin_lock_init(&kvm->dirty_ring_lock);
 	mmgrab(current->mm);
 	kvm->mm = current->mm;
 	kvm_eventfd_init(kvm);
@@ -700,6 +719,7 @@ static struct kvm *kvm_create_vm(unsigned long type)
 	mutex_init(&kvm->irq_lock);
 	mutex_init(&kvm->slots_lock);
 	INIT_LIST_HEAD(&kvm->devices);
+	init_waitqueue_head(&kvm->dirty_ring_waitqueue);
 
 	BUILD_BUG_ON(KVM_MEM_SLOTS_NUM > SHRT_MAX);
 
@@ -2283,7 +2303,10 @@ static void mark_page_dirty_in_slot(struct kvm *kvm,
 	if (memslot && memslot->dirty_bitmap) {
 		unsigned long rel_gfn = gfn - memslot->base_gfn;
 
-		set_bit_le(rel_gfn, memslot->dirty_bitmap);
+		if (kvm->dirty_ring_size)
+			mark_page_dirty_in_ring(kvm, memslot, gfn);
+		else
+			set_bit_le(rel_gfn, memslot->dirty_bitmap);
 	}
 }
 
@@ -2630,6 +2653,16 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me, bool yield_to_kernel_mode)
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_on_spin);
 
+static bool kvm_fault_in_dirty_ring(struct kvm *kvm, struct vm_fault *vmf)
+{
+	if (!KVM_DIRTY_LOG_PAGE_OFFSET)
+		return false;
+
+	return (vmf->pgoff >= KVM_DIRTY_LOG_PAGE_OFFSET) &&
+	    (vmf->pgoff < KVM_DIRTY_LOG_PAGE_OFFSET +
+	     kvm->dirty_ring_size / PAGE_SIZE);
+}
+
 static vm_fault_t kvm_vcpu_fault(struct vm_fault *vmf)
 {
 	struct kvm_vcpu *vcpu = vmf->vma->vm_file->private_data;
@@ -2645,6 +2678,10 @@ static vm_fault_t kvm_vcpu_fault(struct vm_fault *vmf)
 	else if (vmf->pgoff == KVM_COALESCED_MMIO_PAGE_OFFSET)
 		page = virt_to_page(vcpu->kvm->coalesced_mmio_ring);
 #endif
+	else if (kvm_fault_in_dirty_ring(vcpu->kvm, vmf))
+		page = kvm_dirty_ring_get_page(
+		    &vcpu->dirty_ring,
+		    vmf->pgoff - KVM_DIRTY_LOG_PAGE_OFFSET);
 	else
 		return kvm_arch_vcpu_fault(vcpu, vmf);
 	get_page(page);
@@ -3239,12 +3276,138 @@ static long kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
 #endif
 	case KVM_CAP_NR_MEMSLOTS:
 		return KVM_USER_MEM_SLOTS;
+	case KVM_CAP_DIRTY_LOG_RING:
+#ifdef CONFIG_X86
+		return KVM_DIRTY_RING_MAX_ENTRIES;
+#else
+		return 0;
+#endif
 	default:
 		break;
 	}
 	return kvm_vm_ioctl_check_extension(kvm, arg);
 }
 
+static void mark_page_dirty_in_ring(struct kvm *kvm,
+				    struct kvm_memory_slot *slot,
+				    gfn_t gfn)
+{
+	struct kvm_dirty_ring *ring;
+	u64 offset;
+	int ret;
+
+	if (!kvm->dirty_ring_size)
+		return;
+
+	offset = gfn - slot->base_gfn;
+
+	ring = kvm_dirty_ring_get(kvm);
+
+retry:
+	ret = kvm_dirty_ring_push(ring, (slot->as_id << 16) | slot->id,
+				  offset);
+	if (ret < 0) {
+		/* We must be without a vcpu context. */
+		WARN_ON_ONCE(kvm_get_running_vcpu());
+
+		trace_kvm_dirty_ring_waitqueue(1);
+		/*
+		 * Ring is full, put us onto per-vm waitqueue and wait
+		 * for another KVM_RESET_DIRTY_RINGS to retry
+		 */
+		wait_event_killable(kvm->dirty_ring_waitqueue,
+				    !kvm_dirty_ring_soft_full(ring));
+
+		trace_kvm_dirty_ring_waitqueue(0);
+
+		/* If we're killed, no worry on lossing dirty bits */
+		if (fatal_signal_pending(current))
+			return;
+
+		goto retry;
+	}
+
+	kvm_dirty_ring_put(kvm, ring);
+}
+
+void kvm_reset_dirty_gfn(struct kvm *kvm, u32 slot, u64 offset, u64 mask)
+{
+	struct kvm_memory_slot *memslot;
+	int as_id, id;
+
+	as_id = slot >> 16;
+	id = (u16)slot;
+	if (as_id >= KVM_ADDRESS_SPACE_NUM || id >= KVM_USER_MEM_SLOTS)
+		return;
+
+	memslot = id_to_memslot(__kvm_memslots(kvm, as_id), id);
+	if (offset >= memslot->npages)
+		return;
+
+	spin_lock(&kvm->mmu_lock);
+	kvm_arch_mmu_enable_log_dirty_pt_masked(kvm, memslot, offset, mask);
+	spin_unlock(&kvm->mmu_lock);
+}
+
+static int kvm_vm_ioctl_enable_dirty_log_ring(struct kvm *kvm, u32 size)
+{
+	int r;
+
+	/* the size should be power of 2 */
+	if (!size || (size & (size - 1)))
+		return -EINVAL;
+
+	/* Should be bigger to keep the reserved entries, or a page */
+	if (size < kvm_dirty_ring_get_rsvd_entries() *
+	    sizeof(struct kvm_dirty_gfn) || size < PAGE_SIZE)
+		return -EINVAL;
+
+	if (size > KVM_DIRTY_RING_MAX_ENTRIES *
+	    sizeof(struct kvm_dirty_gfn))
+		return -E2BIG;
+
+	/* We only allow it to set once */
+	if (kvm->dirty_ring_size)
+		return -EINVAL;
+
+	mutex_lock(&kvm->lock);
+
+	if (kvm->created_vcpus) {
+		/* We don't allow to change this value after vcpu created */
+		r = -EINVAL;
+	} else {
+		kvm->dirty_ring_size = size;
+		r = 0;
+	}
+
+	mutex_unlock(&kvm->lock);
+	return r;
+}
+
+static int kvm_vm_ioctl_reset_dirty_pages(struct kvm *kvm)
+{
+	int i;
+	struct kvm_vcpu *vcpu;
+	int cleared = 0;
+
+	if (!kvm->dirty_ring_size)
+		return -EINVAL;
+
+	mutex_lock(&kvm->slots_lock);
+
+	kvm_for_each_vcpu(i, vcpu, kvm)
+		cleared += kvm_dirty_ring_reset(vcpu->kvm, &vcpu->dirty_ring);
+
+	mutex_unlock(&kvm->slots_lock);
+
+	if (cleared)
+		kvm_flush_remote_tlbs(kvm);
+
+	wake_up_all(&kvm->dirty_ring_waitqueue);
+
+	return cleared;
+}
+
 int __attribute__((weak)) kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 						  struct kvm_enable_cap *cap)
 {
@@ -3262,6 +3425,8 @@ static int kvm_vm_ioctl_enable_cap_generic(struct kvm *kvm,
 		kvm->manual_dirty_log_protect = cap->args[0];
 		return 0;
 #endif
+	case KVM_CAP_DIRTY_LOG_RING:
+		return kvm_vm_ioctl_enable_dirty_log_ring(kvm, cap->args[0]);
 	default:
 		return kvm_vm_ioctl_enable_cap(kvm, cap);
 	}
@@ -3449,6 +3614,9 @@ static long kvm_vm_ioctl(struct file *filp,
 	case KVM_CHECK_EXTENSION:
 		r = kvm_vm_ioctl_check_extension_generic(kvm, arg);
 		break;
+	case KVM_RESET_DIRTY_RINGS:
+		r = kvm_vm_ioctl_reset_dirty_pages(kvm);
+		break;
 	default:
 		r = kvm_arch_vm_ioctl(filp, ioctl, arg);
 	}
-- 
2.24.1

