Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80D063E0A57
	for <lists+kvm@lfdr.de>; Thu,  5 Aug 2021 00:29:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233155AbhHDW3P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Aug 2021 18:29:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232833AbhHDW3N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Aug 2021 18:29:13 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14474C0613D5
        for <kvm@vger.kernel.org>; Wed,  4 Aug 2021 15:29:00 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id q72-20020a17090a1b4eb0290177884285a6so3261355pjq.2
        for <kvm@vger.kernel.org>; Wed, 04 Aug 2021 15:29:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=VvkWlchhM2p/8iXJnku4XGIW/POiWiCgClUseEdKOWU=;
        b=Ry4JBSzswXdT4zLqqK4pNEo8zA8wZ1ctk0Wc0HK360E9/8SB0n4Zd9mCxXL/4o8opV
         +l7ETLslJ1YTAM07XhUV2vhNfY5/9c3ti3p0QrzPeMvqGFbryzEyMzDd9yCgFnZMdON+
         9VvK4UEShBFCOD3C9tv6u9ls5lfctUf0Lf+lW5aGMp7Y8f7RtKi+WZnsby1qfL8V7E5j
         pV9JZBoqFn4mQkuAw4uEyKizjvHBhA4Yv7a/nOCb1Bd4SaIT8Xm/fmWxt+DSEuX/r6Hw
         HmYdQhWOQLb73anmKDv0dov7/4UjeILLd7AjAxbyB26WjYkHQFUXIt8zm0pWIQ3y4i/b
         2Rxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=VvkWlchhM2p/8iXJnku4XGIW/POiWiCgClUseEdKOWU=;
        b=ilwL0XPtT7+v6NxSCFkJpbPY0gCDF3VzyTSpZKFGEKpAkwWGi831DfgM61s+SE9OKY
         kNO2W/0mR/N2tzPlfq+8Yz2EHjVCYEm5ylxTLQSSRLpuZhOtvu1s9KzaahZik0DBffuO
         sDeRyU3mvhMQ/XeSZ4n+O9eEhz7AIIccvvfSfsduW1753x7dAJsEi3UHxiQJVhulvoaz
         GPeqy0mPy6xCIFs9IyZrj38P2pWdLL0A3bmiuRDti9f4PosF8XXiFvALpd/yksw5FXT9
         7SmmVgQEaQhz6o5zHOk1oLCavEjqo97QTlp0J7dJmTw8aI47ZyLy9419fWLtF/+cCuli
         Qx/A==
X-Gm-Message-State: AOAM531tKRPMPQOUrb3zimzpCFOs3dgDN/i2oI2LYPQYFEzEHn76AAmM
        M+f5B9POFLS2VwroGexrDLz8plCKiiN6lg==
X-Google-Smtp-Source: ABdhPJwdYfBRGR/ArzXVnq5PqNjjPUwtoxjQp19Qo4Ru7u3vt/+YQaEWgu1ahryyokOBMvZzgcOMiIpNwUDvsw==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:902:eb52:b029:12c:3265:26a with SMTP
 id i18-20020a170902eb52b029012c3265026amr1207733pli.34.1628116139603; Wed, 04
 Aug 2021 15:28:59 -0700 (PDT)
Date:   Wed,  4 Aug 2021 22:28:37 +0000
Message-Id: <20210804222844.1419481-1-dmatlack@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.554.ge1b32706d8-goog
Subject: [PATCH v2 0/7] Improve gfn-to-memslot performance during page faults
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Junaid Shahid <junaids@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
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
Unlike passing around the pointer, the cache has an additional benefit
in that it speeds up gfn-to-memslot lookups *across* faults and during
spte prefetching where the gfn changes.

This difference can be seen clearly when looking at the performance of
fast_page_fault when multiple slots are in play:

Metric                        | Baseline     | Pass*    | Cache**
----------------------------- | ------------ | -------- | ----------
Iteration 2 dirty memory time | 2.8s         | 1.6s     | 0.30s

* Pass: Lookup the memslot once per fault and pass it around.
** Cache: Cache the last used slot per vCPU (i.e. this series).

(Collected via ./dirty_log_perf_test -v64 -x64)

I plan to also send a follow-up series with a version of Ben's patches
to pass the pointer to the memslot through the page fault handling code
rather than looking it up multiple times. Even when applied on top of
the cache series it has some performance improvements by avoiding a few
extra memory accesses (mainly kvm->memslots[as_id] and
slots->used_slots). But it will be a judgement call whether or not it's
worth the code churn and complexity.

v2:
 * Rename lru to last_used [Paolo]
 * Tree-wide replace search_memslots with __gfn_to_memslot [Paolo]
 * Avoid speculation when accessesing slots->memslots [Paolo]
 * Refactor tdp_set_spte_atomic to leverage vcpu->last_used_slot [Paolo]
 * Add Paolo's Reviewed-by tags
 * Fix build failures in mmu_audit.c [kernel test robot]

v1: https://lore.kernel.org/kvm/20210730223707.4083785-1-dmatlack@google.com/

David Matlack (7):
  KVM: Rename lru_slot to last_used_slot
  KVM: Move last_used_slot logic out of search_memslots
  KVM: Cache the last used slot index per vCPU
  KVM: x86/mmu: Leverage vcpu->last_used_slot in
    tdp_mmu_map_handle_target_level
  KVM: x86/mmu: Leverage vcpu->last_used_slot for rmap_add and
    rmap_recycle
  KVM: x86/mmu: Rename __gfn_to_rmap to gfn_to_rmap
  KVM: selftests: Support multiple slots in dirty_log_perf_test

 arch/powerpc/kvm/book3s_64_vio.c              |  2 +-
 arch/powerpc/kvm/book3s_64_vio_hv.c           |  2 +-
 arch/s390/kvm/kvm-s390.c                      |  4 +-
 arch/x86/kvm/mmu/mmu.c                        | 54 +++++++------
 arch/x86/kvm/mmu/mmu_audit.c                  |  4 +-
 arch/x86/kvm/mmu/tdp_mmu.c                    | 42 +++++++---
 include/linux/kvm_host.h                      | 80 +++++++++++++++----
 .../selftests/kvm/access_tracking_perf_test.c |  2 +-
 .../selftests/kvm/demand_paging_test.c        |  2 +-
 .../selftests/kvm/dirty_log_perf_test.c       | 76 +++++++++++++++---
 .../selftests/kvm/include/perf_test_util.h    |  2 +-
 .../selftests/kvm/lib/perf_test_util.c        | 20 +++--
 .../kvm/memslot_modification_stress_test.c    |  2 +-
 virt/kvm/kvm_main.c                           | 26 +++++-
 14 files changed, 238 insertions(+), 80 deletions(-)

-- 
2.32.0.554.ge1b32706d8-goog

