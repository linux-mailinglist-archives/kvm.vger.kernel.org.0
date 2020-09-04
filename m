Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E96C625DF0C
	for <lists+kvm@lfdr.de>; Fri,  4 Sep 2020 18:06:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727990AbgIDQGQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Sep 2020 12:06:16 -0400
Received: from mga17.intel.com ([192.55.52.151]:40312 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727996AbgIDQGO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Sep 2020 12:06:14 -0400
IronPort-SDR: mNA65Rc6zvMCnXfR8SNC109C0oDOj6xWs4y9tevo7spgLqZA7wkR+n0JzMQegJWit2UkVt5qnX
 oSn0GROXDLvA==
X-IronPort-AV: E=McAfee;i="6000,8403,9734"; a="137823625"
X-IronPort-AV: E=Sophos;i="5.76,390,1592895600"; 
   d="scan'208";a="137823625"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2020 09:06:14 -0700
IronPort-SDR: Fgk+EDJnX2zD5D02DfcnKFc1J2YJBR/3LyrWm797boITeW63Kr6ncWBXYw8LKhg9ftOgHM8o9x
 bIKapkuUfN3A==
X-IronPort-AV: E=Sophos;i="5.76,390,1592895600"; 
   d="scan'208";a="284479234"
Received: from sjchrist-ice.jf.intel.com (HELO sjchrist-ice) ([10.54.31.34])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2020 09:06:11 -0700
Date:   Fri, 4 Sep 2020 09:06:10 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH] KVM: LAPIC: Reset timer_advance_ns if timer mode switch
Message-ID: <20200904160609.GD2206@sjchrist-ice>
References: <1598578508-14134-1-git-send-email-wanpengli@tencent.com>
 <20200902212328.GI11695@sjchrist-ice>
 <CANRm+CzQ00nFoYsxLQ7xhDaAnbi01U4BGkmuS9WLY80Nyt254w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANRm+CzQ00nFoYsxLQ7xhDaAnbi01U4BGkmuS9WLY80Nyt254w@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 03, 2020 at 06:57:00PM +0800, Wanpeng Li wrote:
> On Thu, 3 Sep 2020 at 05:23, Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> >
> > On Fri, Aug 28, 2020 at 09:35:08AM +0800, Wanpeng Li wrote:
> > > From: Wanpeng Li <wanpengli@tencent.com>
> > >
> > > per-vCPU timer_advance_ns should be set to 0 if timer mode is not tscdeadline
> > > otherwise we waste cpu cycles in the function lapic_timer_int_injected(),
> > > especially on AMD platform which doesn't support tscdeadline mode. We can
> > > reset timer_advance_ns to the initial value if switch back to tscdealine
> > > timer mode.
> > >
> > > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> > > ---
> > >  arch/x86/kvm/lapic.c | 6 ++++++
> > >  1 file changed, 6 insertions(+)
> > >
> > > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> > > index 654649b..abc296d 100644
> > > --- a/arch/x86/kvm/lapic.c
> > > +++ b/arch/x86/kvm/lapic.c
> > > @@ -1499,10 +1499,16 @@ static void apic_update_lvtt(struct kvm_lapic *apic)
> > >                       kvm_lapic_set_reg(apic, APIC_TMICT, 0);
> > >                       apic->lapic_timer.period = 0;
> > >                       apic->lapic_timer.tscdeadline = 0;
> > > +                     if (timer_mode == APIC_LVT_TIMER_TSCDEADLINE &&
> > > +                             lapic_timer_advance_dynamic)
> >
> > Bad indentation.
> >
> > > +                             apic->lapic_timer.timer_advance_ns = LAPIC_TIMER_ADVANCE_NS_INIT;
> >
> > Redoing the tuning seems odd.  Doubt it will matter, but it feels weird to
> > have to retune the advancement just because the guest toggled between modes.
> >
> > Rather than clear timer_advance_ns, can we simply move the check against
> > apic->lapic_timer.expired_tscdeadline much earlier?  I think that would
> > solve this performance hiccup, and IMO would be a logical change in any
> > case.  E.g. with some refactoring to avoid more duplication between VMX and
> > SVM
> 
> How about something like below:

That works too.  The only reason I used the inline shenanigans was to avoid
the CALL+RET in VM-Enter when the timer hasn't expired.

> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 3b32d3b..51ed4f0 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -1582,9 +1582,6 @@ static void __kvm_wait_lapic_expire(struct kvm_vcpu *vcpu)
>      struct kvm_lapic *apic = vcpu->arch.apic;
>      u64 guest_tsc, tsc_deadline;
> 
> -    if (apic->lapic_timer.expired_tscdeadline == 0)
> -        return;
> -
>      tsc_deadline = apic->lapic_timer.expired_tscdeadline;
>      apic->lapic_timer.expired_tscdeadline = 0;
>      guest_tsc = kvm_read_l1_tsc(vcpu, rdtsc());
> @@ -1599,7 +1596,10 @@ static void __kvm_wait_lapic_expire(struct
> kvm_vcpu *vcpu)
> 
>  void kvm_wait_lapic_expire(struct kvm_vcpu *vcpu)
>  {
> -    if (lapic_timer_int_injected(vcpu))
> +    if (lapic_in_kernel(vcpu) &&
> +        vcpu->arch.apic->lapic_timer.expired_tscdeadline &&
> +        vcpu->arch.apic->lapic_timer.timer_advance_ns &&
> +        lapic_timer_int_injected(vcpu))
>          __kvm_wait_lapic_expire(vcpu);
>  }
>  EXPORT_SYMBOL_GPL(kvm_wait_lapic_expire);
> @@ -1635,8 +1635,7 @@ static void apic_timer_expired(struct kvm_lapic
> *apic, bool from_timer_fn)
>      }
> 
>      if (kvm_use_posted_timer_interrupt(apic->vcpu)) {
> -        if (apic->lapic_timer.timer_advance_ns)
> -            __kvm_wait_lapic_expire(vcpu);
> +        kvm_wait_lapic_expire(vcpu);
>          kvm_apic_inject_pending_timer_irqs(apic);
>          return;
>      }
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 0194336..19e622a 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3456,9 +3456,7 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct
> kvm_vcpu *vcpu)
>      clgi();
>      kvm_load_guest_xsave_state(vcpu);
> 
> -    if (lapic_in_kernel(vcpu) &&
> -        vcpu->arch.apic->lapic_timer.timer_advance_ns)
> -        kvm_wait_lapic_expire(vcpu);
> +    kvm_wait_lapic_expire(vcpu);
> 
>      /*
>       * If this vCPU has touched SPEC_CTRL, restore the guest's value if
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index a544351..d6e1656 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6800,9 +6800,7 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
>      if (enable_preemption_timer)
>          vmx_update_hv_timer(vcpu);
> 
> -    if (lapic_in_kernel(vcpu) &&
> -        vcpu->arch.apic->lapic_timer.timer_advance_ns)
> -        kvm_wait_lapic_expire(vcpu);
> +    kvm_wait_lapic_expire(vcpu);
> 
>      /*
>       * If this vCPU has touched SPEC_CTRL, restore the guest's value if
