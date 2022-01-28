Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6619A49F315
	for <lists+kvm@lfdr.de>; Fri, 28 Jan 2022 06:40:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234678AbiA1Fkd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jan 2022 00:40:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231204AbiA1Fkc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jan 2022 00:40:32 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1247FC061714
        for <kvm@vger.kernel.org>; Thu, 27 Jan 2022 21:40:32 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id d18so4935060plg.2
        for <kvm@vger.kernel.org>; Thu, 27 Jan 2022 21:40:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kQgaN91aBojrZB98q50IoV/CyP18WN7SkHg7seKU5xM=;
        b=EfTcJpL2x2G+dT8lRtAOauEbP/eW8+MqMsieb6Ut4RCRsYhJmat4RREDbZ33oNm6IO
         HKsd32id5H2KfCMOsm3MMgrWFzClW5lB6+wE6U7N33IKzkksl+ZZDuVNfCxCJJWDtNJt
         S058unC4LH+8U2HBt4Mtnj9qxD5PJOwMwpSm5enImFwCgg0SY+7Y0W25Pl2q6MKYzMv2
         tpnWRdowQoKyeyKaXKSbA893V0hAp8TQdaSJG5cRvPOX/d1EKqkf6/vqvC+IAFORcdgL
         WwZLN33GewPKgfj6UZQf16RgtsUxr9Ma4P6ZdC28j3LQaQvrj0R0tyVr0tQ/c+enMMle
         UzsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kQgaN91aBojrZB98q50IoV/CyP18WN7SkHg7seKU5xM=;
        b=vA3UpFUVbjDlpzgWmjE5QngyUwh2ctQDkfBzDyN7MSzTeBmLiNAucVy4NbyCYxIeLg
         JrEHgeDaGIOdijKmA+eDJvd3rFlKRxQlzuQgXhadNuV4DJ83Va5DsQeJhFsC2BD+MON4
         4dX0LaBY2890r4ZB94Ug5KvefKGJn/JgezzCgW88qlWwdLf+mM1IDRTVDG0YIrIvpu9Z
         kB3jbebtBGSCGh/wla5n4yyGUJFWdievxuwVt1lpvXMbP3tJkfz8+RpyptBMir74IGoR
         2pd0OGSKhUC2xxwv0S067KZYv2B7NvbLl4ZQESBcZ2Nk67Z11sx8kJp9DPXASyavqdKg
         kEcA==
X-Gm-Message-State: AOAM5328NmK9B0VjzgVE4nmW435aOJhLKsBj+f1Ctn4xXUz2sWhKyMrL
        /mpcqujRDiKZwheWCKWPHUsv3v4ocGCbSctB6QAwpg==
X-Google-Smtp-Source: ABdhPJw9oXiDHGetc7Kw5MzZ3rsTL6M2LnLubbiAM9+CcBEUzz/qRI1KGvq1K+4tioDROw4QG+bdUkzuQNyvRL+9FI0=
X-Received: by 2002:a17:902:d109:: with SMTP id w9mr6874586plw.138.1643348431315;
 Thu, 27 Jan 2022 21:40:31 -0800 (PST)
MIME-Version: 1.0
References: <20220106042708.2869332-1-reijiw@google.com> <20220106042708.2869332-23-reijiw@google.com>
 <CA+EHjTyimL8nuE0gH8B3V-MzoA9rz+n3KazqFxMtdJKgjefAag@mail.gmail.com>
In-Reply-To: <CA+EHjTyimL8nuE0gH8B3V-MzoA9rz+n3KazqFxMtdJKgjefAag@mail.gmail.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Thu, 27 Jan 2022 21:40:15 -0800
Message-ID: <CAAeT=Fw5LC559c=NxSp8xk1WO0CkD-DoJd-sACf78Uf6Yu1nMA@mail.gmail.com>
Subject: Re: [RFC PATCH v4 22/26] KVM: arm64: Trap disabled features of ID_AA64DFR0_EL1
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

