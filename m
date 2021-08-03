Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B258A3DE3EB
	for <lists+kvm@lfdr.de>; Tue,  3 Aug 2021 03:19:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233212AbhHCBTj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Aug 2021 21:19:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233148AbhHCBTj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Aug 2021 21:19:39 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 021B7C06175F;
        Mon,  2 Aug 2021 18:19:29 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id c3so18187265ilh.3;
        Mon, 02 Aug 2021 18:19:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=u9hZlNEVQtl9H4h5fUtoarYkmhlyAeJcak16DpUZk5w=;
        b=XP074fISHdgNdmqlBDocoFPPOyy3Ag4vr397lUiFsl78eXaEeoy056KI89cuLstmPT
         af+v8NtkcdxGgVDmFDb0jSl9ndPRl/XPasHsyX9PnFCkpKm/5L5Dk03TNtT6I41cgv/2
         gUFk/22SzlBl+HbudPWXGDLLHmS4E3O9HuXNFBw8UWbLTTwRY9WDIBYpS4A3H+nToLd8
         5oqi/H3AtAesgGjq4cb6o389lE0OW3kwKB5ZUnbZKKPjEjCri8Oe9eeU7CYgdxiw0Mfx
         b+MeqNbxuMpRQqtO2il/c5zlpX3tCYN+R3HfXnNIFB0pTi75itEaP6x8bwjOcK/sEw5x
         pTVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=u9hZlNEVQtl9H4h5fUtoarYkmhlyAeJcak16DpUZk5w=;
        b=B9heoFLM32kv+U1cPR3JYMqVT9YjMYSOwHOzqLJtaMzfQ6Tj4hUvmAAClyunl9/fop
         //1A1HczbNkQJrJWBGQ8QGUO/XrjyKSG8dVbLgIRKJmp2DGUdzD2+SGhgczocAAW0IKa
         Y0iuLa9P1E4q6xcuK45goGhrr9ROIQl4nRdqr/8cE2k16HK5ZUnXuf9RPPFznr3Ookj2
         1beMfH8dYFKAMBzEv60Hdp8s+7KRlGXshcrX/M7uGJI/ehD/VIr8Wim8rOWEMkNtaBHv
         JqZXL1f1IQ9g9YJPG1b+nUJF/pOmuwKXCpkEoW9KaHtM3idSZG4LOUAtW1uMe7QIZBmI
         Eu7Q==
X-Gm-Message-State: AOAM530/eboP1I5tyS2dmUZ8dbUHbeqlhU07RGvwhASu0sBIcnF/LiQJ
        wILROqm8w5JBYM3UBZ7qojwsZSqhJBs5FMqIHPA=
X-Google-Smtp-Source: ABdhPJwO2whEKVXD9FpKYTgzaF0VMeJTZBR6Hxntfmj81J5yV0DJZTUjbOkVVNzO+vANYCpIVcApLDWdrer3qTE3STA=
X-Received: by 2002:a05:6e02:b43:: with SMTP id f3mr613726ilu.94.1627953568399;
 Mon, 02 Aug 2021 18:19:28 -0700 (PDT)
