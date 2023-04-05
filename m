Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CAD76D7506
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 09:12:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237088AbjDEHMC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 03:12:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229760AbjDEHMA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 03:12:00 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05EE746A8;
        Wed,  5 Apr 2023 00:11:52 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id 2adb3069b0e04-4e0ad2aa77fso437179e87.1;
        Wed, 05 Apr 2023 00:11:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680678710;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lXN0eHPrFIKAXmYL7hNb8AEUq+GfApMvTFxs8P5lyfM=;
        b=m383tT4jXycSx2XL7dgRY61oBIzj9qKwVWbuqITf+XOqN0XJTc7z+ieOiRvsIz6EzU
         yiHZJvlzTF511aJSQtzDLE+2WbQAa+FfWWptXrgyy5kcFxghLgvxnA35iBc3zGGgvR/o
         0LmBlJXQnmig9FEPXwTk4EBBQ9/K/R2oKJmYVu1BxeF+dzKQbTRLvgMeAAltqAjUJ0uF
         FFHcZU2z0F0OjCyfFaKRtPf8SD7PQsf/yChkxwTwGFW7vXTX/F/N31+5lCQS9DUTGl3q
         0RxAGgPXUqm5A90Ys8KMVNJ/ul9bflu3fQkypssU1czZ124L0ZY4mSxuiOgPxPDP6zhD
         LPCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680678710;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lXN0eHPrFIKAXmYL7hNb8AEUq+GfApMvTFxs8P5lyfM=;
        b=2kRk1pb+eO8O1izjRfbYaLa4Z0DcAru4zggo37of7lVSozc24cQ0UG5ipnrBfUylQF
         mCx3j2BSuzf/2nx4USLnNG+a8GY7+nPhuEB0SjiavvAWQsPRrimwjz8KvSaTgjLb1NqU
         UeL4rSNNy3MqfLFcRvLTcnmygk6AXpYtti2zWhrEMKm+oojnpGaYUYSJoc6TUojnbgop
         xj6MULAXrlkwjGOQNkD7z5YGmQh6FJLdjZeJDplCVGiXNfnFzB7N3wjF6I9eI5O/gQSE
         DOeJNeQ8Fv9h7tJNSYf+0Zy38Ids2839wPkQ2SQwPh+RCpqa/93WHvc/pQFEEzox3Cxz
         1hHw==
X-Gm-Message-State: AAQBX9fO+1cpmKcDIL9deJdXWnVosJO5NI3IZO4hqIBIpULF6SSf4hF/
        BTDaXB9gmq1oW1bcLB4BGMM=
X-Google-Smtp-Source: AKy350bhwDS0Sk3DCI5XYPr9WXROSel+P5cnjbbpR+bPJ/NWmF1cXtUAAUD2LUFUyzTLYiGImWow8w==
X-Received: by 2002:ac2:5097:0:b0:4e0:2e20:b663 with SMTP id f23-20020ac25097000000b004e02e20b663mr563970lfm.6.1680678710141;
        Wed, 05 Apr 2023 00:11:50 -0700 (PDT)
Received: from localhost (88-115-161-74.elisa-laajakaista.fi. [88.115.161.74])
        by smtp.gmail.com with ESMTPSA id v14-20020ac2560e000000b004e8011cbaa0sm2674708lfd.111.2023.04.05.00.11.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 00:11:50 -0700 (PDT)
Date:   Wed, 5 Apr 2023 10:11:21 +0300
From:   Zhi Wang <zhi.wang.linux@gmail.com>
To:     isaku.yamahata@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>
Subject: Re: [PATCH v13 030/113] KVM: Allow page-sized MMU caches to be
 initialized with custom 64-bit values
Message-ID: <20230405101121.00000c80.zhi.wang.linux@gmail.com>
In-Reply-To: <c940d56d28ed08e392d87fe00e12dd4fb16e8a3e.1678643052.git.isaku.yamahata@intel.com>
References: <cover.1678643051.git.isaku.yamahata@intel.com>
        <c940d56d28ed08e392d87fe00e12dd4fb16e8a3e.1678643052.git.isaku.yamahata@intel.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 12 Mar 2023 10:55:54 -0700
isaku.yamahata@intel.com wrote:

> From: Sean Christopherson <seanjc@google.com>
> 
> Add support to MMU caches for initializing a page with a custom 64-bit
> value, e.g. to pre-fill an entire page table with non-zero PTE values.
> The functionality will be used by x86 to support Intel's TDX, which needs
> to set bit 63 in all non-present PTEs in order to prevent !PRESENT page
> faults from getting reflected into the guest (Intel's EPT Violation #VE
> architecture made the less than brilliant decision of having the per-PTE
> behavior be opt-out instead of opt-in).
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Your Sighned-off-by is required as well.

> ---
>  include/linux/kvm_types.h |  1 +
>  virt/kvm/kvm_main.c       | 16 ++++++++++++++--
>  2 files changed, 15 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
> index 2728d49bbdf6..7c2b9332b7c5 100644
> --- a/include/linux/kvm_types.h
> +++ b/include/linux/kvm_types.h
> @@ -94,6 +94,7 @@ struct kvm_mmu_memory_cache {
>  	int nobjs;
>  	gfp_t gfp_zero;
>  	gfp_t gfp_custom;
> +	u64 init_value;
>  	struct kmem_cache *kmem_cache;
>  	int capacity;
>  	void **objects;
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index f8495e27d210..87400796df6e 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -381,12 +381,17 @@ static void kvm_flush_shadow_all(struct kvm *kvm)
>  static inline void *mmu_memory_cache_alloc_obj(struct kvm_mmu_memory_cache *mc,
>  					       gfp_t gfp_flags)
>  {
> +	void *page;
> +
>  	gfp_flags |= mc->gfp_zero;
>  
>  	if (mc->kmem_cache)
>  		return kmem_cache_alloc(mc->kmem_cache, gfp_flags);
> -	else
> -		return (void *)__get_free_page(gfp_flags);
> +
> +	page = (void *)__get_free_page(gfp_flags);
> +	if (page && mc->init_value)
> +		memset64(page, mc->init_value, PAGE_SIZE / sizeof(mc->init_value));
> +	return page;
>  }
>  
>  int __kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int capacity, int min)
> @@ -401,6 +406,13 @@ int __kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int capacity,
>  		if (WARN_ON_ONCE(!capacity))
>  			return -EIO;
>  
> +		/*
> +		 * Custom init values can be used only for page allocations,
> +		 * and obviously conflict with __GFP_ZERO.
> +		 */
> +		if (WARN_ON_ONCE(mc->init_value && (mc->kmem_cache || mc->gfp_zero)))
> +			return -EIO;
> +
>  		mc->objects = kvmalloc_array(sizeof(void *), capacity, gfp);
>  		if (!mc->objects)
>  			return -ENOMEM;

