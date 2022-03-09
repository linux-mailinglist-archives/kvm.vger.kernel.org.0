Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 187094D3DA6
	for <lists+kvm@lfdr.de>; Thu, 10 Mar 2022 00:40:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235703AbiCIXlP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Mar 2022 18:41:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234502AbiCIXlN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Mar 2022 18:41:13 -0500
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DECCBA2504
        for <kvm@vger.kernel.org>; Wed,  9 Mar 2022 15:40:12 -0800 (PST)
Received: by mail-lj1-x22b.google.com with SMTP id h11so5437722ljb.2
        for <kvm@vger.kernel.org>; Wed, 09 Mar 2022 15:40:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=knqnMeGEvDhSgvwI6jEQykXZc5wcL4E6yQFTl2iBXg0=;
        b=qB4LgheQoMWtM8zYQ4xsxNray0a29Fj+XFZlD1qFUtKCOgg96i6kyl176Rjo76iRVH
         Eo2noStRp88UtpYIz9mIoHibi12W655Qu9Rn8t16zWRKm3lag6mDAwi6zDuSdvka8A9P
         kCeYtnOxR3HXYtO12wKJ5cNpA5KkIBebdMmv2iMTEG5Lz7Uzdymo7m4v3aCqf9Nqce04
         /V2t5RWNMK0HvHmliE3Nlf5WBkEHbU2CAIimACv/rj+ZH4TGTWRgzHn3agmvwoCxM7GA
         JF+301lukgG14jb/UiRhsUZVaenGmBmvJrtRahJ6RjXomND7Q/VCnaxgU0C7uN2TxKuS
         t3Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=knqnMeGEvDhSgvwI6jEQykXZc5wcL4E6yQFTl2iBXg0=;
        b=zqUa3a0jTByVO188fSQBbMghF/NHxT+4DyefZpuzsMS5ZWG2UvjmUEA0GTz722S9i3
         vtX7RFA54oxfG94wuUQhtvm6Yd6UCLbN7NG7tdl/OO8/6v9pfljLTaqASrB4oYIWKtMb
         cIBAJLiaEuto4hVyUrUyj3zLd7iRp0TyR5C+8jP49tA2FyJRzOf4fKKwKkuQeadqu5rU
         fqAIbcuRfuZUhgTNZ2GTpG4dk7IC6I/9fLMlcdMw96qNvVoN+Sn7zLDfWfdfr/9P5LlN
         J1ZTACEO1mrn38yadwINJbvPfcP5yt2CotqWT9n5tCcxxGxCEUpio0hItYpXlNg5DOo7
         g7pQ==
X-Gm-Message-State: AOAM530Ik5L7kZe4vLnP1jHtNa1Vh9jGWvb3bXHsQHB4Gvg9m6gUy22Z
        Yp1p7fCs4Pz9FX5fKYa+uVnkB3bh0fmGk5xwVD5NjA==
X-Google-Smtp-Source: ABdhPJyd+o3dzDroQ6lEj/qcLCbBZSex9zVujaEAwf+AZwy7XJ8NJNeqc9LkTGRBQ5GCHLb+gR0nm+8LDH0bJ3hJwKI=
X-Received: by 2002:a2e:390c:0:b0:248:1b88:d6c4 with SMTP id
 g12-20020a2e390c000000b002481b88d6c4mr188804lja.49.1646869210887; Wed, 09 Mar
 2022 15:40:10 -0800 (PST)
MIME-Version: 1.0
References: <20220203010051.2813563-1-dmatlack@google.com> <YiWWdekvbPjI/WZm@xz-m1.local>
 <CALzav=fzOkR4oNXoccc40GKzdBrmA+q5bgKE9ViE5W0UYjjHmw@mail.gmail.com> <YihX2rcVIqOd/Yej@xz-m1.local>
In-Reply-To: <YihX2rcVIqOd/Yej@xz-m1.local>
From:   David Matlack <dmatlack@google.com>
Date:   Wed, 9 Mar 2022 15:39:44 -0800
Message-ID: <CALzav=dewe5jovbk-QbHUyzH5ipRxMT923n8847jyVhLKkUbBA@mail.gmail.com>
Subject: Re: [PATCH 00/23] Extend Eager Page Splitting to the shadow MMU
To:     Peter Xu <peterx@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        leksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Peter Feiner <pfeiner@google.com>,
        Andrew Jones <drjones@redhat.com>,
        "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
        kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 8, 2022 at 11:31 PM Peter Xu <peterx@redhat.com> wrote:
