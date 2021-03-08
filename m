Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 006AA331384
	for <lists+kvm@lfdr.de>; Mon,  8 Mar 2021 17:36:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230286AbhCHQf3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Mar 2021 11:35:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:48588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229971AbhCHQfV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Mar 2021 11:35:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E834965227;
        Mon,  8 Mar 2021 16:35:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615221320;
        bh=aB3ELpHAsNqPMSU1NTeVXZu4tkER3Fw968tuBoPwCbA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UWctiQnaYW8/k1Yb9drt1Gx33SIx53VEr9QUvBFtO++cSktio2IJ0zfV/ewCRZarp
         336YuKkMtHXRSuYBavY39s4mbcMYiHtBWr+sRvWGZ5lHGSrbfP2i3cT6bD3IXB5dK9
         XG0wo0LtPIgiU1G/ZSF3cH7a/ODuX4Kng0qGTuOltSSMi8YqXBiBF/+fT0PUpovADG
         83SbF/T2HmBE5FmqBDw1IlC7Fjl6d5Uw9lO45d1PRrtuH7UwKIwqi7eTN8EMhz3x95
         Z7z0loOP+g5/iO2/WDVCxGD5NF44agOCV8FrKagw7dGRiIx0vYS9+tRbTqTzhu1BTI
         sZ5LT0LmUIgug==
Date:   Mon, 8 Mar 2021 16:35:16 +0000
From:   Will Deacon <will@kernel.org>
To:     Yanan Wang <wangyanan55@huawei.com>
Cc:     Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        wanghaibin.wang@huawei.com, yuzenghui@huawei.com
Subject: Re: [PATCH 1/2] KVM: arm64: Distinguish cases of allocating memcache
 more precisely
Message-ID: <20210308163515.GB26561@willie-the-truck>
References: <20210125141044.380156-1-wangyanan55@huawei.com>
 <20210125141044.380156-2-wangyanan55@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210125141044.380156-2-wangyanan55@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 25, 2021 at 10:10:43PM +0800, Yanan Wang wrote:
> With a guest translation fault, we don't really need the memcache pages
> when only installing a new entry to the existing page table or replacing
> the table entry with a block entry. And with a guest permission fault,
> we also don't need the memcache pages for a write_fault in dirty-logging
> time if VMs are not configured with huge mappings.
> 
> The cases where allocations from memcache are required can be much more
> precisely distinguished by comparing fault_granule and vma_pagesize.
> 
> Signed-off-by: Yanan Wang <wangyanan55@huawei.com>
> ---
>  arch/arm64/kvm/mmu.c | 25 ++++++++++++-------------
>  1 file changed, 12 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 7d2257cc5438..8e8549ea1d70 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -820,19 +820,6 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  	gfn = fault_ipa >> PAGE_SHIFT;
>  	mmap_read_unlock(current->mm);
>  
> -	/*
> -	 * Permission faults just need to update the existing leaf entry,
> -	 * and so normally don't require allocations from the memcache. The
> -	 * only exception to this is when dirty logging is enabled at runtime
> -	 * and a write fault needs to collapse a block entry into a table.
> -	 */
> -	if (fault_status != FSC_PERM || (logging_active && write_fault)) {
> -		ret = kvm_mmu_topup_memory_cache(memcache,
> -						 kvm_mmu_cache_min_pages(kvm));
> -		if (ret)
> -			return ret;
> -	}
> -
>  	mmu_seq = vcpu->kvm->mmu_notifier_seq;
>  	/*
>  	 * Ensure the read of mmu_notifier_seq happens before we call
> @@ -898,6 +885,18 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  	else if (cpus_have_const_cap(ARM64_HAS_CACHE_DIC))
>  		prot |= KVM_PGTABLE_PROT_X;
>  
> +	/*
> +	 * Allocations from the memcache are required only when granule of the
> +	 * lookup level where a guest fault happened exceeds the vma_pagesize,
> +	 * which means new page tables will be created in the fault handlers.
> +	 */
> +	if (fault_granule > vma_pagesize) {
> +		ret = kvm_mmu_topup_memory_cache(memcache,
> +						 kvm_mmu_cache_min_pages(kvm));
> +		if (ret)
> +			return ret;
> +	}

This feels like it could bite us in future as the code evolves but people
forget to reconsider this check. Maybe it would be better to extend this
patch so that we handle getting -ENOMEM back and try a second time after
topping up the memcache?

Will
