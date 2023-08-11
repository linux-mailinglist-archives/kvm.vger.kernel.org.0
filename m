Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3E4D7786A4
	for <lists+kvm@lfdr.de>; Fri, 11 Aug 2023 06:51:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233035AbjHKEvm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Aug 2023 00:51:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbjHKEvl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Aug 2023 00:51:41 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AC5E2D41
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 21:51:36 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-585f254c41aso20081987b3.1
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 21:51:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691729495; x=1692334295;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=VS0CCBIXj2dXRaleivgkgdvUTnqHpof7/ktb+RvS/Q0=;
        b=Xs/XQE9YeCWvYTqdPeTfLYpyNY+5vqWMaDD/9s8nntNtSpFE1SquqGb3Y6nXv4gzZF
         Y1G+5HOIs2773hFQjBIvR0YvWdVzIwPRq/p+8KxLOx7KlL80m9UdfaK7TN9LWhx0OuYC
         XZ6VA+QC6JksKnvDfv+h2priALiVJBzdzgzVbgwDXndoy0tnctTrav/sLhV1rurI0/0o
         vJ4D00GOGTWUJRwpsrG7AZCI4X4qdWawWeAJdjmvfDrea90E0hCVsc879pXRENm8zjFC
         4U4S1UcTDRbsssSnIiwfJsGpQdvlY33tr3o1TUkTIs1Cn5DRl5+09ZD4Yuz0qok6NGXf
         gXhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691729495; x=1692334295;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VS0CCBIXj2dXRaleivgkgdvUTnqHpof7/ktb+RvS/Q0=;
        b=AFpVuV269d16gd94vau1e0uEkJ4NQOOLg5clrz5tPfAhNolahmzdAOlWSFejoIXNTK
         v2S6CcZ6TfrmBjxA12CMAuBeWy1udcT40jSW2RDURYMUxUY4eODt3w0M+4k+Ucipq5tj
         hRVeGvMe5qxOG/zQ9AcypowCdwgZWxmp4I1yM9h09FZV3epWkncyBa5aukYaaJnYuswF
         xt22Bp5J8YiP3tsBo7gALG7fxEe+QCcltdgK4ZuJorR6Drs96ACESKR1oZAia/LGDULW
         HLKn7bnpS/LXjhvrNf55WiyDgHLaRTRVAwui5MnoYEzKRkP0CFgovvaVmm9mNg7jmS2l
         KmKw==
X-Gm-Message-State: AOJu0YwWux+RzibR0PflsfWkagUimXnkiuVo1IM4B+N2O1L9D4LLPseH
        GTHFG9jJVa0BlwgLizycT8tvwJdORMCA
X-Google-Smtp-Source: AGHT+IGEHowOM5zhBJ0/wXpSU0rI6H+pqRtR6llLRAu4smbc9z7ekG82myQt8G4ESW5QLBH3P62egs47L6/+
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a81:4509:0:b0:565:9e73:f937 with SMTP id
 s9-20020a814509000000b005659e73f937mr13188ywa.4.1691729495434; Thu, 10 Aug
 2023 21:51:35 -0700 (PDT)
Date:   Fri, 11 Aug 2023 04:51:13 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.640.ga95def55d0-goog
Message-ID: <20230811045127.3308641-1-rananta@google.com>
Subject: [PATCH v9 00/14] KVM: arm64: Add support for FEAT_TLBIRANGE
From:   Raghavendra Rao Ananta <rananta@google.com>
To:     Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Jing Zhang <jingzhangos@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        David Matlack <dmatlack@google.com>,
        Fuad Tabba <tabba@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In certain code paths, KVM/ARM currently invalidates the entire VM's
page-tables instead of just invalidating a necessary range. For example,
when collapsing a table PTE to a block PTE, instead of iterating over
each PTE and flushing them, KVM uses 'vmalls12e1is' TLBI operation to
flush all the entries. This is inefficient since the guest would have
to refill the TLBs again, even for the addresses that aren't covered
by the table entry. The performance impact would scale poorly if many
addresses in the VM is going through this remapping.

For architectures that implement FEAT_TLBIRANGE, KVM can replace such
inefficient paths by performing the invalidations only on the range of
addresses that are in scope. This series tries to achieve the same in
the areas of stage-2 map, unmap and write-protecting the pages.

As suggested by Oliver in the original v5 of the series [1], I'm
posting the series by including v2 of David Matlack's 'KVM: Add a
common API for range-based TLB invalidation' series [2].

