Return-Path: <kvm+bounces-4468-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2348C812DC3
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 11:54:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5DF6CB212B0
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 10:54:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E29163FB18;
	Thu, 14 Dec 2023 10:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Q6pYGnGK"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD55E193
	for <kvm@vger.kernel.org>; Thu, 14 Dec 2023 02:53:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702551192;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MnhJLfTgIa3SLXx4xPA9543TtdSKVB5MmnU2aw58KwM=;
	b=Q6pYGnGKECFf0S8X2bx4bTbnyhfkl3H1KPZoSi15MwJDD+EBt1m5MF7gdx8Db1MOwyj0pd
	+fzw5S8LDa4iemqUNroA/sebLK0FZ+YoRyazjPLP47f1STX3hz5+AZNBRDLGobTiuZz2mD
	x4vpCzOxytrHknZTRU9ILYpf2wmV2Gs=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-65-xMvqU_3pNaGjwxpUsgJV6w-1; Thu, 14 Dec 2023 05:53:10 -0500
X-MC-Unique: xMvqU_3pNaGjwxpUsgJV6w-1
Received: by mail-lj1-f199.google.com with SMTP id 38308e7fff4ca-2c9ef4b6ce4so65756281fa.1
        for <kvm@vger.kernel.org>; Thu, 14 Dec 2023 02:53:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702551188; x=1703155988;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MnhJLfTgIa3SLXx4xPA9543TtdSKVB5MmnU2aw58KwM=;
        b=ImUX6pdqwawWHrtv4hKtCdokxuHDOQR6Yv+4TZ5vqT4NBfjwaDdbPi+FFBAhsAmj1K
         uTyj6hr1rjBK1e4JokvxRET9fK3FxKpZxzc8fgqAfduT/6dGw/orSkJTfV9fgbCU2lx3
         jKpLsYZ0AxIqgYWP/ri40xOSCNZ7M4cUOtzXGE/mA3JwIwKO/jMASsuqkHVGHDSrz/50
         +grpLBRumAmBEGA7hi74fKC95DIhBD0lK3OgV2ho2Wr+cgBfrX69luyFP38eaTxU/qEq
         aXt2qACv2UDx7F9kikor6+djd6jnh8awXCq8CO86vjEiS2QxxGOSVlBVZ1Fu5Jhki48K
         sbkQ==
X-Gm-Message-State: AOJu0Yw4bUDbgdeQ3kqUM9VWpzRLcUg7XTY8bAVdgeeWZnQC7Hf7+xjg
	HyrORzImyy8MiHT04sxuDQEwuWGqF4nHMGCphqljSKLN9XN2xZPHch/YqpVJt1nzYNSFc8r1+W5
	M5YnYWNvME/E+
X-Received: by 2002:ac2:5bc6:0:b0:50b:f7c1:e560 with SMTP id u6-20020ac25bc6000000b0050bf7c1e560mr4949377lfn.64.1702551188434;
        Thu, 14 Dec 2023 02:53:08 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEk+Q1l8hgiJ7UNrZAfbbpiLBywjIYVZ2ilgn7mgJ9X6HXByaqkQ5JHzQ6fHFgg15QB4WdHxw==
X-Received: by 2002:ac2:5bc6:0:b0:50b:f7c1:e560 with SMTP id u6-20020ac25bc6000000b0050bf7c1e560mr4949372lfn.64.1702551188062;
        Thu, 14 Dec 2023 02:53:08 -0800 (PST)
Received: from fedora (g2.ign.cz. [91.219.240.8])
        by smtp.gmail.com with ESMTPSA id g13-20020a056000118d00b003333d46a9e8sm15714036wrx.56.2023.12.14.02.53.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Dec 2023 02:53:07 -0800 (PST)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: "Vineeth Pillai (Google)" <vineeth@bitbyteword.org>
