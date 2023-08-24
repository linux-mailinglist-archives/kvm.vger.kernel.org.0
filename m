Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D282478697E
	for <lists+kvm@lfdr.de>; Thu, 24 Aug 2023 10:06:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240393AbjHXIGH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Aug 2023 04:06:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240500AbjHXIFt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Aug 2023 04:05:49 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAA4819B7
        for <kvm@vger.kernel.org>; Thu, 24 Aug 2023 01:05:17 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id d9443c01a7336-1bf5c314a57so29761895ad.1
        for <kvm@vger.kernel.org>; Thu, 24 Aug 2023 01:05:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1692864303; x=1693469103;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XABl5efGX4dLDIDtb0EMToFN6DITOp/e+Uzd4Q9F18I=;
        b=NMOxeuFctuvdMSGAHF6a3sNMAZVYTiQ15gzr51r5WSX9AD4Jp52VPhOlW4t3j7+BIp
         EK+p3SbwjPGUMIyX9MCUaAGP1JNqTZ84JwBGpqtuFZhFFJqNseR/Ohu5UlCU6B+kWGXz
         F1m0I2rqei5AcINJI6WK2oBjleuGwcva3t0q8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692864303; x=1693469103;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XABl5efGX4dLDIDtb0EMToFN6DITOp/e+Uzd4Q9F18I=;
        b=PfIwmCnscpOrJYV+NWybSlNO60g5IP8d3O48Kys8Wd24kgcn2peOYqP/QzPgTI7cPf
         kdiQeisoGZWwSQpY5PSv2FagqVydFjJSKHqGpTsXVCjJK96zVOtOpz8DEblkHvar4EQ9
         yq6GHrI+bAYw91iN3eSO+oZ4RYb2xU2ISlxdSCjzGMbzincEWfGWc1+QniIHcqkRap88
         cXXhCAgVwzjSHfZTzbjZSJGTVw2wlO9V/uF6GsGmoBuas1nrRnx52q5hcwe8umj3ltzn
         TuSB3RgEFjK7g9jSWXls2P42ED17HvpTt5FdvnuGN5fN5Se/iQj64sVJWpS7kuWoAZV7
         v8Fg==
X-Gm-Message-State: AOJu0YxoE3MIitQ1PibEX7SQxwY0DuIb252dYz1TGes8xjzkKYfaffcu
        cTjGmmFENfMfewVV6zT1qeu6Kg==
X-Google-Smtp-Source: AGHT+IFxDr7iOWu6Tl7iYobrbaczRccU42on6BqmhxkrRNhaRIO0VNSdRCiyULPVAj40XBMY9/nM9g==
X-Received: by 2002:a17:902:8c85:b0:1bf:13a7:d3ef with SMTP id t5-20020a1709028c8500b001bf13a7d3efmr10608777plo.66.1692864303541;
        Thu, 24 Aug 2023 01:05:03 -0700 (PDT)
Received: from localhost ([2401:fa00:8f:203:515:8b2a:90c3:b79e])
        by smtp.gmail.com with UTF8SMTPSA id jd17-20020a170903261100b001bf20c80684sm12158428plb.6.2023.08.24.01.05.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Aug 2023 01:05:03 -0700 (PDT)
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
Subject: [PATCH v8 3/8] KVM: mmu: Make __kvm_follow_pfn not imply FOLL_GET
Date:   Thu, 24 Aug 2023 17:04:03 +0900
Message-ID: <20230824080408.2933205-4-stevensd@google.com>
X-Mailer: git-send-email 2.42.0.rc1.204.g551eb34607-goog
In-Reply-To: <20230824080408.2933205-1-stevensd@google.com>
References: <20230824080408.2933205-1-stevensd@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Stevens <stevensd@chromium.org>

Make it so that __kvm_follow_pfn does not imply FOLL_GET. This allows
callers to resolve a gfn when the associated pfn has a valid struct page
that isn't being actively refcounted (e.g. tail pages of non-compound
higher order pages). For a caller to safely omit FOLL_GET, all usages of
the returned pfn must be guarded by a mmu notifier.

This also adds a is_refcounted_page out parameter to kvm_follow_pfn that
is set when the returned pfn has an associated struct page with a valid
refcount. Callers that don't pass FOLL_GET should remember this value
and use it to avoid places like kvm_is_ad_tracked_page that assume a
non-zero refcount.

