Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D5275032F0
	for <lists+kvm@lfdr.de>; Sat, 16 Apr 2022 07:48:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232616AbiDOXiY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Apr 2022 19:38:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234987AbiDOXiX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Apr 2022 19:38:23 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EB5B4D608
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 16:35:53 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id bj36so5003983ljb.13
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 16:35:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zYpJfqJx7d2DxTmeeTs+ZELB+v0k+j7qa41wmKEfKm8=;
        b=aoNecNfazUQ5134uApw0neMDbp1NXEfEPzly1IRzewTBXD7Vwjsy502V4Z4aYMz//k
         x0pTxEQV+ZXR8or+WZYvhy0YNEoqs0vpxkN7Tior9AU2V8lI6+ZPhm1WqTZfFuhqaq3H
         8KK0tPENoezQkx02qVXWQLFKDwfproboTCwZt5ieVpXxQjNYejuFohswv3sjXU4VC/qu
         K9ZO9J9Dqa+9WBymz2MrOLQ+MLHLNInH+88+n7DOmxcq6N0nBOUANZNW8G6aNJBUE6cP
         hNrw5yVfRDEpsa6GzdWDQCmlLVONgTzAZ/ufu7xSTVag9CzUrl+XnMvjBii/gPEMCSmR
         ZUWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zYpJfqJx7d2DxTmeeTs+ZELB+v0k+j7qa41wmKEfKm8=;
        b=ESIyMwbgUiFzrVhds6oUsxYPwEBiyxDFVwzV/pzi0QrTlF7yvpK42wa+CbQaRr+qo7
         epdQgte7NFJV80GOhOrQEOiww/AguIT0A7XySw+NwsdtoWMy0Sd1x0Vw/hurlkdHRTEI
         QDrZqE2DwSi9/fPy0/tMn9WYe1EVeQFwUu+VFF/Hi0c90Rt1WO2iWnjWu4nJPGcAsg0s
         3C8OV+cPDLqVQNUGbkuVaPbJMQv6j/XCB0fvGvVP/BpVOxfJL3bHjuUgDkgx8w/Odk34
         vN3jIuECaInZi+5xoHSLeRfc94l4XW33m1A9ySuOse8UBjRRZ4Sge8oHKEY1QD1O+f05
         27zg==
X-Gm-Message-State: AOAM530ReGvQmIqNandEy1RtaYyxjEYybph0xJA4jGn7pJaU/v6bx4KX
        g4ni/YpKrm4cE/o6PZyPQs8hTVrkuI27H45xKrQb1g==
X-Google-Smtp-Source: ABdhPJzttRIHPAm85L+ywCTI9gtoFQQ9orr9JaLUs7ZlPkwgkiihGblTNr8Csv/qy/WzICTS1ipzGaW1zUtuHswHYWw=
X-Received: by 2002:a05:651c:179f:b0:24b:1406:5f55 with SMTP id
 bn31-20020a05651c179f00b0024b14065f55mr730237ljb.361.1650065751025; Fri, 15
 Apr 2022 16:35:51 -0700 (PDT)
MIME-Version: 1.0
References: <20220415215901.1737897-1-oupton@google.com>
In-Reply-To: <20220415215901.1737897-1-oupton@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Fri, 15 Apr 2022 16:35:24 -0700
Message-ID: <CALzav=c6jQ53G-2gEZYasH_b4_hLYtNAD5pW1TXSfPWxLf3_qw@mail.gmail.com>
Subject: Re: [RFC PATCH 00/17] KVM: arm64: Parallelize stage 2 fault handling
To:     Oliver Upton <oupton@google.com>
Cc:     KVMARM <kvmarm@lists.cs.columbia.edu>,
        kvm list <kvm@vger.kernel.org>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Ben Gardon <bgardon@google.com>
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

On Fri, Apr 15, 2022 at 2:59 PM Oliver Upton <oupton@google.com> wrote:
>
> Presently KVM only takes a read lock for stage 2 faults if it believes
> the fault can be fixed by relaxing permissions on a PTE (write unprotect
> for dirty logging). Otherwise, stage 2 faults grab the write lock, which
> predictably can pile up all the vCPUs in a sufficiently large VM.
>
> The x86 port of KVM has what it calls the TDP MMU. Basically, it is an
> MMU protected by the combination of a read-write lock and RCU, allowing
> page walkers to traverse in parallel.
>
> This series is strongly inspired by the mechanics of the TDP MMU,
> making use of RCU to protect parallel walks. Note that the TLB
> invalidation mechanics are a bit different between x86 and ARM, so we
> need to use the 'break-before-make' sequence to split/collapse a
> block/table mapping, respectively.

An alternative (or perhaps "v2" [1]) is to make x86's TDP MMU
arch-neutral and port it to support ARM's stage-2 MMU. This is based
on a few observations:

- The problems that motivated the development of the TDP MMU are not
x86-specific (e.g. parallelizing faults during the post-copy phase of
Live Migration).
- The synchronization in the TDP MMU (read/write lock, RCU for PT
freeing, atomic compare-exchanges for modifying PTEs) is complex, but
would be equivalent across architectures.
- Eventually RISC-V is going to want similar performance (my
understanding is RISC-V MMU is already a copy-paste of the ARM MMU),
and it'd be a shame to re-implement TDP MMU synchronization a third
time.
- The TDP MMU includes support for various performance features that
would benefit other architectures, such as eager page splitting,
deferred zapping, lockless write-protection resolution, and (coming
soon) in-place huge page promotion.
- And then there's the obvious wins from less code duplication in KVM
(e.g. get rid of the RISC-V MMU copy, increased code test coverage,
...).

