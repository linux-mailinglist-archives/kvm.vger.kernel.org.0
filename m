Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C5746CFF4C
	for <lists+kvm@lfdr.de>; Thu, 30 Mar 2023 10:58:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230183AbjC3I6X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Mar 2023 04:58:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230083AbjC3I6U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Mar 2023 04:58:20 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF4297A82
        for <kvm@vger.kernel.org>; Thu, 30 Mar 2023 01:58:15 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id ja10so17463139plb.5
        for <kvm@vger.kernel.org>; Thu, 30 Mar 2023 01:58:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1680166695;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BG1wtweCRp2yLKIQJrZsbcG2DCCs4VdZ6zbbPPJNRdk=;
        b=T94hQX0kZBz/CdZCP5ycbTmHKRaEFgSE7kVBYecmLALA9exK+oCTOJrxbI+hIzD6hb
         W7+6L1AMRc1lBk3/hGte25vuDaT3q0QKDeDkJnHx0kSz4PNqzuhUPXY3ARjk+dDKky4b
         exdeTDukFKSSg7FAp6mO+twCNdDegcjlxSP7o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680166695;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BG1wtweCRp2yLKIQJrZsbcG2DCCs4VdZ6zbbPPJNRdk=;
        b=6nIc0YlFhSo4L+0OgV26V47RwN97nnR5sYAlhMZq0O1QWkb6i9ZtC3Hk1qzJjQDjyN
         4fymqlZOcC/cXrQJiJVuDbKZ+2BEPsWoxb1FJoTZX+yfV7iRmH4XS/XD3EMYl1mkpNzg
         5hQca2etJ08tfqlTJi8yVmpk1yr/gSUURJAbjGu6Q028i8vBhdWwqN7nERhO1gjIQGd5
         0G35WSwgKiwkmrcJC6xKq4cp84IM62I+xof/ewCf4GT623abgy23O5bibXZ3Q4oNIwfW
         k89hpsoogECBQaYMtMXkChAp1xUwSKbarndWmVRhcOE9L3n23UCldj1iix2WbhUF3crT
         ffBQ==
X-Gm-Message-State: AO0yUKWhxVYsqIBq7pQqEoIff3ncqkp9Wa7604rFtdEd6bZVHsMQ4gZJ
        KrTrKj25meTVFgaA/r+GI7Qj9g==
X-Google-Smtp-Source: AK7set+2kV6ovFOne/RSG/JuSnGk/aMOvo6fWoUNisnqe6hnWZg9TLcPl5GMn7BN3NTDcJIfpWdL+A==
X-Received: by 2002:a05:6a20:3f0c:b0:db:4c00:7918 with SMTP id az12-20020a056a203f0c00b000db4c007918mr18322352pzb.0.1680166695264;
        Thu, 30 Mar 2023 01:58:15 -0700 (PDT)
Received: from localhost ([2401:fa00:8f:203:1320:eef8:d0bb:b161])
        by smtp.gmail.com with UTF8SMTPSA id i12-20020aa787cc000000b00580e3917af7sm17437668pfo.117.2023.03.30.01.58.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Mar 2023 01:58:14 -0700 (PDT)
From:   David Stevens <stevensd@chromium.org>
X-Google-Original-From: David Stevens <stevensd@google.com>
To:     Marc Zyngier <maz@kernel.org>,
        Sean Christopherson <seanjc@google.com>
Cc:     Oliver Upton <oliver.upton@linux.dev>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        David Stevens <stevensd@chromium.org>
Subject: [PATCH v6 1/4] KVM: mmu: introduce new gfn_to_pfn_noref functions
Date:   Thu, 30 Mar 2023 17:57:59 +0900
Message-Id: <20230330085802.2414466-2-stevensd@google.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
In-Reply-To: <20230330085802.2414466-1-stevensd@google.com>
References: <20230330085802.2414466-1-stevensd@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Stevens <stevensd@chromium.org>

