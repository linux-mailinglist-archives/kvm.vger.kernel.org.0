Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E69B0B40A4
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2019 20:55:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727962AbfIPSzx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Sep 2019 14:55:53 -0400
Received: from mga11.intel.com ([192.55.52.93]:17475 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725912AbfIPSzx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Sep 2019 14:55:53 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Sep 2019 11:55:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,513,1559545200"; 
   d="scan'208";a="187228691"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga007.fm.intel.com with ESMTP; 16 Sep 2019 11:55:51 -0700
Date:   Mon, 16 Sep 2019 11:55:51 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH v4] KVM: LAPIC: Tune lapic_timer_advance_ns smoothly
Message-ID: <20190916185551.GL18871@linux.intel.com>
References: <1568623199-5294-1-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1568623199-5294-1-git-send-email-wanpengli@tencent.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 16, 2019 at 04:39:59PM +0800, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> Filter out drastic fluctuation and random fluctuation, remove
> timer_advance_adjust_done altogether, the adjustment would be 
> continuous.
> 
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
>  arch/x86/kvm/lapic.c | 26 ++++++++++++--------------
>  arch/x86/kvm/lapic.h |  1 -
>  arch/x86/kvm/x86.c   |  2 +-
>  arch/x86/kvm/x86.h   |  1 +
>  4 files changed, 14 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index dbbe478..2585b86 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -69,6 +69,7 @@
>  #define LAPIC_TIMER_ADVANCE_ADJUST_INIT 1000
>  /* step-by-step approximation to mitigate fluctuation */
>  #define LAPIC_TIMER_ADVANCE_ADJUST_STEP 8
> +#define LAPIC_TIMER_ADVANCE_FILTER 5000
>  
>  static inline int apic_test_vector(int vec, void *bitmap)
>  {
> @@ -1482,29 +1483,28 @@ static inline void adjust_lapic_timer_advance(struct kvm_vcpu *vcpu,
>  					      s64 advance_expire_delta)
>  {
>  	struct kvm_lapic *apic = vcpu->arch.apic;
> -	u32 timer_advance_ns = apic->lapic_timer.timer_advance_ns;
> -	u64 ns;
> +	u32 timer_advance_ns = apic->lapic_timer.timer_advance_ns, ns;

Is changing 'ns' to a u32 intentionaly?  It's still cast to a u32 in the
calculations, and set from @advance_expire_delta.

> +
> +	if (abs(advance_expire_delta) > LAPIC_TIMER_ADVANCE_FILTER ||

Shouldn't LAPIC_TIMER_ADVANCE_FILTER be used in the other "if ... > 5000"
check?
	
	if (unlikely(timer_advance_ns > 5000))

And maybe name it LAPIC_TIMER_ADVANCE_MAX or something?

> +		abs(advance_expire_delta) < LAPIC_TIMER_ADVANCE_ADJUST_DONE) {

This should be aligned with the other 'abs', e.g.:

	if (abs(...) ||
	    abs(...))
		return

> +		/* filter out random fluctuations */

If you put the comment above the if statement then you can drop the
parentheses.  And if you're going to bother with a comment, maybe be a bit
more explicit?  E.g.:

	/* Do not adjust for tiny fluctuations or large random spikes. */
	if (abs(...) ||
	    abs(...))
		return;

> +		return;
> +	}
>  
>  	/* too early */
>  	if (advance_expire_delta < 0) {
>  		ns = -advance_expire_delta * 1000000ULL;
>  		do_div(ns, vcpu->arch.virtual_tsc_khz);
> -		timer_advance_ns -= min((u32)ns,
> -			timer_advance_ns / LAPIC_TIMER_ADVANCE_ADJUST_STEP);
> +		timer_advance_ns -= ns/LAPIC_TIMER_ADVANCE_ADJUST_STEP;
>  	} else {
>  	/* too late */
>  		ns = advance_expire_delta * 1000000ULL;
>  		do_div(ns, vcpu->arch.virtual_tsc_khz);
> -		timer_advance_ns += min((u32)ns,
> -			timer_advance_ns / LAPIC_TIMER_ADVANCE_ADJUST_STEP);
> +		timer_advance_ns += ns/LAPIC_TIMER_ADVANCE_ADJUST_STEP;
>  	}
>  
> -	if (abs(advance_expire_delta) < LAPIC_TIMER_ADVANCE_ADJUST_DONE)
> -		apic->lapic_timer.timer_advance_adjust_done = true;
> -	if (unlikely(timer_advance_ns > 5000)) {
> +	if (unlikely(timer_advance_ns > 5000))
>  		timer_advance_ns = LAPIC_TIMER_ADVANCE_ADJUST_INIT;
> -		apic->lapic_timer.timer_advance_adjust_done = false;
> -	}
>  	apic->lapic_timer.timer_advance_ns = timer_advance_ns;
>  }
>  
> @@ -1524,7 +1524,7 @@ static void __kvm_wait_lapic_expire(struct kvm_vcpu *vcpu)
>  	if (guest_tsc < tsc_deadline)
>  		__wait_lapic_expire(vcpu, tsc_deadline - guest_tsc);
>  
> -	if (unlikely(!apic->lapic_timer.timer_advance_adjust_done))
> +	if (lapic_timer_advance_ns == -1)

Rather than expose 'lapic_timer_advance_ns' from x86.c, what if we add a
'static bool dynamically_adjust_timer_advance __read_mostly;' in lapic.c,
and have that be set in kvm_create_lapic() and checked here?  That'd make
this code a little more readable, would make this patch more obvious (it
wasn't immediately clear why lapic_timer_advance_ns was being exposed),
and would reduce the probability of unintentionally writing/corrupting the
module param.

>  		adjust_lapic_timer_advance(vcpu, apic->lapic_timer.advance_expire_delta);
>  }
>  
> @@ -2302,10 +2302,8 @@ int kvm_create_lapic(struct kvm_vcpu *vcpu, int timer_advance_ns)
>  	apic->lapic_timer.timer.function = apic_timer_fn;
>  	if (timer_advance_ns == -1) {
>  		apic->lapic_timer.timer_advance_ns = LAPIC_TIMER_ADVANCE_ADJUST_INIT;
> -		apic->lapic_timer.timer_advance_adjust_done = false;
>  	} else {
>  		apic->lapic_timer.timer_advance_ns = timer_advance_ns;
> -		apic->lapic_timer.timer_advance_adjust_done = true;
>  	}

Parentheses can be dropped (unless this is converted to a local global, as
above).

> diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
> index 50053d2..2aad7e2 100644
> --- a/arch/x86/kvm/lapic.h
> +++ b/arch/x86/kvm/lapic.h
> @@ -35,7 +35,6 @@ struct kvm_timer {
>  	s64 advance_expire_delta;
>  	atomic_t pending;			/* accumulated triggered timers */
>  	bool hv_timer_in_use;
> -	bool timer_advance_adjust_done;
>  };
>  
>  struct kvm_lapic {
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 83288ba..bb4574c 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -141,7 +141,7 @@ module_param(tsc_tolerance_ppm, uint, S_IRUGO | S_IWUSR);
>   * advancement entirely.  Any other value is used as-is and disables adaptive
>   * tuning, i.e. allows priveleged userspace to set an exact advancement time.
>   */
> -static int __read_mostly lapic_timer_advance_ns = -1;
> +int __read_mostly lapic_timer_advance_ns = -1;
>  module_param(lapic_timer_advance_ns, int, S_IRUGO | S_IWUSR);
>  
>  static bool __read_mostly vector_hashing = true;
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index b5274e2..1bf2d82 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -301,6 +301,7 @@ extern unsigned int min_timer_period_us;
>  
>  extern bool enable_vmware_backdoor;
>  
> +extern int lapic_timer_advance_ns;
>  extern int pi_inject_timer;
>  
>  extern struct static_key kvm_no_apic_vcpu;
> -- 
> 2.7.4
> 
