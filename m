Return-Path: <kvm+bounces-67254-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 434FACFF4CB
	for <lists+kvm@lfdr.de>; Wed, 07 Jan 2026 19:09:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 3D2F53002B91
	for <lists+kvm@lfdr.de>; Wed,  7 Jan 2026 18:09:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C353323FC5A;
	Wed,  7 Jan 2026 18:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XBvUvCVn"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5AF93A0B0A
	for <kvm@vger.kernel.org>; Wed,  7 Jan 2026 18:09:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767809377; cv=none; b=UtkzmuxuM6EezgyFJevnqHaiFyp9LfIjJq9M5KPFY+AvGP1Xyp1TJJdopHplwv9NZKRlCc6SxHx8ZnXP5U51IWobV2stCMPK/lC/K3iKqUg6d/q2UpQiXAV+cuQoj44sFLti83vFGcoF/gNVO6+ucZ3k2Iu7BtP217UZ1PE+iis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767809377; c=relaxed/simple;
	bh=Te+EVbCr+LtmUhn8fT5sGp91OOQeOi2uLfD+WI4BDak=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KbgRsqH6hXRAYJu+lXiOnia+XG86yfrPssUkc+Sgh4Y/tWRJYKofQ9FiQeZO2ROZ3QDak2d76DumVxI+fv/8e7J14JrEzntS3ktNOxhqfJg+knfnB9WY4HcM3jDfa7m+ow5YD8zF/172ChPRu/H4Um2GNy8UglKKvIHEwOpFP0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XBvUvCVn; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767809375; x=1799345375;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Te+EVbCr+LtmUhn8fT5sGp91OOQeOi2uLfD+WI4BDak=;
  b=XBvUvCVnHLwWEYVjl4C/KP3Ibu9SuUkgSl50rhIoZrnn2D0KxO5TNFTR
   QqEqCnV0VHAmbb/sypEmrEpwNuUKh9fqzTAlqtQfZ0jogIwBfB53uS/uY
   quhGlhEAQXnEo4FfCO/3JMcrka6io6vcEkeVIXbaIyPzB4K+CZxAATzb8
   /nK0jaO+nZHNz/lXYklZ2tuJg6xkWAIlezRALh10SQqjg4/9ck85FfBp8
   2YSlh+MInrHWMOjdwEpv2S92TKTPsnMQkqrfZc5Da7qMmlHjiDrhuqkBI
   5YMsaO0q+3EzCuZJfL04O/Nfaa6xSOfr371+URvPCbDneGwzqh8Br5Cu2
   g==;
X-CSE-ConnectionGUID: KN2EDHO8SPaBfXcXHEwmTA==
X-CSE-MsgGUID: 2XW24mS0QK2XKMDem3nn/w==
X-IronPort-AV: E=McAfee;i="6800,10657,11664"; a="68921542"
X-IronPort-AV: E=Sophos;i="6.21,208,1763452800"; 
   d="scan'208";a="68921542"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2026 10:09:34 -0800
X-CSE-ConnectionGUID: 57jk7SQlSkSo2JrKS2KCUw==
X-CSE-MsgGUID: 0Kx3BIrcSpmW6t9WqENhKw==
X-ExtLoop1: 1
Received: from unknown (HELO [10.241.241.128]) ([10.241.241.128])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2026 10:09:33 -0800
Message-ID: <25077c70-127c-4bf9-893d-470ab5216f84@intel.com>
Date: Wed, 7 Jan 2026 10:09:32 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 4/7] target/i386/kvm: query kvm.enable_pmu parameter
To: Dongli Zhang <dongli.zhang@oracle.com>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org
Cc: pbonzini@redhat.com, zhao1.liu@intel.com, mtosatti@redhat.com,
 sandipan.das@amd.com, babu.moger@amd.com, likexu@tencent.com,
 like.xu.linux@gmail.com, groug@kaod.org, khorenko@virtuozzo.com,
 alexander.ivanov@virtuozzo.com, den@virtuozzo.com,
 davydov-max@yandex-team.ru, xiaoyao.li@intel.com,
 dapeng1.mi@linux.intel.com, joe.jin@oracle.com, ewanhai-oc@zhaoxin.com,
 ewanhai@zhaoxin.com
