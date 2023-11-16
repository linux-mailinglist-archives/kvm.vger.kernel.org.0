Return-Path: <kvm+bounces-1888-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5EBC37EE720
	for <lists+kvm@lfdr.de>; Thu, 16 Nov 2023 20:03:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D54451F255A7
	for <lists+kvm@lfdr.de>; Thu, 16 Nov 2023 19:03:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E87836AEE;
	Thu, 16 Nov 2023 19:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="EL79lAIy"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47033D59;
	Thu, 16 Nov 2023 11:02:56 -0800 (PST)
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3AGIqRvX008338;
	Thu, 16 Nov 2023 19:02:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : content-type : content-transfer-encoding :
 mime-version; s=pp1; bh=SHIyrFZFifSxGr4mrLrbhZKmxC7H7ciB3AOA5wjmm8E=;
 b=EL79lAIyGZFqeKgTpDJXm0K7tM5gzpzu0M9M1BKzRHWJSJ59EpOyDYzTGnrShniAYZEh
 LmWhlxXy4poTTLZxq6KgS20/f4cRZet9cIxS9H+6r7e26W6kpHtDKYub1HPwowkpnl2I
 2nm/rkbAGv7cpFX8X2f6nAhFWprWBOEwISGpevuTG/7VDM4O6f3a9DTa4xvLc4mkB3vR
 /IODtr71GBxMAvmA3xb1c/jXbzbDKhFMQ3Htze1B0/GarZpjZ+d6uUvdvN/CxHB2hdWF
 TEnrsamZvdfhWlJIOjtS/n+QgoPq0gdV+9ng6F5WrVdl70LB6xCmv8o8gGbgWQKkeGFE Wg== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3udrr8gb4c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 Nov 2023 19:02:36 +0000
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3AGIrTw0012027;
	Thu, 16 Nov 2023 19:02:36 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3udrr8gb29-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 Nov 2023 19:02:36 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3AGI4Z6H005787;
	Thu, 16 Nov 2023 18:58:22 GMT
Received: from smtprelay03.dal12v.mail.ibm.com ([172.16.1.5])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3uapn2092p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 Nov 2023 18:58:22 +0000
Received: from smtpav05.dal12v.mail.ibm.com (smtpav05.dal12v.mail.ibm.com [10.241.53.104])
	by smtprelay03.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3AGIwJ9D9044722
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 16 Nov 2023 18:58:19 GMT
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B5CCA58056;
	Thu, 16 Nov 2023 18:58:19 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2EBDA58052;
	Thu, 16 Nov 2023 18:58:19 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.5.196.140])
	by smtpav05.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 16 Nov 2023 18:58:19 +0000 (GMT)
Date: Thu, 16 Nov 2023 19:58:18 +0100
From: Tobias Huschle <huschle@linux.ibm.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        virtualization@lists.linux.dev, netdev@vger.kernel.org
Cc: Peterz <peterz@infradead.org>, mst@redhat.com, jasowang@redhat.com
Subject: EEVDF/vhost regression (bisected to 86bfbb7ce4f6 sched/fair: Add lag
 based placement)
Message-ID: <c7b38bc27cc2c480f0c5383366416455@linux.ibm.com>
X-Sender: huschle@linux.ibm.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: kIJw1pBF0sJmceQpE6SHwkWR0dW_mfR7
X-Proofpoint-GUID: SenmqXSk8MvmPDlmdOtjTRXtcOhzOcLs
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-16_20,2023-11-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 priorityscore=1501 adultscore=0 clxscore=1011 mlxlogscore=999 phishscore=0
 spamscore=0 bulkscore=0 impostorscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311060000
 definitions=main-2311160150

Hi,

when testing the EEVDF scheduler we stumbled upon a performance 
regression in a uperf scenario and would like to
kindly ask for feedback on whether we are going into the right direction 
with our analysis so far.

The base scenario are two KVM guests running on an s390 LPAR. One guest 
hosts the uperf server, one the uperf client.
With EEVDF we observe a regression of ~50% for a strburst test.
For a more detailed description of the setup see the section TEST 
SUMMARY at the bottom.

