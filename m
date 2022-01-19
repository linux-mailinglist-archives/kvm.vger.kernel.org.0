Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81DE549438F
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 00:09:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357679AbiASXJF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 18:09:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234753AbiASXHs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jan 2022 18:07:48 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FDA3C061749
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 15:07:48 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id x15-20020a17090a46cf00b001b35ee9643fso4812844pjg.6
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 15:07:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=W7frEzHG3+BOTnI8H1NG9Y/MTK93DALIOXzsQmgujR8=;
        b=GL3Ag2QYNYpyde0k5l7ZQo3rQOb0Tzvi4hDvPIfHEy6Ox3AspJz16TWn8aowtVaDe6
         DX1kW3wlsZE+7hfLLuEN7fcJWCMH/zTNcyS23bESJSLRdUommmKoZSW96id3Z8X+vO11
         a2OQUC0gT0kTdO9DztQAwaAsuDuR2y063U9nNVgEAxbeqTOIEn0sU6RdcL6a51OhjK/4
         4vchYW0a7Svnty83dZs/nJFAqqSPfAHn3Us/GJETsmMLlGMoqmsVeWKANg3W1W75jR3f
         YqVSBu89lwIW33Su26MUQLi/OJ9fDUpUSAWn2Gq0scbB1DOotSUPVbo32Ii2D36zgyls
         TQTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=W7frEzHG3+BOTnI8H1NG9Y/MTK93DALIOXzsQmgujR8=;
        b=uzD4Wp0hbyCZlz+gzbtRwnrpkfVJVtNFZ7ciDekQdEP/uiitYk92fNa0gZ+bDW4PRV
         XfdpnPdH0Ii3qHLZypqK2iDqfsZMogy8bnDSUvz0QSjKAojSGDJx7TSP6yq6nCFWtzJj
         HZ06Pccpy7bHjVS1wQzROYgNwd/fbFfYRWX2mYaIX/k1/lnqLkRMYqeGU1UGJfp7/tpk
         FVMe8bDVwNmfIoONtyDMj4jM3DVfNxt/Ry56oOxFX85gjkMEj3/EOeOcdgcIJJTA7xGq
         6+02zKg/F/d4JBmVyinG0SMB6tRDtTAsInG1K7iqoXsu7PMOwGU49ucNyPrkzm1aqTAY
         ygQg==
X-Gm-Message-State: AOAM533ZuZBHIYCarRWM1+jzxukXTbUQavfSYRQg4+pUSShI9fWQy6AK
        HBTzhjfhJbLgxbkj2JVyNC8T1bRjXQlrXg==
X-Google-Smtp-Source: ABdhPJyzys+IbwneUSIhFmYyFvnQUmBtxF2EaYtJOXOX3FYEjMQrKQGM/+UVDrIXT9+YM0kMr3yCMCQtcwZNqg==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90a:ead6:: with SMTP id
 ev22mr1708844pjb.10.1642633667568; Wed, 19 Jan 2022 15:07:47 -0800 (PST)
Date:   Wed, 19 Jan 2022 23:07:21 +0000
Message-Id: <20220119230739.2234394-1-dmatlack@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [PATCH v2 00/18] KVM: x86/mmu: Eager Page Splitting for the TDP MMU
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Junaid Shahid <junaids@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        "Nikunj A . Dadhania" <nikunj@amd.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series implements Eager Page Splitting for the TDP MMU.

"Eager Page Splitting" is an optimization that has been in use in Google
Cloud since 2016 to reduce the performance impact of live migration on
customer workloads. It was originally designed and implemented by Peter
Feiner <pfeiner@google.com>.

For background and performance motivation for this feature, please
see "RFC: KVM: x86/mmu: Eager Page Splitting" [1].

Implementation
==============

This series implements support for splitting all huge pages mapped by
the TDP MMU. Pages mapped by the shadow MMU are not split, although I
plan to add the support in a future patchset.

Eager page splitting is triggered in two ways:

- KVM_SET_USER_MEMORY_REGION ioctl: If this ioctl is invoked to enable
  dirty logging on a memslot and KVM_DIRTY_LOG_INITIALLY_SET is not
  enabled, KVM will attempt to split all huge pages in the memslot down
  to the 4K level.

- KVM_CLEAR_DIRTY_LOG ioctl: If this ioctl is invoked and
  KVM_DIRTY_LOG_INITIALLY_SET is enabled, KVM will attempt to split all
  huge pages cleared by the ioctl down to the 4K level before attempting
  to write-protect them.

Eager page splitting is enabled by default in both paths but can be
disabled via module param eager_page_split=N.

