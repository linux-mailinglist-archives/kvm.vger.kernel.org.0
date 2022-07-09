Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6153F56C79C
	for <lists+kvm@lfdr.de>; Sat,  9 Jul 2022 08:55:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbiGIGza (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 9 Jul 2022 02:55:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiGIGz3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 9 Jul 2022 02:55:29 -0400
Received: from mail-ua1-x933.google.com (mail-ua1-x933.google.com [IPv6:2607:f8b0:4864:20::933])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9165568737
        for <kvm@vger.kernel.org>; Fri,  8 Jul 2022 23:55:25 -0700 (PDT)
Received: by mail-ua1-x933.google.com with SMTP id c7so253401uak.1
        for <kvm@vger.kernel.org>; Fri, 08 Jul 2022 23:55:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=z370ap4icG/n0mxZ/T8cY/FFE6FKmCsSpzWEo9sy9Uk=;
        b=F87ojCFIut+zTKYaLJ0ZxMChAgHzHvxOOO6h2bQ925a4NvkKaAyTF3aYtl2/zaL9px
         Lh/IN/v3B/yhyyn7IYThNntoHuB+ySUclxZXH9ismhSFSSNb89AirHeO9qzIf8ZAh/G/
         d2bEyUFbr22oUHqjGrXx2iiqgu1Ek8s6yD8bQFyNnsF5JRL8SXG4EOvEJmP44bb09AB/
         tMZMH34tEXC4//owLG+FRaLiE71Ivq4vF/qJrs+c2CdPQq5F8lswEB4zniNONvRV0ShR
         0mhTLOPSreJhONNoBw9Jy63tr7JuU+26ojQp55xDJcEFehApDNSIr01Um9euCFh3v0pU
         n8Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=z370ap4icG/n0mxZ/T8cY/FFE6FKmCsSpzWEo9sy9Uk=;
        b=n6/qui4gl1jPRJ9glyrAGUooa7F7fhDY5sPFFng24WvplK+i5VzdX9kphYNkTxCMtH
         tlK0BZT75Rxtb+0jZUFnMURDFwtLOjclj+QKrVkw3kGI7KrzQCqVXgxNN+9ulSFwgNHU
         TIweRw1WRSb4iEtN/dQ4Ak+GhRcXcTSN5RbEJuPIqPy38NItmYEHR77RdsjkwURVKSnG
         ZEVqAOVc3ttMn0+ArkhfSHefDnAQpmcAiA9xZdfh2dRgEzIo8kdoFc4dBbIqLifn6nJR
         r3Us9lj+zhvvu8b0ytopr8gnVzK+CtpozlpDUPZVT0+jRsK1Sh9xfv0rnTI6g9FMZz0G
         Nf9g==
X-Gm-Message-State: AJIora9XrHv8jgarZlfKYrPwDE3EyswLYyRFcdpPmTUiXtY3yROSZjY7
        CSOkNkpT14+yW135dwID55bda46igThLmT5KTp/jzVFFbnuldw==
X-Google-Smtp-Source: AGRyM1uD59U9cfBJ0MdM/PafhlqeV+I3o0BpWowt3O+nRXcoB5eL6fWMp4RjnDA43VjT+2YgHYDFcRR1MvktnwREJew=
X-Received: by 2002:a05:6130:90:b0:362:891c:edef with SMTP id
 x16-20020a056130009000b00362891cedefmr3019255uaf.106.1657349724506; Fri, 08
 Jul 2022 23:55:24 -0700 (PDT)
MIME-Version: 1.0
References: <20220706164304.1582687-1-maz@kernel.org> <20220706164304.1582687-6-maz@kernel.org>
In-Reply-To: <20220706164304.1582687-6-maz@kernel.org>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Fri, 8 Jul 2022 23:55:08 -0700
Message-ID: <CAAeT=FzW78rn-_rXRg2t_RpwBQ1Ap-ugtqE-vb-P6YyGO++VRA@mail.gmail.com>
Subject: Re: [PATCH 05/19] KVM: arm64: Consolidate sysreg userspace accesses
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Schspa Shi <schspa@gmail.com>, kernel-team@android.com,
        Oliver Upton <oliver.upton@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-15.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URI_DOTEDU,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On Wed, Jul 6, 2022 at 9:43 AM Marc Zyngier <maz@kernel.org> wrote:
>
> Until now, the .set_user and .get_user callbacks have to implement
> (directly or not) the userspace memory accesses. Although this gives
> us maximem flexibility, this is also a maintenance burden, making it
> hard to audit, and I'd feel much better if it was all located in
> a single place.
>
> So let's do just that, simplifying most of the function signatures
> in the process (the callbacks are now only concerned with the
> data itself, and not with userspace).
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/sys_regs.c | 162 ++++++++++++++------------------------
>  arch/arm64/kvm/sys_regs.h |   4 +-
>  2 files changed, 63 insertions(+), 103 deletions(-)
>
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 89e7eddea937..1ce439eed3d8 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -321,16 +321,8 @@ static bool trap_oslsr_el1(struct kvm_vcpu *vcpu,
>  }
>
>  static int set_oslsr_el1(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
> -                        const struct kvm_one_reg *reg, void __user *uaddr)
> +                        u64 val)
>  {
> -       u64 id = sys_reg_to_index(rd);
> -       u64 val;
> -       int err;
> -
> -       err = reg_from_user(&val, uaddr, id);
> -       if (err)
> -               return err;
> -
>         /*
>          * The only modifiable bit is the OSLK bit. Refuse the write if
>          * userspace attempts to change any other bit in the register.
> @@ -451,22 +443,16 @@ static bool trap_bvr(struct kvm_vcpu *vcpu,
>  }
>
>  static int set_bvr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
> -               const struct kvm_one_reg *reg, void __user *uaddr)
> +                  u64 val)
>  {
> -       __u64 *r = &vcpu->arch.vcpu_debug_state.dbg_bvr[rd->CRm];
> -
> -       if (copy_from_user(r, uaddr, KVM_REG_SIZE(reg->id)) != 0)
> -               return -EFAULT;
> +       vcpu->arch.vcpu_debug_state.dbg_bvr[rd->CRm] = val;
>         return 0;
>  }
>
>  static int get_bvr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
> -       const struct kvm_one_reg *reg, void __user *uaddr)
> +                  u64 *val)
>  {
> -       __u64 *r = &vcpu->arch.vcpu_debug_state.dbg_bvr[rd->CRm];
> -
> -       if (copy_to_user(uaddr, r, KVM_REG_SIZE(reg->id)) != 0)
> -               return -EFAULT;
> +       *val = vcpu->arch.vcpu_debug_state.dbg_bvr[rd->CRm];
>         return 0;
>  }
>
> @@ -493,23 +479,16 @@ static bool trap_bcr(struct kvm_vcpu *vcpu,
>  }
>
>  static int set_bcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
> -               const struct kvm_one_reg *reg, void __user *uaddr)
> +                  u64 val)
>  {
> -       __u64 *r = &vcpu->arch.vcpu_debug_state.dbg_bcr[rd->CRm];
> -
> -       if (copy_from_user(r, uaddr, KVM_REG_SIZE(reg->id)) != 0)
> -               return -EFAULT;
> -
> +       vcpu->arch.vcpu_debug_state.dbg_bcr[rd->CRm] = val;
>         return 0;
>  }
>
>  static int get_bcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
> -       const struct kvm_one_reg *reg, void __user *uaddr)
> +                  u64 *val)
>  {
> -       __u64 *r = &vcpu->arch.vcpu_debug_state.dbg_bcr[rd->CRm];
> -
> -       if (copy_to_user(uaddr, r, KVM_REG_SIZE(reg->id)) != 0)
> -               return -EFAULT;
> +       *val = vcpu->arch.vcpu_debug_state.dbg_bcr[rd->CRm];
>         return 0;
>  }
>
> @@ -537,22 +516,16 @@ static bool trap_wvr(struct kvm_vcpu *vcpu,
>  }
>
>  static int set_wvr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
> -               const struct kvm_one_reg *reg, void __user *uaddr)
> +                  u64 val)
>  {
> -       __u64 *r = &vcpu->arch.vcpu_debug_state.dbg_wvr[rd->CRm];
> -
> -       if (copy_from_user(r, uaddr, KVM_REG_SIZE(reg->id)) != 0)
> -               return -EFAULT;
> +       vcpu->arch.vcpu_debug_state.dbg_wvr[rd->CRm] = val;
>         return 0;
>  }
>
>  static int get_wvr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
> -       const struct kvm_one_reg *reg, void __user *uaddr)
> +                  u64 *val)
>  {
> -       __u64 *r = &vcpu->arch.vcpu_debug_state.dbg_wvr[rd->CRm];
> -
> -       if (copy_to_user(uaddr, r, KVM_REG_SIZE(reg->id)) != 0)
> -               return -EFAULT;
> +       *val = vcpu->arch.vcpu_debug_state.dbg_wvr[rd->CRm];
>         return 0;
>  }
>
> @@ -579,22 +552,16 @@ static bool trap_wcr(struct kvm_vcpu *vcpu,
>  }
>
>  static int set_wcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
> -               const struct kvm_one_reg *reg, void __user *uaddr)
> +                  u64 val)
>  {
> -       __u64 *r = &vcpu->arch.vcpu_debug_state.dbg_wcr[rd->CRm];
> -
> -       if (copy_from_user(r, uaddr, KVM_REG_SIZE(reg->id)) != 0)
> -               return -EFAULT;
> +       vcpu->arch.vcpu_debug_state.dbg_wcr[rd->CRm] = val;
>         return 0;
>  }
>
>  static int get_wcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
> -       const struct kvm_one_reg *reg, void __user *uaddr)
> +                  u64 *val)
>  {
> -       __u64 *r = &vcpu->arch.vcpu_debug_state.dbg_wcr[rd->CRm];
> -
> -       if (copy_to_user(uaddr, r, KVM_REG_SIZE(reg->id)) != 0)
> -               return -EFAULT;
> +       *val = vcpu->arch.vcpu_debug_state.dbg_wcr[rd->CRm];
>         return 0;
>  }
>
> @@ -1227,16 +1194,9 @@ static unsigned int sve_visibility(const struct kvm_vcpu *vcpu,
>
>  static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
>                                const struct sys_reg_desc *rd,
> -                              const struct kvm_one_reg *reg, void __user *uaddr)
> +                              u64 val)
>  {
> -       const u64 id = sys_reg_to_index(rd);
>         u8 csv2, csv3;
> -       int err;
> -       u64 val;
> -
> -       err = reg_from_user(&val, uaddr, id);
> -       if (err)
> -               return err;
>
>         /*
>          * Allow AA64PFR0_EL1.CSV2 to be set from userspace as long as
> @@ -1262,7 +1222,7 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
>                 return -EINVAL;
>
>         vcpu->kvm->arch.pfr0_csv2 = csv2;
> -       vcpu->kvm->arch.pfr0_csv3 = csv3 ;
> +       vcpu->kvm->arch.pfr0_csv3 = csv3;
>
>         return 0;
>  }
> @@ -1275,27 +1235,17 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
>   * to be changed.
>   */
>  static int __get_id_reg(const struct kvm_vcpu *vcpu,
> -                       const struct sys_reg_desc *rd, void __user *uaddr,
> +                       const struct sys_reg_desc *rd, u64 *val,
>                         bool raz)
>  {
> -       const u64 id = sys_reg_to_index(rd);
> -       const u64 val = read_id_reg(vcpu, rd, raz);
> -
> -       return reg_to_user(uaddr, &val, id);
> +       *val = read_id_reg(vcpu, rd, raz);
> +       return 0;
>  }
>
>  static int __set_id_reg(const struct kvm_vcpu *vcpu,
> -                       const struct sys_reg_desc *rd, void __user *uaddr,
> +                       const struct sys_reg_desc *rd, u64 val,
>                         bool raz)
>  {
> -       const u64 id = sys_reg_to_index(rd);
> -       int err;
> -       u64 val;
> -
> -       err = reg_from_user(&val, uaddr, id);
> -       if (err)
> -               return err;
> -
>         /* This is what we mean by invariant: you can't change it. */
>         if (val != read_id_reg(vcpu, rd, raz))
>                 return -EINVAL;
> @@ -1304,47 +1254,37 @@ static int __set_id_reg(const struct kvm_vcpu *vcpu,
>  }
>
>  static int get_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
> -                     const struct kvm_one_reg *reg, void __user *uaddr)
> +                     u64 *val)
>  {
>         bool raz = sysreg_visible_as_raz(vcpu, rd);
>
> -       return __get_id_reg(vcpu, rd, uaddr, raz);
> +       return __get_id_reg(vcpu, rd, val, raz);
>  }
>
>  static int set_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
> -                     const struct kvm_one_reg *reg, void __user *uaddr)
> +                     u64 val)
>  {
>         bool raz = sysreg_visible_as_raz(vcpu, rd);
>
> -       return __set_id_reg(vcpu, rd, uaddr, raz);
> +       return __set_id_reg(vcpu, rd, val, raz);
>  }
>
>  static int set_raz_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
> -                         const struct kvm_one_reg *reg, void __user *uaddr)
> +                         u64 val)
>  {
> -       return __set_id_reg(vcpu, rd, uaddr, true);
> +       return __set_id_reg(vcpu, rd, val, true);
>  }
>
>  static int get_raz_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
> -                      const struct kvm_one_reg *reg, void __user *uaddr)
> +                      u64 *val)
>  {
> -       const u64 id = sys_reg_to_index(rd);
> -       const u64 val = 0;
> -
> -       return reg_to_user(uaddr, &val, id);
> +       *val = 0;
> +       return 0;
>  }
>
>  static int set_wi_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
> -                     const struct kvm_one_reg *reg, void __user *uaddr)
> +                     u64 val)
>  {
> -       int err;
> -       u64 val;
> -
> -       /* Perform the access even if we are going to ignore the value */
> -       err = reg_from_user(&val, uaddr, sys_reg_to_index(rd));
> -       if (err)
> -               return err;
> -
>         return 0;
>  }
>
> @@ -2854,17 +2794,28 @@ static int demux_c15_set(u64 id, void __user *uaddr)
>  int kvm_sys_reg_get_user(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg,
>                          const struct sys_reg_desc table[], unsigned int num)
>  {
> -       void __user *uaddr = (void __user *)(unsigned long)reg->addr;
> +       u64 __user *uaddr = (u64 __user *)(unsigned long)reg->addr;
>         const struct sys_reg_desc *r;
> +       u64 val;
> +       int ret;
>
>         r = id_to_sys_reg_desc(vcpu, reg->id, table, num);
>         if (!r)
>                 return -ENOENT;
>
> -       if (r->get_user)
> -               return (r->get_user)(vcpu, r, reg, uaddr);
> +       if (r->get_user) {
> +               ret = (r->get_user)(vcpu, r, &val);
> +       } else {
> +               val = __vcpu_sys_reg(vcpu, r->reg);
> +               ret = 0;
> +       }
> +
> +       if (!ret) {
> +               if (put_user(val, uaddr))
> +                       ret = -EFAULT;

Nit: Since put_user() returns -EFAULT when it fails,
we can simply set 'ret' to the return value from put_user().
(same for get_user())

Reviewed-by: Reiji Watanabe <reijiw@google.com>

I like this fix!

Thank you,
Reiji

> +       }
>
> -       return reg_to_user(uaddr, &__vcpu_sys_reg(vcpu, r->reg), reg->id);
> +       return ret;
>  }
>
>  int kvm_arm_sys_reg_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
> @@ -2886,17 +2837,26 @@ int kvm_arm_sys_reg_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg
>  int kvm_sys_reg_set_user(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg,
>                          const struct sys_reg_desc table[], unsigned int num)
>  {
> -       void __user *uaddr = (void __user *)(unsigned long)reg->addr;
> +       u64 __user *uaddr = (u64 __user *)(unsigned long)reg->addr;
>         const struct sys_reg_desc *r;
> +       u64 val;
> +       int ret;
> +
> +       if (get_user(val, uaddr))
> +               return -EFAULT;
>
>         r = id_to_sys_reg_desc(vcpu, reg->id, table, num);
>         if (!r)
>                 return -ENOENT;
>
> -       if (r->set_user)
> -               return (r->set_user)(vcpu, r, reg, uaddr);
> +       if (r->set_user) {
> +               ret = (r->set_user)(vcpu, r, val);
> +       } else {
> +               __vcpu_sys_reg(vcpu, r->reg) = val;
> +               ret = 0;
> +       }
>
> -       return reg_from_user(&__vcpu_sys_reg(vcpu, r->reg), uaddr, reg->id);
> +       return ret;
>  }
>
>  int kvm_arm_sys_reg_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
> diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
> index 4fb6d59e7874..b8b576a2af2b 100644
> --- a/arch/arm64/kvm/sys_regs.h
> +++ b/arch/arm64/kvm/sys_regs.h
> @@ -75,9 +75,9 @@ struct sys_reg_desc {
>
>         /* Custom get/set_user functions, fallback to generic if NULL */
>         int (*get_user)(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
> -                       const struct kvm_one_reg *reg, void __user *uaddr);
> +                       u64 *val);
>         int (*set_user)(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
> -                       const struct kvm_one_reg *reg, void __user *uaddr);
> +                       u64 val);
>
>         /* Return mask of REG_* runtime visibility overrides */
>         unsigned int (*visibility)(const struct kvm_vcpu *vcpu,
> --
> 2.34.1
>
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
