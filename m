Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56A6E19C9F5
	for <lists+kvm@lfdr.de>; Thu,  2 Apr 2020 21:23:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389545AbgDBTWx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Apr 2020 15:22:53 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:35109 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732625AbgDBTWw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 2 Apr 2020 15:22:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585855370;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=CLaaw6+ypLLm/7dGSCfSI7HNdCZAcAh305PJOampzpU=;
        b=ax7LSayGM7UNMbi+XE4KXoiLrHw6i+u8SbFX6v1ff7EtLEJxjOhSWuFbniGCuKV9BcSxA7
        /T9Py21q46blDcnk7ctSIQzq1XsfbGB/ipMZu6+izCOXFA0qWrTpZe6LDiTu88QlZb6GJq
        aklDqGp8e5Y1fa/9rh5OeS2ivAWRu/k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-431-eKbMH5DuPqKqCpbcmh4HkA-1; Thu, 02 Apr 2020 15:22:46 -0400
X-MC-Unique: eKbMH5DuPqKqCpbcmh4HkA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 20032100550D;
        Thu,  2 Apr 2020 19:22:45 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 57C7C60BF3;
        Thu,  2 Apr 2020 19:22:44 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] First batch of KVM changes for Linux 5.7
Date:   Thu,  2 Apr 2020 15:22:43 -0400
Message-Id: <20200402192243.7186-1-pbonzini@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit 009384b38034111bf2c0c7bfb2740f5bd45c176c:

  irqchip/gic-v4.1: Eagerly vmap vPEs (2020-03-24 12:15:51 +0000)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 514ccc194971d0649e4e7ec8a9b3a6e33561d7bf:

  x86/kvm: fix a missing-prototypes "vmread_error" (2020-04-02 15:17:45 -0400)

----------------------------------------------------------------
ARM:
* GICv4.1 support
* 32bit host removal

PPC:
* secure (encrypted) using under the Protected Execution Framework
ultravisor

s390:
* allow disabling GISA (hardware interrupt injection) and protected
VMs/ultravisor support.

x86:
* New dirty bitmap flag that sets all bits in the bitmap when dirty
page logging is enabled; this is faster because it doesn't require bulk
modification of the page tables.
* Initial work on making nested SVM event injection more similar to VMX,
and less buggy.
* Various cleanups to MMU code (though the big ones and related
optimizations were delayed to 5.8).  Instead of using cr3 in function
names which occasionally means eptp, KVM too has standardized on "pgd".
* A large refactoring of CPUID features, which now use an array that
parallels the core x86_features.
* Some removal of pointer chasing from kvm_x86_ops, which will also be
switched to static calls as soon as they are available.
* New Tigerlake CPUID features.
* More bugfixes, optimizations and cleanups.

Generic:
* selftests: cleanups, new MMU notifier stress test, steal-time test
* CSV output for kvm_stat.

KVM/MIPS has been broken since 5.5, it does not compile due to a patch committed
by MIPS maintainers.  I had already prepared a fix, but the MIPS maintainers
prefer to fix it in generic code rather than KVM so they are taking care of it.

----------------------------------------------------------------

The branch shows up as based on a random commit because of an ARM topic branch
that you have already merged.  Most of it was developed as usual in the past couple of
months---no rebases or back merges here.

However, I also had 4 more patches to split a large file, but git hates
resolving that merge ("-X histogram" or "-X patience" make things a
little better, but not something that you shoud care about).  I will
rebase those, retest, and send them separately.

Thanks,

Paolo

Andrew Jones (17):
      KVM: selftests: aarch64: Use stream when given
      KVM: selftests: Remove unnecessary defines
      KVM: selftests: aarch64: Remove unnecessary ifdefs
      KVM: selftests: Rename vm_guest_mode_params
      KVM: selftests: Introduce vm_guest_mode_params
      KVM: selftests: Introduce num-pages conversion utilities
      KVM: selftests: Rework debug message printing
      KVM: selftests: Convert some printf's to pr_info's
      KVM: selftests: Fix unknown ucall command asserts
      KVM: selftests: s390x: Provide additional num-guest-pages adjustment
      selftests: KVM: SVM: Add vmcall test to gitignore
      KVM: selftests: Share common API documentation
      KVM: selftests: Enable printf format warnings for TEST_ASSERT
      KVM: selftests: Use consistent message for test skipping
      KVM: selftests: virt_map should take npages, not size
      KVM: selftests: Introduce steal-time test
      KVM: selftests: Rework timespec functions and usage

Ben Gardon (8):
      KVM: selftests: Create a demand paging test
      KVM: selftests: Add demand paging content to the demand paging test
      KVM: selftests: Add configurable demand paging delay
      KVM: selftests: Add memory size parameter to the demand paging test
      KVM: selftests: Pass args to vCPU in global vCPU args struct
      KVM: selftests: Add support for vcpu_args_set to aarch64 and s390x
      KVM: selftests: Support multiple vCPUs in demand paging test
      KVM: selftests: Time guest demand paging

Chia-I Wu (1):
      KVM: vmx: rewrite the comment in vmx_get_mt_mask

