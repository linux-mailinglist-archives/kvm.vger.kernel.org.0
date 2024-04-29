Return-Path: <kvm+bounces-16186-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E6988B612A
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2024 20:34:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 87BE11C219EE
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2024 18:34:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A1AB12A15B;
	Mon, 29 Apr 2024 18:33:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="dpg+JCAn"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C288C83CBA;
	Mon, 29 Apr 2024 18:33:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714415631; cv=none; b=s/2fahBaOHZiZIXJFKKeb5uRd2QUSQpBT+nCB6mI9Pe/K6dQm5+g8tzEf7TysWo9yM0oGkjmF2DcVsNP2UDxaGQvDdfraeoVe9H1DggGfO6tzmsPA3NTgcE/Z7kifEo8YTWJNC75+3aie1NtKCKAENouncmMDNF3Hq7ww8bPjG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714415631; c=relaxed/simple;
	bh=GZHC88BVTwBCrjrEU6F9yViISGylF0nVvze26vl3cq4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BSBGTCWkGHvKgdIjR7q/gfX0qw9ohPSfJ4Jcob787sIEuRcO9aKrEZ/mvoY5zA+Bm3r114SIxwEg9nFkkys138OHU0l/17bFg3mqdD3xojkkF1NvWRPxJPP/2EIk5B8vxwgn5UYzF1L4orM0/HLsQ3JF6ExXLfz37m1S5mQrJPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=dpg+JCAn; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43TIXlss015294;
	Mon, 29 Apr 2024 18:33:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=H4I8e41/l8uB3Hyx06Bhk4DnM+0xnAu6yljLBAjxOq8=;
 b=dpg+JCAnsP0BiULl4spKXDzvC0EGMvlA1F45PWZvjGHRbwAH9YIs6p/M71h+qih66XQx
 tgX5nQA+6jzhJO2knCyeEdUloe0xMrI12TCi0xh3PNjTFV0mijHdlzcAKJNhzdTJVJ4g
 VTadfVwDEOT5eh8V5LHo2gAPwAXkzyRsX6rqms6JTA+HAjvtrgAGwFesjyZoC+mU5LzE
 YjTDnWEWCezg3OagMlIqeeRJzHv67zzu1alrYAnJ1hj89ZE0CRzVylW6M888qCzB6yob
 cWQkHVG2iAhTOL77UpXqgKgkx9da4IxFj3XzFWsnOrSLEnJtAvRMWhydKfh4UkjokTSd 0Q== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xtgseg0u7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 29 Apr 2024 18:33:47 +0000
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 43TIXkvb015204;
	Mon, 29 Apr 2024 18:33:46 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xtgseg0t9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 29 Apr 2024 18:33:46 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 43TI5UIZ002989;
	Mon, 29 Apr 2024 18:32:49 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3xscpp8ve5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 29 Apr 2024 18:32:48 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 43TIWjZT45023634
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 29 Apr 2024 18:32:47 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E6D132004B;
	Mon, 29 Apr 2024 18:32:44 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 491632007D;
	Mon, 29 Apr 2024 18:32:44 +0000 (GMT)
Received: from [9.179.12.126] (unknown [9.179.12.126])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 29 Apr 2024 18:32:44 +0000 (GMT)
Message-ID: <2f046603-ae89-4ad2-95df-8e187501e06d@linux.ibm.com>
Date: Mon, 29 Apr 2024 20:32:43 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] s390/kvm/vsie: Use virt_to_phys for crypto control block
To: Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>
Cc: David Hildenbrand <david@redhat.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Sven Schnelle <svens@linux.ibm.com>
References: <20240429171512.879215-1-nsg@linux.ibm.com>
Content-Language: en-US
From: Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20240429171512.879215-1-nsg@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: QQ92b6CKSJI40klk5fSh85R5vsMD_YkQ
X-Proofpoint-ORIG-GUID: VQ81qEtSuObAP9dr3zNDjJwJmKd2TUZy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-04-29_16,2024-04-29_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 priorityscore=1501 mlxlogscore=999 lowpriorityscore=0 mlxscore=0
 malwarescore=0 phishscore=0 impostorscore=0 adultscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404290120

Am 29.04.24 um 19:15 schrieb Nina Schoetterl-Glausch:
> The address of the crypto control block in the (shadow) SIE block is
> absolute/physical.
> Convert from virtual to physical when shadowing the guest's control
> block during VSIE.
> 
> Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>

vsie_page was created with page_to_virt to this make sense to translated back here.

Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>

I guess this should go via the s390 with the other virt/phys changes.

> ---
>   arch/s390/kvm/vsie.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
> index b2c9f010f0fe..24defeada00c 100644
> --- a/arch/s390/kvm/vsie.c
> +++ b/arch/s390/kvm/vsie.c
> @@ -361,7 +361,7 @@ static int shadow_crycb(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
>   	case -EACCES:
>   		return set_validity_icpt(scb_s, 0x003CU);
>   	}
> -	scb_s->crycbd = ((__u32)(__u64) &vsie_page->crycb) | CRYCB_FORMAT2;
> +	scb_s->crycbd = (u32)virt_to_phys(&vsie_page->crycb) | CRYCB_FORMAT2;
>   	return 0;
>   }

