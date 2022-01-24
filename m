Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B84349859F
	for <lists+kvm@lfdr.de>; Mon, 24 Jan 2022 18:01:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243907AbiAXRBR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jan 2022 12:01:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244058AbiAXRBQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jan 2022 12:01:16 -0500
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B76AC061401
        for <kvm@vger.kernel.org>; Mon, 24 Jan 2022 09:01:16 -0800 (PST)
Received: by mail-oi1-x22f.google.com with SMTP id s185so9634361oie.3
        for <kvm@vger.kernel.org>; Mon, 24 Jan 2022 09:01:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Aj8Xi1kqw/YrKDgEErjzlaUQl2VTJLMRENCyteFx/Ug=;
        b=E7B3oJbpJ+F3M93IgmUCjE08YdCmVk7Wln2n1QapnKTA0f7HnnX9/aIc9E6A+8NQN4
         bX4kq775b+RQWSSzPJ8ne2VbohHUwcaOwWNCwbLooIsho9jMy2yeSQ9P+QmMrlmSAyxv
         /k0HQPlnDn1ThIQJcp8sRrTltOzGqlTQWs1R+Scq+3zJITapZ6o8Kug89ck3dKVSCzwR
         sDdKMeappC75/8Wek8GhBFggjXrJt2NXB80SPGGlmO9oGb/LBfVR3L18f4VDgfda9SX4
         Z+8e1A7ORNDJyUv02U7NRrKQ4EpFS8hPOwo9KfIRAevtTPYTGyH55q5NZbg5cZFaN45g
         cLhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Aj8Xi1kqw/YrKDgEErjzlaUQl2VTJLMRENCyteFx/Ug=;
        b=Ro7IwnQulsKicoK431qa/HVaYTDd3XuaEljeI8/m320Rri+/13rVgnagI2ajyESjer
         dmMG9wMJHdg+oDYpwghS6ddYR29CrYJ6mrD9S1F37GArdkIhzrZuwOznyPBuckbfYbLk
         PJ/yuadXK21Ffx2ut82tPOyFlodPj9W8BtgKFWdL+B0qc9ub433HeYFKx5crJAk250Ez
         ZMgpbl0vXTU6UqDc0UzBVaBpnj+0iWOCRF/YwC06sc3I+gMxy9PqMA6DcA8JjomuWdEl
         vt4wke4uJhkqRAd/1t9CNs/QAI1MAt+Pi42puOO9K7HCrAPcXt+ROcNSIzHuCNu4csk7
         EodA==
X-Gm-Message-State: AOAM530H/QHibTG6PR8U1KVOtWHTaNQuh7jnPi2ynwLXdT3elosgTpZx
        HHe+UXaiidooT0j0wtpW/OSEWDWns1UUjJfNw38a35BGXo8UmA==
X-Google-Smtp-Source: ABdhPJzxcvJw0ecG6sIAoWVzbp4b0QCZWJB9HqLs8Eqzh+bYnR+k/J+JZ4wCWm+2nKk0MzwhG8VLgq0Wt6aWBvjcMHU=
X-Received: by 2002:aca:1204:: with SMTP id 4mr2189252ois.85.1643043674943;
 Mon, 24 Jan 2022 09:01:14 -0800 (PST)
MIME-Version: 1.0
References: <20220106042708.2869332-1-reijiw@google.com> <20220106042708.2869332-15-reijiw@google.com>
In-Reply-To: <20220106042708.2869332-15-reijiw@google.com>
From:   Fuad Tabba <tabba@google.com>
Date:   Mon, 24 Jan 2022 17:00:38 +0000
Message-ID: <CA+EHjTzQK2kswrW3LDf0ybz4estOCdafCvtRZHWwvTv2nH-UVw@mail.gmail.com>
Subject: Re: [RFC PATCH v4 14/26] KVM: arm64: Add consistency checking for
 frac fields of ID registers
To:     Reiji Watanabe <reijiw@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
        Peter Shier <pshier@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Reiji,

