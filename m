Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 497D05202E6
	for <lists+kvm@lfdr.de>; Mon,  9 May 2022 18:50:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239375AbiEIQwN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 May 2022 12:52:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239358AbiEIQwM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 May 2022 12:52:12 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 760E7237242
        for <kvm@vger.kernel.org>; Mon,  9 May 2022 09:48:17 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id v10so12516772pgl.11
        for <kvm@vger.kernel.org>; Mon, 09 May 2022 09:48:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gr9sMVs6ZdL8g3tPzoqOfbfxtZ+VfAYj0GG/Lu5p3Do=;
        b=OjZ2kHgAm+ILSkIUJhTMWyTvLuftdyN9Kyi5pPlToUr2VbBgQzqMUvubbcjgcNoEKY
         MXYEnQTNZicEPklzohiMYBm+qP9+SYEduyruz2LNwSpo+USrM27as+qWNBIgYtxEZv5E
         WCmCreQKrqgSdfsvR/pMxVBm6RrS8hxwl8b9+Cjrp61ynKE00Ia3w6w1K1uFIobv4dQQ
         aIQZvwYL+FUa1nMowwvnlDaTET5kDXKgRwzA5TOMmAPfdQZPb2aF9agEBMF5V2C8abWU
         PvaYjtBfEYbtDRS/ZncAjUhNAsBBXlyVm4pIymLVH7kh51QXIiMLGjEHljjUysN1gQ0O
         g5ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gr9sMVs6ZdL8g3tPzoqOfbfxtZ+VfAYj0GG/Lu5p3Do=;
        b=V1z4Lm8PqVtam1XFBb6qwsxkYrKmTC9zKmsQyOg3nD1CmLt/7ntITbm6FFRhCAFbDB
         tr8yWtuxTTqRi7irLlr1FFRgjl6lciP7HA/C0l8l+wLmRiwBmDrE7P2xF3SYmFBk5IK/
         2pxuuWrkueV9+XYwqf4CO8Z4WaU5MNdGbo/kKVitJVVs+UoaYhqMxsSYBmVN6iY6z5sT
         zGoqdK62CJA9pJizZm7UEfmEhiIVDSdxcbu8RiaWvb5d4BCCN7uB7MNDYD6j+qtpQzne
         1U090Y8bFbJdIvqO5tBVar+Zda+LdjijcyEdugGAUA46WOy6ApuV4JGvseGqr3ap0QVX
         6Wrw==
X-Gm-Message-State: AOAM532+ju/VmBOcSrs+PZ1L+Xb/5yl82eSNUIujrT8wNfrvG21gdsOn
        /RCrf97sH2GWhyJrXwB8lxO9gA==
X-Google-Smtp-Source: ABdhPJx215vrOO009vGUpGxw2kjUjvEvzUv6r8zkab3Hrf61cs9pR1cmpHEArZYDJKlr8poCIJHRbg==
X-Received: by 2002:a05:6a00:1391:b0:50d:e125:e3c with SMTP id t17-20020a056a00139100b0050de1250e3cmr16967062pfg.75.1652114896725;
        Mon, 09 May 2022 09:48:16 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id r7-20020a17090b050700b001d2bff34228sm12911467pjz.9.2022.05.09.09.48.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 May 2022 09:48:16 -0700 (PDT)
Date:   Mon, 9 May 2022 16:48:12 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Andrew Jones <drjones@redhat.com>,
        Ben Gardon <bgardon@google.com>, Peter Xu <peterx@redhat.com>,
        maciej.szmigiero@oracle.com,
        "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)" 
        <kvmarm@lists.cs.columbia.edu>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <linux-mips@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>, Peter Feiner <pfeiner@google.com>
Subject: Re: [PATCH v4 20/20] KVM: x86/mmu: Extend Eager Page Splitting to
 nested MMUs
Message-ID: <YnlFzMpJZNfFuFic@google.com>
References: <20220422210546.458943-1-dmatlack@google.com>
 <20220422210546.458943-21-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220422210546.458943-21-dmatlack@google.com>
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

