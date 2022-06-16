Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 922ED54DD5C
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 10:49:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376419AbiFPIs7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jun 2022 04:48:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376279AbiFPIsp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jun 2022 04:48:45 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1169C13D08;
        Thu, 16 Jun 2022 01:47:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655369261; x=1686905261;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=LwVrahgpuZc7T0tvDz9kqESk8bh9sRBe1fIKLBtTqC0=;
  b=Sg3CFc93YRWVjszuAiIdfSvLI6WTghZTvw/4tPVSeqCPEppqLhu+UU3V
   Zu4JeoD6VCUuCiriZ11ncnY6etGqZyK+bBchzz51vQUsJSNulWfICQPdA
   ddZjSG1sJ3Wp45meUeiQ65G8/4ulW9bxmr3GZZMIk0VvMMmbcR6CZKLzN
   s7fE4RMfolS4j/4D1wyB2bP1k8XqHGs//2vXx6Dx+bVcusmVhrokxQ3Ne
   dOCiuV+NnLZ5fpMZc53mKsSXrjJ0xEQUGLEB5K+VA4EINST2pQMk0e0Zy
   UQ2FMxC74FRH1Zn8pDyXd4WEM1L1jkqE2QS3BgZ8argZ3tLdMLNc3RaGs
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10379"; a="259664549"
X-IronPort-AV: E=Sophos;i="5.91,304,1647327600"; 
   d="scan'208";a="259664549"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2022 01:47:40 -0700
X-IronPort-AV: E=Sophos;i="5.91,304,1647327600"; 
   d="scan'208";a="613083125"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2022 01:47:40 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        rick.p.edgecombe@intel.com
Cc:     weijiang.yang@intel.com
Subject: [PATCH 00/19] Refresh queued CET virtualization series
Date:   Thu, 16 Jun 2022 04:46:24 -0400
Message-Id: <20220616084643.19564-1-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset=yes
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The purpose of this patch series is to refresh the queued CET KVM
patches[1] with the latest dependent CET native patches, pursuing
the result that whole series could be merged ahead of CET native
series[2] [3].

The patchset has been tested on Skylake(none-CET) and Sapphire Rapids
(CET capable) platforms, didn't find breakages to KVM basic functions
and KVM unit-tests/selftests.

----------------------------------------------------------------------
The motivations are:
1) Customers are interested in developing CET related applications,
they especially desire to set up CET development environments in
VM, but suffered by non-trivial native and KVM patch rebasing work.
If this series could be merged early, it'll save them tons of energy.

2) The kernel and KVM have evolved significantly since the queued day,
it’s necessary to fix up the KVM patches to make them adapted to the
recent mainline code.

3) CET native patch series refactored a lot per maintainers’ review
and some of the patches can be reused by KVM enabling patches.

4) PeterZ’s supervisor IBT patch series got merged in 5.18, it
requires additional KVM patch to support it in guest kernel.

----------------------------------------------------------------------
Guest CET states in KVM:
CET user mode states(MSR_IA32_U_CET,MSR_IA32_PL3_SSP) counts on
xsaves/xrstors and CET user bit of MSR_IA32_XSS to save/restor when
thread/process context switch happens. In virtulization world, after
vm-exit and before vcpu thread exits to user mode, the guest user mode
states are swapped to guest fpu area and host user mode states are loaded,
vice-versa on vm-entry. See details in kvm_load_guest_fpu() and
kvm_put_guest_fpu(). With this design, guest CET xsave-supported states
retain while the vcpu thread keeps in ring-0 vmx root mode, the
instantaneous guest states are not expected to impact host side.

Moveover, VMCS includes new fields for CET states, i.e.,GUEST_S_CET,
GUEST_SSP, GUEST_INTR_SSP_TABLE for guest and HOST_S_CET, HOST_SSP,
HOST_INTR_SSP_TABLE for host, when loading guest/host state bits set
in VMCS, the guest/host MSRs are swapped at vm-exit/entry, therefore
these guest/host CET states are strictly isolated. All CET supervisor
states map to one of the fields. With the new fields, current guest
supervisor IBT enalbing doesn't depend on xsaves/xrstors and CET
supervisor bit of MSR_IA32_XSS.

---------------------------------------------------------------------
Impact to existing kernel/KVM:
To minimize the impact to exiting kernel/KVM code, most of KVM patch
code can be bypassed during runtime.Uncheck "CONFIG_X86_KERNEL_IBT"
and "CONFIG_X86_SHADOW_STACK" in Kconfig before kernel build to get
rid of CET featrures in KVM. If both of them are not enabled, KVM
clears related feature bits as well as CET user bit in supported_xss,
this makes CET related checks stop at the first points. Since most of
the patch code runs on the none-hot path of KVM, it's expected to
introduce little impact to existing code.
On legacy platforms, CET feature is not available by nature, therefore
the execution flow just like that on CET capable platform with
features disabled at build time.

One known downside of early merge is thread fpu area size expands by 16
bytes due to enabling XFEATURE_MASK_CET_USER bit on CET capable platforms.

