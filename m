Return-Path: <kvm+bounces-21651-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B1CD1931858
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2024 18:18:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6D907283418
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2024 16:17:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 971FE1CAA1;
	Mon, 15 Jul 2024 16:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="jLsp/38j"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D6141CD31;
	Mon, 15 Jul 2024 16:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721060270; cv=none; b=hEhJz+DIZ/8s8QhW2aPoo0y8kMVCYKAANxmSpcTLACObMdGiDPJ/y0A2k/N26r/0odS0aSYjw0TCxC7SKLxQLKJdIZNd52gj1OjPeAJx7cdlNruMW4l4Z8dnrUuACsPvJuXYGKnje+iy5Jaq/b9kG+2mxfe9sHvk8PWPlZR9FcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721060270; c=relaxed/simple;
	bh=r+d9qpTSMQ9pDdeXJArccRvmnU/FbQJD0KsRUw9V2uc=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=FbUV+2RwUb9jeWTW9CI9PMNRXQvrvDYcc1UMBoIeeerCFsicyXBoeAFgCsO5NM5QW+bUllZWF21wCyeMYMFPR1SBejutBzdjkwILFz2E9dqI6cjaimLuLIfTHjfnkyKFY2R0etNZhxvOeV250Ww2jKH9gT1IfBe1pRQD4uf7Pro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=jLsp/38j; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46FBQ52B020313;
	Mon, 15 Jul 2024 16:17:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	vMY3JZEzrxVvB6ZgCY7NCJZdbtWa1h4Ng6YvRk3kHpo=; b=jLsp/38jcSy+NMH7
	9MK5SGaV/vDkWbzjzrr1+u8JeEuWK+a8wpN3TEXkkgK3ZOhvWgEKvlbi2XdLIr5k
	uzUJsprotclhGcBT3AoGNu5PQp+NDUgpYUWWikRbrj7V2xQ0aDH0b5hj36FAGH/w
	wn5BW2hrwbDv9eSxeYZEWI3ueusmll4/+guLJnE9CVbuYnW3+wTv/LbPPzI+N/tH
	nA6ij0E+B2Wq4R2QGJ13cd/bv52WL53fv3EXuGsvHNaFMarVLT4RLIiSCX1UMqQ3
	bPnv3NNyeXXCmAL/RgT1mkjEOC17fq0qF/gSijlE0QNqN5OhJZKj1edZoJlK+9/e
	Q7Xnng==
Received: from nalasppmta05.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 40bhnumqr0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 15 Jul 2024 16:17:44 +0000 (GMT)
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
	by NALASPPMTA05.qualcomm.com (8.17.1.19/8.17.1.19) with ESMTPS id 46FGHhwm004748
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 15 Jul 2024 16:17:43 GMT
Received: from [10.48.247.129] (10.49.16.6) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Mon, 15 Jul
 2024 09:17:42 -0700
Message-ID: <3717c990-ac93-4a43-a33c-bce02a066dfd@quicinc.com>
Date: Mon, 15 Jul 2024 09:17:41 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] vfio-mdev: add MODULE_DESCRIPTION() macros
Content-Language: en-US
To: Alex Williamson <alex.williamson@redhat.com>,
        Kirti Wankhede
	<kwankhede@nvidia.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
References: <20240523-md-vfio-mdev-v1-1-4676cd532b10@quicinc.com>
 <a94604eb-7ea6-4813-aa78-6c73f7d4253a@quicinc.com>
 <MN2PR12MB420688C51B3F2CC8BF8CA3A8DCA62@MN2PR12MB4206.namprd12.prod.outlook.com>
 <20240712163621.6f34ae98.alex.williamson@redhat.com>
From: Jeff Johnson <quic_jjohnson@quicinc.com>
In-Reply-To: <20240712163621.6f34ae98.alex.williamson@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: nalasex01c.na.qualcomm.com (10.47.97.35) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: rsHdjrt6dj0NIKZtbu3Std3xlESPW1Us
X-Proofpoint-GUID: rsHdjrt6dj0NIKZtbu3Std3xlESPW1Us
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-15_11,2024-07-11_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 mlxscore=0 lowpriorityscore=0 mlxlogscore=999
 suspectscore=0 phishscore=0 clxscore=1011 spamscore=0 malwarescore=0
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2406140001 definitions=main-2407150128

On 7/12/2024 3:36 PM, Alex Williamson wrote:>>>>   MODULE_LICENSE("GPL v2");
>>>>   MODULE_INFO(supported, "Test driver that simulate serial port over PCI");
>>>> +MODULE_DESCRIPTION("Test driver that simulate serial port over PCI");
> 
> Seems the preceding MODULE_INFO needs to be removed here.  At best the
> added MODULE_DESCRIPTION is redundant, but "supported" is not a
> standard tag, so it's not clear what the purpose of that tag was meant
> to be anyway.  Thanks,
> 
> Alex

My preference would be to just add the missing MODULE_DESCRIPTION() with this
patch since that fixes the existing warning. Removing an existing macro
invocation is out of scope for what I'm trying to accomplish.

Out of almost 300 patches treewide that add missing MODULE_DESCRIPTION()
macros, this is one of 13 that is still pending for the 6.11 merge window.

/jeff


