Return-Path: <kvm+bounces-11096-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A719872CCD
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 03:33:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DDEE8B22A64
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 02:33:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7DE4D51D;
	Wed,  6 Mar 2024 02:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mSuSfBfO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1487117E9;
	Wed,  6 Mar 2024 02:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709692370; cv=none; b=XOpqtK4Kqf3NyDPYcBueUPW7JDv414EtzSF0DMx2jT+cDcSE8onn1IVgKf4+gnMTWVHkItnudmyGspPp/m7fsk+EffJ8KsAtEEnXgjQyHk0fTxEY2aG6ziemMcEnoTzE6ymhhuW72iChkFdoonxo0Bbd5p1UOgEs395pmDbyVXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709692370; c=relaxed/simple;
	bh=aIGfNej6zLoTMAs10B0Xo/VB2CyyZGbqbt8RV9b3g5U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=A80myY/uEcM5ZzsWNB1/lbQceQ2NYtCuPhlRE2O7ZH36ziyAIjiGbfynCbONNnzDvLQj4esR2jG0QQi3gKbT5Wy7dZUdvRla8hiw4FqcFcNaVqUgkNkot3GujUgv03ip0K4EgOrntlvICSvoYL91umjA0uKgcmxlQdoZlvD/Qus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mSuSfBfO; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709692369; x=1741228369;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=aIGfNej6zLoTMAs10B0Xo/VB2CyyZGbqbt8RV9b3g5U=;
  b=mSuSfBfOVUNhIZCB1nAOq/Fq8ZGUHNBEYAbHmRNsWe9n2iaBRo/mqypb
   9lSTimV25CsGkka1zqTXKLOlqMjXFAtnPwJ7N9cCJOzgIbot7bah0nEXz
   z6AAgeoArvsr2hYsXJHt2tWP2zsaooLAaDZhiUb1vmHu5ekogWBHCrEbO
   y0698bj0V5b6rm39gfMJLAkSudqp14QvW32BJolg9vu2yH4mtIcIqrUuE
   7paE0xirq7G8xmKKPIUePD1GlI7UBW5h4rlYuC21/ZRnS2nXGbSwOkJ8p
   uH0rQtgrDUtL3/6zPTEWxGm2EJbT8H3bnBoiDiWqucqTRQzqRvE9/LD4Z
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11004"; a="8103554"
X-IronPort-AV: E=Sophos;i="6.06,207,1705392000"; 
   d="scan'208";a="8103554"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2024 18:32:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,207,1705392000"; 
   d="scan'208";a="10015749"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.239.60]) ([10.124.239.60])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2024 18:32:45 -0800
