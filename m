Return-Path: <kvm+bounces-62470-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id AA1EDC44D4D
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 04:32:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 35B3E4E4CB2
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 03:32:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22D1A2853F8;
	Mon, 10 Nov 2025 03:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dNU6/44b"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9679284881
	for <kvm@vger.kernel.org>; Mon, 10 Nov 2025 03:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762745562; cv=none; b=SknIfSoEomyJQKpIs0RvvrtUAwH+SQwrT/P03/UOnH4aaZE0WK5hfsLA9LwkNzPPqUWWJ5uzxjfcUMYvikD4UC5KjvOzdD/uurb2HXjK3ovqvdwD1Cz0o7/lthqbQi6FYyHmHV9IHF3bPmG5FzZGTPJKmNHTbQvW3JjtSfiebdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762745562; c=relaxed/simple;
	bh=NMZvgzdYGWcZBU+Rx8OWgxX63zQvlHN+qhpwWDWfhn4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=meu0+M67sE/EPu1rQNJjOeiZG3HiMws31QzsEXQDYwYwWBg/ZNo7dpCzW7C6qtsuiK7aVYK3Du76eIDwYS8ddoBigLQw2STRMxcNYV+tkNYQ3YLrNiqxqNfdtHxK2H6/hN68BXg+OPyzUKjcu+Zr8uVcGIVycDLzkinFozG250w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dNU6/44b; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2982237a3b3so2921855ad.2
        for <kvm@vger.kernel.org>; Sun, 09 Nov 2025 19:32:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762745559; x=1763350359; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=h6yp3Sx/NpI4PdO0yLYxgYq2r4P8WCzeoHfAlDu/CgE=;
        b=dNU6/44bKTTA6mVBboFWGZN8iKScErH55T7eZ5gO+YGpWj2sHwyKn6zEGXvRmaHWbb
         CDAJcP9R/pKjbDBrDHjSXNUdIxF3D6Z1UB/9jRCYjVCpiDqrL7LvXmLnL6181N3gaVXv
         nBH4t92TBWs38LNFAA/zuvfKDQurQF5AQJCf/Uo/EQv4jCRn+GPNVVXbO8Yk6fbJ9jhy
         VUanEa9reJCT6ugLxnfZnL5UxeX8oPKFleDasVDfSXKwU/MvvzQOyTtLp9t4T/Ceh8OF
         rBMJLetV/7LbM+ZMwytOha3iyLf9XiqCBn7Ik+6TJyLmhvrARRsGRKQBlbtCPgZoE59s
         H32g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762745559; x=1763350359;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h6yp3Sx/NpI4PdO0yLYxgYq2r4P8WCzeoHfAlDu/CgE=;
        b=L6RgCw5WlNmuHeom3Ag2dkfaYhc/NKafQkNtNXk5qnIwuNK8tpJnk8HpWUwjDcr0tP
         ASlUoeKDAQScEO8s1ZkyRG1UtSv7ExevKbirSCmya+X6ihm/rR8F6SI54vpz4v/G/SLY
         NchkbYUnimaJwf3Glp3tGQU72jYZGCMVMZ6YDnlesgBs5+cszB5FtVGTCKKoikB/A4se
         vk0EYpwFU88JzFZ9F46t0ssNyN6k/osIXYqBlZtbhWkZUOJS0JBJ2Y8q2IF/la69s+d0
         c+v72yPtEJqkfmBbRls4YUzIM4NtRSDqGJzlgARGC0hKncg00ho7ekP3cxqGpsN1fmen
         nKFw==
X-Forwarded-Encrypted: i=1; AJvYcCUu2n2svJaxUJnmuLi0bAo4nV+ArNe7YbSeDJn8IDQWLiQXtxUQlSFEWkD25Wd/sh2Ny/g=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzm1/kTF5BNInhfeg4wCXfDvyMxSTmd3a2I6X7h+Rrq4wmZ8RF6
	d7HCwXvJ32LBCqCX0zPwWQfSHp5BavF4PNMjdVR3ooz7jqbMcuC2HBQ3
