Return-Path: <kvm+bounces-25407-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A6CB396507E
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 22:07:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 34AC41F26271
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 20:07:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 089291BA882;
	Thu, 29 Aug 2024 20:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gWWG29MC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B036D1B86CB
	for <kvm@vger.kernel.org>; Thu, 29 Aug 2024 20:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724962019; cv=none; b=i5Ub+gytMN28AYInwlcuhGpTE6OTX26Eg2euHTdDeSwWslmTqSQBB1qSVa1Rg6F0h+DCtCabPqhHblsnHacOePJ72Ktt30HOmHNARhWqlTc3gWe3XQDVmd2zkXf2eWdtMwy/9fG+XzrUxEOx9gMd31eHfvqhOFdDuGtwOXVDu9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724962019; c=relaxed/simple;
	bh=9ZAG4xVxK2s1NUjwNxY2G84N9pLAuVSOCrY6odqnKBg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=G7FRsdRnB+DXbF0v8Y8MVFlP60p6cmydToVSFxGR8LKvMJzEfCTgkoXEiIALRjNNtdV8rrZEm1SkB8xf9IIs4kJlzNwKq+6gx4+M29OHOSO4/cETJQoTOGhGzQaLfqOuOrEv4wL0bb7CEOeOid4PWvoFGemrNr7qkXBPtbCRmbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gWWG29MC; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2d69603a62aso1140931a91.2
        for <kvm@vger.kernel.org>; Thu, 29 Aug 2024 13:06:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724962017; x=1725566817; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=h0tAXdbF9s5aVrX2D9yJymXJxFJA/BG13Aebp2mvni4=;
        b=gWWG29MCg6sYMqf7MzyDxk6ysK5JnvU1JkRCgIQUNMuyoERsO4sKJc4aR/JFcc2lfQ
         jOpUXAAs1PJ1er7wR9+2aNiqp/qBs6/8bBLuR3poCLBdeAVLQOwYLTh7Kkp9jVkad7En
         Ur6vuArPtTquPe+aZEYuHqbGO3dYKtdZfG44FJLrpX5310UDDeCtzbJEg4bcGMJRXADL
         BJ/O9gKrqTZzZZcz2xIW32FY5YUPo30n1YKcp93KEyv+BZLd4+HCpleItvRng4rZEaB7
         x/rmWnSLXrAs2CDegOAbqg+b7BNc0UcoTotN3/thoWqSzJBZTp04uy6nzcLx1wI5UHvy
         lKIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724962017; x=1725566817;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=h0tAXdbF9s5aVrX2D9yJymXJxFJA/BG13Aebp2mvni4=;
        b=SJix2hSDXRVyOu1pA2Y+RifBCjJWdmRBraKYfaisYLV5msLZP3VjflSgyoCbqwBG5L
         u87KtfeYAD3YoKaKd0VhYacXkoIPim0W525gQNCpyn4SJgkbwtn0Fg/imWFGBUdcjDqK
         EgqaepcNoFvGL/5inUlInC/62zEeFWeD0f4V7RFJSdUoV1s4k0vmu4jM1d+lq9u+2PXb
         pzFzpDP3djR1Uto3f9M0d3KMDe3WK91bnva3KsxURq7s3o7Zd4Pte0jwL3vWDKoA0Yr0
         uV7Uxl1WxYBVsQf9kRdDU+TYeD61Iw+z23sV1CV7KE5CTRbFnGwg8rdVanhQkicuZFfH
         43Iw==
X-Forwarded-Encrypted: i=1; AJvYcCV0zzOAytsyckIHEUfI73sutHO4LeXCnRswHaMT3c8TI01TjiywUFxrig2a0kU7MW4H46s=@vger.kernel.org
X-Gm-Message-State: AOJu0YxQoAsiVW6dtUlj0db2vfodzaUR8F/BCuVynYjO0tEQsBPyJP2k
	F/xFOM/jaluMkZg9QauSyzIVbahWBM+awfjpaHm70PKORVDvW8JScDfmfYEX1s3dg8PCeDprA5q
	S+A==
