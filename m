Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2335F302A61
	for <lists+kvm@lfdr.de>; Mon, 25 Jan 2021 19:36:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727369AbhAYSgR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Jan 2021 13:36:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727232AbhAYSf5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Jan 2021 13:35:57 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E000C061574
        for <kvm@vger.kernel.org>; Mon, 25 Jan 2021 10:35:16 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id t6so8217174plq.1
        for <kvm@vger.kernel.org>; Mon, 25 Jan 2021 10:35:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5li4BVEipLZX5zx8rH4Z99dY7w+ascZy4Y8R2o+aUH8=;
        b=ntnqgqJh8GrmgSLeIUVSOeq5ocf777yPSTQ/ma0WIPO30h+DKcbkCeMBXaDyu+II4o
         UMpCUfTJekTMY3vCJYPmquE6msvyiqLQUxnv+Qa3r6AZbHT7+VpLvX6r5Q+OjazjvunH
         NLPdZTZMV6N7ne6Bxo+VqIYyDyy37rGuL2RgVYOhrRNmdtspPcsGocvHDflOGXXNcL3S
         m0VpqdXFHPlf1Rbm1QxZIvYNZoPDXUlGf3MUk88oOAMT/kUr0DXhL6pFdWc9nb/CDbjA
         eukcfxn0wDeFNZPSqccJmj4nhOmZ8T+LYGGk8Gq334rQrt7MJTlhmWa0vzSCOkusKDUq
         5qfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5li4BVEipLZX5zx8rH4Z99dY7w+ascZy4Y8R2o+aUH8=;
        b=SWpQSH1w22ZjHwUw480281H+0Y5jo10pRG1mXaGxONm0KUBIYjaR4AeJP9H2uRTe4S
         slPEH1ZEpIqnAT/ofqm8N4iRXK5p5BFmehlUM0At6nvUErPgwOH1RhCrxKhhIUP+aGMR
         URFOSguRb/h9ENyl1fgB8B4XBKzlNi5pWOFHV4FYL1l0kAj6BeAmP9K6c4f1gdLJv3JE
         XHPWxsVRUus53chrtYrdNEyHsgbzaFZl2FgDcQ2Ud7NEQ5cNNoKUsbWy0Q+e2TU3Uxgb
         xegh1D86p7rba0QVXlqY2KNrMZ1fy9HF9aq2GAmodGjFauyifKZFJ7Fc8jzzYUVA682l
         tzQg==
X-Gm-Message-State: AOAM532rs0/CXSqorenuoe1tKCgUMAQbls4YB8uSWj6bwL5hnskLIegm
        tN0e23ioBwupmY7jp5zr/rCwTQ==
X-Google-Smtp-Source: ABdhPJxgVscQHSmbku17rqN6Nk67IT0OKp5oZGNz41Gx1gtHDQegyJuNc0/nvJi9Q+6qG60UzNty/w==
X-Received: by 2002:a17:90a:d305:: with SMTP id p5mr1634140pju.33.1611599715885;
        Mon, 25 Jan 2021 10:35:15 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id n128sm18157528pga.55.2021.01.25.10.35.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jan 2021 10:35:15 -0800 (PST)
Date:   Mon, 25 Jan 2021 10:35:08 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     David Stevens <stevensd@chromium.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        linux-mips@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
        kvm-ppc@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: Re: [PATCH] KVM: x86/mmu: consider the hva in mmu_notifer retry
Message-ID: <YA8PXCEVukW0UzC5@google.com>
References: <20210125064234.2078146-1-stevensd@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210125064234.2078146-1-stevensd@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

+Cc the other architectures, I'm guessing this would be a helpful optimization
for all archs.

Quite a few comments, but they're all little more than nits.  Nice!

On Mon, Jan 25, 2021, David Stevens wrote:
> From: David Stevens <stevensd@chromium.org>
> 
> Use the range passed to mmu_notifer's invalidate_range_start to prevent

s/mmu_notifer/mmu_notifier.  

And maybe avoid calling out invalidate_range_start() by name?  It took me a few
reads to understand it's referring to the function, i.e. the start of the
invalidation, not the start of the range.

