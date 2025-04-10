Return-Path: <kvm+bounces-43066-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D0A7BA83B00
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 09:26:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BB8ED7B2803
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 07:25:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5884321A445;
	Thu, 10 Apr 2025 07:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VhTNbcj6"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0821D20C48B
	for <kvm@vger.kernel.org>; Thu, 10 Apr 2025 07:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744269796; cv=none; b=VmV69/8ps/0VVqK0woGB/6RaMFhB4p8HtrlCjYIsLYvJZ2ER17bXZKBDC4wDW6/1rDE9g91ioe+JgIg+SYH9sF1c1J1fHfO+O44PgJIGsYRGmK8QdRdWByEDWMfQqYWXvbbxQWG2swMc1SjyImCWGoyKAPeQyapxFO80tNzVK2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744269796; c=relaxed/simple;
	bh=Lh9jXEP9tgVr78Y+bjPvBpsrVvBVBSu8yVPe3X6/PBk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iBCvCtNoBTv5oKiLyFkgFCnLPaJ4GkXsKYKAb9Xz//QKw+cou2hOMUL7iS4qWQfNhduEp7XZRWKnrGOsMjwCwEhWLral8SQbDZUz2kcYV3ALnwJbCZc5pm3dHjbANW1h3j6Ld3OImV4jHPSNzK4VtFSPG5aptDlW3Xu1NEhFvho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VhTNbcj6; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744269795; x=1775805795;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Lh9jXEP9tgVr78Y+bjPvBpsrVvBVBSu8yVPe3X6/PBk=;
  b=VhTNbcj6ivpHS94mreeRjoZVBLuutVxKSVGQ3kvNj34XpkGHg8iuB3Qq
   HIhb3U4WK+2aEN1x6cqji6lPGTgEdAan44HwOJkeNpvPnaVxuY7EjAZbY
   qzLKB2i82wIbxxDkUNGEeo2c9QsQaqNZg9l076wrBB4fGdlxb97y/vkHH
   d+EqOU5nZ4xVHpAj5iY6+2W2gkj7wT38UnjXYVmJ31LxdNegrtYXIrLJm
   drh7J2mtICXhGxO463eNAdPXuli3Lw3Z/K6GkVXTKMIQeHwtfA6YOsCCb
   WLO+cxH1o10n+O+giwCy+Z2pfjvfOnE9r9RWdjMl0vMreWtanTI0SjAL0
   Q==;
X-CSE-ConnectionGUID: 01AE9ilmTMqsJLNPGoorGw==
X-CSE-MsgGUID: 61dDtYBYRRqQIyL/iWY16g==
X-IronPort-AV: E=McAfee;i="6700,10204,11399"; a="48477552"
X-IronPort-AV: E=Sophos;i="6.15,202,1739865600"; 
   d="scan'208";a="48477552"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2025 00:23:14 -0700
X-CSE-ConnectionGUID: XUminAD6T0GYkRlVFemdzg==
X-CSE-MsgGUID: pctWMc5OS/GsMX0hxH8+og==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,202,1739865600"; 
   d="scan'208";a="128681029"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by fmviesa006.fm.intel.com with ESMTP; 10 Apr 2025 00:23:05 -0700
Date: Thu, 10 Apr 2025 15:43:53 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Dongli Zhang <dongli.zhang@oracle.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, qemu-arm@nongnu.org,
	qemu-ppc@nongnu.org, qemu-riscv@nongnu.org, qemu-s390x@nongnu.org,
	pbonzini@redhat.com, mtosatti@redhat.com, sandipan.das@amd.com,
	babu.moger@amd.com, likexu@tencent.com, like.xu.linux@gmail.com,
	groug@kaod.org, khorenko@virtuozzo.com,
	alexander.ivanov@virtuozzo.com, den@virtuozzo.com,
	davydov-max@yandex-team.ru, xiaoyao.li@intel.com,
	dapeng1.mi@linux.intel.com, joe.jin@oracle.com,
	peter.maydell@linaro.org, gaosong@loongson.cn,
	chenhuacai@kernel.org, philmd@linaro.org, aurelien@aurel32.net,
	jiaxun.yang@flygoat.com, arikalo@gmail.com, npiggin@gmail.com,
	danielhb413@gmail.com, palmer@dabbelt.com, alistair.francis@wdc.com,
	liwei1518@gmail.com, zhiwei_liu@linux.alibaba.com,
	pasic@linux.ibm.com, borntraeger@linux.ibm.com,
	richard.henderson@linaro.org, david@redhat.com, iii@linux.ibm.com,
	thuth@redhat.com, flavra@baylibre.com, ewanhai-oc@zhaoxin.com,
	ewanhai@zhaoxin.com, cobechen@zhaoxin.com, louisqi@zhaoxin.com,
	liamni@zhaoxin.com, frankzhu@zhaoxin.com, silviazhao@zhaoxin.com
