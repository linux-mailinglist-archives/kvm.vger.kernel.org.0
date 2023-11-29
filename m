Return-Path: <kvm+bounces-2725-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C84957FCF17
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 07:32:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5CC492823A2
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 06:31:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CFD11078B;
	Wed, 29 Nov 2023 06:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="jqcrY24A"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8147198;
	Tue, 28 Nov 2023 22:31:33 -0800 (PST)
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3AT6Rr0G003878;
	Wed, 29 Nov 2023 06:31:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=SUZRHLlSRdF3IEamOtrEvhT6fD/d+NFPZWKQqCzpmbA=;
 b=jqcrY24AZWqR+CF9jnuvLLNVfL/dj+NKnK+BKSQlsvRD9WXLWyTduGByOaivyNpZWHen
 CVv1xD+KUkRLJqsyE5fszAQB8DVigbgjHakMQlgLHAku4fyudxgzy52aW7mF/V8Izbvq
 qXdReb5nbMph+fnCy3Cb6uox/ZvKn2lA5xM2gSYhcAxPxfYVieXFJ13XYqCqKKJR5bFy
 wpmtLZVjF8Qpaahlxqu61jW+b78V3n44ErH3+VRrMvJ03poyWolGYbikVUIW1/EEBxUZ
 MMgMcrjL8Q+ngW0zx31r6g1fLEumly+mhF6LYnEsxNxt6J6sJ8bGuvXZCem5t0lbihQO aQ== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3up02381tx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 29 Nov 2023 06:31:05 +0000
