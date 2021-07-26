Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 273143D66D5
	for <lists+kvm@lfdr.de>; Mon, 26 Jul 2021 20:42:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231965AbhGZSBf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jul 2021 14:01:35 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:4856 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231912AbhGZSBe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 26 Jul 2021 14:01:34 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16QIc0vb050909;
        Mon, 26 Jul 2021 14:41:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=/drKpJyCSOdSQ/VwlZaz++Z20EYgiAUy2f+BWfPUf68=;
 b=JGkwSJ/yMJf0q0sZn7nyj5FEK2/A0SH8qQ8MRokODf9H1pXpS+XT5Rs6vtAI3e7CX0rJ
 YOhhWj5C5N+r92rgjD5KiA1Wwonk/YNI5RUqAHI6R0nK2WXMvPZaVMJc6wdy3WGklinq
 dmLl9MMyWPKYgUASbTzZoj49I07hkJwTunAeB/0FrI6jsRlbWLybHC7QtpZIe/vyPE1a
 eW9PlQFNq/FcX2eJOPuK9YhXpThXUP+G1oWI+K3WrxZYb0dsnGEjeQ7YkCvBKN3OM91d
 T+6XorrELvCLJO/omNexIrW6r18lvAIEe7E29RS/FaRRywV0uvRh51ygya/Axz67LzG+ Jw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a225grnxu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 26 Jul 2021 14:41:21 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16QIcO6W052309;
        Mon, 26 Jul 2021 14:41:21 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a225grnw3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 26 Jul 2021 14:41:21 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16QIXPjI028222;
        Mon, 26 Jul 2021 18:41:18 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3a0ag897n2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 26 Jul 2021 18:41:18 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16QIccfx20840798
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Jul 2021 18:38:38 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5CD3D5204E;
        Mon, 26 Jul 2021 18:41:16 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.145.6.229])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id B41755204F;
        Mon, 26 Jul 2021 18:41:15 +0000 (GMT)
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
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <1acd7520-bd4b-d43d-302a-8dcacf6defa5@de.ibm.com>
Date:   Mon, 26 Jul 2021 20:41:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210723162137.GY3809@techsingularity.net>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: FEClkrWfQx1pS3l0oXxxkQDYMkmMdcW0
X-Proofpoint-ORIG-GUID: 35pKIn3gVvjRB9kT4CTsZ-7vjpSZ9IK8
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-26_12:2021-07-26,2021-07-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 phishscore=0 impostorscore=0 mlxscore=0 adultscore=0
 malwarescore=0 priorityscore=1501 mlxlogscore=999 clxscore=1015
 spamscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107260108
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 23.07.21 18:21, Mel Gorman wrote:
> On Fri, Jul 23, 2021 at 02:36:21PM +0200, Christian Borntraeger wrote:
>>> sched: Do not select highest priority task to run if it should be skipped
>>>
>>> <SNIP>
>>>
>>> index 44c452072a1b..ddc0212d520f 100644
>>> --- a/kernel/sched/fair.c
>>> +++ b/kernel/sched/fair.c
>>> @@ -4522,7 +4522,8 @@ pick_next_entity(struct cfs_rq *cfs_rq, struct sched_entity *curr)
>>>    			se = second;
>>>    	}
>>> -	if (cfs_rq->next && wakeup_preempt_entity(cfs_rq->next, left) < 1) {
>>> +	if (cfs_rq->next &&
>>> +	    (cfs_rq->skip == left || wakeup_preempt_entity(cfs_rq->next, left) < 1)) {
>>>    		/*
>>>    		 * Someone really wants this to run. If it's not unfair, run it.
>>>    		 */
>>>
>>
>> I do see a reduction in ignored yields, but from a performance aspect for my
>> testcases this patch does not provide a benefit, while the the simple
>> 	curr->vruntime += sysctl_sched_min_granularity;
>> does.
> 
> I'm still not a fan because vruntime gets distorted. From the docs
> 
>     Small detail: on "ideal" hardware, at any time all tasks would have the same
>     p->se.vruntime value --- i.e., tasks would execute simultaneously and no task
>     would ever get "out of balance" from the "ideal" share of CPU time
> 
> If yield_to impacts this "ideal share" then it could have other
> consequences.
> 
> I think your patch may be performing better in your test case because every
> "wrong" task selected that is not the yield_to target gets penalised and
> so the yield_to target gets pushed up the list.
> 
>> I still think that your approach is probably the cleaner one, any chance to improve this
>> somehow?
>>
> 
> Potentially. The patch was a bit off because while it noticed that skip
> was not being obeyed, the fix was clumsy and isolated. The current flow is
> 
> 1. pick se == left as the candidate
> 2. try pick a different se if the "ideal" candidate is a skip candidate
> 3. Ignore the se update if next or last are set
> 
> Step 3 looks off because it ignores skip if next or last buddies are set
> and I don't think that was intended. Can you try this?
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 44c452072a1b..d56f7772a607 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -4522,12 +4522,12 @@ pick_next_entity(struct cfs_rq *cfs_rq, struct sched_entity *curr)
>   			se = second;
>   	}
>   
> -	if (cfs_rq->next && wakeup_preempt_entity(cfs_rq->next, left) < 1) {
> +	if (cfs_rq->next && wakeup_preempt_entity(cfs_rq->next, se) < 1) {
>   		/*
>   		 * Someone really wants this to run. If it's not unfair, run it.
>   		 */
>   		se = cfs_rq->next;
> -	} else if (cfs_rq->last && wakeup_preempt_entity(cfs_rq->last, left) < 1) {
> +	} else if (cfs_rq->last && wakeup_preempt_entity(cfs_rq->last, se) < 1) {
>   		/*
>   		 * Prefer last buddy, try to return the CPU to a preempted task.
>   		 */
> 

This one alone does not seem to make a difference. Neither in ignored yield, nor
in performance.

Your first patch does really help in terms of ignored yields when
all threads are pinned to one host CPU. After that we do have no ignored yield
it seems. But it does not affect the performance of my testcase.
I did some more experiments and I removed the wakeup_preempt_entity checks in
pick_next_entity - assuming that this will result in source always being stopped
and target always being picked. But still, no performance difference.
As soon as I play with vruntime I do see a difference (but only without the cpu cgroup
controller). I will try to better understand the scheduler logic and do some more
testing. If you have anything that I should test, let me know.

Christian
