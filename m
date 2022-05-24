Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40080532C8D
	for <lists+kvm@lfdr.de>; Tue, 24 May 2022 16:50:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238363AbiEXOuE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 May 2022 10:50:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236171AbiEXOuC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 May 2022 10:50:02 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D41E9B186;
        Tue, 24 May 2022 07:50:01 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24ODnmr9004777;
        Tue, 24 May 2022 14:49:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : reply-to : subject : to : cc : references : from :
 in-reply-to : content-type : content-transfer-encoding; s=pp1;
 bh=MXePOJYBtScFAHW0ImvXEgD630tDNgvr1jNMzrR4k2w=;
 b=Rqq78+ffxULIISd5KS0XGcbTSfoLL51U6rpeRkv2nnLE/fsDT14IIZ2OzIK1j2F4ZaFQ
 ty+hAQyYAnXpuqu7Vt7Vci+9RzvGXUW1aaRFYtOclmKiz31PW55P+kfNfHmvMA/nyDRo
 tk0kbMRAKvulOowWet6v4lQvN48tJJFl6QhPgbzMTV+wblkt9bleUatu0X2nYqM8MHY+
 3XFtpqko8tEH0yYJm7o/oTeKMLQS5rTPIOpO8SEC06sXaGLFXkMNDeOxg/I1DpCNXcHj
 uQVNb4zi4C9b9w6Ek+INgScyCaJ3RhqG0SpKogr8OgXhcLYWOheSuD/TqoLSulo8oLiZ PQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g8ypp31md-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 May 2022 14:49:59 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24OElIed005222;
        Tue, 24 May 2022 14:49:58 GMT
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g8ypp31m2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 May 2022 14:49:58 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24OEhxU7031748;
        Tue, 24 May 2022 14:49:57 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma04dal.us.ibm.com with ESMTP id 3g6qq9pu03-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 May 2022 14:49:57 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24OEnult44630526
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 May 2022 14:49:56 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A80E6112067;
        Tue, 24 May 2022 14:49:56 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5ADE3112063;
        Tue, 24 May 2022 14:49:56 +0000 (GMT)
Received: from [9.60.75.219] (unknown [9.60.75.219])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 24 May 2022 14:49:56 +0000 (GMT)
Message-ID: <c705be10-bbe2-7d44-3057-005299ab6785@linux.ibm.com>
Date:   Tue, 24 May 2022 10:49:56 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Reply-To: jjherne@linux.ibm.com
Subject: Re: [PATCH v19 02/20] s390/vfio-ap: move probe and remove callbacks
 to vfio_ap_ops.c
Content-Language: en-US
To:     Tony Krowiak <akrowiak@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com
References: <20220404221039.1272245-1-akrowiak@linux.ibm.com>
 <20220404221039.1272245-3-akrowiak@linux.ibm.com>
