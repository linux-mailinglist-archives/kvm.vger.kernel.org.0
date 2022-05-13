Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00ECC526022
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 12:39:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379344AbiEMKVY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 May 2022 06:21:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379366AbiEMKVL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 May 2022 06:21:11 -0400
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B41F635A8C;
        Fri, 13 May 2022 03:21:09 -0700 (PDT)
Received: by mail-qk1-x72b.google.com with SMTP id v11so6727205qkf.1;
        Fri, 13 May 2022 03:21:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=H6ylwExavTNkB9OKuRxxHz9+Xg9/ks6xmcZnmCtHXS4=;
        b=g7sMP1a/2Ow4/qzpN/Sm8aIBRpxhQcQyCbqaVkaoHj4pQXP7aKNC5YWj6wegNBoSVd
         TfGGvzvOuXLaN1VIXbzx0DIbATYr3Fe007x6dNTtpV1p/3gK0ZhgdjAW/wG7K46Y873b
         3zgKCMlepFUMBfunyi0UblgvQKj2DlJFl4E0OnPhXdMYCGbyPPIdgCiHN7o+mNGNBDRp
         Oz7WztObzxYcFGquAJCzfHsHC2Y9HkHvkBCQTZ7faaKEml65v8TYxFYbesnyxNJTYklz
         AM90lL7v3gZTPwrrMeadUkkATk6QEcXggcp/1P/CqUOayhEWnqcKvchfs3X6pFPfI7bG
         Q1jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=H6ylwExavTNkB9OKuRxxHz9+Xg9/ks6xmcZnmCtHXS4=;
        b=LKGqb6jOlFGh2+SQo86BKsCZB3l8OkT1OGwmvXgNwznLkPXYwNH3nioCeeJf6M8bMl
         q3CIN8uBXTtTtF+HhKjynEWNNVNZFmWZMq9nYmL6MdUUb4voTTzNTk0004DJqivLiQux
         kpurmKqf+c3GsNguPC2qrYRW/yImYw8QrlXRv/k+74geOtPZT77ii12zcB1weMwh//3l
         q/6Y5OIXwtt4AHLdN8il4D7Qtz42Ho2993ZcPvufwKHfskizDW+6gpIYcJCWSGzN9ATG
         BoFK6I0vuJsNRLppG1xQS3YZxIRozOqJ8xbUu4g0F6sr9vOIeHjWSBs/C65vq2jmqEef
         +krg==
X-Gm-Message-State: AOAM531EG7dJnsrsmufUdCgmDRji0pgVygy+FZdDswwHeS/tHUG/u/HM
        6aruZByJh9DIOfA27HBlCPr9ZauRsGtQZ/rMmU8=
X-Google-Smtp-Source: ABdhPJxiJw1Fre6mkmANvSgkm0EHSpd2RqKozOhnla/0jPGCJ4Q1kJ8UDjHbT3oJWUqW4svCeK/hgsML7lzmHAy+nhc=
X-Received: by 2002:a05:620a:1a01:b0:69c:fda:7404 with SMTP id
 bk1-20020a05620a1a0100b0069c0fda7404mr3084015qkb.522.1652437268783; Fri, 13
 May 2022 03:21:08 -0700 (PDT)
MIME-Version: 1.0
References: <20220510154217.5216-1-ubizjak@gmail.com> <20220513091034.GH76023@worktop.programming.kicks-ass.net>
In-Reply-To: <20220513091034.GH76023@worktop.programming.kicks-ass.net>
From:   Uros Bizjak <ubizjak@gmail.com>
Date:   Fri, 13 May 2022 12:20:57 +0200
Message-ID: <CAFULd4bAAKc=wo6vFkN6xQqBjaSJhF3L+WmuymSsC6-ec6TuvA@mail.gmail.com>
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

On Fri, May 13, 2022 at 11:10 AM Peter Zijlstra <peterz@infradead.org> wrote:
>
> On Tue, May 10, 2022 at 05:42:17PM +0200, Uros Bizjak wrote:
>
> For the Changelog I would focus on the 64bit improvement and leave 32bit
> as a side-note.

Thanks, I will rephrase the ChangeLog.

