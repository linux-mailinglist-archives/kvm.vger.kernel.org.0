Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 325444D5681
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 01:25:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345135AbiCKA0g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Mar 2022 19:26:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241073AbiCKA0e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Mar 2022 19:26:34 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E618F1A1C69
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 16:25:31 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id e7-20020a170902ef4700b00151de30039bso3547124plx.17
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 16:25:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=68gIue062XFpeNPWC+2GMGTpU9jB2fRiIaDhJyxenHk=;
        b=VNpyKBBd/v0UuvYgY/ZloH9oZ5k+QD5tcKd6YiYVquRAOM6SViBWGVvtGVuktxf9yD
         CuzF60g53qOcH8NszijmP4V2D2qCibXZBFTKOK33EBrUF9SgEGsPwMQcIvmlKUDJGYo7
         iX1iekrhh94bn2ulyUflf0obMLH9Su5OVjWLEEU63I8NE4+GYoc19qqvgatfrrpkfAso
         gids+kT5gumjiGmHji7RVzYUOnQTwZn0TwAPYo2ewfje4MIWZDAawLZr2sRG2uZACKgZ
         +1pkELUe9fjewuMk7Tv+5E5mB8lTNVU6QJgsC6AsUo6bb2eBbzMTACejkwjqoTUZ5IFk
         ftxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=68gIue062XFpeNPWC+2GMGTpU9jB2fRiIaDhJyxenHk=;
        b=V87VMFD9gM11kH5lBPc6RIMqQgvzsuAVo1I9xkPcJ+IyGGONgOiR5aowVGMxN4VmV6
         YwfqxcksiTjYsG9jM82PkbIM1ju3bzU/9qThz/CvUjPwfVPExX5DuNE4PS4BuRURT5ke
         Be8P5agc8wiXduMjTyuF0psr3gn7oEl3WqIq98vasQSm1WQZZQgCd6CzJ2i0SRov586l
         QZYPsl+F8sMnsce8Lb8Ahug+VphqnH5dJHJuAzeXIokNSCXssrE2x9OgIYeSMDim0Pmf
         rhyp/USU4Sc+BAj4q8CstbUeRXm0mWXTE4NgaGmpMTCyMdfTeFODHdhGfJaWrax2ZNS+
         f/Fg==
X-Gm-Message-State: AOAM533Hi9Pi2Z6I4qf7zNjxKRhwNEZunpAmPX/5KP6lE/KrIJfZrCTr
        51+OUvlp4hm1B/CspcXwodF3mgJg5WMqpw==
X-Google-Smtp-Source: ABdhPJxCSSsqSvR9E019LXHT4m59+2+TSlLclZ+WdnUH9Ghz6ysOEsXkR+QRVOEjrjxM6Te9nIBHRjCsO4pPHg==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a05:6a00:887:b0:4f2:6d3f:5b53 with SMTP
 id q7-20020a056a00088700b004f26d3f5b53mr7613490pfj.21.1646958331377; Thu, 10
 Mar 2022 16:25:31 -0800 (PST)
Date:   Fri, 11 Mar 2022 00:25:02 +0000
Message-Id: <20220311002528.2230172-1-dmatlack@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH v2 00/26] Extend Eager Page Splitting to the shadow MMU
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Sean Christopherson <seanjc@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Ben Gardon <bgardon@google.com>, Peter Xu <peterx@redhat.com>,
        maciej.szmigiero@oracle.com,
        "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)" 
        <kvmarm@lists.cs.columbia.edu>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <linux-mips@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>, Peter Feiner <pfeiner@google.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[ NOTE: I would like to do more testing on this series than what is
  described in the Testing section below, but I will be out-of-office all
  next week so I wanted to share what I have so far. I fully expect a v3
  of this series anyway after collecting more reviews from Sean. ]

