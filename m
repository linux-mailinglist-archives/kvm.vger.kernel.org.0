Return-Path: <kvm+bounces-6005-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AE98B829DE0
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 16:46:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4A1DD1F27FFE
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 15:46:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0330A4CB33;
	Wed, 10 Jan 2024 15:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Y3uEX2GT"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 652B74CB21;
	Wed, 10 Jan 2024 15:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40AEtT60007939;
	Wed, 10 Jan 2024 15:44:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=46davaovqwEtnCcydpQdJJqyzVaiWwhAxC2+wADQOeE=;
 b=Y3uEX2GTc+BOW/lGynTiqOoi9fhgxYA8FLKgyRVh+7WQC1SBfScL0862Hlsj3ZlMdQO9
 ZiW6y8KxAOnc+XJcIOKDcs52X7+N+CFvYIZnfwUQVtEHSoOeux2VVOaWgZis6EY5mh1r
 Xu7bScke2Bz5ex3AEUxhKuOzNiGU+Wm1dxuBf8/C07ng0crWo4F/a9wOrqCmFhe6Ug16
 Am1LQ8vRQfJgflDi69AbteF6tB3bC/qwXTkrD6jfOi5twDwL5abAUGStNUCU/O4jW/MI
 bvgTNCYUXxE/PnLcHzEsZIeCcR42fhRwqU3PBuXYJhpja007OG4kbhl6v0Ctlacx83UE yw== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vhuu9m3yb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 Jan 2024 15:44:46 +0000
Received: from m0353727.ppops.net (m0353727.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 40AFfrYZ016567;
	Wed, 10 Jan 2024 15:44:45 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vhuu9m3xp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 Jan 2024 15:44:45 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 40AEc1JD028030;
	Wed, 10 Jan 2024 15:44:44 GMT
Received: from smtprelay03.wdc07v.mail.ibm.com ([172.16.1.70])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3vgwfst3bu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 Jan 2024 15:44:44 +0000
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
	by smtprelay03.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 40AFiguL11993778
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Jan 2024 15:44:43 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D94FC5805B;
	Wed, 10 Jan 2024 15:44:42 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4B4C458058;
	Wed, 10 Jan 2024 15:44:41 +0000 (GMT)
Received: from [9.61.170.131] (unknown [9.61.170.131])
	by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 10 Jan 2024 15:44:41 +0000 (GMT)
Message-ID: <41baa1b2-4afd-9adb-2121-b14c8943d9b1@linux.ibm.com>
Date: Wed, 10 Jan 2024 10:44:40 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v2 6/6] s390/vfio-ap: do not reset queue removed from host
 config
To: Tony Krowiak <akrowiak@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: borntraeger@de.ibm.com, pasic@linux.ibm.com, pbonzini@redhat.com,
        frankja@linux.ibm.com, imbrenda@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        stable@vger.kernel.org
References: <20231212212522.307893-1-akrowiak@linux.ibm.com>
 <20231212212522.307893-7-akrowiak@linux.ibm.com>
Content-Language: en-US
From: "Jason J. Herne" <jjherne@linux.ibm.com>
In-Reply-To: <20231212212522.307893-7-akrowiak@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: IsjIOTzPVQKvr0QmfztB0n_OxtMcN7ET
X-Proofpoint-ORIG-GUID: 17mlDLuzrl3HOz48TJCLJGVBUouciBuT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-10_07,2024-01-10_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 malwarescore=0
 adultscore=0 bulkscore=0 impostorscore=0 priorityscore=1501 phishscore=0
 mlxscore=0 mlxlogscore=999 lowpriorityscore=0 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2401100128



On 12/12/23 4:25 PM, Tony Krowiak wrote:
> When a queue is unbound from the vfio_ap device driver, it is reset to
> ensure its crypto data is not leaked when it is bound to another device
> driver. If the queue is unbound due to the fact that the adapter or domain
> was removed from the host's AP configuration, then attempting to reset it
> will fail with response code 01 (APID not valid) getting returned from the
> reset command. Let's ensure that the queue is assigned to the host's
> configuration before resetting it.
> 
> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> Fixes: eeb386aeb5b7 ("s390/vfio-ap: handle config changed and scan complete notification")
> Cc: <stable@vger.kernel.org>
> ---
>   drivers/s390/crypto/vfio_ap_ops.c | 14 ++++++++++++--
>   1 file changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> index e014108067dc..84decb0d5c97 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -2197,6 +2197,8 @@ void vfio_ap_mdev_remove_queue(struct ap_device *apdev)
>   	q = dev_get_drvdata(&apdev->device);
>   	get_update_locks_for_queue(q);
>   	matrix_mdev = q->matrix_mdev;
> +	apid = AP_QID_CARD(q->apqn);
> +	apqi = AP_QID_QUEUE(q->apqn);
>   
>   	if (matrix_mdev) {
>   		/* If the queue is assigned to the guest's AP configuration */
> @@ -2214,8 +2216,16 @@ void vfio_ap_mdev_remove_queue(struct ap_device *apdev)
>   		}
>   	}
>   
> -	vfio_ap_mdev_reset_queue(q);
> -	flush_work(&q->reset_work);
> +	/*
> +	 * If the queue is not in the host's AP configuration, then resetting
> +	 * it will fail with response code 01, (APQN not valid); so, let's make
> +	 * sure it is in the host's config.
> +	 */
> +	if (test_bit_inv(apid, (unsigned long *)matrix_dev->info.apm) &&
> +	    test_bit_inv(apqi, (unsigned long *)matrix_dev->info.aqm)) {
> +		vfio_ap_mdev_reset_queue(q);
> +		flush_work(&q->reset_work);
> +	}
>   
>   done:
>   	if (matrix_mdev)

Reviewed-by: Jason J. Herne <jjherne@linux.ibm.com>

