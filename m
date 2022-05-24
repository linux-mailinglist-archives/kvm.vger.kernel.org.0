Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D39BE532FB8
	for <lists+kvm@lfdr.de>; Tue, 24 May 2022 19:41:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239991AbiEXRlf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 May 2022 13:41:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240076AbiEXRlV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 May 2022 13:41:21 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAD7EAE42;
        Tue, 24 May 2022 10:41:20 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24OHLYR1017679;
        Tue, 24 May 2022 17:41:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=aeMsVA3avnUUTryRjKo79hlrUHkfHf9mCpmOM3tn6qQ=;
 b=L/frL0S80sc0rrhAT4ta++eCKyMO6+n9LveCbwqSO2K7vy77MvEdA0zLR/G5WX7EE8Qf
 RZkXHsqgnEZ0A6jYWPTnZvlwVMU58RXBUc9qIXeOx+wpqr7dio267x+fJB1DzH9sSg5d
 Ffsu1FPCpkc+JbK9U8pTn2QgKFbpsQehAfPrdR0ZRKGXJ8vWRwWOuVnLjJMOnEDI4sNH
 1cqe1lZ8r/QyOrRdvEOupFmi4vSziz2Ze01pcVEOo2A6V1L7UrhTK4YjaNPV84mntX1V
 gURPlQE8fYhVMkH8LU5+ql5JApslyficeAtqVg1TPc2FDlzwr8sDgost8MMc4GQ0Itsm JA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g93pp8avb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 May 2022 17:41:18 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24OHPeR1008006;
        Tue, 24 May 2022 17:41:17 GMT
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g93pp8av1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 May 2022 17:41:17 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24OHXPEp031032;
        Tue, 24 May 2022 17:41:17 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma02dal.us.ibm.com with ESMTP id 3g93v801u1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 May 2022 17:41:16 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24OHfF0c22348182
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 May 2022 17:41:16 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DC3A1AC064;
        Tue, 24 May 2022 17:41:15 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8C98BAC05F;
        Tue, 24 May 2022 17:41:14 +0000 (GMT)
Received: from [9.160.37.241] (unknown [9.160.37.241])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 24 May 2022 17:41:14 +0000 (GMT)
Message-ID: <24aaa840-7643-75c0-1517-5a357183bf07@linux.ibm.com>
Date:   Tue, 24 May 2022 13:41:13 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v19 02/20] s390/vfio-ap: move probe and remove callbacks
 to vfio_ap_ops.c
Content-Language: en-US
To:     jjherne@linux.ibm.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com
References: <20220404221039.1272245-1-akrowiak@linux.ibm.com>
 <20220404221039.1272245-3-akrowiak@linux.ibm.com>
 <c705be10-bbe2-7d44-3057-005299ab6785@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
