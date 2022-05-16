Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5F74529517
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 01:21:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350283AbiEPXVu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 19:21:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237243AbiEPXVo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 19:21:44 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9006C2C116
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 16:21:42 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id m11-20020a170902f64b00b0015820f8038fso8663502plg.23
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 16:21:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=0YkApNghgF4TC4tIp8JnO0EsQZRvA0pJP1NXImtKD4U=;
        b=X8vcSqJ5QNIaNMmMzYnqmXchM3rqClM84FhI1GsLT8KtFRsTCiZmHkDbWjdXE1SAjp
         cH6IjaOTYXXole9wOsXv36WRjk2zWPwm1ygpWn5cLXvLgrev6sKuQ1lpV87mCod9WbJe
         EN3/y19PVPK9aVQDI+7gVXB0k3HiaJ5ahSLxixMzzpOc7r0CuYCuI6sgefnJHWVx3q+Y
         H9KghKIyr6/5idhu2NvkR/YMFTsZ4tqWFwXw1vOrk80NU0blIfGvVJHRj8XhJESxz3N0
         +Ox1h8UjfYc1gKE4o/uiDMTFwn8c8M1hjgZ+lNy8hGHhcrBP4kWQG8k4u2TS8D0AwfBa
         eAXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=0YkApNghgF4TC4tIp8JnO0EsQZRvA0pJP1NXImtKD4U=;
        b=xZHm9QdNhOVXOHHddWz6CbjcEZa7ECnwQoQbo0KqVC213/p1lM4b39gfv9TzGuJUMw
         V1NL8NgdnsakaQrv2YQ8NjtlymjYsTsloo4bJLuGpHxJv20kIZ9EbamNjUYhNMMWo2D7
         H3rDM9w3HiRpualQF6ObT0FZBTANewCRH8OaLBMD9n3sZo6eoeud/TD6AyMJId+8FdEV
         6XxXq9BwQ8Chcfv+PKtXKPccr6gaIqonwFLbJP0QRLnahSkphcn8l6JL5nGGUg+/Qebi
         kqWfzFHJzyYJVxulF93fn7dbTs4UdsI3D2xWxMzRERRJWR2l7IxsRnSdUM8fR6zHGHCd
         rKNg==
X-Gm-Message-State: AOAM532g9dIAOBxFLgm4ZgeXfFS9D8ijmeW06ab9OObt11Jgm3BOzVbk
        D6/QMbCkRzH+NR5qjDsUJGgDhn0h6O/GhQ==
X-Google-Smtp-Source: ABdhPJzVsPkihjdJKyDB4IlWilw/aIIVKfVJV6U2SckzeNt6+CAN/61F3LEIkq/JhYnjb3GbY1/ZuGRCIfxZFw==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a05:6a00:10cc:b0:4fe:3f1c:2d1 with SMTP
 id d12-20020a056a0010cc00b004fe3f1c02d1mr19559137pfu.0.1652743302062; Mon, 16
 May 2022 16:21:42 -0700 (PDT)
Date:   Mon, 16 May 2022 23:21:16 +0000
Message-Id: <20220516232138.1783324-1-dmatlack@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
Subject: [PATCH v6 00/22] KVM: Extend Eager Page Splitting to the shadow MMU
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
        Lai Jiangshan <jiangshanlai@gmail.com>,
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

[ This is a small incremental revision on top of v5. I'm sending this now
  rather than waiting longer, as I would typically do, since the 5.19 merge
  window is fast approaching. ]

This series extends KVM's Eager Page Splitting to also split huge pages
mapped by the shadow MMU, specifically **nested MMUs**.

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

(2) Huge pages may be mapped by indirect shadow pages which may have access
    permission constraints from the guest (unlike the TDP MMU which is
    ACC_ALL by default).

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
dirty_log_perf_test with support for a new flag, -n, that causes each vCPU
thread to run in L2 instead of L1. This support will be sent out in a
separate series.

To measure the imapct of customer performance, we can look at the time
it takes all vCPUs to dirty memory after dirty logging has been enabled.
Without Eager Page Splitting enabled, such dirtying must take faults to
split huge pages and bottleneck on the MMU lock.

For write-heavy workloads, there is not as much benefit since nested MMUs
still have to take the write-lock when resolving 4K write-protection
faults (case (3) in the Motivation section). But ready-heavy workloads
greatly benefit.

             | Config: tdp_mmu=Y, nested, 100% writes                  |
             | Iteration 1 dirty memory time                           |
             | ------------------------------------------------------- |
