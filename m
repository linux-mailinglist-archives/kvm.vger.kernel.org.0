Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF11E70B93B
	for <lists+kvm@lfdr.de>; Mon, 22 May 2023 11:40:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232516AbjEVJkZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 May 2023 05:40:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232521AbjEVJkT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 May 2023 05:40:19 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7C7C115
        for <kvm@vger.kernel.org>; Mon, 22 May 2023 02:40:17 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id 38308e7fff4ca-2af31dc49f9so19067151fa.0
        for <kvm@vger.kernel.org>; Mon, 22 May 2023 02:40:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1684748416; x=1687340416;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bUTd018zzttGKfcxqId+9qTE/jC/9Fv0gPOqDPW0Zg8=;
        b=njW3pcP6cXCxDJCokQLvCm8e1Zh0bVvD5SPleVjyIsfFEPUKbP3s3KecV3NDINQPBx
         4lsQifOMwhEUGuAzv8jU7fy6VAKbGv+p1FdD/jPPgop87GS/M23E18pOf44pR5PZSLtz
         zIYCbEgjHk4ewG32o5qdWpOuBEE0585WluRe6NN1HLapN6oo3AuIyf6iyFUEzm3reoIm
         x+rwrn0nLPHG9KrVI5vgab4ikHfCAcfXH4egboji1uKYg0S3qNmZ8WFoLk1oohiOxWqN
         PvIH7Z4JQcV/hjd1evfOO2QU04EJAaesyvn7R4pwwrKzvn4aGdKAbPROsVUpGmC8Hkco
         JnFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684748416; x=1687340416;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bUTd018zzttGKfcxqId+9qTE/jC/9Fv0gPOqDPW0Zg8=;
        b=J60700CPRm/t34rYDWgK94lPmaqWRRwXXVM+3aiixZ/4fEByDO668SurPDwsOGkCpg
         W0Z2PLkalpkHTiDIXstSc1Tkd+xTeF2lacLBJk/D8hQyGcNekX0geKlcvrpxkrUFFs3Y
         +50giHHa2El0q2de0mWER4Is6pzHF5FbJk35iQVeFysiDHruJG3Ub4Lkn8qSU5pfYul7
         eLKxBoGWSMQvoeqTQk4JyQHIXJ5HRfKDwlnHg0V4XpaUdTEe1M3IuKnneaZWT4EQtpAY
         9IIlKXIEu3DXr7T+1junn5SADZfzziIQbTcsYHJYdglTU2h1FcxtUEJinPDFEVGIvDIr
         u8kg==
X-Gm-Message-State: AC+VfDy5sQzBzz3OFZ5OkFC8lFLk0q3fQV6UTrFn0OztQTjSlnPwS20H
        6g8IHIFQKAvGiDRkjCIyqXRJoQ66CSMLyUk5+mJfiAndBB9zOm1yMRYA4A==
X-Google-Smtp-Source: ACHHUZ7TfPVWU2d1ZRV7ILxTF1F3ImBz+clNcYREWZAyN+RhKlBYRUaENzX1x03Sz+JXcey/OqsRzPlQIVHlneJV/rA=
X-Received: by 2002:ac2:42ce:0:b0:4f3:8143:765 with SMTP id
 n14-20020ac242ce000000b004f381430765mr3018660lfl.27.1684748416036; Mon, 22
 May 2023 02:40:16 -0700 (PDT)
MIME-Version: 1.0
References: <20230518161949.11203-1-andy.chiu@sifive.com> <20230518161949.11203-12-andy.chiu@sifive.com>
 <20230518-external-sixteen-f2d2ae444547@spud>
In-Reply-To: <20230518-external-sixteen-f2d2ae444547@spud>
From:   Andy Chiu <andy.chiu@sifive.com>
Date:   Mon, 22 May 2023 17:40:04 +0800
Message-ID: <CABgGipUcuQTBbJkA5276NH57FWPxDT14my8NpwDL9VHycL6+5w@mail.gmail.com>
Subject: Re: [PATCH -next v20 11/26] riscv: Allocate user's vector context in
 the first-use trap
To:     Conor Dooley <conor@kernel.org>
Cc:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Andrew Jones <ajones@ventanamicro.com>,
        Heiko Stuebner <heiko.stuebner@vrull.eu>,
        Conor Dooley <conor.dooley@microchip.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Liao Chang <liaochang1@huawei.com>,
        Jisheng Zhang <jszhang@kernel.org>,
        Vincent Chen <vincent.chen@sifive.com>,
        Guo Ren <guoren@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@rivosinc.com>,
        Mattias Nissler <mnissler@rivosinc.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Conor,

On Fri, May 19, 2023 at 1:47=E2=80=AFAM Conor Dooley <conor@kernel.org> wro=
te:
>
> On Thu, May 18, 2023 at 04:19:34PM +0000, Andy Chiu wrote:
> > Vector unit is disabled by default for all user processes. Thus, a
> > process will take a trap (illegal instruction) into kernel at the first
> > time when it uses Vector. Only after then, the kernel allocates V
> > context and starts take care of the context for that user process.
> >
> > Suggested-by: Richard Henderson <richard.henderson@linaro.org>
> > Link: https://lore.kernel.org/r/3923eeee-e4dc-0911-40bf-84c34aee962d@li=
naro.org
> > Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
> > ---
> > Hey Heiko and Conor, I am dropping you guys' A-b, T-b, and R-b because =
I
> > added a check in riscv_v_first_use_handler().
>
> > +bool riscv_v_first_use_handler(struct pt_regs *regs)
> > +{
> > +     u32 __user *epc =3D (u32 __user *)regs->epc;
> > +     u32 insn =3D (u32)regs->badaddr;
> > +
> > +     /* Do not handle if V is not supported, or disabled */
> > +     if (!has_vector() || !(elf_hwcap & COMPAT_HWCAP_ISA_V))
> > +             return false;
>
> Remind me please, in what situation is this actually even possible?
> The COMPAT_HWCAP_ISA_V flag only gets set if CONFIG_RISCV_ISA_V is
> enabled & v is in the DT.
> has_vector() is backed by different things whether alternatives are
> enabled or not. With alternatives, it depends on the bit being set in
> the riscv_isa bitmap & the Kconfig option.
> Without alternatives it is backed by __riscv_isa_extension_available()
> which only depends in the riscv_isa bitmap.
> Since the bit in the bitmap does not get cleared if CONFIG_RISCV_ISA_V
> is not set, unlike the elf_hwcap bit which does, it seems like this
> might be the condition you are trying to prevent?
>

In fact the case you mentioned is prevented by Kconfig itself. To be
more specific, riscv_v_first_use_handler() always returns false if
CONFIG_RISCV_ISA_V is not set. In such config, the function is defined
as an inline that returns false in include/asm/vector.h, and
kernl/vector.c is not compiled.

The case that I intended to protect is another scenario. e.g. If a
multicore system has different VLENs across cores, with
CONFIG_RISCV_ISA_V set. Since this series assumes an SMP system, it
turns off V in ELF_HWCAP if it detects uneven VLENs during smp boot.
In this case we must not handle the first-use trap if the user still
executes V instruction anyway.

> If so,
> Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
>
> Otherwise, please let me know where I have gone wrong!
>
> Thanks,
> Conor.

Thanks,
Andy
