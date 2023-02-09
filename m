Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 813E5690945
	for <lists+kvm@lfdr.de>; Thu,  9 Feb 2023 13:50:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbjBIMuQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Feb 2023 07:50:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbjBIMuP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Feb 2023 07:50:15 -0500
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09EC75DC37
        for <kvm@vger.kernel.org>; Thu,  9 Feb 2023 04:50:14 -0800 (PST)
Received: by mail-qt1-x831.google.com with SMTP id h24so1738872qtr.0
        for <kvm@vger.kernel.org>; Thu, 09 Feb 2023 04:50:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=OLq5d0Pb0Y9i2q1HCXjq3v1rbBIMKf6zWjvZjjEj3No=;
        b=rAa47yiy5g5gSok0BA/CUqGYGKCvor6m3O3jROUTSQn1hKEXjUvAuNZkj1ZtpJSLEA
         SgkTDica7CnzjGR8Fe7mEmSsWWhghULZgWt1Dea+3s2PGnfc99OqnN8SOs7Ld0/SoITm
         kdTnqEhxdx8ankfh1XW7QnM5C64zq0kJX5z26vJ1GCSbG7GOQb71SxoYTXvq0vDmP/qE
         5AVWE5Fs68Wh6TfYkER1koTrdAG4wByz9/Tfpe/iywMGrOHulXgx1jszYn8BniD+nkSu
         VN5+ZuVvYxvvthMYekqXYBFuh+Ntf0v9fye8qFNY+WCQI2GqFH3Ke9T8Tu+cl1qg0cDR
         8xMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OLq5d0Pb0Y9i2q1HCXjq3v1rbBIMKf6zWjvZjjEj3No=;
        b=ui1mC2/yzwN9SCVW3Phuvlkp99c3qobmJ+EYD3grluDpMwPXOV0bFboji5RoEu0T0k
         /EshN+x710mXZVgF2HPR2yxQdCm29NWCNTo6146Oy8tDC0MYJeqet/eGYSJ5MMNYt+6F
         2xOEe+6znpQDNNI/jOQATe2R4z1cPCZ/rM+5OwwPwSWMZyEje3qqbDn4JW30ipFTy44D
         /C3VAeWKsf1b46BAxxKxI6B20+kJP6ewR20+9EfM2elZgDZ2rq6Ljo4OGvjXXFWTpRTU
         RPQg5OxSnpMiEbQaYwefD5SLDT8r2vK5dpLP1m5JkGSpwSM8H4HJXC8D9uFJLTE9XSfO
         2wTg==
X-Gm-Message-State: AO0yUKUpp++P05vnnDFnqg0uTCOIllUsdYkyLxOPnwpRChzmU8jgtulV
        WrCwm7yFN7w/LBjb66FHpKab3t0+sLByk1yh2dcbig==
X-Google-Smtp-Source: AK7set/+aBnibfuQ/eDV6HeKJU0GYyiKfY5h7F23IRHVIhcLrx0TlpalbjK6oyD7YG9T7wZRM2LfUOz4Ka16yoI/jtg=
X-Received: by 2002:ac8:7c4e:0:b0:3ab:6bd6:d3bb with SMTP id
 o14-20020ac87c4e000000b003ab6bd6d3bbmr1601287qtv.6.1675947012934; Thu, 09 Feb
 2023 04:50:12 -0800 (PST)
MIME-Version: 1.0
References: <20230206165851.3106338-1-ricarkol@google.com> <20230206165851.3106338-10-ricarkol@google.com>
 <9201764f-baa1-250a-39ac-0305bce789a3@redhat.com>
In-Reply-To: <9201764f-baa1-250a-39ac-0305bce789a3@redhat.com>
From:   Ricardo Koller <ricarkol@google.com>
Date:   Thu, 9 Feb 2023 04:50:02 -0800
Message-ID: <CAOHnOrzGXU29JK+8aRq0SnMe6Ske04YWffJhPU6iUXjGyyoQtA@mail.gmail.com>
Subject: Re: [PATCH v2 09/12] KVM: arm64: Split huge pages when dirty logging
 is enabled
To:     Gavin Shan <gshan@redhat.com>
Cc:     pbonzini@redhat.com, maz@kernel.org, oupton@google.com,
        yuzenghui@huawei.com, dmatlack@google.com, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, qperret@google.com,
        catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, reijiw@google.com, rananta@google.com,
        bgardon@google.com, ricarkol@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 8, 2023 at 10:26 PM Gavin Shan <gshan@redhat.com> wrote:
>
> Hi Ricardo,
>
> On 2/7/23 3:58 AM, Ricardo Koller wrote:
> > Split huge pages eagerly when enabling dirty logging. The goal is to
> > avoid doing it while faulting on write-protected pages, which
> > negatively impacts guest performance.
> >
> > A memslot marked for dirty logging is split in 1GB pieces at a time.
> > This is in order to release the mmu_lock and give other kernel threads
> > the opportunity to run, and also in order to allocate enough pages to
> > split a 1GB range worth of huge pages (or a single 1GB huge page).
> > Note that these page allocations can fail, so eager page splitting is
> > best-effort.  This is not a correctness issue though, as huge pages
> > can still be split on write-faults.
> >
> > The benefits of eager page splitting are the same as in x86, added
> > with commit a3fe5dbda0a4 ("KVM: x86/mmu: Split huge pages mapped by
> > the TDP MMU when dirty logging is enabled"). For example, when running
> > dirty_log_perf_test with 64 virtual CPUs (Ampere Altra), 1GB per vCPU,
> > 50% reads, and 2MB HugeTLB memory, the time it takes vCPUs to access
> > all of their memory after dirty logging is enabled decreased by 44%
> > from 2.58s to 1.42s.
> >
> > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > ---
> >   arch/arm64/include/asm/kvm_host.h |  16 +++++
> >   arch/arm64/kvm/mmu.c              | 113 +++++++++++++++++++++++++++++-
> >   2 files changed, 127 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index a69a815719cf..eab62d8b3ad4 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -154,6 +154,22 @@ struct kvm_s2_mmu {
> >       int __percpu *last_vcpu_ran;
> >
> >   #define KVM_ARM_EAGER_SPLIT_CHUNK_SIZE_DEFAULT      PMD_SIZE
> > +     /*
> > +      * Memory cache used to split
> > +      * KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE worth of huge pages. It
> > +      * is used to allocate stage2 page tables while splitting huge
> > +      * pages. Note that the choice of EAGER_PAGE_SPLIT_CHUNK_SIZE
> > +      * influences both the capacity of the split page cache, and
> > +      * how often KVM reschedules. Be wary of raising CHUNK_SIZE
> > +      * too high.
> > +      *
> > +      * A good heuristic to pick CHUNK_SIZE is that it should be
> > +      * the size of huge-page to be split.
> > +      *
> > +      * Protected by kvm->slots_lock.
> > +      */
> > +     struct kvm_mmu_memory_cache split_page_cache;
> > +     uint64_t split_page_chunk_size;
> >
> >       struct kvm_arch *arch;
> >   };
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index e2ada6588017..73f8b3953f6a 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -31,14 +31,21 @@ static phys_addr_t hyp_idmap_vector;
> >
> >   static unsigned long io_map_base;
> >
> > -static phys_addr_t stage2_range_addr_end(phys_addr_t addr, phys_addr_t end)
> > +static phys_addr_t __stage2_range_addr_end(phys_addr_t addr, phys_addr_t end,
> > +                                        phys_addr_t size)
> >   {
> > -     phys_addr_t size = kvm_granule_size(KVM_PGTABLE_MIN_BLOCK_LEVEL);
> >       phys_addr_t boundary = ALIGN_DOWN(addr + size, size);
> >
> >       return (boundary - 1 < end - 1) ? boundary : end;
> >   }
> >
> > +static phys_addr_t stage2_range_addr_end(phys_addr_t addr, phys_addr_t end)
> > +{
> > +     phys_addr_t size = kvm_granule_size(KVM_PGTABLE_MIN_BLOCK_LEVEL);
> > +
> > +     return __stage2_range_addr_end(addr, end, size);
> > +}
> > +
> >   /*
> >    * Release kvm_mmu_lock periodically if the memory region is large. Otherwise,
> >    * we may see kernel panics with CONFIG_DETECT_HUNG_TASK,
> > @@ -71,6 +78,72 @@ static int stage2_apply_range(struct kvm *kvm, phys_addr_t addr,
> >       return ret;
> >   }
> >
> > +static bool need_topup_split_page_cache_or_resched(struct kvm *kvm, uint64_t min)
> > +{
> > +     struct kvm_mmu_memory_cache *cache;
> > +
> > +     if (need_resched() || rwlock_needbreak(&kvm->mmu_lock))
> > +             return true;
> > +
> > +     cache = &kvm->arch.mmu.split_page_cache;
> > +     return kvm_mmu_memory_cache_nr_free_objects(cache) < min;
> > +}
> > +
> > +static int kvm_mmu_split_nr_page_tables(u64 range)
> > +{
> > +     int n = 0;
> > +
> > +     if (KVM_PGTABLE_MIN_BLOCK_LEVEL < 2)
> > +             n += DIV_ROUND_UP_ULL(range, PUD_SIZE);
> > +     n += DIV_ROUND_UP_ULL(range, PMD_SIZE);
> > +     return n;
> > +}
> > +
>
> I think it needs comments to explain how the number of page tables are calculated,
> similar to what have been done for stage2_block_get_nr_page_tables() in pgtable.c

Will add a comment.

>
> > +static int kvm_mmu_split_huge_pages(struct kvm *kvm, phys_addr_t addr,
> > +                                 phys_addr_t end)
> > +{
> > +     struct kvm_mmu_memory_cache *cache;
> > +     struct kvm_pgtable *pgt;
> > +     int ret;
> > +     u64 next;
> > +     u64 chunk_size = kvm->arch.mmu.split_page_chunk_size;
> > +     int cache_capacity = kvm_mmu_split_nr_page_tables(chunk_size);
> > +
> > +     if (chunk_size == 0)
> > +             return 0;
> > +
> > +     lockdep_assert_held_write(&kvm->mmu_lock);
> > +
> > +     cache = &kvm->arch.mmu.split_page_cache;
> > +
> > +     do {
> > +             if (need_topup_split_page_cache_or_resched(kvm,
> > +                                                        cache_capacity)) {
> > +                     write_unlock(&kvm->mmu_lock);
> > +                     cond_resched();
> > +                     /* Eager page splitting is best-effort. */
> > +                     ret = __kvm_mmu_topup_memory_cache(cache,
> > +                                                        cache_capacity,
> > +                                                        cache_capacity);
> > +                     write_lock(&kvm->mmu_lock);
> > +                     if (ret)
> > +                             break;
> > +             }
> > +
> > +             pgt = kvm->arch.mmu.pgt;
> > +             if (!pgt)
> > +                     return -EINVAL;
>
> I don't think the check to see @pgt is existing or not because the VM can't be
> created with its page-table isn't allocated and set in kvm_init_stage2_mmu().

