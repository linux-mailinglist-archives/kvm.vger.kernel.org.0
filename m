Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE60310DB17
	for <lists+kvm@lfdr.de>; Fri, 29 Nov 2019 22:36:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727230AbfK2VgO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Nov 2019 16:36:14 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:50141 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727389AbfK2VfV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 29 Nov 2019 16:35:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575063318;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3cJNu0RAsiOhVZkNahn81e7bhUG0FnlgGkjFlwJhcSY=;
        b=RqyDOSObd+Vcqc8tZac678W6tWHaWsLql+uEcEn6+DnUosXPByTZCCk31ofPLQbSL6D6O+
        /Sv0Hwk/SH8fLQLIMh4Ovu2H9i1mO8dKjHd6GklpQKr8IQtXE9iyuK/Awxk+Ghys/vdYIL
        f5fp3nuvNYp24bCPvTieHi6ddGKVGpQ=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-114-Asbvy4S1O0Ch6EUICpFNwA-1; Fri, 29 Nov 2019 16:35:15 -0500
Received: by mail-qt1-f198.google.com with SMTP id m8so17215260qta.20
        for <kvm@vger.kernel.org>; Fri, 29 Nov 2019 13:35:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DQDfGuPpN8no+p10TXG4+N6RFnZjtdtsdIKGp+Yg/4U=;
        b=tMwZePCvhEKH/IAtY+47NU24ZOl3OlD/MoGVFF13e0sOuhZ83WZnq7t4uytYNTzn6I
         BHuHQn0OjDkNNU1JtipC7ehsXiX2hLsqWm7//aOrz6Ug/HXLnh6yn+2D9mjeoyt5DUYS
         E5kFdQVBKP43lVlFMxTPM8+cB/0It1KxZQ79U1dNxJ8bbwkn1UbWoVeMagsASAvyN5iW
         kgXqAzGVb9NaqmtM3jHZaxRELuZ2zM9QmZAL0IwrQqT7js6blLh68Q6l8xh8TJizemKb
         C6pcue4w+YuS2IzKR5jd71NP0NyOPl6SZZgxytnwalWcAMigdcyuGhLy+elLxarYNcxS
         GMHg==
X-Gm-Message-State: APjAAAVU39EoEe/BZFx3FEyZOlPoeNej0dcnAYTGa0GAzJ//eYdyHzFT
        jLPQUDgtWqd0MDiZsswAVn7JUs/scqs6mTgnLdHdBJDtQnMcyqpwY2zi+BLTcI4pX36tqHySHrS
        0+/GfHl5jB2Nt
X-Received: by 2002:a37:4cd3:: with SMTP id z202mr18869864qka.212.1575063314625;
        Fri, 29 Nov 2019 13:35:14 -0800 (PST)
X-Google-Smtp-Source: APXvYqyvjkbSiupbFnonrnDc1iMCVGbOn2TGZRHzTcNUEv8C05p+XP+iHXymnDvJFDGNw6ZyXx7bGQ==
X-Received: by 2002:a37:4cd3:: with SMTP id z202mr18869792qka.212.1575063313675;
        Fri, 29 Nov 2019 13:35:13 -0800 (PST)
Received: from xz-x1.yyz.redhat.com ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id h186sm10679046qkf.64.2019.11.29.13.35.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Nov 2019 13:35:12 -0800 (PST)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>, peterx@redhat.com,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH RFC 04/15] KVM: Implement ring-based dirty memory tracking
Date:   Fri, 29 Nov 2019 16:34:54 -0500
Message-Id: <20191129213505.18472-5-peterx@redhat.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191129213505.18472-1-peterx@redhat.com>
References: <20191129213505.18472-1-peterx@redhat.com>
MIME-Version: 1.0
X-MC-Unique: Asbvy4S1O0Ch6EUICpFNwA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
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

We defined two new data structures:

  struct kvm_dirty_ring;
  struct kvm_dirty_ring_indexes;

Firstly, kvm_dirty_ring is defined to represent a ring of dirty
pages.  When dirty tracking is enabled, we can push dirty gfn onto the
ring.

Secondly, kvm_dirty_ring_indexes is defined to represent the
user/kernel interface of each ring.  Currently it contains two
indexes: (1) avail_index represents where we should push our next
PFN (written by kernel), while (2) fetch_index represents where the
userspace should fetch the next dirty PFN (written by userspace).

One complete ring is composed by one kvm_dirty_ring plus its
corresponding kvm_dirty_ring_indexes.

Currently, we have N+1 rings for each VM of N vcpus:

  - for each vcpu, we have 1 per-vcpu dirty ring,
  - for each vm, we have 1 per-vm dirty ring

Please refer to the documentation update in this patch for more
details.

Note that this patch implements the core logic of dirty ring buffer.
It's still disabled for all archs for now.  Also, we'll address some
of the other issues in follow up patches before it's firstly enabled
on x86.

[1] https://patchwork.kernel.org/patch/10471409/

Signed-off-by: Lei Cao <lei.cao@stratus.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Peter Xu <peterx@redhat.com>
---
 Documentation/virt/kvm/api.txt | 109 +++++++++++++++
 arch/x86/kvm/Makefile          |   3 +-
 include/linux/kvm_dirty_ring.h |  67 +++++++++
 include/linux/kvm_host.h       |  33 +++++
 include/linux/kvm_types.h      |   1 +
 include/uapi/linux/kvm.h       |  36 +++++
 virt/kvm/dirty_ring.c          | 156 +++++++++++++++++++++
 virt/kvm/kvm_main.c            | 240 ++++++++++++++++++++++++++++++++-
 8 files changed, 642 insertions(+), 3 deletions(-)
 create mode 100644 include/linux/kvm_dirty_ring.h
 create mode 100644 virt/kvm/dirty_ring.c

