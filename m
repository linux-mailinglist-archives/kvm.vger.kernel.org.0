Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 299E752883A
	for <lists+kvm@lfdr.de>; Mon, 16 May 2022 17:14:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244819AbiEPPOq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 11:14:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230372AbiEPPOo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 11:14:44 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 624E93BA6B
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 08:14:43 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id q7so3311376plx.3
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 08:14:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=18f9yUH1/w73tmifgqC4XWy7DHTtV6nZ9pn9JLOs8G4=;
        b=BMoeDTwmiLVu4Yp7Hb0ZS2ktRN19j8if9lN2p7YpJuwfvZMETAPUAdeU+YJo8AMPlg
         MCmCHbU/CKD+LiJ4Pjfxlbhvfk/1AnBjSBNX8oqKjnw2ya2zf2vVny5Md7+vJt+qJmrb
         BUOkJ4YyEHH5sBZGFEGxEMDm4W4V9BG0n98a8oqKwLXaVlrIeEkMuA2dKL21KgzGM9Az
         4SxA5msjI+ifRYKYSZrH/gue3IMkfqclFB9pBj2pz1khU112i/89GzVXLgdUDbOb4R1b
         46QRgkkcE/HkoH2njsKRysihh3Y2ZFmA78C3nh8fkKStwO/MW/69ph4fWii92pqlgvno
         b92A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=18f9yUH1/w73tmifgqC4XWy7DHTtV6nZ9pn9JLOs8G4=;
        b=QID+IFmOGzGGeIHUmRwSHvhJGzvCV7nUbma8BQatpk4NBaC77CJmJKOWgy4uq0Qfj5
         U36b1xoIm6XRm1aeGWoDQHxW+rRByQaWVUujVtYZvdqX7dlrrKBM9mUhs9j/yKQQibXj
         CLKwHjVZxfsW3ofhBdL5dvqQevbShea2rboo+8cKp0O84pF4ff4v75hVwocf4dfvzbUg
         dLhFmxMjrAyQFQD6sQcJR8KaeRLw9FuC3J0k6qW/Fc1Oi6Qec3MmmXfujwBQXjnpkIpM
         9U0xA3lIsFhmIWXSdm3RjCI6O/c4ebiC092+2IbWpozsuwLr9rdwBdTRpKvFyuYs8W4N
         PTcA==
X-Gm-Message-State: AOAM531L1LJIITh8A1HNZzPr5zTqaCVDTzj1RWQWJlNEl0968uvxoFhp
        lU7ZBGXL0I0Ezs4kMCYUYP/wPQ==
X-Google-Smtp-Source: ABdhPJyl+1yfgFUS4YuuskID0E4r3jxMJV3EP+gpOW8qxwgxQr3JeLBasBIfZBXK57mOkF0wiRRWBg==
X-Received: by 2002:a17:903:288:b0:15f:4cc6:3195 with SMTP id j8-20020a170903028800b0015f4cc63195mr17620427plr.45.1652714082615;
        Mon, 16 May 2022 08:14:42 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id b12-20020a17090a5a0c00b001ded49491basm198821pjd.2.2022.05.16.08.14.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 May 2022 08:14:41 -0700 (PDT)
Date:   Mon, 16 May 2022 15:14:36 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Uros Bizjak <ubizjak@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Will Deacon <will@kernel.org>,
        Boqun Feng <boqun.feng@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Marco Elver <elver@google.com>
Subject: Re: [PATCH] locking/atomic/x86: Introduce try_cmpxchg64
Message-ID: <YoJqXMN38b8dYwyY@google.com>
References: <20220510154217.5216-1-ubizjak@gmail.com>
 <20220510165506.GP76023@worktop.programming.kicks-ass.net>
 <CAFULd4aNME5s2zGOO0A11kdjfHekH=ceSH7jUfAhmZaJWHv9cQ@mail.gmail.com>
 <20220511075409.GX76023@worktop.programming.kicks-ass.net>
 <CAFULd4aXpt_pnCR5OK5B1m5sErfB3uj_ez=-KW7=0qQheEdVzA@mail.gmail.com>
 <Ynven5y2u9WNfwK+@google.com>
 <CAFULd4bZDO5-3T4q9fanHFrRTDj8v6fypiTc=dFPO9Rp61g9eQ@mail.gmail.com>
 <fcf55234cfb95600d412322fba4dc9d0c9a1d7f4.camel@redhat.com>
 <YoJayBWZF3mUnYS6@google.com>
 <9ed2fc294bf2c21b41b22605ff8039bb71903712.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9ed2fc294bf2c21b41b22605ff8039bb71903712.camel@redhat.com>
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

