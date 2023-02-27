Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B7486A3C60
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 09:24:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230147AbjB0IYJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 03:24:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230081AbjB0IYG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 03:24:06 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4180E06E;
        Mon, 27 Feb 2023 00:24:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677486241; x=1709022241;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=4hhkP85IeNEs3pScDycoxGBbd2FksCGcHhPO/VPrjeY=;
  b=ETL0o8exgzrpv7KzqXFlm9QwUa0Pv5vZXWm4iSh74Uh4jt3jGdRs1yGe
   UqwRZGWWPl8JTFMR7E4ZIGn52JnTuV5Dur0oW/LUzz3Tzlg3Cr+jVqfjp
   L/DsXXJELUOVcO9UkDM1HXff5t5yj62VmgYSfRB2BGHOtCOtskHVrMkmw
   mSt7lONUaVWWhja4APvoZXnFmE2kpAezJ4p8gysBBp8gGmVAN9xK/00z3
   Joy+a3VMIIfHkXKZn5GwtXH0LpTwrx1ZG5276ThgZDn0VFgv6AIvDWJYm
   X5qTgB6X4uAcpLySjFjsqF1CMiVRj9jW9QHqeuAR0Tb1x/aeIrNPjMhal
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10633"; a="317608654"
X-IronPort-AV: E=Sophos;i="5.97,331,1669104000"; 
   d="scan'208";a="317608654"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 00:24:00 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10633"; a="783242006"
X-IronPort-AV: E=Sophos;i="5.97,331,1669104000"; 
   d="scan'208";a="783242006"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 00:24:00 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>
Subject: [PATCH v12 000/106] KVM TDX basic feature support
Date:   Mon, 27 Feb 2023 00:21:59 -0800
Message-Id: <cover.1677484918.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

KVM TDX basic feature support

Hello.  This is v12 the patch series vof KVM TDX support.  This is based on
v6.2-rc7 + the following patch series.

Related patch series This patch is based on:
- fd-based approach for supporing KVM v10 and 
  https://lore.kernel.org/lkml/20221202061347.1070246-1-chao.p.peng@linux.intel.com/
  git@github.com:sean-jc/linux.git x86/upm_base_support
- TDX host kernel support v9
  https://lore.kernel.org/lkml/e1c717b36033caf8de9d7a448e06eff88ed0c9ae.camel@intel.com/T/#m2562c7f18eabae171793ed7ea81b3544d7af09c4

The tree can be found at https://github.com/intel/tdx/tree/kvm-upstream
How to run/test: It's describe at https://github.com/intel/tdx/wiki/TDX-KVM

This patch still adopts freezing sept entry instead of detecting error of TDX
SEAMCALL because it's fragile to detect race of SEAMCALL on same Secure-EPT.
The error code of SEAMCALL doesn't necessarily provides information so that
the caller, KVM TDX code, can't reliable determin if it's due to race or bug.

Changes from v11:
- ABI change of KVM_TDX_VM_INIT
- Split the hook of TDP MMU to not modify handle_changed_spte()
- Enhanced commit message on mtrr patch
- Made KVM_CAP_MAX_VCPUS to x86 specific

Thanks,
Isaku Yamahata

Changes from v10:
- rebased to v6.2-rc3
- support mtrr with its own patches
- Integrated fd-based private page v10
- Integrated TDX host kernel support v8
- Integrated kvm_init rework v2
- removed struct tdx_td_page and its initialization logic
- cleaned up mmio spte and require enable_mmio_caching=true for TDX
- removed dubious WARN_ON_ONCE()
- split a patch adding methods as nop into several patches

Changes from v9:
- rebased to v6.1-rc2
- Integrated fd-based private page v9 as prerequisite.
- Integrated TDX host kernel support v6
- TDP MMU: Make handle_change_spte() return value.
- TDX: removed seamcall_lock and return -EAGAIN so that TDP MMU can retry

Changes from v8:
- rebased to v6.0-rc7
- Integrated with kvm hardware initialization.  Check all packages has at least
  one online CPU when creating guest TD and refuse cpu offline during guest TDs
  are running.
- Integrated fd-based private page v8 as prerequisite.
- TDP MMU: Introduced more callbacks instead of single callback.

Changes from v7:
- Use xarray to track whether GFN is private or shared. Drop SPTE_SHARED_MASK.
  The complex state machine with SPTE_SHARED_MASK was ditched.
- Large page support is implemented. But will be posted as independent RFC patch.
- fd-based private page v7 is integrated. This is mostly same to Chao's patches.
  It's in github.

Changes from v6:
- rebased to v5.19

Changes from v5:
- export __seamcall and use it
- move mutex lock from callee function of smp_call_on_cpu to the caller.
- rename mmu_prezap => flush_shadow_all_private() and tdx_mmu_release_hkid
- updated comment
- drop the use of tdh_mng_key.reclaimid(): as the function is for backward
  compatibility to only return success
- struct kvm_tdx_cmd: metadata => flags, added __u64 error.
- make this ioctl systemwide ioctl
- ABI change to struct kvm_init_vm
- guest_tsc_khz: use kvm->arch.default_tsc_khz
- rename BUILD_BUG_ON_MEMCPY to MEMCPY_SAME_SIZE
- drop exporting kvm_set_tsc_khz().
- fix kvm_tdp_page_fault() for mtrr emulation
- rename it to kvm_gfn_shared_mask(), dropped kvm_gpa_shared_mask()
- drop kvm_is_private_gfn(), kept kvm_is_private_gpa()
  keep kvm_{gfn, gpa}_private(), kvm_gpa_private()
