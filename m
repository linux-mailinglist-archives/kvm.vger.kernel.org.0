Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C415F37515A
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 11:16:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234033AbhEFJRz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 May 2021 05:17:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231815AbhEFJRz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 May 2021 05:17:55 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83C49C061574;
        Thu,  6 May 2021 02:16:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=hDlhIpbeqoCuO5RsCW5NsbO4jPToGyvU3+tnRRJpx4c=; b=iYuUkaMe+/U1GiNT1IvXMm1Ghs
        ClsV1L3x+mn8IeGIMWAI6+/uU63Vae7mcNy9L7RXxx1w+Eu8p75msl4QVc7Pdf0cnY0LnCAx+3MnN
        1zQbiQTVyYk32bsO3nfxmLzMuE6/WibB/lvXr3m5OmQWUXokK9gO0+v0JViftpRWo9lnWP9w7IzcM
        WqQ43Nru5hOMTrd22q6xIs80jwkt241Ac0zrYfMxSrF97YLKZephHtCpfaA6kNuMIluUULlz7gaZY
        RawR5gJ8n2qAwozVzbo0Ya/S5s4HJcblYyZx3a4gWAxAg2uIPTzWtezuDe4wFk+esyl7tElDIPm3y
        hbqpuM+w==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lea4x-001Woe-Jg; Thu, 06 May 2021 09:14:25 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 1921E30030F;
        Thu,  6 May 2021 11:13:52 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id C6C342018C406; Thu,  6 May 2021 11:13:52 +0200 (CEST)
Date:   Thu, 6 May 2021 11:13:52 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Balbir Singh <bsingharora@gmail.com>
Cc:     tglx@linutronix.de, mingo@kernel.org, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
        rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de,
        bristot@redhat.com, pbonzini@redhat.com, maz@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        riel@surriel.com, hannes@cmpxchg.org
Subject: Re: [PATCH 0/6] sched,delayacct: Some cleanups
Message-ID: <YJOzUAg30LZWSHcI@hirez.programming.kicks-ass.net>
References: <20210505105940.190490250@infradead.org>
 <20210505222940.GA4236@balbir-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210505222940.GA4236@balbir-desktop>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 06, 2021 at 08:29:40AM +1000, Balbir Singh wrote:
> On Wed, May 05, 2021 at 12:59:40PM +0200, Peter Zijlstra wrote:
> > Hi,
> > 
> > Due to:
> > 
> >   https://lkml.kernel.org/r/0000000000001d43ac05c0f5c6a0@google.com
> > 
> > and general principle, delayacct really shouldn't be using ktime (pvclock also
> > really shouldn't be doing what it does, but that's another story). This lead me
> > to looking at the SCHED_INFO, SCHEDSTATS, DELAYACCT (and PSI) accounting hell.
> > 
> > The rest of the patches are an attempt at simplifying all that a little. All
> > that crud is enabled by default for distros which is leading to a death by a
> > thousand cuts.
> > 
> > The last patch is an attempt at default disabling DELAYACCT, because I don't
> > think anybody actually uses that much, but what do I know, there were no ill
> > effects on my testbox. Perhaps we should mirror
> > /proc/sys/kernel/sched_schedstats and provide a delayacct sysctl for runtime
> > frobbing.
> >
> 
> There are tools like iotop that use delayacct to display information. 

Right, but how many actual people use that? Does that justify saddling
the whole sodding world with the overhead?

> When the
> code was checked in, we did run SPEC* back in the day 2006 to find overheads,
> nothing significant showed. Do we have any date on the overhead your seeing?

I've not looked, but having it disabled saves that per-task allocation
and that spinlock in delayacct_end() for iowait wakeups and a bunch of
cache misses ofcourse.

I doubt SPEC is a benchmark that tickles those paths much if at all.

The thing is; we can't just keep growing more and more stats, that'll
kill us quite dead.
