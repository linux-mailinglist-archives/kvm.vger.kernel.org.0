Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E89702F380B
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 19:14:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388490AbhALSL3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 13:11:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726091AbhALSL0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jan 2021 13:11:26 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15FCDC061786
        for <kvm@vger.kernel.org>; Tue, 12 Jan 2021 10:10:46 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id 1so2138419pgu.17
        for <kvm@vger.kernel.org>; Tue, 12 Jan 2021 10:10:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=fnzL0jDAo9xIfWQHPhjTRvzsU8/hpdoL+ymw2yPPaR8=;
        b=bqh/tCOplimzhw8TJ/Fx5s21Ja85FXBo8arh+ndM+lpHS+EJqewnynGxBMBabsKe6Y
         4EkJd/rR++NPUXHuDM8q6sVB7GoNERQ4XLPc90D/kLMCnqKPa6UNr5QFVPg8xMBDg/lt
         ncSAj9qRn4ANhmZ9y2LyOcqxg1KY6Lg3ec3whFr9zuYwlOF7PgFcBkgcyF9Lh1qmi7Ph
         dKcMrkVm5EdCA8oGV3WsDCaEgZ/SpUlH3We7Hc+/5qhQYpccgdkxuT42jInXXyaHLM5F
         BWpHN1LQ4Fkbv63GwcnRzTMd1DBHTvIpoKUmZRu+NZIdLw7HDvghPTTkc6wSZh0EFEbp
         yJxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=fnzL0jDAo9xIfWQHPhjTRvzsU8/hpdoL+ymw2yPPaR8=;
        b=J8tcScoM/dBYzjXK+LifG9XKOc3xi/hSQOSliyhK4LGgpEEU17AqcYWQiPNHvXEG61
         +C5WS3LFkA/vycYM8EPAMBahodhht0COd0PW+q1sogRNvO04OiIiFto1ZZzGCCgdvFjV
         hB0Oi/2F7aWW9cvMa/BdlqGWNozH9ey15aN2mUcY0SG639VJAPZrQNnt5JxChP91cbtI
         l7JS+cxiZr0GrL/aFrY6/7vHjqWO91t/l4KqfuGh3C13lYK2NbGacpVmQ4R7zQWxaX9m
         R2XTP1yIqGxtERPZ4ce8SobGr5Uqnyr5+tzPa4QXibUZqDBvukuV/N3wGmeTZNCBdIk0
         ouqA==
X-Gm-Message-State: AOAM532WjR7cpQlkfu9+AAuPvLRiRkhHRJDKjw0zGpjJlqfWOJvrX/Tf
        l4zsw73LjF+2rrAj7aWEqY1g8AtCHnhE
X-Google-Smtp-Source: ABdhPJwEwgh4q6rWDhbMv93t+vDodjDTTzM72nf4MGU5I/ay3h4PAvJKiXoGPcBhiCK05TLEdRtqvwbl4qkv
Sender: "bgardon via sendgmr" <bgardon@bgardon.sea.corp.google.com>
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:f693:9fff:fef4:a293])
 (user=bgardon job=sendgmr) by 2002:a17:902:ab97:b029:de:30a:5234 with SMTP id
 f23-20020a170902ab97b02900de030a5234mr301190plr.55.1610475045535; Tue, 12 Jan
 2021 10:10:45 -0800 (PST)
Date:   Tue, 12 Jan 2021 10:10:17 -0800
Message-Id: <20210112181041.356734-1-bgardon@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
Subject: [PATCH 00/24] Allow parallel page faults with TDP MMU
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The TDP MMU was implemented to simplify and improve the performance of
KVM's memory management on modern hardware with TDP (EPT / NPT). To build
on the existing performance improvements of the TDP MMU, add the ability
to handle vCPU page faults in parallel. In the current implementation,
vCPU page faults (actually EPT/NPT violations/misconfigurations) are the
largest source of MMU lock contention on VMs with many vCPUs. This
contention, and the resulting page fault latency, can soft-lock guests
and degrade performance. Handling page faults in parallel is especially
useful when booting VMs, enabling dirty logging, and handling demand
paging. In all these cases vCPUs are constantly incurring  page faults on
each new page accessed.

Broadly, the following changes were required to allow parallel page
faults:
-- Contention detection and yielding added to rwlocks to bring them up to
   feature parity with spin locks, at least as far as the use of the MMU
   lock is concerned.
-- TDP MMU page table memory is protected with RCU and freed in RCU
   callbacks to allow multiple threads to operate on that memory
   concurrently.
-- When the TDP MMU is enabled, a rwlock is used instead of a spin lock on
   x86. This allows the page fault handlers to acquire the MMU lock in read
   mode and handle page faults in parallel while other operations maintain
   exclusive use of the lock by acquiring it in write mode.
-- An additional lock is added to protect some data structures needed by
   the page fault handlers, for relatively infrequent operations.
-- The page fault handler is modified to use atomic cmpxchgs to set SPTEs
   and some page fault handler operations are modified slightly to work
   concurrently with other threads.

This series also contains a few bug fixes and optimizations, related to
the above, but not strictly part of enabling parallel page fault handling.

