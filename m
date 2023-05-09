Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 534A76FCDD1
	for <lists+kvm@lfdr.de>; Tue,  9 May 2023 20:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230345AbjEISaJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 May 2023 14:30:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjEISaI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 May 2023 14:30:08 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89D16E7C
        for <kvm@vger.kernel.org>; Tue,  9 May 2023 11:30:06 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id 2adb3069b0e04-4f24ddf514eso3281278e87.0
        for <kvm@vger.kernel.org>; Tue, 09 May 2023 11:30:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20221208.gappssmtp.com; s=20221208; t=1683657005; x=1686249005;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gL0cCLb0id8U4N3Jjz82PDdmM1uJpA0DxI+3sKg3aSM=;
        b=N1MMKv9cxVawcrPHkQX+aVM9lr6EDKpW0lBQeIBztalbTBOdWoRte7S/CV7gGPC5zm
         biqF6gpE85lLm1pIWDivSvFXWg7ww0H44bgsyDRJQquQlk6LikVgwaj7HNsxoYEd4i5X
         BcgbDgkfy4WmohP+mA9DX7ErlOYyjeMbenTfaK81r4NbWJBQyRwyRZJldEKZS77jgyPB
         6WQdYmEPU331S8/guwz/s/cIYQcglKPE04HAkRe0K1piSVGU2rUTzHFs3j5Qlg2aNpvf
         p8+vB3PTWk2/FZcq+AsCgzXPvjX7xAJkrIOW1sXRnI6CR5aTBJhLv2FZLIWOhdzVRUVF
         ZedA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683657005; x=1686249005;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gL0cCLb0id8U4N3Jjz82PDdmM1uJpA0DxI+3sKg3aSM=;
        b=Aa9Nm4kBAVq9Xc7l1EyV7kZCvNi1mlmTdeYhtwiIcZ2k8f75ERfJQgfkGb4mBrbz9r
         J8gzS+GxUYEdG6FLCVsKmIdGDljlSyDDgJ9QyS9eGPZ5R/4SC+vc6NLlP3zunbg0P1lT
         C8AGiRU+q5dWkmBQP+HxNsNLeDB7Cy1z5jdemsRUZ5lMmbXYCNqgZwr2Cj0M6x0aOqbn
         YRZaFUfUMGY4t/ljuLd1llefsatjzA0CiqxB8zAfR+j6k8Lsc99M6c4HPd4GefV/pTbX
         voYwNPO14NkdS6ORiIwW5j5B8k5TMEbqyT8ltqpWdhLvYEnw1q/W0tuLDozBd1Z2uLCe
         zJlQ==
X-Gm-Message-State: AC+VfDyWcdRUhbuwxpcUQv7PNtcr+m4JhH6xnH11skZnMSpAcqqoSTlx
        zAzkEh706m55Ywh+KSHdJkkTbk7kFE+vStsEQrxVvw==
X-Google-Smtp-Source: ACHHUZ6X8eYc05eiE+zIEALxfDpJyD5yUrNp+bmDpBh6p6mFv7EBvq1U/LVh0PPxNgeY+Ae+WMrCppSDVeOzGmKoWLc=
X-Received: by 2002:a05:6512:909:b0:4ed:b263:5e64 with SMTP id
 e9-20020a056512090900b004edb2635e64mr805271lft.27.1683657004725; Tue, 09 May
 2023 11:30:04 -0700 (PDT)
MIME-Version: 1.0
References: <CALs-Hss8L478Pg7zdcVZkL-jGGqdXtQd+uy+JdNEey90+eBYiA@mail.gmail.com>
 <mhng-abff9e50-4cda-4f22-b903-a3f7eb2c340a@palmer-ri-x1c9a>
In-Reply-To: <mhng-abff9e50-4cda-4f22-b903-a3f7eb2c340a@palmer-ri-x1c9a>
From:   Evan Green <evan@rivosinc.com>
Date:   Tue, 9 May 2023 11:29:28 -0700
Message-ID: <CALs-HssafUZwXbxptGN3N-+2jD+6tvU=YbAZir9LsYwsEM8gBQ@mail.gmail.com>
Subject: Re: [PATCH -next v19 03/24] riscv: hwprobe: Add support for RISCV_HWPROBE_BASE_BEHAVIOR_V
To:     Palmer Dabbelt <palmer@dabbelt.com>
Cc:     andy.chiu@sifive.com, heiko@sntech.de,
        linux-riscv@lists.infradead.org, anup@brainfault.org,
        atishp@atishpatra.org, kvm-riscv@lists.infradead.org,
        kvm@vger.kernel.org, Vineet Gupta <vineetg@rivosinc.com>,
        greentime.hu@sifive.com, guoren@linux.alibaba.com, corbet@lwn.net,
        Paul Walmsley <paul.walmsley@sifive.com>,
        aou@eecs.berkeley.edu, Conor Dooley <conor.dooley@microchip.com>,
        ajones@ventanamicro.com, coelacanthus@outlook.com,
        abrestic@rivosinc.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 9, 2023 at 10:59=E2=80=AFAM Palmer Dabbelt <palmer@dabbelt.com>=
 wrote:
>
> On Tue, 09 May 2023 10:32:03 PDT (-0700), Evan Green wrote:
> > On Tue, May 9, 2023 at 9:41=E2=80=AFAM Andy Chiu <andy.chiu@sifive.com>=
 wrote:
> >>
> >> On Tue, May 9, 2023 at 7:05=E2=80=AFPM Heiko St=C3=BCbner <heiko@sntec=
h.de> wrote:
> >> >
> >> > Am Dienstag, 9. Mai 2023, 12:30:12 CEST schrieb Andy Chiu:
> >> > > Probing kernel support for Vector extension is available now.
> >> > >
> >> > > Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
> >> > > ---
> >> > >  Documentation/riscv/hwprobe.rst       | 10 ++++++++++
> >> > >  arch/riscv/include/asm/hwprobe.h      |  2 +-
> >> > >  arch/riscv/include/uapi/asm/hwprobe.h |  3 +++
> >> > >  arch/riscv/kernel/sys_riscv.c         |  9 +++++++++
> >> > >  4 files changed, 23 insertions(+), 1 deletion(-)
> >> > >
> >> > > diff --git a/Documentation/riscv/hwprobe.rst b/Documentation/riscv=
/hwprobe.rst
> >> > > index 9f0dd62dcb5d..b8755e180fbf 100644
> >> > > --- a/Documentation/riscv/hwprobe.rst
> >> > > +++ b/Documentation/riscv/hwprobe.rst
> >> > > @@ -53,6 +53,9 @@ The following keys are defined:
> >> > >        programs (it may still be executed in userspace via a
> >> > >        kernel-controlled mechanism such as the vDSO).
> >> > >
> >> > > +  * :c:macro:`RISCV_HWPROBE_BASE_BEHAVIOR_V`: Support for Vector =
extension, as
> >> > > +    defined by verion 1.0 of the RISC-V Vector extension.
> >> >
> >> >         ^^ version [missing the S]
> >> >
> >> > > +
> >> > >  * :c:macro:`RISCV_HWPROBE_KEY_IMA_EXT_0`: A bitmask containing th=
e extensions
> >> > >    that are compatible with the :c:macro:`RISCV_HWPROBE_BASE_BEHAV=
IOR_IMA`:
> >> > >    base system behavior.
> >> > > @@ -64,6 +67,13 @@ The following keys are defined:
> >> > >    * :c:macro:`RISCV_HWPROBE_IMA_C`: The C extension is supported,=
 as defined
> >> > >      by version 2.2 of the RISC-V ISA manual.
> >> > >
> >> > > +* :c:macro:`RISCV_HWPROBE_KEY_V_EXT_0`: A bitmask containing the =
extensions
> >> > > +   that are compatible with the :c:macro:`RISCV_HWPROBE_BASE_BEHA=
VIOR_V`: base
> >> > > +   system behavior.
> >> > > +
> >> > > +  * :c:macro:`RISCV_HWPROBE_V`: The V extension is supported, as =
defined by
> >> > > +    version 1.0 of the RISC-V Vector extension manual.
> >> > > +
> >> >
> >> > this seems to be doubling the RISCV_HWPROBE_BASE_BEHAVIOR_V state wi=
thout
> >> > adding additional information? Both essentially tell the system that
> >> > V extension "defined by verion 1.0 of the RISC-V Vector extension" i=
s supported.
> >>
> >> I was thinking that RISCV_HWPROBE_BASE_BEHAVIOR_V indicates the kernel
> >> has a probe for vector (just like RISCV_HWPROBE_BASE_BEHAVIOR_IMA) and
> >> RISCV_HWPROBE_KEY_V_EXT_0 is where the kernel reports what exactly the
> >> extension is. This maps to the condition matching of F,D, and C in
> >> IMA. If that is not the case then I think there is no need for this
> >> entry.
> >>
> >> >
> >> > I don't question that we'll probably need a key for deeper vector-
> >> > specifics but I guess I'd the commit message should definitly explai=
n
> >> > why there is a duplication here.
> >>
> >> I suppose something like Zvfh should fall into the category of
> >> RISCV_HWPROBE_KEY_V_EXT_0. I will add this example into the commit
> >> message if you agree that is a good example.
> >>
> >> >
> >> >
> >> > >  * :c:macro:`RISCV_HWPROBE_KEY_CPUPERF_0`: A bitmask that contains=
 performance
