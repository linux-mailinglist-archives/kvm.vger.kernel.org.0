Return-Path: <kvm+bounces-39438-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9924BA470CC
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 02:19:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9ACC03A9BCA
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 01:18:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DACB38DD3;
	Thu, 27 Feb 2025 01:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WftKV585"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3F0A4A35;
	Thu, 27 Feb 2025 01:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740619131; cv=none; b=LgzuCHbAlTfh6/5yqJq2mmOrD9sBwJnVyEC0JYQ0ml1nd4VGRI/HmsU5pTFi7+1zMSyn9sQg9AmqZ6xNoVIKltn/O/Z29kVlmQ6HJRMHxgroUt5yRbwGhfkdAjwBryATUAeZ02PTv7W2EzebQSHaAlsDowBfiGX24sStaFZgt4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740619131; c=relaxed/simple;
	bh=HhUhlhjRar2n+oEQ4HGfUAieFs+HeIQJMtyvSs6i4zk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HoH7JGKm591erCz82EoJP9mtS8dxTjItq8VbpOuyJyz6hVMbg/F1/1063jvJgVRkiVWM71xtD4ObTTwTsaWi6XH5S/o3dRbFpUZzvme1SJ054LOFn4t1Dk+tWhLii1ctZwt2jCRmKP1S204QfVy5FvvbsO57zdX4IjxC7rHJqnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WftKV585; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740619130; x=1772155130;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=HhUhlhjRar2n+oEQ4HGfUAieFs+HeIQJMtyvSs6i4zk=;
  b=WftKV585HET9IDTgqbYq7disXC6q+081ZaQSBXWHKsNUlijsypYKliPk
   UX6j7VM3EkDGGcxJatBzvF6sd7bM1GPHMXpIFRL19NnYSjJgZXyrGmh6T
   P37hgmFIRgaF8VO1u4XZbioXQ7NiIvvXk4V5NTjsPVdbqRd6Qa8bc/zY3
   03miQ/F5LNHVM36QEb9ETip0UFPiCznGcK5Ke5Xq5T3jY0/2i35IGgpaL
   3uxNuY+sNEHw71Ov4ik8YtCLaguohNw59/DOpCFELGLn2gII/pvQOQgKR
   UYyTau+jbeYtYYX8S4wImZlZEx/b2nC3qOg989JbLVaDVyub0H/XzY5fi
   w==;
X-CSE-ConnectionGUID: YCjk3vbhRfuOQIWuDttTfg==
X-CSE-MsgGUID: cYCpXazZTHeyhZjmPITlSw==
X-IronPort-AV: E=McAfee;i="6700,10204,11357"; a="63959580"
X-IronPort-AV: E=Sophos;i="6.13,318,1732608000"; 
   d="scan'208";a="63959580"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2025 17:18:49 -0800
X-CSE-ConnectionGUID: RQg1tI2SQrqbtY4T0P0NKw==
X-CSE-MsgGUID: tpvsrkJWSISkP+4EZjYRVw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,318,1732608000"; 
   d="scan'208";a="116674823"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2025 17:18:46 -0800
From: Binbin Wu <binbin.wu@linux.intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org
Cc: rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@intel.com,
	isaku.yamahata@intel.com,
	yan.y.zhao@intel.com,
	chao.gao@intel.com,
	linux-kernel@vger.kernel.org,
	binbin.wu@linux.intel.com
Subject: [PATCH v2 00/20] KVM: TDX: TDX "the rest" part
Date: Thu, 27 Feb 2025 09:20:01 +0800
Message-ID: <20250227012021.1778144-1-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

This patch series adds the support for EPT violation/misconfig handling and
several TDVMCALL leaves, adds a bunch of wrappers to ignore the operations
not supported by TDX guests, and the document.

This patch series is the last part needed to provide the ability to run a
functioning TD VM.  We think this is in pretty good shape at this point and
ready for handoff to Paolo.


Base of this series
===================
This series is based on kvm-coco-queue up to the end of "TDX interrupts",
plus one PAT quirk series. Stack is:
 - '31db5921f12d ("KVM: TDX: Handle EXIT_REASON_OTHER_SMI")' from
   kvm-coco-queue.
 - PAT quirk series
   "KVM: x86: Introduce quirk KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT" [0].


