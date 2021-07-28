Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFAE53D9734
	for <lists+kvm@lfdr.de>; Wed, 28 Jul 2021 23:04:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231521AbhG1VEj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jul 2021 17:04:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231126AbhG1VEi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jul 2021 17:04:38 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E4C2C061757
        for <kvm@vger.kernel.org>; Wed, 28 Jul 2021 14:04:35 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id u9-20020a17090a1f09b029017554809f35so12042337pja.5
        for <kvm@vger.kernel.org>; Wed, 28 Jul 2021 14:04:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6oqQGW021mXZJqHUhtjWzolnPxlWrLTQodXSIJOlGhw=;
        b=eLM5EQeizByK/ijs+2tySCIiM3GHSuhXYwUPJ6UphRysKEwpdAJ+mOpZeWu7xL9V63
         QvpZiWmiNEo95qMPAXvd2v0zW9ZVSQC3Vjk23f9H8UEyxGEo7T4JiVwlmMbJmqGHBCax
         WdnE4yPAT81znogqh6ucbl7kXJlxqd2E/RBCmWdv7MeQQvE50lDQoFt4FlhoqOvK5ARC
         PTzDAyIg61H3EmKKCqyiy7E+f4HNlBuTJ2UhJzpuUzxMJDYyJjwhmD6HD7r1OvThixHo
         Eyj1oAEx35Sh7Enci2QkZ3ER77na7POa2ZJn2iEsy5fyU23H5v5w1nRXPqAAIVNzebXV
         YHxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6oqQGW021mXZJqHUhtjWzolnPxlWrLTQodXSIJOlGhw=;
        b=dsfgLLD+1j2mgZIZ9BoathGDfdpuoEa+pZaR1G/uGlSdqwqZTfVoZ1I7Wj1YeywI/g
         kz5RzE5zL4EO0Yy4s3ZIOjwbKdVuRtkGuY8RRI/1MZNpYzB5MM8RR8ho1gaN7scWN+yN
         GsdzDH1osndfEulF7X55tVkTWF3/nJ3hy62TUdq8qPB2wvk7A3rxIBMn1TnuoTqj5rl7
         8wgDcUt7Ht2Khbs+wfdToFA7Bz6zcBzGfyHuouSqxfVLb9PdKewWMCFw0hBdEBTj30UN
         WN8YUl6L6QW7RwcAoVHHuxMwmIQxl1KNRdXwEjbR0d3zhcqFkc/zMD5qur0Sdq1HTBW4
         Tr6A==
X-Gm-Message-State: AOAM532W27Mg/lJK6rzuwPrZ2y2iYoc/veFL6PBJmr656to8/gpjSrUs
        woYXmQUV6XVeJNAQy7ii6/ChOg==
X-Google-Smtp-Source: ABdhPJzABD22vgcAIozv/lPX90Kviu7akrDr6A4LvJXVU7vw0qoySbS71Asd4jheWAIQsKpp/LwqzQ==
X-Received: by 2002:a62:ea10:0:b029:399:ff48:e9da with SMTP id t16-20020a62ea100000b0290399ff48e9damr1689492pfh.56.1627506274948;
        Wed, 28 Jul 2021 14:04:34 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id c23sm946425pfn.140.2021.07.28.14.04.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 14:04:34 -0700 (PDT)
Date:   Wed, 28 Jul 2021 21:04:30 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 8/9] KVM: X86: Optimize pte_list_desc with per-array
 counter
Message-ID: <YQHGXhOc5gO9aYsL@google.com>
References: <20210625153214.43106-1-peterx@redhat.com>
 <20210625153415.43620-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210625153415.43620-1-peterx@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 25, 2021, Peter Xu wrote:
> Add a counter field into pte_list_desc, so as to simplify the add/remove/loop
> logic.  E.g., we don't need to loop over the array any more for most reasons.
> 
> This will make more sense after we've switched the array size to be larger
> otherwise the counter will be a waste.
> 
> Initially I wanted to store a tail pointer at the head of the array list so we
> don't need to traverse the list at least for pushing new ones (if without the
> counter we traverse both the list and the array).  However that'll need
> slightly more change without a huge lot benefit, e.g., after we grow entry
> numbers per array the list traversing is not so expensive.
> 
> So let's be simple but still try to get as much benefit as we can with just
> these extra few lines of changes (not to mention the code looks easier too
> without looping over arrays).
> 
> I used the same a test case to fork 500 child and recycle them ("./rmap_fork
> 500" [1]), this patch further speeds up the total fork time of about 14%, which
> is a total of 38% of vanilla kernel:
> 
>         Vanilla:      367.20 (+-4.58%)
>         3->15 slots:  302.00 (+-5.30%)
>         Add counter:  265.20 (+-9.88%)
> 
> [1] https://github.com/xzpeter/clibs/commit/825436f825453de2ea5aaee4bdb1c92281efe5b3
> 
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 33 ++++++++++++++++++---------------
>  1 file changed, 18 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 9b093985a2ef..ba0258bdebc4 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -138,10 +138,15 @@ module_param(dbg, bool, 0644);
>  #include <trace/events/kvm.h>
>  
>  /* make pte_list_desc fit well in cache lines */
> -#define PTE_LIST_EXT 15
> +#define PTE_LIST_EXT 14

Doh, I looked at kvm/queue code before looking at the full series.

>  struct pte_list_desc {
>  	u64 *sptes[PTE_LIST_EXT];
> +	/*
> +	 * Stores number of entries stored in the pte_list_desc.  No need to be
> +	 * u64 but just for easier alignment.  When PTE_LIST_EXT, means full.
> +	 */
> +	u64 spte_count;

Per my feedback to the previous patch, this should be above sptes[] so that rmaps
with <8 SPTEs only touch one cache line.  No idea if it actually matters in
practice, but I can't see how it would harm anything.

>  	struct pte_list_desc *more;
>  };
