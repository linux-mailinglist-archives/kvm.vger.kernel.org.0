Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F2826A17C1
	for <lists+kvm@lfdr.de>; Fri, 24 Feb 2023 09:12:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbjBXIMH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Feb 2023 03:12:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbjBXIMB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Feb 2023 03:12:01 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1722E410B8
        for <kvm@vger.kernel.org>; Fri, 24 Feb 2023 00:11:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677226270;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=HT/UStx5LjnSo8Fkkc21zvnCA2s+LDokyvV+g5uymo4=;
        b=LdJeWR/DJHI/3D6N7tRrSSWXj7paAsV3OpLAhFnWHuoNr/1ksryx2akOKFL3bqko9zvO5p
        IyGLZ4/vQ2LhVRH3NgqUQJJQUy7uDpuSp9h/vDMXfFMcvfj6DBKFARuLxdF7wfHQid7Ec9
        XSg2odgbE2OGGt5Kj/1ohvGyk55x1Bc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-657-5r4BcXe6PomQyNKmJrftbw-1; Fri, 24 Feb 2023 03:11:06 -0500
X-MC-Unique: 5r4BcXe6PomQyNKmJrftbw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0B0AB811E6E;
        Fri, 24 Feb 2023 08:11:06 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D31C7140EBF4;
        Fri, 24 Feb 2023 08:11:05 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] KVM changes for Linux 6.3 merge window
Date:   Fri, 24 Feb 2023 03:11:05 -0500
Message-Id: <20230224081105.2106665-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit 9442d05bba6c12749fdc4039eddcf801398ec82b:

  arm64/sme: Fix __finalise_el2 SMEver check (2023-02-06 16:34:29 +0000)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 45dd9bc75d9adc9483f0c7d662ba6e73ed698a0b:

  KVM: SVM: hyper-v: placate modpost section mismatch error (2023-02-22 13:32:07 -0500)

The common topic branches with other trees have all been merged already,
hence the slightly weird "since commit" line that git chose above.

There are small conflicts in arch/x86's cpuid lists.  I include the
conflict resolution after the diffstat.

Also, the following drivers/ changes stand out in the diffstat:

- virtualization-related features for the vGIC of Apple's interrupt
  controller and for the RISC-V PMU (event->attr.exclude_{hv,guest})

- a s390 virtio-ccw change that technically should have been included
  in Michael Tsirkin's virtio tree, or simply through the s390 tree.
  But the author (Alexander Gordeev) _is_ an s390 maintainer so please
  give him a pass. :)

----------------------------------------------------------------
ARM:

- Provide a virtual cache topology to the guest to avoid
  inconsistencies with migration on heterogenous systems. Non secure
  software has no practical need to traverse the caches by set/way in
  the first place.

- Add support for taking stage-2 access faults in parallel. This was an
  accidental omission in the original parallel faults implementation,
  but should provide a marginal improvement to machines w/o FEAT_HAFDBS
  (such as hardware from the fruit company).

- A preamble to adding support for nested virtualization to KVM,
  including vEL2 register state, rudimentary nested exception handling
  and masking unsupported features for nested guests.

- Fixes to the PSCI relay that avoid an unexpected host SVE trap when
  resuming a CPU when running pKVM.

- VGIC maintenance interrupt support for the AIC

- Improvements to the arch timer emulation, primarily aimed at reducing
  the trap overhead of running nested.

- Add CONFIG_USERFAULTFD to the KVM selftests config fragment in the
  interest of CI systems.

- Avoid VM-wide stop-the-world operations when a vCPU accesses its own
  redistributor.

- Serialize when toggling CPACR_EL1.SMEN to avoid unexpected exceptions
  in the host.

- Aesthetic and comment/kerneldoc fixes

- Drop the vestiges of the old Columbia mailing list and add [Oliver]
  as co-maintainer

This also drags in arm64's 'for-next/sme2' branch, because both it and
the PSCI relay changes touch the EL2 initialization code.

RISC-V:

- Fix wrong usage of PGDIR_SIZE instead of PUD_SIZE

- Correctly place the guest in S-mode after redirecting a trap to the guest

- Redirect illegal instruction traps to guest

- SBI PMU support for guest

s390:

- Two patches sorting out confusion between virtual and physical
  addresses, which currently are the same on s390.

- A new ioctl that performs cmpxchg on guest memory

- A few fixes

x86:

- Change tdp_mmu to a read-only parameter

- Separate TDP and shadow MMU page fault paths

- Enable Hyper-V invariant TSC control

- Fix a variety of APICv and AVIC bugs, some of them real-world,
  some of them affecting architecurally legal but unlikely to
  happen in practice

- Mark APIC timer as expired if its in one-shot mode and the count
  underflows while the vCPU task was being migrated

- Advertise support for Intel's new fast REP string features

- Fix a double-shootdown issue in the emergency reboot code

- Ensure GIF=1 and disable SVM during an emergency reboot, i.e. give SVM
  similar treatment to VMX

- Update Xen's TSC info CPUID sub-leaves as appropriate

- Add support for Hyper-V's extended hypercalls, where "support" at this
  point is just forwarding the hypercalls to userspace

- Clean up the kvm->lock vs. kvm->srcu sequences when updating the PMU and
  MSR filters

- One-off fixes and cleanups

- Fix and cleanup the range-based TLB flushing code, used when KVM is
  running on Hyper-V

- Add support for filtering PMU events using a mask.  If userspace
  wants to restrict heavily what events the guest can use, it can now
  do so without needing an absurd number of filter entries

- Clean up KVM's handling of "PMU MSRs to save", especially when vPMU
  support is disabled

- Add PEBS support for Intel Sapphire Rapids

- Fix a mostly benign overflow bug in SEV's send|receive_update_data()

- Move several SVM-specific flags into vcpu_svm

x86 Intel:

- Handle NMI VM-Exits before leaving the noinstr region

- A few trivial cleanups in the VM-Enter flows

- Stop enabling VMFUNC for L1 purely to document that KVM doesn't support
  EPTP switching (or any other VM function) for L1

- Fix a crash when using eVMCS's enlighted MSR bitmaps

Generic:

- Clean up the hardware enable and initialization flow, which was
  scattered around multiple arch-specific hooks.  Instead, just
  let the arch code call into generic code.  Both x86 and ARM should
  benefit from not having to fight common KVM code's notion of how
  to do initialization.

- Account allocations in generic kvm_arch_alloc_vm()

- Fix a memory leak if coalesced MMIO unregistration fails

selftests:

- On x86, cache the CPU vendor (AMD vs. Intel) and use the info to emit
  the correct hypercall instruction instead of relying on KVM to patch
  in VMMCALL

- Use TAP interface for kvm_binary_stats_test and tsc_msrs_test

----------------------------------------------------------------
Aaron Lewis (8):
      KVM: x86/pmu: Correct the mask used in a pmu event filter lookup
      KVM: x86/pmu: Remove impossible events from the pmu event filter
      KVM: x86/pmu: prepare the pmu event filter for masked events
      KVM: x86/pmu: Introduce masked events to the pmu event filter
      KVM: selftests: Add flags when creating a pmu event filter
      KVM: selftests: Add testing for KVM_SET_PMU_EVENT_FILTER
      KVM: selftests: Test masked events in PMU filter
      KVM: selftests: Fix a typo in the vcpu_msrs_set assert

Akihiko Odaki (6):
      arm64/sysreg: Convert CCSIDR_EL1 to automatic generation
      arm64/sysreg: Add CCSIDR2_EL1
      arm64/cache: Move CLIDR macro definitions
      KVM: arm64: Always set HCR_TID2
      KVM: arm64: Mask FEAT_CCIDX
      KVM: arm64: Normalize cache configuration

Alexander Gordeev (1):
      s390/virtio: sort out physical vs virtual pointers usage

Alexandre Ghiti (1):
      KVM: RISC-V: Fix wrong usage of PGDIR_SIZE to check page sizes

Alexandru Matei (1):
      KVM: VMX: Fix crash due to uninitialized current_vmcs

Alexey Dobriyan (2):
      KVM: account allocation in generic version of kvm_arch_alloc_vm()
      KVM: VMX: don't use "unsigned long" in vmx_vcpu_enter_exit()

Andy Chiu (1):
      RISC-V: KVM: Redirect illegal instruction traps to guest

Anish Ghulati (1):
      KVM: SVM: Account scratch allocations used to decrypt SEV guest memory

Anup Patel (1):
      RISC-V: KVM: Fix privilege mode setting in kvm_riscv_vcpu_trap_redirect()

Atish Patra (14):
      perf: RISC-V: Define helper functions expose hpm counter width and count
      perf: RISC-V: Improve privilege mode filtering for perf
      RISC-V: Improve SBI PMU extension related definitions
      RISC-V: KVM: Define a probe function for SBI extension data structures
      RISC-V: KVM: Return correct code for hsm stop function
      RISC-V: KVM: Modify SBI extension handler to return SBI error code
      RISC-V: KVM: Add skeleton support for perf
      RISC-V: KVM: Add SBI PMU extension support
      RISC-V: KVM: Make PMU functionality depend on Sscofpmf
      RISC-V: KVM: Disable all hpmcounter access for VS/VU mode
      RISC-V: KVM: Implement trap & emulate for hpmcounters
      RISC-V: KVM: Implement perf support without sampling
      RISC-V: KVM: Support firmware events
      RISC-V: KVM: Increment firmware pmu events

Chao Gao (3):
      KVM: x86: Do compatibility checks when onlining CPU
      KVM: Rename and move CPUHP_AP_KVM_STARTING to ONLINE section
      KVM: Disable CPU hotplug during hardware enabling/disabling

Christoffer Dall (6):
      KVM: arm64: nv: Introduce nested virtualization VCPU feature
      KVM: arm64: nv: Reset VCPU to EL2 registers if VCPU nested virt is set
      KVM: arm64: nv: Allow userspace to set PSR_MODE_EL2x
      KVM: arm64: nv: Add nested virt VCPU primitives for vEL2 VCPU state
      KVM: arm64: nv: Handle trapped ERET from virtual EL2
      KVM: arm64: nv: Only toggle cache for virtual EL2 when SCTLR_EL2 changes

Christophe JAILLET (2):
      KVM: arm64: vgic-v3: Use kstrtobool() instead of strtobool()
      KVM: x86/mmu: Use kstrtobool() instead of strtobool()

David Matlack (22):
      KVM: x86/mmu: Change tdp_mmu to a read-only parameter
      KVM: x86/mmu: Move TDP MMU VM init/uninit behind tdp_mmu_enabled
      KVM: x86/mmu: Grab mmu_invalidate_seq in kvm_faultin_pfn()
      KVM: x86/mmu: Handle error PFNs in kvm_faultin_pfn()
      KVM: x86/mmu: Avoid memslot lookup during KVM_PFN_ERR_HWPOISON handling
      KVM: x86/mmu: Handle no-slot faults in kvm_faultin_pfn()
      KVM: x86/mmu: Initialize fault.{gfn,slot} earlier for direct MMUs
      KVM: x86/mmu: Split out TDP MMU page fault handling
      KVM: x86/mmu: Stop needlessly making MMU pages available for TDP MMU faults
      KVM: x86/mmu: Rename __direct_map() to direct_map()
      KVM: x86/mmu: Change tdp_mmu to a read-only parameter
      KVM: x86/mmu: Move TDP MMU VM init/uninit behind tdp_mmu_enabled
      KVM: x86/mmu: Grab mmu_invalidate_seq in kvm_faultin_pfn()
      KVM: x86/mmu: Handle error PFNs in kvm_faultin_pfn()
      KVM: x86/mmu: Avoid memslot lookup during KVM_PFN_ERR_HWPOISON handling
      KVM: x86/mmu: Handle no-slot faults in kvm_faultin_pfn()
      KVM: x86/mmu: Initialize fault.{gfn,slot} earlier for direct MMUs
      KVM: x86/mmu: Split out TDP MMU page fault handling
      KVM: x86/mmu: Stop needlessly making MMU pages available for TDP MMU faults
      KVM: x86/mmu: Rename __direct_map() to direct_map()
      KVM: x86: Replace cpu_dirty_logging_count with nr_memslots_dirty_logging
      KVM: x86/mmu: Make tdp_mmu_allowed static

Emanuele Giuseppe Esposito (2):
      KVM: x86: Reinitialize xAPIC ID when userspace forces x2APIC => xAPIC
      KVM: selftests: Verify APIC_ID is set when forcing x2APIC=>xAPIC transition

Gavin Shan (2):
      KVM: selftests: Remove duplicate VM creation in memslot_perf_test
      KVM: selftests: Assign guest page size in sync area early in memslot_perf_test

Greg Edwards (1):
      KVM: x86: Allow APICv APIC ID inhibit to be cleared