In-Reply-To: <c705be10-bbe2-7d44-3057-005299ab6785@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: fC7SGWCYW3Nt5Qa9Z_uMhy3lOweaNCvu
X-Proofpoint-GUID: m1DpZdQ3X9zWPcZzXvYROoaSAJx2ht1y
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-24_08,2022-05-23_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 spamscore=0 impostorscore=0 lowpriorityscore=0 malwarescore=0 bulkscore=0
 phishscore=0 mlxscore=0 mlxlogscore=999 adultscore=0 suspectscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205240088
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/24/22 10:49 AM, Jason J. Herne wrote:
> On 4/4/22 18:10, Tony Krowiak wrote:
>> Let's move the probe and remove callbacks into the vfio_ap_ops.c
>> file to keep all code related to managing queues in a single file. This
>> way, all functions related to queue management can be removed from the
>> vfio_ap_private.h header file defining the public interfaces for the
>> vfio_ap device driver.
>>
>> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
>> Reviewed-by: Halil Pasic <pasic@linux.ibm.com>
>> ---
>>   drivers/s390/crypto/vfio_ap_drv.c     | 59 +--------------------------
>>   drivers/s390/crypto/vfio_ap_ops.c     | 31 +++++++++++++-
>>   drivers/s390/crypto/vfio_ap_private.h |  5 ++-
>>   3 files changed, 34 insertions(+), 61 deletions(-)
>>
>> diff --git a/drivers/s390/crypto/vfio_ap_drv.c 
>> b/drivers/s390/crypto/vfio_ap_drv.c
>> index 29ebd54f8919..9a300dd3b6f7 100644
>> --- a/drivers/s390/crypto/vfio_ap_drv.c
>> +++ b/drivers/s390/crypto/vfio_ap_drv.c
>> @@ -104,64 +104,9 @@ static const struct attribute_group 
>> vfio_queue_attr_group = {
>>       .attrs = vfio_queue_attrs,
>>   };
>>   -/**
>> - * vfio_ap_queue_dev_probe: Allocate a vfio_ap_queue structure and 
>> associate it
>> - *                with the device as driver_data.
>> - *
>> - * @apdev: the AP device being probed
>> - *
>> - * Return: returns 0 if the probe succeeded; otherwise, returns an 
>> error if
>> - *       storage could not be allocated for a vfio_ap_queue object 
>> or the
>> - *       sysfs 'status' attribute could not be created for the queue 
>> device.
>> - */
>> -static int vfio_ap_queue_dev_probe(struct ap_device *apdev)
>> -{
>> -    int ret;
>> -    struct vfio_ap_queue *q;
>> -
>> -    q = kzalloc(sizeof(*q), GFP_KERNEL);
>> -    if (!q)
>> -        return -ENOMEM;
>> -
>> -    mutex_lock(&matrix_dev->lock);
>> -    dev_set_drvdata(&apdev->device, q);
>> -    q->apqn = to_ap_queue(&apdev->device)->qid;
>> -    q->saved_isc = VFIO_AP_ISC_INVALID;
>> -
>> -    ret = sysfs_create_group(&apdev->device.kobj, 
>> &vfio_queue_attr_group);
>> -    if (ret) {
>> -        dev_set_drvdata(&apdev->device, NULL);
>> -        kfree(q);
>> -    }
>> -
>> -    mutex_unlock(&matrix_dev->lock);
>> -
>> -    return ret;
>> -}
>> -
>> -/**
>> - * vfio_ap_queue_dev_remove: Free the associated vfio_ap_queue 
>> structure.
>> - *
>> - * @apdev: the AP device being removed
>> - *
>> - * Takes the matrix lock to avoid actions on this device while doing 
>> the remove.
>> - */
>> -static void vfio_ap_queue_dev_remove(struct ap_device *apdev)
>> -{
>> -    struct vfio_ap_queue *q;
>> -
>> -    mutex_lock(&matrix_dev->lock);
>> -    sysfs_remove_group(&apdev->device.kobj, &vfio_queue_attr_group);
>> -    q = dev_get_drvdata(&apdev->device);
>> -    vfio_ap_mdev_reset_queue(q, 1);
>> -    dev_set_drvdata(&apdev->device, NULL);
>> -    kfree(q);
>> -    mutex_unlock(&matrix_dev->lock);
>> -}
>> -
>>   static struct ap_driver vfio_ap_drv = {
>> -    .probe = vfio_ap_queue_dev_probe,
>> -    .remove = vfio_ap_queue_dev_remove,
>> +    .probe = vfio_ap_mdev_probe_queue,
>> +    .remove = vfio_ap_mdev_remove_queue,
>>       .ids = ap_queue_ids,
>>   };
>>   diff --git a/drivers/s390/crypto/vfio_ap_ops.c 
>> b/drivers/s390/crypto/vfio_ap_ops.c
>> index 2227919fde13..16220157dbe3 100644
>> --- a/drivers/s390/crypto/vfio_ap_ops.c
>> +++ b/drivers/s390/crypto/vfio_ap_ops.c
>> @@ -1314,8 +1314,7 @@ static struct vfio_ap_queue 
>> *vfio_ap_find_queue(int apqn)
>>       return q;
>>   }
>>   -int vfio_ap_mdev_reset_queue(struct vfio_ap_queue *q,
>> -                 unsigned int retry)
>> +static int vfio_ap_mdev_reset_queue(struct vfio_ap_queue *q, 
>> unsigned int retry)
>>   {
>>       struct ap_queue_status status;
>>       int ret;
>> @@ -1524,3 +1523,31 @@ void vfio_ap_mdev_unregister(void)
>>       mdev_unregister_device(&matrix_dev->device);
>>       mdev_unregister_driver(&vfio_ap_matrix_driver);
>>   }
>> +
>> +int vfio_ap_mdev_probe_queue(struct ap_device *apdev)
>> +{
>> +    struct vfio_ap_queue *q;
>> +
>> +    q = kzalloc(sizeof(*q), GFP_KERNEL);
>> +    if (!q)
>> +        return -ENOMEM;
>> +    mutex_lock(&matrix_dev->lock);
>> +    q->apqn = to_ap_queue(&apdev->device)->qid;
>> +    q->saved_isc = VFIO_AP_ISC_INVALID;
>> +    dev_set_drvdata(&apdev->device, q);
>> +    mutex_unlock(&matrix_dev->lock);
>> +
>> +    return 0;
>> +}
>> +
>> +void vfio_ap_mdev_remove_queue(struct ap_device *apdev)
>> +{
>> +    struct vfio_ap_queue *q;
>> +
>> +    mutex_lock(&matrix_dev->lock);
>> +    q = dev_get_drvdata(&apdev->device);
>> +    vfio_ap_mdev_reset_queue(q, 1);
>> +    dev_set_drvdata(&apdev->device, NULL);
>> +    kfree(q);
>> +    mutex_unlock(&matrix_dev->lock);
>> +}
>> diff --git a/drivers/s390/crypto/vfio_ap_private.h 
>> b/drivers/s390/crypto/vfio_ap_private.h
>> index 648fcaf8104a..3cade25a1620 100644
>> --- a/drivers/s390/crypto/vfio_ap_private.h
>> +++ b/drivers/s390/crypto/vfio_ap_private.h
>> @@ -119,7 +119,8 @@ struct vfio_ap_queue {
>>     int vfio_ap_mdev_register(void);
>>   void vfio_ap_mdev_unregister(void);
>> -int vfio_ap_mdev_reset_queue(struct vfio_ap_queue *q,
>> -                 unsigned int retry);
>> +
>> +int vfio_ap_mdev_probe_queue(struct ap_device *queue);
>> +void vfio_ap_mdev_remove_queue(struct ap_device *queue);
>>     #endif /* _VFIO_AP_PRIVATE_H_ */
>
>
> With this commit, you did more than just move the probe/remove 
> functions. You also changed their behavior. The call to 
> sysfs_create_group has been removed. So the following in vfop_ap_drv.c 
> becomes dead code:
>
>     vfio_ap_mdev_for_queue
>     status_show
>     static DEVICE_ATTR_RO(status);
>     vfio_queue_attrs
>     vfio_queue_attr_group
>
> Is this what you intended? If so, I assume we can live without the 
> status attribute?
> If this is the case then you'll want to remove all the dead code.

This was not intended. The status attribute was added via commit 
f139862b92cf which
was merged into the KVM last October. I believe it may have been removed 
when this
was rebased on the release containing that patch. I'll reinstate that 
attribute as it is
necessary. Thanks and good catch.

>
>

