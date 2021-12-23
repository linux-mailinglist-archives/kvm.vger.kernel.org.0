Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC38347E947
	for <lists+kvm@lfdr.de>; Thu, 23 Dec 2021 23:23:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350406AbhLWWXn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Dec 2021 17:23:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232339AbhLWWXm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Dec 2021 17:23:42 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A024C061756
        for <kvm@vger.kernel.org>; Thu, 23 Dec 2021 14:23:42 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id k21-20020a63f015000000b0033db7baf101so3863567pgh.19
        for <kvm@vger.kernel.org>; Thu, 23 Dec 2021 14:23:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=OrzQLDV0JBGv9xZyOI3iXeGl6MYuDTmF8uhCLxF6pxY=;
        b=lYTB3jFJhbTbo9TZh/o313alnkQBEfNDm1VciotnT9J688PYPBEiZZUzMOPysawpic
         KIvx6DUGniq4KgrQKPkWe+SDI/MfiZXxzkORbo4rpI/JziFpbSNTjdPQmxOOIG0WAs36
         +iWY+p+98S5TjvibkoJGM3nAbpuFp2mSmHGFr6AkmPw8ZyIPaC6L2MlmduUEN180ToMo
         kjp//6UMOSWZui8wASl3mLrhU8+YOTNuUazC/mmqnzRwZtIq129CaeY4e1OPiQralpXM
         q7Bk4U/xc/xv/X+foUE8BRF5bm71xK5teeJaOoW38PJhZmdDeZZ4zGRErODeEy9rRR7s
         gGBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=OrzQLDV0JBGv9xZyOI3iXeGl6MYuDTmF8uhCLxF6pxY=;
        b=ahIBjWhiyMOHTbWIE6JV29tjTgq1H+lYQad3RzfrMN5MTLhnwBWUgsvA82jo0evF+E
         Bsyua+C33MddgAanMUGVHLfoGJU2tlabw8jFUNOJYeUDHx5Qlw7S+4AePUWnLUhz0tkU
         ZdtVPMNqQLGDmZHaWySHd7Eii4eIz8PWpwFrsA6B8TmjAvGaBkklzR8EQIjXPJTmkXtq
         Lr1nAdn4ZNCXHOfDqYiGlBqZpK7qt+1F9ltXEY4kK3gr2WGICqWMoZqvf/N9x+ovOvTy
         ksdUu8in45K4gkdXoPf/OU8Bjm3jriZNckVKFIvAT8T0j4xwUr+zB8zDGELVWN8p3nms
         QYCw==
X-Gm-Message-State: AOAM530LMDHXW7OrwefIVQD8Xf/Eu0EeWhYOc6x7Xb8eKVsHl0QrvUV6
        waWvMhP+QLol59i2lRS+SGzA6FBkkkA=
X-Google-Smtp-Source: ABdhPJyTWpHkIYY8FLLDoK4E5sb5seoJZtEKQMAdAzGE9EVmOk3eGjYInQ9lqNuqnEy6blmd5DK6f0E+QVU=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:cec2:b0:148:b4c1:540b with SMTP id
 d2-20020a170902cec200b00148b4c1540bmr3989850plg.0.1640298221901; Thu, 23 Dec
 2021 14:23:41 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 23 Dec 2021 22:22:48 +0000
Message-Id: <20211223222318.1039223-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.1.448.ga2b2bfdf31-goog
Subject: [PATCH v2 00/30] KVM: x86/mmu: Overhaul TDP MMU zapping and flushing
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>,
        Mingwei Zhang <mizhang@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Overhaul TDP MMU's handling of zapping and TLB flushing to reduce the
number of TLB flushes, fix soft lockups and RCU stalls, avoid blocking
vCPUs for long durations while zapping paging structure, and to clean up
the zapping code.

Patches 01-03 were allegedly queued when posted separately, but they haven't
showed up yet, and this series depends/conflicts on/with them, so here they
are again.

Based on kvm/queue-5.17, commit 1c4261809af0 ("KVM: SVM: include CR3 ...").

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

v2:
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

Sean Christopherson (30):
  KVM: x86/mmu: Use common TDP MMU zap helper for MMU notifier unmap
    hook
  KVM: x86/mmu: Move "invalid" check out of kvm_tdp_mmu_get_root()
  KVM: x86/mmu: Zap _all_ roots when unmapping gfn range in TDP MMU
  KVM: x86/mmu: Use common iterator for walking invalid TDP MMU roots
  KVM: x86/mmu: Check for present SPTE when clearing dirty bit in TDP
    MMU
  KVM: x86/mmu: Fix wrong/misleading comments in TDP MMU fast zap
  KVM: x86/mmu: Formalize TDP MMU's (unintended?) deferred TLB flush
    logic
  KVM: x86/mmu: Document that zapping invalidated roots doesn't need to
    flush
  KVM: x86/mmu: Drop unused @kvm param from kvm_tdp_mmu_get_root()
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
  KVM: selftests: Move raw KVM_SET_USER_MEMORY_REGION helper to utils
  KVM: selftests: Split out helper to allocate guest mem via memfd
  KVM: selftests: Define cpu_relax() helpers for s390 and x86
  KVM: selftests: Add test to populate a VM with the max possible guest
    mem

 arch/x86/kvm/mmu/mmu.c                        |  42 +-
 arch/x86/kvm/mmu/mmu_internal.h               |  16 +-
 arch/x86/kvm/mmu/tdp_iter.c                   |   6 +-
 arch/x86/kvm/mmu/tdp_iter.h                   |  15 +-
 arch/x86/kvm/mmu/tdp_mmu.c                    | 642 ++++++++++++------
 arch/x86/kvm/mmu/tdp_mmu.h                    |  32 +-
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   3 +
 .../testing/selftests/kvm/include/kvm_util.h  |   6 +
 .../selftests/kvm/include/s390x/processor.h   |   8 +
 .../selftests/kvm/include/x86_64/processor.h  |   5 +
 tools/testing/selftests/kvm/lib/kvm_util.c    |  66 +-
 .../selftests/kvm/max_guest_memory_test.c     | 292 ++++++++
 .../selftests/kvm/set_memory_region_test.c    |  35 +-
 14 files changed, 870 insertions(+), 299 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/max_guest_memory_test.c

-- 
2.34.1.448.ga2b2bfdf31-goog