- update commit message
- rename shadow_init_value => shadow_nonprsent_value
- added ept_violation_ve_test mode
- shadow_nonpresent_value => SHADOW_NONPRESENT_VALUE in tdp_mmu.c
- legacy MMU case
  => - mmu_topup_shadow_page_cache(), kvm_mmu_create()
     - FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
- #VE warning:
- rename: REMOVED_SPTE => __REMOVED_SPTE, SHADOW_REMOVED_SPTE => REMOVED_SPTE
- merge into Like we discussed, this patch should be merged with patch
  "KVM: x86/mmu: Allow non-zero init value for shadow PTE".
- fix pointed by Sagi. check !is_private check => (kvm_gfn_shared_mask && !is_private)
- introduce kvm_gfn_for_root(kvm, root, gfn)
- add only_shared argument to kvm_tdp_mmu_handle_gfn()
- use kvm_arch_dirty_log_supported()
- rename SPTE_PRIVATE_PROHIBIT to SPTE_SHARED_MASK.
- rename: is_private_prohibit_spte() => spte_shared_mask()
- fix: shadow_nonpresent_value => SHADOW_NONPRESENT_VALUE in comment
- dropped this patch as the change was merged into kvm/queue
- update vt_apicv_post_state_restore()
- use is_64_bit_hypercall()
- comment: expand MSMI -> Machine Check System Management Interrupt
- fixed TDX_SEPT_PFERR
- tdvmcall_p[1234]_{write, read}() => tdvmcall_a[0123]_{read,write}()
- rename tdmvcall_exit_readon() => tdvmcall_leaf()
- remove optional zero check of argument.
- do a check for static_call(kvm_x86_has_emulated_msr)(kvm, MSR_IA32_SMBASE)
   in kvm_vcpu_ioctl_smi and __apic_accept_irq.
- WARN_ON_ONCE in tdx_smi_allowed and tdx_enable_smi_window.
- introduce vcpu_deliver_init to x86_ops
- sprinkeled KVM_BUG_ON()

Changes from v4:
- rebased to TDX host kernel patch series.
- include all the patches to make this patch series working.
- add [MARKER] patches to mark the patch layer clear.

---
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


* The organization of this patch series
This patch series is on top of the patches series "TDX host kernel support":
https://lore.kernel.org/lkml/cover.1646007267.git.kai.huang@intel.com/

This patch series is available at
https://github.com/intel/tdx/tree/kvm-upstream

The related repositories (TDX qemu, TDX OVMF(tdvf) etc) are described at
https://github.com/intel/tdx/wiki/TDX-KVM

The relations of the layers are depicted as follows.
The arrows below show the order of patch reviews we would like to have.

The below layers are chosen so that the device model, for example, qemu can
exercise each layering step by step.  Check if TDX is supported, create TD VM,
create TD vcpu, allow vcpu running, populate TD guest private memory, and handle
vcpu exits/hypercalls/interrupts to run TD fully.

  TDX vcpu
  interrupt/exits/hypercall<------------\
        ^                               |
        |                               |
  TD finalization                       |
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
   TDX, VMX    <--------TDX host kernel         KVM MMU GPA stolen bits
   coexistence          support


The followings are explanations of each layer.  Each layer has a dummy commit
that starts with [MARKER] in subject.  It is intended to help to identify where
each layer starts.

TDX host kernel support:
        https://lore.kernel.org/lkml/cover.1646007267.git.kai.huang@intel.com/
        The guts of system-wide initialization of TDX module.  There is an
        independent patch series for host x86.  TDX KVM patches call functions
        this patch series provides to initialize the TDX module.

TDX, VMX coexistence:
        Infrastructure to allow TDX to coexist with VMX and trigger the
        initialization of the TDX module.
        This layer starts with
        "KVM: VMX: Move out vmx_x86_ops to 'main.c' to wrap VMX and TDX"
TDX architectural definitions:
        Add TDX architectural definitions and helper functions
        This layer starts with
        "[MARKER] The start of TDX KVM patch series: TDX architectural definitions".
TD VM creation/destruction:
        Guest TD creation/destroy allocation and releasing of TDX specific vm
        and vcpu structure.  Create an initial guest memory image with TDX
        measurement.
        This layer starts with
        "[MARKER] The start of TDX KVM patch series: TD VM creation/destruction".
TD vcpu creation/destruction:
        guest TD creation/destroy Allocation and releasing of TDX specific vm
        and vcpu structure.  Create an initial guest memory image with TDX
        measurement.
        This layer starts with
        "[MARKER] The start of TDX KVM patch series: TD vcpu creation/destruction"
TDX EPT violation:
        Create an initial guest memory image with TDX measurement.  Handle
        secure EPT violations to populate guest pages with TDX SEAMCALLs.
        This layer starts with
        "[MARKER] The start of TDX KVM patch series: TDX EPT violation"
TD vcpu enter/exit:
        Allow TDX vcpu to enter into TD and exit from TD.  Save CPU state before
        entering into TD.  Restore CPU state after exiting from TD.
        This layer starts with
        "[MARKER] The start of TDX KVM patch series: TD vcpu enter/exit"
TD vcpu interrupts/exit/hypercall:
        Handle various exits/hypercalls and allow interrupts to be injected so
        that TD vcpu can continue running.
        This layer starts with
        "[MARKER] The start of TDX KVM patch series: TD vcpu exits/interrupts/hypercalls"

