Return-Path: <kvm+bounces-31272-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A3C99C1ED0
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 15:07:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 04F61B218B9
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 14:07:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F03791EF095;
	Fri,  8 Nov 2024 14:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="kl3GguPo"
X-Original-To: kvm@vger.kernel.org
Received: from forwardcorp1d.mail.yandex.net (forwardcorp1d.mail.yandex.net [178.154.239.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD7AC1E1C18
	for <kvm@vger.kernel.org>; Fri,  8 Nov 2024 14:07:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731074860; cv=none; b=s5fFNn6W0qs+nbgcUjgS3hjbIGZr/amkXFnuUnXX/iqiSIv4JKrWSa9sA2SFv2Z6Yn/lVHMAY2NHoVLJghEUKbRuvGsqBJtElW1/NNBKoiFrdWk7t03cUlIVek6H8mr7Re9+7g+7RLZu88jajtPl8HkreuTNQzACZZsQ0LZ+otU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731074860; c=relaxed/simple;
	bh=QGXWI14Ag34mRelwfR/nkJ5ItLkpZepMlCCgCpbJMRU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KLKA5vHhivBSB54jGHL2SEjLqGrwW5oeSpoCKz93F2YFko+DWC/Gb4jYTpvySjQVm1EbnnCW2XsZP7TzgKslHqGCy7BnvK7C6I5fdoFEiqROmp+gRGds3LWnCtDf16AYTPUeCzBMXnmEk3oYvjrBQtesUIDlx/yFeBrAl7DC9n0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=kl3GguPo; arc=none smtp.client-ip=178.154.239.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Received: from mail-nwsmtp-smtp-corp-main-56.klg.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-56.klg.yp-c.yandex.net [IPv6:2a02:6b8:c42:b1cb:0:640:2a1e:0])
	by forwardcorp1d.mail.yandex.net (Yandex) with ESMTPS id AD7FF60A3B;
	Fri,  8 Nov 2024 17:07:28 +0300 (MSK)
Received: from [IPV6:2a02:6bf:8011:701:66e1:20a5:ba04:640b] (unknown [2a02:6bf:8011:701:66e1:20a5:ba04:640b])
	by mail-nwsmtp-smtp-corp-main-56.klg.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id P7kDNV1BYSw0-4EEgLR2W;
	Fri, 08 Nov 2024 17:07:27 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1731074847;
	bh=bAEaXbwmbvUU03uRl6Sb/gVLLQlVCAnUnf5V1q9NGl8=;
	h=From:In-Reply-To:Cc:Date:References:To:Subject:Message-ID;
	b=kl3GguPoLnLg9lsmNV+eqbYin5xAkPc9asisSkmURJgL/h8EYQr+ggMkfoDQj/EsR
	 Q8wXH9mJm4vtzVBWox9/FzvQxjrN16MUAVSYXDw4TVkWLE7c1OXjsfExA2RF0ceUF5
	 PpIxGczoJhQFSgEZu9ozGeamHptS6//BNho6ismw=
Authentication-Results: mail-nwsmtp-smtp-corp-main-56.klg.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Message-ID: <94e089fb-4fc3-4320-897e-e8146a226109@yandex-team.ru>
Date: Fri, 8 Nov 2024 17:07:25 +0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/7] target/i386/kvm: reset AMD PMU registers during VM
 reset
To: dongli.zhang@oracle.com
Cc: pbonzini@redhat.com, mtosatti@redhat.com, sandipan.das@amd.com,
 babu.moger@amd.com, zhao1.liu@intel.com, likexu@tencent.com,
 like.xu.linux@gmail.com, zhenyuw@linux.intel.com, groug@kaod.org,
 lyan@digitalocean.com, khorenko@virtuozzo.com,
 alexander.ivanov@virtuozzo.com, den@virtuozzo.com, joe.jin@oracle.com,
 qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20241104094119.4131-1-dongli.zhang@oracle.com>
 <20241104094119.4131-6-dongli.zhang@oracle.com>
 <a7f9c3c9-09af-4941-b137-2cb83ef8ceb3@yandex-team.ru>
 <4b73133b-1ce5-4eba-a77b-f595e02a942e@oracle.com>
