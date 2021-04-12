Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3ACA335CF50
	for <lists+kvm@lfdr.de>; Mon, 12 Apr 2021 19:19:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243336AbhDLRUA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Apr 2021 13:20:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239716AbhDLRT7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Apr 2021 13:19:59 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAAD9C06174A
        for <kvm@vger.kernel.org>; Mon, 12 Apr 2021 10:19:41 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id p15so775087iln.3
        for <kvm@vger.kernel.org>; Mon, 12 Apr 2021 10:19:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Endm3ti5ptQAKud2TWKFQLinnf24qKN2RdmJDCOnQdA=;
        b=OIP+TXCTgxu6rtl/59uKPlWfyOrQTxqDQEtOimkzEBLArbzTQFHoD7ZrQ8yhFLMoDF
         nhdPf97Em+ackNtoLoW0pui5e763ZUzF8pDS9z/umBNUkfLQRONiyyeoX/o/4GYX1+HF
         +9BAoVk6UYFGoySBjVWUd/A3JpQAC2Wovs/ZkkIcnBplyrlMp0KmaJpN8vQh6hr6shaB
         rHtbEAfaOMyFv1D/yh7X2MAewepp6FOFPQfDmTRvHc0HXNQRWCXksxSoejf0p5NnIGyo
         oCz8EaEXRYF4udT+a4daGU3xtPlRalqEs+G7NkqLAQhfIeeTkhgtf6EdNQ7QsCsno7Rc
         2WUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Endm3ti5ptQAKud2TWKFQLinnf24qKN2RdmJDCOnQdA=;
        b=kbpTm3NXVmuetDHhi5QVmYsHQCoClaA+6vtvljnCB+eA3JDmF22NBeJ5bY2gnaCMH1
         9G40tcsrx9aK+ke+YyhjBELeezcDTfaNLVgna4k3DCIWDrluIGJ9IszTKKBFW55kp0VH
         kr6M9BouL9PXl3TneweoyitKlF1CSuwO5hDhAFkVyRsPyuCh2OxBqHz6EgpiSMNIY4LA
         jKWDoPv6VxCTuqPnrGr1v4onrKfq0MMnnZtY27Fb72uEpIeWbK9+wXCzCPyxR3+tM2H7
         XvubBC7tjzs8N4AEZuVQOIFJMWjC7Bdi+oNqxoIcCbfsf8hQ1FJ18qsXlyoRLt95+dTy
         4QKg==
X-Gm-Message-State: AOAM53181HgIF7aWEbdLzPy8Ub8jUh3hMmqj388IygRE6ZGLlV8pbkLS
        acs1fMhO+1IxjD017QmVFgUDAJrjJrEuDQuYUk8Eug==
X-Google-Smtp-Source: ABdhPJw3jw8Nexy7gZOYitweXO+7XDEU8stvOVE+oQepKkEXP9XT5UXiBPAXFGR/lKDTYskYhK/qsimzawC1ttIxn1g=
X-Received: by 2002:a92:7f03:: with SMTP id a3mr24118702ild.203.1618247980865;
 Mon, 12 Apr 2021 10:19:40 -0700 (PDT)
MIME-Version: 1.0
References: <20200828081157.15748-1-zhukeqian1@huawei.com> <107696eb-755f-7807-a484-da63aad01ce4@huawei.com>
 <YGzxzsRlqouaJv6a@google.com>
In-Reply-To: <YGzxzsRlqouaJv6a@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 12 Apr 2021 10:19:29 -0700
Message-ID: <CANgfPd8g3o2mJZi8rtR6jBNeYJTNWR0LTEcD2PeNLJk9JTz4CQ@mail.gmail.com>
Subject: Re: [RFC PATCH] KVM: x86: Support write protect huge pages lazily
To:     Sean Christopherson <seanjc@google.com>
Cc:     Keqian Zhu <zhukeqian1@huawei.com>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, wanghaibin.wang@huawei.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 6, 2021 at 4:42 PM Sean Christopherson <seanjc@google.com> wrote:
>
> +Ben
>
> On Tue, Apr 06, 2021, Keqian Zhu wrote:
> > Hi Paolo,
> >
> > I plan to rework this patch and do full test. What do you think about this idea
> > (enable dirty logging for huge pages lazily)?
>
> Ben, don't you also have something similar (or maybe the exact opposite?) in the
> hopper?  This sounds very familiar, but I can't quite connect the dots that are
> floating around my head...