Christian Borntraeger (12):
      Merge branch 'pvbase' of git://git.kernel.org/.../kvms390/linux into HEAD
      KVM: s390/mm: Make pages accessible before destroying the guest
      KVM: s390: protvirt: Add SCLP interrupt handling
      KVM: s390: protvirt: do not inject interrupts after start
      KVM: s390: protvirt: introduce and enable KVM_CAP_S390_PROTECTED
      selftests: KVM: s390: fixup fprintf format error in reset.c
      selftests: KVM: s390: fix format strings for access reg test
      selftests: KVM: s390: fix early guest crash
      selftests: KVM: s390: test more register variants for the reset ioctl
      selftests: KVM: s390: check for registers to NOT change on reset
      KVM: s390: mark sie block as 512 byte aligned
      s390/gmap: return proper error code on ksm unsharing

Claudio Imbrenda (2):
      s390/mm: provide memory management functions for protected KVM guests
      KVM: s390/mm: handle guest unpin events

Eric Hankland (1):
      KVM: x86: Adjust counter sample period after a wrmsr

Fabiano Rosas (1):
      KVM: PPC: Book3S HV: Skip kvmppc_uvmem_free if Ultravisor is not supported

Greg Kurz (3):
      KVM: PPC: Book3S PR: Fix kernel crash with PR KVM
      KVM: PPC: Book3S PR: Move kvmppc_mmu_init() into PR KVM
      KVM: PPC: Kill kvmppc_ops::mmu_destroy() and kvmppc_mmu_destroy()

Gustavo Romero (1):
      KVM: PPC: Book3S HV: Treat TM-related invalid form instructions on P9 like the valid ones

Jan Kiszka (1):
      KVM: x86: Trace the original requested CPUID function in kvm_cpuid()

Janosch Frank (24):
      s390/protvirt: Add sysfs firmware interface for Ultravisor information
      KVM: s390: protvirt: Add UV debug trace
      KVM: s390: add new variants of UV CALL
      KVM: s390: protvirt: Add initial vm and cpu lifecycle handling
      KVM: s390: protvirt: Secure memory is not mergeable
      KVM: s390: protvirt: Handle SE notification interceptions
      KVM: s390: protvirt: Instruction emulation
      KVM: s390: protvirt: Handle spec exception loops
      KVM: s390: protvirt: Add new gprs location handling
      KVM: S390: protvirt: Introduce instruction data area bounce buffer
      KVM: s390: protvirt: handle secure guest prefix pages
      KVM: s390: protvirt: Write sthyi data to instruction data area
      KVM: s390: protvirt: STSI handling
      KVM: s390: protvirt: disallow one_reg
      KVM: s390: protvirt: Do only reset registers that are accessible
      KVM: s390: protvirt: Only sync fmt4 registers
      KVM: s390: protvirt: Add program exception injection
      KVM: s390: protvirt: UV calls in support of diag308 0, 1
      KVM: s390: protvirt: Report CPU state to Ultravisor
      KVM: s390: protvirt: Support cmd 5 operation state
      KVM: s390: protvirt: Mask PSW interrupt bits for interception 104 and 112
      KVM: s390: protvirt: Add UV cpu reset calls
      DOCUMENTATION: Protected virtual machine introduction and IPL
      KVM: s390: protvirt: Add KVM api documentation

Jay Zhou (2):
      KVM: x86: enable dirty log gradually in small chunks
      kvm: selftests: Support dirty log initial-all-set test

Joe Perches (2):
      KVM: PPC: Use fallthrough;
      KVM: s390: Use fallthrough;

KarimAllah Ahmed (1):
      KVM: arm64: Use the correct timer structure to access the physical counter

Laurent Dufour (2):
      KVM: PPC: Book3S HV: Check caller of H_SVM_* Hcalls
      KVM: PPC: Book3S HV: H_SVM_INIT_START must call UV_RETURN

Marc Zyngier (16):
      arm: Unplug KVM from the build system
      arm: Remove KVM from config files
      arm: Remove 32bit KVM host support
      arm: Remove HYP/Stage-2 page-table support
      arm: Remove GICv3 vgic compatibility macros
      arm: Remove the ability to set HYP vectors outside of the decompressor
      MAINTAINERS: RIP KVM/arm
      KVM: arm64: GICv4.1: Let doorbells be auto-enabled
      KVM: arm64: GICv4.1: Add direct injection capability to SGI registers
      KVM: arm64: GICv4.1: Allow SGIs to switch between HW and SW interrupts
      KVM: arm64: GICv4.1: Plumb SGI implementation selection in the distributor
      KVM: arm64: GICv4.1: Reload VLPI configuration on distributor enable/disable
      KVM: arm64: GICv4.1: Allow non-trapping WFI when using HW SGIs
      KVM: arm64: GICv4.1: Expose HW-based SGIs in debugfs
      Merge branch 'kvm-arm64/gic-v4.1' into kvmarm-master/next
      Merge tag 'kvm-arm-removal' into kvmarm-master/next

Miaohe Lin (6):
      KVM: x86: Fix print format and coding style
      KVM: x86: eliminate some unreachable code
      KVM: VMX: Add 'else' to split mutually exclusive case
      KVM: apic: remove unused function apic_lvt_vector()
      KVM: Fix some obsolete comments
      KVM: nSVM: Remove an obsolete comment.

Michael Ellerman (1):
      KVM: PPC: Book3S HV: Use RADIX_PTE_INDEX_SIZE in Radix MMU code

Michael Mueller (2):
      KVM: s390: protvirt: Implement interrupt injection
      KVM: s390: introduce module parameter kvm.use_gisa