This series extends KVM's Eager Page Splitting to also split huge pages
mapped by the shadow MMU, i.e. huge pages present in the memslot rmaps.
This will be useful for configurations that use Nested Virtualization,
disable the TDP MMU, or disable/lack TDP hardware support.

For background on Eager Page Splitting, see:
 - Proposal: https://lore.kernel.org/kvm/CALzav=dV_U4r1K9oDq4esb4mpBQDQ2ROQ5zH5wV3KpOaZrRW-A@mail.gmail.com/
 - TDP MMU support: https://lore.kernel.org/kvm/20220119230739.2234394-1-dmatlack@google.com/

Splitting huge pages mapped by the shadow MMU is more complicated than
the TDP MMU, but it is also more important for performance as the shadow
MMU handles huge page write-protection faults under the write lock.  See
the Performance section for more details.

The extra complexity of splitting huge pages mapped by the shadow MMU
comes from a few places:

(1) The shadow MMU has a limit on the number of shadow pages that are
    allowed to be allocated. So, as a policy, Eager Page Splitting
    refuses to split if there are KVM_MIN_FREE_MMU_PAGES or fewer
    pages available.

(2) Huge pages may be mapped by indirect shadow pages.

    - Indirect shadow pages have the possibilty of being unsync. As a
      policy we opt not to split such pages as their translation may no
      longer be valid.
    - Huge pages on indirect shadow pages may have access permission
      constraints from the guest (unlike the TDP MMU which is ACC_ALL
      by default).

(3) Splitting a huge page may end up re-using an existing lower level
    shadow page tables. This is unlike the TDP MMU which always allocates
    new shadow page tables when splitting.

(4) When installing the lower level SPTEs, they must be added to the
    rmap which may require allocating additional pte_list_desc structs.

In Google's internal implementation of Eager Page Splitting, we do not
handle cases (3) and (4), and intstead opts to skip splitting entirely
(case 3) or only partially splitting (case 4). This series handles the
additional cases (patches 21-25), which comes with some additional
complexity and an additional 4KiB of memory per VM to store the extra
pte_list_desc cache. However it does also avoid the need for TLB flushes
in most cases.

About half of this series, patches 1-15, is just refactoring the
existing MMU code in preparation for splitting. The bulk of the
refactoring is to make it possible to operate on the MMU outside of a
vCPU context.

Motivation
----------

During dirty logging, VMs using the shadow MMU suffer from:

(1) Write-protection faults on huge pages that take the MMU lock to
    unmap the huge page, map a 4KiB page, and update the dirty log.

(2) Non-present faults caused by (1) that take the MMU lock to map in
    the missing page.

(3) Write-protection faults on 4KiB pages that take the MMU lock to
    make the page writable and update the dirty log. [Note: These faults
    only take the MMU lock during shadow paging.]

The lock contention from (1), (2) and (3) can severely degrade
application performance to the point of failure.  Eager page splitting
eliminates (1) by moving the splitting of huge pages off the vCPU
threads onto the thread invoking VM-ioctls to configure dirty logging,
and eliminates (2) by fully splitting each huge page into its
constituent small pages. (3) is still a concern for shadow paging
workloads (e.g. nested virtualization) but is not addressed by this
series.

Splitting in the VM-ioctl thread is useful because it can run in the
background without interrupting vCPU execution. However, it does take
the MMU lock so it may introduce some extra contention if vCPUs are
hammering the MMU lock. This is offset by the fact that eager page
splitting drops the MMU lock after splitting each SPTE if there is any
contention, and the fact that eager page splitting is reducing the MMU
lock contention from (1) and (2) above. Even workloads that only write
to 5% of their memory see massive MMU lock contention reduction during
dirty logging thanks to Eager Page Splitting (see Performance data
below).

A downside of Eager Page Splitting is that it splits all huge pages,
which may include ranges of memory that are never written to by the
guest and thus could theoretically stay huge. Workloads that write to
only a fraction of their memory may see higher TLB miss costs with Eager
Page Splitting enabled. However, that is secondary to the application
failure that otherwise may occur without Eager Page Splitting.

