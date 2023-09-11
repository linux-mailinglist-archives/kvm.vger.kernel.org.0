Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0E6079A131
	for <lists+kvm@lfdr.de>; Mon, 11 Sep 2023 04:17:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232792AbjIKCRQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 10 Sep 2023 22:17:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232731AbjIKCRO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 10 Sep 2023 22:17:14 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66EBFE6F
        for <kvm@vger.kernel.org>; Sun, 10 Sep 2023 19:17:00 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id d9443c01a7336-1c39f2b4f5aso4462915ad.0
        for <kvm@vger.kernel.org>; Sun, 10 Sep 2023 19:17:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1694398619; x=1695003419; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=egByjBzJcCB8brnLv5YMd/MEK6uJwFM+otbuvFagvYA=;
        b=YF5CuhLN6A3Vytoyb4O19wdujhd9dkx8GtIsfYcLsxzuxj9NfZYnvwXfAhaVdcPZl+
         fv9tjTQ6eXTapCKkpW3FJHbo7fCdIVhCcJrc0+wzLEmgxWgUFN55xVEbNZmBr5XWx7tC
         mUEeA8LcV+YYXAp9fvL3plcYOL4aY56NIeOSk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694398619; x=1695003419;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=egByjBzJcCB8brnLv5YMd/MEK6uJwFM+otbuvFagvYA=;
        b=LYalvBF8Q8DA6YJYzNL9ei89I/Y90ZAJIBiY0oh/xlbU7+lFx03e/XY3FAUBrXJzPO
         VW3z3mVHGyZUqYc4BVDGY9Kn4IXDQdTvFSICO1H4NZRAX41zcrEi9GUyNQtuRbZSB8Qw
         EaxE5CaUxany4TMziq9LPOA8ZOBmJYWFQx2ZMEKFfPvReqeBJ+6krCWIRRX4ithI5FQ0
         fTuCi9D8oGMQOvlj0UISe2Xs1XfxvuPUWP0NQkmUHExG/V6rSLajUT4ObTyOc2zBiOlm
         g6tgc07iwMA+ntUVNflGjLiieEpMQRg27dTsnk6MMVeRBzFoHPqYxaltM4+hCIip5ZQN
         cRTQ==
X-Gm-Message-State: AOJu0Yypyv+pkBOI5vjnbEVccpz49EXuXv632OKVeqbBt86KJoUGEPVN
        ckoIbEeA/gdzHYrpXwLE+XL/qA==
X-Google-Smtp-Source: AGHT+IGe6g+N219BghCgrSGmsKPPbaQaG6yQl3gXiQ0iSd31WWCTldGSVElf/HAQRu1c27N9793bgg==
X-Received: by 2002:a17:903:2303:b0:1b7:f64b:378a with SMTP id d3-20020a170903230300b001b7f64b378amr8074481plh.16.1694398619338;
        Sun, 10 Sep 2023 19:16:59 -0700 (PDT)
Received: from localhost ([2401:fa00:8f:203:282a:59c8:cc3a:2d6])
        by smtp.gmail.com with UTF8SMTPSA id s13-20020a170902988d00b001b89891bfc4sm5148444plp.199.2023.09.10.19.16.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 10 Sep 2023 19:16:58 -0700 (PDT)
From:   David Stevens <stevensd@chromium.org>
X-Google-Original-From: David Stevens <stevensd@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Yu Zhang <yu.c.zhang@linux.intel.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        David Stevens <stevensd@chromium.org>
Subject: [PATCH v9 3/6] KVM: mmu: Improve handling of non-refcounted pfns
Date:   Mon, 11 Sep 2023 11:16:33 +0900
Message-ID: <20230911021637.1941096-4-stevensd@google.com>
X-Mailer: git-send-email 2.42.0.283.g2d96d420d3-goog
In-Reply-To: <20230911021637.1941096-1-stevensd@google.com>
References: <20230911021637.1941096-1-stevensd@google.com>
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

KVM's handling of non-refcounted pfns has two problems:

 - struct pages without refcounting (e.g. tail pages of non-compound
   higher order pages) cannot be used at all, as gfn_to_pfn does not
   provide enough information for callers to handle the refcount.
 - pfns without struct pages can be accessed without the protection of a
   mmu notifier. This is unsafe because KVM cannot monitor or control
   the lifespan of such pfns, so it may continue to access the pfns
   after they are freed.

