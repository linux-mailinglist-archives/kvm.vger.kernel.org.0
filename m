Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3535A1D38D4
	for <lists+kvm@lfdr.de>; Thu, 14 May 2020 20:06:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726950AbgENSGC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 May 2020 14:06:02 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:54487 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726797AbgENSGB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 May 2020 14:06:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589479559;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KdRY9RlwrkuLwO5Dr+/VN1ESkHdrDhoUXGU3cG5mbnw=;
        b=LrNsg/xTYT+m7nkV14/YWmYVhO+LStIPR2CGilxwsg6l8wHetXRd/jJ7EKIyKmho362PKt
        KVy/EzYc25Dwwb3IhOHjEntQ1B7KCAUAdFvshqfhj0/vIXrShdvV5wMJh7Oxe48dlwzUH2
        CcgwRHdpkxYKjZYTLw8sCljciWrtlMI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-286-EkZBBeFYMzqgWbkH570K7Q-1; Thu, 14 May 2020 14:05:55 -0400
X-MC-Unique: EkZBBeFYMzqgWbkH570K7Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 114B08018A7;
        Thu, 14 May 2020 18:05:54 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.178])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 302755D9CA;
        Thu, 14 May 2020 18:05:50 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Michael Tsirkin <mst@redhat.com>,
        Julia Suvorova <jsuvorov@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, x86@kernel.org
Subject: [PATCH RFC 2/5] KVM: x86: introduce KVM_MEM_ALLONES memory
Date:   Thu, 14 May 2020 20:05:37 +0200
Message-Id: <20200514180540.52407-3-vkuznets@redhat.com>
In-Reply-To: <20200514180540.52407-1-vkuznets@redhat.com>
References: <20200514180540.52407-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PCIe config space can (depending on the configuration) be quite big but
usually is sparsely populated. Guest may scan it by accessing individual
device's page which, when device is missing, is supposed to have 'pci
holes' semantics: reads return '0xff' and writes get discarded. Currently,
userspace has to allocate real memory for these holes and fill them with
'0xff'. Moreover, different VMs usually require different memory.

The idea behind the feature introduced by this patch is: let's have a
single read-only page filled with '0xff' in KVM and map it to all such
PCI holes in all VMs. This will free userspace of obligation to allocate
real memory. Later, this will also allow us to speed up access to these
holes as we can aggressively map the whole slot upon first fault.

Suggested-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 Documentation/virt/kvm/api.rst  | 22 ++++++---
 arch/x86/include/uapi/asm/kvm.h |  1 +
 arch/x86/kvm/x86.c              |  9 ++--
 include/linux/kvm_host.h        | 15 ++++++-
 include/uapi/linux/kvm.h        |  2 +
 virt/kvm/kvm_main.c             | 79 +++++++++++++++++++++++++++++++--
 6 files changed, 113 insertions(+), 15 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index d871dacb984e..2b87d588a7e0 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -1236,7 +1236,8 @@ yet and must be cleared on entry.
 
   /* for kvm_memory_region::flags */
   #define KVM_MEM_LOG_DIRTY_PAGES	(1UL << 0)
-  #define KVM_MEM_READONLY	(1UL << 1)
+  #define KVM_MEM_READONLY		(1UL << 1)
+  #define KVM_MEM_ALLONES		(1UL << 2)
 
 This ioctl allows the user to create, modify or delete a guest physical
 memory slot.  Bits 0-15 of "slot" specify the slot id and this value
@@ -1264,12 +1265,19 @@ It is recommended that the lower 21 bits of guest_phys_addr and userspace_addr
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
+- KVM_MEM_ALLONES can be set, if KVM_CAP_ALLONES_MEM capability allows it,
+  to create a new virtual read-only slot which will always return '0xff' when
+  guest reads from it. 'userspace_addr' has to be set to NULL, KVM maps all
+  pages in such slots to a single readonly page. This flag is mutually exclusive
+  with KVM_MEM_LOG_DIRTY_PAGES/KVM_MEM_READONLY. All writes to this memory will be
+  posted to userspace as KVM_EXIT_MMIO exits.
 
 When the KVM_CAP_SYNC_MMU capability is available, changes in the backing of
 the memory region are automatically reflected into the guest.  For example, an
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 3f3f780c8c65..97ad1d90636e 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -48,6 +48,7 @@
 #define __KVM_HAVE_XSAVE
 #define __KVM_HAVE_XCRS
 #define __KVM_HAVE_READONLY_MEM
+#define __KVM_HAVE_ALLONES_MEM
 
 /* Architectural interrupt line count. */
 #define KVM_NR_INTERRUPTS 256
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8c0b77ac8dc6..2c0fcab8ea1e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3389,6 +3389,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_GET_MSR_FEATURES:
 	case KVM_CAP_MSR_PLATFORM_INFO:
 	case KVM_CAP_EXCEPTION_PAYLOAD:
