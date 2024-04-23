Return-Path: <kvm+bounces-15599-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 68AE68ADC8A
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 05:59:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2080E282AFA
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 03:59:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D9B11CD39;
	Tue, 23 Apr 2024 03:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mGWgn1jx"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D75E1B299;
	Tue, 23 Apr 2024 03:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713844782; cv=none; b=FOVqD24boxdTRZfXLC8fS0GBQGHgpGBLiMV7XES7TWRWoozADAJ0tLelSn49BipWh+o4auwMI7ZXWsbQC8/zF2V8ZgBPDtBulj2cqViA1SPx8YXNqt9hcEVGN67ADhlq9y4zGqnTLJj455UiSNW5zBuWlYsKZ9OnX7yxseJL8Fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713844782; c=relaxed/simple;
	bh=EylEGaKnMTMaaTxDN1CcDh9DFrvV30vwuPOwRNJ0jvI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=P7o6l14F7KCCYz5K5w8mw9r9q2iP0pt4zLExiIfkYNomjFsXYg3xYtQkkbvIiwBDeT9FmGvS1lGbFKc/6It78+WWrNWBNlhQrcjoanrvhSu9qK4Upd7QCT78FaVskb0ZVM4/LzBSB7t0rYcajdewBzRQcVNCmXVD97u+4GRdq6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mGWgn1jx; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713844780; x=1745380780;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=EylEGaKnMTMaaTxDN1CcDh9DFrvV30vwuPOwRNJ0jvI=;
  b=mGWgn1jxoUQdatXOW9vUSZ+S2mJBwAh1RD+XOlTmlKxRKSqc8LrHQ8lt
   fcA+RIsyxHiJdxq6iAZvLuj5wppaN46GPcTHPPIGYzhk2yOAEDJ7ATt45
   S87gaRGAW2bGZ58D5XT5egFugRTAHePZWORznA9natSLZMeDqoi+eeLx2
   PkCzpGa3YFK7Fnol4bLWthFcYnBgFMSdKW62YuEWLdFj3GClFeGA0AWMY
   rYQNUJsJkvzdCIaTTotESVsQIdZhmagqVNsLdPXpqkRX0PKSFxwf5sM4E
   jBjGrtlyYSavmf3q2f8er+M66ZIjrJCHJeTdJYCW3BHj76aCD+5Z/YLww
   g==;
X-CSE-ConnectionGUID: a1wm5i+nRfi1R//iXHIL5A==
X-CSE-MsgGUID: Vvf/KYn+QwS5j+y+kViEWA==
X-IronPort-AV: E=McAfee;i="6600,9927,11052"; a="13197931"
X-IronPort-AV: E=Sophos;i="6.07,222,1708416000"; 
   d="scan'208";a="13197931"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2024 20:59:39 -0700
X-CSE-ConnectionGUID: gon1MA/oSEmC81U0bNBt7w==
X-CSE-MsgGUID: Ix+nM5NVRbioYqdyymjkjw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,222,1708416000"; 
   d="scan'208";a="55441043"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.245.127]) ([10.124.245.127])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2024 20:59:35 -0700
Message-ID: <13b0b125-ec05-41b9-8ea9-a36597634b54@linux.intel.com>
Date: Tue, 23 Apr 2024 11:59:33 +0800
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
 <d980dd10-e4c4-4774-b107-77b320cec9f9@linux.intel.com>
 <b5e97aa1-7683-4eff-e1e3-58ac98a8d719@loongson.cn>
 <1ec7a21c-71d0-4f3e-9fa3-3de8ca0f7315@linux.intel.com>
 <5f27b793-b19e-d429-190c-1c20a6d1c649@loongson.cn>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <5f27b793-b19e-d429-190c-1c20a6d1c649@loongson.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 4/23/2024 11:26 AM, maobibo wrote:
>
>
> On 2024/4/23 上午11:13, Mi, Dapeng wrote:
>>
>> On 4/23/2024 10:53 AM, maobibo wrote:
>>>
>>>
>>> On 2024/4/23 上午10:44, Mi, Dapeng wrote:
>>>>
>>>> On 4/23/2024 9:01 AM, maobibo wrote:
>>>>>
>>>>>
>>>>> On 2024/4/23 上午1:01, Sean Christopherson wrote:
>>>>>> On Mon, Apr 22, 2024, maobibo wrote:
>>>>>>> On 2024/4/16 上午6:45, Sean Christopherson wrote:
>>>>>>>> On Mon, Apr 15, 2024, Mingwei Zhang wrote:
>>>>>>>>> On Mon, Apr 15, 2024 at 10:38 AM Sean Christopherson 
>>>>>>>>> <seanjc@google.com> wrote:
>>>>>>>>>> One my biggest complaints with the current vPMU code is that 
>>>>>>>>>> the roles and
>>>>>>>>>> responsibilities between KVM and perf are poorly defined, 
>>>>>>>>>> which leads to suboptimal
>>>>>>>>>> and hard to maintain code.
>>>>>>>>>>
>>>>>>>>>> Case in point, I'm pretty sure leaving guest values in PMCs 
>>>>>>>>>> _would_ leak guest
>>>>>>>>>> state to userspace processes that have RDPMC permissions, as 
>>>>>>>>>> the PMCs might not
>>>>>>>>>> be dirty from perf's perspective (see 
>>>>>>>>>> perf_clear_dirty_counters()).
>>>>>>>>>>
>>>>>>>>>> Blindly clearing PMCs in KVM "solves" that problem, but in 
>>>>>>>>>> doing so makes the
>>>>>>>>>> overall code brittle because it's not clear whether KVM 
>>>>>>>>>> _needs_ to clear PMCs,
>>>>>>>>>> or if KVM is just being paranoid.
>>>>>>>>>
>>>>>>>>> So once this rolls out, perf and vPMU are clients directly to 
>>>>>>>>> PMU HW.
>>>>>>>>
>>>>>>>> I don't think this is a statement we want to make, as it opens 
>>>>>>>> a discussion
>>>>>>>> that we won't win.  Nor do I think it's one we *need* to make. 
>>>>>>>> KVM doesn't need
>>>>>>>> to be on equal footing with perf in terms of owning/managing 
>>>>>>>> PMU hardware, KVM
>>>>>>>> just needs a few APIs to allow faithfully and accurately 
>>>>>>>> virtualizing a guest PMU.
>>>>>>>>
>>>>>>>>> Faithful cleaning (blind cleaning) has to be the baseline
>>>>>>>>> implementation, until both clients agree to a "deal" between 
>>>>>>>>> them.
>>>>>>>>> Currently, there is no such deal, but I believe we could have 
>>>>>>>>> one via
>>>>>>>>> future discussion.
>>>>>>>>
>>>>>>>> What I am saying is that there needs to be a "deal" in place 
>>>>>>>> before this code
>>>>>>>> is merged.  It doesn't need to be anything fancy, e.g. perf can 
>>>>>>>> still pave over
>>>>>>>> PMCs it doesn't immediately load, as opposed to using 
>>>>>>>> cpu_hw_events.dirty to lazily
>>>>>>>> do the clearing.  But perf and KVM need to work together from 
>>>>>>>> the get go, ie. I
>>>>>>>> don't want KVM doing something without regard to what perf 
>>>>>>>> does, and vice versa.
>>>>>>>>
>>>>>>> There is similar issue on LoongArch vPMU where vm can directly 
>>>>>>> pmu hardware
>>>>>>> and pmu hw is shard with guest and host. Besides context switch 
>>>>>>> there are
>>>>>>> other places where perf core will access pmu hw, such as tick
>>>>>>> timer/hrtimer/ipi function call, and KVM can only intercept 
>>>>>>> context switch.
>>>>>>
>>>>>> Two questions:
>>>>>>
>>>>>>   1) Can KVM prevent the guest from accessing the PMU?
>>>>>>
>>>>>>   2) If so, KVM can grant partial access to the PMU, or is it all 
>>>>>> or nothing?
>>>>>>
>>>>>> If the answer to both questions is "yes", then it sounds like 
>>>>>> LoongArch *requires*
>>>>>> mediated/passthrough support in order to virtualize its PMU.
>>>>>
>>>>> Hi Sean,
>>>>>
>>>>> Thank for your quick response.
>>>>>
>>>>> yes, kvm can prevent guest from accessing the PMU and grant 
>>>>> partial or all to access to the PMU. Only that if one pmu event is 
>>>>> granted to VM, host can not access this pmu event again. There 
>>>>> must be pmu event switch if host want to.
>>>>
>>>> PMU event is a software entity which won't be shared. did you mean 
>>>> if a PMU HW counter is granted to VM, then Host can't access the 
>>>> PMU HW counter, right?
>>> yes, if PMU HW counter/control is granted to VM. The value comes 
>>> from guest, and is not meaningful for host.  Host pmu core does not 
>>> know that it is granted to VM, host still think that it owns pmu.
>>
>> That's one issue this patchset tries to solve. Current new mediated 
>> x86 vPMU framework doesn't allow Host or Guest own the PMU HW 
>> resource simultaneously. Only when there is no !exclude_guest event 
>> on host, guest is allowed to exclusively own the PMU HW resource.
>>
>>
>>>
>>> Just like FPU register, it is shared by VM and host during different 
>>> time and it is lately switched. But if IPI or timer interrupt uses 
>>> FPU register on host, there will be the same issue.
>>
>> I didn't fully get your point. When IPI or timer interrupt reach, a 
>> VM-exit is triggered to make CPU traps into host first and then the 
>> host interrupt handler is called. Or are you complaining the 
>> executing sequence of switching guest PMU MSRs and these interrupt 
>> handler?
> It is not necessary to save/restore PMU HW at every vm exit, it had 
> better be lately saved/restored, such as only when vcpu thread is 
> sched-out/sched-in, else the cost will be a little expensive.

