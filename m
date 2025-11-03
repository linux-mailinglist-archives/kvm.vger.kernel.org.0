Return-Path: <kvm+bounces-61838-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 30CF2C2C4F5
	for <lists+kvm@lfdr.de>; Mon, 03 Nov 2025 15:03:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5E5263B53DC
	for <lists+kvm@lfdr.de>; Mon,  3 Nov 2025 13:57:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B7F730FC36;
	Mon,  3 Nov 2025 13:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Quo3Zi33"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0BEA272801;
	Mon,  3 Nov 2025 13:57:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762178238; cv=none; b=sKijV0ibNQge2o/bSCa1mhcr1C0ZkucVp7CdRQyRhsOF8psummz06TIgZnfLILG7JRkgmqb/GhwtjmUKxsjYci8DfaEHgWtSiSqbh/0QFxpVsUo7XAn1s4lb4uoSHr0F4HjylwDA3pLGQRI7QIpCb+1ScwvDY02rvzSNNYMi+Go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762178238; c=relaxed/simple;
	bh=dmuCSoXsWA67MHrMwGljQnYI38XqRGL0mGCYFPa12vs=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BQNvWXUbnwumZoTIGQUCKIdlFdf/2bIXZ5dp/r0J4l/mBkRcUM02h9gy+pCDeIlCNez0Swu2yZrAuDUN8tO0dKsbCuCPwupgbwTomB9DScMc5pM5lTWHxLTdsvvbQqC9bcxDMM8Qqu97/+uQ8qnr5RRKrqBV3cKUqKYktUuFjis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Quo3Zi33; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A2NRAWZ000721;
	Mon, 3 Nov 2025 13:57:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=Uf+L0I
	V5cKSot6eg8qSFRsqxaQWRBD8fodh++a7vdek=; b=Quo3Zi33kscBb5B5DQYuZM
	wJUlIKVCT2OQeZXOowMf64dWHoGam+MUo+qD5cvwX7VDRHSOpUAREqH1TzvpeI1F
	UGBlBx/UdBIxtER+BzOi8GjjjzaxiYO2iEpPcL6C0WctWePzZnv46zgpqJH0xA8R
	D+ict8bBSQ3xPxcGizzvi3mX+QVlZPTFfMGqDc01MJVtGx0PZi8bw3r6IYShfIm5
	akI9RrE2RNRzz/+XkBx6aIH0ML3RYJvrhqc/mQkJs1H79FXalsuJxhBYlwTrpwga
	fICMsxqadQkEMvEbHiOCikM6tTq4mp+nOyAxyxEadutclwFzm3Wds8Lv7zRWcrEA
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a59vu6tn8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Nov 2025 13:57:14 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 5A3DmTTd027021;
	Mon, 3 Nov 2025 13:57:14 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a59vu6tn4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Nov 2025 13:57:13 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5A3C4e6e021471;
	Mon, 3 Nov 2025 13:57:13 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4a5xrjdq6x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Nov 2025 13:57:12 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5A3Dv9qC51249502
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 3 Nov 2025 13:57:09 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1FC2120043;
	Mon,  3 Nov 2025 13:57:09 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4F48520040;
	Mon,  3 Nov 2025 13:57:08 +0000 (GMT)
Received: from p-imbrenda (unknown [9.87.133.247])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with SMTP;
	Mon,  3 Nov 2025 13:57:08 +0000 (GMT)
Date: Mon, 3 Nov 2025 14:57:06 +0100
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Markus Elfring <Markus.Elfring@web.de>
Cc: linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        Alexander Gordeev
 <agordeev@linux.ibm.com>,
        Christian =?UTF-8?B?Qm9ybnRyw6RnZXI=?=
 <borntraeger@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Gerald
 =?UTF-8?B?U2Now6RmZXI=?= <gerald.schaefer@linux.ibm.com>,
        Heiko Carstens
 <hca@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Sven Schnelle
 <svens@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        LKML
 <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Miaoqian
 Lin <linmq006@gmail.com>
Subject: Re: [PATCH] s390/mm: Use pointer from memcpy() call for assignment
 in s390_replace_asce()
Message-ID: <20251103145706.2a419ad6@p-imbrenda>
In-Reply-To: <f488454a-0a0c-4726-b387-451f3c608165@web.de>
References: <f488454a-0a0c-4726-b387-451f3c608165@web.de>
Organization: IBM
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.49; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: KxvWcMLFA8nT0XP7PtY3bd7wf37vYB2k
X-Proofpoint-GUID: uTmyjg_eGkJxSJazDNOBCUzF0V9VHp0w
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTAxMDAyMSBTYWx0ZWRfXwNzdnp0+0j4g
 yxUGzbRZFhJf+R6okn/4A9jX/QYaLc+T6S6IHPu4ezvkzQl7Cm0iSMY0lYl0H3X4i2bwJc+Tile
 INNqJiqp/e0ARUSP3YPyjf+VPZvY2VBE+o4NijnBoVdTsbv1LC92G1nfOOHFz7/wUzXvihc4ezI
 +VMG3ClOj3+j27XGY0vM2HOlLA2lM92Yjj0D167Vv5cRrpvKVvBiakkeHPpIcd61Dhac9pYCKgZ
 XMzhCCddZqc4YMwxL35VHPEwou1ieDzrPhVDbQeeEJoFn/FuosjiLKUr4pwivyFJZd15TFYu2me
 ApK+EFa//xrUSstpYtGzlHJYHgkiSDIWxXjm+drDA0hUrk3ApyrpBjG0wei1I6uHRmksF27Ye/2
 JC5yrwm8ohWS3maCcFUWkthEPnkjgQ==
X-Authority-Analysis: v=2.4 cv=U6qfzOru c=1 sm=1 tr=0 ts=6908b4ba cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=kj9zAlcOel0A:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=FP58Ms26AAAA:8 a=i7YI89PhWf-mWEaAo1gA:9 a=CjuIK1q_8ugA:10
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-03_02,2025-11-03_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 adultscore=0 impostorscore=0 spamscore=0 phishscore=0
 clxscore=1011 malwarescore=0 lowpriorityscore=0 suspectscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2510240000
 definitions=main-2511010021

On Fri, 31 Oct 2025 08:22:30 +0100
Markus Elfring <Markus.Elfring@web.de> wrote:

> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Fri, 31 Oct 2025 07:56:06 +0100
> 
> A pointer was assigned to a variable. The same pointer was used for
> the destination parameter of a memcpy() call.
> This function is documented in the way that the same value is returned.
> Thus convert two separate statements into a direct variable assignment for
> the return value from a memory copy action.
> 
> The source code was transformed by using the Coccinelle software.
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>  arch/s390/mm/gmap.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
> index 22c448b32340..e49e839933f1 100644
> --- a/arch/s390/mm/gmap.c
> +++ b/arch/s390/mm/gmap.c
> @@ -2440,8 +2440,8 @@ int s390_replace_asce(struct gmap *gmap)
>  	page = gmap_alloc_crst();
>  	if (!page)
>  		return -ENOMEM;
> -	table = page_to_virt(page);
> -	memcpy(table, gmap->table, 1UL << (CRST_ALLOC_ORDER + PAGE_SHIFT));
> +
> +	table = memcpy(page_to_virt(page), gmap->table, 1UL << (CRST_ALLOC_ORDER + PAGE_SHIFT));
>  
>  	/* Set new table origin while preserving existing ASCE control bits */
>  	asce = (gmap->asce & ~_ASCE_ORIGIN) | __pa(table);

NACK

1) the change makes the code less readable / understandable
2) mm/gmap.c is going away soon

