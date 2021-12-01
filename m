Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A40D646564D
	for <lists+kvm@lfdr.de>; Wed,  1 Dec 2021 20:22:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245101AbhLATZ6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Dec 2021 14:25:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232671AbhLATZ4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Dec 2021 14:25:56 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99A1AC061574
        for <kvm@vger.kernel.org>; Wed,  1 Dec 2021 11:22:35 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id 137so17576597pgg.3
        for <kvm@vger.kernel.org>; Wed, 01 Dec 2021 11:22:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=cykQBNG3mId7jLMKHUCeUk87p57y0lh/UsD9vvVFphc=;
        b=fWU8RDTyU+5BLdqlwPetohRlPQPQbRIhv1YxXs8T5B0kcPBODP1abj1K0B8wGvVOVj
         +YS54wXB9drNFOVSjd/DfG6ip1lolwAcdADVR+093zCRuXos4j7mi1OAoNmE8JsxwHz/
         j/SZwwGpO5A0B9O9vv4qo3iLLhTi2uto9dnyrimykZLppjrJZGLqVzq4FRvJCkRpLdfd
         xTAT3pdzB7vyBQMg6hDVSialYHt6HBVdjYSOR742Q3cBX4HSeW89BDJjonSqyMIHOLT3
         du6uMPIFzGszbpBvHwIU6R12OW93zpGqYr4PeYv2nQbaWL+OpQGkwgX3Edd9JJO4pOwn
         TziQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=cykQBNG3mId7jLMKHUCeUk87p57y0lh/UsD9vvVFphc=;
        b=RDX9m9nDMacA646zx7W44wzlgfTkHS5EIIWi26+462awSl+vZhBeM2fOFkV7DccjQV
         BX91Gzw7uuFMCoj6RgeJUnW+NzRqbDQYDZsRFe4FoqUdcqujMB7jauv7v3FcJH9xYTWc
         mYnyAIj2pXPT18X7d2Ft7S6XjOfaKB/RU1WBXVCJcFaekFiCz6fOfetKrydefj7ogdKr
         jxzO2Sdw/jipbsJ7KnRrVsocyttC3WHMoVbrrOKEBtn+Egzzz/bRdu7Z3qilXOVNlBYG
         9i/C+gUcdMn6IhZPDwOOwcUT4jvFCUM2Te+KJa4/D9b1jh8oFxgddE09sUwe7ZMdQEMR
         vZYw==
X-Gm-Message-State: AOAM530e8jvODUQe971UpircZ0rIeWivZUlGKEz388h/tjVdx9++9YIX
        6REwU2KAO62hcJN0heBjZT5ALA==
X-Google-Smtp-Source: ABdhPJyfEmm2Ns8oaK/9Q5S0EdVkPtSvAV4Vq9AIN6wg7AVezvtpVyJ6ljcdCbXEFWvaC+K3kX2/uw==
X-Received: by 2002:a62:5215:0:b0:49f:a996:b724 with SMTP id g21-20020a625215000000b0049fa996b724mr8147153pfb.3.1638386554944;
        Wed, 01 Dec 2021 11:22:34 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id q2sm619145pfj.62.2021.12.01.11.22.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Dec 2021 11:22:34 -0800 (PST)
Date:   Wed, 1 Dec 2021 19:22:30 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Junaid Shahid <junaids@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>
Subject: Re: [RFC PATCH 13/15] KVM: x86/mmu: Split large pages during
 CLEAR_DIRTY_LOG
Message-ID: <YafLdpkoTrtyoEjy@google.com>
References: <20211119235759.1304274-1-dmatlack@google.com>
 <20211119235759.1304274-14-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211119235759.1304274-14-dmatlack@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 19, 2021, David Matlack wrote:
> When using initially-all-set, large pages are not write-protected when
> dirty logging is enabled on the memslot. Instead they are
> write-protected once userspace invoked CLEAR_DIRTY_LOG for the first
> time, and only for the specific sub-region of the memslot that userspace
> whishes to clear.
> 
> Enhance CLEAR_DIRTY_LOG to also try to split large pages prior to
> write-protecting to avoid causing write-protection faults on vCPU
> threads. This also allows userspace to smear the cost of large page
> splitting across multiple ioctls rather than splitting the entire
> memslot when not using initially-all-set.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  4 ++++
>  arch/x86/kvm/mmu/mmu.c          | 30 ++++++++++++++++++++++--------
>  2 files changed, 26 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 432a4df817ec..6b5bf99f57af 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1591,6 +1591,10 @@ void kvm_mmu_reset_context(struct kvm_vcpu *vcpu);
>  void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
>  				      const struct kvm_memory_slot *memslot,
>  				      int start_level);
> +void kvm_mmu_try_split_large_pages(struct kvm *kvm,

I would prefer we use hugepage when possible, mostly because that's the terminology
used by the kernel.  KVM is comically inconsistent, but if we make an effort to use
hugepage when adding new code, hopefully someday we'll have enough inertia to commit
fully to hugepage.

> +				   const struct kvm_memory_slot *memslot,
> +				   u64 start, u64 end,
> +				   int target_level);
>  void kvm_mmu_slot_try_split_large_pages(struct kvm *kvm,
>  					const struct kvm_memory_slot *memslot,
>  					int target_level);
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 6768ef9c0891..4e78ef2dd352 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -1448,6 +1448,12 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
>  		gfn_t start = slot->base_gfn + gfn_offset + __ffs(mask);
>  		gfn_t end = slot->base_gfn + gfn_offset + __fls(mask);
>  
> +		/*
> +		 * Try to proactively split any large pages down to 4KB so that
> +		 * vCPUs don't have to take write-protection faults.
> +		 */
> +		kvm_mmu_try_split_large_pages(kvm, slot, start, end, PG_LEVEL_4K);

This should return a value.  If splitting succeeds, there should be no hugepages
and so walking the page tables to write-protect 2M is unnecessary.  Same for the
previous patch, although skipping the write-protect path is a little less
straightforward in that case.

> +
>  		kvm_mmu_slot_gfn_write_protect(kvm, slot, start, PG_LEVEL_2M);
>  
>  		/* Cross two large pages? */
