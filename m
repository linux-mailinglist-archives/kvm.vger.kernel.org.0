Return-Path: <kvm+bounces-50439-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CADB1AE590F
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 03:19:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A0BD33AC7A9
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 01:19:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19C3B194A67;
	Tue, 24 Jun 2025 01:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="W1uUZ08c"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E99835966;
	Tue, 24 Jun 2025 01:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750727981; cv=none; b=rUog64Zoah/r1tSVQMWnL85fyjXjafqF47S4bB/fqbBcrphM3JUWrQq9aiuxbeGP/swCsRYY/aE/XTYT9PrNsmiuKwNX+j764TlVg9OYkXHvDrs+E51oQUXgWV5IvsVtGFLeNYI0Ty21fXz94GSGoI3tHVsQSIn7AR+OkAWlp2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750727981; c=relaxed/simple;
	bh=rSwFW4cbF6WMVzBS2fGOzZoqDKr6H1Izrpq6aj+cSd8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UnslYIfLVL6EBmNwIQ7Y+j6lP6cEh7IYUFOAFWdqE9uI3msA0y/zuSW7vRaNZSb3R/kkAfvti3xDNzSan0Dp/T5b3CWqmdylyfORAOzrGOVrTN/o8hwVAN48/3OwTOsMbw8cD8vCIY1BWVg0ihbOvyIjHeoapKhXALXrleDS3Zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=W1uUZ08c; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750727980; x=1782263980;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=rSwFW4cbF6WMVzBS2fGOzZoqDKr6H1Izrpq6aj+cSd8=;
  b=W1uUZ08cX9mfMNQjRarURFLQc1BmdfHQshEm3OeVeDZYeUm/3C643e2D
   UKjfZB21bWuxEXiLoqbqtfAOKCPoixkcVGJF7nn2sgIovqjrM+j0OI68R
   O/cNJEuQkH9Feugqxh6de1P6itBm5ny3DecE4vS9ifxw/KNrfzmvHBSrn
   w9/bWH0evpDgjx0FoiNlpU3Os3dFygpwijdzG4fFfmweT93lk/jyGLRTM
   3qwEeehotMqaqaxdSV3gaUU3k6DdrjWQHVhQOPqEBcvaDI4Mwk11MOjuF
   K4V7b5FAKuCT3lr6w/WgcqzFQRDyZyjMXpA0lYGVNYayr1CNjUmvn4OjR
   w==;
X-CSE-ConnectionGUID: MpWvgihLRwaqWxZSZdfiFA==
X-CSE-MsgGUID: AzravT3aTZeDQvqYc6nVIg==
X-IronPort-AV: E=McAfee;i="6800,10657,11473"; a="52823428"
X-IronPort-AV: E=Sophos;i="6.16,260,1744095600"; 
   d="scan'208";a="52823428"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2025 18:19:39 -0700
X-CSE-ConnectionGUID: c3yvsP+eS0iesj8Q/ibaOw==
X-CSE-MsgGUID: R9LgCwYGQ2WO3bzJ26egoQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,260,1744095600"; 
   d="scan'208";a="151915905"
Received: from unknown (HELO [10.238.128.162]) ([10.238.128.162])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2025 18:19:34 -0700
Message-ID: <8437bad1-bdae-4922-bf4c-9303872fab57@linux.intel.com>
Date: Tue, 24 Jun 2025 09:19:31 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/2] x86/traps: Initialize DR6 by writing its
 architectural reset value
To: Xin Li <xin@zytor.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, stable@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 seanjc@google.com, pbonzini@redhat.com, peterz@infradead.org,
 sohil.mehta@intel.com, brgerst@gmail.com, tony.luck@intel.com,
 fenghuay@nvidia.com
References: <20250620231504.2676902-1-xin@zytor.com>
 <20250620231504.2676902-2-xin@zytor.com>
 <4018038c-8c96-49e0-b6b7-f54e0f52a65f@linux.intel.com>
 <b170c705-c2a8-44ac-a77d-0c3c73ebed0a@zytor.com>
