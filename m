Return-Path: <kvm+bounces-45690-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FCE9AAD537
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 07:28:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9E5324C5602
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 05:28:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A2D21E1DF6;
	Wed,  7 May 2025 05:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ECgvF1KJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A65751DF968;
	Wed,  7 May 2025 05:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746595686; cv=none; b=Ne4Qxq9KHzGiIrsvpsHsbKBPknjFU2JpgVAfWik4dJG4WR99UZwqveU2gqBMlBGhl2Yb715NTP29VaxOTSGoeGdTacR1FSm1lV65ktmLjrPhDlF1h4a3JKtv3W80RGMqN4h7bBly/LTKyL64l4jqLkbAbWp8QS6F3ileS9QVhE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746595686; c=relaxed/simple;
	bh=Cijq2E0xF6duCxceftnIZjpIQiWFoR/1fj7fTD5TZoQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SYyf/NBrP9VruwvWX/ZjukmRAapc9skSXFpYCje7ibqyTeylridHKRKW8LDmZByOsELO9hurzbRaUBfUgc4JdtNTojc7sBzyLYiEQUN7zURtR+LGZHerXZWKPmhSOiAgrDSTICF4J0kKL6G0yvhS2NSqUDSrfdNz7m4mPsca7FQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ECgvF1KJ; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746595685; x=1778131685;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Cijq2E0xF6duCxceftnIZjpIQiWFoR/1fj7fTD5TZoQ=;
  b=ECgvF1KJmk6YPN7VM1ZSejEM+QEIJZR1241A4b74Kq7DLte3D0Qonmb7
   UHf52c75wCn9xrVan0lo8BWAsZG4bqOw/+eBPi2JnuyZR2c4qFH1vRyeI
   fFGCaQQ04gwQI0jW66EKVjpczDuyRVBzmVCzx7bq1Z0kZEtxrhjhb3+Jt
   ghsHAsFb9kHcmDhzxqUU5RHvBOZsmBiy/Ixmi41fyK6xfaYYWJwqVFCG8
   Z30HTIUEhfRla8Jhi3RuTtUhLlU2m1NujYMtKpkAuiJnqwrk9mvNOuiaU
   yTIzXjLvKBiuWWwjl4S1POxy5BvYFchUyC/je/7aJFl+WzuTTLcNk5bZD
   g==;
X-CSE-ConnectionGUID: 3hIsq8hdSAy4X208KozZCA==
X-CSE-MsgGUID: QQLIPbkXQF+HVF+l8q7xbA==
X-IronPort-AV: E=McAfee;i="6700,10204,11425"; a="50950719"
X-IronPort-AV: E=Sophos;i="6.15,268,1739865600"; 
   d="scan'208";a="50950719"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2025 22:28:04 -0700
X-CSE-ConnectionGUID: nUoencVOTlOHLTQxhdETsA==
X-CSE-MsgGUID: mV0hs1qPQLOZnKzMs1pu+w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,268,1739865600"; 
   d="scan'208";a="135842157"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.245.128]) ([10.124.245.128])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2025 22:27:59 -0700
Message-ID: <181eae79-735d-414e-9a46-caa321602204@linux.intel.com>
Date: Wed, 7 May 2025 13:27:56 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] x86: KVM: VMX: preserve host's
 DEBUGCTLMSR_FREEZE_IN_SMM while in the guest mode
To: mlevitsk@redhat.com, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
 Borislav Petkov <bp@alien8.de>, Paolo Bonzini <pbonzini@redhat.com>,
 x86@kernel.org, Dave Hansen <dave.hansen@linux.intel.com>,
 Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>
References: <20250416002546.3300893-1-mlevitsk@redhat.com>
 <20250416002546.3300893-4-mlevitsk@redhat.com> <aAgpD_5BI6ZcCN29@google.com>
 <2b1ec570a37992cdfa2edad325e53e0592d696c8.camel@redhat.com>
 <71af8435d2085b3f969cb3e73cff5bfacd243819.camel@redhat.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <71af8435d2085b3f969cb3e73cff5bfacd243819.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