Signed-off-by: David Stevens <stevensd@chromium.org>
---
 include/linux/kvm_host.h |  7 ++++
 virt/kvm/kvm_main.c      | 84 ++++++++++++++++++++++++----------------
 virt/kvm/pfncache.c      |  2 +-
 3 files changed, 58 insertions(+), 35 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 59d9b5e5db33..713fc2d91f95 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1164,10 +1164,17 @@ struct kvm_follow_pfn {
 	bool atomic;
 	/* Try to create a writable mapping even for a read fault */
 	bool try_map_writable;
+	/*
+	 * Usage of the returned pfn will be guared by a mmu notifier. Must
+	 * be true if FOLL_GET is not set.
+	 */
+	bool guarded_by_mmu_notifier;
 
 	/* Outputs of __kvm_follow_pfn */
 	hva_t hva;
 	bool writable;
+	/* True if the returned pfn is for a page with a valid refcount. */
+	bool is_refcounted_page;
 };
 
 kvm_pfn_t __kvm_follow_pfn(struct kvm_follow_pfn *foll);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 5fde46f05117..963b96cd8ff9 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2481,6 +2481,25 @@ static inline int check_user_page_hwpoison(unsigned long addr)
 	return rc == -EHWPOISON;
 }
 
+static kvm_pfn_t kvm_follow_refcounted_pfn(struct kvm_follow_pfn *foll,
+					   struct page *page)
+{
+	kvm_pfn_t pfn = page_to_pfn(page);
+
+	foll->is_refcounted_page = true;
+
+	/*
+	 * FIXME: Ideally, KVM wouldn't pass FOLL_GET to gup() when the caller
+	 * doesn't want to grab a reference, but gup() doesn't support getting
+	 * just the pfn, i.e. FOLL_GET is effectively mandatory.  If that ever
+	 * changes, drop this and simply don't pass FOLL_GET to gup().
+	 */
+	if (!(foll->flags & FOLL_GET))
+		put_page(page);
+
+	return pfn;
+}
+
 /*
  * The fast path to get the writable pfn which will be stored in @pfn,
  * true indicates success, otherwise false is returned.  It's also the
@@ -2499,8 +2518,8 @@ static bool hva_to_pfn_fast(struct kvm_follow_pfn *foll, kvm_pfn_t *pfn)
 		return false;
 
 	if (get_user_page_fast_only(foll->hva, FOLL_WRITE, page)) {
-		*pfn = page_to_pfn(page[0]);
 		foll->writable = true;
+		*pfn = kvm_follow_refcounted_pfn(foll, page[0]);
 		return true;
 	}
 
@@ -2513,7 +2532,7 @@ static bool hva_to_pfn_fast(struct kvm_follow_pfn *foll, kvm_pfn_t *pfn)
  */
 static int hva_to_pfn_slow(struct kvm_follow_pfn *foll, kvm_pfn_t *pfn)
 {
-	unsigned int flags = FOLL_HWPOISON | foll->flags;
+	unsigned int flags = FOLL_HWPOISON | FOLL_GET | foll->flags;
 	struct page *page;
 	int npages;
 
@@ -2535,7 +2554,7 @@ static int hva_to_pfn_slow(struct kvm_follow_pfn *foll, kvm_pfn_t *pfn)
 			page = wpage;
 		}
 	}
-	*pfn = page_to_pfn(page);
+	*pfn = kvm_follow_refcounted_pfn(foll, page);
 	return npages;
 }
 
@@ -2550,16 +2569,6 @@ static bool vma_is_valid(struct vm_area_struct *vma, bool write_fault)
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
@@ -2568,6 +2577,7 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
 	pte_t pte;
 	spinlock_t *ptl;
 	bool write_fault = foll->flags & FOLL_WRITE;
+	struct page *page;
 	int r;
 
 	r = follow_pte(vma->vm_mm, foll->hva, &ptep, &ptl);
