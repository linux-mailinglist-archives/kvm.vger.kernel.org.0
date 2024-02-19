Return-Path: <kvm+bounces-9013-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 42C3C859D71
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 08:50:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C43C81F22D30
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 07:50:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3C092375D;
	Mon, 19 Feb 2024 07:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WLHSy36a"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9721020DC3;
	Mon, 19 Feb 2024 07:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708328867; cv=none; b=VXLEPOz2lOseLXmDPM0wNCBOdkhTlRduyuppqMZc8yb77i+txmBHX3gwfr/ZJF06AOm3ljklX4CcmhG+xCVgDM3rL30rzGZ1gfQ7EbYruc7apWASxgKwu1pmEhfpO9Si4+tWvJC3FK7DPoUOUlYiUqXKyHv0RIIw0jkm0wU9rEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708328867; c=relaxed/simple;
	bh=/YWn5/ObdOfhNg+Pusr/TniRTi2o6Z52ssQzMtoyqGQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HbuZm1rVYidddWBG71VaImkwU2VUVP41/JQCbSKsj1G22Ln8xild4FQGDrEhXRZsyop9uKHW3MYg8Z2lsd4yElRJAtDA0PYXYF2Hrea1PBZGCWLGOHPSn3xeTTLOquUb5R7o1PLqVx5FnDRmCiyd7gDsQ4ccEvY9xQzwUWV2JsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WLHSy36a; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708328864; x=1739864864;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=/YWn5/ObdOfhNg+Pusr/TniRTi2o6Z52ssQzMtoyqGQ=;
  b=WLHSy36a346dQPOy3TF2bRDmVIpo8cMRMagUKrXva9jJ1dZ+iPZ72lqa
   AXtRB9kN3XXS5vRJ6Hz7oS8gq5IDJuRtWPS92EiSG2p8AGCE7bnVXzrmj
   qq/znBK5803vApy7n+FJmvsqSWlpxKa1+KEsAosvCHpN3V67XrCV8yiqq
   ug3iMHR4by9n2cxvSqiVZewWx6H3wGxEW8mLPP1UdWsQhSa6H0jLgTOMA
   nIQklRKtz/pLq5Z5PbzOSYVz1FVqGLW64bZq7oGzdAhqS5WonXyQ4jQ/F
   /oUNMxnvCD2uqm9kprKZXWwngnepJL+rb/wF5LPnnWU3Dn9VtM5g/EUKA
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10988"; a="2535005"
X-IronPort-AV: E=Sophos;i="6.06,170,1705392000"; 
   d="scan'208";a="2535005"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2024 23:47:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10988"; a="826966056"
X-IronPort-AV: E=Sophos;i="6.06,170,1705392000"; 
   d="scan'208";a="826966056"
Received: from jf.jf.intel.com (HELO jf.intel.com) ([10.165.9.183])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2024 23:47:43 -0800
From: Yang Weijiang <weijiang.yang@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	dave.hansen@intel.com,
	x86@kernel.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: peterz@infradead.org,
	chao.gao@intel.com,
	rick.p.edgecombe@intel.com,
	mlevitsk@redhat.com,
	john.allen@amd.com,
	weijiang.yang@intel.com
Subject: [PATCH v10 00/27] Enable CET Virtualization
Date: Sun, 18 Feb 2024 23:47:06 -0800
Message-ID: <20240219074733.122080-1-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Control-flow Enforcement Technology (CET) is a kind of CPU feature used
to prevent Return/CALL/Jump-Oriented Programming (ROP/COP/JOP) attacks.
It provides two sub-features(SHSTK,IBT) to defend against ROP/COP/JOP
style control-flow subversion attacks.

Shadow Stack (SHSTK):
  A shadow stack is a second stack used exclusively for control transfer
  operations. The shadow stack is separate from the data/normal stack and
  can be enabled individually in user and kernel mode. When shadow stack
  is enabled, CALL pushes the return address on both the data and shadow
  stack. RET pops the return address from both stacks and compares them.
  If the return addresses from the two stacks do not match, the processor
  generates a #CP.

Indirect Branch Tracking (IBT):
  IBT introduces new instruction(ENDBRANCH)to mark valid target addresses of
  indirect branches (CALL, JMP etc...). If an indirect branch is executed
  and the next instruction is _not_ an ENDBRANCH, the processor generates a
  #CP. These instruction behaves as a NOP on platforms that doesn't support
  CET.

Dependency:
=====================
CET native series for user mode shadow stack has already been merged in v6.6
mainline kernel.

The first 7 kernel patches are prerequisites for this KVM patch series since
guest CET user mode and supervisor mode states depends on kernel FPU framework
to properly save/restore the states whenever FPU context switch is required,
e.g., after VM-Exit and before vCPU thread exits to userspace.

