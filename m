Return-Path: <kvm+bounces-3687-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 55211806EDB
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 12:49:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id ED53DB20ECB
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 11:49:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9788D347A4;
	Wed,  6 Dec 2023 11:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="BBxpSiLD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6237110C2
	for <kvm@vger.kernel.org>; Wed,  6 Dec 2023 03:48:46 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id 4fb4d7f45d1cf-548f853fc9eso8581939a12.1
        for <kvm@vger.kernel.org>; Wed, 06 Dec 2023 03:48:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1701863325; x=1702468125; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uaaChIsfdDTa+nGnyTnK4jDGD3vjpPfqxoAIZJ3M9ug=;
        b=BBxpSiLDLRa2j/jkT89JJYQImRpDC+LueyhPCA3bTrBaN01PwW+CqwbUVeGS+Uj4sB
         /kCu1y0lV+Ij2G5O40ldEl8sVfyVVPhvoWb4AlM2YvoRiy0qDl7T9e3RO+FPHOpnK472
         ia0vgEj+vzm0AfCGILnQUw4nHal060gpLC/o/CrP+iWhPubEfVrpeIsA2uu7N0AiXXc8
         ZsGrzvNhfcyGctP8Kmqrc9dMqEHu665+WE496NRG+6IgkEI8VBJv10Q5QYlsJy4M0NKq
         dmsxCV95vBpSUOQFtYLPzoZOPf9XCOt4w94VRvAnekdDmvvkeIhpGtLL6xGcT3X+Tnkp
         WpBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701863325; x=1702468125;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uaaChIsfdDTa+nGnyTnK4jDGD3vjpPfqxoAIZJ3M9ug=;
        b=uL5T4UgRubkvcyf1bsw1K2F2CYebH1lphoemhJeR65/deTStuhGWY3q8AJd09TG/xI
         4shuiEgVYVynhplpMI7B8pvJ22LX01W9LAed1EySa3TfywRYAsgULgh6RKLzt01cnwQ2
         b5FCb+O11tQJ68CcxvNM9rLo7DEsoUjDbjXCGOWvKazaNpVbgUkciYXfBqlQHaO5UIOw
         XkEZri2IFi6dZBCYtp5+QnujwX1rizW+kmym/OGPw9yjq3BhUHnOgVrxipLJlbpEhvPQ
         ksxEZSCemkzt4iFJLcjyh1teKXbdG3XgygJzCEfP7ia6hPDO0lmrXfD+Te3/elt5I39S
         x3hg==
X-Gm-Message-State: AOJu0YywcijzXULJ/q3DLnqcxmxu86Bzc8aFgD55iY61HvVLB3YEt4rp
	G9xmeGeAWr9RWmwQrvzAIYNn/w==
X-Google-Smtp-Source: AGHT+IFq73Dx3oTOlnwUtGRWueTbMuTaB87Oif2jdjZeL3l9m8lupjmI3NzFkFWMAmbepPgPxNh7Aw==
X-Received: by 2002:a17:906:4e18:b0:a19:d40a:d21f with SMTP id z24-20020a1709064e1800b00a19d40ad21fmr246840eju.235.1701863325091;
        Wed, 06 Dec 2023 03:48:45 -0800 (PST)
Received: from [192.168.69.100] (tal33-h02-176-184-38-132.dsl.sta.abo.bbox.fr. [176.184.38.132])
        by smtp.gmail.com with ESMTPSA id ty6-20020a170907c70600b00a1ddb5a2f7esm480249ejc.60.2023.12.06.03.48.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Dec 2023 03:48:44 -0800 (PST)
Message-ID: <4e78f214-43ee-4c3a-ba49-d3b54aff8737@linaro.org>
Date: Wed, 6 Dec 2023 12:48:35 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 for-8.2?] i386/sev: Avoid SEV-ES crash due to missing
 MSR_EFER_LMA bit
Content-Language: en-US
To: Michael Roth <michael.roth@amd.com>, qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti
 <mtosatti@redhat.com>, Tom Lendacky <thomas.lendacky@amd.com>,
 Akihiko Odaki <akihiko.odaki@daynix.com>, kvm@vger.kernel.org,
 Lara Lazier <laramglazier@gmail.com>, Vitaly Kuznetsov
 <vkuznets@redhat.com>, Maxim Levitsky <mlevitsk@redhat.com>
References: <20231205222816.1152720-1-michael.roth@amd.com>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20231205222816.1152720-1-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Michael,

