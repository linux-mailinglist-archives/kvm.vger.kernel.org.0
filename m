Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89E377934B8
	for <lists+kvm@lfdr.de>; Wed,  6 Sep 2023 07:10:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236498AbjIFFKM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Sep 2023 01:10:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230103AbjIFFKL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Sep 2023 01:10:11 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1F6F1A1
        for <kvm@vger.kernel.org>; Tue,  5 Sep 2023 22:10:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1693977007; x=1725513007;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=NdsrAc2abhVobGm3h2+o5FIBYzm58IktUgl/aOTXN80=;
  b=IClMKo4eyEgmBAbceayy1WP4swXt6h+uHqCQLjlR6MCgxC2Q21Xy51Di
   0r9f0WRSnje+9I4UYzo0+yCpdw6h8Q3zL8a6BqS+x7Ld4IXiYmgJZ1X+3
   fLV4VuWQ9TyE5eQ1jBCcv2v/3uSgtdpTP2ZmsF0O7yAZSm/02vudlLJP3
   hnuB+3JrbakNr+sFyfpvOXu1BP3NeCKZ/Npv8ruRJRkuEJVslkmPmPtYN
   4E4GQCBq54lFqdpfdSBB3SIm3RmGF2F5IRoRr8vMFPooDGl79VO3DFp67
   ptN17ndJ98VX14OcpqTLVg2YKYzVNjB6aikd20m7mWvUXhl6W6S9qFEZ1
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10824"; a="367191906"
X-IronPort-AV: E=Sophos;i="6.02,231,1688454000"; 
   d="scan'208";a="367191906"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2023 22:10:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10824"; a="865016820"
X-IronPort-AV: E=Sophos;i="6.02,231,1688454000"; 
   d="scan'208";a="865016820"
Received: from linux.bj.intel.com ([10.238.157.71])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2023 22:10:05 -0700
Date:   Wed, 6 Sep 2023 13:07:25 +0800
From:   Tao Su <tao1.su@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, chao.gao@intel.com,
        guang.zeng@intel.com, yi1.lai@intel.com
Subject: Re: [PATCH 2/2] KVM: x86: Clear X2APIC_ICR_UNUSED_12 after
 APIC-write VM-exit
Message-ID: <ZPgJDacP1LeO084Z@linux.bj.intel.com>
References: <20230904013555.725413-1-tao1.su@linux.intel.com>
 <20230904013555.725413-3-tao1.su@linux.intel.com>
 <ZPezyAyVbdZSqhzk@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZPezyAyVbdZSqhzk@google.com>
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 05, 2023 at 04:03:36PM -0700, Sean Christopherson wrote:
> +Suravee
> 
> On Mon, Sep 04, 2023, Tao Su wrote:
> > When IPI virtualization is enabled, a WARN is triggered if bit12 of ICR
> > MSR is set after APIC-write VM-exit. The reason is kvm_apic_send_ipi()
> > thinks the APIC_ICR_BUSY bit should be cleared because KVM has no delay,
> > but kvm_apic_write_nodecode() doesn't clear the APIC_ICR_BUSY bit.
> > 
> > Since bit12 of ICR is no longer BUSY bit but UNUSED bit in x2APIC mode,
> > and SDM has no detail about how hardware will handle the UNUSED bit12
> > set, we tested on Intel CPU (SRF/GNR) with IPI virtualization and found
> > the UNUSED bit12 was also cleared by hardware without #GP. Therefore,
> > the clearing of bit12 should be still kept being consistent with the
> > hardware behavior.
> 
> I'm confused.  If hardware clears the bit, then why is it set in the vAPIC page
> after a trap-like APIC-write VM-Exit?  In other words, how is this not a ucode
> or hardware bug?

Sorry, I didn't describe it clearly.

On bare-metal, bit12 of ICR MSR will be cleared after setting this bit.

If bit12 is set in guest, the bit is not cleared in the vAPIC page after APIC-write
VM-Exit. So whether to clear bit12 in vAPIC page needs to be considered.

