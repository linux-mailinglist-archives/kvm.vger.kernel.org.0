Return-Path: <kvm+bounces-19735-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C5C4909A10
	for <lists+kvm@lfdr.de>; Sat, 15 Jun 2024 23:50:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D98DF1F227BC
	for <lists+kvm@lfdr.de>; Sat, 15 Jun 2024 21:50:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E3406BFA6;
	Sat, 15 Jun 2024 21:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="YKZaPHJO"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ECD8179A8;
	Sat, 15 Jun 2024 21:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718488222; cv=none; b=bMSvw6DOOmq3Vtv0c2ncMh6U4ROQXiL7ZYy77q1/pAaNsTA6lYcrSbdnu5P8GlrlkdAp5kKx2TMQ2v9N0S0CnehiEv6F+XmZXur08Z9blS0maqClV7qaLTRVs5ZeI3kC5Z9epxDVh1mU+jiM1E5ISvw4KVYcJCDjvztpQSB+bAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718488222; c=relaxed/simple;
	bh=uu1WWpxIq5VIarKafJyQwgPBec0xd5BV54SUOdG0Fck=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=WBie2Lu9Fix13rPo00vgmutFlnWr77iYM8Oc1t/lHHljYoU6d43gJDyudRaIpcOL4YF5bIwFHZ48EM+MKElUI8oo0tBC8e0ETShWJt6ZpxcIX4ZESaBUHX3cCEEJyTSZTpcc68OtAP5DB4kdsFVFT+aG0JMJjkkx5VHBVfI7Paw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=YKZaPHJO; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45FKr7GN020565;
	Sat, 15 Jun 2024 21:50:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	BmnjQqYT5WAJg2A+SDNeEI4GjxYKoUJi9ctIjvw5UPc=; b=YKZaPHJON3afAsWV
	S9/Ke9lSxy2xd1q4NK+qyEqngWIKm2p+0pq/e4ejYaFNJMhsacuNXyXl4Alg9ooG
	wJbjW5rqdWu8QfFyUSrY7RGlYYdEz8IfItHSYYP+4u89/EV4DojXqzO+rdRDD+Kv
	DijVoMgXJFmEZsXIHrw7glp/fmQnM9R8z4BUCEG7LzKYcHPOcQOXsM2bIWGjBFBd
	EJhb6ROg1qMbO8RY/aaw7bcpmt1DI3pvCV55fC70l//VkQ3NrbAD7Vi8G69gwmV+
	meTdxMO8brxuL4xjOBhaaTLFmWV2jWI8kbde62NymgZEuuvf54SCODVUHdRzOn8x
	H6QxLg==
Received: from nalasppmta01.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3ys3qf128g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 15 Jun 2024 21:50:14 +0000 (GMT)
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
	by NALASPPMTA01.qualcomm.com (8.17.1.19/8.17.1.19) with ESMTPS id 45FLoDTq007589
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 15 Jun 2024 21:50:13 GMT
Received: from [10.48.243.167] (10.49.16.6) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Sat, 15 Jun
 2024 14:50:12 -0700
Message-ID: <7da04855-13a1-49f9-9336-424a9b6c6ad8@quicinc.com>
Date: Sat, 15 Jun 2024 14:50:11 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] vringh: add MODULE_DESCRIPTION()
Content-Language: en-US
To: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg KH
	<gregkh@linuxfoundation.org>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux.dev>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
References: <20240516-md-vringh-v1-1-31bf37779a5a@quicinc.com>
From: Jeff Johnson <quic_jjohnson@quicinc.com>
In-Reply-To: <20240516-md-vringh-v1-1-31bf37779a5a@quicinc.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: nalasex01c.na.qualcomm.com (10.47.97.35) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: t2kBISLsiaqvX0X_UssUBEvWD0an67TU
X-Proofpoint-ORIG-GUID: t2kBISLsiaqvX0X_UssUBEvWD0an67TU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-15_15,2024-06-14_03,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 clxscore=1015
 malwarescore=0 spamscore=0 mlxlogscore=946 bulkscore=0 phishscore=0
 lowpriorityscore=0 mlxscore=0 priorityscore=1501 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2405170001 definitions=main-2406150166

On 5/16/2024 6:57 PM, Jeff Johnson wrote:
> Fix the allmodconfig 'make w=1' issue:
> 
> WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/vhost/vringh.o
> 
> Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
> ---
>  drivers/vhost/vringh.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
> index 7b8fd977f71c..73e153f9b449 100644
> --- a/drivers/vhost/vringh.c
> +++ b/drivers/vhost/vringh.c
> @@ -1614,4 +1614,5 @@ EXPORT_SYMBOL(vringh_need_notify_iotlb);
>  
>  #endif
>  
> +MODULE_DESCRIPTION("host side of a virtio ring");
>  MODULE_LICENSE("GPL");
> 
> ---
> base-commit: 7f094f0e3866f83ca705519b1e8f5a7d6ecce232
> change-id: 20240516-md-vringh-c43803ae0ba4
> 

Just following up to see if anything else is needed to pick this up.


