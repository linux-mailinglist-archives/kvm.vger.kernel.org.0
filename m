Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6901A154AB
	for <lists+kvm@lfdr.de>; Mon,  6 May 2019 21:53:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726424AbfEFTxS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 May 2019 15:53:18 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:50166 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726328AbfEFTxS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 6 May 2019 15:53:18 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x46JluP0126225
        for <kvm@vger.kernel.org>; Mon, 6 May 2019 15:53:16 -0400
Received: from e14.ny.us.ibm.com (e14.ny.us.ibm.com [129.33.205.204])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2saudar3ka-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 06 May 2019 15:53:16 -0400
Received: from localhost
        by e14.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <akrowiak@linux.ibm.com>;
        Mon, 6 May 2019 20:53:15 +0100
Received: from b01cxnp23032.gho.pok.ibm.com (9.57.198.27)
        by e14.ny.us.ibm.com (146.89.104.201) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 6 May 2019 20:53:12 +0100
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x46JrALS36569108
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 6 May 2019 19:53:10 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 52B94AC059;
        Mon,  6 May 2019 19:53:10 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DFF65AC05E;
        Mon,  6 May 2019 19:53:09 +0000 (GMT)
Received: from [9.60.75.251] (unknown [9.60.75.251])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon,  6 May 2019 19:53:09 +0000 (GMT)
Subject: Re: [PATCH v2 2/7] s390: vfio-ap: maintain a shadow of the guest's
 CRYCB