Michael Roth (1):
      KVM: PPC: Book3S HV: Fix H_CEDE return code for nested guests

Oliver Upton (2):
      KVM: SVM: Inhibit APIC virtualization for X2APIC guest
      KVM: nVMX: Consolidate nested MTF checks to helper function

Paolo Bonzini (17):
      KVM: x86: handle GBPAGE CPUID adjustment for EPT with generic code
      KVM: CPUID: add support for supervisor states
      KVM: x86: unify callbacks to load paging root
      KVM: x86: rename set_cr3 callback and related flags to load_mmu_pgd
      KVM: nSVM: do not change host intercepts while nested VM is running
      KVM: nSVM: ignore L1 interrupt window while running L2 with V_INTR_MASKING=1
      KVM: nSVM: implement check_nested_events for interrupts
      KVM: nSVM: avoid loss of pending IRQ/NMI before entering L2
      KVM: X86: correct meaningless kvm_apicv_activated() check
      Merge branch 'kvm-null-pointer-fix' into HEAD
      Merge tag 'kvm-s390-next-5.7-1' of git://git.kernel.org/.../kvms390/linux into HEAD
      KVM: nVMX: remove side effects from nested_vmx_exit_reflected
      KVM: nSVM: check for EFER.SVME=1 before entering guest
      Merge tag 'kvm-s390-next-5.7-2' of git://git.kernel.org/.../kvms390/linux into HEAD
      Merge tag 'kvm-s390-next-5.7-3' of git://git.kernel.org/.../kvms390/linux into HEAD
      Merge tag 'kvmarm-5.7' of git://git.kernel.org/.../kvmarm/kvmarm into HEAD
      Merge tag 'kvm-ppc-next-5.7-1' of git://git.kernel.org/.../paulus/powerpc into HEAD

Paul Mackerras (2):
      KVM: PPC: Book3S HV: Use __gfn_to_pfn_memslot in HPT page fault handler
      KVM: PPC: Book3S HV: Add a capability for enabling secure guests

Peter Xu (3):
      KVM: Remove unnecessary asm/kvm_host.h includes
      KVM: Drop gfn_to_pfn_atomic()
      KVM: Documentation: Update fast page fault for indirect sp

Qian Cai (1):
      x86/kvm: fix a missing-prototypes "vmread_error"