X-Google-Smtp-Source: AGHT+IHvuOtDnHgaKGMG7YaufVXKF5bZJUCSaLhF0tkNOnDRLtlvFWPo0p053FxGCu89mhSEyHod1HWgecQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:5304:b0:2c2:5b8a:ef9c with SMTP id
 98e67ed59e1d1-2d85616d60cmr8985a91.2.1724962016945; Thu, 29 Aug 2024 13:06:56
 -0700 (PDT)
Date: Thu, 29 Aug 2024 13:06:55 -0700
In-Reply-To: <20240829191135.2041489-5-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240829191135.2041489-1-vipinsh@google.com> <20240829191135.2041489-5-vipinsh@google.com>
Message-ID: <ZtDU3x9t66BnpPt_@google.com>
Subject: Re: [PATCH v2 4/4] KVM: x86/mmu: Recover TDP MMU NX huge pages using
 MMU read lock
From: Sean Christopherson <seanjc@google.com>
To: Vipin Sharma <vipinsh@google.com>
Cc: pbonzini@redhat.com, dmatlack@google.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Aug 29, 2024, Vipin Sharma wrote:
> @@ -1806,7 +1832,7 @@ void kvm_tdp_mmu_recover_nx_huge_pages(struct kvm *kvm)
>  	struct kvm_mmu_page *sp;
>  	bool flush = false;
>  
> -	lockdep_assert_held_write(&kvm->mmu_lock);
> +	lockdep_assert_held_read(&kvm->mmu_lock);
>  	/*
>  	 * Zapping TDP MMU shadow pages, including the remote TLB flush, must
>  	 * be done under RCU protection, because the pages are freed via RCU
> @@ -1815,8 +1841,11 @@ void kvm_tdp_mmu_recover_nx_huge_pages(struct kvm *kvm)
>  	rcu_read_lock();
>  
>  	for ( ; to_zap; --to_zap) {
> -		if (list_empty(&kvm->arch.tdp_mmu_possible_nx_huge_pages))
> +		spin_lock(&kvm->arch.tdp_mmu_pages_lock);
> +		if (list_empty(&kvm->arch.tdp_mmu_possible_nx_huge_pages)) {
> +			spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
>  			break;
> +		}
>  
>  		/*
>  		 * We use a separate list instead of just using active_mmu_pages
> @@ -1832,16 +1861,29 @@ void kvm_tdp_mmu_recover_nx_huge_pages(struct kvm *kvm)
>  		WARN_ON_ONCE(!sp->role.direct);
>  
>  		/*
> -		 * Unaccount and do not attempt to recover any NX Huge Pages
> -		 * that are being dirty tracked, as they would just be faulted
> -		 * back in as 4KiB pages. The NX Huge Pages in this slot will be
> +		 * Unaccount the shadow page before zapping its SPTE so as to
> +		 * avoid bouncing tdp_mmu_pages_lock more than is necessary.
> +		 * Clearing nx_huge_page_disallowed before zapping is safe, as
> +		 * the flag doesn't protect against iTLB multi-hit, it's there
> +		 * purely to prevent bouncing the gfn between an NX huge page
> +		 * and an X small spage. A vCPU could get stuck tearing down
> +		 * the shadow page, e.g. if it happens to fault on the region
> +		 * before the SPTE is zapped and replaces the shadow page with
> +		 * an NX huge page and get stuck tearing down the child SPTEs,
> +		 * but that is a rare race, i.e. shouldn't impact performance.
> +		 */
> +		unaccount_nx_huge_page(kvm, sp);
> +		spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
> +
> +		/*
> +		 * Don't bother zapping shadow pages if the memslot is being
> +		 * dirty logged, as the relevant pages would just be faulted back
> +		 * in as 4KiB pages. Potential NX Huge Pages in this slot will be
>  		 * recovered, along with all the other huge pages in the slot,
>  		 * when dirty logging is disabled.
>  		 */
> -		if (kvm_mmu_sp_dirty_logging_enabled(kvm, sp))
> -			unaccount_nx_huge_page(kvm, sp);
> -		else
> -			flush |= kvm_tdp_mmu_zap_sp(kvm, sp);
> +		if (!kvm_mmu_sp_dirty_logging_enabled(kvm, sp))
> +			flush |= tdp_mmu_zap_possible_nx_huge_page(kvm, sp);
>  		WARN_ON_ONCE(sp->nx_huge_page_disallowed);
>  
>  		if (need_resched() || rwlock_needbreak(&kvm->mmu_lock)) {

Tsk, tsk.  There's a cond_resched_rwlock_write() lurking here.

Which is a decent argument/segue for my main comment: I would very, very strongly
prefer to have a single flow for the control logic.  Almost all of the code is
copy+pasted to the TDP MMU, and there unnecessary and confusing differences between
the two flows.  E.g. the TDP MMU does unaccount_nx_huge_page() preemptively, while
the shadow MMU does not.

The TDP MMU has a few extra "locks" (rcu_read_lock() + tdp_mmu_pages_lock), but
I don't see any harm in taking those in the shadow MMU flow.  KVM holds a spinlock
and so RCU practically is meaningless, and tdp_mmu_pages_lock will never be
contended since it's only ever taken under mmu_lock.

If we _really_ wanted to bury tdp_mmu_pages_lock in the TDP MMU, it could be
passed in as an optional paramter.  I'm not super opposed to that, it just looks
ugly, and I'm not convinced it's worth the effort.  Maybe a middle ground would
be to provide a helper so that tdp_mmu_pages_lock can stay 64-bit only, but this
code doesn't need #ifdefs?

Anyways, if the helper is __always_inline, there shouldn't be an indirect call
to recover_page().  Completely untested, but this is the basic gist.

---
typedef bool (*nx_recover_page_t)(struct kvm *kvm, struct kvm_mmu_page *sp,
				  struct list_head *invalid_pages);

static __always_inline void kvm_recover_nx_huge_pages(struct kvm *kvm,
						      bool shared,
						      spinlock_t *list_lock;
						      struct list_head *pages,
						      unsigned long nr_pages,
						      nx_recover_page_t recover_page)
{
	unsigned int ratio = READ_ONCE(nx_huge_pages_recovery_ratio);
	unsigned long to_zap = ratio ? DIV_ROUND_UP(nr_pages, ratio) : 0;
	struct kvm_mmu_page *sp;
	LIST_HEAD(invalid_list);
	int rcu_idx;
	bool flush;

	kvm_lockdep_assert_mmu_lock_held(kvm, shared);

	rcu_idx = srcu_read_lock(&kvm->srcu);
	rcu_read_lock();

	for ( ; to_zap; --to_zap) {
		spin_lock(&kvm->arch.tdp_mmu_pages_lock);
		if (list_empty(pages)) {
			spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
			break;
		}

		sp = list_first_entry(pages, struct kvm_mmu_page,
				      possible_nx_huge_page_link);
		WARN_ON_ONCE(!sp->nx_huge_page_disallowed);
		WARN_ON_ONCE(!sp->role.direct);

		unaccount_nx_huge_page(kvm, sp);
		spin_unlock(&kvm->arch.tdp_mmu_pages_lock);

		if (!kvm_mmu_sp_dirty_logging_enabled(kvm, sp))
			flush |= recover_page(kvm, sp, &invalid_list);

		WARN_ON_ONCE(sp->nx_huge_page_disallowed);

		if (need_resched() || rwlock_needbreak(&kvm->mmu_lock)) {
			kvm_mmu_remote_flush_or_zap(kvm, &invalid_list, flush);

			rcu_read_unlock();

			if (shared)
				cond_resched_rwlock_read(&kvm->mmu_lock);
			else
				cond_resched_rwlock_write(&kvm->mmu_lock);

			rcu_read_lock();
		}
	}

	kvm_mmu_remote_flush_or_zap(kvm, &invalid_list, flush);

	rcu_read_unlock();
	srcu_read_unlock(&kvm->srcu, rcu_idx);
}

