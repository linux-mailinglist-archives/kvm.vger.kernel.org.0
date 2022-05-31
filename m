Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63B4653903E
	for <lists+kvm@lfdr.de>; Tue, 31 May 2022 14:02:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344072AbiEaMCw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 May 2022 08:02:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233781AbiEaMCu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 May 2022 08:02:50 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EACBE5BE6C;
        Tue, 31 May 2022 05:02:48 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24VADr19008901;
        Tue, 31 May 2022 12:02:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=HAMbekByJXG5Ra0WnTNf1/wCwfvbw7mnCQYVB8/zg7I=;
 b=ch5uC3X18zYSIQJhIlGnzraA87txyYPEp/1fqLub7wsd0AbQ6/RIyFonXP1CUk/kMdrc
 jQaEJci7lVKFWTsPSMniRztpWON7B6ESfybB//S5Q8TwhrHowdX1s7LOPBbDrdR8Q5/f
 BtR9UJOX2lBCoZQna1+dB6EI2WUw82gKC1gjIY+/OXJNJYAY1ZG8ZkGFIFvC4bdOjD/O
 46YJ5PJiP4EABgO5OP5N0Xqs+B2cAwvKrfQdNP5y2kMnE/Hxkv2BuS2w60pa3tOqlyTZ
 fgq+E8hiCum8F9mNNgvcC6ETSY0ovaGeTVTmG+61hhctQmego/19NwZ6S8eRLd7qzQHI kQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gdh311wcc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 31 May 2022 12:02:45 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24VBu7HH022666;
        Tue, 31 May 2022 12:02:45 GMT
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gdh311wc4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 31 May 2022 12:02:45 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24VBno77002044;
        Tue, 31 May 2022 12:02:44 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma02wdc.us.ibm.com with ESMTP id 3gbc92kude-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 31 May 2022 12:02:44 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24VC2gDh12517744
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 31 May 2022 12:02:43 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DFA14AC05B;
        Tue, 31 May 2022 12:02:42 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 37540AC060;
        Tue, 31 May 2022 12:02:42 +0000 (GMT)
Received: from [9.160.37.241] (unknown [9.160.37.241])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 31 May 2022 12:02:42 +0000 (GMT)
Message-ID: <7e561de8-be73-4b62-ea7c-36e659d87788@linux.ibm.com>
Date:   Tue, 31 May 2022 08:02:41 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v19 11/20] s390/vfio-ap: prepare for dynamic update of
 guest's APCB on queue probe/remove
Content-Language: en-US
To:     jjherne@linux.ibm.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com
References: <20220404221039.1272245-1-akrowiak@linux.ibm.com>
 <20220404221039.1272245-12-akrowiak@linux.ibm.com>
 <4d05a8f4-d2e9-bc54-3e9b-6becc3281f0f@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
