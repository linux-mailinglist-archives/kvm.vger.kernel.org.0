Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3556E486B5F
	for <lists+kvm@lfdr.de>; Thu,  6 Jan 2022 21:45:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243950AbiAFUpI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jan 2022 15:45:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243932AbiAFUpH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jan 2022 15:45:07 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94D8DC061245
        for <kvm@vger.kernel.org>; Thu,  6 Jan 2022 12:45:07 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id 205so3545835pfu.0
        for <kvm@vger.kernel.org>; Thu, 06 Jan 2022 12:45:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7/ai4b4i8Mwt7TXVmJMPm32zrO362uT5IUj043IFmng=;
        b=aSjR/3fbZRwqkFB/Df5Xc1B8BNM3cq94FATE/ahRIGWjiU3salOuQd5MFWEBFyR7S9
         p+BsDiYGlpZbSuBJ7KZ3QVj3wTAAtaEingnWIt2KTcZIjFPvej2tjVfgST3q8dTnSZL5
         RjlMCxTonM9PcWNSS+xInh/HVFztdcndMb7ZKuGsdQN2N2nYsTJgAg+uTiDr7HGJIcYz
         WQGzl/+jweXUlHZRQAwyaYbnX6gO2ASGxoS6i7hY/bZt2rbi9BNb0vBMiVCT5K1Me0wW
         mnWp5cD/ld7Phngy0HBsC1VwBRqsfR6zo/i4dHNs0efzwNgm46ugNZ8/koR7a+ou64KB
         787A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7/ai4b4i8Mwt7TXVmJMPm32zrO362uT5IUj043IFmng=;
        b=A2XtOnTnCV+w8cDF5hBZ/r5xzO6tUuC2zIL0SsCc7+tPm0DEnl1+jiJWqDEPXx+GcJ
         5gjAsxHAZ6QO7PWVuQhvlmK9MevMgvrar97/8JDGNrJSquw9QFyQ8QVjflUihh46Pk/O
         aLQI6s0rNebWdw8PxRwHFqebbiBSwGtR1j7je0j4w734vO2bJumzgJEPOSD/6OScOmIr
         SzJ0Bp77MJXtaDeLHhbERUxfYF+9frWpoxmxHHjSnkTdU3C0co7y0juTQ1DTufYmBJxq
         Wr5J9nHuzTM8aGUsjb5WEwn9WcrJ5Dy0PsESk3Sl49128b2QVOHh8CleucTWSFIWvqlB
         XZvw==
X-Gm-Message-State: AOAM533fNLqBJ3WAKIfOlIQhFVB8D9vRf64z8BKUxDVyejP/fWyZdhVv
        4OmD4h+oJIorKylE7OpR+jI3RQ==
X-Google-Smtp-Source: ABdhPJxM9KN665w1Hpn+rTDPfoFcfmi6i8OaXUqhopfV8ImGR/GMnMGJzLFGoNjc+SWbUPB8eiGJDg==
X-Received: by 2002:a63:eb42:: with SMTP id b2mr53309696pgk.393.1641501906893;
        Thu, 06 Jan 2022 12:45:06 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id f15sm3153264pjt.18.2022.01.06.12.45.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jan 2022 12:45:06 -0800 (PST)
Date:   Thu, 6 Jan 2022 20:45:03 +0000
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
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        "Nikunj A . Dadhania" <nikunj@amd.com>
Subject: Re: [PATCH v1 07/13] KVM: x86/mmu: Derive page role from parent
Message-ID: <YddUz+SanLUgi+jd@google.com>
References: <20211213225918.672507-1-dmatlack@google.com>
 <20211213225918.672507-8-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211213225918.672507-8-dmatlack@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Please include "TDP MMU" somewhere in the shortlog.  It's a nice to have, e.g. not
worth forcing if there's more interesting info to put in the shortlog, but in this
case there are plenty of chars to go around.  E.g.

  KVM: x86/mmu: Derive page role for TDP MMU shadow pages from parent

On Mon, Dec 13, 2021, David Matlack wrote:
> Derive the page role from the parent shadow page, since the only thing
> that changes is the level. This is in preparation for eagerly splitting
> large pages during VM-ioctls which does not have access to the vCPU

s/does/do since VM-ioctls is plural.

> MMU context.
> 
> No functional change intended.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 43 ++++++++++++++++++++------------------
>  1 file changed, 23 insertions(+), 20 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 2fb2d7677fbf..582d9a798899 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -157,23 +157,8 @@ static struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
>  		if (kvm_mmu_page_as_id(_root) != _as_id) {		\
>  		} else
>  
> -static union kvm_mmu_page_role page_role_for_level(struct kvm_vcpu *vcpu,
> -						   int level)
> -{
> -	union kvm_mmu_page_role role;
> -
> -	role = vcpu->arch.mmu->mmu_role.base;
> -	role.level = level;
> -	role.direct = true;
> -	role.has_4_byte_gpte = false;
> -	role.access = ACC_ALL;
> -	role.ad_disabled = !shadow_accessed_mask;
> -
> -	return role;
> -}
> -
>  static struct kvm_mmu_page *alloc_tdp_mmu_page(struct kvm_vcpu *vcpu, gfn_t gfn,
> -					       int level)
> +					       union kvm_mmu_page_role role)
>  {
>  	struct kvm_mmu_page *sp;
>  
> @@ -181,7 +166,7 @@ static struct kvm_mmu_page *alloc_tdp_mmu_page(struct kvm_vcpu *vcpu, gfn_t gfn,
>  	sp->spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);
>  	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
>  
> -	sp->role.word = page_role_for_level(vcpu, level).word;
> +	sp->role = role;
>  	sp->gfn = gfn;
>  	sp->tdp_mmu_page = true;
>  
> @@ -190,6 +175,19 @@ static struct kvm_mmu_page *alloc_tdp_mmu_page(struct kvm_vcpu *vcpu, gfn_t gfn,
>  	return sp;
>  }
>  
> +static struct kvm_mmu_page *alloc_child_tdp_mmu_page(struct kvm_vcpu *vcpu, struct tdp_iter *iter)

Newline please, this is well over 80 chars.

static struct kvm_mmu_page *alloc_child_tdp_mmu_page(struct kvm_vcpu *vcpu,
						     struct tdp_iter *iter)
> +{
> +	struct kvm_mmu_page *parent_sp;
> +	union kvm_mmu_page_role role;
> +
> +	parent_sp = sptep_to_sp(rcu_dereference(iter->sptep));
> +
> +	role = parent_sp->role;
> +	role.level--;
> +
> +	return alloc_tdp_mmu_page(vcpu, iter->gfn, role);
> +}
> +
>  hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
>  {
>  	union kvm_mmu_page_role role;
> @@ -198,7 +196,12 @@ hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
>  
>  	lockdep_assert_held_write(&kvm->mmu_lock);
>  
> -	role = page_role_for_level(vcpu, vcpu->arch.mmu->shadow_root_level);
> +	role = vcpu->arch.mmu->mmu_role.base;
> +	role.level = vcpu->arch.mmu->shadow_root_level;
> +	role.direct = true;
> +	role.has_4_byte_gpte = false;
> +	role.access = ACC_ALL;
> +	role.ad_disabled = !shadow_accessed_mask;

Hmm, so _all_ of this unnecessary, i.e. this can simply be:

	role = vcpu->arch.mmu->mmu_role.base;

Probably better to handle everything except .level in a separate prep commit.

I'm not worried about the cost, I want to avoid potential confusion as to why the
TDP MMU is apparently "overriding" these fields.