From:   "Jason J. Herne" <jjherne@linux.ibm.com>
Organization: IBM
In-Reply-To: <20220404221039.1272245-3-akrowiak@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: dKI-1TACc6OYDsR85RPuWf0zh6i8pcaG
X-Proofpoint-GUID: cy2iRTZEnlycvZvzp56j-nAQr3VVGQVi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-24_07,2022-05-23_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 phishscore=0 adultscore=0 priorityscore=1501 suspectscore=0 spamscore=0
 mlxscore=0 clxscore=1015 mlxlogscore=999 impostorscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205240074
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/4/22 18:10, Tony Krowiak wrote:
> Let's move the probe and remove callbacks into the vfio_ap_ops.c
> file to keep all code related to managing queues in a single file. This
> way, all functions related to queue management can be removed from the
> vfio_ap_private.h header file defining the public interfaces for the
> vfio_ap device driver.
> 
> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> Reviewed-by: Halil Pasic <pasic@linux.ibm.com>
> ---
>   drivers/s390/crypto/vfio_ap_drv.c     | 59 +--------------------------
>   drivers/s390/crypto/vfio_ap_ops.c     | 31 +++++++++++++-
>   drivers/s390/crypto/vfio_ap_private.h |  5 ++-
>   3 files changed, 34 insertions(+), 61 deletions(-)
> 
> diff --git a/drivers/s390/crypto/vfio_ap_drv.c b/drivers/s390/crypto/vfio_ap_drv.c
> index 29ebd54f8919..9a300dd3b6f7 100644
> --- a/drivers/s390/crypto/vfio_ap_drv.c
> +++ b/drivers/s390/crypto/vfio_ap_drv.c
> @@ -104,64 +104,9 @@ static const struct attribute_group vfio_queue_attr_group = {
>   	.attrs = vfio_queue_attrs,
>   };
>   
> -/**
> - * vfio_ap_queue_dev_probe: Allocate a vfio_ap_queue structure and associate it
> - *			    with the device as driver_data.
> - *
> - * @apdev: the AP device being probed
> - *
> - * Return: returns 0 if the probe succeeded; otherwise, returns an error if
> - *	   storage could not be allocated for a vfio_ap_queue object or the
> - *	   sysfs 'status' attribute could not be created for the queue device.
> - */
> -static int vfio_ap_queue_dev_probe(struct ap_device *apdev)
> -{
> -	int ret;
> -	struct vfio_ap_queue *q;
> -
> -	q = kzalloc(sizeof(*q), GFP_KERNEL);
> -	if (!q)
> -		return -ENOMEM;
> -
> -	mutex_lock(&matrix_dev->lock);
> -	dev_set_drvdata(&apdev->device, q);
> -	q->apqn = to_ap_queue(&apdev->device)->qid;
> -	q->saved_isc = VFIO_AP_ISC_INVALID;
> -
> -	ret = sysfs_create_group(&apdev->device.kobj, &vfio_queue_attr_group);
> -	if (ret) {
> -		dev_set_drvdata(&apdev->device, NULL);
> -		kfree(q);
> -	}
> -
> -	mutex_unlock(&matrix_dev->lock);
> -
> -	return ret;
> -}
> -
> -/**
> - * vfio_ap_queue_dev_remove: Free the associated vfio_ap_queue structure.
> - *
> - * @apdev: the AP device being removed
> - *
> - * Takes the matrix lock to avoid actions on this device while doing the remove.
> - */
> -static void vfio_ap_queue_dev_remove(struct ap_device *apdev)
> -{
> -	struct vfio_ap_queue *q;
> -
> -	mutex_lock(&matrix_dev->lock);
> -	sysfs_remove_group(&apdev->device.kobj, &vfio_queue_attr_group);
> -	q = dev_get_drvdata(&apdev->device);
> -	vfio_ap_mdev_reset_queue(q, 1);
> -	dev_set_drvdata(&apdev->device, NULL);
> -	kfree(q);
> -	mutex_unlock(&matrix_dev->lock);
> -}
> -
>   static struct ap_driver vfio_ap_drv = {
> -	.probe = vfio_ap_queue_dev_probe,
> -	.remove = vfio_ap_queue_dev_remove,
> +	.probe = vfio_ap_mdev_probe_queue,
> +	.remove = vfio_ap_mdev_remove_queue,
>   	.ids = ap_queue_ids,
>   };
>   
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> index 2227919fde13..16220157dbe3 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -1314,8 +1314,7 @@ static struct vfio_ap_queue *vfio_ap_find_queue(int apqn)
>   	return q;
>   }
>   
> -int vfio_ap_mdev_reset_queue(struct vfio_ap_queue *q,
> -			     unsigned int retry)
> +static int vfio_ap_mdev_reset_queue(struct vfio_ap_queue *q, unsigned int retry)
>   {
>   	struct ap_queue_status status;
>   	int ret;
> @@ -1524,3 +1523,31 @@ void vfio_ap_mdev_unregister(void)
>   	mdev_unregister_device(&matrix_dev->device);
>   	mdev_unregister_driver(&vfio_ap_matrix_driver);
>   }
> +
> +int vfio_ap_mdev_probe_queue(struct ap_device *apdev)
> +{
> +	struct vfio_ap_queue *q;
> +
> +	q = kzalloc(sizeof(*q), GFP_KERNEL);
> +	if (!q)
> +		return -ENOMEM;
> +	mutex_lock(&matrix_dev->lock);
> +	q->apqn = to_ap_queue(&apdev->device)->qid;
> +	q->saved_isc = VFIO_AP_ISC_INVALID;
> +	dev_set_drvdata(&apdev->device, q);
> +	mutex_unlock(&matrix_dev->lock);
> +
> +	return 0;
> +}
> +
> +void vfio_ap_mdev_remove_queue(struct ap_device *apdev)
> +{
> +	struct vfio_ap_queue *q;
> +
> +	mutex_lock(&matrix_dev->lock);
> +	q = dev_get_drvdata(&apdev->device);
> +	vfio_ap_mdev_reset_queue(q, 1);
> +	dev_set_drvdata(&apdev->device, NULL);
> +	kfree(q);
> +	mutex_unlock(&matrix_dev->lock);
> +}
> diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
> index 648fcaf8104a..3cade25a1620 100644
> --- a/drivers/s390/crypto/vfio_ap_private.h
> +++ b/drivers/s390/crypto/vfio_ap_private.h
> @@ -119,7 +119,8 @@ struct vfio_ap_queue {
>   
>   int vfio_ap_mdev_register(void);
>   void vfio_ap_mdev_unregister(void);
> -int vfio_ap_mdev_reset_queue(struct vfio_ap_queue *q,
> -			     unsigned int retry);
> +
> +int vfio_ap_mdev_probe_queue(struct ap_device *queue);
> +void vfio_ap_mdev_remove_queue(struct ap_device *queue);
>   
>   #endif /* _VFIO_AP_PRIVATE_H_ */


With this commit, you did more than just move the probe/remove functions. You also changed 
their behavior. The call to sysfs_create_group has been removed. So the following in 
vfop_ap_drv.c becomes dead code:

     vfio_ap_mdev_for_queue
     status_show
     static DEVICE_ATTR_RO(status);
     vfio_queue_attrs
     vfio_queue_attr_group

Is this what you intended? If so, I assume we can live without the status attribute?
If this is the case then you'll want to remove all the dead code.

-- 
-- Jason J. Herne (jjherne@linux.ibm.com)