Introduce new gfn_to_pfn_noref functions that parallel existing
gfn_to_pfn functions. These functions can be used when the caller does
not need to maintain a reference to the returned pfn (i.e. when usage is
guarded by a mmu_notifier). The noref functions take an out parameter
that is used to return the struct page if the hva was resolved via gup.
The caller needs to drop its reference such a returned page.

Signed-off-by: David Stevens <stevensd@chromium.org>
---
 include/linux/kvm_host.h |  18 ++++
 virt/kvm/kvm_main.c      | 209 ++++++++++++++++++++++++++++-----------
 virt/kvm/kvm_mm.h        |   6 +-
 virt/kvm/pfncache.c      |  12 ++-
 4 files changed, 188 insertions(+), 57 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 90edc16d37e5..146f220cc25b 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1162,8 +1162,22 @@ kvm_pfn_t __gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn,
 			       bool atomic, bool interruptible, bool *async,
 			       bool write_fault, bool *writable, hva_t *hva);
 
+kvm_pfn_t gfn_to_pfn_noref(struct kvm *kvm, gfn_t gfn, struct page **page);
+kvm_pfn_t gfn_to_pfn_noref_prot(struct kvm *kvm, gfn_t gfn,
+				bool write_fault, bool *writable,
+				struct page **page);
+kvm_pfn_t gfn_to_pfn_noref_memslot(const struct kvm_memory_slot *slot,
+				   gfn_t gfn, struct page **page);
+kvm_pfn_t gfn_to_pfn_noref_memslot_atomic(const struct kvm_memory_slot *slot,
+					  gfn_t gfn, struct page **page);
+kvm_pfn_t __gfn_to_pfn_noref_memslot(const struct kvm_memory_slot *slot,
+				     gfn_t gfn, bool atomic, bool interruptible,
+				     bool *async, bool write_fault, bool *writable,
+				     hva_t *hva, struct page **page);
+
 void kvm_release_pfn_clean(kvm_pfn_t pfn);
 void kvm_release_pfn_dirty(kvm_pfn_t pfn);
+void kvm_release_pfn_noref_clean(kvm_pfn_t pfn, struct page *page);
 void kvm_set_pfn_dirty(kvm_pfn_t pfn);
 void kvm_set_pfn_accessed(kvm_pfn_t pfn);
 
@@ -1242,6 +1256,10 @@ struct kvm_memslots *kvm_vcpu_memslots(struct kvm_vcpu *vcpu);
 struct kvm_memory_slot *kvm_vcpu_gfn_to_memslot(struct kvm_vcpu *vcpu, gfn_t gfn);
 kvm_pfn_t kvm_vcpu_gfn_to_pfn_atomic(struct kvm_vcpu *vcpu, gfn_t gfn);
 kvm_pfn_t kvm_vcpu_gfn_to_pfn(struct kvm_vcpu *vcpu, gfn_t gfn);
