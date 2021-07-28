Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 776293D9320
	for <lists+kvm@lfdr.de>; Wed, 28 Jul 2021 18:24:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230169AbhG1QYk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jul 2021 12:24:40 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:18690 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230025AbhG1QYj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 28 Jul 2021 12:24:39 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16SGEBAn142337;
        Wed, 28 Jul 2021 12:23:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=SR4vpxkGnzbSTAhN/u+D4Aldp8aTgDt7b8Ka1a3p3K4=;
 b=FT74/69PDTsitf7VPXIb6MDrEBSctUoKIZJbXPcmCErXYJegjJQ0rpITgb808KOecOtD
 6i7/gO5unkvTPsZ85CoH/uc4a02yb4kGxVZbSJzZ9QjXn16C3m5QQYX+IK0smzUEmpjL
 OA/W1X2u5mY6AA0lV0hFh3wHKh7pRQIjv6PA+9to5UPUlz9TcReSjVQpgqzKzZBGXKTY
 O3hjTLQgGUwxHcTc4WXY9i0fIEg6k8EFF+Sjotu/fOP06H91JMurTuw2456HrqO3L46n
 MIb7oKOZfKLaORfVGZiZn8yzDz4WP3QCfnr7TLLmYhE3QSiCMHWcDuo7MEAB3RD7NK7D Pw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a3ajxr95d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Jul 2021 12:23:55 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16SGFO8w153197;
        Wed, 28 Jul 2021 12:23:54 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a3ajxr94a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Jul 2021 12:23:54 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16SGJ1KQ022957;
        Wed, 28 Jul 2021 16:23:52 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06ams.nl.ibm.com with ESMTP id 3a235kh6jy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Jul 2021 16:23:51 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16SGLAN630343586
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Jul 2021 16:21:10 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B9E54AE051;
        Wed, 28 Jul 2021 16:23:49 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 19CFBAE045;
        Wed, 28 Jul 2021 16:23:49 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.145.170.45])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 28 Jul 2021 16:23:49 +0000 (GMT)
Subject: Re: [PATCH 1/1] sched/fair: improve yield_to vs fairness
To:     Benjamin Segall <bsegall@google.com>
Cc:     Mel Gorman <mgorman@techsingularity.net>, peterz@infradead.org,
        bristot@redhat.com, dietmar.eggemann@arm.com, joshdon@google.com,
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
 <xm2635rza8l2.fsf@google.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <d9543747-c75f-28c2-6af3-8d9a134717a6@de.ibm.com>
