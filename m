Return-Path: <kvm+bounces-16412-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C3358B9AA3
	for <lists+kvm@lfdr.de>; Thu,  2 May 2024 14:21:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 984C61F23778
	for <lists+kvm@lfdr.de>; Thu,  2 May 2024 12:21:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CFCE7D408;
	Thu,  2 May 2024 12:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="BOHEXwog"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F95CD26A;
	Thu,  2 May 2024 12:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714652459; cv=none; b=ly/tYmOoa0oYH+oFsRyHKvONNoQ5BRc14oWNnhb/2i4qIYCFLKTg2nw+Xntys2MsroSbOVB407eyfHgoElwDRCwvEInJpVbLIYXgl9rXiqmEjIs3Jjmvz7D7lQfNhCdFIezX3nz1xV9DhsUk/n5fEwRRVtDlJxTZIceroGHC+YQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714652459; c=relaxed/simple;
	bh=caLWVw04WK/JE26bBYnuJz21yJ840Pmi22WQGNs/7xk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=SaPPbI3NYV16ja9YXtqE4py9yf4k30h2B9XaNgYa2LcjeN2TcSMkot6ohZrxkXsWAKh/glWnQNmBi1MvB2/fx4bl2ScVyAIdxkiMSyI5IHyRAmAXBAvaWqhSE1ptZfjYFFYwIESUUgug4AKcI+jPyRCXodlhIF+jbFw/AOvbp2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=BOHEXwog; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 442C3JZW032581;
	Thu, 2 May 2024 12:20:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=pp1; bh=Wo3GS11pbbmlNLoZSjznIa+Hpvyvrhk+tFLJDOiqAuM=;
 b=BOHEXwogDwQovUUQ9Sa//oh7G3jSuQphLWj1Cpv+xRUq0wZvpvNONTi2hJ/3cHEmXime
 afeNEv0hljtp5vNk3mnCEI1q/RJntGDzvnaN89N0nfCmgW3ApZNUVbuEaJEbNgaomSfz
 N/YTUkv9QOMGw3n5TgwKhfmYCd0xH/47N/lhsa1seqyxggE3l+X2A19vFE40ehDC4BFt
 wqrP+qtaa3w7v7zwhU5Yx+jojWJPCSxfiTZAsxmgtF0CPba6Pyf2zIQuqh/dS/fP2AFY
 BKzacHzbNvTYIbL003DlCh3+DMHP76fKdbtVWrtcs8wVtshGseqXRxoszmOefrq2VM0p nA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xvagb81gs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 02 May 2024 12:20:27 +0000
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 442CKQTC025837;
	Thu, 2 May 2024 12:20:26 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xvagb81gp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 02 May 2024 12:20:26 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 442AxwEC027546;
	Thu, 2 May 2024 12:20:26 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3xsc30r22v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 02 May 2024 12:20:26 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 442CKKSh57278854
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 2 May 2024 12:20:22 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6E21B2004E;
	Thu,  2 May 2024 12:20:20 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2DC902004B;
	Thu,  2 May 2024 12:20:20 +0000 (GMT)
Received: from DESKTOP-2CCOB1S. (unknown [9.171.162.63])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu,  2 May 2024 12:20:20 +0000 (GMT)
Date: Thu, 2 May 2024 14:20:19 +0200
From: Tobias Huschle <huschle@linux.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Luis Machado <luis.machado@arm.com>,
        Jason Wang <jasowang@redhat.com>, Abel Wu <wuyun.abel@bytedance.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        virtualization@lists.linux.dev, netdev@vger.kernel.org,
        nd <nd@arm.com>, borntraeger@linux.ibm.com,
        Ingo Molnar <mingo@kernel.org>,
        Mike Galbraith <umgwanakikbuti@gmail.com>
Subject: Re: EEVDF/vhost regression (bisected to 86bfbb7ce4f6 sched/fair: Add
 lag based placement)
Message-ID: <ZjOFA8TdyM7OYjWb@DESKTOP-2CCOB1S.>
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
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240501105151.GG40213@noisy.programming.kicks-ass.net>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: qTXMKVePHO5cXzBnzK2DJDbDAJMUha_l
X-Proofpoint-ORIG-GUID: Sv6HeXPs2DFI-nKMGaDHEjlL5hwTn4rD
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-02_01,2024-05-02_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 adultscore=0
 priorityscore=1501 lowpriorityscore=0 mlxscore=0 phishscore=0 spamscore=0
 suspectscore=0 bulkscore=0 impostorscore=0 clxscore=1011 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2404010000
 definitions=main-2405020078

On Wed, May 01, 2024 at 12:51:51PM +0200, Peter Zijlstra wrote:
> On Tue, Apr 30, 2024 at 12:50:05PM +0200, Tobias Huschle wrote:
<...>
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

Exactly, the kworker should be picked. I experimented with that a bit as
well and forced all tasks to have 0-lag on wake-up but got the results
you are mentioning here. Only if I would give the kworker (in general all
woken up tasks) a lag >0, with 1 being already sufficient, the kworker 
would be picked consistently.

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

I was concerned about that as well. Tampering with the lag value will help
in this particular scenario but might cause problems with others.

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

vhost runs a while(true) loop to go over its queues. After each iteration it 
runs cond_resched to give other tasks a chance to run. So, it will never be
pre-empted by the kworker, since the kworker has no handle to do so since vhost
is running in kernel space. This means, that the wake up path is the only
chance for the kworker to get selected.

So that assumption is of a very implicit nature.

In fact, vhost will run forever until migration hits due do an issue that I 
assume in the cgroup context. See here:
https://lore.kernel.org/all/20240228161023.14310-1-huschle@linux.ibm.com/
Fixing this issue still lets the vhost consume its full time slice which 
still causes significant performance degredation though.

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

I appreciate to hear that adjusting the scheduler might be an option here.
Nevertheless, the implicit assumption mentioned above seems something to keep
an eye on to me.

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

In this particular scenario it actually helped. I had two patches for both
variants and they eliminated the degredation. Maybe the schedule was enough
to equalize the lag values again, can't spot the actual code that would do
that right now though.
Nevertheless both versions fixed the degredation consistently.

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

That makes sense, but does not match the results I was seeing, I might have to
give this a closer look to figure out why this works in this particular 
scenario.

> Now, there is an easy option... but I hate to mention it because I've
> spend a lifetime telling people not to use it (for really good reasons):
> yield().
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

Which would fix the degradation in this particular benchmark scenario.
But I could see this having some unwanted side effects. This would require
a yield_to() which only passes control to the target task and then returns
to the caller consistently. Which might allow to bypass all considerartions
on fairness.

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
> 

I spent some time crawling through the vhost code, and to me it looks like
vhost is writing data to a socket file which has an eventfd handler attached
which is ran by the kworker. Said handler does the actual memory interaction.
So without the kworker running, the transaction is not completed. The 
counterpart keeps waiting for that message while the local vhost expects some
reply from the counterpart. So we're in a deadlock until the kworker gets to
run.

Which could be technically true for more components which use such a loop+event
construction. We saw the same, although less severe, issue with fio.

