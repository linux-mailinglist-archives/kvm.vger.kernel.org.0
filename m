Return-Path: <kvm+bounces-15927-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 17A618B23BD
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 16:18:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 851EF1F236E1
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 14:18:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DFA914A4EA;
	Thu, 25 Apr 2024 14:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TefVK+1D"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0D9B149E0C;
	Thu, 25 Apr 2024 14:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714054691; cv=none; b=CSGm8KkspagAMveNwGz+yE1JukJi4oyQUxPyWKt6er3OMuwIgUPgEc0TK179uKSfYWMHX1f1a1dN9wrvf3RCUJ0SdpmbKgB6L7x0L/mjTCUh3gZUgR4Bi1DB1mov4GUIzUmcZQ+ATffnNDUfVNTqwsvlyXgQ2oHDSFrWcMdmH7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714054691; c=relaxed/simple;
	bh=qs3IbBARNXEGNRHB5Qimg74EcvDIsLw0NrUCyJRdsoc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VvYS/5WKVXgiCt91vVPVzk0niDVMRsszM/vxP1hmTJUbIIgZaCZ2G3gM1f1BFK4OLrFpgFrqCEAwUNiw4HtVvoM9w0YJGThOP0j9R+rMwI2psAZFyCru85w6IfvN9CwXegMDFkZkT/vzkXRZYxevz67BtEnmTDjUTR+pRsKAUvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TefVK+1D; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714054690; x=1745590690;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=qs3IbBARNXEGNRHB5Qimg74EcvDIsLw0NrUCyJRdsoc=;
  b=TefVK+1DvKLDVaD0OdBeqcfAXBijNHPlztlRIOdc0+u/iiupfW6alynB
   +H+SgSNkL2MPIblAdU8bfQP0jRJQTrTtBfh8VzjZE1kHbNuIYSKsCHbFA
   tT6bzZXjePETW2Z5n3qFQMdwhXvK+jj6FbteXNfw/yasCxZtd3YkC2PNY
   dhxKsXlLxDNG+IXTstgoFVG1Cxj44NhPfJwRJTex+VLzNn97Yy5/1BCOB
   1O7HdfvlGhaT85SIlEEG8h7ROFnI8Gf6t7knW0LZc4ez9vTFGmao9Gkuz
   J63+i8pEgLC2z9/Y6dmvjfG9yC0tZQ62ngeNraForJoyv62plHI1Vlukn
   g==;
X-CSE-ConnectionGUID: t2DJFfuHTAySMnxpoCffYw==
X-CSE-MsgGUID: EPPWUPsGR+W0AfuG8h2gSQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11055"; a="9903241"
X-IronPort-AV: E=Sophos;i="6.07,229,1708416000"; 
   d="scan'208";a="9903241"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2024 07:18:09 -0700
X-CSE-ConnectionGUID: qqUc1iwgQFC8nC9vvfJAdg==
X-CSE-MsgGUID: 2pUNRhOVQdCBRTP6nLF8jg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,229,1708416000"; 
   d="scan'208";a="25152778"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.242.48]) ([10.124.242.48])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2024 07:18:05 -0700
Message-ID: <44177c13-b755-4d64-9763-1d4dfe0dfa4f@intel.com>
Date: Thu, 25 Apr 2024 22:18:02 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 8/9] KVM: VMX: Open code VMX preemption timer rate mask
 in its accessor
To: Sean Christopherson <seanjc@google.com>
Cc: Zhao Liu <zhao1.liu@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>, Andy Lutomirski <luto@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, Shan Kang <shan.kang@intel.com>,
 Kai Huang <kai.huang@intel.com>, Xin Li <xin3.li@intel.com>
References: <20240309012725.1409949-1-seanjc@google.com>
 <20240309012725.1409949-9-seanjc@google.com> <ZfRtSKcXTI/lAQxE@intel.com>
 <ZfSLRrf1CtJEGZw2@google.com>
 <1e063b73-0f9a-4956-9634-2552e6e63ee1@intel.com>
 <ZgyBckwbrijACeB1@google.com> <ZilmVN0gbFlpnHO9@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <ZilmVN0gbFlpnHO9@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/25/2024 4:06 AM, Sean Christopherson wrote:
