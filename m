Return-Path: <kvm+bounces-15094-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C3A378A9B68
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 15:36:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7A57A1F22D38
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 13:36:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C316116132C;
	Thu, 18 Apr 2024 13:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Wa8N0//G"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D63BD81AA2;
	Thu, 18 Apr 2024 13:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713447404; cv=none; b=dLsMpXzb1DAhcJvQPE1HqtaM5mDg4FhnRDfioa/2/fD3tYbAdeMUcjoM2xa7e9AfY8aSoCRqMZ3LnWygQICHHAvTBVyGcLYkwf/XD5qLDS73u7wqZnpmdxRilY9eeddUC9oNXRfaRd25MPI/nOLa1RRMRh2L52A6oG5UizQszYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713447404; c=relaxed/simple;
	bh=nnJhdz3RIU81gHJNHF88zbSY6Ik4uNHyK5+aop10vZg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bn1reZRO9VPt81BUymy+FIiM3uVk0y3XM3JR4s9TT9KI3GopStKzdhMPJXnZuyxftc9rfsd0HkM7at7ks7WlTY76RGqhoLucJASSGMFkRupwsCiCsP8pSRhbdvlye6RK2K0KcsiAjnC5ijjZ5wPVDEc7wmSaEMjxgNoPoe7uFvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Wa8N0//G; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713447402; x=1744983402;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=nnJhdz3RIU81gHJNHF88zbSY6Ik4uNHyK5+aop10vZg=;
  b=Wa8N0//Gn2VhxkBvhIp84ct1a3jyVots7CaZYB6PZpSr5Fmr/HGbpWP0
   NdIg5mZ+DL4kalFiFPVYDodrPw/DA7QMWPqPdy3tMlw/N2e4ISM/W7tu+
   VqiFORTqSCG9Qprb/U/zgtm/FT0DjtRkfV9f9JXmsJTkl2DM9wKt16KQy
   YMILz4j5qva2UM8M++agpJ4GY+vTYp/UE2Jk5cGpoz4ckbAi0Ve/mzA/8
   2/FRU+K56ha3crX13RSZKdEo7d7ieBI9l6DOUTMQYOGaMUqk1k67bgRDm
   0WaOe/3pjymOp9Sx1395f/DMg80MHuRajefbBNBeQQX3wpRANplo62cdR
   w==;
X-CSE-ConnectionGUID: dGg9lTguRWekbuqNU1SipQ==
X-CSE-MsgGUID: fNQLfqDnSfaLxWif+3Dntg==
X-IronPort-AV: E=McAfee;i="6600,9927,11047"; a="8866932"
X-IronPort-AV: E=Sophos;i="6.07,212,1708416000"; 
   d="scan'208";a="8866932"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2024 06:36:41 -0700
X-CSE-ConnectionGUID: zwrx9StiRcawW8mQNxNsEw==
X-CSE-MsgGUID: TYbXT4BQRQ6ozsUBxTk4tw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,212,1708416000"; 
   d="scan'208";a="53926653"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.124.236.140]) ([10.124.236.140])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2024 06:36:38 -0700
Message-ID: <4ae8893f-b3dc-4768-887a-b6a680654479@linux.intel.com>
Date: Thu, 18 Apr 2024 21:36:35 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 111/130] KVM: TDX: Implement callbacks for MSR
 operations for TDX
To: Isaku Yamahata <isaku.yamahata@intel.com>,
 Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sagi Shahar <sagis@google.com>,
 Kai Huang <kai.huang@intel.com>, chen.bo@intel.com, hang.yuan@intel.com,
 tina.zhang@intel.com, isaku.yamahata@linux.intel.com
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <62f8890cb90e49a3e0b0d5946318c0267b80c540.1708933498.git.isaku.yamahata@intel.com>
 <Zg1yPIV6cVJrwGxX@google.com>
 <20240404234238.GW2444378@ls.amr.corp.intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20240404234238.GW2444378@ls.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 4/5/2024 7:42 AM, Isaku Yamahata wrote:
> On Wed, Apr 03, 2024 at 08:14:04AM -0700,
> Sean Christopherson <seanjc@google.com> wrote:
>
>> On Mon, Feb 26, 2024, isaku.yamahata@intel.com wrote:
>>> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
>>> index 389bb95d2af0..c8f991b69720 100644
>>> --- a/arch/x86/kvm/vmx/tdx.c
>>> +++ b/arch/x86/kvm/vmx/tdx.c
>>> @@ -1877,6 +1877,76 @@ void tdx_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason,
>>>   	*error_code = 0;
>>>   }
>>>   
>>> +static bool tdx_is_emulated_kvm_msr(u32 index, bool write)
>>> +{
>>> +	switch (index) {
>>> +	case MSR_KVM_POLL_CONTROL:
>>> +		return true;
>>> +	default:
>>> +		return false;
>>> +	}
>>> +}
>>> +
>>> +bool tdx_has_emulated_msr(u32 index, bool write)
>>> +{
>>> +	switch (index) {
>>> +	case MSR_IA32_UCODE_REV:
>>> +	case MSR_IA32_ARCH_CAPABILITIES:
>>> +	case MSR_IA32_POWER_CTL:
>>> +	case MSR_IA32_CR_PAT:
>>> +	case MSR_IA32_TSC_DEADLINE:
>>> +	case MSR_IA32_MISC_ENABLE:
>>> +	case MSR_PLATFORM_INFO:
>>> +	case MSR_MISC_FEATURES_ENABLES:
>>> +	case MSR_IA32_MCG_CAP:
>>> +	case MSR_IA32_MCG_STATUS:
>>> +	case MSR_IA32_MCG_CTL:
>>> +	case MSR_IA32_MCG_EXT_CTL:
>>> +	case MSR_IA32_MC0_CTL ... MSR_IA32_MCx_CTL(KVM_MAX_MCE_BANKS) - 1:
>>> +	case MSR_IA32_MC0_CTL2 ... MSR_IA32_MCx_CTL2(KVM_MAX_MCE_BANKS) - 1:
>>> +		/* MSR_IA32_MCx_{CTL, STATUS, ADDR, MISC, CTL2} */
>>> +		return true;
>>> +	case APIC_BASE_MSR ... APIC_BASE_MSR + 0xff:
>>> +		/*
>>> +		 * x2APIC registers that are virtualized by the CPU can't be
>>> +		 * emulated, KVM doesn't have access to the virtual APIC page.
>>> +		 */
>>> +		switch (index) {
>>> +		case X2APIC_MSR(APIC_TASKPRI):
>>> +		case X2APIC_MSR(APIC_PROCPRI):
>>> +		case X2APIC_MSR(APIC_EOI):
>>> +		case X2APIC_MSR(APIC_ISR) ... X2APIC_MSR(APIC_ISR + APIC_ISR_NR):
>>> +		case X2APIC_MSR(APIC_TMR) ... X2APIC_MSR(APIC_TMR + APIC_ISR_NR):
>>> +		case X2APIC_MSR(APIC_IRR) ... X2APIC_MSR(APIC_IRR + APIC_ISR_NR):
>>> +			return false;
>>> +		default:
>>> +			return true;
>>> +		}
>>> +	case MSR_IA32_APICBASE:
>>> +	case MSR_EFER:
>>> +		return !write;
>> Meh, for literally two MSRs, just open code them in tdx_set_msr() and drop the
>> @write param.  Or alternatively add:
>>
>> static bool tdx_is_read_only_msr(u32 msr){
>> {
>> 	return msr == MSR_IA32_APICBASE || msr == MSR_EFER;
>> }
> Sure will add.
>
>>> +	case 0x4b564d00 ... 0x4b564dff:
>> This is silly, just do
>>
>> 	case MSR_KVM_POLL_CONTROL:
>> 		return false;

Shoud return true here, right?
>>
>> and let everything else go through the default statement, no?
> Now tdx_is_emulated_kvm_msr() is trivial, will open code it.
>
>
>>> +		/* KVM custom MSRs */
>>> +		return tdx_is_emulated_kvm_msr(index, write);
>>> +	default:
>>> +		return false;
>>> +	}
>>> +}
>>> +
>>>

