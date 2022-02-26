Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C49E4C526F
	for <lists+kvm@lfdr.de>; Sat, 26 Feb 2022 01:16:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240056AbiBZAQf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 19:16:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236348AbiBZAQe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 19:16:34 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A98382118F9
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 16:16:01 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id g31-20020a63521f000000b003783582a261so1439330pgb.5
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 16:16:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=nJ7T2/Eu0kELrWfOHFiuRi78BtlV/GKdiarGzSeljcE=;
        b=Xt+4iTJwwp9DbCI6oRTmoYIzy6Mi2+yjlhedxHM4EIkIrsuU4DkckUVye5uQyxXOut
         lsOU4iTkW5/AkP+K9a5HdsyBDsuAR3zC5KX9TEyu18p5R1iUOg4kwrJmEj6q2NlbSdFg
         EdyflBEuagAyC2yErwUDGzqnuMLkZDkkhcwfOpql1/FkPULLhd6gyu2vP7+YxX173NLo
         ppU19l22kPw2G9K5RZBHisFip7jO7ZBcL5jTYmueprtzH85Pd4vdP17+Lld5OmeICRhH
         78JvzLsbsXCKCjBuYDcrbm/5RwT6HmHUkWUJA4B0f+CwPDk/Rk8QLerCFPEafS2L0cnT
         INIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=nJ7T2/Eu0kELrWfOHFiuRi78BtlV/GKdiarGzSeljcE=;
        b=qh1own3IGKyzbDeugcp1wIayXqiYo5NF1p2PoyUSCUKY37GQazN3idfaQccMJXxKvN
         RlS1KOjXJ4zyn3OoryPhaLNzBw3kCpAH7w9EGbf5Xg3/Dj/2VUe4vvGkAMdimfj5P1oM
         KHoNm6ImdroxuD8qFVuOnB85h9bQLG6Xjm4ag8cV8+8zPXAIlaQSQqalMpv6tZFN8AN2
         kuhQDMh9cwiwfdmAG+cr7t2ad9DjHBbO8d22TShU57LO7DQlYeZEFT4VVfaBPaNTdl04
         Qp47QUE/m6XijBsAyLQ0BpHzXWPqf5zZx9Kq1GzMsSaisVcOry2zET9erFTXxGGkm4UM
         qDlA==
X-Gm-Message-State: AOAM533GJ8S7UxrPDu3qEk9SNhvnbvWwtljVarwz9zBz4pA0Yl7R2lzo
        IoM4AKGDk1E5WLGLUy3WaG/NQKU5Ano=
X-Google-Smtp-Source: ABdhPJy4c/aYDFUNcEp854e/8yA0riolv8ASU2lMLjWbw/piD98wr2QFUpC0gUAH42k0DaB+JU0SVjPhQnU=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:f48f:b0:1bc:2521:fb0a with SMTP id
 bx15-20020a17090af48f00b001bc2521fb0amr5661180pjb.48.1645834561115; Fri, 25
 Feb 2022 16:16:01 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 26 Feb 2022 00:15:18 +0000
Message-Id: <20220226001546.360188-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
Subject: [PATCH v3 00/28] KVM: x86/mmu: Overhaul TDP MMU zapping and flushing
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Mingwei Zhang <mizhang@google.com>
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

v3:
  - Drop patches that were applied.
  - Rebase to latest kvm/queue.
  - Collect a review. [David]
  - Use helper instead of goto to zap roots in two passes. [David]
  - Add patches to disallow REMOVED "old" SPTE when atomically
    setting SPTE.

v2:
  - https://lore.kernel.org/all/20211223222318.1039223-1-seanjc@google.com
  - Drop patches that were applied.
  - Collect reviews for patches that weren't modified. [Ben]
  - Abandon the idea of taking invalid roots off the list of roots.
  - Add a patch to fix misleading/wrong comments with respect to KVM's
    responsibilities in the "fast zap" flow, specifically that all SPTEs
    must be dropped before the zap completes.
  - Rework yielding in kvm_tdp_mmu_put_root() to keep the root visibile
    while yielding.
  - Add patch to zap roots in two passes. [Mingwei, David]
  - Add a patch to asynchronously zap defunct roots.
  - Add the selftest.

