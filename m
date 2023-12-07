Return-Path: <kvm+bounces-3797-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 270578080A6
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 07:27:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4A2F21C20A19
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 06:27:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 752DB134D6;
	Thu,  7 Dec 2023 06:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="TLbOs0wu"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8FE3D4B;
	Wed,  6 Dec 2023 22:27:16 -0800 (PST)
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3B76Qnhl017882;
	Thu, 7 Dec 2023 06:26:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=d5jbmnW0EkD6CSJajfUaQ5SYiRswnWaio3/w8qMt2xU=;
 b=TLbOs0wuIXlfOt3U7HolEky3DYFoJTWrcDdVEZkJIwt7fmLvzXDbtbRYea5PFcul5JlE
 813End/Lsnd1UvqSL0CYt2joXmqriVYDk+ahGXIJqgVRL+7zdHzphr+IK1TjsovizYwG
 jmXnkf6aRyEXEXKNXxlHbI8jSEgnwIAV97cv+YdA7EJZKMv/l20XWsa4qQ6lznb8KrE2
 VmhkQ6fV5/xpEnbB+8nO/Sf2QNonxYghTlFdmGaFHB74JonDWf2HoxxsgimoZNR+A4AZ
 tysTAdpxBDo5zCTgsZ1dVSdcy9+dZqqObssMRd0rPK0HLQMo+xNrbI2piRu3d6B+/A2X EA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3uu8ehggd4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 07 Dec 2023 06:26:56 +0000
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3B76QtYG018851;
	Thu, 7 Dec 2023 06:26:55 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3uu8ehgfxt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 07 Dec 2023 06:26:55 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3B74Vfci013754;
	Thu, 7 Dec 2023 06:22:24 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3utau49dss-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 07 Dec 2023 06:22:24 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3B76MMdj12517954
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 7 Dec 2023 06:22:22 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F41942004E;
	Thu,  7 Dec 2023 06:22:21 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BECC52004B;
	Thu,  7 Dec 2023 06:22:21 +0000 (GMT)
Received: from DESKTOP-2CCOB1S. (unknown [9.171.170.249])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu,  7 Dec 2023 06:22:21 +0000 (GMT)
Date: Thu, 7 Dec 2023 07:22:12 +0100
From: Tobias Huschle <huschle@linux.ibm.com>
To: Abel Wu <wuyun.abel@bytedance.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        virtualization@lists.linux.dev, netdev@vger.kernel.org, mst@redhat.com,
        jasowang@redhat.com
Subject: Re: Re: Re: EEVDF/vhost regression (bisected to 86bfbb7ce4f6
 sched/fair: Add lag based placement)
Message-ID: <ZXFklCgF3EjeKXDC@DESKTOP-2CCOB1S.>
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
X-Proofpoint-ORIG-GUID: YxWBNA5v8kUE6HWP3YpGbeQa24-QPgfk
X-Proofpoint-GUID: BFw7w5Nrp5y0zSu7NHsfReZy4aazozqE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-07_03,2023-12-06_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 mlxscore=0
 suspectscore=0 clxscore=1015 mlxlogscore=999 lowpriorityscore=0
 phishscore=0 adultscore=0 impostorscore=0 priorityscore=1501 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2312070050

On Tue, Nov 28, 2023 at 04:55:11PM +0800, Abel Wu wrote:
> On 11/27/23 9:56 PM, Tobias Huschle Wrote:
> > On Wed, Nov 22, 2023 at 11:00:16AM +0100, Peter Zijlstra wrote:
> > > On Tue, Nov 21, 2023 at 02:17:21PM +0100, Tobias Huschle wrote:
[...]
> 
> What are the weights of the two entities?
> 

Both entities have the same weights (I saw 1048576 for both of them).
The story looks different when we look at the cgroup hierarchy though:

sew := weight of the sched entity (se->load.weight)

     CPU 6/KVM-2360    [011] d....  1158.884473: sched_place: comm=vhost-2961 pid=2984 sev=3595548386 sed=3598548386 sel=0 sew=1048576 avg=3595548386 min=3595548386 cpu=11 nr=0 vru=3595548386 lag=0
     CPU 6/KVM-2360    [011] d....  1158.884473: sched_place: comm= pid=0 sev=19998138425 sed=20007532920 sel=0 sew=335754 avg=19998138425 min=19998138425 cpu=11 nr=0 vru=19998138425 lag=0
     CPU 6/KVM-2360    [011] d....  1158.884474: sched_place: comm= pid=0 sev=37794158943 sed=37807515464 sel=0 sew=236146 avg=37794158943 min=37794158943 cpu=11 nr=0 vru=37794158943 lag=0
     CPU 6/KVM-2360    [011] d....  1158.884474: sched_place: comm= pid=0 sev=50387168150 sed=50394482435 sel=0 sew=430665 avg=50387168150 min=50387168150 cpu=11 nr=0 vru=50387168150 lag=0
     CPU 6/KVM-2360    [011] d....  1158.884474: sched_place: comm= pid=0 sev=76600751247 sed=77624751246 sel=0 sew=3876 avg=76600751247 min=76600751247 cpu=11 nr=0 vru=76600751247 lag=0
<...>
    vhost-2961-2984    [011] d....  1158.884487: sched_place: comm=kworker/11:2 pid=202 sev=76603905961 sed=76606905961 sel=0 sew=1048576 avg=76603905961 min=76603905961 cpu=11 nr=1 vru=76603905961 lag=0

Here we can see the following weights:
kworker     -> 1048576
vhost       -> 1048576
cgroup root ->    3876

kworker and vhost weights remain the same. The weights of the nodes in the cgroup vary.


I also spent some more thought on this and have some more observations:

1. kworker lag after short runtime

    vhost-2961-2984    [011] d....  1158.884486: sched_waking: comm=kworker/11:2 pid=202 prio=120 target_cpu=011
    vhost-2961-2984    [011] d....  1158.884487: sched_place: comm=kworker/11:2 pid=202 sev=76603905961 sed=76606905961 sel=0 sew=1048576 avg=76603905961 min=76603905961 cpu=11 nr=1 vru=76603905961 lag=0
<...>                                                                                                                   ^^^^^
    vhost-2961-2984    [011] d....  1158.884490: sched_switch: prev_comm=vhost-2961 prev_pid=2984 prev_prio=120 prev_state=R+ ==> next_comm=kworker/11:2 next_pid=202 next_prio=120
   kworker/11:2-202    [011] d....  1158.884491: sched_waking: comm=CPU 0/KVM pid=2988 prio=120 target_cpu=009
   kworker/11:2-202    [011] d....  1158.884492: sched_stat_runtime: comm=kworker/11:2 pid=202 runtime=5150 [ns] vruntime=76603911111 [ns] deadline=76606905961 [ns] lag=76606905961
                                                                                               ^^^^^^^^^^^^^^^^
   kworker/11:2-202    [011] d....  1158.884492: sched_update: comm=kworker/11:2 pid=202 sev=76603911111 sed=76606905961 sel=-1128 sew=1048576 avg=76603909983 min=76603905961 cpu=11 nr=2 lag=-1128 lim=10000000
                                                                                                                         ^^^^^^^^^
   kworker/11:2-202    [011] d....  1158.884494: sched_stat_wait: comm=vhost-2961 pid=2984 delay=5150 [ns]
   kworker/11:2-202    [011] d....  1158.884494: sched_switch: prev_comm=kworker/11:2 prev_pid=202 prev_prio=120 prev_state=I ==> next_comm=vhost-2961 next_pid=2984 next_prio=120

In the sequence above, the kworker gets woken up by the vhost and placed on the timeline with 0 lag.
The kworker then executes for 5150ns and returns control to the vhost.
Unfortunately, this short runtime earns the kworker a negative lag of -1128.
This in turn, causes the kworker to not be selected by check_preempt_wakeup_fair.

My naive understanding of lag is, that only those entities get negative lag, which consume
more time than they should. Why is the kworker being punished for running only a tiny
portion of time?

In the majority of cases, the kworker finishes after a 4-digit number of ns.
There are occassional outliers with 5-digit numbers. I would therefore not 
expect negative lag for the kworker.

It is fair to say that the kworker was executing while the vhost was not.
kworker gets put on the queue with no lag, so it essentially has its vruntime
set to avg_vruntime.
After giving up its timeslice the kworker has now a vruntime which is larger
than the avg_vruntime. Hence the negative lag might make sense here from an
algorithmic standpoint. 


