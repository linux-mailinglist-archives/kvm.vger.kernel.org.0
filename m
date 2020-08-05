Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E63F23CD08
	for <lists+kvm@lfdr.de>; Wed,  5 Aug 2020 19:16:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728615AbgHEROp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Aug 2020 13:14:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728513AbgHERKy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Aug 2020 13:10:54 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 884C4C061575
        for <kvm@vger.kernel.org>; Wed,  5 Aug 2020 10:10:54 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id g14so9193694iom.0
        for <kvm@vger.kernel.org>; Wed, 05 Aug 2020 10:10:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LKoP11nkvOdBjLbNMsJ6mS897rkmdxw+OMORh/Gp4dA=;
        b=GpjIVCI6a03/UEs6DBRtDfOpuL79ZJtMen/Mx6fZk9kE0pYngE8oVpJLMswOW46JmA
         MhDigq/7/enDILO0WaKYgKJkvhFgk8iJZ+1/kn0awByH6AewETF70nYT93b2wNenFSSf
         O0nKjUlmlhkJ/G6AMGe7Cx5QGmXJMo3szYzc08E9epEo7OvxDGBxFU/6DUIFchoqvJrt
         xd0T9/EgwuW07QgS0vyjPEUBxl7COwhsSiCzioyOmeRqCeSmJYJaG1rmVrQXYzarwdbT
         5i9O10bY3rojgoz2kH6ePLtQh1bF4stYMgMls32QWdnovhan2/+4ppo8cBNhW8Gzb04k
         0nFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LKoP11nkvOdBjLbNMsJ6mS897rkmdxw+OMORh/Gp4dA=;
        b=qv2874tl22TX5qfTtliscsHIDhVtIbSXyUqNuRqXpe3WZTBK5mqERCa/zN4ZEHBG3F
         tZpGyQQwNXy6IDvcd3ckn+kXN2vjop5SNtC2D41q8ZyXjDo6dk7phhdkD4awGoRa+5Hs
         Qq4QqpLSdvHXAMH73Mms/DcXc2huWBZPjfgkeu3IRnbMY60AkaU78KVtOG1XkFO9V/2I
         ikl2jb++Otgz1q7+dQPlXdWXVX6+If7Q1y26y1qYkrX+UU9cxTtUjUc0NSMt72u5cN2U
         uLtNeCVIPBM5ACMRrHxKDMc//M83ug5a0A6rz4j29v5dCOFd0wrrM8Qm0G6am7Kmsend
         681Q==
X-Gm-Message-State: AOAM532EaVxm8PQBTcZV5TjnoRSe9niJxQneQx4nT5MtnbIMvaDw4wLj
        exr135ayWuSr5sOuBpyaK0skVQ03boLxIT39z2KfDmaUMXc=
X-Google-Smtp-Source: ABdhPJwvU0rq9b8X9APyOBTEnYQ8zXpYCksXMZ/jVli4oSFBnrGrMT7ShfLdmvkIb4kHg6uOWdLqfxAZLVmF4H1neRc=
X-Received: by 2002:a05:6602:1343:: with SMTP id i3mr4316598iov.134.1596647453522;
 Wed, 05 Aug 2020 10:10:53 -0700 (PDT)
