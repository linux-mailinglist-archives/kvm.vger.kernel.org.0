Return-Path: <kvm+bounces-15591-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 92F7B8ADC01
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 04:44:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4A52828117F
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 02:44:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C270718AF4;
	Tue, 23 Apr 2024 02:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GszlE20w"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01E341095B;
	Tue, 23 Apr 2024 02:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713840278; cv=none; b=Vzd/7KA+Vu50PsBIjPXZUmOFTz2wSCVvD8d1gvhnIUj4nDBbJ1ynQ9EyKhTDfUjaK9UGtsymXs+02Qj5m6MJ9959WNpIfhaz2gi7HwGxKaUeZ4IxplXieHzNrbqnsF9svJcOsQeAlZ3ENiLYPPw9rYjC3/PM3CSIueYn43M+C3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713840278; c=relaxed/simple;
	bh=EU/jou4vLOFurVBMT8WPOG3WIJ7Ec5z4BM8L84cCgtc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=i0bNFk2ec8aeNkVqIddhfX94pg9sF2NOa8ELT7nWgVWREqbqbVAYksnXHaNad+xeRYvAW9/nLKxeyUKkznzE6PeVcXd+hYwCldAb9QMYweZYfh/ap1qoWZoDAl35dZeJFG7dVHE35D5QxutDT5Og5i028F88oFtKbeCjmwm74Uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GszlE20w; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713840276; x=1745376276;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=EU/jou4vLOFurVBMT8WPOG3WIJ7Ec5z4BM8L84cCgtc=;
  b=GszlE20waG3Ko0LsPkiOenQkXz6GPzM6yERjqQCnRNCiDvDQDgPcEYRR
   I/Rgfa5ivjgWGqCpz2VPA7VpXLk6zShpSF3OFoarbSC0duxIkYhIGVzo1
   HW3nZxZ8K9srjS0kRYxJIVAu+3G1dsl77/7SFljzsi7EINi8EYqqizt37
   E53x7IgBv5/swwCYWPziYHWOLjwGzH3tQFJXH2AAwIXI+cQbN2dsD9JF8
   Q8vWVekC5rLx0v1Oc1SPba40TL7yJBBc8a4575CaiY9EyVISzCyBeCA38
   /wQUadiGARVznNInmSZL5ai6RTtxhd8ZNnArC8XIdl7BsY6yjh/dqZWmP
   Q==;
X-CSE-ConnectionGUID: nhapRqmITmawQaZPWPe2tg==
X-CSE-MsgGUID: 53OogOaHQYSI1eYwS+nxoA==
X-IronPort-AV: E=McAfee;i="6600,9927,11052"; a="26921140"
X-IronPort-AV: E=Sophos;i="6.07,222,1708416000"; 
   d="scan'208";a="26921140"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2024 19:44:35 -0700
X-CSE-ConnectionGUID: wUWCz2GBQc2MI+YjJvlIJQ==
X-CSE-MsgGUID: 9Q74fCf0Sk2Bn1mKiuu14w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,222,1708416000"; 
   d="scan'208";a="29011735"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.245.127]) ([10.124.245.127])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2024 19:44:30 -0700
Message-ID: <d980dd10-e4c4-4774-b107-77b320cec9f9@linux.intel.com>
Date: Tue, 23 Apr 2024 10:44:27 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 23/41] KVM: x86/pmu: Implement the save/restore of PMU
 state for Intel CPU
To: maobibo <maobibo@loongson.cn>, Sean Christopherson <seanjc@google.com>
Cc: Mingwei Zhang <mizhang@google.com>,
 Xiong Zhang <xiong.y.zhang@linux.intel.com>, pbonzini@redhat.com,
 peterz@infradead.org, kan.liang@intel.com, zhenyuw@linux.intel.com,
 jmattson@google.com, kvm@vger.kernel.org, linux-perf-users@vger.kernel.org,
 linux-kernel@vger.kernel.org, zhiyuan.lv@intel.com, eranian@google.com,
 irogers@google.com, samantha.alt@intel.com, like.xu.linux@gmail.com,
 chao.gao@intel.com
References: <18b19dd4-6d76-4ed8-b784-32436ab93d06@linux.intel.com>
 <Zhn9TGOiXxcV5Epx@google.com>
 <4c47b975-ad30-4be9-a0a9-f0989d1fa395@linux.intel.com>
 <CAL715WJXWQgfzgh8KqL+pAzeqL+dkF6imfRM37nQ6PkZd09mhQ@mail.gmail.com>
 <737f0c66-2237-4ed3-8999-19fe9cca9ecc@linux.intel.com>
 <CAL715W+RKCLsByfM3-0uKBWdbYgyk_hou9oC+mC9H61yR_9tyw@mail.gmail.com>
 <Zh1mKoHJcj22rKy8@google.com>
 <CAL715WJf6RdM3DQt995y4skw8LzTMk36Q2hDE34n3tVkkdtMMw@mail.gmail.com>
 <Zh2uFkfH8BA23lm0@google.com>
 <4d60384a-11e0-2f2b-a568-517b40c91b25@loongson.cn>
 <ZiaX3H3YfrVh50cs@google.com>
 <d8f3497b-9f63-e30e-0c63-253908d40ac2@loongson.cn>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <d8f3497b-9f63-e30e-0c63-253908d40ac2@loongson.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 4/23/2024 9:01 AM, maobibo wrote:
