Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 553526A9366
	for <lists+kvm@lfdr.de>; Fri,  3 Mar 2023 10:10:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229819AbjCCJKt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Mar 2023 04:10:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbjCCJKq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Mar 2023 04:10:46 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C34E125A4
        for <kvm@vger.kernel.org>; Fri,  3 Mar 2023 01:10:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677834599;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pJe1IfdCoJR8Gs3rY8myzr5sYaOrRXm56RaO5zyn4p8=;
        b=DrbtLH07af15VZDSf8hCcSukXRmg74p9GYgVcZ9RMJVC6rbMtUln8Y2wjewYAVhogPI7Lf
        FjHYJO3oJztQoDCp5YuJHhc1HNashZWVhf3dEFY2VPeeVPhjVaBVa7/ojq6qxqCRVtH6Bc
        LIwGmFihUsJOANMVudInOJp3PaiJ4gs=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-1-bxithJ8mMl6VHGxHhWQ5AQ-1; Fri, 03 Mar 2023 04:09:50 -0500
X-MC-Unique: bxithJ8mMl6VHGxHhWQ5AQ-1
Received: by mail-qk1-f199.google.com with SMTP id q25-20020a37f719000000b00742bfdd63ecso999354qkj.4
        for <kvm@vger.kernel.org>; Fri, 03 Mar 2023 01:09:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677834590;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pJe1IfdCoJR8Gs3rY8myzr5sYaOrRXm56RaO5zyn4p8=;
        b=rtQatCMKwStM/SoxE6VJ4gtvEtwAj8N3aRIcvSpibaZ5XF0EMZIcYMgVZVKfQQdS9O
         LfSGI3tG5gXxjBle2U84B5zQ3sB9s+VnXKuELHD3FllKH0aaonwenpmxTOdhz+jNPv9A
         MIypVZR5+craomSle5RxqlZvxqXUUTyhC4ENAcGvDseE3RpGuY9X27nygJfxxPEk1krn
         1guJZE7QYEv5aRwqi8IBBsyDkDa/R5xUDaQ8Kpoq8WIoiPoUAVY/GLn5khA5WeEp4xwN
         Pt9WGWmo5xZQx2kIkmlRR6xJLyfpQ0LpH+6au4EAdm4xbuioSJ3HF39zN6ptvjuuHA+P
         ROiw==
X-Gm-Message-State: AO0yUKWnNAF2rs/H2c8v7iDUXV2TjlDQLU1uReuMqdXma1wLMs4AbVFY
        +hZ/hxdzyj7t9St0pa1hXWm2561ii91swBSBzPVmqzsI4EgxFVwaBvbQGk5/tQ35Vn38JYR+jqv
        hES1fIc32Mhuc
X-Received: by 2002:ac8:5b08:0:b0:3bf:cc1b:9512 with SMTP id m8-20020ac85b08000000b003bfcc1b9512mr1783773qtw.1.1677834590352;
        Fri, 03 Mar 2023 01:09:50 -0800 (PST)
X-Google-Smtp-Source: AK7set8p2UjpHPijUcOQBqy9GwkoNikUUadtv/Y8U9dSsIyTKEF761hVPtYYk6UWS5ANNDIb+RbwWg==
X-Received: by 2002:ac8:5b08:0:b0:3bf:cc1b:9512 with SMTP id m8-20020ac85b08000000b003bfcc1b9512mr1783754qtw.1.1677834590083;
        Fri, 03 Mar 2023 01:09:50 -0800 (PST)
Received: from [10.66.61.39] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id c6-20020ac81e86000000b003b9bb59543fsm1327816qtm.61.2023.03.03.01.09.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Mar 2023 01:09:49 -0800 (PST)
Message-ID: <9f9fe336-f1e2-d064-8185-e34d1e19813a@redhat.com>
Date:   Fri, 3 Mar 2023 17:09:41 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v5 04/12] KVM: arm64: Add kvm_pgtable_stage2_split()
Content-Language: en-US
To:     Ricardo Koller <ricarkol@google.com>, pbonzini@redhat.com,
        maz@kernel.org, oupton@google.com, yuzenghui@huawei.com,
        dmatlack@google.com
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev, qperret@google.com,
        catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, gshan@redhat.com, reijiw@google.com,
        rananta@google.com, bgardon@google.com, ricarkol@gmail.com
References: <20230301210928.565562-1-ricarkol@google.com>
 <20230301210928.565562-5-ricarkol@google.com>
