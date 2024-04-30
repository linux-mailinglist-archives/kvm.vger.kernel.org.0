Return-Path: <kvm+bounces-16230-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E66C88B70DC
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2024 12:50:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9D488288408
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2024 10:50:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4244F12CD8F;
	Tue, 30 Apr 2024 10:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="C+X0FFdj"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D08F412B176;
	Tue, 30 Apr 2024 10:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474237; cv=none; b=SgxwXiKzgPd2qPYCeXI1CUgmd5hdw2LGXPbJHRH3a/D5bG/7Col/2EgvccBrCLqO94l1vy59xGSlMUpdw6S6PYTyN8fuE6j69RGkSwoUn13bzi5H+eBQbcQ0zzQWJnQ4IObpJxaH62eCilKfsTNNwq+xv5U+aAJ+4TdzgCHluQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474237; c=relaxed/simple;
	bh=TCc3/P/vb2bKsNgh0DMGDkw3+VtZMF32Qljv9aV8fpg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Ei9dQGsCNhnT+2aothfTw0yYiOTNHnCSkxECMoBdE8qiIBwqr/+r3z/qcxm/OOPH2Wa8UY2DvI7+8eh178ibDiKzQSTmPXkDrPXHDHDAHigfYNiOR8vs7blB/zBqqlhUPHXgvFGL10ePEhuKd5TLL8WTTCEQ44wDLx5/jSugj1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=C+X0FFdj; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43UAjsB9009165;
	Tue, 30 Apr 2024 10:50:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=pp1; bh=KIXZsXA38DEVkkC2fzxHMp+LuAzjui54oRUIHYvigdE=;
 b=C+X0FFdjvbC0a9Dm1DdNFSnKzLhE36e41tYMxbL+q1wYYnb1FIB8ZYD4QTPrjaZhHnuy
 DAHQsk2IumldqJlT42G4sUClFnHKrd2CQCZzgCvIjXfLfHTal3hNHL+jiq/wh3Pdrxxi
 PJE1Wqi3Rq6KI7Kv85WEHcQGwCr2SiAMl249bqqaKiSm96chaQoxD7d4Sbovs0NfLc9l
 hYFPN/mxmu2A+KG+XtBbLB7ptCZ9OHAcxO5K6ASMVwtpdl3YqsACl5r3BnfSJBBCkNo/
 Ky1MHqYOL9LnusTjoKzEpx73p/+1D5bOXpfa7j7vka7Z64crbKvGQo8oHGA33g4yxg+3 rQ== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xty1yg0h6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 30 Apr 2024 10:50:14 +0000
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 43UAoD1G017171;
	Tue, 30 Apr 2024 10:50:13 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xty1yg0h3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 30 Apr 2024 10:50:13 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 43U7E7aa022334;
	Tue, 30 Apr 2024 10:50:12 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3xsd6mme8t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 30 Apr 2024 10:50:12 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 43UAo6NZ4456976
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 Apr 2024 10:50:08 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9E2282004E;
	Tue, 30 Apr 2024 10:50:06 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4E9C420040;
	Tue, 30 Apr 2024 10:50:06 +0000 (GMT)
Received: from DESKTOP-2CCOB1S. (unknown [9.171.161.140])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 30 Apr 2024 10:50:06 +0000 (GMT)
Date: Tue, 30 Apr 2024 12:50:05 +0200
From: Tobias Huschle <huschle@linux.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Luis Machado <luis.machado@arm.com>, Jason Wang <jasowang@redhat.com>,
        Abel Wu <wuyun.abel@bytedance.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        virtualization@lists.linux.dev, netdev@vger.kernel.org,
        nd <nd@arm.com>, borntraeger@linux.ibm.com
Subject: Re: EEVDF/vhost regression (bisected to 86bfbb7ce4f6 sched/fair: Add
 lag based placement)
Message-ID: <ZjDM3SsZ3NkZuphP@DESKTOP-2CCOB1S.>
References: <89460.124020106474400877@us-mta-475.us.mimecast.lan>
 <20240311130446-mutt-send-email-mst@kernel.org>
 <cf813f92-9806-4449-b099-1bb2bd492b3c@arm.com>
 <73123.124031407552500165@us-mta-156.us.mimecast.lan>
 <20240314110649-mutt-send-email-mst@kernel.org>
 <84704.124031504335801509@us-mta-515.us.mimecast.lan>
 <20240315062839-mutt-send-email-mst@kernel.org>
 <b3fd680c675208370fc4560bb3b4d5b8@linux.ibm.com>
 <20240319042829-mutt-send-email-mst@kernel.org>
 <4808eab5fc5c85f12fe7d923de697a78@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4808eab5fc5c85f12fe7d923de697a78@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: OWDcAJbU4IsjSsDQmPO3kNj-5XcYWDnZ
