Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 887DB279439
	for <lists+kvm@lfdr.de>; Sat, 26 Sep 2020 00:29:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729181AbgIYW3X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Sep 2020 18:29:23 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:43390 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727258AbgIYW3X (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 25 Sep 2020 18:29:23 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08PM1brh062488;
        Fri, 25 Sep 2020 18:29:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=KAELlSKVblvotA0/ks7d5Hs1O2FvF8vZrdtdzjD8A4Q=;
 b=pAW2eNqhb+sxuM+FPlgFpUW+BdW4zAY5hyFqEUMujpUs913nlSzBIi8HhiVZzKjCxVp5
 TTwSf3zqGKUtdNF6v3WZGlpe33QK6pHSa6h8nm8tXZu7+MSSKbkCf+n2knlQza15ET+y
 NLJmhF1pmJZ1Dq/0bEbX45l3tti5cjanPHhGCKEnIgDt9LR/nQupvI0otr0TWHcJ4DAC
 XAFl3VOiX54lLFXsT4AXkpXbQuyFJC96HHm+oWQFBD8d2xga5+NJ2BMYe8n3QKvc1WIn
 HEALO/UHlq97NGb9zw2VIHJnTaYS7GE06cEJhgn3mntyYeOJRnZMjFxqRQCt4B7Idffj Fg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33sqnwt912-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Sep 2020 18:29:20 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08PM2Kuk068068;
        Fri, 25 Sep 2020 18:29:20 -0400
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33sqnwt90m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Sep 2020 18:29:20 -0400
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08PMMNEj010083;
        Fri, 25 Sep 2020 22:29:19 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma01wdc.us.ibm.com with ESMTP id 33q41htgje-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Sep 2020 22:29:19 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08PMTEsk30867966
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Sep 2020 22:29:14 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A7220136051;
        Fri, 25 Sep 2020 22:29:18 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A4FDE13604F;
        Fri, 25 Sep 2020 22:29:17 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.85.170.177])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 25 Sep 2020 22:29:17 +0000 (GMT)
Subject: Re: [PATCH] s390/vfio-ap: fix unregister GISC when KVM is already
 gone results in OOPS
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, pmorel@linux.ibm.com,
        alex.williamson@redhat.com, cohuck@redhat.com,
        kwankhede@nvidia.com, borntraeger@de.ibm.com
References: <20200918170234.5807-1-akrowiak@linux.ibm.com>
 <20200921174536.49e45e68.pasic@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <3795bc75-9d5e-2098-fd18-f1cbaef9c290@linux.ibm.com>
Date:   Fri, 25 Sep 2020 18:29:16 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200921174536.49e45e68.pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-25_19:2020-09-24,2020-09-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=2 adultscore=0
 malwarescore=0 bulkscore=0 clxscore=1015 priorityscore=1501
 impostorscore=0 mlxlogscore=999 lowpriorityscore=0 spamscore=0
 phishscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009250157
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 9/21/20 11:45 AM, Halil Pasic wrote:
> On Fri, 18 Sep 2020 13:02:34 -0400
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>
>> Attempting to unregister Guest Interruption Subclass (GISC) when the
>> link between the matrix mdev and KVM has been removed results in the
>> following:
>>
>>     "Kernel panic -not syncing: Fatal exception: panic_on_oops"
>>
>> This patch fixes this bug by verifying the matrix mdev and KVM are still
>> linked prior to unregistering the GISC.
>
> I read from your commit message that this happens when the link between
> the KVM and the matrix mdev was established and then got severed.
>
> I assume the interrupts were previously enabled, and were not been
> disabled or cleaned up because q->saved_isc != VFIO_AP_ISC_INVALID.
>
> That means the guest enabled  interrupts and then for whatever
> reason got destroyed, and this happens on mdev cleanup.
>
> Does it happen all the time or is it some sort of a race?

This is a race condition that happens when a guest is terminated and the 
mdev is
removed in rapid succession. I came across it with one of my hades test 
cases
on cleanup of the resources after the test case completes. There is a 
bug in the problem appears
the vfio_ap_mdev_release function because it tries to reset the APQNs 
after the bits are
cleared from the matrix_mdev.matrix, so the resets never happen.

Fixing that, however, does not resolve the issue, so I'm in the process 
of doing a bunch of
tracing to see the flow of the resets etc. during the lifecycle of the 
mdev during this
hades test. I should have a better answer next week.

>
>> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
>> ---
>>   drivers/s390/crypto/vfio_ap_ops.c | 14 +++++++++-----
>>   1 file changed, 9 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
>> index e0bde8518745..847a88642644 100644
>> --- a/drivers/s390/crypto/vfio_ap_ops.c
>> +++ b/drivers/s390/crypto/vfio_ap_ops.c
>> @@ -119,11 +119,15 @@ static void vfio_ap_wait_for_irqclear(int apqn)
>>    */
>>   static void vfio_ap_free_aqic_resources(struct vfio_ap_queue *q)
>>   {
>> -	if (q->saved_isc != VFIO_AP_ISC_INVALID && q->matrix_mdev)
>> -		kvm_s390_gisc_unregister(q->matrix_mdev->kvm, q->saved_isc);
>> -	if (q->saved_pfn && q->matrix_mdev)
>> -		vfio_unpin_pages(mdev_dev(q->matrix_mdev->mdev),
>> -				 &q->saved_pfn, 1);
>> +	if (q->matrix_mdev) {
>> +		if (q->saved_isc != VFIO_AP_ISC_INVALID && q->matrix_mdev->kvm)
>> +			kvm_s390_gisc_unregister(q->matrix_mdev->kvm,
>> +						 q->saved_isc);
> I don't quite understand the logic here. I suppose we need to ensure
> that the struct kvm is 'alive' at least until kvm_s390_gisc_unregister()
> is done. That is supposed be ensured by kvm_get_kvm() in
> vfio_ap_mdev_set_kvm() and kvm_put_kvm() in vfio_ap_mdev_release().
>
> If the critical section in vfio_ap_mdev_release() is done and
> matrix_mdev->kvm was set to NULL there then I would expect that the
> queues are already reset and q->saved_isc == VFIO_AP_ISC_INVALID. So
> this should not blow up.
>
> Now if this happens before the critical section in
> vfio_ap_mdev_release() is done, I ask myself how are we going to do the
> kvm_put_kvm()?
>
> Another question. Do we hold the matrix_dev->lock here?
>
>> +		if (q->saved_pfn)
>> +			vfio_unpin_pages(mdev_dev(q->matrix_mdev->mdev),
>> +					 &q->saved_pfn, 1);
>> +	}
>> +
>>   	q->saved_pfn = 0;
>>   	q->saved_isc = VFIO_AP_ISC_INVALID;
>>   }

