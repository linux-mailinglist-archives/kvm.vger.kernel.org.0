Return-Path: <kvm+bounces-7087-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F2CA083D648
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 10:29:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E6CBE1C26CCD
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 09:29:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB03322625;
	Fri, 26 Jan 2024 08:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="P2SgqGur"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0BE11D548;
	Fri, 26 Jan 2024 08:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706259337; cv=none; b=lhq0E+E43eCOUWi2EsPmdf0dfga832B7BgT60Qhtf2f6pkoFrDyoIi6ydyHpJXqeHfoPAsx6L6NfCrlWyg6bUws9lwD+T3a82NI3unsQixBf8aEhNOuvE8VkGIBhpXc9+86/CIadVbE0DqHC8Qk/z9+wGJXRaT0DJVUH/M1miXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706259337; c=relaxed/simple;
	bh=lCUAogsNGKA1YUn7ZM4RKSghB5CV86gvsrghACp6bz0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=M2N246Pi6Eiy4Tq5rAU+hC3jRFXObLTUmAqHeZ+PXpzqrX84eQ+OYnoFvd59hMVaZUY5v14bHiAR8FiTG5QbD3VohRGVS5F2/JP996FlxNtQai+Tsp7CllG6WHl784fFlY3RuCOmdg13Vj8brMRdnS6Wu9UCAVWmJCao8ZlWiS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=P2SgqGur; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706259335; x=1737795335;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=lCUAogsNGKA1YUn7ZM4RKSghB5CV86gvsrghACp6bz0=;
  b=P2SgqGuriKN2CGNemx0XWn1Xo7GQxVQhIssRRxpq0K4ZHDfm8RZahLWM
   UGgWcT6RJCP8CA55yqYXNM6AlP6Uz3EV8JDm5btclarejKl2DPw4PyTDU
   M3ELluNKmdKT7XDffVGCxV73QAOiOrUjlQcp6YGfvgD+tPh72crzgXtJK
   BJMSqbwrJtP6EEBncvRGuat3Ey2D/DTRSoAfcbsCsH1Rzu2yPOWo0FSwT
   ah7ZP/3sdGfu7gJOMBED8cXrUZPD++xdot2RJ73NB4bqKQWAmVl+wwy6m
   K2dm/H2BeYTrkGhJadQ+6BrFsOB1WT8VnQ7NTJ9nh0kxIMySLnZFJZ24F
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="9792016"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="9792016"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 00:55:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="930309756"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="930309756"
Received: from yanli3-mobl.ccr.corp.intel.com (HELO xiongzha-desk1.ccr.corp.intel.com) ([10.254.213.178])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 00:55:28 -0800
From: Xiong Zhang <xiong.y.zhang@linux.intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	peterz@infradead.org,
	mizhang@google.com,
	kan.liang@intel.com,
	zhenyuw@linux.intel.com,
	dapeng1.mi@linux.intel.com,
	jmattson@google.com
Cc: kvm@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhiyuan.lv@intel.com,
	eranian@google.com,
	irogers@google.com,
	samantha.alt@intel.com,
	like.xu.linux@gmail.com,
	chao.gao@intel.com,
	xiong.y.zhang@linux.intel.com
Subject: [RFC PATCH 00/41] KVM: x86/pmu: Introduce passthrough vPM
Date: Fri, 26 Jan 2024 16:54:03 +0800
Message-Id: <20240126085444.324918-1-xiong.y.zhang@linux.intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Background
===
KVM has supported vPMU for years as the emulated vPMU. In particular, KVM
presents a virtual PMU to guest where accesses to PMU get trapped and
converted into perf events. These perf events get scheduled along with
other perf events at the host level, sharing the HW resource. In the
emulated vPMU design, KVM is a client of the perf subsystem and has no
control of the HW PMU resource at host level.

This emulated vPMU has these drawbacks:
1. Poor performance, guest PMU MSR accessing has VM-exit and some has
expensive host perf API call. Once guest PMU is multiplexing its
counters, KVM will waste majority of time re-creating/starting/releasing
KVM perf events, then the guest perf performance is dropped dramatically.
2. Guest perf events's backend may be swapped out or disabled silently.
This is because host perf scheduler treats KVM perf events and other host
perf events equally, they will contend HW resources. KVM perf events will
be inactive when all HW resources have been owned by host perf events.
But KVM can not notify this backend error into guest, this slient error
is a red flag for vPMU as a production.
3. Hard to add new vPMU features. For each vPMU new feature, KVM needs
to emulate new MSRs, this involves perf and kvm two subsystems, mostly
the vendor specific perf API is added and is hard to accept.

