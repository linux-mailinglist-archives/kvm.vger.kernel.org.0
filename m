Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A2912F50A1
	for <lists+kvm@lfdr.de>; Wed, 13 Jan 2021 18:07:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727873AbhAMRHV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jan 2021 12:07:21 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:14324 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727788AbhAMRHU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Jan 2021 12:07:20 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10DH2LKB011100;
        Wed, 13 Jan 2021 12:06:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=fXHvHtgnJeEsNzC7mYNyNj1ryUUxFFGYpnl12cD4hdU=;
 b=qHDb0vl+nVFhMx7J3npe+hf58S0zKQbn4bIcD7EqWulgWNTwqJ9M+rlEKimRNFJYH1Y6
 nsErnWKg6M0huPS5oZux02RmsYgnzGXknrpw4BWK3hq6X8EvMCUZ5sQTlRR8Z8FFLsBZ
 5nlJGmJzd3Xh0OAc75HFkrpLHHlL+TL22I4ka4Ru2FGoznwIfGPPZvyQxxERg0dI+IHo
 LDcnWqHRD3/MndB0z9WKJlxezxka7fc6je3nWdGKAfD76Dv+7ph43wYUVLNKmh5xXJsh
 aZAPhRTUOtq3tQ4PhCFAtnVrS0wDMwzSy8Rm4EQl3DG3Vx2bV8KXf3/kViPE+8pJXmSw MQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36249e9byw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jan 2021 12:06:36 -0500
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10DH2cfr014602;
        Wed, 13 Jan 2021 12:06:35 -0500
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36249e9byb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jan 2021 12:06:35 -0500
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10DH2FP7025443;
        Wed, 13 Jan 2021 17:06:34 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma03dal.us.ibm.com with ESMTP id 35y449er26-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jan 2021 17:06:34 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10DH6UZN18350368
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Jan 2021 17:06:30 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CB8C478060;
        Wed, 13 Jan 2021 17:06:30 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 740FA78063;
        Wed, 13 Jan 2021 17:06:29 +0000 (GMT)
Received: from cpe-66-24-58-13.stny.res.rr.com (unknown [9.85.193.150])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed, 13 Jan 2021 17:06:29 +0000 (GMT)
Subject: Re: [PATCH v13 02/15] s390/vfio-ap: No need to disable IRQ after
 queue reset
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        hca@linux.ibm.com, gor@linux.ibm.com
References: <20201223011606.5265-1-akrowiak@linux.ibm.com>
 <20201223011606.5265-3-akrowiak@linux.ibm.com>
 <20210111173206.27808b79.pasic@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <ed9eb852-5046-bcfc-be2c-3bb67323ec8a@linux.ibm.com>
