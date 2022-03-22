Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2BD84E4960
	for <lists+kvm@lfdr.de>; Tue, 22 Mar 2022 23:52:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238501AbiCVWxw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Mar 2022 18:53:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbiCVWxv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Mar 2022 18:53:51 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBA0F5DE53
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 15:52:22 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id w7so32240152lfd.6
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 15:52:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WvvHbaLzRYu7wKbKBkm0f3RCm6Tn7L9LKo6nWKndQoM=;
        b=IeY+8LZbgT5WN7RXZk7eh5d4wwEgng3XBSCniMnT9QQ7QynNJwZl7uqW7IKmQbo57i
         9WsPaoXnjD8RCC9dMJB2euDfnWOanl9VNI5e72UmnBkRwmDoIKf2X+UGaOYLgaXrQHUy
         RILbd+Y2hFukTlo6qBE9n95ArzhdO1ynnb7dT9o+uTxioSnIM2113VbgYH4kxLeiy2Yk
         wLRr3byfZRvARMnc1IHMc7Kb1nmIm278w00qMLp9kgcTtYRuy2IqBS9AxlsuczMBGoHZ
         S1bsn1pIYGuQI/BJQXmQvaI4b6yZK2RE/eASsco4xU31oK99EL3IlMefS9t6EbdC4+4L
         TQTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WvvHbaLzRYu7wKbKBkm0f3RCm6Tn7L9LKo6nWKndQoM=;
        b=fpBr2a4VqeMd+TBah9G4nyP22/xWRIbzFMh1B4n+757csGwpIDwaL9+cGztKVUwfnj
         Em1KOlTfLrD6NQX7LVr4SobaVLwj/LQWtndveNULRW/0IDsGjvGXWl4LjxudlD7N0QxA
         FT7csfgv1woW8HjT29EGMILtd3GUCida79YEjIYxstDZjWrX4z7MdcDVIVqmaUasWNu4
         xVliPORpj9xZrLJgjh7fQQJr5ZwS5s/iUvEJ0cmvHioeXulo1wmTNLdjll18nzCvNnvr
         R5RUK6DrjgZlYYAXZM04C2czHymXkQ/qSfcYUhLYEtvaMMN8OYz7UyRmpyxuWltOsnUO
         0Ing==
X-Gm-Message-State: AOAM530N0wIyfumfene8wj78uqwFasRtGXVNydd5k+2uFUTNYgycIbWy
        VSZuBVdwobzZ5Uoge6/r9ZpilZRAzdnhvRceSRuPiA==
X-Google-Smtp-Source: ABdhPJwI/z0/a17reQN2zQe+86LABc5jxg23lp5/QgxLJAcsYtyoxn6igiqHu+q8XWGSRty2B7/wG5HPsWsQkXUiGVs=
X-Received: by 2002:a05:6512:128e:b0:44a:4067:9ffe with SMTP id
 u14-20020a056512128e00b0044a40679ffemr3043386lfs.64.1647989540978; Tue, 22
 Mar 2022 15:52:20 -0700 (PDT)
MIME-Version: 1.0
References: <20220311002528.2230172-1-dmatlack@google.com> <20220311002528.2230172-17-dmatlack@google.com>
 <YjGgjTnP/9sG8L+2@xz-m1.local>
In-Reply-To: <YjGgjTnP/9sG8L+2@xz-m1.local>
From:   David Matlack <dmatlack@google.com>
Date:   Tue, 22 Mar 2022 15:51:54 -0700
Message-ID: <CALzav=fZQYC7YyTbZqbkYTYVUXCq4skc6pkQ2S59BoSxbkKUhw@mail.gmail.com>
Subject: Re: [PATCH v2 16/26] KVM: x86/mmu: Cache the access bits of shadowed translations
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
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 16, 2022 at 1:32 AM Peter Xu <peterx@redhat.com> wrote:
>
> On Fri, Mar 11, 2022 at 12:25:18AM +0000, David Matlack wrote:
> > In order to split a huge page we need to know what access bits to assign
> > to the role of the new child page table. This can't be easily derived
> > from the huge page SPTE itself since KVM applies its own access policies
> > on top, such as for HugePage NX.
> >
> > We could walk the guest page tables to determine the correct access
> > bits, but that is difficult to plumb outside of a vCPU fault context.
> > Instead, we can store the original access bits for each leaf SPTE
> > alongside the GFN in the gfns array. The access bits only take up 3
> > bits, which leaves 61 bits left over for gfns, which is more than
> > enough. So this change does not require any additional memory.
>
> I have a pure question on why eager page split needs to worry on hugepage
> nx..
>
> IIUC that was about forbidden huge page being mapped as executable.  So
> afaiu the only missing bit that could happen if we copy over the huge page
> ptes is the executable bit.
>
> But then?  I think we could get a page fault on fault->exec==true on the
> split small page (because when we copy over it's cleared, even though the
> page can actually be executable), but it should be well resolved right
> after that small page fault.
>
> The thing is IIUC this is a very rare case, IOW, it should mostly not
> happen in 99% of the use case?  And there's a slight penalty when it
> happens, but only perf-wise.
>
> As I'm not really fluent with the code base, perhaps I missed something?

