Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 193495F360E
	for <lists+kvm@lfdr.de>; Mon,  3 Oct 2022 21:05:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbiJCTFs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Oct 2022 15:05:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbiJCTFp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Oct 2022 15:05:45 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BAE93F1DC
        for <kvm@vger.kernel.org>; Mon,  3 Oct 2022 12:05:44 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id c3so6116180pfb.12
        for <kvm@vger.kernel.org>; Mon, 03 Oct 2022 12:05:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=h2jYlCgDQ5WlHamVx9ZKLzzcBp2fqo6hIoj7oWyUv8s=;
        b=kJV2amsfSkuEta5OkZ4cFpWzh0OjgiHvEGrhvcwV+MMyWDGRCO8rmsHQlj9lLUS9Z+
         eRz668HfYhub0e7JMC7oAucnGucMY/EZxhzLs5nYDBLub2YEsZqRYv4gzgyu5jV1VUeF
         qv1pbJYmMdeJN6fRai6x390Bl90qzi6ViPVjL9qazlG4YkbxAznnnRPmDc3XUdMlU09J
         +Bvw0kC5yB4FnnIokprlQUlVr7FG6g8gjZ9xtsf9wOQiKOgE335CfYlsMBVn5w5RJDvl
         BoHDN0ixvtat54PalxFOMqQV0ygEzZ3wB1VbUva/0ErP/kGOXAfTAL/GQtCp9UL6bPv0
         brRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=h2jYlCgDQ5WlHamVx9ZKLzzcBp2fqo6hIoj7oWyUv8s=;
        b=1XJczu7ryQOmBbQ00Gml5GwhXnU39Zq69ap8zdMiXuPnFIzevnRkPZdJRd2Lg0NgDW
         IL596hhJ6ZbsRjc0SIGsh7ORcjUJ+tNJGa98c0CgyDpQKldYH7MLTmXk6kKdOd/3XU55
         Dca48VS8jC5YZbbRxVO8xwIOEC85EvOf9IZcNzF3KnFHFIjMn5ONbtSzxqvtkj3/jBTs
         b71G8D+cM5ZyPgVwLZaaLGp04A7Jcw2A6EIXY7vZuts+4k7j70Aj+hO5BTemNfq57hW3
         8XHXOE/OvtEcjP2BMEUx3hREh+RszBSzrMnPObEIJWlHX5p39kwCaKHSEgFFU9kLralu
         /D2g==
X-Gm-Message-State: ACrzQf0JHBl3FaEC+wEx5T+yyRqdvso8hJdPyovoIGPsL8gMKMZUCUMa
        KZaiArCcUsAS8nrG/6urVoY=
X-Google-Smtp-Source: AMsMyM4Q7Yh9qTYXt5cY501mvpbG5NaE9uqYGdVqhHyn5THE573Xxhywaz7fnO2Ta2ncj4HtToEEwA==
X-Received: by 2002:a62:190e:0:b0:561:a818:41bb with SMTP id 14-20020a62190e000000b00561a81841bbmr2695198pfz.50.1664823944017;
        Mon, 03 Oct 2022 12:05:44 -0700 (PDT)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id x12-20020a170902ec8c00b00172fc5b0764sm7644267plg.270.2022.10.03.12.05.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Oct 2022 12:05:43 -0700 (PDT)
Date:   Mon, 3 Oct 2022 12:05:42 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Kai Huang <kai.huang@intel.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        Peter Xu <peterx@redhat.com>
Subject: Re: [PATCH v3 03/10] KVM: x86/mmu: Grab mmu_invalidate_seq in
 kvm_faultin_pfn()
Message-ID: <20221003190542.GC2414580@ls.amr.corp.intel.com>
References: <20220921173546.2674386-1-dmatlack@google.com>
 <20220921173546.2674386-4-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220921173546.2674386-4-dmatlack@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 21, 2022 at 10:35:39AM -0700,
David Matlack <dmatlack@google.com> wrote:

> Grab mmu_invalidate_seq in kvm_faultin_pfn() and stash it in struct
> kvm_page_fault. The eliminates duplicate code and reduces the amount of
> parameters needed for is_page_fault_stale().
> 
> Preemptively split out __kvm_faultin_pfn() to a separate function for
> use in subsequent commits.
> 
> No functional change intended.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c          | 21 ++++++++++++---------
>  arch/x86/kvm/mmu/mmu_internal.h |  1 +
>  arch/x86/kvm/mmu/paging_tmpl.h  |  6 +-----
>  3 files changed, 14 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index dd261cd2ad4e..31b835d20762 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4129,7 +4129,7 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
>  	kvm_mmu_do_page_fault(vcpu, work->cr2_or_gpa, 0, true);
>  }
>  
> -static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> +static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>  {
>  	struct kvm_memory_slot *slot = fault->slot;
>  	bool async;
> @@ -4185,12 +4185,20 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>  	return RET_PF_CONTINUE;
>  }
>  
> +static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> +{
> +	fault->mmu_seq = vcpu->kvm->mmu_invalidate_seq;
> +	smp_rmb();
> +
> +	return __kvm_faultin_pfn(vcpu, fault);
> +}
> +
>  /*
>   * Returns true if the page fault is stale and needs to be retried, i.e. if the
>   * root was invalidated by a memslot update or a relevant mmu_notifier fired.
>   */
>  static bool is_page_fault_stale(struct kvm_vcpu *vcpu,
> -				struct kvm_page_fault *fault, int mmu_seq)
> +				struct kvm_page_fault *fault)
>  {
>  	struct kvm_mmu_page *sp = to_shadow_page(vcpu->arch.mmu->root.hpa);
>  
> @@ -4210,14 +4218,12 @@ static bool is_page_fault_stale(struct kvm_vcpu *vcpu,
>  		return true;
>  
>  	return fault->slot &&
> -	       mmu_invalidate_retry_hva(vcpu->kvm, mmu_seq, fault->hva);
> +	       mmu_invalidate_retry_hva(vcpu->kvm, fault->mmu_seq, fault->hva);
>  }
>  
>  static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>  {
>  	bool is_tdp_mmu_fault = is_tdp_mmu(vcpu->arch.mmu);
> -
> -	unsigned long mmu_seq;
>  	int r;
>  
>  	fault->gfn = fault->addr >> PAGE_SHIFT;
> @@ -4234,9 +4240,6 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
>  	if (r)
>  		return r;
>  
> -	mmu_seq = vcpu->kvm->mmu_invalidate_seq;
> -	smp_rmb();
> -
>  	r = kvm_faultin_pfn(vcpu, fault);
>  	if (r != RET_PF_CONTINUE)
>  		return r;
> @@ -4252,7 +4255,7 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
>  	else
>  		write_lock(&vcpu->kvm->mmu_lock);
>  
> -	if (is_page_fault_stale(vcpu, fault, mmu_seq))
> +	if (is_page_fault_stale(vcpu, fault))
>  		goto out_unlock;
>  
>  	r = make_mmu_pages_available(vcpu);
> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> index 582def531d4d..1c0a1e7c796d 100644
> --- a/arch/x86/kvm/mmu/mmu_internal.h
> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> @@ -221,6 +221,7 @@ struct kvm_page_fault {
>  	struct kvm_memory_slot *slot;
>  
>  	/* Outputs of kvm_faultin_pfn.  */
> +	unsigned long mmu_seq;
>  	kvm_pfn_t pfn;
>  	hva_t hva;
>  	bool map_writable;
> diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
> index 39e0205e7300..98f4abce4eaf 100644
> --- a/arch/x86/kvm/mmu/paging_tmpl.h
> +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> @@ -791,7 +791,6 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
>  {
>  	struct guest_walker walker;
>  	int r;
> -	unsigned long mmu_seq;
>  	bool is_self_change_mapping;
>  
>  	pgprintk("%s: addr %lx err %x\n", __func__, fault->addr, fault->error_code);
> @@ -838,9 +837,6 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
>  	else
>  		fault->max_level = walker.level;
>  
> -	mmu_seq = vcpu->kvm->mmu_invalidate_seq;
> -	smp_rmb();
> -
>  	r = kvm_faultin_pfn(vcpu, fault);
>  	if (r != RET_PF_CONTINUE)
>  		return r;
> @@ -871,7 +867,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
>  	r = RET_PF_RETRY;
>  	write_lock(&vcpu->kvm->mmu_lock);
>  
> -	if (is_page_fault_stale(vcpu, fault, mmu_seq))
> +	if (is_page_fault_stale(vcpu, fault))
>  		goto out_unlock;
>  
>  	r = make_mmu_pages_available(vcpu);
> -- 
> 2.37.3.998.g577e59143f-goog
> 

Reviewed-by: Isaku Yamahata <isaku.yamahata@intel.com>
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