Date:   Wed, 13 Jan 2021 12:06:28 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20210111173206.27808b79.pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-13_07:2021-01-13,2021-01-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 clxscore=1011 impostorscore=0 bulkscore=0 phishscore=0 adultscore=0
 malwarescore=0 mlxscore=0 priorityscore=1501 suspectscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101130100
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/11/21 11:32 AM, Halil Pasic wrote:
> On Tue, 22 Dec 2020 20:15:53 -0500
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>
>> The queues assigned to a matrix mediated device are currently reset when:
>>
>> * The VFIO_DEVICE_RESET ioctl is invoked
>> * The mdev fd is closed by userspace (QEMU)
>> * The mdev is removed from sysfs.
>>
>> Immediately after the reset of a queue, a call is made to disable
>> interrupts for the queue. This is entirely unnecessary because the reset of
>> a queue disables interrupts, so this will be removed.
>>
>> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
>> ---
>>   drivers/s390/crypto/vfio_ap_drv.c     |  1 -
>>   drivers/s390/crypto/vfio_ap_ops.c     | 40 +++++++++++++++++----------
>>   drivers/s390/crypto/vfio_ap_private.h |  1 -
>>   3 files changed, 26 insertions(+), 16 deletions(-)
>>
>> diff --git a/drivers/s390/crypto/vfio_ap_drv.c b/drivers/s390/crypto/vfio_ap_drv.c
>> index be2520cc010b..ca18c91afec9 100644
>> --- a/drivers/s390/crypto/vfio_ap_drv.c
>> +++ b/drivers/s390/crypto/vfio_ap_drv.c
>> @@ -79,7 +79,6 @@ static void vfio_ap_queue_dev_remove(struct ap_device *apdev)
>>   	apid = AP_QID_CARD(q->apqn);
>>   	apqi = AP_QID_QUEUE(q->apqn);
>>   	vfio_ap_mdev_reset_queue(apid, apqi, 1);
>> -	vfio_ap_irq_disable(q);
>>   	kfree(q);
>>   	mutex_unlock(&matrix_dev->lock);
>>   }
>> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
>> index 7339043906cf..052f61391ec7 100644
>> --- a/drivers/s390/crypto/vfio_ap_ops.c
>> +++ b/drivers/s390/crypto/vfio_ap_ops.c
>> @@ -25,6 +25,7 @@
>>   #define VFIO_AP_MDEV_NAME_HWVIRT "VFIO AP Passthrough Device"
>>   
>>   static int vfio_ap_mdev_reset_queues(struct mdev_device *mdev);
>> +static struct vfio_ap_queue *vfio_ap_find_queue(int apqn);
>>   
>>   static int match_apqn(struct device *dev, const void *data)
>>   {
>> @@ -49,20 +50,15 @@ static struct vfio_ap_queue *(
>>   					int apqn)
>>   {
>>   	struct vfio_ap_queue *q;
>> -	struct device *dev;
>>   
>>   	if (!test_bit_inv(AP_QID_CARD(apqn), matrix_mdev->matrix.apm))
>>   		return NULL;
>>   	if (!test_bit_inv(AP_QID_QUEUE(apqn), matrix_mdev->matrix.aqm))
>>   		return NULL;
>>   
>> -	dev = driver_find_device(&matrix_dev->vfio_ap_drv->driver, NULL,
>> -				 &apqn, match_apqn);
>> -	if (!dev)
>> -		return NULL;
>> -	q = dev_get_drvdata(dev);
>> -	q->matrix_mdev = matrix_mdev;
>> -	put_device(dev);
>> +	q = vfio_ap_find_queue(apqn);
>> +	if (q)
>> +		q->matrix_mdev = matrix_mdev;
>>   
>>   	return q;
>>   }
>> @@ -1126,24 +1122,27 @@ static int vfio_ap_mdev_group_notifier(struct notifier_block *nb,
>>   	return notify_rc;
>>   }
>>   
>> -static void vfio_ap_irq_disable_apqn(int apqn)
>> +static struct vfio_ap_queue *vfio_ap_find_queue(int apqn)
>>   {
>>   	struct device *dev;
>> -	struct vfio_ap_queue *q;
>> +	struct vfio_ap_queue *q = NULL;
>>   
>>   	dev = driver_find_device(&matrix_dev->vfio_ap_drv->driver, NULL,
>>   				 &apqn, match_apqn);
>>   	if (dev) {
>>   		q = dev_get_drvdata(dev);
>> -		vfio_ap_irq_disable(q);
>>   		put_device(dev);
>>   	}
>> +
>> +	return q;
>>   }
> This hunk and the previous one are a rewrite of vfio_ap_get_queue() and
> have next to nothing to do with the patch's objective. If we were at an
> earlier stage, I would ask to split it up.

The rewrite of vfio_ap_get_queue() definitely is related to this
patch's objective. Below, in the vfio_ap_mdev_reset_queue()
function, there is the label 'free_aqic_resources' which is where
the call to vfio_ap_free_aqic_resources() function is called.
That function takes a struct vfio_ap_queue as an argument,
so the object needs to be retrieved prior to calling the function.
We can't use the vfio_ap_get_queue() function for two reasons:
1. The vfio_ap_get_queue() function takes a struct ap_matrix_mdev
     as a parameter and we do not have a pointer to such at the time.
2. The vfio_ap_get_queue() function is used to link the mdev to the
     vfio_ap_queue object with the specified APQN.
So, we needed a way to retrieve the vfio_ap_queue object by its
APQN only, Rather than creating a function that retrieves the
vfio_ap_queue object which duplicates the retrieval code in
vfio_ap_get_queue(), I created the vfio_ap_find_queue()
function to do just that and modified the vfio_ap_get_queue()
function to call it (i.e., code reuse).


>
>>   
>>   int vfio_ap_mdev_reset_queue(unsigned int apid, unsigned int apqi,
>>   			     unsigned int retry)
>>   {
>>   	struct ap_queue_status status;
>> +	struct vfio_ap_queue *q;
>> +	int ret;
>>   	int retry2 = 2;
>>   	int apqn = AP_MKQID(apid, apqi);
>>   
>> @@ -1156,18 +1155,32 @@ int vfio_ap_mdev_reset_queue(unsigned int apid, unsigned int apqi,
>>   				status = ap_tapq(apqn, NULL);
>>   			}
>>   			WARN_ON_ONCE(retry2 <= 0);
>> -			return 0;
>> +			ret = 0;
>> +			goto free_aqic_resources;
>>   		case AP_RESPONSE_RESET_IN_PROGRESS:
>>   		case AP_RESPONSE_BUSY:
>>   			msleep(20);
>>   			break;
>>   		default:
>>   			/* things are really broken, give up */
>> -			return -EIO;
>> +			ret = -EIO;
>> +			goto free_aqic_resources;
> Do we really want the unpin here? I mean the reset did not work and
> we are giving up. So the irqs are potentially still enabled.
>
> Without this patch we try to disable the interrupts using AQIC, and
> do the cleanup after that.

If the reset failure lands here, then a subsequent AQIC will
also fail, so I see no reason to expend processing time for
something that will ultimately fail anyways.

>
> I'm aware, the comment says we should not take the default branch,
> but if that's really the case we should IMHO log an error and leak the
> page.

I do not see a good reason to leak the page, what purpose would
it serve? I don't have a problem with logging an error, do you think
it should just be a log message or a WARN_ON type of thing?

>
> It's up to you if you want to change this. I don't want to delay the
> series any further than absolutely necessary.
>
> Acked-by: Halil Pasic <pasic@linux.ibm.com>
>
>>   		}
>>   	} while (retry--);
>>   
>>   	return -EBUSY;
>> +
>> +free_aqic_resources:
>> +	/*
>> +	 * In order to free the aqic resources, the queue must be linked to
>> +	 * the matrix_mdev to which its APQN is assigned and the KVM pointer
>> +	 * must be available.
>> +	 */
>> +	q = vfio_ap_find_queue(apqn);
>> +	if (q && q->matrix_mdev && q->matrix_mdev->kvm)
> Is this of the type "we know there are no aqic resources to be freed" if
> precondition is false?

