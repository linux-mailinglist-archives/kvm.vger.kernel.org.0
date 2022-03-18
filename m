Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FEA84DE092
	for <lists+kvm@lfdr.de>; Fri, 18 Mar 2022 18:54:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239003AbiCRRzz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Mar 2022 13:55:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231321AbiCRRzy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Mar 2022 13:55:54 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 491E82B248;
        Fri, 18 Mar 2022 10:54:35 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22IHN3W7030805;
        Fri, 18 Mar 2022 17:54:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=aIsumA5LVwq/0FG/z//n88QoNWgKusI9lUx971gQBsQ=;
 b=iiUPJ+iN+q8r/E+k+yvyU2ldi/WoWRgkQYXQbd7l6fU0fNcPkm1uNPX0y1sAkgosq3h9
 64LaKflLpxaCqAXx8P/JG+hcjCKdNQODv31mUKN8AeSki1Vlzp0bGPs2kHCln9zDQElc
 q+yNVZyywxfwKUQECQgqeMhW7OcjweG5/EX58zMmuMRHazFr1qH5oE2ftn6wodkhptQZ
 srFTN+4kH8gqUPczhVdCrE0Go/H49df9qOChH3VHqqryFJsYjXNZD3HOMVHPS8LmXNXc
 n1V2/uDzAmLZPEOE3f9Avv2NMvfl86u7BV9krh7PNoRPTXZyje/7cjHfmoH9YPiUyb06 Vw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3euwujex7n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Mar 2022 17:54:32 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22IHPm9u004603;
        Fri, 18 Mar 2022 17:54:32 GMT
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3euwujex7b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Mar 2022 17:54:32 +0000
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22IHqlnT019808;
        Fri, 18 Mar 2022 17:54:31 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma03wdc.us.ibm.com with ESMTP id 3eug4u75vr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Mar 2022 17:54:31 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22IHsUd918678218
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Mar 2022 17:54:30 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1D933AC064;
        Fri, 18 Mar 2022 17:54:30 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 82285AC059;
        Fri, 18 Mar 2022 17:54:28 +0000 (GMT)
Received: from [9.65.234.56] (unknown [9.65.234.56])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri, 18 Mar 2022 17:54:28 +0000 (GMT)
Message-ID: <e869ab58-432e-e451-9021-71ee65488fb0@linux.ibm.com>
Date:   Fri, 18 Mar 2022 13:54:27 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v18 12/18] s390/vfio-ap: reset queues after adapter/domain
 unassignment
Content-Language: en-US
To:     jjherne@linux.ibm.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com
References: <20220215005040.52697-1-akrowiak@linux.ibm.com>
 <20220215005040.52697-13-akrowiak@linux.ibm.com>
 <6083d83b-6867-2525-fdd8-baccde1a599f@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