Bisecting led us to the following commit which appears to introduce the 
regression:
86bfbb7ce4f6 sched/fair: Add lag based placement

We then compared the last good commit we identified with a recent level 
of the devel branch.
The issue still persists on 6.7 rc1 although there is some improvement 
(down from 62% regression to 49%)

All analysis described further are based on a 6.6 rc7 kernel.

We sampled perf data to get an idea on what is going wrong and ended up 
seeing an dramatic increase in the maximum
wait times from 3ms up to 366ms. See section WAIT DELAYS below for more 
details.

We then collected tracing data to get a better insight into what is 
going on.
The trace excerpt in section TRACE EXCERPT shows one example (of 
multiple per test run) of the problematic scenario where
a kworker(pid=6525) has to wait for 39,718 ms.

Short summary:
The mentioned kworker has been scheduled to CPU 14 before the tracing 
was enabled.
A vhost process is migrated onto CPU 14.
The vruntimes of kworker and vhost differ significantly (86642125805 vs 
4242563284 -> factor 20)
The vhost process wants to wake up the kworker, therefore the kworker is 
placed onto the runqueue again and set to runnable.
The vhost process continues to execute, waking up other vhost processes 
on other CPUs.

So far this behavior is not different to what we see on pre-EEVDF 
kernels.

On timestamp 576.162767, the vhost process triggers the last wake up of 
another vhost on another CPU.
Until timestamp 576.171155, we see no other activity. Now, the vhost 
process ends its time slice.
Then, vhost gets re-assigned new time slices 4 times and gets then 
migrated off to CPU 15.
This does not occur with older kernels.
The kworker has to wait for the migration to happen in order to be able 
to execute again.
This is due to the fact, that the vruntime of the kworker is 
significantly larger than the one of vhost.


We observed the large difference in vruntime between kworker and vhost 
in the same magnitude on
a kernel built based on the parent of the commit mentioned above.
With EEVDF, the kworker is doomed to wait until the vhost either catches 
up on vruntime (which would take 86 seconds)
or the vhost is migrated off of the CPU.

We found some options which sound plausible but we are not sure if they 
are valid or not:

1. The wake up path has a dependency on the vruntime metrics that now 
delays the execution of the kworker.
2. The previous commit af4cf40470c2 (sched/fair: Add 
cfs_rq::avg_vruntime) which updates the way cfs_rq->min_vruntime and
     cfs_rq->avg_runtime are set might have introduced an issue which is 
uncovered with the commit mentioned above.
3. An assumption in the vhost code which causes vhost to rely on being 
scheduled off in time to allow the kworker to proceed.

We also stumbled upon the following mailing thread: 
https://lore.kernel.org/lkml/ZORaUsd+So+tnyMV@chenyu5-mobl2/
That conversation, and the patches derived from it lead to the 
assumption that the wake up path might be adjustable in a way
that this case in particular can be addressed.
At the same time, the vast difference in vruntimes is concerning since, 
at least for some time frame, both processes are on the runqueue.

We would be glad to hear some feedback on which paths to pursue and 
which might just be a dead end in the first place.


#################### TRACE EXCERPT ####################
The sched_place trace event was added to the end of the place_entity 
function and outputs:
sev -> sched_entity vruntime
sed -> sched_entity deadline
sel -> sched_entity vlag
avg -> cfs_rq avg_vruntime
min -> cfs_rq min_vruntime
cpu -> cpu of cfs_rq
nr  -> cfs_rq nr_running
---
     CPU 3/KVM-2950    [014] d....   576.161432: sched_migrate_task: 
comm=vhost-2920 pid=2941 prio=120 orig_cpu=15 dest_cpu=14
--> migrates task from cpu 15 to 14
     CPU 3/KVM-2950    [014] d....   576.161433: sched_place: 
comm=vhost-2920 pid=2941 sev=4242563284 sed=4245563284 sel=0 
avg=4242563284 min=4242563284 cpu=14 nr=0
--> places vhost 2920 on CPU 14 with vruntime 4242563284
     CPU 3/KVM-2950    [014] d....   576.161433: sched_place: comm= pid=0 
