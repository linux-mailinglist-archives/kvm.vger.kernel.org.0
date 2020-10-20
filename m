Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CA0C2934C8
	for <lists+kvm@lfdr.de>; Tue, 20 Oct 2020 08:19:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403916AbgJTGTl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Oct 2020 02:19:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403899AbgJTGTP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Oct 2020 02:19:15 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95A79C0613D6
        for <kvm@vger.kernel.org>; Mon, 19 Oct 2020 23:19:13 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id m16so739600ljo.6
        for <kvm@vger.kernel.org>; Mon, 19 Oct 2020 23:19:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PNKc4RJ1Oy7aH+IpRJ4FjlsZeZXXYZyCX4/DKrWCkeg=;
        b=z9xv6k6sZbLfbo5Th3nyLshepFClZRI0+N5oprtMQmWqhnSeoh90hc68/VX1S+scUd
         GVZs5ClxNa+3LIz6eS1vgrrEdz0o6bOJdOy1QkBv0kFX+Ewh5FpCDJ+5QIrL2UKh6kxW
         Wz4XxkSFG3/2Q66q6sm5t5N8x2+E8Pv7J7+Ut6XPcq7kMKGrQMXbO28evVleAOLaQkcX
         TP2BV3yE+oXe59sGq4UF5BTuVTLfV/uJ25VWM00A+TQrxA1Ts7lhKOQLetxJzOU9UNzC
         SrpBMhLqFFvnQbKe/Do66wd3KStwZaWiWW14qfqtN649MM1RCLVDfAM8C/ch4Ptwyfsx
         +PSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PNKc4RJ1Oy7aH+IpRJ4FjlsZeZXXYZyCX4/DKrWCkeg=;
        b=qbbEHdw0HMzdzksPBwEsM7chj14LJ2vlQfsXtB5d14K99+tbhhGWF9Vl7AtfbUenRw
         lI9JtAh7tCkcU+4XK9qVq7Vzxnw2zkBafRD8jxszoAtR8XZjkIDKHPOlDK/v2/KC+/sh
         l8lOQNiyGYM5KMnBuJZHQ37vQng6nUSN0XOZbKxPnDLp0YOqHjXkb11VXvQLuUwSBdsr
         cfUpWeMynRcx3fchJUzmVVJulaeMq7LMmIL0feEpStfWdSQjcq+j5tnohloZ6aXU7EKI
         SvJQTBHdEispBuU4TK4knWENs/jrGQUfrgJuzQLzQALa2vbBaeoYRaH9nVtOiEa+76Po
         vPtA==
X-Gm-Message-State: AOAM532igQpB+j5XaUrgI95+uRcu/a1VIWp8nyK4jx9smCX1fKEOAfRa
        4oE8WGQKEx99C6+qbL1xeCaZDQ==
X-Google-Smtp-Source: ABdhPJzcLWyJrdYvk3jPu4M19U2PUZGr+x4SGEcbncAnbwFbLzZv2JMatoIbShM+kdIpd+z7iI19OA==
X-Received: by 2002:a05:651c:102a:: with SMTP id w10mr471257ljm.64.1603174752041;
        Mon, 19 Oct 2020 23:19:12 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id u28sm136394lfi.182.2020.10.19.23.19.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2020 23:19:09 -0700 (PDT)
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
X-Google-Original-From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Received: by box.localdomain (Postfix, from userid 1000)
        id 2CAED102F6D; Tue, 20 Oct 2020 09:19:02 +0300 (+03)
To:     Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     David Rientjes <rientjes@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Will Drewry <wad@chromium.org>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        Liran Alon <liran.alon@oracle.com>,
        Mike Rapoport <rppt@kernel.org>, x86@kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [RFCv2 14/16] KVM: Handle protected memory in __kvm_map_gfn()/__kvm_unmap_gfn()
