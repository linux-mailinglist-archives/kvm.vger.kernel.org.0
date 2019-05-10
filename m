Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09B791A14D
	for <lists+kvm@lfdr.de>; Fri, 10 May 2019 18:22:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727592AbfEJQWA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 May 2019 12:22:00 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:36692 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727271AbfEJQV7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 10 May 2019 12:21:59 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4AGLXaU100859
        for <kvm@vger.kernel.org>; Fri, 10 May 2019 12:21:58 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2sdb6vceqa-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 10 May 2019 12:21:57 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pmorel@linux.ibm.com>;
        Fri, 10 May 2019 17:21:56 +0100
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 10 May 2019 17:21:54 +0100
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x4AGLqLj26083342
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 May 2019 16:21:52 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 60D205204F;
        Fri, 10 May 2019 16:21:52 +0000 (GMT)
Received: from [9.145.187.238] (unknown [9.145.187.238])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id B74575204E;
        Fri, 10 May 2019 16:21:51 +0000 (GMT)
Reply-To: pmorel@linux.ibm.com
Subject: Re: [PATCH v8 3/4] s390: ap: implement PAPQ AQIC interception in
 kernel
To:     Tony Krowiak <akrowiak@linux.ibm.com>, borntraeger@de.ibm.com
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, frankja@linux.ibm.com, pasic@linux.ibm.com,
        david@redhat.com, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, freude@linux.ibm.com, mimu@linux.ibm.com
References: <1556818451-1806-1-git-send-email-pmorel@linux.ibm.com>
 <1556818451-1806-4-git-send-email-pmorel@linux.ibm.com>
 <adcec876-22f5-89fb-3dcc-ad843d6f8f64@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Date:   Fri, 10 May 2019 18:21:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <adcec876-22f5-89fb-3dcc-ad843d6f8f64@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19051016-0016-0000-0000-0000027A6758
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19051016-0017-0000-0000-000032D723CF
Message-Id: <754503da-5e90-d1af-34ba-e33975129118@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-09_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905100111
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/05/2019 22:17, Tony Krowiak wrote:
> On 5/2/19 1:34 PM, Pierre Morel wrote:
>> We register a AP PQAP instruction hook during the open
>> of the mediated device. And unregister it on release.
>>
>> During the probe of the AP device, we allocate a vfio_ap_queue
>> structure to keep track of the information we need for the
>> PQAP/AQIC instruction interception.
>>
>> In the AP PQAP instruction hook, if we receive a demand to
>> enable IRQs,
>> - we retrieve the vfio_ap_queue based on the APQN we receive
>>    in REG1,
>> - we retrieve the page of the guest address, (NIB), from
>>    register REG2
>> - we retrieve the mediated device to use the VFIO pinning
>>    infrastructure to pin the page of the guest address,
>> - we retrieve the pointer to KVM to register the guest ISC
>>    and retrieve the host ISC
>> - finaly we activate GISA
>>
>> If we receive a demand to disable IRQs,
>> - we deactivate GISA
>> - unregister from the GIB
>> - unping the NIB
> 
> s/unping/unpin

yes, thanks,

> 

...snip...

>>   static void vfio_ap_queue_dev_remove(struct ap_device *apdev)
>>   {
>> -    /* Nothing to do yet */
>> +    struct vfio_ap_queue *q;
>> +    int apid, apqi;
>> +
>> +    mutex_lock(&matrix_dev->lock);
>> +    q = dev_get_drvdata(&apdev->device);
>> +    dev_set_drvdata(&apdev->device, NULL);
>> +    if (q) {
>> +        apid = AP_QID_CARD(q->apqn);
>> +        apqi = AP_QID_QUEUE(q->apqn);
>> +        vfio_ap_mdev_reset_queue(apid, apqi, 1);
> 
> As you know, there is another patch series (s390: vfio-ap: dynamic
> configuration support) posted concurrently with this series. That series
> handles reset on remove of an AP queue device. It looks like your
> choices here will greatly conflict with the reset processing in the
> other patch series and create a nasty merge conflict. My suggestion is
> that you build this patch series on top of the other series and do
> the following:
> 
> There are two new functions introduced in vfio_ap_private.h:
> void vfio_ap_mdev_remove_queue(struct ap_queue *queue);
> void vfio_ap_mdev_probe_queue(struct ap_queue *queue);
> 
> These are called from the probe and remove callbacks in vfio_ap_drv.c.
> If you embed your changes to the probe and remove functions above into
> those new functions, that will make merging the two much easier and
> the code cleaner IMHO.

The merging is really limited
The dynamic configuration patches series is new and I am not sure it 
will satisfy Harald and Reinhard, doing so would delay the IRQ patch 
series for an unknown among of time.
I am not sure it is so wise.

May be an other opinion?


Whatever, we can share the reset function, it is independent of the 
series, for my opinion it could go its own way.
I can take your patch.

...snip...

>> +struct ap_queue_status vfio_ap_irq_disable(struct vfio_ap_queue *q)
>> +{
>> +    struct ap_qirq_ctrl aqic_gisa;
>> +    struct ap_queue_status status = {
>> +            .response_code = AP_RESPONSE_Q_NOT_AVAIL,
>> +            };
>> +    int retry_tapq = 5;
>> +    int retry_aqic = 5;
>> +
>> +    if (!q)
> 
> When will q ever be NULL? I checked all places where this is called and
> it looks to me like this will never happen.
> 

OK, I check, may be too carefull.

>> +        return status;
>> +
>> +again:
> 
> I'm not crazy about using a label, why not a do/while
> loop or something of that nature?

I will try this way.

> 
>> +    status = ap_aqic(q->apqn, aqic_gisa, NULL);
>> +    switch (status.response_code) {
>> +    case AP_RESPONSE_OTHERWISE_CHANGED:
>> +    case AP_RESPONSE_RESET_IN_PROGRESS:
>> +    case AP_RESPONSE_NORMAL: /* Fall through */
>> +        while (status.irq_enabled && retry_tapq--) {
>> +            msleep(20);
>> +            status = ap_tapq(q->apqn, NULL);
> 
> Shouldn't you be checking response codes from the TAPQ
> function? Maybe there should be a function call here to
> with for IRQ disabled?

OK

Thanks,
Pierre



-- 
Pierre Morel
Linux/KVM/QEMU in Böblingen - Germany