On Thu, Jan 6, 2022 at 4:29 AM Reiji Watanabe <reijiw@google.com> wrote:
>
> Feature fractional field of an ID register cannot be simply validated
> at KVM_SET_ONE_REG because its validity depends on its (main) feature
> field value, which could be in a different ID register (and might be
> set later).
> Validate fractional fields at the first KVM_RUN instead.
>
> Signed-off-by: Reiji Watanabe <reijiw@google.com>
> ---
>  arch/arm64/include/asm/kvm_host.h |   1 +
>  arch/arm64/kvm/arm.c              |   3 +
>  arch/arm64/kvm/sys_regs.c         | 116 +++++++++++++++++++++++++++++-
>  3 files changed, 117 insertions(+), 3 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 4509f9e7472d..7b3f86bd6a6b 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -750,6 +750,7 @@ long kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
>
>  void set_default_id_regs(struct kvm *kvm);
>  int kvm_set_id_reg_feature(struct kvm *kvm, u32 id, u8 field_shift, u8 fval);
> +int kvm_id_regs_consistency_check(const struct kvm_vcpu *vcpu);
>
>  /* Guest/host FPSIMD coordination helpers */
>  int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu);
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 5f497a0af254..16fc2ce32069 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -596,6 +596,9 @@ static int kvm_vcpu_first_run_init(struct kvm_vcpu *vcpu)
>         if (!kvm_arm_vcpu_is_finalized(vcpu))
>                 return -EPERM;
>
> +       if (!kvm_vm_is_protected(kvm) && kvm_id_regs_consistency_check(vcpu))
> +               return -EPERM;
> +
>         vcpu->arch.has_run_once = true;
>
>         kvm_arm_vcpu_init_debug(vcpu);
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index ddbeefc3881c..6adb7b04620c 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -756,9 +756,6 @@ static struct id_reg_info id_aa64pfr0_el1_info = {
>
>  static struct id_reg_info id_aa64pfr1_el1_info = {
>         .sys_reg = SYS_ID_AA64PFR1_EL1,
> -       .ignore_mask = ARM64_FEATURE_MASK(ID_AA64PFR1_RASFRAC) |
> -                      ARM64_FEATURE_MASK(ID_AA64PFR1_MPAMFRAC) |
> -                      ARM64_FEATURE_MASK(ID_AA64PFR1_CSV2FRAC),
>         .init = init_id_aa64pfr1_el1_info,
>         .validate = validate_id_aa64pfr1_el1,
>         .vcpu_mask = vcpu_mask_id_aa64pfr1_el1,
> @@ -3434,10 +3431,109 @@ int kvm_arm_copy_sys_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
>         return write_demux_regids(uindices);
>  }
>
> +/* ID register's fractional field information with its feature field. */
> +struct feature_frac {
> +       u32     id;
> +       u32     shift;
> +       u32     frac_id;
> +       u32     frac_shift;
> +       u8      frac_ftr_check;
> +};

frac_ftr_check doesn't seem to be used. Also, it would be easier to
read if the ordering of the fields match the ordering you initialize
them below.

> +
> +static struct feature_frac feature_frac_table[] = {
> +       {
> +               .frac_id = SYS_ID_AA64PFR1_EL1,
> +               .frac_shift = ID_AA64PFR1_RASFRAC_SHIFT,
> +               .id = SYS_ID_AA64PFR0_EL1,
> +               .shift = ID_AA64PFR0_RAS_SHIFT,
> +       },
> +       {
> +               .frac_id = SYS_ID_AA64PFR1_EL1,
> +               .frac_shift = ID_AA64PFR1_MPAMFRAC_SHIFT,
> +               .id = SYS_ID_AA64PFR0_EL1,
> +               .shift = ID_AA64PFR0_MPAM_SHIFT,
> +       },
> +       {
> +               .frac_id = SYS_ID_AA64PFR1_EL1,
> +               .frac_shift = ID_AA64PFR1_CSV2FRAC_SHIFT,
> +               .id = SYS_ID_AA64PFR0_EL1,
> +               .shift = ID_AA64PFR0_CSV2_SHIFT,
> +       },
> +};
> +
> +/*
> + * Return non-zero if the feature/fractional fields pair are not
> + * supported. Return zero otherwise.
> + * This function validates only the fractional feature field,
> + * and relies on the fact the feature field is validated before
> + * through arm64_check_features.
> + */
> +static int vcpu_id_reg_feature_frac_check(const struct kvm_vcpu *vcpu,
> +                                         const struct feature_frac *ftr_frac)
> +{
> +       const struct id_reg_info *id_reg;
> +       u32 id;
> +       u64 val, lim, mask;
> +
> +       /* Check if the feature field value is same as the limit */
> +       id = ftr_frac->id;
> +       id_reg = GET_ID_REG_INFO(id);
> +
> +       mask = (u64)ARM64_FEATURE_FIELD_MASK << ftr_frac->shift;
> +       val = __read_id_reg(vcpu, id) & mask;
> +       lim = id_reg ? id_reg->vcpu_limit_val : read_sanitised_ftr_reg(id);
> +       lim &= mask;
> +
> +       if (val != lim)
> +               /*
> +                * The feature level is lower than the limit.
> +                * Any fractional version should be fine.
> +                */
> +               return 0;
> +
> +       /* Check the fractional feature field */
> +       id = ftr_frac->frac_id;
> +       id_reg = GET_ID_REG_INFO(id);
> +
> +       mask = (u64)ARM64_FEATURE_FIELD_MASK << ftr_frac->frac_shift;
> +       val = __read_id_reg(vcpu, id) & mask;
> +       lim = id_reg ? id_reg->vcpu_limit_val : read_sanitised_ftr_reg(id);
> +       lim &= mask;
> +
> +       if (val == lim)
> +               /*
> +                * Both the feature and fractional fields are the same
> +                * as limit.
> +                */
> +               return 0;
> +
> +       return arm64_check_features(id, val, lim);
> +}
> +
> +int kvm_id_regs_consistency_check(const struct kvm_vcpu *vcpu)

Nit: considering that this is only checking the fractional fields,
should the function name reflect that?

> +{
> +       int i, err;
> +       const struct feature_frac *frac;
> +
> +       /*
> +        * Check ID registers' fractional fields, which aren't checked
> +        * at KVM_SET_ONE_REG.
> +        */
> +       for (i = 0; i < ARRAY_SIZE(feature_frac_table); i++) {
> +               frac = &feature_frac_table[i];
> +               err = vcpu_id_reg_feature_frac_check(vcpu, frac);
> +               if (err)
> +                       return err;
> +       }
> +       return 0;
> +}
> +
>  static void id_reg_info_init_all(void)
>  {
>         int i;
>         struct id_reg_info *id_reg;
> +       struct feature_frac *frac;
> +       u64 ftr_mask = ARM64_FEATURE_FIELD_MASK;
>
>         for (i = 0; i < ARRAY_SIZE(id_reg_info_table); i++) {
>                 id_reg = (struct id_reg_info *)id_reg_info_table[i];
> @@ -3446,6 +3542,20 @@ static void id_reg_info_init_all(void)
>
>                 id_reg_info_init(id_reg);
>         }
> +
> +       /*
> +        * Update ignore_mask of ID registers based on fractional fields
> +        * information.  Any ID register that have fractional fields
> +        * is expected to have its own id_reg_info.
> +        */
> +       for (i = 0; i < ARRAY_SIZE(feature_frac_table); i++) {
> +               frac = &feature_frac_table[i];
> +               id_reg = GET_ID_REG_INFO(frac->frac_id);
> +               if (WARN_ON_ONCE(!id_reg))
> +                       continue;
> +
> +               id_reg->ignore_mask |= ftr_mask << frac->frac_shift;
> +       }
>  }

Thanks,
/fuad


>
>  void kvm_sys_reg_table_init(void)
> --
> 2.34.1.448.ga2b2bfdf31-goog
>
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
