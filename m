Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02C0167A414
	for <lists+kvm@lfdr.de>; Tue, 24 Jan 2023 21:41:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233513AbjAXUlr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Jan 2023 15:41:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbjAXUlq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Jan 2023 15:41:46 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 548334C6C0
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 12:41:45 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id 36so12077658pgp.10
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 12:41:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=atishpatra.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=kArh2JTETPG4MZN8AtzWKM/hnB740sJiaw+6d2XmltY=;
        b=oyLp/nUpTQCOQMyT5yEtRG7o0JQPEbxztyhTTwBBWfbRApCOOFV/WkDLdIbvbSvWLz
         b1hrf5/g8Fdn++whjE9zqRHbe7cRC42175lcv4Eyj7FJEwCFaWE1ruLkzMZpzPw3MEn6
         dm8HGLCYb86tX0qQL+B4f0kcnhqKsu6O9j+KA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kArh2JTETPG4MZN8AtzWKM/hnB740sJiaw+6d2XmltY=;
        b=pXR6h7Bc4SC9p4iq1pW6PMmNYVRYV/ri6UOzeiCKzZ6q20hPCZ6Z/Onlp/BRcv8oxJ
         taNv3vGcnys/XXMYt9VUFNdDBIoM6HCr4YhQe+kRnVuRVj+s1NUPK3jSNAcwS1nro/nt
         iQOf1w4lH88vFgO6QbHE0jZJpZdG2Eo4zB3CwrNtSuSFK4denU5RfAd0wVKI9fSfwdW7
         bZ+i9H5rj/uQgCFh3WDyfNypXl+CXytmsvv3aNvy7BRM2GXyQhabe/4ajDPAjN2u9ZLh
         sWb15KZJEVzVRb/U2dHfRMH2PZ3VUMyeOaMMLssb2+RfX2Ffxmjnog9fvyS4UP29Fi+3
         exkw==
X-Gm-Message-State: AFqh2ko+2vkiZ0Cz7c6Gld0V9A1LksPj3xK2BIIzZ8o/yQ2JOINTpVWU
        V8C736r1PH15wmGZZnryX6SaNDPm8ojHGCl71wGl
X-Google-Smtp-Source: AMrXdXv//TSHap1rIs4T8t6FimYpSoWP8wIEH1RnksqTCs7706WWqSUBG8nxukPl0ALp6mPXwdjofzthPg+fGXMiqgg=
X-Received: by 2002:a05:6a00:1d23:b0:58d:b662:af11 with SMTP id
 a35-20020a056a001d2300b0058db662af11mr2817916pfx.37.1674592904836; Tue, 24
 Jan 2023 12:41:44 -0800 (PST)
MIME-Version: 1.0
References: <20221215170046.2010255-1-atishp@rivosinc.com> <20221215170046.2010255-2-atishp@rivosinc.com>
 <20230112100608.d7tnvhbotjfctlgk@orel> <CAHBxVyESkQ9Krmn-44f-A8hYzMrZBtBfq15fdx-sHDQfkBMtKQ@mail.gmail.com>
 <20230113072255.34cnyautbwiy25p5@orel>
In-Reply-To: <20230113072255.34cnyautbwiy25p5@orel>
From:   Atish Patra <atishp@atishpatra.org>
Date:   Tue, 24 Jan 2023 12:41:33 -0800
Message-ID: <CAOnJCU+UBG-AouAc1M4J-i9Y_nPE9RfrFZfNyLSxhKbNF55AMQ@mail.gmail.com>
Subject: Re: [PATCH v2 01/11] RISC-V: Define helper functions expose hpm
 counter width and count
To:     Andrew Jones <ajones@ventanamicro.com>
Cc:     Atish Kumar Patra <atishp@rivosinc.com>,
        linux-kernel@vger.kernel.org, Anup Patel <anup@brainfault.org>,
        Guo Ren <guoren@kernel.org>, kvm-riscv@lists.infradead.org,
        kvm@vger.kernel.org, linux-riscv@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Sergey Matyukevich <sergey.matyukevich@syntacore.com>,
        Eric Lin <eric.lin@sifive.com>, Will Deacon <will@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 12, 2023 at 11:22 PM Andrew Jones <ajones@ventanamicro.com> wrote:
>
> On Thu, Jan 12, 2023 at 10:18:05AM -0800, Atish Kumar Patra wrote:
> > On Thu, Jan 12, 2023 at 2:06 AM Andrew Jones <ajones@ventanamicro.com> wrote:
> > >
> > > On Thu, Dec 15, 2022 at 09:00:36AM -0800, Atish Patra wrote:
> ...
> > > > +EXPORT_SYMBOL(riscv_pmu_get_hpm_info);
> > >
> > > EXPORT_SYMBOL_GPL ?
> > >
> >
> > Is that mandatory ? I have seen usage of both in arch/riscv and other
> > places though.
> > I am also not sure if any other non-GPL module should/need access to this.
>
> TBH, I'm not sure what the best policy is, but I presumed we should use
> _GPL when we aren't aware of anything non-GPL and then when a day comes
> that something non-GPL would like this to be exported, the patch that
> flips it will provide the justification in its commit message.
>

Sgtm. Changed it to EXPORT_SYMBOL_GPL for now.

> Thanks,
> drew



-- 
Regards,
Atish
