Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F889745B73
	for <lists+kvm@lfdr.de>; Mon,  3 Jul 2023 13:45:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231328AbjGCLpd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Jul 2023 07:45:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbjGCLpb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Jul 2023 07:45:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCC50198
        for <kvm@vger.kernel.org>; Mon,  3 Jul 2023 04:44:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688384679;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=OLCLLDr69ATElEllQCQVmEiwPYT+A1Ldq7PNvmXE4lI=;
        b=g37lYP9b6toZ8euvks1Nw7LaM8cBJqNToQRRsX7g7jccPzFE1ecXhQzjt436PQE/Qe8flt
        lzPow6CJoEn2AA1FnuKK7bBmUt+QTB1IJcEYgFYowgWUVyjCW/B04wxGIdA+5Brx7pRSqw
        esT7XiU6VJmYYo3kEYIAz+vMH3q4GRw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-527-xx54p5IcO0aRa5ZmozZpoA-1; Mon, 03 Jul 2023 07:44:36 -0400
X-MC-Unique: xx54p5IcO0aRa5ZmozZpoA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 344903C18FEA;
        Mon,  3 Jul 2023 11:44:36 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0F7A11121314;
        Mon,  3 Jul 2023 11:44:36 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] KVM changes for Linux 6.5
Date:   Mon,  3 Jul 2023 07:44:35 -0400
Message-Id: <20230703114435.645750-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit 6995e2de6891c724bfeb2db33d7b87775f913ad1:

  Linux 6.4 (2023-06-25 16:29:58 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 255006adb3da71bb75c334453786df781b415f54:

  Merge tag 'kvm-x86-vmx-6.5' of https://github.com/kvm-x86/linux into HEAD (2023-07-01 07:20:04 -0400)

A fairly small set of changes this time.  There are some conflicts with
the pull requests from architecture maintainers (ARM, RISC-V and the
maintainer handbooks index in Documentation/), but they're trivial.

----------------------------------------------------------------
ARM64:

* Eager page splitting optimization for dirty logging, optionally
  allowing for a VM to avoid the cost of hugepage splitting in the stage-2
  fault path.

* Arm FF-A proxy for pKVM, allowing a pKVM host to safely interact with
  services that live in the Secure world. pKVM intervenes on FF-A calls
  to guarantee the host doesn't misuse memory donated to the hyp or a
  pKVM guest.

* Support for running the split hypervisor with VHE enabled, known as
  'hVHE' mode. This is extremely useful for testing the split
  hypervisor on VHE-only systems, and paves the way for new use cases
  that depend on having two TTBRs available at EL2.

* Generalized framework for configurable ID registers from userspace.
  KVM/arm64 currently prevents arbitrary CPU feature set configuration
  from userspace, but the intent is to relax this limitation and allow
  userspace to select a feature set consistent with the CPU.

* Enable the use of Branch Target Identification (FEAT_BTI) in the
  hypervisor.

* Use a separate set of pointer authentication keys for the hypervisor
  when running in protected mode, as the host is untrusted at runtime.

* Ensure timer IRQs are consistently released in the init failure
  paths.

* Avoid trapping CTR_EL0 on systems with Enhanced Virtualization Traps
  (FEAT_EVT), as it is a register commonly read from userspace.

* Erratum workaround for the upcoming AmpereOne part, which has broken
  hardware A/D state management.

RISC-V:

* Redirect AMO load/store misaligned traps to KVM guest

* Trap-n-emulate AIA in-kernel irqchip for KVM guest

* Svnapot support for KVM Guest

s390:

* New uvdevice secret API

* CMM selftest and fixes

* fix racy access to target CPU for diag 9c

x86:

* Fix missing/incorrect #GP checks on ENCLS

* Use standard mmu_notifier hooks for handling APIC access page

* Drop now unnecessary TR/TSS load after VM-Exit on AMD

* Print more descriptive information about the status of SEV and SEV-ES during
  module load

* Add a test for splitting and reconstituting hugepages during and after
  dirty logging

* Add support for CPU pinning in demand paging test

* Add support for AMD PerfMonV2, with a variety of cleanups and minor fixes
  included along the way

* Add a "nx_huge_pages=never" option to effectively avoid creating NX hugepage
  recovery threads (because nx_huge_pages=off can be toggled at runtime)

* Move handling of PAT out of MTRR code and dedup SVM+VMX code

* Fix output of PIC poll command emulation when there's an interrupt

* Add a maintainer's handbook to document KVM x86 processes, preferred coding
  style, testing expectations, etc.

* Misc cleanups, fixes and comments

Generic:

* Miscellaneous bugfixes and cleanups

Selftests:

* Generate dependency files so that partial rebuilds work as expected

----------------------------------------------------------------
Alexander Mikhalitsyn (1):
      KVM: SVM: enhance info printk's in SEV init

Andrew Jones (3):
      RISC-V: KVM: Rename dis_idx to ext_idx
      RISC-V: KVM: Convert extension_disabled[] to ext_status[]
      RISC-V: KVM: Probe for SBI extension status

Andy Shevchenko (1):
      KVM: x86: Remove PRIx* definitions as they are solely for user space

Anup Patel (11):
      RISC-V: KVM: Implement guest external interrupt line management
      RISC-V: KVM: Add IMSIC related defines
      RISC-V: KVM: Add APLIC related defines
      RISC-V: KVM: Set kvm_riscv_aia_nr_hgei to zero
      RISC-V: KVM: Skeletal in-kernel AIA irqchip support
      RISC-V: KVM: Implement device interface for AIA irqchip
      RISC-V: KVM: Add in-kernel emulation of AIA APLIC
      RISC-V: KVM: Expose APLIC registers as attributes of AIA irqchip
      RISC-V: KVM: Add in-kernel virtualization of AIA IMSIC
      RISC-V: KVM: Expose IMSIC registers as attributes of AIA irqchip
      RISC-V: KVM: Allow Svnapot extension for Guest/VM

Arnd Bergmann (1):
      arm64: kvm: avoid overflow in integer division

Ben Dooks (1):
      riscv: kvm: define vcpu_sbi_ext_pmu in header

Ben Gardon (2):
      KVM: selftests: Move dirty logging functions to memstress.(c|h)
      KVM: selftests: Add dirty logging page splitting test

Binbin Wu (2):
      KVM: Fix comment for KVM_ENABLE_CAP
      KVM: x86: Fix a typo in Documentation/virt/kvm/x86/mmu.rst

Chao Gao (1):
      KVM: x86: Correct the name for skipping VMENTER l1d flush

Christian Borntraeger (1):
      KVM: s390/diag: fix racy access of physical cpu number in diag 9c handler

Colin Ian King (1):
      KVM: selftests: Fix spelling mistake "miliseconds" -> "milliseconds"

Dan Carpenter (1):
      KVM: arm64: timers: Fix resource leaks in kvm_timer_hyp_init()

Fuad Tabba (1):
      KVM: arm64: Handle FFA_FEATURES call from the host

Jing Zhang (5):
      KVM: arm64: Reuse fields of sys_reg_desc for idreg
      KVM: arm64: Save ID registers' sanitized value per guest
      KVM: arm64: Use arm64_ftr_bits to sanitise ID register writes
      KVM: arm64: Use generic sanitisation for ID_(AA64)DFR0_EL1
      KVM: arm64: Use generic sanitisation for ID_AA64PFR0_EL1

Jinliang Zheng (1):
      KVM: x86: Fix poll command

Jinrong Liang (1):
      KVM: x86/pmu: Remove redundant check for MSR_IA32_DS_AREA set handler

Jon Kohler (1):
      KVM: VMX: restore vmx_vmexit alignment

Ke Guo (1):
      KVM: SVM: Use kvm_pat_valid() directly instead of kvm_mtrr_valid()

Like Xu (12):
      KVM: x86/mmu: Assert on @mmu in the __kvm_mmu_invalidate_addr()
      KVM: x86/pmu: Move reprogram_counters() to pmu.h
      KVM: x86/pmu: Reject userspace attempts to set reserved GLOBAL_STATUS bits
      KVM: x86/pmu: Move handling PERF_GLOBAL_CTRL and friends to common x86
      KVM: x86/pmu: Provide Intel PMU's pmc_is_enabled() as generic x86 code
      KVM: x86: Explicitly zero cpuid "0xa" leaf when PMU is disabled
      KVM: x86/pmu: Disable vPMU if the minimum num of counters isn't met
      KVM: x86/pmu: Advertise PERFCTR_CORE iff the min nr of counters is met
      KVM: x86/pmu: Constrain the num of guest counters with kvm_pmu_cap
      KVM: x86/cpuid: Add a KVM-only leaf to redirect AMD PerfMonV2 flag
      KVM: x86/svm/pmu: Add AMD PerfMonV2 support
      KVM: x86/cpuid: Add AMD CPUID ExtPerfMonAndDbg leaf 0x80000022

Marc Zyngier (19):
      KVM: arm64: Use local TLBI on permission relaxation
      KVM: arm64: Relax trapping of CTR_EL0 when FEAT_EVT is available
      KVM: arm64: Drop is_kernel_in_hyp_mode() from __invalidate_icache_guest_page()
      arm64: Prevent the use of is_kernel_in_hyp_mode() in hypervisor code
      arm64: Turn kaslr_feature_override into a generic SW feature override
      arm64: Add KVM_HVHE capability and has_hvhe() predicate
      arm64: Don't enable VHE for the kernel if OVERRIDE_HVHE is set
      arm64: Allow EL1 physical timer access when running VHE
      arm64: Use CPACR_EL1 format to set CPTR_EL2 when E2H is set
      KVM: arm64: Remove alternatives from sysreg accessors in VHE hypervisor context
      KVM: arm64: Key use of VHE instructions in nVHE code off ARM64_KVM_HVHE
      KVM: arm64: Force HCR_EL2.E2H when ARM64_KVM_HVHE is set
      KVM: arm64: Disable TTBR1_EL2 when using ARM64_KVM_HVHE
      KVM: arm64: Adjust EL2 stage-1 leaf AP bits when ARM64_KVM_HVHE is set
      KVM: arm64: Rework CPTR_EL2 programming for HVHE configuration
      KVM: arm64: Program the timer traps with VHE layout in hVHE mode
      KVM: arm64: Force HCR_E2H in guest context when ARM64_KVM_HVHE is set
      arm64: Allow arm64_sw.hvhe on command line
      KVM: arm64: Fix hVHE init on CPUs where HCR_EL2.E2H is not RES1

Michal Luczaj (3):
      KVM: Don't kfree(NULL) on kzalloc() failure in kvm_assign_ioeventfd_idx()
      KVM: Clean up kvm_vm_ioctl_create_vcpu()
      KVM: x86: Clean up: remove redundant bool conversions

Mingwei Zhang (1):
      KVM: SVM: Remove TSS reloading code after VMEXIT

Mostafa Saleh (2):
      KVM: arm64: Use BTI for nvhe
      KVM: arm64: Use different pointer authentication keys for pKVM

Nico Boehr (2):
      KVM: s390: fix KVM_S390_GET_CMMA_BITS for GFNs in memslot holes
      KVM: s390: selftests: add selftest for CMMA migration

Oliver Upton (17):
      KVM: arm64: Separate out feature sanitisation and initialisation
      KVM: arm64: Relax invariance of KVM_ARM_VCPU_POWER_OFF
      KVM: arm64: Make vCPU feature flags consistent VM-wide
      KVM: arm64: Rewrite IMPDEF PMU version as NI
      KVM: arm64: Handle ID register reads using the VM-wide values
      KVM: arm64: Rip out the vestiges of the 'old' ID register scheme
      Merge branch kvm-arm64/eager-page-splitting into kvmarm/next
      Merge branch kvm-arm64/ffa-proxy into kvmarm/next
      Merge branch kvm-arm64/hvhe into kvmarm/next
      Merge branch for-next/module-alloc into kvmarm/next
      Merge branch kvm-arm64/configurable-id-regs into kvmarm/next
      Merge branch kvm-arm64/misc into kvmarm/next
      arm64: errata: Mitigate Ampere1 erratum AC03_CPU_38 at stage-2
      KVM: arm64: Refactor HFGxTR configuration into separate helpers
      KVM: arm64: Prevent guests from enabling HA/HD on Ampere1
      Merge branch kvm-arm64/ampere1-hafdbs-mitigation into kvmarm/next
      KVM: arm64: Fix misuse of KVM_ARM_VCPU_POWER_OFF bit index

Paolo Bonzini (11):
      KVM: selftests: touch all pages of args on each memstress iteration
      Merge tag 'kvm-s390-next-6.5-1' of https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux into HEAD
      Merge tag 'kvm-riscv-6.5-1' of https://github.com/kvm-riscv/linux into HEAD
      Merge tag 'kvmarm-6.5' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD
      Merge tag 'kvm-x86-generic-6.5' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-misc-6.5' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-mmu-6.5' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-pmu-6.5' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-selftests-6.5' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-svm-6.5' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-vmx-6.5' of https://github.com/kvm-x86/linux into HEAD

Peter Xu (3):
      KVM: selftests: Setup vcpu_alias only for minor mode test
      KVM: selftests: Allow dumping per-vcpu info for uffd threads
      KVM: selftests: Allow specify physical cpu list in demand paging test

Pierre Morel (1):
      KVM: s390: vsie: fix the length of APCB bitmap

Quentin Perret (1):
      KVM: arm64: pkvm: Add support for fragmented FF-A descriptors

Ricardo Koller (11):
      KVM: arm64: Rename free_removed to free_unlinked
      KVM: arm64: Add KVM_PGTABLE_WALK flags for skipping CMOs and BBM TLBIs
      KVM: arm64: Add helper for creating unlinked stage2 subtrees
      KVM: arm64: Export kvm_are_all_memslots_empty()
      KVM: arm64: Add KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE
      KVM: arm64: Add kvm_pgtable_stage2_split()
      KVM: arm64: Refactor kvm_arch_commit_memory_region()
      KVM: arm64: Add kvm_uninit_stage2_mmu()
      KVM: arm64: Split huge pages when dirty logging is enabled
      KVM: arm64: Open-code kvm_mmu_write_protect_pt_masked()
      KVM: arm64: Split huge pages during KVM_CLEAR_DIRTY_LOG

Sean Christopherson (25):
      KVM: Protect vcpu->pid dereference via debugfs with RCU
      KVM: VMX: Treat UMIP as emulated if and only if the host doesn't have UMIP
      KVM: VMX: Use proper accessor to read guest CR4 in handle_desc()
      KVM: selftests: Refactor stable TSC check to use TEST_REQUIRE()
      KVM: x86: Add helper to query if variable MTRR MSR is base (versus mask)
      KVM: x86: Add helper to get variable MTRR range from MSR index
      KVM: x86: Use MTRR macros to define possible MTRR MSR ranges
      KVM: x86: Move PAT MSR handling out of mtrr.c
      KVM: x86: Make kvm_mtrr_valid() static now that there are no external users
      KVM: x86: Move common handling of PAT MSR writes to kvm_set_msr_common()
      KVM: x86: Update number of entries for KVM_GET_CPUID2 on success, not failure
      KVM: selftests: Extend cpuid_test to verify KVM_GET_CPUID2 "nent" updates
      KVM: VMX: Inject #GP on ENCLS if vCPU has paging disabled (CR0.PG==0)
      KVM: VMX: Inject #GP, not #UD, if SGX2 ENCLS leafs are unsupported
      KVM: SVM: Invoke trace_kvm_exit() for fastpath VM-Exits
      KVM: VMX: Retry APIC-access page reload if invalidation is in-progress
      KVM: x86: Use standard mmu_notifier invalidate hooks for APIC access page
      KVM: x86/mmu: Trigger APIC-access page reload iff vendor code cares
      KVM: x86: Use cpu_feature_enabled() for PKU instead of #ifdef
      KVM: x86/pmu: Rename global_ovf_ctrl_mask to global_status_mask
      KVM: x86: Update comments about MSR lists exposed to userspace
      KVM: x86/mmu: Add "never" option to allow sticky disabling of nx_huge_pages
      KVM: SVM: WARN, but continue, if misc_cg_set_capacity() fails
      Documentation/process: Add a label for the tip tree handbook's coding style
      Documentation/process: Add a maintainer handbook for KVM x86

Steffen Eiden (7):
      s390/uv: Always export uv_info
      s390/uvdevice: Add info IOCTL
      s390/uvdevice: Add 'Add Secret' UVC
      s390/uvdevice: Add 'List Secrets' UVC
      s390/uvdevice: Add 'Lock Secret Store' UVC
      s390/uv: replace scnprintf with sysfs_emit
      s390/uv: Update query for secret-UVCs

Uros Bizjak (1):
      KVM: x86/mmu: Add comment on try_cmpxchg64 usage in tdp_mmu_set_spte_atomic

Wei Wang (3):
      KVM: allow KVM_BUG/KVM_BUG_ON to handle 64-bit cond
      KVM: destruct kvm_io_device while unregistering it from kvm_io_bus
      kvm/eventfd: use list_for_each_entry when deassign ioeventfd

Wenyao Hai (1):
      KVM: VMX: Open code writing vCPU's PAT in VMX's MSR handler

Will Deacon (8):
      KVM: arm64: Block unsafe FF-A calls from the host
      KVM: arm64: Probe FF-A version and host/hyp partition ID during init
      KVM: arm64: Allocate pages for hypervisor FF-A mailboxes
      KVM: arm64: Handle FFA_RXTX_MAP and FFA_RXTX_UNMAP calls from the host
      KVM: arm64: Add FF-A helpers to share/unshare memory with secure world
      KVM: arm64: Handle FFA_MEM_SHARE calls from the host
      KVM: arm64: Handle FFA_MEM_RECLAIM calls from the host
      KVM: arm64: Handle FFA_MEM_LEND calls from the host

Xiaoyao Li (2):
      KVM: VMX: Use kvm_read_cr4() to get cr4 value
      KVM: VMX: Move the comment of CR4.MCE handling right above the code

Yang Li (1):
      RISC-V: KVM: Remove unneeded semicolon

Ye Xingchen (1):
      RISC-V: KVM: use bitmap_zero() API

Yu Zhang (1):
      KVM: selftests: Add new CFLAGS to generate dependency files

wchen (1):
      RISC-V: KVM: Redirect AMO load/store misaligned traps to guest


 Documentation/arch/arm64/silicon-errata.rst        |    3 +
 Documentation/process/maintainer-handbooks.rst     |    1 +
 Documentation/process/maintainer-kvm-x86.rst       |  390 +++++++
 Documentation/process/maintainer-tip.rst           |    2 +
 Documentation/virt/kvm/api.rst                     |   27 +
 Documentation/virt/kvm/x86/mmu.rst                 |    2 +-
 MAINTAINERS                                        |    1 +
 arch/arm64/Kconfig                                 |   19 +
 arch/arm64/include/asm/cpufeature.h                |    6 +
 arch/arm64/include/asm/el2_setup.h                 |   27 +-
 arch/arm64/include/asm/kvm_arm.h                   |    7 +-
 arch/arm64/include/asm/kvm_asm.h                   |    4 +
 arch/arm64/include/asm/kvm_emulate.h               |   46 +-
 arch/arm64/include/asm/kvm_host.h                  |   61 +-
 arch/arm64/include/asm/kvm_hyp.h                   |   37 +-
 arch/arm64/include/asm/kvm_mmu.h                   |    4 +-
 arch/arm64/include/asm/kvm_pgtable.h               |   79 +-
 arch/arm64/include/asm/kvm_pkvm.h                  |   21 +
 arch/arm64/include/asm/sysreg.h                    |    1 +
 arch/arm64/include/asm/virt.h                      |   12 +-
 arch/arm64/kernel/cpu_errata.c                     |    7 +
 arch/arm64/kernel/cpufeature.c                     |   34 +-
 arch/arm64/kernel/head.S                           |    2 +
 arch/arm64/kernel/hyp-stub.S                       |   10 +-
 arch/arm64/kernel/idreg-override.c                 |   25 +-
 arch/arm64/kernel/kaslr.c                          |    6 +-
 arch/arm64/kvm/arch_timer.c                        |   14 +-
 arch/arm64/kvm/arm.c                               |  209 +++-
 arch/arm64/kvm/fpsimd.c                            |    4 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h            |  101 +-
 arch/arm64/kvm/hyp/include/nvhe/ffa.h              |   17 +
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h      |    3 +
 arch/arm64/kvm/hyp/nvhe/Makefile                   |    2 +-
 arch/arm64/kvm/hyp/nvhe/ffa.c                      |  762 ++++++++++++++
 arch/arm64/kvm/hyp/nvhe/host.S                     |   36 +-
 arch/arm64/kvm/hyp/nvhe/hyp-init.S                 |   32 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c                 |   19 +-
 arch/arm64/kvm/hyp/nvhe/mem_protect.c              |   74 +-
 arch/arm64/kvm/hyp/nvhe/pkvm.c                     |   27 +-
 arch/arm64/kvm/hyp/nvhe/setup.c                    |   11 +
 arch/arm64/kvm/hyp/nvhe/switch.c                   |   28 +-
 arch/arm64/kvm/hyp/nvhe/timer-sr.c                 |   16 +-
 arch/arm64/kvm/hyp/nvhe/tlb.c                      |   52 +
 arch/arm64/kvm/hyp/pgtable.c                       |  228 +++-
 arch/arm64/kvm/hyp/vhe/switch.c                    |    2 +-
 arch/arm64/kvm/hyp/vhe/tlb.c                       |   32 +
 arch/arm64/kvm/mmu.c                               |  209 +++-
 arch/arm64/kvm/pkvm.c                              |    1 +
 arch/arm64/kvm/reset.c                             |   58 --
 arch/arm64/kvm/sys_regs.c                          |  505 ++++++---
 arch/arm64/kvm/sys_regs.h                          |   22 +-
 arch/arm64/tools/cpucaps                           |    3 +
 arch/riscv/include/asm/csr.h                       |    2 +
 arch/riscv/include/asm/kvm_aia.h                   |  107 +-
 arch/riscv/include/asm/kvm_aia_aplic.h             |   58 ++
 arch/riscv/include/asm/kvm_aia_imsic.h             |   38 +
 arch/riscv/include/asm/kvm_host.h                  |    4 +
 arch/riscv/include/asm/kvm_vcpu_sbi.h              |   11 +-
 arch/riscv/include/uapi/asm/kvm.h                  |   73 ++
 arch/riscv/kvm/Kconfig                             |    4 +
 arch/riscv/kvm/Makefile                            |    3 +
 arch/riscv/kvm/aia.c                               |  274 ++++-
 arch/riscv/kvm/aia_aplic.c                         |  619 +++++++++++
 arch/riscv/kvm/aia_device.c                        |  673 ++++++++++++
 arch/riscv/kvm/aia_imsic.c                         | 1084 ++++++++++++++++++++
 arch/riscv/kvm/main.c                              |    3 +-
 arch/riscv/kvm/tlb.c                               |    2 +-
 arch/riscv/kvm/vcpu.c                              |    4 +
 arch/riscv/kvm/vcpu_exit.c                         |    2 +
 arch/riscv/kvm/vcpu_sbi.c                          |   80 +-
 arch/riscv/kvm/vm.c                                |  118 +++
 arch/s390/boot/uv.c                                |    4 +
 arch/s390/include/asm/uv.h                         |   32 +-
 arch/s390/include/uapi/asm/uvdevice.h              |   53 +-
 arch/s390/kernel/uv.c                              |  108 +-
 arch/s390/kvm/diag.c                               |    8 +-
 arch/s390/kvm/kvm-s390.c                           |    4 +
 arch/s390/kvm/vsie.c                               |    6 +-
 arch/x86/include/asm/kvm-x86-pmu-ops.h             |    1 -
 arch/x86/include/asm/kvm_host.h                    |    2 +-
 arch/x86/kvm/cpuid.c                               |   43 +-
 arch/x86/kvm/i8259.c                               |    3 +
 arch/x86/kvm/lapic.c                               |    5 -
 arch/x86/kvm/mmu/mmu.c                             |   53 +-
 arch/x86/kvm/mmu/tdp_mmu.c                         |    5 +-
 arch/x86/kvm/mtrr.c                                |   64 +-
 arch/x86/kvm/pmu.c                                 |   92 +-
 arch/x86/kvm/pmu.h                                 |   56 +-
 arch/x86/kvm/reverse_cpuid.h                       |    7 +
 arch/x86/kvm/svm/pmu.c                             |   68 +-
 arch/x86/kvm/svm/sev.c                             |   19 +-
 arch/x86/kvm/svm/svm.c                             |   56 +-
 arch/x86/kvm/svm/svm.h                             |    1 -
 arch/x86/kvm/vmx/capabilities.h                    |    4 +-
 arch/x86/kvm/vmx/nested.c                          |    7 +-
 arch/x86/kvm/vmx/pmu_intel.c                       |   79 +-
 arch/x86/kvm/vmx/sgx.c                             |   15 +-
 arch/x86/kvm/vmx/vmenter.S                         |    2 +-
 arch/x86/kvm/vmx/vmx.c                             |   77 +-
 arch/x86/kvm/vmx/vmx.h                             |   12 -
 arch/x86/kvm/x86.c                                 |   80 +-
 arch/x86/kvm/x86.h                                 |    1 -
 drivers/s390/char/Kconfig                          |    2 +-
 drivers/s390/char/uvdevice.c                       |  231 ++++-
 include/kvm/arm_pmu.h                              |    8 +-
 include/kvm/iodev.h                                |    6 -
 include/linux/arm_ffa.h                            |    8 +
 include/linux/kvm_host.h                           |    9 +-
 include/uapi/linux/kvm.h                           |    6 +-
 tools/testing/selftests/kvm/Makefile               |   19 +-
 tools/testing/selftests/kvm/demand_paging_test.c   |   32 +-
 tools/testing/selftests/kvm/dirty_log_perf_test.c  |   96 +-
 .../testing/selftests/kvm/include/kvm_util_base.h  |    1 +
 tools/testing/selftests/kvm/include/memstress.h    |    8 +
 tools/testing/selftests/kvm/lib/kvm_util.c         |   17 +
 tools/testing/selftests/kvm/lib/memstress.c        |   75 ++
 tools/testing/selftests/kvm/lib/userfaultfd_util.c |    4 +-
 tools/testing/selftests/kvm/s390x/cmma_test.c      |  700 +++++++++++++
 tools/testing/selftests/kvm/x86_64/cpuid_test.c    |   21 +
 .../kvm/x86_64/dirty_log_page_splitting_test.c     |  259 +++++
 .../selftests/kvm/x86_64/nx_huge_pages_test.c      |    2 +-
 .../kvm/x86_64/vmx_nested_tsc_scaling_test.c       |   22 +-
 virt/kvm/coalesced_mmio.c                          |    9 +-
 virt/kvm/eventfd.c                                 |    8 +-
 virt/kvm/kvm_main.c                                |   51 +-
 125 files changed, 8009 insertions(+), 1012 deletions(-)


diff --cc Documentation/process/maintainer-handbooks.rst
index fe24cb665fb7,d12cbbe2b7df..000000000000
--- a/Documentation/process/maintainer-handbooks.rst
+++ b/Documentation/process/maintainer-handbooks.rst
@@@ -15,6 -15,6 +15,7 @@@ Contents
     :numbered:
     :maxdepth: 2
  
 -   maintainer-tip
 -   maintainer-netdev
+    maintainer-kvm-x86
 +   maintainer-netdev
 +   maintainer-soc
 +   maintainer-tip
diff --cc arch/arm64/kernel/cpufeature.c
index 6ea7f23b1287,3d93147179a0..000000000000
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@@ -2662,27 -2656,23 +2677,44 @@@ static const struct arm64_cpu_capabilit
  		.cpu_enable = cpu_enable_dit,
  		ARM64_CPUID_FIELDS(ID_AA64PFR0_EL1, DIT, IMP)
  	},
 +	{
 +		.desc = "Memory Copy and Memory Set instructions",
 +		.capability = ARM64_HAS_MOPS,
 +		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
 +		.matches = has_cpuid_feature,
 +		.cpu_enable = cpu_enable_mops,
 +		ARM64_CPUID_FIELDS(ID_AA64ISAR2_EL1, MOPS, IMP)
 +	},
 +	{
 +		.capability = ARM64_HAS_TCR2,
 +		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
 +		.matches = has_cpuid_feature,
 +		ARM64_CPUID_FIELDS(ID_AA64MMFR3_EL1, TCRX, IMP)
 +	},
 +	{
 +		.desc = "Stage-1 Permission Indirection Extension (S1PIE)",
 +		.capability = ARM64_HAS_S1PIE,
 +		.type = ARM64_CPUCAP_BOOT_CPU_FEATURE,
 +		.matches = has_cpuid_feature,
 +		ARM64_CPUID_FIELDS(ID_AA64MMFR3_EL1, S1PIE, IMP)
 +	},
