Return-Path: <kvm+bounces-34984-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DB298A0868F
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 06:37:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8E54F1887314
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 05:37:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B19C2066C0;
	Fri, 10 Jan 2025 05:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nKg+KTIL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3536B290F;
	Fri, 10 Jan 2025 05:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736487425; cv=none; b=cGzdUYfG8z40O1sysSVa4OsRhrQgx30AiJC7I/3iMsQnaHG4PScHRorA1fvstaz5Cn3yzX9vDUjzwazwGLyvoOBlYGa8iWk1fY7dRB++p6XoFDjHiZOPixbEzQFdk5kYyIrw8eEG+STe4LOM0JIssZVOIlG7NDPZG87NZZxLkEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736487425; c=relaxed/simple;
	bh=ThGWkbfOq/aZG7WSy5hQQObGHUK/iWXfu7yiYGXiMIQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SmWw1XfDhVOktG4oYT92CPYYC3LYLDMzeBB0j0owHkS/5qemMHdhux7P300ifXJhGKbxNJmhQ69qGB2ltKLbMKGhQRzgSTKPUTzIXle3TtpTEzEgEXgi4UohWGb4pdpx70CC9v4vGkDk4Z5Bb0VDuRDHpuT7bDZy0doWA/zyZE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nKg+KTIL; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736487423; x=1768023423;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ThGWkbfOq/aZG7WSy5hQQObGHUK/iWXfu7yiYGXiMIQ=;
  b=nKg+KTILqA4GJzjFry2rI88SJpWePZuqTgNm3lOa5UUCj0hV4xaiQ8uN
   n5pQ7tObqZkDt8RHXZx1FX4XDSuJr35pP/WPlmeB2yB/ZIXEgcvdJAU6+
   y5g2vtgoA4X8P/zM0x7rP987aqT8tRKdRWsCTNCS0xtW9jSS4bD1TuQYf
   REgkpFU0AA8qT2fxH9Ho+0y8YJ/1yqIzlgk/TMRBLzF3yhaxoLr71VZol
   gOSxWP8TdgJSeRPyVlCPSJZzo4pETemqdOvyrf4Jco4y4P/w5SfwlKB9a
   7vBGWYGW5Otv8sgQcjYCOthP0vtmeYaF01Wds75N03L1dswNqmciNN155
   A==;
X-CSE-ConnectionGUID: bpunXoCNQP+eSU3J7iKY+A==
X-CSE-MsgGUID: wB68o7rbSESacrJEhkHItQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11310"; a="24375580"
X-IronPort-AV: E=Sophos;i="6.12,303,1728975600"; 
   d="scan'208";a="24375580"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2025 21:37:02 -0800
X-CSE-ConnectionGUID: 4d89aNziT6CmL0Sl2AzPYw==
X-CSE-MsgGUID: 1HXlILGgTCiI4YF7U9vMKg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="108254319"
Received: from unknown (HELO [10.238.1.62]) ([10.238.1.62])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2025 21:36:59 -0800
Message-ID: <a708b8b3-9a6d-4ff5-ab0d-864d2f80b341@linux.intel.com>
Date: Fri, 10 Jan 2025 13:36:57 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/16] KVM: TDX: Add support for find pending IRQ in a
 protected local APIC
To: Nikolay Borisov <nik.borisov@suse.com>, pbonzini@redhat.com,
 seanjc@google.com, kvm@vger.kernel.org
Cc: rick.p.edgecombe@intel.com, kai.huang@intel.com, adrian.hunter@intel.com,
 reinette.chatre@intel.com, xiaoyao.li@intel.com,
 tony.lindgren@linux.intel.com, isaku.yamahata@intel.com,
 yan.y.zhao@intel.com, chao.gao@intel.com, linux-kernel@vger.kernel.org
References: <20241209010734.3543481-1-binbin.wu@linux.intel.com>
 <20241209010734.3543481-2-binbin.wu@linux.intel.com>
 <5d1d421c-3123-455e-aba1-1baf7f12e89e@suse.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <5d1d421c-3123-455e-aba1-1baf7f12e89e@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit




