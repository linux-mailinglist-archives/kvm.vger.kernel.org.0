Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9617E24E4FC
	for <lists+kvm@lfdr.de>; Sat, 22 Aug 2020 06:03:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725856AbgHVEBQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 22 Aug 2020 00:01:16 -0400
Received: from mga17.intel.com ([192.55.52.151]:41402 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725300AbgHVEBQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 22 Aug 2020 00:01:16 -0400
IronPort-SDR: yUu/cx37u8efnEV/L08bDndAWiX+xQj219NXoVRS8CBOOpm1bZC7pNK4mGaVRURiRsmNtvwSwe
 oqT6Wm/8Asfg==
X-IronPort-AV: E=McAfee;i="6000,8403,9720"; a="135742831"
X-IronPort-AV: E=Sophos;i="5.76,339,1592895600"; 
   d="scan'208";a="135742831"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2020 21:01:15 -0700
IronPort-SDR: az/BSV7RSyZiBINLupZ52ug5lb0TI9qqa2rKE/pCL8zqRRJ579VSDUbWOtN+3nvF/BVZOPCYbT
 zlOpPpkOZn0w==
X-IronPort-AV: E=Sophos;i="5.76,339,1592895600"; 
   d="scan'208";a="498728955"
Received: from sjchrist-ice.jf.intel.com (HELO sjchrist-ice) ([10.54.31.34])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2020 21:01:15 -0700
Date:   Fri, 21 Aug 2020 21:01:14 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH] KVM: LAPIC: Don't kick vCPU which is injecting
 already-expired timer
Message-ID: <20200822040114.GF4769@sjchrist-ice>
References: <1598001454-11709-1-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1598001454-11709-1-git-send-email-wanpengli@tencent.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 21, 2020 at 05:17:34PM +0800, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> The kick after setting KVM_REQ_PENDING_TIMER is used to handle the timer 
> fires on a different pCPU which vCPU is running on, we don't need this 
> kick when injecting already-expired timer, this kick is expensive since 
> memory barrier, rcu, preemption disable/enable operations. This patch 
> reduces the overhead by don't kick vCPU which is injecting already-expired 
> timer.

This should also call out the VMX preemption timer case, which also passes
from_timer_fn=false but doesn't need a kick because kvm_lapic_expired_hv_timer()
is called from the target vCPU.
 
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
>  arch/x86/kvm/lapic.c | 2 +-
>  arch/x86/kvm/x86.c   | 5 +++--
>  arch/x86/kvm/x86.h   | 2 +-
>  3 files changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 248095a..5b5ae66 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -1642,7 +1642,7 @@ static void apic_timer_expired(struct kvm_lapic *apic, bool from_timer_fn)
>  	}
>  
>  	atomic_inc(&apic->lapic_timer.pending);
> -	kvm_set_pending_timer(vcpu);
> +	kvm_set_pending_timer(vcpu, from_timer_fn);

My vote would be to open code kvm_set_pending_timer() here and drop the
helper, i.e.

	kvm_make_request(KVM_REQ_PENDING_TIMER, vcpu);
	if (from_timer_fn)
		kvm_vcpu_kick(vcpu);

with that and an updated changelog:

Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>

>  }
>  
>  static void start_sw_tscdeadline(struct kvm_lapic *apic)
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 599d732..2a45405 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1778,10 +1778,11 @@ static s64 get_kvmclock_base_ns(void)
>  }
>  #endif
>  
> -void kvm_set_pending_timer(struct kvm_vcpu *vcpu)
> +void kvm_set_pending_timer(struct kvm_vcpu *vcpu, bool should_kick)
>  {
>  	kvm_make_request(KVM_REQ_PENDING_TIMER, vcpu);
> -	kvm_vcpu_kick(vcpu);
> +	if (should_kick)
> +		kvm_vcpu_kick(vcpu);
>  }
>  
>  static void kvm_write_wall_clock(struct kvm *kvm, gpa_t wall_clock)
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index 995ab69..0eaae9c 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -246,7 +246,7 @@ static inline bool kvm_vcpu_latch_init(struct kvm_vcpu *vcpu)
>  	return is_smm(vcpu) || kvm_x86_ops.apic_init_signal_blocked(vcpu);
>  }
>  
> -void kvm_set_pending_timer(struct kvm_vcpu *vcpu);
> +void kvm_set_pending_timer(struct kvm_vcpu *vcpu, bool should_kick);
>  void kvm_inject_realmode_interrupt(struct kvm_vcpu *vcpu, int irq, int inc_eip);
>  
>  void kvm_write_tsc(struct kvm_vcpu *vcpu, struct msr_data *msr);
> -- 
> 2.7.4
> 