Further work is necessary to improve the TLB miss performance for
read-heavy workoads, such as dirty logging at 2M instead of 4K.

Performance
-----------

To measure the performance impact of Eager Page Splitting I ran
dirty_log_perf_test with tdp_mmu=N, various virtual CPU counts, 1GiB per
vCPU, and backed by 1GiB HugeTLB memory. The amount of memory that was
written to versus read was controlled with the -f option.

To measure the imapct of customer performance, we can look at the time
it takes all vCPUs to dirty memory after dirty logging has been enabled.
Without Eager Page Splitting enabled, such dirtying must take faults to
split huge pages and bottleneck on the MMU lock.

             | 100% written / 0% read                      |
             | --------------------------------------------|
             | "Iteration 1 dirty memory time" (ept=Y)     |
             | ------------------------------------------- |
vCPU Count   | eager_page_split=N   | eager_page_split=Y   |
------------ | -------------------- | -------------------- |
2            | 0.310786549s         | 0.058731929s         |
4            | 0.419165587s         | 0.059615316s         |
8            | 1.061233860s         | 0.060945457s         |
16           | 2.852955595s         | 0.067069980s         |
32           | 7.032750509s         | 0.078623606s         |
64           | 16.501287504s        | 0.083914116s         |


             | 5% written / 95% read                       |
             | --------------------------------------------|
             | "Iteration 1 dirty memory time" (ept=Y)     |
             | ------------------------------------------- |
vCPU Count   | eager_page_split=N   | eager_page_split=Y   |
------------ | -------------------- | -------------------- |
2            | 0.325023846s         | 0.006049684s         |
4            | 0.398393318s         | 0.006275966s         |
8            | 1.242848347s         | 0.006861012s         |
16           | 2.724926895s         | 0.010056859s         |
32           | 7.134648637s         | 0.012153849s         |
64           | 16.804434189s        | 0.017575228s         |

Eager Page Splitting does increase the time it takes to enable dirty
logging when not using initially-all-set, since that's when KVM splits
huge pages. However, this runs in parallel with vCPU execution and drops
the MMU lock whenever there is contention.

             | 100% written / 0% read                      |
             | --------------------------------------------|
             | "Enabling dirty logging time" (ept=Y)       |
             | ------------------------------------------- |
vCPU Count   | eager_page_split=N   | eager_page_split=Y   |
------------ | -------------------- | -------------------- |
2            | 0.001581619s         |  0.025699730s        |
4            | 0.003138664s         |  0.051510208s        |
8            | 0.006247177s         |  0.102960379s        |
16           | 0.012603892s         |  0.206949435s        |
32           | 0.026428036s         |  0.435855597s        |
64           | 0.103826796s         |  1.199686530s        |

Similarly, Eager Page Splitting increases the time it takes to clear the
dirty log for when using initially-all-set. The first time userspace
clears the dirty log, KVM will split huge pages:

             | 100% written / 0% read                      |
             | --------------------------------------------|
             | "Iteration 1 clear dirty log time" (ept=Y)  |
             | ------------------------------------------- |
vCPU Count   | eager_page_split=N   | eager_page_split=Y   |
------------ | -------------------- | -------------------- |
2            | 0.001544730s         | 0.055327916s         |
4            | 0.003145920s         | 0.111887354s         |
8            | 0.006306964s         | 0.223920530s         |
16           | 0.012681628s         | 0.447849488s         |
32           | 0.026827560s         | 0.943874520s         |
64           | 0.090461490s         | 2.664388025s         |

Subsequent calls to clear the dirty log incur almost no additional cost
since KVM can very quickly determine there are no more huge pages to
split via the RMAP. This is unlike the TDP MMU which must re-traverse
the entire page table to check for huge pages.

             | 100% written / 0% read                      |
             | --------------------------------------------|
             | "Iteration 2 clear dirty log time" (ept=Y)  |
             | ------------------------------------------- |