Notable changes since v1 [1]
============================
Patch "KVM: x86: Add a switch_db_regs flag to handle TDX's auto-switched
behavior" is moved to "KVM: TDX: TD vcpu enter/exit" [2].

Rebased after adding tdcall_to_vmx_exit_reason() in [3] and the way to
get exit_qualification, ext_exit_qualification.

For EPT MISCONFIG, bug the VM and return -EIO.  The handling is deferred
until tdx_handle_exit() because tdx_to_vmx_exit_reason() is called by
'noinstr' code with interrupt disabled.

Add SEPT local retry and wait for SEPT zap logic to provide a clean
solution to avoid the blind SEPT retries.

Morph the following guest requested exit reasons (via TDVMCALL) to KVM's
tracked exit reasons:
 - Morph PV CPUID to EXIT_REASON_CPUID
 - Morph PV HLT to EXIT_REASON_HLT
 - Morph PV RDMSR to EXIT_REASON_RDMSR
 - Morph PV WRMSR to EXIT_REASON_WRMSR

Check RVI pending (bit 0 of TD_VCPU_STATE_DETAILS_NON_ARCH field) only for
HALTED case with IRQ enabled in tdx_protected_apic_has_interrupt().

For PV RDMSR/WRMSR handling, marshall values to the appropriate x86
registers to leverage the existing kvm_emulate_{rdmsr,wrmsr}(), and
implement complete_emulated_msr() callback to set return value/code to
vp_enter_args.

Skip setting of return code when the value is TDVMCALL_STATUS_SUCCESS
because r10 is always 0 for standard TDVMCALL exit.

Get/set tdvmcall inputs/outputs from/to vp_enter_args directly in struct
vcpu_tdx. After dropping helpers for read/write a0~a3 in [3].

Added back MTRR MSRs access, but drop the special handling for TDX guests,
just align with what KVM does for normal VMs.

Dropped tdx_cache_reg().

Updated documents.


TODO
====
Macrofy vt_x86_ops callbacks suggested by Sean. [4]


Overview
========
EPT violation
-------------
EPT violation for TDX will trigger X86 MMU code.
Note that instruction fetch from shared memory is not allowed for TDX
guests, if it occurs, treat it as broken hardware, bug the VM and return
error.
(*New Updated*)
SEPT local retry and wait for SEPT zap logic provides a clean solution to
avoid the blind SEPT retries.

EPT misconfiguration
--------------------
EPT misconfiguration shouldn't happen for TDX guests. If it occurs, bug the
VM and return error.

TDVMCALL support
----------------
Supports are added to allow TDX guests to issue CPUID, HLT, RDMSR/WRMSR and
GetTdVmCallInfo via TDVMCALL.

- CPUID
  For TDX, most CPUID leaf/sub-leaf combinations are virtualized by the TDX
  module while some trigger #VE.  On #VE, TDX guest can issue a TDVMCALL
  with the leaf Instruction.CPUID to request VMM to emulate CPUID
  operation.

- HLT
  TDX guest can issue a TDVMCALL with HLT, which passes the interrupt
  blocked flag. Whether the interrupt is allowed or not is depending on the
  interrupt blocked flag.  For NMI, KVM can't get the NMI blocked status of
  TDX guest, it always assumes NMI is allowed.

- MSRs
  Some MSRs are virtualized by TDX module directly, while some MSRs will
  trigger #VE when guest accesses them.  On #VE, TDX guests can issue a
  TDVMCALL with WRMSR or RDMSR to request emulation in VMM.

Operations ignored
------------------
TDX protects TDX guest state from VMM, and some features are not supported
by TDX guest, a bunch of operations are ignored for TDX guests, including:
accesses to CPU state, VMX preemption timer, accesses to TSC offset and 
multiplier, setup MCE for LMCE enable/disable, and hypercall patching.


Repos
=====
Due to "KVM: VMX: Move common fields of struct" in "TDX vcpu enter/exit" v2
[2], subsequent patches require changes to use new struct vcpu_vt, refer to
the full KVM branch below.

