Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A51965B0F2D
	for <lists+kvm@lfdr.de>; Wed,  7 Sep 2022 23:32:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230173AbiIGVcj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Sep 2022 17:32:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbiIGVch (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Sep 2022 17:32:37 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A69D4B774D
        for <kvm@vger.kernel.org>; Wed,  7 Sep 2022 14:32:36 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id z187so15874190pfb.12
        for <kvm@vger.kernel.org>; Wed, 07 Sep 2022 14:32:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=7na4QT6yvyqzijLFE24Wbx46oe0wPXj14j8P2u6pP1w=;
        b=UzP2VbnLuTjsou56LGJV0IVy5dUZ5ia4mREFcUwJvUKzdU8EDsewlGPEqnX1NiOp41
         0AEOCI8E6a9AH/bp0M9AkwM4K6pi18gbxaa9FQHA025LecN9vHkWk0yr6itCVz1d1Sip
         1hCbbLMb+pp9LQqwQoKnGLrTRuEJZNa1YXODMatGENOmG6TlEBYYj8PYxGXt6CEutDx+
         IV+B0IBRq8uMk2z0ZxrVuQ+GHrRdb+ZEWwt0rLSohMESgquu3gLQECLXi22E0+Z7e7gm
         nwGEqq/ifhlOgAjjcm4c9omWSxvG9GV/r3l3r275GllZjalkTy0cWgw6P9peAzfM5qZx
         LHtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=7na4QT6yvyqzijLFE24Wbx46oe0wPXj14j8P2u6pP1w=;
        b=BsonAavN0xObq5Rne135yc0vQ2wChEt1NUlKEtUYBRcGbyYveydsEihosv3uXrUouw
         7YuUQif0AbDzvi/5xriI19iCjscy1fOY6vWXBmdYslhUKpxZJ+dIWfIz+7d/CQkTFWuI
         DFwHJsUYLMb8E3Qe+vPWWhieU20iWA6LWGZ8/DlbqB5wB9IhliPKbUCtSEGcuME1qzhe
         VRqCPD0wSNYXRzYwB6NmKqQTCuKYPDDNbGxrH/RoTiXnefkAIntkyR3ypBAXFPTPJSlA
         E4aGsoh1EC+bMtlnzrXoimCZvCFkPC8+tYQM14OMra2S0fibyr534YUCLvoIiU/tM+PJ
         05zw==
X-Gm-Message-State: ACgBeo3lFBJodINapiZ2LqfZXxjaqaC6kD8pqz04Jd9ton3YNPlO1k4u
        v2rUI+E5iCef02/MAiGd0Urn5A==
X-Google-Smtp-Source: AA6agR7Q4eHfCORqq/GdxHWoHptDop8lLgJyVx3iDY9vFGg98YhF6AsRZ4mhtYSuJiPSkfoyXtLNow==
X-Received: by 2002:a63:6c01:0:b0:429:ea6e:486d with SMTP id h1-20020a636c01000000b00429ea6e486dmr4993947pgc.247.1662586355791;
        Wed, 07 Sep 2022 14:32:35 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id j3-20020a170902da8300b001752216ca51sm13034032plx.39.2022.09.07.14.32.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Sep 2022 14:32:34 -0700 (PDT)
Date:   Wed, 7 Sep 2022 14:32:29 -0700
From:   David Matlack <dmatlack@google.com>
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Quentin Perret <qperret@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Ben Gardon <bgardon@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Gavin Shan <gshan@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/14] KVM: arm64: Return next table from map callbacks
Message-ID: <YxkN7XmHiU3ddknR@google.com>
References: <20220830194132.962932-1-oliver.upton@linux.dev>
 <20220830194132.962932-7-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220830194132.962932-7-oliver.upton@linux.dev>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 30, 2022 at 07:41:24PM +0000, Oliver Upton wrote:
> The map walkers install new page tables during their traversal. Return
> the newly-installed table PTE from the map callbacks to point the walker
> at the new table w/o rereading the ptep.
> 
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>  arch/arm64/kvm/hyp/pgtable.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 331f6e3b2c20..f911509e6512 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -202,13 +202,12 @@ static inline int __kvm_pgtable_visit(struct kvm_pgtable_walk_data *data,
>  	if (!table && (flags & KVM_PGTABLE_WALK_LEAF)) {
>  		ret = kvm_pgtable_visitor_cb(data, addr, level, ptep, &pte,
>  					     KVM_PGTABLE_WALK_LEAF);
> -		pte = *ptep;
> -		table = kvm_pte_table(pte, level);
>  	}
>  
>  	if (ret)
>  		goto out;

Rather than passing a pointer to the local variable pte and requiring
all downstream code to update it (and deal with dereferencing to read
the old pte), wouldn't it be simpler to just re-read the PTE here? e.g.

        /*
         * Explicitly re-read the PTE since it may have been modified
         * during the TABLE_PRE or LEAF callback.
         */
        pte = kvm_pte_read(ptep);

This should also result in better behavior once parallelization is
introduced, because it will prevent the walker from traversing down and
doing a bunch of work on page tables that are in the process of being
freed by some other thread.

>  
> +	table = kvm_pte_table(pte, level);
>  	if (!table) {

nit: Technically there's no reason to set @table again. e.g. This could
just be:

        if (!kvm_pte_table(pte, level)) {

>  		data->addr = ALIGN_DOWN(data->addr, kvm_granule_size(level));
>  		data->addr += kvm_granule_size(level);
> @@ -427,6 +426,7 @@ static int hyp_map_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep, kvm_pte
>  	new = kvm_init_table_pte(childp, mm_ops);
>  	mm_ops->get_page(ptep);
>  	smp_store_release(ptep, new);
> +	*old = new;
>  
>  	return 0;
>  }
> @@ -768,7 +768,7 @@ static int stage2_map_walker_try_leaf(u64 addr, u64 end, u32 level,
>  }
>  
>  static int stage2_map_walk_leaf(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
> -				struct stage2_map_data *data);
> +				kvm_pte_t *old, struct stage2_map_data *data);
>  
>  static int stage2_map_walk_table_pre(u64 addr, u64 end, u32 level,
>  				     kvm_pte_t *ptep, kvm_pte_t *old,
> @@ -791,7 +791,7 @@ static int stage2_map_walk_table_pre(u64 addr, u64 end, u32 level,
>  	 */
>  	kvm_call_hyp(__kvm_tlb_flush_vmid, data->mmu);
>  
> -	ret = stage2_map_walk_leaf(addr, end, level, ptep, data);
> +	ret = stage2_map_walk_leaf(addr, end, level, ptep, old, data);
>  
>  	mm_ops->put_page(ptep);
>  	mm_ops->free_removed_table(childp, level + 1, pgt);
> @@ -832,6 +832,7 @@ static int stage2_map_walk_leaf(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
>  	new = kvm_init_table_pte(childp, mm_ops);
>  	mm_ops->get_page(ptep);
>  	smp_store_release(ptep, new);
> +	*old = new;
>  
>  	return 0;
>  }
> -- 
> 2.37.2.672.g94769d06f0-goog
> 
