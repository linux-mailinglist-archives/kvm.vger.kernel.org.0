Return-Path: <kvm+bounces-52967-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B0BAB0C131
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 12:22:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C026F5402A1
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 10:22:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BD5128E56B;
	Mon, 21 Jul 2025 10:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="CkQt5UuQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 743B428DF40
	for <kvm@vger.kernel.org>; Mon, 21 Jul 2025 10:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753093328; cv=none; b=D8vb3cBLRTEFmAeRqjMMHW9UYAunGfUn5tHkqpwrG4zfONib3IETBWBOS0d53nXRqQqIP+rhHs7oR3Plvqq9GONw7hZAp0rrv5MK9Hr23P7izDne/iA4wpUar4hz6Tn1Occ22h/n61OU6RGzGfALP9IK14gEOcSgsViskrPwwds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753093328; c=relaxed/simple;
	bh=nVwYFgotNO/Cq0mrpzMa1wiIn9v3YCrvCMraTiJ7EeA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qyi1CDWaxMUbBsx/1iIde6rUsm9hwjqIO5BLJUKGaQfgpx5qwyPh/4/c0aP6fthU8GBmyKC3WsHUHN04w79457WjtszfM6ESYIH3qUCmRmiDh6rySslSoe4GUOqrZHqN+9s71aPEA33HmANty1r3VRE1pSPO/Jr8xaSzKgd3cFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=CkQt5UuQ; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4560d176f97so44920985e9.0
        for <kvm@vger.kernel.org>; Mon, 21 Jul 2025 03:22:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1753093324; x=1753698124; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=Bs6CUOQhP2HN4VAhC6GZsaqDgzaMmNd1xy/hvQVUxSg=;
        b=CkQt5UuQEopdI4tQFs6nuP567EHkxAMPx7DZm/Qo/f0e/EMC2ZBtwdmp7Nd0k96sHp
         zp+3PT/VQ2j19I6WJhygdy79xzZGA/duht6Gk/CYc7dx+vfCTp2EpsTl3DmtHOuRG0Tw
         eioEK3zUL+c1nUvnGSmMW6Qv5wEjHFulJYh0ZO5B/NkiG4W6alzP2Kkc4FMl7vQXqDbz
         Y/4567zk2lzt45N3WLT1yeRCa0mt68Y/UT9Z/PzdVi6EcnBIRIaRk7v5jGvtqeafHZBP
         /woEiOLcwjdDXqQigNXBi7JMypYambzhu1WTbRpEsUVzaF6guoriJvUtMf0c/HxDN6Lm
         Bc4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753093324; x=1753698124;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Bs6CUOQhP2HN4VAhC6GZsaqDgzaMmNd1xy/hvQVUxSg=;
        b=n2l2tQu+pv2mn9SqLTjlqgyGg34Va1hg4ta3Z7qNWCmJYQg0byUO7VpGnKp2vJNAgI
         WChzyV4QG7xqSbZfuROTpGo/3UBxv/jWEilP0xYS4uveKT1pCd+nmgj0WjkelbMWi/2b
         PSopDUsRbC55K93jz80/uZMfJxtvBeGNzkpy1jk0X3j0FJZPNJYNhE0fT0UVnfFZp+1l
         gHyV29TQbp9+3aGCEQ1k9j0e9nzFsZm/uwUwMip3E/LIuDIo+O+cCBR4F1Mi/c9Bvshn
         ZGxuZlAC/ExZqU1luDHxSMCuitNDzmuOXhsGhgli2QWsxUR7zyd0C+51TdHZpXP7pP1i
         L4CA==
X-Forwarded-Encrypted: i=1; AJvYcCXQXCx/7NNB0/I+nAeT/MiIDpVq52fC80chr6G+QSXzvhVUjknkQ8tev1+OeN4CfvbRcok=@vger.kernel.org
X-Gm-Message-State: AOJu0YxpmKCJV+pv06myMumfpJfGhRWrlsKI3dx+BucciYtrh8IhM1sB
	YpAxNylGXPcl21vbzFLNTD3Z0KMGfD+ejhYwMMg/pISoIoN1YzPxl9lP8J9azvPFYTXmbc8u4nH
	F0Z/7
X-Gm-Gg: ASbGncvIy6eB7BBislZhzzUXTgmaftcSmwPI3WETS6+ylHqavGpi1EXQkwkXQYDEvJV
	jOtuKZI0CPRCc5Wz5j49RK60ith90IpYDx+wERlJpzXb71snVR5YNhuwwFZqj3cl0s74pyaXEyQ
	JST9/9t6uDOGi/0u74vdVqjE4ASlVkFGBzi57y9pruJLVV3KvNBnUETEAPwibUhZXmRk3pyFb/q
	y1J2XNyfYH7dlXm3afhbW0D1C/tA5qV4MIMl63PXpYbC+0xTEXs43Wqfb2LV1nKaTitFA3ZoSAU
	j/wffgpuYDUb2ppN5i4u9zm1QqLKkkKfLOJOXIbJgLPVGqBJQGONo8Br95GkjofnwObUmiRL0PW
	Q4Lp+KzIs1iGI0LrONrnLxNld1FSpTeiptej9TXGcSmcQsSkSG/9kGn0MQykneidAEUHVuJnP5G
	cTaiyfz6a62cCFMMUVzyAjiuK7IJVuB1yrPRHQiykNwKONAQt/nz31Mls=
