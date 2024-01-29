Return-Path: <kvm+bounces-7309-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 95FCA83FE41
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 07:23:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BA7C41C2257E
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 06:23:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BDA753801;
	Mon, 29 Jan 2024 06:21:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gk7OioEv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9958B524B4;
	Mon, 29 Jan 2024 06:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706509299; cv=none; b=khfCvvn71i0YsC2By6mZzRkXFjtx9DIvUT+bbY0qKMu8e55JTV3n0KWj7ZVaJf9WLp56bnXKjZlx2SC7XkNJygRn97EZRFG9XGSuDGMMinpmgG8iOMRN9iDgcIhw0vv/LR5rNkLOzm6u4u1eTQTIhGjyUpp/AjvVFflcPP8vBS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706509299; c=relaxed/simple;
	bh=P/g5ToRNtde2AasvtMG/KwsIp9y3mo4Va63d6/0WN+0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i4XyqDupS6Trq1ex7mZ6v9KHTRQdOR1yFxzK1Ig6AmfykWk0ueeJqIKwG8qMMZW6hgQXnWpd4aJZzXwo08i2fooghiKFqZswWSJLAVr3Z4L6BG9566vkjqyhbtN6mROOuyL6dGgU48jp39jRKtzyALWdQybhEd4Ry6v7z+H3kUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gk7OioEv; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706509296; x=1738045296;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=P/g5ToRNtde2AasvtMG/KwsIp9y3mo4Va63d6/0WN+0=;
  b=gk7OioEvkU8G2g5s64wrgrQRjYCIPH9ZfozA02lqL0mZRUbtr9tf9AdV
   L7OCzueDi9o2bzgU7myvQy/HnxaL/GOYuCJwEjn/HcltjWGrktvhjPfuT
   lQEFrdtgG5s4MmhwTBnLeROLyb5z2OSZgGpA5FkERkhApZYKOmL0vPQiL
   BB9qJxZh7hVaSX+EBv/O/WVBQf+uO1URlCpPhz9f0gLWVcTVpxtKqGkHI
   cjvS1OUVtiDOpni30j5T2jwCnr0+HDa81vKm+CtCSMB+5qqWyTf2GmB35
   QBtCATqjyNgxi0x7f0FwZOY7SmEy8vp6QnYec3ZlsNC7+U3z/I7Hm5O/8
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10967"; a="16219115"
X-IronPort-AV: E=Sophos;i="6.05,226,1701158400"; 
   d="scan'208";a="16219115"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2024 22:21:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,226,1701158400"; 
   d="scan'208";a="3270556"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by fmviesa003.fm.intel.com with ESMTP; 28 Jan 2024 22:21:33 -0800
Date: Mon, 29 Jan 2024 14:21:32 +0800
From: Yuan Yao <yuan.yao@linux.intel.com>
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com
Subject: Re: [PATCH v18 000/121] KVM TDX basic feature support
Message-ID: <20240129062132.mec3koljujmhvtoo@yy-desk-7060>
References: <cover.1705965634.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1705965634.git.isaku.yamahata@intel.com>
User-Agent: NeoMutt/20171215