vCPU Count   | eager_page_split=N   | eager_page_split=Y   |
------------ | -------------------- | -------------------- |
2            | 0.015613726s         | 0.015771982s         |
4            | 0.031456620s         | 0.031911594s         |
8            | 0.063341572s         | 0.063837403s         |
16           | 0.128409332s         | 0.127484064s         |
32           | 0.255635696s         | 0.268837996s         |
64           | 0.695572818s         | 0.700420727s         |

Eager Page Splitting also improves the performance for shadow paging
configurations, as measured with ept=N. Although the absolute gains are
less for write-heavy workloads since KVM's shadow paging takes the write
lock to track 4KiB writes (i.e. no fast_page_faut() or PML). However
there are still major gains for read/write and read-heavy workloads.

             | 100% written / 0% read                      |
             | --------------------------------------------|
             | "Iteration 1 dirty memory time" (ept=N)     |
             | ------------------------------------------- |
vCPU Count   | eager_page_split=N   | eager_page_split=Y   |
------------ | -------------------- | -------------------- |
2            | 0.373022770s         | 0.348926043s         |
4            | 0.563697483s         | 0.453022037s         |
8            | 1.588492808s         | 1.524962010s         |
16           | 3.988934732s         | 3.369129917s         |
32           | 9.470333115s         | 8.292953856s         |
64           | 20.086419186s        | 18.531840021s        |


             | 50% written / 50% read                      |
             | --------------------------------------------|
             | "Iteration 1 dirty memory time" (ept=N)     |
             | ------------------------------------------- |
vCPU Count   | eager_page_split=N   | eager_page_split=Y   |
------------ | -------------------- | -------------------- |
2            | 0.374301914s         | 0.174864494s         |
4            | 0.539841346s         | 0.213246828s         |
8            | 1.759793717s         | 0.526697696s         |
16           | 3.786053801s         | 1.338638169s         |
32           | 9.603927533s         | 3.869825083s         |
64           | 20.376757135s        | 9.158492731s         |


             | 5% written / 95% read                       |
             | --------------------------------------------|
             | "Iteration 1 dirty memory time"             |
             | ------------------------------------------- |
vCPU Count   | eager_page_split=N   | eager_page_split=Y   |
------------ | -------------------- | -------------------- |
2            | 0.381538968s         | 0.020396121s         |
4            | 0.511922608s         | 0.022625023s         |
8            | 1.464410632s         | 0.054727913s         |
16           | 3.783471041s         | 0.133412717s         |
32           | 9.519432076s         | 0.390443803s         |
64           | 21.052654299s        | 0.929496710s         |

Testing
-------

- Ran all kvm-unit-tests and KVM selftests with all combinations of
  ept=[NY] and tdp_mmu=[NY].
- Booted a 32-bit non-PAE kernel with shadow paging to verify the
  quadrant change in patch 3.

Version Log
-----------

v2:
 - Add performance data for workloads that mix reads and writes [Peter]
 - Collect R-b tags from Ben and Sean.
 - Fix quadrant calculation when deriving role from parent [Sean]
 - Tweak new shadow page function names [Sean]
 - Move set_page_private() to allocation functions [Ben]
 - Only zap collapsible SPTEs up to MAX_LEVEL-1 [Ben]
 - Always top-up pte_list_desc cache to reduce complexity [Ben]
 - Require mmu cache capacity field to be initialized and add WARN()
   to reduce chance of programmer error [Marc]
 - Fix up kvm_mmu_memory_cache struct initialization in arm64 [Marc]

v1: https://lore.kernel.org/kvm/20220203010051.2813563-1-dmatlack@google.com/

