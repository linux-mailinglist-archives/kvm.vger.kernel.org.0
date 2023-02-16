Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07788698AB3
	for <lists+kvm@lfdr.de>; Thu, 16 Feb 2023 03:57:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbjBPC5S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Feb 2023 21:57:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbjBPC5P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Feb 2023 21:57:15 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D4CC460A9
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 18:56:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676516185;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Z/BrsSSGAOoG6zhueBEZJOhOvwif9A6DCJn36xegp8k=;
        b=VMkWaBA/MYKerSDuXU2FCO3XcLQ22EjSpDIQclG3dI3D3BSEvgwG8AV4w4NFgoWXm7IGap
        SP+5D8mOM6nBN7RtuyW3ChwYgBEM7OopOqqXkgL/aRPfjQ+IZJYdvuRBNGidT4VHgxQJsk
        aqDH/LZB9zMfJV1r5h9X1qjeEv9GcFo=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-151-uX2x3QqPMRG4Bpt96o2ZHw-1; Wed, 15 Feb 2023 21:56:24 -0500
X-MC-Unique: uX2x3QqPMRG4Bpt96o2ZHw-1
Received: by mail-qk1-f197.google.com with SMTP id h13-20020a05620a244d00b006fb713618b8so426134qkn.0
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 18:56:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Z/BrsSSGAOoG6zhueBEZJOhOvwif9A6DCJn36xegp8k=;
        b=k+ddzrzdZSBxuLF2nLaZArUfpngVBBpM3xBYd97/WSj4y+csqeP+auwdAw3oAtebCC
         Ksd/jgp5r7CLy+Tg5Ho5uOCnIqVa6IGxmL6pLn3Xy75q825+LIM1wuILRnSJxEGQB2L+
         eOYmjC/DeonDkgzy4TQpp6/CoSYY1XbpEjrvhg3uVJKZBp2SqHBbR9jh4PSN18z1hjKi
         Y84gqO96lOyGOwqzbsr00/DkUQbLQgTLlzhC0RrHmf/ZXrKHGdNnFUF2F1CEQPlPOSn9
         H+gQXcHav+Q0bfgfEiPzvPsjC1P+ZMASlrmP+Lg1lWnmE57lPuJt/m/iNmdGneG4mnQd
         PegA==
X-Gm-Message-State: AO0yUKVKkiUiTb/cIwnFHUrNxZiTKXZV7J3Qt+1a3qoSDggW2Jp6R8V7
        ChD0SzEzWOFGYw6FsQGIIwyFDVd2RdsdW1g9o5IIRIbUSmoCtcnjc4A1xWnz+qMLmxUQVcxMs6m
        WRsk5UxNUC8Gq
X-Received: by 2002:ac8:7e90:0:b0:3bb:7875:1bc1 with SMTP id w16-20020ac87e90000000b003bb78751bc1mr8644988qtj.4.1676516183654;
        Wed, 15 Feb 2023 18:56:23 -0800 (PST)
X-Google-Smtp-Source: AK7set/xjLKjxcngzyi9vsYKhuVKOGmUPKM9Q7gJ5Cab8eX3TKZ3pUR6WYQ8WD1ZGMZlJ4B24iqpYQ==
X-Received: by 2002:ac8:7e90:0:b0:3bb:7875:1bc1 with SMTP id w16-20020ac87e90000000b003bb78751bc1mr8644956qtj.4.1676516183340;
        Wed, 15 Feb 2023 18:56:23 -0800 (PST)
Received: from [10.66.61.39] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id t85-20020a374658000000b007186c9e167esm318445qka.52.2023.02.15.18.56.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Feb 2023 18:56:22 -0800 (PST)
Message-ID: <29b8ac39-555d-ae3d-c583-ba186b473481@redhat.com>
Date:   Thu, 16 Feb 2023 10:56:15 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v3 01/12] KVM: arm64: Add KVM_PGTABLE_WALK ctx->flags for
 skipping BBM and CMO
To:     Ricardo Koller <ricarkol@google.com>, pbonzini@redhat.com,
        maz@kernel.org, oupton@google.com, yuzenghui@huawei.com,
        dmatlack@google.com
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev, qperret@google.com,
        catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, gshan@redhat.com, reijiw@google.com,
        rananta@google.com, bgardon@google.com, ricarkol@gmail.com
References: <20230215174046.2201432-1-ricarkol@google.com>
 <20230215174046.2201432-2-ricarkol@google.com>
