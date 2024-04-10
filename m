Return-Path: <kvm+bounces-14146-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D344C89FEDD
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 19:45:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4AE381F2417C
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 17:45:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46CEE180A6A;
	Wed, 10 Apr 2024 17:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="sJSz3ERr"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6938013D502;
	Wed, 10 Apr 2024 17:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712771099; cv=none; b=hL7X6cTBiVZSW8N2JXWc4pJTmE0zb7Dne4NbvqA4ZvAWonVE4PYPP+tM7lzIjSI3LhodT/BJreXIW5Uwge7o0U8rTzKdySw9KUdLuhnXJ7Kik0peukPFUDshhORR2seM154OCHyuy4qLLCZU33DoyNNiqretMrvfB4ZycI/uByQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712771099; c=relaxed/simple;
	bh=/BMaKXEy6NNnwFMwmVk9KIRRaSKysgILBBq5AXYyV/w=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QiGbn/PWF4xfkw2PcwjGl0CNq72Xe0hKqF776uwwlvv1f3wmzVxQtoW5d8N5/rL8tgqcKDmB9h7RwHOlY9Z4DaGxTneV2oFu5b6EoYxF+DJXmnAkcZB7t+OX5bhQK/zWWf7qYg9w3+NivhuebAGn8z7rMAMCUYICZQAr1Fc6RfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=sJSz3ERr; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43AHW32D027181;
	Wed, 10 Apr 2024 17:44:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=NcCV+vYF6bMCP5PVebzSA3U7LOVkS5kUCoHa1vCxPrs=;
 b=sJSz3ERrXB216gg8xrrXCN9+IMLNefnQMvzHDHZqMKFGtnKCe20Cc9cU0vXipoYDDg2C
 6kdq0Ix2I3HXc1sjqhsSdz42J7cNfkCnJJR7pDIoOdDA8zysxox87aGN96qxNx8RjtQa
 8gcKzA4xy7etKCCdz2kIdc762QWkgdmGusCbV0a2PIpAtqRNfECkvnaxqhSt5fsvLpSW
 HuNO0xpM3YrkL8h261znCFaC3yzd0M1TLfn71q2ExBOdoifYYnwLyol8jAkvhDsrNSnE
 wd/t3RHg0BO/DG8U8nJXATh0CIlY167Jr80kwVYfYwonIF8cUDixsyd7Z/PyvB9X1GVd CA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xdy8j00rk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 Apr 2024 17:44:44 +0000
