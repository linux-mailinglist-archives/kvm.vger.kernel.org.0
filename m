Return-Path: <kvm+bounces-38926-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 43267A404C1
	for <lists+kvm@lfdr.de>; Sat, 22 Feb 2025 02:41:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6E4F019E1262
	for <lists+kvm@lfdr.de>; Sat, 22 Feb 2025 01:41:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 272721DDA1B;
	Sat, 22 Feb 2025 01:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SkwpKLsv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C2C02F37;
	Sat, 22 Feb 2025 01:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740188455; cv=none; b=OELebd0zKj3EISImF6Q4alTyHQkHpvvelo1hpX2AaN8aoqCKtrzYDZcEolKrxERUfeTKgcX/Iq7RsUFFHddusA+c+ZtC4xmg5IURUavbTfD3xjSrIY2i6klEaIHnQnspxTYyoik8r/P2SyT2moXqF+lE3IN54j482JVhrvczAl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740188455; c=relaxed/simple;
	bh=JGond0o9Enkv6CDaMoiMQ3cTsRIW9uAw4u91ZbAjHPk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WwcgcjUEwZ5ckKuOCSpjl+2wXeonTjLv/hV1zENhoCXW8esJbNSyb6kwj6BgjIRk/yYpPfNHJDTbgGDEqdEG93sEqLhLc9FXi6NeJo3tbf6Fm0wmzbEaH5gXDJ/+KHU3uJu5hprQXyDsyIUwj0xXE0na/4SWzgf0u5S9GCYhIVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SkwpKLsv; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740188453; x=1771724453;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=JGond0o9Enkv6CDaMoiMQ3cTsRIW9uAw4u91ZbAjHPk=;
  b=SkwpKLsv+ebICaTQbVeLq5xQ2PfYDV6q+h9JDhsMICRhFJJq09TaDIMs
   oYWu9ZfL0dw4+oFV8kCaZBmFFY1Y50AeQfDmML/e7V4pA0Q1A5QvgiBNF
   neqOKkNNA3t8tH6yD0DOQ+dGsxdERxyWVZV4Jbb3xftbSp+ls7xowQ8br
   pkAW5731/YdBsJNzuVJzS1U8s8PqKkxssejw872zHG9rAJYfi4Yz9SEyS
   hIavy2hqSGVZMvbKzB7+dP7pNGvbxykcC3UmAQ8ZAtfskO+6Iu9JSZl7c
   C+Wv3ZjnmHd0Q1kKIOguaD06nfnmHdNj7TUGH2eVsMAgIniFlmab9KdmF
   g==;
X-CSE-ConnectionGUID: AckHM4QFTGGkKhIJXn6SrQ==
X-CSE-MsgGUID: 7hez98s8RxuGjFbuE2n7yg==
X-IronPort-AV: E=McAfee;i="6700,10204,11352"; a="40893243"
X-IronPort-AV: E=Sophos;i="6.13,306,1732608000"; 
   d="scan'208";a="40893243"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2025 17:40:52 -0800
X-CSE-ConnectionGUID: oOUYLlOZTHONte3vcfiIuw==
X-CSE-MsgGUID: dWstVZfRRaCqcnRfuaBISg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,306,1732608000"; 
   d="scan'208";a="146370220"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2025 17:40:49 -0800
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
Subject: [PATCH v3 0/9] KVM: TDX: TDX hypercalls may exit to userspace
Date: Sat, 22 Feb 2025 09:42:16 +0800
Message-ID: <20250222014225.897298-1-binbin.wu@linux.intel.com>
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
the ability to run a functioning TD VM.  We think this is in pretty good
shape at this point and ready for handoff to Paolo.


Base of this series
===================
This series is based on kvm-coco-queue up to the end of "TD vcpu
enter/exit". Stack is:
 - '3bd69dc8a4a9 ("KVM: x86: Add a switch_db_regs flag to handle TDX's
   auto-switched behavior")'.


Notable changes since v2 [1]
============================
Add a patch to move pv_unhaulted check out of kvm_vcpu_has_events().

Use kvm_vcpu_has_events() for checking pending interrupts when handling
TDG.VP.VMCALL<MapGPA>.

Only morph the limited TDCALL leafs, which are instruction-execution
sub-functions defined in TDX Guest-Host Communication Interface (GHCI)
specification [2] and implemented in KVM, to other VMX exit reasons.

Dump all 16 general-purpose registers to userspace when handling
TDG.VP.VMCALL<ReportFatalError>.


TDX hypercalls
==============
The TDX module specification defines TDG.VP.VMCALL API (TDVMCALL) for the
guest TDs to make hypercall to VMM.  When a guest TD issues a TDVMCALL, it
exits to VMM with a new exit reason.  The arguments from the guest TD and
return values from the VMM are passed through the guest registers.  The
ABI details for the guest TD hypercalls are specified in the TDX GHCI
specification.

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
[3], subsequent patches require changes to use new struct vcpu_vt, refer to
the full KVM branch below.

It requires TDX module 1.5.06.00.0744 [4], or later as mentioned in [3].
A working edk2 commit is 95d8a1c ("UnitTestFrameworkPkg: Use TianoCore
mirror of subhook submodule").

The full KVM branch is here:
https://github.com/intel/tdx/tree/tdx_kvm_dev-2025-02-21

A matching QEMU is here:
https://github.com/intel-staging/qemu-tdx/tree/tdx-qemu-wip-2025-02-18


Testing 
=======
It has been tested as part of the development branch for the TDX base
series. The testing consisted of TDX kvm-unit-tests and booting a Linux
TD, and TDX enhanced KVM selftests.

[1] https://lore.kernel.org/kvm/20250211025442.3071607-1-binbin.wu@linux.intel.com
[2] https://cdrdv2.intel.com/v1/dl/getContent/726792
[3] https://lore.kernel.org/kvm/20250129095902.16391-1-adrian.hunter@intel.com
[4] https://github.com/intel/tdx-module/releases/tag/TDX_1.5.06

Binbin Wu (4):
  KVM: x86: Have ____kvm_emulate_hypercall() read the GPRs
  KVM: x86: Move pv_unhaulted check out of kvm_vcpu_has_events()
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

 Documentation/virt/kvm/api.rst    |   9 +-
 arch/x86/include/asm/shared/tdx.h |   1 +
 arch/x86/include/asm/tdx.h        |   1 +
 arch/x86/include/uapi/asm/vmx.h   |   4 +-
 arch/x86/kvm/vmx/main.c           |  38 ++-
 arch/x86/kvm/vmx/tdx.c            | 524 +++++++++++++++++++++++++++++-
 arch/x86/kvm/vmx/tdx.h            |   5 +
 arch/x86/kvm/vmx/tdx_errno.h      |   3 +
 arch/x86/kvm/vmx/x86_ops.h        |   8 +
 arch/x86/kvm/x86.c                |  27 +-
 arch/x86/kvm/x86.h                |  26 +-
 include/linux/kvm_host.h          |   1 +
 include/uapi/linux/kvm.h          |   1 +
 virt/kvm/kvm_main.c               |   1 +
 14 files changed, 611 insertions(+), 38 deletions(-)

-- 
2.46.0