On 5/2/2025 4:53 AM, mlevitsk@redhat.com wrote:
> On Thu, 2025-05-01 at 16:41 -0400, mlevitsk@redhat.com wrote:
>> On Tue, 2025-04-22 at 16:41 -0700, Sean Christopherson wrote:
>>> On Tue, Apr 15, 2025, Maxim Levitsky wrote:
>>>> Pass through the host's DEBUGCTL.DEBUGCTLMSR_FREEZE_IN_SMM to the guest
>>>> GUEST_IA32_DEBUGCTL without the guest seeing this value.
>>>>
>>>> Note that in the future we might allow the guest to set this bit as well,
>>>> when we implement PMU freezing on VM own, virtual SMM entry.
>>>>
>>>> Since the value of the host DEBUGCTL can in theory change between VM runs,
>>>> check if has changed, and if yes, then reload the GUEST_IA32_DEBUGCTL with
>>>> the new value of the host portion of it (currently only the
>>>> DEBUGCTLMSR_FREEZE_IN_SMM bit)
>>> No, it can't.  DEBUGCTLMSR_FREEZE_IN_SMM can be toggled via IPI callback, but
>>> IRQs are disabled for the entirety of the inner run loop.  And if I'm somehow
>>> wrong, this change movement absolutely belongs in a separate patch.
>
> Hi,
>
> You are right here - reading MSR_IA32_DEBUGCTLMSR in the inner loop is a performance
> regression.
>
>
> Any ideas on how to solve this then? Since currently its the common code that
> reads the current value of the MSR_IA32_DEBUGCTLMSR and it doesn't leave any indication
> about if it changed I can do either
>
> 1. store old value as well, something like 'vcpu->arch.host_debugctl_old' Ugly IMHO.
>
> 2. add DEBUG_CTL to the set of the 'dirty' registers, e.g add new bit for kvm_register_mark_dirty
> It looks a bit overkill to me
>
> 3. Add new x86 callback for something like .sync_debugctl(). I vote for this option.
>
> What do you think/prefer?

Hmm, not sure if I missed something, but why to move the reading host
debug_ctrl MSR from the original place into inner loop? The interrupt has
been disabled before reading host debug_ctrl for original code, suppose
host debug_ctrl won't changed after reading it?


