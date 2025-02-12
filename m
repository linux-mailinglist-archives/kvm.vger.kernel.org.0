Return-Path: <kvm+bounces-37980-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F3FEAA32DCA
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2025 18:46:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C290E7A1A52
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2025 17:45:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACFE125E468;
	Wed, 12 Feb 2025 17:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Saq/0SK5"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18EEF25D521;
	Wed, 12 Feb 2025 17:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739382351; cv=none; b=SBtdJ4p1UONCrXebMYNBCbWjyhAPTV73Y9avoKFq+iW00Te9uD3wM6DyS9tRIJ8QSGJN9iQz4GfkUDT257KMdRjZrHN5LStiUfEua24pJ71qyKz17VNDfogUye6W/5v8iw+Wt7KnfLdIm3ixRlnHNIF33CNh2if90zzhdswP3qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739382351; c=relaxed/simple;
	bh=uWnxqzLFg0Bk6hPMnOW/Hm6rCmLblCOnLu7WnvyOkDU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JRtn++tsDQKp+XiaBSj8/LgGfhn2/4QZ2Omy3zYzB0KSdfoebPQi79ud67ow3qR2q+XU8eHKrQedSZm6i4sh/6OsAcao6PQF6Rsds4kWBHqZDVnQa25Dzjq8oBRF1axgDc2q+yHnvVdI+LvJql7kdNti4m7UDrKZdL7l6NsDz4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Saq/0SK5; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51CAkpxg012575;
	Wed, 12 Feb 2025 17:45:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=AL76FW
	dvHYokKyWp8ATgLXzU6lv9N4+I90sDD6zM2Q4=; b=Saq/0SK5KD/sWIJHPUuI1+
	fxgUUPhYIFPmENhReWTI8VO59pFFK+MSXTrH7TNZNQSc9dJRex0gya7tpZcbsD37
	KzG+Zh2ZQd8gjO6Cbofsg3omZQPTx1yo/0zUb6+H+2ZbrcRrf95OwN1G5D2YvJwS
	wpsLbpEAEO7O0L4wr+vseQ+GnIFvZuBtxPnj29cyBzE7sqcKryKzDNhwrs+lgPvI
	FENgk8HA7aiVlR/vXNKDyaZcnUutDjGmcmHQh5Zc5c6IvbUxC3y6cb7RxWbqH8DO
	ijSPjcnbGw4I+N5CRDwLYV47USBU+TRE2mpJJPw/YvIYcW1FRvuTBSCBhYCQC9Ig
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44rfpa559g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 12 Feb 2025 17:45:47 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 51CFrJph001051;
	Wed, 12 Feb 2025 17:45:45 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 44pjkna4a1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 12 Feb 2025 17:45:45 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 51CHjfbY29557304
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 12 Feb 2025 17:45:41 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A594A20040;
	Wed, 12 Feb 2025 17:45:41 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 559AB20043;
	Wed, 12 Feb 2025 17:45:41 +0000 (GMT)
Received: from p-imbrenda (unknown [9.171.55.171])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with SMTP;
	Wed, 12 Feb 2025 17:45:41 +0000 (GMT)
Date: Wed, 12 Feb 2025 18:45:38 +0100
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: David Hildenbrand <david@redhat.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, borntraeger@de.ibm.com
Subject: Re: [GIT PULL v2 09/20] KVM: s390: move pv gmap functions into kvm
Message-ID: <20250212184538.3c79d608@p-imbrenda>
In-Reply-To: <d5ef124a-d353-4074-925e-a2721be3ce5d@redhat.com>
References: <20250131112510.48531-1-imbrenda@linux.ibm.com>
	<20250131112510.48531-10-imbrenda@linux.ibm.com>
	<d5ef124a-d353-4074-925e-a2721be3ce5d@redhat.com>
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
X-Proofpoint-GUID: yGKQkFHM1ZYVy36azOMh7Y5FNVfa994u
X-Proofpoint-ORIG-GUID: yGKQkFHM1ZYVy36azOMh7Y5FNVfa994u
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-12_05,2025-02-11_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 malwarescore=0
 mlxscore=0 lowpriorityscore=0 adultscore=0 bulkscore=0 priorityscore=1501
 mlxlogscore=999 clxscore=1015 phishscore=0 impostorscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2501170000
 definitions=main-2502120127

On Wed, 12 Feb 2025 17:55:18 +0100
David Hildenbrand <david@redhat.com> wrote:

> On 31.01.25 12:24, Claudio Imbrenda wrote:
> > Move gmap related functions from kernel/uv into kvm.
> > 
> > Create a new file to collect gmap-related functions.
> > 
> > Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
> > Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
> > [fixed unpack_one(), thanks mhartmay@linux.ibm.com]
> > Link: https://lore.kernel.org/r/20250123144627.312456-6-imbrenda@linux.ibm.com
> > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > Message-ID: <20250123144627.312456-6-imbrenda@linux.ibm.com>
> > ---  
> 
> This patch breaks large folio splitting because you end up un-refing
> the wrong folios after a split; I tried to make it work, but either
> because of other changes in this patch (or in others), I
> cannot get it to work and have to give up for today.

yes, I had also noticed that and I already have a fix ready. In fact my
fix was exactly like yours, except that I did not pass the struct folio
anymore to kvm_s390_wiggle_split_folio(), but instead I only pass a
page and use page_folio() at the beginning, and I use
split_huge_page_to_list_to_order() directly instead of split_folio()
 
unfortunately the fix does not fix the issue I'm seeing....

