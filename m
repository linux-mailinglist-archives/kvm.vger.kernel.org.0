Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0CF148544
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2019 16:26:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728285AbfFQOYw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jun 2019 10:24:52 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:55186 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726028AbfFQOYv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 Jun 2019 10:24:51 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5HEIhiZ135962;
        Mon, 17 Jun 2019 10:24:30 -0400
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2t6ajme26k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 Jun 2019 10:24:29 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x5HED5fb032660;
        Mon, 17 Jun 2019 14:24:28 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma03dal.us.ibm.com with ESMTP id 2t4ra5tgjx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 Jun 2019 14:24:28 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5HEON5619464596
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Jun 2019 14:24:23 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 81FE66E050;
        Mon, 17 Jun 2019 14:24:23 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5BDD26E04C;
        Mon, 17 Jun 2019 14:24:22 +0000 (GMT)
Received: from [9.60.84.60] (unknown [9.60.84.60])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 17 Jun 2019 14:24:22 +0000 (GMT)
Subject: Re: [PATCH v4 1/7] s390: vfio-ap: Refactor vfio_ap driver probe and
 remove callbacks
To:     Harald Freudenberger <freude@linux.ibm.com>,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, cohuck@redhat.com, frankja@linux.ibm.com,
        david@redhat.com, mjrosato@linux.ibm.com, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, pmorel@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com
References: <1560454780-20359-1-git-send-email-akrowiak@linux.ibm.com>
 <1560454780-20359-2-git-send-email-akrowiak@linux.ibm.com>
 <534f8ef2-ac7a-bda3-54cf-d475b2a47c02@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <8817a913-b574-3bf4-6ef8-b8f1c5a4728e@linux.ibm.com>
