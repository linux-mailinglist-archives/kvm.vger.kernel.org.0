Return-Path: <kvm+bounces-53169-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C9818B0E48C
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 22:08:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EF8A416BBFF
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 20:08:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E77C7283FE6;
	Tue, 22 Jul 2025 20:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="gKHfp/rB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50AAB21FF3E
	for <kvm@vger.kernel.org>; Tue, 22 Jul 2025 20:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753214891; cv=none; b=nNh6XjG54ltk3rcHckTn5ga7OM08kFQXTHQgcKEToQ4XedW4YZZCbDnQ5ohMix6s3o7Rg+x5PNdNpaMaBjFdlmU2WpFJxN4FiA+IffKnqPOr7Xw1gyNxsTMEapNIduIR+/Qjinn6PWb0wxwsX79ckBjQ2kHJhlHyMstEoj2OvZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753214891; c=relaxed/simple;
	bh=CdFIO8vzPatsoKJkx6xrvDe+I3D4b5lxNBiuh7lBgfo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bgJWBzzJqJUHjzS969GW0Abs9uS8IVxBd4WL2eNFGg+EjAIzxgK1lfUqXSbtAnq4k2SWtNhEeHWDvyiGYDxhKeysiQAbgC0PfkRQ5LMX6NdOyYmEEre+AhXFn8OdP4RAi74ImX08rphvgmWSOWL2TvMOq1eIGljRAx0639xCLF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=gKHfp/rB; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-b26f5f47ba1so4784137a12.1
        for <kvm@vger.kernel.org>; Tue, 22 Jul 2025 13:08:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1753214888; x=1753819688; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=vwH29HD58/kXA0a6qBsvFXRXfwES4lcV0p0FxVJxugI=;
        b=gKHfp/rB8vQUrHthXLMUm2iFRqSnDebRz+feNxQrb0lDbhmN2I5jln0v6TPbEHbB9H
         +Doi4WNiQdBvsZY/XzbQioFqGsYBaBYSnY5w7mStspS/73kIRFauCNyaiPIsBsSUJEhx
         jE3QXKqozAgY1hVJzF9F+bmN7A4UVX/baJykQyisfhaANdk5gWxUtVHtaJXBzCkxco0w
         kNJ3b0VxEXqnBruZPP+SSUoa1yiI2M7huCj5SwiFlhxGga6ueeN+7tZn78tsRuNm9lK2
         DDo5ibdWIjwN2uRJj9NYuDFKwK0wKoIF2JIa595516LBMXmGlE4Oz9cNFBowLNSCHKOY
         9mwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753214888; x=1753819688;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vwH29HD58/kXA0a6qBsvFXRXfwES4lcV0p0FxVJxugI=;
        b=mQOgWivk/TRVhD8Qg7KarUlJHapOUbTaG7ExEReDMR8+Csc+CvFDfr284JfjoSlCgv
         TuWcJbGDpU5gNol3pJnPcw+J/BrjYy2wopU2b1JyN+ILFLK/O9IJ+QNKZQG7ynWl2NzA
         4UPkjQxTQA1JtP5XSl17+HwHFp/8B0yGdB07g1oSqZVmLLXW7PgrVFMwWRSpoDYA7QQu
         mfMO8OCsH4nM3bP8LSbv0x6pjAYaF83CJMcFddsnzj3zhkqgzJEiDlfotAdhe0yqfnm7
         m34i1Wx2YWryraZqknMLsuYYhonnwzY/RIVpNSgofZ1xMpXGDOJT+lbSzWBrQdLFh4pH
         H9ew==
X-Forwarded-Encrypted: i=1; AJvYcCUIoLbbnJOuoQ2IURTjIFNQKsbp/sSeTN5+nhhl563OfVZgoK9+oMvCAbnFdbmI+glmgJ8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxGLMqEWi4B0o0LeKD2RrDXYQY9QeVdQ8+rZElhV6Ju/f5PFxEI
	BItShmX/5QBDmupXfGKTZvRGl5L12PC/vb4ewF4Wd2VasKY6uCD54krJUrCKQtp+kuw=
