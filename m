Return-Path: <kvm+bounces-42278-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C53A3A770D6
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 00:22:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 729E5168347
	for <lists+kvm@lfdr.de>; Mon, 31 Mar 2025 22:22:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F092121CA04;
	Mon, 31 Mar 2025 22:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="JiGwb7fF"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AC8221C19A;
	Mon, 31 Mar 2025 22:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743459769; cv=none; b=Xm72Xi8xqthg67x2BDYDnJUXUy3Cz2jBKrIXkxkFy9xusR0jWqoAfv89639FKtK1Tbe/Zu7xxnsarJ0aMT3Tzifv3ksAN/bb+AZ7BkqZ//+sP9Vg6nsl+OpZNxfdzjg3JRjcn7bIc2chlajYCnjOlSYV/rgGVZvAJINArkVEyMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743459769; c=relaxed/simple;
	bh=Jtp6wQ6r4GPlx2rZ16W9Ir0MyjHkgbNWjAamv8b1jk0=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=SkK3Snr64Bf/mLXMPqU2DCo4/IJ7hU23IkZnLR+72uMj7IeeQk1w8wysdcCheuOfPiIutfpo/T6sQZzWoEgcZ0fQGJf9yBngaUJ62hAdXeIP9Bmhr2/REl2SfjlHbWQ97NrVgJyOB5UIU8qqMOcJsjURMvo6f019cm95HnB84F8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=JiGwb7fF; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52VE39wJ006354;
	Mon, 31 Mar 2025 22:22:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=JzihdS
	bg/SgWNVVNKINk8CKQR/API8qYfxFTRXc4ce8=; b=JiGwb7fF6vFYvL3dksJExI
	D0NfQ3EfZScWm1jLaGzqFccl0DyEdTUlqN1VgmYS/C9VdxC0AYGSdvyg7h7Y0oZ+
	sSCQQVocJpiB/Vm6HXgWdEJvSzLUsO/f0Q3S4Sjx41b79TOdAWap/nitwM19cAt2
	Q+HRNqtOQAb7XFJVv6kAF+UcIBcSGmvegliv8TcDubO8Uuhpngut56SbNmntXk1n
	q4+rjcgWnMbtxVNWEC+TN7b+gA+QFtZfXheTc9wB0FPt3NWUGAfFjaWFgAVPhQqx
	jbHAD9xVKHajKWp2bh1U005/ifB9B4CvL6XTY4axD9eeLkaSDFyY/6YNjqj73AvA
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 45qvfpt72k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 31 Mar 2025 22:22:46 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 52VLfC7n019391;
	Mon, 31 Mar 2025 22:22:45 GMT
Received: from smtprelay03.wdc07v.mail.ibm.com ([172.16.1.70])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 45pu6t01mm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 31 Mar 2025 22:22:45 +0000
Received: from smtpav03.wdc07v.mail.ibm.com (smtpav03.wdc07v.mail.ibm.com [10.39.53.230])
	by smtprelay03.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 52VMMg90393964
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 31 Mar 2025 22:22:42 GMT
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E0A5958062;
	Mon, 31 Mar 2025 22:22:43 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 42C545805D;
	Mon, 31 Mar 2025 22:22:43 +0000 (GMT)
Received: from [9.61.7.200] (unknown [9.61.7.200])
	by smtpav03.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 31 Mar 2025 22:22:43 +0000 (GMT)
Message-ID: <156b71cf-b94f-4fa0-a149-62bb8c2a797b@linux.ibm.com>
Date: Mon, 31 Mar 2025 18:22:42 -0400
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] s390/vio-ap: Fix no AP queue sharing allowed message
 written to kernel log
From: Anthony Krowiak <akrowiak@linux.ibm.com>
To: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc: gor@linux.ibm.com, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
References: <20250311103304.1539188-1-akrowiak@linux.ibm.com>
Content-Language: en-US
In-Reply-To: <20250311103304.1539188-1-akrowiak@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: bHV9AG7GPmlV1d9mO8vEyHcUNoXYjesL
X-Proofpoint-GUID: bHV9AG7GPmlV1d9mO8vEyHcUNoXYjesL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-31_10,2025-03-27_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 suspectscore=0
 priorityscore=1501 clxscore=1015 adultscore=0 bulkscore=0
 lowpriorityscore=0 spamscore=0 mlxlogscore=999 mlxscore=0 impostorscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2502280000 definitions=main-2503310151


Gentlemen,

I got some review comments from Heiko for v1 and implemented his 
suggested changes. I have not heard from anyone else, but I think if 
Heiko agrees that the changes are sufficient, I think this can go 
upstream via the s390 tree. What say you?

Kind regards,
Tony Krowiak

