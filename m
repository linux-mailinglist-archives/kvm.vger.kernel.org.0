Return-Path: <kvm+bounces-3084-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D742D8007BE
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 10:57:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 922C2281B10
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 09:57:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28EB420B2C;
	Fri,  1 Dec 2023 09:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="HHfQEViQ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D029170F;
	Fri,  1 Dec 2023 01:56:54 -0800 (PST)
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3B19FigQ025951;
	Fri, 1 Dec 2023 09:56:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=RK4Y0gnMVUns5GJenYBxnMzG5ooeQ9tCqkoaWTKQDHs=;
 b=HHfQEViQAA5nyhB+Xf+yDGdg1QgsemU4tLqqlbckPMtzW7iNlL0lOBvKWQhTnHvU+Zac
 OCh71WIV0TN5za9cwcjqfx8lTZQCYOBZzHjee8cSmHpBK1N81WnzxLp1ksjtBkE8sel+
 pBD4cebiM5QNqR4JOhT8h46CBmxdv/WnATcEi/8YPkhLWGwNbw7gq73l6Yu37d9DjJ12
 syh6l0vED9H3ctSivwnJk6Xi7mu8sIpz0NIsXREhAF0hxerUaTIz7v13Rp6iQNP4BSX+
 Zc8B7yuOBlZ29dYuwIaLd7OmSdLLN0FCkWpgaM9wrF6/xiFIL5bTGvk3cTE6fA+Mj/8X sg== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3uqc2sj2tx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 01 Dec 2023 09:56:52 +0000
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3B19d6XK007581;
	Fri, 1 Dec 2023 09:56:51 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3uqc2sj2th-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 01 Dec 2023 09:56:51 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3B19Y1rW031406;
	Fri, 1 Dec 2023 09:56:51 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3ukv8p4898-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 01 Dec 2023 09:56:50 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3B19ukLa24642172
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 1 Dec 2023 09:56:46 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C690A20043;
	Fri,  1 Dec 2023 09:56:46 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8097920040;
	Fri,  1 Dec 2023 09:56:46 +0000 (GMT)
Received: from [9.152.224.222] (unknown [9.152.224.222])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri,  1 Dec 2023 09:56:46 +0000 (GMT)
Message-ID: <d9fb5a2b-2250-f319-1207-5697bcf190d3@linux.ibm.com>
Date: Fri, 1 Dec 2023 10:56:45 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v4 1/3] s390/vfio-ap: unpin pages on gisc registration
 failure
To: Tony Krowiak <akrowiak@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>
Cc: jjherne@linux.ibm.com, pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com,
        david@redhat.com, Matthew Rosato <mjrosato@linux.ibm.com>,
        stable@vger.kernel.org
References: <20231129145404.263764-1-akrowiak@linux.ibm.com>
 <20231129145404.263764-2-akrowiak@linux.ibm.com>
Content-Language: en-US
From: Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20231129145404.263764-2-akrowiak@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: JuLLSH2P2nZL6ZajDXOEmpYhk7S5alXw
X-Proofpoint-ORIG-GUID: N61-Rc8kXWluTZpIdz-anCp7X8rf0Uo7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-01_07,2023-11-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 priorityscore=1501
 mlxlogscore=999 adultscore=0 bulkscore=0 phishscore=0 clxscore=1011
 spamscore=0 lowpriorityscore=0 impostorscore=0 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2312010066

Am 29.11.23 um 15:53 schrieb Tony Krowiak:
> From: Anthony Krowiak <akrowiak@linux.ibm.com>
> 
> In the vfio_ap_irq_enable function, after the page containing the
> notification indicator byte (NIB) is pinned, the function attempts
> to register the guest ISC. If registration fails, the function sets the
> status response code and returns without unpinning the page containing
> the NIB. In order to avoid a memory leak, the NIB should be unpinned before
> returning from the vfio_ap_irq_enable function.
> 
> Co-developed-by: Janosch Frank <frankja@linux.ibm.com>
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> Signed-off-by: Anthony Krowiak <akrowiak@linux.ibm.com>
> Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
> Fixes: 783f0a3ccd79 ("s390/vfio-ap: add s390dbf logging to the vfio_ap_irq_enable function")
> Cc: <stable@vger.kernel.org>

Acked-by: Christian Borntraeger <borntraeger@linux.ibm.com>

should go via the s390 tree
Tony, please CC Heiko, Vasily and Alexander

> ---
>   drivers/s390/crypto/vfio_ap_ops.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> index 4db538a55192..9cb28978c186 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -457,6 +457,7 @@ static struct ap_queue_status vfio_ap_irq_enable(struct vfio_ap_queue *q,
>   		VFIO_AP_DBF_WARN("%s: gisc registration failed: nisc=%d, isc=%d, apqn=%#04x\n",
>   				 __func__, nisc, isc, q->apqn);
>   
> +		vfio_unpin_pages(&q->matrix_mdev->vdev, nib, 1);
>   		status.response_code = AP_RESPONSE_INVALID_GISA;
>   		return status;
>   	}

