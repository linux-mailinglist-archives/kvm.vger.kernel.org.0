Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F742230C92
	for <lists+kvm@lfdr.de>; Tue, 28 Jul 2020 16:38:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730492AbgG1OiG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jul 2020 10:38:06 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:25065 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730482AbgG1OiF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 28 Jul 2020 10:38:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595947083;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/9HJ/UB6ue7b4U1ejYNwm1Yc7m1JS9d+wZ3rPN6ArFo=;
        b=IuuT3eRBCn9HRsvzTVwHsPPQjmkub+l5WRJIKGcnPmbGb4Yj+J8y7zhFvOE0TGmeLYOu/t
        GapbircYrALfllEzH5u7gkIaXNA/irI6RwGe8JlUkI8F7qs1AkLfYJH18U8t0ZtYWoqFEu
        h648OQa2drgMz936G6aynGlyzSnmmvM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-459--7RPfeetNfq7kpcFj2p2ng-1; Tue, 28 Jul 2020 10:38:00 -0400
X-MC-Unique: -7RPfeetNfq7kpcFj2p2ng-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C38A4800688;
        Tue, 28 Jul 2020 14:37:58 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.70])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1CFA17BD60;
        Tue, 28 Jul 2020 14:37:55 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Xu <peterx@redhat.com>, Michael Tsirkin <mst@redhat.com>,
        Julia Suvorova <jsuvorov@redhat.com>,
        Andy Lutomirski <luto@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] KVM: x86: introduce KVM_MEM_PCI_HOLE memory
Date:   Tue, 28 Jul 2020 16:37:40 +0200
Message-Id: <20200728143741.2718593-3-vkuznets@redhat.com>
In-Reply-To: <20200728143741.2718593-1-vkuznets@redhat.com>
References: <20200728143741.2718593-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PCIe config space can (depending on the configuration) be quite big but
usually is sparsely populated. Guest may scan it by accessing individual
device's page which, when device is missing, is supposed to have 'pci
hole' semantics: reads return '0xff' and writes get discarded. Compared
to the already existing KVM_MEM_READONLY, VMM doesn't need to allocate
real memory and stuff it with '0xff'.

Suggested-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 Documentation/virt/kvm/api.rst  | 19 +++++++++++-----
 arch/x86/include/uapi/asm/kvm.h |  1 +
 arch/x86/kvm/mmu/mmu.c          |  5 ++++-
 arch/x86/kvm/mmu/paging_tmpl.h  |  3 +++
 arch/x86/kvm/x86.c              | 10 ++++++---
 include/linux/kvm_host.h        |  7 +++++-
 include/uapi/linux/kvm.h        |  3 ++-
 virt/kvm/kvm_main.c             | 39 +++++++++++++++++++++++++++------
 8 files changed, 68 insertions(+), 19 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 644e5326aa50..fbbf533a331b 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -1241,6 +1241,7 @@ yet and must be cleared on entry.
   /* for kvm_memory_region::flags */
   #define KVM_MEM_LOG_DIRTY_PAGES	(1UL << 0)
   #define KVM_MEM_READONLY	(1UL << 1)
+  #define KVM_MEM_PCI_HOLE		(1UL << 2)
 
 This ioctl allows the user to create, modify or delete a guest physical
 memory slot.  Bits 0-15 of "slot" specify the slot id and this value
@@ -1268,12 +1269,18 @@ It is recommended that the lower 21 bits of guest_phys_addr and userspace_addr
 be identical.  This allows large pages in the guest to be backed by large
 pages in the host.
 
-The flags field supports two flags: KVM_MEM_LOG_DIRTY_PAGES and
-KVM_MEM_READONLY.  The former can be set to instruct KVM to keep track of
-writes to memory within the slot.  See KVM_GET_DIRTY_LOG ioctl to know how to
-use it.  The latter can be set, if KVM_CAP_READONLY_MEM capability allows it,
-to make a new slot read-only.  In this case, writes to this memory will be
-posted to userspace as KVM_EXIT_MMIO exits.
+The flags field supports the following flags: KVM_MEM_LOG_DIRTY_PAGES,
+KVM_MEM_READONLY, KVM_MEM_READONLY:
+- KVM_MEM_LOG_DIRTY_PAGES can be set to instruct KVM to keep track of writes to
+  memory within the slot.  See KVM_GET_DIRTY_LOG ioctl to know how to use it.
+- KVM_MEM_READONLY can be set, if KVM_CAP_READONLY_MEM capability allows it,
+  to make a new slot read-only.  In this case, writes to this memory will be
+  posted to userspace as KVM_EXIT_MMIO exits.
+- KVM_MEM_PCI_HOLE can be set, if KVM_CAP_PCI_HOLE_MEM capability allows it,
+  to create a new virtual read-only slot which will always return '0xff' when
+  guest reads from it. 'userspace_addr' has to be set to NULL. This flag is
+  mutually exclusive with KVM_MEM_LOG_DIRTY_PAGES/KVM_MEM_READONLY. All writes
+  to this memory will be posted to userspace as KVM_EXIT_MMIO exits.
 
 When the KVM_CAP_SYNC_MMU capability is available, changes in the backing of
 the memory region are automatically reflected into the guest.  For example, an
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 17c5a038f42d..cf80a26d74f5 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -48,6 +48,7 @@
 #define __KVM_HAVE_XSAVE
 #define __KVM_HAVE_XCRS
 #define __KVM_HAVE_READONLY_MEM
