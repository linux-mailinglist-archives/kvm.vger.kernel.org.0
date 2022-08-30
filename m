Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A41D25A6D86
	for <lists+kvm@lfdr.de>; Tue, 30 Aug 2022 21:41:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbiH3Tlx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 15:41:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbiH3Tlw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 15:41:52 -0400
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0E8672B4A
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 12:41:50 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1661888508;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=SDzXqDxM55ayeb7XSHm97qt3/HgukfVMRYvpXvq6Bww=;
        b=KjHTgycPeLozF1oPcoStTE5XQnoDeutqMeTI88Rj2BL8ySz7NJ14eEnaNkfD9smQMKTIXH
        xh1j6f0tKODpAB6AYTuXEWV46HdbUZuvuKzQOkVvlQMgLV48QK2PeNwnRBIX0fuKKmQ0XB
        53WH0jRq95s5ezrF0qWW95D5dah15Rg=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Quentin Perret <qperret@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Gavin Shan <gshan@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 00/14] KVM: arm64: Parallel stage-2 fault handling
Date:   Tue, 30 Aug 2022 19:41:18 +0000
Message-Id: <20220830194132.962932-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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

Patches 1-2 are a cleanup to the way we collapse page tables, with the
added benefit of narrowing the window of time a range of memory is
unmapped.

Patches 3-7 are minor cleanups and refactorings to the way KVM reads
PTEs and traverses the stage 2 page tables to make it amenable to
concurrent modification.

Patches 8-9 use RCU to punt page table cleanup out of the vCPU fault
path, which should also improve fault latency a bit.

Patches 10-14 implement the meat of this series, extending the
'break-before-make' sequence with atomics to realize locking on PTEs.
Effectively a cmpxchg() is used to 'break' a PTE, thereby serializing
changes to a given PTE.

Finally, patch 15 flips the switch on all the new code and starts
grabbing the read side of the MMU lock for stage 2 faults.

Applies to 6.0-rc3. Tested with KVM selftests and benchmarked with
dirty_log_perf_test, scaling from 1 to 48 vCPUs with 4GB of memory per
vCPU backed by THP.

  ./dirty_log_perf_test -s anonymous_thp -m 2 -b 4G -v ${NR_VCPUS}

Time to dirty memory:

        +-------+---------+------------------+
        | vCPUs | 6.0-rc3 | 6.0-rc3 + series |
        +-------+---------+------------------+
        |     1 | 0.89s   | 0.92s            |
        |     2 | 1.13s   | 1.18s            |
        |     4 | 2.42s   | 1.25s            |
        |     8 | 5.03s   | 1.36s            |
        |    16 | 8.84s   | 2.09s            |
        |    32 | 19.60s  | 4.47s            |
        |    48 | 31.39s  | 6.22s            |
        +-------+---------+------------------+

It is also worth mentioning that the time to populate memory has
improved:

        +-------+---------+------------------+
        | vCPUs | 6.0-rc3 | 6.0-rc3 + series |
        +-------+---------+------------------+
        |     1 | 0.19s   | 0.18s            |
        |     2 | 0.25s   | 0.21s            |
        |     4 | 0.38s   | 0.32s            |
        |     8 | 0.64s   | 0.40s            |
        |    16 | 1.22s   | 0.54s            |
        |    32 | 2.50s   | 1.03s            |
        |    48 | 3.88s   | 1.52s            |
        +-------+---------+------------------+

RFC: https://lore.kernel.org/kvmarm/20220415215901.1737897-1-oupton@google.com/

RFC -> v1:
 - Factored out page table teardown from kvm_pgtable_stage2_map()
 - Use the RCU callback to tear down a subtree, instead of scheduling a
   callback for every individual table page.
 - Reorganized series to (hopefully) avoid intermediate breakage.
 - Dropped the use of page headers, instead stuffing KVM metadata into
   page::private directly

Oliver Upton (14):
  KVM: arm64: Add a helper to tear down unlinked stage-2 subtrees
  KVM: arm64: Tear down unlinked stage-2 subtree after break-before-make
  KVM: arm64: Directly read owner id field in stage2_pte_is_counted()
  KVM: arm64: Read the PTE once per visit
  KVM: arm64: Split init and set for table PTE
  KVM: arm64: Return next table from map callbacks
  KVM: arm64: Document behavior of pgtable visitor callback
  KVM: arm64: Protect page table traversal with RCU
  KVM: arm64: Free removed stage-2 tables in RCU callback
  KVM: arm64: Atomically update stage 2 leaf attributes in parallel
    walks
  KVM: arm64: Make changes block->table to leaf PTEs parallel-aware
  KVM: arm64: Make leaf->leaf PTE changes parallel-aware
  KVM: arm64: Make table->block changes parallel-aware
  KVM: arm64: Handle stage-2 faults in parallel

 arch/arm64/include/asm/kvm_pgtable.h  |  59 ++++-
 arch/arm64/kvm/hyp/nvhe/mem_protect.c |   7 +-
 arch/arm64/kvm/hyp/nvhe/setup.c       |   4 +-
 arch/arm64/kvm/hyp/pgtable.c          | 360 ++++++++++++++++----------
 arch/arm64/kvm/mmu.c                  |  65 +++--
 5 files changed, 325 insertions(+), 170 deletions(-)


base-commit: b90cb1053190353cc30f0fef0ef1f378ccc063c5
-- 
2.37.2.672.g94769d06f0-goog

