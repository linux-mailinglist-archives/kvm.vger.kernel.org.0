Return-Path: <kvm+bounces-40140-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E4461A4F7F4
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 08:33:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 48E9C7A7F62
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 07:32:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2A351EDA21;
	Wed,  5 Mar 2025 07:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jFksWudQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3F5819D06A
	for <kvm@vger.kernel.org>; Wed,  5 Mar 2025 07:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741160001; cv=none; b=kOyLiE7Mqnc7JnWlUkzw/fBMauLLPYOrhBOe8ou0ozuY5RtVNMQHYyobbGmltHA4HPE5p5WQEHFWNgGV2bbYnJFg+F9CCLdGwCvlO/bJ8gjtrSbSPPTaD2CzGEZmT16Tfhcje4ae9muz7n5MQZ6pdlYasV5tr2CrLVT0aYJ+W8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741160001; c=relaxed/simple;
	bh=KeOlT8gHm5Ta6pFCUJc5qwT0LHx0Q/LUtX/54yZDZdc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ry93rqeaeXE5LirUPKLeu5LvOjwEP7P6y5rFhPgA8cVX+4/gR255FkqjvuBOAApycHxT0e1xJmxqggzjHrA/l16V6ccanvc5jJHmNZ6OcRH1XgRhjzD02g5sBDJfAPfmEVj7/p+XLzKt3/LbPVEBNfcLfVkJr0z5BK3oNa1GusU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jFksWudQ; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741160000; x=1772696000;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=KeOlT8gHm5Ta6pFCUJc5qwT0LHx0Q/LUtX/54yZDZdc=;
  b=jFksWudQkuOyw6AGuklqz2vuiRDn7forejMfXQIsnVFluL/3yJcXKMcz
   8r+JFahXvLMurnFoEYnnimHpuWhOFXEqYTnIG6A0znELoE9crxU2zDCXZ
   mTw4KDK1EaWNet9iUTmkOWTgc6aPr5E719XuYXE3PYYNjl7at1UAssFPJ
   +rWllTqewomnw9n875/KSGJHswogmdt2feyjGh8U4x6i88o7YgTQDSJCK
   uyDwo2dkLDdzegbJb3NKbLd3RrMa8m92KhlnG4RGnK0xaJiGawXi7dmmR
   KGXXK0b1aabQAMY9Lxh3ef5gXeHG10/IrGRZrIY6IuCbEGIcEogmNJb4X
   Q==;
X-CSE-ConnectionGUID: qJr9/5TMReOAyVuE0MIuhQ==
X-CSE-MsgGUID: i3+xjcF6Q/+tKz8/JZmhpQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11363"; a="52746493"
X-IronPort-AV: E=Sophos;i="6.14,222,1736841600"; 
   d="scan'208";a="52746493"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2025 23:33:18 -0800
X-CSE-ConnectionGUID: icbHFNd+RhO/Be2+TyGJ5A==
X-CSE-MsgGUID: JpHkFnC7QwmhTQV+61aGOQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="149568964"
Received: from unknown (HELO [10.238.2.135]) ([10.238.2.135])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2025 23:33:15 -0800
Message-ID: <7aed3b14-d81c-441b-a092-d9be9f81c90c@linux.intel.com>
Date: Wed, 5 Mar 2025 15:33:12 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 08/10] target/i386/kvm: reset AMD PMU registers during
 VM reset
To: Dongli Zhang <dongli.zhang@oracle.com>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org
Cc: pbonzini@redhat.com, zhao1.liu@intel.com, mtosatti@redhat.com,
 sandipan.das@amd.com, babu.moger@amd.com, likexu@tencent.com,
 like.xu.linux@gmail.com, zhenyuw@linux.intel.com, groug@kaod.org,
 khorenko@virtuozzo.com, alexander.ivanov@virtuozzo.com, den@virtuozzo.com,
 davydov-max@yandex-team.ru, xiaoyao.li@intel.com, joe.jin@oracle.com
References: <20250302220112.17653-1-dongli.zhang@oracle.com>
 <20250302220112.17653-9-dongli.zhang@oracle.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20250302220112.17653-9-dongli.zhang@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 3/3/2025 6:00 AM, Dongli Zhang wrote:
