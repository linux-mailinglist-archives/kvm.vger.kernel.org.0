Return-Path: <kvm+bounces-48938-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id ABF51AD47E3
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 03:32:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2769B1892B73
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 01:33:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BD40433B1;
	Wed, 11 Jun 2025 01:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="a/hxFMYa"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 325AD4685
	for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 01:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749605560; cv=none; b=dqnOCMb1CWZQx/XU192e5vEGjYQkgM+EfLVfhMjUHJPseEEv1SITlTz6rxHM8V9BfRUYXvQ9xVyCB4PnX9zvn4U3vchmDzTCrzb1ymeU7O5iz6WncZ41vyEPRWW+PppVeJoGKBQ05WtCpqiYwehlCXfGdJiOqUXIrNOYzn5KVB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749605560; c=relaxed/simple;
	bh=0QDGqUeEraZjO0XLQGBYM1ob1mZ6bU0oH+mjiz4zr6o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eN0xA4+Pz5dkOe0KUZzvcLTqyE0nIOlI4D4tmBrffflIn32Aw/4BCkMb/vvSdvbDwMW5Zftj88FWWbtzN5NqmvBPGOU2rRuW5KT9kgFCY3jn8sg+nIYzSpJBkl0xhXQxY6Xi9uEtfoXFsaeli2QZSuEU1mZVavGMoy9w7UjC1Ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=a/hxFMYa; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749605559; x=1781141559;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=0QDGqUeEraZjO0XLQGBYM1ob1mZ6bU0oH+mjiz4zr6o=;
  b=a/hxFMYa3TdkoBQh9yI78PodjWy2RW2DBslTB6HAdrDdF4T3i2w38vAp
   L1GmeqmOvOA3QkFqWL4isO5IWIHtv26HmebZUOWpckMMBmCFn1BDYVk8k
   tX8EQGhv7dx81K3kDHFFAOsR6qF2M93Ghd/QbqIpGYrEvxTrTgg8dZYdf
   FUdos4mA9EI5QvCyAIkpcXLxoVH2XdYuej6Np2svS/r1iUxBkfPPNdZWH
   Pt7lvl7NuHq7sqJM8mI77pKI1FGQh6WgMfZZQiV1mPaskiYblVEYsrGTe
   Ig3QUWBbNq1C/9XhkyUImJjIAeVMrAJ2N8qhpDpKDschGnVSxZzOvdLU2
   w==;
X-CSE-ConnectionGUID: sBw6vSa/Rs27jdNrOWeUEQ==
X-CSE-MsgGUID: 3AUhKCFKQw+yUy2e4QCajw==
X-IronPort-AV: E=McAfee;i="6800,10657,11460"; a="51726180"
X-IronPort-AV: E=Sophos;i="6.16,226,1744095600"; 
   d="scan'208";a="51726180"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2025 18:32:38 -0700
X-CSE-ConnectionGUID: 8gTYHTicREiRCn1W9VrIIA==
X-CSE-MsgGUID: xdQXaEB5TiKZVGCPOW6ypw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,226,1744095600"; 
   d="scan'208";a="177922924"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.245.144]) ([10.124.245.144])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2025 18:32:36 -0700
Message-ID: <a6465f46-4ab8-418e-b10d-d85e288562a7@linux.intel.com>
Date: Wed, 11 Jun 2025 09:32:34 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v2 06/14] x86/pmu: Mark all arch events as
 available on AMD, and rename fields
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Liam Merwick <liam.merwick@oracle.com>
References: <20250610195415.115404-1-seanjc@google.com>
 <20250610195415.115404-7-seanjc@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20250610195415.115404-7-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 6/11/2025 3:54 AM, Sean Christopherson wrote:
> Mark all arch events as available on AMD, as AMD PMUs don't provide the
> "not available" CPUID field, and the number of GP counters has nothing to
> do with which architectural events are available/supported.
>
> Rename gp_counter_mask_length to arch_event_mask_length, and
> pmu_gp_counter_is_available() to pmu_arch_event_is_available(), to
> reflect what the field and helper actually track.
>
> Cc: Dapeng Mi <dapeng1.mi@linux.intel.com>
> Fixes: b883751a ("x86/pmu: Update testcases to cover AMD PMU")
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  lib/x86/pmu.c | 10 +++++-----
>  lib/x86/pmu.h |  8 ++++----
>  x86/pmu.c     |  8 ++++----
>  3 files changed, 13 insertions(+), 13 deletions(-)
>
> diff --git a/lib/x86/pmu.c b/lib/x86/pmu.c
> index d06e9455..d37c874c 100644
> --- a/lib/x86/pmu.c
> +++ b/lib/x86/pmu.c
> @@ -18,10 +18,10 @@ void pmu_init(void)
>  
>  		pmu.nr_gp_counters = (cpuid_10.a >> 8) & 0xff;
>  		pmu.gp_counter_width = (cpuid_10.a >> 16) & 0xff;
> -		pmu.gp_counter_mask_length = (cpuid_10.a >> 24) & 0xff;
> +		pmu.arch_event_mask_length = (cpuid_10.a >> 24) & 0xff;
>  
> -		/* CPUID.0xA.EBX bit is '1' if a counter is NOT available. */
> -		pmu.gp_counter_available = ~cpuid_10.b;
> +		/* CPUID.0xA.EBX bit is '1' if an arch event is NOT available. */
> +		pmu.arch_event_available = ~cpuid_10.b;
>  
>  		if (this_cpu_has(X86_FEATURE_PDCM))
>  			pmu.perf_cap = rdmsr(MSR_IA32_PERF_CAPABILITIES);
> @@ -50,8 +50,8 @@ void pmu_init(void)
>  			pmu.msr_gp_event_select_base = MSR_K7_EVNTSEL0;
>  		}
>  		pmu.gp_counter_width = PMC_DEFAULT_WIDTH;
> -		pmu.gp_counter_mask_length = pmu.nr_gp_counters;
> -		pmu.gp_counter_available = (1u << pmu.nr_gp_counters) - 1;
> +		pmu.arch_event_mask_length = 32;
> +		pmu.arch_event_available = -1u;
>  
>  		if (this_cpu_has_perf_global_status()) {
>  			pmu.msr_global_status = MSR_AMD64_PERF_CNTR_GLOBAL_STATUS;
> diff --git a/lib/x86/pmu.h b/lib/x86/pmu.h
> index f07fbd93..c7dc68c1 100644
> --- a/lib/x86/pmu.h
> +++ b/lib/x86/pmu.h
> @@ -63,8 +63,8 @@ struct pmu_caps {
>  	u8 fixed_counter_width;
>  	u8 nr_gp_counters;
>  	u8 gp_counter_width;
> -	u8 gp_counter_mask_length;
> -	u32 gp_counter_available;
> +	u8 arch_event_mask_length;
> +	u32 arch_event_available;
>  	u32 msr_gp_counter_base;
>  	u32 msr_gp_event_select_base;
>  
> @@ -110,9 +110,9 @@ static inline bool this_cpu_has_perf_global_status(void)
>  	return pmu.version > 1;
>  }
>  
> -static inline bool pmu_gp_counter_is_available(int i)
> +static inline bool pmu_arch_event_is_available(int i)
>  {
> -	return pmu.gp_counter_available & BIT(i);
> +	return pmu.arch_event_available & BIT(i);
>  }
>  
>  static inline u64 pmu_lbr_version(void)
> diff --git a/x86/pmu.c b/x86/pmu.c
> index 45c6db3c..e79122ed 100644
> --- a/x86/pmu.c
> +++ b/x86/pmu.c
> @@ -436,7 +436,7 @@ static void check_gp_counters(void)
>  	int i;
>  
>  	for (i = 0; i < gp_events_size; i++)
> -		if (pmu_gp_counter_is_available(i))
> +		if (pmu_arch_event_is_available(i))
>  			check_gp_counter(&gp_events[i]);
>  		else
>  			printf("GP event '%s' is disabled\n",
> @@ -463,7 +463,7 @@ static void check_counters_many(void)
>  	int i, n;
>  
>  	for (i = 0, n = 0; n < pmu.nr_gp_counters; i++) {
> -		if (!pmu_gp_counter_is_available(i))
> +		if (!pmu_arch_event_is_available(i))
>  			continue;
>  
>  		cnt[n].ctr = MSR_GP_COUNTERx(n);
> @@ -902,7 +902,7 @@ static void set_ref_cycle_expectations(void)
>  	uint64_t t0, t1, t2, t3;
>  
>  	/* Bit 2 enumerates the availability of reference cycles events. */
> -	if (!pmu.nr_gp_counters || !pmu_gp_counter_is_available(2))
> +	if (!pmu.nr_gp_counters || !pmu_arch_event_is_available(2))
>  		return;
>  
>  	t0 = fenced_rdtsc();
> @@ -992,7 +992,7 @@ int main(int ac, char **av)
>  	printf("PMU version:         %d\n", pmu.version);
>  	printf("GP counters:         %d\n", pmu.nr_gp_counters);
>  	printf("GP counter width:    %d\n", pmu.gp_counter_width);
> -	printf("Mask length:         %d\n", pmu.gp_counter_mask_length);
> +	printf("Event Mask length:   %d\n", pmu.arch_event_mask_length);
>  	printf("Fixed counters:      %d\n", pmu.nr_fixed_counters);
>  	printf("Fixed counter width: %d\n", pmu.fixed_counter_width);
>  

Tested this patch on Intel platform (Sapphire Rapids). No issue found.

Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>

Tested-by: Dapeng Mi <dapeng1.mi@linux.intel.com>



