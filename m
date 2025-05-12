Return-Path: <kvm+bounces-46263-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6EC17AB4603
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 23:17:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DC8597A8FC6
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 21:16:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F00F299A8A;
	Mon, 12 May 2025 21:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TX4MuAT1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9BF8383
	for <kvm@vger.kernel.org>; Mon, 12 May 2025 21:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747084620; cv=none; b=aD40ldQpkw3XdPqHk8YT9tmxMm6vknvgT2RDtbHQlFwAGG1gI/2axMyonV8pG6iQCUxM5+88s9USobL4fvg5jsYaVC5cgOdyd0dAorJ2C58+8nAaBPAXn8U201WKvrpX5jEodxzIfpWixT52FestbhXNVYhWLtCvQD7cgr/oPwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747084620; c=relaxed/simple;
	bh=lkeykJikOeyv1ybABVyRTwjYLOxL+eJqCKaS/P2GoJI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lppBJ71eMoEkXRvc/N+aABi00YGMA29SWwpv3SQBzO1VKUHSKxD58PfkJCOvjpsVOLsDY2SuOb7TPjrJ0DXyTTplXZg4b6Ige7MXat9I4lvooQZnSo38AVqcZnofy19jEbCfRh/ldEUVFQ/ePlOeBlRnw2gwpNMXR5Bn71WTL0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TX4MuAT1; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-30aab0f21a3so4475773a91.3
        for <kvm@vger.kernel.org>; Mon, 12 May 2025 14:16:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747084617; x=1747689417; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=a3JVENfn6Nw8P6AJDLTM38Bwvcoxx70DdENf7TcQSOc=;
        b=TX4MuAT1b31EoS8GyJS/BILlK6NcqiP7AbJdVipbtIgUcUjdCXmb/nKj706wZsXE3l
         yo25HsSoAfx1ZnFsIvUllC+Yz4YifSdXvqieCMOKGPxu3iqpNM2GJb1/177spD52qpd1
         wYxbj0eAbfeii5rXmsd+NMtKsAJUZS/rcpgyKgVW2CBipK90enoDtUD/KjBe4rioFZGq
         GC4skG5ysU6A0G7JY6Jxl0tp+Q3C5E9IKxj7kJTnUYN4+CoRlTqbDjqwwJ8vpBRU+FHX
         xrbmdj+RPEhFH77bGVonaUrUpz1aY8P/+NmHCQwiVJf2hKRwYyb506nHhvemDIqt/05x
         shnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747084617; x=1747689417;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=a3JVENfn6Nw8P6AJDLTM38Bwvcoxx70DdENf7TcQSOc=;
        b=UhqFa0E2lE0NH4ZNsWPeddnMp4a1VR44k7OU2vKUpvCugXhoe12hKuNKAizBN9fQtD
         Yme/0A8LuaAKQeXbGTZXBL8eFWFVEb79vbqZxenE0CRDPc+aXU6O/D/GR3Fg47LCCzts
         ojtALPLD7tcqPng1Ywdp5SwcgaqsqynY9lTbyPxD8GtLehSs/ujzvqUWzPQVMm0njkEl
         vTs1B3y+VjByDwtQVam4lcnYMY6kUDPLdv3ToFy75Q9K7Vrgb0H9+4LpwPlyJDrvL8ay
         CcefL5BFik7Gvx1kxOdDAFoY1infN8Fgz017OLRHTwkNK1qH7t2gue5qmWFe0s3KUTrj
         mIiA==
X-Forwarded-Encrypted: i=1; AJvYcCWNpkohNOYHkFHSPdVXBWcTIPBLvnGT5guEdjX0Z08E9TOJfcd581UzTsCGW9gPk/bDOUQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyXminp4S1Ms3+Xlf1XU8AZ1K8vCoOVdSOyHqub0u7K6CAwkaVu
	FXIEVFdTvLe98fdfI/OwzjHy2XL0tZs4nmWsDVWmvPOWRXMc4huLosmYFdA1O/ZdbfjPqyEj51Y
	4kw==
