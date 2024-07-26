Return-Path: <kvm+bounces-22380-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E98393DB76
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2024 01:59:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A11EC1F217C8
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 23:59:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FA99171E53;
	Fri, 26 Jul 2024 23:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cr2ICY4Z"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94E35171086
	for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 23:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722037994; cv=none; b=ZDtT8sTEds+03qs8PZE5L8keYT7oaW/xpI3HGaAWAi5ZCcXIpdonwphDAGlP+4tpkOZh3vVEujS9Y3E8O0TvF7SJLGfwiQV1NTKExjzCeiSwzgCZGNFuRveRbcCVm/PklqtN2firw0RmIDxlM8wn5ZhqvEbbU5MPhll0Ji4/AEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722037994; c=relaxed/simple;
	bh=J4pFwXscwUHwWUzewM7flw7KODfftvhwfJwFPSCTX7s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ONXQfUhJ4iS8Yi3H+Gx15XlX77BU4ROpTLrSRcbrnLGOrIbbEC5zG3IyiJc6Acg0sqyQHSUmkO5+4SrMQ2mWs47JqbQw7k/1FNSjBz7eIgEhkVos/3MwI8m0/LyQTC8GDOGQbaZjPfRoWmnccvpecfXQL1HeKicE4YVEnsQatlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cr2ICY4Z; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-70d14d11f42so1333844b3a.2
        for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 16:53:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722037992; x=1722642792; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=dQWjrE4jvr4hAuT3wkfi5A++VZy4br+IJ16QmEjL6no=;
        b=cr2ICY4ZxkHTQlQlc+ZFVEJfGSX9nofYwyNDBe4AsE1MIR+USR1fnRvv2objpTD44U
         N0ymUXcQsLcRU/VWiI0vR982FrmxZn/BHi1+0zcBlHT0eJbJoxpenUPQDWNuS5Ufwqk5
         +HpRZvKYYdzCEu0R13ESw+oKVeBRcVe2X2WBrKL2qsfNamCsZkxbomK6drk+Ca5lvUcv
         kPokUVrhwqBdf7Fn2o0i1crMZdg93uJzmot2HLQp1vXP85WV3nRD1/JC2SAbncc41j5K
         pB2KPUIf9rjrSrV3v3mTKZdE98/OySoNU/mbwtCdz7xGOd7l+7m+xOLvXa/ep3f0sn9r
         2U0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722037992; x=1722642792;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dQWjrE4jvr4hAuT3wkfi5A++VZy4br+IJ16QmEjL6no=;
        b=lTFdq4M+VxDPKV16dRR+uy8qHJrZ2jIZBhPMjEGAxzKQsGhSTxPpsJpbxD2TdKXjMB
         CNf/c4VpsO+L86bWvcrM7nKVRyDNMCEwhXUvCmDG2b14v1bIb+6tfgMbqf2w5gwMciCb
         uoL06ogqv58t3KHsfUASn9ZyJ8CdUYTYhL7qbFzJ5DDX1Mr2y7AVwl5d8Hc0ZqF5CKzF
         bOvOIzfQV/oRwW2/hp1MMB5mQkqAp+gLpI4e9fCQL0bpVsL8QCACr4Gg+82Gztl3N6t6
         lgXAjQFfPEmh1IGmnnCCPflMnnH81regxpoKlrTnShGS4jE3+5gPN7R64YitCwa5verX
         y7kw==
X-Gm-Message-State: AOJu0YzGZW8KS8ARfltoWn1D7B6dfyhR2AJlgRXhfTKPZ2DHyB6Ra1y+
	b8YB3HnT72MZfDo8bYtQNkDsQ+XUMHS2FKlWF7BhQJEELVi28M9lrmI+owMcHMZc76EV2w67Tn0
	f7g==
