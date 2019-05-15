Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C2A91F944
	for <lists+kvm@lfdr.de>; Wed, 15 May 2019 19:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726880AbfEORVe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 May 2019 13:21:34 -0400
Received: from mga02.intel.com ([134.134.136.20]:26526 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726124AbfEORVd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 May 2019 13:21:33 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 May 2019 10:21:33 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by fmsmga006.fm.intel.com with ESMTP; 15 May 2019 10:21:32 -0700
Date:   Wed, 15 May 2019 10:21:32 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Liran Alon <liran.alon@oracle.com>
Subject: Re: [PATCH v2 3/4] KVM: LAPIC: Expose per-vCPU timer adavance
 information to userspace
Message-ID: <20190515172132.GE5875@linux.intel.com>
References: <1557893514-5815-1-git-send-email-wanpengli@tencent.com>
 <1557893514-5815-4-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1557893514-5815-4-git-send-email-wanpengli@tencent.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 15, 2019 at 12:11:53PM +0800, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> Expose the per-vCPU advancement information to the user via per-vCPU debugfs 
> entry. wait_lapic_expire() call was moved above guest_enter_irqoff() because 
> of its tracepoint, which violated the RCU extended quiescent state invoked 
> by guest_enter_irqoff()[1][2]. This patch simply removes the tracepoint, 
> which would allow moving wait_lapic_expire(). Sean pointed out:
> 
> | Now that the advancement time is tracked per-vCPU, realizing a change 
> | in the advancement time requires creating a new VM. For all intents 
> | and purposes this makes it impractical to hand tune the advancement 
> | in real time using the tracepoint as the feedback mechanism.
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
>  arch/x86/kvm/debugfs.c | 16 ++++++++++++++++
>  arch/x86/kvm/lapic.c   | 16 ++++++++--------
>  arch/x86/kvm/lapic.h   |  1 +
>  arch/x86/kvm/trace.h   | 20 --------------------
>  4 files changed, 25 insertions(+), 28 deletions(-)
> 
> diff --git a/arch/x86/kvm/debugfs.c b/arch/x86/kvm/debugfs.c
> index c19c7ed..8cf542e 100644
> --- a/arch/x86/kvm/debugfs.c
> +++ b/arch/x86/kvm/debugfs.c
> @@ -9,12 +9,22 @@
>   */
>  #include <linux/kvm_host.h>
>  #include <linux/debugfs.h>
> +#include "lapic.h"
>  
>  bool kvm_arch_has_vcpu_debugfs(void)
>  {
>  	return true;
>  }
>  
> +static int vcpu_get_timer_expire_delta(void *data, u64 *val)
> +{
> +	struct kvm_vcpu *vcpu = (struct kvm_vcpu *) data;
> +	*val = vcpu->arch.apic->lapic_timer.advance_expire_delta;
> +	return 0;
> +}
> +
> +DEFINE_SIMPLE_ATTRIBUTE(vcpu_timer_expire_delta_fops, vcpu_get_timer_expire_delta, NULL, "%lld\n");
> +
>  static int vcpu_get_tsc_offset(void *data, u64 *val)
>  {
>  	struct kvm_vcpu *vcpu = (struct kvm_vcpu *) data;
> @@ -51,6 +61,12 @@ int kvm_arch_create_vcpu_debugfs(struct kvm_vcpu *vcpu)
>  	if (!ret)
>  		return -ENOMEM;
>  
> +	ret = debugfs_create_file("advance_expire_delta", 0444,
> +							vcpu->debugfs_dentry,
> +							vcpu, &vcpu_timer_expire_delta_fops);

I was thinking we would expose 'kvm_timer.timer_advance_ns', not the
delta, the idea being that being able to query the auto-adjusted value
is now the desired behavior.  But rethinking things, that enhancement is
orthogonal to removing the tracepoint.

Back to the tracepoint, an alternative solution would be to add
kvm_timer.advance_expire_delta as you did, but rather than add a new
debugfs entry, simply move the tracepoint below guest_exit_irqoff()
in vcpu_enter_guest().  I.e. snapshot the delta before VM-Enter, but
trace it after VM-Exit.

If we want to continue supporting hand tuning the advancement, then a
tracepoint is much easier for userspace to consume, e.g. it allows the
user to monitor the history of the delta while adjusting the advancement
time.  Manually approximating that behavior by sampling the value from
debugfs would be quite cumbersome.

> +	if (!ret)
> +		return -ENOMEM;
> +
>  	if (kvm_has_tsc_control) {
>  		ret = debugfs_create_file("tsc-scaling-ratio", 0444,
>  							vcpu->debugfs_dentry,
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
> diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
> index 4d47a26..3f9bc62 100644
> --- a/arch/x86/kvm/trace.h
> +++ b/arch/x86/kvm/trace.h
> @@ -953,26 +953,6 @@ TRACE_EVENT(kvm_pvclock_update,
>  		  __entry->flags)
>  );
>  
> -TRACE_EVENT(kvm_wait_lapic_expire,
> -	TP_PROTO(unsigned int vcpu_id, s64 delta),
> -	TP_ARGS(vcpu_id, delta),
> -
> -	TP_STRUCT__entry(
> -		__field(	unsigned int,	vcpu_id		)
> -		__field(	s64,		delta		)
> -	),
> -
> -	TP_fast_assign(
> -		__entry->vcpu_id	   = vcpu_id;
> -		__entry->delta             = delta;
> -	),
> -
> -	TP_printk("vcpu %u: delta %lld (%s)",
> -		  __entry->vcpu_id,
> -		  __entry->delta,
> -		  __entry->delta < 0 ? "early" : "late")
> -);
> -
>  TRACE_EVENT(kvm_enter_smm,
>  	TP_PROTO(unsigned int vcpu_id, u64 smbase, bool entering),
>  	TP_ARGS(vcpu_id, smbase, entering),
> -- 
> 2.7.4
> 
