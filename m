Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF23625B5CC
	for <lists+kvm@lfdr.de>; Wed,  2 Sep 2020 23:23:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726377AbgIBVXa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Sep 2020 17:23:30 -0400
Received: from mga14.intel.com ([192.55.52.115]:26025 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726247AbgIBVXa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Sep 2020 17:23:30 -0400
IronPort-SDR: bFKwm0HqsozTi9yEWIIcaUaf8hGtDsPKgMx6054xeufmIldLs82COOA39JefObk0jpZBuU2oo0
 mqGoDn96LmxQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9732"; a="156750703"
X-IronPort-AV: E=Sophos;i="5.76,384,1592895600"; 
   d="scan'208";a="156750703"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2020 14:23:29 -0700
IronPort-SDR: h3njZEnVrM/G6HEsrezZGucyQlqHCyY+0jA1glmX9gPb7Uf4/vVFFRXKaMyk6t6tULMtXRHi3m
 pN1+8+OwSFVg==
X-IronPort-AV: E=Sophos;i="5.76,384,1592895600"; 
   d="scan'208";a="477798477"
Received: from sjchrist-ice.jf.intel.com (HELO sjchrist-ice) ([10.54.31.34])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2020 14:23:29 -0700
Date:   Wed, 2 Sep 2020 14:23:28 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH] KVM: LAPIC: Reset timer_advance_ns if timer mode switch
Message-ID: <20200902212328.GI11695@sjchrist-ice>
References: <1598578508-14134-1-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1598578508-14134-1-git-send-email-wanpengli@tencent.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 28, 2020 at 09:35:08AM +0800, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> per-vCPU timer_advance_ns should be set to 0 if timer mode is not tscdeadline 
> otherwise we waste cpu cycles in the function lapic_timer_int_injected(), 
> especially on AMD platform which doesn't support tscdeadline mode. We can 
> reset timer_advance_ns to the initial value if switch back to tscdealine 
> timer mode.
> 
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
>  arch/x86/kvm/lapic.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 654649b..abc296d 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -1499,10 +1499,16 @@ static void apic_update_lvtt(struct kvm_lapic *apic)
>  			kvm_lapic_set_reg(apic, APIC_TMICT, 0);
>  			apic->lapic_timer.period = 0;
>  			apic->lapic_timer.tscdeadline = 0;
> +			if (timer_mode == APIC_LVT_TIMER_TSCDEADLINE &&
> +				lapic_timer_advance_dynamic)

Bad indentation.

> +				apic->lapic_timer.timer_advance_ns = LAPIC_TIMER_ADVANCE_NS_INIT;

Redoing the tuning seems odd.  Doubt it will matter, but it feels weird to
have to retune the advancement just because the guest toggled between modes.

Rather than clear timer_advance_ns, can we simply move the check against
apic->lapic_timer.expired_tscdeadline much earlier?  I think that would
solve this performance hiccup, and IMO would be a logical change in any
case.  E.g. with some refactoring to avoid more duplication between VMX and
SVM:

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 35cca2e0c8026..54222f0071547 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1571,12 +1571,12 @@ static inline void adjust_lapic_timer_advance(struct kvm_vcpu *vcpu,
        apic->lapic_timer.timer_advance_ns = timer_advance_ns;
 }

-static void __kvm_wait_lapic_expire(struct kvm_vcpu *vcpu)
+void __kvm_wait_lapic_expire(struct kvm_vcpu *vcpu)
 {
        struct kvm_lapic *apic = vcpu->arch.apic;
        u64 guest_tsc, tsc_deadline;

-       if (apic->lapic_timer.expired_tscdeadline == 0)
+       if (!lapic_timer_int_injected(vcpu))
                return;

        tsc_deadline = apic->lapic_timer.expired_tscdeadline;
@@ -1590,13 +1590,7 @@ static void __kvm_wait_lapic_expire(struct kvm_vcpu *vcpu)
        if (lapic_timer_advance_dynamic)
                adjust_lapic_timer_advance(vcpu, apic->lapic_timer.advance_expire_delta);
 }
-
-void kvm_wait_lapic_expire(struct kvm_vcpu *vcpu)
-{
-       if (lapic_timer_int_injected(vcpu))
-               __kvm_wait_lapic_expire(vcpu);
-}
-EXPORT_SYMBOL_GPL(kvm_wait_lapic_expire);
+EXPORT_SYMBOL_GPL(__kvm_wait_lapic_expire);

 static void kvm_apic_inject_pending_timer_irqs(struct kvm_lapic *apic)
 {
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 754f29beb83e3..64be9d751196a 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -236,7 +236,14 @@ static inline int kvm_lapic_latched_init(struct kvm_vcpu *vcpu)

 bool kvm_apic_pending_eoi(struct kvm_vcpu *vcpu, int vector);

-void kvm_wait_lapic_expire(struct kvm_vcpu *vcpu);
+void __kvm_wait_lapic_expire(struct kvm_vcpu *vcpu);
+static inline void kvm_wait_lapic_expire(struct kvm_vcpu *vcpu)
+{
+       if (lapic_in_kernel(vcpu) &&
+           vcpu->arch.apic->lapic_timer.expired_tscdeadline &&
+           vcpu->arch.apic->lapic_timer.timer_advance_ns)
+               __kvm_wait_lapic_expire(vcpu);
+}

 void kvm_bitmap_or_dest_vcpus(struct kvm *kvm, struct kvm_lapic_irq *irq,
                              unsigned long *vcpu_bitmap);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index eee7edcbe7491..dfe505a7304a3 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3456,9 +3456,7 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
        clgi();
        kvm_load_guest_xsave_state(vcpu);

-       if (lapic_in_kernel(vcpu) &&
-               vcpu->arch.apic->lapic_timer.timer_advance_ns)
-               kvm_wait_lapic_expire(vcpu);
+       kvm_wait_lapic_expire(vcpu);

        /*
         * If this vCPU has touched SPEC_CTRL, restore the guest's value if


>  		}
>  		apic->lapic_timer.timer_mode = timer_mode;
>  		limit_periodic_timer_frequency(apic);
>  	}
> +	if (timer_mode != APIC_LVT_TIMER_TSCDEADLINE &&
> +		lapic_timer_advance_dynamic)

Bad indentation.

> +		apic->lapic_timer.timer_advance_ns = 0;
>  }
>  
>  /*
> -- 
> 2.7.4
> 