I suspect this optimization deferring guest PMU state save/restore to 
vCPU task switching boundary would be really landed into KVM since it 
would make host lose the capability to profile KVM and It seems Sean 
object this.


>
> I know little about perf core. However there is PMU HW access in 
> interrupt mode. That means PMU HW access should be irq disabled in 
> general mode, else there may be nested PMU HW access. Is that true?

I had no idea that timer irq handler would access PMU MSRs before. Could 
you please show me the code and I would look at it first. Thanks.


>
>>
>>
>>>
>>> Regards
>>> Bibo Mao
>>>>
>>>>
>>>>>
>>>>>>
>>>>>>> Can we add callback handler in structure kvm_guest_cbs?  just 
>>>>>>> like this:
>>>>>>> @@ -6403,6 +6403,7 @@ static struct perf_guest_info_callbacks 
>>>>>>> kvm_guest_cbs
>>>>>>> = {
>>>>>>>          .state                  = kvm_guest_state,
>>>>>>>          .get_ip                 = kvm_guest_get_ip,
>>>>>>>          .handle_intel_pt_intr   = NULL,
>>>>>>> +       .lose_pmu               = kvm_guest_lose_pmu,
>>>>>>>   };
>>>>>>>
>>>>>>> By the way, I do not know should the callback handler be 
>>>>>>> triggered in perf
>>>>>>> core or detailed pmu hw driver. From ARM pmu hw driver, it is 
>>>>>>> triggered in
>>>>>>> pmu hw driver such as function kvm_vcpu_pmu_resync_el0,
>>>>>>> but I think it will be better if it is done in perf core.
>>>>>>
>>>>>> I don't think we want to take the approach of perf and KVM guests 
>>>>>> "fighting" over
>>>>>> the PMU.  That's effectively what we have today, and it's a mess 
>>>>>> for KVM because
>>>>>> it's impossible to provide consistent, deterministic behavior for 
>>>>>> the guest.  And
>>>>>> it's just as messy for perf, which ends up having wierd, 
>>>>>> cumbersome flows that
>>>>>> exists purely to try to play nice with KVM.
>>>>> With existing pmu core code, in tick timer interrupt or IPI 
>>>>> function call interrupt pmu hw may be accessed by host when VM is 
>>>>> running and pmu is already granted to guest. KVM can not intercept 
>>>>> host IPI/timer interrupt, there is no pmu context switch, there 
>>>>> will be problem.
>>>>>
>>>>> Regards
>>>>> Bibo Mao
>>>>>
>>>
>

