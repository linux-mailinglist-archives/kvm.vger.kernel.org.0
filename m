Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A860E68B87E
	for <lists+kvm@lfdr.de>; Mon,  6 Feb 2023 10:21:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbjBFJVZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Feb 2023 04:21:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230088AbjBFJVS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Feb 2023 04:21:18 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5493D4C2C
        for <kvm@vger.kernel.org>; Mon,  6 Feb 2023 01:21:10 -0800 (PST)
Received: from dggpeml500005.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4P9LLM228jzJsJ0;
        Mon,  6 Feb 2023 17:19:23 +0800 (CST)
Received: from [10.174.186.51] (10.174.186.51) by
 dggpeml500005.china.huawei.com (7.185.36.59) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Mon, 6 Feb 2023 17:21:02 +0800
Subject: Re: [PATCH 3/9] KVM: arm64: Add kvm_pgtable_stage2_split()
To:     Ricardo Koller <ricarkol@google.com>, <pbonzini@redhat.com>,
        <maz@kernel.org>, <oupton@google.com>, <yuzenghui@huawei.com>,
        <dmatlack@google.com>
CC:     <kvm@vger.kernel.org>, <kvmarm@lists.linux.dev>,
        <qperret@google.com>, <catalin.marinas@arm.com>,
        <andrew.jones@linux.dev>, <seanjc@google.com>,
        <alexandru.elisei@arm.com>, <suzuki.poulose@arm.com>,
        <eric.auger@redhat.com>, <gshan@redhat.com>, <reijiw@google.com>,
        <rananta@google.com>, <bgardon@google.com>, <ricarkol@gmail.com>,
        Xiexiangyou <xiexiangyou@huawei.com>, <yezhenyu2@huawei.com>
References: <20230113035000.480021-1-ricarkol@google.com>
 <20230113035000.480021-4-ricarkol@google.com>
From:   Zheng Chuan <zhengchuan@huawei.com>
Message-ID: <59f0d41e-d8ac-dab3-9136-af48efe55578@huawei.com>
Date:   Mon, 6 Feb 2023 17:20:42 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20230113035000.480021-4-ricarkol@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.186.51]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500005.china.huawei.com (7.185.36.59)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, Ricardo

