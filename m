Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2ACF302E0
	for <lists+kvm@lfdr.de>; Thu, 30 May 2019 21:37:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726418AbfE3Tgz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 May 2019 15:36:55 -0400
Received: from mga11.intel.com ([192.55.52.93]:37241 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726307AbfE3Tgy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 May 2019 15:36:54 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 May 2019 12:36:53 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by orsmga001.jf.intel.com with ESMTP; 30 May 2019 12:36:53 -0700
Date:   Thu, 30 May 2019 12:36:53 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Subject: Re: [PATCH 1/2] KVM: LAPIC: Optimize timer latency consider world
 switch time
Message-ID: <20190530193653.GA27551@linux.intel.com>
References: <1558585131-1321-1-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1558585131-1321-1-git-send-email-wanpengli@tencent.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 23, 2019 at 12:18:50PM +0800, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> Advance lapic timer tries to hidden the hypervisor overhead between the
> host emulated timer fires and the guest awares the timer is fired. However,
> even though after more sustaining optimizations, kvm-unit-tests/tscdeadline_latency 
> still awares ~1000 cycles latency since we lost the time between the end of 
> wait_lapic_expire and the guest awares the timer is fired. There are 
> codes between the end of wait_lapic_expire and the world switch, futhermore, 
> the world switch itself also has overhead. Actually the guest_tsc is equal 
> to the target deadline time in wait_lapic_expire is too late, guest will
> aware the latency between the end of wait_lapic_expire() and after vmentry 
> to the guest. This patch takes this time into consideration. 
> 
> The vmentry_lapic_timer_advance_ns module parameter should be well tuned by 
> host admin, it can reduce average cyclictest latency from 3us to 2us on 
> Skylake server. (guest w/ nohz=off, idle=poll, host w/ preemption_timer=N, 
> the cyclictest latency is not too sensitive when preemption_timer=Y for this 
> optimization in my testing), kvm-unit-tests/tscdeadline_latency can reach 0.
> 
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Radim Krčmář <rkrcmar@redhat.com>
> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
>  arch/x86/kvm/lapic.c   | 17 +++++++++++++++--
>  arch/x86/kvm/lapic.h   |  1 +
>  arch/x86/kvm/vmx/vmx.c |  2 +-
>  arch/x86/kvm/x86.c     |  3 +++
>  arch/x86/kvm/x86.h     |  2 ++
>  5 files changed, 22 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index fcf42a3..6f85221 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -1531,6 +1531,19 @@ static inline void adjust_lapic_timer_advance(struct kvm_vcpu *vcpu,
>  	apic->lapic_timer.timer_advance_ns = timer_advance_ns;
>  }
>  
> +u64 get_vmentry_advance_delta(struct kvm_vcpu *vcpu)

Hmm, this isn't a delta, I think get_vmentry_advance_cycles would be more
appropriate.

> +{
> +	u64 vmentry_lapic_timer_advance_cycles = 0;
> +
> +	if (vmentry_lapic_timer_advance_ns) {
> +		vmentry_lapic_timer_advance_cycles = vmentry_lapic_timer_advance_ns *
> +			vcpu->arch.virtual_tsc_khz;
> +		do_div(vmentry_lapic_timer_advance_cycles, 1000000);
> +	}
> +	return vmentry_lapic_timer_advance_cycles;
> +}
> +EXPORT_SYMBOL_GPL(get_vmentry_advance_delta);
> +
>  void kvm_wait_lapic_expire(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_lapic *apic = vcpu->arch.apic;
> @@ -1544,7 +1557,7 @@ void kvm_wait_lapic_expire(struct kvm_vcpu *vcpu)
>  
>  	tsc_deadline = apic->lapic_timer.expired_tscdeadline;
>  	apic->lapic_timer.expired_tscdeadline = 0;
> -	guest_tsc = kvm_read_l1_tsc(vcpu, rdtsc());
> +	guest_tsc = kvm_read_l1_tsc(vcpu, rdtsc()) + get_vmentry_advance_delta(vcpu);
>  	apic->lapic_timer.advance_expire_delta = guest_tsc - tsc_deadline;
>  
>  	if (guest_tsc < tsc_deadline)
> @@ -1572,7 +1585,7 @@ static void start_sw_tscdeadline(struct kvm_lapic *apic)
>  	local_irq_save(flags);
>  
>  	now = ktime_get();
> -	guest_tsc = kvm_read_l1_tsc(vcpu, rdtsc());
> +	guest_tsc = kvm_read_l1_tsc(vcpu, rdtsc()) + get_vmentry_advance_delta(vcpu);
>  
>  	ns = (tscdeadline - guest_tsc) * 1000000ULL;
>  	do_div(ns, this_tsc_khz);
> diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
> index f974a3d..df2fe17 100644
> --- a/arch/x86/kvm/lapic.h
> +++ b/arch/x86/kvm/lapic.h
> @@ -221,6 +221,7 @@ static inline int kvm_lapic_latched_init(struct kvm_vcpu *vcpu)
>  bool kvm_apic_pending_eoi(struct kvm_vcpu *vcpu, int vector);
>  
>  void kvm_wait_lapic_expire(struct kvm_vcpu *vcpu);
> +u64 get_vmentry_advance_delta(struct kvm_vcpu *vcpu);
>  
>  bool kvm_intr_is_single_vcpu_fast(struct kvm *kvm, struct kvm_lapic_irq *irq,
>  			struct kvm_vcpu **dest_vcpu);
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index da24f18..0199ac3 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7047,7 +7047,7 @@ static int vmx_set_hv_timer(struct kvm_vcpu *vcpu, u64 guest_deadline_tsc,
>  
>  	vmx = to_vmx(vcpu);
>  	tscl = rdtsc();
> -	guest_tscl = kvm_read_l1_tsc(vcpu, tscl);
> +	guest_tscl = kvm_read_l1_tsc(vcpu, tscl) + get_vmentry_advance_delta(vcpu);
>  	delta_tsc = max(guest_deadline_tsc, guest_tscl) - guest_tscl;
>  	lapic_timer_advance_cycles = nsec_to_cycles(vcpu,
>  						    ktimer->timer_advance_ns);
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index a4eb711..a02e2c3 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -145,6 +145,9 @@ module_param(tsc_tolerance_ppm, uint, S_IRUGO | S_IWUSR);
>  static int __read_mostly lapic_timer_advance_ns = -1;
>  module_param(lapic_timer_advance_ns, int, S_IRUGO | S_IWUSR);
>  
> +u32 __read_mostly vmentry_lapic_timer_advance_ns = 0;
> +module_param(vmentry_lapic_timer_advance_ns, uint, S_IRUGO | S_IWUSR);

Hmm, an interesting idea would be to have some way to "lock" this param,
e.g. setting bit 0 locks the param.  That would allow KVM to calculate the
cycles value to avoid the function call and the MUL+DIV.  If I'm not
mistaken, vcpu->arch.virtual_tsc_khz is set only in kvm_set_tsc_khz().

For example, if get_vmentry_advance_cycles() sees the value is locked, it
caches the value in struct kvm_lapic.  The cached value would also need to
be updated in kvm_set_tsc_khz() if it has been set.

static inline u64 get_vmentry_advance_cycles(struct kvm_lapic *lapic)
{
        if (lapic->vmentry_advance_cycles)
                return lapic->vmentry_advance_cycles;

        return compute_vmentry_advance_cycles(lapic);
}

u64 compute_vmentry_advance_cycles(struct kvm_lapic *lapic)
{
        u64 val = vmentry_lapic_timer_advance_ns;
        u64 cycles = (val & ~1ULL) * lapic->vcpu->arch.virtual_tsc_khz;

        do_div(cycles, 1000000);

        if (val & 1)
                lapic->vmentry_advance_cycles = cycles;
        return cycles;
}

> +
>  static bool __read_mostly vector_hashing = true;
>  module_param(vector_hashing, bool, S_IRUGO);
>  
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index 275b3b6..b0a3b84 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -294,6 +294,8 @@ extern u64 kvm_supported_xcr0(void);
>  
>  extern unsigned int min_timer_period_us;
>  
> +extern unsigned int vmentry_lapic_timer_advance_ns;
> +
>  extern bool enable_vmware_backdoor;
>  
>  extern struct static_key kvm_no_apic_vcpu;
> -- 
> 2.7.4
> 