You're right that we could get away with not knowing the shadowed
access permissions to assign to the child SPTEs when splitting a huge
SPTE. We could just copy the huge SPTE access permissions and then let
the execute bit be repaired on fault (although those faults would be a
performance cost).

But the access permissions are also needed to lookup an existing
shadow page (or create a new shadow page) to use to split the huge
page. For example, let's say we are going to split a huge page that
does not have execute permissions enabled. That could be because NX
HugePages are enabled or because we are shadowing a guest translation
that does not allow execution (or both). We wouldn't want to propagate
the no-execute permission into the child SP role.access if the
shadowed translation really does allow execution (and vice versa).

>
> >
> > In order to keep the access bit cache in sync with the guest, we have to
> > extend FNAME(sync_page) to also update the access bits.
>
> Besides sync_page(), I also see that in mmu_set_spte() there's a path that
> we will skip the rmap_add() if existed:
>
>         if (!was_rmapped) {
>                 WARN_ON_ONCE(ret == RET_PF_SPURIOUS);
>                 kvm_update_page_stats(vcpu->kvm, level, 1);
>                 rmap_add(vcpu, slot, sptep, gfn);
>         }
>
> I didn't check, but it's not obvious whether the sync_page() change here
> will cover all of the cases, hence raise this up too.

Good catch. I will need to dig into this more to confirm but I think
you might be right.

>
> >
> > Now that the gfns array caches more information than just GFNs, rename
> > it to shadowed_translation.
> >
> > Signed-off-by: David Matlack <dmatlack@google.com>
> > ---
> >  arch/x86/include/asm/kvm_host.h |  2 +-
> >  arch/x86/kvm/mmu/mmu.c          | 32 +++++++++++++++++++-------------
> >  arch/x86/kvm/mmu/mmu_internal.h | 15 +++++++++++++--
> >  arch/x86/kvm/mmu/paging_tmpl.h  |  7 +++++--
> >  4 files changed, 38 insertions(+), 18 deletions(-)
> >
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index f72e80178ffc..0f5a36772bdc 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -694,7 +694,7 @@ struct kvm_vcpu_arch {
> >
> >       struct kvm_mmu_memory_cache mmu_pte_list_desc_cache;
> >       struct kvm_mmu_memory_cache mmu_shadow_page_cache;
> > -     struct kvm_mmu_memory_cache mmu_gfn_array_cache;
> > +     struct kvm_mmu_memory_cache mmu_shadowed_translation_cache;
>
> I'd called it with a shorter name.. :) maybe mmu_shadowed_info_cache?  No
> strong opinion.
>
> >       struct kvm_mmu_memory_cache mmu_page_header_cache;
> >
> >       /*
>
> [...]
>
> > diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> > index b6e22ba9c654..c5b8ee625df7 100644
> > --- a/arch/x86/kvm/mmu/mmu_internal.h
> > +++ b/arch/x86/kvm/mmu/mmu_internal.h
> > @@ -32,6 +32,11 @@ extern bool dbg;
> >
> >  typedef u64 __rcu *tdp_ptep_t;
> >
> > +struct shadowed_translation_entry {
> > +     u64 access:3;
> > +     u64 gfn:56;
>
> Why 56?

I was going for the theoretical maximum number of bits for a GFN. But
that would be 64 - 12 = 52... so I'm not sure what I was thinking
here.

I'll switch it to 52 and add a comment.

>
> > +};
>
> Thanks,
>
> --
> Peter Xu
>