Sean Christopherson (132):
      KVM: x86: Add EMULTYPE_PF when emulation is triggered by a page fault
      KVM: x86: Move gpa_val and gpa_available into the emulator context
      KVM: x86: Allocate new rmap and large page tracking when moving memslot
      KVM: Reinstall old memslots if arch preparation fails
      KVM: Don't free new memslot if allocation of said memslot fails
      KVM: PPC: Move memslot memory allocation into prepare_memory_region()
      KVM: x86: Allocate memslot resources during prepare_memory_region()
      KVM: Drop kvm_arch_create_memslot()
      KVM: Explicitly free allocated-but-unused dirty bitmap
      KVM: Refactor error handling for setting memory region
      KVM: Move setting of memslot into helper routine
      KVM: Drop "const" attribute from old memslot in commit_memory_region()
      KVM: x86: Free arrays for old memslot when moving memslot's base gfn
      KVM: Move memslot deletion to helper function
      KVM: Simplify kvm_free_memslot() and all its descendents
      KVM: Clean up local variable usage in __kvm_set_memory_region()
      KVM: Provide common implementation for generic dirty log functions
      KVM: Ensure validity of memslot with respect to kvm_get_dirty_log()
      KVM: Terminate memslot walks via used_slots
      KVM: Dynamically size memslot array based on number of used slots
      KVM: selftests: Add test for KVM_SET_USER_MEMORY_REGION
      KVM: x86/mmu: Move kvm_arch_flush_remote_tlbs_memslot() to mmu.c
      KVM: x86/mmu: Use range-based TLB flush for dirty log memslot flush
      KVM: x86/mmu: Consolidate open coded variants of memslot TLB flushes
      KVM: x86: Gracefully handle __vmalloc() failure during VM allocation
      KVM: x86: Directly return __vmalloc() result in ->vm_alloc()
      KVM: x86: Consolidate VM allocation and free for VMX and SVM
      KVM: x86/mmu: Ignore guest CR3 on fast root switch for direct MMU
      KVM: x86/mmu: Reuse the current root if possible for fast switch
      KVM: nVMX: Properly handle userspace interrupt window request
      KVM: x86/mmu: Don't drop level/direct from MMU role calculation
      KVM: x86/mmu: Drop kvm_mmu_extended_role.cr4_la57 hack
      KVM: nVMX: Allow L1 to use 5-level page walks for nested EPT
      KVM: nVMX: Rename nested_ept_get_cr3() to nested_ept_get_eptp()
      KVM: nVMX: Rename EPTP validity helper and associated variables
      KVM: x86/mmu: Rename kvm_mmu->get_cr3() to ->get_guest_pgd()
      KVM: nVMX: Drop unnecessary check on ept caps for execute-only
      KVM: x86: Fix warning due to implicit truncation on 32-bit KVM
      KVM: x86: Refactor I/O emulation helpers to provide vcpu-only variant
      KVM: x86: Explicitly pass an exception struct to check_intercept
      KVM: x86: Move emulation-only helpers to emulate.c
      KVM: x86: Dynamically allocate per-vCPU emulation context
      KVM: x86: Move kvm_emulate.h into KVM's private directory
      KVM: x86: Shrink the usercopy region of the emulation context
      KVM: x86: Return -E2BIG when KVM_GET_SUPPORTED_CPUID hits max entries
      KVM: x86: Refactor loop around do_cpuid_func() to separate helper
      KVM: x86: Simplify handling of Centaur CPUID leafs
      KVM: x86: Clean up error handling in kvm_dev_ioctl_get_cpuid()
      KVM: x86: Check userspace CPUID array size after validating sub-leaf
      KVM: x86: Move CPUID 0xD.1 handling out of the index>0 loop
      KVM: x86: Check for CPUID 0xD.N support before validating array size
      KVM: x86: Warn on zero-size save state for valid CPUID 0xD.N sub-leaf
      KVM: x86: Refactor CPUID 0xD.N sub-leaf entry creation
      KVM: x86: Clean up CPUID 0x7 sub-leaf loop
      KVM: x86: Drop the explicit @index from do_cpuid_7_mask()
      KVM: x86: Drop redundant boot cpu checks on SSBD feature bits
      KVM: x86: Consolidate CPUID array max num entries checking
      KVM: x86: Hoist loop counter and terminator to top of __do_cpuid_func()
      KVM: x86: Refactor CPUID 0x4 and 0x8000001d handling
      KVM: x86: Encapsulate CPUID entries and metadata in struct
      KVM: x86: Drop redundant array size check
      KVM: x86: Use common loop iterator when handling CPUID 0xD.N
      KVM: VMX: Add helpers to query Intel PT mode
      KVM: x86: Calculate the supported xcr0 mask at load time
      KVM: x86: Use supported_xcr0 to detect MPX support
      KVM: x86: Make kvm_mpx_supported() an inline function
      KVM: x86: Clear output regs for CPUID 0x14 if PT isn't exposed to guest
      KVM: x86: Drop explicit @func param from ->set_supported_cpuid()
      KVM: x86: Use u32 for holding CPUID register value in helpers
      KVM: x86: Replace bare "unsigned" with "unsigned int" in cpuid helpers
      KVM: x86: Introduce cpuid_entry_{get,has}() accessors
      KVM: x86: Introduce cpuid_entry_{change,set,clear}() mutators
      KVM: x86: Refactor cpuid_mask() to auto-retrieve the register
      KVM: x86: Handle MPX CPUID adjustment in VMX code
      KVM: x86: Handle INVPCID CPUID adjustment in VMX code
      KVM: x86: Handle UMIP emulation CPUID adjustment in VMX code
      KVM: x86: Handle PKU CPUID adjustment in VMX code
      KVM: x86: Handle RDTSCP CPUID adjustment in VMX code
      KVM: x86: Handle Intel PT CPUID adjustment in VMX code
      KVM: x86: Refactor handling of XSAVES CPUID adjustment
      KVM: x86: Introduce kvm_cpu_caps to replace runtime CPUID masking
      KVM: SVM: Convert feature updates from CPUID to KVM cpu caps
      KVM: VMX: Convert feature updates from CPUID to KVM cpu caps
      KVM: x86: Move XSAVES CPUID adjust to VMX's KVM cpu cap update
      KVM: x86: Add a helper to check kernel support when setting cpu cap
      KVM: x86: Use KVM cpu caps to mark CR4.LA57 as not-reserved
      KVM: x86: Use KVM cpu caps to track UMIP emulation
      KVM: x86: Fold CPUID 0x7 masking back into __do_cpuid_func()
      KVM: x86: Remove the unnecessary loop on CPUID 0x7 sub-leafs
      KVM: x86: Squash CPUID 0x2.0 insanity for modern CPUs
      KVM: x86: Remove stateful CPUID handling
      KVM: x86: Do host CPUID at load time to mask KVM cpu caps
      KVM: x86: Override host CPUID results with kvm_cpu_caps
      KVM: x86: Set emulated/transmuted feature bits via kvm_cpu_caps
      KVM: x86: Use kvm_cpu_caps to detect Intel PT support
      KVM: x86: Do kvm_cpuid_array capacity checks in terminal functions
      KVM: x86: Use KVM cpu caps to detect MSR_TSC_AUX virt support
      KVM: VMX: Directly use VMX capabilities helper to detect RDTSCP support
      KVM: x86: Check for Intel PT MSR virtualization using KVM cpu caps
      KVM: VMX: Directly query Intel PT mode when refreshing PMUs
      KVM: SVM: Refactor logging of NPT enabled/disabled
      KVM: x86/mmu: Merge kvm_{enable,disable}_tdp() into a common function
      KVM: x86/mmu: Configure max page level during hardware setup
      KVM: x86: Don't propagate MMU lpage support to memslot.disallow_lpage
      KVM: Drop largepages_enabled and its accessor/mutator
      KVM: x86: Move VMX's host_efer to common x86 code
      KVM: nSVM: Expose SVM features to L1 iff nested is enabled
      KVM: nSVM: Advertise and enable NRIPS for L1 iff nrips is enabled
      KVM: x86: Move nSVM CPUID 0x8000000A handling into common x86 code
      KVM: x86: Add helpers to perform CPUID-based guest vendor check
      KVM x86: Extend AMD specific guest behavior to Hygon virtual CPUs
      KVM: x86: Fix CPUID range checks for Hypervisor and Centaur classes
      KVM: x86: Refactor out-of-range logic to contain the madness
      KVM: x86: Refactor kvm_cpuid() param that controls out-of-range logic
      KVM: x86: Add requested index to the CPUID tracepoint
      KVM: x86: Add blurb to CPUID tracepoint when using max basic leaf values
      KVM: VMX: Always VMCLEAR in-use VMCSes during crash with kexec support
      KVM: VMX: Fold loaded_vmcs_init() into alloc_loaded_vmcs()
      KVM: VMX: Gracefully handle faults on VMXON
      KVM: Fix out of range accesses to memslots
      KVM: selftests: Fix cosmetic copy-paste error in vm_mem_region_move()
      KVM: Pass kvm_init()'s opaque param to additional arch funcs
      KVM: x86: Move init-only kvm_x86_ops to separate struct
      KVM: VMX: Move hardware_setup() definition below vmx_x86_ops
      KVM: VMX: Configure runtime hooks using vmx_x86_ops
      KVM: x86: Set kvm_x86_ops only after ->hardware_setup() completes
      KVM: x86: Copy kvm_x86_ops by value to eliminate layer of indirection
      KVM: x86: Drop __exit from kvm_x86_ops' hardware_unsetup()
      KVM: VMX: Annotate vmx_x86_ops as __initdata
      KVM: SVM: Annotate svm_x86_ops as __initdata
      KVM: VMX: Add a trampoline to fix VMREAD error handling
      KVM: x86: Fix BUILD_BUG() in __cpuid_entry_get_reg() w/ CONFIG_UBSAN=y

