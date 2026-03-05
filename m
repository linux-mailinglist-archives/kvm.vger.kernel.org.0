Return-Path: <kvm+bounces-72888-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QOzlJHrBqWnNDQEAu9opvQ
	(envelope-from <kvm+bounces-72888-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:46:34 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id F303E216707
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:46:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4A7C83111AF2
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 17:44:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22C9D3E5EEF;
	Thu,  5 Mar 2026 17:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Rftd4omh"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DF993BED59;
	Thu,  5 Mar 2026 17:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772732675; cv=none; b=KzbK9KOmNpu96pVRn0hQsh+CIh/pt/Z30SGOUfHzGA4pQ5By/C+cR9/CjN7sxjYF/nO3axR7f1MX8iA6y4DIkgFpZZ8OP/tRWFeGEaGTNAb5GESCiP7b2vdMrVU++p2PWNlflYyNuAgeJeTau/pZOGETy8tIHk12+tkS+kgONbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772732675; c=relaxed/simple;
	bh=SX5FT/6PKDda/EYgozmlIiN+UKhMBYW1adCRraCrPF8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=itSHLsG92tsXAWaH30wwQrmMqLWpjQapQYUGQOZvJI8WsXIRl/COKGBtwRnMsyzpdiN3xDmOitVlG7buXsWt1/xN1f6pV1RGgIL/3LZVN3lVFJnNz04ru8ClvJp8C2EBXJiCSe9c250TNJkB7+7sfWjDU/AqjR/F7hyIsFIg0hU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Rftd4omh; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772732674; x=1804268674;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=SX5FT/6PKDda/EYgozmlIiN+UKhMBYW1adCRraCrPF8=;
  b=Rftd4omhn05c/SddVZPRd186G7YuXXNYNTYfMThfKxmdPhaZxkjbQptS
   yHsVEtbhzKZu7pTsLZ9ya1t39ltQx4On0xKj7Ao7Cy6TA1Ux+zSNniaSz
   FhHqUUEhMDbhmv247JmqTAGLz+Ns19nonoNOCq0XDF0xeqTbnPKW0xQ47
   zyPQYLavO9/ZeqzH6HR1rSc1s62FTJoQG8CT6Jr6LXuj9VGmjhE2ToNii
   hGgqrjWay0hiq/YoWhaljLbrR9utZolQ0Kap9NSPaT9KCvoPXUtplRqRK
   EDQRCuydi57x5K51rrqquv7p3ERjOK2ricD7VhyiVh3OBKU2z1YHJpbAA
   A==;
X-CSE-ConnectionGUID: UjrHtOn9RLuM2J0QLOxiDQ==
X-CSE-MsgGUID: aGa6Tua+SjqfACCe2jCIvQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11720"; a="77431534"
X-IronPort-AV: E=Sophos;i="6.23,103,1770624000"; 
   d="scan'208";a="77431534"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 09:44:33 -0800
X-CSE-ConnectionGUID: 96qB7Lb2QiSeJr/sgvFIIw==
X-CSE-MsgGUID: jhNFmHFCRqauNNbXBIKhIA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,103,1770624000"; 
   d="scan'208";a="223447840"
Received: from mdroper-mobl2.amr.corp.intel.com (HELO localhost) ([10.124.220.244])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 09:44:32 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 00/36] KVM: VMX APIC timer virtualization support
Date: Thu,  5 Mar 2026 09:43:40 -0800
Message-ID: <cover.1772732517.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: F303E216707
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[intel.com,gmail.com,redhat.com,google.com,vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-72888-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[isaku.yamahata@intel.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[intel.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	FROM_NO_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:dkim,intel.com:email,intel.com:url,intel.com:mid,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

From: Isaku Yamahata <isaku.yamahata@intel.com>

This patch series is v2 of VMX APIC timer virtualization support.

qemu patches doesn't need update.
https://lore.kernel.org/kvm/e41ffc4af96b8b4ee3a65f8da1f52dac7f3f4913.1770116952.git.isaku.yamahata@intel.com/

v2 patch for kvm-unit-tests update will be posted.
(v1 https://lore.kernel.org/kvm/7acdd9974effabe5dc461aa755eacf9fb0697467.1770116601.git.isaku.yamahata@intel.com/)

Changes v1 -> v2:
https://lore.kernel.org/kvm/cover.1770116050.git.isaku.yamahata@intel.com/
- Rebased to kvm-x86 and v7.0-rcX.
- Fixed an issue found by syzbot.  Require in-kernel APIC for nested
  VMX APIC timer virtualization.
- Add test case for nested VMX APIC timer virtualization with in-kernel
  APIC.
- Avoid compile time error by clearing the feature bit explicitly instead
  of clearing the bit of KVM_OPTIONAL_VMX_TERTIARY_VM_EXEC_CONTROL.
- Fix compile errors. EXPORT_SYMBOL_FOR_KVM_INTERNAL.
- selftests: Use GUEST_ASSERT_EQ() where meaningful.
- selftests: Use safe_halt(), sti(), cli() instead of raw inline assembly.
- selftests: Require serialize instruction for tests that uses it.

Background
==========
X86 provides the TSC deadline timer as the primary local timer
interrupt source.  Currently, KVM intercepts the guest programming of
the timer and emulates it using either the host OS timer or the VMX
preemption timer.


Problem
=======
VMM emulation causes high latency.  Some workloads require lower
latency, such as gaming applications, while there have been efforts to
reduce latency in the past, a hardware extension can reduce it further
by eliminating VM Exits.


Solution
========
Hardware Extension
------------------
The APIC timer virtualization [1] allows the guest to directly access
the TSC DEADLINE MSR and receive timer interrupts without VM Exits.

It introduces
- A feature bit in the tertiary processor-based VM-execution controls
- Guest deadline: 64-bit physical deadline (host TSC value)
- Guest deadline shadow: 64-bit virtual deadline (virtualized TSC
  value with TSC offset and multiplier)
- Virtual timer vector: interrupt vector to inject on timeout.

Implementation
--------------
Add hooks to the LAPIC timer emulation and implement them in the VMX
backend.  Enable the feature when available, falling back to
software/preemption timer in the following cases
One-shot or periodic APIC timer:
  The hardware supports only the TSC deadline timer
Masked the timer interrupt in LVTT:
  The hardware doesn't respect the emulated LVTT and always generates an
  interrupt on timeout.
vCPU blocking/unblocking:
  The hardware generates an interrupt while the vCPU is running.  The KVM
  must wake up from vCPU blocking by getting the latest TSC
  deadline and setting a software timer before blocking the vCPU.
VM Entry to L2 vCPU:
  If the L1 timer interrupt fires while the L2 vCPU is running, the
  expected behavior is a VM Exit from L2 to L1, followed by an interrupt
  injection into the L1 vCPU.

nVMX Support
------------
Support nVMX to address the benchmark result below.  Emulate related
MSRs and VMCS individually.
MSRs: capability reporting registers of primary/tertiary processor-based
      VM-execution controls.
VMCS fields: primary/tertiary VM-execution controls, guest deadline,
             guest deadline shadow, and virtual timer vector.

Patch Organization
------------------
The patch is organized into 5 parts as follows.

Patches  1- 8: VMX support (feature probe, hooks to KVM LAPIC, VMX hooks)
Patches  9-18: nVMX support (implement emulation of MSR and VMCS fields)
Patches 19-23: Expose the feature to the user
Patches 24-31: KVM selftests
Patches 32   : Documentation update

https://lore.kernel.org/kvm/e41ffc4af96b8b4ee3a65f8da1f52dac7f3f4913.1770116952.git.isaku.yamahata@intel.com/
(KVM unit tests turned out test case issue. It needs fixes.)
https://lore.kernel.org/kvm/7acdd9974effabe5dc461aa755eacf9fb0697467.1770116601.git.isaku.yamahata@intel.com/


Test
====
The following tests were conducted:  The newly added test case as a
part of KVM selftests, KVM unit tests, and cyclic test included in
rt-tests [2].  Selftests and KVM unit tests were run on platforms with
and without APIC timer virtualization.


Benchmark Results
=================
cyclictest
----------
10-minute run of
cyclictest --quiet --nsecs --smp --mlockall --priority=95 --policy=fifo
# of vCPU: host 256, L1 and L2: 16

Legends:
L1 or L2: cyclic test run as L1/L2 process
Y: feature enabled
N: feature disabled

Run in
|       APIC timer virtualization
|       |       nested APIC timer virtualization
|       |       |       min reduction %
|       |       |       |       avg reduction %
|       |       |       |       |
L1	N	-
L1	Y	-	21%	21% (compared to L1 N)

L2	N	N
L2	Y	N	4%	-2% (compared to L2 N N)
L2	Y	Y	75%	51% (compared to L2 N N)

Micro benchmark: Timer latency
------------------------------
10-minute run of custom micro benchmark, timer_latency.
# of vCPU: host 256, L1 and L2: 16

Legends:
L1: the benchmark run in L0 Linux.
L2: the benchmark run in L1 Linux.
Y: feature enabled
N: feature disabled

Run as
|       APIC timer virtualization
|       |       nested APIC timer virtualization
|       |       |       HLT or busy
|       |       |       |       min reduction %
|       |       |       |       |       avg reduction %
|       |       |       |       |       |
L1	N	-	HLT
L1	Y	-	HLT	49%	24% (compared to L1 N HLT)

L1	N	-	busy
L1	Y	-	busy	63%	61% (compared to L1 N busy)

L2	N	N	HLT
L2	Y	N	HLT	-19%	-3% (compared to L2 N N HLT)
L2	Y	Y	HLT	99%	27% (compared to L2 N N HLT)

L2	N	N	busy
L2	Y	N	busy	-5%	-4% (compared to L2 N N busy)
L2	Y	Y	busy	99%	97% (compared to L2 N N busy)


[1] Intel Architecture Instruction Set Extensions and Future Features
September 2025 319433-059
Chapter 8 APIC-TIMER VIRTUALIZATION
https://cdrdv2.intel.com/v1/dl/getContent/671368

[2] rt-tests
https://git.kernel.org/pub/scm/utils/rt-tests/rt-tests.git/


Isaku Yamahata (29):
  KVM: x86/lapic: Wire DEADLINE MSR update to guest virtual TSC deadline
  KVM: VMX: Update APIC timer virtualization on apicv changed
  KVM: nVMX: Disallow/allow guest APIC timer virtualization switch
    to/from L2
  KVM: nVMX: Pass struct msr_data to VMX MSRs emulation
  KVM: nVMX: Supports VMX tertiary controls and GUEST_APIC_TIMER bit
  KVM: nVMX: Add alignment check for struct vmcs12
  KVM: nVMX: Add tertiary VM-execution control VMCS support
  KVM: nVMX: Update intercept on TSC deadline MSR
  KVM: nVMX: Handle virtual timer vector VMCS field
  KVM: VMX: Make vmx_calc_deadline_l1_to_host() non-static
  KVM: nVMX: Enable guest deadline and its shadow VMCS field
  KVM: nVMX: Add VM entry checks related to APIC timer virtualization
  KVM: nVMX: Add check vmread/vmwrite on tertiary control
  KVM: nVMX: Add check VMCS index for guest timer virtualization
  KVM: VMX: Advertise tertiary controls to the user space
  KVM: VMX: Enable APIC timer virtualization
  KVM: nVMX: Introduce module parameter for nested APIC timer
    virtualization
  KVM: selftests: Add a test to measure local timer latency
  KVM: selftests: Add nVMX support to timer_latency test case
  KVM: selftests: Add test for nVMX MSR_IA32_VMX_PROCBASED_CTLS3
  KVM: selftests: Add test vmx_set_nested_state_test with EVMCS disabled
  KVM: selftests: Add tests nested state of APIC timer virtualization
  KVM: selftests: Add VMCS access test to APIC timer virtualization
  KVM: selftests: Add serialize() helper and X86_FEATURE_SERIALIZE
  KVM: selftests: Test cases for L1 APIC timer virtualization
  KVM: selftests: Add tests for nVMX to vmx_apic_timer_virt
  KVM: selftests: Add a global option to disable in-kernel irqchip
  KVM: selftests: Test VMX apic timer virt with inkernel apic disable
  Documentation: KVM: x86: Update documentation of struct vmcs12

Yang Zhong (7):
  KVM: VMX: Detect APIC timer virtualization bit
  KVM: x86: Implement APIC virt timer helpers with callbacks
  KVM: x86/lapic: Start/stop sw/hv timer on vCPU un/block
  KVM: x86/lapic: Add a trace point for guest virtual timer
  KVM: VMX: Implement the hooks for VMX guest virtual deadline timer
  KVM: VMX: dump_vmcs() support the guest virt timer
  KVM: VMX: Introduce module parameter for APIC virt timer support

 Documentation/virt/kvm/x86/nested-vmx.rst     |  14 +-
 arch/x86/include/asm/kvm-x86-ops.h            |   5 +
 arch/x86/include/asm/kvm_host.h               |   6 +
 arch/x86/include/asm/vmx.h                    |   6 +
 arch/x86/include/asm/vmxfeatures.h            |   1 +
 arch/x86/kvm/lapic.c                          | 157 +++-
 arch/x86/kvm/lapic.h                          |  18 +
 arch/x86/kvm/trace.h                          |  16 +
 arch/x86/kvm/vmx/capabilities.h               |   8 +
 arch/x86/kvm/vmx/hyperv.c                     |  17 +
 arch/x86/kvm/vmx/main.c                       |   5 +
 arch/x86/kvm/vmx/nested.c                     | 212 +++++-
 arch/x86/kvm/vmx/nested.h                     |  39 +-
 arch/x86/kvm/vmx/vmcs12.c                     |   8 +
 arch/x86/kvm/vmx/vmcs12.h                     |  13 +-
 arch/x86/kvm/vmx/vmcs_shadow_fields.h         |   1 +
 arch/x86/kvm/vmx/vmx.c                        | 148 +++-
 arch/x86/kvm/vmx/vmx.h                        |   7 +-
 arch/x86/kvm/vmx/x86_ops.h                    |   5 +
 arch/x86/kvm/x86.c                            |   8 +-
 arch/x86/kvm/x86.h                            |   2 +-
 tools/testing/selftests/kvm/Makefile.kvm      |   4 +
 .../testing/selftests/kvm/include/x86/apic.h  |   1 +
 .../selftests/kvm/include/x86/kvm_util_arch.h |   1 +
 .../selftests/kvm/include/x86/processor.h     |   7 +
 tools/testing/selftests/kvm/include/x86/vmx.h |  14 +
 .../testing/selftests/kvm/lib/x86/processor.c |   5 +-
 .../selftests/kvm/x86/nested_set_state_test.c | 250 +++++++
 .../testing/selftests/kvm/x86/timer_latency.c | 704 ++++++++++++++++++
 .../kvm/x86/vmx_apic_timer_virt_test.c        | 510 +++++++++++++
 .../kvm/x86/vmx_apic_timer_virt_vmcs_test.c   | 464 ++++++++++++
 .../testing/selftests/kvm/x86/vmx_msrs_test.c |  53 ++
 .../kvm/x86/vmx_tertiary_ctls_test.c          | 168 +++++
 33 files changed, 2853 insertions(+), 24 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86/timer_latency.c
 create mode 100644 tools/testing/selftests/kvm/x86/vmx_apic_timer_virt_test.c
 create mode 100644 tools/testing/selftests/kvm/x86/vmx_apic_timer_virt_vmcs_test.c
 create mode 100644 tools/testing/selftests/kvm/x86/vmx_tertiary_ctls_test.c


base-commit: 5128b972fb2801ad9aca54d990a75611ab5283a9
-- 
2.45.2


