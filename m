Return-Path: <kvm+bounces-48508-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E36DACEC92
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 11:06:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 818A33A7093
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 09:06:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF08520969A;
	Thu,  5 Jun 2025 09:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="VIWSv99M"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85DF0566A;
	Thu,  5 Jun 2025 09:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749114399; cv=none; b=Niw2G+MGPloJwevL3YGotHmSjrlVYAlaQR19AuRnWHu953TYuD2Jw7CdkDAAi05m8TnthjqqBXiQ9nAN7U0xJI4PQI2oBnKFerbBWA965q76NmzqFNV2XzAWj+FCubcH3hy4P+vPBhY2UI34HAkf28yLCakDMdJp8xdm4oz/IC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749114399; c=relaxed/simple;
	bh=/shQMOR1zYdDdv8vlDhRoaEdJl02lBuH2es2PgKpYDw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kDJppbleMl7g2tFHSbtUnRU/AOBeEXCbhNHdIScG+ZVEh7+zolfWNEQL51gTcixrp0w3ACpvAqmFZRxAZwJlTp1cQYGQy2VX15RHVb3LNkIWHUEAhXVQc69W/dtvnKC+UIigRXO2HXKwl8JFffuDMYJG9YDtafgJguwCmF7VfSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=VIWSv99M; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 554Na9ES025443;
	Thu, 5 Jun 2025 09:06:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=RggBQk
	NjQmrOgTc9mJNXEsYOfIhymx08A05AmkZ32fA=; b=VIWSv99MKpVrS/3KffSt8E
	DcNdpcD0fnlt/fIeXBkOLmfcU+YyQWUizQB5j8xtzqu9Jg+5Gy3sTaG6O2zcVUAK
	kAmohvl0B45GY8lL8AQooVk5nYMEXiEUpK6eXB9a6Ueaucdxz4uzivqw4Vdg4iaO
	pm0AUG2oMZZ8DxsxLhF5CqqNyz9cub7QrHDVaY2sPI8NQJjvG7BKYWtUzJUNgBgM
	WBb2AoGWdNJu6YQ0/U2jDzf2zGyjmMxMtg096p0+pCMEUR07efpH11DsNZilkHk+
	vFqm4O8yeTDZmDBFN2dxaaFlTAFXTme9oVo8ezol2usdHPG56LxZXqC0+0DiUaAw
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 471geyyrrd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 05 Jun 2025 09:06:34 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 55590M3Z024899;
	Thu, 5 Jun 2025 09:06:33 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 470dkmkx2j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 05 Jun 2025 09:06:33 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 55596TAt48300326
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 5 Jun 2025 09:06:29 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9F3F120040;
	Thu,  5 Jun 2025 09:06:29 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4F6E72004D;
	Thu,  5 Jun 2025 09:06:29 +0000 (GMT)
Received: from [9.152.224.132] (unknown [9.152.224.132])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  5 Jun 2025 09:06:29 +0000 (GMT)
Message-ID: <408922a2-ec1a-4e60-841a-90714a3310de@linux.ibm.com>
Date: Thu, 5 Jun 2025 11:06:29 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] s390/mm: Fix in_atomic() handling in
 do_secure_storage_access()
To: Alexander Gordeev <agordeev@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>, Janosch Frank
 <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Sven Schnelle <svens@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20250603134936.1314139-1-hca@linux.ibm.com>
 <aEB0BfLG9yM3Gb4u@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
 <20250604184855.44793208@p-imbrenda>
 <aECCe9bIZORv+yef@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
 <20250604194043.0ab9535e@p-imbrenda>
 <aEFdoYSKqvqK572c@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
Content-Language: en-US
From: Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <aEFdoYSKqvqK572c@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=Pq2TbxM3 c=1 sm=1 tr=0 ts=68415e1a cx=c_pps a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=VnNF1IyMAAAA:8 a=qs_iwHwmzb1svy77jOgA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjA1MDA3OSBTYWx0ZWRfX56Aaz+6lp1sS mEOeYxehi2DphEuBbod0dYjowDACQZs7aQhdxpa8L0SpbLAby6DJJH9bbvZpKYAhh7P1MYha9Da sBrslJ+UFNr8nstx/WIOK/tYEmzIoZnpq142SUt3RBDM92Ae4i5ow7edrvUM+Sz28VNK5ZOqG+Q
 +LNgw00V67U/f4VUYp4Jn2dyfnC7yu9XmG/DQWbebkxwmrTNd1he5L7OG+63Ft/qVjahuhg6SJ9 jdF7Z+ku0UemEYPOFKNcLacnSM3n75o/8Pne2ElgTvwyFzMvzqzmcDzDjQRYAy1gCFFG2xQpDt0 e5zT8U1heI70tEGbwwBHyAdgTAWW3xVZGWRvIzfTv/ZskxOS4nbZn2BMNTbwbamC6CIP0FO/jgL
 M0c1JVOZzUbBE8uzDnI1Hyf5wEJ90botszjcGy+reLfXkDBFMiLi8M1kg5oeE0C7vDiaASJp
X-Proofpoint-GUID: RjIhY-TYWY2ygrrA15FlHV_osAC84UCg
X-Proofpoint-ORIG-GUID: RjIhY-TYWY2ygrrA15FlHV_osAC84UCg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-05_02,2025-06-03_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 clxscore=1015 malwarescore=0 mlxlogscore=703
 phishscore=0 bulkscore=0 spamscore=0 suspectscore=0 priorityscore=1501
 mlxscore=0 adultscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2506050079

Am 05.06.25 um 11:04 schrieb Alexander Gordeev:
> On Wed, Jun 04, 2025 at 07:40:43PM +0200, Claudio Imbrenda wrote:
>>>>> This could trigger WARN_ON_ONCE() in handle_fault_error_nolock():
>>>>>
>>>>> 		if (WARN_ON_ONCE(!si_code))
>>>>> 			si_code = SEGV_MAPERR;
>>>>>
>>>>> Would this warning be justified in this case (aka user_mode(regs) ==
>>>>> true)?
>>>>
>>>> I think so, because if we are in usermode, we should never trigger
>>>> faulthandler_disabled()
>>>
>>> I think I do not get you. We are in a system call and also in_atomic(),
>>> so faulthandler_disabled() is true and handle_fault_error_nolock(regs, 0)
>>> is called (above).
>>
>> what is the psw in regs?
>> is it not the one that was being used when the exception was triggered?
> 
> Hmm, right. I assume is_kernel_fault() returns false not because
> user_mode(regs) is true, but because we access the secondary AS.
> 
> Still, to me it feels wrong to trigger that warning due to a user
> process activity. But anyway:
> 
> Acked-by: Alexander Gordeev <agordeev@linux.ibm.com>

Can we trigger a WARN from userspace?

