Return-Path: <kvm+bounces-16881-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BD54F8BE985
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 18:46:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8FF08B2CE5F
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 16:39:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E6B716D332;
	Tue,  7 May 2024 16:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="hudbxpW9"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94A6116C686;
	Tue,  7 May 2024 16:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715099706; cv=none; b=ItP9/NEgUgqiHg9XJQzvf9vnWI3ETfajTSoTYmWMABMUrwsoG5/a2C4VHSl4aQx0NdIGwQbSdM8FrFAxmgieiHepHz0GqS26kKymb1hIA21/dWWkfcjmKjRLFppVHkGXK2MfoZQ6Gjy/nNsc/NsbQu462TCwlV8JCio6oO6zHKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715099706; c=relaxed/simple;
	bh=Yw+W6EOpS5324//V7p9SZfoADD4/uyq/iHCqqoA3zes=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UuA/TCr6c7aRnX1+vfVWgEBtH/j2wMH2rWuWAbpPUvn82BW5ARH62yrDJeSAHjkK4TGGfOZSRVI2uQFXz+64rZ96saYZnKqJtXP6zB4unSBGXN/nqPYuCEc6fa2AkVmFw/ewukSxM/GYNlZ5wyOxdHjGapzmTcjInPY4QWi6d5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=hudbxpW9; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 447GPWDL003420;
	Tue, 7 May 2024 16:35:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=ZpdvGe/PCF9K79lOhhzmJsF+6EynaPR8HQUF5y3sTcY=;
 b=hudbxpW9xTG57XuDMUQ+VtA5I8gngOXUFigovOpmjFXqwlwf9Q8FlP4UxODNJq8tXnEs
 FTsuBjXPEPq1DeSyev7yeCKr949ry/PpstWs4hg2sMV9tZ95s/m1+5Hqpud0c/lN0BUX
 xg+SSQFjvrQYTeaX1ZPeYNaD4Nc2vcjYG4PviUiLmKF7M+3kAud4lo+3aMfat6sPG9h7
 qBrPzE/bFEl5W1ki4jDP6WrCIdKkRypCztirv1AFJ5+8F76oFpEfW3WjtQqIorZP1WDx
 xw+ZIuqAyhZwMLp6aBEb2rOMWZjH6f/u6nnQd6YSLTzUEZeimlGqexcAeCkWulZjci/s 9w== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xyqpv0123-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 May 2024 16:34:59 +0000
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 447GYxAB019237;
	Tue, 7 May 2024 16:34:59 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xyqpv011y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 May 2024 16:34:59 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 447FKNjQ028545;
	Tue, 7 May 2024 16:34:58 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3xwyr07efy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 May 2024 16:34:57 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 447GYq5331064632
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 7 May 2024 16:34:54 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 468C72004E;
	Tue,  7 May 2024 16:34:52 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 12A612004B;
	Tue,  7 May 2024 16:34:52 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  7 May 2024 16:34:52 +0000 (GMT)
Date: Tue, 7 May 2024 17:49:00 +0200
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
Subject: Re: [PATCH v2 04/10] s390/uv: convert PG_arch_1 users to only work
 on small folios
Message-ID: <20240507174900.0b05791a@p-imbrenda.boeblingen.de.ibm.com>
In-Reply-To: <20240412142120.220087-5-david@redhat.com>
References: <20240412142120.220087-1-david@redhat.com>
	<20240412142120.220087-5-david@redhat.com>
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
X-Proofpoint-GUID: OQgibnyqv9J8IT-0kxPNUMzQBczh4WlT
X-Proofpoint-ORIG-GUID: WO723TopDS_-VtXiq7lKIJbcRXsNGkx4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-07_10,2024-05-06_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 mlxscore=0 spamscore=0 suspectscore=0 mlxlogscore=999
 lowpriorityscore=0 clxscore=1015 priorityscore=1501 adultscore=0
 phishscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2405070113

On Fri, 12 Apr 2024 16:21:14 +0200
David Hildenbrand <david@redhat.com> wrote:

> Now that make_folio_secure() may only set PG_arch_1 for small folios,
> let's convert relevant remaining UV code to only work on (small) folios
> and simply reject large folios early. This way, we'll never end up
> touching PG_arch_1 on tail pages of a large folio in UV code.
> 
> The folio_get()/folio_put() for functions that are documented to already
> hold a folio reference look weird; likely they are required to make
> concurrent gmap_make_secure() back off because the caller might only hold
> an implicit reference due to the page mapping. So leave that alone for now.
> 
> Signed-off-by: David Hildenbrand <david@redhat.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  arch/s390/include/asm/page.h |  2 ++
>  arch/s390/kernel/uv.c        | 41 ++++++++++++++++++++++--------------
>  2 files changed, 27 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/s390/include/asm/page.h b/arch/s390/include/asm/page.h
> index 9381879f7ecf..b64384872c0f 100644
> --- a/arch/s390/include/asm/page.h
> +++ b/arch/s390/include/asm/page.h
> @@ -214,7 +214,9 @@ static inline unsigned long __phys_addr(unsigned long x, bool is_31bit)
>  #define pfn_to_phys(pfn)	((pfn) << PAGE_SHIFT)
>  
>  #define phys_to_page(phys)	pfn_to_page(phys_to_pfn(phys))
> +#define phys_to_folio(phys)	page_folio(phys_to_page(phys))
>  #define page_to_phys(page)	pfn_to_phys(page_to_pfn(page))
> +#define folio_to_phys(page)	pfn_to_phys(folio_pfn(folio))
>  
>  static inline void *pfn_to_virt(unsigned long pfn)
>  {
> diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
> index 3c6d86e3e828..914dcec27329 100644
> --- a/arch/s390/kernel/uv.c
> +++ b/arch/s390/kernel/uv.c
> @@ -135,14 +135,18 @@ static int uv_destroy_page(unsigned long paddr)
>   */
>  int uv_destroy_owned_page(unsigned long paddr)
>  {
> -	struct page *page = phys_to_page(paddr);
> +	struct folio *folio = phys_to_folio(paddr);
>  	int rc;
>  
> -	get_page(page);
> +	/* See gmap_make_secure(): large folios cannot be secure */
> +	if (unlikely(folio_test_large(folio)))
> +		return 0;
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
> @@ -170,14 +174,18 @@ int uv_convert_from_secure(unsigned long paddr)
>   */
>  int uv_convert_owned_from_secure(unsigned long paddr)
>  {
> -	struct page *page = phys_to_page(paddr);
> +	struct folio *folio = phys_to_folio(paddr);
>  	int rc;
>  
> -	get_page(page);
> +	/* See gmap_make_secure(): large folios cannot be secure */
> +	if (unlikely(folio_test_large(folio)))
> +		return 0;
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
> @@ -479,33 +487,34 @@ EXPORT_SYMBOL_GPL(gmap_destroy_page);
>   */
>  int arch_make_page_accessible(struct page *page)
>  {
> +	struct folio *folio = page_folio(page);
>  	int rc = 0;
>  
> -	/* Hugepage cannot be protected, so nothing to do */
> -	if (PageHuge(page))
> +	/* See gmap_make_secure(): large folios cannot be secure */
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