2a/b. vhost getting increased deadlines over time, no call of pick_eevdf

    vhost-2961-2984    [011] d.h..  1158.892878: sched_stat_runtime: comm=vhost-2961 pid=2984 runtime=8385872 [ns] vruntime=3603948448 [ns] deadline=3606948448 [ns] lag=3598548386
    vhost-2961-2984    [011] d.h..  1158.892879: sched_stat_runtime: comm= pid=0 runtime=8385872 [ns] vruntime=76604158567 [ns] deadline=77624751246 [ns] lag=77624751246
<..>
    vhost-2961-2984    [011] d.h..  1158.902877: sched_stat_runtime: comm=vhost-2961 pid=2984 runtime=9999435 [ns] vruntime=3613947883 [ns] deadline=3616947883 [ns] lag=3598548386
    vhost-2961-2984    [011] d.h..  1158.902878: sched_stat_runtime: comm= pid=0 runtime=9999435 [ns] vruntime=76633826282 [ns] deadline=78137144356 [ns] lag=77624751246
<..>
    vhost-2961-2984    [011] d.h..  1158.912877: sched_stat_runtime: comm=vhost-2961 pid=2984 runtime=9999824 [ns] vruntime=3623947707 [ns] deadline=3626947707 [ns] lag=3598548386
    vhost-2961-2984    [011] d.h..  1158.912878: sched_stat_runtime: comm= pid=0 runtime=9999824 [ns] vruntime=76688003113 [ns] deadline=78161723086 [ns] lag=77624751246
<..>
<..>
    vhost-2961-2984    [011] dN...  1159.152927: sched_stat_runtime: comm=vhost-2961 pid=2984 runtime=40402 [ns] vruntime=3863988069 [ns] deadline=3866947667 [ns] lag=3598548386
    vhost-2961-2984    [011] dN...  1159.152928: sched_stat_runtime: comm= pid=0 runtime=40402 [ns] vruntime=78355923791 [ns] deadline=78393801472 [ns] lag=77624751246

In the sequence above, I extended the tracing of sched_stat_runtime to use 
for_each_sched_entity to also output the values for the cgroup hierarchy.
The first entry represents the actual task, the second entry represents
the root for that particular cgroup. I dropped the levels in between
for readability.

The first three groupings are happening in sequence. The fourth grouping
is the last sched_stat_runtime update before the vhost gets migrated off
the CPU. The ones in between repeat the same pattern.

Interestingly, the vruntimes of the root grow faster than the actual tasks.
I assume this is intended.
At the same time, the deadlines keep on growing for vhost and the cgroup root.
At the same time, the kworker is left starving with its negative lag.
At no point in this sequence, pick_eevdf is being called.

The only time pick_eevdf is being called is right when the kworker is woken up.
So check_preempt_wakeup_fair seems to be the only chance for the kworker to get
scheduled in time.

For reference:
    vhost-2961-2984    [011] d....  1158.884563: sched_place: comm=kworker/11:2 pid=202 sev=76604163719 sed=76607163719 sel=-1128 sew=1048576 avg=76604158567 min=76604158567 cpu=11 nr=1 vru=76604158567 lag=-5152

The kworker has a deadline which is definitely smaller than the one of vhost
in later stages. So, I would assume it should get scheduled at some point.
If vhost is running in kernel space and is therefore not preemptable,
this would be expected behavior though.


3. vhost looping endlessly, waiting for kworker to be scheduled

I dug a little deeper on what the vhost is doing. I'm not an expert on
virtio whatsoever, so these are just educated guesses that maybe
someone can verify/correct. Please bear with me probably messing up 
the terminology.

- vhost is looping through available queues.
- vhost wants to wake up a kworker to process a found queue.
- kworker does something with that queue and terminates quickly.

What I found by throwing in some very noisy trace statements was that,
if the kworker is not woken up, the vhost just keeps looping accross
all available queues (and seems to repeat itself). So it essentially
relies on the scheduler to schedule the kworker fast enough. Otherwise
it will just keep on looping until it is migrated off the CPU.


SUMMARY 

1 and 2a/b have some more or less plausible potential explanations, 
where the EEVDF scheduler might just do what it is designed to do.

3 is more tricky since I'm not familiar with the topic. If the vhost just
relies on the kworker pre-empting the vhost, than this sounds a bit
counter-intuitive. But there might also be a valid design decision
behind this.

If 1 and 2 are indeed plausible, path 3 is probably the
one to go in order to figure out if we have a problem there.
[...]

