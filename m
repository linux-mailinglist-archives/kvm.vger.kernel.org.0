Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E1B5632257
	for <lists+kvm@lfdr.de>; Mon, 21 Nov 2022 13:37:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230503AbiKUMhh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Nov 2022 07:37:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231355AbiKUMhf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Nov 2022 07:37:35 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 027EDB85B
        for <kvm@vger.kernel.org>; Mon, 21 Nov 2022 04:36:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669034199;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gRniTnQ250/D9FMQbsGUOqQVU6omRQuB8EuAbpKYAkw=;
        b=VREyFfyg6fOyK2UGnRHD9UTRSlfCCz0RJz4i/lInYBaBYMF78ygm3E1unWm0+kcf2oXCVQ
        Sn7XBzBCZEnrrUTMslgCk6iYlWiNtDDiADwPyhMM8VAPwUvIFkOuCGmD4qxGwCAFQ2WGBc
        MWFhU1KncrzXO++lFIsoT0FAtTsat1c=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-516-gnRBdz9FMlqdbCGWHadoZA-1; Mon, 21 Nov 2022 07:36:37 -0500
X-MC-Unique: gnRBdz9FMlqdbCGWHadoZA-1
Received: by mail-wr1-f71.google.com with SMTP id j30-20020adfa55e000000b00241b49be1a3so3157829wrb.4
        for <kvm@vger.kernel.org>; Mon, 21 Nov 2022 04:36:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gRniTnQ250/D9FMQbsGUOqQVU6omRQuB8EuAbpKYAkw=;
        b=Q+ENFHYgNe2PBQmmyKs2qE9UH+0XLiFDPnsP7yEXniXO1v2IunuLY4qS9HlKfu7QfH
         YoWsroj15zz5+d6dCmcyl4UzKBxmc2DaHxLiwhhhGOJfBJfiEKY+TtRoX9jyBUSmpUsn
         XS3blhwtEoVdinARex9z/Vzm37BRhGBSyGD7kB09BCG0PmTq3769wqj/+k5byoyDw5wx
         2lmorxcaXg2UeWXcM+dpL5wv/3Vyl64sWW96v+pkfLfzvyHQ405VblbFumbOL3Bp57LQ
         PnT5c4p1xgi45cUTK2Xa8z6NW+yUiHDPVVqMwq0R2vfl8FWMDvrEJ9FjebNzemcJNmrr
         SJUQ==
X-Gm-Message-State: ANoB5pnOtHOJQtv/okNp01yOarsSKfkACG3sMpddJC1ERVkNP2mMOE0p
        FAmQ9r2Fl/m22Re3CCufvoNB5F7K3mh6f4tewh3C6uwpRqXG2iCwqOILtxwlUr4rD/uFY1pRuI5
        mS2GWXTk4Mqs0
X-Received: by 2002:a7b:ca55:0:b0:3cf:84e9:e705 with SMTP id m21-20020a7bca55000000b003cf84e9e705mr5494989wml.28.1669034195948;
        Mon, 21 Nov 2022 04:36:35 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6fJdt9vj66HoednnpZcIMbPJ6xqzpTE3KCu7tuygESSBhjFv8UOz7cNS3cm9CNH3XB1fBAqw==
X-Received: by 2002:a7b:ca55:0:b0:3cf:84e9:e705 with SMTP id m21-20020a7bca55000000b003cf84e9e705mr5494966wml.28.1669034195674;
        Mon, 21 Nov 2022 04:36:35 -0800 (PST)
Received: from [10.35.4.238] (bzq-82-81-161-50.red.bezeqint.net. [82.81.161.50])
        by smtp.gmail.com with ESMTPSA id m29-20020a05600c3b1d00b003c6b7f5567csm26808132wms.0.2022.11.21.04.36.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Nov 2022 04:36:35 -0800 (PST)
Message-ID: <4aadf4616e4f1c6219e7c83ee491494feefa78e1.camel@redhat.com>
Subject: Re: [PATCH 07/13] KVM: SVM: Add VNMI support in get/set_nmi_mask
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sandipan Das <sandipan.das@amd.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Jing Liu <jing2.liu@intel.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Wyes Karny <wyes.karny@amd.com>,
        Borislav Petkov <bp@alien8.de>,
        Babu Moger <babu.moger@amd.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Jim Mattson <jmattson@google.com>, x86@kernel.org,
        Santosh Shukla <santosh.shukla@amd.com>
Date:   Mon, 21 Nov 2022 14:36:33 +0200
In-Reply-To: <Y3aDTvglaSfhG8Tg@google.com>
References: <20221117143242.102721-1-mlevitsk@redhat.com>
         <20221117143242.102721-8-mlevitsk@redhat.com> <Y3aDTvglaSfhG8Tg@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-5.fc34) 
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

