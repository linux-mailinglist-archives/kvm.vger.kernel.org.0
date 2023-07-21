Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 046FE75BE55
	for <lists+kvm@lfdr.de>; Fri, 21 Jul 2023 08:09:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230037AbjGUGI6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jul 2023 02:08:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229699AbjGUGIy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jul 2023 02:08:54 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DF44E65;
        Thu, 20 Jul 2023 23:08:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689919732; x=1721455732;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=HRmxOEBLpq+hGP1cUw1x5RwSQJjvLGS0PpFiRHt3IVw=;
  b=jglNLxz5nu6/Vh5tZIuwS/sFCP2RgtM9qIcDv5EFQqJXckcqGUV/4gZl
   T8vidjLj7fyycODFbnOZuahTE+vLPl4l2O/9Ox1THuQbkduFsgfbdiCCl
   avaU68VdOreLfO1xyu1Hyo23puknRatYeq9OTTe+M/beIm+FFXOrUifWz
   Rv2bPuEVtwIxHPRQ0MTz+3QPMQJY9Q/gTlv2cgegFqesNyGuepqQ550xA
   9ICn6oKEY49EZ8wQ25XiWxFVqmS1qTC5SAzvE0Z8K/03MSYXGyl93KZFo
   f5sH7njaKNyZyVhRRpXyJefM2qsJda4fdgn2EAsyjGL/cm0fljJvJqC5a
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10777"; a="370547507"
X-IronPort-AV: E=Sophos;i="6.01,220,1684825200"; 
   d="scan'208";a="370547507"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2023 23:08:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10777"; a="848721860"
X-IronPort-AV: E=Sophos;i="6.01,220,1684825200"; 
   d="scan'208";a="848721860"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2023 23:08:40 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, peterz@infradead.org,
        john.allen@amd.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     rick.p.edgecombe@intel.com, chao.gao@intel.com,
        binbin.wu@linux.intel.com, weijiang.yang@intel.com
Subject: [PATCH v4 00/20] Enable CET Virtualization
Date:   Thu, 20 Jul 2023 23:03:32 -0400
Message-Id: <20230721030352.72414-1-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
The first 2 patches are taken over from CET native series[1] in kernel tip.
They're prerequisites for this KVM patch series as CET user mode xstate and
some feature bits are defined in the patches. Add this KVM series to kernel
tree to build qualified host kernel to support guest CET features. Also apply
QEMU CET enabling patches[2] to build qualified QEMU. These kernel dependent
patches will be enclosed in KVM series until CET native series is merged in
mainline tree.


Implementation:
--------------------------------------------------------------------------
This series enables full support for guest CET SHSTK/IBT register states,
i.e., CET register states in below usage models are backed by KVM.

                  |
    User SHSTK    |    User IBT      (user mode)
--------------------------------------------------
    Kernel SHSTK  |    Kernel IBT    (kernel mode)
                  |

KVM cooperates with host kernel to back CET register states in each model.
In this series, KVM manages guest CET kernel registers(MSRs) by itself and
relies on host kernel to manage the user mode registers, thus KVM relies on
capability from host XSS MSR before exposes CET features to guest.

Note, guest supervisor(kernel) SHSTK cannot be fully supported by this series,
therefore guest SSS_CET bit of CPUID(0x7,1):EDX[bit18] is cleared. Check SDM
(Vol 1, Section 17.2.3) for details.


CET states management:
--------------------------------------------------------------------------
CET user mode states, MSR_IA32_{U_CET,PL3_SSP}, depends on {XSAVES,XRSTORS}
instructions to swap guest and host's states. On vmexit, guest user states
are saved to guest fpu area and host user mode states are loaded from thread
context before vCPU returns to userspace, vice-versa on vmentry. See details
in kvm_{load,put}_guest_fpu(). So CET user mode states management depends on
CET user mode bit(U_CET bit) set in host XSS MSR.

CET supervisor mode states are grouped into two categories : XSAVE-managed
and non-XSAVE-managed, the former includes MSR_IA32_PL{0,1,2}_SSP and are
controlled by CET supervisor mode bit(S_CET bit) in XSS, the later consists
of MSR_IA32_S_CET and MSR_IA32_INTR_SSP_TBL.

The XSAVE-managed supervisor states theoretically can be handled by enabling
S_CET bit in host XSS. But given the fact supervisor shadow stack isn't enabled
in Linux kernel, enabling the control bit just like that for user mode states
has global side-effects to all threads/tasks running on host, i.e.:
1) Introducing unnecessary XSAVE operation when switch to non-vCPU userspace
within current FPU framework.
2)Forcing allocating additional space for CET supervisor states in each thread
context regardless whether it's vCPU thread or not.

To avoid these downsides, this series provides a KVM solution to save/reload
vCPU's supervisor SHSTK states.

VMX introduces new VMCS fields, {GUEST|HOST}_{S_CET,SSP,INTR_SSP_TABL}, to
facilitate guest/host non-XSAVES-managed states. When VMX CET entry/exit load
bits are set, guest/host MSR_IA32_{S_CET,INTR_SSP_TBL,SSP} are loaded from
equivalent fields at vm-exit/entry. With these new fields, such supervisor states
require no addtional KVM save/reload actions.


Tests:
--------------------------------------------------------------------------
This series passed basic CET user shadow stack test and kernel IBT test in L1 and
L2 guest.

The patch series _has_ impact to existing vmx test cases in KVM-unit-tests,the
failures have been fixed in this patch[3].

All other parts of KVM unit-tests and selftests passed with this series. One new
selftest app for CET MSRs is posted here[4].

