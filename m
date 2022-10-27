Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1747610586
	for <lists+kvm@lfdr.de>; Fri, 28 Oct 2022 00:18:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235243AbiJ0WSW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 18:18:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235287AbiJ0WSQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 18:18:16 -0400
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11B15AF193
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 15:18:11 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1666909089;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=9n+3RxdryoMl5Xxq5ZijFC40S1Mj/3IyMGm1mZ68lXA=;
        b=YpTxtNemiM35mRdi+bTzmnJnzI3P1+mymjitmXCgHlEVVsu7a3xtLkBJE3esDp9lDvmOEy
        cu0czVnjmaC8j0xf+4wxWk/K8GWLpg5l9GQgje9h0EWAaQH0Y0tJurnpxaFf96rnwdQ+Q8
        WfReZB6MJofmj09d7zzSJwWmc8EMceg=
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
Subject: [PATCH v3 00/15] KVM: arm64: Parallel stage-2 fault handling
Date:   Thu, 27 Oct 2022 22:17:37 +0000
Message-Id: <20221027221752.1683510-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
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

Patches 5-6 clean up the stage-2 map walkers by calling a helper to tear
down removed tables. There is a small improvement here in that a broken
PTE is replaced more quickly, as page table teardown happens afterwards.

Patches 7-9 sprinkle in RCU to the page table walkers, punting the
teardown of removed tables to an RCU callback.

Patches 10-14 implement the meat of this series, extending the
'break-before-make' sequence with atomics to realize locking on PTEs.
Effectively a cmpxchg() is used to 'break' a PTE, thereby serializing
changes to a given PTE.

Finally, patch 15 flips the switch on all the new code and starts
grabbing the read side of the MMU lock for stage 2 faults.

Applies to 6.1-rc2. Tested with KVM selftests, kvm-unit-tests, and
Google's internal VMM (Vanadium). Also tested with lockdep enabled and
saw no puke for RCU.

Branch available at:

  https://github.com/oupton/linux kvm-arm64/parallel_mmu

benchmarked with dirty_log_perf_test, scaling from 1 to 48 vCPUs with
4GB of memory per vCPU backed by THP.

  ./dirty_log_perf_test -s anonymous_thp -m 2 -b 4G -v ${NR_VCPUS}

Time to dirty memory:

        +-------+----------+-------------------+
        | vCPUs | 6.1-rc2  | 6.1-rc2 + series  |
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
        | vCPUs | 6.1-rc2  | 6.1-rc2 + series  |
        +-------+----------+-------------------+
        |     1 | 0.21s    | 0.17s             |
        |     2 | 0.26s    | 0.23s             |
        |     4 | 0.39s    | 0.31s             |
        |     8 | 0.68s    | 0.39s             |
        |    16 | 1.26s    | 0.53s             |
        |    32 | 2.51s    | 1.04s             |
        |    48 | 3.94s    | 1.55s             |
        +-------+----------+-------------------+

v2 -> v3:
 - Drop const qualifier from opaque argument pointer. The whole visitor
   context is passed as a const pointer.
 - kvm_set_spte_gfn() is called under the write lock; don't set the
   SHARED bit in this case (Sean).
 - Fix build warning resulting from reparameterization residue (test
   robot).
 - Add an assertion that the RCU read lock is held before the raw
   pointer is used in visitors (Marc, off list).

v1 -> v2:
 - It builds! :-)
 - Roll all of the context associated with PTE visit into a
   stack-allocated structure
 - Clean up the oddball handling of PTE values, avoiding a UAF along the
   way (Quentin)
 - Leave the re-reading of the PTE after WALK_LEAF in place instead of
   attempting to return the installed PTE value (David)
 - Mention why RCU is stubbed out for hyp page table walkers (David)
 - Ensure that all reads of page table memory pass through an
   RCU-protected pointer. The lifetime of the dereference is contained
   within __kvm_pgtable_visit() (David).
 - Ensure that no user of stage2_map_walker() passes TABLE_POST (David)
 - Unwire the page table walkers from relying on struct kvm_pgtable,
   simplifying the passed context to RCU callbacks.
 - Key rcu_dereference() off of a page table flag indicating a shared
   walk. This is clear when either (1) the write lock is held or (2)
   called from an RCU callback.

v1: https://lore.kernel.org/kvmarm/20220830194132.962932-1-oliver.upton@linux.dev/
v2: https://lore.kernel.org/kvmarm/20221007232818.459650-1-oliver.upton@linux.dev/

Oliver Upton (15):
  KVM: arm64: Combine visitor arguments into a context structure
  KVM: arm64: Stash observed pte value in visitor context
  KVM: arm64: Pass mm_ops through the visitor context
  KVM: arm64: Don't pass kvm_pgtable through kvm_pgtable_walk_data
  KVM: arm64: Add a helper to tear down unlinked stage-2 subtrees
  KVM: arm64: Tear down unlinked stage-2 subtree after break-before-make
  KVM: arm64: Use an opaque type for pteps
  KVM: arm64: Protect stage-2 traversal with RCU
  KVM: arm64: Free removed stage-2 tables in RCU callback
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
 arch/arm64/kvm/hyp/pgtable.c          | 624 ++++++++++++++------------
 arch/arm64/kvm/mmu.c                  |  51 ++-
 5 files changed, 463 insertions(+), 347 deletions(-)


base-commit: 247f34f7b80357943234f93f247a1ae6b6c3a740
-- 
2.38.1.273.g43a17bfeac-goog

