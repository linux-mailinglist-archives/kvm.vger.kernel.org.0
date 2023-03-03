Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D1466A9279
	for <lists+kvm@lfdr.de>; Fri,  3 Mar 2023 09:32:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbjCCIcj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Mar 2023 03:32:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbjCCIcg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Mar 2023 03:32:36 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C413B44BE
        for <kvm@vger.kernel.org>; Fri,  3 Mar 2023 00:31:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677832306;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2SrZLWyV+NYc4YhMPRe6Q+B4hTIUE14K9ia6BF1JotM=;
        b=N/yN64lNlm96lV+uB9ts97+TSRNu/tCo1LwT9+a4/uvDjfhSauuSE3LPcRPhdOnDxJ+yZ+
        p2Rohpj7VI1D9eI8kHxaKIa9KlMeRAQd2a+z33N+kdgaEtQyOOCKDR1uWqrfg9Lbq59mDU
        aIXnEaEdOI0Z4syTFze7m9gtzkhJBtk=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-445-mAydoHQqNgyVnUJO-sweHw-1; Fri, 03 Mar 2023 03:31:45 -0500
X-MC-Unique: mAydoHQqNgyVnUJO-sweHw-1
Received: by mail-pf1-f197.google.com with SMTP id a10-20020a056a000c8a00b005fc6b117942so1020776pfv.2
        for <kvm@vger.kernel.org>; Fri, 03 Mar 2023 00:31:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677832304;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2SrZLWyV+NYc4YhMPRe6Q+B4hTIUE14K9ia6BF1JotM=;
        b=t9ua5Viq8M5zBJKsDMOvTcstfmdVw257Ua/PQvfF0J2jbxaks3NGwWrsV0XMhcU4NH
         +Sf7JzoDjUEttTQ0EgGY4zCWgnMKG6h/+8KXSQFhd5GlP3mFEFmhCDA4ay6C49sz99Zu
         UXnhGhw29Eyc1BILAdlRGejx+nDCNt+65YNkrbj+7ra5EPpaMitjmsHhus3mQWoWctCV
         1hwBphQVu73bW+UYbbkm3/ZsRknhxgsoG39HvFE9ZkdCPqDuNr40Ua4eFl+aHYytBQj3
         tuOzw3wKASRbjHhHMRk4Qt4CwfiqQL5Q5a8DR687F5HcAdkYJnjyeFukkONGavMkXqT+
         fJsA==
X-Gm-Message-State: AO0yUKVWmH6dcPKBW3rRMaTfgGWPoNkPM5khTPY9LqGJh0RQY0A8Kc6F
        x83E8ltlonRERUJI2hd1M1bo46IIW14XP5/82Z3uVCxU78rfM8k91wrkJO4gO47/caN22gs1mzy
        vnFSpu2LiY5O8
X-Received: by 2002:a17:902:7e88:b0:199:3f82:ef62 with SMTP id z8-20020a1709027e8800b001993f82ef62mr1448535pla.5.1677832304565;
        Fri, 03 Mar 2023 00:31:44 -0800 (PST)
X-Google-Smtp-Source: AK7set+noydgc9x8s/21QA/vZv2xFCtbXxkuyBc46PbxyI9Cty9lK5XgchBr474ufrFDJ+AxnrA8Pg==
X-Received: by 2002:a17:902:7e88:b0:199:3f82:ef62 with SMTP id z8-20020a1709027e8800b001993f82ef62mr1448509pla.5.1677832304185;
        Fri, 03 Mar 2023 00:31:44 -0800 (PST)
Received: from [10.66.61.39] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id y15-20020a17090322cf00b0019a95baaaa6sm936351plg.222.2023.03.03.00.31.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Mar 2023 00:31:43 -0800 (PST)
Message-ID: <268bae0d-4398-7137-b106-a779fb0904ca@redhat.com>
Date:   Fri, 3 Mar 2023 16:31:36 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v5 02/12] KVM: arm64: Rename free_unlinked to free_removed
Content-Language: en-US
To:     Ricardo Koller <ricarkol@google.com>, pbonzini@redhat.com,
        maz@kernel.org, oupton@google.com, yuzenghui@huawei.com,
        dmatlack@google.com
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev, qperret@google.com,
        catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, gshan@redhat.com, reijiw@google.com,
        rananta@google.com, bgardon@google.com, ricarkol@gmail.com,
        Oliver Upton <oliver.upton@linux.dev>
