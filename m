Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2230659274
	for <lists+kvm@lfdr.de>; Thu, 29 Dec 2022 23:31:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234119AbiL2Wa6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Dec 2022 17:30:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233601AbiL2Wa5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Dec 2022 17:30:57 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D4FF120A1
        for <kvm@vger.kernel.org>; Thu, 29 Dec 2022 14:30:56 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id c9so8571591pfj.5
        for <kvm@vger.kernel.org>; Thu, 29 Dec 2022 14:30:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/T7t6TqLFYse20ylRlVN/6lR+B2I/VOA2dwMXXCSOuk=;
        b=YxCiGBDi8ZLG/+4RsZkzEV/FWaasqxmdRL4VKK2MsCWqNDUoQvbsvcMjHZC6LNvZr7
         HdUVkwsU+nfs6NNknJCj4l8MUx+xDcaFgZF5mmA/omnDtZg1/IrhEOw1ib8oqx15HN/Q
         yaCN6dWS1B3r/xZqzqQIV3jDJU2c+7LHgMyKm+00vLFgEIjKUNimp6gzBCISbdAW+Ttt
         CD6FBsxslNIGKZRlHfLQNQP5jxIbP6fp8JrGBu/CVfSFyFikzQGisEr8S/DiP7s6pz1a
         Z5/6ykkH0NtnO6c7cDxrrRmh6bVEYUn9gVmGunARS5Uneo4S0AJUtQ0yF/psORuO7TWz
         IKWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/T7t6TqLFYse20ylRlVN/6lR+B2I/VOA2dwMXXCSOuk=;
        b=2kefyMEGmFTg3Qc+4BDidCwvYO8ndL3da0ZmmKVTFUTiUwivV8TO4Qghb1+KJLiLTe
         T2h10Myk9QbkYT6pa7QUH2CT6/mepGwS1CBZezIWIMwJfufv6DuS3nBRna8hyxxiFYLy
         ketZJL5iZdRoHJLxAaPEPsg3z2+VADk7YFURjhEN5sxTDfvMtAa2SxJsYJ7OMVeqtVWX
         UWwVcjxL+r3WZMT+G2Atq4QEpX8x52J0zlf77Kfh8Ez4zhz8lOR/wKIh70ghDjJq5FZR
         qlBNrAPmTHJ43kXqxEx+AyGooBvmAwb/DORI7LuQU3VUc626MqQ4XQ8ftiertHDwZQlF
         paXQ==
X-Gm-Message-State: AFqh2kreJcfTXvOjhQjw8/6s5EYwbHD0954XgRvGov/1xOveOiLzHGEt
        ljPxkrgUOnsDJl8c7Zqy1eOQSU2Z8j6BQn3a
X-Google-Smtp-Source: AMrXdXuHIj+DCE+mwA4RZWLh+xZAPbs9xd95o8uZw9dwZkUO+L5+0IrPo1Qt2sgvYpYVIwwOkvi3zQ==
X-Received: by 2002:a62:4e93:0:b0:57f:ef11:acf9 with SMTP id c141-20020a624e93000000b0057fef11acf9mr28967825pfb.10.1672353055934;
        Thu, 29 Dec 2022 14:30:55 -0800 (PST)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id y18-20020aa79432000000b00577617c05ecsm12552429pfo.130.2022.12.29.14.30.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Dec 2022 14:30:55 -0800 (PST)
Date:   Thu, 29 Dec 2022 14:30:51 -0800
From:   David Matlack <dmatlack@google.com>
To:     Vipin Sharma <vipinsh@google.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, bgardon@google.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Patch v3 5/9] KVM: x86/mmu: Allocate TDP page table's page on
 correct NUMA node on split
Message-ID: <Y64VG4Bl0fujE2qG@google.com>
References: <20221222023457.1764-1-vipinsh@google.com>
 <20221222023457.1764-6-vipinsh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221222023457.1764-6-vipinsh@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 21, 2022 at 06:34:53PM -0800, Vipin Sharma wrote:
> When dirty log is enabled, huge pages are split. Page table's pages
> during the split are allocated based on the current thread NUMA node or
> mempolicy. This causes inefficient page table accesses if underlying
> page is on a different NUMA node
> 
> Allocate page table's pages on the same NUMA node as the underlying huge
> page when dirty log is enabled and huge pages are split.
> 
> The performance gain during the pre-copy phase of live migrations of a
> 416 vCPUs and 11 TiB memory VM  on a 8 node host was seen in the range
> of 130% to 150%.

Can you be more specific about this. "The performance" is vague. I know
it's an internal workload and fully explaining it would be difficult,
but you can give readers a slightly more specific idea of what improved.
e.g.

 When testing with a synthetic write-heavy workload in a 416 vCPU VM on
 an 8 NUMA node host, the throughput increased by 150% from X to Y
 operations per second.