To run user SHSTK test and kernel IBT test in guest , an CET capable
platform is required, e.g., Sapphire Rapids server, and follow below steps to
build host/guest kernel properly:

1. Build host kernel: Add this series to kernel tree and build kernel.

2. Build guest kernel: Add full CET _native_ series to kernel tree and opt-in
CONFIG_X86_KERNEL_IBT and CONFIG_X86_USER_SHADOW_STACK options. Build with CET
enabled gcc versions(>= 8.5.0).

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

Changes in v4:
1. Overhauled v3 series[5] per community review feedback. [Sean, Chao, Binbin etc.]
2. Modified CET dependency checks on host side before expose the features.
3. Added KVM specific solution for save/reload guest CET SHSTK supervisor states.
4. Rebase on kvm-x86/next [6].


[1]: CET native series: https://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git/log/?h=x86/shstk
[2]: QEMU patch: https://lore.kernel.org/all/20230720111445.99509-1-weijiang.yang@intel.com/
[3]: KVM-unit-tests fixup: https://lore.kernel.org/all/20230720115810.104890-1-weijiang.yang@intel.com/ 
[4]: Selftests for CET MSRs: https://lore.kernel.org/all/20230720120401.105770-1-weijiang.yang@intel.com/ 
[5]: v3 patchset: https://lore.kernel.org/all/20230511040857.6094-1-weijiang.yang@intel.com/
[6]: Rebase branch: https://github.com/kvm-x86/linux/releases/tag/kvm-x86-next-2023.06.22


Patch 1-2: Native dependent CET patches.
Patch 3-5: Enable XSS support in KVM.
Patch 6 :  Prepare patch for XSAVE-managed MSR access
Patch 7-11:  Common patches to support CET on x86.
Patch 12-18: VMX specific patches to support CET.
Patch 19-20: nVMX patches for CET support in nested VM.

-----------------------------------------------------------------------------

Rick Edgecombe (2):
  x86/cpufeatures: Add CPU feature flags for shadow stacks
  x86/fpu/xstate: Introduce CET MSR and XSAVES supervisor states

Sean Christopherson (2):
  KVM:x86: Report XSS as to-be-saved if there are supported features
  KVM:x86: Load guest FPU state when access XSAVE-managed MSRs

Yang Weijiang (16):
  KVM:x86: Refresh CPUID on write to guest MSR_IA32_XSS
  KVM:x86: Initialize kvm_caps.supported_xss
  KVM:x86: Add fault checks for guest CR4.CET setting
  KVM:x86: Report KVM supported CET MSRs as to-be-saved
  KVM:x86: Add common code of CET MSR access
  KVM:x86: Make guest supervisor states as non-XSAVE managed
  KVM:x86: Save and reload GUEST_SSP to/from SMRAM
  KVM:VMX: Introduce CET VMCS fields and control bits
  KVM:VMX: Emulate read and write to CET MSRs
  KVM:VMX: Set up interception for CET MSRs
  KVM:VMX: Save host MSR_IA32_S_CET to VMCS field
  KVM:x86: Optimize CET supervisor SSP save/reload
  KVM:x86: Enable CET virtualization for VMX and advertise to userspace
  KVM:x86: Enable guest CET supervisor xstate bit support
  KVM:nVMX: Refine error code injection to nested VM
  KVM:nVMX: Enable CET support for nested VM

 arch/arm64/include/asm/kvm_host.h        |   1 +
 arch/mips/include/asm/kvm_host.h         |   1 +
 arch/powerpc/include/asm/kvm_host.h      |   1 +
 arch/riscv/include/asm/kvm_host.h        |   1 +
 arch/s390/include/asm/kvm_host.h         |   1 +
 arch/x86/include/asm/cpufeatures.h       |   2 +
 arch/x86/include/asm/disabled-features.h |   8 +-
 arch/x86/include/asm/fpu/types.h         |  16 +-
 arch/x86/include/asm/fpu/xstate.h        |   6 +-
 arch/x86/include/asm/kvm_host.h          |   6 +-
 arch/x86/include/asm/msr-index.h         |   1 +
 arch/x86/include/asm/vmx.h               |   8 +
 arch/x86/include/uapi/asm/kvm_para.h     |   1 +
 arch/x86/kernel/cpu/cpuid-deps.c         |   1 +
 arch/x86/kernel/fpu/xstate.c             |  90 +++++----
 arch/x86/kvm/cpuid.c                     |  32 +++-
 arch/x86/kvm/cpuid.h                     |  10 +
 arch/x86/kvm/smm.c                       |  17 ++
 arch/x86/kvm/smm.h                       |   2 +-
 arch/x86/kvm/vmx/capabilities.h          |  10 +
 arch/x86/kvm/vmx/nested.c                |  49 ++++-
 arch/x86/kvm/vmx/nested.h                |   7 +
 arch/x86/kvm/vmx/vmcs12.c                |   6 +
 arch/x86/kvm/vmx/vmcs12.h                |  14 +-
 arch/x86/kvm/vmx/vmx.c                   | 134 ++++++++++++-
 arch/x86/kvm/vmx/vmx.h                   |   6 +-
 arch/x86/kvm/x86.c                       | 228 +++++++++++++++++++++--
 arch/x86/kvm/x86.h                       |  31 +++
 include/linux/kvm_host.h                 |   1 +
 virt/kvm/kvm_main.c                      |   1 +
 30 files changed, 606 insertions(+), 86 deletions(-)


base-commit: 88bb466c9dec4f70d682cf38c685324e7b1b3d60
-- 
2.27.0

