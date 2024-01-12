Return-Path: <kvm+bounces-6134-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CDA4082BC05
	for <lists+kvm@lfdr.de>; Fri, 12 Jan 2024 08:48:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3792A1F22098
	for <lists+kvm@lfdr.de>; Fri, 12 Jan 2024 07:48:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B64E5D739;
	Fri, 12 Jan 2024 07:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lWjtToLU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74B683A1B7;
	Fri, 12 Jan 2024 07:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705045723; x=1736581723;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=JwVGwvnV/ash5bnvSuVbBXLnAHV/GITqwc469coTDuw=;
  b=lWjtToLUXED+R7G2ckL6XAza1n320zxKnZI2tBrBe8Xt5egddlqNi2iK
   gpIiL5+bsuwQ8Fi5QLxDwvoi5fLNQocaQnBW4e772ITpHdTtCH6XyOyYX
   UGgPq6jfcCwrU1kuLEP0xLX6QIVjvuYIwSpmy++B0QFHXUVSk1G4DAvgG
   /UbtV50Pd36nPGLOTW2y0gOe9zc/WalCy+DcpMxpuJKYNZPcDK+VAmlWr
   TIxeYnW0ZP3Y3q0/+0+mH3LD8ozZifpJQJtIlBYYSRwpHuY8jmYudoVJ3
   VRtMqKVsy+6vngwoFm7mMxAQbW5ETUA3oh8D8p7/7v9VR0U69IBHbAxwc
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10950"; a="463388728"
X-IronPort-AV: E=Sophos;i="6.04,188,1695711600"; 
   d="scan'208";a="463388728"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2024 23:48:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10950"; a="732505637"
X-IronPort-AV: E=Sophos;i="6.04,188,1695711600"; 
   d="scan'208";a="732505637"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by orsmga003.jf.intel.com with ESMTP; 11 Jan 2024 23:48:40 -0800
Date: Fri, 12 Jan 2024 15:48:39 +0800
From: Yuan Yao <yuan.yao@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Yan Zhao <yan.y.zhao@intel.com>,
	Kai Huang <kai.huang@intel.com>
Subject: Re: [PATCH v2] KVM: x86/mmu: Retry fault before acquiring mmu_lock
 if mapping is changing
Message-ID: <20240112074839.waglpqqgs772m4a3@yy-desk-7060>
References: <20240110012045.505046-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240110012045.505046-1-seanjc@google.com>
User-Agent: NeoMutt/20171215

On Tue, Jan 09, 2024 at 05:20:45PM -0800, Sean Christopherson wrote:
> Retry page faults without acquiring mmu_lock if the resolved gfn is covered

after resolved gfn so it's very near the mmu lock taking, this should increase
the possibility of "hit" in progress validation for the gfn ?

