Return-Path: <kvm+bounces-3736-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B107807663
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 18:20:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A152B281F71
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 17:20:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C892765EDD;
	Wed,  6 Dec 2023 17:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Odh/hjOX"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C066DE
	for <kvm@vger.kernel.org>; Wed,  6 Dec 2023 09:20:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701883222;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SsLFzQv2YNuDCZra2Kj0iJALxsgAF/x7Gz2Slw1HQQQ=;
	b=Odh/hjOXg4LRA/Ip4tOAkrH72wYbNVqsO3Dd2DpqBgOkh3tj/ToufKhVJWH/CUS78v7Qf6
	LdIhUTLy5qhxOWAYhEW+gumy3Z9OTvplc42QIXcAvZLXHgOU839LuB73RP9B620Nu2V3O9
	qq2dKVsBClBC88ClgKgZhUlV8TMckyw=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-157-i090KJ4XMhib0qxlNrpDqQ-1; Wed, 06 Dec 2023 12:20:21 -0500
X-MC-Unique: i090KJ4XMhib0qxlNrpDqQ-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-332e2f70092so23437f8f.0
        for <kvm@vger.kernel.org>; Wed, 06 Dec 2023 09:20:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701883217; x=1702488017;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SsLFzQv2YNuDCZra2Kj0iJALxsgAF/x7Gz2Slw1HQQQ=;
        b=erbroTwGsJSageMIitXgDB2AAdwGu8BspzuLMVkhErkhrFFVbI0ELZcoFlWRFOEOVy
         VECf4Nqf5GI+P5MF1PmNXPix4A4kyA+c/RveZdu+VFyaHP9ZKJulZ0LTWAQ+sMMAxo6E
         A6cTpC1I1BJhYeyArisXbwf1k0P21XjNJVMqB6EDNJbPZ2m6sUG0ffNKnIiLInrF5FG+
         X09nSbzldEsnkgoIjsyf4T/4/+5NlDET0xAUjrYAkfmKS0BhoDeiuUYw31OuSzXNDDmD
         T2gRtq+0ubYKaJ2fXdRmz9axxEluPfAlqIX43HCHB7u/wjR0ydwPjFssSoE+oawKOUeI
         ZLDw==
X-Gm-Message-State: AOJu0YwyaKzHtXnjUaoLPN+Z6mj/WIbzeZUJz7xmL1FJA7t3jnSMep0Q
	AGIRAzOLplE2LC5oiW88N0oWO4nL5iE0Lr6f4z9ahiGrKdMKLhh6wGKbmjHpLzpMVb+0XmaaHGx
	HDKvByFZ1KcFSMOOauhly
X-Received: by 2002:a05:600c:152:b0:40c:711:f492 with SMTP id w18-20020a05600c015200b0040c0711f492mr755828wmm.181.1701883216911;
        Wed, 06 Dec 2023 09:20:16 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEEDaeszLqwAe0nU5bPLurT8kY29VuNk8fXrhQGAvKHABN9JIws3HuahPDdf6VZlB5WEBMVQQ==
X-Received: by 2002:a05:600c:152:b0:40c:711:f492 with SMTP id w18-20020a05600c015200b0040c0711f492mr755819wmm.181.1701883216571;
        Wed, 06 Dec 2023 09:20:16 -0800 (PST)
Received: from starship ([89.237.98.20])
        by smtp.gmail.com with ESMTPSA id v16-20020a05600c471000b0040b43da0bbasm215072wmo.30.2023.12.06.09.20.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Dec 2023 09:20:16 -0800 (PST)
Message-ID: <9eae0513c912faa04a11db378ea3ca176ab45f0d.camel@redhat.com>
Subject: Re: [PATCH v2 for-8.2?] i386/sev: Avoid SEV-ES crash due to missing
 MSR_EFER_LMA bit
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Michael Roth <michael.roth@amd.com>, qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti
 <mtosatti@redhat.com>,  Tom Lendacky <thomas.lendacky@amd.com>, Akihiko
 Odaki <akihiko.odaki@daynix.com>, kvm@vger.kernel.org