> QEMU uses the kvm_get_msrs() function to save Intel PMU registers from KVM
> and kvm_put_msrs() to restore them to KVM. However, there is no support for
> AMD PMU registers. Currently, has_pmu_version and num_pmu_gp_counters are
> initialized based on cpuid(0xa), which does not apply to AMD processors.
> For AMD CPUs, prior to PerfMonV2, the number of general-purpose registers
> is determined based on the CPU version.
>
> To address this issue, we need to add support for AMD PMU registers.
> Without this support, the following problems can arise:
>
> 1. If the VM is reset (e.g., via QEMU system_reset or VM kdump/kexec) while
> running "perf top", the PMU registers are not disabled properly.
>
> 2. Despite x86_cpu_reset() resetting many registers to zero, kvm_put_msrs()
> does not handle AMD PMU registers, causing some PMU events to remain
> enabled in KVM.
>
> 3. The KVM kvm_pmc_speculative_in_use() function consistently returns true,
> preventing the reclamation of these events. Consequently, the
> kvm_pmc->perf_event remains active.
>
> 4. After a reboot, the VM kernel may report the following error:
>
> [    0.092011] Performance Events: Fam17h+ core perfctr, Broken BIOS detected, complain to your hardware vendor.
> [    0.092023] [Firmware Bug]: the BIOS has corrupted hw-PMU resources (MSR c0010200 is 530076)
>
> 5. In the worst case, the active kvm_pmc->perf_event may inject unknown
> NMIs randomly into the VM kernel:
>
> [...] Uhhuh. NMI received for unknown reason 30 on CPU 0.
>
> To resolve these issues, we propose resetting AMD PMU registers during the
> VM reset process.
>
> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
> ---
> Changed since v1:
>   - Modify "MSR_K7_EVNTSEL0 + 3" and "MSR_K7_PERFCTR0 + 3" by using
>     AMD64_NUM_COUNTERS (suggested by Sandipan Das).
>   - Use "AMD64_NUM_COUNTERS_CORE * 2 - 1", not "MSR_F15H_PERF_CTL0 + 0xb".
>     (suggested by Sandipan Das).
>   - Switch back to "-pmu" instead of using a global "pmu-cap-disabled".
>   - Don't initialize PMU info if kvm.enable_pmu=N.
>
>  target/i386/cpu.h     |   8 ++
>  target/i386/kvm/kvm.c | 173 +++++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 177 insertions(+), 4 deletions(-)
>
> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
> index c67b42d34f..319600672b 100644
> --- a/target/i386/cpu.h
> +++ b/target/i386/cpu.h
> @@ -490,6 +490,14 @@ typedef enum X86Seg {
>  #define MSR_CORE_PERF_GLOBAL_CTRL       0x38f
>  #define MSR_CORE_PERF_GLOBAL_OVF_CTRL   0x390
>  
> +#define MSR_K7_EVNTSEL0                 0xc0010000
> +#define MSR_K7_PERFCTR0                 0xc0010004
> +#define MSR_F15H_PERF_CTL0              0xc0010200
> +#define MSR_F15H_PERF_CTR0              0xc0010201
> +
> +#define AMD64_NUM_COUNTERS              4
> +#define AMD64_NUM_COUNTERS_CORE         6
> +
>  #define MSR_MC0_CTL                     0x400
>  #define MSR_MC0_STATUS                  0x401
>  #define MSR_MC0_ADDR                    0x402
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index efba3ae7a4..d4be8a0d2e 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -2069,7 +2069,7 @@ int kvm_arch_pre_create_vcpu(CPUState *cpu, Error **errp)
>      return 0;
>  }
>  
> -static void kvm_init_pmu_info(CPUX86State *env)
> +static void kvm_init_pmu_info_intel(CPUX86State *env)
>  {
>      uint32_t eax, edx;
>      uint32_t unused;
> @@ -2106,6 +2106,94 @@ static void kvm_init_pmu_info(CPUX86State *env)
>      }
>  }
>  
> +static void kvm_init_pmu_info_amd(CPUX86State *env)
> +{
> +    uint32_t unused;
> +    int64_t family;
> +    uint32_t ecx;
> +
> +    has_pmu_version = 0;
> +
> +    /*
> +     * To determine the CPU family, the following code is derived from
> +     * x86_cpuid_version_get_family().
> +     */
> +    family = (env->cpuid_version >> 8) & 0xf;
> +    if (family == 0xf) {
> +        family += (env->cpuid_version >> 20) & 0xff;
> +    }
> +
> +    /*
> +     * Performance-monitoring supported from K7 and later.
> +     */
> +    if (family < 6) {
> +        return;
> +    }
> +
> +    has_pmu_version = 1;
> +
> +    cpu_x86_cpuid(env, 0x80000001, 0, &unused, &unused, &ecx, &unused);
> +
> +    if (!(ecx & CPUID_EXT3_PERFCORE)) {
> +        num_pmu_gp_counters = AMD64_NUM_COUNTERS;
> +        return;
> +    }
> +
> +    num_pmu_gp_counters = AMD64_NUM_COUNTERS_CORE;
> +}
> +
> +static bool is_same_vendor(CPUX86State *env)
> +{
> +    static uint32_t host_cpuid_vendor1;
> +    static uint32_t host_cpuid_vendor2;
> +    static uint32_t host_cpuid_vendor3;
> +
> +    host_cpuid(0x0, 0, NULL, &host_cpuid_vendor1, &host_cpuid_vendor3,
> +               &host_cpuid_vendor2);
> +
> +    return env->cpuid_vendor1 == host_cpuid_vendor1 &&
> +           env->cpuid_vendor2 == host_cpuid_vendor2 &&
> +           env->cpuid_vendor3 == host_cpuid_vendor3;
> +}
> +
> +static void kvm_init_pmu_info(CPUState *cs)
> +{
> +    X86CPU *cpu = X86_CPU(cs);
> +    CPUX86State *env = &cpu->env;
> +
> +    /*
> +     * The PMU virtualization is disabled by kvm.enable_pmu=N.
> +     */
> +    if (kvm_pmu_disabled) {
> +        return;
> +    }
> +
> +    /*
> +     * It is not supported to virtualize AMD PMU registers on Intel
> +     * processors, nor to virtualize Intel PMU registers on AMD processors.
> +     */
> +    if (!is_same_vendor(env)) {
> +        return;
> +    }
> +
> +    /*
> +     * If KVM_CAP_PMU_CAPABILITY is not supported, there is no way to
> +     * disable the AMD pmu virtualization.
> +     *
> +     * If KVM_CAP_PMU_CAPABILITY is supported !cpu->enable_pmu
> +     * indicates the KVM has already disabled the PMU virtualization.
> +     */
> +    if (has_pmu_cap && !cpu->enable_pmu) {
> +        return;
> +    }
> +
> +    if (IS_INTEL_CPU(env)) {
> +        kvm_init_pmu_info_intel(env);
> +    } else if (IS_AMD_CPU(env)) {
> +        kvm_init_pmu_info_amd(env);
> +    }
> +}
> +
>  int kvm_arch_init_vcpu(CPUState *cs)
>  {
>      struct {
> @@ -2288,7 +2376,7 @@ int kvm_arch_init_vcpu(CPUState *cs)
>      cpuid_i = kvm_x86_build_cpuid(env, cpuid_data.entries, cpuid_i);
>      cpuid_data.cpuid.nent = cpuid_i;
>  
> -    kvm_init_pmu_info(env);
> +    kvm_init_pmu_info(cs);
>  
>      if (((env->cpuid_version >> 8)&0xF) >= 6
>          && (env->features[FEAT_1_EDX] & (CPUID_MCE | CPUID_MCA)) ==
> @@ -4064,7 +4152,7 @@ static int kvm_put_msrs(X86CPU *cpu, int level)
>              kvm_msr_entry_add(cpu, MSR_KVM_POLL_CONTROL, env->poll_control_msr);
>          }
>  
> -        if (has_pmu_version > 0) {
> +        if (IS_INTEL_CPU(env) && has_pmu_version > 0) {
>              if (has_pmu_version > 1) {
>                  /* Stop the counter.  */
>                  kvm_msr_entry_add(cpu, MSR_CORE_PERF_FIXED_CTR_CTRL, 0);
> @@ -4095,6 +4183,38 @@ static int kvm_put_msrs(X86CPU *cpu, int level)
>                                    env->msr_global_ctrl);
>              }
>          }
> +
> +        if (IS_AMD_CPU(env) && has_pmu_version > 0) {
> +            uint32_t sel_base = MSR_K7_EVNTSEL0;
> +            uint32_t ctr_base = MSR_K7_PERFCTR0;
> +            /*
> +             * The address of the next selector or counter register is
> +             * obtained by incrementing the address of the current selector
> +             * or counter register by one.
> +             */
> +            uint32_t step = 1;
> +
> +            /*
> +             * When PERFCORE is enabled, AMD PMU uses a separate set of
> +             * addresses for the selector and counter registers.
> +             * Additionally, the address of the next selector or counter
> +             * register is determined by incrementing the address of the
> +             * current register by two.
> +             */
> +            if (num_pmu_gp_counters == AMD64_NUM_COUNTERS_CORE) {
> +                sel_base = MSR_F15H_PERF_CTL0;
> +                ctr_base = MSR_F15H_PERF_CTR0;
> +                step = 2;
> +            }
> +
> +            for (i = 0; i < num_pmu_gp_counters; i++) {
> +                kvm_msr_entry_add(cpu, ctr_base + i * step,
> +                                  env->msr_gp_counters[i]);
> +                kvm_msr_entry_add(cpu, sel_base + i * step,
> +                                  env->msr_gp_evtsel[i]);
> +            }
> +        }
> +
>          /*
>           * Hyper-V partition-wide MSRs: to avoid clearing them on cpu hot-add,
>           * only sync them to KVM on the first cpu
> @@ -4542,7 +4662,8 @@ static int kvm_get_msrs(X86CPU *cpu)
>      if (env->features[FEAT_KVM] & CPUID_KVM_POLL_CONTROL) {
>          kvm_msr_entry_add(cpu, MSR_KVM_POLL_CONTROL, 1);
>      }
> -    if (has_pmu_version > 0) {
> +
> +    if (IS_INTEL_CPU(env) && has_pmu_version > 0) {
>          if (has_pmu_version > 1) {
>              kvm_msr_entry_add(cpu, MSR_CORE_PERF_FIXED_CTR_CTRL, 0);
>              kvm_msr_entry_add(cpu, MSR_CORE_PERF_GLOBAL_CTRL, 0);
> @@ -4558,6 +4679,35 @@ static int kvm_get_msrs(X86CPU *cpu)
>          }
>      }
>  
> +    if (IS_AMD_CPU(env) && has_pmu_version > 0) {
> +        uint32_t sel_base = MSR_K7_EVNTSEL0;
> +        uint32_t ctr_base = MSR_K7_PERFCTR0;
> +        /*
> +         * The address of the next selector or counter register is
> +         * obtained by incrementing the address of the current selector
> +         * or counter register by one.
> +         */
> +        uint32_t step = 1;
> +
> +        /*
> +         * When PERFCORE is enabled, AMD PMU uses a separate set of
> +         * addresses for the selector and counter registers.
> +         * Additionally, the address of the next selector or counter
> +         * register is determined by incrementing the address of the
> +         * current register by two.
> +         */
> +        if (num_pmu_gp_counters == AMD64_NUM_COUNTERS_CORE) {
> +            sel_base = MSR_F15H_PERF_CTL0;
> +            ctr_base = MSR_F15H_PERF_CTR0;
> +            step = 2;
> +        }
> +
> +        for (i = 0; i < num_pmu_gp_counters; i++) {
> +            kvm_msr_entry_add(cpu, ctr_base + i * step, 0);
> +            kvm_msr_entry_add(cpu, sel_base + i * step, 0);
> +        }
> +    }
> +
>      if (env->mcg_cap) {
>          kvm_msr_entry_add(cpu, MSR_MCG_STATUS, 0);
>          kvm_msr_entry_add(cpu, MSR_MCG_CTL, 0);
> @@ -4869,6 +5019,21 @@ static int kvm_get_msrs(X86CPU *cpu)
>          case MSR_P6_EVNTSEL0 ... MSR_P6_EVNTSEL0 + MAX_GP_COUNTERS - 1:
>              env->msr_gp_evtsel[index - MSR_P6_EVNTSEL0] = msrs[i].data;
>              break;
> +        case MSR_K7_EVNTSEL0 ... MSR_K7_EVNTSEL0 + AMD64_NUM_COUNTERS - 1:
> +            env->msr_gp_evtsel[index - MSR_K7_EVNTSEL0] = msrs[i].data;
> +            break;
> +        case MSR_K7_PERFCTR0 ... MSR_K7_PERFCTR0 + AMD64_NUM_COUNTERS - 1:
> +            env->msr_gp_counters[index - MSR_K7_PERFCTR0] = msrs[i].data;
> +            break;
> +        case MSR_F15H_PERF_CTL0 ...
> +             MSR_F15H_PERF_CTL0 + AMD64_NUM_COUNTERS_CORE * 2 - 1:
> +            index = index - MSR_F15H_PERF_CTL0;
> +            if (index & 0x1) {
> +                env->msr_gp_counters[index] = msrs[i].data;
> +            } else {
> +                env->msr_gp_evtsel[index] = msrs[i].data;
> +            }
> +            break;
>          case HV_X64_MSR_HYPERCALL:
>              env->msr_hv_hypercall = msrs[i].data;
>              break;

LGTM, but leave it to AMD PMU expert to review.