On Fri, Apr 22, 2022, David Matlack wrote:
> +static bool need_topup_split_caches_or_resched(struct kvm *kvm)
> +{
> +	if (need_resched() || rwlock_needbreak(&kvm->mmu_lock))
> +		return true;
> +
> +	/*
> +	 * In the worst case, SPLIT_DESC_CACHE_CAPACITY descriptors are needed
> +	 * to split a single huge page. Calculating how many are actually needed
> +	 * is possible but not worth the complexity.
> +	 */
> +	return need_topup(&kvm->arch.split_desc_cache, SPLIT_DESC_CACHE_CAPACITY) ||
> +		need_topup(&kvm->arch.split_page_header_cache, 1) ||
> +		need_topup(&kvm->arch.split_shadow_page_cache, 1);

Uber nit that Paolo will make fun of me for... please align indentiation

	return need_topup(&kvm->arch.split_desc_cache, SPLIT_DESC_CACHE_CAPACITY) ||
	       need_topup(&kvm->arch.split_page_header_cache, 1) ||
	       need_topup(&kvm->arch.split_shadow_page_cache, 1);

> +static void nested_mmu_split_huge_page(struct kvm *kvm,
> +				       const struct kvm_memory_slot *slot,
> +				       u64 *huge_sptep)
> +
> +{
> +	struct kvm_mmu_memory_cache *cache = &kvm->arch.split_desc_cache;
> +	u64 huge_spte = READ_ONCE(*huge_sptep);
> +	struct kvm_mmu_page *sp;
> +	bool flush = false;
> +	u64 *sptep, spte;
> +	gfn_t gfn;
> +	int index;
> +
> +	sp = nested_mmu_get_sp_for_split(kvm, huge_sptep);
> +
> +	for (index = 0; index < PT64_ENT_PER_PAGE; index++) {
> +		sptep = &sp->spt[index];
> +		gfn = kvm_mmu_page_get_gfn(sp, index);
> +
> +		/*
> +		 * The SP may already have populated SPTEs, e.g. if this huge
> +		 * page is aliased by multiple sptes with the same access
> +		 * permissions. These entries are guaranteed to map the same
> +		 * gfn-to-pfn translation since the SP is direct, so no need to
> +		 * modify them.
> +		 *
> +		 * However, if a given SPTE points to a lower level page table,
> +		 * that lower level page table may only be partially populated.
> +		 * Installing such SPTEs would effectively unmap a potion of the
> +		 * huge page, which requires a TLB flush.

Maybe explain why a TLB flush is required?  E.g. "which requires a TLB flush as
a subsequent mmu_notifier event on the unmapped region would fail to detect the
need to flush".

> +static bool nested_mmu_skip_split_huge_page(u64 *huge_sptep)

"skip" is kinda odd terminology.  It reads like a command, but it's actually
querying state _and_ it's returning a boolean, which I've learned to hate :-)

I don't see any reason for a helper, there's one caller and it can just do
"continue" directly.

> +static void kvm_nested_mmu_try_split_huge_pages(struct kvm *kvm,
> +						const struct kvm_memory_slot *slot,
> +						gfn_t start, gfn_t end,
> +						int target_level)
> +{
> +	int level;
> +
> +	/*
> +	 * Split huge pages starting with KVM_MAX_HUGEPAGE_LEVEL and working
> +	 * down to the target level. This ensures pages are recursively split
> +	 * all the way to the target level. There's no need to split pages
> +	 * already at the target level.
> +	 */
> +	for (level = KVM_MAX_HUGEPAGE_LEVEL; level > target_level; level--) {

Unnecessary braces.
> +		slot_handle_level_range(kvm, slot,
> +					nested_mmu_try_split_huge_pages,
> +					level, level, start, end - 1,
> +					true, false);

IMO it's worth running over by 4 chars to drop 2 lines:

	for (level = KVM_MAX_HUGEPAGE_LEVEL; level > target_level; level--)
		slot_handle_level_range(kvm, slot, nested_mmu_try_split_huge_pages,
					level, level, start, end - 1, true, false);
> +	}
> +}
> +
>  /* Must be called with the mmu_lock held in write-mode. */

Add a lockdep assertion, not a comment.

>  void kvm_mmu_try_split_huge_pages(struct kvm *kvm,
>  				   const struct kvm_memory_slot *memslot,
>  				   u64 start, u64 end,
>  				   int target_level)
>  {
> -	if (is_tdp_mmu_enabled(kvm))
> -		kvm_tdp_mmu_try_split_huge_pages(kvm, memslot, start, end,
> -						 target_level, false);
> +	if (!is_tdp_mmu_enabled(kvm))
> +		return;
> +
> +	kvm_tdp_mmu_try_split_huge_pages(kvm, memslot, start, end, target_level,
> +					 false);
> +
> +	if (kvm_memslots_have_rmaps(kvm))
> +		kvm_nested_mmu_try_split_huge_pages(kvm, memslot, start, end,
> +						    target_level);
>  
>  	/*
>  	 * A TLB flush is unnecessary at this point for the same resons as in
> @@ -6051,10 +6304,19 @@ void kvm_mmu_slot_try_split_huge_pages(struct kvm *kvm,
>  	u64 start = memslot->base_gfn;
>  	u64 end = start + memslot->npages;
>  
> -	if (is_tdp_mmu_enabled(kvm)) {
> -		read_lock(&kvm->mmu_lock);
> -		kvm_tdp_mmu_try_split_huge_pages(kvm, memslot, start, end, target_level, true);
> -		read_unlock(&kvm->mmu_lock);
> +	if (!is_tdp_mmu_enabled(kvm))
> +		return;
> +
> +	read_lock(&kvm->mmu_lock);
> +	kvm_tdp_mmu_try_split_huge_pages(kvm, memslot, start, end, target_level,
> +					 true);

Eh, let this poke out.

> +	read_unlock(&kvm->mmu_lock);
> +
> +	if (kvm_memslots_have_rmaps(kvm)) {
> +		write_lock(&kvm->mmu_lock);
> +		kvm_nested_mmu_try_split_huge_pages(kvm, memslot, start, end,
> +						    target_level);
> +		write_unlock(&kvm->mmu_lock);

Super duper nit: all other flows do rmaps first, than TDP MMU.  Might as well keep
that ordering here, otherwise it suggests there's a reason to be different.

>  	}
>  
>  	/*
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index ab336f7c82e4..e123e24a130f 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -12161,6 +12161,12 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
>  		 * page faults will create the large-page sptes.
>  		 */
>  		kvm_mmu_zap_collapsible_sptes(kvm, new);
> +
> +		/*
> +		 * Free any memory left behind by eager page splitting. Ignore
> +		 * the module parameter since userspace might have changed it.
> +		 */
> +		free_split_caches(kvm);
>  	} else {
>  		/*
>  		 * Initially-all-set does not require write protecting any page,
> -- 
> 2.36.0.rc2.479.g8af0fa9b8e-goog
> 