sev=16329848593 sed=16334604010 sel=0 avg=16329848593 min=16329848593 
cpu=14 nr=0
     CPU 3/KVM-2950    [014] d....   576.161433: sched_place: comm= pid=0 
sev=42560661157 sed=42627443765 sel=0 avg=42560661157 min=42560661157 
cpu=14 nr=0
     CPU 3/KVM-2950    [014] d....   576.161434: sched_place: comm= pid=0 
sev=53846627372 sed=54125900099 sel=0 avg=53846627372 min=53846627372 
cpu=14 nr=0
     CPU 3/KVM-2950    [014] d....   576.161434: sched_place: comm= pid=0 
sev=86640641980 sed=87255041979 sel=0 avg=86640641980 min=86640641980 
cpu=14 nr=0
     CPU 3/KVM-2950    [014] dN...   576.161434: sched_stat_wait: 
comm=vhost-2920 pid=2941 delay=9958 [ns]
     CPU 3/KVM-2950    [014] d....   576.161435: sched_switch: 
prev_comm=CPU 3/KVM prev_pid=2950 prev_prio=120 prev_state=S ==> 
next_comm=vhost-2920 next_pid=2941 next_prio=120
    vhost-2920-2941    [014] D....   576.161439: sched_waking: 
comm=vhost-2286 pid=2309 prio=120 target_cpu=008
    vhost-2920-2941    [014] d....   576.161446: sched_waking: 
comm=kworker/14:0 pid=6525 prio=120 target_cpu=014
    vhost-2920-2941    [014] d....   576.161447: sched_place: 
comm=kworker/14:0 pid=6525 sev=86642125805 sed=86645125805 sel=0 
avg=86642125805 min=86642125805 cpu=14 nr=1
--> places kworker 6525 on cpu 14 with vruntime 86642125805
-->  which is far larger than vhost vruntime of  4242563284
    vhost-2920-2941    [014] d....   576.161447: sched_stat_blocked: 
comm=kworker/14:0 pid=6525 delay=10143757 [ns]
    vhost-2920-2941    [014] dN...   576.161447: sched_wakeup: 
comm=kworker/14:0 pid=6525 prio=120 target_cpu=014
    vhost-2920-2941    [014] dN...   576.161448: sched_stat_runtime: 
comm=vhost-2920 pid=2941 runtime=13884 [ns] vruntime=4242577168 [ns]
--> vhost 2920 finishes after 13884 ns of runtime
    vhost-2920-2941    [014] dN...   576.161448: sched_stat_wait: 
comm=kworker/14:0 pid=6525 delay=0 [ns]
    vhost-2920-2941    [014] d....   576.161448: sched_switch: 
prev_comm=vhost-2920 prev_pid=2941 prev_prio=120 prev_state=R+ ==> 
next_comm=kworker/14:0 next_pid=6525 next_prio=120
--> switch to kworker
  kworker/14:0-6525    [014] d....   576.161449: sched_waking: comm=CPU 
2/KVM pid=2949 prio=120 target_cpu=007
  kworker/14:0-6525    [014] d....   576.161450: sched_stat_runtime: 
comm=kworker/14:0 pid=6525 runtime=3714 [ns] vruntime=86642129519 [ns]
--> kworker finshes after 3714 ns of runtime
  kworker/14:0-6525    [014] d....   576.161450: sched_stat_wait: 
comm=vhost-2920 pid=2941 delay=3714 [ns]
  kworker/14:0-6525    [014] d....   576.161451: sched_switch: 
prev_comm=kworker/14:0 prev_pid=6525 prev_prio=120 prev_state=I ==> 
next_comm=vhost-2920 next_pid=2941 next_prio=120
--> switch back to vhost
    vhost-2920-2941    [014] d....   576.161478: sched_waking: 
comm=kworker/14:0 pid=6525 prio=120 target_cpu=014
    vhost-2920-2941    [014] d....   576.161478: sched_place: 
