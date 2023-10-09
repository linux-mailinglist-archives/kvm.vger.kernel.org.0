Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D87B77BE75E
	for <lists+kvm@lfdr.de>; Mon,  9 Oct 2023 19:08:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377145AbjJIRIj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Oct 2023 13:08:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376329AbjJIRIi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Oct 2023 13:08:38 -0400
Received: from hall.aurel32.net (hall.aurel32.net [IPv6:2001:bc8:30d7:100::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C351494
        for <kvm@vger.kernel.org>; Mon,  9 Oct 2023 10:08:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=aurel32.net
        ; s=202004.hall; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:Reply-To:
        Subject:Content-ID:Content-Description:X-Debbugs-Cc;
        bh=mrAocPRzlQT+HhzW90ANcMn2nr6/4rXTdfxji/3XDNc=; b=wM9t+Vt4m4Nh/XpHhlbNQt/ZWA
        G8MKQ0N2s19O4O5H5T7jEWIygJWi4w3ryM0ySDnVZ/gNzH289aY/kOIVN75u/gZNJp9VD3sGYLX1A
        rQCNqkalZFUpNQGughQqaBV27YRNnInHBCriXP1fssVhdoICZYJJF1Gz9g68f45rVEBTZcP7CyMoy
        JO5j/v32scGw2eoXCrGRJmeKY48TCDY9EH5ZyN/NWVR5ymXHyY6czZGzrVkaCpWx3pUekD4254Qds
        zx/6U+5g36u4/XL9zh75v4hWbvGQfM0Z4TKRv1fq2Gue1FNJbbjw8elvC9LWfTlwynWd5ktqIf1BD
        gBVml07w==;
Received: from [2a01:e34:ec5d:a741:1ee1:92ff:feb4:5ec0] (helo=ohm.rr44.fr)
        by hall.aurel32.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <aurelien@aurel32.net>)
        id 1qptk0-00EClp-Pa; Mon, 09 Oct 2023 19:08:24 +0200
Received: from aurel32 by ohm.rr44.fr with local (Exim 4.97-RC0)
        (envelope-from <aurelien@aurel32.net>)
        id 1qptjz-00000009abq-1RYE;
        Mon, 09 Oct 2023 19:08:23 +0200
Date:   Mon, 9 Oct 2023 19:08:23 +0200
From:   Aurelien Jarno <aurelien@aurel32.net>
To:     Andy Chiu <andy.chiu@sifive.com>
Cc:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Vincent Chen <vincent.chen@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Heiko Stuebner <heiko.stuebner@vrull.eu>,
        Conor Dooley <conor.dooley@microchip.com>,
        Alexandre Ghiti <alexghiti@rivosinc.com>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@rivosinc.com>,
        Andrew Jones <ajones@ventanamicro.com>,
        Rob Herring <robh@kernel.org>,
        Jisheng Zhang <jszhang@kernel.org>,
        Wenting Zhang <zephray@outlook.com>,
        Guo Ren <guoren@kernel.org>,
        Andrew Bresticker <abrestic@rivosinc.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH -next v21 14/27] riscv: signal: Add sigcontext
 save/restore for vector
Message-ID: <ZSQzhzw3LpbJ8rSx@aurel32.net>
Mail-Followup-To: Andy Chiu <andy.chiu@sifive.com>,
        linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Vincent Chen <vincent.chen@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Heiko Stuebner <heiko.stuebner@vrull.eu>,
        Conor Dooley <conor.dooley@microchip.com>,
        Alexandre Ghiti <alexghiti@rivosinc.com>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@rivosinc.com>,
        Andrew Jones <ajones@ventanamicro.com>,
        Rob Herring <robh@kernel.org>, Jisheng Zhang <jszhang@kernel.org>,
        Wenting Zhang <zephray@outlook.com>, Guo Ren <guoren@kernel.org>,
        Andrew Bresticker <abrestic@rivosinc.com>,
        Al Viro <viro@zeniv.linux.org.uk>
References: <20230605110724.21391-1-andy.chiu@sifive.com>
 <20230605110724.21391-15-andy.chiu@sifive.com>
 <ZSJ0K5JFrglyJY8o@aurel32.net>
 <CABgGipVQ3j+Njw1CDkD9cuDwTwR2-WqF7Y_yZt3NPipAedK_2Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CABgGipVQ3j+Njw1CDkD9cuDwTwR2-WqF7Y_yZt3NPipAedK_2Q@mail.gmail.com>
User-Agent: Mutt/2.2.9 (2022-11-12)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 2023-10-09 01:23, Andy Chiu wrote:
> On Sun, Oct 8, 2023 at 6:19=E2=80=AFPM Aurelien Jarno <aurelien@aurel32.n=
et> wrote:
> >
> > Hi,
> >
> > On 2023-06-05 11:07, Andy Chiu wrote:
> > > From: Greentime Hu <greentime.hu@sifive.com>
> > >
> > > This patch facilitates the existing fp-reserved words for placement of
> > > the first extension's context header on the user's sigframe. A context
> > > header consists of a distinct magic word and the size, including the
> > > header itself, of an extension on the stack. Then, the frame is follo=
wed
> > > by the context of that extension, and then a header + context body for
> > > another extension if exists. If there is no more extension to come, t=
hen
> > > the frame must be ended with a null context header. A special case is
> > > rv64gc, where the kernel support no extensions requiring to expose
> > > additional regfile to the user. In such case the kernel would place t=
he
> > > null context header right after the first reserved word of
> > > __riscv_q_ext_state when saving sigframe. And the kernel would check =
if
> > > all reserved words are zeros when a signal handler returns.
> > >
> > > __riscv_q_ext_state---->|     |<-__riscv_extra_ext_header
> > >                       ~       ~
> > >       .reserved[0]--->|0      |<-     .reserved
> > >               <-------|magic  |<-     .hdr
> > >               |       |size   |_______ end of sc_fpregs
> > >               |       |ext-bdy|
> > >               |       ~       ~
> > >       +)size  ------->|magic  |<- another context header
> > >                       |size   |
> > >                       |ext-bdy|
> > >                       ~       ~
> > >                       |magic:0|<- null context header
> > >                       |size:0 |
> > >
> > > The vector registers will be saved in datap pointer. The datap pointer
> > > will be allocated dynamically when the task needs in kernel space. On
> > > the other hand, datap pointer on the sigframe will be set right after
> > > the __riscv_v_ext_state data structure.
> >
> > It appears that this patch somehow breaks userland, at least the rust
> > compiler. This can be observed for instance by building the rust-lsd
> > package in Debian, but many other rust packages are also affected:
>=20
> Sorry for the time spent on pinpointing the issue. Yes, this is a bug
> and we had a fix [1]. This fix was accidently not getting into the
> -fixes branch, but it will. And it should be going into linux stable
> as well, though I am not certain about the timing. Otherwise, this bug
> may potentially break any processes which allocate a sigaltstack at an
> address higher than their stack.

Thanks for the pointer, I somehow missed that patch when looking for a
potential fix on the mailing list. I have just tried it, and I confirm
it fixes the issue. Let's hope it can get merged soon.

Regards
Aurelien

--=20
Aurelien Jarno                          GPG: 4096R/1DDD8C9B
aurelien@aurel32.net                     http://aurel32.net
