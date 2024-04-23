Return-Path: <kvm+bounces-15644-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BB59F8AE5B5
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 14:12:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 73BD9282BE6
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 12:12:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3685D85C77;
	Tue, 23 Apr 2024 12:12:24 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E740D82865;
	Tue, 23 Apr 2024 12:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713874343; cv=none; b=EFIUwVnEERQY2uYAKCBMsSZkd3Y5MfZ6xu36eVzRzEectfCXqBfc+MMTcVL867TxM41q5hgyVSmLfXIa/T66+WraBclUfhgOWeBlbGttsmc6u4qfJb1Nhx9uk2RQBiOOs/gLm54StXVHv85bQ/48q/G4IlVIepjfOkVD/VWhtVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713874343; c=relaxed/simple;
	bh=fDaZLskB3L9JUVU2fGuLas5jK1PDPhmJkCOPz4/+Xrc=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=eH9bhpB7Usy1riftTpQEr5qNfShkyL0EyTrouL5dWgvwrxZz83FLNQUZkpXhNf+9EB70ReCyez3VILxrliI9QSf2NBTv8t092DP4qLiI51BVT9J3GoMkpycw321sT6TtwgWFuzuVTgC90tOhtl0PgIHf5ARIPavV2BQhp/o+Q5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.173])
	by gateway (Coremail) with SMTP id _____8BxnuuhpSdmd1wBAA--.6689S3;
	Tue, 23 Apr 2024 20:12:17 +0800 (CST)
Received: from [10.20.42.173] (unknown [10.20.42.173])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8Cxyt2epSdmOFQCAA--.9706S3;
	Tue, 23 Apr 2024 20:12:16 +0800 (CST)
Subject: Re: [RFC PATCH 23/41] KVM: x86/pmu: Implement the save/restore of PMU
 state for Intel CPU
To: Mingwei Zhang <mizhang@google.com>
Cc: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>,
 Sean Christopherson <seanjc@google.com>,
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
 <d980dd10-e4c4-4774-b107-77b320cec9f9@linux.intel.com>
 <b5e97aa1-7683-4eff-e1e3-58ac98a8d719@loongson.cn>
 <1ec7a21c-71d0-4f3e-9fa3-3de8ca0f7315@linux.intel.com>
 <5279eabc-ca46-ee1b-b80d-9a511ba90a36@loongson.cn>
 <CAL715WJK893gQd1m9CCAjz5OkxsRc5C4ZR7yJWJXbaGvCeZxQA@mail.gmail.com>
From: maobibo <maobibo@loongson.cn>
Message-ID: <b3868bf5-4e16-3435-c807-f484821fccc6@loongson.cn>
Date: Tue, 23 Apr 2024 20:12:14 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAL715WJK893gQd1m9CCAjz5OkxsRc5C4ZR7yJWJXbaGvCeZxQA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8Cxyt2epSdmOFQCAA--.9706S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoW3Ww1UCF4xKw4DXrWfKrWxGrX_yoWfAF1UpF
	W7Aa1jkr4DJr1jyw1Utw18JFy5trW7Jr1UXrn8JryUA3s09r1rJr1UtrW5CF1Uur1xGr1j
	qr4Ut347Zw1UA3gCm3ZEXasCq-sJn29KB7ZKAUJUUUU7529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUPab4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
	xVWxJr0_GcWln4kS14v26r1Y6r17M2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12
	xvs2x26I8E6xACxx1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r12
	6r1DMcIj6I8E87Iv67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr4
	1lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxG
	rwCFx2IqxVCFs4IE7xkEbVWUJVW8JwCFI7km07C267AKxVWUXVWUAwC20s026c02F40E14
	v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_GFv_WrylIxkG
	c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r4j6F4U
	MIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr1j6F4UJbIYCTnIWIevJa73UjIFyTuYvjxU4qg4DU
	UUU



