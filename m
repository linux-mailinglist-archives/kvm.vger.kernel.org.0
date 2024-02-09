Return-Path: <kvm+bounces-8504-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FC9F84FFEB
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 23:29:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 82E601C223EA
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 22:29:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DE78383BC;
	Fri,  9 Feb 2024 22:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kmnWOXez"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8938B364A0
	for <kvm@vger.kernel.org>; Fri,  9 Feb 2024 22:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707517745; cv=none; b=gM5O5duR1WFrgRQWMSwjz06pZ9lWh00fsDCb6OAxe2Xtnrm1sNo6ojnfdGUSBFAP2ro/LDHKg4RPAJx9Xz/zeJ9CYo7JIa9BEJT59XRuqi5GyDMMRg3DtQ6OtQSLetX5e/aPhG4ueQ22rW9kP8gS2QCiMlh3HGMT+7L6n2Zp/oQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707517745; c=relaxed/simple;
	bh=icC+nO7MuwJUmEXdQhRIAlaaDV8vsyLHbL3REFEZnx0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SjQKTikNJvVGHFSHMJRPTgyIUqGTzg9MfeF8uSUI1tDt6Y3Wd9Ul5qsLdpt83yPOGwgKdbIPzbUrnjwU2uc+YS3x5nFdvHe0wUbMpN3XomtMXqXS4nCYpsV6nH32VnVAXH8QsNwT3RMZ7crrTCUgrSNdU+fuvhcsey/55UYBaRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kmnWOXez; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-5ffee6fcdc1so26509077b3.2
        for <kvm@vger.kernel.org>; Fri, 09 Feb 2024 14:29:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707517742; x=1708122542; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=dMv+G+Ap9UXJP5o+o2JuMHRcwTnywW6TJb7XNnA0Nis=;
        b=kmnWOXezJtbZxhmvygdy07yxQMXsYj2ObCntSqWslnbjXJgWYQHQZ7HtDfWfUObgHd
         CqVEn1syj+pU8q5FC1FWTKNhAdr9Jhzna0Z/X8yEkJnztG0bTVEqiCeB7ZMdlcJB6Di9
         Nd/IibV2SI9YftV5n8hIjWsH2+g4bmlVv4PHms2wRehZLOp4R0ddpLhr6/UiIUNVplu5
         /IYcFU0/+VjzCf3eAseoxxwMX4KXTq6Ku7oPx8OGQcdQ6qRIYCJFrH/1poyFRnMqbfUN
         X6AyFBLV3h/9H6doiKmugLeWfTP9O5pD4C6JG7E6Yr9HAa2/MMeeUxmw4MCLZJPyEMEF
         2T7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707517742; x=1708122542;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dMv+G+Ap9UXJP5o+o2JuMHRcwTnywW6TJb7XNnA0Nis=;
        b=M8qiPrHOUP8dnC8h9HoisyHzklaUpGxoJmYWQ4Qsif0DdJNPbvKKHPUvc3aLVex/aA
         d1cycQ+EhiFfbD4rsFxxHKXgaI0zjVn8MzYMmXuR0ZHjGqygkZV2QQYAVnGcuv4f1oEH
         TEvvPwR2orTbPoir5cc7DenCDMpjDYn+5ysDqrBvBt4t0Kw0t/is/6J2vnerniqMjRnH
         SyTAqYG/xBzAd1o+rrOyQTIBQeKw9JqKj6cCdESl1yfzidhK5wBpT/mmgN8nN5jJZ35M
         emRwXOovw2sLq6bClozj58AS/6mzPOeffWb6VNAdDUShkWJ0HCIQud4q65zhBQ2JoPd4
         F0/w==
X-Gm-Message-State: AOJu0YwrSsMzjKOHaKctlOyySnu6SsavSLYlODvrvYTZxTXAU+veZ2DB
	paEjhtF7VTQP/XvocP2g11937te82IGhz92k50Nt37l+6hnb5MokA/kt72eBcRvuPHRLLyQGk52
	gLA==
X-Google-Smtp-Source: AGHT+IELxZuxEzpEJztgqXAtd5UEdM2r1PgP18O+CDOtyuNNlRlRBUOdU1r0uAwZLiPtzBNxrXzIa1m5k1w=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:4942:0:b0:604:42b0:ebf with SMTP id
 w63-20020a814942000000b0060442b00ebfmr100005ywa.10.1707517742672; Fri, 09 Feb
 2024 14:29:02 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  9 Feb 2024 14:28:55 -0800
In-Reply-To: <20240209222858.396696-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240209222858.396696-1-seanjc@google.com>
X-Mailer: git-send-email 2.43.0.687.g38aa6559b0-goog
Message-ID: <20240209222858.396696-2-seanjc@google.com>
Subject: [PATCH v4 1/4] KVM: x86/mmu: Retry fault before acquiring mmu_lock if
 mapping is changing
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yan Zhao <yan.y.zhao@intel.com>, Friedrich Weber <f.weber@proxmox.com>, 
	Kai Huang <kai.huang@intel.com>, Yuan Yao <yuan.yao@linux.intel.com>, 
	Xu Yilun <yilun.xu@linux.intel.com>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Chao Peng <chao.p.peng@linux.intel.com>, Fuad Tabba <tabba@google.com>, 
	Michael Roth <michael.roth@amd.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Retry page faults without acquiring mmu_lock, and without even faulting
