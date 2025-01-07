Return-Path: <kvm+bounces-34684-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DA99FA044CE
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 16:37:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F12EE166726
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 15:37:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05DBB86321;
	Tue,  7 Jan 2025 15:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tHlbg3fz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67FAE1EB9FA
	for <kvm@vger.kernel.org>; Tue,  7 Jan 2025 15:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736264239; cv=none; b=tvAqiEQ3CbPaccWKTEIV9kXVUfiHdeTk9jbnLanY/DB1dEmvLW9CsTGlhgKp8Azx3mEdTmCDRTq5UqJN1/3g+3tQBw7zSycmTZlp5t4RsnZ5ef4fc9tC3yYEYB+7ow/iJ8vtitHVMef2CLCAw6dF1S6TBS8Dlh1pGMVy7SU+Wmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736264239; c=relaxed/simple;
	bh=F4/LI+uB2CnK80OddDYi9LhBh4HsQFR8rK5omlU/yps=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ucnL8C68SW5sCPh7z6oq/oZZ72kj8oN0iycMPPSnFWaTIEwC8fVORRmsehkovGbEAC6dM0h66EVncNufsJoOVz0GJZ/0LfYfd2z7ZVDTxZH5GsSLi+OE9N18o9osoDtoaLBKnIVJAw8eq7mpg2tp+EYN13VS3Hmfct2MnNRg0aA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tHlbg3fz; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2167141e00eso218974775ad.2
        for <kvm@vger.kernel.org>; Tue, 07 Jan 2025 07:37:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736264237; x=1736869037; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=sYR9ivMdpu6wL5+ta6egPuybFc6sUS3JUHt1ZpqHAIc=;
        b=tHlbg3fzINQMZ4TeB9jG4RFNKpNGD1lQ01R5JmFCJXpVowHhtG1EpazhYpr6bD+U/c
         eRFrLmgtKBrIpZADOd7M9FFamvJPkmOEg0zKYsMDuShy9FdGQRiUMU5YfDDg51XJcEo+
         t0WnyOvQnI6YiprXDmvOL/vphT8Iz5uK61jJXyB6ZkmInlzFACZ8vAWKT3HDN2qgdnOb
         ccfaiaE0P281aoEUsM2pD8kg3+lXAzm9ENDnUXQ31rbM5xEJvjJM8fO3vts+VEI+UWWZ
         NdoMiHkmpx7IzUGA1oim4u09vDO2fOeOSP/kUNflpeU7hP24zeTE5+nYT19AT5a55vtc
         jOBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736264237; x=1736869037;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sYR9ivMdpu6wL5+ta6egPuybFc6sUS3JUHt1ZpqHAIc=;
        b=Zc1xIs5lGA10IzFjJC4SxAXU7jIRDi3eqVNFVcofWNt/CsDswg4ZOzBy7/YWtGJite
         0P8Bu5HwsS/PPyYV7+hBqLPRPuECELP8ZOVa1VLFqNK4qOO9PKL7ylBXJ2Sm5R149bfw
         /lggmPyIW934pnjuvzxr/pxwSl3eL/9E6EELsao4AHB/RUhCBX06pVv6AfzOKQN9DLXY
         HfkB8rbtC6Te2XVopuOcR3c5P+nMmCL/rDj5P8MIfD18Yg8lUKia09kZgOscnKMa3tnj
         PuUyOBXR0hzpVO+2eoLCIlls8/Nx7WP35UIftqvuvYogqeMR5Gbprqhj9O93QHTcHA5n
         MTpg==
X-Forwarded-Encrypted: i=1; AJvYcCWYczNTkZoeiknnCDN6fdYO7KolgYYxoOPUZD2fb1l9hA4RUnL8ujqNSarmEcwqOTE+xr0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwHK1syOD9T5/11mvX8vtg+0Dco5J6/2O+qQ9G9pLOcIRknTGuv
	+FiQ9N3ra8Uy19WmDIqe/mfqti8J0ULXrl+dlOWHdir2eMrqd221eDAgq/B0fr13lWbmHoNVB/z
	U3Q==