but putting printks everywhere seems to solve the issue, so it seems to
be a race somewhere

> 
> Running a simple VM backed by memory-backend-memfd
> (which now uses large folios) no longer works (random refcount underflows /
> freeing of wrong pages).
> 
> 
> 
> The following should be required (but according to my testing insufficient):
> 
>  From 71fafff5183c637f20830f6f346e8c9f3eafeb59 Mon Sep 17 00:00:00 2001
> From: David Hildenbrand <david@redhat.com>
> Date: Wed, 12 Feb 2025 16:00:32 +0100
> Subject: [PATCH] KVM: s390: fix splitting of large folios
> 
> If we end up splitting the large folio, doing a put_page() will drop the
> wrong reference (unless it was the head page), because we are holding a
> reference to the old (large) folio. Similarly, doing another
> page_folio() after the split is wrong.
> 
> The result is that we end up freeing a page that is still mapped+used.
> 
> To fix it, let's pass the page and call split_huge_page() instead.
> 
> As an alternative, we could convert all code to use folios, and to
> look up the page again from the page table after our split; however, in
> context of non-uniform folio splits [1], it make sense to pass the page
> where we really want to split.
> 
> [1] https://lkml.kernel.org/r/20250211155034.268962-1-ziy@nvidia.com
> 
> Fixes: 5cbe24350b7d ("KVM: s390: move pv gmap functions into kvm")
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>   arch/s390/include/asm/gmap.h |  3 ++-
>   arch/s390/kvm/gmap.c         |  4 ++--
>   arch/s390/mm/gmap.c          | 13 +++++++++++--
>   3 files changed, 15 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/s390/include/asm/gmap.h b/arch/s390/include/asm/gmap.h
> index 4e73ef46d4b2a..0efa087778135 100644
> --- a/arch/s390/include/asm/gmap.h
> +++ b/arch/s390/include/asm/gmap.h
> @@ -139,7 +139,8 @@ int s390_replace_asce(struct gmap *gmap);
>   void s390_uv_destroy_pfns(unsigned long count, unsigned long *pfns);
>   int __s390_uv_destroy_range(struct mm_struct *mm, unsigned long start,
>   			    unsigned long end, bool interruptible);
> -int kvm_s390_wiggle_split_folio(struct mm_struct *mm, struct folio *folio, bool split);
> +int kvm_s390_wiggle_split_folio(struct mm_struct *mm, struct folio *folio,
> +		struct page *page, bool split);
>   unsigned long *gmap_table_walk(struct gmap *gmap, unsigned long gaddr, int level);
>   
>   /**
> diff --git a/arch/s390/kvm/gmap.c b/arch/s390/kvm/gmap.c
> index 02adf151d4de4..c2523c63afea3 100644
> --- a/arch/s390/kvm/gmap.c
> +++ b/arch/s390/kvm/gmap.c
> @@ -72,7 +72,7 @@ static int __gmap_make_secure(struct gmap *gmap, struct page *page, void *uvcb)
>   		return -EFAULT;
>   	if (folio_test_large(folio)) {
>   		mmap_read_unlock(gmap->mm);
> -		rc = kvm_s390_wiggle_split_folio(gmap->mm, folio, true);
> +		rc = kvm_s390_wiggle_split_folio(gmap->mm, folio, page, true);
>   		mmap_read_lock(gmap->mm);
>   		if (rc)
>   			return rc;
> @@ -100,7 +100,7 @@ static int __gmap_make_secure(struct gmap *gmap, struct page *page, void *uvcb)
>   	/* The folio has too many references, try to shake some off */
>   	if (rc == -EBUSY) {
>   		mmap_read_unlock(gmap->mm);
> -		kvm_s390_wiggle_split_folio(gmap->mm, folio, false);
> +		kvm_s390_wiggle_split_folio(gmap->mm, folio, page, false);
>   		mmap_read_lock(gmap->mm);
>   		return -EAGAIN;
>   	}
> diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
> index 94d9277858009..3180ad90a255a 100644
> --- a/arch/s390/mm/gmap.c
> +++ b/arch/s390/mm/gmap.c
> @@ -2631,12 +2631,18 @@ EXPORT_SYMBOL_GPL(s390_replace_asce);
>    * kvm_s390_wiggle_split_folio() - try to drain extra references to a folio and optionally split
>    * @mm:    the mm containing the folio to work on
>    * @folio: the folio
> + * @page:  the folio page where to split the folio
>    * @split: whether to split a large folio
>    *
> + * If a split of a large folio was requested, the original provided folio must
> + * no longer be used if this function returns 0. The new folio must be looked
> + * up using page_folio(), to which we will then hold a reference.
> + *
>    * Context: Must be called while holding an extra reference to the folio;
>    *          the mm lock should not be held.
>    */
> -int kvm_s390_wiggle_split_folio(struct mm_struct *mm, struct folio *folio, bool split)
> +int kvm_s390_wiggle_split_folio(struct mm_struct *mm, struct folio *folio,
> +		struct page *page, bool split)
>   {
>   	int rc;
>   
> @@ -2645,7 +2651,10 @@ int kvm_s390_wiggle_split_folio(struct mm_struct *mm, struct folio *folio, bool
>   	lru_add_drain_all();
>   	if (split) {
>   		folio_lock(folio);
> -		rc = split_folio(folio);
> +		/* Careful: split_folio() would be wrong. */
> +		rc = split_huge_page(page);
> +		if (!rc)
> +			folio = page_folio(page);
>   		folio_unlock(folio);
>   
>   		if (rc != -EBUSY)