MIME-Version: 1.0
References: <20200727203324.2614917-1-bgardon@google.com> <20200804211444.GA31916@linux.intel.com>
In-Reply-To: <20200804211444.GA31916@linux.intel.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Wed, 5 Aug 2020 10:10:42 -0700
Message-ID: <CANgfPd9kbnzW+eaBi+dwA1+E2VXEd6JfN4n2PstWrmh4VPRFjA@mail.gmail.com>
Subject: Re: [PATCH 1/1] kvm: mmu: zap pages when zapping only parent
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 4, 2020 at 2:14 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Mon, Jul 27, 2020 at 01:33:24PM -0700, Ben Gardon wrote:
> > When the KVM MMU zaps a page, it will recursively zap the unsynced child
> > pages, but not the synced ones. This can create problems over time when
> > running many nested guests because it leaves unlinked pages which will not
> > be freed until the page quota is hit. With the default page quota of 20
> > shadow pages per 1000 guest pages, this looks like a memory leak and can
> > degrade MMU performance.
> >
> > In a recent benchmark, substantial performance degradation was observed:
> > An L1 guest was booted with 64G memory.
> > 2G nested Windows guests were booted, 10 at a time for 20
> > iterations. (200 total boots)
> > Windows was used in this benchmark because they touch all of their
> > memory on startup.
> > By the end of the benchmark, the nested guests were taking ~10% longer
> > to boot. With this patch there is no degradation in boot time.
> > Without this patch the benchmark ends with hundreds of thousands of
> > stale EPT02 pages cluttering up rmaps and the page hash map. As a
> > result, VM shutdown is also much slower: deleting memslot 0 was
> > observed to take over a minute. With this patch it takes just a
> > few miliseconds.
> >
> > If TDP is enabled, zap child shadow pages when zapping the only parent
> > shadow page.
>
> Comments on the mechanics below.  For the approach itself, I wonder if we
> could/should go even further, i.e. be even more aggressive in reaping nested
> TDP shadow pages.
>
> For this to work, KVM is effectively relying on the write flooding detection
> in kvm_mmu_pte_write() to kick in, i.e. KVM needs the L1 VMM to overwrite
> the TDP tables that L1 was using for L2.  In particular, L1 needs to write
> the upper level TDP entries in order for L0 to effeciently reclaim memory.
>
> For HyperV as L1, I believe that will happen sooner than later as HyperV
> maintains a pool of zeroed pages, i.e. L1 will quickly zero out the old TDP
> entries and trigger the zap.
>
> For KVM as L1, that may not hold true for all scenarios due to lazy zeroing
> of memory.  If L1 is creating and destroying VMs (as in the benchmark), then
> it will work as expected.  But if L1 creates and destroys a large L2 without
> reallocating all memory used for L2's TDP tables, the write flooding will
> never happen and L0 will keep the stale SPs even though L2 is dead.
>
> The above scenario may or may not be problematic in practice.  I would
> assume any reasonably active L1 will quickly do something with the old TDP
> memory and trigger write flooding, but at the same time it's plausible that
> L1 could leave pages unused for a decent amount of time.
>
> One thought would be to track nested TDP PGDs and periodically purge PGDs
> that haven't been used in some arbitrary amount of time and/or an arbitrary
> threshold for the number of nested TDP PGDs is reached.  That being said,
> either of those is probably overkill without more analysis on the below
> approach.

We thought about this as well, but in the absence of a workload which
doesn't get sufficient reclaim from write flooding, it didn't seem
worth implementing.

