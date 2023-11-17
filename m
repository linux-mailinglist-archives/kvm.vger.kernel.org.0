Return-Path: <kvm+bounces-1943-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 547947EF28B
	for <lists+kvm@lfdr.de>; Fri, 17 Nov 2023 13:24:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3AC8EB209DA
	for <lists+kvm@lfdr.de>; Fri, 17 Nov 2023 12:24:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 001D930D0B;
	Fri, 17 Nov 2023 12:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="B1QTwYpo"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C58411D;
	Fri, 17 Nov 2023 04:24:33 -0800 (PST)
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3AHBxUmn001854;
	Fri, 17 Nov 2023 12:24:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=pp1; bh=g/LbJifLEhv9VAEUkd0VMYGie7Nh1ngRR5OraPEIgLc=;
 b=B1QTwYpoi0/JPCeu+/gY5FkR6dLO9wBYmfcMRpuApdWf5Spn+IQis5xtOxJwPdFpK99C
 lVnsqZ15aiaq9FOD2t4uaYSVykrPR8N+vTfBb5rGYtwiS71TAkBIa5TSvnwhgxcIUheK
 EaJ5rGUtmLLYHVqd2RRHNghWXQl9pyEXlCf6CA+gNuLSA5IjjCGJupxUKoKMXiU9SJ7t
 ZFRKC8+UsXHbGiwDuggbjDqzrFmxPgSmISM1dzFxRL4HooWgn0XHglUVrwplxv3ygBtn
 u8FNgMp20lUu+fi2YDKnow9b2TfjZAvH3rREsbPxCAOOXE6Y3G1qjoJpVotKDhHdxoNH GA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ue7snrkfk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Nov 2023 12:24:24 +0000
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3AHCBjfY008600;
	Fri, 17 Nov 2023 12:24:24 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ue7snrkf6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Nov 2023 12:24:24 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3AHAY5Qs009958;
	Fri, 17 Nov 2023 12:24:23 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3uapn2599q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Nov 2023 12:24:23 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3AHCOLqJ19464884
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Nov 2023 12:24:21 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 751A82004B;
	Fri, 17 Nov 2023 12:24:21 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 38F3220040;
	Fri, 17 Nov 2023 12:24:21 +0000 (GMT)
Received: from DESKTOP-2CCOB1S. (unknown [9.171.135.230])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri, 17 Nov 2023 12:24:21 +0000 (GMT)
Date: Fri, 17 Nov 2023 13:24:21 +0100
From: Tobias Huschle <huschle@linux.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        virtualization@lists.linux.dev, netdev@vger.kernel.org, mst@redhat.com,
        jasowang@redhat.com
Subject: Re: EEVDF/vhost regression (bisected to 86bfbb7ce4f6 sched/fair: Add
 lag based placement)
Message-ID: <ZVdbdSXg4qefTNtg@DESKTOP-2CCOB1S.>
References: <c7b38bc27cc2c480f0c5383366416455@linux.ibm.com>
 <20231117092318.GJ8262@noisy.programming.kicks-ass.net>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231117092318.GJ8262@noisy.programming.kicks-ass.net>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: WZwa4MpiyR3hTwWW8OxyGLBUBiUM0tvV
X-Proofpoint-GUID: zttd9tuaSAJVsf2tWjlPt_VTzfk6ZCyl
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-17_10,2023-11-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 spamscore=0 malwarescore=0 bulkscore=0 priorityscore=1501 impostorscore=0
 adultscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2311170091

On Fri, Nov 17, 2023 at 10:23:18AM +0100, Peter Zijlstra wrote:
> 
> Your email is pretty badly mangled by wrapping, please try and
> reconfigure your MUA, esp. the trace and debug output is unreadable.

Just saw that .. sorry, will append the trace and latency data again.

[...]

> 
> So bear with me, I know absolutely nothing about virt stuff. I suspect
> there's cgroups involved because shiny or something.
> 
> kworkers are typically not in cgroups and are part of the root cgroup,
> but what's a vhost and where does it live?

The qemu instances of the two KVM guests are placed into cgroups.
The vhosts run within the context of these qemu instances (4 threads per guest).
So they are also put into those cgroups.

I'll answer the other questions you brought up as well, but I guess that one 
is most critical: 