Stefan Raspl (4):
      tools/kvm_stat: rework command line sequence and message texts
      tools/kvm_stat: switch to argparse
      tools/kvm_stat: add command line switch '-s' to set update interval
      tools/kvm_stat: add command line switch '-c' to log in csv format

Suravee Suthikulpanit (1):
      kvm: svm: Introduce GA Log tracepoint for AVIC

Ulrich Weigand (1):
      KVM: s390/interrupt: do not pin adapter interrupt pages

Uros Bizjak (1):
      KVM: VMX: access regs array in vmenter.S in its natural order

Vasily Gorbik (3):
      s390/protvirt: introduce host side setup
      s390/protvirt: add ultravisor initialization
      s390/mm: add (non)secure page access exceptions handlers

Vitaly Kuznetsov (5):
      KVM: nVMX: stop abusing need_vmcs12_to_shadow_sync for eVMCS mapping
      KVM: nVMX: properly handle errors in nested_vmx_handle_enlightened_vmptrld()
      KVM: selftests: define and use EVMCS_VERSION
      KVM: selftests: test enlightened vmenter with wrong eVMCS version
      KVM: selftests: enlightened VMPTRLD with an incorrect GPA

Wainer dos Santos Moschetta (2):
      selftests: kvm: Introduce the TEST_FAIL macro
      selftests: kvm: Uses TEST_FAIL in tests/utilities

Wanpeng Li (5):
      KVM: LAPIC: Recalculate apic map in batch
      KVM: X86: trigger kvmclock sync request just once on VM creation
      KVM: VMX: Micro-optimize vmexit time when not exposing PMU
      KVM: X86: Delay read msr data iff writes ICR MSR
      KVM: X86: Micro-optimize IPI fastpath delay

Xiaoyao Li (1):
      KVM: x86: Code style cleanup in kvm_arch_dev_ioctl()

