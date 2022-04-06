Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF0EF4F69E2
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 21:30:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231576AbiDFTb4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 15:31:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231283AbiDFTbV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 15:31:21 -0400
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B374A1F6216
        for <kvm@vger.kernel.org>; Wed,  6 Apr 2022 10:53:35 -0700 (PDT)
Received: by mail-qt1-x833.google.com with SMTP id t2so5629055qtw.9
        for <kvm@vger.kernel.org>; Wed, 06 Apr 2022 10:53:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UiC0JZZNX3Tmz74Za2QGi0YjgPWaNriTzAia+mIG/oY=;
        b=C8Z9DYmcvxvJu8NY+MYMQtX06XDHFQ8K7wmWpgt+e7UvuTJ9kBW6rgJ4m96ItAT6bC
         agSP0mlkb7pnOPpK4P5qXOxdL3bq3763M5W3mQub8hSZw4EHWvaiGixVMKZjjpkduDrG
         /01OoPFxfig9PKbGV/F3KE1OujzAGwrfqLQiAruhJhtDtf9ijrhVvcQB6SLC0vb+q3qf
         8Vl9LEL+vckhVErsWsETDcjgIWL4qfXEq9DCiY2YNiB3pdXE+lO4IuMvWvz1EfPk6J/t
         DV0ZhLSsIxbw3Pqo48d1dCeDRNuY0lzlWrixn45pwenckWRpx7+MZxNkmc5uxMQamJBA
         Bm8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UiC0JZZNX3Tmz74Za2QGi0YjgPWaNriTzAia+mIG/oY=;
        b=G6qJAeYs44glQCQcUVUyrtAJINv+JbBnclwUqj1ocjab2aSIdd6fPDK60YYxYHsWUe
         qD/n7DJSc9zzML2IDKtVxNexurKSXisn5uFCyw6jTDhaUUzgB/OPEN63ih7IcNG/SDas
         B86M/BV6Cff9cjsps7wVWgxs57TtWavKro7B2QoNPQ2TET0lsAuswMQQGTZ1icUh+d2p
         li5QYU3rpJv23wb3Kaq2yfYk6wNmzTsh0XKc2dA5x/7F4amd5o+vgZSWvsOYZedtRfpb
         Zx1rzupEhzATx9enJqE3T+K21yDwKyrmKrPKaitpq1+gqdHwxmI06AggZCUz80gtH4d5
         wvVw==
X-Gm-Message-State: AOAM531MrXtPb3CuSv26yMmaDsAXGXvgfsY3srpi1sxKqsuTuA2dnK/F
        jKp+KTJczlxVYnUPOt1aMNMddvzM7pTPjCdiWmfqIbijj/U=
X-Google-Smtp-Source: ABdhPJwOnUHmEK3nL1Hw0/iJrblnXqISxL1gjp5QrgobTxIRsSlbBb1hCnBusAh4f2TNJVRB/0hdR0CBT2U4iymcC9w=
X-Received: by 2002:a05:622a:610:b0:2e2:694:38c6 with SMTP id
 z16-20020a05622a061000b002e2069438c6mr8559136qta.458.1649267614742; Wed, 06
 Apr 2022 10:53:34 -0700 (PDT)
MIME-Version: 1.0
References: <20220330164306.2376085-1-pgonda@google.com> <CAL715W+S-SJwXBhYO=_T-9uAPLt6cQ-Hn+_+ehefAh6+kQ_zOA@mail.gmail.com>
 <YkYdlfYM/FWlMqMg@google.com>
In-Reply-To: <YkYdlfYM/FWlMqMg@google.com>
From:   Mingwei Zhang <mizhang@google.com>
Date:   Wed, 6 Apr 2022 10:53:23 -0700
Message-ID: <CAL715WLhy7EkJCyO7vzak3O8iw8GDRHkPF8aRtDedPXO1vx_Qw@mail.gmail.com>
Subject: Re: [PATCH] KVM: SEV: Add cond_resched() to loop in sev_clflush_pages()
To:     Sean Christopherson <seanjc@google.com>
Cc:     Peter Gonda <pgonda@google.com>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sean,

> > > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > > index 75fa6dd268f0..c2fe89ecdb2d 100644
> > > --- a/arch/x86/kvm/svm/sev.c
> > > +++ b/arch/x86/kvm/svm/sev.c
> > > @@ -465,6 +465,7 @@ static void sev_clflush_pages(struct page *pages[], unsigned long npages)
> > >                 page_virtual = kmap_atomic(pages[i]);
> > >                 clflush_cache_range(page_virtual, PAGE_SIZE);
> > >                 kunmap_atomic(page_virtual);
> > > +               cond_resched();
> >
> > If you add cond_resched() here, the frequency (once per 4K) might be
> > too high. You may want to do it once per X pages, where X could be
> > something like 1G/4K?
>
> No, every iteration is perfectly ok.  The "cond"itional part means that this will
> reschedule if and only if it actually needs to be rescheduled, e.g. if the task's
> timeslice as expired.  The check for a needed reschedule is cheap, using
> cond_resched() in tight-ish loops is ok and intended, e.g. KVM does a reched
> check prior to enterring the guest.

Double check on the code again. I think the point is not about flag
checking. Obviously branch prediction could really help. The point I
think is the 'call' to cond_resched(). Depending on the kernel
configuration, cond_resched() may not always be inlined, at least this
is my understanding so far? So if that is true, then it still might
not always be the best to call cond_resched() that often.
