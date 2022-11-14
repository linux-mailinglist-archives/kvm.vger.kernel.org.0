Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F9A7628AEA
	for <lists+kvm@lfdr.de>; Mon, 14 Nov 2022 21:59:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236825AbiKNU70 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Nov 2022 15:59:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236156AbiKNU7Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Nov 2022 15:59:25 -0500
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5093AFAE7
        for <kvm@vger.kernel.org>; Mon, 14 Nov 2022 12:59:24 -0800 (PST)
Date:   Mon, 14 Nov 2022 20:59:13 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1668459563;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hGeByEF7fiPw7L8RkZy6v3SdTEQDaiCEVE4F9gxaZWU=;
        b=QZGj0VnKfsWs4mmYs5F8K2KzfTrFTlQ11QyOmE6mpMfbFQzlOQCUkNNYmyJ+tD7/0LR3Nk
        VwtMk3HwDmV2fJNzQWGHVnZ6ULtAPfFfWVkHX60MD8aEUxv/aJMhqGhgWY+u2IADU8ax1k
        ZbR1yeBw8FU3uOrTPeENLsM5XOYKJNQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     pbonzini@redhat.com, maz@kernel.org, dmatlack@google.com,
        qperret@google.com, catalin.marinas@arm.com,
        andrew.jones@linux.dev, seanjc@google.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, gshan@redhat.com, reijiw@google.com,
        rananta@google.com, bgardon@google.com, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
        ricarkol@gmail.com
Subject: Re: [RFC PATCH 01/12] KVM: arm64: Relax WARN check in
 stage2_make_pte()
Message-ID: <Y3KsIUpKISgYRAV9@google.com>
References: <20221112081714.2169495-1-ricarkol@google.com>
 <20221112081714.2169495-2-ricarkol@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221112081714.2169495-2-ricarkol@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Ricardo,

On Sat, Nov 12, 2022 at 08:17:03AM +0000, Ricardo Koller wrote:
> stage2_make_pte() throws a warning when used in a non-shared walk, as PTEs
> are not "locked" when walking non-shared. Add a check so it can be used
> non-shared.
> 
> Signed-off-by: Ricardo Koller <ricarkol@google.com>

I would very much prefer to leave this WARN as-is. Correct me if I am
wrong, but I do not believe this warning is firing with the existing
code.

While the locking portion doesn't make a whole lot of sense for a
non-shared walk, it is also a magic value that indicates we've already
done the break side of break-before-make. If the warning fires then that
would suggest our break-before-make implementation isn't working as
expected.

--
Thanks,
Oliver

> ---
>  arch/arm64/kvm/hyp/pgtable.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index c12462439e70..b16107bf917c 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -733,7 +733,8 @@ static void stage2_make_pte(const struct kvm_pgtable_visit_ctx *ctx, kvm_pte_t n
>  {
>  	struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
>  
> -	WARN_ON(!stage2_pte_is_locked(*ctx->ptep));
> +	if (kvm_pgtable_walk_shared(ctx))
> +		WARN_ON(!stage2_pte_is_locked(*ctx->ptep));
>  
>  	if (stage2_pte_is_counted(new))
>  		mm_ops->get_page(ctx->ptep);
> -- 
> 2.38.1.431.g37b22c650d-goog
> 
> 
