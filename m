Return-Path: <kvm+bounces-16889-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AE3978BE95E
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 18:41:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3A7751F27CEC
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 16:41:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC2A7184117;
	Tue,  7 May 2024 16:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="HrddjrBT"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 268FF180A94;
	Tue,  7 May 2024 16:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715099713; cv=none; b=ADK09wUCIiqK+t2ELpN8gE13kuzc8Wam9dgUGxGoIfnOQFNRZ65HvUGqed5IIFsUhqA6l+CFm013mhvvKBV5hoAWxEOCEs31jsg+VR9ZErLWHWnNMPAbuUe2n8wk/g1pdip9RI8A35nPMUF6gM1vq6vpU9jzeNBziT4W4Z66tmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715099713; c=relaxed/simple;
	bh=DPO19saSRN9Lr/ZlxmpldjvftdAMtvY2eyxdGYxJ72o=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WsX1gQ0fOzAuR/Ibzee9MjOVk5doYrV9jX3I+SBY92vzg8c4iXeQgCVWYoRxTwrzLnG6+3Eq5Exup9e5/WLUlAPc9i8HJHJuQ92w1TH2Zdx/3YxCRntoV1P9WpTMbJDoOTUp82En4rnecIX++uBvSXncZjzzjhMURjiiBHfEKIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=HrddjrBT; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 447GT26c011816;
	Tue, 7 May 2024 16:35:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=Ed3ABSWcS7HI/jvRWt0bJ9U+N+WC/8SToS21v9IJLHM=;
 b=HrddjrBTsJdUEYGW6DqCP1vK7fXsQsXyTkwws8PD/srSexdr7bgmgzOCzMbvBv0QU99T
 G2+D1pitFWbyybUPcfCfAiDGp3cJKLEZ1+N6RY1IMY3iIrpz6CMFtpFxcD4hdZtCJw0I
 2yn9Yjte43gEGXXg6OE/U1vjS4mj7n65WO7YNCE18FRo+sMAA2D1fBFHVAsrCkOb97PU
 +NBaUB24igsL6Zoe+QtAMBDM0hUKsnxOd0O6IAddtLlRNA3W4cI9rnnuK49WTsTMIBKG
 tMbZ6pbt3b5/VICVlQDGGtQ0tlJ/E0LPhTNVf4S8rHuQ71YZqVXdtanDxUmZrXq+ykzR tg== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xyqup80g7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 May 2024 16:35:08 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 447GZ81t021994;
	Tue, 7 May 2024 16:35:08 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xyqup80g5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 May 2024 16:35:07 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 447E4GMI005886;
	Tue, 7 May 2024 16:35:07 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3xx5yh5w2x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 May 2024 16:35:07 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 447GZ18655706066
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 7 May 2024 16:35:03 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7C75620043;
	Tue,  7 May 2024 16:35:01 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 48B5C20040;
	Tue,  7 May 2024 16:35:01 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  7 May 2024 16:35:01 +0000 (GMT)
Date: Tue, 7 May 2024 18:26:19 +0200
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
Subject: Re: [PATCH v2 08/10] s390/uv: convert
 uv_convert_owned_from_secure() to uv_convert_from_secure_(folio|pte)()
Message-ID: <20240507182619.2846ea8f@p-imbrenda.boeblingen.de.ibm.com>
In-Reply-To: <20240412142120.220087-9-david@redhat.com>
References: <20240412142120.220087-1-david@redhat.com>
	<20240412142120.220087-9-david@redhat.com>
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
X-Proofpoint-ORIG-GUID: crRXsyOa-oSrtq_E7AGyOl_OsN77sIgP
X-Proofpoint-GUID: RKe4jzWmdoY5D01NMa7mcD3-5zrYeetO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-07_09,2024-05-06_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 mlxlogscore=999 priorityscore=1501 adultscore=0 clxscore=1015
 impostorscore=0 phishscore=0 spamscore=0 suspectscore=0 lowpriorityscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2405070112

On Fri, 12 Apr 2024 16:21:18 +0200
David Hildenbrand <david@redhat.com> wrote:

> Let's do the same as we did for uv_destroy_(folio|pte)() and
> have the following variants:
> 
> (1) uv_convert_from_secure(): "low level" helper that operates on paddr
> and does not mess with folios.
> 
> (2) uv_convert_from_secure_folio(): Consumes a folio to which we hold a
> reference.
> 
> (3) uv_convert_from_secure_pte(): Consumes a PTE that holds a reference
> through the mapping.
> 
> Unfortunately we need uv_convert_from_secure_pte(), because pfn_folio()
> and friends are not available in pgtable.h.
> 
> Signed-off-by: David Hildenbrand <david@redhat.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  arch/s390/include/asm/pgtable.h |  6 +++---
>  arch/s390/include/asm/uv.h      |  4 ++--
>  arch/s390/kernel/uv.c           | 18 +++++++++++++-----
>  3 files changed, 18 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
> index 97e040617c29..5ffc4828c25a 100644
> --- a/arch/s390/include/asm/pgtable.h
> +++ b/arch/s390/include/asm/pgtable.h
> @@ -1149,7 +1149,7 @@ static inline pte_t ptep_get_and_clear(struct mm_struct *mm,
>  	res = ptep_xchg_lazy(mm, addr, ptep, __pte(_PAGE_INVALID));
>  	/* At this point the reference through the mapping is still present */
>  	if (mm_is_protected(mm) && pte_present(res))
> -		uv_convert_owned_from_secure(pte_val(res) & PAGE_MASK);
> +		uv_convert_from_secure_pte(res);
>  	return res;
>  }
>  
> @@ -1167,7 +1167,7 @@ static inline pte_t ptep_clear_flush(struct vm_area_struct *vma,
>  	res = ptep_xchg_direct(vma->vm_mm, addr, ptep, __pte(_PAGE_INVALID));
>  	/* At this point the reference through the mapping is still present */
>  	if (mm_is_protected(vma->vm_mm) && pte_present(res))
> -		uv_convert_owned_from_secure(pte_val(res) & PAGE_MASK);
> +		uv_convert_from_secure_pte(res);
>  	return res;
>  }
>  
> @@ -1206,7 +1206,7 @@ static inline pte_t ptep_get_and_clear_full(struct mm_struct *mm,
>  	 * if this is not a mm teardown, the slower export is used as
>  	 * fallback instead.
>  	 */
> -	uv_convert_owned_from_secure(pte_val(res) & PAGE_MASK);
> +	uv_convert_from_secure_pte(res);
>  	return res;
>  }
>  
> diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
> index a1bef30066ef..0679445cac0b 100644
> --- a/arch/s390/include/asm/uv.h
> +++ b/arch/s390/include/asm/uv.h
> @@ -485,7 +485,7 @@ int gmap_make_secure(struct gmap *gmap, unsigned long gaddr, void *uvcb);
>  int gmap_destroy_page(struct gmap *gmap, unsigned long gaddr);
>  int uv_destroy_folio(struct folio *folio);
>  int uv_destroy_pte(pte_t pte);
> -int uv_convert_owned_from_secure(unsigned long paddr);
> +int uv_convert_from_secure_pte(pte_t pte);
>  int gmap_convert_to_secure(struct gmap *gmap, unsigned long gaddr);
>  
>  void setup_uv(void);
> @@ -508,7 +508,7 @@ static inline int uv_destroy_pte(pte_t pte)
>  	return 0;
>  }
>  
> -static inline int uv_convert_owned_from_secure(unsigned long paddr)
> +static inline int uv_convert_from_secure_pte(pte_t pte)
>  {
>  	return 0;
>  }
> diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
> index 61c1ce51c883..b456066d72da 100644
> --- a/arch/s390/kernel/uv.c
> +++ b/arch/s390/kernel/uv.c
> @@ -178,11 +178,10 @@ static int uv_convert_from_secure(unsigned long paddr)
>  }
>  
>  /*
> - * The caller must already hold a reference to the page
> + * The caller must already hold a reference to the folio.
>   */
> -int uv_convert_owned_from_secure(unsigned long paddr)
> +static int uv_convert_from_secure_folio(struct folio *folio)
>  {
> -	struct folio *folio = phys_to_folio(paddr);
>  	int rc;
>  
>  	/* See gmap_make_secure(): large folios cannot be secure */
> @@ -190,13 +189,22 @@ int uv_convert_owned_from_secure(unsigned long paddr)
>  		return 0;
>  
>  	folio_get(folio);
> -	rc = uv_convert_from_secure(paddr);
> +	rc = uv_convert_from_secure(folio_to_phys(folio));
>  	if (!rc)
>  		clear_bit(PG_arch_1, &folio->flags);
>  	folio_put(folio);
>  	return rc;
>  }
>  
> +/*
> + * The present PTE still indirectly holds a folio reference through the mapping.
> + */
> +int uv_convert_from_secure_pte(pte_t pte)
> +{
> +	VM_WARN_ON(!pte_present(pte));
> +	return uv_convert_from_secure_folio(pfn_folio(pte_pfn(pte)));
> +}
> +
>  /*
>   * Calculate the expected ref_count for a folio that would otherwise have no
>   * further pins. This was cribbed from similar functions in other places in
> @@ -481,7 +489,7 @@ int gmap_destroy_page(struct gmap *gmap, unsigned long gaddr)
>  	 * we instead try to export the page.
>  	 */
>  	if (rc)
> -		rc = uv_convert_owned_from_secure(page_to_phys(page));
> +		rc = uv_convert_from_secure_folio(folio);
>  	folio_put(folio);
>  out:
>  	mmap_read_unlock(gmap->mm);