> 
> Suravee, can you confirm what happens on AMD with x2AVIC?  Does hardware *always*
> clear the busy bit if it's set by the guest?  If so, then we could "optimize"
> avic_incomplete_ipi_interception() to skip the busy check, e.g.
> 
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index cfc8ab773025..4bf0bb250147 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -513,7 +513,7 @@ int avic_incomplete_ipi_interception(struct kvm_vcpu *vcpu)
>                  * in which case KVM needs to emulate the ICR write as well in
>                  * order to clear the BUSY flag.
>                  */
> -               if (icrl & APIC_ICR_BUSY)
> +               if (!apic_x2apic_mode(apic) && (icrl & APIC_ICR_BUSY))
>                         kvm_apic_write_nodecode(vcpu, APIC_ICR);
>                 else
>                         kvm_apic_send_ipi(apic, icrl, icrh);
> 
> > Fixes: 5413bcba7ed5 ("KVM: x86: Add support for vICR APIC-write VM-Exits in x2APIC mode")
> > Signed-off-by: Tao Su <tao1.su@linux.intel.com>
> > Tested-by: Yi Lai <yi1.lai@intel.com>
> > ---
> >  arch/x86/kvm/lapic.c | 27 ++++++++++++++++++++-------
> >  1 file changed, 20 insertions(+), 7 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> > index a983a16163b1..09a376aeb4a0 100644
> > --- a/arch/x86/kvm/lapic.c
> > +++ b/arch/x86/kvm/lapic.c
> > @@ -1482,8 +1482,17 @@ void kvm_apic_send_ipi(struct kvm_lapic *apic, u32 icr_low, u32 icr_high)
> >  {
> >  	struct kvm_lapic_irq irq;
> >  
> > -	/* KVM has no delay and should always clear the BUSY/PENDING flag. */
> > -	WARN_ON_ONCE(icr_low & APIC_ICR_BUSY);
> > +	/*
> > +	 * In non-x2apic mode, KVM has no delay and should always clear the
> > +	 * BUSY/PENDING flag. In x2apic mode, KVM should clear the unused bit12
> > +	 * of ICR since hardware will also clear this bit. Although
> > +	 * APIC_ICR_BUSY and X2APIC_ICR_UNUSED_12 are same, they mean different
> > +	 * things in different modes.
> > +	 */
> > +	if (!apic_x2apic_mode(apic))
> > +		WARN_ON_ONCE(icr_low & APIC_ICR_BUSY);
> > +	else
> > +		WARN_ON_ONCE(icr_low & X2APIC_ICR_UNUSED_12);
> 
> NAK to the new name, KVM is absolutely not going to zero an arbitrary "unused"
> bit.  If Intel wants to reclaim bit 12 for something useful in the future, then
> Intel can ship CPUs that don't touch the "reserved" bit, and deal with all the
> fun of finding and updating all software that unnecessarily sets the busy bit in
> x2apic mode.
> 
> If we really want to pretend that Intel has more than a snowball's chance in hell
> of doing something useful with bit 12, then the right thing to do in KVM is to
> ignore the bit entirely and let the guest keep the pieces, e.g.

Yes, agree. Currently bit12 is unused and cleared by hardware on bare-metal, clearing
bit12 in guest is for keeping the same behavior as bare-metal. But KVM should not to
zero the unused bit until SDM reclaims it for something, so ignoring the bit in KVM
should be better.

Thanks,
Tao

> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 113ca9661ab2..36ec195a3339 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -1473,8 +1473,13 @@ void kvm_apic_send_ipi(struct kvm_lapic *apic, u32 icr_low, u32 icr_high)
>  {
>         struct kvm_lapic_irq irq;
>  
> -       /* KVM has no delay and should always clear the BUSY/PENDING flag. */
> -       WARN_ON_ONCE(icr_low & APIC_ICR_BUSY);
> +       /*
> +        * KVM has no delay and should always clear the BUSY/PENDING flag.
> +        * The flag doesn't exist in x2APIC mode; both the SDM and APM state
> +        * that the flag "Must Be Zero", but neither Intel nor AMD enforces
> +        * that (or any other reserved bits in ICR).
> +        */
> +       WARN_ON_ONCE(!apic_x2apic_mode(apic) && (icr_low & APIC_ICR_BUSY));
>  
>         irq.vector = icr_low & APIC_VECTOR_MASK;
>         irq.delivery_mode = icr_low & APIC_MODE_MASK;
> @@ -3113,8 +3118,6 @@ int kvm_lapic_set_vapic_addr(struct kvm_vcpu *vcpu, gpa_t vapic_addr)
>  
>  int kvm_x2apic_icr_write(struct kvm_lapic *apic, u64 data)
>  {
> -       data &= ~APIC_ICR_BUSY;
> -
>         kvm_apic_send_ipi(apic, (u32)data, (u32)(data >> 32));
>         kvm_lapic_set_reg64(apic, APIC_ICR, data);
>         trace_kvm_apic_write(APIC_ICR, data);
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index cfc8ab773025..4bf0bb250147 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -513,7 +513,7 @@ int avic_incomplete_ipi_interception(struct kvm_vcpu *vcpu)
>                  * in which case KVM needs to emulate the ICR write as well in
>                  * order to clear the BUSY flag.
>                  */
> -               if (icrl & APIC_ICR_BUSY)
> +               if (!apic_x2apic_mode(apic) && (icrl & APIC_ICR_BUSY))
>                         kvm_apic_write_nodecode(vcpu, APIC_ICR);
>                 else
>                         kvm_apic_send_ipi(apic, icrl, icrh);
> 
