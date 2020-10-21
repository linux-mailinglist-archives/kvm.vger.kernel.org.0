Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91B902951DA
	for <lists+kvm@lfdr.de>; Wed, 21 Oct 2020 19:54:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503810AbgJURyy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Oct 2020 13:54:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2409040AbgJURyy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Oct 2020 13:54:54 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE4C9C0613CF
        for <kvm@vger.kernel.org>; Wed, 21 Oct 2020 10:54:53 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id a20so2579174ilk.13
        for <kvm@vger.kernel.org>; Wed, 21 Oct 2020 10:54:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CXh4HataGnM9TFfiUIFt654vuQFfGER0GCLLlZTQXjI=;
        b=a+2NkJEmh9Mdd9OM8OjjNOOepLYmOXxBDXJ3PL3QEBHhc9sB6rX0N4QiIaYFvh6JsA
         jbx1Gl65Tg3E9Dre01SbCjn/Y5CK7SOqLGSy9vvy2DXH9vJGXCfc4ScV7OCu01Fdnr2D
         8xh0Odn7Iq9dTBZ9hNu2bQFZJiuLEiEj7RMLamYCPhJ3Tf8ROzJM9lG1i7Ih+ojq9Yfm
         1vU5RfsEaliE9cL+qo3/w3K3NSOpfluA1Tx5F69A4DzkT4AO3Nha6trQ+Y876bYxsX2X
         BWeI3LRyNGcdJCsxmmDAjo+Af1S7r8h+TFksQLfR6J2xM+N4Ymh7VSVV/ypbWkcJBtiZ
         eVFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CXh4HataGnM9TFfiUIFt654vuQFfGER0GCLLlZTQXjI=;
        b=h2hrrW+t+wZHco46/rZZJ1HcP16jTCAPJtb/9DFwY5PaJ4tfUaJedxc35ljQF1Kgx9
         ac69cKbA6yaLKtB/UASte2LiNimwkmeK45jAUZX21TI8HQN+7FOt65/QuZueY8yXGMtq
         u97u4W2tcYab1CK/u3ajzHc3yfgO13lohjtQR5HECG7A8Yk8Q2Wln1XpGyRIUqO4x2mr
         D8DTgLWPoFVsyor8Ti/1T6uqAmS5xYvTNVmrR4Q6ekiAeGYWTqcQjhoFN9X37/wsDVpZ
         bJz0wDNeFvLW/lD0rh/lL7+zAtfX96GyUt1swWDk17mF+IZhDlbRRJYuHRzLTB7fpiy2
         O0SQ==
X-Gm-Message-State: AOAM53155lE6X8K1KqN9/zxB9929Qi7wn10X1kCedztzzF1EroO/Ing5
        Ws7NlTJZzWx4WvVZWEpSG+G+ckgmJoP9LH01aXZI4Q==
X-Google-Smtp-Source: ABdhPJxWhmoP3ySjUAWXaCo5WbN6wvzwH0jlbGxYpG7jb+wd7gAbMCHYXGXJ2nILePtAfi6HzKuDg1dZSm9Qv087xSI=
X-Received: by 2002:a92:5b02:: with SMTP id p2mr3297905ilb.283.1603302892670;
 Wed, 21 Oct 2020 10:54:52 -0700 (PDT)
MIME-Version: 1.0
References: <20201014182700.2888246-1-bgardon@google.com> <20201014182700.2888246-5-bgardon@google.com>
 <20201021150917.xkiq74pbb63rqxvu@linux.intel.com>
In-Reply-To: <20201021150917.xkiq74pbb63rqxvu@linux.intel.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Wed, 21 Oct 2020 10:54:41 -0700
Message-ID: <CANgfPd_YpHUat5psxPfewz2bQgNXpVZUpLnpP-2VjYsYS_q0Sw@mail.gmail.com>
Subject: Re: [PATCH v2 04/20] kvm: x86/mmu: Allocate and free TDP MMU roots
To:     Yu Zhang <yu.c.zhang@linux.intel.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Cannon Matthews <cannonmatthews@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Shier <pshier@google.com>,
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