X-Google-Smtp-Source: AGHT+IG8WDYQtnSlI1QQ3EJgDr8HcIQ+NM/0nbeRleJpPHBfnwbBY1zwTZNbTyzjJMnr4V6OfvawO3NNABE=
X-Received: from pjbpl8.prod.google.com ([2002:a17:90b:2688:b0:308:670e:aa2c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2d06:b0:2ee:edae:780
 with SMTP id 98e67ed59e1d1-30c3d2e2e67mr25209634a91.15.1747084617008; Mon, 12
 May 2025 14:16:57 -0700 (PDT)
Date: Mon, 12 May 2025 14:16:55 -0700
In-Reply-To: <20250313203702.575156-15-jon@nutanix.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250313203702.575156-1-jon@nutanix.com> <20250313203702.575156-15-jon@nutanix.com>
Message-ID: <aCJlR9jZniZN_7cH@google.com>
Subject: Re: [RFC PATCH 14/18] KVM: x86/mmu: Extend is_executable_pte to
 understand MBEC
From: Sean Christopherson <seanjc@google.com>
To: Jon Kohler <jon@nutanix.com>
Cc: pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	"=?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?=" <mic@digikod.net>
Content-Type: text/plain; charset="us-ascii"

On Thu, Mar 13, 2025, Jon Kohler wrote:
> @@ -359,15 +360,17 @@ TRACE_EVENT(
>  		__entry->sptep = virt_to_phys(sptep);
>  		__entry->level = level;
>  		__entry->r = shadow_present_mask || (__entry->spte & PT_PRESENT_MASK);
> -		__entry->x = is_executable_pte(__entry->spte);
> +		__entry->kx = is_executable_pte(__entry->spte, true, vcpu);
> +		__entry->ux = is_executable_pte(__entry->spte, false, vcpu);
>  		__entry->u = shadow_user_mask ? !!(__entry->spte & shadow_user_mask) : -1;
>  	),
>  
> -	TP_printk("gfn %llx spte %llx (%s%s%s%s) level %d at %llx",
> +	TP_printk("gfn %llx spte %llx (%s%s%s%s%s) level %d at %llx",
>  		  __entry->gfn, __entry->spte,
>  		  __entry->r ? "r" : "-",
>  		  __entry->spte & PT_WRITABLE_MASK ? "w" : "-",
> -		  __entry->x ? "x" : "-",
> +		  __entry->kx ? "X" : "-",
> +		  __entry->ux ? "x" : "-",

I don't have a better idea, but I do worry that X vs. x will lead to confusion.
But as I said, I don't have a better idea...

>  		  __entry->u == -1 ? "" : (__entry->u ? "u" : "-"),
>  		  __entry->level, __entry->sptep
>  	)
> diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
> index 1f7b388a56aa..fd7e29a0a567 100644
> --- a/arch/x86/kvm/mmu/spte.h
> +++ b/arch/x86/kvm/mmu/spte.h
> @@ -346,9 +346,20 @@ static inline bool is_last_spte(u64 pte, int level)
>  	return (level == PG_LEVEL_4K) || is_large_pte(pte);
>  }
>  
> -static inline bool is_executable_pte(u64 spte)
> +static inline bool is_executable_pte(u64 spte, bool for_kernel_mode,

s/for_kernel_mode/is_user_access and invert.  A handful of KVM comments describe
supervisor as "kernel mode", but those are quite old and IMO unnecessarily imprecise.

> +				     struct kvm_vcpu *vcpu)

This needs to be an mmu (or maybe a root role?).  Hmm, thinking about the page
role, I don't think one new bit will suffice.  Simply adding ACC_USER_EXEC_MASK
won't let KVM differentiate between shadow pages created with ACC_EXEC_MASK for
an MMU without MBEC, and a page created explicitly without ACC_USER_EXEC_MASK
for an MMU *with* MBEC.

What I'm not sure about is if MBEC/GMET support needs to be captured in the base
page role, or if it shoving it in kvm_mmu_extended_role will suffice.  I'll think
more on this and report back, need to refresh all the shadowing paging stuff, again...


>  {
> -	return (spte & (shadow_x_mask | shadow_nx_mask)) == shadow_x_mask;
> +	u64 x_mask = shadow_x_mask;
> +
> +	if (vcpu->arch.pt_guest_exec_control) {
> +		x_mask |= shadow_ux_mask;
> +		if (for_kernel_mode)
> +			x_mask &= ~VMX_EPT_USER_EXECUTABLE_MASK;
> +		else
> +			x_mask &= ~VMX_EPT_EXECUTABLE_MASK;
> +	}

This is going to get messy when GMET support comes along, because the U/S bit
would need to be inverted to do the right thing for supervisor fetches.  Rather
than trying to shoehorn support into the existing code, I think we should prep
for GMET and make the code a wee bit easier to follow in the process.  We can
even implement the actual GMET semanctics, but guarded with a WARN (emulating
GMET isn't a terrible fallback in the event of a KVM bug).

	if (spte & shadow_nx_mask)
		return false;

	if (!role.has_mode_based_exec)
		return (spte & shadow_x_mask) == shadow_x_mask;

	if (WARN_ON_ONCE(!shadow_x_mask))
		return is_user_access || !(spte & shadow_user_mask);

	return spte & (is_user_access ? shadow_ux_mask : shadow_x_mask);

