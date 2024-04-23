Return-Path: <kvm+bounces-15615-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 32D8F8ADFA9
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 10:25:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DDA88289189
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 08:25:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6099F524BA;
	Tue, 23 Apr 2024 08:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="V+ttkDps"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8238F2B9CA;
	Tue, 23 Apr 2024 08:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713860695; cv=none; b=p25+vfJT1QkcX2ME7Ms8EBVr5VNUyzYP9W2KE4vvrAcv2zSUT0h8vuicJiPg2XQtoQzvyEbI5SMFOKh9P3LcF0Au8fuS5BHRUlrhOzO7/TCDZPHkuTjrW0q8dPyPwdFtEezWbgHzAd6cywrraF/r4Hy5x8/58n5ktWefzwIS2AM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713860695; c=relaxed/simple;
	bh=xjoZLJ+fPlF5s7MSJCl/qCPNQIMwbAuVdPHDe7WD+KQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nx0FpJMabvnHkM62bi9O0BipOlEOAmynlQPpijf3BIsuPnXT2DyTbHMAhXaUJxTRi8fUb9NzFuGU8Ohf4Wx/jFgHgbTIQBhVikjlxUL1ElfGMONe4X1WUdQHvPOkwYqDYaGMvirCYACCJnSpsdCJ/jmml781QG1N/uD/zpzBprE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=V+ttkDps; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713860693; x=1745396693;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=xjoZLJ+fPlF5s7MSJCl/qCPNQIMwbAuVdPHDe7WD+KQ=;
  b=V+ttkDpsqYhLm2w6pu2Oi74FLmAnEYDCYX+JVYQpNQntgcp4je9c4if8
   /OKyfZe3AacIfp+CF7ik81ziSt+VSKPvFzqcPAVAY0Dncqq2qNrnbpFxQ
   /pbpsTWVw3qDlp626YtwG6yUZ3WKmKNMabcMdEdyzvPVVY2KcxKVNwSPB
   afzORUC1rfcEPRtfW5hYfRljTPYap7SXfpDl+lpvO7DUTjA51IIR1bfMx
   mWtRmDjz5mEjuSNwHgpU3oXjLZ6O8G59VwceRIOfXlHFVqh9OgqOnha5+
   BO/b/60UP8lmsoHTus5NXY/jNJqg6TV2b5xow7rLoXuuGxmum9IzH+Yr6
   g==;
X-CSE-ConnectionGUID: 6Nz/yhC9Q623h4yiP0RvTA==
X-CSE-MsgGUID: iPwXVWm0TKSjgg9iDFkEzQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11052"; a="9301581"
X-IronPort-AV: E=Sophos;i="6.07,222,1708416000"; 
   d="scan'208";a="9301581"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2024 01:24:52 -0700
X-CSE-ConnectionGUID: k9MzM8gBRcyY2ki7HhLYQA==
X-CSE-MsgGUID: /vJeddWKRyOTw1VsufK2YA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,222,1708416000"; 
   d="scan'208";a="29095566"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.245.127]) ([10.124.245.127])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2024 01:24:48 -0700
Message-ID: <46a889c4-b104-487e-be3e-7f4b57c0b339@linux.intel.com>
Date: Tue, 23 Apr 2024 16:24:45 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 23/41] KVM: x86/pmu: Implement the save/restore of PMU
 state for Intel CPU
To: Mingwei Zhang <mizhang@google.com>
Cc: maobibo <maobibo@loongson.cn>, Sean Christopherson <seanjc@google.com>,
 Xiong Zhang <xiong.y.zhang@linux.intel.com>, pbonzini@redhat.com,
 peterz@infradead.org, kan.liang@intel.com, zhenyuw@linux.intel.com,
 jmattson@google.com, kvm@vger.kernel.org, linux-perf-users@vger.kernel.org,
 linux-kernel@vger.kernel.org, zhiyuan.lv@intel.com, eranian@google.com,
 irogers@google.com, samantha.alt@intel.com, like.xu.linux@gmail.com,
 chao.gao@intel.com
