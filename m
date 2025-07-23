Return-Path: <kvm+bounces-53182-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C689B0EB08
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 08:55:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 552003BAFE2
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 06:54:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 075EA246BCF;
	Wed, 23 Jul 2025 06:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dksak0Qt"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A61D820A5EB
	for <kvm@vger.kernel.org>; Wed, 23 Jul 2025 06:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753253706; cv=none; b=AjgsKRGqOADChbb36JBE5/6CclB9jEcndbxlXStNDpBEyMZYuqcYf3pz621VB/AJn6S9BJlqtdinjVJCAwpokM0YDt7e0NumYD+zf5KhYyUWftfedi7lUmOTKzD8LZTYYj/fmBIeDZYVRNPk0rHhgAjKziJ28ThE25jjs+I+yr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753253706; c=relaxed/simple;
	bh=9zqeunNlLCMc0AHx5VWlPjQowqIlhgNYiwA6hI1YRBs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KdFUAF5GKh0aJUsGdm1tHpv2F9sgpHZV1wfwttsU8cWnA5LNC49QgRz8GfvNf/ZCZzpScPu6yfSc4IgO5XUN23JnDo4SKMrydTMLNDEDYRq/fq/ONESElxRlk9oDdmAQAVfDC+UUfDA1R+Kq75KSzua4HachjhZZYhDrsoVm6P0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dksak0Qt; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753253704; x=1784789704;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=9zqeunNlLCMc0AHx5VWlPjQowqIlhgNYiwA6hI1YRBs=;
  b=dksak0QtyqljEaH+Jxt1NNOMDi0sfva+h/MBSS4KOJcCNBlZVgwEqiM2
   ZH5HFolzJbsgSSXgYvWh0S2dWq0iAe6QLkVKQCU0gpTdBjbijqIf5fKjd
   8sXCJhH96syawED3iW3R9OLQ2nuJcvDTo7hPM8MkeTpnWis02hZVC6rbq
   tbYsTztmgW4m+GGWo6WiR1nQN5UOppxEULSdD5CYVVWO+SrKbqPNhleI5
   FXjwWBqV939yZ5FaCKG9eKpUoYUM05/Feq069NV5rEkWVqmo9hPzlBBog
   VJ80SxYGVM5dJW25JbMZOx3D7AMVXEqGYHva3MexrTM1uN54Bq9el7FEQ
   A==;
X-CSE-ConnectionGUID: 2rwJeabvQbO8pULM92ZnHQ==
X-CSE-MsgGUID: qh8I89KXSvSI2hM4OhMiBA==
X-IronPort-AV: E=McAfee;i="6800,10657,11500"; a="55466628"
X-IronPort-AV: E=Sophos;i="6.16,333,1744095600"; 
   d="scan'208";a="55466628"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2025 23:55:04 -0700
X-CSE-ConnectionGUID: FPsUQrS0SWK6CKghY480cw==
X-CSE-MsgGUID: zxvqtdmQS0us0XZJ2XXaeQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,333,1744095600"; 
   d="scan'208";a="159010505"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2025 23:55:02 -0700
Message-ID: <206a04b9-91cb-41e4-b762-92201c659d78@intel.com>
Date: Wed, 23 Jul 2025 14:54:59 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] i386/kvm: Disable hypercall patching quirk by default
To: Mathias Krause <minipli@grsecurity.net>,
 Paolo Bonzini <pbonzini@redhat.com>, qemu-devel@nongnu.org
Cc: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
 Oliver Upton <oliver.upton@linux.dev>,
 Sean Christopherson <seanjc@google.com>
References: <20250722204316.1186096-1-minipli@grsecurity.net>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250722204316.1186096-1-minipli@grsecurity.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/23/2025 4:43 AM, Mathias Krause wrote:
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

I would leave it to Paolo to decide whether a compat property is needed 
to disable the hypercall patching by default for newer machine, and keep 
the old machine with old behavior (hypercall patching is enabled) by 
default.

