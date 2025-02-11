Return-Path: <kvm+bounces-37787-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C7B1A301CD
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 03:57:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C41133A4BE7
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 02:56:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A4AC1D5AB8;
	Tue, 11 Feb 2025 02:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nQ3rOQnQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2C1126BDB3;
	Tue, 11 Feb 2025 02:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739242613; cv=none; b=JOdy/V8+AsLjgXn6rrDe7ubqkBcIf9P5A5ebscJKsXHbo9L/P1+7cZAbLlOTXca0h9qvKVq7gBGx7Sis+kb/fdfh/A+7j+QZmd35K9wOtM11KBCuNNJ7W62iG7l+iMRLO+QJg+Tt8k/0bX7iIrc44j88+wkrNrdgI0kK/+jX2FA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739242613; c=relaxed/simple;
	bh=drFbHHuUIZs0yvjOWJKD+MSxbdtSSBC+mwOH1lUeAA4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HBgommY6iv5nXBxAM/uKsQKvVXlRRQS1ZCHh5Pv6iRQl9lCauubwrsy+0XOXmZP97JPd7bnV2x103rbHW+lwgLJXF68ojfPrNRuwy6OpX1zqJF6uj+HCs6cKkEfhi1l6lnpoOC1xSXwK+47JPvUsPzKs5uXnPGtHYbtj3dsbDig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nQ3rOQnQ; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739242612; x=1770778612;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=drFbHHuUIZs0yvjOWJKD+MSxbdtSSBC+mwOH1lUeAA4=;
  b=nQ3rOQnQ+0/XDqetkFWawsSaRorXRX/62Vv9DZh4YsQLcL7f6TDuodDF
   XoU4vs6769E2lyMxkNZz4EI1EjP0nMVBwNRVDRqhjxuKI3z7+ggBpbZeZ
   KhP5K7EWS6PF8AxAEqWoNHlVLOBpErK0sSbZmf3l1Zmm6LNZubDjlfmoh
   2UqZ6wEE4n6gNgE+L9dLIYkVQ/MEjy2bOyUjH+c1THI8nYKyZRwXgFeKg
   RK4LuJ5GtAp5sEplM9qibSX4WrKwTNlcJ32vJ/jlqXf/E1p2TiUNMc5Kp
   Zju7oywXVOFuC/n2MVzFa4vaCJf3YJQ4xCjmlUOT+9s6HZ6+zTJ3p1M9i
   A==;
X-CSE-ConnectionGUID: KhOM8vvbT+KWg5mNATA40A==
X-CSE-MsgGUID: begQOsxKQwmcJx4AGOcieA==
X-IronPort-AV: E=McAfee;i="6700,10204,11341"; a="43612418"
X-IronPort-AV: E=Sophos;i="6.13,276,1732608000"; 
   d="scan'208";a="43612418"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2025 18:56:52 -0800
X-CSE-ConnectionGUID: hRpPb8FGTYySr7TJTlVXkQ==
X-CSE-MsgGUID: IvumfHUsRYG8B/GfMXFz7Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,276,1732608000"; 
   d="scan'208";a="112355211"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2025 18:56:47 -0800
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
Subject: [PATCH v2 00/17] KVM: TDX: TDX interrupts
Date: Tue, 11 Feb 2025 10:58:11 +0800
Message-ID: <20250211025828.3072076-1-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

This patch series introduces the support of interrupt handling for TDX
guests, including virtual interrupt injection and VM-Exits caused by
vectored events.

This patch set is one of several patch sets that are all needed to provide
the ability to run a functioning TD VM. We think this is in pretty good
shape at this point, but it probably needs another round of review before
hand off. We would appreciate review from Sean on the implementation of the
APICv feedback [1].


Base of this series
===================
This series is based on kvm-coco-queue up to the end of MMU part 2, plus
two later sections. Stack is:
  - '55f78d925e07 ("KVM: TDX: Return -EBUSY when tdh_mem_page_add()
    encounters TDX_OPERAND_BUSY")'.
  - v2 of "KVM: TDX: TD vcpu enter/exit" (There is one small log difference
    between the v2 patches and the commits in kvm-coco-queue. No code
    differences). 
  - v2 of "KVM: TDX: TDX hypercalls may exit to userspace"


Notable changes since v1 [2]
============================
Enforce APICv active for TDX guests from the view of KVM, which was
suggested by Sean in one PUCK session, because it is not concept right to
"lie" to KVM that APICv is disabled while it is actually enabled. Instead,
it's better to make APICv enabled and prevent it from being disabled from
the view of KVM. More details can be found in the discussion thread [1].
For this purpose, additional checks are implemented:
- Check enable_apicv in tdx_bringup().
- Reject KVM_{GET,SET}_LAPIC from userspace, thus it requires the code
  change in QEMU to skip request KVM_{GET,SET}_LAPIC.
