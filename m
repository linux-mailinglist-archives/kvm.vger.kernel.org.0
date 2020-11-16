Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1D862B4FDE
	for <lists+kvm@lfdr.de>; Mon, 16 Nov 2020 19:35:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732510AbgKPS1y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Nov 2020 13:27:54 -0500
Received: from mga06.intel.com ([134.134.136.31]:20621 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731805AbgKPS1x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Nov 2020 13:27:53 -0500
IronPort-SDR: QGSRKg69Dw2Jo99HBCvwKnkDx4zM/Fvu7Yj/nFKJmistVAcjdqNpV2sWNMQgiXmWgEqpvnOhl2
 5wUJ6PCZPA3A==
X-IronPort-AV: E=McAfee;i="6000,8403,9807"; a="232409988"
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="232409988"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 10:27:52 -0800
IronPort-SDR: wAOEqpP8Eq0Nw8gPyBrYrJgv8XAhxL1db3YYwAvgTvp0Nyma+xuhgHhczhs1GlrjD9xPH1uiLZ
 beojlMYybeTQ==
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="400527722"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 10:27:51 -0800
From:   isaku.yamahata@intel.com
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com
Subject: [RFC PATCH 00/67] KVM: X86: TDX support
Date:   Mon, 16 Nov 2020 10:25:45 -0800
Message-Id: <cover.1605232743.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

* What's TDX?
TDX stands for Trust Domain Extensions which isolates VMs from
the virtual-machine manager (VMM)/hypervisor and any other software on
the platform. [1]
For details, the specifications, [2], [3], [4], [5], [6], [7], are
available.


* The goal of this RFC patch
The purpose of this post is to get feedback early on high level design
issue of KVM enhancement for TDX. The detailed coding (variable naming
etc) is not cared of. This patch series is incomplete (not working).
Although multiple software components, not only KVM but also QEMU,
guest Linux and virtual bios, need to be updated, this includes only
KVM VMM part. For those who are curious to changes to other
component, there are public repositories at github. [8], [9]


* Terminology
Here are short explanations of key concepts.
For detailed explanation or other terminologies, please refer to the
specifications. [2], [3], [4], [5], [6], [7].
- Trusted Domain(TD)
  Hardware-isolated virtual machines managed by TDX-module.
- Secure-Arbitration Mode(SEAM)
  A new mode of the CPU. It consists of SEAM Root and SEAM Non-Root
  which corresponds to VMX Root and VMX Non-Root.
- TDX-module
  TDX-module runs in SEAM Root that manages TD guest state.
  It provides ABI for VMM to manages TDs. It's expensive operation.
- SEAM loader(SEAMLDR)
  Authenticated Code Module(ACM) to load the TDX-module.
- Secure EPT (S-EPT)
  An extended Page table that is encrypted.
  Shared bit(bit 51 or 47) in GPA selects shared vs private.
  0: private to TD, 1: shared with host VMM.


* Major touch/discussion points
The followings are the major touch points where feedback is wanted.

** the file location of the boot code
BSP launches SEAM Loader on BSP to load TDX module. TDX module is on
all CPUs. The directory, arch/x86/kvm/boot/seam, is chosen to locate
the related files in near directory. When maintenance/enhancement in
future, it will be easy to identify that they're related to be synced
with.

- arch/x86/kvm/boot/seam: the current choice
  Pros:
  - The directory clearly indicates that the code is related to only
    KVM.
  - Keep files near to the related code (KVM TDX code).
  Cons:
  - It doesn't follow the existing convention.

Alternative:
The alternative is to follow the existing convention.
- arch/x86/kernel/cpu/
  Pros:
  - It follows the existing convention.
  Cons:
  - It's unclear that it's related to only KVM TDX.

- drivers/firmware/
  As TDX module can be considered a firmware, yet other choice is
  Pros:
  - It follows the existing convention. it clarifies that TDX module
    is a firmware.
  Cons:
  - It's hard to understand the firmware is only for KVM TDX.
  - The files are far from the related code(KVM TDX).

** Coexistence of normal(VMX) VM and TD VM
It's required to allow both legacy(normal VMX) VMs and new TD VMs to
coexist. Otherwise the benefits of VM flexibility would be eliminated.
The main issue for it is that the logic of kvm_x86_ops callbacks for
TDX is different from VMX. On the other hand, the variable,
kvm_x86_ops, is global single variable. Not per-VM, not per-vcpu.

Several points to be considered.
  . No or minimal overhead when TDX is disabled(CONFIG_KVM_INTEL_TDX=n).
  . Avoid overhead of indirect call via function pointers.
  . Contain the changes under arch/x86/kvm/vmx directory and share logic
    with VMX for maintenance.
    Even though the ways to operation on VM (VMX instruction vs TDX
    SEAM call) is different, the basic idea remains same. So, many
    logic can be shared.
  . Future maintenance
    The huge change of kvm_x86_ops in (near) future isn't expected.
    a centralized file is acceptable.

- Wrapping kvm x86_ops: The current choice
  Introduce dedicated file for arch/x86/kvm/vmx/main.c (the name,
  main.c, is just chosen to show main entry points for callbacks.) and
  wrapper functions around all the callbacks with
  "if (is-tdx) tdx-callback() else vmx-callback()".

  Pros:
  - No major change in common x86 KVM code. The change is (mostly)
    contained under arch/x86/kvm/vmx/.
  - When TDX is disabled(CONFIG_KVM_INTEL_TDX=n), the overhead is
    optimized out.
  - Micro optimization by avoiding function pointer.
  Cons:
  - Many boiler plates in arch/x86/kvm/vmx/main.c.

Alternative:
- Introduce another callback layer under arch/x86/kvm/vmx.
  Pros:
  - No major change in common x86 KVM code. The change is (mostly)
    contained under arch/x86/kvm/vmx/.
  - clear separation on callbacks.
  Cons:
  - overhead in VMX even when TDX is disabled(CONFIG_KVM_INTEL_TDX=n).

- Allow per-VM kvm_x86_ops callbacks instead of global kvm_x86_ops
  Pros:
  - clear separation on callbacks.
  Cons:
  - Big change in common x86 code.
  - overhead in common code even when TDX is
    disabled(CONFIG_KVM_INTEL_TDX=n).

- Introduce new directory arch/x86/kvm/tdx
  Pros:
  - It clarifies that TDX is different from VMX.
  Cons:
  - Given the level of code sharing, it complicates code sharing.

** KVM MMU Changes
KVM MMU needs to be enhanced to handle Secure/Shared-EPT. The
high-level execution flow is mostly same to normal EPT case.
EPT violation/misconfiguration -> invoke TDP fault handler ->
resolve TDP fault -> resume execution. (or emulate MMIO)
The difference is, that S-EPT is operated(read/write) via TDX SEAM
call which is expensive instead of direct read/write EPT entry.
One bit of GPA (51 or 47 bit) is repurposed so that it means shared
with host(if set to 1) or private to TD(if cleared to 0).

- The current implementation
  . Reuse the existing MMU code with minimal update.  Because the
    execution flow is mostly same. But additional operation, TDX call
    for S-EPT, is needed. So add hooks for it to kvm_x86_ops.
  . For performance, minimize TDX SEAM call to operate on S-EPT. When
    getting corresponding S-EPT pages/entry from faulting GPA, don't
    use TDX SEAM call to read S-EPT entry. Instead create shadow copy
    in host memory.
    Repurpose the existing kvm_mmu_page as shadow copy of S-EPT and
    associate S-EPT to it.
  . Treats share bit as attributes. mask/unmask the bit where
    necessary to keep the existing traversing code works.
    Introduce kvm.arch.gfn_shared_mask and use "if (gfn_share_mask)"
    for special case.
    = 0 : for non-TDX case
    = 51 or 47 bit set for TDX case.

  Pros:
  - Large code reuse with minimal new hooks.
  - Execution path is same.
  Cons:
  - Complicates the existing code.
  - Repurpose kvm_mmu_page as shadow of Secure-EPT can be confusing.

Alternative:
- Replace direct read/write on EPT entry with TDX-SEAM call by
  introducing callbacks on EPT entry.
  Pros:
  - Straightforward.
  Cons:
  - Too many touching point.
  - Too slow due to TDX-SEAM call.
  - Overhead even when TDX is disabled(CONFIG_KVM_INTEL_TDX=n).

- Sprinkle "if (is-tdx)" for TDX special case
  Pros:
  - Straightforward.
  Cons:
  - The result is non-generic and ugly.
  - Put TDX specific logic into common KVM MMU code.

** New KVM API, ioctl (sub)command, to manage TD VMs
Additional KVM API are needed to control TD VMs. The operations on TD
VMs are specific to TDX.

- Piggyback and repurpose KVM_MEMORY_ENCRYPT_OP
  Although not all operation isn't memory encryption, repupose to get
  TDX specific ioctls.
  Pros:
  - No major change in common x86 KVM code.
  Cons:
  - The operations aren't actually memory encryption, but operations
    on TD VMs.

Alternative:
- Introduce new ioctl for guest protection like
  KVM_GUEST_PROTECTION_OP and introduce subcommand for TDX.
  Pros:
  - Clean name.
  Cons:
  - One more new ioctl for guest protection.
  - Confusion with KVM_MEMORY_ENCRYPT_OP with KVM_GUEST_PROTECTION_OP.

- Rename KVM_MEMORY_ENCRYPT_OP to KVM_GUEST_PROTECTION_OP and keep
  KVM_MEMORY_ENCRYPT_OP as same value for user API for compatibility.
  "#define KVM_MEMORY_ENCRYPT_OP KVM_GUEST_PROTECTION_OP" for uapi
  compatibility.
  Pros:
  - No new ioctl with more suitable name.
  Cons:
  - May cause confusion to the existing user program.


* Items unsupported/out of the scope
Those items are unsupported at the moment or out of the scope.
- Large page(2MB, 1GB) support
- Page migration
- Debugger support(qemu gdb stub)
- Removing user space(qemu) mapping of guest private memory
  Because this topic itself is big and will take time, the effort is
  taking place independently. [12]
- Attestation
  The end-to-end integration is required.
- Live migration
  TDX 1.0 doesn't support this.
- Nested virtualization
  TDX 1.0 doesn't support this.


* Related repositories
TDX enabling software are composed of several components. Not only
KVM/x86 enablement, but also other components. There are several
publicly available repositories in github. Those are not complete, not
working, but only for reference for those who are curious.
- TDX host/guest [8]
- TDX Virtual Firmware [9]
- qemu change isn't published (yet).


* Related presentations
At KVM forum 2020, several presentation related to TDX were given. [10] [11]
They are helpful to understand TDX and KVM/qemu related changes.


* Patch organization
The main changes are only 2 patches(62 and 64).
The preceding patches(01-61) are refactoring the code and introducing
additional hooks. The patch 64 plugs hooks into TDX implementation.

- patch 01-16: They are preparations. introduce architecture
               constants, code refactoring, export symbols for
               following patches.
- patch 17-33: start to introduce the new type of VM and allow the
               coexistence of multiple type of VM. allow/disallow KVM
               ioctl where appropriate. Especially make per-system
               ioctl to per-VM ioctl.
- patch 34-43: refactoring KVM MMU and adding new hooks for Secure
               EPT.
- patch 44-48: refactoring KVM/VMX code + wrapper for kvm_x86_ops for
               VMX and TDX.
- patch 52-61: introducing TDX architectural constants/structures and
               helper functions.
- patch 62-63: load/init TDX module during boot.
- patch 64-65: main patch to add "basic" support for building/running
               TDX.
- patch 66   : This patch is not for review, but to make build success.


[1] TDX specification
   https://software.intel.com/content/www/us/en/develop/articles/intel-trust-domain-extensions.html
[2] Intel Trust Domain Extensions (Intel TDX)
   https://software.intel.com/content/dam/develop/external/us/en/documents/tdx-whitepaper-final9-17.pdf
[3] Intel CPU Architectural Extensions Specification
   https://software.intel.com/content/dam/develop/external/us/en/documents/intel-tdx-cpu-architectural-specification.pdf
[4] Intel TDX Module 1.0 EAS
   https://software.intel.com/content/dam/develop/external/us/en/documents/intel-tdx-module-1eas.pdf
[5] Intel TDX Loader Interface Specification
   https://software.intel.com/content/dam/develop/external/us/en/documents/intel-tdx-seamldr-interface-specification.pdf
[6] Intel TDX Guest-Hypervisor Communication Interface
   https://software.intel.com/content/dam/develop/external/us/en/documents/intel-tdx-guest-hypervisor-communication-interface.pdf
[7] Intel TDX Virtual Firmware Design Guide
   https://software.intel.com/content/dam/develop/external/us/en/documents/tdx-virtual-firmware-design-guide-rev-1.
[8] intel public github
   kvm TDX branch: https://github.com/intel/tdx/tree/kvm
   TDX guest branch: https://github.com/intel/tdx/tree/guest
[9] tdvf
    https://github.com/tianocore/edk2-staging/tree/TDVF
[10] KVM forum 2020: Intel Virtualization Technology Extensions to
     Enable Hardware Isolated VMs
     https://osseu2020.sched.com/event/eDzm/intel-virtualization-technology-extensions-to-enable-hardware-isolated-vms-sean-christopherson-intel
[11] Linux Security Summit EU 2020:
     Architectural Extensions for Hardware Virtual Machine Isolation
     to Advance Confidential Computing in Public Clouds - Ravi Sahita
     & Jun Nakajima, Intel Corporation
     https://osseu2020.sched.com/event/eDOx/architectural-extensions-for-hardware-virtual-machine-isolation-to-advance-confidential-computing-in-public-clouds-ravi-sahita-jun-nakajima-intel-corporation
[12] [RFCv2,00/16] KVM protected memory extension
     https://lkml.org/lkml/2020/10/20/66


Isaku Yamahata (4):
  KVM: x86: Make KVM_CAP_X86_SMM a per-VM capability
  KVM: Add per-VM flag to mark read-only memory as unsupported
  fixup! KVM: TDX: Add "basic" support for building and running Trust
    Domains
  KVM: X86: not for review: add dummy file for TDX-SEAM module

Kai Huang (3):
  KVM: x86: Add per-VM flag to disable in-kernel I/O APIC and level
    routes
  KVM: TDX: Add SEAMRR related MSRs macro definition
  cpu/hotplug: Document that TDX also depends on booting CPUs once

Rick Edgecombe (1):
  KVM: x86: Add infrastructure for stolen GPA bits

Sean Christopherson (58):
  x86/cpufeatures: Add synthetic feature flag for TDX (in host)
  x86/msr-index: Define MSR_IA32_MKTME_KEYID_PART used by TDX
  KVM: Export kvm_io_bus_read for use by TDX for PV MMIO
  KVM: Enable hardware before doing arch VM initialization
  KVM: x86: Split core of hypercall emulation to helper function
  KVM: x86: Export kvm_mmio tracepoint for use by TDX for PV MMIO
  KVM: x86/mmu: Zap only leaf SPTEs for deleted/moved memslot by default
  KVM: Add infrastructure and macro to mark VM as bugged
  KVM: Export kvm_make_all_cpus_request() for use in marking VMs as
    bugged
  KVM: x86: Use KVM_BUG/KVM_BUG_ON to handle bugs that are fatal to the
    VM
  KVM: x86/mmu: Mark VM as bugged if page fault returns RET_PF_INVALID
  KVM: VMX: Explicitly check for hv_remote_flush_tlb when loading pgd()
  KVM: Add max_vcpus field in common 'struct kvm'
  KVM: x86: Add vm_type to differentiate legacy VMs from protected VMs
  KVM: x86: Hoist kvm_dirty_regs check out of sync_regs()
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
  KVM: Export kvm_is_reserved_pfn() for use by TDX
  KVM: x86/mmu: Explicitly check for MMIO spte in fast page fault
  KVM: x86/mmu: Track shadow MMIO value on a per-VM basis
  KVM: x86/mmu: Ignore bits 63 and 62 when checking for "present" SPTEs
  KVM: x86/mmu: Allow non-zero init value for shadow PTE
  KVM: x86/mmu: Refactor shadow walk in __direct_map() to reduce
    indentation
  KVM: x86/mmu: Return old SPTE from mmu_spte_clear_track_bits()
  KVM: x86/mmu: Frame in support for private/inaccessible shadow pages
  KVM: x86/mmu: Move 'pfn' variable to caller of direct_page_fault()
  KVM: x86/mmu: Introduce kvm_mmu_map_tdp_page() for use by TDX
  KVM: VMX: Modify NMI and INTR handlers to take intr_info as param
  KVM: VMX: Move NMI/exception handler to common helper
  KVM: VMX: Split out guts of EPT violation to common/exposed function
  KVM: VMX: Define EPT Violation architectural bits
  KVM: VMX: Define VMCS encodings for shared EPT pointer
  KVM: VMX: Add 'main.c' to wrap VMX and TDX
  KVM: VMX: Move setting of EPT MMU masks to common VT-x code
  KVM: VMX: Move register caching logic to common code
  KVM: TDX: Add TDX "architectural" error codes
  KVM: TDX: Add architectural definitions for structures and values
  KVM: TDX: Define TDCALL exit reason
  KVM: TDX: Add macro framework to wrap TDX SEAMCALLs
  KVM: TDX: Stub in tdx.h with structs, accessors, and VMCS helpers
  KVM: VMX: Add macro framework to read/write VMCS for VMs and TDs
  KVM: VMX: Move AR_BYTES encoder/decoder helpers to common.h
  KVM: VMX: MOVE GDT and IDT accessors to common code
  KVM: VMX: Move .get_interrupt_shadow() implementation to common VMX
    code
  KVM: TDX: Load and init TDX-SEAM module during boot
  KVM: TDX: Add "basic" support for building and running Trust Domains
  KVM: x86: Mark the VM (TD) as bugged if non-coherent DMA is detected

Zhang Chen (1):
  x86/cpu: Move get_builtin_firmware() common code (from microcode only)

 arch/arm64/include/asm/kvm_host.h     |    3 -
 arch/arm64/kvm/arm.c                  |    7 +-
 arch/arm64/kvm/vgic/vgic-init.c       |    6 +-
 arch/x86/Kbuild                       |    1 +
 arch/x86/include/asm/cpu.h            |    5 +
 arch/x86/include/asm/cpufeatures.h    |    1 +
 arch/x86/include/asm/kvm_boot.h       |   43 +
 arch/x86/include/asm/kvm_host.h       |   52 +-
 arch/x86/include/asm/microcode.h      |    3 -
 arch/x86/include/asm/msr-index.h      |   10 +
 arch/x86/include/asm/vmx.h            |    6 +
 arch/x86/include/asm/vmxfeatures.h    |    2 +-
 arch/x86/include/uapi/asm/kvm.h       |   55 +
 arch/x86/include/uapi/asm/vmx.h       |    4 +-
 arch/x86/kernel/cpu/common.c          |   20 +
 arch/x86/kernel/cpu/intel.c           |    4 +
 arch/x86/kernel/cpu/microcode/core.c  |   18 -
 arch/x86/kernel/cpu/microcode/intel.c |    1 +
 arch/x86/kernel/setup.c               |    3 +
 arch/x86/kvm/Kconfig                  |    8 +
 arch/x86/kvm/Makefile                 |    2 +-
 arch/x86/kvm/boot/Makefile            |    5 +
 arch/x86/kvm/boot/seam/seamldr.S      |  188 +++
 arch/x86/kvm/boot/seam/seamloader.c   |  162 +++
 arch/x86/kvm/boot/seam/tdx.c          | 1131 +++++++++++++++
 arch/x86/kvm/ioapic.c                 |    4 +
 arch/x86/kvm/irq_comm.c               |    6 +-
 arch/x86/kvm/lapic.c                  |    9 +-
 arch/x86/kvm/lapic.h                  |    2 +-
 arch/x86/kvm/mmu.h                    |   33 +-
 arch/x86/kvm/mmu/mmu.c                |  519 +++++--
 arch/x86/kvm/mmu/mmu_internal.h       |    5 +
 arch/x86/kvm/mmu/paging_tmpl.h        |   27 +-
 arch/x86/kvm/mmu/spte.c               |   36 +-
 arch/x86/kvm/mmu/spte.h               |   30 +-
 arch/x86/kvm/svm/svm.c                |   22 +-
 arch/x86/kvm/trace.h                  |   57 +
 arch/x86/kvm/vmx/common.h             |  180 +++
 arch/x86/kvm/vmx/main.c               | 1130 +++++++++++++++
 arch/x86/kvm/vmx/posted_intr.c        |    6 +
 arch/x86/kvm/vmx/tdx.c                | 1847 +++++++++++++++++++++++++
 arch/x86/kvm/vmx/tdx.h                |  245 ++++
 arch/x86/kvm/vmx/tdx_arch.h           |  230 +++
 arch/x86/kvm/vmx/tdx_errno.h          |   91 ++
 arch/x86/kvm/vmx/tdx_ops.h            |  544 ++++++++
 arch/x86/kvm/vmx/tdx_stubs.c          |   45 +
 arch/x86/kvm/vmx/vmenter.S            |  140 ++
 arch/x86/kvm/vmx/vmx.c                |  537 ++-----
 arch/x86/kvm/vmx/vmx.h                |    2 +
 arch/x86/kvm/x86.c                    |  296 +++-
 include/linux/kvm_host.h              |   51 +-
 include/uapi/linux/kvm.h              |    2 +
 kernel/cpu.c                          |    4 +
 lib/firmware/intel-seam/libtdx.so     |    0
 tools/arch/x86/include/uapi/asm/kvm.h |   55 +
 tools/include/uapi/linux/kvm.h        |    2 +
 virt/kvm/kvm_main.c                   |   45 +-
 57 files changed, 7230 insertions(+), 712 deletions(-)
 create mode 100644 arch/x86/include/asm/kvm_boot.h
 create mode 100644 arch/x86/kvm/boot/Makefile
 create mode 100644 arch/x86/kvm/boot/seam/seamldr.S
 create mode 100644 arch/x86/kvm/boot/seam/seamloader.c
 create mode 100644 arch/x86/kvm/boot/seam/tdx.c
 create mode 100644 arch/x86/kvm/vmx/common.h
 create mode 100644 arch/x86/kvm/vmx/main.c
 create mode 100644 arch/x86/kvm/vmx/tdx.c
 create mode 100644 arch/x86/kvm/vmx/tdx.h
 create mode 100644 arch/x86/kvm/vmx/tdx_arch.h
 create mode 100644 arch/x86/kvm/vmx/tdx_errno.h
 create mode 100644 arch/x86/kvm/vmx/tdx_ops.h
 create mode 100644 arch/x86/kvm/vmx/tdx_stubs.c
 create mode 100644 lib/firmware/intel-seam/libtdx.so

-- 
2.17.1

