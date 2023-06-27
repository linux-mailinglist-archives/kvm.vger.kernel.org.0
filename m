Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 396B17403AB
	for <lists+kvm@lfdr.de>; Tue, 27 Jun 2023 20:58:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229482AbjF0S6o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jun 2023 14:58:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbjF0S6m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jun 2023 14:58:42 -0400
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2283519A8
        for <kvm@vger.kernel.org>; Tue, 27 Jun 2023 11:58:41 -0700 (PDT)
Received: by mail-qt1-x831.google.com with SMTP id d75a77b69052e-40079620a83so53251cf.0
        for <kvm@vger.kernel.org>; Tue, 27 Jun 2023 11:58:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687892320; x=1690484320;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qKmobhi2Nd95iIsQAIChf1bNKSbLWPmwBaNmrDGtsts=;
        b=I8+vYnp56biA2jptfbaCChDPwA5U10DQ4I9FvwYkNhUfKRepAkz2Mk/5JUHv1d5dmM
         lk2ktpVEHOWHcM3PuNxsYc3dPW4A9/8TXbN2uqb7m4FGyAydo1VI4kpXrLq3+XVbAIZM
         YmuJh7wySIlu+n4j5Xqm6P+sXmYblBomzcc9JWgILoGeyt3TKx8srrcXJTnqkAoeC8LV
         RvLpeIcVZVfSmCEqrP4BFFQ2filFJE2sqLEywSUlOEcov6u7yEn7xcYWnV4DZlkhnJaB
         jMq3r/jOkh3C9ZmuxW0/JoW9HpfbbcttU+RSN9dkHaoec8p+Wk669/7rvuJs6Nqkf5B+
         k1xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687892320; x=1690484320;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qKmobhi2Nd95iIsQAIChf1bNKSbLWPmwBaNmrDGtsts=;
        b=EwbPn6HF3jVvNaQBAqB+bg5vCqI6Kc9r4chSMByASLG9Rv/nTDHwW+RcqUprcKdKqt
         iVGrFwI4R3WCd6VmKZynT7arq8L1geUEhm7dRMrkW3FTgUabNuSKVy7YZhbpXT+UcFv8
         ue5nsv5yaG8QE8Am05iY7eQxEZPaQ6Mc2Rr2/N8wF8txutQh2t8KBOiW9+JIdXcMwA+p
         aPHmdycsEfivh5XLVz79RoICTrVD9NpaNNDteflPLuWo+vTV1x0YfsYcci7Lq+stLIpe
         rNtK9qGDfyewPlW2gITOi6ehmpI99W+TfyWHrWy736iUXDaeuDz1nXQHuB5YrRvVtGvW
         JkKg==
X-Gm-Message-State: AC+VfDwwUn+EBzQhGW/e/sNebYReGTEGqf7r9RzR/BpwE5tFGmYLGZ6d
        gAaPRVXeascT2bbHaX4Tr0PBY6E1UbJJsp+YFXyrqxhaKz9lMvb9bcffKw==
X-Google-Smtp-Source: ACHHUZ6J1/N78owDH/OSbtNas/Sl37COEcbqYw6ds8Zv0pHedAq0dIAIUM37R4vLnSFkdqc7ndFCoE3ckGd2t8yVZeA=
X-Received: by 2002:a05:622a:181b:b0:3ed:86f6:6eab with SMTP id
 t27-20020a05622a181b00b003ed86f66eabmr26836qtc.14.1687892320136; Tue, 27 Jun
 2023 11:58:40 -0700 (PDT)
MIME-Version: 1.0
References: <1596005919-29365-5-git-send-email-chenhc@lemote.com>
 <20230616071831.1452507-1-yuzhao@google.com> <20230616082322.GA7323@alpha.franken.de>
 <ZI0R76Fx25Q2EThZ@google.com> <CAAhV-H7Hdw6Ye46OOoNyXtZfO9smMiPz+hRLq8vEvmgQCMGuFQ@mail.gmail.com>
 <CAOUHufYfEijFPPOXS43URKksQzd-YAPfekej9suH07w2etQ3SA@mail.gmail.com> <CAAhV-H5LYRA92XaaeZ5=fo0xiYzQ-2Ejg8yzY_XavYLdYau9BA@mail.gmail.com>
