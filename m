Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C09417785D4
	for <lists+kvm@lfdr.de>; Fri, 11 Aug 2023 05:14:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231377AbjHKDOr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Aug 2023 23:14:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbjHKDOq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Aug 2023 23:14:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D2722D68
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 20:14:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691723641;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+8Fzopu9BiGSPjrEUNgR9DMg7UpRaexYmg1fQM6xS1Q=;
        b=IMq/M1/A2+x2XnCbXbxP0azfpoH3yxEdVikgenKNgO1rb70HGcOQlBGIIdvuSsO1pX52Dd
        OlVD8App50eJkeHNE57AO+t79wzErl+L79kQpVZq4QUi+Tsy8P/TYrL1v2/NgDQaomX9v3
        FjNGkcesD9QHMMFBCqiBx+VVqrR/N04=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-513-V_pW_QEvPgCTBLIllV5JMw-1; Thu, 10 Aug 2023 23:13:55 -0400
X-MC-Unique: V_pW_QEvPgCTBLIllV5JMw-1
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-6871900d991so390963b3a.1
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 20:13:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691723635; x=1692328435;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+8Fzopu9BiGSPjrEUNgR9DMg7UpRaexYmg1fQM6xS1Q=;
        b=GhPPIzNLTmFGTceegKxgwZWBcCBeW/Xia/rQt8EJmvjJ4iPqBIWbYgpa+RSlgErqlW
         f2P/CCvF5moe/E5i1FUhysamAaOeNeq70cZNVKGVrV1NSPKducddgKOFOBK27WDAHL/c
         9XK7gJgxEzt7waObcgOKKB5K9Re1UX5YBgdYQyNaFm89RIt035DLOyjOlSEvZ+PlE+ez
         FT0xtZTjGKvpsLzR9CN8gQsRUDdhmx3x1qq5Ur8+ZGPPgb2VVAcVqMECOzhVq5vcW0KK
         ZmSjGj76GWewehZhlp6YUYkJ0EP0ZdWEIsXmQavsRJb8JAteoDqGL4IX0fdiRWGtAu5p
         qM/g==
X-Gm-Message-State: AOJu0YyF6VdIq4cokoSkwGeOxwnCh8Vizb2hhgUX0/F232SMM6E/OShf
        OVOFGFbgb7u54ByaF1T8Q8aH8pFyj+m2JGSXfsW2n9gXPh8qxsF7eXU25vtR+vjKT7sZTB6jxlS
        WEsd5sw8uc0IG
X-Received: by 2002:a05:6a00:4789:b0:687:874c:7ce0 with SMTP id dh9-20020a056a00478900b00687874c7ce0mr669604pfb.1.1691723634860;
        Thu, 10 Aug 2023 20:13:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE3d1VhIHydgxUNSBHJCWT9khJqug4xGZp+7IM8qZhfIPYmAixEOhR0Nz01guBm87TUHF3WYw==
X-Received: by 2002:a05:6a00:4789:b0:687:874c:7ce0 with SMTP id dh9-20020a056a00478900b00687874c7ce0mr669587pfb.1.1691723634514;
        Thu, 10 Aug 2023 20:13:54 -0700 (PDT)
Received: from [10.72.112.92] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id x8-20020aa79188000000b0064d57ecaa1dsm2227869pfa.28.2023.08.10.20.13.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Aug 2023 20:13:54 -0700 (PDT)
Message-ID: <5ca5e4ed-82f0-369b-db61-7fcd1c148f1c@redhat.com>
Date:   Fri, 11 Aug 2023 11:13:46 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v8 14/14] KVM: arm64: Use TLBI range-based intructions for
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
        Fuad Tabba <tabba@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <20230808231330.3855936-1-rananta@google.com>
 <20230808231330.3855936-15-rananta@google.com>