>
>
> On 2024/4/23 上午1:01, Sean Christopherson wrote:
>> On Mon, Apr 22, 2024, maobibo wrote:
>>> On 2024/4/16 上午6:45, Sean Christopherson wrote:
>>>> On Mon, Apr 15, 2024, Mingwei Zhang wrote:
>>>>> On Mon, Apr 15, 2024 at 10:38 AM Sean Christopherson 
>>>>> <seanjc@google.com> wrote:
>>>>>> One my biggest complaints with the current vPMU code is that the 
>>>>>> roles and
>>>>>> responsibilities between KVM and perf are poorly defined, which 
>>>>>> leads to suboptimal
>>>>>> and hard to maintain code.
>>>>>>
>>>>>> Case in point, I'm pretty sure leaving guest values in PMCs 
>>>>>> _would_ leak guest
>>>>>> state to userspace processes that have RDPMC permissions, as the 
>>>>>> PMCs might not
>>>>>> be dirty from perf's perspective (see perf_clear_dirty_counters()).
>>>>>>
>>>>>> Blindly clearing PMCs in KVM "solves" that problem, but in doing 
>>>>>> so makes the
>>>>>> overall code brittle because it's not clear whether KVM _needs_ 
>>>>>> to clear PMCs,
>>>>>> or if KVM is just being paranoid.
>>>>>
>>>>> So once this rolls out, perf and vPMU are clients directly to PMU HW.
>>>>
>>>> I don't think this is a statement we want to make, as it opens a 
>>>> discussion
>>>> that we won't win.  Nor do I think it's one we *need* to make.  KVM 
>>>> doesn't need
>>>> to be on equal footing with perf in terms of owning/managing PMU 
>>>> hardware, KVM
>>>> just needs a few APIs to allow faithfully and accurately 
>>>> virtualizing a guest PMU.
>>>>
>>>>> Faithful cleaning (blind cleaning) has to be the baseline
>>>>> implementation, until both clients agree to a "deal" between them.
>>>>> Currently, there is no such deal, but I believe we could have one via
>>>>> future discussion.
>>>>
>>>> What I am saying is that there needs to be a "deal" in place before 
>>>> this code
>>>> is merged.  It doesn't need to be anything fancy, e.g. perf can 
>>>> still pave over
>>>> PMCs it doesn't immediately load, as opposed to using 
>>>> cpu_hw_events.dirty to lazily
>>>> do the clearing.  But perf and KVM need to work together from the 
>>>> get go, ie. I
>>>> don't want KVM doing something without regard to what perf does, 
>>>> and vice versa.
>>>>
>>> There is similar issue on LoongArch vPMU where vm can directly pmu 
>>> hardware
>>> and pmu hw is shard with guest and host. Besides context switch 
>>> there are
>>> other places where perf core will access pmu hw, such as tick
>>> timer/hrtimer/ipi function call, and KVM can only intercept context 
>>> switch.
>>
>> Two questions:
>>
>>   1) Can KVM prevent the guest from accessing the PMU?
>>
>>   2) If so, KVM can grant partial access to the PMU, or is it all or 
>> nothing?
>>
>> If the answer to both questions is "yes", then it sounds like 
>> LoongArch *requires*
>> mediated/passthrough support in order to virtualize its PMU.
>
> Hi Sean,
>
> Thank for your quick response.
>
> yes, kvm can prevent guest from accessing the PMU and grant partial or 
> all to access to the PMU. Only that if one pmu event is granted to VM, 
> host can not access this pmu event again. There must be pmu event 
> switch if host want to.

PMU event is a software entity which won't be shared. did you mean if a 
PMU HW counter is granted to VM, then Host can't access the PMU HW 
counter, right?


>
>>
>>> Can we add callback handler in structure kvm_guest_cbs?  just like 
>>> this:
>>> @@ -6403,6 +6403,7 @@ static struct perf_guest_info_callbacks 
>>> kvm_guest_cbs
>>> = {
>>>          .state                  = kvm_guest_state,
>>>          .get_ip                 = kvm_guest_get_ip,
>>>          .handle_intel_pt_intr   = NULL,
>>> +       .lose_pmu               = kvm_guest_lose_pmu,
>>>   };
>>>
>>> By the way, I do not know should the callback handler be triggered 
>>> in perf
>>> core or detailed pmu hw driver. From ARM pmu hw driver, it is 
>>> triggered in
>>> pmu hw driver such as function kvm_vcpu_pmu_resync_el0,
>>> but I think it will be better if it is done in perf core.
>>
>> I don't think we want to take the approach of perf and KVM guests 
>> "fighting" over
>> the PMU.  That's effectively what we have today, and it's a mess for 
>> KVM because
>> it's impossible to provide consistent, deterministic behavior for the 
>> guest.  And
>> it's just as messy for perf, which ends up having wierd, cumbersome 
>> flows that
>> exists purely to try to play nice with KVM.
> With existing pmu core code, in tick timer interrupt or IPI function 
> call interrupt pmu hw may be accessed by host when VM is running and 
> pmu is already granted to guest. KVM can not intercept host IPI/timer 
> interrupt, there is no pmu context switch, there will be problem.
>
> Regards
> Bibo Mao
>

