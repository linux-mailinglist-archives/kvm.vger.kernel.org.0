Return-Path: <kvm+bounces-21433-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B652292EEE6
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2024 20:30:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CB4221C21192
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2024 18:30:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 707DF16E875;
	Thu, 11 Jul 2024 18:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="Jsqf1XrO"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A04CB38DD9;
	Thu, 11 Jul 2024 18:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720722643; cv=none; b=XMRKr/KBbXM2FeIiCj3ukTBtdSrJqbSZ2Qvu9knbA0XnD9LTc6sSfvbHLJe6xmu5l95ECY5nGxvzCR0JO8Sl5ncxV2D5UiJF6AsdhOR7ZnQ60VqBNKgv0Z+xSGk+EqvgAaw55sTdFQkdBR5viAswMrV+3iO0qrI0vST3BX9ja98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720722643; c=relaxed/simple;
	bh=9sn8nM1twsWp4Q/iSpfYVppqiMuBH9x3yfcpgvicbbE=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=TVCLaz4qJ4ftxZd9j3YPHD2WbhnHE2Wve/ZRYgci3wf97VaVVufRZKcB2pHmV2fr5P5nO0wfKS0vVZoEUWPJ29xVOcmY6f9ah3YB9nVNSkAEt8ubsP41x7fCWMGkX83/FSCz6NtCzyaZJ5GzaSJrXyzKXCt5CLg3OLBE7h9TNSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=Jsqf1XrO; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46BDd6If012659;
	Thu, 11 Jul 2024 18:30:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	CHu8EhmZTPioa8VNwURbLi9DcxTX1wc4x2b8oUW5ApE=; b=Jsqf1XrOQA8ktcnC
	wMTQwrSYIL30KoQZQjmLrxsy+l0dvSdRpUfxaEHhquJ+rITSJnBoCLJ4GD0h2BnL
	Y+dGJE2lP41q9f2Z6a3X1vxkezKqr7GvrXRcRkp23Sq17yvnLYYCxWAGiUXj51Qi
	JmmX6Nos+zm+HpnCck/FqiIV9xaa7jon13OrWLuCLNabmmM7jhMm+AKjn0GYpdwW
	POs774dWK1J3jilTQjAcutQcny16b/sYIw7LaLrsp9vaE7gycl9Tdh/0Pr8H/gQS
	2yk189Ocdi5z9MnXW/WjhVShaGNI2QfbfXjK1TM5r8n2+Rh44gCfJO0zonpGeqZq
	5ky6Ig==
Received: from nalasppmta02.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 409vydug4k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Jul 2024 18:30:38 +0000 (GMT)
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
	by NALASPPMTA02.qualcomm.com (8.17.1.19/8.17.1.19) with ESMTPS id 46BIUbtH000739
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Jul 2024 18:30:37 GMT
Received: from [10.81.24.74] (10.49.16.6) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Thu, 11 Jul
 2024 11:30:37 -0700
Message-ID: <a94604eb-7ea6-4813-aa78-6c73f7d4253a@quicinc.com>
Date: Thu, 11 Jul 2024 11:30:36 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] vfio-mdev: add MODULE_DESCRIPTION() macros
To: Kirti Wankhede <kwankhede@nvidia.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
References: <20240523-md-vfio-mdev-v1-1-4676cd532b10@quicinc.com>
Content-Language: en-US
From: Jeff Johnson <quic_jjohnson@quicinc.com>
In-Reply-To: <20240523-md-vfio-mdev-v1-1-4676cd532b10@quicinc.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: nalasex01a.na.qualcomm.com (10.47.209.196) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: GgrMCBYmpWDWhAljSmRKHHmfMhE4GSTI
X-Proofpoint-ORIG-GUID: GgrMCBYmpWDWhAljSmRKHHmfMhE4GSTI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-11_13,2024-07-11_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 bulkscore=0
 priorityscore=1501 clxscore=1011 mlxlogscore=999 impostorscore=0
 suspectscore=0 spamscore=0 adultscore=0 malwarescore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2406140001 definitions=main-2407110128