Message-ID: <9f7f5e0b-de05-49f1-941f-29349d1b9280@linux.intel.com>
Date: Wed, 6 Mar 2024 10:32:41 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: x86/svm/pmu: Set PerfMonV2 global control bits
 correctly
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>, Like Xu <like.xu.linux@gmail.com>
Cc: Sandipan Das <sandipan.das@amd.com>, pbonzini@redhat.com,
 mizhang@google.com, jmattson@google.com, ravi.bangoria@amd.com,
 nikunj.dadhania@amd.com, santosh.shukla@amd.com, manali.shukla@amd.com,
 babu.moger@amd.com, kvm list <kvm@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20240301075007.644152-1-sandipan.das@amd.com>
 <06061a28-88c0-404b-98a6-83cc6cc8c796@gmail.com>
 <cc8699be-3aae-42aa-9c70-f8b6a9728ee3@amd.com>
 <f5bbe9ac-ca35-4c3e-8cd7-249839fbb8b8@linux.intel.com>
 <ZeYlEGORqeTPLK2_@google.com>
 <8a846ba5-d346-422e-817b-e00ab9701f19@gmail.com>
 <ZedUwKWW7PNkvUH1@google.com> <ZedepdnKSl6oFNUq@google.com>
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <ZedepdnKSl6oFNUq@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 3/6/2024 2:04 AM, Sean Christopherson wrote:
> On Tue, Mar 05, 2024, Sean Christopherson wrote:
>> On Tue, Mar 05, 2024, Like Xu wrote:
>> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
>> index 87cc6c8809ad..f61ce26aeb90 100644
>> --- a/arch/x86/kvm/pmu.c
>> +++ b/arch/x86/kvm/pmu.c
>> @@ -741,6 +741,8 @@ static void kvm_pmu_reset(struct kvm_vcpu *vcpu)
>>    */
>>   void kvm_pmu_refresh(struct kvm_vcpu *vcpu)
>>   {
>> +	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
>> +
>>   	if (KVM_BUG_ON(kvm_vcpu_has_run(vcpu), vcpu->kvm))
>>   		return;
>>   
>> @@ -750,8 +752,18 @@ void kvm_pmu_refresh(struct kvm_vcpu *vcpu)
>>   	 */
>>   	kvm_pmu_reset(vcpu);
>>   
>> -	bitmap_zero(vcpu_to_pmu(vcpu)->all_valid_pmc_idx, X86_PMC_IDX_MAX);
>> +	bitmap_zero(pmu->all_valid_pmc_idx, X86_PMC_IDX_MAX);
>>   	static_call(kvm_x86_pmu_refresh)(vcpu);
>> +
>> +	/*
>> +	 * At RESET, both Intel and AMD CPUs set all enable bits for general
>> +	 * purpose counters in IA32_PERF_GLOBAL_CTRL (so that software that
>> +	 * was written for v1 PMUs don't unknowingly leave GP counters disabled
>> +	 * in the global controls).  Emulate that behavior when refreshing the
>> +	 * PMU so that userspace doesn't need to manually set PERF_GLOBAL_CTRL.
>> +	 */
>> +	if (kvm_pmu_has_perf_global_ctrl(pmu))
>> +		pmu->global_ctrl = GENMASK_ULL(pmu->nr_arch_gp_counters - 1, 0);
>>   }
> Doh, this is based on kvm/kvm-uapi, I'll rebase to kvm-x86/next before posting.
>
> I'll also update the changelog to call out that KVM has always clobbered global_ctrl
> during PMU refresh, i.e. there is no danger of breaking existing setups by
> clobbering a value set by userspace, e.g. during live migration.
>
> Lastly, I'll also update the changelog to call out that KVM *did* actually set
> the general purpose counter enable bits in global_ctrl at "RESET" until v6.0,
> and that KVM intentionally removed that behavior because of what appears to be
> an Intel SDM bug.
>
> Of course, in typical KVM fashion, that old code was also broken in its own way
> (the history of this code is a comedy of errors).  Initial vPMU support in commit
> f5132b01386b ("KVM: Expose a version 2 architectural PMU to a guests") *almost*
> got it right, but for some reason only set the bits if the guest PMU was
> advertised as v1:
>
>          if (pmu->version == 1) {
>                  pmu->global_ctrl = (1 << pmu->nr_arch_gp_counters) - 1;
>                  return;
>          }
>
>
> Commit f19a0c2c2e6a ("KVM: PMU emulation: GLOBAL_CTRL MSR should be enabled on
> reset") then tried to remedy that goof, but botched things and also enabled the
> fixed counters:
>
>          pmu->global_ctrl = ((1 << pmu->nr_arch_gp_counters) - 1) |
>                  (((1ull << pmu->nr_arch_fixed_counters) - 1) << X86_PMC_IDX_FIXED);
>          pmu->global_ctrl_mask = ~pmu->global_ctrl;
>
> Which was KVM's behavior up until commit c49467a45fe0 ("KVM: x86/pmu: Don't overwrite
> the pmu->global_ctrl when refreshing") incorrectly removed *everything*.  Very
> ironically, that commit came from Like.
>
> Author: Like Xu <likexu@tencent.com>
> Date:   Tue May 10 12:44:07 2022 +0800
>
>      KVM: x86/pmu: Don't overwrite the pmu->global_ctrl when refreshing
>      
>      Assigning a value to pmu->global_ctrl just to set the value of
>      pmu->global_ctrl_mask is more readable but does not conform to the
>      specification. The value is reset to zero on Power up and Reset but
>      stays unchanged on INIT, like most other MSRs.
>
> But wait, it gets even better.  Like wasn't making up that behavior, Intel's SDM
> circa December 2022 states that "Global Perf Counter Controls" is '0' at Power-Up
> and RESET.  But then the March 2023 SDM rolls out and says
>
>    IA32_PERF_GLOBAL_CTRL: Sets bits n-1:0 and clears the upper bits.
>
> So presumably someone at Intel noticed that what their CPUs do and what the
> documentation says didn't match.

It's a really long story... thanks for figuring it out.

>
> *sigh*
>

