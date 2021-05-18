Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA8CE387362
	for <lists+kvm@lfdr.de>; Tue, 18 May 2021 09:39:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345588AbhERHka (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 May 2021 03:40:30 -0400
Received: from mga02.intel.com ([134.134.136.20]:9534 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240333AbhERHk3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 May 2021 03:40:29 -0400
IronPort-SDR: mLKZgSKiMxWVpS0rhf99qtNLbtrgEiB1HL0pzigPkbRHXgAAYh3W9VxZkQCaVx36GhFoCxIP7C
 +Vz04SHGGqLw==
X-IronPort-AV: E=McAfee;i="6200,9189,9987"; a="187775301"
X-IronPort-AV: E=Sophos;i="5.82,309,1613462400"; 
   d="scan'208";a="187775301"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2021 00:38:59 -0700
IronPort-SDR: xIM7zLfKXapUQjNcwqliZtKtai6OuRNNJJu84cjToVWh+beYEGQDrtn4NqPMptLWfX4n0Eu9qF
 BSkf4inxFUQg==
X-IronPort-AV: E=Sophos;i="5.82,309,1613462400"; 
   d="scan'208";a="472823471"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.238.4.93]) ([10.238.4.93])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2021 00:38:54 -0700
Subject: Re: [PATCH v6 02/16] perf/x86/intel: Handle guest PEBS overflow PMI
 for KVM guest
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, weijiang.yang@intel.com,
        Kan Liang <kan.liang@linux.intel.com>, ak@linux.intel.com,
        wei.w.wang@intel.com, eranian@google.com, liuxiangdong5@huawei.com,
        linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        Like Xu <like.xu@linux.intel.com>
References: <20210511024214.280733-1-like.xu@linux.intel.com>
 <20210511024214.280733-3-like.xu@linux.intel.com>
 <YKImQ2/DilGIkrfe@hirez.programming.kicks-ass.net>
