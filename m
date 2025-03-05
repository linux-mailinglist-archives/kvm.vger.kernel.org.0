Return-Path: <kvm+bounces-40137-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A2F1DA4F7AA
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 08:07:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C47881890FE7
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 07:07:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 363301EA7D9;
	Wed,  5 Mar 2025 07:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EOGyVK+N"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A7C419CC2E
	for <kvm@vger.kernel.org>; Wed,  5 Mar 2025 07:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741158445; cv=none; b=YQXtqOPLTs+mDe/QVE6xKImjR+6XE8gVZs2APq/r7G/TdPG8MpF6+v34t0MJIKWYup2fCmTqRpp8YLiOVPTJ/YSSKX+leRw58Sfi3dCgYJdYP420O6EpVcNJK+F69fAaLjdZvQQy/RGL7OWDdqDVg9KH9g0fYnWIgc9H/2RGjrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741158445; c=relaxed/simple;
	bh=tGcC8AKHL36G6KKjYkJ2djPBvA8fScGzKykiUMbohgA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KuXq8dXEtUvFNo16R05SPK/JwfcANBeaX6GtLk3+jbTvrAApdTge1SXaPtPkJeFJ6TI3lqFu+VtnTegwHFasf0S3AwKYrztwlJnTcY53gu5hXXHCQRxrBFNo4LhCO2Ayx6qg3Raowc+GNlYtRnY9TDJS7uF3f3JUVNObE7zSVAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EOGyVK+N; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741158443; x=1772694443;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=tGcC8AKHL36G6KKjYkJ2djPBvA8fScGzKykiUMbohgA=;
  b=EOGyVK+NbFq6tRHabI5FSMBNeGAShpIQy1d5NkpUp9PAU5W+DtZIfCOg
   SCg+RHOkGkPZY5SEXdmRTHfFPclYwFVAS3SjsgAD1QfFXoFnDc0Ky2gRa
   R4ZadR2IZWCyeeBJUG3LFmbe/rxFL4CuhYhoyntPbfqs2i+nfxd/9fEXU
   5c0tLZa8btovOFU/IOKUlIquk/b/sYfCHHR/uMWaXtNW/ebreQljIAKsA
   rdPmE26O7TxxVtki3SjrOpekEjE7fjZfl0gOSotMawsP4YsBw9DVFA2o5
   snge4SpnrToxlQeuf615OWR+RxSjhQh1hsBQ55wi1adVIO6N/s0vYmKQl
   g==;
X-CSE-ConnectionGUID: W9f5k1MNR4KVV0sdAS9edA==
X-CSE-MsgGUID: b4lMCR7DRhe/EzXvb1VfZQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11363"; a="67475196"
X-IronPort-AV: E=Sophos;i="6.14,222,1736841600"; 
   d="scan'208";a="67475196"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2025 23:07:22 -0800
X-CSE-ConnectionGUID: CngObJnVT/GAgcDIZQc0yw==
X-CSE-MsgGUID: pn+k+QgaRuKQNoXuwC+4UA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,222,1736841600"; 
   d="scan'208";a="123623659"
Received: from unknown (HELO [10.238.2.135]) ([10.238.2.135])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2025 23:07:18 -0800
Message-ID: <d2e9fc7f-76f0-41da-98bc-96886fe9f660@linux.intel.com>
Date: Wed, 5 Mar 2025 15:07:15 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 06/10] target/i386/kvm: rename architectural PMU
 variables
To: Dongli Zhang <dongli.zhang@oracle.com>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org
Cc: pbonzini@redhat.com, zhao1.liu@intel.com, mtosatti@redhat.com,
 sandipan.das@amd.com, babu.moger@amd.com, likexu@tencent.com,
 like.xu.linux@gmail.com, zhenyuw@linux.intel.com, groug@kaod.org,
 khorenko@virtuozzo.com, alexander.ivanov@virtuozzo.com, den@virtuozzo.com,
 davydov-max@yandex-team.ru, xiaoyao.li@intel.com, joe.jin@oracle.com
References: <20250302220112.17653-1-dongli.zhang@oracle.com>
 <20250302220112.17653-7-dongli.zhang@oracle.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20250302220112.17653-7-dongli.zhang@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 3/3/2025 6:00 AM, Dongli Zhang wrote:
> AMD does not have what is commonly referred to as an architectural PMU.
> Therefore, we need to rename the following variables to be applicable for
> both Intel and AMD:
>
> - has_architectural_pmu_version
> - num_architectural_pmu_gp_counters
> - num_architectural_pmu_fixed_counters
>
> For Intel processors, the meaning of has_pmu_version remains unchanged.
>
> For AMD processors:
>
> has_pmu_version == 1 corresponds to versions before AMD PerfMonV2.
> has_pmu_version == 2 corresponds to AMD PerfMonV2.
>
> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
> ---
>  target/i386/kvm/kvm.c | 49 ++++++++++++++++++++++++-------------------
>  1 file changed, 28 insertions(+), 21 deletions(-)
>
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index 8f293ffd61..e895d22f94 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -164,9 +164,16 @@ static bool has_msr_perf_capabs;
>  static bool has_msr_pkrs;
>  static bool has_msr_hwcr;
>  
> -static uint32_t has_architectural_pmu_version;
> -static uint32_t num_architectural_pmu_gp_counters;
> -static uint32_t num_architectural_pmu_fixed_counters;
> +/*
> + * For Intel processors, the meaning is the architectural PMU version
> + * number.
> + *
> + * For AMD processors: 1 corresponds to the prior versions, and 2
> + * corresponds to AMD PerfMonV2.
> + */
> +static uint32_t has_pmu_version;
> +static uint32_t num_pmu_gp_counters;
> +static uint32_t num_pmu_fixed_counters;
>  
>  static int has_xsave2;
>  static int has_xcrs;
> @@ -2072,24 +2079,24 @@ static void kvm_init_pmu_info(CPUX86State *env)
>  
>      cpu_x86_cpuid(env, 0x0a, 0, &eax, &unused, &unused, &edx);
>  
> -    has_architectural_pmu_version = eax & 0xff;
> -    if (has_architectural_pmu_version > 0) {
> -        num_architectural_pmu_gp_counters = (eax & 0xff00) >> 8;
> +    has_pmu_version = eax & 0xff;
> +    if (has_pmu_version > 0) {
> +        num_pmu_gp_counters = (eax & 0xff00) >> 8;
>  
>          /*
>           * Shouldn't be more than 32, since that's the number of bits
>           * available in EBX to tell us _which_ counters are available.
>           * Play it safe.
>           */
> -        if (num_architectural_pmu_gp_counters > MAX_GP_COUNTERS) {
> -            num_architectural_pmu_gp_counters = MAX_GP_COUNTERS;
> +        if (num_pmu_gp_counters > MAX_GP_COUNTERS) {
> +            num_pmu_gp_counters = MAX_GP_COUNTERS;
>          }
>  
> -        if (has_architectural_pmu_version > 1) {
> -            num_architectural_pmu_fixed_counters = edx & 0x1f;
> +        if (has_pmu_version > 1) {
> +            num_pmu_fixed_counters = edx & 0x1f;
>  
> -            if (num_architectural_pmu_fixed_counters > MAX_FIXED_COUNTERS) {
> -                num_architectural_pmu_fixed_counters = MAX_FIXED_COUNTERS;
> +            if (num_pmu_fixed_counters > MAX_FIXED_COUNTERS) {
> +                num_pmu_fixed_counters = MAX_FIXED_COUNTERS;
>              }
>          }
>      }
> @@ -4041,25 +4048,25 @@ static int kvm_put_msrs(X86CPU *cpu, int level)
>              kvm_msr_entry_add(cpu, MSR_KVM_POLL_CONTROL, env->poll_control_msr);
>          }
>  
> -        if (has_architectural_pmu_version > 0) {
> -            if (has_architectural_pmu_version > 1) {
> +        if (has_pmu_version > 0) {
> +            if (has_pmu_version > 1) {
>                  /* Stop the counter.  */
>                  kvm_msr_entry_add(cpu, MSR_CORE_PERF_FIXED_CTR_CTRL, 0);
>                  kvm_msr_entry_add(cpu, MSR_CORE_PERF_GLOBAL_CTRL, 0);
>              }
>  
>              /* Set the counter values.  */
> -            for (i = 0; i < num_architectural_pmu_fixed_counters; i++) {
> +            for (i = 0; i < num_pmu_fixed_counters; i++) {
>                  kvm_msr_entry_add(cpu, MSR_CORE_PERF_FIXED_CTR0 + i,
>                                    env->msr_fixed_counters[i]);
>              }
> -            for (i = 0; i < num_architectural_pmu_gp_counters; i++) {
> +            for (i = 0; i < num_pmu_gp_counters; i++) {
>                  kvm_msr_entry_add(cpu, MSR_P6_PERFCTR0 + i,
>                                    env->msr_gp_counters[i]);
>                  kvm_msr_entry_add(cpu, MSR_P6_EVNTSEL0 + i,
>                                    env->msr_gp_evtsel[i]);
>              }
> -            if (has_architectural_pmu_version > 1) {
> +            if (has_pmu_version > 1) {
>                  kvm_msr_entry_add(cpu, MSR_CORE_PERF_GLOBAL_STATUS,
>                                    env->msr_global_status);
>                  kvm_msr_entry_add(cpu, MSR_CORE_PERF_GLOBAL_OVF_CTRL,
> @@ -4519,17 +4526,17 @@ static int kvm_get_msrs(X86CPU *cpu)
>      if (env->features[FEAT_KVM] & CPUID_KVM_POLL_CONTROL) {
>          kvm_msr_entry_add(cpu, MSR_KVM_POLL_CONTROL, 1);
>      }
> -    if (has_architectural_pmu_version > 0) {
> -        if (has_architectural_pmu_version > 1) {
> +    if (has_pmu_version > 0) {
> +        if (has_pmu_version > 1) {
>              kvm_msr_entry_add(cpu, MSR_CORE_PERF_FIXED_CTR_CTRL, 0);
>              kvm_msr_entry_add(cpu, MSR_CORE_PERF_GLOBAL_CTRL, 0);
>              kvm_msr_entry_add(cpu, MSR_CORE_PERF_GLOBAL_STATUS, 0);
>              kvm_msr_entry_add(cpu, MSR_CORE_PERF_GLOBAL_OVF_CTRL, 0);
>          }
> -        for (i = 0; i < num_architectural_pmu_fixed_counters; i++) {
> +        for (i = 0; i < num_pmu_fixed_counters; i++) {
>              kvm_msr_entry_add(cpu, MSR_CORE_PERF_FIXED_CTR0 + i, 0);
>          }
> -        for (i = 0; i < num_architectural_pmu_gp_counters; i++) {
> +        for (i = 0; i < num_pmu_gp_counters; i++) {
>              kvm_msr_entry_add(cpu, MSR_P6_PERFCTR0 + i, 0);
>              kvm_msr_entry_add(cpu, MSR_P6_EVNTSEL0 + i, 0);
>          }

Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>



