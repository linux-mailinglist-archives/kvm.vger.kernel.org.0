Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6B3A330974
	for <lists+kvm@lfdr.de>; Mon,  8 Mar 2021 09:36:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231571AbhCHIgJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Mar 2021 03:36:09 -0500
Received: from mga07.intel.com ([134.134.136.100]:17843 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231648AbhCHIfe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Mar 2021 03:35:34 -0500
IronPort-SDR: DRXyOyTObGNU4zH0hgF3tiSWqWhcGFS1I3zJAeu4GlVbvxm6fH/N5Me/DcVpYTqCmTOtqg8seG
 GpeCo8/V6+iQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9916"; a="252016808"
X-IronPort-AV: E=Sophos;i="5.81,232,1610438400"; 
   d="scan'208";a="252016808"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2021 00:35:32 -0800
IronPort-SDR: AiZbq5zNnZhAR6cBwLCCKQjqCvNWpQHEVNaESelWayOW19bVURBJsAst7whv4OF55nRmnLWGZm
 junbX8HuQ4ew==
X-IronPort-AV: E=Sophos;i="5.81,232,1610438400"; 
   d="scan'208";a="409215585"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.238.4.93]) ([10.238.4.93])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2021 00:35:15 -0800
Subject: Re: [PATCH] x86/perf: Fix guest_get_msrs static call if there is no
 PMU
To:     Dmitry Vyukov <dvyukov@google.com>, "Xu, Like" <like.xu@intel.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        KVM list <kvm@vger.kernel.org>,
        Thomas Gleixner
         "(x86/pti/timer/core/smp/irq/perf/efi/locking/ras/objtool)"
         "(x86@kernel.org)" <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>
References: <20210305223331.4173565-1-seanjc@google.com>
 <053d0a22-394d-90d0-8d3b-3cd37ca3f378@intel.com>
 <CACT4Y+YTjezgnY_KHzey1q_vDYD7jZCEHU6eOmKHnXYXbzUdcA@mail.gmail.com>
From:   Like Xu <like.xu@linux.intel.com>
Organization: Intel OTC
Message-ID: <2a21980b-7b0a-0de2-d417-09c7c80100cd@linux.intel.com>
Date:   Mon, 8 Mar 2021 16:35:07 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <CACT4Y+YTjezgnY_KHzey1q_vDYD7jZCEHU6eOmKHnXYXbzUdcA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021/3/8 15:12, Dmitry Vyukov wrote:
> On Mon, Mar 8, 2021 at 3:26 AM Xu, Like <like.xu@intel.com> wrote:
>>
>> On 2021/3/6 6:33, Sean Christopherson wrote:
>>> Handle a NULL x86_pmu.guest_get_msrs at invocation instead of patching
>>> in perf_guest_get_msrs_nop() during setup.  If there is no PMU, setup
>>
>> "If there is no PMU" ...
>>
>> How to set up this kind of environment,
>> and what changes are needed in .config or boot parameters ?
> 
> Hi Xu,
> 
> This can be reproduced in qemu with "-cpu max,-pmu" flag using this reproducer:
> https://groups.google.com/g/syzkaller-bugs/c/D8eHw3LIOd0/m/L2G0lVkVBAAJ

Sorry, I couldn't reproduce any VMX abort with "-cpu max,-pmu".
Doe this patch fix this "unexpected kernel reboot" issue ?

If so, you may add "Tested-by" for more attention.

> 
>>> bails before updating the static calls, leaving x86_pmu.guest_get_msrs
>>> NULL and thus a complete nop.
>>
>>> Ultimately, this causes VMX abort on
>>> VM-Exit due to KVM putting random garbage from the stack into the MSR
>>> load list.
>>>
>>> Fixes: abd562df94d1 ("x86/perf: Use static_call for x86_pmu.guest_get_msrs")
>>> Cc: Like Xu <like.xu@linux.intel.com>
>>> Cc: Paolo Bonzini <pbonzini@redhat.com>
>>> Cc: Jim Mattson <jmattson@google.com>
>>> Cc: kvm@vger.kernel.org
>>> Reported-by: Dmitry Vyukov <dvyukov@google.com>
>>> Signed-off-by: Sean Christopherson <seanjc@google.com>
>>> ---
>>>    arch/x86/events/core.c | 16 +++++-----------
>>>    1 file changed, 5 insertions(+), 11 deletions(-)
>>>
>>> diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
>>> index 6ddeed3cd2ac..ff874461f14c 100644
>>> --- a/arch/x86/events/core.c
>>> +++ b/arch/x86/events/core.c
>>> @@ -671,7 +671,11 @@ void x86_pmu_disable_all(void)
>>>
>>>    struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr)
>>>    {
>>> -     return static_call(x86_pmu_guest_get_msrs)(nr);
>>> +     if (x86_pmu.guest_get_msrs)
>>> +             return static_call(x86_pmu_guest_get_msrs)(nr);
>>
>> How about using "static_call_cond" per commit "452cddbff7" ?
>>
>>> +
>>> +     *nr = 0;
>>> +     return NULL;
>>>    }
>>>    EXPORT_SYMBOL_GPL(perf_guest_get_msrs);
>>>
>>> @@ -1944,13 +1948,6 @@ static void _x86_pmu_read(struct perf_event *event)
>>>        x86_perf_event_update(event);
>>>    }
>>>
>>> -static inline struct perf_guest_switch_msr *
>>> -perf_guest_get_msrs_nop(int *nr)
>>> -{
>>> -     *nr = 0;
>>> -     return NULL;
>>> -}
>>> -
>>>    static int __init init_hw_perf_events(void)
>>>    {
>>>        struct x86_pmu_quirk *quirk;
>>> @@ -2024,9 +2021,6 @@ static int __init init_hw_perf_events(void)
>>>        if (!x86_pmu.read)
>>>                x86_pmu.read = _x86_pmu_read;
>>>
>>> -     if (!x86_pmu.guest_get_msrs)
>>> -             x86_pmu.guest_get_msrs = perf_guest_get_msrs_nop;
>>> -
>>>        x86_pmu_static_call_update();
>>>
>>>        /*
>>

