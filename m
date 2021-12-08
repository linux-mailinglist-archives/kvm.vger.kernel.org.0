Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1688746BEB5
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 16:09:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238473AbhLGPMh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 10:12:37 -0500
Received: from mga14.intel.com ([192.55.52.115]:5480 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229503AbhLGPMh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Dec 2021 10:12:37 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10190"; a="237820954"
X-IronPort-AV: E=Sophos;i="5.87,293,1631602800"; 
   d="scan'208";a="237820954"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2021 07:09:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,293,1631602800"; 
   d="scan'208";a="461289713"
Received: from icx.bj.intel.com ([10.240.192.117])
  by orsmga003.jf.intel.com with ESMTP; 07 Dec 2021 07:09:01 -0800
From:   Yang Zhong <yang.zhong@intel.com>
To:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, pbonzini@redhat.com
Cc:     seanjc@google.com, jun.nakajima@intel.com, kevin.tian@intel.com,
        jing2.liu@linux.intel.com, jing2.liu@intel.com,
        yang.zhong@intel.com
Subject: [PATCH 00/19] AMX Support in KVM
Date:   Tue,  7 Dec 2021 19:03:40 -0500
Message-Id: <20211208000359.2853257-1-yang.zhong@intel.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

(send on behalf of Jing who is currently on leave)

This series brings AMX (Advanced Matrix eXtensions) virtualization
support to KVM. The three preparation patches in fpu core from 
Thomas [1] are also included. 

A large portion of the changes in this series is to deal with eXtended
Feature Disable (XFD) which allows resizing of the fpstate buffer to 
support dynamically-enabled XSTATE features with large state component
(e.g. 8K for AMX).

The support is based on several key changes (design discussions can be
found in [2]):

  - Guest permissions for dynamically-enabled XSAVE features

    Native tasks have to request permission via prctl() before touching
    a dynamic-resized XSTATE compoenent. Introduce guest permissions 
    for the similar purpose. Userspace VMM is expected to request guest
    permission only once when the first vCPU is created.

    KVM checks guest permission in KVM_SET_CPUID2. Setting XFD in guest
    cpuid w/o proper permissions fails this operation.

  - Extend fpstate reallocation mechanism to cover guest fpu

    Unlike native tasks which have reallocation triggered from #NM 
    handler, guest fpstate reallocation is requested by KVM when it
    detects the guest intention to use dynamically-enabled XSAVE
    features.

    The reallocation request is handled when exiting to userspace
    VMM. This implies that KVM must break vcpu_run() loop and exit
    to userspace VMM instead of immediately resuming back to the guest
    when reallocation is required.

  - Detect fpstate reallocation in the emulation code

    Because guest #NM is not trapped in KVM (costly), the guest 
    intention of using a dynamically-enabled XSAVE feature[i] can be
    indirectly represented by guest XCR0[i]=1 and XFD[i]=0. This 
    requires the emulation logic of both WRMSR(IA32_XFD) and XSETBV 
    to check reallocation requirement when one of the two conditions
    is changed.

  - Disable WRMSR interception for IA32_XFD

    IA32_XFD can be frequently updated by the guest, as it is part of
    the task state and swapped in context switch when prev and next have
    different XFD setting. Always intercepting WRMSR can easily cause
    non-negligible overhead.

    Disable WRMSR interception for IA32_XFD after fpstate reallocation
    succeeds. After that point the guest direct writes IA32_XFD without
    causing VM-exits.

    However MSR passthrough implies that guest_fpstate::xfd and per-cpu
    xfd cache might be out of sync with the current IA32_XFD value set by
    the guest. This suggests KVM needs to re-sync the software state
    with IA32_XFD before the vCPU thread might be preempted or interrupted.

  - Save/restore guest XFD_ERR

    When XFD causes an instruction to generate #NM, XFD_ERR contains
    information about which disabled state components are being accessed.
    The #NM handler is expected to check this information and then enable
    the state components by clearing IA32_XFD for the faulting task (if 
    having permission).

    #NM can be triggered in both host and guest. It'd be problematic if
    the XFD_ERR value generated in guest is consumed/clobbered by the 
    host before the guest itself doing so. This may lead to non-XFD-
    related #NM treated as XFD #NM in host (due to guest XFD_ERR value),
    or XFD-related #NM treated as non-XFD #NM in guest (XFD_ERR cleared 
    by the host #NM handler).

    KVM needs to save the guest XFD_ERR value before this register
    might be accessed by the host and restore it before entering the 
    guest.

    One open remains in this area about when to start saving/restoring
    guest XFD_ERR. Several options are discussed in patch 15.

  - Expose related cpuid bits to guest

    The last step is to allow exposing XFD, AMX_TILE, AMX_INT8 and
    AMX_BF16 in guest cpuid. Adding those bits into kvm_cpu_caps finally
    activates all previous logics in this series

To verify AMX virtualization overhead on non-AMX usages, we run the
Phoronix kernel build test in the guest w/ and w/o AMX in cpuid. The 
result shows no observable difference between two configurations.

Live migration support is still being worked on. Userspace VMM needs
to use the new KVM_{G|S}SET_XSAVE2 ioctl in this series to migrate state
for dynamically-enabled XSAVE features.

Thanks Thomas for the thoughts and patches on the KVM FPU and AMX
support. Thanks Jun Nakajima for the design suggestions.

[1] git://git.kernel.org/pub/scm/linux/kernel/git/tglx/devel.git x86/fpu-kvm
[2] https://www.spinics.net/lists/kvm/msg259015.html

Thanks,
Yang

---
Jing Liu (13):
  kvm: x86: Fix xstate_required_size() to follow XSTATE alignment rule
  kvm: x86: Check guest xstate permissions when KVM_SET_CPUID2
  x86/fpu: Move xfd initialization out of __fpstate_reset() to the
    callers
  kvm: x86: Propagate fpstate reallocation error to userspace
  x86/fpu: Move xfd_update_state() to xstate.c and export symbol
  kvm: x86: Prepare reallocation check
  kvm: x86: Emulate WRMSR of guest IA32_XFD
  kvm: x86: Disable WRMSR interception for IA32_XFD on demand
  x86/fpu: Prepare for KVM XFD_ERR handling
  kvm: x86: Introduce KVM_{G|S}ET_XSAVE2 ioctl
  docs: virt: api.rst: Document the new KVM_{G, S}ET_XSAVE2 ioctls
  kvm: x86: AMX XCR0 support for guest
  kvm: x86: Add AMX CPUIDs support

Thomas Gleixner (4):
  x86/fpu: Extend prctl() with guest permissions
  x86/fpu: Prepare KVM for dynamically enabled states
  x86/fpu: Add reallocation mechanims for KVM
  x86/fpu: Prepare KVM for bringing XFD state back in-sync

Yang Zhong (2):
  kvm: x86: Check fpstate reallocation in XSETBV emulation
  kvm: x86: Save and restore guest XFD_ERR properly

 Documentation/virt/kvm/api.rst     |  47 +++++++
 arch/x86/include/asm/cpufeatures.h |   2 +
 arch/x86/include/asm/fpu/api.h     |  12 ++
 arch/x86/include/asm/fpu/types.h   |  56 +++++++++
 arch/x86/include/asm/fpu/xstate.h  |   2 +
 arch/x86/include/asm/kvm-x86-ops.h |   1 +
 arch/x86/include/asm/kvm_host.h    |   2 +
 arch/x86/include/uapi/asm/kvm.h    |   6 +
 arch/x86/include/uapi/asm/prctl.h  |  26 ++--
 arch/x86/kernel/fpu/core.c         | 109 ++++++++++++++++-
 arch/x86/kernel/fpu/xstate.c       | 119 +++++++++++++++---
 arch/x86/kernel/fpu/xstate.h       |  29 +++--
 arch/x86/kernel/process.c          |   2 +
 arch/x86/kvm/cpuid.c               |  36 +++++-
 arch/x86/kvm/vmx/vmx.c             |  20 +++
 arch/x86/kvm/vmx/vmx.h             |   2 +-
 arch/x86/kvm/x86.c                 | 189 ++++++++++++++++++++++++++++-
 arch/x86/kvm/x86.h                 |   2 +
 include/uapi/linux/kvm.h           |   8 +-
 19 files changed, 607 insertions(+), 63 deletions(-)