Yes

>
> vfio_ap_free_aqic_resources() checks the matrix_mdev pointer but not the
> kvm pointer. Could we just check the kvm pointer in
> vfio_ap_free_aqic_resources()?

A while back I posted a patch that did just that and someone pushed back
because they could not see how the vfio_ap_free_aqic_resources()
function would ever be called with a NULL kvm pointer which is
why I implemented the above check. The reset is called
when the mdev is removed which can happen only when there
is no kvm pointer, so I agree it would be better to check the kvm
pointer in the vfio_ap_free_aqic_resources() function.

>
> At the end of the series, is seeing q! indicating a bug, or is it
> something we expect to see under certain circumstances?

I'm not quite sure to what you are referring regarding "the
end of the series", but we can expect to see a NULL pointer
for q if a queue is manually unbound from the driver.

>
>
>> +		vfio_ap_free_aqic_resources(q);
>> +
>> +	return ret;
>>   }
>>   
>>   static int vfio_ap_mdev_reset_queues(struct mdev_device *mdev)
>> @@ -1189,7 +1202,6 @@ static int vfio_ap_mdev_reset_queues(struct mdev_device *mdev)
>>   			 */
>>   			if (ret)
>>   				rc = ret;
>> -			vfio_ap_irq_disable_apqn(AP_MKQID(apid, apqi));
>>   		}
>>   	}
>>   
>> diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
>> index f46dde56b464..0db6fb3d56d5 100644
>> --- a/drivers/s390/crypto/vfio_ap_private.h
>> +++ b/drivers/s390/crypto/vfio_ap_private.h
>> @@ -100,5 +100,4 @@ struct vfio_ap_queue {
>>   #define VFIO_AP_ISC_INVALID 0xff
>>   	unsigned char saved_isc;
>>   };
>> -struct ap_queue_status vfio_ap_irq_disable(struct vfio_ap_queue *q);
>>   #endif /* _VFIO_AP_PRIVATE_H_ */