Sorry for the late response, I was out of office last week.

Yes, we have two relevant features I'd like to reconcile somehow:
1.) Large page shattering - Instead of clearing a large TDP mapping,
flushing the TLBs, then replacing it with an empty TDP page table, go
straight from the large mapping to a fully pre-populated table. This
is slightly slower because the table needs to be pre-populated, but it
saves many vCPU page faults.
2.) Eager page splitting - split all large mappings down to 4k when
enabling dirty logging, using large page shattering. This makes
enabling dirty logging much slower, but speeds up the first round (and
later rounds) of gathering / clearing the dirty log and reduces the
number of vCPU page faults. We've prefered to do this when enabling
dirty logging because it's a little less perf-sensitive than the later
passes where latency and convergence are critical.

Large page shattering can happen in the NPT page fault handler or the
thread enabling dirty logging / clearing the dirty log, so it's
more-or-less orthogonal to this patch.

Eager page splitting on the other hand takes the opposite approach to
this patch, frontloading as much of the work to enable dirty logging
as possible. Which approach is better is going to depend a lot on the
guest workload, your live migration constraints, and how the
user-space hypervisor makes use of KVM's growing number of dirty
logging options. In our case, the time to migrate a VM is usually less
of a concern than the performance degradation the guest experiences,
so we want to do everything we can to minimize vCPU exits and exit
latency.

I think this is a reasonable change in principle if we're not write
protecting 4k pages already, but it's hard to really validate all the
performance implications. With this change we'd move pretty much all
the work to the first pass of clearing the dirty log, which is
probably an improvement since it's much more granular. The downside is
that we do more work when we'd really like to be converging the dirty
set as opposed to earlier when we know all pages are dirty anyway.

>
> > PS: As dirty log of TDP MMU has been supported, I should add more code.
> >
> > On 2020/8/28 16:11, Keqian Zhu wrote:
> > > Currently during enable dirty logging, if we're with init-all-set,
> > > we just write protect huge pages and leave normal pages untouched,
> > > for that we can enable dirty logging for these pages lazily.
> > >
> > > It seems that enable dirty logging lazily for huge pages is feasible
> > > too, which not only reduces the time of start dirty logging, also
> > > greatly reduces side-effect on guest when there is high dirty rate.

The side effect on the guest would also be greatly reduced with large
page shattering above.

