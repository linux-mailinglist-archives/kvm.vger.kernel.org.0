Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E330402D8A
	for <lists+kvm@lfdr.de>; Tue,  7 Sep 2021 19:16:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345590AbhIGRRv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Sep 2021 13:17:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:26549 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233525AbhIGRRu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 Sep 2021 13:17:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631035003;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=KImahOKXIQrPPnR9Np3v7k5ZF82wtXrbsu3LtBjMTkw=;
        b=KP9Cm6z8Ts2n5AlsuTqwFMr64xG3UVLYQbNWFBuBMhycBov5uJ8fq/Nn+eFGQWfnIMbo3q
        R22FkyEiTYGQHYnNajUhvVVEJjQUIb3PN7n9kzaybBaYe8OzfgQwRJJ03EaMAqgqQ/Uagg
        cnwntjo7wMppR5itaEvKnbGS0Ga/pWU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-31-Jf_KXPQBPQ6GyM6FOc0faw-1; Tue, 07 Sep 2021 13:16:42 -0400
X-MC-Unique: Jf_KXPQBPQ6GyM6FOc0faw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0AD6E107AD25;
        Tue,  7 Sep 2021 17:16:41 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8F81760BE5;
        Tue,  7 Sep 2021 17:16:40 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] KVM changes for Linux 5.15
Date:   Tue,  7 Sep 2021 13:16:39 -0400
Message-Id: <20210907171639.574037-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

this is a bit late due to my own vacation.  But there are no conflicts

The following changes since commit ce25681d59ffc4303321e555a2d71b1946af07da:

  KVM: x86/mmu: Protect marking SPs unsync when using TDP MMU with spinlock (2021-08-13 03:32:14 -0400)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 109bbba5066b42431399b40e947243f049d8dc8d:

  KVM: Drop unused kvm_dirty_gfn_invalid() (2021-09-06 08:23:46 -0400)

----------------------------------------------------------------
ARM:

- Page ownership tracking between host EL1 and EL2

- Rely on userspace page tables to create large stage-2 mappings

- Fix incompatibility between pKVM and kmemleak

- Fix the PMU reset state, and improve the performance of the virtual PMU

- Move over to the generic KVM entry code

- Address PSCI reset issues w.r.t. save/restore

- Preliminary rework for the upcoming pKVM fixed feature

- A bunch of MM cleanups

- a vGIC fix for timer spurious interrupts

- Various cleanups

s390:

- enable interpretation of specification exceptions

- fix a vcpu_idx vs vcpu_id mixup

x86:

- fast (lockless) page fault support for the new MMU

- new MMU now the default

- increased maximum allowed VCPU count

- allow inhibit IRQs on KVM_RUN while debugging guests

- let Hyper-V-enabled guests run with virtualized LAPIC as long as they
  do not enable the Hyper-V "AutoEOI" feature

- fixes and optimizations for the toggling of AMD AVIC (virtualized LAPIC)

- tuning for the case when two-dimensional paging (EPT/NPT) is disabled

- bugfixes and cleanups, especially with respect to 1) vCPU reset and
  2) choosing a paging mode based on CR0/CR4/EFER

- support for 5-level page table on AMD processors

Generic:

- MMU notifier invalidation callbacks do not take mmu_lock unless necessary

- improved caching of LRU kvm_memory_slot

- support for histogram statistics

- add statistics for halt polling and remote TLB flush requests

----------------------------------------------------------------
Alexandre Chartre (1):
      KVM: arm64: Disabling disabled PMU counters wastes a lot of time

Anshuman Khandual (8):
      KVM: arm64: perf: Replace '0xf' instances with ID_AA64DFR0_PMUVER_IMP_DEF
      arm64/mm: Define ID_AA64MMFR0_TGRAN_2_SHIFT
      KVM: arm64: Restrict IPA size to maximum 48 bits on 4K and 16K page size
      arm64/mm: Add remaining ID_AA64MMFR0_PARANGE_ macros
      KVM: arm64: Use ARM64_MIN_PARANGE_BITS as the minimum supported IPA
      KVM: arm64: Drop init_common_resources()
      KVM: arm64: Drop check_kvm_target_cpu() based percpu probe
      KVM: arm64: Drop unused REQUIRES_VIRT

David Brazdil (1):
      KVM: arm64: Minor optimization of range_is_memory

