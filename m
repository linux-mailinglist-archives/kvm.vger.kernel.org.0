Return-Path: <kvm+bounces-58111-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E191B87F01
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 07:45:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E2664189061E
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 05:45:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FCBB2727EE;
	Fri, 19 Sep 2025 05:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HAIuirTt"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B70526C3B6;
	Fri, 19 Sep 2025 05:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758260691; cv=none; b=PB3h36oYQXD2XDbAosmbd3A8gkmyapxMeGEFrXEulc+iii5EoghQ5BoIOoF+HIy0iybV+5hH6u6HmP/kIdYjOHD+jYR7r+K49pevlDbGgPLHCN7JB9Vk1XMsAl0iHVJ952WK6KqkoSyq0x8+ANVRm8+kh4h3hkBRUcMLeQzSqbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758260691; c=relaxed/simple;
	bh=yYDrj1Q3YIuoH7aynkd4dfJkrz+UBaKIjE8ZH/MU/3A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=i+Qajo2Tn9igpy4RF/ZabHzJj/7GfiPrSFSKwuxFWJd3yl1fBgfyqp8Mj93RkWmibjJuMk+JYQseSOAKHFC+mGXh0/GsXmuv9jsQVfjGsb4Rnd8nzKGGulMw6Xu4dYZNx53vvoARStHyQThav9EigNLfAVl8yMK3i/79d9FVRi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HAIuirTt; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758260690; x=1789796690;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=yYDrj1Q3YIuoH7aynkd4dfJkrz+UBaKIjE8ZH/MU/3A=;
  b=HAIuirTtKGLmTfOCRZggtZWdBbtMh18lcVR936R25K78sFuYCD5ND3ve
   eH7wEkVn5gpgtBSIY1O/rNfUX+Ydp0tYt9PINcUzD9oQFtoS/ttRTKavR
   vje6yyy+tSERmpcm09ox/hH9QWaWCDUK0z94oTnHEZp94oE9jEdIbi7VV
   dDxEjdKIe9m8bQyCcvamIyw+nW5w4ytEjbC3MO0tBZFN4gjmmmZbv1q8B
   QbBUEK/kpA/Kc06lgHkhlJAeRjdB+8zIPTdMtaazSx0MQRFsqGk2nSJu8
   7uxH/DsQAdAmWaABvkgZ3UWc6tAbVR94mPOcp7ce/PDmDi792389mHBGp
   Q==;
X-CSE-ConnectionGUID: D5BmgCxXRUiwK8uKPU56Rg==
X-CSE-MsgGUID: qSODObyDTm6pSdbPfwGJkQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11557"; a="60667001"
X-IronPort-AV: E=Sophos;i="6.18,277,1751266800"; 
   d="scan'208";a="60667001"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2025 22:44:49 -0700
X-CSE-ConnectionGUID: x7gkzqKJT16YD3bybBbVYA==
X-CSE-MsgGUID: Mp5vveOfQui3I32fwrwfgQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,277,1751266800"; 
   d="scan'208";a="174864385"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.233.177]) ([10.124.233.177])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2025 22:44:48 -0700
Message-ID: <d3634d74-bbd3-4c4c-a0d9-a0759dbad208@linux.intel.com>
Date: Fri, 19 Sep 2025 13:44:44 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/5] KVM: selftests: Reduce number of "unavailable PMU
 events" combos tested
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Yi Lai <yi1.lai@intel.com>, dongsheng <dongsheng.x.zhang@intel.com>
References: <20250919004512.1359828-1-seanjc@google.com>
 <20250919004512.1359828-4-seanjc@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20250919004512.1359828-4-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 9/19/2025 8:45 AM, Sean Christopherson wrote:
> Reduce the number of combinations of unavailable PMU events masks that are
> testing by the PMU counters test.  In reality, testing every possible
> combination isn't all that interesting, and certainly not worth the tens
> of seconds (or worse, minutes) of runtime.  Fully testing the N^2 space
> will be especially problematic in the near future, as 5! new arch events
> are on their way.
>
> Use alternating bit patterns (and 0 and -1u) in the hopes that _if_ there
> is ever a KVM bug, it's not something horribly convoluted that shows up
> only with a super specific pattern/value.
>
> Reported-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  .../selftests/kvm/x86/pmu_counters_test.c     | 38 +++++++++++--------
>  1 file changed, 23 insertions(+), 15 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/x86/pmu_counters_test.c b/tools/testing/selftests/kvm/x86/pmu_counters_test.c
> index cfeed0103341..e805882bc306 100644
> --- a/tools/testing/selftests/kvm/x86/pmu_counters_test.c
> +++ b/tools/testing/selftests/kvm/x86/pmu_counters_test.c
> @@ -577,6 +577,26 @@ static void test_intel_counters(void)
>  		PMU_CAP_FW_WRITES,
>  	};
>  
> +	/*
> +	 * To keep the total runtime reasonable, test only a handful of select,
> +	 * semi-arbitrary values for the mask of unavailable PMU events.  Test
> +	 * 0 (all events available) and all ones (no events available) as well
> +	 * as alternating bit sequencues, e.g. to detect if KVM is checking the
> +	 * wrong bit(s).
> +	 */
> +	const uint32_t unavailable_masks[] = {
> +		0x0,
> +		0xffffffffu,
> +		0xaaaaaaaau,
> +		0x55555555u,
> +		0xf0f0f0f0u,
> +		0x0f0f0f0fu,
> +		0xa0a0a0a0u,
> +		0x0a0a0a0au,
> +		0x50505050u,
> +		0x05050505u,
> +	};
> +
>  	/*
>  	 * Test up to PMU v5, which is the current maximum version defined by
>  	 * Intel, i.e. is the last version that is guaranteed to be backwards
> @@ -614,16 +634,7 @@ static void test_intel_counters(void)
>  
>  			pr_info("Testing arch events, PMU version %u, perf_caps = %lx\n",
>  				v, perf_caps[i]);
> -			/*
> -			 * To keep the total runtime reasonable, test every
> -			 * possible non-zero, non-reserved bitmap combination
> -			 * only with the native PMU version and the full bit
> -			 * vector length.
> -			 */
> -			if (v == pmu_version) {
> -				for (k = 1; k < (BIT(NR_INTEL_ARCH_EVENTS) - 1); k++)
> -					test_arch_events(v, perf_caps[i], NR_INTEL_ARCH_EVENTS, k);
> -			}
> +
>  			/*
>  			 * Test single bits for all PMU version and lengths up
>  			 * the number of events +1 (to verify KVM doesn't do
> @@ -632,11 +643,8 @@ static void test_intel_counters(void)
>  			 * ones i.e. all events being available and unavailable.
>  			 */
>  			for (j = 0; j <= NR_INTEL_ARCH_EVENTS + 1; j++) {
> -				test_arch_events(v, perf_caps[i], j, 0);
> -				test_arch_events(v, perf_caps[i], j, -1u);
> -
> -				for (k = 0; k < NR_INTEL_ARCH_EVENTS; k++)
> -					test_arch_events(v, perf_caps[i], j, BIT(k));
> +				for (k = 1; k < ARRAY_SIZE(unavailable_masks); k++)
> +					test_arch_events(v, perf_caps[i], j, unavailable_masks[k]);
>  			}
>  
>  			pr_info("Testing GP counters, PMU version %u, perf_caps = %lx\n",

LGTM.

Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>



