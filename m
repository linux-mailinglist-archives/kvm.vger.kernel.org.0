Return-Path: <kvm+bounces-16150-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E5F68B5983
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2024 15:11:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 52B90B2DE0F
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2024 13:09:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C1AF56B6C;
	Mon, 29 Apr 2024 13:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dUta8Edg"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EC08C2C6;
	Mon, 29 Apr 2024 13:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714396128; cv=none; b=h+poRy0Hh7Rk+ojoLneMXg+Mx9odiAn5LM5UM0OH5Hgw5qWkGHIN8qQR4DPfsYRqWyvqNet1aGhuuTjZkhkqRwRQFmifYXI8JaNOE+RkLET0jscLNcUqWt3MFk3lIhz3x/T+VJ/I2eJhpnFRPXrwGUPON0+RekJotiiePUzPHt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714396128; c=relaxed/simple;
	bh=h/k+QXiqSs9/NGwWZ9VrWj0RyO1ZNwAX2jIDUWeJ//s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iBMiEIg9sppFmHwkUMxnnVTg1AmVp2wIuFGdwI5C3rooJtQTLa9GD1THoHtp2/bb3I0qGxYYP+F+oGudAksT4HaApPOX/fDySRV+ggwJ3v5iyUx2xXp08SR3kJVpDziHMcDPA2X9IId2pM8u8llpmS8ZdqK2Dg06PM8lBIqkOlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dUta8Edg; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714396127; x=1745932127;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=h/k+QXiqSs9/NGwWZ9VrWj0RyO1ZNwAX2jIDUWeJ//s=;
  b=dUta8EdgXPDedFUh1dEn18K+zbpMWsg7NiSCg8B5X/s+a6DvV6xlb7Yr
   RWdti8K4EoKElWUlEkk41DkbzILauDfrASHiQJTRB3mjSK+sRaOOn2aUr
   VJ+du1vQpI2q807tLJR+OTIf52BLuUtUY7ndT4mmXNAoKI7NI7gD7KKzL
   SAvmzjoc9YgCwYBiRJRh9BO3BD5gsdlO/4jPKD2MJPPByKTQsKDHOzols
   nQU5cl43lv7Wf7Qk5ZWa+CngDZgKadLuKyy54Q2ne/xx0Dlo0XtVf8cUv
   Ep3dYhTEzcBLT5Tbi0L/GqbybcjMzEoCUci8NsZrSrpKI5QE04oBMVsDg
   A==;
X-CSE-ConnectionGUID: d1mmrVxlTcmS6fPvk5KAMQ==
X-CSE-MsgGUID: jeui67zPRRCVGXaGYIoplA==
X-IronPort-AV: E=McAfee;i="6600,9927,11057"; a="13840570"
X-IronPort-AV: E=Sophos;i="6.07,239,1708416000"; 
   d="scan'208";a="13840570"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2024 06:08:46 -0700
X-CSE-ConnectionGUID: 8oTf2g0rRwu8qkcwHrQnqA==
X-CSE-MsgGUID: VOAb7zO/RFKVe+CSmynZPw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,239,1708416000"; 
   d="scan'208";a="25976696"
Received: from linux.intel.com ([10.54.29.200])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2024 06:08:47 -0700
Received: from [10.212.16.233] (kliang2-mobl1.ccr.corp.intel.com [10.212.16.233])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by linux.intel.com (Postfix) with ESMTPS id 9E06420B5739;
	Mon, 29 Apr 2024 06:08:43 -0700 (PDT)
Message-ID: <4bd55385-0c8e-4989-95be-37862b564dea@linux.intel.com>
Date: Mon, 29 Apr 2024 09:08:42 -0400
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 23/41] KVM: x86/pmu: Implement the save/restore of PMU
 state for Intel CPU
To: Mingwei Zhang <mizhang@google.com>,
 Sean Christopherson <seanjc@google.com>
Cc: Dapeng Mi <dapeng1.mi@linux.intel.com>, maobibo <maobibo@loongson.cn>,
 Xiong Zhang <xiong.y.zhang@linux.intel.com>, pbonzini@redhat.com,
 peterz@infradead.org, kan.liang@intel.com, zhenyuw@linux.intel.com,
 jmattson@google.com, kvm@vger.kernel.org, linux-perf-users@vger.kernel.org,
 linux-kernel@vger.kernel.org, zhiyuan.lv@intel.com, eranian@google.com,
 irogers@google.com, samantha.alt@intel.com, like.xu.linux@gmail.com,
 chao.gao@intel.com