This patch extends the __kvm_follow_pfn API to properly handle these
cases. First, it adds a is_refcounted_page output parameter so that
callers can tell whether or not a pfn has a struct page that needs to be
passed to put_page. Second, it adds a guarded_by_mmu_notifier parameter
that is used to avoid returning non-refcounted pages when the caller
cannot safely use them.

Since callers need to be updated on a case-by-case basis to pay
attention to is_refcounted_page, the new behavior of returning
non-refcounted pages is opt-in via the allow_non_refcounted_struct_page
parameter. Once all callers have been updated, this parameter should be
removed.

The fact that non-refcounted pfns can no longer be accessed without mmu
notifier protection is a breaking change. Since there is no timeline for
updating everything in KVM to use mmu notifiers, this change adds an
opt-in module parameter called allow_unsafe_mappings to allow such
mappings. Systems which trust userspace not to tear down such unsafe
mappings while KVM is using them can set this parameter to re-enable the
legacy behavior.

Signed-off-by: David Stevens <stevensd@chromium.org>
---
 include/linux/kvm_host.h | 21 ++++++++++
 virt/kvm/kvm_main.c      | 84 ++++++++++++++++++++++++----------------
 virt/kvm/pfncache.c      |  1 +
 3 files changed, 72 insertions(+), 34 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index c2e0ddf14dba..2ed08ae1a9be 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1185,10 +1185,31 @@ struct kvm_follow_pfn {
 	bool atomic;
 	/* Try to create a writable mapping even for a read fault */
 	bool try_map_writable;
+	/* Usage of the returned pfn will be guared by a mmu notifier. */
+	bool guarded_by_mmu_notifier;
+	/*
+	 * When false, do not return pfns for non-refcounted struct pages.
+	 *
+	 * TODO: This allows callers to use kvm_release_pfn on the pfns
+	 * returned by gfn_to_pfn without worrying about corrupting the
+	 * refcounted of non-refcounted pages. Once all callers respect
+	 * is_refcounted_page, this flag should be removed.
+	 */
+	bool allow_non_refcounted_struct_page;
 
 	/* Outputs of __kvm_follow_pfn */
 	hva_t hva;
 	bool writable;
+	/*
+	 * True if the returned pfn is for a page with a valid refcount. False
+	 * if the returned pfn has no struct page or if the struct page is not
+	 * being refcounted (e.g. tail pages of non-compound higher order
+	 * allocations from IO/PFNMAP mappings).
+	 *
+	 * When this output flag is false, callers should not try to convert
+	 * the pfn to a struct page.
+	 */
+	bool is_refcounted_page;
 };
 
 kvm_pfn_t __kvm_follow_pfn(struct kvm_follow_pfn *foll);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 9b33a59c6d65..235c5cb3fdac 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -96,6 +96,10 @@ unsigned int halt_poll_ns_shrink;
 module_param(halt_poll_ns_shrink, uint, 0644);
 EXPORT_SYMBOL_GPL(halt_poll_ns_shrink);
 