Content-Language: en-US
From: Maksim Davydov <davydov-max@yandex-team.ru>
In-Reply-To: <4b73133b-1ce5-4eba-a77b-f595e02a942e@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 11/8/24 04:19, dongli.zhang@oracle.com wrote:
> Hi Maksim,
> 
> On 11/7/24 1:00 PM, Maksim Davydov wrote:
>>
>>
>> On 11/4/24 12:40, Dongli Zhang wrote:
>>> QEMU uses the kvm_get_msrs() function to save Intel PMU registers from KVM
>>> and kvm_put_msrs() to restore them to KVM. However, there is no support for
>>> AMD PMU registers. Currently, has_pmu_version and num_pmu_gp_counters are
>>> initialized based on cpuid(0xa), which does not apply to AMD processors.
>>> For AMD CPUs, prior to PerfMonV2, the number of general-purpose registers
>>> is determined based on the CPU version.
>>>
>>> To address this issue, we need to add support for AMD PMU registers.
>>> Without this support, the following problems can arise:
>>>
>>> 1. If the VM is reset (e.g., via QEMU system_reset or VM kdump/kexec) while
>>> running "perf top", the PMU registers are not disabled properly.
>>>
>>> 2. Despite x86_cpu_reset() resetting many registers to zero, kvm_put_msrs()
>>> does not handle AMD PMU registers, causing some PMU events to remain
>>> enabled in KVM.
>>>
>>> 3. The KVM kvm_pmc_speculative_in_use() function consistently returns true,
>>> preventing the reclamation of these events. Consequently, the
>>> kvm_pmc->perf_event remains active.
>>>
>>> 4. After a reboot, the VM kernel may report the following error:
>>>
>>> [    0.092011] Performance Events: Fam17h+ core perfctr, Broken BIOS detected,
>>> complain to your hardware vendor.
>>> [    0.092023] [Firmware Bug]: the BIOS has corrupted hw-PMU resources (MSR
>>> c0010200 is 530076)
>>>
>>> 5. In the worst case, the active kvm_pmc->perf_event may inject unknown
>>> NMIs randomly into the VM kernel:
>>>
>>> [...] Uhhuh. NMI received for unknown reason 30 on CPU 0.
>>>
>>> To resolve these issues, we propose resetting AMD PMU registers during the
>>> VM reset process.
>>>
>>> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
>>> ---
>>>    target/i386/cpu.h     |   8 +++
>>>    target/i386/kvm/kvm.c | 156 +++++++++++++++++++++++++++++++++++++++++-
>>>    2 files changed, 161 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
>>> index 59959b8b7a..0505eb3b08 100644
>>> --- a/target/i386/cpu.h
>>> +++ b/target/i386/cpu.h
>>> @@ -488,6 +488,14 @@ typedef enum X86Seg {
>>>    #define MSR_CORE_PERF_GLOBAL_CTRL       0x38f
>>>    #define MSR_CORE_PERF_GLOBAL_OVF_CTRL   0x390
>>>    +#define MSR_K7_EVNTSEL0                 0xc0010000
>>> +#define MSR_K7_PERFCTR0                 0xc0010004
>>> +#define MSR_F15H_PERF_CTL0              0xc0010200
>>> +#define MSR_F15H_PERF_CTR0              0xc0010201
>>> +
>>> +#define AMD64_NUM_COUNTERS              4
>>> +#define AMD64_NUM_COUNTERS_CORE         6
>>> +
>>>    #define MSR_MC0_CTL                     0x400
>>>    #define MSR_MC0_STATUS                  0x401
>>>    #define MSR_MC0_ADDR                    0x402
>>> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
>>> index ca2b644e2c..83ec85a9b9 100644
>>> --- a/target/i386/kvm/kvm.c
>>> +++ b/target/i386/kvm/kvm.c
>>> @@ -2035,7 +2035,7 @@ full:
>>>        abort();
>>>    }
>>>    -static void kvm_init_pmu_info(CPUX86State *env)
>>> +static void kvm_init_pmu_info_intel(CPUX86State *env)
>>>    {
>>>        uint32_t eax, edx;
>>>        uint32_t unused;
>>> @@ -2072,6 +2072,80 @@ static void kvm_init_pmu_info(CPUX86State *env)
>>>        }
>>>    }
>>>    +static void kvm_init_pmu_info_amd(CPUX86State *env)
>>> +{
>>> +    int64_t family;
>>> +
>>> +    has_pmu_version = 0;
>>> +
>>> +    /*
>>> +     * To determine the CPU family, the following code is derived from
>>> +     * x86_cpuid_version_get_family().
>>> +     */
>>> +    family = (env->cpuid_version >> 8) & 0xf;
>>> +    if (family == 0xf) {
>>> +        family += (env->cpuid_version >> 20) & 0xff;
>>> +    }
>>> +
>>> +    /*
>>> +     * Performance-monitoring supported from K7 and later.
>>> +     */
>>> +    if (family < 6) {
>>> +        return;
>>> +    }
>>> +
>>> +    has_pmu_version = 1;
>>> +
>>> +    if (!(env->features[FEAT_8000_0001_ECX] & CPUID_EXT3_PERFCORE)) {
>>> +        num_pmu_gp_counters = AMD64_NUM_COUNTERS;
>>> +        return;
>>> +    }
>>> +
>>> +    num_pmu_gp_counters = AMD64_NUM_COUNTERS_CORE;
>>> +}
>>
>> It seems that AMD implementation has one issue.
>> KVM has parameter `enable_pmu`. So vPMU can be disabled in another way, not only
>> via KVM_PMU_CAP_DISABLE. For Intel it's not a problem, because the vPMU
>> initialization uses info from KVM_GET_SUPPORTED_CPUID. The enable_pmu state is
>> reflected in KVM_GET_SUPPORTED_CPUID.  Thus no PMU MSRs in kvm_put_msrs/
>> kvm_get_msrs will be used.
>>
>> But on AMD we don't use information from KVM_GET_SUPPORTED_CPUID to set an
>> appropriate number of PMU registers. So, if vPMU is disabled by KVM parameter
>> `enable_pmu` and pmu-cap-disable=false, then has_pmu_version will be 1 after
>> kvm_init_pmu_info_amd execution. It means that in kvm_put_msrs/kvm_get_msrs 4
>> PMU counters will be processed, but the correct behavior in that situation is to
>> skip all PMU registers.
>> I think we should get info from KVM to fix that.
>>
>> I tested this series on Zen2 and found that PMU MSRs were still processed during
>> initialization even with enable_pmu=N. But it doesn't lead to any errors in QEMU
> 
> Thank you very much for the feedback and helping catch the bug!
> 
> When enable_pmu=N, the QEMU (with this patchset) cannot tell if vPMU is
> supported via KVM_CAP_PMU_CAPABILITY.
> 
> As it cannot disable the PMU, it falls to the legacy 4 counters.
> 
> It falls to 4 counters because KVM disableds PERFCORE on enable_pmu=Y, i.e.,
> 
> 5220         if (enable_pmu) {
> 5221                 /*
> 5222                  * Enumerate support for PERFCTR_CORE if and only if KVM has
> 5223                  * access to enough counters to virtualize "core" support,
> 5224                  * otherwise limit vPMU support to the legacy number of
> counters.
> 5225                  */
> 5226                 if (kvm_pmu_cap.num_counters_gp < AMD64_NUM_COUNTERS_CORE)
> 5227                         kvm_pmu_cap.num_counters_gp = min(AMD64_NUM_COUNTERS,
> 5228
> kvm_pmu_cap.num_counters_gp);
> 5229                 else
> 5230                         kvm_cpu_cap_check_and_set(X86_FEATURE_PERFCTR_CORE);
> 5231
> 5232                 if (kvm_pmu_cap.version != 2 ||
> 5233                     !kvm_cpu_cap_has(X86_FEATURE_PERFCTR_CORE))
> 5234                         kvm_cpu_cap_clear(X86_FEATURE_PERFMON_V2);
> 5235         }
> 
> 
> During the bootup and reset, the QEMU (with this patchset) erroneously resets
> MSRs for the 4 PMCs, via line 3827.
> 
> 3825 static int kvm_buf_set_msrs(X86CPU *cpu)
> 3826 {
> 3827     int ret = kvm_vcpu_ioctl(CPU(cpu), KVM_SET_MSRS, cpu->kvm_msr_buf);
> 3828     if (ret < 0) {
> 3829         return ret;
> 3830     }
> 3831
> 3832     if (ret < cpu->kvm_msr_buf->nmsrs) {
> 3833         struct kvm_msr_entry *e = &cpu->kvm_msr_buf->entries[ret];
> 3834         error_report("error: failed to set MSR 0x%" PRIx32 " to 0x%" PRIx64,
> 3835                      (uint32_t)e->index, (uint64_t)e->data);
> 3836     }
> 3837
> 3838     assert(ret == cpu->kvm_msr_buf->nmsrs);
> 3839     return 0;
> 3840 }
> 
> Because enable_pmu=N, the KVM doesn't support those registers. However, it
> returns 0 (not 1), because the KVM does nothing in the implicit else (i.e., line
> 4144).
> 
> 3847 int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> 3848 {
> ... ...
> 4138         case MSR_K7_PERFCTR0 ... MSR_K7_PERFCTR3:
> 4139         case MSR_P6_PERFCTR0 ... MSR_P6_PERFCTR1:
> 4140         case MSR_K7_EVNTSEL0 ... MSR_K7_EVNTSEL3:
> 4141         case MSR_P6_EVNTSEL0 ... MSR_P6_EVNTSEL1:
> 4142                 if (kvm_pmu_is_valid_msr(vcpu, msr))
> 4143                         return kvm_pmu_set_msr(vcpu, msr_info);
> 4144
> 4145                 if (data)
> 4146                         kvm_pr_unimpl_wrmsr(vcpu, msr, data);
> 4147                 break;
> ... ...
> 4224         default:
> 4225                 if (kvm_pmu_is_valid_msr(vcpu, msr))
> 4226                         return kvm_pmu_set_msr(vcpu, msr_info);
> 4227
> 4228                 /*
> 4229                  * Userspace is allowed to write '0' to MSRs that KVM reports
> 4230                  * as to-be-saved, even if an MSRs isn't fully supported.
> 4231                  */
> 4232                 if (msr_info->host_initiated && !data &&
> 4233                     kvm_is_msr_to_save(msr))
> 4234                         break;
> 4235
> 4236                 return KVM_MSR_RET_INVALID;
> 4237         }
> 4238         return 0;
> 4239 }
> 4240 EXPORT_SYMBOL_GPL(kvm_set_msr_common);
> 
> Fortunately, it returns 0 at line 4238. No error is detected by QEMU.
> 
> Perhaps I may need to send message with a small patch to return 1 in the
> implicit 'else' to kvm mailing list to confirm if that is expected.
> 
> However, the answer is very likely 'expected', because line 4229 to line 4230
> already explain it.
> 

