Return-Path: <kvm+bounces-16013-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 936B98B2F4A
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 06:03:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4A73B281BA9
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 04:03:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 377B18248D;
	Fri, 26 Apr 2024 04:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="M4QGuOK8"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF0CB80BF0;
	Fri, 26 Apr 2024 04:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104185; cv=none; b=M3MFlZCZMb8ccaRdIoAh7WXfNHEbIyCanW3fiaUJ7pZT4mLX023xrDPQAue5pGZ4Q+UaMRuvF1fctfVyGpzoDTyeil/fO4r8D/nmF7LFZgh7sXNDhTLsS6Iv9XV9lZJti3CLA6OwD9jNJowrqGXO+Te7l6IXHLbvncbuN50eS6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104185; c=relaxed/simple;
	bh=DPPO7+IIdKqrZTMgn/awucbtj2keBJmlKS62ZSs0Jzc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=A2F97a3Ugqcmo5bzCtLOELW17neWqxRMQfIkLo2KYqIYzvHHTIbcHRnsyTq5JjKA6CaNjiNWJHoQKefbVjkBbtT9gFnW9JL0yF4Xm/2ZC2pJ6DQgyJ0a3VxXkOdSMenzq7ciARLDM0fE33lUkP9XLzR/5Ip8eqkRyyUlBAU3DIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=M4QGuOK8; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714104183; x=1745640183;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=DPPO7+IIdKqrZTMgn/awucbtj2keBJmlKS62ZSs0Jzc=;
  b=M4QGuOK8CNAK/MF425LxDxgeXwiK/vvliPP9ov0cB+8L95ZCjDfkV5mi
   PWexw70pvZt+5lCTrUDa/kGgl3sJfKbPM6TqwEuvu7CLw5uYGW2SxKdEe
   OT7Oi9IiTNQJ9SReS6kPV5+PCTUmSODxt7pJZOobTvetgP6mLrvFUOpiB
   frvBQnWUOHY13xxKDngNpbSQKR2Mhv+F4IKW3uA/pKamSp3H3cZH4g2YD
   PucrGLD1IOSNcvJRKdF26i4MF6YSybHM1qsF9ygqCIuIXU6xQchpdMVYo
   dFycu0HSaJ9Xmh0XT9TyQ9MFEAXMaxG9H9VTJXfM0aeeVjrOYQqzQWRK1
   g==;
X-CSE-ConnectionGUID: cPxBArSMQ4KoQXCJeo7UPw==
X-CSE-MsgGUID: qIBLe0AdQFWnTUUPLGJQig==
X-IronPort-AV: E=McAfee;i="6600,9927,11055"; a="9949711"
X-IronPort-AV: E=Sophos;i="6.07,231,1708416000"; 
   d="scan'208";a="9949711"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2024 21:03:02 -0700
X-CSE-ConnectionGUID: iBr5nSQFSVCX6uW8QPVtUw==
X-CSE-MsgGUID: 2zefmWEqT6ykAt5rlR+ARQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,231,1708416000"; 
   d="scan'208";a="25930465"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.245.127]) ([10.124.245.127])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2024 21:02:59 -0700
Message-ID: <c96330d1-9750-4b65-8465-1b6f46bc11ba@linux.intel.com>
Date: Fri, 26 Apr 2024 12:02:55 +0800
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
Cc: Sean Christopherson <seanjc@google.com>,
 Kan Liang <kan.liang@linux.intel.com>, maobibo <maobibo@loongson.cn>,
 Xiong Zhang <xiong.y.zhang@linux.intel.com>, pbonzini@redhat.com,
 peterz@infradead.org, kan.liang@intel.com, zhenyuw@linux.intel.com,
 jmattson@google.com, kvm@vger.kernel.org, linux-perf-users@vger.kernel.org,
 linux-kernel@vger.kernel.org, zhiyuan.lv@intel.com, eranian@google.com,
 irogers@google.com, samantha.alt@intel.com, like.xu.linux@gmail.com,
 chao.gao@intel.com