X-Gm-Gg: ASbGncvDgOuieQMCHaamBHCDPGrWGkOBDOrYM/r6ERpRJTeoekQw1GGCTv2ZtgknC3n
	gYQle3Xm33wOH994X1HqVfj7qc5aJ2X2q7oKZDDBdeWi1jJfImoaL/3U2XNdkDeP4kMeUHJm0N0
	FF7eKLPn9S4SWQOE3n3b6rv9thQntxqaYwf0YqLt5pTqdM2pLTtNm5KJX+XP/+kwn7emILk8Qoh
	mZth9ED3XGYQFyyQVUXvYKGXklsY3vvqCfZRFx+hF+kc5o7OQPLp1YS4iU4UVy+HnKSfWsmalSB
	5prKGZsRr6c1Xt3CMfhlp+0RxbzbEul5qQDmvzNZUTB0OgvMBND3SsrW6m2h5tIEvgFTGWPUrS/
	OzpJA1OA/V9o2BeiZ57MKjRN06pAFSgu/qGV3GTf0tsLkocvhsBKHtwQjMFbMw9YfAzz9mXgDzN
	jaRQuiPAs+fs6KYOxG7kN8sJYTJq0L3+mR4V9MSdbRxjDFdx8iTvNoi5U=
X-Google-Smtp-Source: AGHT+IGON/c9iPG+QKwvcxEf/RE7AY6A4s1xpf7C/QxC3rgsnygCXWPewfrss5+j+S9dy1x575sXiw==
X-Received: by 2002:a17:902:ec83:b0:235:7c6:ebd2 with SMTP id d9443c01a7336-23f9820c81fmr3570915ad.31.1753214888479;
        Tue, 22 Jul 2025 13:08:08 -0700 (PDT)
Received: from ?IPV6:2003:fa:af22:cf00:2208:a86d:dff:5ae9? (p200300faaf22cf002208a86d0dff5ae9.dip0.t-ipconnect.de. [2003:fa:af22:cf00:2208:a86d:dff:5ae9])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23e3b6b4aa9sm81964265ad.129.2025.07.22.13.08.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Jul 2025 13:08:08 -0700 (PDT)
Message-ID: <2bcf0f93-12e3-49d6-aba1-3e560c423e12@grsecurity.net>
Date: Tue, 22 Jul 2025 22:08:03 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] i386/kvm: Disable hypercall patching quirk by default
To: Xiaoyao Li <xiaoyao.li@intel.com>, qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti
 <mtosatti@redhat.com>, kvm@vger.kernel.org,
 Oliver Upton <oliver.upton@linux.dev>,
 Sean Christopherson <seanjc@google.com>
References: <20250619194204.1089048-1-minipli@grsecurity.net>
 <41a5767e-42d7-4877-9bc8-aa8eca6dd3e3@intel.com>
 <b8336828-ce72-4567-82df-b91d3670e26c@grsecurity.net>
 <3f58125c-183f-49e0-813e-d4cb1be724e8@intel.com>
Content-Language: de-DE, en-US
From: Mathias Krause <minipli@grsecurity.net>
Autocrypt: addr=minipli@grsecurity.net; keydata=
 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
 RzDVkdgPJkL/NFTKZHo5foFXNi89kA==
In-Reply-To: <3f58125c-183f-49e0-813e-d4cb1be724e8@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 22.07.25 12:27, Xiaoyao Li wrote:
> On 7/22/2025 5:21 PM, Mathias Krause wrote:
>> IMHO, there is no valid reason for still having the patching in place as
>> the .text of non-ancient kernel's  will be write-protected, making
>> patching attempts fail. And, as they fail with a #PF instead of #UD, the
>> guest cannot even handle them appropriately, as there was no memory
>> write attempt from its point of view. Therefore the default should be to
>> disable it, IMO. This won't prevent guests making use of the wrong
>> instruction from trapping, but, at least, now they'll get the correct
>> exception vector and can handle it appropriately.
> 
> But you don't accout for the case that guest kernel is built without
> CONFIG_STRICT_KERNEL_RWX enabled, or without CONFIG_DEBUG_RO_DATA, or
> for whatever reason the guest's text is not readonly, and the VM needs
> to be migrated among different vendors (Intel <-> AMD).
> 
> Before this patch, the above usecase works well. But with this patch,
> the guest will gets #UD after migrated to different vendors.

I strongly doubt that use case works well, probably doesn't work at all
right now. There's so much more to handle on the kernel side for such a
thing to actually "work". Think of mitigations like RETPOLINE, RETHUNK,
UNRET, SRSO, GDS,... and all the vendor-specific MSRs that need to be
switched over. No way this "just works". Not patching VMCALL to VMMCALL
or vice versa is the least of your problems in such a scenario.

