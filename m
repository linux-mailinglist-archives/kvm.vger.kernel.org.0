Return-Path: <kvm+bounces-40030-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 56F3DA4DF68
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 14:36:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E3A5E188A5A5
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 13:36:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C86C9204689;
	Tue,  4 Mar 2025 13:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="SX3bOaM8"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4516C2AF16;
	Tue,  4 Mar 2025 13:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741095400; cv=none; b=O8kTExSlQJxD/fEWhxac4jkH4X3ATvUJYhu0gbfitZmZV40XTS9Qc8pwfo1tTos9d04wkCmlId1Fb5/5x1X44bKh0hmGzY7JFvzc65pxZo2rczzOPqrI6tfaPsxLNTK2Xe6TiyXwFpqDTgUaVyqMKEmb92qOP/mWhgmEq+4EgYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741095400; c=relaxed/simple;
	bh=yF25LpGdJi7PFv7kUBafbWN5+6gSA01nKdsra3U1hbE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=e7XaONeDlqkAB8adTKCN5z/3iqSPs0abToVdN/3OLAel2Obi+Lyacu9UFcR24s8fxxp0314uBGSEOOqStdxL1HsEv60oJnWen6LZ9XlS8FE2/gtrd43mw1G3mX3FAySVZ7kE5B7UdlXIRvgryZmdWPsbWvS/100LejtdiK+2lz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=SX3bOaM8; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5249ckMK026620;
	Tue, 4 Mar 2025 13:36:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=CDiax/
	LIP8CJb3abRRbcSlRurLsVLCyEDkOlbIbb9NE=; b=SX3bOaM8vT8vlvQ6zfuIPO
	OCDFDni6b74lFSpzOfJ/SXvSNsmMLHHMtgLq/YoIyey2UqbHU6A8Ll/K3NTeWsIb
	4EudSY+SU98r+E0kbwlrWiZz5IN2MwbOoOkdeFlOcBAxwb9IkvafDWPiQkWovE8E
	VYA3+e8qcBHDfJg1X+O4LU1vvVxspK0sRaop0PxiZgb1iV37sjNLcf2xxBFp7WVZ
	XSxz+l28yyDzEYnM+kcSTZ2ZXh3Ou096IGBycOiqixXugznZ8F2EV0cPFAJv6jSM
	42YNMwLPWLQ07ixfQfo9P+/TNoQSnaVDWSb82PyNMm4wDyDednZJ3TTibBp0UxoA
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 455kkpc3d7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 04 Mar 2025 13:36:35 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 524DLwnI020877;
	Tue, 4 Mar 2025 13:36:35 GMT
Received: from smtprelay06.wdc07v.mail.ibm.com ([172.16.1.73])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 454esjw8r2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 04 Mar 2025 13:36:35 +0000
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay06.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 524DaX3l15925970
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 4 Mar 2025 13:36:33 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5B8F958052;
	Tue,  4 Mar 2025 13:36:33 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8B6A65805A;
	Tue,  4 Mar 2025 13:36:32 +0000 (GMT)
Received: from [9.61.107.75] (unknown [9.61.107.75])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  4 Mar 2025 13:36:32 +0000 (GMT)
Message-ID: <4bf76371-43ea-4c1a-8a7f-500b0b0195b6@linux.ibm.com>
Date: Tue, 4 Mar 2025 08:36:32 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v1] fixup! s390/vfio-ap: Notify userspace that guest's
 AP config changed when mdev removed
To: Rorie Reyes <rreyes@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: hca@linux.ibm.com, borntraeger@de.ibm.com, agordeev@linux.ibm.com,
        gor@linux.ibm.com, pasic@linux.ibm.com, jjherne@linux.ibm.com,
        alex.williamson@redhat.com
References: <20250303191158.49317-1-rreyes@linux.ibm.com>
Content-Language: en-US
From: Anthony Krowiak <akrowiak@linux.ibm.com>
In-Reply-To: <20250303191158.49317-1-rreyes@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: dswjtEnHH1k6NuG2lPlPBU_nuMfzNUIJ
X-Proofpoint-ORIG-GUID: dswjtEnHH1k6NuG2lPlPBU_nuMfzNUIJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-04_05,2025-03-03_04,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 clxscore=1015
 malwarescore=0 adultscore=0 impostorscore=0 bulkscore=0 mlxlogscore=999
 phishscore=0 spamscore=0 priorityscore=1501 mlxscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2502100000
 definitions=main-2503040110




On 3/3/25 2:11 PM, Rorie Reyes wrote:
> This patch is based on the s390/features branch
>
> The guest's AP configuration is cleared when the mdev is removed, so
> userspace must be notified that the AP configuration has changed. To this
> end, this patch:
>
> * Removes call to 'signal_guest_ap_cfg_changed()' function from the
>    'vfio_ap_mdev_unset_kvm()' function because it has no affect given it is
>    called after the mdev fd is closed.
>
> * Adds call to 'signal_guest_ap_cfg_changed()' function to the
>    'vfio_ap_mdev_request()' function to notify userspace that the guest's
>    AP configuration has changed before signaling the request to remove the
>    mdev.
>
> Minor change - Fixed an indentation issue in function
> 'signal_guest_ap_cfg_changed()'
>
> Fixes: 2ba4410dd477 ("s390/vfio-ap: Signal eventfd when guest AP configuration is changed")
> Signed-off-by: Rorie Reyes <rreyes@linux.ibm.com>
> ---
>   drivers/s390/crypto/vfio_ap_ops.c | 19 ++++++++++++++++---
>   1 file changed, 16 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> index 571f5dcb49c5..c1afac5ac555 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -652,8 +652,8 @@ static void vfio_ap_matrix_init(struct ap_config_info *info,
>   
>   static void signal_guest_ap_cfg_changed(struct ap_matrix_mdev *matrix_mdev)
>   {
> -		if (matrix_mdev->cfg_chg_trigger)
> -			eventfd_signal(matrix_mdev->cfg_chg_trigger);
> +	if (matrix_mdev->cfg_chg_trigger)
> +		eventfd_signal(matrix_mdev->cfg_chg_trigger);
>   }
>   
>   static void vfio_ap_mdev_update_guest_apcb(struct ap_matrix_mdev *matrix_mdev)
> @@ -1870,7 +1870,6 @@ static void vfio_ap_mdev_unset_kvm(struct ap_matrix_mdev *matrix_mdev)
>   		get_update_locks_for_kvm(kvm);
>   
>   		kvm_arch_crypto_clear_masks(kvm);
> -		signal_guest_ap_cfg_changed(matrix_mdev);
>   		vfio_ap_mdev_reset_queues(matrix_mdev);
>   		kvm_put_kvm(kvm);
>   		matrix_mdev->kvm = NULL;
> @@ -2057,6 +2056,14 @@ static void vfio_ap_mdev_request(struct vfio_device *vdev, unsigned int count)
>   
>   	matrix_mdev = container_of(vdev, struct ap_matrix_mdev, vdev);
>   
> +	if (matrix_mdev->kvm) {
> +		get_update_locks_for_kvm(matrix_mdev->kvm);

I know we talked about this prior to submission of this patch, but 
looking at this again I think
you should use the get_update_locks_for_mdev() function for two reasons:

1. It is safer because it will take the matrix_dev->guests_lock which 
will prevent the matrix_mdev->kvm
     field from changing before you check it

2. I will eliminate the need for the else

get_update_locks_for_mdev(matrix_mdev)
if (matrix_mdev->kvm) {
     clear the masks
     signal guest config changed
}
...
release_update_locks_for_mdev(matrix_mdev); Sorry about not seeing this 
before you posted this patch.
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


