Return-Path: <kvm+bounces-32315-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E3589D53C0
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 21:15:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 056071F22965
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 20:15:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D85D31C230E;
	Thu, 21 Nov 2024 20:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Nloe853c"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EACF11CD1EE;
	Thu, 21 Nov 2024 20:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732220112; cv=none; b=Ruw70uOfyhrkvw8W23gbNoK7BKnIRp3wGEpKyt1dIiqPlTBZURnUD7FXtN3k1pSBCrRdp//6OB+uUfRLM2dRt75Of6X2DH9KFBuJJ/N+0h1A9Euk0zW+Nx3BV9EtYUhkQeLNg3RrHDDFFf4Lqkb0wd8JkbGzBTZYIta8Ws4TBDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732220112; c=relaxed/simple;
	bh=fhWu3do1FaQ1TjGwNgvB+EioEnbqtAJ1lpjLarsm/K8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=X9Ijz8bfEwzvUWEjXERHEGv9cRIMTqldT9L6VMa/mXaxb6RbirSyLqaHU1zwqIqltumZ5Nb9G7W4ZYHJhScj2Xe0A7+A95OF1xN597g8DnHnpdsjh/jVvvbBFV23zxdF5L8K4DzkoC6eeylaG4gDQYdh09g2N0P4EfM29TcUZho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Nloe853c; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732220110; x=1763756110;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=fhWu3do1FaQ1TjGwNgvB+EioEnbqtAJ1lpjLarsm/K8=;
  b=Nloe853cORTz7w+DO3tdVk1SiBvgXPTMtcGof49DO1oZB5yA3lyj1iwj
   Ek8uT8s8deQn8cq8lVGROFaEoPNIfCvc9Wr8HSVEH8Gh2NEtQbIAEadfC
   1nTv0QhLnSCM/3mOQAJdhRMIr/zrQ02gD3KJntPqcNue7jcVhtPJ4Lvz1
   csqNRV+6K1voUEM5jfRuZTkJnFAUJTeIwvnZY0b6XLuV/499aAOWAIqlF
   hDDh3HGonrx8CwkI+s8LzXJr7dqPdWwhlBT22oZSSZf4PUjyvHQlFH4sZ
   XXGGq11lNaS3EJOgvM7ktKLzgMe3rQhywiCUe8EcRT5zN9T6s+jlY830t
   w==;
X-CSE-ConnectionGUID: XX1obg+OQaK+oeeD3aq6Og==
X-CSE-MsgGUID: TJDpTJO1SmaWgjI8meSG3A==
X-IronPort-AV: E=McAfee;i="6700,10204,11263"; a="31715830"
X-IronPort-AV: E=Sophos;i="6.12,173,1728975600"; 
   d="scan'208";a="31715830"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2024 12:15:09 -0800
X-CSE-ConnectionGUID: GVbgxKuBQz2zTbNB9NYr3g==
X-CSE-MsgGUID: nb4lbBd5RG2a/D65xO07wA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,173,1728975600"; 
   d="scan'208";a="90161060"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO ahunter-VirtualBox.ger.corp.intel.com) ([10.246.16.81])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2024 12:15:03 -0800
From: Adrian Hunter <adrian.hunter@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org,
	dave.hansen@linux.intel.com
Cc: rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@linux.intel.com,
	binbin.wu@linux.intel.com,
	dmatlack@google.com,
	isaku.yamahata@intel.com,
	nik.borisov@suse.com,
	linux-kernel@vger.kernel.org,
	x86@kernel.org,
	yan.y.zhao@intel.com,
	chao.gao@intel.com,
	weijiang.yang@intel.com
Subject: [PATCH 0/7] KVM: TDX: TD vcpu enter/exit
Date: Thu, 21 Nov 2024 22:14:39 +0200
Message-ID: <20241121201448.36170-1-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi

This patch series introduces callbacks to facilitate the entry of a TD VCPU
and the corresponding save/restore of host state.

There are some outstanding things still to do (see below), so we expect to
post future revisions of this patch set, but please do review the current
patches so that they can be made ready for hand off to Paolo.  Also
direction is needed for "x86/virt/tdx: Add SEAMCALL wrapper to enter/exit
TDX guest" because it will affect KVM.

This patch set is one of several patch sets that are all needed to provide
the ability to run a functioning TD VM.  They have been split from the
"marker" sections of patch set "[PATCH v19 000/130] KVM TDX basic feature
support":

  https://lore.kernel.org/all/cover.1708933498.git.isaku.yamahata@intel.com/

The recent patch sets are:

  TDX host: metadata reading
  TDX vCPU/VM creation
  TDX KVM MMU part 2
  TD vcpu enter/exit			<- this one
  TD vcpu exits/interrupts/hypercalls   <- still to come

