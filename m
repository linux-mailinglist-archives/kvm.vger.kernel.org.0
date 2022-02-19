Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7C5C4BCA3B
	for <lists+kvm@lfdr.de>; Sat, 19 Feb 2022 19:50:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242971AbiBSSuQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 19 Feb 2022 13:50:16 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231241AbiBSSuO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 19 Feb 2022 13:50:14 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6AFE6C1DF;
        Sat, 19 Feb 2022 10:49:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645296594; x=1676832594;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=i38csMGf6rPxmgGx7uKGGYCLPzw5wZskOg57U2L3kqU=;
  b=LCy/y5tFYJ/ynjdup/sBwWEmuG7jLpV5iacYe2JmokVDHlkE8xrHYalH
   uea1/DiZxYPyN0bFUeaVkQd779ecoxVurkxK1dueqGDSGn+ktuSYT5j5O
   TU5+TaWcwU6JSygJmjtgKVrRjMbhQL36sNAohLAo4iEaA1+OcQ5u1j4Nx
   siUpN4HmNdGbfC0NELgf3BeCd5BFjAj9wMNY1VmHhDqJsd+LZ5H3su4sA
   GrrOymeTtb2I176Xs/tafwHhKjrncgI7YLn2fLjbN6swn3sTBpcCeKrvB
   Q4wZGYhPbpIhEXGlWOFhRSDy9oCj7S8+LAOpPsykm9NcQL2Rb2YCU+Xh8
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10263"; a="251500890"
X-IronPort-AV: E=Sophos;i="5.88,381,1635231600"; 
   d="scan'208";a="251500890"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2022 10:49:54 -0800
X-IronPort-AV: E=Sophos;i="5.88,381,1635231600"; 
   d="scan'208";a="705753624"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2022 10:49:53 -0800
From:   isaku.yamahata@intel.com
To:     Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com
Subject: [PATCH v4 0/8] KVM TDX: preparation for coexistence of VMX and TDX
Date:   Sat, 19 Feb 2022 10:49:45 -0800
Message-Id: <cover.1645266955.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

* What's TDX?
TDX stands for Trust Domain Extensions, which extends Intel Virtual Machines
Extensions (VMX) to introduce a kind of virtual machine guest called a Trust
Domain (TD) for confidential computing.

A TD runs in a CPU mode that is designed to protect the confidentiality of its
memory contents and its CPU state from any other software, including the hosting
Virtual Machine Monitor (VMM), unless explicitly shared by the TD itself.

We have more detailed explanations below (***).
We have the high-level design of TDX KVM below (****).

In this patch series, we use "TD" or "guest TD" to differentiate it from the
current "VM" (Virtual Machine), which is supported by KVM today.


* This patch series and whole patches
Because it needs more than 90 patches for KVM to run guest TDs, the patches are
split into layers of patch series so that we can build the TDX code structure in
KVM step by step.  We believe that this should make the review process efficient
and effective.

All of the patches (not just this patch series) are available at
https://github.com/intel/tdx/releases/tag/kvm-upstream-2022.02.18-v5.17-rc4.
The corresponding patches to qemu are available at
https://github.com/intel/qemu-tdx/commits/tdx-upstream.

The relations of the layers are depicted as follows.
The arrows below show the order of patch reviews we would like to have.

  TDX vcpu
  interrupt/exits/hypercall<------------\
        ^                               |
        |                               |
  TDX EPT violation<------------\       |
        ^                       |       |
        |                       |       |
  TD vcpu enter/exit            |       |
        ^                       |       |
        |                       |       |
  TD vcpu creation/destruction  |       \-------KVM TDP MMU MapGPA
        ^                       |                       ^
        |                       |                       |
  TD VM creation/destruction    \---------------KVM TDP MMU hooks
        ^                                               ^
        |                                               |
  TDX architectural definitions                 KVM TDP refactoring for TDX
        ^                                               ^
        |                                               |
  +-----------+                                         |
  |TDX, VMX   |<--------TDX module              KVM MMU GPA stolen bits
  |coexistence|         initialization
  +-----------+
  focus of this
  patch series

