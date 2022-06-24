Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7759F55A4A1
	for <lists+kvm@lfdr.de>; Sat, 25 Jun 2022 01:08:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230355AbiFXXHC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 19:07:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiFXXHB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 19:07:01 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24ED688B0B
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 16:07:01 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id jh14so3316112plb.1
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 16:07:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=M034/RMdz5Qbmfln1Y0Q9RQOoS0pm2Uq8u+/WgT65Dk=;
        b=anvPTCnvjEhTyxynd7MA372XfOoBsgzujHVVnMw0aW4X99JBDgXo7INlEhM3/WEB3R
         pRUGu9GCkdOUkL8krJXuuRS+E/shB+vfGy2i834ihRMkEaLd+dYJ0NADhzcd10h7z9LH
         3igGTaDQZKQFqjDvZ6/xe+5hURawFnKWlWuvAcFttwJrL2sy1gqbBggEvseSA44WgwWQ
         WFCR7pStad52przPjTR7+5NUu8+l79ZexzZfgNiHEv/1JupLoPa4zh7veKBSIPJF8F2Y
         Qo2VbA4rCf4i0C03wk9ixgUGuGUg5+bS9scmtmWLoxSkyqTfZNTdBkrpS9ZtP6wYXQ9s
         b2sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=M034/RMdz5Qbmfln1Y0Q9RQOoS0pm2Uq8u+/WgT65Dk=;
        b=qNQ+/GKnuTQ/NSfY3BGnPwQIZChVsiqfrBpKrOl5flyQi1rGc9KJx4JdQ+qTXzqF0P
         HKh34yGJocgZZNmbctrBSdc1DAWT3lJz+V8GAfuB+i67f0umjeMmO2qcoLMoR0e1PUWH
         w/gII638Jr76wYO3AzubVW06zVd6K4wRLrkbbJHPv9UtyFnh04JYY2ELSr5xOhFnBywF
         GpyL6GbRh8DvsV8cvETGg5iSY7XLCjF8sB/mf0Wki/5l5ruzU8tzg0AsatoaZ96j6dxc
         XPohIDbjMdWFc1+5x82VvRg/bT1IucgWwFAQxlHZCCejVZ89ZYEE/SlpiREODJIUJBWo
         c2tw==
X-Gm-Message-State: AJIora9VqLaN/L569ZfQCw+gtjU2zSaocdh0wt47B9+dBuyTaRaXAugb
        E6ZJDAQECx4i3hKAhKGarGG90XMOeE4DYw==
X-Google-Smtp-Source: AGRyM1uwRkTAlNC28vzK4calU+YrTTtgqyY4sc7VqpQ7dR60345mVH5JElaVOcC+4QVJPOGTL5Cc0w==
X-Received: by 2002:a17:902:6901:b0:168:9bb4:7adb with SMTP id j1-20020a170902690100b001689bb47adbmr1410845plk.147.1656112020514;
        Fri, 24 Jun 2022 16:07:00 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id b205-20020a621bd6000000b0051bb1785286sm2229594pfb.167.2022.06.24.16.06.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jun 2022 16:06:59 -0700 (PDT)
Date:   Fri, 24 Jun 2022 23:06:56 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Hou Wenlong <houwenlong.hwl@antgroup.com>
Cc:     kvm@vger.kernel.org
Subject: Re: [PATCH 0/5] Fix wrong gfn range of tlb flushing with range
Message-ID: <YrZDkBSKwuQSrK+r@google.com>
References: <cover.1656039275.git.houwenlong.hwl@antgroup.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1656039275.git.houwenlong.hwl@antgroup.com>
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

On Fri, Jun 24, 2022, Hou Wenlong wrote:
> Commit c3134ce240eed
> ("KVM: Replace old tlb flush function with new one to flush a specified range.")
> replaces old tlb flush function with kvm_flush_remote_tlbs_with_address()
> to do tlb flushing. However, the gfn range of tlb flushing is wrong in
> some cases. E.g., when a spte is dropped, the start gfn of tlb flushing

Heh, "some" cases.  Looks like KVM is wrong on 7 of 15 cases.  And IIRC, there
were already several rounds of fixes due to passing "end" instead of "nr_pages".

Patches look ok on a quick read through, but I'd have to stare a bunch more to
be confident.

Part of me wonders if we should just revert the whole thing and then only reintroduce
range-based flushing with proper testing and maybe even require performance numbers
to justify the benefits.  Give that almost 50% of the users are broken, it's pretty
obvious that no one running KVM actually tests the behavior.

> should be the gfn of spte not the base gfn of SP which contains the spte.
> So this patchset would fix them and do some cleanups.
> 
> Hou Wenlong (5):
>   KVM: x86/mmu: Fix wrong gfn range of tlb flushing in
>     validate_direct_spte()
>   KVM: x86/mmu: Fix wrong gfn range of tlb flushing in
>     kvm_set_pte_rmapp()
>   KVM: x86/mmu: Reduce gfn range of tlb flushing in
>     tdp_mmu_map_handle_target_level()
>   KVM: x86/mmu: Fix wrong start gfn of tlb flushing with range
>   KVM: x86/mmu: Use 1 as the size of gfn range for tlb flushing in
>     FNAME(invlpg)()
> 
>  arch/x86/kvm/mmu/mmu.c         | 15 +++++++++------
>  arch/x86/kvm/mmu/paging_tmpl.h |  2 +-
>  arch/x86/kvm/mmu/tdp_mmu.c     |  4 ++--
>  3 files changed, 12 insertions(+), 9 deletions(-)
> 
> --
> 2.31.1
> 