Hou Wenlong (6):
      KVM: x86/mmu: Move round_gfn_for_level() helper into mmu_internal.h
      KVM: x86/mmu: Fix wrong gfn range of tlb flushing in kvm_set_pte_rmapp()
      KVM: x86/mmu: Reduce gfn range of tlb flushing in tdp_mmu_map_handle_target_level()
      KVM: x86/mmu: Fix wrong start gfn of tlb flushing with range
      KVM: x86/mmu: Fix wrong gfn range of tlb flushing in validate_direct_spte()
      KVM: x86/mmu: Cleanup range-based flushing for given page

Isaku Yamahata (3):
      KVM: Drop kvm_count_lock and instead protect kvm_usage_count with kvm_lock
      KVM: Remove on_each_cpu(hardware_disable_nolock) in kvm_exit()
      KVM: Make hardware_enable_failed a local variable in the "enable all" path

Janis Schoetterl-Glausch (14):
      KVM: s390: selftest: memop: Pass mop_desc via pointer
      KVM: s390: selftest: memop: Replace macros by functions
      KVM: s390: selftest: memop: Move testlist into main
      KVM: s390: selftest: memop: Add bad address test
      KVM: s390: selftest: memop: Fix typo
      KVM: s390: selftest: memop: Fix wrong address being used in test
      KVM: s390: selftest: memop: Fix integer literal
      KVM: s390: Move common code of mem_op functions into function
      KVM: s390: Dispatch to implementing function at top level of vm mem_op
      KVM: s390: Refactor absolute vm mem_op function
      KVM: s390: Refactor vcpu mem_op function
      KVM: s390: Extend MEM_OP ioctl by storage key checked cmpxchg
      Documentation: KVM: s390: Describe KVM_S390_MEMOP_F_CMPXCHG
      KVM: s390: selftest: memop: Add cmpxchg tests

Janosch Frank (1):
      Merge remote-tracking branch 'l390-korg/cmpxchg_user_key' into kvm-next

Jiapeng Chong (1):
      arm64/sysreg: clean up some inconsistent indenting

Jim Mattson (2):
      x86/cpufeatures: Add macros for Intel's new fast rep string features
      KVM: x86: Advertise fast REP string features inherent to the CPU

Jing Zhang (1):
      KVM: selftests: Stop assuming stats are contiguous in kvm_binary_stats_test

Jintack Lim (7):
      arm64: Add ARM64_HAS_NESTED_VIRT cpufeature
      KVM: arm64: nv: Handle HCR_EL2.NV system register traps
      KVM: arm64: nv: Support virtual EL2 exceptions
      KVM: arm64: nv: Inject HVC exceptions to the virtual EL2
      KVM: arm64: nv: Handle SMCs taken from virtual EL2
      KVM: arm64: nv: Add accessors for SPSR_EL1, ELR_EL1 and VBAR_EL1 from virtual EL2
      KVM: arm64: nv: Emulate EL12 register accesses from the virtual EL2

Kees Cook (1):
      KVM: x86: Replace 0-length arrays with flexible arrays

Lai Jiangshan (4):
      kvm: x86/mmu: Warn on linking when sp->unsync_children
      kvm: x86/mmu: Warn on linking when sp->unsync_children
      kvm: x86/mmu: Rename SPTE_TDP_AD_ENABLED_MASK to SPTE_TDP_AD_ENABLED
      kvm: x86/mmu: Don't clear write flooding for direct SP

Li RongQing (1):
      KVM: x86: fire timer when it is migrated and expired, and in oneshot mode

Like Xu (5):
      KVM: svm/avic: Drop "struct kvm_x86_ops" for avic_hardware_setup()
      KVM: x86/pmu: Drop event_type and rename "struct kvm_event_hw_type_mapping"
      KVM: x86/pmu: Don't tell userspace to save MSRs for non-existent fixed PMCs
      KVM: x86/pmu: Add PRIR++ and PDist support for SPR and later models
      perf/x86/intel: Expose EPT-friendly PEBS for SPR and future models

Marc Zyngier (18):
      KVM: arm64: Simplify the CPUHP logic
      arm64: Allow the definition of UNKNOWN system register fields
      KVM: arm64: Kill CPACR_EL1_TTA definition
      KVM: arm64: vgic: Allow registration of a non-maskable maintenance interrupt
      irqchip/apple-aic: Register vgic maintenance interrupt with KVM
      KVM: arm64: vgic-v3: Limit IPI-ing when accessing GICR_{C,S}ACTIVER0
      KVM: arm64: Drop Columbia-hosted mailing list
      KVM: arm64: Don't arm a hrtimer for an already pending timer
      KVM: arm64: Reduce overhead of trapped timer sysreg accesses
      KVM: arm64: timers: Don't BUG() on unhandled timer trap
      irqchip/apple-aic: Correctly map the vgic maintenance interrupt
      KVM: arm64: Fix non-kerneldoc comments
      KVM: arm64: Use the S2 MMU context to iterate over S2 table
      KVM: arm64: nv: Add EL2 system registers to vcpu context
      KVM: arm64: nv: Emulate PSTATE.M for a guest hypervisor
      KVM: arm64: nv: Allow a sysreg to be hidden from userspace only
      KVM: arm64: nv: Filter out unsupported features from ID regs
      Merge tag ' https://github.com/oupton/linux tags/kvmarm-6.3' from into kvmarm-master/next

Mark Brown (1):
      KVM: selftests: Enable USERFAULTFD

Maxim Levitsky (4):
      KVM: nSVM: Don't sync tlb_ctl back to vmcb12 on nested VM-Exit
      KVM: x86: Move HF_GIF_MASK into "struct vcpu_svm" as "guest_gif"
      KVM: x86: Move HF_NMI_MASK and HF_IRET_MASK into "struct vcpu_svm"
      KVM: x86: Use emulator callbacks instead of duplicating "host flags"

Michal Luczaj (9):
      KVM: x86/emulator: Fix segment load privilege level validation
      KVM: x86/emulator: Fix comment in __load_segment_descriptor()
      KVM: x86: Optimize kvm->lock and SRCU interaction (KVM_SET_PMU_EVENT_FILTER)
      KVM: x86: Optimize kvm->lock and SRCU interaction (KVM_X86_SET_MSR_FILTER)
      KVM: x86: Simplify msr_filter update
      KVM: x86: Explicitly state lockdep condition of msr_filter update
      KVM: x86: Remove unnecessary initialization in kvm_vm_ioctl_set_msr_filter()
      KVM: x86: Simplify msr_io()
      KVM: selftests: Clean up misnomers in xen_shinfo_test

