Return-Path: <kvm+bounces-7895-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D8D94847DE5
	for <lists+kvm@lfdr.de>; Sat,  3 Feb 2024 01:35:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8FD3E292284
	for <lists+kvm@lfdr.de>; Sat,  3 Feb 2024 00:35:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEEB26FC3;
	Sat,  3 Feb 2024 00:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yuxm8q/g"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EDB46FA7
	for <kvm@vger.kernel.org>; Sat,  3 Feb 2024 00:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706920523; cv=none; b=sMVQ1Jb/PPYpSMwJS3cvXvGHq2Onm23mYXrgFIA1Mos97eZ2KwJs6rIKS0caILYNcqm7vpA36GlqtZWOPy+63oaeeHfS9Gg/dcb2CjlEhOgwgSHLb/UWhJvtwrs4JPwivy89FSWXwNDaSe4y47LlptHGy67AE/+17v9zjJkqeXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706920523; c=relaxed/simple;
	bh=+W0x0qmDTWJBFhcBNY7FAOGQpUdjN0SQbJHn4/GsvUM=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=BEW0mkJhJeII3YwosdHSAh8SLFWTNuMBU2EUVyY/Xk23hndt9tQulT7XzoGMYdNugark7fP7IYXFdBOZ0LmuVtctd94Ok/5J/y3TcqRt4Twzo1DNV1isJJn3qozQve0uch582Siua8oePpIZxZdFmKft9ZxxDMd9r2zX8eh26gY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yuxm8q/g; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-29608f00cbbso2542580a91.2
        for <kvm@vger.kernel.org>; Fri, 02 Feb 2024 16:35:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706920521; x=1707525321; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w8/W/QW1OnGWzQANjW/wBiiWNdyxuosNQc6VIGtK4Bs=;
        b=yuxm8q/g7wRZaYvJ84zNlOADVgcgwiGoJHiirIKTuSbufO7jiTG680Gf6z+YHy4YSK
         WZ8e/Us3lRnPdqOT1YEyclsLJtmJ7CjQIR14ZmGtQ6i9d745E1OrGxj5BXzbX+ARmiGe
         n/iVcKddvlF/55gmQlkU9iJ6qDkkZf+OPbjmVM72hvGqcwppRCM+ohhJDr/frsG5Ox1D
         YLnLXcY6OXok11Tc4KynmoJrlfYRaFgUFJqVtIw8Dns8ETUH55cHwRaA/QwT/bbL4b5Q
         e/xpSxpU4n/bNAqnVKUaDdn2F943yczm72eBfmUi+tvBOxSVT0O9vRH7PsMnUcUdiLtq
         TTXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706920521; x=1707525321;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=w8/W/QW1OnGWzQANjW/wBiiWNdyxuosNQc6VIGtK4Bs=;
        b=rd/DLCXjiDkmWERXXMjsHcDk4zy+vDFh36FOfMF1lfxHzRixRQkN8XSp/2/4oShC+C
         AnrKdxlRP3e2jHYeW3dh1xE6WzYhYNisFsLDUpznBtSNFgEXrlruWAJJBg6EDnwVHLfK
         CXN03cCffQu730+ERo37+Hi+vpvEmIR9ypay4Sp32eMXHDnUbf16PfskXJmvmn95E5Bc
         MI9+xQDlsAp9oVqzeU2HZCPRQ21AoCg74YfmZk4NP8ITlHcb671jFSBgLkax2WXxt433
         6mRnUqzQQPw91YETngxfi9IoJe6fQidU/c6+jo3dvgnFcY3WvXhBcj/3SBPCdJSC0URm
         1Wbg==
X-Gm-Message-State: AOJu0YxN2Zn281a9GtYKcYDbkmP3BwPHCXasVuozg7SBFXAuZFHabrzb
	idteKV4+0QOl+WWo0Tyf4KouDCLdbz377VlNc6l4q3b/cieuWCZT+QPE0zPDum2XK0BL/kpgYEd
	JyQ==
