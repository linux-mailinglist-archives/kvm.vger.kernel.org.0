Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B4ED505C0D
	for <lists+kvm@lfdr.de>; Mon, 18 Apr 2022 17:56:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346025AbiDRP51 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Apr 2022 11:57:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245552AbiDRP5O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Apr 2022 11:57:14 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A03BDBC8D
        for <kvm@vger.kernel.org>; Mon, 18 Apr 2022 08:48:11 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id u2so19555993pgq.10
        for <kvm@vger.kernel.org>; Mon, 18 Apr 2022 08:48:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bblbj/fcJFwOLUNIwNuNwpTk1JwxMlxkSB/YW/1NkA8=;
        b=Ql/rsJabvCjhBQBFo9Rm6AmknNrjQobKZJ2h5Gk1G74DoLtW1OApk2N7YbeUgIcQch
         VhZ2BsHKlL2VYyg6IGk4Q1V66ktJAe/O/lh14ggl5/mHN9UlsAKL7RbfWD29K2u3mKUp
         yMqAWbYBFO+2tgm8/mDo2ukQ5E0Dv71chGMtQhMr3u6YwHRWtnpeBMImKg6BYMOfgWJz
         wBP97DlulgoTSdrAfcJwibewHQ2e54AU21nSC3/4ljdNAHclsT2/NFrRriOQ9cWkCjZN
         UVk7efZ/kErjL8+6c+Q5VrxtQQNB07aWtx1HyF6k7dXLHtvYf1Gjg2Cr0MK0Z1eNXHQV
         XnWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bblbj/fcJFwOLUNIwNuNwpTk1JwxMlxkSB/YW/1NkA8=;
        b=Ro2eBDci77zSjyvQwEYISi5drW9AoiEpCRv04dk4kKf7x775/IRzeyGwtJLRjYhNcd
         3/QCshfr5tHTCTuAOUOt8lgt/+Zl64hBa8vIgql4msPxgtaA9x00Ap0SWN26T1qHCrTS
         dGQUtq0JiZjea29PnTnZsgxkPLuUkjscq0kHTeM5rT+TROGlgEnyhfYWjjrAIjHc3//M
         pDMFUhS7c9yKLLbVAD3gC5FlrxniFXI6y9VL/6rnyxUkMGwq60B8xOlu8iJI/OE1AUKT
         IQX8S9dRTKKeZ4YjKEaNMTjZ4nW5CPwYo+TEvY0lJ9SxUcTN7f9/G7jx2SEgOEZQboFe
         wDiA==
X-Gm-Message-State: AOAM5328ISUIvt0rSaUZHTfRrH+D0bOwO4EYFkjt51/yhqVZ7tD7WX9q
        gqgk6vrDNn+t8D5EHfzTvKrjOg==
X-Google-Smtp-Source: ABdhPJxANphA5knqQ12sEaZqn+gwYLT7+9jsJDRzjOj7/Xl6HgrPjE8BccGXxvS9znUgXnXTpJ5yBw==
X-Received: by 2002:a63:79ce:0:b0:3a9:efa0:17d with SMTP id u197-20020a6379ce000000b003a9efa0017dmr5523712pgc.170.1650296890896;
        Mon, 18 Apr 2022 08:48:10 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id a9-20020aa78649000000b004fe3d6c1731sm13295314pfo.175.2022.04.18.08.48.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Apr 2022 08:48:10 -0700 (PDT)
Date:   Mon, 18 Apr 2022 15:48:07 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Gonda <pgonda@google.com>
Cc:     Mingwei Zhang <mizhang@google.com>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: SEV: Add cond_resched() to loop in
 sev_clflush_pages()