Nianyao Tang (1):
      KVM: arm64: Synchronize SMEN on vcpu schedule out

Nico Boehr (2):
      KVM: s390: disable migration mode when dirty tracking is disabled
      KVM: s390: GISA: sort out physical vs virtual pointers usage

Nina Schoetterl-Glausch (1):
      KVM: selftests: Compile s390 tests with -march=z10

Oliver Upton (19):
      KVM: arm64: Use KVM's pte type/helpers in handle_access_fault()
      KVM: arm64: Ignore EAGAIN for walks outside of a fault
      KVM: arm64: Return EAGAIN for invalid PTE in attr walker
      KVM: arm64: Don't serialize if the access flag isn't set
      KVM: arm64: Handle access faults behind the read lock
      KVM: arm64: Condition HW AF updates on config option
      MAINTAINERS: Add Oliver Upton as co-maintainer of KVM/arm64
      KVM: arm64: Mark some VM-scoped allocations as __GFP_ACCOUNT
      KVM: arm64: nv: Use reg_to_encoding() to get sysreg ID
      Merge branch kvm/kvm-hw-enable-refactor into kvmarm/next
      Merge branch arm64/for-next/sme2 into kvmarm/next
      Merge branch kvm-arm64/virtual-cache-geometry into kvmarm/next
      Merge branch kvm-arm64/parallel-access-faults into kvmarm/next
      Merge branch kvm-arm64/MAINTAINERS into kvmarm/next
      Merge branch kvm-arm64/nv-timer-improvements into kvmarm/next
      Merge branch kvm-arm64/psci-relay-fixes into kvmarm/next
      Merge branch kvm-arm64/apple-vgic-mi into kvmarm/next
      Merge branch kvm-arm64/misc into kvmarm/next
      Merge branch kvm-arm64/nv-prefix into kvmarm/next

Paolo Bonzini (15):
      Merge branch 'kvm-late-6.1' into HEAD
      Merge branch 'kvm-hw-enable-refactor' into HEAD
      Merge branch 'kvm-v6.2-rc4-fixes' into HEAD
      Merge branch 'kvm-lapic-fix-and-cleanup' into HEAD
      Merge tag 'kvm-x86-generic-6.3' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-misc-6.3' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-mmu-6.3' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-pmu-6.3' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-selftests-6.3' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-svm-6.3' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-vmx-6.3' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-riscv-6.3-1' of https://github.com/kvm-riscv/linux into HEAD
      Merge tag 'kvm-s390-next-6.3-1' of https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux into HEAD
      Merge tag 'kvmarm-6.3' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD
      Merge tag 'kvm-x86-apic-6.3' of https://github.com/kvm-x86/linux into HEAD

Paul Durrant (2):
      KVM: x86/cpuid: generalize kvm_update_kvm_cpuid_base() and also capture limit
      KVM: x86/xen: update Xen CPUID Leaf 4 (tsc info) sub-leaves, if present

Peter Gonda (1):
      KVM: SVM: Fix potential overflow in SEV's send|receive_update_data()

Quentin Perret (4):
      KVM: arm64: Provide sanitized SYS_ID_AA64SMFR0_EL1 to nVHE
      KVM: arm64: Introduce finalise_el2_state macro
      KVM: arm64: Use sanitized values in __check_override in nVHE
      KVM: arm64: Finalise EL2 state from pKVM PSCI relay

Randy Dunlap (1):
      KVM: SVM: hyper-v: placate modpost section mismatch error

Reiji Watanabe (1):
      KVM: selftests: kvm_vm_elf_load() and elfhdr_get() should close fd