+kvm_pfn_t kvm_vcpu_gfn_to_pfn_noref_atomic(struct kvm_vcpu *vcpu, gfn_t gfn,
+					   struct page **page);
+kvm_pfn_t kvm_vcpu_gfn_to_pfn_noref(struct kvm_vcpu *vcpu, gfn_t gfn,
+				    struct page **page);
 int kvm_vcpu_map(struct kvm_vcpu *vcpu, gpa_t gpa, struct kvm_host_map *map);
 void kvm_vcpu_unmap(struct kvm_vcpu *vcpu, struct kvm_host_map *map, bool dirty);
 unsigned long kvm_vcpu_gfn_to_hva(struct kvm_vcpu *vcpu, gfn_t gfn);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index f40b72eb0e7b..007dd984eeea 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2484,9 +2484,9 @@ static inline int check_user_page_hwpoison(unsigned long addr)
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
@@ -2497,7 +2497,7 @@ static bool hva_to_pfn_fast(unsigned long addr, bool write_fault,
 		return false;
 
 	if (get_user_page_fast_only(addr, FOLL_WRITE, page)) {
-		*pfn = page_to_pfn(page[0]);
+		*pfn = page_to_pfn(*page);
 
 		if (writable)
 			*writable = true;
@@ -2512,10 +2512,10 @@ static bool hva_to_pfn_fast(unsigned long addr, bool write_fault,
  * 1 indicates success, -errno is returned if error is detected.
  */
 static int hva_to_pfn_slow(unsigned long addr, bool *async, bool write_fault,
-			   bool interruptible, bool *writable, kvm_pfn_t *pfn)
+			   bool interruptible, bool *writable, kvm_pfn_t *pfn,
+			   struct page **page)
 {
 	unsigned int flags = FOLL_HWPOISON;
-	struct page *page;
 	int npages;
 
 	might_sleep();
@@ -2530,7 +2530,7 @@ static int hva_to_pfn_slow(unsigned long addr, bool *async, bool write_fault,
 	if (interruptible)
 		flags |= FOLL_INTERRUPTIBLE;
 
-	npages = get_user_pages_unlocked(addr, 1, &page, flags);
+	npages = get_user_pages_unlocked(addr, 1, page, flags);
 	if (npages != 1)
 		return npages;
 
@@ -2540,11 +2540,11 @@ static int hva_to_pfn_slow(unsigned long addr, bool *async, bool write_fault,
 
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
 
@@ -2559,16 +2559,6 @@ static bool vma_is_valid(struct vm_area_struct *vma, bool write_fault)
 	return true;
 }
 
-static int kvm_try_get_pfn(kvm_pfn_t pfn)
-{
-	struct page *page = kvm_pfn_to_refcounted_page(pfn);
-
-	if (!page)
-		return 1;
-
-	return get_page_unless_zero(page);
-}
-
 static int hva_to_pfn_remapped(struct vm_area_struct *vma,
 			       unsigned long addr, bool write_fault,
 			       bool *writable, kvm_pfn_t *p_pfn)
@@ -2607,26 +2597,6 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
 		*writable = pte_write(*ptep);
 	pfn = pte_pfn(*ptep);
 
-	/*
-	 * Get a reference here because callers of *hva_to_pfn* and
-	 * *gfn_to_pfn* ultimately call kvm_release_pfn_clean on the
-	 * returned pfn.  This is only needed if the VMA has VM_MIXEDMAP
-	 * set, but the kvm_try_get_pfn/kvm_release_pfn_clean pair will
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
@@ -2643,6 +2613,7 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
  *         host page is not in the memory
  * @write_fault: whether we should get a writable host page
  * @writable: whether it allows to map a writable host page for !@write_fault
+ * @page: outparam for the refcounted page assicated with the pfn, if any
  *
  * The function will map a writable host page for these two cases:
  * 1): @write_fault = true
@@ -2650,23 +2621,25 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
  *     whether the mapping is writable.
  */
 kvm_pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool interruptible,
-		     bool *async, bool write_fault, bool *writable)
+		     bool *async, bool write_fault, bool *writable,
+		     struct page **page)
 {
 	struct vm_area_struct *vma;
 	kvm_pfn_t pfn;
 	int npages, r;
+	*page = NULL;
 
 	/* we can do it either atomically or asynchronously, not both */
 	BUG_ON(atomic && async);
 
-	if (hva_to_pfn_fast(addr, write_fault, writable, &pfn))
+	if (hva_to_pfn_fast(addr, write_fault, writable, &pfn, page))
 		return pfn;
 
 	if (atomic)
 		return KVM_PFN_ERR_FAULT;
 
 	npages = hva_to_pfn_slow(addr, async, write_fault, interruptible,
-				 writable, &pfn);
+				 writable, &pfn, page);
 	if (npages == 1)
 		return pfn;
 	if (npages == -EINTR)
@@ -2700,9 +2673,37 @@ kvm_pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool interruptible,
 	return pfn;
 }
 
-kvm_pfn_t __gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn,
-			       bool atomic, bool interruptible, bool *async,
-			       bool write_fault, bool *writable, hva_t *hva)
+/*
+ * Helper function for managing refcounts of pfn returned by hva_to_pfn.
+ * @pfn: pfn returned by hva_to_pfn
+ * @page: page outparam from hva_to_pfn
+ *
+ * In cases where access to the pfn resolved by hva_to_pfn isn't protected by
+ * our MMU notifier, if the pfn was resolved by hva_to_pfn_remapped instead of
+ * gup, then its refcount needs to be bumped.
+ *
+ * Certain IO or PFNMAP mappings can be backed with valid struct pages, but be
+ * allocated without refcounting e.g., tail pages of non-compound higher order
+ * allocations, which would then underflow the refcount when the caller does the
+ * required put_page. Don't allow those pages here.
+ */
+kvm_pfn_t kvm_try_get_refcounted_page_ref(kvm_pfn_t pfn, struct page *page)
+{
+	/* If @page is valid, KVM already has a reference to the pfn/page. */
+	if (page || is_error_pfn(pfn))
+		return pfn;
+
+	page = kvm_pfn_to_refcounted_page(pfn);
+	if (!page || get_page_unless_zero(page))
+		return pfn;
+
+	return KVM_PFN_ERR_FAULT;
+}
+
+kvm_pfn_t __gfn_to_pfn_noref_memslot(const struct kvm_memory_slot *slot, gfn_t gfn,
+				     bool atomic, bool interruptible, bool *async,
+				     bool write_fault, bool *writable, hva_t *hva,
+				     struct page **page)
 {
 	unsigned long addr = __gfn_to_hva_many(slot, gfn, NULL, write_fault);
 
@@ -2728,47 +2729,134 @@ kvm_pfn_t __gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn,
 	}
 
 	return hva_to_pfn(addr, atomic, interruptible, async, write_fault,
-			  writable);
+			  writable, page);
+}
+EXPORT_SYMBOL_GPL(__gfn_to_pfn_noref_memslot);
+
+kvm_pfn_t gfn_to_pfn_noref_prot(struct kvm *kvm, gfn_t gfn, bool write_fault,
+				bool *writable, struct page **page)
+{
+	return __gfn_to_pfn_noref_memslot(gfn_to_memslot(kvm, gfn), gfn, false, false,
+					  NULL, write_fault, writable, NULL, page);
+}
+EXPORT_SYMBOL_GPL(gfn_to_pfn_noref_prot);
+
+kvm_pfn_t gfn_to_pfn_noref_memslot(const struct kvm_memory_slot *slot, gfn_t gfn,
+				   struct page **page)
+{
+	return __gfn_to_pfn_noref_memslot(slot, gfn, false, false, NULL, true,
+					  NULL, NULL, page);
+}
+EXPORT_SYMBOL_GPL(gfn_to_pfn_noref_memslot);
+
+kvm_pfn_t gfn_to_pfn_noref_memslot_atomic(const struct kvm_memory_slot *slot,
+					  gfn_t gfn, struct page **page)
+{
+	return __gfn_to_pfn_noref_memslot(slot, gfn, true, false, NULL, true, NULL,
+					  NULL, page);
+}
+EXPORT_SYMBOL_GPL(gfn_to_pfn_noref_memslot_atomic);
+
+kvm_pfn_t kvm_vcpu_gfn_to_pfn_noref_atomic(struct kvm_vcpu *vcpu, gfn_t gfn,
+					   struct page **page)
+{
+	return gfn_to_pfn_noref_memslot_atomic(
+			kvm_vcpu_gfn_to_memslot(vcpu, gfn), gfn, page);
+}
+EXPORT_SYMBOL_GPL(kvm_vcpu_gfn_to_pfn_noref_atomic);
+
+kvm_pfn_t gfn_to_pfn_noref(struct kvm *kvm, gfn_t gfn, struct page **page)
+{
+	return gfn_to_pfn_noref_memslot(gfn_to_memslot(kvm, gfn), gfn, page);
+}
+EXPORT_SYMBOL_GPL(gfn_to_pfn_noref);
+
+kvm_pfn_t kvm_vcpu_gfn_to_pfn_noref(struct kvm_vcpu *vcpu, gfn_t gfn,
+				    struct page **page)
+{
+	return gfn_to_pfn_noref_memslot(kvm_vcpu_gfn_to_memslot(vcpu, gfn),
+					gfn, page);
+}
+EXPORT_SYMBOL_GPL(kvm_vcpu_gfn_to_pfn_noref);
+
+kvm_pfn_t __gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn,
+			       bool atomic, bool interruptible, bool *async,
+			       bool write_fault, bool *writable, hva_t *hva)
+{
+	struct page *page;
+	kvm_pfn_t pfn;
+
+	pfn = __gfn_to_pfn_noref_memslot(slot, gfn, atomic, interruptible, async,
+					 write_fault, writable, hva, &page);
+
+	return kvm_try_get_refcounted_page_ref(pfn, page);
 }
 EXPORT_SYMBOL_GPL(__gfn_to_pfn_memslot);
 
 kvm_pfn_t gfn_to_pfn_prot(struct kvm *kvm, gfn_t gfn, bool write_fault,
 		      bool *writable)
 {
-	return __gfn_to_pfn_memslot(gfn_to_memslot(kvm, gfn), gfn, false, false,
-				    NULL, write_fault, writable, NULL);
+	struct page *page;
+	kvm_pfn_t pfn;
+
+	pfn = gfn_to_pfn_noref_prot(kvm, gfn, write_fault, writable, &page);
+
+	return kvm_try_get_refcounted_page_ref(pfn, page);
 }
 EXPORT_SYMBOL_GPL(gfn_to_pfn_prot);
 
 kvm_pfn_t gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn)
 {
-	return __gfn_to_pfn_memslot(slot, gfn, false, false, NULL, true,
-				    NULL, NULL);
+	struct page *page;
+	kvm_pfn_t pfn;
+
+	pfn = gfn_to_pfn_noref_memslot(slot, gfn, &page);
+
+	return kvm_try_get_refcounted_page_ref(pfn, page);
 }
 EXPORT_SYMBOL_GPL(gfn_to_pfn_memslot);
 
 kvm_pfn_t gfn_to_pfn_memslot_atomic(const struct kvm_memory_slot *slot, gfn_t gfn)
 {
-	return __gfn_to_pfn_memslot(slot, gfn, true, false, NULL, true,
-				    NULL, NULL);
+	struct page *page;
+	kvm_pfn_t pfn;
+
+	pfn = gfn_to_pfn_noref_memslot_atomic(slot, gfn, &page);
+
+	return kvm_try_get_refcounted_page_ref(pfn, page);
 }
 EXPORT_SYMBOL_GPL(gfn_to_pfn_memslot_atomic);
 
 kvm_pfn_t kvm_vcpu_gfn_to_pfn_atomic(struct kvm_vcpu *vcpu, gfn_t gfn)
 {
-	return gfn_to_pfn_memslot_atomic(kvm_vcpu_gfn_to_memslot(vcpu, gfn), gfn);
+	struct page *page;
+	kvm_pfn_t pfn;
+
+	pfn = kvm_vcpu_gfn_to_pfn_noref_atomic(vcpu, gfn, &page);
+
+	return kvm_try_get_refcounted_page_ref(pfn, page);
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_gfn_to_pfn_atomic);
 
 kvm_pfn_t gfn_to_pfn(struct kvm *kvm, gfn_t gfn)
 {
-	return gfn_to_pfn_memslot(gfn_to_memslot(kvm, gfn), gfn);
+	struct page *page;
+	kvm_pfn_t pfn;
+
+	pfn = gfn_to_pfn_noref(kvm, gfn, &page);
+
+	return kvm_try_get_refcounted_page_ref(pfn, page);
 }
 EXPORT_SYMBOL_GPL(gfn_to_pfn);
 
 kvm_pfn_t kvm_vcpu_gfn_to_pfn(struct kvm_vcpu *vcpu, gfn_t gfn)
 {
-	return gfn_to_pfn_memslot(kvm_vcpu_gfn_to_memslot(vcpu, gfn), gfn);
+	struct page *page;
+	kvm_pfn_t pfn;
+
+	pfn = kvm_vcpu_gfn_to_pfn_noref(vcpu, gfn, &page);
+
+	return kvm_try_get_refcounted_page_ref(pfn, page);
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_gfn_to_pfn);
 