+ 	{
+ 		.desc = "VHE for hypervisor only",
+ 		.capability = ARM64_KVM_HVHE,
+ 		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
+ 		.matches = hvhe_possible,
+ 	},
+ 	{
+ 		.desc = "Enhanced Virtualization Traps",
+ 		.capability = ARM64_HAS_EVT,
+ 		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
+ 		.sys_reg = SYS_ID_AA64MMFR2_EL1,
+ 		.sign = FTR_UNSIGNED,
+ 		.field_pos = ID_AA64MMFR2_EL1_EVT_SHIFT,
+ 		.field_width = 4,
+ 		.min_field_value = ID_AA64MMFR2_EL1_EVT_IMP,
+ 		.matches = has_cpuid_feature,
+ 	},
  	{},
  };
  
diff --cc arch/riscv/include/uapi/asm/kvm.h
index 855c047e86d4,a1ca18408bbd..000000000000
--- a/arch/riscv/include/uapi/asm/kvm.h
+++ b/arch/riscv/include/uapi/asm/kvm.h
@@@ -121,7 -122,7 +122,8 @@@ enum KVM_RISCV_ISA_EXT_ID 
  	KVM_RISCV_ISA_EXT_ZICBOZ,
  	KVM_RISCV_ISA_EXT_ZBB,
  	KVM_RISCV_ISA_EXT_SSAIA,
 +	KVM_RISCV_ISA_EXT_V,
