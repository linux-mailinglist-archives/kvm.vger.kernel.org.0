Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A59317EB72
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2020 22:45:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727201AbgCIVox (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Mar 2020 17:44:53 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:29882 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727222AbgCIVow (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 9 Mar 2020 17:44:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583790290;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5lJClZWz8Sqr5tLIkOOMy7bv3eL+MuSJA1eFxEWDmRo=;
        b=NDOrAAz34E5Cb1v9oQsJd6ncNfRK3D8tVNEs9gtQvVHuKrOok+UDvU7ZQrKIuMEH/VUPfU
        3CSVB1jkvedm3RleoAq2igM4hmQTedNRG3IkbD9you18ihQmrtm6gyaiHt02qnfijudPDB
        N3VIwneZp8muquTdotTMtf27zimwhfU=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-376-F4_uk1PYPF2p5qsG0z8qVw-1; Mon, 09 Mar 2020 17:44:46 -0400
X-MC-Unique: F4_uk1PYPF2p5qsG0z8qVw-1
Received: by mail-qv1-f70.google.com with SMTP id j15so7640806qvp.21
        for <kvm@vger.kernel.org>; Mon, 09 Mar 2020 14:44:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5lJClZWz8Sqr5tLIkOOMy7bv3eL+MuSJA1eFxEWDmRo=;
        b=tXrv8dwK0G0SvrqlOOMNRo+ZgwF2DNQgrcm5Ye1cdBbCvS6iI1ki/DnQBfgOSGm1jr
         5/maISp98e1wcvruRtxtxgLGGpIVSHlWh9UqgnPiSyBilnJLLqVdkC6krizizzAkcc01
         0w+zNbMeoLEG5b5Jey9Plpemn6sJU6uzS84vpW9rBD8uIfzG++3Ev/F8pFmk3VqNW37Q
         LkIMKyQcx73AFchUaDTRJzrogd9WHwuuoM7ufCuR+4ZklvtDola7Mta45QXWBNA3vqOQ
         38XCNN65syaG/7hVLSmmMxTbD+hLhvMuUlFmk1xu6nRRXTfZmYfPFqHX7qp+RJnjC01Y
         jz3A==
X-Gm-Message-State: ANhLgQ1okJNlA5h9dRHDjz/eyYO6l7S28y0Oa66Dqw3weAQCVzpOrvyN
        P4IfLptgL9yWxybCPsxFsEJruSAWT80ojeOGIcRHcS/aMGgfvHiNElLNn9z2r813H5azqTbdVF6
        8Lp5w91TgQvsc
X-Received: by 2002:a37:f511:: with SMTP id l17mr16922782qkk.479.1583790285073;
        Mon, 09 Mar 2020 14:44:45 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vvmvpNGcSoYHDWXtp+5YpjAaTJVWU97mviCbuI6Gk5SJe+DD8v44ozsqxOmarcIqNN/twsJGQ==
X-Received: by 2002:a37:f511:: with SMTP id l17mr16922744qkk.479.1583790284108;
        Mon, 09 Mar 2020 14:44:44 -0700 (PDT)
Received: from xz-x1.redhat.com ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id p35sm3154098qtk.2.2020.03.09.14.44.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2020 14:44:43 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Yan Zhao <yan.y.zhao@intel.com>, Jason Wang <jasowang@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        peterx@redhat.com, Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Lei Cao <lei.cao@stratus.com>
Subject: [PATCH v6 05/14] KVM: X86: Implement ring-based dirty memory tracking
Date:   Mon,  9 Mar 2020 17:44:15 -0400
Message-Id: <20200309214424.330363-6-peterx@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200309214424.330363-1-peterx@redhat.com>
References: <20200309214424.330363-1-peterx@redhat.com>
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
 Documentation/virt/kvm/api.rst  | 116 +++++++++++++++++++
 arch/x86/include/asm/kvm_host.h |   3 +
 arch/x86/include/uapi/asm/kvm.h |   1 +
 arch/x86/kvm/Makefile           |   3 +-
 arch/x86/kvm/mmu/mmu.c          |   6 +
 arch/x86/kvm/vmx/vmx.c          |   7 ++
 arch/x86/kvm/x86.c              |   9 ++
 include/linux/kvm_dirty_ring.h  | 103 +++++++++++++++++
 include/linux/kvm_host.h        |  13 +++
 include/trace/events/kvm.h      |  78 +++++++++++++
 include/uapi/linux/kvm.h        |  53 +++++++++
 virt/kvm/dirty_ring.c           | 195 ++++++++++++++++++++++++++++++++
 virt/kvm/kvm_main.c             | 112 +++++++++++++++++-
 13 files changed, 697 insertions(+), 2 deletions(-)
 create mode 100644 include/linux/kvm_dirty_ring.h
 create mode 100644 virt/kvm/dirty_ring.c

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index ebd383fba939..bc17ca955495 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -249,6 +249,7 @@ Based on their initialization different VMs may have different capabilities.
 It is thus encouraged to use the vm ioctl to query for capabilities (available
 with KVM_CAP_CHECK_EXTENSION_VM on the vm fd)
 
+
 4.5 KVM_GET_VCPU_MMAP_SIZE
 --------------------------
 
@@ -262,6 +263,18 @@ The KVM_RUN ioctl (cf.) communicates with userspace via a shared
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
 -------------------------
@@ -6027,3 +6040,106 @@ Architectures: s390
 
 This capability indicates that the KVM_S390_NORMAL_RESET and
 KVM_S390_CLEAR_RESET ioctls are available.
+
+8.23 KVM_CAP_DIRTY_LOG_RING
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
+	int index;
+};
+
+Dirty GFNs (Guest Frame Numbers) are stored in the dirty_gfns array.
+For each of the dirty entry it's defined as:
+
+struct kvm_dirty_gfn {
+        __u32 flags;
+        __u32 slot; /* as_id | slot_id */
+        __u64 offset;
+};
+
+Each GFN is a state machine itself.  The state is embeded in the flags
+field, as defined in the uapi header:
+
+/*
+ * KVM dirty GFN flags, defined as:
+ *
+ * |---------------+---------------+--------------|
+ * | bit 1 (reset) | bit 0 (dirty) | Status       |
+ * |---------------+---------------+--------------|
+ * |             0 |             0 | Invalid GFN  |
+ * |             0 |             1 | Dirty GFN    |
+ * |             1 |             X | GFN to reset |
+ * |---------------+---------------+--------------|
+ *
+ * Lifecycle of a dirty GFN goes like:
+ *
+ *      dirtied         collected        reset
+ * 00 -----------> 01 -------------> 1X -------+
+ *  ^                                          |
+ *  |                                          |
+ *  +------------------------------------------+
+ *
+ * The userspace program is only responsible for the 01->1X state
+ * conversion (to collect dirty bits).  Also, it must not skip any
+ * dirty bits so that dirty bits are always collected in sequence.
+ */
+#define KVM_DIRTY_GFN_F_DIRTY           BIT(0)
+#define KVM_DIRTY_GFN_F_RESET           BIT(1)
+#define KVM_DIRTY_GFN_F_MASK            0x3
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
+to read the dirty GFNs starting from zero.  If the flags has the DIRTY
+bit set (at this stage the RESET bit must be cleared), then it means
+this GFN is a dirty GFN.  The userspace should collect this GFN and
+mark the flags from state 01b to 1Xb (bit 0 will be ignored by KVM,
+but bit 1 must be set to show that this GFN is collected and waiting
+for a reset), and move on to the next GFN.  The userspace should
+continue to do this until when the flags of a GFN has the DIRTY bit
+cleared, it means we've collected all the dirty GFNs we have for now.
+It's not a must that the userspace collects the all dirty GFNs in
+once.  However it must collect the dirty GFNs in sequence, i.e., the
+userspace program cannot skip one dirty GFN to collect the one next to
+it.
+
+After processing one or more entries in the ring buffer, userspace
+calls the VM ioctl KVM_RESET_DIRTY_RINGS to notify the kernel about
+it, so that the kernel will reprotect those collected GFNs.
+Therefore, the ioctl must be called *before* reading the content of
+the dirty pages.
+
+The dirty ring interface has a major difference comparing to the
+KVM_GET_DIRTY_LOG interface in that, when reading the dirty ring from
+userspace it's still possible that the kernel has not yet flushed the
+hardware dirty buffers into the kernel buffer (the flushing was
+previously done by the KVM_GET_DIRTY_LOG ioctl).  To achieve that, one
+needs to kick the vcpu out for a hardware buffer flush (vmexit) to
+make sure all the existing dirty gfns are flushed to the dirty rings.
+
+The dirty ring can gets full.  When it happens, the KVM_RUN of the
+vcpu will return with exit reason KVM_EXIT_DIRTY_LOG_FULL.
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index ae7641b6a473..8495193c962c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1210,6 +1210,7 @@ struct kvm_x86_ops {
 					   struct kvm_memory_slot *slot,
 					   gfn_t offset, unsigned long mask);
 	int (*write_log_dirty)(struct kvm_vcpu *vcpu);
+	int (*cpu_dirty_log_size)(void);
 
 	/* pmu operations of sub-arch */
 	const struct kvm_pmu_ops *pmu_ops;
@@ -1699,4 +1700,6 @@ static inline int kvm_cpu_get_apicid(int mps_cpu)
 #define GET_SMSTATE(type, buf, offset)		\
 	(*(type *)((buf) + (offset) - 0x7e00))
 
+int kvm_cpu_dirty_log_size(void);
+
 #endif /* _ASM_X86_KVM_HOST_H */
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 3f3f780c8c65..99b15ce39e75 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -12,6 +12,7 @@
 
 #define KVM_PIO_PAGE_OFFSET 1
 #define KVM_COALESCED_MMIO_PAGE_OFFSET 2
+#define KVM_DIRTY_LOG_PAGE_OFFSET 64
 
 #define DE_VECTOR 0
 #define DB_VECTOR 1
diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index e553f0fdd87d..8e12a6fe1524 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -6,7 +6,8 @@ ccflags-$(CONFIG_KVM_WERROR) += -Werror
 KVM := ../../../virt/kvm
 
 kvm-y			+= $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o \
-				$(KVM)/eventfd.o $(KVM)/irqchip.o $(KVM)/vfio.o
+				$(KVM)/eventfd.o $(KVM)/irqchip.o $(KVM)/vfio.o \
+				$(KVM)/dirty_ring.o
 kvm-$(CONFIG_KVM_ASYNC_PF)	+= $(KVM)/async_pf.o
 
 kvm-y			+= x86.o emulate.o i8259.o irq.o lapic.o \
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 87e9ba27ada1..0147f20f31f9 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1757,7 +1757,13 @@ int kvm_arch_write_log_dirty(struct kvm_vcpu *vcpu)
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
index fc638a164e03..1564139d48d5 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7765,6 +7765,7 @@ static __init int hardware_setup(void)
 		kvm_x86_ops->slot_disable_log_dirty = NULL;
 		kvm_x86_ops->flush_log_dirty = NULL;
 		kvm_x86_ops->enable_log_dirty_pt_masked = NULL;
+		kvm_x86_ops->cpu_dirty_log_size = NULL;
 	}
 
 	if (!cpu_has_vmx_preemption_timer())
