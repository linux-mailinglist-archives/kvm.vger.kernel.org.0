Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD7724D297D
	for <lists+kvm@lfdr.de>; Wed,  9 Mar 2022 08:31:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230360AbiCIHcw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Mar 2022 02:32:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbiCIHcu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Mar 2022 02:32:50 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6BFFE9F39F
        for <kvm@vger.kernel.org>; Tue,  8 Mar 2022 23:31:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646811111;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wzCDe7ukalZP7qeVLqDkjDCYsOVcxtLI99jzIVWHMDE=;
        b=WYl1gGbG4xZkcg17dkoOijOi0LnFweIqpzQppvEMtdTpZuOm5A5R4TI+gO0FGC/1w3yxk0
        98xrRVRyFmvpkTJL2NA+PSO4kXDcc0tpUGEphbFUJuEXBd7LyRjuCf53/O+NRcwCB2ak67
        AU1P7EwSmd9lk31PUwOiGL9QMKhBm7Y=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-445-T4kZIv9nOdKfCYt9uU6boA-1; Wed, 09 Mar 2022 02:31:49 -0500
X-MC-Unique: T4kZIv9nOdKfCYt9uU6boA-1
Received: by mail-pl1-f199.google.com with SMTP id x6-20020a1709029a4600b0014efe26b04fso712357plv.21
        for <kvm@vger.kernel.org>; Tue, 08 Mar 2022 23:31:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wzCDe7ukalZP7qeVLqDkjDCYsOVcxtLI99jzIVWHMDE=;
        b=a1AbFVrfW6E6icz8feVsHVrhpuH0sdA0RyhQRQ0ipunTUolrO13/zHbFjJpuXzT5An
         I3afZ5KJ2R7HoDRk9B3JVFleWqig0nNkkHNw5vkF1NSQUznShSClxrg7er2zm1kDnxkp
         hjBK7LrFB4THCwETh6E8CtNHYe6ftB6WfXuv9PBYvWtTJAUcn2ZneBahQFn8updDYh7q
         lSVSK3yyyEs86JSb/TULj2b+1mT/Yc2IaZrDjig4xqvHHrREz3UH3xEcu9S4nrrpaM0P
         epehFHZMUGipHkpX8lN6gVGL4XiCU9cTAKs7nGrp7dtIMJKiEPvzbApl9R7p5ujjd6tW
         2sgA==
X-Gm-Message-State: AOAM5325RQxUhk/pB4gTVydSR7hXBe3DsA/5NKWhA2xpQwUXEzPxWSmr
        tCm1KVKqlG84etLze43qHxaaUQCXliSAEqh1uboayUi+V0K+7FhrW2b8IyVgdLGGzuTy27sc/Xt
        c3pTWerFTeQkS
X-Received: by 2002:a17:902:9a46:b0:14e:ea0f:28cf with SMTP id x6-20020a1709029a4600b0014eea0f28cfmr21518653plv.43.1646811107506;
        Tue, 08 Mar 2022 23:31:47 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyzULhW/WBwT6oTwyHD8Z+OqM5aUr8STYTSzeowgBZdvdbX5lPuJoIVa8qcnrOveJpPCqNlLA==
X-Received: by 2002:a17:902:9a46:b0:14e:ea0f:28cf with SMTP id x6-20020a1709029a4600b0014eea0f28cfmr21518621plv.43.1646811106999;
        Tue, 08 Mar 2022 23:31:46 -0800 (PST)
Received: from xz-m1.local ([94.177.118.47])
        by smtp.gmail.com with ESMTPSA id r15-20020a63ce4f000000b00341c40f913esm1230674pgi.87.2022.03.08.23.31.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 23:31:46 -0800 (PST)
Date:   Wed, 9 Mar 2022 15:31:38 +0800
From:   Peter Xu <peterx@redhat.com>
To:     David Matlack <dmatlack@google.com>
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
Subject: Re: [PATCH 00/23] Extend Eager Page Splitting to the shadow MMU
Message-ID: <YihX2rcVIqOd/Yej@xz-m1.local>
References: <20220203010051.2813563-1-dmatlack@google.com>
 <YiWWdekvbPjI/WZm@xz-m1.local>
 <CALzav=fzOkR4oNXoccc40GKzdBrmA+q5bgKE9ViE5W0UYjjHmw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CALzav=fzOkR4oNXoccc40GKzdBrmA+q5bgKE9ViE5W0UYjjHmw@mail.gmail.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 07, 2022 at 03:39:37PM -0800, David Matlack wrote:
> On Sun, Mar 6, 2022 at 9:22 PM Peter Xu <peterx@redhat.com> wrote:
> >
> > Hi, David,
> >
> > Sorry for a very late comment.
> >
> > On Thu, Feb 03, 2022 at 01:00:28AM +0000, David Matlack wrote:
> > > Performance
> > > -----------
> > >
> > > Eager page splitting moves the cost of splitting huge pages off of the
> > > vCPU thread and onto the thread invoking VM-ioctls to configure dirty
> > > logging. This is useful because:
> > >
> > >  - Splitting on the vCPU thread interrupts vCPUs execution and is
> > >    disruptive to customers whereas splitting on VM ioctl threads can
> > >    run in parallel with vCPU execution.
> > >
> > >  - Splitting on the VM ioctl thread is more efficient because it does
> > >    no require performing VM-exit handling and page table walks for every
> > >    4K page.
> > >
> > > To measure the performance impact of Eager Page Splitting I ran
> > > dirty_log_perf_test with tdp_mmu=N, various virtual CPU counts, 1GiB per
> > > vCPU, and backed by 1GiB HugeTLB memory.
> > >
> > > To measure the imapct of customer performance, we can look at the time
> > > it takes all vCPUs to dirty memory after dirty logging has been enabled.
> > > Without Eager Page Splitting enabled, such dirtying must take faults to
> > > split huge pages and bottleneck on the MMU lock.
> > >
> > >              | "Iteration 1 dirty memory time"             |
> > >              | ------------------------------------------- |
> > > vCPU Count   | eager_page_split=N   | eager_page_split=Y   |
> > > ------------ | -------------------- | -------------------- |
> > > 2            | 0.310786549s         | 0.058731929s         |
> > > 4            | 0.419165587s         | 0.059615316s         |
> > > 8            | 1.061233860s         | 0.060945457s         |
> > > 16           | 2.852955595s         | 0.067069980s         |
> > > 32           | 7.032750509s         | 0.078623606s         |
> > > 64           | 16.501287504s        | 0.083914116s         |
> > >
> > > Eager Page Splitting does increase the time it takes to enable dirty
> > > logging when not using initially-all-set, since that's when KVM splits
> > > huge pages. However, this runs in parallel with vCPU execution and does
> > > not bottleneck on the MMU lock.
> > >
> > >              | "Enabling dirty logging time"               |
> > >              | ------------------------------------------- |
> > > vCPU Count   | eager_page_split=N   | eager_page_split=Y   |
> > > ------------ | -------------------- | -------------------- |
> > > 2            | 0.001581619s         |  0.025699730s        |
> > > 4            | 0.003138664s         |  0.051510208s        |
> > > 8            | 0.006247177s         |  0.102960379s        |
> > > 16           | 0.012603892s         |  0.206949435s        |
> > > 32           | 0.026428036s         |  0.435855597s        |
> > > 64           | 0.103826796s         |  1.199686530s        |
> > >
> > > Similarly, Eager Page Splitting increases the time it takes to clear the
> > > dirty log for when using initially-all-set. The first time userspace
> > > clears the dirty log, KVM will split huge pages:
> > >
> > >              | "Iteration 1 clear dirty log time"          |
> > >              | ------------------------------------------- |
> > > vCPU Count   | eager_page_split=N   | eager_page_split=Y   |
> > > ------------ | -------------------- | -------------------- |
> > > 2            | 0.001544730s         | 0.055327916s         |
> > > 4            | 0.003145920s         | 0.111887354s         |
> > > 8            | 0.006306964s         | 0.223920530s         |
> > > 16           | 0.012681628s         | 0.447849488s         |
> > > 32           | 0.026827560s         | 0.943874520s         |
> > > 64           | 0.090461490s         | 2.664388025s         |
> > >
> > > Subsequent calls to clear the dirty log incur almost no additional cost
> > > since KVM can very quickly determine there are no more huge pages to
> > > split via the RMAP. This is unlike the TDP MMU which must re-traverse
> > > the entire page table to check for huge pages.
> > >
> > >              | "Iteration 2 clear dirty log time"          |
> > >              | ------------------------------------------- |
> > > vCPU Count   | eager_page_split=N   | eager_page_split=Y   |
> > > ------------ | -------------------- | -------------------- |
> > > 2            | 0.015613726s         | 0.015771982s         |
> > > 4            | 0.031456620s         | 0.031911594s         |
> > > 8            | 0.063341572s         | 0.063837403s         |
> > > 16           | 0.128409332s         | 0.127484064s         |
> > > 32           | 0.255635696s         | 0.268837996s         |
> > > 64           | 0.695572818s         | 0.700420727s         |
> >
> > Are all the tests above with ept=Y (except the one below)?
> 
> Yes.
> 
> >
> > >
> > > Eager Page Splitting also improves the performance for shadow paging
> > > configurations, as measured with ept=N. Although the absolute gains are
> > > less since ept=N requires taking the MMU lock to track writes to 4KiB
> > > pages (i.e. no fast_page_fault() or PML), which dominates the dirty
> > > memory time.
> > >
> > >              | "Iteration 1 dirty memory time"             |
> > >              | ------------------------------------------- |
> > > vCPU Count   | eager_page_split=N   | eager_page_split=Y   |
> > > ------------ | -------------------- | -------------------- |
> > > 2            | 0.373022770s         | 0.348926043s         |
> > > 4            | 0.563697483s         | 0.453022037s         |
> > > 8            | 1.588492808s         | 1.524962010s         |
> > > 16           | 3.988934732s         | 3.369129917s         |
> > > 32           | 9.470333115s         | 8.292953856s         |
> > > 64           | 20.086419186s        | 18.531840021s        |
> >
> > This one is definitely for ept=N because it's written there. That's ~10%
> > performance increase which looks still good, but IMHO that increase is
> > "debatable" since a normal guest may not simply write over the whole guest
> > mem.. So that 10% increase is based on some assumptions.
> >
> > What if the guest writes 80% and reads 20%?  IIUC the split thread will
> > also start to block the readers too for shadow mmu while it was not blocked
> > previusly?  From that pov, not sure whether the series needs some more
> > justification, as the changeset seems still large.
> >
> > Is there other benefits besides the 10% increase on writes?
> 
> Yes, in fact workloads that perform some reads will benefit _more_
> than workloads that perform only writes.
> 
> The reason is that the current lazy splitting approach unmaps the
> entire huge page on write and then maps in the just the faulting 4K
> page. That means reads on the unmapped portion of the hugepage will
> now take a fault and require the MMU lock. In contrast, Eager Page
> Splitting fully splits each huge page so readers should never take
> faults.
> 
> For example, here is the data with 20% writes and 80% reads (i.e. pass
> `-f 5` to dirty_log_perf_test):
> 
>              | "Iteration 1 dirty memory time"             |
>              | ------------------------------------------- |
> vCPU Count   | eager_page_split=N   | eager_page_split=Y   |
> ------------ | -------------------- | -------------------- |
> 2            | 0.403108098s         | 0.071808764s         |
> 4            | 0.562173582s         | 0.105272819s         |
> 8            | 1.382974557s         | 0.248713796s         |
> 16           | 3.608993666s         | 0.571990327s         |
> 32           | 9.100678321s         | 1.702453103s         |
> 64           | 19.784780903s        | 3.489443239s        |

