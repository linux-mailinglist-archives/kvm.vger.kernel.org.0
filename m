Return-Path: <kvm+bounces-43073-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3114DA83C09
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 10:06:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 45AB98A4FC3
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 08:00:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4AD11E5729;
	Thu, 10 Apr 2025 08:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RYvYr9Uq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B98601C5D7B
	for <kvm@vger.kernel.org>; Thu, 10 Apr 2025 08:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744272050; cv=none; b=G7q3TInqF3WuJ7980rakj3ur9xeD6sH8noawok+1SVDKnEUHve98wkb7gFhEIcPUz9rI9mNJxQ2oSzBUPGFQgCOqhx/Te03ls7vQPDA/GVzXoKeySkq3Ebejd8kGKSMv/9qrS71sCTQKpdRQQ1n05Xm4WiPBI18dVEb3x2XPKXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744272050; c=relaxed/simple;
	bh=Fog4B6Qbd8u1Pqc/gI0bDG41NJadwivsKQhqgMevtPQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q8FketRZ6u4NFHE4k+1klEZwPrj95wefdOPvr8isn9iSP8vt/0iKhIXEyY4pRNUicSMslcmKyIXcqfFRBGSXjgplMIUesYSa41FYkcMojkBvWhXMDw8M64u1MmrkNepyyrDYCq0AfTqNUlghYAwnNF3l3N7VbYXLX8xKvb925uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RYvYr9Uq; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744272048; x=1775808048;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Fog4B6Qbd8u1Pqc/gI0bDG41NJadwivsKQhqgMevtPQ=;
  b=RYvYr9Uqn5Vwi7u7h6cdQ92ip18EVe0jZNFF9edORHK4Ro49C7QU1mjx
   j6Pa900Oy91kRA0CzFQTuUZ0B2WnXbqqgvKZCjaCse+OXkUaWSHBDHnSm
   aH79QzOBlXdyziNBLEi8sg4RLrR23S1Ela3ZfsdPUv+SIO/v1ijYvy/cM
   x2HVI2KYtLHgfqePbVXfFrxBCXpGHqJoiZC6VGh01RG+h3xSgy3p2c4Ki
   vzjaenmQui7Todu9srXdgIzBvhQQEOkdhq2Iuq/JbbWb3qrW0R+2zDOIs
   dCb/6Co3f1nWlElWyyca0le8No9/uDzo3EwxP/VuEbFTEgDI1cNx+c/v9
   w==;
X-CSE-ConnectionGUID: m9FeLZ7eSoCF8j7JshBW7A==
X-CSE-MsgGUID: amlo5lW9TzK2IrCOoEJGpQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11399"; a="45668198"
X-IronPort-AV: E=Sophos;i="6.15,202,1739865600"; 
   d="scan'208";a="45668198"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2025 01:00:39 -0700
X-CSE-ConnectionGUID: GCO21CPgQjmbraiccL1yeA==
X-CSE-MsgGUID: CwIZbOfJSLOTUfZSSHQyug==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,202,1739865600"; 
   d="scan'208";a="134019949"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by orviesa005.jf.intel.com with ESMTP; 10 Apr 2025 01:00:28 -0700
Date: Thu, 10 Apr 2025 16:21:18 +0800
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
Subject: Re: [PATCH v3 09/10] target/i386/kvm: support perfmon-v2 for reset
Message-ID: <Z/d/ft0CufA8prwl@intel.com>
References: <20250331013307.11937-1-dongli.zhang@oracle.com>
 <20250331013307.11937-10-dongli.zhang@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250331013307.11937-10-dongli.zhang@oracle.com>

On Sun, Mar 30, 2025 at 06:32:28PM -0700, Dongli Zhang wrote:
> Date: Sun, 30 Mar 2025 18:32:28 -0700
> From: Dongli Zhang <dongli.zhang@oracle.com>
> Subject: [PATCH v3 09/10] target/i386/kvm: support perfmon-v2 for reset
> X-Mailer: git-send-email 2.43.5
> 
> Since perfmon-v2, the AMD PMU supports additional registers. This update
> includes get/put functionality for these extra registers.
> 
> Similar to the implementation in KVM:
> 
> - MSR_CORE_PERF_GLOBAL_STATUS and MSR_AMD64_PERF_CNTR_GLOBAL_STATUS both
> use env->msr_global_status.
> - MSR_CORE_PERF_GLOBAL_CTRL and MSR_AMD64_PERF_CNTR_GLOBAL_CTL both use
> env->msr_global_ctrl.
> - MSR_CORE_PERF_GLOBAL_OVF_CTRL and MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_CLR
> both use env->msr_global_ovf_ctrl.
> 
> No changes are needed for vmstate_msr_architectural_pmu or
> pmu_enable_needed().
> 
> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
> ---

...

> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index 3a35fd741d..f4532e6f2a 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -2149,6 +2149,16 @@ static void kvm_init_pmu_info_amd(struct kvm_cpuid2 *cpuid, X86CPU *cpu)
>      }
>  
>      num_pmu_gp_counters = AMD64_NUM_COUNTERS_CORE;
> +
> +    c = cpuid_find_entry(cpuid, 0x80000022, 0);
> +    if (c && (c->eax & CPUID_8000_0022_EAX_PERFMON_V2)) {
> +        pmu_version = 2;
> +        num_pmu_gp_counters = c->ebx & 0xf;
> +
> +        if (num_pmu_gp_counters > MAX_GP_COUNTERS) {
> +            num_pmu_gp_counters = MAX_GP_COUNTERS;

OK! KVM now supports 6 GP counters (KVM_MAX_NR_AMD_GP_COUNTERS).

> +        }
> +    }
>  }

Fine for me,

Reviewed-by: Zhao Liu <zhao1.liu@intel.com>