the page into the primary MMU, if the resolved gfn is covered by an active
invalidation.  Contending for mmu_lock is especially problematic on
preemptible kernels as the mmu_notifier invalidation task will yield
mmu_lock (see rwlock_needbreak()), delay the in-progress invalidation, and
ultimately increase the latency of resolving the page fault.  And in the
worst case scenario, yielding will be accompanied by a remote TLB flush,
e.g. if the invalidation covers a large range of memory and vCPUs are
accessing addresses that were already zapped.

Faulting the page into the primary MMU is similarly problematic, as doing
so may acquire locks that need to be taken for the invalidation to
complete (the primary MMU has finer grained locks than KVM's MMU), and/or
may cause unnecessary churn (getting/putting pages, marking them accessed,
etc).

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
Reported-by: Friedrich Weber <f.weber@proxmox.com>
Cc: Kai Huang <kai.huang@intel.com>
Cc: Yan Zhao <yan.y.zhao@intel.com>
Cc: Yuan Yao <yuan.yao@linux.intel.com>
Cc: Xu Yilun <yilun.xu@linux.intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c   | 45 +++++++++++++++++++++++++++++++++++++++-
 include/linux/kvm_host.h | 26 +++++++++++++++++++++++
 2 files changed, 70 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 3c193b096b45..166cef0c3ff4 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4400,11 +4400,37 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 			   unsigned int access)
 {
+	struct kvm_memory_slot *slot = fault->slot;
 	int ret;
 
 	fault->mmu_seq = vcpu->kvm->mmu_invalidate_seq;
 	smp_rmb();
 
+	/*
+	 * Check for a relevant mmu_notifier invalidation event before getting
+	 * the pfn from the primary MMU, and before acquiring mmu_lock.
+	 *
+	 * For mmu_lock, if there is an in-progress invalidation and the kernel
+	 * allows preemption, the invalidation task may drop mmu_lock and yield
+	 * in response to mmu_lock being contended, which is *very* counter-
+	 * productive as this vCPU can't actually make forward progress until
+	 * the invalidation completes.
+	 *
+	 * Retrying now can also avoid unnessary lock contention in the primary
+	 * MMU, as the primary MMU doesn't necessarily hold a single lock for
+	 * the duration of the invalidation, i.e. faulting in a conflicting pfn
+	 * can cause the invalidation to take longer by holding locks that are
+	 * needed to complete the invalidation.
+	 *
+	 * Do the pre-check even for non-preemtible kernels, i.e. even if KVM
+	 * will never yield mmu_lock in response to contention, as this vCPU is
+	 * *guaranteed* to need to retry, i.e. waiting until mmu_lock is held
+	 * to detect retry guarantees the worst case latency for the vCPU.
+	 */
+	if (!slot &&
+	    mmu_invalidate_retry_gfn_unsafe(vcpu->kvm, fault->mmu_seq, fault->gfn))
+		return RET_PF_RETRY;
+
 	ret = __kvm_faultin_pfn(vcpu, fault);
 	if (ret != RET_PF_CONTINUE)
 		return ret;
@@ -4412,9 +4438,21 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 	if (unlikely(is_error_pfn(fault->pfn)))
 		return kvm_handle_error_pfn(vcpu, fault);
 
-	if (unlikely(!fault->slot))
+	if (unlikely(!slot))
 		return kvm_handle_noslot_fault(vcpu, fault, access);
 
+	/*
+	 * Check again for a relevant mmu_notifier invalidation event purely to
+	 * avoid contending mmu_lock.  Most invalidations will be detected by
+	 * the previous check, but checking is extremely cheap relative to the
+	 * overall cost of failing to detect the invalidation until after
+	 * mmu_lock is acquired.
+	 */
+	if (mmu_invalidate_retry_gfn_unsafe(vcpu->kvm, fault->mmu_seq, fault->gfn)) {
+		kvm_release_pfn_clean(fault->pfn);
+		return RET_PF_RETRY;
+	}
+
 	return RET_PF_CONTINUE;
 }
 
@@ -4442,6 +4480,11 @@ static bool is_page_fault_stale(struct kvm_vcpu *vcpu,
 	if (!sp && kvm_test_request(KVM_REQ_MMU_FREE_OBSOLETE_ROOTS, vcpu))
 		return true;
 
+	/*
+	 * Check for a relevant mmu_notifier invalidation event one last time
+	 * now that mmu_lock is held, as the "unsafe" checks performed without
+	 * holding mmu_lock can get false negatives.
+	 */
 	return fault->slot &&
 	       mmu_invalidate_retry_gfn(vcpu->kvm, fault->mmu_seq, fault->gfn);
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
-- 
2.43.0.687.g38aa6559b0-goog


