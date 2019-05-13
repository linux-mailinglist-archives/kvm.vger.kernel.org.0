Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3529A1BE37
	for <lists+kvm@lfdr.de>; Mon, 13 May 2019 21:54:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbfEMTyS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 May 2019 15:54:18 -0400
Received: from mga11.intel.com ([192.55.52.93]:3596 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725928AbfEMTyS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 May 2019 15:54:18 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 May 2019 12:54:17 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by orsmga006.jf.intel.com with ESMTP; 13 May 2019 12:54:17 -0700
Date:   Mon, 13 May 2019 12:54:17 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Liran Alon <liran.alon@oracle.com>
Subject: Re: [PATCH 3/3] KVM: LAPIC: Optimize timer latency further
Message-ID: <20190513195417.GM28561@linux.intel.com>
References: <1557401361-3828-1-git-send-email-wanpengli@tencent.com>
 <1557401361-3828-4-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1557401361-3828-4-git-send-email-wanpengli@tencent.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 09, 2019 at 07:29:21PM +0800, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> Advance lapic timer tries to hidden the hypervisor overhead between host 
> timer fires and the guest awares the timer is fired. However, it just hidden 
> the time between apic_timer_fn/handle_preemption_timer -> wait_lapic_expire, 
> instead of the real position of vmentry which is mentioned in the orignial 
> commit d0659d946be0 ("KVM: x86: add option to advance tscdeadline hrtimer 
> expiration"). There is 700+ cpu cycles between the end of wait_lapic_expire 
> and before world switch on my haswell desktop, it will be 2400+ cycles if 
> vmentry_l1d_flush is tuned to always. 
> 
> This patch tries to narrow the last gap, it measures the time between 
> the end of wait_lapic_expire and before world switch, we take this 
> time into consideration when busy waiting, otherwise, the guest still 
> awares the latency between wait_lapic_expire and world switch, we also 
> consider this when adaptively tuning the timer advancement. The patch 
> can reduce 50% latency (~1600+ cycles to ~800+ cycles on a haswell 
> desktop) for kvm-unit-tests/tscdeadline_latency when testing busy waits.
> 
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Radim Krčmář <rkrcmar@redhat.com>
> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> Cc: Liran Alon <liran.alon@oracle.com>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
>  arch/x86/kvm/lapic.c   | 23 +++++++++++++++++++++--
>  arch/x86/kvm/lapic.h   |  8 ++++++++
>  arch/x86/kvm/vmx/vmx.c |  2 ++
>  3 files changed, 31 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index e7a0660..01d3a87 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -1545,13 +1545,19 @@ void wait_lapic_expire(struct kvm_vcpu *vcpu)
>  
>  	tsc_deadline = apic->lapic_timer.expired_tscdeadline;
>  	apic->lapic_timer.expired_tscdeadline = 0;
> -	guest_tsc = kvm_read_l1_tsc(vcpu, rdtsc());
> +	guest_tsc = kvm_read_l1_tsc(vcpu, (apic->lapic_timer.measure_delay_done == 2) ?
> +		rdtsc() + apic->lapic_timer.vmentry_delay : rdtsc());
>  	trace_kvm_wait_lapic_expire(vcpu->vcpu_id, guest_tsc - tsc_deadline);
>  
>  	if (guest_tsc < tsc_deadline)
>  		__wait_lapic_expire(vcpu, tsc_deadline - guest_tsc);
>  
>  	adaptive_tune_timer_advancement(vcpu, guest_tsc, tsc_deadline);
> +
> +	if (!apic->lapic_timer.measure_delay_done) {
> +		apic->lapic_timer.measure_delay_done = 1;
> +		apic->lapic_timer.vmentry_delay = rdtsc();
> +	}
>  }
>  
>  static void start_sw_tscdeadline(struct kvm_lapic *apic)
> @@ -1837,6 +1843,18 @@ static void apic_manage_nmi_watchdog(struct kvm_lapic *apic, u32 lvt0_val)
>  	}
>  }
>  
> +void kvm_lapic_measure_vmentry_delay(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_timer *ktimer = &vcpu->arch.apic->lapic_timer;

This will #GP if the APIC is not in-kernel, i.e. @apic is NULL.

> +
> +	if (ktimer->measure_delay_done == 1) {
> +		ktimer->vmentry_delay = rdtsc() -
> +			ktimer->vmentry_delay;
> +		ktimer->measure_delay_done = 2;

Measuring the delay a single time is bound to result in random outliers,
e.g. if an NMI happens to occur after wait_lapic_expire().

Rather than reinvent the wheel, can we simply move the call to
wait_lapic_expire() into vmx.c and svm.c?  For VMX we'd probably want to
support the advancement if enable_unrestricted_guest=true so that we avoid
the emulation_required case, but other than that I don't see anything that
requires wait_lapic_expire() to be called where it is.

> +	}
> +}
> +EXPORT_SYMBOL_GPL(kvm_lapic_measure_vmentry_delay);
> +
>  int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
>  {
>  	int ret = 0;
> @@ -2318,7 +2336,8 @@ int kvm_create_lapic(struct kvm_vcpu *vcpu, int timer_advance_ns)
>  		apic->lapic_timer.timer_advance_ns = timer_advance_ns;
>  		apic->lapic_timer.timer_advance_adjust_done = true;
>  	}
> -
> +	apic->lapic_timer.vmentry_delay = 0;
> +	apic->lapic_timer.measure_delay_done = 0;
>  
>  	/*
>  	 * APIC is created enabled. This will prevent kvm_lapic_set_base from
> diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
> index d6d049b..f1d037b 100644
> --- a/arch/x86/kvm/lapic.h
> +++ b/arch/x86/kvm/lapic.h
> @@ -35,6 +35,13 @@ struct kvm_timer {
>  	atomic_t pending;			/* accumulated triggered timers */
>  	bool hv_timer_in_use;
>  	bool timer_advance_adjust_done;
> +	/**
> +	 * 0 unstart measure
> +	 * 1 start record
> +	 * 2 get delta
> +	 */
> +	u32 measure_delay_done;
> +	u64 vmentry_delay;
>  };
>  
>  struct kvm_lapic {
> @@ -230,6 +237,7 @@ void kvm_lapic_switch_to_hv_timer(struct kvm_vcpu *vcpu);
>  void kvm_lapic_expired_hv_timer(struct kvm_vcpu *vcpu);
>  bool kvm_lapic_hv_timer_in_use(struct kvm_vcpu *vcpu);
>  void kvm_lapic_restart_hv_timer(struct kvm_vcpu *vcpu);
> +void kvm_lapic_measure_vmentry_delay(struct kvm_vcpu *vcpu);
>  
>  static inline enum lapic_mode kvm_apic_mode(u64 apic_base)
>  {
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 9663d41..a939bf5 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6437,6 +6437,8 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
>  	if (vcpu->arch.cr2 != read_cr2())
>  		write_cr2(vcpu->arch.cr2);
>  
> +	kvm_lapic_measure_vmentry_delay(vcpu);

This should be wrapped in an unlikely of some form given that it happens
literally once out of thousands/millions runs.

> +
>  	vmx->fail = __vmx_vcpu_run(vmx, (unsigned long *)&vcpu->arch.regs,
>  				   vmx->loaded_vmcs->launched);
>  
> -- 
> 2.7.4
> 