(Cc'ing Lara, Vitaly and Maxim)

On 5/12/23 23:28, Michael Roth wrote:
> Commit 7191f24c7fcf ("accel/kvm/kvm-all: Handle register access errors")
> added error checking for KVM_SET_SREGS/KVM_SET_SREGS2. In doing so, it
> exposed a long-running bug in current KVM support for SEV-ES where the
> kernel assumes that MSR_EFER_LMA will be set explicitly by the guest
> kernel, in which case EFER write traps would result in KVM eventually
> seeing MSR_EFER_LMA get set and recording it in such a way that it would
> be subsequently visible when accessing it via KVM_GET_SREGS/etc.
> 
> However, guests kernels currently rely on MSR_EFER_LMA getting set
> automatically when MSR_EFER_LME is set and paging is enabled via
> CR0_PG_MASK. As a result, the EFER write traps don't actually expose the
> MSR_EFER_LMA even though it is set internally, and when QEMU
> subsequently tries to pass this EFER value back to KVM via
> KVM_SET_SREGS* it will fail various sanity checks and return -EINVAL,
> which is now considered fatal due to the aforementioned QEMU commit.
> 
> This can be addressed by inferring the MSR_EFER_LMA bit being set when
> paging is enabled and MSR_EFER_LME is set, and synthesizing it to ensure
> the expected bits are all present in subsequent handling on the host
> side.
> 
> Ultimately, this handling will be implemented in the host kernel, but to
> avoid breaking QEMU's SEV-ES support when using older host kernels, the
> same handling can be done in QEMU just after fetching the register
> values via KVM_GET_SREGS*. Implement that here.
> 
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Marcelo Tosatti <mtosatti@redhat.com>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: Akihiko Odaki <akihiko.odaki@daynix.com>
> Cc: kvm@vger.kernel.org
> Fixes: 7191f24c7fcf ("accel/kvm/kvm-all: Handle register access errors")

This 'Fixes:' tag is misleading, since as you mentioned this commit
only exposes the issue.

Commit d499f196fe ("target/i386: Added consistency checks for EFER")
or around it seems more appropriate.

Is this feature easily testable on our CI, on a x86 runner with KVM
access?

> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
> v2:
>    - Add handling for KVM_GET_SREGS, not just KVM_GET_SREGS2
> 
>   target/i386/kvm/kvm.c | 14 ++++++++++++++
>   1 file changed, 14 insertions(+)
> 
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index 11b8177eff..8721c1bf8f 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -3610,6 +3610,7 @@ static int kvm_get_sregs(X86CPU *cpu)
>   {
>       CPUX86State *env = &cpu->env;
>       struct kvm_sregs sregs;
> +    target_ulong cr0_old;
>       int ret;
>   
>       ret = kvm_vcpu_ioctl(CPU(cpu), KVM_GET_SREGS, &sregs);
> @@ -3637,12 +3638,18 @@ static int kvm_get_sregs(X86CPU *cpu)
>       env->gdt.limit = sregs.gdt.limit;
>       env->gdt.base = sregs.gdt.base;
>   
> +    cr0_old = env->cr[0];
>       env->cr[0] = sregs.cr0;
>       env->cr[2] = sregs.cr2;
>       env->cr[3] = sregs.cr3;
>       env->cr[4] = sregs.cr4;
>   
>       env->efer = sregs.efer;
> +    if (sev_es_enabled() && env->efer & MSR_EFER_LME) {
> +        if (!(cr0_old & CR0_PG_MASK) && env->cr[0] & CR0_PG_MASK) {
> +            env->efer |= MSR_EFER_LMA;
> +        }
> +    }
>   
>       /* changes to apic base and cr8/tpr are read back via kvm_arch_post_run */
>       x86_update_hflags(env);
> @@ -3654,6 +3661,7 @@ static int kvm_get_sregs2(X86CPU *cpu)
>   {
>       CPUX86State *env = &cpu->env;
>       struct kvm_sregs2 sregs;
> +    target_ulong cr0_old;
>       int i, ret;
>   
>       ret = kvm_vcpu_ioctl(CPU(cpu), KVM_GET_SREGS2, &sregs);
> @@ -3676,12 +3684,18 @@ static int kvm_get_sregs2(X86CPU *cpu)
>       env->gdt.limit = sregs.gdt.limit;
>       env->gdt.base = sregs.gdt.base;
>   
> +    cr0_old = env->cr[0];
>       env->cr[0] = sregs.cr0;
>       env->cr[2] = sregs.cr2;
>       env->cr[3] = sregs.cr3;
>       env->cr[4] = sregs.cr4;
>   
>       env->efer = sregs.efer;
> +    if (sev_es_enabled() && env->efer & MSR_EFER_LME) {
> +        if (!(cr0_old & CR0_PG_MASK) && env->cr[0] & CR0_PG_MASK) {
> +            env->efer |= MSR_EFER_LMA;
> +        }
> +    }
>   
>       env->pdptrs_valid = sregs.flags & KVM_SREGS2_FLAGS_PDPTRS_VALID;
>   


