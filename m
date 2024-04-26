Return-Path: <kvm+bounces-16010-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EC3668B2E76
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 03:51:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5DBFA1F233B9
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 01:51:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C3DF1860;
	Fri, 26 Apr 2024 01:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bX9vhyII"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF23CEDB;
	Fri, 26 Apr 2024 01:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714096259; cv=none; b=XeLE5LcoIrOC2uC1BWt5Bm/cEsh60dprua10ueoL6M37pZlL0OZ2pAla1iAXy/socdCDiEaaYalAIKF5ISxlj3MFgBl8YIeI6ToMtq3+OFT9CtTkgc/D1bJpK5zfHS8UJzvdiz2pzprb1BW3BHXdDf5HkEs2xnIR7z5j24CKnOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714096259; c=relaxed/simple;
	bh=DijMBJtYKcTn6lyH2aQ4zK9TawYHl4zqY8ibfMGuNyk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jWNvtCRhtVcPYmoOhITMhk8y7IxZIbVg9hUWLyD80xqVzh1iCq1L6YQonblOAgd2lfWV6RWiIx/AzB9txa0XCN9PjySFP3LuR++Ki1ULW3bppJ9m0/etcaxwY5VES5B+6n6bPvbFsfuc0DGPGceC/I7C6cfqL2bDp7BXlJCxVQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bX9vhyII; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714096258; x=1745632258;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=DijMBJtYKcTn6lyH2aQ4zK9TawYHl4zqY8ibfMGuNyk=;
  b=bX9vhyIIMCekUSwDR8J7dFTwOWjAS4tTX5dj/0fbHu+BNoh69bhUJpb9
   1Th3r9q2MNCPSuGPDVysrPogfa6+tYdGSf2LjOTb8mfP1QGcHXmJvyIlF
   iPNcCmFIbLB/yIGmtQE8/NAnbB0uixlXgik0uWP6NfB4iZPunF33CsECB
   qNp7mD6SwvFcSK8RFfZdgFf9TOElUB0tLvjHMh5zX5rvL9f+j/0JAAzWm
   0Y93yDL4c6To8CxWg5zCaIfEZOrsg1tMDaIHYJhqai19DwkyK1ICZs9Rk
   F0Pzu5Bk6oAK6TNMYUGAxmZ4LbgTYt1xY9YETfydvPL6zQBJyElhszAdq
   Q==;
X-CSE-ConnectionGUID: Ni/C6H25SjCEfeNKZI0uXA==
X-CSE-MsgGUID: b0eTb74LT66ptS6+mM7+SQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11055"; a="20971487"
X-IronPort-AV: E=Sophos;i="6.07,231,1708416000"; 
   d="scan'208";a="20971487"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2024 18:50:58 -0700
X-CSE-ConnectionGUID: MTU6OKoQS4S2S6UHyXUw5Q==
X-CSE-MsgGUID: oRNlyLgbTtukzca/wMPQZw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,231,1708416000"; 
   d="scan'208";a="25360434"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.245.127]) ([10.124.245.127])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2024 18:50:52 -0700
Message-ID: <bebdafb8-387c-4984-885a-8b22f2d9b9f5@linux.intel.com>
Date: Fri, 26 Apr 2024 09:50:50 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 23/41] KVM: x86/pmu: Implement the save/restore of PMU
 state for Intel CPU
To: "Liang, Kan" <kan.liang@linux.intel.com>,
 Mingwei Zhang <mizhang@google.com>
Cc: Sean Christopherson <seanjc@google.com>, maobibo <maobibo@loongson.cn>,
 Xiong Zhang <xiong.y.zhang@linux.intel.com>, pbonzini@redhat.com,
 peterz@infradead.org, kan.liang@intel.com, zhenyuw@linux.intel.com,
 jmattson@google.com, kvm@vger.kernel.org, linux-perf-users@vger.kernel.org,
 linux-kernel@vger.kernel.org, zhiyuan.lv@intel.com, eranian@google.com,
 irogers@google.com, samantha.alt@intel.com, like.xu.linux@gmail.com,
 chao.gao@intel.com