On Wed, Oct 21, 2020 at 8:09 AM Yu Zhang <yu.c.zhang@linux.intel.com> wrote:
>
> On Wed, Oct 14, 2020 at 11:26:44AM -0700, Ben Gardon wrote:
> > The TDP MMU must be able to allocate paging structure root pages and track
> > the usage of those pages. Implement a similar, but separate system for root
> > page allocation to that of the x86 shadow paging implementation. When
> > future patches add synchronization model changes to allow for parallel
> > page faults, these pages will need to be handled differently from the
> > x86 shadow paging based MMU's root pages.
> >
> > Tested by running kvm-unit-tests and KVM selftests on an Intel Haswell
> > machine. This series introduced no new failures.
> >
> > This series can be viewed in Gerrit at:
> >       https://linux-review.googlesource.com/c/virt/kvm/kvm/+/2538
> >
> > Signed-off-by: Ben Gardon <bgardon@google.com>
> > ---
> >  arch/x86/include/asm/kvm_host.h |   1 +
> >  arch/x86/kvm/mmu/mmu.c          |  29 +++++---
> >  arch/x86/kvm/mmu/mmu_internal.h |  24 +++++++
> >  arch/x86/kvm/mmu/tdp_mmu.c      | 114 ++++++++++++++++++++++++++++++++
> >  arch/x86/kvm/mmu/tdp_mmu.h      |   5 ++
> >  5 files changed, 162 insertions(+), 11 deletions(-)
> >
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index 6b6dbc20ce23a..e0ec1dd271a32 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -989,6 +989,7 @@ struct kvm_arch {
> >        * operations.
> >        */
> >       bool tdp_mmu_enabled;
> > +     struct list_head tdp_mmu_roots;
> >  };
> >
> >  struct kvm_vm_stat {
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index f53d29e09367c..a3340ed59ad1d 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -144,11 +144,6 @@ module_param(dbg, bool, 0644);
> >  #define PT64_PERM_MASK (PT_PRESENT_MASK | PT_WRITABLE_MASK | shadow_user_mask \
> >                       | shadow_x_mask | shadow_nx_mask | shadow_me_mask)
> >
> > -#define ACC_EXEC_MASK    1
> > -#define ACC_WRITE_MASK   PT_WRITABLE_MASK
> > -#define ACC_USER_MASK    PT_USER_MASK
> > -#define ACC_ALL          (ACC_EXEC_MASK | ACC_WRITE_MASK | ACC_USER_MASK)
> > -
> >  /* The mask for the R/X bits in EPT PTEs */
> >  #define PT64_EPT_READABLE_MASK                       0x1ull
> >  #define PT64_EPT_EXECUTABLE_MASK             0x4ull
> > @@ -209,7 +204,7 @@ struct kvm_shadow_walk_iterator {
> >            __shadow_walk_next(&(_walker), spte))
> >
> >  static struct kmem_cache *pte_list_desc_cache;
> > -static struct kmem_cache *mmu_page_header_cache;
> > +struct kmem_cache *mmu_page_header_cache;
> >  static struct percpu_counter kvm_total_used_mmu_pages;
> >
> >  static u64 __read_mostly shadow_nx_mask;
> > @@ -3588,9 +3583,13 @@ static void mmu_free_root_page(struct kvm *kvm, hpa_t *root_hpa,
> >               return;
> >
> >       sp = to_shadow_page(*root_hpa & PT64_BASE_ADDR_MASK);
> > -     --sp->root_count;
> > -     if (!sp->root_count && sp->role.invalid)
> > -             kvm_mmu_prepare_zap_page(kvm, sp, invalid_list);
> > +
> > +     if (kvm_mmu_put_root(sp)) {
> > +             if (sp->tdp_mmu_page)
> > +                     kvm_tdp_mmu_free_root(kvm, sp);
> > +             else if (sp->role.invalid)
> > +                     kvm_mmu_prepare_zap_page(kvm, sp, invalid_list);
> > +     }
> >
> >       *root_hpa = INVALID_PAGE;
> >  }
> > @@ -3680,8 +3679,16 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
> >       hpa_t root;
> >       unsigned i;
> >
> > -     if (shadow_root_level >= PT64_ROOT_4LEVEL) {
> > -             root = mmu_alloc_root(vcpu, 0, 0, shadow_root_level, true);
> > +     if (vcpu->kvm->arch.tdp_mmu_enabled) {
> > +             root = kvm_tdp_mmu_get_vcpu_root_hpa(vcpu);
> > +
> > +             if (!VALID_PAGE(root))
> > +                     return -ENOSPC;
> > +             vcpu->arch.mmu->root_hpa = root;
> > +     } else if (shadow_root_level >= PT64_ROOT_4LEVEL) {
> > +             root = mmu_alloc_root(vcpu, 0, 0, shadow_root_level,
> > +                                   true);
> > +
> >               if (!VALID_PAGE(root))
> >                       return -ENOSPC;
> >               vcpu->arch.mmu->root_hpa = root;
> > diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> > index 74ccbf001a42e..6cedf578c9a8d 100644
> > --- a/arch/x86/kvm/mmu/mmu_internal.h
> > +++ b/arch/x86/kvm/mmu/mmu_internal.h
> > @@ -43,8 +43,12 @@ struct kvm_mmu_page {
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
> > @@ -96,6 +100,11 @@ bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
> >       (PT64_BASE_ADDR_MASK & ((1ULL << (PAGE_SHIFT + (((level) - 1) \
> >                                               * PT64_LEVEL_BITS))) - 1))
> >
> > +#define ACC_EXEC_MASK    1
> > +#define ACC_WRITE_MASK   PT_WRITABLE_MASK
> > +#define ACC_USER_MASK    PT_USER_MASK
> > +#define ACC_ALL          (ACC_EXEC_MASK | ACC_WRITE_MASK | ACC_USER_MASK)
> > +
> >  /* Functions for interpreting SPTEs */
> >  static inline bool is_mmio_spte(u64 spte)
> >  {
> > @@ -126,4 +135,19 @@ static inline kvm_pfn_t spte_to_pfn(u64 pte)
> >       return (pte & PT64_BASE_ADDR_MASK) >> PAGE_SHIFT;
> >  }
> >
> > +static inline void kvm_mmu_get_root(struct kvm_mmu_page *sp)
> > +{
> > +     BUG_ON(!sp->root_count);
> > +
> > +     ++sp->root_count;
> > +}
> > +
> > +static inline bool kvm_mmu_put_root(struct kvm_mmu_page *sp)
> > +{
> > +     --sp->root_count;
> > +
> > +     return !sp->root_count;
> > +}
> > +
> > +
> >  #endif /* __KVM_X86_MMU_INTERNAL_H */
> > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > index b3809835e90b1..09a84a6e157b6 100644
> > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > @@ -1,5 +1,7 @@
> >  // SPDX-License-Identifier: GPL-2.0
> >
> > +#include "mmu.h"
> > +#include "mmu_internal.h"
> >  #include "tdp_mmu.h"
> >
> >  static bool __read_mostly tdp_mmu_enabled = false;
> > @@ -29,10 +31,122 @@ void kvm_mmu_init_tdp_mmu(struct kvm *kvm)
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
> > +     struct kvm_mmu_page *sp;
> > +
> > +     sp = to_shadow_page(hpa);
> > +
> > +     return sp->tdp_mmu_page && sp->root_count;
> > +}
> > +
> > +void kvm_tdp_mmu_free_root(struct kvm *kvm, struct kvm_mmu_page *root)
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
> > +     if (kvm_mmu_put_root(root))
> > +             kvm_tdp_mmu_free_root(kvm, root);
> > +}
> > +
> > +static void get_tdp_mmu_root(struct kvm *kvm, struct kvm_mmu_page *root)
> > +{
> > +     lockdep_assert_held(&kvm->mmu_lock);
> > +
> > +     kvm_mmu_get_root(root);
> > +}
> > +
> > +static union kvm_mmu_page_role page_role_for_level(struct kvm_vcpu *vcpu,
> > +                                                int level)
> > +{
> > +     union kvm_mmu_page_role role;
> > +
> > +     role = vcpu->arch.mmu->mmu_role.base;
> > +     role.level = vcpu->arch.mmu->shadow_root_level;
>
> role.level = level;
> The role will be calculated for non root pages later.

Thank you for catching that Yu, that was definitely an error!
I'm guessing this never showed up in my testing because I don't think
the TDP MMU actually uses role.level for anything other than root
pages.

>
> > +     role.direct = true;
> > +     role.gpte_is_8_bytes = true;
> > +     role.access = ACC_ALL;
> > +
> > +     return role;
> > +}
> > +
> > +static struct kvm_mmu_page *alloc_tdp_mmu_page(struct kvm_vcpu *vcpu, gfn_t gfn,
> > +                                            int level)
> > +{
> > +     struct kvm_mmu_page *sp;
> > +
> > +     sp = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_page_header_cache);
> > +     sp->spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);
> > +     set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
> > +
> > +     sp->role.word = page_role_for_level(vcpu, level).word;
> > +     sp->gfn = gfn;
> > +     sp->tdp_mmu_page = true;
> > +
> > +     return sp;
> > +}
> > +
> > +static struct kvm_mmu_page *get_tdp_mmu_vcpu_root(struct kvm_vcpu *vcpu)
> > +{
> > +     union kvm_mmu_page_role role;
> > +     struct kvm *kvm = vcpu->kvm;
> > +     struct kvm_mmu_page *root;
> > +
> > +     role = page_role_for_level(vcpu, vcpu->arch.mmu->shadow_root_level);
> > +
> > +     spin_lock(&kvm->mmu_lock);
> > +
> > +     /* Check for an existing root before allocating a new one. */
> > +     for_each_tdp_mmu_root(kvm, root) {
> > +             if (root->role.word == role.word) {
> > +                     get_tdp_mmu_root(kvm, root);
> > +                     spin_unlock(&kvm->mmu_lock);
> > +                     return root;
> > +             }
> > +     }
> > +
> > +     root = alloc_tdp_mmu_page(vcpu, 0, vcpu->arch.mmu->shadow_root_level);
> > +     root->root_count = 1;
> > +
> > +     list_add(&root->link, &kvm->arch.tdp_mmu_roots);
> > +
> > +     spin_unlock(&kvm->mmu_lock);
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
> > index cd4a562a70e9a..ac0ef91294420 100644
> > --- a/arch/x86/kvm/mmu/tdp_mmu.h
> > +++ b/arch/x86/kvm/mmu/tdp_mmu.h
> > @@ -7,4 +7,9 @@
> >
> >  void kvm_mmu_init_tdp_mmu(struct kvm *kvm);
> >  void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm);
> > +
> > +bool is_tdp_mmu_root(struct kvm *kvm, hpa_t root);
> > +hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu);
> > +void kvm_tdp_mmu_free_root(struct kvm *kvm, struct kvm_mmu_page *root);
> > +
> >  #endif /* __KVM_X86_MMU_TDP_MMU_H */
> > --
> > 2.28.0.1011.ga647a8990f-goog
> >
>
> Thanks
> Yu