David Matlack (12):
      KVM: x86/mmu: Rename cr2_or_gpa to gpa in fast_page_fault
      KVM: x86/mmu: Fix use of enums in trace_fast_page_fault
      KVM: x86/mmu: Make walk_shadow_page_lockless_{begin,end} interoperate with the TDP MMU
      KVM: x86/mmu: fast_page_fault support for the TDP MMU
      KVM: Rename lru_slot to last_used_slot
      KVM: Move last_used_slot logic out of search_memslots
      KVM: Cache the last used slot index per vCPU
      KVM: x86/mmu: Leverage vcpu->last_used_slot in tdp_mmu_map_handle_target_level
      KVM: x86/mmu: Leverage vcpu->last_used_slot for rmap_add and rmap_recycle
      KVM: x86/mmu: Rename __gfn_to_rmap to gfn_to_rmap
      KVM: selftests: Support multiple slots in dirty_log_perf_test
      KVM: selftests: Move vcpu_args_set into perf_test_util

Eduardo Habkost (3):
      kvm: x86: Set KVM_MAX_VCPU_ID to 4*KVM_MAX_VCPUS
      kvm: x86: Increase MAX_VCPUS to 1024
      kvm: x86: Increase KVM_SOFT_MAX_VCPUS to 710

Fuad Tabba (10):
      KVM: arm64: placeholder to check if VM is protected
      KVM: arm64: Remove trailing whitespace in comment
      KVM: arm64: MDCR_EL2 is a 64-bit register
      KVM: arm64: Fix names of config register fields
      KVM: arm64: Refactor sys_regs.h,c for nVHE reuse
      KVM: arm64: Restore mdcr_el2 from vcpu
      KVM: arm64: Keep mdcr_el2's value as set by __init_el2_debug
      KVM: arm64: Track value of cptr_el2 in struct kvm_vcpu_arch
      KVM: arm64: Add feature register flag definitions
      KVM: arm64: Add config register bit definitions

Halil Pasic (1):
      KVM: s390: index kvm->arch.idle_mask by vcpu_idx

Hamza Mahfooz (1):
      KVM: const-ify all relevant uses of struct kvm_memory_slot

Huacai Chen (1):
      KVM: MIPS: Remove a "set but not used" variable

Janis Schoetterl-Glausch (1):
      KVM: s390: Enable specification exception interpretation

Jason Wang (1):
      KVM: arm64: Fix comments related to GICv2 PMR reporting

Jia He (1):
      KVM: x86/mmu: Remove unused field mmio_cached in struct kvm_mmu_page

Jing Zhang (6):
      KVM: stats: Support linear and logarithmic histogram statistics
      KVM: stats: Update doc for histogram statistics
      KVM: selftests: Add checks for histogram stats bucket_size field
      KVM: stats: Add halt_wait_ns stats for all architectures
      KVM: stats: Add halt polling related histogram stats
      KVM: stats: Add VM stat for remote tlb flush requests

Juergen Gross (1):
      x86/kvm: remove non-x86 stuff from arch/x86/kvm/ioapic.h

Lai Jiangshan (2):
      KVM: X86: Remove unneeded KVM_DEBUGREG_RELOAD
      x86/kvm: Don't enable IRQ when IRQ enabled in kvm_wait

Like Xu (2):
      KVM: x86/pmu: Introduce pmc->is_paused to reduce the call time of perf interfaces
      KVM: x86: Clean up redundant ROL16(val, n) macro definition

