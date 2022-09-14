Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21EB75B800F
	for <lists+kvm@lfdr.de>; Wed, 14 Sep 2022 06:16:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbiINEP7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Sep 2022 00:15:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbiINEP6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Sep 2022 00:15:58 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B752B3A480;
        Tue, 13 Sep 2022 21:15:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663128956; x=1694664956;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Jkiair1baPAJtoC47+aW99/iEwDFIfwZp8PeL1RP0HU=;
  b=RcV6dAtd4qb4reYGd/p5UqkKVCq8ArxQJ7jXmfRgldxizEZGT5qMXxQr
   X4XQ1jk/1j4NTYcWqYQqlkeDOMlThRs5FMkk+UCUWvBEUq1imIJVhh7Cu
   H241Dnan3BXOsUdwHiwlyiXyCUz5cIJ55Fb9nYUid+JPQdUlD70S9da+X
   JMpeSvyUnpQ6IptkMpSwbU23+19M7NW3RVJBwSbqjCWpT5UdTbFz1TR0d
   KxKNSmbhDpj4nPs2vAjQn5adC5HmIVdtlYWC6rodBRhn6q4KAJWgH7p0A
   VJtiaJPUYd8COXtc0lXOi0bfjyujGO4ZWseH80i5q5iAgCm2C1hYVEoBt
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10469"; a="297059724"
X-IronPort-AV: E=Sophos;i="5.93,313,1654585200"; 
   d="scan'208";a="297059724"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2022 21:15:56 -0700
X-IronPort-AV: E=Sophos;i="5.93,313,1654585200"; 
   d="scan'208";a="647223896"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.249.174.4]) ([10.249.174.4])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2022 21:15:53 -0700
Message-ID: <815586ac-1eaa-5e38-1e08-492c29d0729d@intel.com>
Date:   Wed, 14 Sep 2022 12:15:50 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.13.0
Subject: Re: [RFC PATCH 0/2] KVM: VMX: Fix VM entry failure on
 PT_MODE_HOST_GUEST while host is using PT
Content-Language: en-US
To:     "Wang, Wei W" <wei.w.wang@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     "linux-perf-users@vger.kernel.org" <linux-perf-users@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <20220825085625.867763-1-xiaoyao.li@intel.com>
 <CY5PR11MB6365897E8E6D0B590A298FA0DC769@CY5PR11MB6365.namprd11.prod.outlook.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <CY5PR11MB6365897E8E6D0B590A298FA0DC769@CY5PR11MB6365.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/29/2022 3:49 PM, Wang, Wei W wrote:
> On Thursday, August 25, 2022 4:56 PM, Xiaoyao Li wrote:
>> There is one bug in KVM that can hit vm-entry failure 100% on platform
>> supporting PT_MODE_HOST_GUEST mode following below steps:
>>
>>    1. #modprobe -r kvm_intel
>>    2. #modprobe kvm_intel pt_mode=1
>>    3. start a VM with QEMU
>>    4. on host: #perf record -e intel_pt//
>>
>> The vm-entry failure happens because it violates the requirement stated in
>> Intel SDM 26.2.1.1 VM-Execution Control Fields
>>
>>    If the logical processor is operating with Intel PT enabled (if
>>    IA32_RTIT_CTL.TraceEn = 1) at the time of VM entry, the "load
>>    IA32_RTIT_CTL" VM-entry control must be 0.
>>
>> On PT_MODE_HOST_GUEST node, PT_MODE_HOST_GUEST is always set. Thus
>> KVM needs to ensure IA32_RTIT_CTL.TraceEn is 0 before VM-entry. Currently
>> KVM manually WRMSR(IA32_RTIT_CTL) to clear TraceEn bit. However, it
>> doesn't work everytime since there is a posibility that IA32_RTIT_CTL.TraceEn
>> is re-enabled in PT PMI handler before vm-entry. This series tries to fix the
>> issue by exposing two interfaces from Intel PT driver for the purose to stop and
>> resume Intel PT on host. It prevents PT PMI handler from re-enabling PT. By the
>> way, it also fixes another issue that PT PMI touches PT MSRs whihc leads to
>> what KVM stores for host bemomes stale.
> 
> I'm thinking about another approach to fixing it. I think we need to have the
> running host pt event disabled when we switch to guest and don't expect to
> receive the host pt interrupt at this point. Also, the host pt context can be
> save/restored by host perf core (instead of KVM) when we disable/enable
> the event.
> 
> diff --git a/arch/x86/events/intel/pt.c b/arch/x86/events/intel/pt.c
> index 82ef87e9a897..1d3e03ecaf6a 100644
> --- a/arch/x86/events/intel/pt.c
> +++ b/arch/x86/events/intel/pt.c
> @@ -1575,6 +1575,7 @@ static void pt_event_start(struct perf_event *event, int mode)
> 
>          pt_config_buffer(buf);
>          pt_config(event);
> +       pt->event = event;
> 
>          return;
> 
> @@ -1600,6 +1601,7 @@ static void pt_event_stop(struct perf_event *event, int mode)
>                  return;
> 
>          event->hw.state = PERF_HES_STOPPED;
> +       pt->event = NULL;
> 
>          if (mode & PERF_EF_UPDATE) {
>                  struct pt_buffer *buf = perf_get_aux(&pt->handle);
> @@ -1624,6 +1626,15 @@ static void pt_event_stop(struct perf_event *event, int mode)
>          }
>   }
> 
> +
> +struct perf_event *pt_get_curr_event(void)
> +{
> +       struct pt *pt = this_cpu_ptr(&pt_ctx);
> +
> +       return pt->event;
> +}
> +EXPORT_SYMBOL_GPL(pt_get_curr_event);
> +
>   static long pt_event_snapshot_aux(struct perf_event *event,
>                                    struct perf_output_handle *handle,
>                                    unsigned long size)
> diff --git a/arch/x86/events/intel/pt.h b/arch/x86/events/intel/pt.h
> index 96906a62aacd..d46a85bb06bb 100644
> --- a/arch/x86/events/intel/pt.h
> +++ b/arch/x86/events/intel/pt.h
> @@ -121,6 +121,7 @@ struct pt_filters {
>    * @output_mask:       cached RTIT_OUTPUT_MASK MSR value
>    */
>   struct pt {
> +       struct perf_event       *event;
>          struct perf_output_handle handle;
>          struct pt_filters       filters;
>          int                     handle_nmi;
> diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
> index f6fc8dd51ef4..be8dd24922a7 100644
> --- a/arch/x86/include/asm/perf_event.h
> +++ b/arch/x86/include/asm/perf_event.h
> @@ -553,11 +553,14 @@ static inline int x86_perf_get_lbr(struct x86_pmu_lbr *lbr)
> 
>   #ifdef CONFIG_CPU_SUP_INTEL
>    extern void intel_pt_handle_vmx(int on);
> + extern struct perf_event *pt_get_curr_event(void);
>   #else
>   static inline void intel_pt_handle_vmx(int on)
>   {
> 
> +
>   }
> +struct perf_event *pt_get_curr_event(void) { }
>   #endif
> 
>   #if defined(CONFIG_PERF_EVENTS) && defined(CONFIG_CPU_SUP_AMD)
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index d7f8331d6f7e..195debc1bff1 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1125,37 +1125,29 @@ static inline void pt_save_msr(struct pt_ctx *ctx, u32 addr_range)
> 
>   static void pt_guest_enter(struct vcpu_vmx *vmx)
>   {
> -       if (vmx_pt_mode_is_system())
> +       struct perf_event *event;
> +
> +       if (vmx_pt_mode_is_system() ||
> +           !(vmx->pt_desc.guest.ctl & RTIT_CTL_TRACEEN))
>                  return;
> 
> -       /*
> -        * GUEST_IA32_RTIT_CTL is already set in the VMCS.
> -        * Save host state before VM entry.
> -        */
> -       rdmsrl(MSR_IA32_RTIT_CTL, vmx->pt_desc.host.ctl);
> -       if (vmx->pt_desc.guest.ctl & RTIT_CTL_TRACEEN) {
> -               wrmsrl(MSR_IA32_RTIT_CTL, 0);
> -               pt_save_msr(&vmx->pt_desc.host, vmx->pt_desc.num_address_ranges);
> -               pt_load_msr(&vmx->pt_desc.guest, vmx->pt_desc.num_address_ranges);
> -       }
> +       event = pt_get_curr_event();
> +       perf_event_disable(event);

perf_event_disable() is not allowed in preemption disabled context, since

perf_event_disable()
-> perf_event_ctx_lock()
    -> perf_event_ctx_lock_nested()
       -> mutex_lock_nested()

and it causes

[ 3542.164553] BUG: sleeping function called from invalid context at 
kernel/locking/mutex.c:580
[ 3542.165140] in_atomic(): 1, irqs_disabled(): 1, non_block: 0, pid: 
1518, name: CPU 0/KVM
[ 3542.165703] preempt_count: 1, expected: 0
[ 3542.166006] RCU nest depth: 0, expected: 0
[ 3542.166315] INFO: lockdep is turned off.
[ 3542.166614] irq event stamp: 0
[ 3542.166857] hardirqs last  enabled at (0): [<0000000000000000>] 0x0
[ 3542.167304] hardirqs last disabled at (0): [<ffffffff94699ac8>] 
copy_process+0x8e8/0x1bd0
[ 3542.167874] softirqs last  enabled at (0): [<ffffffff94699ac8>] 
copy_process+0x8e8/0x1bd0
[ 3542.168443] softirqs last disabled at (0): [<0000000000000000>] 0x0
[ 3542.168891] Preemption disabled at:
[ 3542.168893] [<ffffffffc0c28f29>] vcpu_enter_guest+0x139/0x1350 [kvm]
[ 3542.169674] CPU: 20 PID: 1518 Comm: CPU 0/KVM Not tainted 
6.0.0-rc5-fix-pt-vm-entry+ #3 f2d44ed9be3fc4a510291e2989c9432fce3cb5de
[ 3542.170457] Hardware name: Intel Corporation JACOBSVILLE/JACOBSVILLE, 
BIOS JBVLCRB1.86B.0012.D75.1912120439 12/12/2019
[ 3542.171188] Call Trace:
[ 3542.171392]  <TASK>
[ 3542.171572]  show_stack+0x52/0x5c
[ 3542.171831]  dump_stack_lvl+0x5b/0x86
[ 3542.172112]  dump_stack+0x10/0x16
[ 3542.172371]  __might_resched.cold+0x135/0x15b
[ 3542.172698]  __might_sleep+0x52/0xa0
[ 3542.172975]  __mutex_lock+0x4e/0x4d0
[ 3542.173251]  ? kvm_sched_in+0x4f/0x60 [kvm 
1f4ec973e90cea60cd68c22c1431d8e7f534c92b]
[ 3542.173839]  ? perf_event_ctx_lock_nested+0xc8/0x230
[ 3542.174202]  ? rcu_read_lock_sched_held+0x16/0x90
[ 3542.174551]  ? lock_acquire+0xfc/0x150
[ 3542.174840]  ? perf_event_ctx_lock_nested+0x24/0x230
[ 3542.175205]  mutex_lock_nested+0x1c/0x30
[ 3542.175505]  perf_event_ctx_lock_nested+0xc8/0x230
[ 3542.181147]  ? perf_event_ctx_lock_nested+0x24/0x230
[ 3542.186839]  perf_event_disable+0x19/0x80
[ 3542.192502]  vmx_vcpu_run+0x3e5/0xfe0 [kvm_intel 
7936a7891efe9306918aa504b0eb8bc1e7ba3aa6]
[ 3542.203771]  ? rcu_read_lock_sched_held+0x16/0x90
[ 3542.209378]  vcpu_enter_guest+0xa96/0x1350 [kvm 
1f4ec973e90cea60cd68c22c1431d8e7f534c92b]
[ 3542.215218]  ? vcpu_enter_guest+0xbe1/0x1350 [kvm 
1f4ec973e90cea60cd68c22c1431d8e7f534c92b]
[ 3542.226292]  ? rcu_read_lock_sched_held+0x16/0x90
[ 3542.231956]  ? rcu_read_lock_sched_held+0x16/0x90
[ 3542.237542]  ? lock_acquire+0xfc/0x150
[ 3542.243093]  ? __rseq_handle_notify_resume+0x3a/0x60
[ 3542.248689]  vcpu_run+0x53/0x490 [kvm 
1f4ec973e90cea60cd68c22c1431d8e7f534c92b]
[ 3542.254533]  ? vcpu_run+0x35a/0x490 [kvm 
1f4ec973e90cea60cd68c22c1431d8e7f534c92b]
[ 3542.260567]  kvm_arch_vcpu_ioctl_run+0x162/0x680 [kvm 
1f4ec973e90cea60cd68c22c1431d8e7f534c92b]
[ 3542.272395]  ? kvm_arch_vcpu_ioctl_run+0x6d/0x680 [kvm 
1f4ec973e90cea60cd68c22c1431d8e7f534c92b]
[ 3542.284586]  kvm_vcpu_ioctl+0x2ad/0x7a0 [kvm 
1f4ec973e90cea60cd68c22c1431d8e7f534c92b]
[ 3542.290973]  ? lock_acquire+0xfc/0x150
[ 3542.296990]  ? rcu_read_lock_sched_held+0x16/0x90
[ 3542.302912]  ? lock_release+0x118/0x190
[ 3542.308800]  ? __fget_files+0xe8/0x1c0
[ 3542.314710]  ? __fget_files+0x5/0x1c0
[ 3542.320591]  __x64_sys_ioctl+0x96/0xd0
[ 3542.326500]  do_syscall_64+0x3a/0x90
[ 3542.332426]  entry_SYSCALL_64_after_hwframe+0x5e/0xc8


I know little about perf. It seems perf_event_disable() is not used 
widely by other kernel component. Is there a alternative? If no, I think 
expose disable/enable helper from pt driver like this series seems OK.

> +       vmx->pt_desc.host_event = event;
> +       pt_load_msr(&vmx->pt_desc.guest, vmx->pt_desc.num_address_ranges);
> }
> 
>   static void pt_guest_exit(struct vcpu_vmx *vmx)
>   {
> -       if (vmx_pt_mode_is_system())
> -               return;
> +       struct perf_event *event = vmx->pt_desc.host_event;
> 
> -       if (vmx->pt_desc.guest.ctl & RTIT_CTL_TRACEEN) {
> -               pt_save_msr(&vmx->pt_desc.guest, vmx->pt_desc.num_address_ranges);
> -               pt_load_msr(&vmx->pt_desc.host, vmx->pt_desc.num_address_ranges);
> -       }
> +       if (vmx_pt_mode_is_system() ||
> +           !(vmx->pt_desc.guest.ctl & RTIT_CTL_TRACEEN))
> +               return;
> 
> -       /*
> -        * KVM requires VM_EXIT_CLEAR_IA32_RTIT_CTL to expose PT to the guest,
> -        * i.e. RTIT_CTL is always cleared on VM-Exit.  Restore it if necessary.
> -        */
> -       if (vmx->pt_desc.host.ctl)
> -               wrmsrl(MSR_IA32_RTIT_CTL, vmx->pt_desc.host.ctl);
> +       pt_save_msr(&vmx->pt_desc.guest, vmx->pt_desc.num_address_ranges);
> +       if (event)
> +               perf_event_enable(event);
>   }
> 
>   void vmx_set_host_fs_gs(struct vmcs_host_state *host, u16 fs_sel, u16 gs_sel,
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index 24d58c2ffaa3..4c20bdabc85b 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -66,7 +66,7 @@ struct pt_desc {
>          u64 ctl_bitmask;
>          u32 num_address_ranges;
>          u32 caps[PT_CPUID_REGS_NUM * PT_CPUID_LEAVES];
> -       struct pt_ctx host;
> +       struct perf_event *host_event;
>          struct pt_ctx guest;
>   };
> 
> 

