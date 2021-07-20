Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 258EA3D0016
	for <lists+kvm@lfdr.de>; Tue, 20 Jul 2021 19:22:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231280AbhGTQl1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Jul 2021 12:41:27 -0400
Received: from foss.arm.com ([217.140.110.172]:35320 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229779AbhGTQlW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Jul 2021 12:41:22 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A04A031B;
        Tue, 20 Jul 2021 10:22:00 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 92F443F73D;
        Tue, 20 Jul 2021 10:21:58 -0700 (PDT)
Subject: Re: [PATCH 1/5] KVM: arm64: Walk userspace page tables to compute the
 THP mapping size
To:     Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, linux-mm@kvack.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>,
        Quentin Perret <qperret@google.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com
References: <20210717095541.1486210-1-maz@kernel.org>
 <20210717095541.1486210-2-maz@kernel.org>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <f09c297b-21dd-a6fa-6e72-49587ba80fe5@arm.com>
Date:   Tue, 20 Jul 2021 18:23:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210717095541.1486210-2-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

I just can't figure out why having the mmap lock is not needed to walk the
userspace page tables. Any hints? Or am I not seeing where it's taken?

On 7/17/21 10:55 AM, Marc Zyngier wrote:
> We currently rely on the kvm_is_transparent_hugepage() helper to
> discover whether a given page has the potential to be mapped as
> a block mapping.
>
> However, this API doesn't really give un everything we want:
> - we don't get the size: this is not crucial today as we only
>   support PMD-sized THPs, but we'd like to have larger sizes
>   in the future
> - we're the only user left of the API, and there is a will
>   to remove it altogether
>
> To address the above, implement a simple walker using the existing
> page table infrastructure, and plumb it into transparent_hugepage_adjust().
> No new page sizes are supported in the process.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/mmu.c | 46 ++++++++++++++++++++++++++++++++++++++++----
>  1 file changed, 42 insertions(+), 4 deletions(-)
>
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 3155c9e778f0..db6314b93e99 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -433,6 +433,44 @@ int create_hyp_exec_mappings(phys_addr_t phys_addr, size_t size,
>  	return 0;
>  }
>  
> +static struct kvm_pgtable_mm_ops kvm_user_mm_ops = {
> +	/* We shouldn't need any other callback to walk the PT */
> +	.phys_to_virt		= kvm_host_va,
> +};
> +
> +struct user_walk_data {
> +	u32	level;
> +};
> +
> +static int user_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
> +		       enum kvm_pgtable_walk_flags flag, void * const arg)
> +{
> +	struct user_walk_data *data = arg;
> +
> +	data->level = level;
> +	return 0;
> +}
> +
> +static int get_user_mapping_size(struct kvm *kvm, u64 addr)
> +{
> +	struct user_walk_data data;
> +	struct kvm_pgtable pgt = {
> +		.pgd		= (kvm_pte_t *)kvm->mm->pgd,
> +		.ia_bits	= VA_BITS,
> +		.start_level	= 4 - CONFIG_PGTABLE_LEVELS,
> +		.mm_ops		= &kvm_user_mm_ops,
> +	};
> +	struct kvm_pgtable_walker walker = {
> +		.cb		= user_walker,
> +		.flags		= KVM_PGTABLE_WALK_LEAF,
> +		.arg		= &data,
> +	};
> +
> +	kvm_pgtable_walk(&pgt, ALIGN_DOWN(addr, PAGE_SIZE), PAGE_SIZE, &walker);

I take it that it is guaranteed that kvm_pgtable_walk() will never fail? For
example, I can see it failing if someone messes with KVM_PGTABLE_MAX_LEVELS. To be
honest, I would rather have a check here instead of potentially feeding a bogus
value to ARM64_HW_PGTABLE_LEVEL_SHIFT. It could be a VM_WARN_ON, so there's no
runtime overhead unless CONFIG_DEBUG_VM.

The patch looks good to me so far, but I want to give it another look (or two)
after I figure out why the mmap semaphone is not needed.

Thanks,

Alex

> +
> +	return BIT(ARM64_HW_PGTABLE_LEVEL_SHIFT(data.level));
> +}
> +
>  static struct kvm_pgtable_mm_ops kvm_s2_mm_ops = {
>  	.zalloc_page		= stage2_memcache_zalloc_page,
>  	.zalloc_pages_exact	= kvm_host_zalloc_pages_exact,
> @@ -780,7 +818,7 @@ static bool fault_supports_stage2_huge_mapping(struct kvm_memory_slot *memslot,
>   * Returns the size of the mapping.
>   */
>  static unsigned long
> -transparent_hugepage_adjust(struct kvm_memory_slot *memslot,
> +transparent_hugepage_adjust(struct kvm *kvm, struct kvm_memory_slot *memslot,
>  			    unsigned long hva, kvm_pfn_t *pfnp,
>  			    phys_addr_t *ipap)
>  {
> @@ -791,8 +829,8 @@ transparent_hugepage_adjust(struct kvm_memory_slot *memslot,
>  	 * sure that the HVA and IPA are sufficiently aligned and that the
>  	 * block map is contained within the memslot.
>  	 */
> -	if (kvm_is_transparent_hugepage(pfn) &&
> -	    fault_supports_stage2_huge_mapping(memslot, hva, PMD_SIZE)) {
> +	if (fault_supports_stage2_huge_mapping(memslot, hva, PMD_SIZE) &&
> +	    get_user_mapping_size(kvm, hva) >= PMD_SIZE) {
>  		/*
>  		 * The address we faulted on is backed by a transparent huge
>  		 * page.  However, because we map the compound huge page and
> @@ -1051,7 +1089,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  	 * backed by a THP and thus use block mapping if possible.
>  	 */
>  	if (vma_pagesize == PAGE_SIZE && !(force_pte || device))
> -		vma_pagesize = transparent_hugepage_adjust(memslot, hva,
> +		vma_pagesize = transparent_hugepage_adjust(kvm, memslot, hva,
>  							   &pfn, &fault_ipa);
>  
>  	if (fault_status != FSC_PERM && !device && kvm_has_mte(kvm)) {
