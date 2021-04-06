Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8E0D355FA6
	for <lists+kvm@lfdr.de>; Wed,  7 Apr 2021 01:42:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242701AbhDFXmV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Apr 2021 19:42:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232682AbhDFXmU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Apr 2021 19:42:20 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAE06C061756
        for <kvm@vger.kernel.org>; Tue,  6 Apr 2021 16:42:11 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id q10so11620689pgj.2
        for <kvm@vger.kernel.org>; Tue, 06 Apr 2021 16:42:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+e4R9WhLCCBJ4gDbadZQs4tZRpdpcvcJbhVk8v4Qqw4=;
        b=IH7b9daRloX8JtyYrDtrasOOM1rOBc3PXLwvOJgBblhR8BDkCzBON39z0P3vMQCZJG
         WGW2NBAve+ZZ5SZ/yPewgk/Gif7KDPbK+2Km8kKCrF6hwIjEQrq+iSzy+adDd5ZxQTtk
         7HdNeTuPTAI5JsoEnMJ5mu1tC7dVTU4MYjx8V5NUtzU6WqAKMh3krxfVT0xuGTz1RmRj
         iI8uCjBd1s6BSA2rfv7Rven/2nt5Arat7CeFho6tBIuqsGpUqhud91gLar5+gecB4lmI
         9gUaSaQQYHEyPoowbsq49LtxbzPQnpPr2zjX/WHMM266ODHy1MMiv9hGDTsyl0XFPsNL
         8iCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+e4R9WhLCCBJ4gDbadZQs4tZRpdpcvcJbhVk8v4Qqw4=;
        b=tGNTVVVCnVQZxgf7ctb0Kw9vxPr/m8j5Japo6jyFSwbO/xEXpWmNcoNgGpV766uVLT
         B9fXnF7xEWRCUhzjihP2beTuDataoMcm7hwkyavQMTwmn2Mx8mbaDOuIsYdBfXxCTxFi
         mFyAdv0xMVfdHhdDBwTOee/DB9AglJp6lzfOGQjY3yZ9MQwMIWDYaWxnTWt0mp2lM7Y6
         JhgP2DO4qJt+K/tX7wFsnkJKBs1aFU9WfTzhJLZPy94K3xPX5/uhiCtVC7DFOmkQHaEq
         MkpwDZ5pEOd3PNUyC133a03qnkbgb+l3lKR8HNH7PApPNULT7N7sl0HjE/tkb4YcVuYh
         IEqg==
X-Gm-Message-State: AOAM531JcFAI4CBBSj4kyQcADBZkgYevTnEdo4KrF2OilMmSpUQTxNcN
        XSLni3/drkjvg9AS2nHthbgFOXuIHyZQkQ==
X-Google-Smtp-Source: ABdhPJxnQBZeI+TY4AQhCk23FZRTQIvjxcXx09uUt2hV/+SQFx0KNOLF+8Ca4jqvlf5y6r7l69cdJw==
X-Received: by 2002:a63:508:: with SMTP id 8mr603878pgf.220.1617752531098;
        Tue, 06 Apr 2021 16:42:11 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id c2sm19742305pfb.121.2021.04.06.16.42.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Apr 2021 16:42:10 -0700 (PDT)
Date:   Tue, 6 Apr 2021 23:42:06 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Keqian Zhu <zhukeqian1@huawei.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        wanghaibin.wang@huawei.com, Ben Gardon <bgardon@google.com>
Subject: Re: [RFC PATCH] KVM: x86: Support write protect huge pages lazily
Message-ID: <YGzxzsRlqouaJv6a@google.com>
References: <20200828081157.15748-1-zhukeqian1@huawei.com>
 <107696eb-755f-7807-a484-da63aad01ce4@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <107696eb-755f-7807-a484-da63aad01ce4@huawei.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

+Ben

On Tue, Apr 06, 2021, Keqian Zhu wrote:
> Hi Paolo,
> 
> I plan to rework this patch and do full test. What do you think about this idea
> (enable dirty logging for huge pages lazily)?

Ben, don't you also have something similar (or maybe the exact opposite?) in the
hopper?  This sounds very familiar, but I can't quite connect the dots that are
floating around my head...
 
