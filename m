Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BB0952663D
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 17:36:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382170AbiEMPgh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 May 2022 11:36:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382104AbiEMPgd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 May 2022 11:36:33 -0400
Received: from mail-qv1-xf2b.google.com (mail-qv1-xf2b.google.com [IPv6:2607:f8b0:4864:20::f2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B4A511171;
        Fri, 13 May 2022 08:36:32 -0700 (PDT)
Received: by mail-qv1-xf2b.google.com with SMTP id kl21so6913811qvb.9;
        Fri, 13 May 2022 08:36:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8h0LmcWAQXb8u9qfucjMgM7lVOGBOAPZEtMIypr4huE=;
        b=V21K7h6gxr/frfJzGoJpY9QlYPLnqhsegSYLRssEC7uQa/RjRMWeTQ+4WUjJcHX232
         h/56lswNcxpH6Vj57Os3FdYFI0z7IvVqw+R+x33nbdUR+V/N5zCn4yIOLirOmom9qNgq
         mMTu36wIUNzYR83MbFr+OBWJmQxUDgemetQKbCOZBp6WKV9WDJDlg5VG7/dDk1vrvJBM
         uc1OJlwSVtRTMAvlGgf4XDcL25fcAsXHieUREzKgfarztWq935EzYNBFpDLztThMgMAe
         3U9evL22QIVjxLN2ucQJkCEjR8+1JzzpcSHu6Wpj0+c65oj7Znhdz1B79tMvIiOiu0Up
         Ei8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8h0LmcWAQXb8u9qfucjMgM7lVOGBOAPZEtMIypr4huE=;
        b=Q1aBtbzC31HiRtpbKFSlepZvEKb5WeQSNQv1fd7Qr07qIbohZGmR2IXjAv/ND/iGYm
         S0FR6C+LMVxvEKd2UEGvAkbRe6GeqJD4Ro/+vUklgCmAJ9sdbf++R0ODG/h/7YmAw7ID
         eXea5RGfHXTWDs4Ibsx/6hubnM+fxW9Dn09fJ5M65XjBOXZBJ3JnIdElEEx7rt6y4t1H
         pRoW1VevKDglCpd4Co/IlhFCso09lVwGvauvjB1cTR+duazWJ5Zhi/GQJqzqmeAMHb4D
         konFnwyc2PEw/HxLsX4ZKZ6xWq7CnJMkoUjFvpIc8CnaOkwse8CxAT2Chd/RfEJgK3nb
         +HsA==
X-Gm-Message-State: AOAM532htkgrfSK2Ggvzk8p7Sd2+L5gDdIZ8+0342EE0mjAnJttjWgJG
        7CCpqHSF/r0nW3OjvSXfSTk6tUwTZFjGBawMpto=
X-Google-Smtp-Source: ABdhPJwqjL1gPdVknYoT/U+0XIneQoJHsxyMbPk309eeSytAsXbtzwplMHbPzQRvE7nw/MpGgYJi4UquFNUEKZc73VA=
X-Received: by 2002:a05:6214:20e6:b0:45d:403f:7a90 with SMTP id
 6-20020a05621420e600b0045d403f7a90mr4745600qvk.1.1652456191435; Fri, 13 May
 2022 08:36:31 -0700 (PDT)
MIME-Version: 1.0
References: <20220510154217.5216-1-ubizjak@gmail.com> <20220513091034.GH76023@worktop.programming.kicks-ass.net>
 <CAFULd4bAAKc=wo6vFkN6xQqBjaSJhF3L+WmuymSsC6-ec6TuvA@mail.gmail.com>
In-Reply-To: <CAFULd4bAAKc=wo6vFkN6xQqBjaSJhF3L+WmuymSsC6-ec6TuvA@mail.gmail.com>
From:   Uros Bizjak <ubizjak@gmail.com>
Date:   Fri, 13 May 2022 17:36:19 +0200
Message-ID: <CAFULd4Zck5YRfhoXsg_aPKpFbnkkr_xZ6ejDpmp=ysZemwoQAg@mail.gmail.com>
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
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 13, 2022 at 12:20 PM Uros Bizjak <ubizjak@gmail.com> wrote:

> > > +#define arch_try_cmpxchg64(ptr, po, n)                               \
> > > +({                                                           \
> > > +     bool success;                                           \
> > > +     __typeof__(*(ptr)) __prev;                              \
> > > +     __typeof__(ptr) _old = (__typeof__(ptr))(po);           \
> > > +     __typeof__(*(ptr)) __old = *_old;                       \
> > > +     __typeof__(*(ptr)) __new = (n);                         \
> > > +     alternative_io(LOCK_PREFIX_HERE                         \
> > > +                     "call cmpxchg8b_emu",                   \
> > > +                     "lock; cmpxchg8b (%%esi)" ,             \
> > > +                    X86_FEATURE_CX8,                         \
> > > +                    "=A" (__prev),                           \
> > > +                    "S" ((ptr)), "0" (__old),                \
> > > +                    "b" ((unsigned int)__new),               \
> > > +                    "c" ((unsigned int)(__new>>32))          \
> > > +                    : "memory");                             \
> > > +     success = (__prev == __old);                            \
> > > +     if (unlikely(!success))                                 \
> > > +             *_old = __prev;                                 \
> > > +     likely(success);                                        \
> > > +})
> >
> > Wouldn't this be better written like the normal fallback wrapper?
> >
> > static __always_inline bool
> > arch_try_cmpxchg64(u64 *v, u64 *old, u64 new)
> > {
> >         u64 r, o = *old;
> >         r = arch_cmpxchg64(v, o, new);
> >         if (unlikely(r != o))
> >                 *old = r;
> >         return likely(r == o);
> > }
> >
> > Less magical, same exact code.
>
> Also, I tried to follow up the existing #defines. Will improve the
> code according to your suggestion here.

In the v2 patch, generic fallbacks were introduced, so that
arch_try_cmpxchg64 can be used when only arch_cmpxchg64 is defined.

Uros.
