Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6D12331382
	for <lists+kvm@lfdr.de>; Mon,  8 Mar 2021 17:36:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbhCHQf2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Mar 2021 11:35:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:48532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229893AbhCHQfA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Mar 2021 11:35:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4C22365227;
        Mon,  8 Mar 2021 16:34:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615221300;
        bh=/a8q5f9+mgUFjkaLUOWpenLQISW7GAOWifO2INunHhc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=t5mel8PvzyIhShxoDA+EYt9ooh6ur1wDK1mo2e24m54Zx3cROiOtV0NEhX4/3rRSl
         /TlHqZIXfRKvEQOHpJErHsLES1zBkjwEoExPy6eht2zFRgBtMpqY5ls2zXbjfMo3Pn
         C1J3+tV/nHLvKuNv/hMb/40sr4OIwG0Fg7LZfzb5tYfh6bpBtEUMzd9M/XftoY2IeF
         We5ZbQAUx2VgWHkI4eEwybZK2xxJT+l5Sx7kWe/31C2e2rnE/pjyq0ED4mWGN4oG9d
         bfqXkhSEHSlb5p42qw8nyzwEf1xamImHeIz7i9CtXfsH5iv6hd5MXuAR14aqd1Wx3E
         E8wW/7oQAOKsg==
Date:   Mon, 8 Mar 2021 16:34:55 +0000
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
Subject: Re: [PATCH 2/2] KVM: arm64: Skip the cache flush when coalescing
 tables into a block
Message-ID: <20210308163454.GA26561@willie-the-truck>
References: <20210125141044.380156-1-wangyanan55@huawei.com>
 <20210125141044.380156-3-wangyanan55@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210125141044.380156-3-wangyanan55@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 25, 2021 at 10:10:44PM +0800, Yanan Wang wrote:
> After dirty-logging is stopped for a VM configured with huge mappings,
> KVM will recover the table mappings back to block mappings. As we only
> replace the existing page tables with a block entry and the cacheability
> has not been changed, the cache maintenance opreations can be skipped.
> 
> Signed-off-by: Yanan Wang <wangyanan55@huawei.com>
> ---
>  arch/arm64/kvm/mmu.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 8e8549ea1d70..37b427dcbc4f 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -744,7 +744,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  {
>  	int ret = 0;
>  	bool write_fault, writable, force_pte = false;
> -	bool exec_fault;
> +	bool exec_fault, adjust_hugepage;
>  	bool device = false;
>  	unsigned long mmu_seq;
>  	struct kvm *kvm = vcpu->kvm;
> @@ -872,12 +872,18 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  		mark_page_dirty(kvm, gfn);
>  	}
>  
> -	if (fault_status != FSC_PERM && !device)
> +	/*
> +	 * There is no necessity to perform cache maintenance operations if we
> +	 * will only replace the existing table mappings with a block mapping.
> +	 */
> +	adjust_hugepage = fault_granule < vma_pagesize ? true : false;

nit: you don't need the '? true : false' part

That said, your previous patch checks for 'fault_granule > vma_pagesize',
so I'm not sure the local variable helps all that much here because it
obscures the size checks in my opinion. It would be more straight-forward
if we could structure the logic as:


	if (fault_granule < vma_pagesize) {

	} else if (fault_granule > vma_page_size) {

	} else {

	}

With some comments describing what we can infer about the memcache and cache
maintenance requirements for each case.

Will