vCPU Count   | eager_page_split=N         | eager_page_split=Y         |
------------ | -------------------------- | -------------------------- |
2            | 0.367445635s               | 0.359880160s               |
4            | 0.503976497s               | 0.418760595s               |
8            | 1.328792652s               | 1.442455382s               |
16           | 4.609457301s               | 3.649754574s               |
32           | 8.751328485s               | 7.659014140s               |
64           | 20.438482174s              | 17.890019577s              |

             | Config: tdp_mmu=Y, nested, 50% writes                   |
             | Iteration 1 dirty memory time                           |
             | ------------------------------------------------------- |
vCPU Count   | eager_page_split=N         | eager_page_split=Y         |
------------ | -------------------------- | -------------------------- |
2            | 0.374082549s               | 0.189881327s               |
4            | 0.498175012s               | 0.216221200s               |
8            | 1.848155856s               | 0.525316794s               |
16           | 4.387725630s               | 1.844867390s               |
32           | 9.153260046s               | 4.061645844s               |
64           | 20.077600588s              | 8.825413269s               |

             | Config: tdp_mmu=Y, nested, 5% writes                    |
             | Iteration 1 dirty memory time                           |
             | ------------------------------------------------------- |
vCPU Count   | eager_page_split=N         | eager_page_split=Y         |
------------ | -------------------------- | -------------------------- |
2            | 0.386395635s               | 0.023315599s               |
4            | 0.495352933s               | 0.024971794s               |
8            | 1.568730321s               | 0.052010563s               |
16           | 4.258323166s               | 0.174402708s               |
32           | 9.260176347s               | 0.377929203s               |
64           | 19.861473882s              | 0.905998574s               |

Eager Page Splitting does increase the time it takes to enable dirty
logging when not using initially-all-set, since that's when KVM splits
huge pages. However, this runs in parallel with vCPU execution and drops
the MMU lock whenever there is contention.

             | Config: tdp_mmu=Y, nested, 100% writes                  |
             | Enabling dirty logging time                             |
             | ------------------------------------------------------- |
vCPU Count   | eager_page_split=N         | eager_page_split=Y         |
------------ | -------------------------- | -------------------------- |
2            | 0.001330088s               | 0.018624938s               |
4            | 0.002763111s               | 0.037247815s               |
8            | 0.005220762s               | 0.074637543s               |
16           | 0.010381925s               | 0.149096917s               |
32           | 0.022109466s               | 0.307983859s               |
64           | 0.085547182s               | 0.854228170s               |

Similarly, Eager Page Splitting increases the time it takes to clear the
dirty log for when using initially-all-set. The first time userspace
clears the dirty log, KVM will split huge pages:

             | Config: tdp_mmu=Y, nested, 100% writes initially-all-set |
             | Iteration 1 clear dirty log time                        |
             | ------------------------------------------------------- |
vCPU Count   | eager_page_split=N         | eager_page_split=Y         |
------------ | -------------------------- | -------------------------- |
2            | 0.001947098s               | 0.019836052s               |
4            | 0.003817996s               | 0.039574178s               |
8            | 0.007673616s               | 0.079118964s               |
16           | 0.015733003s               | 0.158006697s               |
32           | 0.031728367s               | 0.330793049s               |
64           | 0.108699714s               | 0.891762988s               |

Subsequent calls to clear the dirty log incur almost no additional cost
since KVM can very quickly determine there are no more huge pages to
split via the RMAP. This is unlike the TDP MMU which must re-traverse
the entire page table to check for huge pages.

             | Config: tdp_mmu=Y, nested, 100% writes initially-all-set |
             | Iteration 2 clear dirty log time                        |
             | ------------------------------------------------------- |
vCPU Count   | eager_page_split=N         | eager_page_split=Y         |
------------ | -------------------------- | -------------------------- |
2            | 0.009585296s               | 0.009931437s               |
4            | 0.019188984s               | 0.019842738s               |
8            | 0.038568630s               | 0.039951832s               |
16           | 0.077188525s               | 0.079536780s               |
32           | 0.156728329s               | 0.163612725s               |
64           | 0.418679324s               | 0.337336844s               |

Testing
-------

 - Ran all kvm-unit-tests and KVM selftests.

 - Booted a 32-bit non-PAE kernel with shadow paging to verify the
   quadrant change.

 - Ran dirty_log_perf_test with support for a new flag, -n, that causes
   each vCPU thread to run in L2 instead of L1. This support will be
   sent out in a separate series.

 - Tested VM live migration with nested MMUs and huge pages. The live
   migration setup consisted of an 8 vCPU 8 GiB VM running on an Intel
   Cascade Lake host and backed by 1GiB HugeTLBFS memory.  The VM was
   running Debian 10.  Inside a VM was a 6 vCPU 4Gib nested VM also
   Debian 10 and backed by 2M HugeTLBFS. Inside the nested VM ran a
   workload that aggressively accessed memory across 6 threads.
   Tracepoints during the migration confirmes eager page splitting
   occurred, both for the direct TDP MMU mappings, and the nested MMU
   mappings.

