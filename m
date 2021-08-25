Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CC873F6D87
	for <lists+kvm@lfdr.de>; Wed, 25 Aug 2021 04:51:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237645AbhHYCvm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Aug 2021 22:51:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231960AbhHYCvf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Aug 2021 22:51:35 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1A76C061764
        for <kvm@vger.kernel.org>; Tue, 24 Aug 2021 19:50:49 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id ot2-20020a17090b3b4200b0019127f8ed87so3080589pjb.1
        for <kvm@vger.kernel.org>; Tue, 24 Aug 2021 19:50:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YtFasnIK3QHmUjCSfMEQOW++/Aww/avWQuCESI8ywGY=;
        b=gPXD8bV+mzMkPDKvRZ+iVLgz5A+pIxyoVKfTX3kDJpJHXB2W2ukjcU8K3sQU3t4/Gp
         Lsc0Xrgn+LTQzqSY16/kTqq995PFUrqclBu3M/4ysmym1aFlmsxRPY9eU/txiOW6S5Ea
         qFsZRhk83dCnp9xwwTIy1DjP7mcrCBYWvNPCU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YtFasnIK3QHmUjCSfMEQOW++/Aww/avWQuCESI8ywGY=;
        b=fRJQ/7rYLKdOHO4MfQ44Apq2N8cLd4nC48NhQhtObvRmr8zN2f14Z+ZbCuzRr+t0VY
         eCJCx0oxPTr89ivv72UMo6P+RHe09OriPDQQotXgUk906Gjeydp8ljEODaHxJFklI6uv
         O3YWBAtf/R1uv0OqgZD6BHiPMTyUlPoK85PE0nfOLmNKJeIwCdnP0xtvzpgvgyyhcjqS
         FlLPRX0BUHEGmz9s4ZCTyZ8d6yYbB+IDbs9IhGCVrnspaCrRpO6sqVT7vexhz6hDJcC+
         5jHIYOCkpcPv8Qmq+NP+ZRw5ze4J05xV5E24cjCMxRm5DSOj+kTygAwHR4Pgd/17QVu2
         LDWA==
X-Gm-Message-State: AOAM532WbeP2i9XrBhsOMvwl6uQSO/fFolsfUGqiU4fvYJy/ja16rrHa
        P2CtKJfiq2X+FV5abkrETccKGw==
X-Google-Smtp-Source: ABdhPJyRsmPQNbsZS0jerETpZO6IQgXt22kMowxNEAXK+cSlCm4AT0PmuT1HrDiq6aDh/Su/h2zGAw==
X-Received: by 2002:a17:90a:7c45:: with SMTP id e5mr8063779pjl.141.1629859849437;
        Tue, 24 Aug 2021 19:50:49 -0700 (PDT)
Received: from localhost ([2401:fa00:8f:203:d273:c78c:fce8:a0e2])
        by smtp.gmail.com with UTF8SMTPSA id c19sm3368348pjs.1.2021.08.24.19.50.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Aug 2021 19:50:49 -0700 (PDT)
From:   David Stevens <stevensd@chromium.org>
X-Google-Original-From: David Stevens <stevensd@google.com>
To:     Marc Zyngier <maz@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        David Stevens <stevensd@chromium.org>
Subject: [PATCH v3 1/4] KVM: mmu: introduce new gfn_to_pfn_page functions
Date:   Wed, 25 Aug 2021 11:50:06 +0900
Message-Id: <20210825025009.2081060-2-stevensd@google.com>
X-Mailer: git-send-email 2.33.0.rc2.250.ged5fa647cd-goog
In-Reply-To: <20210825025009.2081060-1-stevensd@google.com>
References: <20210825025009.2081060-1-stevensd@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Stevens <stevensd@chromium.org>

Introduce new gfn_to_pfn_page functions that parallel existing
gfn_to_pfn functions. The new functions are identical except they take
an additional out parameter that is used to return the struct page if
the hva was resolved by gup. This allows callers to differentiate the
gup and follow_pte cases, which in turn allows callers to only touch the
page refcount when necessitated by gup.