> spurious page fault retries due to changes in unrelated host virtual
> addresses.

This needs to elaborate on the exact scenario this is handling, as is it sounds
like KVM is tracking the history of invalidations or something.  Understanding
this patch requires a priori knowledge of mmu_notifier_count.  Something like:

  Track the range being invalidated by mmu_notifier and skip page fault
  retries if the fault address is not affected by the in-progress
  invalidation.  Disable the optimization if multiple invalidations are
  in-progress to keep things simple, as tracking multiple ranges has
  diminishing returns.

> This has the secondary effect of greatly reducing the likelihood of extreme

Out of curiosity, is this really the _secondary_ effect?  I would expect this
change to primarily benefit scenarios where the invalidation has gotten
waylaid for whatever reason.

> latency when handing a page fault due to another thread having been preempted
> while modifying host virtual addresses.
> 
> Signed-off-by: David Stevens <stevensd@chromium.org>
> ---

...

> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 6d16481aa29d..79166288ed03 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3658,8 +3658,8 @@ static bool kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>  }
>  
>  static bool try_async_pf(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
> -			 gpa_t cr2_or_gpa, kvm_pfn_t *pfn, bool write,
> -			 bool *writable)
> +			 gpa_t cr2_or_gpa, kvm_pfn_t *pfn, hva_t *hva,
> +			 bool write, bool *writable)

Side topic, I'm all for creating a 'struct kvm_page_fault' or whatever to hold
all these variables.  The helper functions stacks are getting unwieldy.
Definitely doesn't need to be addressed here, this just reminded of how ugly
these stacks are.