X-Gm-Gg: ASbGncuLNTeVSeqgYSfQF4IYJCG8TsHxK35RYohGZeWS4yjAKDS4JFDhNyfQBhY6gVr
	ockBziE+cpGEIJNS3KWFA3CgaH90XfizF+7k/3X2frEBjlpGZ7xR3Wy4QBCHTGoCFkr1jYdWSe0
	0atleXxB+Y5/t/uT75G0MbmMy5kai0kphVjSOzQA0XR9wGjUaIjHetXk5r7S0YJZLkVaWJ9iVBk
	fOj7qBu2d97i2K/yvWDfsZFutJ3Zkh+BqrULtcO5rZIu2AODkfTpEIf0HCIM4uxbyK7AYUT10XK
	Pa+G3ZB6e4N49tTJiMMZZ7VhRMrXCLUcVbYPdhHhk0Nwtguxw9KokyChFtZ5Ia7wHj5TYTLZK7r
	YgznDMaujHmUteito5gfsWhH/HAYhFVBU2wNx+Iio35vQ1a+cwhRM4z5VAX6jafJpz6n7Ob8Vu1
	5F+jAjjvAg
X-Google-Smtp-Source: AGHT+IHqpvEGezBCBBI68J7J9jEM7UVy9LTUzDJlxIp6D+gAbDPih+pK/NVjr3PuUaYiI3+WbIzuQQ==
X-Received: by 2002:a17:903:3848:b0:294:def6:5961 with SMTP id d9443c01a7336-297e56d0868mr88371585ad.45.1762745558830;
        Sun, 09 Nov 2025 19:32:38 -0800 (PST)
Received: from wanpengli.. ([124.93.80.37])
        by smtp.googlemail.com with ESMTPSA id 41be03b00d2f7-ba900fa571esm10913877a12.26.2025.11.09.19.32.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Nov 2025 19:32:38 -0800 (PST)
From: Wanpeng Li <kernellwp@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	Wanpeng Li <wanpengli@tencent.com>
Subject: [PATCH 00/10] sched/kvm: Semantics-aware vCPU scheduling for oversubscribed KVM
Date: Mon, 10 Nov 2025 11:32:21 +0800
Message-ID: <20251110033232.12538-1-kernellwp@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Wanpeng Li <wanpengli@tencent.com>

This series addresses long-standing yield_to() inefficiencies in
virtualized environments through two complementary mechanisms: a vCPU
debooster in the scheduler and IPI-aware directed yield in KVM.

Problem Statement
-----------------

In overcommitted virtualization scenarios, vCPUs frequently spin on locks
held by other vCPUs that are not currently running. The kernel's
paravirtual spinlock support detects these situations and calls yield_to()
to boost the lock holder, allowing it to run and release the lock.

However, the current implementation has two critical limitations:

1. Scheduler-side limitation:

   yield_to_task_fair() relies solely on set_next_buddy() to provide
   preference to the target vCPU. This buddy mechanism only offers
   immediate, transient preference. Once the buddy hint expires (typically
   after one scheduling decision), the yielding vCPU may preempt the target
   again, especially in nested cgroup hierarchies where vruntime domains
   differ.

   This creates a ping-pong effect: the lock holder runs briefly, gets
   preempted before completing critical sections, and the yielding vCPU
   spins again, triggering another futile yield_to() cycle. The overhead
   accumulates rapidly in workloads with high lock contention.

2. KVM-side limitation:

   kvm_vcpu_on_spin() attempts to identify which vCPU to yield to through
   directed yield candidate selection. However, it lacks awareness of IPI
   communication patterns. When a vCPU sends an IPI and spins waiting for
   a response (common in inter-processor synchronization), the current
   heuristics often fail to identify the IPI receiver as the yield target.

   Instead, the code may boost an unrelated vCPU based on coarse-grained
   preemption state, missing opportunities to accelerate actual IPI
   response handling. This is particularly problematic when the IPI receiver
   is runnable but not scheduled, as lock-holder-detection logic doesn't
   capture the IPI dependency relationship.