David Matlack (26):
  KVM: x86/mmu: Optimize MMU page cache lookup for all direct SPs
  KVM: x86/mmu: Use a bool for direct
  KVM: x86/mmu: Derive shadow MMU page role from parent
  KVM: x86/mmu: Decompose kvm_mmu_get_page() into separate functions
  KVM: x86/mmu: Rename shadow MMU functions that deal with shadow pages
  KVM: x86/mmu: Pass memslot to kvm_mmu_new_shadow_page()
  KVM: x86/mmu: Separate shadow MMU sp allocation from initialization
  KVM: x86/mmu: Link spt to sp during allocation
  KVM: x86/mmu: Move huge page split sp allocation code to mmu.c
  KVM: x86/mmu: Use common code to free kvm_mmu_page structs
  KVM: x86/mmu: Use common code to allocate kvm_mmu_page structs from
    vCPU caches
  KVM: x86/mmu: Pass const memslot to rmap_add()
  KVM: x86/mmu: Pass const memslot to init_shadow_page() and descendants
  KVM: x86/mmu: Decouple rmap_add() and link_shadow_page() from kvm_vcpu
  KVM: x86/mmu: Update page stats in __rmap_add()
  KVM: x86/mmu: Cache the access bits of shadowed translations
  KVM: x86/mmu: Pass access information to make_huge_page_split_spte()
  KVM: x86/mmu: Zap collapsible SPTEs at all levels in the shadow MMU
  KVM: x86/mmu: Refactor drop_large_spte()
  KVM: x86/mmu: Extend Eager Page Splitting to the shadow MMU
  KVM: Allow for different capacities in kvm_mmu_memory_cache structs
  KVM: Allow GFP flags to be passed when topping up MMU caches
  KVM: x86/mmu: Fully split huge pages that require extra pte_list_desc
    structs
  KVM: x86/mmu: Split huge pages aliased by multiple SPTEs
  KVM: x86/mmu: Drop NULL pte_list_desc_cache fallback
  KVM: selftests: Map x86_64 guest virtual memory with huge pages

 .../admin-guide/kernel-parameters.txt         |   3 -
 arch/arm64/include/asm/kvm_host.h             |   2 +-
 arch/arm64/kvm/arm.c                          |   1 +
 arch/arm64/kvm/mmu.c                          |  13 +-
 arch/mips/include/asm/kvm_host.h              |   2 +-
 arch/mips/kvm/mips.c                          |   2 +
 arch/riscv/include/asm/kvm_host.h             |   2 +-
 arch/riscv/kvm/vcpu.c                         |   1 +
 arch/x86/include/asm/kvm_host.h               |  19 +-
 arch/x86/include/asm/kvm_page_track.h         |   2 +-
 arch/x86/kvm/mmu/mmu.c                        | 744 +++++++++++++++---
 arch/x86/kvm/mmu/mmu_internal.h               |  22 +-
 arch/x86/kvm/mmu/page_track.c                 |   4 +-
 arch/x86/kvm/mmu/paging_tmpl.h                |  21 +-
 arch/x86/kvm/mmu/spte.c                       |  10 +-
 arch/x86/kvm/mmu/spte.h                       |   3 +-
 arch/x86/kvm/mmu/tdp_mmu.c                    |  48 +-
 arch/x86/kvm/mmu/tdp_mmu.h                    |   2 +-
 include/linux/kvm_host.h                      |   1 +
 include/linux/kvm_types.h                     |  19 +-
 .../selftests/kvm/include/x86_64/processor.h  |   6 +
 tools/testing/selftests/kvm/lib/kvm_util.c    |   4 +-
 .../selftests/kvm/lib/x86_64/processor.c      |  31 +
 virt/kvm/kvm_main.c                           |  19 +-
 24 files changed, 768 insertions(+), 213 deletions(-)


base-commit: ce41d078aaa9cf15cbbb4a42878cc6160d76525e
-- 
2.35.1.723.g4982287a31-goog

