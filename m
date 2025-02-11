Return-Path: <kvm+bounces-37778-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E58BDA301B3
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 03:53:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 864DC3A6888
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 02:53:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 661E41D54EE;
	Tue, 11 Feb 2025 02:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="A73IPHMZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92F4F26BDB3;
	Tue, 11 Feb 2025 02:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739242387; cv=none; b=mXzO5AxVrQlqQvRrFCN22/AsCdjNFt0GynOFXG9bNFhgmuG8MQ5f7KTSW5c/mti0QUYW4iM3kiYd5Y3aWzujC774SaT/0UhwD8E4eej51ZNxOTJvo6GzetLNvT7L2Wsg2Hd+iiQyfwS9WUwxkkac7hvnV5RSWaAoq41Nur6Ckxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739242387; c=relaxed/simple;
	bh=2SebiFEbnENaz2k05BNHEb4S8UUpgFqWp3K6SdhX0Qo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fHxZZnJPtiwIwDwN38UsmlOOzziO1CGESKMC9Y0x5fLGdJYSBEmV1kjHdDoCUENmtWjgvIhUjgqG+6xNo5LPkapY00BuxUB5YFjPZ3tUCS7cG0hj6yplB0gPagxAOlMGAdSdZZtcVgzGE1VcmzJH8mTCrIcDZWWUa5F5qEVK+sI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=A73IPHMZ; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739242386; x=1770778386;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=2SebiFEbnENaz2k05BNHEb4S8UUpgFqWp3K6SdhX0Qo=;
  b=A73IPHMZZdgBGKJk+IYgPWYtmAYJRZjZ6zkPABzn7geXvR+ccVe/ofNM
   SPUyX92KK4BclrF4/r2EZqGNcHu4BcmheslrzUeLjQf9AuTi+4XHtlObz
   asuCQFtP2BY3lvJja2mjN5W7Se0q9+wsbsfNdfeER+KIOtOHxUu8gvkeZ
   1qJcxMh+Pvm4nsYvqWLx8CMtZwpNXv8cu4eTxM1y+nTa3pNAhdZNuErnu
   ZLmXKhN29EK3wMxH1QSPCtgyGiUQIxwG303veDOh5qcvxoYP4C4bgttXP
   mbUs1keR5cxZwVhIIanfD8DPSpPjHVkeTXSYmsI0OTZ7GZT/9dGdG2Rhm
   g==;
X-CSE-ConnectionGUID: hTD7Y1U1R0CHfPbmXq4syA==
X-CSE-MsgGUID: pLvSBbTNTS2mmR22kOOPyw==
X-IronPort-AV: E=McAfee;i="6700,10204,11341"; a="43506582"
X-IronPort-AV: E=Sophos;i="6.13,276,1732608000"; 
   d="scan'208";a="43506582"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2025 18:53:06 -0800
X-CSE-ConnectionGUID: Rq20ttWbQSydYuxflqOajw==
X-CSE-MsgGUID: T7q24sn1RRiw5kva2ViF/g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="112236396"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2025 18:53:01 -0800
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
Subject: [PATCH v2 0/8] KVM: TDX: TDX hypercalls may exit to userspace
Date: Tue, 11 Feb 2025 10:54:34 +0800
Message-ID: <20250211025442.3071607-1-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

When executing in the TD, TDX can exit to the host VMM (KVM) for many
reasons. These reasons are analogous to the exit reasons for VMX. Some of
the exits will be handled within KVM in later changes. This series handles
just the TDX exits that may be passed to userspace to handle, which are all
via the TDCALL exit code. Although, these userspace exits have the same TDX
exit code, they result in several different types of exits to userspace.

This patch set is one of several patch sets that are all needed to provide
the ability to run a functioning TD VM.  With v2, we have addressed the
structural changes suggested by Sean [1] to make TDX exit handling more VMX
like. With the size of the change, it probably needs another round of
review before being ready for kvm-coco-queue.

