Return-Path: <kvm+bounces-70033-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sDAqDgg8gmmVQgMAu9opvQ
	(envelope-from <kvm+bounces-70033-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 19:18:48 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F46ADD743
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 19:18:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2275F30804E6
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 18:17:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EDA0364EA6;
	Tue,  3 Feb 2026 18:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ntwY+Lf5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBE033EBF19;
	Tue,  3 Feb 2026 18:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770142652; cv=none; b=G+z4WSO70KI2JkZa5viMbRBNVpWngPclzD+e7ATcMFkm+YwW6CF20fYvXJ4wSzQWB2/DLaA3WuKXMrVK55XbjhZYaAop/w/UyR6GRCDfDYVJoVdnWKB2QoZ54bOuZsWTM4k7jnbcIQ0Ztwv6kdMzxFZ7hXxAewKiFL4dsI/4hOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770142652; c=relaxed/simple;
	bh=239ceZ4XIIJRPPYpSzcEe0FQJUjdpKkZ6jCsHezqtNE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=U10kc3DUCvGHAWOcxujM06PRWem1ggyHAzsSuZCTK14CrW9xjlwzbkykBG6YD4QSzBouLDsYrqvRRliu1UXzitlxKbFByvMN5kOvGp4q9fMFgTKky7zB0U9YSJ+rysnZSMkiM2C8XKPglgiU8WDwJeMXnWL1f6N1LOh4QrDfsU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ntwY+Lf5; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770142651; x=1801678651;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=239ceZ4XIIJRPPYpSzcEe0FQJUjdpKkZ6jCsHezqtNE=;
  b=ntwY+Lf5RuV0rhRjLmpAGbN8Wbnhm7Lf2pL7BySsU7OXFSm4Oc4Gto7o
   6I8QOJt8k8oCdVBNSsfnmXrBLvUdFls6htl8C1NhqLmS17FfL3thEfXYp
   XGnFUCKn/96SwezdoBDjlHmtkKacsUR3gQDXDesVVV3OGeUu5gorq6w8y
   kEJUKt3d65/2aUBXavuYK+tMeWBh8zeOjcvOTb7SMrgf3GK63zKEsfWfA
   EDIovNpqYyEovFJvAZShD3TXvB8RdzAHKrHKgM8XXdn88sJCQVbeb0y25
   5TBEOTBG8S9HACVkzVFzVuljUNIUbnu+ZjL7lkGcapG94l/NsrVJp50vL
   w==;
X-CSE-ConnectionGUID: OFwfYWUCSzGqujxe22tdzw==
X-CSE-MsgGUID: rPKzxuAPRTW2f3EcWvGZ9g==
X-IronPort-AV: E=McAfee;i="6800,10657,11691"; a="82433150"
X-IronPort-AV: E=Sophos;i="6.21,271,1763452800"; 
   d="scan'208";a="82433150"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 10:17:30 -0800
X-CSE-ConnectionGUID: VOSLX3rWQsCnsZ5knem9cA==
X-CSE-MsgGUID: lCmIclTvSOOS0Eio6aECkw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,271,1763452800"; 
   d="scan'208";a="209727444"
Received: from khuang2-desk.gar.corp.intel.com (HELO localhost) ([10.124.221.188])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 10:17:30 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 00/32] KVM: VMX APIC timer virtualization support
Date: Tue,  3 Feb 2026 10:16:43 -0800
Message-ID: <cover.1770116050.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[intel.com,gmail.com,redhat.com,google.com,vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-70033-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[isaku.yamahata@intel.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[intel.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	FROM_NO_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:dkim,intel.com:email,intel.com:url,intel.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 7F46ADD743
X-Rspamd-Action: no action

From: Isaku Yamahata <isaku.yamahata@intel.com>

This patch series implements support for APIC timer virtualization for
VMX and nVMX.

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

Patches for QEMU and KVM unit tests will be posted.
(KVM unit tests turned out test case issue. It needs fixes.)


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

Isaku Yamahata (25):
  KVM: x86/lapic: Wire DEADLINE MSR update to guest virtual TSC deadline
  KVM: VMX: Update APIC timer virtualization on apicv changed
  KVM: nVMX: Disallow/allow guest APIC timer virtualization switch
    to/from L2
  KVM: nVMX: Pass struct msr_data to VMX MSRs emulation
  KVM: nVMX: Supports VMX tertiary controls and GUEST_APIC_TIMER bit
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
  KVM: selftests: Test cases for L1 APIC timer virtualization
  KVM: selftests: Add tests for nVMX to vmx_apic_timer_virt
  Documentation: KVM: x86: Update documentation of struct vmcs12

Yang Zhong (7):
  KVM: VMX: Detect APIC timer virtualization bit
  KVM: x86: Implement APIC virt timer helpers with callbacks
  KVM: x86/lapic: Start/stop sw/hv timer on vCPU un/block
  KVM: x86/lapic: Add a trace point for guest virtual timer
  KVM: VMX: Implement the hooks for VMX guest virtual deadline timer
  KVM: VMX: dump_vmcs() support the guest virt timer
  KVM: VMX: Introduce module parameter for APIC virt timer support

 Documentation/virt/kvm/x86/nested-vmx.rst     |  13 +-
 arch/x86/include/asm/kvm-x86-ops.h            |   5 +
 arch/x86/include/asm/kvm_host.h               |   6 +
 arch/x86/include/asm/vmx.h                    |   6 +
 arch/x86/include/asm/vmxfeatures.h            |   1 +
 arch/x86/kvm/lapic.c                          | 147 +++-
 arch/x86/kvm/lapic.h                          |  15 +
 arch/x86/kvm/trace.h                          |  16 +
 arch/x86/kvm/vmx/capabilities.h               |   8 +
 arch/x86/kvm/vmx/hyperv.c                     |  17 +
 arch/x86/kvm/vmx/main.c                       |   5 +
 arch/x86/kvm/vmx/nested.c                     | 215 +++++-
 arch/x86/kvm/vmx/nested.h                     |  33 +-
 arch/x86/kvm/vmx/vmcs12.c                     |   6 +
 arch/x86/kvm/vmx/vmcs12.h                     |  11 +-
 arch/x86/kvm/vmx/vmcs_shadow_fields.h         |   1 +
 arch/x86/kvm/vmx/vmx.c                        | 142 +++-
 arch/x86/kvm/vmx/vmx.h                        |   7 +-
 arch/x86/kvm/vmx/x86_ops.h                    |   5 +
 arch/x86/kvm/x86.c                            |   8 +-
 arch/x86/kvm/x86.h                            |   2 +-
 tools/testing/selftests/kvm/Makefile.kvm      |   3 +
 .../testing/selftests/kvm/include/x86/apic.h  |   2 +
 .../selftests/kvm/include/x86/processor.h     |   6 +
 tools/testing/selftests/kvm/include/x86/vmx.h |  14 +
 .../testing/selftests/kvm/x86/timer_latency.c | 700 ++++++++++++++++++
 .../kvm/x86/vmx_apic_timer_virt_test.c        | 508 +++++++++++++
 .../kvm/x86/vmx_apic_timer_virt_vmcs_test.c   | 461 ++++++++++++
 .../testing/selftests/kvm/x86/vmx_msrs_test.c |  53 ++
 .../kvm/x86/vmx_set_nested_state_test.c       | 249 +++++++
 30 files changed, 2644 insertions(+), 21 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86/timer_latency.c
 create mode 100644 tools/testing/selftests/kvm/x86/vmx_apic_timer_virt_test.c
 create mode 100644 tools/testing/selftests/kvm/x86/vmx_apic_timer_virt_vmcs_test.c


base-commit: 63804fed149a6750ffd28610c5c1c98cce6bd377
-- 
2.45.2


