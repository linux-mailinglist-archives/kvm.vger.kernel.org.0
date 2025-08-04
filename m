Return-Path: <kvm+bounces-53881-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CBB22B19A83
	for <lists+kvm@lfdr.de>; Mon,  4 Aug 2025 05:33:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DA619177B9F
	for <lists+kvm@lfdr.de>; Mon,  4 Aug 2025 03:33:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8F6C19B5A7;
	Mon,  4 Aug 2025 03:33:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EMNvgZdN"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD8CD2E36F6
	for <kvm@vger.kernel.org>; Mon,  4 Aug 2025 03:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754278385; cv=none; b=WdpZi1Gjelmc9W9N0q4El9lfdxPPe3GeiY9wERHiulM5CIHDftGxt2cQIC7vIGrAxz2rsKOMo3DIDMCypZHFJBTGJi15EpLffzS8Asu5vnX8gubUOafyC6WTI2YtT3ChgcqMOJUvPqz0ZnMaePsOPNXpvX3GsEdjs+fujfwFKpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754278385; c=relaxed/simple;
	bh=v7YM17EEoPjCgYVxxeC3VS6wY83XauAuJa+XPjEz01s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sUOdgxBcfpVCHgPgGRYWkwegtQ05Rq4zPd6/gQidN/vYXGuLpA813LYCKbceX168ptC+/qVGdmmM+ortXEHi5oUBS1t74E7si+iCEDcBGQjbsjdLmo9gwq5QHwhOnFf/WcipwG+Nt5M9LtHJhKnyULVLPnktSbYp6gYfpiRUjHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EMNvgZdN; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754278383; x=1785814383;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=v7YM17EEoPjCgYVxxeC3VS6wY83XauAuJa+XPjEz01s=;
  b=EMNvgZdNTSEpTyVu+x4KN1T7JEgySnK+4buQXfNtL9LUKUBalx+Kr++l
   3gGgYUVVVDdEew43uN0FU4MNdUgTkSNws+1AXoPHfR2inAZUtW5ohFVq0
   9ZK3SgSa4jqThDIDgMf0paMeMEDAZV/bPSQxT7H+7QAi7/A/d3PLHBhS3
   Zgra2/4zBSK+lhwqsmYtNFBCvYwrE0wdwlNlBIIu+SeC/BWd8w7A74few
   aw9dCCcnKYNfhaI2kkkiRS13p6YdxhtijVQCa+3VMS3SQ9jYUu6n1V6xY
   cbr9Km0luNs8oCsnxkWAeyg324RO8+NytM1JTsELVNCDhlwAAOB7LmWPv
   g==;
X-CSE-ConnectionGUID: OueuHW80R9yyYuRVKHneKw==
X-CSE-MsgGUID: rcd+LhiQR/OuyPNE8ifK4A==
X-IronPort-AV: E=McAfee;i="6800,10657,11511"; a="73988460"
X-IronPort-AV: E=Sophos;i="6.17,258,1747724400"; 
   d="scan'208";a="73988460"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2025 20:33:00 -0700
X-CSE-ConnectionGUID: os7HehQUTJ6a0oWTOEyfVw==
X-CSE-MsgGUID: BYqcN+eCStWfDNDd6q9d0A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,258,1747724400"; 
   d="scan'208";a="169350591"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2025 20:32:58 -0700
Message-ID: <6bcf6108-2d0c-44ae-a9f7-2f53ca23af7a@intel.com>
Date: Mon, 4 Aug 2025 11:32:55 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] i386/kvm: Provide knob to disable hypercall patching
 quirk
To: Mathias Krause <minipli@grsecurity.net>,
 Paolo Bonzini <pbonzini@redhat.com>, qemu-devel@nongnu.org
Cc: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
 Oliver Upton <oliver.upton@linux.dev>,
 Sean Christopherson <seanjc@google.com>
