Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12D2E7A0047
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 11:38:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237175AbjINJiV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 05:38:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235913AbjINJiU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 05:38:20 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E096483;
        Thu, 14 Sep 2023 02:38:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694684295; x=1726220295;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Jb4b7fFnjYhNohHH6lKC54NwWpsMBJuaIFhF2TBdLPI=;
  b=MvvJmp/JrJbPnwYUSvCtxNeoRIB1Zln2AMyG25rvs0P11QfSwCe4Qkb2
   wy4VRj3HMT3BKeY6SC4PFtfPwy71yM6IZVoQDEil4Um/rxmDRRaXTdaCE
   csNG0vYE1ITCxUjTNhhXz3GpzJLda6N6quQvRpwMKG+O11AjEuzFI2eF8
   UGVlOgRhpBRZeq+fRv3nvJLHVhKqKTnQ6BVeqGkRJ7CemEsrmvG/NEEan
   lAiwRVK3YwFlBWWUHZS5wiabwcaZhNzy7SmEg5NggdVH0cNLE3SNPVpMW
   ZR9TEUnNFP9pAqqOWjvgKjJTx8ac6SDyyVBuAuXUo9VQS9PUt5WAZRgpz
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="409857297"
X-IronPort-AV: E=Sophos;i="6.02,145,1688454000"; 
   d="scan'208";a="409857297"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2023 02:38:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="747656207"
X-IronPort-AV: E=Sophos;i="6.02,145,1688454000"; 
   d="scan'208";a="747656207"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2023 02:38:14 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     dave.hansen@intel.com, peterz@infradead.org, chao.gao@intel.com,
        rick.p.edgecombe@intel.com, weijiang.yang@intel.com,
        john.allen@amd.com
Subject: [PATCH v6 00/25] Enable CET Virtualization
Date:   Thu, 14 Sep 2023 02:33:00 -0400
Message-Id: <20230914063325.85503-1-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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
At the moment, the CET native series for user mode shadow stack is upstream
-merged in v6.6-rc1, so no native patches are enclosed in this series.

The first 8 kernel patches are prerequisites for this KVM patch series as
guest CET user mode and supervisor mode xstates/MSRs rely on host FPU
framework to properly saves/reloads guest MSRs when it's required to do so,
e.g., when vCPU thread is sched in/out. The kernel patches are released in
separate review thread here [1].

To test CET guest, patch this KVM series to kernel tree to build qualified
host kernel. Also apply QEMU CET enabling patches[2] to build qualified QEMU.


Implementation:
--------------------------------------------------------------------------
This series enables full support for guest CET SHSTK/IBT register states,
i.e., guest CET register states in below usage models are supported.

                  |
    User SHSTK    |    User IBT      (user mode)
--------------------------------------------------
    Kernel SHSTK  |    Kernel IBT    (kernel mode)
                  |

KVM cooperates with host kernel FPU framework to back guest CET xstates switch
when guest CET MSRs need to be saved/reloaded on host side, thus KVM relies on
host FPU xstate settings. From KVM perspective, part of user mode CET state
support is in the native series but requires series [1] to fix some issues
and enable CET supervisor xstate support for guest.

Note, guest supervisor(kernel) SHSTK cannot be fully supported by this series,
therefore guest SSS_CET bit of CPUID(0x7,1):EDX[bit18] is cleared. Check SDM
(Vol 1, Section 17.2.3) for details.


CET states management:
--------------------------------------------------------------------------
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
failures have been fixed in this series[3].

All other parts of KVM unit-tests and selftests passed with this series. One
new selftest app for CET MSRs is also included in this series.

Note, this series hasn't been tested on AMD platform yet.

To run user SHSTK test and kernel IBT test in guest, an CET capable platform
is required, e.g., Sapphire Rapids server, and follow below steps to build host/
guest kernel properly:

1. Build host kernel: Apply this series to kernel tree(>= v6.6-rc1) and build.

2. Build guest kernel: Pull kernel (>= v6.6-rc1) and opt-in CONFIG_X86_KERNEL_IBT
and CONFIG_X86_USER_SHADOW_STACK options. Build with CET enabled gcc versions
(>= 8.5.0).

