Return-Path: <kvm+bounces-38404-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7494DA39680
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 10:08:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B0D42188FD23
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 09:08:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0194B22F3A3;
	Tue, 18 Feb 2025 09:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LSCjhaQ1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C9E31EB1A6;
	Tue, 18 Feb 2025 09:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739869649; cv=none; b=hjz+nucbm0w6IwX4W1iaQ8uPazwSbyK4tmqiyUtDqhoHEkBMSzL0GxAZ+apSidsgRiQbGpOQZYbKgJ1GfaIauMku6UVdxh+T1VPFrHZSX6EtYc1WCCLMOl+GAb69DJ6AzUK++d+vTuy9jMvRN1zjLtoYwJyM4DPra5cTiW+4knM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739869649; c=relaxed/simple;
	bh=thhsd7C2fre6QGSPN6Q80IMWM3FsmDf1qxmkFY1Ojk4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Y0x8zeQVP6EcdYUSCpnqxG/sMwPf+GbXBlJ1UWhEezj6xx87XExXnLkcXzYLNzoRnRM9ehuT5GzdOayXG7T1dvv9I4/nY28JNBx21ZALlUJwz7OkT6vYf4/gOo11ArWSmiOt+mUrDIGCh1X3f/WeGSsd/CttdQwFM7Z0d7gAv54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LSCjhaQ1; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739869643; x=1771405643;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=thhsd7C2fre6QGSPN6Q80IMWM3FsmDf1qxmkFY1Ojk4=;
  b=LSCjhaQ1B0O8SAwDNHLuP3hUNobcALOTgoxt7q6fLn8K8hWgs7c+R6Eo
   DDsnoPtK8/4WAlYZPLBO6S7VmMG2ppdhGxkp/jGz8KOaRO5QEGC1eq9lQ
   ZYkIi2gnZxF+M2o9+uXWGKzb3AMjabLWEowx23QcR+Kb3kSgbIW6rA8Uh
   pOiVnedddflAQIcCc9BlrnMlCGgTVRHoFP37I9tR+ima8PpQgSQ+53LPF
   Uie0h49jhwUVXDCi+Bwl0pWJKM8RyyNnHoBd5j05pRyljJaTJBS4WwTdh
   j4NTlPUZUPgpQxidizZCS2cS6cQbH83/qMk+MPUt//mfkA+uBjHEZTK7m
   g==;
X-CSE-ConnectionGUID: ZSfexGwXQ+SBy3T+3SCN4A==
X-CSE-MsgGUID: Zs7Gv2dtTYO9vEy82bJv6A==
X-IronPort-AV: E=McAfee;i="6700,10204,11314"; a="51987246"
X-IronPort-AV: E=Sophos;i="6.12,310,1728975600"; 
   d="scan'208";a="51987246"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2025 01:07:22 -0800
X-CSE-ConnectionGUID: 7ZFzaIx5Qh+NtuMt86spew==
X-CSE-MsgGUID: B1r2gJhFToawhkpUDppGIQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="114204781"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.245.128]) ([10.124.245.128])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2025 01:07:20 -0800
Message-ID: <14bf2696-0dcd-43c4-baa7-2591f0d902cc@linux.intel.com>
Date: Tue, 18 Feb 2025 17:07:17 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests patch v6 04/18] x86: pmu: Fix the issue that
 pmu_counter_t.config crosses cache line
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>,
 Mingwei Zhang <mizhang@google.com>, Xiong Zhang <xiong.y.zhang@intel.com>,
 Like Xu <like.xu.linux@gmail.com>, Jinrong Liang <cloudliang@tencent.com>,
 Dapeng Mi <dapeng1.mi@intel.com>
References: <20240914101728.33148-1-dapeng1.mi@linux.intel.com>
 <20240914101728.33148-5-dapeng1.mi@linux.intel.com>
 <Z6-wHilax9b59ps8@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <Z6-wHilax9b59ps8@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 2/15/2025 5:05 AM, Sean Christopherson wrote:
> On Sat, Sep 14, 2024, Dapeng Mi wrote:
>> When running pmu test on SPR, the following #GP fault is reported.
>>
>> Unhandled exception 13 #GP at ip 000000000040771f
>> error_code=0000      rflags=00010046      cs=00000008
>> rax=00000000004031ad rcx=0000000000000186 rdx=0000000000000000 rbx=00000000005142f0
>> rbp=0000000000514260 rsi=0000000000000020 rdi=0000000000000340
>>  r8=0000000000513a65  r9=00000000000003f8 r10=000000000000000d r11=00000000ffffffff
>> r12=000000000043003c r13=0000000000514450 r14=000000000000000b r15=0000000000000001
>> cr0=0000000080010011 cr2=0000000000000000 cr3=0000000001007000 cr4=0000000000000020
>> cr8=0000000000000000
>>         STACK: @40771f 40040e 400976 400aef 40148d 401da9 4001ad
>> FAIL pmu
>>
>> It looks EVENTSEL0 MSR (0x186) is written a invalid value (0x4031ad) and
>> cause a #GP.
> Nope.
>
>> Further investigation shows the #GP is caused by below code in
>> __start_event().
>>
>> rmsr(MSR_GP_EVENT_SELECTx(event_to_global_idx(evt)),
>> 		  evt->config | EVNTSEL_EN);
> Nope.
>
>> The evt->config is correctly initialized but seems corrupted before
>> writing to MSR.
> Still nope.
>
>> The original pmu_counter_t layout looks as below.
>>
>> typedef struct {
>> 	uint32_t ctr;
>> 	uint64_t config;
>> 	uint64_t count;
>> 	int idx;
>> } pmu_counter_t;
>>
>> Obviously the config filed crosses two cache lines. 
> Yeah, no.  Cache lines are 64 bytes on x86, and even with the bad layout, the size
> only adds up to 32 bytes on x86-64.  Packing it slightly better drops it to 24
> bytes, but that has nothing to do with cache lines.
>  
>> When the two cache lines are not updated simultaneously, the config value is
>> corrupted.
> This is simply nonsensical.  Compilers don't generate accesses that split cache
> lines unless software is being deliberately stupid, and x86 doesn't corrupt data
> on unaligned accesses.
>
> The actual problem is that your next patch increases the size of the array in
> check_counters_many() from 10 to 48 entries.  With 32 bytes per entry, it's just
> enough to overflow the stack when making function calls (the array itself stays
> on the stack page).  And because KUT's percpu and stack management is complete
> and utter garbage, overflowing the stack clobbers the percpu area.
>
> Of course, it's way too hard to even see that, because all of the code is beyond
> stupid and (a) doesn't align the stacks to 4KiB, and (b) puts the percpu area at
> the bottom of the stack "page".
>
> I'll send patches to put band-aids on the per-CPU insanity, along with a refreshed
> version of this series.

Thumb up! I never realized this issue is caused by stack corruption. I
would review and test the v7 patch set later. Thanks.