> I heard from some small CSPs that they do want to the ability to live
> migrate VMs among Intel and AMD host.

Well, they'll have a hard time trying to get it to work, sorry.

>> [...]
>> 
>> Ignoring pre-v2.6.25 kernels for a moment, we can assume that KVM will
>> do the patching. So the lack of KVM_X86_QUIRK_FIX_HYPERCALL_INSN but
>> having 'hypercall_patching_enabled == false' indicates that the user
>> wants to disable it but QEMU cannot do so, because KVM lacks the
>> extension to do so. This, IMO, legitimizes the warn_report("kvm:
>> disabling hypercall patching not supported") -- as it's not supported.
> 
> The minimum supported kernel version is 4.5 (see commit f180e367fce4).
> So pre-v2.6.25 kernels is not the case.

Perfect!

> Surely we can list all the cases of different versions of KVM starting
> from v4.5 and draw the conclusion that the semantics of "valid_quirks &
> KVM_X86_QUIRK_FIX_HYPERCALL_INSN == 0" means KVM enables the hypercall
> patching quirk but don't provide the interface for userspace to disable
> it. So the code logic is correct.

Thanks for confirming!

> My statement of "I think it requires a new cap in KVM to return the
> enabled quirks" is more for generic consideration. i.e., QEMU can know
> whether a quirk is enabled or not without analysing the detailed history
> of KVM.

Well, all quirks are enabled by default, only explicitly disabled ones
are, well, disabled. And that requires actively doing so via
kvm_vm_enable_cap(KVM_CAP_DISABLE_QUIRKS[2]). Surely, QEMU can track
these calls on its own if it really wants to.

> Of course, it's more of the requirement on KVM to provide new interface
> and Current QEMU can do nothing on it. That is, current implementation
> of this PATCH is OK to me.

Ok, I'll send a v2 incorporating the member name change to
'hypercall_patching'.

>>> [...]
>>> I think return 0 here is to avoid the warn_report() in the caller. But
>>> for the correct semantics, we need to return -1 to indicate that it
>>> fails to disable the hypercall patching?
>>
>> No, returning 0 here is very much on purpose, as you noticed, to avoid
>> the warn_report() in the caller. The already issued warn_report() is the
>> correct one for this case.
> 
> We can use @Error to pass the error log instead of the trick on return
> value.
> 
> e.g.,
> 
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -3228,17 +3228,24 @@ static int kvm_vm_enable_energy_msrs(KVMState *s)
>      return 0;
>  }
> 
> -static int kvm_vm_disable_hypercall_patching(KVMState *s)
> +static int kvm_vm_disable_hypercall_patching(KVMState *s, Error **errp)
>  {
>      int valid_quirks = kvm_vm_check_extension(s, KVM_CAP_DISABLE_QUIRKS2);
> +    int ret = -1;
> 
>      if (valid_quirks & KVM_X86_QUIRK_FIX_HYPERCALL_INSN) {
> -        return kvm_vm_enable_cap(s, KVM_CAP_DISABLE_QUIRKS2, 0,
> -                                 KVM_X86_QUIRK_FIX_HYPERCALL_INSN);
> +        ret = kvm_vm_enable_cap(s, KVM_CAP_DISABLE_QUIRKS2, 0,
> +                                KVM_X86_QUIRK_FIX_HYPERCALL_INSN);
> +        if (ret) {
> +            error_setg_errno(errp, -ret, "kvm: failed to disable "
> +                             "hypercall patching quirk: %s",
> +                             strerror(-ret));
> +        }
> +    } else {
> +        error_setg(errp, "kvm: disabling hypercall patching not
> supported");
>      }
> 
> -    warn_report("kvm: disabling hypercall patching not supported");
> -    return 0;
> +    return ret;
>  }
> 
>  int kvm_arch_init(MachineState *ms, KVMState *s)
> @@ -3381,8 +3388,8 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
>      }
> 
>      if (s->hypercall_patching_enabled == false) {
> -        if (kvm_vm_disable_hypercall_patching(s)) {
> -            warn_report("kvm: failed to disable hypercall patching
> quirk");
> +        if (kvm_vm_disable_hypercall_patching(s, &local_err)) {
> +            error_report_err(local_err);
>          }
>      }
> 

Ohh, neat. I'll integrate that as well. Thanks!

Thanks,
Mathias