comm=kworker/14:0 pid=6525 sev=86642191859 sed=86645191859 sel=-1150 
avg=86642188144 min=86642188144 cpu=14 nr=1
--> kworker placed again on cpu 14 with vruntime 86642191859, the 
problem occurs only if lag <= 0, having lag=0 does not always hit the 
problem though
    vhost-2920-2941    [014] d....   576.161478: sched_stat_blocked: 
comm=kworker/14:0 pid=6525 delay=27943 [ns]
    vhost-2920-2941    [014] d....   576.161479: sched_wakeup: 
comm=kworker/14:0 pid=6525 prio=120 target_cpu=014
    vhost-2920-2941    [014] D....   576.161511: sched_waking: 
comm=vhost-2286 pid=2308 prio=120 target_cpu=006
    vhost-2920-2941    [014] D....   576.161512: sched_waking: 
comm=vhost-2286 pid=2309 prio=120 target_cpu=008
    vhost-2920-2941    [014] D....   576.161516: sched_waking: 
comm=vhost-2286 pid=2308 prio=120 target_cpu=006
    vhost-2920-2941    [014] D....   576.161773: sched_waking: 
comm=vhost-2286 pid=2308 prio=120 target_cpu=006
    vhost-2920-2941    [014] D....   576.161775: sched_waking: 
comm=vhost-2286 pid=2309 prio=120 target_cpu=008
    vhost-2920-2941    [014] D....   576.162103: sched_waking: 
comm=vhost-2286 pid=2308 prio=120 target_cpu=006
    vhost-2920-2941    [014] D....   576.162105: sched_waking: 
comm=vhost-2286 pid=2307 prio=120 target_cpu=021
    vhost-2920-2941    [014] D....   576.162326: sched_waking: 
comm=vhost-2286 pid=2305 prio=120 target_cpu=004
    vhost-2920-2941    [014] D....   576.162437: sched_waking: 
comm=vhost-2286 pid=2308 prio=120 target_cpu=006
    vhost-2920-2941    [014] D....   576.162767: sched_waking: 
comm=vhost-2286 pid=2305 prio=120 target_cpu=004
    vhost-2920-2941    [014] d.h..   576.171155: sched_stat_runtime: 
comm=vhost-2920 pid=2941 runtime=9704465 [ns] vruntime=4252281633 [ns]
    vhost-2920-2941    [014] d.h..   576.181155: sched_stat_runtime: 
comm=vhost-2920 pid=2941 runtime=10000377 [ns] vruntime=4262282010 [ns]
    vhost-2920-2941    [014] d.h..   576.191154: sched_stat_runtime: 
comm=vhost-2920 pid=2941 runtime=9999514 [ns] vruntime=4272281524 [ns]
    vhost-2920-2941    [014] d.h..   576.201155: sched_stat_runtime: 
comm=vhost-2920 pid=2941 runtime=10000246 [ns] vruntime=4282281770 [ns]
--> vhost gets rescheduled multiple times because its vruntime is 
significantly smaller than the vruntime of the kworker
    vhost-2920-2941    [014] dNh..   576.201176: sched_wakeup: 
comm=migration/14 pid=85 prio=0 target_cpu=014
    vhost-2920-2941    [014] dN...   576.201191: sched_stat_runtime: 
comm=vhost-2920 pid=2941 runtime=25190 [ns] vruntime=4282306960 [ns]
    vhost-2920-2941    [014] d....   576.201192: sched_switch: 
prev_comm=vhost-2920 prev_pid=2941 prev_prio=120 prev_state=R+ ==> 
next_comm=migration/14 next_pid=85 next_prio=0
  migration/14-85      [014] d..1.   576.201194: sched_migrate_task: 
comm=vhost-2920 pid=2941 prio=120 orig_cpu=14 dest_cpu=15
--> vhost gets migrated off of cpu 14
  migration/14-85      [014] d..1.   576.201194: sched_place: 
comm=vhost-2920 pid=2941 sev=3198666923 sed=3201666923 sel=0 
avg=3198666923 min=3198666923 cpu=15 nr=0
  migration/14-85      [014] d..1.   576.201195: sched_place: comm= pid=0 
sev=12775683594 sed=12779398224 sel=0 avg=12775683594 min=12775683594 
cpu=15 nr=0
  migration/14-85      [014] d..1.   576.201195: sched_place: comm= pid=0 
