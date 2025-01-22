Return-Path: <kvm+bounces-36218-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CEB5AA18B34
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 06:08:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0E28C166306
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 05:08:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90A7E188CCA;
	Wed, 22 Jan 2025 05:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bZjX2Taz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D5A3145FE0;
	Wed, 22 Jan 2025 05:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737522516; cv=none; b=YDiaKKErl9skA5T1eJWm4f63YJ3CMU3k52DAhFdES+74qkQfrslKRqyPNVrf5TwK2vyhpkkDw7WGyL4TYTJhw36lBFVQ+oZ+4Fhx1BE2xZZdFQnhgD578EQl7aTgle8725PMXf5ivp2hUBWIt4OBuvdiq+JZ/dZs2Cf5vusv1Rs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737522516; c=relaxed/simple;
	bh=zMsul23VuCdpDLVPnhS8Nasg4luqlhoePf4ElINy+5M=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=fyuneJve01ksp7el7l8ugkaXaV0tpzjSAzzlUYA1crj7bv+n70UtjLn1uldVPwQ9bo7KkaWyVMrgzXLUeAirc/JaB+ZZyyY1mfhgQhfgl1yLcIr/ljR4OlHGhLyYGL0bJlcgin8KYCJRpKlfbgfXtlI8jVxGCKkbokbhZlpi8WQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bZjX2Taz; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737522515; x=1769058515;
  h=message-id:date:mime-version:subject:from:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=zMsul23VuCdpDLVPnhS8Nasg4luqlhoePf4ElINy+5M=;
  b=bZjX2TazgGsWBwbhrDYBBlEUuivYMWGEKr5/8Ip7AxSJQJ/vxm0wxEv2
   q28xT/0l4MIY3fb8eSri1lkK0NOfw1yjxrh91u659qkCC7411g6cxzzJ4
   UNtMlQtk1fGbkkzNsCce/iEVFwR0YO/1M8SEWz6un+dUdXXzKSHnUaVrq
   AQKz74EbhcVXs+ZkecQIoOSJfnG3dR0RVNtBsRasqn4ZyONgpejZmMQOm
   nTEC95p28/BOTkNAYOzbxTo58KizDpr3B+pY9SsW+iBB6mYRtOOeCX74G
   UlYsUydLsCE5HinHZrC6I0W5uoZH/6jRnc/2hH5w2mgh9Nc3MzgQeefGo
   w==;
X-CSE-ConnectionGUID: ETRGij8bQMKYfuWZdyy/+w==
X-CSE-MsgGUID: yBWuL/7UQDi02HGBZGd6CA==
X-IronPort-AV: E=McAfee;i="6700,10204,11322"; a="41638005"
X-IronPort-AV: E=Sophos;i="6.13,224,1732608000"; 
   d="scan'208";a="41638005"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2025 21:08:34 -0800
X-CSE-ConnectionGUID: l+6Yo118Rz6ZxIua9ztKhg==
X-CSE-MsgGUID: /xqAF0GYT4SYLOxlGmAw4w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="107915784"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.245.128]) ([10.124.245.128])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2025 21:08:29 -0800
Message-ID: <dd10217a-51d3-4761-8ee1-59accc542305@linux.intel.com>
Date: Wed, 22 Jan 2025 13:08:26 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 23/58] KVM: x86/pmu: Allow RDPMC pass through when
 all counters exposed to guest
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
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
 <6b073828-394d-4309-a234-25ab3eeea91c@linux.intel.com>
