Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CAC9708D0C
	for <lists+kvm@lfdr.de>; Fri, 19 May 2023 02:52:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230226AbjESAwj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 May 2023 20:52:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjESAwh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 May 2023 20:52:37 -0400
Received: from mail-io1-xd49.google.com (mail-io1-xd49.google.com [IPv6:2607:f8b0:4864:20::d49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28F91E7F
        for <kvm@vger.kernel.org>; Thu, 18 May 2023 17:52:36 -0700 (PDT)
Received: by mail-io1-xd49.google.com with SMTP id ca18e2360f4ac-763c341d627so213874639f.1
        for <kvm@vger.kernel.org>; Thu, 18 May 2023 17:52:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684457555; x=1687049555;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=2+FdYfPuDkwNgSUrgCj2CsZVjJ3kwHAhVzFF3kglZ1o=;
        b=PEjj8cln2P+hhks6cMnJHxbBTLXeRXRr+y9IaE+OkXi0itfJhGNtbHTqt15zx8uZR9
         nyHAFQwFnZgVynOjX8X7HVFUtZZ5zfFF23wKy7qPASbOcmPe+0QFQa1eD/VBYXVcxSJS
         1Bo9Q5RZ7m3OI2EF4gRbmTAa4KsByY+zVLC8wFvEyM0wqL23sTXLfE+CIKpSXbBNCqog
         ALcVdAoX1DbB7Woki1Q07X1m3tLzP1IGpN2l2I4cUTia6Mhsvk7IJxXTb90e6Oh+dg40
         TvVP+1sKfOoAg2Pr39PZx+v6ZVGYNjMsyar0SaY7DIDJkvy50GsZxsPW6qtoFQXiG0l2
         2Xxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684457555; x=1687049555;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2+FdYfPuDkwNgSUrgCj2CsZVjJ3kwHAhVzFF3kglZ1o=;
        b=HGP5nXrQDiLi9zrTNj0JDQUwsxbIK1Ga2R5FnA8ZJYO0/ArQAViclskJ9DRJTjHwQk
         /SoKKXC/wITp48bB+KWCYP4Yi+mivzOXBbitf60UVjVeFSym+Bem8zX9fan7zVz+WcSw
         KhlAeYZcSl+FsNuLD3p0cQQcFSk0v9HKPgOs9ttM6rjw2i35FJVyGG8LUr+F/FvKXEbx
         WqHFgZGV89Q/kySpHkU+Dg8ZJ0wTxMr+gTJmjuEyGCsPlUIAeqqN3c5RNhxVKQXR/KsQ
         lasqBfPEM2jz1Vqd8gwh1w5PXAF2x07cbxJ+mtfOrY/kvyuNohpMlDKzRtVoijCGsiaO
         gvBw==
X-Gm-Message-State: AC+VfDyeUvyRViYADxMlKaoY5rsJVASgQmwFPIDcMWqHRLDhlOhF1zs8
        BVWQ9ktJ19Be8M5M7pjK9b0C4srZzd8G
X-Google-Smtp-Source: ACHHUZ4iQlPh9UT9679e/JNp3ax93bepEhd9G8FWZnQQ8BHLW4d1aP6ICgwH2WrgV5gS/yStz8CtKcGHeQ6D
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a02:aa19:0:b0:40f:91fd:6f3c with SMTP id
 r25-20020a02aa19000000b0040f91fd6f3cmr2206787jam.2.1684457555520; Thu, 18 May
 2023 17:52:35 -0700 (PDT)
Date:   Fri, 19 May 2023 00:52:25 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.1.698.g37aff9b760-goog
Message-ID: <20230519005231.3027912-1-rananta@google.com>
Subject: [PATCH v4 0/6] KVM: arm64: Add support for FEAT_TLBIRANGE
From:   Raghavendra Rao Ananta <rananta@google.com>
To:     Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     Ricardo Koller <ricarkol@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jing Zhang <jingzhangos@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
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

Patch-1 refactors the core arm64's __flush_tlb_range() to be used by
other entities.

Patch-2 adds a range-based TLBI mechanism for KVM (VHE and nVHE).

Patch-3 implements the kvm_arch_flush_remote_tlbs_range() for arm64.

Patch-4 aims to flush only the memslot that undergoes a write-protect,
instead of the entire VM.

Patch-5 operates on stage2_try_break_pte() to use the range based
TLBI instructions when collapsing a table entry. The map path is the
immediate consumer of this when KVM remaps a table entry into a block.

Patch-6 modifies the stage-2 unmap path in which, if the system supports
FEAT_TLBIRANGE, the TLB invalidations are skipped during the page-table.
walk. Instead it's done in one go after the entire walk is finished.

The series is based off of upstream v6.4-rc2, and applied David
Matlack's common API for TLB invalidations[1] on top.

The performance evaluation was done on a hardware that supports
FEAT_TLBIRANGE, on a VHE configuration, using a modified
kvm_page_table_test.
The modified version updates the guest code in the ADJUST_MAPPINGS case
to not only access this page but also to access up to 512 pages
backwards
for every new page it iterates through. This is done to test the effect
of TLBI misses after KVM has handled a fault.

The series captures the impact in the map and unmap paths as described
above.

$ kvm_page_table_test -m 2 -v 128 -s anonymous_hugetlb_2mb -b $i

+--------+------------------------------+------------------------------+
| mem_sz |    ADJUST_MAPPINGS (s)       |      Unmap VM (s)            |
|  (GB)  | Baseline | Baseline + series | Baseline | Baseline + series |
+--------+----------|-------------------+------------------------------+
|   1    |   3.44   |   2.97            | 0.007     | 0.005            |
|   2    |   5.56   |   5.63            | 0.010     | 0.006            |
|   4    |  11.03   |  10.44            | 0.015     | 0.008            |
|   8    |  24.54   |  19.00            | 0.024     | 0.011            |
|  16    |  40.16   |  36.83            | 0.041     | 0.018            |
|  32    |  75.76   |  73.84            | 0.074     | 0.029            |
|  64    | 151.58   | 152.62            | 0.148     | 0.050            |
| 128    | 330.42   | 306.86            | 0.280     | 0.090            |
+--------+----------+-------------------+----------+-------------------+

$ kvm_page_table_test -m 2 -b 128G -s anonymous_hugetlb_2mb -v $i

+--------+------------------------------+
| vCPUs  |    ADJUST_MAPPINGS (s)       |
|        | Baseline | Baseline + series |
+--------+----------|-------------------+
|   1    | 138.69   | 135.58            |
|   2    | 138.77   | 137.54            |
|   4    | 162.57   | 135.82            |
|   8    | 154.92   | 143.67            |
|  16    | 122.02   | 118.86            |
|  32    | 119.99   | 118.81            |
|  64    | 190.70   | 169.36            |
| 128    | 330.42   | 306.86            |   
+--------+----------+-------------------+

For the ADJUST_MAPPINGS cases, which maps back the 4K table entries to
2M hugepages, the series sees an average improvement of ~7%. For
unmapping 2M hugepages, we see at least a 3x improvement.

$ kvm_page_table_test -m 2 -b $i

+--------+------------------------------+
| mem_sz |      Unmap VM (s)            |
|  (GB)  | Baseline | Baseline + series |
+--------+------------------------------+
|   1    |  0.52    |  0.13             |
|   2    |  1.03    |  0.25             |
|   4    |  2.04    |  0.47             |
|   8    |  4.05    |  0.94             |
|  16    |  8.11    |  1.82             |
|  32    | 16.11    |  3.69             |
|  64    | 32.35    |  7.22             |
| 128    | 64.66    | 14.69             |   
+--------+----------+-------------------+

The series sees an average gain of 4x when the guest backed by
PAGE_SIZE (4K) pages.

v4:
Thanks again, Oliver for all the comments
- Updated the __kvm_tlb_flush_vmid_range() implementation for
  nVHE to adjust with the modfied __tlb_switch_to_guest() that
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
  the system support FEAT_TLBIRANGE or not, thus elimiating the
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

[1]:
https://lore.kernel.org/linux-arm-kernel/20230126184025.2294823-1-dmatlack@google.com/

Raghavendra Rao Ananta (6):
  arm64: tlb: Refactor the core flush algorithm of __flush_tlb_range
  KVM: arm64: Implement  __kvm_tlb_flush_vmid_range()
  KVM: arm64: Implement kvm_arch_flush_remote_tlbs_range()
  KVM: arm64: Flush only the memslot after write-protect
  KVM: arm64: Invalidate the table entries upon a range
  KVM: arm64: Use TLBI range-based intructions for unmap

 arch/arm64/include/asm/kvm_asm.h   |   3 +
 arch/arm64/include/asm/kvm_host.h  |   3 +
 arch/arm64/include/asm/tlbflush.h  | 108 +++++++++++++++--------------
 arch/arm64/kvm/hyp/nvhe/hyp-main.c |  11 +++
 arch/arm64/kvm/hyp/nvhe/tlb.c      |  37 ++++++++++
 arch/arm64/kvm/hyp/pgtable.c       |  44 +++++++++---
 arch/arm64/kvm/hyp/vhe/tlb.c       |  35 ++++++++++
 arch/arm64/kvm/mmu.c               |  13 +++-
 8 files changed, 192 insertions(+), 62 deletions(-)

-- 
2.40.1.698.g37aff9b760-goog

