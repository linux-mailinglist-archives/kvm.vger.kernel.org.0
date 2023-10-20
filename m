Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F4D67D0CAA
	for <lists+kvm@lfdr.de>; Fri, 20 Oct 2023 12:06:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376796AbjJTKGl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Oct 2023 06:06:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376648AbjJTKGk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Oct 2023 06:06:40 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8C3AB6
        for <kvm@vger.kernel.org>; Fri, 20 Oct 2023 03:06:38 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id d2e1a72fcca58-6bd73395bceso523022b3a.0
        for <kvm@vger.kernel.org>; Fri, 20 Oct 2023 03:06:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1697796398; x=1698401198; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R0YOpu7rT/QqTy8iuI5dRazXgRC1Ukab7cBL+9gy4Ic=;
        b=ImJjqWalZTdFJyq64kMO14sl/dgEnzPMZKp5uGDNN+9PTP6Anq9ZWBgaHx7SjWYGha
         WA8KnpPcNll+IfehlPjLJS0uaUM55L98C++z0229LoBE2/UJHXPkk93/zBh032PwUi5u
         rf/ApTnFIhPBevS+MTTlqb7dvvHR/hXw3+7q4hb3mWSvMjU9DEQolFbcsJ4N0NddMSbG
         NHZhvoi8Q+8AfCfp5qHGVP1Rty5RK99XJr+51LE3Ts7J5pHPVc/i77BR6faxO1ud2ESq
         3DpZQeMm8ekfwyQEYquQTrVPKamTRLtcWNPKio9+DhAYy/CmiXZY2fu7c2j9TELYYSlm
         FK9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697796398; x=1698401198;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=R0YOpu7rT/QqTy8iuI5dRazXgRC1Ukab7cBL+9gy4Ic=;
        b=l5bgt+Qjf0UnM2kzoHbatmxST1xHsoSPIyMABqnHBaeBvqcPHjfFnGxlIGKfwj8mNo
         NipsbOqPRb9RMk47Sy60B01oCaDjKZVjSuiXkVMyxmH5BBIYED0Z3EFGEPfALkbzQO4i
         7JTiY/MduOFlNP7HfU1jnDq3gv37kRg+CVeSvy4YtQtQMjU82uLVBxFt0w5d7QH01mwZ
         YG024/6OUxl4J6JD0lGic68HbhjWXrc9aQB9rtb2VuF9Rq/zv5YlHHBABRpFvivuFmMZ
         HBh+zFgg1Prph/fbnncIJdRy5ftdRUyCbUAb4w2ZE8AX9BygPR8vGZ9w2FYfdMBGUoPg
         mdYQ==
X-Gm-Message-State: AOJu0YzC10SJYC4+Y58iFn0J9vPQvyds6W2q2E6hZa5nWJkqbsxy8kkQ
        boyum3GOFQufoC832xTyZivzUOJTc5HlFBwqezt5Qw==
X-Google-Smtp-Source: AGHT+IEBzXt8JfC9x1TW5x5JgWjODdGFRcged+43rxtT/zbYgt03X8xn6eJrhjX3Tc0jf12JuE1HThvuDkHZ4TvXIUs=
X-Received: by 2002:a05:6a21:1a5:b0:17a:e981:817e with SMTP id
 le37-20020a056a2101a500b0017ae981817emr1962557pzb.3.1697796398116; Fri, 20
 Oct 2023 03:06:38 -0700 (PDT)
MIME-Version: 1.0
References: <20231020072140.900967-1-apatel@ventanamicro.com>
 <20231020072140.900967-9-apatel@ventanamicro.com> <87mswdbot2.fsf@all.your.base.are.belong.to.us>
In-Reply-To: <87mswdbot2.fsf@all.your.base.are.belong.to.us>
From:   Anup Patel <apatel@ventanamicro.com>
Date:   Fri, 20 Oct 2023 15:36:25 +0530
Message-ID: <CAK9=C2XrDCpq6cGCJu2CVowiksxunGwfF4JxwEZ_k85+3bU1+Q@mail.gmail.com>
Subject: Re: [PATCH v3 8/9] tty: Add SBI debug console support to HVC SBI driver
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Conor Dooley <conor@kernel.org>,
        Andrew Jones <ajones@ventanamicro.com>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-serial@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Atish Patra <atishp@rivosinc.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 20, 2023 at 3:25=E2=80=AFPM Bj=C3=B6rn T=C3=B6pel <bjorn@kernel=
.org> wrote:
>
> Anup Patel <apatel@ventanamicro.com> writes:
>
> > From: Atish Patra <atishp@rivosinc.com>
> >
> > RISC-V SBI specification supports advanced debug console
> > support via SBI DBCN extension.
> >
> > Extend the HVC SBI driver to support it.
> >
> > Signed-off-by: Atish Patra <atishp@rivosinc.com>
> > Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> > ---
> >  drivers/tty/hvc/Kconfig         |  2 +-
> >  drivers/tty/hvc/hvc_riscv_sbi.c | 82 ++++++++++++++++++++++++++++++---
> >  2 files changed, 76 insertions(+), 8 deletions(-)
> >
> > diff --git a/drivers/tty/hvc/Kconfig b/drivers/tty/hvc/Kconfig
> > index 4f9264d005c0..6e05c5c7bca1 100644
> > --- a/drivers/tty/hvc/Kconfig
> > +++ b/drivers/tty/hvc/Kconfig
> > @@ -108,7 +108,7 @@ config HVC_DCC_SERIALIZE_SMP
> >
> >  config HVC_RISCV_SBI
> >       bool "RISC-V SBI console support"
> > -     depends on RISCV_SBI_V01
> > +     depends on RISCV_SBI
> >       select HVC_DRIVER
> >       help
> >         This enables support for console output via RISC-V SBI calls, w=
hich
> > diff --git a/drivers/tty/hvc/hvc_riscv_sbi.c b/drivers/tty/hvc/hvc_risc=
v_sbi.c
> > index 31f53fa77e4a..56da1a4b5aca 100644
> > --- a/drivers/tty/hvc/hvc_riscv_sbi.c
> > +++ b/drivers/tty/hvc/hvc_riscv_sbi.c
> > @@ -39,21 +39,89 @@ static int hvc_sbi_tty_get(uint32_t vtermno, char *=
buf, int count)
> >       return i;
> >  }
> >
> > -static const struct hv_ops hvc_sbi_ops =3D {
> > +static const struct hv_ops hvc_sbi_v01_ops =3D {
> >       .get_chars =3D hvc_sbi_tty_get,
> >       .put_chars =3D hvc_sbi_tty_put,
> >  };
> >
> > -static int __init hvc_sbi_init(void)
> > +static int hvc_sbi_dbcn_tty_put(uint32_t vtermno, const char *buf, int=
 count)
> >  {
> > -     return PTR_ERR_OR_ZERO(hvc_alloc(0, 0, &hvc_sbi_ops, 16));
> > +     phys_addr_t pa;
> > +     struct sbiret ret;
> > +
> > +     if (is_vmalloc_addr(buf)) {
> > +             pa =3D page_to_phys(vmalloc_to_page(buf)) + offset_in_pag=
e(buf);
> > +             if (PAGE_SIZE < (offset_in_page(buf) + count))
> > +                     count =3D PAGE_SIZE - offset_in_page(buf);
>
> Thanks for fixing the cross-page issue. Now you're cutting the buffer
> off. What about doing two SBI calls instead? (Dito on the get side)

We don't need to handle that because the hvc_console framework
will ensure remaining characters are sent-out. Same applies to
get side as well.

Regards,
Anup