> On Tue, Apr 02, 2024, Sean Christopherson wrote:
>> On Mon, Apr 01, 2024, Xiaoyao Li wrote:
>>> On 3/16/2024 1:54 AM, Sean Christopherson wrote:
>>>> On Fri, Mar 15, 2024, Zhao Liu wrote:
>>>>> On Fri, Mar 08, 2024 at 05:27:24PM -0800, Sean Christopherson wrote:
>>>>>> Use vmx_misc_preemption_timer_rate() to get the rate in hardware_setup(),
>>>>>> and open code the rate's bitmask in vmx_misc_preemption_timer_rate() so
>>>>>> that the function looks like all the helpers that grab values from
>>>>>> VMX_BASIC and VMX_MISC MSR values.
>>>>
>>>> ...
>>>>
>>>>>> -#define VMX_MISC_PREEMPTION_TIMER_RATE_MASK	GENMASK_ULL(4, 0)
>>>>>>    #define VMX_MISC_SAVE_EFER_LMA			BIT_ULL(5)
>>>>>>    #define VMX_MISC_ACTIVITY_HLT			BIT_ULL(6)
>>>>>>    #define VMX_MISC_ACTIVITY_SHUTDOWN		BIT_ULL(7)
>>>>>> @@ -162,7 +161,7 @@ static inline u32 vmx_basic_vmcs_mem_type(u64 vmx_basic)
>>>>>>    static inline int vmx_misc_preemption_timer_rate(u64 vmx_misc)
>>>>>>    {
>>>>>> -	return vmx_misc & VMX_MISC_PREEMPTION_TIMER_RATE_MASK;
>>>>>> +	return vmx_misc & GENMASK_ULL(4, 0);
>>>>>>    }
>>>>>
>>>>> I feel keeping VMX_MISC_PREEMPTION_TIMER_RATE_MASK is clearer than
>>>>> GENMASK_ULL(4, 0), and the former improves code readability.
>>>>>
>>>>> May not need to drop VMX_MISC_PREEMPTION_TIMER_RATE_MASK?
>>>>
>>>> I don't necessarily disagree, but in this case I value consistency over one
>>>> individual case.  As called out in the changelog, the motivation is to make
>>>> vmx_misc_preemption_timer_rate() look like all the surrounding helpers.
>>>>
>>>> _If_ we want to preserve the mask, then we should add #defines for vmx_misc_cr3_count(),
>>>> vmx_misc_max_msr(), etc.
>>>>
>>>> I don't have a super strong preference, though I think my vote would be to not
>>>> add the masks and go with this patch.  These helpers are intended to be the _only_
>>>> way to access the fields, i.e. they effectively _are_ the mask macros, just in
>>>> function form.
>>>>
>>>
>>> +1.
>>>
>>> However, it seems different for vmx_basic_vmcs_mem_type() in patch 5, that I
>>> just recommended to define the MASK.
>>>
>>> Because we already have
>>>
>>> 	#define VMX_BASIC_MEM_TYPE_SHIFT	50
>>>
>>> and it has been used in vmx/nested.c,
>>>
>>> static inline u32 vmx_basic_vmcs_mem_type(u64 vmx_basic)
>>> {
>>> 	return (vmx_basic & GENMASK_ULL(53, 50)) >>
>>> 		VMX_BASIC_MEM_TYPE_SHIFT;
>>> }
>>>
>>> looks not intuitive than original patch.
>>
>> Yeah, agreed, that's taking the worst of both worlds.  I'll update patch 5 to drop
>> VMX_BASIC_MEM_TYPE_SHIFT when effectively "moving" it into vmx_basic_vmcs_mem_type().
> 
> Drat.  Finally getting back to this, dropping VMX_BASIC_MEM_TYPE_SHIFT doesn't
> work because it's used by nested_vmx_setup_basic(), as is VMX_BASIC_VMCS_SIZE_SHIFT,
> which is presumably why past me kept them around.
> 
> I'm leaning towards keeping things as proposed in this series.  

If it goes this way, I beg for a comment above the code to explain. 
Otherwise, people might send patch to use defined MARCO in the future.

> I don't see us
> gaining a third copy, or even a third user, i.e. I don't think we are creating a
> future problem by open coding the shift in vmx_basic_vmcs_mem_type().  And IMO
> code like this
> 
> 	return (vmx_basic & VMX_BASIC_MEM_TYPE_MASK) >>
> 	       VMX_BASIC_MEM_TYPE_SHIFT;
> 
> is an unnecessary obfuscation when there is literally one user (the accessor).
> 
> Another idea would be to delete VMX_BASIC_MEM_TYPE_SHIFT and VMX_BASIC_VMCS_SIZE_SHIFT,
> and either open code the values or use local const variables, but that also seems
> like a net negative, e.g. splits the effective definitions over too many locations.


