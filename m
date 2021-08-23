Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 236733F5280
	for <lists+kvm@lfdr.de>; Mon, 23 Aug 2021 22:57:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232657AbhHWU62 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Aug 2021 16:58:28 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:25546 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232594AbhHWU6Y (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 23 Aug 2021 16:58:24 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17NKYJjk009075;
        Mon, 23 Aug 2021 16:57:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=97oOFPGnDW0ULGQ6yPsnsxjViA7YSP9ad5LnyVzO0rQ=;
 b=dRGG0dwQV4Kwhewx41Bbb0abyh8NnQ81kdOel6Ut8TiYL8C9cEf3eDi3O/3DYxJw2AuQ
 X6vzPSglnFXFKJmRty9Y9XNMjDCcQB3tYGqrR8cbTpP/8AJixWSF10qNBlPzyqGB4HBq
 +CfMLMaNFWQNE64Am2eC2Xjsh5GJw8aZvyt+yVBYUyTjIZpyij5Wia7N1+Nf+zRtRwcX
 jUhaiK6luqWO6IKs+8LpM5DeePKEBp7NO/31gHcZcuxUd/Zun9+6Y7X+P/PHFNKkBZ+k
 VXHnWqJPgOX7XTO23IOrQ2f9V62jh+ysGFWPW4q9rN/ViZtzXd+wnecLQvcwNP0CrAxO uA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3amcjjmcvv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 Aug 2021 16:57:37 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17NKYYvx009552;
        Mon, 23 Aug 2021 16:57:36 -0400
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3amcjjmcvq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 Aug 2021 16:57:36 -0400
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17NKvGSY022020;
        Mon, 23 Aug 2021 20:57:35 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma03wdc.us.ibm.com with ESMTP id 3ajs4b43bv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 Aug 2021 20:57:35 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17NKvYhM46793146
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Aug 2021 20:57:34 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 98DC5136067;
        Mon, 23 Aug 2021 20:57:34 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8ED1013604F;
        Mon, 23 Aug 2021 20:57:31 +0000 (GMT)
Received: from cpe-172-100-181-211.stny.res.rr.com (unknown [9.160.182.229])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 23 Aug 2021 20:57:31 +0000 (GMT)
Subject: Re: [PATCH v4] vfio/ap_ops: Convert to use vfio_register_group_dev()
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        linux-s390@vger.kernel.org, Halil Pasic <pasic@linux.ibm.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Christoph Hellwig <hch@lst.de>, kvm@vger.kernel.org
References: <0-v4-0203a4ab0596+f7-vfio_ap_jgg@nvidia.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <206c91b5-ad94-06d8-f187-d55d8708b7b2@linux.ibm.com>
Date:   Mon, 23 Aug 2021 16:57:30 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <0-v4-0203a4ab0596+f7-vfio_ap_jgg@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: rtEH2jblID484hHh9hkEOBk2txy_tkqd
X-Proofpoint-ORIG-GUID: u1iKqw0ftUZrOnyeK0c22s-XKuj_pezu
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-23_04:2021-08-23,2021-08-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxlogscore=999
 malwarescore=0 phishscore=0 lowpriorityscore=0 adultscore=0
 impostorscore=0 bulkscore=0 suspectscore=0 mlxscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108230140
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 8/23/21 10:42 AM, Jason Gunthorpe wrote:
> This is straightforward conversion, the ap_matrix_mdev is actually serving
> as the vfio_device and we can replace all the mdev_get_drvdata()'s with a
> simple container_of() or a dev_get_drvdata() for sysfs paths.
>
> Cc: Alex Williamson <alex.williamson@redhat.com>
> Cc: Cornelia Huck <cohuck@redhat.com>
> Cc: kvm@vger.kernel.org
> Cc: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Tony Krowiak <akrowiak@linux.ibm.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>   drivers/s390/crypto/vfio_ap_ops.c     | 155 +++++++++++++++-----------
>   drivers/s390/crypto/vfio_ap_private.h |   2 +
>   2 files changed, 91 insertions(+), 66 deletions(-)
>
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> index cee5626fe0a4ef..ca2ee1f6736a64 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -24,8 +24,9 @@
>   #define VFIO_AP_MDEV_TYPE_HWVIRT "passthrough"
>   #define VFIO_AP_MDEV_NAME_HWVIRT "VFIO AP Passthrough Device"
>   
> -static int vfio_ap_mdev_reset_queues(struct mdev_device *mdev);
> +static int vfio_ap_mdev_reset_queues(struct ap_matrix_mdev *matrix_mdev);
>   static struct vfio_ap_queue *vfio_ap_find_queue(int apqn);
> +static const struct vfio_device_ops vfio_ap_matrix_dev_ops;
>   
>   static int match_apqn(struct device *dev, const void *data)
>   {
> @@ -335,45 +336,59 @@ static void vfio_ap_matrix_init(struct ap_config_info *info,
>   	matrix->adm_max = info->apxa ? info->Nd : 15;
>   }
>   
> -static int vfio_ap_mdev_create(struct mdev_device *mdev)
> +static int vfio_ap_mdev_probe(struct mdev_device *mdev)
>   {
>   	struct ap_matrix_mdev *matrix_mdev;
> +	int ret;
>   
>   	if ((atomic_dec_if_positive(&matrix_dev->available_instances) < 0))
>   		return -EPERM;
>   
>   	matrix_mdev = kzalloc(sizeof(*matrix_mdev), GFP_KERNEL);
>   	if (!matrix_mdev) {
> -		atomic_inc(&matrix_dev->available_instances);
> -		return -ENOMEM;
> +		ret = -ENOMEM;
> +		goto err_dec_available;
>   	}
> +	vfio_init_group_dev(&matrix_mdev->vdev, &mdev->dev,
> +			    &vfio_ap_matrix_dev_ops);
>   
>   	matrix_mdev->mdev = mdev;
>   	vfio_ap_matrix_init(&matrix_dev->info, &matrix_mdev->matrix);
>   	init_waitqueue_head(&matrix_mdev->wait_for_kvm);
> -	mdev_set_drvdata(mdev, matrix_mdev);
>   	matrix_mdev->pqap_hook.hook = handle_pqap;
>   	matrix_mdev->pqap_hook.owner = THIS_MODULE;
>   	mutex_lock(&matrix_dev->lock);
>   	list_add(&matrix_mdev->node, &matrix_dev->mdev_list);
>   	mutex_unlock(&matrix_dev->lock);
>   
> +	ret = vfio_register_group_dev(&matrix_mdev->vdev);
> +	if (ret)
> +		goto err_list;
> +	dev_set_drvdata(&mdev->dev, matrix_mdev);
>   	return 0;
> +
> +err_list:
> +	mutex_lock(&matrix_dev->lock);
> +	list_del(&matrix_mdev->node);
> +	mutex_unlock(&matrix_dev->lock);
> +	kfree(matrix_mdev);
> +err_dec_available:
> +	atomic_inc(&matrix_dev->available_instances);
> +	return ret;
>   }
>   
> -static int vfio_ap_mdev_remove(struct mdev_device *mdev)
> +static void vfio_ap_mdev_remove(struct mdev_device *mdev)
>   {
> -	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
> +	struct ap_matrix_mdev *matrix_mdev = dev_get_drvdata(&mdev->dev);
> +
> +	vfio_unregister_group_dev(&matrix_mdev->vdev);
>   
>   	mutex_lock(&matrix_dev->lock);
> -	vfio_ap_mdev_reset_queues(mdev);
> +	vfio_ap_mdev_reset_queues(matrix_mdev);
>   	list_del(&matrix_mdev->node);
>   	kfree(matrix_mdev);
> -	mdev_set_drvdata(mdev, NULL);
>   	atomic_inc(&matrix_dev->available_instances);
>   	mutex_unlock(&matrix_dev->lock);
> -
> -	return 0;
>   }
>   
>   static ssize_t name_show(struct mdev_type *mtype,
> @@ -615,8 +630,7 @@ static ssize_t assign_adapter_store(struct device *dev,
>   {
>   	int ret;
>   	unsigned long apid;
> -	struct mdev_device *mdev = mdev_from_dev(dev);
> -	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
> +	struct ap_matrix_mdev *matrix_mdev = dev_get_drvdata(dev);
>   
>   	mutex_lock(&matrix_dev->lock);
>   
> @@ -688,8 +702,7 @@ static ssize_t unassign_adapter_store(struct device *dev,
>   {
>   	int ret;
>   	unsigned long apid;
> -	struct mdev_device *mdev = mdev_from_dev(dev);
> -	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
> +	struct ap_matrix_mdev *matrix_mdev = dev_get_drvdata(dev);
>   
>   	mutex_lock(&matrix_dev->lock);
>   
> @@ -777,8 +790,7 @@ static ssize_t assign_domain_store(struct device *dev,
>   {
>   	int ret;
>   	unsigned long apqi;
> -	struct mdev_device *mdev = mdev_from_dev(dev);
> -	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
> +	struct ap_matrix_mdev *matrix_mdev = dev_get_drvdata(dev);
>   	unsigned long max_apqi = matrix_mdev->matrix.aqm_max;
>   
>   	mutex_lock(&matrix_dev->lock);
> @@ -846,8 +858,7 @@ static ssize_t unassign_domain_store(struct device *dev,
>   {
>   	int ret;
>   	unsigned long apqi;
> -	struct mdev_device *mdev = mdev_from_dev(dev);
> -	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
> +	struct ap_matrix_mdev *matrix_mdev = dev_get_drvdata(dev);
>   
>   	mutex_lock(&matrix_dev->lock);
>   
> @@ -900,8 +911,7 @@ static ssize_t assign_control_domain_store(struct device *dev,
>   {
>   	int ret;
>   	unsigned long id;
> -	struct mdev_device *mdev = mdev_from_dev(dev);
> -	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
> +	struct ap_matrix_mdev *matrix_mdev = dev_get_drvdata(dev);
>   
>   	mutex_lock(&matrix_dev->lock);
>   
> @@ -958,8 +968,7 @@ static ssize_t unassign_control_domain_store(struct device *dev,
>   {
>   	int ret;
>   	unsigned long domid;
> -	struct mdev_device *mdev = mdev_from_dev(dev);
> -	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
> +	struct ap_matrix_mdev *matrix_mdev = dev_get_drvdata(dev);
>   	unsigned long max_domid =  matrix_mdev->matrix.adm_max;
>   
>   	mutex_lock(&matrix_dev->lock);
> @@ -997,8 +1006,7 @@ static ssize_t control_domains_show(struct device *dev,
>   	int nchars = 0;
>   	int n;
>   	char *bufpos = buf;
> -	struct mdev_device *mdev = mdev_from_dev(dev);
> -	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
> +	struct ap_matrix_mdev *matrix_mdev = dev_get_drvdata(dev);
>   	unsigned long max_domid = matrix_mdev->matrix.adm_max;
>   
>   	mutex_lock(&matrix_dev->lock);
> @@ -1016,8 +1024,7 @@ static DEVICE_ATTR_RO(control_domains);
>   static ssize_t matrix_show(struct device *dev, struct device_attribute *attr,
>   			   char *buf)
>   {
> -	struct mdev_device *mdev = mdev_from_dev(dev);
> -	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
> +	struct ap_matrix_mdev *matrix_mdev = dev_get_drvdata(dev);
>   	char *bufpos = buf;
>   	unsigned long apid;
>   	unsigned long apqi;
> @@ -1191,7 +1198,7 @@ static void vfio_ap_mdev_unset_kvm(struct ap_matrix_mdev *matrix_mdev)
>   		mutex_unlock(&matrix_dev->lock);
>   		kvm_arch_crypto_clear_masks(matrix_mdev->kvm);
>   		mutex_lock(&matrix_dev->lock);
> -		vfio_ap_mdev_reset_queues(matrix_mdev->mdev);
> +		vfio_ap_mdev_reset_queues(matrix_mdev);
>   		matrix_mdev->kvm->arch.crypto.pqap_hook = NULL;
>   		kvm_put_kvm(matrix_mdev->kvm);
>   		matrix_mdev->kvm = NULL;
> @@ -1288,13 +1295,12 @@ int vfio_ap_mdev_reset_queue(struct vfio_ap_queue *q,
>   	return ret;
>   }
>   
> -static int vfio_ap_mdev_reset_queues(struct mdev_device *mdev)
> +static int vfio_ap_mdev_reset_queues(struct ap_matrix_mdev *matrix_mdev)
>   {
>   	int ret;
>   	int rc = 0;
>   	unsigned long apid, apqi;
>   	struct vfio_ap_queue *q;
> -	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
>   
>   	for_each_set_bit_inv(apid, matrix_mdev->matrix.apm,
>   			     matrix_mdev->matrix.apm_max + 1) {
> @@ -1315,52 +1321,48 @@ static int vfio_ap_mdev_reset_queues(struct mdev_device *mdev)
>   	return rc;
>   }
>   
> -static int vfio_ap_mdev_open_device(struct mdev_device *mdev)
> +static int vfio_ap_mdev_open_device(struct vfio_device *vdev)
>   {
> -	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
> +	struct ap_matrix_mdev *matrix_mdev =
> +		container_of(vdev, struct ap_matrix_mdev, vdev);
>   	unsigned long events;
>   	int ret;
>   
> -
> -	if (!try_module_get(THIS_MODULE))
> -		return -ENODEV;

Not a big deal, but why did you remove this? Isn't it beneficial to
get a message that the module can't be removed until
the last ref is released?

> -
>   	matrix_mdev->group_notifier.notifier_call = vfio_ap_mdev_group_notifier;
>   	events = VFIO_GROUP_NOTIFY_SET_KVM;
>   
> -	ret = vfio_register_notifier(mdev_dev(mdev), VFIO_GROUP_NOTIFY,
> +	ret = vfio_register_notifier(vdev->dev, VFIO_GROUP_NOTIFY,
>   				     &events, &matrix_mdev->group_notifier);
> -	if (ret) {
> -		module_put(THIS_MODULE);
> +	if (ret)
>   		return ret;
> -	}
>   
>   	matrix_mdev->iommu_notifier.notifier_call = vfio_ap_mdev_iommu_notifier;
>   	events = VFIO_IOMMU_NOTIFY_DMA_UNMAP;
> -	ret = vfio_register_notifier(mdev_dev(mdev), VFIO_IOMMU_NOTIFY,
> +	ret = vfio_register_notifier(vdev->dev, VFIO_IOMMU_NOTIFY,
>   				     &events, &matrix_mdev->iommu_notifier);
> -	if (!ret)
> -		return ret;
> +	if (ret)
> +		goto out_unregister_group;
> +	return 0;
>   
> -	vfio_unregister_notifier(mdev_dev(mdev), VFIO_GROUP_NOTIFY,
> +out_unregister_group:
> +	vfio_unregister_notifier(vdev->dev, VFIO_GROUP_NOTIFY,
>   				 &matrix_mdev->group_notifier);
> -	module_put(THIS_MODULE);
>   	return ret;
>   }
>   
> -static void vfio_ap_mdev_close_device(struct mdev_device *mdev)
> +static void vfio_ap_mdev_close_device(struct vfio_device *vdev)
>   {
> -	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
> +	struct ap_matrix_mdev *matrix_mdev =
> +		container_of(vdev, struct ap_matrix_mdev, vdev);
>   
>   	mutex_lock(&matrix_dev->lock);
>   	vfio_ap_mdev_unset_kvm(matrix_mdev);
>   	mutex_unlock(&matrix_dev->lock);
>   
> -	vfio_unregister_notifier(mdev_dev(mdev), VFIO_IOMMU_NOTIFY,
> +	vfio_unregister_notifier(vdev->dev, VFIO_IOMMU_NOTIFY,
>   				 &matrix_mdev->iommu_notifier);
> -	vfio_unregister_notifier(mdev_dev(mdev), VFIO_GROUP_NOTIFY,
> +	vfio_unregister_notifier(vdev->dev, VFIO_GROUP_NOTIFY,
>   				 &matrix_mdev->group_notifier);
> -	module_put(THIS_MODULE);
>   }
>   
>   static int vfio_ap_mdev_get_device_info(unsigned long arg)
> @@ -1383,11 +1385,12 @@ static int vfio_ap_mdev_get_device_info(unsigned long arg)
>   	return copy_to_user((void __user *)arg, &info, minsz) ? -EFAULT : 0;
>   }
>   
> -static ssize_t vfio_ap_mdev_ioctl(struct mdev_device *mdev,
> +static ssize_t vfio_ap_mdev_ioctl(struct vfio_device *vdev,
>   				    unsigned int cmd, unsigned long arg)
>   {
> +	struct ap_matrix_mdev *matrix_mdev =
> +		container_of(vdev, struct ap_matrix_mdev, vdev);
>   	int ret;
> -	struct ap_matrix_mdev *matrix_mdev;
>   
>   	mutex_lock(&matrix_dev->lock);
>   	switch (cmd) {
> @@ -1395,12 +1398,6 @@ static ssize_t vfio_ap_mdev_ioctl(struct mdev_device *mdev,
>   		ret = vfio_ap_mdev_get_device_info(arg);
>   		break;
>   	case VFIO_DEVICE_RESET:
> -		matrix_mdev = mdev_get_drvdata(mdev);
> -		if (WARN(!matrix_mdev, "Driver data missing from mdev!!")) {
> -			ret = -EINVAL;
> -			break;
> -		}
> -
>   		/*
>   		 * If the KVM pointer is in the process of being set, wait until
>   		 * the process has completed.
> @@ -1410,7 +1407,7 @@ static ssize_t vfio_ap_mdev_ioctl(struct mdev_device *mdev,
>   			       mutex_unlock(&matrix_dev->lock),
>   			       mutex_lock(&matrix_dev->lock));
>   
> -		ret = vfio_ap_mdev_reset_queues(mdev);
> +		ret = vfio_ap_mdev_reset_queues(matrix_mdev);
>   		break;
>   	default:
>   		ret = -EOPNOTSUPP;
> @@ -1421,25 +1418,51 @@ static ssize_t vfio_ap_mdev_ioctl(struct mdev_device *mdev,
>   	return ret;
>   }
>   
> +static const struct vfio_device_ops vfio_ap_matrix_dev_ops = {
> +	.open_device = vfio_ap_mdev_open_device,
> +	.close_device = vfio_ap_mdev_close_device,
> +	.ioctl = vfio_ap_mdev_ioctl,
> +};
> +
> +static struct mdev_driver vfio_ap_matrix_driver = {
> +	.driver = {
> +		.name = "vfio_ap_mdev",
> +		.owner = THIS_MODULE,
> +		.mod_name = KBUILD_MODNAME,
> +		.dev_groups = vfio_ap_mdev_attr_groups,
> +	},
> +	.probe = vfio_ap_mdev_probe,
> +	.remove = vfio_ap_mdev_remove,
> +};
> +
>   static const struct mdev_parent_ops vfio_ap_matrix_ops = {
>   	.owner			= THIS_MODULE,
> +	.device_driver		= &vfio_ap_matrix_driver,
>   	.supported_type_groups	= vfio_ap_mdev_type_groups,
> -	.mdev_attr_groups	= vfio_ap_mdev_attr_groups,
> -	.create			= vfio_ap_mdev_create,
> -	.remove			= vfio_ap_mdev_remove,
> -	.open_device		= vfio_ap_mdev_open_device,
> -	.close_device		= vfio_ap_mdev_close_device,
> -	.ioctl			= vfio_ap_mdev_ioctl,
>   };
>   
>   int vfio_ap_mdev_register(void)
>   {
> +	int ret;
> +
>   	atomic_set(&matrix_dev->available_instances, MAX_ZDEV_ENTRIES_EXT);
>   
> -	return mdev_register_device(&matrix_dev->device, &vfio_ap_matrix_ops);
> +	ret = mdev_register_driver(&vfio_ap_matrix_driver);
> +	if (ret)
> +		return ret;
> +
> +	ret = mdev_register_device(&matrix_dev->device, &vfio_ap_matrix_ops);
> +	if (ret)
> +		goto err_driver;
> +	return 0;
> +
> +err_driver:
> +	mdev_unregister_driver(&vfio_ap_matrix_driver);
> +	return ret;
>   }
>   
>   void vfio_ap_mdev_unregister(void)
>   {
>   	mdev_unregister_device(&matrix_dev->device);
> +	mdev_unregister_driver(&vfio_ap_matrix_driver);
>   }
> diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
> index f82a6396acae7a..5746a00a7696a1 100644
> --- a/drivers/s390/crypto/vfio_ap_private.h
> +++ b/drivers/s390/crypto/vfio_ap_private.h
> @@ -18,6 +18,7 @@
>   #include <linux/delay.h>
>   #include <linux/mutex.h>
>   #include <linux/kvm_host.h>
> +#include <linux/vfio.h>
>   
>   #include "ap_bus.h"
>   
> @@ -79,6 +80,7 @@ struct ap_matrix {
>    * @kvm:	the struct holding guest's state
>    */
>   struct ap_matrix_mdev {
> +	struct vfio_device vdev;
>   	struct list_head node;
>   	struct ap_matrix matrix;
>   	struct notifier_block group_notifier;
>
> base-commit: eb24c1007e6852e024dc33b0dd9617b8500a1291