Sean Christopherson (105):
      KVM: x86/mmu: Replace open coded usage of tdp_mmu_page with is_tdp_mmu_page()
      KVM: x86/mmu: Pivot on "TDP MMU enabled" to check if active MMU is TDP MMU
      KVM: x86/mmu: Pivot on "TDP MMU enabled" when handling direct page faults
      KVM: x86/mmu: Replace open coded usage of tdp_mmu_page with is_tdp_mmu_page()
      KVM: x86/mmu: Pivot on "TDP MMU enabled" to check if active MMU is TDP MMU
      KVM: x86/mmu: Pivot on "TDP MMU enabled" when handling direct page faults
      KVM: Register /dev/kvm as the _very_ last thing during initialization
      KVM: Initialize IRQ FD after arch hardware setup
      KVM: Allocate cpus_hardware_enabled after arch hardware setup
      KVM: Teardown VFIO ops earlier in kvm_exit()
      KVM: s390: Unwind kvm_arch_init() piece-by-piece() if a step fails
      KVM: s390: Move hardware setup/unsetup to init/exit
      KVM: x86: Do timer initialization after XCR0 configuration
      KVM: x86: Move hardware setup/unsetup to init/exit
      KVM: Drop arch hardware (un)setup hooks
      KVM: VMX: Reset eVMCS controls in VP assist page during hardware disabling
      KVM: VMX: Don't bother disabling eVMCS static key on module exit
      KVM: VMX: Move Hyper-V eVMCS initialization to helper
      KVM: x86: Move guts of kvm_arch_init() to standalone helper
      KVM: VMX: Do _all_ initialization before exposing /dev/kvm to userspace
      KVM: x86: Serialize vendor module initialization (hardware setup)
      KVM: arm64: Free hypervisor allocations if vector slot init fails
      KVM: arm64: Unregister perf callbacks if hypervisor finalization fails
      KVM: arm64: Do arm/arch initialization without bouncing through kvm_init()
      KVM: arm64: Mark kvm_arm_init() and its unique descendants as __init
      KVM: MIPS: Hardcode callbacks to hardware virtualization extensions
      KVM: MIPS: Setup VZ emulation? directly from kvm_mips_init()
      KVM: MIPS: Register die notifier prior to kvm_init()
      KVM: RISC-V: Do arch init directly in riscv_kvm_init()
      KVM: RISC-V: Tag init functions and data with __init, __ro_after_init
      KVM: PPC: Move processor compatibility check to module init
      KVM: s390: Do s390 specific init without bouncing through kvm_init()
      KVM: s390: Mark __kvm_s390_init() and its descendants as __init
      KVM: Drop kvm_arch_{init,exit}() hooks
      KVM: VMX: Make VMCS configuration/capabilities structs read-only after init
      KVM: x86: Do CPU compatibility checks in x86 code
      KVM: Drop kvm_arch_check_processor_compat() hook
      KVM: x86: Use KBUILD_MODNAME to specify vendor module name
      KVM: x86: Unify pr_fmt to use module name for all KVM modules
      KVM: VMX: Use current CPU's info to perform "disabled by BIOS?" checks
      KVM: x86: Do VMX/SVM support checks directly in vendor code
      KVM: VMX: Shuffle support checks and hardware enabling code around
      KVM: SVM: Check for SVM support in CPU compatibility checks
      KVM: x86: Move CPU compat checks hook to kvm_x86_ops (from kvm_x86_init_ops)
      KVM: Ensure CPU is stable during low level hardware enable/disable
      KVM: Use a per-CPU variable to track which CPUs have enabled virtualization
      KVM: Register syscore (suspend/resume) ops early in kvm_init()
      KVM: Opt out of generic hardware enabling on s390 and PPC
      KVM: Clean up error labels in kvm_init()
      KVM: x86: Blindly get current x2APIC reg value on "nodecode write" traps
      KVM: x86: Purge "highest ISR" cache when updating APICv state
      KVM: SVM: Flush the "current" TLB when activating AVIC
      KVM: SVM: Process ICR on AVIC IPI delivery failure due to invalid target
      KVM: x86: Don't inhibit APICv/AVIC on xAPIC ID "change" if APIC is disabled
      KVM: x86: Don't inhibit APICv/AVIC if xAPIC ID mismatch is due to 32-bit ID
      KVM: SVM: Don't put/load AVIC when setting virtual APIC mode
      KVM: x86: Handle APICv updates for APIC "mode" changes via request
      KVM: x86: Move APIC access page helper to common x86 code
      KVM: x86: Inhibit APIC memslot if x2APIC and AVIC are enabled
      KVM: SVM: Replace "avic_mode" enum with "x2avic_enabled" boolean
      KVM: SVM: Compute dest based on sender's x2APIC status for AVIC kick
      Revert "KVM: SVM: Use target APIC ID to complete x2AVIC IRQs when possible"
      KVM: SVM: Document that vCPU ID == APIC ID in AVIC kick fastpatch
      KVM: SVM: Add helper to perform final AVIC "kick" of single vCPU
      KVM: x86: Explicitly skip optimized logical map setup if vCPU's LDR==0
      KVM: x86: Explicitly track all possibilities for APIC map's logical modes
      KVM: x86: Skip redundant x2APIC logical mode optimized cluster setup
      KVM: x86: Disable APIC logical map if logical ID covers multiple MDAs
      KVM: x86: Disable APIC logical map if vCPUs are aliased in logical mode
      KVM: x86: Honor architectural behavior for aliased 8-bit APIC IDs
      KVM: x86: Inhibit APICv/AVIC if the optimized physical map is disabled
      KVM: SVM: Inhibit AVIC if vCPUs are aliased in logical mode
      KVM: SVM: Always update local APIC on writes to logical dest register
      KVM: SVM: Update svm->ldr_reg cache even if LDR is "bad"
      KVM: SVM: Require logical ID to be power-of-2 for AVIC entry
      KVM: SVM: Handle multiple logical targets in AVIC kick fastpath
      KVM: SVM: Ignore writes to Remote Read Data on AVIC write traps
      Revert "KVM: SVM: Do not throw warning when calling avic_vcpu_load on a running vcpu"
      KVM: x86: Track required APICv inhibits with variable, not callback
      KVM: x86: Add helpers to recalc physical vs. logical optimized APIC maps
      KVM: PPC: Fix refactoring goof in kvmppc_e500mc_init()
      KVM: x86: Inject #GP if WRMSR sets reserved bits in APIC Self-IPI
      KVM: x86: Inject #GP on x2APIC WRMSR that sets reserved bits 63:32
      KVM: x86: Mark x2APIC DFR reg as non-existent for x2APIC
      KVM: x86: Split out logic to generate "readable" APIC regs mask to helper
      KVM: VMX: Always intercept accesses to unsupported "extended" x2APIC regs
      KVM: VMX: Intercept reads to invalid and write-only x2APIC registers
      x86/crash: Disable virt in core NMI crash handler to avoid double shootdown
      x86/virt: Force GIF=1 prior to disabling SVM (for reboot flows)
      x86/reboot: Disable virtualization in an emergency if SVM is supported
      x86/reboot: Disable SVM, not just VMX, when stopping CPUs
      KVM: VMX: Access @flags as a 32-bit value in __vmx_vcpu_run()
      KVM: x86: Make vmx_get_exit_qual() and vmx_get_intr_info() noinstr-friendly
      KVM: VMX: Allow VM-Fail path of VMREAD helper to be instrumented
      KVM: VMX: Always inline eVMCS read/write helpers
      KVM: VMX: Always inline to_vmx() and to_kvm_vmx()
      x86/entry: KVM: Use dedicated VMX NMI entry for 32-bit kernels too
      KVM: VMX: Provide separate subroutines for invoking NMI vs. IRQ handlers
      KVM: VMX: Handle NMI VM-Exits in noinstr region
      KVM: x86/pmu: Cap kvm_pmu_cap.num_counters_gp at KVM's internal max
      KVM: x86/pmu: Gate all "unimplemented MSR" prints on report_ignored_msrs
      KVM: x86/pmu: Use separate array for defining "PMU MSRs to save"
      KVM: x86/pmu: Don't tell userspace to save PMU MSRs if PMU is disabled
      KVM: x86/pmu: Provide "error" semantics for unsupported-but-known PMU MSRs
      KVM: Destroy target device if coalesced MMIO unregistration fails

Shaoqin Huang (3):
      KVM: selftests: Remove redundant setbuf()
      selftests: KVM: Replace optarg with arg in guest_modes_cmdline
      KVM: selftests: Remove duplicate macro definition

Suravee Suthikulpanit (1):
      KVM: SVM: Fix x2APIC Logical ID calculation for avic_kick_target_vcpus_fast

Thomas Huth (4):
      KVM: selftests: Use TAP interface in the kvm_binary_stats_test
      KVM: selftests: x86: Use TAP interface in the tsc_msrs_test
      KVM: selftests: Use TAP interface in the kvm_binary_stats_test
      KVM: selftests: x86: Use TAP interface in the tsc_msrs_test

Vipin Sharma (5):
      KVM: x86: hyper-v: Use common code for hypercall userspace exit
      KVM: x86: hyper-v: Add extended hypercall support in Hyper-v
      KVM: selftests: Test Hyper-V extended hypercall enablement
      KVM: selftests: Replace hardcoded Linux OS id with HYPERV_LINUX_OS_ID
      KVM: selftests: Test Hyper-V extended hypercall exit to userspace