Marc Zyngier (28):
      KVM: arm64: Walk userspace page tables to compute the THP mapping size
      KVM: arm64: Avoid mapping size adjustment on permission fault
      KVM: Remove kvm_is_transparent_hugepage() and PageTransCompoundMap()
      KVM: arm64: Use get_page() instead of kvm_get_pfn()
      KVM: arm64: Introduce helper to retrieve a PTE and its level
      KVM: Get rid of kvm_get_pfn()
      KVM: arm64: Narrow PMU sysreg reset values to architectural requirements
      KVM: arm64: Drop unnecessary masking of PMU registers
      KVM: arm64: Remove PMSWINC_EL0 shadow register
      arm64: Move .hyp.rodata outside of the _sdata.._edata range
      KVM: arm64: Unregister HYP sections from kmemleak in protected mode
      KVM: arm64: vgic: Resample HW pending state on deactivation
      KVM: arm64: Move kern_hyp_va() usage in __load_guest_stage2() into the callers
      KVM: arm64: Unify stage-2 programming behind __load_stage2()
      KVM: arm64: Upgrade VMID accesses to {READ,WRITE}_ONCE
      KVM: arm64: Upgrade trace_kvm_arm_set_dreg32() to 64bit
      Merge branch arm64/for-next/sysreg into kvm-arm64/misc-5.15
      Merge tag 'kvmarm-fixes-5.14-2' into kvm-arm64/mmu/el2-tracking
      Merge branch kvm-arm64/pmu/reset-values into kvmarm-master/next
      Merge branch kvm-arm64/mmu/mapping-levels into kvmarm-master/next
      Merge branch kvm-arm64/misc-5.15 into kvmarm-master/next
      Merge branch kvm-arm64/mmu/kmemleak-pkvm into kvmarm-master/next
      Merge branch kvm-arm64/mmu/el2-tracking into kvmarm-master/next
      Merge branch kvm-arm64/psci/cpu_on into kvmarm-master/next
      Merge branch kvm-arm64/generic-entry into kvmarm-master/next
      Merge branch kvm-arm64/mmu/vmid-cleanups into kvmarm-master/next
      Merge branch kvm-arm64/pkvm-fixed-features-prologue into kvmarm-master/next
      Merge branch kvm-arm64/misc-5.15 into kvmarm-master/next

Maxim Levitsky (19):
      KVM: x86: APICv: drop immediate APICv disablement on current vCPU
      KVM: x86/mmu: fix parameters to kvm_flush_remote_tlbs_with_address
      KVM: x86/mmu: add comment explaining arguments to kvm_zap_gfn_range
      KVM: x86/mmu: bump mmu notifier count in kvm_zap_gfn_range
      KVM: x86/mmu: rename try_async_pf to kvm_faultin_pfn
      KVM: x86/mmu: allow kvm_faultin_pfn to return page fault handling code
      KVM: x86/mmu: allow APICv memslot to be enabled but invisible
      KVM: x86: don't disable APICv memslot when inhibited
      KVM: x86: APICv: fix race in kvm_request_apicv_update on SVM
      KVM: SVM: add warning for mistmatch between AVIC vcpu state and AVIC inhibition
      KVM: SVM: remove svm_toggle_avic_for_irq_window
      KVM: SVM: avoid refreshing avic if its state didn't change
      KVM: SVM: move check for kvm_vcpu_apicv_active outside of avic_vcpu_{put|load}
      KVM: SVM: call avic_vcpu_load/avic_vcpu_put when enabling/disabling AVIC
      KVM: SVM: AVIC: drop unsupported AVIC base relocation code
      KVM: SVM: split svm_handle_invalid_exit
      KVM: x86: implement KVM_GUESTDBG_BLOCKIRQ
      KVM: selftests: test KVM_GUESTDBG_BLOCKIRQ
      KVM: VMX: avoid running vmx_handle_exit_irqoff in case of emulation

Mingwei Zhang (2):
      KVM: x86/mmu: Remove redundant spte present check in mmu_set_spte
      KVM: x86/mmu: Add detailed page size stats

Oliver Upton (7):
      KVM: arm64: Fix read-side race on updates to vcpu reset state
      KVM: arm64: Handle PSCI resets before userspace touches vCPU state
      KVM: arm64: Enforce reserved bits for PSCI target affinities
      selftests: KVM: Introduce psci_cpu_on_test
      KVM: arm64: Record number of signal exits as a vCPU stat
      entry: KVM: Allow use of generic KVM entry w/o full generic support
      KVM: arm64: Use generic KVM xfer to guest work function

Paolo Bonzini (15):
      KVM: arm64: Count VMID-wide TLB invalidations
      KVM: x86: enable TDP MMU by default
      KVM: nSVM: remove useless kvm_clear_*_queue
      KVM: Block memslot updates across range_start() and range_end()
      KVM: Don't take mmu_lock for range invalidation unless necessary
      KVM: xen: do not use struct gfn_to_hva_cache
      Merge branch 'kvm-vmx-secctl' into HEAD
      Merge branch 'kvm-tdpmmu-fixes' into HEAD
      KVM: X86: Set host DR6 only on VMX and for KVM_DEBUGREG_WONT_EXIT
      KVM: VMX: Reset DR6 only when KVM_DEBUGREG_WONT_EXIT
      KVM: stats: remove dead stores
      KVM: x86: clamp host mapping level to max_level in kvm_mmu_max_mapping_level
      Merge tag 'kvm-s390-next-5.15-1' of git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux into HEAD
      Merge tag 'kvmarm-5.15' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD
      KVM: MMU: mark role_regs and role accessors as maybe unused

