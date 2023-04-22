Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 428936EBB1A
	for <lists+kvm@lfdr.de>; Sat, 22 Apr 2023 22:09:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbjDVUJe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 22 Apr 2023 16:09:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbjDVUJc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 22 Apr 2023 16:09:32 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B61A199A
        for <kvm@vger.kernel.org>; Sat, 22 Apr 2023 13:09:31 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id d9443c01a7336-1a6e5be6224so560445ad.1
        for <kvm@vger.kernel.org>; Sat, 22 Apr 2023 13:09:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682194171; x=1684786171;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=w8jFIlGhqnylD+Ou7GErzwOPZferzkUMYBr2W0WKmRM=;
        b=XjaJS6+2PDAKX+Bz+ZnugmYdvfLIeRAtichteII1QTfoeveCz5S4kuIoFX011m1ZUR
         NBW3FM5JTQ9ILo8HuTcjgkp5+4R1iEgRexgskzajKCRduqzNX0bI9VL3w3tgj1nKj/hc
         DyrJYvOA9arGHDUjrWJwKW+qceERnbrEPV3vh0UJL/149y/mZBIIn8+uqibUtH9bzVVh
         o2MA+gRQ/GkC0sXvToSXMCPWr4wZvMVslYw7k69UGxG6Oo7GHNK57yOLPjt0Fd10tFs1
         lbPTiy9hz1w0YzCLzfyOD7iKKu1X1/CcP3QMQqICbw/ZgMgxIUwKo3oBmyHWX+vq9HC9
         Aspg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682194171; x=1684786171;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w8jFIlGhqnylD+Ou7GErzwOPZferzkUMYBr2W0WKmRM=;
        b=Gh2BKBzzuVSPZx/n9Kbz2s/SYtphzQhj44toVPqjMvkBArzv4CoQkjgLBdWZ+VMjti
         sH0dhrm6ITgvooXa731JpGz7MddCKFEAVos4kpbgWvGM0dH8Aq+jB2AR/rzdkIc1cgB5
         qGQvmlYvbHeZ8g//7neEeOdsXyGVgTJQcKwxoH4mJ0Ze8eUDn3MDXSAX03+VxL3atob4
         gAXkDwjZHFHjkkXSgPzOoC0327ZhejO4hlKfmPzEOaVXosUtVYZpEj3tEPiJN1iswf+d
         QR0uoaVaMNQ66eFXp5502Fuyvporxfhi8FyTzQTgSEi+HK/YossJqHDtu+VX54Yjtii1
         j5WA==
X-Gm-Message-State: AAQBX9dbk85Aa+xd8973AQGx6a5VI6qCM6f0eUEdA4oPp5AlL1/UtNGK
        ZGJV8U+n5dsBCtQ6QHR7VWDZv/RfwUCKAkMt4DFmrA==
X-Google-Smtp-Source: AKy350YpcThMN9M4t6SsXAMpgez9Pntw09c8BFmv3jdMj6cqDwJFvMV/dbanKEs0VH5c4ybWd6ZTog==
X-Received: by 2002:a17:902:d092:b0:1a6:6a2d:18f0 with SMTP id v18-20020a170902d09200b001a66a2d18f0mr170458plv.9.1682194170914;
        Sat, 22 Apr 2023 13:09:30 -0700 (PDT)
Received: from google.com (220.181.82.34.bc.googleusercontent.com. [34.82.181.220])
        by smtp.gmail.com with ESMTPSA id t9-20020a6549c9000000b0051b3ef1295csm4233580pgs.53.2023.04.22.13.09.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Apr 2023 13:09:30 -0700 (PDT)
Date:   Sat, 22 Apr 2023 13:09:26 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Gavin Shan <gshan@redhat.com>
Cc:     pbonzini@redhat.com, maz@kernel.org, oupton@google.com,
        yuzenghui@huawei.com, dmatlack@google.com, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, qperret@google.com,
        catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, reijiw@google.com, rananta@google.com,
        bgardon@google.com, ricarkol@gmail.com,
        Shaoqin Huang <shahuang@redhat.com>
Subject: Re: [PATCH v7 03/12] KVM: arm64: Add helper for creating unlinked
 stage2 subtrees
Message-ID: <ZEQ+9kyXcQS+1i81@google.com>
References: <20230409063000.3559991-1-ricarkol@google.com>
 <20230409063000.3559991-5-ricarkol@google.com>
 <9cb621b0-7174-a7c7-1524-801b06f94e8f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9cb621b0-7174-a7c7-1524-801b06f94e8f@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 17, 2023 at 02:18:26PM +0800, Gavin Shan wrote:
> On 4/9/23 2:29 PM, Ricardo Koller wrote:
> > Add a stage2 helper, kvm_pgtable_stage2_create_unlinked(), for
> > creating unlinked tables (which is the opposite of
> > kvm_pgtable_stage2_free_unlinked()).  Creating an unlinked table is
> > useful for splitting level 1 and 2 entries into subtrees of PAGE_SIZE
> > PTEs.  For example, a level 1 entry can be split into PAGE_SIZE PTEs
> > by first creating a fully populated tree, and then use it to replace
> > the level 1 entry in a single step.  This will be used in a subsequent
> > commit for eager huge-page splitting (a dirty-logging optimization).
> > 
> > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> > ---
> >   arch/arm64/include/asm/kvm_pgtable.h | 26 +++++++++++++++
> >   arch/arm64/kvm/hyp/pgtable.c         | 49 ++++++++++++++++++++++++++++
> >   2 files changed, 75 insertions(+)
> > 
> 
> With the following nits addressed:
> 
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> 
> > diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> > index 3f2d43ba2b628..c8e0e7d9303b2 100644
> > --- a/arch/arm64/include/asm/kvm_pgtable.h
> > +++ b/arch/arm64/include/asm/kvm_pgtable.h
> > @@ -458,6 +458,32 @@ void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt);
> >    */
> >   void kvm_pgtable_stage2_free_unlinked(struct kvm_pgtable_mm_ops *mm_ops, void *pgtable, u32 level);
> > +/**
> > + * kvm_pgtable_stage2_create_unlinked() - Create an unlinked stage-2 paging structure.
> > + * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init*().
> > + * @phys:	Physical address of the memory to map.
> > + * @level:	Starting level of the stage-2 paging structure to be created.
> > + * @prot:	Permissions and attributes for the mapping.
> > + * @mc:		Cache of pre-allocated and zeroed memory from which to allocate
>                 ^^^^^^^^
> Alignment.

This seems to be due to the "+ ". It looks like this without it:

 * kvm_pgtable_stage2_create_unlinked() - Create an unlinked stage-2 paging structure.
 * @pgt:        Page-table structure initialised by kvm_pgtable_stage2_init*().
 * @phys:       Physical address of the memory to map.
 * @level:      Starting level of the stage-2 paging structure to be created.
 * @prot:       Permissions and attributes for the mapping.
 * @mc:         Cache of pre-allocated and zeroed memory from which to allocate
 *              page-table pages.

> 
> > + *		page-table pages.
> > + * @force_pte:  Force mappings to PAGE_SIZE granularity.
> > + *
> > + * Returns an unlinked page-table tree.  This new page-table tree is
> > + * not reachable (i.e., it is unlinked) from the root pgd and it's
> > + * therefore unreachableby the hardware page-table walker. No TLB
> > + * invalidation or CMOs are performed.
> > + *
> > + * If device attributes are not explicitly requested in @prot, then the
> > + * mapping will be normal, cacheable.
> > + *
> > + * Return: The fully populated (unlinked) stage-2 paging structure, or
> > + * an ERR_PTR(error) on failure.
> > + */
> > +kvm_pte_t *kvm_pgtable_stage2_create_unlinked(struct kvm_pgtable *pgt,
> > +					      u64 phys, u32 level,
> > +					      enum kvm_pgtable_prot prot,
> > +					      void *mc, bool force_pte);
> > +
> >   /**
> >    * kvm_pgtable_stage2_map() - Install a mapping in a guest stage-2 page-table.
> >    * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init*().
> > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> > index 633679ee3c49a..477d2be67d401 100644
> > --- a/arch/arm64/kvm/hyp/pgtable.c
> > +++ b/arch/arm64/kvm/hyp/pgtable.c
> > @@ -1222,6 +1222,55 @@ int kvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size)
> >   	return kvm_pgtable_walk(pgt, addr, size, &walker);
> >   }
> > +kvm_pte_t *kvm_pgtable_stage2_create_unlinked(struct kvm_pgtable *pgt,
> > +					      u64 phys, u32 level,
> > +					      enum kvm_pgtable_prot prot,
> > +					      void *mc, bool force_pte)
> > +{
> > +	struct stage2_map_data map_data = {
> > +		.phys		= phys,
> > +		.mmu		= pgt->mmu,
> > +		.memcache	= mc,
> > +		.force_pte	= force_pte,
> > +	};
> > +	struct kvm_pgtable_walker walker = {
> > +		.cb		= stage2_map_walker,
> > +		.flags		= KVM_PGTABLE_WALK_LEAF |
> > +				  KVM_PGTABLE_WALK_SKIP_BBM_TLBI |
> > +				  KVM_PGTABLE_WALK_SKIP_CMO,
> > +		.arg		= &map_data,
> > +	};
> > +	/* .addr (the IPA) is irrelevant for an unlinked table */
> > +	struct kvm_pgtable_walk_data data = {
> > +		.walker	= &walker,
> > +		.addr	= 0,
> > +		.end	= kvm_granule_size(level),
> > +	};
> 
> The comment about '.addr' seems incorrect. The IPA address is still
> used to locate the page table entry, so I think it would be something
> like below:
> 
> 	/* The IPA address (.addr) is relative to zero */
> 

Extended it to say this:

         * The IPA address (.addr) is relative to zero. The goal is to
         * map "kvm_granule_size(level) - 0" worth of pages.

> > +	struct kvm_pgtable_mm_ops *mm_ops = pgt->mm_ops;
> > +	kvm_pte_t *pgtable;
> > +	int ret;
> > +
> > +	if (!IS_ALIGNED(phys, kvm_granule_size(level)))
> > +		return ERR_PTR(-EINVAL);
> > +
> > +	ret = stage2_set_prot_attr(pgt, prot, &map_data.attr);
> > +	if (ret)
> > +		return ERR_PTR(ret);
> > +
> > +	pgtable = mm_ops->zalloc_page(mc);
> > +	if (!pgtable)
> > +		return ERR_PTR(-ENOMEM);
> > +
> > +	ret = __kvm_pgtable_walk(&data, mm_ops, (kvm_pteref_t)pgtable,
> > +				 level + 1);
> > +	if (ret) {
> > +		kvm_pgtable_stage2_free_unlinked(mm_ops, pgtable, level);
> > +		mm_ops->put_page(pgtable);
> > +		return ERR_PTR(ret);
> > +	}
> > +
> > +	return pgtable;
> > +}
> >   int __kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
> >   			      struct kvm_pgtable_mm_ops *mm_ops,
> > 
> 
> Thanks,
> Gavin
> 