References: <20250801131226.2729893-1-minipli@grsecurity.net>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250801131226.2729893-1-minipli@grsecurity.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/1/2025 9:12 PM, Mathias Krause wrote:
> KVM has a weird behaviour when a guest executes VMCALL on an AMD system
> or VMMCALL on an Intel CPU. Both naturally generate an invalid opcode
> exception (#UD) as they are just the wrong instruction for the CPU
> given. But instead of forwarding the exception to the guest, KVM tries
> to patch the guest instruction to match the host's actual hypercall
> instruction. That is doomed to fail for regular operating systems, as
> read-only code is rather the standard these days. But, instead of
> letting go the patching attempt and falling back to #UD injection, KVM
> propagates its failure and injects the page fault instead.
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
> Add a new property 'hypercall-patching=on|off' to the KVM accelerator
> but keep the default behaviour as-is as there are, unfortunately,
> systems out there relying on the patching, e.g. KUT[4,5].
> 
> For regular operating systems, however, the patching wouldn't be needed,
> nor work at all. If it would, these systrems would be vulnerable to
> memory corruption attacks, freely overwriting kernel code as they
> please.

For non-coco VMs, the systems are surely vulnerable to memory corruption 
attacks that the host VMM is free to modify the guest memory. It's 
irrelevant to whether hypercall patching is needed or works.

> [1] https://lore.kernel.org/kvm/20211210222903.3417968-1-seanjc@google.com/
> [2] https://lore.kernel.org/kvm/20220316005538.2282772-2-oupton@google.com/
> [3] https://lore.kernel.org/kvm/80e1f1d2-2d79-22b7-6665-c00e4fe9cb9c@redhat.com/
> [4] https://gitlab.com/kvm-unit-tests/kvm-unit-tests/-/blob/f045ea5627a3/x86/apic.c#L644
> [5] https://gitlab.com/kvm-unit-tests/kvm-unit-tests/-/blob/f045ea5627a3/x86/vmexit.c#L36
> 
> Cc: Oliver Upton <oliver.upton@linux.dev>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Mathias Krause <minipli@grsecurity.net>
> ---
> Xiaoyao, I left out your Tested-by and Reviewed-by as I changed the code
> (slightly) and it didn't felt right to pick these up. However, as only
> the default value changed, the functionality would be the same if you
> tested both cases explicitly (-accel kvm,hypercall-patching={on,off}).

No problem, I just re-tested it.

Tested-by: Xiaoyao Li <xiaoyao.li@intel.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> v3:
> - switch default to 'on' to not change the default behaviour
> - reference KUT tests relying on hypercall patching
> 
> v2:
> - rename hypercall_patching_enabled to hypercall_patching (Xiaoyao Li)
> - make use of error_setg*() (Xiaoyao Li)
> 
>   accel/kvm/kvm-all.c      |  1 +
>   include/system/kvm_int.h |  1 +
>   qemu-options.hx          | 10 +++++++++
>   target/i386/kvm/kvm.c    | 45 ++++++++++++++++++++++++++++++++++++++++
>   4 files changed, 57 insertions(+)
> 
> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> index 890d5ea9f865..a68f779b6c1c 100644
> --- a/accel/kvm/kvm-all.c
> +++ b/accel/kvm/kvm-all.c
> @@ -3997,6 +3997,7 @@ static void kvm_accel_instance_init(Object *obj)
>       s->kvm_dirty_ring_size = 0;
>       s->kvm_dirty_ring_with_bitmap = false;
>       s->kvm_eager_split_size = 0;
> +    s->hypercall_patching = true;
>       s->notify_vmexit = NOTIFY_VMEXIT_OPTION_RUN;
>       s->notify_window = 0;
>       s->xen_version = 0;
> diff --git a/include/system/kvm_int.h b/include/system/kvm_int.h
> index 9247493b0299..ec891ca8e302 100644
> --- a/include/system/kvm_int.h
> +++ b/include/system/kvm_int.h
> @@ -160,6 +160,7 @@ struct KVMState
>       uint64_t kvm_eager_split_size;  /* Eager Page Splitting chunk size */
>       struct KVMDirtyRingReaper reaper;
>       struct KVMMsrEnergy msr_energy;
> +    bool hypercall_patching;
>       NotifyVmexitOption notify_vmexit;
>       uint32_t notify_window;
>       uint32_t xen_version;
> diff --git a/qemu-options.hx b/qemu-options.hx
> index ab23f14d2178..98af1a91e6e6 100644
> --- a/qemu-options.hx
> +++ b/qemu-options.hx
> @@ -236,6 +236,7 @@ DEF("accel", HAS_ARG, QEMU_OPTION_accel,
>       "                dirty-ring-size=n (KVM dirty ring GFN count, default 0)\n"
>       "                eager-split-size=n (KVM Eager Page Split chunk size, default 0, disabled. ARM only)\n"
>       "                notify-vmexit=run|internal-error|disable,notify-window=n (enable notify VM exit and set notify window, x86 only)\n"
> +    "                hypercall-patching=on|off (disable KVM's VMCALL/VMMCALL hypercall patching quirk, x86 only)\n"

I would like to say "(configure KVM's VMCALL/VMCALL hypercall patching 
quirk, x86 only)" instead of "disable"

>       "                thread=single|multi (enable multi-threaded TCG)\n"
>       "                device=path (KVM device path, default /dev/kvm)\n", QEMU_ARCH_ALL)
>   SRST
> @@ -318,6 +319,15 @@ SRST
>           open up for a specified of time (i.e. notify-window).
>           Default: notify-vmexit=run,notify-window=0.
>   
> +    ``hypercall-patching=on|off``
> +        KVM tries to recover from the wrong hypercall instruction being used by
> +        a guest by attempting to rewrite it to the one supported natively by
> +        the host CPU (VMCALL on Intel, VMMCALL for AMD systems). However, this
> +        patching may fail if the guest memory is write protected, leading to a
> +        page fault getting propagated to the guest instead of an illegal
> +        instruction exception. As this may confuse guests, this option allows
> +        disabling it (x86 only, enabled by default).
> +
>       ``device=path``
>           Sets the path to the KVM device node. Defaults to ``/dev/kvm``. This
>           option can be used to pass the KVM device to use via a file descriptor
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index 369626f8c8d7..a841d53c240f 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -3228,6 +3228,26 @@ static int kvm_vm_enable_energy_msrs(KVMState *s)
>       return 0;
>   }
>   
> +static int kvm_vm_disable_hypercall_patching(KVMState *s, Error **errp)
> +{
> +    int valid_quirks = kvm_vm_check_extension(s, KVM_CAP_DISABLE_QUIRKS2);
> +    int ret = -1;
> +
> +    if (valid_quirks & KVM_X86_QUIRK_FIX_HYPERCALL_INSN) {
> +        ret = kvm_vm_enable_cap(s, KVM_CAP_DISABLE_QUIRKS2, 0,
> +                                KVM_X86_QUIRK_FIX_HYPERCALL_INSN);
> +        if (ret) {
> +            error_setg_errno(errp, -ret, "kvm: failed to disable "
> +                             "hypercall patching quirk: %s",
> +                             strerror(-ret));
> +        }
> +    } else {
> +        error_setg(errp, "kvm: disabling hypercall patching not supported");
> +    }
> +
> +    return ret;
> +}
> +
>   int kvm_arch_init(MachineState *ms, KVMState *s)
>   {
>       int ret;
> @@ -3367,6 +3387,12 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
>           }
>       }
>   
> +    if (!s->hypercall_patching) {
> +        if (kvm_vm_disable_hypercall_patching(s, &local_err)) {
> +            error_report_err(local_err);
> +        }
> +    }
> +
>       return 0;
>   }
>   
> @@ -6478,6 +6504,19 @@ void kvm_request_xsave_components(X86CPU *cpu, uint64_t mask)
>       }
>   }
>   
> +static bool kvm_arch_get_hypercall_patching(Object *obj, Error **errp)
> +{
> +    KVMState *s = KVM_STATE(obj);
> +    return s->hypercall_patching;
> +}
> +
> +static void kvm_arch_set_hypercall_patching(Object *obj, bool value,
> +                                            Error **errp)
> +{
> +    KVMState *s = KVM_STATE(obj);
> +    s->hypercall_patching = value;
> +}
> +
>   static int kvm_arch_get_notify_vmexit(Object *obj, Error **errp)
>   {
>       KVMState *s = KVM_STATE(obj);
> @@ -6611,6 +6650,12 @@ static void kvm_arch_set_xen_evtchn_max_pirq(Object *obj, Visitor *v,
>   
>   void kvm_arch_accel_class_init(ObjectClass *oc)
>   {
> +    object_class_property_add_bool(oc, "hypercall-patching",
> +                                   kvm_arch_get_hypercall_patching,
> +                                   kvm_arch_set_hypercall_patching);
> +    object_class_property_set_description(oc, "hypercall-patching",
> +                                          "Disable hypercall patching quirk");

Ditto, Could we use "Configure hypercall patching quirk"? It's not only 
to disable it.

>       object_class_property_add_enum(oc, "notify-vmexit", "NotifyVMexitOption",
>                                      &NotifyVmexitOption_lookup,
>                                      kvm_arch_get_notify_vmexit,


