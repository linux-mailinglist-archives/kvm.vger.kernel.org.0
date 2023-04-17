Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13C246E3F9A
	for <lists+kvm@lfdr.de>; Mon, 17 Apr 2023 08:19:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230049AbjDQGTq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Apr 2023 02:19:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230003AbjDQGTp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Apr 2023 02:19:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F0123ABC
        for <kvm@vger.kernel.org>; Sun, 16 Apr 2023 23:18:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681712331;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ty/AIseaiREXChMM5nDN57NtPbDNuS53lakU5EfBtIY=;
        b=E1JMztF0c7OFO2qX5JsyY2Uj8B4JNNht/L+z6lwq0SIm4//OThbpiZp8VIVDK5Ma0ymbK8
        +P+0TPOppcOWaO++CZqGCb+T5O/KUVChLoApDQuHQNFqaPkoF6iYLBnJpCEsy/ipczhYhb
        OL0ilcsTn+tthANU3yuOEmcfgmTzWWU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-271-x11MFGGXMzeNa4-Hozc7Ng-1; Mon, 17 Apr 2023 02:18:43 -0400
X-MC-Unique: x11MFGGXMzeNa4-Hozc7Ng-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4DD1F185A78F;
        Mon, 17 Apr 2023 06:18:42 +0000 (UTC)
Received: from [10.72.13.187] (ovpn-13-187.pek2.redhat.com [10.72.13.187])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4DF8740C6E6E;
        Mon, 17 Apr 2023 06:18:29 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v7 03/12] KVM: arm64: Add helper for creating unlinked
 stage2 subtrees
To:     Ricardo Koller <ricarkol@google.com>, pbonzini@redhat.com,
        maz@kernel.org, oupton@google.com, yuzenghui@huawei.com,
        dmatlack@google.com
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev, qperret@google.com,
        catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, reijiw@google.com, rananta@google.com,
        bgardon@google.com, ricarkol@gmail.com,
        Shaoqin Huang <shahuang@redhat.com>
References: <20230409063000.3559991-1-ricarkol@google.com>
 <20230409063000.3559991-5-ricarkol@google.com>
From:   Gavin Shan <gshan@redhat.com>
Message-ID: <9cb621b0-7174-a7c7-1524-801b06f94e8f@redhat.com>
Date:   Mon, 17 Apr 2023 14:18:26 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20230409063000.3559991-5-ricarkol@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/9/23 2:29 PM, Ricardo Koller wrote:
> Add a stage2 helper, kvm_pgtable_stage2_create_unlinked(), for
> creating unlinked tables (which is the opposite of
> kvm_pgtable_stage2_free_unlinked()).  Creating an unlinked table is
> useful for splitting level 1 and 2 entries into subtrees of PAGE_SIZE
> PTEs.  For example, a level 1 entry can be split into PAGE_SIZE PTEs
> by first creating a fully populated tree, and then use it to replace
> the level 1 entry in a single step.  This will be used in a subsequent
> commit for eager huge-page splitting (a dirty-logging optimization).
> 
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> ---
>   arch/arm64/include/asm/kvm_pgtable.h | 26 +++++++++++++++
>   arch/arm64/kvm/hyp/pgtable.c         | 49 ++++++++++++++++++++++++++++
>   2 files changed, 75 insertions(+)
> 

With the following nits addressed:

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index 3f2d43ba2b628..c8e0e7d9303b2 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -458,6 +458,32 @@ void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt);
>    */
>   void kvm_pgtable_stage2_free_unlinked(struct kvm_pgtable_mm_ops *mm_ops, void *pgtable, u32 level);
>   
> +/**
> + * kvm_pgtable_stage2_create_unlinked() - Create an unlinked stage-2 paging structure.
> + * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init*().
> + * @phys:	Physical address of the memory to map.
> + * @level:	Starting level of the stage-2 paging structure to be created.
> + * @prot:	Permissions and attributes for the mapping.
> + * @mc:		Cache of pre-allocated and zeroed memory from which to allocate
                 ^^^^^^^^
Alignment.

> + *		page-table pages.
> + * @force_pte:  Force mappings to PAGE_SIZE granularity.
> + *
> + * Returns an unlinked page-table tree.  This new page-table tree is
> + * not reachable (i.e., it is unlinked) from the root pgd and it's
> + * therefore unreachableby the hardware page-table walker. No TLB
> + * invalidation or CMOs are performed.
> + *
> + * If device attributes are not explicitly requested in @prot, then the
> + * mapping will be normal, cacheable.
> + *
> + * Return: The fully populated (unlinked) stage-2 paging structure, or
> + * an ERR_PTR(error) on failure.
> + */
> +kvm_pte_t *kvm_pgtable_stage2_create_unlinked(struct kvm_pgtable *pgt,
> +					      u64 phys, u32 level,
> +					      enum kvm_pgtable_prot prot,
> +					      void *mc, bool force_pte);
> +
>   /**
>    * kvm_pgtable_stage2_map() - Install a mapping in a guest stage-2 page-table.
>    * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init*().
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 633679ee3c49a..477d2be67d401 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -1222,6 +1222,55 @@ int kvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size)
>   	return kvm_pgtable_walk(pgt, addr, size, &walker);
>   }
>   
> +kvm_pte_t *kvm_pgtable_stage2_create_unlinked(struct kvm_pgtable *pgt,
> +					      u64 phys, u32 level,
> +					      enum kvm_pgtable_prot prot,
> +					      void *mc, bool force_pte)
> +{
> +	struct stage2_map_data map_data = {
> +		.phys		= phys,
> +		.mmu		= pgt->mmu,
> +		.memcache	= mc,
> +		.force_pte	= force_pte,
> +	};
> +	struct kvm_pgtable_walker walker = {
> +		.cb		= stage2_map_walker,
> +		.flags		= KVM_PGTABLE_WALK_LEAF |
> +				  KVM_PGTABLE_WALK_SKIP_BBM_TLBI |
> +				  KVM_PGTABLE_WALK_SKIP_CMO,
> +		.arg		= &map_data,
> +	};
> +	/* .addr (the IPA) is irrelevant for an unlinked table */
> +	struct kvm_pgtable_walk_data data = {
> +		.walker	= &walker,
> +		.addr	= 0,
> +		.end	= kvm_granule_size(level),
> +	};

The comment about '.addr' seems incorrect. The IPA address is still
used to locate the page table entry, so I think it would be something
like below:

	/* The IPA address (.addr) is relative to zero */

> +	struct kvm_pgtable_mm_ops *mm_ops = pgt->mm_ops;
> +	kvm_pte_t *pgtable;
> +	int ret;
> +
> +	if (!IS_ALIGNED(phys, kvm_granule_size(level)))
> +		return ERR_PTR(-EINVAL);
> +
> +	ret = stage2_set_prot_attr(pgt, prot, &map_data.attr);
> +	if (ret)
> +		return ERR_PTR(ret);
> +
> +	pgtable = mm_ops->zalloc_page(mc);
> +	if (!pgtable)
> +		return ERR_PTR(-ENOMEM);
> +
> +	ret = __kvm_pgtable_walk(&data, mm_ops, (kvm_pteref_t)pgtable,
> +				 level + 1);
> +	if (ret) {
> +		kvm_pgtable_stage2_free_unlinked(mm_ops, pgtable, level);
> +		mm_ops->put_page(pgtable);
> +		return ERR_PTR(ret);
> +	}
> +
> +	return pgtable;
> +}
>   
>   int __kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
>   			      struct kvm_pgtable_mm_ops *mm_ops,
> 

Thanks,
Gavin