>
> Best regards,
> 	Maxim Levitsky
>
>>>> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
>>>> ---
>>>>  arch/x86/kvm/svm/svm.c |  2 ++
>>>>  arch/x86/kvm/vmx/vmx.c | 28 +++++++++++++++++++++++++++-
>>>>  arch/x86/kvm/x86.c     |  2 --
>>>>  3 files changed, 29 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>>>> index cc1c721ba067..fda0660236d8 100644
>>>> --- a/arch/x86/kvm/svm/svm.c
>>>> +++ b/arch/x86/kvm/svm/svm.c
>>>> @@ -4271,6 +4271,8 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu,
>>>>  	svm->vmcb->save.rsp = vcpu->arch.regs[VCPU_REGS_RSP];
>>>>  	svm->vmcb->save.rip = vcpu->arch.regs[VCPU_REGS_RIP];
>>>>  
>>>> +	vcpu->arch.host_debugctl = get_debugctlmsr();
>>>> +
>>>>  	/*
>>>>  	 * Disable singlestep if we're injecting an interrupt/exception.
>>>>  	 * We don't want our modified rflags to be pushed on the stack where
>>>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>>>> index c9208a4acda4..e0bc31598d60 100644
>>>> --- a/arch/x86/kvm/vmx/vmx.c
>>>> +++ b/arch/x86/kvm/vmx/vmx.c
>>>> @@ -2194,6 +2194,17 @@ static u64 vmx_get_supported_debugctl(struct kvm_vcpu *vcpu, bool host_initiated
>>>>  	return debugctl;
>>>>  }
>>>>  
>>>> +static u64 vmx_get_host_preserved_debugctl(struct kvm_vcpu *vcpu)
>>> No, just open code handling DEBUGCTLMSR_FREEZE_IN_SMM, or make it a #define.
>>> I'm not remotely convinced that we'll ever want to emulate DEBUGCTLMSR_FREEZE_IN_SMM,
>>> and trying to plan for that possibility and adds complexity for no immediate value.
>> Hi,
>>
>> The problem here is a bit different: we indeed are very unlikely to emulate the
>> DEBUGCTLMSR_FREEZE_IN_SMM but however, when I wrote this patch I was sure that this bit is 
>> mandatory with PMU version of 2 or more,  but looks like it is optional after all:
>>
>> "
>> Note that system software must check if the processor supports the IA32_DEBUGCTL.FREEZE_WHILE_SMM
>> control bit. IA32_DEBUGCTL.FREEZE_WHILE_SMM is supported if IA32_PERF_CAPABIL-
>> ITIES.FREEZE_WHILE_SMM[Bit 12] is reporting 1. See Section 20.8 for details of detecting the presence of
>> IA32_PERF_CAPABILITIES MSR."
>>
>> KVM indeed doesn't set the bit 12 of IA32_PERF_CAPABILITIES.
>>
>> However, note that the Linux kernel silently sets this bit without checking the aforementioned capability 
>> bit and ends up with a #GP exception, which it silently ignores.... (I checked this with a trace...)
>>
>> This led me to believe that this bit should be unconditionally supported,
>> meaning that KVM should at least fake setting it without triggering a #GP.
>>
>> Since that is not the case, I can revert to the simpler model of exclusively using GUEST_IA32_DEBUGCTL 
>> while hiding the bit from the guest, however I do vote to keep the guest/host separation.
>>
>>>> +{
>>>> +	/*
>>>> +	 * Bits of host's DEBUGCTL that we should preserve while the guest is
>>>> +	 * running.
>>>> +	 *
>>>> +	 * Some of those bits might still be emulated for the guest own use.
>>>> +	 */
>>>> +	return DEBUGCTLMSR_FREEZE_IN_SMM;
>>>>
>>>>  u64 vmx_get_guest_debugctl(struct kvm_vcpu *vcpu)
>>>>  {
>>>>  	return to_vmx(vcpu)->msr_ia32_debugctl;
>>>> @@ -2202,9 +2213,11 @@ u64 vmx_get_guest_debugctl(struct kvm_vcpu *vcpu)
>>>>  static void __vmx_set_guest_debugctl(struct kvm_vcpu *vcpu, u64 data)
>>>>  {
>>>>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
>>>> +	u64 host_mask = vmx_get_host_preserved_debugctl(vcpu);
>>>>  
>>>>  	vmx->msr_ia32_debugctl = data;
>>>> -	vmcs_write64(GUEST_IA32_DEBUGCTL, data);
>>>> +	vmcs_write64(GUEST_IA32_DEBUGCTL,
>>>> +		     (vcpu->arch.host_debugctl & host_mask) | (data & ~host_mask));
>>>>  }
>>>>  
>>>>  bool vmx_set_guest_debugctl(struct kvm_vcpu *vcpu, u64 data, bool host_initiated)
>>>> @@ -2232,6 +2245,7 @@ bool vmx_set_guest_debugctl(struct kvm_vcpu *vcpu, u64 data, bool host_initiated
>>>>  	return true;
>>>>  }
>>>>  
>>>> +
>>> Spurious newline.
>>>
>>>>  /*
>>>>   * Writes msr value into the appropriate "register".
>>>>   * Returns 0 on success, non-0 otherwise.
>>>> @@ -7349,6 +7363,7 @@ fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
>>>>  {
>>>>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
>>>>  	unsigned long cr3, cr4;
>>>> +	u64 old_debugctl;
>>>>  
>>>>  	/* Record the guest's net vcpu time for enforced NMI injections. */
>>>>  	if (unlikely(!enable_vnmi &&
>>>> @@ -7379,6 +7394,17 @@ fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
>>>>  		vmcs_write32(PLE_WINDOW, vmx->ple_window);
>>>>  	}
>>>>  
>>>> +	old_debugctl = vcpu->arch.host_debugctl;
>>>> +	vcpu->arch.host_debugctl = get_debugctlmsr();
>>>> +
>>>> +	/*
>>>> +	 * In case the host DEBUGCTL had changed since the last time we
>>>> +	 * read it, update the guest's GUEST_IA32_DEBUGCTL with
>>>> +	 * the host's bits.
>>>> +	 */
>>>> +	if (old_debugctl != vcpu->arch.host_debugctl)
>>> This can and should be optimized to only do an update if a host-preserved bit
>>> is toggled.
>> True, I will do this in the next version.
>>
>>>> +		__vmx_set_guest_debugctl(vcpu, vmx->msr_ia32_debugctl);
>>> I would rather have a helper that explicitly writes the VMCS field, not one that
>>> sets the guest value *and* writes the VMCS field.
>>> The usage in init_vmcs() doesn't need to write vmx->msr_ia32_debugctl because the
>>> vCPU is zero allocated, and this usage doesn't change vmx->msr_ia32_debugctl.
>>> So the only path that actually needs to modify vmx->msr_ia32_debugctl is
>>> vmx_set_guest_debugctl().
>>
>> But what about nested entry? nested entry pretty much sets the MSR to a value given by the guest.
>>
>> Also technically the intel_pmu_legacy_freezing_lbrs_on_pmi also changes the guest value by emulating what the real hardware does.
>>
>> Best regards,
>> 	Maxim Levitsky
>>
>>
>>>> +
>>>>  	/*
>>>>  	 * We did this in prepare_switch_to_guest, because it needs to
>>>>  	 * be within srcu_read_lock.
>>>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>>>> index 844e81ee1d96..05e866ed345d 100644
>>>> --- a/arch/x86/kvm/x86.c
>>>> +++ b/arch/x86/kvm/x86.c
>>>> @@ -11020,8 +11020,6 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>>>>  		set_debugreg(0, 7);
>>>>  	}
>>>>  
>>>> -	vcpu->arch.host_debugctl = get_debugctlmsr();
>>>> -
>>>>  	guest_timing_enter_irqoff();
>>>>  
>>>>  	for (;;) {
>>>> -- 
>>>> 2.26.3
>>>>
>

