Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07C435F3601
	for <lists+kvm@lfdr.de>; Mon,  3 Oct 2022 21:01:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229550AbiJCTBX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Oct 2022 15:01:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbiJCTBU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Oct 2022 15:01:20 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E53F2AC48
        for <kvm@vger.kernel.org>; Mon,  3 Oct 2022 12:01:20 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id gf8so8126304pjb.5
        for <kvm@vger.kernel.org>; Mon, 03 Oct 2022 12:01:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=qowFxPih2sV5NJDXGk8gZLHmTm2tmCdaGptPOJVE48o=;
        b=jkfAFsVky9Nj9fCv+gaIdpNvivTV5FBNq+bZt8kPfK05g2P3Dlla2GeoduCWZL6Q+E
         TPhU98l8s+QUGWe7KiKqCXPI2t45g8yUyDFUAYM80tS0SpfNica53ObOfH9nQCVA6xiJ
         yWBiLzhQozaO7/PGPfLqLgYnkPpzFuY4HXMoYw3jjvkwcEDS2Pocg2eDnpQQcYo5z1ox
         4W1dmuVIvpmBdJSopIbiNv6f00wGUN05cGNYse8FfMQxa4bj5sBeqpNgyCYNXje3VP+d
         jWy8WU8tN2/qq0VF7zMOS2cLrfojKtsnZ4DX8r+CWN2bC8yyKr1xAgCJCD2K2NaouW1+
         iQBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=qowFxPih2sV5NJDXGk8gZLHmTm2tmCdaGptPOJVE48o=;
        b=cFqHDVZL4LoyQAuFPGj0k5ebVh/tXU5RWspM7bUJR0kBOTSvcRw3nFcPXtSk7e0qIE
         KG7QMdcPeRRjjjOzdKn5o2MYMJUEbTK4vlH4pXxZl8zwXoBtqoOSCuw7NkGQyyNW0+Ir
         v2lB/wZgQZoaahwbKI2hdM4Y3+r1Sa0TRNZyeBjgBFhYM0ZlqxP+eECXoU9wXglwJQla
         Uec0U2gCG/6y3QJb5bHORxWahfUGHGxLe5gevpK5M5Zwm5ebVl0/YCWBticiTbrEiAYj
         9ICPDLWAakX+hYtEBmoiX0hu7HTzjpjql8yzZ+T2NRsM0ldp3LM6MbVY52+j55KKCrPO
         PUYg==
X-Gm-Message-State: ACrzQf3LAcMQgM+YwB6p3+hIt9gGoq+KinB0m//NfHWkvUPIHvzi/tvW
        QP0AqywnRDjGl2FvOnxJGKU=
X-Google-Smtp-Source: AMsMyM5390Aaf0RTwaKdPwvdas5vvrJKzXFxuwaCfRSSEuRxTRL/3AlznWyrioAIPs76WzF9UX8zag==
X-Received: by 2002:a17:902:ef83:b0:17c:a2f:1e3 with SMTP id iz3-20020a170902ef8300b0017c0a2f01e3mr18845857plb.35.1664823679535;
        Mon, 03 Oct 2022 12:01:19 -0700 (PDT)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id im23-20020a170902bb1700b001755e4278a6sm7524709plb.261.2022.10.03.12.01.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Oct 2022 12:01:19 -0700 (PDT)
Date:   Mon, 3 Oct 2022 12:01:17 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Kai Huang <kai.huang@intel.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        Peter Xu <peterx@redhat.com>
Subject: Re: [PATCH v3 02/10] KVM: x86/mmu: Move TDP MMU VM init/uninit
 behind tdp_mmu_enabled
Message-ID: <20221003190117.GB2414580@ls.amr.corp.intel.com>
References: <20220921173546.2674386-1-dmatlack@google.com>
 <20220921173546.2674386-3-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220921173546.2674386-3-dmatlack@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On Wed, Sep 21, 2022 at 10:35:38AM -0700,
David Matlack <dmatlack@google.com> wrote:

> Move kvm_mmu_{init,uninit}_tdp_mmu() behind tdp_mmu_enabled. This makes
> these functions consistent with the rest of the calls into the TDP MMU
> from mmu.c, and which is now possible since tdp_mmu_enabled is only
> modified when the x86 vendor module is loaded. i.e. It will never change
> during the lifetime of a VM.
> 
> This change also enabled removing the stub definitions for 32-bit KVM,
> as the compiler will just optimize the calls out like it does for all
> the other TDP MMU functions.
> 
> No functional change intended.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c     | 11 +++++++----
>  arch/x86/kvm/mmu/tdp_mmu.c |  6 ------
>  arch/x86/kvm/mmu/tdp_mmu.h |  7 +++----
>  3 files changed, 10 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index ccb0b18fd194..dd261cd2ad4e 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -5970,9 +5970,11 @@ int kvm_mmu_init_vm(struct kvm *kvm)
>  	INIT_LIST_HEAD(&kvm->arch.lpage_disallowed_mmu_pages);
>  	spin_lock_init(&kvm->arch.mmu_unsync_pages_lock);
>  
> -	r = kvm_mmu_init_tdp_mmu(kvm);
> -	if (r < 0)
> -		return r;
> +	if (tdp_mmu_enabled) {
> +		r = kvm_mmu_init_tdp_mmu(kvm);
> +		if (r < 0)
> +			return r;
> +	}
>  
>  	node->track_write = kvm_mmu_pte_write;
>  	node->track_flush_slot = kvm_mmu_invalidate_zap_pages_in_memslot;
> @@ -6002,7 +6004,8 @@ void kvm_mmu_uninit_vm(struct kvm *kvm)
>  
>  	kvm_page_track_unregister_notifier(kvm, node);
>  
> -	kvm_mmu_uninit_tdp_mmu(kvm);
> +	if (tdp_mmu_enabled)
> +		kvm_mmu_uninit_tdp_mmu(kvm);
>  
>  	mmu_free_vm_memory_caches(kvm);
>  }
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index e7d0f21fbbe8..08ab3596dfaa 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -15,9 +15,6 @@ int kvm_mmu_init_tdp_mmu(struct kvm *kvm)
>  {
>  	struct workqueue_struct *wq;
>  
> -	if (!tdp_mmu_enabled)
> -		return 0;
> -
>  	wq = alloc_workqueue("kvm", WQ_UNBOUND|WQ_MEM_RECLAIM|WQ_CPU_INTENSIVE, 0);
>  	if (!wq)
>  		return -ENOMEM;
> @@ -43,9 +40,6 @@ static __always_inline bool kvm_lockdep_assert_mmu_lock_held(struct kvm *kvm,
>  
>  void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
>  {
> -	if (!tdp_mmu_enabled)
> -		return;
> -
>  	/* Also waits for any queued work items.  */
>  	destroy_workqueue(kvm->arch.tdp_mmu_zap_wq);
>  
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
> index c163f7cc23ca..9d086a103f77 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.h
> +++ b/arch/x86/kvm/mmu/tdp_mmu.h
> @@ -5,6 +5,9 @@
>  
>  #include <linux/kvm_host.h>
>  
> +int kvm_mmu_init_tdp_mmu(struct kvm *kvm);
> +void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm);
> +
>  hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu);
>  
>  __must_check static inline bool kvm_tdp_mmu_get_root(struct kvm_mmu_page *root)
> @@ -66,8 +69,6 @@ u64 *kvm_tdp_mmu_fast_pf_get_last_sptep(struct kvm_vcpu *vcpu, u64 addr,
>  					u64 *spte);
>  
>  #ifdef CONFIG_X86_64
> -int kvm_mmu_init_tdp_mmu(struct kvm *kvm);
> -void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm);
>  static inline bool is_tdp_mmu_page(struct kvm_mmu_page *sp) { return sp->tdp_mmu_page; }
>  
>  static inline bool is_tdp_mmu(struct kvm_mmu *mmu)
> @@ -87,8 +88,6 @@ static inline bool is_tdp_mmu(struct kvm_mmu *mmu)
>  	return sp && is_tdp_mmu_page(sp) && sp->root_count;
>  }
>  #else
> -static inline int kvm_mmu_init_tdp_mmu(struct kvm *kvm) { return 0; }
> -static inline void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm) {}
>  static inline bool is_tdp_mmu_page(struct kvm_mmu_page *sp) { return false; }
>  static inline bool is_tdp_mmu(struct kvm_mmu *mmu) { return false; }
>  #endif
> -- 
> 2.37.3.998.g577e59143f-goog

Reviewed-by: Isaku Yamahata <isaku.yamahata@intel.com>
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
