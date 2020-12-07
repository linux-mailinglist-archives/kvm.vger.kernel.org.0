Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB3512D1920
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 20:09:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726852AbgLGTGn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 14:06:43 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:63938 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726459AbgLGTGn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 7 Dec 2020 14:06:43 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B7J1KgK142231;
        Mon, 7 Dec 2020 14:06:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=rz/hQifI7yG+1lfVplc1tW6OqA321PiRrPM49SK9VH8=;
 b=q0meRKXudrG6MMuphS2OjM5RYZX7QuSHCnWlQdY7bVUuY/PirZdp6r/UvVYiJ2NRWXe+
 QXmf6bgaLr4B/XRFtOXCAS+eCJqCUq0yrBusBOH226Oy28/6QTviPZeQybuupLnA5iZ4
 mmN+r7cN+7ACWvSD/v4ZW/glA5RGhWQV4/mY9yc0hFIWvtI58fjD1BqHixpGQ82VYMFI
 ErX8sxmyA3AE+e16WNfVoTb5OUb7AR0S5Js518nf7+gVWgn7ADxvK+YC1Sdw9UAVl0Jr
 FFhidHU3BWtXnsIEQMRN6M0AcHdHcjEQbeTdwnR/f5TYLObKykWoWphy9kQKvqoo8002 Tg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 359q2u6fqa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Dec 2020 14:05:59 -0500
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0B7J2vuT148497;
        Mon, 7 Dec 2020 14:05:59 -0500
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0b-001b2d01.pphosted.com with ESMTP id 359q2u6fpr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Dec 2020 14:05:59 -0500
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0B7J1uXg020330;
        Mon, 7 Dec 2020 19:05:58 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma02dal.us.ibm.com with ESMTP id 3581u9ej04-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Dec 2020 19:05:58 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0B7J5vcw20644280
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 7 Dec 2020 19:05:57 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0D7217805F;
        Mon,  7 Dec 2020 19:05:57 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0E16F78060;
        Mon,  7 Dec 2020 19:05:55 +0000 (GMT)
Received: from cpe-66-24-58-13.stny.res.rr.com (unknown [9.85.162.205])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon,  7 Dec 2020 19:05:55 +0000 (GMT)
Subject: Re: [PATCH] s390/vfio-ap: Clean up vfio_ap resources when KVM pointer
 invalidated
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, cohuck@redhat.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com, david@redhat.com
References: <20201202234101.32169-1-akrowiak@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <ab3f1948-bb23-c0d0-7205-f46cd6dbe99d@linux.ibm.com>
Date:   Mon, 7 Dec 2020 14:05:55 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20201202234101.32169-1-akrowiak@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-07_16:2020-12-04,2020-12-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 bulkscore=0
 mlxlogscore=999 suspectscore=3 mlxscore=0 adultscore=0 clxscore=1015
 spamscore=0 malwarescore=0 phishscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012070119
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 12/2/20 6:41 PM, Tony Krowiak wrote:
> The vfio_ap device driver registers a group notifier with VFIO when the
> file descriptor for a VFIO mediated device for a KVM guest is opened to
> receive notification that the KVM pointer is set (VFIO_GROUP_NOTIFY_SET_KVM
> event). When the KVM pointer is set, the vfio_ap driver stashes the pointer
> and calls the kvm_get_kvm() function to increment its reference counter.
> When the notifier is called to make notification that the KVM pointer has
> been set to NULL, the driver should clean up any resources associated with
> the KVM pointer and decrement its reference counter. The current
> implementation does not take care of this clean up.
>
> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> ---
>   drivers/s390/crypto/vfio_ap_ops.c | 21 +++++++++++++--------
>   1 file changed, 13 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> index e0bde8518745..eeb9c9130756 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -1083,6 +1083,17 @@ static int vfio_ap_mdev_iommu_notifier(struct notifier_block *nb,
>   	return NOTIFY_DONE;
>   }
>   
> +static void vfio_ap_mdev_put_kvm(struct ap_matrix_mdev *matrix_mdev)
> +{
> +	if (matrix_mdev->kvm) {
> +		kvm_arch_crypto_clear_masks(matrix_mdev->kvm);
> +		matrix_mdev->kvm->arch.crypto.pqap_hook = NULL;
> +		vfio_ap_mdev_reset_queues(matrix_mdev->mdev);

This reset probably does not belong here since there is no
reason to reset the queues in the group notifier (see below).
The reset should be done in the release callback only regardless
of whether the KVM pointer exists or not.

> +		kvm_put_kvm(matrix_mdev->kvm);
> +		matrix_mdev->kvm = NULL;
> +	}
> +}
> +
>   static int vfio_ap_mdev_group_notifier(struct notifier_block *nb,
>   				       unsigned long action, void *data)
>   {
> @@ -1095,7 +1106,7 @@ static int vfio_ap_mdev_group_notifier(struct notifier_block *nb,
>   	matrix_mdev = container_of(nb, struct ap_matrix_mdev, group_notifier);
>   
>   	if (!data) {
> -		matrix_mdev->kvm = NULL;
> +		vfio_ap_mdev_put_kvm(matrix_mdev);
>   		return NOTIFY_OK;
>   	}
>   
> @@ -1222,13 +1233,7 @@ static void vfio_ap_mdev_release(struct mdev_device *mdev)
>   	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
>   
>   	mutex_lock(&matrix_dev->lock);
> -	if (matrix_mdev->kvm) {
> -		kvm_arch_crypto_clear_masks(matrix_mdev->kvm);
> -		matrix_mdev->kvm->arch.crypto.pqap_hook = NULL;
> -		vfio_ap_mdev_reset_queues(mdev);

This release should be moved outside of the block and
performed regardless of whether the KVM pointer exists or
not.

> -		kvm_put_kvm(matrix_mdev->kvm);
> -		matrix_mdev->kvm = NULL;
> -	}
> +	vfio_ap_mdev_put_kvm(matrix_mdev);
>   	mutex_unlock(&matrix_dev->lock);
>   
>   	vfio_unregister_notifier(mdev_dev(mdev), VFIO_IOMMU_NOTIFY,

