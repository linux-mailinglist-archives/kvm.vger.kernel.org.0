Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F114155DD3
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 19:18:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726988AbgBGSSt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 13:18:49 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:40530 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726900AbgBGSQl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Feb 2020 13:16:41 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 73C5130747CA;
        Fri,  7 Feb 2020 20:16:38 +0200 (EET)
Received: from host.bbu.bitdefender.biz (unknown [195.210.4.22])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 56DE03000082;
        Fri,  7 Feb 2020 20:16:38 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Mathieu Tarral <mathieu.tarral@protonmail.com>,
        Patrick Colp <patrick.colp@oracle.com>,
        =?UTF-8?q?Samuel=20Laur=C3=A9n?= <samuel.lauren@iki.fi>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Tamas K Lengyel <tamas@tklengyel.com>,
        Weijiang Yang <weijiang.yang@intel.com>
Subject: [RFC PATCH v7 00/78] VM introspection
Date:   Fri,  7 Feb 2020 20:15:18 +0200
Message-Id: <20200207181636.1065-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
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

This patch series is based on kvm/master,
commit 2f13437b8917 ("Merge tag 'trace-v5.5-2' of git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace").

The previous RFC (v6) can be read here:

	https://lore.kernel.org/kvm/20190809160047.8319-1-alazar@bitdefender.com/

Patches 1-35: make preparatory changes

Patches 36-76: add basic introspection capabilities

Patch 77: support introspection tools that write-protect guest page tables

Patch 78: notify the introspection tool even on emulation failures
          (when the read/write callbacks used by the emulator,
           kvm_page_preread/kvm_page_prewrite, are not invoked)

Changes since v6:
    - this is a subset of the previous version, as Sean and Paolo suggested,
      keeping "only" the basic introspection capabilities
    - add a x86_64 test in tools/testing/selftests/kvm [Paolo]
    - simplify the requests/replies handling [Paolo]
    - add a new ioctl (PREHOOK) to notify the introspection tool to unhook
      [Paolo, Sean]
    - add two new commands KVMI_VCPU_CONTROL_SINGLESTEP
      and KVMI_VCPU_TRANSLATE_GVA [Mathieu]
    - restore the status of MSRs, CR3, descriptors access interception
      and prevent conflicts with userspace [Sean]
    - other fixes for allmost all the issues pointed in the previous
      code review [Sean, Paolo]

Adalbert Lazăr (19):
  sched/swait: add swait_event_killable_exclusive()
  KVM: add new error codes for VM introspection
  KVM: add kvm_vcpu_kick_and_wait()
  KVM: doc: fix the hypercall numbering
  KVM: x86: add .control_cr3_intercept() to struct kvm_x86_ops
  KVM: x86: add .control_desc_intercept()
  KVM: x86: intercept the write access on sidt and other emulated
    instructions
  KVM: introspection: add hook/unhook ioctls
  KVM: introspection: add permission access ioctls
  KVM: introspection: add the read/dispatch message function
  KVM: introspection: add KVMI_GET_VERSION
  KVM: introspection: add KVMI_VM_CHECK_COMMAND and KVMI_VM_CHECK_EVENT
  KVM: introspection: add KVMI_EVENT_UNHOOK
  KVM: introspection: add KVMI_VM_CONTROL_EVENTS
  KVM: introspection: add a jobs list to every introspected vCPU
  KVM: introspection: add KVMI_VCPU_PAUSE
  KVM: introspection: add KVMI_EVENT_PAUSE_VCPU
  KVM: introspection: extend KVMI_GET_VERSION with struct kvmi_features
  KVM: introspection: add KVMI_VCPU_TRANSLATE_GVA

Marian Rotariu (1):
  KVM: introspection: add KVMI_VCPU_GET_CPUID

Mathieu Tarral (1):
  export kill_pid_info()