From:   Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230808231330.3855936-15-rananta@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 8/9/23 07:13, Raghavendra Rao Ananta wrote:
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
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> ---
>   arch/arm64/kvm/hyp/pgtable.c | 40 +++++++++++++++++++++++++++++-------
>   1 file changed, 33 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 5ef098af17362..eaaae76481fa9 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -831,16 +831,36 @@ static void stage2_make_pte(const struct kvm_pgtable_visit_ctx *ctx, kvm_pte_t n
>   	smp_store_release(ctx->ptep, new);
>   }
>   
> -static void stage2_put_pte(const struct kvm_pgtable_visit_ctx *ctx, struct kvm_s2_mmu *mmu,
> -			   struct kvm_pgtable_mm_ops *mm_ops)
> +static bool stage2_unmap_defer_tlb_flush(struct kvm_pgtable *pgt)
>   {
>   	/*
> -	 * Clear the existing PTE, and perform break-before-make with
> -	 * TLB maintenance if it was valid.
> +	 * If FEAT_TLBIRANGE is implemented, defer the individual
> +	 * TLB invalidations until the entire walk is finished, and
> +	 * then use the range-based TLBI instructions to do the
> +	 * invalidations. Condition deferred TLB invalidation on the
> +	 * system supporting FWB as the optimization is entirely
> +	 * pointless when the unmap walker needs to perform CMOs.
> +	 */
> +	return system_supports_tlb_range() && stage2_has_fwb(pgt);
> +}
> +
> +static void stage2_unmap_put_pte(const struct kvm_pgtable_visit_ctx *ctx,
> +				struct kvm_s2_mmu *mmu,
> +				struct kvm_pgtable_mm_ops *mm_ops)
> +{
> +	struct kvm_pgtable *pgt = ctx->arg;
> +
> +	/*
> +	 * Clear the existing PTE, and perform break-before-make if it was
> +	 * valid. Depending on the system support, defer the TLB maintenance
> +	 * for the same until the entire unmap walk is completed.
>   	 */
>   	if (kvm_pte_valid(ctx->old)) {
>   		kvm_clear_pte(ctx->ptep);
> -		kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu, ctx->addr, ctx->level);
> +
> +		if (!stage2_unmap_defer_tlb_flush(pgt))
> +			kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu,
> +					ctx->addr, ctx->level);
>   	}
>   
>   	mm_ops->put_page(ctx->ptep);
> @@ -1098,7 +1118,7 @@ static int stage2_unmap_walker(const struct kvm_pgtable_visit_ctx *ctx,
>   	 * block entry and rely on the remaining portions being faulted
>   	 * back lazily.
>   	 */
> -	stage2_put_pte(ctx, mmu, mm_ops);
> +	stage2_unmap_put_pte(ctx, mmu, mm_ops);
>   
>   	if (need_flush && mm_ops->dcache_clean_inval_poc)
>   		mm_ops->dcache_clean_inval_poc(kvm_pte_follow(ctx->old, mm_ops),
> @@ -1112,13 +1132,19 @@ static int stage2_unmap_walker(const struct kvm_pgtable_visit_ctx *ctx,
>   
>   int kvm_pgtable_stage2_unmap(struct kvm_pgtable *pgt, u64 addr, u64 size)
>   {
> +	int ret;
>   	struct kvm_pgtable_walker walker = {
>   		.cb	= stage2_unmap_walker,
>   		.arg	= pgt,
>   		.flags	= KVM_PGTABLE_WALK_LEAF | KVM_PGTABLE_WALK_TABLE_POST,
>   	};
>   
> -	return kvm_pgtable_walk(pgt, addr, size, &walker);
> +	ret = kvm_pgtable_walk(pgt, addr, size, &walker);
> +	if (stage2_unmap_defer_tlb_flush(pgt))
> +		/* Perform the deferred TLB invalidations */
> +		kvm_tlb_flush_vmid_range(pgt->mmu, addr, size);
> +
> +	return ret;
>   }
>   
>   struct stage2_attr_data {

-- 
Shaoqin

