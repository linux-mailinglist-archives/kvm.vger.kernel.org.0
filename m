Return-Path: <kvm+bounces-9345-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 071E585EEA8
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 02:26:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 732EF1F2281A
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 01:26:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07C9A12E58;
	Thu, 22 Feb 2024 01:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ODzRgz8w"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9334DF516
	for <kvm@vger.kernel.org>; Thu, 22 Feb 2024 01:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708565205; cv=none; b=NLnP72Ir8AlB4XlFBVGdjwdqozw2oNeZOZe9qgwGcyzG6AWcoZt8lPcf3Lbjm5HfirKLKJ3YMKgJjzY00/hBQnuOcWaudqnsnE3uPvy8d7NQvrJP55aFU+BlcF7Ro9tThc7U1ewbZvni+3GEVU8HQL4RYEZNkY9wgcj1T/Xvrr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708565205; c=relaxed/simple;
	bh=bhGMbvr6heOLuPobvmyO7j3AQO0mg3NcWYpfiqAvR9E=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=BBBUL6CaFlltnOCW7xUlMCTwsYv6UAK+omP4KFiOLjn5uDFuT7LMafF5c61oUldv61IrfjuLoI8Dg8QdMcwypgWI8BJnavSYidZphEH7GbKQC7/FdvFBDHVH3CAQSSfjX+xABJ447vKHy6bBDGIrmi0oLZG69xK/PRZU3+WH6SA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ODzRgz8w; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1dbc6ff68ffso60929315ad.1
        for <kvm@vger.kernel.org>; Wed, 21 Feb 2024 17:26:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708565203; x=1709170003; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l6K566TT3NzSNaSL9+o1Cb0+GMgOR8tkLbZptICJBGM=;
        b=ODzRgz8wUqg59nic5NSmj5y/MNFbyrMp4+pHPuosAayebRAYmXCcaTfDthnXl7U9ia
         4fR8g6SnYf1n1PNz4O1pHb+KygsTYdEfHM9Qhrr/fn5Fkk8miZwVSjzwdorJ6i+TvKn5
         GUPjbCUsUQoZEG/G+6BUGe+2qSzZnqIRdXtGrw7/dnlqs+aZ6w0qak6ynHBZB9tqS8EV
         Uvw719Chgdt6TmyED5yIsxcyySRI7iBks5h2tnEBKtg6meZzZ4J7LNBGUFwFrrJbGrvt
         dop1rCTH5kevY56fY0MwKiYZ1WwjgDDWNxhBrnffh/wjSK1HS6BKr6yoXCtHag4keYTt
         0RfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708565203; x=1709170003;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l6K566TT3NzSNaSL9+o1Cb0+GMgOR8tkLbZptICJBGM=;
        b=t1DINllvxB7oqn9bgYGFZRwvElqMVxLuINIvK+miJgqTs8bTyf73mdKJHqUcR1bo9H
         XTNc2BX0TM4ZUwiPOZAOcKY20fzoOrO76OPIrq65j3g/ovGYNdTk7n61kDSnlq6zMHK/
         QLoX5+ehxLRMjdNyaWretkVPUqG7ey1/LWbw2hWh7Ade1PMn3peTPxVQFUQjzpxHX5LV
         pE2hIeX5+mPWQiuEAcQPrgool4YnOCwYt8Ebm0BtzZ5Ivfx7YtIXS54GfkIDxB2Oq0nS
         0QjUEEdGWp5kaQYqLV6v5TYd7X//tg/kYU36ycF9o4fyoPXwoZ6kx29vJuvVP/Yvs+8l
         iagA==
X-Gm-Message-State: AOJu0YzgUk5Zw7bx//pvTMIZIO+Jz0y2IP9I3oJqkYUi6QLzrFAM2tjO
	Kdm7aOB7EApmcrNPRtohL1PyQLt77eUcSo+QjQ9C8fvyOZxueljmOdL3Q5pqINcJBw4NjwQ8Gtx
	f2w==
X-Google-Smtp-Source: AGHT+IEX5tsS2jYn/pcoj3DkKpPMM7bMjB70FTjx0NTmkLgmK4hUTQLuzIymNprybd+gJrNNrtR0siTFaaE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:fa46:b0:1db:f94a:8617 with SMTP id
 lb6-20020a170902fa4600b001dbf94a8617mr676315plb.12.1708565202968; Wed, 21 Feb
 2024 17:26:42 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 21 Feb 2024 17:26:40 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.44.0.rc0.258.g7320e95886-goog
Message-ID: <20240222012640.2820927-1-seanjc@google.com>
Subject: [PATCH v5] KVM: x86/mmu: Retry fault before acquiring mmu_lock if
 mapping is changing
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yan Zhao <yan.y.zhao@intel.com>, Friedrich Weber <f.weber@proxmox.com>, 
	Kai Huang <kai.huang@intel.com>, Yuan Yao <yuan.yao@linux.intel.com>, 
	Xu Yilun <yilun.xu@linux.intel.com>
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

v5:
 - Fix the inverted slot check. [Xu] 
 - Drop all the other patches (will post separately).

 arch/x86/kvm/mmu/mmu.c   | 42 ++++++++++++++++++++++++++++++++++++++++
 include/linux/kvm_host.h | 26 +++++++++++++++++++++++++
 2 files changed, 68 insertions(+)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 3c193b096b45..274acc53f0e9 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4405,6 +4405,31 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
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
+	if (fault->slot &&
+	    mmu_invalidate_retry_gfn_unsafe(vcpu->kvm, fault->mmu_seq, fault->gfn))
+		return RET_PF_RETRY;
+
 	ret = __kvm_faultin_pfn(vcpu, fault);
 	if (ret != RET_PF_CONTINUE)
 		return ret;
@@ -4415,6 +4440,18 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 	if (unlikely(!fault->slot))
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
 
@@ -4442,6 +4479,11 @@ static bool is_page_fault_stale(struct kvm_vcpu *vcpu,
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
index 18e28610749e..97afe4519772 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2062,6 +2062,32 @@ static inline int mmu_invalidate_retry_gfn(struct kvm *kvm,
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

base-commit: 21dbc438dde69ff630b3264c54b94923ee9fcdcf
-- 
2.44.0.rc0.258.g7320e95886-goog