X-Google-Smtp-Source: AGHT+IFJ12ln2DajC3mWzxtg70/U/jCAohWMv5KpU68asn0tgc9rJobZSeGAuDtfpY0bL1P69I8OuA==
X-Received: by 2002:a05:600c:4e0a:b0:453:483b:626c with SMTP id 5b1f17b1804b1-456340b94c8mr130683705e9.23.1753093324302;
        Mon, 21 Jul 2025 03:22:04 -0700 (PDT)
Received: from ?IPV6:2003:fa:af22:cf00:2208:a86d:dff:5ae9? (p200300faaf22cf002208a86d0dff5ae9.dip0.t-ipconnect.de. [2003:fa:af22:cf00:2208:a86d:dff:5ae9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4563b75e9e9sm96775905e9.34.2025.07.21.03.22.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Jul 2025 03:22:03 -0700 (PDT)
Message-ID: <97730a3d-a5e7-45b3-9340-740ba33e3b9f@grsecurity.net>
Date: Mon, 21 Jul 2025 12:22:02 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] i386/kvm: Disable hypercall patching quirk by default
To: Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: Oliver Upton <oliver.upton@linux.dev>,
 Sean Christopherson <seanjc@google.com>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org
References: <20250619194204.1089048-1-minipli@grsecurity.net>
Content-Language: en-US, de-DE
From: Mathias Krause <minipli@grsecurity.net>
Autocrypt: addr=minipli@grsecurity.net; keydata=
 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
 RzDVkdgPJkL/NFTKZHo5foFXNi89kA==
In-Reply-To: <20250619194204.1089048-1-minipli@grsecurity.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 19.06.25 21:42, Mathias Krause wrote:
> KVM has a weird behaviour when a guest executes VMCALL on an AMD system
> or VMMCALL on an Intel CPU. Both naturally generate an invalid opcode
> exception (#UD) as they are just the wrong instruction for the CPU
> given. But instead of forwarding the exception to the guest, KVM tries
> to patch the guest instruction to match the host's actual hypercall
> instruction. That is doomed to fail as read-only code is rather the
> standard these days. But, instead of letting go the patching attempt and
> falling back to #UD injection, KVM injects the page fault instead.
> 
> That's wrong on multiple levels. Not only isn't that a valid exception
> to be generated by these instructions, confusing attempts to handle
> them. It also destroys guest state by doing so, namely the value of CR2.
> 
> Sean attempted to fix that in KVM[1] but the patch was never applied.
> 
> Later, Oliver added a quirk bit in [2] so the behaviour can, at least,
> conceptually be disabled. Paolo even called out to add this very
> functionality to disable the quirk in QEMU[3]. So lets just do it.
> 
> A new property 'hypercall-patching=on|off' is added, for the very
> unlikely case that there are setups that really need the patching.
> However, these would be vulnerable to memory corruption attacks freely
> overwriting code as they please. So, my guess is, there are exactly 0
> systems out there requiring this quirk.
> 
> [1] https://lore.kernel.org/kvm/20211210222903.3417968-1-seanjc@google.com/
> [2] https://lore.kernel.org/kvm/20220316005538.2282772-2-oupton@google.com/
> [3] https://lore.kernel.org/kvm/80e1f1d2-2d79-22b7-6665-c00e4fe9cb9c@redhat.com/
> 
> Cc: Oliver Upton <oliver.upton@linux.dev>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Mathias Krause <minipli@grsecurity.net>
> ---
>  include/system/kvm_int.h |  1 +
>  qemu-options.hx          | 10 ++++++++++
>  target/i386/kvm/kvm.c    | 38 ++++++++++++++++++++++++++++++++++++++
>  3 files changed, 49 insertions(+)
> 
> diff --git a/include/system/kvm_int.h b/include/system/kvm_int.h
> index 756a3c0a250e..fd7129824429 100644
> --- a/include/system/kvm_int.h
> +++ b/include/system/kvm_int.h
> @@ -159,6 +159,7 @@ struct KVMState
>      uint64_t kvm_eager_split_size;  /* Eager Page Splitting chunk size */
>      struct KVMDirtyRingReaper reaper;
>      struct KVMMsrEnergy msr_energy;
> +    bool hypercall_patching_enabled;
>      NotifyVmexitOption notify_vmexit;
>      uint32_t notify_window;
>      uint32_t xen_version;
> diff --git a/qemu-options.hx b/qemu-options.hx
> index 1f862b19a676..c2e232649c19 100644
> --- a/qemu-options.hx
> +++ b/qemu-options.hx
> @@ -231,6 +231,7 @@ DEF("accel", HAS_ARG, QEMU_OPTION_accel,
>      "                dirty-ring-size=n (KVM dirty ring GFN count, default 0)\n"
>      "                eager-split-size=n (KVM Eager Page Split chunk size, default 0, disabled. ARM only)\n"
>      "                notify-vmexit=run|internal-error|disable,notify-window=n (enable notify VM exit and set notify window, x86 only)\n"
> +    "                hypercall-patching=on|off (enable KVM's VMCALL/VMMCALL hypercall patching quirk, x86 only)\n"
>      "                thread=single|multi (enable multi-threaded TCG)\n"
>      "                device=path (KVM device path, default /dev/kvm)\n", QEMU_ARCH_ALL)
>  SRST
> @@ -313,6 +314,15 @@ SRST
>          open up for a specified of time (i.e. notify-window).
>          Default: notify-vmexit=run,notify-window=0.
>  
> +    ``hypercall-patching=on|off``
> +        KVM tries to recover from the wrong hypercall instruction being used by
> +        a guest by attempting to rewrite it to the one supported natively by
> +        the host CPU (VMCALL on Intel, VMMCALL for AMD systems). However, this
> +        patching may fail if the guest memory is write protected, leading to a
> +        page fault getting propagated to the guest instead of an illegal
> +        instruction exception. As this may confuse guests, it gets disabled by
> +        default (x86 only).
> +
>      ``device=path``
>          Sets the path to the KVM device node. Defaults to ``/dev/kvm``. This
>          option can be used to pass the KVM device to use via a file descriptor
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index 56a6b9b6381a..6f5f3b95e553 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -3224,6 +3224,19 @@ static int kvm_vm_enable_energy_msrs(KVMState *s)
>      return 0;
>  }
>  
> +static int kvm_vm_disable_hypercall_patching(KVMState *s)
> +{
> +    int valid_quirks = kvm_vm_check_extension(s, KVM_CAP_DISABLE_QUIRKS2);
> +
> +    if (valid_quirks & KVM_X86_QUIRK_FIX_HYPERCALL_INSN) {
> +        return kvm_vm_enable_cap(s, KVM_CAP_DISABLE_QUIRKS2, 0,
> +                                 KVM_X86_QUIRK_FIX_HYPERCALL_INSN);
> +    }
> +
> +    warn_report("kvm: disabling hypercall patching not supported");
> +    return 0;
> +}
> +
>  int kvm_arch_init(MachineState *ms, KVMState *s)
>  {
>      int ret;
> @@ -3363,6 +3376,12 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
>          }
>      }
>  
> +    if (s->hypercall_patching_enabled == false) {
> +        if (kvm_vm_disable_hypercall_patching(s)) {
> +            warn_report("kvm: failed to disable hypercall patching quirk");
> +        }
> +    }
> +
>      return 0;
>  }
>  
> @@ -6456,6 +6475,19 @@ void kvm_request_xsave_components(X86CPU *cpu, uint64_t mask)
>      }
>  }
>  
> +static bool kvm_arch_get_hypercall_patching(Object *obj, Error **errp)
> +{
> +    KVMState *s = KVM_STATE(obj);
> +    return s->hypercall_patching_enabled;
> +}
> +
> +static void kvm_arch_set_hypercall_patching(Object *obj, bool value,
> +                                            Error **errp)
> +{
> +    KVMState *s = KVM_STATE(obj);
> +    s->hypercall_patching_enabled = value;
> +}
> +
>  static int kvm_arch_get_notify_vmexit(Object *obj, Error **errp)
>  {
>      KVMState *s = KVM_STATE(obj);
> @@ -6589,6 +6621,12 @@ static void kvm_arch_set_xen_evtchn_max_pirq(Object *obj, Visitor *v,
>  
>  void kvm_arch_accel_class_init(ObjectClass *oc)
>  {
> +    object_class_property_add_bool(oc, "hypercall-patching",
> +                                   kvm_arch_get_hypercall_patching,
> +                                   kvm_arch_set_hypercall_patching);
> +    object_class_property_set_description(oc, "hypercall-patching",
> +                                          "Enable hypercall patching quirk");
> +
>      object_class_property_add_enum(oc, "notify-vmexit", "NotifyVMexitOption",
>                                     &NotifyVmexitOption_lookup,
>                                     kvm_arch_get_notify_vmexit,

Ping! Paolo, can we get this weird and unexpected behaviour of KVM get
disabled by default, please?

Thanks,
Mathias

