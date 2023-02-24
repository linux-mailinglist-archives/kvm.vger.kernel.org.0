Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4089D6A1D90
	for <lists+kvm@lfdr.de>; Fri, 24 Feb 2023 15:39:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbjBXOjW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Feb 2023 09:39:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbjBXOjV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Feb 2023 09:39:21 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A1CA6798D
        for <kvm@vger.kernel.org>; Fri, 24 Feb 2023 06:38:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677249508;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uUT3ZoP+nR5P8J/41llFFURCv2g6qnQLMmn9WLGJ50k=;
        b=OQPl/AVRDZgFHSWpkMb96ZimbtIlRH71FHSkgCMUAv3+IpEuVZ7c4LDPxjAUdWndU8T/YH
        JN1d9mzuDpPGJHMNfgzAo8Z8xuY51uUx2D9T0x7rVttFp+/Qys4uF6tICnEZCGYNy5skFA
        XIRfz2/H6c+ARBFzlvW1myjfj7XGyr0=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-8-Q501zcU3Nt6v1kxe2APAsw-1; Fri, 24 Feb 2023 09:38:27 -0500
X-MC-Unique: Q501zcU3Nt6v1kxe2APAsw-1
Received: by mail-wm1-f71.google.com with SMTP id j6-20020a05600c1c0600b003eaf882cb85so1008457wms.9
        for <kvm@vger.kernel.org>; Fri, 24 Feb 2023 06:38:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uUT3ZoP+nR5P8J/41llFFURCv2g6qnQLMmn9WLGJ50k=;
        b=XiqEy1F/LGMjs4iOOUTds1i9vQxUipTl9c4BNlemHCue6pceESCoY8Ls9xJ5gwzqnc
         Gc9UHkqHCXwq05Bm5gWJItxPACbOrBu2qeE/XM9G0i31J2OrMtGn5Yr9X2JMypt76b2D
         LlWlz5MTAleB0TgkSU0TXoEZtKVRq2Q7aZHNuZesnt+PtC4iNPd+5bNuTUis72KSZ6+R
         XG/j5Hs81wxERQD7XJQsh402O+ACZEIIQN4AgmExKQgaPNwo4KbM7SCd/00HaKYXdldB
         nSHI8LO+dEwPlKSB+01OTLO619gL6jrM3gSkeRYhQpahMZAdPt2ykPBVwy2geNVuIki+
         0gww==
X-Gm-Message-State: AO0yUKUemsmuHjbE+OF3tiPSQuzIcJNST/oponchMzmBJTG8c2hgZLg7
        DPzI0tqfaIKQzbx/az4K6T2WtMmQW4I1ruR4WlKPQjqHcQQikqcIvgfWJN76pV0ILN41ql2DiV3
        acXY2LFDTjpsB
X-Received: by 2002:adf:fcd2:0:b0:2c5:46f1:bdb2 with SMTP id f18-20020adffcd2000000b002c546f1bdb2mr14412656wrs.14.1677249505849;
        Fri, 24 Feb 2023 06:38:25 -0800 (PST)
X-Google-Smtp-Source: AK7set9H9dkoFP8mb7SR0xPNZlZrvMMzI9xotlLYFtImiwzTHV8+EN02Vrt/9J50kgD8NmPf5vQShw==
X-Received: by 2002:adf:fcd2:0:b0:2c5:46f1:bdb2 with SMTP id f18-20020adffcd2000000b002c546f1bdb2mr14412622wrs.14.1677249505498;
        Fri, 24 Feb 2023 06:38:25 -0800 (PST)
Received: from starship ([89.237.96.70])
        by smtp.gmail.com with ESMTPSA id v15-20020adfedcf000000b002c70ce264bfsm7075023wro.76.2023.02.24.06.38.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Feb 2023 06:38:25 -0800 (PST)
Message-ID: <3ad0d6fdd65a90150358c62161e392736f55a1b4.camel@redhat.com>
Subject: Re: [PATCH v2 02/11] KVM: nSVM: clean up the copying of V_INTR bits
 from vmcb02 to vmcb12
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Sandipan Das <sandipan.das@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Jiaxi Chen <jiaxi.chen@linux.intel.com>,
        Babu Moger <babu.moger@amd.com>, linux-kernel@vger.kernel.org,
        Jing Liu <jing2.liu@intel.com>,
        Wyes Karny <wyes.karny@amd.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Date:   Fri, 24 Feb 2023 16:38:22 +0200
In-Reply-To: <Y9hybI65So5X2LFg@google.com>
References: <20221129193717.513824-1-mlevitsk@redhat.com>
         <20221129193717.513824-3-mlevitsk@redhat.com> <Y9RuQz8dAT7DZGYk@google.com>
         <Y9hybI65So5X2LFg@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2023-01-31 at 01:44 +0000, Sean Christopherson wrote:
> On Sat, Jan 28, 2023, Sean Christopherson wrote:
> > On Tue, Nov 29, 2022, Maxim Levitsky wrote:
> > > the V_IRQ and v_TPR bits don't exist when virtual interrupt
> > > masking is not enabled, therefore the KVM should not copy these
> > > bits regardless of V_IRQ intercept.
> > 
> > Hmm, the APM disagrees:

Yes, my apologies, after re-reading the APM I agree with you.


> > 
> >  The APIC's TPR always controls the task priority for physical interrupts, and the
> >  V_TPR always controls virtual interrupts.
> > 
> >    While running a guest with V_INTR_MASKING cleared to 0:
> >      • Writes to CR8 affect both the APIC's TPR and the V_TPR register.
> > 
> > 
> >  ...
> > 
> >  The three VMCB fields V_IRQ, V_INTR_PRIO, and V_INTR_VECTOR indicate whether there
> >  is a virtual interrupt pending, and, if so, what its vector number and priority are.
> > 
> > IIUC, V_INTR_MASKING_MASK is mostly about EFLAGS.IF, with a small side effect on
> > TPR.  E.g. a VMM could pend a V_IRQ but clear V_INTR_MASKING and expect the guest
> > to take the V_IRQ.  At least, that's my reading of things.

Yes, this is how I understand it as well.