The implementation itself looks good to me, exception one nit. And I 
tested that amd guest gets #UD on Intel host with this patch.

Tested-by: Xiaoyao Li <xiaoyao.li@intel.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> ---
> v2:
> - rename hypercall_patching_enabled to hypercall_patching (Xiaoyao Li)
> - make use of error_setg*() (Xiaoyao Li)
> 
>   include/system/kvm_int.h |  1 +
>   qemu-options.hx          | 10 +++++++++
>   target/i386/kvm/kvm.c    | 45 ++++++++++++++++++++++++++++++++++++++++
>   3 files changed, 56 insertions(+)
> 
> diff --git a/include/system/kvm_int.h b/include/system/kvm_int.h
> index 756a3c0a250e..c909464c74a2 100644
> --- a/include/system/kvm_int.h
> +++ b/include/system/kvm_int.h
> @@ -159,6 +159,7 @@ struct KVMState
>       uint64_t kvm_eager_split_size;  /* Eager Page Splitting chunk size */
>       struct KVMDirtyRingReaper reaper;
>       struct KVMMsrEnergy msr_energy;
> +    bool hypercall_patching;
>       NotifyVmexitOption notify_vmexit;
>       uint32_t notify_window;
>       uint32_t xen_version;
> diff --git a/qemu-options.hx b/qemu-options.hx
> index 1f862b19a676..c2e232649c19 100644
> --- a/qemu-options.hx
> +++ b/qemu-options.hx
> @@ -231,6 +231,7 @@ DEF("accel", HAS_ARG, QEMU_OPTION_accel,
>       "                dirty-ring-size=n (KVM dirty ring GFN count, default 0)\n"
>       "                eager-split-size=n (KVM Eager Page Split chunk size, default 0, disabled. ARM only)\n"
>       "                notify-vmexit=run|internal-error|disable,notify-window=n (enable notify VM exit and set notify window, x86 only)\n"
> +    "                hypercall-patching=on|off (enable KVM's VMCALL/VMMCALL hypercall patching quirk, x86 only)\n"
>       "                thread=single|multi (enable multi-threaded TCG)\n"
>       "                device=path (KVM device path, default /dev/kvm)\n", QEMU_ARCH_ALL)
>   SRST
> @@ -313,6 +314,15 @@ SRST
>           open up for a specified of time (i.e. notify-window).
>           Default: notify-vmexit=run,notify-window=0.
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
>       ``device=path``
>           Sets the path to the KVM device node. Defaults to ``/dev/kvm``. This
>           option can be used to pass the KVM device to use via a file descriptor
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index 56a6b9b6381a..55f744956970 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -3224,6 +3224,26 @@ static int kvm_vm_enable_energy_msrs(KVMState *s)
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
> @@ -3363,6 +3383,12 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
>           }
>       }
>   
> +    if (s->hypercall_patching == false) {

Nit: it can be

	if (!s->hypercall_patching )

> +        if (kvm_vm_disable_hypercall_patching(s, &local_err)) {
> +            error_report_err(local_err);
> +        }
> +    }
> +
>       return 0;
>   }
>   
> @@ -6456,6 +6482,19 @@ void kvm_request_xsave_components(X86CPU *cpu, uint64_t mask)
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
> @@ -6589,6 +6628,12 @@ static void kvm_arch_set_xen_evtchn_max_pirq(Object *obj, Visitor *v,
>   
>   void kvm_arch_accel_class_init(ObjectClass *oc)
>   {
> +    object_class_property_add_bool(oc, "hypercall-patching",
> +                                   kvm_arch_get_hypercall_patching,
> +                                   kvm_arch_set_hypercall_patching);
> +    object_class_property_set_description(oc, "hypercall-patching",
> +                                          "Enable hypercall patching quirk");
> +
>       object_class_property_add_enum(oc, "notify-vmexit", "NotifyVMexitOption",
>                                      &NotifyVmexitOption_lookup,
>                                      kvm_arch_get_notify_vmexit,


