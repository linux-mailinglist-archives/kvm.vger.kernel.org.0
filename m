Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F4EE78697C
	for <lists+kvm@lfdr.de>; Thu, 24 Aug 2023 10:06:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239358AbjHXIGF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Aug 2023 04:06:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240393AbjHXIFj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Aug 2023 04:05:39 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 289BF1BCC
        for <kvm@vger.kernel.org>; Thu, 24 Aug 2023 01:05:02 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id d9443c01a7336-1bf078d5fb7so44391355ad.0
        for <kvm@vger.kernel.org>; Thu, 24 Aug 2023 01:05:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1692864298; x=1693469098;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AvY3BR7n7ICYAWnZQ/eSZPYmzhaqgUHnyIdR0CKyw8o=;
        b=icN/X5nU7CuPmVf3EDP69dbIgW3C5ar+dYaOd+8Um+/O02PqFVSvONoyv1PfzWzeHx
         XGX0oIDz1VPn6MkrlqnH3sf/EON0iHZeAG5rKH7d4jWCsSSL/lHE41K1imdxEycpg7uf
         yQkZvT0Xz84srBh1H+MUK3DVVjjmy0ScESnew=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692864298; x=1693469098;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AvY3BR7n7ICYAWnZQ/eSZPYmzhaqgUHnyIdR0CKyw8o=;
        b=PCta3864/MjeqkrnQfnh7SZ4ttPg+QbfiqJAy6pJXYkKKUAWFwHQncW+xiUWkFCaqr
         HorrgiIP60PUfs+6+jHhFDIoQCIITIPnRgR536uTc2nAL5Eanqubc/83UN3ADp+WCK4L
         pAyM9CQ7XWr0PbjMljIfMMtBozGb3GUjBJfmHFTRg9vxGU9Tvm5A2K5RvRMhbptYqQ7Z
         CyvO1lCSrc15OwBL6ttf9+J6+SMB4XPqJFkVdPeFlLR5t/TG81Kp+B2RXsxTMTW+iXgW
         XYrQoDRwMR4GLlX0Ikf8AfbS9chdljD1Q4K86OmHbbVKqO8a1hpTdPkAsmhmYCg4uZpI
         evfQ==
X-Gm-Message-State: AOJu0YxUac4LU7RnZluqVuGPq7DcEa6WV8gG6czLboHvYYyvTJHmQI4A
        4QEgwwiZc+MHxieSgaGmOjX8ZB1/TjJIxk6NrCA=
X-Google-Smtp-Source: AGHT+IHcwTm8GB+wpjCGaAV8ehVfoF/tH7wPenceS5dXQN6OUyjBTD0aXuUmDcuvmshnSF2y3JwxCQ==
X-Received: by 2002:a17:903:32ce:b0:1bc:56c3:ebb7 with SMTP id i14-20020a17090332ce00b001bc56c3ebb7mr15916806plr.20.1692864298341;
        Thu, 24 Aug 2023 01:04:58 -0700 (PDT)
Received: from localhost ([2401:fa00:8f:203:515:8b2a:90c3:b79e])
        by smtp.gmail.com with UTF8SMTPSA id e21-20020a170902d39500b001c0c86a5415sm610623pld.154.2023.08.24.01.04.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Aug 2023 01:04:57 -0700 (PDT)
From:   David Stevens <stevensd@chromium.org>
X-Google-Original-From: David Stevens <stevensd@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Yu Zhang <yu.c.zhang@linux.intel.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        Marc Zyngier <maz@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Peter Xu <peterx@redhat.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        kvm@vger.kernel.org, David Stevens <stevensd@chromium.org>
Subject: [PATCH v8 2/8] KVM: mmu: Introduce __kvm_follow_pfn function
Date:   Thu, 24 Aug 2023 17:04:02 +0900
Message-ID: <20230824080408.2933205-3-stevensd@google.com>
X-Mailer: git-send-email 2.42.0.rc1.204.g551eb34607-goog
In-Reply-To: <20230824080408.2933205-1-stevensd@google.com>
References: <20230824080408.2933205-1-stevensd@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Stevens <stevensd@chromium.org>