>  {
>  	struct kvm_memory_slot *slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
>  	bool async;
> @@ -3672,7 +3672,8 @@ static bool try_async_pf(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
>  	}
>  
>  	async = false;
> -	*pfn = __gfn_to_pfn_memslot(slot, gfn, false, &async, write, writable);
> +	*pfn = __gfn_to_pfn_memslot(slot, gfn, false, &async,
> +				    write, writable, hva);
>  	if (!async)
>  		return false; /* *pfn has correct page already */
>  
> @@ -3686,7 +3687,8 @@ static bool try_async_pf(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
>  			return true;
>  	}
>  
> -	*pfn = __gfn_to_pfn_memslot(slot, gfn, false, NULL, write, writable);
> +	*pfn = __gfn_to_pfn_memslot(slot, gfn, false, NULL,
> +				    write, writable, hva);
>  	return false;
>  }
>  
> @@ -3699,6 +3701,7 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
>  	gfn_t gfn = gpa >> PAGE_SHIFT;
>  	unsigned long mmu_seq;
>  	kvm_pfn_t pfn;
> +	hva_t hva;
>  	int r;
>  
>  	if (page_fault_handle_page_track(vcpu, error_code, gfn))
> @@ -3717,7 +3720,8 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
>  	mmu_seq = vcpu->kvm->mmu_notifier_seq;
>  	smp_rmb();
>  
> -	if (try_async_pf(vcpu, prefault, gfn, gpa, &pfn, write, &map_writable))
> +	if (try_async_pf(vcpu, prefault, gfn, gpa, &pfn, &hva,
> +			 write, &map_writable))
>  		return RET_PF_RETRY;
>  
>  	if (handle_abnormal_pfn(vcpu, is_tdp ? 0 : gpa, gfn, pfn, ACC_ALL, &r))
> @@ -3725,7 +3729,7 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
>  
>  	r = RET_PF_RETRY;
>  	spin_lock(&vcpu->kvm->mmu_lock);
> -	if (mmu_notifier_retry(vcpu->kvm, mmu_seq))
> +	if (mmu_notifier_retry_hva(vcpu->kvm, mmu_seq, hva))
>  		goto out_unlock;
>  	r = make_mmu_pages_available(vcpu);
>  	if (r)
> diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
> index 50e268eb8e1a..3171784139a4 100644
> --- a/arch/x86/kvm/mmu/paging_tmpl.h
> +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> @@ -790,6 +790,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gpa_t addr, u32 error_code,
>  	struct guest_walker walker;
>  	int r;
>  	kvm_pfn_t pfn;
> +	hva_t hva;
>  	unsigned long mmu_seq;
>  	bool map_writable, is_self_change_mapping;
>  	int max_level;
> @@ -840,8 +841,8 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gpa_t addr, u32 error_code,
>  	mmu_seq = vcpu->kvm->mmu_notifier_seq;
>  	smp_rmb();
>  
> -	if (try_async_pf(vcpu, prefault, walker.gfn, addr, &pfn, write_fault,
> -			 &map_writable))
> +	if (try_async_pf(vcpu, prefault, walker.gfn, addr, &pfn, &hva,
> +			 write_fault, &map_writable))
>  		return RET_PF_RETRY;
>  
>  	if (handle_abnormal_pfn(vcpu, addr, walker.gfn, pfn, walker.pte_access, &r))
> @@ -869,7 +870,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gpa_t addr, u32 error_code,
>  
>  	r = RET_PF_RETRY;
>  	spin_lock(&vcpu->kvm->mmu_lock);
> -	if (mmu_notifier_retry(vcpu->kvm, mmu_seq))
> +	if (mmu_notifier_retry_hva(vcpu->kvm, mmu_seq, hva))
>  		goto out_unlock;
>  
>  	kvm_mmu_audit(vcpu, AUDIT_PRE_PAGE_FAULT);
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index f3b1013fb22c..b70097685249 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -502,6 +502,8 @@ struct kvm {
>  	struct mmu_notifier mmu_notifier;
>  	unsigned long mmu_notifier_seq;
>  	long mmu_notifier_count;
> +	unsigned long mmu_notifier_range_start;
> +	unsigned long mmu_notifier_range_end;
>  #endif
>  	long tlbs_dirty;
>  	struct list_head devices;
> @@ -729,7 +731,7 @@ kvm_pfn_t gfn_to_pfn_memslot(struct kvm_memory_slot *slot, gfn_t gfn);
>  kvm_pfn_t gfn_to_pfn_memslot_atomic(struct kvm_memory_slot *slot, gfn_t gfn);
>  kvm_pfn_t __gfn_to_pfn_memslot(struct kvm_memory_slot *slot, gfn_t gfn,
>  			       bool atomic, bool *async, bool write_fault,
> -			       bool *writable);
> +			       bool *writable, hva_t *hva);
>  
>  void kvm_release_pfn_clean(kvm_pfn_t pfn);
>  void kvm_release_pfn_dirty(kvm_pfn_t pfn);
> @@ -1203,6 +1205,24 @@ static inline int mmu_notifier_retry(struct kvm *kvm, unsigned long mmu_seq)
>  		return 1;
>  	return 0;
>  }
> +
> +static inline int mmu_notifier_retry_hva(struct kvm *kvm,
> +					 unsigned long mmu_seq,
> +					 unsigned long hva)
> +{
> +	/*
> +	 * Unlike mmu_notifier_retry, this function relies on
> +	 * kvm->mmu_lock for consistency.

mmu_notifier_retry is the outlier due to PPC behavior.  Maybe just add a lockdep
annonation and call it good?

> +	 */

This needs a comment to explicitly state that 'count > 1' cannot be done at
this time.  My initial thought is that it would be more intuitive to check for
'count > 1' here, but that would potentially check the wrong wrange when count
goes from 2->1.  The comment about persistence in invalidate_range_start() is a
good hint, but I think it's worth being explicit to avoid bad "cleanup" in the
future.

> +	if (unlikely(kvm->mmu_notifier_count)) {
> +		if (kvm->mmu_notifier_range_start <= hva &&
> +		    hva < kvm->mmu_notifier_range_end)

Combine these into a single statement?  I think the result is easier to read?

	if (unlikely(kvm->mmu_notifier_count) &&
	    kvm->mmu_notifier_range_start <= hva &&
	    hva < kvm->mmu_notifier_range_end)

> +			return 1;
> +	}
> +	if (kvm->mmu_notifier_seq != mmu_seq)
> +		return 1;
> +	return 0;
> +}
>  #endif
>  
>  #ifdef CONFIG_HAVE_KVM_IRQ_ROUTING
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index fa9e3614d30e..d6e1ef5cb184 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -483,6 +483,18 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
>  	 * count is also read inside the mmu_lock critical section.
>  	 */
>  	kvm->mmu_notifier_count++;
> +	if (likely(kvm->mmu_notifier_count == 1)) {
> +		kvm->mmu_notifier_range_start = range->start;
> +		kvm->mmu_notifier_range_end = range->end;
> +	} else {
> +		/**
> +		 * Tracking multiple concurrent ranges has diminishing returns,
> +		 * so just use the maximum range. This persists until after all
> +		 * outstanding invalidation operations complete.
> +		 */
> +		kvm->mmu_notifier_range_start = 0;
> +		kvm->mmu_notifier_range_end = ULONG_MAX;

Hrm, I don't think there's a corner case in practice, but ULONG_MAX is a legal
virtual address and range_end is exclusive.  E.g. passing hva=-1ul would get a
false negative in mmu_notifier_retry_hva().  It's not an issue as written
because hva is generated from the gfn, and hva can't be a kernel address.  I'm
guessing mmu_notifier also doesn't fire on kernel addresses.  I assume that all
holds true for other architectures, and adding checks in mmu_notifier_retry_hva()
feels like a waste of cycles, but it still bugs me. :-)

