Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C65725873C5
	for <lists+kvm@lfdr.de>; Tue,  2 Aug 2022 00:10:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235126AbiHAWKt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Aug 2022 18:10:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235240AbiHAWKc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Aug 2022 18:10:32 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D33B2715F
        for <kvm@vger.kernel.org>; Mon,  1 Aug 2022 15:10:29 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id q22so3567112plr.9
        for <kvm@vger.kernel.org>; Mon, 01 Aug 2022 15:10:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=vCM9uv01al+tkGRXGb8S850ULa0DIPowMZAX7ulbhhg=;
        b=rBo8Stea4RwEIAtwqjrlIgwgyo1K6PaTAvCGwOwvkFMf3mkBkJLoX8791ajGb8GM1U
         LxM4sQkSb93SDqGd+1IFq9V+/yonKjH8hD4Mly9J/VMX1oXEeHeiQa8GjBYRuIhhgQgz
         91PMjhb+/ZjCrsGPWF6+G1ErxSpSUUMCfNLOzP9S45298ttF2qLloLJ5KADl1jjmR5A+
         TU4V1IwMC0uKdoGqz1XPk12oA1p/fszJV5KbitQVE+1o+l0QSp/WmlLWqcnka+Ie1z0g
         beEIkKXpNVWKAMXtkmeFt/ni4qD6CJReIBS3WAlWt9MyZUyhpnlRXhzaSx/qrjM1RPwm
         STZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=vCM9uv01al+tkGRXGb8S850ULa0DIPowMZAX7ulbhhg=;
        b=ph2sDI/89nWFG4rvXL2JoAOCjDLeMVYU0D84UgoOgbb8gOUhKmNadavAa9neBYmQga
         x/h5+XvsQUSjj6tOksXjvfiMG7pAt1KoT8wZUSKlpCg+/MW9Ot962MoBuEawISQ3XqqF
         GgGt3O7/19dYVhUCSn2mXoDahkJi+MprOBRPSMb4pmLAM/op8GfKHoCxAtJ0Mhxxd6+D
         dP55ERGIBpHANb4dnB0Xv7vqduO70H7vffzo9OUJGQpQoEqS6c8DLezTBfZlwJhGmzD+
         Cei19eAjN21Zhgfqy0XU0jL1VPFQsmYPtzauHZBGgqYf91F0R3T8b09BXDL7+iwTY7oC
         /UBw==
X-Gm-Message-State: ACgBeo3HKYcBR8wwkBAUgY4qXu+WA8awGlZZvenXL1Qw7gTV0q2/eWMQ
        SiRRMjM7vfR7tELzu644mhLPLg==
X-Google-Smtp-Source: AA6agR6TpIcG/KZ5DeJTs0MV4kYsQz+/SwXkbNMNCAJ+X1WgU/eC7wKI+JfeU5hG9KnbCe31g3j8ng==
X-Received: by 2002:a17:903:2054:b0:16e:c85d:d86c with SMTP id q20-20020a170903205400b0016ec85dd86cmr14309244pla.39.1659391828376;
        Mon, 01 Aug 2022 15:10:28 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id j24-20020a63fc18000000b004114cc062f0sm7861268pgi.65.2022.08.01.15.10.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Aug 2022 15:10:27 -0700 (PDT)
Date:   Mon, 1 Aug 2022 15:10:23 -0700
From:   David Matlack <dmatlack@google.com>
To:     Vipin Sharma <vipinsh@google.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86/mmu: Make page tables for eager page splitting
 NUMA aware
Message-ID: <YuhPT2drgqL+osLl@google.com>
References: <20220801151928.270380-1-vipinsh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220801151928.270380-1-vipinsh@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 01, 2022 at 08:19:28AM -0700, Vipin Sharma wrote:
>

In the shortlog, clarify that this only applies to the TDP MMU.

> tdp_mmu_alloc_sp_for_split() allocates page tables for Eager Page
> Splitting.  Currently it does not specify a NUMA node preference, so it
> will try to allocate from the local node. The thread doing eager page

nit: Instead of "try to allocate from the local node", say something
like "allocate using the current threads mempolicy, which is most likely
going to be MPOL_LOCAL, i.e. allocate from the local node."

> splitting is supplied by the userspace and may not be running on the same
> node where it would be best for page tables to be allocated.

Suggest comparing eager page splitting to vCPU faults, which is the
other place that TDP page tables are allocated. e.g.

  Note that TDP page tables allocated during fault handling are less
  likely to suffer from the same NUMA locality issue because they will
  be allocated on the same node as the vCPU thread (assuming its
  mempolicy is MPOL_LOCAL), which is often the right node.

That being said, KVM currently has a gap where a guest doing a lot of
remote memory accesses when touching memory for the first time will
cause KVM to allocate the TDP page tables on the arguably wrong node.