References: <CAL715WJK893gQd1m9CCAjz5OkxsRc5C4ZR7yJWJXbaGvCeZxQA@mail.gmail.com>
 <b3868bf5-4e16-3435-c807-f484821fccc6@loongson.cn>
 <CAL715W++maAt2Ujfvmu1pZKS4R5EmAPebTU_h9AB8aFbdLFrTQ@mail.gmail.com>
 <f843298c-db08-4fde-9887-13de18d960ac@linux.intel.com>
 <Zikeh2eGjwzDbytu@google.com>
 <7834a811-4764-42aa-8198-55c4556d947b@linux.intel.com>
 <CAL715WKh8VBJ-O50oqSnCqKPQo4Bor_aMnRZeS_TzJP3ja8-YQ@mail.gmail.com>
 <6af2da05-cb47-46f7-b129-08463bc9469b@linux.intel.com>
 <CAL715W+zeqKenPLP2Fm9u_BkGRKAk-mncsOxrg=EKs74qK5f1Q@mail.gmail.com>
 <42acf1fc-1603-4ac5-8a09-edae2d85963d@linux.intel.com>
 <ZirPGnSDUzD-iWwc@google.com>
 <77913327-2115-42b5-850a-04ef0581faa7@linux.intel.com>
 <CAL715WJCHJD_wcJ+r4TyWfvmk9uNT_kPy7Pt=CHkB-Sf0D4Rqw@mail.gmail.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <CAL715WJCHJD_wcJ+r4TyWfvmk9uNT_kPy7Pt=CHkB-Sf0D4Rqw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 4/26/2024 11:12 AM, Mingwei Zhang wrote:
> On Thu, Apr 25, 2024 at 6:46 PM Mi, Dapeng <dapeng1.mi@linux.intel.com> wrote:
>>
>> On 4/26/2024 5:46 AM, Sean Christopherson wrote:
>>> On Thu, Apr 25, 2024, Kan Liang wrote:
>>>> On 2024-04-25 4:16 p.m., Mingwei Zhang wrote:
>>>>> On Thu, Apr 25, 2024 at 9:13 AM Liang, Kan <kan.liang@linux.intel.com> wrote:
>>>>>> It should not happen. For the current implementation, perf rejects all
>>>>>> the !exclude_guest system-wide event creation if a guest with the vPMU
>>>>>> is running.
>>>>>> However, it's possible to create an exclude_guest system-wide event at
>>>>>> any time. KVM cannot use the information from the VM-entry to decide if
>>>>>> there will be active perf events in the VM-exit.
>>>>> Hmm, why not? If there is any exclude_guest system-wide event,
>>>>> perf_guest_enter() can return something to tell KVM "hey, some active
>>>>> host events are swapped out. they are originally in counter #2 and
>>>>> #3". If so, at the time when perf_guest_enter() returns, KVM will ack
>>>>> that and keep it in its pmu data structure.
>>>> I think it's possible that someone creates !exclude_guest event after
>>> I assume you mean an exclude_guest=1 event?  Because perf should be in a state
>>> where it rejects exclude_guest=0 events.
>> Suppose should be exclude_guest=1 event, the perf event without
>> exclude_guest attribute would be blocked to create in the v2 patches
>> which we are working on.
>>
>>
>>>> the perf_guest_enter(). The stale information is saved in the KVM. Perf
>>>> will schedule the event in the next perf_guest_exit(). KVM will not know it.
>>> Ya, the creation of an event on a CPU that currently has guest PMU state loaded
>>> is what I had in mind when I suggested a callback in my sketch:
>>>
>>>    :  D. Add a perf callback that is invoked from IRQ context when perf wants to
>>>    :     configure a new PMU-based events, *before* actually programming the MSRs,
>>>    :     and have KVM's callback put the guest PMU state
>>
>> when host creates a perf event with exclude_guest attribute which is
>> used to profile KVM/VMM user space, the vCPU process could work at three
>> places.
>>
>> 1. in guest state (non-root mode)
>>
>> 2. inside vcpu-loop
>>
>> 3. outside vcpu-loop
>>
>> Since the PMU state has already been switched to host state, we don't
>> need to consider the case 3 and only care about cases 1 and 2.
>>
>> when host creates a perf event with exclude_guest attribute to profile
>> KVM/VMM user space,  an IPI is triggered to enable the perf event
>> eventually like the following code shows.
>>
>> event_function_call(event, __perf_event_enable, NULL);
>>
>> For case 1,  a vm-exit is triggered and KVM starts to process the
>> vm-exit and then run IPI irq handler, exactly speaking
>> __perf_event_enable() to enable the perf event.
>>
>> For case 2, the IPI irq handler would preempt the vcpu-loop and call
>> __perf_event_enable() to enable the perf event.
>>
>> So IMO KVM just needs to provide a callback to switch guest/host PMU
>> state, and __perf_event_enable() calls this callback before really
>> touching PMU MSRs.
> ok, in this case, do we still need KVM to query perf if there are
> active exclude_guest events? yes? Because there is an ordering issue.
> The above suggests that the host-level perf profiling comes when a VM
> is already running, there is an IPI that can invoke the callback and
> trigger preemption. In this case, KVM should switch the context from
> guest to host. What if it is the other way around, ie., host-level
> profiling runs first and then VM runs?
>
> In this case, just before entering the vcpu loop, kvm should check
> whether there is an active host event and save that into a pmu data
> structure. If none, do the context switch early (so that KVM saves a
> huge amount of unnecessary PMU context switches in the future).
> Otherwise, keep the host PMU context until vm-enter. At the time of
> vm-exit, do the check again using the data stored in pmu structure. If
> there is an active event do the context switch to the host PMU,
> otherwise defer that until exiting the vcpu loop. Of course, in the
> meantime, if there is any perf profiling started causing the IPI, the
> irq handler calls the callback, preempting the guest PMU context. If
> that happens, at the time of exiting the vcpu boundary, PMU context
> switch is skipped since it is already done. Of course, note that the
> irq could come at any time, so the PMU context switch in all 4
> locations need to check the state flag (and skip the context switch if
> needed).
>
> So this requires vcpu->pmu has two pieces of state information: 1) the
> flag similar to TIF_NEED_FPU_LOAD; 2) host perf context info (phase #1
> just a boolean; phase #2, bitmap of occupied counters).

I still had no chance to look at the details about vFPU implementation, 
currently I have no idea what we need exactly on vPMU side, a flag or a 
callback. Anyway, that's just implementation details, we can look at it 
when starting to implement it.

>
> This is a non-trivial optimization on the PMU context switch. I am
> thinking about splitting them into the following phases:
>
> 1) lazy PMU context switch, i.e., wait until the guest touches PMU MSR
> for the 1st time.
> 2) fast PMU context switch on KVM side, i.e., KVM checking event
> selector value (enable/disable) and selectively switch PMU state
> (reducing rd/wr msrs)
> 3) dynamic PMU context boundary, ie., KVM can dynamically choose PMU
> context switch boundary depending on existing active host-level
> events.
> 3.1) more accurate dynamic PMU context switch, ie., KVM checking
> host-level counter position and further reduces the number of msr
> accesses.
> 4) guest PMU context preemption, i.e., any new host-level perf
> profiling can immediately preempt the guest PMU in the vcpu loop
> (instead of waiting for the next PMU context switch in KVM).

Great! we have a whole clear picture about the optimization right now. 
BTW, the optimization 1 and 2 are already on our original to-do list. We 
plan to do it after RFC v2 is ready.


>
> Thanks.
> -Mingwei
>>> It's a similar idea to TIF_NEED_FPU_LOAD, just that instead of a common chunk of
>>> kernel code swapping out the guest state (kernel_fpu_begin()), it's a callback
>>> into KVM.

