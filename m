Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A04D3572BE2
	for <lists+kvm@lfdr.de>; Wed, 13 Jul 2022 05:26:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230076AbiGMD0o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jul 2022 23:26:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbiGMD0m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jul 2022 23:26:42 -0400
Received: from mail-vs1-xe29.google.com (mail-vs1-xe29.google.com [IPv6:2607:f8b0:4864:20::e29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01281D7BAF
        for <kvm@vger.kernel.org>; Tue, 12 Jul 2022 20:26:41 -0700 (PDT)
Received: by mail-vs1-xe29.google.com with SMTP id a184so9638697vsa.1
        for <kvm@vger.kernel.org>; Tue, 12 Jul 2022 20:26:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AR3QaIao9mO/p4YdLAEYzIRvzFznx99Z3Lqv0urjNsg=;
        b=cb6gWtO72b2+gWXBCLauulQ1qDvYsLGfDQPHpguD3YCCbcf1XRZmO6pbLp/dUnRYvx
         qiuDUikxXyhSqk6heFlW7kCPAzZ5MskhVY2Y7m5xAEPKcZEBaNBixQvitSRV3opKx93k
         c6NmpTgVhqJVC4K+cEDj9o3pdThWt5Zx9HPtYatkhogPR6szn8PzQ5JJLVobNBaODRDb
         tyvwBxc9wVXWP82blIlpCQjZSVzimUKTXT7mfFzdoePJTmFYBddPfUat6i33hHBCgl3E
         XEbG0OF+QRfM5UqlfrRR2Q/kYo6JeRyUuYL2RfpX6IsHB2oXX4PQ0ocmakLyP2MyjaXa
         3kuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AR3QaIao9mO/p4YdLAEYzIRvzFznx99Z3Lqv0urjNsg=;
        b=jM+6y+Odagak08kGkRZEE9vkY5aYFgAPOn8OKjCW8KFNrBzs8fGcjWFFn4wmOfw2RG
         ox7B9Fh4ha9kay+Hvs6HphMJDCcF34tpa6Gdre6jp6G0Yg5ESFBlgA19+XmCNNQ+cjlW
         zJgei3OGyFEYI1fhdZqBrNbInNNekVYISx0yjS/7jZcZkISwHE7nBXu+4ySaysP8o6Cd
         8o3ePj5wS8k19splLaLkwxeF6KyzE4DicSfAP1mj4BjuwNDRiA5DdN5ll+10u58iH/S/
         m3NbLZ2x/7OlUkYjNqkRCaWMbpabG6h7+btnLQpjllk1JE1vdQt6+AuPmBNtqTVKBq7H
         eK5w==
X-Gm-Message-State: AJIora9AD5na+hv/L1qMembOXSs8acmwsxoUy5aCt2DHJC/k2UA7JiDb
        8xKd7hvBvB4p4t+u2DR/ibyUUFTmuoepUy8iOcZMSQ==
X-Google-Smtp-Source: AGRyM1t0+V+0cd6RVuIv7tYDAX7GWIE1E/REliha3hmKY0fSVPhu9p51yGGjSqwp+FbrIQ8Td+Rt9gRGyTrjwa9Yvyk=
X-Received: by 2002:a67:b24c:0:b0:356:c997:1cf0 with SMTP id
 s12-20020a67b24c000000b00356c9971cf0mr354014vsh.9.1657682801039; Tue, 12 Jul
 2022 20:26:41 -0700 (PDT)
MIME-Version: 1.0
References: <20220706164304.1582687-1-maz@kernel.org> <20220706164304.1582687-9-maz@kernel.org>
 <CAAeT=FwLxFnVq3T313CM__5j9e1d-5rRDeTwdZVqsbX0LM3ywA@mail.gmail.com> <87fsj6lt4s.wl-maz@kernel.org>
In-Reply-To: <87fsj6lt4s.wl-maz@kernel.org>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Tue, 12 Jul 2022 20:26:25 -0700
Message-ID: <CAAeT=FwQtyfKPWfSz4jzY4nAssqxoFJ2HkWsEcKedvgBGckqQw@mail.gmail.com>
Subject: Re: [PATCH 08/19] KVM: arm64: vgic-v3: Push user access into vgic_v3_cpu_sysregs_uaccess()
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Schspa Shi <schspa@gmail.com>, kernel-team@android.com,
        Oliver Upton <oliver.upton@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On Mon, Jul 11, 2022 at 11:53 PM Marc Zyngier <maz@kernel.org> wrote:
>
> Hi Reiji,
>
> On Tue, 12 Jul 2022 07:11:39 +0100,
> Reiji Watanabe <reijiw@google.com> wrote:
> >
> > Hi Marc,
> >
> > On Wed, Jul 6, 2022 at 9:43 AM Marc Zyngier <maz@kernel.org> wrote:
> > >
> > > In order to start making the vgic sysreg access from userspace
> > > similar to all the other sysregs, push the userspace memory
> > > access one level down into vgic_v3_cpu_sysregs_uaccess().
> > >
> > > The next step will be to rely on the sysreg infrastructure
> > > to perform this task.
> > >
> > > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > > ---
> > >  arch/arm64/kvm/vgic-sys-reg-v3.c      | 22 +++++++++++++------
> > >  arch/arm64/kvm/vgic/vgic-kvm-device.c | 31 ++++++---------------------
> > >  arch/arm64/kvm/vgic/vgic.h            |  4 ++--
> > >  3 files changed, 23 insertions(+), 34 deletions(-)
> > >
> > > diff --git a/arch/arm64/kvm/vgic-sys-reg-v3.c b/arch/arm64/kvm/vgic-sys-reg-v3.c
> > > index 85a5e1d15e9f..8c56e285fde9 100644
> > > --- a/arch/arm64/kvm/vgic-sys-reg-v3.c
> > > +++ b/arch/arm64/kvm/vgic-sys-reg-v3.c
> > > @@ -278,15 +278,21 @@ int vgic_v3_has_cpu_sysregs_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *
> > >         return -ENXIO;
> > >  }
> > >
> > > -int vgic_v3_cpu_sysregs_uaccess(struct kvm_vcpu *vcpu, bool is_write, u64 id,
> > > -                               u64 *reg)
> > > +int vgic_v3_cpu_sysregs_uaccess(struct kvm_vcpu *vcpu,
> > > +                               struct kvm_device_attr *attr,
> > > +                               bool is_write)
> > >  {
> > > +       u64 __user *uaddr = (u64 __user *)(long)attr->addr;
> > >         struct sys_reg_params params;
> > >         const struct sys_reg_desc *r;
> > > -       u64 sysreg = (id & KVM_DEV_ARM_VGIC_SYSREG_MASK) | KVM_REG_SIZE_U64;
> > > +       u64 sysreg;
> > >
> > > -       if (is_write)
> > > -               params.regval = *reg;
> > > +       sysreg = (attr->attr & KVM_DEV_ARM_VGIC_SYSREG_MASK) | KVM_REG_SIZE_U64;
> >
> > Why don't you use attr_to_id() here ?
>
> This actually happens in the following patch. Happy to move the change
> here though.

IMHO it makes more sense to have the change in this patch
because vgic_v3_cpu_sysregs_uaccess in this patch already
takes "attr" as the arguments.
Having said that, I'm fine with keeping the current code:)

> >
> >
> > > +
> > > +       if (is_write) {
> > > +               if (get_user(params.regval, uaddr))
> > > +                       return -EFAULT;
> > > +       }
> > >         params.is_write = is_write;
> > >
> > >         r = find_reg_by_id(sysreg, &params, gic_v3_icc_reg_descs,
> > > @@ -297,8 +303,10 @@ int vgic_v3_cpu_sysregs_uaccess(struct kvm_vcpu *vcpu, bool is_write, u64 id,
> > >         if (!r->access(vcpu, &params, r))
> > >                 return -EINVAL;
> > >
> > > -       if (!is_write)
> > > -               *reg = params.regval;
> > > +       if (!is_write) {
> > > +               if (put_user(params.regval, uaddr))
> > > +                       return -EFAULT;
> > > +       }
> > >
> > >         return 0;
> > >  }
> > > diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
> > > index c6d52a1fd9c8..d8269300632d 100644
> > > --- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
> > > +++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
> > > @@ -561,14 +561,9 @@ static int vgic_v3_attr_regs_access(struct kvm_device *dev,
> > >                 if (!is_write)
> > >                         *reg = tmp32;
> > >                 break;
> > > -       case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS: {
> > > -               u64 regid;
> > > -
> > > -               regid = (attr->attr & KVM_DEV_ARM_VGIC_SYSREG_INSTR_MASK);
> > > -               ret = vgic_v3_cpu_sysregs_uaccess(vcpu, is_write,
> > > -                                                 regid, reg);
> > > +       case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
> > > +               ret = vgic_v3_cpu_sysregs_uaccess(vcpu, attr, is_write);
> >
> > Nit: Since @reg that is passed to vgic_v3_attr_regs_access() will be NULL
> > for KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS, I think it would be more clear
> > if you could update the comment for vgic_v3_attr_regs_access accordingly.
> >
> > ----
> > /*
> >  * vgic_v3_attr_regs_access - allows user space to access VGIC v3 state
> >  *
> >  * @dev:      kvm device handle
> >  * @attr:     kvm device attribute
> >  * @reg:      address the value is read or written
> >    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >  * @is_write: true if userspace is writing a register
> >  */
> > static int vgic_v3_attr_regs_access(struct kvm_device *dev,
> >                                     struct kvm_device_attr *attr,
> >                                     u64 *reg, bool is_write)
>
> @reg disappears completely in patch #12. Do you see value in rewriting
> this comment even if I end-up removing it 4 patches down the line?

Oh, I haven't seen PATCH#12 yet. Then let me withdraw my comment.

Thank you,
Reiji