Introduce __kvm_follow_pfn, which will replace __gfn_to_pfn_memslot.
__kvm_follow_pfn refactors the old API's arguments into a struct and,
where possible, combines the boolean arguments into a single flags
argument.

Signed-off-by: David Stevens <stevensd@chromium.org>
---
 include/linux/kvm_host.h |  16 ++++
 virt/kvm/kvm_main.c      | 171 ++++++++++++++++++++++-----------------
 virt/kvm/kvm_mm.h        |   3 +-
 virt/kvm/pfncache.c      |  10 ++-
 4 files changed, 123 insertions(+), 77 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 9d3ac7720da9..59d9b5e5db33 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -97,6 +97,7 @@
 #define KVM_PFN_ERR_HWPOISON	(KVM_PFN_ERR_MASK + 1)
 #define KVM_PFN_ERR_RO_FAULT	(KVM_PFN_ERR_MASK + 2)
 #define KVM_PFN_ERR_SIGPENDING	(KVM_PFN_ERR_MASK + 3)
+#define KVM_PFN_ERR_NEEDS_IO	(KVM_PFN_ERR_MASK + 4)
 
 /*
  * error pfns indicate that the gfn is in slot but faild to
@@ -1156,6 +1157,21 @@ unsigned long gfn_to_hva_memslot_prot(struct kvm_memory_slot *slot, gfn_t gfn,
 void kvm_release_page_clean(struct page *page);
 void kvm_release_page_dirty(struct page *page);
 
+struct kvm_follow_pfn {
+	const struct kvm_memory_slot *slot;
+	gfn_t gfn;
+	unsigned int flags;
+	bool atomic;
+	/* Try to create a writable mapping even for a read fault */
+	bool try_map_writable;
+
+	/* Outputs of __kvm_follow_pfn */
+	hva_t hva;
+	bool writable;
+};
+
+kvm_pfn_t __kvm_follow_pfn(struct kvm_follow_pfn *foll);
+
 kvm_pfn_t gfn_to_pfn(struct kvm *kvm, gfn_t gfn);
 kvm_pfn_t gfn_to_pfn_prot(struct kvm *kvm, gfn_t gfn, bool write_fault,
 		      bool *writable);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 1e4586aaa6cb..5fde46f05117 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2486,8 +2486,7 @@ static inline int check_user_page_hwpoison(unsigned long addr)
  * true indicates success, otherwise false is returned.  It's also the
  * only part that runs if we can in atomic context.
  */