Date:   Mon, 17 Jun 2019 10:24:21 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <534f8ef2-ac7a-bda3-54cf-d475b2a47c02@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-17_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906170130
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/17/19 4:27 AM, Harald Freudenberger wrote:
> On 13.06.19 21:39, Tony Krowiak wrote:
>> In order to limit the number of private mdev functions called from the
>> vfio_ap device driver as well as to provide a landing spot for dynamic
>> configuration code related to binding/unbinding AP queue devices to/from
>> the vfio_ap driver, the following changes are being introduced:
>>
>> * Move code from the vfio_ap driver's probe callback into a function
>>    defined in the mdev private operations file.
>>
>> * Move code from the vfio_ap driver's remove callback into a function
>>    defined in the mdev private operations file.
>>
>> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
>> ---
>>   drivers/s390/crypto/vfio_ap_drv.c     | 27 ++++++++++-----------------
>>   drivers/s390/crypto/vfio_ap_ops.c     | 28 ++++++++++++++++++++++++++++
>>   drivers/s390/crypto/vfio_ap_private.h |  6 +++---
>>   3 files changed, 41 insertions(+), 20 deletions(-)
>>
>> diff --git a/drivers/s390/crypto/vfio_ap_drv.c b/drivers/s390/crypto/vfio_ap_drv.c
>> index 003662aa8060..3c60df70891b 100644
>> --- a/drivers/s390/crypto/vfio_ap_drv.c
>> +++ b/drivers/s390/crypto/vfio_ap_drv.c
>> @@ -49,15 +49,15 @@ MODULE_DEVICE_TABLE(vfio_ap, ap_queue_ids);
>>    */
>>   static int vfio_ap_queue_dev_probe(struct ap_device *apdev)
>>   {
>> -	struct vfio_ap_queue *q;
>> -
>> -	q = kzalloc(sizeof(*q), GFP_KERNEL);
>> -	if (!q)
>> -		return -ENOMEM;
>> -	dev_set_drvdata(&apdev->device, q);
>> -	q->apqn = to_ap_queue(&apdev->device)->qid;
>> -	q->saved_isc = VFIO_AP_ISC_INVALID;
>> +	int ret;
>> +	struct ap_queue *queue = to_ap_queue(&apdev->device);
>> +
>> +	ret = vfio_ap_mdev_probe_queue(queue);
>> +	if (ret)
>> +		return ret;
>> +
>>   	return 0;
> A simple
>    return vfio_ap_mdev_probe_queue(queue);
> would be enough.

True.

>> +
>>   }
>>   
>>   /**
>> @@ -68,17 +68,10 @@ static int vfio_ap_queue_dev_probe(struct ap_device *apdev)
>>    */
>>   static void vfio_ap_queue_dev_remove(struct ap_device *apdev)
>>   {
>> -	struct vfio_ap_queue *q;
>> -	int apid, apqi;
>> +	struct ap_queue *queue = to_ap_queue(&apdev->device);
>>   
>>   	mutex_lock(&matrix_dev->lock);
>> -	q = dev_get_drvdata(&apdev->device);
>> -	dev_set_drvdata(&apdev->device, NULL);
>> -	apid = AP_QID_CARD(q->apqn);
>> -	apqi = AP_QID_QUEUE(q->apqn);
>> -	vfio_ap_mdev_reset_queue(apid, apqi, 1);
>> -	vfio_ap_irq_disable(q);
>> -	kfree(q);
>> +	vfio_ap_mdev_remove_queue(queue);
>>   	mutex_unlock(&matrix_dev->lock);
>>   }
>>   
>> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
>> index 015174ff6f0a..bf2ab02b9a0b 100644
>> --- a/drivers/s390/crypto/vfio_ap_ops.c
>> +++ b/drivers/s390/crypto/vfio_ap_ops.c
>> @@ -1302,3 +1302,31 @@ void vfio_ap_mdev_unregister(void)
>>   {
>>   	mdev_unregister_device(&matrix_dev->device);
>>   }
>> +
>> +int vfio_ap_mdev_probe_queue(struct ap_queue *queue)
>> +{
>> +	struct vfio_ap_queue *q;
>> +
>> +	q = kzalloc(sizeof(*q), GFP_KERNEL);
>> +	if (!q)
>> +		return -ENOMEM;
>> +	dev_set_drvdata(&queue->ap_dev.device, q);
>> +	q->apqn = queue->qid;
>> +	q->saved_isc = VFIO_AP_ISC_INVALID;
>> +
>> +	return 0;
>> +}
>> +
>> +void vfio_ap_mdev_remove_queue(struct ap_queue *queue)
>> +{
>> +	struct vfio_ap_queue *q;
>> +	int apid, apqi;
>> +
>> +	q = dev_get_drvdata(&queue->ap_dev.device);
>> +	dev_set_drvdata(&queue->ap_dev.device, NULL);
>> +	apid = AP_QID_CARD(q->apqn);
>> +	apqi = AP_QID_QUEUE(q->apqn);
>> +	vfio_ap_mdev_reset_queue(apid, apqi, 1);
>> +	vfio_ap_irq_disable(q);
>> +	kfree(q);
>> +}
>> diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
>> index f46dde56b464..5cc3c2ebf151 100644
>> --- a/drivers/s390/crypto/vfio_ap_private.h
>> +++ b/drivers/s390/crypto/vfio_ap_private.h
>> @@ -90,8 +90,6 @@ struct ap_matrix_mdev {
>>   
>>   extern int vfio_ap_mdev_register(void);
>>   extern void vfio_ap_mdev_unregister(void);
>> -int vfio_ap_mdev_reset_queue(unsigned int apid, unsigned int apqi,
>> -			     unsigned int retry);
>>   
>>   struct vfio_ap_queue {
>>   	struct ap_matrix_mdev *matrix_mdev;
>> @@ -100,5 +98,7 @@ struct vfio_ap_queue {
>>   #define VFIO_AP_ISC_INVALID 0xff
>>   	unsigned char saved_isc;
>>   };
>> -struct ap_queue_status vfio_ap_irq_disable(struct vfio_ap_queue *q);
>> +int vfio_ap_mdev_probe_queue(struct ap_queue *queue);
>> +void vfio_ap_mdev_remove_queue(struct ap_queue *queue);
>> +
>>   #endif /* _VFIO_AP_PRIVATE_H_ */
> 