> 
> After confirming both tasks are indeed in the same cgroup ofcourse,
> because if they're not, vruntime will be meaningless to compare and we
> should look elsewhere.

In that case we probably have to go with elsewhere ... which is good to know.

> 
> Also, what are their weights / nice values?
> 

Everything runs under default priority of 120. No nice values are set.

[...]

> 
> So why does this vhost stay on the CPU if it doesn't have anything to
> do? (I've not tried to make sense of the trace, that's just too
> painful).

It does something, we just don't see anything scheduler related in the trace anymore.
So far we haven't gone down the path of looking deeper into vhost.
We actually don't know what it's doing at the point where we took the trace.

[...]

> 
> That's, weird. Can you add a trace_printk() to update_entity_lag() and
> have it print out the lag, limit and vlag (post clamping) values? And
> also in place_entity() for the reverse process, lag pre and post scaling
> or something.

There is already a trace statement in the log for place_entity, that's were we
found some of the irritating numbers, will add another one for update_entity_lag 
and send an update once we have it.

Unless there is no sense in doing so because of the involvement of cgroups.

> 
> Also, what HZ and what preemption mode are you running? If kworker is

HZ=100
We run a non-preemptable kernel.

> somehow vastly over-shooting it's slice -- keeps running way past the
> avg_vruntime, then it will build up a giant lag and you get what you
> describe, next time it wakes up it gets placed far to the right (exactly
> where it was when it 'finally' went to sleep, relatively speaking).

That's one of the things that irritated us, the kworker has basically no lag.
I hope the reformatted trace below helps claryfing things.
If this is ok due to them not being in the same cgroup, then that's just how it is.

[...]

> 
> Now OTOH, with lag-based placement,  we strictly preserve their relative
> offset vs avg_vruntime. So if they were *far* too the right when they go
> to sleep, they will again be there on placement.

Yea, that's what I gathered from the EEVDF paper and the 3 strategies discussed
how to handle tasks that "rejoin the competition".

I'll do some catching up on how cgroups play into this.

> 
> Sleeping doesn't help them anymore.
> 
> Now, IF this is the problem, I might have a patch that helps:
> 
>   https://git.kernel.org/pub/scm/linux/kernel/git/peterz/queue.git/commit/?h=sched/eevdf&id=119feac4fcc77001cd9bf199b25f08d232289a5c
> 
> That branch is based on v6.7-rc1 and then some, but I think it's
> relatively easy to rebase the lot on v6.6 (which I'm assuming you're
> on).
> 
> I'm a little conflicted on the patch, conceptually I like what it does,
> but the code it turned into is quite horrible. I've tried implementing
> it differently a number of times but always ended up with things that
> either didn't work or were worse.
> 
> But if it works, it works I suppose.
> 

I'll check out the patch, thanks for the pointer.

Here's the hopefully unmangled data:

#################### TRACE EXCERPT ####################
The sched_place trace event was added to the end of the place_entity function and outputs:
sev -> sched_entity vruntime
sed -> sched_entity deadline
sel -> sched_entity vlag
avg -> cfs_rq avg_vruntime
min -> cfs_rq min_vruntime
cpu -> cpu of cfs_rq
nr  -> cfs_rq nr_running
---
    CPU 3/KVM-2950    [014] d....   576.161432: sched_migrate_task: comm=vhost-2920 pid=2941 prio=120 orig_cpu=15 dest_cpu=14
--> migrates task from cpu 15 to 14
    CPU 3/KVM-2950    [014] d....   576.161433: sched_place: comm=vhost-2920 pid=2941 sev=4242563284 sed=4245563284 sel=0 avg=4242563284 min=4242563284 cpu=14 nr=0