Subject: Re: [PATCH v3 08/10] target/i386/kvm: reset AMD PMU registers during
 VM reset
Message-ID: <Z/d2ucu6Y5xlNh6S@intel.com>
References: <20250331013307.11937-1-dongli.zhang@oracle.com>
 <20250331013307.11937-9-dongli.zhang@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250331013307.11937-9-dongli.zhang@oracle.com>

...

> TODO:
>   - This patch adds is_host_compat_vendor(), while there are something
>     like is_host_cpu_intel() from target/i386/kvm/vmsr_energy.c. A rework
>     may help move those helpers to target/i386/cpu*.

vmsr_energy emulates RAPL in user space...but RAPL is not architectural
(no CPUID), so this case doesn't need to consider "compat" vendor.

>  target/i386/cpu.h     |   8 ++
>  target/i386/kvm/kvm.c | 176 +++++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 180 insertions(+), 4 deletions(-)

...

> +static bool is_host_compat_vendor(CPUX86State *env)
> +{
> +    char host_vendor[CPUID_VENDOR_SZ + 1];
> +    uint32_t host_cpuid_vendor1;
> +    uint32_t host_cpuid_vendor2;
> +    uint32_t host_cpuid_vendor3;
>
> +    host_cpuid(0x0, 0, NULL, &host_cpuid_vendor1, &host_cpuid_vendor3,
> +               &host_cpuid_vendor2);
> +
> +    x86_cpu_vendor_words2str(host_vendor, host_cpuid_vendor1,
> +                             host_cpuid_vendor2, host_cpuid_vendor3);

We can use host_cpu_vendor_fms() (with a little change). If you like
this idea, pls feel free to pick my cleanup patch into your series.

> +    /*
> +     * Intel and Zhaoxin are compatible.
> +     */
> +    if ((g_str_equal(host_vendor, CPUID_VENDOR_INTEL) ||
> +         g_str_equal(host_vendor, CPUID_VENDOR_ZHAOXIN1) ||
> +         g_str_equal(host_vendor, CPUID_VENDOR_ZHAOXIN2)) &&
> +        (IS_INTEL_CPU(env) || IS_ZHAOXIN_CPU(env))) {
> +        return true;
> +    }
> +
> +    return env->cpuid_vendor1 == host_cpuid_vendor1 &&
> +           env->cpuid_vendor2 == host_cpuid_vendor2 &&
> +           env->cpuid_vendor3 == host_cpuid_vendor3;

Checking AMD directly makes the "compat" rule clear:

    return g_str_equal(host_vendor, CPUID_VENDOR_AMD) &&
           IS_AMD_CPU(env);

> +}

...

>      if (env->mcg_cap) {
>          kvm_msr_entry_add(cpu, MSR_MCG_STATUS, 0);
>          kvm_msr_entry_add(cpu, MSR_MCG_CTL, 0);
> @@ -4871,6 +5024,21 @@ static int kvm_get_msrs(X86CPU *cpu)
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

This msr_gp_evtsel[] array's size is 18:

#define MAX_GP_COUNTERS    (MSR_IA32_PERF_STATUS - MSR_P6_EVNTSEL0)

This formula is based on Intel's MSR, it's best to add a note that the
current size also meets AMD's needs. (No need to adjust the size, as
it will affect migration).

> +            }
> +            break;
>          case HV_X64_MSR_HYPERCALL:
>              env->msr_hv_hypercall = msrs[i].data;
>              break;

Others LGTM!

Thanks,
Zhao


