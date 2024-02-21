Return-Path: <kvm+bounces-9278-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C2BB385D14F
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 08:27:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 397E61F21ACB
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 07:27:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D73A03B198;
	Wed, 21 Feb 2024 07:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="D9cMQeup"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oi1-f172.google.com (mail-oi1-f172.google.com [209.85.167.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 356673CF5D
	for <kvm@vger.kernel.org>; Wed, 21 Feb 2024 07:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708500375; cv=none; b=cwDkGqH6nPYADxU7ZhV7tJSlASxZsb58l6Q9bHknNbr9YY1mBED/coRj2pRkLOoMKkqZsgNl8m47FLKZZtCZeHbc8yw5L+fuieUnGxJnRKxTqBfKx2ALu0SNgHWoEyiWpNdPc47MuWaXWxTR+yHwS8ssfxlVuLKYO581ckspz8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708500375; c=relaxed/simple;
	bh=VRHol4dx7LY6E87ZtYH4SrK/OkyaH6rxYDR2jN9GG/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GGT+46VSedaaWHZVeVbq7gTLpFFzrQTgJwRL33Ni/PgPxRjVk6bwUe4o+rkDPgXrkp/ytcpZEemVJzXMXcOYVbhkGZZ/EWnyPtMBHNOajUWvROr59FvAm9FZqkXuuZ/SFbzdqM9DWYHg047/4iVuP/r/Ew4smTm+M3mDSNNgX38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=D9cMQeup; arc=none smtp.client-ip=209.85.167.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Received: by mail-oi1-f172.google.com with SMTP id 5614622812f47-3c0a36077a5so3886256b6e.0
        for <kvm@vger.kernel.org>; Tue, 20 Feb 2024 23:26:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1708500372; x=1709105172; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RTBr9/GWDwnsxmtI6m5PH+5BX17VQD9g5p7s8cBzX1w=;
        b=D9cMQeuplraR6rp9WcVOPJJlrhN20aJvBKbg2YwkaX+KzxZd5KPvthnSaHAZMxMY6K
         K2S50W69KCqBQtn5M9N5c5N6oSDWIsF+hGj1emfg/n0SwpD3a4QH0+HcX/DsJf21itDh
         uJ7yKk98A8todWvlBuETfzeWdkeg9lnstl3hM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708500372; x=1709105172;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RTBr9/GWDwnsxmtI6m5PH+5BX17VQD9g5p7s8cBzX1w=;
        b=bhBJzEjtqnV3oHn2urbc7qLbkuljaCDI92jcp2I1uQ6ZExG00+/Z4dMz9WvLP0uy7j
         QoeJiE/UL8q/zs5bhJ9FBNahv7VYex5ctvHvEds2nNrZvnNDs/me2ocabfvRV7Xc/y0J
         BkCdfpeci10/1G9xqeOnNrTIC2MtgzgQeRSF5hgj0t87f8AavjxlDNRhF90KmImguYoe
         iOaf5pHffFyS6lPYIBW0w7RbZyCtOGUgv912K6MJ3Fs4PazmF0xzbuDgNWqN5WW41DPN
         8LX1erjK0yGZC03rMacNuooygIvJVI5TAoUE5+5ud66eUwWQyzh519IDtKmzm0fEg75u
         IUJQ==
X-Forwarded-Encrypted: i=1; AJvYcCUhmpe4R3EP+1RYV1xGYTH/zn9YcbTQ7POtLdg+7/SPINi/Qf2tJwrYB/MP75xxZyOH+qS2nbY2e0pygKycHOoOSRuk
X-Gm-Message-State: AOJu0YxX0wgAyvFw+ldDCbRaKLw/wiEiw5KhKaEmqZVsux9xPwwRT2Ih
	yn3e1m+NxEtgN/Acc5/y7lUUfcFEpb2e6hgTd9avSStbuS5uSPkfJa6LzCNIgQ==
X-Google-Smtp-Source: AGHT+IGqQTxxH7pMORTYmeqcJw2GQWFyedi7oJ0B77dG8t/KSSjK+ZU574E6abJL2b4oD5mLxUDX3Q==
X-Received: by 2002:a05:6808:23d5:b0:3c1:5603:ac2b with SMTP id bq21-20020a05680823d500b003c15603ac2bmr10664093oib.25.1708500372298;
        Tue, 20 Feb 2024 23:26:12 -0800 (PST)
Received: from localhost ([2401:fa00:8f:203:b417:5d09:c226:a19c])
        by smtp.gmail.com with UTF8SMTPSA id r6-20020aa78b86000000b006e2f9f007b0sm7830235pfd.92.2024.02.20.23.26.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Feb 2024 23:26:11 -0800 (PST)
From: David Stevens <stevensd@chromium.org>
X-Google-Original-From: David Stevens <stevensd@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Yu Zhang <yu.c.zhang@linux.intel.com>,
	Isaku Yamahata <isaku.yamahata@gmail.com>,
	Zhi Wang <zhi.wang.linux@gmail.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	David Stevens <stevensd@chromium.org>
Subject: [PATCH v10 4/8] KVM: mmu: Improve handling of non-refcounted pfns
Date: Wed, 21 Feb 2024 16:25:22 +0900
Message-ID: <20240221072528.2702048-5-stevensd@google.com>
X-Mailer: git-send-email 2.44.0.rc0.258.g7320e95886-goog
In-Reply-To: <20240221072528.2702048-1-stevensd@google.com>
References: <20240221072528.2702048-1-stevensd@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: David Stevens <stevensd@chromium.org>

KVM's handling of non-refcounted pfns has two problems:

 - pfns without struct pages can be accessed without the protection of a
   mmu notifier. This is unsafe because KVM cannot monitor or control
   the lifespan of such pfns, so it may continue to access the pfns
   after they are freed.
 - struct pages without refcounting (e.g. tail pages of non-compound
   higher order pages) cannot be used at all, as gfn_to_pfn does not
   provide enough information for callers to be able to avoid
   underflowing the refcount.

This patch extends the kvm_follow_pfn() API to properly handle these
cases:

  - First, it adds FOLL_GET to the list of supported flags, to indicate
    whether or not the caller actually wants to take a refcount.
  - Second, it adds a guarded_by_mmu_notifier parameter that is used to
    avoid returning non-refcounted pages when the caller cannot safely
    use them.
  - Third, it adds an is_refcounted_page output parameter so that
    callers can tell whether or not a pfn has a struct page that needs
    to be passed to put_page.

Since callers need to be updated on a case-by-case basis to pay
attention to is_refcounted_page, the new behavior of returning
non-refcounted pages is opt-in via the allow_non_refcounted_struct_page
parameter. Once all callers have been updated, this parameter should be
removed.

The fact that non-refcounted pfns can no longer be accessed without mmu
notifier protection by default is a breaking change. This patch provides
a module parameter that system admins can use to re-enable the previous
unsafe behavior when userspace is trusted not to migrate/free/etc
non-refcounted pfns that are mapped into the guest. There is no timeline
for updating everything in KVM to use mmu notifiers to alleviate the
need for this module parameter.

Signed-off-by: David Stevens <stevensd@chromium.org>
---
 include/linux/kvm_host.h |  24 +++++++++
 virt/kvm/kvm_main.c      | 108 ++++++++++++++++++++++++++-------------
 virt/kvm/pfncache.c      |   3 +-
 3 files changed, 98 insertions(+), 37 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 290db5133c36..88279649c00d 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1219,10 +1219,34 @@ struct kvm_follow_pfn {
 	bool atomic;
 	/* Try to create a writable mapping even for a read fault. */
 	bool try_map_writable;
+	/*
+	 * Usage of the returned pfn will be guared by a mmu notifier. If
+	 * FOLL_GET is not set, this must be true.
+	 */
+	bool guarded_by_mmu_notifier;
+	/*
+	 * When false, do not return pfns for non-refcounted struct pages.
+	 *
+	 * TODO: This allows callers to use kvm_release_pfn on the pfns
+	 * returned by gfn_to_pfn without worrying about corrupting the
+	 * refcount of non-refcounted pages. Once all callers respect
+	 * refcounted_page, this flag should be removed.
+	 */
+	bool allow_non_refcounted_struct_page;
 
 	/* Outputs of kvm_follow_pfn */
 	hva_t hva;
 	bool writable;
+	/*
+	 * Non-NULL if the returned pfn is for a page with a valid refcount,
+	 * NULL if the returned pfn has no struct page or if the struct page is
+	 * not being refcounted (e.g. tail pages of non-compound higher order
+	 * allocations from IO/PFNMAP mappings).
+	 *
+	 * NOTE: This will still be set if FOLL_GET is not specified, but the
+	 *       returned page will not have an elevated refcount.
+	 */
+	struct page *refcounted_page;
 };
 
 kvm_pfn_t kvm_follow_pfn(struct kvm_follow_pfn *kfp);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 575756c9c5b0..6c10dc546c8d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -96,6 +96,13 @@ unsigned int halt_poll_ns_shrink;
 module_param(halt_poll_ns_shrink, uint, 0644);
 EXPORT_SYMBOL_GPL(halt_poll_ns_shrink);
 
+/*
+ * Allow non-refcounted struct pages and non-struct page memory to
+ * be mapped without MMU notifier protection.
+ */
+static bool allow_unsafe_mappings;
+module_param(allow_unsafe_mappings, bool, 0444);
+
 /*
  * Ordering of locks:
  *
@@ -2786,6 +2793,24 @@ static inline int check_user_page_hwpoison(unsigned long addr)
 	return rc == -EHWPOISON;
 }
 
+static kvm_pfn_t kvm_follow_refcounted_pfn(struct kvm_follow_pfn *kfp,
+					   struct page *page)
+{
+	kvm_pfn_t pfn = page_to_pfn(page);
+
+	/*
+	 * FIXME: Ideally, KVM wouldn't pass FOLL_GET to gup() when the caller
+	 * doesn't want to grab a reference, but gup() doesn't support getting
+	 * just the pfn, i.e. FOLL_GET is effectively mandatory.  If that ever
+	 * changes, drop this and simply don't pass FOLL_GET to gup().
+	 */
+	if (!(kfp->flags & FOLL_GET))
+		put_page(page);
+
+	kfp->refcounted_page = page;
+	return pfn;
+}
+
 /*
  * The fast path to get the writable pfn which will be stored in @pfn,
  * true indicates success, otherwise false is returned.  It's also the
@@ -2804,7 +2829,7 @@ static bool hva_to_pfn_fast(struct kvm_follow_pfn *kfp, kvm_pfn_t *pfn)
 		return false;
 
 	if (get_user_page_fast_only(kfp->hva, FOLL_WRITE, page)) {
-		*pfn = page_to_pfn(page[0]);
+		*pfn = kvm_follow_refcounted_pfn(kfp, page[0]);
 		kfp->writable = true;
 		return true;
 	}
@@ -2851,7 +2876,7 @@ static int hva_to_pfn_slow(struct kvm_follow_pfn *kfp, kvm_pfn_t *pfn)
 			page = wpage;
 		}
 	}
-	*pfn = page_to_pfn(page);
+	*pfn = kvm_follow_refcounted_pfn(kfp, page);
 	return npages;
 }
 
@@ -2866,16 +2891,6 @@ static bool vma_is_valid(struct vm_area_struct *vma, bool write_fault)
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
 			       struct kvm_follow_pfn *kfp, kvm_pfn_t *p_pfn)
 {
@@ -2884,6 +2899,7 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
 	pte_t pte;
 	spinlock_t *ptl;
 	bool write_fault = kfp->flags & FOLL_WRITE;
+	struct page *page;
 	int r;
 
 	r = follow_pte(vma->vm_mm, kfp->hva, &ptep, &ptl);
@@ -2908,37 +2924,44 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
 
 	pte = ptep_get(ptep);
 
+	kfp->writable = pte_write(pte);
+	pfn = pte_pfn(pte);
+
+	page = kvm_pfn_to_refcounted_page(pfn);
+
 	if (write_fault && !pte_write(pte)) {
 		pfn = KVM_PFN_ERR_RO_FAULT;
 		goto out;
 	}
 
-	kfp->writable = pte_write(pte);
-	pfn = pte_pfn(pte);
+	if (!page)
+		goto out;
 
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
-	 *
-	 * Certain IO or PFNMAP mappings can be backed with valid
-	 * struct pages, but be allocated without refcounting e.g.,
-	 * tail pages of non-compound higher order allocations, which
-	 * would then underflow the refcount when the caller does the
-	 * required put_page. Don't allow those pages here.
+	 * IO or PFNMAP mappings can be backed with valid struct pages but be
+	 * allocated without refcounting. We need to detect that to make sure we
+	 * only pass refcounted pages to kvm_follow_refcounted_pfn.
 	 */
-	if (!kvm_try_get_pfn(pfn))
-		r = -EFAULT;
+	if (get_page_unless_zero(page))
+		WARN_ON_ONCE(kvm_follow_refcounted_pfn(kfp, page) != pfn);
 
 out:
 	pte_unmap_unlock(ptep, ptl);
-	*p_pfn = pfn;
+
+	/*
+	 * TODO: Remove the first branch once all callers have been
+	 * taught to play nice with non-refcounted struct pages.
+	 */
+	if (page && !kfp->refcounted_page &&
+	    !kfp->allow_non_refcounted_struct_page) {
+		r = -EFAULT;
+	} else if (!kfp->refcounted_page &&
+		   !kfp->guarded_by_mmu_notifier &&
+		   !allow_unsafe_mappings) {
+		r = -EFAULT;
+	} else {
+		*p_pfn = pfn;
+	}
 
 	return r;
 }
