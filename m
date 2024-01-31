Return-Path: <kvm+bounces-7526-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C3DDC84332A
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 03:11:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0A69BB2432F
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 02:11:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D2BF566B;
	Wed, 31 Jan 2024 02:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FrYV8GpX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA019523B;
	Wed, 31 Jan 2024 02:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706667088; cv=none; b=mcl3N5b0aftedAeki6QsjJ53F2tIIAj0h6Jlh2s6jMX9mVwufs9lR3w5GKp6hYYsF7xmjR9Mh1N/gBhduiczby+mE6AHjT4hMhb3yqn85+N3dba9vt7141EQgUTu/VaNjuu6IfNTGKGjTUc2Pof7dVrd6XWKH2FvZg75bn2HovU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706667088; c=relaxed/simple;
	bh=1eECbBTXJn2dJ3RKcITy2+8k4nSv/+0yUURQeFCZNHw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=suLeJsvHt9lfidM6BU8B5nyydsHO9HEvV0aCmrcNkMdTj0v6zR85A72cLVh22VW0VFd2c1iwXhqWvUGTfwAFNVAuUTMRwxysGYx8xIJ+7EWN5Dz7VJ8AIcXLUUZIlokCA2j+a1tcGdWKIYo1vNwtxmkpdFUqHnH9+gGReu+QI+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FrYV8GpX; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706667087; x=1738203087;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=1eECbBTXJn2dJ3RKcITy2+8k4nSv/+0yUURQeFCZNHw=;
  b=FrYV8GpXf6eoW0guiCm70JnbkiUW9jB5QFCBhQMvVbx5jPaf01pFtw4I
   bjA/mCZ5XsYMN/Ud+dufkOh5GmNlaGDI/pdw0sXkF4AFDBCKHv7rnU/vF
   h1GHFLoat5kS/NpRNq+55O/4tqvQQ6MIG+QP2nW4xIoWRrqrcGHwuaUnn
   hOkk8VbVtLLwWWqiHANW8ol/iSWdArKvQdqYiWomOP1006F2fBAFmm0ow
   pUV12H2B2I8BL2RiJRJscFgskngnLaZokKuFf4J5aBujY56tkUtckzLVU
   afZNBfiAd88e3NNyyvrbyEJhfVmJKarO+h0NAdN7LQL4dge00TuD/VK94
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10969"; a="3317037"
X-IronPort-AV: E=Sophos;i="6.05,231,1701158400"; 
   d="scan'208";a="3317037"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2024 18:11:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,231,1701158400"; 
   d="scan'208";a="30333826"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.93.12.33]) ([10.93.12.33])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2024 18:11:23 -0800
Message-ID: <d24dc389-8e73-4a7a-9970-1022dcbfa39c@linux.intel.com>
Date: Wed, 31 Jan 2024 10:11:20 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 16/29] KVM: selftests: Test Intel PMU architectural
 events on gp counters
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Kan Liang <kan.liang@linux.intel.com>,
 Jim Mattson <jmattson@google.com>, Jinrong Liang <cloudliang@tencent.com>,
 Aaron Lewis <aaronlewis@google.com>, Like Xu <likexu@tencent.com>
References: <20240109230250.424295-1-seanjc@google.com>
 <20240109230250.424295-17-seanjc@google.com>
 <5f51fda5-bc07-42ac-a723-d09d90136961@linux.intel.com>
 <ZaGxNsrf_pUHkFiY@google.com>
 <cce0483f-539b-4be3-838d-af0ec91db8f0@linux.intel.com>
 <ZbmF9eM84cQhdvGf@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <ZbmF9eM84cQhdvGf@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 1/31/2024 7:27 AM, Sean Christopherson wrote:
> On Mon, Jan 15, 2024, Dapeng Mi wrote:
>> On 1/13/2024 5:37 AM, Sean Christopherson wrote:
>>> On Fri, Jan 12, 2024, Dapeng Mi wrote:
>>>> On 1/10/2024 7:02 AM, Sean Christopherson wrote:
>>>>> +/*
>>>>> + * If an architectural event is supported and guaranteed to generate at least
>>>>> + * one "hit, assert that its count is non-zero.  If an event isn't supported or
>>>>> + * the test can't guarantee the associated action will occur, then all bets are
>>>>> + * off regarding the count, i.e. no checks can be done.
>>>>> + *
>>>>> + * Sanity check that in all cases, the event doesn't count when it's disabled,
>>>>> + * and that KVM correctly emulates the write of an arbitrary value.
>>>>> + */
>>>>> +static void guest_assert_event_count(uint8_t idx,
>>>>> +				     struct kvm_x86_pmu_feature event,
>>>>> +				     uint32_t pmc, uint32_t pmc_msr)
>>>>> +{
>>>>> +	uint64_t count;
>>>>> +
>>>>> +	count = _rdpmc(pmc);
>>>>> +	if (!this_pmu_has(event))
>>>>> +		goto sanity_checks;
>>>>> +
>>>>> +	switch (idx) {
>>>>> +	case INTEL_ARCH_INSTRUCTIONS_RETIRED_INDEX:
>>>>> +		GUEST_ASSERT_EQ(count, NUM_INSNS_RETIRED);
>>>>> +		break;
>>>>> +	case INTEL_ARCH_BRANCHES_RETIRED_INDEX:
>>>>> +		GUEST_ASSERT_EQ(count, NUM_BRANCHES);
>>>>> +		break;
>>>>> +	case INTEL_ARCH_CPU_CYCLES_INDEX:
>>>>> +	case INTEL_ARCH_REFERENCE_CYCLES_INDEX:
>>>> Since we already support slots event in below guest_test_arch_event(), we
>>>> can add check for INTEL_ARCH_TOPDOWN_SLOTS_INDEX here.
>>> Can that actually be tested at this point, since KVM doesn't support
>>> X86_PMU_FEATURE_TOPDOWN_SLOTS, i.e. this_pmu_has() above should always fail, no?
>> I suppose X86_PMU_FEATURE_TOPDOWN_SLOTS has been supported in KVM.  The
>> following output comes from a guest with latest kvm-x86 code on the Sapphire
>> Rapids platform.
>>
>> sudo cpuid -l 0xa
>> CPU 0:
>>     Architecture Performance Monitoring Features (0xa):
>>        version ID                               = 0x2 (2)
>>        number of counters per logical processor = 0x8 (8)
>>        bit width of counter                     = 0x30 (48)
>>        length of EBX bit vector                 = 0x8 (8)
>>        core cycle event                         = available
>>        instruction retired event                = available
>>        reference cycles event                   = available
>>        last-level cache ref event               = available
>>        last-level cache miss event              = available
>>        branch inst retired event                = available
>>        branch mispred retired event             = available
>>        top-down slots event                     = available
>>
>> Current KVM doesn't support fixed counter 3 and pseudo slots event yet, but
>> the architectural slots event is supported and can be programed on a GP
>> counter. Current test code can cover this case, so I think we'd better add
>> the check for the slots count.
> Can you submit a patch on top, with a changelog that includes justification that
> that explains exactly what assertions can be made on the top-down slots event
> given the "workload" being measured?  I'm definitely not opposed to adding coverage
> for top-down slots, but at this point, I don't want to respin this series, nor do
> I want to make that change when applying on the fly.

Yeah, I'm glad to submit a patch for this. :)

BTW, I have a patch series to do the bug fixes and improvements for 
kvm-unit-tests/pmu test. (some improvement ideas come from this patchset.)

https://lore.kernel.org/kvm/20240103031409.2504051-1-dapeng1.mi@linux.intel.com/

Could you please kindly review them? Thanks.

>

