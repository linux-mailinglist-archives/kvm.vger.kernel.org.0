Return-Path: <kvm+bounces-2397-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E0CF7F6D59
	for <lists+kvm@lfdr.de>; Fri, 24 Nov 2023 08:59:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 298211C20E30
	for <lists+kvm@lfdr.de>; Fri, 24 Nov 2023 07:59:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F700BA49;
	Fri, 24 Nov 2023 07:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JHI3UyX7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9B6FD53;
	Thu, 23 Nov 2023 23:58:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700812715; x=1732348715;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=6LXxjJBfPU7MNIDA8KbcIYgTZqjYrSEKhZOaYceK600=;
  b=JHI3UyX7Fpp1OlbKc7zNw1t0er7SdzPModr7Ee0gIaZ+3n1uwQvuOnL2
   48Silr7Oyi4w1CPIGCoQ15WMyYRMxeML+MZ+e+BGvWuJZh2IZG5255G+N
   n4+onEwfLPKxH2EgI0BrywHI6cwcZkLSTTgoBuqymmPFzqYiHt7hz/gvF
   10B/ExEuz5r14+iClHzxM3o4cIZlAac3n0YbrwTl3Vn+frgzmU/GAWb6Y
   f7sIFI7IDURbpZVBax8pkRejP/InZMnYMcaZrZDVPo3RWMd+7yuAhQemV
   AmzfI35TCM6gsFiuLWasFawD7DOwUiumDZ+UGUV5DrICospWmLFWuWYqx
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10902"; a="458872265"
X-IronPort-AV: E=Sophos;i="6.04,223,1695711600"; 
   d="scan'208";a="458872265"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2023 23:58:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10902"; a="833629786"
X-IronPort-AV: E=Sophos;i="6.04,223,1695711600"; 
   d="scan'208";a="833629786"
Received: from unknown (HELO embargo.jf.intel.com) ([10.165.9.183])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2023 23:58:34 -0800
From: Yang Weijiang <weijiang.yang@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	dave.hansen@intel.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: peterz@infradead.org,
	chao.gao@intel.com,
	rick.p.edgecombe@intel.com,
	mlevitsk@redhat.com,
	john.allen@amd.com,
	weijiang.yang@intel.com
Subject: [PATCH v7 00/26] Enable CET Virtualization
Date: Fri, 24 Nov 2023 00:53:04 -0500
Message-Id: <20231124055330.138870-1-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
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
--------------------------------------------------------------------------
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
--------------------------------------------------------------------------
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
--------------------------------------------------------------------------
This series passed basic CET user shadow stack test and kernel IBT test in L1
and L2 guest.
The patch series _has_ impact to existing vmx test cases in KVM-unit-tests,the
failures have been fixed here [1].
One new selftest app [2] is introduced for testing CET MSRs accessibilities.

Note, this series hasn't been tested on AMD platform yet.

To run user SHSTK test and kernel IBT test in guest, an CET capable platform
is required, e.g., Sapphire Rapids server, and follow below steps to build
the binaries:

1. Host kernel: Apply this series to mainline kernel (>= v6.6) and build.

2. Guest kernel: Pull kernel (>= v6.6), opt-in CONFIG_X86_KERNEL_IBT
and CONFIG_X86_USER_SHADOW_STACK options. Build with CET enabled gcc versions
(>= 8.5.0).

3. Apply CET QEMU patches [3] before build mainline QEMU.

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

--------------------------------------------------------------------------
Changes in v7:
1. Introduced guest dedicated config for guest related xstate fixup. [Sean, Maxim]
2. Refined CET supervisor state handling for guest fpstate. [Dave]
3. Enclosed Sean's fixup patch for kernel xstate issue. [Sean]
4. Refined CET MSR read/write handling flow. [Sean, Maxim]
5. Added CET VMCS fields sync between vmcs12 and vmcs02. [Chao, Maxim]
6. Added reset handling for CET xstate-managed MSRs.
7. Other minor changes due to community review feedback. [Sean, Maxim, Chao]
8. Rebased to: https://github.com/kvm-x86/linux tag: kvm-x86-next-2023.11.01


