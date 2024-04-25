Return-Path: <kvm+bounces-15971-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 231338B2A07
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 22:44:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2FCC0B24D89
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 20:44:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C826714F9EE;
	Thu, 25 Apr 2024 20:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fDAKMudm"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 307CF153834;
	Thu, 25 Apr 2024 20:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714077826; cv=none; b=U0QtVxCfQap6iiy/HTonUDCE02cnCwhkBSrLh9oR2cusYQ/h1s2lUyY2JpCv9IvN0WakvkVN1JBHl2WOVkP3TClRuRcvu2hvF3Ebu84HmuSTwsf4zevlZkdOhBLDDLl/az5lQIzhsOeqaqyOLyf/juMUe9HGXiKjlcPxU4RL7jY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714077826; c=relaxed/simple;
	bh=/Bry/LrWz5s3cSAoG/NRli3XyUXM2aR+pdRh6BaisJI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cgKIwssdIe+aI454K/EGysOjJcM8DE0QIrw0q7QgKn4rx1DwTMBxhu5Nda+UDBAbw3DSoI71b0zflqIiF2dZzqH2M7xtyGPk09G5/0v2POD6e+QtAdufYEh2i4uyXUsdnn7ZTMbLjdWTZIovCjVVgurA/QEfkCvseTvBu8FhCjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fDAKMudm; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714077824; x=1745613824;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=/Bry/LrWz5s3cSAoG/NRli3XyUXM2aR+pdRh6BaisJI=;
  b=fDAKMudml7s8S6cbiBZM3eQJ6rPz4KH+enecXg4i1ooepCevzeOjdkql
   jGFXq78l6AbvHhNWSUXdrFEPyp6VG9uXwxGrcDeafs9dEL246heZjVX7Q
   nVhcuvAVMCjD8jILYwxz00/yYk0CKnLRVuQD4Nid8xXrxM2Of7k74nhLI
   Dq8ZNV94FCInvtqHOvu+KJhQ66nKKMQE1fPdtbgwBzNt0czRUMSP3UJ92
   dwIyuMOnDqP1GhTCKdpTFEk7wXRgxk2otudArTTM3YBAJ+vYYUxGC0+CW
   s+kUnWDIFY3jqkzm8NtXsS5fWy3Qliy0kef8UOEyg8iJkjaqUBhtpa/rs
   g==;
X-CSE-ConnectionGUID: +9cD1Oj7S/CzpudElRlSXA==
X-CSE-MsgGUID: HdguReztRk+01jG1fIOD+g==
X-IronPort-AV: E=McAfee;i="6600,9927,11055"; a="12732535"
X-IronPort-AV: E=Sophos;i="6.07,230,1708416000"; 
   d="scan'208";a="12732535"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2024 13:43:43 -0700
X-CSE-ConnectionGUID: 7KgeubM6TomVXo4FwsgdrA==
X-CSE-MsgGUID: HalkeOTpSIGqjCfc+OhXKQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,230,1708416000"; 
   d="scan'208";a="25609924"
