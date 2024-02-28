Return-Path: <kvm+bounces-10180-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 70DAA86A648
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 03:03:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2D1DB28D5CD
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 02:03:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70CF863BF;
	Wed, 28 Feb 2024 02:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RNfKPtf0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37AA44405
	for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 02:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709085785; cv=none; b=EeSocnw5J06iL+jdcU5sam60UCebqlDGZ2p75FUQN6M9m78mBraLelirGTkLpiHaiQpVn5ACSUC08PQq2VzwTFH11C+yihqgkymRr6PyEH78shd/TOv3jyllp4/LiMmW5lX4cGRrJDakvB7gf405MPuvWnh4uH5v62LhENCf0to=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709085785; c=relaxed/simple;
	bh=4on74mCYLeE6XaAwNoUjaXzsgV6wvEl6lBJmqfetf9k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KKeib2hlhYbEFUV9xfMh8tQ77PI7SEyogCGDb/9VhO2AvZ4aRJz7ZoDmtoeQgnaNVve12cG0NNYi/j+R+kMoBz1aIqYd90XVsihCIthk3ZPwbhsIJGDX5CtImAW6i/Njplv98bw+uGCpiPoRORtl8BjwGZ8fMEDit2+66eYL3Es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RNfKPtf0; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-5efe82b835fso101779777b3.0
        for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 18:03:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709085783; x=1709690583; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2cRk3uqvSbJiBHA3pyhGkClPVcG1HOgMZ3vlrWdyKlg=;
        b=RNfKPtf0FOjno52HqOg1L+E2Ncf7KNg1pCXFiGPr8aQp2k1Fi0+Jbav4dmR7Sdg3Sx
         WIQQIack4+Hf8X89I8XQFmO+Knxc5pqXlO+fN+7sJPZo4o9Lt9Nf4EFf+vixHYdK6O3j
         nhLQjY5zZH92KRoHJexIMSHoAducE43vF268hY986rYShBnPtlxz7HyPrQKyqpzE7Ihj
         r+UtbUhJcvBwCvQWQuo6WI2t3w3KhUGmF+mc5/tv2C4M7A5+hBcmcj/gEqVOLOh8WTlR
         pAlo40RZFcq0N7P1xXkBSg+0Pgf47tWAbpWeLrSvvbg3306mMWatgFJq7kvUnzzpKGQQ
         IYVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709085783; x=1709690583;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2cRk3uqvSbJiBHA3pyhGkClPVcG1HOgMZ3vlrWdyKlg=;
        b=dJ5NzRuL8cMoEk+VDZSaVOgKC1/w7m6XbiQo1za3ZVizMb8XQzpPN0PKGIn6Jp8KSn
         mFPwik+MzO9TwOSik3gxiiorFYgLlfl5E8OkLz//YRfVfrWQ03Yt0Fp1o83Y2PUpUPca
         TmHtawKEMCYyi25xnuCwloVh6hsBtFzg67shnKDZQ58ngTYxewt3wYOVQweCMafR3lPY
         LM2dgKzdFZXkU4msBWCSJQCqlgtnv/mByvy1Az8jVUiB2x9nqgI20bxrN8N6eayA011s
         U/3jKE4b/KYWy9x5Fx8LLWcLRo5DyuUmuE03NKfClUWtAcRN0eltBr85qTDav/603xoV
         j1WQ==
X-Forwarded-Encrypted: i=1; AJvYcCXKhZltAl5k7Ti/PQAsNAxaxUfiLWDAqWefd5ZmoH8cZJKuayyKw/EcaJAaIjkpfcoS8cDAFB1y1/7VFezYn3watURV
X-Gm-Message-State: AOJu0Yy0mSeV7XX4iqDIxPRcfpgGw5rOmJgIXoNGT3rzLbKprs5CIi8n
	Y21uAhp9eItP5hNwTvGAHA3KxvBoMpEj151Oyrd93+M+qquaYuyRkcxuVVM2VbocR8Wd24zV/dE
	Y7w==
X-Google-Smtp-Source: AGHT+IEK2yrVKUL7lEaC9JelCIFBpRdLkIgZXj7tAXuA6PffgrnMLO39NARWg5HKV7bsg3dCjSBeiyxN4gs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:fe08:0:b0:608:f15:5ba7 with SMTP id
 j8-20020a81fe08000000b006080f155ba7mr907857ywn.0.1709085783122; Tue, 27 Feb
 2024 18:03:03 -0800 (PST)
