Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 077951F973
	for <lists+kvm@lfdr.de>; Wed, 15 May 2019 19:43:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726796AbfEORmy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 May 2019 13:42:54 -0400
Received: from mga02.intel.com ([134.134.136.20]:27990 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726657AbfEORmx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 May 2019 13:42:53 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 May 2019 10:42:52 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by fmsmga007.fm.intel.com with ESMTP; 15 May 2019 10:42:52 -0700
Date:   Wed, 15 May 2019 10:42:51 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Liran Alon <liran.alon@oracle.com>
Subject: Re: [PATCH v2 4/4] KVM: LAPIC: Optimize timer latency further
Message-ID: <20190515174251.GF5875@linux.intel.com>
References: <1557893514-5815-1-git-send-email-wanpengli@tencent.com>
 <1557893514-5815-5-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1557893514-5815-5-git-send-email-wanpengli@tencent.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 15, 2019 at 12:11:54PM +0800, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> Advance lapic timer tries to hidden the hypervisor overhead between the 
> host emulated timer fires and the guest awares the timer is fired. However, 
> it just hidden the time between apic_timer_fn/handle_preemption_timer -> 
> wait_lapic_expire, instead of the real position of vmentry which is 
> mentioned in the orignial commit d0659d946be0 ("KVM: x86: add option to 
> advance tscdeadline hrtimer expiration"). There is 700+ cpu cycles between 
> the end of wait_lapic_expire and before world switch on my haswell desktop, 
> it will be 2400+ cycles if vmentry_l1d_flush is tuned to always. 
> 
> This patch tries to narrow the last gap(wait_lapic_expire -> world switch), 
> it takes the real overhead time between apic_timer_fn/handle_preemption_timer
> and before world switch into consideration when adaptively tuning timer 
> advancement. The patch can reduce 40% latency (~1600+ cycles to ~1000+ cycles 
> on a haswell desktop) for kvm-unit-tests/tscdeadline_latency when testing 
> busy waits.
> 
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Radim Krčmář <rkrcmar@redhat.com>
> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> Cc: Liran Alon <liran.alon@oracle.com>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
>  arch/x86/kvm/lapic.c   | 3 ++-
>  arch/x86/kvm/lapic.h   | 2 +-
>  arch/x86/kvm/svm.c     | 4 ++++
>  arch/x86/kvm/vmx/vmx.c | 4 ++++
>  arch/x86/kvm/x86.c     | 3 ---
>  5 files changed, 11 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index af38ece..63513de 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -1531,7 +1531,7 @@ static inline void adaptive_tune_timer_advancement(struct kvm_vcpu *vcpu,
>  	apic->lapic_timer.timer_advance_ns = timer_advance_ns;
>  }
>  
> -void wait_lapic_expire(struct kvm_vcpu *vcpu)
> +void kvm_wait_lapic_expire(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_lapic *apic = vcpu->arch.apic;
>  	u64 guest_tsc, tsc_deadline;
> @@ -1553,6 +1553,7 @@ void wait_lapic_expire(struct kvm_vcpu *vcpu)
>  	if (unlikely(!apic->lapic_timer.timer_advance_adjust_done))
>  		adaptive_tune_timer_advancement(vcpu, apic->lapic_timer.advance_expire_delta);
>  }
> +EXPORT_SYMBOL_GPL(kvm_wait_lapic_expire);
>  
>  static void start_sw_tscdeadline(struct kvm_lapic *apic)
>  {
> diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
> index 3e72a25..f974a3d 100644
> --- a/arch/x86/kvm/lapic.h
> +++ b/arch/x86/kvm/lapic.h
> @@ -220,7 +220,7 @@ static inline int kvm_lapic_latched_init(struct kvm_vcpu *vcpu)
>  
>  bool kvm_apic_pending_eoi(struct kvm_vcpu *vcpu, int vector);
>  
> -void wait_lapic_expire(struct kvm_vcpu *vcpu);
> +void kvm_wait_lapic_expire(struct kvm_vcpu *vcpu);
>  
>  bool kvm_intr_is_single_vcpu_fast(struct kvm *kvm, struct kvm_lapic_irq *irq,
>  			struct kvm_vcpu **dest_vcpu);
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 406b558..740fb3f 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -5646,6 +5646,10 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu)
>  	 */
>  	x86_spec_ctrl_set_guest(svm->spec_ctrl, svm->virt_spec_ctrl);
>  
> +	if (lapic_in_kernel(vcpu) &&
> +		vcpu->arch.apic->lapic_timer.timer_advance_ns)
> +		kvm_wait_lapic_expire(vcpu);
> +
>  	local_irq_enable();
>  
>  	asm volatile (
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 9663d41..1c49946 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6437,6 +6437,10 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
>  	if (vcpu->arch.cr2 != read_cr2())
>  		write_cr2(vcpu->arch.cr2);
>  
> +	if (lapic_in_kernel(vcpu) &&
> +		vcpu->arch.apic->lapic_timer.timer_advance_ns)
> +		kvm_wait_lapic_expire(vcpu);

One potential hiccup with this approach is that we're now accessing more
data after flushing the L1.  Not sure if that's actually a problem here,
but it probably should be explicitly addressed/considered.

> +
>  	vmx->fail = __vmx_vcpu_run(vmx, (unsigned long *)&vcpu->arch.regs,
>  				   vmx->loaded_vmcs->launched);
>  
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 1d89cb9..0eb9549 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -7894,9 +7894,6 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>  	}
>  
>  	trace_kvm_entry(vcpu->vcpu_id);
> -	if (lapic_in_kernel(vcpu) &&
> -	    vcpu->arch.apic->lapic_timer.timer_advance_ns)
> -		wait_lapic_expire(vcpu);
>  	guest_enter_irqoff();
>  
>  	fpregs_assert_state_consistent();
> -- 
> 2.7.4
> 
