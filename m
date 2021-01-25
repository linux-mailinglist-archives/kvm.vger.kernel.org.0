Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21766303415
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 06:16:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730125AbhAZFOq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 00:14:46 -0500
Received: from mga14.intel.com ([192.55.52.115]:22891 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726484AbhAYJYs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Jan 2021 04:24:48 -0500
IronPort-SDR: yg+XNjqOOVMuo4R62xwcHYJhJB0D9vtSI7j6LYF1pzVZ0vyHB4nE3We3S8kgYcFUjtjt8/xe2y
 TcZDyNo8lZjQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9874"; a="178915772"
X-IronPort-AV: E=Sophos;i="5.79,373,1602572400"; 
   d="scan'208";a="178915772"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2021 01:07:00 -0800
IronPort-SDR: kzLEPq1A2kRrDIeWOy9sfD1Ak86o2cn+9L0otfA1S1iHlvpPUVsPNbZvbjWayFrWOeFi87+qVJ
 N0tfmh4dMzJA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,373,1602572400"; 
   d="scan'208";a="402223784"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by fmsmga004.fm.intel.com with ESMTP; 25 Jan 2021 01:06:57 -0800
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org
Cc:     chang.seok.bae@intel.com, kvm@vger.kernel.org, robert.hu@intel.com,
        Robert Hoo <robert.hu@linux.intel.com>
Subject: [RFC PATCH 00/12] KVM: Support Intel KeyLocker
Date:   Mon, 25 Jan 2021 17:06:08 +0800
Message-Id: <1611565580-47718-1-git-send-email-robert.hu@linux.intel.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=y
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch set is to enable KVM virtualization of Key Locker feature [1][2].

Key Locker provides a mechanism to encrypt and decrypt data with an AES key
without having access to the raw key value by converting AES keys into
"handles".
Handles are essentially an encrypted form of those underlying real AES
keys. "IWKey (Internal Wrapping Key)", loaded inside CPU, inaccessible from
SW, is the key used to seal real AES Keys into handles.
Thus, a real AES Key exists in memory for only a short period of time, when
user is requesting a 'handle' from it. After that, the real AES Key can be
erased, user then uses handle, with new Key Locker instructions, to perform
AES encryption/decryption. By OS policy, usually, handles will be revoked
after reboot, then any handles that may have been stolen should no longer
be useful to the attacker after the reboot.

IWKey, is the core of this framework. It is loaded into CPU by LOADIWKEY
instruction, then inaccessible from (CPU) outside anymore. LOADIWKEY is the
only Key Locker instruction that will cause VM-exit (if we set so in VM
Execution Control). When load IWKey into CPU, we can ask CPU further
randomize it, if HW supports this.
The IWKey can also be distributed among CPUs, rather than LOADIWKEY on each
CPU, by: first backup IWKey to platform specific storage, then copy it on
target CPU. The backup process is triggered by writing to MSR
IA32_COPY_LOCAL_TO_PLATFORM. The restore process is triggered by writing to
MSR IA32_COPY_PLATFORM_LOCAL.
 
Virtualization Design
Key Locker Spec [2] indicates virtualization limitations by current HW
implementation.
1) IWKey cannot be read from CPU after it's loaded (this is the nature of
this feature) and only 1 copy of IWKey inside 1 CPU.
2) Initial implementations may take a significant amount of time to perform
a copy of IWKeyBackup to IWKey (via a write to MSR
IA32_COPY_PLATFORM_LOCAL) so it may cause a significant performance impact
to reload IWKey after each VM exit.
 
Due to above reasons, virtualization design makes below decisions
1) don't expose HW randomize IWKey capability (CPUID.0x19.ECX[1]) to guest. 
   As such, guest IWKey cannot be preserved by VMM across VM-{Exit, Entry}.
   (VMM cannot know what exact IWKey were set by CPU)
2) guests and host can only use Key Locker feature exclusively. [4] 

The virtualization implementation is generally straight forward
1) On VM-Exit of guest 'LOADIWKEY', VMM stores the IWKey in vCPU scope
        area (kvm_vcpu_arch)
2) Right before VM-Entry, VMM load that vCPU's IWKey in to pCPU, by
LOADIWKEY instruction.
3) On guest backup local to platform operation, VMM traps the write
   to MSR, and simulate the IWKey store process by store it in a KVM
   scope area (kvm_arch), mark the success status in the shadow
   msr_ia32_iwkey_backup_status and msr_ia32_copy_status.