[1]: KVM-unit-tests fixup:
https://lore.kernel.org/all/20230913235006.74172-1-weijiang.yang@intel.com/
[2]: Selftest for CET MSRs:
https://lore.kernel.org/all/20230914064201.85605-1-weijiang.yang@intel.com/
[3]: QEMU patch:
https://lore.kernel.org/all/20230720111445.99509-1-weijiang.yang@intel.com/
[4]: v6 patchset:
https://lore.kernel.org/all/20230914063325.85503-1-weijiang.yang@intel.com/

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
Patch 24:	Add CET virtualization settings.
Patch 25-26:	Add CET nested support.


Sean Christopherson (4):
  x86/fpu/xstate: Always preserve non-user xfeatures/flags in
    __state_perm
  KVM: x86: Rework cpuid_get_supported_xcr0() to operate on vCPU data
  KVM: x86: Report XSS as to-be-saved if there are supported features
  KVM: x86: Load guest FPU state when access XSAVE-managed MSRs

Yang Weijiang (22):
  x86/fpu/xstate: Refine CET user xstate bit enabling
  x86/fpu/xstate: Add CET supervisor mode state support
  x86/fpu/xstate: Introduce XFEATURE_MASK_KERNEL_DYNAMIC xfeature set
  x86/fpu/xstate: Introduce fpu_guest_cfg for guest FPU configuration
  x86/fpu/xstate: Create guest fpstate with guest specific config
  x86/fpu/xstate: Warn if kernel dynamic xfeatures detected in normal fpstate
  KVM: x86: Rename kvm_{g,s}et_msr() to menifest emulation operations
  KVM: x86: Refine xsave-managed guest register/MSR reset handling
  KVM: x86: Add kvm_msr_{read,write}() helpers
  KVM: x86: Refresh CPUID on write to guest MSR_IA32_XSS
  KVM: x86: Initialize kvm_caps.supported_xss
  KVM: x86: Add fault checks for guest CR4.CET setting
  KVM: x86: Report KVM supported CET MSRs as to-be-saved
  KVM: VMX: Introduce CET VMCS fields and control bits
  KVM: x86: Use KVM-governed feature framework to track "SHSTK/IBT enabled"
  KVM: VMX: Emulate read and write to CET MSRs
  KVM: x86: Save and reload SSP to/from SMRAM
  KVM: VMX: Set up interception for CET MSRs
  KVM: VMX: Set host constant supervisor states to VMCS fields
  KVM: x86: Enable CET virtualization for VMX and advertise to userspace
  KVM: nVMX: Introduce new VMX_BASIC bit for event error_code delivery to L1
  KVM: nVMX: Enable CET support for nested guest

 arch/x86/include/asm/fpu/types.h     |  16 +-
 arch/x86/include/asm/fpu/xstate.h    |  11 +-
 arch/x86/include/asm/kvm_host.h      |  13 +-
 arch/x86/include/asm/msr-index.h     |   1 +
 arch/x86/include/asm/vmx.h           |   8 +
 arch/x86/include/uapi/asm/kvm_para.h |   1 +
 arch/x86/kernel/fpu/core.c           |  62 +++++--
 arch/x86/kernel/fpu/xstate.c         |  46 +++--
 arch/x86/kernel/fpu/xstate.h         |   4 +
 arch/x86/kvm/cpuid.c                 |  69 +++++---
 arch/x86/kvm/governed_features.h     |   2 +
 arch/x86/kvm/smm.c                   |  12 +-
 arch/x86/kvm/smm.h                   |   2 +-
 arch/x86/kvm/vmx/capabilities.h      |  10 ++
 arch/x86/kvm/vmx/nested.c            |  88 ++++++++--
 arch/x86/kvm/vmx/nested.h            |   5 +
 arch/x86/kvm/vmx/vmcs12.c            |   6 +
 arch/x86/kvm/vmx/vmcs12.h            |  14 +-
 arch/x86/kvm/vmx/vmx.c               | 110 +++++++++++-
 arch/x86/kvm/vmx/vmx.h               |   6 +-
 arch/x86/kvm/x86.c                   | 254 +++++++++++++++++++++++++--
 arch/x86/kvm/x86.h                   |  28 +++
 22 files changed, 669 insertions(+), 99 deletions(-)

-- 
2.27.0


