Return-Path: <kvm+bounces-15618-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D8C38AE04C
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 10:52:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 03F0928328B
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 08:52:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 040A15644F;
	Tue, 23 Apr 2024 08:51:57 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66059320E;
	Tue, 23 Apr 2024 08:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713862316; cv=none; b=sghzWt8FgXP3yLOGDPxC3utcpFbX/aPP42kKlSEb0InTY/3mBhz6wICxVrSRYBmMVzqzySTEzn9kCcNOGdSZC2uxdVt7PDSBLBgXlf6aB8EDyJ0zyUEjM54bXRoEo+9lnP6nVMb+Tg48BbGRkVXhKi7biaJPk4HoWYDG3CHgjPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713862316; c=relaxed/simple;
	bh=0U+dC9aMBDCYgJXVzEBscSIeQ03/FPKDhOX4Neg2/sk=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=AxTb0HZp+PfKuEKxV3tTxYnRZ5SPtLez1U4MTz088jP6YcUdKF5xAfZzl5LA66F5xedXiMGnU2Ntr0dV/NZSuiG2W1s6yalY5N80JVGUDcFQXt1+9H4jk6KyqyiOe68VKqnn8ZGvjjHbpQiiIc0Yz6GKM2DG2TxtimZqthZi8AY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.173])
	by gateway (Coremail) with SMTP id _____8BxV_Cididm7kMBAA--.7536S3;
	Tue, 23 Apr 2024 16:51:47 +0800 (CST)
Received: from [10.20.42.173] (unknown [10.20.42.173])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8CxTN6ddidmdykCAA--.9087S3;
	Tue, 23 Apr 2024 16:51:43 +0800 (CST)
Subject: Re: [RFC PATCH 23/41] KVM: x86/pmu: Implement the save/restore of PMU
 state for Intel CPU
To: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>,
 Mingwei Zhang <mizhang@google.com>
Cc: Sean Christopherson <seanjc@google.com>,
 Xiong Zhang <xiong.y.zhang@linux.intel.com>, pbonzini@redhat.com,
 peterz@infradead.org, kan.liang@intel.com, zhenyuw@linux.intel.com,
 jmattson@google.com, kvm@vger.kernel.org, linux-perf-users@vger.kernel.org,
 linux-kernel@vger.kernel.org, zhiyuan.lv@intel.com, eranian@google.com,
 irogers@google.com, samantha.alt@intel.com, like.xu.linux@gmail.com,
 chao.gao@intel.com
References: <18b19dd4-6d76-4ed8-b784-32436ab93d06@linux.intel.com>
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
 <46a889c4-b104-487e-be3e-7f4b57c0b339@linux.intel.com>
From: maobibo <maobibo@loongson.cn>
Message-ID: <f45f44e3-7888-7c45-edce-359bca2ef903@loongson.cn>
Date: Tue, 23 Apr 2024 16:51:41 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <46a889c4-b104-487e-be3e-7f4b57c0b339@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8CxTN6ddidmdykCAA--.9087S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoW3JF4kuF1UAw4xAF1UGw4UAwc_yoWfuFWxpr
	WUAF1UKr4UJr1UAw1Utw1UXF1UKry7Jr1UXr1DJr1UAr1qvr1rJr1UtryUCF1UGr1xGr1j
	qr4Utry7XryUArgCm3ZEXasCq-sJn29KB7ZKAUJUUUUx529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUPSb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
	xVW8Jr0_Cr1UM2kKe7AKxVWUAVWUtwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07
	AIYIkI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWU
	AVWUtwAv7VC2z280aVAFwI0_Gr0_Cr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI4
	8JMxk0xIA0c2IEe2xFo4CEbIxvr21lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vI
	r41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1l4IxYO2xFxVAFwI0_JF0_Jw1lx2IqxVAqx4xG67
	AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r4a6rW5MIIY
	rxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_JFI_Gr1lIxAIcVC0I7IYx2IY6xkF7I0E14
	v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWx
	JwCI42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJrUvcSsGvfC2KfnxnUUI43ZEXa7IU8loGP
	UUUUU==