Vishal Annapurve (3):
      KVM: selftests: x86: Use "this_cpu" prefix for cpu vendor queries
      KVM: selftests: x86: Cache host CPU vendor (AMD vs. Intel)
      KVM: selftests: x86: Use host's native hypercall instruction in kvm_hypercall()

Vitaly Kuznetsov (22):
      KVM: nVMX: Sanitize primary processor-based VM-execution controls with eVMCS too
      KVM: nVMX: Invert 'unsupported by eVMCSv1' check
      KVM: nVMX: Prepare to sanitize tertiary execution controls with eVMCS
      KVM: VMX: Resurrect vmcs_conf sanitization for KVM-on-Hyper-V
      x86/hyperv: Add HV_EXPOSE_INVARIANT_TSC define
      KVM: x86: Add a KVM-only leaf for CPUID_8000_0007_EDX
      KVM: x86: Hyper-V invariant TSC control
      KVM: selftests: Rename 'msr->available' to 'msr->fault_exepected' in hyperv_features test
      KVM: selftests: Convert hyperv_features test to using KVM_X86_CPU_FEATURE()
      KVM: selftests: Test that values written to Hyper-V MSRs are preserved
      KVM: selftests: Test Hyper-V invariant TSC control
      KVM: nVMX: Sanitize primary processor-based VM-execution controls with eVMCS too
      KVM: nVMX: Invert 'unsupported by eVMCSv1' check
      KVM: nVMX: Prepare to sanitize tertiary execution controls with eVMCS
      KVM: VMX: Resurrect vmcs_conf sanitization for KVM-on-Hyper-V
      x86/hyperv: Add HV_EXPOSE_INVARIANT_TSC define
      KVM: x86: Add a KVM-only leaf for CPUID_8000_0007_EDX
      KVM: x86: Hyper-V invariant TSC control
      KVM: selftests: Rename 'msr->available' to 'msr->fault_exepected' in hyperv_features test
      KVM: selftests: Convert hyperv_features test to using KVM_X86_CPU_FEATURE()
      KVM: selftests: Test that values written to Hyper-V MSRs are preserved
      KVM: selftests: Test Hyper-V invariant TSC control

Wang Liang (1):
      kvm_host.h: fix spelling typo in function declaration

Wang Yong (1):
      KVM: update code comment in struct kvm_vcpu

Wei Liu (1):
      KVM: x86/mmu: fix an incorrect comment in kvm_mmu_new_pgd()

Yu Zhang (3):
      KVM: MMU: Make the definition of 'INVALID_GPA' common
      KVM: VMX: Do not trap VMFUNC instructions for L1 guests.
      KVM: nVMX: Simplify the setting of SECONDARY_EXEC_ENABLE_VMFUNC for nested.

ye xingchen (1):
      KVM: x86: Replace IS_ERR() with IS_ERR_VALUE()

