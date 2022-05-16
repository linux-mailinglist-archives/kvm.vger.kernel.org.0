Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66CB352867F
	for <lists+kvm@lfdr.de>; Mon, 16 May 2022 16:08:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244264AbiEPOIR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 10:08:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244085AbiEPOIO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 10:08:14 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A24113AA41
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 07:08:13 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id x23so14129798pff.9
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 07:08:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=u8W+9QrHPo7jdPM3Bcoe/9qQ4ATKCLa3Udps7+UVOAc=;
        b=a70vIt1fKElhDJvP1TFnRL5oukRLPASFThfAiiD0oSs+ftrcbRS+O6yQGBEhqMGLHW
         PM76KWpc8psDzV3PWj71Mu6MevW3FA4KEc1uqRGDYHY8Ij5oAtIrBCTyI3x9c4rfC/f+
         JdGhUpGE8JewAOEa23SbWg1suSLR6pgMqpT+YNk2e/XTWmUIPYJhcOuUaETTIcIw6soH
         pykKXejyUAgE9mbYBrYKY/5GZ94m7Ddj+AueGghoQ5jWv5nOz92UPBQLWFI0aONjbrom
         G+oLCsjyZ2RbZCLv6T0TobHjIZ/m6tyKAIZ7Q1LcX4O1wO+eiZCJSs4BXyeCD/X4zukB
         5UIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=u8W+9QrHPo7jdPM3Bcoe/9qQ4ATKCLa3Udps7+UVOAc=;
        b=vzDFqwXxq9TyEwntHEes3ajqfQnxLx9OdGWZEQED8IQUAL9vd8BWDrN/2u2prqvJcK
         uV/67tgyN0BCr5dHNbBNg8F/dNpn2VFwOAqPBrZF57HkZbwrf4hk5cejExJPMuL6nd7V
         SoYM6wa146VwK75SzeK5WpGcCX3L/kwU9XGT3OaKB3F6qjP4mMpHZL77pGyJWGuStsdL
         SCShU6A4viSbCfbFT5pJThtCWWqHzoIHXQDeLrN5325EMSHIWL//f9nUzoDTWUL854Ne
         vWZAfRi0fCz0PZENzIt2b3uze7sdUm2C4V9+Xmjv34hX4/VLeTVtrFA/57olhInRcDpC
         9gOw==
X-Gm-Message-State: AOAM532vFSnSmcU1Xpg/NgSOVAqXO3vffZ0THZOA5tq5La9ooNoL+0ib
        0x0sclA9ae4G1092U2fgZlYLDQ==
X-Google-Smtp-Source: ABdhPJz5NgVVTf7vK89fkPbIuFUxS+rfyRPXvX7qLlLWuEUustncEiJv134yGfkqbAZ1P1ORH7HSyg==
X-Received: by 2002:a63:1d42:0:b0:3ed:6b3d:c52d with SMTP id d2-20020a631d42000000b003ed6b3dc52dmr10639644pgm.295.1652710092327;
        Mon, 16 May 2022 07:08:12 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id c1-20020a170902c2c100b0015e8d4eb2e9sm6999368pla.307.2022.05.16.07.08.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 May 2022 07:08:11 -0700 (PDT)
Date:   Mon, 16 May 2022 14:08:08 +0000
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
Message-ID: <YoJayBWZF3mUnYS6@google.com>
References: <20220510154217.5216-1-ubizjak@gmail.com>
 <20220510165506.GP76023@worktop.programming.kicks-ass.net>
 <CAFULd4aNME5s2zGOO0A11kdjfHekH=ceSH7jUfAhmZaJWHv9cQ@mail.gmail.com>
 <20220511075409.GX76023@worktop.programming.kicks-ass.net>
 <CAFULd4aXpt_pnCR5OK5B1m5sErfB3uj_ez=-KW7=0qQheEdVzA@mail.gmail.com>
 <Ynven5y2u9WNfwK+@google.com>
 <CAFULd4bZDO5-3T4q9fanHFrRTDj8v6fypiTc=dFPO9Rp61g9eQ@mail.gmail.com>
 <fcf55234cfb95600d412322fba4dc9d0c9a1d7f4.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fcf55234cfb95600d412322fba4dc9d0c9a1d7f4.camel@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 16, 2022, Maxim Levitsky wrote:
> On Wed, 2022-05-11 at 21:54 +0200, Uros Bizjak wrote:
> > On Wed, May 11, 2022 at 6:04 PM Sean Christopherson <seanjc@google.com> wrote:
> > > On Wed, May 11, 2022, Uros Bizjak wrote:
> > > > On Wed, May 11, 2022 at 9:54 AM Peter Zijlstra <peterz@infradead.org> wrote:
> > > > > Still, does 32bit actually support that stuff?
> > > > 
> > > > Unfortunately, it does:
> > > > 
> > > > kvm-intel-y        += vmx/vmx.o vmx/vmenter.o vmx/pmu_intel.o vmx/vmcs12.o \
> > > >                vmx/evmcs.o vmx/nested.o vmx/posted_intr.o
> > > > 
> > > > And when existing cmpxchg64 is substituted with cmpxchg, the
> > > > compilation dies for 32bits with:
> > > 
> > > ...
> > > 
> > > > > Anyway, your patch looks about right, but I find it *really* hard to
> > > > > care about 32bit code these days.
> > > > 
> > > > Thanks, this is also my sentiment, but I hope the patch will enable
> > > > better code and perhaps ease similar situation I have had elsewhere.
> > > 
> > > IMO, if we merge this it should be solely on the benefits to 64-bit code.  Yes,
> > > KVM still supports 32-bit kernels, but I'm fairly certain the only people that
> > > run 32-bit KVM are KVM developers.  32-bit KVM has been completely broken for
> > > multiple releases at least once, maybe twice, and no one ever complained.
> > 
> > Yes, the idea was to improve cmpxchg64 with the implementation of
> > try_cmpxchg64 for 64bit targets. However, the issue with 32bit targets
> > stood in the way, so the effort with 32-bit implementation was mainly
> > to unblock progression for 64-bit targets.
> 
> Would that allow tdp mmu to work on 32 bit?

From a purely technical perspective, there's nothing that prevents enabling the
TDP MMU on 32-bit kernels.  The TDP MMU is 64-bit only to simplify the implementation
and to reduce the maintenance and validation costs.
