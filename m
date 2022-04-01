Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 658704EF936
	for <lists+kvm@lfdr.de>; Fri,  1 Apr 2022 19:56:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236188AbiDAR57 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Apr 2022 13:57:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347535AbiDAR5v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Apr 2022 13:57:51 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F23FC4E2A
        for <kvm@vger.kernel.org>; Fri,  1 Apr 2022 10:56:01 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id oo16-20020a17090b1c9000b001c6d21e8c04so4354333pjb.4
        for <kvm@vger.kernel.org>; Fri, 01 Apr 2022 10:56:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=UWcFJllWtTHFKbwhK3a8mN7B6aJSWbBdywDICw/6Dnc=;
        b=f1v/sid4RJKNiM8FkROZ7u5eC3CcDwBywqgbSZAfg1YEPptW2TGKeAt0Ufp9flQn88
         AMWTHqCfih0145lHgu9DrfSD30+6UrPY1N329Q69Cc78oSDhQuZ4hy2kkeFyhLKb0EIs
         GbpSGFCG6FVysbU5s/WQuNGVg32O2LtCCQRCN6ft4C8QGz5egAMqqFk6DLwHX6/OMTGy
         SzSbGUo+oTFGuv9UliF/dly98DH3N25mh4dgF0wcrNhoITMQECUZqPnNBdqQrSRgRHNS
         eHbPPi1NyjHZk8uuV1aDHjqZtGasRwJhRlkvVbcrZZHsz/NpuGFTz6Ii6tE3dIculYLn
         kCLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=UWcFJllWtTHFKbwhK3a8mN7B6aJSWbBdywDICw/6Dnc=;
        b=MbpZtIE/ynVTuNOzCq+SyXW0qE/TdNinFOghSzv25bp66ozZE7EdyEEwFIRsL1x4MH
         R6fQ2ZMg1Gd5mXgUiibvE0M9eVIVb9IADGIwwUAxk5LQFIBW4p9aIED2Vzrj4oar6QVL
         Su3r+QPHcgoybrby+6G2ghw5xoVgLlKZTJVVrINirOXaFke8OYyh/DdGhOCI3IshV80t
         4HC9NlL4eqDpkNkazEQ/Ll637hwjg+R2jUYEAeO2cOR/CZnWDT4HFsJT0CsQGMHNPz4x
         2ZhjLj5/knfX4ynqwiPJuuFWhGkr08c63rsTxCbVuRVKmAmuAv+IHa9NFjzXJuZLM1Em
         HKww==
X-Gm-Message-State: AOAM533xHjKJLfWH2C2LeHYdyHfmwW49JmNHq3aN1RoXGqeQUznHTlCJ
        rXZxFZUxUtH2m7mjxRI8M+1xCn6Jl/OMvA==
X-Google-Smtp-Source: ABdhPJx53MZz8ztQEZW7VLY2/b1BHs00fcWBLAI+G+3Sy82e8LJdHnS45o4RIzX52MXpN+UUgSe+DFEjSDShiA==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:902:e40a:b0:155:d894:79a3 with SMTP
 id m10-20020a170902e40a00b00155d89479a3mr11752354ple.73.1648835760643; Fri,
 01 Apr 2022 10:56:00 -0700 (PDT)
Date:   Fri,  1 Apr 2022 17:55:31 +0000
Message-Id: <20220401175554.1931568-1-dmatlack@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH v3 00/23] KVM: Extend Eager Page Splitting to the shadow MMU
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
additional cases, which requires an additional 4KiB of memory per VM to
store the extra pte_list_desc cache. However it does also avoids the need
for TLB flushes in most cases and allows KVM to split more pages mapped
by shadow paging.

The bulk of this series is just refactoring the existing MMU code in
preparation for splitting, specifically to make it possible to operate
on the MMU outside of a vCPU context.

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

             | Config: ept=Y, tdp_mmu=N, 100% writes                   |
             | Iteration 1 dirty memory time                           |
             | ------------------------------------------------------- |
vCPU Count   | eager_page_split=N         | eager_page_split=Y         |
------------ | -------------------------- | -------------------------- |
2            | 0.326340139s               | 0.058645119s               |
4            | 0.425658733s               | 0.059211364s               |
8            | 1.392495283s               | 0.059992269s               |
16           | 2.891475203s               | 0.074386427s               |
32           | 7.077453255s               | 0.074484273s               |
64           | 17.907075277s              | 0.080433025s               |

             | Config: ept=Y, tdp_mmu=N, 5% writes                     |
             | Iteration 1 dirty memory time                           |
             | ------------------------------------------------------- |
vCPU Count   | eager_page_split=N         | eager_page_split=Y         |
------------ | -------------------------- | -------------------------- |
2            | 0.333304003s               | 0.005811521s               |
4            | 0.418382740s               | 0.006195093s               |
8            | 1.127732621s               | 0.007388453s               |
16           | 3.003522635s               | 0.007854799s               |
32           | 7.341293635s               | 0.012048705s               |
64           | 16.555752029s              | 0.016820654s               |