+	case KVM_CAP_ALLONES_MEM:
 		r = 1;
 		break;
 	case KVM_CAP_SYNC_REGS:
@@ -9962,9 +9963,11 @@ static int kvm_alloc_memslot_metadata(struct kvm_memory_slot *slot,
 		ugfn = slot->userspace_addr >> PAGE_SHIFT;
 		/*
 		 * If the gfn and userspace address are not aligned wrt each
-		 * other, disable large page support for this slot.
+		 * other, disable large page support for this slot. Also,
+		 * disable large page support for KVM_MEM_ALLONES slots.
 		 */
-		if ((slot->base_gfn ^ ugfn) & (KVM_PAGES_PER_HPAGE(level) - 1)) {
+		if (slot->flags & KVM_MEM_ALLONES || ((slot->base_gfn ^ ugfn) &
+				      (KVM_PAGES_PER_HPAGE(level) - 1))) {
 			unsigned long j;
 
 			for (j = 0; j < lpages; ++j)
@@ -10021,7 +10024,7 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
 				     struct kvm_memory_slot *new)
 {
 	/* Still write protect RO slot */
-	if (new->flags & KVM_MEM_READONLY) {
+	if (new->flags & KVM_MEM_READONLY || new->flags & KVM_MEM_ALLONES) {
 		kvm_mmu_slot_remove_write_access(kvm, new, PT_PAGE_TABLE_LEVEL);
 		return;
 	}
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 3cc6ccbb1183..47a01ebe019d 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1064,10 +1064,23 @@ __gfn_to_memslot(struct kvm_memslots *slots, gfn_t gfn)
 	return search_memslots(slots, gfn);
 }
 
+#ifdef __KVM_HAVE_ALLONES_MEM
+extern void *kvm_allones_pg;
+#endif
+
 static inline unsigned long
 __gfn_to_hva_memslot(struct kvm_memory_slot *slot, gfn_t gfn)
 {
-	return slot->userspace_addr + (gfn - slot->base_gfn) * PAGE_SIZE;
+	if (likely(!(slot->flags & KVM_MEM_ALLONES))) {
+		return slot->userspace_addr +
+			(gfn - slot->base_gfn) * PAGE_SIZE;
+	} else {
+#ifdef __KVM_HAVE_ALLONES_MEM
+		return (unsigned long)kvm_allones_pg;
+#else
+		BUG();
+#endif
+	}
 }
 
 static inline int memslot_id(struct kvm *kvm, gfn_t gfn)
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index ac9eba0289d1..2d28890d6c7d 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -109,6 +109,7 @@ struct kvm_userspace_memory_region {
  */
 #define KVM_MEM_LOG_DIRTY_PAGES	(1UL << 0)
 #define KVM_MEM_READONLY	(1UL << 1)
+#define KVM_MEM_ALLONES		(1UL << 2)
 
 /* for KVM_IRQ_LINE */
 struct kvm_irq_level {
@@ -1018,6 +1019,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_S390_PROTECTED 180
 #define KVM_CAP_PPC_SECURE_GUEST 181
 #define KVM_CAP_HALT_POLL 182
+#define KVM_CAP_ALLONES_MEM 183
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 892ea0b9087e..95e645c6efbc 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -155,6 +155,11 @@ static void kvm_uevent_notify_change(unsigned int type, struct kvm *kvm);
 static unsigned long long kvm_createvm_count;
 static unsigned long long kvm_active_vms;
 
+#ifdef __KVM_HAVE_ALLONES_MEM
+void *kvm_allones_pg;
+EXPORT_SYMBOL_GPL(kvm_allones_pg);
+#endif
+
 __weak int kvm_arch_mmu_notifier_invalidate_range(struct kvm *kvm,
 		unsigned long start, unsigned long end, bool blockable)
 {
@@ -1039,6 +1044,10 @@ static int check_memory_region_flags(const struct kvm_userspace_memory_region *m
 	valid_flags |= KVM_MEM_READONLY;
 #endif
 
+#ifdef __KVM_HAVE_ALLONES_MEM
+	valid_flags |= KVM_MEM_ALLONES;
+#endif
+
 	if (mem->flags & ~valid_flags)
 		return -EINVAL;
 
@@ -1216,8 +1225,24 @@ int __kvm_set_memory_region(struct kvm *kvm,
 		return -EINVAL;
 	if (mem->guest_phys_addr & (PAGE_SIZE - 1))
 		return -EINVAL;
-	/* We can read the guest memory with __xxx_user() later on. */
-	if ((id < KVM_USER_MEM_SLOTS) &&
+
+	/* KVM_MEM_ALLONES doesn't need userspace_addr */
+	if ((mem->flags & KVM_MEM_ALLONES) && mem->userspace_addr)
+		return -EINVAL;
+
+	/*
+	 * KVM_MEM_ALLONES is mutually exclusive with KVM_MEM_READONLY/
+	 * KVM_MEM_LOG_DIRTY_PAGES.
+	 */
+	if ((mem->flags & KVM_MEM_ALLONES) &&
+	    (mem->flags & (KVM_MEM_READONLY | KVM_MEM_LOG_DIRTY_PAGES)))
+		return -EINVAL;
+
+	/*
+	 * We can read the guest memory with __xxx_user() later on.
+	 * KVM_MEM_ALLONES slots don't have any userspace memory attached.
+	 */
+	if ((id < KVM_USER_MEM_SLOTS) && !(mem->flags & KVM_MEM_ALLONES) &&
 	    ((mem->userspace_addr & (PAGE_SIZE - 1)) ||
 	     !access_ok((void __user *)(unsigned long)mem->userspace_addr,
 			mem->memory_size)))
@@ -1920,7 +1945,24 @@ kvm_pfn_t __gfn_to_pfn_memslot(struct kvm_memory_slot *slot, gfn_t gfn,
 			       bool atomic, bool *async, bool write_fault,
 			       bool *writable)
 {
-	unsigned long addr = __gfn_to_hva_many(slot, gfn, NULL, write_fault);
+	unsigned long addr;
+
+#ifdef __KVM_HAVE_ALLONES_MEM
+	if (unlikely(slot->flags & KVM_MEM_ALLONES)) {
+		if (writable)
+			*writable = false;
+		if (async)
+			*async = false;
+		if (!write_fault) {
+			addr = vmalloc_to_pfn(kvm_allones_pg);
+			kvm_get_pfn(addr);
+			return addr;
+		} else {
+			return KVM_PFN_NOSLOT;
+		}
+	}
+#endif
+	addr = __gfn_to_hva_many(slot, gfn, NULL, write_fault);
 
 	if (addr == KVM_HVA_ERR_RO_BAD) {
 		if (writable)
@@ -4671,6 +4713,9 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
 	struct kvm_cpu_compat_check c;
 	int r;
 	int cpu;
+#ifdef __KVM_HAVE_ALLONES_MEM
+	struct page *page;
+#endif
 
 	r = kvm_arch_init(opaque);
 	if (r)
@@ -4728,6 +4773,18 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
 	if (r)
 		goto out_free_vcpu_cache;
 
+#ifdef __KVM_HAVE_ALLONES_MEM
+	page = alloc_page(GFP_KERNEL);
+	if (!page)
+		goto out_async_pf_deinit;
+	memset(page_address(page), 0xff, PAGE_SIZE);
+	kvm_allones_pg = vmap(&page, 1, VM_MAP, PAGE_KERNEL_RO);
+	if (!kvm_allones_pg) {
+		__free_page(page);
+		goto out_async_pf_deinit;
+	}
+#endif
+
 	kvm_chardev_ops.owner = module;
 	kvm_vm_fops.owner = module;
 	kvm_vcpu_fops.owner = module;
@@ -4735,7 +4792,7 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
 	r = misc_register(&kvm_dev);
 	if (r) {
 		pr_err("kvm: misc device register failed\n");
-		goto out_async_pf_deinit;
+		goto out_free_allones_page;
 	}
 
 	register_syscore_ops(&kvm_syscore_ops);
@@ -4750,6 +4807,12 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
 
 	return 0;
 
+out_free_allones_page:
+#ifdef __KVM_HAVE_ALLONES_MEM
+	page = vmalloc_to_page(kvm_allones_pg);
+	vunmap(kvm_allones_pg);
+	__free_page(page);
+#endif
 out_async_pf_deinit:
 	kvm_async_pf_deinit();
 out_free_vcpu_cache:
@@ -4771,8 +4834,16 @@ EXPORT_SYMBOL_GPL(kvm_init);
 
 void kvm_exit(void)
 {
+#ifdef __KVM_HAVE_ALLONES_MEM
+	struct page *page;
+#endif
 	debugfs_remove_recursive(kvm_debugfs_dir);
 	misc_deregister(&kvm_dev);
+#ifdef __KVM_HAVE_ALLONES_MEM
+	page = vmalloc_to_page(kvm_allones_pg);
+	vunmap(kvm_allones_pg);
+	__free_page(page);
+#endif
 	kmem_cache_destroy(kvm_vcpu_cache);
 	kvm_async_pf_deinit();
 	unregister_syscore_ops(&kvm_syscore_ops);
-- 
2.25.4