Cc: Suleiman Souhlal <suleiman@google.com>, Masami Hiramatsu
 <mhiramat@google.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 x86@kernel.org, Joel Fernandes <joel@joelfernandes.org>, Ben Segall
 <bsegall@google.com>, Borislav Petkov <bp@alien8.de>, Daniel Bristot de
 Oliveira <bristot@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>, "H . Peter Anvin"
 <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Juri Lelli
 <juri.lelli@redhat.com>, Mel Gorman <mgorman@suse.de>, Paolo Bonzini
 <pbonzini@redhat.com>, Andy Lutomirski <luto@kernel.org>, Peter Zijlstra
 <peterz@infradead.org>, Sean Christopherson <seanjc@google.com>, Steven
 Rostedt <rostedt@goodmis.org>, Thomas Gleixner <tglx@linutronix.de>,
 Valentin Schneider <vschneid@redhat.com>, Vincent Guittot
 <vincent.guittot@linaro.org>, Wanpeng Li <wanpengli@tencent.com>
Subject: Re: [RFC PATCH 1/8] kvm: x86: MSR for setting up scheduler info
 shared memory
In-Reply-To: <20231214024727.3503870-2-vineeth@bitbyteword.org>
References: <20231214024727.3503870-1-vineeth@bitbyteword.org>
 <20231214024727.3503870-2-vineeth@bitbyteword.org>
Date: Thu, 14 Dec 2023 11:53:06 +0100
Message-ID: <877clhkqct.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

"Vineeth Pillai (Google)" <vineeth@bitbyteword.org> writes:

> Implement a kvm MSR that guest uses to provide the GPA of shared memory
> for communicating the scheduling information between host and guest.
>
> wrmsr(0) disables the feature. wrmsr(valid_gpa) enables the feature and
> uses the gpa for further communication.
>
> Also add a new cpuid feature flag for the host to advertise the feature
> to the guest.
>
> Co-developed-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> Signed-off-by: Vineeth Pillai (Google) <vineeth@bitbyteword.org>
> ---
>  arch/x86/include/asm/kvm_host.h      | 25 ++++++++++++
>  arch/x86/include/uapi/asm/kvm_para.h | 24 +++++++++++
>  arch/x86/kvm/Kconfig                 | 12 ++++++
>  arch/x86/kvm/cpuid.c                 |  2 +
>  arch/x86/kvm/x86.c                   | 61 ++++++++++++++++++++++++++++
>  include/linux/kvm_host.h             |  5 +++
>  6 files changed, 129 insertions(+)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index f72b30d2238a..f89ba1f07d88 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -987,6 +987,18 @@ struct kvm_vcpu_arch {
>  	/* Protected Guests */
>  	bool guest_state_protected;
>  
> +#ifdef CONFIG_PARAVIRT_SCHED_KVM
> +	/*
> +	 * MSR to setup a shared memory for scheduling
> +	 * information sharing between host and guest.
> +	 */
> +	struct {
> +		enum kvm_vcpu_boost_state boost_status;
> +		u64 msr_val;
> +		struct gfn_to_hva_cache data;
> +	} pv_sched;
> +#endif
> +
>  	/*
>  	 * Set when PDPTS were loaded directly by the userspace without
>  	 * reading the guest memory
> @@ -2217,4 +2229,17 @@ int memslot_rmap_alloc(struct kvm_memory_slot *slot, unsigned long npages);
>   */
>  #define KVM_EXIT_HYPERCALL_MBZ		GENMASK_ULL(31, 1)
>  
> +#ifdef CONFIG_PARAVIRT_SCHED_KVM
> +static inline bool kvm_arch_vcpu_pv_sched_enabled(struct kvm_vcpu_arch *arch)
> +{
> +	return arch->pv_sched.msr_val;
> +}
> +
> +static inline void kvm_arch_vcpu_set_boost_status(struct kvm_vcpu_arch *arch,
> +		enum kvm_vcpu_boost_state boost_status)
> +{
> +	arch->pv_sched.boost_status = boost_status;
> +}
> +#endif
> +
>  #endif /* _ASM_X86_KVM_HOST_H */
> diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
> index 6e64b27b2c1e..6b1dea07a563 100644
> --- a/arch/x86/include/uapi/asm/kvm_para.h
> +++ b/arch/x86/include/uapi/asm/kvm_para.h
> @@ -36,6 +36,7 @@
>  #define KVM_FEATURE_MSI_EXT_DEST_ID	15
>  #define KVM_FEATURE_HC_MAP_GPA_RANGE	16
>  #define KVM_FEATURE_MIGRATION_CONTROL	17
> +#define KVM_FEATURE_PV_SCHED		18
>  
>  #define KVM_HINTS_REALTIME      0
>  
> @@ -58,6 +59,7 @@
>  #define MSR_KVM_ASYNC_PF_INT	0x4b564d06
>  #define MSR_KVM_ASYNC_PF_ACK	0x4b564d07
>  #define MSR_KVM_MIGRATION_CONTROL	0x4b564d08
> +#define MSR_KVM_PV_SCHED	0x4b564da0
>  
>  struct kvm_steal_time {
>  	__u64 steal;
> @@ -150,4 +152,26 @@ struct kvm_vcpu_pv_apf_data {
>  #define KVM_PV_EOI_ENABLED KVM_PV_EOI_MASK
>  #define KVM_PV_EOI_DISABLED 0x0
>  
> +/*
> + * VCPU boost state shared between the host and guest.
> + */
> +enum kvm_vcpu_boost_state {
> +	/* Priority boosting feature disabled in host */
> +	VCPU_BOOST_DISABLED = 0,
> +	/*
> +	 * vcpu is not explicitly boosted by the host.
> +	 * (Default priority when the guest started)
> +	 */
> +	VCPU_BOOST_NORMAL,
> +	/* vcpu is boosted by the host */
> +	VCPU_BOOST_BOOSTED
> +};
> +
> +/*
> + * Structure passed in via MSR_KVM_PV_SCHED
> + */
> +struct pv_sched_data {
> +	__u64 boost_status;
> +};
> +
>  #endif /* _UAPI_ASM_X86_KVM_PARA_H */
> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> index 89ca7f4c1464..dbcba73fb508 100644
> --- a/arch/x86/kvm/Kconfig
> +++ b/arch/x86/kvm/Kconfig
> @@ -141,4 +141,16 @@ config KVM_XEN
>  config KVM_EXTERNAL_WRITE_TRACKING
>  	bool
>  
> +config PARAVIRT_SCHED_KVM
> +	bool "Enable paravirt scheduling capability for kvm"
> +	depends on KVM
> +	help
> +	  Paravirtualized scheduling facilitates the exchange of scheduling
> +	  related information between the host and guest through shared memory,
> +	  enhancing the efficiency of vCPU thread scheduling by the hypervisor.
> +	  An illustrative use case involves dynamically boosting the priority of
> +	  a vCPU thread when the guest is executing a latency-sensitive workload
> +	  on that specific vCPU.
> +	  This config enables paravirt scheduling in the kvm hypervisor.
> +
>  endif # VIRTUALIZATION
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 7bdc66abfc92..960ef6e869f2 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -1113,6 +1113,8 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>  			     (1 << KVM_FEATURE_POLL_CONTROL) |
>  			     (1 << KVM_FEATURE_PV_SCHED_YIELD) |
>  			     (1 << KVM_FEATURE_ASYNC_PF_INT);
> +		if (IS_ENABLED(CONFIG_PARAVIRT_SCHED_KVM))
> +			entry->eax |= (1 << KVM_FEATURE_PV_SCHED);
>  
>  		if (sched_info_on())
>  			entry->eax |= (1 << KVM_FEATURE_STEAL_TIME);
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 7bcf1a76a6ab..0f475b50ac83 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3879,6 +3879,33 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  			return 1;
>  		break;
>  
> +#ifdef CONFIG_PARAVIRT_SCHED_KVM
> +	case MSR_KVM_PV_SCHED:
> +		if (!guest_pv_has(vcpu, KVM_FEATURE_PV_SCHED))
> +			return 1;
> +
> +		if (!(data & KVM_MSR_ENABLED))
> +			break;
> +
> +		if (!(data & ~KVM_MSR_ENABLED)) {
> +			/*
> +			 * Disable the feature
> +			 */
> +			vcpu->arch.pv_sched.msr_val = 0;
> +			kvm_set_vcpu_boosted(vcpu, false);
> +		} if (!kvm_gfn_to_hva_cache_init(vcpu->kvm,
> +				&vcpu->arch.pv_sched.data, data & ~KVM_MSR_ENABLED,
> +				sizeof(struct pv_sched_data))) {
> +			vcpu->arch.pv_sched.msr_val = data;
> +			kvm_set_vcpu_boosted(vcpu, false);
> +		} else {
> +			pr_warn("MSR_KVM_PV_SCHED: kvm:%p, vcpu:%p, "
> +				"msr value: %llx, kvm_gfn_to_hva_cache_init failed!\n",
> +				vcpu->kvm, vcpu, data & ~KVM_MSR_ENABLED);

As this is triggerable by the guest please drop this print (which is not
even ratelimited!). I think it would be better to just 'return 1;' in case
of kvm_gfn_to_hva_cache_init() failure but maybe you also need to
account for 'msr_info->host_initiated' to not fail setting this MSR from
the host upon migration.

> +		}
> +		break;
> +#endif
> +
>  	case MSR_KVM_POLL_CONTROL:
>  		if (!guest_pv_has(vcpu, KVM_FEATURE_POLL_CONTROL))
>  			return 1;
> @@ -4239,6 +4266,11 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  
>  		msr_info->data = vcpu->arch.pv_eoi.msr_val;
>  		break;
> +#ifdef CONFIG_PARAVIRT_SCHED_KVM
> +	case MSR_KVM_PV_SCHED:
> +		msr_info->data = vcpu->arch.pv_sched.msr_val;
> +		break;
> +#endif
>  	case MSR_KVM_POLL_CONTROL:
>  		if (!guest_pv_has(vcpu, KVM_FEATURE_POLL_CONTROL))
>  			return 1;
> @@ -9820,6 +9852,29 @@ static int complete_hypercall_exit(struct kvm_vcpu *vcpu)
>  	return kvm_skip_emulated_instruction(vcpu);
>  }
>  
> +#ifdef CONFIG_PARAVIRT_SCHED_KVM
> +static void record_vcpu_boost_status(struct kvm_vcpu *vcpu)
> +{
> +	u64 val = vcpu->arch.pv_sched.boost_status;
> +
> +	if (!kvm_arch_vcpu_pv_sched_enabled(&vcpu->arch))
> +		return;
> +
> +	pagefault_disable();
> +	kvm_write_guest_offset_cached(vcpu->kvm, &vcpu->arch.pv_sched.data,
> +		&val, offsetof(struct pv_sched_data, boost_status), sizeof(u64));
> +	pagefault_enable();
> +}
> +
> +void kvm_set_vcpu_boosted(struct kvm_vcpu *vcpu, bool boosted)
> +{
> +	kvm_arch_vcpu_set_boost_status(&vcpu->arch,
> +			boosted ? VCPU_BOOST_BOOSTED : VCPU_BOOST_NORMAL);
> +
> +	kvm_make_request(KVM_REQ_VCPU_BOOST_UPDATE, vcpu);
> +}
> +#endif
> +
>  int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
>  {
>  	unsigned long nr, a0, a1, a2, a3, ret;
> @@ -10593,6 +10648,12 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>  		}
>  		if (kvm_check_request(KVM_REQ_STEAL_UPDATE, vcpu))
>  			record_steal_time(vcpu);
> +
> +#ifdef CONFIG_PARAVIRT_SCHED_KVM
> +		if (kvm_check_request(KVM_REQ_VCPU_BOOST_UPDATE, vcpu))
> +			record_vcpu_boost_status(vcpu);
> +#endif
> +
>  #ifdef CONFIG_KVM_SMM
>  		if (kvm_check_request(KVM_REQ_SMI, vcpu))
>  			process_smi(vcpu);
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 9d3ac7720da9..a74aeea55347 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -167,6 +167,7 @@ static inline bool is_error_page(struct page *page)
>  #define KVM_REQ_VM_DEAD			(1 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
>  #define KVM_REQ_UNBLOCK			2
>  #define KVM_REQ_DIRTY_RING_SOFT_FULL	3
> +#define KVM_REQ_VCPU_BOOST_UPDATE	6
>  #define KVM_REQUEST_ARCH_BASE		8
>  
>  /*
> @@ -2287,4 +2288,8 @@ static inline void kvm_account_pgtable_pages(void *virt, int nr)
>  /* Max number of entries allowed for each kvm dirty ring */
>  #define  KVM_DIRTY_RING_MAX_ENTRIES  65536
>  
> +#ifdef CONFIG_PARAVIRT_SCHED_KVM
> +void kvm_set_vcpu_boosted(struct kvm_vcpu *vcpu, bool boosted);
> +#endif
> +
>  #endif

-- 
Vitaly


