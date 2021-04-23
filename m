Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D54336890C
	for <lists+kvm@lfdr.de>; Fri, 23 Apr 2021 00:36:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237047AbhDVWgm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Apr 2021 18:36:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28524 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232844AbhDVWgk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 22 Apr 2021 18:36:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619130965;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oCrQMIGOiPSDFBMRTF4r7RFudjb0OnYoOwI0UV/Dgh4=;
        b=esJGnRhkq52WpBbiWhqW1ziBTzzqQW4T21uKbyseuwt9EWpEmxknqD7Vl0vqj780PKNSV/
        uxLYAUskUx37nJvfmUajgO7gBtPbjwVFmTnD4f/AoPJ4x7SBMrfeVrAYRe4NeGFhMHRyWJ
        RokT8VMt6NxR7mg7e0iNDaOoX2TaTPk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-517-9OfPzJ6POMqYjjuQxS-VAQ-1; Thu, 22 Apr 2021 18:36:02 -0400
X-MC-Unique: 9OfPzJ6POMqYjjuQxS-VAQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2B92210054F6;
        Thu, 22 Apr 2021 22:36:01 +0000 (UTC)
Received: from [10.64.54.94] (vpn2-54-94.bne.redhat.com [10.64.54.94])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 677C460BE5;
        Thu, 22 Apr 2021 22:35:58 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v4 1/2] kvm/arm64: Remove the creation time's mapping of
 MMIO regions
To:     Keqian Zhu <zhukeqian1@huawei.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>
References: <20210415140328.24200-1-zhukeqian1@huawei.com>
 <20210415140328.24200-2-zhukeqian1@huawei.com>
From:   Gavin Shan <gshan@redhat.com>
Message-ID: <b3da0d70-30e4-e128-cb76-16d335829541@redhat.com>
Date:   Fri, 23 Apr 2021 10:36:09 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20210415140328.24200-2-zhukeqian1@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/16/21 12:03 AM, Keqian Zhu wrote:
> The MMIO regions may be unmapped for many reasons and can be remapped
> by stage2 fault path. Map MMIO regions at creation time becomes a
> minor optimization and makes these two mapping path hard to sync.
> 
> Remove the mapping code while keep the useful sanity check.
> 
> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
> ---
>   arch/arm64/kvm/mmu.c | 38 +++-----------------------------------
>   1 file changed, 3 insertions(+), 35 deletions(-)
>

Reviewed-by: Gavin Shan <gshan@redhat.com>

  
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 8711894db8c2..c59af5ca01b0 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1301,7 +1301,6 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
>   {
>   	hva_t hva = mem->userspace_addr;
>   	hva_t reg_end = hva + mem->memory_size;
> -	bool writable = !(mem->flags & KVM_MEM_READONLY);
>   	int ret = 0;
>   
>   	if (change != KVM_MR_CREATE && change != KVM_MR_MOVE &&
> @@ -1318,8 +1317,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
>   	mmap_read_lock(current->mm);
>   	/*
>   	 * A memory region could potentially cover multiple VMAs, and any holes
> -	 * between them, so iterate over all of them to find out if we can map
> -	 * any of them right now.
> +	 * between them, so iterate over all of them.
>   	 *
>   	 *     +--------------------------------------------+
>   	 * +---------------+----------------+   +----------------+
> @@ -1330,50 +1328,20 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
>   	 */
>   	do {
>   		struct vm_area_struct *vma = find_vma(current->mm, hva);
> -		hva_t vm_start, vm_end;
>   
>   		if (!vma || vma->vm_start >= reg_end)
>   			break;
>   
> -		/*
> -		 * Take the intersection of this VMA with the memory region
> -		 */
> -		vm_start = max(hva, vma->vm_start);
> -		vm_end = min(reg_end, vma->vm_end);
> -
>   		if (vma->vm_flags & VM_PFNMAP) {
> -			gpa_t gpa = mem->guest_phys_addr +
> -				    (vm_start - mem->userspace_addr);
> -			phys_addr_t pa;
> -
> -			pa = (phys_addr_t)vma->vm_pgoff << PAGE_SHIFT;
> -			pa += vm_start - vma->vm_start;
> -
>   			/* IO region dirty page logging not allowed */
>   			if (memslot->flags & KVM_MEM_LOG_DIRTY_PAGES) {
>   				ret = -EINVAL;
> -				goto out;
> -			}
> -
> -			ret = kvm_phys_addr_ioremap(kvm, gpa, pa,
> -						    vm_end - vm_start,
> -						    writable);
> -			if (ret)
>   				break;
> +			}
>   		}
> -		hva = vm_end;
> +		hva = min(reg_end, vma->vm_end);
>   	} while (hva < reg_end);
>   
> -	if (change == KVM_MR_FLAGS_ONLY)
> -		goto out;
> -
> -	spin_lock(&kvm->mmu_lock);
> -	if (ret)
> -		unmap_stage2_range(&kvm->arch.mmu, mem->guest_phys_addr, mem->memory_size);
> -	else if (!cpus_have_final_cap(ARM64_HAS_STAGE2_FWB))
> -		stage2_flush_memslot(kvm, memslot);
> -	spin_unlock(&kvm->mmu_lock);
> -out:
>   	mmap_read_unlock(current->mm);
>   	return ret;
>   }
> 

