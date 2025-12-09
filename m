Return-Path: <kvm+bounces-65571-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 45E1BCB0A8F
	for <lists+kvm@lfdr.de>; Tue, 09 Dec 2025 18:03:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id A59ED3019629
	for <lists+kvm@lfdr.de>; Tue,  9 Dec 2025 17:03:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 723C2329E7E;
	Tue,  9 Dec 2025 16:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EHwSTebW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7371332ED21
	for <kvm@vger.kernel.org>; Tue,  9 Dec 2025 16:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765299177; cv=none; b=o4V3XpUwBTVjzMw+AB70azm8rb6DlT8z7ICO0m1QAM60Nb7MRyn2Ra/2k48fDr+NVhT0NNQrWaOZILoko52p6XKDdngjPJPebU+dDtJztF+7Qr9I6wu2QwPl5xx1dBsD+Zhm8JuhRdoQKqTqYuhOEE0v8vEZkzwC321b/uhtpKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765299177; c=relaxed/simple;
	bh=4NGxUFeSDZR1lpivl+wtCl2pAJgtHYkLyCOsOgrOsbk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nQoIVGAK2+f46DG0ATL7CZv6Xy0pTmpRGCz/yKCpTrvXlbwIVq5m8v+FoVbTVg5TX4pzFB5k8WZ5S7ydZhBiodphBt+q4nT5JfpuowBHOgQUTWuKOU+1k4ONHxTkEd+ynd+FesezTXGsTsIFhnFibI6tR27/K0OwA3vlS/4eSS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EHwSTebW; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3438744f12fso15221397a91.2
        for <kvm@vger.kernel.org>; Tue, 09 Dec 2025 08:52:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765299175; x=1765903975; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=EJgZoMD9RSsV+i2jtLwOC9BEsIC80q2fVMD6po/0Nhk=;
        b=EHwSTebW1LzpQnogCmlTNFXRCnglKnScyPAGIlJc6OCyKDt3mqHmjM3vmgfzaFpmc8
         nz4vsiwx+0O5UypR2gJ2tCulZTiY6yQfNvwoizvC/Ff/TlnL1FhugnOH9T0u/Mc47ze6
         iGkN2lE2mS5ukxI7C95/gpTspPWCyg/Rdslfx8lixBdiWHdEYqthX7iRWUq8w+aFARKg
         boMokq3iqmQ0gV80Z/ajOqaFnd9c6NMag0muI9L1XyLx8kEPxjJkq8te++XAQCjUBVHs
         aoqAXacm7hXC3f/fM4qICG5UY6zfQzdXlY0QjI/ND0uD4cjAwIByYkUie/hXTfEv2jH6
         cf/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765299175; x=1765903975;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EJgZoMD9RSsV+i2jtLwOC9BEsIC80q2fVMD6po/0Nhk=;
        b=eaOK9cUSQHCNNnHoUSCE+G2QlenXDfHq4ST2WAyqeb5ROF/b6bHMjNwjjVXyB5IPvq
         anSh5Q2h1wwTTlTXxdFcNwNc8vXZP+GVAkD2tQjMhOJvI9Qurj09h6x/tD4cVZ3oeIz0
         /DDrmv+oBiK+NcQtmXTVXQvkyclRJTEXibmiqljtuinmjVqf4uHh6MZs3kUpGzekmg1O
         UAyldPuGZD8YNeQ69/TpFhdbLeE71C9x9eEQRPEXT9ynOmwSqhj3r2qRkMsbr+rm2XeZ
         clNmN/uEdbK08Y03QUsEbmLi9gf+tCjYBtlZxtKJz0stMI5xgt3XjDH77zXen25X5pLm
         94Yw==
X-Forwarded-Encrypted: i=1; AJvYcCXx4NZFbpO17XOU+rv42sW/yTu9ajcBA6Ft7EGdM2KguUFr19JStv4qbHpRCzBsbsPrUKE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxD4hTnCMVZpbGM3lgBcgUn+14PvmO8Z/KtboRenTnrqPDe8z1O
	ucfiTcAQPRI6ChPp/JYZiyHghxyUuM7a4ckgaoYSRKoSbzEDkJfVil8zHnQpMWeNLlfMfH8QvG6
	nWERLlA==
