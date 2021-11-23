Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D0A1459CC0
	for <lists+kvm@lfdr.de>; Tue, 23 Nov 2021 08:27:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234128AbhKWHaj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Nov 2021 02:30:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234130AbhKWHaf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Nov 2021 02:30:35 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C97AC061714
        for <kvm@vger.kernel.org>; Mon, 22 Nov 2021 23:27:28 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id y7so16357231plp.0
        for <kvm@vger.kernel.org>; Mon, 22 Nov 2021 23:27:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=a/jOJfBxYMr68LtaWMzzCSnglAw6mPj5RWwAjR4ErlI=;
        b=NQ1ROgk2G2jDnMoiOljzW5fB/BLOzDTCFmMn8rpKthuf8Vw7NYRDAzKsVxJPTxWQ8c
         BK68yEDLbG3ieVCQZVtDuWmQDpXtnT1/kUJvucVsCsb4iENGD7kPracmHmOJRp6uwEx7
         KguhK0IQ2LA0uFh/alvWAqbKk3QO4vaoV3Wn3qRlBoNk5rlFLzWA4HSoDDAPFKtTt22/
         SXMZxCzigEeo7/1sEQN9xZrw7gbj3NyaEOCdnmNLvHUOG5fRCF2B1ej2DAaKEQ7s+bpk
         DTmwLefwHv9yzWz7bCOFnxKP34L9REWt1+I1qaX2vnbWCjze2xaLSdCKJQpUX2HQGTBt
         4WZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=a/jOJfBxYMr68LtaWMzzCSnglAw6mPj5RWwAjR4ErlI=;
        b=Om9Lo3fmhpFzgRXlzpdF/eZ0cxIg9CBBFCEu8OPpmgmG8x/ASbGjlsLePBKlgoZLqj
         E0KfkJnZu85+GFWL0p6m+3tzrzqq9lLD5pMBVzI8MzHcvqtFpwFXH2OHSMTq/IKuQrt2
         fG4+13Yv1poQjyYcMFSMOXxAEtIhipnjE4/4iO0tL6HrLnm44L6/jbeSBgGwkazM7JgT
         3lP1hoR1mrdZbGnJKgmLzbHHV8XJ9SbJZ+1ydc3EtPNi/YBUHwHxt3ij8+tEUywB6yHV
         5X3z/GiIYKWGAl/Utfk/KIdEGxlvIrXCNHStfmUduFGW9S4TaqkSrKam4MNRdbkgfmM/
         AX2Q==
X-Gm-Message-State: AOAM532jkcHFCIfAeXpqgR2eVhaP639114pPcf/JN5LCciQI7VLRyj7d
        dFqUMperjHXpQjFh0huPzxX9wFIsO5kz7i92uK1ZxQ==
X-Google-Smtp-Source: ABdhPJwf2G6YVg5t9TnlP39xMAJPWzYB0UD9y46tt/9WhaJq6sdYAgKUCg4C4rPKJyzryOyEpQIRjjMs7b1E1l75meU=
X-Received: by 2002:a17:90b:380d:: with SMTP id mq13mr428792pjb.110.1637652447274;
 Mon, 22 Nov 2021 23:27:27 -0800 (PST)
MIME-Version: 1.0
References: <20211117064359.2362060-1-reijiw@google.com> <20211117064359.2362060-22-reijiw@google.com>
 <87fsrps5wu.wl-maz@kernel.org>