KVM MMU GPA shared bit:
        Introduce framework to handle shared bit repurposed bit of GPA TDX
        repurposed a bit of GPA to indicate shared or private. If it's shared,
        it's the same as the conventional VMX EPT case.  VMM can access shared
        guest pages.  If it's private, it's handled by Secure-EPT and the guest
        page is encrypted.
        This layer starts with
        "[MARKER] The start of TDX KVM patch series: KVM MMU GPA stolen bits"
KVM TDP refactoring for TDX:
        TDX Secure EPT requires different constants. e.g. initial value EPT
        entry value etc. Various refactoring for those differences.
        This layer starts with
        "[MARKER] The start of TDX KVM patch series: KVM TDP refactoring for TDX"
KVM TDP MMU hooks:
        Introduce framework to TDP MMU to add hooks in addition to direct EPT
        access TDX added Secure EPT which is an enhancement to VMX EPT.  Unlike
        conventional VMX EPT, CPU can't directly read/write Secure EPT. Instead,
        use TDX SEAMCALLs to operate on Secure EPT.
        This layer starts with
        "[MARKER] The start of TDX KVM patch series: KVM TDP MMU hooks"
KVM TDP MMU MapGPA:
        Introduce framework to handle switching guest pages from private/shared
        to shared/private.  For a given GPA, a guest page can be assigned to a
        private GPA or a shared GPA exclusively.  With TDX MapGPA hypercall,
        guest TD converts GPA assignments from private (or shared) to shared (or
        private).
        This layer starts with
        "[MARKER] The start of TDX KVM patch series: KVM TDP MMU MapGPA "

KVM guest private memory: (not shown in the above diagram)
[PATCH v4 00/12] KVM: mm: fd-based approach for supporting KVM guest private
memory: https://lkml.org/lkml/2022/1/18/395
        Guest private memory requires different memory management in KVM.  The
        patch proposes a way for it.  Integration with TDX KVM.

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
- const struct tdsysinfo_struct *tdx_get_sysinfo(void);
  Return the system wide information about the TDX module.  NULL if the TDX
  isn't initialized.
- int tdx_enable(void);
  Initialization of TDX module so that the TDX module is ready for KVM to use.
- extern u32 tdx_global_keyid __read_mostly;
  global host key id that is used for the TDX module itself.
- u32 tdx_get_num_keyid(void);
  return the number of available TDX private host key id.
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
  shared EPT                private EPT--------mirror----->Secure EPT
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
   https://www.intel.com/content/www/us/en/developer/articles/technical/intel-trust-domain-extensions.html
[2] Intel Trust Domain Extensions (Intel TDX)
   https://cdrdv2.intel.com/v1/dl/getContent/726790
[3] Intel CPU Architectural Extensions Specification
   https://www.intel.com/content/dam/develop/external/us/en/documents-tps/intel-tdx-cpu-architectural-specification.pdf
[4] Intel TDX Module 1.0 Specification
   https://www.intel.com/content/dam/develop/external/us/en/documents/tdx-module-1.0-public-spec-v0.931.pdf
[5] Intel TDX Loader Interface Specification
  https://www.intel.com/content/dam/develop/external/us/en/documents-tps/intel-tdx-seamldr-interface-specification.pdf
[6] Intel TDX Guest-Hypervisor Communication Interface
   https://cdrdv2.intel.com/v1/dl/getContent/726790
[7] Intel TDX Virtual Firmware Design Guide
   https://www.intel.com/content/dam/develop/external/us/en/documents/tdx-virtual-firmware-design-guide-rev-1.01.pdf
[8] intel public github
   kvm TDX branch: https://github.com/intel/tdx/tree/kvm
   TDX guest branch: https://github.com/intel/tdx/tree/guest
   qemu TDX https://github.com/intel/qemu-tdx
[9] TDVF
    https://github.com/tianocore/edk2-staging/tree/TDVF
    This was merged into EDK2 main branch. https://github.com/tianocore/edk2

Chao Gao (1):
  KVM: x86: Allow to update cached values in kvm_user_return_msrs w/o
    wrmsr

