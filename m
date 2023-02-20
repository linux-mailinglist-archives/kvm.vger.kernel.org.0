Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12CF569C563
	for <lists+kvm@lfdr.de>; Mon, 20 Feb 2023 07:37:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230267AbjBTGh2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Feb 2023 01:37:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbjBTGh0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Feb 2023 01:37:26 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 279E8D503
        for <kvm@vger.kernel.org>; Sun, 19 Feb 2023 22:36:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676874998;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8GjODHe6S++XQylWhBaNjHr8qSr1b8DgtaT4TgXobEI=;
        b=NCpYnSuZvXZ/owjP4tk2UUgYoLl+ohRNABP9Xx6cpBJDDjCrP1COgcSkwORrarO3/leJXn
        3VjGeF6tr8pBJIX04n6fcv/CYrkozxLBJmRzuVyW6vbfsOCT4xFD/OEe0+Q1EDrjLPlnDh
        jARFdEc+WPF4u3ch0xqGwQqB/TEyPFM=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-134-YtClLH8-OFmudezZf-ynYw-1; Mon, 20 Feb 2023 01:36:36 -0500
X-MC-Unique: YtClLH8-OFmudezZf-ynYw-1
Received: by mail-pj1-f70.google.com with SMTP id gt9-20020a17090af2c900b0023465ea4b65so683880pjb.3
        for <kvm@vger.kernel.org>; Sun, 19 Feb 2023 22:36:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676874995;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8GjODHe6S++XQylWhBaNjHr8qSr1b8DgtaT4TgXobEI=;
        b=EWH5z2oYBEN/K4lJvQQ+8Xu/IDR4LazE74vyvQpaBjlObOkztl79y8DgFxb/JHiXBp
         eXIOmG5DhBgjRsPayPmM53CSZhNxRc61433br3OgwwxpG0o3QepGfv4wST5Q+SLIhXAF
         ivkeK9WML5Hx37UXjx+dfm4zZPxT6ka4tMZ1yNzxKWOpcn7ud5JkeEq8R9yVD6DpnroR
         KyN5fEDoxxF1c861m/n+AnFNmLU+ti2BrWC89Zmamv/1WsB9JvCluEJsWVnNfCAgoNv5
         D6Uk/Z8Pj8qayEaCfD25776dIQGwUJ2BpvjdrEjelTxoedU29w8Rpu0f3t738hDfT0JL
         ue/Q==
X-Gm-Message-State: AO0yUKXMA7Nhy/zijemG8x/6cO77jjVTg/pOPpR327AkE2I6oHrV+gS+
        +2NI3PSuLL4aXWA1AeOXKvwOqtLHdNg3booBDJ9epndyEOprnDiELUft9FQ0CQtsGTlMXEVD04o
        z23VS0hSJtT6O
X-Received: by 2002:a62:e713:0:b0:5a9:cebd:7b79 with SMTP id s19-20020a62e713000000b005a9cebd7b79mr874869pfh.0.1676874995596;
        Sun, 19 Feb 2023 22:36:35 -0800 (PST)
X-Google-Smtp-Source: AK7set8E02nUXFpUZT0DxvGjWE7nTzqX9K4BGP1W4oErCb+WGEbDoiKUSDEreN1T1nYqO+eYiw6y2Q==
X-Received: by 2002:a62:e713:0:b0:5a9:cebd:7b79 with SMTP id s19-20020a62e713000000b005a9cebd7b79mr874843pfh.0.1676874995304;
        Sun, 19 Feb 2023 22:36:35 -0800 (PST)
Received: from [10.66.61.39] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id bm2-20020a056a00320200b005821c109cebsm1384665pfb.199.2023.02.19.22.36.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Feb 2023 22:36:34 -0800 (PST)
Message-ID: <e62b4495-3e99-d3da-8fc3-e40246ccb498@redhat.com>
Date:   Mon, 20 Feb 2023 14:35:46 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v4 03/12] KVM: arm64: Add helper for creating unlinked
 stage2 subtrees
To:     Ricardo Koller <ricarkol@google.com>, pbonzini@redhat.com,
        maz@kernel.org, oupton@google.com, yuzenghui@huawei.com,
        dmatlack@google.com
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev, qperret@google.com,
        catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, gshan@redhat.com, reijiw@google.com,
        rananta@google.com, bgardon@google.com, ricarkol@gmail.com
References: <20230218032314.635829-1-ricarkol@google.com>
 <20230218032314.635829-4-ricarkol@google.com>
Content-Language: en-US
From:   Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230218032314.635829-4-ricarkol@google.com>
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

On 2/18/23 11:23, Ricardo Koller wrote:
> Add a stage2 helper, kvm_pgtable_stage2_create_unlinked(), for
> creating unlinked tables (which is the opposite of
> kvm_pgtable_stage2_free_unlinked()).  Creating an unlinked table is
> useful for splitting PMD and PUD blocks into subtrees of PAGE_SIZE
> PTEs.  For example, a PUD can be split into PAGE_SIZE PTEs by first
> creating a fully populated tree, and then use it to replace the PUD in
> a single step.  This will be used in a subsequent commit for eager
> huge-page splitting (a dirty-logging optimization).
> 
> No functional change intended. This new function will be used in a
> subsequent commit.
> 
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>   arch/arm64/include/asm/kvm_pgtable.h | 28 +++++++++++++++++
>   arch/arm64/kvm/hyp/pgtable.c         | 46 ++++++++++++++++++++++++++++
>   2 files changed, 74 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index dcd3aafd3e6c..b8cde914cca9 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -460,6 +460,34 @@ void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt);
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
> + *		page-table pages.
> + * @force_pte:  Force mappings to PAGE_SIZE granularity.
> + *
> + * Create an unlinked page-table tree under @new. If @force_pte is
The @new parameter has been deleted, you should update the comments too.

Thanks,
Shaoqin
> + * true or @level is 2 (the PMD level), then the tree is mapped up to
> + * the PAGE_SIZE leaf PTE; the tree is mapped up one level otherwise.
> + * This new page-table tree is not reachable (i.e., it is unlinked)
> + * from the root pgd and it's therefore unreachableby the hardware
> + * page-table walker. No TLB invalidation or CMOs are performed.
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
> index 0a5ef9288371..80f2965ab0fe 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -1181,6 +1181,52 @@ int kvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size)
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
> +				  KVM_PGTABLE_WALK_SKIP_BBM |
> +				  KVM_PGTABLE_WALK_SKIP_CMO,
> +		.arg		= &map_data,
> +	};
> +	/* .addr (the IPA) is irrelevant for a removed table */
> +	struct kvm_pgtable_walk_data data = {
> +		.walker	= &walker,
> +		.addr	= 0,
> +		.end	= kvm_granule_size(level),
> +	};
> +	struct kvm_pgtable_mm_ops *mm_ops = pgt->mm_ops;
> +	kvm_pte_t *pgtable;
> +	int ret;
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

-- 
Regards,
Shaoqin