Eager Page Splitting does increase the time it takes to enable dirty
logging when not using initially-all-set, since that's when KVM splits
huge pages. However, this runs in parallel with vCPU execution and drops
the MMU lock whenever there is contention.

             | Config: ept=Y, tdp_mmu=N, 100% writes                   |
             | Enabling dirty logging time                             |
             | ------------------------------------------------------- |
vCPU Count   | eager_page_split=N         | eager_page_split=Y         |
------------ | -------------------------- | -------------------------- |
2            | 0.001618723s               | 0.026362044s               |
4            | 0.003214434s               | 0.052079721s               |
8            | 0.006392632s               | 0.106090423s               |
16           | 0.012733697s               | 0.212877154s               |
32           | 0.060493391s               | 0.438669189s               |
64           | 0.104983842s               | 1.199435360s               |

Similarly, Eager Page Splitting increases the time it takes to clear the
dirty log for when using initially-all-set. The first time userspace
clears the dirty log, KVM will split huge pages:

             | Config: ept=Y, tdp_mmu=N, 100% writes initially-all-set |
             | Iteration 1 clear dirty log time                        |
             | ------------------------------------------------------- |
vCPU Count   | eager_page_split=N         | eager_page_split=Y         |
------------ | -------------------------- | -------------------------- |
2            | 0.001599286s               | 0.027095008s               |
4            | 0.003180496s               | 0.053376070s               |
8            | 0.006417064s               | 0.106120759s               |
16           | 0.012826026s               | 0.215146223s               |
32           | 0.027089937s               | 0.444193363s               |
64           | 0.090911208s               | 1.200149758s               |

Subsequent calls to clear the dirty log incur almost no additional cost
since KVM can very quickly determine there are no more huge pages to
split via the RMAP. This is unlike the TDP MMU which must re-traverse
the entire page table to check for huge pages.

             | Config: ept=Y, tdp_mmu=N, 100% writes initially-all-set |
             | Iteration 2 clear dirty log time                        |
             | ------------------------------------------------------- |
vCPU Count   | eager_page_split=N         | eager_page_split=Y         |
------------ | -------------------------- | -------------------------- |
2            | 0.016009056s               | 0.016397093s               |
4            | 0.031897037s               | 0.032602744s               |
8            | 0.063964980s               | 0.064671106s               |
16           | 0.128522311s               | 0.131025221s               |
32           | 0.259647643s               | 0.273217378s               |
64           | 0.647532182s               | 0.705208495s               |


Eager Page Splitting also improves the performance for shadow paging
configurations, as measured with ept=N. Although the absolute gains are
less for write-heavy workloads since KVM's shadow paging takes the write
lock to track 4KiB writes (i.e. no fast_page_faut() or PML). However
there are still major gains for read/write and read-heavy workloads.

             | Config: ept=N, tdp_mmu=Y, 100% writes                   |
             | Iteration 1 dirty memory time                           |
             | ------------------------------------------------------- |
vCPU Count   | eager_page_split=N         | eager_page_split=Y         |
------------ | -------------------------- | -------------------------- |
2            | 0.369208141s               | 0.346649742s               |
4            | 0.586295755s               | 0.486400573s               |
8            | 1.605597377s               | 1.433775448s               |
16           | 3.499827702s               | 3.424215648s               |
32           | 9.219003076s               | 8.142864934s               |
64           | 20.876099825s              | 19.342073745s              |

             | Config: ept=N, tdp_mmu=Y, 50% writes                    |
             | Iteration 1 dirty memory time                           |
             | ------------------------------------------------------- |
vCPU Count   | eager_page_split=N         | eager_page_split=Y         |
------------ | -------------------------- | -------------------------- |
2            | 0.381155928s               | 0.179281063s               |
4            | 0.530227136s               | 0.262919652s               |
8            | 1.771578193s               | 0.732303441s               |
16           | 3.744348496s               | 1.633369935s               |
32           | 9.558809131s               | 4.343945991s               |
64           | 20.257131790s              | 9.609166533s               |

             | Config: ept=N, tdp_mmu=Y, 5% writes                     |
             | Iteration 1 dirty memory time                           |
             | ------------------------------------------------------- |
vCPU Count   | eager_page_split=N         | eager_page_split=Y         |
------------ | -------------------------- | -------------------------- |
2            | 0.385243149s               | 0.020628192s               |
4            | 0.506447280s               | 0.024045445s               |
8            | 1.635995700s               | 0.064108556s               |
16           | 3.752015939s               | 0.131484155s               |
32           | 9.493783332s               | 0.422104253s               |
64           | 21.250099240s              | 0.984948363s               |

Testing
-------

- Ran all kvm-unit-tests and KVM selftests with all combinations of
  ept=[NY] and tdp_mmu=[NY].