Received: from m0353723.ppops.net (m0353723.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3AT6UMA8009948;
	Wed, 29 Nov 2023 06:31:04 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3up02381tf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 29 Nov 2023 06:31:04 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3AT5G5sb028329;
	Wed, 29 Nov 2023 06:31:04 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3ukv8nng8y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 29 Nov 2023 06:31:03 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3AT6V1e845744780
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Nov 2023 06:31:02 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D55EA2004D;
	Wed, 29 Nov 2023 06:31:01 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id ABBC820040;
	Wed, 29 Nov 2023 06:31:01 +0000 (GMT)
Received: from DESKTOP-2CCOB1S. (unknown [9.171.203.35])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 29 Nov 2023 06:31:01 +0000 (GMT)
Date: Wed, 29 Nov 2023 07:31:01 +0100
From: Tobias Huschle <huschle@linux.ibm.com>
To: Abel Wu <wuyun.abel@bytedance.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        virtualization@lists.linux.dev, netdev@vger.kernel.org, mst@redhat.com,
        jasowang@redhat.com
Subject: Re: Re: Re: EEVDF/vhost regression (bisected to 86bfbb7ce4f6
 sched/fair: Add lag based placement)
Message-ID: <ZWbapeL34Z8AMR5f@DESKTOP-2CCOB1S.>
References: <c7b38bc27cc2c480f0c5383366416455@linux.ibm.com>
 <20231117092318.GJ8262@noisy.programming.kicks-ass.net>
 <ZVdbdSXg4qefTNtg@DESKTOP-2CCOB1S.>
 <20231117123759.GP8262@noisy.programming.kicks-ass.net>
 <46a997c2-5a38-4b60-b589-6073b1fac677@bytedance.com>
 <ZVyt4UU9+XxunIP7@DESKTOP-2CCOB1S.>
 <20231122100016.GO8262@noisy.programming.kicks-ass.net>
 <6564a012.c80a0220.adb78.f0e4SMTPIN_ADDED_BROKEN@mx.google.com>
 <d4110c79-d64f-49bd-9f69-0a94369b5e86@bytedance.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d4110c79-d64f-49bd-9f69-0a94369b5e86@bytedance.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: MWQRo9A2y_8bYd4lGwrLhaqCYQTrINad
X-Proofpoint-GUID: mTSe3wItw0uj9WgQnE43wzWgGLmNSKJT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-29_03,2023-11-27_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 clxscore=1015
 malwarescore=0 phishscore=0 lowpriorityscore=0 priorityscore=1501
 bulkscore=0 adultscore=0 mlxscore=0 mlxlogscore=999 impostorscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2311290046

On Tue, Nov 28, 2023 at 04:55:11PM +0800, Abel Wu wrote:
> On 11/27/23 9:56 PM, Tobias Huschle Wrote:
> > On Wed, Nov 22, 2023 at 11:00:16AM +0100, Peter Zijlstra wrote:
> > > On Tue, Nov 21, 2023 at 02:17:21PM +0100, Tobias Huschle wrote:

[...]

> > - At depth 4, the cgroup shows the observed vruntime value which is smaller
> >    by a factor of 20, but depth 0 seems to be running with values of the
> >    correct magnitude.
> 
> A child is running means its parent also being the cfs->curr, but
> not vice versa if there are more than one child.
> 
> > - cgroup at depth 0 has zero lag, with higher depth, there are large lag
> >    values (as observed 606.338267 onwards)
> 
> These values of se->vlag means 'run this entity to parity' to avoid
> excess context switch, which is what RUN_TO_PARITY does, or nothing
> when !RUN_TO_PARITY. In short, se->vlag is not vlag when se->on_rq.
> 

Thanks for clarifying that. This makes things clearer to me.

> > 
> > Now the following occurs, triggered by the vhost:
> > - The kworker gets placed again with:
> >                      vruntime      deadline
> >     cgroup        56117619190   57650477291 -> depth 0, last known value
> >     kworker       56117885776   56120885776 -> lag of -725
> > - vhost continues executing and updates its vruntime accordingly, here
> >    I would need to enhance the trace to also print the vruntimes of the
> >    parent sched_entities to see the progress of their vruntime/deadline/lag
> >    values as well
> > - It is a bit irritating that the EEVDF algorithm would not pick the kworker
> >    over the cgroup as its deadline is smaller.
> >    But, the kworker has negative lag, which might cause EEVDF to not pick
> >    the kworker.
> >    The cgroup at depth 0 has no lag, all deeper layers have a significantly
> >    positve lag (last known values, might have changed in the meantime).
> >    At this point I would see the option that the vhost task is stuck
> >    somewhere or EEVDF just does not see the kworker as a eligible option.
> 
> IMHO such lag should not introduce that long delay. Can you run the
> test again with NEXT_BUDDY disabled?

I added a trace event to the next buddy path, it does not get triggered, so I'd 
assume that no buddies are selected.

> 
> > 
> > - Once the vhost is migrated off the cpu, the update_entity_lag function
> >    works with the following values at 606.467022: sched_update
> >    For the cgroup at depth 0
> >    - vruntime = 57104166665 --> this is in line with the amount of new timeslices
> >                                 vhost got assigned while the kworker was waiting
> >    - vlag     =   -62439022 --> the scheduler knows that the cgroup was
> >                                 overconsuming, but no runtime for the kworker
> >    For the cfs_rq we have
> >    - min_vruntime =  56117885776 --> this matches the vruntime of the kworker
> >    - avg_vruntime = 161750065796 --> this is rather large in comparison, but I
> >                                      might access this value at a bad time
> 
> Use avg_vruntime() instead.

Fair.

[...]

> > 
> > ######################### full trace #########################
> > 
> > sched_bestvnode: v=vruntime,d=deadline,l=vlag,md=min_deadline,dp=depth
> > --> during __pick_eevdf, prints values for best and the first node loop variable, second loop is never executed
> > 
> > sched_place/sched_update: sev=se->vruntime,sed=se->deadline,sev=se->vlag,avg=cfs_rq->avg_vruntime,min=cfs_rq->min_vruntime
> 
> It would be better replace cfs_rq->avg_vruntime with avg_vruntime().
> Although we can get real @avg by (vruntime + vlag), I am not sure
> vlag (@lag in trace) is se->vlag or the local variable in the place
> function which is scaled and no longer be the true vlag.
> 

Oh my bad, sev is the vlag value of the sched_entity, lag is the local variable.

[...]

> >      vhost-2931-2953    [013] d....   606.338313: sched_wakeup: comm=kworker/13:1 pid=168 prio=120 target_cpu=013
> > --> kworker set to runnable, but vhost keeps on executing
> 
> What are the weights of the two entities?

I'll do another run and look at those values.

[...]

