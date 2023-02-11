Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 025AF692C5F
	for <lists+kvm@lfdr.de>; Sat, 11 Feb 2023 02:02:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229781AbjBKBC2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Feb 2023 20:02:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbjBKBC0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Feb 2023 20:02:26 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 779EC75F52
        for <kvm@vger.kernel.org>; Fri, 10 Feb 2023 17:02:25 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8A80AC14;
        Fri, 10 Feb 2023 17:03:07 -0800 (PST)
Received: from slackpad.lan (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 011593F703;
        Fri, 10 Feb 2023 17:02:22 -0800 (PST)
Date:   Sat, 11 Feb 2023 01:00:19 +0000
From:   Andre Przywara <andre.przywara@arm.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 02/18] KVM: arm64: Use the S2 MMU context to iterate
 over S2 table
Message-ID: <20230211010019.1ccb6855@slackpad.lan>
In-Reply-To: <20230209175820.1939006-3-maz@kernel.org>
References: <20230209175820.1939006-1-maz@kernel.org>
        <20230209175820.1939006-3-maz@kernel.org>
Organization: Arm Ltd.
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.31; x86_64-slackware-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu,  9 Feb 2023 17:58:04 +0000
Marc Zyngier <maz@kernel.org> wrote:

> Most of our S2 helpers take a kvm_s2_mmu pointer, but quickly
> revert back to using the kvm structure. By doing so, we lose
> track of which S2 MMU context we were initially using, and fallback
> to the "canonical" context.
> 
> If we were trying to unmap a S2 context managed by a guest hypervisor,
> we end-up parsing the wrong set of page tables, and bad stuff happens
> (as this is often happening on the back of a trapped TLBI from the
> guest hypervisor).
> 
> Instead, make sure we always use the provided MMU context all the way.
> This has no impact on non-NV, as we always pass the canonical MMU
> context.

Indeed this just changes stage2_apply_range() and all its callers, in
a manner that shouldn't change the current behaviour, but preserves the
S2 MMU passed in:

> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Andre Przywara <andre.przywara@arm.com>

Cheers,
Andre

> ---
>  arch/arm64/kvm/mmu.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index a3ee3b605c9b..892d6a5fb2f5 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -46,16 +46,17 @@ static phys_addr_t stage2_range_addr_end(phys_addr_t addr, phys_addr_t end)
>   * long will also starve other vCPUs. We have to also make sure that the page
>   * tables are not freed while we released the lock.
>   */
> -static int stage2_apply_range(struct kvm *kvm, phys_addr_t addr,
> +static int stage2_apply_range(struct kvm_s2_mmu *mmu, phys_addr_t addr,
>  			      phys_addr_t end,
>  			      int (*fn)(struct kvm_pgtable *, u64, u64),
>  			      bool resched)
>  {
> +	struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
>  	int ret;
>  	u64 next;
>  
>  	do {
> -		struct kvm_pgtable *pgt = kvm->arch.mmu.pgt;
> +		struct kvm_pgtable *pgt = mmu->pgt;
>  		if (!pgt)
>  			return -EINVAL;
>  
> @@ -71,8 +72,8 @@ static int stage2_apply_range(struct kvm *kvm, phys_addr_t addr,
>  	return ret;
>  }
>  
> -#define stage2_apply_range_resched(kvm, addr, end, fn)			\
> -	stage2_apply_range(kvm, addr, end, fn, true)
> +#define stage2_apply_range_resched(mmu, addr, end, fn)			\
> +	stage2_apply_range(mmu, addr, end, fn, true)
>  
>  static bool memslot_is_logging(struct kvm_memory_slot *memslot)
>  {
> @@ -235,7 +236,7 @@ static void __unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64
>  
>  	lockdep_assert_held_write(&kvm->mmu_lock);
>  	WARN_ON(size & ~PAGE_MASK);
> -	WARN_ON(stage2_apply_range(kvm, start, end, kvm_pgtable_stage2_unmap,
> +	WARN_ON(stage2_apply_range(mmu, start, end, kvm_pgtable_stage2_unmap,
>  				   may_block));
>  }
>  
> @@ -250,7 +251,7 @@ static void stage2_flush_memslot(struct kvm *kvm,
>  	phys_addr_t addr = memslot->base_gfn << PAGE_SHIFT;
>  	phys_addr_t end = addr + PAGE_SIZE * memslot->npages;
>  
> -	stage2_apply_range_resched(kvm, addr, end, kvm_pgtable_stage2_flush);
> +	stage2_apply_range_resched(&kvm->arch.mmu, addr, end, kvm_pgtable_stage2_flush);
>  }
>  
>  /**
> @@ -934,8 +935,7 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
>   */
>  static void stage2_wp_range(struct kvm_s2_mmu *mmu, phys_addr_t addr, phys_addr_t end)
>  {
> -	struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
> -	stage2_apply_range_resched(kvm, addr, end, kvm_pgtable_stage2_wrprotect);
> +	stage2_apply_range_resched(mmu, addr, end, kvm_pgtable_stage2_wrprotect);
>  }
>  
>  /**