+#define __KVM_HAVE_PCI_HOLE_MEM
 
 /* Architectural interrupt line count. */
 #define KVM_NR_INTERRUPTS 256
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 8597e8102636..c2e3a1deafdd 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3253,7 +3253,7 @@ static int kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, gfn_t gfn,
 		return PG_LEVEL_4K;
 
 	slot = gfn_to_memslot_dirty_bitmap(vcpu, gfn, true);
-	if (!slot)
+	if (!slot || (slot->flags & KVM_MEM_PCI_HOLE))
 		return PG_LEVEL_4K;
 
 	max_level = min(max_level, max_page_level);
@@ -4104,6 +4104,9 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 
 	slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
 
+	if (!write && slot && (slot->flags & KVM_MEM_PCI_HOLE))
+		return RET_PF_EMULATE;
+
 	if (try_async_pf(vcpu, slot, prefault, gfn, gpa, &pfn, write,
 			 &map_writable))
 		return RET_PF_RETRY;
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 5c6a895f67c3..27abd69e69f6 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -836,6 +836,9 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gpa_t addr, u32 error_code,
 
 	slot = kvm_vcpu_gfn_to_memslot(vcpu, walker.gfn);
 
+	if (!write_fault && slot && (slot->flags & KVM_MEM_PCI_HOLE))
+		return RET_PF_EMULATE;
+
 	if (try_async_pf(vcpu, slot, prefault, walker.gfn, addr, &pfn,
 			 write_fault, &map_writable))
 		return RET_PF_RETRY;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 95ef62922869..dc312b8bfa05 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3515,6 +3515,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_EXCEPTION_PAYLOAD:
 	case KVM_CAP_SET_GUEST_DEBUG:
 	case KVM_CAP_LAST_CPU:
+	case KVM_CAP_PCI_HOLE_MEM:
 		r = 1;
 		break;
 	case KVM_CAP_SYNC_REGS:
@@ -10115,9 +10116,11 @@ static int kvm_alloc_memslot_metadata(struct kvm_memory_slot *slot,
 		ugfn = slot->userspace_addr >> PAGE_SHIFT;
 		/*
 		 * If the gfn and userspace address are not aligned wrt each
-		 * other, disable large page support for this slot.
+		 * other, disable large page support for this slot. Also,
+		 * disable large page support for KVM_MEM_PCI_HOLE slots.
 		 */
-		if ((slot->base_gfn ^ ugfn) & (KVM_PAGES_PER_HPAGE(level) - 1)) {
+		if (slot->flags & KVM_MEM_PCI_HOLE || ((slot->base_gfn ^ ugfn) &
+				      (KVM_PAGES_PER_HPAGE(level) - 1))) {
 			unsigned long j;
 
 			for (j = 0; j < lpages; ++j)
@@ -10179,7 +10182,8 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
 	 * Nothing to do for RO slots or CREATE/MOVE/DELETE of a slot.
 	 * See comments below.
 	 */
-	if ((change != KVM_MR_FLAGS_ONLY) || (new->flags & KVM_MEM_READONLY))
+	if ((change != KVM_MR_FLAGS_ONLY) || (new->flags & KVM_MEM_READONLY) ||
+	    (new->flags & KVM_MEM_PCI_HOLE))
 		return;
 
 	/*
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 989afcbe642f..63c2d93ef172 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1081,7 +1081,12 @@ __gfn_to_memslot(struct kvm_memslots *slots, gfn_t gfn)
 static inline unsigned long
 __gfn_to_hva_memslot(struct kvm_memory_slot *slot, gfn_t gfn)
 {
-	return slot->userspace_addr + (gfn - slot->base_gfn) * PAGE_SIZE;
+	if (likely(!(slot->flags & KVM_MEM_PCI_HOLE))) {
+		return slot->userspace_addr +
+			(gfn - slot->base_gfn) * PAGE_SIZE;
+	} else {
+		BUG();
+	}
 }
 
 static inline int memslot_id(struct kvm *kvm, gfn_t gfn)
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 2c73dcfb3dbb..59d631cbb71d 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -109,6 +109,7 @@ struct kvm_userspace_memory_region {
  */
 #define KVM_MEM_LOG_DIRTY_PAGES	(1UL << 0)
 #define KVM_MEM_READONLY	(1UL << 1)
+#define KVM_MEM_PCI_HOLE		(1UL << 2)
 
 /* for KVM_IRQ_LINE */
 struct kvm_irq_level {
@@ -1034,7 +1035,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_ASYNC_PF_INT 183
 #define KVM_CAP_LAST_CPU 184
 #define KVM_CAP_SMALLER_MAXPHYADDR 185
-
+#define KVM_CAP_PCI_HOLE_MEM 186
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 2c2c0254c2d8..3f69ae711021 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1107,6 +1107,10 @@ static int check_memory_region_flags(const struct kvm_userspace_memory_region *m
 	valid_flags |= KVM_MEM_READONLY;
 #endif
 
+#ifdef __KVM_HAVE_PCI_HOLE_MEM
+	valid_flags |= KVM_MEM_PCI_HOLE;
+#endif
+
 	if (mem->flags & ~valid_flags)
 		return -EINVAL;
 
@@ -1284,11 +1288,26 @@ int __kvm_set_memory_region(struct kvm *kvm,
 		return -EINVAL;
 	if (mem->guest_phys_addr & (PAGE_SIZE - 1))
 		return -EINVAL;
-	/* We can read the guest memory with __xxx_user() later on. */
-	if ((mem->userspace_addr & (PAGE_SIZE - 1)) ||
-	     !access_ok((void __user *)(unsigned long)mem->userspace_addr,
-			mem->memory_size))
+
+	/*
+	 * KVM_MEM_PCI_HOLE is mutually exclusive with KVM_MEM_READONLY/
+	 * KVM_MEM_LOG_DIRTY_PAGES.
+	 */
+	if ((mem->flags & KVM_MEM_PCI_HOLE) &&
+	    (mem->flags & (KVM_MEM_READONLY | KVM_MEM_LOG_DIRTY_PAGES)))
 		return -EINVAL;
+
+	if (!(mem->flags & KVM_MEM_PCI_HOLE)) {
+		/* We can read the guest memory with __xxx_user() later on. */
+		if ((mem->userspace_addr & (PAGE_SIZE - 1)) ||
+		    !access_ok((void __user *)(unsigned long)mem->userspace_addr,
+			       mem->memory_size))
+			return -EINVAL;
+	} else {
+		if (mem->userspace_addr)
+			return -EINVAL;
+	}
+
 	if (as_id >= KVM_ADDRESS_SPACE_NUM || id >= KVM_MEM_SLOTS_NUM)
 		return -EINVAL;
 	if (mem->guest_phys_addr + mem->memory_size < mem->guest_phys_addr)
@@ -1328,7 +1347,8 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	} else { /* Modify an existing slot. */
 		if ((new.userspace_addr != old.userspace_addr) ||
 		    (new.npages != old.npages) ||
-		    ((new.flags ^ old.flags) & KVM_MEM_READONLY))
+		    ((new.flags ^ old.flags) & KVM_MEM_READONLY) ||
+		    ((new.flags ^ old.flags) & KVM_MEM_PCI_HOLE))
 			return -EINVAL;
 
 		if (new.base_gfn != old.base_gfn)
@@ -1715,13 +1735,13 @@ unsigned long kvm_host_page_size(struct kvm_vcpu *vcpu, gfn_t gfn)
 
 static bool memslot_is_readonly(struct kvm_memory_slot *slot)
 {
-	return slot->flags & KVM_MEM_READONLY;
+	return slot->flags & (KVM_MEM_READONLY | KVM_MEM_PCI_HOLE);
 }
 
 static unsigned long __gfn_to_hva_many(struct kvm_memory_slot *slot, gfn_t gfn,
 				       gfn_t *nr_pages, bool write)
 {
-	if (!slot || slot->flags & KVM_MEMSLOT_INVALID)
+	if (!slot || (slot->flags & (KVM_MEMSLOT_INVALID | KVM_MEM_PCI_HOLE)))
 		return KVM_HVA_ERR_BAD;
 
 	if (memslot_is_readonly(slot) && write)
@@ -2318,6 +2338,11 @@ static int __kvm_read_guest_page(struct kvm_memory_slot *slot, gfn_t gfn,
 	int r;
 	unsigned long addr;
 
+	if (unlikely(slot && (slot->flags & KVM_MEM_PCI_HOLE))) {
+		memset(data, 0xff, len);
+		return 0;
+	}
+
 	addr = gfn_to_hva_memslot_prot(slot, gfn, NULL);
 	if (kvm_is_error_hva(addr))
 		return -EFAULT;
-- 
2.25.4