In-Reply-To: <87fsrps5wu.wl-maz@kernel.org>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Mon, 22 Nov 2021 23:27:11 -0800
Message-ID: <CAAeT=Fwyr_KAwj5d3feiV1iw8fqSAy3Mz43d6diuOkSjg+Cmcg@mail.gmail.com>
Subject: Re: [RFC PATCH v3 21/29] KVM: arm64: Introduce framework to trap
 disabled features
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        Peng Liang <liangpeng10@huawei.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Nov 21, 2021 at 10:46 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Wed, 17 Nov 2021 06:43:51 +0000,
> Reiji Watanabe <reijiw@google.com> wrote:
> >
> > When a CPU feature that is supported on the host is not exposed to
> > its guest, emulating a real CPU's behavior (by trapping or disabling
> > guest's using the feature) is generally a desirable behavior (when
> > it's possible without any or little side effect).
> >
> > Introduce feature_config_ctrl structure, which manages feature
> > information to program configuration register to trap or disable
> > the feature when the feature is not exposed to the guest, and
> > functions that uses the structure to activate trapping the feature.
> >
> > At present, no feature has feature_config_ctrl yet and the following
> > patches will add the feature_config_ctrl for several features.
> >
> > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > ---
> >  arch/arm64/kvm/sys_regs.c | 121 +++++++++++++++++++++++++++++++++++++-
> >  1 file changed, 120 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index 2f96103fc0d2..501de08dacb7 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -376,8 +376,38 @@ static int arm64_check_features(u64 check_types, u64 val, u64 lim)
> >       (cpuid_feature_extract_unsigned_field(val, ID_AA64ISAR1_GPI_SHIFT) >= \
> >        ID_AA64ISAR1_GPI_IMP_DEF)
> >
> > +enum vcpu_config_reg {
> > +     VCPU_HCR_EL2 = 1,
> > +     VCPU_MDCR_EL2,
> > +     VCPU_CPTR_EL2,
> > +};
> > +
> > +/*
> > + * Feature information to program configuration register to trap or disable
> > + * guest's using a feature when the feature is not exposed to the guest.
> > + */
> > +struct feature_config_ctrl {
> > +     /* ID register/field for the feature */
> > +     u32     ftr_reg;        /* ID register */
> > +     bool    ftr_signed;     /* Is the feature field signed ? */
> > +     u8      ftr_shift;      /* Field of ID register for the feature */
> > +     s8      ftr_min;        /* Min value that indicate the feature */
> > +
> > +     /*
> > +      * Function to check trapping is needed. This is used when the above
> > +      * fields are not enough to determine if trapping is needed.
> > +      */
> > +     bool    (*ftr_need_trap)(struct kvm_vcpu *vcpu);
> > +
> > +     /* Configuration register information to trap the feature. */
> > +     enum vcpu_config_reg cfg_reg;   /* Configuration register */
> > +     u64     cfg_mask;       /* Field of the configuration register */
> > +     u64     cfg_val;        /* Value that are set for the field */
>
> Although this probably works for the use cases you have in mind, some
> trap bits are actually working the other way around (clear to trap).
> So you probably want to turn this into cfg_set and add a cfg_clear for
> a good measure, dropping cfg_mask in the process.

Although I was aware of both of the cases (cfg_clear is implicitly
derived from cfg_mask ~ cfg_set), I agree that dropping cfg_mask and
adding cfg_clear would be more explicit and nicer.

> That being said, the current trend is to move to FGT, meaning that a
> single register is unlikely to cut it in the long run. I'd rather you
> simply have a configuration function here (and the helper you already
> have is probably enough).

Thank you for the nice suggestion ! That's a good point (I didn't pay
attention to FGT yet).  I will look into having a configuration function
here.