The community has discussed these drawbacks for years and reconsidered
current emulated vPMU [1]. In latest discussion [2], both Perf and KVM
x86 community agreed to try a passthrough vPMU. So we co-work with google
engineers to develop this RFC, currently we implement it on Intel CPU
only, and can add other arch's implementation later.
Complete RFC source code can be found in below link:
https://github.com/googleprodkernel/linux-kvm/tree/passthrough-pmu-rfc

Under passthrough vPMU, VM direct access to all HW PMU general purpose
counters and some of the fixed counters, VM has transparency of x86 PMU
HW. All host perf events using x86 PMU are stopped during VM running, and
are restarted at VM-exit. This has the following benefits:
1. Better performance, when guest access x86 PMU MSRs and rdpmc, no VM-exit
and no host perf API call.
2. Guest perf events exclusively own HW resource during guest running. Host
perf events are stopped and give up HW resource at VM-entry, and restart 
runnging after VM-exit.
3. Easier to enable PMU new features. KVM just needs to passthrough new
MSRs and save/restore them at VM-exit and VM-entry, no need to add
perf API.

Note, passthrough vPMU does satisfy the enterprise-level requirement of
secure usage for PMU by intercepting guest access to all event selectors.
But the key problem of passthrough vPMU is that host user loses the
capability to profile guest. If any users want to profile guest from the
host, they should not enable passthrough vPMU mode. Another problem is
the NMI watchdog is not fully functional anymore. Please see design opens
for more details.

Implementation
===
To passthrough host x86 PMU into guest, PMU context switch is mandatory,
this RFC implements this PMU context switch at VM-entry/exit boundary.

At VM-entry:
1. KVM call perf supplied perf_guest_enter() interface, perf stops all
the perf events which use host x86 PMU.
2. KVM call perf supplied perf_guest_switch_to_kvm_pmi_vector() interface,
perf switch PMI vector to a separate kvm_pmi_vector, so that KVM handles
PMI after this point and KVM injects HW PMI into guest.
3. KVM restores guest PMU context.

In order to support KVM PMU filter feature for security, EVENT_SELECT and
FIXED_CTR_CTRL MSRs are intercepted, all other MSRs defined in Architectural
Performance Monitoring spec and rdpmc are passthrough, so guest can access
them without VM exit during guest running, when guest counter overflow
happens, HW PMI is triggered with dedicated kvm_pmi_vector, KVM injects a
virtual PMI into guest through virtual local apic.

At VM-exit:
1. KVM saves and clears guest PMU context.
2. KVM call perf supplied perf_guest_switch_to_host_pmi_vector() interface,
perf switch PMI vector to host NMI, so that host handles PMI after this
point.
3. KVM call perf supplied perf_guest_exit() interface, perf resched all
the perf events, these events stopped at VM-entry will be re-started here.

Design Opens
===
we met some design opens during this POC and seek supporting from
community:

1. host system wide / QEMU events handling during VM running
   At VM-entry, all the host perf events which use host x86 PMU will be
   stopped. These events with attr.exclude_guest = 1 will be stopped here
   and re-started after vm-exit. These events without attr.exclude_guest=1
   will be in error state, and they cannot recovery into active state even
   if the guest stops running. This impacts host perf a lot and request
   host system wide perf events have attr.exclude_guest=1.

   This requests QEMU Process's perf event with attr.exclude_guest=1 also.

   During VM running, perf event creation for system wide and QEMU
   process without attr.exclude_guest=1 fail with -EBUSY. 

2. NMI watchdog
   the perf event for NMI watchdog is a system wide cpu pinned event, it
   will be stopped also during vm running, but it doesn't have
   attr.exclude_guest=1, we add it in this RFC. But this still means NMI
   watchdog loses function during VM running.

   Two candidates exist for replacing perf event of NMI watchdog:
   a. Buddy hardlock detector[3] may be not reliable to replace perf event.
   b. HPET-based hardlock detector [4] isn't in the upstream kernel.

3. Dedicated kvm_pmi_vector
   In emulated vPMU, host PMI handler notify KVM to inject a virtual
   PMI into guest when physical PMI belongs to guest counter. If the
   same mechanism is used in passthrough vPMU and PMI skid exists
   which cause physical PMI belonging to guest happens after VM-exit,
   then the host PMI handler couldn't identify this PMI belongs to
   host or guest.
   So this RFC uses a dedicated kvm_pmi_vector, PMI belonging to guest
   has this vector only. The PMI belonging to host still has an NMI
   vector.

   Without considering PMI skid especially for AMD, the host NMI vector
   could be used for guest PMI also, this method is simpler and doesn't
   need x86 subsystem to reserve the dedicated kvm_pmi_vector, and we
   didn't meet the skid PMI issue on modern Intel processors.

