Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3620469A4A1
	for <lists+kvm@lfdr.de>; Fri, 17 Feb 2023 05:08:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230120AbjBQEIN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Feb 2023 23:08:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229823AbjBQEIL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Feb 2023 23:08:11 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DD40166DC
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 20:07:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676606843;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TWQfzUcCwlzm6sKehp4ZpwCoGpqZRGcu2EZK4t1AGuM=;
        b=ANojH85Kr/GYsTm0WFc0nwcXyQyqf86SEGpH71KPtrCDpXDHiWHggyxO+pvblHZ3Bu7UCr
        WtWbRDpHgOnxcMCNc08+1yCXLIEJ6VSvRiSTYAsFj+8fG2Gdau50C8oOUKE2I+FoViE4Ew
        LjUKngal7AJeramGIhhTeXVm9aji1k4=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-464-0LIUc3WoMkGw10qsHHb4Uw-1; Thu, 16 Feb 2023 23:07:21 -0500
X-MC-Unique: 0LIUc3WoMkGw10qsHHb4Uw-1
Received: by mail-pj1-f71.google.com with SMTP id gn18-20020a17090ac79200b0022bef1f49c9so4152406pjb.0
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 20:07:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TWQfzUcCwlzm6sKehp4ZpwCoGpqZRGcu2EZK4t1AGuM=;
        b=wOhOJNzngjsJAE4s9M6JjNXSv6vrfoOHhKZukmOlJSNDWoHItfH8xJh5wxB4j5M4NV
         IV07d8PdyIlOeq0X90xvRbAkAtU5EbNt504w7BGT/HicT/tRLxSxoMz1kgPeoi3XlgEF
         W/PGOR4kxTXZjc3bjz4FqsUoGUkhUN/zVovaxGnOpru37Ribl2OANEsEu/GbCutmDqVf
         c2ikWn2zmJBDg9bLp28roeXX/8dY+X61GZXhShYgLFbFI93adYbo8YbVFcDdVsWVqJYN
         CThKKgzQio2H3CXpQ4FqWx3jDTkvEdx8ryn6lwatwSGPDPRSoa3FIIkEb6+QMasXQFES
         Niow==
X-Gm-Message-State: AO0yUKXb/fmeIW61+FooUx46pP08KKAgaklmPbSjPYil1jBg7/DumAPw
        XUkDkohWZq+qxaV1y6PegdrfDXGeYwoItdm5AsCvnrT4yv/ORI8uKLnvk/ZicVG9RjvYuDGQ1xm
        +XEEzL9iMqpR3
X-Received: by 2002:a05:6a00:cce:b0:5a9:b4c6:c07c with SMTP id b14-20020a056a000cce00b005a9b4c6c07cmr3136851pfv.0.1676606840706;
        Thu, 16 Feb 2023 20:07:20 -0800 (PST)
X-Google-Smtp-Source: AK7set/HhmzhIvwODyOOUf9AdQnW43QbUPXFNc3K5/CqbRQRmJyVplWpkivs2LFTRWh1IEFIVBO3+Q==
X-Received: by 2002:a05:6a00:cce:b0:5a9:b4c6:c07c with SMTP id b14-20020a056a000cce00b005a9b4c6c07cmr3136817pfv.0.1676606840275;
        Thu, 16 Feb 2023 20:07:20 -0800 (PST)
Received: from [10.66.61.39] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b14-20020a65668e000000b004fb997a0bd8sm1905130pgw.30.2023.02.16.20.07.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Feb 2023 20:07:19 -0800 (PST)
Message-ID: <073043b0-522d-0c5c-7a85-35ef5112e6d9@redhat.com>
Date:   Fri, 17 Feb 2023 12:07:12 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v3 04/12] KVM: arm64: Add kvm_pgtable_stage2_split()
Content-Language: en-US
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
From:   Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230215174046.2201432-5-ricarkol@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
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
> + * populated tree, up to the PTE level, at particular level.
> + */
> +static inline u32 stage2_block_get_nr_page_tables(u32 level)
> +{
> +	switch (level) {
> +	/* There are no blocks at level 0 */
> +	case 1: return 1 + PTRS_PER_PTE;
> +	case 2: return 1;
> +	case 3: return 0;

Is the level 3 check really needed?
Because level 3 will be first detected by:

+ if (level == KVM_PGTABLE_MAX_LEVELS - 1)
+ return 0;

in the stage2_split_walker().

Even if the case 3 return 0 and continue execute, it will still trigger:
kvm_pgtable_stage2_create_unlinked(..level..)
   -> __kvm_pgtable_walk(..level+1..)
     -> WARN_ON_ONCE(level >= KVM_PGTABLE_MAX_LEVELS)

Thanks,
Shaoqin

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

