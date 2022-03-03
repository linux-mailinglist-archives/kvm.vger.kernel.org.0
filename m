Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 284A44CC61B
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 20:38:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235969AbiCCTji (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 14:39:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235861AbiCCTjh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 14:39:37 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EF68B50E32
        for <kvm@vger.kernel.org>; Thu,  3 Mar 2022 11:38:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646336329;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=LIqA+lNqjHjKCKmjSiwf7/bxTydScBcjTgeR2eFkens=;
        b=CMu2IiHZbJvQ8MsFdJbub26GHfbzBQXNFf1CatZELAbWmQ6+gzB2k2CERnh3IwNMfk3XZ/
        RkjVcSYh0PYookSPuBUF2WfdgCLB80bbhJDc/8GV3GKaJVku41FnsiOG9bvMJJ6cQgCcGf
        0hmh3wfHw9Efesxe+Tc7V3WKgJ939pk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-274-Bo2uh_HbOxOOCc6touhNvQ-1; Thu, 03 Mar 2022 14:38:46 -0500
X-MC-Unique: Bo2uh_HbOxOOCc6touhNvQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 57FD451DF;
        Thu,  3 Mar 2022 19:38:44 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 57D375DF2E;
        Thu,  3 Mar 2022 19:38:43 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Hildenbrand <david@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Mingwei Zhang <mizhang@google.com>
Subject: [PATCH v4 00/30] KVM: x86/mmu: Overhaul TDP MMU zapping and flushing
Date:   Thu,  3 Mar 2022 14:38:12 -0500
Message-Id: <20220303193842.370645-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Overhaul TDP MMU's handling of zapping and TLB flushing to reduce the
number of TLB flushes, fix soft lockups and RCU stalls, avoid blocking
vCPUs for long durations while zapping paging structure, and to clean up
the zapping code.

The largest cleanup is to separate the flows for zapping roots (zap
_everything_), zapping leaf SPTEs (zap guest mappings for whatever reason),
and zapping a specific SP (NX recovery).  They're currently smushed into a
single zap_gfn_range(), which was a good idea at the time, but became a
mess when trying to handle the different rules, e.g. TLB flushes aren't
needed when zapping a root because KVM can safely zap a root if and only
if it's unreachable.

To solve the soft lockups, stalls, and vCPU performance issues:

 - Defer remote TLB flushes to the caller when zapping TDP MMU shadow
   pages by relying on RCU to ensure the paging structure isn't freed
   until all vCPUs have exited the guest.

 - Allowing yielding when zapping TDP MMU roots in response to the root's
   last reference being put.  This requires a bit of trickery to ensure
   the root is reachable via mmu_notifier, but it's not too gross.

 - Zap roots in two passes to avoid holding RCU for potential hundreds of
   seconds when zapping guest with terabytes of memory that is backed
   entirely by 4kb SPTEs.

 - Zap defunct roots asynchronously via the common work_queue so that a
   vCPU doesn't get stuck doing the work if the vCPU happens to drop the
   last reference to a root.

The selftest at the end allows populating a guest with the max amount of
memory allowed by the underlying architecture.  The most I've tested is
~64tb (MAXPHYADDR=46) as I don't have easy access to a system with
MAXPHYADDR=52.  The selftest compiles on arm64 and s390x, but otherwise
hasn't been tested outside of x86-64.  It will hopefully do something
useful as is, but there's a non-zero chance it won't get past init with
a high max memory.  Running on x86 without the TDP MMU is comically slow.

Testing: passes kvm-unit-tests and guest installation tests on Intel.
Haven't yet run AMD or selftests.

Thanks,

Paolo

v4:
- collected reviews and typo fixes (plus some typo fixes of my own)

- new patches to simplify reader invariants: they are not allowed to
  acquire references to invalid roots

- new version of "Allow yielding when zapping GFNs for defunct TDP MMU
  root", simplifying the atomic a bit by 1) using xchg and relying on
  its implicit memory barriers 2) relying on readers to have the same
  behavior for the three stats refcount=0/valid, refcount=0/invalid,
  refcount=1/invalid (see previous point)

- switch zapping of invalidated roots to asynchronous workers on a
  per-VM workqueue, fixing a bug in v3 where the extra reference added
  by kvm_tdp_mmu_put_root could be given back twice.  This also replaces
  "KVM: x86/mmu: Use common iterator for walking invalid TDP MMU roots"
  in v3, since it gets rid of next_invalidated_root() in a different way.