On 2023/1/13 11:49, Ricardo Koller wrote:
> Add a new stage2 function, kvm_pgtable_stage2_split(), for splitting a
> range of huge pages. This will be used for eager-splitting huge pages
> into PAGE_SIZE pages. The goal is to avoid having to split huge pages
> on write-protection faults, and instead use this function to do it
> ahead of time for large ranges (e.g., all guest memory in 1G chunks at
> a time).
> 
> No functional change intended. This new function will be used in a
> subsequent commit.
> 
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  arch/arm64/include/asm/kvm_pgtable.h | 29 ++++++++++++
>  arch/arm64/kvm/hyp/pgtable.c         | 67 ++++++++++++++++++++++++++++
>  2 files changed, 96 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index 8ad78d61af7f..5fbdc1f259fd 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -644,6 +644,35 @@ bool kvm_pgtable_stage2_is_young(struct kvm_pgtable *pgt, u64 addr);
>   */
>  int kvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size);
>  
> +/**
> + * kvm_pgtable_stage2_split() - Split a range of huge pages into leaf PTEs pointing
> + *				to PAGE_SIZE guest pages.
> + * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init*().
> + * @addr:	Intermediate physical address from which to split.
> + * @size:	Size of the range.
> + * @mc:		Cache of pre-allocated and zeroed memory from which to allocate
> + *		page-table pages.
> + *
> + * @addr and the end (@addr + @size) are effectively aligned down and up to
> + * the top level huge-page block size. This is an exampe using 1GB
> + * huge-pages and 4KB granules.
> + *
> + *                          [---input range---]
> + *                          :                 :
> + * [--1G block pte--][--1G block pte--][--1G block pte--][--1G block pte--]
> + *                          :                 :
> + *                   [--2MB--][--2MB--][--2MB--][--2MB--]
> + *                          :                 :
> + *                   [ ][ ][:][ ][ ][ ][ ][ ][:][ ][ ][ ]
> + *                          :                 :
> + *
> + * Return: 0 on success, negative error code on failure. Note that
> + * kvm_pgtable_stage2_split() is best effort: it tries to break as many
> + * blocks in the input range as allowed by the size of the memcache. It
> + * will fail it wasn't able to break any block.
> + */
> +int kvm_pgtable_stage2_split(struct kvm_pgtable *pgt, u64 addr, u64 size, void *mc);
> +
>  /**
>   * kvm_pgtable_walk() - Walk a page-table.
>   * @pgt:	Page-table structure initialised by kvm_pgtable_*_init().
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 0dee13007776..db9d1a28769b 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -1229,6 +1229,73 @@ int kvm_pgtable_stage2_create_removed(struct kvm_pgtable *pgt,
>  	return 0;
>  }
>  
> +struct stage2_split_data {
> +	struct kvm_s2_mmu		*mmu;
> +	void				*memcache;
> +};
> +
> +static int stage2_split_walker(const struct kvm_pgtable_visit_ctx *ctx,
> +			       enum kvm_pgtable_walk_flags visit)
> +{
> +	struct stage2_split_data *data = ctx->arg;
> +	struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
> +	kvm_pte_t pte = ctx->old, new, *childp;
> +	enum kvm_pgtable_prot prot;
> +	void *mc = data->memcache;
> +	u32 level = ctx->level;
> +	u64 phys;
> +	int ret;
> +
> +	/* Nothing to split at the last level */
> +	if (level == KVM_PGTABLE_MAX_LEVELS - 1)
> +		return 0;
> +
> +	/* We only split valid block mappings */
> +	if (!kvm_pte_valid(pte) || kvm_pte_table(pte, ctx->level))
> +		return 0;
> +
IIUC, It should be !kvm_pte_table(pte, ctx->level)?
also, the kvm_pte_table includes the level check and kvm_pte_valid, so, it just be like:
-	/* Nothing to split at the last level */
-	if (level == KVM_PGTABLE_MAX_LEVELS - 1)
-		return 0;
-
-	/* We only split valid block mappings */
+	if (!kvm_pte_table(pte, ctx->level))
+		return 0;

> +	phys = kvm_pte_to_phys(pte);
> +	prot = kvm_pgtable_stage2_pte_prot(pte);
> +
> +	ret = kvm_pgtable_stage2_create_removed(data->mmu->pgt, &new, phys,
> +						level, prot, mc);
> +	if (ret)
> +		return ret;
> +
> +	if (!stage2_try_break_pte(ctx, data->mmu)) {
> +		childp = kvm_pte_follow(new, mm_ops);
> +		kvm_pgtable_stage2_free_removed(mm_ops, childp, level);
> +		mm_ops->put_page(childp);
> +		return -EAGAIN;
> +	}
> +
> +	/*
> +	 * Note, the contents of the page table are guaranteed to be
> +	 * made visible before the new PTE is assigned because
> +	 * stage2_make_pte() writes the PTE using smp_store_release().
> +	 */
> +	stage2_make_pte(ctx, new);
> +	dsb(ishst);
> +	return 0;
> +}
> +
> +int kvm_pgtable_stage2_split(struct kvm_pgtable *pgt,
> +			     u64 addr, u64 size, void *mc)
> +{
> +	struct stage2_split_data split_data = {
> +		.mmu		= pgt->mmu,
> +		.memcache	= mc,
> +	};
> +
> +	struct kvm_pgtable_walker walker = {
> +		.cb	= stage2_split_walker,
> +		.flags	= KVM_PGTABLE_WALK_LEAF,
> +		.arg	= &split_data,
> +	};
> +
> +	return kvm_pgtable_walk(pgt, addr, size, &walker);
> +}
> +
>  int __kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
>  			      struct kvm_pgtable_mm_ops *mm_ops,
>  			      enum kvm_pgtable_stage2_flags flags,
> 

-- 
Regards.
Chuan