Base of this series
===================
This series is based on kvm-coco-queue up to the end of MMU part 2, plus
one later section. Stack is:
  - '55f78d925e07 ("KVM: TDX: Return -EBUSY when tdh_mem_page_add()
    encounters TDX_OPERAND_BUSY")'.
  - v2 "KVM: TDX: TD vcpu enter/exit" (There is one small log difference
    between the v2 patches and the commits in kvm-coco-queue. No code
    differences). 


Notable changes since v1 [2]
============================
Record vmx exit reason and exit_qualification in struct vcpu_vt for TDX,
so that TDX/VMX can use the same helpers to get exit reason and exit
qualification.

Get/set tdvmcall inputs/outputs from/to vp_enter_args directly in struct
vcpu_tdx. Drop helpers for read/write a0~a3.

Skip setting of return code when the value is TDVMCALL_STATUS_SUCCESS
because r10 is always 0 for standard TDVMCALL exit.

Morph the guest requested exit reason (via TDVMCALL) to KVM's tracked exit
reason when it could, i.e. when the TDVMCALL leaf number is less than
0x10000.
- Morph the TDG.VP.VMCALL with KVM hypercall to EXIT_REASON_VMCALL.
- Morph PV port I/O hypercall to EXIT_REASON_IO_INSTRUCTION.
- Morph PV MMIO hypercall to EXIT_REASON_EPT_MISCONFIG.

TDX marshalls registers of TDVMCALL ABI into KVM's x86 registers to match
the definition of KVM hypercall ABI _before_ ____kvm_emulate_hypercall()
gets called. Also, "KVM: x86: Have ____kvm_emulate_hypercall() read the
GPRs" is added as a preparation patch for the change.

Zero run->hypercall.ret in __tdx_map_gpa() following the pattern of Paolo's
patch [3], the feedback of adding a helper is still pending.

Combine TDX_OPERAND_BUSY for TDX_OPERAND_ID_TD_EPOCH and
TDX_OPERAND_ID_SEPT.  Use EXIT_FASTPATH_EXIT_HANDLED instead of
EXIT_FASTPATH_REENTER_GUEST for TDX_OPERAND_BUSY because when KVM requests
KVM_REQ_OUTSIDE_GUEST_MODE, which has both KVM_REQUEST_WAIT and
KVM_REQUEST_NO_ACTION set, it requires target vCPUs leaving fastpath so
that interrupt can be enabled to ensure the IPIs can be delivered. Return
EXIT_FASTPATH_EXIT_HANDLED instead of EXIT_FASTPATH_REENTER_GUEST to exit
fastpath, otherwise, the requester may be blocked endlessly.

Remove the code for reading/writing APIC mmio, since TDX guest supports
x2APIC only.


TDX hypercalls
==============
The TDX module specification defines TDG.VP.VMCALL API (TDVMCALL) for the
guest TDs to make hypercall to VMM.  When a guest TD issues a TDVMCALL, it
exits to VMM with a new exit reason.  The arguments from the guest TD and
return values from the VMM are passed through the guest registers.  The
ABI details for the guest TD hypercalls are specified in the TDX Guest-Host
Communication Interface (GHCI) specification [4].

There are two types of hypercalls defined in the GHCI specification:
- Standard TDVMCALLs: When input of R10 from guest TD is set to 0, it
  indicates that the TDVMCALL sub-function used in R11 is defined in GHCI
  specification.
- Vendor-Specific TDVMCALLs: When input of R10 from guest TD is non-zero,
  it indicates a vendor-specific TDVMCALL. For KVM hypercalls from guest
  TDs, KVM uses R10 as KVM hypercall number and R11-R14 as 4 arguments,
  with the error code returned in R10.

KVM hypercalls
--------------
This series supports KVM hypercalls from guest TDs following the 
vendor-specific interface described above.  The KVM_HC_MAP_GPA_RANGE
hypercall will need to exit to userspace for handling.