@@ -7837,6 +7838,11 @@ static bool vmx_check_apicv_inhibit_reasons(ulong bit)
 	return supported & BIT(bit);
 }
 
+static int vmx_cpu_dirty_log_size(void)
+{
+	return enable_pml ? PML_ENTITY_NUM : 0;
+}
+
 static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
 	.cpu_has_kvm_support = cpu_has_kvm_support,
 	.disabled_by_bios = vmx_disabled_by_bios,
@@ -7961,6 +7967,7 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
 	.flush_log_dirty = vmx_flush_log_dirty,
 	.enable_log_dirty_pt_masked = vmx_enable_log_dirty_pt_masked,
 	.write_log_dirty = vmx_write_pml_buffer,
+	.cpu_dirty_log_size = vmx_cpu_dirty_log_size,
 
 	.pre_block = vmx_pre_block,
 	.post_block = vmx_post_block,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fe485d4ba6c7..f3cad54458dc 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8154,6 +8154,15 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 
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
index 000000000000..120e5e90fa1d
--- /dev/null
+++ b/include/linux/kvm_dirty_ring.h
@@ -0,0 +1,103 @@
+#ifndef KVM_DIRTY_RING_H
+#define KVM_DIRTY_RING_H
+
+#include <linux/kvm.h>
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
+ * @index:       index of this dirty ring
+ */
+struct kvm_dirty_ring {
+	u32 dirty_index;
+	u32 reset_index;
+	u32 size;
+	u32 soft_limit;
+	struct kvm_dirty_gfn *dirty_gfns;
+	int index;
+};
+
+#if (KVM_DIRTY_LOG_PAGE_OFFSET == 0)
+/*
+ * If KVM_DIRTY_LOG_PAGE_OFFSET not defined, kvm_dirty_ring.o should
+ * not be included as well, so define these nop functions for the arch.
+ */
+static inline u32 kvm_dirty_ring_get_rsvd_entries(void)
+{
+	return 0;
+}
+
+static inline int kvm_dirty_ring_alloc(struct kvm_dirty_ring *ring,
+				       int index, u32 size)
+{
+	return 0;
+}
+
+static inline struct kvm_dirty_ring *kvm_dirty_ring_get(struct kvm *kvm)
+{
+	return NULL;
+}
+
+static inline int kvm_dirty_ring_reset(struct kvm *kvm,
+				       struct kvm_dirty_ring *ring)
+{
+	return 0;
+}
+
+static inline void kvm_dirty_ring_push(struct kvm_dirty_ring *ring,
+				       u32 slot, u64 offset)
+{
+}
+
+static inline struct page *kvm_dirty_ring_get_page(struct kvm_dirty_ring *ring,
+						   u32 offset)
+{
+	return NULL;
+}
+
+static inline void kvm_dirty_ring_free(struct kvm_dirty_ring *ring)
+{
+}
+
+static inline bool kvm_dirty_ring_soft_full(struct kvm_dirty_ring *ring)
+{
+	return true;
+}
+
+#else /* KVM_DIRTY_LOG_PAGE_OFFSET == 0 */
+
+u32 kvm_dirty_ring_get_rsvd_entries(void);
+int kvm_dirty_ring_alloc(struct kvm_dirty_ring *ring, int index, u32 size);
+struct kvm_dirty_ring *kvm_dirty_ring_get(struct kvm *kvm);
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
+void kvm_dirty_ring_push(struct kvm_dirty_ring *ring, u32 slot, u64 offset);
+
+/* for use in vm_operations_struct */
+struct page *kvm_dirty_ring_get_page(struct kvm_dirty_ring *ring, u32 offset);
+
+void kvm_dirty_ring_free(struct kvm_dirty_ring *ring);
+bool kvm_dirty_ring_soft_full(struct kvm_dirty_ring *ring);
+
+#endif /* KVM_DIRTY_LOG_PAGE_OFFSET == 0 */
+
+#endif	/* KVM_DIRTY_RING_H */
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index afa0e9034881..f0993dec3b77 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -34,6 +34,7 @@
 #include <linux/kvm_types.h>
 
 #include <asm/kvm_host.h>