Isaku Yamahata (84):
  [MARKER] The start of TDX KVM patch series: TDX architectural
    definitions
  KVM: TDX: Define TDX architectural definitions
  KVM: TDX: Add C wrapper functions for SEAMCALLs to the TDX module
  KVM: TDX: Add helper functions to print TDX SEAMCALL error
  [MARKER] The start of TDX KVM patch series: TD VM creation/destruction
  x86/cpu: Add helper functions to allocate/free TDX private host key id
  x86/virt/tdx: Add a helper function to return system wide info about
    TDX module
  KVM: TDX: Add place holder for TDX VM specific mem_enc_op ioctl
  KVM: x86, tdx: Make KVM_CAP_MAX_VCPUS backend specific
  KVM: x86/vmx, tdx: Allow VMX, TDX to override KVM_ENABLE_CAP
  KVM: TDX: create/destroy VM structure
  KVM: TDX: initialize VM with TDX specific parameters
  KVM: TDX: Make pmu_intel.c ignore guest TD case
  KVM: TDX: Refuse to unplug the last cpu on the package
  [MARKER] The start of TDX KVM patch series: TD vcpu
    creation/destruction
  KVM: TDX: allocate/free TDX vcpu structure
  KVM: TDX: Do TDX specific vcpu initialization
  [MARKER] The start of TDX KVM patch series: KVM MMU GPA shared bits
  KVM: x86/mmu: introduce config for PRIVATE KVM MMU
  KVM: x86/mmu: Add address conversion functions for TDX shared bit of
    GPA
  [MARKER] The start of TDX KVM patch series: KVM TDP refactoring for
    TDX
  KVM: x86/mmu: Replace hardcoded value 0 for the initial value for SPTE
  KVM: x86/mmu: Add Suppress VE bit to
    shadow_mmio_mask/shadow_present_mask
  KVM: x86/mmu: Track shadow MMIO value on a per-VM basis
  KVM: x86/mmu: Disallow fast page fault on private GPA
  KVM: VMX: Introduce test mode related to EPT violation VE
  [MARKER] The start of TDX KVM patch series: KVM TDP MMU hooks
  KVM: x86/tdp_mmu: Init role member of struct kvm_mmu_page at
    allocation
  KVM: x86/mmu: Require TDP MMU and mmio caching for TDX
  KVM: x86/mmu: Add a new is_private member for union kvm_mmu_page_role
  KVM: x86/mmu: Add a private pointer to struct kvm_mmu_page
  KVM: Add flags to struct kvm_gfn_range
  KVM: x86/tdp_mmu: Sprinkle __must_check
  KVM: x86/tdp_mmu: Support TDX private mapping for TDP MMU
  [MARKER] The start of TDX KVM patch series: TDX EPT violation
  KVM: x86/mmu: Disallow dirty logging for x86 TDX
  KVM: TDX: TDP MMU TDX support
  KVM: TDX: MTRR: implement get_mt_mask() for TDX
  [MARKER] The start of TDX KVM patch series: TD finalization
  KVM: TDX: Create initial guest memory
  KVM: TDX: Finalize VM initialization
  [MARKER] The start of TDX KVM patch series: TD vcpu enter/exit
  KVM: TDX: Add helper assembly function to TDX vcpu
  KVM: TDX: Implement TDX vcpu enter/exit path
  KVM: TDX: vcpu_run: save/restore host state(host kernel gs)
  KVM: TDX: restore host xsave state when exit from the guest TD
  KVM: TDX: restore user ret MSRs
  [MARKER] The start of TDX KVM patch series: TD vcpu
    exits/interrupts/hypercalls
  KVM: TDX: complete interrupts after tdexit
  KVM: TDX: restore debug store when TD exit
  KVM: TDX: handle vcpu migration over logical processor
  KVM: x86: Add a switch_db_regs flag to handle TDX's auto-switched
    behavior
  KVM: TDX: remove use of struct vcpu_vmx from posted_interrupt.c
  KVM: TDX: Implement interrupt injection
  KVM: TDX: Implements vcpu request_immediate_exit
  KVM: TDX: Implement methods to inject NMI
  KVM: TDX: Add a place holder to handle TDX VM exit
  KVM: TDX: handle EXIT_REASON_OTHER_SMI
  KVM: TDX: handle ept violation/misconfig exit
  KVM: TDX: handle EXCEPTION_NMI and EXTERNAL_INTERRUPT
  KVM: TDX: Add a place holder for handler of TDX hypercalls
    (TDG.VP.VMCALL)
  KVM: TDX: handle KVM hypercall with TDG.VP.VMCALL
  KVM: TDX: Add KVM Exit for TDX TDG.VP.VMCALL
  KVM: TDX: Handle TDX PV CPUID hypercall
  KVM: TDX: Handle TDX PV HLT hypercall
  KVM: TDX: Handle TDX PV port io hypercall
  KVM: TDX: Implement callbacks for MSR operations for TDX
  KVM: TDX: Handle TDX PV rdmsr/wrmsr hypercall
  KVM: TDX: Handle TDX PV report fatal error hypercall
  KVM: TDX: Handle TDX PV map_gpa hypercall
  KVM: TDX: Handle TDG.VP.VMCALL<GetTdVmCallInfo> hypercall
  KVM: TDX: Silently discard SMI request
  KVM: TDX: Silently ignore INIT/SIPI
  KVM: TDX: Add methods to ignore guest instruction emulation
  KVM: TDX: Add a method to ignore dirty logging
  KVM: TDX: Add methods to ignore VMX preemption timer
  KVM: TDX: Add methods to ignore accesses to TSC
  KVM: TDX: Ignore setting up mce
  KVM: TDX: Add a method to ignore for TDX to ignore hypercall patch
  KVM: TDX: Add methods to ignore virtual apic related operation
  Documentation/virt/kvm: Document on Trust Domain Extensions(TDX)
  KVM: x86: design documentation on TDX support of x86 KVM TDP MMU
  RFC: KVM: TDX: Make busy with S-EPT on entry bug
  [MARKER] the end of (the first phase of) TDX KVM patch series

Sean Christopherson (18):
  KVM: TDX: Add TDX "architectural" error codes
  KVM: TDX: x86: Add ioctl to get TDX systemwide parameters
  KVM: Allow page-sized MMU caches to be initialized with custom 64-bit
    values
  KVM: x86/mmu: Allow non-zero value for non-present SPTE and removed
    SPTE
  KVM: x86/mmu: Allow per-VM override of the TDP max page level
  KVM: x86/tdp_mmu: Don't zap private pages for unsupported cases
  KVM: VMX: Split out guts of EPT violation to common/exposed function
  KVM: VMX: Move setting of EPT MMU masks to common VT-x code
  KVM: TDX: Add accessors VMX VMCS helpers
  KVM: TDX: Add load_mmu_pgd method for TDX
  KVM: x86/mmu: Introduce kvm_mmu_map_tdp_page() for use by TDX
  KVM: TDX: Add support for find pending IRQ in a protected local APIC
  KVM: x86: Assume timer IRQ was injected if APIC state is proteced
  KVM: VMX: Modify NMI and INTR handlers to take intr_info as function
    argument
  KVM: VMX: Move NMI/exception handler to common helper
  KVM: x86: Split core of hypercall emulation to helper function
  KVM: TDX: Handle TDX PV MMIO hypercall
  KVM: TDX: Add methods to ignore accesses to CPU state