Splitting for pages mapped by the TDP MMU is done under the MMU lock in
read mode. The lock is dropped and the thread rescheduled if contention
or need_resched() is detected.

To allocate memory for the lower level page tables, we attempt to
allocate without dropping the MMU lock using GFP_NOWAIT to avoid doing
direct reclaim or invoking filesystem callbacks. If that fails we drop
the lock and perform a normal GFP_KERNEL allocation.

Performance
===========

Eager page splitting moves the cost of splitting huge pages off of the
vCPU thread and onto the thread invoking one of the aforementioned
ioctls. This is useful because:

 - Splitting on the vCPU thread interrupts vCPUs execution and is
   disruptive to customers whereas splitting on VM ioctl threads can
   run in parallel with vCPU execution.

 - Splitting on the VM ioctl thread is more efficient because it does
   no require performing VM-exit handling and page table walks for every
   4K page.

The measure the performance impact of Eager Page Splitting I ran
dirty_log_perf_test with 96 virtual CPUs, 1GiB per vCPU, and 1GiB
HugeTLB memory.

When KVM_DIRTY_LOG_INITIALLY_SET is set, we can see that the first
KVM_CLEAR_DIRTY_LOG iteration gets longer because KVM is splitting
huge pages. But the time it takes for vCPUs to dirty their memory
is significantly shorter since they do not have to take write-
protection faults.

           | Iteration 1 clear dirty log time | Iteration 2 dirty memory time
---------- | -------------------------------- | -----------------------------
Before     | 0.049572219s                     | 2.751442902s
After      | 1.667811687s                     | 0.127016504s

Eager page splitting does make subsequent KVM_CLEAR_DIRTY_LOG ioctls
about 4% slower since it always walks the page tables looking for pages
to split.  This can be avoided but will require extra memory and/or code
complexity to track when splitting can be skipped.

           | Iteration 3 clear dirty log time
---------- | --------------------------------
Before     | 1.374501209s
After      | 1.422478617s

When not using KVM_DIRTY_LOG_INITIALLY_SET, KVM performs splitting on
the entire memslot during the KVM_SET_USER_MEMORY_REGION ioctl that
enables dirty logging. We can see that as an increase in the time it
takes to enable dirty logging. This allows vCPUs to avoid taking
write-protection faults which we again see in the dirty memory time.

           | Enabling dirty logging time      | Iteration 1 dirty memory time
---------- | -------------------------------- | -----------------------------
Before     | 0.001683739s                     | 2.943733325s
After      | 1.546904175s                     | 0.145979748s

Testing
=======

- Ran all kvm-unit-tests and KVM selftests on debug and non-debug kernels.

- Ran dirty_log_perf_test with different backing sources (anonymous,
  anonymous_thp, anonymous_hugetlb_2mb, anonymous_hugetlb_1gb) with and
  without Eager Page Splitting enabled.

- Added a tracepoint locally to time the GFP_NOWAIT allocations. Across
  40 runs of dirty_log_perf_test using 1GiB HugeTLB with 96 vCPUs there
  were only 4 allocations that took longer than 20 microseconds and the
  longest was 60 microseconds. None of the GFP_NOWAIT allocations
  failed.

- I have not been able to trigger a GFP_NOWAIT allocation failure (to
  exercise the fallback path). However I did manually modify the code
  to force every allocation to fallback by removing the GFP_NOWAIT
  allocation altogether to make sure the logic works correctly.

- Live migrated a 32 vCPU 32 GiB Linux VM running a workload that
  aggressively writes to guest memory with Eager Page Splitting enabled.
  Observed pages being split via tracepoint and the pages_{4k,2m,1g}
  stats.

Version Log
===========

v2:

[Overall Changes]
 - Additional testing by live migrating a Linux VM (see above).
 - Add Sean's, Ben's, and Peter's Reviewed-by tags.
 - Use () when referring to functions in commit message and comments [Sean]
 - Add TDP MMU to shortlog where applicable [Sean]
 - Fix gramatical errors in commit messages [Sean]
 - Break 80+ char function declarations across multiple lines [Sean]

[PATCH v1 03/13] KVM: x86/mmu: Automatically update iter->old_spte if cmpxchg fails
 - Remove useless empty line [Peter]
 - Tighten up the wording in comments [Sean]
 - Move result of rcu_dereference() to a local variable to cut down line lengths [Sean]

[PATCH v1 04/13] KVM: x86/mmu: Factor out logic to atomically install a new page table
 - Add prep patch to return 0/-EBUSY instead of bool [Sean]
 - Add prep patch to rename {un,}link_page to {un,}link_sp [Sean]
 - Fold tdp_mmu_link_page() into tdp_mmu_install_sp_atomic() [Sean]