> PS: As dirty log of TDP MMU has been supported, I should add more code.
> 
> On 2020/8/28 16:11, Keqian Zhu wrote:
> > Currently during enable dirty logging, if we're with init-all-set,
> > we just write protect huge pages and leave normal pages untouched,
> > for that we can enable dirty logging for these pages lazily.
> > 
> > It seems that enable dirty logging lazily for huge pages is feasible
> > too, which not only reduces the time of start dirty logging, also
> > greatly reduces side-effect on guest when there is high dirty rate.
> > 
> > (These codes are not tested, for RFC purpose :-) ).
> > 
> > Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
> > ---
> >  arch/x86/include/asm/kvm_host.h |  3 +-
> >  arch/x86/kvm/mmu/mmu.c          | 65 ++++++++++++++++++++++++++-------
> >  arch/x86/kvm/vmx/vmx.c          |  3 +-
> >  arch/x86/kvm/x86.c              | 22 +++++------
> >  4 files changed, 62 insertions(+), 31 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index 5303dbc5c9bc..201a068cf43d 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -1296,8 +1296,7 @@ void kvm_mmu_set_mask_ptes(u64 user_mask, u64 accessed_mask,
> >  
> >  void kvm_mmu_reset_context(struct kvm_vcpu *vcpu);
> >  void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
> > -				      struct kvm_memory_slot *memslot,
> > -				      int start_level);
> > +				      struct kvm_memory_slot *memslot);
> >  void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
> >  				   const struct kvm_memory_slot *memslot);
> >  void kvm_mmu_slot_leaf_clear_dirty(struct kvm *kvm,
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 43fdb0c12a5d..4b7d577de6cd 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -1625,14 +1625,45 @@ static bool __rmap_set_dirty(struct kvm *kvm, struct kvm_rmap_head *rmap_head)
> >  }
> >  
> >  /**
> > - * kvm_mmu_write_protect_pt_masked - write protect selected PT level pages
> > + * kvm_mmu_write_protect_largepage_masked - write protect selected largepages
> >   * @kvm: kvm instance
> >   * @slot: slot to protect
> >   * @gfn_offset: start of the BITS_PER_LONG pages we care about
> >   * @mask: indicates which pages we should protect
> >   *
> > - * Used when we do not need to care about huge page mappings: e.g. during dirty
> > - * logging we do not have any such mappings.
> > + * @ret: true if all pages are write protected
> > + */
> > +static bool kvm_mmu_write_protect_largepage_masked(struct kvm *kvm,
> > +				    struct kvm_memory_slot *slot,
> > +				    gfn_t gfn_offset, unsigned long mask)
> > +{
> > +	struct kvm_rmap_head *rmap_head;
> > +	bool protected, all_protected;
> > +	gfn_t start_gfn = slot->base_gfn + gfn_offset;
> > +	int i;
> > +
> > +	all_protected = true;
> > +	while (mask) {
> > +		protected = false;
> > +		for (i = PG_LEVEL_2M; i <= KVM_MAX_HUGEPAGE_LEVEL; ++i) {
> > +			rmap_head = __gfn_to_rmap(start_gfn + __ffs(mask), i, slot);
> > +			protectd |= __rmap_write_protect(kvm, rmap_head, false);
> > +		}
> > +
> > +		all_protected &= protectd;
> > +		/* clear the first set bit */
> > +		mask &= mask - 1;
> > +	}
> > +
> > +	return all_protected;
> > +}
> > +
> > +/**
> > + * kvm_mmu_write_protect_pt_masked - write protect selected PT level pages
> > + * @kvm: kvm instance
> > + * @slot: slot to protect
> > + * @gfn_offset: start of the BITS_PER_LONG pages we care about
> > + * @mask: indicates which pages we should protect
> >   */
> >  static void kvm_mmu_write_protect_pt_masked(struct kvm *kvm,
> >  				     struct kvm_memory_slot *slot,
> > @@ -1679,18 +1710,25 @@ EXPORT_SYMBOL_GPL(kvm_mmu_clear_dirty_pt_masked);
> >  
> >  /**
> >   * kvm_arch_mmu_enable_log_dirty_pt_masked - enable dirty logging for selected
> > - * PT level pages.
> > - *
> > - * It calls kvm_mmu_write_protect_pt_masked to write protect selected pages to
> > - * enable dirty logging for them.
> > - *
> > - * Used when we do not need to care about huge page mappings: e.g. during dirty
> > - * logging we do not have any such mappings.
> > + * dirty pages.
> >   */
> >  void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
> >  				struct kvm_memory_slot *slot,
> >  				gfn_t gfn_offset, unsigned long mask)
> >  {
> > +	/*
> > +	 * If we're with initial-all-set, huge pages are NOT
> > +	 * write protected when we start dirty log, so we must
> > +	 * write protect them here.
> > +	 */
> > +	if (kvm_dirty_log_manual_protect_and_init_set(kvm)) {
> > +		if (kvm_mmu_write_protect_largepage_masked(kvm, slot,
> > +					gfn_offset, mask))
> > +			return;
> > +	}
> > +
> > +	/* Then we can handle the 4K level pages */
> > +
> >  	if (kvm_x86_ops.enable_log_dirty_pt_masked)
> >  		kvm_x86_ops.enable_log_dirty_pt_masked(kvm, slot, gfn_offset,
> >  				mask);
> > @@ -5906,14 +5944,13 @@ static bool slot_rmap_write_protect(struct kvm *kvm,
> >  }
> >  
> >  void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
> > -				      struct kvm_memory_slot *memslot,
> > -				      int start_level)
> > +				      struct kvm_memory_slot *memslot)
> >  {
> >  	bool flush;
> >  
> >  	spin_lock(&kvm->mmu_lock);
> > -	flush = slot_handle_level(kvm, memslot, slot_rmap_write_protect,
> > -				start_level, KVM_MAX_HUGEPAGE_LEVEL, false);
> > +	flush = slot_handle_all_level(kvm, memslot, slot_rmap_write_protect,
> > +				      false);
> >  	spin_unlock(&kvm->mmu_lock);
> >  
> >  	/*
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index 819c185adf09..ba871c52ef8b 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -7538,8 +7538,7 @@ static void vmx_sched_in(struct kvm_vcpu *vcpu, int cpu)
> >  static void vmx_slot_enable_log_dirty(struct kvm *kvm,
> >  				     struct kvm_memory_slot *slot)
> >  {
> > -	if (!kvm_dirty_log_manual_protect_and_init_set(kvm))
> > -		kvm_mmu_slot_leaf_clear_dirty(kvm, slot);
> > +	kvm_mmu_slot_leaf_clear_dirty(kvm, slot);
> >  	kvm_mmu_slot_largepage_remove_write_access(kvm, slot);
> >  }
> >  
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index d39d6cf1d473..c31c32f1424b 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -10225,22 +10225,18 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
> >  	 * is enabled the D-bit or the W-bit will be cleared.
> >  	 */
> >  	if (new->flags & KVM_MEM_LOG_DIRTY_PAGES) {
> > +		/*
> > +		 * If we're with initial-all-set, we don't need
> > +		 * to write protect any page because they're
> > +		 * reported as dirty already.
> > +		 */
> > +		if (kvm_dirty_log_manual_protect_and_init_set(kvm))
> > +			return;
> > +
> >  		if (kvm_x86_ops.slot_enable_log_dirty) {
> >  			kvm_x86_ops.slot_enable_log_dirty(kvm, new);
> >  		} else {
> > -			int level =
> > -				kvm_dirty_log_manual_protect_and_init_set(kvm) ?
> > -				PG_LEVEL_2M : PG_LEVEL_4K;
> > -
> > -			/*
> > -			 * If we're with initial-all-set, we don't need
> > -			 * to write protect any small page because
> > -			 * they're reported as dirty already.  However
> > -			 * we still need to write-protect huge pages
> > -			 * so that the page split can happen lazily on
> > -			 * the first write to the huge page.
> > -			 */
> > -			kvm_mmu_slot_remove_write_access(kvm, new, level);
> > +			kvm_mmu_slot_remove_write_access(kvm, new);
> >  		}
> >  	} else {
> >  		if (kvm_x86_ops.slot_disable_log_dirty)
> > 
