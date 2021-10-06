Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75C9D4244FE
	for <lists+kvm@lfdr.de>; Wed,  6 Oct 2021 19:42:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239860AbhJFRoB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Oct 2021 13:44:01 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:53654 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238664AbhJFRmp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 Oct 2021 13:42:45 -0400
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id BF2F0306E47B;
        Wed,  6 Oct 2021 20:30:52 +0300 (EEST)
Received: from localhost (unknown [91.199.104.28])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id A51BA3064495;
        Wed,  6 Oct 2021 20:30:52 +0300 (EEST)
X-Is-Junk-Enabled: fGZTSsP0qEJE2AIKtlSuFiRRwg9xyHmJ
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Mathieu Tarral <mathieu.tarral@protonmail.com>,
        Tamas K Lengyel <tamas@tklengyel.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v12 00/77] VM introspection
Date:   Wed,  6 Oct 2021 20:29:56 +0300
Message-Id: <20211006173113.26445-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The KVM introspection subsystem provides a facility for applications
running on the host or in a separate VM, to control the execution of
other VMs (pause, resume, shutdown), query the state of the vCPUs (GPRs,
MSRs etc.), alter the page access bits in the shadow page tables (only
for the hardware backed ones, eg. Intel's EPT) and receive notifications
when events of interest have taken place (shadow page table level faults,
key MSR writes, hypercalls etc.). Some notifications can be responded
to with an action (like preventing an MSR from being written), others
are mere informative (like breakpoint events which can be used for
execution tracing).  With few exceptions, all events are optional. An
application using this subsystem will explicitly register for them.

The use case that gave way for the creation of this subsystem is to
monitor the guest OS and as such the ABI/API is highly influenced by how
the guest software (kernel, applications) sees the world. For example,
some events provide information specific for the host CPU architecture
(eg. MSR_IA32_SYSENTER_EIP) merely because its leveraged by guest software
to implement a critical feature (fast system calls).

At the moment, the target audience for KVMI are security software authors
that wish to perform forensics on newly discovered threats (exploits)
or to implement another layer of security like preventing a large set
of kernel rootkits simply by "locking" the kernel image in the shadow
page tables (ie. enforce .text r-x, .rodata rw- etc.). It's the latter
case that made KVMI a separate subsystem, even though many of these
features are available in the device manager. The ability to build a
security application that does not interfere (in terms of performance)
with the guest software asks for a specialized interface that is designed
for minimum overhead.

Patches 1-28: make preparatory changes

Patches 29-75: add basic introspection capabilities

Patch 76: support introspection tools that write-protect guest page tables

Patch 77: notify the introspection tool even on emulation failures
          (when the read/write callbacks used by the emulator,
           kvm_page_preread/kvm_page_prewrite, are not called)

Changes since [v11](https://lore.kernel.org/kvm/20201207204622.15258-1-alazar@bitdefender.com/):
  - rebase to 5.15 (from 5.10)
  - remove patches no longer needed
  - remove kvm_get_max_gfn()/KVMI_VM_GET_MAX_GFN (a couple of tests are needed to see
    if it is better to send the memory size from QEMU, during handshake)

Adalbert Lazăr (23):
  KVM: UAPI: add error codes used by the VM introspection code
  KVM: add kvm_vcpu_kick_and_wait()
  KVM: x86: add kvm_x86_ops.control_cr3_intercept()
  KVM: x86: add kvm_x86_ops.desc_ctrl_supported()
  KVM: x86: add kvm_x86_ops.control_desc_intercept()
  KVM: x86: export kvm_vcpu_ioctl_x86_set_xsave()
  KVM: introspection: add hook/unhook ioctls
  KVM: introspection: add permission access ioctls
  KVM: introspection: add the read/dispatch message function
  KVM: introspection: add KVMI_GET_VERSION
  KVM: introspection: add KVMI_VM_CHECK_COMMAND and KVMI_VM_CHECK_EVENT
  KVM: introspection: add KVM_INTROSPECTION_PREUNHOOK
  KVM: introspection: add KVMI_VM_EVENT_UNHOOK
  KVM: introspection: add KVMI_VM_CONTROL_EVENTS
  KVM: introspection: add a jobs list to every introspected vCPU
  KVM: introspection: add KVMI_VM_PAUSE_VCPU
  KVM: introspection: add support for vCPU events
  KVM: introspection: add KVMI_VCPU_EVENT_PAUSE
  KVM: introspection: add KVMI_VM_CONTROL_CLEANUP
  KVM: introspection: add KVMI_VCPU_GET_XCR
  KVM: introspection: add KVMI_VCPU_SET_XSAVE
  KVM: introspection: extend KVMI_GET_VERSION with struct kvmi_features
  KVM: introspection: add KVMI_VCPU_TRANSLATE_GVA

Marian Rotariu (1):
  KVM: introspection: add KVMI_VCPU_GET_CPUID

Mihai Donțu (32):
  KVM: x86: add kvm_arch_vcpu_get_regs() and kvm_arch_vcpu_get_sregs()
  KVM: x86: avoid injecting #PF when emulate the VMCALL instruction
  KVM: x86: add kvm_x86_ops.control_msr_intercept()
  KVM: x86: save the error code during EPT/NPF exits handling
  KVM: x86: add kvm_x86_ops.fault_gla()
  KVM: x86: extend kvm_mmu_gva_to_gpa_system() with the 'access'
    parameter
  KVM: x86: page track: provide all callbacks with the guest virtual
    address
  KVM: x86: page track: add track_create_slot() callback
  KVM: x86: page_track: add support for preread, prewrite and preexec
  KVM: x86: wire in the preread/prewrite/preexec page trackers
  KVM: introduce VM introspection
  KVM: introspection: add KVMI_VM_GET_INFO
  KVM: introspection: add KVMI_VM_READ_PHYSICAL/KVMI_VM_WRITE_PHYSICAL
  KVM: introspection: handle vCPU introspection requests
  KVM: introspection: handle vCPU commands
  KVM: introspection: add KVMI_VCPU_GET_INFO
  KVM: introspection: add the crash action handling on the event reply
  KVM: introspection: add KVMI_VCPU_CONTROL_EVENTS
  KVM: introspection: add KVMI_VCPU_GET_REGISTERS
  KVM: introspection: add KVMI_VCPU_SET_REGISTERS
  KVM: introspection: add KVMI_VCPU_EVENT_HYPERCALL
  KVM: introspection: add KVMI_VCPU_EVENT_BREAKPOINT
  KVM: introspection: add KVMI_VCPU_CONTROL_CR and KVMI_VCPU_EVENT_CR
  KVM: introspection: add KVMI_VCPU_INJECT_EXCEPTION +
    KVMI_VCPU_EVENT_TRAP
  KVM: introspection: add KVMI_VCPU_EVENT_XSETBV
  KVM: introspection: add KVMI_VCPU_GET_XSAVE
  KVM: introspection: add KVMI_VCPU_GET_MTRR_TYPE
  KVM: introspection: add KVMI_VCPU_CONTROL_MSR and KVMI_VCPU_EVENT_MSR
  KVM: introspection: add KVMI_VM_SET_PAGE_ACCESS
  KVM: introspection: add KVMI_VCPU_EVENT_PF
  KVM: introspection: emulate a guest page table walk on SPT violations
    due to A/D bit updates
  KVM: x86: call the page tracking code on emulation failure

Mircea Cîrjaliu (2):
  KVM: x86: disable gpa_available optimization for fetch and page-walk
    SPT violations
  KVM: introspection: add vCPU related data

Nicușor Cîțu (19):
  KVM: x86: add kvm_arch_vcpu_set_regs()
  KVM: x86: add kvm_x86_ops.bp_intercepted()
  KVM: x86: add kvm_x86_ops.cr3_write_intercepted()
  KVM: svm: add support for descriptor-table VM-exits
  KVM: x86: add kvm_x86_ops.desc_intercepted()
  KVM: x86: add kvm_x86_ops.msr_write_intercepted()
  KVM: x86: svm: use the vmx convention to control the MSR interception
  KVM: x86: add kvm_x86_ops.control_singlestep()
  KVM: x86: export kvm_arch_vcpu_set_guest_debug()
  KVM: x86: export kvm_inject_pending_exception()
  KVM: x86: export kvm_vcpu_ioctl_x86_get_xsave()
  KVM: introspection: add cleanup support for vCPUs
  KVM: introspection: restore the state of #BP interception on unhook
  KVM: introspection: restore the state of CR3 interception on unhook
  KVM: introspection: add KVMI_VCPU_EVENT_DESCRIPTOR
  KVM: introspection: restore the state of descriptor-table register
    interception on unhook
  KVM: introspection: restore the state of MSR interception on unhook
  KVM: introspection: add KVMI_VCPU_CONTROL_SINGLESTEP
  KVM: introspection: add KVMI_VCPU_EVENT_SINGLESTEP

 Documentation/virt/kvm/api.rst                |  160 ++
 Documentation/virt/kvm/hypercalls.rst         |   35 +
 Documentation/virt/kvm/kvmi.rst               | 1554 +++++++++++++
 arch/x86/include/asm/kvm-x86-ops.h            |   10 +
 arch/x86/include/asm/kvm_host.h               |   46 +-
 arch/x86/include/asm/kvm_page_track.h         |   69 +-
 arch/x86/include/asm/kvmi_host.h              |  111 +
 arch/x86/include/asm/vmx.h                    |    2 +
 arch/x86/include/uapi/asm/kvmi.h              |  167 ++
 arch/x86/kvm/Kconfig                          |   10 +
 arch/x86/kvm/Makefile                         |    2 +
 arch/x86/kvm/emulate.c                        |    4 +
 arch/x86/kvm/kvm_emulate.h                    |    1 +
 arch/x86/kvm/kvmi.c                           | 1134 ++++++++++
 arch/x86/kvm/kvmi.h                           |   24 +
 arch/x86/kvm/kvmi_msg.c                       |  456 ++++
 arch/x86/kvm/mmu/mmu.c                        |  158 +-
 arch/x86/kvm/mmu/mmu_internal.h               |    6 +
 arch/x86/kvm/mmu/page_track.c                 |  144 +-
 arch/x86/kvm/mmu/spte.c                       |   23 +
 arch/x86/kvm/mmu/tdp_mmu.c                    |  106 +
 arch/x86/kvm/mmu/tdp_mmu.h                    |    6 +
 arch/x86/kvm/svm/sev.c                        |   18 +-
 arch/x86/kvm/svm/svm.c                        |  303 ++-
 arch/x86/kvm/svm/svm.h                        |   10 +-
 arch/x86/kvm/vmx/capabilities.h               |    7 +-
 arch/x86/kvm/vmx/vmx.c                        |  150 +-
 arch/x86/kvm/vmx/vmx.h                        |    4 -
 arch/x86/kvm/x86.c                            |  301 ++-
 drivers/gpu/drm/i915/gvt/kvmgt.c              |    2 +-
 include/linux/kvm_host.h                      |   16 +
 include/linux/kvmi_host.h                     |  110 +
 include/uapi/linux/kvm.h                      |   20 +
 include/uapi/linux/kvm_para.h                 |    5 +
 include/uapi/linux/kvmi.h                     |  240 ++
 tools/testing/selftests/kvm/Makefile          |    1 +
 .../testing/selftests/kvm/x86_64/kvmi_test.c  | 1993 +++++++++++++++++
 virt/kvm/introspection/kvmi.c                 | 1265 +++++++++++
 virt/kvm/introspection/kvmi_int.h             |  129 ++
 virt/kvm/introspection/kvmi_msg.c             |  902 ++++++++
 virt/kvm/kvm_main.c                           |   73 +
 41 files changed, 9618 insertions(+), 159 deletions(-)
 create mode 100644 Documentation/virt/kvm/kvmi.rst
 create mode 100644 arch/x86/include/asm/kvmi_host.h
 create mode 100644 arch/x86/include/uapi/asm/kvmi.h
 create mode 100644 arch/x86/kvm/kvmi.c
 create mode 100644 arch/x86/kvm/kvmi.h
 create mode 100644 arch/x86/kvm/kvmi_msg.c
 create mode 100644 include/linux/kvmi_host.h
 create mode 100644 include/uapi/linux/kvmi.h
 create mode 100644 tools/testing/selftests/kvm/x86_64/kvmi_test.c
 create mode 100644 virt/kvm/introspection/kvmi.c
 create mode 100644 virt/kvm/introspection/kvmi_int.h
 create mode 100644 virt/kvm/introspection/kvmi_msg.c


base-commit: 542a2640a2f491902fd366b5bb54a2b20ac5a2c5
