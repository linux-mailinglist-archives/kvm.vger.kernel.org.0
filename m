Return-Path: <kvm+bounces-1459-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C63FB7E7CA3
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 14:48:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4ABC7B20CCA
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 13:48:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01D7D1A73C;
	Fri, 10 Nov 2023 13:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SzvoKxA9"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9BAE19BAF
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 13:48:45 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADB7EA752C;
	Fri, 10 Nov 2023 05:48:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699624122; x=1731160122;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=i4DGycXr5ls5BoujGjeZj8UmFRoUHSyqGt7yLUkrRBM=;
  b=SzvoKxA9GZuawdbURVB17nAqv5ZuxtmLb/mB7aenLcP/AiZEeeHNUhfu
   GcKwxrKICtZ0lDNAbKEFa0mRcy2DAQEC6gz8ED0c5vEN5PaPdU2fJiLx7
   cWoBdcr7O81akw9xi3AkqwP4lBq4bymzJ55RD0UJ+WL4+2SsmLU36VrWU
   aDkoYDwY1LFd3Vo/QCBqajD8zPgECrCTGxqjlstOzwf/Ff8OzoHO4GFTj
   Wwl5/E4z6ZRBjy6uQ6Aj1B8YqF/uYkyCR/YcTIvrpB9x2YEjBKF3lkHO+
   h5G0Na9WA292cg2u3jBHjq5xlV87CFAzaP6mWixtEZ2NR1DdYFZGi3Rsx
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10890"; a="389044834"
X-IronPort-AV: E=Sophos;i="6.03,291,1694761200"; 
   d="scan'208";a="389044834"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2023 05:48:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10890"; a="763762260"
X-IronPort-AV: E=Sophos;i="6.03,291,1694761200"; 
   d="scan'208";a="763762260"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2023 05:48:42 -0800
Received: from [10.212.121.231] (shassa2x-mobl1.gar.corp.intel.com [10.212.121.231])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by linux.intel.com (Postfix) with ESMTPS id BFD8D580D69;
	Fri, 10 Nov 2023 05:48:40 -0800 (PST)
Message-ID: <2f306eda-953b-4390-8db1-0b3ab4e16213@linux.intel.com>
Date: Fri, 10 Nov 2023 08:48:39 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 05/26] KVM: x86/pmu: Get eventsel for fixed counters
 from perf
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Dapeng Mi <dapeng1.mi@linux.intel.com>, Jim Mattson <jmattson@google.com>,
 Jinrong Liang <cloudliang@tencent.com>, Aaron Lewis <aaronlewis@google.com>,
 Like Xu <likexu@tencent.com>
References: <20231110021306.1269082-1-seanjc@google.com>
 <20231110021306.1269082-6-seanjc@google.com>
Content-Language: en-US
From: "Liang, Kan" <kan.liang@linux.intel.com>
In-Reply-To: <20231110021306.1269082-6-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2023-11-09 9:12 p.m., Sean Christopherson wrote:
> Get the event selectors used to effectively request fixed counters for
> perf events from perf itself instead of hardcoding them in KVM and hoping
> that they match the underlying hardware.  While fixed counters 0 and 1 use
> architectural events, as of ffbe4ab0beda ("perf/x86/intel: Extend the
> ref-cycles event to GP counters") fixed counter 2 (reference TSC cycles)
> may use a software-defined pseudo-encoding or a real hardware-defined
> encoding.
> 
> Reported-by: Kan Liang <kan.liang@linux.intel.com>
> Closes: https://lkml.kernel.org/r/4281eee7-6423-4ec8-bb18-c6aeee1faf2c%40linux.intel.com
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---

Reviewed-by: Kan Liang <kan.liang@linux.intel.com>

Thanks,
Kan
>  arch/x86/kvm/vmx/pmu_intel.c | 30 +++++++++++++++++-------------
>  1 file changed, 17 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> index c9df139efc0c..3bac3b32b485 100644
> --- a/arch/x86/kvm/vmx/pmu_intel.c
> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> @@ -406,24 +406,28 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   * result is the same (ignoring the fact that using a general purpose counter
>   * will likely exacerbate counter contention).
>   *
> - * Note, reference cycles is counted using a perf-defined "psuedo-encoding",
> - * as there is no architectural general purpose encoding for reference cycles.
> + * Forcibly inlined to allow asserting on @index at build time, and there should
> + * never be more than one user.
>   */
> -static u64 intel_get_fixed_pmc_eventsel(int index)
> +static __always_inline u64 intel_get_fixed_pmc_eventsel(unsigned int index)
>  {
> -	const struct {
> -		u8 event;
> -		u8 unit_mask;
> -	} fixed_pmc_events[] = {
> -		[0] = { 0xc0, 0x00 }, /* Instruction Retired / PERF_COUNT_HW_INSTRUCTIONS. */
> -		[1] = { 0x3c, 0x00 }, /* CPU Cycles/ PERF_COUNT_HW_CPU_CYCLES. */
> -		[2] = { 0x00, 0x03 }, /* Reference Cycles / PERF_COUNT_HW_REF_CPU_CYCLES*/
> +	const enum perf_hw_id fixed_pmc_perf_ids[] = {
> +		[0] = PERF_COUNT_HW_INSTRUCTIONS,
> +		[1] = PERF_COUNT_HW_CPU_CYCLES,
> +		[2] = PERF_COUNT_HW_REF_CPU_CYCLES,
>  	};
> +	u64 eventsel;
>  
> -	BUILD_BUG_ON(ARRAY_SIZE(fixed_pmc_events) != KVM_PMC_MAX_FIXED);
> +	BUILD_BUG_ON(ARRAY_SIZE(fixed_pmc_perf_ids) != KVM_PMC_MAX_FIXED);
> +	BUILD_BUG_ON(index >= KVM_PMC_MAX_FIXED);
>  
> -	return (fixed_pmc_events[index].unit_mask << 8) |
> -		fixed_pmc_events[index].event;
> +	/*
> +	 * Yell if perf reports support for a fixed counter but perf doesn't
> +	 * have a known encoding for the associated general purpose event.
> +	 */
> +	eventsel = perf_get_hw_event_config(fixed_pmc_perf_ids[index]);
> +	WARN_ON_ONCE(!eventsel && index < kvm_pmu_cap.num_counters_fixed);
> +	return eventsel;
>  }
>  
>  static void intel_pmu_refresh(struct kvm_vcpu *vcpu)

