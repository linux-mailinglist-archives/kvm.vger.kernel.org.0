Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 335864A7D1F
	for <lists+kvm@lfdr.de>; Thu,  3 Feb 2022 02:03:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348646AbiBCBBB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Feb 2022 20:01:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241392AbiBCBBB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Feb 2022 20:01:01 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 151EFC061714
        for <kvm@vger.kernel.org>; Wed,  2 Feb 2022 17:01:01 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id q11-20020a170902dacb00b0014b4c2de1f7so276716plx.14
        for <kvm@vger.kernel.org>; Wed, 02 Feb 2022 17:01:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=uIdmVf0NU6eOtNKjq3SqE586w3lsf34+46U1mWBahSQ=;
        b=Ijw8f8PQeHS9Ps4GtwjRSlR1hgVSREXdxRXWYXPmfkzPQZYI5/u/bvxpw2qyUvOD8f
         ZYquuTEQZ0x15BjuM7WFwlEBh2e34HPWnovwn2ylBbl/6uhIFyUE9ulBe5sE/ub7aEnt
         eDSS9eVJ5c94g1I5ZjHwkEfcKEHBN7aDgIwRkOOk1jrpVn5yTD4rQf+gZ/2c9OBt4KFO
         wsn27mutg/fl3kiLynLppR+UWXGtcZHLrJJv+DVdvTS8ylSlU8yLjxDohQsr6P54fFaZ
         F2zCyGfcFNhW2T2gFpZrCY2FMjjzwsUxJkyb2jJJtqG5zDegIkWplVvr0la5T95e+I2p
         fW3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=uIdmVf0NU6eOtNKjq3SqE586w3lsf34+46U1mWBahSQ=;
        b=R3lBxaMkaMCggnqH8KCUT0G7aVLZadVlRzeG0b03FUxsqsz6JEZD/JO8U/lcz6Mlvk
         CVI0eMqBs8OpG6hpzbTcYiEQWwl+ZMkTYHog/LqleTGCx2ctOh9JAsp6gmFcAklMDynk
         30Y8c2SHccpCzuG7m7zRsOefdeGhUBsxnFy5Q3XjQ+Vr/JQrMdva1GsbtJ2q3wpOtiCz
         Q3YEK3dOCT75vDjYaUClnecX0oipJXn+tUQf+p3j2UPuvYqgjI8BEDWpzC1eZpk1/WmY
         GYdfN8byIcLa7aiqZoPAf/A1COkGeg8UZxGCC6qsYrah273WVVf4SekpAfuUV+UxqoFV
         aOaw==
X-Gm-Message-State: AOAM533aNRdQ9jWgmBqoJTIqog6h9OpC/KKSYTRYo/VZF2B8yyRSoB3I
        RZSIKwF/PmyeI7/hEkSydke33qCRRi1mLQ==
X-Google-Smtp-Source: ABdhPJxOlvWLFnmRawXuIKrysWUG6lx/vFlqJC4Sp0kP+sqEc89aHS0l2rpMtzmWlixxhhKjpQJfR4UHC8zIzg==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:aa7:9ad0:: with SMTP id
 x16mr32455860pfp.55.1643850060513; Wed, 02 Feb 2022 17:01:00 -0800 (PST)
Date:   Thu,  3 Feb 2022 01:00:28 +0000
Message-Id: <20220203010051.2813563-1-dmatlack@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.0.rc2.247.g8bbb082509-goog
Subject: [PATCH 00/23] Extend Eager Page Splitting to the shadow MMU
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        leksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Peter Feiner <pfeiner@google.com>,
        Andrew Jones <drjones@redhat.com>, maciej.szmigiero@oracle.com,
        kvm@vger.kernel.org, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
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
additional cases (patches 19-22), which comes with some additional
complexity and an additional 4KiB of memory per VM to store the extra
pte_list_desc cache. However it does also avoid the need for TLB flushes
in most cases.

About half of this series, patches 1-13, is just refactoring the
existing MMU code in preparation for splitting. The bulk of the
refactoring is to make it possible to operate on the MMU outside of a
vCPU context.

Performance
-----------

Eager page splitting moves the cost of splitting huge pages off of the
vCPU thread and onto the thread invoking VM-ioctls to configure dirty
logging. This is useful because:

 - Splitting on the vCPU thread interrupts vCPUs execution and is
   disruptive to customers whereas splitting on VM ioctl threads can
   run in parallel with vCPU execution.

 - Splitting on the VM ioctl thread is more efficient because it does
   no require performing VM-exit handling and page table walks for every
   4K page.

To measure the performance impact of Eager Page Splitting I ran
dirty_log_perf_test with tdp_mmu=N, various virtual CPU counts, 1GiB per
vCPU, and backed by 1GiB HugeTLB memory.

To measure the imapct of customer performance, we can look at the time
it takes all vCPUs to dirty memory after dirty logging has been enabled.
Without Eager Page Splitting enabled, such dirtying must take faults to
split huge pages and bottleneck on the MMU lock.

             | "Iteration 1 dirty memory time"             |
             | ------------------------------------------- |
vCPU Count   | eager_page_split=N   | eager_page_split=Y   |
------------ | -------------------- | -------------------- |
2            | 0.310786549s         | 0.058731929s         |
4            | 0.419165587s         | 0.059615316s         |
8            | 1.061233860s         | 0.060945457s         |
16           | 2.852955595s         | 0.067069980s         |
32           | 7.032750509s         | 0.078623606s         |
64           | 16.501287504s        | 0.083914116s         |