In-Reply-To: <4d05a8f4-d2e9-bc54-3e9b-6becc3281f0f@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: qY9zYATb8vh31k9OrCgD9mM1I9RIuhIX
X-Proofpoint-GUID: ThUaaHt6ccLpvV0JtGLDKGRRWsKZF58c
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-05-31_04,2022-05-30_03,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0 mlxscore=0
 malwarescore=0 mlxlogscore=999 phishscore=0 bulkscore=0 spamscore=0
 impostorscore=0 suspectscore=0 priorityscore=1501 clxscore=1015
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2205310063
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/27/22 9:50 AM, Jason J. Herne wrote:
> On 4/4/22 18:10, Tony Krowiak wrote:
>> The callback functions for probing and removing a queue device must take
>> and release the locks required to perform a dynamic update of a guest's
>> APCB in the proper order.
>>
>> The proper order for taking the locks is:
>>
>>          matrix_dev->guests_lock => kvm->lock => matrix_dev->mdevs_lock
>>
>> The proper order for releasing the locks is:
>>
>>          matrix_dev->mdevs_lock => kvm->lock => matrix_dev->guests_lock
>>
>> A new helper function is introduced to be used by the probe callback to
>> acquire the required locks. Since the probe callback only has
>> access to a queue device when it is called, the helper function will 
>> find
>> the ap_matrix_mdev object to which the queue device's APQN is 
>> assigned and
>> return it so the KVM guest to which the mdev is attached can be 
>> dynamically
>> updated.
>>
>> Note that in order to find the ap_matrix_mdev (matrix_mdev) object, 
>> it is
>> necessary to search the matrix_dev->mdev_list. This presents a
>> locking order dilemma because the matrix_dev->mdevs_lock can't be 
>> taken to
>> protect against changes to the list while searching for the 
>> matrix_mdev to
>> which a queue device's APQN is assigned. This is due to the fact that 
>> the
>> proper locking order requires that the matrix_dev->mdevs_lock be taken
>> after both the matrix_mdev->kvm->lock and the matrix_dev->mdevs_lock.
>> Consequently, the matrix_dev->guests_lock will be used to protect 
>> against
>> removal of a matrix_mdev object from the list while a queue device is
>> being probed. This necessitates changes to the mdev probe/remove
>> callback functions to take the matrix_dev->guests_lock prior to removing
>> a matrix_mdev object from the list.
>>
>> A new macro is also introduced to acquire the locks required to 
>> dynamically
>> update the guest's APCB in the proper order when a queue device is
>> removed.
>>
>> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
>> ---
>>   drivers/s390/crypto/vfio_ap_ops.c | 126 +++++++++++++++++++++---------
>>   1 file changed, 88 insertions(+), 38 deletions(-)
>>
>> diff --git a/drivers/s390/crypto/vfio_ap_ops.c 
>> b/drivers/s390/crypto/vfio_ap_ops.c
>> index 2219b1069ceb..080a733f7cd2 100644
>> --- a/drivers/s390/crypto/vfio_ap_ops.c
>> +++ b/drivers/s390/crypto/vfio_ap_ops.c
>> @@ -116,6 +116,74 @@ static const struct vfio_device_ops 
>> vfio_ap_matrix_dev_ops;
>>       mutex_unlock(&matrix_dev->guests_lock);        \
>>   })
>>   +/**
>> + * vfio_ap_mdev_get_update_locks_for_apqn: retrieve the matrix mdev 
>> to which an
>> + *                       APQN is assigned and acquire the
>> + *                       locks required to update the APCB of
>> + *                       the KVM guest to which the mdev is
>> + *                       attached.
>> + *
>> + * @apqn: the APQN of a queue device.
>> + *
>> + * The proper locking order is:
>> + * 1. matrix_dev->guests_lock: required to use the KVM pointer to 
>> update a KVM
>> + *                   guest's APCB.
>> + * 2. matrix_mdev->kvm->lock:  required to update a guest's APCB
>> + * 3. matrix_dev->mdevs_lock:  required to access data stored in a 
>> matrix_mdev
>> + *
>> + * Note: If @apqn is not assigned to a matrix_mdev, the 
>> matrix_mdev->kvm->lock
>> + *     will not be taken.
>> + *
>> + * Return: the ap_matrix_mdev object to which @apqn is assigned or 
>> NULL if @apqn
>> + *       is not assigned to an ap_matrix_mdev.
>> + */
>> +static struct ap_matrix_mdev 
>> *vfio_ap_mdev_get_update_locks_for_apqn(int apqn)
>> +{
>> +    struct ap_matrix_mdev *matrix_mdev;
>> +
>> +    mutex_lock(&matrix_dev->guests_lock);
>> +
>> +    list_for_each_entry(matrix_mdev, &matrix_dev->mdev_list, node) {
>> +        if (test_bit_inv(AP_QID_CARD(apqn), matrix_mdev->matrix.apm) &&
>> +            test_bit_inv(AP_QID_QUEUE(apqn), 
>> matrix_mdev->matrix.aqm)) {
>> +            if (matrix_mdev->kvm)
>> +                mutex_lock(&matrix_mdev->kvm->lock);
>> +
>> +            mutex_lock(&matrix_dev->mdevs_lock);
>> +
>> +            return matrix_mdev;
>> +        }
>> +    }
>> +
>> +    mutex_lock(&matrix_dev->mdevs_lock);
>> +
>> +    return NULL;
>> +}
>> +
>> +/**
>> + * get_update_locks_for_queue: get the locks required to update the 
>> APCB of the
>> + *                   KVM guest to which the matrix mdev linked to a
>> + *                   vfio_ap_queue object is attached.
>> + *
>> + * @queue: a pointer to a vfio_ap_queue object.
>> + *
>> + * The proper locking order is:
>> + * 1. matrix_dev->guests_lock: required to use the KVM pointer to 
>> update a KVM
>> + *                guest's APCB.
>> + * 2. queue->matrix_mdev->kvm->lock: required to update a guest's APCB
>> + * 3. matrix_dev->mdevs_lock:    required to access data stored in a 
>> matrix_mdev
>> + *
>> + * Note: if @queue is not linked to an ap_matrix_mdev object, the 
>> KVM lock
>> + *      will not be taken.
>> + */
>> +#define get_update_locks_for_queue(queue) ({            \
>> +    struct ap_matrix_mdev *matrix_mdev = q->matrix_mdev; \
>> +    mutex_lock(&matrix_dev->guests_lock);            \
>> +    if (matrix_mdev && matrix_mdev->kvm) \
>> +        mutex_lock(&matrix_mdev->kvm->lock);        \
>> +    mutex_lock(&matrix_dev->mdevs_lock);            \
>> +})
>> +
>
>
> One more comment I forgot to include before:
> This macro is far too similar to existing macro, 
> get_update_locks_for_mdev. And it is only called in one place. Let's 
> remove this and replace the single invocation with:
>
> get_update_locks_for_mdev(q->matrix_mdev);

