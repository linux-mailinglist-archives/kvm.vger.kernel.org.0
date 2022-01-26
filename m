Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FD0E49C3D2
	for <lists+kvm@lfdr.de>; Wed, 26 Jan 2022 07:47:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236251AbiAZGq7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jan 2022 01:46:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232211AbiAZGq7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jan 2022 01:46:59 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39F82C06161C
        for <kvm@vger.kernel.org>; Tue, 25 Jan 2022 22:46:59 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id e6so229995pfc.7
        for <kvm@vger.kernel.org>; Tue, 25 Jan 2022 22:46:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=f6dqKO3PgHhM5UGW6xjEBcU4yLBPsWVi3UnvT/m/hMk=;
        b=g2aCOg/LlupJRhA/l2FmKs7CuxPP3PtKnl2qS2zVufVk3lRV2LITAXnsbGAPtX6lim
         SNtbyHMN2xGnwwcvfATaXa8kQWkhpYU26iCIW5mqe27D/KTjaN3kln0dj9h1ODh/5GHz
         hP1yhIVWCNGVUonoiePmzibVVA/h8Qk1LdBpz9opDa/51KsT/fbnt7igWV1GdORewy2b
         X9KPGVhfw52ycC4rFvSjDuTkWYghSBTMSlTUSGMVCt9dW8CCeAZMmLbBoVIZRWqXcZSQ
         h+tunb9n4hROYXxVuT1azIJEhdu1RATVWsmAcbchVqptRUN3aD1+7s+h3Rf5H4EtmUsD
         2I0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=f6dqKO3PgHhM5UGW6xjEBcU4yLBPsWVi3UnvT/m/hMk=;
        b=J17gMlrma1WSOuKWVgR7L0HH7A2N/iiI6iJiiporchCTJ/HprQJuXR4tCqdoye1JMu
         MKLj1aS7ACbqh55u+LS39HdeZqzG4N8m9RsIpkpuXAuUIRiqAIw8s2avX3cP4WpVjyDQ
         bltnsU/ruhraoLMHbhZthM4pGgQHxKMTB8Ky20Jx3vyxBG90uTpij+TSfU5B94JIwqcF
         aMsRC1BJsm78k8ETVAnFb0i9HRcnbnXCheCtizk+IJFzPwReQu8H0O8Vt+RCglqkU0Ca
         7C9+LXHT9kqP1Obni0HXTbvdDLrDIwIA3qhzzg0KLtloz0gnIQmltCVotU/jkzJvP4/5
         sTyw==
X-Gm-Message-State: AOAM532R1MZRWIon9KgA2ARqWpGAD+PXiLETvidUNXzUH+y1LWatdHYe
        NbjjGRGYOUffjJMGKzjlFzuUt7xaPEnILJUmShVuuc7HFjb8FA==
X-Google-Smtp-Source: ABdhPJwmgx6XOgb1UQ4LVSEw9TwdAJnLyMJQrCO8m6VIemGGIMB/Bri57M4ZZ09DR9gTLJ9XvF2fjgD50entNDDxexM=
X-Received: by 2002:a63:7c03:: with SMTP id x3mr17700535pgc.433.1643179618429;
 Tue, 25 Jan 2022 22:46:58 -0800 (PST)
MIME-Version: 1.0
References: <20220106042708.2869332-1-reijiw@google.com> <20220106042708.2869332-4-reijiw@google.com>
 <CA+EHjTx65scqNVvHci6fge7C5qQ=fiqqHKGwOvOKySQwsCy8Jg@mail.gmail.com>
In-Reply-To: <CA+EHjTx65scqNVvHci6fge7C5qQ=fiqqHKGwOvOKySQwsCy8Jg@mail.gmail.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Tue, 25 Jan 2022 22:46:42 -0800
Message-ID: <CAAeT=Fzi2JSuVGijM0x7_w8osRWMFUupz3r10NduO6r5hN+HKw@mail.gmail.com>
Subject: Re: [RFC PATCH v4 03/26] KVM: arm64: Introduce struct id_reg_info
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