>
> On Mon, Mar 07, 2022 at 03:39:37PM -0800, David Matlack wrote:
> > On Sun, Mar 6, 2022 at 9:22 PM Peter Xu <peterx@redhat.com> wrote:
> > >
> > > Hi, David,
> > >
> > > Sorry for a very late comment.
> > >
> > > On Thu, Feb 03, 2022 at 01:00:28AM +0000, David Matlack wrote:
> > > > Performance
> > > > -----------
> > > >
> > > > Eager page splitting moves the cost of splitting huge pages off of the
> > > > vCPU thread and onto the thread invoking VM-ioctls to configure dirty
> > > > logging. This is useful because:
> > > >
> > > >  - Splitting on the vCPU thread interrupts vCPUs execution and is
> > > >    disruptive to customers whereas splitting on VM ioctl threads can
> > > >    run in parallel with vCPU execution.
> > > >
> > > >  - Splitting on the VM ioctl thread is more efficient because it does
> > > >    no require performing VM-exit handling and page table walks for every
> > > >    4K page.
> > > >
> > > > To measure the performance impact of Eager Page Splitting I ran
> > > > dirty_log_perf_test with tdp_mmu=N, various virtual CPU counts, 1GiB per
> > > > vCPU, and backed by 1GiB HugeTLB memory.
> > > >
> > > > To measure the imapct of customer performance, we can look at the time
> > > > it takes all vCPUs to dirty memory after dirty logging has been enabled.
> > > > Without Eager Page Splitting enabled, such dirtying must take faults to
> > > > split huge pages and bottleneck on the MMU lock.
> > > >
> > > >              | "Iteration 1 dirty memory time"             |
> > > >              | ------------------------------------------- |
> > > > vCPU Count   | eager_page_split=N   | eager_page_split=Y   |
> > > > ------------ | -------------------- | -------------------- |
> > > > 2            | 0.310786549s         | 0.058731929s         |
> > > > 4            | 0.419165587s         | 0.059615316s         |
> > > > 8            | 1.061233860s         | 0.060945457s         |
> > > > 16           | 2.852955595s         | 0.067069980s         |
> > > > 32           | 7.032750509s         | 0.078623606s         |
> > > > 64           | 16.501287504s        | 0.083914116s         |
> > > >
> > > > Eager Page Splitting does increase the time it takes to enable dirty
> > > > logging when not using initially-all-set, since that's when KVM splits
> > > > huge pages. However, this runs in parallel with vCPU execution and does
> > > > not bottleneck on the MMU lock.
> > > >
> > > >              | "Enabling dirty logging time"               |
> > > >              | ------------------------------------------- |
> > > > vCPU Count   | eager_page_split=N   | eager_page_split=Y   |
> > > > ------------ | -------------------- | -------------------- |
> > > > 2            | 0.001581619s         |  0.025699730s        |
> > > > 4            | 0.003138664s         |  0.051510208s        |
> > > > 8            | 0.006247177s         |  0.102960379s        |
> > > > 16           | 0.012603892s         |  0.206949435s        |
> > > > 32           | 0.026428036s         |  0.435855597s        |
> > > > 64           | 0.103826796s         |  1.199686530s        |
> > > >
> > > > Similarly, Eager Page Splitting increases the time it takes to clear the
> > > > dirty log for when using initially-all-set. The first time userspace
> > > > clears the dirty log, KVM will split huge pages:
> > > >
> > > >              | "Iteration 1 clear dirty log time"          |
> > > >              | ------------------------------------------- |
> > > > vCPU Count   | eager_page_split=N   | eager_page_split=Y   |
> > > > ------------ | -------------------- | -------------------- |
> > > > 2            | 0.001544730s         | 0.055327916s         |
> > > > 4            | 0.003145920s         | 0.111887354s         |
> > > > 8            | 0.006306964s         | 0.223920530s         |
> > > > 16           | 0.012681628s         | 0.447849488s         |
> > > > 32           | 0.026827560s         | 0.943874520s         |
> > > > 64           | 0.090461490s         | 2.664388025s         |
> > > >
> > > > Subsequent calls to clear the dirty log incur almost no additional cost
> > > > since KVM can very quickly determine there are no more huge pages to
> > > > split via the RMAP. This is unlike the TDP MMU which must re-traverse
> > > > the entire page table to check for huge pages.
> > > >
> > > >              | "Iteration 2 clear dirty log time"          |
> > > >              | ------------------------------------------- |
> > > > vCPU Count   | eager_page_split=N   | eager_page_split=Y   |
> > > > ------------ | -------------------- | -------------------- |
> > > > 2            | 0.015613726s         | 0.015771982s         |
> > > > 4            | 0.031456620s         | 0.031911594s         |
> > > > 8            | 0.063341572s         | 0.063837403s         |
> > > > 16           | 0.128409332s         | 0.127484064s         |
> > > > 32           | 0.255635696s         | 0.268837996s         |
> > > > 64           | 0.695572818s         | 0.700420727s         |
> > >
> > > Are all the tests above with ept=Y (except the one below)?
> >
> > Yes.
> >
> > >
> > > >
> > > > Eager Page Splitting also improves the performance for shadow paging
> > > > configurations, as measured with ept=N. Although the absolute gains are
> > > > less since ept=N requires taking the MMU lock to track writes to 4KiB
> > > > pages (i.e. no fast_page_fault() or PML), which dominates the dirty
> > > > memory time.
> > > >
> > > >              | "Iteration 1 dirty memory time"             |
> > > >              | ------------------------------------------- |
> > > > vCPU Count   | eager_page_split=N   | eager_page_split=Y   |
> > > > ------------ | -------------------- | -------------------- |
> > > > 2            | 0.373022770s         | 0.348926043s         |
> > > > 4            | 0.563697483s         | 0.453022037s         |
> > > > 8            | 1.588492808s         | 1.524962010s         |
> > > > 16           | 3.988934732s         | 3.369129917s         |
> > > > 32           | 9.470333115s         | 8.292953856s         |
> > > > 64           | 20.086419186s        | 18.531840021s        |
> > >
> > > This one is definitely for ept=N because it's written there. That's ~10%
> > > performance increase which looks still good, but IMHO that increase is
> > > "debatable" since a normal guest may not simply write over the whole guest
> > > mem.. So that 10% increase is based on some assumptions.
> > >
> > > What if the guest writes 80% and reads 20%?  IIUC the split thread will
> > > also start to block the readers too for shadow mmu while it was not blocked
> > > previusly?  From that pov, not sure whether the series needs some more
> > > justification, as the changeset seems still large.
> > >
> > > Is there other benefits besides the 10% increase on writes?
> >
> > Yes, in fact workloads that perform some reads will benefit _more_
> > than workloads that perform only writes.
> >
> > The reason is that the current lazy splitting approach unmaps the
> > entire huge page on write and then maps in the just the faulting 4K
> > page. That means reads on the unmapped portion of the hugepage will
> > now take a fault and require the MMU lock. In contrast, Eager Page
> > Splitting fully splits each huge page so readers should never take
> > faults.
> >
> > For example, here is the data with 20% writes and 80% reads (i.e. pass
> > `-f 5` to dirty_log_perf_test):
> >
> >              | "Iteration 1 dirty memory time"             |
> >              | ------------------------------------------- |
> > vCPU Count   | eager_page_split=N   | eager_page_split=Y   |
> > ------------ | -------------------- | -------------------- |
> > 2            | 0.403108098s         | 0.071808764s         |
> > 4            | 0.562173582s         | 0.105272819s         |
> > 8            | 1.382974557s         | 0.248713796s         |
> > 16           | 3.608993666s         | 0.571990327s         |
> > 32           | 9.100678321s         | 1.702453103s         |
> > 64           | 19.784780903s        | 3.489443239s        |
>
> It's very interesting to know these numbers, thanks for sharing that.
>
> Above reminded me that eager page split actually does two things:
>
> (1) When a page is mapped as huge, we "assume" this whole page will be
>     accessed in the near future, so when split is needed we map all the
>     small ptes, and,

