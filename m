Return-Path: <kvm+bounces-894-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 004FF7E4230
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 15:57:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 07E9BB20DBD
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 14:57:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2700B31591;
	Tue,  7 Nov 2023 14:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hsZn3vCg"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8B1D30D04
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 14:57:39 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4069101;
	Tue,  7 Nov 2023 06:57:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699369055; x=1730905055;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=RLm/2VKLnTxqe1fFdufygmb22r7xa1YqwoIcsNLJWcg=;
  b=hsZn3vCglsBww065NgTsSEVc4wM6kqUmvUsFwJa7ncIwC2sNLYd1oyd1
   9+pgY4nHdEQiuE9/Kze8CzjsVVTuQcDpDLe/vml1obK+rHk9DcAsuga+/
   qP/0JSVl/Azt3OpZuHAxmSmoD1YbW0SBtJk8eKi2sK2phDmgiWJDK4VYA
   mdlyzgMJyZeEjHSLBAtfYKByGtrgMBkZI1KsqELWluVDehFzi225T8Nrr
   QIEEenl2wio6hRUHE7wOa4/XIrxYSPyR+uZwZ2Dudo4eoJE6COh3dPgYU
   qjHlFzfPysftdQJsA9fdGZwXXAewlohog3fJnr3NJ9KvVO8948EZI7o8O
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10887"; a="2462021"
X-IronPort-AV: E=Sophos;i="6.03,284,1694761200"; 
   d="scan'208";a="2462021"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2023 06:57:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10887"; a="739156162"
X-IronPort-AV: E=Sophos;i="6.03,284,1694761200"; 
   d="scan'208";a="739156162"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2023 06:57:32 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>,
	David Matlack <dmatlack@google.com>,
	Kai Huang <kai.huang@intel.com>,
	Zhi Wang <zhi.wang.linux@gmail.com>,
	chen.bo@intel.com,
	hang.yuan@intel.com,
	tina.zhang@intel.com
Subject: [PATCH v17 000/116] KVM TDX basic feature support
Date: Tue,  7 Nov 2023 06:55:26 -0800
Message-Id: <cover.1699368322.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

KVM TDX basic feature support

Hello.  This is v16 the patch series vof KVM TDX support.  This is based on
v6.7-rc + the following patch series + minor fixes.
The most changes are trivial and contained in VMX specific. The arguable changes
are to KVM TDP-MMU that requires more reviews.

Related patch series This patch is based on:
- v13 KVM: guest_memfd() and per-page attributes
  https://lore.kernel.org/all/20230914015531.1419405-1-seanjc@google.com/

- TDX host kernel support v14
  https://lore.kernel.org/all/cover.1697532085.git.kai.huang@intel.com/

The tree can be found at https://github.com/intel/tdx/tree/kvm-upstream
The corresponding qemu branch is found at
https://github.com/yamahata/qemu/tree/tdx/qemu-upm
How to run/test: It's describe at https://github.com/intel/tdx/wiki/TDX-KVM

More features tree is found at
https://github.com/intel/tdx/tree/kvm-upstream-next

Isaku Yamahata

Changes from v16:
- rebased v6.7-rc
- Switched to TDX module 1.5. Unsupport TDX module 1.0

Changes from v15:
- Added KVM_TDX_RELEASE_VM to reduce the destruction time
- Catch up the TDX module interface to use struct tdx_module_args
  instead of struct tdx_module_output
- Add tdh_mem_sept_rd() for SEPT_VE_DISABLE=1 and handle Secure-EPT violation
  with SEPT_VE_DISABLE case.
- Simplified tdx_reclaim_page()
- Reorganize the locking of tdx_release_hkid(), and use smp_call_mask()
  instead of smp_call_on_cpu() to hold spinlock to race with invalidation
  on releasing guest memfd
- Removed AMX check as the KVM upstream supports AMX.
- Added CET flag to guest supported xss
- add check if nr_pages isn't large with
  (nr_page << PAGE_SHIFT) >> PAGE_SHIFT
