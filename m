Return-Path: <kvm+bounces-53104-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 49C93B0D5CA
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 11:21:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3BF3417167A
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 09:21:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D34F62DBF48;
	Tue, 22 Jul 2025 09:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="Kwx5L8Di"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 926371DFFC
	for <kvm@vger.kernel.org>; Tue, 22 Jul 2025 09:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753176103; cv=none; b=Lmqx9UieK5oCZj1IXgjF+SXERxYz2GMvi+LzyFvI47ZRBcf+7Iau133Tdiymc9MtGZ4ErQ5ySTcMFJvt0/0IdmzZhjx22F50YffoJCrexjd1EbFSV1Kac5WExkuUwvfUQyMA10i88ak/r0cnGPFri0j85mm05zy/rz7/mowOChk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753176103; c=relaxed/simple;
	bh=dssBb15/p8rgNYvBkWhvXdr11wf0u652VGhpOSIprk8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HZDOc9wbZTr2SG6jsS2hlV0eb1ZvtvEo7sqBfsyJQuJEA08NDRUkbVazy3wBpk8ExK3K6DzOOpEVekSX96NC4H6OSOMA2h9nCIAGfqNeswutpJG/OMVg1yHhifrLKgbz7kOkKhVxEJUIDM70F70WrZsSvOkA6YmD9IVIgbLpkx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=Kwx5L8Di; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-451dbe494d6so57520215e9.1
        for <kvm@vger.kernel.org>; Tue, 22 Jul 2025 02:21:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1753176100; x=1753780900; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=RuoprhYxB0LMkVVTEPQHwa6tOFm9BYAF7wpRrOfNTMY=;
        b=Kwx5L8Dit8xMiBEbz7NBjJnAkaHCdpy8buY0ke93xT4zv2MDx46s0auehbMJ52Va5p
         Ic+yXFBrYe8Aqu2GP0DjRNcgMslrNuM2V6MRWEahFDfzAvtSp0DYPPgFp/iDhWLgI2Sy
         phbKp+wJXv7YJAu3JmB970wktPohJmfBj+SUh3MfkYOMPvpkLkR1h9A9AHky6HrRtLp7
         R/1rKBdbkIJFoxVQhvDGvDEq+k8EXSPjsio6EBJxrWdRzJXP3WSWl20t5I5wppF9AXb0
         oPQrG8r9bxRaU6+b9svBljqEBrtqcTs/YxD08pNcHqwfxOXNUG/R2x2yP7fZF+o9TnIx
         8NJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753176100; x=1753780900;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RuoprhYxB0LMkVVTEPQHwa6tOFm9BYAF7wpRrOfNTMY=;
        b=dvIj15maziyz8u2yXHw08uGIwLz8h4Xm7m3TPAGoMgZ8tGxF9HNzI/6/exYUyfF7Wk
         2rU+374J6FQPpyx9pRneezDWgOsnBOzrUcuq4XbP4y3xk3TF271I9KaKltuH8B/zBbmD
         YAiCSLW1q+7w3FRuCC0xjCPrL9eagN5RKgrzZxX3WeNkr80n18dU03CjarehVvEasV7R
         FHu4ZeZbP1JyXEs8QwhcsUg3Mp6UGjt7h9QeLO7BsxvKbtz5ZzFs0gWKzHY87qNDuuaF
         Y27YeaGr9ri2KqidbTujGGc2wUXGCKSUYMQzFT9Hv25uqtG+7jmt5llEGhLs3AoOMwAF
         TV4g==
X-Forwarded-Encrypted: i=1; AJvYcCWENNnR3ZtHlKFjgHOiWYBahw4DHqFOHroS5UqQhzD9HYmGJV7vNoEt0qJTwkbX1f7DkPY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyuhw/E87bzlvP4kT3g8ma1u91RGCvHIbgwwdNX+WaMWPLPpy+h
	LRx9VN50UkodDDsfwAL3WvD1L9KfpcihlQNllVTE+pvVmQ2W9lkF0PrjWR43uxPg5EcDHOvmULo
	UFOymFoY=