diff --git a/Documentation/virt/kvm/api.txt b/Documentation/virt/kvm/api.tx=
t
index 49183add44e7..fa622c9a2eb8 100644
--- a/Documentation/virt/kvm/api.txt
+++ b/Documentation/virt/kvm/api.txt
@@ -231,6 +231,7 @@ Based on their initialization different VMs may have di=
fferent capabilities.
 It is thus encouraged to use the vm ioctl to query for capabilities (avail=
able
 with KVM_CAP_CHECK_EXTENSION_VM on the vm fd)
=20
+
 4.5 KVM_GET_VCPU_MMAP_SIZE
=20
 Capability: basic
@@ -243,6 +244,18 @@ The KVM_RUN ioctl (cf.) communicates with userspace vi=
a a shared
 memory region.  This ioctl returns the size of that region.  See the
 KVM_RUN documentation for details.
=20
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
=20
 4.6 KVM_SET_MEMORY_REGION
=20
@@ -5358,6 +5371,7 @@ CPU when the exception is taken. If this virtual SErr=
or is taken to EL1 using
 AArch64, this value will be reported in the ISS field of ESR_ELx.
=20
 See KVM_CAP_VCPU_EVENTS for more details.
+
 8.20 KVM_CAP_HYPERV_SEND_IPI
=20
 Architectures: x86
@@ -5365,6 +5379,7 @@ Architectures: x86
 This capability indicates that KVM supports paravirtualized Hyper-V IPI se=
nd
 hypercalls:
 HvCallSendSyntheticClusterIpi, HvCallSendSyntheticClusterIpiEx.
+
 8.21 KVM_CAP_HYPERV_DIRECT_TLBFLUSH
=20
 Architecture: x86
@@ -5378,3 +5393,97 @@ handling by KVM (as some KVM hypercall may be mistak=
enly treated as TLB
 flush hypercalls by Hyper-V) so userspace should disable KVM identificatio=
n
 in CPUID and only exposes Hyper-V identification. In this case, guest
 thinks it's running on Hyper-V and only use Hyper-V hypercalls.
+
+8.22 KVM_CAP_DIRTY_LOG_RING
+
+Architectures: x86
+Parameters: args[0] - size of the dirty log ring
+
+KVM is capable of tracking dirty memory using ring buffers that are
+mmaped into userspace; there is one dirty ring per vcpu and one global
+ring per vm.
+
+One dirty ring has the following two major structures:
+
+struct kvm_dirty_ring {
+=09u16 dirty_index;
+=09u16 reset_index;
+=09u32 size;
+=09u32 soft_limit;
+=09spinlock_t lock;
+=09struct kvm_dirty_gfn *dirty_gfns;
+};
+
+struct kvm_dirty_ring_indexes {
+=09__u32 avail_index; /* set by kernel */
+=09__u32 fetch_index; /* set by userspace */
+};
+
+While for each of the dirty entry it's defined as:
+
+struct kvm_dirty_gfn {
+        __u32 pad;
+        __u32 slot; /* as_id | slot_id */
+        __u64 offset;
+};
+
+The fields in kvm_dirty_ring will be only internal to KVM itself,
+while the fields in kvm_dirty_ring_indexes will be exposed to
+userspace to be either read or written.
+
+The two indices in the ring buffer are free running counters.
+
+In pseudocode, processing the ring buffer looks like this:
+
+=09idx =3D load-acquire(&ring->fetch_index);
+=09while (idx !=3D ring->avail_index) {
+=09=09struct kvm_dirty_gfn *entry;
+=09=09entry =3D &ring->dirty_gfns[idx & (size - 1)];
+=09=09...
+
+=09=09idx++;
+=09}
+=09ring->fetch_index =3D idx;
+
+Userspace calls KVM_ENABLE_CAP ioctl right after KVM_CREATE_VM ioctl
+to enable this capability for the new guest and set the size of the
+rings.  It is only allowed before creating any vCPU, and the size of
+the ring must be a power of two.  The larger the ring buffer, the less
+likely the ring is full and the VM is forced to exit to userspace. The
+optimal size depends on the workload, but it is recommended that it be
+at least 64 KiB (4096 entries).
+
+After the capability is enabled, userspace can mmap the global ring
+buffer (kvm_dirty_gfn[], offset KVM_DIRTY_LOG_PAGE_OFFSET) and the
+indexes (kvm_dirty_ring_indexes, offset 0) from the VM file
+descriptor.  The per-vcpu dirty ring instead is mmapped when the vcpu
+is created, similar to the kvm_run struct (kvm_dirty_ring_indexes
+locates inside kvm_run, while kvm_dirty_gfn[] at offset
+KVM_DIRTY_LOG_PAGE_OFFSET).
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
+hardware dirty buffers into the kernel buffer.  To achieve that, one
+needs to kick the vcpu out for a hardware buffer flush (vmexit).
+
+If one of the ring buffers is full, the guest will exit to userspace
+with the exit reason set to KVM_EXIT_DIRTY_LOG_FULL, and the
+KVM_RUN ioctl will return -EINTR. Once that happens, userspace
+should pause all the vcpus, then harvest all the dirty pages and
+rearm the dirty traps. It can unpause the guest after that.
diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index b19ef421084d..0acee817adfb 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -5,7 +5,8 @@ ccflags-y +=3D -Iarch/x86/kvm
 KVM :=3D ../../../virt/kvm
