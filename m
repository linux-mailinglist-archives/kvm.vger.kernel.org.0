Return-Path: <kvm+bounces-15179-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EB77F8AA667
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 03:02:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1D62B1C20E9F
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 01:02:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7F96110A;
	Fri, 19 Apr 2024 01:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AbFKx6Xo"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECECD65C;
	Fri, 19 Apr 2024 01:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713488567; cv=none; b=b/iFpJn1mtUGMnBaZqnuWYvKErljOlUxmu+3zpwifFvI8YhG9eBE6dIU7QZgZF9Wa3kOvO/3RBFi8qBRNSQIF8ut+0Avbs0r6hZRPSAY1yQiKMoqfMth6x3luDb5+FkQop/hlR/WmaSMcCkJmCyOD8CoKrotR83DHaiGyDwPb9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713488567; c=relaxed/simple;
	bh=aqDmFCv9VB0RMFUJFXbc+HwuGl8Pjhp8r57WddbrwdE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AoLDqbreBG7gXW63Ir9F7JNGemOy/orgWE3NtQfFk9iX59Rd8FvY/9pWC3LybyNqSfvFQaCbQTV1XHc/tKg5wef7nuHnf81sjXoz2oEfCkMCmeZcnFlUg52kr8fCVFVOq/AvrUwp6pHFZ/pt0tLcMIkiT1KZ6hvDMm2brZb6pWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AbFKx6Xo; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713488566; x=1745024566;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=aqDmFCv9VB0RMFUJFXbc+HwuGl8Pjhp8r57WddbrwdE=;
  b=AbFKx6Xowv2FehVcJcB2lFZ7JartKLvxn4iERa1kAabPOGNke7PfRWsa
   b4CLuRRZQS1Zx9FT7ANP8dJgfp+4aqjixWDAG3YTsmDyvpwn49If6QWqU
   Ek+teG6xvMDzqp1eRebDFtwtpZWGP/1zdKpTC31yoy82QKdo9Wbe9INLn
   8Fn/Ei7re5rNF0W153u+QW2CnIQ2Ss4ykTwq8EkQIixRUqV3Df06y6m7u
   k7ShsVDOx4Egai1aXyaz298G/sjkgTfZ/+eitfM+UQ4jtVpi20Fbdfjx6
   bKMPZALd9+3yqHJZdoUTGSDfDQgyEVh3wsL7E7tzglO35DWEB9kgyVuPR
   w==;
X-CSE-ConnectionGUID: 5ST7AJ58TqGLtDAkn2GkTw==
X-CSE-MsgGUID: vajuflyaQtq2lX+uCiyfzw==
X-IronPort-AV: E=McAfee;i="6600,9927,11047"; a="12016724"
X-IronPort-AV: E=Sophos;i="6.07,213,1708416000"; 
   d="scan'208";a="12016724"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2024 18:02:45 -0700
X-CSE-ConnectionGUID: +aHBtE5WRkGi2CB1vWzMAA==
X-CSE-MsgGUID: Ip2kdL9oShO+adwp40ko/A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,213,1708416000"; 
   d="scan'208";a="27943753"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.245.127]) ([10.124.245.127])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2024 18:02:40 -0700
Message-ID: <de34d944-4d39-4525-9e1e-8ad47a8a4d6e@linux.intel.com>
Date: Fri, 19 Apr 2024 09:02:38 +0800
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
Cc: Xiong Zhang <xiong.y.zhang@linux.intel.com>, pbonzini@redhat.com,
 peterz@infradead.org, kan.liang@intel.com, zhenyuw@linux.intel.com,
 jmattson@google.com, kvm@vger.kernel.org, linux-perf-users@vger.kernel.org,
 linux-kernel@vger.kernel.org, zhiyuan.lv@intel.com, eranian@google.com,
 irogers@google.com, samantha.alt@intel.com, like.xu.linux@gmail.com,
 chao.gao@intel.com
References: <20240126085444.324918-1-xiong.y.zhang@linux.intel.com>
 <20240126085444.324918-24-xiong.y.zhang@linux.intel.com>
 <ZhhZush_VOEnimuw@google.com>
 <18b19dd4-6d76-4ed8-b784-32436ab93d06@linux.intel.com>
 <Zhn9TGOiXxcV5Epx@google.com>
 <4c47b975-ad30-4be9-a0a9-f0989d1fa395@linux.intel.com>
 <CAL715WJXWQgfzgh8KqL+pAzeqL+dkF6imfRM37nQ6PkZd09mhQ@mail.gmail.com>
 <737f0c66-2237-4ed3-8999-19fe9cca9ecc@linux.intel.com>
 <CAL715W+RKCLsByfM3-0uKBWdbYgyk_hou9oC+mC9H61yR_9tyw@mail.gmail.com>
 <Zh1mKoHJcj22rKy8@google.com> <ZiGOzkLhQm57EPlx@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <ZiGOzkLhQm57EPlx@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 4/19/2024 5:21 AM, Mingwei Zhang wrote:
> On Mon, Apr 15, 2024, Sean Christopherson wrote:
>> On Mon, Apr 15, 2024, Mingwei Zhang wrote:
>>> On Mon, Apr 15, 2024 at 3:04 AM Mi, Dapeng <dapeng1.mi@linux.intel.com> wrote:
>>>> On 4/15/2024 2:06 PM, Mingwei Zhang wrote:
>>>>> On Fri, Apr 12, 2024 at 9:25 PM Mi, Dapeng <dapeng1.mi@linux.intel.com> wrote:
>>>>>>>> It's necessary to clear the EVENTSELx MSRs for both GP and fixed counters.
>>>>>>>> Considering this case, Guest uses GP counter 2, but Host doesn't use it. So
>>>>>>>> if the EVENTSEL2 MSR is not cleared here, the GP counter 2 would be enabled
>>>>>>>> unexpectedly on host later since Host perf always enable all validate bits
>>>>>>>> in PERF_GLOBAL_CTRL MSR. That would cause issues.
>>>>>>>>
>>>>>>>> Yeah,  the clearing for PMCx MSR should be unnecessary .
>>>>>>>>
>>>>>>> Why is clearing for PMCx MSR unnecessary? Do we want to leaking counter
>>>>>>> values to the host? NO. Not in cloud usage.
>>>>>> No, this place is clearing the guest counter value instead of host
>>>>>> counter value. Host always has method to see guest value in a normal VM
>>>>>> if he want. I don't see its necessity, it's just a overkill and
>>>>>> introduce extra overhead to write MSRs.
>>>>>>
>>>>> I am curious how the perf subsystem solves the problem? Does perf
>>>>> subsystem in the host only scrubbing the selector but not the counter
>>>>> value when doing the context switch?
>>>> When context switch happens, perf code would schedule out the old events
>>>> and schedule in the new events. When scheduling out, the ENABLE bit of
>>>> EVENTSELx MSR would be cleared, and when scheduling in, the EVENTSELx
>>>> and PMCx MSRs would be overwritten with new event's attr.config and
>>>> sample_period separately.  Of course, these is only for the case when
>>>> there are new events to be programmed on the PMC. If no new events, the
>>>> PMCx MSR would keep stall value and won't be cleared.
>>>>
>>>> Anyway, I don't see any reason that PMCx MSR must be cleared.
>>>>
>>> I don't have a strong opinion on the upstream version. But since both
>>> the mediated vPMU and perf are clients of PMU HW, leaving PMC values
>>> uncleared when transition out of the vPMU boundary is leaking info
>>> technically.
>> I'm not objecting to ensuring guest PMCs can't be read by any entity that's not
>> in the guest's TCB, which is what I would consider a true leak.  I'm objecting
>> to blindly clearing all PMCs, and more specifically objecting to *KVM* clearing
>> PMCs when saving guest state without coordinating with perf in any way.
> Agree. blindly clearing PMCs is the basic implementation. I am thinking
> about what coordination between perf and KVM as well.
>
>> I am ok if we start with (or default to) a "safe" implementation that zeroes all
>> PMCs when switching to host context, but I want KVM and perf to work together to
>> do the context switches, e.g. so that we don't end up with code where KVM writes
>> to all PMC MSRs and that perf also immediately writes to all PMC MSRs.
> Sure. Point taken.
>> One my biggest complaints with the current vPMU code is that the roles and
>> responsibilities between KVM and perf are poorly defined, which leads to suboptimal
>> and hard to maintain code.
> Right.
>> Case in point, I'm pretty sure leaving guest values in PMCs _would_ leak guest
>> state to userspace processes that have RDPMC permissions, as the PMCs might not
>> be dirty from perf's perspective (see perf_clear_dirty_counters()).
>>
> ah. This is a good point.
>
> 		switch_mm_irqs_off() =>
> 		cr4_update_pce_mm() =>
> 		/*
> 		 * Clear the existing dirty counters to
> 		 * prevent the leak for an RDPMC task.
> 		 */
> 		perf_clear_dirty_counters()
>
> So perf does clear dirty counter values on process context switch. This
> is nice to know.
>
> perf_clear_dirty_counters() clear the counter values according to
> cpuc->dirty except for those assigned counters.
>
>> Blindly clearing PMCs in KVM "solves" that problem, but in doing so makes the
>> overall code brittle because it's not clear whether KVM _needs_ to clear PMCs,
>> or if KVM is just being paranoid.
> There is a difference between KVM and perf subsystem on PMU context
> switch. The latter has the notion of "perf_events", while the former
> currently does not. It is quite hard for KVM to know which counters are
> really "in use".
>
> Another point I want to raise up to you is that, KVM PMU context switch
> and Perf PMU context switch happens at different timing:
>
>   - The former is a context switch between guest/host state of the same
>     process, happening at VM-enter/exit boundary.
>   - The latter is a context switch beteen two host-level processes.
>   - The former happens before the latter.
>   - Current design has no PMC partitioning between host/guest due to
>     arch limitation.
>
>  From the above, I feel that it might be impossible to combine them or to
> add coordination? Unless we do the KVM PMU context switch at vcpu loop
> boundary...

It seems there are two ways to clear the PMCx MSRs.

a) KVM clears these guest only used counters' PMCx MSRs when VM exits 
and saving the guest MSRs. This can be seen as a portion of the next 
step optimization that only guest used MSRs are saved and restored. It 
would avoid to save/restore unnecessary MSR and decrease the performance 
impact.

b) Perf subsystem clears these guest used MSRs, but perf system doesn't 
know which MSRs are touched by guest, KVM has to provide a API to tell 
perf subsystem the information. Another issue is that perf does the 
clearing in task context switch. It may be too late, user can get the 
guest counter value via rdpmc instruction as long as the vCPU process is 
allowed to use rdpmc from user space.

We had an internal rough talk on this, It seems the option 1 is the 
better one which looks simpler and has clearer boundary. We would 
implement it together with the optimization mentioned in option 1.


>
> Thanks.
> -Mingwei
>