References: <18b19dd4-6d76-4ed8-b784-32436ab93d06@linux.intel.com>
 <CAL715WJXWQgfzgh8KqL+pAzeqL+dkF6imfRM37nQ6PkZd09mhQ@mail.gmail.com>
 <737f0c66-2237-4ed3-8999-19fe9cca9ecc@linux.intel.com>
 <CAL715W+RKCLsByfM3-0uKBWdbYgyk_hou9oC+mC9H61yR_9tyw@mail.gmail.com>
 <Zh1mKoHJcj22rKy8@google.com>
 <CAL715WJf6RdM3DQt995y4skw8LzTMk36Q2hDE34n3tVkkdtMMw@mail.gmail.com>
 <Zh2uFkfH8BA23lm0@google.com>
 <4d60384a-11e0-2f2b-a568-517b40c91b25@loongson.cn>
 <ZiaX3H3YfrVh50cs@google.com>
 <d8f3497b-9f63-e30e-0c63-253908d40ac2@loongson.cn>
 <d980dd10-e4c4-4774-b107-77b320cec9f9@linux.intel.com>
 <b5e97aa1-7683-4eff-e1e3-58ac98a8d719@loongson.cn>
 <1ec7a21c-71d0-4f3e-9fa3-3de8ca0f7315@linux.intel.com>
 <5279eabc-ca46-ee1b-b80d-9a511ba90a36@loongson.cn>
 <CAL715WJK893gQd1m9CCAjz5OkxsRc5C4ZR7yJWJXbaGvCeZxQA@mail.gmail.com>
 <86d1f6d1-197a-ecd9-3349-a64da9ea9789@loongson.cn>
 <729c4b30-163c-4115-a380-14ece533a8b9@linux.intel.com>
 <CAL715W+BpyX3EeKr=3ipMH8W30wmhMkxg2Fx2OET9cvQ480cgg@mail.gmail.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <CAL715W+BpyX3EeKr=3ipMH8W30wmhMkxg2Fx2OET9cvQ480cgg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 4/23/2024 3:10 PM, Mingwei Zhang wrote:
> On Mon, Apr 22, 2024 at 11:45 PM Mi, Dapeng <dapeng1.mi@linux.intel.com> wrote:
>>
>> On 4/23/2024 2:08 PM, maobibo wrote:
>>>
>>> On 2024/4/23 下午12:23, Mingwei Zhang wrote:
>>>> On Mon, Apr 22, 2024 at 8:55 PM maobibo <maobibo@loongson.cn> wrote:
>>>>>
>>>>>
>>>>> On 2024/4/23 上午11:13, Mi, Dapeng wrote:
>>>>>> On 4/23/2024 10:53 AM, maobibo wrote:
>>>>>>>
>>>>>>> On 2024/4/23 上午10:44, Mi, Dapeng wrote:
>>>>>>>> On 4/23/2024 9:01 AM, maobibo wrote:
>>>>>>>>>
>>>>>>>>> On 2024/4/23 上午1:01, Sean Christopherson wrote:
>>>>>>>>>> On Mon, Apr 22, 2024, maobibo wrote:
>>>>>>>>>>> On 2024/4/16 上午6:45, Sean Christopherson wrote:
>>>>>>>>>>>> On Mon, Apr 15, 2024, Mingwei Zhang wrote:
>>>>>>>>>>>>> On Mon, Apr 15, 2024 at 10:38 AM Sean Christopherson
>>>>>>>>>>>>> <seanjc@google.com> wrote:
>>>>>>>>>>>>>> One my biggest complaints with the current vPMU code is that
>>>>>>>>>>>>>> the roles and
>>>>>>>>>>>>>> responsibilities between KVM and perf are poorly defined,
>>>>>>>>>>>>>> which
>>>>>>>>>>>>>> leads to suboptimal
>>>>>>>>>>>>>> and hard to maintain code.
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> Case in point, I'm pretty sure leaving guest values in PMCs
>>>>>>>>>>>>>> _would_ leak guest
>>>>>>>>>>>>>> state to userspace processes that have RDPMC permissions, as
>>>>>>>>>>>>>> the PMCs might not
>>>>>>>>>>>>>> be dirty from perf's perspective (see
>>>>>>>>>>>>>> perf_clear_dirty_counters()).
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> Blindly clearing PMCs in KVM "solves" that problem, but in
>>>>>>>>>>>>>> doing so makes the
>>>>>>>>>>>>>> overall code brittle because it's not clear whether KVM
>>>>>>>>>>>>>> _needs_
>>>>>>>>>>>>>> to clear PMCs,
>>>>>>>>>>>>>> or if KVM is just being paranoid.
>>>>>>>>>>>>> So once this rolls out, perf and vPMU are clients directly to
>>>>>>>>>>>>> PMU HW.
>>>>>>>>>>>> I don't think this is a statement we want to make, as it opens a
>>>>>>>>>>>> discussion
>>>>>>>>>>>> that we won't win.  Nor do I think it's one we *need* to make.
>>>>>>>>>>>> KVM doesn't need
>>>>>>>>>>>> to be on equal footing with perf in terms of owning/managing PMU
>>>>>>>>>>>> hardware, KVM
>>>>>>>>>>>> just needs a few APIs to allow faithfully and accurately
>>>>>>>>>>>> virtualizing a guest PMU.
>>>>>>>>>>>>
>>>>>>>>>>>>> Faithful cleaning (blind cleaning) has to be the baseline
>>>>>>>>>>>>> implementation, until both clients agree to a "deal" between
>>>>>>>>>>>>> them.
>>>>>>>>>>>>> Currently, there is no such deal, but I believe we could have
>>>>>>>>>>>>> one via
>>>>>>>>>>>>> future discussion.
>>>>>>>>>>>> What I am saying is that there needs to be a "deal" in place
>>>>>>>>>>>> before this code
>>>>>>>>>>>> is merged.  It doesn't need to be anything fancy, e.g. perf can
>>>>>>>>>>>> still pave over
>>>>>>>>>>>> PMCs it doesn't immediately load, as opposed to using
>>>>>>>>>>>> cpu_hw_events.dirty to lazily
>>>>>>>>>>>> do the clearing.  But perf and KVM need to work together from
>>>>>>>>>>>> the
>>>>>>>>>>>> get go, ie. I
>>>>>>>>>>>> don't want KVM doing something without regard to what perf does,
>>>>>>>>>>>> and vice versa.
>>>>>>>>>>>>
>>>>>>>>>>> There is similar issue on LoongArch vPMU where vm can directly
>>>>>>>>>>> pmu
>>>>>>>>>>> hardware
>>>>>>>>>>> and pmu hw is shard with guest and host. Besides context switch
>>>>>>>>>>> there are
>>>>>>>>>>> other places where perf core will access pmu hw, such as tick
>>>>>>>>>>> timer/hrtimer/ipi function call, and KVM can only intercept
>>>>>>>>>>> context switch.
>>>>>>>>>> Two questions:
>>>>>>>>>>
>>>>>>>>>>     1) Can KVM prevent the guest from accessing the PMU?
>>>>>>>>>>
>>>>>>>>>>     2) If so, KVM can grant partial access to the PMU, or is it all
>>>>>>>>>> or nothing?
>>>>>>>>>>
>>>>>>>>>> If the answer to both questions is "yes", then it sounds like
>>>>>>>>>> LoongArch *requires*
>>>>>>>>>> mediated/passthrough support in order to virtualize its PMU.
>>>>>>>>> Hi Sean,
>>>>>>>>>
>>>>>>>>> Thank for your quick response.
>>>>>>>>>
>>>>>>>>> yes, kvm can prevent guest from accessing the PMU and grant partial
>>>>>>>>> or all to access to the PMU. Only that if one pmu event is granted
>>>>>>>>> to VM, host can not access this pmu event again. There must be pmu
>>>>>>>>> event switch if host want to.
>>>>>>>> PMU event is a software entity which won't be shared. did you
>>>>>>>> mean if
>>>>>>>> a PMU HW counter is granted to VM, then Host can't access the PMU HW
>>>>>>>> counter, right?
>>>>>>> yes, if PMU HW counter/control is granted to VM. The value comes from
>>>>>>> guest, and is not meaningful for host.  Host pmu core does not know
>>>>>>> that it is granted to VM, host still think that it owns pmu.
>>>>>> That's one issue this patchset tries to solve. Current new mediated
>>>>>> x86
>>>>>> vPMU framework doesn't allow Host or Guest own the PMU HW resource
>>>>>> simultaneously. Only when there is no !exclude_guest event on host,
>>>>>> guest is allowed to exclusively own the PMU HW resource.
>>>>>>
>>>>>>
>>>>>>> Just like FPU register, it is shared by VM and host during different
>>>>>>> time and it is lately switched. But if IPI or timer interrupt uses
>>>>>>> FPU
>>>>>>> register on host, there will be the same issue.
>>>>>> I didn't fully get your point. When IPI or timer interrupt reach, a
>>>>>> VM-exit is triggered to make CPU traps into host first and then the
>>>>>> host
>>>>> yes, it is.
>>>> This is correct. And this is one of the points that we had debated
>>>> internally whether we should do PMU context switch at vcpu loop
>>>> boundary or VM Enter/exit boundary. (host-level) timer interrupt can
>>>> force VM Exit, which I think happens every 4ms or 1ms, depending on
>>>> configuration.
>>>>
>>>> One of the key reasons we currently propose this is because it is the
>>>> same boundary as the legacy PMU, i.e., it would be simple to propose
>>>> from the perf subsystem perspective.
>>>>
>>>> Performance wise, doing PMU context switch at vcpu boundary would be
>>>> way better in general. But the downside is that perf sub-system lose
>>>> the capability to profile majority of the KVM code (functions) when
>>>> guest PMU is enabled.
>>>>
>>>>>> interrupt handler is called. Or are you complaining the executing
>>>>>> sequence of switching guest PMU MSRs and these interrupt handler?
>>>>> In our vPMU implementation, it is ok if vPMU is switched in vm exit
>>>>> path, however there is problem if vPMU is switched during vcpu thread
>>>>> sched-out/sched-in path since IPI/timer irq interrupt access pmu
>>>>> register in host mode.
>>>> Oh, the IPI/timer irq handler will access PMU registers? I thought
>>>> only the host-level NMI handler will access the PMU MSRs since PMI is
>>>> registered under NMI.
>>>>
>>>> In that case, you should disable  IRQ during vcpu context switch. For
>>>> NMI, we prevent its handler from accessing the PMU registers. In
>>>> particular, we use a per-cpu variable to guard that. So, the
>>>> host-level PMI handler for perf sub-system will check the variable
>>>> before proceeding.
>>> perf core will access pmu hw in tick timer/hrtimer/ipi function call,
>>> such as function perf_event_task_tick() is called in tick timer, there
>>> are  event_function_call(event, __perf_event_xxx, &value) in file
>>> kernel/events/core.c.
>>>
>>> https://lore.kernel.org/lkml/20240417065236.500011-1-gaosong@loongson.cn/T/#m15aeb79fdc9ce72dd5b374edd6acdcf7a9dafcf4
>>>
>> Just go through functions (not sure if all),  whether
>> perf_event_task_tick() or the callbacks of event_function_call() would
>> check the event->state first, if the event is in
>> PERF_EVENT_STATE_INACTIVE, the PMU HW MSRs would not be touched really.
>> In this new proposal, all host events with exclude_guest attribute would
>> be put on PERF_EVENT_STATE_INACTIVE sate if guest own the PMU HW
>> resource. So I think it's fine.
>>
> Is there any event in the host still having PERF_EVENT_STATE_ACTIVE?
> If so, hmm, it will reach perf_pmu_disable(event->pmu), which will
> access the global ctrl MSR.

I don't think there is any event with PERF_EVENT_STATE_ACTIVE state on 
host when guest owns the PMU HW resource.

In current solution, VM would fail to create if there is any system-wide 
event without exclude_guest attribute. If VM is created successfully and 
when vm-entry happens, the helper perf_guest_enter() would put all host 
events with exclude_guest attribute into PERF_EVENT_STATE_INACTIVE state 
and block host to create system-wide events without exclude_guest attribute.



