Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 995F26BA5E1
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 05:07:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230266AbjCOEHC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 00:07:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbjCOEHA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 00:07:00 -0400
Received: from mail-yw1-x112b.google.com (mail-yw1-x112b.google.com [IPv6:2607:f8b0:4864:20::112b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9434741B48
        for <kvm@vger.kernel.org>; Tue, 14 Mar 2023 21:06:57 -0700 (PDT)
Received: by mail-yw1-x112b.google.com with SMTP id 00721157ae682-541a05e4124so157272527b3.1
        for <kvm@vger.kernel.org>; Tue, 14 Mar 2023 21:06:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1678853217;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Enn/P/P0Dso5wyT4aOyOrnfmbLXABI8oREO5fJsikhQ=;
        b=hvN2KLy5T3SiSflrjJRxvuPv6nrBSuZh0KCh1TLM1iOfBtnTVDVpijqPBclk9AqrZC
         RWU1x3EwowxRny2TX18oNDlOLVjIEptbfT/ZIXkOHxLJW82+qgIweO8QSiUNPI0ZKtmy
         +MZMBAnW20W/0q3qD0dxafJWZbbnrH8eR2sxWpjBnby3jrLPzC+6lEGBMPF3MdHnFCkq
         3eoBNeER9FIAEBbZZlDb6ZmC/d4GBa5wG4aGazYyjfdNbkoe+ZHo8YCGNe5uQWvWPHOH
         BrnEDNdQRfjygRVovr93C9KmlF87Jr9lwYVWp5DPxUEXAvhVEMq9u75mdKSuT2/u5EIv
         cSHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678853217;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Enn/P/P0Dso5wyT4aOyOrnfmbLXABI8oREO5fJsikhQ=;
        b=ss2h8tlog8fPJG4A3UrNZI9z+TmIh8zXIC0yD8H4iFgydRaacFisk94bbKsm4Fjphw
         z0Pq5FvX523v2KsF6e6ENwyA+AVEtsbwT7qj497nggG1H4yKwC2A2JL13FS6dfu9Bnc8
         uThlztpU5gRfjKUnNksPpgIKwLNsG8QEjE5ynsDA1rStHAaqBL0Y37i/yAq3mNJDFjBo
         noscy864qz3l6r8o6gBERI7ZJteOWH9sXlHklwCVJdlI2r5Znvc8R5zQwVhQ9A9cN1Ml
         pXGmzYh4dlJ95+t7X+MGk2iSQogvHVK0USG/IFD/gtZXj0KucC5rZqySEiH6cM17xmlm
         2cfw==
X-Gm-Message-State: AO0yUKUUGX2MVIN0sB/dI3/7ktzPtJF3uR4zaRBFDr+Vy5k5Qg7grrR+
        l/2TYeYiTsj+wND4WcGaQuKOW64ISVxiNblPbHKfbA==
X-Google-Smtp-Source: AK7set/QwXaVUBibhg3kuLxzvNSAgDNGKXWiCcNO7ggyml88RawJoFRbknRBYj2sneiztp2sYM11S74xbEM9Te/QxWM=
X-Received: by 2002:a81:ad63:0:b0:52a:9f66:80c6 with SMTP id
 l35-20020a81ad63000000b0052a9f6680c6mr25994436ywk.9.1678853216765; Tue, 14
 Mar 2023 21:06:56 -0700 (PDT)
MIME-Version: 1.0
References: <20230224170118.16766-1-andy.chiu@sifive.com> <20230224170118.16766-9-andy.chiu@sifive.com>
 <87r0u74dac.fsf@all.your.base.are.belong.to.us>
In-Reply-To: <87r0u74dac.fsf@all.your.base.are.belong.to.us>
From:   Andy Chiu <andy.chiu@sifive.com>
Date:   Wed, 15 Mar 2023 12:05:00 +0800
Message-ID: <CABgGipXQcLvcSqHWoaZZEMW+7cwxEyOYPAEvr5cCtJMPFGva0w@mail.gmail.com>
Subject: Re: [PATCH -next v14 08/19] riscv: Introduce struct/helpers to
 save/restore per-task Vector state
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>
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

On Thu, Mar 2, 2023 at 7:13=E2=80=AFPM Bj=C3=B6rn T=C3=B6pel <bjorn@kernel.=
org> wrote:
>
> Andy Chiu <andy.chiu@sifive.com> writes:
>
> > diff --git a/arch/riscv/include/asm/vector.h b/arch/riscv/include/asm/v=
ector.h
> > index 692d3ee2d2d3..9c025f2efdc3 100644
> > --- a/arch/riscv/include/asm/vector.h
> > +++ b/arch/riscv/include/asm/vector.h
> > @@ -31,11 +54,72 @@ static __always_inline void riscv_v_disable(void)
> >       csr_clear(CSR_SSTATUS, SR_VS);
> >  }
> >
> > +static __always_inline void __vstate_csr_save(struct __riscv_v_ext_sta=
te *dest)
> > +{
> > +     asm volatile (
> > +             "csrr   %0, " CSR_STR(CSR_VSTART) "\n\t"
> > +             "csrr   %1, " CSR_STR(CSR_VTYPE) "\n\t"
> > +             "csrr   %2, " CSR_STR(CSR_VL) "\n\t"
> > +             "csrr   %3, " CSR_STR(CSR_VCSR) "\n\t"
> > +             : "=3Dr" (dest->vstart), "=3Dr" (dest->vtype), "=3Dr" (de=
st->vl),
> > +               "=3Dr" (dest->vcsr) : :);
> > +}
> > +
> > +static __always_inline void __vstate_csr_restore(struct __riscv_v_ext_=
state *src)
> > +{
> > +     asm volatile (
> > +             "vsetvl  x0, %2, %1\n\t"
> > +             "csrw   " CSR_STR(CSR_VSTART) ", %0\n\t"
> > +             "csrw   " CSR_STR(CSR_VCSR) ", %3\n\t"
> > +             : : "r" (src->vstart), "r" (src->vtype), "r" (src->vl),
> > +                 "r" (src->vcsr) :);
> > +}
> > +
> > +static inline void __riscv_v_vstate_save(struct __riscv_v_ext_state *s=
ave_to, void *datap)
> > +{
> > +     riscv_v_enable();
> > +     __vstate_csr_save(save_to);
> > +     asm volatile (
> > +             "vsetvli        t4, x0, e8, m8, ta, ma\n\t"
> > +             "vse8.v         v0, (%0)\n\t"
> > +             "add            %0, %0, t4\n\t"
> > +             "vse8.v         v8, (%0)\n\t"
> > +             "add            %0, %0, t4\n\t"
> > +             "vse8.v         v16, (%0)\n\t"
> > +             "add            %0, %0, t4\n\t"
> > +             "vse8.v         v24, (%0)\n\t"
> > +             : : "r" (datap) : "t4", "memory");
> > +     riscv_v_disable();
> > +}
> > +
> > +static inline void __riscv_v_vstate_restore(struct __riscv_v_ext_state=
 *restore_from,
> > +                                 void *datap)
> > +{
> > +     riscv_v_enable();
> > +     asm volatile (
> > +             "vsetvli        t4, x0, e8, m8, ta, ma\n\t"
> > +             "vle8.v         v0, (%0)\n\t"
> > +             "add            %0, %0, t4\n\t"
> > +             "vle8.v         v8, (%0)\n\t"
> > +             "add            %0, %0, t4\n\t"
> > +             "vle8.v         v16, (%0)\n\t"
> > +             "add            %0, %0, t4\n\t"
> > +             "vle8.v         v24, (%0)\n\t"
> > +             : : "r" (datap) : "t4");
>
> Nit/question: For both enable/disable; Any reason to clobber t4, instead
> of using a scratch reg?
>

Yes, it is better to use a scratch register here in order to gain
benefit from inline asm.

> Bj=C3=B6rn

Andy