> 
> We can improve TDP MMU eager page splitting by making
> tdp_mmu_alloc_sp_for_split() NUMA-aware. Specifically, when splitting a
> huge page, allocate the new lower level page tables on the same node as the
> huge page.
> 
> __get_free_page() is replaced by alloc_page_nodes(). This introduces two
> functional changes.
> 
>   1. __get_free_page() removes gfp flag __GFP_HIGHMEM via call to
>   __get_free_pages(). This should not be an issue  as __GFP_HIGHMEM flag is
>   not passed in tdp_mmu_alloc_sp_for_split() anyway.
> 
>   2. __get_free_page() calls alloc_pages() and use thread's mempolicy for
>   the NUMA node allocation. From this commit, thread's mempolicy will not
>   be used and first preference will be to allocate on the node where huge
>   page was present.

It would be worth noting that userspace could change the mempolicy of
the thread doing eager splitting to prefer allocating from the target
NUMA node, as an alternative approach.

I don't prefer the alternative though since it bleeds details from KVM
into userspace, such as the fact that enabling dirty logging does eager
page splitting, which allocates page tables. It's also unnecessary since
KVM can infer an appropriate NUMA placement without the help of
userspace, and I can't think of a reason for userspace to prefer a
different policy.

> 
> dirty_log_perf_test for 416 vcpu and 1GB/vcpu configuration on a 8 NUMA
> node machine showed dirty memory time improvements between 2% - 35% in
> multiple runs.

That's a pretty wide range.

What's probably happening is vCPU threads are being migrated across NUMA
nodes during the test. So for example, a vCPU thread might first run on
Node 0 during the Populate memory phase, so the huge page will be
allocated on Node 0 as well. But then if the thread gets migrated to
Node 1 later, it will perform poorly because it's memory is on a remote
node.

I would recommend pinning vCPUs to specific NUMA nodes to prevent
cross-node migrations. e.g. For a 416 vCPU VM, pin 52 to Node 0, 52 to
Node 1, etc. That should results in more consistent performance and will
be more inline with how large NUMA VMs are actually configured to run.

> 
> Suggested-by: David Matlack <dmatlack@google.com>
> Signed-off-by: Vipin Sharma <vipinsh@google.com>
> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 24 +++++++++++++++++++-----
>  1 file changed, 19 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index bf2ccf9debcaa..1e30e18fc6a03 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1402,9 +1402,19 @@ bool kvm_tdp_mmu_wrprot_slot(struct kvm *kvm,
>  	return spte_set;
>  }
>  
> -static struct kvm_mmu_page *__tdp_mmu_alloc_sp_for_split(gfp_t gfp)
> +/*
> + * Caller's responsibility to pass a valid spte which has the shadow page
> + * present.
> + */
> +static int tdp_mmu_spte_to_nid(u64 spte)

I think this name is ambiguous because it could be getting the node ID
of the SPTE itself, or the node ID of the page the SPTE is pointing to.

Maybe tdp_mmu_spte_pfn_nid()? Or just drop the helper an open code this
calculation in tdp_mmu_alloc_sp_for_split().

> +{
> +	return page_to_nid(pfn_to_page(spte_to_pfn(spte)));
> +}
> +
> +static struct kvm_mmu_page *__tdp_mmu_alloc_sp_for_split(int nid, gfp_t gfp)
>  {
>  	struct kvm_mmu_page *sp;
> +	struct page *spt_page;
>  
>  	gfp |= __GFP_ZERO;
>  
> @@ -1412,11 +1422,12 @@ static struct kvm_mmu_page *__tdp_mmu_alloc_sp_for_split(gfp_t gfp)
>  	if (!sp)
>  		return NULL;
>  
> -	sp->spt = (void *)__get_free_page(gfp);
> -	if (!sp->spt) {
> +	spt_page = alloc_pages_node(nid, gfp, 0);
> +	if (!spt_page) {
>  		kmem_cache_free(mmu_page_header_cache, sp);
>  		return NULL;
>  	}
> +	sp->spt = page_address(spt_page);
>  
>  	return sp;
>  }
> @@ -1426,6 +1437,9 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(struct kvm *kvm,
>  						       bool shared)
>  {
>  	struct kvm_mmu_page *sp;
> +	int nid;
> +
> +	nid = tdp_mmu_spte_to_nid(iter->old_spte);
>  
>  	/*
>  	 * Since we are allocating while under the MMU lock we have to be
> @@ -1436,7 +1450,7 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(struct kvm *kvm,
>  	 * If this allocation fails we drop the lock and retry with reclaim
>  	 * allowed.
>  	 */
> -	sp = __tdp_mmu_alloc_sp_for_split(GFP_NOWAIT | __GFP_ACCOUNT);
> +	sp = __tdp_mmu_alloc_sp_for_split(nid, GFP_NOWAIT | __GFP_ACCOUNT);
>  	if (sp)
>  		return sp;
>  
> @@ -1448,7 +1462,7 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(struct kvm *kvm,
>  		write_unlock(&kvm->mmu_lock);
>  
>  	iter->yielded = true;
> -	sp = __tdp_mmu_alloc_sp_for_split(GFP_KERNEL_ACCOUNT);
> +	sp = __tdp_mmu_alloc_sp_for_split(nid, GFP_KERNEL_ACCOUNT);
>  
>  	if (shared)
>  		read_lock(&kvm->mmu_lock);
> -- 
> 2.37.1.455.g008518b4e5-goog
> 
