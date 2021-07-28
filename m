Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73A423D898C
	for <lists+kvm@lfdr.de>; Wed, 28 Jul 2021 10:15:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234484AbhG1IPI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jul 2021 04:15:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:24837 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233541AbhG1IPI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 28 Jul 2021 04:15:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627460106;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3X1OXchtwERdylvCYincdzvmNfGGQuFuosSA7ACxUG0=;
        b=UN4vzfLAHPySllGJAUOFJNPpJpPb/s8eONAYSxDpR009ce0hwKaFk2aiagvPFAV9zF/asO
        B8NW3dC6glAXr5QLsxCArTFwNFWujw7aCNbnLVBTj2JhXNDiBi1+9sE6Kw+c0BHkgcE8Gy
        kbJVN6K+dJMJFVFmm2vARi+i0waIpm0=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-322-OAiswkH-M5i_sjnuuKW_0A-1; Wed, 28 Jul 2021 04:15:05 -0400
X-MC-Unique: OAiswkH-M5i_sjnuuKW_0A-1
Received: by mail-ej1-f70.google.com with SMTP id u8-20020a170906c408b02904e0a2912b46so545352ejz.7
        for <kvm@vger.kernel.org>; Wed, 28 Jul 2021 01:15:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=3X1OXchtwERdylvCYincdzvmNfGGQuFuosSA7ACxUG0=;
        b=QnarEzQp5YX4/Eg5+VUMMtAFpZftZfJVGa9UktUuCzzWrqGH55prpxjWJFDlfnyXdT
         V9guO4Hvm8OR4wyNsbEzGIzihVbDot6UwvRvG+5USIkXteCOnRr9zBUPHudYDQmfZhzG
         5x5wVdNKi9GRM3SnCb/XROeJ0MSDOXb41knrKZvfK/BmV+yt03vfPJe8+iLLW1587MHh
         SVRC73vZ54yVaDhMdSWsleA8AIC6xHmKIknRNdU+JlOTU07yCkUqUQ7ndMlwOuXyBJMH
         qlYTlNC4c15sR2vm4Xze0Q3BFset9SgMfpnCDTbOw8UtdapfM2v80V4X/f0fJRqpyJvz
         7OHg==
X-Gm-Message-State: AOAM533AqgVx3Y9LczOaEqIBR2deSUHT8ajA2jUpFwSLUsLwDIyYPMM2
        vsAoZjKqzc49SuCC3kEFwBQZHrqVE6xU6RsHzyN0W4r70iuXnw6RZJceR9Xq4KRSQ3IGAvLXJvP
        bkXv3OliXZYTn
X-Received: by 2002:a17:907:9602:: with SMTP id gb2mr26133909ejc.354.1627460103854;
        Wed, 28 Jul 2021 01:15:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyKTumq6kDjzjsKzaso4vLHIDc9pPvtDOaxvJO9xMIfVSoF86F2NAmpa+zE8VXFHJEMMThOpA==
X-Received: by 2002:a17:907:9602:: with SMTP id gb2mr26133873ejc.354.1627460103512;
        Wed, 28 Jul 2021 01:15:03 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id jg9sm1734676ejc.6.2021.07.28.01.15.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 01:15:03 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Suleiman Souhlal <suleiman@google.com>
Cc:     ssouhlal@FreeBSD.org, joelaf@google.com, senozhatsky@chromium.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Suleiman Souhlal <suleiman@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>
Subject: Re: [RFC PATCH 1/2] kvm,x86: Support heterogeneous RT VCPU
 configurations.
In-Reply-To: <20210728073700.120449-2-suleiman@google.com>
References: <20210728073700.120449-1-suleiman@google.com>
 <20210728073700.120449-2-suleiman@google.com>
Date:   Wed, 28 Jul 2021 10:15:01 +0200
Message-ID: <87wnpa6eii.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Suleiman Souhlal <suleiman@google.com> writes:

