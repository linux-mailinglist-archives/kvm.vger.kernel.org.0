Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 679FD7422C1
	for <lists+kvm@lfdr.de>; Thu, 29 Jun 2023 10:55:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232084AbjF2Iza (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jun 2023 04:55:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232096AbjF2Iz1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Jun 2023 04:55:27 -0400
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91618131
        for <kvm@vger.kernel.org>; Thu, 29 Jun 2023 01:55:26 -0700 (PDT)
Received: by mail-qt1-x82e.google.com with SMTP id d75a77b69052e-401f4408955so176531cf.1
        for <kvm@vger.kernel.org>; Thu, 29 Jun 2023 01:55:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1688028925; x=1690620925;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iLSx+IibbbFO3eoieeQ0ahfVThh114dnzZVKXKMPytk=;
        b=R2NV18E8eGwxVId5xlR/et2NMPrHy1x+Kd+uELH+C5Z6QLpMYj53Qtd7NTe9vvl+dI
         Qz3QcKegMT+55v+aeQa1kcAditI7nAaLBuyZM36+iROvkx/Isysw4+FpbXNHPqMj1FeI
         oT2OOGnrHaVltLlVP6bzc3Ozs6/shKr0q8SwhLrNYIukwWaTuZR3eNqInxz5lqdCoebt
         NI1331PyQr7S3udY7/lXE2ywGPgw3VenPkcMV3AUyh0CGZKodnZbRFidaf5FPw9ZGzDv
         DnTw7PgFj2s0wesachAMtBi+s+f18ndCrF1epkmhe4DNSXnUzz7wIetew2t0A35ZwZ6O
         0KhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688028925; x=1690620925;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iLSx+IibbbFO3eoieeQ0ahfVThh114dnzZVKXKMPytk=;
        b=V6s6ZeatsA+xdvfHWJpg+nU7tCGTTw4K7umDA6buu0AYb1srx3NHE0o+/Jp9MR9wKw
         5uvTHP/r7kG3CmdFdvQGL5Gu0zYBz1EGvhyvZo3FJPxCGf7Dcrkqw+MulP7ahaacDSug
         NOd4haz8lt/G56dvGNFcpfWlfVdu5wGeMOJ24/e5ZzOXJZgn5A6NYGnAOXNJCK3kMnzx
         vHsL5MFKChfPLDnclECFVdUB3LCLRIghlv3r+MuajsYpZKirW7cJMVX77lke18UWqbFQ
         uBoUFyxWdBTXW07PepKQlQudhZc89uno7hG3doI9gZNTmNpaLwXhPoe3HP1VjGpPWvzH
         iL4g==
X-Gm-Message-State: AC+VfDzbzM+XKBS5xPID/eEOlmZxO7bKwDkfhyt3hHACvEcDMPb6wIGA
        waha2hhxbaKIxQ/fDU95Q+AXulUpB0wSNaq2fMC+lGCIJX+Q2+zDAzSBNw==
X-Google-Smtp-Source: ACHHUZ4FMOfJIC0Hituk7BUmqP60oyWZYdWSfPJ2bAwb5vMGv+QKSdp3IUJlDw0dUODOJYWbC85JxkhSlHkovKXXUMY=
X-Received: by 2002:ac8:5882:0:b0:3e0:c2dd:fd29 with SMTP id
 t2-20020ac85882000000b003e0c2ddfd29mr450540qta.4.1688028925505; Thu, 29 Jun
 2023 01:55:25 -0700 (PDT)
MIME-Version: 1.0
References: <CABgObfYLnhW0qrPvFnMW_B9xZzLF6Ysn2uL4w9B815fUNVKK5A@mail.gmail.com>
 <20230629000729.1223067-1-yuzhao@google.com> <CAAhV-H73BgeU=Vw+X+R+1pTrbZb_y9WLy66iu9=d3SXXeD0SBw@mail.gmail.com>
In-Reply-To: <CAAhV-H73BgeU=Vw+X+R+1pTrbZb_y9WLy66iu9=d3SXXeD0SBw@mail.gmail.com>
From:   Yu Zhao <yuzhao@google.com>
Date:   Thu, 29 Jun 2023 02:54:49 -0600
Message-ID: <CAOUHufYHANwC-YZ0W5D89spuA693-PKnZ+9JwkNEN05AagUETw@mail.gmail.com>
Subject: Re: [PATCH] MIPS: KVM: Fix NULL pointer dereference
To:     Huacai Chen <chenhuacai@kernel.org>
Cc:     pbonzini@redhat.com, chenhuacai@loongson.cn,
        jiaxun.yang@flygoat.com, kvm@vger.kernel.org,
        linux-mips@vger.kernel.org, stable@vger.kernel.org,
        tsbogend@alpha.franken.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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

On Thu, Jun 29, 2023 at 12:24=E2=80=AFAM Huacai Chen <chenhuacai@kernel.org=
> wrote:
>
> Hi, Zhao,
>
> On Thu, Jun 29, 2023 at 8:07=E2=80=AFAM Yu Zhao <yuzhao@google.com> wrote=
:
> >
> > On Mon, Jun 26, 2023 at 6:33 AM Paolo Bonzini <pbonzini@redhat.com> wro=
te:
> > >
> > > On Mon, Jun 26, 2023 at 9:59 AM Huacai Chen <chenhuacai@loongson.cn> =
wrote:
> > > >
> > > > After commit 45c7e8af4a5e3f0bea4ac209 ("MIPS: Remove KVM_TE support=
") we
> > > > get a NULL pointer dereference when creating a KVM guest:
> > >
> > > To be honest, a bug that needed 2 years to be reproduced is probably =
a
> > > sign that KVM/MIPS has no users. Any objections to removing it
> > > altogether?
> >
> > ACK:
> > 1. It's still broken after this patch [1]. The most well-tested MIPS
> >    distros, i.e., Debian/OpenWrt, have CONFIG_KVM=3Dn. (The latter does=
n't
> >    even provide the QEMU package on MIPS.)
> > 2. Burden on QEMU dev. There is no guarantee that QEMU would work with
> >    KVM even if we could fix the kernel -- it actually does not until
> >    v8.0 [1], which is by luck:
> >
> >    commit a844873512400fae6bed9e87694dc96ff2f15f39
> >    Author: Paolo Bonzini <pbonzini@redhat.com>
> >    Date:   Sun Dec 18 01:06:45 2022 +0100
> >
> >        mips: Remove support for trap and emulate KVM
> >
> >        This support was limited to the Malta board, drop it.
> >        I do not have a machine that can run VZ KVM, so I am assuming
> >        that it works for -M malta as well.
> >
> >    (The latest Debian stable only ships v7.2.)
> >
> > [1] https://lore.kernel.org/r/ZI0R76Fx25Q2EThZ@google.com/
> My testbed is Loongson-3A4000 host + Loongson-3A4000 guest + Qemu8.0,
> both TCG and KVM works.

I tried TCG too, as reported in the link above, and had no luck.

> Some thoughts:
> 1, I think your host is malta, but you cannot use a malta host to boot
> a Loongson guest, at least their kernels use different page sizes.

Good to know. Thanks.

> 2, commit a844873512400fae6bed9e87694dc96f remove the TE KVM, so if
> you are trying VZ KVM (but it seems you are using TE KVM), it can
> break nothing.

I fully understand :) I was trying to point out that QEMU/KVM had been
broken for over 2 years -- neither TE (removed from KVM) nor VZ works
with 7.2, which is probably why you used 8.0 too -- until that commit
*accidentally* fixed VZ (it was supposed to be a cleanup, not a fix).
