Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82360520691
	for <lists+kvm@lfdr.de>; Mon,  9 May 2022 23:18:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229799AbiEIVWt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 May 2022 17:22:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbiEIVWr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 May 2022 17:22:47 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EFDF27E3FE
        for <kvm@vger.kernel.org>; Mon,  9 May 2022 14:18:48 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id h29so26039054lfj.2
        for <kvm@vger.kernel.org>; Mon, 09 May 2022 14:18:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qchi2ovSlwKNdfNz60pRFkmAP/3ewU4lfp3vcRbEGlU=;
        b=eGkU5zTgJUYc8R/bZEvWar9PD0laWJPybiJLqeTwEWYl2flllTcBFbyTo8+oUobAU0
         tWqbrVzupUWUPQ/oEqKFrKkzApM/460q/sBtENEj+svMZC8kN83hBsoV4yIY3D0n+zEG
         cZzlHhUBiUjcWD7ssehHMrg3q1WJTlyGGu0bJLZU2+398Xu4LmELv4nT0n4ltD2TkSar
         l/2zfb86pt9JP3jHi4970ZSAqcirzMd5Dal58pESMXboHZQoPjOrYjod979tp2ffWSY9
         0xKViGZqjX/ynl44ibcdsbVQhptbZe/DypzKucGQve8F4kKGLohzTEJey8jUFc95+8x2
         iUSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qchi2ovSlwKNdfNz60pRFkmAP/3ewU4lfp3vcRbEGlU=;
        b=bhmFQrXU75bGCg8JHGJuP4HbnTlbZ2Q0dSWClylIBFhpfGyKInHTYy3GoLSBfRZPDy
         Eqpy21/4kzY+M1irCakmyrfsdc0EFQo8VxPtPl1PH8wUmk+XXUGM55YHw9FjvavBx8/k
         8F2qi9m9NjiIOZieUqtPL1Ec00QRgTwZ75RtNpcTPrF5Xv1jue5ehRg70q4+SJv3+7fE
         T2gXvTdfY6ZE1aIjPaq+zSj8EhvD3FHd2U7jgrE43mo5ojtizYKgLMaQi2KluNWGTHBE
         XRntzzmz6BjBWOLshHblQ9cZ7HE0iGJ4uehlZeUM9b4cpYMOwIi+7lhMAMWvB1IISxqw
         VBmw==
X-Gm-Message-State: AOAM533jNbXMBDZuQbAZfflfROT5kxSMy5EnWmVYjW3ZbO0xEGeHEzFp
        gbXX6Rg53K7nubF1zKC7ItFdEFZSR75AamGVN09yuUSDu8k=
X-Google-Smtp-Source: ABdhPJyvz4bFX6ByxPxugEVcuzVcqYiTBrRxjECVFhA951epTBmdMiUFM07b6t6SQS/Z5WmLCW6hDwUciKFtbEvVsLk=
X-Received: by 2002:ac2:4c54:0:b0:473:a414:1768 with SMTP id
 o20-20020ac24c54000000b00473a4141768mr13933301lfk.537.1652131126435; Mon, 09
 May 2022 14:18:46 -0700 (PDT)
MIME-Version: 1.0
References: <20220422210546.458943-1-dmatlack@google.com> <20220422210546.458943-8-dmatlack@google.com>
 <YnRU+zN9T8Zf91Ei@google.com>
In-Reply-To: <YnRU+zN9T8Zf91Ei@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Mon, 9 May 2022 14:18:20 -0700
Message-ID: <CALzav=cU8dsXjZy2eUdQ-eA7BBsXU6PaPDepNmmF=sp=Z0xJ4A@mail.gmail.com>
Subject: Re: [PATCH v4 07/20] KVM: x86/mmu: Move guest PT write-protection to account_shadowed()
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

