Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D83E35B0FA1
	for <lists+kvm@lfdr.de>; Thu,  8 Sep 2022 00:00:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbiIGWA1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Sep 2022 18:00:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbiIGWA0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Sep 2022 18:00:26 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D941657A
        for <kvm@vger.kernel.org>; Wed,  7 Sep 2022 15:00:25 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id v4so14830523pgi.10
        for <kvm@vger.kernel.org>; Wed, 07 Sep 2022 15:00:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=Z6i7/OEeMp+vclfvU0ocYeg3hscpfsRzRk3osMten/8=;
        b=e3Fe+rheW8Na/BXBO0bEG/1zt5AvIyqOPccGgeldHQDysW4dhlQDvScdWW2jF/ykJ0
         1KZwGAcihDgrTllUZHJJCNthA+tnI5/MKxfV98sxO2gZdnNqtwz4ehAALW8HWWs42K4u
         ocGtMwQOJbi17zrV7TwAfsFGcApOG5pyrSRoymiKtunKPdiNxC47IKTkRNH5I0iklGS7
         4o7kfFBEXIsl9Q3af05OVupBoJddnUB5PVwkMSqoL+yMs33XpMb06Gf/XqiqKdeZ+ZhV
         Hi7J8tFb62JxGs/zwwIUjqJqcKSQ9HcUYGQgsRwMCfp8L3VnL/MyK/wxFVZnjlAnT6dN
         a/Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=Z6i7/OEeMp+vclfvU0ocYeg3hscpfsRzRk3osMten/8=;
        b=WXnNoRC8dxiI9309RVhGF3MDB0l9jAv5kHl8sSeJ3HxH+n8nXZkwiocC2hvby1Mzw9
         8KW2pRTIO45yx18L/BahLwwmgk6TdL4FEyYhP09Ro5i4efwb3x8YP+A7MyqXL7USKQHl
         YYL2MnKFVTFeyTANU7ZGNlHFGWbxSBhYEih/C5GX20sjs8eygnyZs68WekerNqOADFb5
         HIVDzJXLqEyRPTJcSeGVv3VgtGP9b/KTDxx7/VbOO7QYjAnqq0jDJ3ro4ZFaoTQ/zfh8
         mGswYXtpR18yLl6jMvLlUkb942gJZg3G5k4Xrumwdc6l/Adi+rU+IvV1jN0e5Wzmmijd
         DyTw==
X-Gm-Message-State: ACgBeo0mMLB1BIFOXA294ENzVnG4JXRG/dFiUFn6+LGrcNn2EvHVyk5w
        YD5lhS9QZ6f3a+ivQ76MLsYznw==
X-Google-Smtp-Source: AA6agR42gCnxTLUemS9/D7J6YQAzvwNbNyEIYR546Fz93K8ats2Z1wyfCNCKWhEadwoFVmBAFIejcg==
X-Received: by 2002:a63:84c1:0:b0:434:fd55:e213 with SMTP id k184-20020a6384c1000000b00434fd55e213mr3190251pgd.10.1662588024651;
        Wed, 07 Sep 2022 15:00:24 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id i15-20020aa796ef000000b0053e62b6fd22sm2762187pfq.126.2022.09.07.15.00.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Sep 2022 15:00:23 -0700 (PDT)
Date:   Wed, 7 Sep 2022 15:00:18 -0700
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
Subject: Re: [PATCH 09/14] KVM: arm64: Free removed stage-2 tables in RCU
 callback
Message-ID: <YxkUciuwLFvByLOu@google.com>
References: <20220830194132.962932-1-oliver.upton@linux.dev>
 <20220830194132.962932-10-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220830194132.962932-10-oliver.upton@linux.dev>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 30, 2022 at 07:41:27PM +0000, Oliver Upton wrote:
> There is no real urgency to free a stage-2 subtree that was pruned.
> Nonetheless, KVM does the tear down in the stage-2 fault path while
> holding the MMU lock.
> 
> Free removed stage-2 subtrees after an RCU grace period. To guarantee
> all stage-2 table pages are freed before killing a VM, add an
> rcu_barrier() to the flush path.
> 
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>  arch/arm64/kvm/mmu.c | 35 ++++++++++++++++++++++++++++++++++-
>  1 file changed, 34 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 91521f4aab97..265951c05879 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -97,6 +97,38 @@ static void *stage2_memcache_zalloc_page(void *arg)
>  	return kvm_mmu_memory_cache_alloc(mc);
>  }
>  
> +#define STAGE2_PAGE_PRIVATE_LEVEL_MASK	GENMASK_ULL(2, 0)
> +
> +static inline unsigned long stage2_page_private(u32 level, void *arg)
> +{
> +	unsigned long pvt = (unsigned long)arg;
> +
> +	BUILD_BUG_ON(KVM_PGTABLE_MAX_LEVELS > STAGE2_PAGE_PRIVATE_LEVEL_MASK);
> +	WARN_ON_ONCE(pvt & STAGE2_PAGE_PRIVATE_LEVEL_MASK);
> +
> +	return pvt | level;
> +}
> +
> +static void stage2_free_removed_table_rcu_cb(struct rcu_head *head)
> +{
> +	struct page *page = container_of(head, struct page, rcu_head);
> +	unsigned long pvt = page_private(page);
> +	void *arg = (void *)(pvt & ~STAGE2_PAGE_PRIVATE_LEVEL_MASK);
> +	u32 level = (u32)(pvt & STAGE2_PAGE_PRIVATE_LEVEL_MASK);
> +	void *pgtable = page_to_virt(page);
> +
> +	kvm_pgtable_stage2_free_removed(pgtable, level, arg);
> +}
> +
> +static void stage2_free_removed_table(void *pgtable, u32 level, void *arg)
> +{
> +	unsigned long pvt = stage2_page_private(level, arg);
> +	struct page *page = virt_to_page(pgtable);
> +
> +	set_page_private(page, (unsigned long)pvt);
> +	call_rcu(&page->rcu_head, stage2_free_removed_table_rcu_cb);
> +}
> +
>  static void *kvm_host_zalloc_pages_exact(size_t size)
>  {
>  	return alloc_pages_exact(size, GFP_KERNEL_ACCOUNT | __GFP_ZERO);
> @@ -627,7 +659,7 @@ static struct kvm_pgtable_mm_ops kvm_s2_mm_ops = {
>  	.zalloc_page		= stage2_memcache_zalloc_page,
>  	.zalloc_pages_exact	= kvm_host_zalloc_pages_exact,
>  	.free_pages_exact	= free_pages_exact,
> -	.free_removed_table	= kvm_pgtable_stage2_free_removed,
> +	.free_removed_table	= stage2_free_removed_table,
>  	.get_page		= kvm_host_get_page,
>  	.put_page		= kvm_host_put_page,
>  	.page_count		= kvm_host_page_count,
> @@ -770,6 +802,7 @@ void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
>  	if (pgt) {
>  		kvm_pgtable_stage2_destroy(pgt);
>  		kfree(pgt);
> +		rcu_barrier();

A comment here would be useful to document the behavior. e.g.

        /*
         * Wait for all stage-2 page tables that are being freed
         * asynchronously via RCU callback because ...
         */

Speaking of, what's the reason for this rcu_barrier()? Is there any
reason why KVM can't let in-flight stage-2 freeing RCU callbacks run at
the end of the next grace period?

>  	}
>  }
>  
> -- 
> 2.37.2.672.g94769d06f0-goog
> 
