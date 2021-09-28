Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59FC141B9CC
	for <lists+kvm@lfdr.de>; Wed, 29 Sep 2021 00:02:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243028AbhI1WDp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Sep 2021 18:03:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242626AbhI1WDo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Sep 2021 18:03:44 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B266C061749
        for <kvm@vger.kernel.org>; Tue, 28 Sep 2021 15:02:04 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id q23so181314pfs.9
        for <kvm@vger.kernel.org>; Tue, 28 Sep 2021 15:02:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Uyoda1M7++CEI+NcRU/yK2dl+cGCwI02HkT4b++R1XE=;
        b=QmD9aRi5+EgXAhlFuGRdUSQX9Uz44AR4z/xWFh7r5QT9hkbF4lCu+zQav9YSXgTRyS
         t4PzcBteTlw4efZui3v5HdXJF7B/u5xuDN9Q4R25bnKdnKN0ChrLBQkE/NWcFvgvvoFL
         dpBa+t9Y3niHPnrPqER/44HMTZko+o4g6GsMWICeInOFWuAOv8+OC5zd9/IbKCNeQ0bQ
         pnhhjuD6njqd9lK9s+QpX0A7z+4ZOBBgt87sWSJz6PEUWABHG+PyyaV5v4Qyd0w7G6UN
         GAxfqE0GOh66cNhOiALuHOx9cSXTKQ6O1pFouqpuBjy0h1dfGu4jwZXe/uINmux/Lkzy
         ZSyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Uyoda1M7++CEI+NcRU/yK2dl+cGCwI02HkT4b++R1XE=;
        b=DWPKEzCypB4MMCoiBvVesDECCv3TbkbwA76QzQZ8+Hy2iEbz5+57Ru/GLU5yguMFKh
         erloqfwbjWiL5U7ryeMGdhJqBKlwnuvEVoVMemzgAR6w4sx0HxhmHjfWMnyJpmvR4XDE
         hswI5J9koG6RAXjWsEH5ED94PXzUvvJkcxkpK6t5rr0hmn0KtlF//xBLmjsOdnGwM0Dc
         UyiXyQam2NNyf7Hwk6GlzRfX0YF1v9JbiBY8uLk5u/e/TECJU3nxZO6+4G4tA63Aqip3
         iek3GtgO9HKOI3RIR/Nze2A8bd5Vs+XOf99JZeNx6AUZ5Ej1ot2M4UFuJI6tSSuwhkUj
         WUAA==
X-Gm-Message-State: AOAM532lGs2tezzNsoKfc19hZ0tdTVhbjbV5iGTGDHeNBhcsE6JAU4/m
        0jRY6uerzJvPi7ZeKtpOWJvhnw==
X-Google-Smtp-Source: ABdhPJye4SCXxstkrD9IGAb+VU0ISMKN7AbRPH62N+iZQF4/kOnvfClBLcpmaOSexQOUuMcdr0Zn3A==
X-Received: by 2002:a63:f5b:: with SMTP id 27mr6363279pgp.302.1632866523282;
        Tue, 28 Sep 2021 15:02:03 -0700 (PDT)
Received: from google.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id h4sm143929pgn.6.2021.09.28.15.02.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Sep 2021 15:02:02 -0700 (PDT)
Date:   Tue, 28 Sep 2021 22:01:58 +0000
From:   David Matlack <dmatlack@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jing Zhang <jingzhangos@google.com>
Subject: Re: [PATCH 09/14] KVM: Rename kvm_vcpu_block() => kvm_vcpu_halt()
Message-ID: <YVOQ1vxdDUQKziT+@google.com>
References: <20210925005528.1145584-1-seanjc@google.com>
 <20210925005528.1145584-10-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210925005528.1145584-10-seanjc@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 24, 2021 at 05:55:23PM -0700, Sean Christopherson wrote:
> Rename kvm_vcpu_block() to kvm_vcpu_halt() in preparation for splitting
> the actual "block" sequences into a separate helper (to be named
> kvm_vcpu_block()).  x86 will use the standalone block-only path to handle
> non-halt cases where the vCPU is not runnable.
> 
> Rename block_ns to halt_ns to match the new function name.
> 
> Opportunistically move an x86-specific comment to x86, and enhance it, too.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: David Matlack <dmatlack@google.com>