[PATCH v1 05/13] KVM: x86/mmu: Move restore_acc_track_spte to spte.c
 - Make inline [Sean]
 - Eliminate WARN_ON_ONCE [Sean]
 - Eliminate unnecessary local variable new_spte [Sean].

[PATCH v1 06/13] KVM: x86/mmu: Refactor tdp_mmu iterators to take kvm_mmu_page root
 - Eliminate unnecessary local variable root_pt [Sean]

[PATCH v1 07/13] KVM: x86/mmu: Derive page role from parent
 - Eliminate redundant role overrides [Sean]

[PATCH v1 08/13] KVM: x86/mmu: Refactor TDP MMU child page initialization
 - Rename alloc_tdp_mmu_page*() functions [Sean]

[PATCH v1 09/13] KVM: x86/mmu: Split huge pages when dirty logging is enabled
 - Drop access from make_huge_page_split_spte() [Sean]
 - Drop is_mmio_spte() check from make_huge_page_split_spte() [Sean]
 - Change WARN_ON to WARN_ON_ONCE in make_huge_page_split_spte() [Sean]
 - Improve comment for making 4K SPTEs executable [Sean]
 - Rename mark_spte_executable() to mark_spte_executable() [Sean]
 - Put return type on same line as tdp_mmu_split_huge_page_atomic() [Sean]
 - Drop child_spte local variable in tdp_mmu_split_huge_page_atomic() [Sean]
 - Make alloc_tdp_mmu_page_for_split() play nice with
   commit 3a0f64de479c ("KVM: x86/mmu: Don't advance iterator after restart due to yielding") [Sean]
 - Free unused sp after dropping RCU [Sean]
 - Rename module param to something shorter [Sean]
 - Document module param somewhere [Sean]
 - Fix rcu_read_unlock in tdp_mmu_split_huge_pages_root() [me]
 - Document TLB flush behavior [Peter]

[PATCH v1 10/13] KVM: Push MMU locking down into kvm_arch_mmu_enable_log_dirty_pt_masked
 - Drop [Peter]

[PATCH v1 11/13] KVM: x86/mmu: Split huge pages during CLEAR_DIRTY_LOG
 - Hold the lock in write-mode when splitting [Peter]
 - Document TLB flush behavior [Peter]

[PATCH v1 12/13] KVM: x86/mmu: Add tracepoint for splitting huge pages
 - Record if split succeeded or failed [Sean]

v1: https://lore.kernel.org/kvm/20211213225918.672507-1-dmatlack@google.com/

[Overall Changes]
 - Use "huge page" instead of "large page" [Sean Christopherson]

[RFC PATCH 02/15] KVM: x86/mmu: Rename __rmap_write_protect to rmap_write_protect
 - Add Ben's Reviewed-by.
 - Add Peter's Reviewed-by.

[RFC PATCH 03/15] KVM: x86/mmu: Automatically update iter->old_spte if cmpxchg fails
 - Add comment when updating old_spte [Ben Gardon]
 - Follow kernel style of else case in zap_gfn_range [Ben Gardon]
 - Don't delete old_spte update after zapping in kvm_tdp_mmu_map [me]

[RFC PATCH 04/15] KVM: x86/mmu: Factor out logic to atomically install a new page table
 - Add blurb to commit message describing intentional drop of tracepoint [Ben Gardon]
 - Consolidate "u64 spte = make_nonleaf_spte(...);" onto one line [Sean Christopherson]
 - Do not free the sp if set fails  [Sean Christopherson]

[RFC PATCH 05/15] KVM: x86/mmu: Abstract mmu caches out to a separate struct
 - Drop to adopt Sean's proposed allocation scheme.

[RFC PATCH 06/15] KVM: x86/mmu: Derive page role from parent
 - No changes.

[RFC PATCH 07/15] KVM: x86/mmu: Pass in vcpu->arch.mmu_caches instead of vcpu
 - Drop to adopt Sean's proposed allocation scheme.

[RFC PATCH 08/15] KVM: x86/mmu: Helper method to check for large and present sptes
 - Drop this commit and the helper function [Sean Christopherson]

[RFC PATCH 09/15] KVM: x86/mmu: Move restore_acc_track_spte to spte.c
 - Add Ben's Reviewed-by.

[RFC PATCH 10/15] KVM: x86/mmu: Abstract need_resched logic from tdp_mmu_iter_cond_resched
 - Drop to adopt Sean's proposed allocation scheme.

[RFC PATCH 11/15] KVM: x86/mmu: Refactor tdp_mmu iterators to take kvm_mmu_page root
 - Add Ben's Reviewed-by.