X-Google-Smtp-Source: AGHT+IGQ+vZkDSPZfozDOkYUmCM0pGO67d9wOLL8i5LulF6+4vDmWr6layMlPRZzcYK65MkYyIWpX1/esfg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:5108:b0:296:5baa:63e with SMTP id
 sc8-20020a17090b510800b002965baa063emr75980pjb.8.1706920520809; Fri, 02 Feb
 2024 16:35:20 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  2 Feb 2024 16:35:18 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.43.0.594.gd9cf4e227d-goog
Message-ID: <20240203003518.387220-1-seanjc@google.com>
Subject: [PATCH v3] KVM: x86/mmu: Retry fault before acquiring mmu_lock if
 mapping is changing
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yan Zhao <yan.y.zhao@intel.com>, Kai Huang <kai.huang@intel.com>, 
	Yuan Yao <yuan.yao@linux.intel.com>, Xu Yilun <yilun.xu@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

Retry page faults without acquiring mmu_lock if the resolved gfn is covered
by an active invalidation.  Contending for mmu_lock is especially
problematic on preemptible kernels as the mmu_notifier invalidation task
will yield mmu_lock (see rwlock_needbreak()), delay the in-progress
invalidation, and ultimately increase the latency of resolving the page
fault.  And in the worst case scenario, yielding will be accompanied by a
remote TLB flush, e.g. if the invalidation covers a large range of memory
and vCPUs are accessing addresses that were already zapped.

Alternatively, the yielding issue could be mitigated by teaching KVM's MMU
iterators to perform more work before yielding, but that wouldn't solve
the lock contention and would negatively affect scenarios where a vCPU is
trying to fault in an address that is NOT covered by the in-progress
invalidation.

Add a dedicated lockess version of the range-based retry check to avoid
false positives on the sanity check on start+end WARN, and so that it's
super obvious that checking for a racing invalidation without holding
mmu_lock is unsafe (though obviously useful).

Wrap mmu_invalidate_in_progress in READ_ONCE() to ensure that pre-checking
invalidation in a loop won't put KVM into an infinite loop, e.g. due to
caching the in-progress flag and never seeing it go to '0'.

Force a load of mmu_invalidate_seq as well, even though it isn't strictly
necessary to avoid an infinite loop, as doing so improves the probability
that KVM will detect an invalidation that already completed before
acquiring mmu_lock and bailing anyways.

Do the pre-check even for non-preemptible kernels, as waiting to detect
the invalidation until mmu_lock is held guarantees the vCPU will observe
the worst case latency in terms of handling the fault, and can generate
even more mmu_lock contention.  E.g. the vCPU will acquire mmu_lock,
detect retry, drop mmu_lock, re-enter the guest, retake the fault, and
eventually re-acquire mmu_lock.  This behavior is also why there are no
new starvation issues due to losing the fairness guarantees provided by
rwlocks: if the vCPU needs to retry, it _must_ drop mmu_lock, i.e. waiting
on mmu_lock doesn't guarantee forward progress in the face of _another_
mmu_notifier invalidation event.

Note, adding READ_ONCE() isn't entirely free, e.g. on x86, the READ_ONCE()
may generate a load into a register instead of doing a direct comparison
(MOV+TEST+Jcc instead of CMP+Jcc), but practically speaking the added cost
is a few bytes of code and maaaaybe a cycle or three.

Reported-by: Yan Zhao <yan.y.zhao@intel.com>
Closes: https://lore.kernel.org/all/ZNnPF4W26ZbAyGto@yzhao56-desk.sh.intel.com
Cc: Kai Huang <kai.huang@intel.com>
Cc: Yan Zhao <yan.y.zhao@intel.com>
Cc: Yuan Yao <yuan.yao@linux.intel.com>
Cc: Xu Yilun <yilun.xu@linux.intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---

