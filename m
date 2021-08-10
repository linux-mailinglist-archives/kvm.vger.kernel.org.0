Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65F143E8639
	for <lists+kvm@lfdr.de>; Wed, 11 Aug 2021 00:51:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235194AbhHJWvx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Aug 2021 18:51:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235206AbhHJWvq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Aug 2021 18:51:46 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57B17C0613D3
        for <kvm@vger.kernel.org>; Tue, 10 Aug 2021 15:51:23 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id x27so1256444lfu.5
        for <kvm@vger.kernel.org>; Tue, 10 Aug 2021 15:51:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VbatiMRsmAmXs4vvzOB1wH4t9q57JJ3mkBuPvNIsKCI=;
        b=mr1DdnmU/DedJywtjPvwTpIi7QANHO5wn/LcXPDTieDNUCu+vftmZDm42dNZywkXaG
         atTnR+G+qnVLo0itmllONYpTKa0Q5N3kic8TPitZT8uIZkzsfHXSFMvsjhoNCy8yIjQ7
         aA1EDCgeUHeEeZygUFXFBDUo696pTu7NLCn3wTP7P2zmnnknK+/iaDzcOComn+wj1kNV
         8EQm0F3+DapNhOJBjFiBejnql70w/kSYLF8Yxec5Ce/njYVqAjoqsm67xuwqwQML/oa/
         zmODy9FqOasgjocF4ZdQE4YdmsUnjKxFITWV8ozsgaS7euOEbmxkNfIYbC0XooOfnA76
         +HAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VbatiMRsmAmXs4vvzOB1wH4t9q57JJ3mkBuPvNIsKCI=;
        b=qJinsBMDTCYazDCLd4G0F9mMgi0I1K0HYMl9VdD3eoMVHxmtER+AF4kFl5mjF8Et+0
         aWBA5odEPHKLTJt9E3dNn2H8ByTMD+ygxzy3DHZqcyB301eHf19Dw8UKWnhBZW6srPMU
         dlMNReiPV8CuiFrK7UoqUAxYb9Mw/3Et3pdB1F/skld4IRGAS5aRsuNU1bvjbc6fmd1z
         I5x8P3lY6DKwSi8kBgYMLZffSrBrKNbs7H2nIK/VBQknUCQE6dUHe1qmako3vzMS91gT
         rP1rHPx5qRQBKtdNUhMb7scbAJXbVu4kbOmnju4h+UN3VtZOIHTriEaTJiy6/+o5yyoU
         L2mA==
X-Gm-Message-State: AOAM531vF5QCCTxfhkv7CnZ2DTpmJgPsFhasV6wjiQHeQ/MNb27go7Oe
        0MfIO2XmNO3aQ76yixuMjWTRq5V1LDrhMby3oolJ9A==
X-Google-Smtp-Source: ABdhPJziQ6ODztQCpbyqJ6pgCmyWIQb7M9v95gDyRQspKyPkvXk8V/sTq4xygUHnDD4SO31Tkk5lKXsWLUf9xw8v+NM=
X-Received: by 2002:ac2:442a:: with SMTP id w10mr1554388lfl.473.1628635881069;
 Tue, 10 Aug 2021 15:51:21 -0700 (PDT)
MIME-Version: 1.0
References: <20210810223238.979194-1-jingzhangos@google.com> <CAM3pwhH+c9K0X5me7668QBjtT3vomZdToG8k6u-f5bXvNYuLNg@mail.gmail.com>
In-Reply-To: <CAM3pwhH+c9K0X5me7668QBjtT3vomZdToG8k6u-f5bXvNYuLNg@mail.gmail.com>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Tue, 10 Aug 2021 15:51:10 -0700
Message-ID: <CAAdAUtiWXaA5v1YkFBaDf3+Yp5QgbcFee=7_Qft6cJkUL=jKpA@mail.gmail.com>
Subject: Re: [PATCH] KVM: stats: Add VM dirty_pages stats for the number of
 dirty pages
