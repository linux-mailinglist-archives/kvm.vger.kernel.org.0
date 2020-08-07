Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 334F823EECA
	for <lists+kvm@lfdr.de>; Fri,  7 Aug 2020 16:13:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725970AbgHGONC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Aug 2020 10:13:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26427 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726605AbgHGOM7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Aug 2020 10:12:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596809577;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZOVFeD54uWTNVYt9d1e29eOWPuCx+GEP4I0eHGR0r7M=;
        b=DBA19N9I40BAYYeVFkO/8OK6kuHemMArLBTp38xaB6DR9rWw3RzIMn2XqhYA8qHScy3kza
        AcpPQTaMvFPlr5jqEZSuvKuSsaGgUZEagTuUlBd6XKN2dsF8oN4JrozZ8oPr5+8mwSZpJl
        ZPLY6u5pJrtGj3rOmgcSQuJ+4E6rECM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-27-iKktexiqMreFR_E4FShiyg-1; Fri, 07 Aug 2020 10:12:52 -0400
X-MC-Unique: iKktexiqMreFR_E4FShiyg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AB5C319057A6;
        Fri,  7 Aug 2020 14:12:50 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.139])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B55DC5C1D3;
        Fri,  7 Aug 2020 14:12:47 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Xu <peterx@redhat.com>, Michael Tsirkin <mst@redhat.com>,
        Julia Suvorova <jsuvorov@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Andrew Jones <drjones@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/3] KVM: x86: introduce KVM_MEM_PCI_HOLE memory
Date:   Fri,  7 Aug 2020 16:12:31 +0200
Message-Id: <20200807141232.402895-3-vkuznets@redhat.com>
In-Reply-To: <20200807141232.402895-1-vkuznets@redhat.com>
References: <20200807141232.402895-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
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
 Documentation/virt/kvm/api.rst  | 18 ++++++++++-----
 arch/x86/include/uapi/asm/kvm.h |  1 +
 arch/x86/kvm/mmu/mmu.c          |  5 ++++-
 arch/x86/kvm/mmu/paging_tmpl.h  |  3 +++
 arch/x86/kvm/x86.c              | 10 ++++++---
 include/linux/kvm_host.h        |  3 +++
 include/uapi/linux/kvm.h        |  2 ++
 virt/kvm/kvm_main.c             | 39 +++++++++++++++++++++++++++------
 8 files changed, 64 insertions(+), 17 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 644e5326aa50..dc4172352635 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -1241,6 +1241,7 @@ yet and must be cleared on entry.
   /* for kvm_memory_region::flags */
   #define KVM_MEM_LOG_DIRTY_PAGES	(1UL << 0)
   #define KVM_MEM_READONLY	(1UL << 1)
+  #define KVM_MEM_PCI_HOLE		(1UL << 2)
 
 This ioctl allows the user to create, modify or delete a guest physical
 memory slot.  Bits 0-15 of "slot" specify the slot id and this value
@@ -1268,12 +1269,17 @@ It is recommended that the lower 21 bits of guest_phys_addr and userspace_addr
 be identical.  This allows large pages in the guest to be backed by large
 pages in the host.
 
-The flags field supports two flags: KVM_MEM_LOG_DIRTY_PAGES and
-KVM_MEM_READONLY.  The former can be set to instruct KVM to keep track of
-writes to memory within the slot.  See KVM_GET_DIRTY_LOG ioctl to know how to
-use it.  The latter can be set, if KVM_CAP_READONLY_MEM capability allows it,
-to make a new slot read-only.  In this case, writes to this memory will be
-posted to userspace as KVM_EXIT_MMIO exits.
+The flags field supports the following flags: KVM_MEM_LOG_DIRTY_PAGES,
+KVM_MEM_READONLY, KVM_MEM_PCI_HOLE:
+- KVM_MEM_LOG_DIRTY_PAGES: log writes.  Use KVM_GET_DIRTY_LOG to retreive
+  the log.
+- KVM_MEM_READONLY: exit to userspace with KVM_EXIT_MMIO on writes.  Only
+  available when KVM_CAP_READONLY_MEM is present.
+- KVM_MEM_PCI_HOLE: always return 0xff on reads, exit to userspace with
+  KVM_EXIT_MMIO on writes.  Only available when KVM_CAP_PCI_HOLE_MEM is
+  present.  When setting the memory region 'userspace_addr' must be NULL.
+  This flag is mutually exclusive with KVM_MEM_LOG_DIRTY_PAGES and with
+  KVM_MEM_READONLY.
 
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
index fef6956393f7..4a2a7fface1e 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3254,7 +3254,7 @@ static int kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, gfn_t gfn,
 		return PG_LEVEL_4K;
 
 	slot = gfn_to_memslot_dirty_bitmap(vcpu, gfn, true);
-	if (!slot)
+	if (!slot || (slot->flags & KVM_MEM_PCI_HOLE))
 		return PG_LEVEL_4K;
 
 	max_level = min(max_level, max_huge_page_level);
@@ -4105,6 +4105,9 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 
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
index dc4370394ab8..538bc58a22db 100644
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
@@ -10114,9 +10115,11 @@ static int kvm_alloc_memslot_metadata(struct kvm_memory_slot *slot,
 		ugfn = slot->userspace_addr >> PAGE_SHIFT;
 		/*
 		 * If the gfn and userspace address are not aligned wrt each
-		 * other, disable large page support for this slot.
+		 * other, disable large page support for this slot. Also,
+		 * disable large page support for KVM_MEM_PCI_HOLE slots.
 		 */
-		if ((slot->base_gfn ^ ugfn) & (KVM_PAGES_PER_HPAGE(level) - 1)) {
+		if ((slot->flags & KVM_MEM_PCI_HOLE) || ((slot->base_gfn ^ ugfn) &
+				      (KVM_PAGES_PER_HPAGE(level) - 1))) {
 			unsigned long j;
 
 			for (j = 0; j < lpages; ++j)
@@ -10178,7 +10181,8 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
 	 * Nothing to do for RO slots or CREATE/MOVE/DELETE of a slot.
 	 * See comments below.
 	 */
-	if ((change != KVM_MR_FLAGS_ONLY) || (new->flags & KVM_MEM_READONLY))
+	if ((change != KVM_MR_FLAGS_ONLY) ||
+	    (new->flags & (KVM_MEM_READONLY | KVM_MEM_PCI_HOLE)))
 		return;
 
 	/*
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 989afcbe642f..de1faa64a8ef 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1081,6 +1081,9 @@ __gfn_to_memslot(struct kvm_memslots *slots, gfn_t gfn)
 static inline unsigned long
 __gfn_to_hva_memslot(struct kvm_memory_slot *slot, gfn_t gfn)
 {
+	/* Should never be called with a KVM_MEM_PCI_HOLE slot */
+	BUG_ON(!slot->userspace_addr);
+
 	return slot->userspace_addr + (gfn - slot->base_gfn) * PAGE_SIZE;
 }
 
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index f6d86033c4fa..b56137f4f96f 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -109,6 +109,7 @@ struct kvm_userspace_memory_region {
  */
 #define KVM_MEM_LOG_DIRTY_PAGES	(1UL << 0)
 #define KVM_MEM_READONLY	(1UL << 1)
+#define KVM_MEM_PCI_HOLE		(1UL << 2)
 
 /* for KVM_IRQ_LINE */
 struct kvm_irq_level {
@@ -1035,6 +1036,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_LAST_CPU 184
 #define KVM_CAP_SMALLER_MAXPHYADDR 185
 #define KVM_CAP_S390_DIAG318 186
+#define KVM_CAP_PCI_HOLE_MEM 187
 
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