On Mon, Jan 22, 2024 at 03:52:36PM -0800, isaku.yamahata@intel.com wrote:
...
> The below layers are chosen so that the device model, for example, qemu can
> exercise each layering step by step.  Check if TDX is supported, create TD VM,
> create TD vcpu, allow vcpu running, populate TD guest private memory, and handle
> vcpu exits/hypercalls/interrupts to run TD fully.
>
>   TDX vcpu
>   interrupt/exits/hypercall<------------\
>         ^                               |
>         |                               |
>   TD finalization                       |
>         ^                               |
>         |                               |
>   TDX EPT violation<------------\       |
>         ^                       |       |
>         |                       |       |
>   TD vcpu enter/exit            |       |
>         ^                       |       |
>         |                       |       |
>   TD vcpu creation/destruction  |       \-------KVM TDP MMU MapGPA
>         ^                       |                       ^
>         |                       |                       |
>   TD VM creation/destruction    \---------------KVM TDP MMU hooks
>         ^                                               ^
>         |                                               |
>   TDX architectural definitions                 KVM TDP refactoring for TDX
>         ^                                               ^
>         |                                               |
>    TDX, VMX    <--------TDX host kernel         KVM MMU GPA stolen bits
>    coexistence          support
>
>
> The followings are explanations of each layer.  Each layer has a dummy commit
> that starts with [MARKER] in subject.  It is intended to help to identify where
> each layer starts.
>
> TDX host kernel support:
>         https://lore.kernel.org/lkml/cover.1646007267.git.kai.huang@intel.com/
>         The guts of system-wide initialization of TDX module.  There is an
>         independent patch series for host x86.  TDX KVM patches call functions
>         this patch series provides to initialize the TDX module.
>
> TDX, VMX coexistence:
>         Infrastructure to allow TDX to coexist with VMX and trigger the
>         initialization of the TDX module.
>         This layer starts with
>         "KVM: VMX: Move out vmx_x86_ops to 'main.c' to wrap VMX and TDX"
> TDX architectural definitions:
>         Add TDX architectural definitions and helper functions
>         This layer starts with
>         "[MARKER] The start of TDX KVM patch series: TDX architectural definitions".
> TD VM creation/destruction:
>         Guest TD creation/destroy allocation and releasing of TDX specific vm
>         and vcpu structure.  Create an initial guest memory image with TDX
>         measurement.
>         This layer starts with
>         "[MARKER] The start of TDX KVM patch series: TD VM creation/destruction".
> TD vcpu creation/destruction:
>         guest TD creation/destroy Allocation and releasing of TDX specific vm
>         and vcpu structure.  Create an initial guest memory image with TDX
>         measurement.
>         This layer starts with
>         "[MARKER] The start of TDX KVM patch series: TD vcpu creation/destruction"
> TDX EPT violation:
>         Create an initial guest memory image with TDX measurement.  Handle
>         secure EPT violations to populate guest pages with TDX SEAMCALLs.
>         This layer starts with
>         "[MARKER] The start of TDX KVM patch series: TDX EPT violation"
> TD vcpu enter/exit:
>         Allow TDX vcpu to enter into TD and exit from TD.  Save CPU state before
>         entering into TD.  Restore CPU state after exiting from TD.
>         This layer starts with
>         "[MARKER] The start of TDX KVM patch series: TD vcpu enter/exit"
> TD vcpu interrupts/exit/hypercall:
>         Handle various exits/hypercalls and allow interrupts to be injected so
>         that TD vcpu can continue running.
>         This layer starts with
>         "[MARKER] The start of TDX KVM patch series: TD vcpu exits/interrupts/hypercalls"
>
> KVM MMU GPA shared bit:
>         Introduce framework to handle shared bit repurposed bit of GPA TDX
>         repurposed a bit of GPA to indicate shared or private. If it's shared,

How about:
Introduce framework to handle shared bit which is repurposed GPA bit to indicate
shared or private.

>         it's the same as the conventional VMX EPT case.  VMM can access shared
>         guest pages.  If it's private, it's handled by Secure-EPT and the guest
>         page is encrypted.
>         This layer starts with
>         "[MARKER] The start of TDX KVM patch series: KVM MMU GPA stolen bits"
> KVM TDP refactoring for TDX:
>         TDX Secure EPT requires different constants. e.g. initial value EPT
>         entry value etc. Various refactoring for those differences.
>         This layer starts with
>         "[MARKER] The start of TDX KVM patch series: KVM TDP refactoring for TDX"
> KVM TDP MMU hooks:
>         Introduce framework to TDP MMU to add hooks in addition to direct EPT
>         access TDX added Secure EPT which is an enhancement to VMX EPT.  Unlike
>         conventional VMX EPT, CPU can't directly read/write Secure EPT. Instead,
>         use TDX SEAMCALLs to operate on Secure EPT.
>         This layer starts with
>         "[MARKER] The start of TDX KVM patch series: KVM TDP MMU hooks"
...
> Several VMX control structures (such as Shared EPT and Posted interrupt
> descriptor) are directly managed and accessed by the host VMM.  These control
> structures are pointed to by fields in the TD VMCS.
>
> The above means that 1) KVM needs to allocate different data structures for TDs,
> 2) KVM can reuse the existing code for TDs for some operations, 3) it needs to
> define TD-specific handling for others.  3) Redirect operations to .  3)
                                           ^^^^^^^^^^^^^^^^^^^^^^^^^^^
unnecessary duplication.