It's also necessary to characterize the improvement relative to the
performance when dirty logging is not enabled. Whithout that information
it would be hard for an unfamiliar reader to understand how useful this
change really is.

For example, let's say the throughput of your workload is 100,000
operations per second before dirty logging is enabled, and that drops
down to 1,000 operations per second after dirty logging is enabled. This
commit could increase that by 150% to 2,500 operations per second, but
that's actually not a very meaningful improvement since, either way,
guest performance is degraded by 95+% during dirty logging.

On the other hand, if performance goes from 100,000 to 30,000 normally,
and this commit increases that 30,000 to 75,000 (150%), that's a much
more meaningful improvement.

> 
> Suggested-by: David Matlack <dmatlack@google.com>
> Signed-off-by: Vipin Sharma <vipinsh@google.com>
> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 12 ++++++++----
>  include/linux/kvm_host.h   | 18 ++++++++++++++++++
>  2 files changed, 26 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 4974fa96deff..376b8dceb3f9 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1403,7 +1403,7 @@ bool kvm_tdp_mmu_wrprot_slot(struct kvm *kvm,
>  	return spte_set;
>  }
>  
> -static struct kvm_mmu_page *__tdp_mmu_alloc_sp_for_split(gfp_t gfp)
> +static struct kvm_mmu_page *__tdp_mmu_alloc_sp_for_split(int nid, gfp_t gfp)
>  {
>  	struct kvm_mmu_page *sp;
>  
> @@ -1413,7 +1413,8 @@ static struct kvm_mmu_page *__tdp_mmu_alloc_sp_for_split(gfp_t gfp)
>  	if (!sp)
>  		return NULL;
>  
> -	sp->spt = (void *)__get_free_page(gfp);
> +	sp->spt = kvm_mmu_get_free_page(nid, gfp);
> +
>  	if (!sp->spt) {
>  		kmem_cache_free(mmu_page_header_cache, sp);
>  		return NULL;
> @@ -1427,6 +1428,9 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(struct kvm *kvm,
>  						       bool shared)
>  {
>  	struct kvm_mmu_page *sp;
> +	int nid;
> +
> +	nid = kvm_pfn_to_page_table_nid(spte_to_pfn(iter->old_spte));
>  
>  	/*
>  	 * Since we are allocating while under the MMU lock we have to be
> @@ -1437,7 +1441,7 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(struct kvm *kvm,
>  	 * If this allocation fails we drop the lock and retry with reclaim
>  	 * allowed.
>  	 */
> -	sp = __tdp_mmu_alloc_sp_for_split(GFP_NOWAIT | __GFP_ACCOUNT);
> +	sp = __tdp_mmu_alloc_sp_for_split(nid, GFP_NOWAIT | __GFP_ACCOUNT);
>  	if (sp)
>  		return sp;
>  
> @@ -1449,7 +1453,7 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(struct kvm *kvm,
>  		write_unlock(&kvm->mmu_lock);
>  
>  	iter->yielded = true;
> -	sp = __tdp_mmu_alloc_sp_for_split(GFP_KERNEL_ACCOUNT);
> +	sp = __tdp_mmu_alloc_sp_for_split(nid, GFP_KERNEL_ACCOUNT);
>  
>  	if (shared)
>  		read_lock(&kvm->mmu_lock);
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index d48064503b88..a262e15ebd19 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1583,6 +1583,24 @@ void kvm_arch_sync_events(struct kvm *kvm);
>  int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu);
>  
>  struct page *kvm_pfn_to_refcounted_page(kvm_pfn_t pfn);
> +
> +/*
> + * Tells the appropriate NUMA node location of the page table's page based on
> + * pfn it will point to.

I know what you are trying to say but the wording is a bit awkward. e.g.
"Tells" instead of "Returns", "location" is redundant, "page table's
page", etc. Suggest this:

/*
 * Returns an appropriate NUMA node on which to allocate a page table that
 * maps @pfn.
 */

> + *
> + * Return the nid of the page if pfn is valid and backed by a refcounted page,
> + * otherwise, return the nearest memory node for the current CPU.

I would just drop this as it's just restating the code, which is already
very readable.

> + */
> +static inline int kvm_pfn_to_page_table_nid(kvm_pfn_t pfn)
> +{
> +	struct page *page = kvm_pfn_to_refcounted_page(pfn);
> +
> +	if (page)
> +		return page_to_nid(page);
> +	else
> +		return numa_mem_id();
> +}
> +
>  bool kvm_is_zone_device_page(struct page *page);
>  
>  struct kvm_irq_ack_notifier {
> -- 
> 2.39.0.314.g84b9a713c41-goog
> 
