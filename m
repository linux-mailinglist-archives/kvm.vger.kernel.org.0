Return-Path: <kvm+bounces-3086-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E92308007D1
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 10:59:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E2F8CB21312
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 09:59:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88804200D5;
	Fri,  1 Dec 2023 09:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="IIHmhCSd"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAC7D1718;
	Fri,  1 Dec 2023 01:59:02 -0800 (PST)
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3B19Bea6012283;
	Fri, 1 Dec 2023 09:59:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=JhGJPjpO1cLFqjeD4R8nIFqRnlBrKO94LwPI8EFTFho=;
 b=IIHmhCSd/uHFbdkb5Qqsbl5ILTum610NzctpsYqdn/AgB+O+N3QkyMZ/t8aSntbJBnso
 8/PYzNdG5J/DpYoHR38kx6Wrv+FanDMiHEJVsgWejH/UYKMlPF+tABqLd3akewepzZgK
 /KqDmFzv/8f7mNKssTDT2hXepTI3zYTwY4LxGfGuKwSP67PHXWfR+rD9lfy/BRlbqUzO
 X1UnB963h8j/DDpeJ0QRdXqzOketc/QBzevIN8UnGVqT3+7AoN+sQSACyVGmLUdTS1rG
 4F33KWNwxGTXM3c+jt/8mXjoR7QvZv3qRV30LGpCxjKQXEQhUJalDsoEl0SyHg9NQWgI fw== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3uqc2s233k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 01 Dec 2023 09:59:00 +0000
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3B19CJXh015483;
	Fri, 1 Dec 2023 09:58:59 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3uqc2s233e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 01 Dec 2023 09:58:59 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3B19XuQl029642;
	Fri, 1 Dec 2023 09:58:58 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3ukun04fb6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 01 Dec 2023 09:58:58 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3B19wtnJ17891974
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 1 Dec 2023 09:58:55 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 78A3C20043;
	Fri,  1 Dec 2023 09:58:55 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 010602004B;
	Fri,  1 Dec 2023 09:58:55 +0000 (GMT)
Received: from [9.152.224.222] (unknown [9.152.224.222])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri,  1 Dec 2023 09:58:54 +0000 (GMT)
Message-ID: <2822327d-bf4b-9dd2-1d3a-e0811bb0aa96@linux.ibm.com>
Date: Fri, 1 Dec 2023 10:58:53 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v4 3/3] s390/vfio-ap: improve reaction to response code 07
 from PQAP(AQIC) command
Content-Language: en-US
To: Tony Krowiak <akrowiak@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>
Cc: jjherne@linux.ibm.com, pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com,
        david@redhat.com, Matthew Rosato <mjrosato@linux.ibm.com>
References: <20231129145404.263764-1-akrowiak@linux.ibm.com>
 <20231129145404.263764-4-akrowiak@linux.ibm.com>
From: Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20231129145404.263764-4-akrowiak@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: kSn4j221ThvZr1Q1AtukYXZWL6bObKJn
X-Proofpoint-ORIG-GUID: pmKnlYrfHW5C1Tr4_C5HDogOF4UaxGj8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-01_07,2023-11-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 clxscore=1015 mlxscore=0 bulkscore=0 mlxlogscore=999
 malwarescore=0 adultscore=0 spamscore=0 impostorscore=0 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2312010066



Am 29.11.23 um 15:54 schrieb Tony Krowiak:
> Let's improve the vfio_ap driver's reaction to reception of response code
> 07 from the PQAP(AQIC) command when enabling interrupts on behalf of a
> guest:
> 
> * Unregister the guest's ISC before the pages containing the notification
>    indicator bytes are unpinned.
> 
> * Capture the return code from the kvm_s390_gisc_unregister function and
>    log a DBF warning if it fails.
> 
> Suggested-by: Matthew Rosato <mjrosato@linux.ibm.com>
> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>

Acked-by: Christian Borntraeger <borntraeger@linux.ibm.com>

should go via the s390 tree

> ---
>   drivers/s390/crypto/vfio_ap_ops.c | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> index 25d7ce2094f8..4e80c211ba47 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -476,8 +476,11 @@ static struct ap_queue_status vfio_ap_irq_enable(struct vfio_ap_queue *q,
>   		break;
>   	case AP_RESPONSE_OTHERWISE_CHANGED:
>   		/* We could not modify IRQ settings: clear new configuration */
> +		ret = kvm_s390_gisc_unregister(kvm, isc);
> +		if (ret)
> +			VFIO_AP_DBF_WARN("%s: kvm_s390_gisc_unregister: rc=%d isc=%d, apqn=%#04x\n",
> +					 __func__, ret, isc, q->apqn);
>   		vfio_unpin_pages(&q->matrix_mdev->vdev, nib, 1);
> -		kvm_s390_gisc_unregister(kvm, isc);
>   		break;
>   	default:
>   		pr_warn("%s: apqn %04x: response: %02x\n", __func__, q->apqn,

