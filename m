Return-Path: <kvm+bounces-3085-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 80B3C8007C6
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 10:57:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3AB4B2818F9
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 09:57:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88E11200BD;
	Fri,  1 Dec 2023 09:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="gyPB4x8J"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBC262117;
	Fri,  1 Dec 2023 01:57:36 -0800 (PST)
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3B19QMdD018409;
	Fri, 1 Dec 2023 09:57:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=iE5vL/TCzGzSgU96m+b5jLpBrUhGV6W511CmXEeUKY8=;
 b=gyPB4x8JelWSpkXRlqDZGqhPfnRFAO33Y/YdTMxXYNvfAfQDV/64Y+Z+ZGJ+KYh47xSP
 g4osHfxVbYX+VvXA6j6RDnhH87ERsgaOK5dsWxanP2iQESQ475lPW4XS4wow8T/JjNBp
 LpecGBhTSHSnFanJFODd1fwseVPOaQWIVkfwhK2Mvisa8BoP9woGA5IG45h/5fCfz2WU
 iT4IpKC6sU2HO21D9vzJLpXs/Rq5vWXzo0v/x6/GWcUB5vQryNRjY0dm/N24/eO1nKWS
 Kpri93+jUZcte/Ph48EQ05PkMJpma44td3VcvetC4ZC/yo03v8ukziGf8WKlmcHod17v 3g== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3uqcgs17dc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 01 Dec 2023 09:57:34 +0000
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3B19uTiW013513;
	Fri, 1 Dec 2023 09:57:34 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3uqcgs17d6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 01 Dec 2023 09:57:34 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3B19Y2SU017434;
	Fri, 1 Dec 2023 09:57:33 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3ukvrm44ct-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 01 Dec 2023 09:57:33 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3B19vU2h28705206
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 1 Dec 2023 09:57:30 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2B6862004B;
	Fri,  1 Dec 2023 09:57:30 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D96A820040;
	Fri,  1 Dec 2023 09:57:29 +0000 (GMT)
Received: from [9.152.224.222] (unknown [9.152.224.222])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri,  1 Dec 2023 09:57:29 +0000 (GMT)
Message-ID: <90817094-9feb-84e6-7dc9-9b997f054242@linux.ibm.com>
Date: Fri, 1 Dec 2023 10:57:28 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v4 2/3] s390/vfio-ap: set status response code to 06 on
 gisc registration failure
Content-Language: en-US
To: Tony Krowiak <akrowiak@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>
Cc: jjherne@linux.ibm.com, pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com,
        david@redhat.com, Harald Freudenberger <freude@linux.ibm.com>
References: <20231129145404.263764-1-akrowiak@linux.ibm.com>
 <20231129145404.263764-3-akrowiak@linux.ibm.com>
From: Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20231129145404.263764-3-akrowiak@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Mn0oEm_e3xgh5DNv3S01u0JGMHFdxM5X
X-Proofpoint-ORIG-GUID: lV6f45zuC4MtyjHc38fzPVVSIG4MiOYO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-01_07,2023-11-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 malwarescore=0 phishscore=0 clxscore=1015 lowpriorityscore=0
 mlxlogscore=999 priorityscore=1501 suspectscore=0 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2312010066



Am 29.11.23 um 15:54 schrieb Tony Krowiak:
> From: Anthony Krowiak <akrowiak@linux.ibm.com>
> 
> The interception handler for the PQAP(AQIC) command calls the
> kvm_s390_gisc_register function to register the guest ISC with the channel
> subsystem. If that call fails, the status response code 08 - indicating
> Invalid ZONE/GISA designation - is returned to the guest. This response
> code is not valid because setting the ZONE/GISA values is the
> responsibility of the hypervisor controlling the guest and there is nothing
> that can be done from the guest perspective to correct that problem.
> 
> The likelihood of GISC registration failure is nil and there is no status
> response code to indicate an invalid ISC value, so let's set the response
> code to 06 indicating 'Invalid address of AP-queue notification byte'.
> While this is not entirely accurate, it is better than setting a response
> code which makes no sense for the guest.
> 
> Signed-off-by: Anthony Krowiak <akrowiak@linux.ibm.com>
> Suggested-by: Halil Pasic <pasic@linux.ibm.com>
> Reviewed-by: Halil Pasic <pasic@linux.ibm.com>
> Reviewed-by: Harald Freudenberger <freude@linux.ibm.com>

Acked-by: Christian Borntraeger <borntraeger@linux.ibm.com>

should go via the s390 tree

> ---
>   drivers/s390/crypto/vfio_ap_ops.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> index 9cb28978c186..25d7ce2094f8 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -393,8 +393,8 @@ static int ensure_nib_shared(unsigned long addr, struct gmap *gmap)
>    * Register the guest ISC to GIB interface and retrieve the
>    * host ISC to issue the host side PQAP/AQIC
>    *
> - * Response.status may be set to AP_RESPONSE_INVALID_ADDRESS in case the
> - * vfio_pin_pages failed.
> + * status.response_code may be set to AP_RESPONSE_INVALID_ADDRESS in case the
> + * vfio_pin_pages or kvm_s390_gisc_register failed.
>    *
>    * Otherwise return the ap_queue_status returned by the ap_aqic(),
>    * all retry handling will be done by the guest.
> @@ -458,7 +458,7 @@ static struct ap_queue_status vfio_ap_irq_enable(struct vfio_ap_queue *q,
>   				 __func__, nisc, isc, q->apqn);
>   
>   		vfio_unpin_pages(&q->matrix_mdev->vdev, nib, 1);
> -		status.response_code = AP_RESPONSE_INVALID_GISA;
> +		status.response_code = AP_RESPONSE_INVALID_ADDRESS;
>   		return status;
>   	}
>   

