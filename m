Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0464396F62
	for <lists+kvm@lfdr.de>; Tue,  1 Jun 2021 10:48:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233764AbhFAItn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Jun 2021 04:49:43 -0400
Received: from mga07.intel.com ([134.134.136.100]:45129 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233561AbhFAItj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Jun 2021 04:49:39 -0400
IronPort-SDR: Plp4X3BqkkHDZUK4TEh+CqRwdaNSfBBddRHiLmlciDvkqPC4q21YqEPHQNeEJdUSL9gdq+Pnzf
 rzNavRevziTQ==
X-IronPort-AV: E=McAfee;i="6200,9189,10001"; a="267381282"
X-IronPort-AV: E=Sophos;i="5.83,239,1616482800"; 
   d="scan'208";a="267381282"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2021 01:47:58 -0700
IronPort-SDR: lrZRXcbg4/b7RscuTnXd4PtKeNIMa/vn4TqWFjEcs+W1ppUsVkOdTTO5jp6Gm1QXTaTQ19NsHV
 hZd15I7lgNqA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,239,1616482800"; 
   d="scan'208";a="437967726"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by orsmga007.jf.intel.com with ESMTP; 01 Jun 2021 01:47:54 -0700
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        kvm@vger.kernel.org
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        chang.seok.bae@intel.com, robert.hu@intel.com,
        robert.hu@linux.intel.com
Subject: [PATCH 00/15] KVM: Support Intel Key Locker
Date:   Tue,  1 Jun 2021 16:47:39 +0800
Message-Id: <1622537274-146420-1-git-send-email-robert.hu@linux.intel.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=y
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch set is to support KVM virtualization of Key Locker feature
[1][2].

Key Locker provides a mechanism to encrypt and decrypt data without
directly providing AES key but a "handle" instead.
Handles are essentially an encrypted form of those underlying real AES
keys. "IWKey (Internal Wrapping Key)", loaded inside CPU, inaccessible from
outside, is the key used to seal real AES Keys into handles.
Thus, a real AES Key exists in memory for only a short period of time, when
user is requesting a 'handle' from it. After that, the real AES Key can be
erased, user then uses handle, with new Key Locker instructions, to perform
AES encryption/decryption. By OS policy, usually, handles will be revoked
after reboot, then any handles that may have been stolen should no longer
be useful to the attacker after the reboot.

IWKey, is the core of this framework. It is loaded into CPU by LOADIWKEY
instruction, then inaccessible from CPU-outside anymore. LOADIWKEY is the
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
1) don't expose HW randomize IWKey capability (CPUID.0x19.ECX[1]) to
guest. As such, guest IWKey cannot be preserved by VMM across vCPU switch.
(VMM cannot know what IWKey is set in physical CPU if HW randomized.)
2) guests and host can only use Key Locker feature exclusively. [4] 

The virtualization implementation is generally straight forward
1) On VM-Exit of guest 'LOADIWKEY', VMM stores the IWKey of that vCPU, and
set in physical CPU on behalf.
2) On each vCPU load/put, VMM is responsible to set IWKEY to pCPU or clear
it.
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

To the end, we don't suggest this feature to be migratable, as if so, IWKey
would have to be exposed to user space, which would further weaken this
feature's security significance.

P.S. this patch set is based on Chang's Kernel Key Locker upstream-v2
https://lore.kernel.org/lkml/20210514201508.27967-1-chang.seok.bae@intel.com/

Patch 1 ~ 3, x86 code, which lay the foundation of following KVM patches.
Have been reviewed by Tony Luck.
Patch 4 ~ 9, KVM enabling of Key Locker.
Patch 10 ~ 15, nested VMX support for Key Locker.

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

---
Change log since last RFC patch set:
* Don't loadiwkey every VM-Exit/Entry. (Sean Christopherson)
* Don't enable Tertiary VM-Exec Control if using eVMCS, as its support in
enlightened VMCS isn't ready yet. (Vitaly Kuznetsov)
* Extended BUILD_CONTROLS_SHADOW to support 64-bit variation. (Sean
Christopherson)
* Refactored patch set and other changes.


Hu, Robert (2):
  kvm/vmx: Detect Tertiary VM-Execution control when setup VMCS config
  kvm/vmx: dump_vmcs() reports tertiary_exec_control field as well

Robert Hoo (13):
  x86/keylocker: Move KEYSRC_{SW,HW}RAND to keylocker.h
  x86/cpufeatures: Define Key Locker sub feature flags
  x86/feat_ctl: Add new VMX feature, Tertiary VM-Execution control and  
      LOADIWKEY Exiting
  kvm/vmx: Extend BUILD_CONTROLS_SHADOW macro to support 64-bit
    variation
  kvm/vmx: Set Tertiary VM-Execution control field When init vCPU's VMCS
  kvm/vmx: Add KVM support on guest Key Locker operations
  kvm/cpuid: Enumerate Key Locker feature in KVM
  kvm/vmx/nested: Support new IA32_VMX_PROCBASED_CTLS3 vmx capability
    MSR
  kvm/vmx: Implement vmx_compute_tertiary_exec_control()
  kvm/vmx/vmcs12: Add Tertiary VM-Exec control field in vmcs12
  kvm/vmx/nested: Support Tertiary VM-Exec control in vmcs02
  kvm/vmx/nested: Support CR4.KL in nested
  kvm/vmx/nested: Enable nested LOADIWKEY VM-exit

 arch/x86/include/asm/cpufeatures.h |   5 +
 arch/x86/include/asm/keylocker.h   |   3 +
 arch/x86/include/asm/kvm_host.h    |  24 ++-
 arch/x86/include/asm/msr-index.h   |   1 +
 arch/x86/include/asm/vmx.h         |   9 ++
 arch/x86/include/asm/vmxfeatures.h |   6 +-
 arch/x86/include/uapi/asm/vmx.h    |   2 +
 arch/x86/kernel/cpu/feat_ctl.c     |   9 ++
 arch/x86/kernel/cpu/scattered.c    |   5 +
 arch/x86/kernel/keylocker.c        |   2 -
 arch/x86/kvm/cpuid.c               |  26 +++-
 arch/x86/kvm/reverse_cpuid.h       |  32 +++-
 arch/x86/kvm/vmx/capabilities.h    |   9 ++
 arch/x86/kvm/vmx/evmcs.c           |   2 +
 arch/x86/kvm/vmx/evmcs.h           |   1 +
 arch/x86/kvm/vmx/nested.c          |  38 ++++-
 arch/x86/kvm/vmx/nested.h          |   7 +
 arch/x86/kvm/vmx/vmcs.h            |   1 +
 arch/x86/kvm/vmx/vmcs12.c          |   1 +
 arch/x86/kvm/vmx/vmcs12.h          |   4 +-
 arch/x86/kvm/vmx/vmx.c             | 290 ++++++++++++++++++++++++++++++++++++-
 arch/x86/kvm/vmx/vmx.h             |  24 +--
 arch/x86/kvm/x86.c                 |   2 +
 arch/x86/kvm/x86.h                 |   2 +
 24 files changed, 475 insertions(+), 30 deletions(-)

-- 
1.8.3.1