From:   Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230301210928.565562-5-ricarkol@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/2/23 05:09, Ricardo Koller wrote:
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
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> ---
>   arch/arm64/include/asm/kvm_pgtable.h |  30 +++++++
>   arch/arm64/kvm/hyp/pgtable.c         | 113 +++++++++++++++++++++++++++
>   2 files changed, 143 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index 2b98357a5497..ce0a8e17fb6d 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -657,6 +657,36 @@ bool kvm_pgtable_stage2_is_young(struct kvm_pgtable *pgt, u64 addr);
>    */
>   int kvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size);
>   
> +/**
> + * kvm_pgtable_stage2_split() - Split a range of huge pages into leaf PTEs pointing
> + *				to PAGE_SIZE guest pages.
> + * @pgt:	 Page-table structure initialised by kvm_pgtable_stage2_init().
> + * @addr:	 Intermediate physical address from which to split.
> + * @size:	 Size of the range.
> + * @mc:		 Cache of pre-allocated and zeroed memory from which to allocate
> + *		 page-table pages.
> + * @mc_capacity: Number of pages in @mc.
> + *
> + * @addr and the end (@addr + @size) are effectively aligned down and up to
> + * the top level huge-page block size. This is an example using 1GB
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
> + * blocks in the input range as allowed by @mc_capacity.
> + */
> +int kvm_pgtable_stage2_split(struct kvm_pgtable *pgt, u64 addr, u64 size,
> +			     void *mc, u64 mc_capacity);
> +
>   /**
>    * kvm_pgtable_walk() - Walk a page-table.
>    * @pgt:	Page-table structure initialised by kvm_pgtable_*_init().
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 3554b74e13c6..75726edba2f3 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -1228,6 +1228,119 @@ kvm_pte_t *kvm_pgtable_stage2_create_unlinked(struct kvm_pgtable *pgt,
>   	return pgtable;
>   }
>   
> +struct stage2_split_data {
> +	struct kvm_s2_mmu		*mmu;
> +	void				*memcache;
> +	u64				mc_capacity;
> +};
> +
> +/*
> + * Get the number of page-tables needed to replace a block with a
> + * fully populated tree, up to the PTE level, at particular level.
> + */
> +static inline int stage2_block_get_nr_page_tables(u32 level)
> +{
> +	if (WARN_ON_ONCE(level < KVM_PGTABLE_MIN_BLOCK_LEVEL ||
> +			 level >= KVM_PGTABLE_MAX_LEVELS))
> +		return -EINVAL;
> +
> +	switch (level) {
> +	case 1:
> +		return PTRS_PER_PTE + 1;
> +	case 2:
> +		return 1;
> +	case 3:
> +		return 0;
> +	default:
> +		return -EINVAL;
> +	};
> +}
> +
> +static int stage2_split_walker(const struct kvm_pgtable_visit_ctx *ctx,
> +			       enum kvm_pgtable_walk_flags visit)
> +{
> +	struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
> +	struct stage2_split_data *data = ctx->arg;
> +	kvm_pte_t pte = ctx->old, new, *childp;
> +	enum kvm_pgtable_prot prot;
> +	void *mc = data->memcache;
> +	u32 level = ctx->level;
> +	bool force_pte;
> +	int nr_pages;
> +	u64 phys;
> +
> +	/* No huge-pages exist at the last level */
> +	if (level == KVM_PGTABLE_MAX_LEVELS - 1)
> +		return 0;
> +
> +	/* We only split valid block mappings */
> +	if (!kvm_pte_valid(pte))
> +		return 0;
> +
> +	nr_pages = stage2_block_get_nr_page_tables(level);
> +	if (nr_pages < 0)
> +		return nr_pages;
> +
> +	if (data->mc_capacity >= nr_pages) {
> +		/* Build a tree mapped down to the PTE granularity. */
> +		force_pte = true;
> +	} else {
> +		/*
> +		 * Don't force PTEs. This requires a single page of PMDs at the
> +		 * PUD level, or a single page of PTEs at the PMD level. If we
> +		 * are at the PUD level, the PTEs will be created recursively.
> +		 */
> +		force_pte = false;
> +		nr_pages = 1;
> +	}
> +
> +	if (data->mc_capacity < nr_pages)
> +		return -ENOMEM;
> +
> +	phys = kvm_pte_to_phys(pte);
> +	prot = kvm_pgtable_stage2_pte_prot(pte);
> +
> +	childp = kvm_pgtable_stage2_create_unlinked(data->mmu->pgt, phys,
> +						    level, prot, mc, force_pte);
> +	if (IS_ERR(childp))
> +		return PTR_ERR(childp);
> +
> +	if (!stage2_try_break_pte(ctx, data->mmu)) {
> +		kvm_pgtable_stage2_free_unlinked(mm_ops, childp, level);
> +		mm_ops->put_page(childp);
> +		return -EAGAIN;
> +	}
> +
> +	/*
> +	 * Note, the contents of the page table are guaranteed to be made
> +	 * visible before the new PTE is assigned because stage2_make_pte()
> +	 * writes the PTE using smp_store_release().
> +	 */
> +	new = kvm_init_table_pte(childp, mm_ops);
> +	stage2_make_pte(ctx, new);
> +	dsb(ishst);
> +	data->mc_capacity -= nr_pages;
> +	return 0;
> +}
> +
> +int kvm_pgtable_stage2_split(struct kvm_pgtable *pgt, u64 addr, u64 size,
> +			     void *mc, u64 mc_capacity)
> +{
> +	struct stage2_split_data split_data = {
> +		.mmu		= pgt->mmu,
> +		.memcache	= mc,
> +		.mc_capacity	= mc_capacity,
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
>   int __kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
>   			      struct kvm_pgtable_mm_ops *mm_ops,
>   			      enum kvm_pgtable_stage2_flags flags,

-- 
Shaoqin

