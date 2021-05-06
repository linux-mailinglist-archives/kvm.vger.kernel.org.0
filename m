Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AAE837558B
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 16:22:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234751AbhEFOXr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 May 2021 10:23:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234721AbhEFOXq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 May 2021 10:23:46 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9804EC061574;
        Thu,  6 May 2021 07:22:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=L7Wckp9ebZm0QWNsvc214TUX7ukxMswtFUJfcKeZEFg=; b=SfWSlpncig8YbvX0yr1ScJII4O
        69V9ZMrQ2D1FemHQkoVhAgvjBRcLzyxCB39gPXRH0N5C4VFCT2XtDYtQFXIA+sD4pasT8kEMS00R6
        pHOQ/GopqFXDuECTVqOJ2aK7z12AXZPXaXhxDuPNOM3Bt6WuUT4SMG2idr6C6rLTmvmyhsbDShmGK
        /Jd1eh4Ewi/Os1OaNQmBktoYVYfTjV3LvUbKvNBTpNNlhy702AwPmyqrLWnwBFqnbNiAYMIJ8kkoC
        xBwo7Geh3RTA2/KN7rpVAAVp63fliiot6hZPE+R1TUnYyIyGsEaep7+CBC7P6wmNOyV36SxwiMh3z
        iFDq8mtA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1leeop-001njw-Hk; Thu, 06 May 2021 14:18:32 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id D7BC93001DB;
        Thu,  6 May 2021 16:17:33 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id B50D720224220; Thu,  6 May 2021 16:17:33 +0200 (CEST)
Date:   Thu, 6 May 2021 16:17:33 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Johannes Weiner <hannes@cmpxchg.org>
Cc:     tglx@linutronix.de, mingo@kernel.org, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
        rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de,
        bristot@redhat.com, bsingharora@gmail.com, pbonzini@redhat.com,
        maz@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        riel@surriel.com
Subject: Re: [PATCH 1/6] delayacct: Use sched_clock()
Message-ID: <YJP6fWhwg95JZ1Kg@hirez.programming.kicks-ass.net>
References: <20210505105940.190490250@infradead.org>
 <20210505111525.001031466@infradead.org>
 <YJP2L1lUvUrur4pK@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YJP2L1lUvUrur4pK@cmpxchg.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 06, 2021 at 09:59:11AM -0400, Johannes Weiner wrote:
> On Wed, May 05, 2021 at 12:59:41PM +0200, Peter Zijlstra wrote:
> > @@ -42,10 +42,9 @@ void __delayacct_tsk_init(struct task_st
> >   * Finish delay accounting for a statistic using its timestamps (@start),
> >   * accumalator (@total) and @count
> >   */
> > -static void delayacct_end(raw_spinlock_t *lock, u64 *start, u64 *total,
> > -			  u32 *count)
> > +static void delayacct_end(raw_spinlock_t *lock, u64 *start, u64 *total, u32 *count)
> >  {
> > -	s64 ns = ktime_get_ns() - *start;
> > +	s64 ns = local_clock() - *start;
> 
> I don't think this is safe. These time sections that have preemption
> and migration enabled and so might span multiple CPUs. local_clock()
> could end up behind *start, AFAICS.

Only if you have really crummy hardware, and in that case the drift is
bounded by around 1 tick. Also, this function actually checks: ns > 0.

And if you do have crummy hardware like that, ktime_get_ns() is the very
last thing you want to call at any frequency because it'll be the HPET.
