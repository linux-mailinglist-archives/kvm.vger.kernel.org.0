Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 545283D6FD5
	for <lists+kvm@lfdr.de>; Tue, 27 Jul 2021 09:00:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235508AbhG0HAQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jul 2021 03:00:16 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:34628 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235471AbhG0HAI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 27 Jul 2021 03:00:08 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16R6i5br083563;
        Tue, 27 Jul 2021 02:59:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=FiVabGtfjDnbtifvF/XqkM9qnKY88Q2VXsum59GwZGo=;
 b=P79yPCxHP+laYTtJrD09z1yfgvdV70oOGk6AlZzwf7AgPFwsxOok7xM89Wl8Mkukyee9
 FvCYlXFYiIkOVjrN47hievvEjU0XZZInZXvK9uglpuPWsbljnkUxL+xkctnGe4gN7+NG
 h6DSsnRivIGTZl9ZwSRY3fyjpnpoBWYt0FSa8SiB0KNNyKNTVQbrpsV4pObH0ZCnxJP7
 E8/eIHEubwHyJ73dhn/0cbTOU8AVhuZvey5u+Xpxx4JlxhSI0gDpx2MkWJH+4Q1KSHwk
 mjvNHxG7q2DZF+mnq48jmCHd1man4VIhPeXH3DBxElrotlo+yezTg1tVdRnCFDu7oAvn oQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a2d4p0h5m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 27 Jul 2021 02:59:25 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16R6iDZS084722;
        Tue, 27 Jul 2021 02:59:24 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a2d4p0h31-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 27 Jul 2021 02:59:22 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16R62w77002265;
        Tue, 27 Jul 2021 06:59:20 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 3a235yg7kw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 27 Jul 2021 06:59:20 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16R6uePl27787764
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Jul 2021 06:56:41 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7678A4203F;
        Tue, 27 Jul 2021 06:59:17 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C47F542047;
        Tue, 27 Jul 2021 06:59:16 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.145.165.137])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 27 Jul 2021 06:59:16 +0000 (GMT)
Subject: Re: [PATCH 1/1] sched/fair: improve yield_to vs fairness
To:     Mel Gorman <mgorman@techsingularity.net>
Cc:     peterz@infradead.org, bristot@redhat.com, bsegall@google.com,
        dietmar.eggemann@arm.com, joshdon@google.com,
        juri.lelli@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        linux@rasmusvillemoes.dk, mgorman@suse.de, mingo@kernel.org,
        rostedt@goodmis.org, valentin.schneider@arm.com,
        vincent.guittot@linaro.org
References: <YIlXQ43b6+7sUl+f@hirez.programming.kicks-ass.net>
 <20210707123402.13999-1-borntraeger@de.ibm.com>
 <20210707123402.13999-2-borntraeger@de.ibm.com>
 <20210723093523.GX3809@techsingularity.net>
 <ddb81bc9-1429-c392-adac-736e23977c84@de.ibm.com>
 <20210723162137.GY3809@techsingularity.net>
 <1acd7520-bd4b-d43d-302a-8dcacf6defa5@de.ibm.com>
 <20210726193232.GZ3809@techsingularity.net>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <d4a8e694-a014-1532-9829-f1594f7c6d86@de.ibm.com>
