Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F057575BC3
	for <lists+kvm@lfdr.de>; Fri, 15 Jul 2022 08:46:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231806AbiGOGol (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jul 2022 02:44:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230151AbiGOGoj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jul 2022 02:44:39 -0400
Received: from mail-ua1-x934.google.com (mail-ua1-x934.google.com [IPv6:2607:f8b0:4864:20::934])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63A8621266
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 23:44:38 -0700 (PDT)
Received: by mail-ua1-x934.google.com with SMTP id r25so1485557uap.7
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 23:44:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=p6aDTSAubguJZg+3J+aZpS+pct8nChj++g4A7S8KF7M=;
        b=Jnbw9hVnECgNwloAV8Mr84FXTmguVIg5NfAo3mkCvlZ4hKp8wmbAxT8ZXMLH50tbHb
         2AtcqfP7CDR/M2LkGerzE4RjbEo3t0+wZ9znySMf0cboWxAHISnGNymaU4u4n+DgDwhw
         xYDBbeKC7uGCempsmTNjSBbKGkPxxwW3Lqd2C0PTh/i165tqfnkbP9i7mbujFw+EPnEZ
         0W1uYTZ92SNd5HFvJYLmeUvWHvtwMq0ad8SjNTIwuNai2ZMDD4PXZt1XZSsnuQ2QBtGi
         BNiQD6ngvkYHgXMzozebc4+/+kt2uNmiAg7HN/zBnwKI+0QIme1wAPU4861wQ7qFEZXb
         9YRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=p6aDTSAubguJZg+3J+aZpS+pct8nChj++g4A7S8KF7M=;
        b=Y24+qzM7jKHmPNoRxWsxHA3ObQvDaUmRFbOwCOLgA8EnPBTs3SlAwL2sNdeAH6USOa
         cSzC7mxcW4sYDnUtkLY56CjhqOhFZ5ny4SvCabYtbYjaeAafmwVRHTKptO+FDIYu+PRj
         0L+s99c+n964FnxKEy9MB5ZOMSPru4lToZmoKMk5Oov33kpXLAFtjP+z+xwuZOwyBcFX
         4UG721IsRdHNBUQNHuXC2wXuJbWJmWJEDp9Zv1GSJWF+7loUud/yhu8sc4NUH4Igcd3J
         YDF6Fhl6M1SWRR9XX5jx0OMyugMQUQdZA5CFnwNGBXIHrANp+6WqpGP7rPQDbRlVb6EM
         IuUQ==
X-Gm-Message-State: AJIora+frou+1eB+YgBGDnDiPHimmYTm30qk+zZyzYqP/LV8xg9NkvhQ
        5Sol+vO+LKQ+JjDryBRzZ46DK21k+vXjNPW73mbWGA==
X-Google-Smtp-Source: AGRyM1uWE0AM135v8bgmHTfGGyyoJpV55Gqxr8UiXmUhCXS1dGfLbxzAYnRhlP4kgcMpR7lq+JXvgxe6eP5xZy9syp8=
X-Received: by 2002:a05:6130:90:b0:362:891c:edef with SMTP id
 x16-20020a056130009000b00362891cedefmr5471902uaf.106.1657867477456; Thu, 14
 Jul 2022 23:44:37 -0700 (PDT)
MIME-Version: 1.0
References: <20220706164304.1582687-1-maz@kernel.org> <20220706164304.1582687-16-maz@kernel.org>
 <CAAeT=FzgBpwcf7oEGeCLCHO+XadP+i7vyPFWx6VJxmiWC94-7g@mail.gmail.com> <877d4gyy7y.wl-maz@kernel.org>
In-Reply-To: <877d4gyy7y.wl-maz@kernel.org>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Thu, 14 Jul 2022 23:44:21 -0700
Message-ID: <CAAeT=FwwO5=v3vLJ0qAw3V0NaPEnPeP1VmgLXXBL4jdm80aeew@mail.gmail.com>
Subject: Re: [PATCH 15/19] KVM: arm64: vgic-v2: Add helper for legacy
 dist/cpuif base address setting
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

On Thu, Jul 14, 2022 at 12:01 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Thu, 14 Jul 2022 07:37:25 +0100,
> Reiji Watanabe <reijiw@google.com> wrote:
> >
> > Hi Marc,
> >
> > On Wed, Jul 6, 2022 at 10:05 AM Marc Zyngier <maz@kernel.org> wrote:
> > >
> > > We carry a legacy interface to set the base addresses for GICv2.
> > > As this is currently plumbed into the same handling code as
> > > the modern interface, it limits the evolution we can make there.
> > >
> > > Add a helper dedicated to this handling, with a view of maybe
> > > removing this in the future.
> > >
> > > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > > ---
> > >  arch/arm64/kvm/arm.c                  | 11 ++-------
> > >  arch/arm64/kvm/vgic/vgic-kvm-device.c | 32 +++++++++++++++++++++++++++
> > >  include/kvm/arm_vgic.h                |  1 +
> > >  3 files changed, 35 insertions(+), 9 deletions(-)
> > >
> > > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > > index 83a7f61354d3..bf39570c0aef 100644
> > > --- a/arch/arm64/kvm/arm.c
> > > +++ b/arch/arm64/kvm/arm.c
> > > @@ -1414,18 +1414,11 @@ void kvm_arch_flush_remote_tlbs_memslot(struct kvm *kvm,
> > >  static int kvm_vm_ioctl_set_device_addr(struct kvm *kvm,
> > >                                         struct kvm_arm_device_addr *dev_addr)
> > >  {
> > > -       unsigned long dev_id, type;
> > > -
> > > -       dev_id = (dev_addr->id & KVM_ARM_DEVICE_ID_MASK) >>
> > > -               KVM_ARM_DEVICE_ID_SHIFT;
> > > -       type = (dev_addr->id & KVM_ARM_DEVICE_TYPE_MASK) >>
> > > -               KVM_ARM_DEVICE_TYPE_SHIFT;
> > > -
> > > -       switch (dev_id) {
> > > +       switch (FIELD_GET(KVM_ARM_DEVICE_ID_MASK, dev_addr->id)) {
> > >         case KVM_ARM_DEVICE_VGIC_V2:
> > >                 if (!vgic_present)
> > >                         return -ENXIO;
> > > -               return kvm_vgic_addr(kvm, type, &dev_addr->addr, true);
> > > +               return kvm_set_legacy_vgic_v2_addr(kvm, dev_addr);
> > >         default:
> > >                 return -ENODEV;
> > >         }
> > > diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
> > > index fbbd0338c782..0dfd277b9058 100644
> > > --- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
> > > +++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
> > > @@ -41,6 +41,38 @@ static int vgic_check_type(struct kvm *kvm, int type_needed)
> > >                 return 0;
> > >  }
> > >
> > > +int kvm_set_legacy_vgic_v2_addr(struct kvm *kvm, struct kvm_arm_device_addr *dev_addr)
> > > +{
> > > +       struct vgic_dist *vgic = &kvm->arch.vgic;
> > > +       int r;
> > > +
> > > +       mutex_lock(&kvm->lock);
> > > +       switch (FIELD_GET(KVM_ARM_DEVICE_ID_MASK, dev_addr->id)) {
> >
> > Shouldn't this be KVM_ARM_DEVICE_TYPE_MASK (not KVM_ARM_DEVICE_ID_MASK) ?
>
> Damn, you just ruined my attempt at deprecating this API ;-).

Oops, I should have pretended not to notice:)

> More seriously, thanks for catching this one!

Thank you for cleaning up the code so much!
Reiji