Content-Language: en-US
From:   Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230215174046.2201432-2-ricarkol@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
> Add two flags to kvm_pgtable_visit_ctx, KVM_PGTABLE_WALK_SKIP_BBM and
> KVM_PGTABLE_WALK_SKIP_CMO, to indicate that the walk should not
> perform break-before-make (BBM) nor cache maintenance operations
> (CMO). This will by a future commit to create unlinked tables not
> accessible to the HW page-table walker.  This is safe as these removed
> tables are not visible to the HW page-table walker.
>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>   arch/arm64/include/asm/kvm_pgtable.h | 18 ++++++++++++++++++
>   arch/arm64/kvm/hyp/pgtable.c         | 27 ++++++++++++++++-----------
>   2 files changed, 34 insertions(+), 11 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index 63f81b27a4e3..3339192a97a9 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -188,12 +188,20 @@ typedef bool (*kvm_pgtable_force_pte_cb_t)(u64 addr, u64 end,
>    *					children.
>    * @KVM_PGTABLE_WALK_SHARED:		Indicates the page-tables may be shared
>    *					with other software walkers.
> + * @KVM_PGTABLE_WALK_SKIP_BBM:		Visit and update table entries
> + *					without Break-before-make
> + *					requirements.
> + * @KVM_PGTABLE_WALK_SKIP_CMO:		Visit and update table entries
> + *					without Cache maintenance
> + *					operations required.
>    */
>   enum kvm_pgtable_walk_flags {
>   	KVM_PGTABLE_WALK_LEAF			= BIT(0),
>   	KVM_PGTABLE_WALK_TABLE_PRE		= BIT(1),
>   	KVM_PGTABLE_WALK_TABLE_POST		= BIT(2),
>   	KVM_PGTABLE_WALK_SHARED			= BIT(3),
> +	KVM_PGTABLE_WALK_SKIP_BBM		= BIT(4),
> +	KVM_PGTABLE_WALK_SKIP_CMO		= BIT(4),

The KVM_PGTABLE_WALK_SKIP_BBM and KVM_PGTABLE_WALK_SKIP_CMO use the same 
BIT(4), if I understand correctly, the two flags are used in different 
operation and will never be used at the same time.


Maybe add some comments to illustrate why the two use the same bit can 
be better.


>   };
>   
>   struct kvm_pgtable_visit_ctx {
> @@ -215,6 +223,16 @@ static inline bool kvm_pgtable_walk_shared(const struct kvm_pgtable_visit_ctx *c
>   	return ctx->flags & KVM_PGTABLE_WALK_SHARED;
>   }
>   
> +static inline bool kvm_pgtable_walk_skip_bbm(const struct kvm_pgtable_visit_ctx *ctx)
> +{
> +	return ctx->flags & KVM_PGTABLE_WALK_SKIP_BBM;
> +}
> +
> +static inline bool kvm_pgtable_walk_skip_cmo(const struct kvm_pgtable_visit_ctx *ctx)
> +{
> +	return ctx->flags & KVM_PGTABLE_WALK_SKIP_CMO;
> +}
> +
>   /**
>    * struct kvm_pgtable_walker - Hook into a page-table walk.
>    * @cb:		Callback function to invoke during the walk.
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index b11cf2c618a6..e093e222daf3 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -717,14 +717,17 @@ static bool stage2_try_break_pte(const struct kvm_pgtable_visit_ctx *ctx,
>   	if (!stage2_try_set_pte(ctx, KVM_INVALID_PTE_LOCKED))
>   		return false;
>   
> -	/*
> -	 * Perform the appropriate TLB invalidation based on the evicted pte
> -	 * value (if any).
> -	 */
> -	if (kvm_pte_table(ctx->old, ctx->level))
> -		kvm_call_hyp(__kvm_tlb_flush_vmid, mmu);
> -	else if (kvm_pte_valid(ctx->old))
> -		kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu, ctx->addr, ctx->level);
> +	if (!kvm_pgtable_walk_skip_bbm(ctx)) {
> +		/*
> +		 * Perform the appropriate TLB invalidation based on the
> +		 * evicted pte value (if any).
> +		 */
> +		if (kvm_pte_table(ctx->old, ctx->level))
> +			kvm_call_hyp(__kvm_tlb_flush_vmid, mmu);
> +		else if (kvm_pte_valid(ctx->old))
> +			kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu,
> +				     ctx->addr, ctx->level);
> +	}
>   
>   	if (stage2_pte_is_counted(ctx->old))
>   		mm_ops->put_page(ctx->ptep);
> @@ -808,11 +811,13 @@ static int stage2_map_walker_try_leaf(const struct kvm_pgtable_visit_ctx *ctx,
>   		return -EAGAIN;
>   
>   	/* Perform CMOs before installation of the guest stage-2 PTE */
> -	if (mm_ops->dcache_clean_inval_poc && stage2_pte_cacheable(pgt, new))
> +	if (!kvm_pgtable_walk_skip_cmo(ctx) && mm_ops->dcache_clean_inval_poc &&
> +	    stage2_pte_cacheable(pgt, new))
>   		mm_ops->dcache_clean_inval_poc(kvm_pte_follow(new, mm_ops),
> -						granule);
> +					       granule);
>   
> -	if (mm_ops->icache_inval_pou && stage2_pte_executable(new))
> +	if (!kvm_pgtable_walk_skip_cmo(ctx) && mm_ops->icache_inval_pou &&
> +	    stage2_pte_executable(new))
>   		mm_ops->icache_inval_pou(kvm_pte_follow(new, mm_ops), granule);
>   
>   	stage2_make_pte(ctx, new);

-- 
Regards,
Shaoqin

