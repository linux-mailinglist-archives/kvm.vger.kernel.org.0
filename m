Return-Path: <kvm+bounces-40336-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 30417A568AF
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 14:19:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8C36E3A8116
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 13:18:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3060218AAB;
	Fri,  7 Mar 2025 13:18:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="IxxleyoU"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F82820968E;
	Fri,  7 Mar 2025 13:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741353527; cv=none; b=brDsFHkxGjB1FsslgWQznpS0QVJ7fTcA3gdsW3GW3LApCTh3PdBhCuz/jWBmqADy9SC9M3YS3C6xczKWNLJNVIpOAuarqQ04dDfbxhXXmwoWkKCXIrqecbH/U4T56qF+GkHEusy++K3f5+ntfoeEVwe6GPw6U63EifwESBicmyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741353527; c=relaxed/simple;
	bh=yTWuwDWY+zi+Wf/VdFJyCria5v6dEIMxIs0g9Tc7NnE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jx6Meh5upAducROF+qa0W6xf+fEkBUxNgYf1kCbfhMMMAR1rfMEACZAjPz/wEfI+9eu+lTUsuP2AiDcraDhvPnjUGrRd+J2CHubcs20F54xVcZRPS3U+IYQqDnEzgnUIioasSl3PhX/nuHyEIRRUe2RjjqPFFhLTNaDNPkJ0Kqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=IxxleyoU; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5278SXOd019419;
	Fri, 7 Mar 2025 13:18:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=t0qCIT
	dvTbKE9hCZos/dy3JCp5YTaXaJqKP81zJoySQ=; b=IxxleyoUle/so3vmRtwO5k
	Egrr3+qMKYBlMgq0q1g4BLViKBVg8jAfDxyKvuzpspNEbXo2AQTxHqVh+xZvWZnS
	ssByGcr67RLXBZ+g3FY/zQb6olC2ZZpargjNutVGfZR0To8c16UkIlVCHoyqghPy
	FJlmiHLI2VJT9CLfUqo9SvF3jnuKk5/EDg7XAkuVf6mPk6uUYiKi8lLYcob73vCQ
	ueUNWn+Lg5AGKS/EaafVsBsKBAeld4aVh5X6LF1KXBqRthWoX6cVBQKyJ0a6ZsPI
	/MyNAmh7gHQM/lNYWit49GjwMLff68ZNL6dABEoyae+iqvK+396pdVOuZfNTW8GA
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 457d4p68nv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 07 Mar 2025 13:18:41 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 527BL1C8025026;
	Fri, 7 Mar 2025 13:18:40 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 454f92eghq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 07 Mar 2025 13:18:40 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 527DIbhI26280300
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 7 Mar 2025 13:18:37 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3A68E2004D;
	Fri,  7 Mar 2025 13:18:37 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CD74020040;
	Fri,  7 Mar 2025 13:18:36 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri,  7 Mar 2025 13:18:36 +0000 (GMT)
Date: Fri, 7 Mar 2025 14:18:33 +0100
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: David Hildenbrand <david@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, nrb@linux.ibm.com, seiden@linux.ibm.com,
        nsg@linux.ibm.com, schlameuss@linux.ibm.com, hca@linux.ibm.com
Subject: Re: [PATCH v4 1/1] KVM: s390: pv: fix race when making a page
 secure
Message-ID: <20250307141833.0162e827@p-imbrenda>
In-Reply-To: <af3739da-771a-4987-86b7-d6f7f82252f6@redhat.com>
References: <20250304182304.178746-1-imbrenda@linux.ibm.com>
	<20250304182304.178746-2-imbrenda@linux.ibm.com>
	<c60e60a2-07ed-4692-8952-c125c34122f8@redhat.com>
	<af3739da-771a-4987-86b7-d6f7f82252f6@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: xjmoY31Vz8wk1O4Nrt4BtphiYHAiAhsK
X-Proofpoint-ORIG-GUID: xjmoY31Vz8wk1O4Nrt4BtphiYHAiAhsK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-07_05,2025-03-06_04,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 suspectscore=0 clxscore=1015 phishscore=0 priorityscore=1501 bulkscore=0
 lowpriorityscore=0 mlxlogscore=999 adultscore=0 impostorscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2502100000 definitions=main-2503070095