> When CONFIG_KVM_HETEROGENEOUS_RT is enabled, it is possible to use a
> RT VCPU without getting hundreds of milliseconds of latency spikes
> when the RT VCPU preempts another VCPU that's holding a lock.
> The guest needs to have preempt_count reporting enabled.
>
> We achieve this by preventing non-RT VCPUs from getting preempted if
> they are in a critical section, which we define as having non-zero
> preempt_count or interrupts disabled. This avoids the priority inversion
> of a RT VCPU preempting another VCPU that is holding a lock that it
> wants.
>
> On a machine with 2 CPU threads, creating a VM with 3 VCPUs and making
> VCPU 2 RT in the host (and preventing most tasks from running on it by
> using "isolcpus"), the max latency shown by
> "/data/local/tmp/cyclictest -l100000 -m -Sp90 -i1000 -q -n" in the guest
> for VCPU2 never exceeds 4ms (and is often < 1ms) in my tests, even when
> the host CPUs are overloaded by running something like
> "for i in `seq 8`; do yes > /dev/null & done".
> Without these changes, the max latency would often get in the hundreds
> of milliseconds.
>
> Signed-off-by: Suleiman Souhlal <suleiman@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h      |  7 +++
>  arch/x86/include/uapi/asm/kvm_para.h |  2 +
>  arch/x86/kvm/Kconfig                 | 13 ++++++
>  arch/x86/kvm/cpuid.c                 |  3 ++
>  arch/x86/kvm/vmx/vmx.c               | 15 ++++++
>  arch/x86/kvm/x86.c                   | 70 +++++++++++++++++++++++++++-
>  arch/x86/kvm/x86.h                   |  2 +
>  include/linux/kvm_host.h             |  4 ++
>  include/linux/preempt.h              |  7 +++
>  kernel/sched/core.c                  | 30 ++++++++++++
>  virt/kvm/Kconfig                     |  3 ++
>  virt/kvm/kvm_main.c                  | 13 ++++++
>  12 files changed, 168 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 974cbfb1eefe..a8a2ceb870d2 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -836,6 +836,13 @@ struct kvm_vcpu_arch {
>  
>  	u64 msr_kvm_poll_control;
>  
> +#ifdef CONFIG_KVM_HETEROGENEOUS_RT
> +	bool preempt_count_enabled;
> +	bool may_boost;
> +	int boost;
> +	struct gfn_to_hva_cache preempt_count_g2h;

Nitpick: we don't seem to use 'g2h' acronym anywhere, it's either
"foo_cache" or "ghc".

> +#endif
> +
>  	/*
>  	 * Indicates the guest is trying to write a gfn that contains one or
>  	 * more of the PTEs used to translate the write itself, i.e. the access
> diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
> index 5146bbab84d4..4534dcb05229 100644
> --- a/arch/x86/include/uapi/asm/kvm_para.h
> +++ b/arch/x86/include/uapi/asm/kvm_para.h
> @@ -35,6 +35,7 @@
>  #define KVM_FEATURE_MSI_EXT_DEST_ID	15
>  #define KVM_FEATURE_HC_MAP_GPA_RANGE	16
>  #define KVM_FEATURE_MIGRATION_CONTROL	17
> +#define KVM_FEATURE_PREEMPT_COUNT	18
>  
>  #define KVM_HINTS_REALTIME      0
>  
> @@ -57,6 +58,7 @@
>  #define MSR_KVM_ASYNC_PF_INT	0x4b564d06
>  #define MSR_KVM_ASYNC_PF_ACK	0x4b564d07
>  #define MSR_KVM_MIGRATION_CONTROL	0x4b564d08
> +#define MSR_KVM_PREEMPT_COUNT	0x4b564d09
>  
>  struct kvm_steal_time {
>  	__u64 steal;
> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> index ac69894eab88..20716814376e 100644
> --- a/arch/x86/kvm/Kconfig
> +++ b/arch/x86/kvm/Kconfig
> @@ -129,4 +129,17 @@ config KVM_MMU_AUDIT
>  	 This option adds a R/W kVM module parameter 'mmu_audit', which allows
>  	 auditing of KVM MMU events at runtime.
>  
> +
> +config KVM_HETEROGENEOUS_RT
> +	bool "Support for heterogeneous real-time VCPU configurations"
> +	depends on KVM
> +	select HAVE_KVM_MAY_PREEMPT
> +	help
> +	 Allows some VCPUs to be real-time. Without this option, if some
> +	 VCPUs are real-time while others are not, extremely long latencies
> +	 might be experienced. Needs guest with CONFIG_PREEMPT_COUNT_REPORTING
> +	 enabled.
> +
> +	 If in doubt, say "N".
> +
>  endif # VIRTUALIZATION
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 739be5da3bca..ea78faad8adc 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -910,6 +910,9 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>  			     (1 << KVM_FEATURE_PV_SEND_IPI) |
>  			     (1 << KVM_FEATURE_POLL_CONTROL) |
>  			     (1 << KVM_FEATURE_PV_SCHED_YIELD) |
> +#ifdef CONFIG_KVM_HETEROGENEOUS_RT
> +			     (1 << KVM_FEATURE_PREEMPT_COUNT) |
> +#endif
>  			     (1 << KVM_FEATURE_ASYNC_PF_INT);
>  
>  		if (sched_info_on())
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 927a552393b9..b2eedcd4d16e 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6750,6 +6750,21 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
>  
>  	trace_kvm_exit(vmx->exit_reason.full, vcpu, KVM_ISA_VMX);
>  
> +#ifdef CONFIG_KVM_HETEROGENEOUS_RT
> +	vcpu->arch.may_boost = 0;
> +	if (vmx->exit_reason.basic == EXIT_REASON_EXTERNAL_INTERRUPT ||
> +	    vmx->exit_reason.basic == EXIT_REASON_PREEMPTION_TIMER ||
> +	    vmx->exit_reason.basic == EXIT_REASON_MSR_WRITE) {
> +		/*
> +		 * Boost when MSR write when sending IPI for function call,
> +		 * otherwise the sending cpu might not be able to release lock
> +		 * and the destination cpu will not be able to progress.
> +		 */
> +		if (kvm_vcpu_dont_preempt(vcpu))
> +			vcpu->arch.may_boost = 1;
> +	}
> +#endif
> +
>  	if (unlikely(vmx->exit_reason.failed_vmentry))
>  		return EXIT_FASTPATH_NONE;
>  
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index a4fd10604f72..c18ea8d136a3 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1355,6 +1355,9 @@ static const u32 emulated_msrs_all[] = {
>  
>  	MSR_KVM_ASYNC_PF_EN, MSR_KVM_STEAL_TIME,
>  	MSR_KVM_PV_EOI_EN, MSR_KVM_ASYNC_PF_INT, MSR_KVM_ASYNC_PF_ACK,
> +#ifdef CONFIG_KVM_HETEROGENEOUS_RT
> +	MSR_KVM_PREEMPT_COUNT,
> +#endif
>  
>  	MSR_IA32_TSC_ADJUST,
>  	MSR_IA32_TSC_DEADLINE,
> @@ -3439,7 +3442,17 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  		if (kvm_lapic_enable_pv_eoi(vcpu, data, sizeof(u8)))
>  			return 1;
>  		break;
> -
> +#ifdef CONFIG_KVM_HETEROGENEOUS_RT
> +	case MSR_KVM_PREEMPT_COUNT:

You probably need 

               if (!guest_pv_has(vcpu, KVM_FEATURE_PREEMPT_COUNT))
                       return 1;

here.

Also, even if MSR_KVM_PREEMPT_COUNT is kind of write-only, you still
need to allow reading it even if only for migration purposes.

> +		vcpu->arch.preempt_count_enabled = 0;
> +		if (!(data & KVM_MSR_ENABLED))
> +			break;
> +		if (!kvm_gfn_to_hva_cache_init(vcpu->kvm,
> +		    &vcpu->arch.preempt_count_g2h, data & ~KVM_MSR_ENABLED,
> +		    sizeof(int)))
> +			vcpu->arch.preempt_count_enabled = 1;
> +		break;
> +#endif
>  	case MSR_KVM_POLL_CONTROL:
>  		if (!guest_pv_has(vcpu, KVM_FEATURE_POLL_CONTROL))
>  			return 1;
> @@ -9684,6 +9697,17 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>  	local_irq_enable();
>  	preempt_enable();
>  
> +#ifdef CONFIG_KVM_HETEROGENEOUS_RT
> +	/*
> +	 * Boosted VCPU is no longer in critical section, so we can yield
> +	 * back the cpu.
> +	 */
> +	if (vcpu->arch.boost && !vcpu->arch.may_boost) {
> +		vcpu->arch.boost = 0;
> +		schedule();
> +	}
> +#endif
> +
>  	vcpu->srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
>  
>  	/*
> @@ -9757,6 +9781,26 @@ static inline bool kvm_vcpu_running(struct kvm_vcpu *vcpu)
>  		!vcpu->arch.apf.halted);
>  }
>  
> +#ifdef CONFIG_KVM_HETEROGENEOUS_RT
> +int
> +kvm_vcpu_dont_preempt(struct kvm_vcpu *vcpu)
> +{
> +	int count, ret;
> +
> +	if (!vcpu->arch.preempt_count_enabled)
> +		return 0;
> +
> +	pagefault_disable();
> +	ret = kvm_read_guest_cached(vcpu->kvm, &vcpu->arch.preempt_count_g2h,
> +	    &count, sizeof(int));
> +	pagefault_enable();

Could you please elaborate on why disabling pagefault here is a good
idea? (and better add a comment).

> +	if (likely(!ret))
> +		return count & ~PREEMPT_NEED_RESCHED || !(kvm_get_rflags(vcpu) &
> +		    X86_EFLAGS_IF);
> +	return 0;
> +}
> +#endif /* CONFIG_KVM_HETEROGENEOUS_RT */
> +
>  static int vcpu_run(struct kvm_vcpu *vcpu)
>  {
>  	int r;
> @@ -10705,6 +10749,11 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>  	vcpu->arch.hv_root_tdp = INVALID_PAGE;
>  #endif
>  
> +#ifdef CONFIG_KVM_HETEROGENEOUS_RT
> +	vcpu->arch.boost = 0;
> +	vcpu->arch.may_boost = 0;
> +#endif
> +
>  	r = static_call(kvm_x86_vcpu_create)(vcpu);
>  	if (r)
>  		goto free_guest_fpu;
> @@ -11066,6 +11115,10 @@ void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu)
>  		kvm_make_request(KVM_REQ_PMU, vcpu);
>  	}
>  	static_call(kvm_x86_sched_in)(vcpu, cpu);
> +#ifdef CONFIG_KVM_HETEROGENEOUS_RT
> +	vcpu->arch.boost = 0;
> +	vcpu->arch.may_boost = 0;
> +#endif
>  }
>  
>  void kvm_arch_free_vm(struct kvm *kvm)
> @@ -11074,6 +11127,21 @@ void kvm_arch_free_vm(struct kvm *kvm)
>  	vfree(kvm);
>  }
>  
> +#ifdef CONFIG_KVM_HETEROGENEOUS_RT
> +#define	MAX_BOOSTS 5

