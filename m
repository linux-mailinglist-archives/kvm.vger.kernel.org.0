Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 241DE36650E
	for <lists+kvm@lfdr.de>; Wed, 21 Apr 2021 07:53:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235359AbhDUFxc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 01:53:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:60706 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235353AbhDUFx3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 21 Apr 2021 01:53:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618984375;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vqV3nZmtiS3HiblM9X32LHWFH0pNEm2EPbe6NxcNwks=;
        b=BDB5dfpLJOCoiB/tCoDV3QctjgWB4FJM3K8E89T6yzUenBF0qRyT+5LmXQrCCNroJ0xGpj
        xhAFmGt4rkndIfnW+wH2R1e1jT3fpetyimq076xNvsBv2tU5iWRly+CyJsY+ejQWE/fGFw
        aC5LItUzPkXRJJ5WRtgT+npIB9zdiu0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-512-AufqBBdtMVaojJyOUvcMWw-1; Wed, 21 Apr 2021 01:52:53 -0400
X-MC-Unique: AufqBBdtMVaojJyOUvcMWw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 05E118030A0;
        Wed, 21 Apr 2021 05:52:52 +0000 (UTC)
Received: from [10.64.54.47] (vpn2-54-47.bne.redhat.com [10.64.54.47])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 39B086064B;
        Wed, 21 Apr 2021 05:52:48 +0000 (UTC)
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
Message-ID: <960e097d-818b-00bc-b2ee-0da17857f862@redhat.com>
Date:   Wed, 21 Apr 2021 17:52:58 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20210415140328.24200-3-zhukeqian1@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Keqian,

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

I don't understand how VM_PFNMAP is set for hugetlbfs related vma.
I think they are exclusive, meaning the flag is never set for
hugetlbfs vma. If it's true, VM_PFNMAP needn't be checked on hugetlbfs
vma and the VM_BUG_ON() becomes unnecessary.

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

There is "switch(...)" fallback mechanism in user_mem_abort(). PUD_SIZE/PMD_SIZE
can be downgraded accordingly if the addresses fails in the alignment check
by fault_supports_stage2_huge_mapping(). I think it would make user_mem_abort()
simplified if the logic can be moved to get_vma_page_shift().

Another question if we need the check from fault_supports_stage2_huge_mapping()
if VM_PFNMAP area is going to be covered by block mapping. If so, the "switch(...)"
fallback mechanism needs to be part of get_vma_page_shift().

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

Thanks,
Gavin