The old gfn_to_pfn functions are depreciated, and all callers should be
migrated to the new gfn_to_pfn_page functions. In the interim, the
gfn_to_pfn functions are reimplemented as wrappers of the corresponding
gfn_to_pfn_page functions. The wrappers take a reference to the pfn's
page that had previously been taken in hva_to_pfn_remapped.

Signed-off-by: David Stevens <stevensd@chromium.org>
---
 include/linux/kvm_host.h |  17 ++++
 virt/kvm/kvm_main.c      | 186 ++++++++++++++++++++++++++++-----------
 2 files changed, 152 insertions(+), 51 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index e4d712e9f760..2e7400ae4982 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -868,6 +868,19 @@ kvm_pfn_t __gfn_to_pfn_memslot(struct kvm_memory_slot *slot, gfn_t gfn,
 			       bool atomic, bool *async, bool write_fault,
 			       bool *writable, hva_t *hva);
 
+kvm_pfn_t gfn_to_pfn_page(struct kvm *kvm, gfn_t gfn, struct page **page);
+kvm_pfn_t gfn_to_pfn_page_prot(struct kvm *kvm, gfn_t gfn,
+			       bool write_fault, bool *writable,
+			       struct page **page);
+kvm_pfn_t gfn_to_pfn_page_memslot(struct kvm_memory_slot *slot,
+				  gfn_t gfn, struct page **page);
+kvm_pfn_t gfn_to_pfn_page_memslot_atomic(struct kvm_memory_slot *slot,
+					 gfn_t gfn, struct page **page);
+kvm_pfn_t __gfn_to_pfn_page_memslot(struct kvm_memory_slot *slot,
+				    gfn_t gfn, bool atomic, bool *async,
+				    bool write_fault, bool *writable,
+				    hva_t *hva, struct page **page);
+
 void kvm_release_pfn_clean(kvm_pfn_t pfn);
 void kvm_release_pfn_dirty(kvm_pfn_t pfn);
 void kvm_set_pfn_dirty(kvm_pfn_t pfn);
@@ -949,6 +962,10 @@ struct kvm_memslots *kvm_vcpu_memslots(struct kvm_vcpu *vcpu);
 struct kvm_memory_slot *kvm_vcpu_gfn_to_memslot(struct kvm_vcpu *vcpu, gfn_t gfn);
 kvm_pfn_t kvm_vcpu_gfn_to_pfn_atomic(struct kvm_vcpu *vcpu, gfn_t gfn);
 kvm_pfn_t kvm_vcpu_gfn_to_pfn(struct kvm_vcpu *vcpu, gfn_t gfn);
+kvm_pfn_t kvm_vcpu_gfn_to_pfn_page_atomic(struct kvm_vcpu *vcpu, gfn_t gfn,
+					  struct page **page);
+kvm_pfn_t kvm_vcpu_gfn_to_pfn_page(struct kvm_vcpu *vcpu, gfn_t gfn,
+				   struct page **page);
 int kvm_vcpu_map(struct kvm_vcpu *vcpu, gpa_t gpa, struct kvm_host_map *map);
 int kvm_map_gfn(struct kvm_vcpu *vcpu, gfn_t gfn, struct kvm_host_map *map,
 		struct gfn_to_pfn_cache *cache, bool atomic);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 3e67c93ca403..5c47ea93df23 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2216,9 +2216,9 @@ static inline int check_user_page_hwpoison(unsigned long addr)
  * only part that runs if we can in atomic context.
  */
 static bool hva_to_pfn_fast(unsigned long addr, bool write_fault,
-			    bool *writable, kvm_pfn_t *pfn)
+			    bool *writable, kvm_pfn_t *pfn,
+			    struct page **page)
 {
-	struct page *page[1];
 
 	/*
 	 * Fast pin a writable pfn only if it is a write fault request
@@ -2229,7 +2229,7 @@ static bool hva_to_pfn_fast(unsigned long addr, bool write_fault,
 		return false;
 
 	if (get_user_page_fast_only(addr, FOLL_WRITE, page)) {
-		*pfn = page_to_pfn(page[0]);
+		*pfn = page_to_pfn(*page);
 
 		if (writable)
 			*writable = true;
@@ -2244,10 +2244,9 @@ static bool hva_to_pfn_fast(unsigned long addr, bool write_fault,
  * 1 indicates success, -errno is returned if error is detected.
  */
 static int hva_to_pfn_slow(unsigned long addr, bool *async, bool write_fault,
-			   bool *writable, kvm_pfn_t *pfn)
+			   bool *writable, kvm_pfn_t *pfn, struct page **page)
 {
 	unsigned int flags = FOLL_HWPOISON;
-	struct page *page;
 	int npages = 0;
 
 	might_sleep();
@@ -2260,7 +2259,7 @@ static int hva_to_pfn_slow(unsigned long addr, bool *async, bool write_fault,
 	if (async)
 		flags |= FOLL_NOWAIT;
 
-	npages = get_user_pages_unlocked(addr, 1, &page, flags);
+	npages = get_user_pages_unlocked(addr, 1, page, flags);
 	if (npages != 1)
 		return npages;
 
@@ -2270,11 +2269,11 @@ static int hva_to_pfn_slow(unsigned long addr, bool *async, bool write_fault,
 
 		if (get_user_page_fast_only(addr, FOLL_WRITE, &wpage)) {
 			*writable = true;
-			put_page(page);
-			page = wpage;
+			put_page(*page);
+			*page = wpage;
 		}
 	}
-	*pfn = page_to_pfn(page);
+	*pfn = page_to_pfn(*page);
 	return npages;
 }
 
@@ -2289,13 +2288,6 @@ static bool vma_is_valid(struct vm_area_struct *vma, bool write_fault)
 	return true;
 }
 