Kai and Yan, I dropped your reviews as this changed just enough to make me
uncomfortable carrying reviews over from the previous version.

v3:
 - Release the pfn, i.e. put the struct page reference if one was held,
   as the caller doesn't expect to get a reference on "failure". [Yuan]
 - Fix a typo in the comment.

v2:
 - Introduce a dedicated helper and collapse to a single patch (because
   adding an unused helper would be quite silly).
 - Add a comment to explain the "unsafe" check in kvm_faultin_pfn(). [Kai]
 - Add Kai's Ack.

v1: https://lore.kernel.org/all/20230825020733.2849862-1-seanjc@google.com

 arch/x86/kvm/mmu/mmu.c   | 19 +++++++++++++++++++
 include/linux/kvm_host.h | 26 ++++++++++++++++++++++++++
 2 files changed, 45 insertions(+)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 3c193b096b45..8ce9898914f1 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4415,6 +4415,25 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 	if (unlikely(!fault->slot))
 		return kvm_handle_noslot_fault(vcpu, fault, access);
 
+	/*
+	 * Pre-check for a relevant mmu_notifier invalidation event prior to
+	 * acquiring mmu_lock.  If there is an in-progress invalidation and the
+	 * kernel allows preemption, the invalidation task may drop mmu_lock
+	 * and yield in response to mmu_lock being contended, which is *very*
+	 * counter-productive as this vCPU can't actually make forward progress
+	 * until the invalidation completes.  This "unsafe" check can get false
+	 * negatives, i.e. KVM needs to re-check after acquiring mmu_lock.
+	 *
+	 * Do the pre-check even for non-preemtible kernels, i.e. even if KVM
+	 * will never yield mmu_lock in response to contention, as this vCPU is
+	 * *guaranteed* to need to retry, i.e. waiting until mmu_lock is held
+	 * to detect retry guarantees the worst case latency for the vCPU.
+	 */
+	if (mmu_invalidate_retry_gfn_unsafe(vcpu->kvm, fault->mmu_seq, fault->gfn)) {
+		kvm_release_pfn_clean(fault->pfn);
+		return RET_PF_RETRY;
+	}
+
 	return RET_PF_CONTINUE;
 }
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 7e7fd25b09b3..179df96b20f8 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2031,6 +2031,32 @@ static inline int mmu_invalidate_retry_gfn(struct kvm *kvm,
 		return 1;
 	return 0;
 }
+
+/*
+ * This lockless version of the range-based retry check *must* be paired with a
+ * call to the locked version after acquiring mmu_lock, i.e. this is safe to
+ * use only as a pre-check to avoid contending mmu_lock.  This version *will*
+ * get false negatives and false positives.
+ */
+static inline bool mmu_invalidate_retry_gfn_unsafe(struct kvm *kvm,
+						   unsigned long mmu_seq,
+						   gfn_t gfn)
+{
+	/*
+	 * Use READ_ONCE() to ensure the in-progress flag and sequence counter
+	 * are always read from memory, e.g. so that checking for retry in a
+	 * loop won't result in an infinite retry loop.  Don't force loads for
+	 * start+end, as the key to avoiding infinite retry loops is observing
+	 * the 1=>0 transition of in-progress, i.e. getting false negatives
+	 * due to stale start+end values is acceptable.
+	 */
+	if (unlikely(READ_ONCE(kvm->mmu_invalidate_in_progress)) &&
+	    gfn >= kvm->mmu_invalidate_range_start &&
+	    gfn < kvm->mmu_invalidate_range_end)
+		return true;
+
+	return READ_ONCE(kvm->mmu_invalidate_seq) != mmu_seq;
+}
 #endif
 
 #ifdef CONFIG_HAVE_KVM_IRQ_ROUTING

base-commit: 60eedcfceda9db46f1b333e5e1aa9359793f04fb
-- 
2.43.0.594.gd9cf4e227d-goog