- use __seamcall_saved_ret()
- As struct tdx_module_args doesn't match with vcpu.arch.regs, copy regs
  before/after calling __seamcall_saved_ret().

Changes from v14:
https://lore.kernel.org/all/cover.1685333727.git.isaku.yamahata@intel.com/
- rebased to v6.5-rc2, v11 KVM guest_memfd(), v11 TDX host kernel support
- ABI change to add reserved member for future compatibility, dropped unused
  member.
- handle EXIT_REASON_OTHER_SMI
- handle FEAT_CTL MSR access

Changes from v13:
- rbased to v6.4-rc3
- Make use of KVM gmem.
- Added check_cpuid callback for KVM_SET_CPUID2 as RFC patch.
- ABI change of KVM_TDX_VM_INIT as VM scoped KVM ioctl.
- Make TDX initialization non-depend on kvm hardware_enable.
  Use vmx_hardware_enable directly.
- Drop a patch to prohibit dirty logging as new KVM gmem code base
- Drop parameter only checking for some TDG.VP.VMCALL. Just default part

Changes from v12:
- ABI change of KVM_TDX_VM_INIT
- Rename kvm_gfn_{private, shared} to kvm_gfn_to_{private, shared}
- Move APIC BASE MSI initialization to KVM_TDX_VCPU_INIT
- Fix MTRR patch
- Make MapGpa hypercall always pass it to user space VMM
- Split hooks to TDP MMU into two part. populating and zapping.

Changes from v11:
- ABI change of KVM_TDX_VM_INIT
- Split the hook of TDP MMU to not modify handle_changed_spte()
- Enhanced commit message on mtrr patch
- Made KVM_CAP_MAX_VCPUS to x86 specific

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

Chao Gao (2):
  KVM: x86/mmu: Assume guest MMIOs are shared
  KVM: x86: Allow to update cached values in kvm_user_return_msrs w/o
    wrmsr

