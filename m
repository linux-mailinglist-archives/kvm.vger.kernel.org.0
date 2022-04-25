Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E78A750E934
	for <lists+kvm@lfdr.de>; Mon, 25 Apr 2022 21:11:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233291AbiDYTNp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Apr 2022 15:13:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242528AbiDYTNm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Apr 2022 15:13:42 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F14242B182
        for <kvm@vger.kernel.org>; Mon, 25 Apr 2022 12:10:34 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id m128so10895609ybm.5
        for <kvm@vger.kernel.org>; Mon, 25 Apr 2022 12:10:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UKUZ7DP50ptG4NzujWrbifGcFshz0HLX5OhocYQcJfU=;
        b=FpvyciOA4rdM5SHb9TOKr5vjW2eVA3zIw791zPFtC+UTvZiXiBCLzu28Ne7DU5i1Kb
         bzSlPE3nvr3mkq2JkC7DDD2VNrqG8fAZFMR0fNNAgtvwwgKRJ2sHyvzSmiDLgTndLS8q
         7rZG8FmtQlymVzqYql/8EkyXlAAKHDaiaSSmLxuQo8Ed/RYVBSxti1azQsBhlxN1Cjt8
         WfyhaStXQGYF3zn8I5144huJhPI4zALKLeadaMZwvBtake+QpclAIKZW7gaBa2ENg8FQ
         BWM3iUaOVU6k9u3vsi6vXv9edMesyYT9S3gR1zM9NMVxgoNkgbXsGJWQbJOvn6KfBouJ
         8HzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UKUZ7DP50ptG4NzujWrbifGcFshz0HLX5OhocYQcJfU=;
        b=nY5VEi+XgVfdjLml/n0mRxAeopQ6T2aG6mHUYke0Q3yeOyqFN0EE5Bbv0iGFsa74zl
         wK29vP7D2rZyeoKzeqmQ9l9QOUHaaqFUykuf3NI2NDxRJIoS04HrJGP43woenGRDKgvm
         Fbqrq0TQx48pVl7nHsGCyi/2Mww3aBL5V5n7GaTA+Nwru5iyauTiLVkyr9+vjg1JfmG7
         J34hDhGlxmm78O91BtVbUcbttKYK6jy4Frec7VEcrDoo1tj2EAyJMvcW6wk2QsSAxCxQ
         DzQnbB35hdAjq08KEQsKw5ywjSOA8YEIwco6UnTkWk+gXbQOCpN9m7yK9O6Z7Rx4bLIY
         69+Q==
X-Gm-Message-State: AOAM531xAlHyvIyjnDamGdvP+JWjrgQuCFluk8+fTsCeLWuvMkcmFwNN
        1Oq9HeubAf3eNIpg/egI/JsADMT4cKuCEkbYNINNLA==
X-Google-Smtp-Source: ABdhPJy7/Zdt4Avo8Y9ndpqRvtzRkEBydKLfmQHwHwSpXrqoGplVJhKeqDPjLIYEVQB0S1zydn0hEX6fpJzFLxOPlWI=
X-Received: by 2002:a25:5d0d:0:b0:633:25c8:380 with SMTP id
 r13-20020a255d0d000000b0063325c80380mr16720386ybb.167.1650913833575; Mon, 25
 Apr 2022 12:10:33 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <7a5246c54427952728bd702bd7f2c6963eefa712.1646422845.git.isaku.yamahata@intel.com>
 <fb83aaeed48c7da071f0e9f3e4b36e9145ad5c63.camel@intel.com>
In-Reply-To: <fb83aaeed48c7da071f0e9f3e4b36e9145ad5c63.camel@intel.com>
From:   Sagi Shahar <sagis@google.com>
Date:   Mon, 25 Apr 2022 12:10:22 -0700
Message-ID: <CAAhR5DHFi14LzAt+3t-1tSFMLZYmtx-TxXSovh8m4=R=5NsdXA@mail.gmail.com>
Subject: Re: [RFC PATCH v5 048/104] KVM: x86/tdp_mmu: Support TDX private
 mapping for TDP MMU