On Thu, 2022-11-17 at 18:54 +0000, Sean Christopherson wrote:
> On Thu, Nov 17, 2022, Maxim Levitsky wrote:
> > From: Santosh Shukla <santosh.shukla@amd.com>
> > 
> > VMCB intr_ctrl bit12 (V_NMI_MASK) is set by the processor when handling
> > NMI in guest and is cleared after the NMI is handled. Treat V_NMI_MASK
> > as read-only in the hypervisor except for the SMM case where hypervisor
> > before entring and after leaving SMM mode requires to set and unset
> > V_NMI_MASK.
> > 
> > Adding API(get_vnmi_vmcb) in order to return the correct vmcb for L1 or
> > L2.
> > 
> > Maxim:
> >    - made set_vnmi_mask/clear_vnmi_mask/is_vnmi_mask warn if called
> >      without vNMI enabled
> >    - clear IRET intercept in svm_set_nmi_mask even with vNMI
> > 
> > Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
> > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > ---
> >  arch/x86/kvm/svm/svm.c | 18 ++++++++++++++-
> >  arch/x86/kvm/svm/svm.h | 52 ++++++++++++++++++++++++++++++++++++++++++
> >  2 files changed, 69 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index 08a7b2a0a29f3a..c16f68f6c4f7d7 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -3618,13 +3618,29 @@ static int svm_nmi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
> >  
> >  static bool svm_get_nmi_mask(struct kvm_vcpu *vcpu)
> >  {
> > -       return !!(vcpu->arch.hflags & HF_NMI_MASK);
> > +       struct vcpu_svm *svm = to_svm(vcpu);
> > +
> > +       if (is_vnmi_enabled(svm))
> > +               return is_vnmi_mask_set(svm);
> > +       else
> > +               return !!(vcpu->arch.hflags & HF_NMI_MASK);
> >  }
> >  
> >  static void svm_set_nmi_mask(struct kvm_vcpu *vcpu, bool masked)
> >  {
> >         struct vcpu_svm *svm = to_svm(vcpu);
> >  
> > +       if (is_vnmi_enabled(svm)) {
> > +               if (masked)
> > +                       set_vnmi_mask(svm);
> 
> I believe not setting INTERCEPT_IRET is correct, but only because the existing
> code is unnecessary.  And this all very subtly relies on KVM_REQ_EVENT being set
> and/or KVM already being in kvm_check_and_inject_events().
> 
> When NMIs become unblocked, INTERCEPT_IRET can be cleared, but KVM should also
> pending KVM_REQ_EVENT.  AFAICT, that doesn't happen when this is called via the
> emulator.  Ah, because em_iret() only handles RM for Intel's restricted guest
> crap.  I.e. it "works" only because it never happens.  All other flows set
> KVM_REQ_EVENT when toggling NMI blocking, e.g. the RSM path of kvm_smm_changed().
Makes sense


> 
> And when NMIs become blocked, there's no need to force INTERCEPT_IRET in this
> code because kvm_check_and_inject_events() will request an NMI window and set the
> intercept if necessary, and all paths that set NMI blocking are guaranteed to
> reach kvm_check_and_inject_events() before entering the guest.

I think I understand what you mean.


When a normal NMI is injected, we do have to intercept IRET because this is how
we know that NMI done executing.

But if NMI becames masked then it can be either if:

1. We are already in NMI, so masking it is essintially NOP, so no need to intercept
IRET since it is already intercepted.

2. We are not in NMI, then we don't need to intercept IRET, since its interception
is not needed to track that NMI is over, but only needed to detect NMI window
(IRET can be used without a paired NMI to unblock NMIs, which is IMHO a very wrong
x86 design decision, but the ship sailed long ago), and so we can intercept IRET
only when we request an actual NMI window.

Makes sense and I'll send a patch to do it.


> 
>   1. RSM => kvm_smm_changed() sets KVM_REQ_EVENT
>   2. enter_smm() is only called from within kvm_check_and_inject_events(),
>      before pending NMIs are processed (yay priority)
>   3. emulator_set_nmi_mask() never blocks NMIs, only does the half-baked IRET emulation
>   4. kvm_vcpu_ioctl_x86_set_vcpu_event() sets KVM_REQ_EVENT
> 
> So, can you add a prep patch to drop the forced INTERCEPT_IRET?  That way the
> logic for vNMI and !vNMI is the same.
> 
> > +               else {
> > +                       clear_vnmi_mask(svm);
> 
> This is the only code that sets/clears the vNMI mask, so rather than have set/clear
> helpers, what about a single helper to do the dirty work? 

Or not have any hepler at all maybe, since it is only done once? I don't know
I just wanted to not change the original patches too much, I only changed
the minimum to make it work.

> 
> > +                       if (!sev_es_guest(vcpu->kvm))
> > +                               svm_clr_intercept(svm, INTERCEPT_IRET);
> > +               }
> > +               return;
> > +       }
> > +
> >         if (masked) {
> >                 vcpu->arch.hflags |= HF_NMI_MASK;
> >                 if (!sev_es_guest(vcpu->kvm))
> > diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> > index f5383104d00580..bf7f4851dee204 100644
> > --- a/arch/x86/kvm/svm/svm.h
> > +++ b/arch/x86/kvm/svm/svm.h
> > @@ -35,6 +35,7 @@ extern u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;
> >  extern bool npt_enabled;
> >  extern int vgif;
> >  extern bool intercept_smi;
> > +extern bool vnmi;
> >  
> >  enum avic_modes {
> >         AVIC_MODE_NONE = 0,
> > @@ -531,6 +532,57 @@ static inline bool is_x2apic_msrpm_offset(u32 offset)
> >                (msr < (APIC_BASE_MSR + 0x100));
> >  }
> >  
> > +static inline struct vmcb *get_vnmi_vmcb(struct vcpu_svm *svm)
> > +{
> > +       if (!vnmi)
> > +               return NULL;
> > +
> > +       if (is_guest_mode(&svm->vcpu))
> > +               return svm->nested.vmcb02.ptr;
> > +       else
> > +               return svm->vmcb01.ptr;
> > +}
> > +
> > +static inline bool is_vnmi_enabled(struct vcpu_svm *svm)
> > +{
> > +       struct vmcb *vmcb = get_vnmi_vmcb(svm);
> > +
> > +       if (vmcb)
> > +               return !!(vmcb->control.int_ctl & V_NMI_ENABLE);
> > +       else
> > +               return false;
> 
> Maybe just this?
> 
>         return vmcb && (vmcb->control.int_ctl & V_NMI_ENABLE);
> 
> Or if an inner helper is added:
> 
>         return vmcb && __is_vnmi_enabled(vmcb);
> 
> > +}
> > +
> > +static inline bool is_vnmi_mask_set(struct vcpu_svm *svm)
> > +{
> > +       struct vmcb *vmcb = get_vnmi_vmcb(svm);
> > +
> > +       if (!WARN_ON_ONCE(!vmcb))
> 
> Rather than WARN, add an inner __is_vnmi_enabled() that takes the vnmi_vmcb.
> Actually, if you do that, the test/set/clear helpers can go away entirely.
> 
> > +               return false;
> > +
> > +       return !!(vmcb->control.int_ctl & V_NMI_MASK);
> > +}
> > +
> > +static inline void set_vnmi_mask(struct vcpu_svm *svm)
> > +{
> > +       struct vmcb *vmcb = get_vnmi_vmcb(svm);
> > +
> > +       if (!WARN_ON_ONCE(!vmcb))
> > +               return;
> > +
> > +       vmcb->control.int_ctl |= V_NMI_MASK;
> > +}
> > +
> > +static inline void clear_vnmi_mask(struct vcpu_svm *svm)
> > +{
> > +       struct vmcb *vmcb = get_vnmi_vmcb(svm);
> > +
> > +       if (!WARN_ON_ONCE(!vmcb))
> > +               return;
> > +
> > +       vmcb->control.int_ctl &= ~V_NMI_MASK;
> > +}
> 
> These helpers can all go in svm.  There are no users oustide of svm.c, and
> unless I'm misunderstanding how nested works, there should never be oustide users.
> 
> E.g. with HF_NMI_MASK => svm->nmi_masked, the end result can be something like:
> 
> static bool __is_vnmi_enabled(struct *vmcb)
> {
>         return !!(vmcb->control.int_ctl & V_NMI_ENABLE);
> }
> 
> static bool is_vnmi_enabled(struct vcpu_svm *svm)
> {
>         struct vmcb *vmcb = get_vnmi_vmcb(svm);
> 
>         return vmcb && __is_vnmi_enabled(vmcb);
> }
> 
> static bool svm_get_nmi_mask(struct kvm_vcpu *vcpu)
> {
>         struct vcpu_svm *svm = to_svm(vcpu);
>         struct vmcb *vmcb = get_vnmi_vmcb(svm);
> 
>         if (vmcb && __is_vnmi_enabled(vmcb))
>                 return !!(vmcb->control.int_ctl & V_NMI_MASK);
>         else
>                 return !!(vcpu->arch.hflags & HF_NMI_MASK);
> }
> 
> static void svm_set_or_clear_vnmi_mask(struct vmcb *vmcb, bool set)
> {
>         if (set)
>                 vmcb->control.int_ctl |= V_NMI_MASK;
>         else
>                 vmcb->control.int_ctl &= ~V_NMI_MASK;
> }
> 
> static void svm_set_nmi_mask(struct kvm_vcpu *vcpu, bool masked)
> {
>         struct vcpu_svm *svm = to_svm(vcpu);
>         struct vmcb *vmcb = get_vnmi_vmcb(svm);
> 
>         if (vmcb && __is_vnmi_enabled(vmcb)) {
>                 if (masked)
>                         vmcb->control.int_ctl |= V_NMI_MASK;
>                 else
>                         vmcb->control.int_ctl &= ~V_NMI_MASK;
>         } else {
>                 svm->nmi_masked = masked;
>         }
> 
>         if (!masked)
>                 svm_disable_iret_interception(svm);
> }

OK, this is one of the ways to do it, makes sense overall.
I actualy wanted to do something like that but opted to not touch
the original code too much, but only what I needed. I can do this
in a next version.

Best regards,
	Maxim Levitsky

> 


