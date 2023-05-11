Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09A8B6FEC73
	for <lists+kvm@lfdr.de>; Thu, 11 May 2023 09:13:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237380AbjEKHNn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 May 2023 03:13:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236848AbjEKHNi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 May 2023 03:13:38 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDEFC5FF2;
        Thu, 11 May 2023 00:13:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683789210; x=1715325210;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=x6kFyyfcC7Qa/ItADGYfJy0M6HL1tbruJU5F3NysgKE=;
  b=WP6z9q7yIRGFw9M7hpitUsXbtLYOSdekWFpOODRozma6dFR+EJiZy+Kt
   Ep+6Cmu4zPSY+s3a9VGgsRkHY+O0p3JEby1uE1h981JLg3XyD7jka0rVB
   1O6dj/6n+/VPl9Ky19Ek5WUHCveRflPp62nNA7Jdw8Ive5+DMHzqxCm5k
   hBdMKLvjrUXdagOuNOahFq1T0WZ2e3vNX8r+yxysAj97zX+IoXsW4sW07
   yH7ucCvoQoO6ap6ZBEGwf/Cefohbgzftu1UjdzVr85ii67JY8r6EZtzmA
   j/SiOj1kh48u+P6ZD+LqVJu/nmpk4hnxbxt6sDnhjI/d8HMXvnxdsN1NL
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10706"; a="334896552"
X-IronPort-AV: E=Sophos;i="5.99,266,1677571200"; 
   d="scan'208";a="334896552"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2023 00:13:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10706"; a="1029512339"
X-IronPort-AV: E=Sophos;i="5.99,266,1677571200"; 
   d="scan'208";a="1029512339"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2023 00:13:21 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     peterz@infradead.org, rppt@kernel.org, binbin.wu@linux.intel.com,
        rick.p.edgecombe@intel.com, weijiang.yang@intel.com,
        john.allen@amd.com
Subject: [PATCH v3 00/21] Enable CET Virtualization
Date:   Thu, 11 May 2023 00:08:36 -0400
Message-Id: <20230511040857.6094-1-weijiang.yang@intel.com>
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