Date: Tue, 27 Feb 2024 18:03:01 -0800
In-Reply-To: <20240227232100.478238-15-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240227232100.478238-1-pbonzini@redhat.com> <20240227232100.478238-15-pbonzini@redhat.com>
Message-ID: <Zd6UVfhzdMp8z2O2@google.com>
Subject: Re: [PATCH 14/21] KVM: x86/mmu: pass error code back to MMU when
 async pf is ready
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, michael.roth@amd.com, 
	isaku.yamahata@intel.com, thomas.lendacky@amd.com
Content-Type: text/plain; charset="us-ascii"

On Tue, Feb 27, 2024, Paolo Bonzini wrote:
> Right now the error code is not used when an async page fault is completed.
> This is not a problem in the current code, but it is untidy.  For protected
> VMs we need to check that the page attributes match the current state of the
> page.  Async page faults can only occur on shared pages (because
> private pages go through kvm_faultin_pfn_private() instead of
> __gfn_to_pfn_memslot()), but it is risky to rely on the polarity of
> PFERR_GUEST_ENC_MASK and the high 32 bits of the error code being zero.
> So, for clarity and future-proofing of the code, pipe the error code
> from kvm_arch_setup_async_pf() to kvm_arch_async_page_ready() via the
> architecture-specific async page fault data.
> 
> Extracted from a patch by Isaku Yamahata.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  1 +
>  arch/x86/kvm/mmu/mmu.c          | 14 +++++++-------
>  2 files changed, 8 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index a4514c2ef0ec..24e30ca2ca8f 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1839,6 +1839,7 @@ struct kvm_arch_async_pf {
>  	gfn_t gfn;
>  	unsigned long cr3;
>  	bool direct_map;
> +	u64 error_code;
>  };
>  
>  extern u32 __read_mostly kvm_nr_uret_msrs;
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index f58ca6cb789a..c9890e5b6e4c 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4260,18 +4260,18 @@ static u32 alloc_apf_token(struct kvm_vcpu *vcpu)
>  	return (vcpu->arch.apf.id++ << 12) | vcpu->vcpu_id;
>  }
>  
> -static bool kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
> -				    gfn_t gfn)
> +static bool kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu,
> +				    struct kvm_page_fault *fault)
>  {
>  	struct kvm_arch_async_pf arch;
>  
>  	arch.token = alloc_apf_token(vcpu);
> -	arch.gfn = gfn;
> +	arch.gfn = fault->gfn;
>  	arch.direct_map = vcpu->arch.mmu->root_role.direct;
>  	arch.cr3 = kvm_mmu_get_guest_pgd(vcpu, vcpu->arch.mmu);
>  
> -	return kvm_setup_async_pf(vcpu, cr2_or_gpa,
> -				  kvm_vcpu_gfn_to_hva(vcpu, gfn), &arch);
> +	return kvm_setup_async_pf(vcpu, fault->addr,
> +				  kvm_vcpu_gfn_to_hva(vcpu, fault->gfn), &arch);
>  }
>  
>  void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
> @@ -4290,7 +4290,7 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
>  	      work->arch.cr3 != kvm_mmu_get_guest_pgd(vcpu, vcpu->arch.mmu))
>  		return;
>  
> -	kvm_mmu_do_page_fault(vcpu, work->cr2_or_gpa, 0, true, NULL);
> +	kvm_mmu_do_page_fault(vcpu, work->cr2_or_gpa, work->arch.error_code, true, NULL);

This is silly.  If we're going to bother plumbing in the error code, then we
should use it to do sanity checks.  Things have gone off the rails if end up with
an async #PF on private memory.

>  }
>  
>  static inline u8 kvm_max_level_for_order(int order)
> @@ -4395,7 +4395,7 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
>  			trace_kvm_async_pf_repeated_fault(fault->addr, fault->gfn);
>  			kvm_make_request(KVM_REQ_APF_HALT, vcpu);
>  			return RET_PF_RETRY;
> -		} else if (kvm_arch_setup_async_pf(vcpu, fault->addr, fault->gfn)) {
> +		} else if (kvm_arch_setup_async_pf(vcpu, fault)) {
>  			return RET_PF_RETRY;
>  		}
>  	}
> -- 
> 2.39.0
> 
> 