--> places vhost 2920 on CPU 14 with vruntime 4242563284
    CPU 3/KVM-2950    [014] d....   576.161433: sched_place: comm= pid=0 sev=16329848593 sed=16334604010 sel=0 avg=16329848593 min=16329848593 cpu=14 nr=0
    CPU 3/KVM-2950    [014] d....   576.161433: sched_place: comm= pid=0 sev=42560661157 sed=42627443765 sel=0 avg=42560661157 min=42560661157 cpu=14 nr=0
    CPU 3/KVM-2950    [014] d....   576.161434: sched_place: comm= pid=0 sev=53846627372 sed=54125900099 sel=0 avg=53846627372 min=53846627372 cpu=14 nr=0
    CPU 3/KVM-2950    [014] d....   576.161434: sched_place: comm= pid=0 sev=86640641980 sed=87255041979 sel=0 avg=86640641980 min=86640641980 cpu=14 nr=0
    CPU 3/KVM-2950    [014] dN...   576.161434: sched_stat_wait: comm=vhost-2920 pid=2941 delay=9958 [ns]
    CPU 3/KVM-2950    [014] d....   576.161435: sched_switch: prev_comm=CPU 3/KVM prev_pid=2950 prev_prio=120 prev_state=S ==> next_comm=vhost-2920 next_pid=2941 next_prio=120
   vhost-2920-2941    [014] D....   576.161439: sched_waking: comm=vhost-2286 pid=2309 prio=120 target_cpu=008
   vhost-2920-2941    [014] d....   576.161446: sched_waking: comm=kworker/14:0 pid=6525 prio=120 target_cpu=014
   vhost-2920-2941    [014] d....   576.161447: sched_place: comm=kworker/14:0 pid=6525 sev=86642125805 sed=86645125805 sel=0 avg=86642125805 min=86642125805 cpu=14 nr=1
--> places kworker 6525 on cpu 14 with vruntime 86642125805
-->  which is far larger than vhost vruntime of  4242563284
   vhost-2920-2941    [014] d....   576.161447: sched_stat_blocked: comm=kworker/14:0 pid=6525 delay=10143757 [ns]
   vhost-2920-2941    [014] dN...   576.161447: sched_wakeup: comm=kworker/14:0 pid=6525 prio=120 target_cpu=014
   vhost-2920-2941    [014] dN...   576.161448: sched_stat_runtime: comm=vhost-2920 pid=2941 runtime=13884 [ns] vruntime=4242577168 [ns]
--> vhost 2920 finishes after 13884 ns of runtime
   vhost-2920-2941    [014] dN...   576.161448: sched_stat_wait: comm=kworker/14:0 pid=6525 delay=0 [ns]
   vhost-2920-2941    [014] d....   576.161448: sched_switch: prev_comm=vhost-2920 prev_pid=2941 prev_prio=120 prev_state=R+ ==> next_comm=kworker/14:0 next_pid=6525 next_prio=120
--> switch to kworker
 kworker/14:0-6525    [014] d....   576.161449: sched_waking: comm=CPU 2/KVM pid=2949 prio=120 target_cpu=007
 kworker/14:0-6525    [014] d....   576.161450: sched_stat_runtime: comm=kworker/14:0 pid=6525 runtime=3714 [ns] vruntime=86642129519 [ns]
--> kworker finshes after 3714 ns of runtime
 kworker/14:0-6525    [014] d....   576.161450: sched_stat_wait: comm=vhost-2920 pid=2941 delay=3714 [ns]
 kworker/14:0-6525    [014] d....   576.161451: sched_switch: prev_comm=kworker/14:0 prev_pid=6525 prev_prio=120 prev_state=I ==> next_comm=vhost-2920 next_pid=2941 next_prio=120
--> switch back to vhost
   vhost-2920-2941    [014] d....   576.161478: sched_waking: comm=kworker/14:0 pid=6525 prio=120 target_cpu=014
   vhost-2920-2941    [014] d....   576.161478: sched_place: comm=kworker/14:0 pid=6525 sev=86642191859 sed=86645191859 sel=-1150 avg=86642188144 min=86642188144 cpu=14 nr=1