@@ -3004,6 +3027,11 @@ kvm_pfn_t hva_to_pfn(struct kvm_follow_pfn *kfp)
 kvm_pfn_t kvm_follow_pfn(struct kvm_follow_pfn *kfp)
 {
 	kfp->writable = false;
+	kfp->refcounted_page = NULL;
+
+	if (WARN_ON_ONCE(!(kfp->flags & FOLL_GET) && !kfp->guarded_by_mmu_notifier))
+		return KVM_PFN_ERR_FAULT;
+
 	kfp->hva = __gfn_to_hva_many(kfp->slot, kfp->gfn, NULL,
 				     kfp->flags & FOLL_WRITE);
 
@@ -3028,9 +3056,10 @@ kvm_pfn_t __gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn,
 	struct kvm_follow_pfn kfp = {
 		.slot = slot,
 		.gfn = gfn,
-		.flags = 0,
+		.flags = FOLL_GET,
 		.atomic = atomic,
 		.try_map_writable = !!writable,
+		.allow_non_refcounted_struct_page = false,
 	};
 
 	if (write_fault)
@@ -3060,8 +3089,9 @@ kvm_pfn_t gfn_to_pfn_prot(struct kvm *kvm, gfn_t gfn, bool write_fault,
 	struct kvm_follow_pfn kfp = {
 		.slot = gfn_to_memslot(kvm, gfn),
 		.gfn = gfn,
-		.flags = write_fault ? FOLL_WRITE : 0,
+		.flags = FOLL_GET | (write_fault ? FOLL_WRITE : 0),
 		.try_map_writable = !!writable,
+		.allow_non_refcounted_struct_page = false,
 	};
 	pfn = kvm_follow_pfn(&kfp);
 	if (writable)
@@ -3075,7 +3105,8 @@ kvm_pfn_t gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn)
 	struct kvm_follow_pfn kfp = {
 		.slot = slot,
 		.gfn = gfn,
-		.flags = FOLL_WRITE,
+		.flags = FOLL_GET | FOLL_WRITE,
+		.allow_non_refcounted_struct_page = false,
 	};
 	return kvm_follow_pfn(&kfp);
 }