v1: https://lore.kernel.org/all/20211120045046.3940942-1-seanjc@google.com


Sean Christopherson (28):
  KVM: x86/mmu: Use common iterator for walking invalid TDP MMU roots
  KVM: x86/mmu: Check for present SPTE when clearing dirty bit in TDP
    MMU
  KVM: x86/mmu: Fix wrong/misleading comments in TDP MMU fast zap
  KVM: x86/mmu: Formalize TDP MMU's (unintended?) deferred TLB flush
    logic
  KVM: x86/mmu: Document that zapping invalidated roots doesn't need to
    flush
  KVM: x86/mmu: Require mmu_lock be held for write in unyielding root
    iter
  KVM: x86/mmu: Check for !leaf=>leaf, not PFN change, in TDP MMU SP
    removal
  KVM: x86/mmu: Batch TLB flushes from TDP MMU for MMU notifier
    change_spte
  KVM: x86/mmu: Drop RCU after processing each root in MMU notifier
    hooks
  KVM: x86/mmu: Add helpers to read/write TDP MMU SPTEs and document RCU
  KVM: x86/mmu: WARN if old _or_ new SPTE is REMOVED in non-atomic path
  KVM: x86/mmu: Refactor low-level TDP MMU set SPTE helper to take raw
    vals
  KVM: x86/mmu: Zap only the target TDP MMU shadow page in NX recovery
  KVM: x86/mmu: Skip remote TLB flush when zapping all of TDP MMU
  KVM: x86/mmu: Add dedicated helper to zap TDP MMU root shadow page
  KVM: x86/mmu: Require mmu_lock be held for write to zap TDP MMU range
  KVM: x86/mmu: Zap only TDP MMU leafs in kvm_zap_gfn_range()
  KVM: x86/mmu: Do remote TLB flush before dropping RCU in TDP MMU
    resched
  KVM: x86/mmu: Defer TLB flush to caller when freeing TDP MMU shadow
    pages
  KVM: x86/mmu: Allow yielding when zapping GFNs for defunct TDP MMU
    root
  KVM: x86/mmu: Zap roots in two passes to avoid inducing RCU stalls
  KVM: x86/mmu: Zap defunct roots via asynchronous worker
  KVM: x86/mmu: Check for a REMOVED leaf SPTE before making the SPTE
  KVM: x86/mmu: WARN on any attempt to atomically update REMOVED SPTE
  KVM: selftests: Move raw KVM_SET_USER_MEMORY_REGION helper to utils
  KVM: selftests: Split out helper to allocate guest mem via memfd
  KVM: selftests: Define cpu_relax() helpers for s390 and x86
  KVM: selftests: Add test to populate a VM with the max possible guest
    mem

 arch/x86/kvm/mmu/mmu.c                        |  42 +-
 arch/x86/kvm/mmu/mmu_internal.h               |  15 +-
 arch/x86/kvm/mmu/tdp_iter.c                   |   6 +-
 arch/x86/kvm/mmu/tdp_iter.h                   |  15 +-
 arch/x86/kvm/mmu/tdp_mmu.c                    | 595 ++++++++++++------
 arch/x86/kvm/mmu/tdp_mmu.h                    |  26 +-
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   3 +
 .../selftests/kvm/include/kvm_util_base.h     |   5 +
 .../selftests/kvm/include/s390x/processor.h   |   8 +
 .../selftests/kvm/include/x86_64/processor.h  |   5 +
 tools/testing/selftests/kvm/lib/kvm_util.c    |  66 +-
 .../selftests/kvm/max_guest_memory_test.c     | 292 +++++++++
 .../selftests/kvm/set_memory_region_test.c    |  35 +-
 14 files changed, 832 insertions(+), 282 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/max_guest_memory_test.c


base-commit: 625e7ef7da1a4addd8db41c2504fe8a25b93acd5
-- 
2.35.1.574.g5d30c73bfb-goog

