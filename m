Return-Path: <kvm+bounces-39288-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E4ADAA4621B
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 15:16:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E8C2D3B021C
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 14:16:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E39C622171D;
	Wed, 26 Feb 2025 14:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="EVH3VIsz"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F01D219E8D;
	Wed, 26 Feb 2025 14:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740579410; cv=none; b=LlMT49m95rlaPQfCoFVc3HqLSC17Sx7idlW23HpzE7sA7XJZy2fG/YhsSJNwB/PNQ3ItFSjj1dxCz2Z2CcSwZm+DC/bLdYm+tC9QnhMdovDkYCPa07dd16tN7gnN65c2okyiLPB8GPkY+PSYyWHfwOEJgCashEfunmuTOSCvFA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740579410; c=relaxed/simple;
	bh=be0DhVHXvIrbwG6S18TC34vLnBjIVVQE+vn71Evrd4o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=e/7vgeerqMj4Y8Byaenl30l6YtAZNnC1GkTohHBVQ6ZJU95QnqvX6Hjm23ZSMtDkNcFHo1zizgwWmApvwVZvg5q7fHBbeEx48FxXoxJ932NHOHRJ2i49rzEjAwgR2q8ORZ5ckJmopYdkn/ORjstm0t/wRsiSRVxvmMXSXszPtgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=EVH3VIsz; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51QBa54k013048;
	Wed, 26 Feb 2025 14:16:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=WQbQEI
	sUUMA0rfA6FA7CYmCh7tbVL9N0aY72lMm5jZU=; b=EVH3VIszWpMrqgBUg5xaZH
	Me4RBU2MnV6mZiwgr8vsszAGjPGjOrqtu2asnGtNKf4OaQ0Z202wuoJcb3KnZWEg
	Ce5DgxH+ECWwt7jNFvMZtKuaVjZNh+Qo30MIVd5fx7QwjavI03fVs2y+MSqXazlY
	FSCCIT8wIEQhWv8AhgZjL0Ijm5PoDqDBp7ONCJNC1QB0bFaSj1lioQL3+Nkvqwsq
	e3H92Bo0IeOHQbH+pcwGGC6NrHvIxOLZ1akkwFqKUaxh8d9Mc7nbsdAbOfwfqQhu
	qs+1cs23CiLkdV7ZeFRJyUY6dRoE0zogrfkaraGs4XZsTHGu6+nOGliGn2Ypk14w
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 451s19b57a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 26 Feb 2025 14:16:44 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 51QCs8LD026964;
	Wed, 26 Feb 2025 14:16:43 GMT
Received: from smtprelay05.dal12v.mail.ibm.com ([172.16.1.7])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 44ytdkjwr3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 26 Feb 2025 14:16:43 +0000
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
	by smtprelay05.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 51QEGgTi65274326
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 Feb 2025 14:16:42 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 70CE65804E;
	Wed, 26 Feb 2025 14:16:42 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 47D645803F;
	Wed, 26 Feb 2025 14:16:41 +0000 (GMT)
Received: from [9.61.107.75] (unknown [9.61.107.75])
	by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 26 Feb 2025 14:16:41 +0000 (GMT)
Message-ID: <86e40763-f76a-4f71-bb50-d1b1a4c77509@linux.ibm.com>
Date: Wed, 26 Feb 2025 09:16:40 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 2/2] s390/vfio-ap: Fixing mdev remove notification
To: Rorie Reyes <rreyes@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: hca@linux.ibm.com, borntraeger@de.ibm.com, agordeev@linux.ibm.com,
        gor@linux.ibm.com, pasic@linux.ibm.com, jjherne@linux.ibm.com,
        alex.williamson@redhat.com
References: <20250225201208.45998-1-rreyes@linux.ibm.com>
 <20250225201208.45998-3-rreyes@linux.ibm.com>
Content-Language: en-US
From: Anthony Krowiak <akrowiak@linux.ibm.com>
In-Reply-To: <20250225201208.45998-3-rreyes@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: hTygt1-RlUXqBhFcRAgTHoN_vB5gyXfK
X-Proofpoint-ORIG-GUID: hTygt1-RlUXqBhFcRAgTHoN_vB5gyXfK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-26_03,2025-02-26_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 suspectscore=0
 phishscore=0 adultscore=0 impostorscore=0 lowpriorityscore=0
 mlxlogscore=999 mlxscore=0 spamscore=0 clxscore=1015 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2502100000 definitions=main-2502260112




On 2/25/25 3:12 PM, Rorie Reyes wrote:
> Removed eventfd from vfio_ap_mdev_unset_kvm
> Update and release locks along with the eventfd added
> to vfio_ap_mdev_request

This patch doesn't really fix anything, it just undoes a line of code 
that was added in
patch 1/2 (see my comment below).

By my reckoning, the purpose for this patch
is to signal an AP config change event to the guest when the crypto 
devices are
removed from the guest's AP configuration as a result of a request to 
remove the
mediated device.


>
> Signed-off-by: Rorie Reyes <rreyes@linux.ibm.com>
> ---
>   drivers/s390/crypto/vfio_ap_ops.c | 15 ++++++++++++++-
>   1 file changed, 14 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> index c6ff4ab13f16..e0237ea27d7e 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -1870,7 +1870,6 @@ static void vfio_ap_mdev_unset_kvm(struct ap_matrix_mdev *matrix_mdev)
>   		get_update_locks_for_kvm(kvm);
>   
>   		kvm_arch_crypto_clear_masks(kvm);
> -		signal_guest_ap_cfg_changed(matrix_mdev);

Why remove a line of code that was added in patch 1/2. Why not just 
rebase patch 1/2 and
remove this line of code from that patch rather than here if it was 
added in error?

>   		vfio_ap_mdev_reset_queues(matrix_mdev);
>   		kvm_put_kvm(kvm);
>   		matrix_mdev->kvm = NULL;
> @@ -2057,6 +2056,14 @@ static void vfio_ap_mdev_request(struct vfio_device *vdev, unsigned int count)
>   
>   	matrix_mdev = container_of(vdev, struct ap_matrix_mdev, vdev);
>   
> +	if (matrix_mdev->kvm) {
> +		get_update_locks_for_kvm(matrix_mdev->kvm);
> +		kvm_arch_crypto_clear_masks(matrix_mdev->kvm);
> +		signal_guest_ap_cfg_changed(matrix_mdev);
> +	} else {
> +		mutex_lock(&matrix_dev->mdevs_lock);
> +	}
> +
>   	if (matrix_mdev->req_trigger) {
>   		if (!(count % 10))
>   			dev_notice_ratelimited(dev,
> @@ -2068,6 +2075,12 @@ static void vfio_ap_mdev_request(struct vfio_device *vdev, unsigned int count)
>   		dev_notice(dev,
>   			   "No device request registered, blocked until released by user\n");
>   	}
> +
> +	if (matrix_mdev->kvm)
> +		release_update_locks_for_kvm(matrix_mdev->kvm);
> +	else
> +		mutex_unlock(&matrix_dev->mdevs_lock);
> +
>   }
>   
>   static int vfio_ap_mdev_get_device_info(unsigned long arg)