X-Proofpoint-ORIG-GUID: IscbDflkXN5EgID7BfMaWZI85fn9JhIq
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-04-30_04,2024-04-29_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=999
 mlxscore=0 spamscore=0 lowpriorityscore=0 clxscore=1011 impostorscore=0
 phishscore=0 malwarescore=0 adultscore=0 priorityscore=1501 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2404010000
 definitions=main-2404300077

It took me a while, but I was able to figure out why EEVDF behaves 
different then CFS does. I'm still waiting for some official confirmation
of my assumptions but it all seems very plausible to me.

Leaving aside all the specifics of vhost and kworkers, a more general
description of the scenario would be as follows:

Assume that we have two tasks taking turns on a single CPU. 
Task 1 does something and wakes up Task 2.
Task 2 does something and goes to sleep.
And we're just repeating that.
Task 1 and task 2 only run for very short amounts of time, i.e. much 
shorter than a regular time slice (vhost = task1, kworker = task2).

Let's further assume, that task 1 runs longer than task 2. 
In CFS, this means, that vruntime of task 1 starts to outrun the vruntime
of task 2. This means that vruntime(task2) < vruntime(task1). Hence, task 2
always gets picked on wake up because it has the smaller vruntime. 
In EEVDF, this would translate to a permanent positive lag, which also 
causes task 2 to get consistently scheduled on wake up.

Let's now assume, that ocassionally, task 2 runs a little bit longer than
task 1. In CFS, this means, that task 2 can close the vruntime gap by a
bit, but, it can easily remain below the value of task 1. Task 2 would 
still get picked on wake up.
With EEVDF, in its current form, task 2 will now get a negative lag, which
in turn, will cause it not being picked on the next wake up.

So, it seems we have a change in the level of how far the both variants look 
into the past. CFS being willing to take more history into account, whereas
EEVDF does not (with update_entity_lag setting the lag value from scratch, 
and place_entity not taking the original vruntime into account).

All of this can be seen as correct by design, a task consumes more time
than the others, so it has to give way to others. The big difference
is now, that CFS allowed a task to collect some bonus by constantly using 
less CPU time than others and trading that time against ocassionally taking
more CPU time. EEVDF could do the same thing, by allowing the accumulation
of positive lag, which can then be traded against the one time the task
would get negative lag. This might clash with other EEVDF assumptions though.

The patch below fixes the degredation, but is not at all aligned with what 
EEVDF wants to achieve, but it helps as an indicator that my hypothesis is
correct.

So, what does this now mean for the vhost regression we were discussing?

1. The behavior of the scheduler changed with regard to wake-up scenarios.
2. vhost in its current form relies on the way how CFS works by assuming 
   that the kworker always gets scheduled.

I would like to argue that it therefore makes sense to reconsider the vhost
implementation to make it less dependent on the internals of the scheduler.
As proposed earlier in this thread, I see two options:

1. Do an explicit schedule() after every iteration across the vhost queues
2. Set the need_resched flag after writing to the socket that would trigger
   eventfd and the underlying kworker

Both options would make sure that the vhost gives up the CPU as it cannot
continue anyway without the kworker handling the event. Option 1 will give
up the CPU regardless of whether something was found in the queues, whereas
option 2 would only give up the CPU if there is.

It shall be noted, that we encountered similar behavior when running some
fio benchmarks. From a brief glance at the code, I was seeing similar
intentions: Loop over queues, then trigger an action through some event
mechanism. Applying the same patch as mentioned above also fixes this issue.

It could be argued, that this is still something that needs to be somehow
addressed by the scheduler since it might affect others as well and there 
are in fact patches coming in. Will they address our issue here? Not sure yet.
On the other hand, it might just be beneficial to make vhost more resilient
towards the scheduler's algorithm by not relying on a certain behavior in
the wakeup path.
Further discussion on additional commits to make EEVDF work correctly can 
be found here: 
https://lore.kernel.org/lkml/20240408090639.GD21904@noisy.programming.kicks-ass.net/T/
So far these patches do not fix the degredation.

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 03be0d1330a6..b83a72311d2a 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -701,7 +701,7 @@ static void update_entity_lag(struct cfs_rq *cfs_rq, struct sched_entity *se)
        s64 lag, limit;
 
        SCHED_WARN_ON(!se->on_rq);
-       lag = avg_vruntime(cfs_rq) - se->vruntime;
+       lag = se->vlag + avg_vruntime(cfs_rq) - se->vruntime;
 
        limit = calc_delta_fair(max_t(u64, 2*se->slice, TICK_NSEC), se);
        se->vlag = clamp(lag, -limit, limit);