On Thu, 6 Mar 2025 23:07:04 +0100
David Hildenbrand <david@redhat.com> wrote:

> On 06.03.25 11:23, David Hildenbrand wrote:
> >>    /**
> >> - * make_folio_secure() - make a folio secure
> >> + * __make_folio_secure() - make a folio secure
> >>     * @folio: the folio to make secure
> >>     * @uvcb: the uvcb that describes the UVC to be used
> >>     *
> >> @@ -243,14 +276,13 @@ static int expected_folio_refs(struct folio *folio)
> >>     *         -EINVAL if the UVC failed for other reasons.
> >>     *
> >>     * Context: The caller must hold exactly one extra reference on the folio
> >> - *          (it's the same logic as split_folio())
> >> + *          (it's the same logic as split_folio()), and the folio must be
> >> + *          locked.
> >>     */
> >> -int make_folio_secure(struct folio *folio, struct uv_cb_header *uvcb)
> >> +static int __make_folio_secure(struct folio *folio, struct uv_cb_header *uvcb)  
> > 
> > One more nit: -EBUSY can no longer be returned from his function, so you
> > might just remove it from the doc above.
> > 
> > 
> > While chasing a very weird folio split bug that seems to result in late
> > validation issues (:/), I was wondering if __gmap_destroy_page could
> > similarly be problematic.
> > 
> > We're now no longer holding the PTL while performing the operation.
> > 
> > (not that that would explain the issue I am chasing, because
> > gmap_destroy_page() is never called in my setup)
> >   
> 
> Okay, I've been debugging for way to long the weird issue I am seeing, and I
> did not find the root cause yet. But the following things are problematic:
> 
> 1) To walk the page tables, we need the mmap lock in read mode.
> 
> 2) To walk the page tables, we must know that a VMA exists
> 
> 3) get_locked_pte() must not be used on hugetlb areas.
> 
> Further, the following things should be cleaned up
> 
> 4) s390_wiggle_split_folio() is only used in that file
> 
> 5) gmap_make_secure() likely should be returning -EFAULT
> 
> 
> See below, I went with a folio_walk (which also checks for pte_present()
> like the old code did, but that should not matter here) so we can get rid of the
> get_locked_pte() usage completely.

I shall merge this into my patch, thanks a lot!