> Redirect operations to the TDX specific callbacks, like "if (is_td_vcpu(vcpu))
> tdx_callback() else vmx_callback();".
>
> *TD Private Memory
> TD private memory is designed to hold TD private content, encrypted by the CPU
> using the TD ephemeral key. An encryption engine holds a table of encryption
> keys, and an encryption key is selected for each memory transaction based on a
> Host Key Identifier (HKID). By design, the host VMM does not have access to the
> encryption keys.
>
> In the first generation of MKTME, HKID is "stolen" from the physical address by
> allocating a configurable number of bits from the top of the physical
> address. The HKID space is partitioned into shared HKIDs for legacy MKTME
> accesses and private HKIDs for SEAM-mode-only accesses. We use 0 for the shared
> HKID on the host so that MKTME can be opaque or bypassed on the host.
>
> During TDX non-root operation (i.e. guest TD), memory accesses can be qualified
> as either shared or private, based on the value of a new SHARED bit in the Guest
> Physical Address (GPA).  The CPU translates shared GPAs using the usual VMX EPT
> (Extended Page Table) or "Shared EPT" (in this document), which resides in host
> VMM memory. The Shared EPT is directly managed by the host VMM - the same as
> with the current VMX. Since guest TDs usually require I/O, and the data exchange
> needs to be done via shared memory, thus KVM needs to use the current EPT
> functionality even for TDs.
>
> * Secure EPT and Minoring using the TDP code
> The CPU translates private GPAs using a separate Secure EPT.  The Secure EPT
> pages are encrypted and integrity-protected with the TD's ephemeral private
> key.  Secure EPT can be managed _indirectly_ by the host VMM, using the TDX
> interface functions, and thus conceptually Secure EPT is a subset of EPT (why
> "subset"). Since execution of such interface functions takes much longer time
> than accessing memory directly, in KVM we use the existing TDP code to minor the
> Secure EPT for the TD.
>
> This way, we can effectively walk Secure EPT without using the TDX interface
> functions.
>
> * VM life cycle and TDX specific operations
> The userspace VMM, such as QEMU, needs to build and treat TDs differently.  For
> example, a TD needs to boot in private memory, and the host software cannot copy
> the initial image to private memory.
>
> * TSC Virtualization
> The TDX module helps TDs maintain reliable TSC (Time Stamp Counter) values
> (e.g. consistent among the TD VCPUs) and the virtual TSC frequency is determined
> by TD configuration, i.e. when the TD is created, not per VCPU.  The current KVM
> owns TSC virtualization for VMs, but the TDX module does for TDs.
>
> * MCE support for TDs
> The TDX module doesn't allow VMM to inject MCE.  Instead PV way is needed for TD
> to communicate with VMM.  For now, KVM silently ignores MCE request by VMM.  MSRs
> related to MCE (e.g, MCE bank registers) can be naturally emulated by
> paravirtualizing MSR access.
>
> [1] For details, the specifications, [2], [3], [4], [5], [6], [7], are
> available.
>
> * Restrictions or future work
> Some features are not included to reduce patch size.  Those features are
> addressed as future independent patch series.
> - large page (2M, 1G)
> - qemu gdb stub
> - guest PMU
> - and more
>
> * Prerequisites
> It's required to load the TDX module and initialize it.  It's out of the scope
> of this patch series.  Another independent patch for the common x86 code is
> planned.  It defines CONFIG_INTEL_TDX_HOST and this patch series uses
> CONFIG_INTEL_TDX_HOST.  It's assumed that With CONFIG_INTEL_TDX_HOST=y, the TDX
> module is initialized and ready for KVM to use the TDX module APIs for TDX guest
> life cycle like tdh.mng.init are ready to use.
>
> Concretely Global initialization, LP (Logical Processor) initialization, global
> configuration, the key configuration, and TDMR and PAMT initialization are done.
> The state of the TDX module is SYS_READY.  Please refer to the TDX module
> specification, the chapter Intel TDX Module Lifecycle State Machine
>
> ** Detecting the TDX module readiness.
> TDX host patch series implements the detection of the TDX module availability
> and its initialization so that KVM can use it.  Also it manages Host KeyID
> (HKID) assigned to guest TD.
> The assumed APIs the TDX host patch series provides are
> - const struct tdsysinfo_struct *tdx_get_sysinfo(void);
>   Return the system wide information about the TDX module.  NULL if the TDX
>   isn't initialized.
> - int tdx_enable(void);
>   Initialization of TDX module so that the TDX module is ready for KVM to use.
> - extern u32 tdx_global_keyid __read_mostly;
>   global host key id that is used for the TDX module itself.
> - u32 tdx_get_num_keyid(void);
>   return the number of available TDX private host key id.
> - int tdx_keyid_alloc(void);
>   Allocate HKID for guest TD.
> - void tdx_keyid_free(int keyid);
>   Free HKID for guest TD.
>
> (****)
> * TDX KVM high-level design
> - Host key ID management
> Host Key ID (HKID) needs to be assigned to each TDX guest for memory encryption.
> It is assumed The TDX host patch series implements necessary functions,
> u32 tdx_get_global_keyid(void), int tdx_keyid_alloc(void) and,
> void tdx_keyid_free(int keyid).
>
> - Data structures and VM type
> Because TDX is different from VMX, define its own VM/VCPU structures, struct
> kvm_tdx and struct vcpu_tdx instead of struct kvm_vmx and struct vcpu_vmx.  To
> identify the VM, introduce VM-type to specify which VM type, VMX (default) or
> TDX, is used.
>
> - VM life cycle and TDX specific operations
> Re-purpose the existing KVM_MEMORY_ENCRYPT_OP to add TDX specific operations.
> New commands are used to get the TDX system parameters, set TDX specific VM/VCPU
> parameters, set initial guest memory and measurement.
>
> The creation of TDX VM requires five additional operations in addition to the
> conventional VM creation.
>   - Get KVM system capability to check if TDX VM type is supported
>   - VM creation (KVM_CREATE_VM)
>   - New: Get the TDX specific system parameters.  KVM_TDX_GET_CAPABILITY.
>   - New: Set TDX specific VM parameters.  KVM_TDX_INIT_VM.
>   - VCPU creation (KVM_CREATE_VCPU)
>   - New: Set TDX specific VCPU parameters.  KVM_TDX_INIT_VCPU.
>   - New: Initialize guest memory as boot state and extend the measurement with
>     the memory.  KVM_TDX_INIT_MEM_REGION.
>   - New: Finalize VM. KVM_TDX_FINALIZE. Complete measurement of the initial
>     TDX VM contents.
>   - VCPU RUN (KVM_VCPU_RUN)
>
> - Protected guest state
> Because the guest state (CPU state and guest memory) is protected, the KVM VMM
> can't operate on them.  For example, accessing CPU registers, injecting
> exceptions, and accessing guest memory.  Those operations are handled as
> silently ignored, returning zero or initial reset value when it's requested via
> KVM API ioctls.
>
>     VM/VCPU state and callbacks for TDX specific operations.
>     Define tdx specific VM state and VCPU state instead of VMX ones.  Redirect
>     operations to TDX specific callbacks.  "if (tdx) tdx_op() else vmx_op()".
>
>     Operations on the CPU state
>     silently ignore operations on the guest state.  For example, the write to
>     CPU registers is ignored and the read from CPU registers returns 0.
>
>     . ignore access to CPU registers except for allowed ones.
>     . TSC: add a check if tsc is immutable and return an error.  Because the KVM
>       implementation updates the internal tsc state and it's difficult to back
>       out those changes.  Instead, skip the logic.
>     . dirty logging: add check if dirty logging is supported.
>     . exceptions/SMI/MCE/SIPI/INIT: silently ignore
>
>     Note: virtual external interrupt and NMI can be injected into TDX guests.
>
> - KVM MMU integration
> One bit of the guest physical address (bit 51 or 47) is repurposed to indicate if
> the guest physical address is private (the bit is cleared) or shared (the bit is
> set).  The bits are called stolen bits.
>
>   - Stolen bits framework
>     systematically tracks which guest physical address, shared or private, is
>     used.
>
>   - Shared EPT and secure EPT
>     There are two EPTs. Shared EPT (the conventional one) and Secure
>     EPT(the new one). Shared EPT is handled the same for the stolen
>     bit set.  Secure EPT points to private guest pages.  To resolve
>     EPT violation, KVM walks one of two EPTs based on faulted GPA.
>     Because it's costly to access secure EPT during walking EPTs with
>     SEAMCALLs for the private guest physical address, another private
>     EPT is used as a shadow of Secure-EPT with the existing logic at
>     the cost of extra memory.
>
> The following depicts the relationship.
>
>                     KVM                             |       TDX module
>                      |                              |           |
>         -------------+----------                    |           |
>         |                      |                    |           |
>         V                      V                    |           |
>      shared GPA           private GPA               |           |
>   CPU shared EPT pointer  KVM private EPT pointer   |  CPU secure EPT pointer
>         |                      |                    |           |
>         |                      |                    |           |
>         V                      V                    |           V
>   shared EPT                private EPT--------mirror----->Secure EPT
>         |                      |                    |           |
>         |                      \--------------------+------\    |
>         |                                           |      |    |
>         V                                           |      V    V
>   shared guest page                                 |    private guest page
>                                                     |
>                                                     |
>                               non-encrypted memory  |    encrypted memory
>                                                     |
>
>   - Operating on Secure EPT
>     Use the TDX module APIs to operate on Secure EPT.  To call the TDX API
>     during resolving EPT violation, add hooks to additional operation and wiring
>     it to TDX backend.
>
> * References
>
> [1] TDX specification
>    https://www.intel.com/content/www/us/en/developer/articles/technical/intel-trust-domain-extensions.html
> [2] Intel Trust Domain Extensions (Intel TDX)
>    https://cdrdv2.intel.com/v1/dl/getContent/726790
> [3] Intel CPU Architectural Extensions Specification
>    https://www.intel.com/content/dam/develop/external/us/en/documents-tps/intel-tdx-cpu-architectural-specification.pdf
> [4] Intel TDX Module 1.0 Specification
>    https://www.intel.com/content/dam/develop/external/us/en/documents/tdx-module-1.0-public-spec-v0.931.pdf
> [5] Intel TDX Loader Interface Specification
>   https://www.intel.com/content/dam/develop/external/us/en/documents-tps/intel-tdx-seamldr-interface-specification.pdf
> [6] Intel TDX Guest-Hypervisor Communication Interface
>    https://cdrdv2.intel.com/v1/dl/getContent/726790
> [7] Intel TDX Virtual Firmware Design Guide
>    https://www.intel.com/content/dam/develop/external/us/en/documents/tdx-virtual-firmware-design-guide-rev-1.01.pdf
> [8] intel public github
>    kvm TDX branch: https://github.com/intel/tdx/tree/kvm
>    TDX guest branch: https://github.com/intel/tdx/tree/guest
>    qemu TDX https://github.com/intel/qemu-tdx
> [9] TDVF
>     https://github.com/tianocore/edk2-staging/tree/TDVF
>     This was merged into EDK2 main branch. https://github.com/tianocore/edk2
>
> Chao Gao (2):
>   KVM: x86/mmu: Assume guest MMIOs are shared
>   KVM: x86: Allow to update cached values in kvm_user_return_msrs w/o
>     wrmsr
>
> Isaku Yamahata (96):
>   KVM: x86: Add is_vm_type_supported callback
>   KVM: x86/vmx: initialize loaded_vmcss_on_cpu in vmx_hardware_setup()
>   KVM: x86/vmx: Refactor KVM VMX module init/exit functions
>   KVM: VMX: Reorder vmx initialization with kvm vendor initialization
>   KVM: TDX: Initialize the TDX module when loading the KVM intel kernel
>     module
>   KVM: TDX: Add placeholders for TDX VM/vcpu structure
>   KVM: TDX: Make TDX VM type supported
>   [MARKER] The start of TDX KVM patch series: TDX architectural
>     definitions
>   KVM: TDX: Define TDX architectural definitions
>   KVM: TDX: Add C wrapper functions for SEAMCALLs to the TDX module
>   KVM: TDX: Retry SEAMCALL on the lack of entropy error
>   KVM: TDX: Add helper functions to print TDX SEAMCALL error
>   [MARKER] The start of TDX KVM patch series: TD VM creation/destruction
>   KVM: TDX: Add helper functions to allocate/free TDX private host key
>     id
>   KVM: TDX: Add helper function to read TDX metadata in array
>   x86/virt/tdx: Get system-wide info about TDX module on initialization
>   KVM: TDX: Add place holder for TDX VM specific mem_enc_op ioctl
>   KVM: TDX: Make KVM_CAP_MAX_VCPUS backend specific
>   KVM: TDX: create/destroy VM structure
>   KVM: TDX: initialize VM with TDX specific parameters
>   KVM: TDX: Make pmu_intel.c ignore guest TD case
>   KVM: TDX: Refuse to unplug the last cpu on the package
>   [MARKER] The start of TDX KVM patch series: TD vcpu
>     creation/destruction
>   KVM: TDX: create/free TDX vcpu structure
>   KVM: TDX: Do TDX specific vcpu initialization
>   [MARKER] The start of TDX KVM patch series: KVM MMU GPA shared bits
>   KVM: x86/mmu: introduce config for PRIVATE KVM MMU
>   KVM: x86/mmu: Add address conversion functions for TDX shared bit of
>     GPA
>   [MARKER] The start of TDX KVM patch series: KVM TDP refactoring for
>     TDX
>   KVM: x86/mmu: Replace hardcoded value 0 for the initial value for SPTE
>   KVM: x86/mmu: Add Suppress VE bit to
>     shadow_mmio_mask/shadow_present_mask
>   KVM: x86/mmu: Track shadow MMIO value on a per-VM basis
>   KVM: x86/mmu: Disallow fast page fault on private GPA
>   KVM: VMX: Introduce test mode related to EPT violation VE
>   [MARKER] The start of TDX KVM patch series: KVM TDP MMU hooks
>   KVM: x86/tdp_mmu: Init role member of struct kvm_mmu_page at
>     allocation
>   KVM: x86/mmu: Add a new is_private member for union kvm_mmu_page_role
>   KVM: x86/mmu: Add a private pointer to struct kvm_mmu_page
>   KVM: x86/tdp_mmu: Apply mmu notifier callback to only shared GPA
>   KVM: x86/tdp_mmu: Sprinkle __must_check
>   KVM: x86/tdp_mmu: Support TDX private mapping for TDP MMU
>   [MARKER] The start of TDX KVM patch series: TDX EPT violation
>   KVM: TDX: Add accessors VMX VMCS helpers
>   KVM: TDX: Require TDP MMU and mmio caching for TDX
>   KVM: TDX: TDP MMU TDX support
>   KVM: TDX: MTRR: implement get_mt_mask() for TDX
>   [MARKER] The start of TDX KVM patch series: TD finalization
>   KVM: TDX: Create initial guest memory
>   KVM: TDX: Finalize VM initialization
>   [MARKER] The start of TDX KVM patch series: TD vcpu enter/exit
>   KVM: TDX: Implement TDX vcpu enter/exit path
>   KVM: TDX: vcpu_run: save/restore host state(host kernel gs)
>   KVM: TDX: restore host xsave state when exit from the guest TD
>   KVM: TDX: restore user ret MSRs
>   [MARKER] The start of TDX KVM patch series: TD vcpu
>     exits/interrupts/hypercalls
>   KVM: TDX: complete interrupts after tdexit
>   KVM: TDX: restore debug store when TD exit
>   KVM: TDX: handle vcpu migration over logical processor
>   KVM: x86: Add a switch_db_regs flag to handle TDX's auto-switched
>     behavior
>   KVM: TDX: remove use of struct vcpu_vmx from posted_interrupt.c
>   KVM: TDX: Implement interrupt injection
>   KVM: TDX: Implements vcpu request_immediate_exit
>   KVM: TDX: Implement methods to inject NMI
>   KVM: TDX: Add a place holder to handle TDX VM exit
>   KVM: TDX: handle EXIT_REASON_OTHER_SMI
>   KVM: TDX: handle ept violation/misconfig exit
>   KVM: TDX: handle EXCEPTION_NMI and EXTERNAL_INTERRUPT
>   KVM: TDX: Handle EXIT_REASON_OTHER_SMI with MSMI
>   KVM: TDX: Add a place holder for handler of TDX hypercalls
>     (TDG.VP.VMCALL)
>   KVM: TDX: handle KVM hypercall with TDG.VP.VMCALL
>   KVM: TDX: Add KVM Exit for TDX TDG.VP.VMCALL
>   KVM: TDX: Handle TDX PV CPUID hypercall
>   KVM: TDX: Handle TDX PV HLT hypercall
>   KVM: TDX: Handle TDX PV port io hypercall
>   KVM: TDX: Implement callbacks for MSR operations for TDX
>   KVM: TDX: Handle TDX PV rdmsr/wrmsr hypercall
>   KVM: TDX: Handle MSR MTRRCap and MTRRDefType access
>   KVM: TDX: Handle MSR IA32_FEAT_CTL MSR and IA32_MCG_EXT_CTL
>   KVM: TDX: Handle TDG.VP.VMCALL<GetTdVmCallInfo> hypercall
>   KVM: TDX: Silently discard SMI request
>   KVM: TDX: Silently ignore INIT/SIPI
>   KVM: TDX: Add methods to ignore accesses to CPU state
>   KVM: TDX: Add methods to ignore guest instruction emulation
>   KVM: TDX: Add a method to ignore dirty logging
>   KVM: TDX: Add methods to ignore VMX preemption timer
>   KVM: TDX: Add methods to ignore accesses to TSC
>   KVM: TDX: Ignore setting up mce
>   KVM: TDX: Add a method to ignore for TDX to ignore hypercall patch
>   KVM: TDX: Add methods to ignore virtual apic related operation
>   KVM: TDX: Inhibit APICv for TDX guest
>   Documentation/virt/kvm: Document on Trust Domain Extensions(TDX)
>   KVM: x86: design documentation on TDX support of x86 KVM TDP MMU
>   KVM: TDX: Add hint TDX ioctl to release Secure-EPT
>   RFC: KVM: x86: Add x86 callback to check cpuid
>   RFC: KVM: x86, TDX: Add check for KVM_SET_CPUID2
>   [MARKER] the end of (the first phase of) TDX KVM patch series
>
> Kai Huang (2):
>   x86/virt/tdx: Export TDX KeyID information
>   x86/virt/tdx: Export SEAMCALL functions
>
> Sean Christopherson (17):
>   KVM: VMX: Move out vmx_x86_ops to 'main.c' to wrap VMX and TDX
>   KVM: TDX: Add TDX "architectural" error codes
>   KVM: TDX: x86: Add ioctl to get TDX systemwide parameters
>   KVM: Allow page-sized MMU caches to be initialized with custom 64-bit
>     values
>   KVM: x86/mmu: Allow non-zero value for non-present SPTE and removed
>     SPTE
>   KVM: x86/mmu: Allow per-VM override of the TDP max page level
>   KVM: x86/tdp_mmu: Don't zap private pages for unsupported cases
>   KVM: VMX: Split out guts of EPT violation to common/exposed function
>   KVM: VMX: Move setting of EPT MMU masks to common VT-x code
>   KVM: TDX: Add load_mmu_pgd method for TDX
>   KVM: x86/mmu: Introduce kvm_mmu_map_tdp_page() for use by TDX
>   KVM: TDX: Add support for find pending IRQ in a protected local APIC
>   KVM: x86: Assume timer IRQ was injected if APIC state is proteced
>   KVM: VMX: Modify NMI and INTR handlers to take intr_info as function
>     argument
>   KVM: VMX: Move NMI/exception handler to common helper
>   KVM: x86: Split core of hypercall emulation to helper function
>   KVM: TDX: Handle TDX PV MMIO hypercall
>
> Yan Zhao (1):
>   KVM: x86/mmu: TDX: Do not enable page track for TD guest
>
> Yang Weijiang (1):
>   KVM: TDX: Add TSX_CTRL msr into uret_msrs list
>
> Yao Yuan (1):
>   KVM: TDX: Handle vmentry failure for INTEL TD guest
>
> Yuan Yao (1):
>   KVM: TDX: Retry seamcall when TDX_OPERAND_BUSY with operand SEPT
>
>  Documentation/virt/kvm/api.rst             |    9 +-
>  Documentation/virt/kvm/index.rst           |    1 +
>  Documentation/virt/kvm/x86/index.rst       |    2 +
>  Documentation/virt/kvm/x86/intel-tdx.rst   |  362 +++
>  Documentation/virt/kvm/x86/tdx-tdp-mmu.rst |  443 +++
>  arch/x86/events/intel/ds.c                 |    1 +
>  arch/x86/include/asm/asm-prototypes.h      |    1 +
>  arch/x86/include/asm/kvm-x86-ops.h         |   18 +-
>  arch/x86/include/asm/kvm_host.h            |   85 +-
>  arch/x86/include/asm/tdx.h                 |    5 +
>  arch/x86/include/asm/vmx.h                 |   14 +
>  arch/x86/include/uapi/asm/kvm.h            |   95 +
>  arch/x86/include/uapi/asm/vmx.h            |    5 +-
>  arch/x86/kvm/Kconfig                       |    7 +-
>  arch/x86/kvm/Makefile                      |    3 +-
>  arch/x86/kvm/cpuid.c                       |   27 +-
>  arch/x86/kvm/cpuid.h                       |    2 +
>  arch/x86/kvm/irq.c                         |    3 +
>  arch/x86/kvm/lapic.c                       |   33 +-
>  arch/x86/kvm/lapic.h                       |    2 +
>  arch/x86/kvm/mmu.h                         |   31 +
>  arch/x86/kvm/mmu/mmu.c                     |  200 +-
>  arch/x86/kvm/mmu/mmu_internal.h            |  109 +-
>  arch/x86/kvm/mmu/page_track.c              |    3 +
>  arch/x86/kvm/mmu/paging_tmpl.h             |    2 +-
>  arch/x86/kvm/mmu/spte.c                    |   17 +-
>  arch/x86/kvm/mmu/spte.h                    |   27 +-
>  arch/x86/kvm/mmu/tdp_iter.h                |   14 +-
>  arch/x86/kvm/mmu/tdp_mmu.c                 |  442 ++-
>  arch/x86/kvm/mmu/tdp_mmu.h                 |    7 +-
>  arch/x86/kvm/smm.h                         |    7 +-
>  arch/x86/kvm/svm/svm.c                     |    8 +
>  arch/x86/kvm/vmx/common.h                  |  166 +
>  arch/x86/kvm/vmx/main.c                    | 1246 ++++++++
>  arch/x86/kvm/vmx/pmu_intel.c               |   46 +-
>  arch/x86/kvm/vmx/pmu_intel.h               |   28 +
>  arch/x86/kvm/vmx/posted_intr.c             |   43 +-
>  arch/x86/kvm/vmx/posted_intr.h             |   13 +
>  arch/x86/kvm/vmx/tdx.c                     | 3321 ++++++++++++++++++++
>  arch/x86/kvm/vmx/tdx.h                     |  266 ++
>  arch/x86/kvm/vmx/tdx_arch.h                |  277 ++
>  arch/x86/kvm/vmx/tdx_errno.h               |   44 +
>  arch/x86/kvm/vmx/tdx_error.c               |   21 +
>  arch/x86/kvm/vmx/tdx_ops.h                 |  408 +++
>  arch/x86/kvm/vmx/vmcs.h                    |    5 +
>  arch/x86/kvm/vmx/vmx.c                     |  661 ++--
>  arch/x86/kvm/vmx/vmx.h                     |   52 +-
>  arch/x86/kvm/vmx/x86_ops.h                 |  257 ++
>  arch/x86/kvm/x86.c                         |  129 +-
>  arch/x86/kvm/x86.h                         |    4 +
>  arch/x86/virt/vmx/tdx/seamcall.S           |    4 +
>  arch/x86/virt/vmx/tdx/tdx.c                |   11 +-
>  include/linux/kvm_host.h                   |    1 +
>  include/linux/kvm_types.h                  |    1 +
>  include/uapi/linux/kvm.h                   |   89 +
>  virt/kvm/kvm_main.c                        |   31 +-
>  56 files changed, 8407 insertions(+), 702 deletions(-)
>  create mode 100644 Documentation/virt/kvm/x86/intel-tdx.rst
>  create mode 100644 Documentation/virt/kvm/x86/tdx-tdp-mmu.rst
>  create mode 100644 arch/x86/kvm/vmx/common.h
>  create mode 100644 arch/x86/kvm/vmx/main.c
>  create mode 100644 arch/x86/kvm/vmx/pmu_intel.h
>  create mode 100644 arch/x86/kvm/vmx/tdx.c
>  create mode 100644 arch/x86/kvm/vmx/tdx.h
>  create mode 100644 arch/x86/kvm/vmx/tdx_arch.h
>  create mode 100644 arch/x86/kvm/vmx/tdx_errno.h
>  create mode 100644 arch/x86/kvm/vmx/tdx_error.c
>  create mode 100644 arch/x86/kvm/vmx/tdx_ops.h
>  create mode 100644 arch/x86/kvm/vmx/x86_ops.h
>
>
> base-commit: 6613476e225e090cc9aad49be7fa504e290dd33d
> prerequisite-patch-id: 5e29e9200c65fb7f6213b4aa85254f128a4fc49f
> prerequisite-patch-id: 39908082e873a3828568cc6c626e734d4ccb279a
> prerequisite-patch-id: 01d54029211a041370ee12d58825c42f2255d3f8
> prerequisite-patch-id: ec2e5dc132d37f2ec76f56172fe82e0f30998a50
> prerequisite-patch-id: b9438c767dbd45f4dda5287e104a54fe8f3c516f
> prerequisite-patch-id: ef4b52b28c7459a217b5fc4bd4dc592354fb9a46
> prerequisite-patch-id: bc425a71343a9fed0ad12e5b85a1c614f8eff934
> prerequisite-patch-id: cb538a88ed4c5d7614d3e6fcd10b991cce605a0d
> prerequisite-patch-id: 6019835e0581c2749e8e353f2045a2e94040a2b0
> prerequisite-patch-id: 4dd00540050377ff852c0a939682d5894513444c
> --
> 2.25.1
>
>

