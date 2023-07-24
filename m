Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1BE375EF3A
	for <lists+kvm@lfdr.de>; Mon, 24 Jul 2023 11:35:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbjGXJfs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jul 2023 05:35:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229831AbjGXJfq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jul 2023 05:35:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A68F12E
        for <kvm@vger.kernel.org>; Mon, 24 Jul 2023 02:35:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690191299;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+aRVEy8W9VZsmtykV3MS4fg+1kXzADTBk7CG7c2ZXbE=;
        b=UoiFadmy4MpH4ah4EWPELSE9LzKzxPKiTZPXiy86htqLPiQjMRGAvrPFjbXJIauri+jIVb
        7PpkzZ5zsSQmqIcZt9AEYOM6Q0oVPvVbCw73ordLz+Dg5cRAS5OcU8ATVTuDmO+2fS69Ig
        CzVigabAQza1E/ec7tCRKYnUjzmsHwM=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-163-3aQAgRZOPwyGh_o_h_pU9g-1; Mon, 24 Jul 2023 05:34:58 -0400
X-MC-Unique: 3aQAgRZOPwyGh_o_h_pU9g-1
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-34659f3d04cso4388355ab.1
        for <kvm@vger.kernel.org>; Mon, 24 Jul 2023 02:34:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690191297; x=1690796097;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+aRVEy8W9VZsmtykV3MS4fg+1kXzADTBk7CG7c2ZXbE=;
        b=ZT6gFWwgpNyvavfJjJIaSDqAk60v+5UryJij+pYNceWVdNtTzuG80PRDQ3J7+Oc/FP
         0EmGUT5Dvpex+8nHhKZB72tNrA6dZsS6LPdDHSPDf3WgaanRtGsPjouc+gSfkpV0qesV
         pj3PAAO0s6q92mx9DepBbKsXqP8kv9DQMH2wY7ygIwXS9XQeoIA9xwSyZLgh9TY/mJh2
         VBqRG3L3RRP+pKHdsKHYl+ukUC1GoS9hKQNSeNOKkHFqn31fGxztQzjuwxDSQ8mqeiS3
         Ot5V8vjaVYQFUgiMGxJAYXdQOUkffCOIodImvFHKqstKsJOAIoaMIba0EQgd0mzZUarK
         9KbQ==
X-Gm-Message-State: ABy/qLan3Dvg+SNScQ6VLK53DLkTJiEJtn9W5lDvUM7KQNhOXAvk0FyO
        7WlPOdsRaNqvA1b+9KEtzGv+Vb22J22D1UR58HbiHN/JKRoKyeo6XQZWn3gJ+ehiP4Fny6lGYrt
        cMwUFtAtp1Flf
X-Received: by 2002:a92:cecf:0:b0:348:d2e9:399a with SMTP id z15-20020a92cecf000000b00348d2e9399amr1415921ilq.1.1690191297454;
        Mon, 24 Jul 2023 02:34:57 -0700 (PDT)
X-Google-Smtp-Source: APBJJlG6NmNRqSH1n6n4EBMT9iuWXK0UDAK+VvUY/g4ptdk4KWrWf/bvtDD8DcAuDIFVkgfhDqFXAA==
X-Received: by 2002:a92:cecf:0:b0:348:d2e9:399a with SMTP id z15-20020a92cecf000000b00348d2e9399amr1415902ilq.1.1690191297214;
        Mon, 24 Jul 2023 02:34:57 -0700 (PDT)
Received: from [10.66.61.39] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id gv17-20020a17090b11d100b00265dc26d8dfsm7966842pjb.27.2023.07.24.02.34.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Jul 2023 02:34:56 -0700 (PDT)
Message-ID: <0841aca6-2824-6a1b-a568-119f8bd220de@redhat.com>
Date:   Mon, 24 Jul 2023 17:34:51 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v7 12/12] KVM: arm64: Use TLBI range-based intructions for
 unmap
Content-Language: en-US
To:     Raghavendra Rao Ananta <rananta@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Jing Zhang <jingzhangos@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        David Matlack <dmatlack@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <20230722022251.3446223-1-rananta@google.com>
 <20230722022251.3446223-13-rananta@google.com>
From:   Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230722022251.3446223-13-rananta@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Raghavendra,