Eager Page Splitting does increase the time it takes to enable dirty
logging when not using initially-all-set, since that's when KVM splits
huge pages. However, this runs in parallel with vCPU execution and does
not bottleneck on the MMU lock.

             | "Enabling dirty logging time"               |
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

             | "Iteration 1 clear dirty log time"          |
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

             | "Iteration 2 clear dirty log time"          |
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
less since ept=N requires taking the MMU lock to track writes to 4KiB
pages (i.e. no fast_page_fault() or PML), which dominates the dirty
memory time.

             | "Iteration 1 dirty memory time"             |
             | ------------------------------------------- |
vCPU Count   | eager_page_split=N   | eager_page_split=Y   |
------------ | -------------------- | -------------------- |
2            | 0.373022770s         | 0.348926043s         |
4            | 0.563697483s         | 0.453022037s         |
8            | 1.588492808s         | 1.524962010s         |
16           | 3.988934732s         | 3.369129917s         |
32           | 9.470333115s         | 8.292953856s         |
64           | 20.086419186s        | 18.531840021s        |

Testing
-------

- Ran all kvm-unit-tests and KVM selftests with all combinations of
  ept=[NY] and tdp_mmu=[NY].
- Tested VM live migration [*] with ept=N and ept=Y and observed pages
  being split via tracepoint and the pages_* stats.

[*] The live migration setup consisted of an 8 vCPU 8 GiB VM running
    on an Intel Cascade Lake host and backed by 1GiB HugeTLBFS memory.
    The VM was running Debian 10 and a workload that consisted of 16
    independent processes that each dirty memory. The tests were run
    with ept=N to exercise the interaction of Eager Page Splitting and
    shadow paging.

David Matlack (23):
  KVM: x86/mmu: Optimize MMU page cache lookup for all direct SPs
  KVM: x86/mmu: Derive shadow MMU page role from parent
  KVM: x86/mmu: Decompose kvm_mmu_get_page() into separate functions
  KVM: x86/mmu: Rename shadow MMU functions that deal with shadow pages
  KVM: x86/mmu: Pass memslot to kvm_mmu_create_sp()
  KVM: x86/mmu: Separate shadow MMU sp allocation from initialization
  KVM: x86/mmu: Move huge page split sp allocation code to mmu.c
  KVM: x86/mmu: Use common code to free kvm_mmu_page structs
  KVM: x86/mmu: Use common code to allocate kvm_mmu_page structs from
    vCPU caches
  KVM: x86/mmu: Pass const memslot to rmap_add()
  KVM: x86/mmu: Pass const memslot to kvm_mmu_init_sp() and descendants
  KVM: x86/mmu: Decouple rmap_add() and link_shadow_page() from kvm_vcpu
  KVM: x86/mmu: Update page stats in __rmap_add()
  KVM: x86/mmu: Cache the access bits of shadowed translations
  KVM: x86/mmu: Pass access information to make_huge_page_split_spte()
  KVM: x86/mmu: Zap collapsible SPTEs at all levels in the shadow MMU
  KVM: x86/mmu: Pass bool flush parameter to drop_large_spte()
  KVM: x86/mmu: Extend Eager Page Splitting to the shadow MMU
  KVM: Allow for different capacities in kvm_mmu_memory_cache structs
  KVM: Allow GFP flags to be passed when topping up MMU caches
  KVM: x86/mmu: Fully split huge pages that require extra pte_list_desc
    structs
  KVM: x86/mmu: Split huge pages aliased by multiple SPTEs
  KVM: selftests: Map x86_64 guest virtual memory with huge pages

 .../admin-guide/kernel-parameters.txt         |   3 -
 arch/arm64/include/asm/kvm_host.h             |   2 +-
 arch/arm64/kvm/mmu.c                          |  12 +-
 arch/mips/include/asm/kvm_host.h              |   2 +-
 arch/x86/include/asm/kvm_host.h               |  19 +-
 arch/x86/include/asm/kvm_page_track.h         |   2 +-
 arch/x86/kvm/mmu/mmu.c                        | 744 +++++++++++++++---
 arch/x86/kvm/mmu/mmu_internal.h               |  22 +-
 arch/x86/kvm/mmu/page_track.c                 |   4 +-
 arch/x86/kvm/mmu/paging_tmpl.h                |  25 +-
 arch/x86/kvm/mmu/spte.c                       |  10 +-
 arch/x86/kvm/mmu/spte.h                       |   3 +-
 arch/x86/kvm/mmu/tdp_mmu.c                    |  37 +-
 arch/x86/kvm/mmu/tdp_mmu.h                    |   2 +-
 include/linux/kvm_host.h                      |   1 +
 include/linux/kvm_types.h                     |  24 +-
 .../selftests/kvm/include/x86_64/processor.h  |   6 +
 tools/testing/selftests/kvm/lib/kvm_util.c    |   4 +-
 .../selftests/kvm/lib/x86_64/processor.c      |  31 +
 virt/kvm/kvm_main.c                           |  17 +-
 20 files changed, 765 insertions(+), 205 deletions(-)


base-commit: f02ccc0f669341de1a831dfa7ca843ebbdbc8bd7
-- 
2.35.0.rc2.247.g8bbb082509-goog