To:     Kai Huang <kai.huang@intel.com>
Cc:     "Yamahata, Isaku" <isaku.yamahata@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 6, 2022 at 5:50 PM Kai Huang <kai.huang@intel.com> wrote:
>
> On Fri, 2022-03-04 at 11:49 -0800, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> >
> > Use private EPT to mirror Secure EPT, and On the change of the private EPT
>
> "on the change".
>
> > entry, invoke kvm_x86_ops hook in __handle_changed_spte() to propagate the
> > change to Secure EPT.
> >
> > On EPT violation, determine which EPT to use, private or shared, based on
> > faulted GPA.  When allocating an EPT page, record it (private or shared) in
> > the page role.  The private is passed down to the function as an argument
> > as necessary.  When the private EPT entry is changed, call the hook.
> >
> > When zapping EPT, the EPT entry is frozen with the special EPT value that
> > clears the present bit. After the TLB shootdown, the entry is set to the
> > eventual value.  On populating the EPT entry, atomically set the entry.
> >
> > For TDX, TDX SEAMCALL to update Secure EPT in addition to direct access to
> > the private EPT entry.  For the zapping case, freeing the EPT entry
> > works. It can call TDX SEAMCALL in addition to TLB shootdown.  For
> > populating the private EPT entry, there can be a race condition without
> > further protection
> >
> >   vcpu 1: populating 2M private EPT entry
> >   vcpu 2: populating 4K private EPT entry
> >   vcpu 2: TDX SEAMCALL to update 4K secure EPT => error
> >   vcpu 1: TDX SEAMCALL to update 4M secure EPT
>
> 2M secure EPT
>
> >
> > To avoid the race, the frozen EPT entry is utilized.  Instead of atomic
> > update of the private EPT entry, freeze the entry, call the hook that
> > invokes TDX SEAMCALL, set the entry to the final value (unfreeze).
> >
> > Support 4K page only at this stage.  2M page support can be done in future
> > patches.
>
> Btw, I'd like to see this as a patch to handle schematic of private mapping in
> MMU code, and put this patch close to other infrastructure patches such as
> "stolen GPA infrastructure" and "private_sp", so people can get a clear view on
> what does the schematic of "private mapping" meaning and how to handle it before
> jumping to TDX details.
>
> In this patch, you have a "mirrored private page table", this is an important
> concept and please explain it in commit message.  Only with this, your above
> race condition case makes sense.
>
> Also, you mentioned you will record private or shared in page role.  It seems I
> don't see it.  Anyway, you also have SPTE_PRIVATE_PROHIBIT.  It's not entirely
> clearly to me why you need it, or what's advantage between using page.role vs
> it.  Please put those patches together so we can have a clear understanding on
> your decisions.
>
> IMHO, in general please reorganize the MMU related patches into below way:
>
> 1) Patches to introduce schematic of private mapping, and how to handle.  You
> can use TDX as background to explain, but IMHO please use common name such as
> "private page table" instead of "Secure EPT".  Those patches can include:
>   - concept of protected VM, private/shared mapping (current "GPA stolen bits
>     infrastructure" patch).
>   - shadow_nonpresent_mask to support setting "Suppress #VE" bit.
>   - per-VM MMIO value/mask
>   - 'kvm_mmu_page->private_sp'
>   - mirrored private page table (this patch).
>   - SPTE_PRIVATE_PROHIBIT (vs role.private, etc)
>   - Anything else?
>
> 2) After you clearly explain the schematic of private mapping, you can declare
> some features cannot work with private mapping, such as log-dirty, fast page
> fault, so that you can disable them in separate patches
>
> 3) TDX specific handling.
>
> Order of 2) and 3) doesn't matter, of course.
>
> And when introduce a patch, please make sure it doesn't break existing things,
> even logically.  While I understand we want to split out independent small logic
> as small patches (as preparation to support main patches), please don't break
> anything in one patch.
>
> My 2cents above.
>
> >
> > Co-developed-by: Kai Huang <kai.huang@intel.com>
> > Signed-off-by: Kai Huang <kai.huang@intel.com>
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > ---
> >  arch/x86/include/asm/kvm-x86-ops.h |   2 +
> >  arch/x86/include/asm/kvm_host.h    |   8 +
> >  arch/x86/kvm/mmu/mmu.c             |  31 +++-
> >  arch/x86/kvm/mmu/tdp_iter.h        |   2 +-
> >  arch/x86/kvm/mmu/tdp_mmu.c         | 226 +++++++++++++++++++++++------
> >  arch/x86/kvm/mmu/tdp_mmu.h         |  13 +-
> >  virt/kvm/kvm_main.c                |   1 +
> >  7 files changed, 232 insertions(+), 51 deletions(-)
> >
> > diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> > index ef48dcc98cfc..7e27b73d839f 100644
> > --- a/arch/x86/include/asm/kvm-x86-ops.h
> > +++ b/arch/x86/include/asm/kvm-x86-ops.h
> > @@ -91,6 +91,8 @@ KVM_X86_OP(set_tss_addr)
> >  KVM_X86_OP(set_identity_map_addr)
> >  KVM_X86_OP(get_mt_mask)
> >  KVM_X86_OP(load_mmu_pgd)
> > +KVM_X86_OP(free_private_sp)
> > +KVM_X86_OP(handle_changed_private_spte)
> >  KVM_X86_OP_NULL(has_wbinvd_exit)
> >  KVM_X86_OP(get_l2_tsc_offset)
> >  KVM_X86_OP(get_l2_tsc_multiplier)
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index 0c8cc7d73371..8406f8b5ab74 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -433,6 +433,7 @@ struct kvm_mmu {
> >                        struct kvm_mmu_page *sp);
> >       void (*invlpg)(struct kvm_vcpu *vcpu, gva_t gva, hpa_t root_hpa);
> >       hpa_t root_hpa;
> > +     hpa_t private_root_hpa;
> >       gpa_t root_pgd;
> >       union kvm_mmu_role mmu_role;
> >       u8 root_level;
> > @@ -1433,6 +1434,13 @@ struct kvm_x86_ops {
> >       void (*load_mmu_pgd)(struct kvm_vcpu *vcpu, hpa_t root_hpa,
> >                            int root_level);
> >
> > +     int (*free_private_sp)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
> > +                            void *private_sp);
> > +     void (*handle_changed_private_spte)(
> > +             struct kvm *kvm, gfn_t gfn, enum pg_level level,
> > +             kvm_pfn_t old_pfn, bool was_present, bool was_leaf,
> > +             kvm_pfn_t new_pfn, bool is_present, bool is_leaf, void *sept_page);
> > +
> >       bool (*has_wbinvd_exit)(void);
> >
> >       u64 (*get_l2_tsc_offset)(struct kvm_vcpu *vcpu);
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 8def8b97978f..0ec9548ff4dd 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -3422,6 +3422,7 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
> >  {
> >       struct kvm_mmu *mmu = vcpu->arch.mmu;
> >       u8 shadow_root_level = mmu->shadow_root_level;
> > +     gfn_t gfn_stolen = kvm_gfn_stolen_mask(vcpu->kvm);
> >       hpa_t root;
> >       unsigned i;
> >       int r;
> > @@ -3432,7 +3433,11 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
> >               goto out_unlock;
> >
> >       if (is_tdp_mmu_enabled(vcpu->kvm)) {
> > -             root = kvm_tdp_mmu_get_vcpu_root_hpa(vcpu);
> > +             if (gfn_stolen && !VALID_PAGE(mmu->private_root_hpa)) {
> > +                     root = kvm_tdp_mmu_get_vcpu_root_hpa(vcpu, true);
> > +                     mmu->private_root_hpa = root;
> > +             }
> > +             root = kvm_tdp_mmu_get_vcpu_root_hpa(vcpu, false);
> >               mmu->root_hpa = root;
> >       } else if (shadow_root_level >= PT64_ROOT_4LEVEL) {
> >               root = mmu_alloc_root(vcpu, 0, 0, shadow_root_level, true);
> > @@ -5596,6 +5601,7 @@ static int __kvm_mmu_create(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu)
> >       int i;
> >
> >       mmu->root_hpa = INVALID_PAGE;
> > +     mmu->private_root_hpa = INVALID_PAGE;
> >       mmu->root_pgd = 0;
> >       for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
> >               mmu->prev_roots[i] = KVM_MMU_ROOT_INFO_INVALID;
> > @@ -5772,6 +5778,10 @@ static void kvm_mmu_zap_all_fast(struct kvm *kvm)
> >
> >       write_unlock(&kvm->mmu_lock);
> >
> > +     /*
> > +      * For now private root is never invalidate during VM is running,
> > +      * so this can only happen for shared roots.
> > +      */
> >       if (is_tdp_mmu_enabled(kvm)) {
> >               read_lock(&kvm->mmu_lock);
> >               kvm_tdp_mmu_zap_invalidated_roots(kvm);
> > @@ -5871,7 +5881,8 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
> >       if (is_tdp_mmu_enabled(kvm)) {
> >               for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++)
> >                       flush = kvm_tdp_mmu_zap_gfn_range(kvm, i, gfn_start,
> > -                                                       gfn_end, flush);
> > +                                                       gfn_end, flush,
> > +                                                       false);
> >       }
> >
> >       if (flush)
> > @@ -5904,6 +5915,11 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
> >               write_unlock(&kvm->mmu_lock);
> >       }
> >
> > +     /*
> > +      * For now this can only happen for non-TD VM, because TD private
> > +      * mapping doesn't support write protection.  kvm_tdp_mmu_wrprot_slot()
> > +      * will give a WARN() if it hits for TD.
> > +      */
> >       if (is_tdp_mmu_enabled(kvm)) {
> >               read_lock(&kvm->mmu_lock);
> >               flush |= kvm_tdp_mmu_wrprot_slot(kvm, memslot, start_level);
> > @@ -5952,6 +5968,9 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
> >               sp = sptep_to_sp(sptep);
> >               pfn = spte_to_pfn(*sptep);
> >
> > +             /* Private page dirty logging is not supported. */
> > +             KVM_BUG_ON(is_private_spte(sptep), kvm);
> > +
> >               /*
> >                * We cannot do huge page mapping for indirect shadow pages,
> >                * which are found on the last rmap (level = 1) when not using
> > @@ -5992,6 +6011,11 @@ void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
> >               write_unlock(&kvm->mmu_lock);
> >       }
> >
> > +     /*
> > +      * This should only be reachable in case of log-dirty, wihch TD private
> > +      * mapping doesn't support so far.  kvm_tdp_mmu_zap_collapsible_sptes()
> > +      * internally gives a WARN() when it hits.
> > +      */
> >       if (is_tdp_mmu_enabled(kvm)) {
> >               read_lock(&kvm->mmu_lock);
> >               kvm_tdp_mmu_zap_collapsible_sptes(kvm, slot);
> > @@ -6266,6 +6290,9 @@ int kvm_mmu_module_init(void)
> >  void kvm_mmu_destroy(struct kvm_vcpu *vcpu)
> >  {
> >       kvm_mmu_unload(vcpu);
> > +     if (is_tdp_mmu_enabled(vcpu->kvm))
> > +             mmu_free_root_page(vcpu->kvm, &vcpu->arch.mmu->private_root_hpa,
> > +                             NULL);
> >       free_mmu_pages(&vcpu->arch.root_mmu);
> >       free_mmu_pages(&vcpu->arch.guest_mmu);
> >       mmu_free_memory_caches(vcpu);
> > diff --git a/arch/x86/kvm/mmu/tdp_iter.h b/arch/x86/kvm/mmu/tdp_iter.h
> > index e19cabbcb65c..ad22d5b691c5 100644
> > --- a/arch/x86/kvm/mmu/tdp_iter.h
> > +++ b/arch/x86/kvm/mmu/tdp_iter.h
> > @@ -28,7 +28,7 @@ struct tdp_iter {
> >       tdp_ptep_t pt_path[PT64_ROOT_MAX_LEVEL];
> >       /* A pointer to the current SPTE */
> >       tdp_ptep_t sptep;
> > -     /* The lowest GFN mapped by the current SPTE */
> > +     /* The lowest GFN (stolen bits included) mapped by the current SPTE */
> >       gfn_t gfn;
> >       /* The level of the root page given to the iterator */
> >       int root_level;
> > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > index a68f3a22836b..acba2590b51e 100644
> > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > @@ -53,6 +53,11 @@ void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
> >       rcu_barrier();
> >  }
> >
> > +static gfn_t tdp_iter_gfn_unalias(struct kvm *kvm, struct tdp_iter *iter)
> > +{
> > +     return kvm_gfn_unalias(kvm, iter->gfn);
> > +}
> > +
> >  static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
> >                         gfn_t start, gfn_t end, bool can_yield, bool flush,
> >                         bool shared);
> > @@ -175,10 +180,13 @@ static union kvm_mmu_page_role page_role_for_level(struct kvm_vcpu *vcpu,
> >  }
> >
> >  static struct kvm_mmu_page *alloc_tdp_mmu_page(struct kvm_vcpu *vcpu, gfn_t gfn,
> > -                                            int level)
> > +                                            int level, bool private)
> >  {
> >       struct kvm_mmu_page *sp;
> >
> > +     WARN_ON(level != vcpu->arch.mmu->shadow_root_level &&
> > +             kvm_is_private_gfn(vcpu->kvm, gfn) != private);
> > +     WARN_ON(level == vcpu->arch.mmu->shadow_root_level && gfn != 0);
> >       sp = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_page_header_cache);
> >       sp->spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);
> >       set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
> > @@ -186,14 +194,19 @@ static struct kvm_mmu_page *alloc_tdp_mmu_page(struct kvm_vcpu *vcpu, gfn_t gfn,
> >       sp->role.word = page_role_for_level(vcpu, level).word;
> >       sp->gfn = gfn;
> >       sp->tdp_mmu_page = true;
> > -     kvm_mmu_init_private_sp(sp);
> > +
> > +     if (private)
> > +             kvm_mmu_alloc_private_sp(vcpu, sp);
> > +     else
> > +             kvm_mmu_init_private_sp(sp);
> >
> >       trace_kvm_mmu_get_page(sp, true);
> >
> >       return sp;
> >  }
> >
> > -hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
> > +static struct kvm_mmu_page *kvm_tdp_mmu_get_vcpu_root(struct kvm_vcpu *vcpu,
> > +                                                   bool private)
> >  {
> >       union kvm_mmu_page_role role;
> >       struct kvm *kvm = vcpu->kvm;
> > @@ -206,11 +219,13 @@ hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
> >       /* Check for an existing root before allocating a new one. */
> >       for_each_tdp_mmu_root(kvm, root, kvm_mmu_role_as_id(role)) {
> >               if (root->role.word == role.word &&
> > +                 is_private_sp(root) == private &&
> >                   kvm_tdp_mmu_get_root(kvm, root))
> >                       goto out;
> >       }
> >
> > -     root = alloc_tdp_mmu_page(vcpu, 0, vcpu->arch.mmu->shadow_root_level);
> > +     root = alloc_tdp_mmu_page(vcpu, 0, vcpu->arch.mmu->shadow_root_level,
> > +                     private);
> >       refcount_set(&root->tdp_mmu_root_count, 1);
> >
> >       spin_lock(&kvm->arch.tdp_mmu_pages_lock);
> > @@ -218,12 +233,17 @@ hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
> >       spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
> >
> >  out:
> > -     return __pa(root->spt);
> > +     return root;
> > +}
> > +
> > +hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu, bool private)
> > +{
> > +     return __pa(kvm_tdp_mmu_get_vcpu_root(vcpu, private)->spt);
> >  }
> >
> >  static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
> > -                             u64 old_spte, u64 new_spte, int level,
> > -                             bool shared);
> > +                             bool private_spte, u64 old_spte,
> > +                             u64 new_spte, int level, bool shared);
> >
> >  static void handle_changed_spte_acc_track(u64 old_spte, u64 new_spte, int level)
> >  {
> > @@ -321,6 +341,7 @@ static void handle_removed_tdp_mmu_page(struct kvm *kvm, tdp_ptep_t pt,
> >       int level = sp->role.level;
> >       gfn_t base_gfn = sp->gfn;
> >       int i;
> > +     bool private_sp = is_private_sp(sp);
> >
> >       trace_kvm_mmu_prepare_zap_page(sp);
> >
> > @@ -370,7 +391,7 @@ static void handle_removed_tdp_mmu_page(struct kvm *kvm, tdp_ptep_t pt,
> >                        */
> >                       WRITE_ONCE(*sptep, SHADOW_REMOVED_SPTE);
> >               }
> > -             handle_changed_spte(kvm, kvm_mmu_page_as_id(sp), gfn,
> > +             handle_changed_spte(kvm, kvm_mmu_page_as_id(sp), gfn, private_sp,
> >                                   old_child_spte, SHADOW_REMOVED_SPTE, level,
> >                                   shared);
> >       }
> > @@ -378,6 +399,17 @@ static void handle_removed_tdp_mmu_page(struct kvm *kvm, tdp_ptep_t pt,
> >       kvm_flush_remote_tlbs_with_address(kvm, base_gfn,
> >                                          KVM_PAGES_PER_HPAGE(level + 1));
> >
> > +     if (private_sp &&
> > +             WARN_ON(static_call(kvm_x86_free_private_sp)(
> > +                             kvm, sp->gfn, sp->role.level,
> > +                             kvm_mmu_private_sp(sp)))) {
> > +             /*
> > +              * Failed to unlink Secure EPT page and there is nothing to do
> > +              * further.  Intentionally leak the page to prevent the kernel
> > +              * from accessing the encrypted page.
> > +              */
> > +             kvm_mmu_init_private_sp(sp);
> > +     }
> >       call_rcu(&sp->rcu_head, tdp_mmu_free_sp_rcu_callback);
> >  }
> >
> > @@ -386,6 +418,7 @@ static void handle_removed_tdp_mmu_page(struct kvm *kvm, tdp_ptep_t pt,
> >   * @kvm: kvm instance
> >   * @as_id: the address space of the paging structure the SPTE was a part of
> >   * @gfn: the base GFN that was mapped by the SPTE
> > + * @private_spte: the SPTE is private or not
> >   * @old_spte: The value of the SPTE before the change
> >   * @new_spte: The value of the SPTE after the change
> >   * @level: the level of the PT the SPTE is part of in the paging structure
> > @@ -397,14 +430,16 @@ static void handle_removed_tdp_mmu_page(struct kvm *kvm, tdp_ptep_t pt,
> >   * This function must be called for all TDP SPTE modifications.
> >   */
> >  static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
> > -                               u64 old_spte, u64 new_spte, int level,
> > -                               bool shared)
> > +                               bool private_spte, u64 old_spte,
> > +                               u64 new_spte, int level, bool shared)
> >  {
> >       bool was_present = is_shadow_present_pte(old_spte);
> >       bool is_present = is_shadow_present_pte(new_spte);
> >       bool was_leaf = was_present && is_last_spte(old_spte, level);
> >       bool is_leaf = is_present && is_last_spte(new_spte, level);
> > -     bool pfn_changed = spte_to_pfn(old_spte) != spte_to_pfn(new_spte);
> > +     kvm_pfn_t old_pfn = spte_to_pfn(old_spte);
> > +     kvm_pfn_t new_pfn = spte_to_pfn(new_spte);
> > +     bool pfn_changed = old_pfn != new_pfn;
> >
> >       WARN_ON(level > PT64_ROOT_MAX_LEVEL);
> >       WARN_ON(level < PG_LEVEL_4K);
> > @@ -468,23 +503,49 @@ static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
> >
> >       if (was_leaf && is_dirty_spte(old_spte) &&
> >           (!is_present || !is_dirty_spte(new_spte) || pfn_changed))
> > -             kvm_set_pfn_dirty(spte_to_pfn(old_spte));
> > +             kvm_set_pfn_dirty(old_pfn);
> > +
> > +     /*
> > +      * Special handling for the private mapping.  We are either
> > +      * setting up new mapping at middle level page table, or leaf,
> > +      * or tearing down existing mapping.
> > +      */
> > +     if (private_spte) {
> > +             void *sept_page = NULL;
> > +
> > +             if (is_present && !is_leaf) {
> > +                     struct kvm_mmu_page *sp = to_shadow_page(pfn_to_hpa(new_pfn));
> > +
> > +                     sept_page = kvm_mmu_private_sp(sp);
> > +                     WARN_ON(!sept_page);
> > +                     WARN_ON(sp->role.level + 1 != level);
> > +                     WARN_ON(sp->gfn != gfn);
> > +             }
> > +
> > +             static_call(kvm_x86_handle_changed_private_spte)(
> > +                     kvm, gfn, level,
> > +                     old_pfn, was_present, was_leaf,
> > +                     new_pfn, is_present, is_leaf, sept_page);
> > +     }
> >
> >       /*
> >        * Recursively handle child PTs if the change removed a subtree from
> >        * the paging structure.
> >        */
> > -     if (was_present && !was_leaf && (pfn_changed || !is_present))
> > +     if (was_present && !was_leaf && (pfn_changed || !is_present)) {
> > +             WARN_ON(private_spte !=
> > +                     is_private_spte(spte_to_child_pt(old_spte, level)));
> >               handle_removed_tdp_mmu_page(kvm,
> >                               spte_to_child_pt(old_spte, level), shared);
> > +     }
> >  }
> >
> >  static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
> > -                             u64 old_spte, u64 new_spte, int level,
> > -                             bool shared)
> > +                             bool private_spte, u64 old_spte, u64 new_spte,
> > +                             int level, bool shared)
> >  {
> > -     __handle_changed_spte(kvm, as_id, gfn, old_spte, new_spte, level,
> > -                           shared);
> > +     __handle_changed_spte(kvm, as_id, gfn, private_spte,
> > +                     old_spte, new_spte, level, shared);
> >       handle_changed_spte_acc_track(old_spte, new_spte, level);
> >       handle_changed_spte_dirty_log(kvm, as_id, gfn, old_spte,
> >                                     new_spte, level);
> > @@ -505,6 +566,10 @@ static inline bool tdp_mmu_set_spte_atomic(struct kvm *kvm,
> >                                          struct tdp_iter *iter,
> >                                          u64 new_spte)
> >  {
> > +     bool freeze_spte = is_private_spte(iter->sptep) &&
> > +             !is_removed_spte(new_spte);
> > +     u64 tmp_spte = freeze_spte ? SHADOW_REMOVED_SPTE : new_spte;
> > +
> >       WARN_ON_ONCE(iter->yielded);
> >
> >       lockdep_assert_held_read(&kvm->mmu_lock);
> > @@ -521,13 +586,16 @@ static inline bool tdp_mmu_set_spte_atomic(struct kvm *kvm,
> >        * does not hold the mmu_lock.
> >        */
> >       if (cmpxchg64(rcu_dereference(iter->sptep), iter->old_spte,
> > -                   new_spte) != iter->old_spte)
> > +                   tmp_spte) != iter->old_spte)
> >               return false;
> >
> > -     __handle_changed_spte(kvm, iter->as_id, iter->gfn, iter->old_spte,
> > -                           new_spte, iter->level, true);
> > +     __handle_changed_spte(kvm, iter->as_id, iter->gfn, is_private_spte(iter->sptep),
> > +                           iter->old_spte, new_spte, iter->level, true);
> >       handle_changed_spte_acc_track(iter->old_spte, new_spte, iter->level);
> >
> > +     if (freeze_spte)
> > +             WRITE_ONCE(*rcu_dereference(iter->sptep), new_spte);
> > +
> >       return true;
> >  }
> >
> > @@ -603,8 +671,8 @@ static inline void __tdp_mmu_set_spte(struct kvm *kvm, struct tdp_iter *iter,
> >
> >       WRITE_ONCE(*rcu_dereference(iter->sptep), new_spte);
> >
> > -     __handle_changed_spte(kvm, iter->as_id, iter->gfn, iter->old_spte,
> > -                           new_spte, iter->level, false);
> > +     __handle_changed_spte(kvm, iter->as_id, iter->gfn, is_private_spte(iter->sptep),
> > +                           iter->old_spte, new_spte, iter->level, false);
> >       if (record_acc_track)
> >               handle_changed_spte_acc_track(iter->old_spte, new_spte,
> >                                             iter->level);
> > @@ -644,9 +712,10 @@ static inline void tdp_mmu_set_spte_no_dirty_log(struct kvm *kvm,
> >                       continue;                                       \
> >               else
> >
> > -#define tdp_mmu_for_each_pte(_iter, _mmu, _start, _end)              \
> > -     for_each_tdp_pte(_iter, __va(_mmu->root_hpa),           \
> > -                      _mmu->shadow_root_level, _start, _end)
> > +#define tdp_mmu_for_each_pte(_iter, _mmu, _private, _start, _end)            \
> > +     for_each_tdp_pte(_iter,                                                 \
> > +             __va((_private) ? _mmu->private_root_hpa : _mmu->root_hpa),     \
> > +             _mmu->shadow_root_level, _start, _end)
> >
> >  /*
> >   * Yield if the MMU lock is contended or this thread needs to return control
> > @@ -731,6 +800,18 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
> >        */
> >       end = min(end, max_gfn_host);
> >
> > +     /*
> > +      * Extend [start, end) to include GFN shared bit when TDX is enabled,
> > +      * and for shared mapping range.
> > +      */
> > +     if (is_private_sp(root)) {
> > +             start = kvm_gfn_private(kvm, start);
> > +             end = kvm_gfn_private(kvm, end);
> > +     } else {
> > +             start = kvm_gfn_shared(kvm, start);
> > +             end = kvm_gfn_shared(kvm, end);
> > +     }
> > +
> >       kvm_lockdep_assert_mmu_lock_held(kvm, shared);
> >
> >       rcu_read_lock();
> > @@ -783,13 +864,18 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
> >   * MMU lock.
> >   */
> >  bool __kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, int as_id, gfn_t start,
> > -                              gfn_t end, bool can_yield, bool flush)
> > +                              gfn_t end, bool can_yield, bool flush,
> > +                              bool zap_private)
> >  {
> >       struct kvm_mmu_page *root;
> >
> > -     for_each_tdp_mmu_root_yield_safe(kvm, root, as_id, false)
> > +     for_each_tdp_mmu_root_yield_safe(kvm, root, as_id, false) {
> > +             /* Skip private page table if not requested */
> > +             if (!zap_private && is_private_sp(root))
> > +                     continue;
> >               flush = zap_gfn_range(kvm, root, start, end, can_yield, flush,
> >                                     false);
> > +     }
> >
> >       return flush;
> >  }
> > @@ -800,7 +886,7 @@ void kvm_tdp_mmu_zap_all(struct kvm *kvm)
> >       int i;
> >
> >       for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++)
> > -             flush = kvm_tdp_mmu_zap_gfn_range(kvm, i, 0, -1ull, flush);
> > +             flush = kvm_tdp_mmu_zap_gfn_range(kvm, i, 0, -1ull, flush, true);
> >
> >       if (flush)
> >               kvm_flush_remote_tlbs(kvm);
> > @@ -851,6 +937,13 @@ void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm)
> >       while (root) {
> >               next_root = next_invalidated_root(kvm, root);
> >
> > +             /*
> > +              * Private table is only torn down when VM is destroyed.
> > +              * It is a bug to zap private table here.
> > +              */
> > +             if (WARN_ON(is_private_sp(root)))
> > +                     goto out;
> > +
> >               rcu_read_unlock();
> >
> >               flush = zap_gfn_range(kvm, root, 0, -1ull, true, flush, true);
> > @@ -865,7 +958,7 @@ void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm)
> >
> >               rcu_read_lock();
> >       }
> > -
> > +out:
> >       rcu_read_unlock();
> >
> >       if (flush)
> > @@ -897,9 +990,16 @@ void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm)
> >       struct kvm_mmu_page *root;
> >
> >       lockdep_assert_held_write(&kvm->mmu_lock);
> > -     list_for_each_entry(root, &kvm->arch.tdp_mmu_roots, link)
> > +     list_for_each_entry(root, &kvm->arch.tdp_mmu_roots, link) {
> > +             /*
> > +              * Skip private root since private page table
> > +              * is only torn down when VM is destroyed.
> > +              */
> > +             if (is_private_sp(root))
> > +                     continue;
> >               if (refcount_inc_not_zero(&root->tdp_mmu_root_count))
> >                       root->role.invalid = true;
> > +     }
> >  }
> >
> >  /*
> > @@ -914,14 +1014,23 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
> >       u64 new_spte;
> >       int ret = RET_PF_FIXED;
> >       bool wrprot = false;
> > +     unsigned long pte_access = ACC_ALL;
> >
> >       WARN_ON(sp->role.level != fault->goal_level);
> > +
> > +     /* TDX shared GPAs are no executable, enforce this for the SDV. */
> > +     if (!kvm_is_private_gfn(vcpu->kvm, iter->gfn))