In-Reply-To: <CAAhV-H5LYRA92XaaeZ5=fo0xiYzQ-2Ejg8yzY_XavYLdYau9BA@mail.gmail.com>
From:   Yu Zhao <yuzhao@google.com>
Date:   Tue, 27 Jun 2023 12:58:04 -0600
Message-ID: <CAOUHufZZUQg9pw+OY+3xUc3fKgO1iOV8af61nYS2uvSdvbQpyg@mail.gmail.com>
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
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 26, 2023 at 2:00=E2=80=AFAM Huacai Chen <chenhuacai@kernel.org>=
 wrote:
>
> Hi, Zhao,
>
> On Sun, Jun 18, 2023 at 10:51=E2=80=AFAM Yu Zhao <yuzhao@google.com> wrot=
e:
> >
> > On Sat, Jun 17, 2023 at 8:13=E2=80=AFPM Huacai Chen <chenhuacai@kernel.=
org> wrote:
> > >
> > > On Sat, Jun 17, 2023 at 9:52=E2=80=AFAM Yu Zhao <yuzhao@google.com> w=
rote:
> > > >
> > > > On Fri, Jun 16, 2023 at 10:23:22AM +0200, Thomas Bogendoerfer wrote=
:
> > > > > On Fri, Jun 16, 2023 at 01:18:31AM -0600, Yu Zhao wrote:
> > > > > > On Tue, Jul 28, 2020 at 23:58:20PM -0700, Huacai Chen wrote:
> > > > > > > James Hogan has become inactive for a long time and leaves KV=
M for MIPS
> > > > > > > orphan. I'm working on KVM/Loongson and attempt to make it up=
stream both
> > > > > > > in kernel and QEMU, while Aleksandar Markovic is already a ma=
intainer of
> > > > > > > QEMU/MIPS. We are both interested in QEMU/KVM/MIPS, and we ha=
ve already
> > > > > > > made some contributions in kernel and QEMU. If possible, we w=
ant to take
> > > > > > > the KVM/MIPS maintainership.
> > > > > > >
> > > > > > > Reviewed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
> > > > > > > Reviewed-by: Aleksandar Markovic <aleksandar.qemu.devel@gmail=
.com>
> > > > > > > Signed-off-by: Huacai Chen <chenhc@lemote.com>
> > > > > > > ---
> > > > > > >  MAINTAINERS | 4 +++-
> > > > > > >  1 file changed, 3 insertions(+), 1 deletion(-)
> > > > > > >
> > > > > > > diff --git a/MAINTAINERS b/MAINTAINERS
> > > > > > > index bddc79a..5f9c2fd 100644
> > > > > > > --- a/MAINTAINERS
> > > > > > > +++ b/MAINTAINERS
> > > > > > > @@ -9441,9 +9441,11 @@ F: arch/arm64/kvm/
> > > > > > >  F:       include/kvm/arm_*
> > > > > > >
> > > > > > >  KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)
> > > > > > > +M:       Huacai Chen <chenhc@lemote.com>
> > > > > > > +M:       Aleksandar Markovic <aleksandar.qemu.devel@gmail.co=
m>
> > > > > > >  L:       linux-mips@vger.kernel.org
> > > > > > >  L:       kvm@vger.kernel.org
> > > > > > > -S:       Orphan
> > > > > > > +S:       Maintained
> > > > > > >  F:       arch/mips/include/asm/kvm*
> > > > > > >  F:       arch/mips/include/uapi/asm/kvm*
> > > > > > >  F:       arch/mips/kvm/
> > > > > >
> > > > > > Hi,
> > > > > >
> > > > > > Is kvm/mips still maintained? Thanks.
> > > > > >
> > > > > > I tried v6.4-rc6 and hit the following crash. It seems it has b=
een broken since
> > > > > >
> > > > > >   commit 45c7e8af4a5e3f0bea4ac209eea34118dd57ac64
> > > > > >   Author: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> > > > > >   Date:   Mon Mar 1 16:29:57 2021 +0100
> > > > > >
> > > > > >       MIPS: Remove KVM_TE support
> > > > >
> > > > > ok, I see what I missed when removing TE support, d'oh. Does the =
patch
> > > > > below fix the issue for you ?
> > > >
> > > > Thanks!
> > > >
> > > > It made some progress but somehow crashed the guest kernel.
> > > >
> > > > $ qemu-system-mips64el --version
> > > > QEMU emulator version 7.2.2 (Debian 1:7.2+dfsg-7)
> > > > Copyright (c) 2003-2022 Fabrice Bellard and the QEMU Project develo=
pers
> > > >
> > > > # w/o KVM
> > > >
> > > >   # malta: working (but slow)
> > > >
> > > >     $ qemu-system-mips64el -nographic -kernel lede-malta-le64-vmlin=
ux-initramfs.elf
> > > >     [    0.000000] Linux version 4.9.58 (buildbot@builds) (gcc vers=
ion 5.5.0 (LEDE GCC 5.5.0 r5218-f90f94d) ) #0 SMP Wed Nov 1 21:08:14 2017
> > > >     ...
> > > >
> > > >   # loongson3-virt: hanged
> > > >
> > > >     $ qemu-system-mips64el -M loongson3-virt -m 512m -nographic -ke=
rnel vmlinuz-6.1.0-9-loongson-3 -initrd initrd.gz
> > > >     [    0.000000] Linux version 6.1.0-9-loongson-3 (debian-kernel@=
lists.debian.org) (gcc-12 (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils f=
or Debian) 2.40) #1 SMP PREEMPT Debian 6.1.27-1 (2023-05-08)
> > > >     ...
> > > >     [    0.000000] Initmem setup node 0 [mem 0x0000000000000000-0x0=
00000009fffffff]
> > > >
> > > > # w/ KVM
> > > >
> > > >   # malta: qemu error
> > > >
> > > >     $ sudo qemu-system-mips64el -M accel=3Dkvm -nographic -kernel l=
ede-malta-le64-vmlinux-initramfs.elf
> > > >     qemu-system-mips64el: KVM guest kernels must be linked in useg.=
 Did you forget to enable CONFIG_KVM_GUEST?
