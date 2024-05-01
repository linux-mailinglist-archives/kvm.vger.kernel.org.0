Return-Path: <kvm+bounces-16329-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D4A98B88CF
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 12:52:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 54DC4B2168A
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 10:52:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DA9056B68;
	Wed,  1 May 2024 10:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="IAUqktMw"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B89B53F8D1;
	Wed,  1 May 2024 10:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714560722; cv=none; b=lCubaKELX7rTT//SbCfVYkC9ESKIFLCy2OzXm5bFLJqHDXaEiqXLiAUkkZf9T7d4MIMt4bfOEle9leUFazJaK9kTI/LzKr5eJNjVdwiRliPy0OogmSGPs5UIiInjHlaVKQ7kCEiO8RMjDrl5ujYsZoxqBDUhPsDAsHUXMFsifRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714560722; c=relaxed/simple;
	bh=H9WqSZOqtRfzy4RtuozjQWiXJCn9SisEFqmEAatQ/gc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VWcXG6oMOrBAxznE/qv+Uep/oiac0NxlB/Ml5KPZSxzkxJtBXoEnr/X3wl7nl9a2zMlnj/BPiuGcx5EChUgriEPCuucxwEPvjPflGO4q1xlwX9DFGEf/B10umcOJ84GXDWdJ/bWmKIzGb937AnwyprCPZkTIvCVaswsnmKgKt1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=IAUqktMw; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=39xyfPxcNlhzacIDUm5Fs67pXqssMxpzb5P1AtXdGo8=; b=IAUqktMwmBHKZOdlYNZEwT8FaI
	c1p7iZYrLw5llHtfw4tXWiv/LgJujZPwq9s4LO6XRwU/9eI3HDcsoorrlR5nq70wA/nvxhKUdKX3I
	zor453KPTHP0nDTgl0sQ4+ws8acW02qLUJQ/kWDt8/TjgNlpPCv8ta+oJh4rRlek6KwrLZ8oguOh2
	9uEfILrX+8PaaIXN9miMNQivKl+QE+6qXFvRsdbWWmg+BwFzIj9gzUnAkgZX7TgyY5hyXV1K8BpeC
	G8adPmYoCUBEuPkxle8OjQegx9f+xVVC5G9E6JeugPTEr0ljci/DUme/wcwBFAdfjMHyq7YDcVXUA
	qwPNIBEQ==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s27Z1-0000000HM0F-44xc;
	Wed, 01 May 2024 10:51:52 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id A21E1300362; Wed,  1 May 2024 12:51:51 +0200 (CEST)
Date: Wed, 1 May 2024 12:51:51 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Tobias Huschle <huschle@linux.ibm.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
	Luis Machado <luis.machado@arm.com>,
	Jason Wang <jasowang@redhat.com>,
	Abel Wu <wuyun.abel@bytedance.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
	virtualization@lists.linux.dev, netdev@vger.kernel.org,
	nd <nd@arm.com>, borntraeger@linux.ibm.com,
	Ingo Molnar <mingo@kernel.org>,
	Mike Galbraith <umgwanakikbuti@gmail.com>
Subject: Re: EEVDF/vhost regression (bisected to 86bfbb7ce4f6 sched/fair: Add
 lag based placement)
Message-ID: <20240501105151.GG40213@noisy.programming.kicks-ass.net>
References: <20240311130446-mutt-send-email-mst@kernel.org>
 <cf813f92-9806-4449-b099-1bb2bd492b3c@arm.com>
 <73123.124031407552500165@us-mta-156.us.mimecast.lan>
 <20240314110649-mutt-send-email-mst@kernel.org>
 <84704.124031504335801509@us-mta-515.us.mimecast.lan>
 <20240315062839-mutt-send-email-mst@kernel.org>
 <b3fd680c675208370fc4560bb3b4d5b8@linux.ibm.com>
 <20240319042829-mutt-send-email-mst@kernel.org>
 <4808eab5fc5c85f12fe7d923de697a78@linux.ibm.com>
 <ZjDM3SsZ3NkZuphP@DESKTOP-2CCOB1S.>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZjDM3SsZ3NkZuphP@DESKTOP-2CCOB1S.>

On Tue, Apr 30, 2024 at 12:50:05PM +0200, Tobias Huschle wrote:
> It took me a while, but I was able to figure out why EEVDF behaves 
> different then CFS does. I'm still waiting for some official confirmation
> of my assumptions but it all seems very plausible to me.
> 
> Leaving aside all the specifics of vhost and kworkers, a more general
> description of the scenario would be as follows:
> 
> Assume that we have two tasks taking turns on a single CPU. 
> Task 1 does something and wakes up Task 2.
> Task 2 does something and goes to sleep.
> And we're just repeating that.
> Task 1 and task 2 only run for very short amounts of time, i.e. much 
> shorter than a regular time slice (vhost = task1, kworker = task2).
> 
> Let's further assume, that task 1 runs longer than task 2. 
> In CFS, this means, that vruntime of task 1 starts to outrun the vruntime
> of task 2. This means that vruntime(task2) < vruntime(task1). Hence, task 2
> always gets picked on wake up because it has the smaller vruntime. 
> In EEVDF, this would translate to a permanent positive lag, which also 
> causes task 2 to get consistently scheduled on wake up.
> 
> Let's now assume, that ocassionally, task 2 runs a little bit longer than
> task 1. In CFS, this means, that task 2 can close the vruntime gap by a
> bit, but, it can easily remain below the value of task 1. Task 2 would 
> still get picked on wake up.
> With EEVDF, in its current form, task 2 will now get a negative lag, which
> in turn, will cause it not being picked on the next wake up.

