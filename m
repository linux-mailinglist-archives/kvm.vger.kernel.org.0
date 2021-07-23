Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F4813D3A59
	for <lists+kvm@lfdr.de>; Fri, 23 Jul 2021 14:37:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234864AbhGWL4i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Jul 2021 07:56:38 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:35414 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234601AbhGWL4h (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 23 Jul 2021 07:56:37 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16NCWcj8089636;
        Fri, 23 Jul 2021 08:36:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=UBwwbHNFTltVZ16imvvarg3MRaB3K7QyU4RhoBUfrLc=;
 b=B37CWwE37wMvq7LWImvZ3WPTO53aTZZ6JsVEnNNRdWcdysG9Zi1ij3FEkI3+WUdXqAR6
 Y3ud+GdoQRl9cvsOVg1ZbKYwTH05CE0C/bQFwmoyA2lAoh49k3MKhDE9/echH6iWEw6d
 kBzN5yfWQvKNSNrtA5YMGzIRF0TsMnem9yuRdJiHpXwfoGxV8MTklyOHXOswP1R87MdI
 +r32Yf6Ufa9ztFDKuft/axbDbYVzyi1bsV0VPmrhbf6aa4ia9Yxm/g1hWeliR/Xe99vZ
 masdJjbtaOuWeduT1SLSqC65vP5IrfJBH/9e2ci3VdTR4dzsQ1vhA/gcQN4+elEcNkYg Ew== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39ywk4gsmj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 23 Jul 2021 08:36:28 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16NCWpi1090483;
        Fri, 23 Jul 2021 08:36:28 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39ywk4gsks-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 23 Jul 2021 08:36:28 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16NCRUlT004819;
        Fri, 23 Jul 2021 12:36:26 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 39vng72nhh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 23 Jul 2021 12:36:26 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16NCaNKS25690474
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Jul 2021 12:36:23 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AC81542045;
        Fri, 23 Jul 2021 12:36:23 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0B9CC42054;
        Fri, 23 Jul 2021 12:36:23 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.145.25.128])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 23 Jul 2021 12:36:22 +0000 (GMT)
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
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <ddb81bc9-1429-c392-adac-736e23977c84@de.ibm.com>
Date:   Fri, 23 Jul 2021 14:36:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210723093523.GX3809@techsingularity.net>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: -NUXTObVFEL_2qBz5ys066VUffwwt3Xt
X-Proofpoint-GUID: sWkq2cIXFjZugwzHhOOoTI6RbyYKl6lW
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-23_05:2021-07-23,2021-07-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 impostorscore=0
 adultscore=0 mlxscore=0 malwarescore=0 bulkscore=0 lowpriorityscore=0
 priorityscore=1501 suspectscore=0 mlxlogscore=999 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107230074
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 23.07.21 11:35, Mel Gorman wrote:
> On Wed, Jul 07, 2021 at 02:34:02PM +0200, Christian Borntraeger wrote:
>> After some debugging in situations where a smaller sched_latency_ns and
>> smaller sched_migration_cost settings helped for KVM host, I was able to
>> come up with a reduced testcase.
>> This testcase has 2 vcpus working on a shared memory location and
>> waiting for mem % 2 == cpu number to then do an add on the shared
>> memory.
>> To start simple I pinned all vcpus to one host CPU. Without the
>> yield_to in KVM the testcase was horribly slow. This is expected as each
>> vcpu will spin a whole time slice. With the yield_to from KVM things are
>> much better, but I was still seeing yields being ignored.
>> In the end pick_next_entity decided to keep the current process running
>> due to fairness reasons.  On this path we really know that there is no
>> point in continuing current. So let us make things a bit unfairer to
>> current.
>> This makes the reduced testcase noticeable faster. It improved a more
>> realistic test case (many guests on some host CPUs with overcomitment)
>> even more.
>> In the end this is similar to the old compat_sched_yield approach with
>> an important difference:
>> Instead of doing it for all yields we now only do it for yield_to
>> a place where we really know that current it waiting for the target.
>>
>> What are alternative implementations for this patch
>> - do the same as the old compat_sched_yield:
>>    current->vruntime = rightmost->vruntime+1
>> - provide a new tunable sched_ns_yield_penalty: how much vruntime to add
>>    (could be per architecture)
>> - also fiddle with the vruntime of the target
>>    e.g. subtract from the target what we add to the source
>>
>> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> 
> I think this one accidentally fell off everyones radar including mine.
> At the time this patch was mailed I remembered thinking that playing games with
> vruntime might have other consequences. For example, what I believe is
> the most relevant problem for KVM is that a task spinning to acquire a
> lock may be waiting on a vcpu holding the lock that has been
> descheduled. Without vcpu pinning, it's possible that the holder is on
> the same runqueue as the lock acquirer so the acquirer is wasting CPU.
> 
> In such a case, changing the acquirers vcpu may mean that it unfairly
> loses CPU time simply because it's a lock acquirer. Vincent, what do you
> think? Christian, would you mind testing this as an alternative with your
> demonstration test case and more importantly the "realistic test case"?
> 
> --8<--
> sched: Do not select highest priority task to run if it should be skipped
> 
> pick_next_entity will consider the "next buddy" over the highest priority
> task if it's not unfair to do so (as determined by wakekup_preempt_entity).
> The potential problem is that an in-kernel user of yield_to() such as
> KVM may explicitly want to yield the current task because it is trying
> to acquire a spinlock from a task that is currently descheduled and
> potentially running on the same runqueue. However, if it's more fair from
> the scheduler perspective to continue running the current task, it'll continue
> to spin uselessly waiting on a descheduled task to run.
> 
> This patch will select the targeted task to run even if it's unfair if the
> highest priority task is explicitly marked as "skip".
> 
> This was evaluated using a debugging patch to expose yield_to as a system
> call. A demonstration program creates N number of threads and arranges
> them in a ring that are updating a shared value in memory. Each thread
> spins until the value matches the thread ID. It then updates the value
> and wakes the next thread in the ring. It measures how many times it spins
> before it gets its turn. Without the patch, the number of spins is highly
> variable and unstable but with the patch it's more consistent.
> 
> Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
> ---
>   kernel/sched/fair.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 44c452072a1b..ddc0212d520f 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -4522,7 +4522,8 @@ pick_next_entity(struct cfs_rq *cfs_rq, struct sched_entity *curr)
>   			se = second;
>   	}
>   
> -	if (cfs_rq->next && wakeup_preempt_entity(cfs_rq->next, left) < 1) {
> +	if (cfs_rq->next &&
> +	    (cfs_rq->skip == left || wakeup_preempt_entity(cfs_rq->next, left) < 1)) {
>   		/*
>   		 * Someone really wants this to run. If it's not unfair, run it.
>   		 */
> 

I do see a reduction in ignored yields, but from a performance aspect for my
testcases this patch does not provide a benefit, while the the simple
	curr->vruntime += sysctl_sched_min_granularity;
does.
I still think that your approach is probably the cleaner one, any chance to improve this
somehow?

FWIW,  I recently realized that my patch also does not solve the problem for KVM with libvirt.
My testcase only improves with qemu started by hand. As soon as the cpu cgroup controller is
active, my patch also no longer helps.

If you have any patch to test, I can test it. Meanwhile I will also do some more testing.
