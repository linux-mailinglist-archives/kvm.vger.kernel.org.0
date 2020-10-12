Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DF0528C515
	for <lists+kvm@lfdr.de>; Tue, 13 Oct 2020 01:00:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390956AbgJLXAU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Oct 2020 19:00:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390941AbgJLW7s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Oct 2020 18:59:48 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6790C0613D1
        for <kvm@vger.kernel.org>; Mon, 12 Oct 2020 15:59:47 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id q9so19491607iow.6
        for <kvm@vger.kernel.org>; Mon, 12 Oct 2020 15:59:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cNsRLEkySf3v54+YqIeevQ4fb9eVdZRoPO5zed6Njvg=;
        b=J1+jbZmmGQs6PTdls6Glk+YhlKexrpR3t27C8STz3O3vJY3CMk0xd+/zPRRewn9fYU
         A8D5KhRdh4bOmRpqhuu3pWzWv+FHKrc4dQ860B5Da+bN1mqW+X1AigVTImy47Am5AEug
         rGodI/tjj+zuE9b6C++WLf1M9XCGvavdsjANnEU04BtKNGvtZVdQUOj/KnWqEKCZTY07
         UwZBpfhCGooQzcWGduU0SBjZdZKMeAsj7LkzSlN1Nq2OvFvn9HGLdvERsHfW0TEqSw56
         WsL+mcwI2l6q97V23AUH5XHx4es0hxmEiJUWdxpcz2k8urS2hrF2fBZx04IXBxAIIeow
         u75w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cNsRLEkySf3v54+YqIeevQ4fb9eVdZRoPO5zed6Njvg=;
        b=dunb6j/Hp1leyefi3sw3Zl2yiSop/om2ntnPN908LvLZinAxrwcHV6ZccQsoY6okC/
         UpHX6Sf31xtO6ULI6o2epeidoR7eUGZKQ/4CvDuWBjhzVlchX/hmfXcJp6cfiY9gMK8l
         Mfrv42UEEus5E5RaEadibS7eye96k2K28y11PGwBmdfNg93REdIDFbJEclt5gnT2S9mI
         Up5htsbrrCAsxhd1hTGBWDbH91MeZXjzX9Rsp1LMHqqZ+oB44h+OQVdr76gHUouodXjL
         z3HLf0LI3BYcMUq8pMaVqsiEiiq7XOqYXZX+1eUI51HWIMIGMCLuvqqMUK9XeOy6h220
         PImA==
X-Gm-Message-State: AOAM530broOyyHCUlQKQjkHtrUcrrO82zg1Q3c2RfwJKvqJpcgybMjfO
        PWTYW0F6fIHY1/W4T7GVrGq45TWN6CNjHp49oESpPQ==
X-Google-Smtp-Source: ABdhPJy/CL3a+iDKKsZCRVNHyp1AS4/aW/91KE1iht4vaOkv37WURoQ0hLz5TGJNc5vgHWJEVVAIUrIJBvGKO+0HkNg=
X-Received: by 2002:a5d:97c2:: with SMTP id k2mr18626090ios.9.1602543586731;
 Mon, 12 Oct 2020 15:59:46 -0700 (PDT)
MIME-Version: 1.0
References: <20200925212302.3979661-1-bgardon@google.com> <20200925212302.3979661-5-bgardon@google.com>
 <20200930060610.GA29659@linux.intel.com>
