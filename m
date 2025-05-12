Return-Path: <kvm+bounces-46264-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E594AB4656
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 23:33:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 10FF7464DB2
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 21:33:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14955299A97;
	Mon, 12 May 2025 21:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hKfWk3wD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5B1C29A32A
	for <kvm@vger.kernel.org>; Mon, 12 May 2025 21:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747085370; cv=none; b=hQTDyeWJdu8E1lnTPm8QAtc8/VCSyRHgnLKXy5Fc1PIQbKMOmV9EhiLkf/YffEpDIHHvo/Kkdo1JTM5J/wGMh1tomVHJS8U9eeCQK/mMinQUaStNrdy2SrgxBnWjgKvxXgt685Y5NFljjA4fwgIaX3HOe/RSoOKpZpbrfCGCjrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747085370; c=relaxed/simple;
	bh=Z5q1pavSEshfgtbKLxA4dVhOBJt55XXA25YiY0CRiCs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=URyA0ZuXUkfB0E2TBlAvUGjzdeXygzhVFbReopgL6AsLQqjzQBLw3NniA0zmbfXtIR6GRhNIAg7sVFiI7ZlDG14YL1zmDkHD7ZG5jYMcFyYx0r2kwZKVkIVh2njCwkQ87wziTb6EmvL+OhBKdymCgi8dIstOnkO/iGonTi+ZwM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hKfWk3wD; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7391d68617cso5131156b3a.0
        for <kvm@vger.kernel.org>; Mon, 12 May 2025 14:29:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747085368; x=1747690168; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wFGPSrY68zV4qyPR9Vt6PDfC7pmhdWCF2s5FvUcnXjk=;
        b=hKfWk3wDXzT1LFr51RHThWw13Q3+vzYKOBeR8Pr/ri63imq06iSW8d9wAsBnfnjCxz
         hk5kt1Z67WuvHYcF/owPRzhE5tTUa85e3jgyMAgH9qOrHy7CIo2qyxPT8A6DtUVFFoeS
         fCEGlHToxMdmArNGr8mBNAbb3UpwMiUAfXhKGq3SyxxycwU8GQmmDliauhAlGK84kuIL
         LcYbcZgTauUBZ028Jcv/B2xITlKToyjTZkBbpOJXKCAHOaIxkW/PazhJEZv+B0pl8OYI
         QctOTeGkRNdEu1PPzsmuP0Ru/FGuC+NCm1M5fLtDxZN72p/C6AFexiwrmvfjll/tNDfr
         2hyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747085368; x=1747690168;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wFGPSrY68zV4qyPR9Vt6PDfC7pmhdWCF2s5FvUcnXjk=;
        b=ZIcKquuLHWubyyDJD4KmHTgVU6Ua8aiNcgBii6/LErjoSOHjapFx9hYJwet/MZJ3+/
         GxeYTciSJAsqKKWFrSyd/raG4SgxTCwl0vKdW6EWiZPIPOk9mZPQAxyZmAxb/AoxW3q0
         ZOBFoGhKI1HRxej3KHpadwWmzN5kRoIGuOnTOyrM5NPWwtgblvepn1d6KIsaKvA6K3l2
         +MZi3zyUwAsbHOPGPqr8iYRykPxCGKR8xMu9JoQ0jbge7mdprM54oe5WfI2wBwebavJT
         O9FRQiM0COKj23MFn8TdfJ+rNJEalljWiRpyJUdMNMGEEwyaGrgkbkRmiUxPmXo36QwP
         IoWQ==
X-Forwarded-Encrypted: i=1; AJvYcCXNHTwAax2pKIiBb67B5Irq5QBiJHiwwHa6A7lcONmJugMhRHql0b61OPZXJnKVdpncEH8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzeFO70dHvDkVRHatWsEX7a2H+eZKgEmrKbY/d9pq+MC4waea4X
	SJ6rf8qj3JdHdVh9J4hT4B3exvuOidfpq4cQWkdTJqjofG5KBGbgKvS45Zc6S7dpMcxVovzkHhg
	kgw==
X-Google-Smtp-Source: AGHT+IEErX4BIBKCF5XOXHKn8v/zaso6HOh8FlMg8M1xwk6B4HHxvzFc9bvxMZVgLuQ/zE+dXGFVjXz3cD0=
X-Received: from pfbi25.prod.google.com ([2002:a05:6a00:af19:b0:73c:2470:addf])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:621a:b0:215:e8b5:3df
 with SMTP id adf61e73a8af0-215eb72648fmr1021843637.7.1747085367868; Mon, 12
 May 2025 14:29:27 -0700 (PDT)
Date: Mon, 12 May 2025 14:29:26 -0700
In-Reply-To: <20250313203702.575156-16-jon@nutanix.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250313203702.575156-1-jon@nutanix.com> <20250313203702.575156-16-jon@nutanix.com>
Message-ID: <aCJoNvABQugU2rdZ@google.com>
Subject: Re: [RFC PATCH 15/18] KVM: x86/mmu: Extend make_spte to understand MBEC
From: Sean Christopherson <seanjc@google.com>
To: Jon Kohler <jon@nutanix.com>
Cc: pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sergey Dyasli <sergey.dyasli@nutanix.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Mar 13, 2025, Jon Kohler wrote:
> Extend make_spte to mask in and out bits depending on MBEC enablement.

