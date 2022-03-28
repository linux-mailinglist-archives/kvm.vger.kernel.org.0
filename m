Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B535B4E9ACD
	for <lists+kvm@lfdr.de>; Mon, 28 Mar 2022 17:16:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233207AbiC1PSg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Mar 2022 11:18:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230330AbiC1PSe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Mar 2022 11:18:34 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8F151FCF8
        for <kvm@vger.kernel.org>; Mon, 28 Mar 2022 08:16:53 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id w7so10238584pfu.11
        for <kvm@vger.kernel.org>; Mon, 28 Mar 2022 08:16:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=V2BkG1eTX10cucUGmcHAn94FhLtFZhm8llsNlwvtRuc=;
        b=sALbJwx8VGCOa6mzxzDleDWU1dPFqfgqIX1UyiHh3zAj5ZCTtCKO3xjq94w2VrpetQ
         y0OlGDN2AP01yDewUz/x8/cbYm9hbsQQ7RsIAkSDsaia0hIWnniT0PPDDAg9NMxLqT7f
         CUh5MKcp8D4mUEodbmDVwDeIhz1E/LoLuUEAg/360b4C0vFGeHSOm9fHdeUV1wr2NJyf
         D4l1oUU7gaTWjmf8iToex55XptSW+KJX3nCVq3VNVumPDFyAXJrvmiPnfTWg6AKp5THL
         hN3Tbi1K4CiHHiW9fzyPr6xYQmlwrDUIYWzTSDQIl2m4MSCeIu7Wjc4IHwm43yWIdm+N
         MUEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=V2BkG1eTX10cucUGmcHAn94FhLtFZhm8llsNlwvtRuc=;
        b=Mp3HN59B1v+R5e8JorK2Y9Vk0Gu1nXF84zHEfKebGHWtaWYHhkP6c6gRCqzeUN76sD
         0OTSsd5/bJ+cVfc5pFodhayhnE+pa2p7hhzccRfIzX2Qz9KEkup0FbOBrB97gcXQpeQ3
         8nKONLzMaoczc9k0C5xjE6R/d8q/xdqvkIQgGuvU808aaApjkYk2M3p3kZuXZn7fedR5
         MhIQbhB9c0sIoN6KtjeuMnRbhfEo4v2B7CuUY5SEXK+/eJRrSA3I1N8tiW7PX2LKC9go
         eQUmCDXKjp7YyqqbmJLn9NAJRIqsZ2fuqfOzDaiYgi61HCdE1K8XHeGTDB4IkcV4JBYF
         OfZw==
X-Gm-Message-State: AOAM532YscDSDM5QIrsQ9J8BU5EWu5oLK0mBEbVrPgHbRuNFswh404AY
        8E/iasb48oWyvbIoNN8G08Wfuw==
X-Google-Smtp-Source: ABdhPJymvUPIEff3uEiOhFC8PqKbbFXCngUaPAQ96GGUp2FYuqQpLllY+Mk5xWbNxDWjkvXLJTlEUw==
X-Received: by 2002:a05:6a00:b51:b0:4fa:ece9:15e4 with SMTP id p17-20020a056a000b5100b004faece915e4mr22481702pfo.27.1648480612981;
        Mon, 28 Mar 2022 08:16:52 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id p10-20020a056a0026ca00b004fb44e0cb17sm6083630pfw.116.2022.03.28.08.16.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Mar 2022 08:16:52 -0700 (PDT)
Date:   Mon, 28 Mar 2022 15:16:49 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Mingwei Zhang <mizhang@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>
Subject: Re: [PATCH] KVM: x86/mmu: add lockdep check before
 lookup_address_in_mm()
Message-ID: <YkHRYY6x1Ewez/g4@google.com>
References: <20220327205803.739336-1-mizhang@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220327205803.739336-1-mizhang@google.com>
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

On Sun, Mar 27, 2022, Mingwei Zhang wrote:
> Add a lockdep check before invoking lookup_address_in_mm().
> lookup_address_in_mm() walks all levels of host page table without
> accquiring any lock. This is usually unsafe unless we are walking the
> kernel addresses (check other usage cases of lookup_address_in_mm and
> lookup_address_in_pgd).
> 
> Walking host page table (especially guest addresses) usually requires
> holding two types of locks: 1) mmu_lock in mm or the lock that protects
> the reverse maps of host memory in range; 2) lock for the leaf paging
> structures.
> 
> One exception case is when we take the mmu_lock of the secondary mmu.
> Holding mmu_lock of KVM MMU in either read mode or write mode prevents host
> level entities from modifying the host page table concurrently. This is
> because all of them will have to invoke KVM mmu_notifier first before doing
> the actual work. Since KVM mmu_notifier invalidation operations always take
> the mmu write lock, we are safe if we hold the mmu lock here.
> 
> Note: this means that KVM cannot allow concurrent multiple mmu_notifier
> invalidation callbacks by using KVM mmu read lock. Since, otherwise, any
> host level entity can cause race conditions with this one. Walking host
> page table here may get us stale information or may trigger NULL ptr
> dereference that is hard to reproduce.
> 
> Having a lockdep check here will prevent or at least warn future
> development that directly walks host page table simply in a KVM ioctl
> function. In addition, it provides a record for any future development on
> KVM mmu_notifier.
> 
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Ben Gardon <bgardon@google.com>
> Cc: David Matlack <dmatlack@google.com>
> 
> Signed-off-by: Mingwei Zhang <mizhang@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 1361eb4599b4..066bb5435156 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -2820,6 +2820,24 @@ static int host_pfn_mapping_level(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
>  	 */
>  	hva = __gfn_to_hva_memslot(slot, gfn);
>  
> +	/*
> +	 * lookup_address_in_mm() walks all levels of host page table without
> +	 * accquiring any lock. This is not safe when KVM does not take the
> +	 * mmu_lock. Holding mmu_lock in either read mode or write mode prevents
> +	 * host level entities from modifying the host page table. This is
> +	 * because all of them will have to invoke KVM mmu_notifier first before
> +	 * doing the actual work. Since KVM mmu_notifier invalidation operations
> +	 * always take the mmu write lock, we are safe if we hold the mmu lock
> +	 * here.
> +	 *
> +	 * Note: this means that KVM cannot allow concurrent multiple
> +	 * mmu_notifier invalidation callbacks by using KVM mmu read lock.
> +	 * Otherwise, any host level entity can cause race conditions with this
> +	 * one. Walking host page table here may get us stale information or may
> +	 * trigger NULL ptr dereference that is hard to reproduce.
> +	 */
> +	lockdep_assert_held(&kvm->mmu_lock);

Holding mmu_lock isn't strictly required.  It would also be safe to use this helper
if mmu_notifier_retry_hva() were checked after grabbing the mapping level, before
consuming it.  E.g. we could theoretically move this to kvm_faultin_pfn().

And simply holding the lock isn't sufficient, i.e. the lockdep gives a false sense
of security.  E.g. calling this while holding mmu_lock but without first checking
mmu_notifier_count would let it run concurrently with host PTE modifications.

I'm definitely in favor of adding a comment to document the mmu_notifier
interactions, but I don't like adding a lockdep.