- Implement vt_refresh_apicv_exec_ctrl() to bug the VM if APICv is
  disabled.

Enforce KVM_IRQCHIP_SPLIT for TDX guests to disallow in-kernel I/O APIC
while in-kernel local APIC is needed.

Unify the code to handle NMIs and external interrupts.

WARN on init event for TDX vCPU.

Drop vt_hwapic_irr_update() since .hwapic_irr_update() is gone in 6.14.

Also, there is an new information update about NMI blocked status after
exiting from TDX guest for NMI-induced exits in "NMI" part of section
"VM-Exits caused by vectored event" below.


Virtual interrupt injection
===========================
Non-NMI Interrupt
-----------------
TDX supports non-NMI interrupt injection only by posted interrupt. Posted
interrupt descriptors (PIDs) are allocated in shared memory, KVM can update
them directly. To post pending interrupts in the PID, KVM can generate a
self-IPI with notification vector prior to TD entry.
TDX guest status is protected, KVM can't get the interrupt status of TDX
guest. In this series, assumes interrupt is always allowed. A later patch
set will have the support for TDX guest to call TDVMCALL with HLT, which
passes the interrupt block flag, so that whether interrupt is allowed in
HLT will checked against the interrupt block flag.

NMI
---
KVM can request the TDX module to inject a NMI into a TDX vCPU by setting
the PEND_NMI TDVPS field to 1. Following that, KVM can call TDH.VP.ENTER to
run the vCPU and the TDX module will attempt to inject the NMI as soon as
possible.
PEND_NMI TDVPS field is a 1-bit filed, i.e. KVM can only pend one NMI in
the TDX module. Also, TDX doesn't allow KVM to request NMI-window exit
directly. When there is already one NMI pending in the TDX module, i.e. it
has not been delivered to TDX guest yet, if there is NMI pending in KVM,
collapse the pending NMI in KVM into the one pending in the TDX module.
Such collapse is OK considering on X86 bare metal, multiple NMIs could
collapse into one NMI, e.g. when NMI is blocked by SMI.  It's OS's
responsibility to poll all NMI sources in the NMI handler to avoid missing
handling of some NMI events. More details can be found in the changelog of
the patch "KVM: TDX: Implement methods to inject NMI".

SMI
---
TDX doesn't support system-management mode (SMM) and system-management
interrupt (SMI) in guest TDs because TDX module doesn't provide a way for
VMM to inject SMI into guest TD or switch guest vCPU mode into SMM. Handle
SMI request as what KVM does for CONFIG_KVM_SMM=n, i.e. return -ENOTTY,
and add KVM_BUG_ON() to SMI related OPs for TD.

INIT/SIPI event
----------------
TDX defines its own vCPU creation and initialization sequence including
multiple SEAMCALLs.  Also, it's only allowed during TD build time. Always
block INIT and SIPI events for the TDX guest.


VM-Exits caused by vectored event
=================================
NMI (with *new update*)
-----------------------
Just like the VMX case, NMI remains blocked after exiting from TDX guest
for NMI-induced exits [*], handle VM-Exit caused by NMIs within
tdx_vcpu_enter_exit(), i.e., handled before leaving the safety of noinstr.

[*]: Old TDX modules may have a bug which makes NMI unblocked after exiting
from TDX guest for NMI-induced exits.  This could potentially lead to
nested NMIs: a new NMI arrives when KVM is manually calling the host NMI
handler.  This is an architectural violation, but it doesn't have real harm
until FRED is enabled together with TDX (for non-FRED, the host NMI handler
can handle nested NMIs).  Given this is rare to happen and has no real
harm, ignore this for the initial TDX support.
For the new TDX modules that fixed the bug, NMIs are blocked after exiting
from TDX guest for NMI-induced exits, which is the default behavior and no
"opt-in" is needed. This is aligned with the suggestion made by Sean [3].

External Interrupt
------------------
Similar to the VMX case, external interrupts are handled in
.handle_exit_irqoff() callback.

Exception
---------
Machine check, which is handled in the .handle_exit_irqoff() callback, is
the only exception type KVM handles for TDX guests. For other exceptions,
because TDX guest state is protected, exceptions in TDX guests can't be
intercepted. TDX VMM isn't supposed to handle these exceptions. Exit to
userspace with KVM_EXIT_EXCEPTION If unexpected exception occurs.