Mihai Donțu (34):
  KVM: x86: add kvm_arch_vcpu_get_regs() and kvm_arch_vcpu_get_sregs()
  KVM: x86: avoid injecting #PF when emulate the VMCALL instruction
  KVM: x86: add .control_msr_intercept()
  KVM: x86: vmx: use a symbolic constant when checking the exit
    qualifications
  KVM: x86: save the error code during EPT/NPF exits handling
  KVM: x86: add .fault_gla()
  KVM: x86: add .spt_fault()
  KVM: x86: add .gpt_translation_fault()
  KVM: x86: extend kvm_mmu_gva_to_gpa_system() with the 'access'
    parameter
  KVM: x86: page track: provide all page tracking hooks with the guest
    virtual address
  KVM: x86: page track: add track_create_slot() callback
  KVM: x86: page_track: add support for preread, prewrite and preexec
  KVM: x86: wire in the preread/prewrite/preexec page trackers
  KVM: introduce VM introspection
  KVM: introspection: add KVMI_VM_GET_INFO
  KVM: introspection: add KVMI_VM_READ_PHYSICAL/KVMI_VM_WRITE_PHYSICAL
  KVM: introspection: handle vCPU introspection requests
  KVM: introspection: handle vCPU commands
  KVM: introspection: add KVMI_VCPU_GET_INFO
  KVM: introspection: add KVMI_VCPU_CONTROL_EVENTS
  KVM: introspection: add KVMI_VCPU_GET_REGISTERS
  KVM: introspection: add KVMI_VCPU_SET_REGISTERS
  KVM: introspection: add KVMI_EVENT_HYPERCALL
  KVM: introspection: add KVMI_EVENT_BREAKPOINT
  KVM: introspection: add KVMI_VCPU_CONTROL_CR and KVMI_EVENT_CR
  KVM: introspection: add KVMI_VCPU_INJECT_EXCEPTION + KVMI_EVENT_TRAP
  KVM: introspection: add KVMI_EVENT_XSETBV
  KVM: introspection: add KVMI_VCPU_GET_XSAVE
  KVM: introspection: add KVMI_VCPU_GET_MTRR_TYPE
  KVM: introspection: add KVMI_VCPU_CONTROL_MSR and KVMI_EVENT_MSR
  KVM: introspection: add KVMI_VM_SET_PAGE_ACCESS
  KVM: introspection: add KVMI_EVENT_PF
  KVM: introspection: emulate a guest page table walk on SPT violations
    due to A/D bit updates
  KVM: x86: call the page tracking code on emulation failure

Mircea Cîrjaliu (2):
  KVM: x86: disable gpa_available optimization for fetch and page-walk
    NPF/EPT violations
  KVM: introspection: add vCPU related data

Nicușor Cîțu (19):
  KVM: x86: add kvm_arch_vcpu_set_regs()
  KVM: x86: add .bp_intercepted() to struct kvm_x86_ops
  KVM: x86: add .cr3_write_intercepted()
  KVM: x86: add .desc_intercepted()
  KVM: x86: export .msr_write_intercepted()
  KVM: x86: use MSR_TYPE_R, MSR_TYPE_W and MSR_TYPE_RW with AMD code too
  KVM: svm: pass struct kvm_vcpu to set_msr_interception()
  KVM: vmx: pass struct kvm_vcpu to the intercept msr related functions
  KVM: x86: add .control_singlestep()
  KVM: x86: export kvm_arch_vcpu_set_guest_debug()
  KVM: x86: export kvm_inject_pending_exception()
  KVM: x86: export kvm_vcpu_ioctl_x86_get_xsave()
  KVM: introspection: restore the state of #BP interception on unhook
  KVM: introspection: restore the state of CR3 interception on unhook
  KVM: introspection: add KVMI_EVENT_DESCRIPTOR
  KVM: introspection: restore the state of descriptor interception on
    unhook
  KVM: introspection: restore the state of MSR interception on unhook
  KVM: introspection: add KVMI_VCPU_CONTROL_SINGLESTEP
  KVM: introspection: add KVMI_EVENT_SINGLESTEP

