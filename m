Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C69CA520639
	for <lists+kvm@lfdr.de>; Mon,  9 May 2022 22:53:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbiEIU5q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 May 2022 16:57:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbiEIU5o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 May 2022 16:57:44 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABD911B775C
        for <kvm@vger.kernel.org>; Mon,  9 May 2022 13:53:48 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id bu29so25965755lfb.0
        for <kvm@vger.kernel.org>; Mon, 09 May 2022 13:53:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=juLv0tHpYyniXYJdhCO4IxrUzdGFAB7hgGLuXWxzzfQ=;
        b=sRZ7gFCnwGjke9Wy7MLVeZ5O0pOeCU9NprkShjZhbejgMypvTgHE4yc3vifvxCNILW
         kSIZJ/CoKbTAq+5dr8eFKZdVdVqRgUP3XWXoOUKk8XQb5nTv6W54BQcarUUUYhRKizgk
         iujC3c1SKkL5XlpepNx1f1AOO4+7qMzGYgwTIZbbi1ptSn1ndmsmXhHpMMm6s2ZfSFZt
         pyvC4L5K+czwRFO5op8YzGtjjgsEOAWeR0E5RddYpLcOWTKUCY9qQr3k+FTZxfIfuAj6
         WIByklV6HkfKOcUB6vX/KH6jQodXZaEnZQc4VvsVPJbH0jRYWbhBUGhaj43wbYvDlPJb
         4UaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=juLv0tHpYyniXYJdhCO4IxrUzdGFAB7hgGLuXWxzzfQ=;
        b=CHRrOYtaHC4AgvPTmi33UBMXZPYiXzbz2ATMsHr9q2LzdVBIeMu/m9IAJIHXkwC8u5
         NkSACvpp1dS2qEsARkT0tR170iyzbApaJWYVSCG5PE0uWjCGhDXROHC8tZQtbjXekagK
         jLeJpqLu/VEoxoga8SzsuZ3j0uWfGSCyQZ1IQrko48eTfqMzvFb1x+CmhPmbU/TFIRpw
         IBfq0zN0oXdYJcYyJgEqVQT1+Iutcu6RpIrJbHVlydUTOFjfZhNPcQBLcLz3AWjpwwV9
         Fd259j4L8LcrnJnyR8TJoJ6xQJ9srT9e5wZFIRXI6UXeEiK/WBvjaPYnPWuKA4WpuS2j
         774Q==
X-Gm-Message-State: AOAM530LjxUg/dO6cQS+2vkRnH7paJ3BimB3iIO4ODBgr5BX/N4ZrHc2
        0ipLJIrEy6EyZiSE4zX3zovTOl1vSHQDYU6+1wm2iw==
X-Google-Smtp-Source: ABdhPJwFVmz6RcyS9btj/o1ZoybvFtU4h2ot2/ATLJyzYvOdSTHlqVpOgczeC9S/D+0ST2v4E6oNv/tLBiH0Fcx36+k=
X-Received: by 2002:a19:8c1a:0:b0:472:315:48db with SMTP id
 o26-20020a198c1a000000b00472031548dbmr13897928lfd.235.1652129626813; Mon, 09
 May 2022 13:53:46 -0700 (PDT)
MIME-Version: 1.0
References: <20220422210546.458943-1-dmatlack@google.com> <20220422210546.458943-6-dmatlack@google.com>
 <YnRLVB+t0bLBeu+/@google.com>
In-Reply-To: <YnRLVB+t0bLBeu+/@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Mon, 9 May 2022 13:53:20 -0700
Message-ID: <CALzav=cRwx2qSvtt1r=4W1b81jTjVMA4rZBxbtrmCwd_91__yg@mail.gmail.com>
Subject: Re: [PATCH v4 05/20] KVM: x86/mmu: Consolidate shadow page allocation
 and initialization
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
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 5, 2022 at 3:10 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Fri, Apr 22, 2022, David Matlack wrote:
> > Consolidate kvm_mmu_alloc_page() and kvm_mmu_alloc_shadow_page() under
> > the latter so that all shadow page allocation and initialization happens
> > in one place.
> >
> > No functional change intended.
> >
> > Signed-off-by: David Matlack <dmatlack@google.com>
> > ---
> >  arch/x86/kvm/mmu/mmu.c | 39 +++++++++++++++++----------------------
> >  1 file changed, 17 insertions(+), 22 deletions(-)
> >
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 5582badf4947..7d03320f6e08 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -1703,27 +1703,6 @@ static void drop_parent_pte(struct kvm_mmu_page *sp,
> >       mmu_spte_clear_no_track(parent_pte);
> >  }
> >
> > -static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu, bool direct)
> > -{
> > -     struct kvm_mmu_page *sp;
> > -
> > -     sp = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_page_header_cache);
> > -     sp->spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);
> > -     if (!direct)
> > -             sp->gfns = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_gfn_array_cache);
> > -     set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
> > -
> > -     /*
> > -      * active_mmu_pages must be a FIFO list, as kvm_zap_obsolete_pages()
> > -      * depends on valid pages being added to the head of the list.  See
> > -      * comments in kvm_zap_obsolete_pages().
> > -      */
> > -     sp->mmu_valid_gen = vcpu->kvm->arch.mmu_valid_gen;
> > -     list_add(&sp->link, &vcpu->kvm->arch.active_mmu_pages);
> > -     kvm_mod_used_mmu_pages(vcpu->kvm, +1);
> > -     return sp;
> > -}
> > -
> >  static void mark_unsync(u64 *spte);
> >  static void kvm_mmu_mark_parents_unsync(struct kvm_mmu_page *sp)
> >  {
> > @@ -2100,7 +2079,23 @@ static struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm_vcpu *vcpu,
> >                                                     struct hlist_head *sp_list,
> >                                                     union kvm_mmu_page_role role)
> >  {
> > -     struct kvm_mmu_page *sp = kvm_mmu_alloc_page(vcpu, role.direct);
> > +     struct kvm_mmu_page *sp;
> > +
> > +     sp = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_page_header_cache);
> > +     sp->spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);
> > +     if (!role.direct)
> > +             sp->gfns = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_gfn_array_cache);
> > +
> > +     set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
> > +
> > +     /*
> > +      * active_mmu_pages must be a FIFO list, as kvm_zap_obsolete_pages()
> > +      * depends on valid pages being added to the head of the list.  See
> > +      * comments in kvm_zap_obsolete_pages().
> > +      */
> > +     sp->mmu_valid_gen = vcpu->kvm->arch.mmu_valid_gen;
> > +     list_add(&sp->link, &vcpu->kvm->arch.active_mmu_pages);
> > +     kvm_mod_used_mmu_pages(vcpu->kvm, +1);
>
> To reduce churn later on, what about opportunistically grabbing vcpu->kvm in a
> local variable in this patch?
>
> Actually, at that point, it's a super trivial change, so you can probably just drop
>
>         KVM: x86/mmu: Replace vcpu with kvm in kvm_mmu_alloc_shadow_page()
>
> and do the vcpu/kvm swap as part of
>
>         KVM: x86/mmu: Pass memory caches to allocate SPs separately

I'm not sure it's any less churn, it's just doing the same amount of
changes in fewer commits. Is there a benefit of using less commits? I
can only think of downsides (harder to review, harder to bisect).

>
> >       sp->gfn = gfn;
> >       sp->role = role;
> > --
> > 2.36.0.rc2.479.g8af0fa9b8e-goog
> >
