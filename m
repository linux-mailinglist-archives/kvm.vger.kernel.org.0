Return-Path: <kvm+bounces-10342-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B1F486BF2E
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 03:59:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5F6CB1C216AD
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 02:59:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4545B3BBFA;
	Thu, 29 Feb 2024 02:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="TUm3QJqU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C76B73AC1E
	for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 02:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709175507; cv=none; b=QkX8V4W/MVNGtAMS5978d0hkRRR/kp+Du1yM7vbu2asCPS6wXJx9f2JejYnx8+QUOuZy06dim9j3nv2gKe7VNJ/X1Nc2srTcpBM9wcqCmNtL8OCtlwNkcWR32Bu4+NdaPMInddrN5/dvP2HGZ9T5771tUxnFBswVKCXQR1y+x+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709175507; c=relaxed/simple;
	bh=wTBT90vLQAt7jPRgA9QAvNLDpWe+6cmuHUKhvPwYsbY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c6aRx2JSW4o3g/VURvtdHcZtFc1bSBIAg78bdAmT6jTK/PMpWigrMiWUZ4DQkNRAv0XEgXpKiFmPKQAZPp33chg0aR5+b2EfSXIqL2m/Wsowph4zm4tJRVY/iZSA/3aeJtjfLMTikye1JoNCR6FjhSIGmwg0i+tD720XL5FwKdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=TUm3QJqU; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-6e4d48a5823so322854b3a.1
        for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 18:58:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1709175505; x=1709780305; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=guFGcwgeQ9q19T0MpQj3XFS0S0+Vp/ZSlvHqGbok+lw=;
        b=TUm3QJqUmYeb/qZSBMmtBKc+whEjzhK5xu3GdtOo5gOuv0atgLwyiINVQXQu/E4ikU
         cDYUdPovJvpCQZQwPN+FaG7Sp3vOzekYuDzQDEt/na8DBWK8NW7idxY4PDSVhPTevjBl
         yum3+0ibwYWr/7X95ZBJ/0YFMDoDh+esPK3Pc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709175505; x=1709780305;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=guFGcwgeQ9q19T0MpQj3XFS0S0+Vp/ZSlvHqGbok+lw=;
        b=IvPajg1U9PTPN0UKIKcC2Y/Nj4nVooPoucaGM2sKuLVoWSXQ0g9SC2hiu0GZIbEhb2
         +0DLRl+laFWZaBT43CyVAKrqvIlzAKsILybELW1qxmag90BYNhql4/BBDAg/pjbcHipd
         4QcR931Gw3xxxIG2hh8d4lpvsvX7/o9MjOjFNEWR6qfIY46wI3P1By+QyYNf/CkOBkFM
         bj7TJs9YMfg7wES4fprzRV0yCX07BlpJB4pUNC0PIfxkboZEzsptAo5MglsvOGhfvezl
         0eqy7Yt5mDPWhAqQQJYPYwC8hU565978QD2Jl+sEuVr7pkDfXDwGpvGIoJJ3nv8XVcmx
         dk6w==
X-Forwarded-Encrypted: i=1; AJvYcCUU0AxAa79RIdCfmb7n8ZwcKFtZ29ZcRX05bqZBnvSdjkTN3sCY0AbawCBqbXQtHhgk0fiwmCiS95FtfUUpX3iLL40m
X-Gm-Message-State: AOJu0Yw9Fa9jNCBAsjRz2SUAXy53E2FwTa4JL/V8hGznrPIw1KhUQpP+
	P5Uu8QZ43lXbctdmTSxqzSzpVGD5xQuF57jzEs2BR7GoxfISdaRZFm1Mo1p3Xg==
X-Google-Smtp-Source: AGHT+IG/RLoeouoKaD41YPHYi3DnsdUmf+ZF9Y41z3ijesgZgEI1arDthFnKjFggH35c9NSPvQ8V0w==
X-Received: by 2002:a05:6a00:c87:b0:6e5:3b0e:9f14 with SMTP id a7-20020a056a000c8700b006e53b0e9f14mr1271659pfv.13.1709175505093;
        Wed, 28 Feb 2024 18:58:25 -0800 (PST)
Received: from localhost ([2401:fa00:8f:203:f51:e79e:9056:77ea])
        by smtp.gmail.com with UTF8SMTPSA id u32-20020a056a0009a000b006e144ec8eafsm153448pfg.119.2024.02.28.18.58.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Feb 2024 18:58:24 -0800 (PST)
From: David Stevens <stevensd@chromium.org>
X-Google-Original-From: David Stevens <stevensd@google.com>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: Yu Zhang <yu.c.zhang@linux.intel.com>,
	Isaku Yamahata <isaku.yamahata@gmail.com>,
	Zhi Wang <zhi.wang.linux@gmail.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	David Stevens <stevensd@chromium.org>
Subject: [PATCH v11 4/8] KVM: mmu: Improve handling of non-refcounted pfns
Date: Thu, 29 Feb 2024 11:57:55 +0900
Message-ID: <20240229025759.1187910-5-stevensd@google.com>
X-Mailer: git-send-email 2.44.0.rc1.240.g4c46232300-goog
In-Reply-To: <20240229025759.1187910-1-stevensd@google.com>
References: <20240229025759.1187910-1-stevensd@google.com>
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
 include/linux/kvm_host.h |  29 +++++++++++
 virt/kvm/kvm_main.c      | 104 +++++++++++++++++++++++++--------------
 virt/kvm/pfncache.c      |   3 +-
 3 files changed, 99 insertions(+), 37 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 290db5133c36..66516088bb0a 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1219,10 +1219,39 @@ struct kvm_follow_pfn {
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
+	 * This allows callers to continue to rely on the legacy behavior
+	 * where pfs returned by gfn_to_pfn can be safely passed to
+	 * kvm_release_pfn without worrying about corrupting the refcount of
+	 * non-refcounted pages.
+	 *
+	 * Callers that opt into non-refcount struct pages need to track
+	 * whether or not the returned pages are refcounted and avoid touching
+	 * them when they are not. Some architectures may not have enough
+	 * free space in PTEs to do this.
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
index 575756c9c5b0..984bcf8511e7 100644
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
@@ -2908,37 +2924,40 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
 
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
@@ -3004,6 +3023,11 @@ kvm_pfn_t hva_to_pfn(struct kvm_follow_pfn *kfp)
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
 
@@ -3028,9 +3052,10 @@ kvm_pfn_t __gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn,
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
@@ -3060,8 +3085,9 @@ kvm_pfn_t gfn_to_pfn_prot(struct kvm *kvm, gfn_t gfn, bool write_fault,
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
@@ -3075,7 +3101,8 @@ kvm_pfn_t gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn)
 	struct kvm_follow_pfn kfp = {
 		.slot = slot,
 		.gfn = gfn,
-		.flags = FOLL_WRITE,
+		.flags = FOLL_GET | FOLL_WRITE,
+		.allow_non_refcounted_struct_page = false,
 	};
 	return kvm_follow_pfn(&kfp);
 }
@@ -3086,8 +3113,13 @@ kvm_pfn_t gfn_to_pfn_memslot_atomic(const struct kvm_memory_slot *slot, gfn_t gf
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
2.44.0.rc1.240.g4c46232300-goog


