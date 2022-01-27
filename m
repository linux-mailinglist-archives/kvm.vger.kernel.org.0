Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FEA349DB53
	for <lists+kvm@lfdr.de>; Thu, 27 Jan 2022 08:19:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233312AbiA0HTe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jan 2022 02:19:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230171AbiA0HTe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jan 2022 02:19:34 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1516C061714
        for <kvm@vger.kernel.org>; Wed, 26 Jan 2022 23:19:33 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id d5so2036711pjk.5
        for <kvm@vger.kernel.org>; Wed, 26 Jan 2022 23:19:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=i2RBhTxWRPU1sfMn3Q98WcKVoFM08enITE4vRBeZ0ts=;
        b=LveWagL8Y8wBrtFmstEFsxtVqR1cOWjSmVVo65yBqhyJF2T9o8vkHeytGjWxDMvW37
         KkJOHyfSKBRPCACtT5nb96Qsz1vHII0V9f0DWvWt2JzYKfRvbEUnHh2I7QDwUwm9jHiZ
         KXJQVXMh0+LfChNfwdq3PBx/Rom3FSQdlR506AUB3hnBBsJMF5+NX0UlH5YXfzAM2ucy
         pL0MHTrMME6dXUD4DM3djF7MFuhZ8iji6n9/OCThl5QPK3nbgzvB6Yl1nszY25PERhoP
         IVWe4CjOca/AqrKAXU40l/FHxoJGkjovc6+OHakCV5075aM+G4ADSX9M/42lCQVyLomO
         VBcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=i2RBhTxWRPU1sfMn3Q98WcKVoFM08enITE4vRBeZ0ts=;
        b=16y5ph4rl0lp+U33CBx1kZeMPNDcV+4XMrRdO8CPxcXSDsV06KmWTctWNrD/gJZDcI
         yzFBnMargwp6Pe2hwrNqhQDBF/eNObDFpA7D3HjVuqVe/1f4TwVTOHK34bB6qaUtCri+
         s3ffR3avI9E/XMhi2ewb9WCVPusnGiSkExvqLwD1Efq60v3jwxWBD9HNFt9nuLHR1tmV
         +UpLgVmVi9G3AVRN12ZCkAuQSSHw3xq5G/lQ9qMHHKkQWB10ge6t8AiIaDgEL2hRIntc
         +qG4jF3ckX0RtMyJY1VKyKBFbOoSfGmV8ec/Wtlk4Hrz66osD+o2o+5NNnDM8UoOPmDz
         saSA==
X-Gm-Message-State: AOAM5335qOn+HoJW0XpRP85t4K0p8ta/WEEL8jZV66mEtHoJNl88vL8j
        ZaWMrEgxQ65F/S8TdxkYK3XAc/6Gx8A1qHCUdIGXcg==
X-Google-Smtp-Source: ABdhPJx0IH1AvG7ogKWuMzMV7o4j8Ergb4xi8pLDsEOdIkOfB6Z5ux4Yre4+FVoHvdLBt2Vo8S4SBzDXKvetgqgjFhA=
X-Received: by 2002:a17:902:bc83:: with SMTP id bb3mr2671934plb.172.1643267973009;
 Wed, 26 Jan 2022 23:19:33 -0800 (PST)
MIME-Version: 1.0
References: <20220106042708.2869332-1-reijiw@google.com> <20220106042708.2869332-21-reijiw@google.com>
 <CA+EHjTy4L37G89orJ+cPTTZdFUehxNSMy0Pd36PW41JKVB0ohA@mail.gmail.com>
In-Reply-To: <CA+EHjTy4L37G89orJ+cPTTZdFUehxNSMy0Pd36PW41JKVB0ohA@mail.gmail.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Wed, 26 Jan 2022 23:19:17 -0800
Message-ID: <CAAeT=Fx1pM66cQaefkBTAJ7-Y0nzjmABJrp5DiNm4_47hdEyrg@mail.gmail.com>
Subject: Re: [RFC PATCH v4 20/26] KVM: arm64: Trap disabled features of ID_AA64PFR0_EL1
To:     Fuad Tabba <tabba@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
        Peter Shier <pshier@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Fuad,

