Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DD1146C1BD
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 18:28:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240001AbhLGRcX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 12:32:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229800AbhLGRcW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Dec 2021 12:32:22 -0500
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 466B8C061574
        for <kvm@vger.kernel.org>; Tue,  7 Dec 2021 09:28:52 -0800 (PST)
Received: by mail-oi1-x22b.google.com with SMTP id t23so29021079oiw.3
        for <kvm@vger.kernel.org>; Tue, 07 Dec 2021 09:28:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/AvOf7ER8v5H0MjABhsd0BcEX4X+zqr8vh7bP9dwVAA=;
        b=ZvcljMy7ztZ2M2RzI/cYNwQh+ld65A/KWrGMi0BI/g1hKirUUjFuJERVQBNwc9G/nb
         vViR2AjLmz3v4X3QEpZPDgCcEHG6OSHgAzYlCaDw4qY58CmleIVOWJF+Eruvq7Y+5sfo
         BL6/Piynk8knxTaad4opvmEUSA1e17+Mr0tX1Fvsd4WnZxFgLAwrri+GnHagzKyPFlkw
         y4nwcZmjzGsVT55Uc8hwTGDBtnRTNhvQI2yHGZu+7Jfv4OEl3OilEAANz0AuOc9P14Zb
         oOYzyrJ1F2/F7TE3QqVnML7eGobICS8ZpdrN7Nzf0uCd+F+FWFmYkfFLegeyblPmonRt
         kdPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/AvOf7ER8v5H0MjABhsd0BcEX4X+zqr8vh7bP9dwVAA=;
        b=SYSH7Ww3yB68yeuZRvhXcmrmrrfLHO6bYtHObSYAM8UWseqaMJo2RMAokak0H433HI
         qEToFhKKrmNJBGrO4HfRVs+BoW5nC8rLen2+dfmhEuP54wDhly1M3zmn1M4/h4kt7z9q
         9XGy8Dyg9pZGu04xPQl6vSHRHhrw5dPcYTX7StK8rotTm9HCUyT5jvI5JOCySqZ++gHc
         6y1mFR23z+H5WMjvU/2vHdUS3yaFQpOfnF6t2e2/I2MSfttMck/NQbkqKINsJEeIhynw
         ExOi44DGFE0dn3bxfbLLBq0mne2x+KdRJHK0oz9OChgmzEUrU5xmdosq+c87iwxBLwIQ
         kxDg==
X-Gm-Message-State: AOAM533WyYbCnYtv5C9lY4iVz7SczAuEWzXUpFZYXkCifgsc57UM2pf/
        ekcUkpH3T2ho8awFusiI7EBy92Mhq4BI2VkfYiQYgtQbwC0w+w==
X-Google-Smtp-Source: ABdhPJzKZi3NPnBCVYoeIOunfFC4LiThbaSzLqhOKTlwi9M5FmOEA5dK5aAeDwO4w+3RZwxMjvr3esT4tI4hPHO6ip4=
X-Received: by 2002:a54:4515:: with SMTP id l21mr6394061oil.15.1638898120973;
 Tue, 07 Dec 2021 09:28:40 -0800 (PST)
MIME-Version: 1.0
References: <20211207043100.3357474-1-marcorr@google.com> <c8889028-9c4e-cade-31b6-ea92a32e4f66@amd.com>
 <CAA03e5E7-ns7w9B9Tu7pSWzCo0Nh7Ba5jwQXcn_XYPf_reRq9Q@mail.gmail.com>
 <5e69c0ca-389c-3ace-7559-edd901a0ab3c@amd.com> <Ya+NIxO5pIkB8057@google.com>
In-Reply-To: <Ya+NIxO5pIkB8057@google.com>
From:   Marc Orr <marcorr@google.com>
Date:   Tue, 7 Dec 2021 09:28:29 -0800
Message-ID: <CAA03e5FYm1ZZc+OEiKjdDj6jnhvgcU_fwOpV5RxofChPEHp-+Q@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: Always set kvm_run->if_flag
To:     Sean Christopherson <seanjc@google.com>
Cc:     Tom Lendacky <Thomas.Lendacky@amd.com>, pbonzini@redhat.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 7, 2021 at 8:34 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Tue, Dec 07, 2021, Tom Lendacky wrote:
> > On 12/7/21 9:14 AM, Marc Orr wrote:
> > > On Tue, Dec 7, 2021 at 6:43 AM Tom Lendacky <thomas.lendacky@amd.com> wrote:
> > > > > +static bool svm_get_if_flag(struct kvm_vcpu *vcpu)
> > > > > +{
> > > > > +     struct vmcb *vmcb = to_svm(vcpu)->vmcb;
> > > > > +
> > > > > +     return !!(vmcb->control.int_state & SVM_GUEST_INTERRUPT_MASK);
> > > >
> > > > I'm not sure if this is always valid to use for non SEV-ES guests. Maybe
> > > > the better thing would be:
> > > >
> > > >          return sev_es_guest(vcpu->kvm) ? vmcb->control.int_state & SVM_GUEST_INTERRUPT_MASK
> > > >                                         : kvm_get_rflags(vcpu) & X86_EFLAGS_IF;
> > > >
> > > > (Since this function returns a bool, I don't think you need the !!)
> > >
> > > I had the same reservations when writing the patch. (Why fix what's
> > > not broken.) The reason I wrote the patch this way is based on what I
> > > read in APM vol2: Appendix B Layout of VMCB: "GUEST_INTERRUPT_MASK -
> > > Value of the RFLAGS.IF bit for the guest."
> >
> > I just verified with the hardware team that this flag is indeed only set for
> > a guest with protected state (SEV-ES / SEV-SNP). An update to the APM will
> > be made.
>
> svm_interrupt_blocked() should be modified to use the new svm_get_if_flag()
> helper so that the SEV-{ES,SN} behavior is contained in a single location, e.g.
>
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 208566f63bce..fef04e9fa9c9 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3583,14 +3583,10 @@ bool svm_interrupt_blocked(struct kvm_vcpu *vcpu)
>         if (!gif_set(svm))
>                 return true;
>
> -       if (sev_es_guest(vcpu->kvm)) {
> -               /*
> -                * SEV-ES guests to not expose RFLAGS. Use the VMCB interrupt mask
> -                * bit to determine the state of the IF flag.
> -                */
> -               if (!(vmcb->control.int_state & SVM_GUEST_INTERRUPT_MASK))
> +       if (!is_guest_mode(vcpu)) {
> +               if (!svm_get_if_flag(vcpu))
>                         return true;
> -       } else if (is_guest_mode(vcpu)) {
> +       } else {
>                 /* As long as interrupts are being delivered...  */
>                 if ((svm->nested.ctl.int_ctl & V_INTR_MASKING_MASK)
>                     ? !(svm->vmcb01.ptr->save.rflags & X86_EFLAGS_IF)
> @@ -3600,9 +3596,6 @@ bool svm_interrupt_blocked(struct kvm_vcpu *vcpu)
>                 /* ... vmexits aren't blocked by the interrupt shadow  */
>                 if (nested_exit_on_intr(svm))
>                         return false;
> -       } else {
> -               if (!(kvm_get_rflags(vcpu) & X86_EFLAGS_IF))
> -                       return true;
>         }
>
>         return (vmcb->control.int_state & SVM_INTERRUPT_SHADOW_MASK);

Agreed. This is a nice change. I'll incorporate it into v2. Thanks!