Yikes, I see another flaw in this macro! Either the input parameter 
needs to be renamed to 'q' or the q->matrix_mdev needs to be changed to 
queue->matrix_mdev. I think I'll go with the former since vfio_ap_queue 
is referred to as 'q' everywhere else.

>
>
>>   /**
>>    * vfio_ap_mdev_get_queue - retrieve a queue with a specific APQN 
>> from a
>>    *                hash table of queues assigned to a matrix mdev
>> @@ -615,21 +683,18 @@ static int vfio_ap_mdev_probe(struct 
>> mdev_device *mdev)
>>       matrix_mdev->pqap_hook = handle_pqap;
>>       vfio_ap_matrix_init(&matrix_dev->info, &matrix_mdev->shadow_apcb);
>>       hash_init(matrix_mdev->qtable.queues);
>> -    mdev_set_drvdata(mdev, matrix_mdev);
>> -    mutex_lock(&matrix_dev->mdevs_lock);
>> -    list_add(&matrix_mdev->node, &matrix_dev->mdev_list);
>> -    mutex_unlock(&matrix_dev->mdevs_lock);
>>         ret = vfio_register_emulated_iommu_dev(&matrix_mdev->vdev);
>>       if (ret)
>>           goto err_list;
>> +    mdev_set_drvdata(mdev, matrix_mdev);
>> +    mutex_lock(&matrix_dev->mdevs_lock);
>> +    list_add(&matrix_mdev->node, &matrix_dev->mdev_list);
>> +    mutex_unlock(&matrix_dev->mdevs_lock);
>>       dev_set_drvdata(&mdev->dev, matrix_mdev);
>>       return 0;
>>     err_list:
>> -    mutex_lock(&matrix_dev->mdevs_lock);
>> -    list_del(&matrix_mdev->node);
>> -    mutex_unlock(&matrix_dev->mdevs_lock);
>>       vfio_uninit_group_dev(&matrix_mdev->vdev);
>>       kfree(matrix_mdev);
>>   err_dec_available:
>> @@ -692,11 +757,13 @@ static void vfio_ap_mdev_remove(struct 
>> mdev_device *mdev)
>>         vfio_unregister_group_dev(&matrix_mdev->vdev);
>>   +    mutex_lock(&matrix_dev->guests_lock);
>>       mutex_lock(&matrix_dev->mdevs_lock);
>>       vfio_ap_mdev_reset_queues(matrix_mdev);
>>       vfio_ap_mdev_unlink_fr_queues(matrix_mdev);
>>       list_del(&matrix_mdev->node);
>>       mutex_unlock(&matrix_dev->mdevs_lock);
>> +    mutex_unlock(&matrix_dev->guests_lock);
>>       vfio_uninit_group_dev(&matrix_mdev->vdev);
>>       kfree(matrix_mdev);
>>       atomic_inc(&matrix_dev->available_instances);
>> @@ -1665,49 +1732,30 @@ void vfio_ap_mdev_unregister(void)
>>       mdev_unregister_driver(&vfio_ap_matrix_driver);
>>   }
>>   -/*
>> - * vfio_ap_queue_link_mdev
>> - *
>> - * @q: The queue to link with the matrix mdev.
>> - *
>> - * Links @q with the matrix mdev to which the queue's APQN is assigned.
>> - */
>> -static void vfio_ap_queue_link_mdev(struct vfio_ap_queue *q)
>> -{
>> -    unsigned long apid = AP_QID_CARD(q->apqn);
>> -    unsigned long apqi = AP_QID_QUEUE(q->apqn);
>> -    struct ap_matrix_mdev *matrix_mdev;
>> -
>> -    list_for_each_entry(matrix_mdev, &matrix_dev->mdev_list, node) {
>> -        if (test_bit_inv(apid, matrix_mdev->matrix.apm) &&
>> -            test_bit_inv(apqi, matrix_mdev->matrix.aqm)) {
>> -            vfio_ap_mdev_link_queue(matrix_mdev, q);
>> -            break;
>> -        }
>> -    }
>> -}
>> -
>>   int vfio_ap_mdev_probe_queue(struct ap_device *apdev)
>>   {
>>       struct vfio_ap_queue *q;
>> +    struct ap_matrix_mdev *matrix_mdev;
>>       DECLARE_BITMAP(apm_delta, AP_DEVICES);
>>         q = kzalloc(sizeof(*q), GFP_KERNEL);
>>       if (!q)
>>           return -ENOMEM;
>> -    mutex_lock(&matrix_dev->mdevs_lock);
>>       q->apqn = to_ap_queue(&apdev->device)->qid;
>>       q->saved_isc = VFIO_AP_ISC_INVALID;
>> -    vfio_ap_queue_link_mdev(q);
>> -    if (q->matrix_mdev) {
>> +
>> +    matrix_mdev = vfio_ap_mdev_get_update_locks_for_apqn(q->apqn);
>> +
>> +    if (matrix_mdev) {
>> +        vfio_ap_mdev_link_queue(matrix_mdev, q);
>>           memset(apm_delta, 0, sizeof(apm_delta));
>>           set_bit_inv(AP_QID_CARD(q->apqn), apm_delta);
>>           vfio_ap_mdev_filter_matrix(apm_delta,
>> -                       q->matrix_mdev->matrix.aqm,
>> -                       q->matrix_mdev);
>> +                       matrix_mdev->matrix.aqm,
>> +                       matrix_mdev);
>>       }
>>       dev_set_drvdata(&apdev->device, q);
>> -    mutex_unlock(&matrix_dev->mdevs_lock);
>> +    release_update_locks_for_mdev(matrix_mdev);
>>         return 0;
>>   }
>> @@ -1716,11 +1764,13 @@ void vfio_ap_mdev_remove_queue(struct 
>> ap_device *apdev)
>>   {
>>       unsigned long apid;
>>       struct vfio_ap_queue *q;
>> +    struct ap_matrix_mdev *matrix_mdev;
>>   -    mutex_lock(&matrix_dev->mdevs_lock);
>>       q = dev_get_drvdata(&apdev->device);
>> +    get_update_locks_for_queue(q);
>> +    matrix_mdev = q->matrix_mdev;
>>   -    if (q->matrix_mdev) {
>> +    if (matrix_mdev) {
>>           vfio_ap_unlink_queue_fr_mdev(q);
>>             apid = AP_QID_CARD(q->apqn);
>> @@ -1731,5 +1781,5 @@ void vfio_ap_mdev_remove_queue(struct ap_device 
>> *apdev)
>>       vfio_ap_mdev_reset_queue(q, 1);
>>       dev_set_drvdata(&apdev->device, NULL);
>>       kfree(q);
>> -    mutex_unlock(&matrix_dev->mdevs_lock);
>> +    release_update_locks_for_mdev(matrix_mdev);
>>   }
>
>