Control-flow Enforcement Technology (CET) is a CPU feature used to prevent
Return/Jump-Oriented Programming (ROP/JOP) attacks. CET introduces a new
exception type, Control Protection (#CP), and two sub-features(SHSTK,IBT)
to defend against ROP/JOP style control-flow subversion attacks.

Shadow Stack (SHSTK):
  A shadow stack is a second stack used exclusively for control transfer
  operations. The shadow stack is separate from the data/normal stack and
  can be enabled individually in user and kernel mode. When shadow stack
  is enabled, CALL pushes the return address on both the data and shadow
  stack. RET pops the return address from both stacks and compares them.
  If the return addresses from the two stacks do not match, the processor
  generates a #CP.

Indirect Branch Tracking (IBT):
  IBT adds a new instruction, ENDBRANCH, to mark valid target addresses of
  indirect branches (CALL, JMP etc...). If an indirect branch is executed
  and the next instruction is _not_ an ENDBRANCH, the processor generates a
  #CP. These instruction behaves as a NOP on platforms that doesn't support
  CET.


Dependency:
--------------------------------------------------------------------------
The first 5 patches are taken over from CET native series [1] in linux-next.
They're prerequisites for enabling guest user mode SHSTK. Patch this full
series before build host kernel for guest CET testing. Also apply CET enabling
patches in [2] to build qualified QEMU. These kernel dependent patches will
be enclosed in KVM series until CET native series is merged in mainline tree.


Implementation:
--------------------------------------------------------------------------
Historically, the early KVM patches can support both user SHSTK and IBT,
and most of the early patches are carried forward with changes in this new
series. And with kernel IBT feature merged in 5.18, a new patch was added
to support the feature in guest. The last patch is introduced to support
supervisor SHSTK but the feature is not enabled on Intel platform for now,
the main purpose of this patch is to facilitate AMD folks to enable the
feature.

In summary, this new series enables CET user SHSTK/IBT and kernel IBT, but
doesn't fully support CET supervisor SHSTK, the enabling work is left for
the future.

Supported CET sub-features:

                  |
    User SHSTK    |    User IBT      (user mode)
--------------------------------------------------
    s-SHSTK (X)   |    Kernel IBT    (kernel mode)
                  |

Guest user mode SHSTK/IBT relies on host side XSAVES support(XSS[bit 11])
to swap CET states. Guest kernel IBT doesn't have dependency on host XSAVES.
The supervisor SHSTK relies on host side XSAVES support(XSS[bit 12]) for
supervisor mode CET states save/restore.

This version removed unnecessary checks of host CET enabling status before
expose CET features to guest, making guest CET enabling apart from host.
By doing so, it's expected to be more friendly to cloud computing scenarios.


CET states management:
--------------------------------------------------------------------------
CET user mode states, MSR_IA32_{U_CET,PL3_SSP} depends on {XSAVES,XRSTORS}
instructions to swap guest/host context when vm-exit/vm-entry happens. 
On vm-exit, the guest CET states are stored to guest fpu area and host user
mode states are loaded from thread/process context before vCPU returns to
userspace, vice-versa on vm-entry. See details in kvm_{load|put}_guest_fpu().
So the user mode state validity depends on host side U_CET bit set in MSR_XSS.

CET supervisor mode states are grouped into two categories - XSAVES dependent
and non-dependent, the former includes MSR_IA32_PL{0,1,2}_SSP, the later
consists of MSR_IA32_S_CET and MSR_IA32_INTR_SSP_TBL. The XSAVES dependent
MSR's save/restore depends on S_CET bit set in MSR_XSS. Since native series
doesn't enable S_CET support, these s-SHSTK shadow stack pointers are invalid.

New VMCS fields, {GUEST|HOST}_{S_CET,SSP,INTR_SSP_TABL}, are introduced for
guest/host non-XSAVES managed states switch. When CET entry/exit load bits are
set, guest/host MSR_IA32_{S_CET,INTR_SSP_TBL,SSP} are loaded from these fields
at vm-exit/entry. With these new fields, current guest kernel IBT enabling
doesn't depend on S_CET bit in XSS, i.e., host {XSAVES|XRSTORS} support.


Tests:
--------------------------------------------------------------------------
This series passed basic CET user shadow stack test and kernel IBT test in
L1 and L2 guest. It also works with CET KVM-unit-test application.

Executed all KVM-unit-test cases and KVM selftests against this series, all
test cases passed except the vmx test, the failure is due to CR4_CET bit
testing in test_vmxon_bad_cr(). After add CR4_CET bit to skip list, the test
passed. I'll send a patch to fix this issue later.


To run user shadow stack test and kernel IBT test in VM, you need an CET
capable platform, e.g., Sapphire Rapids server, and follow below steps to
build host/guest kernel properly:

1. Build host kernel. Patch this series to kernel tree and build kernel.

2. Build guest kernel. Patch CET native series to kernel tree and opt-in
CONFIG_X86_KERNEL_IBT and CONFIG_X86_USER_SHADOW_STACK options. Build with
CET enabled gcc versions(>= 8.5.0).

3. Use patched QEMU to launch a VM.

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
Changes in v3:
1. Moved MSR access check helper to x86 common file. [Mike]
2. Modified cover letter, commit logs and code per review comments. [PeterZ, Binbin, Rick]
3. Fixed an issue on host MSR_IA32_S_CET reload at vm-exit.
5. Rebase on kvm-x86/next [4].


[1]: linux-next: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/tree/?h=next-20230420
[2]: QEMU patch: https://lore.kernel.org/all/20230421041227.90915-1-weijiang.yang@intel.com/
[3]: v2 patchset: https://lore.kernel.org/all/20230421134615.62539-1-weijiang.yang@intel.com/
[4]: Rebase branch: https://github.com/kvm-x86/linux.git, commit: 5c291b93e5d6 (tag: kvm-x86-next-2023.04.26)


Rick Edgecombe (5):
  x86/shstk: Add Kconfig option for shadow stack
  x86/cpufeatures: Add CPU feature flags for shadow stacks
  x86/cpufeatures: Enable CET CR4 bit for shadow stack
  x86/fpu/xstate: Introduce CET MSR and XSAVES supervisor states
  x86/fpu: Add helper for modifying xstate

Sean Christopherson (2):
  KVM:x86: Report XSS as to-be-saved if there are supported features
  KVM:x86: Load guest FPU state when accessing xsaves-managed MSRs

Yang Weijiang (14):
  KVM:x86: Refresh CPUID on write to guest MSR_IA32_XSS
  KVM:x86: Init kvm_caps.supported_xss with supported feature bits
  KVM:x86: Add #CP support in guest exception classification
  KVM:VMX: Introduce CET VMCS fields and control bits
  KVM:x86: Add fault checks for guest CR4.CET setting
  KVM:VMX: Emulate reads and writes to CET MSRs
  KVM:VMX: Add a synthetic MSR to allow userspace to access GUEST_SSP
  KVM:x86: Report CET MSRs as to-be-saved if CET is supported
  KVM:x86: Save/Restore GUEST_SSP to/from SMM state save area
  KVM:VMX: Pass through user CET MSRs to the guest
  KVM:x86: Enable CET virtualization for VMX and advertise to userspace
  KVM:nVMX: Enable user CET support for nested VMX
  KVM:x86: Enable kernel IBT support for guest
  KVM:x86: Support CET supervisor shadow stack MSR access

 arch/x86/Kconfig                         |  24 +++++
 arch/x86/Kconfig.assembler               |   5 +
 arch/x86/include/asm/cpufeatures.h       |   2 +
 arch/x86/include/asm/disabled-features.h |   8 +-
 arch/x86/include/asm/fpu/api.h           |   9 ++
 arch/x86/include/asm/fpu/types.h         |  16 ++-
 arch/x86/include/asm/fpu/xstate.h        |   6 +-
 arch/x86/include/asm/kvm_host.h          |   3 +-
 arch/x86/include/asm/vmx.h               |   8 ++
 arch/x86/include/uapi/asm/kvm.h          |   1 +
 arch/x86/include/uapi/asm/kvm_para.h     |   1 +
 arch/x86/kernel/cpu/common.c             |  35 +++++--
 arch/x86/kernel/cpu/cpuid-deps.c         |   1 +
 arch/x86/kernel/fpu/core.c               |  19 ++++
 arch/x86/kernel/fpu/xstate.c             |  90 ++++++++--------
 arch/x86/kvm/cpuid.c                     |  19 +++-
 arch/x86/kvm/cpuid.h                     |   6 ++
 arch/x86/kvm/smm.c                       |  20 ++++
 arch/x86/kvm/vmx/capabilities.h          |   4 +
 arch/x86/kvm/vmx/nested.c                |  29 +++++-
 arch/x86/kvm/vmx/vmcs12.c                |   6 ++
 arch/x86/kvm/vmx/vmcs12.h                |  14 ++-
 arch/x86/kvm/vmx/vmx.c                   | 124 ++++++++++++++++++++++-
 arch/x86/kvm/vmx/vmx.h                   |   6 +-
 arch/x86/kvm/x86.c                       | 122 ++++++++++++++++++++--
 arch/x86/kvm/x86.h                       |  47 ++++++++-
 26 files changed, 543 insertions(+), 82 deletions(-)


base-commit: 5c291b93e5d665380dbecc6944973583f9565ee5
-- 
2.27.0

