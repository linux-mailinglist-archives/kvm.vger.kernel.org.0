Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE77721EBF
	for <lists+kvm@lfdr.de>; Fri, 17 May 2019 21:45:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728646AbfEQTow (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 May 2019 15:44:52 -0400
Received: from mga02.intel.com ([134.134.136.20]:49478 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726851AbfEQTov (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 May 2019 15:44:51 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 May 2019 12:44:51 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by orsmga007.jf.intel.com with ESMTP; 17 May 2019 12:44:50 -0700
Date:   Fri, 17 May 2019 12:44:50 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Liran Alon <liran.alon@oracle.com>
Subject: Re: [PATCH v3 4/5] KVM: LAPIC: Delay trace advance expire delta
Message-ID: <20190517194450.GH15006@linux.intel.com>
References: <1557975980-9875-1-git-send-email-wanpengli@tencent.com>
 <1557975980-9875-5-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1557975980-9875-5-git-send-email-wanpengli@tencent.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 16, 2019 at 11:06:19AM +0800, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> wait_lapic_expire() call was moved above guest_enter_irqoff() because of 
> its tracepoint, which violated the RCU extended quiescent state invoked 
> by guest_enter_irqoff()[1][2]. This patch simply moves the tracepoint 
> below guest_exit_irqoff() in vcpu_enter_guest(). Snapshot the delta before 
> VM-Enter, but trace it after VM-Exit. This can help us to move 
> wait_lapic_expire() just before vmentry in the later patch.
> 
> [1] Commit 8b89fe1f6c43 ("kvm: x86: move tracepoints outside extended quiescent state")
> [2] https://patchwork.kernel.org/patch/7821111/
> 
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Radim Krčmář <rkrcmar@redhat.com>
> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> Cc: Liran Alon <liran.alon@oracle.com>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
>  arch/x86/kvm/lapic.c | 16 ++++++++--------
>  arch/x86/kvm/lapic.h |  1 +
>  arch/x86/kvm/x86.c   |  2 ++
>  3 files changed, 11 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 2f364fe..af38ece 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -1502,27 +1502,27 @@ static inline void __wait_lapic_expire(struct kvm_vcpu *vcpu, u64 guest_cycles)
>  }
>  
>  static inline void adaptive_tune_timer_advancement(struct kvm_vcpu *vcpu,
> -				u64 guest_tsc, u64 tsc_deadline)
> +				s64 advance_expire_delta)
>  {
>  	struct kvm_lapic *apic = vcpu->arch.apic;
>  	u32 timer_advance_ns = apic->lapic_timer.timer_advance_ns;
>  	u64 ns;
>  
>  	/* too early */
> -	if (guest_tsc < tsc_deadline) {
> -		ns = (tsc_deadline - guest_tsc) * 1000000ULL;
> +	if (advance_expire_delta < 0) {
> +		ns = -advance_expire_delta * 1000000ULL;
>  		do_div(ns, vcpu->arch.virtual_tsc_khz);
>  		timer_advance_ns -= min((u32)ns,
>  			timer_advance_ns / LAPIC_TIMER_ADVANCE_ADJUST_STEP);
>  	} else {
>  	/* too late */
> -		ns = (guest_tsc - tsc_deadline) * 1000000ULL;
> +		ns = advance_expire_delta * 1000000ULL;
>  		do_div(ns, vcpu->arch.virtual_tsc_khz);
>  		timer_advance_ns += min((u32)ns,
>  			timer_advance_ns / LAPIC_TIMER_ADVANCE_ADJUST_STEP);
>  	}
>  
> -	if (abs(guest_tsc - tsc_deadline) < LAPIC_TIMER_ADVANCE_ADJUST_DONE)
> +	if (abs(advance_expire_delta) < LAPIC_TIMER_ADVANCE_ADJUST_DONE)
>  		apic->lapic_timer.timer_advance_adjust_done = true;
>  	if (unlikely(timer_advance_ns > 5000)) {
>  		timer_advance_ns = 0;
> @@ -1545,13 +1545,13 @@ void wait_lapic_expire(struct kvm_vcpu *vcpu)
>  	tsc_deadline = apic->lapic_timer.expired_tscdeadline;
>  	apic->lapic_timer.expired_tscdeadline = 0;
>  	guest_tsc = kvm_read_l1_tsc(vcpu, rdtsc());
> -	trace_kvm_wait_lapic_expire(vcpu->vcpu_id, guest_tsc - tsc_deadline);
> +	apic->lapic_timer.advance_expire_delta = guest_tsc - tsc_deadline;
>  
> -	if (guest_tsc < tsc_deadline)
> +	if (apic->lapic_timer.advance_expire_delta < 0)

I'd prefer to keep "guest_tsc < tsc_deadline" here, just so that it's
obvious that the call to __wait_lapic_expire() is safe.  My eyes did a
few double takes reading this code :-)

>  		__wait_lapic_expire(vcpu, tsc_deadline - guest_tsc);
>  
>  	if (unlikely(!apic->lapic_timer.timer_advance_adjust_done))
> -		adaptive_tune_timer_advancement(vcpu, guest_tsc, tsc_deadline);
> +		adaptive_tune_timer_advancement(vcpu, apic->lapic_timer.advance_expire_delta);
>  }
>  
>  static void start_sw_tscdeadline(struct kvm_lapic *apic)
> diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
> index d6d049b..3e72a25 100644
> --- a/arch/x86/kvm/lapic.h
> +++ b/arch/x86/kvm/lapic.h
> @@ -32,6 +32,7 @@ struct kvm_timer {
>  	u64 tscdeadline;
>  	u64 expired_tscdeadline;
>  	u32 timer_advance_ns;
> +	s64 advance_expire_delta;
>  	atomic_t pending;			/* accumulated triggered timers */
>  	bool hv_timer_in_use;
>  	bool timer_advance_adjust_done;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index f2e3847..4a7b00c 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -7961,6 +7961,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>  	++vcpu->stat.exits;
>  
>  	guest_exit_irqoff();
> +	trace_kvm_wait_lapic_expire(vcpu->vcpu_id,
> +		vcpu->arch.apic->lapic_timer.advance_expire_delta);

This needs to be guarded with lapic_in_kernel(vcpu).  But, since this is
all in the same flow, a better approach would be to return the delta from
wait_lapic_expire().  That saves 8 bytes in struct kvm_timer and avoids
additional checks for tracing the delta.

E.g.:

	s64 lapic_expire_delta;

	...

        if (lapic_in_kernel(vcpu) &&
            vcpu->arch.apic->lapic_timer.timer_advance_ns)
                lapic_expire_delta = wait_lapic_expire(vcpu);
	else
		lapic_expire_delta = 0;

	...
	
	trace_kvm_wait_lapic_expire(vcpu->vcpu_id, lapic_expire_delta);
>  
>  	local_irq_enable();
>  	preempt_enable();
> -- 
> 2.7.4
> 
