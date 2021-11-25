Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA72A45D18C
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 01:21:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346977AbhKYAYK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 19:24:10 -0500
Received: from mga17.intel.com ([192.55.52.151]:31426 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234573AbhKYAYJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Nov 2021 19:24:09 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10178"; a="216116922"
X-IronPort-AV: E=Sophos;i="5.87,261,1631602800"; 
   d="scan'208";a="216116922"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2021 16:20:58 -0800
X-IronPort-AV: E=Sophos;i="5.87,261,1631602800"; 
   d="scan'208";a="607374540"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2021 16:20:58 -0800
From:   isaku.yamahata@intel.com
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com
Subject: [RFC PATCH v3 00/59] KVM: X86: TDX support
Date:   Wed, 24 Nov 2021 16:19:43 -0800
Message-Id: <cover.1637799475.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

Changes from v2:
- update based on patch review
- support TDP MMU
- drop non-essential fetures (ftrace etc.) to reduce patch size

TODO:
- integrate vm type patch
- integrate unmapping user space mapping

--- 
* What's TDX?
TDX stands for Trust Domain Extensions which isolates VMs from the
virtual-machine manager (VMM)/hypervisor and any other software on the
platform. [1] For details, the specifications, [2], [3], [4], [5], [6], [7], are
available.

* Patch organization
The patch 66 is main change.  The preceding patches(1-65) The preceding
patches(01-61) are refactoring the code and introducing additional hooks.

- 01-13: They are preparations. introduce architecture constants, code
         refactoring, export symbols for following patches.
- 14-30: start to introduce the new type of VM and allow the coexistence of
         multiple type of VM. allow/disallow KVM ioctl where
         appropriate. Especially make per-system ioctl to per-VM ioctl.
- 31-38: refactoring KVM VMX/MMU and adding new hooks for Secure EPT.
- 39-54: refactoring KVM
- 55:    main patch to add "basic" support for building/running TDX.
- 56-57: TDP MMU support
- 58:    support TDX hypercall, GetQuote and SetupEventNotifyInterrupt, that
         requires qemu help
- 59:    Documentation

* Missing features
Those major features are intentionally missing from this patch series to keep
this patch series small.  They are addressed as independent patch series.

- qemu gdb stub support
- Large page support
- guest PMU support
- and more

Changes from v1:
- rebase to v5.13
- drop load/initialization of TDX module
- catch up the update of related specifications.
- rework on C-wrapper function to invoke seamcall
- various code clean up

[1] TDX specification
   https://software.intel.com/content/www/us/en/develop/articles/intel-trust-domain-extensions.html
[2] Intel Trust Domain Extensions (Intel TDX)
   https://software.intel.com/content/dam/develop/external/us/en/documents/tdx-whitepaper-final9-17.pdf
[3] Intel CPU Architectural Extensions Specification
   https://software.intel.com/content/dam/develop/external/us/en/documents-tps/intel-tdx-cpu-architectural-specification.pdf
[4] Intel TDX Module 1.0 EAS
   https://software.intel.com/content/dam/develop/external/us/en/documents/tdx-module-1eas-v0.85.039.pdf
[5] Intel TDX Loader Interface Specification
  https://software.intel.com/content/dam/develop/external/us/en/documents-tps/intel-tdx-seamldr-interface-specification.pdf
[6] Intel TDX Guest-Hypervisor Communication Interface
   https://software.intel.com/content/dam/develop/external/us/en/documents/intel-tdx-guest-hypervisor-communication-interface.pdf
[7] Intel TDX Virtual Firmware Design Guide
   https://software.intel.com/content/dam/develop/external/us/en/documents/tdx-virtual-firmware-design-guide-rev-1.pdf
[8] intel public github
   kvm TDX branch: https://github.com/intel/tdx/tree/kvm
   TDX guest branch: https://github.com/intel/tdx/tree/guest
   qemu TDX https://github.com/intel/qemu-tdx
[9] TDVF
    https://github.com/tianocore/edk2-staging/tree/TDVF

Chao Gao (1):
  KVM: x86: Add a helper function to restore 4 host MSRs on exit to user
    space

Isaku Yamahata (9):
  x86/mktme: move out MKTME related constatnts/macro to msr-index.h
  x86/mtrr: mask out keyid bits from variable mtrr mask register
  KVM: TDX: Define TDX architectural definitions
  KVM: TDX: add a helper function for kvm to call seamcall
  KVM: TDX: Add helper functions to print TDX SEAMCALL error
  KVM: Add per-VM flag to mark read-only memory as unsupported
  KVM: x86: add per-VM flags to disable SMI/INIT/SIPI
  KVM: TDX: exit to user space on GET_QUOTE,
    SETUP_EVENT_NOTIFY_INTERRUPT
  Documentation/virtual/kvm: Add Trust Domain Extensions(TDX)

Kai Huang (3):
  KVM: x86: Add per-VM flag to disable in-kernel I/O APIC and level
    routes
  KVM: TDX: Protect private mapping related SEAMCALLs with spinlock
  KVM, x86/mmu: Support TDX private mapping for TDP MMU

Rick Edgecombe (1):
  KVM: x86: Add infrastructure for stolen GPA bits

Sean Christopherson (44):
  KVM: TDX: Add TDX "architectural" error codes
  KVM: TDX: Add C wrapper functions for TDX SEAMCALLs
  KVM: Export kvm_io_bus_read for use by TDX for PV MMIO
  KVM: Enable hardware before doing arch VM initialization
  KVM: x86: Split core of hypercall emulation to helper function
  KVM: x86: Export kvm_mmio tracepoint for use by TDX for PV MMIO
  KVM: x86/mmu: Zap only leaf SPTEs for deleted/moved memslot by default
  KVM: Add max_vcpus field in common 'struct kvm'
  KVM: x86: Add vm_type to differentiate legacy VMs from protected VMs
  KVM: x86: Introduce "protected guest" concept and block disallowed
    ioctls
  KVM: x86: Add per-VM flag to disable direct IRQ injection
  KVM: x86: Add flag to disallow #MC injection / KVM_X86_SETUP_MCE
  KVM: x86: Add flag to mark TSC as immutable (for TDX)
  KVM: Add per-VM flag to disable dirty logging of memslots for TDs
  KVM: x86: Allow host-initiated WRMSR to set X2APIC regardless of CPUID
  KVM: x86: Add kvm_x86_ops .cache_gprs() and .flush_gprs()
  KVM: x86: Add support for vCPU and device-scoped KVM_MEMORY_ENCRYPT_OP
  KVM: x86: Introduce vm_teardown() hook in kvm_arch_vm_destroy()
  KVM: x86: Add a switch_db_regs flag to handle TDX's auto-switched
    behavior
  KVM: x86: Check for pending APICv interrupt in kvm_vcpu_has_events()
  KVM: x86: Add option to force LAPIC expiration wait
  KVM: x86: Add guest_supported_xss placholder
  KVM: x86/mmu: Explicitly check for MMIO spte in fast page fault
  KVM: x86/mmu: Ignore bits 63 and 62 when checking for "present" SPTEs
  KVM: x86/mmu: Allow non-zero init value for shadow PTE
  KVM: x86/mmu: Return old SPTE from mmu_spte_clear_track_bits()
  KVM: x86/mmu: Frame in support for private/inaccessible shadow pages
  KVM: x86/mmu: Introduce kvm_mmu_map_tdp_page() for use by TDX
  KVM: x86/mmu: Allow per-VM override of the TDP max page level
  KVM: VMX: Modify NMI and INTR handlers to take intr_info as param
  KVM: VMX: Move NMI/exception handler to common helper
  KVM: VMX: Split out guts of EPT violation to common/exposed function
  KVM: VMX: Define EPT Violation architectural bits
  KVM: VMX: Define VMCS encodings for shared EPT pointer
  KVM: VMX: Add 'main.c' to wrap VMX and TDX
  KVM: VMX: Move setting of EPT MMU masks to common VT-x code
  KVM: VMX: Move register caching logic to common code
  KVM: TDX: Define TDCALL exit reason
  KVM: TDX: Stub in tdx.h with structs, accessors, and VMCS helpers
  KVM: VMX: Add macro framework to read/write VMCS for VMs and TDs
  KVM: VMX: Move AR_BYTES encoder/decoder helpers to common.h
  KVM: VMX: MOVE GDT and IDT accessors to common code
  KVM: VMX: Move .get_interrupt_shadow() implementation to common VMX
    code
  KVM: TDX: Add "basic" support for building and running Trust Domains

Xiaoyao Li (1):
  KVM: X86: Introduce initial_tsc_khz in struct kvm_arch

 Documentation/virt/kvm/api.rst        |    9 +-
 Documentation/virt/kvm/intel-tdx.rst  |  359 ++++
 arch/arm64/include/asm/kvm_host.h     |    3 -
 arch/arm64/kvm/arm.c                  |    7 +-
 arch/arm64/kvm/vgic/vgic-init.c       |    6 +-
 arch/x86/events/intel/ds.c            |    1 +
 arch/x86/include/asm/kvm-x86-ops.h    |   11 +
 arch/x86/include/asm/kvm_host.h       |   63 +-
 arch/x86/include/asm/msr-index.h      |   16 +
 arch/x86/include/asm/vmx.h            |    6 +
 arch/x86/include/uapi/asm/kvm.h       |   60 +
 arch/x86/include/uapi/asm/vmx.h       |    7 +-
 arch/x86/kernel/cpu/intel.c           |   14 -
 arch/x86/kernel/cpu/mtrr/mtrr.c       |    9 +
 arch/x86/kvm/Makefile                 |    6 +-
 arch/x86/kvm/ioapic.c                 |    4 +
 arch/x86/kvm/irq_comm.c               |   13 +-
 arch/x86/kvm/lapic.c                  |    7 +-
 arch/x86/kvm/lapic.h                  |    2 +-
 arch/x86/kvm/mmu.h                    |   29 +-
 arch/x86/kvm/mmu/mmu.c                |  667 ++++++-
 arch/x86/kvm/mmu/mmu_internal.h       |   12 +
 arch/x86/kvm/mmu/paging_tmpl.h        |   32 +-
 arch/x86/kvm/mmu/spte.c               |   15 +-
 arch/x86/kvm/mmu/spte.h               |   51 +-
 arch/x86/kvm/mmu/tdp_iter.h           |    2 +-
 arch/x86/kvm/mmu/tdp_mmu.c            |  544 +++++-
 arch/x86/kvm/mmu/tdp_mmu.h            |   15 +-
 arch/x86/kvm/svm/svm.c                |   13 +-
 arch/x86/kvm/vmx/common.h             |  178 ++
 arch/x86/kvm/vmx/main.c               | 1152 ++++++++++++
 arch/x86/kvm/vmx/posted_intr.c        |    6 +
 arch/x86/kvm/vmx/seamcall.h           |  116 ++
 arch/x86/kvm/vmx/tdx.c                | 2437 +++++++++++++++++++++++++
 arch/x86/kvm/vmx/tdx.h                |  290 +++
 arch/x86/kvm/vmx/tdx_arch.h           |  239 +++
 arch/x86/kvm/vmx/tdx_errno.h          |  111 ++
 arch/x86/kvm/vmx/tdx_error.c          |   53 +
 arch/x86/kvm/vmx/tdx_ops.h            |  224 +++
 arch/x86/kvm/vmx/tdx_stubs.c          |   50 +
 arch/x86/kvm/vmx/vmenter.S            |  146 ++
 arch/x86/kvm/vmx/vmx.c                |  689 ++-----
 arch/x86/kvm/vmx/x86_ops.h            |  203 ++
 arch/x86/kvm/x86.c                    |  276 ++-
 include/linux/kvm_host.h              |    5 +
 include/uapi/linux/kvm.h              |   59 +
 tools/arch/x86/include/uapi/asm/kvm.h |   55 +
 tools/include/uapi/linux/kvm.h        |    2 +
 virt/kvm/kvm_main.c                   |   34 +-
 49 files changed, 7469 insertions(+), 839 deletions(-)
 create mode 100644 Documentation/virt/kvm/intel-tdx.rst
 create mode 100644 arch/x86/kvm/vmx/common.h
 create mode 100644 arch/x86/kvm/vmx/main.c
 create mode 100644 arch/x86/kvm/vmx/seamcall.h
 create mode 100644 arch/x86/kvm/vmx/tdx.c
 create mode 100644 arch/x86/kvm/vmx/tdx.h
 create mode 100644 arch/x86/kvm/vmx/tdx_arch.h
 create mode 100644 arch/x86/kvm/vmx/tdx_errno.h
 create mode 100644 arch/x86/kvm/vmx/tdx_error.c
 create mode 100644 arch/x86/kvm/vmx/tdx_ops.h
 create mode 100644 arch/x86/kvm/vmx/tdx_stubs.c
 create mode 100644 arch/x86/kvm/vmx/x86_ops.h

-- 
2.25.1