4) On guest copy from platform to local operation, VMM traps the write
   to MSR and simulate the process by load kvm_arch.iwkey_backup to
   vCPU.iwkey; and simulate the success status in the
   shadow msr_ia32_copy_status.
5) Guest read the 2 status MSRs will also be trapped and return the shadow
   value.
6) Other Key Locker instructions can run without VM-Exit in non-root mode.

At the end, we don't suggest this feature to be migratable, as if so, IWKey
would have to be exposed to user space, which would weaken this feature's
security significance.

BTW, this patch set is based on Kernel v5.10 (2c85ebc) + Kernel Key Locker
enabling patches [3].


[1] Intel Architecture Instruction Set Extensions Programming Reference:
https://software.intel.com/content/www/us/en/develop/download/intel-architecture-instruction-set-extensions-programming-reference.html

[2] Intel Key Locker Specification:
https://software.intel.com/content/www/us/en/develop/download/intel-key-locker-specification.html 

[3] Kernel enablement patch:
https://lore.kernel.org/lkml/20201216174146.10446-1-chang.seok.bae@intel.com/
 
[4] It's possible to use Key Locker by both the guest and host, albeit with
reduced security benefits. I.e., store host IWKey in VMM scoped place
(memory/register), VMM switches host-IWKey and guest-IWKey between
VM-{Exit/Entry} by LOADIWKEY instruction.
But in this case, an adversary that can observe arbitrary VMM memory may be
able to steal both the handles and IWKey. And this case also require the
VMM to be running before the first IWKey load.


Robert Hoo (12):
  x86/keylocker: Move LOADIWKEY opcode definition from keylocker.c to
    keylocker.h
  x86/cpufeature: Add CPUID.19H:{EBX,ECX} cpuid leaves
  kvm/vmx: Introduce the new tertiary processor-based VM-execution
    controls
  kvm/vmx: enable LOADIWKEY vm-exit support in tertiary processor-based
    VM-execution controls
  kvm/vmx: Add KVM support on KeyLocker operations
  kvm/cpuid: Enumerate KeyLocker feature in KVM
  kvm/vmx/nested: Support new IA32_VMX_PROCBASED_CTLS3 vmx feature
    control MSR
  kvm/vmx: Refactor vmx_compute_tertiary_exec_control()
  kvm/vmx/vmcs12: Add Tertiary Exec-Control field in vmcs12
  kvm/vmx/nested: Support tertiary VM-Exec control in vmcs02
  kvm/vmx/nested: Support CR4.KL in nested
  kvm/vmx/nested: Enable nested LOADIWKey VM-exit

 arch/x86/include/asm/cpufeature.h        |   6 +-
 arch/x86/include/asm/cpufeatures.h       |  11 +-
 arch/x86/include/asm/disabled-features.h |   2 +-
 arch/x86/include/asm/keylocker.h         |   2 +
 arch/x86/include/asm/kvm_host.h          |  24 ++-
 arch/x86/include/asm/msr-index.h         |   1 +
 arch/x86/include/asm/required-features.h |   2 +-
 arch/x86/include/asm/vmx.h               |   9 ++
 arch/x86/include/asm/vmxfeatures.h       |   6 +-
 arch/x86/include/uapi/asm/vmx.h          |   5 +-
 arch/x86/kernel/cpu/common.c             |   7 +
 arch/x86/kernel/cpu/feat_ctl.c           |   9 ++
 arch/x86/kernel/keylocker.c              |   1 -
 arch/x86/kvm/cpuid.c                     |  26 +++-
 arch/x86/kvm/cpuid.h                     |   2 +
 arch/x86/kvm/vmx/capabilities.h          |   9 ++
 arch/x86/kvm/vmx/nested.c                |  34 +++-
 arch/x86/kvm/vmx/nested.h                |   7 +
 arch/x86/kvm/vmx/vmcs.h                  |   1 +
 arch/x86/kvm/vmx/vmcs12.c                |   1 +
 arch/x86/kvm/vmx/vmcs12.h                |   3 +-
 arch/x86/kvm/vmx/vmx.c                   | 258 ++++++++++++++++++++++++++++++-
 arch/x86/kvm/vmx/vmx.h                   |   9 ++
 arch/x86/kvm/x86.c                       |   6 +-
 arch/x86/kvm/x86.h                       |   2 +
 25 files changed, 422 insertions(+), 21 deletions(-)

-- 
1.8.3.1

