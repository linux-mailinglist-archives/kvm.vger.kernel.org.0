Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A10434629BA
	for <lists+kvm@lfdr.de>; Tue, 30 Nov 2021 02:30:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236373AbhK3Bdc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Nov 2021 20:33:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236332AbhK3Bdc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Nov 2021 20:33:32 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2616C061574
        for <kvm@vger.kernel.org>; Mon, 29 Nov 2021 17:30:13 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id b11so13596323pld.12
        for <kvm@vger.kernel.org>; Mon, 29 Nov 2021 17:30:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=z6k0u76oLfrxFnRfCQqpgH3a7DGT8Svyiv/OozS9s8Q=;
        b=e+pDAbhA3qgo5VrRLD3GioZhOJH88Y+ZobynMlP5+GQ3GX6zzk43B/1yG+rsEjTK2j
         jDOwaSNw3exODm+rdBqEbseuVL90SfGErs9xFCBOAFKDOnF2L47MddrQrzeBo49E67Ac
         xawvOZp1p9ika1lAvGxvLrtaSlCN/xAwB6Nl1eK33Iixtbjn3fJMew6EpmlxshrqqTww
         5/sixT3Bp6t/lvEBrEIIuZnD0FvTLRX8glF8VI7PW4vkXKw/5gDN2XKrn5/l0rP5wF/x
         5Tp0aZXrijks003EJUQX09dSEA3bhgVpqSOt36HfY699jD2sNR9secXTNrMHHrLVRa9D
         pODg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=z6k0u76oLfrxFnRfCQqpgH3a7DGT8Svyiv/OozS9s8Q=;
        b=DRti9o9DoOoUEzb5bzoAog2mjvQzqMHjw/B79xM+769ZlNHW22rCY7/NEGybS6H1H2
         K6ArZyvS4OCuHfd4uCLbjHU+QtgcZQyIun3QcFzyfQrpxx949u//jckBXH0nh1RjS4uw
         LqOTQxWCpQrG0S3204GPYFfdeJ7BdBYmlm2JGUbAG25dpDoVU9adJTpZug+WgYbLygBY
         YuvwhWgcLCfa0ZSa+i55mbT5WloTAHl8F3lBXfw5SSJECYxhXaX9pcg8XniAx0gKnL5C
         qeTYoR0Mf+DL8F4e3o2E+tvUmy3vkA1XlJ6vtWut3Bn+TKEcjnL6ctPiKxVsG84NXXyQ
         z1BA==
X-Gm-Message-State: AOAM532lL/lQLUN8M17eXc3xv4aJyRiPnIgA1J1Ujr3iw7704sJ/4MTz
        osovKRuEnfvVkXOF2mNNkz9czaXvysIDZ6HUnbfQcg==
X-Google-Smtp-Source: ABdhPJzq1HYUtohDmdrT9AteQ7TOnwp5TltRApAUwblcjchFt88a9JJpwnFl4yiZ3v/V9q0A0N9AnzGuPZTdwUJXvTg=
X-Received: by 2002:a17:902:aa43:b0:142:6919:73da with SMTP id
 c3-20020a170902aa4300b00142691973damr63733052plr.39.1638235813148; Mon, 29
 Nov 2021 17:30:13 -0800 (PST)
MIME-Version: 1.0
References: <20211117064359.2362060-1-reijiw@google.com> <20211117064359.2362060-5-reijiw@google.com>
 <b56f871c-11da-e8ff-e90e-0ec3b4c0207f@redhat.com>
In-Reply-To: <b56f871c-11da-e8ff-e90e-0ec3b4c0207f@redhat.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Mon, 29 Nov 2021 17:29:57 -0800
Message-ID: <CAAeT=Fz96dYR2m7UbgVw_SjNV6wheYBfSx+m+zCWbnHWHkcQdw@mail.gmail.com>
Subject: Re: [RFC PATCH v3 04/29] KVM: arm64: Make ID_AA64PFR0_EL1 writable
To:     Eric Auger <eauger@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
        Peter Shier <pshier@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Eric,

On Thu, Nov 25, 2021 at 7:35 AM Eric Auger <eauger@redhat.com> wrote:
>
> Hi Reiji,
>
> On 11/17/21 7:43 AM, Reiji Watanabe wrote:
> > This patch adds id_reg_info for ID_AA64PFR0_EL1 to make it writable by
> > userspace.
> >
> > The CSV2/CSV3 fields of the register were already writable and values
> > that were written for them affected all vCPUs before. Now they only
> > affect the vCPU.
> > Return an error if userspace tries to set SVE/GIC field of the register
> > to a value that conflicts with SVE/GIC configuration for the guest.
> > SIMD/FP/SVE fields of the requested value are validated according to
> > Arm ARM.
> >
> > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > ---
> >  arch/arm64/kvm/sys_regs.c | 159 ++++++++++++++++++++++++--------------
> >  1 file changed, 103 insertions(+), 56 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index 1552cd5581b7..35400869067a 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -401,6 +401,92 @@ static void id_reg_info_init(struct id_reg_info *id_reg)
> >               id_reg->init(id_reg);
> >  }
> >
> > +#define      kvm_has_gic3(kvm)               \
> > +     (irqchip_in_kernel(kvm) &&      \
> > +      (kvm)->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3)
> you may move this macro to kvm/arm_vgic.h as this may be used in
> vgic/vgic-v3.c too