=20
 kvm-y=09=09=09+=3D $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o \
-=09=09=09=09$(KVM)/eventfd.o $(KVM)/irqchip.o $(KVM)/vfio.o
+=09=09=09=09$(KVM)/eventfd.o $(KVM)/irqchip.o $(KVM)/vfio.o \
+=09=09=09=09$(KVM)/dirty_ring.o
 kvm-$(CONFIG_KVM_ASYNC_PF)=09+=3D $(KVM)/async_pf.o
=20
 kvm-y=09=09=09+=3D x86.o emulate.o i8259.o irq.o lapic.o \
diff --git a/include/linux/kvm_dirty_ring.h b/include/linux/kvm_dirty_ring.=
h
new file mode 100644
index 000000000000..8335635b7ff7
--- /dev/null
+++ b/include/linux/kvm_dirty_ring.h
@@ -0,0 +1,67 @@
+#ifndef KVM_DIRTY_RING_H
+#define KVM_DIRTY_RING_H
+
+/*
+ * struct kvm_dirty_ring is defined in include/uapi/linux/kvm.h.
+ *
+ * dirty_ring:  shared with userspace via mmap. It is the compact list
+ *              that holds the dirty pages.
+ * dirty_index: free running counter that points to the next slot in
+ *              dirty_ring->dirty_gfns  where a new dirty page should go.
+ * reset_index: free running counter that points to the next dirty page
+ *              in dirty_ring->dirty_gfns for which dirty trap needs to
+ *              be reenabled
+ * size:        size of the compact list, dirty_ring->dirty_gfns
+ * soft_limit:  when the number of dirty pages in the list reaches this
+ *              limit, vcpu that owns this ring should exit to userspace
+ *              to allow userspace to harvest all the dirty pages
+ * lock:        protects dirty_ring, only in use if this is the global
+ *              ring
+ *
+ * The number of dirty pages in the ring is calculated by,
+ * dirty_index - reset_index
+ *
+ * kernel increments dirty_ring->indices.avail_index after dirty index
+ * is incremented. When userspace harvests the dirty pages, it increments
+ * dirty_ring->indices.fetch_index up to dirty_ring->indices.avail_index.
+ * When kernel reenables dirty traps for the dirty pages, it increments
+ * reset_index up to dirty_ring->indices.fetch_index.
+ *
+ */
+struct kvm_dirty_ring {
+=09u32 dirty_index;
+=09u32 reset_index;
+=09u32 size;
+=09u32 soft_limit;
+=09spinlock_t lock;
+=09struct kvm_dirty_gfn *dirty_gfns;
+};
+
+u32 kvm_dirty_ring_get_rsvd_entries(void);
+int kvm_dirty_ring_alloc(struct kvm *kvm, struct kvm_dirty_ring *ring);
+
+/*
+ * called with kvm->slots_lock held, returns the number of
+ * processed pages.
+ */
+int kvm_dirty_ring_reset(struct kvm *kvm,
+=09=09=09 struct kvm_dirty_ring *ring,
+=09=09=09 struct kvm_dirty_ring_indexes *indexes);
+
+/*
+ * returns 0: successfully pushed
+ *         1: successfully pushed, soft limit reached,
+ *            vcpu should exit to userspace
+ *         -EBUSY: unable to push, dirty ring full.
+ */
+int kvm_dirty_ring_push(struct kvm_dirty_ring *ring,
+=09=09=09struct kvm_dirty_ring_indexes *indexes,
+=09=09=09u32 slot, u64 offset, bool lock);
+
+/* for use in vm_operations_struct */
+struct page *kvm_dirty_ring_get_page(struct kvm_dirty_ring *ring, u32 i);
+
+void kvm_dirty_ring_free(struct kvm_dirty_ring *ring);
+bool kvm_dirty_ring_full(struct kvm_dirty_ring *ring);
+
+#endif
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 498a39462ac1..7b747bc9ff3e 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -34,6 +34,7 @@
 #include <linux/kvm_types.h>
=20
 #include <asm/kvm_host.h>
+#include <linux/kvm_dirty_ring.h>
=20
 #ifndef KVM_MAX_VCPU_ID
 #define KVM_MAX_VCPU_ID KVM_MAX_VCPUS
@@ -146,6 +147,7 @@ static inline bool is_error_page(struct page *page)
 #define KVM_REQ_MMU_RELOAD        (1 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_W=
AKEUP)
 #define KVM_REQ_PENDING_TIMER     2
 #define KVM_REQ_UNHALT            3
+#define KVM_REQ_DIRTY_RING_FULL   4
 #define KVM_REQUEST_ARCH_BASE     8
=20
 #define KVM_ARCH_REQ_FLAGS(nr, flags) ({ \
@@ -321,6 +323,7 @@ struct kvm_vcpu {
 =09bool ready;
 =09struct kvm_vcpu_arch arch;
 =09struct dentry *debugfs_dentry;
+=09struct kvm_dirty_ring dirty_ring;
 };
=20
 static inline int kvm_vcpu_exiting_guest_mode(struct kvm_vcpu *vcpu)
@@ -501,6 +504,10 @@ struct kvm {
 =09struct srcu_struct srcu;
 =09struct srcu_struct irq_srcu;
 =09pid_t userspace_pid;
+=09/* Data structure to be exported by mmap(kvm->fd, 0) */
+=09struct kvm_vm_run *vm_run;
+=09u32 dirty_ring_size;
+=09struct kvm_dirty_ring vm_dirty_ring;
 };
