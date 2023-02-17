Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82C2C69A6E4
	for <lists+kvm@lfdr.de>; Fri, 17 Feb 2023 09:27:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229781AbjBQI1z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Feb 2023 03:27:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbjBQI1y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Feb 2023 03:27:54 -0500
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B6E25FD8;
        Fri, 17 Feb 2023 00:27:51 -0800 (PST)
Received: by mail-lj1-x233.google.com with SMTP id r12so405662ljg.4;
        Fri, 17 Feb 2023 00:27:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QAoMJKlMJ+XFbSX67OuVv50PwIJOWkP1+4AQHzhPSBI=;
        b=k0dek0QEJcdjG5iRaaOlqBTL+r2HXB/4pVxjTCu9cbunK/oZ0rvaSr4IOQcEJPjMZu
         YzC80oegiQZH7KiywkxXnqXGAWvY6/cByeGn7r6iTe3a4r2P4/zLydmnHEjp99q1f+qw
         pWgX3Pnzm4VpffdSOI8hG5Kb9Q6mfMElGsMkCBqwpUcbEJ4zfFaq2JUkO8YseP9+3x9+
         WHCo/P09LrRBaKiRG1A7iGvhWOak94yRYJCSzvpQE4rZYZcuHw6QjvFykXHjQ/07GxG4
         LFD246YzUD6SIGN0/f6/CDvU4SLciJYuleJ4SjD8x7yHS7lM4qiEPchc2V5ZadzcGit0
         gcRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QAoMJKlMJ+XFbSX67OuVv50PwIJOWkP1+4AQHzhPSBI=;
        b=4ulgmKWx+1QdDwGazFgEUxQSV13frt2VwLlN2VtMm5ESU4C4c1ki9r7edM+oJzKQVu
         2Zz5lKMZhpaxZ9+llmfgXJYOlUmqHd9nh1sx7cq5Y8es77HT7OAy/JTChJGd6g8/qA5a
         QfKnG7pTKsv8uE319vis2s1Hsz8eD++tBwowB6hGAoB8rMrC/qoLD7MqkdcsK+8eHf0G
         vyfL+P0fbluo4EdPoKdQYXt10frIAKa94MD7IcRerKJCGxx/aBhi7lTvUewhi6gQgJ8z
         Yf5zJ39aJfTb472vbJ0qqarjNKfk9xeqVf3K/Eg/NfMFn4yESR+Y4irx/O0Tu+IPzMCS
         1guA==
X-Gm-Message-State: AO0yUKV9yrw6LdJ3jNGCoeRxj7O8sEV1KzgZQJL7PSXfv4949KEwWPn7
        30I9YyCkYxE6zLA4kETc1SroPBHauys=
X-Google-Smtp-Source: AK7set8D9uBbw+3iBbBQ1xyqHMFFSTvgKsBKUsJ9d7KylbJFqPupp8qm2cdGiGQnKxIGZF3xFFOpaw==
X-Received: by 2002:a2e:bea8:0:b0:294:710a:fe6c with SMTP id a40-20020a2ebea8000000b00294710afe6cmr659798ljr.0.1676622469585;
        Fri, 17 Feb 2023 00:27:49 -0800 (PST)
Received: from localhost (88-115-161-74.elisa-laajakaista.fi. [88.115.161.74])
        by smtp.gmail.com with ESMTPSA id j20-20020a2e8014000000b002934ba451b1sm505580ljg.131.2023.02.17.00.27.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Feb 2023 00:27:49 -0800 (PST)
Date:   Fri, 17 Feb 2023 10:27:47 +0200
From:   Zhi Wang <zhi.wang.linux@gmail.com>
To:     isaku.yamahata@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v11 050/113] KVM: x86/tdp_mmu: Ignore unsupported mmu
 operation on private GFNs
Message-ID: <20230217102747.00001d7f@gmail.com>
In-Reply-To: <7a0fb2a0dddc87fb8d34d5af8fc73b288dbcc63c.1673539699.git.isaku.yamahata@intel.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
        <7a0fb2a0dddc87fb8d34d5af8fc73b288dbcc63c.1673539699.git.isaku.yamahata@intel.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 12 Jan 2023 08:31:58 -0800
isaku.yamahata@intel.com wrote:

> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Some KVM MMU operations (dirty page logging, page migration, aging page)
> aren't supported for private GFNs (yet) with the first generation of TDX.
> Silently return on unsupported TDX KVM MMU operations.
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  arch/x86/kvm/mmu/mmu.c     |  3 +++
>  arch/x86/kvm/mmu/tdp_mmu.c | 50 ++++++++++++++++++++++++++++++++++----
>  arch/x86/kvm/x86.c         |  3 +++
>  3 files changed, 51 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 484e615196aa..ad0482a101a3 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -6635,6 +6635,9 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
>  	for_each_rmap_spte(rmap_head, &iter, sptep) {
>  		sp = sptep_to_sp(sptep);
>  
> +		/* Private page dirty logging is not supported yet. */
> +		KVM_BUG_ON(is_private_sptep(sptep), kvm);
> +
>  		/*
>  		 * We cannot do huge page mapping for indirect shadow pages,
>  		 * which are found on the last rmap (level = 1) when not using
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 5ce0328c71df..69e202bd1897 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1478,7 +1478,8 @@ typedef bool (*tdp_handler_t)(struct kvm *kvm, struct tdp_iter *iter,
>  
>  static __always_inline bool kvm_tdp_mmu_handle_gfn(struct kvm *kvm,
>  						   struct kvm_gfn_range *range,
> -						   tdp_handler_t handler)
> +						   tdp_handler_t handler,
> +						   bool only_shared)

What's the purpose of having only_shared while all the callers will set it as
true?

>  {
>  	struct kvm_mmu_page *root;
>  	struct tdp_iter iter;
> @@ -1489,9 +1490,23 @@ static __always_inline bool kvm_tdp_mmu_handle_gfn(struct kvm *kvm,
>  	 * into this helper allow blocking; it'd be dead, wasteful code.
>  	 */
>  	for_each_tdp_mmu_root(kvm, root, range->slot->as_id) {
> +		gfn_t start;
> +		gfn_t end;
> +
> +		if (only_shared && is_private_sp(root))
> +			continue;
> +
>  		rcu_read_lock();
>  
> -		tdp_root_for_each_leaf_pte(iter, root, range->start, range->end)
> +		/*
> +		 * For TDX shared mapping, set GFN shared bit to the range,
> +		 * so the handler() doesn't need to set it, to avoid duplicated
> +		 * code in multiple handler()s.
> +		 */
> +		start = kvm_gfn_for_root(kvm, root, range->start);
> +		end = kvm_gfn_for_root(kvm, root, range->end);
> +

The coco implementation tends to treat the SHARED bit / C bit as a page_prot,
an attribute, not a part of the GFN. From that prospective, the caller needs to
be aware if it is operating on the private memory or shared memory, so does
the handler. The page table walker should know the SHARED bit as a attribute.

I don't think it is a good idea to have two different understandings, which
will cause conversion and confusion.

> +		tdp_root_for_each_leaf_pte(iter, root, start, end)
>  			ret |= handler(kvm, &iter, range);
>  
>  		rcu_read_unlock();
> @@ -1535,7 +1550,12 @@ static bool age_gfn_range(struct kvm *kvm, struct tdp_iter *iter,
>  
>  bool kvm_tdp_mmu_age_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
>  {
> -	return kvm_tdp_mmu_handle_gfn(kvm, range, age_gfn_range);
> +	/*
> +	 * First TDX generation doesn't support clearing A bit for private
> +	 * mapping, since there's no secure EPT API to support it.  However
> +	 * it's a legitimate request for TDX guest.
> +	 */
> +	return kvm_tdp_mmu_handle_gfn(kvm, range, age_gfn_range, true);
>  }
>  
>  static bool test_age_gfn(struct kvm *kvm, struct tdp_iter *iter,
> @@ -1546,7 +1566,8 @@ static bool test_age_gfn(struct kvm *kvm, struct tdp_iter *iter,
>  
>  bool kvm_tdp_mmu_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
>  {
> -	return kvm_tdp_mmu_handle_gfn(kvm, range, test_age_gfn);
> +	/* The first TDX generation doesn't support A bit. */
> +	return kvm_tdp_mmu_handle_gfn(kvm, range, test_age_gfn, true);
>  }
>  
>  static bool set_spte_gfn(struct kvm *kvm, struct tdp_iter *iter,
> @@ -1591,8 +1612,11 @@ bool kvm_tdp_mmu_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
>  	 * No need to handle the remote TLB flush under RCU protection, the
>  	 * target SPTE _must_ be a leaf SPTE, i.e. cannot result in freeing a
>  	 * shadow page.  See the WARN on pfn_changed in __handle_changed_spte().
> +	 *
> +	 * .change_pte() callback should not happen for private page, because
> +	 * for now TDX private pages are pinned during VM's life time.
>  	 */
> -	return kvm_tdp_mmu_handle_gfn(kvm, range, set_spte_gfn);
> +	return kvm_tdp_mmu_handle_gfn(kvm, range, set_spte_gfn, true);
>  }
>
If the mmu notifier callbacks will never operate on a private page, having a
WARN_ON() is better than silently letting it fade away.  

>  /*
> @@ -1974,6 +1998,13 @@ void kvm_tdp_mmu_clear_dirty_pt_masked(struct kvm *kvm,
>  	struct kvm_mmu_page *root;
>  
>  	lockdep_assert_held_write(&kvm->mmu_lock);
> +	/*
> +	 * First TDX generation doesn't support clearing dirty bit,
> +	 * since there's no secure EPT API to support it.  For now silently
> +	 * ignore KVM_CLEAR_DIRTY_LOG.
> +	 */
> +	if (!kvm_arch_dirty_log_supported(kvm))
> +		return;
>  	for_each_tdp_mmu_root(kvm, root, slot->as_id)
>  		clear_dirty_pt_masked(kvm, root, gfn, mask, wrprot);
>  }
> @@ -2093,6 +2124,15 @@ bool kvm_tdp_mmu_write_protect_gfn(struct kvm *kvm,
>  	bool spte_set = false;
>  
>  	lockdep_assert_held_write(&kvm->mmu_lock);
> +
> +	/*
> +	 * First TDX generation doesn't support write protecting private
> +	 * mappings, silently ignore the request.  KVM_GET_DIRTY_LOG etc
> +	 * can reach here, no warning.
> +	 */
> +	if (!kvm_arch_dirty_log_supported(kvm))
> +		return false;
> +
>  	for_each_tdp_mmu_root(kvm, root, slot->as_id)
>  		spte_set |= write_protect_gfn(kvm, root, gfn, min_level);
> 

> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 5b4d5f8128a5..c4579e696d39 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -12526,6 +12526,9 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
>  	u32 new_flags = new ? new->flags : 0;
>  	bool log_dirty_pages = new_flags & KVM_MEM_LOG_DIRTY_PAGES;
>  
> +	if (!kvm_arch_dirty_log_supported(kvm) && log_dirty_pages)
> +		return;
> +
>  	/*
>  	 * Update CPU dirty logging if dirty logging is being toggled.  This
>  	 * applies to all operations.

