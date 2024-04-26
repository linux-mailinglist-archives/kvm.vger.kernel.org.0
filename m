Return-Path: <kvm+bounces-16009-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DF5438B2E6A
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 03:47:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 923E51F22759
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 01:47:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E305C1879;
	Fri, 26 Apr 2024 01:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WIk04bDM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1388717CD;
	Fri, 26 Apr 2024 01:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714096010; cv=none; b=UgUud2jg6c8BRZy9XbP/fvvyGHd/Q7T9FDbLn9LGEG9bv0ZpqyeDnh5/wqjRmQgRK0cIwJx9JZclRfiMcq7dzAA/8/Ttbs5FJzFeERAIO15v3HXKd3zSMUzcCyVp9fUYfczvu23fU+HW3WjCFkShPMQijAhoH58t+y6HenaSmPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714096010; c=relaxed/simple;
	bh=pvsz6Y7tz8tUTnzdHVdbRBcFs4F7XLbUl6m/bU8Y3GU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BN9XyYnyByENqsaf9BOJiw0NI4zjYUD7v8R0tcjvw7Ur/frpyvfwEcXnOAu0N9p/VGYGK9cwG4P3g49eUx/lelWG65RRM7pCVL1XIuXWF2mEeluF+yOvl6APGVOd75QbqxDqsb01+HP8o/vQW0NaFh/UOd84SA0Dbkbxz9RUM/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WIk04bDM; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714096008; x=1745632008;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=pvsz6Y7tz8tUTnzdHVdbRBcFs4F7XLbUl6m/bU8Y3GU=;
  b=WIk04bDMU2KLWokv1TvtOp7Bdd6eMrzSi+R4AZPo+HgSaFVi4UKfdl/g
   bNiongcuzE2WKlLUQcqBY8NYKyKqo4IbgBczUftez5QzqvDsdXMZB6ylp
   V5b9EevlDccUP+BZ9LiPulrEnuAmezLpIz70rQ6Rhzl/oO5WQLYO1h867
   fJeFYsktxCKd864TidC1LA83f9gpgFjbYczvz+9VzOqZASfWidhVbmo+X
   9ZtZ1Xq3alyjIjfnABJ+MmQ8xNniecXZkf77/Uixg4qSp1KYi1Y5lipUV
   qXTzhCAU3334zNHzdJI4lSi4NY5foIt9B3vxBiR1Pfd8+8SK8ANu9W0aB
   Q==;
X-CSE-ConnectionGUID: N/KCDj1xTp25FovZXk7itw==
X-CSE-MsgGUID: 9k4AQKcdT/2rcBJajNbIfw==
X-IronPort-AV: E=McAfee;i="6600,9927,11055"; a="21239943"
X-IronPort-AV: E=Sophos;i="6.07,231,1708416000"; 
   d="scan'208";a="21239943"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2024 18:46:47 -0700
X-CSE-ConnectionGUID: ovHcXCKTQdu5MWqIjgnzsg==
X-CSE-MsgGUID: uCATs3BCQFubIHsdmVPbjw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,231,1708416000"; 
   d="scan'208";a="56209325"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.245.127]) ([10.124.245.127])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2024 18:46:43 -0700
Message-ID: <77913327-2115-42b5-850a-04ef0581faa7@linux.intel.com>
Date: Fri, 26 Apr 2024 09:46:40 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 23/41] KVM: x86/pmu: Implement the save/restore of PMU
 state for Intel CPU
To: Sean Christopherson <seanjc@google.com>,
 Kan Liang <kan.liang@linux.intel.com>
Cc: Mingwei Zhang <mizhang@google.com>, maobibo <maobibo@loongson.cn>,
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
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <ZirPGnSDUzD-iWwc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 4/26/2024 5:46 AM, Sean Christopherson wrote:
> On Thu, Apr 25, 2024, Kan Liang wrote:
>> On 2024-04-25 4:16 p.m., Mingwei Zhang wrote:
>>> On Thu, Apr 25, 2024 at 9:13 AM Liang, Kan <kan.liang@linux.intel.com> wrote:
>>>> It should not happen. For the current implementation, perf rejects all
>>>> the !exclude_guest system-wide event creation if a guest with the vPMU
>>>> is running.
>>>> However, it's possible to create an exclude_guest system-wide event at
>>>> any time. KVM cannot use the information from the VM-entry to decide if
>>>> there will be active perf events in the VM-exit.
>>> Hmm, why not? If there is any exclude_guest system-wide event,
>>> perf_guest_enter() can return something to tell KVM "hey, some active
>>> host events are swapped out. they are originally in counter #2 and
>>> #3". If so, at the time when perf_guest_enter() returns, KVM will ack
>>> that and keep it in its pmu data structure.
>> I think it's possible that someone creates !exclude_guest event after
> I assume you mean an exclude_guest=1 event?  Because perf should be in a state
> where it rejects exclude_guest=0 events.

Suppose should be exclude_guest=1 event, the perf event without 
exclude_guest attribute would be blocked to create in the v2 patches 
which we are working on.


>
>> the perf_guest_enter(). The stale information is saved in the KVM. Perf
>> will schedule the event in the next perf_guest_exit(). KVM will not know it.
> Ya, the creation of an event on a CPU that currently has guest PMU state loaded
> is what I had in mind when I suggested a callback in my sketch:
>
>   :  D. Add a perf callback that is invoked from IRQ context when perf wants to
>   :     configure a new PMU-based events, *before* actually programming the MSRs,
>   :     and have KVM's callback put the guest PMU state


when host creates a perf event with exclude_guest attribute which is 
used to profile KVM/VMM user space, the vCPU process could work at three 
places.

1. in guest state (non-root mode)

2. inside vcpu-loop

3. outside vcpu-loop

Since the PMU state has already been switched to host state, we don't 
need to consider the case 3 and only care about cases 1 and 2.

when host creates a perf event with exclude_guest attribute to profile 
KVM/VMM user space,  an IPI is triggered to enable the perf event 
eventually like the following code shows.

event_function_call(event, __perf_event_enable, NULL);

For case 1,  a vm-exit is triggered and KVM starts to process the 
vm-exit and then run IPI irq handler, exactly speaking 
__perf_event_enable() to enable the perf event.

For case 2, the IPI irq handler would preempt the vcpu-loop and call 
__perf_event_enable() to enable the perf event.

So IMO KVM just needs to provide a callback to switch guest/host PMU 
state, and __perf_event_enable() calls this callback before really 
touching PMU MSRs.

>
> It's a similar idea to TIF_NEED_FPU_LOAD, just that instead of a common chunk of
> kernel code swapping out the guest state (kernel_fpu_begin()), it's a callback
> into KVM.

