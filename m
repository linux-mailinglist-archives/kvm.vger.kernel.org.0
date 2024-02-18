Return-Path: <kvm+bounces-8980-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 31743859456
	for <lists+kvm@lfdr.de>; Sun, 18 Feb 2024 04:17:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 871BCB214D5
	for <lists+kvm@lfdr.de>; Sun, 18 Feb 2024 03:17:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94E151859;
	Sun, 18 Feb 2024 03:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RVTZYtJA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEAF215C0;
	Sun, 18 Feb 2024 03:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708226220; cv=none; b=tyxnUSa5O+cM2AbCx031tKkAN8P1CczwCJtEWzKfibfvETPfRLZE/ppgp3akMey9ZoVFP1PUAfClQJ6/XL2mG+M9bvsLWgM/sbHKpcXJd/zJKIfU2kdJCLOpCxwFJPHnLusNSVInXkv0NAtrtTLg53hb0uj58zXXWX/kwLoMgQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708226220; c=relaxed/simple;
	bh=DeGDrMAgGcdQj3OmlPemYT17RoDy097NuhgcWvnkTOw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qsWZevX5BjcxZD4wRjlu5p0SeB7c3MRFvLmkaM9aHKuiJ7m1+coEGwAphgwb4PEFHgiwpA93sRtXjFWZHNquS+6SAwxRifyW+E/D0CQHI7NP6I1RfEpLuCdQSCGcL6rWI0w9n0fEagBrN/R1kMRCBxOuJ1zp0EZNDK0pRC6VxUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RVTZYtJA; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708226220; x=1739762220;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=DeGDrMAgGcdQj3OmlPemYT17RoDy097NuhgcWvnkTOw=;
  b=RVTZYtJAguZcY7TMWhKkUA5q0rbB6uwvaU8qMBIl2cLY+zDsGogirdVR
   TRgh3hBPyOdHsiU6muZNyMcuE3aUNacJsCLFcXYNt6oa7CTwmp1hD+uMT
   t01oKqCbV6GjeRmSb6yTSCZICgccoPuCGhhE2dcnnOYCmVBFX50DDu9rp
   8WPGV9ip7UEYAmnbZxsBfaoc0owON890tmz1wcG9np1g7hhLO9IPo7qMQ
   ZzU6ah4vl4DEjDfpoUtNLFEfLBUxIzT6ZSBXiyZ6UxAxSwqMlwQTcknNa
   lYrdLzNPAENPf0eFnLLxvwzBZLyu5PgDU7xhDal6levj5k3Z/YzDX+Ek+
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10987"; a="19749191"
X-IronPort-AV: E=Sophos;i="6.06,167,1705392000"; 
   d="scan'208";a="19749191"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2024 19:16:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,167,1705392000"; 
   d="scan'208";a="8855672"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.93.20.184]) ([10.93.20.184])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2024 19:16:56 -0800
Message-ID: <a0d961d0-179e-481c-a1fa-d7b384a481dd@linux.intel.com>
Date: Sun, 18 Feb 2024 11:16:53 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: selftests: Test top-down slots event
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Kan Liang <kan.liang@linux.intel.com>,
 Jim Mattson <jmattson@google.com>, Jinrong Liang <cloudliang@tencent.com>,
 Aaron Lewis <aaronlewis@google.com>, Dapeng Mi <dapeng1.mi@intel.com>
References: <20240201061505.2027804-1-dapeng1.mi@linux.intel.com>
 <Zbvcx0A-Ln2sP6XA@google.com>
 <95c3dc22-2d40-46fc-bc4d-8206b002e0a1@linux.intel.com>
 <Zb0lPSBI_GFGuVex@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <Zb0lPSBI_GFGuVex@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 2/3/2024 1:24 AM, Sean Christopherson wrote:
> On Fri, Feb 02, 2024, Dapeng Mi wrote:
>> On 2/2/2024 2:02 AM, Sean Christopherson wrote:
>>> On Thu, Feb 01, 2024, Dapeng Mi wrote:
>>>> Although the fixed counter 3 and the exclusive pseudo slots events is
>>>> not supported by KVM yet, the architectural slots event is supported by
>>>> KVM and can be programed on any GP counter. Thus add validation for this
>>>> architectural slots event.
>>>>
>>>> Top-down slots event "counts the total number of available slots for an
>>>> unhalted logical processor, and increments by machine-width of the
>>>> narrowest pipeline as employed by the Top-down Microarchitecture
>>>> Analysis method." So suppose the measured count of slots event would be
>>>> always larger than 0.
>>> Please translate that into something non-perf folks can understand.  I know what
>>> a pipeline slot is, and I know a dictionary's definition of "available" is, but I
>>> still have no idea what this event actually counts.  In other words, I want a
>>> precise definition of exactly what constitutes an "available slot", in verbiage
>>> that anyone with basic understanding of x86 architectures can follow after reading
>>> the whitepaper[*], which is helpful for understanding the concepts, but doesn't
>>> crisply explain what this event counts.
>>>
>>> Examples of when a slot is available vs. unavailable would be extremely helpful.
>>>
>>> [*] https://www.intel.com/content/www/us/en/docs/vtune-profiler/cookbook/2023-0/top-down-microarchitecture-analysis-method.html
>> Yeah, indeed, 'slots' is not easily understood from its literal meaning. I
>> also took some time to understand it when I look at this event for the first
>> time. Simply speaking, slots is an abstract concept which indicates how many
>> uops (decoded from instructions) can be processed simultaneously (per cycle)
>> on HW. we assume there is a classic 5-stage pipeline, fetch, decode,
>> execute, memory access and register writeback. In topdown
>> micro-architectural analysis method, the former two stages (fetch/decode) is
>> called front-end and the last three stages are called back-end.
>>
>> In modern Intel processors, a complicated instruction could be decoded into
>> several uops (micro-operations) and so these uops can be processed
>> simultaneously and then improve the performance. Thus, assume a processor
>> can decode and dispatch 4 uops in front-end and execute 4 uops in back-end
>> simultaneously (per-cycle), so we would say this processor has 4 topdown
>> slots per-cycle. If a slot is spare and can be used to process new uop, we
>> say it's available, but if a slot is occupied by a uop for several cycles
>> and not retired (maybe blocked by memory access), we say this slot is stall
>> and unavailable.
> In that case, can't the test assert that the count is at least NUM_INSNS_RETIRED?
> AFAIK, none of the sequences in the measured code can be fused, i.e. the test can
> assert that every instruction requires at least one uop, and IIUC, actually
> executing a uop requires an available slot at _some_ time.


Yeah, looks the instruction sequence can't be marco-fused on x86 
platforms, the slots count should be equal or larger than 
NUM_INSNS_RETIRED.


>
> diff --git a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
> index ae5f6042f1e8..29609b52f8fa 100644
> --- a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
> @@ -119,6 +119,9 @@ static void guest_assert_event_count(uint8_t idx,
>          case INTEL_ARCH_REFERENCE_CYCLES_INDEX:
>                  GUEST_ASSERT_NE(count, 0);
>                  break;
> +       case INTEL_ARCH_TOPDOWN_SLOTS_INDEX:
> +               GUEST_ASSERT(count >= NUM_INSNS_RETIRED);
> +               break;
>          default:
>                  break;
>          }

