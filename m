Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BE6A6E1177
	for <lists+kvm@lfdr.de>; Thu, 13 Apr 2023 17:53:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230268AbjDMPxM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Apr 2023 11:53:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbjDMPxL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Apr 2023 11:53:11 -0400
Received: from out-27.mta1.migadu.com (out-27.mta1.migadu.com [95.215.58.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B5A2558B
        for <kvm@vger.kernel.org>; Thu, 13 Apr 2023 08:53:09 -0700 (PDT)
Date:   Thu, 13 Apr 2023 15:53:04 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1681401188;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DDhBJiuoLWfvR3buxL71Lhhnlb72RGsxq/NWY4TUF+U=;
        b=cokkdAAqL0Xwxvs+5WyToebqEUM68iu5hSg1tsHrLWnRk79gNHwX5Ejea5OnxB/g4lLfeN
        CVESEZsA39ZeQkEOgZP6btSXjPwQhajL29XOZdaU6KAr2+9Zl4XEEgciWldwjMANFb4fOW
        h22i6UfavfGiTO6ucMQnjMUpluktsFU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Will Deacon <will@kernel.org>,
        Ricardo Koller <ricarkol@google.com>
Subject: Re: [PATCH v3 2/5] KVM: arm64: nvhe: Synchronise with page table
 walker on TLBI
Message-ID: <ZDglYGkLVtkBd78e@linux.dev>
References: <20230413081441.165134-1-maz@kernel.org>
 <20230413081441.165134-3-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230413081441.165134-3-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 13, 2023 at 09:14:38AM +0100, Marc Zyngier wrote:
> A TLBI from EL2 impacting EL1 involves messing with the EL1&0
> translation regime, and the page table walker may still be
> performing speculative walks.
> 
> Piggyback on the existing DSBs to always have a DSB ISH that
> will synchronise all load/store operations that the PTW may
> still have.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

> ---
>  arch/arm64/kvm/hyp/nvhe/tlb.c | 38 ++++++++++++++++++++++++++---------
>  1 file changed, 29 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/tlb.c b/arch/arm64/kvm/hyp/nvhe/tlb.c
> index d296d617f589..1da2fc35f94e 100644
> --- a/arch/arm64/kvm/hyp/nvhe/tlb.c
> +++ b/arch/arm64/kvm/hyp/nvhe/tlb.c
> @@ -15,8 +15,31 @@ struct tlb_inv_context {
>  };
>  
>  static void __tlb_switch_to_guest(struct kvm_s2_mmu *mmu,
> -				  struct tlb_inv_context *cxt)
> +				  struct tlb_inv_context *cxt,
> +				  bool nsh)
>  {
> +	/*
> +	 * We have two requirements:
> +	 *
> +	 * - ensure that the page table updates are visible to all
> +         *   CPUs, for which a dsb(DOMAIN-st) is what we need, DOMAIN
> +         *   being either ish or nsh, depending on the invalidation
> +         *   type.
> +	 *
> +	 * - complete any speculative page table walk started before
> +         *   we trapped to EL2 so that we can mess with the MM
> +         *   registers out of context, for which dsb(nsh) is enough

Looks like a few of these lines are indented with spaces, not tabs. Mind
fixing this when you apply the patches?

-- 
Thanks,
Oliver
