Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06DAF486B80
	for <lists+kvm@lfdr.de>; Thu,  6 Jan 2022 21:59:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244046AbiAFU7K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jan 2022 15:59:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244010AbiAFU7J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jan 2022 15:59:09 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D38EFC061245
        for <kvm@vger.kernel.org>; Thu,  6 Jan 2022 12:59:08 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id l10-20020a17090a384a00b001b22190e075so9897165pjf.3
        for <kvm@vger.kernel.org>; Thu, 06 Jan 2022 12:59:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=m/lD8QWjKKZT6y2LYcTdyOLMYP8ZwyW0DsUC9Olabgs=;
        b=hmT55DxDsPUU9Xgt3fQCVmHY3IWVaR+ZEMLRcP4i5hpLuk8LoL2kvCuDILqJNlLaLU
         /daMgUyYIBLjBHDdcCh0AwsoDBO9QLhLrScyQJK7nhzPjqkekCk/2G8Ux+hH8POyoaq9
         PVuYNDsX9XVizoE/tWO/TNVmdcF8JqBQVfA5feuscx+nsEpnVQuiWlhMyMKUti0xkh/w
         MMVKw1uYXDGzC51ln0Jd2Yw+TubtoughzDjAb1WpVDNU/rhh1WEuQBJgceV4m6bYFF/v
         UA5s8LKbHxozWeunp6b35GDRygIOaREmvYF+4Eifr7OGgUbgvUUrtDLjTR6jKaiizLmK
         PPsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=m/lD8QWjKKZT6y2LYcTdyOLMYP8ZwyW0DsUC9Olabgs=;
        b=Vya0n2+xeVM/Yhc3iObQSRLYLtJCYSS+pSHwXPyg7n3khPslwEm9m+medegz3PCvwm
         LfQcDPOqAKEekFNuhEPa9n4IkYGsmj9kfAjVvC0gDi0ksX+sk46SrhvUAHb+ltx3VQ5S
         L1hQO72TVLCOH4Dz4im5fLVEm+wPh4d1GOrjHCNtEBunny2VZti/ftKNRmfMY96TjutA
         WtYiaY3Hclo/vsqQqqUCqltdKQ9UzynQJOHpwS3qnxhW3LGfx8iJYwk9tnDYTDlKeTHn
         29ZGTV7dqQ67kFnKJs2iDUYpj3i2RpSkR0w5gNx2woNE/zoSMOxB6VJChZ4L5OjPhT0A
         QsKQ==
X-Gm-Message-State: AOAM532Fvvi57qVYXeAagtUlwmTYqxePai9g0qvV8gg6Bm6Ac7WnxZVC
        Csi825tm5rcj81VB3BOCE5YvKAG+dRrKTw==
X-Google-Smtp-Source: ABdhPJzHgjKqm/G3lK9GqFQbPSgEg3464wZjyZK/lE+l8s1jXFNMWHhKOL+RPYi770HfuwPkxkQxNg==
X-Received: by 2002:a17:90a:1bc6:: with SMTP id r6mr12179886pjr.221.1641502748218;
        Thu, 06 Jan 2022 12:59:08 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id y13sm2452852pgi.53.2022.01.06.12.59.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jan 2022 12:59:07 -0800 (PST)
Date:   Thu, 6 Jan 2022 20:59:04 +0000
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
Subject: Re: [PATCH v1 08/13] KVM: x86/mmu: Refactor TDP MMU child page
 initialization
Message-ID: <YddYGIoTaFloeENP@google.com>
References: <20211213225918.672507-1-dmatlack@google.com>
 <20211213225918.672507-9-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211213225918.672507-9-dmatlack@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 13, 2021, David Matlack wrote:
> Separate the allocation of child pages from the initialization. This is

"from their initialization" so that it's not a dangling sentence.