Patches 1-6 includes David M.'s patches 1, 2, 6, and 7 from [2],
with minor modifications as per upstream comments.

Patch-7 refactors the core arm64's __flush_tlb_range() to be used by
other entities and patch-8 introduces a wrapper over it,
__flush_s2_tlb_range_op(), more suited for stage-2 flushes.

Patch-9,10 adds a range-based TLBI mechanism for KVM (VHE and nVHE).

Patch-11 implements the kvm_arch_flush_remote_tlbs_range() for arm64.

Patch-12 aims to flush only the memslot that undergoes a write-protect,
instead of the entire VM.

Patch-13 operates on stage2_try_break_pte() to use the range based
TLBI instructions when collapsing a table entry. The map path is the
immediate consumer of this when KVM remaps a table entry into a block.

Patch-14 modifies the stage-2 unmap path in which, if the system
supports FEAT_TLBIRANGE, the TLB invalidations are skipped during the
page-table. walk. Instead it's done in one go after the entire walk
is finished.

The series is based off of upstream v6.5-rc1.

The performance evaluation was done on a hardware that supports
FEAT_TLBIRANGE, on a VHE configuration, using a modified
kvm_page_table_test.
The modified version updates the guest code in the ADJUST_MAPPINGS case
to not only access this page but also to access up to 512 pages
backwards for every new page it iterates through. This is done to test
the effect of TLBI misses after KVM has handled a fault.

The series captures the impact in the map and unmap paths as described
above.

$ kvm_page_table_test -m 2 -v 128 -s anonymous_hugetlb_2mb -b $i

+--------+------------------------------+------------------------------+
| mem_sz |    ADJUST_MAPPINGS (s)       |      Unmap VM (s)            |
|  (GB)  | Baseline | Baseline + series | Baseline | Baseline + series |
+--------+----------|-------------------+------------------------------+
|   1    |   3.33   |   3.22            | 0.009     | 0.005            |
|   2    |   7.39   |   7.32            | 0.012     | 0.006            |
|   4    |  13.49   |  10.50            | 0.017     | 0.008            |
|   8    |  21.60   |  21.50            | 0.027     | 0.011            |
|  16    |  57.02   |  43.63            | 0.046     | 0.018            |
|  32    |  95.92   |  83.26            | 0.087     | 0.030            |
|  64    | 199.57   | 165.14            | 0.146     | 0.055            |
| 128    | 423.65   | 349.37            | 0.280     | 0.100            |
+--------+----------+-------------------+----------+-------------------+

$ kvm_page_table_test -m 2 -b 128G -s anonymous_hugetlb_2mb -v $i

+--------+------------------------------+
| vCPUs  |    ADJUST_MAPPINGS (s)       |
|        | Baseline | Baseline + series |
+--------+----------|-------------------+
|   1    | 111.44   | 114.63            |
|   2    | 102.88   |  74.64            |
|   4    | 134.83   |  98.78            |
|   8    |  98.81   |  95.01            |
|  16    | 127.41   |  99.05            |
|  32    | 105.35   |  91.75            |
|  64    | 201.13   | 163.63            |
| 128    | 423.65   | 349.37            |   
+--------+----------+-------------------+

For the ADJUST_MAPPINGS cases, which maps back the 4K table entries to
2M hugepages, the series sees an average improvement of ~15%. For
unmapping 2M hugepages, we see a gain of 2x to 3x.

$ kvm_page_table_test -m 2 -b $i

+--------+------------------------------+
| mem_sz |      Unmap VM (s)            |
|  (GB)  | Baseline | Baseline + series |
+--------+------------------------------+
|   1    |  0.54    |  0.13             |
|   2    |  1.07    |  0.25             |
|   4    |  2.10    |  0.47             |
|   8    |  4.19    |  0.92             |
|  16    |  8.35    |  1.92             |
|  32    | 16.66    |  3.61             |
|  64    | 32.36    |  7.62             |
| 128    | 64.65    | 14.39             |   
+--------+----------+-------------------+

The series sees an average gain of 4x when the guest backed by
PAGE_SIZE (4K) pages.

Other testing:
 - Booted on x86_64 and ran KVM selftests.
 - Build tested for MIPS and RISCV architectures with
   malta_kvm_defconfig and defconfig, respectively.

Cc: David Matlack <dmatlack@google.com>

