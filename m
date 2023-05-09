Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F3326FCCC9
	for <lists+kvm@lfdr.de>; Tue,  9 May 2023 19:32:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234798AbjEIRcp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 May 2023 13:32:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230198AbjEIRcn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 May 2023 13:32:43 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9579B40C0
        for <kvm@vger.kernel.org>; Tue,  9 May 2023 10:32:41 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id 2adb3069b0e04-4f139de8cefso35260432e87.0
        for <kvm@vger.kernel.org>; Tue, 09 May 2023 10:32:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20221208.gappssmtp.com; s=20221208; t=1683653560; x=1686245560;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IsBc4OUVKU79CuNh6s1CDRhWpEPdYDoZ5WJAHHiWarw=;
        b=3/wV+jhO6GMHOISz4RaIHmCizn5M2+0JiQOMpqDz3sviYuJI0d1U+LLWPLttP9lYxD
         incEKswQ8XIImYR2XkWPBfEXDEJ+witiKdQBn17Nj87kMI3VETXQNc17oLNwPhP4lJov
         ncARr3jdW+fiE/LWBrsFX8G3pcr6tn818cLD2QDMdkAj24M0f1SO5NSsnJwJ1nCShyuC
         bGUmZ7P517lAlZLrIOsETSfbSq86OXeRdkAUKw/LVN2/k+BrausuNryrm8Z6ZDB6eo56
         Hvfoyb/LdJxa286/3y/709Khk8B5h12BPkqPqyPNuEY2ZY3fyFXr/0HBYYW2yq0D2+xK
         tSMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683653560; x=1686245560;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IsBc4OUVKU79CuNh6s1CDRhWpEPdYDoZ5WJAHHiWarw=;
        b=RnxT+XECW/Dn45yC0HKz/MPJbUGsSJYePaDsgBK86+s9+j4h1bEdG6/hTmHKNSX1ho
         yhk5213cNKFe38ulNqEx7MrN6cEkwcTY3iZnXtUZOTYj5iTOgxabD8cXltjpQhtalR2Q
         uUe32+3VzPUQUYzb+VR4jihtOve2xlUSBJZHRieFHmzzAlD9ahEf3NfNg9UsRbAeGp2x
         HXg40FRqcx8qlxzFWnmfnZsx5xRxL6SXCmUbFS/ouVFmm8praAsqmFHuEkN/0cuCJZIp
         057B9qI/F/cMYFgK9k1885hx4rwT1Jv1DkLgRk8msKBJpCeE8ZetHK1Jg/pYvwfHqkyn
         EFCA==
X-Gm-Message-State: AC+VfDzlL0U8bjn2lS7NJrqFJ98gYR/ld0WvpHXrlLtc79hyPFg2qroi
        AP3WNL1fbZRL8NeJQxJnUZO2aU6xPbLwj54j2Iox3Q==
X-Google-Smtp-Source: ACHHUZ70lBjWokfJLkTr58sjXyruW1neYyvWrkYTXIj2WyT3RMBbAg3l5wPYYz8tDqPxUg5BGbMOazH33xA5yJ+prxM=
X-Received: by 2002:ac2:4d03:0:b0:4ef:ebbb:2cf5 with SMTP id
 r3-20020ac24d03000000b004efebbb2cf5mr1045596lfi.17.1683653559811; Tue, 09 May
 2023 10:32:39 -0700 (PDT)
MIME-Version: 1.0
References: <20230509103033.11285-1-andy.chiu@sifive.com> <20230509103033.11285-4-andy.chiu@sifive.com>
 <2172277.NgBsaNRSFp@diego> <CABgGipW0U6=4AhaM9zWPDKZYdKEYDi04Gm-uRmf_WoOioTaf6w@mail.gmail.com>
In-Reply-To: <CABgGipW0U6=4AhaM9zWPDKZYdKEYDi04Gm-uRmf_WoOioTaf6w@mail.gmail.com>
From:   Evan Green <evan@rivosinc.com>
Date:   Tue, 9 May 2023 10:32:03 -0700
Message-ID: <CALs-Hss8L478Pg7zdcVZkL-jGGqdXtQd+uy+JdNEey90+eBYiA@mail.gmail.com>
Subject: Re: [PATCH -next v19 03/24] riscv: hwprobe: Add support for RISCV_HWPROBE_BASE_BEHAVIOR_V
To:     Andy Chiu <andy.chiu@sifive.com>
Cc:     =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Jonathan Corbet <corbet@lwn.net>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Conor Dooley <conor.dooley@microchip.com>,
        Andrew Jones <ajones@ventanamicro.com>,
        Celeste Liu <coelacanthus@outlook.com>,
        Andrew Bresticker <abrestic@rivosinc.com>
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