--> kworker placed again on cpu 14 with vruntime 86642191859, the problem occurs only if lag <= 0, having lag=0 does not always hit the problem though
   vhost-2920-2941    [014] d....   576.161478: sched_stat_blocked: comm=kworker/14:0 pid=6525 delay=27943 [ns]
   vhost-2920-2941    [014] d....   576.161479: sched_wakeup: comm=kworker/14:0 pid=6525 prio=120 target_cpu=014
   vhost-2920-2941    [014] D....   576.161511: sched_waking: comm=vhost-2286 pid=2308 prio=120 target_cpu=006
   vhost-2920-2941    [014] D....   576.161512: sched_waking: comm=vhost-2286 pid=2309 prio=120 target_cpu=008
   vhost-2920-2941    [014] D....   576.161516: sched_waking: comm=vhost-2286 pid=2308 prio=120 target_cpu=006
   vhost-2920-2941    [014] D....   576.161773: sched_waking: comm=vhost-2286 pid=2308 prio=120 target_cpu=006
   vhost-2920-2941    [014] D....   576.161775: sched_waking: comm=vhost-2286 pid=2309 prio=120 target_cpu=008
   vhost-2920-2941    [014] D....   576.162103: sched_waking: comm=vhost-2286 pid=2308 prio=120 target_cpu=006
   vhost-2920-2941    [014] D....   576.162105: sched_waking: comm=vhost-2286 pid=2307 prio=120 target_cpu=021
   vhost-2920-2941    [014] D....   576.162326: sched_waking: comm=vhost-2286 pid=2305 prio=120 target_cpu=004
   vhost-2920-2941    [014] D....   576.162437: sched_waking: comm=vhost-2286 pid=2308 prio=120 target_cpu=006
   vhost-2920-2941    [014] D....   576.162767: sched_waking: comm=vhost-2286 pid=2305 prio=120 target_cpu=004
   vhost-2920-2941    [014] d.h..   576.171155: sched_stat_runtime: comm=vhost-2920 pid=2941 runtime=9704465 [ns] vruntime=4252281633 [ns]
   vhost-2920-2941    [014] d.h..   576.181155: sched_stat_runtime: comm=vhost-2920 pid=2941 runtime=10000377 [ns] vruntime=4262282010 [ns]
   vhost-2920-2941    [014] d.h..   576.191154: sched_stat_runtime: comm=vhost-2920 pid=2941 runtime=9999514 [ns] vruntime=4272281524 [ns]
   vhost-2920-2941    [014] d.h..   576.201155: sched_stat_runtime: comm=vhost-2920 pid=2941 runtime=10000246 [ns] vruntime=4282281770 [ns]
--> vhost gets rescheduled multiple times because its vruntime is significantly smaller than the vruntime of the kworker
   vhost-2920-2941    [014] dNh..   576.201176: sched_wakeup: comm=migration/14 pid=85 prio=0 target_cpu=014
   vhost-2920-2941    [014] dN...   576.201191: sched_stat_runtime: comm=vhost-2920 pid=2941 runtime=25190 [ns] vruntime=4282306960 [ns]
   vhost-2920-2941    [014] d....   576.201192: sched_switch: prev_comm=vhost-2920 prev_pid=2941 prev_prio=120 prev_state=R+ ==> next_comm=migration/14 next_pid=85 next_prio=0
 migration/14-85      [014] d..1.   576.201194: sched_migrate_task: comm=vhost-2920 pid=2941 prio=120 orig_cpu=14 dest_cpu=15
--> vhost gets migrated off of cpu 14
 migration/14-85      [014] d..1.   576.201194: sched_place: comm=vhost-2920 pid=2941 sev=3198666923 sed=3201666923 sel=0 avg=3198666923 min=3198666923 cpu=15 nr=0
 migration/14-85      [014] d..1.   576.201195: sched_place: comm= pid=0 sev=12775683594 sed=12779398224 sel=0 avg=12775683594 min=12775683594 cpu=15 nr=0
 migration/14-85      [014] d..1.   576.201195: sched_place: comm= pid=0 sev=33655559178 sed=33661025369 sel=0 avg=33655559178 min=33655559178 cpu=15 nr=0
 migration/14-85      [014] d..1.   576.201195: sched_place: comm= pid=0 sev=42240572785 sed=42244083642 sel=0 avg=42240572785 min=42240572785 cpu=15 nr=0
 migration/14-85      [014] d..1.   576.201196: sched_place: comm= pid=0 sev=70190876523 sed=70194789898 sel=-13068763 avg=70190876523 min=70190876523 cpu=15 nr=0
 migration/14-85      [014] d....   576.201198: sched_stat_wait: comm=kworker/14:0 pid=6525 delay=39718472 [ns]
 migration/14-85      [014] d....   576.201198: sched_switch: prev_comm=migration/14 prev_pid=85 prev_prio=0 prev_state=S ==> next_comm=kworker/14:0 next_pid=6525 next_prio=120
 --> only now, kworker is eligible to run again, after a delay of 39718472 ns
 kworker/14:0-6525    [014] d....   576.201200: sched_waking: comm=CPU 0/KVM pid=2947 prio=120 target_cpu=012
 kworker/14:0-6525    [014] d....   576.201290: sched_stat_runtime: comm=kworker/14:0 pid=6525 runtime=92941 [ns] vruntime=86642284800 [ns]