v8:
https://lore.kernel.org/all/20230808231330.3855936-1-rananta@google.com/
- Thanks for the suggestions from Gavin, Sean, and Shaoqin
 - Fix the build error reported by the kernel test robot in patch-11/14.
 - Fix typo in patch-9/14. (Gavin)
 - Renamed 'start_gfn' argument to 'gfn' in patch-5/14. (Gavin)

v7:
https://lore.kernel.org/all/20230722022251.3446223-1-rananta@google.com/
Thanks, Marc and Sean for the reviews and suggestions
- Made the function declaration for kvm_arch_flush_remote_tlbs() global.
  (Marc, Sean)
- Rename 'pages' to 'nr_pages' in TLBI functions that were introduced in
  the series. (Sean)
- Define __flush_s2_tlb_range_op() as a wrapper over
  __flush_tlb_range_op(). (Marc)
- Correct/improve the comments as suggested throughout the series.
  (Marc)
- Get rid of WARN_ON() check and the 'struct stage2_unmap_data' as they
  were not necessary. (Marc)

v6:
https://lore.kernel.org/all/20230715005405.3689586-1-rananta@google.com/
Thank you, Philippe and Shaoqin for the reviews and suggestions
- Split the patch-2/11 to separate the removal of
  CONFIG_HAVE_KVM_ARCH_TLB_FLUSH_ALL and arm64 to switch to using
  kvm_arch_flush_remote_tlbs(). (Philippe)
- Align the 'pages' argument with 'kvm' in patch-3/11. (Shaoqin)
- Call  __tlb_switch_to_guest() before  __flush_tlb_range_op()
  in the VHE's implementation of __kvm_tlb_flush_vmid_range().
  (Shaoqin)

v5 (RESEND):
https://lore.kernel.org/all/20230621175002.2832640-1-rananta@google.com/
Thanks, Gavin for the suggestions:
- Adjusted the comment on patch-2 to align with the code.
- Fixed checkpatch.pl warning on patch-5.

v5:
https://lore.kernel.org/all/20230606192858.3600174-1-rananta@google.com/
Thank you, Marc and Oliver for the comments
- Introduced a helper, kvm_tlb_flush_vmid_range(), to handle
  the decision of using range-based TLBI instructions or
  invalidating the entire VMID, rather than depending on
  __kvm_tlb_flush_vmid_range() for it.
- kvm_tlb_flush_vmid_range() splits the range-based invalidations
  if the requested range exceeds MAX_TLBI_RANGE_PAGES.
- All the users in need of invalidating the TLB upon a range
  now depends on kvm_tlb_flush_vmid_range() rather than directly
  on __kvm_tlb_flush_vmid_range().
- stage2_unmap_defer_tlb_flush() introduces a WARN_ON() to
  track if there's any change in TLBIRANGE or FWB support
  during the unmap process as the features are based on
  alternative patching and the TLBI operations solely depend
  on this check.
- Corrected an incorrect hunk being present on v4's patch-3.
- Updated the patches changelog and code comments as per the
  suggestions.

v4:
https://lore.kernel.org/all/20230519005231.3027912-1-rananta@google.com/
Thanks again, Oliver for all the comments
- Updated the __kvm_tlb_flush_vmid_range() implementation for
  nVHE to adjust with the modified __tlb_switch_to_guest() that
  accepts a new 'bool nsh' arg.
- Renamed stage2_put_pte() to stage2_unmap_put_pte() and removed
  the 'skip_flush' argument.
- Defined stage2_unmap_defer_tlb_flush() to check if the PTE
  flushes can be deferred during the unmap table walk. It's
  being called from stage2_unmap_put_pte() and
  kvm_pgtable_stage2_unmap().
- Got rid of the 'struct stage2_unmap_data'.

v3:
https://lore.kernel.org/all/20230414172922.812640-1-rananta@google.com/
Thanks, Oliver for all the suggestions.
- The core flush API (__kvm_tlb_flush_vmid_range()) now checks if
  the system support FEAT_TLBIRANGE or not, thus eliminating the
  redundancy in the upper layers.
- If FEAT_TLBIRANGE is not supported, the implementation falls
  back to invalidating all the TLB entries with the VMID, instead
  of doing an iterative flush for the range.
- The kvm_arch_flush_remote_tlbs_range() doesn't return -EOPNOTSUPP
  if the system doesn't implement FEAT_TLBIRANGE. It depends on
  __kvm_tlb_flush_vmid_range() to do take care of the decisions
  and return 0 regardless of the underlying feature support.
