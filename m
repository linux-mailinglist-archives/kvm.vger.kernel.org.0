Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A53D76E1A8
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 09:36:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233961AbjHCHgx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 03:36:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231302AbjHCHgE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 03:36:04 -0400
Received: from mgamail.intel.com (unknown [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C982D49C9;
        Thu,  3 Aug 2023 00:32:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691047934; x=1722583934;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Jx7znXT623dDsUgwC4yXa1anpEhRfez8dQemNEY6QkM=;
  b=CMprtYRoaDT3m7XL3iFy0V1gwhsSIu5F9Oz8YWVkFDkmibRon3Cw84fl
   QIxZwLcMt/uo0E4VJnFR3DdFH63TpH7fnHzkAlPqWeT4IkLa/mXru3KYV
   NtVIT/V6MmcOJVRVmyFlqU4Yu05pX3/nWTnPZWKuGGktqmmxMzdvbqvzl
   xIwbU8uBpt7vXnrghxhXXxQjDi2PQnyvlIkNA17XHMKDFhwdVkBWcGHD8
   f6FKa0wtstnubKa2bkELk2bcGR19UjYYdiqDfMFmBisa6wA3Vi9jq8NuJ
   yon4SQr3D0HBd5s+Z5sGyZuwQzhYgXHG+SmPzphAvsqf/uI1QHeZG5++1
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10790"; a="354708068"
X-IronPort-AV: E=Sophos;i="6.01,251,1684825200"; 
   d="scan'208";a="354708068"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2023 00:32:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10790"; a="794888462"
X-IronPort-AV: E=Sophos;i="6.01,251,1684825200"; 
   d="scan'208";a="794888462"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2023 00:32:13 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, peterz@infradead.org,
        john.allen@amd.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     rick.p.edgecombe@intel.com, chao.gao@intel.com,
        binbin.wu@linux.intel.com, weijiang.yang@intel.com
Subject: [PATCH v5 00/19] Enable CET Virtualization
Date:   Thu,  3 Aug 2023 00:27:13 -0400
Message-Id: <20230803042732.88515-1-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.5 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
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
1) Introducing unnecessary XSAVE operation when switch context between non-vCPU
userspace within current FPU framework.
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

Note, this series hasn't been tested on AMD platform yet.

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
Changes in v5:
1. Consolidated CET MSR access code into one patch to make it clearer. [Chao]
2. Refined SSP handling when enter/exit SMM mode. [Chao]
3. Refined CET MSR interception to make it adaptive to enable/disable cases. [Chao]
4. Refined guest PL{0,1,2}_SSP handling to comply with exiting code logic. [Chao]
5. Other tweaks per Sean and Chao's feedback.
6. Rebased to: https://github.com/kvm-x86/linux/tree/next tag: kvm-x86-next-2023.07.28


[1]: CET native series: https://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git/log/?h=x86/shstk
[2]: QEMU patch: https://lore.kernel.org/all/20230720111445.99509-1-weijiang.yang@intel.com/
[3]: KVM-unit-tests fixup: https://lore.kernel.org/all/20230720115810.104890-1-weijiang.yang@intel.com/ 
[4]: Selftests for CET MSRs: https://lore.kernel.org/all/20230720120401.105770-1-weijiang.yang@intel.com/ 
[5]: v4 patchset: https://lore.kernel.org/all/20230721030352.72414-1-weijiang.yang@intel.com/ 


Patch 1-2: 	Native dependent CET patches.
Patch 3-5: 	Enable XSS support in KVM.
Patch 6 :  	Prepare patch for XSAVE-managed MSR access
Patch 7-9:  	Common patches to support CET on x86.
Patch 10-11: 	Emulate CET MSR access.
Patch 12: 	Handle SSP at entry/exit to SMM.
Patch 13-17: 	Add CET virtualization settings.
Patch 18-19: 	nVMX patches for CET support in nested VM.


Rick Edgecombe (2):
  x86/cpufeatures: Add CPU feature flags for shadow stacks
  x86/fpu/xstate: Introduce CET MSR and XSAVES supervisor states

Sean Christopherson (2):
  KVM:x86: Report XSS as to-be-saved if there are supported features
  KVM:x86: Load guest FPU state when access XSAVE-managed MSRs

Yang Weijiang (15):
  KVM:x86: Refresh CPUID on write to guest MSR_IA32_XSS
  KVM:x86: Initialize kvm_caps.supported_xss
  KVM:x86: Add fault checks for guest CR4.CET setting
  KVM:x86: Report KVM supported CET MSRs as to-be-saved
  KVM:x86: Make guest supervisor states as non-XSAVE managed
  KVM:VMX: Introduce CET VMCS fields and control bits
  KVM:VMX: Emulate read and write to CET MSRs
  KVM:x86: Save and reload SSP to/from SMRAM
  KVM:VMX: Set up interception for CET MSRs
  KVM:VMX: Set host constant supervisor states to VMCS fields
  KVM:x86: Optimize CET supervisor SSP save/reload
  KVM:x86: Enable CET virtualization for VMX and advertise to userspace
  KVM:x86: Enable guest CET supervisor xstate bit support
  KVM:nVMX: Refine error code injection to nested VM
  KVM:nVMX: Enable CET support for nested VM

 arch/x86/include/asm/cpufeatures.h       |   2 +
 arch/x86/include/asm/disabled-features.h |   8 +-
 arch/x86/include/asm/fpu/types.h         |  16 +-
 arch/x86/include/asm/fpu/xstate.h        |   6 +-
 arch/x86/include/asm/kvm_host.h          |   6 +-
 arch/x86/include/asm/msr-index.h         |   1 +
 arch/x86/include/asm/vmx.h               |   8 +
 arch/x86/include/uapi/asm/kvm_para.h     |   1 +
 arch/x86/kernel/cpu/cpuid-deps.c         |   1 +
 arch/x86/kernel/fpu/xstate.c             |  90 ++++-----
 arch/x86/kvm/cpuid.c                     |  32 ++-
 arch/x86/kvm/cpuid.h                     |  11 ++
 arch/x86/kvm/smm.c                       |  11 ++
 arch/x86/kvm/smm.h                       |   2 +-
 arch/x86/kvm/svm/svm.c                   |   2 +
 arch/x86/kvm/vmx/capabilities.h          |  10 +
 arch/x86/kvm/vmx/nested.c                |  49 ++++-
 arch/x86/kvm/vmx/nested.h                |   7 +
 arch/x86/kvm/vmx/vmcs12.c                |   6 +
 arch/x86/kvm/vmx/vmcs12.h                |  14 +-
 arch/x86/kvm/vmx/vmx.c                   | 133 ++++++++++++-
 arch/x86/kvm/vmx/vmx.h                   |   6 +-
 arch/x86/kvm/x86.c                       | 242 +++++++++++++++++++++--
 arch/x86/kvm/x86.h                       |  35 ++++
 24 files changed, 614 insertions(+), 85 deletions(-)


base-commit: d406b457840171306ada37400e4f3d3c6f0f4960
-- 
2.27.0

