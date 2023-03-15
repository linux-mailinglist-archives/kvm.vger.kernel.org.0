Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64F4F6BA5D3
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 05:00:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbjCOEAx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 00:00:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbjCOEAv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 00:00:51 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 174543402C
        for <kvm@vger.kernel.org>; Tue, 14 Mar 2023 21:00:48 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id p203so10681535ybb.13
        for <kvm@vger.kernel.org>; Tue, 14 Mar 2023 21:00:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1678852847;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9WrhLd5JpQXyC1TC5SJTwH36/6Kisk6CvI+ttYQeoGw=;
        b=aNJEfZ9wDlkkKLtCBaMQVsBAtRZxjQ6xiRPe7YfCYJFAY9BMHJtSDFcx0Wl5mt+thO
         Mna9rA+BruhqE4HZdv/PxiS0AepZkEkzcSaAoOSaOxGYBExMnNg8cC08VzrMnvn7mCa5
         HJO/7FiE+7t57r/EoEgY57ahklGk61AWCYcAOG/pnHxUlwTsoAZHiiIIFwRt6A33IVIc
         wCFcEIjTjpx32xfKk4fXxr2Z5HwR2/Cu3ExURQtHGWEIFka4qELu1yGOSHxgrlmaCjm5
         XmTrWdQb/BtX+P8flotDE1Wn2vpMzDQTcqR4Fbl/WRzC+m5MnMR5fgifAdUwdJJZbToJ
         E44g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678852847;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9WrhLd5JpQXyC1TC5SJTwH36/6Kisk6CvI+ttYQeoGw=;
        b=0XyrVeqcXWx/xWsV400o+W+AS5rD4xgQDVwXFWeKceg+co7ItMv17Siipzpknp7GLG
         grJsOxjcbjfZbCK15o9QL9g0dBQ55ZdWcOdGpwKVWkEOhHn5tLJHHw9sQ/M8xLXXSL/m
         9YhSklrTgR1GZTNTPdsqYV/7fct8Q93+ZChpFU2U5aU+5bgKHfIJFFAY4uykFzqKnSgl
         XM/+5yyw72a+Z2F5BNCtq4NTzV2jNaB7mlU32JOIoe7d0ley3/9pWTuhSzTWkY6QnTXP
         DXVXf5k/8JX0mEVA62jgFpVm4T03m5Y0Raf2PStk5e2tcKRyzS+b1j4Wx0eUPfqk/tBX
         /TqQ==
X-Gm-Message-State: AO0yUKUZuXbYBRP79EY+WQugAy2UwJ+QxtIRb182StUWxlekAijLG7q5
        Cc9NLkQBE/qohBOaEcgtRjcydsV7+CbeeWKN+jm6tw==
X-Google-Smtp-Source: AK7set8FN7Fl+EdfStWhaZjOKKUlUjOUuyD6IGOXuU2yOmG7x+jOvErH2Y6sTBDP51O3X1FdharwIQFn38dF6rP1Pw4=
X-Received: by 2002:a5b:2cc:0:b0:a02:a3a6:78fa with SMTP id
 h12-20020a5b02cc000000b00a02a3a678famr19780355ybp.12.1678852847167; Tue, 14
 Mar 2023 21:00:47 -0700 (PDT)
MIME-Version: 1.0
References: <20230224170118.16766-1-andy.chiu@sifive.com> <20230224170118.16766-9-andy.chiu@sifive.com>
 <Y/6HmORLbsFWsEbu@spud>
In-Reply-To: <Y/6HmORLbsFWsEbu@spud>
From:   Andy Chiu <andy.chiu@sifive.com>
Date:   Wed, 15 Mar 2023 12:00:00 +0800
Message-ID: <CABgGipWBGgs-enRr=_HToW4wxTVGeUnJ4imLagdwThFiQ4xG2w@mail.gmail.com>
Subject: Re: [PATCH -next v14 08/19] riscv: Introduce struct/helpers to
 save/restore per-task Vector state