X-Google-Smtp-Source: AGHT+IF64dFMfvjIHcwYUOw27WNHnHBsH0QN8lopZ3C9XrG9iD55Iu+E93imY7RdCCfaNaEEdqDD7q46L3E=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:66e5:b0:70d:1e28:1c33 with SMTP id
 d2e1a72fcca58-70ece9ecd04mr9965b3a.1.1722037991679; Fri, 26 Jul 2024 16:53:11
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jul 2024 16:51:26 -0700
In-Reply-To: <20240726235234.228822-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240726235234.228822-18-seanjc@google.com>
Subject: [PATCH v12 17/84] KVM: Introduce kvm_follow_pfn() to eventually
 replace "gfn_to_pfn" APIs
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	David Matlack <dmatlack@google.com>, David Stevens <stevensd@chromium.org>
Content-Type: text/plain; charset="UTF-8"

From: David Stevens <stevensd@chromium.org>

Introduce kvm_follow_pfn() to eventually supplant the various "gfn_to_pfn"
APIs, albeit by adding more wrappers.  The primary motivation of the new
helper is to pass a structure instead of an ever changing set of parameters,
e.g. so that tweaking the behavior, inputs, and/or outputs of the "to pfn"
helpers doesn't require churning half of KVM.

In the more distant future, the APIs exposed to arch code could also
follow suit, e.g. by adding something akin to x86's "struct kvm_page_fault"
when faulting in guest memory.  But for now, the goal is purely to clean
up KVM's "internal" MMU code.

As part of the conversion, replace the write_fault, interruptible, and
no-wait boolean flags with FOLL_WRITE, FOLL_INTERRUPTIBLE, and FOLL_NOWAIT
respectively.  Collecting the various FOLL_* flags into a single field
will again ease the pain of passing new flags.

Signed-off-by: David Stevens <stevensd@chromium.org>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 166 +++++++++++++++++++++++---------------------
 virt/kvm/kvm_mm.h   |  20 +++++-
 virt/kvm/pfncache.c |   9 ++-
 3 files changed, 111 insertions(+), 84 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 6e3bb202c1b3..56c2d11761e0 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2761,8 +2761,7 @@ static inline int check_user_page_hwpoison(unsigned long addr)
  * true indicates success, otherwise false is returned.  It's also the
  * only part that runs if we can in atomic context.
  */