It's very interesting to know these numbers, thanks for sharing that.

Above reminded me that eager page split actually does two things:

(1) When a page is mapped as huge, we "assume" this whole page will be
    accessed in the near future, so when split is needed we map all the
    small ptes, and,

(2) We move the split operation from page faults to when enable-dirty-track
    happens.

We could have done (1) already without the whole eager split patchsets: if
we see a read-only huge page on a page fault, we could populat the whole
range of ptes, only marking current small pte writable but leaving the rest
small ptes wr-protected.  I had a feeling this will speedup the above 19.78
seconds (64 cores case) fairly much too to some point.

Entry (1) makes a lot of sense to me; OTOH I can understand entry (2) but
not strongly.

My previous concern was majorly about having readers being blocked during
splitting of huge pages (not after).  For shadow mmu, IIUC the split thread
will start to take write lock rather than read lock (comparing to tdp mmu),
hence any vcpu page faults (hmm, not only reader but writters too I think
with non-present pte..) will be blocked longer than before, am I right?

Meanwhile for shadow mmu I think there can be more page tables to walk
comparing to the tdp mmu for a single huge page to split?  My understanding
is tdp mmu pgtables are mostly limited by the number of address spaces (?),
but shadow pgtables are per-task.  So I'm not sure whether for a guest with
a lot of active tasks sharing pages, the split thread can spend quite some
time splitting, during which time with write lock held without releasing.

These are kind of against the purpose of eager split on shadowing, which is
to reduce influence for guest vcpu threads?  But I can't tell, I could have
missed something else.  It's just that when applying the idea to shadow mmu
it sounds less attractive than the tdp mmu case.

Thanks,

-- 
Peter Xu