In this series, guest supervisor SHSTK mitigation solution isn't introduced
for Intel platform therefore guest SSS_CET bit of CPUID(0x7,1):EDX[bit18] is
cleared. Check SDM (Vol 1, Section 17.2.3) for details.

CET states management:
======================
KVM cooperates with host kernel FPU framework to manage guest CET registers.
With CET supervisor mode state support in this series, KVM can save/restore
full guest CET xsave-managed states.

CET user mode and supervisor mode xstates, i.e., MSR_IA32_{U_CET,PL3_SSP}
and MSR_IA32_PL{0,1,2}, depend on host FPU framework to swap guest and host
xstates. On VM-Exit, guest CET xstates are saved to guest fpu area and host
CET xstates are loaded from task/thread context before vCPU returns to
userspace, vice-versa on VM-Entry. See details in kvm_{load,put}_guest_fpu().
So guest CET xstates management depends on CET xstate bits(U_CET/S_CET bit)
set in host XSS MSR.

CET supervisor mode states are grouped into two categories : XSAVE-managed
and non-XSAVE-managed, the former includes MSR_IA32_PL{0,1,2}_SSP and are
controlled by CET supervisor mode bit(S_CET bit) in XSS, the later consists
of MSR_IA32_S_CET and MSR_IA32_INTR_SSP_TBL.

VMX introduces new VMCS fields, {GUEST|HOST}_{S_CET,SSP,INTR_SSP_TABL}, to
facilitate guest/host non-XSAVES-managed states. When VMX CET entry/exit load
bits are set, guest/host MSR_IA32_{S_CET,INTR_SSP_TBL,SSP} are loaded from
equivalent fields at VM-Exit/Entry. With these new fields, such supervisor
states require no addtional KVM save/reload actions.

Tests:
======================
This series passed basic CET user shadow stack test and kernel IBT test in L1
and L2 guest.
The patch series _has_ impact to existing vmx test cases in KVM-unit-tests,the
failures have been fixed here[1].
One new selftest app[2] is introduced for testing CET MSRs accessibilities.

Note, this series hasn't been tested on AMD platform yet.

To run user SHSTK test and kernel IBT test in guest, an CET capable platform
is required, e.g., Sapphire Rapids server, and follow below steps to build
the binaries:

1. Host kernel: Apply this series to mainline kernel (>= v6.6) and build.

2. Guest kernel: Pull kernel (>= v6.6), opt-in CONFIG_X86_KERNEL_IBT
and CONFIG_X86_USER_SHADOW_STACK options. Build with CET enabled gcc versions
(>= 8.5.0).

3. Apply CET QEMU patches[3] before build mainline QEMU.

Check kernel selftest test_shadow_stack_64 output:
[INFO]  new_ssp = 7f8c82100ff8, *new_ssp = 7f8c82101001
[INFO]  changing ssp from 7f8c82900ff0 to 7f8c82100ff8
[INFO]  ssp is now 7f8c82101000
[OK]    Shadow stack pivot
[OK]    Shadow stack faults
[INFO]  Corrupting shadow stack
[INFO]  Generated shadow stack violation successfully
[OK]    Shadow stack violation test
[INFO]  Gup read -> shstk access success
[INFO]  Gup write -> shstk access success
[INFO]  Violation from normal write
[INFO]  Gup read -> write access success
[INFO]  Violation from normal write
[INFO]  Gup write -> write access success
[INFO]  Cow gup write -> write access success
[OK]    Shadow gup test
[INFO]  Violation from shstk access
[OK]    mprotect() test
[SKIP]  Userfaultfd unavailable.
[OK]    32 bit test


Check kernel IBT with dmesg | grep CET:
CET detected: Indirect Branch Tracking enabled

Changes in v10:
=====================
1. Add Reviewed-by tags from Chao and Rick. [Chao, Rick]
2. Use two bit flags to check CET guarded instructions in KVM emulator. [Chao]
3. Refine reset handling of xsave-managed guest FPU states. [Chao]
4. Add nested CET MSR sync when entry/exit-load-bit is not set. [Chao]
5. Other minor changes per comments from Chao and Rick.
6. Rebased on https://github.com/kvm-x86/linux commit: c0f8b0752b09


[1]: KVM-unit-tests fixup:
https://lore.kernel.org/all/20230913235006.74172-1-weijiang.yang@intel.com/
[2]: Selftest for CET MSRs:
https://lore.kernel.org/all/20230914064201.85605-1-weijiang.yang@intel.com/
[3]: QEMU patch:
https://lore.kernel.org/all/20230720111445.99509-1-weijiang.yang@intel.com/
[4]: v9 patchset:
https://lore.kernel.org/all/20240124024200.102792-1-weijiang.yang@intel.com/


