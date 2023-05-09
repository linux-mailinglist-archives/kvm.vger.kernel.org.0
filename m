Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A43F06FCB82
	for <lists+kvm@lfdr.de>; Tue,  9 May 2023 18:41:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229539AbjEIQlw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 May 2023 12:41:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbjEIQlu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 May 2023 12:41:50 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD23E1BD4
        for <kvm@vger.kernel.org>; Tue,  9 May 2023 09:41:48 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id 2adb3069b0e04-4f24cfb8539so3305713e87.3
        for <kvm@vger.kernel.org>; Tue, 09 May 2023 09:41:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1683650507; x=1686242507;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FROceCXxvPLn3QgmwriNBcr2jTNl45QJMsriOAUhI2g=;
        b=PgVynsszyyDyJGa76hskdhLRs7gtISWteMbz7DjIIAEbcrcuBJfGiLm02fl1AuOGB7
         DDC7eukMYF1Rk78C73SEFyLxsFE/wtrsJTZG6gR17rF4n8RILKY/9Jv6MdlMuxhujHkT
         YbY8bRX3qj2fOmfLbCB8XRA+E0KYhR+Z0PDFj0e9npVLz4Z2iFe7nOTPf8HB+8YHTTk9
         fryfaFH/K92YPwmkM38Mdr4sRKMX2XoH/9+IOp8ZRSEBqqWEv0AG7hzoy/tqhATBDAhd
         wDI2lQJY1BfAw9mv8xipo4vZRM/PnffOo/FRJTsm0Vqj3f4Wkc7lJVjG5MgOg0lLdM0X
         22eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683650507; x=1686242507;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FROceCXxvPLn3QgmwriNBcr2jTNl45QJMsriOAUhI2g=;
        b=JA/GehOjh0bsgcXfegbO5cYI9wumqHJTPZF74b0GTBslaDDL3qrUyNHXYpC0gjtbNv
         1eLP9Oj1wRq+U4RDr5uLyuLaU4Yffu+hAJ/3Wu66L7o7YBCOVaAzfp8/IdZ0SXcWPyeD
         FQcSxhZjWZqNbiAwFG3NqJAhOIiUjTgfuxNHkixMe5CdhZzGHt/xmgpn0teNBWBc1tFT
         7id4KSm63Zi3bjD6Ea3uYjKcQP0uWYBCj463PiklNrlIFz6qhxFpPoB3a0mzH9YhpJ2y
         S00QLovT11IuUAdHUUbsNZXG3+R92BN0U0Pe9UBLxtcIHbcfEM88Y260kkzVECU9LjZ1
         3lCg==
X-Gm-Message-State: AC+VfDwqkvbHKzpCyiYLEkP5ceRnZ9d1l/HUa+Un+VUKsbSFEb64FPbb
        36jeZ01Z56+jPrxd5p5Jl04n2stGeaLSOD+QocPS1g==
X-Google-Smtp-Source: ACHHUZ42TNEnMm6quoByyvMr3JNETn4d0SUot+zK2QvMKh4CfjQ3FheXMimT+5RPUmyaweYtBVrJ0zocQVt2X4nxcks=
X-Received: by 2002:a05:6512:906:b0:4ed:c640:a20d with SMTP id
 e6-20020a056512090600b004edc640a20dmr902453lft.49.1683650506884; Tue, 09 May
 2023 09:41:46 -0700 (PDT)
MIME-Version: 1.0
References: <20230509103033.11285-1-andy.chiu@sifive.com> <20230509103033.11285-4-andy.chiu@sifive.com>
 <2172277.NgBsaNRSFp@diego>
In-Reply-To: <2172277.NgBsaNRSFp@diego>
From:   Andy Chiu <andy.chiu@sifive.com>
Date:   Wed, 10 May 2023 00:41:35 +0800
Message-ID: <CABgGipW0U6=4AhaM9zWPDKZYdKEYDi04Gm-uRmf_WoOioTaf6w@mail.gmail.com>
Subject: Re: [PATCH -next v19 03/24] riscv: hwprobe: Add support for RISCV_HWPROBE_BASE_BEHAVIOR_V
To:     =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>
Cc:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Jonathan Corbet <corbet@lwn.net>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Evan Green <evan@rivosinc.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        Andrew Jones <ajones@ventanamicro.com>,
        Celeste Liu <coelacanthus@outlook.com>,
        Andrew Bresticker <abrestic@rivosinc.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 9, 2023 at 7:05=E2=80=AFPM Heiko St=C3=BCbner <heiko@sntech.de>=
 wrote:
>
> Am Dienstag, 9. Mai 2023, 12:30:12 CEST schrieb Andy Chiu:
> > Probing kernel support for Vector extension is available now.
> >
> > Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
> > ---
> >  Documentation/riscv/hwprobe.rst       | 10 ++++++++++
> >  arch/riscv/include/asm/hwprobe.h      |  2 +-
> >  arch/riscv/include/uapi/asm/hwprobe.h |  3 +++
> >  arch/riscv/kernel/sys_riscv.c         |  9 +++++++++
> >  4 files changed, 23 insertions(+), 1 deletion(-)
> >
> > diff --git a/Documentation/riscv/hwprobe.rst b/Documentation/riscv/hwpr=
obe.rst
> > index 9f0dd62dcb5d..b8755e180fbf 100644
> > --- a/Documentation/riscv/hwprobe.rst
> > +++ b/Documentation/riscv/hwprobe.rst
> > @@ -53,6 +53,9 @@ The following keys are defined:
> >        programs (it may still be executed in userspace via a
> >        kernel-controlled mechanism such as the vDSO).
> >
> > +  * :c:macro:`RISCV_HWPROBE_BASE_BEHAVIOR_V`: Support for Vector exten=
sion, as
> > +    defined by verion 1.0 of the RISC-V Vector extension.
>
>         ^^ version [missing the S]
>
> > +
> >  * :c:macro:`RISCV_HWPROBE_KEY_IMA_EXT_0`: A bitmask containing the ext=
ensions
> >    that are compatible with the :c:macro:`RISCV_HWPROBE_BASE_BEHAVIOR_I=
MA`:
> >    base system behavior.
> > @@ -64,6 +67,13 @@ The following keys are defined:
> >    * :c:macro:`RISCV_HWPROBE_IMA_C`: The C extension is supported, as d=
efined
> >      by version 2.2 of the RISC-V ISA manual.
> >
> > +* :c:macro:`RISCV_HWPROBE_KEY_V_EXT_0`: A bitmask containing the exten=
sions
> > +   that are compatible with the :c:macro:`RISCV_HWPROBE_BASE_BEHAVIOR_=
V`: base
> > +   system behavior.
> > +
> > +  * :c:macro:`RISCV_HWPROBE_V`: The V extension is supported, as defin=
ed by
> > +    version 1.0 of the RISC-V Vector extension manual.
> > +
>
> this seems to be doubling the RISCV_HWPROBE_BASE_BEHAVIOR_V state without
> adding additional information? Both essentially tell the system that
> V extension "defined by verion 1.0 of the RISC-V Vector extension" is sup=
ported.

I was thinking that RISCV_HWPROBE_BASE_BEHAVIOR_V indicates the kernel
has a probe for vector (just like RISCV_HWPROBE_BASE_BEHAVIOR_IMA) and
RISCV_HWPROBE_KEY_V_EXT_0 is where the kernel reports what exactly the
extension is. This maps to the condition matching of F,D, and C in
IMA. If that is not the case then I think there is no need for this
entry.

>
> I don't question that we'll probably need a key for deeper vector-
> specifics but I guess I'd the commit message should definitly explain
> why there is a duplication here.

I suppose something like Zvfh should fall into the category of
RISCV_HWPROBE_KEY_V_EXT_0. I will add this example into the commit
message if you agree that is a good example.

