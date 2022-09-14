Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F3E15B8FA6
	for <lists+kvm@lfdr.de>; Wed, 14 Sep 2022 22:25:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbiINUZm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Sep 2022 16:25:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiINUZk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Sep 2022 16:25:40 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D869B1277F;
        Wed, 14 Sep 2022 13:25:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663187138; x=1694723138;
  h=message-id:date:mime-version:to:cc:references:from:
   subject:in-reply-to:content-transfer-encoding;
  bh=ULa3g5H2RT8pA1+sjT+EjmhN7Tl0WB6Y4XPOjGo0Miw=;
  b=Vdw6HsqzrbE4LFnR8wkEYKk2PqN5qC4bzc4r/qJ/4o8yqBdjC4P1N4Qv
   hxrZkX0ro2mwDgINgCUpEopvT6WhOEXZatm+KTIqhpBl5i3oBehiS7RJ8
   GHG5vjzEmu+BLKezXAKYrErK1dP24aDNKilgBPvKbY109k3S8kDJpNxCX
   Ite27IGbXLf4OsZqoqFG52JHUV9GXrJzZVfHn5irPu8b+3uewMtCMI7Hf
   pFD2fWPsUcDW6eRtIrt0b3mfaS1mX4d15dK1Z4mv26yLMsLOaIzFeCF3j
   DI1iWPUJ4Pbjc5mCXADJiLuOt585B3AtrWILAaFGQuE804qKWV7NpVl4A
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10470"; a="299346937"
X-IronPort-AV: E=Sophos;i="5.93,315,1654585200"; 
   d="scan'208";a="299346937"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2022 13:25:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,315,1654585200"; 
   d="scan'208";a="685443072"
Received: from linux.intel.com ([10.54.29.200])
  by fmsmga004.fm.intel.com with ESMTP; 14 Sep 2022 13:25:34 -0700
Received: from [10.252.210.12] (kliang2-mobl1.ccr.corp.intel.com [10.252.210.12])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 3D75C580C37;
        Wed, 14 Sep 2022 13:25:32 -0700 (PDT)
Message-ID: <f7cfb391-c38b-84d2-b2fe-5e289d82862c@linux.intel.com>
Date:   Wed, 14 Sep 2022 16:25:30 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Content-Language: en-US
To:     "Wang, Wei W" <wei.w.wang@intel.com>,
        "Li, Xiaoyao" <xiaoyao.li@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Liang, Kan" <kan.liang@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>
Cc:     "linux-perf-users@vger.kernel.org" <linux-perf-users@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <20220825085625.867763-1-xiaoyao.li@intel.com>
 <CY5PR11MB6365897E8E6D0B590A298FA0DC769@CY5PR11MB6365.namprd11.prod.outlook.com>
 <815586ac-1eaa-5e38-1e08-492c29d0729d@intel.com>
 <CY5PR11MB63659EBEAEA0E64812E96111DC469@CY5PR11MB6365.namprd11.prod.outlook.com>
From:   "Liang, Kan" <kan.liang@linux.intel.com>
Subject: Re: [RFC PATCH 0/2] KVM: VMX: Fix VM entry failure on
 PT_MODE_HOST_GUEST while host is using PT
