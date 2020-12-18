Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41E092DE04A
	for <lists+kvm@lfdr.de>; Fri, 18 Dec 2020 10:12:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732864AbgLRJLs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Dec 2020 04:11:48 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:44961 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726520AbgLRJLr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 18 Dec 2020 04:11:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608282620;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mSafa2iKpPc7BWIljDih5YUhC7jXJc4sK5czMJ5uQUs=;
        b=KReYM/f96RzVU7vez+i9zt/rShosptJWwuk6bZwUhUnrNS1dIwMdFeHlacQ1Rmh/7EatjT
        0oSWUi1182WWjye/s5yDNlvpU011O7Tuqyibrqk1Y5DLaKeqMH+nUp2jNYU3HCcOWy+T2a
        DLaa+PuaNdNbIWkuVh4FJYoYgCfqmLQ=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-428-XXDAGRojOemPFiD4RVI7DA-1; Fri, 18 Dec 2020 04:10:18 -0500
X-MC-Unique: XXDAGRojOemPFiD4RVI7DA-1
Received: by mail-ej1-f71.google.com with SMTP id u15so556889ejg.17
        for <kvm@vger.kernel.org>; Fri, 18 Dec 2020 01:10:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=mSafa2iKpPc7BWIljDih5YUhC7jXJc4sK5czMJ5uQUs=;
        b=r+hm/QhSSzzoUlwnbj/tit37sibv0KP68jvnepgRgEB6fbpHC9hZwhLqsMHEjaLmvF
         HZHZpUKlGQESMwmo8sa95GrpZfBCVUJZb9Pst604QGLu9LDrPKrMu+o9n9maNNKPUQDG
         GSMAGVtmpRrExdpey2HW42cY+5meNsqUqm9AF/u7/k6r+vQBCTXoU4rg8Wwv+xFNh5QM
         YJfxuGDCqM8kLVNFWvCv9yu4vjiCaLdYd5htvJN8qpTuiz5fHBleovO7i6si7hQCPngG
         VZdBNZ5S14/Q2fLqIKpgRLsxOOJbE0RtUtv/yUDVPkdwYmoCMTI7MQ8ymTTBo6Vgpyq4
         eE+g==
X-Gm-Message-State: AOAM531hXb4rdM3fsT188/tunhTGKjfm7URSAWeZ2cnjZc5Eu31VOigv
        2Bz2aOTdzkzhzBRxOGXOw89v4rLseKh4+E1pq7d9IJcx+Cu6YMahGnhLeuyyNUcU9TUZvzssdR7
        GHqbVVU1yzdUz
X-Received: by 2002:a17:907:429d:: with SMTP id ny21mr3000479ejb.290.1608282617570;
        Fri, 18 Dec 2020 01:10:17 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw3xSZm3Yxv4Um6vmCs6roOxEe25yN6/mhZj9seqlOjpkSs6TxRvSGSisa5DH2+v3vzrX750Q==
X-Received: by 2002:a17:907:429d:: with SMTP id ny21mr3000448ejb.290.1608282617269;
        Fri, 18 Dec 2020 01:10:17 -0800 (PST)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id gt11sm5221411ejb.67.2020.12.18.01.10.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Dec 2020 01:10:16 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Richard Herbert <rherbert@sympatico.ca>
Subject: Re: [PATCH 2/4] KVM: x86/mmu: Get root level from walkers when
 retrieving MMIO SPTE
In-Reply-To: <20201218003139.2167891-3-seanjc@google.com>
References: <20201218003139.2167891-1-seanjc@google.com>
 <20201218003139.2167891-3-seanjc@google.com>