References: <CAL715WKh8VBJ-O50oqSnCqKPQo4Bor_aMnRZeS_TzJP3ja8-YQ@mail.gmail.com>
 <6af2da05-cb47-46f7-b129-08463bc9469b@linux.intel.com>
 <CAL715W+zeqKenPLP2Fm9u_BkGRKAk-mncsOxrg=EKs74qK5f1Q@mail.gmail.com>
 <42acf1fc-1603-4ac5-8a09-edae2d85963d@linux.intel.com>
 <ZirPGnSDUzD-iWwc@google.com>
 <77913327-2115-42b5-850a-04ef0581faa7@linux.intel.com>
 <CAL715WJCHJD_wcJ+r4TyWfvmk9uNT_kPy7Pt=CHkB-Sf0D4Rqw@mail.gmail.com>
 <ff4a4229-04ac-4cbf-8aea-c84ccfa96e0b@linux.intel.com>
 <CAL715WJKL5__8RU0xxUf0HifNVQBDRODE54O2bwOx45w67TQTQ@mail.gmail.com>
 <5f5bcbc0-e2ef-4232-a56a-fda93c6a569e@linux.intel.com>
 <ZiwEoZDIg8l7-uid@google.com>
 <CAL715WJ4jHmto3ci=Fz5Bwx2Y=Hiy1MoFCpcUhz-C8aPMqYskw@mail.gmail.com>
Content-Language: en-US
From: "Liang, Kan" <kan.liang@linux.intel.com>
In-Reply-To: <CAL715WJ4jHmto3ci=Fz5Bwx2Y=Hiy1MoFCpcUhz-C8aPMqYskw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 2024-04-26 11:04 p.m., Mingwei Zhang wrote:
> On Fri, Apr 26, 2024 at 12:46 PM Sean Christopherson <seanjc@google.com> wrote:
>>
>> On Fri, Apr 26, 2024, Kan Liang wrote:
>>>> Optimization 4
>>>> allows the host side to immediately profiling this part instead of
>>>> waiting for vcpu to reach to PMU context switch locations. Doing so
>>>> will generate more accurate results.
>>>
>>> If so, I think the 4 is a must to have. Otherwise, it wouldn't honer the
>>> definition of the exclude_guest. Without 4, it brings some random blind
>>> spots, right?
>>
>> +1, I view it as a hard requirement.  It's not an optimization, it's about
>> accuracy and functional correctness.
> 
> Well. Does it have to be a _hard_ requirement? no? The irq handler
> triggered by "perf record -a" could just inject a "state". Instead of
> immediately preempting the guest PMU context, perf subsystem could
> allow KVM defer the context switch when it reaches the next PMU
> context switch location.

It depends on what is the upcoming PMU context switch location.
If it's the upcoming VM-exit/entry, the defer should be fine. Because
it's a exclude_guest event, nothing should be counted when a VM is running.
If it's the upcoming vCPU boundary, no. I think there may be several
VM-exit/entry before the upcoming vCPU switch. We may lose some results.
> 
> This is the same as the preemption kernel logic. Do you want me to
> stop the work immediately? Yes (if you enable preemption), or No, let
> me finish my job and get to the scheduling point.

I don't think it's necessary. Just make sure that the counters are
scheduled in the upcoming VM-exit/entry boundary should be fine.

Thanks,
Kan
> 
> Implementing this might be more difficult to debug. That's my real
> concern. If we do not enable preemption, the PMU context switch will
> only happen at the 2 pairs of locations. If we enable preemption, it
> could happen at any time.
> 
>>
>> What _is_ an optimization is keeping guest state loaded while KVM is in its
>> run loop, i.e. initial mediated/passthrough PMU support could land upstream with
>> unconditional switches at entry/exit.  The performance of KVM would likely be
>> unacceptable for any production use cases, but that would give us motivation to
>> finish the job, and it doesn't result in random, hard to diagnose issues for
>> userspace.
> 
> That's true. I agree with that.
> 
>>
>>>> Do we want to preempt that? I think it depends. For regular cloud
>>>> usage, we don't. But for any other usages where we want to prioritize
>>>> KVM/VMM profiling over guest vPMU, it is useful.
>>>>
>>>> My current opinion is that optimization 4 is something nice to have.
>>>> But we should allow people to turn it off just like we could choose to
>>>> disable preempt kernel.
>>>
>>> The exclude_guest means everything but the guest. I don't see a reason
>>> why people want to turn it off and get some random blind spots.
> 