Date:   Tue, 27 Jul 2021 08:59:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210726193232.GZ3809@techsingularity.net>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Jx2Fh_BmAj2jGHXNRIKpYHEiX0rnAWKv
X-Proofpoint-GUID: SxmirhP_T-CJuWM4Ye5s7G2NZVr1dNVp
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-27_04:2021-07-27,2021-07-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 impostorscore=0 phishscore=0 priorityscore=1501 suspectscore=0
 adultscore=0 bulkscore=0 clxscore=1015 mlxscore=0 mlxlogscore=999
 spamscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107270038
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 26.07.21 21:32, Mel Gorman wrote:
> On Mon, Jul 26, 2021 at 08:41:15PM +0200, Christian Borntraeger wrote:
>>> Potentially. The patch was a bit off because while it noticed that skip
>>> was not being obeyed, the fix was clumsy and isolated. The current flow is
>>>
>>> 1. pick se == left as the candidate
>>> 2. try pick a different se if the "ideal" candidate is a skip candidate
>>> 3. Ignore the se update if next or last are set
>>>
>>> Step 3 looks off because it ignores skip if next or last buddies are set
>>> and I don't think that was intended. Can you try this?
>>>
>>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>>> index 44c452072a1b..d56f7772a607 100644
>>> --- a/kernel/sched/fair.c
>>> +++ b/kernel/sched/fair.c
>>> @@ -4522,12 +4522,12 @@ pick_next_entity(struct cfs_rq *cfs_rq, struct sched_entity *curr)
>>>    			se = second;
>>>    	}
>>> -	if (cfs_rq->next && wakeup_preempt_entity(cfs_rq->next, left) < 1) {
>>> +	if (cfs_rq->next && wakeup_preempt_entity(cfs_rq->next, se) < 1) {
>>>    		/*
>>>    		 * Someone really wants this to run. If it's not unfair, run it.
>>>    		 */
>>>    		se = cfs_rq->next;
>>> -	} else if (cfs_rq->last && wakeup_preempt_entity(cfs_rq->last, left) < 1) {
>>> +	} else if (cfs_rq->last && wakeup_preempt_entity(cfs_rq->last, se) < 1) {
>>>    		/*
>>>    		 * Prefer last buddy, try to return the CPU to a preempted task.
>>>    		 */
>>>
>>
>> This one alone does not seem to make a difference. Neither in ignored yield, nor
>> in performance.
>>
>> Your first patch does really help in terms of ignored yields when
>> all threads are pinned to one host CPU.
> 
> Ok, that tells us something. It implies, but does not prove, that the
> block above that handles skip is failing either the entity_before()
> test or the wakeup_preempt_entity() test. To what degree that should be
> relaxed when cfs_rq->next is !NULL is harder to determine.
> 
>> After that we do have no ignored yield
>> it seems. But it does not affect the performance of my testcase.
> 
> Ok, this is the first patch. The second patch is not improving ignored
> yields at all so the above paragraph still applies. It would be nice
> if you could instrument with trace_printk when cfs->rq_next is valid
> whether it's the entity_before() check that is preventing the skip or
> wakeup_preempt_entity. Would that be possible?

I will try that.
> 
> I still think the second patch is right independent of it helping your
> test case because it makes no sense to me at all that the task after the
> skip candidate is ignored if there is a next or last buddy.

I agree.  This patch makes sense to me as a bug fix.
And I think also the first patch makes sense on its own.
> 
>> I did some more experiments and I removed the wakeup_preempt_entity checks in
>> pick_next_entity - assuming that this will result in source always being stopped
>> and target always being picked. But still, no performance difference.
>> As soon as I play with vruntime I do see a difference (but only without the cpu cgroup
>> controller). I will try to better understand the scheduler logic and do some more
>> testing. If you have anything that I should test, let me know.
>>
> 
> The fact that vruntime tricks only makes a difference when cgroups are
> involved is interesting. Can you describe roughly what how the cgroup
> is configured? 

Its the other way around. My vruntime patch ONLY helps WITHOUT the cpu cgroup controller.
In other words this example on a 16CPU host (resulting in 4x overcommitment)
time ( for ((d=0; d<16; d++)) ; do cgexec -g cpu:test$d qemu-system-s390x -enable-kvm -kernel /root/REPOS/kvm-unit-tests/s390x/diag9c.elf  -smp 4 -nographic -nodefaults -device sclpconsole,chardev=c2 -chardev file,path=/tmp/log$d.log,id=c2  & done; wait)
does NOT benefit from the vruntime patch, but when I remove the "cgexec -g cpu:test$d" it does:
time ( for ((d=0; d<16; d++)) ; do qemu-system-s390x -enable-kvm -kernel /root/REPOS/kvm-unit-tests/s390x/diag9c.elf  -smp 4 -nographic -nodefaults -device sclpconsole,chardev=c2 -chardev file,path=/tmp/log$d.log,id=c2  & done; wait)
  

Similarly, does your config have CONFIG_SCHED_AUTOGROUP
> or CONFIG_FAIR_GROUP_SCHED set? I assume FAIR_GROUP_SCHED must be and

Yes, both are set.
> I wonder if the impact of your patch is dropping groups of tasks in
> priority as opposed to individual tasks. I'm not that familiar with how
> groups are handled in terms of how they are prioritised unfortunately.
> 
> I'm still hesitant to consider the vruntime hammer in case it causes
> fairness problems when vruntime is no longer reflecting time spent on
> the CPU.

I understand your concerns. What about subtracting the same amount of
vruntime from the target as we add on the yielder? Would that result in
quicker rebalancing while still keeping everything in order?
The reason why I am asking is that initially we
realized that setting some tunables lower, e.g.
kernel.sched_latency_ns = 2000000
kernel.sched_migration_cost_ns = 100000
makes things faster in a similar fashion. And that also works with cgroups.
But ideally we find a solution without changing tuneables.
