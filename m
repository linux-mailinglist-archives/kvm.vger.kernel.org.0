Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 729096268AD
	for <lists+kvm@lfdr.de>; Sat, 12 Nov 2022 10:48:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234731AbiKLJsk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 12 Nov 2022 04:48:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230170AbiKLJsi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 12 Nov 2022 04:48:38 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EF06E031;
        Sat, 12 Nov 2022 01:48:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=aKOTb8X0RrZ73pUTzPb8AcL3BXawV6mvmfnTQpI/3cI=; b=dubaVRnZ1fySNyJ6m8N5GztbWz
        brhbwhhQFUPXnTZNKyvfvrOk6LEfmvw+2aCqUpKdcsGwClLE+fnxPRFCGTjXiKHP1hMrx94w/Itzd
        FJErYxzxXhyXZvS7RUDQ2KMtbnW961omQAHIKiV4odkVb6gDougTsAInCHk2dyIPgf5M3CZqrbLUZ
        Z9+MSYQajkyJdP1n8EMnQuRCR/N6vw6feW0CQU3meVWIr5ipVPeV04GOEQdJlKi2ETRZu9cASIR8g
        PX60poQ5D5m5+/pltlYpHSBVdICLbfSwDdIYkJcaLRMv/kKz5j3Yoo9zLZJXXEOOAW2gSWeYwOUL3
        VCH/yXwQ==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1otn7I-000FpZ-HW; Sat, 12 Nov 2022 09:48:02 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 9413730013F;
        Sat, 12 Nov 2022 10:47:58 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 4A6AA20831B7F; Sat, 12 Nov 2022 10:47:58 +0100 (CET)
Date:   Sat, 12 Nov 2022 10:47:58 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     "H. Peter Anvin" <hpa@zytor.com>
Cc:     "Li, Xin3" <xin3.li@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
Subject: Re: [RESEND PATCH 2/6] x86/traps: add a system interrupt table for
 system interrupt dispatch
Message-ID: <Y29rzovA90RWZjo1@hirez.programming.kicks-ass.net>
References: <20221110061545.1531-1-xin3.li@intel.com>
 <20221110061545.1531-3-xin3.li@intel.com>
 <Y2y8obdYDXo9vlH/@hirez.programming.kicks-ass.net>
 <BN6PR1101MB21619E2092AFF048422C6311A8019@BN6PR1101MB2161.namprd11.prod.outlook.com>
 <EA13BAB1-FD67-4145-9325-5705FEE6915A@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <EA13BAB1-FD67-4145-9325-5705FEE6915A@zytor.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 11, 2022 at 02:07:05PM -0800, H. Peter Anvin wrote:
> On November 10, 2022 11:55:22 AM PST, "Li, Xin3" <xin3.li@intel.com> wrote:
> >> > Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
> >> > Signed-off-by: Xin Li <xin3.li@intel.com>
> >> 
> >> This is not a valid SOB, it would suggest hpa is the author, but he's not in in
> >> From.
> >
> >HPA wrote the initial dispatch code for FRED, and I worked with him to
> >refactor it for KVM/VMX NMI/IRQ dispatch.  So use SOB from both.  No?
> >
> >> > diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c index
> >> > 178015a820f0..95dd917ef9ad 100644
> >> > --- a/arch/x86/kernel/traps.c
> >> > +++ b/arch/x86/kernel/traps.c
> >> > @@ -1444,6 +1444,61 @@ DEFINE_IDTENTRY_SW(iret_error)  }  #endif
> >> >
> >> > +#define SYSV(x,y) [(x) - FIRST_SYSTEM_VECTOR] =
> >> > +(system_interrupt_handler)y
> >> > +
> >> > +#pragma GCC diagnostic push
> >> > +#pragma GCC diagnostic ignored "-Wcast-function-type"
> >> 
> >> How does this not break CFI ?
> >
> >I wasn't aware of it, will check.
> >
> 
> It doesn't break CFI because the arguments passed is always a strict
> superset of the ones expected and they are free enough that they are
> always passed in registers.

It does break CFI because the signature hash doesn't match and you'll
trigger an explicit UD2.