zhang songyi (3):
      KVM: x86: remove redundant ret variable
      KVM: x86/xen: Remove unneeded semicolon
      KVM: SVM: remove redundant ret variable

 Documentation/admin-guide/kernel-parameters.txt    |   7 +-
 Documentation/virt/kvm/api.rst                     | 124 +++-
 Documentation/virt/kvm/devices/vm.rst              |   4 +
 Documentation/virt/kvm/locking.rst                 |  25 +-
 Documentation/virt/kvm/x86/errata.rst              |  11 +
 MAINTAINERS                                        |   3 +-
 arch/arm64/include/asm/cache.h                     |   9 +
 arch/arm64/include/asm/el2_setup.h                 |  99 +++
 arch/arm64/include/asm/esr.h                       |   4 +
 arch/arm64/include/asm/kvm_arm.h                   |  23 +-
 arch/arm64/include/asm/kvm_emulate.h               |  70 ++-
 arch/arm64/include/asm/kvm_host.h                  |  67 +-
 arch/arm64/include/asm/kvm_hyp.h                   |   1 +
 arch/arm64/include/asm/kvm_mmu.h                   |  15 +-
 arch/arm64/include/asm/kvm_nested.h                |  20 +
 arch/arm64/include/asm/kvm_pgtable.h               |   8 +
 arch/arm64/include/asm/sysreg.h                    |  39 +-
 arch/arm64/include/uapi/asm/kvm.h                  |   1 +
 arch/arm64/kernel/cacheinfo.c                      |   5 -
 arch/arm64/kernel/cpufeature.c                     |  25 +
 arch/arm64/kernel/hyp-stub.S                       |  86 +--
 arch/arm64/kvm/Kconfig                             |   1 +
 arch/arm64/kvm/Makefile                            |   2 +-
 arch/arm64/kvm/arch_timer.c                        | 106 ++--
 arch/arm64/kvm/arm.c                               | 109 ++--
 arch/arm64/kvm/emulate-nested.c                    | 203 +++++++
 arch/arm64/kvm/fpsimd.c                            |   1 +
 arch/arm64/kvm/guest.c                             |   6 +
 arch/arm64/kvm/handle_exit.c                       |  47 +-
 arch/arm64/kvm/hyp/exception.c                     |  48 +-
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h         |  21 +-
 arch/arm64/kvm/hyp/nvhe/hyp-init.S                 |   1 +
 arch/arm64/kvm/hyp/nvhe/sys_regs.c                 |   1 +
 arch/arm64/kvm/hyp/pgtable.c                       |  43 +-
 arch/arm64/kvm/hyp/vhe/switch.c                    |  26 +-
 arch/arm64/kvm/hypercalls.c                        |   2 +-
 arch/arm64/kvm/inject_fault.c                      |  61 +-
 arch/arm64/kvm/mmu.c                               |  46 +-
 arch/arm64/kvm/nested.c                            | 161 +++++
 arch/arm64/kvm/pvtime.c                            |   8 +-
 arch/arm64/kvm/reset.c                             |  25 +-
 arch/arm64/kvm/sys_regs.c                          | 459 ++++++++++----
 arch/arm64/kvm/sys_regs.h                          |  14 +-
 arch/arm64/kvm/trace_arm.h                         |  59 ++
 arch/arm64/kvm/vgic/vgic-init.c                    |  21 +-
 arch/arm64/kvm/vgic/vgic-mmio.c                    |  13 +-
 arch/arm64/kvm/vgic/vgic-v3.c                      |   9 +-
 arch/arm64/kvm/vmid.c                              |   6 +-
 arch/arm64/tools/cpucaps                           |   1 +
 arch/arm64/tools/gen-sysreg.awk                    |  20 +-
 arch/arm64/tools/sysreg                            |  17 +
 arch/mips/include/asm/kvm_host.h                   |   3 +-
 arch/mips/kvm/Kconfig                              |   1 +
 arch/mips/kvm/Makefile                             |   2 +-
 arch/mips/kvm/callback.c                           |  14 -
 arch/mips/kvm/mips.c                               |  34 +-
 arch/mips/kvm/vz.c                                 |   7 +-
 arch/powerpc/include/asm/kvm_host.h                |   3 -
 arch/powerpc/include/asm/kvm_ppc.h                 |   1 -
 arch/powerpc/kvm/book3s.c                          |  12 +-
 arch/powerpc/kvm/booke.c                           |   2 +-
 arch/powerpc/kvm/e500.c                            |   6 +-
 arch/powerpc/kvm/e500mc.c                          |   8 +-
 arch/powerpc/kvm/powerpc.c                         |  20 -
 arch/riscv/include/asm/kvm_host.h                  |  11 +-
 arch/riscv/include/asm/kvm_vcpu_pmu.h              | 107 ++++
 arch/riscv/include/asm/kvm_vcpu_sbi.h              |  13 +-
 arch/riscv/include/asm/sbi.h                       |   7 +-
 arch/riscv/kvm/Kconfig                             |   1 +
 arch/riscv/kvm/Makefile                            |   1 +
 arch/riscv/kvm/main.c                              |  26 +-
 arch/riscv/kvm/mmu.c                               |  20 +-
 arch/riscv/kvm/tlb.c                               |   4 +
 arch/riscv/kvm/vcpu.c                              |   7 +
 arch/riscv/kvm/vcpu_exit.c                         |   9 +
 arch/riscv/kvm/vcpu_insn.c                         |   4 +-
 arch/riscv/kvm/vcpu_pmu.c                          | 633 +++++++++++++++++++
 arch/riscv/kvm/vcpu_sbi.c                          |  72 ++-
 arch/riscv/kvm/vcpu_sbi_base.c                     |  27 +-
 arch/riscv/kvm/vcpu_sbi_hsm.c                      |  28 +-
 arch/riscv/kvm/vcpu_sbi_pmu.c                      |  86 +++
 arch/riscv/kvm/vcpu_sbi_replace.c                  |  50 +-
 arch/riscv/kvm/vcpu_sbi_v01.c                      |  17 +-
 arch/riscv/kvm/vmid.c                              |   4 +-
 arch/s390/include/asm/kvm_host.h                   |   1 -
 arch/s390/kvm/gaccess.c                            | 109 ++++
 arch/s390/kvm/gaccess.h                            |   3 +
 arch/s390/kvm/interrupt.c                          |  13 +-
 arch/s390/kvm/kvm-s390.c                           | 348 ++++++-----
 arch/s390/kvm/kvm-s390.h                           |   2 +-
 arch/s390/kvm/pci.c                                |   2 +-
 arch/s390/kvm/pci.h                                |   2 +-
 arch/x86/events/intel/core.c                       |   1 +
 arch/x86/events/intel/ds.c                         |   4 +-
 arch/x86/include/asm/cpufeatures.h                 |   3 +
 arch/x86/include/asm/hyperv-tlfs.h                 |   3 +
 arch/x86/include/asm/idtentry.h                    |  16 +-
 arch/x86/include/asm/kvm-x86-ops.h                 |   2 +-
 arch/x86/include/asm/kvm_host.h                    | 109 ++--
 arch/x86/include/asm/reboot.h                      |   2 +
 arch/x86/include/asm/virtext.h                     |  16 +-
 arch/x86/include/asm/xen/hypervisor.h              |   4 +-
 arch/x86/include/uapi/asm/kvm.h                    |  34 +-
 arch/x86/kernel/cpu/mshyperv.c                     |   2 +-
 arch/x86/kernel/crash.c                            |  17 +-
 arch/x86/kernel/nmi.c                              |   8 +-
 arch/x86/kernel/reboot.c                           |  88 ++-
 arch/x86/kernel/smp.c                              |   6 +-
 arch/x86/kvm/Kconfig                               |   1 +
 arch/x86/kvm/cpuid.c                               |  43 +-
 arch/x86/kvm/debugfs.c                             |   2 +
 arch/x86/kvm/emulate.c                             |  18 +-
 arch/x86/kvm/hyperv.c                              |  85 ++-
 arch/x86/kvm/hyperv.h                              |  27 +
 arch/x86/kvm/i8254.c                               |   4 +-
 arch/x86/kvm/i8259.c                               |   4 +-
 arch/x86/kvm/ioapic.c                              |   1 +
 arch/x86/kvm/irq.c                                 |   1 +
 arch/x86/kvm/irq_comm.c                            |   7 +-
 arch/x86/kvm/kvm_cache_regs.h                      |  12 +
 arch/x86/kvm/kvm_emulate.h                         |   7 +-
 arch/x86/kvm/kvm_onhyperv.c                        |   1 +
 arch/x86/kvm/lapic.c                               | 404 +++++++++----
 arch/x86/kvm/lapic.h                               |   4 +
 arch/x86/kvm/mmu.h                                 |   6 +-
 arch/x86/kvm/mmu/mmu.c                             | 320 ++++++----
 arch/x86/kvm/mmu/mmu_internal.h                    |  22 +-
 arch/x86/kvm/mmu/page_track.c                      |   1 +
 arch/x86/kvm/mmu/paging_tmpl.h                     |  25 +-
 arch/x86/kvm/mmu/spte.c                            |  10 +-
 arch/x86/kvm/mmu/spte.h                            |  20 +-
 arch/x86/kvm/mmu/tdp_iter.c                        |  12 +-
 arch/x86/kvm/mmu/tdp_mmu.c                         |  20 +-
 arch/x86/kvm/mmu/tdp_mmu.h                         |  25 +-
 arch/x86/kvm/mtrr.c                                |   1 +
 arch/x86/kvm/pmu.c                                 | 290 +++++++--
 arch/x86/kvm/pmu.h                                 |  13 +-
 arch/x86/kvm/reverse_cpuid.h                       |   7 +
 arch/x86/kvm/smm.c                                 |   3 +-
 arch/x86/kvm/svm/avic.c                            | 374 +++++-------
 arch/x86/kvm/svm/nested.c                          |   5 +-
 arch/x86/kvm/svm/pmu.c                             |   4 +
 arch/x86/kvm/svm/sev.c                             |   7 +-
 arch/x86/kvm/svm/svm.c                             | 131 ++--
 arch/x86/kvm/svm/svm.h                             |  58 +-
 arch/x86/kvm/svm/svm_onhyperv.c                    |   1 +
 arch/x86/kvm/svm/svm_onhyperv.h                    |   8 +-
 arch/x86/kvm/vmx/capabilities.h                    |   4 +-
 arch/x86/kvm/vmx/hyperv.c                          |  87 ++-
 arch/x86/kvm/vmx/hyperv.h                          | 128 ++--
 arch/x86/kvm/vmx/nested.c                          |  24 +-
 arch/x86/kvm/vmx/pmu_intel.c                       |  28 +-
 arch/x86/kvm/vmx/posted_intr.c                     |   2 +
 arch/x86/kvm/vmx/sgx.c                             |   5 +-
 arch/x86/kvm/vmx/vmcs.h                            |   4 +-
 arch/x86/kvm/vmx/vmcs12.c                          |   1 +
 arch/x86/kvm/vmx/vmenter.S                         |  80 +--
 arch/x86/kvm/vmx/vmx.c                             | 624 ++++++++++---------
 arch/x86/kvm/vmx/vmx.h                             |  18 +-
 arch/x86/kvm/vmx/vmx_ops.h                         |   6 +-
 arch/x86/kvm/x86.c                                 | 557 +++++++++--------
 arch/x86/kvm/x86.h                                 |  18 +-
 arch/x86/kvm/xen.c                                 |  27 +
 arch/x86/kvm/xen.h                                 |   7 +
 drivers/irqchip/irq-apple-aic.c                    |  53 +-
 drivers/perf/riscv_pmu_sbi.c                       |  64 +-
 drivers/s390/virtio/virtio_ccw.c                   |  46 +-
 include/kvm/arm_arch_timer.h                       |   6 +-
 include/kvm/arm_vgic.h                             |   4 +
 include/linux/cpuhotplug.h                         |   5 +-
 include/linux/kvm_host.h                           |  19 +-
 include/linux/kvm_types.h                          |   2 +-
 include/linux/perf/riscv_pmu.h                     |   5 +
 include/uapi/linux/kvm.h                           |   9 +
 tools/testing/selftests/kvm/Makefile               |   4 +
 .../selftests/kvm/aarch64/page_fault_test.c        |   2 -
 tools/testing/selftests/kvm/config                 |   1 +
 .../testing/selftests/kvm/include/x86_64/hyperv.h  | 149 +++--
 .../selftests/kvm/include/x86_64/processor.h       |  31 +-
 .../testing/selftests/kvm/kvm_binary_stats_test.c  |  21 +-
 tools/testing/selftests/kvm/lib/elf.c              |   2 +
 tools/testing/selftests/kvm/lib/guest_modes.c      |   2 +-
 tools/testing/selftests/kvm/lib/kvm_util.c         |   4 +-
 tools/testing/selftests/kvm/lib/x86_64/processor.c |  46 +-
 tools/testing/selftests/kvm/memslot_perf_test.c    |   5 +-
 tools/testing/selftests/kvm/s390x/memop.c          | 672 ++++++++++++++++-----
 .../kvm/x86_64/exit_on_emulation_failure_test.c    |   3 -
 .../selftests/kvm/x86_64/fix_hypercall_test.c      |   4 +-
 tools/testing/selftests/kvm/x86_64/hyperv_clock.c  |   2 +-
 .../kvm/x86_64/hyperv_extended_hypercalls.c        |  97 +++
 .../testing/selftests/kvm/x86_64/hyperv_features.c | 339 +++++++----
 .../selftests/kvm/x86_64/mmio_warning_test.c       |   2 +-
 .../selftests/kvm/x86_64/pmu_event_filter_test.c   | 385 +++++++++++-
 tools/testing/selftests/kvm/x86_64/tsc_msrs_test.c |  16 +-
 .../vmx_exception_with_invalid_guest_state.c       |   2 +-
 .../selftests/kvm/x86_64/xapic_state_test.c        |  55 ++
 .../testing/selftests/kvm/x86_64/xen_shinfo_test.c |  15 +-
 virt/kvm/Kconfig                                   |   3 +
 virt/kvm/coalesced_mmio.c                          |   8 +-
 virt/kvm/kvm_main.c                                | 297 ++++-----
 200 files changed, 7274 insertions(+), 2928 deletions(-)