- Booted a 32-bit non-PAE kernel with shadow paging to verify the
  quadrant change in patch 3.
- Tested VM live migration [*] with ept=N and ept=Y and observed pages
  being split via tracepoint and the pages_* stats.

[*] The live migration setup consisted of an 8 vCPU 8 GiB VM running
    on an Intel Cascade Lake host and backed by 1GiB HugeTLBFS memory.
    The VM was running Debian 10 and a workload that consisted of 16
    independent processes that each dirty memory. The tests were run
    with ept=N to exercise the interaction of Eager Page Splitting and
    shadow paging.

Version Log
-----------

v3:
 - Add R-b tags from Peter.
 - Explain direct SPs in indirect MMUs in commit message [Peter]
 - Change BUG_ON() to WARN_ON_ONCE() in quadrant calculation [me]
 - Eliminate unnecessary gotos [Peter]
 - Drop mmu_alloc_pte_list_desc() [Peter]
 - Also update access cache in mmu_set_spte() if was_rmapped [Peter]
 - Fix number of gfn bits in shadowed_translation cache [Peter]
 - Pass sp to make_huge_page_split_spte() to derive level and exec [me]
 - Eliminate flush var in kvm_rmap_zap_collapsible_sptes() [Peter]
 - Drop NULL pte_list_desc cache fallback [Peter]
 - Fix get_access to return sp->role.access. [me]
 - Re-use split cache across calls to CLEAR_DIRTY_LOG for better perf [me]
 - Top-up the split cache outside of the MMU lock when possible [me]
 - Refactor prepare_to_split_huge_page() into try_split_huge_page() [me]
 - Collapse PATCH 20, 23, and 24 avoid intermediate complexity [Peter]
 - Update the RISC-V function stage2_ioremap() [Anup]

v2: https://lore.kernel.org/kvm/20220311002528.2230172-1-dmatlack@google.com/
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


David Matlack (23):
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
  KVM: x86/mmu: Use common code to allocate shadow pages from vCPU
    caches
  KVM: x86/mmu: Pass const memslot to rmap_add()
  KVM: x86/mmu: Pass const memslot to init_shadow_page() and descendants
  KVM: x86/mmu: Decouple rmap_add() and link_shadow_page() from kvm_vcpu
  KVM: x86/mmu: Update page stats in __rmap_add()
  KVM: x86/mmu: Cache the access bits of shadowed translations
  KVM: x86/mmu: Extend make_huge_page_split_spte() for the shadow MMU
  KVM: x86/mmu: Zap collapsible SPTEs at all levels in the shadow MMU
  KVM: x86/mmu: Refactor drop_large_spte()
  KVM: Allow for different capacities in kvm_mmu_memory_cache structs
  KVM: Allow GFP flags to be passed when topping up MMU caches
  KVM: x86/mmu: Support Eager Page Splitting in the shadow MMU
  KVM: selftests: Map x86_64 guest virtual memory with huge pages

 .../admin-guide/kernel-parameters.txt         |   3 -
 arch/arm64/include/asm/kvm_host.h             |   2 +-
 arch/arm64/kvm/arm.c                          |   1 +
 arch/arm64/kvm/mmu.c                          |  13 +-
 arch/mips/include/asm/kvm_host.h              |   2 +-
 arch/mips/kvm/mips.c                          |   2 +
 arch/riscv/include/asm/kvm_host.h             |   2 +-
 arch/riscv/kvm/mmu.c                          |  17 +-
 arch/riscv/kvm/vcpu.c                         |   1 +
 arch/x86/include/asm/kvm_host.h               |  20 +-
 arch/x86/include/asm/kvm_page_track.h         |   2 +-
 arch/x86/kvm/mmu/mmu.c                        | 732 ++++++++++++++----
 arch/x86/kvm/mmu/mmu_internal.h               |  27 +-
 arch/x86/kvm/mmu/page_track.c                 |   4 +-
 arch/x86/kvm/mmu/paging_tmpl.h                |  22 +-
 arch/x86/kvm/mmu/spte.c                       |  18 +-
 arch/x86/kvm/mmu/spte.h                       |   2 +-
 arch/x86/kvm/mmu/tdp_mmu.c                    |  48 +-
 arch/x86/kvm/mmu/tdp_mmu.h                    |   2 +-
 arch/x86/kvm/x86.c                            |   6 +
 include/linux/kvm_host.h                      |   1 +
 include/linux/kvm_types.h                     |  19 +-
 .../selftests/kvm/include/x86_64/processor.h  |   6 +
 tools/testing/selftests/kvm/lib/kvm_util.c    |   4 +-
 .../selftests/kvm/lib/x86_64/processor.c      |  31 +
 virt/kvm/kvm_main.c                           |  19 +-
 26 files changed, 780 insertions(+), 226 deletions(-)


base-commit: 19164ad08bf668bca4f4bfbaacaa0a47c1b737a6
-- 
2.35.1.1094.g7c7d902a7c-goog

