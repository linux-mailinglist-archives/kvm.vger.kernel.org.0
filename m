Return-Path: <kvm+bounces-19859-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EAD5890CFEC
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 15:30:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 90D6F281F24
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 13:30:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4B1114F9E2;
	Tue, 18 Jun 2024 12:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="NcF6YQZp"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 640EF15217A;
	Tue, 18 Jun 2024 12:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715160; cv=none; b=lnnfXb3ZLK3lVh80lqvPTc3txljEjkI69rFSMT0APz3UlWIidxEh8PoX+CGXk0uWGQ926/y7E/5EgFucWoD10MGv5oGrf/n5uVE1psTEDFDfno94UUaGU3JNDIwIh3QdiSVOGs1lphONYc8RoEL9kHv0OvG3V7M7i1omqG85YJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715160; c=relaxed/simple;
	bh=pBn80IzhuGRdmTZVHYfLCIkKKqjBbgAETcNFsymps04=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cAe6R3mnuJenQti3rfxk7zi9uI/Og1NLfz+k7AcGt+OIBF/tENX0b2GIlu3iSFwUxBHsNiCpB3AA9HMVr4zelQEHbMUAhjEpw4nc/w+yYhZL9SdWFDaysbmsny/pt0VkCQYJtokAYXeIjbZzAQCQ7ne2m7OQ/FVCLAr+SM7A/Bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=NcF6YQZp; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45ICj8Es011062;
	Tue, 18 Jun 2024 12:52:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	message-id:date:mime-version:subject:to:cc:references:from
	:in-reply-to:content-type:content-transfer-encoding; s=pp1; bh=U
	+4m8KYIdzZvREkSj/dSgWtwYRuSrHOhhAO28kw7O94=; b=NcF6YQZpPFXgEzgJU
	WCL7luYEdCobKKY/0NDzFQAcYizsIdBHHzz0wd2tEnBJVN/K8dHzK575CvM8Hv8N
	7jCHY8xDFj6wcD7xQwWN+j4kDzuuyAMoi99hDEsoNbOU/A1oDTaUjrwvqPPfVvCJ
	uDQ3APnhNFZoRTBbDbygmb2WBcW7I25FUhhAaVIfqnAH8uYg5PXQiG5SoMCm7+rX
	Q70YDNj1kMvhc0ZFI1X5a3tV8mSY8nw+RSg9sPRbkxgpMRqyHkolhQiYAVXqNj7A
	PyQaSrJwGAHvg+ctX9jM4pQiLA8uyTUkMX8fVx2Fv/Um2YYeE0lQVzvwoYryDYbh
	QEvGg==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yua9p82ae-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 18 Jun 2024 12:52:34 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 45IC1Yn8009433;
	Tue, 18 Jun 2024 12:52:33 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3ysqgmjukv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 18 Jun 2024 12:52:33 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 45ICqRVv17891672
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Jun 2024 12:52:29 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 851AA2004F;
	Tue, 18 Jun 2024 12:52:27 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 464E22004D;
	Tue, 18 Jun 2024 12:52:27 +0000 (GMT)
Received: from [9.152.212.186] (unknown [9.152.212.186])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 18 Jun 2024 12:52:27 +0000 (GMT)
Message-ID: <064eb313-2f38-479d-80bd-14777f7d3d62@linux.ibm.com>
Date: Tue, 18 Jun 2024 14:52:26 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] s390/cio: add missing MODULE_DESCRIPTION() macros
Content-Language: en-US
To: Jeff Johnson <quic_jjohnson@quicinc.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>
Cc: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <20240615-md-s390-drivers-s390-cio-v1-1-8fc9584e8595@quicinc.com>
From: Vineeth Vijayan <vneethv@linux.ibm.com>
In-Reply-To: <20240615-md-s390-drivers-s390-cio-v1-1-8fc9584e8595@quicinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: NsIo8IT7sIOm_ZqKTw8PjkyJK5nEJUZs
X-Proofpoint-GUID: NsIo8IT7sIOm_ZqKTw8PjkyJK5nEJUZs
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-18_02,2024-06-17_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 suspectscore=0
 clxscore=1011 mlxscore=0 priorityscore=1501 mlxlogscore=999 spamscore=0
 phishscore=0 impostorscore=0 lowpriorityscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2405170001 definitions=main-2406180092



On 6/16/24 05:56, Jeff Johnson wrote:
> With ARCH=s390, make allmodconfig && make W=1 C=1 reports:
> WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/s390/cio/ccwgroup.o
> WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/s390/cio/vfio_ccw.o
> 
> Add the missing invocations of the MODULE_DESCRIPTION() macro.
> 
> Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
> ---
>   drivers/s390/cio/ccwgroup.c     | 1 +
>   drivers/s390/cio/vfio_ccw_drv.c | 1 +
>   2 files changed, 2 insertions(+)
> 
> diff --git a/drivers/s390/cio/ccwgroup.c b/drivers/s390/cio/ccwgroup.c
> index b72f672a7720..a741e5012fce 100644
> --- a/drivers/s390/cio/ccwgroup.c
> +++ b/drivers/s390/cio/ccwgroup.c
> @@ -550,4 +550,5 @@ void ccwgroup_remove_ccwdev(struct ccw_device *cdev)
>   	put_device(&gdev->dev);
>   }
>   EXPORT_SYMBOL(ccwgroup_remove_ccwdev);
> +MODULE_DESCRIPTION("CCW group bus driver");

the name of the bus here is "ccwgroup" bus without a space.
Otherwise this change in ccwgroup.c looks good to me.
Thank you for the patch.

With the correction mentioned above,
Reviewed-by: Vineeth Vijayan <vneethv@linux.ibm.com>


>   MODULE_LICENSE("GPL");
> diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
> index 8ad49030a7bf..49da348355b4 100644
> --- a/drivers/s390/cio/vfio_ccw_drv.c
> +++ b/drivers/s390/cio/vfio_ccw_drv.c
> @@ -488,4 +488,5 @@ static void __exit vfio_ccw_sch_exit(void)
>   module_init(vfio_ccw_sch_init);
>   module_exit(vfio_ccw_sch_exit);
>   
> +MODULE_DESCRIPTION("VFIO based Physical Subchannel device driver");

Halil/Mathew/Eric,
Could you please comment on this ?

>   MODULE_LICENSE("GPL v2");
> 
> ---
> base-commit: 83a7eefedc9b56fe7bfeff13b6c7356688ffa670
> change-id: 20240615-md-s390-drivers-s390-cio-3598abb802ad
> 

