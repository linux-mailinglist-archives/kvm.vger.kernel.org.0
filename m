Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81CA35B23BB
	for <lists+kvm@lfdr.de>; Thu,  8 Sep 2022 18:40:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230186AbiIHQkZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Sep 2022 12:40:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiIHQkY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Sep 2022 12:40:24 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19C7BE6205
        for <kvm@vger.kernel.org>; Thu,  8 Sep 2022 09:40:23 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id m3so7745189pjo.1
        for <kvm@vger.kernel.org>; Thu, 08 Sep 2022 09:40:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=44f96G3kCRZjV7Y8+rtld0XE0LiSAJByVTyxhZXDjtw=;
        b=fl0OF4gPksEMzbO6l5ojcJJdCc+d34Eu6l34U9JHsmWZmYqMRhxCjrXQimUdVzxZ4Z
         h+tlSUaFHV90shVtftbvG5kp6jvxSzUOEKtBj2Y5ndd7aK8uDUqK0mMDgxzuYabkB9X/
         yLPxRKLVx4lqp802+KHlONlx8+g7D2gfQV2FY9nkD/vJPTNBj3IQoZeW2yJ8c5KuVD4P
         2btMsSs/jWYhOpHZVxep5SkPu3rK/BKMxCFCG1Re+YjZWo6eWO6o4IG7Gq8pQN42LiJO
         BGDLDtAidqsf49nSAQ+Iw8owS4IsNHK1io4In3hBdCVR0VwpuFEt11DTABFzWzxxrKt4
         uuwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=44f96G3kCRZjV7Y8+rtld0XE0LiSAJByVTyxhZXDjtw=;
        b=xgqPd5w/Qv/qI3iXFZMIef0hdYfJ2nF4c2Gs2VVD6qCXMD9ukahZ1fFFJMq0KmqKHW
         SC/t15IGo11rYVMNDVlOUjGoN1vnZBq/r/dn7bzg9cUvvcsK27T/KQLDkDs06nCygToc
         1EflagyFKHwcV3gu7WXGnra9HO8B99R982zUIhShXtqE1R6SyETbbgVrUaD9o+MbNCgT
         bLz0I5TZ3Cnxfvsat443cHJiiR2uHGMNdnocEjGTT2ACtWSz+u3kBewEEmPl6EK1zm1l
         AgFHeBSodkghy5dibVc3/Dnv59ZNGsD7e0Pc8kcX4lK6u2cKy+6dX4gxcVKEjy/2aIuN
         oNKA==
X-Gm-Message-State: ACgBeo0eWm7ksF6DKYDaZYlNdtxc39r+aPHUL+rWMZ9btX7etpRmTxpu
        SzLZ9LFCWX54lfMjUJoh+m8t0Q==
X-Google-Smtp-Source: AA6agR6OtvAZQ1VlqtdckX4M37HUd6tnzFOMxCB7aH5ZyWfFq8tToKkiSh7ojqXsfhbd+jx/tPhW7w==
X-Received: by 2002:a17:90a:588c:b0:1fd:a1bc:ff71 with SMTP id j12-20020a17090a588c00b001fda1bcff71mr4945546pji.134.1662655222365;
        Thu, 08 Sep 2022 09:40:22 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id w24-20020aa79558000000b0053725e331a1sm14927604pfq.82.2022.09.08.09.40.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 09:40:21 -0700 (PDT)
Date:   Thu, 8 Sep 2022 09:40:16 -0700
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
Message-ID: <Yxoa8AQozMWuayTD@google.com>
References: <20220830194132.962932-1-oliver.upton@linux.dev>
 <20220830194132.962932-10-oliver.upton@linux.dev>
 <YxkUciuwLFvByLOu@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YxkUciuwLFvByLOu@google.com>
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

