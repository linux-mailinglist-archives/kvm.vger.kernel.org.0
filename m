Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F8BF65C636
	for <lists+kvm@lfdr.de>; Tue,  3 Jan 2023 19:27:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238908AbjACS1b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Jan 2023 13:27:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238954AbjACS1H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Jan 2023 13:27:07 -0500
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9525FF5D
        for <kvm@vger.kernel.org>; Tue,  3 Jan 2023 10:26:52 -0800 (PST)
Received: by mail-yb1-xb2d.google.com with SMTP id n78so34004073yba.12
        for <kvm@vger.kernel.org>; Tue, 03 Jan 2023 10:26:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=pq3R+dMUCBtQBXaTENIPK+pFT96E7II7s9kyI9TK3FA=;
        b=qtM6NgWaiVqZCrj8mlfOBfl9chZFnGk7FZeAhK0wy71zu0Jbt2DGUrwpnG+p6HliNC
         wO2NaOlbCKIgyAgsIjNe/ikj5/5528+86PkkSkuC0kNwPWkn7sa5m7z0RYJ3nJKeFbCh
         qKMd4AqqUqZL4N4KitDhTrxCoBKchw+0ODvu4s+qk5ApqgNxN5YNl00Xc/+j+jTj5Zf3
         pPUGZsWkOgqVLfWCcj3yYEHcaOdmMTAoL6Jc05sJ/Hh4r2FXvyZEmzUYIWm9n0Tt0b7y
         GzMQ8UT2wOaVw/bOcZ1dvM88egQWS4WawD4MiF/7QBnjCih+TPZ3Cy6Y3OPb5R3FTuf3
         76FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pq3R+dMUCBtQBXaTENIPK+pFT96E7II7s9kyI9TK3FA=;
        b=wJbm0pd8FAVpWed4ffXpzDqVsYurpXZy7eOSm22xKnypd1AJJC1eHQrW4hwjwKNNUX
         pBRvCtkrypxP8yOP4yZ4TU+giJIT0pxeeUMXq4sZfXJdc97VUxgSiCvew8Ss4HduFklB
         Dik1Szg8uM3/byQ8X729exT1v8LTC2cP8D4K7cN82/5kyaZY/QnKO/8Ku3iTzFZ/WEdy
         fV3bjarHjCToKVlzTRhYbd2ppcbYUQDKU/17CPnQFUGnnlCmrBwvS6uJPnumvlV7xMpA
         nMKwMZKgIleD8BZfZPEOog+6Q7UTKExshx+NnuOmx8wGI9sAziuQBqcVZoZ1x9ZOaqfS
         VR0Q==
X-Gm-Message-State: AFqh2kps8HekdUE8XGFNGWVqx4C8ZZ6TgdNZpSQdAMASMDNdvs7rBqD8
        MXaZz8maNYyKflpTs4Gw/D2zcl8m7uy5zD2cpAugW+F1JsHsrA==
X-Google-Smtp-Source: AMrXdXtz9fE389kox3Zm+Hqn9n1jIVfUW3PvUCQvVSXTI5E+gIl9S5H+OLruEjvmoAaAls5jjJ+8Df66Dwj9ERutr3Y=
X-Received: by 2002:a25:da14:0:b0:707:34cf:b4b1 with SMTP id
 n20-20020a25da14000000b0070734cfb4b1mr4286913ybf.123.1672770411475; Tue, 03
 Jan 2023 10:26:51 -0800 (PST)
MIME-Version: 1.0
References: <20221222023457.1764-1-vipinsh@google.com> <20221222023457.1764-6-vipinsh@google.com>
 <Y64VG4Bl0fujE2qG@google.com>
In-Reply-To: <Y64VG4Bl0fujE2qG@google.com>
From:   Vipin Sharma <vipinsh@google.com>
Date:   Tue, 3 Jan 2023 10:26:15 -0800
Message-ID: <CAHVum0eE+bJw7vaYczipR5v8h94QzAkddz6etQKYkEBz6+zZoQ@mail.gmail.com>
Subject: Re: [Patch v3 5/9] KVM: x86/mmu: Allocate TDP page table's page on
 correct NUMA node on split
To:     David Matlack <dmatlack@google.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, bgardon@google.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
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

On Thu, Dec 29, 2022 at 2:30 PM David Matlack <dmatlack@google.com> wrote:
>
> On Wed, Dec 21, 2022 at 06:34:53PM -0800, Vipin Sharma wrote:
> > When dirty log is enabled, huge pages are split. Page table's pages
> > during the split are allocated based on the current thread NUMA node or
> > mempolicy. This causes inefficient page table accesses if underlying
> > page is on a different NUMA node
> >
> > Allocate page table's pages on the same NUMA node as the underlying huge
> > page when dirty log is enabled and huge pages are split.
> >
> > The performance gain during the pre-copy phase of live migrations of a
> > 416 vCPUs and 11 TiB memory VM  on a 8 node host was seen in the range
> > of 130% to 150%.
>
> Can you be more specific about this. "The performance" is vague. I know
> it's an internal workload and fully explaining it would be difficult,
> but you can give readers a slightly more specific idea of what improved.
> e.g.
>
>  When testing with a synthetic write-heavy workload in a 416 vCPU VM on
>  an 8 NUMA node host, the throughput increased by 150% from X to Y
>  operations per second.
>
> It's also necessary to characterize the improvement relative to the
> performance when dirty logging is not enabled. Whithout that information
> it would be hard for an unfamiliar reader to understand how useful this
> change really is.
>
> For example, let's say the throughput of your workload is 100,000
> operations per second before dirty logging is enabled, and that drops
> down to 1,000 operations per second after dirty logging is enabled. This
> commit could increase that by 150% to 2,500 operations per second, but
> that's actually not a very meaningful improvement since, either way,
> guest performance is degraded by 95+% during dirty logging.
>
> On the other hand, if performance goes from 100,000 to 30,000 normally,
> and this commit increases that 30,000 to 75,000 (150%), that's a much
> more meaningful improvement.
>

