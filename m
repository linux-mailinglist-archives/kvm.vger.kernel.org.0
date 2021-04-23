Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C4513695EF
	for <lists+kvm@lfdr.de>; Fri, 23 Apr 2021 17:18:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243021AbhDWPTW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 11:19:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237114AbhDWPTF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Apr 2021 11:19:05 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B2C0C06174A
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 08:18:27 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id v13so11780022ple.9
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 08:18:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RRJebZVaxHqzkm5xYFuJxuwx6avqRXGA2Ewnq/B2t4g=;
        b=DWUEquz6eZmsmpLbHLdXJSR8NxTMfM4hf/a6kRnz1V1VS5NAs6IbQTJ0LGApSzMmF9
         psF4GURk+fqTYq0pKqmYDim4F6PvAq6ceNWe7EB4sIWr4QzvPHNj5FT0cYZ+nD4T0ced
         BAZKi6G9AnB35oZI6wUxnik6QM8gDDmURXaCJ1fuX6Ba/YaJafIJX0bqqYQxRI+LwUgv
         AXqhBy2w+i6kX6AYB3gDv4FDVBg386OOj/ZwXG9izJje7LtlWchHkzsSsLzsSuk5i6Gm
         gl+sa4Sa69GCjOc+jEJ/3Nw4XVJ6gAiSIcwitvq95n/cOLYufBrL1von4eXmR7Fq+dmR
         VywQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RRJebZVaxHqzkm5xYFuJxuwx6avqRXGA2Ewnq/B2t4g=;
        b=h1JWkDvPWBBpAnebHvK7S8hbd2ONBCu6auQQgyH0ruhVyfiLsHZKvwWxYnXKKLrmgI
         KNUvNLVVq3jv5CYvX5VrOcKr0EBS4HHjz5498uNEL39TyGAm06PUaIB8YwdTSAr7uV/f
         Cwrmy+X6YJBTPnKWcHU0y/RsQaIXN7I2mqVrYrwmd0m+Tk8gcxM4TP97IJ99VxWhRDGb
         6nLy8VXKO0stu/rBMLBSN88u2WmBK9SE+u5AhpZCcqGhfdLBuBisJVju/Y1WB2JLM+pu
         EzUXU2ulNM+bgXjH2eQvSzFt8kp/VBAhjktfSog5MbFDrkj+LqHBtJklPmExpVVOt5BN
         2B3Q==
X-Gm-Message-State: AOAM532G+3Tw8lmnl3ozgt5dDLI3u058XMHs/3Html+fAVUVrJWieHe5
        LzDzJbMZY1TyZw780+vpb6OE4g==
X-Google-Smtp-Source: ABdhPJzXDK2ujEd9Pl9K0qJpTeO+/RfaDkdAudeD0IMOb+Lm9JjFA3m7tSIH00mNZdVoIof0Pe6GzA==
X-Received: by 2002:a17:902:7fc9:b029:eb:4828:47e8 with SMTP id t9-20020a1709027fc9b02900eb482847e8mr4603408plb.56.1619191106491;
        Fri, 23 Apr 2021 08:18:26 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id 137sm5080242pfx.172.2021.04.23.08.18.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Apr 2021 08:18:25 -0700 (PDT)
Date:   Fri, 23 Apr 2021 15:18:22 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH v2] KVM: x86/xen: Take srcu lock when accessing
 kvm_memslots()
Message-ID: <YILlPmN0fgLA8RkJ@google.com>
References: <1619166200-9215-1-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1619166200-9215-1-git-send-email-wanpengli@tencent.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 23, 2021, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> kvm_memslots() will be called by kvm_write_guest_offset_cached() so we should 
> take the srcu lock. Let's pull the srcu lock operation from kvm_steal_time_set_preempted() 
> again to fix xen part.
> 
> Fixes: 30b5c851af7 (KVM: x86/xen: Add support for vCPU runstate information)
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
>  arch/x86/kvm/x86.c | 20 +++++++++-----------
>  1 file changed, 9 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 3bf52ba..c775d24 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4097,7 +4097,6 @@ static void kvm_steal_time_set_preempted(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_host_map map;
>  	struct kvm_steal_time *st;
> -	int idx;
>  
>  	if (!(vcpu->arch.st.msr_val & KVM_MSR_ENABLED))
>  		return;
> @@ -4105,15 +4104,9 @@ static void kvm_steal_time_set_preempted(struct kvm_vcpu *vcpu)
>  	if (vcpu->arch.st.preempted)
>  		return;
>  
> -	/*
> -	 * Take the srcu lock as memslots will be accessed to check the gfn
> -	 * cache generation against the memslots generation.
> -	 */
> -	idx = srcu_read_lock(&vcpu->kvm->srcu);
> -
>  	if (kvm_map_gfn(vcpu, vcpu->arch.st.msr_val >> PAGE_SHIFT, &map,
>  			&vcpu->arch.st.cache, true))
> -		goto out;
> +		return;
>  
>  	st = map.hva +
>  		offset_in_page(vcpu->arch.st.msr_val & KVM_STEAL_VALID_BITS);
> @@ -4121,20 +4114,25 @@ static void kvm_steal_time_set_preempted(struct kvm_vcpu *vcpu)
>  	st->preempted = vcpu->arch.st.preempted = KVM_VCPU_PREEMPTED;
>  
>  	kvm_unmap_gfn(vcpu, &map, &vcpu->arch.st.cache, true, true);
> -
> -out:
> -	srcu_read_unlock(&vcpu->kvm->srcu, idx);
>  }
>  
>  void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>  {
> +	int idx;
> +
>  	if (vcpu->preempted && !vcpu->arch.guest_state_protected)
>  		vcpu->arch.preempted_in_kernel = !static_call(kvm_x86_get_cpl)(vcpu);
>  
> +	/*
> +	 * Take the srcu lock as memslots will be accessed to check the gfn
> +	 * cache generation against the memslots generation.
> +	 */
> +	idx = srcu_read_lock(&vcpu->kvm->srcu);

Might be worth grabbing "kvm" in a local variable?  Either way:

Reviewed-by: Sean Christopherson <seanjc@google.com>

>  	if (kvm_xen_msr_enabled(vcpu->kvm))
>  		kvm_xen_runstate_set_preempted(vcpu);
>  	else
>  		kvm_steal_time_set_preempted(vcpu);
> +	srcu_read_unlock(&vcpu->kvm->srcu, idx);
>  
>  	static_call(kvm_x86_vcpu_put)(vcpu);
>  	vcpu->arch.last_host_tsc = rdtsc();
> -- 
> 2.7.4
> 