On Tue, May 9, 2023 at 9:41=E2=80=AFAM Andy Chiu <andy.chiu@sifive.com> wro=
te:
>
> On Tue, May 9, 2023 at 7:05=E2=80=AFPM Heiko St=C3=BCbner <heiko@sntech.d=
e> wrote:
> >
> > Am Dienstag, 9. Mai 2023, 12:30:12 CEST schrieb Andy Chiu:
> > > Probing kernel support for Vector extension is available now.
> > >
> > > Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
> > > ---
> > >  Documentation/riscv/hwprobe.rst       | 10 ++++++++++
> > >  arch/riscv/include/asm/hwprobe.h      |  2 +-
> > >  arch/riscv/include/uapi/asm/hwprobe.h |  3 +++
> > >  arch/riscv/kernel/sys_riscv.c         |  9 +++++++++
> > >  4 files changed, 23 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/Documentation/riscv/hwprobe.rst b/Documentation/riscv/hw=
probe.rst
> > > index 9f0dd62dcb5d..b8755e180fbf 100644
> > > --- a/Documentation/riscv/hwprobe.rst
> > > +++ b/Documentation/riscv/hwprobe.rst
> > > @@ -53,6 +53,9 @@ The following keys are defined:
> > >        programs (it may still be executed in userspace via a
> > >        kernel-controlled mechanism such as the vDSO).
> > >
> > > +  * :c:macro:`RISCV_HWPROBE_BASE_BEHAVIOR_V`: Support for Vector ext=
ension, as
> > > +    defined by verion 1.0 of the RISC-V Vector extension.
> >
> >         ^^ version [missing the S]
> >
> > > +
> > >  * :c:macro:`RISCV_HWPROBE_KEY_IMA_EXT_0`: A bitmask containing the e=
xtensions
> > >    that are compatible with the :c:macro:`RISCV_HWPROBE_BASE_BEHAVIOR=
_IMA`:
> > >    base system behavior.
> > > @@ -64,6 +67,13 @@ The following keys are defined:
> > >    * :c:macro:`RISCV_HWPROBE_IMA_C`: The C extension is supported, as=
 defined