Same complaints about the shortlog and changelog not saying anything useful.

> 
> Note: For the RFC/v1 series, I've added several 'For Review' items that
> may require a bit deeper inspection, as well as some long winded
> comments/annotations. These will be cleaned up for the next iteration
> of the series after initial review.
> 
> Signed-off-by: Jon Kohler <jon@nutanix.com>
> Co-developed-by: Sergey Dyasli <sergey.dyasli@nutanix.com>
> Signed-off-by: Sergey Dyasli <sergey.dyasli@nutanix.com>
> 
> ---
>  arch/x86/kvm/mmu/paging_tmpl.h |  3 +++
>  arch/x86/kvm/mmu/spte.c        | 30 ++++++++++++++++++++++++++----
>  2 files changed, 29 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
> index a3a5cacda614..7675239f2dd1 100644
> --- a/arch/x86/kvm/mmu/paging_tmpl.h
> +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> @@ -840,6 +840,9 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
>  		 * then we should prevent the kernel from executing it
>  		 * if SMEP is enabled.
>  		 */
> +		// FOR REVIEW:
> +		// ACC_USER_EXEC_MASK seems not necessary to add here since
> +		// SMEP is for kernel-only.
>  		if (is_cr4_smep(vcpu->arch.mmu))
>  			walker.pte_access &= ~ACC_EXEC_MASK;

I would straight up WARN, because it should be impossible to reach this code with
ACC_USER_EXEC_MASK set.  In fact, this entire blob of code should be #ifdef'd
out for PTTYPE_EPT.  AFAICT, the only reason it doesn't break nEPT is because
its impossible to have a WRITE EPT violation without READ (a.k.a. USER) being
set.

>  	}
> diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
> index 6f4994b3e6d0..89bdae3f9ada 100644
> --- a/arch/x86/kvm/mmu/spte.c
> +++ b/arch/x86/kvm/mmu/spte.c
> @@ -178,6 +178,9 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
>  	else if (kvm_mmu_page_ad_need_write_protect(sp))
>  		spte |= SPTE_TDP_AD_WRPROT_ONLY;
>  
> +	// For LKML Review:
> +	// In MBEC case, you can have exec only and also bit 10
> +	// set for user exec only. Do we need to cater for that here?
>  	spte |= shadow_present_mask;
>  	if (!prefetch)
>  		spte |= spte_shadow_accessed_mask(spte);
> @@ -197,12 +200,31 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
>  	if (level > PG_LEVEL_4K && (pte_access & ACC_EXEC_MASK) &&

Needs to check ACC_USER_EXEC_MASK.

>  	    is_nx_huge_page_enabled(vcpu->kvm)) {
>  		pte_access &= ~ACC_EXEC_MASK;
> +		if (vcpu->arch.pt_guest_exec_control)
> +			pte_access &= ~ACC_USER_EXEC_MASK;
>  	}
>  
> -	if (pte_access & ACC_EXEC_MASK)
> -		spte |= shadow_x_mask;
> -	else
> -		spte |= shadow_nx_mask;
> +	// For LKML Review:
> +	// We could probably optimize the logic here, but typing it out
> +	// long hand for now to make it clear how we're changing the control
> +	// flow to support MBEC.

I appreciate the effort, but this did far more harm than good.  Reviewing code
that has zero chance of being the end product is a waste of time.  And unless I'm
overlooking a subtlety, you're making this way harder than it needs to be:

	if (pte_access & (ACC_EXEC_MASK | ACC_USER_EXEC_MASK)) {
		if (pte_access & ACC_EXEC_MASK)
			spte |= shadow_x_mask;

		if (pte_access & ACC_USER_EXEC_MASK)
			spte |= shadow_ux_mask;
	} else {
		spte |= shadow_nx_mask;
	}

KVM needs to ensure ACC_USER_EXEC_MASK isn't spuriously set, but KVM should be
doing that anyways.

> +	if (!vcpu->arch.pt_guest_exec_control) { // non-mbec logic
> +		if (pte_access & ACC_EXEC_MASK)
> +			spte |= shadow_x_mask;
> +		else
> +			spte |= shadow_nx_mask;
> +	} else { // mbec logic
> +		if (pte_access & ACC_EXEC_MASK) { /* mbec: kernel exec */
> +			if (pte_access & ACC_USER_EXEC_MASK)
> +				spte |= shadow_x_mask | shadow_ux_mask; // KMX = 1, UMX = 1
> +			else
> +				spte |= shadow_x_mask;  // KMX = 1, UMX = 0
> +		} else if (pte_access & ACC_USER_EXEC_MASK) { /* mbec: user exec, no kernel exec */
> +			spte |= shadow_ux_mask; // KMX = 0, UMX = 1
> +		} else { /* mbec: nx */
> +			spte |= shadow_nx_mask; // KMX = 0, UMX = 0
> +		}
> +	}
>  
>  	if (pte_access & ACC_USER_MASK)
>  		spte |= shadow_user_mask;
> -- 
> 2.43.0
> 