- __kvm_tlb_flush_vmid_range() doesn't take 'level' as input to
  calculate the 'stride'. Instead, it always assumes PAGE_SIZE.
- Fast unmap path is eliminated. Instead, the existing unmap walker
  is modified to skip the TLBIs during the walk, and do it all at
  once after the walk, using the range-based instructions.

v2:
https://lore.kernel.org/all/20230206172340.2639971-1-rananta@google.com/
- Rebased the series on top of David Matlack's series for common
  TLB invalidation API[1].
- Implement kvm_arch_flush_remote_tlbs_range() for arm64, by extending
  the support introduced by [1].
- Use kvm_flush_remote_tlbs_memslot() introduced by [1] to flush
  only the current memslot after write-protect.
- Modified the __kvm_tlb_flush_range() macro to accepts 'level' as an
  argument to calculate the 'stride' instead of just using PAGE_SIZE.
- Split the patch that introduces the range-based TLBI to KVM and the
  implementation of IPA-based invalidation into its own patches.
- Dropped the patch that tries to optimize the mmu notifiers paths.
- Rename the function kvm_table_pte_flush() to
  kvm_pgtable_stage2_flush_range(), and accept the range of addresses to
  flush. [Oliver]
- Drop the 'tlb_level' argument for stage2_try_break_pte() and directly
  pass '0' as 'tlb_level' to kvm_pgtable_stage2_flush_range(). [Oliver]

v1:
https://lore.kernel.org/all/20230109215347.3119271-1-rananta@google.com/

Thank you.
Raghavendra

David Matlack (3):
  KVM: Rename kvm_arch_flush_remote_tlb() to
    kvm_arch_flush_remote_tlbs()
  KVM: Allow range-based TLB invalidation from common code
  KVM: Move kvm_arch_flush_remote_tlbs_memslot() to common code

Raghavendra Rao Ananta (11):
  KVM: Declare kvm_arch_flush_remote_tlbs() globally
  KVM: arm64: Use kvm_arch_flush_remote_tlbs()
  KVM: Remove CONFIG_HAVE_KVM_ARCH_TLB_FLUSH_ALL
  arm64: tlb: Refactor the core flush algorithm of __flush_tlb_range
  arm64: tlb: Implement __flush_s2_tlb_range_op()
  KVM: arm64: Implement  __kvm_tlb_flush_vmid_range()
  KVM: arm64: Define kvm_tlb_flush_vmid_range()
  KVM: arm64: Implement kvm_arch_flush_remote_tlbs_range()
  KVM: arm64: Flush only the memslot after write-protect
  KVM: arm64: Invalidate the table entries upon a range
  KVM: arm64: Use TLBI range-based instructions for unmap

 arch/arm64/include/asm/kvm_asm.h     |   3 +
 arch/arm64/include/asm/kvm_host.h    |   4 +
 arch/arm64/include/asm/kvm_pgtable.h |  10 +++
 arch/arm64/include/asm/tlbflush.h    | 124 +++++++++++++++------------
 arch/arm64/kvm/Kconfig               |   1 -
 arch/arm64/kvm/arm.c                 |   6 --
 arch/arm64/kvm/hyp/nvhe/hyp-main.c   |  11 +++
 arch/arm64/kvm/hyp/nvhe/tlb.c        |  30 +++++++
 arch/arm64/kvm/hyp/pgtable.c         |  63 ++++++++++++--
 arch/arm64/kvm/hyp/vhe/tlb.c         |  28 ++++++
 arch/arm64/kvm/mmu.c                 |  16 +++-
 arch/mips/include/asm/kvm_host.h     |   3 +-
 arch/mips/kvm/mips.c                 |  12 +--
 arch/riscv/kvm/mmu.c                 |   6 --
 arch/x86/include/asm/kvm_host.h      |   6 +-
 arch/x86/kvm/mmu/mmu.c               |  26 ++----
 arch/x86/kvm/mmu/mmu_internal.h      |   3 -
 arch/x86/kvm/x86.c                   |   2 +-
 include/linux/kvm_host.h             |  24 ++++--
 virt/kvm/Kconfig                     |   3 -
 virt/kvm/kvm_main.c                  |  35 ++++++--
 21 files changed, 286 insertions(+), 130 deletions(-)

-- 
2.41.0.640.ga95def55d0-goog

