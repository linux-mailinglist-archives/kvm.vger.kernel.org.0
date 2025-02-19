Return-Path: <kvm+bounces-38521-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 881C4A3AE42
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 02:01:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1806D3B67B8
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 00:58:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 804D613D891;
	Wed, 19 Feb 2025 00:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="W6Yss6n0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3C071EA80;
	Wed, 19 Feb 2025 00:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739926160; cv=none; b=IfCfMD+bq7HEVT6jm5RO49djtFyJ5IsK8KAk6ERkrB7WvpF9eULausG5Z6jBCaD9rcRe1a8pxQBff/g3IeJL+c4FJ9Ad64O9rvtlTrWADMLwTuUrtS87STTrI3V7H1z2v/8x+Pzn1S2XslXNo96OL+gIoQeMn9Gjsolnel34vbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739926160; c=relaxed/simple;
	bh=k1xCUsS2F2OsNYMqSP+OtTM/+hdWDceq8oFCTxeLIIM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RodZrdSj3RQMEIhF2hUAJyKxpgXVfEEff1QO5eIgGzUGGMrdmWHEHYEBMZ569Rj5xDscpjRtGUz9erF2eCo4leTc+DjKzL5/evVrlvLSmsc7VO4VGQLVdrih7Vuh6w6t0nYGtL5WN3MuGPmHEplccWBWpuRD0JocjFU3A0gGRLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=W6Yss6n0; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739926159; x=1771462159;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=k1xCUsS2F2OsNYMqSP+OtTM/+hdWDceq8oFCTxeLIIM=;
  b=W6Yss6n0mFjDutU4r8pdYjx/Acr5b4N9EyO1rQi/V7uqvjgrr/9ySDIz
   IQnT3pXWfN/kOdPdFfa/ik07zyb8/wDPrgQ+HOqxEj80zhChg3KzLZedn
   EjqckOtM0NwzP9x9jK1N2lB50fKCv0tfOV5yMCAmyd6rwcGhlk5oUiusz
   uYat/Wrswu0vLeSxRONCfzX4ocWZBJELpZIPk7p7VHwbUp2oNr8BFGvq2
   PqzfSh5gq1E34g2Jb5cmOFPXQYSF4VqPAbrANzOeKJg3j9f/zO4kj7QOa
   QesX9yx1NZ0/sC9guvZbseBbHW1b0lUljIFouLmfVJmIPHKAUqig1Ttgb
   Q==;
X-CSE-ConnectionGUID: XQ3RQXehTOOq1ZrtXR3vJg==
X-CSE-MsgGUID: ASKYU5trR2CEWO44+bfJig==
X-IronPort-AV: E=McAfee;i="6700,10204,11348"; a="28247626"
X-IronPort-AV: E=Sophos;i="6.13,296,1732608000"; 
   d="scan'208";a="28247626"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2025 16:49:18 -0800
X-CSE-ConnectionGUID: 8UOiHrkRSQKRytG03nycyg==
X-CSE-MsgGUID: 3M8iqulnRfatjUAiyw3EpA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,296,1732608000"; 
   d="scan'208";a="145409494"
Received: from unknown (HELO [10.238.9.235]) ([10.238.9.235])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2025 16:49:15 -0800
Message-ID: <cbda86c4-f56f-4142-93eb-12736b2e3719@linux.intel.com>
Date: Wed, 19 Feb 2025 08:49:12 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/8] KVM: TDX: Handle TDG.VP.VMCALL<MapGPA>
To: Sean Christopherson <seanjc@google.com>
Cc: Chao Gao <chao.gao@intel.com>, Yan Zhao <yan.y.zhao@intel.com>,
 pbonzini@redhat.com, kvm@vger.kernel.org, rick.p.edgecombe@intel.com,
 kai.huang@intel.com, adrian.hunter@intel.com, reinette.chatre@intel.com,
 xiaoyao.li@intel.com, tony.lindgren@intel.com, isaku.yamahata@intel.com,
 linux-kernel@vger.kernel.org
