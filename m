Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87B9A36890F
	for <lists+kvm@lfdr.de>; Fri, 23 Apr 2021 00:37:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239657AbhDVWho (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Apr 2021 18:37:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30704 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232844AbhDVWhm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 22 Apr 2021 18:37:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619131027;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FIN9E2GU73DP80qk98W7edTbeO39ckNz6/z6iV+ZVaE=;
        b=F8OX1fYZPjJ3P9ffvivR1EWCy9p3/udQKuzjNBJY0DwhjJPnOqz/5aX78F3kZppQ+Idybw
        gE3jsUaGH9S0Sd7uL+KM7KsLQ171DFovGZSOR/WzCKiYrjbrvbu+Rq6TBFzNztLN6lrYzX
        xvYoNYT5Eiy+mLSu2ZZii8i8tbLmbJg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-425-qt4M-qynM1mJku2DtY-EmA-1; Thu, 22 Apr 2021 18:37:05 -0400
X-MC-Unique: qt4M-qynM1mJku2DtY-EmA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E57C71927800;
        Thu, 22 Apr 2021 22:37:03 +0000 (UTC)
Received: from [10.64.54.94] (vpn2-54-94.bne.redhat.com [10.64.54.94])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5F8195C3E9;
        Thu, 22 Apr 2021 22:37:00 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v4 2/2] kvm/arm64: Try stage2 block mapping for host
 device MMIO
To:     Keqian Zhu <zhukeqian1@huawei.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>
Cc:     wanghaibin.wang@huawei.com
References: <20210415140328.24200-1-zhukeqian1@huawei.com>
 <20210415140328.24200-3-zhukeqian1@huawei.com>
From:   Gavin Shan <gshan@redhat.com>
Message-ID: <b201abab-a183-8014-884b-436018c6f71a@redhat.com>
Date:   Fri, 23 Apr 2021 10:37:12 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20210415140328.24200-3-zhukeqian1@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/16/21 12:03 AM, Keqian Zhu wrote:
> The MMIO region of a device maybe huge (GB level), try to use
> block mapping in stage2 to speedup both map and unmap.
> 
> Compared to normal memory mapping, we should consider two more
> points when try block mapping for MMIO region:
> 
> 1. For normal memory mapping, the PA(host physical address) and
> HVA have same alignment within PUD_SIZE or PMD_SIZE when we use
> the HVA to request hugepage, so we don't need to consider PA
> alignment when verifing block mapping. But for device memory
> mapping, the PA and HVA may have different alignment.
> 
> 2. For normal memory mapping, we are sure hugepage size properly
> fit into vma, so we don't check whether the mapping size exceeds
> the boundary of vma. But for device memory mapping, we should pay
> attention to this.
> 
> This adds get_vma_page_shift() to get page shift for both normal
> memory and device MMIO region, and check these two points when
> selecting block mapping size for MMIO region.
> 
> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
> ---
>   arch/arm64/kvm/mmu.c | 61 ++++++++++++++++++++++++++++++++++++--------
>   1 file changed, 51 insertions(+), 10 deletions(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index c59af5ca01b0..5a1cc7751e6d 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -738,6 +738,35 @@ transparent_hugepage_adjust(struct kvm_memory_slot *memslot,
>   	return PAGE_SIZE;
>   }
>   
> +static int get_vma_page_shift(struct vm_area_struct *vma, unsigned long hva)
> +{
> +	unsigned long pa;
> +
> +	if (is_vm_hugetlb_page(vma) && !(vma->vm_flags & VM_PFNMAP))
> +		return huge_page_shift(hstate_vma(vma));
> +
> +	if (!(vma->vm_flags & VM_PFNMAP))
> +		return PAGE_SHIFT;
> +
> +	VM_BUG_ON(is_vm_hugetlb_page(vma));
> +
> +	pa = (vma->vm_pgoff << PAGE_SHIFT) + (hva - vma->vm_start);
> +
> +#ifndef __PAGETABLE_PMD_FOLDED
> +	if ((hva & (PUD_SIZE - 1)) == (pa & (PUD_SIZE - 1)) &&
> +	    ALIGN_DOWN(hva, PUD_SIZE) >= vma->vm_start &&
> +	    ALIGN(hva, PUD_SIZE) <= vma->vm_end)
> +		return PUD_SHIFT;
> +#endif
> +
> +	if ((hva & (PMD_SIZE - 1)) == (pa & (PMD_SIZE - 1)) &&
> +	    ALIGN_DOWN(hva, PMD_SIZE) >= vma->vm_start &&
> +	    ALIGN(hva, PMD_SIZE) <= vma->vm_end)
> +		return PMD_SHIFT;
> +
> +	return PAGE_SHIFT;
> +}
> +
>   static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>   			  struct kvm_memory_slot *memslot, unsigned long hva,
>   			  unsigned long fault_status)
> @@ -769,7 +798,10 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>   		return -EFAULT;
>   	}
>   
> -	/* Let's check if we will get back a huge page backed by hugetlbfs */
> +	/*
> +	 * Let's check if we will get back a huge page backed by hugetlbfs, or
> +	 * get block mapping for device MMIO region.
> +	 */
>   	mmap_read_lock(current->mm);
>   	vma = find_vma_intersection(current->mm, hva, hva + 1);
>   	if (unlikely(!vma)) {
> @@ -778,15 +810,15 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>   		return -EFAULT;
>   	}
>   
> -	if (is_vm_hugetlb_page(vma))
> -		vma_shift = huge_page_shift(hstate_vma(vma));
> -	else
> -		vma_shift = PAGE_SHIFT;
> -
> -	if (logging_active ||
> -	    (vma->vm_flags & VM_PFNMAP)) {
> +	/*
> +	 * logging_active is guaranteed to never be true for VM_PFNMAP
> +	 * memslots.
> +	 */
> +	if (logging_active) {
>   		force_pte = true;
>   		vma_shift = PAGE_SHIFT;
> +	} else {
> +		vma_shift = get_vma_page_shift(vma, hva);
>   	}
>   
>   	switch (vma_shift) {
> @@ -854,8 +886,17 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>   		return -EFAULT;
>   
>   	if (kvm_is_device_pfn(pfn)) {
> +		/*
> +		 * If the page was identified as device early by looking at
> +		 * the VMA flags, vma_pagesize is already representing the
> +		 * largest quantity we can map.  If instead it was mapped
> +		 * via gfn_to_pfn_prot(), vma_pagesize is set to PAGE_SIZE
> +		 * and must not be upgraded.
> +		 *
> +		 * In both cases, we don't let transparent_hugepage_adjust()
> +		 * change things at the last minute.
> +		 */
>   		device = true;
> -		force_pte = true;
>   	} else if (logging_active && !write_fault) {
>   		/*
>   		 * Only actually map the page as writable if this was a write
> @@ -876,7 +917,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>   	 * If we are not forced to use page mapping, check if we are
>   	 * backed by a THP and thus use block mapping if possible.
>   	 */
> -	if (vma_pagesize == PAGE_SIZE && !force_pte)
> +	if (vma_pagesize == PAGE_SIZE && !(force_pte || device))
>   		vma_pagesize = transparent_hugepage_adjust(memslot, hva,
>   							   &pfn, &fault_ipa);
>   	if (writable)
> 

