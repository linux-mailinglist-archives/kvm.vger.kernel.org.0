Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E24B67D48F
	for <lists+kvm@lfdr.de>; Thu, 26 Jan 2023 19:46:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230287AbjAZSp7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Jan 2023 13:45:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbjAZSp5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Jan 2023 13:45:57 -0500
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C501BB
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 10:45:56 -0800 (PST)
Received: by mail-qt1-x82e.google.com with SMTP id v19so2041998qtq.13
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 10:45:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=HL/JrLeUR6yzDk5IQceW57W/oCLNgKmEtj/CfP/yK2w=;
        b=kFqmg1WDyPDj6ngTNbcKq9UXXI8vj4V5vcl1YSI1Qe5dQCdOs2QvYVI7Okig1Dt/U9
         LupTkiTmpDY08VKwwnkdjCsML/HV8bOOQi+flOPtPT9wImK8q5cJlDv0B207A0lOuQZk
         9YXvB0he1HrW/oBNpFQFM1CClTiMfcimwanqr/Lfc03AiVAjp9aCnsthTpLDkuEtKCOF
         1XLvMJeTpH5biM/7rQwZqfNiMss/OvDUuFOM8ahYWBXtt3ca1LbQSw/cv0+9E/2bVOPE
         BsXgv++P5Dz+h1uUSP8nsFzbkVAPIxjv/gd0p/hewuzVTET1HMJvn1jCFQCEBokORWlN
         qbpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HL/JrLeUR6yzDk5IQceW57W/oCLNgKmEtj/CfP/yK2w=;
        b=CL6yt63i8EZB3aQ6B3s6VpfEOeAdsheQHbJ0PMer8iFK2MEnqjk/r2bS0U8wIemNac
         TUczJ6J+bE01AZQcgsulFEw+LTFPt8KNMOEBPJNILxSqKVzSCAYwkxZ7MCkuzmkp0c8K
         pee96mm2O/l4qbv9/raHg4qZA/S5UsCKQ+0WEyjNAFZwY84o1PEHQLZ+L3riVRNDzdt0
         phDTGBX3u7vUS9TXSJ47qtokkEp22YwT0RrGYl5xWm0pwD+oHNHjKCPQTpSIaLTPCITS
         2DQJGoqY0Ov3OHM4WAG01BsKPXlE33mZsktzfBBRA30ZntZE9uUifzK+FUzNPFiuQld+
         qghw==
X-Gm-Message-State: AO0yUKVlH/2qL60O9TllKTe19CO5Llm6A0dxPW8YXeK4MFeSf8GSvZMa
        3uPCRYVSIKz5LmOgpK6d9qh7KajIqDbCx4qfi//4yg==
X-Google-Smtp-Source: AK7set8sLSWp5oFRcNSsjuqMglEUdmFKKF58L807xtHJ3vPxcvhfg0U0Q18ext6WUojHj76WidB3f+fdEJJQ5Y9uBhY=
X-Received: by 2002:a05:622a:1996:b0:3b8:1078:2112 with SMTP id
 u22-20020a05622a199600b003b810782112mr193800qtc.385.1674758755281; Thu, 26
 Jan 2023 10:45:55 -0800 (PST)
MIME-Version: 1.0
References: <20230113035000.480021-1-ricarkol@google.com> <20230113035000.480021-7-ricarkol@google.com>
 <Y9BfdgL+JSYCirvm@thinky-boi>
In-Reply-To: <Y9BfdgL+JSYCirvm@thinky-boi>
From:   Ricardo Koller <ricarkol@google.com>
Date:   Thu, 26 Jan 2023 10:45:43 -0800
Message-ID: <CAOHnOrysMhp_8Kdv=Pe-O8ZGDbhN5HiHWVhBv795_E6+4RAzPw@mail.gmail.com>
Subject: Re: [PATCH 6/9] KVM: arm64: Split huge pages when dirty logging is enabled
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     pbonzini@redhat.com, maz@kernel.org, oupton@google.com,
        yuzenghui@huawei.com, dmatlack@google.com, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, qperret@google.com,
        catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, gshan@redhat.com, reijiw@google.com,
        rananta@google.com, bgardon@google.com, ricarkol@gmail.com
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

