Return-Path: <kvm+bounces-54306-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E6B22B1DFFC
	for <lists+kvm@lfdr.de>; Fri,  8 Aug 2025 02:42:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A831B722F95
	for <lists+kvm@lfdr.de>; Fri,  8 Aug 2025 00:42:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89348224D7;
	Fri,  8 Aug 2025 00:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eJxo1bgi"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE120CA52;
	Fri,  8 Aug 2025 00:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754613763; cv=none; b=avtb+2Yu2pN0CYKJc6Xo7ukTBgIVMRr3doGN8209iXBo/ppQbzS3wMA6FMn8RK88SZrmvlAVfdDPNRKW1xiQmGIjgwAnJC1oFHRVsVJuTg1FHustyDMan0FZ/Lt23sNeQY3R7CFhrC3OI82zbmnZrtPzfru5GFZe7XDWPVd55XA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754613763; c=relaxed/simple;
	bh=1MvbBp80QkZN36I+UxRaDpB80kdDaaYXnX5v0pxZ4F4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=d2R9d6P7CKsxIiNLsJCOWfjmIYRNpvTIEAYDNVVkbgG9Lz5eyGq3qsQ1pPwJr/ngv5KMtIYSgggd2WeKShri/lvJqMkNvHXGPxooMTZiS0SlwtZ0YA4zF+7xslLjJd/BJV21W7ZklrtDPl6g0M+zPVecd60JRLfzY0S/uBc9dcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eJxo1bgi; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754613763; x=1786149763;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=1MvbBp80QkZN36I+UxRaDpB80kdDaaYXnX5v0pxZ4F4=;
  b=eJxo1bgia2HCCd4eAbWnV4wzOi+KgytLslKATRMmSIOXgydFVKsqnFuC
   xO1jFeD/MEQPONRxOYKjDFpng7BUFW8jjMP9hX5mNFrjcn1tb10HMA8lH
   2U7OLXmhFnjqSSHsmw/XzDhvVzuOd8kc7+1wPEyXmNrQJ6+Smm5lCO+H6
   q2hT7DSWWLnSjxoeKnSOQ91W3qrjk0QlP0gdQ56crGgV9EmaDSAZPzg1M
   l9ELepg0+wskmRlmNALlihhRbcNmOUFrtzCMQVwIg3ZxOSgXq++kT6gbU
   djnDWjLlVmn21SwP0G0r5tcZ0ErjK+qbrautaStINIVyjDskHaRaYqdcR
   A==;
X-CSE-ConnectionGUID: e6MTTjT0T3Of1VAgMiRWqw==
X-CSE-MsgGUID: ZKej627dRRK7wxvDSYDmZg==
X-IronPort-AV: E=McAfee;i="6800,10657,11514"; a="57039859"
X-IronPort-AV: E=Sophos;i="6.17,274,1747724400"; 
   d="scan'208";a="57039859"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2025 17:42:38 -0700
X-CSE-ConnectionGUID: W0QJHt5+SMa9Ja0G2H0srw==
X-CSE-MsgGUID: Kw2IR14bRs2kMtlQn0HciQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,274,1747724400"; 
   d="scan'208";a="165995299"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.240.106]) ([10.124.240.106])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2025 17:42:36 -0700
Message-ID: <ab2295fa-4c98-480c-a669-dcff3b28e447@linux.intel.com>
Date: Fri, 8 Aug 2025 08:42:33 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 17/18] KVM: x86: Push acquisition of SRCU in fastpath into
 kvm_pmu_trigger_event()
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Xin Li <xin@zytor.com>,
 Sandipan Das <sandipan.das@amd.com>
References: <20250805190526.1453366-1-seanjc@google.com>
 <20250805190526.1453366-18-seanjc@google.com>
 <e64951b0-4707-42ed-abf4-947def74ea34@linux.intel.com>
 <aJOR4Bk3DwKSVdQV@google.com>
 <515a5221-dbcd-45cc-bc55-887ae70b63db@linux.intel.com>
 <aJSqlMViOHAHHyCq@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <aJSqlMViOHAHHyCq@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


On 8/7/2025 9:31 PM, Sean Christopherson wrote:
> On Thu, Aug 07, 2025, Dapeng Mi wrote:
>> On 8/7/2025 1:33 AM, Sean Christopherson wrote:
>>> On Wed, Aug 06, 2025, Dapeng Mi wrote:
>>>> On 8/6/2025 3:05 AM, Sean Christopherson wrote:
>>>>> Acquire SRCU in the VM-Exit fastpath if and only if KVM needs to check the
>>>>> PMU event filter, to further trim the amount of code that is executed with
>>>>> SRCU protection in the fastpath.  Counter-intuitively, holding SRCU can do
>>>>> more harm than good due to masking potential bugs, and introducing a new
>>>>> SRCU-protected asset to code reachable via kvm_skip_emulated_instruction()
>>>>> would be quite notable, i.e. definitely worth auditing.
>>>>>
>>>>> E.g. the primary user of kvm->srcu is KVM's memslots, accessing memslots
>>>>> all but guarantees guest memory may be accessed, accessing guest memory
>>>>> can fault, and page faults might sleep, which isn't allowed while IRQs are
>>>>> disabled.  Not acquiring SRCU means the (hypothetical) illegal sleep would
>>>>> be flagged when running with PROVE_RCU=y, even if DEBUG_ATOMIC_SLEEP=n.
>>>>>
>>>>> Note, performance is NOT a motivating factor, as SRCU lock/unlock only
>>>>> adds ~15 cycles of latency to fastpath VM-Exits.  I.e. overhead isn't a
>>>>> concern _if_ SRCU protection needs to be extended beyond PMU events, e.g.
>>>>> to honor userspace MSR filters.
>>>>>
>>>>> Signed-off-by: Sean Christopherson <seanjc@google.com>
>>>>> ---
>>> ...
>>>
>>>>> @@ -968,12 +968,14 @@ static void kvm_pmu_trigger_event(struct kvm_vcpu *vcpu,
>>>>>  			     (unsigned long *)&pmu->global_ctrl, X86_PMC_IDX_MAX))
>>>>>  		return;
>>>>>  
>>>>> +	idx = srcu_read_lock(&vcpu->kvm->srcu);
>>>> It looks the asset what "kvm->srcu" protects here is
>>>> kvm->arch.pmu_event_filter which is only read by pmc_is_event_allowed().
>>>> Besides here, pmc_is_event_allowed() is called by reprogram_counter() but
>>>> without srcu_read_lock()/srcu_read_unlock() protection.
>>> No, reprogram_counter() is only called called in the context of KVM_RUN, i.e. with
>>> the vCPU loaded and thus with kvm->srcu already head for read (acquired by
>>> kvm_arch_vcpu_ioctl_run()).
>> Not sure if I understand correctly, but KVM_SET_PMU_EVENT_FILTER ioctl is a
>> VM-level ioctl and it can be set when vCPUs are running. So assume
>> KVM_SET_PMU_EVENT_FILTER ioctl is called at vCPU0 and vCPU1 is running
>> reprogram_counter(). Is it safe without srcu_read_lock()/srcu_read_unlock()
>> protection?
> No, but reprogram_counter() can be reached if and only if the CPU holds SRCU.
>
>   kvm_arch_vcpu_ioctl_run() => 	kvm_vcpu_srcu_read_lock(vcpu);
>   |
>   -> vcpu_run()
>      |
>      -> vcpu_enter_guest()
>         |
>         -> kvm_pmu_handle_event()
>            |
>            -> reprogram_counter()

oh, yes. I missed it. Thanks for explaining. 

Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>


>