Notably, a later patch sets deal with VCPU exits, interrupts and
hypercalls.

For x86 maintainers

This series has 1 commit that is an RFC that needs input from x86
maintainers:

  x86/virt/tdx: Add SEAMCALL wrapper to enter/exit TDX guest

This is because wrapping TDH.VP.ENTER means dealing with multiple input and
output formats for the data in argument registers. We would like
maintainers to comment on the discussion that we will have on it.

Overview

A TD VCPU is entered via the SEAMCALL TDH.VP.ENTER. The TDX Module manages
the save/restore of guest state and, in conjunction with the SEAMCALL
interface, handles certain aspects of host state. However, there are
specific elements of the host state that require additional attention, as
detailed in the Intel TDX ABI documentation for TDH.VP.ENTER.

TDX is quite different from VMX in this regard.  For VMX, the host VMM is
heavily involved in restoring, managing and saving guest CPU state, whereas
for TDX this is handled by the TDX Module.  In that way, the TDX Module can
protect the confidentiality and integrity of TD CPU state.

The TDX Module does not save/restore all host CPU state because the host
VMM can do it more efficiently and selectively.  CPU state referred to
below is host CPU state.  Often values are already held in memory so no
explicit save is needed, and restoration may not be needed if the kernel
is not using a feature.

Outstanding things still to do:

  - how to wrap TDH.VP.ENTER SEAMCALL, refer to patch "x86/virt/tdx:
    Add SEAMCALL wrapper to enter/exit TDX guest"
  - tdx_vcpu_enter_exit() calls guest_state_enter_irqoff()
    and guest_state_exit_irqoff() which comments say should be
    called from non-instrumentable code but noinst was removed
    at Sean's suggestion:
  	https://lore.kernel.org/all/Zg8tJspL9uBmMZFO@google.com/
    noinstr is also needed to retain NMI-blocking by avoiding
    instrumented code that leads to an IRET which unblocks NMIs.
    A later patch set will deal with NMI VM-exits.
  - disallow TDX guest to use Intel PT
  	I think Tony will fix tdx_get_supported_xfam()
  - disallow PERFMON (TD attribute bit 63)
  - save/restore MSR IA32_UMWAIT_CONTROL or disallow guest
    CPUID(7,0).ECX.WAITPKG[5]
  - save/restore IA32_DEBUGCTL
  	VMX does:
  		vmx_vcpu_load() -> get_debugctlmsr()
  		vmx_vcpu_run() -> update_debugctlmsr()
  	TDX Module only preserves bits 1, 12 and 14

Key Details

Argument Passing: Similar to other SEAMCALLs, TDH.VP.ENTER passes
arguments through General Purpose Registers (GPRs). For the special case
of the TD guest invoking TDG.VP.VMCALL, nearly any GPR can be used,
as well as XMM0 to XMM15. Notably, RBP is not used, and Linux mandates the
TDX Module feature NO_RBP_MOD, which is enforced elsewhere. Additionally,
XMM registers are not required for the existing Guest Hypervisor
Communication Interface and are handled by existing KVM code should they be
modified by the guest.

Debug Register Handling: After TDH.VP.ENTER returns, registers DR0, DR1,
DR2, DR3, DR6, and DR7 are set to their architectural INIT values. Existing
KVM code already handles the restoration of host values as needed, refer
vcpu_enter_guest() which calls hw_breakpoint_restore().

MSR Restoration: Certain Model-Specific Registers (MSRs) need to be
restored post TDH.VP.ENTER. The Intel TDX ABI documentation provides a
detailed list in the msr_preservation.json file. Most MSRs do not require
restoration if the guest is not utilizing the corresponding feature. The
following features are currently assumed to be unsupported, and their MSRs
are not restored:
  PERFMON            (TD ATTRIBUTES[63])
  LBRs               (XFAM[15])
  User Interrupts    (XFAM[14])
  Intel PT           (XFAM[8])
The one feature that is supported:
  CET                (XFAM[11-12])	is restored via kvm_put_guest_fpu()

Other host MSR/Register Handling:

MSR IA32_XFD is already restored by KVM, refer to kvm_put_guest_fpu().
The TDX Module sets MSR IA32_XFD_ERR to its RESET value (0) which is
fine for the kernel.

MSR IA32_DEBUGCTL appears to have been overlooked.  According to
msr_preservation.json, the TDX Module preserves only bits 1, 12 and 14.
For VMX there is code to save and restore in vmx_vcpu_load() and
vmx_vcpu_run() respectively, but TDX does not use those functions.

