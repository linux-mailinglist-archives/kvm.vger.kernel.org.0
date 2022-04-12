Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 441024FE52A
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 17:52:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357372AbiDLPy1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 11:54:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245499AbiDLPy0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 11:54:26 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE4106005C
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 08:52:08 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id n18so17148336plg.5
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 08:52:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jdoVTAOzsUTmRWyRrILsCe/CPtH8yNrfzN0Er5FKiB4=;
        b=cpL0mFgLvc3284MRWQEYU2TjNIbJGza3TAbzfvjUJ9VLpaaeluPAPdHFE9I1D+t0c9
         R83GKfmQgrvnqVFiQxcTtMu1nVUpEMlnXXkTyezN4RjQv5z5MRHloVn2HriGkz7EyCMS
         XpKcTu8985NoirZnN54J360s7r5uUM036LQPmdgNEZn+yo8ecoIl/lOKgWqQ46+MBkaM
         tBkrnZJj39wCcfblxn92dScKQSD2BiJGwn/BdQR90Oe+0DviLwb9J5D19Zo+lVZatl1X
         oovQcwlyoE0JUHknbjaq7tTlO9SIIUhV5vDbiZb/tOaowOcEoZidSvz3W4pkL+OFduMg
         OqgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jdoVTAOzsUTmRWyRrILsCe/CPtH8yNrfzN0Er5FKiB4=;
        b=MIemF9LuAmEkjaSD1fQ/tZZsU7xcmdz9szolTXNruc7B3x+pkGItWL8kfOnr45vi1y
         FsZpepcCfB/M1bmir16RP/VRWxwm8CRr/4JYAuIRK58y24yt5y42V43/BxmnXY117awZ
         ZnZHRVXqcgHjz/E+nkJbafaY9mqRu8RY9nf4nGkGUrB4+AmPF59sVb81/TJe/m9K5vB2
         WGgteKXAVMGrJRdWNcy7DkHkXUwq5mGswtSMfuPHRUzVYkDhOqnZD+pv1FHc4XKreUDn
         VE1jHJpVnEi/Vhz+kGwpC8TF8pjpzDaPXMGvPnRGwwSUGap4jEnz3rUOddhXxRnv7aml
         nP2w==
X-Gm-Message-State: AOAM531wBZjTKIkIZ2JEF3g8wWal6J6DmIIgXui1C/2j7/LG2oRWRiI1
        2hSfnX+vBdRZHjSlCp+j/4vb0A==
X-Google-Smtp-Source: ABdhPJzKVAQ06G3dUaI/EVJi7iNndxpnOP4buUqlAiv50c9kNyF+6CfXNEIClv6w1pbMrnUCrtssmw==
X-Received: by 2002:a17:90b:3b4d:b0:1cd:3ce7:aaec with SMTP id ot13-20020a17090b3b4d00b001cd3ce7aaecmr1784143pjb.32.1649778728270;
        Tue, 12 Apr 2022 08:52:08 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id f14-20020a63380e000000b0038253c4d5casm3176405pga.36.2022.04.12.08.52.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 08:52:07 -0700 (PDT)
Date:   Tue, 12 Apr 2022 15:52:03 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Junaid Shahid <junaids@google.com>
Subject: Re: [PATCH v2 3/9] KVM: x86/mmu: Factor shadow_zero_check out of
 __make_spte
Message-ID: <YlWgIw/0v+G+G8za@google.com>
References: <20220321224358.1305530-1-bgardon@google.com>
 <20220321224358.1305530-4-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220321224358.1305530-4-bgardon@google.com>
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