On Mon, May 16, 2022, Maxim Levitsky wrote:
> On Mon, 2022-05-16 at 14:08 +0000, Sean Christopherson wrote:
> > On Mon, May 16, 2022, Maxim Levitsky wrote:
> > > On Wed, 2022-05-11 at 21:54 +0200, Uros Bizjak wrote:
> > > > On Wed, May 11, 2022 at 6:04 PM Sean Christopherson <seanjc@google.com> wrote:
> > > > > On Wed, May 11, 2022, Uros Bizjak wrote:
> > > > > > On Wed, May 11, 2022 at 9:54 AM Peter Zijlstra <peterz@infradead.org> wrote:
> > > > > > > Still, does 32bit actually support that stuff?
> > > > > > 
> > > > > > Unfortunately, it does:
> > > > > > 
> > > > > > kvm-intel-y        += vmx/vmx.o vmx/vmenter.o vmx/pmu_intel.o vmx/vmcs12.o \
> > > > > >                vmx/evmcs.o vmx/nested.o vmx/posted_intr.o
> > > > > > 
> > > > > > And when existing cmpxchg64 is substituted with cmpxchg, the
> > > > > > compilation dies for 32bits with:
> > > > > 
> > > > > ...
> > > > > 
> > > > > > > Anyway, your patch looks about right, but I find it *really* hard to
> > > > > > > care about 32bit code these days.
> > > > > > 
> > > > > > Thanks, this is also my sentiment, but I hope the patch will enable
> > > > > > better code and perhaps ease similar situation I have had elsewhere.
> > > > > 
> > > > > IMO, if we merge this it should be solely on the benefits to 64-bit code.  Yes,
> > > > > KVM still supports 32-bit kernels, but I'm fairly certain the only people that
> > > > > run 32-bit KVM are KVM developers.  32-bit KVM has been completely broken for
> > > > > multiple releases at least once, maybe twice, and no one ever complained.
> > > > 
> > > > Yes, the idea was to improve cmpxchg64 with the implementation of
> > > > try_cmpxchg64 for 64bit targets. However, the issue with 32bit targets
> > > > stood in the way, so the effort with 32-bit implementation was mainly
> > > > to unblock progression for 64-bit targets.
> > > 
> > > Would that allow tdp mmu to work on 32 bit?
> > 
> > From a purely technical perspective, there's nothing that prevents enabling the
> > TDP MMU on 32-bit kernels.  The TDP MMU is 64-bit only to simplify the implementation
> > and to reduce the maintenance and validation costs.
> 
> I understand exactly that, so the question, will this patch help make the tdp
> mmu work transparently on 32 bit kernels? I  heard that 64 bit cmpxchg was
> one of the main reasons that it is 64 bit only.

I don't think it moves the needled much, e.g. non-atomic 64-bit accesses are still
problematic, and we'd have to update the TDP MMU to deal with PAE paging (thanks
NPT).  All those problems are solvable, it's purely a matter of the ongoing costs
to solve them.

> I am asking because there was some talk to eliminate the direct mode from the
> legacy non tdp mmu, which would simplify its code by a lot, but then it will
> make 32 bit kernel fail back to shadowing mmu.

Simplify which code?  Between the nonpaging code and direct shadow pages in
indirect MMUs, the vast majority of the "direct" support in the legacy MMU needs
to be kept even if TDP support is dropped.  And the really nasty stuff, e.g. PAE
roots, would need to be carried over to the TDP MMU.