Version Log
-----------

v6:
 - Collect R-b tag from Marc.
 - Initialize memory cache capacity during top-up [Sean]
 - Eliminate redundant role overrides in mmu_alloc_root() [Lai]

v5: https://lore.kernel.org/kvm/20220513202819.829591-1-dmatlack@google.com/
 - Rebase on top of latest kvm/queue.
 - Collected R-b tags from Sean and Lai.
 - Add another patch to stop passing non-zero quadrant [Sean]
 - Drop vcpu_or_null and __kvm_sync_page() [Sean]
 - Formatting and wording changes [Sean]
 - Pass role instead of sp when making huge split SPTEs [Sean]
 - Fix riscv compilation error [kernel test robot]
 - Document split caches protected by slots_lock [Lai]

v4: https://lore.kernel.org/kvm/20220422210546.458943-1-dmatlack@google.com/
 - Limit eager page splitting to nested MMUs [Sean]
 - Use memory caches for SP allocation [Sean]
 - Use kvm_mmu_get_page() with NULL vCPU for EPS [Sean]
 - Use u64 instead of bit field for shadow translation entry [Sean]
 - Add Sean's R-b to "Use a bool" patch.
 - Fix printf warning in "Cache access bits" patch.
 - Fix asymmentrical pr_err_ratelimit() + WARN() [Sean]
 - Drop unnecessary unsync check for huge pages [Sean]
 - Eliminate use of we in comments and change logs [Sean]
 - Allocate objects arrays dynamically [Ben]

v3: https://lore.kernel.org/kvm/20220401175554.1931568-1-dmatlack@google.com/
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

David Matlack (22):
  KVM: x86/mmu: Optimize MMU page cache lookup for all direct SPs
  KVM: x86/mmu: Use a bool for direct
  KVM: x86/mmu: Stop passing @direct to mmu_alloc_root()
  KVM: x86/mmu: Derive shadow MMU page role from parent
  KVM: x86/mmu: Always pass 0 for @quadrant when gptes are 8 bytes
  KVM: x86/mmu: Decompose kvm_mmu_get_page() into separate functions
  KVM: x86/mmu: Consolidate shadow page allocation and initialization
  KVM: x86/mmu: Rename shadow MMU functions that deal with shadow pages
  KVM: x86/mmu: Move guest PT write-protection to account_shadowed()
  KVM: x86/mmu: Pass memory caches to allocate SPs separately
  KVM: x86/mmu: Replace vcpu with kvm in kvm_mmu_alloc_shadow_page()
  KVM: x86/mmu: Pass kvm pointer separately from vcpu to
    kvm_mmu_find_shadow_page()
  KVM: x86/mmu: Allow NULL @vcpu in kvm_mmu_find_shadow_page()
  KVM: x86/mmu: Pass const memslot to rmap_add()
  KVM: x86/mmu: Decouple rmap_add() and link_shadow_page() from kvm_vcpu
  KVM: x86/mmu: Update page stats in __rmap_add()
  KVM: x86/mmu: Cache the access bits of shadowed translations
  KVM: x86/mmu: Extend make_huge_page_split_spte() for the shadow MMU
  KVM: x86/mmu: Zap collapsible SPTEs in shadow MMU at all possible
    levels
  KVM: x86/mmu: Refactor drop_large_spte()
  KVM: Allow for different capacities in kvm_mmu_memory_cache structs
  KVM: x86/mmu: Extend Eager Page Splitting to nested MMUs

 .../admin-guide/kernel-parameters.txt         |   3 +-
 arch/arm64/kvm/mmu.c                          |   2 +-
 arch/riscv/kvm/mmu.c                          |   5 +-
 arch/x86/include/asm/kvm_host.h               |  26 +-
 arch/x86/kvm/mmu/mmu.c                        | 693 ++++++++++++++----
 arch/x86/kvm/mmu/mmu_internal.h               |  17 +-
 arch/x86/kvm/mmu/paging_tmpl.h                |  17 +-
 arch/x86/kvm/mmu/spte.c                       |  16 +-
 arch/x86/kvm/mmu/spte.h                       |   2 +-
 arch/x86/kvm/mmu/tdp_mmu.c                    |   2 +-
 arch/x86/kvm/x86.c                            |   6 +
 include/linux/kvm_host.h                      |   1 +
 include/linux/kvm_types.h                     |   6 +-
 virt/kvm/kvm_main.c                           |  33 +-
 14 files changed, 658 insertions(+), 171 deletions(-)


base-commit: a3808d88461270c71d3fece5e51cc486ecdac7d0
-- 
2.36.0.550.gb090851708-goog

