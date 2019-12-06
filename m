Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE57B11582D
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2019 21:25:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726352AbfLFUZW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Dec 2019 15:25:22 -0500
Received: from mail-vs1-f65.google.com ([209.85.217.65]:35315 "EHLO
        mail-vs1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726325AbfLFUZW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Dec 2019 15:25:22 -0500
Received: by mail-vs1-f65.google.com with SMTP id x123so5994064vsc.2
        for <kvm@vger.kernel.org>; Fri, 06 Dec 2019 12:25:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cgdDh87CK7xnJZ7mMClC3ELC+qdEyQlemzRQvllxKu8=;
        b=eNt37q1vUM/r/eR3t5PDE2j4qi0qfmImw0TDUFm14pPLjEBMpRTsQd/Z6ymUz6RyBU
         6xESeRbZWkqC3T5pxdrG3Fo39uAcvTRulPiLJr6Yg9iJt+j8hM6b8JZzlwjqvA2S9DCb
         htDqf3vQaE0LqZxBsoJZ+JTjHC2fm7s7C7NDG9cVZ1/W7xIYjuSrud47Kmnr+00jcZCg
         OdoiWscxetsf4WLJRBMmzgF+iy4W7Ul8QSxMe32flG28mZcxCjQeqPS7BBEZxQUk2JmV
         QHvUyjmSlvF9YtYIAGl7QzuV5aevv1VNnDD85wSOzo3DgkS1ytLtSZjDemymOEtWEw8Q
         Qp7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cgdDh87CK7xnJZ7mMClC3ELC+qdEyQlemzRQvllxKu8=;
        b=kT+R+HfxKkoGzIrMIE0AbUmVwuXLIN3o8AsuFBsWkMIcF7WkMhsQz6xA58AJZDS0uF
         99yq2jjwLMnwUmgnxv15Se4PE8vHzgllCzENM5fBTj9MOfF/PxNC+dqYNpkCAjobju1M
         FqQ3NhlZl2vuvcWxQ7ECkn7jfI8J0SI1VJIEdkeHqlvtguyxqpFmqpErRXdnzKHow2V4
         oIeNtCBSybtjDF0XbHAJnacne8EvHlhITJyj7ByI189uIRWcrD1VsJqkgYjTQacM1lqW
         5/00n0QGMMCWG8jM2jdK2rZ8mylu91OmB2AKOJ8lBoqxOqGchmuKyG97tFo/6NtvteAt
         tStg==
X-Gm-Message-State: APjAAAW/vsJBtExkMRYPlfqsn4bYR5cnbSIHmZaiY+cBdMpHYj90R6iB
        wz5FRbGWRGT5QNttVqE3E3OYfWJ714iN8qTaYEzmvQ==
X-Google-Smtp-Source: APXvYqwVXRdsYJi3P/jxeQdzukD720+upnjqoAKCqBU8it8v5rsv+juHRXINqadHIg9qMkIEcjSB1WDYdK7FCnZrvk4=
X-Received: by 2002:a67:cd09:: with SMTP id u9mr11721542vsl.17.1575663920646;
 Fri, 06 Dec 2019 12:25:20 -0800 (PST)
MIME-Version: 1.0
References: <20190926231824.149014-1-bgardon@google.com> <20190926231824.149014-9-bgardon@google.com>
 <20191202234058.GG8120@linux.intel.com>
In-Reply-To: <20191202234058.GG8120@linux.intel.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Fri, 6 Dec 2019 12:25:09 -0800
Message-ID: <CANgfPd8MoE+xGm8M5WQxk+opW5VTLkg-gVYdQqLkQt7N=U98ZA@mail.gmail.com>
Subject: Re: [RFC PATCH 08/28] kvm: mmu: Init / Uninit the direct MMU
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Peter Feiner <pfeiner@google.com>,
        Peter Shier <pshier@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

>On a different topic, have you thrown around any other names besides
>"direct MMU"?
I think direct MMU is a bad name. It's always been intended as a
temporary name as we intended to generalize the "direct MMU" to work
for nested TDP as well at some point. I'd prefer to eventually call it
the TDP MMU, but right now I guess it would be most correct to call it
an L1 TDP MMU or a TDP MMU for running L1 guests.

> What's the reasoning behind allowing the module param to be changed after
> KVM is loaded?  I haven't looked through all future patches, but I assume
> there are optimizations and/or simplifications that can be made if all VMs
> are guaranteed to have the same setting?
There are no optimizations if all VMs have the same setting. The
module parameter just exists for debugging and as a way to turn off
the "direct MMU" without a reboot, if it started causing problems. I
don't expect the module parameter to stick around in the version of
this code that's ultimately merged.



On Mon, Dec 2, 2019 at 3:41 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Thu, Sep 26, 2019 at 04:18:04PM -0700, Ben Gardon wrote:
> > The direct MMU introduces several new fields that need to be initialized
> > and torn down. Add functions to do that initialization / cleanup.
>
> Can you briefly explain the basic concepts of the direct MMU?  The cover
> letter explains the goals of the direct MMU and the mechanics of how KVM
> moves between a shadow MMU and direct MMU, but I didn't see anything that
> describes how the direct MMU fundamentally differs from the shadow MMU.
>
> I'm something like 3-4 patches ahead of this one and still don't have a
> good idea of the core tenets of the direct MMU.  I might eventually get
> there on my own, but a jump start would be appreciated.
>
>
> On a different topic, have you thrown around any other names besides
> "direct MMU"?  I don't necessarily dislike the name, but I don't like it
> either, e.g. the @direct flag is also set when IA32 paging is disabled in
> the guest.
>
> > Signed-off-by: Ben Gardon <bgardon@google.com>
> > ---
> >  arch/x86/include/asm/kvm_host.h |  51 ++++++++----
> >  arch/x86/kvm/mmu.c              | 132 +++++++++++++++++++++++++++++---
> >  arch/x86/kvm/x86.c              |  16 +++-
> >  3 files changed, 169 insertions(+), 30 deletions(-)
> >
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index 23edf56cf577c..1f8164c577d50 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -236,6 +236,22 @@ enum {
> >   */
> >  #define KVM_APIC_PV_EOI_PENDING      1
> >
> > +#define HF_GIF_MASK          (1 << 0)
> > +#define HF_HIF_MASK          (1 << 1)
> > +#define HF_VINTR_MASK                (1 << 2)
> > +#define HF_NMI_MASK          (1 << 3)
> > +#define HF_IRET_MASK         (1 << 4)
> > +#define HF_GUEST_MASK                (1 << 5) /* VCPU is in guest-mode */
> > +#define HF_SMM_MASK          (1 << 6)
> > +#define HF_SMM_INSIDE_NMI_MASK       (1 << 7)
> > +
> > +#define __KVM_VCPU_MULTIPLE_ADDRESS_SPACE
> > +#define KVM_ADDRESS_SPACE_NUM 2
> > +
> > +#define kvm_arch_vcpu_memslots_id(vcpu) \
> > +             ((vcpu)->arch.hflags & HF_SMM_MASK ? 1 : 0)
> > +#define kvm_memslots_for_spte_role(kvm, role) __kvm_memslots(kvm, (role).smm)
> > +
> >  struct kvm_kernel_irq_routing_entry;
> >
> >  /*
> > @@ -940,6 +956,24 @@ struct kvm_arch {
> >       bool exception_payload_enabled;
> >
> >       struct kvm_pmu_event_filter *pmu_event_filter;
> > +
> > +     /*
> > +      * Whether the direct MMU is enabled for this VM. This contains a
> > +      * snapshot of the direct MMU module parameter from when the VM was
> > +      * created and remains unchanged for the life of the VM. If this is
> > +      * true, direct MMU handler functions will run for various MMU
> > +      * operations.
> > +      */
> > +     bool direct_mmu_enabled;
>
> What's the reasoning behind allowing the module param to be changed after
> KVM is loaded?  I haven't looked through all future patches, but I assume
> there are optimizations and/or simplifications that can be made if all VMs
> are guaranteed to have the same setting?
>
> > +     /*
> > +      * Indicates that the paging structure built by the direct MMU is
> > +      * currently the only one in use. If nesting is used, prompting the
> > +      * creation of shadow page tables for L2, this will be set to false.
> > +      * While this is true, only direct MMU handlers will be run for many
> > +      * MMU functions. Ignored if !direct_mmu_enabled.
> > +      */
> > +     bool pure_direct_mmu;
>
> This should be introduced in the same patch that first uses the flag,
> without the usage it's impossible to properly review.  E.g. is a dedicated
> flag necessary or is it only used in slow paths and so could check for
> vmxon?  Is the flag intended to be sticky?  Why is it per-VM and not
> per-vCPU?  And so on and so forth.
>
> > +     hpa_t direct_root_hpa[KVM_ADDRESS_SPACE_NUM];
> >  };
> >
> >  struct kvm_vm_stat {
> > @@ -1255,7 +1289,7 @@ void kvm_mmu_module_exit(void);
> >
> >  void kvm_mmu_destroy(struct kvm_vcpu *vcpu);
> >  int kvm_mmu_create(struct kvm_vcpu *vcpu);
> > -void kvm_mmu_init_vm(struct kvm *kvm);
> > +int kvm_mmu_init_vm(struct kvm *kvm);
> >  void kvm_mmu_uninit_vm(struct kvm *kvm);
> >  void kvm_mmu_set_mask_ptes(u64 user_mask, u64 accessed_mask,
> >               u64 dirty_mask, u64 nx_mask, u64 x_mask, u64 p_mask,
> > @@ -1519,21 +1553,6 @@ enum {
> >       TASK_SWITCH_GATE = 3,
> >  };
> >
> > -#define HF_GIF_MASK          (1 << 0)
> > -#define HF_HIF_MASK          (1 << 1)
> > -#define HF_VINTR_MASK                (1 << 2)
> > -#define HF_NMI_MASK          (1 << 3)
> > -#define HF_IRET_MASK         (1 << 4)
> > -#define HF_GUEST_MASK                (1 << 5) /* VCPU is in guest-mode */
> > -#define HF_SMM_MASK          (1 << 6)
> > -#define HF_SMM_INSIDE_NMI_MASK       (1 << 7)
> > -
> > -#define __KVM_VCPU_MULTIPLE_ADDRESS_SPACE
> > -#define KVM_ADDRESS_SPACE_NUM 2
> > -
> > -#define kvm_arch_vcpu_memslots_id(vcpu) ((vcpu)->arch.hflags & HF_SMM_MASK ? 1 : 0)
> > -#define kvm_memslots_for_spte_role(kvm, role) __kvm_memslots(kvm, (role).smm)
> > -
> >  asmlinkage void kvm_spurious_fault(void);
> >
> >  /*
> > diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> > index 50413f17c7cd0..788edbda02f69 100644
> > --- a/arch/x86/kvm/mmu.c
> > +++ b/arch/x86/kvm/mmu.c
> > @@ -47,6 +47,10 @@
> >  #include <asm/kvm_page_track.h>
> >  #include "trace.h"
> >
> > +static bool __read_mostly direct_mmu_enabled;
> > +module_param_named(enable_direct_mmu, direct_mmu_enabled, bool,
>
> To match other x86 module params, use "direct_mmu" for the param name and
> "enable_direct_mmu" for the varaible.
>
> > +                S_IRUGO | S_IWUSR);
>
> I'd prefer octal perms here.  I'm pretty sure checkpatch complains about
> this, and I personally find 0444 and 0644 much more readable.
>
> > +
> >  /*
> >   * When setting this variable to true it enables Two-Dimensional-Paging
> >   * where the hardware walks 2 page tables:
> > @@ -3754,27 +3758,56 @@ static void mmu_free_root_page(struct kvm *kvm, hpa_t *root_hpa,
> >       *root_hpa = INVALID_PAGE;
> >  }
> >
> > +static bool is_direct_mmu_root(struct kvm *kvm, hpa_t root)
> > +{
> > +     int as_id;
> > +
> > +     for (as_id = 0; as_id < KVM_ADDRESS_SPACE_NUM; as_id++)
> > +             if (root == kvm->arch.direct_root_hpa[as_id])
> > +                     return true;
> > +
> > +     return false;
> > +}
> > +
> >  /* roots_to_free must be some combination of the KVM_MMU_ROOT_* flags */
> >  void kvm_mmu_free_roots(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
> >                       ulong roots_to_free)
> >  {
> >       int i;
> >       LIST_HEAD(invalid_list);
> > -     bool free_active_root = roots_to_free & KVM_MMU_ROOT_CURRENT;
> >
> >       BUILD_BUG_ON(KVM_MMU_NUM_PREV_ROOTS >= BITS_PER_LONG);
> >
> > -     /* Before acquiring the MMU lock, see if we need to do any real work. */
> > -     if (!(free_active_root && VALID_PAGE(mmu->root_hpa))) {
> > -             for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
> > -                     if ((roots_to_free & KVM_MMU_ROOT_PREVIOUS(i)) &&
> > -                         VALID_PAGE(mmu->prev_roots[i].hpa))
> > -                             break;
> > +     /*
> > +      * Direct MMU paging structures follow the life of the VM, so instead of
> > +      * destroying direct MMU paging structure root, simply mark the root
> > +      * HPA pointing to it as invalid.
> > +      */
> > +     if (vcpu->kvm->arch.direct_mmu_enabled &&
> > +         roots_to_free & KVM_MMU_ROOT_CURRENT &&
> > +         is_direct_mmu_root(vcpu->kvm, mmu->root_hpa))
> > +             mmu->root_hpa = INVALID_PAGE;
> >
> > -             if (i == KVM_MMU_NUM_PREV_ROOTS)
> > -                     return;
> > +     if (!VALID_PAGE(mmu->root_hpa))
> > +             roots_to_free &= ~KVM_MMU_ROOT_CURRENT;
> > +
> > +     for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++) {
> > +             if (roots_to_free & KVM_MMU_ROOT_PREVIOUS(i)) {
> > +                     if (is_direct_mmu_root(vcpu->kvm,
> > +                                            mmu->prev_roots[i].hpa))
> > +                             mmu->prev_roots[i].hpa = INVALID_PAGE;
> > +                     if (!VALID_PAGE(mmu->prev_roots[i].hpa))
> > +                             roots_to_free &= ~KVM_MMU_ROOT_PREVIOUS(i);
> > +             }
> >       }
> >
> > +     /*
> > +      * If there are no valid roots that need freeing at this point, avoid
> > +      * acquiring the MMU lock and return.
> > +      */
> > +     if (!roots_to_free)
> > +             return;
> > +
> >       write_lock(&vcpu->kvm->mmu_lock);
> >
> >       for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
> > @@ -3782,7 +3815,7 @@ void kvm_mmu_free_roots(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
> >                       mmu_free_root_page(vcpu->kvm, &mmu->prev_roots[i].hpa,
> >                                          &invalid_list);
> >
> > -     if (free_active_root) {
> > +     if (roots_to_free & KVM_MMU_ROOT_CURRENT) {
> >               if (mmu->shadow_root_level >= PT64_ROOT_4LEVEL &&
> >                   (mmu->root_level >= PT64_ROOT_4LEVEL || mmu->direct_map)) {
> >                       mmu_free_root_page(vcpu->kvm, &mmu->root_hpa,
> > @@ -3820,7 +3853,12 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
> >       struct kvm_mmu_page *sp;
> >       unsigned i;
> >
> > -     if (vcpu->arch.mmu->shadow_root_level >= PT64_ROOT_4LEVEL) {
> > +     if (vcpu->kvm->arch.direct_mmu_enabled) {
> > +             // TODO: Support 5 level paging in the direct MMU
> > +             BUG_ON(vcpu->arch.mmu->shadow_root_level > PT64_ROOT_4LEVEL);
> > +             vcpu->arch.mmu->root_hpa = vcpu->kvm->arch.direct_root_hpa[
> > +                     kvm_arch_vcpu_memslots_id(vcpu)];
> > +     } else if (vcpu->arch.mmu->shadow_root_level >= PT64_ROOT_4LEVEL) {
> >               write_lock(&vcpu->kvm->mmu_lock);
> >               if(make_mmu_pages_available(vcpu) < 0) {
> >                       write_unlock(&vcpu->kvm->mmu_lock);
> > @@ -3863,6 +3901,10 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
> >       gfn_t root_gfn, root_cr3;
> >       int i;
> >
> > +     write_lock(&vcpu->kvm->mmu_lock);
> > +     vcpu->kvm->arch.pure_direct_mmu = false;
> > +     write_unlock(&vcpu->kvm->mmu_lock);
> > +
> >       root_cr3 = vcpu->arch.mmu->get_cr3(vcpu);
> >       root_gfn = root_cr3 >> PAGE_SHIFT;
> >
> > @@ -5710,6 +5752,64 @@ void kvm_disable_tdp(void)
> >  }
> >  EXPORT_SYMBOL_GPL(kvm_disable_tdp);
> >
> > +static bool is_direct_mmu_enabled(void)
> > +{
> > +     if (!READ_ONCE(direct_mmu_enabled))
> > +             return false;
> > +
> > +     if (WARN_ONCE(!tdp_enabled,
> > +                   "Creating a VM with direct MMU enabled requires TDP."))
> > +             return false;
>
> User-induced WARNs are bad, direct_mmu_enabled must be forced to zero in
> kvm_disable_tdp().  Unless there's a good reason for direct_mmu_enabled to
> remain writable at runtime, making it read-only will eliminate that case.
>
> > +     return true;
> > +}
> > +
> > +static int kvm_mmu_init_direct_mmu(struct kvm *kvm)
> > +{
> > +     struct page *page;
> > +     int i;
> > +
> > +     if (!is_direct_mmu_enabled())
> > +             return 0;
> > +
> > +     /*
> > +      * Allocate the direct MMU root pages. These pages follow the life of
> > +      * the VM.
> > +      */
> > +     for (i = 0; i < ARRAY_SIZE(kvm->arch.direct_root_hpa); i++) {
> > +             page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
> > +             if (!page)
> > +                     goto err;
> > +             kvm->arch.direct_root_hpa[i] = page_to_phys(page);
> > +     }
> > +
> > +     /* This should not be changed for the lifetime of the VM. */
> > +     kvm->arch.direct_mmu_enabled = true;
> > +
> > +     kvm->arch.pure_direct_mmu = true;
> > +     return 0;
> > +err:
> > +     for (i = 0; i < ARRAY_SIZE(kvm->arch.direct_root_hpa); i++) {
> > +             if (kvm->arch.direct_root_hpa[i] &&
> > +                 VALID_PAGE(kvm->arch.direct_root_hpa[i]))
> > +                     free_page((unsigned long)kvm->arch.direct_root_hpa[i]);
> > +             kvm->arch.direct_root_hpa[i] = INVALID_PAGE;
> > +     }
> > +     return -ENOMEM;
> > +}
> > +