X-Google-Smtp-Source: AGHT+IEBz1WfrNvpbqdnhmVR1h4LxDG5BHeyBbehKAT+A0DZ3ViYxF7r/QkQCH9qPUwuon3T24PasV0mibQ=
X-Received: from pfan20.prod.google.com ([2002:aa7:8a54:0:b0:72a:bc6b:89ad])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6300:6681:b0:1e0:c6c0:1e1f
 with SMTP id adf61e73a8af0-1e5e07f8a98mr89298008637.36.1736264236650; Tue, 07
 Jan 2025 07:37:16 -0800 (PST)
Date: Tue, 7 Jan 2025 07:37:15 -0800
In-Reply-To: <20250107042202.2554063-3-suleiman@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250107042202.2554063-1-suleiman@google.com> <20250107042202.2554063-3-suleiman@google.com>
Message-ID: <Z31KK-9Z_b-UleVT@google.com>
Subject: Re: [PATCH v3 2/3] KVM: x86: Include host suspended time in steal time.
From: Sean Christopherson <seanjc@google.com>
To: Suleiman Souhlal <suleiman@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Chao Gao <chao.gao@intel.com>, 
	David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	ssouhlal@freebsd.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Jan 07, 2025, Suleiman Souhlal wrote:
> When the host resumes from a suspend, the guest thinks any task
> that was running during the suspend ran for a long time, even though
> the effective run time was much shorter, which can end up having
> negative effects with scheduling. This can be particularly noticeable
> if the guest task was RT, as it can end up getting throttled for a
> long time.
> 
> To mitigate this issue, we include the time that the host was

No "we".

> suspended in steal time, which lets the guest can subtract the
> duration from the tasks' runtime.
> 
> Note that the case of a suspend happening during a VM migration
> might not be accounted.

And this isn't considered a bug because?  I asked for documentation, not a
statement of fact.

> Change-Id: I18d1d17d4d0d6f4c89b312e427036e052c47e1fa

gerrit.

> Signed-off-by: Suleiman Souhlal <suleiman@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  1 +
>  arch/x86/kvm/x86.c              | 11 ++++++++++-
>  2 files changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index e159e44a6a1b61..01d44d527a7f88 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -897,6 +897,7 @@ struct kvm_vcpu_arch {
>  		u8 preempted;
>  		u64 msr_val;
>  		u64 last_steal;
> +		u64 last_suspend_ns;
>  		struct gfn_to_hva_cache cache;
>  	} st;
>  
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index c8160baf383851..12439edc36f83a 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3650,7 +3650,7 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
>  	struct kvm_steal_time __user *st;
>  	struct kvm_memslots *slots;
>  	gpa_t gpa = vcpu->arch.st.msr_val & KVM_STEAL_VALID_BITS;
> -	u64 steal;
> +	u64 steal, suspend_ns;
>  	u32 version;
>  
>  	if (kvm_xen_msr_enabled(vcpu->kvm)) {
> @@ -3677,6 +3677,7 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
>  			return;
>  	}
>  
> +	suspend_ns = kvm_total_suspend_ns();
>  	st = (struct kvm_steal_time __user *)ghc->hva;
>  	/*
>  	 * Doing a TLB flush here, on the guest's behalf, can avoid
> @@ -3731,6 +3732,13 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
>  	steal += current->sched_info.run_delay -
>  		vcpu->arch.st.last_steal;
>  	vcpu->arch.st.last_steal = current->sched_info.run_delay;
> +	/*
> +	 * Include the time that the host was suspended in steal time.
> +	 * Note that the case of a suspend happening during a VM migration
> +	 * might not be accounted.
> +	 */

This is not a useful comment.  It's quite clear what that suspend time is being
accumulated into steal_time, and restating the migration caveat does more harm
than good, as that flaw is an issue with the overall design, i.e. has nothing to
do with this specific snippet of code.

> +	steal += suspend_ns - vcpu->arch.st.last_suspend_ns;
> +	vcpu->arch.st.last_suspend_ns = suspend_ns;
>  	unsafe_put_user(steal, &st->steal, out);
>  
>  	version += 1;
> @@ -12299,6 +12307,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>  	if (r)
>  		goto free_guest_fpu;
>  
> +	vcpu->arch.st.last_suspend_ns = kvm_total_suspend_ns();
>  	kvm_xen_init_vcpu(vcpu);
>  	vcpu_load(vcpu);
>  	kvm_set_tsc_khz(vcpu, vcpu->kvm->arch.default_tsc_khz);
> -- 
> 2.47.1.613.gc27f4b7a9f-goog
> 

