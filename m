Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADFF65699C0
	for <lists+kvm@lfdr.de>; Thu,  7 Jul 2022 07:17:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234936AbiGGFRJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jul 2022 01:17:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234919AbiGGFRE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jul 2022 01:17:04 -0400
Received: from mail-vs1-xe35.google.com (mail-vs1-xe35.google.com [IPv6:2607:f8b0:4864:20::e35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24C1E31234
        for <kvm@vger.kernel.org>; Wed,  6 Jul 2022 22:17:03 -0700 (PDT)
Received: by mail-vs1-xe35.google.com with SMTP id o185so4692752vsc.7
        for <kvm@vger.kernel.org>; Wed, 06 Jul 2022 22:17:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=78VvqqeGGhzujgkUxwnpYoL4c4XN7DDS4lxQpLU4nvU=;
        b=ngY6+5JOojjN1GcAOXKIFriMglWIoZmmf2cAlLrGPALF+QbWeW/0XbSEf+TZ97Dux5
         lqb/41JuwsCNPoTiLutzeCXYgRWssDCNgaZzS7JWvvLUXJ6XmV6vgcO1KdyBfi7iYq+9
         R5RAAulKwm7Qm7F/YQlcCvzyo1eYkh4Gdf+hxkZ1X9pXguLgq9VxsIMFaxivEakSLHLj
         83Y8iU5YIbnIxVDRaRMpkt9TdiXrxq7skete619N+rnNdR//vgHFc0TGJw0gNqXeeOd6
         sNiR2MZdOst8QL5Gb0mn0mc0a7hQvLuPCrRvlwO6BHGoyaG8bYqefNKOTCZrgRQTcYXU
         g8WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=78VvqqeGGhzujgkUxwnpYoL4c4XN7DDS4lxQpLU4nvU=;
        b=DUUMXMwHn4wr9bqKz+3+vemUP2oT8hdVAUpre0WjjxasX/w9d5BRPJhZSFcbm3pQ6K
         twQ4PCBAzcCHDwpNOnHaFwxPX5Oyg0iKxmo6tybu39Y4efMcMFtFecZ01Y3TAstP8RZQ
         RDst2ujaE2WxgBNXn8XLSpBPVniia6fPBsRV/LwwqaZeWYgIr+Mip1/8+KeEyeGE5pgN
         ZulLrC5XJr2hPpxhevvBdxb/PTefF8HC8/jOy71HwZd1RwhJ7JBWiKFXfc19N+rVhKsz
         EZSzR4A4i0kr9yeM9ppR3tF6SKX9iXns6J3P1uCsZkxkADBTTUIpipbS22ORRmYjaGh/
         vLCA==
X-Gm-Message-State: AJIora8IFPwEV62L6l6vhY4QvjNT8LJjnhMD1cXYm3HKLGzd5zsvtj6h
        mheFrUrt60cnpctvvDwwZ1xNRI218arcOASkAC80gA==
X-Google-Smtp-Source: AGRyM1vVS0K94KTjakbjtLBu0kFtsRQN9XX9G7FKNJYewAaeG6AxXLcIw9hRoUT38sLaanq1PHd8w9CVjEDhyese92s=
X-Received: by 2002:a67:f553:0:b0:357:c2b:8408 with SMTP id
 z19-20020a67f553000000b003570c2b8408mr4591742vsn.51.1657171021509; Wed, 06
 Jul 2022 22:17:01 -0700 (PDT)
MIME-Version: 1.0
References: <20220706164304.1582687-1-maz@kernel.org> <20220706164304.1582687-2-maz@kernel.org>
 <CAAeT=FzLaOnHP51SedG-0C8H90UPEtW+qLm2L2k_73hu66fSwg@mail.gmail.com>
In-Reply-To: <CAAeT=FzLaOnHP51SedG-0C8H90UPEtW+qLm2L2k_73hu66fSwg@mail.gmail.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Wed, 6 Jul 2022 22:16:45 -0700
Message-ID: <CAAeT=Fwd0Vq6J6SN_-kfAJgqbVzJV-j2oP4q1MLrNy_0Prvriw@mail.gmail.com>
Subject: Re: [PATCH 01/19] KVM: arm64: Add get_reg_by_id() as a sys_reg_desc
 retrieving helper
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

On Wed, Jul 6, 2022 at 9:05 PM Reiji Watanabe <reijiw@google.com> wrote:
>
> Hi Marc,
>
> On Wed, Jul 6, 2022 at 9:43 AM Marc Zyngier <maz@kernel.org> wrote:
> >
> > find_reg_by_id() requires a sys_reg_param as input, which most
> > users provide as a on-stack variable, but don't make any use of
> > the result.
> >
> > Provide a helper that doesn't have this requirement and simplify
> > the callers (all but one).
> >
> > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > ---
> >  arch/arm64/kvm/sys_regs.c        | 28 +++++++++++++++++-----------
> >  arch/arm64/kvm/sys_regs.h        |  4 ++++
> >  arch/arm64/kvm/vgic-sys-reg-v3.c |  8 ++------
> >  3 files changed, 23 insertions(+), 17 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index c06c0477fab5..1f410283c592 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -2650,21 +2650,29 @@ const struct sys_reg_desc *find_reg_by_id(u64 id,
> >         return find_reg(params, table, num);
> >  }
> >
> > +const struct sys_reg_desc *get_reg_by_id(u64 id,
> > +                                        const struct sys_reg_desc table[],
> > +                                        unsigned int num)
> > +{
> > +       struct sys_reg_params params;
> > +
> > +       if (!index_to_params(id, &params))
> > +               return NULL;
> > +
> > +       return find_reg(&params, table, num);
> > +}
>
> Since all the callers of get_reg_id() specify ARRAY_SIZE(array) for
> the 3rd argument, and I think future callers of it are also likely to
> do the same, perhaps it might be more convenient if we make get_reg_id()
> a wrapper macro like below (and rename "get_reg_by_id()" to
> "__get_reg_by_id()") ?
>
> #define get_reg_id(id, table)   __get_reg_id(id, table, ARRAY_SIZE(table))

Looking at the following patches, let me withdraw this comment... Instead,

Reviewed-by: Reiji Watanabe <reijiw@google.com>

Thank you,
Reiji


>
> > +
> >  /* Decode an index value, and find the sys_reg_desc entry. */
> >  static const struct sys_reg_desc *index_to_sys_reg_desc(struct kvm_vcpu *vcpu,
> >                                                     u64 id)
> >  {
> >         const struct sys_reg_desc *r;
> > -       struct sys_reg_params params;
> >
> >         /* We only do sys_reg for now. */
> >         if ((id & KVM_REG_ARM_COPROC_MASK) != KVM_REG_ARM64_SYSREG)
> >                 return NULL;
> >
> > -       if (!index_to_params(id, &params))
> > -               return NULL;
> > -
> > -       r = find_reg(&params, sys_reg_descs, ARRAY_SIZE(sys_reg_descs));
> > +       r = get_reg_by_id(id, sys_reg_descs, ARRAY_SIZE(sys_reg_descs));
> >
> >         /* Not saved in the sys_reg array and not otherwise accessible? */
> >         if (r && !(r->reg || r->get_user))
> > @@ -2723,11 +2731,10 @@ static int reg_to_user(void __user *uaddr, const u64 *val, u64 id)
> >
> >  static int get_invariant_sys_reg(u64 id, void __user *uaddr)
> >  {
> > -       struct sys_reg_params params;
> >         const struct sys_reg_desc *r;
> >
> > -       r = find_reg_by_id(id, &params, invariant_sys_regs,
> > -                          ARRAY_SIZE(invariant_sys_regs));
> > +       r = get_reg_by_id(id, invariant_sys_regs,
> > +                         ARRAY_SIZE(invariant_sys_regs));
> >         if (!r)
> >                 return -ENOENT;
> >
> > @@ -2736,13 +2743,12 @@ static int get_invariant_sys_reg(u64 id, void __user *uaddr)
> >
> >  static int set_invariant_sys_reg(u64 id, void __user *uaddr)
> >  {
> > -       struct sys_reg_params params;
> >         const struct sys_reg_desc *r;
> >         int err;
> >         u64 val = 0; /* Make sure high bits are 0 for 32-bit regs */
> >
> > -       r = find_reg_by_id(id, &params, invariant_sys_regs,
> > -                          ARRAY_SIZE(invariant_sys_regs));
> > +       r = get_reg_by_id(id, invariant_sys_regs,
> > +                         ARRAY_SIZE(invariant_sys_regs));
> >         if (!r)
> >                 return -ENOENT;
> >
> > diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
> > index aee8ea054f0d..ce30ed9566ae 100644
> > --- a/arch/arm64/kvm/sys_regs.h
> > +++ b/arch/arm64/kvm/sys_regs.h
> > @@ -195,6 +195,10 @@ const struct sys_reg_desc *find_reg_by_id(u64 id,
> >                                           const struct sys_reg_desc table[],
> >                                           unsigned int num);
> >
> > +const struct sys_reg_desc *get_reg_by_id(u64 id,
> > +                                        const struct sys_reg_desc table[],
> > +                                        unsigned int num);
> > +
> >  #define AA32(_x)       .aarch32_map = AA32_##_x
> >  #define Op0(_x)        .Op0 = _x
> >  #define Op1(_x)        .Op1 = _x
> > diff --git a/arch/arm64/kvm/vgic-sys-reg-v3.c b/arch/arm64/kvm/vgic-sys-reg-v3.c
> > index 07d5271e9f05..644acda33c7c 100644
> > --- a/arch/arm64/kvm/vgic-sys-reg-v3.c
> > +++ b/arch/arm64/kvm/vgic-sys-reg-v3.c
> > @@ -263,14 +263,10 @@ static const struct sys_reg_desc gic_v3_icc_reg_descs[] = {
> >  int vgic_v3_has_cpu_sysregs_attr(struct kvm_vcpu *vcpu, bool is_write, u64 id,
> >                                 u64 *reg)
> >  {
> > -       struct sys_reg_params params;
> >         u64 sysreg = (id & KVM_DEV_ARM_VGIC_SYSREG_MASK) | KVM_REG_SIZE_U64;
> >
> > -       params.regval = *reg;
> > -       params.is_write = is_write;
> > -
> > -       if (find_reg_by_id(sysreg, &params, gic_v3_icc_reg_descs,
> > -                             ARRAY_SIZE(gic_v3_icc_reg_descs)))
> > +       if (get_reg_by_id(sysreg, gic_v3_icc_reg_descs,
> > +                         ARRAY_SIZE(gic_v3_icc_reg_descs)))
> >                 return 0;
> >
> >         return -ENXIO;
> > --
> > 2.34.1
> >
> > _______________________________________________
> > kvmarm mailing list
> > kvmarm@lists.cs.columbia.edu
> > https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