Peter Xu (9):
      KVM: X86: Add per-vm stat for max rmap list size
      KVM: Introduce kvm_get_kvm_safe()
      KVM: X86: MMU: Tune PTE_LIST_EXT to be bigger
      KVM: X86: Optimize pte_list_desc with per-array counter
      KVM: X86: Optimize zapping rmap
      KVM: Allow to have arch-specific per-vm debugfs files
      KVM: X86: Introduce kvm_mmu_slot_lpages() helpers
      KVM: X86: Introduce mmu_rmaps_stat per-vm debugfs file
      KVM: Drop unused kvm_dirty_gfn_invalid()

Quentin Perret (20):
      KVM: arm64: Introduce hyp_assert_lock_held()
      KVM: arm64: Provide the host_stage2_try() helper macro
      KVM: arm64: Expose page-table helpers
      KVM: arm64: Optimize host memory aborts
      KVM: arm64: Rename KVM_PTE_LEAF_ATTR_S2_IGNORED
      KVM: arm64: Don't overwrite software bits with owner id
      KVM: arm64: Tolerate re-creating hyp mappings to set software bits
      KVM: arm64: Enable forcing page-level stage-2 mappings
      KVM: arm64: Allow populating software bits
      KVM: arm64: Add helpers to tag shared pages in SW bits
      KVM: arm64: Expose host stage-2 manipulation helpers
      KVM: arm64: Expose pkvm_hyp_id
      KVM: arm64: Introduce addr_is_memory()
      KVM: arm64: Enable retrieving protections attributes of PTEs
      KVM: arm64: Mark host bss and rodata section as shared
      KVM: arm64: Remove __pkvm_mark_hyp
      KVM: arm64: Refactor protected nVHE stage-1 locking
      KVM: arm64: Restrict EL2 stage-1 changes in protected mode
      KVM: arm64: Make __pkvm_create_mappings static
      KVM: arm64: Return -EPERM from __pkvm_host_share_hyp()

Raghavendra Rao Ananta (1):
      KVM: arm64: Trim guest debug exception handling

Ricardo Koller (1):
      KVM: arm64: vgic: Drop WARN from vgic_get_irq