> by an active invalidation.  Contending for mmu_lock is especially
> problematic on preemptible kernels as the mmu_notifier invalidation task
> will yield mmu_lock (see rwlock_needbreak()), delay the in-progress
> invalidation, and ultimately increase the latency of resolving the page
> fault.  And in the worst case scenario, yielding will be accompanied by a
> remote TLB flush, e.g. if the invalidation covers a large range of memory
> and vCPUs are accessing addresses that were already zapped.
>
> Alternatively, the yielding issue could be mitigated by teaching KVM's MMU
> iterators to perform more work before yielding, but that wouldn't solve
> the lock contention and would negatively affect scenarios where a vCPU is
> trying to fault in an address that is NOT covered by the in-progress
> invalidation.
>
> Add a dedicated lockess version of the range-based retry check to avoid
> false positives on the sanity check on start+end WARN, and so that it's
> super obvious that checking for a racing invalidation without holding
> mmu_lock is unsafe (though obviously useful).
>
> Wrap mmu_invalidate_in_progress in READ_ONCE() to ensure that pre-checking
> invalidation in a loop won't put KVM into an infinite loop, e.g. due to
> caching the in-progress flag and never seeing it go to '0'.
>
> Force a load of mmu_invalidate_seq as well, even though it isn't strictly
> necessary to avoid an infinite loop, as doing so improves the probability
> that KVM will detect an invalidation that already completed before
> acquiring mmu_lock and bailing anyways.
>
> Do the pre-check even for non-preemptible kernels, as waiting to detect
> the invalidation until mmu_lock is held guarantees the vCPU will observe
> the worst case latency in terms of handling the fault, and can generate
> even more mmu_lock contention.  E.g. the vCPU will acquire mmu_lock,
> detect retry, drop mmu_lock, re-enter the guest, retake the fault, and
> eventually re-acquire mmu_lock.  This behavior is also why there are no
> new starvation issues due to losing the fairness guarantees provided by
> rwlocks: if the vCPU needs to retry, it _must_ drop mmu_lock, i.e. waiting
> on mmu_lock doesn't guarantee forward progress in the face of _another_
> mmu_notifier invalidation event.
>
> Note, adding READ_ONCE() isn't entirely free, e.g. on x86, the READ_ONCE()
> may generate a load into a register instead of doing a direct comparison
> (MOV+TEST+Jcc instead of CMP+Jcc), but practically speaking the added cost
> is a few bytes of code and maaaaybe a cycle or three.
>
> Reported-by: Yan Zhao <yan.y.zhao@intel.com>
> Closes: https://lore.kernel.org/all/ZNnPF4W26ZbAyGto@yzhao56-desk.sh.intel.com
> Acked-by: Kai Huang <kai.huang@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>
> Note, this version adds a dedicated helper, mmu_invalidate_retry_gfn_unsafe(),
> instead of making mmu_invalidate_retry_gfn() play nice with being called without
> mmu_lock held.  I was hesitant to drop the lockdep assertion before, and the
> recently introduced sanity check on the gfn start/end values pushed this past
> the threshold of being worth the duplicate code (preserving the start/end sanity
> check in lock-free code would comically difficult, and would add almost no value
> since it would have to be quite conservative to avoid false positives).
>
> Kai, I kept your Ack even though the code is obviously a little different.
> Holler if you want me to drop it.
>
> v2:
>  - Introduce a dedicated helper and collapse to a single patch (because
>    adding an unused helper would be quite silly).
>  - Add a comment to explain the "unsafe" check in kvm_faultin_pfn(). [Kai]
>  - Add Kai's Ack.
>
> v1: https://lore.kernel.org/all/20230825020733.2849862-1-seanjc@google.com
>
>  arch/x86/kvm/mmu/mmu.c   | 16 ++++++++++++++++
>  include/linux/kvm_host.h | 26 ++++++++++++++++++++++++++
>  2 files changed, 42 insertions(+)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 3c844e428684..92f51540c4a7 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4415,6 +4415,22 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
>  	if (unlikely(!fault->slot))
>  		return kvm_handle_noslot_fault(vcpu, fault, access);
>
> +	/*
> +	 * Pre-check for a relevant mmu_notifier invalidation event prior to
> +	 * acquiring mmu_lock.  If there is an in-progress invalidation and the
> +	 * kernel allows preemption, the invalidation task may drop mmu_lock
> +	 * and yield in response to mmu_lock being contended, which is *very*
> +	 * counter-productive as this vCPU can't actually make forward progress
> +	 * until the invalidation completes.  This "unsafe" check can get false
> +	 * negatives, i.e. KVM needs to re-check after acquiring mmu_lock.  Do
> +	 * the pre-check even for non-preemtible kernels, i.e. even if KVM will
> +	 * never yield mmu_lock in response to contention, as this vCPU ob
> +	 * *guaranteed* to need to retry, i.e. waiting until mmu_lock is held
> +	 * to detect retry guarantees the worst case latency for the vCPU.
> +	 */
> +	if (mmu_invalidate_retry_gfn_unsafe(vcpu->kvm, fault->mmu_seq, fault->gfn))
> +		return RET_PF_RETRY;

This breaks the contract of kvm_faultin_pfn(), i.e. the pfn's refcount
increased after resolved from gfn, but its caller won't decrease it.

How about call kvm_release_pfn_clean() just before return RET_PF_RETRY here,
so we don't need to duplicate it in 3 different places.

> +
>  	return RET_PF_CONTINUE;
>  }
>
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 7e7fd25b09b3..179df96b20f8 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -2031,6 +2031,32 @@ static inline int mmu_invalidate_retry_gfn(struct kvm *kvm,
>  		return 1;
>  	return 0;
>  }
> +
> +/*
> + * This lockless version of the range-based retry check *must* be paired with a

s/lockess/lockless

> + * call to the locked version after acquiring mmu_lock, i.e. this is safe to
> + * use only as a pre-check to avoid contending mmu_lock.  This version *will*
> + * get false negatives and false positives.
> + */
> +static inline bool mmu_invalidate_retry_gfn_unsafe(struct kvm *kvm,
> +						   unsigned long mmu_seq,
> +						   gfn_t gfn)
> +{
> +	/*
> +	 * Use READ_ONCE() to ensure the in-progress flag and sequence counter
> +	 * are always read from memory, e.g. so that checking for retry in a
> +	 * loop won't result in an infinite retry loop.  Don't force loads for
> +	 * start+end, as the key to avoiding infinite retry loops is observing
> +	 * the 1=>0 transition of in-progress, i.e. getting false negatives
> +	 * due to stale start+end values is acceptable.
> +	 */
> +	if (unlikely(READ_ONCE(kvm->mmu_invalidate_in_progress)) &&
> +	    gfn >= kvm->mmu_invalidate_range_start &&
> +	    gfn < kvm->mmu_invalidate_range_end)
> +		return true;
> +
> +	return READ_ONCE(kvm->mmu_invalidate_seq) != mmu_seq;
> +}
>  #endif
>
>  #ifdef CONFIG_HAVE_KVM_IRQ_ROUTING
>
> base-commit: 1c6d984f523f67ecfad1083bb04c55d91977bb15
> --
> 2.43.0.472.g3155946c3a-goog
>
>

