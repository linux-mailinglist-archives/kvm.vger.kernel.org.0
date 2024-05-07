Return-Path: <kvm+bounces-16882-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F18BF8BE94D
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 18:39:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7E44C1F27AE3
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 16:39:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A0C016D4FE;
	Tue,  7 May 2024 16:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="SbBm54P5"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DD1915FA70;
	Tue,  7 May 2024 16:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715099707; cv=none; b=Ti+JQlBKkVjx9YzV9ZTfFZJk4/G6rYDEYOPt/1RW03eF/nW369FEfffNDvnOzs4SLS1HuQZhmlAR5YIANzaUOjfOp2wsBSquhouFAQZu1IzcOgTgxLkAydzFJjEnWC0kzT1QWlh1t9z+CoPvsKNDLmiiqx9OKfeKS1EK5YvwSg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715099707; c=relaxed/simple;
	bh=lfScHmvdqPaBXlvaQ/bWWDypFh9amox+v4VqxmSQXYs=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Anjdy/KM+B42BmHO5l65opclZ/vApNOUPMfMz2c8ieuwG0zy3l7ondNdqC/GVGMnZadvuRIi6xhrveF0Tt7RVb7xShgVNr1eOInKvEZGZ3rBYNmHN9qhoPH9jura6/seX/ELfxP3T1dBtgMQF8iRVl14dDPrtwP8ZhhDO7+Su4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=SbBm54P5; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 447G7Iq8016296;
	Tue, 7 May 2024 16:34:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=0g2Y1HrdZhlmW9KUaTvwqMGRRwkTNvfztHJ1kclu0Gs=;
 b=SbBm54P53l6zmjOw7F3mI5njHXS3ZlF2JxwnOas5/alRvfX5UxH8VCPyJFEIrNEIOX4U
 Qxg+tCP5UmRqA4XiBURj78mNHP6YXrziNxLB2EVmuHalrQgt3+NZOba+ABYmabzQCBBl
 p/EjuX6GarkYwD2eELiSR58Z0dtZUqiWlPG0ITvCElTHIcSfWkNVwWmrZaCVHa7QuC5/
 K1vxc3KultgN1yzfliFjaH+Z7qh1TEp9E30YshSjQPkucYCiLhmv5IEPFlM5pememZOl
 PKEC4zduwsqA5qFg5VgNRW2weyZViPcWSweTqHOlyM7WYJAX6QtuKy9qCyGFdDRzuG+6 6A== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xyqhr81s5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 May 2024 16:34:56 +0000
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 447GYtwa025401;
	Tue, 7 May 2024 16:34:55 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xyqhr81s2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 May 2024 16:34:55 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 447E9Wsr013959;
	Tue, 7 May 2024 16:34:54 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3xx222xvqu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 May 2024 16:34:54 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 447GYniC47448406
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 7 May 2024 16:34:51 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 128912004E;
	Tue,  7 May 2024 16:34:49 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C939C2004D;
	Tue,  7 May 2024 16:34:48 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  7 May 2024 16:34:48 +0000 (GMT)
Date: Tue, 7 May 2024 18:25:15 +0200
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
Subject: Re: [PATCH v2 07/10] s390/uv: convert uv_destroy_owned_page() to
 uv_destroy_(folio|pte)()
Message-ID: <20240507182515.0ce19da5@p-imbrenda.boeblingen.de.ibm.com>
In-Reply-To: <20240412142120.220087-8-david@redhat.com>
References: <20240412142120.220087-1-david@redhat.com>
	<20240412142120.220087-8-david@redhat.com>
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
X-Proofpoint-ORIG-GUID: Gy31hXtW57XyqcX0sZhg-EMLdzCls9Qj
X-Proofpoint-GUID: BbCVk9QsfWD0wnuk-eB_b9oO3gnVttpe
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-07_10,2024-05-06_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 priorityscore=1501 suspectscore=0 clxscore=1015 adultscore=0
 lowpriorityscore=0 mlxlogscore=999 impostorscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2404010000 definitions=main-2405070113

On Fri, 12 Apr 2024 16:21:17 +0200
David Hildenbrand <david@redhat.com> wrote:

> Let's have the following variants for destroying pages:
> 
> (1) uv_destroy(): Like uv_pin_shared() and uv_convert_from_secure(),
> "low level" helper that operates on paddr and doesn't mess with folios.
> 
> (2) uv_destroy_folio(): Consumes a folio to which we hold a reference.
> 
> (3) uv_destroy_pte(): Consumes a PTE that holds a reference through the
> mapping.
> 
> Unfortunately we need uv_destroy_pte(), because pfn_folio() and
> friends are not available in pgtable.h.
> 
> Signed-off-by: David Hildenbrand <david@redhat.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  arch/s390/include/asm/pgtable.h |  2 +-
>  arch/s390/include/asm/uv.h      | 10 ++++++++--
>  arch/s390/kernel/uv.c           | 24 +++++++++++++++++-------
>  arch/s390/mm/gmap.c             |  6 ++++--
>  4 files changed, 30 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
> index 60950e7a25f5..97e040617c29 100644
> --- a/arch/s390/include/asm/pgtable.h
> +++ b/arch/s390/include/asm/pgtable.h
> @@ -1199,7 +1199,7 @@ static inline pte_t ptep_get_and_clear_full(struct mm_struct *mm,
>  	 * The notifier should have destroyed all protected vCPUs at this
>  	 * point, so the destroy should be successful.
>  	 */
> -	if (full && !uv_destroy_owned_page(pte_val(res) & PAGE_MASK))
> +	if (full && !uv_destroy_pte(res))
>  		return res;
>  	/*
>  	 * If something went wrong and the page could not be destroyed, or
> diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
> index d2205ff97007..a1bef30066ef 100644
> --- a/arch/s390/include/asm/uv.h
> +++ b/arch/s390/include/asm/uv.h
> @@ -483,7 +483,8 @@ static inline int is_prot_virt_host(void)
>  int uv_pin_shared(unsigned long paddr);
>  int gmap_make_secure(struct gmap *gmap, unsigned long gaddr, void *uvcb);
>  int gmap_destroy_page(struct gmap *gmap, unsigned long gaddr);
> -int uv_destroy_owned_page(unsigned long paddr);
> +int uv_destroy_folio(struct folio *folio);
> +int uv_destroy_pte(pte_t pte);
>  int uv_convert_owned_from_secure(unsigned long paddr);
>  int gmap_convert_to_secure(struct gmap *gmap, unsigned long gaddr);
>  
> @@ -497,7 +498,12 @@ static inline int uv_pin_shared(unsigned long paddr)
>  	return 0;
>  }
>  
> -static inline int uv_destroy_owned_page(unsigned long paddr)
> +static inline int uv_destroy_folio(struct folio *folio)
> +{
> +	return 0;
> +}
> +
> +static inline int uv_destroy_pte(pte_t pte)
>  {
>  	return 0;
>  }
> diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
> index 3d3250b406a6..61c1ce51c883 100644
> --- a/arch/s390/kernel/uv.c
> +++ b/arch/s390/kernel/uv.c
> @@ -110,7 +110,7 @@ EXPORT_SYMBOL_GPL(uv_pin_shared);
>   *
>   * @paddr: Absolute host address of page to be destroyed
>   */
> -static int uv_destroy_page(unsigned long paddr)
> +static int uv_destroy(unsigned long paddr)
>  {
>  	struct uv_cb_cfs uvcb = {
>  		.header.cmd = UVC_CMD_DESTR_SEC_STOR,
> @@ -131,11 +131,10 @@ static int uv_destroy_page(unsigned long paddr)
>  }
>  
>  /*
> - * The caller must already hold a reference to the page
> + * The caller must already hold a reference to the folio
>   */
> -int uv_destroy_owned_page(unsigned long paddr)
> +int uv_destroy_folio(struct folio *folio)
>  {
> -	struct folio *folio = phys_to_folio(paddr);
>  	int rc;
>  
>  	/* See gmap_make_secure(): large folios cannot be secure */
> @@ -143,13 +142,22 @@ int uv_destroy_owned_page(unsigned long paddr)
>  		return 0;
>  
>  	folio_get(folio);
> -	rc = uv_destroy_page(paddr);
> +	rc = uv_destroy(folio_to_phys(folio));
>  	if (!rc)
>  		clear_bit(PG_arch_1, &folio->flags);
>  	folio_put(folio);
>  	return rc;
>  }
>  
> +/*
> + * The present PTE still indirectly holds a folio reference through the mapping.
> + */
> +int uv_destroy_pte(pte_t pte)
> +{
> +	VM_WARN_ON(!pte_present(pte));
> +	return uv_destroy_folio(pfn_folio(pte_pfn(pte)));
> +}
> +
>  /*
>   * Requests the Ultravisor to encrypt a guest page and make it
>   * accessible to the host for paging (export).
> @@ -437,6 +445,7 @@ int gmap_destroy_page(struct gmap *gmap, unsigned long gaddr)
>  {
>  	struct vm_area_struct *vma;
>  	unsigned long uaddr;
> +	struct folio *folio;
>  	struct page *page;
>  	int rc;
>  
> @@ -460,7 +469,8 @@ int gmap_destroy_page(struct gmap *gmap, unsigned long gaddr)
>  	page = follow_page(vma, uaddr, FOLL_WRITE | FOLL_GET);
>  	if (IS_ERR_OR_NULL(page))
>  		goto out;
> -	rc = uv_destroy_owned_page(page_to_phys(page));
> +	folio = page_folio(page);
> +	rc = uv_destroy_folio(folio);
>  	/*
>  	 * Fault handlers can race; it is possible that two CPUs will fault
>  	 * on the same secure page. One CPU can destroy the page, reboot,
> @@ -472,7 +482,7 @@ int gmap_destroy_page(struct gmap *gmap, unsigned long gaddr)
>  	 */
>  	if (rc)
>  		rc = uv_convert_owned_from_secure(page_to_phys(page));
> -	put_page(page);
> +	folio_put(folio);
>  out:
>  	mmap_read_unlock(gmap->mm);
>  	return rc;
> diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
> index 094b43b121cd..0351cb139df4 100644
> --- a/arch/s390/mm/gmap.c
> +++ b/arch/s390/mm/gmap.c
> @@ -2756,13 +2756,15 @@ static const struct mm_walk_ops gather_pages_ops = {
>   */
>  void s390_uv_destroy_pfns(unsigned long count, unsigned long *pfns)
>  {
> +	struct folio *folio;
>  	unsigned long i;
>  
>  	for (i = 0; i < count; i++) {
> +		folio = pfn_folio(pfns[i]);
>  		/* we always have an extra reference */
> -		uv_destroy_owned_page(pfn_to_phys(pfns[i]));
> +		uv_destroy_folio(folio);
>  		/* get rid of the extra reference */
> -		put_page(pfn_to_page(pfns[i]));
> +		folio_put(folio);
>  		cond_resched();
>  	}
>  }