The above layers are chosen so that the device model, for example, qemu can
exercise each layering step by step.  Check if TDX is supported, create TD VM,
create TD vcpu, allow vcpu running, populate TD guest private memory, and handle
vcpu exits/hypercalls/interrupts to run TD fully.

The followings are explanations of each layer.

TDX module initialization:
        The guts of system-wide initialization of TDX module.  There is an
        independent patch series for host x86.  TDX KVM patches call functions
        this patch series provides to initialize the TDX module.
        This patch series starts with "[MARKER] The start of TDX host patch
        series".

TDX, VMX coexistence:
        Infrastructure to allow TDX to coexist with VMX and trigger the
        initialization of the TDX module.
        This patch series starts with "[MARKER] The start of TDX KVM patch
        series: TDX, VMX coexistence".
TDX architectural definitions:
        Add TDX architectural definitions and helper functions
        This patch series starts with "[MARKER] The start of TDX KVM patch
        series: TDX architectural definitions".
TD VM creation/destruction:
        Guest TD creation/destroy allocation and releasing of TDX specific vm
        and vcpu structure.  Create an initial guest memory image with TDX
        measurement.
        This patch series starts with "[MARKER] The start of TDX KVM patch
        series: TD VM creation/destruction" and "[MARKER] The start of TDX KVM
        patch series: TD finalization".
TD vcpu creation/destruction:
        guest TD creation/destroy Allocation and releasing of TDX specific vm
        and vcpu structure.  Create an initial guest memory image with TDX
        measurement.
        This patch series starts with "[MARKER] The start of TDX KVM patch
        series: TD vcpu creation/destruction".
TDX EPT violation:
        Create an initial guest memory image with TDX measurement.  Handle
        secure EPT violations to populate guest pages with TDX SEAMCALLs.
        This patch series starts with "[MARKER] The start of TDX KVM patch
        series: TDX EPT violation".
TD vcpu enter/exit:
        Allow TDX vcpu to enter into TD and exit from TD.  Save CPU state before
        entering into TD.  Restore CPU state after exiting from TD.
        This patch series starts with "[MARKER] The start of TDX KVM patch
        series: TD vcpu enter/exit".
TD vcpu interrupts/exit/hypercall:
        Handle various exits/hypercalls and allow interrupts to be injected so
        that TD vcpu can continue running.
        This patch series starts with "[MARKER] The start of TDX KVM patch
        series: TD vcpu exits/interrupts/hypercalls".

KVM MMU GPA stolen bits:
        Introduce framework to handle stolen repurposed bit of GPA TDX
        repurposed a bit of GPA to indicate shared or private. If it's shared,
        it's the same as the conventional VMX EPT case.  VMM can access shared
        guest pages.  If it's private, it's handled by Secure-EPT and the guest
        page is encrypted.
        This patch series starts with "[MARKER] The start of TDX KVM patch
        series: KVM MMU GPA stolen bits".
KVM TDP refactoring for TDX:
        TDX Secure EPT requires different constants. e.g. initial value EPT
        entry value etc. Various refactoring for those differences.
        This patch series starts with "[MARKER] The start of TDX KVM patch
        series: KVM TDP refactoring for TDX".
KVM TDP MMU hooks:
        Introduce framework to TDP MMU to add hooks in addition to direct EPT
        access TDX added Secure EPT which is an enhancement to VMX EPT.  Unlike
        conventional VMX EPT, CPU can't directly read/write Secure EPT. Instead,
        use TDX SEAMCALLs to operate on Secure EPT.
        This patch series starts with "[MARKER] The start of TDX KVM patch
        series: KVM TDP MMU hooks".
KVM TDP MMU MapGPA:
        Introduce framework to handle switching guest pages from private/shared
        to shared/private.  For a given GPA, a guest page can be assigned to a
        private GPA or a shared GPA exclusively.  With TDX MapGPA hypercall,
        guest TD converts GPA assignments from private (or shared) to shared (or
        private).
        This patch series starts with "[MARKER] The start of TDX KVM patch
        series: KVM TDP MMU MapGPA".

KVM guest private memory: (not shown in the above diagram)
[PATCH v4 00/12] KVM: mm: fd-based approach for supporting KVM guest private
memory: https://lkml.org/lkml/2022/1/18/395
        Guest private memory requires different memory management in KVM.  The
        patch proposes a way for it.  Integration with TDX KVM.


