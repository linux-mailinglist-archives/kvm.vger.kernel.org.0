Return-Path: <kvm+bounces-16352-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B00E8B8D25
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 17:34:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3E57A1C2266A
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 15:33:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 807B01304BF;
	Wed,  1 May 2024 15:31:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hPQU1Znp"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CFB413175A
	for <kvm@vger.kernel.org>; Wed,  1 May 2024 15:31:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714577479; cv=none; b=KvNJSveMcYWXOMv/6U2dSWEYWnLpA8vG78ty27Uq+tIztfTAnZhAV1ZR0b0c4/3qnTBrf5Xk9VBHh0f/+f5/ON9AW2l3tceqroM7Q7rxq7eu6VkX2vBS0EXfI/gmhU/eqJ4quZ6jxFN9jF76EqKMssf54WVKdgFeB8vKDhu3uaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714577479; c=relaxed/simple;
	bh=nPqwrPZ+/7JQNAtaYuTtqWmat2rB97cHWkHnBF5zGOs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sxDdFGx3Lbxo4Tsn9pPThZv6SdXQH/mI2Q+OMGoSo1t9jqx1wd3+fHyR/khOODmkNtCCdn6VsvCZc4cvN8a0WYucqzBVYbHImOpMh9PIeCtXeW901F0pkHXt2jlDr21TOB1HQdeAOspXU8kwsUaF57xa9h6LK/5NlxDa7TW0mVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hPQU1Znp; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714577476;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KNOkWjqGIwO/KbmHEYJOzeUwiZPMbPwwqSHmtTRCUws=;
	b=hPQU1Znp95yV3Ny65rgctdzOdRDV0zgmXHmXn/7q6Q2fZGKwjQJKYSjmJD6Fg4kKMBJ01Y
	kR8XiA/DmmF4u042nUotAchW73Alu1GE5ajoCyeJA9rQADaKWzvI64fjuRCdcDURaM+gzL
	U2eC2yOdQIlHTQNak1MoeB104cdEzuw=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-683-cou44VNuOTmwE8GuNpbuOw-1; Wed, 01 May 2024 11:31:14 -0400
X-MC-Unique: cou44VNuOTmwE8GuNpbuOw-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-a558739aaf4so416198766b.0
        for <kvm@vger.kernel.org>; Wed, 01 May 2024 08:31:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714577473; x=1715182273;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KNOkWjqGIwO/KbmHEYJOzeUwiZPMbPwwqSHmtTRCUws=;
        b=PWxZVGliVtE4ukgeHzw5C7pgADOlMXv1vypxneUHf2EA9lupscJhscsckfFqLLITug
         QWVIrop4aztuHW3fG3bCThQ1rrKQOvZxO+zZASRIGLKtKjaDn4ofdPHDYhGY/ymiugaz
         ntrZpVgpH7MhVQgKejQDyTXfcAp74iuOS9wI3ia+9AQktZImv1DAsDK4R0yX+d1OG6QI
         BqrqzKP2wf9SK7mnHOH3iHckUtHQVrjTodbMnATuhTWiiB5RjJjMSrMQRGxDjWV7qmKi
         tDLkbeCseDsN+eVBmA0+ezTud2GHehrFfXImFqafIfDo+5gqIMJjBUpv/2hm7AU1rtP5
         6qew==
X-Forwarded-Encrypted: i=1; AJvYcCVH3wtJi6DLEyY/Ji5ZN4vLhYHf5aHwjOGji0ULBYMWT5XFnNf483UGxu9HjB0PqkcpsgUArOEz7+LDFlxk4g42bfI2
X-Gm-Message-State: AOJu0Yy02fx1YbJHaniXSe+N95Uz8M3qMgGZxPpGPZjLP1L8gncEFwIm
	ZJlITTurpKoDCccqcC/XigrGOM9ql8psTXg19VvoStvYLg1drogBGjb5zfgrb30TkcYXu6PeAxj
	7Nij3d4GHJWbYJ96glYY5IUhCW1DIz17znnpDQbD4FisS1RwZ8Q==
X-Received: by 2002:a17:906:3542:b0:a58:db18:3cc6 with SMTP id s2-20020a170906354200b00a58db183cc6mr2525434eja.3.1714577472614;
        Wed, 01 May 2024 08:31:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG9fiao1qX+y5da7YTC+zxBAWCMGioTkfjU9P9u+74exVdWQCySFN+4xEcj24VqOnawkjfs5Q==
X-Received: by 2002:a17:906:3542:b0:a58:db18:3cc6 with SMTP id s2-20020a170906354200b00a58db183cc6mr2525399eja.3.1714577471877;
        Wed, 01 May 2024 08:31:11 -0700 (PDT)
