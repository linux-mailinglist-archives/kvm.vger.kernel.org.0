Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15FA92DBCD4
	for <lists+kvm@lfdr.de>; Wed, 16 Dec 2020 09:43:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726420AbgLPIm6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Dec 2020 03:42:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726414AbgLPIm6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Dec 2020 03:42:58 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9A75C0613D6;
        Wed, 16 Dec 2020 00:42:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=0Vl8v+K48CQ1CpDPZyiLdlZ3QZd1xhq2vGyfDmO1QSk=; b=d0ukNEGopW7xSAvf4l6oxB/hVo
        FRyEdkJ6gVh6WhW3HqIsdfeYXWYQ1HLOyEXl/M8OOjMOALFor8DXrwW8OkhssqBZWj2qY+dOjn3WQ
        w+eOTFIjqNLK3/OUKiTAiR7DfaZ2tzpDvvAr4qqHg7G/gm2EllebQ0U87v/0G0msGEUvStoO64DY+
        jRApct0VEjBdukFFaWwT/w5fpgGG2r/xGFbqZ+y+RR+1foywG9EkTHpqpIVFJmYZHyDNnwWxdOg8q
        B4pWQSqNEGAgqHIW+S7+CgCiPXoMiutaQwIno90DVH6FICQhR2vzciTHwxWeaxxT1doUmhnq8aMrv
        PjYDhOMw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kpSMu-0005UY-Qg; Wed, 16 Dec 2020 08:41:09 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id AB87E307697;
        Wed, 16 Dec 2020 09:40:59 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 967842CADD880; Wed, 16 Dec 2020 09:40:59 +0100 (CET)
Date:   Wed, 16 Dec 2020 09:40:59 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     =?iso-8859-1?Q?J=FCrgen_Gro=DF?= <jgross@suse.com>,
        xen-devel@lists.xenproject.org, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-hyperv@vger.kernel.org, kvm@vger.kernel.org, luto@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Deep Shah <sdeep@vmware.com>,
        "VMware, Inc." <pv-drivers@vmware.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>
Subject: Re: [PATCH v2 00/12] x86: major paravirt cleanup
Message-ID: <20201216084059.GL3040@hirez.programming.kicks-ass.net>
References: <20201120114630.13552-1-jgross@suse.com>
 <20201120125342.GC3040@hirez.programming.kicks-ass.net>
 <20201123134317.GE3092@hirez.programming.kicks-ass.net>
 <6771a12c-051d-1655-fb3a-cc45a3c82e29@suse.com>
 <20201215141834.GG3040@hirez.programming.kicks-ass.net>
 <20201215145408.GR3092@hirez.programming.kicks-ass.net>
 <20201216003802.5fpklvx37yuiufrt@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201216003802.5fpklvx37yuiufrt@treble>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 15, 2020 at 06:38:02PM -0600, Josh Poimboeuf wrote:
> On Tue, Dec 15, 2020 at 03:54:08PM +0100, Peter Zijlstra wrote:
> > The problem is that a single instance of unwind information (ORC) must
> > capture and correctly unwind all alternatives. Since the trivially
> > correct mandate is out, implement the straight forward brute-force
> > approach:
> > 
> >  1) generate CFI information for each alternative
> > 
> >  2) unwind every alternative with the merge-sort of the previously
> >     generated CFI information -- O(n^2)
> > 
> >  3) for any possible conflict: yell.
> > 
> >  4) Generate ORC with merge-sort
> > 
> > Specifically for 3 there are two possible classes of conflicts:
> > 
> >  - the merge-sort itself could find conflicting CFI for the same
> >    offset.
> > 
> >  - the unwind can fail with the merged CFI.
> 
> So much algorithm.

:-)

It's not really hard, but it has a few pesky details (as always).

> Could we make it easier by caching the shared
> per-alt-group CFI state somewhere along the way?

Yes, but when I tried it grew the code required. Runtime costs would be
less, but I figured that since alternatives are typically few and small,
that wasn't a real consideration.

That is, it would basically cache the results of find_alt_unwind(), but
you still need find_alt_unwind() to generate that data, and so you gain
the code for filling and using the extra data structure.

Yes, computing it 3 times is naf, but meh.

> [ 'offset' is a byte offset from the beginning of the group.  It could
>   be calculated based on 'orig_insn' or 'orig_insn->alts', depending on
>   whether 'insn' is an original or a replacement. ]

That's exactly what it already does ofcourse ;-)

> If the array entry is NULL, just update it with a pointer to the CFI.
> If it's not NULL, make sure it matches the existing CFI, and WARN if it
> doesn't.
> 
> Also, with this data structure, the ORC generation should also be a lot
> more straightforward, just ignore the NULL entries.

Yeah, I suppose it gets rid of the memcmp-prev thing.

> Thoughts?  This is all theoretical of course, I could try to do a patch
> tomorrow.

No real objection, I just didn't do it because 1) it works, and 2) even
moar lines.
