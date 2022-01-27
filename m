Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84CA049D9C8
	for <lists+kvm@lfdr.de>; Thu, 27 Jan 2022 06:03:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232202AbiA0FDx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jan 2022 00:03:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230106AbiA0FDw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jan 2022 00:03:52 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83AA4C06161C
        for <kvm@vger.kernel.org>; Wed, 26 Jan 2022 21:03:51 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id v74so1643129pfc.1
        for <kvm@vger.kernel.org>; Wed, 26 Jan 2022 21:03:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=agPawYo4RaAHn59m9QDt6suEoJLBOjPFjwtduhksCZA=;
        b=SHnaCJpS0XGF2gKPdqkxKsiQEN5Pvi0d4uuTXh2KymzYNDiqFtc13ey3Pu+dNkEgbZ
         pk/V6yrlgQge1/tujoYulDwjpCQmWLLJcvfWi7mBzKxIVSCCE8ta7V+Lr91cJvfLziNq
         1uhuc6gxDu5tYnDXQ9IZeL2cvPMXV7AkK6FfjUOn72PfHO55XXe+YnCas50gOtS14/ep
         s5P8DmOcWl0mqJzudyVMXOSVsO4TlTfZ3mcMuJ7eIRGMqv4k6h9ONr8mBjNhNlDM2U+g
         0k2IIfdEN+/P1B2f+UGy92Qj2L4lhmvWNcuhQbbK/iFk/hu8IIA0p10SGvmIfbW2vIZJ
         WkOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=agPawYo4RaAHn59m9QDt6suEoJLBOjPFjwtduhksCZA=;
        b=YeS5LD9NJ/onzZSzVuPTtvsmeg06gHaJFT+9qG/2BxWsDf3YepcsV9Hnp/XVeh5sGy
         CF40ZxercrnF8rmsHu2zFjpTbtUfAASjjsMm1FrBM8ksTJM4kSJNo5N/WDOWdo6oc8U1
         yzo552azTYyNcl3VD6iNae7MmkzWD5FqAc/Bp/BZHEo1CKjUog+evIoemufg9BLXGzLg
         s+6TNax5tr9ngrmx+5mDBVH5LH5YI/nF6OlD7QEBElt0wLAoL7WckLPQkyZfAMOB78c5
         hFG1+U24fqDPvAz1tC3On7eAObNnsCfNdMajIXLXKlN0Y+h0OB1lQI71WbGmFEfWTumI
         njzQ==
X-Gm-Message-State: AOAM531LudejlmmCJDHVnKXPXOkfvWQpIG4cfQM2eoLc9qOsMRHCPJZy
        bKMymzV8n6s2K7ioD4KGt9rZeC3Unb5qRUsDjNdYkQ==
X-Google-Smtp-Source: ABdhPJyohy4/6u5c4O8NFD2tW970/10L+Klc/wjONOYTfQvmiQ0UEXicdr8tiFzT/PhrjqK7I+uv9Ai47/74v+I+TOk=
X-Received: by 2002:a63:6909:: with SMTP id e9mr1595725pgc.514.1643259830730;
 Wed, 26 Jan 2022 21:03:50 -0800 (PST)
MIME-Version: 1.0
References: <20220106042708.2869332-1-reijiw@google.com> <20220106042708.2869332-15-reijiw@google.com>
 <CA+EHjTzQK2kswrW3LDf0ybz4estOCdafCvtRZHWwvTv2nH-UVw@mail.gmail.com>
In-Reply-To: <CA+EHjTzQK2kswrW3LDf0ybz4estOCdafCvtRZHWwvTv2nH-UVw@mail.gmail.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Wed, 26 Jan 2022 21:03:34 -0800
Message-ID: <CAAeT=FzR+=evcsOA9PMtsE=TDJmBq1LJxR5wo1DMgEZ0B=dU9Q@mail.gmail.com>
Subject: Re: [RFC PATCH v4 14/26] KVM: arm64: Add consistency checking for
 frac fields of ID registers
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