X-Gm-Gg: ASbGncusDqC+KsP0Q93BjlGFWDbI/EUH2AsesT705eYcL6AanUrvuomCqssQQd7GxYc
	9Kt06rV+74J5kqJzwHlvBeyPH/sOoWC8636g76gaHGp6yFeMPxt5Ky2r09s4DLQ1rmh8jcLA1Kq
	/9GfLzQG5ZjTmG4vwSoGHlspujtUbm80IVdByuAD+blHmqIF2Dr1iSRVNq7R40UhzbcCy5QvJcf
	kI7P9Qke77GPEb8+BGFonkUTvwhjG5jlEN0dlDwxIoyiC8zPMc36Zvow/WtpG41mcSmWJwwGcmD
	WeHEdQyrwj8bkkn3GeMR5xDm2EATfFTKSR//kI5d99W6AYR2G51LhYZVBaAOde/OzDB071pHJPB
	+n7uHCMjg8fvgQeFq3M+oVu/KqTP6HIgrYzQK1ykFSu740JQydY0WPx8s+Op3H74RXKot3zWJ7G
	4Uv+h3SQ+svb7PTDSt0xxuCP+mlBrqBO9/EHD+vE8hZ8dez6NF1/gFP1U=
X-Google-Smtp-Source: AGHT+IFStOAu+Lx25M5OUqkeENC8SXn77YTjcmFmE+l+y3oVlQiO1LWMq/9f+CjN0kk0oweAiHK2Cw==
X-Received: by 2002:a05:600c:8b67:b0:456:19be:5cc with SMTP id 5b1f17b1804b1-4562e38a883mr225641965e9.14.1753176099469;
        Tue, 22 Jul 2025 02:21:39 -0700 (PDT)