Yan Zhao (1):
  KVM: x86/mmu: TDX: Do not enable page track for TD guest

Yao Yuan (1):
  KVM: TDX: Handle vmentry failure for INTEL TD guest

Yuan Yao (1):
  KVM: TDX: Retry seamcall when TDX_OPERAND_BUSY with operand SEPT

 Documentation/virt/kvm/api.rst         |    9 +-
 Documentation/virt/kvm/index.rst       |    3 +
 Documentation/virt/kvm/intel-tdx.rst   |  351 +++
 Documentation/virt/kvm/tdx-tdp-mmu.rst |  417 ++++
 arch/x86/events/intel/ds.c             |    1 +
 arch/x86/include/asm/kvm-x86-ops.h     |   14 +
 arch/x86/include/asm/kvm_host.h        |   75 +-
 arch/x86/include/asm/tdx.h             |   74 +-
 arch/x86/include/asm/vmx.h             |   14 +
 arch/x86/include/uapi/asm/kvm.h        |   83 +
 arch/x86/include/uapi/asm/vmx.h        |    5 +-
 arch/x86/kvm/Kconfig                   |    4 +
 arch/x86/kvm/Makefile                  |    2 +-
 arch/x86/kvm/cpuid.c                   |    7 +
 arch/x86/kvm/cpuid.h                   |    2 +
 arch/x86/kvm/irq.c                     |    3 +
 arch/x86/kvm/lapic.c                   |   33 +-
 arch/x86/kvm/lapic.h                   |    2 +
 arch/x86/kvm/mmu.h                     |   36 +
 arch/x86/kvm/mmu/mmu.c                 |  192 +-
 arch/x86/kvm/mmu/mmu_internal.h        |  111 +-
 arch/x86/kvm/mmu/page_track.c          |    3 +
 arch/x86/kvm/mmu/paging_tmpl.h         |    3 +-
 arch/x86/kvm/mmu/spte.c                |   22 +-
 arch/x86/kvm/mmu/spte.h                |   29 +-
 arch/x86/kvm/mmu/tdp_iter.h            |   14 +-
 arch/x86/kvm/mmu/tdp_mmu.c             |  436 +++-
 arch/x86/kvm/mmu/tdp_mmu.h             |    7 +-
 arch/x86/kvm/smm.h                     |    7 +-
 arch/x86/kvm/svm/svm.c                 |    1 +
 arch/x86/kvm/vmx/common.h              |  176 ++
 arch/x86/kvm/vmx/main.c                | 1121 +++++++++-
 arch/x86/kvm/vmx/pmu_intel.c           |   46 +-
 arch/x86/kvm/vmx/pmu_intel.h           |   28 +
 arch/x86/kvm/vmx/posted_intr.c         |   43 +-
 arch/x86/kvm/vmx/posted_intr.h         |   13 +
 arch/x86/kvm/vmx/tdx.c                 | 2775 +++++++++++++++++++++++-
 arch/x86/kvm/vmx/tdx.h                 |  211 +-
 arch/x86/kvm/vmx/tdx_arch.h            |  168 ++
 arch/x86/kvm/vmx/tdx_errno.h           |   38 +
 arch/x86/kvm/vmx/tdx_error.c           |   21 +
 arch/x86/kvm/vmx/tdx_ops.h             |  218 ++
 arch/x86/kvm/vmx/vmcs.h                |    5 +
 arch/x86/kvm/vmx/vmenter.S             |  156 ++
 arch/x86/kvm/vmx/vmx.c                 |  252 +--
 arch/x86/kvm/vmx/vmx.h                 |   52 +-
 arch/x86/kvm/vmx/x86_ops.h             |  111 +-
 arch/x86/kvm/x86.c                     |  136 +-
 arch/x86/kvm/x86.h                     |    2 +
 arch/x86/virt/vmx/tdx/seamcall.S       |    2 +
 arch/x86/virt/vmx/tdx/tdx.c            |   55 +-
 arch/x86/virt/vmx/tdx/tdx.h            |   51 -
 include/linux/kvm_host.h               |   12 +-
 include/linux/kvm_types.h              |    1 +
 include/uapi/linux/kvm.h               |   57 +
 tools/arch/x86/include/uapi/asm/kvm.h  |   92 +
 virt/kvm/kvm_main.c                    |   46 +-
 57 files changed, 7303 insertions(+), 545 deletions(-)
 create mode 100644 Documentation/virt/kvm/intel-tdx.rst
 create mode 100644 Documentation/virt/kvm/tdx-tdp-mmu.rst
 create mode 100644 arch/x86/kvm/vmx/common.h
 create mode 100644 arch/x86/kvm/vmx/pmu_intel.h
 create mode 100644 arch/x86/kvm/vmx/tdx_arch.h
 create mode 100644 arch/x86/kvm/vmx/tdx_errno.h
 create mode 100644 arch/x86/kvm/vmx/tdx_error.c
 create mode 100644 arch/x86/kvm/vmx/tdx_ops.h