Combined, these issues cause excessive lock hold times, cache thrashing,
and degraded throughput in overcommitted environments, particularly
affecting workloads with fine-grained synchronization patterns.

Solution Overview
-----------------

The series introduces two orthogonal improvements that work synergistically:

Part 1: Scheduler vCPU Debooster (patches 1-5)

Augment yield_to_task_fair() with bounded vruntime penalties to provide
sustained preference beyond the buddy mechanism. When a vCPU yields to a
target, apply a carefully tuned vruntime penalty to the yielding vCPU,
ensuring the target maintains scheduling advantage for longer periods.

The mechanism is EEVDF-aware and cgroup-hierarchy-aware:

- Locate the lowest common ancestor (LCA) in the cgroup hierarchy where
  both the yielding and target tasks coexist. This ensures vruntime
  adjustments occur at the correct hierarchy level, maintaining fairness
  across cgroup boundaries.

- Update EEVDF scheduler fields (vruntime, deadline, vlag) atomically to
  keep the scheduler state consistent. The penalty shifts the yielding
  task's virtual deadline forward, allowing the target to run.

- Apply queue-size-adaptive penalties that scale from 6.0× scheduling
  granularity for 2-task scenarios (strong preference) down to 1.0× for
  large queues (>12 tasks), balancing preference against starvation risks.

- Implement reverse-pair debouncing: when task A yields to B, then B yields
  to A within a short window (~600us), downscale the penalty to prevent
  ping-pong oscillation.

- Rate-limit penalty application to 6ms intervals to prevent pathological
  overhead when yields occur at very high frequency.

The debooster works *with* the buddy mechanism rather than replacing it:
set_next_buddy() provides immediate preference for the next scheduling
decision, while the vruntime penalty sustains that preference over
subsequent decisions. This dual approach proves especially effective in
nested cgroup scenarios where buddy hints alone are insufficient.

Part 2: KVM IPI-Aware Directed Yield (patches 6-10)

Enhance kvm_vcpu_on_spin() with lightweight IPI tracking to improve
directed yield candidate selection. Track sender/receiver relationships
when IPIs are delivered and use this information to prioritize yield
targets.

The tracking mechanism:

- Hooks into kvm_irq_delivery_to_apic() to detect unicast fixed IPIs (the
  common case for inter-processor synchronization). When exactly one
  destination vCPU receives an IPI, record the sender→receiver relationship
  with a monotonic timestamp.

  In high VM density scenarios, software-based IPI tracking through interrupt
  delivery interception becomes particularly valuable. It captures precise
  sender/receiver relationships that can be leveraged for intelligent
  scheduling decisions, providing performance benefits that complement or
  even exceed hardware-accelerated interrupt delivery in overcommitted
  environments.

- Uses lockless READ_ONCE/WRITE_ONCE accessors for minimal overhead. The
  per-vCPU ipi_context structure is carefully designed to avoid cache line
  bouncing.

- Implements a short recency window (50ms default) to avoid stale IPI
  information inflating boost priority on throughput-sensitive workloads.
  Old IPI relationships are naturally aged out.

- Clears IPI context on EOI with two-stage precision: unconditionally clear
  the receiver's context (it processed the interrupt), but only clear the
  sender's pending flag if the receiver matches and the IPI is recent. This
  prevents unrelated EOIs from prematurely clearing valid IPI state.