[RFC PATCH 12/15] KVM: x86/mmu: Split large pages when dirty logging is enabled
 - Add a module parameter to control Eager Page Splitting [Peter Xu]
 - Change level to large_spte_level [Ben Gardon]
 - Get rid of BUG_ONs [Ben Gardon]
 - Change += to |= and add a comment [Ben Gardon]
 - Do not flush TLBs when dropping the MMU lock. [Sean Christopherson]
 - Allocate memory directly from the kernel instead of using mmu_caches [Sean Christopherson]

[RFC PATCH 13/15] KVM: x86/mmu: Split large pages during CLEAR_DIRTY_LOG
 - Fix deadlock by refactoring MMU locking and dropping write lock before splitting. [kernel test robot]
 - Did not follow Sean's suggestion of skipping write-protection if splitting
   succeeds as it would require extra complexity since we aren't splitting
   pages in the shadow MMU yet.

[RFC PATCH 14/15] KVM: x86/mmu: Add tracepoint for splitting large pages
 - No changes.

[RFC PATCH 15/15] KVM: x86/mmu: Update page stats when splitting large pages
 - Squash into patch that first introduces page splitting.

Note: I opted not to change TDP MMU functions to return int instead of
bool per Sean's suggestion. I agree this change should be done but can
be left to a separate series.

RFC: https://lore.kernel.org/kvm/20211119235759.1304274-1-dmatlack@google.com/

[1] https://lore.kernel.org/kvm/CALzav=dV_U4r1K9oDq4esb4mpBQDQ2ROQ5zH5wV3KpOaZrRW-A@mail.gmail.com/#t

David Matlack (18):
  KVM: x86/mmu: Rename rmap_write_protect() to
    kvm_vcpu_write_protect_gfn()
  KVM: x86/mmu: Rename __rmap_write_protect() to rmap_write_protect()
  KVM: x86/mmu: Automatically update iter->old_spte if cmpxchg fails
  KVM: x86/mmu: Change tdp_mmu_{set,zap}_spte_atomic() to return
    0/-EBUSY
  KVM: x86/mmu: Rename TDP MMU functions that handle shadow pages
  KVM: x86/mmu: Rename handle_removed_tdp_mmu_page() to
    handle_removed_pt()
  KVM: x86/mmu: Consolidate logic to atomically install a new TDP MMU
    page table
  KVM: x86/mmu: Remove unnecessary warnings from
    restore_acc_track_spte()
  KVM: x86/mmu: Drop new_spte local variable from
    restore_acc_track_spte()
  KVM: x86/mmu: Move restore_acc_track_spte() to spte.h
  KVM: x86/mmu: Refactor TDP MMU iterators to take kvm_mmu_page root
  KVM: x86/mmu: Remove redundant role overrides for TDP MMU shadow pages
  KVM: x86/mmu: Derive page role for TDP MMU shadow pages from parent
  KVM: x86/mmu: Separate TDP MMU shadow page allocation and
    initialization
  KVM: x86/mmu: Split huge pages mapped by the TDP MMU when dirty
    logging is enabled
  KVM: x86/mmu: Split huge pages mapped by the TDP MMU during
    KVM_CLEAR_DIRTY_LOG
  KVM: x86/mmu: Add tracepoint for splitting huge pages
  KVM: selftests: Add an option to disable MANUAL_PROTECT_ENABLE and
    INITIALLY_SET

 .../admin-guide/kernel-parameters.txt         |  26 ++
 arch/x86/include/asm/kvm_host.h               |   7 +
 arch/x86/kvm/mmu/mmu.c                        |  79 ++--
 arch/x86/kvm/mmu/mmutrace.h                   |  23 +
 arch/x86/kvm/mmu/spte.c                       |  59 +++
 arch/x86/kvm/mmu/spte.h                       |  16 +
 arch/x86/kvm/mmu/tdp_iter.c                   |   8 +-
 arch/x86/kvm/mmu/tdp_iter.h                   |  10 +-
 arch/x86/kvm/mmu/tdp_mmu.c                    | 419 +++++++++++++-----
 arch/x86/kvm/mmu/tdp_mmu.h                    |   5 +
 arch/x86/kvm/x86.c                            |   6 +
 arch/x86/kvm/x86.h                            |   2 +
 .../selftests/kvm/dirty_log_perf_test.c       |  13 +-
 13 files changed, 520 insertions(+), 153 deletions(-)


base-commit: edb9e50dbe18394d0fc9d0494f5b6046fc912d33
-- 
2.35.0.rc0.227.g00780c9af4-goog