4. per-VM passthrough mode configuration
   Current RFC uses a KVM module enable_passthrough_pmu RO parameter,
   it decides vPMU is passthrough mode or emulated mode at kvm module
   load time.
   Do we need the capability of per-VM passthrough mode configuration?
   So an admin can launch some non-passthrough VM and profile these
   non-passthrough VMs in host, but admin still cannot profile all
   the VMs once passthrough VM existence. This means passthrough vPMU
   and emulated vPMU mix on one platform, it has challenges to implement.
   As the commit message in commit 0011, the main challenge is 
   passthrough vPMU and emulated vPMU have different vPMU features, this
   ends up with two different values for kvm_cap.supported_perf_cap, which
   is initialized at module load time. To support it, more refactor is
   needed.

Commits construction
===
0000 ~ 0003: Perf extends exclude_guest to stop perf events during
             guest running.
0004 ~ 0009: Perf interface for dedicated kvm_pmi_vector.
0010 ~ 0032: all passthrough vPMU with PMU context switch at
             VM-entry/exit boundary.
0033 ~ 0037: Intercept EVENT_SELECT and FIXED_CTR_CTRL MSRs for
             KVM PMU filter feature.
0038 ~ 0039: Add emulated instructions to guest counter.
0040 ~ 0041: Fixes for passthrough vPMU live migration and Nested VM.

Performance Data
===
Measure method:
First step: guest run workload without perf, and get basic workload score.
Second step: guest run workload with perf commands, and get perf workload
             score.
Third step: perf overhead to workload is gotten from (first-second)/first.
Finally: compare perf overhead between emulated vPMU and passthrough vPMU.

Workload: Specint-2017
HW platform: Sapphire rapids, 1 socket, 56 cores, no-SMT
Perf command:
a. basic-sampling: perf record -F 1000 -e 6-instructions  -a --overwrite
b. multiplex-sampling: perf record -F 1000 -e 10-instructions -a --overwrite

Guest performance overhead:
---------------------------------------------------------------------------
| Test case          | emulated vPMU | all passthrough | passthrough with |
|                    |               |                 | event filters    |
---------------------------------------------------------------------------
| basic-sampling     |   33.62%      |    4.24%        |   6.21%          |
---------------------------------------------------------------------------
| multiplex-sampling |   79.32%      |    7.34%        |   10.45%         |
---------------------------------------------------------------------------
Note: here "passthrough with event filters" means KVM intercepts EVENT_SELECT
and FIXED_CTR_CTRL MSRs to support KVM PMU filter feature for security, this
is current RFC implementation. In order to collect EVENT_SELECT interception
impact, we modified RFC source to passthrough all the MSRs into guest, this
is "all passthrough" in above table.

Conclusion:
1. passthrough vPMU has much better performance than emulated vPMU.
2. Intercept EVENT_SELECT and FIXED_CTR_CTRL MSRs cause 2% overhead.
3. As PMU context switch happens at VM-exit/entry, the more VM-exit,
the more vPMU overhead. This does not only impacts perf, but it also
impacts other benchmarks which have massive VM-exit like fio. We will
optimize this at the second phase of passthrough vPMU.

Remain Works
===
1. To reduce passthrough vPMU overhead, optimize the PMU context switch.
2. Add more PMU features like LBR, PEBS, perf metrics.
3. vPMU live migration.

Reference
===
1. https://lore.kernel.org/lkml/2db2ebbe-e552-b974-fc77-870d958465ba@gmail.com/
2. https://lkml.kernel.org/kvm/ZRRl6y1GL-7RM63x@google.com/
3. https://lwn.net/Articles/932497/
4. https://lwn.net/Articles/924927/

Dapeng Mi (4):
  x86: Introduce MSR_CORE_PERF_GLOBAL_STATUS_SET for passthrough PMU
  KVM: x86/pmu: Implement the save/restore of PMU state for Intel CPU
  KVM: x86/pmu: Introduce macro PMU_CAP_PERF_METRICS
  KVM: x86/pmu: Clear PERF_METRICS MSR for guest

Kan Liang (2):
  perf: x86/intel: Support PERF_PMU_CAP_VPMU_PASSTHROUGH
  perf: Support guest enter/exit interfaces

