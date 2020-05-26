Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02FC31E2136
	for <lists+kvm@lfdr.de>; Tue, 26 May 2020 13:49:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731674AbgEZLtd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 May 2020 07:49:33 -0400
Received: from foss.arm.com ([217.140.110.172]:49816 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726756AbgEZLtd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 May 2020 07:49:33 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 16B8630E;
        Tue, 26 May 2020 04:49:32 -0700 (PDT)
Received: from gaia (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B510E3F6C4;
        Tue, 26 May 2020 04:49:29 -0700 (PDT)
Date:   Tue, 26 May 2020 12:49:27 +0100
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Keqian Zhu <zhukeqian1@huawei.com>
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Will Deacon <will@kernel.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexios Zavras <alexios.zavras@intel.com>,
        wanghaibin.wang@huawei.com, zhengxiang9@huawei.com,
        Peng Liang <liangpeng10@huawei.com>
Subject: Re: [RFC PATCH 2/7] KVM: arm64: Set DBM bit of PTEs if hw DBM enabled
Message-ID: <20200526114926.GD17051@gaia>
References: <20200525112406.28224-1-zhukeqian1@huawei.com>
 <20200525112406.28224-3-zhukeqian1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200525112406.28224-3-zhukeqian1@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 25, 2020 at 07:24:01PM +0800, Keqian Zhu wrote:
> diff --git a/arch/arm64/include/asm/pgtable-prot.h b/arch/arm64/include/asm/pgtable-prot.h
> index 1305e28225fc..f9910ba2afd8 100644
> --- a/arch/arm64/include/asm/pgtable-prot.h
> +++ b/arch/arm64/include/asm/pgtable-prot.h
> @@ -79,6 +79,7 @@ extern bool arm64_use_ng_mappings;
>  	})
>  
>  #define PAGE_S2			__pgprot(_PROT_DEFAULT | PAGE_S2_MEMATTR(NORMAL) | PTE_S2_RDONLY | PAGE_S2_XN)
> +#define PAGE_S2_DBM		__pgprot(_PROT_DEFAULT | PAGE_S2_MEMATTR(NORMAL) | PTE_S2_RDONLY | PAGE_S2_XN | PTE_DBM)

You don't need a new page permission (see below).

>  #define PAGE_S2_DEVICE		__pgprot(_PROT_DEFAULT | PAGE_S2_MEMATTR(DEVICE_nGnRE) | PTE_S2_RDONLY | PTE_S2_XN)
>  
>  #define PAGE_NONE		__pgprot(((_PAGE_DEFAULT) & ~PTE_VALID) | PTE_PROT_NONE | PTE_RDONLY | PTE_NG | PTE_PXN | PTE_UXN)
> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
> index e3b9ee268823..dc97988eb2e0 100644
> --- a/virt/kvm/arm/mmu.c
> +++ b/virt/kvm/arm/mmu.c
> @@ -1426,6 +1426,10 @@ static void stage2_wp_ptes(pmd_t *pmd, phys_addr_t addr, phys_addr_t end)
>  	pte = pte_offset_kernel(pmd, addr);
>  	do {
>  		if (!pte_none(*pte)) {
> +#ifdef CONFIG_ARM64_HW_AFDBM
> +			if (kvm_hw_dbm_enabled() && !kvm_s2pte_dbm(pte))
> +				kvm_set_s2pte_dbm(pte);
> +#endif
>  			if (!kvm_s2pte_readonly(pte))
>  				kvm_set_s2pte_readonly(pte);
>  		}

Setting the DBM bit is equivalent to marking the page writable. The
actual writable pte bit (S2AP[1] or HAP[2] as we call them in Linux for
legacy reasons) tells you whether the page has been dirtied but it is
still writable if you set DBM. Doing this in stage2_wp_ptes()
practically means that you no longer have read-only pages at S2. There
are several good reasons why you don't want to break this. For example,
the S2 pte may already be read-only for other reasons (CoW).

I think you should only set the DBM bit if the pte was previously
writable. In addition, any permission change to the S2 pte must take
into account the DBM bit and clear it while transferring the dirty
status to the underlying page. I'm not deeply familiar with all these
callbacks into KVM but two such paths are kvm_unmap_hva_range() and the
kvm_mmu_notifier_change_pte().


> @@ -1827,7 +1831,15 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  
>  		ret = stage2_set_pmd_huge(kvm, memcache, fault_ipa, &new_pmd);
>  	} else {
> -		pte_t new_pte = kvm_pfn_pte(pfn, mem_type);
> +		pte_t new_pte;
> +
> +#ifdef CONFIG_ARM64_HW_AFDBM
> +		if (kvm_hw_dbm_enabled() &&
> +		    pgprot_val(mem_type) == pgprot_val(PAGE_S2)) {
> +			mem_type = PAGE_S2_DBM;
> +		}
> +#endif
> +		new_pte = kvm_pfn_pte(pfn, mem_type);
>  
>  		if (writable) {
>  			new_pte = kvm_s2pte_mkwrite(new_pte);

That's wrong here. Basically for any fault you get, you just turn the S2
page writable. The point of DBM is that you don't get write faults at
all if you have a writable page. So, as I said above, only set the DBM
bit if you stored a writable S2 pte (kvm_s2pte_mkwrite()).

-- 
Catalin