Sean Christopherson (64):
      KVM: Add infrastructure and macro to mark VM as bugged
      KVM: Export kvm_make_all_cpus_request() for use in marking VMs as bugged
      KVM: x86: Use KVM_BUG/KVM_BUG_ON to handle bugs that are fatal to the VM
      KVM: x86/mmu: Mark VM as bugged if page fault returns RET_PF_INVALID
      KVM: x86: Hoist kvm_dirty_regs check out of sync_regs()
      KVM: x86/mmu: Refactor shadow walk in __direct_map() to reduce indentation
      KVM: x86/mmu: Return old SPTE from mmu_spte_clear_track_bits()
      KVM: x86: Flush the guest's TLB on INIT
      KVM: nVMX: Set LDTR to its architecturally defined value on nested VM-Exit
      KVM: SVM: Zero out GDTR.base and IDTR.base on INIT
      KVM: VMX: Set EDX at INIT with CPUID.0x1, Family-Model-Stepping
      KVM: SVM: Require exact CPUID.0x1 match when stuffing EDX at INIT
      KVM: SVM: Fall back to KVM's hardcoded value for EDX at RESET/INIT
      KVM: VMX: Remove explicit MMU reset in enter_rmode()
      KVM: SVM: Drop explicit MMU reset at RESET/INIT
      KVM: x86: WARN if the APIC map is dirty without an in-kernel local APIC
      KVM: x86: Remove defunct BSP "update" in local APIC reset
      KVM: x86: Migrate the PIT only if vcpu0 is migrated, not any BSP
      KVM: x86: Don't force set BSP bit when local APIC is managed by userspace
      KVM: x86: Set BSP bit in reset BSP vCPU's APIC base by default
      KVM: VMX: Stuff vcpu->arch.apic_base directly at vCPU RESET
      KVM: x86: Open code necessary bits of kvm_lapic_set_base() at vCPU RESET
      KVM: x86: Consolidate APIC base RESET initialization code
      KVM: x86: Move EDX initialization at vCPU RESET to common code
      KVM: SVM: Don't bother writing vmcb->save.rip at vCPU RESET/INIT
      KVM: VMX: Invert handling of CR0.WP for EPT without unrestricted guest
      KVM: VMX: Remove direct write to vcpu->arch.cr0 during vCPU RESET/INIT
      KVM: VMX: Fold ept_update_paging_mode_cr0() back into vmx_set_cr0()
      KVM: nVMX: Do not clear CR3 load/store exiting bits if L1 wants 'em
      KVM: VMX: Pull GUEST_CR3 from the VMCS iff CR3 load exiting is disabled
      KVM: x86/mmu: Skip the permission_fault() check on MMIO if CR0.PG=0
      KVM: VMX: Process CR0.PG side effects after setting CR0 assets
      KVM: VMX: Skip emulation required checks during pmode/rmode transitions
      KVM: nVMX: Don't evaluate "emulation required" on nested VM-Exit
      KVM: SVM: Tweak order of cr0/cr4/efer writes at RESET/INIT
      KVM: SVM: Drop redundant writes to vmcb->save.cr4 at RESET/INIT
      KVM: SVM: Stuff save->dr6 at during VMSA sync, not at RESET/INIT
      KVM: VMX: Skip pointless MSR bitmap update when setting EFER
      KVM: VMX: Refresh list of user return MSRs after setting guest CPUID
      KVM: VMX: Don't _explicitly_ reconfigure user return MSRs on vCPU INIT
      KVM: x86: Move setting of sregs during vCPU RESET/INIT to common x86
      KVM: VMX: Remove obsolete MSR bitmap refresh at vCPU RESET/INIT
      KVM: nVMX: Remove obsolete MSR bitmap refresh at nested transitions
      KVM: VMX: Don't redo x2APIC MSR bitmaps when userspace filter is changed
      KVM: VMX: Remove unnecessary initialization of msr_bitmap_mode
      KVM: VMX: Smush x2APIC MSR bitmap adjustments into single function
      KVM: VMX: Remove redundant write to set vCPU as active at RESET/INIT
      KVM: VMX: Move RESET-only VMWRITE sequences to init_vmcs()
      KVM: SVM: Emulate #INIT in response to triple fault shutdown
      KVM: SVM: Drop redundant clearing of vcpu->arch.hflags at INIT/RESET
      KVM: x86: Preserve guest's CR0.CD/NW on INIT
      KVM: nVMX: Pull KVM L0's desired controls directly from vmcs01
      KVM: VMX: Drop caching of KVM's desired sec exec controls for vmcs01
      KVM: VMX: Hide VMCS control calculators in vmx.c
      KVM: x86: Kill off __ex() and __kvm_handle_fault_on_reboot()
      KVM: nVMX: Unconditionally clear nested.pi_pending on nested VM-Enter
      Revert "KVM: x86/mmu: Allow zap gfn range to operate under the mmu read lock"
      KVM: x86/mmu: Avoid collision with !PRESENT SPTEs in TDP MMU lpage stats
      KVM: x86/mmu: Drop 'shared' param from tdp_mmu_link_page()
      KVM: x86/mmu: Don't freak out if pml5_root is NULL on 4-level host
      Revert "KVM: x86: mmu: Add guest physical address check in translate_gpa()"
      KVM: x86/mmu: Relocate kvm_mmu_page.tdp_mmu_page for better cache locality
      KVM: x86/mmu: Move lpage_disallowed_link further "down" in kvm_mmu_page
      KVM: Remove unnecessary export of kvm_{inc,dec}_notifier_count()

Uros Bizjak (1):
      KVM: x86: Move declaration of kvm_spurious_fault() to x86.h

Vitaly Kuznetsov (1):
      KVM: x86: hyper-v: Deactivate APICv only when AutoEOI feature is in use

Wei Huang (3):
      KVM: x86: Allow CPU to force vendor-specific TDP level
      KVM: x86/mmu: Support shadowing NPT when 5-level paging is enabled in host
      KVM: SVM: Add 5-level page table support for SVM

Will Deacon (2):
      KVM: arm64: Add hyp_spin_is_locked() for basic locking assertions at EL2
      KVM: arm64: Make hyp_panic() more robust when protected mode is enabled