MSR IA32_UARCH_MISC_CTL is not utilized by the kernel, so it is fine if
the TDX Module sets it to it's RESET value.

MSR IA32_KERNEL_GS_BASE is addressed in patch "KVM: TDX: vcpu_run:
save/restore host state (host kernel gs)".

MSRs IA32_XSS and XCRO are handled in patch "KVM: TDX: restore host xsave
state when exiting from the guest TD".

MSRs IA32_STAR, IA32_LSTAR, IA32_FMASK, and IA32_TSC_AUX are handled in
patch "KVM: TDX: restore user ret MSRs".

MSR IA32_TSX_CTRL is handled in patch "KVM: TDX: Add TSX_CTRL msr into
uret_msrs list".

MSR IA32_UMWAIT_CONTROL appears to have been overlooked.  The host value
needs to be restored if guest CPUID(7,0).ECX.WAITPKG[5] is 1, otherwise
that guest CPUID value needs to be disallowed.

Additional Notes

The patch "KVM: TDX: Implement TDX vcpu enter/exit path" highlights that
TDX does not support "PAUSE-loop exiting".  According to the TDX Module
Base arch. spec., hypercalls are expected to be used instead.  Note that
the Linux TDX guest supports existing hypercalls via TDG.VP.VMCALL.

Base

This series is based off of a kvm-coco-queue commit and some pre-req
series:
1. commit ee69eb746754 ("KVM: x86/mmu: Prevent aliased memslot GFNs") (in
   kvm-coco-queue).
2. v7 of "TDX host: metadata reading tweaks, bug fix and info dump" [1].
3. v1 of "KVM: VMX: Initialize TDX when loading KVM module" [2], with some
   new feedback from Sean.
4. v2 of “TDX vCPU/VM creation” [3]
5. v2 of "TDX KVM MMU part 2" [4]

It requires TDX module 1.5.06.00.0744[5], or later. This is due to removal
of the workarounds for the lack of the NO_RBP_MOD feature required by the
kernel. Now NO_RBP_MOD is enabled (in VM/vCPU creation patches), and this
particular version of the TDX module has a required NO_RBP_MOD related bug
fix.
A working edk2 commit is 95d8a1c ("UnitTestFrameworkPkg: Use TianoCore
mirror of subhook submodule").

Testing

The series has been tested as part of the development branch for the TDX
base series. The testing consisted of TDX kvm-unit-tests and booting a
Linux TD, and TDX enhanced KVM selftests.

The full KVM branch is here:
https://github.com/intel/tdx/tree/tdx_kvm_dev-2024-11-20

Matching QEMU:
https://github.com/intel-staging/qemu-tdx/commits/tdx-qemu-upstream-v6.1/

[0] https://lore.kernel.org/kvm/20240904030751.117579-1-rick.p.edgecombe@intel.com/
[1] https://lore.kernel.org/kvm/cover.1731318868.git.kai.huang@intel.com/#t
[2] https://lore.kernel.org/kvm/cover.1730120881.git.kai.huang@intel.com/
[3] https://lore.kernel.org/kvm/20241030190039.77971-1-rick.p.edgecombe@intel.com/
[4] https://lore.kernel.org/kvm/20241112073327.21979-1-yan.y.zhao@intel.com/
[5] https://github.com/intel/tdx-module/releases/tag/TDX_1.5.06

Chao Gao (1):
      KVM: x86: Allow to update cached values in kvm_user_return_msrs w/o
      wrmsr

Isaku Yamahata (4):
      KVM: TDX: Implement TDX vcpu enter/exit path
      KVM: TDX: vcpu_run: save/restore host state(host kernel gs)
      KVM: TDX: restore host xsave state when exit from the guest TD
      KVM: TDX: restore user ret MSRs

Kai Huang (1):
      x86/virt/tdx: Add SEAMCALL wrapper to enter/exit TDX guest

Yang Weijiang (1):
      KVM: TDX: Add TSX_CTRL msr into uret_msrs list

 arch/x86/include/asm/kvm_host.h |   1 +
 arch/x86/include/asm/tdx.h      |   1 +
 arch/x86/kvm/vmx/main.c         |  45 ++++++++-
 arch/x86/kvm/vmx/tdx.c          | 212 ++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/tdx.h          |  14 +++
 arch/x86/kvm/vmx/x86_ops.h      |   9 ++
 arch/x86/kvm/x86.c              |  24 ++++-
 arch/x86/virt/vmx/tdx/tdx.c     |   8 ++
 arch/x86/virt/vmx/tdx/tdx.h     |   1 +
 9 files changed, 306 insertions(+), 9 deletions(-)

Regards
Adrian