References: <ZiaX3H3YfrVh50cs@google.com>
 <d8f3497b-9f63-e30e-0c63-253908d40ac2@loongson.cn>
 <d980dd10-e4c4-4774-b107-77b320cec9f9@linux.intel.com>
 <b5e97aa1-7683-4eff-e1e3-58ac98a8d719@loongson.cn>
 <1ec7a21c-71d0-4f3e-9fa3-3de8ca0f7315@linux.intel.com>
 <5279eabc-ca46-ee1b-b80d-9a511ba90a36@loongson.cn>
 <CAL715WJK893gQd1m9CCAjz5OkxsRc5C4ZR7yJWJXbaGvCeZxQA@mail.gmail.com>
 <b3868bf5-4e16-3435-c807-f484821fccc6@loongson.cn>
 <CAL715W++maAt2Ujfvmu1pZKS4R5EmAPebTU_h9AB8aFbdLFrTQ@mail.gmail.com>
 <f843298c-db08-4fde-9887-13de18d960ac@linux.intel.com>
 <Zikeh2eGjwzDbytu@google.com>
 <7834a811-4764-42aa-8198-55c4556d947b@linux.intel.com>
 <CAL715WKh8VBJ-O50oqSnCqKPQo4Bor_aMnRZeS_TzJP3ja8-YQ@mail.gmail.com>
 <6af2da05-cb47-46f7-b129-08463bc9469b@linux.intel.com>
 <CAL715W+zeqKenPLP2Fm9u_BkGRKAk-mncsOxrg=EKs74qK5f1Q@mail.gmail.com>
 <42acf1fc-1603-4ac5-8a09-edae2d85963d@linux.intel.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <42acf1fc-1603-4ac5-8a09-edae2d85963d@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 4/26/2024 4:43 AM, Liang, Kan wrote:
>
> On 2024-04-25 4:16 p.m., Mingwei Zhang wrote:
>> On Thu, Apr 25, 2024 at 9:13 AM Liang, Kan <kan.liang@linux.intel.com> wrote:
>>>
>>>
>>> On 2024-04-25 12:24 a.m., Mingwei Zhang wrote:
>>>> On Wed, Apr 24, 2024 at 8:56 PM Mi, Dapeng <dapeng1.mi@linux.intel.com> wrote:
>>>>>
>>>>> On 4/24/2024 11:00 PM, Sean Christopherson wrote:
>>>>>> On Wed, Apr 24, 2024, Dapeng Mi wrote:
>>>>>>> On 4/24/2024 1:02 AM, Mingwei Zhang wrote:
>>>>>>>>>> Maybe, (just maybe), it is possible to do PMU context switch at vcpu
>>>>>>>>>> boundary normally, but doing it at VM Enter/Exit boundary when host is
>>>>>>>>>> profiling KVM kernel module. So, dynamically adjusting PMU context
>>>>>>>>>> switch location could be an option.
>>>>>>>>> If there are two VMs with pmu enabled both, however host PMU is not
>>>>>>>>> enabled. PMU context switch should be done in vcpu thread sched-out path.
>>>>>>>>>
>>>>>>>>> If host pmu is used also, we can choose whether PMU switch should be
>>>>>>>>> done in vm exit path or vcpu thread sched-out path.
>>>>>>>>>
>>>>>>>> host PMU is always enabled, ie., Linux currently does not support KVM
>>>>>>>> PMU running standalone. I guess what you mean is there are no active
>>>>>>>> perf_events on the host side. Allowing a PMU context switch drifting
>>>>>>>> from vm-enter/exit boundary to vcpu loop boundary by checking host
>>>>>>>> side events might be a good option. We can keep the discussion, but I
>>>>>>>> won't propose that in v2.
>>>>>>> I suspect if it's really doable to do this deferring. This still makes host
>>>>>>> lose the most of capability to profile KVM. Per my understanding, most of
>>>>>>> KVM overhead happens in the vcpu loop, exactly speaking in VM-exit handling.
>>>>>>> We have no idea when host want to create perf event to profile KVM, it could
>>>>>>> be at any time.
>>>>>> No, the idea is that KVM will load host PMU state asap, but only when host PMU
>>>>>> state actually needs to be loaded, i.e. only when there are relevant host events.
>>>>>>
>>>>>> If there are no host perf events, KVM keeps guest PMU state loaded for the entire
>>>>>> KVM_RUN loop, i.e. provides optimal behavior for the guest.  But if a host perf
>>>>>> events exists (or comes along), the KVM context switches PMU at VM-Enter/VM-Exit,
>>>>>> i.e. lets the host profile almost all of KVM, at the cost of a degraded experience
>>>>>> for the guest while host perf events are active.
>>>>> I see. So KVM needs to provide a callback which needs to be called in
>>>>> the IPI handler. The KVM callback needs to be called to switch PMU state
>>>>> before perf really enabling host event and touching PMU MSRs. And only
>>>>> the perf event with exclude_guest attribute is allowed to create on
>>>>> host. Thanks.
>>>> Do we really need a KVM callback? I think that is one option.
>>>>
>>>> Immediately after VMEXIT, KVM will check whether there are "host perf
>>>> events". If so, do the PMU context switch immediately. Otherwise, keep
>>>> deferring the context switch to the end of vPMU loop.
>>>>
>>>> Detecting if there are "host perf events" would be interesting. The
>>>> "host perf events" refer to the perf_events on the host that are
>>>> active and assigned with HW counters and that are saved when context
>>>> switching to the guest PMU. I think getting those events could be done
>>>> by fetching the bitmaps in cpuc.
>>> The cpuc is ARCH specific structure. I don't think it can be get in the
>>> generic code. You probably have to implement ARCH specific functions to
>>> fetch the bitmaps. It probably won't worth it.
>>>
>>> You may check the pinned_groups and flexible_groups to understand if
>>> there are host perf events which may be scheduled when VM-exit. But it
>>> will not tell the idx of the counters which can only be got when the
>>> host event is really scheduled.
>>>
>>>> I have to look into the details. But
>>>> at the time of VMEXIT, kvm should already have that information, so it
>>>> can immediately decide whether to do the PMU context switch or not.
>>>>
>>>> oh, but when the control is executing within the run loop, a
>>>> host-level profiling starts, say 'perf record -a ...', it will
>>>> generate an IPI to all CPUs. Maybe that's when we need a callback so
>>>> the KVM guest PMU context gets preempted for the host-level profiling.
>>>> Gah..
>>>>
>>>> hmm, not a fan of that. That means the host can poke the guest PMU
>>>> context at any time and cause higher overhead. But I admit it is much
>>>> better than the current approach.
>>>>
>>>> The only thing is that: any command like 'perf record/stat -a' shot in
>>>> dark corners of the host can preempt guest PMUs of _all_ running VMs.
>>>> So, to alleviate that, maybe a module parameter that disables this
>>>> "preemption" is possible? This should fit scenarios where we don't
>>>> want guest PMU to be preempted outside of the vCPU loop?
>>>>
>>> It should not happen. For the current implementation, perf rejects all
>>> the !exclude_guest system-wide event creation if a guest with the vPMU
>>> is running.
>>> However, it's possible to create an exclude_guest system-wide event at
>>> any time. KVM cannot use the information from the VM-entry to decide if
>>> there will be active perf events in the VM-exit.
>> Hmm, why not? If there is any exclude_guest system-wide event,
>> perf_guest_enter() can return something to tell KVM "hey, some active
>> host events are swapped out. they are originally in counter #2 and
>> #3". If so, at the time when perf_guest_enter() returns, KVM will ack
>> that and keep it in its pmu data structure.
> I think it's possible that someone creates !exclude_guest event after
> the perf_guest_enter(). The stale information is saved in the KVM. Perf
> will schedule the event in the next perf_guest_exit(). KVM will not know it.
>
>> Now, when doing context switching back to host at just VMEXIT, KVM
>> will check this data and see if host perf context has something active
>> (of course, they are all exclude_guest events). If not, deferring the
>> context switch to vcpu boundary. Otherwise, do the proper PMU context
>> switching by respecting the occupied counter positions on the host
>> side, i.e., avoid doubling the work on the KVM side.
>>
>> Kan, any suggestion on the above approach?
> I think we can only know the accurate event list at perf_guest_exit().
> You may check the pinned_groups and flexible_groups, which tell if there
> are candidate events.
>
>> Totally understand that
>> there might be some difficulty, since perf subsystem works in several
>> layers and obviously fetching low-level mapping is arch specific work.
>> If that is difficult, we can split the work in two phases: 1) phase
>> #1, just ask perf to tell kvm if there are active exclude_guest events
>> swapped out; 2) phase #2, ask perf to tell their (low-level) counter
>> indices.
>>
> If you want an accurate counter mask, the changes in the arch specific
> code is required. Two phases sound good to me.
>
> Besides perf changes, I think the KVM should also track which counters
> need to be saved/restored. The information can be get from the EventSel
> interception.

Yes, that's another optimization from guest point view. It's in our 
to-do list.


>
> Thanks,
> Kan
>>> The perf_guest_exit() will reload the host state. It's impossible to
>>> save the guest state after that. We may need a KVM callback. So perf can
>>> tell KVM whether to save the guest state before perf reloads the host state.
>>>
>>> Thanks,
>>> Kan
>>>>>
>>>>>> My original sketch: https://lore.kernel.org/all/ZR3eNtP5IVAHeFNC@googlecom