Message-ID: <Yl2IN6CHQzkts4XE@google.com>
References: <20220330164306.2376085-1-pgonda@google.com>
 <CAL715W+S-SJwXBhYO=_T-9uAPLt6cQ-Hn+_+ehefAh6+kQ_zOA@mail.gmail.com>
 <YkYdlfYM/FWlMqMg@google.com>
 <CAL715WLhy7EkJCyO7vzak3O8iw8GDRHkPF8aRtDedPXO1vx_Qw@mail.gmail.com>
 <Yk3bSmQTspjZHUZf@google.com>
 <CAMkAt6obVDW_LFvQzUYw6v7okiNq1KAbUOMoM3bN6zeJUGg6Xw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMkAt6obVDW_LFvQzUYw6v7okiNq1KAbUOMoM3bN6zeJUGg6Xw@mail.gmail.com>
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

On Wed, Apr 06, 2022, Peter Gonda wrote:
> On Wed, Apr 6, 2022 at 12:26 PM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Wed, Apr 06, 2022, Mingwei Zhang wrote:
> > > Hi Sean,
> > >
> > > > > > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > > > > > index 75fa6dd268f0..c2fe89ecdb2d 100644
> > > > > > --- a/arch/x86/kvm/svm/sev.c
> > > > > > +++ b/arch/x86/kvm/svm/sev.c
> > > > > > @@ -465,6 +465,7 @@ static void sev_clflush_pages(struct page *pages[], unsigned long npages)
> > > > > >                 page_virtual = kmap_atomic(pages[i]);
> > > > > >                 clflush_cache_range(page_virtual, PAGE_SIZE);
> > > > > >                 kunmap_atomic(page_virtual);
> > > > > > +               cond_resched();
> > > > >
> > > > > If you add cond_resched() here, the frequency (once per 4K) might be
> > > > > too high. You may want to do it once per X pages, where X could be
> > > > > something like 1G/4K?
> > > >
> > > > No, every iteration is perfectly ok.  The "cond"itional part means that this will
> > > > reschedule if and only if it actually needs to be rescheduled, e.g. if the task's
> > > > timeslice as expired.  The check for a needed reschedule is cheap, using
> > > > cond_resched() in tight-ish loops is ok and intended, e.g. KVM does a reched
> > > > check prior to enterring the guest.
> > >
> > > Double check on the code again. I think the point is not about flag
> > > checking. Obviously branch prediction could really help. The point I
> > > think is the 'call' to cond_resched(). Depending on the kernel
> > > configuration, cond_resched() may not always be inlined, at least this
> > > is my understanding so far? So if that is true, then it still might
> > > not always be the best to call cond_resched() that often.
> >
> > Eh, compared to the cost of 64 back-to-back CLFLUSHOPTs, the cost of __cond_resched()
> > is peanuts.  Even accounting for the rcu_all_qs() work, it's still dwarfed by the
> > cost of flushing data from the cache.  E.g. based on Agner Fog's wonderful uop
> > latencies[*], the actual flush time for a single page is going to be upwards of
> > 10k cycles, whereas __cond_resched() is going to well under 100 cycles in the happy
> > case of no work.  Even if those throughput numbers are off by an order of magnitude,
> > e.g. CLFLUSHOPT can complete in 15 cycles, that's still ~1k cycles.
> >
> > Peter, don't we also theoretically need cond_resched() in the loops in
> > sev_launch_update_data()?  AFAICT, there's no articifical restriction on the size
> > of the payload, i.e. the kernel is effectively relying on userspace to not update
> > large swaths of memory.
> 
> Yea we probably do want to cond_resched() in the for loop inside of
> sev_launch_update_data(). Ithink in  sev_dbg_crypt() userspace could
> request a large number of pages to be decrypted/encrypted for
> debugging but se have a call to sev_pin_memory() in the loop so that
> will have a cond_resded() inside of __get_users_pages(). Or should we
> have a cond_resded() inside of the loop in sev_dbg_crypt() too?

I believe sev_dbg_crypt() needs a cond_resched() of its own, sev_pin_memory()
isn't guaranteed to get into the slow path of internal_get_user_pages_fast().
