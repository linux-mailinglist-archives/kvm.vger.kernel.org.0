Return-Path: <kvm+bounces-33259-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 571C79E88D2
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2024 02:05:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 02B19188522F
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2024 01:05:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E443D22066;
	Mon,  9 Dec 2024 01:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mSLzkVlv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB114320B;
	Mon,  9 Dec 2024 01:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733706339; cv=none; b=Bbrjfz5p3vepSdM30qGNEa+qoXjx9eSHG3G0itFnPEaK/aTvHOB4ckq47FNXoCm+hbi+jwhm7bhmflpyGkA1BahWLCOBI7a1461Ti/7LtjH2JB6YIE7reMTMO//nsr92zIWERwthyercyFH4UvmKVbjGj3mKdlD6GAI2vG866Y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733706339; c=relaxed/simple;
	bh=sE5cgdFRZ0ThtBLfvL8yW8v8DMJ0bmmpXC7L2z6nGGQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=IFMO4Rtg6oIpke/KjNL7a7m0a8PC2OrcbSdn0V3xWYqqzhYv9VbITw3RXRvLIRRFOfnzc9vMoV+obxwEuLeFuuD5EUkN2ws+W0aGHS9QG9gPOmpRNweqhZAjO6oPjHHA3u8t80P62p9/WHlljwE3pS1beA5eJKkcmS+sfTPa4zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mSLzkVlv; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733706337; x=1765242337;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=sE5cgdFRZ0ThtBLfvL8yW8v8DMJ0bmmpXC7L2z6nGGQ=;
  b=mSLzkVlvZoPU+ZxPJC2sk+rcmoSGMmZCXuiKrtLl5JY44tFchgqUP9eW
   FBp80bw6SzCd7gacpHE1RmbQcJNNxeMSwS3I/NGWMnqm39Kjz0M4O/QB3
   OGKpdoezFK5YzAAL9Gq740DCiS5UYV129GTEkqA6TXEDG32yUVQvSXGP2
   lHcdUVlx6Ge4HMMCkts0kzMlIbYGf7sRfD2FZ5/q1MQtyZfE1wX/0QqzU
   4zK3+/JbQgAGSz9bq3kMSdrK3i1b6sYzjfBIK8fjtIFU8tHaJfucA3i/F
   gUnD/uAppJaTg23TC8OtCWEzfynKRyS8UEUoTRMz5ng+bWHU/2Z6lDU+r
   Q==;
X-CSE-ConnectionGUID: vz4FoNeGRICeZMPOo3b6Hw==
X-CSE-MsgGUID: LzhExxErTjiHzwaliqdZnw==
X-IronPort-AV: E=McAfee;i="6700,10204,11280"; a="36833673"
X-IronPort-AV: E=Sophos;i="6.12,218,1728975600"; 
   d="scan'208";a="36833673"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2024 17:05:36 -0800
X-CSE-ConnectionGUID: XKI4ESmIQTS8MU7AZhMoCA==
X-CSE-MsgGUID: TEyZsFs5Q8GWDvjHI54efw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,218,1728975600"; 
   d="scan'208";a="95402396"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2024 17:05:32 -0800
From: Binbin Wu <binbin.wu@linux.intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org
Cc: rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@linux.intel.com,
	isaku.yamahata@intel.com,
	yan.y.zhao@intel.com,
	chao.gao@intel.com,
	linux-kernel@vger.kernel.org,
	binbin.wu@linux.intel.com
Subject: [PATCH 00/16]  KVM: TDX: TDX interrupts
Date: Mon,  9 Dec 2024 09:07:14 +0800
Message-ID: <20241209010734.3543481-1-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi,

This patch series introduces the support of interrupt handling for TDX
guests, including virtual interrupt injection and VM-Exits caused by
vectored events.

This patch set is one of several patch sets that are all needed to provide
the ability to run a functioning TD VM. It is extracted from the section
"TD vcpu exits/interrupts/hypercalls" of the extensive 130-patch TDX base
enabling series[0]. We would like get maintainers/reviewers feedback of the
implementation of interrupt handling, especially the open about the virtual
NMI injection.