Date:   Wed, 28 Jul 2021 18:23:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <xm2635rza8l2.fsf@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: LW-kW5Cmkq8ClOJMy0yM8S9BEpCxreC4
X-Proofpoint-GUID: m-ueN1bVoJyu8M7xkNoPJIVh3oa7uKkt
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-28_08:2021-07-27,2021-07-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 spamscore=0 priorityscore=1501 bulkscore=0 mlxlogscore=999 mlxscore=0
 adultscore=0 suspectscore=0 malwarescore=0 phishscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2107280090
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 27.07.21 20:57, Benjamin Segall wrote:
> Christian Borntraeger <borntraeger@de.ibm.com> writes:
> 
>> On 23.07.21 18:21, Mel Gorman wrote:
>>> On Fri, Jul 23, 2021 at 02:36:21PM +0200, Christian Borntraeger wrote:
>>>>> sched: Do not select highest priority task to run if it should be skipped
>>>>>
>>>>> <SNIP>
>>>>>
>>>>> index 44c452072a1b..ddc0212d520f 100644
>>>>> --- a/kernel/sched/fair.c
>>>>> +++ b/kernel/sched/fair.c
>>>>> @@ -4522,7 +4522,8 @@ pick_next_entity(struct cfs_rq *cfs_rq, struct sched_entity *curr)
>>>>>     			se = second;
>>>>>     	}
>>>>> -	if (cfs_rq->next && wakeup_preempt_entity(cfs_rq->next, left) < 1) {
>>>>> +	if (cfs_rq->next &&
>>>>> +	    (cfs_rq->skip == left || wakeup_preempt_entity(cfs_rq->next, left) < 1)) {
>>>>>     		/*
>>>>>     		 * Someone really wants this to run. If it's not unfair, run it.
>>>>>     		 */
>>>>>
>>>>
>>>> I do see a reduction in ignored yields, but from a performance aspect for my
>>>> testcases this patch does not provide a benefit, while the the simple
>>>> 	curr->vruntime += sysctl_sched_min_granularity;
>>>> does.
>>> I'm still not a fan because vruntime gets distorted. From the docs
>>>      Small detail: on "ideal" hardware, at any time all tasks would have the
>>> same
>>>      p->se.vruntime value --- i.e., tasks would execute simultaneously and no task
>>>      would ever get "out of balance" from the "ideal" share of CPU time
>>> If yield_to impacts this "ideal share" then it could have other
>>> consequences.
>>> I think your patch may be performing better in your test case because every
>>> "wrong" task selected that is not the yield_to target gets penalised and
>>> so the yield_to target gets pushed up the list.
>>>
>>>> I still think that your approach is probably the cleaner one, any chance to improve this
>>>> somehow?
>>>>
>>> Potentially. The patch was a bit off because while it noticed that skip
>>> was not being obeyed, the fix was clumsy and isolated. The current flow is
>>> 1. pick se == left as the candidate
>>> 2. try pick a different se if the "ideal" candidate is a skip candidate
>>> 3. Ignore the se update if next or last are set
>>> Step 3 looks off because it ignores skip if next or last buddies are set
>>> and I don't think that was intended. Can you try this?
>>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>>> index 44c452072a1b..d56f7772a607 100644
>>> --- a/kernel/sched/fair.c
>>> +++ b/kernel/sched/fair.c
>>> @@ -4522,12 +4522,12 @@ pick_next_entity(struct cfs_rq *cfs_rq, struct sched_entity *curr)
>>>    			se = second;
>>>    	}
>>>    -	if (cfs_rq->next && wakeup_preempt_entity(cfs_rq->next, left) < 1) {
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
>> all threads are pinned to one host CPU. After that we do have no ignored yield
>> it seems. But it does not affect the performance of my testcase.
>> I did some more experiments and I removed the wakeup_preempt_entity checks in
>> pick_next_entity - assuming that this will result in source always being stopped
>> and target always being picked. But still, no performance difference.
>> As soon as I play with vruntime I do see a difference (but only without the cpu cgroup
>> controller). I will try to better understand the scheduler logic and do some more
>> testing. If you have anything that I should test, let me know.
>>
>> Christian
> 
> If both yielder and target are in the same cpu cgroup or the cpu cgroup
> is disabled (ie, if cfs_rq_of(p->se) matches), you could try
> 
> if (p->se.vruntime > rq->curr->se.vruntime)
> 	swap(p->se.vruntime, rq->curr->se.vruntime)

I tried that and it does not show the performance benefit. I then played with my
patch (uses different values to add) and the benefit seems to be depending on the
size that is being added, maybe when swapping it was just not large enough.

I have to say that this is all a bit unclear what and why performance improves.
It just seems that the cpu cgroup controller has a fair share of the performance
problems.

I also asked the performance people to run some measurements and the numbers of
some transactional workload under KVM was
baseline: 11813
with much smaller sched_latency_ns and sched_migration_cost_ns: 16419
with cpu controller disabled: 15962
with cpu controller disabled + my patch: 16782

I will be travelling the next 2 weeks, so I can continue with more debugging
after that.

Thanks for all the ideas and help so far.

Christian

> as well as the existing buddy flags, as an entirely fair vruntime boost
> to the target.
> 
> For when they aren't direct siblings, you /could/ use find_matching_se,
> but it's much less clear that's desirable, since it would yield vruntime
> for the entire hierarchy to the target's hierarchy.
> 