Yeah, I will provide more insight in the next version.

> >
> > Suggested-by: David Matlack <dmatlack@google.com>
> > Signed-off-by: Vipin Sharma <vipinsh@google.com>
> > ---
> >  arch/x86/kvm/mmu/tdp_mmu.c | 12 ++++++++----
> >  include/linux/kvm_host.h   | 18 ++++++++++++++++++
> >  2 files changed, 26 insertions(+), 4 deletions(-)
> >
> > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > index 4974fa96deff..376b8dceb3f9 100644
> > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > @@ -1403,7 +1403,7 @@ bool kvm_tdp_mmu_wrprot_slot(struct kvm *kvm,
> >       return spte_set;
> >  }
> >
> > -static struct kvm_mmu_page *__tdp_mmu_alloc_sp_for_split(gfp_t gfp)
> > +static struct kvm_mmu_page *__tdp_mmu_alloc_sp_for_split(int nid, gfp_t gfp)
> >  {
> >       struct kvm_mmu_page *sp;
> >
> > @@ -1413,7 +1413,8 @@ static struct kvm_mmu_page *__tdp_mmu_alloc_sp_for_split(gfp_t gfp)
> >       if (!sp)
> >               return NULL;
> >
> > -     sp->spt = (void *)__get_free_page(gfp);
> > +     sp->spt = kvm_mmu_get_free_page(nid, gfp);
> > +
> >       if (!sp->spt) {
> >               kmem_cache_free(mmu_page_header_cache, sp);
> >               return NULL;
> > @@ -1427,6 +1428,9 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(struct kvm *kvm,
> >                                                      bool shared)
> >  {
> >       struct kvm_mmu_page *sp;
> > +     int nid;
> > +
> > +     nid = kvm_pfn_to_page_table_nid(spte_to_pfn(iter->old_spte));
> >
> >       /*
> >        * Since we are allocating while under the MMU lock we have to be
> > @@ -1437,7 +1441,7 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(struct kvm *kvm,
> >        * If this allocation fails we drop the lock and retry with reclaim
> >        * allowed.
> >        */
> > -     sp = __tdp_mmu_alloc_sp_for_split(GFP_NOWAIT | __GFP_ACCOUNT);
> > +     sp = __tdp_mmu_alloc_sp_for_split(nid, GFP_NOWAIT | __GFP_ACCOUNT);
> >       if (sp)
> >               return sp;
> >
> > @@ -1449,7 +1453,7 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(struct kvm *kvm,
> >               write_unlock(&kvm->mmu_lock);
> >
> >       iter->yielded = true;
> > -     sp = __tdp_mmu_alloc_sp_for_split(GFP_KERNEL_ACCOUNT);
> > +     sp = __tdp_mmu_alloc_sp_for_split(nid, GFP_KERNEL_ACCOUNT);
> >
> >       if (shared)
> >               read_lock(&kvm->mmu_lock);
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index d48064503b88..a262e15ebd19 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -1583,6 +1583,24 @@ void kvm_arch_sync_events(struct kvm *kvm);
> >  int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu);
> >
> >  struct page *kvm_pfn_to_refcounted_page(kvm_pfn_t pfn);
> > +
> > +/*
> > + * Tells the appropriate NUMA node location of the page table's page based on
> > + * pfn it will point to.
>
> I know what you are trying to say but the wording is a bit awkward. e.g.
> "Tells" instead of "Returns", "location" is redundant, "page table's
> page", etc. Suggest this:
>
> /*
>  * Returns an appropriate NUMA node on which to allocate a page table that
>  * maps @pfn.
>  */
>
> > + *
> > + * Return the nid of the page if pfn is valid and backed by a refcounted page,
> > + * otherwise, return the nearest memory node for the current CPU.
>
> I would just drop this as it's just restating the code, which is already
> very readable.
>

Okay.

> > + */
> > +static inline int kvm_pfn_to_page_table_nid(kvm_pfn_t pfn)
> > +{
> > +     struct page *page = kvm_pfn_to_refcounted_page(pfn);
> > +
> > +     if (page)
> > +             return page_to_nid(page);
> > +     else
> > +             return numa_mem_id();
> > +}
> > +
> >  bool kvm_is_zone_device_page(struct page *page);
> >
> >  struct kvm_irq_ack_notifier {
> > --
> > 2.39.0.314.g84b9a713c41-goog
> >
