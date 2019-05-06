Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E99C114493
	for <lists+kvm@lfdr.de>; Mon,  6 May 2019 08:49:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725883AbfEFGtj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 May 2019 02:49:39 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:33850 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725813AbfEFGtj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 6 May 2019 02:49:39 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x466libN164690
        for <kvm@vger.kernel.org>; Mon, 6 May 2019 02:49:38 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2saejutv9t-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 06 May 2019 02:49:37 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pmorel@linux.ibm.com>;
        Mon, 6 May 2019 07:49:36 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 6 May 2019 07:49:32 +0100
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x466nUoH46465108
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 6 May 2019 06:49:30 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9B64E52054;
        Mon,  6 May 2019 06:49:30 +0000 (GMT)
Received: from [9.145.46.119] (unknown [9.145.46.119])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 084EB5204E;
        Mon,  6 May 2019 06:49:30 +0000 (GMT)
Reply-To: pmorel@linux.ibm.com
Subject: Re: [PATCH v2 2/7] s390: vfio-ap: maintain a shadow of the guest's
 CRYCB
To:     Tony Krowiak <akrowiak@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        frankja@linux.ibm.com, david@redhat.com, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com
References: <1556918073-13171-1-git-send-email-akrowiak@linux.ibm.com>
 <1556918073-13171-3-git-send-email-akrowiak@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Date:   Mon, 6 May 2019 08:49:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <1556918073-13171-3-git-send-email-akrowiak@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19050606-0008-0000-0000-000002E3B089
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19050606-0009-0000-0000-00002250275F
Message-Id: <2f980dbc-4765-aba8-46fc-848ee66854d6@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-06_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905060058
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/05/2019 23:14, Tony Krowiak wrote:
> This patch introduces a shadow of the CRYCB being used by a guest. This
> will enable to more effectively manage dynamic changes to the AP
> resources installed on the host that may be assigned to an mdev device
> and being used by a guest. For example:
> 
> * AP adapter cards can be dynamically added to and removed from the AP
>    configuration via the SE or an SCLP command.
> 
> * AP resources that disappear and reappear due to hardware malfunctions.
> 
> * AP queues bound to and unbound from the vfio_ap device driver by a
>    root user.
> 
> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> ---
>   drivers/s390/crypto/vfio_ap_ops.c     | 91 ++++++++++++++++++++++++++++++++---
>   drivers/s390/crypto/vfio_ap_private.h |  2 +
>   2 files changed, 87 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> index b88a2a2ba075..44a04b4aa9ae 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -297,6 +297,45 @@ static void vfio_ap_mdev_wait_for_qempty(unsigned long apid, unsigned long apqi)
>   	} while (--retry);
>   }
>   
> +/*
> + * vfio_ap_mdev_update_crycb
> + *
> + * @matrix_mdev: the mediated matrix device
> + *
> + * Updates the AP matrix in the guest's CRYCB from it's shadow masks.
> + *
> + * Returns zero if the guest's CRYCB is successfully updated; otherwise,
> + * returns -ENODEV if a guest is not running or does not have a CRYCB.
> + */
> +static int vfio_ap_mdev_update_crycb(struct ap_matrix_mdev *matrix_mdev)
> +{
> +	if (!matrix_mdev->kvm || !matrix_mdev->kvm->arch.crypto.crycbd)
> +		return -ENODEV;
> +
> +	kvm_arch_crypto_set_masks(matrix_mdev->kvm,
> +				  matrix_mdev->shadow_crycb->apm,
> +				  matrix_mdev->shadow_crycb->aqm,
> +				  matrix_mdev->shadow_crycb->adm);
> +
> +	return 0;
> +}
> +
> +static int match_apqn(struct device *dev, void *data)
> +{
> +	struct ap_queue *apq = to_ap_queue(dev);
> +
> +	return (apq->qid == *(unsigned long *)(data)) ? 1 : 0;
> +}
> +
> +static struct device *vfio_ap_get_queue_dev(unsigned long apid,
> +					     unsigned long apqi)
> +{
> +	unsigned long apqn = AP_MKQID(apid, apqi);
> +
> +	return driver_find_device(&matrix_dev->vfio_ap_drv->driver, NULL,
> +				  &apqn, match_apqn);
> +}
> +
>   /**
>    * assign_adapter_store
>    *
> @@ -805,14 +844,9 @@ static int vfio_ap_mdev_group_notifier(struct notifier_block *nb,
>   	if (ret)
>   		return NOTIFY_DONE;
>   
> -	/* If there is no CRYCB pointer, then we can't copy the masks */
> -	if (!matrix_mdev->kvm->arch.crypto.crycbd)
> +	if (vfio_ap_mdev_update_crycb(matrix_mdev))
>   		return NOTIFY_DONE;
>   
> -	kvm_arch_crypto_set_masks(matrix_mdev->kvm, matrix_mdev->matrix.apm,
> -				  matrix_mdev->matrix.aqm,
> -				  matrix_mdev->matrix.adm);
> -
>   	return NOTIFY_OK;
>   }
>   
> @@ -867,12 +901,55 @@ static int vfio_ap_mdev_reset_queues(struct mdev_device *mdev)
>   	return rc;
>   }
>   
> +static int vfio_ap_mdev_create_shadow_crycb(struct ap_matrix_mdev *matrix_mdev)
> +{
> +	unsigned long apid, apqi, domid;
> +	struct device *dev;
> +
> +	matrix_mdev->shadow_crycb = kzalloc(sizeof(*matrix_mdev->shadow_crycb),
> +					    GFP_KERNEL);
> +	if (!matrix_mdev->shadow_crycb)
> +		return -ENOMEM;
> +
> +	vfio_ap_matrix_init(&matrix_dev->info, matrix_mdev->shadow_crycb);
> +
> +	/*
> +	 * Examine each APQN assigned to the mdev device. Set the APID and APQI
> +	 * in the shadow CRYCB if and only if the queue device identified by
> +	 * the APQN is in the configuration.
> +	 */
> +	for_each_set_bit_inv(apid, matrix_mdev->matrix.apm,
> +			     matrix_mdev->matrix.apm_max + 1) {
> +		for_each_set_bit_inv(apqi, matrix_mdev->matrix.aqm,
> +				     matrix_mdev->matrix.aqm_max + 1) {
> +			dev = vfio_ap_get_queue_dev(apid, apqi);
> +			if (dev) {
> +				set_bit_inv(apid,
> +					    matrix_mdev->shadow_crycb->apm);
> +				set_bit_inv(apqi,
> +					    matrix_mdev->shadow_crycb->aqm);
> +				put_device(dev);
> +			}

I think that if we do not find a device here we have a problem.
Don't we?


> +		}
> +	}
> +
> +	/* Set all control domains assigned to the mdev in the shadow CRYCB */
> +	for_each_set_bit_inv(domid, matrix_mdev->matrix.adm,
> +			     matrix_mdev->matrix.adm_max + 1)
> +		set_bit_inv(domid, matrix_mdev->shadow_crycb->adm);
> +
> +	return 0;
> +}
> +
>   static int vfio_ap_mdev_open(struct mdev_device *mdev)
>   {
>   	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
>   	unsigned long events;
>   	int ret;
>   
> +	ret = vfio_ap_mdev_create_shadow_crycb(matrix_mdev);
> +	if (ret)
> +		return ret;
>   
>   	if (!try_module_get(THIS_MODULE))
>   		return -ENODEV;
> @@ -902,6 +979,8 @@ static void vfio_ap_mdev_release(struct mdev_device *mdev)
>   				 &matrix_mdev->group_notifier);
>   	matrix_mdev->kvm = NULL;
>   	module_put(THIS_MODULE);
> +	kfree(matrix_mdev->shadow_crycb);
> +	matrix_mdev->shadow_crycb = NULL;
>   }
>   
>   static int vfio_ap_mdev_get_device_info(unsigned long arg)
> diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
> index 76b7f98e47e9..e8457aa61976 100644
> --- a/drivers/s390/crypto/vfio_ap_private.h
> +++ b/drivers/s390/crypto/vfio_ap_private.h
> @@ -72,6 +72,7 @@ struct ap_matrix {
>    * @list:	allows the ap_matrix_mdev struct to be added to a list
>    * @matrix:	the adapters, usage domains and control domains assigned to the
>    *		mediated matrix device.
> + * @shadow_crycb: a shadow copy of the crycb in use by a guest
>    * @group_notifier: notifier block used for specifying callback function for
>    *		    handling the VFIO_GROUP_NOTIFY_SET_KVM event
>    * @kvm:	the struct holding guest's state
> @@ -79,6 +80,7 @@ struct ap_matrix {
>   struct ap_matrix_mdev {
>   	struct list_head node;
>   	struct ap_matrix matrix;
> +	struct ap_matrix *shadow_crycb;
>   	struct notifier_block group_notifier;
>   	struct kvm *kvm;
>   };
> 


-- 
Pierre Morel
Linux/KVM/QEMU in Böblingen - Germany