> > >
> > > (These codes are not tested, for RFC purpose :-) ).
> > >
> > > Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
> > > ---
> > >  arch/x86/include/asm/kvm_host.h |  3 +-
> > >  arch/x86/kvm/mmu/mmu.c          | 65 ++++++++++++++++++++++++++-------
> > >  arch/x86/kvm/vmx/vmx.c          |  3 +-
> > >  arch/x86/kvm/x86.c              | 22 +++++------
> > >  4 files changed, 62 insertions(+), 31 deletions(-)
> > >
> > > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > > index 5303dbc5c9bc..201a068cf43d 100644
> > > --- a/arch/x86/include/asm/kvm_host.h
> > > +++ b/arch/x86/include/asm/kvm_host.h
> > > @@ -1296,8 +1296,7 @@ void kvm_mmu_set_mask_ptes(u64 user_mask, u64 accessed_mask,
> > >
> > >  void kvm_mmu_reset_context(struct kvm_vcpu *vcpu);
> > >  void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
> > > -                                 struct kvm_memory_slot *memslot,
> > > -                                 int start_level);
> > > +                                 struct kvm_memory_slot *memslot);
> > >  void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
> > >                                const struct kvm_memory_slot *memslot);
> > >  void kvm_mmu_slot_leaf_clear_dirty(struct kvm *kvm,
> > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > index 43fdb0c12a5d..4b7d577de6cd 100644
> > > --- a/arch/x86/kvm/mmu/mmu.c
> > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > @@ -1625,14 +1625,45 @@ static bool __rmap_set_dirty(struct kvm *kvm, struct kvm_rmap_head *rmap_head)
> > >  }
> > >
> > >  /**
> > > - * kvm_mmu_write_protect_pt_masked - write protect selected PT level pages
> > > + * kvm_mmu_write_protect_largepage_masked - write protect selected largepages
> > >   * @kvm: kvm instance
> > >   * @slot: slot to protect
> > >   * @gfn_offset: start of the BITS_PER_LONG pages we care about
> > >   * @mask: indicates which pages we should protect
> > >   *
> > > - * Used when we do not need to care about huge page mappings: e.g. during dirty
> > > - * logging we do not have any such mappings.
> > > + * @ret: true if all pages are write protected
> > > + */
> > > +static bool kvm_mmu_write_protect_largepage_masked(struct kvm *kvm,
> > > +                               struct kvm_memory_slot *slot,
> > > +                               gfn_t gfn_offset, unsigned long mask)
> > > +{
> > > +   struct kvm_rmap_head *rmap_head;
> > > +   bool protected, all_protected;
> > > +   gfn_t start_gfn = slot->base_gfn + gfn_offset;
> > > +   int i;
> > > +
> > > +   all_protected = true;
> > > +   while (mask) {
> > > +           protected = false;
> > > +           for (i = PG_LEVEL_2M; i <= KVM_MAX_HUGEPAGE_LEVEL; ++i) {
> > > +                   rmap_head = __gfn_to_rmap(start_gfn + __ffs(mask), i, slot);
> > > +                   protectd |= __rmap_write_protect(kvm, rmap_head, false);
> > > +           }
> > > +
> > > +           all_protected &= protectd;
> > > +           /* clear the first set bit */
> > > +           mask &= mask - 1;

I'm a little confused by the use of mask in this function. If
gfn_offset is aligned to some multiple of 64, which I think it is, all
the bits in the mask will be part of the same large page, so I don't
think the mask adds anything.
I'm also not sure this function compiles since I think the use of
protectd above will result in an error.

> > > +   }
> > > +
> > > +   return all_protected;
> > > +}
> > > +
> > > +/**
> > > + * kvm_mmu_write_protect_pt_masked - write protect selected PT level pages
> > > + * @kvm: kvm instance
> > > + * @slot: slot to protect
> > > + * @gfn_offset: start of the BITS_PER_LONG pages we care about
> > > + * @mask: indicates which pages we should protect
> > >   */
> > >  static void kvm_mmu_write_protect_pt_masked(struct kvm *kvm,
> > >                                  struct kvm_memory_slot *slot,
> > > @@ -1679,18 +1710,25 @@ EXPORT_SYMBOL_GPL(kvm_mmu_clear_dirty_pt_masked);
> > >
> > >  /**
> > >   * kvm_arch_mmu_enable_log_dirty_pt_masked - enable dirty logging for selected
> > > - * PT level pages.
> > > - *
> > > - * It calls kvm_mmu_write_protect_pt_masked to write protect selected pages to
> > > - * enable dirty logging for them.
> > > - *
> > > - * Used when we do not need to care about huge page mappings: e.g. during dirty
> > > - * logging we do not have any such mappings.
> > > + * dirty pages.
> > >   */
> > >  void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
> > >                             struct kvm_memory_slot *slot,
> > >                             gfn_t gfn_offset, unsigned long mask)
> > >  {
> > > +   /*
> > > +    * If we're with initial-all-set, huge pages are NOT
> > > +    * write protected when we start dirty log, so we must
> > > +    * write protect them here.
> > > +    */
> > > +   if (kvm_dirty_log_manual_protect_and_init_set(kvm)) {
> > > +           if (kvm_mmu_write_protect_largepage_masked(kvm, slot,
> > > +                                   gfn_offset, mask))
> > > +                   return;
> > > +   }
> > > +
> > > +   /* Then we can handle the 4K level pages */
> > > +
> > >     if (kvm_x86_ops.enable_log_dirty_pt_masked)
> > >             kvm_x86_ops.enable_log_dirty_pt_masked(kvm, slot, gfn_offset,
> > >                             mask);
> > > @@ -5906,14 +5944,13 @@ static bool slot_rmap_write_protect(struct kvm *kvm,
> > >  }
> > >
> > >  void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
> > > -                                 struct kvm_memory_slot *memslot,
> > > -                                 int start_level)
> > > +                                 struct kvm_memory_slot *memslot)
> > >  {
> > >     bool flush;
> > >
> > >     spin_lock(&kvm->mmu_lock);
> > > -   flush = slot_handle_level(kvm, memslot, slot_rmap_write_protect,
> > > -                           start_level, KVM_MAX_HUGEPAGE_LEVEL, false);
> > > +   flush = slot_handle_all_level(kvm, memslot, slot_rmap_write_protect,
> > > +                                 false);
> > >     spin_unlock(&kvm->mmu_lock);
> > >
> > >     /*
> > > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > > index 819c185adf09..ba871c52ef8b 100644
> > > --- a/arch/x86/kvm/vmx/vmx.c
> > > +++ b/arch/x86/kvm/vmx/vmx.c
> > > @@ -7538,8 +7538,7 @@ static void vmx_sched_in(struct kvm_vcpu *vcpu, int cpu)
> > >  static void vmx_slot_enable_log_dirty(struct kvm *kvm,
> > >                                  struct kvm_memory_slot *slot)
> > >  {
> > > -   if (!kvm_dirty_log_manual_protect_and_init_set(kvm))
> > > -           kvm_mmu_slot_leaf_clear_dirty(kvm, slot);
> > > +   kvm_mmu_slot_leaf_clear_dirty(kvm, slot);
> > >     kvm_mmu_slot_largepage_remove_write_access(kvm, slot);
> > >  }
> > >
> > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > index d39d6cf1d473..c31c32f1424b 100644
> > > --- a/arch/x86/kvm/x86.c
> > > +++ b/arch/x86/kvm/x86.c
> > > @@ -10225,22 +10225,18 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
> > >      * is enabled the D-bit or the W-bit will be cleared.
> > >      */
> > >     if (new->flags & KVM_MEM_LOG_DIRTY_PAGES) {
> > > +           /*
> > > +            * If we're with initial-all-set, we don't need
> > > +            * to write protect any page because they're
> > > +            * reported as dirty already.
> > > +            */
> > > +           if (kvm_dirty_log_manual_protect_and_init_set(kvm))
> > > +                   return;
> > > +
> > >             if (kvm_x86_ops.slot_enable_log_dirty) {
> > >                     kvm_x86_ops.slot_enable_log_dirty(kvm, new);
> > >             } else {
> > > -                   int level =
> > > -                           kvm_dirty_log_manual_protect_and_init_set(kvm) ?
> > > -                           PG_LEVEL_2M : PG_LEVEL_4K;
> > > -
> > > -                   /*
> > > -                    * If we're with initial-all-set, we don't need
> > > -                    * to write protect any small page because
> > > -                    * they're reported as dirty already.  However
> > > -                    * we still need to write-protect huge pages
> > > -                    * so that the page split can happen lazily on
> > > -                    * the first write to the huge page.
> > > -                    */
> > > -                   kvm_mmu_slot_remove_write_access(kvm, new, level);
> > > +                   kvm_mmu_slot_remove_write_access(kvm, new);
> > >             }
> > >     } else {
> > >             if (kvm_x86_ops.slot_disable_log_dirty)
> > >