Zhenyu Wang (2):
      KVM: x86: Expose AVX512 VP2INTERSECT in cpuid for TGL
      KVM: x86: Expose fast short REP MOV for supported cpuid

 Documentation/admin-guide/kernel-parameters.txt    |    5 +
 Documentation/virt/kvm/api.rst                     |  128 +-
 Documentation/virt/kvm/arm/hyp-abi.rst             |    5 +
 Documentation/virt/kvm/devices/s390_flic.rst       |   11 +-
 Documentation/virt/kvm/index.rst                   |    2 +
 Documentation/virt/kvm/locking.rst                 |   11 +-
 Documentation/virt/kvm/s390-pv-boot.rst            |   84 ++
 Documentation/virt/kvm/s390-pv.rst                 |  116 ++
 MAINTAINERS                                        |    6 +-
 arch/arm/Kconfig                                   |    2 -
 arch/arm/Makefile                                  |    1 -
 arch/arm/configs/axm55xx_defconfig                 |    2 -
 arch/arm/include/asm/arch_gicv3.h                  |  114 --
 arch/arm/include/asm/kvm_arm.h                     |  239 ----
 arch/arm/include/asm/kvm_asm.h                     |   77 --
 arch/arm/include/asm/kvm_coproc.h                  |   36 -
 arch/arm/include/asm/kvm_emulate.h                 |  372 -----
 arch/arm/include/asm/kvm_host.h                    |  456 ------
 arch/arm/include/asm/kvm_hyp.h                     |  127 --
 arch/arm/include/asm/kvm_mmu.h                     |  435 ------
 arch/arm/include/asm/kvm_ras.h                     |   14 -
 arch/arm/include/asm/pgtable-3level.h              |   20 -
 arch/arm/include/asm/pgtable.h                     |    9 -
 arch/arm/include/asm/sections.h                    |    6 +-
 arch/arm/include/asm/stage2_pgtable.h              |   75 -
 arch/arm/include/asm/virt.h                        |   17 -
 arch/arm/include/uapi/asm/kvm.h                    |  314 -----
 arch/arm/kernel/asm-offsets.c                      |   11 -
 arch/arm/kernel/hyp-stub.S                         |   39 +-
 arch/arm/kernel/vmlinux-xip.lds.S                  |    8 -
 arch/arm/kernel/vmlinux.lds.S                      |    8 -
 arch/arm/kernel/vmlinux.lds.h                      |   10 -
 arch/arm/kvm/Kconfig                               |   59 -
 arch/arm/kvm/Makefile                              |   43 -
 arch/arm/kvm/coproc.c                              | 1455 --------------------
 arch/arm/kvm/coproc.h                              |  130 --
 arch/arm/kvm/coproc_a15.c                          |   39 -
 arch/arm/kvm/coproc_a7.c                           |   42 -
 arch/arm/kvm/emulate.c                             |  166 ---
 arch/arm/kvm/guest.c                               |  387 ------
 arch/arm/kvm/handle_exit.c                         |  175 ---
 arch/arm/kvm/hyp/Makefile                          |   34 -
 arch/arm/kvm/hyp/banked-sr.c                       |   70 -
 arch/arm/kvm/hyp/cp15-sr.c                         |   72 -
 arch/arm/kvm/hyp/entry.S                           |  121 --
 arch/arm/kvm/hyp/hyp-entry.S                       |  295 ----
 arch/arm/kvm/hyp/s2-setup.c                        |   22 -
 arch/arm/kvm/hyp/switch.c                          |  242 ----
 arch/arm/kvm/hyp/tlb.c                             |   68 -
 arch/arm/kvm/hyp/vfp.S                             |   57 -
 arch/arm/kvm/init.S                                |  157 ---
 arch/arm/kvm/interrupts.S                          |   36 -
 arch/arm/kvm/irq.h                                 |   16 -
 arch/arm/kvm/reset.c                               |   86 --
 arch/arm/kvm/trace.h                               |   86 --
 arch/arm/kvm/vgic-v3-coproc.c                      |   27 -
 arch/arm/mach-exynos/Kconfig                       |    2 +-
 arch/arm/mm/mmu.c                                  |   26 -
 arch/arm64/include/asm/kvm_emulate.h               |    3 +-
 arch/arm64/include/asm/kvm_host.h                  |    1 +
 arch/arm64/kvm/fpsimd.c                            |    1 -
 arch/arm64/kvm/guest.c                             |    1 -
 arch/arm64/kvm/hyp/switch.c                        |    1 -
 arch/arm64/kvm/sys_regs.c                          |    1 -
 arch/arm64/kvm/sys_regs_generic_v8.c               |    1 -
 arch/mips/include/asm/kvm_host.h                   |    2 +-
 arch/mips/kvm/mips.c                               |   75 +-
 arch/powerpc/include/asm/kvm_asm.h                 |    3 +
 arch/powerpc/include/asm/kvm_book3s_uvmem.h        |    6 +
 arch/powerpc/include/asm/kvm_host.h                |    1 +
 arch/powerpc/include/asm/kvm_ppc.h                 |   21 +-
 arch/powerpc/kvm/book3s.c                          |   25 +-
 arch/powerpc/kvm/book3s.h                          |    1 +
 arch/powerpc/kvm/book3s_32_mmu.c                   |    2 +-
 arch/powerpc/kvm/book3s_32_mmu_host.c              |    2 +-
 arch/powerpc/kvm/book3s_64_mmu.c                   |    2 +-
 arch/powerpc/kvm/book3s_64_mmu_host.c              |    2 +-
 arch/powerpc/kvm/book3s_64_mmu_hv.c                |  119 +-
 arch/powerpc/kvm/book3s_64_mmu_radix.c             |    2 +-
 arch/powerpc/kvm/book3s_64_vio.c                   |    1 -
 arch/powerpc/kvm/book3s_64_vio_hv.c                |    1 -
 arch/powerpc/kvm/book3s_hv.c                       |   90 +-
 arch/powerpc/kvm/book3s_hv_tm.c                    |   28 +-
 arch/powerpc/kvm/book3s_hv_tm_builtin.c            |   16 +-
 arch/powerpc/kvm/book3s_hv_uvmem.c                 |   19 +-
 arch/powerpc/kvm/book3s_pr.c                       |   26 +-
 arch/powerpc/kvm/booke.c                           |   26 +-
 arch/powerpc/kvm/booke.h                           |    2 -
 arch/powerpc/kvm/e500.c                            |    1 -
 arch/powerpc/kvm/e500_mmu.c                        |    4 -
 arch/powerpc/kvm/e500mc.c                          |    1 -
 arch/powerpc/kvm/mpic.c                            |    1 -
 arch/powerpc/kvm/powerpc.c                         |   37 +-
 arch/powerpc/kvm/timing.h                          |    1 -
 arch/s390/boot/Makefile                            |    2 +-
 arch/s390/boot/uv.c                                |   20 +
 arch/s390/include/asm/gmap.h                       |    6 +
 arch/s390/include/asm/kvm_host.h                   |  117 +-
 arch/s390/include/asm/mmu.h                        |    2 +
 arch/s390/include/asm/mmu_context.h                |    1 +
 arch/s390/include/asm/page.h                       |    5 +
 arch/s390/include/asm/pgtable.h                    |   35 +-
 arch/s390/include/asm/uv.h                         |  251 +++-
 arch/s390/kernel/Makefile                          |    1 +
 arch/s390/kernel/entry.h                           |    2 +
 arch/s390/kernel/pgm_check.S                       |    4 +-
 arch/s390/kernel/setup.c                           |    9 +-
 arch/s390/kernel/uv.c                              |  414 ++++++
 arch/s390/kvm/Makefile                             |    2 +-
 arch/s390/kvm/diag.c                               |    6 +-
 arch/s390/kvm/gaccess.c                            |   23 +-
 arch/s390/kvm/intercept.c                          |  123 +-
 arch/s390/kvm/interrupt.c                          |  401 +++---
 arch/s390/kvm/kvm-s390.c                           |  597 ++++++--
 arch/s390/kvm/kvm-s390.h                           |   51 +-
 arch/s390/kvm/priv.c                               |   13 +-
 arch/s390/kvm/pv.c                                 |  303 ++++
 arch/s390/mm/fault.c                               |   78 ++
 arch/s390/mm/gmap.c                                |   72 +-
 arch/x86/include/asm/kvm_host.h                    |  105 +-
 arch/x86/include/asm/kvm_page_track.h              |    3 +-
 arch/x86/include/asm/vmx.h                         |   12 +
 arch/x86/kvm/cpuid.c                               |  944 +++++++------
 arch/x86/kvm/cpuid.h                               |  151 +-
 arch/x86/kvm/emulate.c                             |   57 +-
 arch/x86/kvm/hyperv.c                              |    8 +-
 arch/x86/kvm/i8254.c                               |    2 +-
 arch/x86/kvm/kvm_cache_regs.h                      |   10 +-
 arch/x86/{include/asm => kvm}/kvm_emulate.h        |   43 +-
 arch/x86/kvm/lapic.c                               |   85 +-
 arch/x86/kvm/lapic.h                               |    2 +
 arch/x86/kvm/mmu.h                                 |   10 +-
 arch/x86/kvm/mmu/mmu.c                             |  209 +--
 arch/x86/kvm/mmu/page_track.c                      |   16 +-
 arch/x86/kvm/mmu/paging_tmpl.h                     |    4 +-
 arch/x86/kvm/pmu.c                                 |   34 +-
 arch/x86/kvm/pmu.h                                 |   11 +-
 arch/x86/kvm/svm.c                                 |  407 +++---
 arch/x86/kvm/trace.h                               |   50 +-
 arch/x86/kvm/vmx/capabilities.h                    |   25 +-
 arch/x86/kvm/vmx/evmcs.h                           |    7 +
 arch/x86/kvm/vmx/nested.c                          |  188 +--
 arch/x86/kvm/vmx/nested.h                          |    8 +-
 arch/x86/kvm/vmx/ops.h                             |   27 +-
 arch/x86/kvm/vmx/pmu_intel.c                       |    8 +-
 arch/x86/kvm/vmx/vmenter.S                         |   72 +-
 arch/x86/kvm/vmx/vmx.c                             |  665 +++++----
 arch/x86/kvm/vmx/vmx.h                             |    8 +-
 arch/x86/kvm/x86.c                                 |  787 ++++++-----
 arch/x86/kvm/x86.h                                 |   28 +-
 include/kvm/arm_vgic.h                             |    3 +
 include/linux/kvm_host.h                           |   71 +-
 include/uapi/linux/kvm.h                           |   47 +-
 tools/arch/x86/include/asm/unistd_64.h             |    3 +
 tools/kvm/kvm_stat/kvm_stat                        |  256 ++--
 tools/kvm/kvm_stat/kvm_stat.txt                    |   44 +-
 tools/testing/selftests/kvm/.gitignore             |    7 +-
 tools/testing/selftests/kvm/Makefile               |   12 +-
 tools/testing/selftests/kvm/clear_dirty_log_test.c |    4 +
 tools/testing/selftests/kvm/demand_paging_test.c   |  661 +++++++++
 tools/testing/selftests/kvm/dirty_log_test.c       |  107 +-
 tools/testing/selftests/kvm/include/evmcs.h        |    2 +
 tools/testing/selftests/kvm/include/kvm_util.h     |  126 +-
 tools/testing/selftests/kvm/include/test_util.h    |   28 +-
 tools/testing/selftests/kvm/kvm_create_max_vcpus.c |    8 +-
 .../testing/selftests/kvm/lib/aarch64/processor.c  |   41 +-
 tools/testing/selftests/kvm/lib/aarch64/ucall.c    |    2 +-
 tools/testing/selftests/kvm/lib/assert.c           |    6 +-
 tools/testing/selftests/kvm/lib/io.c               |   12 +-
 tools/testing/selftests/kvm/lib/kvm_util.c         |  170 ++-
 .../testing/selftests/kvm/lib/kvm_util_internal.h  |   59 +-
 tools/testing/selftests/kvm/lib/s390x/processor.c  |   78 +-
 tools/testing/selftests/kvm/lib/test_util.c        |   93 ++
 tools/testing/selftests/kvm/lib/x86_64/processor.c |  201 +--
 tools/testing/selftests/kvm/lib/x86_64/svm.c       |    2 +-
 tools/testing/selftests/kvm/lib/x86_64/vmx.c       |    4 +-
 tools/testing/selftests/kvm/s390x/memop.c          |    2 +-
 tools/testing/selftests/kvm/s390x/resets.c         |  138 +-
 tools/testing/selftests/kvm/s390x/sync_regs_test.c |   13 +-
 tools/testing/selftests/kvm/steal_time.c           |  352 +++++
 .../selftests/kvm/x86_64/cr4_cpuid_sync_test.c     |    6 +-
 tools/testing/selftests/kvm/x86_64/evmcs_test.c    |   35 +-
 tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c  |    8 +-
 .../selftests/kvm/x86_64/mmio_warning_test.c       |    6 +-
 .../selftests/kvm/x86_64/platform_info_test.c      |    6 +-
 .../selftests/kvm/x86_64/set_memory_region_test.c  |  141 ++
 tools/testing/selftests/kvm/x86_64/smm_test.c      |    2 +-
 tools/testing/selftests/kvm/x86_64/state_test.c    |   10 +-
 .../testing/selftests/kvm/x86_64/svm_vmcall_test.c |    6 +-
 .../testing/selftests/kvm/x86_64/sync_regs_test.c  |    4 +-
 .../kvm/x86_64/vmx_close_while_nested_test.c       |    4 +-
 .../selftests/kvm/x86_64/vmx_dirty_log_test.c      |   17 +-
 .../kvm/x86_64/vmx_set_nested_state_test.c         |    4 +-
 .../selftests/kvm/x86_64/vmx_tsc_adjust_test.c     |    8 +-
 tools/testing/selftests/kvm/x86_64/xss_msr_test.c  |    2 +-
 virt/kvm/arm/arch_timer.c                          |    2 +-
 virt/kvm/arm/arm.c                                 |   60 +-
 virt/kvm/arm/mmu.c                                 |   20 +-
 virt/kvm/arm/psci.c                                |    1 -
 virt/kvm/arm/vgic/vgic-debug.c                     |   14 +-
 virt/kvm/arm/vgic/vgic-mmio-v3.c                   |   81 +-
 virt/kvm/arm/vgic/vgic-mmio.c                      |   88 +-
 virt/kvm/arm/vgic/vgic-v3.c                        |    2 +
 virt/kvm/arm/vgic/vgic-v4.c                        |  107 +-
 virt/kvm/arm/vgic/vgic.h                           |    1 +
 virt/kvm/kvm_main.c                                |  663 ++++++---
 206 files changed, 7871 insertions(+), 9702 deletions(-)
 create mode 100644 Documentation/virt/kvm/s390-pv-boot.rst
 create mode 100644 Documentation/virt/kvm/s390-pv.rst
 delete mode 100644 arch/arm/include/asm/kvm_arm.h
 delete mode 100644 arch/arm/include/asm/kvm_asm.h
 delete mode 100644 arch/arm/include/asm/kvm_coproc.h
 delete mode 100644 arch/arm/include/asm/kvm_emulate.h
 delete mode 100644 arch/arm/include/asm/kvm_host.h
 delete mode 100644 arch/arm/include/asm/kvm_hyp.h
 delete mode 100644 arch/arm/include/asm/kvm_mmu.h
 delete mode 100644 arch/arm/include/asm/kvm_ras.h
 delete mode 100644 arch/arm/include/asm/stage2_pgtable.h
 delete mode 100644 arch/arm/include/uapi/asm/kvm.h
 delete mode 100644 arch/arm/kvm/Kconfig
 delete mode 100644 arch/arm/kvm/Makefile
 delete mode 100644 arch/arm/kvm/coproc.c
 delete mode 100644 arch/arm/kvm/coproc.h
 delete mode 100644 arch/arm/kvm/coproc_a15.c
 delete mode 100644 arch/arm/kvm/coproc_a7.c
 delete mode 100644 arch/arm/kvm/emulate.c
 delete mode 100644 arch/arm/kvm/guest.c
 delete mode 100644 arch/arm/kvm/handle_exit.c
 delete mode 100644 arch/arm/kvm/hyp/Makefile
 delete mode 100644 arch/arm/kvm/hyp/banked-sr.c
 delete mode 100644 arch/arm/kvm/hyp/cp15-sr.c
 delete mode 100644 arch/arm/kvm/hyp/entry.S
 delete mode 100644 arch/arm/kvm/hyp/hyp-entry.S
 delete mode 100644 arch/arm/kvm/hyp/s2-setup.c
 delete mode 100644 arch/arm/kvm/hyp/switch.c
 delete mode 100644 arch/arm/kvm/hyp/tlb.c
 delete mode 100644 arch/arm/kvm/hyp/vfp.S
 delete mode 100644 arch/arm/kvm/init.S
 delete mode 100644 arch/arm/kvm/interrupts.S
 delete mode 100644 arch/arm/kvm/irq.h
 delete mode 100644 arch/arm/kvm/reset.c
 delete mode 100644 arch/arm/kvm/trace.h
 delete mode 100644 arch/arm/kvm/vgic-v3-coproc.c
 create mode 100644 arch/s390/kernel/uv.c
 create mode 100644 arch/s390/kvm/pv.c
 rename arch/x86/{include/asm => kvm}/kvm_emulate.h (93%)
 create mode 100644 tools/testing/selftests/kvm/demand_paging_test.c
 create mode 100644 tools/testing/selftests/kvm/lib/test_util.c
 create mode 100644 tools/testing/selftests/kvm/steal_time.c
 create mode 100644 tools/testing/selftests/kvm/x86_64/set_memory_region_test.c