> > > >
> > > >   # loongson3-virt: qemu error
> > > >
> > > >     $ sudo qemu-system-mips64el -M loongson3-virt,accel=3Dkvm -m 51=
2m -nographic -kernel vmlinuz-6.1.0-9-loongson-3 -initrd initrd.gz
> > > >     qemu-system-mips64el: ../../accel/kvm/kvm-all.c:2310: kvm_init:=
 Assertion `TARGET_PAGE_SIZE <=3D qemu_real_host_page_size()' failed.
> > > >     Aborted
> > > >
> > > > $ qemu-system-mips64el --version
> > > > QEMU emulator version 8.0.2 (Debian 1:8.0.2+dfsg-1)
> > > > Copyright (c) 2003-2022 Fabrice Bellard and the QEMU Project develo=
pers
> > > >
> > > > # w/o KVM
> > > >
> > > >   # malta: no change
> > > >   # loongson3-virt: no change
> > > >
> > > > # w/ KVM
> > > >
> > > >   # loongson3-virt: the same qemu error
> > > >
> > > >   # malta: booted very fast but guest crashed:
> > > >
> > > > $ sudo qemu-system-mips64el -M accel=3Dkvm -nographic -kernel lede-=
malta-le64-vmlinux-initramfs.elf
> > > > [    0.000000] Linux version 4.9.58 (buildbot@builds) (gcc version =
5.5.0 (LEDE GCC 5.5.0 r5218-f90f94d) ) #0 SMP Wed Nov 1 21:08:14 2017
> >
> > ...
> >
> > > > [    0.402570] Kernel panic - not syncing: Fatal exception
> > > > [    0.404311] Rebooting in 1 seconds..
> > > > [    2.385408] Reboot failed -- System halted
> > > >
> > > > openwrt/malta: https://downloads.openwrt.org/snapshots/targets/malt=
a/le64/
> > > > debian/loongson-3: https://deb.debian.org/debian/dists/sid/main/ins=
taller-mips64el/current/images/
> > > > debian/malta: not working
> > >
> > > I have reproduced the problem, and I hope I can fix it in a few days,
> >
> > That's great. Thanks a lot!
> I fixed the KVM problems on Loongson [1][2][3]. However, you have
> tried [1] but still have problems, while [2] and [3] are specific to
> Loongson, so maybe you are still unable to use KVM.
>
> [1] https://lore.kernel.org/linux-mips/20230626074919.1871944-1-chenhuaca=
i@loongson.cn/T/#u
> [2] https://lore.kernel.org/linux-mips/20230626075014.1872632-1-chenhuaca=
i@loongson.cn/T/#u
> [3] https://lore.kernel.org/linux-mips/20230626075047.1872818-1-chenhuaca=
i@loongson.cn/T/#u

Thanks for the update. I'll take a look if I get a chance.
