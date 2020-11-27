Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 617B92C69DC
	for <lists+kvm@lfdr.de>; Fri, 27 Nov 2020 17:45:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731984AbgK0Qm3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Nov 2020 11:42:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731911AbgK0QmU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Nov 2020 11:42:20 -0500
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 520CAC0613D1
        for <kvm@vger.kernel.org>; Fri, 27 Nov 2020 08:42:20 -0800 (PST)
Received: by mail-wr1-x444.google.com with SMTP id u12so6231911wrt.0
        for <kvm@vger.kernel.org>; Fri, 27 Nov 2020 08:42:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3lnP38KG8A1LYh8v2GDNGvx8wPBJZF5Ara+ZJGh4/qc=;
        b=Csi8ZNX8RwNnU8LIQCxMM/vhvOmiVOUfzLolBjW93b/0Ev61Hel+fH6DUNNbUoXIsN
         m2xOyrQkp7031+NnywTEwaU8fHW7SR4mzR31n+JgrbhbWoPF2SmTrKypWIv1gJ3PdmPO
         GCaxG6O/lC6nFDbGj3eoBmR7DWwk00wEtf1uI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3lnP38KG8A1LYh8v2GDNGvx8wPBJZF5Ara+ZJGh4/qc=;
        b=OOIoHGxwVDh5MKzj70bL2py/zxhmS7wJKUxOmWDRxqilvexRYsoyzp+GZybKikpaIa
         7EgrmZvKh1008VQZv0nAOntWG9eYPzzVaDnb8yO0+r5McXzFlHwFhOeC5cxyevam2eFJ
         WkfD7KBenoRXXkW7UNen85Z/9rmBK6sOuRaMuMtJwHVdgO+rrjpZseGeakpjlXci1I28
         +ZdOoGFqm2rZtHfWfYOCP5LtOvvNYXVMzgbPS5/I6D5aUDftrFSqv+8zWCvUEn1OMaSG
         5duQCwGn9I/Y1TCp1gM/h/E+oe0Z+ioDNVDXUgaDNWD7zw0Uj0XEJJecrEKZ515IGkEH
         s8/w==
X-Gm-Message-State: AOAM533BaQDf/y4DMRok/Fv/M/BDQ/DKC5wrOcypxcQB6wEC31pMBuwE
        YPVgtLElJ/o0q1SEdn17NEn9UQ==
X-Google-Smtp-Source: ABdhPJw7dxM001AIWI/7kkdx/f4V+l1kW8lYPInhXdvuY1ifUPn3D28yfeu5k/6cM0pkiAew1Q0CJA==
X-Received: by 2002:adf:f888:: with SMTP id u8mr11470289wrp.381.1606495339093;
        Fri, 27 Nov 2020 08:42:19 -0800 (PST)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id q12sm14859078wrx.86.2020.11.27.08.42.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2020 08:42:18 -0800 (PST)
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
To:     DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Kees Cook <keescook@chromium.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Hubbard <jhubbard@nvidia.com>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
        Jan Kara <jack@suse.cz>
Subject: [PATCH v7 16/17] kvm: pass kvm argument to follow_pfn callsites
Date:   Fri, 27 Nov 2020 17:41:30 +0100
Message-Id: <20201127164131.2244124-17-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201127164131.2244124-1-daniel.vetter@ffwll.ch>
References: <20201127164131.2244124-1-daniel.vetter@ffwll.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Both Christoph Hellwig and Jason Gunthorpe suggested that usage of
follow_pfn by modules should be locked down more. To do so callers
need to be able to pass the mmu_notifier subscription corresponding
to the mm_struct to follow_pfn().

This patch does the rote work of doing that in the kvm subsystem. In
most places this is solved by passing struct kvm * down the call
stacks as an additional parameter, since that contains the
mmu_notifier.

Compile tested on all affected arch.

Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Kees Cook <keescook@chromium.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Jérôme Glisse <jglisse@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: linux-mm@kvack.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-samsung-soc@vger.kernel.org
Cc: linux-media@vger.kernel.org
Cc: kvm@vger.kernel.org
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
---
 arch/powerpc/kvm/book3s_64_mmu_hv.c    |  2 +-
 arch/powerpc/kvm/book3s_64_mmu_radix.c |  2 +-
 arch/powerpc/kvm/e500_mmu_host.c       |  2 +-
 arch/x86/kvm/mmu/mmu.c                 |  8 ++--
 include/linux/kvm_host.h               |  9 +++--
 virt/kvm/kvm_main.c                    | 52 +++++++++++++++-----------
 6 files changed, 45 insertions(+), 30 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_64_mmu_hv.c b/arch/powerpc/kvm/book3s_64_mmu_hv.c