Standard TDVMCALLs exiting to userspace
---------------------------------------
To support basic functionality of TDX,  this series includes the following
standard TDVMCALL sub-functions, which reuse exist exit reasons when they
need to exit to userspace for handling:
- TDG.VP.VMCALL<MapGPA> reuses exit reason KVM_EXIT_HYPERCALL with the
  hypercall number KVM_HC_MAP_GPA_RANGE.
- TDG.VP.VMCALL<ReportFatalError> reuses exit reason KVM_EXIT_SYSTEM_EVENT
  with a new event type KVM_SYSTEM_EVENT_TDX_FATAL.
- TDG.VP.VMCALL<Instruction.IO> reuses exit reason KVM_EXIT_IO.
- TDG.VP.VMCALL<#VE.RequestMMIO> reuses exit reason KVM_EXIT_MMIO.

Support for TD attestation is currently excluded from the TDX basic
enabling, so handling for TDG.VP.VMCALL<SetupEventNotifyInterrupt> and
TDG.VP.VMCALL<GetQuote> is not included in this patch series.


Repos
=====
Due to "KVM: VMX: Move common fields of struct" in "TDX vcpu enter/exit" v2
[5], subsequent patches require changes to use new struct vcpu_vt, refer to
the full KVM branch below.

It requires TDX module 1.5.06.00.0744 [6], or later as mentioned in [5].
A working edk2 commit is 95d8a1c ("UnitTestFrameworkPkg: Use TianoCore
mirror of subhook submodule").

The full KVM branch is here:
https://github.com/intel/tdx/tree/tdx_kvm_dev-2025-02-10

A matching QEMU is here:
https://github.com/intel-staging/qemu-tdx/tree/tdx-qemu-upstream-v7


Testing 
=======
It has been tested as part of the development branch for the TDX base
series. The testing consisted of TDX kvm-unit-tests and booting a Linux
TD, and TDX enhanced KVM selftests.

[1] https://lore.kernel.org/kvm/Z1suNzg2Or743a7e@google.com
[2] https://lore.kernel.org/kvm/20241201035358.2193078-1-binbin.wu@linux.intel.com
[3] https://lore.kernel.org/kvm/20241213194137.315304-1-pbonzini@redhat.com
[4] https://cdrdv2.intel.com/v1/dl/getContent/726792
[5] https://lore.kernel.org/kvm/20250129095902.16391-1-adrian.hunter@intel.com
[6] https://github.com/intel/tdx-module/releases/tag/TDX_1.5.06


Binbin Wu (3):
  KVM: x86: Have ____kvm_emulate_hypercall() read the GPRs
  KVM: TDX: Handle TDG.VP.VMCALL<MapGPA>
  KVM: TDX: Handle TDG.VP.VMCALL<ReportFatalError>

Isaku Yamahata (4):
  KVM: TDX: Add a place holder to handle TDX VM exit
  KVM: TDX: Add a place holder for handler of TDX hypercalls
    (TDG.VP.VMCALL)
  KVM: TDX: Handle KVM hypercall with TDG.VP.VMCALL
  KVM: TDX: Handle TDX PV port I/O hypercall

Sean Christopherson (1):
  KVM: TDX: Handle TDX PV MMIO hypercall

 Documentation/virt/kvm/api.rst    |   9 +
 arch/x86/include/asm/shared/tdx.h |   1 +
 arch/x86/include/asm/tdx.h        |   1 +
 arch/x86/include/uapi/asm/vmx.h   |   4 +-
 arch/x86/kvm/vmx/main.c           |  38 ++-
 arch/x86/kvm/vmx/tdx.c            | 532 +++++++++++++++++++++++++++++-
 arch/x86/kvm/vmx/tdx.h            |   5 +
 arch/x86/kvm/vmx/tdx_errno.h      |   3 +
 arch/x86/kvm/vmx/x86_ops.h        |   8 +
 arch/x86/kvm/x86.c                |  16 +-
 arch/x86/kvm/x86.h                |  26 +-
 include/uapi/linux/kvm.h          |   1 +
 virt/kvm/kvm_main.c               |   1 +
 13 files changed, 616 insertions(+), 29 deletions(-)

-- 
2.46.0