In-Reply-To: <20200930060610.GA29659@linux.intel.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 12 Oct 2020 15:59:35 -0700
Message-ID: <CANgfPd90pTFr_36EhHsZjYkmFdyhyxYsRVxQ4_63znT1ri7jOw@mail.gmail.com>
Subject: Re: [PATCH 04/22] kvm: mmu: Allocate and free TDP MMU roots
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Cannon Matthews <cannonmatthews@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 29, 2020 at 11:06 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Fri, Sep 25, 2020 at 02:22:44PM -0700, Ben Gardon wrote:
>   static u64 __read_mostly shadow_nx_mask;
> > @@ -3597,10 +3592,14 @@ static void mmu_free_root_page(struct kvm *kvm, hpa_t *root_hpa,
> >       if (!VALID_PAGE(*root_hpa))
> >               return;
> >
> > -     sp = to_shadow_page(*root_hpa & PT64_BASE_ADDR_MASK);
> > -     --sp->root_count;
> > -     if (!sp->root_count && sp->role.invalid)
> > -             kvm_mmu_prepare_zap_page(kvm, sp, invalid_list);
> > +     if (is_tdp_mmu_root(kvm, *root_hpa)) {
> > +             kvm_tdp_mmu_put_root_hpa(kvm, *root_hpa);
> > +     } else {
> > +             sp = to_shadow_page(*root_hpa & PT64_BASE_ADDR_MASK);
> > +             --sp->root_count;
> > +             if (!sp->root_count && sp->role.invalid)
> > +                     kvm_mmu_prepare_zap_page(kvm, sp, invalid_list);
>
> Hmm, I see that future patches use put_tdp_mmu_root()/get_tdp_mmu_root(),
> but the code itself isn't specific to the TDP MMU.  Even if this ends up
> being the only non-TDP user of get/put, I think it'd be worth making them
> common helpers, e.g.
>
>         sp = to_shadow_page(*root_hpa & PT64_BASE_ADDR_MASK);
>         if (mmu_put_root(sp) {
>                 if (is_tdp_mmu(...))
>                         kvm_tdp_mmu_free_root(kvm, sp);
>                 else if (sp->role.invalid)
>                         kvm_mmu_prepare_zap_page(kvm, sp, invalid_list);
>         }
>
> > +     }
> >
> >       *root_hpa = INVALID_PAGE;
> >  }
> > @@ -3691,7 +3690,13 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
> >       unsigned i;
> >
> >       if (shadow_root_level >= PT64_ROOT_4LEVEL) {
> > -             root = mmu_alloc_root(vcpu, 0, 0, shadow_root_level, true);
> > +             if (vcpu->kvm->arch.tdp_mmu_enabled) {
>
> I believe this will break 32-bit NPT.  Or at a minimum, look weird.  It'd
> be better to explicitly disable the TDP MMU on 32-bit KVM, then this becomes
>
>         if (vcpu->kvm->arch.tdp_mmu_enabled) {
>
>         } else if (shadow_root_level >= PT64_ROOT_4LEVEL) {
>
>         } else {
>
>         }
>

How does this break 32-bit NPT? I'm not sure I understand how we would
get into a bad state here because I'm not familiar with the specifics
of 32 bit NPT.

> > +                     root = kvm_tdp_mmu_get_vcpu_root_hpa(vcpu);
> > +             } else {
> > +                     root = mmu_alloc_root(vcpu, 0, 0, shadow_root_level,
> > +                                           true);
> > +             }
>
> May not matter in the end, but the braces aren't needed.
>
> > +
> >               if (!VALID_PAGE(root))
> >                       return -ENOSPC;
> >               vcpu->arch.mmu->root_hpa = root;
> > diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> > index 65bb110847858..530b7d893c7b3 100644
> > --- a/arch/x86/kvm/mmu/mmu_internal.h
> > +++ b/arch/x86/kvm/mmu/mmu_internal.h
> > @@ -41,8 +41,12 @@ struct kvm_mmu_page {
> >
> >       /* Number of writes since the last time traversal visited this page.  */
> >       atomic_t write_flooding_count;
> > +
> > +     bool tdp_mmu_page;
> >  };
> >
> > +extern struct kmem_cache *mmu_page_header_cache;
> > +
> >  static inline struct kvm_mmu_page *to_shadow_page(hpa_t shadow_page)
> >  {
> >       struct page *page = pfn_to_page(shadow_page >> PAGE_SHIFT);
> > @@ -69,6 +73,11 @@ bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
> >       (((address) >> PT64_LEVEL_SHIFT(level)) & ((1 << PT64_LEVEL_BITS) - 1))
> >  #define SHADOW_PT_INDEX(addr, level) PT64_INDEX(addr, level)
> >
> > +#define ACC_EXEC_MASK    1
> > +#define ACC_WRITE_MASK   PT_WRITABLE_MASK
> > +#define ACC_USER_MASK    PT_USER_MASK
> > +#define ACC_ALL          (ACC_EXEC_MASK | ACC_WRITE_MASK | ACC_USER_MASK)
> > +
> >  /* Functions for interpreting SPTEs */
> >  kvm_pfn_t spte_to_pfn(u64 pte);
> >  bool is_mmio_spte(u64 spte);
> > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > index 8241e18c111e6..cdca829e42040 100644
> > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > @@ -1,5 +1,7 @@
> >  /* SPDX-License-Identifier: GPL-2.0 */
> >
> > +#include "mmu.h"
> > +#include "mmu_internal.h"
> >  #include "tdp_mmu.h"
> >
> >  static bool __read_mostly tdp_mmu_enabled = true;
> > @@ -25,10 +27,165 @@ void kvm_mmu_init_tdp_mmu(struct kvm *kvm)
> >
> >       /* This should not be changed for the lifetime of the VM. */
> >       kvm->arch.tdp_mmu_enabled = true;
> > +
> > +     INIT_LIST_HEAD(&kvm->arch.tdp_mmu_roots);
> >  }
> >
> >  void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
> >  {
> >       if (!kvm->arch.tdp_mmu_enabled)
> >               return;
> > +
> > +     WARN_ON(!list_empty(&kvm->arch.tdp_mmu_roots));
> > +}
> > +
> > +#define for_each_tdp_mmu_root(_kvm, _root)                       \
> > +     list_for_each_entry(_root, &_kvm->arch.tdp_mmu_roots, link)
> > +
> > +bool is_tdp_mmu_root(struct kvm *kvm, hpa_t hpa)
> > +{
> > +     struct kvm_mmu_page *root;
> > +
> > +     if (!kvm->arch.tdp_mmu_enabled)
> > +             return false;
> > +
> > +     root = to_shadow_page(hpa);
> > +
> > +     if (WARN_ON(!root))
> > +             return false;
> > +
> > +     return root->tdp_mmu_page;
>
> Why all the extra checks?
>
> > +}
> > +
> > +static void free_tdp_mmu_root(struct kvm *kvm, struct kvm_mmu_page *root)
> > +{
> > +     lockdep_assert_held(&kvm->mmu_lock);
> > +
> > +     WARN_ON(root->root_count);
> > +     WARN_ON(!root->tdp_mmu_page);
> > +
> > +     list_del(&root->link);
> > +
> > +     free_page((unsigned long)root->spt);
> > +     kmem_cache_free(mmu_page_header_cache, root);
> > +}
> > +
> > +static void put_tdp_mmu_root(struct kvm *kvm, struct kvm_mmu_page *root)
> > +{
> > +     lockdep_assert_held(&kvm->mmu_lock);
> > +
> > +     root->root_count--;
> > +     if (!root->root_count)
> > +             free_tdp_mmu_root(kvm, root);
> > +}
> > +
> > +static void get_tdp_mmu_root(struct kvm *kvm, struct kvm_mmu_page *root)
> > +{
> > +     lockdep_assert_held(&kvm->mmu_lock);
> > +     WARN_ON(!root->root_count);
> > +
> > +     root->root_count++;
> > +}
> > +
> > +void kvm_tdp_mmu_put_root_hpa(struct kvm *kvm, hpa_t root_hpa)
> > +{
> > +     struct kvm_mmu_page *root;
> > +
> > +     root = to_shadow_page(root_hpa);
> > +
> > +     if (WARN_ON(!root))
> > +             return;
> > +
> > +     put_tdp_mmu_root(kvm, root);
> > +}
> > +
> > +static struct kvm_mmu_page *find_tdp_mmu_root_with_role(
> > +             struct kvm *kvm, union kvm_mmu_page_role role)
> > +{
> > +     struct kvm_mmu_page *root;
> > +
> > +     lockdep_assert_held(&kvm->mmu_lock);
> > +     for_each_tdp_mmu_root(kvm, root) {
> > +             WARN_ON(!root->root_count);
> > +
> > +             if (root->role.word == role.word)
> > +                     return root;
> > +     }
> > +
> > +     return NULL;
> > +}
> > +
> > +static struct kvm_mmu_page *alloc_tdp_mmu_root(struct kvm_vcpu *vcpu,
> > +                                            union kvm_mmu_page_role role)
> > +{
> > +     struct kvm_mmu_page *new_root;
> > +     struct kvm_mmu_page *root;
> > +
> > +     new_root = kvm_mmu_memory_cache_alloc(
> > +                     &vcpu->arch.mmu_page_header_cache);
> > +     new_root->spt = kvm_mmu_memory_cache_alloc(
> > +                     &vcpu->arch.mmu_shadow_page_cache);
> > +     set_page_private(virt_to_page(new_root->spt), (unsigned long)new_root);
> > +
> > +     new_root->role.word = role.word;
> > +     new_root->root_count = 1;
> > +     new_root->gfn = 0;
> > +     new_root->tdp_mmu_page = true;
> > +
> > +     spin_lock(&vcpu->kvm->mmu_lock);
> > +
> > +     /* Check that no matching root exists before adding this one. */
> > +     root = find_tdp_mmu_root_with_role(vcpu->kvm, role);
> > +     if (root) {
> > +             get_tdp_mmu_root(vcpu->kvm, root);
> > +             spin_unlock(&vcpu->kvm->mmu_lock);
>
> Hrm, I'm not a big fan of dropping locks in the middle of functions, but the
> alternatives aren't great.  :-/  Best I can come up with is
>
>         if (root)
>                 get_tdp_mmu_root()
>         else
>                 list_add();
>
>         spin_unlock();
>
>         if (root) {
>                 free_page()
>                 kmem_cache_free()
>         } else {
>                 root = new_root;
>         }
>
>         return root;
>
> Not sure that's any better.
>
> > +             free_page((unsigned long)new_root->spt);
> > +             kmem_cache_free(mmu_page_header_cache, new_root);
> > +             return root;
> > +     }
> > +
> > +     list_add(&new_root->link, &vcpu->kvm->arch.tdp_mmu_roots);
> > +     spin_unlock(&vcpu->kvm->mmu_lock);
> > +
> > +     return new_root;
> > +}
> > +
> > +static struct kvm_mmu_page *get_tdp_mmu_vcpu_root(struct kvm_vcpu *vcpu)
> > +{
> > +     struct kvm_mmu_page *root;
> > +     union kvm_mmu_page_role role;
> > +
> > +     role = vcpu->arch.mmu->mmu_role.base;
> > +     role.level = vcpu->arch.mmu->shadow_root_level;
> > +     role.direct = true;
> > +     role.gpte_is_8_bytes = true;
> > +     role.access = ACC_ALL;
> > +
> > +     spin_lock(&vcpu->kvm->mmu_lock);
> > +
> > +     /* Search for an already allocated root with the same role. */
> > +     root = find_tdp_mmu_root_with_role(vcpu->kvm, role);
> > +     if (root) {
> > +             get_tdp_mmu_root(vcpu->kvm, root);
> > +             spin_unlock(&vcpu->kvm->mmu_lock);
>
> Rather than manually unlock and return, this can be
>
>         if (root)
>                 get_tdp_mmju_root();
>
>         spin_unlock()
>
>         if (!root)
>                 root = alloc_tdp_mmu_root();
>
>         return root;
>
> You could also add a helper to do the "get" along with the "find".  Not sure
> if that's worth the code.
>
> > +             return root;
> > +     }
> > +
> > +     spin_unlock(&vcpu->kvm->mmu_lock);
> > +
> > +     /* If there is no appropriate root, allocate one. */
> > +     root = alloc_tdp_mmu_root(vcpu, role);
> > +
> > +     return root;
> > +}
> > +
> > +hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
> > +{
> > +     struct kvm_mmu_page *root;
> > +
> > +     root = get_tdp_mmu_vcpu_root(vcpu);
> > +     if (!root)
> > +             return INVALID_PAGE;
> > +
> > +     return __pa(root->spt);
> >  }
> > diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
> > index dd3764f5a9aa3..9274debffeaa1 100644
> > --- a/arch/x86/kvm/mmu/tdp_mmu.h
> > +++ b/arch/x86/kvm/mmu/tdp_mmu.h
> > @@ -7,4 +7,9 @@
> >
> >  void kvm_mmu_init_tdp_mmu(struct kvm *kvm);
> >  void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm);
> > +
> > +bool is_tdp_mmu_root(struct kvm *kvm, hpa_t root);
> > +hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu);
> > +void kvm_tdp_mmu_put_root_hpa(struct kvm *kvm, hpa_t root_hpa);
> > +
> >  #endif /* __KVM_X86_MMU_TDP_MMU_H */
> > --
> > 2.28.0.709.gb0816b6eb0-goog
> >