Base of this series
===================
This series is based off of a kvm-coco-queue commit and some pre-req series:
1. commit ee69eb746754 ("KVM: x86/mmu: Prevent aliased memslot GFNs") (in
   kvm-coco-queue).
2. v7 of "TDX host: metadata reading tweaks and bug fixes and info dump" [1]
3. v1 of "KVM: VMX: Initialize TDX when loading KVM module" [2]
4. v2 of “TDX vCPU/VM creation” [3]
5. v2 of "TDX KVM MMU part 2" [4]
6  v1 of "TDX vcpu enter/exit" [5] with a few fixups based on review feedbacks.
7. v4 of "KVM: x86: Prep KVM hypercall handling for TDX" [6]
8. v1 of "KVM: TDX: TDX hypercalls may exit to userspace" [7]

Opens to discuss
================
- NMI injection: VMM can't inject another pending NMI to TDX guest when
  there is already one pending NMI in the TDX module in a back-to-back
  way. The solution adopted in this patch series is if there is a further
  pending NMI in KVM, collapse it to the one pending in the TDX module.
  Refer to patch "KVM: TDX: Implement methods to inject NMI" for more
  details.
- NMI VM-Exit handling: Based on current TDX module, NMI is unblocked after
  SEAMRET from SEAM root mode to VMX root mode due to NMI VM-EXit. This is
  a TDX module bug, it could cause NMI handling order issue [8][9], which
  could lead to unknown NMI warning message or nested NMI. There is a
  internal discussion ongoing about the change of TDX module based on Sean's
  suggestion [8].
  This patch series puts the NMI VM-Exit handling in noinstr section, it
  can't completely prevent the order issue from happening, but if the code
  can be instrumented, the probability of the order issue could be bigger.
  Also, no code change needed if the NMIs are blocked after TD exit to KVM.

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

NMI
---
Similar to the VMX case, handle VM-Exit caused by NMIs within
tdx_vcpu_enter_exit(), i.e., handled before leaving the safety of noinstr.

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
In SEAM root mode (TDX module), all interrupts are blocked. If an SMI occurs
in SEAM non-root mode (TD guest), the SMI causes VM exit to TDX module, then
SEAMRET to KVM. Once it exits to KVM, SMI is delivered and handled by kernel
handler right away.
An SMI can be "I/O SMI" or "other SMI".  For TDX, there will be no I/O SMI
because I/O instructions inside TDX guest trigger #VE and TDX guest needs to
use TDVMCALL to request VMM to do I/O emulation.
For "other SMI", there are two cases:
- MSMI case.  When BIOS eMCA MCE-SMI morphing is enabled, the #MC occurs in
  TDX guest will be delivered as an MSMI.  It causes an EXIT_REASON_OTHER_SMI
  VM exit with MSMI (bit 0) set in the exit qualification.  On VM exit, TDX
  module checks whether the "other SMI" is caused by an MSMI or not.  If so,
  TDX module marks TD as fatal, preventing further TD entries, and then
  completes the TD exit flow to KVM with the TDH.VP.ENTER outputs indicating
  TDX_NON_RECOVERABLE_TD.  After TD exit, the MSMI is delivered and eventually
  handled by the kernel machine check handler (7911f14 x86/mce: Implement
  recovery for errors in TDX/SEAM non-root mode), i.e., the memory page is
  marked as poisoned and it won't be freed to the free list when the TDX
  guest is terminated.  Since the TDX guest is dead, follow other
  non-recoverable cases, exit to userspace.
- For non-MSMI case, KVM doesn't need to do anything, just continue TDX vCPU
  execution.

Notable changes since v19
=========================

NMI injection
-------------
If there is a further pending NMI in KVM, collapse it to the one pending in
the TDX module.

Always block INIT/SIPI
----------------------
INIT/SIPI events are always blocked for TDX, so this patch series removes the
unnecessary interfaces and helpers for INIT/SIPI delivery.

Check LVTT vector before waiting for lapic expiration
-----------------------------------------------------
To avoid unnecessary wait calls, only call kvm_wait_lapic_expire() when a
timer IRQ was injected, i.e., POSTED_INTR_ON is set and the vector for
LVTT is set in PIR.

