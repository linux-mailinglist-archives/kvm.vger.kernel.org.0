Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F4896C731B
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 23:30:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231652AbjCWWaY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 18:30:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231584AbjCWWaW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 18:30:22 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9972A28215
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 15:30:18 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id p3-20020a17090a74c300b0023f69bc7a68so3536000pjl.4
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 15:30:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679610618;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=M8iG1umXx8GITdl0xgHX7j5XKjcQXd2O16pFDIPVsKQ=;
        b=ncAyECD24uLZub2yxcP8Akw4bCFiFhqS8Nh/isnkGx9xMKcMebA1fLdPeiF6Vnfs4l
         QOzM7TkDk2mYpGygUlE8JK3oR3rC6+Us2eEf8GZ+Ie38wcT2UYe5j+4B3sMjHixo3JZV
         i6me1jgkIvRPpljC4mYmEFINHqUekUuom5V2oDd0kLgl54bsXHmPHH8dGxxXH1/1PRDS
         jIIcQEH7Lti3D52psdnq39EF/6mXqtvDLLGbIb03Z1Tg5wo6sfxN2UCWUgzLNmRb+WXL
         GSW8vTNAYi8u9RHgxslmEeDLU8Cx/3AKVK9tW50haOct3Zu7gtAZsUqQ08UGYaz48xz3
         oWTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679610618;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M8iG1umXx8GITdl0xgHX7j5XKjcQXd2O16pFDIPVsKQ=;
        b=ixmg68aehmtzzPbWAk/NfyHddZ6PjVqqU36/riKElgSJE1togcw7xnJ5FBCXvq/LEN
         ffGZo62+3/MIkYAfisfeVLyd5/23MlovrHrCiZk/LZdPbZ7nyGhdu7y9VZnDcuXgH48W
         ITg/jCrL3ziKOrS4/MvWTPMHoq9FiRIAJB18rH3hCWjzUqgiwfQasnb2NQ3u9nl0N+X0
         1dHqjetDEXbFXvNQVNUvN3tSSt0iVLVP7vCtc03DgxjdpZVQwdTeoXmf4RuTJSBr8E6O
         bMkMnryKranB/fEqi2XnuvnlFiVd7jlfu5RwztizRpgFh6kpwGUhbaBUoFvAHS1RGlgY
         9Q2w==
X-Gm-Message-State: AAQBX9dJZ9KMFAQcK26UOgxl5+qLEBT9mNNB7QffW07+aVMT4ah1r1si
        IYisZARh/Ub682FzQQliAMy4fg==
X-Google-Smtp-Source: AKy350a3uQVqYGJ0hAGoyHC42qS4vaxfZILPBGnLXjRzCyXxX8WHGknaNiJe0jBwyJ1oi+kVDF1Ncw==
X-Received: by 2002:a17:903:1391:b0:1a0:48c6:3b43 with SMTP id jx17-20020a170903139100b001a048c63b43mr367591plb.37.1679610617936;
        Thu, 23 Mar 2023 15:30:17 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id y21-20020a1709029b9500b0019b0937003esm12858113plp.150.2023.03.23.15.30.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Mar 2023 15:30:17 -0700 (PDT)
Date:   Thu, 23 Mar 2023 15:30:13 -0700
From:   David Matlack <dmatlack@google.com>
To:     Vipin Sharma <vipinsh@google.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, bgardon@google.com,
        jmattson@google.com, mizhang@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Patch v4 15/18] KVM: mmu: Add NUMA node support in struct
 kvm_mmu_memory_cache{}
Message-ID: <ZBzS9WnZu9VtSVAt@google.com>
References: <20230306224127.1689967-1-vipinsh@google.com>
 <20230306224127.1689967-16-vipinsh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230306224127.1689967-16-vipinsh@google.com>
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 06, 2023 at 02:41:24PM -0800, Vipin Sharma wrote:
> Add NUMA node id variable in struct kvm_mmu_memory_cache{}. This
> variable denotes preferable NUMA node from which memory will be
> allocated under this memory cache.
> 
> Set this variable to NUMA_NO_NODE if there is no preferred node.
> 
> MIPS doesn't do any sort of initializatino of struct
> kvm_mmu_memory_cache{}. Keep things similar in MIPS by setting gfp_zero
> to 0 as INIT_KVM_MMU_MEMORY_CACHE() will initialize it to __GFP_ZERO.
> 
> "node" cannot be left as 0, as 0 is a valid NUMA node value.
> 
> Signed-off-by: Vipin Sharma <vipinsh@google.com>
> ---
>  arch/mips/kvm/mips.c      | 3 +++
>  include/linux/kvm_types.h | 3 +++
>  2 files changed, 6 insertions(+)
> 
> diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
> index 36c8991b5d39..5ec5ce919918 100644
> --- a/arch/mips/kvm/mips.c
> +++ b/arch/mips/kvm/mips.c
> @@ -294,6 +294,9 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>  		     HRTIMER_MODE_REL);
>  	vcpu->arch.comparecount_timer.function = kvm_mips_comparecount_wakeup;
>  
> +	INIT_KVM_MMU_MEMORY_CACHE(&vcpu->arch.mmu_page_cache);
> +	vcpu->arch.mmu_page_cache.gfp_zero = 0;

Oh MIPS is here. Why isn't MIPS covered in the previous commits?

> +
>  	/*
>  	 * Allocate space for host mode exception handlers that handle
>  	 * guest mode exits
> diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
> index 5da7953532ce..b2a405c8e629 100644
> --- a/include/linux/kvm_types.h
> +++ b/include/linux/kvm_types.h
> @@ -97,10 +97,13 @@ struct kvm_mmu_memory_cache {
>  	struct kmem_cache *kmem_cache;
>  	int capacity;
>  	void **objects;
> +	/* Preferred NUMA node of memory allocation. */
> +	int node;
>  };
>  
>  #define KVM_MMU_MEMORY_CACHE_INIT() {	\
>  	.gfp_zero = __GFP_ZERO,		\
> +	.node = NUMA_NO_NODE,		\
>  }
>  
>  #define KVM_MMU_MEMORY_CACHE(_name) \
> -- 
> 2.40.0.rc0.216.gc4246ad0f0-goog
> 