Performance testing:
The KVM selftests dirty_log_perf_test demonstrates the performance
improvements associated with this patch series. The dirty_log_perf test
was run on a two socket Indus Skylake, with a VM with 96 vCPUs.
5 get-dirty-log iterations were run. Each test was run 3 times and the
results averaged. The test was conducted with 3 different variables:
Overlapping versus partitioned memory
With overlapping memory vCPUs are more likely to incur retries handling
parallel page faults, so the TDP MMU with parallel page faults is expected
to fare the worst in this situation.
Partitioned memory between vCPUs is a best case for parallel page faults
with the TDP MMU as it should minimize contention and retries.
When running with partitioned memory, 3G was allocated for each vCPU's
data region. When running with overlapping memory accesses, a total of 6G
was allocated for the VM's data region. This meant that the VM was much
smaller overall, but each vCPU had more memory to access. Since the VMs
were very different in size, the results cannot be reliably compared. The
VM sizes were chosen to balance test runtime and repeatability of results.
The option to overlap memory accesses will be added to dirty_log_perf_test
in a (near-)future series.
With this patch set applied versus without
In these tests the series was applied on commit:
9f1abbe97c08 Merge tag 'for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost
That commit was also used as the baseline.
TDP MMU enabled versus disabled
This is primarily included to ensure that this series does not regress
performance with the TDP MMU disabled.

Does this series improve performance with the TDP MMU enabled?

Baseline, TDP MMU enabled, partitioned accesses:
Populate memory time (s)		110.193
Enabling dirty logging time (s)		4.829
Dirty memory time (s)			3.949
Get dirty log time (s)			0.822
Disabling dirty logging time (s)	2.995
Parallel PFs series, TDP MMU enabled, partitioned accesses:
Populate memory time (s)		16.112
Enabling dirty logging time (s)		7.057
Dirty memory time (s)			0.275
Get dirty log time (s)			5.468
Disabling dirty logging time (s)	3.088

This scenario demonstrates the big win in this series: an 85% reduction in
the time taken to populate memory! Note that the time taken to dirty memory
is much shorter and the time to get the dirty log higher with this series.

Baseline, TDP MMU enabled, overlapping accesses:
Populate memory time (s)		117.31
Enabling dirty logging time (s)		0.191
Dirty memory time (s)			0.193
Get dirty log time (s)			2.33
Disabling dirty logging time (s)	0.059
Parallel PFs series, TDP MMU enabled, overlapping accesses:
Populate memory time (s)		141.155
Enabling dirty logging time (s)		0.245
Dirty memory time (s)			0.236
Get dirty log time (s)			2.35
Disabling dirty logging time (s)	0.075

With overlapping accesses, we can see that this parallel page faults
series actually reduces performance when populating memory. In profiling,
it appeared that most of the time was spent in get_user_pages, so it's
possible the extra concurrency hit the main MM subsystem harder, creating
contention there.

Does this series degrade performance with the TDP MMU disabled?

Baseline, TDP MMU disabled, partitioned accesses:
Populate memory time (s)		110.193
Enabling dirty logging time (s)		4.829
Dirty memory time (s)			3.949
Get dirty log time (s)			0.822
Disabling dirty logging time (s)	2.995
Parallel PFs series, TDP MMU disabled, partitioned accesses:
Populate memory time (s)		110.917
Enabling dirty logging time (s)		5.196
Dirty memory time (s)			4.559
Get dirty log time (s)			0.879
Disabling dirty logging time (s)	3.278

Here we can see that the parallel PFs series appears to have made enabling
and disabling dirty logging, and dirtying memory slightly slower. It's
possible that this is a result of additional checks around MMU lock
acquisition.

Baseline, TDP MMU disabled, overlapping accesses:
Populate memory time (s)		103.115
Enabling dirty logging time (s)		0.222
Dirty memory time (s)			0.189
Get dirty log time (s)			2.341
Disabling dirty logging time (s)	0.126
Parallel PFs series, TDP MMU disabled, overlapping accesses:
Populate memory time (s)		85.392
Enabling dirty logging time (s)		0.224
Dirty memory time (s)			0.201
Get dirty log time (s)			2.363
Disabling dirty logging time (s)	0.131

From the above results we can see that the parallel PF series only had a
significant effect on the population time, with overlapping accesses and
the TDP MMU disabled. It is not currently known what in this series caused
the improvement.

Correctness testing:
The following tests were performed with an SMP kernel and DBX kernel on an
Intel Skylake machine. The tests were run both with and without the TDP
MMU enabled.
-- This series introduces no new failures in kvm-unit-tests
SMP + no TDP MMU no new failures
SMP + TDP MMU no new failures
DBX + no TDP MMU no new failures
DBX + TDP MMU no new failures
-- All KVM selftests behave as expected
SMP + no TDP MMU all pass except ./x86_64/vmx_preemption_timer_test
SMP + TDP MMU all pass except ./x86_64/vmx_preemption_timer_test
(./x86_64/vmx_preemption_timer_test also fails without this patch set,
both with the TDP MMU on and off.)
DBX + no TDP MMU all pass
DBX + TDP MMU all pass
-- A VM can be booted running a Debian 9 and all memory accessed
SMP + no TDP MMU works
SMP + TDP MMU works
DBX + no TDP MMU works
DBX + TDP MMU works
Cross-compilation was also checked for PowerPC and ARM64.

