Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2CB1457E82
	for <lists+kvm@lfdr.de>; Sat, 20 Nov 2021 13:53:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237329AbhKTM42 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 20 Nov 2021 07:56:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbhKTM42 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 20 Nov 2021 07:56:28 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96537C061574
        for <kvm@vger.kernel.org>; Sat, 20 Nov 2021 04:53:24 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id x6so42909684edr.5
        for <kvm@vger.kernel.org>; Sat, 20 Nov 2021 04:53:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=sG0JbAdTDbi3sk5bLt3gzFFkeXEbv7ZJxkojOmidfz4=;
        b=J4cyOD4EViYz3vBk0eSAryoDd8FehfSc/7arthMmWU8Gesjuts0jCYN74XMdVQnrEU
         Wq/ZBtwIGQMRBvU4eE8o54+2lj1ccEJqP03U7B/vXy16j/PeepdUZxfHGwX9eDTfmmwO
         AWR2Kv10xZPylFV3hwW9ZtzcUIY5yT1m83+Xy5UjiJSGC29sMIU2p0ADyYtFUe11FOPR
         3e7znFkJ3psxa7gMnnjbP46mzr5dJ4SiKoZGJtTtSlOvVdLevkFfllvx7hQbhAW2juSg
         BSjCFf5FfQVotwJcf/hi0+mPE76jRlmO3hzGCTJa/7tVywYFmTFNBNpiIrZqULy705qu
         FD3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=sG0JbAdTDbi3sk5bLt3gzFFkeXEbv7ZJxkojOmidfz4=;
        b=upLVk74y1000fJspHXtpKFuKH2tQXkzJ8PlrJ/iV7ivI00rcCPkvy2zKtwxPjC755L
         56hxtuo6vOjWvS8jNj2vZiPJIobjbZYxNr6D8US2O3xgRObsSEMNS5nuW693ZRcTcEs2
         pelK56qkSuNAWSlJGycsQFWtZnLvLuPHOziDMfanBjDxLeSsH/PoBuquXQwDjbLuyTMp
         tCBokLKz/mQA3oVShUBG0q9dAvOOcahYEmhU+6/Lzig8x6tENo7T+P9VP9WXoer2tPv1
         tAERmxRULU7Wl6kVkr/y6rbo9KOWqWcVCcGS5T36Cs8NU8eQBS6K/nJdT8fmbGCkonjj
         RPrw==
X-Gm-Message-State: AOAM531zXxMrPj2FFZBv/Imh9cJzTpS5HnYWGeey8mzNgigPT3J+qBrn
        yrMbH+gFnCkpkjOy+yTpri4=
X-Google-Smtp-Source: ABdhPJwHi1/t+b5yNg49VQCYkS07ljbHbQQNeALuDqPyeVhhDfh0fA6LkApgqja40cDBl1NyFliEtQ==
X-Received: by 2002:a05:6402:1e8b:: with SMTP id f11mr31110762edf.304.1637412803073;
        Sat, 20 Nov 2021 04:53:23 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id m16sm1234256edd.61.2021.11.20.04.53.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 20 Nov 2021 04:53:22 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <62bd6567-bde5-7bb3-ec73-abf0e2874706@redhat.com>
Date:   Sat, 20 Nov 2021 13:53:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [RFC PATCH 06/15] KVM: x86/mmu: Derive page role from parent
Content-Language: en-US
To:     David Matlack <dmatlack@google.com>
Cc:     kvm@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Junaid Shahid <junaids@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>
References: <20211119235759.1304274-1-dmatlack@google.com>
 <20211119235759.1304274-7-dmatlack@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211119235759.1304274-7-dmatlack@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/20/21 00:57, David Matlack wrote:
> Derive the page role from the parent shadow page, since the only thing
> that changes is the level. This is in preparation for eagerly splitting
> large pages during VM-ioctls which does not have access to the vCPU
> MMU context.
> 
> No functional change intended.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>   arch/x86/kvm/mmu/tdp_mmu.c | 43 ++++++++++++++++++++------------------
>   1 file changed, 23 insertions(+), 20 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index b70707a7fe87..1a409992a57f 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -157,23 +157,8 @@ static struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
>   		if (kvm_mmu_page_as_id(_root) != _as_id) {		\
>   		} else
>   
> -static union kvm_mmu_page_role page_role_for_level(struct kvm_vcpu *vcpu,
> -						   int level)
> -{
> -	union kvm_mmu_page_role role;
> -
> -	role = vcpu->arch.mmu->mmu_role.base;
> -	role.level = level;
> -	role.direct = true;
> -	role.gpte_is_8_bytes = true;
> -	role.access = ACC_ALL;
> -	role.ad_disabled = !shadow_accessed_mask;
> -
> -	return role;
> -}
> -
>   static struct kvm_mmu_page *alloc_tdp_mmu_page(struct kvm_vcpu *vcpu, gfn_t gfn,
> -					       int level)
> +					       union kvm_mmu_page_role role)
>   {
>   	struct kvm_mmu_memory_caches *mmu_caches;
>   	struct kvm_mmu_page *sp;
> @@ -184,7 +169,7 @@ static struct kvm_mmu_page *alloc_tdp_mmu_page(struct kvm_vcpu *vcpu, gfn_t gfn,
>   	sp->spt = kvm_mmu_memory_cache_alloc(&mmu_caches->shadow_page_cache);
>   	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
>   
> -	sp->role.word = page_role_for_level(vcpu, level).word;
> +	sp->role = role;
>   	sp->gfn = gfn;
>   	sp->tdp_mmu_page = true;
>   
> @@ -193,6 +178,19 @@ static struct kvm_mmu_page *alloc_tdp_mmu_page(struct kvm_vcpu *vcpu, gfn_t gfn,
>   	return sp;
>   }
>   
> +static struct kvm_mmu_page *alloc_child_tdp_mmu_page(struct kvm_vcpu *vcpu, struct tdp_iter *iter)
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
>   hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
>   {
>   	union kvm_mmu_page_role role;
> @@ -201,7 +199,12 @@ hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
>   
>   	lockdep_assert_held_write(&kvm->mmu_lock);
>   
> -	role = page_role_for_level(vcpu, vcpu->arch.mmu->shadow_root_level);
> +	role = vcpu->arch.mmu->mmu_role.base;
> +	role.level = vcpu->arch.mmu->shadow_root_level;
> +	role.direct = true;
> +	role.gpte_is_8_bytes = true;
> +	role.access = ACC_ALL;
> +	role.ad_disabled = !shadow_accessed_mask;

I have a similar patch for the old MMU, but it was also replacing 
shadow_root_level with shadow_root_role.  I'll see if I can adapt it to 
the TDP MMU, since the shadow_root_role is obviously the same for both.

Paolo

>   	/* Check for an existing root before allocating a new one. */
>   	for_each_tdp_mmu_root(kvm, root, kvm_mmu_role_as_id(role)) {
> @@ -210,7 +213,7 @@ hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
>   			goto out;
>   	}
>   
> -	root = alloc_tdp_mmu_page(vcpu, 0, vcpu->arch.mmu->shadow_root_level);
> +	root = alloc_tdp_mmu_page(vcpu, 0, role);
>   	refcount_set(&root->tdp_mmu_root_count, 1);
>   
>   	spin_lock(&kvm->arch.tdp_mmu_pages_lock);
> @@ -1028,7 +1031,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>   			if (is_removed_spte(iter.old_spte))
>   				break;
>   
> -			sp = alloc_tdp_mmu_page(vcpu, iter.gfn, iter.level - 1);
> +			sp = alloc_child_tdp_mmu_page(vcpu, &iter);
>   			if (!tdp_mmu_install_sp_atomic(vcpu->kvm, &iter, sp, account_nx))
>   				break;
>   		}
> 