On Thu, May 5, 2022 at 3:51 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Fri, Apr 22, 2022, David Matlack wrote:
> > Move the code that write-protects newly-shadowed guest page tables into
> > account_shadowed(). This avoids a extra gfn-to-memslot lookup and is a
> > more logical place for this code to live. But most importantly, this
> > reduces kvm_mmu_alloc_shadow_page()'s reliance on having a struct
> > kvm_vcpu pointer, which will be necessary when creating new shadow pages
> > during VM ioctls for eager page splitting.
> >
> > Note, it is safe to drop the role.level == PG_LEVEL_4K check since
> > account_shadowed() returns early if role.level > PG_LEVEL_4K.
> >
> > No functional change intended.
> >
> > Signed-off-by: David Matlack <dmatlack@google.com>
> > ---
>
> Reviewed-by: Sean Christopherson <seanjc@google.com>
>
> >  arch/x86/kvm/mmu/mmu.c | 9 +++++----
> >  1 file changed, 5 insertions(+), 4 deletions(-)
> >
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index fa7846760887..4f894db88bbf 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -807,6 +807,9 @@ static void account_shadowed(struct kvm *kvm, struct kvm_mmu_page *sp)
> >                                                   KVM_PAGE_TRACK_WRITE);
> >
> >       kvm_mmu_gfn_disallow_lpage(slot, gfn);
> > +
> > +     if (kvm_mmu_slot_gfn_write_protect(kvm, slot, gfn, PG_LEVEL_4K))
> > +             kvm_flush_remote_tlbs_with_address(kvm, gfn, 1);
> >  }
> >
> >  void account_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp)
> > @@ -2100,11 +2103,9 @@ static struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm_vcpu *vcpu,
> >       sp->gfn = gfn;
> >       sp->role = role;
> >       hlist_add_head(&sp->hash_link, sp_list);
> > -     if (!role.direct) {
> > +
> > +     if (!role.direct)
> >               account_shadowed(vcpu->kvm, sp);
> > -             if (role.level == PG_LEVEL_4K && kvm_vcpu_write_protect_gfn(vcpu, gfn))
>
> Huh.  Two thoughts.
>
> 1. Can you add a patch to drop kvm_vcpu_write_protect_gfn() entirely, i.e. convert
>    mmu_sync_children() to use kvm_mmu_slot_gfn_write_protect?  It's largely a moot
>    point, but only because mmu_sync_children() only operates on shadow pages that
>    are relevant to the current non-SMM/SMM role.  And _that_ holds true only because
>    KVM does kvm_mmu_reset_context() and drops roots for the vCPU on SMM transitions.
>
>    That'd be a good oppurtunity to move this pair into a helper:
>
>         slots = kvm_memslots_for_spte_role(kvm, sp->role);
>         slot = __gfn_to_memslot(slots, gfn);

Sounds reasonable but let's do that in a separate series since this is
already on v4 and I wouldn't say it's obvious that using the role to
get the memslot will give the same result as using the vCPU, although
that does look to be true.

>
> 2. This got me thinking...  Write-protecting for shadow paging should NOT be
>    associated with the vCPU or even the role.  The SMM memslots conceptually
>    operate on the same guest physical memory, SMM is just given access to memory
>    that is not present in the non-SMM memslots.
>
>    If KVM creates SPTEs for non-SMM, then it needs to write-protect _all_ memslots
>    that contain the relevant gfn, e.g. if the guest takes an SMI and modifies the
>    non-SMM page tables, then KVM needs trap and emulate (or unsync) those writes.
>
>    The mess "works" because no sane SMM handler (kind of a contradiction in terms)
>    will modify non-SMM page tables, and vice versa.
>
>    The entire duplicate memslots approach is flawed.  Better would have been to
>    make SMM a flag and hide SMM-only memslots, not duplicated everything...
>
> > -                     kvm_flush_remote_tlbs_with_address(vcpu->kvm, gfn, 1);
> > -     }
> >
> >       return sp;
> >  }
> > --
> > 2.36.0.rc2.479.g8af0fa9b8e-goog
> >
