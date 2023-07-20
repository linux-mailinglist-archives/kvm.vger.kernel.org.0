Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56E3075A89A
	for <lists+kvm@lfdr.de>; Thu, 20 Jul 2023 10:04:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230403AbjGTIEl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jul 2023 04:04:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbjGTIEk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jul 2023 04:04:40 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3074135;
        Thu, 20 Jul 2023 01:04:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=GYJcNSzzJTwKk+N/xTZNKE50sP/tZ1CZ3Su9PfekZow=; b=qgLwlrg8oj3b3JNg2b1yWsbEPj
        wiOH0516yzh0dor0idZ7d1TOdtWNX6oV4LUfYZgjFVDqhSrFsC9aUU4Z9xo82ETCHw8WRdgZzOUaA
        kfU7/80wZirOKXgAHHtH9QAzIxCRAkMkoHxicQMZRp/GcxIkzdf+NH06BWuFVq96EmB1g5u03XfN5
        Epz0qD47fZKsxWgkqWk1Ns7+FmVYKoJo3iYt9t2leaOpLyVAblL7PE8nT0X4cDRPXGwF/4kb6ywyr
        SUSruf9BxyzaoIExEj2nl8+BBMMLvHuLmKGVsZluXnjW7+1lU2cUe11HiN9oD3PrDWH1P3mC5yKNY
        /dWRlmzA==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qMOdm-00FOe6-0N;
        Thu, 20 Jul 2023 08:04:03 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 2D53930007E;
        Thu, 20 Jul 2023 10:03:58 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 185512B326662; Thu, 20 Jul 2023 10:03:58 +0200 (CEST)
Date:   Thu, 20 Jul 2023 10:03:57 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Weijiang Yang <weijiang.yang@intel.com>, pbonzini@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org, rppt@kernel.org,
        binbin.wu@linux.intel.com, rick.p.edgecombe@intel.com,
        john.allen@amd.com, Chao Gao <chao.gao@intel.com>,
        Andrew Cooper <Andrew.Cooper3@citrix.com>
Subject: Re: [PATCH v3 00/21] Enable CET Virtualization
Message-ID: <20230720080357.GA3569127@hirez.programming.kicks-ass.net>
References: <20230511040857.6094-1-weijiang.yang@intel.com>
 <ZIufL7p/ZvxjXwK5@google.com>
 <147246fc-79a2-3bb5-f51f-93dfc1cffcc0@intel.com>
 <ZIyiWr4sR+MqwmAo@google.com>
 <c438b5b1-b34d-3e77-d374-37053f4c14fa@intel.com>
 <ZJYF7haMNRCbtLIh@google.com>
 <e44a9a1a-0826-dfa7-4bd9-a11e5790d162@intel.com>
 <ZLg8ezG/XrZH+KGD@google.com>
 <20230719203658.GE3529734@hirez.programming.kicks-ass.net>
 <CAM9Jb+hkbUpTNy-jqf8tevKeEsQjhkpBtD5iESSoPsATVfA9tg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM9Jb+hkbUpTNy-jqf8tevKeEsQjhkpBtD5iESSoPsATVfA9tg@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 20, 2023 at 07:26:04AM +0200, Pankaj Gupta wrote:
> > > My understanding is that PL[0-2]_SSP are used only on transitions to the
> > > corresponding privilege level from a *different* privilege level.  That means
> > > KVM should be able to utilize the user_return_msr framework to load the host
> > > values.  Though if Linux ever supports SSS, I'm guessing the core kernel will
> > > have some sort of mechanism to defer loading MSR_IA32_PL0_SSP until an exit to
> > > userspace, e.g. to avoid having to write PL0_SSP, which will presumably be
> > > per-task, on every context switch.
> > >
> > > But note my original wording: **If that's necessary**
> > >
> > > If nothing in the host ever consumes those MSRs, i.e. if SSS is NOT enabled in
> > > IA32_S_CET, then running host stuff with guest values should be ok.  KVM only
> > > needs to guarantee that it doesn't leak values between guests.  But that should
> > > Just Work, e.g. KVM should load the new vCPU's values if SHSTK is exposed to the
> > > guest, and intercept (to inject #GP) if SHSTK is not exposed to the guest.
> > >
> > > And regardless of what the mechanism ends up managing SSP MSRs, it should only
> > > ever touch PL0_SSP, because Linux never runs anything at CPL1 or CPL2, i.e. will
> > > never consume PL{1,2}_SSP.
> >
> > To clarify, Linux will only use SSS in FRED mode -- FRED removes CPL1,2.
> 
> Trying to understand more what prevents SSS to enable in pre FRED, Is
> it better #CP exception
> handling with other nested exceptions?

SSS took the syscall gap and made it worse -- as in *way* worse.

To top it off, the whole SSS busy bit thing is fundamentally
incompatible with how we manage to survive nested exceptions in NMI
context.

Basically, the whole x86 exception / stack switching logic was already
borderline impossible (consider taking an MCE in the early NMI path
where we set up, but have not finished, the re-entrancy stuff), and
pushed it over the edge and set it on fire.

And NMI isn't the only problem, the various new virt exceptions #VC and
#HV are on their own already near impossible, adding SSS again pushes
the whole thing into clear insanity.

There's a good exposition of the whole trainwreck by Andrew here:

  https://www.youtube.com/watch?v=qcORS8CN0ow

(that is, sorry for the youtube link, but Google is failing me in
finding the actual Google Doc that talk is based on, or even the slide
deck :/)



FRED solves all that by:

 - removing the stack gap, cc/ip/ss/sp/ssp/gs will all be switched
   atomically and consistently for every transition.

 - removing the non-reentrant IST mechanism and replacing it with stack
   levels

 - adding an explicit NMI latch

 - re-organising the actual shadow stacks and doing away with that busy
   bit thing (I need to re-read the FRED spec on this detail again).



Crazy as we are, we're not touching legacy/IDT SSS with a ten foot pole,
sorry.