+/* Allow non-struct page memory to be mapped without MMU notifier protection. */
+static bool allow_unsafe_mappings;
+module_param(allow_unsafe_mappings, bool, 0444);
+
 /*
  * Ordering of locks:
  *
@@ -2507,6 +2511,15 @@ static inline int check_user_page_hwpoison(unsigned long addr)
 	return rc == -EHWPOISON;
 }
 
+static kvm_pfn_t kvm_follow_refcounted_pfn(struct kvm_follow_pfn *foll,
+					   struct page *page)
+{
+	kvm_pfn_t pfn = page_to_pfn(page);
+
+	foll->is_refcounted_page = true;
+	return pfn;
+}
+
 /*
  * The fast path to get the writable pfn which will be stored in @pfn,
  * true indicates success, otherwise false is returned.  It's also the
@@ -2525,7 +2538,7 @@ static bool hva_to_pfn_fast(struct kvm_follow_pfn *foll, kvm_pfn_t *pfn)
 		return false;
 
 	if (get_user_page_fast_only(foll->hva, FOLL_WRITE, page)) {
-		*pfn = page_to_pfn(page[0]);
+		*pfn = kvm_follow_refcounted_pfn(foll, page[0]);
 		foll->writable = true;
 		return true;
 	}
@@ -2561,7 +2574,7 @@ static int hva_to_pfn_slow(struct kvm_follow_pfn *foll, kvm_pfn_t *pfn)
 			page = wpage;
 		}
 	}
-	*pfn = page_to_pfn(page);
+	*pfn = kvm_follow_refcounted_pfn(foll, page);
 	return npages;
 }
 
@@ -2576,16 +2589,6 @@ static bool vma_is_valid(struct vm_area_struct *vma, bool write_fault)
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
 			       struct kvm_follow_pfn *foll, kvm_pfn_t *p_pfn)
 {
@@ -2594,6 +2597,7 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
 	pte_t pte;
 	spinlock_t *ptl;
 	bool write_fault = foll->flags & FOLL_WRITE;
+	struct page *page;
 	int r;
 
 	r = follow_pte(vma->vm_mm, foll->hva, &ptep, &ptl);
@@ -2618,37 +2622,39 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
 
 	pte = ptep_get(ptep);
 
+	foll->writable = pte_write(pte);
+	pfn = pte_pfn(pte);
+
+	page = kvm_pfn_to_refcounted_page(pfn);
+
 	if (write_fault && !pte_write(pte)) {
 		pfn = KVM_PFN_ERR_RO_FAULT;
 		goto out;
 	}
 
-	foll->writable = pte_write(pte);
-	pfn = pte_pfn(pte);
+	if (!page)
+		goto out;
 
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
+	if (get_page_unless_zero(page))
+		WARN_ON_ONCE(kvm_follow_refcounted_pfn(foll, page) != pfn);
 
 out:
 	pte_unmap_unlock(ptep, ptl);
-	*p_pfn = pfn;
+
+	/*
+	 * TODO: Remove the first branch once all callers have been
+	 * taught to play nice with non-refcounted struct pages.
+	 */
+	if (page && !foll->is_refcounted_page &&
+	    !foll->allow_non_refcounted_struct_page) {
+		r = -EFAULT;
+	} else if (!foll->is_refcounted_page &&
+		   !foll->guarded_by_mmu_notifier &&
+		   !allow_unsafe_mappings) {
+		r = -EFAULT;
+	} else {
+		*p_pfn = pfn;
+	}
 
 	return r;
 }
@@ -2722,6 +2728,8 @@ kvm_pfn_t hva_to_pfn(struct kvm_follow_pfn *foll)
 kvm_pfn_t __kvm_follow_pfn(struct kvm_follow_pfn *foll)
 {
 	foll->writable = false;
+	foll->is_refcounted_page = false;
+
 	foll->hva = __gfn_to_hva_many(foll->slot, foll->gfn, NULL,
 				      foll->flags & FOLL_WRITE);
 
@@ -2749,6 +2757,7 @@ kvm_pfn_t __gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn,
 		.flags = 0,
 		.atomic = atomic,
 		.try_map_writable = !!writable,
+		.allow_non_refcounted_struct_page = false,
 	};
 
 	if (write_fault)
@@ -2780,6 +2789,7 @@ kvm_pfn_t gfn_to_pfn_prot(struct kvm *kvm, gfn_t gfn, bool write_fault,
 		.gfn = gfn,
 		.flags = write_fault ? FOLL_WRITE : 0,
 		.try_map_writable = !!writable,
+		.allow_non_refcounted_struct_page = false,
 	};
 	pfn = __kvm_follow_pfn(&foll);
 	if (writable)
@@ -2794,6 +2804,7 @@ kvm_pfn_t gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn)
 		.slot = slot,
 		.gfn = gfn,
 		.flags = FOLL_WRITE,
+		.allow_non_refcounted_struct_page = false,
 	};
 	return __kvm_follow_pfn(&foll);
 }
@@ -2806,6 +2817,11 @@ kvm_pfn_t gfn_to_pfn_memslot_atomic(const struct kvm_memory_slot *slot, gfn_t gf
 		.gfn = gfn,
 		.flags = FOLL_WRITE,
 		.atomic = true,
+		/*
+		 * Setting atomic means __kvm_follow_pfn will never make it
+		 * to hva_to_pfn_remapped, so this is vacuously true.
+		 */
+		.allow_non_refcounted_struct_page = true,
 	};
 	return __kvm_follow_pfn(&foll);
 }
diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index 86cd40acad11..6bbf972c11f8 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -149,6 +149,7 @@ static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_cache *gpc)
 		.gfn = gpa_to_gfn(gpc->gpa),
 		.flags = FOLL_WRITE,
 		.hva = gpc->uhva,
+		.allow_non_refcounted_struct_page = false,
 	};
 
 	lockdep_assert_held(&gpc->refresh_lock);
-- 
2.42.0.283.g2d96d420d3-goog

