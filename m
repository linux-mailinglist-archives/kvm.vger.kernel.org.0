Return-Path: <kvm+bounces-32113-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E49A39D3207
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 03:08:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7951C1F2375E
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 02:08:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79E35249F9;
	Wed, 20 Nov 2024 02:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XEbGOhJ1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD65139ACC;
	Wed, 20 Nov 2024 02:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732068522; cv=none; b=rSXaV27EulIpj5k/y6Y+5qpNsT+GReofc+1IuEq4HasIppVeta/ignpXAeN1ZPGVbG42R6lisTKfv/bdCvAGaswXiOvKha7EVlq23BNJVqAZOqqRSb8E7qrDCIA5rNSdyhZZsFecHPjrqmfj0mwNWM9OI2y3eVRMNFeXzZu4VHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732068522; c=relaxed/simple;
	bh=XuYwFwLR+nHeOmFTNWXebzsAM2O0zu4UY6YsGvbY4lk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ImdQm03GZmnOLAxGWWqsaGUl0YKS4VPV/CE8oeGlhJFM3tzqFpPT8+DwCLp0b5k4wZgiyd6FGL8EAe4JMZdFAeqoDfx/XsEbXW8NfAV7Goze4LnxWPltwYWIcN3VrRJHyjw21uy5p5Ted48+7S/bSQxdKg5nsn6osqBdSEbRAa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XEbGOhJ1; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732068521; x=1763604521;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=XuYwFwLR+nHeOmFTNWXebzsAM2O0zu4UY6YsGvbY4lk=;
  b=XEbGOhJ1XWoy8A6g9YG5MkEQ5Kzi/7hpJ91e0SlFv6BsRQRAmZS/MH0/
   Dx/kuHSUxMVKV+5PNLYaHiQLWDaBpmfFs7vxWYoCC/MTDMBb+U7nbxGRR
   CwaBbqUGv1X/Pt1AAbSeQXee7yFtjjcI3wr0wi9n+XhO/vzgsDrF8vm/t
   AnkGTMynyhU0hGVuKJmSdBfBlGBPQohyHbLzCipfmXqc2sCwjA5AeAhZB
   Pn2rj0jJn0Kpp70m9GxE+P8Uj1wBwhQzzpLHFSnbhXaUo+pVrh2ndORNU
   WSoyMNq5T26WorqjVm50yt3xgmHzZZrNbwhMS0ehO3I/iDjVtiPYsCszS
   g==;
X-CSE-ConnectionGUID: wCTN0VRlQSSX4HuWAt9NJg==
X-CSE-MsgGUID: 2BnSaaSES5utvEgdNphd2Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11261"; a="43177171"
X-IronPort-AV: E=Sophos;i="6.12,168,1728975600"; 
   d="scan'208";a="43177171"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2024 18:08:40 -0800
X-CSE-ConnectionGUID: bumxxEhlSbagZYblKG4Bnw==
X-CSE-MsgGUID: Pz2PGE82TWya5IjPvnDxHg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,168,1728975600"; 
   d="scan'208";a="90580233"
Received: from unknown (HELO [10.238.2.170]) ([10.238.2.170])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2024 18:08:35 -0800
Message-ID: <bbf98681-d7d3-4156-afed-f5e65973c8ea@linux.intel.com>
Date: Wed, 20 Nov 2024 10:08:32 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 37/58] KVM: x86/pmu: Switch IA32_PERF_GLOBAL_CTRL
 at VM boundary
To: Sean Christopherson <seanjc@google.com>
Cc: Zide Chen <zide.chen@intel.com>, Mingwei Zhang <mizhang@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Xiong Zhang <xiong.y.zhang@intel.com>,
 Kan Liang <kan.liang@intel.com>, Zhenyu Wang <zhenyuw@linux.intel.com>,
 Manali Shukla <manali.shukla@amd.com>, Sandipan Das <sandipan.das@amd.com>,
 Jim Mattson <jmattson@google.com>, Stephane Eranian <eranian@google.com>,
 Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>,
 gce-passthrou-pmu-dev@google.com, Samantha Alt <samantha.alt@intel.com>,
 Zhiyuan Lv <zhiyuan.lv@intel.com>, Yanfei Xu <yanfei.xu@intel.com>,
 Like Xu <like.xu.linux@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
 Raghavendra Rao Ananta <rananta@google.com>, kvm@vger.kernel.org,
 linux-perf-users@vger.kernel.org