On Tue, Jan 24, 2023 at 2:45 PM Oliver Upton <oliver.upton@linux.dev> wrote:
>
> Hi Ricardo,
>
> On Fri, Jan 13, 2023 at 03:49:57AM +0000, Ricardo Koller wrote:
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
> >  arch/arm64/include/asm/kvm_host.h |  30 ++++++++
> >  arch/arm64/kvm/mmu.c              | 110 +++++++++++++++++++++++++++++-
> >  2 files changed, 138 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index 35a159d131b5..6ab37209b1d1 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -153,6 +153,36 @@ struct kvm_s2_mmu {
> >       /* The last vcpu id that ran on each physical CPU */
> >       int __percpu *last_vcpu_ran;
> >
> > +     /*
> > +      * Memory cache used to split EAGER_PAGE_SPLIT_CHUNK_SIZE worth of huge
> > +      * pages. It is used to allocate stage2 page tables while splitting
> > +      * huge pages. Its capacity should be EAGER_PAGE_SPLIT_CACHE_CAPACITY.
> > +      * Note that the choice of EAGER_PAGE_SPLIT_CHUNK_SIZE influences both
> > +      * the capacity of the split page cache (CACHE_CAPACITY), and how often
> > +      * KVM reschedules. Be wary of raising CHUNK_SIZE too high.
> > +      *
> > +      * A good heuristic to pick CHUNK_SIZE is that it should be larger than
> > +      * all the available huge-page sizes, and be a multiple of all the
> > +      * other ones; for example, 1GB when all the available huge-page sizes
> > +      * are (1GB, 2MB, 32MB, 512MB).
> > +      *
> > +      * CACHE_CAPACITY should have enough pages to cover CHUNK_SIZE; for
> > +      * example, 1GB requires the following number of PAGE_SIZE-pages:
> > +      * - 512 when using 2MB hugepages with 4KB granules (1GB / 2MB).
> > +      * - 513 when using 1GB hugepages with 4KB granules (1 + (1GB / 2MB)).
> > +      * - 32 when using 32MB hugepages with 16KB granule (1GB / 32MB).
> > +      * - 2 when using 512MB hugepages with 64KB granules (1GB / 512MB).
> > +      * CACHE_CAPACITY below assumes the worst case: 1GB hugepages with 4KB
> > +      * granules.
> > +      *
> > +      * Protected by kvm->slots_lock.
> > +      */
> > +#define EAGER_PAGE_SPLIT_CHUNK_SIZE                 SZ_1G
> > +#define EAGER_PAGE_SPLIT_CACHE_CAPACITY                                      \
> > +     (DIV_ROUND_UP_ULL(EAGER_PAGE_SPLIT_CHUNK_SIZE, SZ_1G) +         \
> > +      DIV_ROUND_UP_ULL(EAGER_PAGE_SPLIT_CHUNK_SIZE, SZ_2M))
>
> Could you instead make use of the existing KVM_PGTABLE_MIN_BLOCK_LEVEL
> as the batch size? 513 pages across all page sizes is a non-negligible
> amount of memory that goes largely unused when PAGE_SIZE != 4K.
>

Sounds good, will refine this for v2.

> With that change it is a lot easier to correctly match the cache
> capacity to the selected page size. Additionally, we continue to have a
> single set of batching logic that we can improve later on.
>
> > +     struct kvm_mmu_memory_cache split_page_cache;
> > +
> >       struct kvm_arch *arch;
> >  };
> >
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index 700c5774b50d..41ee330edae3 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -31,14 +31,24 @@ static phys_addr_t hyp_idmap_vector;
> >
> >  static unsigned long io_map_base;
> >
> > -static phys_addr_t stage2_range_addr_end(phys_addr_t addr, phys_addr_t end)
> > +bool __read_mostly eager_page_split = true;
> > +module_param(eager_page_split, bool, 0644);
> > +
>
> Unless someone is really begging for it I'd prefer we not add a module
> parameter for this.