Date:   Tue, 20 Oct 2020 09:18:57 +0300
Message-Id: <20201020061859.18385-15-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201020061859.18385-1-kirill.shutemov@linux.intel.com>
References: <20201020061859.18385-1-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We cannot access protected pages directly. Use ioremap() to
create a temporary mapping of the page. The mapping is destroyed
on __kvm_unmap_gfn().

The new interface gfn_to_pfn_memslot_protected() is used to detect if
the page is protected.

ioremap_cache_force() is a hack to bypass IORES_MAP_SYSTEM_RAM check in
the x86 ioremap code. We need a better solution.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 arch/powerpc/kvm/book3s_64_mmu_hv.c    |  2 +-
 arch/powerpc/kvm/book3s_64_mmu_radix.c |  2 +-
 arch/x86/include/asm/io.h              |  2 +
 arch/x86/include/asm/pgtable_types.h   |  1 +
 arch/x86/kvm/mmu/mmu.c                 |  6 ++-
 arch/x86/mm/ioremap.c                  | 16 ++++++--
 include/linux/kvm_host.h               |  3 +-
 include/linux/kvm_types.h              |  1 +
 virt/kvm/kvm_main.c                    | 52 +++++++++++++++++++-------
 9 files changed, 63 insertions(+), 22 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_64_mmu_hv.c b/arch/powerpc/kvm/book3s_64_mmu_hv.c
index 38ea396a23d6..8e06cd3f759c 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_hv.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_hv.c
@@ -590,7 +590,7 @@ int kvmppc_book3s_hv_page_fault(struct kvm_vcpu *vcpu,
 	} else {
 		/* Call KVM generic code to do the slow-path check */
 		pfn = __gfn_to_pfn_memslot(memslot, gfn, false, NULL,
-					   writing, &write_ok);
+					   writing, &write_ok, NULL);
 		if (is_error_noslot_pfn(pfn))
 			return -EFAULT;
 		page = NULL;
diff --git a/arch/powerpc/kvm/book3s_64_mmu_radix.c b/arch/powerpc/kvm/book3s_64_mmu_radix.c
index 22a677b18695..6fd4e3f9b66a 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_radix.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_radix.c
@@ -822,7 +822,7 @@ int kvmppc_book3s_instantiate_page(struct kvm_vcpu *vcpu,
 
 		/* Call KVM generic code to do the slow-path check */
 		pfn = __gfn_to_pfn_memslot(memslot, gfn, false, NULL,
-					   writing, upgrade_p);
+					   writing, upgrade_p, NULL);
 		if (is_error_noslot_pfn(pfn))
 			return -EFAULT;
 		page = NULL;
diff --git a/arch/x86/include/asm/io.h b/arch/x86/include/asm/io.h
index c58d52fd7bf2..a3e1bfad1026 100644
--- a/arch/x86/include/asm/io.h
+++ b/arch/x86/include/asm/io.h
@@ -184,6 +184,8 @@ extern void __iomem *ioremap_uc(resource_size_t offset, unsigned long size);
 #define ioremap_uc ioremap_uc
 extern void __iomem *ioremap_cache(resource_size_t offset, unsigned long size);
 #define ioremap_cache ioremap_cache
+extern void __iomem *ioremap_cache_force(resource_size_t offset, unsigned long size);
+#define ioremap_cache_force ioremap_cache_force
 extern void __iomem *ioremap_prot(resource_size_t offset, unsigned long size, unsigned long prot_val);
 #define ioremap_prot ioremap_prot
 extern void __iomem *ioremap_encrypted(resource_size_t phys_addr, unsigned long size);
diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
index 816b31c68550..4c16a9583786 100644
--- a/arch/x86/include/asm/pgtable_types.h
+++ b/arch/x86/include/asm/pgtable_types.h
@@ -147,6 +147,7 @@ enum page_cache_mode {
 	_PAGE_CACHE_MODE_UC       = 3,
 	_PAGE_CACHE_MODE_WT       = 4,
 	_PAGE_CACHE_MODE_WP       = 5,
+	_PAGE_CACHE_MODE_WB_FORCE = 6,
 
 	_PAGE_CACHE_MODE_NUM      = 8
 };
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 71aa3da2a0b7..162cb285b87b 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4058,7 +4058,8 @@ static bool try_async_pf(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
 	}
 
 	async = false;
-	*pfn = __gfn_to_pfn_memslot(slot, gfn, false, &async, write, writable);
+	*pfn = __gfn_to_pfn_memslot(slot, gfn, false, &async, write, writable,
+				    NULL);
 	if (!async)
 		return false; /* *pfn has correct page already */
 
@@ -4072,7 +4073,8 @@ static bool try_async_pf(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
 			return true;
 	}
 
-	*pfn = __gfn_to_pfn_memslot(slot, gfn, false, NULL, write, writable);
+	*pfn = __gfn_to_pfn_memslot(slot, gfn, false, NULL, write, writable,
+				    NULL);
 	return false;
 }
 
diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 9e5ccc56f8e0..4409785e294c 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -202,9 +202,12 @@ __ioremap_caller(resource_size_t phys_addr, unsigned long size,
 	__ioremap_check_mem(phys_addr, size, &io_desc);
 
 	/*
-	 * Don't allow anybody to remap normal RAM that we're using..
+	 * Don't allow anybody to remap normal RAM that we're using, unless
+	 * _PAGE_CACHE_MODE_WB_FORCE is used.
 	 */
-	if (io_desc.flags & IORES_MAP_SYSTEM_RAM) {
+	if (pcm == _PAGE_CACHE_MODE_WB_FORCE) {
+	    pcm = _PAGE_CACHE_MODE_WB;
+	} else if (io_desc.flags & IORES_MAP_SYSTEM_RAM) {
 		WARN_ONCE(1, "ioremap on RAM at %pa - %pa\n",
 			  &phys_addr, &last_addr);
 		return NULL;
@@ -419,6 +422,13 @@ void __iomem *ioremap_cache(resource_size_t phys_addr, unsigned long size)
 }
 EXPORT_SYMBOL(ioremap_cache);
 
+void __iomem *ioremap_cache_force(resource_size_t phys_addr, unsigned long size)
+{
+	return __ioremap_caller(phys_addr, size, _PAGE_CACHE_MODE_WB_FORCE,
+				__builtin_return_address(0), false);
+}
+EXPORT_SYMBOL(ioremap_cache_force);
+
 void __iomem *ioremap_prot(resource_size_t phys_addr, unsigned long size,
 				unsigned long prot_val)
 {
@@ -467,7 +477,7 @@ void iounmap(volatile void __iomem *addr)
 	p = find_vm_area((void __force *)addr);
 
 	if (!p) {
-		printk(KERN_ERR "iounmap: bad address %p\n", addr);
+		printk(KERN_ERR "iounmap: bad address %px\n", addr);
 		dump_stack();
 		return;
 	}
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 6655e8da4555..0d5f3885747b 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -238,6 +238,7 @@ struct kvm_host_map {
 	void *hva;
 	kvm_pfn_t pfn;
 	kvm_pfn_t gfn;
+	bool protected;
 };
 
 /*
@@ -725,7 +726,7 @@ kvm_pfn_t gfn_to_pfn_memslot(struct kvm_memory_slot *slot, gfn_t gfn);
 kvm_pfn_t gfn_to_pfn_memslot_atomic(struct kvm_memory_slot *slot, gfn_t gfn);
 kvm_pfn_t __gfn_to_pfn_memslot(struct kvm_memory_slot *slot, gfn_t gfn,
 			       bool atomic, bool *async, bool write_fault,
-			       bool *writable);
+			       bool *writable, bool *protected);
 
 void kvm_release_pfn_clean(kvm_pfn_t pfn);
 void kvm_release_pfn_dirty(kvm_pfn_t pfn);
diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
index a7580f69dda0..0a8c6426b4f4 100644
--- a/include/linux/kvm_types.h
+++ b/include/linux/kvm_types.h
@@ -58,6 +58,7 @@ struct gfn_to_pfn_cache {
 	gfn_t gfn;
 	kvm_pfn_t pfn;
 	bool dirty;
+	bool protected;
 };
 
 #ifdef KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 9b569b78874a..7c2c764c28c5 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1852,9 +1852,10 @@ static bool hva_to_pfn_fast(unsigned long addr, bool write_fault,
  * 1 indicates success, -errno is returned if error is detected.
  */
 static int hva_to_pfn_slow(unsigned long addr, bool *async, bool write_fault,
-			   bool *writable, kvm_pfn_t *pfn)
+			   bool *writable, bool *protected, kvm_pfn_t *pfn)
 {
 	unsigned int flags = FOLL_HWPOISON | FOLL_KVM;
+	struct vm_area_struct *vma;
 	struct page *page;
 	int npages = 0;
 
@@ -1868,9 +1869,15 @@ static int hva_to_pfn_slow(unsigned long addr, bool *async, bool write_fault,
 	if (async)
 		flags |= FOLL_NOWAIT;
 
-	npages = get_user_pages_unlocked(addr, 1, &page, flags);
-	if (npages != 1)
+	mmap_read_lock(current->mm);
+	npages = get_user_pages(addr, 1, flags, &page, &vma);
+	if (npages != 1) {
+		mmap_read_unlock(current->mm);
 		return npages;
+	}
+	if (protected)
+		*protected = vma_is_kvm_protected(vma);
+	mmap_read_unlock(current->mm);
 
 	/* map read fault as writable if possible */
 	if (unlikely(!write_fault) && writable) {
@@ -1961,7 +1968,7 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
  *     whether the mapping is writable.
  */
 static kvm_pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool *async,
-			bool write_fault, bool *writable)
+			bool write_fault, bool *writable, bool *protected)
 {
 	struct vm_area_struct *vma;
 	kvm_pfn_t pfn = 0;
@@ -1976,7 +1983,8 @@ static kvm_pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool *async,
 	if (atomic)
 		return KVM_PFN_ERR_FAULT;
 
-	npages = hva_to_pfn_slow(addr, async, write_fault, writable, &pfn);
+	npages = hva_to_pfn_slow(addr, async, write_fault, writable, protected,
+				 &pfn);
 	if (npages == 1)
 		return pfn;
 
@@ -2010,7 +2018,7 @@ static kvm_pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool *async,
 
 kvm_pfn_t __gfn_to_pfn_memslot(struct kvm_memory_slot *slot, gfn_t gfn,
 			       bool atomic, bool *async, bool write_fault,
-			       bool *writable)
+			       bool *writable, bool *protected)
 {
 	unsigned long addr = __gfn_to_hva_many(slot, gfn, NULL, write_fault);
 
@@ -2033,7 +2041,7 @@ kvm_pfn_t __gfn_to_pfn_memslot(struct kvm_memory_slot *slot, gfn_t gfn,
 	}
 
 	return hva_to_pfn(addr, atomic, async, write_fault,
-			  writable);
+			  writable, protected);
 }
 EXPORT_SYMBOL_GPL(__gfn_to_pfn_memslot);
 
@@ -2041,19 +2049,26 @@ kvm_pfn_t gfn_to_pfn_prot(struct kvm *kvm, gfn_t gfn, bool write_fault,
 		      bool *writable)
 {
 	return __gfn_to_pfn_memslot(gfn_to_memslot(kvm, gfn), gfn, false, NULL,
-				    write_fault, writable);
+				    write_fault, writable, NULL);
 }
 EXPORT_SYMBOL_GPL(gfn_to_pfn_prot);
 
 kvm_pfn_t gfn_to_pfn_memslot(struct kvm_memory_slot *slot, gfn_t gfn)
 {
-	return __gfn_to_pfn_memslot(slot, gfn, false, NULL, true, NULL);
+	return __gfn_to_pfn_memslot(slot, gfn, false, NULL, true, NULL, NULL);
 }
 EXPORT_SYMBOL_GPL(gfn_to_pfn_memslot);
 
+static kvm_pfn_t gfn_to_pfn_memslot_protected(struct kvm_memory_slot *slot,
+					      gfn_t gfn, bool *protected)
+{
+	return __gfn_to_pfn_memslot(slot, gfn, false, NULL, true, NULL,
+				    protected);
+}
+
 kvm_pfn_t gfn_to_pfn_memslot_atomic(struct kvm_memory_slot *slot, gfn_t gfn)
 {
-	return __gfn_to_pfn_memslot(slot, gfn, true, NULL, true, NULL);
+	return __gfn_to_pfn_memslot(slot, gfn, true, NULL, true, NULL, NULL);
 }
 EXPORT_SYMBOL_GPL(gfn_to_pfn_memslot_atomic);
 
@@ -2134,7 +2149,7 @@ static void kvm_cache_gfn_to_pfn(struct kvm_memory_slot *slot, gfn_t gfn,
 {
 	kvm_release_pfn(cache->pfn, cache->dirty, cache);
 
-	cache->pfn = gfn_to_pfn_memslot(slot, gfn);
+	cache->pfn = gfn_to_pfn_memslot_protected(slot, gfn, &cache->protected);
 	cache->gfn = gfn;
 	cache->dirty = false;
 	cache->generation = gen;
@@ -2149,6 +2164,7 @@ static int __kvm_map_gfn(struct kvm_memslots *slots, gfn_t gfn,
 	void *hva = NULL;
 	struct page *page = KVM_UNMAPPED_PAGE;
 	struct kvm_memory_slot *slot = __gfn_to_memslot(slots, gfn);
+	bool protected;
 	u64 gen = slots->generation;
 
 	if (!map)
@@ -2162,15 +2178,20 @@ static int __kvm_map_gfn(struct kvm_memslots *slots, gfn_t gfn,
 			kvm_cache_gfn_to_pfn(slot, gfn, cache, gen);
 		}
 		pfn = cache->pfn;
+		protected = cache->protected;
 	} else {
 		if (atomic)
 			return -EAGAIN;
-		pfn = gfn_to_pfn_memslot(slot, gfn);
+		pfn = gfn_to_pfn_memslot_protected(slot, gfn, &protected);
 	}
 	if (is_error_noslot_pfn(pfn))
 		return -EINVAL;
 
-	if (pfn_valid(pfn)) {
+	if (protected) {
+		if (atomic)
+			return -EAGAIN;
+		hva = ioremap_cache_force(pfn_to_hpa(pfn), PAGE_SIZE);
+	} else if (pfn_valid(pfn)) {
 		page = pfn_to_page(pfn);
 		if (atomic)
 			hva = kmap_atomic(page);
@@ -2191,6 +2212,7 @@ static int __kvm_map_gfn(struct kvm_memslots *slots, gfn_t gfn,
 	map->hva = hva;
 	map->pfn = pfn;
 	map->gfn = gfn;
+	map->protected = protected;
 
 	return 0;
 }
@@ -2221,7 +2243,9 @@ static void __kvm_unmap_gfn(struct kvm_memory_slot *memslot,
 	if (!map->hva)
 		return;
 
-	if (map->page != KVM_UNMAPPED_PAGE) {
+	if (map->protected) {
+		iounmap(map->hva);
+	} else if (map->page != KVM_UNMAPPED_PAGE) {
 		if (atomic)
 			kunmap_atomic(map->hva);
 		else
-- 
2.26.2