> > 
> > > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > > ---
> > >  arch/x86/kvm/svm/nested.c | 23 ++++++++---------------
> > >  1 file changed, 8 insertions(+), 15 deletions(-)
> > > 
> > > diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> > > index 37af0338da7c32..aad3145b2f62fe 100644
> > > --- a/arch/x86/kvm/svm/nested.c
> > > +++ b/arch/x86/kvm/svm/nested.c
> > > @@ -412,24 +412,17 @@ void nested_copy_vmcb_save_to_cache(struct vcpu_svm *svm,
> > >   */
> > >  void nested_sync_control_from_vmcb02(struct vcpu_svm *svm)
> > >  {
> > > -	u32 mask;
> > > +	u32 mask = 0;
> > >  	svm->nested.ctl.event_inj      = svm->vmcb->control.event_inj;
> > >  	svm->nested.ctl.event_inj_err  = svm->vmcb->control.event_inj_err;
> > >  
> > > -	/* Only a few fields of int_ctl are written by the processor.  */
> > > -	mask = V_IRQ_MASK | V_TPR_MASK;
> > > -	if (!(svm->nested.ctl.int_ctl & V_INTR_MASKING_MASK) &&
> > > -	    svm_is_intercept(svm, INTERCEPT_VINTR)) {
> > > -		/*
> > > -		 * In order to request an interrupt window, L0 is usurping
> > > -		 * svm->vmcb->control.int_ctl and possibly setting V_IRQ
> > > -		 * even if it was clear in L1's VMCB.  Restoring it would be
> > > -		 * wrong.  However, in this case V_IRQ will remain true until
> > > -		 * interrupt_window_interception calls svm_clear_vintr and
> > > -		 * restores int_ctl.  We can just leave it aside.
> > > -		 */
> > > -		mask &= ~V_IRQ_MASK;
> 
> Argh! *shakes fist at KVM and SVM*
> 
> This is ridiculously convoluted, and I'm pretty sure there are existing bugs.  If
> L1 runs L2 with V_IRQ=1 and V_INTR_MASKING=1


Note that there are two cases when we need an interrupt window in nested case:

- If the L1 doesn't intercept interrupts, which is what we are taking about here.
- If the L1 does intercept interrupts, but let L2 control the L1's EFLAGS.IF and/or
  L1's GIF 
  (that is V_INTR_MASKING_MASK is not set, and/or L1 doesn't intercept STGI/CLGI).

  In this case a 'real' interrupt will be converted to a VM exit but only
  when both L1's EFLAGS.IF is true and L1's GIF is true.



> , and KVM requests an interrupt window,
> then KVM will overwrite vmcb02's int_vector and int_ctl, i.e. clobber L1's V_IRQ,
> but then silently clear INTERCEPT_VINTR in recalc_intercepts() and thus prevent
> svm_clear_vintr() from being reached, i.e. prevent restoring L1's V_IRQ.


> 
> Bug #1 is that KVM shouldn't clobber the V_IRQ fields if KVM ultimately decides
> not to open an interrupt window.  Bug #2 is that KVM needs to open an interrupt
> window if save.RFLAGS.IF=1, as interrupts may become unblocked in that case,
> e.g. if L2 is in an interrupt shadow.


> 
> So I think this over two patches?
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 05d38944a6c0..ad1e70ac8669 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -139,13 +139,18 @@ void recalc_intercepts(struct vcpu_svm *svm)
>  
>         if (g->int_ctl & V_INTR_MASKING_MASK) {
>                 /*
> -                * Once running L2 with HF_VINTR_MASK, EFLAGS.IF and CR8
> -                * does not affect any interrupt we may want to inject;
> -                * therefore, writes to CR8 are irrelevant to L0, as are
> -                * interrupt window vmexits.
> +                * If L2 is active and V_INTR_MASKING is enabled in vmcb12,
> +                * disable intercept of CR8 writes as L2's CR8 does not affect
> +                * any interrupt KVM may want to inject.
> +                *
> +                * Similarly, disable intercept of virtual interrupts (used to
> +                * detect interrupt windows) if the saved RFLAGS.IF is '0', as
> +                * the effective RFLAGS.IF for L1 interrupts will never be set
> +                * while L2 is running (L2's RFLAGS.IF doesn't affect L1 IRQs).
>                  */
>                 vmcb_clr_intercept(c, INTERCEPT_CR8_WRITE);
> -               vmcb_clr_intercept(c, INTERCEPT_VINTR);
> +               if (!(svm->vmcb01.ptr->save.rflags & X86_EFLAGS_IF))
> +                       vmcb_clr_intercept(c, INTERCEPT_VINTR);

How about instead moving this code to svm_set_vintr?

That is, in the guest mode, if the guest has V_INTR_MASKING_MASK, then
then a nested VM exit is the next point the interrupt window could open,
thus we don't set VINTR)

Or even better put the logic in svm_enable_irq_window (that is avoid
calling svm_set_vintr in the first place).

I also think that it worth it to add a warning that 'svm_set_intercept'
didn't work, that is didn't really set an intercept. 
In theory that can result in nasty CVEs in addition to logic bugs as you found.


>         }
>  
>         /*
> @@ -416,18 +421,18 @@ void nested_sync_control_from_vmcb02(struct vcpu_svm *svm)
>  
>         /* Only a few fields of int_ctl are written by the processor.  */
>         mask = V_IRQ_MASK | V_TPR_MASK;
> -       if (!(svm->nested.ctl.int_ctl & V_INTR_MASKING_MASK) &&
> -           svm_is_intercept(svm, INTERCEPT_VINTR)) {
> -               /*
> -                * In order to request an interrupt window, L0 is usurping
> -                * svm->vmcb->control.int_ctl and possibly setting V_IRQ
> -                * even if it was clear in L1's VMCB.  Restoring it would be
> -                * wrong.  However, in this case V_IRQ will remain true until
> -                * interrupt_window_interception calls svm_clear_vintr and
> -                * restores int_ctl.  We can just leave it aside.
> -                */
> +
> +       /*
> +        * Don't sync vmcb02 V_IRQ back to vmcb12 if KVM (L0) is intercepting
> +        * virtual interrupts in order to request an interrupt window, as KVM
> +        * has usurped vmcb02's int_ctl.  If an interrupt window opens before
> +        * the next VM-Exit, svm_clear_vintr() will restore vmcb12's int_ctl.
> +        * If no window opens, V_IRQ will be correctly preserved in vmcb12's
> +        * int_ctl (because it was never recognized while L2 was running).
> +        */
> +       if (svm_is_intercept(svm, INTERCEPT_VINTR) &&
> +           !test_bit(INTERCEPT_VINTR, (unsigned long *)svm->nested.ctl.intercepts))
>                 mask &= ~V_IRQ_MASK;

This makes sense.



> -       }
>  
>         if (nested_vgif_enabled(svm))
>                 mask |= V_GIF_MASK;
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index b103fe7cbc82..59d2891662ef 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1580,6 +1580,16 @@ static void svm_set_vintr(struct vcpu_svm *svm)
>  
>         svm_set_intercept(svm, INTERCEPT_VINTR);
>  
> +       /*
> +        * Recalculating intercepts may have clear the VINTR intercept.  If
> +        * V_INTR_MASKING is enabled in vmcb12, then the effective RFLAGS.IF
> +        * for L1 physical interrupts is L1's RFLAGS.IF at the time of VMRUN.
> +        * Requesting an interrupt window if save.RFLAGS.IF=0 is pointless as
> +        * interrupts will never be unblocked while L2 is running.
> +        */
> +       if (!svm_is_intercept(svm, INTERCEPT_VINTR))
> +               return;

This won't be needed if we don't call the svm_set_vintr in the first place.

> +
>         /*
>          * This is just a dummy VINTR to actually cause a vmexit to happen.
>          * Actual injection of virtual interrupts happens through EVENTINJ.
> 



With all this said, I also want to note that this patch has *nothing* to do with VNMI,
I only added it due to some refactoring, so feel free to drop it from vNMI queue,
and deal with those bugs separately.

Best regards,
	Maxim Levitsky


