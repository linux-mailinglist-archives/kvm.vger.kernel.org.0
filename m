Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE5191F632A
	for <lists+kvm@lfdr.de>; Thu, 11 Jun 2020 10:01:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726774AbgFKIBr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jun 2020 04:01:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:47298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726648AbgFKIBr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jun 2020 04:01:47 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 65AB1204EA;
        Thu, 11 Jun 2020 08:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591862506;
        bh=WrdLLQIOoxEMsuU9Lk5Dy1SToKye9eSD7H3ebXQ4auQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BFNWtrgHmTyg+AGGrVuwbubxxA7aMIB6dBhEn5erW2tJ90Re7LmkgQh1PRU8S1tBy
         1Vf5aq5qLm3ViH955oFX5SqDRf+22SYRhv8o6a+CLJPlv/tGf0NcfQ1zvZ772LwNWR
         fmY3NiXUQ/U6YmjVuKyNJoqR2RwkIVDLBKcX1YPI=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jjI9g-0021ZL-Tz; Thu, 11 Jun 2020 09:01:45 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 11 Jun 2020 09:01:44 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Feiner <pfeiner@google.com>,
        Peter Shier <pshier@google.com>,
        Junaid Shahid <junaids@google.com>,
        Ben Gardon <bgardon@google.com>,
        Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCH 18/21] KVM: arm64: Use common KVM implementation of MMU
 memory caches
In-Reply-To: <20200605213853.14959-19-sean.j.christopherson@intel.com>
References: <20200605213853.14959-1-sean.j.christopherson@intel.com>
 <20200605213853.14959-19-sean.j.christopherson@intel.com>
User-Agent: Roundcube Webmail/1.4.4
Message-ID: <3555daf3b38c890e1e74f05d6f49f9be@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: sean.j.christopherson@intel.com, paulus@ozlabs.org, borntraeger@de.ibm.com, frankja@linux.ibm.com, pbonzini@redhat.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, david@redhat.com, cohuck@redhat.com, imbrenda@linux.ibm.com, vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org, kvm@vger.kernel.org, kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org, pfeiner@google.com, pshier@google.com, junaids@google.com, bgardon@google.com, christoffer.dall@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-06-05 22:38, Sean Christopherson wrote:
> Move to the common MMU memory cache implementation now that the common
> code and arm64's existing code are semantically compatible.
> 
> No functional change intended.
> 
> Suggested-by: Christoffer Dall <christoffer.dall@arm.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/arm64/include/asm/kvm_host.h  | 12 -------
>  arch/arm64/include/asm/kvm_types.h |  2 ++
>  arch/arm64/kvm/mmu.c               | 51 ++++++------------------------
>  3 files changed, 12 insertions(+), 53 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h
> b/arch/arm64/include/asm/kvm_host.h
> index 2385dede96e0..d221b6b129fd 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -97,18 +97,6 @@ struct kvm_arch {
>  	bool return_nisv_io_abort_to_user;
>  };
> 
> -#define KVM_NR_MEM_OBJS     40
> -
> -/*
> - * We don't want allocation failures within the mmu code, so we 
> preallocate
> - * enough memory for a single page fault in a cache.
> - */
> -struct kvm_mmu_memory_cache {
> -	int nobjs;
> -	gfp_t gfp_zero;
> -	void *objects[KVM_NR_MEM_OBJS];
> -};
> -
>  struct kvm_vcpu_fault_info {
>  	u32 esr_el2;		/* Hyp Syndrom Register */
>  	u64 far_el2;		/* Hyp Fault Address Register */
> diff --git a/arch/arm64/include/asm/kvm_types.h
> b/arch/arm64/include/asm/kvm_types.h
> index d0987007d581..9a126b9e2d7c 100644
> --- a/arch/arm64/include/asm/kvm_types.h
> +++ b/arch/arm64/include/asm/kvm_types.h
> @@ -2,5 +2,7 @@
>  #ifndef _ASM_ARM64_KVM_TYPES_H
>  #define _ASM_ARM64_KVM_TYPES_H
> 
> +#define KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE 40
> +
>  #endif /* _ASM_ARM64_KVM_TYPES_H */
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 688213ef34f0..976405e2fbb2 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -124,37 +124,6 @@ static void stage2_dissolve_pud(struct kvm *kvm,
> phys_addr_t addr, pud_t *pudp)
>  	put_page(virt_to_page(pudp));
>  }
> 
> -static int mmu_topup_memory_cache(struct kvm_mmu_memory_cache *cache, 
> int min)
> -{
> -	void *page;
> -
> -	if (cache->nobjs >= min)
> -		return 0;
> -	while (cache->nobjs < ARRAY_SIZE(cache->objects)) {
> -		page = (void *)__get_free_page(GFP_KERNEL_ACCOUNT |
> -					       cache->gfp_zero);
> -		if (!page)
> -			return -ENOMEM;
> -		cache->objects[cache->nobjs++] = page;
> -	}
> -	return 0;
> -}
> -
> -static void mmu_free_memory_cache(struct kvm_mmu_memory_cache *mc)
> -{
> -	while (mc->nobjs)
> -		free_page((unsigned long)mc->objects[--mc->nobjs]);
> -}
> -
> -static void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc)
> -{
> -	void *p;
> -
> -	BUG_ON(!mc || !mc->nobjs);
> -	p = mc->objects[--mc->nobjs];
> -	return p;
> -}
> -
>  static void clear_stage2_pgd_entry(struct kvm *kvm, pgd_t *pgd,
> phys_addr_t addr)
>  {
>  	pud_t *pud_table __maybe_unused = stage2_pud_offset(kvm, pgd, 0UL);
> @@ -1024,7 +993,7 @@ static pud_t *stage2_get_pud(struct kvm *kvm,
> struct kvm_mmu_memory_cache *cache
>  	if (stage2_pgd_none(kvm, *pgd)) {
>  		if (!cache)
>  			return NULL;
> -		pud = mmu_memory_cache_alloc(cache);
> +		pud = kvm_mmu_memory_cache_alloc(cache);
>  		stage2_pgd_populate(kvm, pgd, pud);
>  		get_page(virt_to_page(pgd));
>  	}

Quick note: this patch (as it is) breaks on arm64 due to Mike Rapoport's
P4D rework. I've fixed it locally in order to test the series.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