On 2024/4/23 下午4:24, Mi, Dapeng wrote:
> 
> On 4/23/2024 3:10 PM, Mingwei Zhang wrote:
>> On Mon, Apr 22, 2024 at 11:45 PM Mi, Dapeng 
>> <dapeng1.mi@linux.intel.com> wrote:
>>>
>>> On 4/23/2024 2:08 PM, maobibo wrote:
>>>>
>>>> On 2024/4/23 下午12:23, Mingwei Zhang wrote:
>>>>> On Mon, Apr 22, 2024 at 8:55 PM maobibo <maobibo@loongson.cn> wrote:
>>>>>>
>>>>>>
>>>>>> On 2024/4/23 上午11:13, Mi, Dapeng wrote:
>>>>>>> On 4/23/2024 10:53 AM, maobibo wrote:
>>>>>>>>
>>>>>>>> On 2024/4/23 上午10:44, Mi, Dapeng wrote:
>>>>>>>>> On 4/23/2024 9:01 AM, maobibo wrote:
>>>>>>>>>>
>>>>>>>>>> On 2024/4/23 上午1:01, Sean Christopherson wrote:
>>>>>>>>>>> On Mon, Apr 22, 2024, maobibo wrote:
>>>>>>>>>>>> On 2024/4/16 上午6:45, Sean Christopherson wrote:
>>>>>>>>>>>>> On Mon, Apr 15, 2024, Mingwei Zhang wrote:
>>>>>>>>>>>>>> On Mon, Apr 15, 2024 at 10:38 AM Sean Christopherson
>>>>>>>>>>>>>> <seanjc@google.com> wrote:
>>>>>>>>>>>>>>> One my biggest complaints with the current vPMU code is that
>>>>>>>>>>>>>>> the roles and
>>>>>>>>>>>>>>> responsibilities between KVM and perf are poorly defined,
>>>>>>>>>>>>>>> which
>>>>>>>>>>>>>>> leads to suboptimal
>>>>>>>>>>>>>>> and hard to maintain code.
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> Case in point, I'm pretty sure leaving guest values in PMCs
>>>>>>>>>>>>>>> _would_ leak guest
>>>>>>>>>>>>>>> state to userspace processes that have RDPMC permissions, as
>>>>>>>>>>>>>>> the PMCs might not
>>>>>>>>>>>>>>> be dirty from perf's perspective (see
>>>>>>>>>>>>>>> perf_clear_dirty_counters()).
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> Blindly clearing PMCs in KVM "solves" that problem, but in
>>>>>>>>>>>>>>> doing so makes the
>>>>>>>>>>>>>>> overall code brittle because it's not clear whether KVM
>>>>>>>>>>>>>>> _needs_
>>>>>>>>>>>>>>> to clear PMCs,
>>>>>>>>>>>>>>> or if KVM is just being paranoid.
>>>>>>>>>>>>>> So once this rolls out, perf and vPMU are clients directly to
>>>>>>>>>>>>>> PMU HW.
>>>>>>>>>>>>> I don't think this is a statement we want to make, as it 
>>>>>>>>>>>>> opens a
>>>>>>>>>>>>> discussion
>>>>>>>>>>>>> that we won't win.  Nor do I think it's one we *need* to make.
>>>>>>>>>>>>> KVM doesn't need
>>>>>>>>>>>>> to be on equal footing with perf in terms of 
>>>>>>>>>>>>> owning/managing PMU
>>>>>>>>>>>>> hardware, KVM
>>>>>>>>>>>>> just needs a few APIs to allow faithfully and accurately
>>>>>>>>>>>>> virtualizing a guest PMU.
>>>>>>>>>>>>>
>>>>>>>>>>>>>> Faithful cleaning (blind cleaning) has to be the baseline
>>>>>>>>>>>>>> implementation, until both clients agree to a "deal" between
>>>>>>>>>>>>>> them.
>>>>>>>>>>>>>> Currently, there is no such deal, but I believe we could have
>>>>>>>>>>>>>> one via
>>>>>>>>>>>>>> future discussion.
>>>>>>>>>>>>> What I am saying is that there needs to be a "deal" in place
>>>>>>>>>>>>> before this code
>>>>>>>>>>>>> is merged.  It doesn't need to be anything fancy, e.g. perf 
>>>>>>>>>>>>> can
>>>>>>>>>>>>> still pave over
>>>>>>>>>>>>> PMCs it doesn't immediately load, as opposed to using
>>>>>>>>>>>>> cpu_hw_events.dirty to lazily
>>>>>>>>>>>>> do the clearing.  But perf and KVM need to work together from
>>>>>>>>>>>>> the
>>>>>>>>>>>>> get go, ie. I
>>>>>>>>>>>>> don't want KVM doing something without regard to what perf 
>>>>>>>>>>>>> does,
>>>>>>>>>>>>> and vice versa.
>>>>>>>>>>>>>
>>>>>>>>>>>> There is similar issue on LoongArch vPMU where vm can directly
>>>>>>>>>>>> pmu
>>>>>>>>>>>> hardware
>>>>>>>>>>>> and pmu hw is shard with guest and host. Besides context switch
>>>>>>>>>>>> there are
>>>>>>>>>>>> other places where perf core will access pmu hw, such as tick
>>>>>>>>>>>> timer/hrtimer/ipi function call, and KVM can only intercept
>>>>>>>>>>>> context switch.
>>>>>>>>>>> Two questions:
>>>>>>>>>>>
>>>>>>>>>>>     1) Can KVM prevent the guest from accessing the PMU?
>>>>>>>>>>>
>>>>>>>>>>>     2) If so, KVM can grant partial access to the PMU, or is 
>>>>>>>>>>> it all
>>>>>>>>>>> or nothing?
>>>>>>>>>>>
>>>>>>>>>>> If the answer to both questions is "yes", then it sounds like
>>>>>>>>>>> LoongArch *requires*
>>>>>>>>>>> mediated/passthrough support in order to virtualize its PMU.
>>>>>>>>>> Hi Sean,
>>>>>>>>>>
>>>>>>>>>> Thank for your quick response.
>>>>>>>>>>
>>>>>>>>>> yes, kvm can prevent guest from accessing the PMU and grant 
>>>>>>>>>> partial
>>>>>>>>>> or all to access to the PMU. Only that if one pmu event is 
>>>>>>>>>> granted
>>>>>>>>>> to VM, host can not access this pmu event again. There must be 
>>>>>>>>>> pmu
>>>>>>>>>> event switch if host want to.
>>>>>>>>> PMU event is a software entity which won't be shared. did you
>>>>>>>>> mean if
>>>>>>>>> a PMU HW counter is granted to VM, then Host can't access the 
>>>>>>>>> PMU HW
>>>>>>>>> counter, right?
>>>>>>>> yes, if PMU HW counter/control is granted to VM. The value comes 
>>>>>>>> from
>>>>>>>> guest, and is not meaningful for host.  Host pmu core does not know
>>>>>>>> that it is granted to VM, host still think that it owns pmu.
>>>>>>> That's one issue this patchset tries to solve. Current new mediated
>>>>>>> x86
>>>>>>> vPMU framework doesn't allow Host or Guest own the PMU HW resource
>>>>>>> simultaneously. Only when there is no !exclude_guest event on host,
>>>>>>> guest is allowed to exclusively own the PMU HW resource.
>>>>>>>
>>>>>>>
>>>>>>>> Just like FPU register, it is shared by VM and host during 
>>>>>>>> different
>>>>>>>> time and it is lately switched. But if IPI or timer interrupt uses
>>>>>>>> FPU
>>>>>>>> register on host, there will be the same issue.
>>>>>>> I didn't fully get your point. When IPI or timer interrupt reach, a
>>>>>>> VM-exit is triggered to make CPU traps into host first and then the
>>>>>>> host
>>>>>> yes, it is.
>>>>> This is correct. And this is one of the points that we had debated
>>>>> internally whether we should do PMU context switch at vcpu loop
>>>>> boundary or VM Enter/exit boundary. (host-level) timer interrupt can
>>>>> force VM Exit, which I think happens every 4ms or 1ms, depending on
>>>>> configuration.
>>>>>
>>>>> One of the key reasons we currently propose this is because it is the
>>>>> same boundary as the legacy PMU, i.e., it would be simple to propose
>>>>> from the perf subsystem perspective.
>>>>>
>>>>> Performance wise, doing PMU context switch at vcpu boundary would be
>>>>> way better in general. But the downside is that perf sub-system lose
>>>>> the capability to profile majority of the KVM code (functions) when
>>>>> guest PMU is enabled.
>>>>>
>>>>>>> interrupt handler is called. Or are you complaining the executing
>>>>>>> sequence of switching guest PMU MSRs and these interrupt handler?
>>>>>> In our vPMU implementation, it is ok if vPMU is switched in vm exit
>>>>>> path, however there is problem if vPMU is switched during vcpu thread
>>>>>> sched-out/sched-in path since IPI/timer irq interrupt access pmu
>>>>>> register in host mode.
>>>>> Oh, the IPI/timer irq handler will access PMU registers? I thought
>>>>> only the host-level NMI handler will access the PMU MSRs since PMI is
>>>>> registered under NMI.
>>>>>
>>>>> In that case, you should disable  IRQ during vcpu context switch. For
>>>>> NMI, we prevent its handler from accessing the PMU registers. In
>>>>> particular, we use a per-cpu variable to guard that. So, the
>>>>> host-level PMI handler for perf sub-system will check the variable
>>>>> before proceeding.
>>>> perf core will access pmu hw in tick timer/hrtimer/ipi function call,
>>>> such as function perf_event_task_tick() is called in tick timer, there
>>>> are  event_function_call(event, __perf_event_xxx, &value) in file
>>>> kernel/events/core.c.
>>>>
>>>> https://lore.kernel.org/lkml/20240417065236.500011-1-gaosong@loongson.cn/T/#m15aeb79fdc9ce72dd5b374edd6acdcf7a9dafcf4 
>>>>
>>>>
>>> Just go through functions (not sure if all),  whether
>>> perf_event_task_tick() or the callbacks of event_function_call() would
>>> check the event->state first, if the event is in
>>> PERF_EVENT_STATE_INACTIVE, the PMU HW MSRs would not be touched really.
>>> In this new proposal, all host events with exclude_guest attribute would
>>> be put on PERF_EVENT_STATE_INACTIVE sate if guest own the PMU HW
>>> resource. So I think it's fine.
>>>
>> Is there any event in the host still having PERF_EVENT_STATE_ACTIVE?
>> If so, hmm, it will reach perf_pmu_disable(event->pmu), which will
>> access the global ctrl MSR.
> 
> I don't think there is any event with PERF_EVENT_STATE_ACTIVE state on 
> host when guest owns the PMU HW resource.
> 
> In current solution, VM would fail to create if there is any system-wide 
> event without exclude_guest attribute. If VM is created successfully and 
> when vm-entry happens, the helper perf_guest_enter() would put all host 
> events with exclude_guest attribute into PERF_EVENT_STATE_INACTIVE state 
> and block host to create system-wide events without exclude_guest 
> attribute.
I do not know perf subsytem, Can the perf event state kept unchanged? 
After VM enters, hw perf counter is allocated to VM.  HW counter 
function for host should be stopped already. It seems that host perf 
core needs not perceive VM enter/exit.


