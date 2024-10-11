Return-Path: <kvm+bounces-28611-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F1FB99A29D
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 13:21:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B5FC7B24EC6
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 11:21:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43093216449;
	Fri, 11 Oct 2024 11:21:40 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A5D03D64;
	Fri, 11 Oct 2024 11:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728645699; cv=none; b=EnaOF3dSTAF5o7QrwWasCeHrM0aqGN10SdSIGf7lBUO1TI3/95qBoyCjA0/aXP0+DCQ/IAVB6nLNU5nDJZrG3p2/kQ8NTgdyryaVxLBFZ7oKZOXW/fDTCIliBUqRudQWUNfyNdeGm4P3cpAoOppWwzM1RlGyx0P19UlbWiDKMJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728645699; c=relaxed/simple;
	bh=xL0URaUxHtaSXtH5PsRUYkQ8i/Wvh6VBzDWj0/MIm4M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mms7pE4M2QcgEgOX2RoMZ1Bqxzb5WO/+o1JSRA+e/1JTMyGPtUoLlyk5I3A2NBYTP77H9E3z4QnPnuRkjWCX0AlHo2GOmghGSNTHv3wh781dhetthlzrRXY4MuH6VvhwM8oSdOVnw1cNQY0WIcLcXD6wRpaH92MddKprbIeFdy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1E1AF497;
	Fri, 11 Oct 2024 04:22:06 -0700 (PDT)
Received: from [10.57.85.162] (unknown [10.57.85.162])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A2EE63F73F;
	Fri, 11 Oct 2024 04:21:34 -0700 (PDT)
Message-ID: <262aa3c4-fdcc-4971-bbbb-024b9086d6c3@arm.com>
Date: Fri, 11 Oct 2024 12:21:32 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 1/2] mm: huge_memory: add vma_thp_disabled() and
 thp_disabled_by_hw()
To: David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, kvm@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
 Thomas Huth <thuth@redhat.com>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 Kefeng Wang <wangkefeng.wang@huawei.com>
References: <20241011102445.934409-1-david@redhat.com>
 <20241011102445.934409-2-david@redhat.com>
Content-Language: en-GB
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <20241011102445.934409-2-david@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/10/2024 11:24, David Hildenbrand wrote:
> From: Kefeng Wang <wangkefeng.wang@huawei.com>
> 
> Add vma_thp_disabled() and thp_disabled_by_hw() helpers to be shared by
> shmem_allowable_huge_orders() and __thp_vma_allowable_orders().
> 
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> [ rename to vma_thp_disabled(), split out thp_disabled_by_hw() ]
> Signed-off-by: David Hildenbrand <david@redhat.com>

Looks like a nice tidy up on its own:

Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>

> ---
>  include/linux/huge_mm.h | 18 ++++++++++++++++++
>  mm/huge_memory.c        | 13 +------------
>  mm/shmem.c              |  7 +------
>  3 files changed, 20 insertions(+), 18 deletions(-)
> 
> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> index 67d0ab3c3bba..ef5b80e48599 100644
> --- a/include/linux/huge_mm.h
> +++ b/include/linux/huge_mm.h
> @@ -322,6 +322,24 @@ struct thpsize {
>  	(transparent_hugepage_flags &					\
>  	 (1<<TRANSPARENT_HUGEPAGE_USE_ZERO_PAGE_FLAG))
>  
> +static inline bool vma_thp_disabled(struct vm_area_struct *vma,
> +		unsigned long vm_flags)
> +{
> +	/*
> +	 * Explicitly disabled through madvise or prctl, or some
> +	 * architectures may disable THP for some mappings, for
> +	 * example, s390 kvm.
> +	 */
> +	return (vm_flags & VM_NOHUGEPAGE) ||
> +	       test_bit(MMF_DISABLE_THP, &vma->vm_mm->flags);
> +}
> +
> +static inline bool thp_disabled_by_hw(void)
> +{
> +	/* If the hardware/firmware marked hugepage support disabled. */
> +	return transparent_hugepage_flags & (1 << TRANSPARENT_HUGEPAGE_UNSUPPORTED);
> +}
> +
>  unsigned long thp_get_unmapped_area(struct file *filp, unsigned long addr,
>  		unsigned long len, unsigned long pgoff, unsigned long flags);
>  unsigned long thp_get_unmapped_area_vmflags(struct file *filp, unsigned long addr,
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 87b49ecc7b1e..2fb328880b50 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -109,18 +109,7 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
>  	if (!vma->vm_mm)		/* vdso */
>  		return 0;
>  
> -	/*
> -	 * Explicitly disabled through madvise or prctl, or some
> -	 * architectures may disable THP for some mappings, for
> -	 * example, s390 kvm.
> -	 * */
> -	if ((vm_flags & VM_NOHUGEPAGE) ||
> -	    test_bit(MMF_DISABLE_THP, &vma->vm_mm->flags))
> -		return 0;
> -	/*
> -	 * If the hardware/firmware marked hugepage support disabled.
> -	 */
> -	if (transparent_hugepage_flags & (1 << TRANSPARENT_HUGEPAGE_UNSUPPORTED))
> +	if (thp_disabled_by_hw() || vma_thp_disabled(vma, vm_flags))
>  		return 0;
>  
>  	/* khugepaged doesn't collapse DAX vma, but page fault is fine. */
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 4f11b5506363..c5adb987b23c 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -1664,12 +1664,7 @@ unsigned long shmem_allowable_huge_orders(struct inode *inode,
>  	loff_t i_size;
>  	int order;
>  
> -	if (vma && ((vm_flags & VM_NOHUGEPAGE) ||
> -	    test_bit(MMF_DISABLE_THP, &vma->vm_mm->flags)))
> -		return 0;
> -
> -	/* If the hardware/firmware marked hugepage support disabled. */
> -	if (transparent_hugepage_flags & (1 << TRANSPARENT_HUGEPAGE_UNSUPPORTED))
> +	if (thp_disabled_by_hw() || (vma && vma_thp_disabled(vma, vm_flags)))
>  		return 0;
>  
>  	global_huge = shmem_huge_global_enabled(inode, index, write_end,