Ștefan Șicleru (2):
  KVM: add kvm_get_max_gfn()
  KVM: introspection: add KVMI_VM_GET_MAX_GFN

 Documentation/virt/kvm/api.txt                |  115 +
 Documentation/virt/kvm/hypercalls.txt         |   36 +-
 Documentation/virt/kvm/kvmi.rst               | 1413 +++++++++++++
 arch/x86/include/asm/kvm_emulate.h            |    1 +
 arch/x86/include/asm/kvm_host.h               |   36 +-
 arch/x86/include/asm/kvm_page_track.h         |   71 +-
 arch/x86/include/asm/kvmi_host.h              |   91 +
 arch/x86/include/asm/vmx.h                    |    2 +
 arch/x86/include/uapi/asm/kvmi.h              |  147 ++
 arch/x86/kvm/Kconfig                          |    9 +
 arch/x86/kvm/Makefile                         |    2 +
 arch/x86/kvm/emulate.c                        |    4 +
 arch/x86/kvm/kvmi.c                           | 1168 +++++++++++
 arch/x86/kvm/mmu.h                            |    4 +
 arch/x86/kvm/mmu/mmu.c                        |  160 +-
 arch/x86/kvm/mmu/page_track.c                 |  142 +-
 arch/x86/kvm/svm.c                            |  272 ++-
 arch/x86/kvm/vmx/vmx.c                        |  265 ++-
 arch/x86/kvm/vmx/vmx.h                        |    4 -
 arch/x86/kvm/x86.c                            |  296 ++-
 drivers/gpu/drm/i915/gvt/kvmgt.c              |    2 +-
 include/linux/kvm_host.h                      |   18 +
 include/linux/kvmi_host.h                     |  126 ++
 include/linux/swait.h                         |   11 +
 include/uapi/linux/kvm.h                      |   20 +
 include/uapi/linux/kvm_para.h                 |    5 +
 include/uapi/linux/kvmi.h                     |  217 ++
 kernel/signal.c                               |    1 +
 tools/testing/selftests/kvm/Makefile          |    1 +
 .../testing/selftests/kvm/x86_64/kvmi_test.c  | 1864 +++++++++++++++++
 virt/kvm/introspection/kvmi.c                 | 1408 +++++++++++++
 virt/kvm/introspection/kvmi_int.h             |  178 ++
 virt/kvm/introspection/kvmi_msg.c             | 1149 ++++++++++
 virt/kvm/kvm_main.c                           |   69 +
 34 files changed, 9132 insertions(+), 175 deletions(-)
 create mode 100644 Documentation/virt/kvm/kvmi.rst
 create mode 100644 arch/x86/include/asm/kvmi_host.h
 create mode 100644 arch/x86/include/uapi/asm/kvmi.h
 create mode 100644 arch/x86/kvm/kvmi.c
 create mode 100644 include/linux/kvmi_host.h
 create mode 100644 include/uapi/linux/kvmi.h
 create mode 100644 tools/testing/selftests/kvm/x86_64/kvmi_test.c
 create mode 100644 virt/kvm/introspection/kvmi.c
 create mode 100644 virt/kvm/introspection/kvmi_int.h
 create mode 100644 virt/kvm/introspection/kvmi_msg.c


base-commit: 2f13437b8917627119d163d62f73e7a78a92303a
CC: Jan Kiszka <jan.kiszka@siemens.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Mathieu Tarral <mathieu.tarral@protonmail.com>
CC: Patrick Colp <patrick.colp@oracle.com>
CC: Samuel Laurén <samuel.lauren@iki.fi>
CC: Stefan Hajnoczi <stefanha@redhat.com>
CC: Tamas K Lengyel <tamas@tklengyel.com>
CC: Weijiang Yang <weijiang.yang@intel.com>