On Mon, Mar 21, 2022, Ben Gardon wrote:
> In the interest of devloping a version of __make_spte that can function
> without a vCPU pointer, factor out the shadow_zero_mask to be an
> additional argument to the function.
> 
> No functional change intended.
> 
> Signed-off-by: Ben Gardon <bgardon@google.com>
> ---
>  arch/x86/kvm/mmu/spte.c | 10 ++++++----
>  arch/x86/kvm/mmu/spte.h |  2 +-
>  2 files changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
> index 931cf93c3b7e..ef2d85577abb 100644
> --- a/arch/x86/kvm/mmu/spte.c
> +++ b/arch/x86/kvm/mmu/spte.c
> @@ -94,7 +94,7 @@ bool __make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
>  		 const struct kvm_memory_slot *slot, unsigned int pte_access,
>  		 gfn_t gfn, kvm_pfn_t pfn, u64 old_spte, bool prefetch,
>  		 bool can_unsync, bool host_writable, u64 mt_mask,
> -		 u64 *new_spte)
> +		 struct rsvd_bits_validate *shadow_zero_check, u64 *new_spte)

Can we name the new param "rsvd_bits"?  As mentioned in the other patch, it's not
a pure "are these bits zero" check.

>  {
>  	int level = sp->role.level;
>  	u64 spte = SPTE_MMU_PRESENT_MASK;
> @@ -177,9 +177,9 @@ bool __make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
>  	if (prefetch)
>  		spte = mark_spte_for_access_track(spte);
>  
> -	WARN_ONCE(is_rsvd_spte(&vcpu->arch.mmu->shadow_zero_check, spte, level),
> +	WARN_ONCE(is_rsvd_spte(shadow_zero_check, spte, level),
>  		  "spte = 0x%llx, level = %d, rsvd bits = 0x%llx", spte, level,
> -		  get_rsvd_bits(&vcpu->arch.mmu->shadow_zero_check, spte, level));
> +		  get_rsvd_bits(shadow_zero_check, spte, level));
>  
>  	if ((spte & PT_WRITABLE_MASK) && kvm_slot_dirty_track_enabled(slot)) {
>  		/* Enforced by kvm_mmu_hugepage_adjust. */
> @@ -199,10 +199,12 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
>  {
>  	u64 mt_mask = static_call(kvm_x86_get_mt_mask)(vcpu, gfn,
>  						       kvm_is_mmio_pfn(pfn));
> +	struct rsvd_bits_validate *shadow_zero_check =
> +			&vcpu->arch.mmu->shadow_zero_check;
>  
>  	return __make_spte(vcpu, sp, slot, pte_access, gfn, pfn, old_spte,
>  			   prefetch, can_unsync, host_writable, mt_mask,
> -			   new_spte);
> +			   shadow_zero_check, new_spte);

I don't see any reason to snapshot the reserved bits, IMO this is much more
readable overall:

	u64 mt_mask = static_call(kvm_x86_get_mt_mask)(vcpu, gfn,
						       kvm_is_mmio_pfn(pfn));

	return __make_spte(vcpu->kvm, sp, slot, pte_access, gfn, pfn, old_spte,
			   prefetch, can_unsync, host_writable, mt_mask,
			   &vcpu->arch.mmu->shadow_zero_check, new_spte);

And it avoids propagating the shadow_zero_check naming.

> diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
> index d051f955699e..e8a051188eb6 100644
> --- a/arch/x86/kvm/mmu/spte.h
> +++ b/arch/x86/kvm/mmu/spte.h
> @@ -414,7 +414,7 @@ bool __make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
>  		 const struct kvm_memory_slot *slot, unsigned int pte_access,
>  		 gfn_t gfn, kvm_pfn_t pfn, u64 old_spte, bool prefetch,
>  		 bool can_unsync, bool host_writable, u64 mt_mask,
> -		 u64 *new_spte);
> +		 struct rsvd_bits_validate *shadow_zero_check, u64 *new_spte);
>  bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
>  	       const struct kvm_memory_slot *slot,
>  	       unsigned int pte_access, gfn_t gfn, kvm_pfn_t pfn,
> -- 
> 2.35.1.894.gb6a874cedc-goog
> 