* The focus of this patch series
This patch series implements the infrastructure for KVM to 1) allow the
coexistence of VMX and TDX, and 2) start the initialization of the TDX module
for KVM to use the TDX module API.

1) Existing VMs (VMX VMs) and TDs can run on the same physical machine
simultaneously.  Today, we need two kernel modules for VMX: the common x86 KVM
module (kvm.ko) and the VMX-specific module (kvm_intel.ko) that implements the
VMX-specific operations as "callbacks".  We need different operations for TDs
and part of them can be shared, depending on the operation.  Because the x86 KVM
operations are global, i.e. not per-VM in KVM, we think that the most reasonable
way for adding TDX support would be to have the common entry points for the
callbacks like:
  "if (is_td_vcpu(vcpu)) tdx_callback() else vmx_callback();"
to allow VMX and TDX to coexist, handled in the same VMX/TDX-specific module
(kvm_intel.ko).  It builds a foundation so that the rest of the TDX patches can
add TDX specific code without affecting the existing VMX code.

2) For initialization (and de-initialization), we refactor the VMX
initialization flow and put TDX initialization hooks.  As the TDX technology is
built on top of VMX, the system-wide initialization of the TDX Module (below) is
required to run guest TDs in addition to conventional VMX initialization.

With this patch series applied, we can confirm that
a) we can create/run/destroy the existing VMs (VMX VM) normally.  The existing
   VMX code is intact.
b) we can enable TDX module initialization by integrating with the TDX host
   patch series.  The device model, for example, qemu can initiate the creation
   of a guest TD. If the TDX module is not available, it will fail.  If the TDX
   module is available, initialize the TDX module and then fail.


(***)
* TDX module
A CPU-attested software module called the "TDX module" is designed to implement
the TDX architecture, and it is loaded by the UEFI firmware today. It can be
loaded by the kernel or driver at runtime, but in this patch series we assume
that the TDX module is already loaded and initialized.

The TDX module provides two main new logical modes of operation built upon the
new SEAM (Secure Arbitration Mode) root and non-root CPU modes added to the VMX
architecture. TDX root mode is mostly identical to the VMX root operation mode,
and the TDX functions (described later) are triggered by the new SEAMCALL
instruction with the desired interface function selected by an input operand
(leaf number, in RAX). TDX non-root mode is used for TD guest operation.  TDX
non-root operation (i.e. "guest TD" mode) is similar to the VMX non-root
operation (i.e. guest VM), with changes and restrictions to better assure that
no other software or hardware has direct visibility of the TD memory and state.

TDX transitions between TDX root operation and TDX non-root operation include TD
Entries, from TDX root to TDX non-root mode, and TD Exits from TDX non-root to
TDX root mode.  A TD Exit might be asynchronous, triggered by some external
event (e.g., external interrupt or SMI) or an exception, or it might be
synchronous, triggered by a TDCALL (TDG.VP.VMCALL) function.

TD VCPUs can be entered using SEAMCALL(TDH.VP.ENTER) by KVM. TDH.VP.ENTER is one
of the TDX interface functions as mentioned above, and "TDH" stands for Trust
Domain Host. Those host-side TDX interface functions are categorized into
various areas just for better organization, such as SYS (TDX module management),
MNG (TD management), VP (VCPU), PHYSMEM (physical memory), MEM (private memory),
etc. For example, SEAMCALL(TDH.SYS.INFO) returns the TDX module information.

