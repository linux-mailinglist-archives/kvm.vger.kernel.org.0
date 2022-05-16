Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEB0652865B
	for <lists+kvm@lfdr.de>; Mon, 16 May 2022 16:04:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244187AbiEPOET (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 10:04:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233234AbiEPOEO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 10:04:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3BA3039B9F
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 07:04:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652709853;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=msH0fbWMB2FjlFoGW4LyhQTRlos1WPFFFL4WveZKmPQ=;
        b=CL2VQK7dvCcVHwRyBR86Ni+0Xawuzz7dsINmJ+beYEOnH+Kt2t13UAQ/02nPP58VU9R6tR
        wvkRV4YHszrwBQVJpwfIj4owhI9KW1XZkUKYNqY0uGtqgwEVpypEjRYPKrTDp0RC9HQ/rK
        +mZ/pAeu4gYX7uJRbAOpBU0vY/ahU4o=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-558-HFWdWCckNxiAyEOTdL7HQw-1; Mon, 16 May 2022 10:04:09 -0400
X-MC-Unique: HFWdWCckNxiAyEOTdL7HQw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4037D89B841;
        Mon, 16 May 2022 14:04:08 +0000 (UTC)
Received: from starship (unknown [10.40.192.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CC86D2026D64;
        Mon, 16 May 2022 14:04:04 +0000 (UTC)
Message-ID: <fcf55234cfb95600d412322fba4dc9d0c9a1d7f4.camel@redhat.com>
Subject: Re: [PATCH] locking/atomic/x86: Introduce try_cmpxchg64
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Uros Bizjak <ubizjak@gmail.com>,
        Sean Christopherson <seanjc@google.com>
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
Date:   Mon, 16 May 2022 17:04:03 +0300
In-Reply-To: <CAFULd4bZDO5-3T4q9fanHFrRTDj8v6fypiTc=dFPO9Rp61g9eQ@mail.gmail.com>
References: <20220510154217.5216-1-ubizjak@gmail.com>
         <20220510165506.GP76023@worktop.programming.kicks-ass.net>
         <CAFULd4aNME5s2zGOO0A11kdjfHekH=ceSH7jUfAhmZaJWHv9cQ@mail.gmail.com>
         <20220511075409.GX76023@worktop.programming.kicks-ass.net>
         <CAFULd4aXpt_pnCR5OK5B1m5sErfB3uj_ez=-KW7=0qQheEdVzA@mail.gmail.com>
         <Ynven5y2u9WNfwK+@google.com>
         <CAFULd4bZDO5-3T4q9fanHFrRTDj8v6fypiTc=dFPO9Rp61g9eQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-05-11 at 21:54 +0200, Uros Bizjak wrote:
> On Wed, May 11, 2022 at 6:04 PM Sean Christopherson <seanjc@google.com> wrote:
> > On Wed, May 11, 2022, Uros Bizjak wrote:
> > > On Wed, May 11, 2022 at 9:54 AM Peter Zijlstra <peterz@infradead.org> wrote:
> > > > Still, does 32bit actually support that stuff?
> > > 
> > > Unfortunately, it does:
> > > 
> > > kvm-intel-y        += vmx/vmx.o vmx/vmenter.o vmx/pmu_intel.o vmx/vmcs12.o \
> > >                vmx/evmcs.o vmx/nested.o vmx/posted_intr.o
> > > 
> > > And when existing cmpxchg64 is substituted with cmpxchg, the
> > > compilation dies for 32bits with:
> > 
> > ...
> > 
> > > > Anyway, your patch looks about right, but I find it *really* hard to
> > > > care about 32bit code these days.
> > > 
> > > Thanks, this is also my sentiment, but I hope the patch will enable
> > > better code and perhaps ease similar situation I have had elsewhere.
> > 
> > IMO, if we merge this it should be solely on the benefits to 64-bit code.  Yes,
> > KVM still supports 32-bit kernels, but I'm fairly certain the only people that
> > run 32-bit KVM are KVM developers.  32-bit KVM has been completely broken for
> > multiple releases at least once, maybe twice, and no one ever complained.
> 
> Yes, the idea was to improve cmpxchg64 with the implementation of
> try_cmpxchg64 for 64bit targets. However, the issue with 32bit targets
> stood in the way, so the effort with 32-bit implementation was mainly
> to unblock progression for 64-bit targets.

Would that allow tdp mmu to work on 32 bit?

Best regards,
	Maxim Levitsky

> 
> Uros.
> 