Received: from redhat.com ([2a0d:6fc7:346:6a42:bb79:449b:3f0b:a228])
        by smtp.gmail.com with ESMTPSA id bn16-20020a170906c0d000b00a51dcdca6cfsm16398473ejb.71.2024.05.01.08.31.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 May 2024 08:31:08 -0700 (PDT)
Date: Wed, 1 May 2024 11:31:02 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Tobias Huschle <huschle@linux.ibm.com>,
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
Message-ID: <20240501112830-mutt-send-email-mst@kernel.org>
References: <cf813f92-9806-4449-b099-1bb2bd492b3c@arm.com>
 <73123.124031407552500165@us-mta-156.us.mimecast.lan>
 <20240314110649-mutt-send-email-mst@kernel.org>
 <84704.124031504335801509@us-mta-515.us.mimecast.lan>
 <20240315062839-mutt-send-email-mst@kernel.org>
 <b3fd680c675208370fc4560bb3b4d5b8@linux.ibm.com>
 <20240319042829-mutt-send-email-mst@kernel.org>
 <4808eab5fc5c85f12fe7d923de697a78@linux.ibm.com>
 <ZjDM3SsZ3NkZuphP@DESKTOP-2CCOB1S.>
 <20240501105151.GG40213@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240501105151.GG40213@noisy.programming.kicks-ass.net>