Date:   Fri, 18 Dec 2020 10:10:15 +0100
Message-ID: <87r1nntr7s.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> Get the so called "root" level from the low level shadow page table
> walkers instead of manually attempting to calculate it higher up the
> stack, e.g. in get_mmio_spte().  When KVM is using PAE shadow paging,
> the starting level of the walk, from the callers perspective, is not
> the CR3 root but rather the PDPTR "root".  Checking for reserved bits
> from the CR3 root causes get_mmio_spte() to consume uninitialized stack
> data due to indexing into sptes[] for a level that was not filled by
> get_walk().  This can result in false positives and/or negatives
> depending on what garbage happens to be on the stack.
>
> Opportunistically nuke a few extra newlines.
>
> Fixes: 95fb5b0258b7 ("kvm: x86/mmu: Support MMIO in the TDP MMU")
> Reported-by: Richard Herbert <rherbert@sympatico.ca>
> Cc: Ben Gardon <bgardon@google.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c     | 15 ++++++---------
>  arch/x86/kvm/mmu/tdp_mmu.c |  5 ++++-
>  arch/x86/kvm/mmu/tdp_mmu.h |  4 +++-
>  3 files changed, 13 insertions(+), 11 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index a48cd12c01d7..52f36c879086 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3485,16 +3485,16 @@ static bool mmio_info_in_cache(struct kvm_vcpu *vcpu, u64 addr, bool direct)
>   * Return the level of the lowest level SPTE added to sptes.
>   * That SPTE may be non-present.
>   */
> -static int get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes)
> +static int get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes, int *root_level)
>  {
>  	struct kvm_shadow_walk_iterator iterator;
>  	int leaf = -1;
>  	u64 spte;
>  
> -
>  	walk_shadow_page_lockless_begin(vcpu);
>  
> -	for (shadow_walk_init(&iterator, vcpu, addr);
> +	for (shadow_walk_init(&iterator, vcpu, addr),
> +	     *root_level = iterator.level;
>  	     shadow_walk_okay(&iterator);
>  	     __shadow_walk_next(&iterator, spte)) {
>  		leaf = iterator.level;
> @@ -3504,7 +3504,6 @@ static int get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes)
>  
>  		if (!is_shadow_present_pte(spte))
>  			break;
> -
>  	}
>  
>  	walk_shadow_page_lockless_end(vcpu);
> @@ -3517,9 +3516,7 @@ static bool get_mmio_spte(struct kvm_vcpu *vcpu, u64 addr, u64 *sptep)
>  {
>  	u64 sptes[PT64_ROOT_MAX_LEVEL];
>  	struct rsvd_bits_validate *rsvd_check;
> -	int root = vcpu->arch.mmu->shadow_root_level;
> -	int leaf;
> -	int level;
> +	int root, leaf, level;
>  	bool reserved = false;

Personal taste: I would've renamed 'root' to 'root_level' (to be
consistent with get_walk()/kvm_tdp_mmu_get_walk()) and 'level' to
e.g. 'l' as it's only being used as an interator ('i' would also do).

>  
>  	if (!VALID_PAGE(vcpu->arch.mmu->root_hpa)) {
> @@ -3528,9 +3525,9 @@ static bool get_mmio_spte(struct kvm_vcpu *vcpu, u64 addr, u64 *sptep)
>  	}
>  
>  	if (is_tdp_mmu_root(vcpu->kvm, vcpu->arch.mmu->root_hpa))
> -		leaf = kvm_tdp_mmu_get_walk(vcpu, addr, sptes);
> +		leaf = kvm_tdp_mmu_get_walk(vcpu, addr, sptes, &root);
>  	else
> -		leaf = get_walk(vcpu, addr, sptes);
> +		leaf = get_walk(vcpu, addr, sptes, &root);
>  
>  	if (unlikely(leaf < 0)) {
>  		*sptep = 0ull;
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 50cec7a15ddb..a4f9447f8327 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1148,13 +1148,16 @@ bool kvm_tdp_mmu_write_protect_gfn(struct kvm *kvm,
>   * Return the level of the lowest level SPTE added to sptes.
>   * That SPTE may be non-present.
>   */
> -int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes)
> +int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
> +			 int *root_level)
>  {
>  	struct tdp_iter iter;
>  	struct kvm_mmu *mmu = vcpu->arch.mmu;
>  	gfn_t gfn = addr >> PAGE_SHIFT;
>  	int leaf = -1;
>  
> +	*root_level = vcpu->arch.mmu->shadow_root_level;
> +
>  	tdp_mmu_for_each_pte(iter, mmu, gfn, gfn + 1) {
>  		leaf = iter.level;
>  		sptes[leaf - 1] = iter.old_spte;
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
> index 556e065503f6..cbbdbadd1526 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.h
> +++ b/arch/x86/kvm/mmu/tdp_mmu.h
> @@ -44,5 +44,7 @@ void kvm_tdp_mmu_zap_collapsible_sptes(struct kvm *kvm,
>  bool kvm_tdp_mmu_write_protect_gfn(struct kvm *kvm,
>  				   struct kvm_memory_slot *slot, gfn_t gfn);
>  
> -int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes);
> +int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
> +			 int *root_level);
> +
>  #endif /* __KVM_X86_MMU_TDP_MMU_H */

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

