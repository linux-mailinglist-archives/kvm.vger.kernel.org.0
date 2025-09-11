Return-Path: <kvm+bounces-57269-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CF013B525E5
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 03:42:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E1F581B243F6
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 01:42:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBDEF20E011;
	Thu, 11 Sep 2025 01:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="g71JBFKK"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 227A91E3DCF;
	Thu, 11 Sep 2025 01:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757554926; cv=none; b=hfBz+i+l64uNXWY6msJAjGgzRhl9KjRgx4AFIKpKrke0aQTv7CKO0JyvAxhO3zyFEkGnaUIMu54JiAdCbxRY4UTasSNjFWJ2ny90U/le3XQlQ3U7nFWUC16bMtQTXtEoG9SchNYF2rxdboC0ET7WBvdY9ajRp/MeaBsa/7OCRNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757554926; c=relaxed/simple;
	bh=OLQaS2gRdqg4w8Ub5cQaE+UPyxaGSnZ/EID3luKpLnc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=O5rGRrtknWuuJoNzYrd3Y28asxIka+3lV+9e34wkE22UGln0Wg7xDspEJ6AGUbJezYLZyla7QzTIaLS36eDOS3ICY4OC0rULRVojbM7XflERZCOT9m0wTw0OqEx3DzZiq1Kozwg+2IBrNGXZZOEVYfuWm6vyZqel+ZuhQbLswAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=g71JBFKK; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757554924; x=1789090924;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=OLQaS2gRdqg4w8Ub5cQaE+UPyxaGSnZ/EID3luKpLnc=;
  b=g71JBFKKkpqlm6XXUR9rYUxjPN3dspdsFGBT7odTZ0fihHH8npIzWh8O
   hPet0ifSkjxdkcxxk+FX8XBo7aEApbGKzC8ORhsiZigN8MnDsv1neEe+W
   EMyqxzLQFdf2oGCYYCEjmDfxP7NzAo8qQQex3AWZipE3nK3wEXw1Rw/Ut
   CD9eFBzVvFLdOeIN8k5I9nqtVX6SNe73fxnUEYqeZ/BAS6FRtGrmAOgZU
   b4WIan4D+wbfOznS6Qzfpimg9kjBtONyEYSqHoVWPlxsqKKj/E6PdxoZx
   BmGeKs6TV4XiIOcCNcICRpfg/UCuXFRiqNFyG3QZ608ZIN1X7C0POjaH3
   A==;
X-CSE-ConnectionGUID: BeoyfMdSRu6QoJB8Bhyjgw==
X-CSE-MsgGUID: 0L+97gdTRJCjln9CVH2B2g==
X-IronPort-AV: E=McAfee;i="6800,10657,11549"; a="71258736"
X-IronPort-AV: E=Sophos;i="6.18,256,1751266800"; 
   d="scan'208";a="71258736"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2025 18:42:03 -0700
X-CSE-ConnectionGUID: V/4WYwkxRbeiNetauNkHbg==
X-CSE-MsgGUID: 7IB96zRxTIu9sp8LY7LiAQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,256,1751266800"; 
   d="scan'208";a="172738171"
Received: from unknown (HELO [10.238.3.254]) ([10.238.3.254])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2025 18:42:00 -0700
Message-ID: <727fbc0a-7edf-46a3-abaf-90ef32615b04@linux.intel.com>
Date: Thu, 11 Sep 2025 09:41:57 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/5] KVM: Selftests: Validate more arch-events in
 pmu_counters_test
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>,
 Mingwei Zhang <mizhang@google.com>, Zide Chen <zide.chen@intel.com>,
 Das Sandipan <Sandipan.Das@amd.com>, Shukla Manali <Manali.Shukla@amd.com>,
 Yi Lai <yi1.lai@intel.com>, Dapeng Mi <dapeng1.mi@intel.com>
References: <20250718001905.196989-1-dapeng1.mi@linux.intel.com>
 <20250718001905.196989-4-dapeng1.mi@linux.intel.com>
 <aMIO5ZLNur5JkdYl@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <aMIO5ZLNur5JkdYl@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 9/11/2025 7:51 AM, Sean Christopherson wrote:
> On Fri, Jul 18, 2025, Dapeng Mi wrote:
>> Clearwater Forest introduces 5 new architectural events (4 topdown
>> level 1 metrics events and LBR inserts event). This patch supports
>> to validate these 5 newly added events. The detailed info about these
>> 5 events can be found in SDM section 21.2.7 "Pre-defined Architectural
>>  Performance Events".
>>
>> It becomes unrealistic to traverse all possible combinations of
>> unavailable events mask (may need dozens of minutes to finish all
>> possible combination validation). So only limit unavailable events mask
>> traverse to the first 8 arch-events.
> Split these into separate patches.  Buring a meaningful change like this in a big
> patch that seemingly just adds architectural collateral is pure evil.
>> @@ -612,15 +620,19 @@ static void test_intel_counters(void)
>>  			pr_info("Testing arch events, PMU version %u, perf_caps = %lx\n",
>>  				v, perf_caps[i]);
>>  			/*
>> -			 * To keep the total runtime reasonable, test every
>> -			 * possible non-zero, non-reserved bitmap combination
>> -			 * only with the native PMU version and the full bit
>> -			 * vector length.
>> +			 * To keep the total runtime reasonable, especially after
>> +			 * the total number of arch-events increasing to 13, It's
>> +			 * impossible to test every possible non-zero, non-reserved
>> +			 * bitmap combination. Only test the first 8-bits combination
>> +			 * with the native PMU version and the full bit vector length.
>>  			 */
>>  			if (v == pmu_version) {
>> -				for (k = 1; k < (BIT(NR_INTEL_ARCH_EVENTS) - 1); k++)
>> +				int max_events = min(NR_INTEL_ARCH_EVENTS, 8);
> Too arbitrary, and worse, bad coverage.  And honestly, even iterating over 255
> (or 512?) different values is a waste of time.  Ha!  And test_arch_events() is
> buggy, it takes unavailable_mask as u8 instead of a u32.  I'll slot in a patch
> to fix that.
>
> As for the runtime, I think it's time to throw in the towel in terms of brute
> forcing the validation space, and just test a handful of hopefully-interesting
> values, e.g.
>
> ---
>  .../selftests/kvm/x86/pmu_counters_test.c     | 38 +++++++++++--------
>  1 file changed, 23 insertions(+), 15 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/x86/pmu_counters_test.c b/tools/testing/selftests/kvm/x86/pmu_counters_test.c
> index cfeed0103341..09ad68675576 100644
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
> +		0xf0f0f0f0u,
> +		0x0f0f0f0fu,
> +		0xaaaaaaaau,
> +		0xa0a0a0a0u,
> +		0x0a0a0a0au,
> +		0x55555555u,
> +		0x50505050u,
> +		0x05050505u,
> +	};

Looks good to me. Just a minor suggestion, better to move 0x55555555u
closely before and after 0xaaaaaaaau since they are the 2 complementary
items. This makes the sequences more easily understood. Thanks.


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

