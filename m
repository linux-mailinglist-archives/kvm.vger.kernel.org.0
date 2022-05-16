Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0029A528901
	for <lists+kvm@lfdr.de>; Mon, 16 May 2022 17:37:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232105AbiEPPhM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 11:37:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245359AbiEPPhJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 11:37:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A6297245B4
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 08:37:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652715426;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DIRR+/4xP3PcsIIpPjK0T2ZfAKws5p6jyUGEq00/P8o=;
        b=W8DmFcLB9xCgdNT0ZM9H2ixXbaopL7NAmYVkokTQybr1E+cEjZb1fPaq1UhwxKHP/wLkWo
        e/Y0tAH9Ry3zWPOHo8tEfCiAD9B6aJgivTiXmEqRekIQQT3iomOw6pq7l93wN8Vug5HV8l
        BviWDAuamVOQMizwfixtvOS+REjp3I4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-455-9Rov6n1COPmSVID0SU7tbA-1; Mon, 16 May 2022 11:37:01 -0400
X-MC-Unique: 9Rov6n1COPmSVID0SU7tbA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D8F1D395AFE5;
        Mon, 16 May 2022 15:37:00 +0000 (UTC)
Received: from starship (unknown [10.40.192.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 71B61400E880;
        Mon, 16 May 2022 15:36:57 +0000 (UTC)
Message-ID: <874fad1e8443a88ef962775a960aac219c838b17.camel@redhat.com>
Subject: Re: [PATCH] locking/atomic/x86: Introduce try_cmpxchg64
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
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
Date:   Mon, 16 May 2022 18:36:56 +0300
In-Reply-To: <YoJqXMN38b8dYwyY@google.com>
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
         <YoJqXMN38b8dYwyY@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2022-05-16 at 15:14 +0000, Sean Christopherson wrote:
> On Mon, May 16, 2022, Maxim Levitsky wrote:
> > On Mon, 2022-05-16 at 14:08 +0000, Sean Christopherson wrote:
> > > On Mon, May 16, 2022, Maxim Levitsky wrote:
> > > > On Wed, 2022-05-11 at 21:54 +0200, Uros Bizjak wrote:
> > > > > On Wed, May 11, 2022 at 6:04 PM Sean Christopherson <seanjc@google.com> wrote:
> > > > > > On Wed, May 11, 2022, Uros Bizjak wrote:
> > > > > > > On Wed, May 11, 2022 at 9:54 AM Peter Zijlstra <peterz@infradead.org> wrote:
> > > > > > > > Still, does 32bit actually support that stuff?
> > > > > > > 
> > > > > > > Unfortunately, it does:
> > > > > > > 
> > > > > > > kvm-intel-y        += vmx/vmx.o vmx/vmenter.o vmx/pmu_intel.o vmx/vmcs12.o \
> > > > > > >                vmx/evmcs.o vmx/nested.o vmx/posted_intr.o
> > > > > > > 
> > > > > > > And when existing cmpxchg64 is substituted with cmpxchg, the
> > > > > > > compilation dies for 32bits with:
> > > > > > 
> > > > > > ...
> > > > > > 
> > > > > > > > Anyway, your patch looks about right, but I find it *really* hard to
> > > > > > > > care about 32bit code these days.
> > > > > > > 
> > > > > > > Thanks, this is also my sentiment, but I hope the patch will enable
> > > > > > > better code and perhaps ease similar situation I have had elsewhere.
> > > > > > 
> > > > > > IMO, if we merge this it should be solely on the benefits to 64-bit code.  Yes,
> > > > > > KVM still supports 32-bit kernels, but I'm fairly certain the only people that
> > > > > > run 32-bit KVM are KVM developers.  32-bit KVM has been completely broken for
> > > > > > multiple releases at least once, maybe twice, and no one ever complained.
> > > > > 
> > > > > Yes, the idea was to improve cmpxchg64 with the implementation of
> > > > > try_cmpxchg64 for 64bit targets. However, the issue with 32bit targets
> > > > > stood in the way, so the effort with 32-bit implementation was mainly
> > > > > to unblock progression for 64-bit targets.
> > > > 
> > > > Would that allow tdp mmu to work on 32 bit?
> > > 
> > > From a purely technical perspective, there's nothing that prevents enabling the
> > > TDP MMU on 32-bit kernels.  The TDP MMU is 64-bit only to simplify the implementation
> > > and to reduce the maintenance and validation costs.
> > 
> > I understand exactly that, so the question, will this patch help make the tdp
> > mmu work transparently on 32 bit kernels? I  heard that 64 bit cmpxchg was
> > one of the main reasons that it is 64 bit only.
> 
> I don't think it moves the needled much, e.g. non-atomic 64-bit accesses are still
> problematic, and we'd have to update the TDP MMU to deal with PAE paging (thanks
> NPT).  All those problems are solvable, it's purely a matter of the ongoing costs
> to solve them.
> 
> > I am asking because there was some talk to eliminate the direct mode from the
> > legacy non tdp mmu, which would simplify its code by a lot, but then it will
> > make 32 bit kernel fail back to shadowing mmu.
> 
> Simplify which code?  Between the nonpaging code and direct shadow pages in
> indirect MMUs, the vast majority of the "direct" support in the legacy MMU needs
> to be kept even if TDP support is dropped.  And the really nasty stuff, e.g. PAE
> roots, would need to be carried over to the TDP MMU.
> 

I guess this makes sense. I haven't researched the code well enough to know the exact answer.
I was just curious if this patch makes any difference :)

Thanks!

Best regards,
	Maxim Levitsky