References: <Z6r0Q/zzjrDaHfXi@yzhao56-desk.sh.intel.com>
 <926a035f-e375-4164-bcd8-736e65a1c0f7@linux.intel.com>
 <Z6sReszzi8jL97TP@intel.com> <Z6vvgGFngGjQHwps@google.com>
 <3033f048-6aa8-483a-b2dc-37e8dfb237d5@linux.intel.com>
 <Z6zu8liLTKAKmPwV@google.com>
 <f12e1c06-d38d-4ed0-b471-7f016057f604@linux.intel.com>
 <c47f0fa1-b400-4186-846e-84d0470d887e@linux.intel.com>
 <Z64M_r64CCWxSD5_@google.com>
 <bcb80309-10ec-44e3-90db-259de6076183@linux.intel.com>
 <Z7Ul9ORPitXpQAV5@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <Z7Ul9ORPitXpQAV5@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2/19/2025 8:29 AM, Sean Christopherson wrote:
> On Mon, Feb 17, 2025, Binbin Wu wrote:
>> On 2/13/2025 11:17 PM, Sean Christopherson wrote:
>>> On Thu, Feb 13, 2025, Binbin Wu wrote:
>>>> On 2/13/2025 11:23 AM, Binbin Wu wrote:
>>>>> On 2/13/2025 2:56 AM, Sean Christopherson wrote:
>>>>>> On Wed, Feb 12, 2025, Binbin Wu wrote:
>>>>>>> On 2/12/2025 8:46 AM, Sean Christopherson wrote:
>>>>>>>> I am completely comfortable saying that KVM doesn't care about STI/SS shadows
>>>>>>>> outside of the HALTED case, and so unless I'm missing something, I think it makes
>>>>>>>> sense for tdx_protected_apic_has_interrupt() to not check RVI outside of the HALTED
>>>>>>>> case, because it's impossible to know if the interrupt is actually unmasked, and
>>>>>>>> statistically it's far, far more likely that it _is_ masked.
>>>>>>> OK. Will update tdx_protected_apic_has_interrupt() in "TDX interrupts" part.
>>>>>>> And use kvm_vcpu_has_events() to replace the open code in this patch.
>>>>>> Something to keep an eye on: kvm_vcpu_has_events() returns true if pv_unhalted
>>>>>> is set, and pv_unhalted is only cleared on transitions KVM_MP_STATE_RUNNABLE.
>>>>>> If the guest initiates a spurious wakeup, pv_unhalted could be left set in
>>>>>> perpetuity.
>>>>> Oh, yes.
>>>>> KVM_HC_KICK_CPU is allowed in TDX guests.
>>> And a clever guest can send a REMRD IPI.
>>>
>>>>> The change below looks good to me.
>>>>>
>>>>> One minor issue is when guest initiates a spurious wakeup, pv_unhalted is
>>>>> left set, then later when the guest want to halt the vcpu, in
>>>>> __kvm_emulate_halt(), since pv_unhalted is still set and the state will not
>>>>> transit to KVM_MP_STATE_HALTED.
>>>>> But I guess it's guests' responsibility to not initiate spurious wakeup,
>>>>> guests need to bear the fact that HLT could fail due to a previous
>>>>> spurious wakeup?
>>>> Just found a patch set for fixing the issue.
>>> FWIW, Jim's series doesn't address spurious wakeups per se, it just ensures
>>> pv_unhalted is cleared when transitioning to RUNNING.  If the vCPU is already
>>> RUNNING, __apic_accept_irq() will set pv_unhalted and nothing will clear it
>>> until the next transition to RUNNING (which implies at least an attempted
>>> transition away from RUNNING).
>>>
>> Indeed.
>>
>> I am wondering why KVM doesn't clear pv_unhalted before the vcpu entering guest?
>> Is the additional memory access a concern or is there some other reason?
> Not clearing pv_unhalted when entering the guest is necessary to avoid races.
> Stating the obvious, the guest must set up all of its lock tracking before executing
> HLT, which means that the soon-to-be-blocking vCPU is eligible for wakeup *before*
> it executes HLT.  If an asynchronous exit happens on the vCPU at just the right
> time, KVM could clear pv_unhalted before the vCPU executes HLT.
>
Got it.
Thanks for the explanation.

