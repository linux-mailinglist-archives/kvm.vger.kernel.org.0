Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADDD45221F0
	for <lists+kvm@lfdr.de>; Tue, 10 May 2022 19:07:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245329AbiEJRLj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 May 2022 13:11:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238571AbiEJRLh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 May 2022 13:11:37 -0400
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5598453E38;
        Tue, 10 May 2022 10:07:37 -0700 (PDT)
Received: by mail-qt1-x82b.google.com with SMTP id o11so13984924qtp.13;
        Tue, 10 May 2022 10:07:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mDbeLsxcSaCyLGr0Qfd1Hb+swgASSp1RmxbaNkEpdfM=;
        b=YQ5zcOUiHoMQ0qfa+plbCN4mHadzV8ncW33+T4OSTql/s0+cuKd0Gnj9VmnTLUq8qD
         MsfowQWfErW/6uivr1e0Jvj7sPzBmpguC80YO8MlaUjmV50sMlmV6bl8IlUAdpZxT7xw
         Fsb2kQR/6SfZzVvO4SziVNVoqEqMxt6q0L2ZOIBZ5r410k1iuySme8pha5CuatJUFPhP
         AxuwcMaTcxtfLbKZ0y1lOFdK5Jyr9qw73TAJk8yyS92iWWX+GQV+lHFU8k7pIUsG4d64
         35IUmyKC2ltycK9aqxOa+y5PLbMgMVIoXCsHs/l9r8NY57I0YFEfNN8T+QUIo6IQN9ZY
         o9Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mDbeLsxcSaCyLGr0Qfd1Hb+swgASSp1RmxbaNkEpdfM=;
        b=lmF6b8qHmnUQdmW16sGnFKwxsH4FD3mODSyYKM4I3/8gVsgk37F/qKZDy322R6DeMs
         e6dyCVaHnNq1Mv0eZB4gw9iNQmBh4mLANbga7HtVvZPXFgIFWvzk4cH7nvJyEOinn3He
         3kc8lF4AxEYc1UdGff03yrebFCdZZFrTBB0qDBCm+snewPgYcpEBpvVIZ9TVT0EcwUpy
         yPogwZZmbc29dT1+lBANIh7IVZrhYLHaTfgAVzii9Xp3ai1jdlm9EODMUiIH1DsO1JMi
         Hc09azydWH6elM+ZVtVI51XDD3qERqbA0XvKBCvQKAA8iqdlK5WChypoK6/6wq30l4jl
         hxeQ==
X-Gm-Message-State: AOAM533Ma8xZFf9ECt2fvfbOL76h4ikFGYg87A9uYxTjru+D0uKgRdFo
        KR00K9Bh7KPJtWi6eDJXxBE9CYpLc46UWkX4LQE=
X-Google-Smtp-Source: ABdhPJx563eQ7xakd0WA+hbzvol8B90LoZbCAPbTY4/ZgoQAqUjSoyHB9FpnxIx1FFSJ3sl08Rdxn6BR5HqBy5Y7hyw=
X-Received: by 2002:a05:622a:1193:b0:2f3:d34f:118b with SMTP id
 m19-20020a05622a119300b002f3d34f118bmr13814831qtk.305.1652202456442; Tue, 10
 May 2022 10:07:36 -0700 (PDT)
MIME-Version: 1.0
References: <20220510154217.5216-1-ubizjak@gmail.com> <20220510165506.GP76023@worktop.programming.kicks-ass.net>
In-Reply-To: <20220510165506.GP76023@worktop.programming.kicks-ass.net>
From:   Uros Bizjak <ubizjak@gmail.com>
Date:   Tue, 10 May 2022 19:07:25 +0200
Message-ID: <CAFULd4aNME5s2zGOO0A11kdjfHekH=ceSH7jUfAhmZaJWHv9cQ@mail.gmail.com>
Subject: Re: [PATCH] locking/atomic/x86: Introduce try_cmpxchg64
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        kvm@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Will Deacon <will@kernel.org>,
        Boqun Feng <boqun.feng@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Marco Elver <elver@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 10, 2022 at 6:55 PM Peter Zijlstra <peterz@infradead.org> wrote:
>
> On Tue, May 10, 2022 at 05:42:17PM +0200, Uros Bizjak wrote:
> > This patch adds try_cmpxchg64 to improve code around cmpxchg8b.  While
> > the resulting code improvements on x86_64 are minor (a compare and a move saved),
> > the improvements on x86_32 are quite noticeable. The code improves from:
>
> What user of cmpxchg64 is this?

This is cmpxchg64 in pi_try_set_control from
arch/x86/kvm/vmx/posted_intr.c, as shown in a RFC patch [1].

There are some more opportunities for try_cmpxchg64 in KVM, namely
fast_pf_fix_direct_spte in arch/x86/kvm/mmu/mmu.c and
tdp_mmu_set_spte_atomic in arch/x86/kvm/mmu/tdp_mmu.c

[1] https://www.spinics.net/lists/kvm/msg266042.html

Uros.
