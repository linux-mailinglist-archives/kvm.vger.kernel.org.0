Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DA143C0E1
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2019 03:21:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390229AbfFKBVV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jun 2019 21:21:21 -0400
Received: from mga14.intel.com ([192.55.52.115]:2574 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388845AbfFKBVV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jun 2019 21:21:21 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Jun 2019 18:21:18 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by fmsmga006.fm.intel.com with ESMTP; 10 Jun 2019 18:21:18 -0700
Date:   Mon, 10 Jun 2019 18:21:18 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Subject: Re: [PATCH v2 1/2] KVM: LAPIC: Optimize timer latency consider world
 switch time
Message-ID: <20190611012118.GC24835@linux.intel.com>
References: <1559284814-20378-1-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1559284814-20378-1-git-send-email-wanpengli@tencent.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 31, 2019 at 02:40:13PM +0800, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> Advance lapic timer tries to hidden the hypervisor overhead between the
> host emulated timer fires and the guest awares the timer is fired. However,
> even though after more sustaining optimizations, kvm-unit-tests/tscdeadline_latency 
> still awares ~1000 cycles latency since we lost the time between the end of 
> wait_lapic_expire and the guest awares the timer is fired. There are 
> codes between the end of wait_lapic_expire and the world switch, furthermore, 
> the world switch itself also has overhead. Actually the guest_tsc is equal 
> to the target deadline time in wait_lapic_expire is too late, guest will
> aware the latency between the end of wait_lapic_expire() and after vmentry 
> to the guest. This patch takes this time into consideration. 
> 
> The vmentry_lapic_timer_advance_ns module parameter should be well tuned by 
> host admin, setting bit 0 to 1 to finally cache parameter in KVM. This patch 
> can reduce average cyclictest latency from 3us to 2us on Skylake server. 
> (guest w/ nohz=off, idle=poll, host w/ preemption_timer=N, the cyclictest 
> latency is not too sensitive when preemption_timer=Y for this optimization in 
> my testing), kvm-unit-tests/tscdeadline_latency can reach 0.
> 
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Radim Krčmář <rkrcmar@redhat.com>
> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
> NOTE: rebase on https://lkml.org/lkml/2019/5/20/449
> v1 -> v2:
>  * rename get_vmentry_advance_delta to get_vmentry_advance_cycles
>  * cache vmentry_advance_cycles by setting param bit 0 
>  * add param max limit 
> 
>  arch/x86/kvm/lapic.c   | 38 +++++++++++++++++++++++++++++++++++---
>  arch/x86/kvm/lapic.h   |  3 +++
>  arch/x86/kvm/vmx/vmx.c |  2 +-
>  arch/x86/kvm/x86.c     |  9 +++++++++
>  arch/x86/kvm/x86.h     |  2 ++
>  5 files changed, 50 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index fcf42a3..60587b5 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -1531,6 +1531,38 @@ static inline void adjust_lapic_timer_advance(struct kvm_vcpu *vcpu,
>  	apic->lapic_timer.timer_advance_ns = timer_advance_ns;
>  }
>  
> +#define MAX_VMENTRY_ADVANCE_NS 1000
> +
> +u64 compute_vmentry_advance_cycles(struct kvm_vcpu *vcpu)

This can be static, unless get_vmentry_advance_cycles() is moved to
lapic.h, in which case compute_vmentry_advance_cycles() would need to be
exported.

> +{
> +	u64 cycles;
> +	struct kvm_lapic *apic = vcpu->arch.apic;
> +	u64 val = min_t(u32, vmentry_lapic_timer_advance_ns, MAX_VMENTRY_ADVANCE_NS);
> +
> +	cycles = (val & ~1ULL) * vcpu->arch.virtual_tsc_khz;
> +	do_div(cycles, 1000000);
> +
> +	/* setting bit 0 locks the value, it is cached */
> +	if (val & 1)
> +		apic->lapic_timer.vmentry_advance_cycles = cycles;
> +
> +	return cycles;
> +}
> +
> +inline u64 get_vmentry_advance_cycles(struct kvm_vcpu *vcpu)

This shouldn't be 'inline' since it's exported from a C file.  That being
said, I think it's short enough to define as a 'static inline' in lapic.h.

> +{
> +	struct kvm_lapic *apic = vcpu->arch.apic;
> +
> +	if (!vmentry_lapic_timer_advance_ns)
> +		return 0;
> +
> +	if (likely(apic->lapic_timer.vmentry_advance_cycles))
> +		return apic->lapic_timer.vmentry_advance_cycles;
> +
> +	return compute_vmentry_advance_cycles(vcpu);
> +}
> +EXPORT_SYMBOL_GPL(get_vmentry_advance_cycles);
> +
>  void kvm_wait_lapic_expire(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_lapic *apic = vcpu->arch.apic;
> @@ -1544,7 +1576,7 @@ void kvm_wait_lapic_expire(struct kvm_vcpu *vcpu)
>  
>  	tsc_deadline = apic->lapic_timer.expired_tscdeadline;
>  	apic->lapic_timer.expired_tscdeadline = 0;
> -	guest_tsc = kvm_read_l1_tsc(vcpu, rdtsc());
> +	guest_tsc = kvm_read_l1_tsc(vcpu, rdtsc()) + get_vmentry_advance_cycles(vcpu);
>  	apic->lapic_timer.advance_expire_delta = guest_tsc - tsc_deadline;
>  
>  	if (guest_tsc < tsc_deadline)
> @@ -1572,7 +1604,7 @@ static void start_sw_tscdeadline(struct kvm_lapic *apic)
>  	local_irq_save(flags);
>  
>  	now = ktime_get();
> -	guest_tsc = kvm_read_l1_tsc(vcpu, rdtsc());
> +	guest_tsc = kvm_read_l1_tsc(vcpu, rdtsc()) + get_vmentry_advance_cycles(vcpu);
>  
>  	ns = (tscdeadline - guest_tsc) * 1000000ULL;
>  	do_div(ns, this_tsc_khz);
> @@ -2329,7 +2361,7 @@ int kvm_create_lapic(struct kvm_vcpu *vcpu, int timer_advance_ns)
>  		apic->lapic_timer.timer_advance_ns = timer_advance_ns;
>  		apic->lapic_timer.timer_advance_adjust_done = true;
>  	}
> -
> +	apic->lapic_timer.vmentry_advance_cycles = 0;
>  
>  	/*
>  	 * APIC is created enabled. This will prevent kvm_lapic_set_base from
> diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
> index f974a3d..70854a9 100644
> --- a/arch/x86/kvm/lapic.h
> +++ b/arch/x86/kvm/lapic.h
> @@ -33,6 +33,7 @@ struct kvm_timer {
>  	u64 expired_tscdeadline;
>  	u32 timer_advance_ns;
>  	s64 advance_expire_delta;
> +	u64 vmentry_advance_cycles;
>  	atomic_t pending;			/* accumulated triggered timers */
>  	bool hv_timer_in_use;
>  	bool timer_advance_adjust_done;
> @@ -221,6 +222,8 @@ static inline int kvm_lapic_latched_init(struct kvm_vcpu *vcpu)
>  bool kvm_apic_pending_eoi(struct kvm_vcpu *vcpu, int vector);
>  
>  void kvm_wait_lapic_expire(struct kvm_vcpu *vcpu);
> +u64 compute_vmentry_advance_cycles(struct kvm_vcpu *vcpu);
> +inline u64 get_vmentry_advance_cycles(struct kvm_vcpu *vcpu);
>  
>  bool kvm_intr_is_single_vcpu_fast(struct kvm *kvm, struct kvm_lapic_irq *irq,
>  			struct kvm_vcpu **dest_vcpu);
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index a341663..255b5d5 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7047,7 +7047,7 @@ static int vmx_set_hv_timer(struct kvm_vcpu *vcpu, u64 guest_deadline_tsc,
>  
>  	vmx = to_vmx(vcpu);
>  	tscl = rdtsc();
> -	guest_tscl = kvm_read_l1_tsc(vcpu, tscl);
> +	guest_tscl = kvm_read_l1_tsc(vcpu, tscl) + get_vmentry_advance_cycles(vcpu);
>  	delta_tsc = max(guest_deadline_tsc, guest_tscl) - guest_tscl;
>  	lapic_timer_advance_cycles = nsec_to_cycles(vcpu,
>  						    ktimer->timer_advance_ns);
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 69c3672e..0d4eb27 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -145,6 +145,13 @@ module_param(tsc_tolerance_ppm, uint, S_IRUGO | S_IWUSR);
>  static int __read_mostly lapic_timer_advance_ns = -1;
>  module_param(lapic_timer_advance_ns, int, S_IRUGO | S_IWUSR);
>  
> +/*
> + * lapic timer vmentry advance (tscdeadline mode only) in nanoseconds. Setting
> + * bit 0 to 1 after well manually tuning to cache vmentry advance time.
> + */
> +u32 __read_mostly vmentry_lapic_timer_advance_ns = 0;
> +module_param(vmentry_lapic_timer_advance_ns, uint, S_IRUGO | S_IWUSR);
> +
>  static bool __read_mostly vector_hashing = true;
>  module_param(vector_hashing, bool, S_IRUGO);
>  
> @@ -1592,6 +1599,8 @@ static int kvm_set_tsc_khz(struct kvm_vcpu *vcpu, u32 user_tsc_khz)
>  	kvm_get_time_scale(user_tsc_khz * 1000LL, NSEC_PER_SEC,
>  			   &vcpu->arch.virtual_tsc_shift,
>  			   &vcpu->arch.virtual_tsc_mult);
> +	if (vcpu->arch.apic && user_tsc_khz != vcpu->arch.virtual_tsc_khz)
> +		compute_vmentry_advance_cycles(vcpu);
>  	vcpu->arch.virtual_tsc_khz = user_tsc_khz;
>  
>  	/*
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
