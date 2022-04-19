Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AA0F5076E7
	for <lists+kvm@lfdr.de>; Tue, 19 Apr 2022 19:59:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349941AbiDSSAE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Apr 2022 14:00:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347463AbiDSSAA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Apr 2022 14:00:00 -0400
Received: from mail-yw1-x112d.google.com (mail-yw1-x112d.google.com [IPv6:2607:f8b0:4864:20::112d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3777E10FFA
        for <kvm@vger.kernel.org>; Tue, 19 Apr 2022 10:57:17 -0700 (PDT)
Received: by mail-yw1-x112d.google.com with SMTP id 00721157ae682-2eba37104a2so181823897b3.0
        for <kvm@vger.kernel.org>; Tue, 19 Apr 2022 10:57:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IbS3Xpxm43bSb82M/GpDSiaT9N8mAu6Po3BZDjwUF6A=;
        b=EreiokSozIoFy2pQ8c8zv034yqpvG8UyR2ue3PpVD4YkGEyul8JfgQtOq6X7uNeTr0
         YHHk0naLTx6Xq3LO8yWNXVN9XjpVY9soNj0QPT0B8Kq/dniEtAbs1NiMa55N/HagWaJE
         TALfaleKL/R19tfAb6/O3S05YqsNovEMYe3er73m+K0IyP7j+//VRLC9N6SxK5Gt3svN
         bYyF2BW7ZTZqv5/VII6kybObwakPnnawTxFnARTzW22xfgLEvE6BCUkNRbgJREDT4+U1
         mvXLBrW/MHOOSfZFgBG8fsDbBx9AtOHQ7DWaq1Vp7kX4c6aUl6mASXbC96nFP7PVcQ/F
         Fy/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IbS3Xpxm43bSb82M/GpDSiaT9N8mAu6Po3BZDjwUF6A=;
        b=izPzM/9t+8VBH63VtExZdq1FQtsP/4DQI7iUxzPx3TMnP0UgnWVG11UPWZBI4kxlCC
         o3/kiXR98ByK2Lo1dB0zIYZ5V2JBEQ1Aufg9B+oK5udobO9dZpaWF+DH1jn7jUX7A9z5
         g+k1RpWHR0L28P8lWA7iJaLZ2tLKwYwGmtsQuD4/psi9oBUuEpo9fEc0iAWZcXEvvtsN
         1ihbgJj96yT8r8A6o5F3tFt0YjEMfHWvzns9M2wBDknZr66gKcx8+Ml3G9U4BT/ZQH0+
         1tJTGOez2kXvI6Xu43NM+OOB3hbL5+GApVpgD6nLE4VCGYvHEnM0Gqk4rhN8H9HGQtfG
         L0bQ==
X-Gm-Message-State: AOAM532U5BERzF2zZCxaB7zoOsC98Dp59Z44JoIkj7Fm9alAih5alclP
        CdW4DJWEwcrN66GMcroP0EY0X+VBLYztuD79GbzcPg==
X-Google-Smtp-Source: ABdhPJyZ2F/Bb4tPwUu4up+hTdywsYpbJswod0K4gdZBdKuxntx30CfwXRiDm5TQoF2qpU2Asfrst5xEM850f3smY4w=
X-Received: by 2002:a0d:ccd0:0:b0:2f1:c824:5bba with SMTP id
 o199-20020a0dccd0000000b002f1c8245bbamr4709131ywd.156.1650391036163; Tue, 19
 Apr 2022 10:57:16 -0700 (PDT)
MIME-Version: 1.0
References: <20220415215901.1737897-1-oupton@google.com>
In-Reply-To: <20220415215901.1737897-1-oupton@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Tue, 19 Apr 2022 10:57:05 -0700
Message-ID: <CANgfPd8V5AdH0dEAox2PvKJpqDrqmfJyiwoLpxEGqVfb7EEP9Q@mail.gmail.com>
Subject: Re: [RFC PATCH 00/17] KVM: arm64: Parallelize stage 2 fault handling
To:     Oliver Upton <oupton@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, kvm <kvm@vger.kernel.org>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>
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

FWIW we used a similar approach in early versions of the TDP MMU, but
instead of page->private used page->lru so that more metadata could be
stored in page->private.
Ultimately that ended up being too limiting and we decided to switch
to just using the associated struct kvm_mmu_page as the list element.
I don't know if ARM has an equivalent construct though.

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