On 7/22/23 10:22, Raghavendra Rao Ananta wrote:
> The current implementation of the stage-2 unmap walker traverses
> the given range and, as a part of break-before-make, performs
> TLB invalidations with a DSB for every PTE. A multitude of this
> combination could cause a performance bottleneck on some systems.
> 
> Hence, if the system supports FEAT_TLBIRANGE, defer the TLB
> invalidations until the entire walk is finished, and then
> use range-based instructions to invalidate the TLBs in one go.
> Condition deferred TLB invalidation on the system supporting FWB,
> as the optimization is entirely pointless when the unmap walker
> needs to perform CMOs.
> 
> Rename stage2_put_pte() to stage2_unmap_put_pte() as the function
> now serves the stage-2 unmap walker specifically, rather than
> acting generic.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>   arch/arm64/kvm/hyp/pgtable.c | 67 +++++++++++++++++++++++++++++++-----
>   1 file changed, 58 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 5ef098af1736..cf88933a2ea0 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -831,16 +831,54 @@ static void stage2_make_pte(const struct kvm_pgtable_visit_ctx *ctx, kvm_pte_t n
>   	smp_store_release(ctx->ptep, new);
>   }
>   
> -static void stage2_put_pte(const struct kvm_pgtable_visit_ctx *ctx, struct kvm_s2_mmu *mmu,
> -			   struct kvm_pgtable_mm_ops *mm_ops)
> +struct stage2_unmap_data {
> +	struct kvm_pgtable *pgt;
> +	bool defer_tlb_flush_init;
> +};
> +
> +static bool __stage2_unmap_defer_tlb_flush(struct kvm_pgtable *pgt)
> +{
> +	/*
> +	 * If FEAT_TLBIRANGE is implemented, defer the individual
> +	 * TLB invalidations until the entire walk is finished, and
> +	 * then use the range-based TLBI instructions to do the
> +	 * invalidations. Condition deferred TLB invalidation on the
> +	 * system supporting FWB, as the optimization is entirely
> +	 * pointless when the unmap walker needs to perform CMOs.
> +	 */
> +	return system_supports_tlb_range() && stage2_has_fwb(pgt);
> +}
> +
> +static bool stage2_unmap_defer_tlb_flush(struct stage2_unmap_data *unmap_data)
> +{
> +	bool defer_tlb_flush = __stage2_unmap_defer_tlb_flush(unmap_data->pgt);
> +
> +	/*
> +	 * Since __stage2_unmap_defer_tlb_flush() is based on alternative
> +	 * patching and the TLBIs' operations behavior depend on this,
> +	 * track if there's any change in the state during the unmap sequence.
> +	 */
> +	WARN_ON(unmap_data->defer_tlb_flush_init != defer_tlb_flush);
> +	return defer_tlb_flush;
> +}
> +
> +static void stage2_unmap_put_pte(const struct kvm_pgtable_visit_ctx *ctx,
> +				struct kvm_s2_mmu *mmu,
> +				struct kvm_pgtable_mm_ops *mm_ops)
>   {
> +	struct stage2_unmap_data *unmap_data = ctx->arg;
> +
>   	/*
> -	 * Clear the existing PTE, and perform break-before-make with
> -	 * TLB maintenance if it was valid.
> +	 * Clear the existing PTE, and perform break-before-make if it was
> +	 * valid. Depending on the system support, the TLB maintenance for
> +	 * the same can be deferred until the entire unmap is completed.
>   	 */
>   	if (kvm_pte_valid(ctx->old)) {
>   		kvm_clear_pte(ctx->ptep);
> -		kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu, ctx->addr, ctx->level);
> +
> +		if (!stage2_unmap_defer_tlb_flush(unmap_data))
Why not directly check (unmap_data->defer_tlb_flush_init) here?

> +			kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu,
> +					ctx->addr, ctx->level);
Small indent hint. The ctx->addr can align with __kvm_tlb_flush_vmid_ipa.

Thanks,
Shaoqin
>   	}
>   
>   	mm_ops->put_page(ctx->ptep);
> @@ -1070,7 +1108,8 @@ int kvm_pgtable_stage2_set_owner(struct kvm_pgtable *pgt, u64 addr, u64 size,
>   static int stage2_unmap_walker(const struct kvm_pgtable_visit_ctx *ctx,
>   			       enum kvm_pgtable_walk_flags visit)
>   {
> -	struct kvm_pgtable *pgt = ctx->arg;
> +	struct stage2_unmap_data *unmap_data = ctx->arg;
> +	struct kvm_pgtable *pgt = unmap_data->pgt;
>   	struct kvm_s2_mmu *mmu = pgt->mmu;
>   	struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
>   	kvm_pte_t *childp = NULL;
> @@ -1098,7 +1137,7 @@ static int stage2_unmap_walker(const struct kvm_pgtable_visit_ctx *ctx,
>   	 * block entry and rely on the remaining portions being faulted
>   	 * back lazily.
>   	 */
> -	stage2_put_pte(ctx, mmu, mm_ops);
> +	stage2_unmap_put_pte(ctx, mmu, mm_ops);
>   
>   	if (need_flush && mm_ops->dcache_clean_inval_poc)
>   		mm_ops->dcache_clean_inval_poc(kvm_pte_follow(ctx->old, mm_ops),
> @@ -1112,13 +1151,23 @@ static int stage2_unmap_walker(const struct kvm_pgtable_visit_ctx *ctx,
>   
>   int kvm_pgtable_stage2_unmap(struct kvm_pgtable *pgt, u64 addr, u64 size)
>   {
> +	int ret;
> +	struct stage2_unmap_data unmap_data = {
> +		.pgt = pgt,
> +		.defer_tlb_flush_init = __stage2_unmap_defer_tlb_flush(pgt),
> +	};
>   	struct kvm_pgtable_walker walker = {
>   		.cb	= stage2_unmap_walker,
> -		.arg	= pgt,
> +		.arg	= &unmap_data,
>   		.flags	= KVM_PGTABLE_WALK_LEAF | KVM_PGTABLE_WALK_TABLE_POST,
>   	};
>   
> -	return kvm_pgtable_walk(pgt, addr, size, &walker);
> +	ret = kvm_pgtable_walk(pgt, addr, size, &walker);
> +	if (stage2_unmap_defer_tlb_flush(&unmap_data))
> +		/* Perform the deferred TLB invalidations */
> +		kvm_tlb_flush_vmid_range(pgt->mmu, addr, size);
> +
> +	return ret;
>   }
>   
>   struct stage2_attr_data {

-- 
Shaoqin