>
> > Tested by running the kvm-unit-tests suite on an Intel Haswell machine.
> > No regressions versus
> > commit c34b26b98cac ("KVM: MIPS: clean up redundant 'kvm_run' parameters"),
> > or warnings.
> >
> > Reviewed-by: Peter Shier <pshier@google.com>
> > Signed-off-by: Ben Gardon <bgardon@google.com>
> > ---
> >  arch/x86/kvm/mmu/mmu.c | 49 +++++++++++++++++++++++++++++++++++++-----
> >  1 file changed, 44 insertions(+), 5 deletions(-)
> >
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index fa506aaaf0194..c550bc3831dcc 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -2626,13 +2626,52 @@ static bool mmu_page_zap_pte(struct kvm *kvm, struct kvm_mmu_page *sp,
> >       return false;
> >  }
> >
> > -static void kvm_mmu_page_unlink_children(struct kvm *kvm,
> > -                                      struct kvm_mmu_page *sp)
> > +static int kvm_mmu_page_unlink_children(struct kvm *kvm,
> > +                                     struct kvm_mmu_page *sp,
> > +                                     struct list_head *invalid_list)
> >  {
> >       unsigned i;
> > +     int zapped = 0;
> > +
> > +     for (i = 0; i < PT64_ENT_PER_PAGE; ++i) {
> > +             u64 *sptep = sp->spt + i;
> > +             u64 spte = *sptep;
> > +             struct kvm_mmu_page *child_sp;
> > +
> > +             /*
> > +              * Zap the page table entry, unlinking any potential child
> > +              * page
> > +              */
> > +             mmu_page_zap_pte(kvm, sp, sptep);
> > +
> > +             /* If there is no child page for this spte, continue */
> > +             if (!is_shadow_present_pte(spte) ||
> > +                 is_last_spte(spte, sp->role.level))
> > +                     continue;
> > +
> > +             /*
> > +              * If TDP is enabled, then any shadow pages are part of either
> > +              * the EPT01 or an EPT02. In either case, do not expect the
> > +              * same pattern of page reuse seen in x86 PTs for
> > +              * copy-on-write  and similar techniques. In this case, it is
> > +              * unlikely that a parentless shadow PT will be used again in
> > +              * the near future. Zap it to keep the rmaps and page hash
> > +              * maps from filling up with stale EPT02 pages.
> > +              */
> > +             if (!tdp_enabled)
> > +                     continue;
>
> I haven't tested, but I believe this will have the unwanted side effect of
> blasting large swaths of EPT01 if recycling is triggered.  Because the list
> of active SPs is FIFO (and never reordered), the first entries are almost
> always the root SP and then high level SPs.  If make_mmu_pages_available()
> triggers kvm_mmu_zap_oldest_mmu_pages(), this is take out the high level SP
> and all its children.
>
> That may or may not be a problem in practice, but it's outside the scope of
> what this patch is trying to accomplish.
>
> TL;DR: what about further conditioning this on sp->role.guest_mode?

I agree this is a potential problem and conditioning on
sp->role.guest_mode seems like an adequate solution for preventing
this leaky behavior for nested. If there were a better way to get the
recursive zapping for all TDP structures without the reclaim being
overly aggressive, that feels more intuitive, but certainly more work
to implement. I suppose a parameter could be added when zapping to
prevent recursive zapping but I'm happy with the guest mode condition
for now.

>
> > +
> > +             child_sp = to_shadow_page(spte & PT64_BASE_ADDR_MASK);
> > +             if (WARN_ON_ONCE(!child_sp))
>
> This WARN is pointless, mmu_page_zap_pte() above will already have dereferenced
> the child shadow page, i.e. any null pointer will have exploded.
>
> > +                     continue;
> > +
> > +             /* Zap the page if it has no remaining parent pages */
> > +             if (!child_sp->parent_ptes.val)
>
> IMO it's easier to read if these checks are collapsed, e.g.:
>
>                 if (!tdp_enabled || !child_sp->role.guest_mode ||
>                     child_sp->parent_ptes.val)
>                         continue;
>
>                 zapped += kvm_mmu_prepare_zap_page(kvm, child_sp, invalid_list);
>
>
> Alternatively, what about moving this logic into mmu_page_zap_pte()?  That
> can be done with a little massaging of FNAME(invlpg) and would avoid what is
> effectively redundant checks on is_shadow_present_pte() and is_last_spte().
> Patches attached and somewhat tested.

That seems like a good change to me and the patches you attached look
good to me. I'm happy to review them more if you want to send them to
the mailing list as their own series. Thanks for putting them
together.

>
> > +                     zapped += kvm_mmu_prepare_zap_page(kvm, child_sp,
> > +                                                        invalid_list);
> > +     }
> >
> > -     for (i = 0; i < PT64_ENT_PER_PAGE; ++i)
> > -             mmu_page_zap_pte(kvm, sp, sp->spt + i);
> > +     return zapped;
> >  }
> >
> >  static void kvm_mmu_unlink_parents(struct kvm *kvm, struct kvm_mmu_page *sp)
> > @@ -2678,7 +2717,7 @@ static bool __kvm_mmu_prepare_zap_page(struct kvm *kvm,
> >       trace_kvm_mmu_prepare_zap_page(sp);
> >       ++kvm->stat.mmu_shadow_zapped;
> >       *nr_zapped = mmu_zap_unsync_children(kvm, sp, invalid_list);
> > -     kvm_mmu_page_unlink_children(kvm, sp);
> > +     *nr_zapped += kvm_mmu_page_unlink_children(kvm, sp, invalid_list);
> >       kvm_mmu_unlink_parents(kvm, sp);
> >
> >       /* Zapping children means active_mmu_pages has become unstable. */
> > --
> > 2.28.0.rc0.142.g3c755180ce-goog
> >
