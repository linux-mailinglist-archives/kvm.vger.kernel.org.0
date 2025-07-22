Return-Path: <kvm+bounces-53065-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E87FB0D084
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 05:45:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1687A54496C
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 03:45:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 612461E377F;
	Tue, 22 Jul 2025 03:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ej/cixpt"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD101145323
	for <kvm@vger.kernel.org>; Tue, 22 Jul 2025 03:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753155920; cv=none; b=GmlVzEXT/ZaqnhCEIpQXLTh1rEOR3gvc4+T4QbXDSYeq7rPNN/97O5wt994Lwi1rPU611jbGdzysGZikE+j1C4CsY1+BCU87xulTWhTV/C6yOauar/NjgTCU+Y5yf4o712mQZB2rwTaM4EEPf2Luf8r2CPBdOfmWlejqDUmUQTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753155920; c=relaxed/simple;
	bh=zrZs/No0qVKF30sP6igUlzT/Mz2cYoNHdEUSToc4YGQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kuKMLn7bgqevrq02LNZdM/2Ur5iHL3hEPo3hSgU+WtP75aEq1LcwttZymHUPxbGhsoQIKff8xXWr1cLpuIP4wXtG74nuQWuxTVjVMAcX9lyAVnIZObJAqEbu59Ef7FHNmwVZi41Sru3RGN/ye4SwW5JFTJUbaG0TQu6Ap1+lDZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ej/cixpt; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753155918; x=1784691918;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=zrZs/No0qVKF30sP6igUlzT/Mz2cYoNHdEUSToc4YGQ=;
  b=Ej/cixptHb4x625WhO+M2XRypIFVf4l68V4FEAMpy4sv6SYxKrriEvrm
   FEYZ17EMrUN8MksVEFJP/I4E6fhz2K+pwEVqNUzc+QWFuq5rJB1yK/FkT
   0DObVJYtDwZRpLnEhWpQqJDslu7lYr7HYplDhVHH4Ft/pc2hpyA/7H51R
   5CB0Ch0bjQr0/nlenKRCAUNhrNbFKFJQ/MEOMZvXWLGcoF7Ywvic7Yk8j
   h4FV79IhqWYk8QIK1f5/gXPSWBEfZbit9PKQGtInAG5417uzSfzFd3xr4
   aPpnAh2auOLAHKiDtZcjHoLsrJkOWtpVW0Wwo0txM52tES0EkT+b7HqfT
   g==;
X-CSE-ConnectionGUID: 56zd1VGdRYWVa/G/boS8Sg==
X-CSE-MsgGUID: 11yis9jvSKSIBHaL9JHBeg==
X-IronPort-AV: E=McAfee;i="6800,10657,11499"; a="55346526"
X-IronPort-AV: E=Sophos;i="6.16,330,1744095600"; 
   d="scan'208";a="55346526"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2025 20:45:17 -0700
X-CSE-ConnectionGUID: AUpdBQ2USry0Ket7kA6lFg==
X-CSE-MsgGUID: ko3Gql3gR/+sQw1x0wpdHA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,330,1744095600"; 
   d="scan'208";a="163071168"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2025 20:45:15 -0700
Message-ID: <41a5767e-42d7-4877-9bc8-aa8eca6dd3e3@intel.com>
Date: Tue, 22 Jul 2025 11:45:13 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] i386/kvm: Disable hypercall patching quirk by default
To: Mathias Krause <minipli@grsecurity.net>, qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti
 <mtosatti@redhat.com>, kvm@vger.kernel.org,
 Oliver Upton <oliver.upton@linux.dev>,
 Sean Christopherson <seanjc@google.com>
References: <20250619194204.1089048-1-minipli@grsecurity.net>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250619194204.1089048-1-minipli@grsecurity.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/20/2025 3:42 AM, Mathias Krause wrote:
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

The default behavior is patching the hypercall for many years.

If you desire to change the default behavior, please at least keep it 
unchanged for old machine version. i.e., introduce compat_property, 
which sets KVMState->hypercall_patching_enabled to true.

> [1] https://lore.kernel.org/kvm/20211210222903.3417968-1-seanjc@google.com/
> [2] https://lore.kernel.org/kvm/20220316005538.2282772-2-oupton@google.com/
> [3] https://lore.kernel.org/kvm/80e1f1d2-2d79-22b7-6665-c00e4fe9cb9c@redhat.com/
> 
> Cc: Oliver Upton <oliver.upton@linux.dev>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Mathias Krause <minipli@grsecurity.net>
> ---
>   include/system/kvm_int.h |  1 +
>   qemu-options.hx          | 10 ++++++++++
>   target/i386/kvm/kvm.c    | 38 ++++++++++++++++++++++++++++++++++++++
>   3 files changed, 49 insertions(+)
> 
> diff --git a/include/system/kvm_int.h b/include/system/kvm_int.h
> index 756a3c0a250e..fd7129824429 100644
> --- a/include/system/kvm_int.h
> +++ b/include/system/kvm_int.h
> @@ -159,6 +159,7 @@ struct KVMState
>       uint64_t kvm_eager_split_size;  /* Eager Page Splitting chunk size */
>       struct KVMDirtyRingReaper reaper;
>       struct KVMMsrEnergy msr_energy;
> +    bool hypercall_patching_enabled;

IMHO, we can just name it "hypercall_patching".

Since it's a boolean type, true means enabled and false means disabled.

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
> index 56a6b9b6381a..6f5f3b95e553 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -3224,6 +3224,19 @@ static int kvm_vm_enable_energy_msrs(KVMState *s)
>       return 0;
>   }
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

It's not clear it's 1) KVM doesn't support/has FIX_HYPERCALL_INSN quirk 
or 2) KVM has FIX_HYPERCALL_INSN quirk but doesn't allow it to be 
disabled, when KVM_X86_QUIRK_FIX_HYPERCALL_INSN is not returned in 
KVM_CAP_DISABLE_QUIRKS2.

If it's case 1), it can be treated as hypercall patching is disabled 
thus no warning is expected.

So, I think it requires a new cap in KVM to return the enabled quirks.

> +    return 0;

I think return 0 here is to avoid the warn_report() in the caller. But 
for the correct semantics, we need to return -1 to indicate that it 
fails to disable the hypercall patching?

> +}
> +
>   int kvm_arch_init(MachineState *ms, KVMState *s)
>   {
>       int ret;
> @@ -3363,6 +3376,12 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
>           }
>       }
>   
> +    if (s->hypercall_patching_enabled == false) {
> +        if (kvm_vm_disable_hypercall_patching(s)) {
> +            warn_report("kvm: failed to disable hypercall patching quirk");
> +        }
> +    }
> +
>       return 0;
>   }
>   
> @@ -6456,6 +6475,19 @@ void kvm_request_xsave_components(X86CPU *cpu, uint64_t mask)
>       }
>   }
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
>   static int kvm_arch_get_notify_vmexit(Object *obj, Error **errp)
>   {
>       KVMState *s = KVM_STATE(obj);
> @@ -6589,6 +6621,12 @@ static void kvm_arch_set_xen_evtchn_max_pirq(Object *obj, Visitor *v,
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


