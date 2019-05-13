Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F6F11BE1F
	for <lists+kvm@lfdr.de>; Mon, 13 May 2019 21:39:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbfEMTjl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 May 2019 15:39:41 -0400
Received: from mga06.intel.com ([134.134.136.31]:21263 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726554AbfEMTjl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 May 2019 15:39:41 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 May 2019 12:39:40 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by orsmga003.jf.intel.com with ESMTP; 13 May 2019 12:39:40 -0700
Date:   Mon, 13 May 2019 12:39:40 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Liran Alon <liran.alon@oracle.com>
Subject: Re: [PATCH 1/3] KVM: LAPIC: Extract adaptive tune timer advancement
 logic
Message-ID: <20190513193940.GL28561@linux.intel.com>
References: <1557401361-3828-1-git-send-email-wanpengli@tencent.com>
 <1557401361-3828-2-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1557401361-3828-2-git-send-email-wanpengli@tencent.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 09, 2019 at 07:29:19PM +0800, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> Extract adaptive tune timer advancement logic to a single function.

Why?

> 
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Radim Krčmář <rkrcmar@redhat.com>
> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> Cc: Liran Alon <liran.alon@oracle.com>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
>  arch/x86/kvm/lapic.c | 57 ++++++++++++++++++++++++++++++----------------------
>  1 file changed, 33 insertions(+), 24 deletions(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index bd13fdd..e7a0660 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -1501,11 +1501,41 @@ static inline void __wait_lapic_expire(struct kvm_vcpu *vcpu, u64 guest_cycles)
>  	}
>  }
>  
> -void wait_lapic_expire(struct kvm_vcpu *vcpu)
> +static inline void adaptive_tune_timer_advancement(struct kvm_vcpu *vcpu,
> +				u64 guest_tsc, u64 tsc_deadline)
>  {
>  	struct kvm_lapic *apic = vcpu->arch.apic;
>  	u32 timer_advance_ns = apic->lapic_timer.timer_advance_ns;
> -	u64 guest_tsc, tsc_deadline, ns;
> +	u64 ns;
> +
> +	if (!apic->lapic_timer.timer_advance_adjust_done) {
> +			/* too early */
> +			if (guest_tsc < tsc_deadline) {
> +				ns = (tsc_deadline - guest_tsc) * 1000000ULL;
> +				do_div(ns, vcpu->arch.virtual_tsc_khz);
> +				timer_advance_ns -= min((u32)ns,
> +					timer_advance_ns / LAPIC_TIMER_ADVANCE_ADJUST_STEP);
> +			} else {
> +			/* too late */
> +				ns = (guest_tsc - tsc_deadline) * 1000000ULL;
> +				do_div(ns, vcpu->arch.virtual_tsc_khz);
> +				timer_advance_ns += min((u32)ns,
> +					timer_advance_ns / LAPIC_TIMER_ADVANCE_ADJUST_STEP);
> +			}
> +			if (abs(guest_tsc - tsc_deadline) < LAPIC_TIMER_ADVANCE_ADJUST_DONE)
> +				apic->lapic_timer.timer_advance_adjust_done = true;
> +			if (unlikely(timer_advance_ns > 5000)) {
> +				timer_advance_ns = 0;
> +				apic->lapic_timer.timer_advance_adjust_done = true;
> +			}
> +			apic->lapic_timer.timer_advance_ns = timer_advance_ns;
> +		}

This whole block is indented too far.

> +}
> +
> +void wait_lapic_expire(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_lapic *apic = vcpu->arch.apic;
> +	u64 guest_tsc, tsc_deadline;
>  
>  	if (apic->lapic_timer.expired_tscdeadline == 0)
>  		return;
> @@ -1521,28 +1551,7 @@ void wait_lapic_expire(struct kvm_vcpu *vcpu)
>  	if (guest_tsc < tsc_deadline)
>  		__wait_lapic_expire(vcpu, tsc_deadline - guest_tsc);
>  
> -	if (!apic->lapic_timer.timer_advance_adjust_done) {
> -		/* too early */
> -		if (guest_tsc < tsc_deadline) {
> -			ns = (tsc_deadline - guest_tsc) * 1000000ULL;
> -			do_div(ns, vcpu->arch.virtual_tsc_khz);
> -			timer_advance_ns -= min((u32)ns,
> -				timer_advance_ns / LAPIC_TIMER_ADVANCE_ADJUST_STEP);
> -		} else {
> -		/* too late */
> -			ns = (guest_tsc - tsc_deadline) * 1000000ULL;
> -			do_div(ns, vcpu->arch.virtual_tsc_khz);
> -			timer_advance_ns += min((u32)ns,
> -				timer_advance_ns / LAPIC_TIMER_ADVANCE_ADJUST_STEP);
> -		}
> -		if (abs(guest_tsc - tsc_deadline) < LAPIC_TIMER_ADVANCE_ADJUST_DONE)
> -			apic->lapic_timer.timer_advance_adjust_done = true;
> -		if (unlikely(timer_advance_ns > 5000)) {
> -			timer_advance_ns = 0;
> -			apic->lapic_timer.timer_advance_adjust_done = true;
> -		}
> -		apic->lapic_timer.timer_advance_ns = timer_advance_ns;
> -	}
> +	adaptive_tune_timer_advancement(vcpu, guest_tsc, tsc_deadline);
>  }
>  
>  static void start_sw_tscdeadline(struct kvm_lapic *apic)
> -- 
> 2.7.4
> 