TDCS (Trust Domain Control Structure) is the main control structure of a guest
TD, and encrypted (using the guest TD's ephemeral private key).  At a high
level, TDCS holds information for controlling TD operation as a whole,
execution, EPTP, MSR bitmaps, etc that KVM needs to set it up.  Note that MSR
bitmaps are held as part of TDCS (unlike VMX) because they are meant to have the
same value for all VCPUs of the same TD.

Trust Domain Virtual Processor State (TDVPS) is the root control structure of a
TD VCPU.  It helps the TDX module control the operation of the VCPU, and holds
the VCPU state while the VCPU is not running. TDVPS is opaque to software and
DMA access, accessible only by using the TDX module interface functions (such as
TDH.VP.RD, TDH.VP.WR). TDVPS includes TD VMCS, and TD VMCS auxiliary structures,
such as virtual APIC page, virtualization exception information, etc.

Several VMX control structures (such as Shared EPT and Posted interrupt
descriptor) are directly managed and accessed by the host VMM.  These control
structures are pointed to by fields in the TD VMCS.

The above means that 1) KVM needs to allocate different data structures for TDs,
2) KVM can reuse the existing code for TDs for some operations, 3) it needs to
define TD-specific handling for others.  3) Redirect operations to .  3)
Redirect operations to the TDX specific callbacks, like "if (is_td_vcpu(vcpu))
tdx_callback() else vmx_callback();".

*TD Private Memory
TD private memory is designed to hold TD private content, encrypted by the CPU
using the TD ephemeral key. An encryption engine holds a table of encryption
keys, and an encryption key is selected for each memory transaction based on a
Host Key Identifier (HKID). By design, the host VMM does not have access to the
encryption keys.

In the first generation of MKTME, HKID is "stolen" from the physical address by
allocating a configurable number of bits from the top of the physical
address. The HKID space is partitioned into shared HKIDs for legacy MKTME
accesses and private HKIDs for SEAM-mode-only accesses. We use 0 for the shared
HKID on the host so that MKTME can be opaque or bypassed on the host.

During TDX non-root operation (i.e. guest TD), memory accesses can be qualified
as either shared or private, based on the value of a new SHARED bit in the Guest
Physical Address (GPA).  The CPU translates shared GPAs using the usual VMX EPT
(Extended Page Table) or "Shared EPT" (in this document), which resides in host
VMM memory. The Shared EPT is directly managed by the host VMM - the same as
with the current VMX. Since guest TDs usually require I/O, and the data exchange
needs to be done via shared memory, thus KVM needs to use the current EPT
functionality even for TDs.

* Secure EPT and Minoring using the TDP code
The CPU translates private GPAs using a separate Secure EPT.  The Secure EPT
pages are encrypted and integrity-protected with the TD's ephemeral private
key.  Secure EPT can be managed _indirectly_ by the host VMM, using the TDX
interface functions, and thus conceptually Secure EPT is a subset of EPT (why
"subset"). Since execution of such interface functions takes much longer time
than accessing memory directly, in KVM we use the existing TDP code to minor the
Secure EPT for the TD.

This way, we can effectively walk Secure EPT without using the TDX interface
functions.

* VM life cycle and TDX specific operations
The userspace VMM, such as QEMU, needs to build and treat TDs differently.  For
example, a TD needs to boot in private memory, and the host software cannot copy
the initial image to private memory.

* TSC Virtualization
The TDX module helps TDs maintain reliable TSC (Time Stamp Counter) values
(e.g. consistent among the TD VCPUs) and the virtual TSC frequency is determined
by TD configuration, i.e. when the TD is created, not per VCPU.  The current KVM
owns TSC virtualization for VMs, but the TDX module does for TDs.

* MCE support for TDs
The TDX module doesn't allow VMM to inject MCE.  Instead PV way is needed for TD
to communicate with VMM.  For now, KVM silently ignores MCE request by VMM.  MSRs
related to MCE (e.g, MCE bank registers) can be naturally emulated by
paravirtualizing MSR access.

[1] For details, the specifications, [2], [3], [4], [5], [6], [7], are
available.

* Restrictions or future work
Some features are not included to reduce patch size.  Those features are
addressed as future independent patch series.
- large page (2M, 1G)
- qemu gdb stub
- guest PMU
- and more

* Prerequisites
It's required to load the TDX module and initialize it.  It's out of the scope
of this patch series.  Another independent patch for the common x86 code is
planned.  It defines CONFIG_INTEL_TDX_HOST and this patch series uses
CONFIG_INTEL_TDX_HOST.  It's assumed that With CONFIG_INTEL_TDX_HOST=y, the TDX
module is initialized and ready for KVM to use the TDX module APIs for TDX guest
life cycle like tdh.mng.init are ready to use.