Date: Wed, 06 Dec 2023 19:20:14 +0200
In-Reply-To: <20231205222816.1152720-1-michael.roth@amd.com>
References: <20231205222816.1152720-1-michael.roth@amd.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Tue, 2023-12-05 at 16:28 -0600, Michael Roth wrote:
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
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
> v2:
>   - Add handling for KVM_GET_SREGS, not just KVM_GET_SREGS2
> 
>  target/i386/kvm/kvm.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index 11b8177eff..8721c1bf8f 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -3610,6 +3610,7 @@ static int kvm_get_sregs(X86CPU *cpu)
>  {
>      CPUX86State *env = &cpu->env;
>      struct kvm_sregs sregs;
> +    target_ulong cr0_old;
>      int ret;
>  
>      ret = kvm_vcpu_ioctl(CPU(cpu), KVM_GET_SREGS, &sregs);
> @@ -3637,12 +3638,18 @@ static int kvm_get_sregs(X86CPU *cpu)
>      env->gdt.limit = sregs.gdt.limit;
>      env->gdt.base = sregs.gdt.base;
>  
> +    cr0_old = env->cr[0];
>      env->cr[0] = sregs.cr0;
>      env->cr[2] = sregs.cr2;
>      env->cr[3] = sregs.cr3;
>      env->cr[4] = sregs.cr4;
>  
>      env->efer = sregs.efer;
> +    if (sev_es_enabled() && env->efer & MSR_EFER_LME) {
> +        if (!(cr0_old & CR0_PG_MASK) && env->cr[0] & CR0_PG_MASK) {
> +            env->efer |= MSR_EFER_LMA;
> +        }
> +    }

I think that we should not check that CR0_PG has changed, and just blindly assume
that if EFER.LME is set and CR0.PG is set, then EFER.LMA must be set as defined in x86 spec.

Otherwise, suppose qemu calls kvm_get_sregs twice: First time it will work,
but second time CR0.PG will match one that is stored in the env, and thus the workaround
will not be executed, and instead we will revert back to wrong EFER value 
reported by the kernel.

How about something like that:


if (sev_es_enabled() && env->efer & MSR_EFER_LME && env->cr[0] & CR0_PG_MASK) {
	/* 
         * Workaround KVM bug, because of which KVM might not be aware of the 
         * fact that EFER.LMA was toggled by the hardware 
         */
	env->efer |= MSR_EFER_LMA;
}


Best regards,
	Maxim Levitsky

>  
>      /* changes to apic base and cr8/tpr are read back via kvm_arch_post_run */
>      x86_update_hflags(env);
> @@ -3654,6 +3661,7 @@ static int kvm_get_sregs2(X86CPU *cpu)
>  {
>      CPUX86State *env = &cpu->env;
>      struct kvm_sregs2 sregs;
> +    target_ulong cr0_old;
>      int i, ret;
>  
>      ret = kvm_vcpu_ioctl(CPU(cpu), KVM_GET_SREGS2, &sregs);
> @@ -3676,12 +3684,18 @@ static int kvm_get_sregs2(X86CPU *cpu)
>      env->gdt.limit = sregs.gdt.limit;
>      env->gdt.base = sregs.gdt.base;
>  
> +    cr0_old = env->cr[0];
>      env->cr[0] = sregs.cr0;
>      env->cr[2] = sregs.cr2;
>      env->cr[3] = sregs.cr3;
>      env->cr[4] = sregs.cr4;
>  
>      env->efer = sregs.efer;
> +    if (sev_es_enabled() && env->efer & MSR_EFER_LME) {
> +        if (!(cr0_old & CR0_PG_MASK) && env->cr[0] & CR0_PG_MASK) {
> +            env->efer |= MSR_EFER_LMA;
> +        }
> +    }
>  
>      env->pdptrs_valid = sregs.flags & KVM_SREGS2_FLAGS_PDPTRS_VALID;
>  