MIME-Version: 1.0
References: <20210525213920.3340-1-jiangshanlai@gmail.com> <YQLuBDZ2MlNlIoH4@google.com>
In-Reply-To: <YQLuBDZ2MlNlIoH4@google.com>
From:   Lai Jiangshan <jiangshanlai@gmail.com>
Date:   Tue, 3 Aug 2021 09:19:17 +0800
Message-ID: <CAJhGHyCU-Om3NWLVg-kbUE7FZD1nNZft8+KeCDH3cr_FDaitXQ@mail.gmail.com>
Subject: Re: [RFC PATCH] kvm/x86: Keep root hpa in prev_roots as much as possible
To:     Sean Christopherson <seanjc@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Lai Jiangshan <laijs@linux.alibaba.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 30, 2021 at 2:06 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Wed, May 26, 2021, Lai Jiangshan wrote:
> > From: Lai Jiangshan <laijs@linux.alibaba.com>
> >
> > Pagetable roots in prev_roots[] are likely to be reused soon and
> > there is no much overhead to keep it with a new need_sync field
> > introduced.
> >
> > With the help of the new need_sync field, pagetable roots are
> > kept as much as possible, and they will be re-synced before reused
> > instead of being dropped.
> >
> > Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
> > ---
> >
> > This patch is just for RFC.
> >   Is the idea Ok?
>
> Yes, the idea is definitely a good one.
>
> >   If the idea is Ok, we need to reused one bit from pgd or hpa
> >     as need_sync to save memory.  Which one is better?
>
> Ha, we can do this without increasing the memory footprint and without co-opting
> a bit from pgd or hpa.  Because of compiler alignment/padding, the u8s and bools
> between mmu_role and prev_roots already occupy 8 bytes, even though the actual
> size is 4 bytes.  In total, we need room for 4 roots (3 previous + current), i.e.
> 4 bytes.  If a separate array is used, no additional memory is consumed and no
> masking is needed when reading/writing e.g. pgd.
>
> The cost is an extra swap() when updating the prev_roots LRU, but that's peanuts
> and would likely be offset by masking anyways.
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 99f37781a6fc..13bb3c3a60b4 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -424,10 +424,12 @@ struct kvm_mmu {
>         hpa_t root_hpa;
>         gpa_t root_pgd;
>         union kvm_mmu_role mmu_role;
> +       bool root_unsync;
>         u8 root_level;
>         u8 shadow_root_level;
>         u8 ept_ad;
>         bool direct_map;
> +       bool unsync_roots[KVM_MMU_NUM_PREV_ROOTS];
>         struct kvm_mmu_root_info prev_roots[KVM_MMU_NUM_PREV_ROOTS];
>

Hello

I think it is too complicated.  And it is hard to accept to put "unsync"
out of struct kvm_mmu_root_info when they should be bound to each other.

How about this:
- KVM_MMU_NUM_PREV_ROOTS
+ KVM_MMU_NUM_CACHED_ROOTS
- mmu->prev_roots[KVM_MMU_NUM_PREV_ROOTS]
+ mmu->cached_roots[KVM_MMU_NUM_CACHED_ROOTS]
- mmu->root_hpa
+ mmu->cached_roots[0].hpa
- mmu->root_pgd
+ mmu->cached_roots[0].pgd

And using the bit63 in @pgd as the information that it is not requested
to sync since the last sync.

Thanks
Lai.

>         /*
>
>
> >  arch/x86/include/asm/kvm_host.h |  3 ++-
> >  arch/x86/kvm/mmu/mmu.c          |  6 ++++++
> >  arch/x86/kvm/vmx/nested.c       | 12 ++++--------
> >  arch/x86/kvm/x86.c              |  9 +++++----
> >  4 files changed, 17 insertions(+), 13 deletions(-)
> >
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index 55efbacfc244..19a337cf7aa6 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -354,10 +354,11 @@ struct rsvd_bits_validate {
> >  struct kvm_mmu_root_info {
> >       gpa_t pgd;
> >       hpa_t hpa;
> > +     bool need_sync;
>
> Hmm, use "unsync" instead of "need_sync", purely to match the existing terminology
> in KVM's MMU for this sort of behavior.
>
> >  };
> >
> >  #define KVM_MMU_ROOT_INFO_INVALID \
> > -     ((struct kvm_mmu_root_info) { .pgd = INVALID_PAGE, .hpa = INVALID_PAGE })
> > +     ((struct kvm_mmu_root_info) { .pgd = INVALID_PAGE, .hpa = INVALID_PAGE, .need_sync = true})
> >
> >  #define KVM_MMU_NUM_PREV_ROOTS 3
> >
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 5e60b00e8e50..147827135549 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -3878,6 +3878,7 @@ static bool cached_root_available(struct kvm_vcpu *vcpu, gpa_t new_pgd,
> >
> >       root.pgd = mmu->root_pgd;
> >       root.hpa = mmu->root_hpa;
> > +     root.need_sync = false;
> >
> >       if (is_root_usable(&root, new_pgd, new_role))
> >               return true;
> > @@ -3892,6 +3893,11 @@ static bool cached_root_available(struct kvm_vcpu *vcpu, gpa_t new_pgd,
> >       mmu->root_hpa = root.hpa;
> >       mmu->root_pgd = root.pgd;
> >
> > +     if (i < KVM_MMU_NUM_PREV_ROOTS && root.need_sync) {
>
> Probably makes sense to write this as:
>
>         if (i >= KVM_MMU_NUM_PREV_ROOTS)
>                 return false;
>
>         if (root.need_sync) {
>                 kvm_make_request(KVM_REQ_MMU_SYNC, vcpu);
>                 kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
>         }
>         return true;
>
> The "i < KVM_MMU_NUM_PREV_ROOTS == success" logic is just confusing enough that
> it'd be nice to write it only once.
>
> And that would also play nicely with deferring a sync for the "current" root
> (see below), e.g.
>
>         ...
>         unsync = mmu->root_unsync;
>
>         if (is_root_usable(&root, new_pgd, new_role))
>                 goto found_root;
>
>         for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++) {
>                 swap(root, mmu->prev_roots[i]);
>                 swap(unsync, mmu->unsync_roots[i]);
>
>                 if (is_root_usable(&root, new_pgd, new_role))
>                         break;
>         }
>
>         if (i >= KVM_MMU_NUM_PREV_ROOTS)
>                 return false;
>
> found_root:
>         if (unsync) {
>                 kvm_make_request(KVM_REQ_MMU_SYNC, vcpu);
>                 kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
>         }
>         return true;
>
> > +             kvm_make_request(KVM_REQ_MMU_SYNC, vcpu);
> > +             kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
> > +     }
> > +
> >       return i < KVM_MMU_NUM_PREV_ROOTS;
> >  }
> >
> > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > index 6058a65a6ede..ab7069ac6dc5 100644
> > --- a/arch/x86/kvm/vmx/nested.c
> > +++ b/arch/x86/kvm/vmx/nested.c
> > @@ -5312,7 +5312,7 @@ static int handle_invept(struct kvm_vcpu *vcpu)
> >  {
> >       struct vcpu_vmx *vmx = to_vmx(vcpu);
> >       u32 vmx_instruction_info, types;
> > -     unsigned long type, roots_to_free;
> > +     unsigned long type;
> >       struct kvm_mmu *mmu;
> >       gva_t gva;
> >       struct x86_exception e;
> > @@ -5361,29 +5361,25 @@ static int handle_invept(struct kvm_vcpu *vcpu)
> >                       return nested_vmx_fail(vcpu,
> >                               VMXERR_INVALID_OPERAND_TO_INVEPT_INVVPID);
> >
> > -             roots_to_free = 0;
> >               if (nested_ept_root_matches(mmu->root_hpa, mmu->root_pgd,
> >                                           operand.eptp))
> > -                     roots_to_free |= KVM_MMU_ROOT_CURRENT;
> > +                     kvm_mmu_free_roots(vcpu, mmu, KVM_MMU_ROOT_CURRENT);
>
> For a non-RFC series, I think this should do two things:
>
>   1. Separate INVEPT from INVPCID, i.e. do only INVPCID first.
>   2. Enhance INVEPT to SYNC+FLUSH the current root instead of freeing it
>
> As alluded to above, this can be done by deferring the sync+flush (which can't
> be done right away because INVEPT runs in L1 context, whereas KVM needs to sync+flush
> L2 EPT context).
>
> >               for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++) {
> >                       if (nested_ept_root_matches(mmu->prev_roots[i].hpa,
> >                                                   mmu->prev_roots[i].pgd,
> >                                                   operand.eptp))
> > -                             roots_to_free |= KVM_MMU_ROOT_PREVIOUS(i);
> > +                             mmu->prev_roots[i].need_sync = true;
> >               }
> >               break;
> >       case VMX_EPT_EXTENT_GLOBAL:
> > -             roots_to_free = KVM_MMU_ROOTS_ALL;
> > +             kvm_mmu_free_roots(vcpu, mmu, KVM_MMU_ROOTS_ALL);
> >               break;
> >       default:
> >               BUG();
> >               break;
> >       }
> >
> > -     if (roots_to_free)
> > -             kvm_mmu_free_roots(vcpu, mmu, roots_to_free);
> > -
> >       return nested_vmx_succeed(vcpu);
> >  }
