Return-Path: <kvm+bounces-21654-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E230931964
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2024 19:33:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CB7461F22A9A
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2024 17:33:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9538A4D8CC;
	Mon, 15 Jul 2024 17:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="ZQYuBx0c"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CFA9224EF;
	Mon, 15 Jul 2024 17:32:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721064773; cv=none; b=YGZ4zo8quxwA2fq29YYoVQiu9buKqG6sk/Kthu+AjbuparvoV3qA9hI9xig6rbVEjOSRI+FLQV457qUM3QbKG3VlORcmcRoxPcTS4B20btx2hh40QFXixKQdQ7eonFosNZDUIM9rBSiLbeJr1TkATL+Qku02g1dBA/q3jf47bQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721064773; c=relaxed/simple;
	bh=UWnRcUzwi9Uqj2YWWnawaWlNMpjIv/5tEUSPXIHZMLw=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=tHLWVa93ZGQwR5fMJaplCTZaRR8hHKWCDPQwJw9aCPbK2ZUP9VOc6w1cnXFGliuHrfse4wsuA1Q8IzyY5MzzRPDG6oorP9uO+YoLDpwrkjiKw8/kbUZAuZIZzGD312pOPqvXDy8aQWG+Q5vEGGNCDKik8vnlJrT6EzvdQZKZyy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=ZQYuBx0c; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46FH8i6N011845;
	Mon, 15 Jul 2024 17:32:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Ek+O80F6CChVrZQdWGSuGkbgld3v8A1/DkOZGpo87LU=; b=ZQYuBx0cbfa3FCkt
	aOnaGPkj+BL6A+myEFEnly41dW9K4rrXX/xBIsM5huY4QW927TbeoeJa3hMn7yz3
	mhssghF8DOq9oSJmbiW10tznsQgN6FPYsIypNX+pCq9V+GBwxUNKviqjeQFfEVWq
	vAwXMrgfmJdG2QJdsoE+NCw9pAHA+Y+9V/qnhfaBmFNdI9Hm19VhJ5LhhL+qyKoI
	MXLJgPO3V5ZvMtRv8CAdQbOpWlndC9gB3DVd42D7W/KRA0RvGvrs1sZIjp6bVpon
	Sql/5pQU97oI8s/dPNpGMDfQFSdN+AKu3+/6O8bflMOKKUrsJ9cKzReDLuELwqGs
	wNXkoA==
Received: from nalasppmta02.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 40bgwg4xh9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 15 Jul 2024 17:32:40 +0000 (GMT)
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
	by NALASPPMTA02.qualcomm.com (8.17.1.19/8.17.1.19) with ESMTPS id 46FHWd4T005496
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 15 Jul 2024 17:32:39 GMT
Received: from [10.48.247.129] (10.49.16.6) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Mon, 15 Jul
 2024 10:32:38 -0700
Message-ID: <ac6de49a-a130-41eb-87b5-0ecd1e05840b@quicinc.com>
Date: Mon, 15 Jul 2024 10:32:38 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] vfio-mdev: add MODULE_DESCRIPTION() macros
Content-Language: en-US
To: Alex Williamson <alex.williamson@redhat.com>
CC: Kirti Wankhede <kwankhede@nvidia.com>,
        "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org"
	<kernel-janitors@vger.kernel.org>
References: <20240523-md-vfio-mdev-v1-1-4676cd532b10@quicinc.com>
 <a94604eb-7ea6-4813-aa78-6c73f7d4253a@quicinc.com>
 <MN2PR12MB420688C51B3F2CC8BF8CA3A8DCA62@MN2PR12MB4206.namprd12.prod.outlook.com>
 <20240712163621.6f34ae98.alex.williamson@redhat.com>
 <3717c990-ac93-4a43-a33c-bce02a066dfd@quicinc.com>
 <20240715103536.3e1370ef.alex.williamson@redhat.com>
From: Jeff Johnson <quic_jjohnson@quicinc.com>
In-Reply-To: <20240715103536.3e1370ef.alex.williamson@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: nalasex01b.na.qualcomm.com (10.47.209.197) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: 2Z5D_oFVDS7QP5aWCDCCvsPw9SZCFiz3
X-Proofpoint-ORIG-GUID: 2Z5D_oFVDS7QP5aWCDCCvsPw9SZCFiz3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-15_11,2024-07-11_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 malwarescore=0
 adultscore=0 spamscore=0 priorityscore=1501 mlxscore=0 suspectscore=0
 mlxlogscore=993 lowpriorityscore=0 clxscore=1015 bulkscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2406140001 definitions=main-2407150136

On 7/15/2024 9:35 AM, Alex Williamson wrote:
> On Mon, 15 Jul 2024 09:17:41 -0700
> Jeff Johnson <quic_jjohnson@quicinc.com> wrote:
> 
>> On 7/12/2024 3:36 PM, Alex Williamson wrote:>>>>   MODULE_LICENSE("GPL v2");
>>>>>>   MODULE_INFO(supported, "Test driver that simulate serial port over PCI");
>>>>>> +MODULE_DESCRIPTION("Test driver that simulate serial port over PCI");  
>>>
>>> Seems the preceding MODULE_INFO needs to be removed here.  At best the
>>> added MODULE_DESCRIPTION is redundant, but "supported" is not a
>>> standard tag, so it's not clear what the purpose of that tag was meant
>>> to be anyway.  Thanks,
>>>
>>> Alex  
>>
>> My preference would be to just add the missing MODULE_DESCRIPTION() with this
>> patch since that fixes the existing warning. Removing an existing macro
>> invocation is out of scope for what I'm trying to accomplish.
> 
> This adds a MODULE_DESCRIPTION that's redundant to the current
> MODULE_INFO, therefore I'd argue that it's not out of scope to replace
> the MODULE_INFO with a MODULE_DESCRIPTION to achieve your goal.  Thanks,
> 
> Alex
> 
ok, let me post a v2

/jeff

