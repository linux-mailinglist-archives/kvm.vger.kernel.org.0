Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 019DF148A0
	for <lists+kvm@lfdr.de>; Mon,  6 May 2019 12:56:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726413AbfEFKz5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 May 2019 06:55:57 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:46476 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725948AbfEFKz5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 6 May 2019 06:55:57 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x46AqFWO005776
        for <kvm@vger.kernel.org>; Mon, 6 May 2019 06:55:56 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2sajd2jy1c-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 06 May 2019 06:55:56 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pmorel@linux.ibm.com>;
        Mon, 6 May 2019 11:55:53 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 6 May 2019 11:55:52 +0100
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x46Atorg40173808
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 6 May 2019 10:55:50 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 78C3852052;
        Mon,  6 May 2019 10:55:50 +0000 (GMT)
Received: from [9.145.46.119] (unknown [9.145.46.119])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id BCF415204E;
        Mon,  6 May 2019 10:55:49 +0000 (GMT)
Reply-To: pmorel@linux.ibm.com
Subject: Re: [PATCH v2 6/7] s390: vfio-ap: handle bind and unbind of AP queue
 device
To:     Tony Krowiak <akrowiak@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        frankja@linux.ibm.com, david@redhat.com, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com
References: <1556918073-13171-1-git-send-email-akrowiak@linux.ibm.com>
 <1556918073-13171-7-git-send-email-akrowiak@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Date:   Mon, 6 May 2019 12:55:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <1556918073-13171-7-git-send-email-akrowiak@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19050610-0028-0000-0000-0000036ACAA2
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19050610-0029-0000-0000-0000242A3EF6
Message-Id: <acf4e2fe-7b91-718c-f1f7-f4678eda52e0@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-06_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905060096
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/05/2019 23:14, Tony Krowiak wrote:
> There is nothing preventing a root user from inadvertently unbinding an
> AP queue device that is in use by a guest from the vfio_ap device driver
> and binding it to a zcrypt driver. This can result in a queue being
> accessible from both the host and a guest.
> 
> This patch introduces safeguards that prevent sharing of an AP queue
> between the host when a queue device is unbound from the vfio_ap device
> driver. In addition, this patch restores guest access to AP queue devices
> bound to the vfio_ap driver if the queue's APQN is assigned to an mdev
> device in use by a guest.
> 
> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> ---
>   drivers/s390/crypto/vfio_ap_drv.c     |  12 +++-
>   drivers/s390/crypto/vfio_ap_ops.c     | 100 +++++++++++++++++++++++++++++++++-
>   drivers/s390/crypto/vfio_ap_private.h |   2 +
>   3 files changed, 111 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/s390/crypto/vfio_ap_drv.c b/drivers/s390/crypto/vfio_ap_drv.c
> index e9824c35c34f..c215978daf39 100644
> --- a/drivers/s390/crypto/vfio_ap_drv.c
> +++ b/drivers/s390/crypto/vfio_ap_drv.c
> @@ -42,12 +42,22 @@ MODULE_DEVICE_TABLE(vfio_ap, ap_queue_ids);
>   
>   static int vfio_ap_queue_dev_probe(struct ap_device *apdev)
>   {
> +	struct ap_queue *queue = to_ap_queue(&apdev->device);
> +
> +	mutex_lock(&matrix_dev->lock);
> +	vfio_ap_mdev_probe_queue(queue);
> +	mutex_unlock(&matrix_dev->lock);
> +
>   	return 0;
>   }
>   
>   static void vfio_ap_queue_dev_remove(struct ap_device *apdev)
>   {
> -	/* Nothing to do yet */
> +	struct ap_queue *queue = to_ap_queue(&apdev->device);
> +
> +	mutex_lock(&matrix_dev->lock);
> +	vfio_ap_mdev_remove_queue(queue);
> +	mutex_unlock(&matrix_dev->lock);
>   }
>   
>   static void vfio_ap_matrix_dev_release(struct device *dev)
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> index ede45184eb67..40324951bd37 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -226,8 +226,6 @@ static struct device *vfio_ap_get_queue_dev(unsigned long apid,
>   				  &apqn, match_apqn);
>   }
>   
> -
> -
>   static int vfio_ap_mdev_validate_masks(unsigned long *apm, unsigned long *aqm)
>   {
>   	int ret;
> @@ -259,6 +257,27 @@ static bool vfio_ap_queues_on_drv(unsigned long *apm, unsigned long *aqm)
>   	return true;
>   }
>   
> +static bool vfio_ap_card_on_drv(struct ap_queue *queue, unsigned long *aqm)
> +{
> +	unsigned long apid, apqi;
> +	struct device *dev;
> +
> +	apid = AP_QID_CARD(queue->qid);
> +
> +	for_each_set_bit_inv(apqi, aqm, AP_DOMAINS) {
> +		if (queue->qid == AP_MKQID(apid, apqi))
> +			continue;
> +
> +		dev = vfio_ap_get_queue_dev(apid, apqi);
> +		if (!dev)
> +			return false;
> +
> +		put_device(dev);
> +	}
> +
> +	return true;
> +}
> +
>   /**
>    * assign_adapter_store
>    *
> @@ -1017,3 +1036,80 @@ void vfio_ap_mdev_unregister(void)
>   {
>   	mdev_unregister_device(&matrix_dev->device);
>   }
> +
> +static struct ap_matrix_mdev *vfio_ap_mdev_find_matrix_mdev(unsigned long apid,
> +							    unsigned long apqi)
> +{
> +	struct ap_matrix_mdev *matrix_mdev;
> +
> +	list_for_each_entry(matrix_mdev, &matrix_dev->mdev_list, node) {
> +		if (test_bit_inv(apid, matrix_mdev->matrix.apm) &&
> +		    test_bit_inv(apqi, matrix_mdev->matrix.aqm))
> +			return matrix_mdev;
> +	}
> +
> +	return NULL;
> +}
> +
> +void vfio_ap_mdev_probe_queue(struct ap_queue *queue)
> +{
> +	struct ap_matrix_mdev *matrix_mdev;
> +	unsigned long *shadow_apm, *shadow_aqm;
> +	unsigned long apid = AP_QID_CARD(queue->qid);
> +	unsigned long apqi = AP_QID_QUEUE(queue->qid);
> +
> +	/*
> +	 * Find the mdev device to which the APQN of the queue device being
> +	 * probed is assigned
> +	 */
> +	matrix_mdev = vfio_ap_mdev_find_matrix_mdev(apid, apqi);
> +
> +	/* Check whether we found an mdev device and it is in use by a guest */
> +	if (matrix_mdev && matrix_mdev->kvm) {
> +		shadow_apm = matrix_mdev->shadow_crycb->apm;
> +		shadow_aqm = matrix_mdev->shadow_crycb->aqm;
> +		/*
> +		 * If the guest already has access to the adapter card
> +		 * referenced by APID or does not have access to the queues
> +		 * referenced by APQI, there is nothing to do here.
> +		 */
> +		if (test_bit_inv(apid, shadow_apm) ||
> +		    !test_bit_inv(apqi, shadow_aqm))
> +			return;
> +
> +		/*
> +		 * If each APQN with the APID of the queue being probed and an
> +		 * APQI in the shadow CRYCB references a queue device that is
> +		 * bound to the vfio_ap driver, then plug the adapter into the
> +		 * guest.
> +		 */
> +		if (vfio_ap_card_on_drv(queue, shadow_aqm)) {
> +			set_bit_inv(apid, shadow_apm);
> +			vfio_ap_mdev_update_crycb(matrix_mdev);
> +		}
> +	}
> +}
> +
> +void vfio_ap_mdev_remove_queue(struct ap_queue *queue)
> +{
> +	struct ap_matrix_mdev *matrix_mdev;
> +	unsigned long apid = AP_QID_CARD(queue->qid);
> +	unsigned long apqi = AP_QID_QUEUE(queue->qid);
> +
> +	matrix_mdev = vfio_ap_mdev_find_matrix_mdev(apid, apqi);
> +
> +	/*
> +	 * If the queue is assigned to the mdev device and the mdev device
> +	 * is in use by a guest, unplug the adapter referred to by the APID
> +	 * of the APQN of the queue being removed.
> +	 */
> +	if (matrix_mdev && matrix_mdev->kvm) {
> +		if (!test_bit_inv(apid, matrix_mdev->shadow_crycb->apm))
> +			return;
> +
> +		clear_bit_inv(apid, matrix_mdev->shadow_crycb->apm);
> +		vfio_ap_mdev_update_crycb(matrix_mdev);
> +	}
> +
> +	vfio_ap_mdev_reset_queue(apid, apqi);
> +}
> diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
> index e8457aa61976..6b1f7df5b979 100644
> --- a/drivers/s390/crypto/vfio_ap_private.h
> +++ b/drivers/s390/crypto/vfio_ap_private.h
> @@ -87,5 +87,7 @@ struct ap_matrix_mdev {
>   
>   extern int vfio_ap_mdev_register(void);
>   extern void vfio_ap_mdev_unregister(void);
> +void vfio_ap_mdev_remove_queue(struct ap_queue *queue);
> +void vfio_ap_mdev_probe_queue(struct ap_queue *queue);
>   
>   #endif /* _VFIO_AP_PRIVATE_H_ */
> 


AFAIU the apmask/aqmask of the AP_BUS are replacing bind/unbind for the 
admin. Don't they?
Then why not suppress bind/unbind for ap_queues?

Otherwise, it seems to me to handle correctly the disappearance of a 
card, which is the only thing that can happen from out of the firmware 
queue change requires configuration change and re-IPL.

Even still need testing, LGTM


-- 
Pierre Morel
Linux/KVM/QEMU in Böblingen - Germany