+ 	KVM_RISCV_ISA_EXT_SVNAPOT,
  	KVM_RISCV_ISA_EXT_MAX,
  };
  
@@@ -204,13 -205,77 +206,84 @@@ enum KVM_RISCV_SBI_EXT_ID 
  #define KVM_REG_RISCV_SBI_MULTI_REG_LAST	\
  		KVM_REG_RISCV_SBI_MULTI_REG(KVM_RISCV_SBI_EXT_MAX - 1)
  
 +/* V extension registers are mapped as type 9 */
 +#define KVM_REG_RISCV_VECTOR		(0x09 << KVM_REG_RISCV_TYPE_SHIFT)
 +#define KVM_REG_RISCV_VECTOR_CSR_REG(name)	\
 +		(offsetof(struct __riscv_v_ext_state, name) / sizeof(unsigned long))
 +#define KVM_REG_RISCV_VECTOR_REG(n)	\
 +		((n) + sizeof(struct __riscv_v_ext_state) / sizeof(unsigned long))
 +
+ /* Device Control API: RISC-V AIA */
+ #define KVM_DEV_RISCV_APLIC_ALIGN		0x1000
+ #define KVM_DEV_RISCV_APLIC_SIZE		0x4000
+ #define KVM_DEV_RISCV_APLIC_MAX_HARTS		0x4000
+ #define KVM_DEV_RISCV_IMSIC_ALIGN		0x1000
+ #define KVM_DEV_RISCV_IMSIC_SIZE		0x1000
+ 
+ #define KVM_DEV_RISCV_AIA_GRP_CONFIG		0
+ #define KVM_DEV_RISCV_AIA_CONFIG_MODE		0
+ #define KVM_DEV_RISCV_AIA_CONFIG_IDS		1
+ #define KVM_DEV_RISCV_AIA_CONFIG_SRCS		2
+ #define KVM_DEV_RISCV_AIA_CONFIG_GROUP_BITS	3
+ #define KVM_DEV_RISCV_AIA_CONFIG_GROUP_SHIFT	4
+ #define KVM_DEV_RISCV_AIA_CONFIG_HART_BITS	5
+ #define KVM_DEV_RISCV_AIA_CONFIG_GUEST_BITS	6
+ 
+ /*
+  * Modes of RISC-V AIA device:
+  * 1) EMUL (aka Emulation): Trap-n-emulate IMSIC
+  * 2) HWACCEL (aka HW Acceleration): Virtualize IMSIC using IMSIC guest files
+  * 3) AUTO (aka Automatic): Virtualize IMSIC using IMSIC guest files whenever
+  *    available otherwise fallback to trap-n-emulation
+  */
+ #define KVM_DEV_RISCV_AIA_MODE_EMUL		0
+ #define KVM_DEV_RISCV_AIA_MODE_HWACCEL		1
+ #define KVM_DEV_RISCV_AIA_MODE_AUTO		2
+ 
+ #define KVM_DEV_RISCV_AIA_IDS_MIN		63
+ #define KVM_DEV_RISCV_AIA_IDS_MAX		2048
+ #define KVM_DEV_RISCV_AIA_SRCS_MAX		1024
+ #define KVM_DEV_RISCV_AIA_GROUP_BITS_MAX	8
+ #define KVM_DEV_RISCV_AIA_GROUP_SHIFT_MIN	24
+ #define KVM_DEV_RISCV_AIA_GROUP_SHIFT_MAX	56
+ #define KVM_DEV_RISCV_AIA_HART_BITS_MAX		16
+ #define KVM_DEV_RISCV_AIA_GUEST_BITS_MAX	8
+ 
+ #define KVM_DEV_RISCV_AIA_GRP_ADDR		1
+ #define KVM_DEV_RISCV_AIA_ADDR_APLIC		0
+ #define KVM_DEV_RISCV_AIA_ADDR_IMSIC(__vcpu)	(1 + (__vcpu))
+ #define KVM_DEV_RISCV_AIA_ADDR_MAX		\
+ 		(1 + KVM_DEV_RISCV_APLIC_MAX_HARTS)
+ 
+ #define KVM_DEV_RISCV_AIA_GRP_CTRL		2
+ #define KVM_DEV_RISCV_AIA_CTRL_INIT		0
+ 
+ /*
+  * The device attribute type contains the memory mapped offset of the
+  * APLIC register (range 0x0000-0x3FFF) and it must be 4-byte aligned.
+  */
+ #define KVM_DEV_RISCV_AIA_GRP_APLIC		3
+ 
+ /*
+  * The lower 12-bits of the device attribute type contains the iselect
+  * value of the IMSIC register (range 0x70-0xFF) whereas the higher order
+  * bits contains the VCPU id.
+  */
+ #define KVM_DEV_RISCV_AIA_GRP_IMSIC		4
+ #define KVM_DEV_RISCV_AIA_IMSIC_ISEL_BITS	12
+ #define KVM_DEV_RISCV_AIA_IMSIC_ISEL_MASK	\
+ 		((1U << KVM_DEV_RISCV_AIA_IMSIC_ISEL_BITS) - 1)
+ #define KVM_DEV_RISCV_AIA_IMSIC_MKATTR(__vcpu, __isel)	\
+ 		(((__vcpu) << KVM_DEV_RISCV_AIA_IMSIC_ISEL_BITS) | \
+ 		 ((__isel) & KVM_DEV_RISCV_AIA_IMSIC_ISEL_MASK))
+ #define KVM_DEV_RISCV_AIA_IMSIC_GET_ISEL(__attr)	\
+ 		((__attr) & KVM_DEV_RISCV_AIA_IMSIC_ISEL_MASK)
+ #define KVM_DEV_RISCV_AIA_IMSIC_GET_VCPU(__attr)	\
+ 		((__attr) >> KVM_DEV_RISCV_AIA_IMSIC_ISEL_BITS)
+ 
+ /* One single KVM irqchip, ie. the AIA */
+ #define KVM_NR_IRQCHIPS			1
+ 
  #endif
  
  #endif /* __LINUX_KVM_RISCV_H */