=20
 #define kvm_err(fmt, ...) \
@@ -832,6 +839,8 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm=
 *kvm,
 =09=09=09=09=09gfn_t gfn_offset,
 =09=09=09=09=09unsigned long mask);
=20
+void kvm_reset_dirty_gfn(struct kvm *kvm, u32 slot, u64 offset, u64 mask);
+
 int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm,
 =09=09=09=09struct kvm_dirty_log *log);
 int kvm_vm_ioctl_clear_dirty_log(struct kvm *kvm,
@@ -1411,4 +1420,28 @@ int kvm_vm_create_worker_thread(struct kvm *kvm, kvm=
_vm_thread_fn_t thread_fn,
 =09=09=09=09uintptr_t data, const char *name,
 =09=09=09=09struct task_struct **thread_ptr);
=20
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
+ * KVM_DIRTY_RING_VERSION should be defined as >=3D1.  By default, this
+ * feature is off on all archs.
+ */
+#ifndef KVM_DIRTY_LOG_PAGE_OFFSET
+#define KVM_DIRTY_LOG_PAGE_OFFSET 0
+#endif
+#ifndef KVM_DIRTY_RING_VERSION
+#define KVM_DIRTY_RING_VERSION 0
+#endif
+
 #endif
diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
index 1c88e69db3d9..d9d03eea145a 100644
--- a/include/linux/kvm_types.h
+++ b/include/linux/kvm_types.h
@@ -11,6 +11,7 @@ struct kvm_irq_routing_table;
 struct kvm_memory_slot;
 struct kvm_one_reg;
 struct kvm_run;
+struct kvm_vm_run;
 struct kvm_userspace_memory_region;
 struct kvm_vcpu;
 struct kvm_vcpu_init;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index e6f17c8e2dba..0b88d76d6215 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -236,6 +236,7 @@ struct kvm_hyperv_exit {
 #define KVM_EXIT_IOAPIC_EOI       26
 #define KVM_EXIT_HYPERV           27
 #define KVM_EXIT_ARM_NISV         28
+#define KVM_EXIT_DIRTY_RING_FULL  29
=20
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -247,6 +248,11 @@ struct kvm_hyperv_exit {
 /* Encounter unexpected vm-exit reason */
 #define KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON=094
=20
+struct kvm_dirty_ring_indexes {
+=09__u32 avail_index; /* set by kernel */
+=09__u32 fetch_index; /* set by userspace */
+};
+
 /* for KVM_RUN, returned by mmap(vcpu_fd, offset=3D0) */
 struct kvm_run {
 =09/* in */
@@ -421,6 +427,13 @@ struct kvm_run {
 =09=09struct kvm_sync_regs regs;
 =09=09char padding[SYNC_REGS_SIZE_BYTES];
 =09} s;
+
+=09struct kvm_dirty_ring_indexes vcpu_ring_indexes;
+};
+
+/* Returned by mmap(kvm->fd, offset=3D0) */
+struct kvm_vm_run {
+=09struct kvm_dirty_ring_indexes vm_ring_indexes;
 };
=20
 /* for KVM_REGISTER_COALESCED_MMIO / KVM_UNREGISTER_COALESCED_MMIO */
@@ -1009,6 +1022,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_PPC_GUEST_DEBUG_SSTEP 176
 #define KVM_CAP_ARM_NISV_TO_USER 177
 #define KVM_CAP_ARM_INJECT_EXT_DABT 178
+#define KVM_CAP_DIRTY_LOG_RING 179
=20
 #ifdef KVM_CAP_IRQ_ROUTING
=20
@@ -1472,6 +1486,9 @@ struct kvm_enc_region {
 /* Available with KVM_CAP_ARM_SVE */
 #define KVM_ARM_VCPU_FINALIZE=09  _IOW(KVMIO,  0xc2, int)
=20
+/* Available with KVM_CAP_DIRTY_LOG_RING */
+#define KVM_RESET_DIRTY_RINGS     _IO(KVMIO, 0xc3)
+
 /* Secure Encrypted Virtualization command */
 enum sev_cmd_id {
 =09/* Guest initialization commands */
@@ -1622,4 +1639,23 @@ struct kvm_hyperv_eventfd {
 #define KVM_HYPERV_CONN_ID_MASK=09=090x00ffffff
 #define KVM_HYPERV_EVENTFD_DEASSIGN=09(1 << 0)
=20
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
+=09__u32 pad;
+=09__u32 slot;
+=09__u64 offset;
+};
+
 #endif /* __LINUX_KVM_H */
diff --git a/virt/kvm/dirty_ring.c b/virt/kvm/dirty_ring.c
new file mode 100644
index 000000000000..9264891f3c32
--- /dev/null
+++ b/virt/kvm/dirty_ring.c
@@ -0,0 +1,156 @@
+#include <linux/kvm_host.h>
+#include <linux/kvm.h>
+#include <linux/vmalloc.h>
+#include <linux/kvm_dirty_ring.h>
+
+u32 kvm_dirty_ring_get_rsvd_entries(void)
+{
+=09return KVM_DIRTY_RING_RSVD_ENTRIES + kvm_cpu_dirty_log_size();
+}
+
+int kvm_dirty_ring_alloc(struct kvm *kvm, struct kvm_dirty_ring *ring)
+{
+=09u32 size =3D kvm->dirty_ring_size;
+
+=09ring->dirty_gfns =3D vmalloc(size);
+=09if (!ring->dirty_gfns)
+=09=09return -ENOMEM;
+=09memset(ring->dirty_gfns, 0, size);
+
+=09ring->size =3D size / sizeof(struct kvm_dirty_gfn);
+=09ring->soft_limit =3D
+=09    (kvm->dirty_ring_size / sizeof(struct kvm_dirty_gfn)) -
+=09    kvm_dirty_ring_get_rsvd_entries();
+=09ring->dirty_index =3D 0;
+=09ring->reset_index =3D 0;
+=09spin_lock_init(&ring->lock);
+
+=09return 0;
+}
+
+int kvm_dirty_ring_reset(struct kvm *kvm,
+=09=09=09 struct kvm_dirty_ring *ring,
+=09=09=09 struct kvm_dirty_ring_indexes *indexes)
+{
+=09u32 cur_slot, next_slot;
+=09u64 cur_offset, next_offset;
+=09unsigned long mask;
+=09u32 fetch;
+=09int count =3D 0;
+=09struct kvm_dirty_gfn *entry;
+
+=09fetch =3D READ_ONCE(indexes->fetch_index);
+=09if (fetch =3D=3D ring->reset_index)
+=09=09return 0;
+
+=09entry =3D &ring->dirty_gfns[ring->reset_index & (ring->size - 1)];
+=09/*
+=09 * The ring buffer is shared with userspace, which might mmap
+=09 * it and concurrently modify slot and offset.  Userspace must
+=09 * not be trusted!  READ_ONCE prevents the compiler from changing
+=09 * the values after they've been range-checked (the checks are
+=09 * in kvm_reset_dirty_gfn).
+=09 */
+=09smp_read_barrier_depends();
+=09cur_slot =3D READ_ONCE(entry->slot);
+=09cur_offset =3D READ_ONCE(entry->offset);
+=09mask =3D 1;
+=09count++;
+=09ring->reset_index++;
+=09while (ring->reset_index !=3D fetch) {
+=09=09entry =3D &ring->dirty_gfns[ring->reset_index & (ring->size - 1)];
+=09=09smp_read_barrier_depends();
+=09=09next_slot =3D READ_ONCE(entry->slot);
+=09=09next_offset =3D READ_ONCE(entry->offset);
+=09=09ring->reset_index++;
+=09=09count++;
+=09=09/*
+=09=09 * Try to coalesce the reset operations when the guest is
+=09=09 * scanning pages in the same slot.
+=09=09 */
+=09=09if (next_slot =3D=3D cur_slot) {
+=09=09=09int delta =3D next_offset - cur_offset;
+
+=09=09=09if (delta >=3D 0 && delta < BITS_PER_LONG) {
+=09=09=09=09mask |=3D 1ull << delta;
+=09=09=09=09continue;
+=09=09=09}
+
+=09=09=09/* Backwards visit, careful about overflows!  */
+=09=09=09if (delta > -BITS_PER_LONG && delta < 0 &&
+=09=09=09    (mask << -delta >> -delta) =3D=3D mask) {
+=09=09=09=09cur_offset =3D next_offset;
+=09=09=09=09mask =3D (mask << -delta) | 1;
+=09=09=09=09continue;
+=09=09=09}
+=09=09}
+=09=09kvm_reset_dirty_gfn(kvm, cur_slot, cur_offset, mask);
+=09=09cur_slot =3D next_slot;
+=09=09cur_offset =3D next_offset;
+=09=09mask =3D 1;
+=09}
+=09kvm_reset_dirty_gfn(kvm, cur_slot, cur_offset, mask);
+
+=09return count;
+}
+
+static inline u32 kvm_dirty_ring_used(struct kvm_dirty_ring *ring)
+{
+=09return ring->dirty_index - ring->reset_index;
+}
+
+bool kvm_dirty_ring_full(struct kvm_dirty_ring *ring)
+{
+=09return kvm_dirty_ring_used(ring) >=3D ring->size;
+}
+
+/*
+ * Returns:
+ *   >0 if we should kick the vcpu out,
+ *   =3D0 if the gfn pushed successfully, or,
+ *   <0 if error (e.g. ring full)
+ */
+int kvm_dirty_ring_push(struct kvm_dirty_ring *ring,
+=09=09=09struct kvm_dirty_ring_indexes *indexes,
+=09=09=09u32 slot, u64 offset, bool lock)
+{
+=09int ret;
+=09struct kvm_dirty_gfn *entry;
+
+=09if (lock)
+=09=09spin_lock(&ring->lock);
+
+=09if (kvm_dirty_ring_full(ring)) {
+=09=09ret =3D -EBUSY;
+=09=09goto out;
+=09}
+
+=09entry =3D &ring->dirty_gfns[ring->dirty_index & (ring->size - 1)];
+=09entry->slot =3D slot;
+=09entry->offset =3D offset;
+=09smp_wmb();
+=09ring->dirty_index++;
+=09WRITE_ONCE(indexes->avail_index, ring->dirty_index);
+=09ret =3D kvm_dirty_ring_used(ring) >=3D ring->soft_limit;
+=09pr_info("%s: slot %u offset %llu used %u\n",
+=09=09__func__, slot, offset, kvm_dirty_ring_used(ring));
+
+out:
+=09if (lock)
+=09=09spin_unlock(&ring->lock);
+
+=09return ret;
+}
+
+struct page *kvm_dirty_ring_get_page(struct kvm_dirty_ring *ring, u32 i)
+{
+=09return vmalloc_to_page((void *)ring->dirty_gfns + i * PAGE_SIZE);
+}
+
+void kvm_dirty_ring_free(struct kvm_dirty_ring *ring)
+{
+=09if (ring->dirty_gfns) {
+=09=09vfree(ring->dirty_gfns);
+=09=09ring->dirty_gfns =3D NULL;
+=09}
+}
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 681452d288cd..8642c977629b 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -64,6 +64,8 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/kvm.h>
=20
+#include <linux/kvm_dirty_ring.h>
+
 /* Worst case buffer size needed for holding an integer. */
 #define ITOA_MAX_LEN 12
=20
@@ -149,6 +151,10 @@ static void mark_page_dirty_in_slot(struct kvm *kvm,
 =09=09=09=09    struct kvm_vcpu *vcpu,
 =09=09=09=09    struct kvm_memory_slot *memslot,
 =09=09=09=09    gfn_t gfn);
+static void mark_page_dirty_in_ring(struct kvm *kvm,
+=09=09=09=09    struct kvm_vcpu *vcpu,
+=09=09=09=09    struct kvm_memory_slot *slot,
+=09=09=09=09    gfn_t gfn);
=20
 __visible bool kvm_rebooting;
 EXPORT_SYMBOL_GPL(kvm_rebooting);
@@ -359,11 +365,22 @@ int kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *=
kvm, unsigned id)
 =09vcpu->preempted =3D false;
 =09vcpu->ready =3D false;
=20
+=09if (kvm->dirty_ring_size) {
+=09=09r =3D kvm_dirty_ring_alloc(vcpu->kvm, &vcpu->dirty_ring);
+=09=09if (r) {
+=09=09=09kvm->dirty_ring_size =3D 0;
+=09=09=09goto fail_free_run;
+=09=09}
+=09}
+
 =09r =3D kvm_arch_vcpu_init(vcpu);
 =09if (r < 0)
-=09=09goto fail_free_run;
+=09=09goto fail_free_ring;
 =09return 0;
=20
+fail_free_ring:
+=09if (kvm->dirty_ring_size)
+=09=09kvm_dirty_ring_free(&vcpu->dirty_ring);
 fail_free_run:
 =09free_page((unsigned long)vcpu->run);
 fail:
@@ -381,6 +398,8 @@ void kvm_vcpu_uninit(struct kvm_vcpu *vcpu)
 =09put_pid(rcu_dereference_protected(vcpu->pid, 1));
 =09kvm_arch_vcpu_uninit(vcpu);
 =09free_page((unsigned long)vcpu->run);
+=09if (vcpu->kvm->dirty_ring_size)
+=09=09kvm_dirty_ring_free(&vcpu->dirty_ring);
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_uninit);
=20
@@ -690,6 +709,7 @@ static struct kvm *kvm_create_vm(unsigned long type)
 =09struct kvm *kvm =3D kvm_arch_alloc_vm();
 =09int r =3D -ENOMEM;
 =09int i;
+=09struct page *page;
=20
 =09if (!kvm)
 =09=09return ERR_PTR(-ENOMEM);
@@ -705,6 +725,14 @@ static struct kvm *kvm_create_vm(unsigned long type)
=20
 =09BUILD_BUG_ON(KVM_MEM_SLOTS_NUM > SHRT_MAX);
=20
+=09page =3D alloc_page(GFP_KERNEL | __GFP_ZERO);
+=09if (!page) {
+=09=09r =3D -ENOMEM;
+=09=09goto out_err_alloc_page;
+=09}
+=09kvm->vm_run =3D page_address(page);
+=09BUILD_BUG_ON(sizeof(struct kvm_vm_run) > PAGE_SIZE);
+
 =09if (init_srcu_struct(&kvm->srcu))
 =09=09goto out_err_no_srcu;
 =09if (init_srcu_struct(&kvm->irq_srcu))
@@ -775,6 +803,9 @@ static struct kvm *kvm_create_vm(unsigned long type)
 out_err_no_irq_srcu:
 =09cleanup_srcu_struct(&kvm->srcu);
 out_err_no_srcu:
+=09free_page((unsigned long)page);
+=09kvm->vm_run =3D NULL;
+out_err_alloc_page:
 =09kvm_arch_free_vm(kvm);
 =09mmdrop(current->mm);
 =09return ERR_PTR(r);
@@ -800,6 +831,15 @@ static void kvm_destroy_vm(struct kvm *kvm)
 =09int i;
 =09struct mm_struct *mm =3D kvm->mm;
=20
+=09if (kvm->dirty_ring_size) {
+=09=09kvm_dirty_ring_free(&kvm->vm_dirty_ring);
+=09}
+
+=09if (kvm->vm_run) {
+=09=09free_page((unsigned long)kvm->vm_run);
+=09=09kvm->vm_run =3D NULL;
+=09}
+
 =09kvm_uevent_notify_change(KVM_EVENT_DESTROY_VM, kvm);
 =09kvm_destroy_vm_debugfs(kvm);
 =09kvm_arch_sync_events(kvm);
@@ -2301,7 +2341,7 @@ static void mark_page_dirty_in_slot(struct kvm *kvm,
 {
 =09if (memslot && memslot->dirty_bitmap) {
 =09=09unsigned long rel_gfn =3D gfn - memslot->base_gfn;
-
+=09=09mark_page_dirty_in_ring(kvm, vcpu, memslot, gfn);
 =09=09set_bit_le(rel_gfn, memslot->dirty_bitmap);
 =09}
 }
@@ -2649,6 +2689,13 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me, bool yiel=
d_to_kernel_mode)
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_on_spin);
=20
+static bool kvm_fault_in_dirty_ring(struct kvm *kvm, struct vm_fault *vmf)
+{
+=09return (vmf->pgoff >=3D KVM_DIRTY_LOG_PAGE_OFFSET) &&
+=09    (vmf->pgoff < KVM_DIRTY_LOG_PAGE_OFFSET +
+=09     kvm->dirty_ring_size / PAGE_SIZE);
+}
+
 static vm_fault_t kvm_vcpu_fault(struct vm_fault *vmf)
 {
 =09struct kvm_vcpu *vcpu =3D vmf->vma->vm_file->private_data;
@@ -2664,6 +2711,10 @@ static vm_fault_t kvm_vcpu_fault(struct vm_fault *vm=
f)
 =09else if (vmf->pgoff =3D=3D KVM_COALESCED_MMIO_PAGE_OFFSET)
 =09=09page =3D virt_to_page(vcpu->kvm->coalesced_mmio_ring);
 #endif
+=09else if (kvm_fault_in_dirty_ring(vcpu->kvm, vmf))
+=09=09page =3D kvm_dirty_ring_get_page(
+=09=09    &vcpu->dirty_ring,
+=09=09    vmf->pgoff - KVM_DIRTY_LOG_PAGE_OFFSET);
 =09else
 =09=09return kvm_arch_vcpu_fault(vcpu, vmf);
 =09get_page(page);
@@ -3259,12 +3310,162 @@ static long kvm_vm_ioctl_check_extension_generic(s=
truct kvm *kvm, long arg)
 #endif
 =09case KVM_CAP_NR_MEMSLOTS:
 =09=09return KVM_USER_MEM_SLOTS;
+=09case KVM_CAP_DIRTY_LOG_RING:
+=09=09/* Version will be zero if arch didn't implement it */
+=09=09return KVM_DIRTY_RING_VERSION;
 =09default:
 =09=09break;
 =09}
 =09return kvm_vm_ioctl_check_extension(kvm, arg);
 }
=20
+static void mark_page_dirty_in_ring(struct kvm *kvm,
+=09=09=09=09    struct kvm_vcpu *vcpu,
+=09=09=09=09    struct kvm_memory_slot *slot,
+=09=09=09=09    gfn_t gfn)
+{
+=09u32 as_id =3D 0;
+=09u64 offset;
+=09int ret;
+=09struct kvm_dirty_ring *ring;
+=09struct kvm_dirty_ring_indexes *indexes;
+=09bool is_vm_ring;
+
+=09if (!kvm->dirty_ring_size)
+=09=09return;
+
+=09offset =3D gfn - slot->base_gfn;
+
+=09if (vcpu) {
+=09=09as_id =3D kvm_arch_vcpu_memslots_id(vcpu);
+=09} else {
+=09=09as_id =3D 0;
+=09=09vcpu =3D kvm_get_running_vcpu();
+=09}
+
+=09if (vcpu) {
+=09=09ring =3D &vcpu->dirty_ring;
+=09=09indexes =3D &vcpu->run->vcpu_ring_indexes;
+=09=09is_vm_ring =3D false;
+=09} else {
+=09=09/*
+=09=09 * Put onto per vm ring because no vcpu context.  Kick
+=09=09 * vcpu0 if ring is full.
+=09=09 */
+=09=09vcpu =3D kvm->vcpus[0];
+=09=09ring =3D &kvm->vm_dirty_ring;
+=09=09indexes =3D &kvm->vm_run->vm_ring_indexes;
+=09=09is_vm_ring =3D true;
+=09}
+
+=09ret =3D kvm_dirty_ring_push(ring, indexes,
+=09=09=09=09  (as_id << 16)|slot->id, offset,
+=09=09=09=09  is_vm_ring);
+=09if (ret < 0) {
+=09=09if (is_vm_ring)
+=09=09=09pr_warn_once("vcpu %d dirty log overflow\n",
+=09=09=09=09     vcpu->vcpu_id);
+=09=09else
+=09=09=09pr_warn_once("per-vm dirty log overflow\n");
+=09=09return;
+=09}
+
+=09if (ret)
+=09=09kvm_make_request(KVM_REQ_DIRTY_RING_FULL, vcpu);
+}
+
+void kvm_reset_dirty_gfn(struct kvm *kvm, u32 slot, u64 offset, u64 mask)
+{
+=09struct kvm_memory_slot *memslot;
+=09int as_id, id;
+
+=09as_id =3D slot >> 16;
+=09id =3D (u16)slot;
+=09if (as_id >=3D KVM_ADDRESS_SPACE_NUM || id >=3D KVM_USER_MEM_SLOTS)
+=09=09return;
+
+=09memslot =3D id_to_memslot(__kvm_memslots(kvm, as_id), id);
+=09if (offset >=3D memslot->npages)
+=09=09return;
+
+=09spin_lock(&kvm->mmu_lock);
+=09/* FIXME: we should use a single AND operation, but there is no
+=09 * applicable atomic API.
+=09 */
+=09while (mask) {
+=09=09clear_bit_le(offset + __ffs(mask), memslot->dirty_bitmap);
+=09=09mask &=3D mask - 1;
+=09}
+
+=09kvm_arch_mmu_enable_log_dirty_pt_masked(kvm, memslot, offset, mask);
+=09spin_unlock(&kvm->mmu_lock);
+}
+
+static int kvm_vm_ioctl_enable_dirty_log_ring(struct kvm *kvm, u32 size)
+{
+=09int r;
+
+=09/* the size should be power of 2 */
+=09if (!size || (size & (size - 1)))
+=09=09return -EINVAL;
+
+=09/* Should be bigger to keep the reserved entries, or a page */
+=09if (size < kvm_dirty_ring_get_rsvd_entries() *
+=09    sizeof(struct kvm_dirty_gfn) || size < PAGE_SIZE)
+=09=09return -EINVAL;
+
+=09if (size > KVM_DIRTY_RING_MAX_ENTRIES *
+=09    sizeof(struct kvm_dirty_gfn))
+=09=09return -E2BIG;
+
+=09/* We only allow it to set once */
+=09if (kvm->dirty_ring_size)
+=09=09return -EINVAL;
+
+=09mutex_lock(&kvm->lock);
+
+=09if (kvm->created_vcpus) {
+=09=09/* We don't allow to change this value after vcpu created */
+=09=09r =3D -EINVAL;
+=09} else {
+=09=09kvm->dirty_ring_size =3D size;
+=09=09r =3D kvm_dirty_ring_alloc(kvm, &kvm->vm_dirty_ring);
+=09=09if (r) {
+=09=09=09/* Unset dirty ring */
+=09=09=09kvm->dirty_ring_size =3D 0;
+=09=09}
+=09}
+
+=09mutex_unlock(&kvm->lock);
+=09return r;
+}
+
+static int kvm_vm_ioctl_reset_dirty_pages(struct kvm *kvm)
+{
+=09int i;
+=09struct kvm_vcpu *vcpu;
+=09int cleared =3D 0;
+
+=09if (!kvm->dirty_ring_size)
+=09=09return -EINVAL;
+
+=09mutex_lock(&kvm->slots_lock);
+
+=09cleared +=3D kvm_dirty_ring_reset(kvm, &kvm->vm_dirty_ring,
+=09=09=09=09=09&kvm->vm_run->vm_ring_indexes);
+
+=09kvm_for_each_vcpu(i, vcpu, kvm)
+=09=09cleared +=3D kvm_dirty_ring_reset(vcpu->kvm, &vcpu->dirty_ring,
+=09=09=09=09=09=09&vcpu->run->vcpu_ring_indexes);
+
+=09mutex_unlock(&kvm->slots_lock);
+
+=09if (cleared)
+=09=09kvm_flush_remote_tlbs(kvm);
+
+=09return cleared;
+}
+
 int __attribute__((weak)) kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 =09=09=09=09=09=09  struct kvm_enable_cap *cap)
 {
@@ -3282,6 +3483,8 @@ static int kvm_vm_ioctl_enable_cap_generic(struct kvm=
 *kvm,
 =09=09kvm->manual_dirty_log_protect =3D cap->args[0];
 =09=09return 0;
 #endif
+=09case KVM_CAP_DIRTY_LOG_RING:
+=09=09return kvm_vm_ioctl_enable_dirty_log_ring(kvm, cap->args[0]);
 =09default:
 =09=09return kvm_vm_ioctl_enable_cap(kvm, cap);
 =09}
@@ -3469,6 +3672,9 @@ static long kvm_vm_ioctl(struct file *filp,
 =09case KVM_CHECK_EXTENSION:
 =09=09r =3D kvm_vm_ioctl_check_extension_generic(kvm, arg);
 =09=09break;
+=09case KVM_RESET_DIRTY_RINGS:
+=09=09r =3D kvm_vm_ioctl_reset_dirty_pages(kvm);
+=09=09break;
 =09default:
 =09=09r =3D kvm_arch_vm_ioctl(filp, ioctl, arg);
 =09}
@@ -3517,9 +3723,39 @@ static long kvm_vm_compat_ioctl(struct file *filp,
 }
 #endif
=20
+static vm_fault_t kvm_vm_fault(struct vm_fault *vmf)
+{
+=09struct kvm *kvm =3D vmf->vma->vm_file->private_data;
+=09struct page *page =3D NULL;
+
+=09if (vmf->pgoff =3D=3D 0)
+=09=09page =3D virt_to_page(kvm->vm_run);
+=09else if (kvm_fault_in_dirty_ring(kvm, vmf))
+=09=09page =3D kvm_dirty_ring_get_page(
+=09=09    &kvm->vm_dirty_ring,
+=09=09    vmf->pgoff - KVM_DIRTY_LOG_PAGE_OFFSET);
+=09else
+=09=09return VM_FAULT_SIGBUS;
+
+=09get_page(page);
+=09vmf->page =3D page;
+=09return 0;
+}
+
+static const struct vm_operations_struct kvm_vm_vm_ops =3D {
+=09.fault =3D kvm_vm_fault,
+};
+
+static int kvm_vm_mmap(struct file *file, struct vm_area_struct *vma)
+{
+=09vma->vm_ops =3D &kvm_vm_vm_ops;
+=09return 0;
+}
+
 static struct file_operations kvm_vm_fops =3D {
 =09.release        =3D kvm_vm_release,
 =09.unlocked_ioctl =3D kvm_vm_ioctl,
+=09.mmap           =3D kvm_vm_mmap,
 =09.llseek=09=09=3D noop_llseek,
 =09KVM_COMPAT(kvm_vm_compat_ioctl),
 };
--=20
2.21.0