References: <20240801045907.4010984-1-mizhang@google.com>
 <20240801045907.4010984-38-mizhang@google.com>
 <5309ec1b-edc6-4e59-af88-b223dbf2a455@intel.com>
 <c21d02a3-4315-41f4-b873-bf28041a0d82@linux.intel.com>
 <Zzvt_fNw0U34I9bJ@google.com>
 <67013550-9739-4943-812f-4ba6f01e4fb4@linux.intel.com>
 <ZzyWKTMdNi5YjvEM@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <ZzyWKTMdNi5YjvEM@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


On 11/19/2024 9:44 PM, Sean Christopherson wrote:
> On Tue, Nov 19, 2024, Dapeng Mi wrote:
>> On 11/19/2024 9:46 AM, Sean Christopherson wrote:
>>> On Fri, Oct 25, 2024, Dapeng Mi wrote:
>>>> On 10/25/2024 4:26 AM, Chen, Zide wrote:
>>>>> On 7/31/2024 9:58 PM, Mingwei Zhang wrote:
>>>>>
>>>>>> @@ -7295,6 +7299,46 @@ static void atomic_switch_perf_msrs(struct vcpu_vmx *vmx)
>>>>>>  					msrs[i].host, false);
>>>>>>  }
>>>>>>  
>>>>>> +static void save_perf_global_ctrl_in_passthrough_pmu(struct vcpu_vmx *vmx)
>>>>>> +{
>>>>>> +	struct kvm_pmu *pmu = vcpu_to_pmu(&vmx->vcpu);
>>>>>> +	int i;
>>>>>> +
>>>>>> +	if (vm_exit_controls_get(vmx) & VM_EXIT_SAVE_IA32_PERF_GLOBAL_CTRL) {
>>>>>> +		pmu->global_ctrl = vmcs_read64(GUEST_IA32_PERF_GLOBAL_CTRL);
>>>>> As commented in patch 26, compared with MSR auto save/store area
>>>>> approach, the exec control way needs one relatively expensive VMCS read
>>>>> on every VM exit.
>>>> Anyway, let us have a evaluation and data speaks.
>>> No, drop the unconditional VMREAD and VMWRITE, one way or another.  No benchmark
>>> will notice ~50 extra cycles, but if we write poor code for every feature, those
>>> 50 cycles per feature add up.
>>>
>>> Furthermore, checking to see if the CPU supports the load/save VMCS controls at
>>> runtime beyond ridiculous.  The mediated PMU requires ***VERSION 4***; if a CPU
>>> supports PMU version 4 and doesn't support the VMCS controls, KVM should yell and
>>> disable the passthrough PMU.  The amount of complexity added here to support a
>>> CPU that should never exist is silly.
>>>
>>>>>> +static void load_perf_global_ctrl_in_passthrough_pmu(struct vcpu_vmx *vmx)
>>>>>> +{
>>>>>> +	struct kvm_pmu *pmu = vcpu_to_pmu(&vmx->vcpu);
>>>>>> +	u64 global_ctrl = pmu->global_ctrl;
>>>>>> +	int i;
>>>>>> +
>>>>>> +	if (vm_entry_controls_get(vmx) & VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL) {
>>>>>> +		vmcs_write64(GUEST_IA32_PERF_GLOBAL_CTRL, global_ctrl);
>>>>> ditto.
>>>>>
>>>>> We may optimize it by introducing a new flag pmu->global_ctrl_dirty and
>>>>> update GUEST_IA32_PERF_GLOBAL_CTRL only when it's needed.  But this
>>>>> makes the code even more complicated.
>>> I haven't looked at surrounding code too much, but I guarantee there's _zero_
>>> reason to eat a VMWRITE+VMREAD on every transition.  If, emphasis on *if*, KVM
>>> accesses PERF_GLOBAL_CTRL frequently, e.g. on most exits, then add a VCPU_EXREG_XXX
>>> and let KVM's caching infrastructure do the heavy lifting.  Don't reinvent the
>>> wheel.  But first, convince the world that KVM actually accesses the MSR somewhat
>>> frequently.
>> Sean, let me give more background here.
>>
>> VMX supports two ways to save/restore PERF_GLOBAL_CTRL MSR, one is to
>> leverage VMCS_EXIT_CTRL/VMCS_ENTRY_CTRL to save/restore guest
>> PERF_GLOBAL_CTRL value to/from VMCS guest state. The other is to use the
>> VMCS MSR auto-load/restore bitmap to save/restore guest PERF_GLOBAL_CTRL. 
> I know.
>
>> Currently we prefer to use the former way to save/restore guest
>> PERF_GLOBAL_CTRL as long as HW supports it. There is a limitation on the
>> MSR auto-load/restore feature. When there are multiple MSRs, the MSRs are
>> saved/restored in the order of MSR index. As the suggestion of SDM,
>> PERF_GLOBAL_CTRL should always be written at last after all other PMU MSRs
>> are manipulated. So if there are some PMU MSRs whose index is larger than
>> PERF_GLOBAL_CTRL (It would be true in archPerfmon v6+, all PMU MSRs in the
>> new MSR range have larger index than PERF_GLOBAL_CTRL),
> No, the entries in the load/store lists are processed in sequential order as they
> appear in the lists.  Ordering them based on their MSR index would be insane and
> would make the lists useless.
>
>   VM entries may load MSRs from the VM-entry MSR-load area (see Section 25.8.2).
>   Specifically each entry in that area (up to the number specified in the VM-entry
>   MSR-load count) is processed in order by loading the MSR indexed by bits 31:0
>   with the contents of bits 127:64 as they would be written by WRMSR.1

Thanks, just look at the SDM again. It seems I misunderstood the words. :(


>
>> these PMU MSRs would be restored after PERF_GLOBAL_CTRL. That would break the
>> rule. Of course, it's good to save/restore PERF_GLOBAL_CTRL right now with
>> the VMCS VMCS MSR auto-load/restore bitmap feature since only one PMU MSR
>> PERF_GLOBAL_CTRL is saved/restored in current implementation.
> No, it's never good to use the load/store lists.  They're slow as mud, because
> they're essentially just wrappers to the standard WRMSR/RDMSR ucode.  Whereas
> dedicated VMCS fields have dedicated, streamlined ucode to make loads and stores
> as fast as possible.
>
> I haven't measured PERF_GLOBAL_CTRL specifically, at least not in recent memory,
> but generally speaking using a load/store entry is 100+ cycles, whereas using a
> dedicated VMCS field is <20 cyles (often far less).
>
> So what I am saying is that the mediated PMU should _require_ support for loading
> and saving PERF_GLOBAL_CTRL via dedicated fields, and WARN if a CPU with a v4+
> PMU doesn't support said fields.  E.g.
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index a4b2b0b69a68..cab8305e7bf0 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -8620,6 +8620,15 @@ __init int vmx_hardware_setup(void)
>                 enable_sgx = false;
>  #endif
>  
> +       /*
> +        * All CPUs that support a mediated PMU are expected to support loading
> +        * and saving PERF_GLOBAL_CTRL via dedicated VMCS fields.
> +        */
> +       if (enable_passthrough_pmu &&
> +           (WARN_ON_ONCE(!cpu_has_load_perf_global_ctrl() ||
> +                         !cpu_has_save_perf_global_ctrl())))
> +               enable_passthrough_pmu = false;
> +
>         /*
>          * set_apic_access_page_addr() is used to reload apic access
>          * page upon invalidation.  No need to do anything if not
>
> That will provide better, more consistent performance, and will eliminate a big
> pile of non-trivial code.

Sure. When the mediated vPMU is proposed at the beginning, we considered to
support all kinds of HWs including some old may not broadly used HWs
nowadays, so we have to consider all kinds of corner cases. But think
twice, it may not be worthy...


>
>> PERF_GLOBAL_CTRL MSR could be frequently accessed by perf/pmu driver, e.g.
>> on each task switch, so PERF_GLOBAL_CTRL MSR is configured to passthrough
>> to reduce the performance impact in mediated vPMU proposal if guest own all
>> PMU HW resource. But if guest only owns part of PMU HW resource,
>> PERF_GLOBAL_CTRL would be set to interception mode.
> Again, I know.  What I am saying is that propagating PERF_GLOBAL_CTRL to/from the
> VMCS on every entry and exit is extremely wasteful and completely unnecessary.

Yes, I understood your meaning.  For passthough mode, KVM should not need
to access the guest PERF_GLOBAL_CTRL value. For interception mode, KVM
would maintain an emulated guest PERF_GLOBAL_CTRL value and don't need to
read/write it from/to VMCS guest fields.

Anyway, it looks these two helpers are useless, it can be removed.

>
>> I suppose KVM doesn't need access PERF_GLOBAL_CTRL in passthrough mode.
>> This piece of code is intently just for PERF_GLOBAL_CTRL interception mode,
> No, it's even more useless if PERF_GLOBAL_CTRL is intercepted, because in that
> case the _only_ time KVM needs move the guest's value to/from the VMCS is when
> the guest (or host userspace) is explicitly accessing the field.
>
>> but think twice it looks unnecessary to save/restore PERF_GLOBAL_CTRL via
>> VMCS as KVM would always maintain the guest PERF_GLOBAL_CTRL value? Anyway,
>> this part of code can be optimized.