To:     Conor Dooley <conor@kernel.org>
Cc:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Vincent Chen <vincent.chen@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>, Guo Ren <guoren@kernel.org>,
        Richard Henderson <richard.henderson@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 1, 2023 at 7:00=E2=80=AFAM Conor Dooley <conor@kernel.org> wrot=
e:
>
> On Fri, Feb 24, 2023 at 05:01:07PM +0000, Andy Chiu wrote:
> > From: Greentime Hu <greentime.hu@sifive.com>
> >
> > Add vector state context struct to be added later in thread_struct. And
> > prepare low-level helper functions to save/restore vector contexts.
> >
> > This include Vector Regfile and CSRs holding dynamic configuration stat=
e
> > (vstart, vl, vtype, vcsr). The Vec Register width could be implementati=
on
> > defined, but same for all processes, so that is saved separately.
> >
> > This is not yet wired into final thread_struct - will be done when
> > __switch_to actually starts doing this in later patches.
> >
> > Given the variable (and potentially large) size of regfile, they are
> > saved in dynamically allocated memory, pointed to by datap pointer in
> > __riscv_v_ext_state.
> >
> > Co-developed-by: Vincent Chen <vincent.chen@sifive.com>
> > Signed-off-by: Vincent Chen <vincent.chen@sifive.com>
> > Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
> > Signed-off-by: Vineet Gupta <vineetg@rivosinc.com>
> > [vineetg: merged bits from 2 different patches]
> > Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
> > [andy.chiu: use inline asm to save/restore context, remove asm vaiant]
> > ---
> >  arch/riscv/include/asm/vector.h      | 84 ++++++++++++++++++++++++++++
> >  arch/riscv/include/uapi/asm/ptrace.h | 17 ++++++
> >  2 files changed, 101 insertions(+)
> >
> > diff --git a/arch/riscv/include/asm/vector.h b/arch/riscv/include/asm/v=
ector.h
> > index 692d3ee2d2d3..9c025f2efdc3 100644
> > --- a/arch/riscv/include/asm/vector.h
> > +++ b/arch/riscv/include/asm/vector.h
> > @@ -12,6 +12,9 @@
> >
> >  #include <asm/hwcap.h>
> >  #include <asm/csr.h>
> > +#include <asm/asm.h>
> > +
> > +#define CSR_STR(x) __ASM_STR(x)
>
> TBH, I'm not really sure what this definition adds.
>

Agree, I'm going to drop this #define and use __ASM_STR directly.
However, we should not replace the inline asm to csr_read because
csr_read clobbers memory and we don't.

> >  extern unsigned long riscv_v_vsize;
> >  void riscv_v_setup_vsize(void);
> > @@ -21,6 +24,26 @@ static __always_inline bool has_vector(void)
> >       return riscv_has_extension_likely(RISCV_ISA_EXT_v);
> >  }
> >
> > +static inline void __riscv_v_vstate_clean(struct pt_regs *regs)
> > +{
> > +     regs->status =3D (regs->status & ~(SR_VS)) | SR_VS_CLEAN;
> > +}
> > +
> > +static inline void riscv_v_vstate_off(struct pt_regs *regs)
> > +{
> > +     regs->status =3D (regs->status & ~SR_VS) | SR_VS_OFF;
>
> Inconsistent use of brackets here compared to the other items.
> They're not actually needed anywhere here, are they?
>

Yes, there is no need for brackets at SR_VS because it expands to one
constant value.




> > +}
> > +
> > +static inline void riscv_v_vstate_on(struct pt_regs *regs)
> > +{
> > +     regs->status =3D (regs->status & ~(SR_VS)) | SR_VS_INITIAL;
> > +}
>
> Other than that, this seems fine? I only really had a quick check of the
> asm though, so with the brackets thing fixed up:
> Acked-by: Conor Dooley <conor.dooley@microchip.com>