> ---
>  arch/arm64/kvm/arch_timer.c       |  2 +-
>  arch/arm64/kvm/handle_exit.c      |  4 ++--
>  arch/arm64/kvm/psci.c             |  2 +-
>  arch/mips/kvm/emulate.c           |  2 +-
>  arch/powerpc/kvm/book3s_pr.c      |  2 +-
>  arch/powerpc/kvm/book3s_pr_papr.c |  2 +-
>  arch/powerpc/kvm/booke.c          |  2 +-
>  arch/powerpc/kvm/powerpc.c        |  2 +-
>  arch/s390/kvm/interrupt.c         |  2 +-
>  arch/x86/kvm/x86.c                | 11 +++++++++--
>  include/linux/kvm_host.h          |  2 +-
>  virt/kvm/kvm_main.c               | 20 +++++++++-----------
>  12 files changed, 29 insertions(+), 24 deletions(-)
> 
> diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
> index 3df67c127489..7e8396f74010 100644
> --- a/arch/arm64/kvm/arch_timer.c
> +++ b/arch/arm64/kvm/arch_timer.c
> @@ -467,7 +467,7 @@ static void timer_save_state(struct arch_timer_context *ctx)
>  }
>  
>  /*
> - * Schedule the background timer before calling kvm_vcpu_block, so that this
> + * Schedule the background timer before calling kvm_vcpu_halt, so that this
>   * thread is removed from its waitqueue and made runnable when there's a timer
>   * interrupt to handle.
>   */
> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> index 275a27368a04..08f823984712 100644
> --- a/arch/arm64/kvm/handle_exit.c
> +++ b/arch/arm64/kvm/handle_exit.c
> @@ -82,7 +82,7 @@ static int handle_no_fpsimd(struct kvm_vcpu *vcpu)
>   *
>   * WFE: Yield the CPU and come back to this vcpu when the scheduler
>   * decides to.
> - * WFI: Simply call kvm_vcpu_block(), which will halt execution of
> + * WFI: Simply call kvm_vcpu_halt(), which will halt execution of
>   * world-switches and schedule other host processes until there is an
>   * incoming IRQ or FIQ to the VM.
>   */
> @@ -95,7 +95,7 @@ static int kvm_handle_wfx(struct kvm_vcpu *vcpu)
>  	} else {
>  		trace_kvm_wfx_arm64(*vcpu_pc(vcpu), false);
>  		vcpu->stat.wfi_exit_stat++;
> -		kvm_vcpu_block(vcpu);
> +		kvm_vcpu_halt(vcpu);
>  		kvm_clear_request(KVM_REQ_UNHALT, vcpu);
>  	}
>  
> diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
> index 74c47d420253..e275b2ca08b9 100644
> --- a/arch/arm64/kvm/psci.c
> +++ b/arch/arm64/kvm/psci.c
> @@ -46,7 +46,7 @@ static unsigned long kvm_psci_vcpu_suspend(struct kvm_vcpu *vcpu)
>  	 * specification (ARM DEN 0022A). This means all suspend states
>  	 * for KVM will preserve the register state.
>  	 */
> -	kvm_vcpu_block(vcpu);
> +	kvm_vcpu_halt(vcpu);
>  	kvm_clear_request(KVM_REQ_UNHALT, vcpu);
>  
>  	return PSCI_RET_SUCCESS;
> diff --git a/arch/mips/kvm/emulate.c b/arch/mips/kvm/emulate.c
> index 22e745e49b0a..b494d8d39290 100644
> --- a/arch/mips/kvm/emulate.c
> +++ b/arch/mips/kvm/emulate.c
> @@ -952,7 +952,7 @@ enum emulation_result kvm_mips_emul_wait(struct kvm_vcpu *vcpu)
>  	if (!vcpu->arch.pending_exceptions) {
>  		kvm_vz_lose_htimer(vcpu);
>  		vcpu->arch.wait = 1;
> -		kvm_vcpu_block(vcpu);
> +		kvm_vcpu_halt(vcpu);
>  
>  		/*
>  		 * We we are runnable, then definitely go off to user space to
> diff --git a/arch/powerpc/kvm/book3s_pr.c b/arch/powerpc/kvm/book3s_pr.c
> index 6bc9425acb32..0ced1b16f0e5 100644
> --- a/arch/powerpc/kvm/book3s_pr.c
> +++ b/arch/powerpc/kvm/book3s_pr.c
> @@ -492,7 +492,7 @@ static void kvmppc_set_msr_pr(struct kvm_vcpu *vcpu, u64 msr)
>  
>  	if (msr & MSR_POW) {
>  		if (!vcpu->arch.pending_exceptions) {
> -			kvm_vcpu_block(vcpu);
> +			kvm_vcpu_halt(vcpu);
>  			kvm_clear_request(KVM_REQ_UNHALT, vcpu);
>  			vcpu->stat.generic.halt_wakeup++;
>  
> diff --git a/arch/powerpc/kvm/book3s_pr_papr.c b/arch/powerpc/kvm/book3s_pr_papr.c
> index ac14239f3424..1f10e7dfcdd0 100644
> --- a/arch/powerpc/kvm/book3s_pr_papr.c
> +++ b/arch/powerpc/kvm/book3s_pr_papr.c
> @@ -376,7 +376,7 @@ int kvmppc_h_pr(struct kvm_vcpu *vcpu, unsigned long cmd)
>  		return kvmppc_h_pr_stuff_tce(vcpu);
>  	case H_CEDE:
>  		kvmppc_set_msr_fast(vcpu, kvmppc_get_msr(vcpu) | MSR_EE);
> -		kvm_vcpu_block(vcpu);
> +		kvm_vcpu_halt(vcpu);
>  		kvm_clear_request(KVM_REQ_UNHALT, vcpu);
>  		vcpu->stat.generic.halt_wakeup++;
>  		return EMULATE_DONE;
> diff --git a/arch/powerpc/kvm/booke.c b/arch/powerpc/kvm/booke.c
> index 977801c83aff..12abffa40cd9 100644
> --- a/arch/powerpc/kvm/booke.c
> +++ b/arch/powerpc/kvm/booke.c
> @@ -718,7 +718,7 @@ int kvmppc_core_prepare_to_enter(struct kvm_vcpu *vcpu)
>  
>  	if (vcpu->arch.shared->msr & MSR_WE) {
>  		local_irq_enable();
> -		kvm_vcpu_block(vcpu);
> +		kvm_vcpu_halt(vcpu);
>  		kvm_clear_request(KVM_REQ_UNHALT, vcpu);
>  		hard_irq_disable();
>  
> diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
> index 8ab90ce8738f..565eed2dab81 100644
> --- a/arch/powerpc/kvm/powerpc.c
> +++ b/arch/powerpc/kvm/powerpc.c
> @@ -236,7 +236,7 @@ int kvmppc_kvm_pv(struct kvm_vcpu *vcpu)
>  		break;
>  	case EV_HCALL_TOKEN(EV_IDLE):
>  		r = EV_SUCCESS;
> -		kvm_vcpu_block(vcpu);
> +		kvm_vcpu_halt(vcpu);
>  		kvm_clear_request(KVM_REQ_UNHALT, vcpu);
>  		break;
>  	default:
> diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
> index 520450a7956f..10bd648170b7 100644
> --- a/arch/s390/kvm/interrupt.c
> +++ b/arch/s390/kvm/interrupt.c
> @@ -1335,7 +1335,7 @@ int kvm_s390_handle_wait(struct kvm_vcpu *vcpu)
>  	VCPU_EVENT(vcpu, 4, "enabled wait: %llu ns", sltime);
>  no_timer:
>  	srcu_read_unlock(&vcpu->kvm->srcu, vcpu->srcu_idx);
> -	kvm_vcpu_block(vcpu);
> +	kvm_vcpu_halt(vcpu);
>  	vcpu->valid_wakeup = false;
>  	__unset_cpu_idle(vcpu);
>  	vcpu->srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index eade8a2bdccf..0d71c73a61bb 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -8645,6 +8645,13 @@ void kvm_arch_exit(void)
>  
>  static int __kvm_emulate_halt(struct kvm_vcpu *vcpu, int state, int reason)
>  {
> +	/*
> +	 * The vCPU has halted, e.g. executed HLT.  Update the run state if the
> +	 * local APIC is in-kernel, the run loop will detect the non-runnable
> +	 * state and halt the vCPU.  Exit to userspace if the local APIC is
> +	 * managed by userspace, in which case userspace is responsible for
> +	 * handling wake events.
> +	 */
>  	++vcpu->stat.halt_exits;
>  	if (lapic_in_kernel(vcpu)) {
>  		vcpu->arch.mp_state = state;
> @@ -9886,7 +9893,7 @@ static inline int vcpu_block(struct kvm *kvm, struct kvm_vcpu *vcpu)
>  	if (!kvm_arch_vcpu_runnable(vcpu) &&
>  	    (!kvm_x86_ops.pre_block || static_call(kvm_x86_pre_block)(vcpu) == 0)) {
>  		srcu_read_unlock(&kvm->srcu, vcpu->srcu_idx);
> -		kvm_vcpu_block(vcpu);
> +		kvm_vcpu_halt(vcpu);
>  		vcpu->srcu_idx = srcu_read_lock(&kvm->srcu);
>  
>  		if (kvm_x86_ops.post_block)
> @@ -10120,7 +10127,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>  			r = -EINTR;
>  			goto out;
>  		}
> -		kvm_vcpu_block(vcpu);
> +		kvm_vcpu_halt(vcpu);
>  		if (kvm_apic_accept_events(vcpu) < 0) {
>  			r = 0;
>  			goto out;
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 3f87d6ad20bf..d2a8be3fb9ba 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -965,7 +965,7 @@ void kvm_vcpu_mark_page_dirty(struct kvm_vcpu *vcpu, gfn_t gfn);
>  void kvm_sigset_activate(struct kvm_vcpu *vcpu);
>  void kvm_sigset_deactivate(struct kvm_vcpu *vcpu);
>  
> -void kvm_vcpu_block(struct kvm_vcpu *vcpu);
> +void kvm_vcpu_halt(struct kvm_vcpu *vcpu);
>  void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu);
>  void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu);
>  bool kvm_vcpu_wake_up(struct kvm_vcpu *vcpu);
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index f96cda8312f3..280cf1dca7db 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -3221,16 +3221,13 @@ static inline void update_halt_poll_stats(struct kvm_vcpu *vcpu, ktime_t start,
>  	}
>  }
>  
> -/*
> - * The vCPU has executed a HLT instruction with in-kernel mode enabled.
> - */
> -void kvm_vcpu_block(struct kvm_vcpu *vcpu)
> +void kvm_vcpu_halt(struct kvm_vcpu *vcpu)
>  {
>  	bool halt_poll_allowed = !kvm_arch_no_poll(vcpu);
>  	bool do_halt_poll = halt_poll_allowed && vcpu->halt_poll_ns;
>  	ktime_t start, cur, poll_end;
>  	bool waited = false;
> -	u64 block_ns;
> +	u64 halt_ns;
>  
>  	start = cur = poll_end = ktime_get();
>  	if (do_halt_poll) {
> @@ -3273,7 +3270,8 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
>  	}
>  
>  out:
> -	block_ns = ktime_to_ns(cur) - ktime_to_ns(start);
> +	/* The total time the vCPU was "halted", including polling time. */
> +	halt_ns = ktime_to_ns(cur) - ktime_to_ns(start);
>  
>  	/*
>  	 * Note, halt-polling is considered successful so long as the vCPU was
> @@ -3287,24 +3285,24 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
>  		if (!vcpu_valid_wakeup(vcpu)) {
>  			shrink_halt_poll_ns(vcpu);
>  		} else if (vcpu->kvm->max_halt_poll_ns) {
> -			if (block_ns <= vcpu->halt_poll_ns)
> +			if (halt_ns <= vcpu->halt_poll_ns)
>  				;
>  			/* we had a long block, shrink polling */
>  			else if (vcpu->halt_poll_ns &&
> -					block_ns > vcpu->kvm->max_halt_poll_ns)
> +				 halt_ns > vcpu->kvm->max_halt_poll_ns)
>  				shrink_halt_poll_ns(vcpu);
>  			/* we had a short halt and our poll time is too small */
>  			else if (vcpu->halt_poll_ns < vcpu->kvm->max_halt_poll_ns &&
> -					block_ns < vcpu->kvm->max_halt_poll_ns)
> +				 halt_ns < vcpu->kvm->max_halt_poll_ns)
>  				grow_halt_poll_ns(vcpu);
>  		} else {
>  			vcpu->halt_poll_ns = 0;
>  		}
>  	}
>  
> -	trace_kvm_vcpu_wakeup(block_ns, waited, vcpu_valid_wakeup(vcpu));
> +	trace_kvm_vcpu_wakeup(halt_ns, waited, vcpu_valid_wakeup(vcpu));
>  }
> -EXPORT_SYMBOL_GPL(kvm_vcpu_block);
> +EXPORT_SYMBOL_GPL(kvm_vcpu_halt);
>  
>  bool kvm_vcpu_wake_up(struct kvm_vcpu *vcpu)
>  {
> -- 
> 2.33.0.685.g46640cef36-goog
> 