SMI
---
In SEAM root mode (TDX module), all interrupts are blocked. If an SMI
occurs in SEAM non-root mode (TD guest), the SMI causes VM exit to TDX
module, then SEAMRET to KVM. Once it exits to KVM, SMI is delivered and
handled by kernel handler right away.
An SMI can be "I/O SMI" or "other SMI".  For TDX, there will be no I/O SMI
because I/O instructions inside TDX guest trigger #VE and TDX guest needs
to use TDVMCALL to request VMM to do I/O emulation.
For "other SMI", there are two cases:
- MSMI case.  When BIOS eMCA MCE-SMI morphing is enabled, the #MC occurs in
  TDX guest will be delivered as an MSMI.  It causes an
  EXIT_REASON_OTHER_SMI VM exit with MSMI (bit 0) set in the exit
  qualification.  On VM exit, TDX module checks whether the "other SMI" is
  caused by an MSMI or not.  If so, TDX module marks TD as fatal,
  preventing further TD entries, and then completes the TD exit flow to KVM
  with the TDH.VP.ENTER outputs indicating TDX_NON_RECOVERABLE_TD.  After
  TD exit, the MSMI is delivered and eventually handled by the kernel
  machine check handler (7911f14 x86/mce: Implement recovery for errors in
  TDX/SEAM non-root mode), i.e., the memory page is marked as poisoned and
  it won't be freed to the free list when the TDX guest is terminated.
  Since the TDX guest is dead, follow other non-recoverable cases, exit to
  userspace.
- For non-MSMI case, KVM doesn't need to do anything, just continue TDX
  vCPU execution.


Repos
=====
Due to "KVM: VMX: Move common fields of struct" in "TDX vcpu enter/exit" v2
[4], subsequent patches require changes to use new struct vcpu_vt, refer to
the full KVM branch below.

It requires TDX module 1.5.06.00.0744 [5], or later as mentioned in [4].
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

[1] https://lore.kernel.org/kvm/Z4VKdbW1R0AoLvkB@google.com
[2] https://lore.kernel.org/kvm/20241209010734.3543481-1-binbin.wu@linux.intel.com
[3] https://lore.kernel.org/kvm/Z0T_iPdmtpjrc14q@google.com
[4] https://lore.kernel.org/kvm/20250129095902.16391-1-adrian.hunter@intel.com
[5] https://github.com/intel/tdx-module/releases/tag/TDX_1.5.06

Binbin Wu (2):
  KVM: TDX: Enforce KVM_IRQCHIP_SPLIT for TDX guests
  KVM: VMX: Move emulation_required to struct vcpu_vt

Isaku Yamahata (12):
  KVM: TDX: Disable PI wakeup for IPIv
  KVM: VMX: Move posted interrupt delivery code to common header
  KVM: TDX: Implement non-NMI interrupt injection
  KVM: TDX: Wait lapic expire when timer IRQ was injected
  KVM: TDX: Implement methods to inject NMI
  KVM: TDX: Complete interrupts after TD exit
  KVM: TDX: Handle SMI request as !CONFIG_KVM_SMM
  KVM: TDX: Always block INIT/SIPI
  KVM: TDX: Force APICv active for TDX guest
  KVM: TDX: Add methods to ignore virtual apic related operation
  KVM: TDX: Handle EXCEPTION_NMI and EXTERNAL_INTERRUPT
  KVM: TDX: Handle EXIT_REASON_OTHER_SMI

Sean Christopherson (3):
  KVM: TDX: Add support for find pending IRQ in a protected local APIC
  KVM: x86: Assume timer IRQ was injected if APIC state is protected
  KVM: VMX: Add a helper for NMI handling

 arch/x86/include/asm/kvm-x86-ops.h |   1 +
 arch/x86/include/asm/kvm_host.h    |   1 +
 arch/x86/include/asm/posted_intr.h |   5 +
 arch/x86/include/uapi/asm/vmx.h    |   1 +
 arch/x86/kvm/irq.c                 |   3 +
 arch/x86/kvm/lapic.c               |  14 +-
 arch/x86/kvm/lapic.h               |   2 +
 arch/x86/kvm/smm.h                 |   3 +
 arch/x86/kvm/vmx/common.h          |  74 ++++++++
 arch/x86/kvm/vmx/main.c            | 262 ++++++++++++++++++++++++++---
 arch/x86/kvm/vmx/nested.c          |   2 +-
 arch/x86/kvm/vmx/posted_intr.c     |   9 +-
 arch/x86/kvm/vmx/posted_intr.h     |   2 +
 arch/x86/kvm/vmx/tdx.c             | 145 +++++++++++++++-
 arch/x86/kvm/vmx/tdx.h             |   5 +
 arch/x86/kvm/vmx/vmx.c             | 113 +++----------
 arch/x86/kvm/vmx/vmx.h             |   1 -
 arch/x86/kvm/vmx/x86_ops.h         |  12 ++
 arch/x86/kvm/x86.c                 |   6 +
 19 files changed, 541 insertions(+), 120 deletions(-)

-- 
2.46.0