In-Reply-To: <CY5PR11MB63659EBEAEA0E64812E96111DC469@CY5PR11MB6365.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2022-09-14 2:16 a.m., Wang, Wei W wrote:
> On Wednesday, September 14, 2022 12:16 PM, Li, Xiaoyao wrote:
>> On 8/29/2022 3:49 PM, Wang, Wei W wrote:
>>> On Thursday, August 25, 2022 4:56 PM, Xiaoyao Li wrote:
>>>> There is one bug in KVM that can hit vm-entry failure 100% on
>>>> platform supporting PT_MODE_HOST_GUEST mode following below steps:
>>>>
>>>>    1. #modprobe -r kvm_intel
>>>>    2. #modprobe kvm_intel pt_mode=1
>>>>    3. start a VM with QEMU
>>>>    4. on host: #perf record -e intel_pt//
>>>>
>>>> The vm-entry failure happens because it violates the requirement
>>>> stated in Intel SDM 26.2.1.1 VM-Execution Control Fields
>>>>
>>>>    If the logical processor is operating with Intel PT enabled (if
>>>>    IA32_RTIT_CTL.TraceEn = 1) at the time of VM entry, the "load
>>>>    IA32_RTIT_CTL" VM-entry control must be 0.
>>>>
>>>> On PT_MODE_HOST_GUEST node, PT_MODE_HOST_GUEST is always set.
>> Thus
>>>> KVM needs to ensure IA32_RTIT_CTL.TraceEn is 0 before VM-entry.
>>>> Currently KVM manually WRMSR(IA32_RTIT_CTL) to clear TraceEn bit.
>>>> However, it doesn't work everytime since there is a posibility that
>>>> IA32_RTIT_CTL.TraceEn is re-enabled in PT PMI handler before
>>>> vm-entry. This series tries to fix the issue by exposing two
>>>> interfaces from Intel PT driver for the purose to stop and resume
>>>> Intel PT on host. It prevents PT PMI handler from re-enabling PT. By
>>>> the way, it also fixes another issue that PT PMI touches PT MSRs whihc
>> leads to what KVM stores for host bemomes stale.
>>>
>>> I'm thinking about another approach to fixing it. I think we need to
>>> have the running host pt event disabled when we switch to guest and
>>> don't expect to receive the host pt interrupt at this point. Also, the
>>> host pt context can be save/restored by host perf core (instead of
>>> KVM) when we disable/enable the event.
>>>
>>> diff --git a/arch/x86/events/intel/pt.c b/arch/x86/events/intel/pt.c
>>> index 82ef87e9a897..1d3e03ecaf6a 100644
>>> --- a/arch/x86/events/intel/pt.c
>>> +++ b/arch/x86/events/intel/pt.c
>>> @@ -1575,6 +1575,7 @@ static void pt_event_start(struct perf_event
>>> *event, int mode)
>>>
>>>          pt_config_buffer(buf);
>>>          pt_config(event);
>>> +       pt->event = event;
>>>
>>>          return;
>>>
>>> @@ -1600,6 +1601,7 @@ static void pt_event_stop(struct perf_event
>> *event, int mode)
>>>                  return;
>>>
>>>          event->hw.state = PERF_HES_STOPPED;
>>> +       pt->event = NULL;
>>>
>>>          if (mode & PERF_EF_UPDATE) {
>>>                  struct pt_buffer *buf = perf_get_aux(&pt->handle);
>> @@
>>> -1624,6 +1626,15 @@ static void pt_event_stop(struct perf_event *event,
>> int mode)
>>>          }
>>>   }
>>>
>>> +
>>> +struct perf_event *pt_get_curr_event(void) {
>>> +       struct pt *pt = this_cpu_ptr(&pt_ctx);
>>> +
>>> +       return pt->event;
>>> +}
>>> +EXPORT_SYMBOL_GPL(pt_get_curr_event);
>>> +
>>>   static long pt_event_snapshot_aux(struct perf_event *event,
>>>                                    struct perf_output_handle
>> *handle,
>>>                                    unsigned long size) diff --git
>>> a/arch/x86/events/intel/pt.h b/arch/x86/events/intel/pt.h index
>>> 96906a62aacd..d46a85bb06bb 100644
>>> --- a/arch/x86/events/intel/pt.h
>>> +++ b/arch/x86/events/intel/pt.h
>>> @@ -121,6 +121,7 @@ struct pt_filters {
>>>    * @output_mask:       cached RTIT_OUTPUT_MASK MSR value
>>>    */
>>>   struct pt {
>>> +       struct perf_event       *event;
>>>          struct perf_output_handle handle;
>>>          struct pt_filters       filters;
>>>          int                     handle_nmi;
>>> diff --git a/arch/x86/include/asm/perf_event.h
>>> b/arch/x86/include/asm/perf_event.h
>>> index f6fc8dd51ef4..be8dd24922a7 100644
>>> --- a/arch/x86/include/asm/perf_event.h
>>> +++ b/arch/x86/include/asm/perf_event.h
>>> @@ -553,11 +553,14 @@ static inline int x86_perf_get_lbr(struct
>>> x86_pmu_lbr *lbr)
>>>
>>>   #ifdef CONFIG_CPU_SUP_INTEL
>>>    extern void intel_pt_handle_vmx(int on);
>>> + extern struct perf_event *pt_get_curr_event(void);
>>>   #else
>>>   static inline void intel_pt_handle_vmx(int on)
>>>   {
>>>
>>> +
>>>   }
>>> +struct perf_event *pt_get_curr_event(void) { }
>>>   #endif
>>>
>>>   #if defined(CONFIG_PERF_EVENTS) && defined(CONFIG_CPU_SUP_AMD)
>> diff
>>> --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c index
>>> d7f8331d6f7e..195debc1bff1 100644
>>> --- a/arch/x86/kvm/vmx/vmx.c
>>> +++ b/arch/x86/kvm/vmx/vmx.c
>>> @@ -1125,37 +1125,29 @@ static inline void pt_save_msr(struct pt_ctx
>>> *ctx, u32 addr_range)
>>>
>>>   static void pt_guest_enter(struct vcpu_vmx *vmx)
>>>   {
>>> -       if (vmx_pt_mode_is_system())
>>> +       struct perf_event *event;
>>> +
>>> +       if (vmx_pt_mode_is_system() ||
>>> +           !(vmx->pt_desc.guest.ctl & RTIT_CTL_TRACEEN))
>>>                  return;
>>>
>>> -       /*
>>> -        * GUEST_IA32_RTIT_CTL is already set in the VMCS.
>>> -        * Save host state before VM entry.
>>> -        */
>>> -       rdmsrl(MSR_IA32_RTIT_CTL, vmx->pt_desc.host.ctl);
>>> -       if (vmx->pt_desc.guest.ctl & RTIT_CTL_TRACEEN) {
>>> -               wrmsrl(MSR_IA32_RTIT_CTL, 0);
>>> -               pt_save_msr(&vmx->pt_desc.host,
>> vmx->pt_desc.num_address_ranges);
>>> -               pt_load_msr(&vmx->pt_desc.guest,
>> vmx->pt_desc.num_address_ranges);
>>> -       }
>>> +       event = pt_get_curr_event();
>>> +       perf_event_disable(event);
>>
>> perf_event_disable() is not allowed in preemption disabled context, since
>>
>> perf_event_disable()
>> -> perf_event_ctx_lock()
>>     -> perf_event_ctx_lock_nested()
>>        -> mutex_lock_nested()
>>
>> and it causes
>>
>> [ 3542.164553] BUG: sleeping function called from invalid context at
>> kernel/locking/mutex.c:580
>> [ 3542.165140] in_atomic(): 1, irqs_disabled(): 1, non_block: 0, pid:
>> 1518, name: CPU 0/KVM
>> [ 3542.165703] preempt_count: 1, expected: 0 [ 3542.166006] RCU nest depth:
>> 0, expected: 0 [ 3542.166315] INFO: lockdep is turned off.
>> [ 3542.166614] irq event stamp: 0
>> [ 3542.166857] hardirqs last  enabled at (0): [<0000000000000000>] 0x0
>> [ 3542.167304] hardirqs last disabled at (0): [<ffffffff94699ac8>]
>> copy_process+0x8e8/0x1bd0
>> [ 3542.167874] softirqs last  enabled at (0): [<ffffffff94699ac8>]
>> copy_process+0x8e8/0x1bd0
>> [ 3542.168443] softirqs last disabled at (0): [<0000000000000000>] 0x0
>> [ 3542.168891] Preemption disabled at:
>> [ 3542.168893] [<ffffffffc0c28f29>] vcpu_enter_guest+0x139/0x1350 [kvm]
>> [ 3542.169674] CPU: 20 PID: 1518 Comm: CPU 0/KVM Not tainted
>> 6.0.0-rc5-fix-pt-vm-entry+ #3 f2d44ed9be3fc4a510291e2989c9432fce3cb5de
>> [ 3542.170457] Hardware name: Intel Corporation JACOBSVILLE/JACOBSVILLE,
>> BIOS JBVLCRB1.86B.0012.D75.1912120439 12/12/2019 [ 3542.171188] Call
>> Trace:
>> [ 3542.171392]  <TASK>
>> [ 3542.171572]  show_stack+0x52/0x5c
>> [ 3542.171831]  dump_stack_lvl+0x5b/0x86 [ 3542.172112]
>> dump_stack+0x10/0x16 [ 3542.172371]  __might_resched.cold+0x135/0x15b
>> [ 3542.172698]  __might_sleep+0x52/0xa0 [ 3542.172975]
>> __mutex_lock+0x4e/0x4d0 [ 3542.173251]  ? kvm_sched_in+0x4f/0x60 [kvm
>> 1f4ec973e90cea60cd68c22c1431d8e7f534c92b]
>> [ 3542.173839]  ? perf_event_ctx_lock_nested+0xc8/0x230
>> [ 3542.174202]  ? rcu_read_lock_sched_held+0x16/0x90
>> [ 3542.174551]  ? lock_acquire+0xfc/0x150 [ 3542.174840]  ?
>> perf_event_ctx_lock_nested+0x24/0x230
>> [ 3542.175205]  mutex_lock_nested+0x1c/0x30 [ 3542.175505]
>> perf_event_ctx_lock_nested+0xc8/0x230
>> [ 3542.181147]  ? perf_event_ctx_lock_nested+0x24/0x230
>> [ 3542.186839]  perf_event_disable+0x19/0x80 [ 3542.192502]
>> vmx_vcpu_run+0x3e5/0xfe0 [kvm_intel
>> 7936a7891efe9306918aa504b0eb8bc1e7ba3aa6]
>> [ 3542.203771]  ? rcu_read_lock_sched_held+0x16/0x90
>> [ 3542.209378]  vcpu_enter_guest+0xa96/0x1350 [kvm
>> 1f4ec973e90cea60cd68c22c1431d8e7f534c92b]
>> [ 3542.215218]  ? vcpu_enter_guest+0xbe1/0x1350 [kvm
>> 1f4ec973e90cea60cd68c22c1431d8e7f534c92b]
>> [ 3542.226292]  ? rcu_read_lock_sched_held+0x16/0x90
>> [ 3542.231956]  ? rcu_read_lock_sched_held+0x16/0x90
>> [ 3542.237542]  ? lock_acquire+0xfc/0x150 [ 3542.243093]  ?
>> __rseq_handle_notify_resume+0x3a/0x60
>> [ 3542.248689]  vcpu_run+0x53/0x490 [kvm
>> 1f4ec973e90cea60cd68c22c1431d8e7f534c92b]
>> [ 3542.254533]  ? vcpu_run+0x35a/0x490 [kvm
>> 1f4ec973e90cea60cd68c22c1431d8e7f534c92b]
>> [ 3542.260567]  kvm_arch_vcpu_ioctl_run+0x162/0x680 [kvm
>> 1f4ec973e90cea60cd68c22c1431d8e7f534c92b]
>> [ 3542.272395]  ? kvm_arch_vcpu_ioctl_run+0x6d/0x680 [kvm
>> 1f4ec973e90cea60cd68c22c1431d8e7f534c92b]
>> [ 3542.284586]  kvm_vcpu_ioctl+0x2ad/0x7a0 [kvm
>> 1f4ec973e90cea60cd68c22c1431d8e7f534c92b]
>> [ 3542.290973]  ? lock_acquire+0xfc/0x150 [ 3542.296990]  ?
>> rcu_read_lock_sched_held+0x16/0x90
>> [ 3542.302912]  ? lock_release+0x118/0x190 [ 3542.308800]  ?
>> __fget_files+0xe8/0x1c0 [ 3542.314710]  ? __fget_files+0x5/0x1c0
>> [ 3542.320591]  __x64_sys_ioctl+0x96/0xd0 [ 3542.326500]
>> do_syscall_64+0x3a/0x90 [ 3542.332426]
>> entry_SYSCALL_64_after_hwframe+0x5e/0xc8
>>
>>
>> I know little about perf.
>  
> +Kan to double confirm if needed.


The perf_event_disable() eventually invokes the intel_pt_stop().
We already expose the intel_pt_stop()/cpu_emergency_stop_pt() to other
modules. I don't think we have to use the perf_event_disable(). Also,
the perf_event_disable() requires extra codes.

I went through the discussions. I agree with Sean's suggestion.
We should only put the logic in the KVM but all the MSR access details
into the PT driver. But I prefer a more generic and straightforward
function name, e.g., intel_pt_stop_save()/intel_pt_start_load(), in case
other modules may want to save/restore the PT information in their
context switch later.

Thanks,
Kan

> 
>> It seems perf_event_disable() is not used widely by
>> other kernel component. Is there a alternative? If no, I think expose
>> disable/enable helper from pt driver like this series seems OK.
> 
> Oops, it was actually a mistake to disable the event on other CPUs.
> Can you expose and use perf_event_disable_local?
> 
> For the enabling side, we need to add and expose perf_event_enable_local:
> event_function_local(event, __perf_event_enable, NULL);