Concretely Global initialization, LP (Logical Processor) initialization, global
configuration, the key configuration, and TDMR and PAMT initialization are done.
The state of the TDX module is SYS_READY.  Please refer to the TDX module
specification, the chapter Intel TDX Module Lifecycle State Machine

** Detecting the TDX module readiness.
TDX host patch series implements the detection of the TDX module availability
and its initialization so that KVM can use it.  Also it manages Host KeyID
(HKID) assigned to guest TD.
The assumed APIs the TDX host patch series provides are
- int seamrr_enabled()
  Check if required cpu feature (SEAM mode) is available. This only check CPU
  feature availability.  At this point, the TDX module may not be ready for KVM
  to use.
- int init_tdx(void);
  Initialization of TDX module so that the TDX module is ready for KVM to use.
- const struct tdsysinfo_struct *tdx_get_sysinfo(void);
  Return the system wide information about the TDX module.  NULL if the TDX
  isn't initialized.
- u32 tdx_get_global_keyid(void);
  Return global key id that is used for the TDX module itself.
- int tdx_keyid_alloc(void);
  Allocate HKID for guest TD.
- void tdx_keyid_free(int keyid);
  Free HKID for guest TD.

(****)
* TDX KVM high-level design
- Host key ID management
Host Key ID (HKID) needs to be assigned to each TDX guest for memory encryption.
It is assumed The TDX host patch series implements necessary functions,
u32 tdx_get_global_keyid(void), int tdx_keyid_alloc(void) and,
void tdx_keyid_free(int keyid).

- Data structures and VM type
Because TDX is different from VMX, define its own VM/VCPU structures, struct
kvm_tdx and struct vcpu_tdx instead of struct kvm_vmx and struct vcpu_vmx.  To
identify the VM, introduce VM-type to specify which VM type, VMX (default) or
TDX, is used.

- VM life cycle and TDX specific operations
Re-purpose the existing KVM_MEMORY_ENCRYPT_OP to add TDX specific operations.
New commands are used to get the TDX system parameters, set TDX specific VM/VCPU
parameters, set initial guest memory and measurement.

The creation of TDX VM requires five additional operations in addition to the
conventional VM creation.
  - Get KVM system capability to check if TDX VM type is supported
  - VM creation (KVM_CREATE_VM)
  - New: Get the TDX specific system parameters.  KVM_TDX_GET_CAPABILITY.
  - New: Set TDX specific VM parameters.  KVM_TDX_INIT_VM.
  - VCPU creation (KVM_CREATE_VCPU)
  - New: Set TDX specific VCPU parameters.  KVM_TDX_INIT_VCPU.
  - New: Initialize guest memory as boot state and extend the measurement with
    the memory.  KVM_TDX_INIT_MEM_REGION.
  - New: Finalize VM. KVM_TDX_FINALIZE. Complete measurement of the initial
    TDX VM contents.
  - VCPU RUN (KVM_VCPU_RUN)

- Protected guest state
Because the guest state (CPU state and guest memory) is protected, the KVM VMM
can't operate on them.  For example, accessing CPU registers, injecting
exceptions, and accessing guest memory.  Those operations are handled as
silently ignored, returning zero or initial reset value when it's requested via
KVM API ioctls.

    VM/VCPU state and callbacks for TDX specific operations.
    Define tdx specific VM state and VCPU state instead of VMX ones.  Redirect
    operations to TDX specific callbacks.  "if (tdx) tdx_op() else vmx_op()".

    Operations on the CPU state
    silently ignore operations on the guest state.  For example, the write to
    CPU registers is ignored and the read from CPU registers returns 0.

    . ignore access to CPU registers except for allowed ones.
    . TSC: add a check if tsc is immutable and return an error.  Because the KVM
      implementation updates the internal tsc state and it's difficult to back
      out those changes.  Instead, skip the logic.
    . dirty logging: add check if dirty logging is supported.
    . exceptions/SMI/MCE/SIPI/INIT: silently ignore

    Note: virtual external interrupt and NMI can be injected into TDX guests.