References: <20230301210928.565562-1-ricarkol@google.com>
 <20230301210928.565562-3-ricarkol@google.com>
From:   Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230301210928.565562-3-ricarkol@google.com>
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

Hi Ricardo,

May be replace the patch name from:
KVM: arm64: Rename free_unlinked to free_removed
to
KVM: arm64: Rename free_removed to free_unlinked

is the right description for this patch?

But in fact, it has no affect to me.

On 3/2/23 05:09, Ricardo Koller wrote:
> Normalize on referring to tables outside of an active paging structure
> as 'unlinked'.
> 
> A subsequent change to KVM will add support for building page tables
> that are not part of an active paging structure. The existing
> 'removed_table' terminology is quite clunky when applied in this
> context.
> 
> No functional change intended.
> 
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

The patch itself LGTM.

Reviewed-by: Shaoqin Huang <shahuang@redhat.com>

Thanks,

> ---
>   arch/arm64/include/asm/kvm_pgtable.h  |  8 ++++----
>   arch/arm64/kvm/hyp/nvhe/mem_protect.c |  6 +++---
>   arch/arm64/kvm/hyp/pgtable.c          |  6 +++---
>   arch/arm64/kvm/mmu.c                  | 10 +++++-----
>   4 files changed, 15 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index 252b651f743d..dcd3aafd3e6c 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -99,7 +99,7 @@ static inline bool kvm_level_supports_block_mapping(u32 level)
>    *				allocation is physically contiguous.
>    * @free_pages_exact:		Free an exact number of memory pages previously
>    *				allocated by zalloc_pages_exact.
> - * @free_removed_table:		Free a removed paging structure by unlinking and
> + * @free_unlinked_table:	Free an unlinked paging structure by unlinking and
>    *				dropping references.
>    * @get_page:			Increment the refcount on a page.
>    * @put_page:			Decrement the refcount on a page. When the
> @@ -119,7 +119,7 @@ struct kvm_pgtable_mm_ops {
>   	void*		(*zalloc_page)(void *arg);
>   	void*		(*zalloc_pages_exact)(size_t size);
>   	void		(*free_pages_exact)(void *addr, size_t size);
> -	void		(*free_removed_table)(void *addr, u32 level);
> +	void		(*free_unlinked_table)(void *addr, u32 level);
>   	void		(*get_page)(void *addr);
>   	void		(*put_page)(void *addr);
>   	int		(*page_count)(void *addr);
> @@ -450,7 +450,7 @@ int __kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
>   void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt);
>   
>   /**
> - * kvm_pgtable_stage2_free_removed() - Free a removed stage-2 paging structure.
> + * kvm_pgtable_stage2_free_unlinked() - Free an unlinked stage-2 paging structure.
>    * @mm_ops:	Memory management callbacks.
>    * @pgtable:	Unlinked stage-2 paging structure to be freed.
>    * @level:	Level of the stage-2 paging structure to be freed.
> @@ -458,7 +458,7 @@ void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt);
>    * The page-table is assumed to be unreachable by any hardware walkers prior to
>    * freeing and therefore no TLB invalidation is performed.
>    */
> -void kvm_pgtable_stage2_free_removed(struct kvm_pgtable_mm_ops *mm_ops, void *pgtable, u32 level);
> +void kvm_pgtable_stage2_free_unlinked(struct kvm_pgtable_mm_ops *mm_ops, void *pgtable, u32 level);
>   
>   /**
>    * kvm_pgtable_stage2_map() - Install a mapping in a guest stage-2 page-table.
> diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> index 552653fa18be..b030170d803b 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> @@ -91,9 +91,9 @@ static void host_s2_put_page(void *addr)
>   	hyp_put_page(&host_s2_pool, addr);
>   }
>   
> -static void host_s2_free_removed_table(void *addr, u32 level)
> +static void host_s2_free_unlinked_table(void *addr, u32 level)
>   {
> -	kvm_pgtable_stage2_free_removed(&host_mmu.mm_ops, addr, level);
> +	kvm_pgtable_stage2_free_unlinked(&host_mmu.mm_ops, addr, level);
>   }
>   
>   static int prepare_s2_pool(void *pgt_pool_base)
> @@ -110,7 +110,7 @@ static int prepare_s2_pool(void *pgt_pool_base)
>   	host_mmu.mm_ops = (struct kvm_pgtable_mm_ops) {
>   		.zalloc_pages_exact = host_s2_zalloc_pages_exact,
>   		.zalloc_page = host_s2_zalloc_page,
> -		.free_removed_table = host_s2_free_removed_table,
> +		.free_unlinked_table = host_s2_free_unlinked_table,
>   		.phys_to_virt = hyp_phys_to_virt,
>   		.virt_to_phys = hyp_virt_to_phys,
>   		.page_count = hyp_page_count,
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index e093e222daf3..0a5ef9288371 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -841,7 +841,7 @@ static int stage2_map_walk_table_pre(const struct kvm_pgtable_visit_ctx *ctx,
>   	if (ret)
>   		return ret;
>   
> -	mm_ops->free_removed_table(childp, ctx->level);
> +	mm_ops->free_unlinked_table(childp, ctx->level);
>   	return 0;
>   }
>   
> @@ -886,7 +886,7 @@ static int stage2_map_walk_leaf(const struct kvm_pgtable_visit_ctx *ctx,
>    * The TABLE_PRE callback runs for table entries on the way down, looking
>    * for table entries which we could conceivably replace with a block entry
>    * for this mapping. If it finds one it replaces the entry and calls
> - * kvm_pgtable_mm_ops::free_removed_table() to tear down the detached table.
> + * kvm_pgtable_mm_ops::free_unlinked_table() to tear down the detached table.
>    *
>    * Otherwise, the LEAF callback performs the mapping at the existing leaves
>    * instead.
> @@ -1250,7 +1250,7 @@ void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt)
>   	pgt->pgd = NULL;
>   }
>   
> -void kvm_pgtable_stage2_free_removed(struct kvm_pgtable_mm_ops *mm_ops, void *pgtable, u32 level)
> +void kvm_pgtable_stage2_free_unlinked(struct kvm_pgtable_mm_ops *mm_ops, void *pgtable, u32 level)
>   {
>   	kvm_pteref_t ptep = (kvm_pteref_t)pgtable;
>   	struct kvm_pgtable_walker walker = {
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index a3ee3b605c9b..9bd3c2cfb476 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -130,21 +130,21 @@ static void kvm_s2_free_pages_exact(void *virt, size_t size)
>   
>   static struct kvm_pgtable_mm_ops kvm_s2_mm_ops;
>   
> -static void stage2_free_removed_table_rcu_cb(struct rcu_head *head)
> +static void stage2_free_unlinked_table_rcu_cb(struct rcu_head *head)
>   {
>   	struct page *page = container_of(head, struct page, rcu_head);
>   	void *pgtable = page_to_virt(page);
>   	u32 level = page_private(page);
>   
> -	kvm_pgtable_stage2_free_removed(&kvm_s2_mm_ops, pgtable, level);
> +	kvm_pgtable_stage2_free_unlinked(&kvm_s2_mm_ops, pgtable, level);
>   }
>   
> -static void stage2_free_removed_table(void *addr, u32 level)
> +static void stage2_free_unlinked_table(void *addr, u32 level)
>   {
>   	struct page *page = virt_to_page(addr);
>   
>   	set_page_private(page, (unsigned long)level);
> -	call_rcu(&page->rcu_head, stage2_free_removed_table_rcu_cb);
> +	call_rcu(&page->rcu_head, stage2_free_unlinked_table_rcu_cb);
>   }
>   
>   static void kvm_host_get_page(void *addr)
> @@ -681,7 +681,7 @@ static struct kvm_pgtable_mm_ops kvm_s2_mm_ops = {
>   	.zalloc_page		= stage2_memcache_zalloc_page,
>   	.zalloc_pages_exact	= kvm_s2_zalloc_pages_exact,
>   	.free_pages_exact	= kvm_s2_free_pages_exact,
> -	.free_removed_table	= stage2_free_removed_table,
> +	.free_unlinked_table	= stage2_free_unlinked_table,
>   	.get_page		= kvm_host_get_page,
>   	.put_page		= kvm_s2_put_page,
>   	.page_count		= kvm_host_page_count,

-- 
Shaoqin

