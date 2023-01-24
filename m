Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 948C467A6D4
	for <lists+kvm@lfdr.de>; Wed, 25 Jan 2023 00:25:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232084AbjAXXZy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Jan 2023 18:25:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbjAXXZx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Jan 2023 18:25:53 -0500
Received: from out-14.mta0.migadu.com (out-14.mta0.migadu.com [IPv6:2001:41d0:1004:224b::e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEFCF1F5E6
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 15:25:51 -0800 (PST)
Date:   Tue, 24 Jan 2023 15:25:42 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1674602749;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=c74+f/E81sUW5vwqR4R5i42L30Py8ifaBoFNS256FLc=;
        b=DY6oY/iylKNyk7k7siN12oc3f6brxvNO05K/H869hJ8xZAiaE7YqpP72oXE86llGUFEe1O
        1mZi+lfR4ZQbbSw3ILPGX0KEGFAA+qZm8QG7CFU4Ng+uzkdIhGom4q5q7r8SMljdvrLkXo
        eMFUkv6hAz+FW8i4zMpGIlIcoJYa2XU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Raghavendra Rao Ananta <rananta@google.com>
Cc:     Oliver Upton <oupton@google.com>, Marc Zyngier <maz@kernel.org>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Jing Zhang <jingzhangos@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC PATCH 5/6] KVM: arm64: Optimize the stage2 map path with
 TLBI range instructions
Message-ID: <Y9Bo9qwJhs3KK6jR@thinky-boi>
References: <20230109215347.3119271-1-rananta@google.com>
 <20230109215347.3119271-6-rananta@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230109215347.3119271-6-rananta@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Raghavendra,

My comment from the previous change also applies here:

  KVM: arm64: Use range-based TLBIs when collapsing hugepages

On Mon, Jan 09, 2023 at 09:53:46PM +0000, Raghavendra Rao Ananta wrote:
> Currently, when the map path of stage2 page-table coalesces a
> bunch of pages into a hugepage, KVM invalidates the entire
> VM's TLB entries. This would cause a perforamance penality for
> the guest whose pages have already been coalesced earlier as they
> would have to refill their TLB entries unnecessarily again.

It is also problematic that we do this on every single fault where we
collapse a hugepage.

> Hence, if the system supports it, use __kvm_tlb_flush_range_vmid_ipa()
> to flush only the range of pages that have been combined into
> a hugepage, while leaving other TLB entries alone.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  arch/arm64/kvm/hyp/pgtable.c | 29 +++++++++++++++++++++++++----
>  1 file changed, 25 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index b11cf2c618a6c..099032bb01bce 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -686,6 +686,22 @@ static bool stage2_try_set_pte(const struct kvm_pgtable_visit_ctx *ctx, kvm_pte_
>  	return cmpxchg(ctx->ptep, ctx->old, new) == ctx->old;
>  }
>  
> +static void kvm_table_pte_flush(struct kvm_s2_mmu *mmu, u64 addr, u32 level, u32 tlb_level)

Could you call this something like kvm_pgtable_flush_range() and take an
address range as an argument? TLBIRANGE can be used outside the context
of a table (i.e. a subset of PTEs).

> +{
> +	if (system_supports_tlb_range()) {
> +		u64 end = addr + kvm_granule_size(level);
> +
> +		kvm_call_hyp(__kvm_tlb_flush_range_vmid_ipa, mmu, addr, end, tlb_level);
> +	} else {
> +		/*
> +		 * Invalidate the whole stage-2, as we may have numerous leaf
> +		 * entries below us which would otherwise need invalidating
> +		 * individually.
> +		 */
> +		kvm_call_hyp(__kvm_tlb_flush_vmid, mmu);
> +	}
> +}
> +
>  /**
>   * stage2_try_break_pte() - Invalidates a pte according to the
>   *			    'break-before-make' requirements of the
> @@ -693,6 +709,7 @@ static bool stage2_try_set_pte(const struct kvm_pgtable_visit_ctx *ctx, kvm_pte_
>   *
>   * @ctx: context of the visited pte.
>   * @mmu: stage-2 mmu
> + * @tlb_level: The level at which the leaf pages are expected (for FEAT_TTL hint)

Do we need the caller to provide the TTL hint? We already have
ctx->level, and stage2_try_break_pte() also knows what the removed PTE
contained (i.e. a table or a block/page).

>   * Returns: true if the pte was successfully broken.
>   *
> @@ -701,7 +718,7 @@ static bool stage2_try_set_pte(const struct kvm_pgtable_visit_ctx *ctx, kvm_pte_
>   * on the containing table page.
>   */
>  static bool stage2_try_break_pte(const struct kvm_pgtable_visit_ctx *ctx,
> -				 struct kvm_s2_mmu *mmu)
> +				 struct kvm_s2_mmu *mmu, u32 tlb_level)
>  {
>  	struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
>  
> @@ -722,7 +739,7 @@ static bool stage2_try_break_pte(const struct kvm_pgtable_visit_ctx *ctx,
>  	 * value (if any).
>  	 */
>  	if (kvm_pte_table(ctx->old, ctx->level))
> -		kvm_call_hyp(__kvm_tlb_flush_vmid, mmu);
> +		kvm_table_pte_flush(mmu, ctx->addr, ctx->level, tlb_level);

I don't think we should provide a TTL hint for a removed table. It is
entirely possible for the unlinked table to contain a mix of blocks and
pages, meaning there isn't a uniform table level for the whole range.

>  	else if (kvm_pte_valid(ctx->old))
>  		kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu, ctx->addr, ctx->level);
>  
> @@ -804,7 +821,7 @@ static int stage2_map_walker_try_leaf(const struct kvm_pgtable_visit_ctx *ctx,
>  	if (!stage2_pte_needs_update(ctx->old, new))
>  		return -EAGAIN;
>  
> -	if (!stage2_try_break_pte(ctx, data->mmu))
> +	if (!stage2_try_break_pte(ctx, data->mmu, ctx->level))
>  		return -EAGAIN;
>  
>  	/* Perform CMOs before installation of the guest stage-2 PTE */
> @@ -861,7 +878,11 @@ static int stage2_map_walk_leaf(const struct kvm_pgtable_visit_ctx *ctx,
>  	if (!childp)
>  		return -ENOMEM;
>  
> -	if (!stage2_try_break_pte(ctx, data->mmu)) {
> +	/*
> +	 * As the table will be replaced with a block, one level down would
> +	 * be the current page entries held by the table.
> +	 */

This isn't necessarily true. Ignoring mixed block/pages for a moment,
Collapsing a PUD entry into a block after dirty logging (where we mapped
at PTE level) would imply a TTL of ctx->level + 2.

But again, I think it is best to provide no hint in this case.

--
Thanks,
Oliver