+#include <linux/kvm_dirty_ring.h>
 
 #ifndef KVM_MAX_VCPU_ID
 #define KVM_MAX_VCPU_ID KVM_MAX_VCPUS
@@ -319,6 +320,7 @@ struct kvm_vcpu {
 	bool ready;
 	struct kvm_vcpu_arch arch;
 	struct dentry *debugfs_dentry;
+	struct kvm_dirty_ring dirty_ring;
 };
 
 static inline int kvm_vcpu_exiting_guest_mode(struct kvm_vcpu *vcpu)
@@ -500,6 +502,7 @@ struct kvm {
 	struct srcu_struct srcu;
 	struct srcu_struct irq_srcu;
 	pid_t userspace_pid;
+	u32 dirty_ring_size;
 };
 
 #define kvm_err(fmt, ...) \
@@ -1413,4 +1416,14 @@ int kvm_vm_create_worker_thread(struct kvm *kvm, kvm_vm_thread_fn_t thread_fn,
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
index 4b95f9a31a2f..cdd19f50c0af 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -236,6 +236,7 @@ struct kvm_hyperv_exit {
 #define KVM_EXIT_IOAPIC_EOI       26
 #define KVM_EXIT_HYPERV           27
 #define KVM_EXIT_ARM_NISV         28
+#define KVM_EXIT_DIRTY_RING_FULL  29
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -1010,6 +1011,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_ARM_NISV_TO_USER 177
 #define KVM_CAP_ARM_INJECT_EXT_DABT 178
 #define KVM_CAP_S390_VCPU_RESETS 179
+#define KVM_CAP_DIRTY_LOG_RING 180
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -1478,6 +1480,9 @@ struct kvm_enc_region {
 #define KVM_S390_NORMAL_RESET	_IO(KVMIO,   0xc3)
 #define KVM_S390_CLEAR_RESET	_IO(KVMIO,   0xc4)
 
+/* Available with KVM_CAP_DIRTY_LOG_RING */
+#define KVM_RESET_DIRTY_RINGS     _IO(KVMIO, 0xc5)
+
 /* Secure Encrypted Virtualization command */
 enum sev_cmd_id {
 	/* Guest initialization commands */
@@ -1628,4 +1633,52 @@ struct kvm_hyperv_eventfd {
 #define KVM_HYPERV_CONN_ID_MASK		0x00ffffff
 #define KVM_HYPERV_EVENTFD_DEASSIGN	(1 << 0)
 
+/*
+ * Arch needs to define the macro after implementing the dirty ring
+ * feature.  KVM_DIRTY_LOG_PAGE_OFFSET should be defined as the
+ * starting page offset of the dirty ring structures.
+ */
+#ifndef KVM_DIRTY_LOG_PAGE_OFFSET
+#define KVM_DIRTY_LOG_PAGE_OFFSET 0
+#endif
+
+/*
+ * KVM dirty GFN flags, defined as:
+ *
+ * |---------------+---------------+--------------|
+ * | bit 1 (reset) | bit 0 (dirty) | Status       |
+ * |---------------+---------------+--------------|
+ * |             0 |             0 | Invalid GFN  |
+ * |             0 |             1 | Dirty GFN    |
+ * |             1 |             X | GFN to reset |
+ * |---------------+---------------+--------------|
+ *
+ * Lifecycle of a dirty GFN goes like:
+ *
+ *      dirtied         collected        reset
+ * 00 -----------> 01 -------------> 1X -------+
+ *  ^                                          |
+ *  |                                          |
+ *  +------------------------------------------+
+ *
+ * The userspace program is only responsible for the 01->1X state
+ * conversion (to collect dirty bits).  Also, it must not skip any
+ * dirty bits so that dirty bits are always collected in sequence.
+ */
+#define KVM_DIRTY_GFN_F_DIRTY           BIT(0)
+#define KVM_DIRTY_GFN_F_RESET           BIT(1)
+#define KVM_DIRTY_GFN_F_MASK            0x3
+
+/*
+ * KVM dirty rings should be mapped at KVM_DIRTY_LOG_PAGE_OFFSET of
+ * per-vcpu mmaped regions as an array of struct kvm_dirty_gfn.  The
+ * size of the gfn buffer is decided by the first argument when
+ * enabling KVM_CAP_DIRTY_LOG_RING.
+ */
+struct kvm_dirty_gfn {
+	__u32 flags;
+	__u32 slot;
+	__u64 offset;
+};
+
 #endif /* __LINUX_KVM_H */
diff --git a/virt/kvm/dirty_ring.c b/virt/kvm/dirty_ring.c
new file mode 100644
index 000000000000..12d09802b8a7
--- /dev/null
+++ b/virt/kvm/dirty_ring.c
@@ -0,0 +1,195 @@
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
+	WARN_ON_ONCE(vcpu->kvm != kvm);
+
+	return &vcpu->dirty_ring;
+}
+
+static void kvm_reset_dirty_gfn(struct kvm *kvm, u32 slot, u64 offset, u64 mask)
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
+int kvm_dirty_ring_alloc(struct kvm_dirty_ring *ring, int index, u32 size)
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
+
+	return 0;
+}
+
+static inline void kvm_dirty_gfn_set_invalid(struct kvm_dirty_gfn *gfn)
+{
+	gfn->flags = 0;
+}
+
+static inline void kvm_dirty_gfn_set_dirtied(struct kvm_dirty_gfn *gfn)
+{
+	gfn->flags = KVM_DIRTY_GFN_F_DIRTY;
+}
+
+static inline bool kvm_dirty_gfn_invalid(struct kvm_dirty_gfn *gfn)
+{
+	return gfn->flags == 0;
+}
+
+static inline bool kvm_dirty_gfn_collected(struct kvm_dirty_gfn *gfn)
+{
+	return gfn->flags & KVM_DIRTY_GFN_F_RESET;
+}
+
+int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring)
+{
+	u32 cur_slot, next_slot;
+	u64 cur_offset, next_offset;
+	unsigned long mask;
+	int count = 0;
+	struct kvm_dirty_gfn *entry;
+	bool first_round = true;
+
+	/* This is only needed to make compilers happy */
+	cur_slot = cur_offset = mask = 0;
+
+	while (true) {
+		entry = &ring->dirty_gfns[ring->reset_index & (ring->size - 1)];
+
+		if (!kvm_dirty_gfn_collected(entry))
+			break;
+
+		next_slot = READ_ONCE(entry->slot);
+		next_offset = READ_ONCE(entry->offset);
+
+		/* Update the flags to reflect that this GFN is reset */
+		kvm_dirty_gfn_set_invalid(entry);
+
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
+
+	kvm_reset_dirty_gfn(kvm, cur_slot, cur_offset, mask);
+
+	trace_kvm_dirty_ring_reset(ring);
+
+	return count;
+}
+
+void kvm_dirty_ring_push(struct kvm_dirty_ring *ring, u32 slot, u64 offset)
+{
+	struct kvm_dirty_gfn *entry;
+
+	/* It should never get full */
+	WARN_ON_ONCE(kvm_dirty_ring_full(ring));
+
+	entry = &ring->dirty_gfns[ring->dirty_index & (ring->size - 1)];
+
+	/* It should always be an invalid entry to fill in */
+	WARN_ON_ONCE(!kvm_dirty_gfn_invalid(entry));
+
+	entry->slot = slot;
+	entry->offset = offset;
+	/*
+	 * Make sure the data is filled in before we publish this to
+	 * the userspace program.  There's no paired kernel-side reader.
+	 */
+	smp_wmb();
+	kvm_dirty_gfn_set_dirtied(entry);
+	ring->dirty_index++;
+	trace_kvm_dirty_ring_push(ring, slot, offset);
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
index 7280417d82f0..2112958c7500 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -64,6 +64,8 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/kvm.h>
 
+#include <linux/kvm_dirty_ring.h>
+
 /* Worst case buffer size needed for holding an integer. */
 #define ITOA_MAX_LEN 12
 
@@ -360,6 +362,7 @@ static void kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
 
 void kvm_vcpu_destroy(struct kvm_vcpu *vcpu)
 {
+	kvm_dirty_ring_free(&vcpu->dirty_ring);
 	kvm_arch_vcpu_destroy(vcpu);
 
 	/*
@@ -2363,8 +2366,13 @@ static void mark_page_dirty_in_slot(struct kvm *kvm,
 {
 	if (memslot && memslot->dirty_bitmap) {
 		unsigned long rel_gfn = gfn - memslot->base_gfn;
+		u32 slot = (memslot->as_id << 16) | memslot->id;
 
-		set_bit_le(rel_gfn, memslot->dirty_bitmap);
+		if (kvm->dirty_ring_size)
+			kvm_dirty_ring_push(kvm_dirty_ring_get(kvm),
+					    slot, rel_gfn);
+		else
+			set_bit_le(rel_gfn, memslot->dirty_bitmap);
 	}
 }
 
@@ -2711,6 +2719,16 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me, bool yield_to_kernel_mode)
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_on_spin);
 
+static bool kvm_page_in_dirty_ring(struct kvm *kvm, unsigned long pgoff)
+{
+	if (!KVM_DIRTY_LOG_PAGE_OFFSET)
+		return false;
+
+	return (pgoff >= KVM_DIRTY_LOG_PAGE_OFFSET) &&
+	    (pgoff < KVM_DIRTY_LOG_PAGE_OFFSET +
+	     kvm->dirty_ring_size / PAGE_SIZE);
+}
+
 static vm_fault_t kvm_vcpu_fault(struct vm_fault *vmf)
 {
 	struct kvm_vcpu *vcpu = vmf->vma->vm_file->private_data;
@@ -2726,6 +2744,10 @@ static vm_fault_t kvm_vcpu_fault(struct vm_fault *vmf)
 	else if (vmf->pgoff == KVM_COALESCED_MMIO_PAGE_OFFSET)
 		page = virt_to_page(vcpu->kvm->coalesced_mmio_ring);
 #endif
+	else if (kvm_page_in_dirty_ring(vcpu->kvm, vmf->pgoff))
+		page = kvm_dirty_ring_get_page(
+		    &vcpu->dirty_ring,
+		    vmf->pgoff - KVM_DIRTY_LOG_PAGE_OFFSET);
 	else
 		return kvm_arch_vcpu_fault(vcpu, vmf);
 	get_page(page);
@@ -2739,6 +2761,14 @@ static const struct vm_operations_struct kvm_vcpu_vm_ops = {
 
 static int kvm_vcpu_mmap(struct file *file, struct vm_area_struct *vma)
 {
+	struct kvm_vcpu *vcpu = file->private_data;
+	unsigned long pages = (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
+
+	if ((kvm_page_in_dirty_ring(vcpu->kvm, vma->vm_pgoff) ||
+	     kvm_page_in_dirty_ring(vcpu->kvm, vma->vm_pgoff + pages - 1)) &&
+	    ((vma->vm_flags & VM_EXEC) || !(vma->vm_flags & VM_SHARED)))
+		return -EINVAL;
+
 	vma->vm_ops = &kvm_vcpu_vm_ops;
 	return 0;
 }
@@ -2832,6 +2862,13 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
 	if (r)
 		goto vcpu_free_run_page;
 
+	if (kvm->dirty_ring_size) {
+		r = kvm_dirty_ring_alloc(&vcpu->dirty_ring,
+					 id, kvm->dirty_ring_size);
+		if (r)
+			goto arch_vcpu_destroy;
+	}
+
 	kvm_create_vcpu_debugfs(vcpu);
 
 	mutex_lock(&kvm->lock);
@@ -2867,6 +2904,8 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
 unlock_vcpu_destroy:
 	mutex_unlock(&kvm->lock);
 	debugfs_remove_recursive(vcpu->debugfs_dentry);
+	kvm_dirty_ring_free(&vcpu->dirty_ring);
+arch_vcpu_destroy:
 	kvm_arch_vcpu_destroy(vcpu);
 vcpu_free_run_page:
 	free_page((unsigned long)vcpu->run);
@@ -3337,12 +3376,78 @@ static long kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
 #endif
 	case KVM_CAP_NR_MEMSLOTS:
 		return KVM_USER_MEM_SLOTS;
+	case KVM_CAP_DIRTY_LOG_RING:
+#ifdef CONFIG_X86
+		return KVM_DIRTY_RING_MAX_ENTRIES * sizeof(struct kvm_dirty_gfn);
+#else
+		return 0;
+#endif
 	default:
 		break;
 	}
 	return kvm_vm_ioctl_check_extension(kvm, arg);
 }
 
+static int kvm_vm_ioctl_enable_dirty_log_ring(struct kvm *kvm, u32 size)
+{
+	int r;
+
+	if (!KVM_DIRTY_LOG_PAGE_OFFSET)
+		return -EINVAL;
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
+	return cleared;
+}
+
 int __attribute__((weak)) kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 						  struct kvm_enable_cap *cap)
 {
@@ -3360,6 +3465,8 @@ static int kvm_vm_ioctl_enable_cap_generic(struct kvm *kvm,
 		kvm->manual_dirty_log_protect = cap->args[0];
 		return 0;
 #endif
+	case KVM_CAP_DIRTY_LOG_RING:
+		return kvm_vm_ioctl_enable_dirty_log_ring(kvm, cap->args[0]);
 	default:
 		return kvm_vm_ioctl_enable_cap(kvm, cap);
 	}
@@ -3547,6 +3654,9 @@ static long kvm_vm_ioctl(struct file *filp,
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