This should be:
if (kvm_gfn_stolen_mask(vcpu->kvm) && !kvm_is_private_gfn(vcpu->kvm, iter->gfn))

Otherwise, when TDX is disabled, all EPTs are going to be considered
as shared non-executable EPTs.

>
> > +             pte_access &= ~ACC_EXEC_MASK;
> > +
> >       if (unlikely(!fault->slot))
> > -             new_spte = make_mmio_spte(vcpu, iter->gfn, ACC_ALL);
> > +             new_spte = make_mmio_spte(vcpu,
> > +                             tdp_iter_gfn_unalias(vcpu->kvm, iter),
> > +                             pte_access);
> >       else
> > -             wrprot = make_spte(vcpu, sp, fault->slot, ACC_ALL, iter->gfn,
> > -                                      fault->pfn, iter->old_spte, fault->prefetch, true,
> > -                                      fault->map_writable, &new_spte);
> > +             wrprot = make_spte(vcpu, sp, fault->slot, pte_access,
> > +                             tdp_iter_gfn_unalias(vcpu->kvm, iter),
> > +                             fault->pfn, iter->old_spte, fault->prefetch,
> > +                             true, fault->map_writable, &new_spte);
> >
> >       if (new_spte == iter->old_spte)
> >               ret = RET_PF_SPURIOUS;
> > @@ -959,7 +1068,8 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
> >  }
> >
> >  static bool tdp_mmu_populate_nonleaf(
> > -     struct kvm_vcpu *vcpu, struct tdp_iter *iter, bool account_nx)
> > +     struct kvm_vcpu *vcpu, struct tdp_iter *iter, bool is_private,
> > +     bool account_nx)
> >  {
> >       struct kvm_mmu_page *sp;
> >       u64 *child_pt;
> > @@ -968,7 +1078,7 @@ static bool tdp_mmu_populate_nonleaf(
> >       WARN_ON(is_shadow_present_pte(iter->old_spte));
> >       WARN_ON(is_removed_spte(iter->old_spte));
> >
> > -     sp = alloc_tdp_mmu_page(vcpu, iter->gfn, iter->level - 1);
> > +     sp = alloc_tdp_mmu_page(vcpu, iter->gfn, iter->level - 1, is_private);
> >       child_pt = sp->spt;
> >
> >       new_spte = make_nonleaf_spte(child_pt, !shadow_accessed_mask);
> > @@ -991,6 +1101,8 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> >  {
> >       struct kvm_mmu *mmu = vcpu->arch.mmu;
> >       struct tdp_iter iter;
> > +     gfn_t raw_gfn;
> > +     bool is_private;
> >       int ret;
> >
> >       kvm_mmu_hugepage_adjust(vcpu, fault);
> > @@ -999,7 +1111,17 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> >
> >       rcu_read_lock();
> >
> > -     tdp_mmu_for_each_pte(iter, mmu, fault->gfn, fault->gfn + 1) {
> > +     raw_gfn = gpa_to_gfn(fault->addr);
> > +     is_private = kvm_is_private_gfn(vcpu->kvm, raw_gfn);
> > +
> > +     if (is_error_noslot_pfn(fault->pfn) || kvm_is_reserved_pfn(fault->pfn)) {
> > +             if (is_private) {
> > +                     rcu_read_unlock();
> > +                     return -EFAULT;
> > +             }
> > +     }
> > +
> > +     tdp_mmu_for_each_pte(iter, mmu, is_private, raw_gfn, raw_gfn + 1) {
> >               if (fault->nx_huge_page_workaround_enabled)
> >                       disallowed_hugepage_adjust(fault, iter.old_spte, iter.level);
> >
> > @@ -1015,6 +1137,12 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> >                   is_large_pte(iter.old_spte)) {
> >                       if (!tdp_mmu_zap_spte_atomic(vcpu->kvm, &iter))
> >                               break;
> > +                     /*
> > +                      * TODO: large page support.
> > +                      * Doesn't support large page for TDX now
> > +                      */
> > +                     WARN_ON(is_private_spte(&iter.old_spte));
> > +
> >
> >                       /*
> >                        * The iter must explicitly re-read the spte here
> > @@ -1037,7 +1165,8 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> >
> >                       account_nx = fault->huge_page_disallowed &&
> >                               fault->req_level >= iter.level;
> > -                     if (!tdp_mmu_populate_nonleaf(vcpu, &iter, account_nx))
> > +                     if (!tdp_mmu_populate_nonleaf(
> > +                                     vcpu, &iter, is_private, account_nx))
> >                               break;
> >               }
> >       }
> > @@ -1058,9 +1187,12 @@ bool kvm_tdp_mmu_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range,
> >  {
> >       struct kvm_mmu_page *root;
> >
> > -     for_each_tdp_mmu_root_yield_safe(kvm, root, range->slot->as_id, false)
> > +     for_each_tdp_mmu_root_yield_safe(kvm, root, range->slot->as_id, false) {
> > +             if (is_private_sp(root))
> > +                     continue;
> >               flush = zap_gfn_range(kvm, root, range->start, range->end,
> > -                                   range->may_block, flush, false);
> > +                             range->may_block, flush, false);
> > +     }
> >
> >       return flush;
> >  }
> > @@ -1513,10 +1645,14 @@ int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
> >       struct kvm_mmu *mmu = vcpu->arch.mmu;
> >       gfn_t gfn = addr >> PAGE_SHIFT;
> >       int leaf = -1;
> > +     bool is_private = kvm_is_private_gfn(vcpu->kvm, gfn);
> >
> >       *root_level = vcpu->arch.mmu->shadow_root_level;
> >
> > -     tdp_mmu_for_each_pte(iter, mmu, gfn, gfn + 1) {
> > +     if (WARN_ON(is_private))
> > +             return leaf;
> > +
> > +     tdp_mmu_for_each_pte(iter, mmu, false, gfn, gfn + 1) {
> >               leaf = iter.level;
> >               sptes[leaf] = iter.old_spte;
> >       }
> > @@ -1542,12 +1678,16 @@ u64 *kvm_tdp_mmu_fast_pf_get_last_sptep(struct kvm_vcpu *vcpu, u64 addr,
> >       struct kvm_mmu *mmu = vcpu->arch.mmu;
> >       gfn_t gfn = addr >> PAGE_SHIFT;
> >       tdp_ptep_t sptep = NULL;
> > +     bool is_private = kvm_is_private_gfn(vcpu->kvm, gfn);
> >
> > -     tdp_mmu_for_each_pte(iter, mmu, gfn, gfn + 1) {
> > +     if (is_private)
> > +             goto out;
> > +
> > +     tdp_mmu_for_each_pte(iter, mmu, false, gfn, gfn + 1) {
> >               *spte = iter.old_spte;
> >               sptep = iter.sptep;
> >       }
> > -
> > +out:
> >       /*
> >        * Perform the rcu_dereference to get the raw spte pointer value since
> >        * we are passing it up to fast_page_fault, which is shared with the
> > diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
> > index 3899004a5d91..7c62f694a465 100644
> > --- a/arch/x86/kvm/mmu/tdp_mmu.h
> > +++ b/arch/x86/kvm/mmu/tdp_mmu.h
> > @@ -5,7 +5,7 @@
> >
> >  #include <linux/kvm_host.h>
> >
> > -hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu);
> > +hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu, bool private);
> >
> >  __must_check static inline bool kvm_tdp_mmu_get_root(struct kvm *kvm,
> >                                                    struct kvm_mmu_page *root)
> > @@ -20,11 +20,14 @@ void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root,
> >                         bool shared);
> >
> >  bool __kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, int as_id, gfn_t start,
> > -                              gfn_t end, bool can_yield, bool flush);
> > +                              gfn_t end, bool can_yield, bool flush,
> > +                              bool zap_private);
> >  static inline bool kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, int as_id,
> > -                                          gfn_t start, gfn_t end, bool flush)
> > +                                          gfn_t start, gfn_t end, bool flush,
> > +                                          bool zap_private)
> >  {
> > -     return __kvm_tdp_mmu_zap_gfn_range(kvm, as_id, start, end, true, flush);
> > +     return __kvm_tdp_mmu_zap_gfn_range(kvm, as_id, start, end, true, flush,
> > +                     zap_private);
> >  }
> >  static inline bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
> >  {
> > @@ -41,7 +44,7 @@ static inline bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
> >        */
> >       lockdep_assert_held_write(&kvm->mmu_lock);
> >       return __kvm_tdp_mmu_zap_gfn_range(kvm, kvm_mmu_page_as_id(sp),
> > -                                        sp->gfn, end, false, false);
> > +                                        sp->gfn, end, false, false, false);
> >  }
> >
> >  void kvm_tdp_mmu_zap_all(struct kvm *kvm);
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index ae3bf553f215..d4e117f5b5b9 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -190,6 +190,7 @@ bool kvm_is_reserved_pfn(kvm_pfn_t pfn)
> >
> >       return true;
> >  }
> > +EXPORT_SYMBOL_GPL(kvm_is_reserved_pfn);
> >
> >  /*
> >   * Switches to specified vcpu, until a matching vcpu_put()
>

Trying again in plain text mode. Sorry but it looks like I turned it
off at some point and forgot about it.

Sagi
