Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E2A76D441C
	for <lists+kvm@lfdr.de>; Mon,  3 Apr 2023 14:06:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232095AbjDCMGL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 08:06:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231792AbjDCMGJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 08:06:09 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C657A9
        for <kvm@vger.kernel.org>; Mon,  3 Apr 2023 05:06:08 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id eg48so116283203edb.13
        for <kvm@vger.kernel.org>; Mon, 03 Apr 2023 05:06:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112; t=1680523567;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UZfKyBaaKHbQvgg/VJsrpQyMIGk/2wuGGA+Z7SD3s4Q=;
        b=hi3PNsTKURB5PVdNZkcXbSPnvmQOvG9rz7V/2C2ROw3ba1F6KlTOwgcj4AtIIhr0ST
         3JfoPVfkamnbtBhUnQiyaLqnV3kq81AUaM6G+D8rT3CfvpATriU8WdWOmaeC/tBDlG2O
         2vb7wClsSykyLAYi7FkDWhKUO4NSA0crquEyH8EDqValishYZ93lVuNAHMiUL6UXBIzM
         UCiv9dKt8RUTV5Bp+Y4cNEC364qr84jwVdGaTnWk7j1a6wW73/+El9GZa/9cbMqGOPTf
         rx1xxDj1JJg8rQJoyoBPgORNB0o+cmt78EhHhTnvdncg3T3MjK1qRyS/EdD2kzeh7+Of
         8fRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680523567;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UZfKyBaaKHbQvgg/VJsrpQyMIGk/2wuGGA+Z7SD3s4Q=;
        b=8FA1a/ZL3NfY7USREGtZuFLY4PYR1b1ToiQEm9z+UHuZ63j3ZK7P7XEIJPDXy1t9k/
         yqCZqu17QB1ctVfkXeYbCGMoIXh59MCdcsJslImdeudZB+mP7cXwsBl2kEQxPqVbw4E/
         lWQ4tpOh9VqGwTKge3tu831hra9Az1RpY2djvPfFnEzheTlMzOI5Ijr6YNVxstaE4Fg/
         NCyEC2UA+ehW+46f4rHYSsThc1YgnOOZBz3UDB2hd2roCDiSSpZ7UXSZO+KjHcQb6PwH
         ag4hXuU/vZxpIygupj1wKitG9ALvnhEhRUxh/Zc7ozYesxqVgCNGkheWG6frJXQjse3j
         40vw==
X-Gm-Message-State: AAQBX9e3N1lycy3l6tmsJhm6jbaQca/nmFRhjvNK3vP0BV01bTAiyKHQ
        HajeMvoJOvs20nams7dhSXblDwmTG2xfSB9nzr0QhA==
X-Google-Smtp-Source: AKy350Y+VYvsNjh0WcR57yewEEKViES5vHUz2CstIZgU1iqEfYqNKp9hEOLycwhS0LrtxrS0Xjd+IOOEaQtT21owqTc=
X-Received: by 2002:a17:906:2357:b0:931:cac0:60ff with SMTP id
 m23-20020a170906235700b00931cac060ffmr16919310eja.13.1680523566836; Mon, 03
 Apr 2023 05:06:06 -0700 (PDT)
MIME-Version: 1.0
References: <20230403093310.2271142-1-apatel@ventanamicro.com>
 <20230403093310.2271142-3-apatel@ventanamicro.com> <20230403-80af54e80a34fc70fad04e0c@wendy>
In-Reply-To: <20230403-80af54e80a34fc70fad04e0c@wendy>
From:   Anup Patel <anup@brainfault.org>
Date:   Mon, 3 Apr 2023 17:35:54 +0530
Message-ID: <CAAhSdy1L55ZOTKhv81baAMPkEQ==Oz0KgoULkq1mFx4GWN+Sow@mail.gmail.com>
Subject: Re: [PATCH v3 2/8] RISC-V: Detect AIA CSRs from ISA string
To:     Conor Dooley <conor.dooley@microchip.com>
Cc:     Anup Patel <apatel@ventanamicro.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Andrew Jones <ajones@ventanamicro.com>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Atish Patra <atishp@rivosinc.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 3, 2023 at 3:10=E2=80=AFPM Conor Dooley <conor.dooley@microchip=
.com> wrote:
>
> On Mon, Apr 03, 2023 at 03:03:04PM +0530, Anup Patel wrote:
>
> > diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeat=
ure.c
> > index 59d58ee0f68d..1b13a5823b90 100644
> > --- a/arch/riscv/kernel/cpufeature.c
> > +++ b/arch/riscv/kernel/cpufeature.c
> > @@ -221,8 +221,10 @@ void __init riscv_fill_hwcap(void)
> >                               }
> >                       } else {
> >                               /* sorted alphabetically */
>                                    ^^^^^^^^^^^^^^^^^^^^^
>
> > +                             SET_ISA_EXT_MAP("ssaia", RISCV_ISA_EXT_SS=
AIA);
> >                               SET_ISA_EXT_MAP("sscofpmf", RISCV_ISA_EXT=
_SSCOFPMF);
> >                               SET_ISA_EXT_MAP("sstc", RISCV_ISA_EXT_SST=
C);
> > +                             SET_ISA_EXT_MAP("smaia", RISCV_ISA_EXT_SM=
AIA);
>
> This entry has been added in an incorrect order chief :/

Okay, I will update in the next revision.

>
> >                               SET_ISA_EXT_MAP("svinval", RISCV_ISA_EXT_=
SVINVAL);
> >                               SET_ISA_EXT_MAP("svpbmt", RISCV_ISA_EXT_S=
VPBMT);
> >                               SET_ISA_EXT_MAP("zbb", RISCV_ISA_EXT_ZBB)=
;

Regards,
Anup