@@ -3086,8 +3117,13 @@ kvm_pfn_t gfn_to_pfn_memslot_atomic(const struct kvm_memory_slot *slot, gfn_t gf
 	struct kvm_follow_pfn kfp = {
 		.slot = slot,
 		.gfn = gfn,
-		.flags = FOLL_WRITE,
+		.flags = FOLL_GET | FOLL_WRITE,
 		.atomic = true,
+		/*
+		 * Setting atomic means __kvm_follow_pfn will never make it
+		 * to hva_to_pfn_remapped, so this is vacuously true.
+		 */
+		.allow_non_refcounted_struct_page = true,
 	};
 	return kvm_follow_pfn(&kfp);
 }
diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index 1fb21c2ced5d..6e82062ea203 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -147,8 +147,9 @@ static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_cache *gpc)
 	struct kvm_follow_pfn kfp = {
 		.slot = gpc->memslot,
 		.gfn = gpa_to_gfn(gpc->gpa),
-		.flags = FOLL_WRITE,
+		.flags = FOLL_GET | FOLL_WRITE,
 		.hva = gpc->uhva,
+		.allow_non_refcounted_struct_page = false,
 	};
 
 	lockdep_assert_held(&gpc->refresh_lock);
-- 
2.44.0.rc0.258.g7320e95886-goog