The side of this I haven't really looked into yet is ARM's stage-2
MMU, and how amenable it would be to being managed by the TDP MMU. But
I assume it's a conventional page table structure mapping GPAs to
HPAs, which is the most important overlap.

That all being said, an arch-neutral TDP MMU would be a larger, more
complex code change than something like this series (hence my "v2"
caveat above). But I wanted to get this idea out there since the
rubber is starting to hit the road on improving ARM MMU scalability.

[1] "v2" as in the "next evolution" sense, not the "PATCH v2" sense :)





>
> Nonetheless, using atomics on the break side allows fault handlers to
> acquire exclusive access to a PTE (lets just call it locked). Once the
> PTE lock is acquired it is then safe to assume exclusive access.
>
> Special consideration is required when pruning the page tables in
> parallel. Suppose we are collapsing a table into a block. Allowing
> parallel faults means that a software walker could be in the middle of
> a lower level traversal when the table is unlinked. Table
> walkers that prune the paging structures must now 'lock' all descendent
> PTEs, effectively asserting exclusive ownership of the substructure
> (no other walker can install something to an already locked pte).
>
> Additionally, for parallel walks we need to punt the freeing of table
> pages to the next RCU sync, as there could be multiple observers of the
> table until all walkers exit the RCU critical section. For this I
> decided to cram an rcu_head into page private data for every table page.
> We wind up spending a bit more on table pages now, but lazily allocating
> for rcu callbacks probably doesn't make a lot of sense. Not only would
> we need a large cache of them (think about installing a level 1 block)
> to wire up callbacks on all descendent tables, but we also then need to
> spend memory to actually free memory.
>
> I tried to organize these patches as best I could w/o introducing
> intermediate breakage.
>
> The first 5 patches are meant mostly as prepatory reworks, and, in the
> case of RCU a nop.
>
> Patch 6 is quite large, but I had a hard time deciding how to change the
> way we link/unlink tables to use atomics without breaking things along
> the way.
>
> Patch 7 probably should come before patch 6, as it informs the other
> read-side fault (perm relax) about when a map is in progress so it'll
> back off.
>
> Patches 8-10 take care of the pruning case, actually locking the child ptes
> instead of simply dropping table page references along the way. Note
> that we cannot assume a pte points to a table/page at this point, hence
> the same helper is called for pre- and leaf-traversal. Guide the
> recursion based on what got yanked from the PTE.
>
> Patches 11-14 wire up everything to schedule rcu callbacks on
> to-be-freed table pages. rcu_barrier() is called on the way out from
> tearing down a stage 2 page table to guarantee all memory associated
> with the VM has actually been cleaned up.
>
> Patches 15-16 loop in the fault handler to the new table traversal game.
>
> Lastly, patch 17 is a nasty bit of debugging residue to spot possible
> table page leaks. Please don't laugh ;-)
>
> Smoke tested with KVM selftests + kvm_page_table_test w/ 2M hugetlb to
> exercise the table pruning code. Haven't done anything beyond this,
> sending as an RFC now to get eyes on the code.
>
> Applies to commit fb649bda6f56 ("Merge tag 'block-5.18-2022-04-15' of
> git://git.kernel.dk/linux-block")
>
> Oliver Upton (17):
>   KVM: arm64: Directly read owner id field in stage2_pte_is_counted()
>   KVM: arm64: Only read the pte once per visit
>   KVM: arm64: Return the next table from map callbacks
>   KVM: arm64: Protect page table traversal with RCU
>   KVM: arm64: Take an argument to indicate parallel walk
>   KVM: arm64: Implement break-before-make sequence for parallel walks
>   KVM: arm64: Enlighten perm relax path about parallel walks
>   KVM: arm64: Spin off helper for initializing table pte
>   KVM: arm64: Tear down unlinked page tables in parallel walk
>   KVM: arm64: Assume a table pte is already owned in post-order
>     traversal
>   KVM: arm64: Move MMU cache init/destroy into helpers
>   KVM: arm64: Stuff mmu page cache in sub struct
>   KVM: arm64: Setup cache for stage2 page headers
>   KVM: arm64: Punt last page reference to rcu callback for parallel walk
>   KVM: arm64: Allow parallel calls to kvm_pgtable_stage2_map()
>   KVM: arm64: Enable parallel stage 2 MMU faults
>   TESTONLY: KVM: arm64: Add super lazy accounting of stage 2 table pages
>
>  arch/arm64/include/asm/kvm_host.h     |   5 +-
>  arch/arm64/include/asm/kvm_mmu.h      |   2 +
>  arch/arm64/include/asm/kvm_pgtable.h  |  14 +-
>  arch/arm64/kvm/arm.c                  |   4 +-
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c |  13 +-
>  arch/arm64/kvm/hyp/nvhe/setup.c       |  13 +-
>  arch/arm64/kvm/hyp/pgtable.c          | 518 +++++++++++++++++++-------
>  arch/arm64/kvm/mmu.c                  | 120 ++++--
>  8 files changed, 503 insertions(+), 186 deletions(-)
>
> --
> 2.36.0.rc0.470.gd361397f0d-goog
>