> > +};
> > +
> >  struct id_reg_info {
> >       u32     sys_reg;        /* Register ID */
> > +     u64     sys_val;        /* Sanitized system value */
> >
> >       /*
> >        * Limit value of the register for a vcpu. The value is the sanitized
> > @@ -410,11 +440,15 @@ struct id_reg_info {
> >       /* Return the reset value of the register for the vCPU */
> >       u64 (*get_reset_val)(struct kvm_vcpu *vcpu,
> >                            const struct id_reg_info *id_reg);
> > +
> > +     /* Information to trap features that are disabled for the guest */
> > +     const struct feature_config_ctrl *(*trap_features)[];
> >  };
> >
> >  static void id_reg_info_init(struct id_reg_info *id_reg)
> >  {
> > -     id_reg->vcpu_limit_val = read_sanitised_ftr_reg(id_reg->sys_reg);
> > +     id_reg->sys_val = read_sanitised_ftr_reg(id_reg->sys_reg);
> > +     id_reg->vcpu_limit_val = id_reg->sys_val;
> >       if (id_reg->init)
> >               id_reg->init(id_reg);
> >  }
> > @@ -952,6 +986,47 @@ static int validate_id_reg(struct kvm_vcpu *vcpu,
> >       return err;
> >  }
> >
> > +static void feature_trap_activate(struct kvm_vcpu *vcpu,
> > +                               const struct feature_config_ctrl *config)
> > +{
> > +     u64 *reg_ptr, reg_val;
> > +
> > +     switch (config->cfg_reg) {
> > +     case VCPU_HCR_EL2:
> > +             reg_ptr = &vcpu->arch.hcr_el2;
> > +             break;
> > +     case VCPU_MDCR_EL2:
> > +             reg_ptr = &vcpu->arch.mdcr_el2;
> > +             break;
> > +     case VCPU_CPTR_EL2:
> > +             reg_ptr = &vcpu->arch.cptr_el2;
> > +             break;
> > +     }
> > +
> > +     /* Update cfg_mask fields with cfg_val */
> > +     reg_val = (*reg_ptr & ~config->cfg_mask);
> > +     reg_val |= config->cfg_val;
> > +     *reg_ptr = reg_val;
> > +}
> > +
> > +static inline bool feature_avail(const struct feature_config_ctrl *ctrl,
> > +                              u64 id_val)
> > +{
> > +     int field_val = cpuid_feature_extract_field(id_val,
> > +                             ctrl->ftr_shift, ctrl->ftr_signed);
> > +
> > +     return (field_val >= ctrl->ftr_min);
> > +}
> > +
> > +static inline bool vcpu_feature_is_available(struct kvm_vcpu *vcpu,
> > +                                     const struct feature_config_ctrl *ctrl)
> > +{
> > +     u64 val;
> > +
> > +     val = __read_id_reg(vcpu, ctrl->ftr_reg);
> > +     return feature_avail(ctrl, val);
> > +}
> > +
> >  /*
> >   * ARMv8.1 mandates at least a trivial LORegion implementation, where all the
> >   * RW registers are RES0 (which we can implement as RAZ/WI). On an ARMv8.0
> > @@ -1831,6 +1906,42 @@ static int reg_from_user(u64 *val, const void __user *uaddr, u64 id);
> >  static int reg_to_user(void __user *uaddr, const u64 *val, u64 id);
> >  static u64 sys_reg_to_index(const struct sys_reg_desc *reg);
> >
> > +static void id_reg_features_trap_activate(struct kvm_vcpu *vcpu,
> > +                                       const struct id_reg_info *id_reg)
> > +{
> > +     u64 val;
> > +     int i = 0;
> > +     const struct feature_config_ctrl **ctrlp_array, *ctrl;
> > +
> > +     if (!id_reg || !id_reg->trap_features)
> > +             /* No information to trap a feature */
> > +             return;
> > +
> > +     val = __read_id_reg(vcpu, id_reg->sys_reg);
> > +     if (val == id_reg->sys_val)
> > +             /* No feature needs to be trapped (no feature is disabled). */
> > +             return;
> > +
> > +     ctrlp_array = *id_reg->trap_features;
> > +     while ((ctrl = ctrlp_array[i++]) != NULL) {
> > +             if (ctrl->ftr_need_trap && ctrl->ftr_need_trap(vcpu)) {
> > +                     feature_trap_activate(vcpu, ctrl);
> > +                     continue;
> > +             }
> > +
> > +             if (!feature_avail(ctrl, id_reg->sys_val))
> > +                     /* The feature is not supported on the host. */
> > +                     continue;
> > +
> > +             if (feature_avail(ctrl, val))
> > +                     /* The feature is enabled for the guest. */
> > +                     continue;
> > +
> > +             /* The feature is supported but disabled. */
> > +             feature_trap_activate(vcpu, ctrl);
> > +     }
> > +}
> > +
> >  /* Visibility overrides for SVE-specific control registers */
> >  static unsigned int sve_visibility(const struct kvm_vcpu *vcpu,
> >                                  const struct sys_reg_desc *rd)
> > @@ -3457,6 +3568,14 @@ int kvm_arm_copy_sys_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
> >       return write_demux_regids(uindices);
> >  }
> >
> > +void kvm_vcpu_init_traps(struct kvm_vcpu *vcpu)
>
> Who is going to call this? At which point? Please document the use
> constraints on this.

kvm_vcpu_first_run_init() is going to call it (for non-pKVM).
I will document the use constraints on that.

Thanks,
Reiji
