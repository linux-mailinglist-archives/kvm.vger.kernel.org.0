Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 815213DC123
	for <lists+kvm@lfdr.de>; Sat, 31 Jul 2021 00:37:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233158AbhG3WhU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jul 2021 18:37:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232817AbhG3WhT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jul 2021 18:37:19 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A56B6C06175F
        for <kvm@vger.kernel.org>; Fri, 30 Jul 2021 15:37:14 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id p71-20020a25424a0000b029056092741626so12028996yba.19
        for <kvm@vger.kernel.org>; Fri, 30 Jul 2021 15:37:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=La1sDp9z728EUdArr8dAJV9rSsj40AWPAQ4RtlkYcwI=;
        b=XAy+zPjNUa+2DhPvYtIrpzlUnjnEicZzUYnBUboPHDm5LSBnJv9yDGitPLtSnkr0eN
         rmTs5VzGGpOrcL5XUB4IlNs0jpyUjuQhqsazyjbMJFhuOyeYczekeQtQcRf7Ilp1ieCi
         7HxLJ1MedDo9+eYTiKf2WDQHZxO0pElHAFQAwa6FD67o7R6UGw0p3uTAV1lBtKwi17Lq
         J0tCbtPhW7gRQir+vzV7cpTkdRdX0jdGfZ9edtkgKPtNU6s1v3tbcvHKtuFOukcmfz95
         PSEr0AFmsfOfclFMfhUrDCBZ7H/YOlZlks/mtrgOc+5zbkFzl3E4Mcwh2QF/2SAvIXOt
         f1IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=La1sDp9z728EUdArr8dAJV9rSsj40AWPAQ4RtlkYcwI=;
        b=BcS4DgiyVhIeK0uTi8r9B8CTWWyuucKOw/NOLxWLXpwtu+NcufqremGhuH2LCuU3L5
         dlGGhPuL9R53DvVZ3koyP0cjORi1FTWWXmUuhU8H185QuoS7F9MPBXg12rY7SHanQ3v1
         sJvDJVmbo1TWIsvQ+MdXC7WzdGhebA5hdZQP+bwmkjwVJDGfaGRSyZXWfertRGSBs43n
         GNkl30stuM3PUtzQjBlenacxi5STtQkuvgB9+CxuPPRiyNz0ihOEs2iScq5qaOTsmrN0
         o2v3SaDra167fuqcT0UYazVd7FdgOyf7YcraSe372yvtQ9IfVCRDv7Qg8/N79iVh1sqM
         1NZA==
X-Gm-Message-State: AOAM530Hg4XwJHrRxQh4txN6ePVzENnInDIW0oaNK78oFDtr2lJKKccZ
        txrmnYvu8M/YT+5wTArhxneRyjTYwgS1J27xNNxEbZra4QWIS2ah9Vp6FTFlrjGRj19woC5ZZ6B
        UENU71OQ35LcCeekvho7e0U5gxid9jOfTo+41uBBQWGlXrSQUJpuwxrHvkdw4MdI=
X-Google-Smtp-Source: ABdhPJzcuwwgkqV2TqY+j9OVN3wdzpyH6oHcSXdlPmkkkPQvsTKg05TEJyGGVzlEoWzNBSOQFWTck3OYXsw4mg==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a05:6902:54e:: with SMTP id
 z14mr2758285ybs.334.1627684633762; Fri, 30 Jul 2021 15:37:13 -0700 (PDT)
Date:   Fri, 30 Jul 2021 22:37:01 +0000
Message-Id: <20210730223707.4083785-1-dmatlack@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.554.ge1b32706d8-goog
Subject: [PATCH 0/6] Improve gfn-to-memslot performance during page faults
From:   David Matlack <dmatlack@google.com>
To:     kvm@vger.kernel.org
Cc:     Ben Gardon <bgardon@google.com>, Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Junaid Shahid <junaids@google.com>,
        Andrew Jones <drjones@redhat.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series improves the performance of gfn-to-memslot lookups during
page faults. Ben Gardon originally identified this performance gap and
sufficiently addressed it in Google's kernel by reading the memslot once
at the beginning of the page fault and passing around the pointer.

This series takes an alternative approach by introducing a per-vCPU
cache of the least recently used memslot index. This avoids needing to
binary search the existing memslots multiple times during a page fault.
Unlike passing around the pointer, the LRU cache has an additional
benefit in that it speeds up gfn-to-memslot lookups *across* faults and
during spte prefetching where the gfn changes.

This difference can be seen clearly when looking at the performance of
fast_page_fault when multiple slots are in play:

Metric                        | Baseline     | Pass*    | LRU**
----------------------------- | ------------ | -------- | ----------
Iteration 2 dirty memory time | 2.8s         | 1.6s     | 0.30s

* Pass: Lookup the memslot once per fault and pass it around.
** LRU: Cache the LRU slot per vCPU (i.e. this series).

(Collected via ./dirty_log_perf_test -v64 -x64)

I plan to also send a follow-up series with a version of Ben's patches
to pass the pointer to the memslot through the page fault handling code
rather than looking it up multiple times. Even when applied on top of
the LRU series it has some performance improvements by avoiding a few
extra memory accesses (mainly kvm->memslots[as_id] and
slots->used_slots). But it will be a judgement call whether or not it's
worth the code churn and complexity.

Here is a break down of this series:

Patches 1-2 introduce a per-vCPU cache of the least recently memslot
index.

Patches 3-5 convert existing gfn-to-memslot lookups to use
kvm_vcpu_gfn_to_memslot so that they can leverage the new LRU cache.

Patch 6 adds support for multiple slots to dirty_log_perf_test which is
used to generate the performance data in this series.

David Matlack (6):
  KVM: Cache the least recently used slot index per vCPU
  KVM: Avoid VM-wide lru_slot lookup in kvm_vcpu_gfn_to_memslot
  KVM: x86/mmu: Speed up dirty logging in
    tdp_mmu_map_handle_target_level
  KVM: x86/mmu: Leverage vcpu->lru_slot_index for rmap_add and
    rmap_recycle
  KVM: x86/mmu: Rename __gfn_to_rmap to gfn_to_rmap
  KVM: selftests: Support multiple slots in dirty_log_perf_test

 arch/x86/kvm/mmu/mmu.c                        | 54 +++++++------
 arch/x86/kvm/mmu/tdp_mmu.c                    | 15 +++-
 include/linux/kvm_host.h                      | 73 +++++++++++++-----
 .../selftests/kvm/access_tracking_perf_test.c |  2 +-
 .../selftests/kvm/demand_paging_test.c        |  2 +-
 .../selftests/kvm/dirty_log_perf_test.c       | 76 ++++++++++++++++---
 .../selftests/kvm/include/perf_test_util.h    |  2 +-
 .../selftests/kvm/lib/perf_test_util.c        | 20 +++--
 .../kvm/memslot_modification_stress_test.c    |  2 +-
 virt/kvm/kvm_main.c                           | 21 ++++-
 10 files changed, 198 insertions(+), 69 deletions(-)

-- 
2.32.0.554.ge1b32706d8-goog

