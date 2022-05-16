Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE746528AB9
	for <lists+kvm@lfdr.de>; Mon, 16 May 2022 18:39:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343763AbiEPQji (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 12:39:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233538AbiEPQjh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 12:39:37 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0C6F3BA58
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 09:39:34 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id i10so26780677lfg.13
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 09:39:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hYHwEAjXNX75VWbUllN/Gour8BQtThd5ZVwkANp9gRY=;
        b=bK0X0UtuI4068ycqprV0lsvDAI+AHR1gGA9C4RAXNgLVkgt0X/SKAKqpBUz8VqsXpj
         VrQIu3E5HBAJkaSLXxA5SSd32mibLdUgvSTv7KRsOl12irVDXAei24CduxHIFEmELpOP
         Akpk1TKatgOUWNo6GH97f41Rgt6dC5o53iE1TXInCkHY+5KU2UCKYICVz0nTiaETdOa2
         CUC3ubVPJqahOO59ugDHhBeZXWtViC++Mw6XCSkemHHGmBDpjehgL/B1CmV7dpUkYOpZ
         84aGJCq612yfSOXz1WDxqr+HCHIKSkf5IFdZCgpMrXHap1xZ012QF/CF92C9hAXvs7rX
         +KlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hYHwEAjXNX75VWbUllN/Gour8BQtThd5ZVwkANp9gRY=;
        b=DQbtNFjfMyRESApVNkIHTfoBO40ZpFgPkoBd7JHtjcGKYj25XyTTdwkBYac8uakIU7
         lVpYiZrl1CWoxRg2ja/aYIn5cza/Pu6km4oYE4H+JPw9xkitXnOBM22RhufdEMVZFj7G
         5LRj6aDQan+sQ1sCCQqMG2kb+ghp5Dk8rZ/IQPc1v4qTYfeTK//CvOAH9nqX4zUBVyTa
         dR43KW88zLtItmEeEbWu+zJfhFlGxDOLrxisOytfSbKH5I0G1XbyhVXvikaq8NMT02sK
         18N8T+f3rQHz49OcYVKwMiRuxsYQTEYZob9APqpiG4T/4zn/Rhbm//HYSue+nKMuOfAv
         PdTg==
X-Gm-Message-State: AOAM533s3ZepIS3X1Zyw78qcoj/r7Vwn2UC4GXHN2hZdouYJYMOOVqww
        YXnoRatkhSURz3QpsXwvq+Q443SfQD516zHxHoP0Mg==
X-Google-Smtp-Source: ABdhPJxDcLtX1NQ8HJRWY2uXCXca5YQCMMosdKfmnprtNa9msTSkc4SzO4QNTM90AWokT5c92TgN1ZwszC5RaDsSBUI=
X-Received: by 2002:a19:674c:0:b0:448:3f49:e6d5 with SMTP id
 e12-20020a19674c000000b004483f49e6d5mr13821457lfj.518.1652719173041; Mon, 16
 May 2022 09:39:33 -0700 (PDT)
MIME-Version: 1.0
References: <20220513202819.829591-1-dmatlack@google.com> <20220513202819.829591-21-dmatlack@google.com>
 <YoJkb7oMEz0v1dnp@google.com>
In-Reply-To: <YoJkb7oMEz0v1dnp@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Mon, 16 May 2022 09:39:07 -0700
Message-ID: <CALzav=d-O5KWDC356cdpoJAUvKSSNOMtn_n7G6Yc342-VQFJNQ@mail.gmail.com>
Subject: Re: [PATCH v5 20/21] KVM: Allow for different capacities in
 kvm_mmu_memory_cache structs
To:     Sean Christopherson <seanjc@google.com>
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
Content-Type: text/plain; charset="UTF-8"
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

On Mon, May 16, 2022 at 7:49 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Fri, May 13, 2022, David Matlack wrote:
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index 53ae2c0640bc..2f2ef6b60ff4 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -764,7 +764,10 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
> >  {
> >       phys_addr_t addr;
> >       int ret = 0;
> > -     struct kvm_mmu_memory_cache cache = { 0, __GFP_ZERO, NULL, };
> > +     struct kvm_mmu_memory_cache cache = {
> > +             .capacity = KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE,
> > +             .gfp_zero = __GFP_ZERO,
>
> I dislike requiring all users to specificy the capacity.  It largely defeats the
> purpose of KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE, and bleeds details into code that
> really doesn't care all that much about the details.
>
> Rather than force the capacity to be set before topup, what about adding a custom
> capacity topup helper?  That allows keeping a default capacity, better documents
> the caches that are special, and provides an opportunity to sanity check that the
> capacity isn't incorrectly changed by the user.

Even simpler: If mc->capacity is 0 in topup, set it to
KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE.

This is what I had before when I was laying out the storage for
objects in a separate array. It was risky then because it was too easy
for someone to accidentally corrupt memory (call topup with
capacity==0 but without allocating the objects array). Now that topup
takes care of allocation automatically, that risk is gone.

>
> And then I believe this code becomes:
>
>         struct kvm_mmu_memory_cache cache = { .gfp_zero = __GFP_ZERO };
>
> E.g. (completely untested)
>
> static int __kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc,
>                                         int capacity, int min)
> {
>         gfp_t gfp = GFP_KERNEL_ACCOUNT;
>         void *obj;
>
>         if (mc->nobjs >= min)
>                 return 0;
>
>         if (likely(mc->capacity)) {
>                 if (WARN_ON_ONCE(mc->capacity != capacity || !mc->objects))
>                         return -EIO;
>         } else {
>                 mc->objects = kvmalloc_array(sizeof(void *), capacity, gfp);
>                 if (!mc->objects)
>                         return -ENOMEM;
>
>                 mc->capacity = capacity;
>         }
>
>         while (mc->nobjs < mc->capacity) {
>                 obj = mmu_memory_cache_alloc_obj(mc, gfp);
>                 if (!obj)
>                         return mc->nobjs >= min ? 0 : -ENOMEM;
>                 mc->objects[mc->nobjs++] = obj;
>         }
>         return 0;
> }
>
> int kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min)
> {
>         const int capacity = KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE;
>
>         return __kvm_mmu_topup_memory_cache(mc, capacity, min);
> }
>
> int kvm_mmu_topup_custom_memory_cache(struct kvm_mmu_memory_cache *mc,
>                                       int capacity)
> {
>         return __kvm_mmu_topup_memory_cache(mc, capacity, capacity);
> }
>
