Return-Path: <kvm+bounces-37951-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 54961A31DC8
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2025 06:16:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E9F283A6EE0
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2025 05:16:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83BD01EEA32;
	Wed, 12 Feb 2025 05:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kxnsJEZ0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88EB538FA3;
	Wed, 12 Feb 2025 05:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739337388; cv=none; b=CFJdoTSgxRB0CAS2J9UUzE8vBLeHrRdZWcghpaB5t2pgbpZ/4mnrPMYE+F9SBl4VvA6Gcqi9d2qKTreKJSR2bBWfQ5uE8HUwxCNv174exfSUx9pX+4cJ/+dRHSEza3Qn5VKeYcJvJc0pPJ/MjIQYYyYeCburBX1xQXJNcMhTAOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739337388; c=relaxed/simple;
	bh=eVsMpX/8Jed3hCVhlFQngIaOqAD3Ff3kb6Lw95jePG4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mJStzKZ4Yywt/a6ySiCMhT3e7ue5NzWRzWct9l7jjCAJlrxHWinIwq7sBQp8NeEZpa0R3prN+r5Efuvuxi2aEkGimkpLPJIf1+I7kKv+PokFlwZDRQ54ko2mMqTFYctdnVJcs4y5lGnwsQoHVXnf2TD0OU7itX1Tb5NKgx9EDe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kxnsJEZ0; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739337387; x=1770873387;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=eVsMpX/8Jed3hCVhlFQngIaOqAD3Ff3kb6Lw95jePG4=;
  b=kxnsJEZ0S0swymowk5h9M8aDAw7wwMWfP9hLF7j8ybjWpBFVW+uhHK7y
   VNFqlMfL1HvRMwgCJh/WXLNhl0UXC7/j0usTyemBHWcCxoHKHl93ijxq2
   IRGAEa50yZe0BGT7z6zdi3HaghYthhqksUMcGTcZjRx95HQXd5JxWA3ib
   07RQ3WkRi4m5kXyjnSIUB0/SmGzOc4mKI9oiEPJD3oJ8DXfB6gBv7D3+R
   Jm2h5BDIL2yrYxXCGlVlgLuD8794TOyJfGP5yGcLEmdVmtbt/H+TON8w0
   ZMxZM6qaRI2evcsIgRCXV77aEDfm3Y7E8lhz95/dwJePpBh1YMMjX7jjJ
   Q==;
X-CSE-ConnectionGUID: VlIuLnu4QMeeAVL+8MFzHw==
X-CSE-MsgGUID: KlbilTcfTVq2zLgVUhpPUQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11342"; a="51371852"
X-IronPort-AV: E=Sophos;i="6.13,279,1732608000"; 
   d="scan'208";a="51371852"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2025 21:16:26 -0800
X-CSE-ConnectionGUID: eFx3fF4dROu+Z0YR9qgKpQ==
X-CSE-MsgGUID: W1kQezGMTvqFn0HXpRDkFg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,279,1732608000"; 
   d="scan'208";a="117735888"
Received: from unknown (HELO [10.238.0.51]) ([10.238.0.51])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2025 21:16:23 -0800
Message-ID: <3033f048-6aa8-483a-b2dc-37e8dfb237d5@linux.intel.com>
Date: Wed, 12 Feb 2025 13:16:21 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/8] KVM: TDX: Handle TDG.VP.VMCALL<MapGPA>
To: Sean Christopherson <seanjc@google.com>, Chao Gao <chao.gao@intel.com>
Cc: Yan Zhao <yan.y.zhao@intel.com>, pbonzini@redhat.com,
 kvm@vger.kernel.org, rick.p.edgecombe@intel.com, kai.huang@intel.com,
 adrian.hunter@intel.com, reinette.chatre@intel.com, xiaoyao.li@intel.com,
 tony.lindgren@intel.com, isaku.yamahata@intel.com,
 linux-kernel@vger.kernel.org
References: <20250211025442.3071607-1-binbin.wu@linux.intel.com>
 <20250211025442.3071607-6-binbin.wu@linux.intel.com>
 <Z6r0Q/zzjrDaHfXi@yzhao56-desk.sh.intel.com>
 <926a035f-e375-4164-bcd8-736e65a1c0f7@linux.intel.com>
 <Z6sReszzi8jL97TP@intel.com> <Z6vvgGFngGjQHwps@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <Z6vvgGFngGjQHwps@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 2/12/2025 8:46 AM, Sean Christopherson wrote:
> On Tue, Feb 11, 2025, Chao Gao wrote:
>> On Tue, Feb 11, 2025 at 04:11:19PM +0800, Binbin Wu wrote:
>>>
>>> On 2/11/2025 2:54 PM, Yan Zhao wrote:
>>>> On Tue, Feb 11, 2025 at 10:54:39AM +0800, Binbin Wu wrote:
>>>>> +static int tdx_complete_vmcall_map_gpa(struct kvm_vcpu *vcpu)
>>>>> +{
>>>>> +	struct vcpu_tdx *tdx = to_tdx(vcpu);
>>>>> +
>>>>> +	if (vcpu->run->hypercall.ret) {
>>>>> +		tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_INVALID_OPERAND);
>>>>> +		tdx->vp_enter_args.r11 = tdx->map_gpa_next;
>>>>> +		return 1;
>>>>> +	}
>>>>> +
>>>>> +	tdx->map_gpa_next += TDX_MAP_GPA_MAX_LEN;
>>>>> +	if (tdx->map_gpa_next >= tdx->map_gpa_end)
>>>>> +		return 1;
>>>>> +
>>>>> +	/*
>>>>> +	 * Stop processing the remaining part if there is pending interrupt.
>>>>> +	 * Skip checking pending virtual interrupt (reflected by
>>>>> +	 * TDX_VCPU_STATE_DETAILS_INTR_PENDING bit) to save a seamcall because
>>>>> +	 * if guest disabled interrupt, it's OK not returning back to guest
>>>>> +	 * due to non-NMI interrupt. Also it's rare to TDVMCALL_MAP_GPA
>>>>> +	 * immediately after STI or MOV/POP SS.
>>>>> +	 */
>>>>> +	if (pi_has_pending_interrupt(vcpu) ||
>>>>> +	    kvm_test_request(KVM_REQ_NMI, vcpu) || vcpu->arch.nmi_pending) {
>>>> Should here also use "kvm_vcpu_has_events()" to replace
>>>> "pi_has_pending_interrupt(vcpu) ||
>>>>    kvm_test_request(KVM_REQ_NMI, vcpu) || vcpu->arch.nmi_pending" as Sean
>>>> suggested at [1]?
>>>>
>>>> [1] https://lore.kernel.org/all/Z4rIGv4E7Jdmhl8P@google.com
>>> For TDX guests, kvm_vcpu_has_events() will check pending virtual interrupt
>>> via a SEAM call.  As noted in the comments, the check for pending virtual
>>> interrupt is intentionally skipped to save the SEAM call. Additionally,
> Drat, I had a whole response typed up and then discovered the implementation of
> tdx_protected_apic_has_interrupt() had changed.  But I think the basic gist
> still holds.
>
> The new version:
>
>   bool tdx_protected_apic_has_interrupt(struct kvm_vcpu *vcpu)
>   {
> -       return pi_has_pending_interrupt(vcpu);
> +       u64 vcpu_state_details;
> +
> +       if (pi_has_pending_interrupt(vcpu))
> +               return true;
> +
> +       vcpu_state_details =
> +               td_state_non_arch_read64(to_tdx(vcpu), TD_VCPU_STATE_DETAILS_NON_ARCH);
> +
> +       return tdx_vcpu_state_details_intr_pending(vcpu_state_details);
>   }
>
> is much better than the old:
>
>   bool tdx_protected_apic_has_interrupt(struct kvm_vcpu *vcpu)
>   {
> -       return pi_has_pending_interrupt(vcpu);
> +       bool ret = pi_has_pending_interrupt(vcpu);
> +       union tdx_vcpu_state_details details;
> +       struct vcpu_tdx *tdx = to_tdx(vcpu);
> +
> +       if (ret || vcpu->arch.mp_state != KVM_MP_STATE_HALTED)
> +               return true;
> +
> +       if (tdx->interrupt_disabled_hlt)
> +               return false;
> +
> +       details.full = td_state_non_arch_read64(tdx, TD_VCPU_STATE_DETAILS_NON_ARCH);
> +       return !!details.vmxip;
>   }
>
> because assuming the vCPU has an interrupt if it's not HALTED is all kinds of
> wrong.
>
> However, checking VMXIP for the !HLT case is also wrong.  And undesirable, as
> evidenced by both this path and the EPT violation retry path wanted to avoid
> checking VMXIP.
>
> Except for the guest being stupid (non-HLT TDCALL in an interrupt shadow), having
> an interrupt in RVI that is fully unmasked will be extremely rare.  Actually,
> outside of an interrupt shadow, I don't think it's even possible.  I can't think
> of any CPU flows that modify RVI in the middle of instruction execution.  I.e. if
> RVI is non-zero, then either the interrupt has been pending since before the
> TDVMCALL, or the TDVMCALL is in an STI/SS shadow.  And if the interrupt was
> pending before TDVMCALL, then it _must_ be blocked, otherwise the interrupt
> would have been serviced at the instruction boundary.

Agree.

>
> I am completely comfortable saying that KVM doesn't care about STI/SS shadows
> outside of the HALTED case, and so unless I'm missing something, I think it makes
> sense for tdx_protected_apic_has_interrupt() to not check RVI outside of the HALTED
> case, because it's impossible to know if the interrupt is actually unmasked, and
> statistically it's far, far more likely that it _is_ masked.
OK. Will update tdx_protected_apic_has_interrupt() in "TDX interrupts" part.
And use kvm_vcpu_has_events() to replace the open code in this patch.

Thanks!

>
>>> unnecessarily returning back to guest will has performance impact.
>>>
>>> But according to the discussion thread above, it seems that Sean prioritized
>>> code readability (i.e. reuse the common helper to make TDX code less special)
>>> over performance considerations?
>> To mitigate the performance impact, we can cache the "pending interrupt" status
>> on the first read, similar to how guest RSP/RBP are cached to avoid VMREADs for
>> normal VMs. This optimization can be done in a separate patch or series.
>>
>> And, future TDX modules will report the status via registers.