Isaku Yamahata (93):
  KVM: x86/vmx: initialize loaded_vmcss_on_cpu in vmx_hardware_setup()
  KVM: x86/vmx: Refactor KVM VMX module init/exit functions
  KVM: VMX: Reorder vmx initialization with kvm vendor initialization
  KVM: TDX: Initialize the TDX module when loading the KVM intel kernel
    module
  KVM: TDX: Add placeholders for TDX VM/vcpu structure
  KVM: TDX: Make TDX VM type supported
  [MARKER] The start of TDX KVM patch series: TDX architectural
    definitions
  KVM: TDX: Define TDX architectural definitions
  KVM: TDX: Add C wrapper functions for SEAMCALLs to the TDX module
  KVM: TDX: Retry SEAMCALL on the lack of entropy error
  KVM: TDX: Add helper functions to print TDX SEAMCALL error
  [MARKER] The start of TDX KVM patch series: TD VM creation/destruction
  x86/cpu: Add helper functions to allocate/free TDX private host key id
  x86/virt/tdx: Add a helper function to return system wide info about
    TDX module
  KVM: TDX: Add place holder for TDX VM specific mem_enc_op ioctl
  KVM: x86, tdx: Make KVM_CAP_MAX_VCPUS backend specific
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
  KVM: x86/mmu: Add a new is_private member for union kvm_mmu_page_role
  KVM: x86/mmu: Add a private pointer to struct kvm_mmu_page
  KVM: x86/tdp_mmu: Sprinkle __must_check
  KVM: x86/tdp_mmu: Support TDX private mapping for TDP MMU
  [MARKER] The start of TDX KVM patch series: TDX EPT violation
  KVM: TDX: Add accessors VMX VMCS helpers
  KVM: TDX: Require TDP MMU and mmio caching for TDX
  KVM: TDX: TDP MMU TDX support
  KVM: TDX: MTRR: implement get_mt_mask() for TDX
  [MARKER] The start of TDX KVM patch series: TD finalization
  KVM: TDX: Create initial guest memory
  KVM: TDX: Finalize VM initialization
  [MARKER] The start of TDX KVM patch series: TD vcpu enter/exit
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
  KVM: TDX: Handle EXIT_REASON_OTHER_SMI with MSMI
  KVM: TDX: Add a place holder for handler of TDX hypercalls
    (TDG.VP.VMCALL)
  KVM: TDX: handle KVM hypercall with TDG.VP.VMCALL
  KVM: TDX: Add KVM Exit for TDX TDG.VP.VMCALL
  KVM: TDX: Handle TDX PV CPUID hypercall
  KVM: TDX: Handle TDX PV HLT hypercall
  KVM: TDX: Handle TDX PV port io hypercall
  KVM: TDX: Implement callbacks for MSR operations for TDX
  KVM: TDX: Handle TDX PV rdmsr/wrmsr hypercall
  KVM: TDX: Handle MSR MTRRCap and MTRRDefType access
  KVM: TDX: Handle MSR IA32_FEAT_CTL MSR and IA32_MCG_EXT_CTL
  KVM: TDX: Handle TDG.VP.VMCALL<GetTdVmCallInfo> hypercall
  KVM: TDX: Silently discard SMI request
  KVM: TDX: Silently ignore INIT/SIPI
  KVM: TDX: Add methods to ignore accesses to CPU state
  KVM: TDX: Add methods to ignore guest instruction emulation
  KVM: TDX: Add a method to ignore dirty logging
  KVM: TDX: Add methods to ignore VMX preemption timer
  KVM: TDX: Add methods to ignore accesses to TSC
  KVM: TDX: Ignore setting up mce
  KVM: TDX: Add a method to ignore for TDX to ignore hypercall patch
  KVM: TDX: Add methods to ignore virtual apic related operation
  KVM: TDX: Inhibit APICv for TDX guest
  Documentation/virt/kvm: Document on Trust Domain Extensions(TDX)
  KVM: x86: design documentation on TDX support of x86 KVM TDP MMU
  KVM: TDX: Add hint TDX ioctl to release Secure-EPT
  RFC: KVM: x86: Add x86 callback to check cpuid
  RFC: KVM: x86, TDX: Add check for KVM_SET_CPUID2
  [MARKER] the end of (the first phase of) TDX KVM patch series

Sean Christopherson (17):
  KVM: VMX: Move out vmx_x86_ops to 'main.c' to wrap VMX and TDX
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
  KVM: TDX: Add load_mmu_pgd method for TDX
  KVM: x86/mmu: Introduce kvm_mmu_map_tdp_page() for use by TDX
  KVM: TDX: Add support for find pending IRQ in a protected local APIC
  KVM: x86: Assume timer IRQ was injected if APIC state is proteced
  KVM: VMX: Modify NMI and INTR handlers to take intr_info as function
    argument
  KVM: VMX: Move NMI/exception handler to common helper
  KVM: x86: Split core of hypercall emulation to helper function
  KVM: TDX: Handle TDX PV MMIO hypercall

Yan Zhao (1):
  KVM: x86/mmu: TDX: Do not enable page track for TD guest

Yang Weijiang (1):
  KVM: TDX: Add TSX_CTRL msr into uret_msrs list

Yao Yuan (1):
  KVM: TDX: Handle vmentry failure for INTEL TD guest