sev=33655559178 sed=33661025369 sel=0 avg=33655559178 min=33655559178 
cpu=15 nr=0
  migration/14-85      [014] d..1.   576.201195: sched_place: comm= pid=0 
sev=42240572785 sed=42244083642 sel=0 avg=42240572785 min=42240572785 
cpu=15 nr=0
  migration/14-85      [014] d..1.   576.201196: sched_place: comm= pid=0 
sev=70190876523 sed=70194789898 sel=-13068763 avg=70190876523 
min=70190876523 cpu=15 nr=0
  migration/14-85      [014] d....   576.201198: sched_stat_wait: 
comm=kworker/14:0 pid=6525 delay=39718472 [ns]
  migration/14-85      [014] d....   576.201198: sched_switch: 
prev_comm=migration/14 prev_pid=85 prev_prio=0 prev_state=S ==> 
next_comm=kworker/14:0 next_pid=6525 next_prio=120
  --> only now, kworker is eligible to run again, after a delay of 
39718472 ns
  kworker/14:0-6525    [014] d....   576.201200: sched_waking: comm=CPU 
0/KVM pid=2947 prio=120 target_cpu=012
  kworker/14:0-6525    [014] d....   576.201290: sched_stat_runtime: 
comm=kworker/14:0 pid=6525 runtime=92941 [ns] vruntime=86642284800 [ns]

#################### WAIT DELAYS - PERF LATENCY ####################
last good commit --> perf sched latency -s max
  
-------------------------------------------------------------------------------------------------------------------------------------------
   Task                  |   Runtime ms  | Switches | Avg delay ms    | 
Max delay ms    | Max delay start           | Max delay end          |
  
-------------------------------------------------------------------------------------------------------------------------------------------
   CPU 2/KVM:(2)         |   5399.650 ms |   108698 | avg:   0.003 ms | 
max:   3.077 ms | max start:   544.090322 s | max end:   544.093399 s
   CPU 7/KVM:(2)         |   5111.132 ms |    69632 | avg:   0.003 ms | 
max:   2.980 ms | max start:   544.690994 s | max end:   544.693974 s
   kworker/22:3-ev:723   |    342.944 ms |    63417 | avg:   0.005 ms | 
max:   1.880 ms | max start:   545.235430 s | max end:   545.237310 s
   CPU 0/KVM:(2)         |   8171.431 ms |   433099 | avg:   0.003 ms | 
max:   1.004 ms | max start:   547.970344 s | max end:   547.971348 s
   CPU 1/KVM:(2)         |   5486.260 ms |   258702 | avg:   0.003 ms | 
max:   1.002 ms | max start:   548.782514 s | max end:   548.783516 s
   CPU 5/KVM:(2)         |   4766.143 ms |    65727 | avg:   0.003 ms | 
max:   0.997 ms | max start:   545.313610 s | max end:   545.314607 s
   vhost-2268:(6)        |  13206.503 ms |   315030 | avg:   0.003 ms | 
max:   0.989 ms | max start:   550.887761 s | max end:   550.888749 s
   vhost-2892:(6)        |  14467.268 ms |   214005 | avg:   0.003 ms | 
max:   0.981 ms | max start:   545.213819 s | max end:   545.214800 s
   CPU 3/KVM:(2)         |   5538.908 ms |    85105 | avg:   0.003 ms | 
max:   0.883 ms | max start:   547.138139 s | max end:   547.139023 s
   CPU 6/KVM:(2)         |   5289.827 ms |    72301 | avg:   0.003 ms | 
max:   0.836 ms | max start:   551.094590 s | max end:   551.095425 s

6.6 rc7 --> perf sched latency -s max
-------------------------------------------------------------------------------------------------------------------------------------------
   Task                  |   Runtime ms  | Switches | Avg delay ms    | 
Max delay ms    | Max delay start           | Max delay end          |
  
-------------------------------------------------------------------------------------------------------------------------------------------
   kworker/19:2-ev:1071  |     69.482 ms |    12700 | avg:   0.050 ms | 