In-Reply-To: <6083d83b-6867-2525-fdd8-baccde1a599f@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: eEZulnVsfM1xWhGozvJAuy0cIMndvhM4
X-Proofpoint-GUID: ufxfhyos-Nq7-pR9TvVOg0rCRMv2ik_J
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-18_13,2022-03-15_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 spamscore=0
 lowpriorityscore=0 adultscore=0 priorityscore=1501 impostorscore=0
 clxscore=1015 mlxlogscore=999 phishscore=0 mlxscore=0 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203180093
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/15/22 10:13, Jason J. Herne wrote:
> On 2/14/22 19:50, Tony Krowiak wrote:
>> When an adapter or domain is unassigned from an mdev providing the AP
>> configuration to a running KVM guest, one or more of the guest's 
>> queues may
>> get dynamically removed. Since the removed queues could get 
>> re-assigned to
>> another mdev, they need to be reset. So, when an adapter or domain is
>> unassigned from the mdev, the queues that are removed from the guest's
>> AP configuration will be reset.
>>
>> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
>> ---
> ...
>>   +static void vfio_ap_unlink_apqn_fr_mdev(struct ap_matrix_mdev 
>> *matrix_mdev,
>> +                    unsigned long apid, unsigned long apqi,
>> +                    struct ap_queue_table *qtable)
>> +{
>> +    struct vfio_ap_queue *q;
>> +
>> +    q = vfio_ap_mdev_get_queue(matrix_mdev, AP_MKQID(apid, apqi));
>> +    /* If the queue is assigned to the matrix mdev, unlink it. */
>> +    if (q)
>> +        vfio_ap_unlink_queue_fr_mdev(q);
>> +
>> +    /* If the queue is assigned to the APCB, store it in @qtable. */
>> +    if (test_bit_inv(apid, matrix_mdev->shadow_apcb.apm) &&
>> +        test_bit_inv(apqi, matrix_mdev->shadow_apcb.aqm))
>> +        hash_add(qtable->queues, &q->mdev_qnode, q->apqn);
>> +}
>> +
>> +/**
>> + * vfio_ap_mdev_unlink_adapter - unlink all queues associated with 
>> unassigned
>> + *                 adapter from the matrix mdev to which the
>> + *                 adapter was assigned.
>> + * @matrix_mdev: the matrix mediated device to which the adapter was 
>> assigned.
>> + * @apid: the APID of the unassigned adapter.
>> + * @qtable: table for storing queues associated with unassigned 
>> adapter.
>> + */
>>   static void vfio_ap_mdev_unlink_adapter(struct ap_matrix_mdev 
>> *matrix_mdev,
>> -                    unsigned long apid)
>> +                    unsigned long apid,
>> +                    struct ap_queue_table *qtable)
>>   {
>>       unsigned long apqi;
>> +
>> +    for_each_set_bit_inv(apqi, matrix_mdev->matrix.aqm, AP_DOMAINS)
>> +        vfio_ap_unlink_apqn_fr_mdev(matrix_mdev, apid, apqi, qtable);
>> +}
>
> Here is an alternate version of the above two functions that stops the
> profileration of the qtables variable into vfio_ap_unlink_apqn_fr_mdev.
> It may seem like a change with no benefit, but it simplifies things a
> bit and avoids the reader from having to sink three functions deep to
> find out where qtables is used. This is 100% untested.
>
>
> static bool vfio_ap_unlink_apqn_fr_mdev(struct ap_matrix_mdev 
> *matrix_mdev,
>                     unsigned long apid, unsigned long apqi)
> {
>     struct vfio_ap_queue *q;
>
>     q = vfio_ap_mdev_get_queue(matrix_mdev, AP_MKQID(apid, apqi));
>     /* If the queue is assigned to the matrix mdev, unlink it. */
>     if (q) {
>         vfio_ap_unlink_queue_fr_mdev(q);
>         return true;
>     }
>     return false;
> }
>
> static void vfio_ap_mdev_unlink_adapter(struct ap_matrix_mdev 
> *matrix_mdev,
>                     unsigned long apid,
>                     struct ap_queue_table *qtable)
> {
>     unsigned long apqi;
>     bool unlinked;
>
>     for_each_set_bit_inv(apqi, matrix_mdev->matrix.aqm, AP_DOMAINS) {
>         unlinked = vfio_ap_unlink_apqn_fr_mdev(matrix_mdev, apid, 
> apqi, qtable);
>
>         if (unlinked && qtable) {
>             if (test_bit_inv(apid, matrix_mdev->shadow_apcb.apm) &&
>                 test_bit_inv(apqi, matrix_mdev->shadow_apcb.aqm))
>                 hash_add(qtable->queues, &q->mdev_qnode,
>                      q->apqn);
>         }
>     }
> }

This code didn't compile because in the function immediately above,
the variable q is not defined nor is it initialized with a value. What I did
to fix that is return  the vfio_ap_queue pointer from the
vfio_ap_unlink_apqn_fr_mdev function and checked the return value
for NULL instead of the boolean:

vfio_ap_queue *q;
...
q = vfio_ap_unlink_apqn_fr_mdev(matrix_mdev, apid, apqi, qtable);
...
if (q && qtable)
...