The candidate selection follows a priority hierarchy:

  Priority 1: Confirmed IPI receiver
    If the spinning vCPU recently sent an IPI to another vCPU and that IPI
    is still pending (within the recency window), unconditionally boost the
    receiver. This directly addresses the "spinning on IPI response" case.

  Priority 2: Fast pending interrupt
    Leverage arch-specific kvm_arch_dy_has_pending_interrupt() for
    compatibility with existing optimizations.

  Priority 3: Preempted in kernel mode
    Fall back to traditional preemption-based logic when yield_to_kernel_mode
    is requested, ensuring compatibility with existing workloads.

A two-round fallback mechanism provides a safety net: if the first round
with strict IPI-aware selection finds no eligible candidate (e.g., due to
missed IPI context or transient runnable set changes), a second round
applies relaxed selection gated only by preemption state. This is
controlled by the enable_relaxed_boost module parameter (default on).

Implementation Details
----------------------

Both mechanisms are designed for minimal overhead and runtime control:

- All locking occurs under existing rq->lock or per-vCPU locks; no new
  lock contention is introduced.

- Penalty calculations use integer arithmetic with overflow protection.

- IPI tracking uses monotonic timestamps (ktime_get_mono_fast_ns()) for
  efficient, race-free recency checks.

Advantages over paravirtualization approaches:

- No guest OS modification required: This solution operates entirely within
  the host kernel, providing transparent optimization without guest kernel
  changes or recompilation.

- Guest OS agnostic: Works uniformly across Linux, Windows, and other guest
  operating systems, unlike PV TLB shootdown which requires guest-side
  paravirtual driver support.

- Broader applicability: Captures IPI patterns from all synchronization
  primitives (spinlocks, RCU, smp_call_function, etc.), not limited to
  specific paravirtualized operations like TLB shootdown.

- Deployment simplicity: Existing VM images benefit immediately without
  guest kernel updates, critical for production environments with diverse
  guest OS versions and configurations.

- Runtime controls allow disabling features if needed:
  * /sys/kernel/debug/sched/sched_vcpu_debooster_enabled
  * /sys/module/kvm/parameters/ipi_tracking_enabled
  * /sys/module/kvm/parameters/enable_relaxed_boost

- The infrastructure is incrementally introduced: early patches add inert
  scaffolding that can be verified for zero performance impact before
  activation.

Performance Results
-------------------

Test environment: Intel Xeon, 16 physical cores, 16 vCPUs per VM

Dbench 16 clients per VM (filesystem metadata operations):
  2 VMs: +14.4% throughput (lock contention reduction)
  3 VMs:  +9.8% throughput
  4 VMs:  +6.7% throughput

PARSEC Dedup benchmark, simlarge input (memory-intensive):
  2 VMs: +47.1% throughput (IPI-heavy synchronization)
  3 VMs: +28.1% throughput
  4 VMs:  +1.7% throughput

PARSEC VIPS benchmark, simlarge input (compute-intensive):
  2 VMs: +26.2% throughput (balanced sync and compute)
  3 VMs: +12.7% throughput
  4 VMs:  +6.0% throughput

Analysis:

- Gains are most pronounced at moderate overcommit (2-3 VMs). At this level,
  contention is significant enough to benefit from better yield behavior,
  but context switch overhead remains manageable.

- Dedup shows the strongest improvement (+47.1% at 2 VMs) due to its
  IPI-heavy synchronization patterns. The IPI-aware directed yield
  precisely targets the bottleneck.

- At 4 VMs (heavier overcommit), gains diminish as general CPU contention
  dominates. However, performance never regresses, indicating the mechanisms
  gracefully degrade.

- In certain high-density, resource overcommitted deployment scenarios, the 
  performance benefits of APICv can be constrained by scheduling and contention 
  patterns. In such cases, software-based IPI tracking serves as a complementary 
  optimization path, offering targeted scheduling hints without relying on disabling 
  APICv. The practical choice should be evaluated and balanced against workload 
  characteristics and platform configuration.

- Dbench benefits primarily from the scheduler-side debooster, as its lock
  patterns involve less IPI spinning and more direct lock holder boosting.

