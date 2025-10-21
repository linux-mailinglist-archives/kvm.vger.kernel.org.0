Return-Path: <kvm+bounces-60636-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E200BF5472
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 10:36:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3A5D918C544C
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 08:36:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3DC93164D0;
	Tue, 21 Oct 2025 08:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="KH2LNSyp"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AACED313298
	for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 08:34:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761035661; cv=none; b=dTpoEH5pfRHjyosoZKdC/4Aqc7SjUaL/xPPT6cAWWXy0PNNTL1uo4puhW2n2dULjhQa9ZIKT/02SBRkSnq6R57kJ2QCl15aOX3DM6nKOGqlcICA50w8c6s64BzMC9QG+ZvX50aw0enov3IaLX8mdmjWCkbiYwQAZyX1uEBh159U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761035661; c=relaxed/simple;
	bh=oZMKZluxpjT2q0VX4GyOvOS8CRLgTmWwK8yzjG2WnZQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rPfkMgyeITla117JilIdP0/lbhAvYtKd3T+gDH9YDDk2x+0lOF8/e4z8BrKgKubUVXmdr8M/yddDDuyC+bSPPiZ2sOCnSnFszeXSxSCpHKxdHPODS7ZUlTzrdNn3frEsC6xrqrchlrdrWRM8UBmWoAxu2w1OioeyFncBapttr/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=KH2LNSyp; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59KMmlhd015153;
	Tue, 21 Oct 2025 08:34:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=y1f+XH
	XFLaBwmTFwJbNAM8tdNEK3R/QofhGR0fPjJN0=; b=KH2LNSypDyDyet4uLvuJcE
	ye2iK8CkiwwHoFPlXQLPKtGScbNCeGwlNsw/gpWgZSF1tlLc0feVEfOTbyCKjoYN
	nL+l7yqW8EAlel1N1N9sM3yObtAMvn6LoLm28kkzFhp2anJeUnAB26NBXAhO7TX/
	Q/xt25ib03KJ6YvPxKv5whVznZwyi3oof33dxDPbnw/TQ5whnSC4XqvsSEeVWoh7
	YB43pjieV6EzYS8zFXC9aLXck2L0k7xiiFJDnb5V7+uFlkp/R0c/UFbaGlBbXa6s
	DY+2L93bDhfJxdG6rP9/JNUTmqyyXGZszrxzPiFWzm5lWuZYbaBzGnF/qbAQbr+w
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49v31rwxdm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 Oct 2025 08:34:07 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 59L8SpLf029686;
	Tue, 21 Oct 2025 08:34:06 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49v31rwxdg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 Oct 2025 08:34:06 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 59L7rCDo032142;
	Tue, 21 Oct 2025 08:34:05 GMT
Received: from smtprelay07.wdc07v.mail.ibm.com ([172.16.1.74])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 49vp7mssh7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 Oct 2025 08:34:05 +0000
Received: from smtpav05.dal12v.mail.ibm.com (smtpav05.dal12v.mail.ibm.com [10.241.53.104])
	by smtprelay07.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 59L8Y4eG63242568
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Oct 2025 08:34:05 GMT
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D7DF758056;
	Tue, 21 Oct 2025 08:34:04 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5BEE85805D;
	Tue, 21 Oct 2025 08:34:02 +0000 (GMT)
Received: from [9.109.242.24] (unknown [9.109.242.24])
	by smtpav05.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 21 Oct 2025 08:34:02 +0000 (GMT)
Message-ID: <6c1c6488-679b-4bb8-8fb2-569a9f705ba7@linux.ibm.com>
Date: Tue, 21 Oct 2025 14:04:00 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/18] hw/ppc/spapr: Remove deprecated pseries-3.0 ->
 pseries-4.2 machines
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>,
        qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Nicholas Piggin <npiggin@gmail.com>,
        qemu-ppc@nongnu.org, kvm@vger.kernel.org,
        Chinmay Rath <rathc@linux.ibm.com>
References: <20251020103815.78415-1-philmd@linaro.org>
 <fdb7e249-b801-4f57-943d-71e620df2fb3@linux.ibm.com>
 <8993a80c-6cb5-4c5b-a0ef-db9257c212be@redhat.com>
 <6dcf7f38-5d1d-47a0-b647-b63b9151b4b6@linaro.org>
Content-Language: en-US
From: Harsh Prateek Bora <harshpb@linux.ibm.com>
In-Reply-To: <6dcf7f38-5d1d-47a0-b647-b63b9151b4b6@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 10K1frV2wbgOTd-IUkUtYqy7Y71EM2nc
X-Proofpoint-GUID: dFVBtMpVflffMbYtxfCSPHpOWs16ZHP5
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE4MDAyMiBTYWx0ZWRfX7wH5vPH8yRwJ
 F/hxg0kL7deEniW1GQw2O28m0WSzet4lOsyvdimbnmzXVzMXq1orAQmmzAjFg7rQIUg8riGDRLs
 kpn1MQF+tBvx/ppo1Kio9viidcK3WruI8NhXXjI/dC6rf4b7lj83EZcwlafGfB0ghI6wEbesQNy
 QUv38/lnYHGju7zhm3M3OZVHu879oT4ZqqpMvhUtc5aFatEtk9atsFl2QvlAAsReAEqYDyVI8Ij
 jaKV1c8Rrv+PCe+j5kTlOp/pWN6e/mBXAZXuMs15CWk08iBHTrL1ZX3o3Mp2IcmJ6Ad6DhdLaC4
 aGVmRsApZNpF7QpTEXdZT0Oy3Bs75FgaAbS+V6/nwmq6/GB2TW3BJgU3YhgFZHNys3Fs72padFP
 chYKUKJ/aoS4R4V6oxRS1Cn6rluTvQ==
X-Authority-Analysis: v=2.4 cv=IJYPywvG c=1 sm=1 tr=0 ts=68f7457f cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=f7IdgyKtn90A:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=QSvJpS1G6Mq8gHJVPkUA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=oH34dK2VZjykjzsv8OSz:22 a=cPQSjfK2_nFv0Q5t_7PE:22 a=HhbK4dLum7pmb74im6QT:22
 a=Z5ABNNGmrOfJ6cZ5bIyy:22 a=SsAZrZ5W_gNWK9tOzrEV:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-20_07,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=0 clxscore=1015 suspectscore=0 spamscore=0
 bulkscore=0 adultscore=0 impostorscore=0 malwarescore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510020000 definitions=main-2510180022



On 10/21/25 13:16, Philippe Mathieu-Daudé wrote:
> On 21/10/25 08:31, Cédric Le Goater wrote:
>> Hi
>>
>> On 10/21/25 06:54, Harsh Prateek Bora wrote:
>>> +Cedric
>>>
>>> Hi Phillipe,
>>>
>>> It had been done and the patches were reviewed already here (you were 
>>> in CC too):
>>>
>>> https://lore.kernel.org/qemu-devel/20251009184057.19973-1- 
>>> harshpb@linux.ibm.com/
>>
>> I would take the already reviewed patches, as that work is done. This 
>> series
>> is fine, but it is extra effort for removing dead code, which isn't worth
>> the time.
> 
> My bad for missing a series reviewed 2 weeks ago (and not yet merged).
> 
> Please consider cherry-picking the patches doing these cleanups then,
> which were missed because "too many things changed in a single patch"
> IMHO:
> 
> -- >8 --

Thanks for highlighting the delta cleanups, we can take care.

regards,
Harsh