-static bool hva_to_pfn_fast(unsigned long addr, bool write_fault,
-			    bool *writable, kvm_pfn_t *pfn)
+static bool hva_to_pfn_fast(struct kvm_follow_pfn *kfp, kvm_pfn_t *pfn)
 {
 	struct page *page[1];
 
@@ -2771,14 +2770,13 @@ static bool hva_to_pfn_fast(unsigned long addr, bool write_fault,
 	 * or the caller allows to map a writable pfn for a read fault
 	 * request.
 	 */
-	if (!(write_fault || writable))
+	if (!((kfp->flags & FOLL_WRITE) || kfp->map_writable))
 		return false;
 
-	if (get_user_page_fast_only(addr, FOLL_WRITE, page)) {
+	if (get_user_page_fast_only(kfp->hva, FOLL_WRITE, page)) {
 		*pfn = page_to_pfn(page[0]);
-
-		if (writable)
-			*writable = true;
+		if (kfp->map_writable)
+			*kfp->map_writable = true;
 		return true;
 	}
 
@@ -2789,8 +2787,7 @@ static bool hva_to_pfn_fast(unsigned long addr, bool write_fault,
  * The slow path to get the pfn of the specified host virtual address,
  * 1 indicates success, -errno is returned if error is detected.
  */
-static int hva_to_pfn_slow(unsigned long addr, bool no_wait, bool write_fault,
-			   bool interruptible, bool *writable, kvm_pfn_t *pfn)
+static int hva_to_pfn_slow(struct kvm_follow_pfn *kfp, kvm_pfn_t *pfn)
 {
 	/*
 	 * When a VCPU accesses a page that is not mapped into the secondary
@@ -2803,34 +2800,30 @@ static int hva_to_pfn_slow(unsigned long addr, bool no_wait, bool write_fault,
 	 * Note that get_user_page_fast_only() and FOLL_WRITE for now
 	 * implicitly honor NUMA hinting faults and don't need this flag.
 	 */
-	unsigned int flags = FOLL_HWPOISON | FOLL_HONOR_NUMA_FAULT;
-	struct page *page;
+	unsigned int flags = FOLL_HWPOISON | FOLL_HONOR_NUMA_FAULT | kfp->flags;
+	struct page *page, *wpage;
 	int npages;
 
-	if (writable)
-		*writable = write_fault;
-
-	if (write_fault)
-		flags |= FOLL_WRITE;
-	if (no_wait)
-		flags |= FOLL_NOWAIT;
-	if (interruptible)
-		flags |= FOLL_INTERRUPTIBLE;
-
-	npages = get_user_pages_unlocked(addr, 1, &page, flags);
+	npages = get_user_pages_unlocked(kfp->hva, 1, &page, flags);
 	if (npages != 1)
 		return npages;
 
+	if (!kfp->map_writable)
+		goto out;
+
+	if (kfp->flags & FOLL_WRITE) {
+		*kfp->map_writable = true;
+		goto out;
+	}
+
 	/* map read fault as writable if possible */
-	if (unlikely(!write_fault) && writable) {
-		struct page *wpage;
-
-		if (get_user_page_fast_only(addr, FOLL_WRITE, &wpage)) {
-			*writable = true;
-			put_page(page);
-			page = wpage;
-		}
+	if (get_user_page_fast_only(kfp->hva, FOLL_WRITE, &wpage)) {
+		*kfp->map_writable = true;
+		put_page(page);
+		page = wpage;
 	}
+
+out:
 	*pfn = page_to_pfn(page);
 	return npages;
 }
@@ -2857,23 +2850,23 @@ static int kvm_try_get_pfn(kvm_pfn_t pfn)
 }
 
 static int hva_to_pfn_remapped(struct vm_area_struct *vma,
-			       unsigned long addr, bool write_fault,
-			       bool *writable, kvm_pfn_t *p_pfn)
+			       struct kvm_follow_pfn *kfp, kvm_pfn_t *p_pfn)
 {
 	kvm_pfn_t pfn;
 	pte_t *ptep;
 	pte_t pte;
 	spinlock_t *ptl;
+	bool write_fault = kfp->flags & FOLL_WRITE;
 	int r;
 
-	r = follow_pte(vma, addr, &ptep, &ptl);
+	r = follow_pte(vma, kfp->hva, &ptep, &ptl);
 	if (r) {
 		/*
 		 * get_user_pages fails for VM_IO and VM_PFNMAP vmas and does
 		 * not call the fault handler, so do it here.
 		 */
 		bool unlocked = false;
-		r = fixup_user_fault(current->mm, addr,
+		r = fixup_user_fault(current->mm, kfp->hva,
 				     (write_fault ? FAULT_FLAG_WRITE : 0),
 				     &unlocked);
 		if (unlocked)
@@ -2881,7 +2874,7 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
 		if (r)
 			return r;
 
-		r = follow_pte(vma, addr, &ptep, &ptl);
+		r = follow_pte(vma, kfp->hva, &ptep, &ptl);
 		if (r)
 			return r;
 	}
@@ -2893,8 +2886,8 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
 		goto out;
 	}
 
-	if (writable)
-		*writable = pte_write(pte);
+	if (kfp->map_writable)
+		*kfp->map_writable = pte_write(pte);
 	pfn = pte_pfn(pte);
 
 	/*
@@ -2924,22 +2917,7 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
 	return r;
 }
 
-/*
- * Pin guest page in memory and return its pfn.
- * @addr: host virtual address which maps memory to the guest
- * @interruptible: whether the process can be interrupted by non-fatal signals
- * @no_wait: whether or not this function need to wait IO complete if the
- *	     host page is not in the memory
- * @write_fault: whether we should get a writable host page
- * @writable: whether it allows to map a writable host page for !@write_fault
- *
- * The function will map a writable host page for these two cases:
- * 1): @write_fault = true
- * 2): @write_fault = false && @writable, @writable will tell the caller
- *     whether the mapping is writable.
- */
-kvm_pfn_t hva_to_pfn(unsigned long addr, bool interruptible, bool no_wait,
-		     bool write_fault, bool *writable)
+kvm_pfn_t hva_to_pfn(struct kvm_follow_pfn *kfp)
 {
 	struct vm_area_struct *vma;
 	kvm_pfn_t pfn;
@@ -2947,11 +2925,10 @@ kvm_pfn_t hva_to_pfn(unsigned long addr, bool interruptible, bool no_wait,
 
 	might_sleep();
 
-	if (hva_to_pfn_fast(addr, write_fault, writable, &pfn))
+	if (hva_to_pfn_fast(kfp, &pfn))
 		return pfn;
 
-	npages = hva_to_pfn_slow(addr, no_wait, write_fault, interruptible,
-				 writable, &pfn);
+	npages = hva_to_pfn_slow(kfp, &pfn);
 	if (npages == 1)
 		return pfn;
 	if (npages == -EINTR)
@@ -2959,24 +2936,25 @@ kvm_pfn_t hva_to_pfn(unsigned long addr, bool interruptible, bool no_wait,
 
 	mmap_read_lock(current->mm);
 	if (npages == -EHWPOISON ||
-	    (!no_wait && check_user_page_hwpoison(addr))) {
+	    (!(kfp->flags & FOLL_NOWAIT) && check_user_page_hwpoison(kfp->hva))) {
 		pfn = KVM_PFN_ERR_HWPOISON;
 		goto exit;
 	}
 
 retry:
-	vma = vma_lookup(current->mm, addr);
+	vma = vma_lookup(current->mm, kfp->hva);
 
 	if (vma == NULL)
 		pfn = KVM_PFN_ERR_FAULT;
 	else if (vma->vm_flags & (VM_IO | VM_PFNMAP)) {
-		r = hva_to_pfn_remapped(vma, addr, write_fault, writable, &pfn);
+		r = hva_to_pfn_remapped(vma, kfp, &pfn);
 		if (r == -EAGAIN)
 			goto retry;
 		if (r < 0)
 			pfn = KVM_PFN_ERR_FAULT;
 	} else {
-		if (no_wait && vma_is_valid(vma, write_fault))
+		if ((kfp->flags & FOLL_NOWAIT) &&
+		    vma_is_valid(vma, kfp->flags & FOLL_WRITE))
 			pfn = KVM_PFN_ERR_NEEDS_IO;
 		else
 			pfn = KVM_PFN_ERR_FAULT;
@@ -2986,41 +2964,69 @@ kvm_pfn_t hva_to_pfn(unsigned long addr, bool interruptible, bool no_wait,
 	return pfn;
 }
 
+static kvm_pfn_t kvm_follow_pfn(struct kvm_follow_pfn *kfp)
+{
+	kfp->hva = __gfn_to_hva_many(kfp->slot, kfp->gfn, NULL,
+				     kfp->flags & FOLL_WRITE);
+
+	if (kfp->hva == KVM_HVA_ERR_RO_BAD)
+		return KVM_PFN_ERR_RO_FAULT;
+
+	if (kvm_is_error_hva(kfp->hva))
+		return KVM_PFN_NOSLOT;
+
+	if (memslot_is_readonly(kfp->slot) && kfp->map_writable) {
+		*kfp->map_writable = false;
+		kfp->map_writable = NULL;
+	}
+
+	return hva_to_pfn(kfp);
+}
+
 kvm_pfn_t __gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn,
 			       bool interruptible, bool no_wait,
 			       bool write_fault, bool *writable)
 {
-	unsigned long addr = __gfn_to_hva_many(slot, gfn, NULL, write_fault);
-
-	if (kvm_is_error_hva(addr)) {
-		if (writable)
-			*writable = false;
-
-		return addr == KVM_HVA_ERR_RO_BAD ? KVM_PFN_ERR_RO_FAULT :
-						    KVM_PFN_NOSLOT;
-	}
-
-	/* Do not map writable pfn in the readonly memslot. */
-	if (writable && memslot_is_readonly(slot)) {
-		*writable = false;
-		writable = NULL;
-	}
-
-	return hva_to_pfn(addr, interruptible, no_wait, write_fault, writable);
+	struct kvm_follow_pfn kfp = {
+		.slot = slot,
+		.gfn = gfn,
+		.map_writable = writable,
+	};
+
+	if (write_fault)
+		kfp.flags |= FOLL_WRITE;
+	if (no_wait)
+		kfp.flags |= FOLL_NOWAIT;
+	if (interruptible)
+		kfp.flags |= FOLL_INTERRUPTIBLE;
+
+	return kvm_follow_pfn(&kfp);
 }
 EXPORT_SYMBOL_GPL(__gfn_to_pfn_memslot);
 
 kvm_pfn_t gfn_to_pfn_prot(struct kvm *kvm, gfn_t gfn, bool write_fault,
 		      bool *writable)
 {
-	return __gfn_to_pfn_memslot(gfn_to_memslot(kvm, gfn), gfn, false, false,
-				    write_fault, writable);
+	struct kvm_follow_pfn kfp = {
+		.slot = gfn_to_memslot(kvm, gfn),
+		.gfn = gfn,
+		.flags = write_fault ? FOLL_WRITE : 0,
+		.map_writable = writable,
+	};
+
+	return kvm_follow_pfn(&kfp);
 }
 EXPORT_SYMBOL_GPL(gfn_to_pfn_prot);
 
 kvm_pfn_t gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn)
 {
-	return __gfn_to_pfn_memslot(slot, gfn, false, false, true, NULL);
+	struct kvm_follow_pfn kfp = {
+		.slot = slot,
+		.gfn = gfn,
+		.flags = FOLL_WRITE,
+	};
+
+	return kvm_follow_pfn(&kfp);
 }
 EXPORT_SYMBOL_GPL(gfn_to_pfn_memslot);
 
diff --git a/virt/kvm/kvm_mm.h b/virt/kvm/kvm_mm.h
index 51f3fee4ca3f..d5a215958f06 100644
--- a/virt/kvm/kvm_mm.h
+++ b/virt/kvm/kvm_mm.h
@@ -20,8 +20,24 @@
 #define KVM_MMU_UNLOCK(kvm)		spin_unlock(&(kvm)->mmu_lock)
 #endif /* KVM_HAVE_MMU_RWLOCK */
 
-kvm_pfn_t hva_to_pfn(unsigned long addr, bool interruptible, bool no_wait,
-		     bool write_fault, bool *writable);
+
+struct kvm_follow_pfn {
+	const struct kvm_memory_slot *slot;
+	const gfn_t gfn;
+
+	unsigned long hva;
+
+	/* FOLL_* flags modifying lookup behavior, e.g. FOLL_WRITE. */
+	unsigned int flags;
+
+	/*
+	 * If non-NULL, try to get a writable mapping even for a read fault.
+	 * Set to true if a writable mapping was obtained.
+	 */
+	bool *map_writable;
+};
+
+kvm_pfn_t hva_to_pfn(struct kvm_follow_pfn *kfp);
 
 #ifdef CONFIG_HAVE_KVM_PFNCACHE
 void gfn_to_pfn_cache_invalidate_start(struct kvm *kvm,
diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index 32dc61f48c81..067daf9ad6ef 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -159,6 +159,12 @@ static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_cache *gpc)
 	kvm_pfn_t new_pfn = KVM_PFN_ERR_FAULT;
 	void *new_khva = NULL;
 	unsigned long mmu_seq;
+	struct kvm_follow_pfn kfp = {
+		.slot = gpc->memslot,
+		.gfn = gpa_to_gfn(gpc->gpa),
+		.flags = FOLL_WRITE,
+		.hva = gpc->uhva,
+	};
 
 	lockdep_assert_held(&gpc->refresh_lock);
 
@@ -197,8 +203,7 @@ static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_cache *gpc)
 			cond_resched();
 		}
 
-		/* We always request a writable mapping */
-		new_pfn = hva_to_pfn(gpc->uhva, false, false, true, NULL);
+		new_pfn = hva_to_pfn(&kfp);
 		if (is_error_noslot_pfn(new_pfn))
 			goto out_error;
 
-- 
2.46.0.rc1.232.g9752f9e123-goog


