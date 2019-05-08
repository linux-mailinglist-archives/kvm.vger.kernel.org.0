Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D068180EB
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 22:17:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728386AbfEHURm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 16:17:42 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:54218 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726830AbfEHURl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 May 2019 16:17:41 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x48KCwuJ016512;
        Wed, 8 May 2019 16:17:36 -0400
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2sc4svbgnr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 May 2019 16:17:36 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x48EIhJD020295;
        Wed, 8 May 2019 14:21:45 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma01dal.us.ibm.com with ESMTP id 2s92c40cva-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 May 2019 14:21:45 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x48KHWIO30212322
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 May 2019 20:17:32 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CC48D28059;
        Wed,  8 May 2019 20:17:32 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0901328058;
        Wed,  8 May 2019 20:17:32 +0000 (GMT)
Received: from [9.80.194.137] (unknown [9.80.194.137])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed,  8 May 2019 20:17:31 +0000 (GMT)
Subject: Re: [PATCH v8 3/4] s390: ap: implement PAPQ AQIC interception in
 kernel
To:     Pierre Morel <pmorel@linux.ibm.com>, borntraeger@de.ibm.com
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, frankja@linux.ibm.com, pasic@linux.ibm.com,
        david@redhat.com, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, freude@linux.ibm.com, mimu@linux.ibm.com
References: <1556818451-1806-1-git-send-email-pmorel@linux.ibm.com>
 <1556818451-1806-4-git-send-email-pmorel@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <adcec876-22f5-89fb-3dcc-ad843d6f8f64@linux.ibm.com>
Date:   Wed, 8 May 2019 16:17:31 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <1556818451-1806-4-git-send-email-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-08_11:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905080124
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/2/19 1:34 PM, Pierre Morel wrote:
> We register a AP PQAP instruction hook during the open
> of the mediated device. And unregister it on release.
> 
> During the probe of the AP device, we allocate a vfio_ap_queue
> structure to keep track of the information we need for the
> PQAP/AQIC instruction interception.
> 
> In the AP PQAP instruction hook, if we receive a demand to
> enable IRQs,
> - we retrieve the vfio_ap_queue based on the APQN we receive
>    in REG1,
> - we retrieve the page of the guest address, (NIB), from
>    register REG2
> - we retrieve the mediated device to use the VFIO pinning
>    infrastructure to pin the page of the guest address,
> - we retrieve the pointer to KVM to register the guest ISC
>    and retrieve the host ISC
> - finaly we activate GISA
> 
> If we receive a demand to disable IRQs,
> - we deactivate GISA
> - unregister from the GIB
> - unping the NIB

s/unping/unpin