On Wed, Sep 07, 2022 at 03:00:18PM -0700, David Matlack wrote:
> On Tue, Aug 30, 2022 at 07:41:27PM +0000, Oliver Upton wrote:
> > There is no real urgency to free a stage-2 subtree that was pruned.
> > Nonetheless, KVM does the tear down in the stage-2 fault path while
> > holding the MMU lock.
> > 
> > Free removed stage-2 subtrees after an RCU grace period. To guarantee
> > all stage-2 table pages are freed before killing a VM, add an
> > rcu_barrier() to the flush path.
> > 
> > Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> > ---
> >  arch/arm64/kvm/mmu.c | 35 ++++++++++++++++++++++++++++++++++-
> >  1 file changed, 34 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index 91521f4aab97..265951c05879 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -97,6 +97,38 @@ static void *stage2_memcache_zalloc_page(void *arg)
> >  	return kvm_mmu_memory_cache_alloc(mc);
> >  }
> >  
> > +#define STAGE2_PAGE_PRIVATE_LEVEL_MASK	GENMASK_ULL(2, 0)
> > +
> > +static inline unsigned long stage2_page_private(u32 level, void *arg)
> > +{
> > +	unsigned long pvt = (unsigned long)arg;
> > +
> > +	BUILD_BUG_ON(KVM_PGTABLE_MAX_LEVELS > STAGE2_PAGE_PRIVATE_LEVEL_MASK);
> > +	WARN_ON_ONCE(pvt & STAGE2_PAGE_PRIVATE_LEVEL_MASK);
> > +
> > +	return pvt | level;
> > +}
> > +
> > +static void stage2_free_removed_table_rcu_cb(struct rcu_head *head)
> > +{
> > +	struct page *page = container_of(head, struct page, rcu_head);
> > +	unsigned long pvt = page_private(page);
> > +	void *arg = (void *)(pvt & ~STAGE2_PAGE_PRIVATE_LEVEL_MASK);
> > +	u32 level = (u32)(pvt & STAGE2_PAGE_PRIVATE_LEVEL_MASK);
> > +	void *pgtable = page_to_virt(page);
> > +
> > +	kvm_pgtable_stage2_free_removed(pgtable, level, arg);
> > +}
> > +
> > +static void stage2_free_removed_table(void *pgtable, u32 level, void *arg)
> > +{
> > +	unsigned long pvt = stage2_page_private(level, arg);
> > +	struct page *page = virt_to_page(pgtable);
> > +
> > +	set_page_private(page, (unsigned long)pvt);
> > +	call_rcu(&page->rcu_head, stage2_free_removed_table_rcu_cb);
> > +}
> > +
> >  static void *kvm_host_zalloc_pages_exact(size_t size)
> >  {
> >  	return alloc_pages_exact(size, GFP_KERNEL_ACCOUNT | __GFP_ZERO);
> > @@ -627,7 +659,7 @@ static struct kvm_pgtable_mm_ops kvm_s2_mm_ops = {
> >  	.zalloc_page		= stage2_memcache_zalloc_page,
> >  	.zalloc_pages_exact	= kvm_host_zalloc_pages_exact,
> >  	.free_pages_exact	= free_pages_exact,
> > -	.free_removed_table	= kvm_pgtable_stage2_free_removed,
> > +	.free_removed_table	= stage2_free_removed_table,
> >  	.get_page		= kvm_host_get_page,
> >  	.put_page		= kvm_host_put_page,
> >  	.page_count		= kvm_host_page_count,
> > @@ -770,6 +802,7 @@ void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
> >  	if (pgt) {
> >  		kvm_pgtable_stage2_destroy(pgt);
> >  		kfree(pgt);
> > +		rcu_barrier();
> 
> A comment here would be useful to document the behavior. e.g.
> 
>         /*
>          * Wait for all stage-2 page tables that are being freed
>          * asynchronously via RCU callback because ...
>          */
> 
> Speaking of, what's the reason for this rcu_barrier()? Is there any
> reason why KVM can't let in-flight stage-2 freeing RCU callbacks run at
> the end of the next grace period?

After thinking about this more I have 2 follow-up questions:

1. Should the RCU barrier come before kvm_pgtable_stage2_destroy() and
   kfree(pgt)? Otherwise an RCU callback running
   kvm_pgtable_stage2_free_removed() could access the pgt after it has
   been freed?

2. In general, is it safe for kvm_pgtable_stage2_free_removed() to run
   outside of the MMU lock? Yes the page tables have already been
   disconnected from the tree, but kvm_pgtable_stage2_free_removed()
   also accesses shared data structures likstruct kvm_pgtable. I *think*
   it might be safe after you fix (1.) but it would be more robust to
   avoid accessing shared data structures at all outside of the MMU lock
   and just do the page table freeing in the RCU callback.

> 
> >  	}
> >  }
> >  
> > -- 
> > 2.37.2.672.g94769d06f0-goog
> > 