3. Use patched QEMU to launch a guest.

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
Changes in v6:
1. Added kernel patches to enable CET supervisor xstate support for guest. [Sean, Paolo]
2. Overhauled CET MSR access interface to make read/write clearer.[Sean, Chao]
3. Removed KVM-managed CET supervisor state patches.
4. Tweaked the code for accessing XSS MSR/reporting CET MSRs/SSP access in SMM mode/
CET MSR interception etc.per review feedback. [Sean, Paolo, Chao]
5. Rebased to: https://github.com/kvm-x86/linux tag: kvm-x86-next-2023.09.07


[1]: CET supervisor xstate support:
https://lore.kernel.org/all/20230914032334.75212-1-weijiang.yang@intel.com/
[2]: QEMU patch:
https://lore.kernel.org/all/20230720111445.99509-1-weijiang.yang@intel.com/
[3]: KVM-unit-tests fixup:
https://lore.kernel.org/all/20230913235006.74172-1-weijiang.yang@intel.com/
[4]: v5 patchset:
https://lore.kernel.org/kvm/20230803042732.88515-1-weijiang.yang@intel.com/


Patch 1-8: 	Kernel patches to enable CET supervisor state.
Patch 9-14: 	Enable XSS support in KVM.
Patch 15:  	Fault check for CR4.CET setting.
Patch 16:	Report CET MSRs to userspace.
Patch 17:	Introduce CET VMCS fields.
Patch 18:  	Add SHSTK/IBT to KVM-governed framework.
Patch 19: 	Emulate CET MSR access.
Patch 20: 	Handle SSP at entry/exit to SMM.
Patch 21: 	Set up CET MSR interception.
Patch 22: 	Initialize host constant supervisor state.
Patch 23: 	Add CET virtualization settings.
Patch 24-25: 	Add CET nested support.



Sean Christopherson (3):
  KVM: x86: Rework cpuid_get_supported_xcr0() to operate on vCPU data
  KVM: x86: Report XSS as to-be-saved if there are supported features
  KVM: x86: Load guest FPU state when access XSAVE-managed MSRs

Yang Weijiang (22):
  x86/fpu/xstate: Manually check and add XFEATURE_CET_USER xstate bit
  x86/fpu/xstate: Fix guest fpstate allocation size calculation
  x86/fpu/xstate: Add CET supervisor mode state support
  x86/fpu/xstate: Introduce kernel dynamic xfeature set
  x86/fpu/xstate: Remove kernel dynamic xfeatures from kernel
    default_features
  x86/fpu/xstate: Opt-in kernel dynamic bits when calculate guest xstate
    size
  x86/fpu/xstate: Tweak guest fpstate to support kernel dynamic
    xfeatures
  x86/fpu/xstate: WARN if normal fpstate contains kernel dynamic
    xfeatures
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

 arch/x86/include/asm/fpu/types.h     |  14 +-
 arch/x86/include/asm/fpu/xstate.h    |   6 +-
 arch/x86/include/asm/kvm_host.h      |   8 +-
 arch/x86/include/asm/msr-index.h     |   1 +
 arch/x86/include/asm/vmx.h           |   8 ++
 arch/x86/include/uapi/asm/kvm_para.h |   1 +
 arch/x86/kernel/fpu/core.c           |  56 ++++++--
 arch/x86/kernel/fpu/xstate.c         |  49 ++++++-
 arch/x86/kernel/fpu/xstate.h         |   5 +
 arch/x86/kvm/cpuid.c                 |  62 ++++++---
 arch/x86/kvm/governed_features.h     |   2 +
 arch/x86/kvm/smm.c                   |   8 ++
 arch/x86/kvm/smm.h                   |   2 +-
 arch/x86/kvm/vmx/capabilities.h      |  10 ++
 arch/x86/kvm/vmx/nested.c            |  49 +++++--
 arch/x86/kvm/vmx/nested.h            |   5 +
 arch/x86/kvm/vmx/vmcs12.c            |   6 +
 arch/x86/kvm/vmx/vmcs12.h            |  14 +-
 arch/x86/kvm/vmx/vmx.c               | 104 ++++++++++++++-
 arch/x86/kvm/vmx/vmx.h               |   6 +-
 arch/x86/kvm/x86.c                   | 192 +++++++++++++++++++++++++--
 arch/x86/kvm/x86.h                   |  28 ++++
 22 files changed, 569 insertions(+), 67 deletions(-)


base-commit: ff6e6ded54725cd01623b9a1a86b74a523198733
-- 
2.27.0