X-Google-Smtp-Source: AGHT+IGdc0pzuAKQ4XqewrxBnrdB+VGX0brdUCowtbA6utIyqjEuZW6lgZy3RELLwFidJPsKO01bwJ+xhQ8=
X-Received: from pjbjz24.prod.google.com ([2002:a17:90b:14d8:b0:340:c9ea:fff])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4a4b:b0:32b:65e6:ec48
 with SMTP id 98e67ed59e1d1-349a253dca5mr11817894a91.8.1765299174678; Tue, 09
 Dec 2025 08:52:54 -0800 (PST)
Date: Tue, 9 Dec 2025 08:52:53 -0800
In-Reply-To: <20251205070630.4013452-1-chengkev@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251205070630.4013452-1-chengkev@google.com>
Message-ID: <aThT5d5WdMSszN9b@google.com>
Subject: Re: [PATCH] KVM: SVM: Don't allow L1 intercepts for instructions not advertised
From: Sean Christopherson <seanjc@google.com>
To: Kevin Cheng <chengkev@google.com>
Cc: pbonzini@redhat.com, jmattson@google.com, yosry.ahmed@linux.dev, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, Dec 05, 2025, Kevin Cheng wrote:
> If a feature is not advertised in the guest's CPUID, prevent L1 from
> intercepting the unsupported instructions by clearing the corresponding
> intercept in KVM's cached vmcb12.
> 
> When an L2 guest executes an instruction that is not advertised to L1,
> we expect a #UD exception to be injected by L0. However, the nested svm
> exit handler first checks if the instruction intercept is set in vmcb12,
> and if so, synthesizes an exit from L2 to L1 instead of a #UD exception.
> If a feature is not advertised, the L1 intercept should be ignored.
> 
> Calculate the nested intercept mask by checking all instructions that
> can be intercepted and are controlled by a CPUID bit. Use this mask when
> copying from the vmcb12 to KVM's cached vmcb12 to effectively ignore the
> intercept on nested vm exit handling.
> 
> Another option is to handle ignoring the L1 intercepts in the nested vm
> exit code path, but I've gone with modifying the cached vmcb12 to keep
> it simpler.
> 
> Signed-off-by: Kevin Cheng <chengkev@google.com>
> ---
>  arch/x86/kvm/svm/nested.c | 30 +++++++++++++++++++++++++++++-
>  arch/x86/kvm/svm/svm.c    |  2 ++
>  arch/x86/kvm/svm/svm.h    | 14 ++++++++++++++
>  3 files changed, 45 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index c81005b245222..f2ade24908b39 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -184,6 +184,33 @@ void recalc_intercepts(struct vcpu_svm *svm)
>  	}
>  }
> 
> +/*
> + * If a feature is not advertised to L1, set the mask bit for the corresponding
> + * vmcb12 intercept.
> + */
> +void svm_recalc_nested_intercepts_mask(struct kvm_vcpu *vcpu)
> +{
> +	struct vcpu_svm *svm = to_svm(vcpu);
> +
> +	memset(svm->nested.nested_intercept_mask, 0,
> +	       sizeof(svm->nested.nested_intercept_mask));
> +
> +	if (!guest_cpu_cap_has(vcpu, X86_FEATURE_RDTSCP))
> +		set_nested_intercept_mask(&svm->nested, INTERCEPT_RDTSCP);
> +
> +	if (!guest_cpu_cap_has(vcpu, X86_FEATURE_SKINIT))
> +		set_nested_intercept_mask(&svm->nested, INTERCEPT_SKINIT);
> +
> +	if (!guest_cpu_cap_has(vcpu, X86_FEATURE_XSAVE))
> +		set_nested_intercept_mask(&svm->nested, INTERCEPT_XSETBV);
> +
> +	if (!guest_cpu_cap_has(vcpu, X86_FEATURE_RDPRU))
> +		set_nested_intercept_mask(&svm->nested, INTERCEPT_RDPRU);
> +
> +	if (!guest_cpu_cap_has(vcpu, X86_FEATURE_INVPCID))
> +		set_nested_intercept_mask(&svm->nested, INTERCEPT_INVPCID);

Ugh.  I don't see any reason for svm->nested.nested_intercept_mask to exist.
guest_cpu_cap_has() is cheap (which is largely why it even exists), just sanitize
the vmcb02 intercepts on-demand.  The name is also wonky: it "sets" bits only to
effect a "clear" of those bits.

Gah, and the helpers to access/mutate intercepts can be cleaned up.  E.g. if we
do something like this:

static inline void __vmcb_set_intercept(unsigned long *intercepts, u32 bit)
{
	WARN_ON_ONCE(bit >= 32 * MAX_INTERCEPT);
	__set_bit(bit, intercepts);
}

static inline void __vmcb_clr_intercept(unsigned long *intercepts, u32 bit)
{
	WARN_ON_ONCE(bit >= 32 * MAX_INTERCEPT);
	__clear_bit(bit, intercepts);
}

static inline bool __vmcb_is_intercept(unsigned long *intercepts, u32 bit)
{
	WARN_ON_ONCE(bit >= 32 * MAX_INTERCEPT);
	return test_bit(bit, intercepts);
}

static inline void vmcb_set_intercept(struct vmcb_control_area *control, u32 bit)
{
	__vmcb_set_intercept((unsigned long *)&control->intercepts, bit);
}

static inline void vmcb_clr_intercept(struct vmcb_control_area *control, u32 bit)
{
	__vmcb_clr_intercept((unsigned long *)&control->intercepts, bit);
}

static inline bool vmcb_is_intercept(struct vmcb_control_area *control, u32 bit)
{
	return __vmcb_is_intercept((unsigned long *)&control->intercepts, bit);
}

static inline void vmcb12_clr_intercept(struct vmcb_ctrl_area_cached *control, u32 bit)
{
	__vmcb_clr_intercept((unsigned long *)&control->intercepts, bit);
}

static inline bool vmcb12_is_intercept(struct vmcb_ctrl_area_cached *control, u32 bit)
{
	return __vmcb_is_intercept((unsigned long *)&control->intercepts, bit);
}

> +}
> +
>  /*
>   * This array (and its actual size) holds the set of offsets (indexing by chunk
>   * size) to process when merging vmcb12's MSRPM with vmcb01's MSRPM.  Note, the
> @@ -408,10 +435,11 @@ void __nested_copy_vmcb_control_to_cache(struct kvm_vcpu *vcpu,
>  					 struct vmcb_ctrl_area_cached *to,
>  					 struct vmcb_control_area *from)
>  {
> +	struct vcpu_svm *svm = to_svm(vcpu);
>  	unsigned int i;
> 
>  	for (i = 0; i < MAX_INTERCEPT; i++)
> -		to->intercepts[i] = from->intercepts[i];
> +		to->intercepts[i] = from->intercepts[i] & ~(svm->nested.nested_intercept_mask[i]);

Then here we can use vmcb_clr_intercept().  And if with macro shenanigans, we
can cut down on the boilerplate like so:

#define __nested_svm_sanitize_intercept(__vcpu, __control, fname, iname)	\
do {										\
	if (!guest_cpu_cap_has(__vcpu, X86_FEATURE_##fname))			\
		vmcb12_clr_intercept(__control, INTERCEPT_##iname);		\
} while (0)

#define nested_svm_sanitize_intercept(__vcpu, __control, name)			\
	__nested_svm_sanitize_intercept(__vcpu, __control, name, name)

static
void __nested_copy_vmcb_control_to_cache(struct kvm_vcpu *vcpu,
					 struct vmcb_ctrl_area_cached *to,
					 struct vmcb_control_area *from)
{
	unsigned int i;

	for (i = 0; i < MAX_INTERCEPT; i++)
		to->intercepts[i] = from->intercepts[i];

	nested_svm_sanitize_intercept(vcpu, to, RDTSCP);
	nested_svm_sanitize_intercept(vcpu, to, SKINIT);
	__nested_svm_sanitize_intercept(vcpu, to, XSAVE, XSETBV);
	nested_svm_sanitize_intercept(vcpu, to, RDPRU);
	nested_svm_sanitize_intercept(vcpu, to, INVPCID);

Side topic, do we care about handling the case where userspace sets CPUID after
stuffing guest state?  I'm very tempted to send a patch disallowing KVM_SET_CPUID
if is_guest_mode() is true, and hoping no one cares.

> 
>  	to->iopm_base_pa        = from->iopm_base_pa;
>  	to->msrpm_base_pa       = from->msrpm_base_pa;