From:   "Xu, Like" <like.xu@intel.com>
Message-ID: <bd684011-b83d-5c83-bdfb-926d6bc4595a@intel.com>
Date:   Tue, 18 May 2021 15:38:52 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <YKImQ2/DilGIkrfe@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021/5/17 16:16, Peter Zijlstra wrote:
> On Tue, May 11, 2021 at 10:42:00AM +0800, Like Xu wrote:
>> With PEBS virtualization, the guest PEBS records get delivered to the
>> guest DS, and the host pmi handler uses perf_guest_cbs->is_in_guest()
>> to distinguish whether the PMI comes from the guest code like Intel PT.
>>
>> No matter how many guest PEBS counters are overflowed, only triggering
>> one fake event is enough. The fake event causes the KVM PMI callback to
>> be called, thereby injecting the PEBS overflow PMI into the guest.
>>
>> KVM may inject the PMI with BUFFER_OVF set, even if the guest DS is
>> empty. That should really be harmless. Thus guest PEBS handler would
>> retrieve the correct information from its own PEBS records buffer.
>>
>> Originally-by: Andi Kleen <ak@linux.intel.com>
>> Co-developed-by: Kan Liang <kan.liang@linux.intel.com>
>> Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
>> Signed-off-by: Like Xu <like.xu@linux.intel.com>
>> ---
>>   arch/x86/events/intel/core.c | 40 ++++++++++++++++++++++++++++++++++++
>>   1 file changed, 40 insertions(+)
>>
>> diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
>> index b6e45ee10e16..092ecacf8345 100644
>> --- a/arch/x86/events/intel/core.c
>> +++ b/arch/x86/events/intel/core.c
>> @@ -2780,6 +2780,43 @@ static void intel_pmu_reset(void)
>>   	local_irq_restore(flags);
>>   }
>>   
>> +/*
>> + * We may be running with guest PEBS events created by KVM, and the
>> + * PEBS records are logged into the guest's DS and invisible to host.
>> + *
>> + * In the case of guest PEBS overflow, we only trigger a fake event
>> + * to emulate the PEBS overflow PMI for guest PBES counters in KVM.
>> + * The guest will then vm-entry and check the guest DS area to read
>> + * the guest PEBS records.
>> + *
>> + * The contents and other behavior of the guest event do not matter.
>> + */
>> +static void x86_pmu_handle_guest_pebs(struct pt_regs *regs,
>> +				      struct perf_sample_data *data)
>> +{
>> +	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
>> +	u64 guest_pebs_idxs = cpuc->pebs_enabled & ~cpuc->intel_ctrl_host_mask;
>> +	struct perf_event *event = NULL;
>> +	int bit;
>> +
>> +	if (!x86_pmu.pebs_active || !guest_pebs_idxs)
>> +		return;
>> +
>> +	for_each_set_bit(bit, (unsigned long *)&guest_pebs_idxs,
>> +			 INTEL_PMC_IDX_FIXED + x86_pmu.num_counters_fixed) {
>> +		event = cpuc->events[bit];
>> +		if (!event->attr.precise_ip)
>> +			continue;
>> +
>> +		perf_sample_data_init(data, 0, event->hw.last_period);
>> +		if (perf_event_overflow(event, data, regs))
>> +			x86_pmu_stop(event, 0);
>> +
>> +		/* Inject one fake event is enough. */
>> +		break;
>> +	}
>> +}
>> +
>>   static int handle_pmi_common(struct pt_regs *regs, u64 status)
>>   {
>>   	struct perf_sample_data data;
>> @@ -2831,6 +2868,9 @@ static int handle_pmi_common(struct pt_regs *regs, u64 status)
>>   		u64 pebs_enabled = cpuc->pebs_enabled;
>>   
>>   		handled++;
>> +		if (x86_pmu.pebs_vmx && perf_guest_cbs &&
>> +		    perf_guest_cbs->is_in_guest())
>> +			x86_pmu_handle_guest_pebs(regs, &data);
>>   		x86_pmu.drain_pebs(regs, &data);
>>   		status &= intel_ctrl | GLOBAL_STATUS_TRACE_TOPAPMI;
>>   
> I'm thinking you have your conditions in the wrong order; would it not
> be much cheaper to first check: '!x86_pmu.pebs_active || !guest_pebs_idx'
> than to do that horrible indirect ->is_in_guest() call?
>
> After all, if the guest doesn't have PEBS enabled, who cares if we're
> currently in a guest or not.

Yes, it makes sense. How about:

@@ -2833,6 +2867,10 @@ static int handle_pmi_common(struct pt_regs *regs, 
u64 status)
                 u64 pebs_enabled = cpuc->pebs_enabled;

                 handled++;
+               if (x86_pmu.pebs_vmx && x86_pmu.pebs_active &&
+                   (cpuc->pebs_enabled & ~cpuc->intel_ctrl_host_mask) &&
+                   (static_call(x86_guest_state)() & PERF_GUEST_ACTIVE))
+                       x86_pmu_handle_guest_pebs(regs, &data);
                 x86_pmu.drain_pebs(regs, &data);
                 status &= intel_ctrl | GLOBAL_STATUS_TRACE_TOPAPMI;

>
> Also, something like the below perhaps (arm64 and xen need fixing up at
> the very least) could make all that perf_guest_cbs stuff suck less.

How about the commit message for your below patch:

From: "Peter Zijlstra (Intel)" <peterz@infradead.org>

x86/core: Use static_call to rewrite perf_guest_info_callbacks

The two fields named "is_in_guest" and "is_user_mode" in
perf_guest_info_callbacks are replaced with a new multiplexed member
named "state", and the "get_guest_ip" field will be renamed to "get_ip".

The application of DEFINE_STATIC_CALL_RET0 (arm64 and xen need fixing
up at the very least) could make all that perf_guest_cbs stuff suck less.
For KVM, these callbacks will be updated in the kvm_arch_init().

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>

----

I'm not sue if you have a strong reason to violate the check-patch rule:

ERROR: Using weak declarations can have unintended link defects
#238: FILE: include/linux/perf_event.h:1242:
+extern void __weak arch_perf_update_guest_cbs(void);

?

>
> ---
> diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
> index 8e509325c2c3..c8f8fb7c0536 100644
> --- a/arch/x86/events/core.c
> +++ b/arch/x86/events/core.c
> @@ -90,6 +90,26 @@ DEFINE_STATIC_CALL_NULL(x86_pmu_pebs_aliases, *x86_pmu.pebs_aliases);
>    */
>   DEFINE_STATIC_CALL_RET0(x86_pmu_guest_get_msrs, *x86_pmu.guest_get_msrs);
>   
> +DEFINE_STATIC_CALL_RET0(x86_guest_state, *(perf_guest_cbs->state));
> +DEFINE_STATIC_CALL_RET0(x86_guest_get_ip, *(perf_guest_cbs->get_ip));
> +DEFINE_STATIC_CALL_RET0(x86_guest_handle_intel_pt_intr, *(perf_guest_cbs->handle_intel_pt_intr));
> +
> +void arch_perf_update_guest_cbs(void)
> +{
> +	static_call_update(x86_guest_state, (void *)&__static_call_return0);
> +	static_call_update(x86_guest_get_ip, (void *)&__static_call_return0);
> +	static_call_update(x86_guest_handle_intel_pt_intr, (void *)&__static_call_return0);
> +
> +	if (perf_guest_cbs && perf_guest_cbs->state)
> +		static_call_update(x86_guest_state, perf_guest_cbs->state);
> +
> +	if (perf_guest_cbs && perf_guest_cbs->get_ip)
> +		static_call_update(x86_guest_get_ip, perf_guest_cbs->get_ip);
> +
> +	if (perf_guest_cbs && perf_guest_cbs->handle_intel_pt_intr)
> +		static_call_update(x86_guest_handle_intel_pt_intr, perf_guest_cbs->handle_intel_pt_intr);
> +}
> +
>   u64 __read_mostly hw_cache_event_ids
>   				[PERF_COUNT_HW_CACHE_MAX]
>   				[PERF_COUNT_HW_CACHE_OP_MAX]
> @@ -2736,7 +2756,7 @@ perf_callchain_kernel(struct perf_callchain_entry_ctx *entry, struct pt_regs *re
>   	struct unwind_state state;
>   	unsigned long addr;
>   
> -	if (perf_guest_cbs && perf_guest_cbs->is_in_guest()) {
> +	if (static_call(x86_guest_state)()) {
>   		/* TODO: We don't support guest os callchain now */
>   		return;
>   	}
> @@ -2839,7 +2859,7 @@ perf_callchain_user(struct perf_callchain_entry_ctx *entry, struct pt_regs *regs
>   	struct stack_frame frame;
>   	const struct stack_frame __user *fp;
>   
> -	if (perf_guest_cbs && perf_guest_cbs->is_in_guest()) {
> +	if (static_call(x86_guest_state)()) {
>   		/* TODO: We don't support guest os callchain now */
>   		return;
>   	}
> @@ -2916,18 +2936,21 @@ static unsigned long code_segment_base(struct pt_regs *regs)
>   
>   unsigned long perf_instruction_pointer(struct pt_regs *regs)
>   {
> -	if (perf_guest_cbs && perf_guest_cbs->is_in_guest())
> -		return perf_guest_cbs->get_guest_ip();
> +	unsigned long ip = static_call(x86_guest_get_ip)();
> +
> +	if (likely(!ip))
> +		ip = regs->ip + code_segment_base(regs);
>   
> -	return regs->ip + code_segment_base(regs);
> +	return ip;
>   }
>   
>   unsigned long perf_misc_flags(struct pt_regs *regs)
>   {
> +	unsigned int guest = static_call(x86_guest_state)();
>   	int misc = 0;
>   
> -	if (perf_guest_cbs && perf_guest_cbs->is_in_guest()) {
> -		if (perf_guest_cbs->is_user_mode())
> +	if (guest) {
> +		if (guest & PERF_GUEST_USER)
>   			misc |= PERF_RECORD_MISC_GUEST_USER;
>   		else
>   			misc |= PERF_RECORD_MISC_GUEST_KERNEL;
> diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
> index 2521d03de5e0..ac422c45f940 100644
> --- a/arch/x86/events/intel/core.c
> +++ b/arch/x86/events/intel/core.c
> @@ -2780,6 +2780,8 @@ static void intel_pmu_reset(void)
>   	local_irq_restore(flags);
>   }
>   
> +DECLARE_STATIC_CALL(x86_guest_handle_intel_pt_intr, *(perf_guest_cbs->handle_intel_pt_intr));
> +
>   static int handle_pmi_common(struct pt_regs *regs, u64 status)
>   {
>   	struct perf_sample_data data;
> @@ -2850,10 +2852,7 @@ static int handle_pmi_common(struct pt_regs *regs, u64 status)
>   	 */
>   	if (__test_and_clear_bit(GLOBAL_STATUS_TRACE_TOPAPMI_BIT, (unsigned long *)&status)) {
>   		handled++;
> -		if (unlikely(perf_guest_cbs && perf_guest_cbs->is_in_guest() &&
> -			perf_guest_cbs->handle_intel_pt_intr))
> -			perf_guest_cbs->handle_intel_pt_intr();
> -		else
> +		if (!static_call(x86_guest_handle_intel_pt_intr)())
>   			intel_pt_interrupt();
>   	}
>   
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 55efbacfc244..2a24e615fa4a 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1812,7 +1812,7 @@ int kvm_skip_emulated_instruction(struct kvm_vcpu *vcpu);
>   int kvm_complete_insn_gp(struct kvm_vcpu *vcpu, int err);
>   void __kvm_request_immediate_exit(struct kvm_vcpu *vcpu);
>   
> -int kvm_is_in_guest(void);
> +unsigned int kvm_guest_state(void);
>   
>   void __user *__x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa,
>   				     u32 size);
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index 827886c12c16..2dcbd1b30004 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -87,7 +87,7 @@ static void kvm_perf_overflow_intr(struct perf_event *perf_event,
>   		 * woken up. So we should wake it, but this is impossible from
>   		 * NMI context. Do it from irq work instead.
>   		 */
> -		if (!kvm_is_in_guest())
> +		if (!kvm_guest_state())
>   			irq_work_queue(&pmc_to_pmu(pmc)->irq_work);
>   		else
>   			kvm_make_request(KVM_REQ_PMI, pmc->vcpu);
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index bbc4e04e67ad..88f709b3759c 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -8035,44 +8035,46 @@ static void kvm_timer_init(void)
>   DEFINE_PER_CPU(struct kvm_vcpu *, current_vcpu);
>   EXPORT_PER_CPU_SYMBOL_GPL(current_vcpu);
>   
> -int kvm_is_in_guest(void)
> +static unsigned int kvm_guest_state(void)
>   {
> -	return __this_cpu_read(current_vcpu) != NULL;
> -}
> -
> -static int kvm_is_user_mode(void)
> -{
> -	int user_mode = 3;
> +	struct kvm_vcpu *vcpu = __this_cpu_read(current_vcpu);
> +	unsigned int state = 0;
>   
> -	if (__this_cpu_read(current_vcpu))
> -		user_mode = static_call(kvm_x86_get_cpl)(__this_cpu_read(current_vcpu));
> +	if (vcpu)
> +		state |= PERF_GUEST_ACTIVE;
> +	if (static_call(kvm_x86_get_cpl)(vcpu))
> +		state |= PERF_GUEST_USER;
>   
> -	return user_mode != 0;
> +	return state;
>   }
>   
> -static unsigned long kvm_get_guest_ip(void)
> +static unsigned long kvm_guest_get_ip(void)
>   {
> +	struct kvm_vcpu *vcpu = __this_cpu_read(current_vcpu);
>   	unsigned long ip = 0;
>   
> -	if (__this_cpu_read(current_vcpu))
> -		ip = kvm_rip_read(__this_cpu_read(current_vcpu));
> +	if (vcpu)
> +		ip = kvm_rip_read(vcpu);
>   
>   	return ip;
>   }
>   
> -static void kvm_handle_intel_pt_intr(void)
> +static unsigned int kvm_handle_intel_pt_intr(void)
>   {
>   	struct kvm_vcpu *vcpu = __this_cpu_read(current_vcpu);
>   
> +	if (!vcpu)
> +		return 0;
> +
>   	kvm_make_request(KVM_REQ_PMI, vcpu);
>   	__set_bit(MSR_CORE_PERF_GLOBAL_OVF_CTRL_TRACE_TOPA_PMI_BIT,
>   			(unsigned long *)&vcpu->arch.pmu.global_status);
> +	return 1;
>   }
>   
>   static struct perf_guest_info_callbacks kvm_guest_cbs = {
> -	.is_in_guest		= kvm_is_in_guest,
> -	.is_user_mode		= kvm_is_user_mode,
> -	.get_guest_ip		= kvm_get_guest_ip,
> +	.state			= kvm_guest_state,
> +	.get_ip			= kvm_guest_get_ip,
>   	.handle_intel_pt_intr	= kvm_handle_intel_pt_intr,
>   };
>   
> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index f5a6a2f069ed..7eae1fd22db3 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -26,11 +26,13 @@
>   # include <asm/local64.h>
>   #endif
>   
> +#define PERF_GUEST_ACTIVE	0x01
> +#define PERF_GUEST_USER		0x02
> +
>   struct perf_guest_info_callbacks {
> -	int				(*is_in_guest)(void);
> -	int				(*is_user_mode)(void);
> -	unsigned long			(*get_guest_ip)(void);
> -	void				(*handle_intel_pt_intr)(void);
> +	unsigned int			(*state)(void);
> +	unsigned long			(*get_ip)(void);
> +	unsigned int			(*handle_intel_pt_intr)(void);
>   };
>   
>   #ifdef CONFIG_HAVE_HW_BREAKPOINT
> @@ -1237,6 +1239,8 @@ extern void perf_event_bpf_event(struct bpf_prog *prog,
>   				 u16 flags);
>   
>   extern struct perf_guest_info_callbacks *perf_guest_cbs;
> +extern void __weak arch_perf_update_guest_cbs(void);
> +
>   extern int perf_register_guest_info_callbacks(struct perf_guest_info_callbacks *callbacks);
>   extern int perf_unregister_guest_info_callbacks(struct perf_guest_info_callbacks *callbacks);
>   
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index 2e947a485898..aec531fc9c90 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -6486,9 +6486,17 @@ static void perf_pending_event(struct irq_work *entry)
>    */
>   struct perf_guest_info_callbacks *perf_guest_cbs;
>   
> +void __weak arch_perf_update_guest_cbs(void)
> +{
> +}
> +
>   int perf_register_guest_info_callbacks(struct perf_guest_info_callbacks *cbs)
>   {
> +	if (WARN_ON_ONCE(perf_guest_cbs))
> +		return -EBUSY;
> +
>   	perf_guest_cbs = cbs;
> +	arch_perf_update_guest_cbs();
>   	return 0;
>   }
>   EXPORT_SYMBOL_GPL(perf_register_guest_info_callbacks);