>
>
> >  * :c:macro:`RISCV_HWPROBE_KEY_CPUPERF_0`: A bitmask that contains perf=
ormance
> >    information about the selected set of processors.
> >
> > diff --git a/arch/riscv/include/asm/hwprobe.h b/arch/riscv/include/asm/=
hwprobe.h
> > index 78936f4ff513..39df8604fea1 100644
> > --- a/arch/riscv/include/asm/hwprobe.h
> > +++ b/arch/riscv/include/asm/hwprobe.h
> > @@ -8,6 +8,6 @@
> >
> >  #include <uapi/asm/hwprobe.h>
> >
> > -#define RISCV_HWPROBE_MAX_KEY 5
> > +#define RISCV_HWPROBE_MAX_KEY 6
> >
> >  #endif
> > diff --git a/arch/riscv/include/uapi/asm/hwprobe.h b/arch/riscv/include=
/uapi/asm/hwprobe.h
> > index 8d745a4ad8a2..93a7fd3fd341 100644
> > --- a/arch/riscv/include/uapi/asm/hwprobe.h
> > +++ b/arch/riscv/include/uapi/asm/hwprobe.h
> > @@ -22,6 +22,7 @@ struct riscv_hwprobe {
> >  #define RISCV_HWPROBE_KEY_MIMPID     2
> >  #define RISCV_HWPROBE_KEY_BASE_BEHAVIOR      3
> >  #define              RISCV_HWPROBE_BASE_BEHAVIOR_IMA (1 << 0)
> > +#define              RISCV_HWPROBE_BASE_BEHAVIOR_V   (1 << 1)
> >  #define RISCV_HWPROBE_KEY_IMA_EXT_0  4
> >  #define              RISCV_HWPROBE_IMA_FD            (1 << 0)
> >  #define              RISCV_HWPROBE_IMA_C             (1 << 1)
> > @@ -32,6 +33,8 @@ struct riscv_hwprobe {
> >  #define              RISCV_HWPROBE_MISALIGNED_FAST           (3 << 0)
> >  #define              RISCV_HWPROBE_MISALIGNED_UNSUPPORTED    (4 << 0)
> >  #define              RISCV_HWPROBE_MISALIGNED_MASK           (7 << 0)
> > +#define RISCV_HWPROBE_KEY_V_EXT_0    6
> > +#define              RISCV_HWPROBE_V                 (1 << 0)
> >  /* Increase RISCV_HWPROBE_MAX_KEY when adding items. */
> >
> >  #endif
> > diff --git a/arch/riscv/kernel/sys_riscv.c b/arch/riscv/kernel/sys_risc=
v.c
> > index 5db29683ebee..6280a7f778b3 100644
> > --- a/arch/riscv/kernel/sys_riscv.c
> > +++ b/arch/riscv/kernel/sys_riscv.c
> > @@ -10,6 +10,7 @@
> >  #include <asm/cpufeature.h>
> >  #include <asm/hwprobe.h>
> >  #include <asm/sbi.h>
> > +#include <asm/vector.h>
> >  #include <asm/switch_to.h>
> >  #include <asm/uaccess.h>
> >  #include <asm/unistd.h>
> > @@ -161,6 +162,7 @@ static void hwprobe_one_pair(struct riscv_hwprobe *=
pair,
> >        */
> >       case RISCV_HWPROBE_KEY_BASE_BEHAVIOR:
> >               pair->value =3D RISCV_HWPROBE_BASE_BEHAVIOR_IMA;
> > +             pair->value |=3D RISCV_HWPROBE_BASE_BEHAVIOR_V;
>
> Doesn't this also need a
>         if (has_vector())
>

If the RISCV_HWPROBE_KEY_BASE_BEHAVIOR part just tells whether hwprobe
supports probing of a set of extensions then I think we should not add
the if statement here, but maybe I misunderstood something..

>
> Heiko
>
> >               break;
> >
> >       case RISCV_HWPROBE_KEY_IMA_EXT_0:
> > @@ -173,6 +175,13 @@ static void hwprobe_one_pair(struct riscv_hwprobe =
*pair,
> >
> >               break;
> >
> > +     case RISCV_HWPROBE_KEY_V_EXT_0:
> > +             pair->value =3D 0;
> > +             if (has_vector())
> > +                     pair->value |=3D RISCV_HWPROBE_V;
> > +
> > +             break;
> > +
> >       case RISCV_HWPROBE_KEY_CPUPERF_0:
> >               pair->value =3D hwprobe_misaligned(cpus);
> >               break;
> >
>
>
>
>

Thanks,
Andy