> 
> When removing the AP device from the driver the device is
> reseted and this process unregisters the GISA from the GIB,
> and unpins the NIB address then we free the vfio_ap_queue
> structure.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>   drivers/s390/crypto/ap_bus.h          |   1 +
>   drivers/s390/crypto/vfio_ap_drv.c     |  36 ++++-
>   drivers/s390/crypto/vfio_ap_ops.c     | 283 +++++++++++++++++++++++++++++++++-
>   drivers/s390/crypto/vfio_ap_private.h |  11 ++
>   4 files changed, 324 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/s390/crypto/ap_bus.h b/drivers/s390/crypto/ap_bus.h
> index 15a98a6..60e70f3 100644
> --- a/drivers/s390/crypto/ap_bus.h
> +++ b/drivers/s390/crypto/ap_bus.h
> @@ -43,6 +43,7 @@ static inline int ap_test_bit(unsigned int *ptr, unsigned int nr)
>   #define AP_RESPONSE_BUSY		0x05
>   #define AP_RESPONSE_INVALID_ADDRESS	0x06
>   #define AP_RESPONSE_OTHERWISE_CHANGED	0x07
> +#define AP_RESPONSE_INVALID_GISA	0x08
>   #define AP_RESPONSE_Q_FULL		0x10
>   #define AP_RESPONSE_NO_PENDING_REPLY	0x10
>   #define AP_RESPONSE_INDEX_TOO_BIG	0x11
> diff --git a/drivers/s390/crypto/vfio_ap_drv.c b/drivers/s390/crypto/vfio_ap_drv.c
> index e9824c3..d7d8341 100644
> --- a/drivers/s390/crypto/vfio_ap_drv.c
> +++ b/drivers/s390/crypto/vfio_ap_drv.c
> @@ -5,6 +5,7 @@
>    * Copyright IBM Corp. 2018
>    *
>    * Author(s): Tony Krowiak <akrowiak@linux.ibm.com>
> + *	      Pierre Morel <pmorel@linux.ibm.com>
>    */
>   
>   #include <linux/module.h>
> @@ -40,14 +41,47 @@ static struct ap_device_id ap_queue_ids[] = {
>   
>   MODULE_DEVICE_TABLE(vfio_ap, ap_queue_ids);
>   
> +/**
> + * vfio_ap_queue_dev_probe:
> + *
> + * Allocate a vfio_ap_queue structure and associate it
> + * with the device as driver_data.
> + */
>   static int vfio_ap_queue_dev_probe(struct ap_device *apdev)
>   {
> +	struct vfio_ap_queue *q;
> +
> +	q = kzalloc(sizeof(*q), GFP_KERNEL);
> +	if (!q)
> +		return -ENOMEM;
> +	dev_set_drvdata(&apdev->device, q);
> +	q->apqn = to_ap_queue(&apdev->device)->qid;
> +	q->saved_isc = VFIO_AP_ISC_INVALID;
>   	return 0;
>   }
>   
> +/**
> + * vfio_ap_queue_dev_remove:
> + *
> + * Takes the matrix lock to avoid actions on this device while removing
> + * Free the associated vfio_ap_queue structure
> + */
>   static void vfio_ap_queue_dev_remove(struct ap_device *apdev)
>   {
> -	/* Nothing to do yet */
> +	struct vfio_ap_queue *q;
> +	int apid, apqi;
> +
> +	mutex_lock(&matrix_dev->lock);
> +	q = dev_get_drvdata(&apdev->device);
> +	dev_set_drvdata(&apdev->device, NULL);
> +	if (q) {
> +		apid = AP_QID_CARD(q->apqn);
> +		apqi = AP_QID_QUEUE(q->apqn);
> +		vfio_ap_mdev_reset_queue(apid, apqi, 1);

As you know, there is another patch series (s390: vfio-ap: dynamic
configuration support) posted concurrently with this series. That series
handles reset on remove of an AP queue device. It looks like your
choices here will greatly conflict with the reset processing in the
other patch series and create a nasty merge conflict. My suggestion is
that you build this patch series on top of the other series and do
the following:

There are two new functions introduced in vfio_ap_private.h:
void vfio_ap_mdev_remove_queue(struct ap_queue *queue);
void vfio_ap_mdev_probe_queue(struct ap_queue *queue);

These are called from the probe and remove callbacks in vfio_ap_drv.c.
If you embed your changes to the probe and remove functions above into
those new functions, that will make merging the two much easier and
the code cleaner IMHO.

> +		vfio_ap_irq_disable(q);
> +		kfree(q);
> +	}
> +	mutex_unlock(&matrix_dev->lock);
>   }
>   
>   static void vfio_ap_matrix_dev_release(struct device *dev)
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> index e8e87bf..448c40c 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -24,6 +24,242 @@
>   #define VFIO_AP_MDEV_TYPE_HWVIRT "passthrough"
>   #define VFIO_AP_MDEV_NAME_HWVIRT "VFIO AP Passthrough Device"
>   
> +static int vfio_ap_mdev_reset_queues(struct mdev_device *mdev);
> +
> +static int match_apqn(struct device *dev, void *data)
> +{
> +	struct vfio_ap_queue *q = dev_get_drvdata(dev);
> +
> +	return (q->apqn == *(int *)(data)) ? 1 : 0;
> +}

This same function is also already included in the other patch
series (s390: vfio-ap: dynamic configuration support) posted
concurrently with this series. This is another good reason to
build yours on top of that series.

> +
> +/**
> + * vfio_ap_get_queue: Retrieve a queue with a specific APQN from a list
> + * @matrix_mdev: the associated mediated matrix
> + * @apqn: The queue APQN
> + *
> + * Retrieve a queue with a specific APQN from the list of the
> + * devices of the vfio_ap_drv.
> + * Verify that the APID and the APQI are set in the matrix.
> + *
> + * Returns the pointer to the associated vfio_ap_queue
> + */
> +struct vfio_ap_queue *vfio_ap_get_queue(struct ap_matrix_mdev *matrix_mdev,
> +					int apqn)
> +{
> +	struct vfio_ap_queue *q;
> +	struct device *dev;
> +
> +	if (!test_bit_inv(AP_QID_CARD(apqn), matrix_mdev->matrix.apm))
> +		return NULL;
> +	if (!test_bit_inv(AP_QID_QUEUE(apqn), matrix_mdev->matrix.aqm))
> +		return NULL;
> +
> +	dev = driver_find_device(&matrix_dev->vfio_ap_drv->driver, NULL,
> +				 &apqn, match_apqn);

If you build this series on top of the other series, it has a
vfio_ap_get_queue_dev function that can be called from here.

> +	if (!dev)
> +		return NULL;
> +	q = dev_get_drvdata(dev);
> +	q->matrix_mdev = matrix_mdev;
> +	put_device(dev);
> +
> +	return q;
> +}
> +
> +/**
> + * vfio_ap_irq_disable
> + * @q: The vfio_ap_queue
> + *
> + * Unpin the guest NIB
> + * Unregister the ISC from the GIB alert
> + * Clear the vfio_ap_queue intern fields
> + *
> + * Important notice:
> + * Before calling this function, interrupt must have been
> + * unregistered by use of ap_zapq/ap_reset or ap_aqic.
> + */
> +struct ap_queue_status vfio_ap_irq_disable(struct vfio_ap_queue *q)
> +{
> +	struct ap_qirq_ctrl aqic_gisa;
> +	struct ap_queue_status status = {
> +			.response_code = AP_RESPONSE_Q_NOT_AVAIL,
> +			};
> +	int retry_tapq = 5;
> +	int retry_aqic = 5;
> +
> +	if (!q)

When will q ever be NULL? I checked all places where this is called and
it looks to me like this will never happen.

> +		return status;
> +
> +again:

I'm not crazy about using a label, why not a do/while
loop or something of that nature?

> +	status = ap_aqic(q->apqn, aqic_gisa, NULL);
> +	switch (status.response_code) {
> +	case AP_RESPONSE_OTHERWISE_CHANGED:
> +	case AP_RESPONSE_RESET_IN_PROGRESS:
> +	case AP_RESPONSE_NORMAL: /* Fall through */
> +		while (status.irq_enabled && retry_tapq--) {
> +			msleep(20);
> +			status = ap_tapq(q->apqn, NULL);

Shouldn't you be checking response codes from the TAPQ
function? Maybe there should be a function call here to
with for IRQ disabled?

> +		}
> +		break;
> +	case AP_RESPONSE_BUSY:
> +		msleep(20);
> +		if (retry_aqic-- < 0)
> +			return status;
> +		goto again;
> +	default:
> +		WARN_ONCE(1, "%s: ap_aqic status %d\n", __func__,
> +			  status.response_code);
> +		return status;
> +	}
> +
> +	if (q->saved_isc != VFIO_AP_ISC_INVALID && q->matrix_mdev)
> +		kvm_s390_gisc_unregister(q->matrix_mdev->kvm, q->saved_isc);
> +	if (q->saved_pfn && q->matrix_mdev)
> +		vfio_unpin_pages(mdev_dev(q->matrix_mdev->mdev),
> +				 &q->saved_pfn, 1);

NIT:

Both if statements above check q->matrix_mdev, how about wrapping the
two if statements inside of "if (q->matrix_mdev)" block?

> +
> +	q->saved_pfn = 0;
> +	q->saved_isc = VFIO_AP_ISC_INVALID;
> +	q->matrix_mdev = NULL;
> +	return (struct ap_queue_status) {};
> +}
> +
> +/**
> + * vfio_ap_setirq: Enable Interruption for a APQN
> + *
> + * @dev: the device associated with the ap_queue
> + * @q:   the vfio_ap_queue holding AQIC parameters
> + *
> + * Pin the NIB saved in *q
> + * Register the guest ISC to GIB interface and retrieve the
> + * host ISC to issue the host side PQAP/AQIC
> + *
> + * Response.status may be set to following Response Code in case of error:
> + * - AP_RESPONSE_INVALID_ADDRESS: vfio_pin_pages failed
> + * - AP_RESPONSE_OTHERWISE_CHANGED: Hypervizor GISA internal error
> + *
> + * Otherwise return the ap_queue_status returned by the ap_aqic()
> + */
> +static struct ap_queue_status vfio_ap_irq_enable(struct vfio_ap_queue *q,
> +						 int isc,
> +						 unsigned long nib)
> +{
> +	struct ap_qirq_ctrl aqic_gisa = {};
> +	struct ap_queue_status status = {};
> +	struct kvm_s390_gisa *gisa;
> +	struct kvm *kvm;
> +	unsigned long h_nib, g_pfn, h_pfn;
> +	int ret;
> +
> +	g_pfn = nib >> PAGE_SHIFT;
> +	ret = vfio_pin_pages(mdev_dev(q->matrix_mdev->mdev), &g_pfn, 1,
> +			     IOMMU_READ | IOMMU_WRITE, &h_pfn);
> +	switch (ret) {
> +	case 1:
> +		break;
> +	default:
> +		status.response_code = AP_RESPONSE_INVALID_ADDRESS;
> +		return status;
> +	}
> +
> +	kvm = q->matrix_mdev->kvm;
> +	gisa = kvm->arch.gisa_int.origin;
> +
> +	h_nib = (h_pfn << PAGE_SHIFT) | (nib & ~PAGE_MASK);
> +	aqic_gisa.gisc = isc;
> +	aqic_gisa.isc = kvm_s390_gisc_register(kvm, isc);
> +	aqic_gisa.ir = 1;
> +	aqic_gisa.gisa = (uint64_t)gisa >> 4;
> +
> +	status = ap_aqic(q->apqn, aqic_gisa, (void *)h_nib);
> +	switch (status.response_code) {
> +	case AP_RESPONSE_NORMAL:
> +		/* See if we did clear older IRQ configuration */
> +		if (q->saved_pfn)
> +			vfio_unpin_pages(mdev_dev(q->matrix_mdev->mdev),
> +					 &q->saved_pfn, 1);
> +		if (q->saved_isc != VFIO_AP_ISC_INVALID)
> +			kvm_s390_gisc_unregister(kvm, q->saved_isc);
> +		q->saved_pfn = g_pfn;
> +		q->saved_isc = isc;
> +		break;
> +	case AP_RESPONSE_OTHERWISE_CHANGED:
> +		/* We could not modify IRQ setings: clear new configuration */
> +		vfio_unpin_pages(mdev_dev(q->matrix_mdev->mdev), &g_pfn, 1);
> +		kvm_s390_gisc_unregister(kvm, isc);
> +		break;
> +	default:
> +		pr_warn("%s: apqn %04x: response: %02x\n", __func__, q->apqn,
> +			status.response_code);
> +		vfio_ap_irq_disable(q);
> +		break;
> +	}
> +
> +	return status;
> +}
> +
> +/**
> + * handle_pqap: PQAP instruction callback
> + *
> + * @vcpu: The vcpu on which we received the PQAP instruction
> + *
> + * Get the general register contents to initialize internal variables.
> + * REG[0]: APQN
> + * REG[1]: IR and ISC
> + * REG[2]: NIB
> + *
> + * Response.status may be set to following Response Code:
> + * - AP_RESPONSE_Q_NOT_AVAIL: if the queue is not available
> + * - AP_RESPONSE_DECONFIGURED: if the queue is not configured
> + * - AP_RESPONSE_NORMAL (0) : in case of successs
> + *   Check vfio_ap_setirq() and vfio_ap_clrirq() for other possible RC.
> + * We take the matrix_dev lock to ensure serialization on queues and
> + * mediated device access.
> + *
> + * Return 0 if we could handle the request inside KVM.
> + * otherwise, returns -EOPNOTSUPP to let QEMU handle the fault.
> + */
> +static int handle_pqap(struct kvm_vcpu *vcpu)
> +{
> +	uint64_t status;
> +	uint16_t apqn;
> +	struct vfio_ap_queue *q;
> +	struct ap_queue_status qstatus = {
> +			       .response_code = AP_RESPONSE_Q_NOT_AVAIL, };
> +	struct ap_matrix_mdev *matrix_mdev;
> +
> +	/* If we do not use the AIV facility just go to userland */
> +	if (!(vcpu->arch.sie_block->eca & ECA_AIV))
> +		return -EOPNOTSUPP;
> +
> +	apqn = vcpu->run->s.regs.gprs[0] & 0xffff;
> +	mutex_lock(&matrix_dev->lock);
> +
> +	if (!vcpu->kvm->arch.crypto.pqap_hook)
> +		goto out_unlock;
> +	matrix_mdev = container_of(vcpu->kvm->arch.crypto.pqap_hook,
> +				   struct ap_matrix_mdev, pqap_hook);
> +
> +	q = vfio_ap_get_queue(matrix_mdev, apqn);
> +	if (!q)
> +		goto out_unlock;
> +
> +	status = vcpu->run->s.regs.gprs[1];
> +
> +	/* If IR bit(16) is set we enable the interrupt */
> +	if ((status >> (63 - 16)) & 0x01)
> +		qstatus = vfio_ap_irq_enable(q, status & 0x07,
> +					     vcpu->run->s.regs.gprs[2]);
> +	else
> +		qstatus = vfio_ap_irq_disable(q);
> +
> +out_unlock:
> +	memcpy(&vcpu->run->s.regs.gprs[1], &qstatus, sizeof(qstatus));
> +	vcpu->run->s.regs.gprs[1] >>= 32;
> +	mutex_unlock(&matrix_dev->lock);
> +	return 0;
> +}
> +
>   static void vfio_ap_matrix_init(struct ap_config_info *info,
>   				struct ap_matrix *matrix)
>   {
> @@ -45,8 +281,11 @@ static int vfio_ap_mdev_create(struct kobject *kobj, struct mdev_device *mdev)
>   		return -ENOMEM;
>   	}
>   
> +	matrix_mdev->mdev = mdev;
>   	vfio_ap_matrix_init(&matrix_dev->info, &matrix_mdev->matrix);
>   	mdev_set_drvdata(mdev, matrix_mdev);
> +	matrix_mdev->pqap_hook.hook = handle_pqap;
> +	matrix_mdev->pqap_hook.owner = THIS_MODULE;
>   	mutex_lock(&matrix_dev->lock);
>   	list_add(&matrix_mdev->node, &matrix_dev->mdev_list);
>   	mutex_unlock(&matrix_dev->lock);
> @@ -62,6 +301,7 @@ static int vfio_ap_mdev_remove(struct mdev_device *mdev)
>   		return -EBUSY;
>   
>   	mutex_lock(&matrix_dev->lock);
> +	vfio_ap_mdev_reset_queues(mdev);
>   	list_del(&matrix_mdev->node);
>   	mutex_unlock(&matrix_dev->lock);
>   
> @@ -754,6 +994,8 @@ static int vfio_ap_mdev_set_kvm(struct ap_matrix_mdev *matrix_mdev,
>   	}
>   
>   	matrix_mdev->kvm = kvm;
> +	kvm_get_kvm(kvm);
> +	kvm->arch.crypto.pqap_hook = &matrix_mdev->pqap_hook;
>   	mutex_unlock(&matrix_dev->lock);
>   
>   	return 0;
> @@ -819,15 +1061,36 @@ static int vfio_ap_mdev_group_notifier(struct notifier_block *nb,
>   	return NOTIFY_OK;
>   }
>   
> -static int vfio_ap_mdev_reset_queue(unsigned int apid, unsigned int apqi,
> -				    unsigned int retry)
> +static void vfio_ap_irq_disable_apqn(int apqn)
> +{
> +	struct device *dev;
> +	struct vfio_ap_queue *q;
> +
> +	dev = driver_find_device(&matrix_dev->vfio_ap_drv->driver, NULL,
> +				 &apqn, match_apqn);
> +	if (dev) {
> +		q = dev_get_drvdata(dev);
> +		vfio_ap_irq_disable(q);
> +		put_device(dev);
> +	}
> +}
> +
> +int vfio_ap_mdev_reset_queue(unsigned int apid, unsigned int apqi,
> +			     unsigned int retry)
>   {
>   	struct ap_queue_status status;
> +	int retry2 = 2;
> +	int apqn = AP_MKQID(apid, apqi);
>   
>   	do {
> -		status = ap_zapq(AP_MKQID(apid, apqi));
> +		status = ap_zapq(apqn);
>   		switch (status.response_code) {
>   		case AP_RESPONSE_NORMAL:
> +			while (!status.queue_empty && retry2--) {
> +				msleep(20);
> +				status = ap_tapq(apqn, NULL);
> +			}
> +			WARN_ON_ONCE(retry <= 0);
>   			return 0;
>   		case AP_RESPONSE_RESET_IN_PROGRESS:
>   		case AP_RESPONSE_BUSY:
> @@ -861,6 +1124,7 @@ static int vfio_ap_mdev_reset_queues(struct mdev_device *mdev)
>   			 */
>   			if (ret)
>   				rc = ret;
> +			vfio_ap_irq_disable_apqn(AP_MKQID(apid, apqi));
>   		}
>   	}
>   
> @@ -904,15 +1168,20 @@ static void vfio_ap_mdev_release(struct mdev_device *mdev)
>   {
>   	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
>   
> -	if (matrix_mdev->kvm)
> +	mutex_lock(&matrix_dev->lock);
> +	if (matrix_mdev->kvm) {
>   		kvm_arch_crypto_clear_masks(matrix_mdev->kvm);
> +		matrix_mdev->kvm->arch.crypto.pqap_hook = NULL;
> +		vfio_ap_mdev_reset_queues(mdev);
> +		kvm_put_kvm(matrix_mdev->kvm);
> +		matrix_mdev->kvm = NULL;
> +	}
> +	mutex_unlock(&matrix_dev->lock);
>   
> -	vfio_ap_mdev_reset_queues(mdev);
>   	vfio_unregister_notifier(mdev_dev(mdev), VFIO_IOMMU_NOTIFY,
>   				 &matrix_mdev->iommu_notifier);
>   	vfio_unregister_notifier(mdev_dev(mdev), VFIO_GROUP_NOTIFY,
>   				 &matrix_mdev->group_notifier);
> -	matrix_mdev->kvm = NULL;
>   	module_put(THIS_MODULE);
>   }
>   
> @@ -941,6 +1210,7 @@ static ssize_t vfio_ap_mdev_ioctl(struct mdev_device *mdev,
>   {
>   	int ret;
>   
> +	mutex_lock(&matrix_dev->lock);
>   	switch (cmd) {
>   	case VFIO_DEVICE_GET_INFO:
>   		ret = vfio_ap_mdev_get_device_info(arg);
> @@ -952,6 +1222,7 @@ static ssize_t vfio_ap_mdev_ioctl(struct mdev_device *mdev,
>   		ret = -EOPNOTSUPP;
>   		break;
>   	}
> +	mutex_unlock(&matrix_dev->lock);
>   
>   	return ret;
>   }
> diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
> index 18dcc4d..f46dde5 100644
> --- a/drivers/s390/crypto/vfio_ap_private.h
> +++ b/drivers/s390/crypto/vfio_ap_private.h
> @@ -4,6 +4,7 @@
>    *
>    * Author(s): Tony Krowiak <akrowiak@linux.ibm.com>
>    *	      Halil Pasic <pasic@linux.ibm.com>
> + *	      Pierre Morel <pmorel@linux.ibm.com>
>    *
>    * Copyright IBM Corp. 2018
>    */
> @@ -89,5 +90,15 @@ struct ap_matrix_mdev {
>   
>   extern int vfio_ap_mdev_register(void);
>   extern void vfio_ap_mdev_unregister(void);
> +int vfio_ap_mdev_reset_queue(unsigned int apid, unsigned int apqi,
> +			     unsigned int retry);
>   
> +struct vfio_ap_queue {
> +	struct ap_matrix_mdev *matrix_mdev;
> +	unsigned long saved_pfn;
> +	int	apqn;
> +#define VFIO_AP_ISC_INVALID 0xff
> +	unsigned char saved_isc;
> +};
> +struct ap_queue_status vfio_ap_irq_disable(struct vfio_ap_queue *q);
>   #endif /* _VFIO_AP_PRIVATE_H_ */
> 