On Wed, May 01, 2024 at 12:51:51PM +0200, Peter Zijlstra wrote:
> On Tue, Apr 30, 2024 at 12:50:05PM +0200, Tobias Huschle wrote:
> > It took me a while, but I was able to figure out why EEVDF behaves 
> > different then CFS does. I'm still waiting for some official confirmation
> > of my assumptions but it all seems very plausible to me.
> > 
> > Leaving aside all the specifics of vhost and kworkers, a more general
> > description of the scenario would be as follows:
> > 
> > Assume that we have two tasks taking turns on a single CPU. 
> > Task 1 does something and wakes up Task 2.
> > Task 2 does something and goes to sleep.
> > And we're just repeating that.
> > Task 1 and task 2 only run for very short amounts of time, i.e. much 
> > shorter than a regular time slice (vhost = task1, kworker = task2).
> > 
> > Let's further assume, that task 1 runs longer than task 2. 
> > In CFS, this means, that vruntime of task 1 starts to outrun the vruntime
> > of task 2. This means that vruntime(task2) < vruntime(task1). Hence, task 2
> > always gets picked on wake up because it has the smaller vruntime. 
> > In EEVDF, this would translate to a permanent positive lag, which also 
> > causes task 2 to get consistently scheduled on wake up.
> > 
> > Let's now assume, that ocassionally, task 2 runs a little bit longer than
> > task 1. In CFS, this means, that task 2 can close the vruntime gap by a
> > bit, but, it can easily remain below the value of task 1. Task 2 would 
> > still get picked on wake up.
> > With EEVDF, in its current form, task 2 will now get a negative lag, which
> > in turn, will cause it not being picked on the next wake up.
> 
> Right, so I've been working on changes where tasks will be able to
> 'earn' credit when sleeping. Specifically, keeping dequeued tasks on the
> runqueue will allow them to burn off negative lag. Once they get picked
> again they are guaranteed to have zero (or more) lag. If by that time
> they've not been woken up again, they get dequeued with 0-lag.
> 
> (placement with 0-lag will ensure eligibility doesn't inhibit the pick,
> but is not sufficient to ensure a pick)
> 
> However, this alone will not be sufficient to get the behaviour you
> want. Notably, even at 0-lag the virtual deadline will still be after
> the virtual deadline of the already running task -- assuming they have
> equal request sizes.
> 
> That is, IIUC, you want your task 2 (kworker) to always preempt task 1
> (vhost), right? So even if tsak 2 were to have 0-lag, placing it would
> be something like:
> 
> t1      |---------<    
> t2        |---------<
> V    -----|-----------------------------
> 
> So t1 has started at | with a virtual deadline at <. Then a short
> while later -- V will have advanced a little -- it wakes t2 with 0-lag,
> but as you can observe, its virtual deadline will be later than t1's and
> as such it will never get picked, even though they're both eligible.
> 
> > So, it seems we have a change in the level of how far the both variants look 
> > into the past. CFS being willing to take more history into account, whereas
> > EEVDF does not (with update_entity_lag setting the lag value from scratch, 
> > and place_entity not taking the original vruntime into account).
> >
> > All of this can be seen as correct by design, a task consumes more time
> > than the others, so it has to give way to others. The big difference
> > is now, that CFS allowed a task to collect some bonus by constantly using 
> > less CPU time than others and trading that time against ocassionally taking
> > more CPU time. EEVDF could do the same thing, by allowing the accumulation
> > of positive lag, which can then be traded against the one time the task
> > would get negative lag. This might clash with other EEVDF assumptions though.
> 
> Right, so CFS was a pure virtual runtime based scheduler, while EEVDF
> considers both virtual runtime (for eligibility, which ties to fairness)
> but primarily virtual deadline (for timeliness).
> 
> If you want to make EEVDF force pick a task by modifying vruntime you
> have to place it with lag > request (slice) such that the virtual
> deadline of the newly placed task is before the already running task,
> yielding both eligibility and earliest deadline.
> 
> Consistently placing tasks with such large (positive) lag will affect
> fairness though, they're basically always runnable, so barring external
> throttling, they'll starve you.
> 
> > The patch below fixes the degredation, but is not at all aligned with what 
> > EEVDF wants to achieve, but it helps as an indicator that my hypothesis is
> > correct.
> > 
> > So, what does this now mean for the vhost regression we were discussing?
> > 
> > 1. The behavior of the scheduler changed with regard to wake-up scenarios.
> > 2. vhost in its current form relies on the way how CFS works by assuming 
> >    that the kworker always gets scheduled.
> 
> How does it assume this? Also, this is a performance issue, not a
> correctness issue, right?
> 
> > I would like to argue that it therefore makes sense to reconsider the vhost
> > implementation to make it less dependent on the internals of the scheduler.
> 
> I think I'll propose the opposite :-) Much of the problems we have are
> because the scheduler simply doesn't know anything and we're playing a
> mutual guessing game.
> 
> The trick is finding things to tell the scheduler it can actually do
> something with though..
> 
> > As proposed earlier in this thread, I see two options:
> > 
> > 1. Do an explicit schedule() after every iteration across the vhost queues
> > 2. Set the need_resched flag after writing to the socket that would trigger
> >    eventfd and the underlying kworker
> 
> Neither of these options will get you what you want. Specifically in the
> example above, t1 doing an explicit reschedule will result in t1 being
> picked.
> 
> > Both options would make sure that the vhost gives up the CPU as it cannot
> > continue anyway without the kworker handling the event. Option 1 will give
> > up the CPU regardless of whether something was found in the queues, whereas
> > option 2 would only give up the CPU if there is.
> 
> Incorrect, neither schedule() nor marking things with TIF_NEED_RESCHED
> (which has more issues) will make t2 run. In that scenario you have to
> make t1 block, such that t2 is the only possible choice. As long as you
> keep t1 on the runqueue, it will be the most eligible pick at that time.
> 
> Now, there is an easy option... but I hate to mention it because I've
> spend a lifetime telling people not to use it (for really good reasons):
> yield().
> 
> With EEVDF yield() will move the virtual deadline ahead by one request.
> That is, given the above scenario:
> 
> t1      |---------<    
> t2        |---------<
> V    -----|-----------------------------
> 
> t1 doing yield(), would result in:
> 
> t1      |-------------------<    
> t2        |---------<
> V    -----|-----------------------------
> 
> And at that point, you'll find that all of a sudden t2 will be picked.
> On the flip side, you might find that when t2 completes another task is
> more likely to run than return to t1 -- because of that elongated
> deadline. Ofc. if t1 and t2 are the only tasks on the CPU this doesn't
> matter.
> 
> > It shall be noted, that we encountered similar behavior when running some
> > fio benchmarks. From a brief glance at the code, I was seeing similar
> > intentions: Loop over queues, then trigger an action through some event
> > mechanism. Applying the same patch as mentioned above also fixes this issue.
> > 
> > It could be argued, that this is still something that needs to be somehow
> > addressed by the scheduler since it might affect others as well and there 
> > are in fact patches coming in. Will they address our issue here? Not sure yet.
> 
> > On the other hand, it might just be beneficial to make vhost more resilient
> > towards the scheduler's algorithm by not relying on a certain behavior in
> > the wakeup path.
> 
> So the 'advantage' of EEVDF over CFS is that it has 2 parameters to play
> with: weight and slice. Slice being the new toy in town.
> 
> Specifically in your example you would ideally have task 2 have a
> shorter slice. Except of course its a kworker and you can't very well
> set a kworker with a short slice because you never know wth it will end
> up doing.
> 
> I'm still wondering why exactly it is imperative for t2 to preempt t1.
> Is there some unexpressed serialization / spin-waiting ?


I am not sure but I think the point is that t2 is a kworker. It is
much cheaper to run it right now when we are already in the kernel
than return to userspace, let it run for a bit then interrupt it
and then run t2.
Right, Tobias?

-- 
MST