On 5/23/24 17:12, Jeff Johnson wrote:
> Fix the 'make W=1' warnings:
> WARNING: modpost: missing MODULE_DESCRIPTION() in samples/vfio-mdev/mtty.o
> WARNING: modpost: missing MODULE_DESCRIPTION() in samples/vfio-mdev/mdpy.o
> WARNING: modpost: missing MODULE_DESCRIPTION() in samples/vfio-mdev/mdpy-fb.o
> WARNING: modpost: missing MODULE_DESCRIPTION() in samples/vfio-mdev/mbochs.o
> 
> Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
> ---
>   samples/vfio-mdev/mbochs.c  | 1 +
>   samples/vfio-mdev/mdpy-fb.c | 1 +
>   samples/vfio-mdev/mdpy.c    | 1 +
>   samples/vfio-mdev/mtty.c    | 1 +
>   4 files changed, 4 insertions(+)
> 
> diff --git a/samples/vfio-mdev/mbochs.c b/samples/vfio-mdev/mbochs.c
> index 9062598ea03d..836456837997 100644
> --- a/samples/vfio-mdev/mbochs.c
> +++ b/samples/vfio-mdev/mbochs.c
> @@ -88,6 +88,7 @@
>   #define STORE_LE32(addr, val)	(*(u32 *)addr = val)
>   
>   
> +MODULE_DESCRIPTION("Mediated virtual PCI display host device driver");
>   MODULE_LICENSE("GPL v2");
>   
>   static int max_mbytes = 256;
> diff --git a/samples/vfio-mdev/mdpy-fb.c b/samples/vfio-mdev/mdpy-fb.c
> index 4598bc28acd9..149af7f598f8 100644
> --- a/samples/vfio-mdev/mdpy-fb.c
> +++ b/samples/vfio-mdev/mdpy-fb.c
> @@ -229,4 +229,5 @@ static int __init mdpy_fb_init(void)
>   module_init(mdpy_fb_init);
>   
>   MODULE_DEVICE_TABLE(pci, mdpy_fb_pci_table);
> +MODULE_DESCRIPTION("Framebuffer driver for mdpy (mediated virtual pci display device)");
>   MODULE_LICENSE("GPL v2");
> diff --git a/samples/vfio-mdev/mdpy.c b/samples/vfio-mdev/mdpy.c
> index 27795501de6e..8104831ae125 100644
> --- a/samples/vfio-mdev/mdpy.c
> +++ b/samples/vfio-mdev/mdpy.c
> @@ -40,6 +40,7 @@
>   #define STORE_LE32(addr, val)	(*(u32 *)addr = val)
>   
>   
> +MODULE_DESCRIPTION("Mediated virtual PCI display host device driver");
>   MODULE_LICENSE("GPL v2");
>   
>   #define MDPY_TYPE_1 "vga"
> diff --git a/samples/vfio-mdev/mtty.c b/samples/vfio-mdev/mtty.c
> index 2284b3751240..40e7d154455e 100644
> --- a/samples/vfio-mdev/mtty.c
> +++ b/samples/vfio-mdev/mtty.c
> @@ -2059,5 +2059,6 @@ module_exit(mtty_dev_exit)
>   
>   MODULE_LICENSE("GPL v2");
>   MODULE_INFO(supported, "Test driver that simulate serial port over PCI");
> +MODULE_DESCRIPTION("Test driver that simulate serial port over PCI");
>   MODULE_VERSION(VERSION_STRING);
>   MODULE_AUTHOR(DRIVER_AUTHOR);
> 
> ---
> base-commit: 5c4069234f68372e80e4edfcce260e81fd9da007
> change-id: 20240523-md-vfio-mdev-381f74bf87f1
> 

I don't see this in linux-next yet so following up to see if anything 
else is needed to get this merged.

I hope to have these warnings fixed tree-wide in 6.11.

/jeff

