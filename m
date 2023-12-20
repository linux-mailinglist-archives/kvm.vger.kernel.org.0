Return-Path: <kvm+bounces-4912-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 34B49819BD4
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 10:56:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C8F5BB20340
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 09:56:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55F572033A;
	Wed, 20 Dec 2023 09:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="B1/WCZSa"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 779C21F616;
	Wed, 20 Dec 2023 09:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3BK8Cf66014296;
	Wed, 20 Dec 2023 09:56:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=C17ZtDNNWsK1aq9JjnwX7tEGI6cd5ViNpeHPvoDQj3E=;
 b=B1/WCZSacF45dCa32wdOiKQrR4UThxEkjiqR9tcXOcOqi9VmlOfH7Opjii8YYbprY5BK
 RYFduNvKXd1DRedLmeTPULP+ZkJZzdnBIuRp63KUvsLkISwJqbxVLwG9sKEXVvABgqYI
 0jDR+gqconn+L13vRnysscQItvSGYv88XGe8lgph5I+rqPkoUK3qMI4l6dCpSObJzA7V
 zYPE3Ydq37eJkz/zORECCXka+KvUxTKMzVtvoh7uBD6pwVRNbcuMiRrorIJy2ef9FUh5
 cPHB2Dp9gCtPpp3SvkpZr+OyyMwlNX+PqwhUd2barrVG5ddIbmyo9XxUiDrZbRFHnqaA 0A== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3v3vjctdh7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 20 Dec 2023 09:56:22 +0000
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3BK9YNk9015619;
	Wed, 20 Dec 2023 09:56:22 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3v3vjctdgt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 20 Dec 2023 09:56:22 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3BK6rS39029726;
	Wed, 20 Dec 2023 09:56:21 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3v1p7snurb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 20 Dec 2023 09:56:21 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3BK9uIE137749338
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 Dec 2023 09:56:18 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 85D6C2004B;
	Wed, 20 Dec 2023 09:56:18 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D9A2920043;
	Wed, 20 Dec 2023 09:56:17 +0000 (GMT)
Received: from [9.171.71.20] (unknown [9.171.71.20])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 20 Dec 2023 09:56:17 +0000 (GMT)
Message-ID: <adaa7efe-b5f7-450b-8dd9-312cefa8fce3@linux.ibm.com>
Date: Wed, 20 Dec 2023 10:56:17 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/4] KVM: s390: vsie: Fix STFLE interpretive execution
 identification
To: Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens
 <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>
Cc: David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Sven Schnelle <svens@linux.ibm.com>,
        linux-s390@vger.kernel.org
References: <20231219140854.1042599-1-nsg@linux.ibm.com>
 <20231219140854.1042599-2-nsg@linux.ibm.com>
Content-Language: en-US
From: Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20231219140854.1042599-2-nsg@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Zjz3AkNrnVzkl0TyS2yhk3SH93jduN7v
X-Proofpoint-ORIG-GUID: g-UQ3RHgLfFT7g9FHACBy5bS1Ms86Kbn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-20_02,2023-12-14_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 mlxlogscore=999 spamscore=0 mlxscore=0 impostorscore=0 phishscore=0
 malwarescore=0 clxscore=1015 suspectscore=0 priorityscore=1501
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2312200069

Am 19.12.23 um 15:08 schrieb Nina Schoetterl-Glausch:
> STFLE can be interpretively executed.
> This occurs when the facility list designation is unequal to zero.
> Perform the check before applying the address mask instead of after.
> 
> Fixes: 66b630d5b7f2 ("KVM: s390: vsie: support STFLE interpretation")
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Acked-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>

Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>

this should not matter in reality but maybe some weird guests puts this at address 0.
Do we want a unit test for that case?

> ---
>   arch/s390/kvm/vsie.c | 7 ++++++-
>   1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
> index 8207a892bbe2..35937911724e 100644
> --- a/arch/s390/kvm/vsie.c
> +++ b/arch/s390/kvm/vsie.c
> @@ -984,10 +984,15 @@ static void retry_vsie_icpt(struct vsie_page *vsie_page)
>   static int handle_stfle(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
>   {
>   	struct kvm_s390_sie_block *scb_s = &vsie_page->scb_s;
> -	__u32 fac = READ_ONCE(vsie_page->scb_o->fac) & 0x7ffffff8U;
> +	__u32 fac = READ_ONCE(vsie_page->scb_o->fac);
>   
>   	if (fac && test_kvm_facility(vcpu->kvm, 7)) {
>   		retry_vsie_icpt(vsie_page);
> +		/*
> +		 * The facility list origin (FLO) is in bits 1 - 28 of the FLD
> +		 * so we need to mask here before reading.
> +		 */
> +		fac = fac & 0x7ffffff8U;
>   		if (read_guest_real(vcpu, fac, &vsie_page->fac,
>   				    sizeof(vsie_page->fac)))
>   			return set_validity_icpt(scb_s, 0x1090U);