max: 366.314 ms | max start: 54705.674294 s | max end: 54706.040607 s
   kworker/13:1-ev:184   |     78.048 ms |    14645 | avg:   0.067 ms | 
max: 287.738 ms | max start: 54710.312863 s | max end: 54710.600602 s
   kworker/12:1-ev:46148 |    138.488 ms |    26660 | avg:   0.021 ms | 
max: 147.414 ms | max start: 54706.133161 s | max end: 54706.280576 s
   kworker/16:2-ev:33076 |    149.175 ms |    29491 | avg:   0.026 ms | 
max: 139.752 ms | max start: 54708.410845 s | max end: 54708.550597 s
   CPU 3/KVM:(2)         |   1934.714 ms |    41896 | avg:   0.007 ms | 
max:  92.126 ms | max start: 54713.158498 s | max end: 54713.250624 s
   kworker/7:2-eve:17001 |     68.164 ms |    11820 | avg:   0.045 ms | 
max:  69.717 ms | max start: 54707.100903 s | max end: 54707.170619 s
   kworker/17:1-ev:46510 |     68.804 ms |    13328 | avg:   0.037 ms | 
max:  67.894 ms | max start: 54711.022711 s | max end: 54711.090605 s
   kworker/21:1-ev:45782 |     68.906 ms |    13215 | avg:   0.021 ms | 
max:  59.473 ms | max start: 54709.351135 s | max end: 54709.410608 s
   ksoftirqd/17:101      |      0.041 ms |        2 | avg:  25.028 ms | 
max:  50.047 ms | max start: 54711.040578 s | max end: 54711.090625 s

#################### TEST SUMMARY ####################
  Setup description:
- single KVM host with 2 identical guests
- guests are connected virtually via Open vSwitch
- guests run uperf streaming read workload with 50 parallel connections
- one guests acts as uperf client, the other one as uperf server

Regression:
kernel-6.5.0-rc2: 78 Gb/s (before 86bfbb7ce4f6 sched/fair: Add lag based 
placement)
kernel-6.5.0-rc2: 29 Gb/s (with 86bfbb7ce4f6 sched/fair: Add lag based 
placement)
kernel-6.7.0-rc1: 41 Gb/s

KVM host:
- 12 dedicated IFLs, SMT-2 (24 Linux CPUs)
- 64 GiB memory
- FEDORA 38
- kernel commandline: transparent_hugepage=never audit_enable=0 audit=0 
audit_debug=0 selinux=0

KVM guests:
- 8 vCPUs
- 8 GiB memory
- RHEL 9.2
- kernel: 5.14.0-162.6.1.el9_1.s390x
- kernel commandline: transparent_hugepage=never audit_enable=0 audit=0 
audit_debug=0 selinux=0

Open vSwitch:
- Open vSwitch with 2 ports, each with mtu=32768 and qlen=15000
- Open vSwitch ports attached to guests via virtio-net
- each guest has 4 vhost-queues

Domain xml snippet for Open vSwitch port:
<interface type="bridge" dev="OVS">
   <source bridge="vswitch0"/>
   <mac address="02:bb:97:28:02:02"/>
   <virtualport type="openvswitch"/>
   <model type="virtio"/>
   <target dev="vport1"/>
   <driver name="vhost" queues="4"/>
   <address type="ccw" cssid="0xfe" ssid="0x0" devno="0x0002"/>
</interface>

Benchmark: uperf
- workload: str-readx30k, 50 active parallel connections
- uperf server permanently sends data in 30720-byte chunks
- uperf client receives and acknowledges this data
- Server: uperf -s
- Client: uperf -a -i 30 -m uperf.xml

uperf.xml:
<?xml version="1.0"?>
<profile name="strburst">
   <group nprocs="50">
     <transaction iterations="1">
       <flowop type="connect" options="remotehost=10.161.28.3 
protocol=tcp  "/>
     </transaction>
     <transaction duration="300">
       <flowop type="read" options="count=640 size=30k"/>
     </transaction>
     <transaction iterations="1">
       <flowop type="disconnect" />
     </transaction>
   </group>
</profile>