GIven that the lock is released/acquired every chunk, the intent was to check
that the page-table wasn't freed in between.

>
> > +
> > +             next = __stage2_range_addr_end(addr, end, chunk_size);
> > +             ret = kvm_pgtable_stage2_split(pgt, addr, next - addr,
> > +                                            cache, cache_capacity);
> > +             if (ret)
> > +                     break;
> > +     } while (addr = next, addr != end);
> > +
> > +     return ret;
> > +}
> > +
> >   #define stage2_apply_range_resched(kvm, addr, end, fn)                      \
> >       stage2_apply_range(kvm, addr, end, fn, true)
> >
>
> I'm wandering if stage2_apply_range() can be reused to avoid invent another similar
> function. the gap are the granularity and conditions to reschedule.

Will try and see what it looks like and report back.

>
> > @@ -772,6 +845,7 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
> >   void kvm_uninit_stage2_mmu(struct kvm *kvm)
> >   {
> >       kvm_free_stage2_pgd(&kvm->arch.mmu);
> > +     kvm_mmu_free_memory_cache(&kvm->arch.mmu.split_page_cache);
> >   }
> >
> >   static void stage2_unmap_memslot(struct kvm *kvm,
> > @@ -999,6 +1073,31 @@ static void kvm_mmu_write_protect_pt_masked(struct kvm *kvm,
> >       stage2_wp_range(&kvm->arch.mmu, start, end);
> >   }
> >
> > +/**
> > + * kvm_mmu_split_memory_region() - split the stage 2 blocks into PAGE_SIZE
> > + *                              pages for memory slot
> > + * @kvm:     The KVM pointer
> > + * @slot:    The memory slot to split
> > + *
> > + * Acquires kvm->mmu_lock. Called with kvm->slots_lock mutex acquired,
> > + * serializing operations for VM memory regions.
> > + */
> > +static void kvm_mmu_split_memory_region(struct kvm *kvm, int slot)
> > +{
> > +     struct kvm_memslots *slots = kvm_memslots(kvm);
> > +     struct kvm_memory_slot *memslot = id_to_memslot(slots, slot);
> > +     phys_addr_t start, end;
> > +
> > +     lockdep_assert_held(&kvm->slots_lock);
> > +
> > +     start = memslot->base_gfn << PAGE_SHIFT;
> > +     end = (memslot->base_gfn + memslot->npages) << PAGE_SHIFT;
> > +
> > +     write_lock(&kvm->mmu_lock);
> > +     kvm_mmu_split_huge_pages(kvm, start, end);
> > +     write_unlock(&kvm->mmu_lock);
> > +}
> > +
> >   /*
> >    * kvm_arch_mmu_enable_log_dirty_pt_masked - enable dirty logging for selected
> >    * dirty pages.
> > @@ -1790,6 +1889,16 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
> >                       return;
> >
> >               kvm_mmu_wp_memory_region(kvm, new->id);
> > +             kvm_mmu_split_memory_region(kvm, new->id);
> > +     } else {
> > +             /*
> > +              * Free any leftovers from the eager page splitting cache. Do
> > +              * this when deleting, moving, disabling dirty logging, or
> > +              * creating the memslot (a nop). Doing it for deletes makes
> > +              * sure we don't leak memory, and there's no need to keep the
> > +              * cache around for any of the other cases.
> > +              */
> > +             kvm_mmu_free_memory_cache(&kvm->arch.mmu.split_page_cache);
> >       }
> >   }
> >
> >
>
> Thanks,
> Gavin
>