References: <20251230074354.88958-1-dongli.zhang@oracle.com>
 <20251230074354.88958-5-dongli.zhang@oracle.com>
 <b6c531d4-328d-48a7-856b-051c918c24ae@intel.com>
 <29969c2f-d71f-4952-9ab4-4ba8f69e1514@oracle.com>
 <e9762b91-175e-444d-b64c-dcded943b312@intel.com>
 <1a5e1552-0e61-4829-b6db-99914184eb7a@oracle.com>
Content-Language: en-US
From: "Chen, Zide" <zide.chen@intel.com>
In-Reply-To: <1a5e1552-0e61-4829-b6db-99914184eb7a@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 1/7/2026 12:05 AM, Dongli Zhang wrote:
> Hi Zide,
> 
> On 1/6/26 1:03 PM, Chen, Zide wrote:
>>
>>
>> On 1/5/2026 12:21 PM, Dongli Zhang wrote:
>>> Hi Zide,
>>>
>>> On 1/2/26 2:59 PM, Chen, Zide wrote:
>>>>
>>>>
>>>> On 12/29/2025 11:42 PM, Dongli Zhang wrote:
>>>
>>> [snip]
>>>
>>>>>  
>>>>>  static struct kvm_cpuid2 *cpuid_cache;
>>>>>  static struct kvm_cpuid2 *hv_cpuid_cache;
>>>>> @@ -2068,23 +2072,30 @@ int kvm_arch_pre_create_vcpu(CPUState *cpu, Error **errp)
>>>>>      if (first) {
>>>>>          first = false;
>>>>>  
>>>>> -        /*
>>>>> -         * Since Linux v5.18, KVM provides a VM-level capability to easily
>>>>> -         * disable PMUs; however, QEMU has been providing PMU property per
>>>>> -         * CPU since v1.6. In order to accommodate both, have to configure
>>>>> -         * the VM-level capability here.
>>>>> -         *
>>>>> -         * KVM_PMU_CAP_DISABLE doesn't change the PMU
>>>>> -         * behavior on Intel platform because current "pmu" property works
>>>>> -         * as expected.
>>>>> -         */
>>>>> -        if ((pmu_cap & KVM_PMU_CAP_DISABLE) && !X86_CPU(cpu)->enable_pmu) {
>>>>> -            ret = kvm_vm_enable_cap(kvm_state, KVM_CAP_PMU_CAPABILITY, 0,
>>>>> -                                    KVM_PMU_CAP_DISABLE);
>>>>> -            if (ret < 0) {
>>>>> -                error_setg_errno(errp, -ret,
>>>>> -                                 "Failed to set KVM_PMU_CAP_DISABLE");
>>>>> -                return ret;
>>>>> +        if (X86_CPU(cpu)->enable_pmu) {
>>>>> +            if (kvm_pmu_disabled) {
>>>>> +                warn_report("Failed to enable PMU since "
>>>>> +                            "KVM's enable_pmu parameter is disabled");
>>>>
>>>> I'm wondering about the intended value of this patch?
>>>>
>>>> If enable_pmu is true in QEMU but the corresponding KVM parameter is
>>>> false, then KVM_GET_SUPPORTED_CPUID or KVM_GET_MSRS should be able to
>>>> tell that the PMU feature is not supported by host.
>>>>
>>>> The logic implemented in this patch seems somewhat redundant.
>>>
>>> For Intel, the QEMU userspace can determine if the vPMU is disabled by KVM
>>> through the use of KVM_GET_SUPPORTED_CPUID.
>>>
>>> However, this approach does not apply to AMD. Unlike Intel, AMD does not rely on
>>> CPUID to detect whether PMU is supported. By default, we can assume that PMU is
>>> always available, except for the recent PerfMonV2 feature.
>>>
>>> The main objective of this PATCH 4/7 is to introduce the variable
>>> 'kvm_pmu_disabled', which will be reused in PATCH 5/7 to skip any PMU
>>> initialization if the parameter is set to 'N'.
>>>
>>> +static void kvm_init_pmu_info(struct kvm_cpuid2 *cpuid, X86CPU *cpu)
>>> +{
>>> +    CPUX86State *env = &cpu->env;
>>> +
>>> +    /*
>>> +     * The PMU virtualization is disabled by kvm.enable_pmu=N.
>>> +     */
>>> +    if (kvm_pmu_disabled) {
>>> +        return;
>>> +    }
>>
>> Thanks for explanation.
>>
>>> The 'kvm_pmu_disabled' variable is used to differentiate between the following
>>> two scenarios on AMD:
>>>
>>> (1) A newer KVM with KVM_PMU_CAP_DISABLE support, but explicitly disabled via
>>> the KVM parameter ('N').
>>>
>>> (2) An older KVM without KVM_CAP_PMU_CAPABILITY support.
>>>
>>> In both cases, the call to KVM_CAP_PMU_CAPABILITY extension support check may
>>> return 0.
>>>
>>> By reading the file "/sys/module/kvm/parameters/enable_pmu", we can distinguish
>>> between these two scenarios.
>>
>> As described in PATCH 1/7, without issuing KVM_PMU_CAP_DISABLE, KVM has
>> no way to know that userspace does not intend to enable vPMU in AMD
>> platforms, and therefore does not fault guest accesses to PMU MSRs.
>>
>> My understanding is that the issue being addressed here is basically the
>> opposite: QEMU does not know that vPMU is disabled by KVM.
> 
> Exactly.
> 
> Otherwise, QEMU issues unwanted MSR writes for every vCPU during QEMU reset.
> 
>>
>> IIUC, one difference between Intel and AMD is that AMD lacks a CPUID
>> leaf to indicate the availability of PMU version 1. But Intel
>> potentially could be in the same situation that KVM advertises PMU
>> availability but it's not actually supported. (e.g. kvm->arch.enable_pmu
>> is false while modules parameter enable_pmu is true).
>>
>> From the guest’s point of view, it probes PMU MSRs to determine whether
>> PMU support is present and it's fine in this situation.
>>
>> In userspace, QEMU may issue KVM_SET_MSRS / KVM_GET_MSRS to KVM without
>> knowing that vPMU has been disabled by KVM.  I think these IOCTLs should
>> not fail, since KVM states that “Userspace is allowed to read MSRs, and
>> write ‘0’ to MSRs, that KVM advertises to userspace, even if an MSR
>> isn’t fully supported.”
>>
>> My current understanding is that AMD should be fine even without
>> kvm_pmu_disabled, but I may be missing some context here.
>>
>> The bottom line is this patch doesn't handle the cases that KVM still
>> could disable vPMU support even if enable_pmu is true.
> 
> Yes. There are still unwanted PMU MSR writes from QEMU. This just seems odd.
> 
> The concern with unwanted MSR writes was initially raised by Maksim Davydov:
> 
> https://lore.kernel.org/qemu-devel/a7f9c3c9-09af-4941-b137-2cb83ef8ceb3@yandex-team.ru/
> 
> As shown below on the v6.0 KVM hypervisor (AMD), while there are no errors from
> QEMU, numerous annoying warnings are generated. (If I recall correctly, this can
> also be triggered from the VM itself.)
> 
> However, here the logs are not only due to vcpu0, but indeed every vcpu.
> 
> [  280.802976] kvm_set_msr_common: 1910 callbacks suppressed
> [  280.802981] kvm [18411]: vcpu0, guest rIP: 0xffffffffa4c97844 disabled
> perfctr wrmsr: 0xc0010007 data 0xffff
> [  295.345747] kvm [18411]: vcpu0, guest rIP: 0xfff0 disabled perfctr wrmsr:
> 0xc0010004 data 0x0
> [  295.355379] kvm [18411]: vcpu0, guest rIP: 0xfff0 disabled perfctr wrmsr:
> 0xc0010005 data 0x0
> [  295.364997] kvm [18411]: vcpu0, guest rIP: 0xfff0 disabled perfctr wrmsr:
> 0xc0010006 data 0x0
> [  295.374618] kvm [18411]: vcpu0, guest rIP: 0xfff0 disabled perfctr wrmsr:
> 0xc0010007 data 0x0
> [  295.385048] kvm [18411]: vcpu1, guest rIP: 0xfff0 disabled perfctr wrmsr:
> 0xc0010004 data 0x0
> [  295.394694] kvm [18411]: vcpu1, guest rIP: 0xfff0 disabled perfctr wrmsr:
> 0xc0010005 data 0x0
> [  295.404317] kvm [18411]: vcpu1, guest rIP: 0xfff0 disabled perfctr wrmsr:
> 0xc0010006 data 0x0
> [  295.413928] kvm [18411]: vcpu1, guest rIP: 0xfff0 disabled perfctr wrmsr:
> 0xc0010007 data 0x0
> [  295.424319] kvm [18411]: vcpu2, guest rIP: 0xfff0 disabled perfctr wrmsr:
> 0xc0010004 data 0x0
> [  295.433963] kvm [18411]: vcpu2, guest rIP: 0xfff0 disabled perfctr wrmsr:
> 0xc0010005 data 0x0
> [  301.966571] kvm_set_msr_common: 1910 callbacks suppressed
> [  301.966577] kvm [18411]: vcpu0, guest rIP: 0xffffffff8ac97844 disabled
> perfctr wrmsr: 0xc0010007 data 0xffff

In e76ae52747a8 ("KVM: x86/pmu: Gate all "unimplemented MSR" prints on
report_ignored_msrs"), in "disabled perfctr wrmsr" case, vcpu_unimpl()
is no longer forced for counter MSRs, so most of the above warnings go away.

For the remaining warnings, vcpu_unimpl() is ratelimitedm and plus all
these logs can be removed by setting report_ignored_msrs=false.

So, it should be not that bad now.

>>
>>
>>> As you mentioned, another approach would be to use KVM_GET_MSRS to specifically
>>> probe for AMD during QEMU initialization. In this case, we can set
>>> 'kvm_pmu_disabled' to true if reading the AMD PMU MSR registers fails.
>>>
>>> To implement this, we may need to:
>>>
>>> 1. Turn this patch to be AMD specific by probing the AMD PMU registers during
>>> initialization. We may need go create a new function in QEMU to use KVM_GET_MSRS
>>> for probing only, or we may re-use kvm_arch_get_supported_msr_feature() or
>>> kvm_get_one_msr(). I may change in the next version.
>>>
>>> 2. Limit the usage of 'kvm_pmu_disabled' to be AMD specific in PATCH 5/7.
>>
>> I guess this might make things more complicated.
>>
>>>>
>>>> Additionally, in this scenario — where the user intends to enable a
>>>> feature but the host cannot support it — normally no warning is emitted
>>>> by QEMU.
>>>
>>> According to the usage of QEMU, may I assume QEMU already prints warning logs
>>> for unsupported features? The below is an example.
>>>
>>> QEMU 10.2.50 monitor - type 'help' for more information
>>> qemu-system-x86_64: warning: host doesn't support requested feature:
>>> CPUID[eax=07h,ecx=00h].EBX.hle [bit 4]
>>> qemu-system-x86_64: warning: host doesn't support requested feature:
>>> CPUID[eax=07h,ecx=00h].EBX.rtm [bit 11]
>>>
>>>>
>>>>> +            }
>>>>> +        } else {
>>>>> +            /*
>>>>> +             * Since Linux v5.18, KVM provides a VM-level capability to easily
>>>>> +             * disable PMUs; however, QEMU has been providing PMU property per
>>>>> +             * CPU since v1.6. In order to accommodate both, have to configure
>>>>> +             * the VM-level capability here.
>>>>> +             *
>>>>> +             * KVM_PMU_CAP_DISABLE doesn't change the PMU
>>>>> +             * behavior on Intel platform because current "pmu" property works
>>>>> +             * as expected.
>>>>> +             */
>>>>> +            if (pmu_cap & KVM_PMU_CAP_DISABLE) {
>>>>> +                ret = kvm_vm_enable_cap(kvm_state, KVM_CAP_PMU_CAPABILITY, 0,
>>>>> +                                        KVM_PMU_CAP_DISABLE);
>>>>> +                if (ret < 0) {
>>>>> +                    error_setg_errno(errp, -ret,
>>>>> +                                     "Failed to set KVM_PMU_CAP_DISABLE");
>>>>> +                    return ret;
>>>>> +                }
>>>>>              }
>>>>>          }
>>>>>      }
>>>>> @@ -3302,6 +3313,7 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
>>>>>      int ret;
>>>>>      struct utsname utsname;
>>>>>      Error *local_err = NULL;
>>>>> +    g_autofree char *kvm_enable_pmu;
>>>>>  
>>>>>      /*
>>>>>       * Initialize confidential guest (SEV/TDX) context, if required
>>>>> @@ -3437,6 +3449,21 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
>>>>>  
>>>>>      pmu_cap = kvm_check_extension(s, KVM_CAP_PMU_CAPABILITY);
>>>>>  
>>>>> +    /*
>>>>> +     * The enable_pmu parameter is introduced since Linux v5.17,
>>>>> +     * give a chance to provide more information about vPMU
>>>>> +     * enablement.
>>>>> +     *
>>>>> +     * The kvm.enable_pmu's permission is 0444. It does not change
>>>>> +     * until a reload of the KVM module.
>>>>> +     */
>>>>> +    if (g_file_get_contents("/sys/module/kvm/parameters/enable_pmu",
>>>>> +                            &kvm_enable_pmu, NULL, NULL)) {
>>>>> +        if (*kvm_enable_pmu == 'N') {
>>>>> +            kvm_pmu_disabled = true;
>>>>
>>>> It’s generally better not to rely on KVM’s internal implementation
>>>> unless really necessary.
>>>>
>>>> For example, in the new mediated vPMU framework, even if the KVM module
>>>> parameter enable_pmu is set, the per-guest kvm->arch.enable_pmu could
>>>> still be cleared.
>>>>
>>>> In such a case, the logic here might not be correct.
>>>
>>> Would the Mediated vPMU set KVM_PMU_CAP_DISABLE to clear per-VM enable_pmu even
>>> when the global KVM parameter enable_pmu=N is set?
>>>
>>> In this scenario, we plan to rely on KVM_PMU_CAP_DISABLE only when the value of
>>> "/sys/module/kvm/parameters/enable_pmu" is not equal to N.
>>>
>>> Can I assume that this will work with Mediated vPMU?
>>>
>>>
>>> Is there any possibility to follow the current approach before Mediated vPMU is
>>> finalized for mainline, and later introduce an incremental change using
>>> KVM_GET_MSRS probing? The current approach is straightforward and can work with
>>> existing Linux kernel source code.
>>
>> Apologies for the incorrect statement I made earlier regarding mediated
>> vPMU.
>>
>> According to the mediated vPMU v6, the only behavior specific to
>> mediated vPMU is that kvm->arch.enable_pmu may be cleared when
>> irqchip_in_kernel() is not true:
>> https://urldefense.com/v3/__https://lore.kernel.org/all/20251206001720.468579-17-seanjc@google.com/__;!!ACWV5N9M2RV99hQ!IS8XQG3Zx84utP2QScNlxp-0H5JAgr89lBb1j2oGVJJop3WMyK6X2I5mlerMPA06wkJy8VFd1x6XGEHc6kWn$ 
>>
>> However, this does not imply that mediated vPMU requires any special
>> handling here. In theory, KVM could clear kvm->arch.enable_pmu in the
>> future for other reasons.
>>
> 
> While "KVM could clear kvm->arch.enable_pmu in the future," I don't think KVM
> may set kvm->arch.enable_pmu if the global enable_pmu is set to 'N'.
> 
> Taking Intel VMX EPT as an example, once "/sys/module/kvm_intel/parameters/ept"
> is globally disabled, there's no way within KVM software to enable it for any
> guest VM **after** 'ept' is set to N.
> 
> Similarly, "/sys/module/kvm/parameters/enable_pmu=N" indicates that this KVM
> host will not support PMU virtualization in any way. Therefore, there should be
> no way to enable vPMU for any guest VM if the global parameter is set to 'N'.
> Here we read from ths parameter only during QEMU initialization.
> 
> That's why I believe it's reliable to trust the setting when
> "/sys/module/kvm/parameters/enable_pmu=N".
> 
> In this way, we can avoid many unnecessary MSR writes, especially in cases where
> a VM has 300+ vCPUs, even though these may be equivalent to NOPs with
> optimizations in more recent KVM versions.
> 
> The objective isn't to improve performance. Minimizing the number of unwanted
> MSR writes from QEMU reduces the chances of failure (e.g., due to any QEMU
> software bug). We can simply avoid those unwanted MSR/NOPs by reading from a KVM
> parameter.
> 
> From a user's perspective, this just seems odd.
> "/sys/module/kvm/parameters/enable_pmu=N" is a reliable setting. If there's a
> configuration mismatch between QEMU and KVM, a warning could alert the user.
> 
> I can remove this patch, along with the 'kvm_pmu_disabled' variable.


Even with /sys/module/kvm/parameters/enable_pmu=Y, theoretically it's
possible for kvm->arch.enable_pmu to be false. In such a case, vPMU
could still be advertised, and QEMU doens't know that vPMU is not
supported by KVM, on either Intel or AMD platforms.

Anyway, this is likely only a theoretical scenario and may not actually
happens in practice.


> Thank you very much!
> 
> Dongli Zhang


