Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81BCF699438
	for <lists+kvm@lfdr.de>; Thu, 16 Feb 2023 13:23:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbjBPMXV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Feb 2023 07:23:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjBPMXU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Feb 2023 07:23:20 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D2C6359A
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 04:22:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676550152;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uu9F92433KQz82bOPLwkQk65uUslqk/7EoD1ZlUl9+s=;
        b=WpOEGfEE1VrVx2X6/4V8Nz5I7r5X9u6W+PSTd66LPeXNT5ERvtckcR5KWqFXezODd1qVbJ
        k9UFgQ39hYjWNOo06fL73lYM7i4NEIgQm5FgWk6LJzZ2oOBGaCb7kZo0xaKOTSCQWw9UQI
        pMnAoUA4wbcufVUrDt5MVk8VvdCpMXo=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-42-RmywwALyON6AU9fpLQ_h6g-1; Thu, 16 Feb 2023 07:22:31 -0500
X-MC-Unique: RmywwALyON6AU9fpLQ_h6g-1
Received: by mail-qt1-f200.google.com with SMTP id c16-20020ac85190000000b003b841d1118aso1091464qtn.17
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 04:22:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676550150;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uu9F92433KQz82bOPLwkQk65uUslqk/7EoD1ZlUl9+s=;
        b=LAg90Ldnt9ZhFRgtrhig5dxfjW37EisQ8GsGSbQbZ4dZmDJNjDPpxlpo4nY2UPfQnw
         U0DKYHKTSA/ciJdApECJb5SSza3u8InchCYcpJRypwRZb3oikjnydKSL3YRR/jeMpwEw
         qyH916mr73GM3D0PWZET5JmA/R6AVC4nQM5mC6uBffMqhgv5zywkxPeJ6NKWQaE+2hS0
         +MONGKYbe2HhLwsVIhFDvBlB/k/RjicY/JmFS8yN4PJJhaWegv29qwKzhibJvyic4het
         DXN6TPjYCWhDfQqZ/vzceFo0WevTsEpbTSDcwb0igd7ZPdk9vzOg5eXa/V+NSwe6KaWG
         D/pw==
X-Gm-Message-State: AO0yUKUSgOwRgxTPRJ+uq9kzNnz2jdX9jK4tImBAjIVJ7bhVxy30Ym2d
        YsFUd9bn/HRWJZdfr6Kyd709cBKQErwjo+5V9moB+EJlgI3B8vbpBgJ/1H2uW7VOxTK6b9pbfK3
        NS80GjRALPjUK
X-Received: by 2002:a0c:e1cc:0:b0:56c:222d:427a with SMTP id v12-20020a0ce1cc000000b0056c222d427amr8617227qvl.1.1676550150694;
        Thu, 16 Feb 2023 04:22:30 -0800 (PST)
X-Google-Smtp-Source: AK7set968vpM1j6c42DcAjrxp25iMMpBNuVNfxcQfnhM/pmJyn3rfRG/g4jcGPafSERlnmvUHnjelw==
X-Received: by 2002:a0c:e1cc:0:b0:56c:222d:427a with SMTP id v12-20020a0ce1cc000000b0056c222d427amr8617207qvl.1.1676550150421;
        Thu, 16 Feb 2023 04:22:30 -0800 (PST)
Received: from [10.66.61.39] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id e67-20020a378246000000b0071c535f3ff3sm1088742qkd.6.2023.02.16.04.22.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Feb 2023 04:22:30 -0800 (PST)
Message-ID: <93595bc0-02fb-7e4f-f87e-2d03f604c0e8@redhat.com>
Date:   Thu, 16 Feb 2023 20:22:21 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v3 04/12] KVM: arm64: Add kvm_pgtable_stage2_split()
To:     Ricardo Koller <ricarkol@google.com>, pbonzini@redhat.com,
        maz@kernel.org, oupton@google.com, yuzenghui@huawei.com,
        dmatlack@google.com
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev, qperret@google.com,
        catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, gshan@redhat.com, reijiw@google.com,
        rananta@google.com, bgardon@google.com, ricarkol@gmail.com
References: <20230215174046.2201432-1-ricarkol@google.com>
 <20230215174046.2201432-5-ricarkol@google.com>
Content-Language: en-US
From:   Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230215174046.2201432-5-ricarkol@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Ricardo,

On 2/16/23 01:40, Ricardo Koller wrote:
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
>   arch/arm64/include/asm/kvm_pgtable.h |  30 ++++++++
>   arch/arm64/kvm/hyp/pgtable.c         | 105 +++++++++++++++++++++++++++
>   2 files changed, 135 insertions(+)
>
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index 2ea397ad3e63..b28489aa0994 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -658,6 +658,36 @@ bool kvm_pgtable_stage2_is_young(struct kvm_pgtable *pgt, u64 addr);
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
> index fed314f2b320..e2fb78398b3d 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -1229,6 +1229,111 @@ int kvm_pgtable_stage2_create_unlinked(struct kvm_pgtable *pgt,
>   	return 0;
>   }
>   
> +struct stage2_split_data {
> +	struct kvm_s2_mmu		*mmu;
> +	void				*memcache;
> +	u64				mc_capacity;
> +};
> +
> +/*
> + * Get the number of page-tables needed to replace a bock with a fully

/s/bock/block

Thanks,

> + * populated tree, up to the PTE level, at particular level.
> + */
> +static inline u32 stage2_block_get_nr_page_tables(u32 level)
> +{
> +	switch (level) {
> +	/* There are no blocks at level 0 */
> +	case 1: return 1 + PTRS_PER_PTE;
> +	case 2: return 1;
> +	case 3: return 0;
> +	default:
> +		WARN_ON_ONCE(1);
> +		return ~0;
> +	}
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
> +	u64 phys, nr_pages;
> +	bool force_pte;
> +	int ret;
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
> +	ret = kvm_pgtable_stage2_create_unlinked(data->mmu->pgt, &new, phys,
> +						 level, prot, mc, force_pte);
> +	if (ret)
> +		return ret;
> +
> +	if (!stage2_try_break_pte(ctx, data->mmu)) {
> +		childp = kvm_pte_follow(new, mm_ops);
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
Regards,
Shaoqin

