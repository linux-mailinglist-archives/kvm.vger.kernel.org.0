Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D6725B7DF1
	for <lists+kvm@lfdr.de>; Wed, 14 Sep 2022 02:49:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229701AbiINAtg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Sep 2022 20:49:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbiINAtd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Sep 2022 20:49:33 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA9D5DEF
        for <kvm@vger.kernel.org>; Tue, 13 Sep 2022 17:49:31 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id p18so13514357plr.8
        for <kvm@vger.kernel.org>; Tue, 13 Sep 2022 17:49:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=VC9mI68no/Lhw0HfZpwkORWcc1RC3UZIYHwVkfGB/r4=;
        b=hrIqf5MD/xB/9myyBeSm33TcaOokPoX7OBfouhtK+QYu3xN2uBJxyO2hwvyYtuh2W0
         RdwXYSsNmn+DsH/Gpdq5vM3R8ZfCoKhKciL2HGbxoduQKF7c8ktRoTQjLfMESLPFpZyL
         Ns0E2DVLJos2dtMmG5R41fTtTe3J/4Tlo1NyAQwzTGqI70CMfMYO11+ICelzhKCetwtW
         SkPeKYcul80lg+mpqpXs6SCD0MpG3NKQFFzJeeWkjLD0aS7zcXg0vSm1kwe5vEoNUwPa
         CPS85UG7CF4R83h+gydjSaaK82yV2BkpbSMULGBFAaCTe6LmRRsym1vdrmpcBBksyYr9
         H8nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=VC9mI68no/Lhw0HfZpwkORWcc1RC3UZIYHwVkfGB/r4=;
        b=SWI3JUMigYETA/xQiEs24dDS2n2GRhXkVkdRSyz5v52plhiZIwqYb7tCuf9z2cqk16
         uurfhBDMAWpwfT/z6lXMw2Bjz4/UKxkNVgMv1BWsJwOpFsl1NK1QqAY9Hg1Ti288Sf5M
         kdExnDYPF8F23QCWYMG+GW9JvcEHK9hZomVTRFVcRIaVrAM+InVBbNCEsuBRvWEv8aAb
         FX4IcYbtyyuXBiAACx8rapAoa6b9DB/w/6/Wgj/LdRaLDS05ZO4p3gxomGwCum8wqmZT
         fDoZs3YKXXpW5ocZD/1wl5HD98KQpyhEVvp6AJ5cD76Vi3VBEKyYN9cvkCkCAgcPdLrR
         TA2A==
X-Gm-Message-State: ACrzQf2zoR/HBPnST6VXb+xaH5VQ+qe8os/vqJDC/IDDCGyDCX/jd0eM
        sftOPVjQs6hEhcM3eR7QG3GTQg==
X-Google-Smtp-Source: AMsMyM526FQxM1WokLTXGOLY1vbfrlIhdoLZtMq7zQSlveMaKcR+WWo9mX4QO1UTnf2rxrP+iQLIoA==
X-Received: by 2002:a17:90a:7006:b0:200:aabc:891 with SMTP id f6-20020a17090a700600b00200aabc0891mr1948603pjk.67.1663116571104;
        Tue, 13 Sep 2022 17:49:31 -0700 (PDT)
Received: from google.com (220.181.82.34.bc.googleusercontent.com. [34.82.181.220])
        by smtp.gmail.com with ESMTPSA id y186-20020a6232c3000000b00535e46171c1sm8503863pfy.117.2022.09.13.17.49.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Sep 2022 17:49:30 -0700 (PDT)
Date:   Tue, 13 Sep 2022 17:49:27 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Quentin Perret <qperret@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Gavin Shan <gshan@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/14] KVM: arm64: Free removed stage-2 tables in RCU
 callback
Message-ID: <YyElF+MMXSumzszf@google.com>
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

Hi Oliver,

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

If the pgt pointer (arg) is not aligned for some reason, I think it
might be better to BUG_ON(). Alternatively, why not trying to pass a new
struct (with level and arg) that's freed by the rcu callback.

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
>  	}
>  }
>  
> -- 
> 2.37.2.672.g94769d06f0-goog
> 
