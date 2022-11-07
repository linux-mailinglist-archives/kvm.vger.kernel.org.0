Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F0ED620180
	for <lists+kvm@lfdr.de>; Mon,  7 Nov 2022 22:57:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232277AbiKGV5d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Nov 2022 16:57:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232112AbiKGV5b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Nov 2022 16:57:31 -0500
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50C0327DE5
        for <kvm@vger.kernel.org>; Mon,  7 Nov 2022 13:57:29 -0800 (PST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1667858248;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=K8pNk8hWUq4Y0+/KZMKfTCv81iZIAJaiRKw2wKJYvsE=;
        b=N6Xlo3L3F26NzaElzf6V6LstKEForCmo6VqnF13KdaUb2R7f+OkCQPZbaqB5WxzuOamgci
        halbKIs/tFt23TR+R95UMcp5PPaCj4Rchie+kdGC1y5iyFy8+6FtR2TcwJvxeEUuvmTN8R
        +/Wb3+jbrSsXuPw76AUlmTDIBKJ3OKw=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Reiji Watanabe <reijiw@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        David Matlack <dmatlack@google.com>,
        Quentin Perret <qperret@google.com>,
        Ben Gardon <bgardon@google.com>, Gavin Shan <gshan@redhat.com>,
        Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        kvmarm@lists.linux.dev, Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v5 00/14] KVM: arm64: Parallel stage-2 fault handling
Date:   Mon,  7 Nov 2022 21:56:30 +0000
Message-Id: <20221107215644.1895162-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Presently KVM only takes a read lock for stage 2 faults if it believes
the fault can be fixed by relaxing permissions on a PTE (write unprotect
for dirty logging). Otherwise, stage 2 faults grab the write lock, which
predictably can pile up all the vCPUs in a sufficiently large VM.

Like the TDP MMU for x86, this series loosens the locking around
manipulations of the stage 2 page tables to allow parallel faults. RCU
and atomics are exploited to safely build/destroy the stage 2 page
tables in light of multiple software observers.

Patches 1-4 clean up the context associated with a page table walk / PTE
visit. This is helpful for:
 - Extending the context passed through for a visit
 - Building page table walkers that operate outside of a kvm_pgtable
   context (e.g. RCU callback)

Patches 5-7 clean up the stage-2 map walkers by calling a helper to tear
down removed tables. There is a small improvement here in that a broken
PTE is replaced more quickly, as page table teardown happens afterwards.

Patch 8 sprinkles in RCU to the page table walkers, punting the
teardown of removed tables to an RCU callback.

Patches 9-13 implement the meat of this series, extending the
'break-before-make' sequence with atomics to realize locking on PTEs.
Effectively a cmpxchg() is used to 'break' a PTE, thereby serializing
changes to a given PTE.

Finally, patch 14 flips the switch on all the new code and starts
grabbing the read side of the MMU lock for stage 2 faults.

Applies to 6.1-rc3. Tested with KVM selftests, kvm-unit-tests, and live
migrating a 24 vCPU, 96GB VM that was running a Debian install.
Confirmed all stage-2 table memory was freed by checking the
SecPageTables stat in meminfo.

Branch available at:

  https://github.com/oupton/linux kvm-arm64/parallel_mmu

benchmarked with dirty_log_perf_test, scaling from 1 to 48 vCPUs with
4GB of memory per vCPU backed by THP.

  ./dirty_log_perf_test -s anonymous_thp -m 2 -b 4G -v ${NR_VCPUS}

Time to dirty memory:

        +-------+----------+-------------------+
        | vCPUs | 6.1-rc3  | 6.1-rc3 + series  |
        +-------+----------+-------------------+
        |     1 | 0.87s    | 0.93s             |
        |     2 | 1.11s    | 1.16s             |
        |     4 | 2.39s    | 1.27s             |
        |     8 | 5.01s    | 1.39s             |
        |    16 | 8.89s    | 2.07s             |
        |    32 | 19.90s   | 4.45s             |
        |    48 | 32.10s   | 6.23s             |
        +-------+----------+-------------------+

It is also worth mentioning that the time to populate memory has
improved:

        +-------+----------+-------------------+
        | vCPUs | 6.1-rc3  | 6.1-rc3 + series  |
        +-------+----------+-------------------+
        |     1 | 0.21s    | 0.17s             |
        |     2 | 0.26s    | 0.23s             |
        |     4 | 0.39s    | 0.31s             |
        |     8 | 0.68s    | 0.39s             |
        |    16 | 1.26s    | 0.53s             |
        |    32 | 2.51s    | 1.04s             |
        |    48 | 3.94s    | 1.55s             |
        +-------+----------+-------------------+

v4 -> v5:
 - Fix an obvious leak of table memory (Ricardo)

v3 -> v4:
 - Fix some type conversion misses caught by sparse (test robot)
 - Squash RCU locking and RCU callback patches together into one (Sean)
 - Commit message nits (Sean)
 - Take a pointer to kvm_s2_mmu in stage2_try_break_pte(), in
   anticipation of eager page splitting (Ricardo)

v3: https://lore.kernel.org/kvmarm/20221027221752.1683510-1-oliver.upton@linux.dev/
v4: https://lore.kernel.org/kvmarm/20221103091140.1040433-1-oliver.upton@linux.dev/

Oliver Upton (14):
  KVM: arm64: Combine visitor arguments into a context structure
  KVM: arm64: Stash observed pte value in visitor context
  KVM: arm64: Pass mm_ops through the visitor context
  KVM: arm64: Don't pass kvm_pgtable through kvm_pgtable_walk_data
  KVM: arm64: Add a helper to tear down unlinked stage-2 subtrees
  KVM: arm64: Use an opaque type for pteps
  KVM: arm64: Tear down unlinked stage-2 subtree after break-before-make
  KVM: arm64: Protect stage-2 traversal with RCU
  KVM: arm64: Atomically update stage 2 leaf attributes in parallel
    walks
  KVM: arm64: Split init and set for table PTE
  KVM: arm64: Make block->table PTE changes parallel-aware
  KVM: arm64: Make leaf->leaf PTE changes parallel-aware
  KVM: arm64: Make table->block changes parallel-aware
  KVM: arm64: Handle stage-2 faults in parallel

 arch/arm64/include/asm/kvm_pgtable.h  |  92 +++-
 arch/arm64/kvm/hyp/nvhe/mem_protect.c |  21 +-
 arch/arm64/kvm/hyp/nvhe/setup.c       |  22 +-
 arch/arm64/kvm/hyp/pgtable.c          | 628 ++++++++++++++------------
 arch/arm64/kvm/mmu.c                  |  53 ++-
 5 files changed, 466 insertions(+), 350 deletions(-)


base-commit: 30a0b95b1335e12efef89dd78518ed3e4a71a763
-- 
2.38.1.431.g37b22c650d-goog

