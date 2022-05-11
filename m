Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FC1D522DB6
	for <lists+kvm@lfdr.de>; Wed, 11 May 2022 09:54:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243201AbiEKHyk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 May 2022 03:54:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239799AbiEKHyi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 May 2022 03:54:38 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02BEB590A4;
        Wed, 11 May 2022 00:54:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=NRzg9BMGZ8Y+RRvXMPsod+kdMY39tgO1LAjDB+4Koho=; b=W5uCK5iUANqz0n4NnO/prBk8/D
        6MdMrRP8VEA+HE2DeJI842gi9L/YVcwPw4cIlXBXMwgGb4l+YEXBpayM5aANi+05OUSfO9bHyuQio
        7hapr+FvMnWi1NExGYf6xuRyrIe7R426HnuTx4gpZImZ4XL4w42lbG+XorJexICtkq0EZP5YmDHNq
        2P75nD6+JoddYL59d4WCzYrrHrWY3AotkXEr0ED1FlxElQfwBmct1mdG+YaPh/46EsI8C/L95c+kC
        mAnWc1PcYQVXifThtahz9fozV+wDAOBAipLe99xOxG903cvW8wCyf40CU/YmKFhfCwWAsPO7ta3gq
        o3qEhWPw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=worktop.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nohAh-00D6D6-PM; Wed, 11 May 2022 07:54:12 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id 57FBD980E3A; Wed, 11 May 2022 09:54:09 +0200 (CEST)
Date:   Wed, 11 May 2022 09:54:09 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Uros Bizjak <ubizjak@gmail.com>
Cc:     X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        kvm@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Will Deacon <will@kernel.org>,
        Boqun Feng <boqun.feng@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Marco Elver <elver@google.com>
Subject: Re: [PATCH] locking/atomic/x86: Introduce try_cmpxchg64
Message-ID: <20220511075409.GX76023@worktop.programming.kicks-ass.net>
References: <20220510154217.5216-1-ubizjak@gmail.com>
 <20220510165506.GP76023@worktop.programming.kicks-ass.net>
 <CAFULd4aNME5s2zGOO0A11kdjfHekH=ceSH7jUfAhmZaJWHv9cQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFULd4aNME5s2zGOO0A11kdjfHekH=ceSH7jUfAhmZaJWHv9cQ@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 10, 2022 at 07:07:25PM +0200, Uros Bizjak wrote:
> On Tue, May 10, 2022 at 6:55 PM Peter Zijlstra <peterz@infradead.org> wrote:
> >
> > On Tue, May 10, 2022 at 05:42:17PM +0200, Uros Bizjak wrote:
> > > This patch adds try_cmpxchg64 to improve code around cmpxchg8b.  While
> > > the resulting code improvements on x86_64 are minor (a compare and a move saved),
> > > the improvements on x86_32 are quite noticeable. The code improves from:
> >
> > What user of cmpxchg64 is this?
> 
> This is cmpxchg64 in pi_try_set_control from
> arch/x86/kvm/vmx/posted_intr.c, as shown in a RFC patch [1].

I can't read that code, my brain is hard wired to read pi as priority
inheritance/inversion.

Still, does 32bit actually support that stuff?

> There are some more opportunities for try_cmpxchg64 in KVM, namely
> fast_pf_fix_direct_spte in arch/x86/kvm/mmu/mmu.c and
> tdp_mmu_set_spte_atomic in arch/x86/kvm/mmu/tdp_mmu.c

tdp_mmu is definitely 64bit only and as such shouldn't need to use
cmpxchg64.


Anyway, your patch looks about right, but I find it *really* hard to
care about 32bit code these days.