The performance gains stem from three factors:

1. Lock holders receive sustained CPU time to complete critical sections,
   reducing overall lock hold duration and cascading contention.

2. IPI receivers are promptly scheduled when senders spin, minimizing IPI
   response latency and reducing wasted spin cycles.

3. Better cache utilization results from reduced context switching between
   lock waiters and holders.

Patch Organization
------------------

The series is organized for incremental review and bisectability:

Patches 1-5: Scheduler vCPU debooster

  Patch 1: Add infrastructure (per-rq tracking, sysctl, debugfs entry)
           Infrastructure is inert; no functional change.

  Patch 2: Add rate-limiting and validation helpers
           Static functions with comprehensive safety checks.

  Patch 3: Add cgroup LCA finder for hierarchical yield
           Implements CONFIG_FAIR_GROUP_SCHED-aware LCA location.

  Patch 4: Add penalty calculation and application logic
           Core algorithms with queue-size adaptation and debouncing.

  Patch 5: Wire up yield deboost in yield_to_task_fair()
           Activation patch. Includes Dbench performance data.

Patches 6-10: KVM IPI-aware directed yield

  Patch 6: Fix last_boosted_vcpu index assignment bug
           Standalone bugfix for existing code.

  Patch 7: Add IPI tracking infrastructure
           Per-vCPU context, module parameters, helper functions.
           Infrastructure is inert until activated.

  Patch 8: Integrate IPI tracking with LAPIC interrupt delivery
           Hook into kvm_irq_delivery_to_apic() and EOI handling.

  Patch 9: Implement IPI-aware directed yield candidate selection
           Replace candidate selection logic with priority-based approach.
           Includes PARSEC performance data.

  Patch 10: Add relaxed boost as safety net
            Two-round fallback mechanism for robustness.

Each patch compiles and boots independently. Performance data is presented
where the relevant mechanism becomes active (patches 5 and 9).

Testing
-------

Workloads tested:

- Dbench (filesystem metadata stress)
- PARSEC benchmarks (Dedup, VIPS, Ferret, Blackscholes)
- Kernel compilation (make -j16 in each VM)

No regressions observed on any configuration. The mechanisms show neutral
to positive impact across diverse workloads.

Future Work
-----------

Potential extensions beyond this series:

- Adaptive recency window: dynamically adjust ipi_window_ns based on
  observed workload patterns.

- Extended tracking: consider multi-round IPI patterns (A→B→C→A).

- Cross-NUMA awareness: penalty scaling based on NUMA distances.

These are intentionally deferred to keep this series focused and reviewable.

Wanpeng Li (10):
  sched: Add vCPU debooster infrastructure
  sched/fair: Add rate-limiting and validation helpers
  sched/fair: Add cgroup LCA finder for hierarchical yield
  sched/fair: Add penalty calculation and application logic
  sched/fair: Wire up yield deboost in yield_to_task_fair()
  KVM: Fix last_boosted_vcpu index assignment bug
  KVM: x86: Add IPI tracking infrastructure
  KVM: x86/lapic: Integrate IPI tracking with interrupt delivery
  KVM: Implement IPI-aware directed yield candidate selection
  KVM: Relaxed boost as safety net

 arch/x86/include/asm/kvm_host.h |   8 +
 arch/x86/kvm/lapic.c            | 172 +++++++++++++++-
 arch/x86/kvm/x86.c              |   6 +
 arch/x86/kvm/x86.h              |   4 +
 include/linux/kvm_host.h        |   1 +
 kernel/sched/core.c             |   7 +-
 kernel/sched/debug.c            |   3 +
 kernel/sched/fair.c             | 336 ++++++++++++++++++++++++++++++++
 kernel/sched/sched.h            |   9 +
 virt/kvm/kvm_main.c             |  81 +++++++-
 10 files changed, 611 insertions(+), 16 deletions(-)

-- 
2.43.0


