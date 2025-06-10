Return-Path: <kvm+bounces-48798-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 109E4AD2EA9
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 09:29:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DA4713A3B50
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 07:29:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4071427EC99;
	Tue, 10 Jun 2025 07:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MJWWUo2U"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF5D921D594;
	Tue, 10 Jun 2025 07:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749540582; cv=none; b=ECJrP7FNLDv8xoKJkQA2A7sIpb5qgWDUmpAtUbvw9Z5oLSZIBXA7nWBrZYLpMUdNIvJqIC27Fl1UT6TwWQmjRcMSAhx5UzJ0PJYls956L0+paPSafcJH2WeSQCptDKNqMvKehZ+NfYKketLeJ0ZBWwjUhHfWxQgK5miA2ZMyKcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749540582; c=relaxed/simple;
	bh=lAAtMSan3afQSwOuXOhzP3QPjgP54f8sQlMRzRkaed8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hRPmJbMrzGxmTJKtob+tT21JMvPdjkc59KxWJ7R91Y9IQIpHW1/+TQ87POki1Xpig4mtvdfRlM8npS1Upaaf/kHZyvUjHVdaYtwSQNbdquU1GZ2mb5wZzwmDDypghJSDMltfLLazTIU5zLL3TG7YwTdj0qEppQGw2bltqTpfBPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MJWWUo2U; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749540580; x=1781076580;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=lAAtMSan3afQSwOuXOhzP3QPjgP54f8sQlMRzRkaed8=;
  b=MJWWUo2UvhkSoHxRBguU6hLWPzArwXuAKwtO6sI9oDDmgLtKkDclh62Z
   AhIAN7h4NBfJMD7qEoF0roR+pbf6v2FsDsdf8/RIr1Xd1/QYrnqBSVFe/
   Y0YDapkgOR+/oD7CN24+4V/JrEW9eHuup3xGXhbnn9GgHP7llM8mvFOUd
   MAbfsk/Eq0ApyHOcd746qCKhar7NBhzHs4gBuIs94iWCE/rEJamJD++ZB
   nyFR6zQXaweAn4tsKaFmrdlP9DAhFZz9iboxzuMnTa5Y5FC6pVLPpvJLa
   z+Qr7Gcpc9C84itytvcwCNFC7OMj+lw/lOsE35nbwcBQwrZNUPqbSEDGF
   Q==;
X-CSE-ConnectionGUID: iAX+Jv0rRFeMaAEsqKa3uw==
X-CSE-MsgGUID: yK8+I5edS0OiOiYKY/U6pQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11459"; a="63040637"
X-IronPort-AV: E=Sophos;i="6.16,224,1744095600"; 
   d="scan'208";a="63040637"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2025 00:29:39 -0700
X-CSE-ConnectionGUID: YLgeloFCR52uw2jpg7GNVA==
X-CSE-MsgGUID: GWVg24xgTO6ptJ1pznfgfg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,224,1744095600"; 
   d="scan'208";a="147718065"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.245.144]) ([10.124.245.144])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2025 00:29:37 -0700
Message-ID: <0072b2bd-5b3b-46b4-bd60-8b7579aba5c4@linux.intel.com>
Date: Tue, 10 Jun 2025 15:29:34 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH 10/16] x86/pmu: Use X86_PROPERTY_PMU_*
 macros to retrieve PMU information
To: Sean Christopherson <seanjc@google.com>,
 Andrew Jones <andrew.jones@linux.dev>, Janosch Frank
 <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>,
 =?UTF-8?Q?Nico_B=C3=B6hr?= <nrb@linux.ibm.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 kvm@vger.kernel.org
References: <20250529221929.3807680-1-seanjc@google.com>
 <20250529221929.3807680-11-seanjc@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20250529221929.3807680-11-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 5/30/2025 6:19 AM, Sean Christopherson wrote:
> Use the recently introduced X86_PROPERTY_PMU_* macros to get PMU
> information instead of open coding equivalent functionality.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  lib/x86/pmu.c | 18 ++++++++----------
>  1 file changed, 8 insertions(+), 10 deletions(-)
>
> diff --git a/lib/x86/pmu.c b/lib/x86/pmu.c
> index 44449372..c7f7da14 100644
> --- a/lib/x86/pmu.c
> +++ b/lib/x86/pmu.c
> @@ -7,21 +7,19 @@ void pmu_init(void)
>  	pmu.is_intel = is_intel();
>  
>  	if (pmu.is_intel) {
> -		struct cpuid cpuid_10 = cpuid(10);
> -
> -		pmu.version = cpuid_10.a & 0xff;
> +		pmu.version = this_cpu_property(X86_PROPERTY_PMU_VERSION);
>  
>  		if (pmu.version > 1) {
> -			pmu.nr_fixed_counters = cpuid_10.d & 0x1f;
> -			pmu.fixed_counter_width = (cpuid_10.d >> 5) & 0xff;
> +			pmu.nr_fixed_counters = this_cpu_property(X86_PROPERTY_PMU_NR_FIXED_COUNTERS);
> +			pmu.fixed_counter_width = this_cpu_property(X86_PROPERTY_PMU_FIXED_COUNTERS_BIT_WIDTH);
>  		}
>  
> -		pmu.nr_gp_counters = (cpuid_10.a >> 8) & 0xff;
> -		pmu.gp_counter_width = (cpuid_10.a >> 16) & 0xff;
> -		pmu.arch_event_mask_length = (cpuid_10.a >> 24) & 0xff;
> +		pmu.nr_gp_counters = this_cpu_property(X86_PROPERTY_PMU_NR_GP_COUNTERS);
> +		pmu.gp_counter_width = this_cpu_property(X86_PROPERTY_PMU_GP_COUNTERS_BIT_WIDTH);
> +		pmu.arch_event_mask_length = this_cpu_property(X86_PROPERTY_PMU_EBX_BIT_VECTOR_LENGTH);
>  
>  		/* CPUID.0xA.EBX bit is '1' if a counter is NOT available. */
> -		pmu.arch_event_available = ~cpuid_10.b;
> +		pmu.arch_event_available = ~this_cpu_property(X86_PROPERTY_PMU_EVENTS_MASK);
>  
>  		if (this_cpu_has(X86_FEATURE_PDCM))
>  			pmu.perf_cap = rdmsr(MSR_IA32_PERF_CAPABILITIES);
> @@ -38,7 +36,7 @@ void pmu_init(void)
>  			/* Performance Monitoring Version 2 Supported */
>  			if (this_cpu_has(X86_FEATURE_AMD_PMU_V2)) {
>  				pmu.version = 2;
> -				pmu.nr_gp_counters = cpuid(0x80000022).b & 0xf;
> +				pmu.nr_gp_counters = this_cpu_property(X86_PROPERTY_NR_PERFCTR_CORE);
>  			} else {
>  				pmu.nr_gp_counters = AMD64_NUM_COUNTERS_CORE;
>  			}

Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>