Content-Language: en-US
In-Reply-To: <6b073828-394d-4309-a234-25ab3eeea91c@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 11/20/2024 1:31 PM, Mi, Dapeng wrote:
> On 11/20/2024 12:32 AM, Sean Christopherson wrote:
>> On Thu, Aug 01, 2024, Mingwei Zhang wrote:
>>> Clear RDPMC_EXITING in vmcs when all counters on the host side are exposed
>>> to guest VM. This gives performance to passthrough PMU. However, when guest
>>> does not get all counters, intercept RDPMC to prevent access to unexposed
>>> counters. Make decision in vmx_vcpu_after_set_cpuid() when guest enables
>>> PMU and passthrough PMU is enabled.
>>>
>>> Co-developed-by: Xiong Zhang <xiong.y.zhang@linux.intel.com>
>>> Signed-off-by: Xiong Zhang <xiong.y.zhang@linux.intel.com>
>>> Signed-off-by: Mingwei Zhang <mizhang@google.com>
>>> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
>>> Tested-by: Yongwei Ma <yongwei.ma@intel.com>
>>> ---
>>>  arch/x86/kvm/pmu.c     | 16 ++++++++++++++++
>>>  arch/x86/kvm/pmu.h     |  1 +
>>>  arch/x86/kvm/vmx/vmx.c |  5 +++++
>>>  3 files changed, 22 insertions(+)
>>>
>>> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
>>> index e656f72fdace..19104e16a986 100644
>>> --- a/arch/x86/kvm/pmu.c
>>> +++ b/arch/x86/kvm/pmu.c
>>> @@ -96,6 +96,22 @@ void kvm_pmu_ops_update(const struct kvm_pmu_ops *pmu_ops)
>>>  #undef __KVM_X86_PMU_OP
>>>  }
>>>  
>>> +bool kvm_pmu_check_rdpmc_passthrough(struct kvm_vcpu *vcpu)
>> As suggested earlier, kvm_rdpmc_in_guest().
> Sure.
>
>
>>> +{
>>> +	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
>>> +
>>> +	if (is_passthrough_pmu_enabled(vcpu) &&
>>> +	    !enable_vmware_backdoor &&
>> Please add a comment about the VMware backdoor, I doubt most folks know about
>> VMware's tweaks to RDPMC behavior.  It's somewhat obvious from the code and
>> comment in check_rdpmc(), but I think it's worth calling out here too.
> Sure.
>
>
>>> +	    pmu->nr_arch_gp_counters == kvm_pmu_cap.num_counters_gp &&
>>> +	    pmu->nr_arch_fixed_counters == kvm_pmu_cap.num_counters_fixed &&
>>> +	    pmu->counter_bitmask[KVM_PMC_GP] == (((u64)1 << kvm_pmu_cap.bit_width_gp) - 1) &&
>>> +	    pmu->counter_bitmask[KVM_PMC_FIXED] == (((u64)1 << kvm_pmu_cap.bit_width_fixed)  - 1))
>> BIT_ULL?  GENMASK_ULL?
> Sure.
>
>
>>> +		return true;
>>> +
>>> +	return false;
>> Do this:
>>
>>
>> 	return <true>;
>>
>> not:
>>
>> 	if (<true>)
>> 		return true;
>>
>> 	return false;
>>
>> Short-circuiting on certain cases is fine, and I would probably vote for that so
>> it's easier to add comments, but that's obviously not what's done here.  E.g. either
>>
>> 	if (!enable_mediated_pmu)
>> 		return false;
>>
>> 	/* comment goes here */
>> 	if (enable_vmware_backdoor)
>> 		return false;
>>
>> 	return <counters checks>;
>>
>> or
>>
>> 	return <massive combined check>;
> Nice suggestion. Thanks.
>
>
>>> +}
>>> +EXPORT_SYMBOL_GPL(kvm_pmu_check_rdpmc_passthrough);
>> Maybe just make this an inline in a header?  enable_vmware_backdoor is exported,
>> and presumably enable_mediated_pmu will be too.
> Sure.
>
>
>>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>>> index 4d60a8cf2dd1..339742350b7a 100644
>>> --- a/arch/x86/kvm/vmx/vmx.c
>>> +++ b/arch/x86/kvm/vmx/vmx.c
>>> @@ -7911,6 +7911,11 @@ void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>>>  		vmx->msr_ia32_feature_control_valid_bits &=
>>>  			~FEAT_CTL_SGX_LC_ENABLED;
>>>  
>>> +	if (kvm_pmu_check_rdpmc_passthrough(&vmx->vcpu))
>> No need to follow vmx->vcpu, @vcpu is readily available.
> Yes.
>
>
>>> +		exec_controls_clearbit(vmx, CPU_BASED_RDPMC_EXITING);
>>> +	else
>>> +		exec_controls_setbit(vmx, CPU_BASED_RDPMC_EXITING);
>> I wonder if it makes sense to add a helper to change a bit.  IIRC, the only reason
>> I didn't add one along with the set/clear helpers was because there weren't many
>> users and I couldn't think of good alternative to "set".
>>
>> I still don't have a good name, but I think we're reaching the point where it's
>> worth forcing the issue to avoid common goofs, e.g. handling only the "clear"
>> case and no the "set" case.
>>
>> Maybe changebit?  E.g.
>>
>> static __always_inline void lname##_controls_changebit(struct vcpu_vmx *vmx, u##bits val,	\
>> 						       bool set)				\
>> {												\
>> 	if (set)										\
>> 		lname##_controls_setbit(vmx, val);						\
>> 	else											\
>> 		lname##_controls_clearbit(vmx, val);						\
>> }
>>
>>
>> and then vmx_refresh_apicv_exec_ctrl() can be:
>>
>> 	secondary_exec_controls_changebit(vmx,
>> 					  SECONDARY_EXEC_APIC_REGISTER_VIRT |
>> 					  SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY,
>> 					  kvm_vcpu_apicv_active(vcpu));
>> 	tertiary_exec_controls_changebit(vmx, TERTIARY_EXEC_IPI_VIRT,
>> 					 kvm_vcpu_apicv_active(vcpu) && enable_ipiv);
>>
>> and this can be:
>>
>> 	exec_controls_changebit(vmx, CPU_BASED_RDPMC_EXITING,
>> 				!kvm_rdpmc_in_guest(vcpu));
> Sure. would add a separate patch to add these helpers.

Hi Sean,

The upcoming v4 patches would include some code which you suggest in the
comments, like this one. I would like add a co-developed-by and
corresponding SoB tags for you in the patch if the patch includes you
suggested code. Is it ok? Or you more prefer the "suggested-by" tag? Thanks.


>
>
>