On Mon, Jan 24, 2022 at 8:29 AM Fuad Tabba <tabba@google.com> wrote:
>
> Hi Reiji,
>
> On Thu, Jan 6, 2022 at 4:28 AM Reiji Watanabe <reijiw@google.com> wrote:
> >
> > This patch lays the groundwork to make ID registers writable.
> >
> > Introduce struct id_reg_info for an ID register to manage the
> > register specific control of its value for the guest, and provide set
> > of functions commonly used for ID registers to make them writable.
> >
> > The id_reg_info is used to do register specific initialization,
> > validation of the ID register and etc.  Not all ID registers must
> > have the id_reg_info. ID registers that don't have the id_reg_info
> > are handled in a common way that is applied to all ID registers.
> >
> > At present, changing an ID register from userspace is allowed only
> > if the ID register has the id_reg_info, but that will be changed
> > by the following patches.
> >
> > No ID register has the structure yet and the following patches
> > will add the id_reg_info for some ID registers.
> >
> > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > ---
> >  arch/arm64/kvm/sys_regs.c | 243 ++++++++++++++++++++++++++++++++++++--
> >  1 file changed, 230 insertions(+), 13 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index 80dc62f98ef0..971018288bee 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -265,6 +265,101 @@ static bool trap_raz_wi(struct kvm_vcpu *vcpu,
> >                 return read_zero(vcpu, p);
> >  }
> >
> > +struct id_reg_info {
> > +       u32     sys_reg;        /* Register ID */
>
> Nit: Why not have the comment above, as for the other fields of this struct?

Yes, I will fix that.
(I placed the comment there just because the comment was short
 enough to place it on the right side)

>
> > +
> > +       /*
> > +        * Limit value of the register for a vcpu. The value is the sanitized
> > +        * system value with bits cleared for unsupported features for the
> > +        * guest.
> > +        */
>
> I think that rather than saying "with bits cleared for unsupported
> features", it might be better to rephrase along the lines of "with
> bits indicating" or "set/cleared to indicate", so that it applies to
> signed fields as well.

Thank you for the suggestion ! I will fix the comment.

>
> > +       u64     vcpu_limit_val;
> > +
> > +       /* Fields that we don't to validate by arm64_check_features. */
>
> Nit: Remove "to".

I will fix it.

>
> > +       u64     ignore_mask;
> > +
> > +       /* Initialization function of the id_reg_info */
> > +       void (*init)(struct id_reg_info *id_reg);
> > +       /*
> > +        * This is an optional ID register specific validation function.
> > +        * When userspace tries to set the ID register, arm64_check_features()
> > +        * will check if the requested value indicates any features that cannot
> > +        * be supported by KVM on the host.  But, some ID register fields need
> > +        * a special checking, and this function can be used for such fields.
> > +        * e.g. When SVE is configured for a vCPU by KVM_ARM_VCPU_INIT,
> > +        * ID_AA64PFR0_EL1.SVE shouldn't be set to 0 for the vCPU.
> > +        * The validation function for ID_AA64PFR0_EL1 could be used to check
> > +        * the field is consistent with SVE configuration.
> > +        */
> > +       int (*validate)(struct kvm_vcpu *vcpu, const struct id_reg_info *id_reg,
> > +                       u64 val);
> > +
> > +       /*
> > +        * Return a bitmask of the vCPU's ID register fields that are not
> > +        * synced with saved (per VM) ID register value, which usually
> > +        * indicates opt-in CPU features that is not configured for the vCPU.
>
> Nit: s/is/are

I will fix it.

>
>
> > +        * ID registers are saved per VM, but some opt-in CPU features can
> > +        * be configured per vCPU.  The saved (per VM) values for such
> > +        * features are for vCPUs with the features (and zero for
> > +        * vCPUs without the features).
> > +        * Return value of this function is used to handle such fields
> > +        * for per vCPU ID register read/write request with saved per VM
> > +        * ID register.  See the __write_id_reg's comment for more detail.
> > +        */
> > +       u64 (*vcpu_mask)(const struct kvm_vcpu *vcpu,
> > +                        const struct id_reg_info *id_reg);
> > +};
> > +
> > +static void id_reg_info_init(struct id_reg_info *id_reg)
> > +{
> > +       id_reg->vcpu_limit_val = read_sanitised_ftr_reg(id_reg->sys_reg);
> > +       if (id_reg->init)
>
> If there is an id_reg then the init function is necessary, isn't it?
> Otherwise it doesn't seem to add more than the default handling. If
> that's right, should we instead ensure that init is always set?

The init function is optional (maybe I should comment that).

>
> > +               id_reg->init(id_reg);
> > +}
> > +
> > +/*
> > + * An ID register that needs special handling to control the value for the
> > + * guest must have its own id_reg_info in id_reg_info_table.
> > + * (i.e. the reset value is different from the host's sanitized value,
> > + * the value is affected by opt-in features, some fields need specific
> > + * validation, etc.)
> > + */
> > +#define        GET_ID_REG_INFO(id)     (id_reg_info_table[IDREG_IDX(id)])
> > +static struct id_reg_info *id_reg_info_table[KVM_ARM_ID_REG_MAX_NUM] = {};
> > +
> > +static int validate_id_reg(struct kvm_vcpu *vcpu, u32 id, u64 val)
> > +{
> > +       const struct id_reg_info *id_reg = GET_ID_REG_INFO(id);
> > +       u64 limit, tmp_val;
> > +       int err;
> > +
> > +       if (id_reg) {
> > +               limit = id_reg->vcpu_limit_val;
> > +               /*
> > +                * Replace the fields that are indicated in ignore_mask with
> > +                * the value in the limit to not have arm64_check_features()
> > +                * check the field in @val.
> > +                */
> > +               tmp_val = val & ~id_reg->ignore_mask;
> > +               tmp_val |= (limit & id_reg->ignore_mask);
> > +       } else {
> > +               limit = read_sanitised_ftr_reg(id);
> > +               tmp_val = val;
> > +       }
> > +
> > +       /* Check if the value indicates any feature that is not in the limit. */
> > +       err = arm64_check_features(id, tmp_val, limit);
> > +       if (err)
> > +               return err;
> > +
> > +       if (id_reg && id_reg->validate)
> > +               /* Run the ID register specific validity check. */
> > +               err = id_reg->validate(vcpu, id_reg, val);
> > +
> > +       return err;
> > +}
> > +
> >  /*
> >   * ARMv8.1 mandates at least a trivial LORegion implementation, where all the
> >   * RW registers are RES0 (which we can implement as RAZ/WI). On an ARMv8.0
> > @@ -1061,9 +1156,81 @@ static bool access_arch_timer(struct kvm_vcpu *vcpu,
> >         return true;
> >  }
> >
> > +static u64 read_kvm_id_reg(struct kvm *kvm, u32 id)
> > +{
> > +       return kvm->arch.id_regs[IDREG_IDX(id)];
> > +}
> > +
> > +static int modify_kvm_id_reg(struct kvm *kvm, u32 id, u64 val,
> > +                            u64 preserve_mask)
> > +{
> > +       u64 old, new;
> > +
> > +       mutex_lock(&kvm->lock);
> > +
> > +       old = kvm->arch.id_regs[IDREG_IDX(id)];
> > +
> > +       /* Preserve the value at the bit position set in preserve_mask */
> > +       new = old & preserve_mask;
> > +       new |= (val & ~preserve_mask);
> > +
> > +       /* Don't allow to modify ID register value after KVM_RUN on any vCPUs */
> > +       if (kvm_vm_has_started(kvm) && new != old)
> > +               return -EBUSY;
>
> This path doesn't release the lock. I see that it gets fixed in a
> future patch, but it might be good to fix it here...

