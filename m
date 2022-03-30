Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35CD94ED06B
	for <lists+kvm@lfdr.de>; Thu, 31 Mar 2022 01:51:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234200AbiC3XxJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Mar 2022 19:53:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351929AbiC3Xw6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Mar 2022 19:52:58 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7104942EE8
        for <kvm@vger.kernel.org>; Wed, 30 Mar 2022 16:51:12 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id p8so20324820pfh.8
        for <kvm@vger.kernel.org>; Wed, 30 Mar 2022 16:51:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8sYtBs4j48qpjJK702ZGcP6bcn8eUKCCXRTri6o8Pm0=;
        b=O0pU+YpCgQB3W1ICDgli4uhU2wBOxv3AyO2hjo7v7Ln2MHIOJQOD+iWvGQVxfWcYX6
         pX5TGnm9+UkWGkds48cXksPhnSnho1o8MZ+CVmHNlhqx0gocCC790es+n0LUQ8PUZH7B
         Q/6B9AAYG/IsFN055oNLYFU/S7i1EdZnkvlXpLR/h5vVSSxH/sSGV0DT2ThB0Z7+rtlr
         uTx32GZ2A1L+qKCFkeanySC76+0r96inQWECJ8w7ib/Xgo6eWN+AV/r5P5p82ouk09HV
         0jHTVbTO1LqNWrm2YwpccI2cw6EaY6UrlkP4VSC7bZt6G8Arn6sHxW9hEmGYcTEPNcrl
         2lRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8sYtBs4j48qpjJK702ZGcP6bcn8eUKCCXRTri6o8Pm0=;
        b=rBqlWQns+lJONe2GtDupbkzzIz8fvSTY4sRrgvmbldxK+KiSgv5s5ZIA1W3p+d9hPV
         7vOeLjrMI/6Gcy0uLIsyJpSfauc9m+MTQ8rpw6X80lHTEsAXJJ7N6LwvJIPRfRxDmx0m
         8iCajf3tueB61OSsUNTk2NseIHXdyPwkRO8MIlj6bpNS2wt1U8MQEKSZMjac3eC6RBHK
         pwuPo531ogMu9SNwaiQDKn48XL70lES6xHtys8FlLO15WT5AhFZODuywJUg2zs62h0Dz
         xczkSE2tZu0BuCIzV5YTtYQN+H6yuTdpD3kNJgIo5vggLm1vHlRhLgtvF5AJDy9dIKcE
         syzA==
X-Gm-Message-State: AOAM533VBh3qy2LJsVexFrJvNEDw5zmmqoVWvBmwUdaSK+sprb74OXdi
        KVRXMgAPu4TBpHy6TeRKal0KVeNs56sW8A==
X-Google-Smtp-Source: ABdhPJwJTvi89nfmVhC07A9+LmxZYpEnMumd75LEvSF1f0s6Hewqqk/2D/NG+Qh7koCts18gV9UF+g==
X-Received: by 2002:a63:368f:0:b0:398:1bfe:bdab with SMTP id d137-20020a63368f000000b003981bfebdabmr8221748pga.29.1648684271549;
        Wed, 30 Mar 2022 16:51:11 -0700 (PDT)
Received: from google.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id q9-20020a056a00088900b004e03b051040sm26642967pfj.112.2022.03.30.16.51.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Mar 2022 16:51:04 -0700 (PDT)
Date:   Wed, 30 Mar 2022 23:51:00 +0000
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: MMU: propagate alloc_workqueue failure
Message-ID: <YkTs5BU24zrw30hK@google.com>
References: <20220330165510.213111-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220330165510.213111-1-pbonzini@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 30, 2022 at 12:55:10PM -0400, Paolo Bonzini wrote:
> If kvm->arch.tdp_mmu_zap_wq cannot be created, the failure has
> to be propagated up to kvm_mmu_init_vm and kvm_arch_init_vm.
> kvm_arch_init_vm also has to undo all the initialization, so
> group all the MMU initialization code at the beginning and
> handle cleaning up of kvm_page_track_init.
> 

Fixes: 22b94c4b63eb ("KVM: x86/mmu: Zap invalidated roots via asynchronous worker")

> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  2 +-
>  arch/x86/kvm/mmu/mmu.c          | 11 +++++++++--
>  arch/x86/kvm/mmu/tdp_mmu.c      | 17 ++++++++++-------
>  arch/x86/kvm/mmu/tdp_mmu.h      |  4 ++--
>  arch/x86/kvm/x86.c              | 15 ++++++++++-----
>  5 files changed, 32 insertions(+), 17 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 0ddc2e67a731..469c7702fad9 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1584,7 +1584,7 @@ void kvm_mmu_module_exit(void);
>  
>  void kvm_mmu_destroy(struct kvm_vcpu *vcpu);
>  int kvm_mmu_create(struct kvm_vcpu *vcpu);
> -void kvm_mmu_init_vm(struct kvm *kvm);
> +int kvm_mmu_init_vm(struct kvm *kvm);
>  void kvm_mmu_uninit_vm(struct kvm *kvm);
>  
>  void kvm_mmu_after_set_cpuid(struct kvm_vcpu *vcpu);
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 51671cb34fb6..857ba93b5c92 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -5768,17 +5768,24 @@ static void kvm_mmu_invalidate_zap_pages_in_memslot(struct kvm *kvm,
>  	kvm_mmu_zap_all_fast(kvm);
>  }
>  
> -void kvm_mmu_init_vm(struct kvm *kvm)
> +int kvm_mmu_init_vm(struct kvm *kvm)
>  {
>  	struct kvm_page_track_notifier_node *node = &kvm->arch.mmu_sp_tracker;
> +	int r;
>  
> +	INIT_LIST_HEAD(&kvm->arch.active_mmu_pages);
> +	INIT_LIST_HEAD(&kvm->arch.zapped_obsolete_pages);
> +	INIT_LIST_HEAD(&kvm->arch.lpage_disallowed_mmu_pages);

I agree with moving these but that should probably be done in a separate
commit.

>  	spin_lock_init(&kvm->arch.mmu_unsync_pages_lock);
>  
> -	kvm_mmu_init_tdp_mmu(kvm);
> +	r = kvm_mmu_init_tdp_mmu(kvm);
> +	if (r < 0)
> +		return r;
>  
>  	node->track_write = kvm_mmu_pte_write;
>  	node->track_flush_slot = kvm_mmu_invalidate_zap_pages_in_memslot;
>  	kvm_page_track_register_notifier(kvm, node);
> +	return 0;
>  }
>  
>  void kvm_mmu_uninit_vm(struct kvm *kvm)
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index e7e7876251b3..d7c112a29fe9 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -14,21 +14,24 @@ static bool __read_mostly tdp_mmu_enabled = true;
>  module_param_named(tdp_mmu, tdp_mmu_enabled, bool, 0644);
>  
>  /* Initializes the TDP MMU for the VM, if enabled. */
> -bool kvm_mmu_init_tdp_mmu(struct kvm *kvm)
> +int kvm_mmu_init_tdp_mmu(struct kvm *kvm)
>  {
> +	struct workqueue_struct *wq;
> +
>  	if (!tdp_enabled || !READ_ONCE(tdp_mmu_enabled))
> -		return false;
> +		return 0;
> +
> +	wq = alloc_workqueue("kvm", WQ_UNBOUND|WQ_MEM_RECLAIM|WQ_CPU_INTENSIVE, 0);
> +	if (IS_ERR(wq))
> +		return PTR_ERR(wq);
>  
>  	/* This should not be changed for the lifetime of the VM. */
>  	kvm->arch.tdp_mmu_enabled = true;
> -
>  	INIT_LIST_HEAD(&kvm->arch.tdp_mmu_roots);
>  	spin_lock_init(&kvm->arch.tdp_mmu_pages_lock);
>  	INIT_LIST_HEAD(&kvm->arch.tdp_mmu_pages);
> -	kvm->arch.tdp_mmu_zap_wq =
> -		alloc_workqueue("kvm", WQ_UNBOUND|WQ_MEM_RECLAIM|WQ_CPU_INTENSIVE, 0);
> -
> -	return true;
> +	kvm->arch.tdp_mmu_zap_wq = wq;

Suggest moving this to just after checking the return value of
alloc_workqueue().

> +	return 1;

Perhaps return 0 until we have a reason to differentiate the 2 cases.

>  }
>  
>  /* Arbitrarily returns true so that this may be used in if statements. */
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
> index 5e5ef2576c81..647926541e38 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.h
> +++ b/arch/x86/kvm/mmu/tdp_mmu.h
> @@ -72,7 +72,7 @@ u64 *kvm_tdp_mmu_fast_pf_get_last_sptep(struct kvm_vcpu *vcpu, u64 addr,
>  					u64 *spte);
>  
>  #ifdef CONFIG_X86_64
> -bool kvm_mmu_init_tdp_mmu(struct kvm *kvm);
> +int kvm_mmu_init_tdp_mmu(struct kvm *kvm);
>  void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm);
>  static inline bool is_tdp_mmu_page(struct kvm_mmu_page *sp) { return sp->tdp_mmu_page; }
>  
> @@ -93,7 +93,7 @@ static inline bool is_tdp_mmu(struct kvm_mmu *mmu)
>  	return sp && is_tdp_mmu_page(sp) && sp->root_count;
>  }
>  #else
> -static inline bool kvm_mmu_init_tdp_mmu(struct kvm *kvm) { return false; }
> +static inline int kvm_mmu_init_tdp_mmu(struct kvm *kvm) { return 0; }
>  static inline void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm) {}
>  static inline bool is_tdp_mmu_page(struct kvm_mmu_page *sp) { return false; }
>  static inline bool is_tdp_mmu(struct kvm_mmu *mmu) { return false; }
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index fe2171b11441..89b6efb7f504 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -11629,12 +11629,13 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>  
>  	ret = kvm_page_track_init(kvm);
>  	if (ret)
> -		return ret;
> +		goto out;

nit: This goto is unnecessary.

> +
> +	ret = kvm_mmu_init_vm(kvm);
> +	if (ret)
> +		goto out_page_track;
>  
>  	INIT_HLIST_HEAD(&kvm->arch.mask_notifier_list);
> -	INIT_LIST_HEAD(&kvm->arch.active_mmu_pages);
> -	INIT_LIST_HEAD(&kvm->arch.zapped_obsolete_pages);
> -	INIT_LIST_HEAD(&kvm->arch.lpage_disallowed_mmu_pages);
>  	INIT_LIST_HEAD(&kvm->arch.assigned_dev_head);
>  	atomic_set(&kvm->arch.noncoherent_dma_count, 0);
>  
> @@ -11666,10 +11667,14 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>  
>  	kvm_apicv_init(kvm);
>  	kvm_hv_init_vm(kvm);
> -	kvm_mmu_init_vm(kvm);
>  	kvm_xen_init_vm(kvm);
>  
>  	return static_call(kvm_x86_vm_init)(kvm);
> +
> +out_page_track:
> +	kvm_page_track_cleanup(kvm);
> +out:
> +	return ret;
>  }
>  
>  int kvm_arch_post_init_vm(struct kvm *kvm)
> -- 
> 2.31.1
> 