On 1/9/2025 11:38 PM, Nikolay Borisov wrote:
>
>
> On 9.12.24 г. 3:07 ч., Binbin Wu wrote:
>> From: Sean Christopherson <seanjc@google.com>
>>
>> Add flag and hook to KVM's local APIC management to support determining
>> whether or not a TDX guest as a pending IRQ.  For TDX vCPUs, the virtual
>> APIC page is owned by the TDX module and cannot be accessed by KVM.  As a
>> result, registers that are virtualized by the CPU, e.g. PPR, cannot be
>> read or written by KVM.  To deliver interrupts for TDX guests, KVM must
>> send an IRQ to the CPU on the posted interrupt notification vector.  And
>> to determine if TDX vCPU has a pending interrupt, KVM must check if there
>> is an outstanding notification.
>>
>> Return "no interrupt" in kvm_apic_has_interrupt() if the guest APIC is
>> protected to short-circuit the various other flows that try to pull an
>> IRQ out of the vAPIC, the only valid operation is querying _if_ an IRQ is
>> pending, KVM can't do anything based on _which_ IRQ is pending.
>>
>> Intentionally omit sanity checks from other flows, e.g. PPR update, so as
>> not to degrade non-TDX guests with unnecessary checks.  A well-behaved KVM
>> and userspace will never reach those flows for TDX guests, but reaching
>> them is not fatal if something does go awry.
>>
>> Note, this doesn't handle interrupts that have been delivered to the vCPU
>> but not yet recognized by the core, i.e. interrupts that are sitting in
>> vmcs.GUEST_INTR_STATUS.  Querying that state requires a SEAMCALL and will
>> be supported in a future patch.
>>
>> Signed-off-by: Sean Christopherson <seanjc@google.com>
>> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
>> Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
>> ---
>> TDX interrupts breakout:
>>   - Dropped vt_protected_apic_has_interrupt() with KVM_BUG_ON(), wire in
>>     tdx_protected_apic_has_interrupt() directly. (Rick)
>>   - Add {} on else in vt_hardware_setup()
>> ---
>>   arch/x86/include/asm/kvm-x86-ops.h | 1 +
>>   arch/x86/include/asm/kvm_host.h    | 1 +
>>   arch/x86/kvm/irq.c                 | 3 +++
>>   arch/x86/kvm/lapic.c               | 3 +++
>>   arch/x86/kvm/lapic.h               | 2 ++
>>   arch/x86/kvm/vmx/main.c            | 3 +++
>>   arch/x86/kvm/vmx/tdx.c             | 6 ++++++
>>   arch/x86/kvm/vmx/x86_ops.h         | 2 ++
>>   8 files changed, 21 insertions(+)
>>
>> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
>> index ec1b1b39c6b3..d5faaaee6ac0 100644
>> --- a/arch/x86/include/asm/kvm-x86-ops.h
>> +++ b/arch/x86/include/asm/kvm-x86-ops.h
>> @@ -114,6 +114,7 @@ KVM_X86_OP_OPTIONAL(pi_start_assignment)
>>   KVM_X86_OP_OPTIONAL(apicv_pre_state_restore)
>>   KVM_X86_OP_OPTIONAL(apicv_post_state_restore)
>>   KVM_X86_OP_OPTIONAL_RET0(dy_apicv_has_pending_interrupt)
>> +KVM_X86_OP_OPTIONAL(protected_apic_has_interrupt)
>>   KVM_X86_OP_OPTIONAL(set_hv_timer)
>>   KVM_X86_OP_OPTIONAL(cancel_hv_timer)
>>   KVM_X86_OP(setup_mce)
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>> index 37dc7edef1ca..32c7d58a5d68 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -1811,6 +1811,7 @@ struct kvm_x86_ops {
>>       void (*apicv_pre_state_restore)(struct kvm_vcpu *vcpu);
>>       void (*apicv_post_state_restore)(struct kvm_vcpu *vcpu);
>>       bool (*dy_apicv_has_pending_interrupt)(struct kvm_vcpu *vcpu);
>> +    bool (*protected_apic_has_interrupt)(struct kvm_vcpu *vcpu);
>>         int (*set_hv_timer)(struct kvm_vcpu *vcpu, u64 guest_deadline_tsc,
>>                   bool *expired);
>> diff --git a/arch/x86/kvm/irq.c b/arch/x86/kvm/irq.c
>> index 63f66c51975a..f0644d0bbe11 100644
>> --- a/arch/x86/kvm/irq.c
>> +++ b/arch/x86/kvm/irq.c
>> @@ -100,6 +100,9 @@ int kvm_cpu_has_interrupt(struct kvm_vcpu *v)
>>       if (kvm_cpu_has_extint(v))
>>           return 1;
>>   +    if (lapic_in_kernel(v) && v->arch.apic->guest_apic_protected)
>> +        return static_call(kvm_x86_protected_apic_has_interrupt)(v);
>> +
>>       return kvm_apic_has_interrupt(v) != -1;    /* LAPIC */
>>   }
>>   EXPORT_SYMBOL_GPL(kvm_cpu_has_interrupt);
>> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
>> index 65412640cfc7..684777c2f0a4 100644
>> --- a/arch/x86/kvm/lapic.c
>> +++ b/arch/x86/kvm/lapic.c
>> @@ -2920,6 +2920,9 @@ int kvm_apic_has_interrupt(struct kvm_vcpu *vcpu)
>>       if (!kvm_apic_present(vcpu))
>>           return -1;
>>   +    if (apic->guest_apic_protected)
>> +        return -1;
>> +
>>       __apic_update_ppr(apic, &ppr);
>>       return apic_has_interrupt_for_ppr(apic, ppr);
>>   }
>> diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
>> index 1b8ef9856422..82355faf8c0d 100644
>> --- a/arch/x86/kvm/lapic.h
>> +++ b/arch/x86/kvm/lapic.h
>> @@ -65,6 +65,8 @@ struct kvm_lapic {
>>       bool sw_enabled;
>>       bool irr_pending;
>>       bool lvt0_in_nmi_mode;
>> +    /* Select registers in the vAPIC cannot be read/written. */
>> +    bool guest_apic_protected;
>
> Can't this member be eliminated and instead  is_td_vcpu() used as it stands currently that member is simply a proxy value for "is this a tdx vcpu"?

By using this member, the code in the common path can be more generic,
instead of using is_td_vcpu(). I.e, in the future, if other VM types has
the same characteristic, no need to modify the common code.

>
> <snip>