- because of the previous point, most of the logic in v3's "KVM: x86/mmu:
  Zap defunct roots via asynchronous worker" moves to the earlier patch
  "KVM: x86/mmu: Zap invalidated roots via asynchronous worker"


v3:
- Drop patches that were applied.
- Rebase to latest kvm/queue.
- Collect a review. [David]
- Use helper instead of goto to zap roots in two passes. [David]
- Add patches to disallow REMOVED "old" SPTE when atomically
  setting SPTE.

Paolo Bonzini (5):
  KVM: x86/mmu: only perform eager page splitting on valid roots
  KVM: x86/mmu: do not allow readers to acquire references to invalid roots
  KVM: x86/mmu: Zap invalidated roots via asynchronous worker
  KVM: x86/mmu: Allow yielding when zapping GFNs for defunct TDP MMU root
  KVM: x86/mmu: Zap defunct roots via asynchronous worker

Sean Christopherson (25):
  KVM: x86/mmu: Check for present SPTE when clearing dirty bit in TDP MMU
  KVM: x86/mmu: Fix wrong/misleading comments in TDP MMU fast zap
  KVM: x86/mmu: Formalize TDP MMU's (unintended?) deferred TLB flush logic
  KVM: x86/mmu: Document that zapping invalidated roots doesn't need to flush
  KVM: x86/mmu: Require mmu_lock be held for write in unyielding root iter
  KVM: x86/mmu: Check for !leaf=>leaf, not PFN change, in TDP MMU SP removal
  KVM: x86/mmu: Batch TLB flushes from TDP MMU for MMU notifier change_spte
  KVM: x86/mmu: Drop RCU after processing each root in MMU notifier hooks
  KVM: x86/mmu: Add helpers to read/write TDP MMU SPTEs and document RCU
  KVM: x86/mmu: WARN if old _or_ new SPTE is REMOVED in non-atomic path
  KVM: x86/mmu: Refactor low-level TDP MMU set SPTE helper to take raw values
  KVM: x86/mmu: Zap only the target TDP MMU shadow page in NX recovery
  KVM: x86/mmu: Skip remote TLB flush when zapping all of TDP MMU
  KVM: x86/mmu: Add dedicated helper to zap TDP MMU root shadow page
  KVM: x86/mmu: Require mmu_lock be held for write to zap TDP MMU range
  KVM: x86/mmu: Zap only TDP MMU leafs in kvm_zap_gfn_range()
  KVM: x86/mmu: Do remote TLB flush before dropping RCU in TDP MMU resched
  KVM: x86/mmu: Defer TLB flush to caller when freeing TDP MMU shadow pages
  KVM: x86/mmu: Zap roots in two passes to avoid inducing RCU stalls
  KVM: x86/mmu: Check for a REMOVED leaf SPTE before making the SPTE
  KVM: x86/mmu: WARN on any attempt to atomically update REMOVED SPTE
  KVM: selftests: Move raw KVM_SET_USER_MEMORY_REGION helper to utils
  KVM: selftests: Split out helper to allocate guest mem via memfd
  KVM: selftests: Define cpu_relax() helpers for s390 and x86
  KVM: selftests: Add test to populate a VM with the max possible guest mem

 arch/x86/include/asm/kvm_host.h               |   2 +
 arch/x86/kvm/mmu/mmu.c                        |  49 +-
 arch/x86/kvm/mmu/mmu_internal.h               |  15 +-
 arch/x86/kvm/mmu/tdp_iter.c                   |   6 +-
 arch/x86/kvm/mmu/tdp_iter.h                   |  15 +-
 arch/x86/kvm/mmu/tdp_mmu.c                    | 559 +++++++++++-------
 arch/x86/kvm/mmu/tdp_mmu.h                    |  26 +-
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   3 +
 .../selftests/kvm/include/kvm_util_base.h     |   5 +
 .../selftests/kvm/include/s390x/processor.h   |   8 +
 .../selftests/kvm/include/x86_64/processor.h  |   5 +
 tools/testing/selftests/kvm/lib/kvm_util.c    |  66 ++-
 .../selftests/kvm/max_guest_memory_test.c     | 292 +++++++++
 .../selftests/kvm/set_memory_region_test.c    |  35 +-
 15 files changed, 794 insertions(+), 293 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/max_guest_memory_test.c

-- 
2.31.1