Received: from ?IPV6:2003:fa:af22:cf00:2208:a86d:dff:5ae9? (p200300faaf22cf002208a86d0dff5ae9.dip0.t-ipconnect.de. [2003:fa:af22:cf00:2208:a86d:dff:5ae9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4563b75e9e9sm125573325e9.34.2025.07.22.02.21.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Jul 2025 02:21:39 -0700 (PDT)
Message-ID: <b8336828-ce72-4567-82df-b91d3670e26c@grsecurity.net>
Date: Tue, 22 Jul 2025 11:21:37 +0200
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
Content-Language: en-US, de-DE
From: Mathias Krause <minipli@grsecurity.net>
Autocrypt: addr=minipli@grsecurity.net; keydata=
 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
 RzDVkdgPJkL/NFTKZHo5foFXNi89kA==
In-Reply-To: <41a5767e-42d7-4877-9bc8-aa8eca6dd3e3@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 22.07.25 05:45, Xiaoyao Li wrote:
> On 6/20/2025 3:42 AM, Mathias Krause wrote:
>> KVM has a weird behaviour when a guest executes VMCALL on an AMD system
>> or VMMCALL on an Intel CPU. Both naturally generate an invalid opcode
>> exception (#UD) as they are just the wrong instruction for the CPU
>> given. But instead of forwarding the exception to the guest, KVM tries
>> to patch the guest instruction to match the host's actual hypercall
>> instruction. That is doomed to fail as read-only code is rather the
>> standard these days. But, instead of letting go the patching attempt and
>> falling back to #UD injection, KVM injects the page fault instead.
>>
>> That's wrong on multiple levels. Not only isn't that a valid exception
>> to be generated by these instructions, confusing attempts to handle
>> them. It also destroys guest state by doing so, namely the value of CR2.
>>
>> Sean attempted to fix that in KVM[1] but the patch was never applied.
>>
>> Later, Oliver added a quirk bit in [2] so the behaviour can, at least,
>> conceptually be disabled. Paolo even called out to add this very
>> functionality to disable the quirk in QEMU[3]. So lets just do it.
>>
>> A new property 'hypercall-patching=on|off' is added, for the very
>> unlikely case that there are setups that really need the patching.
>> However, these would be vulnerable to memory corruption attacks freely
>> overwriting code as they please. So, my guess is, there are exactly 0
>> systems out there requiring this quirk.
> 
> The default behavior is patching the hypercall for many years.
> 
> If you desire to change the default behavior, please at least keep it
> unchanged for old machine version. i.e., introduce compat_property,
> which sets KVMState->hypercall_patching_enabled to true.

Well, the thing is, KVM's patching is done with the effective
permissions of the guest which means, if the code in question isn't
writable from the guest's point of view, KVM's attempt to modify it will
fail. This failure isn't transparent for the guest as it sees a #PF
instead of a #UD, and that's what I'm trying to fix by disabling the quirk.

The hypercall patching was introduced in Linux commit 7aa81cc04781
("KVM: Refactor hypercall infrastructure (v3)") in v2.6.25. Until then
it was based on a dedicated hypercall page that was handled by KVM to
use the proper instruction of the KVM module in use (VMX or SVM).

Patching code was fine back then, but the introduction of DEBUG_RO_DATA
made the patching attempts fail and, ultimately, lead to Paolo handle
this with commit c1118b3602c2 ("x86: kvm: use alternatives for VMCALL
vs. VMMCALL if kernel text is read-only").

However, his change still doesn't account for the cross-vendor live
migration case (Intel<->AMD), which will still be broken, causing the
before mentioned bogus #PF, which will just lead to misleading Oops
reports, confusing the poor souls, trying to make sense of it.

IMHO, there is no valid reason for still having the patching in place as
the .text of non-ancient kernel's  will be write-protected, making
patching attempts fail. And, as they fail with a #PF instead of #UD, the
guest cannot even handle them appropriately, as there was no memory
write attempt from its point of view. Therefore the default should be to
disable it, IMO. This won't prevent guests making use of the wrong
instruction from trapping, but, at least, now they'll get the correct
exception vector and can handle it appropriately.

> 
>> [1] https://lore.kernel.org/kvm/20211210222903.3417968-1-
>> seanjc@google.com/
>> [2] https://lore.kernel.org/kvm/20220316005538.2282772-2-
>> oupton@google.com/
>> [3] https://lore.kernel.org/kvm/80e1f1d2-2d79-22b7-6665-
>> c00e4fe9cb9c@redhat.com/
>>
>> Cc: Oliver Upton <oliver.upton@linux.dev>
>> Cc: Sean Christopherson <seanjc@google.com>
>> Cc: Paolo Bonzini <pbonzini@redhat.com>
>> Signed-off-by: Mathias Krause <minipli@grsecurity.net>
>> ---
>>   include/system/kvm_int.h |  1 +
>>   qemu-options.hx          | 10 ++++++++++
>>   target/i386/kvm/kvm.c    | 38 ++++++++++++++++++++++++++++++++++++++
>>   3 files changed, 49 insertions(+)
>>
>> diff --git a/include/system/kvm_int.h b/include/system/kvm_int.h
>> index 756a3c0a250e..fd7129824429 100644
>> --- a/include/system/kvm_int.h
>> +++ b/include/system/kvm_int.h
>> @@ -159,6 +159,7 @@ struct KVMState
>>       uint64_t kvm_eager_split_size;  /* Eager Page Splitting chunk
>> size */
>>       struct KVMDirtyRingReaper reaper;
>>       struct KVMMsrEnergy msr_energy;
>> +    bool hypercall_patching_enabled;
> 
> IMHO, we can just name it "hypercall_patching".
> 
> Since it's a boolean type, true means enabled and false means disabled.

Ok, makes sense.

> 
>>       NotifyVmexitOption notify_vmexit;
>>       uint32_t notify_window;
>>       uint32_t xen_version;
>> diff --git a/qemu-options.hx b/qemu-options.hx
>> index 1f862b19a676..c2e232649c19 100644
>> --- a/qemu-options.hx
>> +++ b/qemu-options.hx
>> @@ -231,6 +231,7 @@ DEF("accel", HAS_ARG, QEMU_OPTION_accel,
>>       "                dirty-ring-size=n (KVM dirty ring GFN count,
>> default 0)\n"
>>       "                eager-split-size=n (KVM Eager Page Split chunk
>> size, default 0, disabled. ARM only)\n"
>>       "                notify-vmexit=run|internal-error|
>> disable,notify-window=n (enable notify VM exit and set notify window,
>> x86 only)\n"
>> +    "                hypercall-patching=on|off (enable KVM's VMCALL/
>> VMMCALL hypercall patching quirk, x86 only)\n"
>>       "                thread=single|multi (enable multi-threaded TCG)\n"
>>       "                device=path (KVM device path, default /dev/
>> kvm)\n", QEMU_ARCH_ALL)
>>   SRST
>> @@ -313,6 +314,15 @@ SRST
>>           open up for a specified of time (i.e. notify-window).
>>           Default: notify-vmexit=run,notify-window=0.
>>   +    ``hypercall-patching=on|off``
>> +        KVM tries to recover from the wrong hypercall instruction
>> being used by
>> +        a guest by attempting to rewrite it to the one supported
>> natively by
>> +        the host CPU (VMCALL on Intel, VMMCALL for AMD systems).
>> However, this
>> +        patching may fail if the guest memory is write protected,
>> leading to a
>> +        page fault getting propagated to the guest instead of an illegal
>> +        instruction exception. As this may confuse guests, it gets
>> disabled by
>> +        default (x86 only).
>> +
>>       ``device=path``
>>           Sets the path to the KVM device node. Defaults to ``/dev/
>> kvm``. This
>>           option can be used to pass the KVM device to use via a file
>> descriptor
>> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
>> index 56a6b9b6381a..6f5f3b95e553 100644
>> --- a/target/i386/kvm/kvm.c
>> +++ b/target/i386/kvm/kvm.c
>> @@ -3224,6 +3224,19 @@ static int kvm_vm_enable_energy_msrs(KVMState *s)
>>       return 0;
>>   }
>>   +static int kvm_vm_disable_hypercall_patching(KVMState *s)
>> +{
>> +    int valid_quirks = kvm_vm_check_extension(s,
>> KVM_CAP_DISABLE_QUIRKS2);
>> +
>> +    if (valid_quirks & KVM_X86_QUIRK_FIX_HYPERCALL_INSN) {
>> +        return kvm_vm_enable_cap(s, KVM_CAP_DISABLE_QUIRKS2, 0,
>> +                                 KVM_X86_QUIRK_FIX_HYPERCALL_INSN);
>> +    }
>> +
>> +    warn_report("kvm: disabling hypercall patching not supported");
> 
> It's not clear it's 1) KVM doesn't support/has FIX_HYPERCALL_INSN quirk
> or 2) KVM has FIX_HYPERCALL_INSN quirk but doesn't allow it to be
> disabled, when KVM_X86_QUIRK_FIX_HYPERCALL_INSN is not returned in
> KVM_CAP_DISABLE_QUIRKS2.
> 
> If it's case 1), it can be treated as hypercall patching is disabled
> thus no warning is expected.
> 
> So, I think it requires a new cap in KVM to return the enabled quirks.

