Return-Path: <kvm+bounces-14148-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4132289FEE4
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 19:46:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5F72B1C22B5C
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 17:45:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B8C7181325;
	Wed, 10 Apr 2024 17:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="cQyhRkTI"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4873A17F379;
	Wed, 10 Apr 2024 17:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712771100; cv=none; b=gNtlKRSa1DqrVxxYYxgSm6YWkHnap30JuBQYtQ2h6bWYtNOEuqqPtMzF33WlNMYgVY9Y4mVsPVILpD+zM9KQEUxm0pnbJeq+OrpNR/JbsfB7gs6ROdqFgRz8YU/gcNKdGa28+VwziS+PmqQSaQ9S91FSwciVUlXjrBKPGtvkTdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712771100; c=relaxed/simple;
	bh=tU0llIrllZGBRBSavOUUBkfUfb8QI63nj9aOBMcJOj4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JOvkR3AJ14DlHeGHnmZULlMY+3ohoFvydYKrUbkX1/oQA6+j4Tu4vdTxK6/VxZSBjcm9Hj/QbM6MgQfdh4SsVU46I1tx8zaSFl3n+47zZFYpiuFHWrbHbUG6dpiJMqjKDhzw7zXKMVaxt7xdyDfngqQs0NPj88CXOmtxwDJcmps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=cQyhRkTI; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43AHVgZG007470;
	Wed, 10 Apr 2024 17:44:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=isCwm2VVj9IIusgK5+U+9pg2r2c/kDAQFXY6w8ShkCo=;
 b=cQyhRkTIl4/qjhddQzjTxEMo4+0zNfE/pYfoBe4duwiQM3YX0MM3wh4+fX3V2x4G2sGk
 rI5sq25FyKI/19HBz9K4CxvOHy8HTyW4DMcl0QroHMJfRi/+dxRfusOKHwGEiyCS5Dqh
 cWgRC/xIyRmRY1G6dDXwx8HbmsBiPYl094ARqFspKKeKPKXHat6tlY/3lz51tQYlThGk
 p6ZAFpiO0EC4dVcVRkvYivrcWjEKSjz6noBSleZi084mMoTS/pOvz2gB6kZPUzN/Nhts
 XA4RBIagt349h3W3X1jfaeq1fyoo2Cmtgb+MFo2nCwM6JHr6L1WFpBfCHniycPphxx8l og== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xdy1tr1xs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 Apr 2024 17:44:44 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 43AHii2d029421;
	Wed, 10 Apr 2024 17:44:44 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xdy1tr1xn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 Apr 2024 17:44:44 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 43AFK6e1017031;
	Wed, 10 Apr 2024 17:44:43 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3xbke2nuf3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 Apr 2024 17:44:43 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 43AHibNo53150022
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Apr 2024 17:44:40 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D948620043;
	Wed, 10 Apr 2024 17:44:37 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AAFD920040;
	Wed, 10 Apr 2024 17:44:37 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 10 Apr 2024 17:44:37 +0000 (GMT)
Date: Wed, 10 Apr 2024 19:42:36 +0200
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
Subject: Re: [PATCH v1 3/5] s390/uv: convert PG_arch_1 users to only work on
 small folios
Message-ID: <20240410194236.1c89eb7d@p-imbrenda>
In-Reply-To: <20240404163642.1125529-4-david@redhat.com>
References: <20240404163642.1125529-1-david@redhat.com>
	<20240404163642.1125529-4-david@redhat.com>
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
X-Proofpoint-GUID: hz7Bxbv-xN-ZtiKpIDAhRT2UsI1w_po4
X-Proofpoint-ORIG-GUID: -P0lAWXIohdv_lozvSe4QhK7TZVjsEOR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-10_04,2024-04-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 spamscore=0
 malwarescore=0 bulkscore=0 phishscore=0 priorityscore=1501 suspectscore=0
 mlxlogscore=999 adultscore=0 impostorscore=0 mlxscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2404010000
 definitions=main-2404100130

On Thu,  4 Apr 2024 18:36:40 +0200
David Hildenbrand <david@redhat.com> wrote:

> Now that make_folio_secure() may only set PG_arch_1 for small folios,
> let's convert relevant remaining UV code to only work on (small) folios
> and simply reject large folios early. This way, we'll never end up
> touching PG_arch_1 on tail pages of a large folio in UV code.
> 
> The folio_get()/folio_put() for functions that are documented to already
> hold a folio reference look weird and it should probably be removed.
> Similarly, uv_destroy_owned_page() and uv_convert_owned_from_secure()
> should really consume a folio reference instead. But these are cleanups for
> another day.
> 
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>  arch/s390/include/asm/page.h |  1 +
>  arch/s390/kernel/uv.c        | 39 +++++++++++++++++++++---------------
>  2 files changed, 24 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/s390/include/asm/page.h b/arch/s390/include/asm/page.h
> index 54d015bcd8e3..b64384872c0f 100644
> --- a/arch/s390/include/asm/page.h
> +++ b/arch/s390/include/asm/page.h
> @@ -214,6 +214,7 @@ static inline unsigned long __phys_addr(unsigned long x, bool is_31bit)
>  #define pfn_to_phys(pfn)	((pfn) << PAGE_SHIFT)
>  
>  #define phys_to_page(phys)	pfn_to_page(phys_to_pfn(phys))
> +#define phys_to_folio(phys)	page_folio(phys_to_page(phys))
>  #define page_to_phys(page)	pfn_to_phys(page_to_pfn(page))
>  #define folio_to_phys(page)	pfn_to_phys(folio_pfn(folio))
>  
> diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
> index adcbd4b13035..9c0113b26735 100644
> --- a/arch/s390/kernel/uv.c
> +++ b/arch/s390/kernel/uv.c
> @@ -134,14 +134,17 @@ static int uv_destroy_page(unsigned long paddr)
>   */
>  int uv_destroy_owned_page(unsigned long paddr)
>  {
> -	struct page *page = phys_to_page(paddr);
> +	struct folio *folio = phys_to_folio(paddr);
>  	int rc;
>  
> -	get_page(page);
> +	if (unlikely(folio_test_large(folio)))
> +		return 0;

please add a comment here to explain why it's ok to just return 0
here...

> +
> +	folio_get(folio);
>  	rc = uv_destroy_page(paddr);
>  	if (!rc)
> -		clear_bit(PG_arch_1, &page->flags);
> -	put_page(page);
> +		clear_bit(PG_arch_1, &folio->flags);
> +	folio_put(folio);
>  	return rc;
>  }
>  
> @@ -169,14 +172,17 @@ int uv_convert_from_secure(unsigned long paddr)
>   */
>  int uv_convert_owned_from_secure(unsigned long paddr)
>  {
> -	struct page *page = phys_to_page(paddr);
> +	struct folio *folio = phys_to_folio(paddr);
>  	int rc;
>  
> -	get_page(page);
> +	if (unlikely(folio_test_large(folio)))
> +		return 0;

... and here

> +
> +	folio_get(folio);
>  	rc = uv_convert_from_secure(paddr);
>  	if (!rc)
> -		clear_bit(PG_arch_1, &page->flags);
> -	put_page(page);
> +		clear_bit(PG_arch_1, &folio->flags);
> +	folio_put(folio);
>  	return rc;
>  }
>  
> @@ -457,33 +463,34 @@ EXPORT_SYMBOL_GPL(gmap_destroy_page);
>   */
>  int arch_make_page_accessible(struct page *page)
>  {
> +	struct folio *folio = page_folio(page);
>  	int rc = 0;
>  
> -	/* Hugepage cannot be protected, so nothing to do */
> -	if (PageHuge(page))
> +	/* Large folios cannot be protected, so nothing to do */
> +	if (unlikely(folio_test_large(folio)))
>  		return 0;
>  
>  	/*
>  	 * PG_arch_1 is used in 3 places:
>  	 * 1. for kernel page tables during early boot
>  	 * 2. for storage keys of huge pages and KVM
> -	 * 3. As an indication that this page might be secure. This can
> +	 * 3. As an indication that this small folio might be secure. This can
>  	 *    overindicate, e.g. we set the bit before calling
>  	 *    convert_to_secure.
>  	 * As secure pages are never huge, all 3 variants can co-exists.
>  	 */
> -	if (!test_bit(PG_arch_1, &page->flags))
> +	if (!test_bit(PG_arch_1, &folio->flags))
>  		return 0;
>  
> -	rc = uv_pin_shared(page_to_phys(page));
> +	rc = uv_pin_shared(folio_to_phys(folio));
>  	if (!rc) {
> -		clear_bit(PG_arch_1, &page->flags);
> +		clear_bit(PG_arch_1, &folio->flags);
>  		return 0;
>  	}
>  
> -	rc = uv_convert_from_secure(page_to_phys(page));
> +	rc = uv_convert_from_secure(folio_to_phys(folio));
>  	if (!rc) {
> -		clear_bit(PG_arch_1, &page->flags);
> +		clear_bit(PG_arch_1, &folio->flags);
>  		return 0;
>  	}
>  


