Return-Path: <kvm+bounces-16886-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E1028BE955
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 18:40:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8A810292224
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 16:40:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 991B917554D;
	Tue,  7 May 2024 16:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="G9VhPaYv"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E6DF16D324;
	Tue,  7 May 2024 16:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715099708; cv=none; b=PU/WDqv6mTei5ru2FcWihbahFLUkA3t4SOL19n+kmegFlhGn6UQVfBdFk+1KKwK4PS+UeLZGviEGcgQneH3A1jKghpKayb6XSYH3drerA5lnCjCDeM6v7VbZVS5Mo5NuLss1bHg0P5NloWtCv56yO+Nha7aHY7CNfdVm55gBFrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715099708; c=relaxed/simple;
	bh=NjDWS2e4urHOZKxzJetAdtuFJD2CgyrBwJ5bZQD66To=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dDCTJ9WoWW9CipGMl+xAnCSSTm+93ayyMdbsEtN5jYFkfLsiTHK4kE3KyfJSTW2MiB2YrzP/7ekgrdr4FzJzefzESt0UN9qRWUVfm5BjuaxKjTy72NFuwsW6GH1ZZteAthXtq2QrvfCZJdsvtEcmC+oZAJiBJ4NxT655W67e33g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=G9VhPaYv; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 447GOPG4001337;
	Tue, 7 May 2024 16:35:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=Vef/B1jTE04cYAPD3j1lZ9mGWWo9zBLDBTYaEHdtAhw=;
 b=G9VhPaYvWhD5qO3TKy0IS3BGTNT5As6lu+HA3X9X49CxR6iEAIPQqawWv6rODK6qT71F
 gISOhzTc4hWp1qSWjcOQ+A5oTjzObI2BjDUiPIr5M0K5fzFCZjDNydM2TnEg9dc8Og5U
 x12dq2fmVB5QxiQRPbEL6FQG+S1UNRAsB9KI+/X6jIh0fyrc7KUq8wVpgqgF4/G7gVpm
 2EG0O095rv4rizF3VF7KLPrfFJ9uBKd/UUivP8Df+uGQiXSJmN5rG/kJgDnPPPGGe7wI
 zX9OMN/VNXrIroHsOK+L0ttJMXYWymBA+hfsUSeOfYw/n7HuRNxeVtS1cNQHRYOGG08Z qA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xyqpv012g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 May 2024 16:35:03 +0000
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 447GZ3Pi019449;
	Tue, 7 May 2024 16:35:03 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xyqpv012c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 May 2024 16:35:03 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 447EZ7Qs030920;
	Tue, 7 May 2024 16:35:02 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3xwybtyj37-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 May 2024 16:35:02 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 447GYubk53543318
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 7 May 2024 16:34:59 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DC77D2004F;
	Tue,  7 May 2024 16:34:56 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9E92C20040;
	Tue,  7 May 2024 16:34:56 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  7 May 2024 16:34:56 +0000 (GMT)
Date: Tue, 7 May 2024 18:33:07 +0200
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Vasily
 Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle
 <svens@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Gerald
 Schaefer <gerald.schaefer@linux.ibm.com>,
        Matthew Wilcox
 <willy@infradead.org>, Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH v2 10/10] s390/hugetlb: convert PG_arch_1 code to work
 on folio->flags
Message-ID: <20240507183307.3336dabc@p-imbrenda.boeblingen.de.ibm.com>
In-Reply-To: <20240412142120.220087-11-david@redhat.com>
References: <20240412142120.220087-1-david@redhat.com>
	<20240412142120.220087-11-david@redhat.com>
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
X-Proofpoint-GUID: Iiz6veNj8m8Ui57Lj9a9hJIPjnkuk3__
X-Proofpoint-ORIG-GUID: VrB8HqYh09u_Zqzs8sklBI0m0zW6Z4Un
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-07_10,2024-05-06_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 mlxscore=0 spamscore=0 suspectscore=0 mlxlogscore=999
 lowpriorityscore=0 clxscore=1015 priorityscore=1501 adultscore=0
 phishscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2405070113

On Fri, 12 Apr 2024 16:21:20 +0200
David Hildenbrand <david@redhat.com> wrote:

> Let's make it clearer that we are always working on folio flags and
> never page flags of tail pages.

please be a little more verbose, and explain what you are doing (i.e.
converting usages of page flags to folio flags), not just why.

> 
> Signed-off-by: David Hildenbrand <david@redhat.com>

with a few extra words in the description:

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  arch/s390/mm/gmap.c        | 4 ++--
>  arch/s390/mm/hugetlbpage.c | 8 ++++----
>  2 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
> index 0351cb139df4..9eea05cd93b7 100644
> --- a/arch/s390/mm/gmap.c
> +++ b/arch/s390/mm/gmap.c
> @@ -2648,7 +2648,7 @@ static int __s390_enable_skey_hugetlb(pte_t *pte, unsigned long addr,
>  {
>  	pmd_t *pmd = (pmd_t *)pte;
>  	unsigned long start, end;
> -	struct page *page = pmd_page(*pmd);
> +	struct folio *folio = page_folio(pmd_page(*pmd));
>  
>  	/*
>  	 * The write check makes sure we do not set a key on shared
> @@ -2663,7 +2663,7 @@ static int __s390_enable_skey_hugetlb(pte_t *pte, unsigned long addr,
>  	start = pmd_val(*pmd) & HPAGE_MASK;
>  	end = start + HPAGE_SIZE - 1;
>  	__storage_key_init_range(start, end);
> -	set_bit(PG_arch_1, &page->flags);
> +	set_bit(PG_arch_1, &folio->flags);
>  	cond_resched();
>  	return 0;
>  }
> diff --git a/arch/s390/mm/hugetlbpage.c b/arch/s390/mm/hugetlbpage.c
> index c2e8242bd15d..a32047315f9a 100644
> --- a/arch/s390/mm/hugetlbpage.c
> +++ b/arch/s390/mm/hugetlbpage.c
> @@ -121,7 +121,7 @@ static inline pte_t __rste_to_pte(unsigned long rste)
>  
>  static void clear_huge_pte_skeys(struct mm_struct *mm, unsigned long rste)
>  {
> -	struct page *page;
> +	struct folio *folio;
>  	unsigned long size, paddr;
>  
>  	if (!mm_uses_skeys(mm) ||
> @@ -129,16 +129,16 @@ static void clear_huge_pte_skeys(struct mm_struct *mm, unsigned long rste)
>  		return;
>  
>  	if ((rste & _REGION_ENTRY_TYPE_MASK) == _REGION_ENTRY_TYPE_R3) {
> -		page = pud_page(__pud(rste));
> +		folio = page_folio(pud_page(__pud(rste)));
>  		size = PUD_SIZE;
>  		paddr = rste & PUD_MASK;
>  	} else {
> -		page = pmd_page(__pmd(rste));
> +		folio = page_folio(pmd_page(__pmd(rste)));
>  		size = PMD_SIZE;
>  		paddr = rste & PMD_MASK;
>  	}
>  
> -	if (!test_and_set_bit(PG_arch_1, &page->flags))
> +	if (!test_and_set_bit(PG_arch_1, &folio->flags))
>  		__storage_key_init_range(paddr, paddr + size - 1);
>  }
>  