On Mon, Jan 24, 2022 at 9:01 AM Fuad Tabba <tabba@google.com> wrote:
>
> Hi Reiji,
>
> On Thu, Jan 6, 2022 at 4:29 AM Reiji Watanabe <reijiw@google.com> wrote:
> >
> > Feature fractional field of an ID register cannot be simply validated
> > at KVM_SET_ONE_REG because its validity depends on its (main) feature
> > field value, which could be in a different ID register (and might be
> > set later).
> > Validate fractional fields at the first KVM_RUN instead.
> >
> > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_host.h |   1 +
> >  arch/arm64/kvm/arm.c              |   3 +
> >  arch/arm64/kvm/sys_regs.c         | 116 +++++++++++++++++++++++++++++-
> >  3 files changed, 117 insertions(+), 3 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index 4509f9e7472d..7b3f86bd6a6b 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -750,6 +750,7 @@ long kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
> >
> >  void set_default_id_regs(struct kvm *kvm);
> >  int kvm_set_id_reg_feature(struct kvm *kvm, u32 id, u8 field_shift, u8 fval);
> > +int kvm_id_regs_consistency_check(const struct kvm_vcpu *vcpu);
> >
> >  /* Guest/host FPSIMD coordination helpers */
> >  int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu);
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index 5f497a0af254..16fc2ce32069 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -596,6 +596,9 @@ static int kvm_vcpu_first_run_init(struct kvm_vcpu *vcpu)
> >         if (!kvm_arm_vcpu_is_finalized(vcpu))
> >                 return -EPERM;
> >
> > +       if (!kvm_vm_is_protected(kvm) && kvm_id_regs_consistency_check(vcpu))
> > +               return -EPERM;
> > +
> >         vcpu->arch.has_run_once = true;
> >
> >         kvm_arm_vcpu_init_debug(vcpu);
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index ddbeefc3881c..6adb7b04620c 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -756,9 +756,6 @@ static struct id_reg_info id_aa64pfr0_el1_info = {
> >
> >  static struct id_reg_info id_aa64pfr1_el1_info = {
> >         .sys_reg = SYS_ID_AA64PFR1_EL1,
> > -       .ignore_mask = ARM64_FEATURE_MASK(ID_AA64PFR1_RASFRAC) |
> > -                      ARM64_FEATURE_MASK(ID_AA64PFR1_MPAMFRAC) |
> > -                      ARM64_FEATURE_MASK(ID_AA64PFR1_CSV2FRAC),
> >         .init = init_id_aa64pfr1_el1_info,
> >         .validate = validate_id_aa64pfr1_el1,
> >         .vcpu_mask = vcpu_mask_id_aa64pfr1_el1,
> > @@ -3434,10 +3431,109 @@ int kvm_arm_copy_sys_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
> >         return write_demux_regids(uindices);
> >  }
> >
> > +/* ID register's fractional field information with its feature field. */
> > +struct feature_frac {
> > +       u32     id;
> > +       u32     shift;
> > +       u32     frac_id;
> > +       u32     frac_shift;
> > +       u8      frac_ftr_check;
> > +};
>
> frac_ftr_check doesn't seem to be used. Also, it would be easier to
> read if the ordering of the fields match the ordering you initialize
> them below.

Thank you for catching this.
I will remove frac_ftr_check and change the ordering.

>
> > +
> > +static struct feature_frac feature_frac_table[] = {
> > +       {
> > +               .frac_id = SYS_ID_AA64PFR1_EL1,
> > +               .frac_shift = ID_AA64PFR1_RASFRAC_SHIFT,
> > +               .id = SYS_ID_AA64PFR0_EL1,
> > +               .shift = ID_AA64PFR0_RAS_SHIFT,
> > +       },
> > +       {
> > +               .frac_id = SYS_ID_AA64PFR1_EL1,
> > +               .frac_shift = ID_AA64PFR1_MPAMFRAC_SHIFT,
> > +               .id = SYS_ID_AA64PFR0_EL1,
> > +               .shift = ID_AA64PFR0_MPAM_SHIFT,
> > +       },
> > +       {
> > +               .frac_id = SYS_ID_AA64PFR1_EL1,
> > +               .frac_shift = ID_AA64PFR1_CSV2FRAC_SHIFT,
> > +               .id = SYS_ID_AA64PFR0_EL1,
> > +               .shift = ID_AA64PFR0_CSV2_SHIFT,
> > +       },
> > +};
> > +
> > +/*
> > + * Return non-zero if the feature/fractional fields pair are not
> > + * supported. Return zero otherwise.
> > + * This function validates only the fractional feature field,
> > + * and relies on the fact the feature field is validated before
> > + * through arm64_check_features.
> > + */
> > +static int vcpu_id_reg_feature_frac_check(const struct kvm_vcpu *vcpu,
> > +                                         const struct feature_frac *ftr_frac)
> > +{
> > +       const struct id_reg_info *id_reg;
> > +       u32 id;
> > +       u64 val, lim, mask;
> > +
> > +       /* Check if the feature field value is same as the limit */
> > +       id = ftr_frac->id;
> > +       id_reg = GET_ID_REG_INFO(id);
> > +
> > +       mask = (u64)ARM64_FEATURE_FIELD_MASK << ftr_frac->shift;
> > +       val = __read_id_reg(vcpu, id) & mask;
> > +       lim = id_reg ? id_reg->vcpu_limit_val : read_sanitised_ftr_reg(id);
> > +       lim &= mask;
> > +
> > +       if (val != lim)
> > +               /*
> > +                * The feature level is lower than the limit.
> > +                * Any fractional version should be fine.
> > +                */
> > +               return 0;
> > +
> > +       /* Check the fractional feature field */
> > +       id = ftr_frac->frac_id;
> > +       id_reg = GET_ID_REG_INFO(id);
> > +
> > +       mask = (u64)ARM64_FEATURE_FIELD_MASK << ftr_frac->frac_shift;
> > +       val = __read_id_reg(vcpu, id) & mask;
> > +       lim = id_reg ? id_reg->vcpu_limit_val : read_sanitised_ftr_reg(id);
> > +       lim &= mask;
> > +
> > +       if (val == lim)
> > +               /*
> > +                * Both the feature and fractional fields are the same
> > +                * as limit.
> > +                */
> > +               return 0;
> > +
> > +       return arm64_check_features(id, val, lim);
> > +}
> > +
> > +int kvm_id_regs_consistency_check(const struct kvm_vcpu *vcpu)
>
> Nit: considering that this is only checking the fractional fields,
> should the function name reflect that?

Thank you for the suggestion.
I will change the function name to reflect that.
(There were more checks in older version and I forgot to
change the name...)

Thanks,
Reiji