On Mon, Jan 24, 2022 at 9:20 AM Fuad Tabba <tabba@google.com> wrote:
>
> .Hi Reiji,
>
> On Thu, Jan 6, 2022 at 4:29 AM Reiji Watanabe <reijiw@google.com> wrote:
> >
> > Add feature_config_ctrl for PMUv3, PMS and TraceFilt, which are
> > indicated in ID_AA64DFR0_EL1, to program configuration registers
> > to trap guest's using those features when they are not exposed to
> > the guest.
> >
> > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > ---
> >  arch/arm64/kvm/sys_regs.c | 47 +++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 47 insertions(+)
> >
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index 72e745c5a9c2..229671ec3abd 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -349,6 +349,22 @@ static void feature_mte_trap_activate(struct kvm_vcpu *vcpu)
> >         feature_trap_activate(vcpu, VCPU_HCR_EL2, HCR_TID5, HCR_DCT | HCR_ATA);
> >  }
> >
> > +static void feature_pmuv3_trap_activate(struct kvm_vcpu *vcpu)
> > +{
> > +       feature_trap_activate(vcpu, VCPU_MDCR_EL2, MDCR_EL2_TPM, 0);
>
> I think that for full coverage it might be good to include setting
> MDCR_EL2_TPMCR, and clearing MDCR_EL2_HPME | MDCR_EL2_MTPME |
> MDCR_EL2_HPMN_MASK, even if redundant at this point.

I included what is needed only, and I would prefer not to let KVM
do things that are not needed to trap guest's using the feature.
Please let me know if you have a specific reason why you think it
would be better to include them.

>
> > +}
> > +
> > +static void feature_pms_trap_activate(struct kvm_vcpu *vcpu)
> > +{
> > +       feature_trap_activate(vcpu, VCPU_MDCR_EL2, MDCR_EL2_TPMS,
> > +                             MDCR_EL2_E2PB_MASK << MDCR_EL2_E2PB_SHIFT);
> > +}
> > +
> > +static void feature_tracefilt_trap_activate(struct kvm_vcpu *vcpu)
> > +{
> > +       feature_trap_activate(vcpu, VCPU_MDCR_EL2, MDCR_EL2_TTRF, 0);
> > +}
> > +
> >  /* For ID_AA64PFR0_EL1 */
> >  static struct feature_config_ctrl ftr_ctrl_ras = {
> >         .ftr_reg = SYS_ID_AA64PFR0_EL1,
> > @@ -375,6 +391,31 @@ static struct feature_config_ctrl ftr_ctrl_mte = {
> >         .trap_activate = feature_mte_trap_activate,
> >  };
> >
> > +/* For ID_AA64DFR0_EL1 */
> > +static struct feature_config_ctrl ftr_ctrl_pmuv3 = {
> > +       .ftr_reg = SYS_ID_AA64DFR0_EL1,
> > +       .ftr_shift = ID_AA64DFR0_PMUVER_SHIFT,
> > +       .ftr_min = ID_AA64DFR0_PMUVER_8_0,
> > +       .ftr_signed = FTR_UNSIGNED,
> > +       .trap_activate = feature_pmuv3_trap_activate,
> > +};
> > +
> > +static struct feature_config_ctrl ftr_ctrl_pms = {
> > +       .ftr_reg = SYS_ID_AA64DFR0_EL1,
> > +       .ftr_shift = ID_AA64DFR0_PMSVER_SHIFT,
> > +       .ftr_min = ID_AA64DFR0_PMSVER_8_2,
> > +       .ftr_signed = FTR_UNSIGNED,
> > +       .trap_activate = feature_pms_trap_activate,
> > +};
> > +
> > +static struct feature_config_ctrl ftr_ctrl_tracefilt = {
> > +       .ftr_reg = SYS_ID_AA64DFR0_EL1,
> > +       .ftr_shift = ID_AA64DFR0_TRACE_FILT_SHIFT,
> > +       .ftr_min = 1,
> > +       .ftr_signed = FTR_UNSIGNED,
> > +       .trap_activate = feature_tracefilt_trap_activate,
> > +};
>
> I think you might be missing trace, ID_AA64DFR0_TRACEVER -> CPTR_EL2_TTA.

Thank you for catching this. I will add the trace.

Thanks,
Reiji