#################### WAIT DELAYS - PERF LATENCY ####################
last good commit --> perf sched latency -s max
 -------------------------------------------------------------------------------------------------------------------------------------------
  Task                  |   Runtime ms  | Switches | Avg delay ms    | Max delay ms    | Max delay start           | Max delay end          |
 -------------------------------------------------------------------------------------------------------------------------------------------
  CPU 2/KVM:(2)         |   5399.650 ms |   108698 | avg:   0.003 ms | max:   3.077 ms | max start:   544.090322 s | max end:   544.093399 s
  CPU 7/KVM:(2)         |   5111.132 ms |    69632 | avg:   0.003 ms | max:   2.980 ms | max start:   544.690994 s | max end:   544.693974 s
  kworker/22:3-ev:723   |    342.944 ms |    63417 | avg:   0.005 ms | max:   1.880 ms | max start:   545.235430 s | max end:   545.237310 s
  CPU 0/KVM:(2)         |   8171.431 ms |   433099 | avg:   0.003 ms | max:   1.004 ms | max start:   547.970344 s | max end:   547.971348 s
  CPU 1/KVM:(2)         |   5486.260 ms |   258702 | avg:   0.003 ms | max:   1.002 ms | max start:   548.782514 s | max end:   548.783516 s
  CPU 5/KVM:(2)         |   4766.143 ms |    65727 | avg:   0.003 ms | max:   0.997 ms | max start:   545.313610 s | max end:   545.314607 s
  vhost-2268:(6)        |  13206.503 ms |   315030 | avg:   0.003 ms | max:   0.989 ms | max start:   550.887761 s | max end:   550.888749 s
  vhost-2892:(6)        |  14467.268 ms |   214005 | avg:   0.003 ms | max:   0.981 ms | max start:   545.213819 s | max end:   545.214800 s
  CPU 3/KVM:(2)         |   5538.908 ms |    85105 | avg:   0.003 ms | max:   0.883 ms | max start:   547.138139 s | max end:   547.139023 s
  CPU 6/KVM:(2)         |   5289.827 ms |    72301 | avg:   0.003 ms | max:   0.836 ms | max start:   551.094590 s | max end:   551.095425 s

6.6 rc7 --> perf sched latency -s max
-------------------------------------------------------------------------------------------------------------------------------------------
  Task                  |   Runtime ms  | Switches | Avg delay ms    | Max delay ms    | Max delay start           | Max delay end          |
 -------------------------------------------------------------------------------------------------------------------------------------------
  kworker/19:2-ev:1071  |     69.482 ms |    12700 | avg:   0.050 ms | max: 366.314 ms | max start: 54705.674294 s | max end: 54706.040607 s
  kworker/13:1-ev:184   |     78.048 ms |    14645 | avg:   0.067 ms | max: 287.738 ms | max start: 54710.312863 s | max end: 54710.600602 s
  kworker/12:1-ev:46148 |    138.488 ms |    26660 | avg:   0.021 ms | max: 147.414 ms | max start: 54706.133161 s | max end: 54706.280576 s
  kworker/16:2-ev:33076 |    149.175 ms |    29491 | avg:   0.026 ms | max: 139.752 ms | max start: 54708.410845 s | max end: 54708.550597 s
  CPU 3/KVM:(2)         |   1934.714 ms |    41896 | avg:   0.007 ms | max:  92.126 ms | max start: 54713.158498 s | max end: 54713.250624 s
  kworker/7:2-eve:17001 |     68.164 ms |    11820 | avg:   0.045 ms | max:  69.717 ms | max start: 54707.100903 s | max end: 54707.170619 s
  kworker/17:1-ev:46510 |     68.804 ms |    13328 | avg:   0.037 ms | max:  67.894 ms | max start: 54711.022711 s | max end: 54711.090605 s
  kworker/21:1-ev:45782 |     68.906 ms |    13215 | avg:   0.021 ms | max:  59.473 ms | max start: 54709.351135 s | max end: 54709.410608 s
  ksoftirqd/17:101      |      0.041 ms |        2 | avg:  25.028 ms | max:  50.047 ms | max start: 54711.040578 s | max end: 54711.090625 s