Mingwei Zhang (22):
  perf: core/x86: Forbid PMI handler when guest own PMU
  perf: core/x86: Plumb passthrough PMU capability from x86_pmu to
    x86_pmu_cap
  KVM: x86/pmu: Introduce enable_passthrough_pmu module parameter and
    propage to KVM instance
  KVM: x86/pmu: Plumb through passthrough PMU to vcpu for Intel CPUs
  KVM: x86/pmu: Add a helper to check if passthrough PMU is enabled
  KVM: x86/pmu: Allow RDPMC pass through
  KVM: x86/pmu: Create a function prototype to disable MSR interception
  KVM: x86/pmu: Implement pmu function for Intel CPU to disable MSR
    interception
  KVM: x86/pmu: Intercept full-width GP counter MSRs by checking with
    perf capabilities
  KVM: x86/pmu: Whitelist PMU MSRs for passthrough PMU
  KVM: x86/pmu: Introduce PMU operation prototypes for save/restore PMU
    context
  KVM: x86/pmu: Introduce function prototype for Intel CPU to
    save/restore PMU context
  KVM: x86/pmu: Zero out unexposed Counters/Selectors to avoid
    information leakage
  KVM: x86/pmu: Add host_perf_cap field in kvm_caps to record host PMU
    capability
  KVM: x86/pmu: Exclude existing vLBR logic from the passthrough PMU
  KVM: x86/pmu: Make check_pmu_event_filter() an exported function
  KVM: x86/pmu: Allow writing to event selector for GP counters if event
    is allowed
  KVM: x86/pmu: Allow writing to fixed counter selector if counter is
    exposed
  KVM: x86/pmu: Introduce PMU helper to increment counter
  KVM: x86/pmu: Implement emulated counter increment for passthrough PMU
  KVM: x86/pmu: Separate passthrough PMU logic in set/get_msr() from
    non-passthrough vPMU
  KVM: nVMX: Add nested virtualization support for passthrough PMU

Xiong Zhang (13):
  perf: Set exclude_guest onto nmi_watchdog
  perf: core/x86: Add support to register a new vector for PMI handling
  KVM: x86/pmu: Register PMI handler for passthrough PMU
  perf: x86: Add function to switch PMI handler
  perf/x86: Add interface to reflect virtual LVTPC_MASK bit onto HW
  KVM: x86/pmu: Add get virtual LVTPC_MASK bit function
  KVM: x86/pmu: Manage MSR interception for IA32_PERF_GLOBAL_CTRL
  KVM: x86/pmu: Switch IA32_PERF_GLOBAL_CTRL at VM boundary
  KVM: x86/pmu: Switch PMI handler at KVM context switch boundary
  KVM: x86/pmu: Call perf_guest_enter() at PMU context switch
  KVM: x86/pmu: Add support for PMU context switch at VM-exit/enter
  KVM: x86/pmu: Intercept EVENT_SELECT MSR
  KVM: x86/pmu: Intercept FIXED_CTR_CTRL MSR

 arch/x86/events/core.c                   |  38 +++++
 arch/x86/events/intel/core.c             |   8 +
 arch/x86/events/perf_event.h             |   1 +
 arch/x86/include/asm/hardirq.h           |   1 +
 arch/x86/include/asm/idtentry.h          |   1 +
 arch/x86/include/asm/irq.h               |   1 +
 arch/x86/include/asm/irq_vectors.h       |   2 +-
 arch/x86/include/asm/kvm-x86-pmu-ops.h   |   3 +
 arch/x86/include/asm/kvm_host.h          |   8 +
 arch/x86/include/asm/msr-index.h         |   1 +
 arch/x86/include/asm/perf_event.h        |   4 +
 arch/x86/include/asm/vmx.h               |   1 +
 arch/x86/kernel/idt.c                    |   1 +
 arch/x86/kernel/irq.c                    |  29 ++++
 arch/x86/kvm/cpuid.c                     |   4 +
 arch/x86/kvm/lapic.h                     |   5 +
 arch/x86/kvm/pmu.c                       | 102 ++++++++++++-
 arch/x86/kvm/pmu.h                       |  37 ++++-
 arch/x86/kvm/vmx/capabilities.h          |   1 +
 arch/x86/kvm/vmx/nested.c                |  52 +++++++
 arch/x86/kvm/vmx/pmu_intel.c             | 186 +++++++++++++++++++++--
 arch/x86/kvm/vmx/vmx.c                   | 176 +++++++++++++++++----
 arch/x86/kvm/vmx/vmx.h                   |   3 +-
 arch/x86/kvm/x86.c                       |  37 ++++-
 arch/x86/kvm/x86.h                       |   2 +
 include/linux/perf_event.h               |  11 ++
 kernel/events/core.c                     | 179 ++++++++++++++++++++++
 kernel/watchdog_perf.c                   |   1 +
 tools/arch/x86/include/asm/irq_vectors.h |   1 +
 29 files changed, 852 insertions(+), 44 deletions(-)


base-commit: b85ea95d086471afb4ad062012a4d73cd328fa86
-- 
2.34.1


