Return-Path: <kvm+bounces-42168-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A886EA7441E
	for <lists+kvm@lfdr.de>; Fri, 28 Mar 2025 07:46:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5B3927A7756
	for <lists+kvm@lfdr.de>; Fri, 28 Mar 2025 06:45:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B24AA211474;
	Fri, 28 Mar 2025 06:46:39 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mx2.zhaoxin.com (mx2.zhaoxin.com [61.152.208.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42364C2C8
	for <kvm@vger.kernel.org>; Fri, 28 Mar 2025 06:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=61.152.208.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743144399; cv=none; b=q6qaPy2fvaKPG9OcuGwrtGACPfavjc8w2YqetjTkgvSbrFl2mF60/OgC7svcKkRizOFcukEfkuEShyCuhawl8gUw99phHPNrmvf+7TY4eSr/S/0yOaqBaZRVRwrvEoNTdzLclHqaVAMbdn3sQwn6Y/YYl8wb57aiQdau9PJpQyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743144399; c=relaxed/simple;
	bh=4bifKUtnw91pNgb9LRonAJTlnH/Z8/Uz/YnGQZH2foo=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=SyYhiQwLsyTLYfoRbcrtJNHyno5ZzuXjSz3lnY4R47ixSGYZXvn+v8RpkrZ+vyWStQn+SmOeDfZg9007q3BIL1EC7VkYTjsjH+/1142XCdRbU+0bzUugnQXJtq3h65KPLJ6tis/mO7Kto5FTaKL7hKLSipSR6AozlkB431K1cPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com; spf=pass smtp.mailfrom=zhaoxin.com; arc=none smtp.client-ip=61.152.208.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zhaoxin.com
X-ASG-Debug-ID: 1743143375-1eb14e79ffeed90001-HEqcsx
Received: from ZXSHMBX1.zhaoxin.com (ZXSHMBX1.zhaoxin.com [10.28.252.163]) by mx2.zhaoxin.com with ESMTP id ESUnGPrVZzb3uQ01 (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO); Fri, 28 Mar 2025 14:29:35 +0800 (CST)
X-Barracuda-Envelope-From: EwanHai-oc@zhaoxin.com
X-Barracuda-RBL-Trusted-Forwarder: 10.28.252.163
Received: from ZXSHMBX2.zhaoxin.com (10.28.252.164) by ZXSHMBX1.zhaoxin.com
 (10.28.252.163) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.44; Fri, 28 Mar
 2025 14:29:35 +0800
Received: from ZXSHMBX2.zhaoxin.com ([fe80::4dfc:4f6a:c0cf:4298]) by
 ZXSHMBX2.zhaoxin.com ([fe80::4dfc:4f6a:c0cf:4298%4]) with mapi id
 15.01.2507.044; Fri, 28 Mar 2025 14:29:35 +0800
X-Barracuda-RBL-Trusted-Forwarder: 10.28.252.163
Received: from [192.168.31.91] (10.28.66.62) by zxbjmbx1.zhaoxin.com
 (10.29.252.163) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.44; Fri, 28 Mar
 2025 14:29:08 +0800
Message-ID: <8a547bf5-bdd4-4a49-883a-02b4aa0cc92c@zhaoxin.com>
Date: Fri, 28 Mar 2025 14:29:05 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 08/10] target/i386/kvm: reset AMD PMU registers during
 VM reset
To: Dongli Zhang <dongli.zhang@oracle.com>, <qemu-devel@nongnu.org>,
	<kvm@vger.kernel.org>
X-ASG-Orig-Subj: Re: [PATCH v2 08/10] target/i386/kvm: reset AMD PMU registers during
 VM reset
CC: <pbonzini@redhat.com>, <zhao1.liu@intel.com>, <mtosatti@redhat.com>,
	<sandipan.das@amd.com>, <babu.moger@amd.com>, <likexu@tencent.com>,
	<like.xu.linux@gmail.com>, <zhenyuw@linux.intel.com>, <groug@kaod.org>,
	<khorenko@virtuozzo.com>, <alexander.ivanov@virtuozzo.com>,
	<den@virtuozzo.com>, <davydov-max@yandex-team.ru>, <xiaoyao.li@intel.com>,
	<dapeng1.mi@linux.intel.com>, <joe.jin@oracle.com>, <ewanhai@zhaoxin.com>,
	<cobechen@zhaoxin.com>, <louisqi@zhaoxin.com>, <liamni@zhaoxin.com>,
	<frankzhu@zhaoxin.com>, <silviazhao@zhaoxin.com>
References: <20250302220112.17653-1-dongli.zhang@oracle.com>
 <20250302220112.17653-9-dongli.zhang@oracle.com>
From: ewanhai <ewanhai-oc@zhaoxin.com>
In-Reply-To: <20250302220112.17653-9-dongli.zhang@oracle.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: ZXSHCAS1.zhaoxin.com (10.28.252.161) To
 zxbjmbx1.zhaoxin.com (10.29.252.163)
X-Moderation-Data: 3/28/2025 2:29:34 PM
X-Barracuda-Connect: ZXSHMBX1.zhaoxin.com[10.28.252.163]
X-Barracuda-Start-Time: 1743143375
X-Barracuda-Encrypted: ECDHE-RSA-AES128-GCM-SHA256
X-Barracuda-URL: https://10.28.252.36:4443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at zhaoxin.com
X-Barracuda-Scan-Msg-Size: 4725
X-Barracuda-BRTS-Status: 1
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.01
X-Barracuda-Spam-Status: No, SCORE=-2.01 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=TRACK_DBX_001
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.139134
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.01 TRACK_DBX_001          Custom rule TRACK_DBX_001

Hi Zhao,

Thank you for pointing out the potential impact on Zhaoxin CPUs!

Hi Dongli,

Zhaoxin (including vendor "__shanghai__" and "centaurhauls")'s PMU is
compatible with Intel, so I have some advice for this patch.

=E5=9C=A8 2025/3/3 06:00, Dongli Zhang =E5=86=99=E9=81=93:
> [snip]
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
> +    return env->cpuid_vendor1 =3D=3D host_cpuid_vendor1 &&
> +           env->cpuid_vendor2 =3D=3D host_cpuid_vendor2 &&
> +           env->cpuid_vendor3 =3D=3D host_cpuid_vendor3;
> +}
Should we consider a special case, such as emulating Intel CPUs on a
Zhaoxin platform, or vice versa? If so, maybe we can write a
'vendor_compatible()' helper. After all, before this patchset, QEMU
supported behavior-similar CPU emulation, e.g., emulating an Intel VCPU on
a Zhaoxin PCPU.
> +static void kvm_init_pmu_info(CPUState *cs)
> +{
> +    X86CPU *cpu =3D X86_CPU(cs);
> +    CPUX86State *env =3D &cpu->env;
> +
> +    /*
> +     * The PMU virtualization is disabled by kvm.enable_pmu=3DN.
> +     */
> +    if (kvm_pmu_disabled) {
> +        return;
> +    }
> +
> +    /*
> +     * It is not supported to virtualize AMD PMU registers on Intel
> +     * processors, nor to virtualize Intel PMU registers on AMD processo=
rs.
> +     */
> +    if (!is_same_vendor(env)) {
> +        return;
> +    }

ditto.

> [snip]
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
We can use "if (IS_INTEL_CPU(env) || IS_ZHAOXIN_CPU(env))" instead. This
helper was introduced to QEMU in commit 5d20aa540b.

The function name kvm_init_pmu_info_"intel"() is acceptable since the
current Zhaoxin and Intel PMU architectures are compatible. However,
if Zhaoxin develop any exclusive features in the future, we can always
implement a separate "zhaoxin" version of the PMU info initialization
function.
> +    } else if (IS_AMD_CPU(env)) {
> +        kvm_init_pmu_info_amd(env);
> +    }
> +}
> +
[snip]
>   int kvm_arch_init_vcpu(CPUState *cs)
>   {
>       struct {
> @@ -2288,7 +2376,7 @@ int kvm_arch_init_vcpu(CPUState *cs)
>       cpuid_i =3D kvm_x86_build_cpuid(env, cpuid_data.entries, cpuid_i);
>       cpuid_data.cpuid.nent =3D cpuid_i;
>  =20
> -    kvm_init_pmu_info(env);
> +    kvm_init_pmu_info(cs);
>  =20
>       if (((env->cpuid_version >> 8)&0xF) >=3D 6
>           && (env->features[FEAT_1_EDX] & (CPUID_MCE | CPUID_MCA)) =3D=3D
> @@ -4064,7 +4152,7 @@ static int kvm_put_msrs(X86CPU *cpu, int level)
>               kvm_msr_entry_add(cpu, MSR_KVM_POLL_CONTROL, env->poll_cont=
rol_msr);
>           }
>  =20
> -        if (has_pmu_version > 0) {
> +        if (IS_INTEL_CPU(env) && has_pmu_version > 0) {
Also use 'if (IS_INTEL_CPU(env) || IS_ZHAOXIN_CPU(env))' instead.
>               if (has_pmu_version > 1) {
>                   /* Stop the counter.  */
>                   kvm_msr_entry_add(cpu, MSR_CORE_PERF_FIXED_CTR_CTRL, 0)=
;
> @@ -4095,6 +4183,38 @@ static int kvm_put_msrs(X86CPU *cpu, int level)
>                                     env->msr_global_ctrl);
>               }
>           }
> +
> +        if (IS_AMD_CPU(env) && has_pmu_version > 0) {
> +            uint32_t sel_base =3D MSR_K7_EVNTSEL0;
> +            uint32_t ctr_base =3D MSR_K7_PERFCTR0;
> ...
[snip]
> @@ -4542,7 +4662,8 @@ static int kvm_get_msrs(X86CPU *cpu)
>       if (env->features[FEAT_KVM] & CPUID_KVM_POLL_CONTROL) {
>           kvm_msr_entry_add(cpu, MSR_KVM_POLL_CONTROL, 1);
>       }
> -    if (has_pmu_version > 0) {
> +
> +    if (IS_INTEL_CPU(env) && has_pmu_version > 0) {
Also use 'if (IS_INTEL_CPU(env) || IS_ZHAOXIN_CPU(env))' instead.
>           if (has_pmu_version > 1) {
>               kvm_msr_entry_add(cpu, MSR_CORE_PERF_FIXED_CTR_CTRL, 0);
>               kvm_msr_entry_add(cpu, MSR_CORE_PERF_GLOBAL_CTRL, 0);
> @@ -4558,6 +4679,35 @@ static int kvm_get_msrs(X86CPU *cpu)
>           }
>       }
>  =20
> +    if (IS_AMD_CPU(env) && has_pmu_version > 0) {
> +        uint32_t sel_base =3D MSR_K7_EVNTSEL0;
> +        uint32_t ctr_base =3D MSR_K7_PERFCTR0;
> ...


