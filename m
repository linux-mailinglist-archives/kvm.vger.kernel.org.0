Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59C9154FCFB
	for <lists+kvm@lfdr.de>; Fri, 17 Jun 2022 20:35:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbiFQSfF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Jun 2022 14:35:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230011AbiFQSfE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Jun 2022 14:35:04 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF0C633A1D
        for <kvm@vger.kernel.org>; Fri, 17 Jun 2022 11:35:03 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id u37so4855355pfg.3
        for <kvm@vger.kernel.org>; Fri, 17 Jun 2022 11:35:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wn5PJvZjayRGTgY0EL7zo+ZpkVBIhnd1vf/XBJfv398=;
        b=XUjHAkComAsH676GvMGE8tfx7jPYVHXd49eunVKrZupRS34+He9Ne0Gtm/unj7Uqyl
         ykdip2LZH2YlJjdHgomgqFc1Zio2za04RCEQEox9FQRzHqZ9we1ib3s5M1DhJyFZa9MB
         nnl5RiYodqPM9NTNq+MB76c62ZV49AUKSUk5uIlwYA7OxXm0KgOM2nJwnHg5npdpCC8F
         H8M1+Ofb3zHl5174PCWBppRvNiI2V22LzZfKWhFLP7bQKF4az2k7MvbZx4421pwNr9Xr
         v6vIoBdyVQZiyzfWn+jGiAPVJ7cHZf608mZ+JbqR3zUZHJ5W6IPaR1ljg1lxpVqRMVHS
         JzRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wn5PJvZjayRGTgY0EL7zo+ZpkVBIhnd1vf/XBJfv398=;
        b=7IfjhSZi2NxfISTl2cTxkl+Vud15ip8cdxiPQ3N2ETnuo5RyJTLJGaBqR89V0nBHiS
         +uur0TggHqsQCw//i0FwmGDmMZdgp2eCVfwGEByRwoKLtuIzTZfMXyI1xRBZOBOicVw5
         Xk/frCrwOmJmFE0NQRg4LwP4JDyL2Vrls3NKBUVSfVFLfSIH9bqN3kMgdIly1iQywYuA
         Q5WvFE25ggc/H0uQb+Lini6rwhFv5s7eWjXdyvGkzikkRFObjFY6UUZpHogjiILbU0n7
         78zSGotZINfLsPMQFl+wk+ydz/57Nq798Y6hy78wyopgHfKmLhk9WWlf5twy2P9vhBcM
         sqyQ==
X-Gm-Message-State: AJIora/shGmP1RZ0iI7Y3XUuNy4TpWfK4UtMKHRhT/RLS1p+RymUuxtV
        rrkFtGDBI4ckFNzmgZXW1lIkcA==
X-Google-Smtp-Source: AGRyM1spMY0SV+af/bWX4jYu0RNeMMMehRL+RlWnsxhf3BAN02q9XVjNqdlG9AaqqAiCUkeYx2Fagw==
X-Received: by 2002:a05:6a00:218c:b0:51c:c64:3f6a with SMTP id h12-20020a056a00218c00b0051c0c643f6amr11135128pfi.50.1655490903050;
        Fri, 17 Jun 2022 11:35:03 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id g8-20020a62f948000000b0051b8e7765edsm4014810pfm.67.2022.06.17.11.35.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jun 2022 11:35:02 -0700 (PDT)
Date:   Fri, 17 Jun 2022 18:34:59 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Andrew Jones <drjones@redhat.com>,
        Ben Gardon <bgardon@google.com>, Peter Xu <peterx@redhat.com>,
        maciej.szmigiero@oracle.com,
        "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)" 
        <kvmarm@lists.cs.columbia.edu>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <linux-mips@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>, Peter Feiner <pfeiner@google.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>
Subject: Re: [PATCH v6 21/22] KVM: Allow for different capacities in
 kvm_mmu_memory_cache structs
Message-ID: <YqzJUxrW67vACltI@google.com>
References: <20220516232138.1783324-1-dmatlack@google.com>
 <20220516232138.1783324-22-dmatlack@google.com>
 <Yqy84GkGAdE1BzI6@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yqy84GkGAdE1BzI6@google.com>
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

On Fri, Jun 17, 2022, Sean Christopherson wrote:
> On Mon, May 16, 2022, David Matlack wrote:
> > -int kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min)
> > +static int __kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int capacity, int min)
> 
> I still find it somewhat kludgy to have callers provide an capacity.  It's not
> terrible while there's only a single call site, but if a use case comes along
> for using an oversized cache with multiple call sites, it'll be gross.
> 
> Tweaking my idea of a "custom" wrapper, what about adding an "oversized" wrapper?
> That yields clear, firm rules on when to use each helper, guards against calling
> the "standard" flavor with an impossible @min, and addresses Mingwei's concern
> that a misguided user could specify a nonsensically small capacity.

Drat, arguing against my own idea.

The future usage in nested_mmu_try_split_huge_page() is going to be inefficient.
By having capacity==min, consuming just one entry, which is guaranteed when a
huge page split is successful, will mean the cache needs to be topped up.  In other
words, I'm pretty sure need_topup_split_caches_or_resched() will always return
true between different huge pages and so KVM will drop mmu_lock and reschedule
after every huge page.  Maybe that's not a big deal, but at the very least it's
odd, and its a nasty gotcha with forcing capacity==min.

So I'm ok with this patch, though it should yell if min > capacity.

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 932abb4fb67e..14e807501229 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -388,7 +388,7 @@ int __kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int capacity,
                return 0;

        if (unlikely(!mc->objects)) {
-               if (WARN_ON_ONCE(!capacity))
+               if (WARN_ON_ONCE(!capacity || min > capacity))
                        return -EIO;

                mc->objects = kvmalloc_array(sizeof(void *), capacity, gfp);