To:     pmorel@linux.ibm.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        frankja@linux.ibm.com, david@redhat.com, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com
References: <1556918073-13171-1-git-send-email-akrowiak@linux.ibm.com>
 <1556918073-13171-3-git-send-email-akrowiak@linux.ibm.com>
 <2f980dbc-4765-aba8-46fc-848ee66854d6@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Date:   Mon, 6 May 2019 15:53:09 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <2f980dbc-4765-aba8-46fc-848ee66854d6@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19050619-0052-0000-0000-000003BB8952
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011061; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000285; SDB=6.01199541; UDB=6.00629320; IPR=6.00980417;
 MB=3.00026760; MTD=3.00000008; XFM=3.00000015; UTC=2019-05-06 19:53:14
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19050619-0053-0000-0000-000060CB471B
Message-Id: <a47e980e-95e5-f44c-b8fd-e8a7d3d9b625@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-06_11:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905060162
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/6/19 2:49 AM, Pierre Morel wrote:
> On 03/05/2019 23:14, Tony Krowiak wrote:
>> This patch introduces a shadow of the CRYCB being used by a guest. This
>> will enable to more effectively manage dynamic changes to the AP
>> resources installed on the host that may be assigned to an mdev device
>> and being used by a guest. For example:
>>
>> * AP adapter cards can be dynamically added to and removed from the AP
>>    configuration via the SE or an SCLP command.
>>
>> * AP resources that disappear and reappear due to hardware malfunctions.
>>
>> * AP queues bound to and unbound from the vfio_ap device driver by a
>>    root user.
>>
>> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
>> ---
>>   drivers/s390/crypto/vfio_ap_ops.c     | 91 
>> ++++++++++++++++++++++++++++++++---
>>   drivers/s390/crypto/vfio_ap_private.h |  2 +
>>   2 files changed, 87 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/s390/crypto/vfio_ap_ops.c 
>> b/drivers/s390/crypto/vfio_ap_ops.c
>> index b88a2a2ba075..44a04b4aa9ae 100644
>> --- a/drivers/s390/crypto/vfio_ap_ops.c
>> +++ b/drivers/s390/crypto/vfio_ap_ops.c
>> @@ -297,6 +297,45 @@ static void vfio_ap_mdev_wait_for_qempty(unsigned 
>> long apid, unsigned long apqi)
>>       } while (--retry);
>>   }
>> +/*
>> + * vfio_ap_mdev_update_crycb
>> + *
>> + * @matrix_mdev: the mediated matrix device
>> + *
>> + * Updates the AP matrix in the guest's CRYCB from it's shadow masks.
>> + *
>> + * Returns zero if the guest's CRYCB is successfully updated; otherwise,
>> + * returns -ENODEV if a guest is not running or does not have a CRYCB.
>> + */
>> +static int vfio_ap_mdev_update_crycb(struct ap_matrix_mdev *matrix_mdev)
>> +{
>> +    if (!matrix_mdev->kvm || !matrix_mdev->kvm->arch.crypto.crycbd)
>> +        return -ENODEV;
>> +
>> +    kvm_arch_crypto_set_masks(matrix_mdev->kvm,
>> +                  matrix_mdev->shadow_crycb->apm,
>> +                  matrix_mdev->shadow_crycb->aqm,
>> +                  matrix_mdev->shadow_crycb->adm);
>> +
>> +    return 0;
>> +}
>> +
>> +static int match_apqn(struct device *dev, void *data)
>> +{
>> +    struct ap_queue *apq = to_ap_queue(dev);
>> +
>> +    return (apq->qid == *(unsigned long *)(data)) ? 1 : 0;
>> +}
>> +
>> +static struct device *vfio_ap_get_queue_dev(unsigned long apid,
>> +                         unsigned long apqi)
>> +{
>> +    unsigned long apqn = AP_MKQID(apid, apqi);
>> +
>> +    return driver_find_device(&matrix_dev->vfio_ap_drv->driver, NULL,
>> +                  &apqn, match_apqn);
>> +}
>> +
>>   /**
>>    * assign_adapter_store
>>    *
>> @@ -805,14 +844,9 @@ static int vfio_ap_mdev_group_notifier(struct 
>> notifier_block *nb,
>>       if (ret)
>>           return NOTIFY_DONE;
>> -    /* If there is no CRYCB pointer, then we can't copy the masks */
>> -    if (!matrix_mdev->kvm->arch.crypto.crycbd)
>> +    if (vfio_ap_mdev_update_crycb(matrix_mdev))
>>           return NOTIFY_DONE;
>> -    kvm_arch_crypto_set_masks(matrix_mdev->kvm, matrix_mdev->matrix.apm,
>> -                  matrix_mdev->matrix.aqm,
>> -                  matrix_mdev->matrix.adm);
>> -
>>       return NOTIFY_OK;
>>   }
>> @@ -867,12 +901,55 @@ static int vfio_ap_mdev_reset_queues(struct 
>> mdev_device *mdev)
>>       return rc;
>>   }
>> +static int vfio_ap_mdev_create_shadow_crycb(struct ap_matrix_mdev 
>> *matrix_mdev)
>> +{
>> +    unsigned long apid, apqi, domid;
>> +    struct device *dev;
>> +
>> +    matrix_mdev->shadow_crycb = 
>> kzalloc(sizeof(*matrix_mdev->shadow_crycb),
>> +                        GFP_KERNEL);
>> +    if (!matrix_mdev->shadow_crycb)
>> +        return -ENOMEM;
>> +
>> +    vfio_ap_matrix_init(&matrix_dev->info, matrix_mdev->shadow_crycb);
>> +
>> +    /*
>> +     * Examine each APQN assigned to the mdev device. Set the APID 
>> and APQI
>> +     * in the shadow CRYCB if and only if the queue device identified by
>> +     * the APQN is in the configuration.
>> +     */
>> +    for_each_set_bit_inv(apid, matrix_mdev->matrix.apm,
>> +                 matrix_mdev->matrix.apm_max + 1) {
>> +        for_each_set_bit_inv(apqi, matrix_mdev->matrix.aqm,
>> +                     matrix_mdev->matrix.aqm_max + 1) {
>> +            dev = vfio_ap_get_queue_dev(apid, apqi);
>> +            if (dev) {
>> +                set_bit_inv(apid,
>> +                        matrix_mdev->shadow_crycb->apm);
>> +                set_bit_inv(apqi,
>> +                        matrix_mdev->shadow_crycb->aqm);
>> +                put_device(dev);
>> +            }
> 
> I think that if we do not find a device here we have a problem.
> Don't we?

Other than the fact that the guest will not have any AP devices,
what would be the problem? What would you suggest?

> 
> 
>> +        }
>> +    }
>> +
>> +    /* Set all control domains assigned to the mdev in the shadow 
>> CRYCB */
>> +    for_each_set_bit_inv(domid, matrix_mdev->matrix.adm,
>> +                 matrix_mdev->matrix.adm_max + 1)
>> +        set_bit_inv(domid, matrix_mdev->shadow_crycb->adm);
>> +
>> +    return 0;
>> +}
>> +
>>   static int vfio_ap_mdev_open(struct mdev_device *mdev)
>>   {
>>       struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
>>       unsigned long events;
>>       int ret;
>> +    ret = vfio_ap_mdev_create_shadow_crycb(matrix_mdev);
>> +    if (ret)
>> +        return ret;
>>       if (!try_module_get(THIS_MODULE))
>>           return -ENODEV;
>> @@ -902,6 +979,8 @@ static void vfio_ap_mdev_release(struct 
>> mdev_device *mdev)
>>                    &matrix_mdev->group_notifier);
>>       matrix_mdev->kvm = NULL;
>>       module_put(THIS_MODULE);
>> +    kfree(matrix_mdev->shadow_crycb);
>> +    matrix_mdev->shadow_crycb = NULL;
>>   }
>>   static int vfio_ap_mdev_get_device_info(unsigned long arg)
>> diff --git a/drivers/s390/crypto/vfio_ap_private.h 
>> b/drivers/s390/crypto/vfio_ap_private.h
>> index 76b7f98e47e9..e8457aa61976 100644
>> --- a/drivers/s390/crypto/vfio_ap_private.h
>> +++ b/drivers/s390/crypto/vfio_ap_private.h
>> @@ -72,6 +72,7 @@ struct ap_matrix {
>>    * @list:    allows the ap_matrix_mdev struct to be added to a list
>>    * @matrix:    the adapters, usage domains and control domains 
>> assigned to the
>>    *        mediated matrix device.
>> + * @shadow_crycb: a shadow copy of the crycb in use by a guest
>>    * @group_notifier: notifier block used for specifying callback 
>> function for
>>    *            handling the VFIO_GROUP_NOTIFY_SET_KVM event
>>    * @kvm:    the struct holding guest's state
>> @@ -79,6 +80,7 @@ struct ap_matrix {
>>   struct ap_matrix_mdev {
>>       struct list_head node;
>>       struct ap_matrix matrix;
>> +    struct ap_matrix *shadow_crycb;
>>       struct notifier_block group_notifier;
>>       struct kvm *kvm;
>>   };
>>
> 
> 