It was mainly to match x86 and because it makes perf testing a bit
simpler. What do others think?

>
> > +static phys_addr_t __stage2_range_addr_end(phys_addr_t addr, phys_addr_t end,
> > +                                        phys_addr_t size)
> >  {
> > -     phys_addr_t size = kvm_granule_size(KVM_PGTABLE_MIN_BLOCK_LEVEL);
> >       phys_addr_t boundary = ALIGN_DOWN(addr + size, size);
> >
> >       return (boundary - 1 < end - 1) ? boundary : end;
> >  }
> >
> > +static phys_addr_t stage2_range_addr_end(phys_addr_t addr, phys_addr_t end)
> > +{
> > +     phys_addr_t size = kvm_granule_size(KVM_PGTABLE_MIN_BLOCK_LEVEL);
> > +
> > +     return __stage2_range_addr_end(addr, end, size);
> > +}
> > +
> >  /*
> >   * Release kvm_mmu_lock periodically if the memory region is large. Otherwise,
> >   * we may see kernel panics with CONFIG_DETECT_HUNG_TASK,
> > @@ -71,6 +81,64 @@ static int stage2_apply_range(struct kvm *kvm, phys_addr_t addr,
> >       return ret;
> >  }
> >
> > +static inline bool need_topup(struct kvm_mmu_memory_cache *cache, int min)
> > +{
> > +     return kvm_mmu_memory_cache_nr_free_objects(cache) < min;
> > +}
>
> I don't think the helper is adding too much here.

Will try how it looks without.

>
> > +static bool need_topup_split_page_cache_or_resched(struct kvm *kvm)
> > +{
> > +     struct kvm_mmu_memory_cache *cache;
> > +
> > +     if (need_resched() || rwlock_needbreak(&kvm->mmu_lock))
> > +             return true;
> > +
> > +     cache = &kvm->arch.mmu.split_page_cache;
> > +     return need_topup(cache, EAGER_PAGE_SPLIT_CACHE_CAPACITY);
> > +}
> > +
> > +static int kvm_mmu_split_huge_pages(struct kvm *kvm, phys_addr_t addr,
> > +                           phys_addr_t end)
> > +{
> > +     struct kvm_mmu_memory_cache *cache;
> > +     struct kvm_pgtable *pgt;
> > +     int ret;
> > +     u64 next;
> > +     int cache_capacity = EAGER_PAGE_SPLIT_CACHE_CAPACITY;
> > +
> > +     lockdep_assert_held_write(&kvm->mmu_lock);
>
> Rather than having the caller acquire the lock, can you instead do it
> here? It would appear that the entire critical section is enclosed
> within this function.

Sure. I will first double check things related to perf and correctness
just in case.
I'm not sure if the increase of acquire/releases makes any difference in perf.
Also, not sure if there's a correctness issue because of releasing the lock
between WP and split (I think it should be fine, but not 100% sure).

>
> > +     lockdep_assert_held(&kvm->slots_lock);
>
> This function doesn't depend on anything guarded by the slots_lock, can
> you move this to kvm_mmu_split_memory_region()?

kvm_mmu_split_memory_region() takes a memslot.
That works in this case, eager splitting when enabling dirty logging, but won't
work in the next commit when spliting on the CLEAR ioctl.

>
> > +     cache = &kvm->arch.mmu.split_page_cache;
> > +
> > +     do {
> > +             if (need_topup_split_page_cache_or_resched(kvm)) {
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
> > +
> > +             next = __stage2_range_addr_end(addr, end,
> > +                                            EAGER_PAGE_SPLIT_CHUNK_SIZE);
> > +             ret = kvm_pgtable_stage2_split(pgt, addr, next - addr, cache);
> > +             if (ret)
> > +                     break;
> > +     } while (addr = next, addr != end);
> > +
> > +     return ret;
> > +}
>
> --
> Thanks,
> Oliver