index 38ea396a23d6..86781ff76fcb 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_hv.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_hv.c
@@ -589,7 +589,7 @@ int kvmppc_book3s_hv_page_fault(struct kvm_vcpu *vcpu,
 		write_ok = true;
 	} else {
 		/* Call KVM generic code to do the slow-path check */
-		pfn = __gfn_to_pfn_memslot(memslot, gfn, false, NULL,
+		pfn = __gfn_to_pfn_memslot(kvm, memslot, gfn, false, NULL,
 					   writing, &write_ok);
 		if (is_error_noslot_pfn(pfn))
 			return -EFAULT;
diff --git a/arch/powerpc/kvm/book3s_64_mmu_radix.c b/arch/powerpc/kvm/book3s_64_mmu_radix.c
index bb35490400e9..319a1a99153f 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_radix.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_radix.c
@@ -821,7 +821,7 @@ int kvmppc_book3s_instantiate_page(struct kvm_vcpu *vcpu,
 		unsigned long pfn;
 
 		/* Call KVM generic code to do the slow-path check */
-		pfn = __gfn_to_pfn_memslot(memslot, gfn, false, NULL,
+		pfn = __gfn_to_pfn_memslot(kvm, memslot, gfn, false, NULL,
 					   writing, upgrade_p);
 		if (is_error_noslot_pfn(pfn))
 			return -EFAULT;
diff --git a/arch/powerpc/kvm/e500_mmu_host.c b/arch/powerpc/kvm/e500_mmu_host.c
index ed0c9c43d0cf..fd2b2d363559 100644
--- a/arch/powerpc/kvm/e500_mmu_host.c
+++ b/arch/powerpc/kvm/e500_mmu_host.c
@@ -446,7 +446,7 @@ static inline int kvmppc_e500_shadow_map(struct kvmppc_vcpu_e500 *vcpu_e500,
 
 	if (likely(!pfnmap)) {
 		tsize_pages = 1UL << (tsize + 10 - PAGE_SHIFT);
-		pfn = gfn_to_pfn_memslot(slot, gfn);
+		pfn = gfn_to_pfn_memslot(kvm, slot, gfn);
 		if (is_error_noslot_pfn(pfn)) {
 			if (printk_ratelimit())
 				pr_err("%s: real page not found for gfn %lx\n",
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 5bb1939b65d8..67ada47aa722 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2679,7 +2679,7 @@ static kvm_pfn_t pte_prefetch_gfn_to_pfn(struct kvm_vcpu *vcpu, gfn_t gfn,
 	if (!slot)
 		return KVM_PFN_ERR_FAULT;
 
-	return gfn_to_pfn_memslot_atomic(slot, gfn);
+	return gfn_to_pfn_memslot_atomic(vcpu->kvm, slot, gfn);
 }
 
 static int direct_pte_prefetch_many(struct kvm_vcpu *vcpu,
@@ -3657,7 +3657,8 @@ static bool try_async_pf(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
 	}
 
 	async = false;
-	*pfn = __gfn_to_pfn_memslot(slot, gfn, false, &async, write, writable);
+	*pfn = __gfn_to_pfn_memslot(vcpu->kvm, slot, gfn,
+				    false, &async, write, writable);
 	if (!async)
 		return false; /* *pfn has correct page already */
 
@@ -3671,7 +3672,8 @@ static bool try_async_pf(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
 			return true;
 	}
 
-	*pfn = __gfn_to_pfn_memslot(slot, gfn, false, NULL, write, writable);
+	*pfn = __gfn_to_pfn_memslot(vcpu->kvm, slot, gfn,
+				    false, NULL, write, writable);
 	return false;
 }
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 7f2e2a09ebbd..864424ce6b6b 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -717,9 +717,12 @@ void kvm_set_page_accessed(struct page *page);
 kvm_pfn_t gfn_to_pfn(struct kvm *kvm, gfn_t gfn);
 kvm_pfn_t gfn_to_pfn_prot(struct kvm *kvm, gfn_t gfn, bool write_fault,
 		      bool *writable);
-kvm_pfn_t gfn_to_pfn_memslot(struct kvm_memory_slot *slot, gfn_t gfn);
-kvm_pfn_t gfn_to_pfn_memslot_atomic(struct kvm_memory_slot *slot, gfn_t gfn);
-kvm_pfn_t __gfn_to_pfn_memslot(struct kvm_memory_slot *slot, gfn_t gfn,
+kvm_pfn_t gfn_to_pfn_memslot(struct kvm *kvm,
+			     struct kvm_memory_slot *slot, gfn_t gfn);
+kvm_pfn_t gfn_to_pfn_memslot_atomic(struct kvm *kvm,
+				    struct kvm_memory_slot *slot, gfn_t gfn);
+kvm_pfn_t __gfn_to_pfn_memslot(struct kvm *kvm,
+			       struct kvm_memory_slot *slot, gfn_t gfn,
 			       bool atomic, bool *async, bool write_fault,
 			       bool *writable);
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 2541a17ff1c4..417f3d470c3e 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1883,7 +1883,7 @@ static bool vma_is_valid(struct vm_area_struct *vma, bool write_fault)
 	return true;
 }
 
-static int hva_to_pfn_remapped(struct vm_area_struct *vma,
+static int hva_to_pfn_remapped(struct kvm *kvm, struct vm_area_struct *vma,
 			       unsigned long addr, bool *async,
 			       bool write_fault, bool *writable,
 			       kvm_pfn_t *p_pfn)
@@ -1946,8 +1946,9 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
  * 2): @write_fault = false && @writable, @writable will tell the caller
  *     whether the mapping is writable.
  */
-static kvm_pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool *async,
-			bool write_fault, bool *writable)
+static kvm_pfn_t hva_to_pfn(struct kvm *kvm, unsigned long addr,
+			    bool atomic, bool *async,
+			    bool write_fault, bool *writable)
 {
 	struct vm_area_struct *vma;
 	kvm_pfn_t pfn = 0;
@@ -1979,7 +1980,8 @@ static kvm_pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool *async,
 	if (vma == NULL)
 		pfn = KVM_PFN_ERR_FAULT;
 	else if (vma->vm_flags & (VM_IO | VM_PFNMAP)) {
-		r = hva_to_pfn_remapped(vma, addr, async, write_fault, writable, &pfn);
+		r = hva_to_pfn_remapped(kvm, vma, addr,
+					async, write_fault, writable, &pfn);
 		if (r == -EAGAIN)
 			goto retry;
 		if (r < 0)
@@ -1994,7 +1996,8 @@ static kvm_pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool *async,
 	return pfn;
 }
 
-kvm_pfn_t __gfn_to_pfn_memslot(struct kvm_memory_slot *slot, gfn_t gfn,
+kvm_pfn_t __gfn_to_pfn_memslot(struct kvm *kvm,
+			       struct kvm_memory_slot *slot, gfn_t gfn,
 			       bool atomic, bool *async, bool write_fault,
 			       bool *writable)
 {
@@ -2018,7 +2021,7 @@ kvm_pfn_t __gfn_to_pfn_memslot(struct kvm_memory_slot *slot, gfn_t gfn,
 		writable = NULL;
 	}
 
-	return hva_to_pfn(addr, atomic, async, write_fault,
+	return hva_to_pfn(kvm, addr, atomic, async, write_fault,
 			  writable);
 }
 EXPORT_SYMBOL_GPL(__gfn_to_pfn_memslot);
@@ -2026,38 +2029,43 @@ EXPORT_SYMBOL_GPL(__gfn_to_pfn_memslot);
 kvm_pfn_t gfn_to_pfn_prot(struct kvm *kvm, gfn_t gfn, bool write_fault,
 		      bool *writable)
 {
-	return __gfn_to_pfn_memslot(gfn_to_memslot(kvm, gfn), gfn, false, NULL,
+	return __gfn_to_pfn_memslot(kvm, gfn_to_memslot(kvm, gfn), gfn,
+				    false, NULL,
 				    write_fault, writable);
 }
 EXPORT_SYMBOL_GPL(gfn_to_pfn_prot);
 
-kvm_pfn_t gfn_to_pfn_memslot(struct kvm_memory_slot *slot, gfn_t gfn)
+kvm_pfn_t gfn_to_pfn_memslot(struct kvm *kvm,
+			     struct kvm_memory_slot *slot, gfn_t gfn)
 {
-	return __gfn_to_pfn_memslot(slot, gfn, false, NULL, true, NULL);
+	return __gfn_to_pfn_memslot(kvm, slot, gfn, false, NULL, true, NULL);
 }
 EXPORT_SYMBOL_GPL(gfn_to_pfn_memslot);
 
-kvm_pfn_t gfn_to_pfn_memslot_atomic(struct kvm_memory_slot *slot, gfn_t gfn)
+kvm_pfn_t gfn_to_pfn_memslot_atomic(struct kvm *kvm,
+				    struct kvm_memory_slot *slot, gfn_t gfn)
 {
-	return __gfn_to_pfn_memslot(slot, gfn, true, NULL, true, NULL);
+	return __gfn_to_pfn_memslot(kvm, slot, gfn, true, NULL, true, NULL);
 }
 EXPORT_SYMBOL_GPL(gfn_to_pfn_memslot_atomic);
 
 kvm_pfn_t kvm_vcpu_gfn_to_pfn_atomic(struct kvm_vcpu *vcpu, gfn_t gfn)
 {
-	return gfn_to_pfn_memslot_atomic(kvm_vcpu_gfn_to_memslot(vcpu, gfn), gfn);
+	return gfn_to_pfn_memslot_atomic(vcpu->kvm,
+					 kvm_vcpu_gfn_to_memslot(vcpu, gfn), gfn);
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_gfn_to_pfn_atomic);
 
 kvm_pfn_t gfn_to_pfn(struct kvm *kvm, gfn_t gfn)
 {
-	return gfn_to_pfn_memslot(gfn_to_memslot(kvm, gfn), gfn);
+	return gfn_to_pfn_memslot(kvm, gfn_to_memslot(kvm, gfn), gfn);
 }
 EXPORT_SYMBOL_GPL(gfn_to_pfn);
 
 kvm_pfn_t kvm_vcpu_gfn_to_pfn(struct kvm_vcpu *vcpu, gfn_t gfn)
 {
-	return gfn_to_pfn_memslot(kvm_vcpu_gfn_to_memslot(vcpu, gfn), gfn);
+	return gfn_to_pfn_memslot(vcpu->kvm,
+				  kvm_vcpu_gfn_to_memslot(vcpu, gfn), gfn);
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_gfn_to_pfn);
 
@@ -2115,18 +2123,20 @@ void kvm_release_pfn(kvm_pfn_t pfn, bool dirty, struct gfn_to_pfn_cache *cache)
 		kvm_release_pfn_clean(pfn);
 }
 
-static void kvm_cache_gfn_to_pfn(struct kvm_memory_slot *slot, gfn_t gfn,
+static void kvm_cache_gfn_to_pfn(struct kvm *kvm,
+				 struct kvm_memory_slot *slot, gfn_t gfn,
 				 struct gfn_to_pfn_cache *cache, u64 gen)
 {
 	kvm_release_pfn(cache->pfn, cache->dirty, cache);
 
-	cache->pfn = gfn_to_pfn_memslot(slot, gfn);
+	cache->pfn = gfn_to_pfn_memslot(kvm, slot, gfn);
 	cache->gfn = gfn;
 	cache->dirty = false;
 	cache->generation = gen;
 }
 
-static int __kvm_map_gfn(struct kvm_memslots *slots, gfn_t gfn,
+static int __kvm_map_gfn(struct kvm *kvm,
+			 struct kvm_memslots *slots, gfn_t gfn,
 			 struct kvm_host_map *map,
 			 struct gfn_to_pfn_cache *cache,
 			 bool atomic)
@@ -2145,13 +2155,13 @@ static int __kvm_map_gfn(struct kvm_memslots *slots, gfn_t gfn,
 			cache->generation != gen) {
 			if (atomic)
 				return -EAGAIN;
-			kvm_cache_gfn_to_pfn(slot, gfn, cache, gen);
+			kvm_cache_gfn_to_pfn(kvm, slot, gfn, cache, gen);
 		}
 		pfn = cache->pfn;
 	} else {
 		if (atomic)
 			return -EAGAIN;
-		pfn = gfn_to_pfn_memslot(slot, gfn);
+		pfn = gfn_to_pfn_memslot(kvm, slot, gfn);
 	}
 	if (is_error_noslot_pfn(pfn))
 		return -EINVAL;
@@ -2184,14 +2194,14 @@ static int __kvm_map_gfn(struct kvm_memslots *slots, gfn_t gfn,
 int kvm_map_gfn(struct kvm_vcpu *vcpu, gfn_t gfn, struct kvm_host_map *map,
 		struct gfn_to_pfn_cache *cache, bool atomic)
 {
-	return __kvm_map_gfn(kvm_memslots(vcpu->kvm), gfn, map,
+	return __kvm_map_gfn(vcpu->kvm, kvm_memslots(vcpu->kvm), gfn, map,
 			cache, atomic);
 }
 EXPORT_SYMBOL_GPL(kvm_map_gfn);
 
 int kvm_vcpu_map(struct kvm_vcpu *vcpu, gfn_t gfn, struct kvm_host_map *map)
 {
-	return __kvm_map_gfn(kvm_vcpu_memslots(vcpu), gfn, map,
+	return __kvm_map_gfn(vcpu->kvm, kvm_vcpu_memslots(vcpu), gfn, map,
 		NULL, false);
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_map);
-- 
2.29.2