diff --cc arch/x86/include/asm/cpufeatures.h
index 389ea336258f,cdb7e1492311..000000000000
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@@ -314,8 -312,9 +314,11 @@@
  #define X86_FEATURE_AVX_VNNI		(12*32+ 4) /* AVX VNNI instructions */
  #define X86_FEATURE_AVX512_BF16		(12*32+ 5) /* AVX512 BFLOAT16 instructions */
  #define X86_FEATURE_CMPCCXADD           (12*32+ 7) /* "" CMPccXADD instructions */
 +#define X86_FEATURE_ARCH_PERFMON_EXT	(12*32+ 8) /* "" Intel Architectural PerfMon Extension */
+ #define X86_FEATURE_FZRM		(12*32+10) /* "" Fast zero-length REP MOVSB */
+ #define X86_FEATURE_FSRS		(12*32+11) /* "" Fast short REP STOSB */
+ #define X86_FEATURE_FSRC		(12*32+12) /* "" Fast short REP {CMPSB,SCASB} */
 +#define X86_FEATURE_LKGS		(12*32+18) /* "" Load "kernel" (userspace) GS */
  #define X86_FEATURE_AMX_FP16		(12*32+21) /* "" AMX fp16 Support */
  #define X86_FEATURE_AVX_IFMA            (12*32+23) /* "" Support for VPMADD52[H,L]UQ */
  
diff --cc arch/x86/kvm/reverse_cpuid.h
index 81f4e9ce0c77,4945456fd646..000000000000
--- a/arch/x86/kvm/reverse_cpuid.h
+++ b/arch/x86/kvm/reverse_cpuid.h
@@@ -68,7 -72,7 +72,8 @@@ static const struct cpuid_reg reverse_c
  	[CPUID_12_EAX]        = {0x00000012, 0, CPUID_EAX},
  	[CPUID_8000_001F_EAX] = {0x8000001f, 0, CPUID_EAX},
  	[CPUID_7_1_EDX]       = {         7, 1, CPUID_EDX},
+ 	[CPUID_8000_0007_EDX] = {0x80000007, 0, CPUID_EDX},
 +	[CPUID_8000_0021_EAX] = {0x80000021, 0, CPUID_EAX},
  };
  
  /*