- KVM MMU integration
One bit of the guest physical address (bit 51 or 47) is repurposed to indicate if
the guest physical address is private (the bit is cleared) or shared (the bit is
set).  The bits are called stolen bits.

  - Stolen bits framework
    systematically tracks which guest physical address, shared or private, is
    used.

  - Shared EPT and secure EPT
    There are two EPTs. Shared EPT (the conventional one) and Secure
    EPT(the new one). Shared EPT is handled the same for the stolen
    bit set.  Secure EPT points to private guest pages.  To resolve
    EPT violation, KVM walks one of two EPTs based on faulted GPA.
    Because it's costly to access secure EPT during walking EPTs with
    SEAMCALLs for the private guest physical address, another private
    EPT is used as a shadow of Secure-EPT with the existing logic at
    the cost of extra memory.

The following depicts the relationship.

                    KVM                             |       TDX module
                     |                              |           |
        -------------+----------                    |           |
        |                      |                    |           |
        V                      V                    |           |
     shared GPA           private GPA               |           |
  CPU shared EPT pointer  KVM private EPT pointer   |  CPU secure EPT pointer
        |                      |                    |           |
        |                      |                    |           |
        V                      V                    |           V
  shared EPT                private EPT<-------mirror----->Secure EPT
        |                      |                    |           |
        |                      \--------------------+------\    |
        |                                           |      |    |
        V                                           |      V    V
  shared guest page                                 |    private guest page
                                                    |
                                                    |
                              non-encrypted memory  |    encrypted memory
                                                    |

  - Operating on Secure EPT
    Use the TDX module APIs to operate on Secure EPT.  To call the TDX API
    during resolving EPT violation, add hooks to additional operation and wiring
    it to TDX backend.

* References

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

---
Changes from v4 internal review
- narrow the scope of patches for efficient review
- rebase to v5.17-rc

Changes from v3
- reorganize patch series for review.
- integrated updated vm_type patches

Changes from v2:
- update based on patch review
- support TDP MMU
- drop non-essential features (ftrace etc.) to reduce patch size

Changes from v1:
- rebase to v5.13
- drop load/initialization of TDX module
- catch up on the update of related specifications.
- rework on C-wrapper function to invoke seamcall
- various code clean up

Isaku Yamahata (5):
  KVM: TDX: Detect CPU feature on kernel module initialization
  KVM: x86: Refactor KVM VMX module init/exit functions
  KVM: TDX: Add placeholders for TDX VM/vcpu structure
  KVM: TDX: Add a function to initialize TDX module
  KVM: TDX: Make TDX VM type supported

Sean Christopherson (3):
  KVM: VMX: Move out vmx_x86_ops to 'main.c' to wrap VMX and TDX
  KVM: Enable hardware before doing arch VM initialization
  KVM: x86: Introduce vm_type to differentiate default VMs from
    confidential VMs

 Documentation/virt/kvm/api.rst        |  15 +
 arch/x86/include/asm/kvm-x86-ops.h    |   1 +
 arch/x86/include/asm/kvm_host.h       |   2 +
 arch/x86/include/uapi/asm/kvm.h       |   3 +
 arch/x86/kvm/Makefile                 |   3 +-
 arch/x86/kvm/svm/svm.c                |   6 +
 arch/x86/kvm/vmx/main.c               | 224 +++++++++++++
 arch/x86/kvm/vmx/tdx.c                | 218 +++++++++++++
 arch/x86/kvm/vmx/tdx.h                |  47 +++
 arch/x86/kvm/vmx/vmx.c                | 453 +++++++++-----------------
 arch/x86/kvm/vmx/x86_ops.h            | 141 ++++++++
 arch/x86/kvm/x86.c                    |   9 +-
 include/uapi/linux/kvm.h              |   1 +
 tools/arch/x86/include/uapi/asm/kvm.h |   3 +
 tools/include/uapi/linux/kvm.h        |   1 +
 virt/kvm/kvm_main.c                   |  14 +-
 16 files changed, 830 insertions(+), 311 deletions(-)
 create mode 100644 arch/x86/kvm/vmx/main.c
 create mode 100644 arch/x86/kvm/vmx/tdx.c
 create mode 100644 arch/x86/kvm/vmx/tdx.h
 create mode 100644 arch/x86/kvm/vmx/x86_ops.h

-- 
2.25.1