-static bool hva_to_pfn_fast(unsigned long addr, bool write_fault,
-			    bool *writable, kvm_pfn_t *pfn)
+static bool hva_to_pfn_fast(struct kvm_follow_pfn *foll, kvm_pfn_t *pfn)
 {
 	struct page *page[1];
 
@@ -2496,14 +2495,12 @@ static bool hva_to_pfn_fast(unsigned long addr, bool write_fault,
 	 * or the caller allows to map a writable pfn for a read fault
 	 * request.
 	 */
-	if (!(write_fault || writable))
+	if (!((foll->flags & FOLL_WRITE) || foll->try_map_writable))
 		return false;
 
-	if (get_user_page_fast_only(addr, FOLL_WRITE, page)) {
+	if (get_user_page_fast_only(foll->hva, FOLL_WRITE, page)) {
 		*pfn = page_to_pfn(page[0]);
-
-		if (writable)
-			*writable = true;
+		foll->writable = true;
 		return true;
 	}
 
@@ -2514,35 +2511,26 @@ static bool hva_to_pfn_fast(unsigned long addr, bool write_fault,
  * The slow path to get the pfn of the specified host virtual address,
  * 1 indicates success, -errno is returned if error is detected.
  */
-static int hva_to_pfn_slow(unsigned long addr, bool *async, bool write_fault,
-			   bool interruptible, bool *writable, kvm_pfn_t *pfn)
+static int hva_to_pfn_slow(struct kvm_follow_pfn *foll, kvm_pfn_t *pfn)
 {
-	unsigned int flags = FOLL_HWPOISON;
+	unsigned int flags = FOLL_HWPOISON | foll->flags;
 	struct page *page;
 	int npages;
 
 	might_sleep();
 
-	if (writable)
-		*writable = write_fault;
-
-	if (write_fault)
-		flags |= FOLL_WRITE;
-	if (async)
-		flags |= FOLL_NOWAIT;
-	if (interruptible)
-		flags |= FOLL_INTERRUPTIBLE;
-
-	npages = get_user_pages_unlocked(addr, 1, &page, flags);
+	npages = get_user_pages_unlocked(foll->hva, 1, &page, flags);
 	if (npages != 1)
 		return npages;
 
-	/* map read fault as writable if possible */
-	if (unlikely(!write_fault) && writable) {
+	if (foll->flags & FOLL_WRITE) {
+		foll->writable = true;
+	} else if (foll->try_map_writable) {
 		struct page *wpage;
 
-		if (get_user_page_fast_only(addr, FOLL_WRITE, &wpage)) {
-			*writable = true;
+		/* map read fault as writable if possible */
+		if (get_user_page_fast_only(foll->hva, FOLL_WRITE, &wpage)) {
+			foll->writable = true;
 			put_page(page);
 			page = wpage;
 		}
@@ -2573,23 +2561,23 @@ static int kvm_try_get_pfn(kvm_pfn_t pfn)
 }
 
 static int hva_to_pfn_remapped(struct vm_area_struct *vma,
-			       unsigned long addr, bool write_fault,
-			       bool *writable, kvm_pfn_t *p_pfn)
+			       struct kvm_follow_pfn *foll, kvm_pfn_t *p_pfn)
 {
 	kvm_pfn_t pfn;
 	pte_t *ptep;
 	pte_t pte;
 	spinlock_t *ptl;
+	bool write_fault = foll->flags & FOLL_WRITE;
 	int r;
 
-	r = follow_pte(vma->vm_mm, addr, &ptep, &ptl);
+	r = follow_pte(vma->vm_mm, foll->hva, &ptep, &ptl);
 	if (r) {
 		/*
 		 * get_user_pages fails for VM_IO and VM_PFNMAP vmas and does
 		 * not call the fault handler, so do it here.
 		 */
 		bool unlocked = false;
-		r = fixup_user_fault(current->mm, addr,
+		r = fixup_user_fault(current->mm, foll->hva,
 				     (write_fault ? FAULT_FLAG_WRITE : 0),
 				     &unlocked);
 		if (unlocked)
@@ -2597,7 +2585,7 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
 		if (r)
 			return r;
 
-		r = follow_pte(vma->vm_mm, addr, &ptep, &ptl);
+		r = follow_pte(vma->vm_mm, foll->hva, &ptep, &ptl);
 		if (r)
 			return r;
 	}
@@ -2609,8 +2597,7 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
 		goto out;
 	}
 
-	if (writable)
-		*writable = pte_write(pte);
+	foll->writable = pte_write(*ptep);
 	pfn = pte_pfn(pte);
 
 	/*
@@ -2655,24 +2642,22 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
  * 2): @write_fault = false && @writable, @writable will tell the caller
  *     whether the mapping is writable.
  */
-kvm_pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool interruptible,
-		     bool *async, bool write_fault, bool *writable)
+kvm_pfn_t hva_to_pfn(struct kvm_follow_pfn *foll)
 {
 	struct vm_area_struct *vma;
 	kvm_pfn_t pfn;
 	int npages, r;
 
 	/* we can do it either atomically or asynchronously, not both */
-	BUG_ON(atomic && async);
+	BUG_ON(foll->atomic && (foll->flags & FOLL_NOWAIT));
 
-	if (hva_to_pfn_fast(addr, write_fault, writable, &pfn))
+	if (hva_to_pfn_fast(foll, &pfn))
 		return pfn;
 
-	if (atomic)
+	if (foll->atomic)
 		return KVM_PFN_ERR_FAULT;
 
-	npages = hva_to_pfn_slow(addr, async, write_fault, interruptible,
-				 writable, &pfn);
+	npages = hva_to_pfn_slow(foll, &pfn);
 	if (npages == 1)
 		return pfn;
 	if (npages == -EINTR)
@@ -2680,83 +2665,123 @@ kvm_pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool interruptible,
 
 	mmap_read_lock(current->mm);
 	if (npages == -EHWPOISON ||
-	      (!async && check_user_page_hwpoison(addr))) {
+	    (!(foll->flags & FOLL_NOWAIT) && check_user_page_hwpoison(foll->hva))) {
 		pfn = KVM_PFN_ERR_HWPOISON;
 		goto exit;
 	}
 
 retry:
-	vma = vma_lookup(current->mm, addr);
+	vma = vma_lookup(current->mm, foll->hva);
 
 	if (vma == NULL)
 		pfn = KVM_PFN_ERR_FAULT;
 	else if (vma->vm_flags & (VM_IO | VM_PFNMAP)) {
-		r = hva_to_pfn_remapped(vma, addr, write_fault, writable, &pfn);
+		r = hva_to_pfn_remapped(vma, foll, &pfn);
 		if (r == -EAGAIN)
 			goto retry;
 		if (r < 0)
 			pfn = KVM_PFN_ERR_FAULT;
 	} else {
-		if (async && vma_is_valid(vma, write_fault))
-			*async = true;
-		pfn = KVM_PFN_ERR_FAULT;
+		if ((foll->flags & FOLL_NOWAIT) &&
+		    vma_is_valid(vma, foll->flags & FOLL_WRITE))
+			pfn = KVM_PFN_ERR_NEEDS_IO;
+		else
+			pfn = KVM_PFN_ERR_FAULT;
 	}
 exit:
 	mmap_read_unlock(current->mm);
 	return pfn;
 }
 
-kvm_pfn_t __gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn,
-			       bool atomic, bool interruptible, bool *async,
-			       bool write_fault, bool *writable, hva_t *hva)
+kvm_pfn_t __kvm_follow_pfn(struct kvm_follow_pfn *foll)
 {
-	unsigned long addr = __gfn_to_hva_many(slot, gfn, NULL, write_fault);
+	foll->writable = false;
+	foll->hva = __gfn_to_hva_many(foll->slot, foll->gfn, NULL,
+				      foll->flags & FOLL_WRITE);
 
-	if (hva)
-		*hva = addr;
-
-	if (addr == KVM_HVA_ERR_RO_BAD) {
-		if (writable)
-			*writable = false;
+	if (foll->hva == KVM_HVA_ERR_RO_BAD)
 		return KVM_PFN_ERR_RO_FAULT;
-	}
 
-	if (kvm_is_error_hva(addr)) {
-		if (writable)
-			*writable = false;
+	if (kvm_is_error_hva(foll->hva))
 		return KVM_PFN_NOSLOT;
-	}
 
-	/* Do not map writable pfn in the readonly memslot. */
-	if (writable && memslot_is_readonly(slot)) {
-		*writable = false;
-		writable = NULL;
-	}
+	if (memslot_is_readonly(foll->slot))
+		foll->try_map_writable = false;
 
-	return hva_to_pfn(addr, atomic, interruptible, async, write_fault,
-			  writable);
+	return hva_to_pfn(foll);
+}
+EXPORT_SYMBOL_GPL(__kvm_follow_pfn);
+
+kvm_pfn_t __gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn,
+			       bool atomic, bool interruptible, bool *async,
+			       bool write_fault, bool *writable, hva_t *hva)
+{
+	kvm_pfn_t pfn;
+	struct kvm_follow_pfn foll = {
+		.slot = slot,
+		.gfn = gfn,
+		.flags = 0,
+		.atomic = atomic,
+		.try_map_writable = !!writable,
+	};
+
+	if (write_fault)
+		foll.flags |= FOLL_WRITE;
+	if (async)
+		foll.flags |= FOLL_NOWAIT;
+	if (interruptible)
+		foll.flags |= FOLL_INTERRUPTIBLE;
+
+	pfn = __kvm_follow_pfn(&foll);
+	if (pfn == KVM_PFN_ERR_NEEDS_IO) {
+		*async = true;
+		pfn = KVM_PFN_ERR_FAULT;
+	}
+	if (hva)
+		*hva = foll.hva;
+	if (writable)
+		*writable = foll.writable;
+	return pfn;
 }
 EXPORT_SYMBOL_GPL(__gfn_to_pfn_memslot);
 
 kvm_pfn_t gfn_to_pfn_prot(struct kvm *kvm, gfn_t gfn, bool write_fault,
 		      bool *writable)
 {
-	return __gfn_to_pfn_memslot(gfn_to_memslot(kvm, gfn), gfn, false, false,
-				    NULL, write_fault, writable, NULL);
+	kvm_pfn_t pfn;
+	struct kvm_follow_pfn foll = {
+		.slot = gfn_to_memslot(kvm, gfn),
+		.gfn = gfn,
+		.flags = write_fault ? FOLL_WRITE : 0,
+		.try_map_writable = !!writable,
+	};
+	pfn = __kvm_follow_pfn(&foll);
+	if (writable)
+		*writable = foll.writable;
+	return pfn;
 }
 EXPORT_SYMBOL_GPL(gfn_to_pfn_prot);
 
 kvm_pfn_t gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn)
 {
-	return __gfn_to_pfn_memslot(slot, gfn, false, false, NULL, true,
-				    NULL, NULL);
+	struct kvm_follow_pfn foll = {
+		.slot = slot,
+		.gfn = gfn,
+		.flags = FOLL_WRITE,
+	};
+	return __kvm_follow_pfn(&foll);
 }
 EXPORT_SYMBOL_GPL(gfn_to_pfn_memslot);
 
 kvm_pfn_t gfn_to_pfn_memslot_atomic(const struct kvm_memory_slot *slot, gfn_t gfn)
 {
-	return __gfn_to_pfn_memslot(slot, gfn, true, false, NULL, true,
-				    NULL, NULL);
+	struct kvm_follow_pfn foll = {
+		.slot = slot,
+		.gfn = gfn,
+		.flags = FOLL_WRITE,
+		.atomic = true,
+	};
+	return __kvm_follow_pfn(&foll);
 }
 EXPORT_SYMBOL_GPL(gfn_to_pfn_memslot_atomic);
 
diff --git a/virt/kvm/kvm_mm.h b/virt/kvm/kvm_mm.h
index 180f1a09e6ba..ed896aee5396 100644
--- a/virt/kvm/kvm_mm.h
+++ b/virt/kvm/kvm_mm.h
@@ -20,8 +20,7 @@
 #define KVM_MMU_UNLOCK(kvm)		spin_unlock(&(kvm)->mmu_lock)
 #endif /* KVM_HAVE_MMU_RWLOCK */
 
-kvm_pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool interruptible,
-		     bool *async, bool write_fault, bool *writable);
+kvm_pfn_t hva_to_pfn(struct kvm_follow_pfn *foll);
 
 #ifdef CONFIG_HAVE_KVM_PFNCACHE
 void gfn_to_pfn_cache_invalidate_start(struct kvm *kvm,
diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index 2d6aba677830..86cd40acad11 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -144,6 +144,12 @@ static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_cache *gpc)
 	kvm_pfn_t new_pfn = KVM_PFN_ERR_FAULT;
 	void *new_khva = NULL;
 	unsigned long mmu_seq;
+	struct kvm_follow_pfn foll = {
+		.slot = gpc->memslot,
+		.gfn = gpa_to_gfn(gpc->gpa),
+		.flags = FOLL_WRITE,
+		.hva = gpc->uhva,
+	};
 
 	lockdep_assert_held(&gpc->refresh_lock);
 
@@ -182,8 +188,8 @@ static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_cache *gpc)
 			cond_resched();
 		}
 
-		/* We always request a writeable mapping */
-		new_pfn = hva_to_pfn(gpc->uhva, false, false, NULL, true, NULL);
+		/* We always request a writable mapping */
+		new_pfn = hva_to_pfn(&foll);
 		if (is_error_noslot_pfn(new_pfn))
 			goto out_error;
 
-- 
2.42.0.rc1.204.g551eb34607-goog