Thank you for catching it ! Yes, I will fix this.

>
> > +
> > +       WRITE_ONCE(kvm->arch.id_regs[IDREG_IDX(id)], new);
> > +       mutex_unlock(&kvm->lock);
> > +
> > +       return 0;
> > +}
> > +
> > +static int write_kvm_id_reg(struct kvm *kvm, u32 id, u64 val)
> > +{
> > +       return modify_kvm_id_reg(kvm, id, val, 0);
> > +}
> > +
> > +
> > +/*
> > + * KVM basically forces all vCPUs of the guest to have a uniform value for
> > + * each ID register (, which means KVM_SET_ONE_REG for a vCPU affects all
> > + * the vCPUs of the guest), and the id_regs[] of kvm_arch holds values
> > + * of ID registers for the guest.  However, there is an exception for
> > + * ID register fields corresponding to CPU features that can be
> > + * configured per vCPU by KVM_ARM_VCPU_INIT, or etc (e.g. PMUv3, SVE, etc).
> > + * For such fields, all vCPUs that have the feature will have a non-zero
> > + * uniform value (, which can be updated by userspace), but the vCPUs that
>
> Nit: uneven nesting of parentheses and commas :)

I will fix it.


> > + * don't have the feature will have zero for the fields.
> > + * Values that @id_regs holds are for vCPUs that have such features.  So,
> > + * to get the ID register value for a vCPU that doesn't have those features,
> > + * the corresponding fields in id_regs[] needs to be cleared.
> > + * A bitmask of the fields are provided by id_reg_info's vcpu_mask(), and
> > + * __write_id_reg() and __read_id_reg() take care of those fields using
> > + * the bitmask.
> > + */
> > +static int __write_id_reg(struct kvm_vcpu *vcpu, u32 id, u64 val)
> > +{
> > +       const struct id_reg_info *id_reg = GET_ID_REG_INFO(id);
> > +       u64 mask = 0;
> > +
> > +       if (id_reg && id_reg->vcpu_mask)
> > +               mask = id_reg->vcpu_mask(vcpu, id_reg);
> > +
> > +       /*
> > +        * Update the ID register for the guest with @val, except for fields
> > +        * that are set in the mask, which indicates fields for opt-in
> > +        * features that are not configured for the vCPU.
> > +        */
> > +       return modify_kvm_id_reg(vcpu->kvm, id, val, mask);
> > +}
> > +
> >  static u64 __read_id_reg(const struct kvm_vcpu *vcpu, u32 id)
> >  {
> > -       u64 val = vcpu->kvm->arch.id_regs[IDREG_IDX(id)];
> > +       const struct id_reg_info *id_reg = GET_ID_REG_INFO(id);
> > +       u64 val = read_kvm_id_reg(vcpu->kvm, id);
> > +
> > +       if (id_reg && id_reg->vcpu_mask)
> > +               /* Clear fields for opt-in features that are not configured. */
> > +               val &= ~(id_reg->vcpu_mask(vcpu, id_reg));
> >         switch (id) {
> >         case SYS_ID_AA64PFR0_EL1:
> > @@ -1222,12 +1389,7 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
> >         return 0;
> >  }
> >
> > -/*
> > - * cpufeature ID register user accessors
> > - *
> > - * For now, these registers are immutable for userspace, so for set_id_reg()
> > - * we don't allow the effective value to be changed.
> > - */
> > +/* cpufeature ID register user accessors */
> >  static int __get_id_reg(const struct kvm_vcpu *vcpu,
> >                         const struct sys_reg_desc *rd, void __user *uaddr,
> >                         bool raz)
> > @@ -1238,11 +1400,31 @@ static int __get_id_reg(const struct kvm_vcpu *vcpu,
> >         return reg_to_user(uaddr, &val, id);
> >  }
> >
> > +/*
> > + * Check if the given id indicates AArch32 ID register encoding.
> > + */
> > +static bool is_aarch32_id_reg(u32 id)
> > +{
> > +       u32 crm, op2;
> > +
> > +       if (!is_id_reg(id))
> > +               return false;
> > +
> > +       crm = sys_reg_CRm(id);
> > +       op2 = sys_reg_Op2(id);
> > +       if (crm == 1 || crm == 2 || (crm == 3 && (op2 != 3 && op2 != 7)))
>
> Consistent with the Arm ARM "Table D12-2 System instruction encodings
> for non-Debug System register accesses"
>
> > +               /* AArch32 ID register */
> > +               return true;
> > +
> > +       return false;
> > +}
> > +
> >  static int __set_id_reg(struct kvm_vcpu *vcpu,
> >                         const struct sys_reg_desc *rd, void __user *uaddr,
> >                         bool raz)
> >  {
> >         const u64 id = sys_reg_to_index(rd);
> > +       u32 encoding = reg_to_encoding(rd);
> >         int err;
> >         u64 val;
> >
> > @@ -1250,11 +1432,28 @@ static int __set_id_reg(struct kvm_vcpu *vcpu,
> >         if (err)
> >                 return err;
> >
> > -       /* This is what we mean by invariant: you can't change it. */
> > -       if (val != read_id_reg(vcpu, rd, raz))
> > +       if (val == read_id_reg(vcpu, rd, raz))
> > +               /* The value is same as the current value. Nothing to do. */
> > +               return 0;
> > +
> > +       /*
> > +        * Don't allow to modify the register's value if the register is raz,
> > +        * or the reg doesn't have the id_reg_info.
> > +        */
> > +       if (raz || !GET_ID_REG_INFO(encoding))
> >                 return -EINVAL;
> >
> > -       return 0;
> > +       /*
> > +        * Skip the validation of AArch32 ID registers if the system doesn't
> > +        * 32bit EL0 (their value are UNKNOWN).
> > +        */
> > +       if (system_supports_32bit_el0() || !is_aarch32_id_reg(encoding)) {
> > +               err = validate_id_reg(vcpu, encoding, val);
> > +               if (err)
> > +                       return err;
> > +       }
> > +
> > +       return __write_id_reg(vcpu, encoding, val);
> >  }
> >
> >  static int get_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
> > @@ -2816,6 +3015,20 @@ int kvm_arm_copy_sys_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
> >         return write_demux_regids(uindices);
> >  }
> >
> > +static void id_reg_info_init_all(void)
> > +{
> > +       int i;
> > +       struct id_reg_info *id_reg;
> > +
> > +       for (i = 0; i < ARRAY_SIZE(id_reg_info_table); i++) {
> > +               id_reg = (struct id_reg_info *)id_reg_info_table[i];
> > +               if (!id_reg)
> > +                       continue;
> > +
> > +               id_reg_info_init(id_reg);
> > +       }
> > +}
> > +
> >  void kvm_sys_reg_table_init(void)
> >  {
> >         unsigned int i;
> > @@ -2850,6 +3063,8 @@ void kvm_sys_reg_table_init(void)
> >                         break;
> >         /* Clear all higher bits. */
> >         cache_levels &= (1 << (i*3))-1;
> > +
> > +       id_reg_info_init_all();
> >  }
> >
> >  /*
> > @@ -2862,11 +3077,12 @@ void set_default_id_regs(struct kvm *kvm)
> >         u32 id;
> >         const struct sys_reg_desc *rd;
> >         u64 val;
> > +       struct id_reg_info *idr;
> >
> >         for (i = 0; i < ARRAY_SIZE(sys_reg_descs); i++) {
> >                 rd = &sys_reg_descs[i];
> >                 if (rd->access != access_id_reg)
> > -                       /* Not ID register, or hidden/reserved ID register */
> > +                       /* Not ID register or hidden/reserved ID register */
> >                         continue;
> >
> >                 id = reg_to_encoding(rd);
> > @@ -2874,7 +3090,8 @@ void set_default_id_regs(struct kvm *kvm)
> >                         /* Shouldn't happen */
> >                         continue;
> >
> > -               val = read_sanitised_ftr_reg(id);
> > -               kvm->arch.id_regs[IDREG_IDX(id)] = val;
> > +               idr = GET_ID_REG_INFO(id);
> > +               val = idr ? idr->vcpu_limit_val : read_sanitised_ftr_reg(id);
> > +               (void)write_kvm_id_reg(kvm, id, val);
>
> Rather than ignoring the return value of write_kvm_id_reg(), wouldn't
> it be better if set_default_id_regs were to propagate it back to
> kvm_arch_init_vm in case there's a problem?

Since write_kvm_id_reg() should never return an error for this
case, returning an error to kvm_arch_init_vm() adds a practically
unnecessary error handling, which I would like to avoid.
So, how about putting WARN_ON_ONCE on its return value ?

Thanks,
Reiji