On 2024/4/23 下午12:23, Mingwei Zhang wrote:
> On Mon, Apr 22, 2024 at 8:55 PM maobibo <maobibo@loongson.cn> wrote:
>>
>>
>>
>> On 2024/4/23 上午11:13, Mi, Dapeng wrote:
>>>
>>> On 4/23/2024 10:53 AM, maobibo wrote:
>>>>
>>>>
>>>> On 2024/4/23 上午10:44, Mi, Dapeng wrote:
>>>>>
>>>>> On 4/23/2024 9:01 AM, maobibo wrote:
>>>>>>
>>>>>>
>>>>>> On 2024/4/23 上午1:01, Sean Christopherson wrote:
>>>>>>> On Mon, Apr 22, 2024, maobibo wrote:
>>>>>>>> On 2024/4/16 上午6:45, Sean Christopherson wrote:
>>>>>>>>> On Mon, Apr 15, 2024, Mingwei Zhang wrote:
>>>>>>>>>> On Mon, Apr 15, 2024 at 10:38 AM Sean Christopherson
>>>>>>>>>> <seanjc@google.com> wrote:
>>>>>>>>>>> One my biggest complaints with the current vPMU code is that
>>>>>>>>>>> the roles and
>>>>>>>>>>> responsibilities between KVM and perf are poorly defined, which
>>>>>>>>>>> leads to suboptimal
>>>>>>>>>>> and hard to maintain code.
>>>>>>>>>>>
>>>>>>>>>>> Case in point, I'm pretty sure leaving guest values in PMCs
>>>>>>>>>>> _would_ leak guest
>>>>>>>>>>> state to userspace processes that have RDPMC permissions, as
>>>>>>>>>>> the PMCs might not
>>>>>>>>>>> be dirty from perf's perspective (see
>>>>>>>>>>> perf_clear_dirty_counters()).
>>>>>>>>>>>
>>>>>>>>>>> Blindly clearing PMCs in KVM "solves" that problem, but in
>>>>>>>>>>> doing so makes the
>>>>>>>>>>> overall code brittle because it's not clear whether KVM _needs_
>>>>>>>>>>> to clear PMCs,
>>>>>>>>>>> or if KVM is just being paranoid.
>>>>>>>>>>
>>>>>>>>>> So once this rolls out, perf and vPMU are clients directly to
>>>>>>>>>> PMU HW.
>>>>>>>>>
>>>>>>>>> I don't think this is a statement we want to make, as it opens a
>>>>>>>>> discussion
>>>>>>>>> that we won't win.  Nor do I think it's one we *need* to make.
>>>>>>>>> KVM doesn't need
>>>>>>>>> to be on equal footing with perf in terms of owning/managing PMU
>>>>>>>>> hardware, KVM
>>>>>>>>> just needs a few APIs to allow faithfully and accurately
>>>>>>>>> virtualizing a guest PMU.
>>>>>>>>>
>>>>>>>>>> Faithful cleaning (blind cleaning) has to be the baseline
>>>>>>>>>> implementation, until both clients agree to a "deal" between them.
>>>>>>>>>> Currently, there is no such deal, but I believe we could have
>>>>>>>>>> one via
>>>>>>>>>> future discussion.
>>>>>>>>>
>>>>>>>>> What I am saying is that there needs to be a "deal" in place
>>>>>>>>> before this code
>>>>>>>>> is merged.  It doesn't need to be anything fancy, e.g. perf can
>>>>>>>>> still pave over
>>>>>>>>> PMCs it doesn't immediately load, as opposed to using
>>>>>>>>> cpu_hw_events.dirty to lazily
>>>>>>>>> do the clearing.  But perf and KVM need to work together from the
>>>>>>>>> get go, ie. I
>>>>>>>>> don't want KVM doing something without regard to what perf does,
>>>>>>>>> and vice versa.
>>>>>>>>>
>>>>>>>> There is similar issue on LoongArch vPMU where vm can directly pmu
>>>>>>>> hardware
>>>>>>>> and pmu hw is shard with guest and host. Besides context switch
>>>>>>>> there are
>>>>>>>> other places where perf core will access pmu hw, such as tick
>>>>>>>> timer/hrtimer/ipi function call, and KVM can only intercept
>>>>>>>> context switch.
>>>>>>>
>>>>>>> Two questions:
>>>>>>>
>>>>>>>    1) Can KVM prevent the guest from accessing the PMU?
>>>>>>>
>>>>>>>    2) If so, KVM can grant partial access to the PMU, or is it all
>>>>>>> or nothing?
>>>>>>>
>>>>>>> If the answer to both questions is "yes", then it sounds like
>>>>>>> LoongArch *requires*
>>>>>>> mediated/passthrough support in order to virtualize its PMU.
>>>>>>
>>>>>> Hi Sean,
>>>>>>
>>>>>> Thank for your quick response.
>>>>>>
>>>>>> yes, kvm can prevent guest from accessing the PMU and grant partial
>>>>>> or all to access to the PMU. Only that if one pmu event is granted
>>>>>> to VM, host can not access this pmu event again. There must be pmu
>>>>>> event switch if host want to.
>>>>>
>>>>> PMU event is a software entity which won't be shared. did you mean if
>>>>> a PMU HW counter is granted to VM, then Host can't access the PMU HW
>>>>> counter, right?
>>>> yes, if PMU HW counter/control is granted to VM. The value comes from
>>>> guest, and is not meaningful for host.  Host pmu core does not know
>>>> that it is granted to VM, host still think that it owns pmu.
>>>
>>> That's one issue this patchset tries to solve. Current new mediated x86
>>> vPMU framework doesn't allow Host or Guest own the PMU HW resource
>>> simultaneously. Only when there is no !exclude_guest event on host,
>>> guest is allowed to exclusively own the PMU HW resource.
>>>
>>>
>>>>
>>>> Just like FPU register, it is shared by VM and host during different
>>>> time and it is lately switched. But if IPI or timer interrupt uses FPU
>>>> register on host, there will be the same issue.
>>>
>>> I didn't fully get your point. When IPI or timer interrupt reach, a
>>> VM-exit is triggered to make CPU traps into host first and then the host
>> yes, it is.
> 
> This is correct. And this is one of the points that we had debated
> internally whether we should do PMU context switch at vcpu loop
> boundary or VM Enter/exit boundary. (host-level) timer interrupt can
> force VM Exit, which I think happens every 4ms or 1ms, depending on
> configuration.
> 
> One of the key reasons we currently propose this is because it is the
> same boundary as the legacy PMU, i.e., it would be simple to propose
> from the perf subsystem perspective.
> 
> Performance wise, doing PMU context switch at vcpu boundary would be
> way better in general. But the downside is that perf sub-system lose
> the capability to profile majority of the KVM code (functions) when
> guest PMU is enabled.
> 
>>
>>> interrupt handler is called. Or are you complaining the executing
>>> sequence of switching guest PMU MSRs and these interrupt handler?
>> In our vPMU implementation, it is ok if vPMU is switched in vm exit
>> path, however there is problem if vPMU is switched during vcpu thread
>> sched-out/sched-in path since IPI/timer irq interrupt access pmu
>> register in host mode.
> 
> Oh, the IPI/timer irq handler will access PMU registers? I thought
> only the host-level NMI handler will access the PMU MSRs since PMI is
> registered under NMI.
> 
> In that case, you should disable  IRQ during vcpu context switch. For
> NMI, we prevent its handler from accessing the PMU registers. In
> particular, we use a per-cpu variable to guard that. So, the
> host-level PMI handler for perf sub-system will check the variable
> before proceeding.
> 
>>
>> In general it will be better if the switch is done in vcpu thread
>> sched-out/sched-in, else there is requirement to profile kvm
>> hypervisor.Even there is such requirement, it is only one option. In
>> most conditions, it will better if time of VM context exit is small.
>>
> Performance wise, agree, but there will be debate on perf
> functionality loss at the host level.
> 
> Maybe, (just maybe), it is possible to do PMU context switch at vcpu
> boundary normally, but doing it at VM Enter/Exit boundary when host is
> profiling KVM kernel module. So, dynamically adjusting PMU context
> switch location could be an option.
If there are two VMs with pmu enabled both, however host PMU is not 
enabled. PMU context switch should be done in vcpu thread sched-out path.

