Return-Path: <kvm+bounces-5964-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F2948829207
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 02:21:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4EE1A1F21502
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 01:21:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E58F43C32;
	Wed, 10 Jan 2024 01:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ebmo6RU7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB0572915
	for <kvm@vger.kernel.org>; Wed, 10 Jan 2024 01:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-5cdbf9fd702so3005459a12.0
        for <kvm@vger.kernel.org>; Tue, 09 Jan 2024 17:20:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704849648; x=1705454448; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=i/U8higRWLYYPzuwVChe68lacTt9MhufBB3K4ClFKBg=;
        b=ebmo6RU7Ge32E+O2dWvvyrpz2Jq+5Sb9EDb0cPwYCWkPJmnDYw37VjnUBHUx98obLv
         x7IRY7bnIP+ERMM/SWE1kgCeJHjtyz+aM0HRIRU9R34iSvfeUVIeTX7iJjNftgCJ8T6b
         6GGpQHL6/0W96qXaibsBCMtI/LFtuDfKUKxB4MZIk30OqD/DblIUu4NOhbjrtWlKoz6W
         rMP1etxzHt8ucKcRHZyCJ/4P25Tdg0gs08E2KMeUhb8WTGTujqarM0qtT5r89Q0cNq4A
         jictJwOrLL7uSxxQp/UkkdeZY3wK5keYD1FYw9GJDxsq0Gsf3iakCUnYUequXhWfXNzv
         2SvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704849648; x=1705454448;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=i/U8higRWLYYPzuwVChe68lacTt9MhufBB3K4ClFKBg=;
        b=EV8dAAbV+7ra4ZV5KPNO66Cr57DcCgm+w7KwhH2pzicXONRytYecjPjIJEoNH/Cepg
         AVqra09zUK+R5J/10wM9/2BOQO+ByTjrpmgXZB/tUocTlaapnHCObVmIByn7edovybm/
         T3i5uKRLbDsRXCD0bPRl3IB8GTifVaG2njhlU/M0is3ItZJMKMwjBFauYVJDwoTJdIHy
         S0WhuJZSymRzEWVRojMrCvFIkZrw3qWs18BrNQyHRZT8SFIi4ClcUjrR9gy6Y0t9jJt1
         4ET5wBd7QitV4mnxM7mi5x4owq4rNfPL2VuXNWbPYm2IrX7w1i6ASjSugGZM73G4Ml7W
         /BnQ==
X-Gm-Message-State: AOJu0YxV7jovZPHS9Edm7g2WJTUGiCkp5TIKFYi7zEc+JS4DeHhZ0+Fc
	S4geACHIvaLhGhgy/+8QejcOmdDZkz4S4K6ZlA==
X-Google-Smtp-Source: AGHT+IEdLFn2za2ZRbcDpkJ6Fbmjfyw2kUER5KHcfoGUMp3BqNFzs/jlA9BmA0+askwMTndyLyQdDloE0dI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:f201:0:b0:5cf:1c78:27a8 with SMTP id
 v1-20020a63f201000000b005cf1c7827a8mr439pgh.1.1704849647971; Tue, 09 Jan 2024
 17:20:47 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  9 Jan 2024 17:20:45 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Message-ID: <20240110012045.505046-1-seanjc@google.com>
Subject: [PATCH v2] KVM: x86/mmu: Retry fault before acquiring mmu_lock if
 mapping is changing
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yan Zhao <yan.y.zhao@intel.com>, Kai Huang <kai.huang@intel.com>
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
Acked-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---

Note, this version adds a dedicated helper, mmu_invalidate_retry_gfn_unsafe(),
instead of making mmu_invalidate_retry_gfn() play nice with being called without
mmu_lock held.  I was hesitant to drop the lockdep assertion before, and the
recently introduced sanity check on the gfn start/end values pushed this past
the threshold of being worth the duplicate code (preserving the start/end sanity
check in lock-free code would comically difficult, and would add almost no value
since it would have to be quite conservative to avoid false positives).

Kai, I kept your Ack even though the code is obviously a little different.
Holler if you want me to drop it.

v2:
 - Introduce a dedicated helper and collapse to a single patch (because
   adding an unused helper would be quite silly).
 - Add a comment to explain the "unsafe" check in kvm_faultin_pfn(). [Kai]
 - Add Kai's Ack.

v1: https://lore.kernel.org/all/20230825020733.2849862-1-seanjc@google.com

 arch/x86/kvm/mmu/mmu.c   | 16 ++++++++++++++++
 include/linux/kvm_host.h | 26 ++++++++++++++++++++++++++
 2 files changed, 42 insertions(+)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 3c844e428684..92f51540c4a7 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4415,6 +4415,22 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 	if (unlikely(!fault->slot))
 		return kvm_handle_noslot_fault(vcpu, fault, access);
 
+	/*
+	 * Pre-check for a relevant mmu_notifier invalidation event prior to
+	 * acquiring mmu_lock.  If there is an in-progress invalidation and the
+	 * kernel allows preemption, the invalidation task may drop mmu_lock
+	 * and yield in response to mmu_lock being contended, which is *very*
+	 * counter-productive as this vCPU can't actually make forward progress
+	 * until the invalidation completes.  This "unsafe" check can get false
+	 * negatives, i.e. KVM needs to re-check after acquiring mmu_lock.  Do
+	 * the pre-check even for non-preemtible kernels, i.e. even if KVM will
+	 * never yield mmu_lock in response to contention, as this vCPU ob
+	 * *guaranteed* to need to retry, i.e. waiting until mmu_lock is held
+	 * to detect retry guarantees the worst case latency for the vCPU.
+	 */
+	if (mmu_invalidate_retry_gfn_unsafe(vcpu->kvm, fault->mmu_seq, fault->gfn))
+		return RET_PF_RETRY;
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

base-commit: 1c6d984f523f67ecfad1083bb04c55d91977bb15
-- 
2.43.0.472.g3155946c3a-goog