Zelin Deng (1):
      KVM: x86: Update vCPU's hv_clock before back to guest when tsc_offset is adjusted

 Documentation/virt/kvm/api.rst                     |  36 +-
 Documentation/virt/kvm/locking.rst                 |   6 +
 arch/arm64/include/asm/cpufeature.h                |  18 +-
 arch/arm64/include/asm/kvm_arm.h                   |  54 ++-
 arch/arm64/include/asm/kvm_asm.h                   |   7 +-
 arch/arm64/include/asm/kvm_host.h                  |  17 +-
 arch/arm64/include/asm/kvm_hyp.h                   |   2 +-
 arch/arm64/include/asm/kvm_mmu.h                   |  17 +-
 arch/arm64/include/asm/kvm_pgtable.h               | 168 +++++--
 arch/arm64/include/asm/sysreg.h                    |  26 +-
 arch/arm64/kernel/cpufeature.c                     |   8 +-
 arch/arm64/kernel/vmlinux.lds.S                    |   4 +-
 arch/arm64/kvm/Kconfig                             |  10 +
 arch/arm64/kvm/arm.c                               | 161 +++----
 arch/arm64/kvm/debug.c                             |   2 +-
 arch/arm64/kvm/guest.c                             |   9 +-
 arch/arm64/kvm/handle_exit.c                       |  43 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h            |   6 +-
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h      |  35 +-
 arch/arm64/kvm/hyp/include/nvhe/mm.h               |   3 +-
 arch/arm64/kvm/hyp/include/nvhe/spinlock.h         |  25 +
 arch/arm64/kvm/hyp/nvhe/debug-sr.c                 |   2 +-
 arch/arm64/kvm/hyp/nvhe/host.S                     |  21 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c                 |  20 +-
 arch/arm64/kvm/hyp/nvhe/mem_protect.c              | 244 ++++++++--
 arch/arm64/kvm/hyp/nvhe/mm.c                       |  22 +-
 arch/arm64/kvm/hyp/nvhe/setup.c                    |  82 +++-
 arch/arm64/kvm/hyp/nvhe/switch.c                   |  17 +-
 arch/arm64/kvm/hyp/nvhe/tlb.c                      |   4 +-
 arch/arm64/kvm/hyp/pgtable.c                       | 247 +++++-----
 arch/arm64/kvm/hyp/vhe/debug-sr.c                  |   2 +-
 arch/arm64/kvm/hyp/vhe/switch.c                    |  18 +-
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c                 |   2 +-
 arch/arm64/kvm/hyp/vhe/tlb.c                       |   4 +-
 arch/arm64/kvm/mmu.c                               |  76 ++-
 arch/arm64/kvm/perf.c                              |   2 +-
 arch/arm64/kvm/pmu-emul.c                          |  14 +-
 arch/arm64/kvm/psci.c                              |  15 +-
 arch/arm64/kvm/reset.c                             |  43 +-
 arch/arm64/kvm/sys_regs.c                          | 134 +++---
 arch/arm64/kvm/sys_regs.h                          |  31 ++
 arch/arm64/kvm/trace_handle_exit.h                 |  10 +-
 arch/arm64/kvm/vgic/vgic-mmio-v2.c                 |   4 +-
 arch/arm64/kvm/vgic/vgic-v2.c                      |  36 +-
 arch/arm64/kvm/vgic/vgic-v3.c                      |  36 +-
 arch/arm64/kvm/vgic/vgic.c                         |  39 +-
 arch/arm64/kvm/vgic/vgic.h                         |   2 +
 arch/mips/kvm/mips.c                               |   4 -
 arch/mips/kvm/vz.c                                 |   3 +-
 arch/powerpc/include/asm/kvm_host.h                |   1 -
 arch/powerpc/kvm/book3s.c                          |   5 -
 arch/powerpc/kvm/book3s_64_vio.c                   |   2 +-
 arch/powerpc/kvm/book3s_64_vio_hv.c                |   2 +-
 arch/powerpc/kvm/book3s_hv.c                       |  18 +-
 arch/powerpc/kvm/booke.c                           |   5 -
 arch/s390/include/asm/kvm_host.h                   |   2 +
 arch/s390/kvm/interrupt.c                          |  12 +-
 arch/s390/kvm/kvm-s390.c                           |  12 +-
 arch/s390/kvm/kvm-s390.h                           |   2 +-
 arch/s390/kvm/vsie.c                               |   2 +
 arch/x86/include/asm/kvm-x86-ops.h                 |   1 -
 arch/x86/include/asm/kvm_host.h                    |  96 ++--
 arch/x86/include/uapi/asm/kvm.h                    |   1 +
 arch/x86/kernel/kvm.c                              |   5 +-
 arch/x86/kvm/debugfs.c                             | 111 +++++
 arch/x86/kvm/hyperv.c                              |  32 +-
 arch/x86/kvm/i8254.c                               |   3 +-
 arch/x86/kvm/ioapic.h                              |   4 -
 arch/x86/kvm/lapic.c                               |  26 +-
 arch/x86/kvm/mmu.h                                 |  25 +
 arch/x86/kvm/mmu/mmu.c                             | 524 +++++++++++++--------
 arch/x86/kvm/mmu/mmu_audit.c                       |   4 +-
 arch/x86/kvm/mmu/mmu_internal.h                    |  18 +-
 arch/x86/kvm/mmu/mmutrace.h                        |   6 +
 arch/x86/kvm/mmu/page_track.c                      |   1 +
 arch/x86/kvm/mmu/paging_tmpl.h                     |   6 +-
 arch/x86/kvm/mmu/tdp_mmu.c                         | 139 ++++--
 arch/x86/kvm/mmu/tdp_mmu.h                         |  29 +-
 arch/x86/kvm/pmu.c                                 |   5 +-
 arch/x86/kvm/pmu.h                                 |   2 +-
 arch/x86/kvm/svm/avic.c                            |  49 +-
 arch/x86/kvm/svm/nested.c                          |   5 -
 arch/x86/kvm/svm/sev.c                             |   3 +-
 arch/x86/kvm/svm/svm.c                             |  97 ++--
 arch/x86/kvm/svm/svm.h                             |   8 -
 arch/x86/kvm/svm/svm_ops.h                         |   2 +-
 arch/x86/kvm/vmx/evmcs.c                           |   1 -
 arch/x86/kvm/vmx/evmcs.h                           |   4 -
 arch/x86/kvm/vmx/nested.c                          |  56 ++-
 arch/x86/kvm/vmx/pmu_intel.c                       |   4 +-
 arch/x86/kvm/vmx/vmcs.h                            |   2 +
 arch/x86/kvm/vmx/vmcs12.c                          |   1 -
 arch/x86/kvm/vmx/vmcs12.h                          |   4 -
 arch/x86/kvm/vmx/vmx.c                             | 333 +++++++------
 arch/x86/kvm/vmx/vmx.h                             |  38 +-
 arch/x86/kvm/vmx/vmx_ops.h                         |   4 +-
 arch/x86/kvm/x86.c                                 | 189 +++++---
 arch/x86/kvm/x86.h                                 |   2 +
 arch/x86/kvm/xen.c                                 |  23 +-
 arch/x86/kvm/xen.h                                 |   5 +
 include/linux/entry-kvm.h                          |   6 +-
 include/linux/kvm_host.h                           | 236 ++++++++--
 include/linux/kvm_types.h                          |   7 +
 include/linux/page-flags.h                         |  37 --
 include/uapi/linux/kvm.h                           |  11 +-
 tools/testing/selftests/kvm/.gitignore             |   1 +
 tools/testing/selftests/kvm/Makefile               |   1 +
 .../selftests/kvm/aarch64/psci_cpu_on_test.c       | 121 +++++
 .../selftests/kvm/access_tracking_perf_test.c      |   4 +-
 tools/testing/selftests/kvm/demand_paging_test.c   |   3 +-
 tools/testing/selftests/kvm/dirty_log_perf_test.c  |  77 ++-
 .../selftests/kvm/include/aarch64/processor.h      |   3 +
 .../testing/selftests/kvm/include/perf_test_util.h |   2 +-
 .../testing/selftests/kvm/kvm_binary_stats_test.c  |  12 +
 tools/testing/selftests/kvm/lib/perf_test_util.c   |  22 +-
 .../kvm/memslot_modification_stress_test.c         |   3 +-
 tools/testing/selftests/kvm/x86_64/debug_regs.c    |  24 +-
 virt/kvm/binary_stats.c                            |   2 -
 virt/kvm/dirty_ring.c                              |   5 -
 virt/kvm/kvm_main.c                                | 197 ++++++--
 120 files changed, 2891 insertions(+), 1605 deletions(-)

