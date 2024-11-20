Return-Path: <kvm+bounces-32123-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ADC299D3324
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 06:31:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F3988B23E8D
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 05:31:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C523A156C52;
	Wed, 20 Nov 2024 05:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ilBUdccM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D114749A;
	Wed, 20 Nov 2024 05:31:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732080682; cv=none; b=iP2h+qsvptR+gyTHRh17u+b3edv+K0YlYGTqAXSIO2vAbHqEvgNpWwx7RqKbMRFivrQ8pI8mtKOtp4aRiiGeaCxpyu10PW4XpLUTXvjisc1KZhHX3iOefl21wYIkMB4Fmt6W2ocpKn7xR/tkKPDGQSeSJ8hzxmIi3aJwGY6nn1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732080682; c=relaxed/simple;
	bh=XaqcvNUuTb5oy01LGhAyWR3ncPuNQkHEAQzCygt4fBM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fED+5PTr4963HRhRYBZTPe6X7owKul/Vc6zFWWw/XUentrRaYFcHbHQOR9IVOR5UYB2W0SrYKtrJAE2E2NjtB9qh1gwgPxHYikzRd5cWLsKGd8qSCbmB3qjqFNTJv5oI7xUnBxnDTeiGNvfDqoqr6SmilZPAu9c2tTuvE8m3thc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ilBUdccM; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732080680; x=1763616680;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=XaqcvNUuTb5oy01LGhAyWR3ncPuNQkHEAQzCygt4fBM=;
  b=ilBUdccMa5m0K1fpzw4aPo9c7zK4dQoipT8sP0mNkuS/bL55tI/KaHyw
   PRstjRjwivl3hZF+uEIqbv6fKPWHm/y9CE3ySdI6NdOFDHxfq4i6lj+gS
   58y3GG5ElT/xiYzwHLE9UkDTAxmfdjsmmby9q7k425/beQ1wAxpHd4Gou
   F20Lty4JX3peMSEZMItuZYWVBooPb3gfF1FAA9mm3Kr7dtA8kwwJqRPxm
   bZRGZEATYlTDD7HCuB3TXTJeW2As/ZlRgKppHJW0YX6HdwT678cuUDLKG
   0BcMgH9qJAPxcEMkyglkXXj8eJ0ef/QGBR4N6FXVOGPXxxtVD2M+PZMoE
   w==;
X-CSE-ConnectionGUID: PTZel30DSV25GAwo3ewjJw==
X-CSE-MsgGUID: hEF/TbcbSjqU8CW2aDtKpA==
X-IronPort-AV: E=McAfee;i="6700,10204,11261"; a="32178814"
X-IronPort-AV: E=Sophos;i="6.12,168,1728975600"; 
   d="scan'208";a="32178814"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2024 21:31:19 -0800
X-CSE-ConnectionGUID: bFQ6YWHGRQa3IHB8nqsjxQ==
X-CSE-MsgGUID: HkD3QixKRROnqCLS5v1haw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,168,1728975600"; 
   d="scan'208";a="89948733"
Received: from unknown (HELO [10.238.2.170]) ([10.238.2.170])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2024 21:31:14 -0800
Message-ID: <6b073828-394d-4309-a234-25ab3eeea91c@linux.intel.com>
Date: Wed, 20 Nov 2024 13:31:11 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 23/58] KVM: x86/pmu: Allow RDPMC pass through when
 all counters exposed to guest
To: Sean Christopherson <seanjc@google.com>,
 Mingwei Zhang <mizhang@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Xiong Zhang
 <xiong.y.zhang@intel.com>, Kan Liang <kan.liang@intel.com>,
 Zhenyu Wang <zhenyuw@linux.intel.com>, Manali Shukla
 <manali.shukla@amd.com>, Sandipan Das <sandipan.das@amd.com>,
 Jim Mattson <jmattson@google.com>, Stephane Eranian <eranian@google.com>,
 Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>,
 gce-passthrou-pmu-dev@google.com, Samantha Alt <samantha.alt@intel.com>,
 Zhiyuan Lv <zhiyuan.lv@intel.com>, Yanfei Xu <yanfei.xu@intel.com>,
 Like Xu <like.xu.linux@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
 Raghavendra Rao Ananta <rananta@google.com>, kvm@vger.kernel.org,
 linux-perf-users@vger.kernel.org
References: <20240801045907.4010984-1-mizhang@google.com>
 <20240801045907.4010984-24-mizhang@google.com> <Zzy9gz9boGIzZlsQ@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <Zzy9gz9boGIzZlsQ@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 11/20/2024 12:32 AM, Sean Christopherson wrote:
> On Thu, Aug 01, 2024, Mingwei Zhang wrote:
>> Clear RDPMC_EXITING in vmcs when all counters on the host side are exposed
>> to guest VM. This gives performance to passthrough PMU. However, when guest
>> does not get all counters, intercept RDPMC to prevent access to unexposed
>> counters. Make decision in vmx_vcpu_after_set_cpuid() when guest enables
>> PMU and passthrough PMU is enabled.
>>
>> Co-developed-by: Xiong Zhang <xiong.y.zhang@linux.intel.com>
>> Signed-off-by: Xiong Zhang <xiong.y.zhang@linux.intel.com>
>> Signed-off-by: Mingwei Zhang <mizhang@google.com>
>> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
>> Tested-by: Yongwei Ma <yongwei.ma@intel.com>
>> ---
>>  arch/x86/kvm/pmu.c     | 16 ++++++++++++++++
>>  arch/x86/kvm/pmu.h     |  1 +
>>  arch/x86/kvm/vmx/vmx.c |  5 +++++
>>  3 files changed, 22 insertions(+)
>>
>> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
>> index e656f72fdace..19104e16a986 100644
>> --- a/arch/x86/kvm/pmu.c
>> +++ b/arch/x86/kvm/pmu.c
>> @@ -96,6 +96,22 @@ void kvm_pmu_ops_update(const struct kvm_pmu_ops *pmu_ops)
>>  #undef __KVM_X86_PMU_OP
>>  }
>>  
>> +bool kvm_pmu_check_rdpmc_passthrough(struct kvm_vcpu *vcpu)
> As suggested earlier, kvm_rdpmc_in_guest().

Sure.


>
>> +{
>> +	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
>> +
>> +	if (is_passthrough_pmu_enabled(vcpu) &&
>> +	    !enable_vmware_backdoor &&
> Please add a comment about the VMware backdoor, I doubt most folks know about
> VMware's tweaks to RDPMC behavior.  It's somewhat obvious from the code and
> comment in check_rdpmc(), but I think it's worth calling out here too.

Sure.


>
>> +	    pmu->nr_arch_gp_counters == kvm_pmu_cap.num_counters_gp &&
>> +	    pmu->nr_arch_fixed_counters == kvm_pmu_cap.num_counters_fixed &&
>> +	    pmu->counter_bitmask[KVM_PMC_GP] == (((u64)1 << kvm_pmu_cap.bit_width_gp) - 1) &&
>> +	    pmu->counter_bitmask[KVM_PMC_FIXED] == (((u64)1 << kvm_pmu_cap.bit_width_fixed)  - 1))
> BIT_ULL?  GENMASK_ULL?

Sure.


>
>> +		return true;
>> +
>> +	return false;
> Do this:
>
>
> 	return <true>;
>
> not:
>
> 	if (<true>)
> 		return true;
>
> 	return false;
>
> Short-circuiting on certain cases is fine, and I would probably vote for that so
> it's easier to add comments, but that's obviously not what's done here.  E.g. either
>
> 	if (!enable_mediated_pmu)
> 		return false;
>
> 	/* comment goes here */
> 	if (enable_vmware_backdoor)
> 		return false;
>
> 	return <counters checks>;
>
> or
>
> 	return <massive combined check>;

Nice suggestion. Thanks.


>
>> +}
>> +EXPORT_SYMBOL_GPL(kvm_pmu_check_rdpmc_passthrough);
> Maybe just make this an inline in a header?  enable_vmware_backdoor is exported,
> and presumably enable_mediated_pmu will be too.

Sure.


>
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index 4d60a8cf2dd1..339742350b7a 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -7911,6 +7911,11 @@ void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>>  		vmx->msr_ia32_feature_control_valid_bits &=
>>  			~FEAT_CTL_SGX_LC_ENABLED;
>>  
>> +	if (kvm_pmu_check_rdpmc_passthrough(&vmx->vcpu))
> No need to follow vmx->vcpu, @vcpu is readily available.

Yes.


>
>> +		exec_controls_clearbit(vmx, CPU_BASED_RDPMC_EXITING);
>> +	else
>> +		exec_controls_setbit(vmx, CPU_BASED_RDPMC_EXITING);
> I wonder if it makes sense to add a helper to change a bit.  IIRC, the only reason
> I didn't add one along with the set/clear helpers was because there weren't many
> users and I couldn't think of good alternative to "set".
>
> I still don't have a good name, but I think we're reaching the point where it's
> worth forcing the issue to avoid common goofs, e.g. handling only the "clear"
> case and no the "set" case.
>
> Maybe changebit?  E.g.
>
> static __always_inline void lname##_controls_changebit(struct vcpu_vmx *vmx, u##bits val,	\
> 						       bool set)				\
> {												\
> 	if (set)										\
> 		lname##_controls_setbit(vmx, val);						\
> 	else											\
> 		lname##_controls_clearbit(vmx, val);						\
> }
>
>
> and then vmx_refresh_apicv_exec_ctrl() can be:
>
> 	secondary_exec_controls_changebit(vmx,
> 					  SECONDARY_EXEC_APIC_REGISTER_VIRT |
> 					  SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY,
> 					  kvm_vcpu_apicv_active(vcpu));
> 	tertiary_exec_controls_changebit(vmx, TERTIARY_EXEC_IPI_VIRT,
> 					 kvm_vcpu_apicv_active(vcpu) && enable_ipiv);
>
> and this can be:
>
> 	exec_controls_changebit(vmx, CPU_BASED_RDPMC_EXITING,
> 				!kvm_rdpmc_in_guest(vcpu));

Sure. would add a separate patch to add these helpers.



