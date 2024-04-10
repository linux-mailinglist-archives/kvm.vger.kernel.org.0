Return-Path: <kvm+bounces-14147-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 35FE289FEDE
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 19:45:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E47F1282EA2
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 17:45:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 503AB180A6F;
	Wed, 10 Apr 2024 17:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="AvdRggsv"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E7AF17F372;
	Wed, 10 Apr 2024 17:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712771099; cv=none; b=c1LLnNXL0LpNwv0xzfLjz6jTzr/s9B5dUvi1pVx/O6LyeXfypKOpztXgpR0S1B+8i5hkTOqGigbhEm84nJiT9gD7omniOtq7cfMXqryl5gI8XpriimcEAy7tRiqqLeQgUWYVDk62ZVPHxKa9i5AVQz/LGBuyI4dRT3wg/qo2Rlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712771099; c=relaxed/simple;
	bh=zd72EbgmhFsdvxrkydv/54uHUjTmye/iH4W+WqdNsUE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R6ZHA683a57UdRuopwier3g978ep3bG4ARz8F8u1LnXAq7+C7/4SmpBwtitMo0FuCEADLWR3ci4wqDGdv9rnmVFK8hkeD78XTZs7hLYKUcL3XcHrw1nzsdgXPwddb13ULODIGdnVM5UsH5yJLgryo8HrSykKJjHXp4y8ncgxq+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=AvdRggsv; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43AHWfCE027558;
	Wed, 10 Apr 2024 17:44:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=lnjnE8ATros47CvItPMr0cyRhNnNvF8qFBKBUXO4nZg=;
 b=AvdRggsvVtfgVMcGf1LWwC2cpuVNYpVhS/VYxYE9Sa3p4sFXBVjl7jzeNO6F073J9Nvo
 U/omTieaaEzZ9iD3ZCm0neCWSCfXvA0GzxtoIiqcdGK3gHAZLspWVEuHytY3J84MjoQx
 ayRhg5ymc0FZxffaz06ZSdk85D+tGzbMpnhl3pXD5WzkMUuS61HR3k5zobEiiTXr4mfE
 aPExz9a/LEYnpzV0AquFSh0M+E6qN0Qzcuh8zIdM9fBKiFEglM8nF8UGdhj9tkRd9+95
 UdHJ6D3BsaA9Mo+udUJFIPIVi7kU1CZa9KrIfl8ncgejC8UTn5EWJywBiOQoXslw55Zk ng== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xdy8j00rf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 Apr 2024 17:44:42 +0000
Received: from m0353727.ppops.net (m0353727.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 43AHige7011949;
	Wed, 10 Apr 2024 17:44:42 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xdy8j00ra-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 Apr 2024 17:44:41 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 43AH29f6029904;
	Wed, 10 Apr 2024 17:44:40 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3xbj7me5h5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 Apr 2024 17:44:40 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 43AHiZpp50856364
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Apr 2024 17:44:37 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EC8DD20043;
	Wed, 10 Apr 2024 17:44:34 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B400C20040;
	Wed, 10 Apr 2024 17:44:34 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 10 Apr 2024 17:44:34 +0000 (GMT)
Date: Wed, 10 Apr 2024 19:19:44 +0200
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        Matthew Wilcox
 <willy@infradead.org>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik
 <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian
 Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle
 <svens@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Gerald
 Schaefer <gerald.schaefer@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH v1 4/5] s390/uv: update PG_arch_1 comment
Message-ID: <20240410191944.72c84b2e@p-imbrenda>
In-Reply-To: <20240404163642.1125529-5-david@redhat.com>
References: <20240404163642.1125529-1-david@redhat.com>
	<20240404163642.1125529-5-david@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 8zhlPPNcuaeSlcywV_RLHDG0nrUNh0XR
X-Proofpoint-GUID: 53w3kbTBb5T7QS82YxhvL0E5DyEKQP8o
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-10_04,2024-04-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 mlxscore=0
 adultscore=0 priorityscore=1501 bulkscore=0 malwarescore=0 spamscore=0
 phishscore=0 suspectscore=0 mlxlogscore=907 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404100130

On Thu,  4 Apr 2024 18:36:41 +0200
David Hildenbrand <david@redhat.com> wrote:

> We removed the usage of PG_arch_1 for page tables in commit
> a51324c430db ("s390/cmma: rework no-dat handling").
> 
> Let's update the comment in UV to reflect that.
> 
> Signed-off-by: David Hildenbrand <david@redhat.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  arch/s390/kernel/uv.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
> index 9c0113b26735..76fc61333fae 100644
> --- a/arch/s390/kernel/uv.c
> +++ b/arch/s390/kernel/uv.c
> @@ -471,13 +471,12 @@ int arch_make_page_accessible(struct page *page)
>  		return 0;
>  
>  	/*
> -	 * PG_arch_1 is used in 3 places:
> -	 * 1. for kernel page tables during early boot
> -	 * 2. for storage keys of huge pages and KVM
> -	 * 3. As an indication that this small folio might be secure. This can
> +	 * PG_arch_1 is used in 2 places:
> +	 * 1. for storage keys of hugetlb folios and KVM
> +	 * 2. As an indication that this small folio might be secure. This can
>  	 *    overindicate, e.g. we set the bit before calling
>  	 *    convert_to_secure.
> -	 * As secure pages are never huge, all 3 variants can co-exists.
> +	 * As secure pages are never large folios, both variants can co-exists.
>  	 */
>  	if (!test_bit(PG_arch_1, &folio->flags))
>  		return 0;