This series can be viewed in Gerrit at:
https://linux-review.googlesource.com/c/linux/kernel/git/torvalds/linux/+/7172

Ben Gardon (24):
  locking/rwlocks: Add contention detection for rwlocks
  sched: Add needbreak for rwlocks
  sched: Add cond_resched_rwlock
  kvm: x86/mmu: change TDP MMU yield function returns to match
    cond_resched
  kvm: x86/mmu: Fix yielding in TDP MMU
  kvm: x86/mmu: Skip no-op changes in TDP MMU functions
  kvm: x86/mmu: Add comment on __tdp_mmu_set_spte
  kvm: x86/mmu: Add lockdep when setting a TDP MMU SPTE
  kvm: x86/mmu: Don't redundantly clear TDP MMU pt memory
  kvm: x86/mmu: Factor out handle disconnected pt
  kvm: x86/mmu: Put TDP MMU PT walks in RCU read-critical section
  kvm: x86/kvm: RCU dereference tdp mmu page table links
  kvm: x86/mmu: Only free tdp_mmu pages after a grace period
  kvm: mmu: Wrap mmu_lock lock / unlock in a function
  kvm: mmu: Wrap mmu_lock cond_resched and needbreak
  kvm: mmu: Wrap mmu_lock assertions
  kvm: mmu: Move mmu_lock to struct kvm_arch
  kvm: x86/mmu: Use an rwlock for the x86 TDP MMU
  kvm: x86/mmu: Protect tdp_mmu_pages with a lock
  kvm: x86/mmu: Add atomic option for setting SPTEs
  kvm: x86/mmu: Use atomic ops to set SPTEs in TDP MMU map
  kvm: x86/mmu: Flush TLBs after zap in TDP MMU PF handler
  kvm: x86/mmu: Freeze SPTEs in disconnected pages
  kvm: x86/mmu: Allow parallel page faults for the TDP MMU

 Documentation/virt/kvm/locking.rst       |   2 +-
 arch/arm64/include/asm/kvm_host.h        |   2 +
 arch/arm64/kvm/arm.c                     |   2 +
 arch/arm64/kvm/mmu.c                     |  40 +-
 arch/mips/include/asm/kvm_host.h         |   2 +
 arch/mips/kvm/mips.c                     |  10 +-
 arch/mips/kvm/mmu.c                      |  20 +-
 arch/powerpc/include/asm/kvm_book3s_64.h |   7 +-
 arch/powerpc/include/asm/kvm_host.h      |   2 +
 arch/powerpc/kvm/book3s_64_mmu_host.c    |   4 +-
 arch/powerpc/kvm/book3s_64_mmu_hv.c      |  12 +-
 arch/powerpc/kvm/book3s_64_mmu_radix.c   |  32 +-
 arch/powerpc/kvm/book3s_64_vio_hv.c      |   4 +-
 arch/powerpc/kvm/book3s_hv.c             |   8 +-
 arch/powerpc/kvm/book3s_hv_nested.c      |  59 ++-
 arch/powerpc/kvm/book3s_hv_rm_mmu.c      |  14 +-
 arch/powerpc/kvm/book3s_mmu_hpte.c       |  10 +-
 arch/powerpc/kvm/e500_mmu_host.c         |   6 +-
 arch/powerpc/kvm/powerpc.c               |   2 +
 arch/s390/include/asm/kvm_host.h         |   2 +
 arch/s390/kvm/kvm-s390.c                 |   2 +
 arch/x86/include/asm/kvm_host.h          |  23 +
 arch/x86/kvm/mmu/mmu.c                   | 189 ++++++--
 arch/x86/kvm/mmu/mmu_internal.h          |  16 +-
 arch/x86/kvm/mmu/page_track.c            |   8 +-
 arch/x86/kvm/mmu/paging_tmpl.h           |   8 +-
 arch/x86/kvm/mmu/spte.h                  |  16 +-
 arch/x86/kvm/mmu/tdp_iter.c              |   6 +-
 arch/x86/kvm/mmu/tdp_mmu.c               | 540 +++++++++++++++++++----
 arch/x86/kvm/x86.c                       |   4 +-
 drivers/gpu/drm/i915/gvt/kvmgt.c         |  12 +-
 include/asm-generic/qrwlock.h            |  24 +-
 include/linux/kvm_host.h                 |   7 +-
 include/linux/rwlock.h                   |   7 +
 include/linux/sched.h                    |  29 ++
 kernel/sched/core.c                      |  40 ++
 virt/kvm/dirty_ring.c                    |   4 +-
 virt/kvm/kvm_main.c                      |  58 ++-
 38 files changed, 938 insertions(+), 295 deletions(-)

-- 
2.30.0.284.gd98b1dd5eaa7-goog

