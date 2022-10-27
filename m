Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E60F36102C7
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 22:35:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236933AbiJ0UfJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 16:35:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236370AbiJ0UfD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 16:35:03 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 494146C111
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 13:35:00 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id r61-20020a17090a43c300b00212f4e9cccdso7726379pjg.5
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 13:35:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9ayCoTb3LsKceUxgZcNk0TwTqYqq4AwkbO8gPBAZhj4=;
        b=Q9Ihh910YBWsYBrBfxxptFJKXGinmxQZrjNfFCjixaDAQgxpP3MVC1syBajdHnsKFT
         HeN3vkahpIk4emy09QBWuvxPpFJ+G1FK7gl/a7UUbRD7d85ca3rYxj2M/+jmC1LUpdoY
         zekHh2RzBLqSrVh4hG/F5nsKsUN+J4TFWpWg4eq3tOKBAOCgPiJ0Lmg9GKf7zCrbeFjj
         wes3u9RxnHt4kzrfACfmNEG+tx29njnYd4ykiY+caF/AZeViFbvr6MJhPwm01Hvgy6Ui
         fQfcP3QlB6XCLukS7nLZ6/xbPIJLboZ+/w4YxSETgG5vcamhkPymnwpSBTEUoEArsxdV
         1MMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9ayCoTb3LsKceUxgZcNk0TwTqYqq4AwkbO8gPBAZhj4=;
        b=TPk/wqekbPcY98LK9c9c/G55X0EcZCZEGeswtq1mawdygFh1fgbXCwF4Ot2fOsPJ4w
         VDLQEudVkcLS/TzyR7UYmkFeg5V4/X5UqRhXDfjUrUr9VgL2aHWQZY5lLnL0bPFqExLd
         FH5tnLUEiudMCm6gNTcGXusl2UjTl5HQ+THgc5pWXYOBNwdNqqvNwhY6mCbxDiauvO7U
         p1lTJ3WQvSa9/jp1/Kuz5It1lokAWOyAF02F4a8SwFplZ1nJntK9jIj347uZ1r5anfEh
         Bc2uYK+NEizX156E/V2sONYAdWBCv0+n/1pLDc18oA8yyd+OhJLLn9OkK5JctkuTAmhD
         QW8w==
X-Gm-Message-State: ACrzQf2ZFEoz5AOkbQe8WoVXdlavqnQv18jBw2iwPQ37FPBvbsXG6CiQ
        XTv4uQROMeSF4j6UNPJeL5IoGMP7H6h2MQ==
X-Google-Smtp-Source: AMsMyM5M1ufWvQOAPGPKgX2kTBBZGj2ERWntDBoqnuvSjiXNTomsOes4vULYEWwiuZBQNlvTYePahg==
X-Received: by 2002:a17:902:8c81:b0:178:a33f:8b8f with SMTP id t1-20020a1709028c8100b00178a33f8b8fmr51818385plo.50.1666902899606;
        Thu, 27 Oct 2022 13:34:59 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id i7-20020a170902c94700b00181e55d02dcsm1616363pla.139.2022.10.27.13.34.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 13:34:59 -0700 (PDT)
Date:   Thu, 27 Oct 2022 20:34:56 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 1/2] KVM: Keep track of the number of memslots with dirty
 logging enabled
Message-ID: <Y1rrcOcUJMo/VFSK@google.com>
References: <20221027200316.2221027-1-dmatlack@google.com>
 <20221027200316.2221027-2-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221027200316.2221027-2-dmatlack@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 27, 2022, David Matlack wrote:
> Add a new field to struct kvm that keeps track of the number of memslots
> with dirty logging enabled. This will be used in a future commit to
> cheaply check if any memslot is doing dirty logging.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  include/linux/kvm_host.h |  2 ++
>  virt/kvm/kvm_main.c      | 10 ++++++++++

Why put this in common code?  I'm having a hard time coming up with a second use
case since the count isn't stable, i.e. it can't be used for anything except
scenarios like x86's NX huge page mitigation where a false negative/positive is benign.

>  2 files changed, 12 insertions(+)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 32f259fa5801..25ed8c1725ff 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -709,6 +709,8 @@ struct kvm {
>  	struct kvm_memslots __memslots[KVM_ADDRESS_SPACE_NUM][2];
>  	/* The current active memslot set for each address space */
>  	struct kvm_memslots __rcu *memslots[KVM_ADDRESS_SPACE_NUM];
> +	/* The number of memslots with dirty logging enabled. */
> +	int nr_memslots_dirty_logging;

I believe this can technically be a u16, as even with SMM KVM ensures the total
number of memslots fits in a u16.  A BUILD_BUG_ON() sanity check is probably a
good idea regardless.

>  	struct xarray vcpu_array;
>  
>  	/* Used to wait for completion of MMU notifiers.  */
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index e30f1b4ecfa5..57e4406005cd 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1641,6 +1641,9 @@ static void kvm_commit_memory_region(struct kvm *kvm,
>  				     const struct kvm_memory_slot *new,
>  				     enum kvm_mr_change change)
>  {
> +	int old_flags = old ? old->flags : 0;
> +	int new_flags = new ? new->flags : 0;

Not that it really matters, but kvm_memory_slot.flags is a u32.

>  	/*
>  	 * Update the total number of memslot pages before calling the arch
>  	 * hook so that architectures can consume the result directly.
> @@ -1650,6 +1653,13 @@ static void kvm_commit_memory_region(struct kvm *kvm,
>  	else if (change == KVM_MR_CREATE)
>  		kvm->nr_memslot_pages += new->npages;
>  
> +	if ((old_flags ^ new_flags) & KVM_MEM_LOG_DIRTY_PAGES) {
> +		if (new_flags & KVM_MEM_LOG_DIRTY_PAGES)
> +			kvm->nr_memslots_dirty_logging++;
> +		else
> +			kvm->nr_memslots_dirty_logging--;

A sanity check that KVM hasn't botched the count is probably a good idea.  E.g.
__kvm_set_memory_region() as a WARN_ON_ONCE() sanity check that KVM won't end up
underflowing nr_memslot_pages.

> +	}
> +
>  	kvm_arch_commit_memory_region(kvm, old, new, change);
>  
>  	switch (change) {
> -- 
> 2.38.1.273.g43a17bfeac-goog
> 