@@ -2601,28 +2611,29 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
 	pfn = pte_pfn(pte);
 
 	/*
-	 * Get a reference here because callers of *hva_to_pfn* and
-	 * *gfn_to_pfn* ultimately call kvm_release_pfn_clean on the
-	 * returned pfn.  This is only needed if the VMA has VM_MIXEDMAP
-	 * set, but the kvm_try_get_pfn/kvm_release_pfn_clean pair will
-	 * simply do nothing for reserved pfns.
-	 *
-	 * Whoever called remap_pfn_range is also going to call e.g.
-	 * unmap_mapping_range before the underlying pages are freed,
-	 * causing a call to our MMU notifier.
+	 * Now deal with reference counting. If kvm_pfn_to_refcounted_page
+	 * returns NULL, then there's no refcount to worry about.
 	 *
-	 * Certain IO or PFNMAP mappings can be backed with valid
-	 * struct pages, but be allocated without refcounting e.g.,
-	 * tail pages of non-compound higher order allocations, which
-	 * would then underflow the refcount when the caller does the
-	 * required put_page. Don't allow those pages here.
+	 * Otherwise, certain IO or PFNMAP mappings can be backed with valid
+	 * struct pages but be allocated without refcounting e.g., tail pages of
+	 * non-compound higher order allocations. If FOLL_GET is set and we
+	 * increment such a refcount, then when that pfn is eventually passed to
+	 * kvm_release_pfn_clean, its refcount would hit zero and be incorrectly
+	 * freed. Therefore don't allow those pages here when FOLL_GET is set.
 	 */
-	if (!kvm_try_get_pfn(pfn))
-		r = -EFAULT;
+	page = kvm_pfn_to_refcounted_page(pfn);
+	if (!page)
+		goto out;
+
+	if (get_page_unless_zero(page))
+		WARN_ON_ONCE(kvm_follow_refcounted_pfn(foll, page) != pfn);
 
 out:
 	pte_unmap_unlock(ptep, ptl);
-	*p_pfn = pfn;
+	if (!foll->is_refcounted_page && !foll->guarded_by_mmu_notifier)
+		r = -EFAULT;
+	else
+		*p_pfn = pfn;
 
 	return r;
 }
@@ -2696,6 +2707,11 @@ kvm_pfn_t hva_to_pfn(struct kvm_follow_pfn *foll)
 kvm_pfn_t __kvm_follow_pfn(struct kvm_follow_pfn *foll)
 {
 	foll->writable = false;
+	foll->is_refcounted_page = false;
+
+	if (WARN_ON_ONCE(!(foll->flags & FOLL_GET) && !foll->guarded_by_mmu_notifier))
+		return KVM_PFN_ERR_FAULT;
+
 	foll->hva = __gfn_to_hva_many(foll->slot, foll->gfn, NULL,
 				      foll->flags & FOLL_WRITE);
 
@@ -2720,7 +2736,7 @@ kvm_pfn_t __gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn,
 	struct kvm_follow_pfn foll = {
 		.slot = slot,
 		.gfn = gfn,
-		.flags = 0,
+		.flags = FOLL_GET,
 		.atomic = atomic,
 		.try_map_writable = !!writable,
 	};
@@ -2752,7 +2768,7 @@ kvm_pfn_t gfn_to_pfn_prot(struct kvm *kvm, gfn_t gfn, bool write_fault,
 	struct kvm_follow_pfn foll = {
 		.slot = gfn_to_memslot(kvm, gfn),
 		.gfn = gfn,
-		.flags = write_fault ? FOLL_WRITE : 0,
+		.flags = FOLL_GET | (write_fault ? FOLL_WRITE : 0),
 		.try_map_writable = !!writable,
 	};
 	pfn = __kvm_follow_pfn(&foll);
@@ -2767,7 +2783,7 @@ kvm_pfn_t gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn)
 	struct kvm_follow_pfn foll = {
 		.slot = slot,
 		.gfn = gfn,
-		.flags = FOLL_WRITE,
+		.flags = FOLL_GET | FOLL_WRITE,
 	};
 	return __kvm_follow_pfn(&foll);
 }
@@ -2778,7 +2794,7 @@ kvm_pfn_t gfn_to_pfn_memslot_atomic(const struct kvm_memory_slot *slot, gfn_t gf
 	struct kvm_follow_pfn foll = {
 		.slot = slot,
 		.gfn = gfn,
-		.flags = FOLL_WRITE,
+		.flags = FOLL_GET | FOLL_WRITE,
 		.atomic = true,
 	};
 	return __kvm_follow_pfn(&foll);
diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index 86cd40acad11..c558f510ab51 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -147,7 +147,7 @@ static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_cache *gpc)
 	struct kvm_follow_pfn foll = {
 		.slot = gpc->memslot,
 		.gfn = gpa_to_gfn(gpc->gpa),
-		.flags = FOLL_WRITE,
+		.flags = FOLL_WRITE | FOLL_GET,
 		.hva = gpc->uhva,
 	};
 
-- 
2.42.0.rc1.204.g551eb34607-goog