Yuan Yao (1):
  KVM: TDX: Retry seamcall when TDX_OPERAND_BUSY with operand SEPT

 Documentation/virt/kvm/api.rst             |    9 +-
 Documentation/virt/kvm/index.rst           |    1 +
 Documentation/virt/kvm/x86/index.rst       |    2 +
 Documentation/virt/kvm/x86/intel-tdx.rst   |  362 +++
 Documentation/virt/kvm/x86/tdx-tdp-mmu.rst |  443 +++
 arch/x86/events/intel/ds.c                 |    1 +
 arch/x86/include/asm/asm-prototypes.h      |    1 +
 arch/x86/include/asm/kvm-x86-ops.h         |   17 +-
 arch/x86/include/asm/kvm_host.h            |   84 +-
 arch/x86/include/asm/tdx.h                 |   85 +
 arch/x86/include/asm/vmx.h                 |   14 +
 arch/x86/include/uapi/asm/kvm.h            |   89 +
 arch/x86/include/uapi/asm/vmx.h            |    5 +-
 arch/x86/kvm/Kconfig                       |    6 +
 arch/x86/kvm/Makefile                      |    3 +-
 arch/x86/kvm/cpuid.c                       |   27 +-
 arch/x86/kvm/cpuid.h                       |    2 +
 arch/x86/kvm/irq.c                         |    3 +
 arch/x86/kvm/lapic.c                       |   33 +-
 arch/x86/kvm/lapic.h                       |    2 +
 arch/x86/kvm/mmu.h                         |   31 +
 arch/x86/kvm/mmu/mmu.c                     |  200 +-
 arch/x86/kvm/mmu/mmu_internal.h            |  109 +-
 arch/x86/kvm/mmu/page_track.c              |    3 +
 arch/x86/kvm/mmu/paging_tmpl.h             |    2 +-
 arch/x86/kvm/mmu/spte.c                    |   17 +-
 arch/x86/kvm/mmu/spte.h                    |   27 +-
 arch/x86/kvm/mmu/tdp_iter.h                |   14 +-
 arch/x86/kvm/mmu/tdp_mmu.c                 |  421 ++-
 arch/x86/kvm/mmu/tdp_mmu.h                 |    7 +-
 arch/x86/kvm/smm.h                         |    7 +-
 arch/x86/kvm/svm/svm.c                     |    1 +
 arch/x86/kvm/vmx/common.h                  |  166 +
 arch/x86/kvm/vmx/main.c                    | 1239 ++++++++
 arch/x86/kvm/vmx/pmu_intel.c               |   46 +-
 arch/x86/kvm/vmx/pmu_intel.h               |   28 +
 arch/x86/kvm/vmx/posted_intr.c             |   43 +-
 arch/x86/kvm/vmx/posted_intr.h             |   13 +
 arch/x86/kvm/vmx/tdx.c                     | 3214 ++++++++++++++++++++
 arch/x86/kvm/vmx/tdx.h                     |  272 ++
 arch/x86/kvm/vmx/tdx_arch.h                |  221 ++
 arch/x86/kvm/vmx/tdx_errno.h               |   44 +
 arch/x86/kvm/vmx/tdx_error.c               |   20 +
 arch/x86/kvm/vmx/tdx_ops.h                 |  267 ++
 arch/x86/kvm/vmx/vmcs.h                    |    5 +
 arch/x86/kvm/vmx/vmx.c                     |  674 ++--
 arch/x86/kvm/vmx/vmx.h                     |   52 +-
 arch/x86/kvm/vmx/x86_ops.h                 |  257 ++
 arch/x86/kvm/x86.c                         |  117 +-
 arch/x86/kvm/x86.h                         |    2 +
 arch/x86/virt/vmx/tdx/seamcall.S           |    4 +
 arch/x86/virt/vmx/tdx/tdx.c                |   48 +-
 arch/x86/virt/vmx/tdx/tdx.h                |   51 -
 include/linux/kvm_host.h                   |    1 +
 include/linux/kvm_types.h                  |    1 +
 include/uapi/linux/kvm.h                   |   89 +
 tools/arch/x86/include/uapi/asm/kvm.h      |   96 +
 virt/kvm/kvm_main.c                        |   31 +-
 58 files changed, 8271 insertions(+), 758 deletions(-)
 create mode 100644 Documentation/virt/kvm/x86/intel-tdx.rst
 create mode 100644 Documentation/virt/kvm/x86/tdx-tdp-mmu.rst
 create mode 100644 arch/x86/kvm/vmx/common.h
 create mode 100644 arch/x86/kvm/vmx/main.c
 create mode 100644 arch/x86/kvm/vmx/pmu_intel.h
 create mode 100644 arch/x86/kvm/vmx/tdx.c
 create mode 100644 arch/x86/kvm/vmx/tdx.h
 create mode 100644 arch/x86/kvm/vmx/tdx_arch.h
 create mode 100644 arch/x86/kvm/vmx/tdx_errno.h
 create mode 100644 arch/x86/kvm/vmx/tdx_error.c
 create mode 100644 arch/x86/kvm/vmx/tdx_ops.h
 create mode 100644 arch/x86/kvm/vmx/x86_ops.h


