Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 965F97344B1
	for <lists+kvm@lfdr.de>; Sun, 18 Jun 2023 04:51:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229445AbjFRCvy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 17 Jun 2023 22:51:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjFRCvw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 17 Jun 2023 22:51:52 -0400
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BB58E49
        for <kvm@vger.kernel.org>; Sat, 17 Jun 2023 19:51:51 -0700 (PDT)
Received: by mail-qt1-x82f.google.com with SMTP id d75a77b69052e-3f9d619103dso143021cf.1
        for <kvm@vger.kernel.org>; Sat, 17 Jun 2023 19:51:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687056710; x=1689648710;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KyD17gLPgexT2aqbYuEbthxsgtTZKjpJDUd+6kK1LkY=;
        b=QDN3aF42KzvqZofIhe2Lpda1s1n0wh6ubeV8/rFEnwdLo3nTAFoDhfEOvHa9v0B4DQ
         7EYAa3MDrbnPVwE5WQ54PN/NEzIclqnTNeM3ccqY9fekV0TFoCLuxlwLJuf8yncumUn4
         Q4J+WEM9QGKI9MqCv/cZ2ku7PKiBlw66qgJ9uM0l7VV3JYKZvoToIr04Kp5JkLe9Vj7u
         eRp1DySpwI/5nus2ZJeYi3ZH8fvbBiA1qvXcjSfl4yCd0VKy2/d1vTM/MaRBE1GvnYLo
         v+yRzWljT+3pD+jsh+fQYJsHCaYaZpnVAMNUIBP4WI5MuaRNrjZLs5ElfyHaWifVuA9K
         ddQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687056710; x=1689648710;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KyD17gLPgexT2aqbYuEbthxsgtTZKjpJDUd+6kK1LkY=;
        b=dWLPxtfL8QPJ8sJzL+y0EtqSMVFTx36qSKYuyVZsqG2dRCKplI0tAeoGdPpekrfbwu
         sTPHUdOTH0AfUUP8DRHhI964K7YKzGV70XsKPg7mXaFDlmwyjgeWDvHrEKlixbBWgp8R
         pJd9CZGnNx3oycsez/P0r8FrNUEBaC+rmBoC0oQ1Cn7X8FZQWwP2epyg3AQy8qWJ/Yp5
         CRiV1wXT1YBZec/2kqI0N8qgQQZdEMjdU2HOaHKUpqbvaHizW4ekbSXkLdZsnHY4J1XR
         UpEKa0lJimQ4hUvmm3NoYPKdOglcIaz4rOEoRTXaWYKcqfu7UHdc8wKHWA78ILq5iall
         KbJw==
X-Gm-Message-State: AC+VfDy9GZmxc4tsab2t1Ph4H8yOBHNDPZvHe5BnNYHUDUPa7VeSRg0R
        X3Gk25lBhIhK0IQmHRBsPvFAplLy6tHqp0rf4kyNJg0REAHAQbBCFCxvdA==
X-Google-Smtp-Source: ACHHUZ5GV2W8sbCpJJi/hRiEYnKaTXcf8/MVwHgMIE9frTp9ki9R7esIwCcZH06iLIFg+kaXVYkIseCvkcKjjP5eYSE=
X-Received: by 2002:a05:622a:20a:b0:3f9:a78f:c527 with SMTP id
 b10-20020a05622a020a00b003f9a78fc527mr215538qtx.21.1687056709945; Sat, 17 Jun
 2023 19:51:49 -0700 (PDT)
MIME-Version: 1.0
References: <1596005919-29365-5-git-send-email-chenhc@lemote.com>
 <20230616071831.1452507-1-yuzhao@google.com> <20230616082322.GA7323@alpha.franken.de>
 <ZI0R76Fx25Q2EThZ@google.com> <CAAhV-H7Hdw6Ye46OOoNyXtZfO9smMiPz+hRLq8vEvmgQCMGuFQ@mail.gmail.com>
In-Reply-To: <CAAhV-H7Hdw6Ye46OOoNyXtZfO9smMiPz+hRLq8vEvmgQCMGuFQ@mail.gmail.com>
From:   Yu Zhao <yuzhao@google.com>
Date:   Sat, 17 Jun 2023 20:51:13 -0600
Message-ID: <CAOUHufYfEijFPPOXS43URKksQzd-YAPfekej9suH07w2etQ3SA@mail.gmail.com>
Subject: Re: [PATCH 5/5] MAINTAINERS: Update KVM/MIPS maintainers
To:     Huacai Chen <chenhuacai@kernel.org>
Cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        jiaxun.yang@flygoat.com, kvm@vger.kernel.org,
        linux-mips@vger.kernel.org, pbonzini@redhat.com, robh+dt@kernel.org
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

On Sat, Jun 17, 2023 at 8:13=E2=80=AFPM Huacai Chen <chenhuacai@kernel.org>=
 wrote:
>
> On Sat, Jun 17, 2023 at 9:52=E2=80=AFAM Yu Zhao <yuzhao@google.com> wrote=
:
> >
> > On Fri, Jun 16, 2023 at 10:23:22AM +0200, Thomas Bogendoerfer wrote:
> > > On Fri, Jun 16, 2023 at 01:18:31AM -0600, Yu Zhao wrote:
> > > > On Tue, Jul 28, 2020 at 23:58:20PM -0700, Huacai Chen wrote:
> > > > > James Hogan has become inactive for a long time and leaves KVM fo=
r MIPS
> > > > > orphan. I'm working on KVM/Loongson and attempt to make it upstre=
am both
> > > > > in kernel and QEMU, while Aleksandar Markovic is already a mainta=
iner of
> > > > > QEMU/MIPS. We are both interested in QEMU/KVM/MIPS, and we have a=
lready
> > > > > made some contributions in kernel and QEMU. If possible, we want =
to take
> > > > > the KVM/MIPS maintainership.
> > > > >
> > > > > Reviewed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
> > > > > Reviewed-by: Aleksandar Markovic <aleksandar.qemu.devel@gmail.com=
>
> > > > > Signed-off-by: Huacai Chen <chenhc@lemote.com>
> > > > > ---
> > > > >  MAINTAINERS | 4 +++-
> > > > >  1 file changed, 3 insertions(+), 1 deletion(-)
> > > > >
> > > > > diff --git a/MAINTAINERS b/MAINTAINERS
> > > > > index bddc79a..5f9c2fd 100644
> > > > > --- a/MAINTAINERS
> > > > > +++ b/MAINTAINERS
> > > > > @@ -9441,9 +9441,11 @@ F: arch/arm64/kvm/
> > > > >  F:       include/kvm/arm_*
> > > > >
> > > > >  KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)
> > > > > +M:       Huacai Chen <chenhc@lemote.com>
> > > > > +M:       Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
> > > > >  L:       linux-mips@vger.kernel.org
> > > > >  L:       kvm@vger.kernel.org
> > > > > -S:       Orphan
> > > > > +S:       Maintained
> > > > >  F:       arch/mips/include/asm/kvm*
> > > > >  F:       arch/mips/include/uapi/asm/kvm*
> > > > >  F:       arch/mips/kvm/
> > > >
> > > > Hi,
> > > >
> > > > Is kvm/mips still maintained? Thanks.
> > > >
> > > > I tried v6.4-rc6 and hit the following crash. It seems it has been =
broken since
> > > >
> > > >   commit 45c7e8af4a5e3f0bea4ac209eea34118dd57ac64
> > > >   Author: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> > > >   Date:   Mon Mar 1 16:29:57 2021 +0100
> > > >
> > > >       MIPS: Remove KVM_TE support
> > >
> > > ok, I see what I missed when removing TE support, d'oh. Does the patc=
h
> > > below fix the issue for you ?
> >
> > Thanks!
> >
> > It made some progress but somehow crashed the guest kernel.
> >
> > $ qemu-system-mips64el --version
> > QEMU emulator version 7.2.2 (Debian 1:7.2+dfsg-7)
> > Copyright (c) 2003-2022 Fabrice Bellard and the QEMU Project developers
> >
> > # w/o KVM
> >
> >   # malta: working (but slow)
> >
> >     $ qemu-system-mips64el -nographic -kernel lede-malta-le64-vmlinux-i=
nitramfs.elf
> >     [    0.000000] Linux version 4.9.58 (buildbot@builds) (gcc version =
5.5.0 (LEDE GCC 5.5.0 r5218-f90f94d) ) #0 SMP Wed Nov 1 21:08:14 2017
> >     ...
> >
> >   # loongson3-virt: hanged
> >
> >     $ qemu-system-mips64el -M loongson3-virt -m 512m -nographic -kernel=
 vmlinuz-6.1.0-9-loongson-3 -initrd initrd.gz
> >     [    0.000000] Linux version 6.1.0-9-loongson-3 (debian-kernel@list=
s.debian.org) (gcc-12 (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for D=
ebian) 2.40) #1 SMP PREEMPT Debian 6.1.27-1 (2023-05-08)
> >     ...
> >     [    0.000000] Initmem setup node 0 [mem 0x0000000000000000-0x00000=
0009fffffff]
> >
> > # w/ KVM
> >
> >   # malta: qemu error
> >
> >     $ sudo qemu-system-mips64el -M accel=3Dkvm -nographic -kernel lede-=
malta-le64-vmlinux-initramfs.elf
> >     qemu-system-mips64el: KVM guest kernels must be linked in useg. Did=
 you forget to enable CONFIG_KVM_GUEST?
> >
> >   # loongson3-virt: qemu error
> >
> >     $ sudo qemu-system-mips64el -M loongson3-virt,accel=3Dkvm -m 512m -=
nographic -kernel vmlinuz-6.1.0-9-loongson-3 -initrd initrd.gz
> >     qemu-system-mips64el: ../../accel/kvm/kvm-all.c:2310: kvm_init: Ass=
ertion `TARGET_PAGE_SIZE <=3D qemu_real_host_page_size()' failed.
> >     Aborted
> >
> > $ qemu-system-mips64el --version
> > QEMU emulator version 8.0.2 (Debian 1:8.0.2+dfsg-1)
> > Copyright (c) 2003-2022 Fabrice Bellard and the QEMU Project developers
> >
> > # w/o KVM
> >
> >   # malta: no change
> >   # loongson3-virt: no change
> >
> > # w/ KVM
> >
> >   # loongson3-virt: the same qemu error
> >
> >   # malta: booted very fast but guest crashed:
> >
> > $ sudo qemu-system-mips64el -M accel=3Dkvm -nographic -kernel lede-malt=
a-le64-vmlinux-initramfs.elf
> > [    0.000000] Linux version 4.9.58 (buildbot@builds) (gcc version 5.5.=
0 (LEDE GCC 5.5.0 r5218-f90f94d) ) #0 SMP Wed Nov 1 21:08:14 2017

...

> > [    0.402570] Kernel panic - not syncing: Fatal exception
> > [    0.404311] Rebooting in 1 seconds..
> > [    2.385408] Reboot failed -- System halted
> >
> > openwrt/malta: https://downloads.openwrt.org/snapshots/targets/malta/le=
64/
> > debian/loongson-3: https://deb.debian.org/debian/dists/sid/main/install=
er-mips64el/current/images/
> > debian/malta: not working
>
> I have reproduced the problem, and I hope I can fix it in a few days,

That's great. Thanks a lot!
