Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF76A2DE057
	for <lists+kvm@lfdr.de>; Fri, 18 Dec 2020 10:21:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732846AbgLRJUP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Dec 2020 04:20:15 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20710 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732751AbgLRJUP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 18 Dec 2020 04:20:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608283128;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ejcHzuD9fFPSUG7/hU65XXRSqtWaCKdWCMMhWat4xMU=;
        b=iC6R/RP7TzoErWvZBPlF3P/T3jyt1ec09A5sGQEjgfEkP7hljYY0cB7vBPYpoJAQnQyw9Z
        unbFtcKQurEWXtUHuaxnc+PQ63pD4w2GDdXZ5+5qGxPpg9JtFDJMXnJ3oHsQIuEQbiUBRx
        r8K/FJxC8QSkScZqFCZoKv3YneaeeSs=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-41-t_-G2DINM-KMOsTFLgp-sg-1; Fri, 18 Dec 2020 04:18:46 -0500
X-MC-Unique: t_-G2DINM-KMOsTFLgp-sg-1
Received: by mail-ed1-f71.google.com with SMTP id g25so860441edu.4
        for <kvm@vger.kernel.org>; Fri, 18 Dec 2020 01:18:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=ejcHzuD9fFPSUG7/hU65XXRSqtWaCKdWCMMhWat4xMU=;
        b=uBBBQhiN8hC5heDejFBQweLbiHEk3KmMURrk+7jbXqcGuRTsmJNpyrGYTMzP83zX89
         t5uc9lFOmVjUw7A9AOM6zgC3CjbLyjn4Uc2Zo11RQ+7rxOshWdeheSzpQhAkgEOaOgGi
         0GIaMgCykV4BEpWRoBaTWZpwuVPAw//1PpkaAL8qrEQlLRSDKgc4+aZ2VhTT4zuGEzuY
         mbT8tdxzB2mbmgazv4EUqRAfhAi06R5JmL1Kt5yRz1VVowhK3PZDiJwjHq/hlOqWJ+tR
         zRCHCLLFgADk5+oQN3eMQ+sUe4vga43kcQ3ApfQ/nOiMoov3JEinc6gFrVVWDDATl7iF
         Hrcw==
X-Gm-Message-State: AOAM533P9W9xtUw1FalBgCc849hqviFvlSmKBGqW1lGdwNqUy0vi1SZh
        TJxGX07ntUJBI+fwKpp/9alchNKIBGfAe0l+/PnMRsrQ3Rc47Tpfj65EDti3YTnSxs/zO05ISi2
        /n9SkxKQlfx5U
X-Received: by 2002:a17:906:cc9c:: with SMTP id oq28mr3078138ejb.224.1608283125342;
        Fri, 18 Dec 2020 01:18:45 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzRlPQTAZK6n6UAHdwvwvC4SS1JkxSjJMpsyMSplOZqd1Lw14LdiOywycWCjjf7X9vdO2EVfA==
X-Received: by 2002:a17:906:cc9c:: with SMTP id oq28mr3078122ejb.224.1608283125176;
        Fri, 18 Dec 2020 01:18:45 -0800 (PST)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id cf17sm24352748edb.16.2020.12.18.01.18.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Dec 2020 01:18:44 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Richard Herbert <rherbert@sympatico.ca>
Subject: Re: [PATCH 3/4] KVM: x86/mmu: Use raw level to index into MMIO
 walks' sptes array
In-Reply-To: <20201218003139.2167891-4-seanjc@google.com>
References: <20201218003139.2167891-1-seanjc@google.com>
 <20201218003139.2167891-4-seanjc@google.com>
Date:   Fri, 18 Dec 2020 10:18:43 +0100
Message-ID: <87o8irtqto.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> Bump the size of the sptes array by one and use the raw level of the
> SPTE to index into the sptes array.  Using the SPTE level directly
> improves readability by eliminating the need to reason out why the level
> is being adjusted when indexing the array.  The array is on the stack
> and is not explicitly initialized; bumping its size is nothing more than
> a superficial adjustment to the stack frame.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c     | 15 +++++++--------
>  arch/x86/kvm/mmu/tdp_mmu.c |  2 +-
>  2 files changed, 8 insertions(+), 9 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 52f36c879086..4798a4472066 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3500,7 +3500,7 @@ static int get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes, int *root_level
>  		leaf = iterator.level;
>  		spte = mmu_spte_get_lockless(iterator.sptep);
>  
> -		sptes[leaf - 1] = spte;
> +		sptes[leaf] = spte;
>  
>  		if (!is_shadow_present_pte(spte))
>  			break;
> @@ -3514,7 +3514,7 @@ static int get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes, int *root_level
>  /* return true if reserved bit is detected on spte. */
>  static bool get_mmio_spte(struct kvm_vcpu *vcpu, u64 addr, u64 *sptep)
>  {
> -	u64 sptes[PT64_ROOT_MAX_LEVEL];
> +	u64 sptes[PT64_ROOT_MAX_LEVEL + 1];
>  	struct rsvd_bits_validate *rsvd_check;
>  	int root, leaf, level;
>  	bool reserved = false;
> @@ -3537,16 +3537,15 @@ static bool get_mmio_spte(struct kvm_vcpu *vcpu, u64 addr, u64 *sptep)
>  	rsvd_check = &vcpu->arch.mmu->shadow_zero_check;
>  
>  	for (level = root; level >= leaf; level--) {
> -		if (!is_shadow_present_pte(sptes[level - 1]))
> +		if (!is_shadow_present_pte(sptes[level]))
>  			break;
>  		/*
>  		 * Use a bitwise-OR instead of a logical-OR to aggregate the
>  		 * reserved bit and EPT's invalid memtype/XWR checks to avoid
>  		 * adding a Jcc in the loop.
>  		 */
> -		reserved |= __is_bad_mt_xwr(rsvd_check, sptes[level - 1]) |
> -			    __is_rsvd_bits_set(rsvd_check, sptes[level - 1],
> -					       level);
> +		reserved |= __is_bad_mt_xwr(rsvd_check, sptes[level]) |
> +			    __is_rsvd_bits_set(rsvd_check, sptes[level], level);
>  	}
>  
>  	if (reserved) {
> @@ -3554,10 +3553,10 @@ static bool get_mmio_spte(struct kvm_vcpu *vcpu, u64 addr, u64 *sptep)
>  		       __func__, addr);
>  		for (level = root; level >= leaf; level--)
>  			pr_err("------ spte 0x%llx level %d.\n",
> -			       sptes[level - 1], level);
> +			       sptes[level], level);
>  	}
>  
> -	*sptep = sptes[leaf - 1];
> +	*sptep = sptes[leaf];
>  
>  	return reserved;
>  }
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index a4f9447f8327..efef571806ad 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1160,7 +1160,7 @@ int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
>  
>  	tdp_mmu_for_each_pte(iter, mmu, gfn, gfn + 1) {
>  		leaf = iter.level;
> -		sptes[leaf - 1] = iter.old_spte;
> +		sptes[leaf] = iter.old_spte;
>  	}
>  
>  	return leaf;

An alretnitive solution would've been to reverse the array and fill it
like

 sptes[PT64_ROOT_MAX_LEVEL - leaf] = iter.old_spte;

but this may not reach the goal of 'improved readability' :-)

Also, we may add an MMU_DEBUG ifdef-ed check that sptes[0] remains
intact.

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