@@ -2925,6 +3013,17 @@ void kvm_release_pfn_clean(kvm_pfn_t pfn)
 }
 EXPORT_SYMBOL_GPL(kvm_release_pfn_clean);
 
+void kvm_release_pfn_noref_clean(kvm_pfn_t pfn, struct page *page)
+{
+	if (is_error_noslot_pfn(pfn))
+		return;
+
+	kvm_set_pfn_accessed(pfn);
+	if (page)
+		put_page(page);
+}
+EXPORT_SYMBOL_GPL(kvm_release_pfn_noref_clean);
+
 void kvm_release_page_dirty(struct page *page)
 {
 	WARN_ON(is_error_page(page));
diff --git a/virt/kvm/kvm_mm.h b/virt/kvm/kvm_mm.h
index 180f1a09e6ba..a4072cc5a189 100644
--- a/virt/kvm/kvm_mm.h
+++ b/virt/kvm/kvm_mm.h
@@ -3,6 +3,8 @@
 #ifndef __KVM_MM_H__
 #define __KVM_MM_H__ 1
 
+#include <linux/mm_types.h>
+
 /*
  * Architectures can choose whether to use an rwlock or spinlock
  * for the mmu_lock.  These macros, for use in common code
@@ -21,7 +23,9 @@
 #endif /* KVM_HAVE_MMU_RWLOCK */
 
 kvm_pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool interruptible,
-		     bool *async, bool write_fault, bool *writable);
+		     bool *async, bool write_fault, bool *writable,
+		     struct page **page);
+kvm_pfn_t kvm_try_get_refcounted_page_ref(kvm_pfn_t pfn, struct page *page);
 
 #ifdef CONFIG_HAVE_KVM_PFNCACHE
 void gfn_to_pfn_cache_invalidate_start(struct kvm *kvm,
diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index 2d6aba677830..e25d3af969f4 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -144,6 +144,7 @@ static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_cache *gpc)
 	kvm_pfn_t new_pfn = KVM_PFN_ERR_FAULT;
 	void *new_khva = NULL;
 	unsigned long mmu_seq;
+	struct page *page;
 
 	lockdep_assert_held(&gpc->refresh_lock);
 
@@ -183,10 +184,19 @@ static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_cache *gpc)
 		}
 
 		/* We always request a writeable mapping */
-		new_pfn = hva_to_pfn(gpc->uhva, false, false, NULL, true, NULL);
+		new_pfn = hva_to_pfn(gpc->uhva, false, false, NULL, true, NULL, &page);
 		if (is_error_noslot_pfn(new_pfn))
 			goto out_error;
 
+		/*
+		 * Filter out pages that support refcounting but which aren't
+		 * currently being refcounted. Some KVM MMUs support such pages, but
+		 * although we could support them here, kvm internals more generally
+		 * don't. Reject them here for consistency.
+		 */
+		if (kvm_try_get_refcounted_page_ref(new_pfn, page) != new_pfn)
+			goto out_error;
+
 		/*
 		 * Obtain a new kernel mapping if KVM itself will access the
 		 * pfn.  Note, kmap() and memremap() can both sleep, so this
-- 
2.40.0.348.gf938b09366-goog