>
>
>> +static void vfio_ap_mdev_hot_unplug_adapter(struct ap_matrix_mdev 
>> *matrix_mdev,
>> +                        unsigned long apid)
>> +{
>> +    int bkt;
>>       struct vfio_ap_queue *q;
>> +    struct ap_queue_table qtable;
>> +    hash_init(qtable.queues);
>> +    vfio_ap_mdev_unlink_adapter(matrix_mdev, apid, &qtable);
>> +
>> +    if (test_bit_inv(apid, matrix_mdev->shadow_apcb.apm)) {
>> +        clear_bit_inv(apid, matrix_mdev->shadow_apcb.apm);
>> +        vfio_ap_mdev_hotplug_apcb(matrix_mdev);
>> +    }
>>   -    for_each_set_bit_inv(apqi, matrix_mdev->matrix.aqm, AP_DOMAINS) {
>> -        q = vfio_ap_mdev_get_queue(matrix_mdev, AP_MKQID(apid, apqi));
>> +    vfio_ap_mdev_reset_queues(&qtable);
>>   -        if (q)
>> -            vfio_ap_mdev_unlink_queue(q);
>> +    hash_for_each(qtable.queues, bkt, q, mdev_qnode) {
>
> This comment applies to all instances of btk: What is btk? Can we come
> up with a more descriptive name?

If you look at the hash_for_each macro, you will see that I used the exact
same variable name as the macro does to indicate it is a bucket loop
cursor. Since that is a long name I'll go with loop_cursor.

>
>
>> +        vfio_ap_unlink_mdev_fr_queue(q);
>> +        hash_del(&q->mdev_qnode);
>>       }
>>   }
> ...
>> @@ -1273,9 +1320,9 @@ static void vfio_ap_mdev_unset_kvm(struct 
>> ap_matrix_mdev *matrix_mdev,
>>           mutex_lock(&kvm->lock);
>>           mutex_lock(&matrix_dev->mdevs_lock);
>>   -        kvm_arch_crypto_clear_masks(kvm);
>> -        vfio_ap_mdev_reset_queues(matrix_mdev);
>> -        kvm_put_kvm(kvm);
>> +        kvm_arch_crypto_clear_masks(matrix_mdev->kvm);
>> +        vfio_ap_mdev_reset_queues(&matrix_mdev->qtable);
>> +        kvm_put_kvm(matrix_mdev->kvm);
>>           matrix_mdev->kvm = NULL;
>
> I understand changing the call to vfio_ap_mdev_reset_queues, but why 
> are we changing the
> kvm pointer on the surrounding lines?

In reality, both pointers are one in the same given the two callers pass
matrix_mdev->kvm into the function. I'm not sure why that is the case,
it is probably a remnant from the commits that fixed the lockdep splat;
however, there is no reason other than I've gotten used to retrieving the
KVM pointer from the ap_matrix_mdev structure. In reality, there is no
reason to pass a 'struct kvm *kvm' into this function, so I'm going to
look into that and adjust accordingly.

>
>
>> mutex_unlock(&matrix_dev->mdevs_lock);
>> @@ -1328,14 +1375,17 @@ static int vfio_ap_mdev_reset_queue(struct 
>> vfio_ap_queue *q, unsigned int retry)
>>         if (!q)
>>           return 0;
>> +    q->reset_rc = 0;
>
> This line seems unnecessary. You set q->reset_rc in every single case 
> below, so this 0
> will always get overwritten.

Right you are. It is also unnecessary to set q->reset_rc every case when
it can be set once right after the call to ap_zapq.

>
>
>>   retry_zapq:
>>       status = ap_zapq(q->apqn);
>>       switch (status.response_code) {
>>       case AP_RESPONSE_NORMAL:
>>           ret = 0;
>> +        q->reset_rc = status.response_code;
>>           break;
>>       case AP_RESPONSE_RESET_IN_PROGRESS:
>> +        q->reset_rc = status.response_code;
>>           if (retry--) {
>>               msleep(20);
>>               goto retry_zapq;
>> @@ -1345,13 +1395,20 @@ static int vfio_ap_mdev_reset_queue(struct 
>> vfio_ap_queue *q, unsigned int retry)
>>       case AP_RESPONSE_Q_NOT_AVAIL:
>>       case AP_RESPONSE_DECONFIGURED:
>>       case AP_RESPONSE_CHECKSTOPPED:
>> -        WARN_ON_ONCE(status.irq_enabled);
>> +        WARN_ONCE(status.irq_enabled,
>> +              "PQAP/ZAPQ for %02x.%04x failed with rc=%u while IRQ 
>> enabled",
>> +              AP_QID_CARD(q->apqn), AP_QID_QUEUE(q->apqn),
>> +              status.response_code);
>> +        q->reset_rc = status.response_code;
>>           ret = -EBUSY;
>>           goto free_resources;
>>       default:
>>           /* things are really broken, give up */
>> -        WARN(true, "PQAP/ZAPQ completed with invalid rc (%x)\n",
>> +        WARN(true,
>> +             "PQAP/ZAPQ for %02x.%04x failed with invalid rc=%u\n",
>> +             AP_QID_CARD(q->apqn), AP_QID_QUEUE(q->apqn),
>>                status.response_code);
>> +        q->reset_rc = status.response_code;
>>           return -EIO;
>>       }
> ...
>