Sorry for confusing you. My fault.
I tested the previous series on Intel with the old kernel and QEMU 
failed with `error: failed to set MSR 0x38d to 0x0`. So I expected the 
same error.
But as I can see, AMD PMU registers are processed differently than the 
Intel ones. Also the default MSR behavior in KVM has been changed since 
2de154f541fc

I think that the current implementation with additional parameter 
pmu-cap-disabled does what we expect. The guest will see disabled PMU in 
the same two configurations:
* pmu-cap-disabled=true and enabled_pmu=N
* pmu-cap-disabled=true and enabled_pmu=Y
But in QEMU these two configurations will have different states 
(has_pmu_version 1 and 0 respectively). I think it should be taken into 
account in the implementation without pmu-cap-disabled (which was 
suggested before) to save guest-visible state during migration.

> 
> Regarding the change in QEMU:
> 
> Since kvm_check_extension(s, KVM_CAP_PMU_CAPABILITY) returns 0 for both (1)
> enable_pmu=Y, and (2) KVM_CAP_PMU_CAPABILITY not supported, I may need to use
> g_file_get_contents() to read from the KVM sysfs parameters (similar to KVM
> selftest kvm_is_pmu_enabled()).
> 
>>
>>> +
>>> +static bool is_same_vendor(CPUX86State *env)
>>> +{
>>> +    static uint32_t host_cpuid_vendor1;
>>> +    static uint32_t host_cpuid_vendor2;
>>> +    static uint32_t host_cpuid_vendor3;
>>> +
>>> +    host_cpuid(0x0, 0, NULL, &host_cpuid_vendor1, &host_cpuid_vendor3,
>>> +               &host_cpuid_vendor2);
>>> +
>>> +    return env->cpuid_vendor1 == host_cpuid_vendor1 &&
>>> +           env->cpuid_vendor2 == host_cpuid_vendor2 &&
>>> +           env->cpuid_vendor3 == host_cpuid_vendor3;
>>> +}
>>> +
>>> +static void kvm_init_pmu_info(CPUX86State *env)
>>> +{
>>> +    /*
>>> +     * It is not supported to virtualize AMD PMU registers on Intel
>>> +     * processors, nor to virtualize Intel PMU registers on AMD processors.
>>> +     */
>>> +    if (!is_same_vendor(env)) {
>>> +        return;
>>> +    }
>>> +
>>> +    /*
>>> +     * If KVM_CAP_PMU_CAPABILITY is not supported, there is no way to
>>> +     * disable the AMD pmu virtualization.
>>> +     *
>>> +     * If KVM_CAP_PMU_CAPABILITY is supported, kvm_state->pmu_cap_disabled
>>> +     * indicates the KVM has already disabled the pmu virtualization.
>>> +     */
>>> +    if (kvm_state->pmu_cap_disabled) {
>>> +        return;
>>> +    }
>>> +
>>
>> It seems that after these changes the issue concerning using
>> pmu-cap-disable=true with +pmu on Intel platform (that Zhao Liu has mentioned
>> before) is fixed
> 
> Can I assume you were going to paste some code below?
> 
> Regardless, I am going to following Zhao's suggestion to revert back to my
> previous solution.
> 
> Thank you very much for the feedback!
> 
> Dongli Zhang
> 
>>
>>> +    if (IS_INTEL_CPU(env)) {
>>> +        kvm_init_pmu_info_intel(env);
>>> +    } else if (IS_AMD_CPU(env)) {
>>> +        kvm_init_pmu_info_amd(env);
>>> +    }
>>> +}
>>> +
>>>    int kvm_arch_init_vcpu(CPUState *cs)
>>>    {
>>>        struct {
>>> @@ -4027,7 +4101,7 @@ static int kvm_put_msrs(X86CPU *cpu, int level)
>>>                kvm_msr_entry_add(cpu, MSR_KVM_POLL_CONTROL, env-
>>>> poll_control_msr);
>>>            }
>>>    -        if (has_pmu_version > 0) {
>>> +        if (IS_INTEL_CPU(env) && has_pmu_version > 0) {
>>>                if (has_pmu_version > 1) {
>>>                    /* Stop the counter.  */
>>>                    kvm_msr_entry_add(cpu, MSR_CORE_PERF_FIXED_CTR_CTRL, 0);
>>> @@ -4058,6 +4132,38 @@ static int kvm_put_msrs(X86CPU *cpu, int level)
>>>                                      env->msr_global_ctrl);
>>>                }
>>>            }
>>> +
>>> +        if (IS_AMD_CPU(env) && has_pmu_version > 0) {
>>> +            uint32_t sel_base = MSR_K7_EVNTSEL0;
>>> +            uint32_t ctr_base = MSR_K7_PERFCTR0;
>>> +            /*
>>> +             * The address of the next selector or counter register is
>>> +             * obtained by incrementing the address of the current selector
>>> +             * or counter register by one.
>>> +             */
>>> +            uint32_t step = 1;
>>> +
>>> +            /*
>>> +             * When PERFCORE is enabled, AMD PMU uses a separate set of
>>> +             * addresses for the selector and counter registers.
>>> +             * Additionally, the address of the next selector or counter
>>> +             * register is determined by incrementing the address of the
>>> +             * current register by two.
>>> +             */
>>> +            if (num_pmu_gp_counters == AMD64_NUM_COUNTERS_CORE) {
>>> +                sel_base = MSR_F15H_PERF_CTL0;
>>> +                ctr_base = MSR_F15H_PERF_CTR0;
>>> +                step = 2;
>>> +            }
>>> +
>>> +            for (i = 0; i < num_pmu_gp_counters; i++) {
>>> +                kvm_msr_entry_add(cpu, ctr_base + i * step,
>>> +                                  env->msr_gp_counters[i]);
>>> +                kvm_msr_entry_add(cpu, sel_base + i * step,
>>> +                                  env->msr_gp_evtsel[i]);
>>> +            }
>>> +        }
>>> +
>>>            /*
>>>             * Hyper-V partition-wide MSRs: to avoid clearing them on cpu hot-add,
>>>             * only sync them to KVM on the first cpu
>>> @@ -4503,7 +4609,8 @@ static int kvm_get_msrs(X86CPU *cpu)
>>>        if (env->features[FEAT_KVM] & (1 << KVM_FEATURE_POLL_CONTROL)) {
>>>            kvm_msr_entry_add(cpu, MSR_KVM_POLL_CONTROL, 1);
>>>        }
>>> -    if (has_pmu_version > 0) {
>>> +
>>> +    if (IS_INTEL_CPU(env) && has_pmu_version > 0) {
>>>            if (has_pmu_version > 1) {
>>>                kvm_msr_entry_add(cpu, MSR_CORE_PERF_FIXED_CTR_CTRL, 0);
>>>                kvm_msr_entry_add(cpu, MSR_CORE_PERF_GLOBAL_CTRL, 0);
>>> @@ -4519,6 +4626,35 @@ static int kvm_get_msrs(X86CPU *cpu)
>>>            }
>>>        }
>>>    +    if (IS_AMD_CPU(env) && has_pmu_version > 0) {
>>> +        uint32_t sel_base = MSR_K7_EVNTSEL0;
>>> +        uint32_t ctr_base = MSR_K7_PERFCTR0;
>>> +        /*
>>> +         * The address of the next selector or counter register is
>>> +         * obtained by incrementing the address of the current selector
>>> +         * or counter register by one.
>>> +         */
>>> +        uint32_t step = 1;
>>> +
>>> +        /*
>>> +         * When PERFCORE is enabled, AMD PMU uses a separate set of
>>> +         * addresses for the selector and counter registers.
>>> +         * Additionally, the address of the next selector or counter
>>> +         * register is determined by incrementing the address of the
>>> +         * current register by two.
>>> +         */
>>> +        if (num_pmu_gp_counters == AMD64_NUM_COUNTERS_CORE) {
>>> +            sel_base = MSR_F15H_PERF_CTL0;
>>> +            ctr_base = MSR_F15H_PERF_CTR0;
>>> +            step = 2;
>>> +        }
>>> +
>>> +        for (i = 0; i < num_pmu_gp_counters; i++) {
>>> +            kvm_msr_entry_add(cpu, ctr_base + i * step, 0);
>>> +            kvm_msr_entry_add(cpu, sel_base + i * step, 0);
>>> +        }
>>> +    }
>>> +
>>>        if (env->mcg_cap) {
>>>            kvm_msr_entry_add(cpu, MSR_MCG_STATUS, 0);
>>>            kvm_msr_entry_add(cpu, MSR_MCG_CTL, 0);
>>> @@ -4830,6 +4966,20 @@ static int kvm_get_msrs(X86CPU *cpu)
>>>            case MSR_P6_EVNTSEL0 ... MSR_P6_EVNTSEL0 + MAX_GP_COUNTERS - 1:
>>>                env->msr_gp_evtsel[index - MSR_P6_EVNTSEL0] = msrs[i].data;
>>>                break;
>>> +        case MSR_K7_EVNTSEL0 ... MSR_K7_EVNTSEL0 + 3:
>>> +            env->msr_gp_evtsel[index - MSR_K7_EVNTSEL0] = msrs[i].data;
>>> +            break;
>>> +        case MSR_K7_PERFCTR0 ... MSR_K7_PERFCTR0 + 3:
>>> +            env->msr_gp_counters[index - MSR_K7_PERFCTR0] = msrs[i].data;
>>> +            break;
>>> +        case MSR_F15H_PERF_CTL0 ... MSR_F15H_PERF_CTL0 + 0xb:
>>> +            index = index - MSR_F15H_PERF_CTL0;
>>> +            if (index & 0x1) {
>>> +                env->msr_gp_counters[index] = msrs[i].data;
>>> +            } else {
>>> +                env->msr_gp_evtsel[index] = msrs[i].data;
>>> +            }
>>> +            break;
>>>            case HV_X64_MSR_HYPERCALL:
>>>                env->msr_hv_hypercall = msrs[i].data;
>>>                break;
>>
> 

-- 
Best regards,
Maksim Davydov

