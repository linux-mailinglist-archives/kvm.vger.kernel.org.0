Return-Path: <kvm+bounces-16888-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 982978BE95C
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 18:41:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BBC701C23E6A
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 16:41:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D473D181318;
	Tue,  7 May 2024 16:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="p5wO3re0"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57B7617967C;
	Tue,  7 May 2024 16:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715099712; cv=none; b=FW4qG+FTUheUAK0aZCbhuzwh5/wO7eSq0sZx68kEsafluhjvpGQe7IFYbOGVUSYVq9Em43XIhjp/PXQpPWQxlXFWVeimWyCqQGQg1lUboTmNyt95q/XJ6D++EPaTHbSfEHy4+fXks8Yg3QMtb/yrN+evEeSMo33C1ugqUc4kc1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715099712; c=relaxed/simple;
	bh=nYYHI1lX7tSIULkrAfAULdVwRSwZQZMaF/wYbKQevjg=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mkRZCdsCqoadmZ1b1GpM7EtGvoL+oAB2x+FVovembI7UUQXKP1UtMLbOij0XC8RtCh+NSo6CAZ/32OiSLs0/WYM2QBgHY572mWpAdUKYzGcA6lOkdzQQLj192Ez7MG7tuiJGq9BSYNLpzZf6XT8pQ/g5DFgbVB+d8iEeZHVvj+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=p5wO3re0; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 447G96CR014054;
	Tue, 7 May 2024 16:35:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=qZAsXK2MlNndj48kA4lJe7DQZC7zLHkchPdAIkp7POY=;
 b=p5wO3re0JzadvMNN1jfTfQacxHdg993byB6p8hzsrG7TwXECcxb0sjaFJh4sgHzlK5Ao
 0CDgOJix2yJnPzSjhLMYSHS9FXdn0xX8loNdExOuKy0uGdbbYaZ46s1P7CCjLDPBJ27B
 qzqNj9gc7E7966c6mpOvkO7f57FgQG9Zqo6dZwP/G8Hixp02vfcmK1KFeqm46CKwiswI
 2VWJrT094dLjXiR04EgLAV+ESnIyfoT9BREePqPt+0boxsXpkElO7bZd/AxFW4i7Ndhu
 w3nhM1Wy7JQMgUzZ54gUaapbYhDsqA8Tm5U9GiU3TS2AdhXq9TnycR+A9ziRIIrC3HBx IA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xyqj98204-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 May 2024 16:35:07 +0000
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 447GZ6Qf021808;
	Tue, 7 May 2024 16:35:06 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xyqj981yy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 May 2024 16:35:06 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 447FCYRZ028617;
	Tue, 7 May 2024 16:35:05 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3xwyr07egh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 May 2024 16:35:05 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 447GZ0Bd46924212
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 7 May 2024 16:35:02 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EBDEA2004D;
	Tue,  7 May 2024 16:34:59 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B7AC82004B;
	Tue,  7 May 2024 16:34:59 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  7 May 2024 16:34:59 +0000 (GMT)
Date: Tue, 7 May 2024 18:29:30 +0200
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
Subject: Re: [PATCH v2 09/10] s390/uv: implement
 HAVE_ARCH_MAKE_FOLIO_ACCESSIBLE
Message-ID: <20240507182930.03ca0be2@p-imbrenda.boeblingen.de.ibm.com>
In-Reply-To: <20240412142120.220087-10-david@redhat.com>
References: <20240412142120.220087-1-david@redhat.com>
	<20240412142120.220087-10-david@redhat.com>
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
X-Proofpoint-ORIG-GUID: loY9liwNUfC4v6qaY8I0WNlGJL_TWcnb
X-Proofpoint-GUID: vOSKbZP4nf5hKs6sdNkVvYDQMnFoL3rK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-07_09,2024-05-06_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 priorityscore=1501 bulkscore=0 phishscore=0 malwarescore=0
 lowpriorityscore=0 impostorscore=0 spamscore=0 mlxscore=0 adultscore=0
 clxscore=1015 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2404010000 definitions=main-2405070112

On Fri, 12 Apr 2024 16:21:19 +0200
David Hildenbrand <david@redhat.com> wrote:

> Let's also implement HAVE_ARCH_MAKE_FOLIO_ACCESSIBLE, so we can convert
> arch_make_page_accessible() to be a simple wrapper around
> arch_make_folio_accessible(). Unfortuantely, we cannot do that in the
> header.
> 
> There are only two arch_make_page_accessible() calls remaining in gup.c.
> We can now drop HAVE_ARCH_MAKE_PAGE_ACCESSIBLE completely form core-MM.
> We'll handle that separately, once the s390x part landed.
> 
> Suggested-by: Matthew Wilcox <willy@infradead.org>
> Signed-off-by: David Hildenbrand <david@redhat.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  arch/s390/include/asm/page.h |  3 +++
>  arch/s390/kernel/uv.c        | 18 +++++++++++-------
>  arch/s390/mm/fault.c         | 14 ++++++++------
>  3 files changed, 22 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/s390/include/asm/page.h b/arch/s390/include/asm/page.h
> index b64384872c0f..03bbc782e286 100644
> --- a/arch/s390/include/asm/page.h
> +++ b/arch/s390/include/asm/page.h
> @@ -162,6 +162,7 @@ static inline int page_reset_referenced(unsigned long addr)
>  #define _PAGE_ACC_BITS		0xf0	/* HW access control bits	*/
>  
>  struct page;
> +struct folio;
>  void arch_free_page(struct page *page, int order);
>  void arch_alloc_page(struct page *page, int order);
>  
> @@ -174,6 +175,8 @@ static inline int devmem_is_allowed(unsigned long pfn)
>  #define HAVE_ARCH_ALLOC_PAGE
>  
>  #if IS_ENABLED(CONFIG_PGSTE)
> +int arch_make_folio_accessible(struct folio *folio);
> +#define HAVE_ARCH_MAKE_FOLIO_ACCESSIBLE
>  int arch_make_page_accessible(struct page *page);
>  #define HAVE_ARCH_MAKE_PAGE_ACCESSIBLE
>  #endif
> diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
> index b456066d72da..fa62fa0e369f 100644
> --- a/arch/s390/kernel/uv.c
> +++ b/arch/s390/kernel/uv.c
> @@ -498,14 +498,13 @@ int gmap_destroy_page(struct gmap *gmap, unsigned long gaddr)
>  EXPORT_SYMBOL_GPL(gmap_destroy_page);
>  
>  /*
> - * To be called with the page locked or with an extra reference! This will
> - * prevent gmap_make_secure from touching the page concurrently. Having 2
> - * parallel make_page_accessible is fine, as the UV calls will become a
> - * no-op if the page is already exported.
> + * To be called with the folio locked or with an extra reference! This will
> + * prevent gmap_make_secure from touching the folio concurrently. Having 2
> + * parallel arch_make_folio_accessible is fine, as the UV calls will become a
> + * no-op if the folio is already exported.
>   */
> -int arch_make_page_accessible(struct page *page)
> +int arch_make_folio_accessible(struct folio *folio)
>  {
> -	struct folio *folio = page_folio(page);
>  	int rc = 0;
>  
>  	/* See gmap_make_secure(): large folios cannot be secure */
> @@ -537,8 +536,13 @@ int arch_make_page_accessible(struct page *page)
>  
>  	return rc;
>  }
> -EXPORT_SYMBOL_GPL(arch_make_page_accessible);
> +EXPORT_SYMBOL_GPL(arch_make_folio_accessible);
>  
> +int arch_make_page_accessible(struct page *page)
> +{
> +	return arch_make_folio_accessible(page_folio(page));
> +}
> +EXPORT_SYMBOL_GPL(arch_make_page_accessible);
>  #endif
>  
>  #if defined(CONFIG_PROTECTED_VIRTUALIZATION_GUEST) || IS_ENABLED(CONFIG_KVM)
> diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
> index c421dd44ffbe..a1ba58460593 100644
> --- a/arch/s390/mm/fault.c
> +++ b/arch/s390/mm/fault.c
> @@ -491,6 +491,7 @@ void do_secure_storage_access(struct pt_regs *regs)
>  	unsigned long addr = get_fault_address(regs);
>  	struct vm_area_struct *vma;
>  	struct mm_struct *mm;
> +	struct folio *folio;
>  	struct page *page;
>  	struct gmap *gmap;
>  	int rc;
> @@ -538,17 +539,18 @@ void do_secure_storage_access(struct pt_regs *regs)
>  			mmap_read_unlock(mm);
>  			break;
>  		}
> -		if (arch_make_page_accessible(page))
> +		folio = page_folio(page);
> +		if (arch_make_folio_accessible(folio))
>  			send_sig(SIGSEGV, current, 0);
> -		put_page(page);
> +		folio_put(folio);
>  		mmap_read_unlock(mm);
>  		break;
>  	case KERNEL_FAULT:
> -		page = phys_to_page(addr);
> -		if (unlikely(!try_get_page(page)))
> +		folio = phys_to_folio(addr);
> +		if (unlikely(!folio_try_get(folio)))
>  			break;
> -		rc = arch_make_page_accessible(page);
> -		put_page(page);
> +		rc = arch_make_folio_accessible(folio);
> +		folio_put(folio);
>  		if (rc)
>  			BUG();
>  		break;