A module parameter instead maybe?

> +
> +bool
> +kvm_arch_may_preempt(struct kvm_vcpu *vcpu, struct task_struct *prev)
> +{
> +	/*
> +	 * Limit the maximum number of times we can get boosted to prevent
> +	 * livelock.
> +	 */
> +	if (vcpu->arch.may_boost && vcpu->arch.boost++ < MAX_BOOSTS)
> +		return false;
> +	return true;
> +}
> +#endif
>  
>  int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>  {
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index 44ae10312740..2954340ed258 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -486,4 +486,6 @@ int kvm_sev_es_string_io(struct kvm_vcpu *vcpu, unsigned int size,
>  			 unsigned int port, void *data,  unsigned int count,
>  			 int in);
>  
> +int kvm_vcpu_dont_preempt(struct kvm_vcpu *vcpu);
> +
>  #endif
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index ae7735b490b4..4d40152a6692 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1695,4 +1695,8 @@ static inline void kvm_handle_signal_exit(struct kvm_vcpu *vcpu)
>  /* Max number of entries allowed for each kvm dirty ring */
>  #define  KVM_DIRTY_RING_MAX_ENTRIES  65536
>  
> +#ifdef CONFIG_HAVE_KVM_MAY_PREEMPT
> +bool kvm_arch_may_preempt(struct kvm_vcpu *vcpu, struct task_struct *prev);
> +#endif /* CONFIG_HAVE_KVM_MAY_PREEMPT */
> +
>  #endif
> diff --git a/include/linux/preempt.h b/include/linux/preempt.h
> index 9881eac0698f..12fcfdd6b825 100644
> --- a/include/linux/preempt.h
> +++ b/include/linux/preempt.h
> @@ -290,6 +290,9 @@ struct preempt_notifier;
>   * @sched_out: we've just been preempted
>   *    notifier: struct preempt_notifier for the task being preempted
>   *    next: the task that's kicking us out
> + * @may_preempt: is it ok to preempt us?
> + *    notifier: struct preempt_notifier for the task being scheduled
> + *    prev: our task
>   *
>   * Please note that sched_in and out are called under different
>   * contexts.  sched_out is called with rq lock held and irq disabled
> @@ -300,6 +303,10 @@ struct preempt_ops {
>  	void (*sched_in)(struct preempt_notifier *notifier, int cpu);
>  	void (*sched_out)(struct preempt_notifier *notifier,
>  			  struct task_struct *next);
> +#ifdef CONFIG_HAVE_KVM_MAY_PREEMPT
> +	bool (*may_preempt)(struct preempt_notifier *notifier,
> +	    struct task_struct *prev);
> +#endif
>  };
>  
>  /**
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 2d9ff40f4661..337265e208a5 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c

Could you please separate sched changes into its own patch so it can get
an ACK from maintainers?

> @@ -4293,6 +4293,21 @@ fire_sched_out_preempt_notifiers(struct task_struct *curr,
>  		__fire_sched_out_preempt_notifiers(curr, next);
>  }
>  
> +#ifdef CONFIG_KVM_HETEROGENEOUS_RT
> +static bool
> +fire_may_preempt_notifiers(struct task_struct *prev)
> +{
> +	struct preempt_notifier *notifier;
> +
> +	if (static_branch_unlikely(&preempt_notifier_key))
> +		hlist_for_each_entry(notifier, &prev->preempt_notifiers, link)
> +			if (notifier->ops->may_preempt &&
> +			    !notifier->ops->may_preempt(notifier, prev))
> +				return false;
> +	return true;
> +}
> +#endif
> +
>  #else /* !CONFIG_PREEMPT_NOTIFIERS */
>  
>  static inline void fire_sched_in_preempt_notifiers(struct task_struct *curr)
> @@ -4305,6 +4320,12 @@ fire_sched_out_preempt_notifiers(struct task_struct *curr,
>  {
>  }
>  
> +static inline bool
> +fire_may_preempt_notifiers(struct task_struct *curr)
> +{
> +	return true;
> +}
> +
>  #endif /* CONFIG_PREEMPT_NOTIFIERS */
>  
>  static inline void prepare_task(struct task_struct *next)
> @@ -5833,6 +5854,15 @@ static void __sched notrace __schedule(bool preempt)
>  	if (sched_feat(HRTICK) || sched_feat(HRTICK_DL))
>  		hrtick_clear(rq);
>  
> +#ifdef CONFIG_KVM_HETEROGENEOUS_RT
> +	if (prev->__state == TASK_RUNNING && prev->sched_class !=
> +	    &rt_sched_class && !fire_may_preempt_notifiers(prev)) {
> +		clear_tsk_need_resched(prev);
> +		clear_preempt_need_resched();
> +		return;
> +	}
> +#endif
> +
>  	local_irq_disable();
>  	rcu_note_context_switch(preempt);
>  
> diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
> index 62b39149b8c8..e4a5ee7a231c 100644
> --- a/virt/kvm/Kconfig
> +++ b/virt/kvm/Kconfig
> @@ -66,3 +66,6 @@ config KVM_XFER_TO_GUEST_WORK
>  
>  config HAVE_KVM_PM_NOTIFIER
>         bool
> +
> +config HAVE_KVM_MAY_PREEMPT
> +	bool
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 986959833d70..d609a7b41497 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -5313,6 +5313,16 @@ static void check_processor_compat(void *data)
>  	*c->ret = kvm_arch_check_processor_compat(c->opaque);
>  }
>  
> +#ifdef CONFIG_HAVE_KVM_MAY_PREEMPT
> +static bool
> +kvm_may_preempt(struct preempt_notifier *pn, struct task_struct *prev)
> +{
> +	struct kvm_vcpu *vcpu = preempt_notifier_to_vcpu(pn);
> +
> +	return kvm_arch_may_preempt(vcpu, prev);
> +}
> +#endif
> +
>  int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
>  		  struct module *module)
>  {
> @@ -5391,6 +5401,9 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
>  
>  	kvm_preempt_ops.sched_in = kvm_sched_in;
>  	kvm_preempt_ops.sched_out = kvm_sched_out;
> +#ifdef CONFIG_HAVE_KVM_MAY_PREEMPT
> +	kvm_preempt_ops.may_preempt = kvm_may_preempt;
> +#endif
>  
>  	kvm_init_debug();

-- 
Vitaly