Patch 1-7:	Fixup patches for kernel xstate and enable CET supervisor xstate.
Patch 8-11:	Cleanup patches for KVM.
Patch 12-15:	Enable KVM XSS MSR support.
Patch 16:	Fault check for CR4.CET setting.
Patch 17:	Report CET MSRs to userspace.
Patch 18:	Introduce CET VMCS fields.
Patch 19:	Add SHSTK/IBT to KVM-governed framework.(to be deprecated)
Patch 20:	Emulate CET MSR access.
Patch 21:	Handle SSP at entry/exit to SMM.
Patch 22:	Set up CET MSR interception.
Patch 23:	Initialize host constant supervisor state.
Patch 24:	Enable CET virtualization settings.
Patch 25-26:	Add CET nested support.
Patch 27:	KVM emulation handling for branch instructions


Sean Christopherson (4):
  x86/fpu/xstate: Always preserve non-user xfeatures/flags in
    __state_perm
  KVM: x86: Rework cpuid_get_supported_xcr0() to operate on vCPU data
  KVM: x86: Report XSS as to-be-saved if there are supported features
  KVM: x86: Load guest FPU state when access XSAVE-managed MSRs

Yang Weijiang (23):
  x86/fpu/xstate: Refine CET user xstate bit enabling
  x86/fpu/xstate: Add CET supervisor mode state support
  x86/fpu/xstate: Introduce XFEATURE_MASK_KERNEL_DYNAMIC xfeature set
  x86/fpu/xstate: Introduce fpu_guest_cfg for guest FPU configuration
  x86/fpu/xstate: Create guest fpstate with guest specific config
  x86/fpu/xstate: Warn if kernel dynamic xfeatures detected in normal
    fpstate
  KVM: x86: Rename kvm_{g,s}et_msr()* to menifest emulation operations
  KVM: x86: Refine xsave-managed guest register/MSR reset handling
  KVM: x86: Add kvm_msr_{read,write}() helpers
  KVM: x86: Refresh CPUID on write to guest MSR_IA32_XSS
  KVM: x86: Initialize kvm_caps.supported_xss
  KVM: x86: Add fault checks for guest CR4.CET setting
  KVM: x86: Report KVM supported CET MSRs as to-be-saved
  KVM: VMX: Introduce CET VMCS fields and control bits
  KVM: x86: Use KVM-governed feature framework to track "SHSTK/IBT
    enabled"
  KVM: VMX: Emulate read and write to CET MSRs
  KVM: x86: Save and reload SSP to/from SMRAM
  KVM: VMX: Set up interception for CET MSRs
  KVM: VMX: Set host constant supervisor states to VMCS fields
  KVM: x86: Enable CET virtualization for VMX and advertise to userspace
  KVM: nVMX: Introduce new VMX_BASIC bit for event error_code delivery
    to L1
  KVM: nVMX: Enable CET support for nested guest
  KVM: x86: Don't emulate instructions guarded by CET

 arch/x86/include/asm/fpu/types.h     |  16 +-
 arch/x86/include/asm/fpu/xstate.h    |  11 +-
 arch/x86/include/asm/kvm_host.h      |  12 +-
 arch/x86/include/asm/msr-index.h     |   1 +
 arch/x86/include/asm/vmx.h           |   8 +
 arch/x86/include/uapi/asm/kvm_para.h |   1 +
 arch/x86/kernel/fpu/core.c           |  53 +++--
 arch/x86/kernel/fpu/xstate.c         |  44 ++++-
 arch/x86/kernel/fpu/xstate.h         |   3 +
 arch/x86/kvm/cpuid.c                 |  80 ++++++--
 arch/x86/kvm/emulate.c               |  46 +++--
 arch/x86/kvm/governed_features.h     |   2 +
 arch/x86/kvm/smm.c                   |  12 +-
 arch/x86/kvm/smm.h                   |   2 +-
 arch/x86/kvm/vmx/capabilities.h      |  10 +
 arch/x86/kvm/vmx/nested.c            | 120 ++++++++++--
 arch/x86/kvm/vmx/nested.h            |   5 +
 arch/x86/kvm/vmx/vmcs12.c            |   6 +
 arch/x86/kvm/vmx/vmcs12.h            |  14 +-
 arch/x86/kvm/vmx/vmx.c               | 112 ++++++++++-
 arch/x86/kvm/vmx/vmx.h               |   9 +-
 arch/x86/kvm/x86.c                   | 280 ++++++++++++++++++++++++---
 arch/x86/kvm/x86.h                   |  28 +++
 23 files changed, 761 insertions(+), 114 deletions(-)


base-commit: c0f8b0752b0988e5116c78e8b6c3cfdf89806e45
-- 
2.43.0