-static int kvm_try_get_pfn(kvm_pfn_t pfn)
-{
-	if (kvm_is_reserved_pfn(pfn))
-		return 1;
-	return get_page_unless_zero(pfn_to_page(pfn));
-}
-
 static int hva_to_pfn_remapped(struct vm_area_struct *vma,
 			       unsigned long addr, bool *async,
 			       bool write_fault, bool *writable,
@@ -2335,26 +2327,6 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
 		*writable = pte_write(*ptep);
 	pfn = pte_pfn(*ptep);
 
-	/*
-	 * Get a reference here because callers of *hva_to_pfn* and
-	 * *gfn_to_pfn* ultimately call kvm_release_pfn_clean on the
-	 * returned pfn.  This is only needed if the VMA has VM_MIXEDMAP
-	 * set, but the kvm_get_pfn/kvm_release_pfn_clean pair will
-	 * simply do nothing for reserved pfns.
-	 *
-	 * Whoever called remap_pfn_range is also going to call e.g.
-	 * unmap_mapping_range before the underlying pages are freed,
-	 * causing a call to our MMU notifier.
-	 *
-	 * Certain IO or PFNMAP mappings can be backed with valid
-	 * struct pages, but be allocated without refcounting e.g.,
-	 * tail pages of non-compound higher order allocations, which
-	 * would then underflow the refcount when the caller does the
-	 * required put_page. Don't allow those pages here.
-	 */ 
-	if (!kvm_try_get_pfn(pfn))
-		r = -EFAULT;
-
 out:
 	pte_unmap_unlock(ptep, ptl);
 	*p_pfn = pfn;
@@ -2376,8 +2348,9 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
  * 2): @write_fault = false && @writable, @writable will tell the caller
  *     whether the mapping is writable.
  */
-static kvm_pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool *async,
-			bool write_fault, bool *writable)
+static kvm_pfn_t hva_to_pfn(unsigned long addr, bool atomic,
+			    bool *async, bool write_fault, bool *writable,
+			    struct page **page)
 {
 	struct vm_area_struct *vma;
 	kvm_pfn_t pfn = 0;
@@ -2386,13 +2359,14 @@ static kvm_pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool *async,
 	/* we can do it either atomically or asynchronously, not both */
 	BUG_ON(atomic && async);
 
-	if (hva_to_pfn_fast(addr, write_fault, writable, &pfn))
+	if (hva_to_pfn_fast(addr, write_fault, writable, &pfn, page))
 		return pfn;
 
 	if (atomic)
 		return KVM_PFN_ERR_FAULT;
 
-	npages = hva_to_pfn_slow(addr, async, write_fault, writable, &pfn);
+	npages = hva_to_pfn_slow(addr, async, write_fault, writable,
+				 &pfn, page);
 	if (npages == 1)
 		return pfn;
 
@@ -2424,12 +2398,14 @@ static kvm_pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool *async,
 	return pfn;
 }
 