> in preparation for doing page splitting outside of the vCPU fault
> context which requires a different allocation mechanism.
> 
> No functional changed intended.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 30 +++++++++++++++++++++++-------
>  1 file changed, 23 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 582d9a798899..a8354d8578f1 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -157,13 +157,18 @@ static struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
>  		if (kvm_mmu_page_as_id(_root) != _as_id) {		\
>  		} else
>  
> -static struct kvm_mmu_page *alloc_tdp_mmu_page(struct kvm_vcpu *vcpu, gfn_t gfn,
> -					       union kvm_mmu_page_role role)
> +static struct kvm_mmu_page *alloc_tdp_mmu_page_from_caches(struct kvm_vcpu *vcpu)

Hrm, this ends up being a rather poor name because the "from_kernel" variant also
allocates from a cache, it's just a different cache:

  static struct kvm_mmu_page *alloc_tdp_mmu_page_from_kernel(gfp_t gfp)
  {
	struct kvm_mmu_page *sp;

	gfp |= __GFP_ZERO;

	sp = kmem_cache_alloc(mmu_page_header_cache, gfp);
	if (!sp)
		return NULL;

	...
  }

Given that the !vcpu path is the odd one, and the only user of the from_kernel
variant is the split, maybe this?  I.e. punt on naming until another user of the
"split" variant comes along.

  static struct kvm_mmu_page *__alloc_tdp_mmu_page(struct kvm_vcpu *vcpu)

and

  static struct kvm_mmu_page *__alloc_tdp_mmu_page_for_split(gfp_t gfp)

>  {
>  	struct kvm_mmu_page *sp;
>  
>  	sp = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_page_header_cache);
>  	sp->spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);
> +
> +	return sp;
> +}
> +
> +static void init_tdp_mmu_page(struct kvm_mmu_page *sp, gfn_t gfn, union kvm_mmu_page_role role)

Newline.  I'm all in favor of running over when doing so improves readability, but
that's not the case here.

> +{
>  	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
>  
>  	sp->role = role;
> @@ -171,11 +176,9 @@ static struct kvm_mmu_page *alloc_tdp_mmu_page(struct kvm_vcpu *vcpu, gfn_t gfn,
>  	sp->tdp_mmu_page = true;
>  
>  	trace_kvm_mmu_get_page(sp, true);
> -
> -	return sp;
>  }
>  
> -static struct kvm_mmu_page *alloc_child_tdp_mmu_page(struct kvm_vcpu *vcpu, struct tdp_iter *iter)
> +static void init_child_tdp_mmu_page(struct kvm_mmu_page *child_sp, struct tdp_iter *iter)

Newline.

>  {
>  	struct kvm_mmu_page *parent_sp;
>  	union kvm_mmu_page_role role;
> @@ -185,7 +188,17 @@ static struct kvm_mmu_page *alloc_child_tdp_mmu_page(struct kvm_vcpu *vcpu, stru
>  	role = parent_sp->role;
>  	role.level--;
>  
> -	return alloc_tdp_mmu_page(vcpu, iter->gfn, role);
> +	init_tdp_mmu_page(child_sp, iter->gfn, role);
> +}
> +
> +static struct kvm_mmu_page *alloc_child_tdp_mmu_page(struct kvm_vcpu *vcpu, struct tdp_iter *iter)

Newline.

> +{
> +	struct kvm_mmu_page *child_sp;
> +
> +	child_sp = alloc_tdp_mmu_page_from_caches(vcpu);
> +	init_child_tdp_mmu_page(child_sp, iter);
> +
> +	return child_sp;
>  }
>  
>  hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
> @@ -210,7 +223,10 @@ hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
>  			goto out;
>  	}
>  
> -	root = alloc_tdp_mmu_page(vcpu, 0, role);
> +	root = alloc_tdp_mmu_page_from_caches(vcpu);
> +
> +	init_tdp_mmu_page(root, 0, role);
> +
>  	refcount_set(&root->tdp_mmu_root_count, 1);
>  
>  	spin_lock(&kvm->arch.tdp_mmu_pages_lock);
> -- 
> 2.34.1.173.g76aa8bc2d0-goog
> 
