Return-Path: <kvm+bounces-2736-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B0377FCFFF
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 08:36:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AD98528270F
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 07:36:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FDE610A3E;
	Wed, 29 Nov 2023 07:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2C50E1FFA
	for <kvm@vger.kernel.org>; Tue, 28 Nov 2023 23:36:12 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5AC5E2F4;
	Tue, 28 Nov 2023 23:36:59 -0800 (PST)
Received: from [10.163.33.248] (unknown [10.163.33.248])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5BBF43F6C4;
	Tue, 28 Nov 2023 23:36:08 -0800 (PST)
Message-ID: <b9198f61-c3d1-462b-9cff-0342e26d9ba9@arm.com>
Date: Wed, 29 Nov 2023 13:06:06 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] KVM: arm64: Remove VPIPT I-cache handling
Content-Language: en-US
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ardb@kernel.org>,
 James Morse <james.morse@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Zenghui Yu <yuzenghui@huawei.com>
References: <20231127172613.1490283-1-maz@kernel.org>
 <20231127172613.1490283-2-maz@kernel.org>
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20231127172613.1490283-2-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 11/27/23 22:56, Marc Zyngier wrote:
> We have some special handling for VPIPT I-cache in critical parts
> of the cache and TLB maintenance. Remove it.

Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>

> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_mmu.h |  7 ----
>  arch/arm64/kvm/hyp/nvhe/pkvm.c   |  2 +-
>  arch/arm64/kvm/hyp/nvhe/tlb.c    | 61 --------------------------------
>  arch/arm64/kvm/hyp/vhe/tlb.c     | 13 -------
>  4 files changed, 1 insertion(+), 82 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> index 49e0d4b36bd0..e3e793d0ec30 100644
> --- a/arch/arm64/include/asm/kvm_mmu.h
> +++ b/arch/arm64/include/asm/kvm_mmu.h
> @@ -243,13 +243,6 @@ static inline size_t __invalidate_icache_max_range(void)
>  
>  static inline void __invalidate_icache_guest_page(void *va, size_t size)
>  {
> -	/*
> -	 * VPIPT I-cache maintenance must be done from EL2. See comment in the
> -	 * nVHE flavor of __kvm_tlb_flush_vmid_ipa().
> -	 */
> -	if (icache_is_vpipt() && read_sysreg(CurrentEL) != CurrentEL_EL2)
> -		return;
> -
>  	/*
>  	 * Blow the whole I-cache if it is aliasing (i.e. VIPT) or the
>  	 * invalidation range exceeds our arbitrary limit on invadations by
> diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> index 9d23a51d7f75..b29f15418c0a 100644
> --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
> +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> @@ -12,7 +12,7 @@
>  #include <nvhe/pkvm.h>
>  #include <nvhe/trap_handler.h>
>  
> -/* Used by icache_is_vpipt(). */
> +/* Used by icache_is_aliasing(). */
>  unsigned long __icache_flags;
>  
>  /* Used by kvm_get_vttbr(). */
> diff --git a/arch/arm64/kvm/hyp/nvhe/tlb.c b/arch/arm64/kvm/hyp/nvhe/tlb.c
> index 1b265713d6be..a60fb13e2192 100644
> --- a/arch/arm64/kvm/hyp/nvhe/tlb.c
> +++ b/arch/arm64/kvm/hyp/nvhe/tlb.c
> @@ -105,28 +105,6 @@ void __kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu,
>  	dsb(ish);
>  	isb();
>  
> -	/*
> -	 * If the host is running at EL1 and we have a VPIPT I-cache,
> -	 * then we must perform I-cache maintenance at EL2 in order for
> -	 * it to have an effect on the guest. Since the guest cannot hit
> -	 * I-cache lines allocated with a different VMID, we don't need
> -	 * to worry about junk out of guest reset (we nuke the I-cache on
> -	 * VMID rollover), but we do need to be careful when remapping
> -	 * executable pages for the same guest. This can happen when KSM
> -	 * takes a CoW fault on an executable page, copies the page into
> -	 * a page that was previously mapped in the guest and then needs
> -	 * to invalidate the guest view of the I-cache for that page
> -	 * from EL1. To solve this, we invalidate the entire I-cache when
> -	 * unmapping a page from a guest if we have a VPIPT I-cache but
> -	 * the host is running at EL1. As above, we could do better if
> -	 * we had the VA.
> -	 *
> -	 * The moral of this story is: if you have a VPIPT I-cache, then
> -	 * you should be running with VHE enabled.
> -	 */
> -	if (icache_is_vpipt())
> -		icache_inval_all_pou();
> -
>  	__tlb_switch_to_host(&cxt);
>  }
>  
> @@ -157,28 +135,6 @@ void __kvm_tlb_flush_vmid_ipa_nsh(struct kvm_s2_mmu *mmu,
>  	dsb(nsh);
>  	isb();
>  
> -	/*
> -	 * If the host is running at EL1 and we have a VPIPT I-cache,
> -	 * then we must perform I-cache maintenance at EL2 in order for
> -	 * it to have an effect on the guest. Since the guest cannot hit
> -	 * I-cache lines allocated with a different VMID, we don't need
> -	 * to worry about junk out of guest reset (we nuke the I-cache on
> -	 * VMID rollover), but we do need to be careful when remapping
> -	 * executable pages for the same guest. This can happen when KSM
> -	 * takes a CoW fault on an executable page, copies the page into
> -	 * a page that was previously mapped in the guest and then needs
> -	 * to invalidate the guest view of the I-cache for that page
> -	 * from EL1. To solve this, we invalidate the entire I-cache when
> -	 * unmapping a page from a guest if we have a VPIPT I-cache but
> -	 * the host is running at EL1. As above, we could do better if
> -	 * we had the VA.
> -	 *
> -	 * The moral of this story is: if you have a VPIPT I-cache, then
> -	 * you should be running with VHE enabled.
> -	 */
> -	if (icache_is_vpipt())
> -		icache_inval_all_pou();
> -
>  	__tlb_switch_to_host(&cxt);
>  }
>  
> @@ -205,10 +161,6 @@ void __kvm_tlb_flush_vmid_range(struct kvm_s2_mmu *mmu,
>  	dsb(ish);
>  	isb();
>  
> -	/* See the comment in __kvm_tlb_flush_vmid_ipa() */
> -	if (icache_is_vpipt())
> -		icache_inval_all_pou();
> -
>  	__tlb_switch_to_host(&cxt);
>  }
>  
> @@ -246,18 +198,5 @@ void __kvm_flush_vm_context(void)
>  	/* Same remark as in __tlb_switch_to_guest() */
>  	dsb(ish);
>  	__tlbi(alle1is);
> -
> -	/*
> -	 * VIPT and PIPT caches are not affected by VMID, so no maintenance
> -	 * is necessary across a VMID rollover.
> -	 *
> -	 * VPIPT caches constrain lookup and maintenance to the active VMID,
> -	 * so we need to invalidate lines with a stale VMID to avoid an ABA
> -	 * race after multiple rollovers.
> -	 *
> -	 */
> -	if (icache_is_vpipt())
> -		asm volatile("ic ialluis");
> -
>  	dsb(ish);
>  }
> diff --git a/arch/arm64/kvm/hyp/vhe/tlb.c b/arch/arm64/kvm/hyp/vhe/tlb.c
> index b636b4111dbf..b32e2940df7d 100644
> --- a/arch/arm64/kvm/hyp/vhe/tlb.c
> +++ b/arch/arm64/kvm/hyp/vhe/tlb.c
> @@ -216,18 +216,5 @@ void __kvm_flush_vm_context(void)
>  {
>  	dsb(ishst);
>  	__tlbi(alle1is);
> -
> -	/*
> -	 * VIPT and PIPT caches are not affected by VMID, so no maintenance
> -	 * is necessary across a VMID rollover.
> -	 *
> -	 * VPIPT caches constrain lookup and maintenance to the active VMID,
> -	 * so we need to invalidate lines with a stale VMID to avoid an ABA
> -	 * race after multiple rollovers.
> -	 *
> -	 */
> -	if (icache_is_vpipt())
> -		asm volatile("ic ialluis");
> -
>  	dsb(ish);
>  }