Received: from linux.intel.com ([10.54.29.200])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2024 13:43:44 -0700
Received: from [10.212.96.44] (kliang2-mobl1.ccr.corp.intel.com [10.212.96.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by linux.intel.com (Postfix) with ESMTPS id 1266C206DFCE;
	Thu, 25 Apr 2024 13:43:40 -0700 (PDT)
Message-ID: <42acf1fc-1603-4ac5-8a09-edae2d85963d@linux.intel.com>
Date: Thu, 25 Apr 2024 16:43:39 -0400
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
Cc: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>,
 Sean Christopherson <seanjc@google.com>, maobibo <maobibo@loongson.cn>,
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
Content-Language: en-US
From: "Liang, Kan" <kan.liang@linux.intel.com>
In-Reply-To: <CAL715W+zeqKenPLP2Fm9u_BkGRKAk-mncsOxrg=EKs74qK5f1Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 2024-04-25 4:16 p.m., Mingwei Zhang wrote:
> On Thu, Apr 25, 2024 at 9:13 AM Liang, Kan <kan.liang@linux.intel.com> wrote:
>>
>>
>>
>> On 2024-04-25 12:24 a.m., Mingwei Zhang wrote:
>>> On Wed, Apr 24, 2024 at 8:56 PM Mi, Dapeng <dapeng1.mi@linux.intel.com> wrote:
>>>>
>>>>
>>>> On 4/24/2024 11:00 PM, Sean Christopherson wrote:
>>>>> On Wed, Apr 24, 2024, Dapeng Mi wrote:
>>>>>> On 4/24/2024 1:02 AM, Mingwei Zhang wrote:
>>>>>>>>> Maybe, (just maybe), it is possible to do PMU context switch at vcpu
>>>>>>>>> boundary normally, but doing it at VM Enter/Exit boundary when host is
>>>>>>>>> profiling KVM kernel module. So, dynamically adjusting PMU context
>>>>>>>>> switch location could be an option.
>>>>>>>> If there are two VMs with pmu enabled both, however host PMU is not
>>>>>>>> enabled. PMU context switch should be done in vcpu thread sched-out path.
>>>>>>>>
>>>>>>>> If host pmu is used also, we can choose whether PMU switch should be
>>>>>>>> done in vm exit path or vcpu thread sched-out path.
>>>>>>>>
>>>>>>> host PMU is always enabled, ie., Linux currently does not support KVM
>>>>>>> PMU running standalone. I guess what you mean is there are no active
>>>>>>> perf_events on the host side. Allowing a PMU context switch drifting
>>>>>>> from vm-enter/exit boundary to vcpu loop boundary by checking host
>>>>>>> side events might be a good option. We can keep the discussion, but I
>>>>>>> won't propose that in v2.
>>>>>> I suspect if it's really doable to do this deferring. This still makes host
>>>>>> lose the most of capability to profile KVM. Per my understanding, most of
>>>>>> KVM overhead happens in the vcpu loop, exactly speaking in VM-exit handling.
>>>>>> We have no idea when host want to create perf event to profile KVM, it could
>>>>>> be at any time.
>>>>> No, the idea is that KVM will load host PMU state asap, but only when host PMU
>>>>> state actually needs to be loaded, i.e. only when there are relevant host events.
>>>>>
>>>>> If there are no host perf events, KVM keeps guest PMU state loaded for the entire
>>>>> KVM_RUN loop, i.e. provides optimal behavior for the guest.  But if a host perf
>>>>> events exists (or comes along), the KVM context switches PMU at VM-Enter/VM-Exit,
>>>>> i.e. lets the host profile almost all of KVM, at the cost of a degraded experience
>>>>> for the guest while host perf events are active.
>>>>
>>>> I see. So KVM needs to provide a callback which needs to be called in
>>>> the IPI handler. The KVM callback needs to be called to switch PMU state
>>>> before perf really enabling host event and touching PMU MSRs. And only
>>>> the perf event with exclude_guest attribute is allowed to create on
>>>> host. Thanks.
>>>
>>> Do we really need a KVM callback? I think that is one option.
>>>
>>> Immediately after VMEXIT, KVM will check whether there are "host perf
>>> events". If so, do the PMU context switch immediately. Otherwise, keep
>>> deferring the context switch to the end of vPMU loop.
>>>
>>> Detecting if there are "host perf events" would be interesting. The
>>> "host perf events" refer to the perf_events on the host that are
>>> active and assigned with HW counters and that are saved when context
>>> switching to the guest PMU. I think getting those events could be done
>>> by fetching the bitmaps in cpuc.
>>
>> The cpuc is ARCH specific structure. I don't think it can be get in the
>> generic code. You probably have to implement ARCH specific functions to
>> fetch the bitmaps. It probably won't worth it.
>>
>> You may check the pinned_groups and flexible_groups to understand if
>> there are host perf events which may be scheduled when VM-exit. But it
>> will not tell the idx of the counters which can only be got when the
>> host event is really scheduled.
>>
>>> I have to look into the details. But
>>> at the time of VMEXIT, kvm should already have that information, so it
>>> can immediately decide whether to do the PMU context switch or not.
>>>
>>> oh, but when the control is executing within the run loop, a
>>> host-level profiling starts, say 'perf record -a ...', it will
>>> generate an IPI to all CPUs. Maybe that's when we need a callback so
>>> the KVM guest PMU context gets preempted for the host-level profiling.
>>> Gah..
>>>
>>> hmm, not a fan of that. That means the host can poke the guest PMU
>>> context at any time and cause higher overhead. But I admit it is much
>>> better than the current approach.
>>>
>>> The only thing is that: any command like 'perf record/stat -a' shot in
>>> dark corners of the host can preempt guest PMUs of _all_ running VMs.
>>> So, to alleviate that, maybe a module parameter that disables this
>>> "preemption" is possible? This should fit scenarios where we don't
>>> want guest PMU to be preempted outside of the vCPU loop?
>>>
>>
>> It should not happen. For the current implementation, perf rejects all
>> the !exclude_guest system-wide event creation if a guest with the vPMU
>> is running.
>> However, it's possible to create an exclude_guest system-wide event at
>> any time. KVM cannot use the information from the VM-entry to decide if
>> there will be active perf events in the VM-exit.
> 
> Hmm, why not? If there is any exclude_guest system-wide event,
> perf_guest_enter() can return something to tell KVM "hey, some active
> host events are swapped out. they are originally in counter #2 and
> #3". If so, at the time when perf_guest_enter() returns, KVM will ack
> that and keep it in its pmu data structure.

I think it's possible that someone creates !exclude_guest event after
the perf_guest_enter(). The stale information is saved in the KVM. Perf
will schedule the event in the next perf_guest_exit(). KVM will not know it.

> 
> Now, when doing context switching back to host at just VMEXIT, KVM
> will check this data and see if host perf context has something active
> (of course, they are all exclude_guest events). If not, deferring the
> context switch to vcpu boundary. Otherwise, do the proper PMU context
> switching by respecting the occupied counter positions on the host
> side, i.e., avoid doubling the work on the KVM side.
> 
> Kan, any suggestion on the above approach? 

I think we can only know the accurate event list at perf_guest_exit().
You may check the pinned_groups and flexible_groups, which tell if there
are candidate events.

> Totally understand that
> there might be some difficulty, since perf subsystem works in several
> layers and obviously fetching low-level mapping is arch specific work.
> If that is difficult, we can split the work in two phases: 1) phase
> #1, just ask perf to tell kvm if there are active exclude_guest events
> swapped out; 2) phase #2, ask perf to tell their (low-level) counter
> indices.
>

If you want an accurate counter mask, the changes in the arch specific
code is required. Two phases sound good to me.

Besides perf changes, I think the KVM should also track which counters
need to be saved/restored. The information can be get from the EventSel
interception.

Thanks,
Kan
>>
>> The perf_guest_exit() will reload the host state. It's impossible to
>> save the guest state after that. We may need a KVM callback. So perf can
>> tell KVM whether to save the guest state before perf reloads the host state.
>>
>> Thanks,
>> Kan
>>>>
>>>>
>>>>>
>>>>> My original sketch: https://lore.kernel.org/all/ZR3eNtP5IVAHeFNC@googlecom
>>>
> 