Note, this series does not add this behavior to the fault path.

>
> (2) We move the split operation from page faults to when enable-dirty-track
>     happens.
>
> We could have done (1) already without the whole eager split patchsets: if
> we see a read-only huge page on a page fault, we could populat the whole
> range of ptes, only marking current small pte writable but leaving the rest
> small ptes wr-protected.  I had a feeling this will speedup the above 19.78
> seconds (64 cores case) fairly much too to some point.

The problem with (1) is that it still requires faults to split the
huge pages. Those faults will need to contend for the MMU lock, and
will hold the lock for longer than they do today since they are doing
extra work.

I agree there might be some benefit for workloads, but for write-heavy
workloads there will still be a "thundering herd" problem when dirty
logging is first enable. I'll admit though I have not testing this
approach.

An alternative approach to handling read-heavy workloads we're looking
at is to perform dirty logging at 2M.

>
> Entry (1) makes a lot of sense to me; OTOH I can understand entry (2) but
> not strongly.
>
> My previous concern was majorly about having readers being blocked during
> splitting of huge pages (not after).  For shadow mmu, IIUC the split thread
> will start to take write lock rather than read lock (comparing to tdp mmu),
> hence any vcpu page faults (hmm, not only reader but writters too I think
> with non-present pte..) will be blocked longer than before, am I right?
>
> Meanwhile for shadow mmu I think there can be more page tables to walk
> comparing to the tdp mmu for a single huge page to split?  My understanding
> is tdp mmu pgtables are mostly limited by the number of address spaces (?),
> but shadow pgtables are per-task.

Or per-L2 VM, in the case of nested virtualization.

> So I'm not sure whether for a guest with
> a lot of active tasks sharing pages, the split thread can spend quite some
> time splitting, during which time with write lock held without releasing.

The eager page splitting code does check for contention and drop the
MMU lock in between every SPTE it tries to split. But there still
might be some increase in contention due to eager page splitting.

>
> These are kind of against the purpose of eager split on shadowing, which is
> to reduce influence for guest vcpu threads?  But I can't tell, I could have
> missed something else.  It's just that when applying the idea to shadow mmu
> it sounds less attractive than the tdp mmu case.

The shadow MMU is also used for Nested Virtualization, which is a bit
different from "typical" shadow paging (ept/npt=N) because VMs tend
not to share pages, their page tables are fairly static (compared to
process page tables), and they tend to be longer lived. So there will
not be as much steady-state MMU lock contention that would be
negatively impacted by eager page splitting.

You might be right though that ept/npt=N has enough steady-state MMU
lock contention that it will notice eager page splitting. But then
again, it would be even more affected by lazy splitting unless the
guest is doing very few writes.

>
> Thanks,
>
> --
> Peter Xu
>
