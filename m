Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 140EF36D788
	for <lists+kvm@lfdr.de>; Wed, 28 Apr 2021 14:40:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239291AbhD1Mks (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Apr 2021 08:40:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235630AbhD1Mkr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Apr 2021 08:40:47 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BD0FC061574;
        Wed, 28 Apr 2021 05:40:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=m5f/iRhfUWRkjMhQisf/mthD9AMA77TGY3RTn6mcx6Q=; b=Lkqx31gsizhW9o7BpLZsPLAQ6X
        InmIbkX46YfnQ/lGXXrBca7I7FvxudUMTFr+zICtQzQWdAR++bqAOtaPNtbaLtEcUxJxhXK96B7nG
        wdCLH/PiJFmNuGWc3NjbHC0ezqo5YRu6o3/hkhUZmMrx+fVlA0b09ziwebO3mJ6ltfSp8/4DA/T1B
        R76XZCqFJpc2DCxIs4QDwsuwZstPMQHGElGUwkgrJfEquzBC82cmh2n0TMopIsBsJMphtb6jQ7TsD
        fAz0D6gSwCmInABLAIdKPl8owBaENkX4QSRAhwV4lUm/yjsT/A3EArSFC+A21eTDHweZio6odjPIz
        xvjHNqbw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lbjSX-008Hl6-Kr; Wed, 28 Apr 2021 12:38:49 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 1D408300091;
        Wed, 28 Apr 2021 14:38:28 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id F09762CE52E40; Wed, 28 Apr 2021 14:38:27 +0200 (CEST)
Date:   Wed, 28 Apr 2021 14:38:27 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     bristot@redhat.com, bsegall@google.com, dietmar.eggemann@arm.com,
        greg@kroah.com, gregkh@linuxfoundation.org, joshdon@google.com,
        juri.lelli@redhat.com, linux-kernel@vger.kernel.org,
        linux@rasmusvillemoes.dk, mgorman@suse.de, mingo@kernel.org,
        rostedt@goodmis.org, valentin.schneider@arm.com,
        vincent.guittot@linaro.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: sched: Move SCHED_DEBUG sysctl to debugfs
Message-ID: <YIlXQ43b6+7sUl+f@hirez.programming.kicks-ass.net>
References: <20210412102001.287610138@infradead.org>
 <20210427145925.5246-1-borntraeger@de.ibm.com>
 <YIkgzUWEPaXQTCOv@hirez.programming.kicks-ass.net>
 <da373590-f0d7-e3a2-cef9-4527fc9f3056@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <da373590-f0d7-e3a2-cef9-4527fc9f3056@de.ibm.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 28, 2021 at 11:42:57AM +0200, Christian Borntraeger wrote:
> On 28.04.21 10:46, Peter Zijlstra wrote:
> [..]
> > The right thing to do here is to analyze the situation and determine why
> > migration_cost needs changing; is that an architectural thing, does s390
> > benefit from less sticky tasks due to its cache setup (the book caches
> > could be absorbing some of the penalties here for example). Or is it
> > something that's workload related, does KVM intrinsically not care about
> > migrating so much, or is it something else.
> 
> So lets focus on the performance issue.
> 
> One workload where we have seen this is transactional workload that is
> triggered by external network requests. So every external request
> triggered a wakup of a guest and a wakeup of a process in the guest.
> The end result was that KVM was 40% slower than z/VM (in terms of
> transactions per second) while we had more idle time.
> With smaller sched_migration_cost_ns (e.g. 100000) KVM was as fast
> as z/VM.
> 
> So to me it looks like that the wakeup and reschedule to a free CPU
> was just not fast enough. It might also depend where I/O interrupts
> land. Not sure yet.

So there's unfortunately three places where migration_cost is used; one
is in {nohz_,}newidle_balance(), see below. Someone tried removing it
before and that ran into so weird regressions somewhere. But it is worth
checking if this is the thing that matters for your workload.

The other (main) use is in task_hot(), where we try and prevent
migrating tasks that have recently run on a CPU. We already have an
exception for SMT there, because SMT siblings share all cache levels per
defintion, so moving it to the sibling should have no ill effect.

It could be that the current measure is fundamentally too high for your
machine -- it is basically a random number that was determined many
years ago on some random x86 machine, so it not reflecting reality today
on an entirely different platform is no surprise.

Back in the day, we had some magic code that measured cache latency per
sched_domain and we used that, but that suffered from boot-to-boot
variance and made things rather non-deterministic, but the idea of
having per-domain cost certainly makes sense.

Over the years people have tried bringing parts of that back, but it
never really had convincing numbers justifying the complexity. So that's
another thing you could be looking at I suppose.

And then finally we have an almost random use in rebalance_domains(),
and I can't remember the story behind that one :/


Anyway, TL;DR, try and figure out which of these three is responsible
for your performance woes. If it's the first, the below patch might be a
good candidate. If it's task_hot(), we might need to re-eval per domain
costs. If its that other thing, I'll have to dig to figure out wth that
was supposed to accomplish ;-)

---

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 3bdc41f22909..9189bd78ad8f 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -10557,10 +10557,6 @@ static void nohz_newidle_balance(struct rq *this_rq)
 	if (!housekeeping_cpu(this_cpu, HK_FLAG_SCHED))
 		return;
 
-	/* Will wake up very soon. No time for doing anything else*/
-	if (this_rq->avg_idle < sysctl_sched_migration_cost)
-		return;
-
 	/* Don't need to update blocked load of idle CPUs*/
 	if (!READ_ONCE(nohz.has_blocked) ||
 	    time_before(jiffies, READ_ONCE(nohz.next_blocked)))
@@ -10622,8 +10618,7 @@ static int newidle_balance(struct rq *this_rq, struct rq_flags *rf)
 	 */
 	rq_unpin_lock(this_rq, rf);
 
-	if (this_rq->avg_idle < sysctl_sched_migration_cost ||
-	    !READ_ONCE(this_rq->rd->overload)) {
+	if (!READ_ONCE(this_rq->rd->overload)) {
 
 		rcu_read_lock();
 		sd = rcu_dereference_check_sched_domain(this_rq->sd);