Right, so I've been working on changes where tasks will be able to
'earn' credit when sleeping. Specifically, keeping dequeued tasks on the
runqueue will allow them to burn off negative lag. Once they get picked
again they are guaranteed to have zero (or more) lag. If by that time
they've not been woken up again, they get dequeued with 0-lag.

(placement with 0-lag will ensure eligibility doesn't inhibit the pick,
but is not sufficient to ensure a pick)

However, this alone will not be sufficient to get the behaviour you
want. Notably, even at 0-lag the virtual deadline will still be after
the virtual deadline of the already running task -- assuming they have
equal request sizes.

That is, IIUC, you want your task 2 (kworker) to always preempt task 1
(vhost), right? So even if tsak 2 were to have 0-lag, placing it would
be something like:

t1      |---------<    
t2        |---------<
V    -----|-----------------------------

So t1 has started at | with a virtual deadline at <. Then a short
while later -- V will have advanced a little -- it wakes t2 with 0-lag,
but as you can observe, its virtual deadline will be later than t1's and
as such it will never get picked, even though they're both eligible.

> So, it seems we have a change in the level of how far the both variants look 
> into the past. CFS being willing to take more history into account, whereas
> EEVDF does not (with update_entity_lag setting the lag value from scratch, 
> and place_entity not taking the original vruntime into account).
>
> All of this can be seen as correct by design, a task consumes more time
> than the others, so it has to give way to others. The big difference
> is now, that CFS allowed a task to collect some bonus by constantly using 
> less CPU time than others and trading that time against ocassionally taking
> more CPU time. EEVDF could do the same thing, by allowing the accumulation
> of positive lag, which can then be traded against the one time the task
> would get negative lag. This might clash with other EEVDF assumptions though.

Right, so CFS was a pure virtual runtime based scheduler, while EEVDF
considers both virtual runtime (for eligibility, which ties to fairness)
but primarily virtual deadline (for timeliness).

If you want to make EEVDF force pick a task by modifying vruntime you
have to place it with lag > request (slice) such that the virtual
deadline of the newly placed task is before the already running task,
yielding both eligibility and earliest deadline.

Consistently placing tasks with such large (positive) lag will affect
fairness though, they're basically always runnable, so barring external
throttling, they'll starve you.

> The patch below fixes the degredation, but is not at all aligned with what 
> EEVDF wants to achieve, but it helps as an indicator that my hypothesis is
> correct.
> 
> So, what does this now mean for the vhost regression we were discussing?
> 
> 1. The behavior of the scheduler changed with regard to wake-up scenarios.
> 2. vhost in its current form relies on the way how CFS works by assuming 
>    that the kworker always gets scheduled.

How does it assume this? Also, this is a performance issue, not a
correctness issue, right?

> I would like to argue that it therefore makes sense to reconsider the vhost
> implementation to make it less dependent on the internals of the scheduler.

I think I'll propose the opposite :-) Much of the problems we have are
because the scheduler simply doesn't know anything and we're playing a
mutual guessing game.

The trick is finding things to tell the scheduler it can actually do
something with though..

> As proposed earlier in this thread, I see two options:
> 
> 1. Do an explicit schedule() after every iteration across the vhost queues
> 2. Set the need_resched flag after writing to the socket that would trigger
>    eventfd and the underlying kworker

Neither of these options will get you what you want. Specifically in the
example above, t1 doing an explicit reschedule will result in t1 being
picked.

> Both options would make sure that the vhost gives up the CPU as it cannot
> continue anyway without the kworker handling the event. Option 1 will give
> up the CPU regardless of whether something was found in the queues, whereas
> option 2 would only give up the CPU if there is.

Incorrect, neither schedule() nor marking things with TIF_NEED_RESCHED
(which has more issues) will make t2 run. In that scenario you have to
make t1 block, such that t2 is the only possible choice. As long as you
keep t1 on the runqueue, it will be the most eligible pick at that time.

Now, there is an easy option... but I hate to mention it because I've
spend a lifetime telling people not to use it (for really good reasons):
yield().

With EEVDF yield() will move the virtual deadline ahead by one request.
That is, given the above scenario:

t1      |---------<    
t2        |---------<
V    -----|-----------------------------

t1 doing yield(), would result in:

t1      |-------------------<    
t2        |---------<
V    -----|-----------------------------

And at that point, you'll find that all of a sudden t2 will be picked.
On the flip side, you might find that when t2 completes another task is
more likely to run than return to t1 -- because of that elongated
deadline. Ofc. if t1 and t2 are the only tasks on the CPU this doesn't
matter.

> It shall be noted, that we encountered similar behavior when running some
> fio benchmarks. From a brief glance at the code, I was seeing similar
> intentions: Loop over queues, then trigger an action through some event
> mechanism. Applying the same patch as mentioned above also fixes this issue.
> 
> It could be argued, that this is still something that needs to be somehow
> addressed by the scheduler since it might affect others as well and there 
> are in fact patches coming in. Will they address our issue here? Not sure yet.

> On the other hand, it might just be beneficial to make vhost more resilient
> towards the scheduler's algorithm by not relying on a certain behavior in
> the wakeup path.

So the 'advantage' of EEVDF over CFS is that it has 2 parameters to play
with: weight and slice. Slice being the new toy in town.

Specifically in your example you would ideally have task 2 have a
shorter slice. Except of course its a kworker and you can't very well
set a kworker with a short slice because you never know wth it will end
up doing.

I'm still wondering why exactly it is imperative for t2 to preempt t1.
Is there some unexpressed serialization / spin-waiting ?


