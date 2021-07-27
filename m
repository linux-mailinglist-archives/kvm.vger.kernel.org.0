Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 220C43D79A8
	for <lists+kvm@lfdr.de>; Tue, 27 Jul 2021 17:25:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237078AbhG0PZp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jul 2021 11:25:45 -0400
Received: from foss.arm.com ([217.140.110.172]:40330 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232634AbhG0PY4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jul 2021 11:24:56 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8DAF131B;
        Tue, 27 Jul 2021 08:24:29 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 782673F66F;
        Tue, 27 Jul 2021 08:24:27 -0700 (PDT)
Subject: Re: [PATCH v2 1/6] KVM: arm64: Introduce helper to retrieve a PTE and
 its level
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
References: <20210726153552.1535838-1-maz@kernel.org>
 <20210726153552.1535838-2-maz@kernel.org>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <11d5e176-ac47-e215-b82a-b8f074220bd6@arm.com>
Date:   Tue, 27 Jul 2021 16:25:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210726153552.1535838-2-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 7/26/21 4:35 PM, Marc Zyngier wrote:
> It is becoming a common need to fetch the PTE for a given address
> together with its level. Add such a helper.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_pgtable.h | 19 ++++++++++++++
>  arch/arm64/kvm/hyp/pgtable.c         | 39 ++++++++++++++++++++++++++++
>  2 files changed, 58 insertions(+)
>
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index f004c0115d89..082b9d65f40b 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -432,6 +432,25 @@ int kvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size);
>  int kvm_pgtable_walk(struct kvm_pgtable *pgt, u64 addr, u64 size,
>  		     struct kvm_pgtable_walker *walker);
>  
> +/**
> + * kvm_pgtable_get_leaf() - Walk a page-table and retrieve the leaf entry
> + *			    with its level.
> + * @pgt:	Page-table structure initialised by kvm_pgtable_*_init().

Yet in the next patch you use a struct kvm_pgtable_pgt not initialized by any of
the kvm_pgtable_*_init() functions. It doesn't hurt correctness, but it might
confuse potential users of this function.

> + * @addr:	Input address for the start of the walk.
> + * @ptep:	Pointer to storage for the retrieved PTE.
> + * @level:	Pointer to storage for the level of the retrieved PTE.
> + *
> + * The offset of @addr within a page is ignored.
> + *
> + * The walker will walk the page-table entries corresponding to the input
> + * address specified, retrieving the leaf corresponding to this address.
> + * Invalid entries are treated as leaf entries.
> + *
> + * Return: 0 on success, negative error code on failure.
> + */
> +int kvm_pgtable_get_leaf(struct kvm_pgtable *pgt, u64 addr,
> +			 kvm_pte_t *ptep, u32 *level);
> +
>  /**
>   * kvm_pgtable_stage2_find_range() - Find a range of Intermediate Physical
>   *				     Addresses with compatible permission
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 05321f4165e3..78f36bd5df6c 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -326,6 +326,45 @@ int kvm_pgtable_walk(struct kvm_pgtable *pgt, u64 addr, u64 size,
>  	return _kvm_pgtable_walk(&walk_data);
>  }
>  
> +struct leaf_walk_data {
> +	kvm_pte_t	pte;
> +	u32		level;
> +};
> +
> +static int leaf_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
> +		       enum kvm_pgtable_walk_flags flag, void * const arg)
> +{
> +	struct leaf_walk_data *data = arg;
> +
> +	data->pte   = *ptep;
> +	data->level = level;
> +
> +	return 0;
> +}
> +
> +int kvm_pgtable_get_leaf(struct kvm_pgtable *pgt, u64 addr,
> +			 kvm_pte_t *ptep, u32 *level)
> +{
> +	struct leaf_walk_data data;
> +	struct kvm_pgtable_walker walker = {
> +		.cb	= leaf_walker,
> +		.flags	= KVM_PGTABLE_WALK_LEAF,
> +		.arg	= &data,
> +	};
> +	int ret;
> +
> +	ret = kvm_pgtable_walk(pgt, ALIGN_DOWN(addr, PAGE_SIZE),
> +			       PAGE_SIZE, &walker);

kvm_pgtable_walk() already aligns addr down to PAGE_SIZE, I don't think that's
needed here. But not harmful either.

Otherwise, the patch looks good to me:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,

Alex

> +	if (!ret) {
> +		if (ptep)
> +			*ptep  = data.pte;
> +		if (level)
> +			*level = data.level;
> +	}
> +
> +	return ret;
> +}
> +
>  struct hyp_map_data {
>  	u64				phys;
>  	kvm_pte_t			attr;