> > >      by version 2.2 of the RISC-V ISA manual.
> > >
> > > +* :c:macro:`RISCV_HWPROBE_KEY_V_EXT_0`: A bitmask containing the ext=
ensions
> > > +   that are compatible with the :c:macro:`RISCV_HWPROBE_BASE_BEHAVIO=
R_V`: base
> > > +   system behavior.
> > > +
> > > +  * :c:macro:`RISCV_HWPROBE_V`: The V extension is supported, as def=
ined by
> > > +    version 1.0 of the RISC-V Vector extension manual.
> > > +
> >
> > this seems to be doubling the RISCV_HWPROBE_BASE_BEHAVIOR_V state witho=
ut
> > adding additional information? Both essentially tell the system that
> > V extension "defined by verion 1.0 of the RISC-V Vector extension" is s=
upported.
>
> I was thinking that RISCV_HWPROBE_BASE_BEHAVIOR_V indicates the kernel
> has a probe for vector (just like RISCV_HWPROBE_BASE_BEHAVIOR_IMA) and
> RISCV_HWPROBE_KEY_V_EXT_0 is where the kernel reports what exactly the
> extension is. This maps to the condition matching of F,D, and C in
> IMA. If that is not the case then I think there is no need for this
> entry.
>
> >
> > I don't question that we'll probably need a key for deeper vector-
> > specifics but I guess I'd the commit message should definitly explain
> > why there is a duplication here.
>
> I suppose something like Zvfh should fall into the category of
> RISCV_HWPROBE_KEY_V_EXT_0. I will add this example into the commit
> message if you agree that is a good example.
>
> >
> >
> > >  * :c:macro:`RISCV_HWPROBE_KEY_CPUPERF_0`: A bitmask that contains pe=
rformance
> > >    information about the selected set of processors.
> > >
> > > diff --git a/arch/riscv/include/asm/hwprobe.h b/arch/riscv/include/as=
m/hwprobe.h
> > > index 78936f4ff513..39df8604fea1 100644
> > > --- a/arch/riscv/include/asm/hwprobe.h
> > > +++ b/arch/riscv/include/asm/hwprobe.h
> > > @@ -8,6 +8,6 @@
> > >
> > >  #include <uapi/asm/hwprobe.h>
> > >
> > > -#define RISCV_HWPROBE_MAX_KEY 5
> > > +#define RISCV_HWPROBE_MAX_KEY 6
> > >
> > >  #endif
> > > diff --git a/arch/riscv/include/uapi/asm/hwprobe.h b/arch/riscv/inclu=
de/uapi/asm/hwprobe.h
> > > index 8d745a4ad8a2..93a7fd3fd341 100644
> > > --- a/arch/riscv/include/uapi/asm/hwprobe.h
> > > +++ b/arch/riscv/include/uapi/asm/hwprobe.h
> > > @@ -22,6 +22,7 @@ struct riscv_hwprobe {
> > >  #define RISCV_HWPROBE_KEY_MIMPID     2
> > >  #define RISCV_HWPROBE_KEY_BASE_BEHAVIOR      3
> > >  #define              RISCV_HWPROBE_BASE_BEHAVIOR_IMA (1 << 0)
> > > +#define              RISCV_HWPROBE_BASE_BEHAVIOR_V   (1 << 1)
> > >  #define RISCV_HWPROBE_KEY_IMA_EXT_0  4
> > >  #define              RISCV_HWPROBE_IMA_FD            (1 << 0)
> > >  #define              RISCV_HWPROBE_IMA_C             (1 << 1)
> > > @@ -32,6 +33,8 @@ struct riscv_hwprobe {
> > >  #define              RISCV_HWPROBE_MISALIGNED_FAST           (3 << 0=
)
> > >  #define              RISCV_HWPROBE_MISALIGNED_UNSUPPORTED    (4 << 0=
)
> > >  #define              RISCV_HWPROBE_MISALIGNED_MASK           (7 << 0=
)
> > > +#define RISCV_HWPROBE_KEY_V_EXT_0    6
> > > +#define              RISCV_HWPROBE_V                 (1 << 0)
> > >  /* Increase RISCV_HWPROBE_MAX_KEY when adding items. */
> > >
> > >  #endif
> > > diff --git a/arch/riscv/kernel/sys_riscv.c b/arch/riscv/kernel/sys_ri=
scv.c
> > > index 5db29683ebee..6280a7f778b3 100644
> > > --- a/arch/riscv/kernel/sys_riscv.c
> > > +++ b/arch/riscv/kernel/sys_riscv.c
> > > @@ -10,6 +10,7 @@
> > >  #include <asm/cpufeature.h>
> > >  #include <asm/hwprobe.h>
> > >  #include <asm/sbi.h>
> > > +#include <asm/vector.h>
> > >  #include <asm/switch_to.h>
> > >  #include <asm/uaccess.h>
> > >  #include <asm/unistd.h>
> > > @@ -161,6 +162,7 @@ static void hwprobe_one_pair(struct riscv_hwprobe=
 *pair,
> > >        */
> > >       case RISCV_HWPROBE_KEY_BASE_BEHAVIOR:
> > >               pair->value =3D RISCV_HWPROBE_BASE_BEHAVIOR_IMA;
> > > +             pair->value |=3D RISCV_HWPROBE_BASE_BEHAVIOR_V;
> >
> > Doesn't this also need a
> >         if (has_vector())
> >
>
> If the RISCV_HWPROBE_KEY_BASE_BEHAVIOR part just tells whether hwprobe
> supports probing of a set of extensions then I think we should not add
> the if statement here, but maybe I misunderstood something..

The intention was to show that the I, M, and A extensions are actually
present on this machine, not that the other probe keys exist. Usermode
is allowed to query any hwprobe key, they just get back the key set to
-1 and value set to 0 on unknown keys. We "cheated" a bit for
determining I, M, and A exist since they're already prerequisites of
Linux, which is why there's no conditional there.
-Evan