On Mon, Jan 24, 2022 at 9:17 AM Fuad Tabba <tabba@google.com> wrote:
>
> Hi Reiji,
>
> On Thu, Jan 6, 2022 at 4:29 AM Reiji Watanabe <reijiw@google.com> wrote:
> >
> > Add feature_config_ctrl for RAS and AMU, which are indicated in
> > ID_AA64PFR0_EL1, to program configuration registers to trap
> > guest's using those features when they are not exposed to the guest.
> >
> > Introduce trap_ras_regs() to change a behavior of guest's access to
> > the registers, which is currently raz/wi, depending on the feature's
> > availability for the guest (and inject undefined instruction
> > exception when guest's RAS register access are trapped and RAS is
> > not exposed to the guest).  In order to keep the current visibility
> > of the RAS registers from userspace (always visible), a visibility
> > function for RAS registers is not added.
> >
> > No code is added for AMU's access/visibility handler because the
> > current code already injects the exception for Guest's AMU register
> > access unconditionally because AMU is never exposed to the guest.
>
> I think it might be code to trap it anyway, in case AMU guest support
> is added in the future.

Yes, I will fix it.
(I forgot to update the comment above...)


> >
> > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > ---
> >  arch/arm64/kvm/sys_regs.c | 90 +++++++++++++++++++++++++++++++++++----
> >  1 file changed, 82 insertions(+), 8 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index 33893a501475..015d67092d5e 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -304,6 +304,63 @@ struct feature_config_ctrl {
> >         void    (*trap_activate)(struct kvm_vcpu *vcpu);
> >  };
> >
> > +enum vcpu_config_reg {
> > +       VCPU_HCR_EL2 = 1,
> > +       VCPU_MDCR_EL2,
> > +       VCPU_CPTR_EL2,
> > +};
> > +
> > +static void feature_trap_activate(struct kvm_vcpu *vcpu,
> > +                                 enum vcpu_config_reg cfg_reg,
> > +                                 u64 cfg_set, u64 cfg_clear)
> > +{
> > +       u64 *reg_ptr, reg_val;
> > +
> > +       switch (cfg_reg) {
> > +       case VCPU_HCR_EL2:
> > +               reg_ptr = &vcpu->arch.hcr_el2;
> > +               break;
> > +       case VCPU_MDCR_EL2:
> > +               reg_ptr = &vcpu->arch.mdcr_el2;
> > +               break;
> > +       case VCPU_CPTR_EL2:
> > +               reg_ptr = &vcpu->arch.cptr_el2;
> > +               break;
> > +       }
> > +
> > +       /* Clear/Set fields that are indicated by cfg_clear/cfg_set. */
> > +       reg_val = (*reg_ptr & ~cfg_clear);
> > +       reg_val |= cfg_set;
> > +       *reg_ptr = reg_val;
> > +}
> > +
> > +static void feature_ras_trap_activate(struct kvm_vcpu *vcpu)
> > +{
> > +       feature_trap_activate(vcpu, VCPU_HCR_EL2, HCR_TERR | HCR_TEA, HCR_FIEN);
>
> Covers all the flags for ras.
>
> > +}
> > +
> > +static void feature_amu_trap_activate(struct kvm_vcpu *vcpu)
> > +{
> > +       feature_trap_activate(vcpu, VCPU_CPTR_EL2, CPTR_EL2_TAM, 0);
>
> Covers the CPTR flags for AMU, but as you mentioned, does not
> explicitly clear HCR_AMVOFFEN.

In my understanding, clearing HCR_EL2.AMVOFFEN is not necessary as
CPTR_EL2.TAM == 1 traps the guest's accessing AMEVCNTR0<n>_EL0 and
AMEVCNTR1<n>_EL0 anyway (HCR_EL2.AMVOFFEN doesn't matter).
(Or is my understanding wrong ??)

Thanks,
Reiji