Repos
=====
The full KVM branch is here:
https://github.com/intel/tdx/tree/tdx_kvm_dev-2024-11-20-exits-userspace

A matching QEMU is here:
https://github.com/intel-staging/qemu-tdx/tree/tdx-qemu-upstream-v6.1

Testing 
======= 
It has been tested as part of the development branch for the TDX base
series. The testing consisted of TDX kvm-unit-tests and booting a Linux
TD, and TDX enhanced KVM selftests.

[0] https://lore.kernel.org/kvm/cover.1708933498.git.isaku.yamahata@intel.com
[1] https://lore.kernel.org/kvm/cover.1731318868.git.kai.huang@intel.com
[2] https://lore.kernel.org/kvm/cover.1730120881.git.kai.huang@intel.com
[3] https://lore.kernel.org/kvm/20241030190039.77971-1-rick.p.edgecombe@intel.com
[4] https://lore.kernel.org/kvm/20241112073327.21979-1-yan.y.zhao@intel.com
[5] https://lore.kernel.org/kvm/20241121201448.36170-1-adrian.hunter@intel.com
[6] https://lore.kernel.org/kvm/20241128004344.4072099-1-seanjc@google.com
[7] https://lore.kernel.org/kvm/20241201035358.2193078-1-binbin.wu@linux.intel.com
[8] https://lore.kernel.org/kvm/Z0T_iPdmtpjrc14q@google.com
[9] https://lore.kernel.org/kvm/57aab3bf-4bae-4956-a3b7-d42e810556e3@linux.intel.com

Isaku Yamahata (13):
  KVM: VMX: Remove use of struct vcpu_vmx from posted_intr.c
  KVM: TDX: Disable PI wakeup for IPIv
  KVM: VMX: Move posted interrupt delivery code to common header
  KVM: TDX: Implement non-NMI interrupt injection
  KVM: TDX: Wait lapic expire when timer IRQ was injected
  KVM: TDX: Implement methods to inject NMI
  KVM: TDX: Complete interrupts after TD exit
  KVM: TDX: Handle SMI request as !CONFIG_KVM_SMM
  KVM: TDX: Always block INIT/SIPI
  KVM: TDX: Inhibit APICv for TDX guest
  KVM: TDX: Add methods to ignore virtual apic related operation
  KVM: TDX: Handle EXCEPTION_NMI and EXTERNAL_INTERRUPT
  KVM: TDX: Handle EXIT_REASON_OTHER_SMI

Sean Christopherson (3):
  KVM: TDX: Add support for find pending IRQ in a protected local APIC
  KVM: x86: Assume timer IRQ was injected if APIC state is protected
  KVM: VMX: Move NMI/exception handler to common helper

 arch/x86/include/asm/kvm-x86-ops.h |   1 +
 arch/x86/include/asm/kvm_host.h    |  13 +-
 arch/x86/include/asm/posted_intr.h |   5 +
 arch/x86/include/uapi/asm/vmx.h    |   1 +
 arch/x86/kvm/irq.c                 |   3 +
 arch/x86/kvm/lapic.c               |  16 +-
 arch/x86/kvm/lapic.h               |   2 +
 arch/x86/kvm/smm.h                 |   3 +
 arch/x86/kvm/vmx/common.h          | 143 +++++++++++++++
 arch/x86/kvm/vmx/main.c            | 286 ++++++++++++++++++++++++++---
 arch/x86/kvm/vmx/posted_intr.c     |  51 +++--
 arch/x86/kvm/vmx/posted_intr.h     |  13 ++
 arch/x86/kvm/vmx/tdx.c             | 137 +++++++++++++-
 arch/x86/kvm/vmx/tdx.h             |  16 ++
 arch/x86/kvm/vmx/vmx.c             | 144 ++-------------
 arch/x86/kvm/vmx/vmx.h             |  14 +-
 arch/x86/kvm/vmx/x86_ops.h         |  13 +-
 17 files changed, 677 insertions(+), 184 deletions(-)

-- 
2.46.0