-kvm_pfn_t __gfn_to_pfn_memslot(struct kvm_memory_slot *slot, gfn_t gfn,
-			       bool atomic, bool *async, bool write_fault,
-			       bool *writable, hva_t *hva)
+kvm_pfn_t __gfn_to_pfn_page_memslot(struct kvm_memory_slot *slot,
+				    gfn_t gfn, bool atomic, bool *async,
+				    bool write_fault, bool *writable,
+				    hva_t *hva, struct page **page)
 {
 	unsigned long addr = __gfn_to_hva_many(slot, gfn, NULL, write_fault);
 
+	*page = NULL;
 	if (hva)
 		*hva = addr;
 
@@ -2452,45 +2428,153 @@ kvm_pfn_t __gfn_to_pfn_memslot(struct kvm_memory_slot *slot, gfn_t gfn,
 	}
 
 	return hva_to_pfn(addr, atomic, async, write_fault,
-			  writable);
+			  writable, page);
+}
+EXPORT_SYMBOL_GPL(__gfn_to_pfn_page_memslot);
+
+kvm_pfn_t gfn_to_pfn_page_prot(struct kvm *kvm, gfn_t gfn, bool write_fault,
+			       bool *writable, struct page **page)
+{
+	return __gfn_to_pfn_page_memslot(gfn_to_memslot(kvm, gfn), gfn, false,
+					 NULL, write_fault, writable, NULL,
+					 page);
+}
+EXPORT_SYMBOL_GPL(gfn_to_pfn_page_prot);
+
+kvm_pfn_t gfn_to_pfn_page_memslot(struct kvm_memory_slot *slot, gfn_t gfn,
+				  struct page **page)
+{
+	return __gfn_to_pfn_page_memslot(slot, gfn, false, NULL, true,
+					 NULL, NULL, page);
+}
+EXPORT_SYMBOL_GPL(gfn_to_pfn_page_memslot);
+
+kvm_pfn_t gfn_to_pfn_page_memslot_atomic(struct kvm_memory_slot *slot,
+					 gfn_t gfn, struct page **page)
+{
+	return __gfn_to_pfn_page_memslot(slot, gfn, true, NULL, true, NULL,
+					 NULL, page);
+}
+EXPORT_SYMBOL_GPL(gfn_to_pfn_page_memslot_atomic);
+
+kvm_pfn_t kvm_vcpu_gfn_to_pfn_page_atomic(struct kvm_vcpu *vcpu, gfn_t gfn,
+					  struct page **page)
+{
+	return gfn_to_pfn_page_memslot_atomic(
+			kvm_vcpu_gfn_to_memslot(vcpu, gfn), gfn, page);
+}
+EXPORT_SYMBOL_GPL(kvm_vcpu_gfn_to_pfn_page_atomic);
+
+kvm_pfn_t gfn_to_pfn_page(struct kvm *kvm, gfn_t gfn, struct page **page)
+{
+	return gfn_to_pfn_page_memslot(gfn_to_memslot(kvm, gfn), gfn, page);
+}
+EXPORT_SYMBOL_GPL(gfn_to_pfn_page);
+
+kvm_pfn_t kvm_vcpu_gfn_to_pfn_page(struct kvm_vcpu *vcpu, gfn_t gfn,
+				   struct page **page)
+{
+	return gfn_to_pfn_page_memslot(kvm_vcpu_gfn_to_memslot(vcpu, gfn),
+				       gfn, page);
+}
+EXPORT_SYMBOL_GPL(kvm_vcpu_gfn_to_pfn_page);
+
+static kvm_pfn_t ensure_pfn_ref(struct page *page, kvm_pfn_t pfn)
+{
+	if (page || is_error_pfn(pfn) || kvm_is_reserved_pfn(pfn))
+		return pfn;
+
+	/*
+	 * Certain IO or PFNMAP mappings can be backed with valid
+	 * struct pages, but be allocated without refcounting e.g.,
+	 * tail pages of non-compound higher order allocations, which
+	 * would then underflow the refcount when the caller does the
+	 * required put_page. Don't allow those pages here.
+	 */
+	if (get_page_unless_zero(pfn_to_page(pfn)))
+		return pfn;
+
+	return KVM_PFN_ERR_FAULT;
+}
+
+kvm_pfn_t __gfn_to_pfn_memslot(struct kvm_memory_slot *slot, gfn_t gfn,
+			       bool atomic, bool *async, bool write_fault,
+			       bool *writable, hva_t *hva)
+{
+	struct page *page;
+	kvm_pfn_t pfn;
+
+	pfn = __gfn_to_pfn_page_memslot(slot, gfn, atomic, async,
+					write_fault, writable, hva, &page);
+
+	return ensure_pfn_ref(page, pfn);
 }
 EXPORT_SYMBOL_GPL(__gfn_to_pfn_memslot);
 
 kvm_pfn_t gfn_to_pfn_prot(struct kvm *kvm, gfn_t gfn, bool write_fault,
 		      bool *writable)
 {
-	return __gfn_to_pfn_memslot(gfn_to_memslot(kvm, gfn), gfn, false, NULL,
-				    write_fault, writable, NULL);
+	struct page *page;
+	kvm_pfn_t pfn;
+
+	pfn = gfn_to_pfn_page_prot(kvm, gfn, write_fault, writable, &page);
+
+	return ensure_pfn_ref(page, pfn);
 }
 EXPORT_SYMBOL_GPL(gfn_to_pfn_prot);
 
 kvm_pfn_t gfn_to_pfn_memslot(struct kvm_memory_slot *slot, gfn_t gfn)
 {
-	return __gfn_to_pfn_memslot(slot, gfn, false, NULL, true, NULL, NULL);
+	struct page *page;
+	kvm_pfn_t pfn;
+
+	pfn = gfn_to_pfn_page_memslot(slot, gfn, &page);
+
+	return ensure_pfn_ref(page, pfn);
 }
 EXPORT_SYMBOL_GPL(gfn_to_pfn_memslot);
 
 kvm_pfn_t gfn_to_pfn_memslot_atomic(struct kvm_memory_slot *slot, gfn_t gfn)
 {
-	return __gfn_to_pfn_memslot(slot, gfn, true, NULL, true, NULL, NULL);
+	struct page *page;
+	kvm_pfn_t pfn;
+
+	pfn = gfn_to_pfn_page_memslot_atomic(slot, gfn, &page);
+
+	return ensure_pfn_ref(page, pfn);
 }
 EXPORT_SYMBOL_GPL(gfn_to_pfn_memslot_atomic);
 
 kvm_pfn_t kvm_vcpu_gfn_to_pfn_atomic(struct kvm_vcpu *vcpu, gfn_t gfn)
 {
-	return gfn_to_pfn_memslot_atomic(kvm_vcpu_gfn_to_memslot(vcpu, gfn), gfn);
+	struct page *page;
+	kvm_pfn_t pfn;
+
+	pfn = kvm_vcpu_gfn_to_pfn_page_atomic(vcpu, gfn, &page);
+
+	return ensure_pfn_ref(page, pfn);
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_gfn_to_pfn_atomic);
 
 kvm_pfn_t gfn_to_pfn(struct kvm *kvm, gfn_t gfn)
 {
-	return gfn_to_pfn_memslot(gfn_to_memslot(kvm, gfn), gfn);
+	struct page *page;
+	kvm_pfn_t pfn;
+
+	pfn = gfn_to_pfn_page(kvm, gfn, &page);
+
+	return ensure_pfn_ref(page, pfn);
 }
 EXPORT_SYMBOL_GPL(gfn_to_pfn);
 
 kvm_pfn_t kvm_vcpu_gfn_to_pfn(struct kvm_vcpu *vcpu, gfn_t gfn)
 {
-	return gfn_to_pfn_memslot(kvm_vcpu_gfn_to_memslot(vcpu, gfn), gfn);
+	struct page *page;
+	kvm_pfn_t pfn;
+
+	pfn = kvm_vcpu_gfn_to_pfn_page(vcpu, gfn, &page);
+
+	return ensure_pfn_ref(page, pfn);
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_gfn_to_pfn);
 
-- 
2.33.0.rc2.250.ged5fa647cd-goog

