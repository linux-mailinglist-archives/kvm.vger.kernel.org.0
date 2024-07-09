Return-Path: <kvm+bounces-21241-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D265892C62D
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 00:17:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 62ADDB2253F
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 22:17:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6461C18C18C;
	Tue,  9 Jul 2024 22:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="Tb0JNCiZ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D28A182A6B;
	Tue,  9 Jul 2024 22:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720563353; cv=none; b=tTrSqWVPodx3oXzqyQyKSvZbosJP3z3+vdKXQgMpKPn/ONlJZyMyHJyhdQWkSOVLqlDxE0U3V2+i+7oM5/ocnkm3vubLdj9+/fzwbh2UhAfsLHVyzAxxLJSU8h/9WkheWHWD34hz4rfvAve/wLy+Ol0J9nKSOm5y6P17UKj3sq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720563353; c=relaxed/simple;
	bh=L3OYjzT7gk/y2KBkwTJSXAdbvt4/7kkO9Pg4tMXryPs=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=PN70o3HFLFXfk5jLgCLcl/XqpWAHw4OV5jy94ussrj5D2gS0Tpd53VSUPoGcVOFaN9Uj1YbBW3bchqGaMvtUFwxEZ1xTFHOlO1SUNRzmNhv6S/VcKh68il5A5H9KOHlXodUrCQ53ar4EOH4MNSiLiCqrj1zxaoKhTG/tUN14uQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=Tb0JNCiZ; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4699oZvJ031417;
	Tue, 9 Jul 2024 22:15:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	sVK3UYVSjbY3trWtc+qEfMeP3E59zIUTt+3mNbWkwBA=; b=Tb0JNCiZN8f/YrPU
	9nPDIe60xAqa+5eHkZ7hTyHGDUgMWVQUzNToZ7T/vGvpm41jw2OB/RcI2JRBfdkC
	9rmv/BJtTtPTE+KmaTIGqVP+sWsw4qYpag+ocUrdSj2aQHXCSvKtCs1rru7N0rFE
	cFVtuWAMqHLzVE9LvF3j8D1n84sR91nK4dszGwRfybMBxLE5L2NP0uX4DVHPMyX/
	WZ7fG6nEfU0QBRSQAUkjVD4VU6Bap943zPY2RHfBNDvEPr+nAO+HjktZaxfDBaGd
	UD6LvL4ipG7vj4SgjkeD/RLkyq4YGTaEoAhbyMWn5s2FfhNsIj6AEyHspw6hHD8p
	5JXG1A==
Received: from nalasppmta05.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 406wmmqud3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 09 Jul 2024 22:15:50 +0000 (GMT)
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
	by NALASPPMTA05.qualcomm.com (8.17.1.19/8.17.1.19) with ESMTPS id 469MFnsA030019
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 9 Jul 2024 22:15:49 GMT
Received: from [10.48.245.228] (10.49.16.6) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Tue, 9 Jul 2024
 15:15:47 -0700
Message-ID: <40298bcf-8c39-4f81-bdb2-afec914fc976@quicinc.com>
Date: Tue, 9 Jul 2024 15:15:45 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] s390/cio: add missing MODULE_DESCRIPTION() macros
Content-Language: en-US
To: Eric Farman <farman@linux.ibm.com>, Halil Pasic <pasic@linux.ibm.com>
CC: Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter
	<oberpar@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik
	<gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian
 Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>, <linux-s390@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
References: <20240615-md-s390-drivers-s390-cio-v1-1-8fc9584e8595@quicinc.com>
 <064eb313-2f38-479d-80bd-14777f7d3d62@linux.ibm.com>
 <afdde0842680698276df0856dd8b896dac692b56.camel@linux.ibm.com>
 <20240619123255.4b1a6c6d.pasic@linux.ibm.com>
 <8ae9b1bef0e8ef4689873911c8ae5c9a921401a9.camel@linux.ibm.com>
From: Jeff Johnson <quic_jjohnson@quicinc.com>
In-Reply-To: <8ae9b1bef0e8ef4689873911c8ae5c9a921401a9.camel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: nalasex01a.na.qualcomm.com (10.47.209.196) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: -o9blC4wuLIkjg7kUJJpiN6XPRqBFQvH
X-Proofpoint-ORIG-GUID: -o9blC4wuLIkjg7kUJJpiN6XPRqBFQvH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-09_10,2024-07-09_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011
 priorityscore=1501 lowpriorityscore=0 spamscore=0 bulkscore=0 adultscore=0
 impostorscore=0 suspectscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2406140001 definitions=main-2407090151

On 6/19/2024 7:00 AM, Eric Farman wrote:
> On Wed, 2024-06-19 at 12:32 +0200, Halil Pasic wrote:
>> On Tue, 18 Jun 2024 16:11:33 -0400
>> Eric Farman <farman@linux.ibm.com> wrote:
>>
>>>>> +MODULE_DESCRIPTION("VFIO based Physical Subchannel device
>>>>> driver");  
>>>>
>>>> Halil/Mathew/Eric,
>>>> Could you please comment on this ?  
>>>
>>> That's what is in the prologue, and is fine.
>>
>> Eric can you explain it to me why is the attribute "physical"
>> appropriate
>> here? I did a quick grep for "Physical Subchannel" only turned up
>> hits
>> in vfio-ccw.
> 
> One hit, in the prologue comment of this module. "Physical device" adds
> three to the tally, but only one of those is in vfio-ccw so we should
> expand your query regarding "physical" vs "emulated" vs "virtual" in
> the context of, say, tape devices.
> 
>>
>> My best guess is that "physical" was somehow intended to mean the
>> opposite of "virtual". But actually it does not matter if our
>> underlying
>> subchannel is emulated or not, at least AFAIU.
> 
> I also believe this was intended to mean "not virtual," regardless of
> whether there's emulation taking place underneath. That point is moot
> since I don't see that information being surfaced, such that the driver
> can only work with "physical" subchannels.
> 
> I'm fine with removing it if it bothers you, but I don't see it as an
> issue.

Since I'm not the domain expert here I just copied what was in the prologue.
If someone can supply a suitable description, I'll update the patch to use it :)

I'm hoping to have these issued cleaned up tree-wide before the 6.11 merge window.

/jeff


