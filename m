Return-Path: <kvm+bounces-16054-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9343C8B3981
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 16:10:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B5DD81C21EDA
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 14:10:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D61C1487F8;
	Fri, 26 Apr 2024 14:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mVvtQU/m"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE28B1465A1;
	Fri, 26 Apr 2024 14:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714140598; cv=none; b=LX/Gj8arHHsryGYWs8cfTVE1/BPCxVoxEiOUalqcF/mEQxmvJIgGoCc5W8mgGuh2ZCU4x9RJncqbzt6g+INBYHG6vmuL8aljQdyfjU0ni85gjKNtGbwmqBQPRvdknRhE2wsZ5YeORxJiYYG3yStqgeQEm5nkLqlh4BjVJNW7A/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714140598; c=relaxed/simple;
	bh=q++yybLMckKLiXK6TTH8gaSYPe98nTrzO/fuv8VXCPM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EioW7paoFJQ8AR3LDomEfFoCTq7JFlGzvdJUQc8QFPiLMZwtZ+JBXTcbM514MAx3DnhH0weKvFKtj6lR1em+1n6MH9UWEXfixinephyrbZbqxa47nZ509hTp0Yj8wc9Tze/PzRIvaQMRkmkbsaLQBOq9yBPfeJeAHVmy4bS4bdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mVvtQU/m; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714140597; x=1745676597;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=q++yybLMckKLiXK6TTH8gaSYPe98nTrzO/fuv8VXCPM=;
  b=mVvtQU/mXuJhvsK9W1eT5qfhI6CO1QMTtMGNnhyWArxjh+In96lryitC
   xUAPKePSjod9g+kfzHM9eqH6Ehrcg0L+EgQRuU5yWL5IkDUGppfaxN6yg
   Ca61e9yp3JTEAT03eqUKgROaR5sdBBdW4uB0J05Ha/UnK7qg2Dn8Rgw/K
   igsInT7BTeL9D1a5fepdzrIBpzoUXyUWYnR7SvkJ7ryY/MAZ++ZO2ZpDk
   EzLtHuSUwOce8J/AN32Twu8hL7z7Ihweib4YtTU0iT+orlbKkYc7Dc6FU
   vVlYMNzSQVnQmxSCDsjNHXAjaG2+baySZSCa2OcX19Ic/jMll5TfJsIt7
   g==;
X-CSE-ConnectionGUID: Y8STL22nSoig5MytvzUK+g==
X-CSE-MsgGUID: k0H0Y4C1Q8a355cKfJJSlQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11056"; a="21282381"
X-IronPort-AV: E=Sophos;i="6.07,232,1708416000"; 
   d="scan'208";a="21282381"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2024 07:09:56 -0700
X-CSE-ConnectionGUID: RGO9JhZIT1y4czepxixcvQ==
X-CSE-MsgGUID: VGNph+ncSXCpNsNkns787w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,232,1708416000"; 
   d="scan'208";a="62908642"
Received: from linux.intel.com ([10.54.29.200])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2024 07:09:56 -0700
Received: from [10.212.113.23] (kliang2-mobl1.ccr.corp.intel.com [10.212.113.23])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by linux.intel.com (Postfix) with ESMTPS id B65FB20B5739;
	Fri, 26 Apr 2024 07:09:53 -0700 (PDT)
Message-ID: <ff4a4229-04ac-4cbf-8aea-c84ccfa96e0b@linux.intel.com>
Date: Fri, 26 Apr 2024 10:09:52 -0400
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
 "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
Cc: Sean Christopherson <seanjc@google.com>, maobibo <maobibo@loongson.cn>,
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
From: "Liang, Kan" <kan.liang@linux.intel.com>
In-Reply-To: <CAL715WJCHJD_wcJ+r4TyWfvmk9uNT_kPy7Pt=CHkB-Sf0D4Rqw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2024-04-25 11:12 p.m., Mingwei Zhang wrote:
>>>> the perf_guest_enter(). The stale information is saved in the KVM. Perf
>>>> will schedule the event in the next perf_guest_exit(). KVM will not know it.
>>> Ya, the creation of an event on a CPU that currently has guest PMU state loaded
>>> is what I had in mind when I suggested a callback in my sketch:
>>>
>>>   :  D. Add a perf callback that is invoked from IRQ context when perf wants to
>>>   :     configure a new PMU-based events, *before* actually programming the MSRs,
>>>   :     and have KVM's callback put the guest PMU state
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
> structure. 

KVM doesn't need to save/restore the host state. Host perf has the
information and will reload the values whenever the host events are
rescheduled. But I think KVM should clear the registers used by the host
to prevent the value leaks to the guest.

> If none, do the context switch early (so that KVM saves a
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

I'm not quit sure about the 4.
The new host-level perf must be an exclude_guest event. It should not be
scheduled when a guest is using the PMU. Why do we want to preempt the
guest PMU? The current implementation in perf doesn't schedule any
exclude_guest events when a guest is running.

Thanks,
Kan

