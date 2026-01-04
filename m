Return-Path: <kvm+bounces-66975-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 658B9CF08DF
	for <lists+kvm@lfdr.de>; Sun, 04 Jan 2026 03:41:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C9B663011412
	for <lists+kvm@lfdr.de>; Sun,  4 Jan 2026 02:41:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD34C29E0E1;
	Sun,  4 Jan 2026 02:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="S9NK3Q0q"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f48.google.com (mail-oo1-f48.google.com [209.85.161.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC7941F4168
	for <kvm@vger.kernel.org>; Sun,  4 Jan 2026 02:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767494459; cv=none; b=OHeUt3Sl6svwJD6qbanzz7U3v4QHVVKj/LaX/Fqdnyy0WkBT5J+t0GG1IF/rIBMLhj5BENTa0og1llX4XW6LbGIEbPkFkIIpm7GLzLOioBpCZwAZUxZAMIXrjyDb8O9qdWOo66is3jOCJy7dX72esjuh9iERPvF5m6Gk9mJaMZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767494459; c=relaxed/simple;
	bh=0DY11Pa8UCbxtBiOMZa0wo+r80KnAHmVvvt00rJaPLY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=K3ly/BsUNlSjN0z74tHzyWfW8oalIYXMicjtf/uMn8MlAYdQztRLahK2ECdlEr64PCXmdHC84+iiaX7vBszl6pxDqMcGfjBxpBeNvCk0vqaKRTksUgBuqJX7r/U+GGvKv0vC0+7pU4i+mkOvK3RVIQWOWCkaR6vk/hI1S6HzwOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=S9NK3Q0q; arc=none smtp.client-ip=209.85.161.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oo1-f48.google.com with SMTP id 006d021491bc7-65cff0c342eso9025386eaf.3
        for <kvm@vger.kernel.org>; Sat, 03 Jan 2026 18:40:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767494456; x=1768099256; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=SDYQjm1ipYckRZEFD3bu9CqwdZtgfB4aM3bs90ZYiSI=;
        b=S9NK3Q0qmokkqBEM8PKvi6ycBABrcTBUacf7oWR0vn48nZMMKj/YVM6962Iy/QkKv1
         P/YdZSGAU87AYxoVnbRRD1YpNRCaxBnWguguX/MRpksGcoRYlMHMxLcjDhSYu0oupDsO
         mDiwIgOQy9IKFgvDy4jB95cNrdu/9VOdDwkHnrhH2yVgBAKc6ZzlDKqghCsMdgjHGYve
         m0ol9obLVyHGClDriRKIWWjN0n3xVAqV5RtNnvva1MaQO3gd1Qdg5NNeP01MtVyUfIgH
         jJHiMGrHz3KhzAmqg9FwqE7X4eTmtmrJ6o4uX3lVgIm4BpRYkJzANI68R7NDHr9g4whA
         ArNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767494456; x=1768099256;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SDYQjm1ipYckRZEFD3bu9CqwdZtgfB4aM3bs90ZYiSI=;
        b=L9qJL1DvvL+lg0OGXaNhoUL89SDO9gJILUimkDCCVh/UsYogIFeQ4gCJfh/EC0jV1K
         VGO9zx3LBQGdWSX23SCBcLYyTOQXQKjlUyXFF2p4nVXIwoGzFnwIvUBsMGEhQyiZQSfu
         Y7cpv2+tg4xP4Mf7WX2OcWj0v+LHc0Gd51idd83ojMY0WLFtgkYdvHakhI0VWMerjluF
         oUsHRLVD8hH/TTTa9EIbSV09M2QHAKoT0Ou5+hQZ56dOtJ3GY08pcIFmzhIcI7enSe3d
         uUgJ30jfHHFtvr3xSuPIMLW7JmL4OYQ/FcWBn7luMy1oL9glDSnXquYUcW7tLRBOznvj
         pykA==
X-Forwarded-Encrypted: i=1; AJvYcCUTyI8mCYEvvE0tv8ULLtFo1upOLQdigpx9cuQdqgimzFRUIWEVn7AUU/cwAfpqIsrsjgU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxLdaFvwYYHhbONTRo3PwLBZfrvL43Itt/x4ZN9LvvlBTtrFJfv
	SFvSGx8po32yqAmpVL590sOSahAkHrcDyMNkR2dwjFxvsuvO6k8cIHoIk4jTmVblLb3I5jD/2bQ
	TdWaF+as3Iw76WDkzC6g8GwSSKvBYpXE=
X-Gm-Gg: AY/fxX7Fsv2Ye4b007oAFWHgPDaeBL/XJvXvVAC18hABq0eindxE9M/p00B+mqsKWde
	CiWvtgG7swVSKDpcLTjf50ls6SSRisQRn3wjrkC+S4XQIqAo5AwEEAoev3oKd9CsN4VwE+uuWCY
	VSWidhXJj48Sp4PiCdUCFNG7z+//OgaxZf9qM6Zx20l3Wrq1rakX47t4kn4sm+WI9QtXs4nGWKm
	btOKQqQJzrQHsewXn7m3oqAfQeWDEb/vM3Qybcf2oRfTYsWDMOhmOWp5AX/76SQ+yN+e6A6
X-Google-Smtp-Source: AGHT+IHtfyefaFr9mXfJWaiSAAPpi9TycB8UQdjtn8ivVnUqJo67uIRANBoRAcqmXLieK6vbFSn6Vcr4QEXygvXZQeI=
X-Received: by 2002:a4a:c211:0:b0:65e:a61c:2480 with SMTP id
 006d021491bc7-65ea61c25d3mr10786374eaf.77.1767494456419; Sat, 03 Jan 2026
 18:40:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251219035334.39790-1-kernellwp@gmail.com>
In-Reply-To: <20251219035334.39790-1-kernellwp@gmail.com>
From: Wanpeng Li <kernellwp@gmail.com>
Date: Sun, 4 Jan 2026 10:40:30 +0800
X-Gm-Features: AQt7F2pD9KXiZru0xV-Qai0BgSTgnNdc54BV-GY2LhaZq402lF6mis48RTePFUs
Message-ID: <CANRm+CwNS99ORAdQvrCg4rFs3TtKBR6TjEJnScdxy3uP+DRiOw@mail.gmail.com>
Subject: Re: [PATCH v2 0/9] sched/kvm: Semantics-aware vCPU scheduling for
 oversubscribed KVM
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>
Cc: K Prateek Nayak <kprateek.nayak@amd.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Juri Lelli <juri.lelli@redhat.com>, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Wanpeng Li <wanpengli@tencent.com>
Content-Type: text/plain; charset="UTF-8"

ping, :)
On Fri, 19 Dec 2025 at 11:53, Wanpeng Li <kernellwp@gmail.com> wrote:
>
> From: Wanpeng Li <wanpengli@tencent.com>
>
> This series addresses long-standing yield_to() inefficiencies in
> virtualized environments through two complementary mechanisms: a vCPU
> debooster in the scheduler and IPI-aware directed yield in KVM.
>
> Problem Statement
> -----------------
>
> In overcommitted virtualization scenarios, vCPUs frequently spin on locks
> held by other vCPUs that are not currently running. The kernel's
> paravirtual spinlock support detects these situations and calls yield_to()
> to boost the lock holder, allowing it to run and release the lock.
>
> However, the current implementation has two critical limitations:
>
> 1. Scheduler-side limitation:
>
>    yield_to_task_fair() relies solely on set_next_buddy() to provide
>    preference to the target vCPU. This buddy mechanism only offers
>    immediate, transient preference. Once the buddy hint expires (typically
>    after one scheduling decision), the yielding vCPU may preempt the target
>    again, especially in nested cgroup hierarchies where vruntime domains
>    differ.
>
>    This creates a ping-pong effect: the lock holder runs briefly, gets
>    preempted before completing critical sections, and the yielding vCPU
>    spins again, triggering another futile yield_to() cycle. The overhead
>    accumulates rapidly in workloads with high lock contention.
>
> 2. KVM-side limitation:
>
>    kvm_vcpu_on_spin() attempts to identify which vCPU to yield to through
>    directed yield candidate selection. However, it lacks awareness of IPI
>    communication patterns. When a vCPU sends an IPI and spins waiting for
>    a response (common in inter-processor synchronization), the current
>    heuristics often fail to identify the IPI receiver as the yield target.
>
>    Instead, the code may boost an unrelated vCPU based on coarse-grained
>    preemption state, missing opportunities to accelerate actual IPI
>    response handling. This is particularly problematic when the IPI
>    receiver is runnable but not scheduled, as lock-holder-detection logic
>    doesn't capture the IPI dependency relationship.
>
> Combined, these issues cause excessive lock hold times, cache thrashing,
> and degraded throughput in overcommitted environments, particularly
> affecting workloads with fine-grained synchronization patterns.
>
> Solution Overview
> -----------------
>
> The series introduces two orthogonal improvements that work synergistically:
>
> Part 1: Scheduler vCPU Debooster (patches 1-5)
>
> Augment yield_to_task_fair() with bounded vruntime penalties to provide
> sustained preference beyond the buddy mechanism. When a vCPU yields to a
> target, apply a carefully tuned vruntime penalty to the yielding vCPU,
> ensuring the target maintains scheduling advantage for longer periods.
>
> The mechanism is EEVDF-aware and cgroup-hierarchy-aware:
>
> - Locate the lowest common ancestor (LCA) in the cgroup hierarchy where
>   both the yielding and target tasks coexist. This ensures vruntime
>   adjustments occur at the correct hierarchy level, maintaining fairness
>   across cgroup boundaries.
>
> - Update EEVDF scheduler fields (vruntime, deadline) atomically to keep
>   the scheduler state consistent. Note that vlag is intentionally not
>   modified as it will be recalculated on dequeue/enqueue cycles. The
>   penalty shifts the yielding task's virtual deadline forward, allowing
>   the target to run.
>
> - Apply queue-size-adaptive penalties that scale from 6.0x scheduling
>   granularity for 2-task scenarios (strong preference) down to 1.0x for
>   large queues (>12 tasks), balancing preference against starvation risks.
>
> - Implement reverse-pair debouncing: when task A yields to B, then B yields
>   to A within a short window (~600us), downscale the penalty to prevent
>   ping-pong oscillation.
>
> - Rate-limit penalty application to 6ms intervals to prevent pathological
>   overhead when yields occur at very high frequency.
>
> The debooster works *with* the buddy mechanism rather than replacing it:
> set_next_buddy() provides immediate preference for the next scheduling
> decision, while the vruntime penalty sustains that preference over
> subsequent decisions. This dual approach proves especially effective in
> nested cgroup scenarios where buddy hints alone are insufficient.
>
> Part 2: KVM IPI-Aware Directed Yield (patches 6-9)
>
> Enhance kvm_vcpu_on_spin() with lightweight IPI tracking to improve
> directed yield candidate selection. Track sender/receiver relationships
> when IPIs are delivered and use this information to prioritize yield
> targets.
>
> The tracking mechanism:
>
> - Hooks into kvm_irq_delivery_to_apic() to detect unicast fixed IPIs (the
>   common case for inter-processor synchronization). When exactly one
>   destination vCPU receives an IPI, record the sender->receiver relationship
>   with a monotonic timestamp.
>
>   In high VM density scenarios, software-based IPI tracking through
>   interrupt delivery interception becomes particularly valuable. It
>   captures precise sender/receiver relationships that can be leveraged
>   for intelligent scheduling decisions, providing performance benefits
>   that complement or even exceed hardware-accelerated interrupt delivery
>   in overcommitted environments.
>
> - Uses lockless READ_ONCE/WRITE_ONCE accessors for minimal overhead. The
>   per-vCPU ipi_context structure is carefully designed to avoid cache line
>   bouncing.
>
> - Implements a short recency window (50ms default) to avoid stale IPI
>   information inflating boost priority on throughput-sensitive workloads.
>   Old IPI relationships are naturally aged out.
>
> - Clears IPI context on EOI with two-stage precision: unconditionally clear
>   the receiver's context (it processed the interrupt), but only clear the
>   sender's pending flag if the receiver matches and the IPI is recent. This
>   prevents unrelated EOIs from prematurely clearing valid IPI state.
>
> The candidate selection follows a priority hierarchy:
>
>   Priority 1: Confirmed IPI receiver
>     If the spinning vCPU recently sent an IPI to another vCPU and that IPI
>     is still pending (within the recency window), unconditionally boost the
>     receiver. This directly addresses the "spinning on IPI response" case.
>
>   Priority 2: Fast pending interrupt
>     Leverage arch-specific kvm_arch_dy_has_pending_interrupt() for
>     compatibility with existing optimizations.
>
>   Priority 3: Preempted in kernel mode
>     Fall back to traditional preemption-based logic when yield_to_kernel_mode
>     is requested, ensuring compatibility with existing workloads.
>
> A two-round fallback mechanism provides a safety net: if the first round
> with strict IPI-aware selection finds no eligible candidate (e.g., due to
> missed IPI context or transient runnable set changes), a second round
> applies relaxed selection gated only by preemption state. This is
> controlled by the enable_relaxed_boost module parameter (default on).
>
> Implementation Details
> ----------------------
>
> Both mechanisms are designed for minimal overhead and runtime control:
>
> - All locking occurs under existing rq->lock or per-vCPU locks; no new
>   lock contention is introduced.
>
> - Penalty calculations use integer arithmetic with overflow protection.
>
> - IPI tracking uses monotonic timestamps (ktime_get_mono_fast_ns()) for
>   efficient, race-free recency checks.
>
> Advantages over paravirtualization approaches:
>
> - No guest OS modification required: This solution operates entirely within
>   the host kernel, providing transparent optimization without guest kernel
>   changes or recompilation.
>
> - Guest OS agnostic: Works uniformly across Linux, Windows, and other guest
>   operating systems, unlike PV TLB shootdown which requires guest-side
>   paravirtual driver support.
>
> - Broader applicability: Captures IPI patterns from all synchronization
>   primitives (spinlocks, RCU, smp_call_function, etc.), not limited to
>   specific paravirtualized operations like TLB shootdown.
>
> - Deployment simplicity: Existing VM images benefit immediately without
>   guest kernel updates, critical for production environments with diverse
>   guest OS versions and configurations.
>
> - Runtime controls allow disabling features if needed:
>   * /sys/kernel/debug/sched/vcpu_debooster_enabled
>   * /sys/module/kvm/parameters/ipi_tracking_enabled
>   * /sys/module/kvm/parameters/enable_relaxed_boost
>
> - The infrastructure is incrementally introduced: early patches add inert
>   scaffolding that can be verified for zero performance impact before
>   activation.
>
> Performance Results
> -------------------
>
> Test environment: Intel Xeon, 16 physical cores, 16 vCPUs per VM
>
> Dbench 16 clients per VM (filesystem metadata operations):
>   2 VMs: +14.4% throughput (lock contention reduction)
>   3 VMs:  +9.8% throughput
>   4 VMs:  +6.7% throughput
>
> PARSEC Dedup benchmark, simlarge input (memory-intensive):
>   2 VMs: +47.1% throughput (IPI-heavy synchronization)
>   3 VMs: +28.1% throughput
>   4 VMs:  +1.7% throughput
>
> PARSEC VIPS benchmark, simlarge input (compute-intensive):
>   2 VMs: +26.2% throughput (balanced sync and compute)
>   3 VMs: +12.7% throughput
>   4 VMs:  +6.0% throughput
>
> Analysis:
>
> - Gains are most pronounced at moderate overcommit (2-3 VMs). At this level,
>   contention is significant enough to benefit from better yield behavior,
>   but context switch overhead remains manageable.
>
> - Dedup shows the strongest improvement (+47.1% at 2 VMs) due to its
>   IPI-heavy synchronization patterns. The IPI-aware directed yield
>   precisely targets the bottleneck.
>
> - At 4 VMs (heavier overcommit), gains diminish as general CPU contention
>   dominates. However, performance never regresses, indicating the mechanisms
>   gracefully degrade.
>
> - In certain high-density, resource overcommitted deployment scenarios, the
>   performance benefits of APICv can be constrained by scheduling and
>   contention patterns. In such cases, software-based IPI tracking serves as
>   a complementary optimization path, offering targeted scheduling hints
>   without relying on disabling APICv. The practical choice should be
>   evaluated and balanced against workload characteristics and platform
>   configuration.
>
> - Dbench benefits primarily from the scheduler-side debooster, as its lock
>   patterns involve less IPI spinning and more direct lock holder boosting.
>
> The performance gains stem from three factors:
>
> 1. Lock holders receive sustained CPU time to complete critical sections,
>    reducing overall lock hold duration and cascading contention.
>
> 2. IPI receivers are promptly scheduled when senders spin, minimizing IPI
>    response latency and reducing wasted spin cycles.
>
> 3. Better cache utilization results from reduced context switching between
>    lock waiters and holders.
>
> Patch Organization
> ------------------
>
> The series is organized for incremental review and bisectability:
>
> Patches 1-5: Scheduler vCPU debooster
>
>   Patch 1: Add infrastructure (per-rq tracking, sysctl, debugfs entry)
>            Infrastructure is inert; no functional change.
>
>   Patch 2: Add rate-limiting and validation helpers
>            Static functions with comprehensive safety checks.
>
>   Patch 3: Add cgroup LCA finder for hierarchical yield
>            Implements CONFIG_FAIR_GROUP_SCHED-aware LCA location.
>
>   Patch 4: Add penalty calculation and application logic
>            Core algorithms with queue-size adaptation and debouncing.
>
>   Patch 5: Wire up yield deboost in yield_to_task_fair()
>            Activation patch. Includes Dbench performance data.
>
> Patches 6-9: KVM IPI-aware directed yield
>
>   Patch 6: Add IPI tracking infrastructure
>            Per-vCPU context, module parameters, helper functions.
>            Infrastructure is inert until activated.
>
>   Patch 7: Integrate IPI tracking with LAPIC interrupt delivery
>            Hook into kvm_irq_delivery_to_apic() and EOI handling.
>
>   Patch 8: Implement IPI-aware directed yield candidate selection
>            Replace candidate selection logic with priority-based approach.
>            Includes PARSEC performance data.
>
>   Patch 9: Add relaxed boost as safety net
>            Two-round fallback mechanism for robustness.
>
> Each patch compiles and boots independently. Performance data is presented
> where the relevant mechanism becomes active (patches 5 and 8).
>
> Testing
> -------
>
> Workloads tested:
>
> - Dbench (filesystem metadata stress)
> - PARSEC benchmarks (Dedup, VIPS, Ferret, Blackscholes)
> - Kernel compilation (make -j16 in each VM)
>
> No regressions observed on any configuration. The mechanisms show neutral
> to positive impact across diverse workloads.
>
> Future Work
> -----------
>
> Potential extensions beyond this series:
>
> - Adaptive recency window: dynamically adjust ipi_window_ns based on
>   observed workload patterns.
>
> - Extended tracking: consider multi-round IPI patterns (A->B->C->A).
>
> - Cross-NUMA awareness: penalty scaling based on NUMA distances.
>
> These are intentionally deferred to keep this series focused and reviewable.
>
> v1 -> v2:
> - Rebase onto v6.19-rc1 (v1 was based on v6.18-rc4)
> - Drop "KVM: Fix last_boosted_vcpu index assignment bug" patch as v6.19-rc1
>   already contains this fix
> - Scheduler debooster changes:
>   * Adapt to v6.19's EEVDF forfeit behavior: yield_to_deboost() must be
>     called BEFORE yield_task_fair() to preserve fairness gap calculation.
>     In v6.19+, yield_task_fair() performs forfeit (se->vruntime =
>     se->deadline), which would inflate the yielding entity's vruntime
>     before penalty calculation, causing need=0 and only baseline penalty
>     being applied.
>   * Change from rq->curr to rq->donor for correct EEVDF donor tracking
>   * Change from nr_queued to h_nr_queued for accurate hierarchical task
>     counting in penalty cap calculation
>   * Remove vlag assignment as it will be recalculated on dequeue/enqueue
>     and modifying it for on-rq entity is incorrect
>   * Remove update_min_vruntime() call: in EEVDF the yielding entity is
>     always cfs_rq->curr (dequeued from RB-tree), so modifying its vruntime
>     does not affect min_vruntime calculation
>   * Remove unnecessary gran_floor safeguard (calc_delta_fair already
>     handles edge cases correctly)
>   * Rename debugfs entry from sched_vcpu_debooster_enabled to
>     vcpu_debooster_enabled for consistency
> - KVM IPI tracking changes:
>   * Improve documentation for module parameters
>   * Add kvm_vcpu_is_ipi_receiver() declaration to x86.h header
>
> Wanpeng Li (9):
>   sched: Add vCPU debooster infrastructure
>   sched/fair: Add rate-limiting and validation helpers
>   sched/fair: Add cgroup LCA finder for hierarchical yield
>   sched/fair: Add penalty calculation and application logic
>   sched/fair: Wire up yield deboost in yield_to_task_fair()
>   KVM: x86: Add IPI tracking infrastructure
>   KVM: x86/lapic: Integrate IPI tracking with interrupt delivery
>   KVM: Implement IPI-aware directed yield candidate selection
>   KVM: Relaxed boost as safety net
>
>  arch/x86/include/asm/kvm_host.h |  12 ++
>  arch/x86/kvm/lapic.c            | 166 ++++++++++++++++-
>  arch/x86/kvm/x86.c              |   3 +
>  arch/x86/kvm/x86.h              |   8 +
>  include/linux/kvm_host.h        |   3 +
>  kernel/sched/core.c             |   9 +-
>  kernel/sched/debug.c            |   2 +
>  kernel/sched/fair.c             | 305 ++++++++++++++++++++++++++++++++
>  kernel/sched/sched.h            |  12 ++
>  virt/kvm/kvm_main.c             |  74 +++++++-
>  10 files changed, 579 insertions(+), 15 deletions(-)
>
> --
> 2.43.0
>

