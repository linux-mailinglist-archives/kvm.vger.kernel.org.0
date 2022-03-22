Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9EBE4E4936
	for <lists+kvm@lfdr.de>; Tue, 22 Mar 2022 23:36:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238104AbiCVWhg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Mar 2022 18:37:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231526AbiCVWhf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Mar 2022 18:37:35 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6E4124BDC
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 15:36:05 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id q14so12631845ljc.12
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 15:36:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xOVVu/q0Ku1P/VW4cpKoWIMKe104EsaHhNWgjj4aCF8=;
        b=Y7qK379YZwjwJ93fuYIEVEDITu46iSrJOQ0tZ8SSc7IVS8czHo+MH4DJ7Pt7CL2biv
         GMjsHvy2T2x2DnT7OfrTkJ/sO5zmepZkjcXthCPZ4S9i4u64E9R4NOXDMYXHd5xJdO3a
         ahkV/xEP+lQEfsObo1RcXS1j/+oHAk5Z5+t01bDijgjmBhtKAhib6SUKp/zQZxG4XLPd
         nY5kbhVDTSTIFbGGM7tOW78wkSioZ/5SiaF2e2vzZ4kyh8DaZB9XrnkFb9KxGdW4Irty
         2fzpNLrPi8SnEn0OVzetEpoHsp6JrPqr2b9SACCkU3eSFZUiaZxL/5o/v/qMLVYzTDiF
         adTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xOVVu/q0Ku1P/VW4cpKoWIMKe104EsaHhNWgjj4aCF8=;
        b=MLg1J4vzNrI3rouHzZpfkgBdYS7GGBq91t3bEMqOfgLKSVBBJY7FCQvEDOsWd+jsxM
         pRH1AO577NkT1Y2t2hOtL2bM7eiO+/0d9cTX0k01XxV4G+U0sAlWrevS2336x6ZHAw+t
         +nNs7BgTv2SBZVOYBI56TGfuyW6ERbXgFBhtpLC3u1oRCtyLW7LLpdlVO2YwjPc8j0C3
         7TZcVopN2wd8+DSKG8VCKe6FomR/hcMa5eSBFU07NEBJyiei4EqqXykUJeV+LteeJmkp
         GAo76gVBjB0pXpBHXgOv9bu7aTlDfXeP4tlGvF5qb/u2zvPly3J8/BZ6xEIRCMrekRIV
         VsZg==
X-Gm-Message-State: AOAM530jgC857rOM/acx0Olr9E77n+zdXelpIxBud9QIBCQ6IdnFnNQy
        1sqEkxxaruC4HsarqJT1qTU4oS7JhwR6ONxbsnKFbA==
X-Google-Smtp-Source: ABdhPJwluBUdrQ3S0RKAvUXwpNmDB1zewZyw9nwYwRGoo/UMdP6fAUCPu5hPz027Wbt0/gETfLhJ81bzY9PXcrOyUew=
X-Received: by 2002:a2e:8255:0:b0:247:dff4:1f with SMTP id j21-20020a2e8255000000b00247dff4001fmr20990052ljh.16.1647988564022;
 Tue, 22 Mar 2022 15:36:04 -0700 (PDT)
MIME-Version: 1.0
References: <20220311002528.2230172-1-dmatlack@google.com> <20220311002528.2230172-12-dmatlack@google.com>
 <YjBqAL+bPmcQpTgM@xz-m1.local>
In-Reply-To: <YjBqAL+bPmcQpTgM@xz-m1.local>
From:   David Matlack <dmatlack@google.com>
Date:   Tue, 22 Mar 2022 15:35:37 -0700
Message-ID: <CALzav=ehyvZiM-JH6gcZo_yw9R-T5mR18UQF_GecM-qZCQs=Uw@mail.gmail.com>
Subject: Re: [PATCH v2 11/26] KVM: x86/mmu: Use common code to allocate
 kvm_mmu_page structs from vCPU caches
To:     Peter Xu <peterx@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Sean Christopherson <seanjc@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Ben Gardon <bgardon@google.com>,
        "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
        "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)" 
        <kvmarm@lists.cs.columbia.edu>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <linux-mips@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>, Peter Feiner <pfeiner@google.com>
Content-Type: text/plain; charset="UTF-8"
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

On Tue, Mar 15, 2022 at 3:27 AM Peter Xu <peterx@redhat.com> wrote:
>
> On Fri, Mar 11, 2022 at 12:25:13AM +0000, David Matlack wrote:
> >  static struct kvm_mmu_page *tdp_mmu_alloc_sp(struct kvm_vcpu *vcpu)
> >  {
> > -     struct kvm_mmu_page *sp;
> > -
> > -     sp = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_page_header_cache);
> > -     sp->spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);
> > -     set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
> > -
> > -     return sp;
> > +     return kvm_mmu_alloc_shadow_page(vcpu, true);
> >  }
>
> Similarly I had a feeling we could drop tdp_mmu_alloc_sp() too.. anyway:

Certainly, but I think it simplifies the TDP MMU code to keep it. It abstracts
away the implementation detail that a TDP MMU shadow page is allocated
the same way as a shadow MMU shadow page with direct=true.


>
> Reviewed-by: Peter Xu <peterx@redhat.com>
>
> --
> Peter Xu
>