base-commit: 513c1a3d3f1982fb850c910937099525b0d35e24
prerequisite-patch-id: 0711427e09d394052f47d629a05fff9139cf45f9
prerequisite-patch-id: f4e4bba285caf9235ffd723a9dea5d4bb6f091bb
prerequisite-patch-id: ae77e481e68d80051823abb20ffc0a11a7e7519f
prerequisite-patch-id: 447db73f329f75f973a5535dd2a831b16adb7e29
prerequisite-patch-id: 0918dcd86d4b3a738fe1d2bd5fbb018daf7fedb3
prerequisite-patch-id: 835f8c91d0bcbaa467531b0c673591dcbac93aab
prerequisite-patch-id: 70a64b2a969263a662235e004f5d165987cdee7b
prerequisite-patch-id: 9e02516dfb181273064b90d9e649ab710faa8327
prerequisite-patch-id: c6c86136ad5fe3f4f028aca2ae576f626a609d50
prerequisite-patch-id: d74e0cff593b7482b4aa9adcb404e63335aa7998
prerequisite-patch-id: 05ae7b8b946fb40fdcca626170937521745087a2
prerequisite-patch-id: 23484d65b2ca3d1dc3e6038fe634966ca926c1fd
prerequisite-patch-id: dc57166c8b1002b0d523c36a567a25c7d97f99ad
prerequisite-patch-id: bcb7f7c4f9afa44b5261c55803bcd6096f80b283
prerequisite-patch-id: 5d184cb4d4658388188e347c328da8778bdf9e29
prerequisite-patch-id: 6b25bde8b3ed7ae0b759fa69e931220d64d2e522
prerequisite-patch-id: 253c15673e595bd69c0b584ceabe29a25dfe4d52
prerequisite-patch-id: 2345b717dbc9088f51de2430ff2a8cf48bc41c7e
prerequisite-patch-id: 2e84c58128ab60d53dcf17e456396df62536d162
prerequisite-patch-id: b141fb4c84b6a6399c5a0e399a5a7c5279892aa4
prerequisite-patch-id: 97b3b271be3bd8541c102f73e8491bf95abad365
prerequisite-patch-id: f8dd2855bd255866b8c3670f3a826061fdf689be
prerequisite-patch-id: 4066b6b99abaf69a4b4f02fd623e0d3c896f9dd5
prerequisite-patch-id: 23113c11b5d43ba44f50a434b6f16c6cd1115305
prerequisite-patch-id: 9831f77bab0eb4320e60a8b7b9a5846069260afd
prerequisite-patch-id: 88aa762b68fe99342b101d476847905451507172
prerequisite-patch-id: 9b117dd0273de675bb20d43256bbfb89f7b7575c
prerequisite-patch-id: c07e2331876dc8ab4100655d5e2a33b0395a0a14
prerequisite-patch-id: 7b6a3d3a3695e8cc31877e27588e4a0aa55f4587
prerequisite-patch-id: 0eee33e1c8fb1ba97f3f7f8d9cca2e5ec8cd6c70
prerequisite-patch-id: 93b4dcfa25d777a4db8711cbb3e806abbcf348d3
prerequisite-patch-id: 7ef859d08678020338b04daaae0abb42821fc559
prerequisite-patch-id: 13c5aae87d890b4c856ec2718252616851001a7b
prerequisite-patch-id: 00524c037d3084b8e8af731030e3d47d146d2e2b
prerequisite-patch-id: bb5bcbe9e50bc33565612543865478e001fa8fee
prerequisite-patch-id: b9f0ecb32b8a48f6b975b3f2ba4c059f489c32aa
prerequisite-patch-id: 6f38d6cea1fcf7df86677b75c73905c3855ad57f
prerequisite-patch-id: e23f0c75c61f46d8e801465cfa05fdcb722e6caa
prerequisite-patch-id: e457d47d9e2fdceaf5088e627b6e4cc216b5e85d
prerequisite-patch-id: a62d991592c1ba08d928e923e0c6c03530bd63dd
prerequisite-patch-id: 9bd5f96a907a709aae8af549fa10484c4347782b
prerequisite-patch-id: 972d15ad44b9b44f390dea6d037e15421a897fd8
prerequisite-patch-id: e01e352a0a5545a93f5bc9af9ddc9ebb6062b703
prerequisite-patch-id: 6a7fcb0f2364deaf2514f8a23ff782be02fe5026
prerequisite-patch-id: 15608c8c226ee426ee976cc4410bff8ae865d920
prerequisite-patch-id: 76b053ab857a63c265df686024ff1fda0a2b6e7d
prerequisite-patch-id: 32a45051ddb8b785a0389814b73e38d8d7d7a6ae
prerequisite-patch-id: 5acae7bf571007f6c9b021fb69c500a7110b0ae3
prerequisite-patch-id: 14f83dfadef9dd8da6268ab6d73046a199a57116
prerequisite-patch-id: c2888053763858ee8ef39b30a1c8005c26a2378c
prerequisite-patch-id: 5bf7a07a4e19850fee9cd56d15a421b2cb2802b8
prerequisite-patch-id: 34ba41a3d0b4ad565c387bba9eef51e0556ff4ee
prerequisite-patch-id: 94ae4f32ad3f3693b9700f08d80da5a369d2cdaa
prerequisite-patch-id: 068d0c78244299a6cd9182c130bcb81d1c3ffdf1
prerequisite-patch-id: 9c38fc7292d5526e00148635229eedbbcb788583
prerequisite-patch-id: a244b94ee9b65b5bbba29f1eae311177adc3cefd
prerequisite-patch-id: acf875a766868d3969446897742f154b8e364a80
prerequisite-patch-id: c3d704436879601a54b8d42b5e565ca934c48195
prerequisite-patch-id: dc172265f050831b96447522dc8fab4231fd50d9
prerequisite-patch-id: 8d1ef7b82aba942d60171ed0877479d2a4297404
prerequisite-patch-id: e78505575e9e9f08d0166fa3eaf05c140929e319
prerequisite-patch-id: bcd4a65da6528d07f1edd628ec7f1d8df66222a0
prerequisite-patch-id: 2597d4d142448ff4796f4b9fcc5ab2e9873ae391
prerequisite-patch-id: 73023e0f63805ae226ffffe6af0798adb14c9e63
prerequisite-patch-id: daaff2e774b9e2aa139fbf89486650acc815cfa4
prerequisite-patch-id: 027b97fe2a2d10188ad1b18154a5b3a494fcdb3b
prerequisite-patch-id: 945c0546972666678bfb2b5c7737370e9f0897cb
prerequisite-patch-id: 94475f3a196844c29c9ffcfb728cecbc2baa0900
prerequisite-patch-id: 4eb88b47e0ed46c9034008bb5c9350c9e940c454
prerequisite-patch-id: 261cfb768e11e24317a4113f3cec3e65ba021696
prerequisite-patch-id: 8fbfa7cdd01d715cb8bbfe20041d0fecc691f72d
prerequisite-patch-id: c0a4c61d4e210aa0c691b26b3d4a0ab06efa617d
prerequisite-patch-id: 66322a79e5a22623c2398e9663ad23597b11347d
prerequisite-patch-id: 569bc795ecfd8c434c75bbc0202fa058c423e40e
prerequisite-patch-id: bb6bb2b65db2bc477c4b2e0e4144b9606db713a6
prerequisite-patch-id: 982f8129cad940137f6cf2c6234300b2e7d60c80
prerequisite-patch-id: f4fa117498ff3dd92db3b47c2d92e42a3d5c20f1
prerequisite-patch-id: 887655947c99ab6e822e7518ca779db5f27b86a1
prerequisite-patch-id: 8cc565c48b64291afb9cc817671d046cdc28a4ac
prerequisite-patch-id: 27f2d18b5ce2af402462117b522ad5a827ba3e82
prerequisite-patch-id: 40e5e3850a9402a43c31d4305f9c2e8051026328
prerequisite-patch-id: 871f2d5e5df13094f62fb8a52cb7d88ebb6146ba
prerequisite-patch-id: 176eac82fd72836b18ae8d50460f194421a00a02
prerequisite-patch-id: d38e46840d508967d1566c02ca5d1fecc39ad4ef
prerequisite-patch-id: 3160d1d6c295d51a610c71f8f9b8a0d83ee6d66c
prerequisite-patch-id: eb533cad65d1717efc48978ea6bc1c7a00cecfd2
prerequisite-patch-id: 1b4777af5019256652cf46a9719b645f35ad3545
prerequisite-patch-id: ab67f6fbf39573bf1926ed47f0f377d1907d93f9
prerequisite-patch-id: e53b862a3f19bfae6bad83a14e65399317e8f412
prerequisite-patch-id: f8c467f752f8ae76e4371637fc7f7f29ebba44c2
prerequisite-patch-id: 7746a8aef667b0d76e867bb3fe84c37e18ba9cf5
prerequisite-patch-id: 78d7b3b721d433f62393de3b12169c4b462fa939
prerequisite-patch-id: 24d59ae1238fb43f7337a0d08478f394441b04dc
prerequisite-patch-id: 42287c3913d32bf80cc28be41d8bf9972139dc33
prerequisite-patch-id: be3e7f787d9912862b913df033f4087d25ec5aa4
prerequisite-patch-id: a0a7ae7f18baf2ba244a5f2c38375c3352c933b8
prerequisite-patch-id: 7f4f230b3739ec80e426fb42bd7e80795ab97f20
prerequisite-patch-id: 103d70d6a171ec88afbe7b79dacc38f45141e1f8
prerequisite-patch-id: c02ee58512800188946f1a4aecdee9c8fd9783bc
prerequisite-patch-id: 64aadbfc41067b73b942410fe4900d83e8b2fa34
prerequisite-patch-id: 97871a9f8b43b5b45c39008fe90a461eacb4eade
prerequisite-patch-id: f2be318daa505a3ec4d310438484bd27c47f08dd
prerequisite-patch-id: 4d458c35e2988d7ffa25f1b7945e84a43efffb5e
prerequisite-patch-id: 1c2f09dc37a0b4ddd186f474207d98dafa8de411
prerequisite-patch-id: c3813c0f10f83c0c0b93a84e1c31c304ff5b48e0
prerequisite-patch-id: 06060a0723d48ca605a960d819b9e3c7fe0a2bb1
prerequisite-patch-id: 3023cf5f10af5d6d129d8483ce0b28b3c2ebff57
prerequisite-patch-id: 27d601d1cceccc045e79567b7ca4e9c9bbfff071
prerequisite-patch-id: 7d0b40a3a2a480541704e429bbbec763482a802c
prerequisite-patch-id: f15d178f9000430e0089c546756ab1d8d29341a7
prerequisite-patch-id: e162f31c8556dc9b1eebb52b153d2d4ae76d663f
prerequisite-patch-id: 81f0aa03c369838b739657547210249097aa3429
prerequisite-patch-id: 308ddf8aa7d3260ce21f687c0a39d21a8a7e421e
prerequisite-patch-id: 9d77fb0e8ce8c8c21e22ff3f26bd168eb5446df0
prerequisite-patch-id: 6aa44589d9a85a39af2224817c4f857ac3a04695
prerequisite-patch-id: 498e20857392d3ab0b290335f6bc4a646a9d8797
prerequisite-patch-id: 773bf14343711b6df1790f3c0e0bceec952be19c
prerequisite-patch-id: c1ff9950424897e617e2be2c96881714fb4aa2d2
prerequisite-patch-id: 8a420307f338a7a496e87649f200227816226880
prerequisite-patch-id: 94420af3725fc8b7d9b0bea2549f71c106dc6c78
prerequisite-patch-id: 52e7b497758cc689a2717c4483e64a3b0562f3f7
prerequisite-patch-id: c771edd362e6306753f058b0061f3218158ce717
prerequisite-patch-id: 9db94eaed64451494088ffc13fca31d8bf0144e6
prerequisite-patch-id: 68bc54f6dbee57d34ec6397df8bd2d76f0e5b15e
prerequisite-patch-id: 301dbdf8448175ea609664c890a3694750ecf740
prerequisite-patch-id: ba8e6068bcef7865bb5523065e19edd49fbc02de
prerequisite-patch-id: 7a11e08c6b7b73cd3fd29809c155af5d5400a24f
prerequisite-patch-id: a123ed868b3ed76e35dfc4830e4c3e903464db64
prerequisite-patch-id: cb5d2a167bed556fe3b2aa26452ee53d5e7c4428
prerequisite-patch-id: 5618d2414a1ef641b4c247b5e28076f67a765b24
prerequisite-patch-id: 338234d708730ff22c40b3a8ffbcf6820e9e6381
prerequisite-patch-id: 265913c78c61a3f84975f2a427bc895319a64b64
prerequisite-patch-id: bda07e82c47928bff9f1fcc8d003c526a5a42b6b
prerequisite-patch-id: 909d82383aac39075f4a80325d7a0d09f060ffb6
prerequisite-patch-id: 7ae6c571e61a2dc52aa1470b088d57b87267047f
prerequisite-patch-id: 2457494a366e0571189f98814b531435e656bc9d
prerequisite-patch-id: b7fc334127598465b74056593ee5ec1ceb67cee3
prerequisite-patch-id: b5eb477c22f1d4e9311760be7dcb4155f7bd01a0
prerequisite-patch-id: 0577b5bae65761382b14df238a107c24c5589f22
prerequisite-patch-id: 20f4cee4163cdbae5311cb8ee253ef3db48e10ad
prerequisite-patch-id: 8ea0ca56650455427780838fbd3f3a3fe412add5
prerequisite-patch-id: 4cfa225b52663f3308346df86c9f33120982fffa
prerequisite-patch-id: 66b406c400fb1ada0bae998b933621ed77557173
prerequisite-patch-id: cb32f271215dd2080619b4a794331c8b1c518ae6
prerequisite-patch-id: ffb4d5a65b230e2a6cfbedc4341287d520a215ee
prerequisite-patch-id: 3c93e412ef811eb92d0c9e7442108e57f4c0161d
prerequisite-patch-id: 8d5eff028fb5b925f659364f5aa41102a693fec3
prerequisite-patch-id: 90af14973f31856b7af0a44c33059729a91547c3
prerequisite-patch-id: aa3b25f154c23e996118c42521a77b9dc211256c
prerequisite-patch-id: f4c167fb86fb2fa6ff05f9f7932d154e1eaa4223
prerequisite-patch-id: 0b2bc7d01b85a07d441b56a7c55b3e383e8fe433
prerequisite-patch-id: 12d16cfb3118cc4cdbafa192c8458bd1103ed704
prerequisite-patch-id: dec14f3d6c1f4243b23bcbe0ecca83ae6ab703de
prerequisite-patch-id: 4451413560f58c6ce2f752b05085e3226878b256
prerequisite-patch-id: 82897b015f65fc920f5fdb6ffcd60d5de0fe09d2
prerequisite-patch-id: 716544cdd2e1ccec5efb4968a87f560689cebbca
prerequisite-patch-id: 4399516d31260b164e5bdebaea0f566e0508e318
prerequisite-patch-id: 78579fdc8bec4a6e3d576ac01c97124b6b2503a3
prerequisite-patch-id: e998ddb2d9d31a0b3e968d7195cbc4d2372bef36
prerequisite-patch-id: df55ce2450aa405f904d1a5085ffe33b0ec6e399
prerequisite-patch-id: 16d63052069b5079502e6e8ee7a0e38111471af5
prerequisite-patch-id: bf5fd74736424429cee5bf645f85d09bb93a26be
prerequisite-patch-id: d0a71fc6ae91999a93703727e682532fe5d12c9a
prerequisite-patch-id: a8774091ff1e54f65c926c443703a776c288916d
prerequisite-patch-id: b139f94a8d2458d3d2a4d81e0bdf77cd2eaacc05
prerequisite-patch-id: b1aed667f5cf78a947491280cffd6fa85c5d310c
prerequisite-patch-id: 8a4fcdc6aefb233e60f6be919d9d94f7192b7fee
prerequisite-patch-id: 4f0cbb8eeddc992d22b4b0cdd7eda53aed85e9f8
prerequisite-patch-id: 0dd9f6c8dc9cebd06a7203ec29d5d4d2256929ab
-- 
2.25.1

