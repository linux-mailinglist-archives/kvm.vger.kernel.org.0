Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D316C47382C
	for <lists+kvm@lfdr.de>; Mon, 13 Dec 2021 23:59:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243939AbhLMW7X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Dec 2021 17:59:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238473AbhLMW7W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Dec 2021 17:59:22 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D9CBC061574
        for <kvm@vger.kernel.org>; Mon, 13 Dec 2021 14:59:22 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id e7-20020aa798c7000000b004a254db7946so10890793pfm.17
        for <kvm@vger.kernel.org>; Mon, 13 Dec 2021 14:59:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=I4bZl1HG8m2nKgH7v1kXds58CGgPR7upA4eBXL1ZP60=;
        b=pvvEazWDeyexHJBh0DbbpFxaJq3j5AXTWsr8mbv1f22KppCxqkSdMqOHndEuPN4eec
         3ksNol4vslPiO+qpzssTstBCCUg50DXDrwF5MTttEbITlKCanznhMDSduALaBMlI6rUb
         4SL6bCtZxdpqVWe/CbcQ/U69hgxgwM+I6oTdDCw4A3dPE7tMg8BSOK+8yZq20JiNDl09
         2kVtHoDBSappUMS+RFc6MQ2E5RGVVovKMsfOdAWCQcNzi359uZJxa6+o6K6UJ2V9FJxm
         NAyYpWzOgGNyHPIkvY6Ruo+qBmR/SCnI0lzBQYlVALcELH8kZNtTq0E8ulTWD6ohGmeP
         HoWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=I4bZl1HG8m2nKgH7v1kXds58CGgPR7upA4eBXL1ZP60=;
        b=reJgtXPuItCrgWFM8DjAHQU9j8KHTHylzud0W4JQ34HPvpAo0olau0M5mt27W5MYQ1
         Lvuy2kihl0JWVR8euU8LYAyHS68P6SGAd+mhgVtHQLCts8XBHbko2ngIJC4Dj4Yzkie8
         lamTuyHCJHhS40pz4EicfFx/hU7FJA1CZKVaP7MXuiw3o9UfLHUktOoUe+I2ulZ/oV3M
         eTn2rvQqqfMplLMEPH5laCass+gmBU4tCS3l8Srp0R3vR+wXci1NaNHwLNQLFsBRw96v
         GU8HYmw13+CposLveKelgCWqW9R9nxtxprDKzist31Pqfx5mSLiodKI2d7FGmifagnrr
         derw==
X-Gm-Message-State: AOAM530q/hY8FTx1zSVD4p+pxj+h3igJPqWFM613WqwdFWh8q3LlCubv
        Ys/HeIMeWD6SIGlfV3XlK0gU9QdEjGBLXg==
X-Google-Smtp-Source: ABdhPJyZO3XYVD/a7Ih4Mp9602xeClqhRvvORbkHIqTcq8kaNztAS6ZZexVCegOCJzYPOs5+AbaKbSgIoki20A==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:903:24d:b0:143:beb5:b6b1 with SMTP id
 j13-20020a170903024d00b00143beb5b6b1mr1887033plh.54.1639436361495; Mon, 13
 Dec 2021 14:59:21 -0800 (PST)
Date:   Mon, 13 Dec 2021 22:59:05 +0000
Message-Id: <20211213225918.672507-1-dmatlack@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.1.173.g76aa8bc2d0-goog
Subject: [PATCH v1 00/13] KVM: x86/mmu: Eager Page Splitting for the TDP MMU
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

This is a follow-up to the RFC implementation [1] that incorporates
review feedback and bug fixes discovered during testing. See the "v1"
section below for a list of all changes.

"Eager Page Splitting" is an optimization that has been in use in Google
Cloud since 2016 to reduce the performance impact of live migration on
customer workloads. It was originally designed and implemented by Peter
Feiner <pfeiner@google.com>.

For background and performance motivation for this feature, please
see "RFC: KVM: x86/mmu: Eager Page Splitting" [2].

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
disabled with the writable module parameter
eagerly_split_huge_pages_for_dirty_logging.

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

Version Log
===========

v1:

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

[1] https://lore.kernel.org/kvm/20211119235759.1304274-1-dmatlack@google.com/
[2] https://lore.kernel.org/kvm/CALzav=dV_U4r1K9oDq4esb4mpBQDQ2ROQ5zH5wV3KpOaZrRW-A@mail.gmail.com/#t

David Matlack (13):
  KVM: x86/mmu: Rename rmap_write_protect to kvm_vcpu_write_protect_gfn
  KVM: x86/mmu: Rename __rmap_write_protect to rmap_write_protect
  KVM: x86/mmu: Automatically update iter->old_spte if cmpxchg fails
  KVM: x86/mmu: Factor out logic to atomically install a new page table
  KVM: x86/mmu: Move restore_acc_track_spte to spte.c
  KVM: x86/mmu: Refactor tdp_mmu iterators to take kvm_mmu_page root
  KVM: x86/mmu: Derive page role from parent
  KVM: x86/mmu: Refactor TDP MMU child page initialization
  KVM: x86/mmu: Split huge pages when dirty logging is enabled
  KVM: Push MMU locking down into
    kvm_arch_mmu_enable_log_dirty_pt_masked
  KVM: x86/mmu: Split huge pages during CLEAR_DIRTY_LOG
  KVM: x86/mmu: Add tracepoint for splitting huge pages
  KVM: selftests: Add an option to disable MANUAL_PROTECT_ENABLE and
    INITIALLY_SET

 arch/arm64/kvm/mmu.c                          |   2 +
 arch/mips/kvm/mmu.c                           |   5 +-
 arch/riscv/kvm/mmu.c                          |   2 +
 arch/x86/include/asm/kvm_host.h               |   7 +
 arch/x86/kvm/mmu/mmu.c                        |  78 ++--
 arch/x86/kvm/mmu/mmutrace.h                   |  20 ++
 arch/x86/kvm/mmu/spte.c                       |  77 ++++
 arch/x86/kvm/mmu/spte.h                       |   2 +
 arch/x86/kvm/mmu/tdp_iter.c                   |   5 +-
 arch/x86/kvm/mmu/tdp_iter.h                   |  10 +-
 arch/x86/kvm/mmu/tdp_mmu.c                    | 340 ++++++++++++++----
 arch/x86/kvm/mmu/tdp_mmu.h                    |   5 +
 arch/x86/kvm/x86.c                            |  10 +
 arch/x86/kvm/x86.h                            |   2 +
 .../selftests/kvm/dirty_log_perf_test.c       |  10 +-
 virt/kvm/dirty_ring.c                         |   2 -
 virt/kvm/kvm_main.c                           |   4 -
 17 files changed, 465 insertions(+), 116 deletions(-)


base-commit: 1c10f4b4877ffaed602d12ff8cbbd5009e82c970
-- 
2.34.1.173.g76aa8bc2d0-goog

