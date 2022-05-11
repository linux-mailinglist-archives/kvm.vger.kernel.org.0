Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F0A6523811
	for <lists+kvm@lfdr.de>; Wed, 11 May 2022 18:05:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344330AbiEKQFF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 May 2022 12:05:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344395AbiEKQEz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 May 2022 12:04:55 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 020D11D3D49
        for <kvm@vger.kernel.org>; Wed, 11 May 2022 09:04:51 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id x18so2317955plg.6
        for <kvm@vger.kernel.org>; Wed, 11 May 2022 09:04:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TRKmAr5NAdQKEYAx0dVLgEebSdJiqCRTYjBrDYpiOp0=;
        b=qC7AesSwyMDnyGl33oJbOlVtzDDtrNyv/UI9YPmCNFCb32MV8ZWDQZuurnWgehEVKQ
         pAJnAKGfgm5aJWrYYA98SQ4SfRf9cl7yY9zD8XSDe5z/1FIS3Jr9abC4tLZ6HSV6uUGU
         g/Z4eLQnc8NDYkRWUOSKnl/StkCs8VDm87+thHuE34uRCjxYdcgNSSf5oBQh0jri+1YA
         gsU65s4kn6qbOGKB6D7VXGlbuJkbDB8IwT5W4XOgFhrEAQEdVKrZ0kCwQq9U7PNKW8Rc
         rW3wLcjptzHpgJfSU9l0ScBmNKKn3JQ7KXpFE0CyWdnDszsC2buG9tzEvAopnrddQrAN
         Iyjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TRKmAr5NAdQKEYAx0dVLgEebSdJiqCRTYjBrDYpiOp0=;
        b=xdZ5vB9dLYD1bdfVxMQtP85ixiJL9r8c4NcMwBHtLNjhh1xDJNpubcSPnflkkZnQL3
         R0SvKSfVEMLnWZlY8NH1X3vHy1fwAizf0nKE6p0Tnk0QZGkE8K1c1kaDj2SgIeR8mKz+
         2KVClw+vUsdO5Us+3wvLweklmDBpu6iJaJjA1IMkqdeTH6Iq48QIi0u32OOUYnnW2F2g
         3uTZGcTXl12b3/4FH2+i5gNYhYW0bjF+59/Ba8fNCoL3qpJf5BvFOtjYxQTSNDtVstDj
         EwRCFAO5VHUSoWhMUC0QT9Q7eWVe3FLhY3NKv0mAjeL95T9ehkGwtBfN7oJOMIuO60wZ
         Bazg==
X-Gm-Message-State: AOAM533u4rxgo57WrZ1Sy3oJVWh8ZI5UoBiT00HUd7RVCpAVf59gSQp8
        ywH1IoVQY5JpbhWS6AULK1myFA==
X-Google-Smtp-Source: ABdhPJyigL7p2FbwrSbjxQ0qIW43a/IDZNnz9751M7J7aEmUDws/iTZzN0VGmnDSyHgYIZhW4iM6zg==
X-Received: by 2002:a17:90a:bc8a:b0:1db:382d:6fb5 with SMTP id x10-20020a17090abc8a00b001db382d6fb5mr6112062pjr.100.1652285091145;
        Wed, 11 May 2022 09:04:51 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id z12-20020a170902708c00b0015e8d4eb1desm2063112plk.40.2022.05.11.09.04.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 May 2022 09:04:50 -0700 (PDT)
Date:   Wed, 11 May 2022 16:04:47 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Uros Bizjak <ubizjak@gmail.com>
Cc:     Peter Zijlstra <peterz@infradead.org>, X86 ML <x86@kernel.org>,
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
Message-ID: <Ynven5y2u9WNfwK+@google.com>
References: <20220510154217.5216-1-ubizjak@gmail.com>
 <20220510165506.GP76023@worktop.programming.kicks-ass.net>
 <CAFULd4aNME5s2zGOO0A11kdjfHekH=ceSH7jUfAhmZaJWHv9cQ@mail.gmail.com>
 <20220511075409.GX76023@worktop.programming.kicks-ass.net>
 <CAFULd4aXpt_pnCR5OK5B1m5sErfB3uj_ez=-KW7=0qQheEdVzA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFULd4aXpt_pnCR5OK5B1m5sErfB3uj_ez=-KW7=0qQheEdVzA@mail.gmail.com>
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

On Wed, May 11, 2022, Uros Bizjak wrote:
> On Wed, May 11, 2022 at 9:54 AM Peter Zijlstra <peterz@infradead.org> wrote:
> > Still, does 32bit actually support that stuff?
> 
> Unfortunately, it does:
> 
> kvm-intel-y        += vmx/vmx.o vmx/vmenter.o vmx/pmu_intel.o vmx/vmcs12.o \
>                vmx/evmcs.o vmx/nested.o vmx/posted_intr.o
> 
> And when existing cmpxchg64 is substituted with cmpxchg, the
> compilation dies for 32bits with:

...

> > Anyway, your patch looks about right, but I find it *really* hard to
> > care about 32bit code these days.
> 
> Thanks, this is also my sentiment, but I hope the patch will enable
> better code and perhaps ease similar situation I have had elsewhere.

IMO, if we merge this it should be solely on the benefits to 64-bit code.  Yes,
KVM still supports 32-bit kernels, but I'm fairly certain the only people that
run 32-bit KVM are KVM developers.  32-bit KVM has been completely broken for
multiple releases at least once, maybe twice, and no one ever complained.

32-bit KVM is mostly useful for testing the mess that is nested NPT; an L1
hypervsior can use 32-bit paging for NPT, so KVM needs to at least make sure it
doesn't blow up if such a hypervisor is encountered.  But in terms of the performance
of 32-bit KVM, I doubt there is a person in the world that cares.