KVM_CAP_DISABLE_QUIRKS2 fixes that bug of KVM_CAP_DISABLE_QUIRKS by
doing just that: returning the mask of supported quirks when queried via
KVM_CHECK_EXTENSION. So if KVM_X86_QUIRK_FIX_HYPERCALL_INSN is in that
mask, it can also be disabled. If that attempt fails (for whatever
reason), it's an error, which makes kvm_vm_enable_cap() return a
non-zero value, triggering the warn_report("kvm: failed to disable
hypercall patching quirk") in the caller.

If KVM_X86_QUIRK_FIX_HYPERCALL_INSN is missing in the
KVM_CAP_DISABLE_QUIRKS2 mask, it may either be that KVM is too old to
even have the hypercall patching (pre-v2.6.25) or does do the patching,
just doesn't have KVM_X86_QUIRK_FIX_HYPERCALL_INSN yet, which came in
Linux commit f1a9761fbb00 ("KVM: x86: Allow userspace to opt out of
hypercall patching"), which is v5.19.

Ignoring pre-v2.6.25 kernels for a moment, we can assume that KVM will
do the patching. So the lack of KVM_X86_QUIRK_FIX_HYPERCALL_INSN but
having 'hypercall_patching_enabled == false' indicates that the user
wants to disable it but QEMU cannot do so, because KVM lacks the
extension to do so. This, IMO, legitimizes the warn_report("kvm:
disabling hypercall patching not supported") -- as it's not supported.

> 
>> +    return 0;
> 
> I think return 0 here is to avoid the warn_report() in the caller. But
> for the correct semantics, we need to return -1 to indicate that it
> fails to disable the hypercall patching?

No, returning 0 here is very much on purpose, as you noticed, to avoid
the warn_report() in the caller. The already issued warn_report() is the
correct one for this case.

I guess, it's a question of if disabling hypercall patching is a hard
requirement or can soft-fail. I decided for the latter, as hypercall
patching shouldn't be needed in most cases, so if it cannot be disabled,
it's mostly fine to start the VM still.

> 
>> +}
>> +
>>   int kvm_arch_init(MachineState *ms, KVMState *s)
>>   {
>>       int ret;
>> @@ -3363,6 +3376,12 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
>>           }
>>       }
>>   +    if (s->hypercall_patching_enabled == false) {
>> +        if (kvm_vm_disable_hypercall_patching(s)) {
>> +            warn_report("kvm: failed to disable hypercall patching
>> quirk");
>> +        }
>> +    }
>> +
>>       return 0;
>>   }
>>   @@ -6456,6 +6475,19 @@ void kvm_request_xsave_components(X86CPU
>> *cpu, uint64_t mask)
>>       }
>>   }
>>   +static bool kvm_arch_get_hypercall_patching(Object *obj, Error **errp)
>> +{
>> +    KVMState *s = KVM_STATE(obj);
>> +    return s->hypercall_patching_enabled;
>> +}
>> +
>> +static void kvm_arch_set_hypercall_patching(Object *obj, bool value,
>> +                                            Error **errp)
>> +{
>> +    KVMState *s = KVM_STATE(obj);
>> +    s->hypercall_patching_enabled = value;
>> +}
>> +
>>   static int kvm_arch_get_notify_vmexit(Object *obj, Error **errp)
>>   {
>>       KVMState *s = KVM_STATE(obj);
>> @@ -6589,6 +6621,12 @@ static void
>> kvm_arch_set_xen_evtchn_max_pirq(Object *obj, Visitor *v,
>>     void kvm_arch_accel_class_init(ObjectClass *oc)
>>   {
>> +    object_class_property_add_bool(oc, "hypercall-patching",
>> +                                   kvm_arch_get_hypercall_patching,
>> +                                   kvm_arch_set_hypercall_patching);
>> +    object_class_property_set_description(oc, "hypercall-patching",
>> +                                          "Enable hypercall patching
>> quirk");
>> +
>>       object_class_property_add_enum(oc, "notify-vmexit",
>> "NotifyVMexitOption",
>>                                      &NotifyVmexitOption_lookup,
>>                                      kvm_arch_get_notify_vmexit,
> 

Thanks,
Mathias