> 
> 
>  From 1b9a4306b79a352daf80708252d166114e7335de Mon Sep 17 00:00:00 2001
> From: David Hildenbrand <david@redhat.com>
> Date: Thu, 6 Mar 2025 22:43:43 +0100
> Subject: [PATCH] merge
> 
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>   arch/s390/include/asm/uv.h |  1 -
>   arch/s390/kernel/uv.c      | 41 ++++++++++++++++++--------------------
>   arch/s390/kvm/gmap.c       |  2 +-
>   3 files changed, 20 insertions(+), 24 deletions(-)
> 
> diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
> index fa33a6ff2fabf..46fb0ef6f9847 100644
> --- a/arch/s390/include/asm/uv.h
> +++ b/arch/s390/include/asm/uv.h
> @@ -634,7 +634,6 @@ int uv_convert_from_secure_pte(pte_t pte);
>   int make_hva_secure(struct mm_struct *mm, unsigned long hva, struct uv_cb_header *uvcb);
>   int uv_convert_from_secure(unsigned long paddr);
>   int uv_convert_from_secure_folio(struct folio *folio);
> -int s390_wiggle_split_folio(struct mm_struct *mm, struct folio *folio, bool split);
>   
>   void setup_uv(void);
>   
> diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
> index 63420a5f3ee57..11a1894e63405 100644
> --- a/arch/s390/kernel/uv.c
> +++ b/arch/s390/kernel/uv.c
> @@ -270,7 +270,6 @@ static int expected_folio_refs(struct folio *folio)
>    *
>    * Return: 0 on success;
>    *         -EBUSY if the folio is in writeback or has too many references;
> - *         -E2BIG if the folio is large;
>    *         -EAGAIN if the UVC needs to be attempted again;
>    *         -ENXIO if the address is not mapped;
>    *         -EINVAL if the UVC failed for other reasons.
> @@ -324,17 +323,6 @@ static int make_folio_secure(struct mm_struct *mm, struct folio *folio, struct u
>   	return rc;
>   }
>   
> -static pte_t *get_locked_valid_pte(struct mm_struct *mm, unsigned long hva, spinlock_t **ptl)
> -{
> -	pte_t *ptep = get_locked_pte(mm, hva, ptl);
> -
> -	if (ptep && (pte_val(*ptep) & _PAGE_INVALID)) {
> -		pte_unmap_unlock(ptep, *ptl);
> -		ptep = NULL;
> -	}
> -	return ptep;
> -}
> -
>   /**
>    * s390_wiggle_split_folio() - try to drain extra references to a folio and optionally split
>    * @mm:    the mm containing the folio to work on
> @@ -344,7 +332,7 @@ static pte_t *get_locked_valid_pte(struct mm_struct *mm, unsigned long hva, spin
>    * Context: Must be called while holding an extra reference to the folio;
>    *          the mm lock should not be held.
>    */
> -int s390_wiggle_split_folio(struct mm_struct *mm, struct folio *folio, bool split)
> +static int s390_wiggle_split_folio(struct mm_struct *mm, struct folio *folio, bool split)
>   {
>   	int rc;
>   
> @@ -361,20 +349,28 @@ int s390_wiggle_split_folio(struct mm_struct *mm, struct folio *folio, bool spli
>   	}
>   	return -EAGAIN;
>   }
> -EXPORT_SYMBOL_GPL(s390_wiggle_split_folio);
>   
>   int make_hva_secure(struct mm_struct *mm, unsigned long hva, struct uv_cb_header *uvcb)
>   {
> +	struct vm_area_struct *vma;
> +	struct folio_walk fw;
>   	struct folio *folio;
> -	spinlock_t *ptelock;
> -	pte_t *ptep;
>   	int rc;
>   
> -	ptep = get_locked_valid_pte(mm, hva, &ptelock);
> -	if (!ptep)
> +	mmap_read_lock(mm);
> +
> +	vma = vma_lookup(mm, hva);
> +	if (!vma) {
> +		mmap_read_unlock(mm);
> +		return -EFAULT;
> +	}
> +
> +	folio = folio_walk_start(&fw, vma, hva, 0);
> +	if (!folio) {
> +		mmap_read_unlock(mm);
>   		return -ENXIO;
> +	}
>   
> -	folio = page_folio(pte_page(*ptep));
>   	folio_get(folio);
>   	/*
>   	 * Secure pages cannot be huge and userspace should not combine both.
> @@ -385,14 +381,15 @@ int make_hva_secure(struct mm_struct *mm, unsigned long hva, struct uv_cb_header
>   	 * KVM_RUN will return -EFAULT.
>   	 */
>   	if (folio_test_hugetlb(folio))
> -		rc =  -EFAULT;
> +		rc = -EFAULT;
>   	else if (folio_test_large(folio))
>   		rc = -E2BIG;
> -	else if (!pte_write(*ptep))
> +	else if (!pte_write(fw.pte) || (pte_val(fw.pte) & _PAGE_INVALID))
>   		rc = -ENXIO;
>   	else
>   		rc = make_folio_secure(mm, folio, uvcb);
> -	pte_unmap_unlock(ptep, ptelock);
> +	folio_walk_end(&fw, vma);
> +	mmap_read_unlock(mm);
>   
>   	if (rc == -E2BIG || rc == -EBUSY)
>   		rc = s390_wiggle_split_folio(mm, folio, rc == -E2BIG);
> diff --git a/arch/s390/kvm/gmap.c b/arch/s390/kvm/gmap.c
> index 21580cfecc6ac..1a88b32e7c134 100644
> --- a/arch/s390/kvm/gmap.c
> +++ b/arch/s390/kvm/gmap.c
> @@ -41,7 +41,7 @@ int gmap_make_secure(struct gmap *gmap, unsigned long gaddr, void *uvcb)
>   
>   	vmaddr = gfn_to_hva(kvm, gpa_to_gfn(gaddr));
>   	if (kvm_is_error_hva(vmaddr))
> -		rc = -ENXIO;
> +		rc = -EFAULT;
>   	else
>   		rc = make_hva_secure(gmap->mm, vmaddr, uvcb);
>   