It requires TDX module 1.5.06.00.0744 [4], or later as mentioned in [2].
A working edk2 commit is 95d8a1c ("UnitTestFrameworkPkg: Use TianoCore
mirror of subhook submodule").

The full KVM branch is here:
https://github.com/intel/tdx/tree/tdx_kvm_dev-2025-02-26

A matching QEMU is here:
https://github.com/intel-staging/qemu-tdx/tree/tdx-qemu-wip-2025-02-18


Testing 
=======
It has been tested as part of the development branch for the TDX base
series. The testing consisted of TDX kvm-unit-tests and booting a Linux
TD, and TDX enhanced KVM selftests. It also passed the TDX related test
cases defined in the LKVS test suite as described in: 
https://github.com/intel/lkvs/blob/main/KVM/docs/lkvs_on_avocado.md


[0] https://lore.kernel.org/kvm/20250224070716.31360-1-yan.y.zhao@intel.com
[1] https://lore.kernel.org/kvm/20241210004946.3718496-1-binbin.wu@linux.intel.com
[2] https://lore.kernel.org/kvm/20250129095902.16391-1-adrian.hunter@intel.com
[3] https://lore.kernel.org/kvm/20250222014225.897298-1-binbin.wu@linux.intel.com
[4] https://lore.kernel.org/kvm/Z6v9yjWLNTU6X90d@google.com
[5] https://github.com/intel/tdx-module/releases/tag/TDX_1.5.06

Binbin Wu (1):
  KVM: TDX: Enable guest access to MTRR MSRs

Isaku Yamahata (16):
  KVM: TDX: Handle EPT violation/misconfig exit
  KVM: TDX: Handle TDX PV CPUID hypercall
  KVM: TDX: Handle TDX PV HLT hypercall
  KVM: x86: Move KVM_MAX_MCE_BANKS to header file
  KVM: TDX: Implement callbacks for MSR operations
  KVM: TDX: Handle TDX PV rdmsr/wrmsr hypercall
  KVM: TDX: Enable guest access to LMCE related MSRs
  KVM: TDX: Handle TDG.VP.VMCALL<GetTdVmCallInfo> hypercall
  KVM: TDX: Add methods to ignore accesses to CPU state
  KVM: TDX: Add method to ignore guest instruction emulation
  KVM: TDX: Add methods to ignore VMX preemption timer
  KVM: TDX: Add methods to ignore accesses to TSC
  KVM: TDX: Ignore setting up mce
  KVM: TDX: Add a method to ignore hypercall patching
  KVM: TDX: Make TDX VM type supported
  Documentation/virt/kvm: Document on Trust Domain Extensions (TDX)

Yan Zhao (3):
  KVM: TDX: Detect unexpected SEPT violations due to pending SPTEs
  KVM: TDX: Retry locally in TDX EPT violation handler on RET_PF_RETRY
  KVM: TDX: Kick off vCPUs when SEAMCALL is busy during TD page removal

 Documentation/virt/kvm/api.rst           |  13 +-
 Documentation/virt/kvm/x86/index.rst     |   1 +
 Documentation/virt/kvm/x86/intel-tdx.rst | 255 ++++++++++++
 arch/x86/include/asm/shared/tdx.h        |   1 +
 arch/x86/include/asm/vmx.h               |   2 +
 arch/x86/kvm/vmx/main.c                  | 482 ++++++++++++++++++++---
 arch/x86/kvm/vmx/posted_intr.c           |   3 +-
 arch/x86/kvm/vmx/tdx.c                   | 381 +++++++++++++++++-
 arch/x86/kvm/vmx/tdx.h                   |  16 +
 arch/x86/kvm/vmx/tdx_arch.h              |  13 +
 arch/x86/kvm/vmx/x86_ops.h               |   6 +
 arch/x86/kvm/x86.c                       |   1 -
 arch/x86/kvm/x86.h                       |   2 +
 13 files changed, 1113 insertions(+), 63 deletions(-)
 create mode 100644 Documentation/virt/kvm/x86/intel-tdx.rst

-- 
2.46.0