> >> > >    information about the selected set of processors.
> >> > >
> >> > > diff --git a/arch/riscv/include/asm/hwprobe.h b/arch/riscv/include=
/asm/hwprobe.h
> >> > > index 78936f4ff513..39df8604fea1 100644
> >> > > --- a/arch/riscv/include/asm/hwprobe.h
> >> > > +++ b/arch/riscv/include/asm/hwprobe.h
> >> > > @@ -8,6 +8,6 @@
> >> > >
> >> > >  #include <uapi/asm/hwprobe.h>
> >> > >
> >> > > -#define RISCV_HWPROBE_MAX_KEY 5
> >> > > +#define RISCV_HWPROBE_MAX_KEY 6
> >> > >
> >> > >  #endif
> >> > > diff --git a/arch/riscv/include/uapi/asm/hwprobe.h b/arch/riscv/in=
clude/uapi/asm/hwprobe.h
> >> > > index 8d745a4ad8a2..93a7fd3fd341 100644
> >> > > --- a/arch/riscv/include/uapi/asm/hwprobe.h
> >> > > +++ b/arch/riscv/include/uapi/asm/hwprobe.h
> >> > > @@ -22,6 +22,7 @@ struct riscv_hwprobe {
> >> > >  #define RISCV_HWPROBE_KEY_MIMPID     2
> >> > >  #define RISCV_HWPROBE_KEY_BASE_BEHAVIOR      3
> >> > >  #define              RISCV_HWPROBE_BASE_BEHAVIOR_IMA (1 << 0)
> >> > > +#define              RISCV_HWPROBE_BASE_BEHAVIOR_V   (1 << 1)
> >> > >  #define RISCV_HWPROBE_KEY_IMA_EXT_0  4
> >> > >  #define              RISCV_HWPROBE_IMA_FD            (1 << 0)
> >> > >  #define              RISCV_HWPROBE_IMA_C             (1 << 1)
> >> > > @@ -32,6 +33,8 @@ struct riscv_hwprobe {
> >> > >  #define              RISCV_HWPROBE_MISALIGNED_FAST           (3 <=
< 0)
> >> > >  #define              RISCV_HWPROBE_MISALIGNED_UNSUPPORTED    (4 <=
< 0)
> >> > >  #define              RISCV_HWPROBE_MISALIGNED_MASK           (7 <=
< 0)
> >> > > +#define RISCV_HWPROBE_KEY_V_EXT_0    6
> >> > > +#define              RISCV_HWPROBE_V                 (1 << 0)
> >> > >  /* Increase RISCV_HWPROBE_MAX_KEY when adding items. */
> >> > >
> >> > >  #endif
> >> > > diff --git a/arch/riscv/kernel/sys_riscv.c b/arch/riscv/kernel/sys=
_riscv.c
> >> > > index 5db29683ebee..6280a7f778b3 100644
> >> > > --- a/arch/riscv/kernel/sys_riscv.c
> >> > > +++ b/arch/riscv/kernel/sys_riscv.c
> >> > > @@ -10,6 +10,7 @@
> >> > >  #include <asm/cpufeature.h>
> >> > >  #include <asm/hwprobe.h>
> >> > >  #include <asm/sbi.h>
> >> > > +#include <asm/vector.h>
> >> > >  #include <asm/switch_to.h>
> >> > >  #include <asm/uaccess.h>
> >> > >  #include <asm/unistd.h>
> >> > > @@ -161,6 +162,7 @@ static void hwprobe_one_pair(struct riscv_hwpr=
obe *pair,
> >> > >        */
> >> > >       case RISCV_HWPROBE_KEY_BASE_BEHAVIOR:
> >> > >               pair->value =3D RISCV_HWPROBE_BASE_BEHAVIOR_IMA;
> >> > > +             pair->value |=3D RISCV_HWPROBE_BASE_BEHAVIOR_V;
> >> >
> >> > Doesn't this also need a
> >> >         if (has_vector())
> >> >
> >>
> >> If the RISCV_HWPROBE_KEY_BASE_BEHAVIOR part just tells whether hwprobe
> >> supports probing of a set of extensions then I think we should not add
> >> the if statement here, but maybe I misunderstood something..
> >
> > The intention was to show that the I, M, and A extensions are actually
> > present on this machine, not that the other probe keys exist. Usermode
> > is allowed to query any hwprobe key, they just get back the key set to
> > -1 and value set to 0 on unknown keys. We "cheated" a bit for
> > determining I, M, and A exist since they're already prerequisites of
> > Linux, which is why there's no conditional there.
>
> We should probably add a comment so it doesn't trip someone up again.

There is one there, it just got clipped in the context diff. It looks
like this (after gmail mangles it):

/*
* The kernel already assumes that the base single-letter ISA
* extensions are supported on all harts, and only supports the
* IMA base, so just cheat a bit here and tell that to
* userspace.
*/
case RISCV_HWPROBE_KEY_BASE_BEHAVIOR:
pair->value =3D RISCV_HWPROBE_BASE_BEHAVIOR_IMA;
break;