Maybe zero out range_end and explicitly check for that, just to be paranoid?

	if (unlikely(kvm->mmu_notifier_count) &&
	    (!kvm->mmu_notifier_range_end ||
            (kvm->mmu_notifier_range_start <= hva &&
             hva < kvm->mmu_notifier_range_end))

> +	}
>  	need_tlb_flush = kvm_unmap_hva_range(kvm, range->start, range->end,
>  					     range->flags);
>  	/* we've to flush the tlb before the pages can be freed */
> @@ -2010,9 +2022,11 @@ static kvm_pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool *async,
>  
>  kvm_pfn_t __gfn_to_pfn_memslot(struct kvm_memory_slot *slot, gfn_t gfn,
>  			       bool atomic, bool *async, bool write_fault,
> -			       bool *writable)
> +			       bool *writable, hva_t *hva)

Hrm, it feels like we should really split gfn->hva and hva->pfn into separate
operations, but pretty much every arch needs the hva error handling.  Splitting
it would probably do more harm than good, at least not without a lot of
additional refactoring.  Bummer.

>  {
>  	unsigned long addr = __gfn_to_hva_many(slot, gfn, NULL, write_fault);

Newline here.

> +	if (hva)
> +		*hva = addr;
>  
>  	if (addr == KVM_HVA_ERR_RO_BAD) {
>  		if (writable)
> @@ -2041,19 +2055,19 @@ kvm_pfn_t gfn_to_pfn_prot(struct kvm *kvm, gfn_t gfn, bool write_fault,
>  		      bool *writable)
>  {
>  	return __gfn_to_pfn_memslot(gfn_to_memslot(kvm, gfn), gfn, false, NULL,
> -				    write_fault, writable);
> +				    write_fault, writable, NULL);
>  }
>  EXPORT_SYMBOL_GPL(gfn_to_pfn_prot);
>  
>  kvm_pfn_t gfn_to_pfn_memslot(struct kvm_memory_slot *slot, gfn_t gfn)
>  {
> -	return __gfn_to_pfn_memslot(slot, gfn, false, NULL, true, NULL);
> +	return __gfn_to_pfn_memslot(slot, gfn, false, NULL, true, NULL, NULL);
>  }
>  EXPORT_SYMBOL_GPL(gfn_to_pfn_memslot);
>  
>  kvm_pfn_t gfn_to_pfn_memslot_atomic(struct kvm_memory_slot *slot, gfn_t gfn)
>  {
> -	return __gfn_to_pfn_memslot(slot, gfn, true, NULL, true, NULL);
> +	return __gfn_to_pfn_memslot(slot, gfn, true, NULL, true, NULL, NULL);
>  }
>  EXPORT_SYMBOL_GPL(gfn_to_pfn_memslot_atomic);
>  
> -- 
> 2.30.0.280.ga3ce27912f-goog
> 
