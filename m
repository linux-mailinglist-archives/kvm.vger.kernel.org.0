Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF30651CC67
	for <lists+kvm@lfdr.de>; Fri,  6 May 2022 01:00:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386532AbiEEXE1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 19:04:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386529AbiEEXEZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 19:04:25 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B61505EDCB
        for <kvm@vger.kernel.org>; Thu,  5 May 2022 16:00:43 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id c14so4813882pfn.2
        for <kvm@vger.kernel.org>; Thu, 05 May 2022 16:00:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OynsI/Y1y6rsQh9WExR+1/Zkn9MMK8WgC1JkonenMkY=;
        b=czdbdSz4ZFvCh9CDIv//7vre9DD/9YuCdL7EH5JN3DK0rF1o5+bTGuSgXwOZeSrk+p
         p8f2JfvS0v+6umNaERHgOwIdoEi8v1/2zrslEUYWwlHeubYqiVmr34/AxEsei4oudhWF
         CJw1/UWxbSaDoiU0lYFK9W30KO/wNOo18gChC4qkaV1TP5t1Sj1gQwYTlFKXOJwlMxlq
         XeiXI6920NuTALp0ZQbe2zYhFBhwPP2emPNLXFFrtYyo4BIGE7RBJErDr0wdw4Tg7a0V
         li/5C0KssxCA+9aZc5pkAacKGyoxzspvkeX6qENNBTjpWd2qQDkGsVy52938gVfWzJSk
         QdKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OynsI/Y1y6rsQh9WExR+1/Zkn9MMK8WgC1JkonenMkY=;
        b=JdF3vW/q2VQ00GEFHol72CkCUFj62VoXU18LR6e6T8ubxbXeiojnsB0vuHQNDIu+XO
         d2BMkvKfSd08lGTJToFD0Tln3Q1ZhZrUxX+xjZCdH206H1+rbavLJDREDp4UJC35N9NH
         UkpvxNYayQ2KBUp75q//L0nrjY5taz5jmy3JNul7SEsfC7B9CZ3PQN0J/zIL3hkJ/TTl
         ic9l0QTbDIJpV/4XhjY0xPjFcd0P2T+PT37IKQgeSaViJBqeLhp9lcyh6yXSmzjOq3Ye
         a0UH3fnOb4N3ZKc+v0QiYqlo+uKwq+S9JtBNolnyJi+xJn/c5Kvzz7WtJ0xxTashfO6t
         3dlQ==
X-Gm-Message-State: AOAM531teaShPpQe5uh9UmspOdeyoyKYYqWVmiA8l1E4fOe/XTgSMP7p
        BHLAqRyDvszxcyLNPxjoNpC5uw==
X-Google-Smtp-Source: ABdhPJxDu0wALLZyxGIddDUnRgsXc2qv3Ld2ZmjdwFGFx/UOM+F3BAohwM2FdgVKnvaNd70HiCM4nw==
X-Received: by 2002:a63:6841:0:b0:3c1:a611:793e with SMTP id d62-20020a636841000000b003c1a611793emr308309pgc.249.1651791642951;
        Thu, 05 May 2022 16:00:42 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id y18-20020a170902d65200b0015e8d4eb27fsm146862plh.201.2022.05.05.16.00.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 May 2022 16:00:42 -0700 (PDT)
Date:   Thu, 5 May 2022 23:00:39 +0000
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
        <kvm-riscv@lists.infradead.org>, Peter Feiner <pfeiner@google.com>
Subject: Re: [PATCH v4 08/20] KVM: x86/mmu: Pass memory caches to allocate
 SPs separately
Message-ID: <YnRXFyTik32RIxNp@google.com>
References: <20220422210546.458943-1-dmatlack@google.com>
 <20220422210546.458943-9-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220422210546.458943-9-dmatlack@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 22, 2022, David Matlack wrote:
> Refactor kvm_mmu_alloc_shadow_page() to receive the caches from which it
> will allocate the various pieces of memory for shadow pages as a
> parameter, rather than deriving them from the vcpu pointer. This will be
> useful in a future commit where shadow pages are allocated during VM
> ioctls for eager page splitting, and thus will use a different set of
> caches.
> 
> Preemptively pull the caches out all the way to
> kvm_mmu_get_shadow_page() since eager page splitting will not be calling
> kvm_mmu_alloc_shadow_page() directly.
> 
> No functional change intended.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---

...

>  static struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm_vcpu *vcpu,
> +						      struct shadow_page_caches *caches,

Definitely work doing the "kvm" capture in an earlier patch, and doing the s/vcpu/kvm
here, the diff on top is tiny.  The shortlog/changelog would need minor tweaks, but
that's not a big deal.

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index da1c3cf91778..15784bab985f 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2084,13 +2084,12 @@ struct shadow_page_caches {
        struct kvm_mmu_memory_cache *gfn_array_cache;
 };

-static struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm_vcpu *vcpu,
+static struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm *kvm,
                                                      struct shadow_page_caches *caches,
                                                      gfn_t gfn,
                                                      struct hlist_head *sp_list,
                                                      union kvm_mmu_page_role role)
 {
-       struct kvm *kvm = vcpu->kvm;
        struct kvm_mmu_page *sp;

        sp = kvm_mmu_memory_cache_alloc(caches->page_header_cache);
@@ -2133,7 +2132,7 @@ static struct kvm_mmu_page *__kvm_mmu_get_shadow_page(struct kvm_vcpu *vcpu,
        sp = kvm_mmu_find_shadow_page(vcpu, gfn, sp_list, role);
        if (!sp) {
                created = true;
-               sp = kvm_mmu_alloc_shadow_page(vcpu, caches, gfn, sp_list, role);
+               sp = kvm_mmu_alloc_shadow_page(vcpu->kvm, caches, gfn, sp_list, role);
        }

        trace_kvm_mmu_get_page(sp, created);

