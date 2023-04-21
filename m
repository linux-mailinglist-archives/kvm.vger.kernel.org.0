Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAEA26EAF7B
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 18:50:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233208AbjDUQur (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 12:50:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232445AbjDUQuq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 12:50:46 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1F6A8691;
        Fri, 21 Apr 2023 09:50:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682095844; x=1713631844;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=gwxpo+wRlLq+sgXMaWLO4NiSZPubB5SwUMSLYgQBk08=;
  b=ShNcUZmGNxVMCZpMeWzeILKCM7e21k0IEKlYeaCSYBJMyj9/GAUjkB45
   5YCs1duXEyjzg0Osi48zY7WmGdwVppnXK0ZiXdvXTjGTYRvijWW0ceuxd
   K88hsAU93G/3b38Pc70b9wbL6RDo40CGA9VC6nbIEepERPmozIGi6KQNw
   jWP6tYdM+z3s8Ehv3Y8Spqtb8pzX/a9JGzqS38bh5yX+fx7gdWFpU/fNk
   foPlET74yoIeyOZDPgG+6w7GuDRGFLCSc+WN7gPF9FGdzzll8VrOhFlMK
   e/4UvWCLIQB6RkKLpjOOL7hY7i9lKBlZlAJ7vf4IOzaxXfpJEWNY5esyM
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10687"; a="344786937"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="344786937"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2023 09:50:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10687"; a="722817352"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="722817352"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2023 09:50:41 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, peterz@infradead.org,
        john.allen@amd.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     rick.p.edgecombe@intel.com, weijiang.yang@intel.com
Subject: [PATCH v2 00/21] Enable CET Virtualization
Date:   Fri, 21 Apr 2023 09:45:54 -0400
Message-Id: <20230421134615.62539-1-weijiang.yang@intel.com>
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

CET (Control-flow Enforcement Technology) is a CPU feature used to prevent\n
Return/Jump-Oriented Programming (ROP/JOP) attacks. CET introduces a new\n
exception type, Control Protection (#CP), and two sub-features(SHSTK,IBT)\n
to defend against ROP/JOP style control-flow subversion attacks.\n

Shadow Stack (SHSTK):
  A shadow stack is a second stack used exclusively for control transfer
  operations. The shadow stack is separate from the data/normal stack and
  can be enabled individually in user and kernel mode. When shadow stacks
  are enabled, CALL pushes the return address on both the data and shadow
  stack. RET pops the return address from both stacks and compares them.
  If the return addresses from the two stacks do not match, the processor
  generates a #CP.

Indirect Branch Tracking (IBT):
  IBT adds new instrutions, ENDBRANCH{32|64}, to mark valid target addresses
  of indirect branches (CALL, JMP etc...). If an indirect branch is executed
  and the next instruction is _not_ an ENDBRANCH, the processor generates a #CP.


Build dependency:
--------------------------------------------------------------------------
The first 5 patches are took over from CET native series [1] in linux-next,
they must be included in kernel tree when build host kernel for testing CET
in guest. Will remove them once the native series landed in mainline kernel
tree. It's just for build and test purpose.


Implementation:
--------------------------------------------------------------------------
Historically, the early KVM patches can support both user SHSTK and IBT,
and most of the early patches are carried forward with changes by this new
series. Then with kernel IBT feature merged in 5.18, a new patch was added
to support the feature for guest. The last patch is introduced to support
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

The user SHSTK/IBT relies on host side XSAVES support(XSS[bit 11]) for user
mode CET states. The kernel IBT doesn't have dependency on host XSAVES.
The supervisor SHSTK relies on host side XSAVES support(XSS[bit 12]) for
supervisor mode CET states.

This version removed unnecessary checks for host CET enabling status before
enabling guest CET support, making guest CET support apart from that of host.
By doing so, it's expected to be more friendly to cloud computing scenarios.


CET states management:
--------------------------------------------------------------------------
CET user mode states, MSR_IA32_{U_CET,PL3_SSP} depends on {XSAVES|XRSTORS}
instructions to swap guest/host context when vm-exit/vm-entry happens. 
On vm-exit, the guest CET states are stored to guest fpu area and host user
mode states are loaded from thread/process context before vCPU returns to
userspace, vice-versa on vm-entry. See details in kvm_{load|put}_guest_fpu().
So the user mode state validity depends on host side U_CET bit set in MSR_XSS.

CET supervisor mode states are grouped into two categories - XSAVES dependent
and non-dependent, the former includes MSR_IA32_PL{0,1,2}_SSP, the later
consists of MSR_IA32_S_CET and MSR_IA32_INTR_SSP_TBL. The XSAVES dependent
MSR's save/restore depends on S_CET bit set in MSR_XSS. Since the native series
doesn't enable S_CET support, these s-SHSTK shadow stack pointers are invalid.

Moveover, new VMCS fields, {GUEST|HOST}_{S_CET,SSP,INTR_SSP_TABL}, are
introduced for guest/host supervisor state switch. When CET entry/exit load
bits are set, the guest/host MSR_IA32_{S_CET,INTR_SSP_TBL,SSP} are swapped
automatically at vm-exit/entry. With these new fields, current guest kernel
IBT enalbing doesn't depend on host {XSAVES|XRSTORS} support.


Tests:
--------------------------------------------------------------------------
This series passed basic CET user shadow stack test and kernel IBT test in
L1 and L2 guest. It also passed CET KUT test which has been merged there.

Executed all KUT tests and KVM selftests against this series, all test cases
passes except the vmx test, the failure is due to CR4_CET bit testing in
test_vmxon_bad_cr(). After add CR4_CET bit to skip list, the test passed.
I'll send a patch to fix this issue later.


To run user shadow stack test and kernel IBT test in VM, you need an CET
capable platform, e.g., Sapphire Rapids server, and follow below steps to
build host/guest kernel properly:

1. Buld host kernel. Patch this series to kernel tree and build kernel
with CET capable gcc version(e.g., >=8.5.0).

2. Build guest kernel. Patch CET native series to kernel tree and opt-in
CONFIG_X86_KERNEL_IBT and CONFIG_X86_USER_SHADOW_STACK options.

3. Launch a VM with QEMU built with CET enabling patches [2].

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
Changes in v2:
1. Remove excessive checks on host CET Kconfig options in v1 patchset [3].
2. Make CET CPUIDs, MSRs and control flags enabling independent to host CET status.
3. Introduce supervisor SHSTK support to make the patch set complete.
4. Refactor patches to accommodate above changes.
5. Rebase on kvm-x86/next [4].


[1]: linux-next: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/tree/?h=next-20230420
[2]: QEMU patch: https://lore.kernel.org/all/20230421041227.90915-1-weijiang.yang@intel.com/
[3]: v1 patchset: https://lore.kernel.org/all/20220616084643.19564-1-weijiang.yang@intel.com/
[4]: Rebase branch: https://github.com/kvm-x86/linux.git, commit: 7b632f72528d (tag: kvm-x86-next-2023.04.14)


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
  KVM:VMX: Add a synthetic MSR to allow userspace VMM to access
    GUEST_SSP
  KVM:x86: Report CET MSRs as to-be-saved if CET is supported
  KVM:x86: Save/Restore GUEST_SSP to/from SMM state save area
  KVM:VMX: Pass through user CET MSRs to the guest
  KVM:x86: Enable CET virtualization for VMX and advertise to userspace
  KVM:nVMX: Enable user CET support for nested VMX
  KVM:x86: Enable supervisor IBT support for guest
  KVM:x86: Support CET supervisor shadow stack MSR access

 arch/x86/Kconfig                         |  24 ++++
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
 arch/x86/kernel/cpu/common.c             |  35 ++++--
 arch/x86/kernel/cpu/cpuid-deps.c         |   1 +
 arch/x86/kernel/fpu/core.c               |  19 +++
 arch/x86/kernel/fpu/xstate.c             |  90 +++++++-------
 arch/x86/kvm/cpuid.c                     |  23 +++-
 arch/x86/kvm/cpuid.h                     |   6 +
 arch/x86/kvm/smm.c                       |  20 +++
 arch/x86/kvm/vmx/capabilities.h          |   4 +
 arch/x86/kvm/vmx/nested.c                |  29 ++++-
 arch/x86/kvm/vmx/vmcs12.c                |   6 +
 arch/x86/kvm/vmx/vmcs12.h                |  14 ++-
 arch/x86/kvm/vmx/vmx.c                   | 150 ++++++++++++++++++++++-
 arch/x86/kvm/vmx/vmx.h                   |   6 +-
 arch/x86/kvm/x86.c                       |  79 ++++++++++--
 arch/x86/kvm/x86.h                       |  46 ++++++-
 26 files changed, 528 insertions(+), 83 deletions(-)


base-commit: 7b632f72528d5fa3f0265358a393f534da47d9dd
-- 
2.27.0