If host pmu is used also, we can choose whether PMU switch should be 
done in vm exit path or vcpu thread sched-out path.

> 
>>>
>>>
>>>>
>>>> Regards
>>>> Bibo Mao
>>>>>
>>>>>
>>>>>>
>>>>>>>
>>>>>>>> Can we add callback handler in structure kvm_guest_cbs?  just like
>>>>>>>> this:
>>>>>>>> @@ -6403,6 +6403,7 @@ static struct perf_guest_info_callbacks
>>>>>>>> kvm_guest_cbs
>>>>>>>> = {
>>>>>>>>           .state                  = kvm_guest_state,
>>>>>>>>           .get_ip                 = kvm_guest_get_ip,
>>>>>>>>           .handle_intel_pt_intr   = NULL,
>>>>>>>> +       .lose_pmu               = kvm_guest_lose_pmu,
>>>>>>>>    };
>>>>>>>>
>>>>>>>> By the way, I do not know should the callback handler be triggered
>>>>>>>> in perf
>>>>>>>> core or detailed pmu hw driver. From ARM pmu hw driver, it is
>>>>>>>> triggered in
>>>>>>>> pmu hw driver such as function kvm_vcpu_pmu_resync_el0,
>>>>>>>> but I think it will be better if it is done in perf core.
>>>>>>>
>>>>>>> I don't think we want to take the approach of perf and KVM guests
>>>>>>> "fighting" over
>>>>>>> the PMU.  That's effectively what we have today, and it's a mess
>>>>>>> for KVM because
>>>>>>> it's impossible to provide consistent, deterministic behavior for
>>>>>>> the guest.  And
>>>>>>> it's just as messy for perf, which ends up having wierd, cumbersome
>>>>>>> flows that
>>>>>>> exists purely to try to play nice with KVM.
>>>>>> With existing pmu core code, in tick timer interrupt or IPI function
>>>>>> call interrupt pmu hw may be accessed by host when VM is running and
>>>>>> pmu is already granted to guest. KVM can not intercept host
>>>>>> IPI/timer interrupt, there is no pmu context switch, there will be
>>>>>> problem.
>>>>>>
>>>>>> Regards
>>>>>> Bibo Mao
>>>>>>
>>>>
>>


