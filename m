Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3ADEF4E48DE
	for <lists+kvm@lfdr.de>; Tue, 22 Mar 2022 23:06:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237405AbiCVWHk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Mar 2022 18:07:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237398AbiCVWHj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Mar 2022 18:07:39 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA8765F8DD
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 15:06:07 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id 25so25831060ljv.10
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 15:06:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dDctWXCZdyM5GB7RYASY+je0HYc47y70gOwl8FZOZm4=;
        b=smB2FXdWY0kivKSxas6WhCBIsILQplewNHqP+jCt4AUSWLy/pM2Sqmxa9Vs2b0ddnb
         rysEStWa6DxMu8bCjQoFwFIonkuFBXpcUjSFGIv8ZeKAn7cNKdA3Qn3I3TQG6nhRmz2T
         NG6nR/8T1pwaXdKdWGeKeW6u71IaPmZKO5IUsHHdC1pZPr2GQHbD8YwfMU+8YcYnBoDU
         TcNIBUyP1NQYItJFFYI7W5O7hgFQJpfjqOXWE7e7T90a42b8Yvzfde7AeBvNfktwdgVr
         IVyxA3N7oEsLuXfO91CfQGWGZdyB/gLypP6qaFz3j3yN2qEyvXDRBsa/iwKjJzg6sxc5
         2BJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dDctWXCZdyM5GB7RYASY+je0HYc47y70gOwl8FZOZm4=;
        b=Hsa4pNrLIYLo0I1fsehGDmNDT2Y6A+dV8FLZPISRc1GtY0nR9Ylayqu15AQqRhfhTs
         QjjkDxWhsEqGSTYRX0FM+0rCpLVsfCiDVvIzJwHAo/XnRhTJSOl0AKeqy4l3n99ratN8
         Jfx55AEybhCHRgUhQu38T1aaFpsVb7FG5ZTJzREpQR9GyhjXGTcRm5xedLoWT7xJcZXH
         EI2wUqab4dVnwK7014f/cujLSM9+4Fqvvv092iP+Mz7RkPNSgD1ihHd9VCPNsdEmUmGg
         zqP8u7Jqg4tThf+GMUknhgc2Y0EdJnVB1JSxfpRBII8IU3VHekxIHwHUdumNSf6D06jh
         UjMg==
X-Gm-Message-State: AOAM533soLlI8CK8fFxcXHu5+tVvpKVy710eCKA9SMI13bK6m3Etyu4a
        ElcxAwyRymcx/C7+sus4d/OLdVRM/vKpfEWVcK2kag==
X-Google-Smtp-Source: ABdhPJynK/JJXFYQj2VAWjdUhNJu91ZGpwnFDHqBcP8k3VgI99deds+U0mT8GuZkBk87T+opYdYujghah01FAEA+v/g=
X-Received: by 2002:a2e:8255:0:b0:247:dff4:1f with SMTP id j21-20020a2e8255000000b00247dff4001fmr20905527ljh.16.1647986766015;
 Tue, 22 Mar 2022 15:06:06 -0700 (PDT)
MIME-Version: 1.0
References: <20220311002528.2230172-1-dmatlack@google.com> <20220311002528.2230172-7-dmatlack@google.com>
 <YjBWdv3nEk3Cz40m@xz-m1.local>
In-Reply-To: <YjBWdv3nEk3Cz40m@xz-m1.local>
From:   David Matlack <dmatlack@google.com>
Date:   Tue, 22 Mar 2022 15:05:39 -0700
Message-ID: <CALzav=dmfFNvitGvO-RCnxmqHpSiQN68JV6Q+UTem8Wfwma+wA@mail.gmail.com>
Subject: Re: [PATCH v2 06/26] KVM: x86/mmu: Pass memslot to kvm_mmu_new_shadow_page()
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

On Tue, Mar 15, 2022 at 2:04 AM Peter Xu <peterx@redhat.com> wrote:
>
> On Fri, Mar 11, 2022 at 12:25:08AM +0000, David Matlack wrote:
> > Passing the memslot to kvm_mmu_new_shadow_page() avoids the need for the
> > vCPU pointer when write-protecting indirect 4k shadow pages. This moves
> > us closer to being able to create new shadow pages during VM ioctls for
> > eager page splitting, where there is not vCPU pointer.
> >
> > This change does not negatively impact "Populate memory time" for ept=Y
> > or ept=N configurations since kvm_vcpu_gfn_to_memslot() caches the last
> > use slot. So even though we now look up the slot more often, it is a
> > very cheap check.
> >
> > Opportunistically move the code to write-protect GFNs shadowed by
> > PG_LEVEL_4K shadow pages into account_shadowed() to reduce indentation
> > and consolidate the code. This also eliminates a memslot lookup.
> >
> > No functional change intended.
> >
> > Signed-off-by: David Matlack <dmatlack@google.com>
> > ---
> >  arch/x86/kvm/mmu/mmu.c | 23 ++++++++++++-----------
> >  1 file changed, 12 insertions(+), 11 deletions(-)
> >
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index b6fb50e32291..519910938478 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -793,16 +793,14 @@ void kvm_mmu_gfn_allow_lpage(const struct kvm_memory_slot *slot, gfn_t gfn)
> >       update_gfn_disallow_lpage_count(slot, gfn, -1);
> >  }
> >
> > -static void account_shadowed(struct kvm *kvm, struct kvm_mmu_page *sp)
> > +static void account_shadowed(struct kvm *kvm,
> > +                          struct kvm_memory_slot *slot,
> > +                          struct kvm_mmu_page *sp)
> >  {
> > -     struct kvm_memslots *slots;
> > -     struct kvm_memory_slot *slot;
> >       gfn_t gfn;
> >
> >       kvm->arch.indirect_shadow_pages++;
> >       gfn = sp->gfn;
> > -     slots = kvm_memslots_for_spte_role(kvm, sp->role);
> > -     slot = __gfn_to_memslot(slots, gfn);
> >
> >       /* the non-leaf shadow pages are keeping readonly. */
> >       if (sp->role.level > PG_LEVEL_4K)
> > @@ -810,6 +808,9 @@ static void account_shadowed(struct kvm *kvm, struct kvm_mmu_page *sp)
> >                                                   KVM_PAGE_TRACK_WRITE);
> >
> >       kvm_mmu_gfn_disallow_lpage(slot, gfn);
> > +
> > +     if (kvm_mmu_slot_gfn_write_protect(kvm, slot, gfn, PG_LEVEL_4K))
> > +             kvm_flush_remote_tlbs_with_address(kvm, gfn, 1);
>
> It's not immediately obvious in this diff, but when looking at the code
> yeah it looks right to just drop the 4K check..

Yeah it's a bit subtle but (as you probably noticed) account_shadowed()
returns early if the level is above PG_LEVEL_4K.


>
> I also never understood why we only write-track the >1 levels but only
> wr-protect the last level.  It'll be great if there's quick answer from
> anyone.. even though it's probably unrelated to the patch.
>
> The change looks all correct:
>
> Reviewed-by: Peter Xu <peterx@redhat.com>
>
> Thanks,
>
> --
> Peter Xu
>