On 3/11/25 6:32 AM, Anthony Krowiak wrote:
> An erroneous message is written to the kernel log when either of the
> following actions are taken by a user:
>
> 1. Assign an adapter or domain to a vfio_ap mediated device via its sysfs
>     assign_adapter or assign_domain attributes that would result in one or
>     more AP queues being assigned that are already assigned to a different
>     mediated device. Sharing of queues between mdevs is not allowed.
>
> 2. Reserve an adapter or domain for the host device driver via the AP bus
>     driver's sysfs apmask or aqmask attribute that would result in providing
>     host access to an AP queue that is in use by a vfio_ap mediated device.
>     Reserving a queue for a host driver that is in use by an mdev is not
>     allowed.
>
> In both cases, the assignment will return an error; however, a message like
> the following is written to the kernel log:
>
> vfio_ap_mdev e1839397-51a0-4e3c-91e0-c3b9c3d3047d: Userspace may not
> re-assign queue 00.0028 already assigned to \
> e1839397-51a0-4e3c-91e0-c3b9c3d3047d
>
> Notice the mdev reporting the error is the same as the mdev identified
> in the message as the one to which the queue is being assigned.
> It is perfectly okay to assign a queue to an mdev to which it is
> already assigned; the assignment is simply ignored by the vfio_ap device
> driver.
>
> This patch logs more descriptive and accurate messages for both 1 and 2
> above to the kernel log:
>
> Example for 1:
> vfio_ap_mdev 0fe903a0-a323-44db-9daf-134c68627d61: Userspace may not assign
> queue 00.0033 to mdev: already assigned to \
> 62177883-f1bb-47f0-914d-32a22e3a8804
>
> Example for 2:
> vfio_ap_mdev 62177883-f1bb-47f0-914d-32a22e3a8804: Can not reserve queue
> 00.0033 for host driver: in use by mdev
>
> Signed-off-by: Anthony Krowiak <akrowiak@linux.ibm.com>
> ---
>   drivers/s390/crypto/vfio_ap_ops.c | 82 +++++++++++++++++++++----------
>   1 file changed, 55 insertions(+), 27 deletions(-)
>
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> index bc8669b5c304..7c34fdaa2a27 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -873,48 +873,68 @@ static void vfio_ap_mdev_remove(struct mdev_device *mdev)
>   	vfio_put_device(&matrix_mdev->vdev);
>   }
>   
> -#define MDEV_SHARING_ERR "Userspace may not re-assign queue %02lx.%04lx " \
> -			 "already assigned to %s"
> +#define MDEV_SHARING_ERR "Userspace may not assign queue %02lx.%04lx to mdev: already assigned to %s"
>   
> -static void vfio_ap_mdev_log_sharing_err(struct ap_matrix_mdev *matrix_mdev,
> -					 unsigned long *apm,
> -					 unsigned long *aqm)
> +#define MDEV_IN_USE_ERR "Can not reserve queue %02lx.%04lx for host driver: in use by mdev"
> +
> +static void vfio_ap_mdev_log_sharing_err(struct ap_matrix_mdev *assignee,
> +					 struct ap_matrix_mdev *assigned_to,
> +					 unsigned long *apm, unsigned long *aqm)
> +{
> +	unsigned long apid, apqi;
> +
> +	for_each_set_bit_inv(apid, apm, AP_DEVICES) {
> +		for_each_set_bit_inv(apqi, aqm, AP_DOMAINS) {
> +			dev_warn(mdev_dev(assignee->mdev), MDEV_SHARING_ERR,
> +				 apid, apqi, dev_name(mdev_dev(assigned_to->mdev)));
> +		}
> +	}
> +}
> +
> +static void vfio_ap_mdev_log_in_use_err(struct ap_matrix_mdev *assignee,
> +					unsigned long *apm, unsigned long *aqm)
>   {
>   	unsigned long apid, apqi;
> -	const struct device *dev = mdev_dev(matrix_mdev->mdev);
> -	const char *mdev_name = dev_name(dev);
>   
> -	for_each_set_bit_inv(apid, apm, AP_DEVICES)
> -		for_each_set_bit_inv(apqi, aqm, AP_DOMAINS)
> -			dev_warn(dev, MDEV_SHARING_ERR, apid, apqi, mdev_name);
> +	for_each_set_bit_inv(apid, apm, AP_DEVICES) {
> +		for_each_set_bit_inv(apqi, aqm, AP_DOMAINS) {
> +			dev_warn(mdev_dev(assignee->mdev), MDEV_IN_USE_ERR,
> +				 apid, apqi);
> +		}
> +	}
>   }
>   
>   /**
>    * vfio_ap_mdev_verify_no_sharing - verify APQNs are not shared by matrix mdevs
>    *
> + * @assignee: the matrix mdev to which @mdev_apm and @mdev_aqm are being
> + *            assigned; or, NULL if this function was called by the AP bus
> + *            driver in_use callback to verify none of the APQNs being reserved
> + *            for the host device driver are in use by a vfio_ap mediated device
>    * @mdev_apm: mask indicating the APIDs of the APQNs to be verified
>    * @mdev_aqm: mask indicating the APQIs of the APQNs to be verified
>    *
> - * Verifies that each APQN derived from the Cartesian product of a bitmap of
> - * AP adapter IDs and AP queue indexes is not configured for any matrix
> - * mediated device. AP queue sharing is not allowed.
> + * Verifies that each APQN derived from the Cartesian product of APIDs
> + * represented by the bits set in @mdev_apm and the APQIs of the bits set in
> + * @mdev_aqm is not assigned to a mediated device other than the mdev to which
> + * the APQN is being assigned (@assignee). AP queue sharing is not allowed.
>    *
>    * Return: 0 if the APQNs are not shared; otherwise return -EADDRINUSE.
>    */
> -static int vfio_ap_mdev_verify_no_sharing(unsigned long *mdev_apm,
> +static int vfio_ap_mdev_verify_no_sharing(struct ap_matrix_mdev *assignee,
> +					  unsigned long *mdev_apm,
>   					  unsigned long *mdev_aqm)
>   {
> -	struct ap_matrix_mdev *matrix_mdev;
> +	struct ap_matrix_mdev *assigned_to;
>   	DECLARE_BITMAP(apm, AP_DEVICES);
>   	DECLARE_BITMAP(aqm, AP_DOMAINS);
>   
> -	list_for_each_entry(matrix_mdev, &matrix_dev->mdev_list, node) {
> +	list_for_each_entry(assigned_to, &matrix_dev->mdev_list, node) {
>   		/*
> -		 * If the input apm and aqm are fields of the matrix_mdev
> -		 * object, then move on to the next matrix_mdev.
> +		 * If the mdev to which the mdev_apm and mdev_aqm is being
> +		 * assigned is the same as the mdev being verified
>   		 */
> -		if (mdev_apm == matrix_mdev->matrix.apm &&
> -		    mdev_aqm == matrix_mdev->matrix.aqm)
> +		if (assignee == assigned_to)
>   			continue;
>   
>   		memset(apm, 0, sizeof(apm));
> @@ -924,15 +944,22 @@ static int vfio_ap_mdev_verify_no_sharing(unsigned long *mdev_apm,
>   		 * We work on full longs, as we can only exclude the leftover
>   		 * bits in non-inverse order. The leftover is all zeros.
>   		 */
> -		if (!bitmap_and(apm, mdev_apm, matrix_mdev->matrix.apm,
> -				AP_DEVICES))
> +		if (!bitmap_and(apm, mdev_apm, assigned_to->matrix.apm,
> +				AP_DEVICES)) {
>   			continue;
> +		}
>   
> -		if (!bitmap_and(aqm, mdev_aqm, matrix_mdev->matrix.aqm,
> -				AP_DOMAINS))
> +		if (!bitmap_and(aqm, mdev_aqm, assigned_to->matrix.aqm,
> +				AP_DOMAINS)) {
>   			continue;
> +		}
>   
> -		vfio_ap_mdev_log_sharing_err(matrix_mdev, apm, aqm);
> +		if (assignee) {
> +			vfio_ap_mdev_log_sharing_err(assignee, assigned_to,
> +						     apm, aqm);
> +		} else {
> +			vfio_ap_mdev_log_in_use_err(assigned_to, apm, aqm);
> +		}
>   
>   		return -EADDRINUSE;
>   	}
> @@ -961,7 +988,8 @@ static int vfio_ap_mdev_validate_masks(struct ap_matrix_mdev *matrix_mdev)
>   					       matrix_mdev->matrix.aqm))
>   		return -EADDRNOTAVAIL;
>   
> -	return vfio_ap_mdev_verify_no_sharing(matrix_mdev->matrix.apm,
> +	return vfio_ap_mdev_verify_no_sharing(matrix_mdev,
> +					      matrix_mdev->matrix.apm,
>   					      matrix_mdev->matrix.aqm);
>   }
>   
> @@ -2516,7 +2544,7 @@ int vfio_ap_mdev_resource_in_use(unsigned long *apm, unsigned long *aqm)
>   
>   	mutex_lock(&matrix_dev->guests_lock);
>   	mutex_lock(&matrix_dev->mdevs_lock);
> -	ret = vfio_ap_mdev_verify_no_sharing(apm, aqm);
> +	ret = vfio_ap_mdev_verify_no_sharing(NULL, apm, aqm);
>   	mutex_unlock(&matrix_dev->mdevs_lock);
>   	mutex_unlock(&matrix_dev->guests_lock);
>   