To:     Peter Feiner <pfeiner@google.com>
Cc:     KVM <kvm@vger.kernel.org>, KVMPPC <kvm-ppc@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 10, 2021 at 3:45 PM Peter Feiner <pfeiner@google.com> wrote:
>
> On Tue, Aug 10, 2021 at 3:32 PM Jing Zhang <jingzhangos@google.com> wrote:
> >
> > Add a generic VM stats dirty_pages to record the number of dirty pages
> > reflected in dirty_bitmap at the moment.
> >
> > Original-by: Peter Feiner <pfeiner@google.com>
> > Signed-off-by: Jing Zhang <jingzhangos@google.com>
> > ---
> >  arch/powerpc/kvm/book3s_64_mmu_hv.c    |  8 ++++++--
> >  arch/powerpc/kvm/book3s_64_mmu_radix.c |  1 +
> >  arch/powerpc/kvm/book3s_hv_rm_mmu.c    |  1 +
> >  include/linux/kvm_host.h               |  3 ++-
> >  include/linux/kvm_types.h              |  1 +
> >  virt/kvm/kvm_main.c                    | 26 +++++++++++++++++++++++---
> >  6 files changed, 34 insertions(+), 6 deletions(-)
> >
> > diff --git a/arch/powerpc/kvm/book3s_64_mmu_hv.c b/arch/powerpc/kvm/book3s_64_mmu_hv.c
> > index c63e263312a4..e4aafa10efa1 100644
> > --- a/arch/powerpc/kvm/book3s_64_mmu_hv.c
> > +++ b/arch/powerpc/kvm/book3s_64_mmu_hv.c
> > @@ -1122,8 +1122,10 @@ long kvmppc_hv_get_dirty_log_hpt(struct kvm *kvm,
> >                  * since we always put huge-page HPTEs in the rmap chain
> >                  * corresponding to their page base address.
> >                  */
> > -               if (npages)
> > +               if (npages) {
> >                         set_dirty_bits(map, i, npages);
> > +                       kvm->stat.generic.dirty_pages += npages;
> > +               }
> >                 ++rmapp;
> >         }
> >         preempt_enable();
> > @@ -1178,8 +1180,10 @@ void kvmppc_unpin_guest_page(struct kvm *kvm, void *va, unsigned long gpa,
> >         gfn = gpa >> PAGE_SHIFT;
> >         srcu_idx = srcu_read_lock(&kvm->srcu);
> >         memslot = gfn_to_memslot(kvm, gfn);
> > -       if (memslot && memslot->dirty_bitmap)
> > +       if (memslot && memslot->dirty_bitmap) {
> >                 set_bit_le(gfn - memslot->base_gfn, memslot->dirty_bitmap);
> > +               ++kvm->stat.generic.dirty_pages;
> > +       }
> >         srcu_read_unlock(&kvm->srcu, srcu_idx);
> >  }
> >
> > diff --git a/arch/powerpc/kvm/book3s_64_mmu_radix.c b/arch/powerpc/kvm/book3s_64_mmu_radix.c
> > index b5905ae4377c..3a6cb3854a44 100644
> > --- a/arch/powerpc/kvm/book3s_64_mmu_radix.c
> > +++ b/arch/powerpc/kvm/book3s_64_mmu_radix.c
> > @@ -1150,6 +1150,7 @@ long kvmppc_hv_get_dirty_log_radix(struct kvm *kvm,
> >                 j = i + 1;
> >                 if (npages) {
> >                         set_dirty_bits(map, i, npages);
> > +                       kvm->stat.generic.dirty_pages += npages;
> >                         j = i + npages;
> >                 }
> >         }
> > diff --git a/arch/powerpc/kvm/book3s_hv_rm_mmu.c b/arch/powerpc/kvm/book3s_hv_rm_mmu.c
> > index 632b2545072b..16806bc473fa 100644
> > --- a/arch/powerpc/kvm/book3s_hv_rm_mmu.c
> > +++ b/arch/powerpc/kvm/book3s_hv_rm_mmu.c
> > @@ -109,6 +109,7 @@ void kvmppc_update_dirty_map(const struct kvm_memory_slot *memslot,
> >         npages = (psize + PAGE_SIZE - 1) / PAGE_SIZE;
> >         gfn -= memslot->base_gfn;
> >         set_dirty_bits_atomic(memslot->dirty_bitmap, gfn, npages);
> > +       kvm->stat.generic.dirty_pages += npages;
> >  }
> >  EXPORT_SYMBOL_GPL(kvmppc_update_dirty_map);
> >
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index f50bfcf225f0..1e8e66fb915b 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -1421,7 +1421,8 @@ struct _kvm_stats_desc {
> >                 KVM_STATS_BASE_POW10, -9)
> >
> >  #define KVM_GENERIC_VM_STATS()                                                \
> > -       STATS_DESC_COUNTER(VM_GENERIC, remote_tlb_flush)
> > +       STATS_DESC_COUNTER(VM_GENERIC, remote_tlb_flush),                      \
> > +       STATS_DESC_COUNTER(VM_GENERIC, dirty_pages)
> >
> >  #define KVM_GENERIC_VCPU_STATS()                                              \
> >         STATS_DESC_COUNTER(VCPU_GENERIC, halt_successful_poll),                \
> > diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
> > index ed6a985c5680..6c05df00aebf 100644
> > --- a/include/linux/kvm_types.h
> > +++ b/include/linux/kvm_types.h
> > @@ -78,6 +78,7 @@ struct kvm_mmu_memory_cache {
> >
> >  struct kvm_vm_stat_generic {
> >         u64 remote_tlb_flush;
> > +       u64 dirty_pages;
> >  };
> >
> >  struct kvm_vcpu_stat_generic {
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index a438a7a3774a..93f0ca2ea326 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -1228,6 +1228,19 @@ static int kvm_alloc_dirty_bitmap(struct kvm_memory_slot *memslot)
> >         return 0;
> >  }
> >
> > +static inline unsigned long hweight_dirty_bitmap(
> > +                                               struct kvm_memory_slot *memslot)
> > +{
> > +       unsigned long i;
> > +       unsigned long count = 0;
> > +       unsigned long n = kvm_dirty_bitmap_bytes(memslot);
> > +
> > +       for (i = 0; i < n / sizeof(long); ++i)
> > +               count += hweight_long(memslot->dirty_bitmap[i]);
> > +
> > +       return count;
> > +}
> > +
> >  /*
> >   * Delete a memslot by decrementing the number of used slots and shifting all
> >   * other entries in the array forward one spot.
> > @@ -1612,6 +1625,7 @@ static int kvm_delete_memslot(struct kvm *kvm,
> >         if (r)
> >                 return r;
> >
> > +       kvm->stat.generic.dirty_pages -= hweight_dirty_bitmap(old);
> >         kvm_free_memslot(kvm, old);
> >         return 0;
> >  }
> > @@ -1733,8 +1747,10 @@ int __kvm_set_memory_region(struct kvm *kvm,
> >         if (r)
> >                 goto out_bitmap;
> >
> > -       if (old.dirty_bitmap && !new.dirty_bitmap)
> > +       if (old.dirty_bitmap && !new.dirty_bitmap) {
> > +               kvm->stat.generic.dirty_pages -= hweight_dirty_bitmap(&old);
> >                 kvm_destroy_dirty_bitmap(&old);
> > +       }
> >         return 0;
> >
> >  out_bitmap:
> > @@ -1895,6 +1911,7 @@ static int kvm_get_dirty_log_protect(struct kvm *kvm, struct kvm_dirty_log *log)
> >                         offset = i * BITS_PER_LONG;
> >                         kvm_arch_mmu_enable_log_dirty_pt_masked(kvm, memslot,
> >                                                                 offset, mask);
> > +                       kvm->stat.generic.dirty_pages -= hweight_long(mask);
> >                 }
> >                 KVM_MMU_UNLOCK(kvm);
> >         }
> > @@ -2012,6 +2029,7 @@ static int kvm_clear_dirty_log_protect(struct kvm *kvm,
> >                         flush = true;
> >                         kvm_arch_mmu_enable_log_dirty_pt_masked(kvm, memslot,
> >                                                                 offset, mask);
> > +                       kvm->stat.generic.dirty_pages -= hweight_long(mask);
> >                 }
> >         }
> >         KVM_MMU_UNLOCK(kvm);
> > @@ -3062,11 +3080,13 @@ void mark_page_dirty_in_slot(struct kvm *kvm,
> >                 unsigned long rel_gfn = gfn - memslot->base_gfn;
> >                 u32 slot = (memslot->as_id << 16) | memslot->id;
> >
> > -               if (kvm->dirty_ring_size)
> > +               if (kvm->dirty_ring_size) {
> >                         kvm_dirty_ring_push(kvm_dirty_ring_get(kvm),
> >                                             slot, rel_gfn);
> > -               else
> > +               } else {
> >                         set_bit_le(rel_gfn, memslot->dirty_bitmap);
> > +                       ++kvm->stat.generic.dirty_pages;
>
> Couple of problems here:
>
> - Calls to mark_page_dirty_in_slot aren't serialized by the mmu_lock,
> so these updates will race.
> - The page might already be dirty in the bitmap, so you're potentially
> double counting here
>
> You can fix both of these problems by changing set_bit_le to a
> test_and_set_bit_le (might not be the function name -- but you get the
> idea) and conditionally incrementing dirty_pages.
Thanks Peter, will do that.
>
>
> > +               }
> >         }
> >  }
> >  EXPORT_SYMBOL_GPL(mark_page_dirty_in_slot);
> >
> > base-commit: d0732b0f8884d9cc0eca0082bbaef043f3fef7fb
> > --
> > 2.32.0.605.g8dce9f2422-goog
> >
Jing