From: Ethan Zhao <haifeng.zhao@linux.intel.com>
Autocrypt: addr=haifeng.zhao@linux.intel.com; keydata=
 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
 8TCx1OJHpvWFmL4Deq8=
In-Reply-To: <b170c705-c2a8-44ac-a77d-0c3c73ebed0a@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


在 2025/6/24 0:34, Xin Li 写道:
> On 6/22/2025 11:49 PM, Ethan Zhao wrote:
>>
>> 在 2025/6/21 7:15, Xin Li (Intel) 写道:
>>> Initialize DR6 by writing its architectural reset value to avoid
>>> incorrectly zeroing DR6 to clear DR6.BLD at boot time, which leads
>>> to a false bus lock detected warning.
>>>
>>> The Intel SDM says:
>>>
>>>    1) Certain debug exceptions may clear bits 0-3 of DR6.
>>>
>>>    2) BLD induced #DB clears DR6.BLD and any other debug exception
>>>       doesn't modify DR6.BLD.
>>>
>>>    3) RTM induced #DB clears DR6.RTM and any other debug exception
>>>       sets DR6.RTM.
>>>
>>>    To avoid confusion in identifying debug exceptions, debug handlers
>>>    should set DR6.BLD and DR6.RTM, and clear other DR6 bits before
>>>    returning.
>>>
>>> The DR6 architectural reset value 0xFFFF0FF0, already defined as
>>> macro DR6_RESERVED, satisfies these requirements, so just use it to
>>> reinitialize DR6 whenever needed.
>>>
>>> Since clear_all_debug_regs() no longer zeros all debug registers,
>>> rename it to initialize_debug_regs() to better reflect its current
>>> behavior.
>>>
>>> Since debug_read_clear_dr6() no longer clears DR6, rename it to
>>> debug_read_reset_dr6() to better reflect its current behavior.
>>>
>>> Reported-by: Sohil Mehta <sohil.mehta@intel.com>
>>> Link: https://lore.kernel.org/lkml/06e68373-a92b-472e-8fd9- 
>>> ba548119770c@intel.com/
>>> Fixes: ebb1064e7c2e9 ("x86/traps: Handle #DB for bus lock")
>>> Suggested-by: H. Peter Anvin (Intel) <hpa@zytor.com>
>>> Tested-by: Sohil Mehta <sohil.mehta@intel.com>
>>> Reviewed-by: H. Peter Anvin (Intel) <hpa@zytor.com>
>>> Reviewed-by: Sohil Mehta <sohil.mehta@intel.com>
>>> Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
>>> Signed-off-by: Xin Li (Intel) <xin@zytor.com>
>>> Cc: stable@vger.kernel.org
>>> ---
>>>
>>> Changes in v3:
>>> *) Polish initialize_debug_regs() (PeterZ).
>>> *) Rewrite the comment for DR6_RESERVED definition (Sohil and Sean).
>>> *) Collect TB, RB, AB (PeterZ and Sohil).
>>>
>>> Changes in v2:
>>> *) Use debug register index 6 rather than DR_STATUS (PeterZ and Sean).
>>> *) Move this patch the first of the patch set to ease backporting.
>>> ---
>>>   arch/x86/include/uapi/asm/debugreg.h | 21 ++++++++++++++++-
>>>   arch/x86/kernel/cpu/common.c         | 24 ++++++++------------
>>>   arch/x86/kernel/traps.c              | 34 
>>> +++++++++++++++++-----------
>>>   3 files changed, 51 insertions(+), 28 deletions(-)
>>>
>>> diff --git a/arch/x86/include/uapi/asm/debugreg.h 
>>> b/arch/x86/include/ uapi/asm/debugreg.h
>>> index 0007ba077c0c..41da492dfb01 100644
>>> --- a/arch/x86/include/uapi/asm/debugreg.h
>>> +++ b/arch/x86/include/uapi/asm/debugreg.h
>>> @@ -15,7 +15,26 @@
>>>      which debugging register was responsible for the trap. The 
>>> other bits
>>>      are either reserved or not of interest to us. */
>>> -/* Define reserved bits in DR6 which are always set to 1 */
>>> +/*
>>> + * Define bits in DR6 which are set to 1 by default.
>>> + *
>>> + * This is also the DR6 architectural value following Power-up, 
>>> Reset or INIT.
>>> + *
>>> + * Note, with the introduction of Bus Lock Detection (BLD) and 
>>> Restricted
>>> + * Transactional Memory (RTM), the DR6 register has been modified:
>>> + *
>>> + * 1) BLD flag (bit 11) is no longer reserved to 1 if the CPU supports
>>> + *    Bus Lock Detection.  The assertion of a bus lock could clear it.
>>> + *
>>> + * 2) RTM flag (bit 16) is no longer reserved to 1 if the CPU supports
>>> + *    restricted transactional memory.  #DB occurred inside an RTM 
>>> region
>>> + *    could clear it.
>>> + *
>>> + * Apparently, DR6.BLD and DR6.RTM are active low bits.
>>> + *
>>> + * As a result, DR6_RESERVED is an incorrect name now, but it is 
>>> kept for
>>> + * compatibility.
>>> + */
>>>   #define DR6_RESERVED    (0xFFFF0FF0)
>>>   #define DR_TRAP0    (0x1)        /* db0 */
>>> diff --git a/arch/x86/kernel/cpu/common.c 
>>> b/arch/x86/kernel/cpu/common.c
>>> index 8feb8fd2957a..0f6c280a94f0 100644
>>> --- a/arch/x86/kernel/cpu/common.c
>>> +++ b/arch/x86/kernel/cpu/common.c
>>> @@ -2243,20 +2243,16 @@ EXPORT_PER_CPU_SYMBOL(__stack_chk_guard);
>>>   #endif
>>>   #endif
>>> -/*
>>> - * Clear all 6 debug registers:
>>> - */
>>> -static void clear_all_debug_regs(void)
>>> +static void initialize_debug_regs(void)
>>>   {
>>> -    int i;
>>> -
>>> -    for (i = 0; i < 8; i++) {
>>> -        /* Ignore db4, db5 */
>>> -        if ((i == 4) || (i == 5))
>>> -            continue;
>>> -
>>> -        set_debugreg(0, i);
>>> -    }
>>> +    /* Control register first -- to make sure everything is 
>>> disabled. */
>>
>> In the Figure 19-1. Debug Registers of SDM section 19.2 DEBUG REGISTERS,
>>
>> bit 10, 12, 14, 15 of DR7 are marked as gray (Reversed) and their 
>> value are filled as
>>
>> 1, 0, 0,0 ; should we clear them all here ?  I didn't find any other 
>> description in the
>>
>> SDM about the result if they are cleaned. of course, this patch 
>> doesn't change
>>
>> the behaviour of original DR7 initialization code, no justification 
>> needed,
>>
>> just out of curiosity.
>
> This patch is NOT intended to make any actual change to DR7
> initialization.
>
So far it is okay,  I am just curious why these registers were cleared 
to zero

but the git log history and SDM doesn't give too much consistent clue.

That is 16 years old code.

> Please take a look at the second patch of this patch set.

Looking.


Thanks,

Ethan

>
> Thanks!
>     Xin
>
>>
>>> +    set_debugreg(0, 7);
>>> +    set_debugreg(DR6_RESERVED, 6);
>>> +    /* dr5 and dr4 don't exist */
>>> +    set_debugreg(0, 3);
>>> +    set_debugreg(0, 2);
>>> +    set_debugreg(0, 1);
>>> +    set_debugreg(0, 0);

-- 
"firm, enduring, strong, and long-lived"


