Return-Path: <kvm+bounces-40076-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BED61A4EE1B
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 21:11:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DD105174D0D
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 20:11:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E628025FA09;
	Tue,  4 Mar 2025 20:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="M3L3796v"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D8162475C3;
	Tue,  4 Mar 2025 20:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741119080; cv=none; b=YCUAGaXRAw5RslCdA2kCgD8PzMxQzMvbN3a98tmvFVUWRZupI4HQTPLnDpN1zelMULq6HePnvU7zt1mTr6xlc/qe7pEekfX6p+FC8IpcFqcx7It6ML36vDBKIXSrJz+p1ZAHt+NxLrL2spdpoXWPhvalfjAGqq3XsISHRh0Sl8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741119080; c=relaxed/simple;
	bh=cfMzhB7XC+JezusyQjnaqFcQyOtbEDdC23yjtB+Tv4A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Hc3IPJVi2gkEtpka4LMp4a8QfQFn+gBgsnDEf+Ivrxs60paSEZv1BHdyjUwoMR7oZFu/BvM2l/yF/zteROCx4vdldYD+r9TFMzmOmqUvy/RmIPOOuluDP9PolN+bEHt85wYXS61vfSy1bwAGMeGAbmZS/0O9yDsr8JV3jli6xIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=M3L3796v; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 524CS7nq006582;
	Tue, 4 Mar 2025 20:11:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=LfZdko
	V5EnRMLdP1eqVZF5PRicg+LrrVV4/C29hMnRc=; b=M3L3796vPh1i5TcTJzVUIq
	3DMMmMzomLt+nqk6+syHPl6K3Dda8yUg6pbOVKDaA1yJ83gOJ6pMduQyjNPmQEqM
	+jHJJZpX0QGI6XnGGrnsF4kq+2AsxVE4D+JrP8Ven3RlfRdzZ33F579E+YoBOiPt
	TL+XB8sXi8ix0nQbEW9gAn4EYl2PZ2Z05/EFcGuuUzg/MdOsl7XY2luSMdzT2IQK
	a23pPelKBcxNRVRE9yOBVyWV6Y/V8bSXeooU1kZNSQw9SkG1OdXO4dra+nwtp3TF
	/eGuuC4XTT2OtEOu+OTmm3wEretDvgg7TxuOTZ8lFTW+7Pg8EZt5Kw9Za6g9it4g
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4561j327dg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 04 Mar 2025 20:11:15 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 524Gf6Dj020788;
	Tue, 4 Mar 2025 20:11:14 GMT
Received: from smtprelay02.dal12v.mail.ibm.com ([172.16.1.4])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 454esjxwsa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 04 Mar 2025 20:11:14 +0000
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay02.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 524KBEJq20906594
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 4 Mar 2025 20:11:14 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0F6EC5805A;
	Tue,  4 Mar 2025 20:11:14 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2A5F258052;
	Tue,  4 Mar 2025 20:11:13 +0000 (GMT)
Received: from [9.61.107.75] (unknown [9.61.107.75])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  4 Mar 2025 20:11:13 +0000 (GMT)
Message-ID: <a3e051e0-b2c3-4e2e-961e-ee36956a5666@linux.ibm.com>
Date: Tue, 4 Mar 2025 15:11:12 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2] s390/vfio-ap: Notify userspace that guest's AP
 config changed when mdev removed
To: Rorie Reyes <rreyes@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: hca@linux.ibm.com, borntraeger@de.ibm.com, agordeev@linux.ibm.com,
        gor@linux.ibm.com, pasic@linux.ibm.com, jjherne@linux.ibm.com,
        alex.williamson@redhat.com
References: <20250304200812.54556-1-rreyes@linux.ibm.com>
Content-Language: en-US
From: Anthony Krowiak <akrowiak@linux.ibm.com>
In-Reply-To: <20250304200812.54556-1-rreyes@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: tiG2HG6yWu_vmo5TBiraBFzxZVFt7ulp
X-Proofpoint-ORIG-GUID: tiG2HG6yWu_vmo5TBiraBFzxZVFt7ulp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-04_08,2025-03-04_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 impostorscore=0 spamscore=0 mlxlogscore=999 phishscore=0 clxscore=1015
 priorityscore=1501 adultscore=0 mlxscore=0 bulkscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2502100000 definitions=main-2503040160




On 3/4/25 3:08 PM, Rorie Reyes wrote:
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
> Fixes: 07d89045bffe ("s390/vfio-ap: Signal eventfd when guest AP configuration is changed")
> Signed-off-by: Rorie Reyes <rreyes@linux.ibm.com>
> ---
> This patch is based on the s390/features branch
>
> V1 -> V2:
> - replaced get_update_locks_for_kvm() with get_update_locks_for_mdev
> - removed else statements that were unnecessary
> - Addressed review comments for commit messages/details
> ---
>   drivers/s390/crypto/vfio_ap_ops.c | 15 ++++++++++++---
>   1 file changed, 12 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> index 571f5dcb49c5..ae2bc5c1d445 100644
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
> @@ -2057,6 +2056,13 @@ static void vfio_ap_mdev_request(struct vfio_device *vdev, unsigned int count)
>   
>   	matrix_mdev = container_of(vdev, struct ap_matrix_mdev, vdev);
>   
> +	get_update_locks_for_mdev(matrix_mdev);
> +
> +	if (matrix_mdev->kvm) {
> +		kvm_arch_crypto_clear_masks(matrix_mdev->kvm);
> +		signal_guest_ap_cfg_changed(matrix_mdev);
> +	}
> +
>   	if (matrix_mdev->req_trigger) {
>   		if (!(count % 10))
>   			dev_notice_ratelimited(dev,
> @@ -2068,6 +2074,9 @@ static void vfio_ap_mdev_request(struct vfio_device *vdev, unsigned int count)
>   		dev_notice(dev,
>   			   "No device request registered, blocked until released by user\n");
>   	}
> +
> +	release_update_locks_for_mdev(matrix_mdev);
> +

Get rid of empty line; other than that, LGTM
Reviewed-by: Anthony Krowiak <akrowiak@linux.ibm.com>

>   }
>   
>   static int vfio_ap_mdev_get_device_info(unsigned long arg)