Thank you for the suggestion. I will move that to kvm/arm_vgic.h.


> > +
> > +static int validate_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
> > +                                 const struct id_reg_info *id_reg, u64 val)
> > +{
> > +     int fp, simd;
> > +     bool vcpu_has_sve = vcpu_has_sve(vcpu);
> > +     bool pfr0_has_sve = id_aa64pfr0_sve(val);
> > +     int gic;
> > +
> > +     simd = cpuid_feature_extract_signed_field(val, ID_AA64PFR0_ASIMD_SHIFT);
> > +     fp = cpuid_feature_extract_signed_field(val, ID_AA64PFR0_FP_SHIFT);
> > +     if (simd != fp)
> > +             return -EINVAL;
> > +
> > +     /* fp must be supported when sve is supported */
> > +     if (pfr0_has_sve && (fp < 0))
> > +             return -EINVAL;
> > +
> > +     /* Check if there is a conflict with a request via KVM_ARM_VCPU_INIT */
> > +     if (vcpu_has_sve ^ pfr0_has_sve)
> > +             return -EPERM;
> > +
> > +     gic = cpuid_feature_extract_unsigned_field(val, ID_AA64PFR0_GIC_SHIFT);
> > +     if ((gic > 0) ^ kvm_has_gic3(vcpu->kvm))
> > +             return -EPERM;
>
> Sometimes from a given architecture version, some lower values are not
> allowed. For instance from ARMv8.5 onlt 1 is permitted for CSV3.
> Shouldn't we handle that kind of check?

As far as I know, there is no way for guests to identify the
architecture revision (e.g. v8.1, v8.2, etc).  It might be able
to indirectly infer the revision though (from features that are
available or etc).


> > +
> > +     return 0;
> > +}
> > +
> > +static void init_id_aa64pfr0_el1_info(struct id_reg_info *id_reg)
> > +{
> > +     u64 limit = id_reg->vcpu_limit_val;
> > +     unsigned int gic;
> > +
> > +     limit &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_AMU);
> > +     if (!system_supports_sve())
> > +             limit &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_SVE);
> > +
> > +     /*
> > +      * The default is to expose CSV2 == 1 and CSV3 == 1 if the HW
> > +      * isn't affected.  Userspace can override this as long as it
> > +      * doesn't promise the impossible.
> > +      */
> > +     limit &= ~(ARM64_FEATURE_MASK(ID_AA64PFR0_CSV2) |
> > +                ARM64_FEATURE_MASK(ID_AA64PFR0_CSV3));
> > +
> > +     if (arm64_get_spectre_v2_state() == SPECTRE_UNAFFECTED)
> > +             limit |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_CSV2), 1);
> > +     if (arm64_get_meltdown_state() == SPECTRE_UNAFFECTED)
> > +             limit |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_CSV3), 1);
> > +
> > +     gic = cpuid_feature_extract_unsigned_field(limit, ID_AA64PFR0_GIC_SHIFT);
> > +     if (gic > 1) {
> > +             /* Limit to GICv3.0/4.0 */
> > +             limit &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_GIC);
> > +             limit |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_GIC), 1);
> > +     }
> > +     id_reg->vcpu_limit_val = limit;
> > +}
> > +
> > +static u64 get_reset_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
> > +                                  const struct id_reg_info *idr)
> > +{
> > +     u64 val = idr->vcpu_limit_val;
> > +
> > +     if (!vcpu_has_sve(vcpu))
> > +             val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_SVE);
> > +
> > +     if (!kvm_has_gic3(vcpu->kvm))
> > +             val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_GIC);
> > +
> > +     return val;
> > +}
> > +
> > +static struct id_reg_info id_aa64pfr0_el1_info = {
> > +     .sys_reg = SYS_ID_AA64PFR0_EL1,
> > +     .ftr_check_types = S_FCT(ID_AA64PFR0_ASIMD_SHIFT, FCT_LOWER_SAFE) |
> > +                        S_FCT(ID_AA64PFR0_FP_SHIFT, FCT_LOWER_SAFE),
> is it needed as it is the default?

> > +     .ftr_check_types = S_FCT(ID_AA64PFR0_ASIMD_SHIFT, FCT_LOWER_SAFE) |
> > +                        S_FCT(ID_AA64PFR0_FP_SHIFT, FCT_LOWER_SAFE),
> is it needed as it is the default?

They are needed because they are signed fields (the default is unsigned
and FCT_LOWER_SAFE).  Having said that, ftr_check_types itself will be
gone in the next version (as arm64_ftr_bits will be used instead).

Thanks,
Reiji