base-commit: 45b890f7689eb0aba454fc5831d2d79763781677
prerequisite-patch-id: 3c646922da088ceebe447974a90217f377b76e4a
prerequisite-patch-id: 8f45b2dfcad5ad3ccde4273656b6b8b2b62e11b2
prerequisite-patch-id: 63a51964c8ba364d20abcbce8eb0d939c817ec01
prerequisite-patch-id: df2a5a0c60cdefdeb05bf2c63e8d4faa26d1ef31
prerequisite-patch-id: eede5382aa76c0602a853fc93a1450995c651345
prerequisite-patch-id: 5549aad02248eb5a0c2853058dc7c102044c7a9d
prerequisite-patch-id: ab6557f79edb77246ee1e9955be81a10841e65fd
prerequisite-patch-id: abb1d76aa2064918020d13fea2480afa330e0912
prerequisite-patch-id: 39535a98128343fd72a3b36fe1fccd6f5b76333a
prerequisite-patch-id: e1692d657690f974d836ba3efdd277ea82e675ca
prerequisite-patch-id: 747debe72334ef0cd12bbb42d1acb281eb59cd98
prerequisite-patch-id: 2d1df1bad8af51577ec15a37510ea8bf018b0d4f
prerequisite-patch-id: 1d81fc666ab2e02310c72ec10bc8f26e7d8d4741
prerequisite-patch-id: 9916b6553a61beb9a5435bc0b1fcacf0a87165ea
prerequisite-patch-id: 9f624e97056d5bea70b113dec519f63550b231ca
prerequisite-patch-id: 3f521305586c73ca1870d4de06120d3d1ed9f809
prerequisite-patch-id: a06dc931e52e733c4f898e2e84caa20b3222bcb0
prerequisite-patch-id: cafe1f6964532d261b950e1879e091dc8c0b4386
prerequisite-patch-id: be84a6107dea5db81672bd44503b1fe755a36b35
prerequisite-patch-id: 44509f563771211f6e4813540e3701d344c146f9
prerequisite-patch-id: 0e93d19cb59f3a052a377a56ff0a4399046818aa
prerequisite-patch-id: 5a08517c7b8dff35e0adbae366b9b3c91b4a9476
prerequisite-patch-id: 4cb325704c22c899be7c12c3f558a284d390849e
prerequisite-patch-id: 301dbdf8448175ea609664c890a3694750ecf740
prerequisite-patch-id: 8f67d4366ca5c9875c4ef7f445941e3ad3162c75
prerequisite-patch-id: 96318da5ef3baeed5bed1cddea80a94b34edee42
prerequisite-patch-id: ee7d6285e1f03f9bef0c14c622262aed28796036
prerequisite-patch-id: 8a2b4167ea632413ba8f6d39788ddf19eb928ab0
prerequisite-patch-id: 5618d2414a1ef641b4c247b5e28076f67a765b24
prerequisite-patch-id: 4415e2df6492fbb64746e3503deba6e991a0e08b
prerequisite-patch-id: 39d4092e51f17b0365bc9b1f808fba8a950640ae
prerequisite-patch-id: 95fac1bcad0d670dc9625df6b58e3f3ff246314d
prerequisite-patch-id: 4c0e6ab89b9a3ed3a2cb236e942b5842926bf868
prerequisite-patch-id: 371bdcffa52c4990978d5b7fa88b35637e307fad
prerequisite-patch-id: 53f3c227c59c1a9cd5886ba198a4c772d50bf80d
prerequisite-patch-id: 6a1256e8ae62a3464493f28d11020f755479ecc1
prerequisite-patch-id: 0c22a1b8ee1b6034d75dee7ba2acb8f85b07d7e9
prerequisite-patch-id: 806530c9e960c04af1f89772e3f979edab98a408
prerequisite-patch-id: b7ed5b025d879e45768e9aec3dd7155849107fc9
prerequisite-patch-id: dd9b8b1bccc91dbb763e73cedd3519ea425d35e9
prerequisite-patch-id: 780a296b04f5f6e1183b32fd818b68123ea90837
prerequisite-patch-id: 95113eb3c33808cf3c9ae9c25535e03301fbbcd7
prerequisite-patch-id: 47fcc823395eec1de79064e4c7979dc38cd981ac
prerequisite-patch-id: f6cf57a358d1c4f671e92db813078f6ed4f772ad
prerequisite-patch-id: ad05efeb6f1d255dd29c0097cea0d32618b0b2c5
prerequisite-patch-id: 47d7568b7cc0875aee1789ea2fce0f983184ca6f
prerequisite-patch-id: 94e4aaee87b6cd053a521bc286b53585436f7fad
prerequisite-patch-id: 2639688b9d64d085fb6e471ead698eed95aab6a0
prerequisite-patch-id: df629550e116efcb9d98b25206052b621442a864
prerequisite-patch-id: 07ea154d398c47c42bd2b14045af8d85b360430b
prerequisite-patch-id: 9bf1c597c4fb41b85cdc3e1a012888095a44ff61
prerequisite-patch-id: 3c93e412ef811eb92d0c9e7442108e57f4c0161d
prerequisite-patch-id: 8b181ba5e1411d7d750414dbdcd4bcbd9e476af9
prerequisite-patch-id: f6607474be3d5ab08757abdc84e67ecf2b085e33
prerequisite-patch-id: 6f30346769e6432a9f5bee3515810f553f6090d3
prerequisite-patch-id: ffa0856539a107cabb97c25c4c6fc9a2fc0ee331
prerequisite-patch-id: 87b32d037d75a95447f9697435e27e1dbda3dfb3
prerequisite-patch-id: b9bc2aa4866ce683eda84480e571eb0c948c839b
prerequisite-patch-id: 7236f20728fdb43c3ff2ddca00cc7f8054c31eb2
prerequisite-patch-id: 2d7d9e53916d8ae7098b81d16c37f8fa36d49ac0
prerequisite-patch-id: 990e43c351bf383be04aaca187fce4c6ceef5a45
prerequisite-patch-id: 9b86598398e80dcc894a3defaf56750e416e70c2
prerequisite-patch-id: 33263e8b7ce27fb753f3c36ab9861f88db37d56e
prerequisite-patch-id: 17300f4680c7d5ae3ca560aaa260223c81dd4376
prerequisite-patch-id: be8f066b9530a0e4c9e681a6227853801e610ddf
prerequisite-patch-id: 806b22d567c941d668b09660fa707453deb1af71
prerequisite-patch-id: 44ef835e2361519b11ee631b8b66e51b95cf2889
prerequisite-patch-id: 9e014e61e461fd71993a934c728b1af675209368
prerequisite-patch-id: 77675d43aa69f65a4d5464c20760430d142951f9
prerequisite-patch-id: 736d1f5418ec5064002e56f01646317df4ef7ae8
prerequisite-patch-id: 3cb1cb5fcd992b3efd56079606b959ce70c01e07
prerequisite-patch-id: 2617544260d28f793f7d1a132c9c0de45c93773f
prerequisite-patch-id: 79c36fb01e1ca2aba2d3b05eaa862603ba49b637
prerequisite-patch-id: 4c3e874f5a81d8faa87f1552c4f66c335e51b10b
prerequisite-patch-id: cb538a88ed4c5d7614d3e6fcd10b991cce605a0d
prerequisite-patch-id: 6019835e0581c2749e8e353f2045a2e94040a2b0
prerequisite-patch-id: 4dd00540050377ff852c0a939682d5894513444c
prerequisite-patch-id: ef4b52b28c7459a217b5fc4bd4dc592354fb9a46
-- 
2.25.1