Received: from m0353727.ppops.net (m0353727.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 43AHihtw011980;
	Wed, 10 Apr 2024 17:44:43 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xdy8j00rh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 Apr 2024 17:44:43 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 43AFqkcu019119;
	Wed, 10 Apr 2024 17:44:42 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3xbh40ef83-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 Apr 2024 17:44:42 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 43AHia1Y16187780
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Apr 2024 17:44:38 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 69E3F2004B;
	Wed, 10 Apr 2024 17:44:36 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3B2B720040;
	Wed, 10 Apr 2024 17:44:36 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 10 Apr 2024 17:44:36 +0000 (GMT)
Date: Wed, 10 Apr 2024 19:31:50 +0200
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
Subject: Re: [PATCH v1 2/5] s390/uv: convert gmap_make_secure() to work on
 folios
Message-ID: <20240410193150.655df790@p-imbrenda>
In-Reply-To: <20240404163642.1125529-3-david@redhat.com>
References: <20240404163642.1125529-1-david@redhat.com>
	<20240404163642.1125529-3-david@redhat.com>
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
X-Proofpoint-ORIG-GUID: rkGJLSWwyI4FSBzce00f3hjUwHMGtIj8
X-Proofpoint-GUID: g0vFXYAqO7tLKK4XeNGPxST4QRrLVVev
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-10_04,2024-04-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 adultscore=0 priorityscore=1501 bulkscore=0 malwarescore=0 spamscore=0
 phishscore=0 suspectscore=0 mlxlogscore=858 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404100130

On Thu,  4 Apr 2024 18:36:39 +0200
David Hildenbrand <david@redhat.com> wrote:

> We have various goals that require gmap_make_secure() to only work on
> folios. We want to limit the use of page_mapcount() to the places where it
> is absolutely necessary, we want to avoid using page flags of tail
> pages, and we want to remove page_has_private().
> 
> So, let's convert gmap_make_secure() to folios. While s390x makes sure
> to never have PMD-mapped THP in processes that use KVM -- by remapping
> them using PTEs in thp_split_walk_pmd_entry()->split_huge_pmd() -- we might
> still find PTE-mapped THPs and could end up working on tail pages of
> such large folios for now.
> 
> To handle that cleanly, let's simply split any PTE-mapped large folio,
> so we can be sure that we are always working with small folios and never
> on tail pages.
> 
> There is no real change: splitting will similarly fail on unexpected folio
> references, just like it would already when we try to freeze the folio
> refcount.
> 
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>  arch/s390/include/asm/page.h |  1 +
>  arch/s390/kernel/uv.c        | 66 ++++++++++++++++++++++--------------
>  2 files changed, 42 insertions(+), 25 deletions(-)
> 
> diff --git a/arch/s390/include/asm/page.h b/arch/s390/include/asm/page.h
> index 9381879f7ecf..54d015bcd8e3 100644
> --- a/arch/s390/include/asm/page.h
> +++ b/arch/s390/include/asm/page.h
> @@ -215,6 +215,7 @@ static inline unsigned long __phys_addr(unsigned long x, bool is_31bit)
>  
>  #define phys_to_page(phys)	pfn_to_page(phys_to_pfn(phys))
>  #define page_to_phys(page)	pfn_to_phys(page_to_pfn(page))
> +#define folio_to_phys(page)	pfn_to_phys(folio_pfn(folio))
>  
>  static inline void *pfn_to_virt(unsigned long pfn)
>  {
> diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
> index 7401838b960b..adcbd4b13035 100644
> --- a/arch/s390/kernel/uv.c
> +++ b/arch/s390/kernel/uv.c
> @@ -181,36 +181,36 @@ int uv_convert_owned_from_secure(unsigned long paddr)
>  }
>  
>  /*
> - * Calculate the expected ref_count for a page that would otherwise have no
> + * Calculate the expected ref_count for a folio that would otherwise have no
>   * further pins. This was cribbed from similar functions in other places in
>   * the kernel, but with some slight modifications. We know that a secure
> - * page can not be a huge page for example.
> + * folio can only be a small folio for example.
>   */
> -static int expected_page_refs(struct page *page)
> +static int expected_folio_refs(struct folio *folio)
>  {
>  	int res;
>  
> -	res = page_mapcount(page);
> -	if (PageSwapCache(page)) {
> +	res = folio_mapcount(folio);
> +	if (folio_test_swapcache(folio)) {
>  		res++;
> -	} else if (page_mapping(page)) {
> +	} else if (folio_mapping(folio)) {
>  		res++;
> -		if (page_has_private(page))
> +		if (folio_has_private(folio))
>  			res++;
>  	}
>  	return res;
>  }
>  
> -static int make_page_secure(struct page *page, struct uv_cb_header *uvcb)
> +static int make_folio_secure(struct folio *folio, struct uv_cb_header *uvcb)
>  {
>  	int expected, cc = 0;
>  
> -	if (PageWriteback(page))
> +	if (folio_test_writeback(folio))
>  		return -EAGAIN;
> -	expected = expected_page_refs(page);
> -	if (!page_ref_freeze(page, expected))
> +	expected = expected_folio_refs(folio);
> +	if (!folio_ref_freeze(folio, expected))
>  		return -EBUSY;
> -	set_bit(PG_arch_1, &page->flags);
> +	set_bit(PG_arch_1, &folio->flags);
>  	/*
>  	 * If the UVC does not succeed or fail immediately, we don't want to
>  	 * loop for long, or we might get stall notifications.
> @@ -220,9 +220,9 @@ static int make_page_secure(struct page *page, struct uv_cb_header *uvcb)
>  	 * -EAGAIN and we let the callers deal with it.
>  	 */
>  	cc = __uv_call(0, (u64)uvcb);
> -	page_ref_unfreeze(page, expected);
> +	folio_ref_unfreeze(folio, expected);
>  	/*
> -	 * Return -ENXIO if the page was not mapped, -EINVAL for other errors.
> +	 * Return -ENXIO if the folio was not mapped, -EINVAL for other errors.
>  	 * If busy or partially completed, return -EAGAIN.
>  	 */
>  	if (cc == UVC_CC_OK)
> @@ -277,7 +277,7 @@ int gmap_make_secure(struct gmap *gmap, unsigned long gaddr, void *uvcb)
>  	bool local_drain = false;
>  	spinlock_t *ptelock;
>  	unsigned long uaddr;
> -	struct page *page;
> +	struct folio *folio;
>  	pte_t *ptep;
>  	int rc;
>  
> @@ -306,33 +306,49 @@ int gmap_make_secure(struct gmap *gmap, unsigned long gaddr, void *uvcb)
>  	if (!ptep)
>  		goto out;
>  	if (pte_present(*ptep) && !(pte_val(*ptep) & _PAGE_INVALID) && pte_write(*ptep)) {
> -		page = pte_page(*ptep);
> +		folio = page_folio(pte_page(*ptep));
>  		rc = -EAGAIN;
> -		if (trylock_page(page)) {
> +
> +		/* We might get PTE-mapped large folios; split them first. */
> +		if (folio_test_large(folio)) {
> +			rc = -E2BIG;
> +		} else if (folio_trylock(folio)) {
>  			if (should_export_before_import(uvcb, gmap->mm))
> -				uv_convert_from_secure(page_to_phys(page));
> -			rc = make_page_secure(page, uvcb);
> -			unlock_page(page);
> +				uv_convert_from_secure(folio_to_phys(folio));
> +			rc = make_folio_secure(folio, uvcb);
> +			folio_unlock(folio);
>  		}
>  
>  		/*
> -		 * Once we drop the PTL, the page may get unmapped and
> +		 * Once we drop the PTL, the folio may get unmapped and
>  		 * freed immediately. We need a temporary reference.
>  		 */
> -		if (rc == -EAGAIN)
> -			get_page(page);
> +		if (rc == -EAGAIN || rc == -E2BIG)
> +			folio_get(folio);
>  	}
>  	pte_unmap_unlock(ptep, ptelock);
>  out:
>  	mmap_read_unlock(gmap->mm);
>  
> +	if (rc == -E2BIG) {
> +		/*
> +		 * Splitting might fail with -EBUSY due to unexpected folio
> +		 * references, just like make_folio_secure(). So handle it
> +		 * ahead of time without the PTL being held.
> +		 */
> +		folio_lock(folio);
> +		rc = split_folio(folio);

if split_folio returns -EAGAIN...

> +		folio_unlock(folio);
> +		folio_put(folio);
> +	}
> +
>  	if (rc == -EAGAIN) {

... we will not skip this ...

>  		/*
>  		 * If we are here because the UVC returned busy or partial
>  		 * completion, this is just a useless check, but it is safe.
>  		 */
> -		wait_on_page_writeback(page);
> -		put_page(page);
> +		folio_wait_writeback(folio);
> +		folio_put(folio);

... and we will do one folio_put() too many

>  	} else if (rc == -EBUSY) {
>  		/*
>  		 * If we have tried a local drain and the page refcount

are we sure that split_folio() can never return -EAGAIN now and in the
future too?

maybe just change it to  } else if (...   ?