>
> > ---
> >  arch/x86/include/asm/cmpxchg_32.h          | 43 ++++++++++++++++++++++
> >  arch/x86/include/asm/cmpxchg_64.h          |  6 +++
> >  include/linux/atomic/atomic-instrumented.h | 40 +++++++++++++++++++-
> >  scripts/atomic/gen-atomic-instrumented.sh  |  2 +-
> >  4 files changed, 89 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/x86/include/asm/cmpxchg_32.h b/arch/x86/include/asm/cmpxchg_32.h
> > index 0a7fe0321613..e874ff7f7529 100644
> > --- a/arch/x86/include/asm/cmpxchg_32.h
> > +++ b/arch/x86/include/asm/cmpxchg_32.h
> > @@ -42,6 +42,9 @@ static inline void set_64bit(volatile u64 *ptr, u64 value)
> >  #define arch_cmpxchg64_local(ptr, o, n)                                      \
> >       ((__typeof__(*(ptr)))__cmpxchg64_local((ptr), (unsigned long long)(o), \
> >                                              (unsigned long long)(n)))
> > +#define arch_try_cmpxchg64(ptr, po, n)                                       \
> > +     ((__typeof__(*(ptr)))__try_cmpxchg64((ptr), (unsigned long long *)(po), \
> > +                                          (unsigned long long)(n)))
> >  #endif
> >
> >  static inline u64 __cmpxchg64(volatile u64 *ptr, u64 old, u64 new)
> > @@ -70,6 +73,25 @@ static inline u64 __cmpxchg64_local(volatile u64 *ptr, u64 old, u64 new)
> >       return prev;
> >  }
> >
> > +static inline bool __try_cmpxchg64(volatile u64 *ptr, u64 *pold, u64 new)
> > +{
> > +     bool success;
> > +     u64 prev;
> > +     asm volatile(LOCK_PREFIX "cmpxchg8b %2"
> > +                  CC_SET(z)
> > +                  : CC_OUT(z) (success),
> > +                    "=A" (prev),
> > +                    "+m" (*ptr)
> > +                  : "b" ((u32)new),
> > +                    "c" ((u32)(new >> 32)),
> > +                    "1" (*pold)
> > +                  : "memory");
> > +
> > +     if (unlikely(!success))
> > +             *pold = prev;
>
> I would prefer this be more like the existing try_cmpxchg code,
> perhaps:
>
>         u64 old = *pold;
>
>         asm volatile (LOCK_PREFIX "cmpxchg8b %[ptr]"
>                       CC_SET(z)
>                       : CC_OUT(z) (success),
>                         [ptr] "+m" (*ptr)
>                         "+A" (old)
>                       : "b" ((u32)new)
>                         "c" ((u32)(new >> 32))
>                       : "memory");
>
>         if (unlikely(!success))
>                 *pold = old;
>
> The existing 32bit cmpxchg code is a 'bit' crusty.

I was trying to follow the existing __cmpxchg64 as much as possible,
with the intention of a follow-up patch that would modernize
everything in cmpxchg_32.h. I can surely go the other way and submit
modernized new code.

> > +     return success;
> > +}
> > +
> >  #ifndef CONFIG_X86_CMPXCHG64
> >  /*
> >   * Building a kernel capable running on 80386 and 80486. It may be necessary
> > @@ -108,6 +130,27 @@ static inline u64 __cmpxchg64_local(volatile u64 *ptr, u64 old, u64 new)
> >                      : "memory");                             \
> >       __ret; })
> >
> > +#define arch_try_cmpxchg64(ptr, po, n)                               \
> > +({                                                           \
> > +     bool success;                                           \
> > +     __typeof__(*(ptr)) __prev;                              \
> > +     __typeof__(ptr) _old = (__typeof__(ptr))(po);           \
> > +     __typeof__(*(ptr)) __old = *_old;                       \
> > +     __typeof__(*(ptr)) __new = (n);                         \
> > +     alternative_io(LOCK_PREFIX_HERE                         \
> > +                     "call cmpxchg8b_emu",                   \
> > +                     "lock; cmpxchg8b (%%esi)" ,             \
> > +                    X86_FEATURE_CX8,                         \
> > +                    "=A" (__prev),                           \
> > +                    "S" ((ptr)), "0" (__old),                \
> > +                    "b" ((unsigned int)__new),               \
> > +                    "c" ((unsigned int)(__new>>32))          \
> > +                    : "memory");                             \
> > +     success = (__prev == __old);                            \
> > +     if (unlikely(!success))                                 \
> > +             *_old = __prev;                                 \
> > +     likely(success);                                        \
> > +})
>
> Wouldn't this be better written like the normal fallback wrapper?
>
> static __always_inline bool
> arch_try_cmpxchg64(u64 *v, u64 *old, u64 new)
> {
>         u64 r, o = *old;
>         r = arch_cmpxchg64(v, o, new);
>         if (unlikely(r != o))
>                 *old = r;
>         return likely(r == o);
> }
>
> Less magical, same exact code.

Also, I tried to follow up the existing #defines. Will improve the
code according to your suggestion here.

Thanks,
Uros.