Although native SHSTK and IBT patch series are split off, but we don't
want to do the same for KVM patches since supervisor IBT has been merged
and customers desire full user mode features in guest.

We'd like to get your comments on the practice and patches, thanks!

Patch 1-5: Dependent CET native patches.
Patch 6-7: KVM XSS Supporting patches from kvm/queue.
Patch 8-18: Enabling patches for CET user mode.
Patch 19:  Enabling patch for supervisor IBT.

Change logs:
1. Removed XFEATURE_MASK_CET_KERNEL, MSR_IA32_PL{0,1,2}_SSP and
   MSR_IA32_INT_SSP_TAB related code since supervisor SHSTK design is
   still open.
2. Added support for guest kernel supervisor IBT.
3. Refactored some of previous helpers due to change 1) and 2).
4. Refactored control logic between XSS CET user bit and user mode SHSTK/IBT,
   make supervisor IBT support independent to XSS user bit.
5. Rebased the patch series onto kvm/queue:
   8baacf67c76c ("KVM: SEV-ES: reuse advance_sev_es_emulated_ins for OUT too")

[1]: https://git.kernel.org/pub/scm/virt/kvm/kvm.git/log/?h=intel
[2]: SHSTK: https://lore.kernel.org/all/20220130211838.8382-1-rick.p.edgecombe@intel.com/
[3]: old IBT: https://lore.kernel.org/all/20210830182221.3535-1-yu-cheng.yu@intel.com/

Rick Edgecombe (1):
  x86/fpu: Add helper for modifying xstate

Sean Christopherson (2):
  KVM: x86: Report XSS as an MSR to be saved if there are supported
    features
  KVM: x86: Load guest fpu state when accessing MSRs managed by XSAVES

Yang Weijiang (12):
  KVM: x86: Refresh CPUID on writes to MSR_IA32_XSS
  KVM: x86: Add #CP support in guest exception classification.
  KVM: VMX: Introduce CET VMCS fields and flags
  KVM: x86: Add fault checks for CR4.CET
  KVM: VMX: Emulate reads and writes to CET MSRs
  KVM: VMX: Add a synthetic MSR to allow userspace VMM to access
    GUEST_SSP
  KVM: x86: Report CET MSRs as to-be-saved if CET is supported
  KVM: x86: Save/Restore GUEST_SSP to/from SMM state save area
  KVM: x86: Enable CET virtualization for VMX and advertise CET to
    userspace
  KVM: VMX: Pass through CET MSRs to the guest when supported
  KVM: nVMX: Enable CET support for nested VMX
  KVM: x86: Enable supervisor IBT support for guest

Yu-cheng Yu (4):
  x86/cet/shstk: Add Kconfig option for Shadow Stack
  x86/cpufeatures: Add CPU feature flags for shadow stacks
  x86/cpufeatures: Enable CET CR4 bit for shadow stack
  x86/fpu/xstate: Introduce CET MSR and XSAVES supervisor states

 arch/x86/Kconfig                         |  17 +++
 arch/x86/Kconfig.assembler               |   1 +
 arch/x86/include/asm/cpu.h               |   2 +-
 arch/x86/include/asm/cpufeatures.h       |   1 +
 arch/x86/include/asm/disabled-features.h |   8 +-
 arch/x86/include/asm/fpu/api.h           |   7 +-
 arch/x86/include/asm/fpu/types.h         |  14 ++-
 arch/x86/include/asm/fpu/xstate.h        |   6 +-
 arch/x86/include/asm/kvm_host.h          |   3 +-
 arch/x86/include/asm/vmx.h               |   8 ++
 arch/x86/include/uapi/asm/kvm.h          |   1 +
 arch/x86/include/uapi/asm/kvm_para.h     |   1 +
 arch/x86/kernel/cpu/common.c             |  14 +--
 arch/x86/kernel/cpu/cpuid-deps.c         |   1 +
 arch/x86/kernel/fpu/core.c               |  19 ++++
 arch/x86/kernel/fpu/xstate.c             |  93 ++++++++--------
 arch/x86/kernel/machine_kexec_64.c       |   2 +-
 arch/x86/kvm/cpuid.c                     |  21 +++-
 arch/x86/kvm/cpuid.h                     |   5 +
 arch/x86/kvm/emulate.c                   |  11 ++
 arch/x86/kvm/vmx/capabilities.h          |   4 +
 arch/x86/kvm/vmx/nested.c                |  19 +++-
 arch/x86/kvm/vmx/vmcs12.c                |   6 +
 arch/x86/kvm/vmx/vmcs12.h                |  14 ++-
 arch/x86/kvm/vmx/vmx.c                   | 134 ++++++++++++++++++++++-
 arch/x86/kvm/x86.c                       |  95 ++++++++++++++--
 arch/x86/kvm/x86.h                       |  47 +++++++-
 27 files changed, 468 insertions(+), 86 deletions(-)


base-commit: 8baacf67c76c560fed954ac972b63e6e59a6fba0
-- 
2.27.0

