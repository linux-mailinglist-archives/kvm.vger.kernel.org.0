Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7523B5880D1
	for <lists+kvm@lfdr.de>; Tue,  2 Aug 2022 19:12:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230386AbiHBRMk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Aug 2022 13:12:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbiHBRMi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Aug 2022 13:12:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E07C21D327
        for <kvm@vger.kernel.org>; Tue,  2 Aug 2022 10:12:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659460354;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=smMl5gAfucW+7WdrXT3ubU1ei4sZcF0TVQS1QS95BKU=;
        b=U/jsxfq6FfzlxMOnW9sAzcddhg5zV5kQ9kdTirahPcVunZm9yflN2bV54naVGybp4fpr1O
        r/a7ZvsD2ck/rqZg8o8O3iMx7btXutxcHda+jsNYAxruB6lvaEpp72b6+7f/R45TDBRFKf
        D/i4EKdxDv1IQ/FXpZS8E9ox1OnX99I=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-591-powD2K7bMUi7f4cPUK5YqQ-1; Tue, 02 Aug 2022 13:12:32 -0400
X-MC-Unique: powD2K7bMUi7f4cPUK5YqQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4597E3C02B84;
        Tue,  2 Aug 2022 17:12:32 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1A4FAC15D4F;
        Tue,  2 Aug 2022 17:12:32 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] KVM changes for Linux 5.20 merge window
Date:   Tue,  2 Aug 2022 13:12:31 -0400
Message-Id: <20220802171231.1267184-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit e0dccc3b76fb35bb257b4118367a883073d7390e:

  Linux 5.19-rc8 (2022-07-24 13:26:27 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 281106f938d3daaea6f8b6723a8217a2a1ef6936:

  selftests: kvm: set rax before vmcall (2022-08-01 08:43:05 -0400)

Quite a large pull request due to a selftest API overhaul and some
patches that had come in too late for 5.19.
----------------------------------------------------------------
ARM:

* Unwinder implementations for both nVHE modes (classic and
  protected), complete with an overflow stack

* Rework of the sysreg access from userspace, with a complete
  rewrite of the vgic-v3 view to allign with the rest of the
  infrastructure

* Disagregation of the vcpu flags in separate sets to better track
  their use model.

* A fix for the GICv2-on-v3 selftest

* A small set of cosmetic fixes

RISC-V:

* Track ISA extensions used by Guest using bitmap

* Added system instruction emulation framework

* Added CSR emulation framework

* Added gfp_custom flag in struct kvm_mmu_memory_cache

* Added G-stage ioremap() and iounmap() functions

* Added support for Svpbmt inside Guest

s390:

* add an interface to provide a hypervisor dump for secure guests

* improve selftests to use TAP interface

* enable interpretive execution of zPCI instructions (for PCI passthrough)

* First part of deferred teardown

* CPU Topology

* PV attestation

* Minor fixes

x86:

* Permit guests to ignore single-bit ECC errors

* Intel IPI virtualization

* Allow getting/setting pending triple fault with KVM_GET/SET_VCPU_EVENTS

* PEBS virtualization

* Simplify PMU emulation by just using PERF_TYPE_RAW events

* More accurate event reinjection on SVM (avoid retrying instructions)

* Allow getting/setting the state of the speaker port data bit

* Refuse starting the kvm-intel module if VM-Entry/VM-Exit controls are inconsistent

* "Notify" VM exit (detect microarchitectural hangs) for Intel

* Use try_cmpxchg64 instead of cmpxchg64

* Ignore benign host accesses to PMU MSRs when PMU is disabled

* Allow disabling KVM's "MONITOR/MWAIT are NOPs!" behavior

* Allow NX huge page mitigation to be disabled on a per-vm basis

* Port eager page splitting to shadow MMU as well

* Enable CMCI capability by default and handle injected UCNA errors

* Expose pid of vcpu threads in debugfs

* x2AVIC support for AMD

* cleanup PIO emulation

* Fixes for LLDT/LTR emulation

* Don't require refcounted "struct page" to create huge SPTEs

* Miscellaneous cleanups:
** MCE MSR emulation
** Use separate namespaces for guest PTEs and shadow PTEs bitmasks
** PIO emulation
** Reorganize rmap API, mostly around rmap destruction
** Do not workaround very old KVM bugs for L0 that runs with nesting enabled
** new selftests API for CPUID

Generic:

* Fix races in gfn->pfn cache refresh; do not pin pages tracked by the cache

* new selftests API using struct kvm_vcpu instead of a (vm, id) tuple

----------------------------------------------------------------
Andrei Vagin (1):
      selftests: kvm: set rax before vmcall

Andrew Jones (1):
      KVM: selftests: kvm_binary_stats_test: Fix index expressions

Andrey Konovalov (2):
      arm64: kasan: do not instrument stacktrace.c
      arm64: stacktrace: use non-atomic __set_bit

Anup Patel (7):
      RISC-V: KVM: Factor-out instruction emulation into separate sources
      RISC-V: KVM: Add extensible system instruction emulation framework
      RISC-V: KVM: Add extensible CSR emulation framework
      KVM: Add gfp_custom flag in struct kvm_mmu_memory_cache
      RISC-V: KVM: Add G-stage ioremap() and iounmap() functions
      RISC-V: KVM: Use PAGE_KERNEL_IO in kvm_riscv_gstage_ioremap()
      RISC-V: KVM: Add support for Svpbmt inside Guest/VM

Atish Patra (1):
      RISC-V: KVM: Improve ISA extension by using a bitmap

Bagas Sanjaya (1):
      Documentation: kvm: extend KVM_S390_ZPCI_OP subheading underline

Ben Gardon (9):
      KVM: selftests: Remove dynamic memory allocation for stats header
      KVM: selftests: Read binary stats header in lib
      KVM: selftests: Read binary stats desc in lib
      KVM: selftests: Read binary stat data in lib
      KVM: x86: Fix errant brace in KVM capability handling
      KVM: x86/MMU: Allow NX huge pages to be disabled on a per-vm basis
      KVM: selftests: Add NX huge pages test
      KVM: selftests: Test disabling NX hugepages on a VM
      KVM: selftests: Cache binary stats metadata for duration of test

Chao Gao (1):
      KVM: VMX: enable IPI virtualization

Chenyi Qiang (2):
      KVM: x86: Extend KVM_{G,S}ET_VCPU_EVENTS to support pending triple fault
      KVM: selftests: Add a test to get/set triple fault event

Christian Borntraeger (3):
      Merge tag 'kvm-s390-pci-5.20' into kernelorgnext
      KVM: s390/pci: fix include duplicates
      KVM: s390: Add facility 197 to the allow list

Claudio Imbrenda (12):
      KVM: s390: pv: leak the topmost page table when destroy fails
      KVM: s390: pv: handle secure storage violations for protected guests
      KVM: s390: pv: handle secure storage exceptions for normal guests
      KVM: s390: pv: refactor s390_reset_acc
      KVM: s390: pv: usage counter instead of flag
      KVM: s390: pv: add export before import
      KVM: s390: pv: clear the state without memset
      KVM: s390: pv: Add kvm_s390_cpus_from_pv to kvm-s390.h and add documentation
      KVM: s390: pv: add mmu_notifier
      s390/mm: KVM: pv: when tearing down, try to destroy protected pages
      KVM: s390: pv: refactoring of kvm_s390_pv_deinit_vm
      KVM: s390: pv: destroy the configuration before its memory

Colton Lewis (4):
      KVM: selftests: enumerate GUEST_ASSERT arguments
      KVM: selftests: Increase UCALL_MAX_ARGS to 7
      KVM: selftests: Write REPORT_GUEST_ASSERT macros to pair with GUEST_ASSERT
      KVM: selftests: Fix filename reporting in guest asserts

David Matlack (22):
      KVM: VMX: Print VM-instruction error when it may be helpful
      KVM: x86/mmu: Optimize MMU page cache lookup for all direct SPs
      KVM: x86/mmu: Use a bool for direct
      KVM: x86/mmu: Stop passing "direct" to mmu_alloc_root()
      KVM: x86/mmu: Derive shadow MMU page role from parent
      KVM: x86/mmu: Always pass 0 for @quadrant when gptes are 8 bytes
      KVM: x86/mmu: Decompose kvm_mmu_get_page() into separate functions
      KVM: x86/mmu: Consolidate shadow page allocation and initialization
      KVM: x86/mmu: Rename shadow MMU functions that deal with shadow pages
      KVM: x86/mmu: Move guest PT write-protection to account_shadowed()
      KVM: x86/mmu: Pass memory caches to allocate SPs separately
      KVM: x86/mmu: Replace vcpu with kvm in kvm_mmu_alloc_shadow_page()
      KVM: x86/mmu: Pass kvm pointer separately from vcpu to kvm_mmu_find_shadow_page()
      KVM: x86/mmu: Allow NULL @vcpu in kvm_mmu_find_shadow_page()
      KVM: x86/mmu: Pass const memslot to rmap_add()
      KVM: x86/mmu: Decouple rmap_add() and link_shadow_page() from kvm_vcpu
      KVM: x86/mmu: Update page stats in __rmap_add()
      KVM: x86/mmu: Cache the access bits of shadowed translations
      KVM: x86/mmu: Extend make_huge_page_split_spte() for the shadow MMU
      KVM: x86/mmu: Zap collapsible SPTEs in shadow MMU at all possible levels
      KVM: Allow for different capacities in kvm_mmu_memory_cache structs
      KVM: x86/mmu: Extend Eager Page Splitting to nested MMUs

Dongliang Mu (1):
      x86: kvm: remove NULL check before kfree

Guo Zhengkui (1):
      selftests: kvm: replace ternary operator with min()

Hou Wenlong (1):
      KVM: x86/mmu: Replace UNMAPPED_GVA with INVALID_GPA for gva_to_gpa()

Janis Schoetterl-Glausch (1):
      KVM: s390: selftests: Fix memop extension capability check

Janosch Frank (11):
      s390/uv: Add SE hdr query information
      s390/uv: Add dump fields to query
      KVM: s390: pv: Add query interface
      KVM: s390: pv: Add dump support definitions
      KVM: s390: pv: Add query dump information
      KVM: s390: Add configuration dump functionality
      KVM: s390: Add CPU dump functionality
      KVM: s390: Add KVM_CAP_S390_PROTECTED_DUMP
      Documentation: virt: Protected virtual machine dumps
      Documentation/virt/kvm/api.rst: Add protvirt dump/info api descriptions
      Documentation/virt/kvm/api.rst: Explain rc/rrc delivery

Jarkko Sakkinen (1):
      KVM: SVM: Dump Virtual Machine Save Area (VMSA) to klog

Jiang Jian (1):
      KVM: s390: drop unexpected word 'and' in the comments

Jim Mattson (1):
      KVM: VMX: Print VM-instruction error as unsigned

Jue Wang (8):
      KVM: x86: Make APIC_VERSION capture only the magic 0x14UL.
      KVM: x86: Fill apic_lvt_mask with enums / explicit entries.
      KVM: x86: Add APIC_LVTx() macro.
      KVM: x86: Add Corrected Machine Check Interrupt (CMCI) emulation to lapic.
      KVM: x86: Use kcalloc to allocate the mce_banks array.
      KVM: x86: Add emulation for MSR_IA32_MCx_CTL2 MSRs.
      KVM: x86: Enable CMCI capability by default and handle injected UCNA errors
      KVM: selftests: Add a self test for CMCI and UCNA emulations.

Kai Huang (1):
      KVM, x86/mmu: Fix the comment around kvm_tdp_mmu_zap_leafs()

Kalesh Singh (18):
      KVM: arm64: Fix hypervisor address symbolization
      arm64: stacktrace: Add shared header for common stack unwinding code
      arm64: stacktrace: Factor out on_accessible_stack_common()
      arm64: stacktrace: Factor out unwind_next_common()
      arm64: stacktrace: Handle frame pointer from different address spaces
      arm64: stacktrace: Factor out common unwind()
      arm64: stacktrace: Add description of stacktrace/common.h
      KVM: arm64: On stack overflow switch to hyp overflow_stack
      KVM: arm64: Stub implementation of non-protected nVHE HYP stack unwinder
      KVM: arm64: Prepare non-protected nVHE hypervisor stacktrace
      KVM: arm64: Implement non-protected nVHE hyp stack unwinder
      KVM: arm64: Introduce hyp_dump_backtrace()
      KVM: arm64: Add PROTECTED_NVHE_STACKTRACE Kconfig
      KVM: arm64: Allocate shared pKVM hyp stacktrace buffers
      KVM: arm64: Stub implementation of pKVM HYP stack unwinder
      KVM: arm64: Save protected-nVHE (pKVM) hyp stacktrace
      KVM: arm64: Implement protected nVHE hyp stack unwinder
      KVM: arm64: Introduce pkvm_dump_backtrace()

Lai Jiangshan (4):
      KVM: X86/MMU: Remove unused PT32_DIR_BASE_ADDR_MASK from mmu.c
      KVM: Rename ack_flush() to ack_kick()
      KVM: X86/MMU: Remove useless mmu_topup_memory_caches() in kvm_mmu_pte_write()
      KVM: X86/SVM: Use root_level in svm_load_mmu_pgd()

Lev Kujawski (1):
      KVM: set_msr_mce: Permit guests to ignore single-bit ECC errors

Like Xu (33):
      perf/x86/intel: Add EPT-Friendly PEBS for Ice Lake Server
      perf/x86/intel: Handle guest PEBS overflow PMI for KVM guest
      perf/x86/core: Pass "struct kvm_pmu *" to determine the guest values
      KVM: x86/pmu: Set MSR_IA32_MISC_ENABLE_EMON bit when vPMU is enabled
      KVM: x86/pmu: Introduce the ctrl_mask value for fixed counter
      KVM: x86/pmu: Add IA32_PEBS_ENABLE MSR emulation for extended PEBS
      KVM: x86/pmu: Reprogram PEBS event to emulate guest PEBS counter
      KVM: x86/pmu: Adjust precise_ip to emulate Ice Lake guest PDIR counter
      KVM: x86/pmu: Add IA32_DS_AREA MSR emulation to support guest DS
      KVM: x86/pmu: Add PEBS_DATA_CFG MSR emulation to support adaptive PEBS
      KVM: x86: Set PEBS_UNAVAIL in IA32_MISC_ENABLE when PEBS is enabled
      KVM: x86/pmu: Move pmc_speculative_in_use() to arch/x86/kvm/pmu.h
      KVM: x86/pmu: Disable guest PEBS temporarily in two rare situations
      KVM: x86/pmu: Add kvm_pmu_cap to optimize perf_get_x86_pmu_capability
      KVM: x86/cpuid: Refactor host/guest CPU model consistency check
      KVM: x86/pmu: Expose CPUIDs feature bits PDCM, DS, DTES64
      KVM: x86/pmu: Move the vmx_icl_pebs_cpu[] definition out of the header file
      KVM: x86/pmu: Don't overwrite the pmu->global_ctrl when refreshing
      KVM: x86/pmu: Ignore pmu->global_ctrl check if vPMU doesn't support global_ctrl
      KVM: x86/pmu: Update comments for AMD gp counters
      KVM: x86/pmu: Extract check_pmu_event_filter() handling both GP and fixed counters
      KVM: x86/pmu: Pass only "struct kvm_pmc *pmc" to reprogram_counter()
      KVM: x86/pmu: Drop "u64 eventsel" for reprogram_gp_counter()
      KVM: x86/pmu: Drop "u8 ctrl, int idx" for reprogram_fixed_counter()
      KVM: x86/pmu: Use PERF_TYPE_RAW to merge reprogram_{gp,fixed}counter()
      perf: x86/core: Add interface to query perfmon_event_map[] directly
      KVM: x86/pmu: Replace pmc_perf_hw_id() with perf_get_hw_event_config()
      KVM: x86/pmu: Drop amd_event_mapping[] in the KVM context
      perf/x86/intel: Fix the comment about guest LBR support on KVM
      KVM: x86/pmu: Update global enable_pmu when PMU is undetected
      KVM: x86/pmu: Avoid exposing Intel BTS feature
      KVM: x86/pmu: Restrict advanced features based on module enable_pmu
      KVM: x86/pmu: Accept 0 for absent PMU MSRs when host-initiated if !enable_pmu

Maciej S. Szmigiero (5):
      KVM: nSVM: Sync next_rip field from vmcb12 to vmcb02
      KVM: SVM: Don't BUG if userspace injects an interrupt with GIF=0
      KVM: nSVM: Transparently handle L1 -> L2 NMI re-injection
      KVM: selftests: nSVM: Add svm_nested_soft_inject_test
      KVM: nSVM: Pull CS.Base from actual VMCB12 for soft int/ex re-injection

Madhavan T. Venkataraman (2):
      arm64: Split unwind_init()
      arm64: Copy the task argument to unwind_state

Marc Zyngier (47):
      KVM: arm64: Drop FP_FOREIGN_STATE from the hypervisor code
      KVM: arm64: Move FP state ownership from flag to a tristate
      KVM: arm64: Add helpers to manipulate vcpu flags among a set
      KVM: arm64: Add three sets of flags to the vcpu state
      KVM: arm64: Move vcpu configuration flags into their own set
      KVM: arm64: Move vcpu PC/Exception flags to the input flag set
      KVM: arm64: Move vcpu debug/SPE/TRBE flags to the input flag set
      KVM: arm64: Move vcpu SVE/SME flags to the state flag set
      KVM: arm64: Move vcpu ON_UNSUPPORTED_CPU flag to the state flag set
      KVM: arm64: Move vcpu WFIT flag to the state flag set
      KVM: arm64: Kill unused vcpu flags field
      KVM: arm64: Convert vcpu sysregs_loaded_on_cpu to a state flag
      KVM: arm64: Warn when PENDING_EXCEPTION and INCREMENT_PC are set together
      KVM: arm64: Add build-time sanity checks for flags
      KVM: arm64: Reduce the size of the vcpu flag members
      KVM: arm64: Document why pause cannot be turned into a flag
      KVM: arm64: Move the handling of !FP outside of the fast path
      Merge branch kvm-arm64/burn-the-flags into kvmarm-master/next
      KVM: arm64: selftests: Add support for GICv2 on v3
      Merge branch kvm-arm64/misc-5.20 into kvmarm-master/next
      KVM: arm64: Add get_reg_by_id() as a sys_reg_desc retrieving helper
      KVM: arm64: Reorder handling of invariant sysregs from userspace
      KVM: arm64: Introduce generic get_user/set_user helpers for system registers
      KVM: arm64: Rely on index_to_param() for size checks on userspace access
      KVM: arm64: Consolidate sysreg userspace accesses
      KVM: arm64: Get rid of reg_from/to_user()
      KVM: arm64: vgic-v3: Simplify vgic_v3_has_cpu_sysregs_attr()
      KVM: arm64: vgic-v3: Push user access into vgic_v3_cpu_sysregs_uaccess()
      KVM: arm64: vgic-v3: Make the userspace accessors use sysreg API
      KVM: arm64: vgic-v3: Convert userspace accessors over to FIELD_GET/FIELD_PREP
      KVM: arm64: vgic-v3: Use u32 to manage the line level from userspace
      KVM: arm64: vgic-v3: Consolidate userspace access for MMIO registers
      KVM: arm64: vgic-v2: Consolidate userspace access for MMIO registers
      KVM: arm64: vgic: Use {get,put}_user() instead of copy_{from.to}_user
      KVM: arm64: vgic-v2: Add helper for legacy dist/cpuif base address setting
      KVM: arm64: vgic: Consolidate userspace access for base address setting
      KVM: arm64: vgic: Tidy-up calls to vgic_{get,set}_common_attr()
      KVM: arm64: Get rid of find_reg_by_id()
      KVM: arm64: Descope kvm_arm_sys_reg_{get,set}_reg()
      KVM: arm64: Get rid or outdated comments
      Merge branch kvm-arm64/sysreg-cleanup-5.20 into kvmarm-master/next
      KVM: arm64: Move PROTECTED_NVHE_STACKTRACE around
      KVM: arm64: Move nVHE stacktrace unwinding into its own compilation unit
      KVM: arm64: Make unwind()/on_accessible_stack() per-unwinder functions
      KVM: arm64: Move nVHE-only helpers into kvm/stacktrace.c
      arm64: Update 'unwinder howto'
      Merge branch kvm-arm64/nvhe-stacktrace into kvmarm-master/next

Masahiro Yamada (2):
      KVM: arm64: nvhe: Rename confusing obj-y
      KVM: arm64: nvhe: Add intermediates to 'targets' instead of extra-y

Matthew Rosato (21):
      s390/sclp: detect the zPCI load/store interpretation facility
      s390/sclp: detect the AISII facility
      s390/sclp: detect the AENI facility
      s390/sclp: detect the AISI facility
      s390/airq: pass more TPI info to airq handlers
      s390/airq: allow for airq structure that uses an input vector
      s390/pci: externalize the SIC operation controls and routine
      s390/pci: stash associated GISA designation
      s390/pci: stash dtsm and maxstbl
      vfio/pci: introduce CONFIG_VFIO_PCI_ZDEV_KVM
      KVM: s390: pci: add basic kvm_zdev structure
      KVM: s390: pci: do initial setup for AEN interpretation
      KVM: s390: pci: enable host forwarding of Adapter Event Notifications
      KVM: s390: mechanism to enable guest zPCI Interpretation
      KVM: s390: pci: provide routines for enabling/disabling interrupt forwarding
      KVM: s390: pci: add routines to start/stop interpretive execution
      vfio-pci/zdev: add open/close device hooks
      vfio-pci/zdev: add function handle to clp base capability
      vfio-pci/zdev: different maxstbl for interpreted devices
      KVM: s390: add KVM_S390_ZPCI_OP to manage guest zPCI devices
      MAINTAINERS: additional files related kvm s390 pci passthrough

Maxim Levitsky (3):
      KVM: x86: nSVM: always intercept x2apic msrs
      KVM: x86: nSVM: optimize svm_set_x2apic_msr_interception
      KVM: SVM: fix task switch emulation on INTn instruction.

Nico Boehr (1):
      KVM: s390: pv: don't present the ecall interrupt twice

Nikolay Borisov (2):
      RISC-V: KVM: Make kvm_riscv_guest_timer_init a void function
      RISC-V: KVM: move preempt_disable() call in kvm_arch_vcpu_ioctl_run

Oliver Upton (4):
      KVM: arm64: Don't open code ARRAY_SIZE()
      selftests: KVM: Check stat name before other fields
      selftests: KVM: Provide descriptive assertions in kvm_binary_stats_test
      selftests: KVM: Add exponent check for boolean stats

Paolo Bonzini (30):
      Merge branch 'kvm-5.19-early-fixes' into HEAD
      Merge branch 'kvm-5.20-early-patches' into HEAD
      Merge tag 'kvm-s390-next-5.19-2' of git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux into HEAD
      KVM: x86/pmu: remove useless prototype
      KVM: vmx, pmu: accept 0 for host-initiated write to MSR_IA32_DS_AREA
      KVM: x86: always allow host-initiated writes to PMU MSRs
      KVM: x86/pmu: Use only the uniform interface reprogram_counter()
      x86: events: Do not return bogus capabilities if PMU is broken
      Merge branch 'kvm-5.20-early'
      KVM: SEV: fix misplaced closing parenthesis
      KVM: x86/mmu: Use common macros to compute 32/64-bit paging masks
      KVM: x86/mmu: pull call to drop_large_spte() into __link_shadow_page()
      KVM: x86/mmu: Avoid unnecessary flush on eager page split
      KVM: nVMX: clean up posted interrupt descriptor try_cmpxchg
      KVM: x86: complete fast IN directly with complete_emulator_pio_in()
      KVM: x86: inline kernel_pio into its sole caller
      KVM: x86: drop PIO from unregistered devices
      KVM: x86: move all vcpu->arch.pio* setup in emulator_pio_in_out()
      KVM: x86: wean in-kernel PIO from vcpu->arch.pio*
      KVM: x86: wean fast IN from emulator_pio_in
      KVM: x86: de-underscorify __emulator_pio_in
      KVM: SEV-ES: reuse advance_sev_es_emulated_ins for OUT too
      Merge commit 'kvm-vmx-nested-tsc-fix' into kvm-next-5.20
      Merge tag 'kvm-s390-next-5.20-1' of https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux into HEAD
      Revert "KVM: nVMX: Do not expose MPX VMX controls when guest MPX disabled"
      Revert "KVM: nVMX: Expose load IA32_PERF_GLOBAL_CTRL VM-{Entry,Exit} control"
      Merge tag 'kvm-riscv-5.20-1' of https://github.com/kvm-riscv/linux into HEAD
      Merge remote-tracking branch 'kvm/next' into kvm-next-5.20
      Merge tag 'kvmarm-5.20' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD
      KVM: x86/mmu: remove unused variable

Paul Durrant (1):
      KVM: x86: PIT: Preserve state of speaker port data bit

Peter Zijlstra (Intel) (1):
      x86/perf/core: Add pebs_capable to store valid PEBS_COUNTER_MASK value

Pierre Morel (3):
      KVM: s390: Cleanup ipte lock access and SIIF facility checks
      KVM: s390: guest support for topology function
      KVM: s390: resetting the Topology-Change-Report

Quentin Perret (1):
      KVM: arm64: Don't return from void function

Robert Hoo (4):
      x86/cpu: Add new VMX feature, Tertiary VM-Execution control
      KVM: VMX: Extend BUILD_CONTROLS_SHADOW macro to support 64-bit variation
      KVM: VMX: Detect Tertiary VM-Execution control when setup VMCS config
      KVM: VMX: Report tertiary_exec_control field in dump_vmcs()

Sean Christopherson (310):
      KVM: Drop unused @gpa param from gfn=>pfn cache's __release_gpc() helper
      KVM: Put the extra pfn reference when reusing a pfn in the gpc cache
      KVM: Do not incorporate page offset into gfn=>pfn cache user address
      KVM: Fully serialize gfn=>pfn cache refresh via mutex
      KVM: Fix multiple races in gfn=>pfn cache refresh
      KVM: Do not pin pages tracked by gfn=>pfn caches
      KVM: SVM: Unwind "speculative" RIP advancement if INTn injection "fails"
      KVM: SVM: Stuff next_rip on emulated INT3 injection if NRIPS is supported
      KVM: SVM: Re-inject INT3/INTO instead of retrying the instruction
      KVM: SVM: Re-inject INTn instead of retrying the insn on "failure"
      KVM: x86: Trace re-injected exceptions
      KVM: x86: Print error code in exception injection tracepoint iff valid
      KVM: x86: Differentiate Soft vs. Hard IRQs vs. reinjected in tracepoint
      KVM: x86/mmu: Drop RWX=0 SPTEs during ept_sync_page()
      KVM: x86/mmu: Comment FNAME(sync_page) to document TLB flushing logic
      KVM: x86: Introduce "struct kvm_caps" to track misc caps/settings
      KVM: VMX: Sanitize VM-Entry/VM-Exit control pairs at kvm_intel load time
      KVM: VMX: Reject kvm_intel if an inconsistent VMCS config is detected
      KVM: x86: Grab regs_dirty in local 'unsigned long'
      KVM: x86: Harden _regs accesses to guard against buggy input
      KVM: x86: Omit VCPU_REGS_RIP from emulator's _regs array
      KVM: x86: Use 16-bit fields to track dirty/valid emulator GPRs
      KVM: x86: Reduce the number of emulator GPRs to '8' for 32-bit KVM
      KVM: x86: Bug the VM if the emulator accesses a non-existent GPR
      KVM: x86: Bug the VM if the emulator generates a bogus exception vector
      KVM: x86: Bug the VM on an out-of-bounds data read
      KVM: Fix references to non-existent KVM_CAP_TRIPLE_FAULT_EVENT
      KVM: selftests: Fix buggy-but-benign check in test_v3_new_redist_regions()
      KVM: selftests: Fix typo in vgic_init test
      KVM: selftests: Drop stale declarations from kvm_util_base.h
      KVM: selftests: Always open VM file descriptors with O_RDWR
      KVM: selftests: Add another underscore to inner ioctl() helpers
      KVM: selftests: Make vcpu_ioctl() a wrapper to pretty print ioctl name
      KVM: selftests: Drop @mode from common vm_create() helper
      KVM: selftests: Split vcpu_set_nested_state() into two helpers
      KVM: sefltests: Use vcpu_ioctl() and __vcpu_ioctl() helpers
      KVM: selftests: Add __vcpu_run() helper
      KVM: selftests: Use vcpu_access_device_attr() in arm64 code
      KVM: selftests: Remove vcpu_get_fd()
      KVM: selftests: Add vcpu_get() to retrieve and assert on vCPU existence
      KVM: selftests: Make vm_ioctl() a wrapper to pretty print ioctl name
      KVM: sefltests: Use vm_ioctl() and __vm_ioctl() helpers
      KVM: selftests: Make kvm_ioctl() a wrapper to pretty print ioctl name
      KVM: selftests: Use kvm_ioctl() helpers
      KVM: selftests: Use __KVM_SYSCALL_ERROR() to handle non-KVM syscall errors
      KVM: selftests: Make x86-64's register dump helpers static
      KVM: selftests: Get rid of kvm_util_internal.h
      KVM: selftests: Use KVM_IOCTL_ERROR() for one-off arm64 ioctls
      KVM: selftests: Drop @test param from kvm_create_device()
      KVM: selftests: Move KVM_CREATE_DEVICE_TEST code to separate helper
      KVM: selftests: Multiplex return code and fd in __kvm_create_device()
      KVM: selftests: Rename KVM_HAS_DEVICE_ATTR helpers for consistency
      KVM: selftests: Drop 'int' return from asserting *_has_device_attr()
      KVM: selftests: Split get/set device_attr helpers
      KVM: selftests: Dedup vgic_init's asserts and improve error messages
      KVM: selftests: Add a VM backpointer to 'struct vcpu'
      KVM: selftests: Consolidate KVM_ENABLE_CAP usage
      KVM: selftests: Simplify KVM_ENABLE_CAP helper APIs
      KVM: selftests: Cache list of MSRs to save/restore
      KVM: selftests: Harden and comment XSS / KVM_SET_MSRS interaction
      KVM: selftests: Dedup MSR index list helpers, simplify dedicated test
      KVM: selftests: Rename MP_STATE and GUEST_DEBUG helpers for consistency
      KVM: selftest: Add proper helpers for x86-specific save/restore ioctls
      KVM: selftests: Add vm_create_*() variants to expose/return 'struct vcpu'
      KVM: selftests: Push vm_adjust_num_guest_pages() into "w/o vCPUs" helper
      KVM: selftests: Use vm_create_without_vcpus() in set_boot_cpu_id
      KVM: selftests: Use vm_create_without_vcpus() in dirty_log_test
      KVM: selftests: Use vm_create_without_vcpus() in hardware_disable_test
      KVM: selftests: Use vm_create_without_vcpus() in psci_test
      KVM: selftests: Avoid memory allocations when adding vCPU in get-reg-list
      KVM: selftests: Rename vm_create() => vm_create_barebones(), drop param
      KVM: selftests: Rename vm_create_without_vcpus() => vm_create()
      KVM: selftests: Make vm_create() a wrapper that specifies VM_MODE_DEFAULT
      KVM: selftests: Rename xAPIC state test's vcpu struct
      KVM: selftests: Rename vcpu.state => vcpu.run
      KVM: selftests: Rename 'struct vcpu' to 'struct kvm_vcpu'
      KVM: selftests: Return the created vCPU from vm_vcpu_add()
      KVM: selftests: Convert memslot_perf_test away from VCPU_ID
      KVM: selftests: Convert rseq_test away from VCPU_ID
      KVM: selftests: Convert xss_msr_test away from VCPU_ID
      KVM: selftests: Convert vmx_preemption_timer_test away from VCPU_ID
      KVM: selftests: Convert vmx_pmu_msrs_test away from VCPU_ID
      KVM: selftests: Convert vmx_set_nested_state_test away from VCPU_ID
      KVM: selftests: Convert vmx_tsc_adjust_test away from VCPU_ID
      KVM: selftests: Convert mmu_role_test away from VCPU_ID
      KVM: selftests: Convert pmu_event_filter_test away from VCPU_ID
      KVM: selftests: Convert smm_test away from VCPU_ID
      KVM: selftests: Convert state_test away from VCPU_ID
      KVM: selftests: Convert svm_int_ctl_test away from VCPU_ID
      KVM: selftests: Convert svm_vmcall_test away from VCPU_ID
      KVM: selftests: Convert sync_regs_test away from VCPU_ID
      KVM: selftests: Convert hyperv_cpuid away from VCPU_ID
      KVM: selftests: Convert kvm_pv_test away from VCPU_ID
      KVM: selftests: Convert platform_info_test away from VCPU_ID
      KVM: selftests: Convert vmx_nested_tsc_scaling_test away from VCPU_ID
      KVM: selftests: Convert set_sregs_test away from VCPU_ID
      KVM: selftests: Convert vmx_dirty_log_test away from VCPU_ID
      KVM: selftests: Convert vmx_close_while_nested_test away from VCPU_ID
      KVM: selftests: Convert vmx_apic_access_test away from VCPU_ID
      KVM: selftests: Convert userspace_msr_exit_test away from VCPU_ID
      KVM: selftests: Convert vmx_exception_with_invalid_guest_state away from VCPU_ID
      KVM: selftests: Convert tsc_msrs_test away from VCPU_ID
      KVM: selftests: Convert kvm_clock_test away from VCPU_ID
      KVM: selftests: Convert hyperv_svm_test away from VCPU_ID
      KVM: selftests: Convert hyperv_features away from VCPU_ID
      KVM: selftests: Convert hyperv_clock away from VCPU_ID
      KVM: selftests: Convert evmcs_test away from VCPU_ID
      KVM: selftests: Convert emulator_error_test away from VCPU_ID
      KVM: selftests: Convert debug_regs away from VCPU_ID
      KVM: selftests: Add proper helper for advancing RIP in debug_regs
      KVM: selftests: Convert amx_test away from VCPU_ID
      KVM: selftests: Convert cr4_cpuid_sync_test away from VCPU_ID
      KVM: selftests: Convert cpuid_test away from VCPU_ID
      KVM: selftests: Convert userspace_io_test away from VCPU_ID
      KVM: selftests: Convert vmx_invalid_nested_guest_state away from VCPU_ID
      KVM: selftests: Convert xen_vmcall_test away from VCPU_ID
      KVM: selftests: Convert xen_shinfo_test away from VCPU_ID
      KVM: selftests: Convert dirty_log_test away from VCPU_ID
      KVM: selftests: Convert set_memory_region_test away from VCPU_ID
      KVM: selftests: Convert system_counter_offset_test away from VCPU_ID
      KVM: selftests: Track kvm_vcpu object in tsc_scaling_sync
      KVM: selftests: Convert xapic_state_test away from hardcoded vCPU ID
      KVM: selftests: Convert debug-exceptions away from VCPU_ID
      KVM: selftests: Convert fix_hypercall_test away from VCPU_ID
      KVM: selftests: Convert vgic_irq away from VCPU_ID
      KVM: selftests: Make arm64's guest_get_vcpuid() declaration arm64-only
      KVM: selftests: Move vm_is_unrestricted_guest() to x86-64
      KVM: selftests: Add "arch" to common utils that have arch implementations
      KVM: selftests: Return created vcpu from vm_vcpu_add_default()
      KVM: selftests: Rename vm_vcpu_add* helpers to better show relationships
      KVM: selftests: Convert set_boot_cpu_id away from global VCPU_IDs
      KVM: selftests: Convert psci_test away from VCPU_ID
      KVM: selftests: Convert hardware_disable_test to pass around vCPU objects
      KVM: selftests: Add VM creation helper that "returns" vCPUs
      KVM: selftests: Convert steal_time away from VCPU_ID
      KVM: selftests: Convert arch_timer away from VCPU_ID
      KVM: selftests: Convert svm_nested_soft_inject_test away from VCPU_ID
      KVM: selftests: Convert triple_fault_event_test away from VCPU_ID
      KVM: selftests: Convert vgic_init away from vm_create_default_with_vcpus()
      KVM: selftests: Consolidate KVM_{G,S}ET_ONE_REG helpers
      KVM: selftests: Sync stage before VM is freed in hypercalls test
      KVM: selftests: Convert hypercalls test away from vm_create_default()
      KVM: selftests: Convert xapic_ipi_test away from *_VCPU_ID
      KVM: selftests: Convert sync_regs_test away from VCPU_ID
      KVM: selftests: Convert s390's "resets" test away from VCPU_ID
      KVM: selftests: Convert memop away from VCPU_ID
      KVM: selftests: Convert s390x/diag318_test_handler away from VCPU_ID
      KVM: selftests: Convert tprot away from VCPU_ID
      KVM: selftests: Use vm_create() in tsc_scaling_sync
      KVM: selftests: Use vm_create_with_vcpus() in max_guest_memory_test
      KVM: selftests: Drop vm_create_default* helpers
      KVM: selftests: Drop @vcpuids param from VM creators
      KVM: selftests: Convert kvm_page_table_test away from reliance on vcpu_id
      KVM: selftests: Convert kvm_binary_stats_test away from vCPU IDs
      KVM: selftests: Convert get-reg-list away from its "VCPU_ID"
      KVM: selftests: Stop hardcoding vCPU IDs in vcpu_width_config
      KVM: selftests: Stop conflating vCPU index and ID in perf tests
      KVM: selftests: Remove vcpu_get() usage from dirty_log_test
      KVM: selftests: Require vCPU output array when creating VM with vCPUs
      KVM: selftests: Purge vm+vcpu_id == vcpu silliness
      KVM: selftests: Drop vcpu_get(), rename vcpu_find() => vcpu_exists()
      KVM: selftests: Remove vcpu_state() helper
      KVM: selftests: Open code and drop 'struct kvm_vm' accessors
      KVM: selftests: Drop @slot0_mem_pages from __vm_create_with_vcpus()
      KVM: selftests: Drop @num_percpu_pages from __vm_create_with_vcpus()
      KVM: selftests: Move per-VM/per-vCPU nr pages calculation to __vm_create()
      KVM: selftests: Trust that MAXPHYADDR > memslot0 in vmx_apic_access_test
      KVM: selftests: Drop DEFAULT_GUEST_PHY_PAGES, open code the magic number
      KVM: selftests: Return an 'unsigned int' from kvm_check_cap()
      KVM: selftests: Add kvm_has_cap() to provide syntactic sugar
      KVM: selftests: Add TEST_REQUIRE macros to reduce skipping copy+paste
      KVM: selftests: Use TAP-friendly ksft_exit_skip() in __TEST_REQUIRE
      KVM: selftests: Sanity check input to ioctls() at build time
      KVM: selftests: Add a missing apostrophe in comment to show ownership
      KVM: selftests: Call a dummy helper in VM/vCPU ioctls() to enforce type
      KVM: selftests: Drop a duplicate TEST_ASSERT() in vm_nr_pages_required()
      KVM: selftests: Use kvm_has_cap(), not kvm_check_cap(), where possible
      KVM: SVM: Hide SEV migration lockdep goo behind CONFIG_PROVE_LOCKING
      KVM: x86/mmu: Drop unused CMPXCHG macro from paging_tmpl.h
      KVM: VMX: Skip filter updates for MSRs that KVM is already intercepting
      KVM: nVMX: Snapshot pre-VM-Enter BNDCFGS for !nested_run_pending case
      KVM: nVMX: Snapshot pre-VM-Enter DEBUGCTL for !nested_run_pending case
      KVM: nVMX: Rename nested.vmcs01_* fields to nested.pre_vmenter_*
      KVM: nVMX: Save BNDCFGS to vmcs12 iff relevant controls are exposed to L1
      KVM: nVMX: Update vmcs12 on BNDCFGS write, not at vmcs02=>vmcs12 sync
      KVM: SVM: Drop unused AVIC / kvm_x86_ops declarations
      KVM: x86: Drop @vcpu parameter from kvm_x86_ops.hwapic_isr_update()
      KVM: x86: Check for in-kernel xAPIC when querying APICv for directed yield
      KVM: x86: Move "apicv_active" into "struct kvm_lapic"
      KVM: x86: Use lapic_in_kernel() to query in-kernel APIC in APICv helper
      KVM: VMX: Refactor 32-bit PSE PT creation to avoid using MMU macro
      KVM: x86/mmu: Bury 32-bit PSE paging helpers in paging_tmpl.h
      KVM: x86/mmu: Dedup macros for computing various page table masks
      KVM: x86/mmu: Use separate namespaces for guest PTEs and shadow PTEs
      KVM: x86/mmu: Truncate paging32's PT_BASE_ADDR_MASK to 32 bits
      KVM: x86/mmu: Use common logic for computing the 32/64-bit base PA mask
      KVM: Drop bogus "pfn != 0" guard from kvm_release_pfn()
      KVM: Don't set Accessed/Dirty bits for ZERO_PAGE
      KVM: Avoid pfn_to_page() and vice versa when releasing pages
      KVM: nVMX: Use kvm_vcpu_map() to get/pin vmcs12's APIC-access page
      KVM: Don't WARN if kvm_pfn_to_page() encounters a "reserved" pfn
      KVM: Remove kvm_vcpu_gfn_to_page() and kvm_vcpu_gpa_to_page()
      KVM: Take a 'struct page', not a pfn in kvm_is_zone_device_page()
      KVM: Rename/refactor kvm_is_reserved_pfn() to kvm_pfn_to_refcounted_page()
      KVM: x86/mmu: Shove refcounted page dependency into host_pfn_mapping_level()
      KVM: Do not zero initialize 'pfn' in hva_to_pfn()
      KVM: x86: Give host userspace full control of MSR_IA32_MISC_ENABLES
      KVM: VMX: Give host userspace full control of MSR_IA32_PERF_CAPABILITIES
      Revert "KVM: x86/pmu: Accept 0 for absent PMU MSRs when host-initiated if !enable_pmu"
      Revert "KVM: x86: always allow host-initiated writes to PMU MSRs"
      KVM: VMX: Use vcpu_get_perf_capabilities() to get guest-visible value
      KVM: x86: Ignore benign host accesses to "unsupported" PEBS and BTS MSRs
      KVM: x86: Ignore benign host writes to "unsupported" F15H_PERF_CTL MSRs
      KVM: x86: Add a quirk for KVM's "MONITOR/MWAIT are NOPs!" behavior
      KVM: selftests: Add x86-64 support for exception fixup
      KVM: selftests: Mostly fix broken Hyper-V Features test
      KVM: selftests: Use exception fixup for #UD/#GP Hyper-V MSR/hcall tests
      KVM: selftests: Add MONITOR/MWAIT quirk test
      KVM: selftests: Clean up coding style in binary stats test
      KVM: x86/mmu: Use "unsigned int", not "u32", for SPTEs' @access info
      KVM: x86/mmu: Buffer nested MMU split_desc_cache only by default capacity
      KVM: x86: Signal #GP, not -EPERM, on bad WRMSR(MCi_CTL/STATUS)
      KVM: x86: Use explicit case-statements for MCx banks in {g,s}et_msr_mce()
      KVM: x86: Add helpers to identify CTL and STATUS MCi MSRs
      Merge branch 'kvm-5.20-msr-eperm'
      KVM: x86: Initialize number of APIC LVT entries during APIC creation
      KVM: x86: Fix handling of APIC LVT updates when userspace changes MCG_CAP
      KVM: x86: Query vcpu->vcpu_idx directly and drop its accessor, again
      KVM: selftests: Test MONITOR and MWAIT, not just MONITOR for quirk
      KVM: selftests: Provide valid inputs for MONITOR/MWAIT regs
      KVM: x86: Tweak name of MONITOR/MWAIT #UD quirk to make it #UD specific
      KVM: x86: Mark TSS busy during LTR emulation _after_ all fault checks
      KVM: x86: Set error code to segment selector on LLDT/LTR non-canonical #GP
      KVM: x86: WARN only once if KVM leaves a dangling userspace I/O request
      KVM: selftests: Set KVM's supported CPUID as vCPU's CPUID during recreate
      KVM: sefltests: Use CPUID_* instead of X86_FEATURE_* for one-off usage
      KVM: selftests: Add framework to query KVM CPUID bits
      KVM: selftests: Use kvm_cpu_has() in the SEV migration test
      KVM: selftests: Use kvm_cpu_has() for nested SVM checks
      KVM: selftests: Use kvm_cpu_has() for nested VMX checks
      KVM: selftests: Use kvm_cpu_has() to query PDCM in PMU selftest
      KVM: selftests: Drop redundant vcpu_set_cpuid() from PMU selftest
      KVM: selftests: Use kvm_cpu_has() for XSAVES in XSS MSR test
      KVM: selftests: Check for _both_ XTILE data and cfg in AMX test
      KVM: selftests: Use kvm_cpu_has() in AMX test
      KVM: selftests: Use kvm_cpu_has() for XSAVE in cr4_cpuid_sync_test
      KVM: selftests: Remove the obsolete/dead MMU role test
      KVM: selftests: Use kvm_cpu_has() for KVM's PV steal time
      KVM: selftests: Use kvm_cpu_has() for nSVM soft INT injection test
      KVM: selftests: Verify that kvm_cpuid2.entries layout is unchanged by KVM
      KVM: selftests: Split out kvm_cpuid2_size() from allocate_kvm_cpuid2()
      KVM: selftests: Cache CPUID in struct kvm_vcpu
      KVM: selftests: Don't use a static local in vcpu_get_supported_hv_cpuid()
      KVM: selftests: Rename and tweak get_cpuid() to get_cpuid_entry()
      KVM: selftests: Use get_cpuid_entry() in kvm_get_supported_cpuid_index()
      KVM: selftests: Add helpers to get and modify a vCPU's CPUID entries
      KVM: selftests: Use vm->pa_bits to generate reserved PA bits
      KVM: selftests: Add and use helper to set vCPU's CPUID maxphyaddr
      KVM: selftests: Use vcpu_clear_cpuid_feature() in monitor_mwait_test
      KVM: selftests: Use vcpu_get_cpuid_entry() in PV features test (sort of)
      KVM: selftests: Use vCPU's CPUID directly in Hyper-V test
      KVM: selftests: Use vcpu_get_cpuid_entry() in CPUID test
      KVM: selftests: Use vcpu_{set,clear}_cpuid_feature() in nVMX state test
      KVM: selftests: Use vcpu_clear_cpuid_feature() to clear x2APIC
      KVM: selftests: Make get_supported_cpuid() returns "const"
      KVM: selftests: Set input function/index in raw CPUID helper(s)
      KVM: selftests: Add this_cpu_has() to query X86_FEATURE_* via cpuid()
      KVM: selftests: Use this_cpu_has() in CR4/CPUID sync test
      KVM: selftests: Use this_cpu_has() to detect SVM support in L1
      KVM: selftests: Drop unnecessary use of kvm_get_supported_cpuid_index()
      KVM: selftests: Rename kvm_get_supported_cpuid_index() to __..._entry()
      KVM: selftests: Inline "get max CPUID leaf" helpers
      KVM: selftests: Check KVM's supported CPUID, not host CPUID, for XFD
      KVM: selftests: Skip AMX test if ARCH_REQ_XCOMP_GUEST_PERM isn't supported
      KVM: selftests: Clean up requirements for XFD-aware XSAVE features
      KVM: selftests: Use the common cpuid() helper in cpu_vendor_string_is()
      KVM: selftests: Drop unused SVM_CPUID_FUNC macro
      KVM: VMX: Update PT MSR intercepts during filter change iff PT in host+guest
      KVM: x86/mmu: Add optimized helper to retrieve an SPTE's index
      KVM: x86/mmu: Expand quadrant comment for PG_LEVEL_4K shadow pages
      KVM: x86/mmu: Fix typo and tweak comment for split_desc_cache capacity
      KVM: x86: Add dedicated helper to get CPUID entry with significant index
      KVM: x86: Restrict get_mt_mask() to a u8, use KVM_X86_OP_OPTIONAL_RET0
      KVM: x86: Check target, not vCPU's x2APIC ID, when applying hotplug hack
      KVM: x86/mmu: Return a u64 (the old SPTE) from mmu_spte_clear_track_bits()
      KVM: x86/mmu: Directly "destroy" PTE list when recycling rmaps
      KVM: x86/mmu: Drop the "p is for pointer" from rmap helpers
      KVM: x86/mmu: Rename __kvm_zap_rmaps() to align with other nomenclature
      KVM: x86/mmu: Rename rmap zap helpers to eliminate "unmap" wrapper
      KVM: x86/mmu: Rename pte_list_{destroy,remove}() to show they zap SPTEs
      KVM: x86/mmu: Remove underscores from __pte_list_remove()
      KVM: x86: Reject loading KVM if host.PAT[0] != WB
      KVM: x86: Drop unnecessary goto+label in kvm_arch_init()
      KVM: x86/mmu: Add shadow mask for effective host MTRR memtype
      KVM: x86/mmu: Restrict mapping level based on guest MTRR iff they're used
      KVM: x86/mmu: Don't require refcounted "struct page" to create huge SPTEs
      KVM: x86/mmu: Document the "rules" for using host_pfn_mapping_level()
      KVM: x86/mmu: Don't bottom out on leafs when zapping collapsible SPTEs
      KVM: selftests: Add an option to run vCPUs while disabling dirty logging
      KVM: x86: Split kvm_is_valid_cr4() and export only the non-vendor bits
      KVM: nVMX: Account for KVM reserved CR4 bits in consistency checks
      KVM: nVMX: Inject #UD if VMXON is attempted with incompatible CR0/CR4
      KVM: nVMX: Rename handle_vm{on,off}() to handle_vmx{on,off}()
      KVM: nVMX: Let userspace set nVMX MSR to any _host_ supported value
      KVM: VMX: Mark all PERF_GLOBAL_(OVF)_CTRL bits reserved if there's no vPMU
      KVM: VMX: Add helper to check if the guest PMU has PERF_GLOBAL_CTRL
      KVM: nVMX: Attempt to load PERF_GLOBAL_CTRL on nVMX xfer iff it exists
      KVM: nVMX: Set UMIP bit CR4_FIXED1 MSR when emulating UMIP
      KVM: selftests: Verify VMX MSRs can be restored to KVM-supported values
      KVM: x86/mmu: Treat NX as a valid SPTE bit for NPT

Shaoqin Huang (1):
      KVM: selftests: Remove the mismatched parameter comments

Steffen Eiden (1):
      s390: Add attestation query information

Suravee Suthikulpanit (18):
      x86/cpufeatures: Introduce x2AVIC CPUID bit
      KVM: x86: lapic: Rename [GET/SET]_APIC_DEST_FIELD to [GET/SET]_XAPIC_DEST_FIELD
      KVM: SVM: Detect X2APIC virtualization (x2AVIC) support
      KVM: SVM: Update max number of vCPUs supported for x2AVIC mode
      KVM: SVM: Update avic_kick_target_vcpus to support 32-bit APIC ID
      KVM: SVM: Do not support updating APIC ID when in x2APIC mode
      KVM: SVM: Adding support for configuring x2APIC MSRs interception
      KVM: x86: Deactivate APICv on vCPU with APIC disabled
      KVM: SVM: Refresh AVIC configuration when changing APIC mode
      KVM: SVM: Introduce logic to (de)activate x2AVIC mode
      KVM: SVM: Do not throw warning when calling avic_vcpu_load on a running vcpu
      KVM: SVM: Introduce hybrid-AVIC mode
      KVM: x86: Warning APICv inconsistency only when vcpu APIC mode is valid
      KVM: SVM: Use target APIC ID to complete x2AVIC IRQs when possible
      KVM: SVM: Add AVIC doorbell tracepoint
      KVM: SVM: Fix x2APIC MSRs interception
      KVM: SVM: Do not virtualize MSR accesses for APIC LVTT register
      KVM: x86: Do not block APIC write for non ICR registers

Tao Xu (1):
      KVM: VMX: Enable Notify VM exit

Thomas Huth (4):
      KVM: s390: selftests: Use TAP interface in the memop test
      KVM: s390: selftests: Use TAP interface in the sync_regs test
      KVM: s390: selftests: Use TAP interface in the tprot test
      KVM: s390: selftests: Use TAP interface in the reset test

Uros Bizjak (3):
      KVM: x86/mmu: Use try_cmpxchg64 in tdp_mmu_set_spte_atomic
      KVM: VMX: Use try_cmpxchg64 in pi_try_set_control
      KVM: x86/mmu: Use try_cmpxchg64 in fast_pf_fix_direct_spte

Vineeth Pillai (1):
      KVM: debugfs: expose pid of vcpu threads

Vitaly Kuznetsov (3):
      KVM: x86: Fully initialize 'struct kvm_lapic_irq' in kvm_pv_kick_cpu_op()
      KVM: nVMX: Always enable TSC scaling for L2 when it was enabled for L1
      KVM: selftests: Use "a" and "d" to set EAX/EDX for wrmsr_safe()

Zeng Guang (6):
      KVM: x86: Add support for vICR APIC-write VM-Exits in x2APIC mode
      KVM: VMX: Clean up vmx_refresh_apicv_exec_ctrl()
      KVM: Move kvm_arch_vcpu_precreate() under kvm->lock
      KVM: x86: Allow userspace to set maximum VCPU id for VM
      kvm: selftests: Add KVM_CAP_MAX_VCPU_ID cap test
      KVM: selftests: Enhance handling WRMSR ICR register in x2APIC mode

Zhang Jiaming (1):
      RISC-V: KVM: Fix variable spelling mistake

 Documentation/admin-guide/kernel-parameters.txt    |    3 +-
 Documentation/virt/kvm/api.rst                     |  344 +++++-
 Documentation/virt/kvm/s390/index.rst              |    1 +
 Documentation/virt/kvm/s390/s390-pv-dump.rst       |   64 ++
 MAINTAINERS                                        |    1 +
 arch/arm64/include/asm/kvm_asm.h                   |   16 +
 arch/arm64/include/asm/kvm_emulate.h               |   11 +-
 arch/arm64/include/asm/kvm_host.h                  |  205 +++-
 arch/arm64/include/asm/memory.h                    |    8 +
 arch/arm64/include/asm/stacktrace.h                |   62 +-
 arch/arm64/include/asm/stacktrace/common.h         |  199 ++++
 arch/arm64/include/asm/stacktrace/nvhe.h           |   55 +
 arch/arm64/kernel/Makefile                         |    5 +
 arch/arm64/kernel/stacktrace.c                     |  184 ++-
 arch/arm64/kvm/Kconfig                             |   13 +
 arch/arm64/kvm/Makefile                            |    2 +-
 arch/arm64/kvm/arch_timer.c                        |    2 +-
 arch/arm64/kvm/arm.c                               |   25 +-
 arch/arm64/kvm/debug.c                             |   25 +-
 arch/arm64/kvm/fpsimd.c                            |   39 +-
 arch/arm64/kvm/handle_exit.c                       |   10 +-
 arch/arm64/kvm/hyp/exception.c                     |   23 +-
 arch/arm64/kvm/hyp/include/hyp/debug-sr.h          |    6 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h            |   24 +-
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h         |    4 +-
 arch/arm64/kvm/hyp/nvhe/Makefile                   |   14 +-
 arch/arm64/kvm/hyp/nvhe/debug-sr.c                 |    8 +-
 arch/arm64/kvm/hyp/nvhe/host.S                     |    9 +-
 arch/arm64/kvm/hyp/nvhe/stacktrace.c               |  160 +++
 arch/arm64/kvm/hyp/nvhe/switch.c                   |   14 +-
 arch/arm64/kvm/hyp/nvhe/sys_regs.c                 |    4 +-
 arch/arm64/kvm/hyp/vhe/switch.c                    |    6 +-
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c                 |    4 +-
 arch/arm64/kvm/inject_fault.c                      |   17 +-
 arch/arm64/kvm/mmu.c                               |    2 +-
 arch/arm64/kvm/reset.c                             |    6 +-
 arch/arm64/kvm/stacktrace.c                        |  218 ++++
 arch/arm64/kvm/sys_regs.c                          |  294 ++---
 arch/arm64/kvm/sys_regs.h                          |   18 +-
 arch/arm64/kvm/vgic-sys-reg-v3.c                   |  462 ++++----
 arch/arm64/kvm/vgic/vgic-kvm-device.c              |  342 +++---
 arch/arm64/kvm/vgic/vgic-mmio-v3.c                 |   10 +-
 arch/arm64/kvm/vgic/vgic-mmio.c                    |    6 +-
 arch/arm64/kvm/vgic/vgic-mmio.h                    |    4 +-
 arch/arm64/kvm/vgic/vgic.h                         |    9 +-
 arch/riscv/include/asm/csr.h                       |   16 +
 arch/riscv/include/asm/kvm_host.h                  |   24 +-
 arch/riscv/include/asm/kvm_vcpu_fp.h               |    8 +-
 arch/riscv/include/asm/kvm_vcpu_insn.h             |   48 +
 arch/riscv/include/asm/kvm_vcpu_timer.h            |    2 +-
 arch/riscv/include/uapi/asm/kvm.h                  |    1 +
 arch/riscv/kvm/Makefile                            |    1 +
 arch/riscv/kvm/mmu.c                               |   35 +-
 arch/riscv/kvm/vcpu.c                              |  203 ++--
 arch/riscv/kvm/vcpu_exit.c                         |  496 +-------
 arch/riscv/kvm/vcpu_fp.c                           |   27 +-
 arch/riscv/kvm/vcpu_insn.c                         |  752 ++++++++++++
 arch/riscv/kvm/vcpu_timer.c                        |    4 +-
 arch/riscv/kvm/vm.c                                |    4 +-
 arch/s390/boot/uv.c                                |    6 +
 arch/s390/include/asm/airq.h                       |    7 +-
 arch/s390/include/asm/gmap.h                       |   39 +-
 arch/s390/include/asm/kvm_host.h                   |   44 +-
 arch/s390/include/asm/mmu.h                        |    2 +-
 arch/s390/include/asm/mmu_context.h                |    2 +-
 arch/s390/include/asm/pci.h                        |   11 +
 arch/s390/include/asm/pci_clp.h                    |    9 +-
 arch/s390/include/asm/pci_insn.h                   |   29 +-
 arch/s390/include/asm/pgtable.h                    |   21 +-
 arch/s390/include/asm/sclp.h                       |    4 +
 arch/s390/include/asm/tpi.h                        |   13 +
 arch/s390/include/asm/uv.h                         |   51 +-
 arch/s390/include/uapi/asm/kvm.h                   |    1 +
 arch/s390/kernel/uv.c                              |  156 +++
 arch/s390/kvm/Kconfig                              |    1 +
 arch/s390/kvm/Makefile                             |    1 +
 arch/s390/kvm/gaccess.c                            |   96 +-
 arch/s390/kvm/gaccess.h                            |    6 +-
 arch/s390/kvm/intercept.c                          |   15 +
 arch/s390/kvm/interrupt.c                          |   98 +-
 arch/s390/kvm/kvm-s390.c                           |  482 +++++++-
 arch/s390/kvm/kvm-s390.h                           |   16 +
 arch/s390/kvm/pci.c                                |  690 +++++++++++
 arch/s390/kvm/pci.h                                |   87 ++
 arch/s390/kvm/priv.c                               |   26 +-
 arch/s390/kvm/pv.c                                 |  269 ++++-
 arch/s390/kvm/sigp.c                               |    4 +-
 arch/s390/kvm/vsie.c                               |    8 +
 arch/s390/mm/fault.c                               |   23 +-
 arch/s390/mm/gmap.c                                |  177 ++-
 arch/s390/pci/pci.c                                |   16 +
 arch/s390/pci/pci_clp.c                            |    7 +
 arch/s390/pci/pci_insn.c                           |    4 +-
 arch/s390/pci/pci_irq.c                            |   48 +-
 arch/s390/tools/gen_facilities.c                   |    1 +
 arch/x86/events/core.c                             |   28 +-
 arch/x86/events/intel/core.c                       |  160 ++-
 arch/x86/events/perf_event.h                       |    6 +-
 arch/x86/hyperv/hv_apic.c                          |    2 +-
 arch/x86/include/asm/apicdef.h                     |    4 +-
 arch/x86/include/asm/cpufeatures.h                 |    1 +
 arch/x86/include/asm/kvm-x86-ops.h                 |    3 +-
 arch/x86/include/asm/kvm-x86-pmu-ops.h             |    2 +-
 arch/x86/include/asm/kvm_host.h                    |   90 +-
 arch/x86/include/asm/msr-index.h                   |    7 +
 arch/x86/include/asm/perf_event.h                  |   11 +-
 arch/x86/include/asm/svm.h                         |   16 +-
 arch/x86/include/asm/vmx.h                         |   18 +
 arch/x86/include/asm/vmxfeatures.h                 |    6 +-
 arch/x86/include/uapi/asm/kvm.h                    |   10 +-
 arch/x86/include/uapi/asm/vmx.h                    |    4 +-
 arch/x86/kernel/apic/apic.c                        |    2 +-
 arch/x86/kernel/apic/ipi.c                         |    2 +-
 arch/x86/kernel/cpu/feat_ctl.c                     |    9 +-
 arch/x86/kernel/kvm.c                              |    3 +-
 arch/x86/kvm/cpuid.c                               |  115 +-
 arch/x86/kvm/cpuid.h                               |   21 +-
 arch/x86/kvm/debugfs.c                             |    4 +-
 arch/x86/kvm/emulate.c                             |   49 +-
 arch/x86/kvm/hyperv.c                              |    8 +-
 arch/x86/kvm/i8254.c                               |   10 +-
 arch/x86/kvm/i8254.h                               |    1 -
 arch/x86/kvm/kvm_emulate.h                         |   28 +-
 arch/x86/kvm/lapic.c                               |  181 ++-
 arch/x86/kvm/lapic.h                               |   20 +-
 arch/x86/kvm/mmu.h                                 |   10 -
 arch/x86/kvm/mmu/mmu.c                             |  967 +++++++++++-----
 arch/x86/kvm/mmu/mmu_internal.h                    |   40 +-
 arch/x86/kvm/mmu/paging.h                          |   14 -
 arch/x86/kvm/mmu/paging_tmpl.h                     |  126 +-
 arch/x86/kvm/mmu/spte.c                            |   43 +-
 arch/x86/kvm/mmu/spte.h                            |   38 +-
 arch/x86/kvm/mmu/tdp_iter.c                        |   15 +-
 arch/x86/kvm/mmu/tdp_iter.h                        |    1 -
 arch/x86/kvm/mmu/tdp_mmu.c                         |   87 +-
 arch/x86/kvm/pmu.c                                 |  212 ++--
 arch/x86/kvm/pmu.h                                 |   45 +-
 arch/x86/kvm/svm/avic.c                            |  170 ++-
 arch/x86/kvm/svm/nested.c                          |   72 +-
 arch/x86/kvm/svm/pmu.c                             |   62 +-
 arch/x86/kvm/svm/sev.c                             |   20 +-
 arch/x86/kvm/svm/svm.c                             |  273 +++--
 arch/x86/kvm/svm/svm.h                             |   39 +-
 arch/x86/kvm/trace.h                               |   51 +-
 arch/x86/kvm/vmx/capabilities.h                    |   57 +-
 arch/x86/kvm/vmx/evmcs.c                           |    2 +
 arch/x86/kvm/vmx/evmcs.h                           |    1 +
 arch/x86/kvm/vmx/nested.c                          |  197 ++--
 arch/x86/kvm/vmx/nested.h                          |    5 +-
 arch/x86/kvm/vmx/pmu_intel.c                       |  198 +++-
 arch/x86/kvm/vmx/posted_intr.c                     |   30 +-
 arch/x86/kvm/vmx/posted_intr.h                     |    2 +
 arch/x86/kvm/vmx/sgx.c                             |   10 +-
 arch/x86/kvm/vmx/vmcs.h                            |    1 +
 arch/x86/kvm/vmx/vmx.c                             |  367 ++++--
 arch/x86/kvm/vmx/vmx.h                             |   95 +-
 arch/x86/kvm/x86.c                                 |  704 ++++++++----
 arch/x86/kvm/x86.h                                 |   35 +-
 arch/x86/kvm/xen.c                                 |   10 +-
 drivers/s390/char/sclp_early.c                     |    4 +
 drivers/s390/cio/airq.c                            |   12 +-
 drivers/s390/cio/qdio_thinint.c                    |    6 +-
 drivers/s390/crypto/ap_bus.c                       |    9 +-
 drivers/s390/virtio/virtio_ccw.c                   |    6 +-
 drivers/vfio/pci/Kconfig                           |   11 +
 drivers/vfio/pci/Makefile                          |    2 +-
 drivers/vfio/pci/vfio_pci_core.c                   |   10 +-
 drivers/vfio/pci/vfio_pci_zdev.c                   |   35 +-
 include/kvm/arm_vgic.h                             |    2 +-
 include/linux/kvm_host.h                           |   20 +-
 include/linux/kvm_types.h                          |    9 +-
 include/linux/sched/user.h                         |    3 +-
 include/linux/vfio_pci_core.h                      |   12 +-
 include/uapi/linux/kvm.h                           |  108 ++
 include/uapi/linux/vfio_zdev.h                     |    7 +
 tools/testing/selftests/kvm/.gitignore             |   10 +-
 tools/testing/selftests/kvm/Makefile               |   17 +-
 tools/testing/selftests/kvm/aarch64/arch_timer.c   |   88 +-
 .../selftests/kvm/aarch64/debug-exceptions.c       |   26 +-
 tools/testing/selftests/kvm/aarch64/get-reg-list.c |   30 +-
 tools/testing/selftests/kvm/aarch64/hypercalls.c   |   97 +-
 tools/testing/selftests/kvm/aarch64/psci_test.c    |   72 +-
 .../selftests/kvm/aarch64/vcpu_width_config.c      |   71 +-
 tools/testing/selftests/kvm/aarch64/vgic_init.c    |  446 ++++----
 tools/testing/selftests/kvm/aarch64/vgic_irq.c     |   44 +-
 .../selftests/kvm/access_tracking_perf_test.c      |   92 +-
 tools/testing/selftests/kvm/demand_paging_test.c   |   49 +-
 tools/testing/selftests/kvm/dirty_log_perf_test.c  |   81 +-
 tools/testing/selftests/kvm/dirty_log_test.c       |   95 +-
 .../testing/selftests/kvm/hardware_disable_test.c  |   29 +-
 .../selftests/kvm/include/aarch64/processor.h      |   28 +-
 tools/testing/selftests/kvm/include/aarch64/vgic.h |    6 +-
 .../testing/selftests/kvm/include/kvm_util_base.h  |  823 +++++++++----
 .../testing/selftests/kvm/include/perf_test_util.h |    7 +-
 .../selftests/kvm/include/riscv/processor.h        |   20 -
 tools/testing/selftests/kvm/include/test_util.h    |    7 +
 tools/testing/selftests/kvm/include/ucall_common.h |   65 +-
 tools/testing/selftests/kvm/include/x86_64/apic.h  |    1 +
 tools/testing/selftests/kvm/include/x86_64/evmcs.h |    2 +-
 tools/testing/selftests/kvm/include/x86_64/mce.h   |   25 +
 .../selftests/kvm/include/x86_64/processor.h       |  474 +++++++-
 tools/testing/selftests/kvm/include/x86_64/svm.h   |    2 -
 .../selftests/kvm/include/x86_64/svm_util.h        |   27 +-
 tools/testing/selftests/kvm/include/x86_64/vmx.h   |    2 -
 .../testing/selftests/kvm/kvm_binary_stats_test.c  |  183 +--
 tools/testing/selftests/kvm/kvm_create_max_vcpus.c |   10 +-
 tools/testing/selftests/kvm/kvm_page_table_test.c  |   66 +-
 .../testing/selftests/kvm/lib/aarch64/processor.c  |   81 +-
 tools/testing/selftests/kvm/lib/aarch64/ucall.c    |   13 +-
 tools/testing/selftests/kvm/lib/aarch64/vgic.c     |   54 +-
 tools/testing/selftests/kvm/lib/elf.c              |    1 -
 tools/testing/selftests/kvm/lib/guest_modes.c      |    6 +-
 tools/testing/selftests/kvm/lib/kvm_util.c         | 1207 +++++---------------
 .../testing/selftests/kvm/lib/kvm_util_internal.h  |  128 ---
 tools/testing/selftests/kvm/lib/perf_test_util.c   |   92 +-
 tools/testing/selftests/kvm/lib/riscv/processor.c  |  111 +-
 tools/testing/selftests/kvm/lib/riscv/ucall.c      |   16 +-
 .../selftests/kvm/lib/s390x/diag318_test_handler.c |   11 +-
 tools/testing/selftests/kvm/lib/s390x/processor.c  |   44 +-
 tools/testing/selftests/kvm/lib/s390x/ucall.c      |   10 +-
 .../selftests/kvm/lib/x86_64/perf_test_util.c      |   11 +-
 tools/testing/selftests/kvm/lib/x86_64/processor.c |  811 +++++--------
 tools/testing/selftests/kvm/lib/x86_64/svm.c       |   17 -
 tools/testing/selftests/kvm/lib/x86_64/ucall.c     |   12 +-
 tools/testing/selftests/kvm/lib/x86_64/vmx.c       |   26 +-
 .../testing/selftests/kvm/max_guest_memory_test.c  |   53 +-
 .../kvm/memslot_modification_stress_test.c         |   13 +-
 tools/testing/selftests/kvm/memslot_perf_test.c    |   32 +-
 tools/testing/selftests/kvm/rseq_test.c            |   22 +-
 tools/testing/selftests/kvm/s390x/memop.c          |  182 ++-
 tools/testing/selftests/kvm/s390x/resets.c         |  178 +--
 tools/testing/selftests/kvm/s390x/sync_regs_test.c |  121 +-
 tools/testing/selftests/kvm/s390x/tprot.c          |   68 +-
 .../testing/selftests/kvm/set_memory_region_test.c |   46 +-
 tools/testing/selftests/kvm/steal_time.c           |  123 +-
 .../selftests/kvm/system_counter_offset_test.c     |   38 +-
 tools/testing/selftests/kvm/x86_64/amx_test.c      |   91 +-
 tools/testing/selftests/kvm/x86_64/cpuid_test.c    |  105 +-
 .../selftests/kvm/x86_64/cr4_cpuid_sync_test.c     |   43 +-
 tools/testing/selftests/kvm/x86_64/debug_regs.c    |   77 +-
 .../selftests/kvm/x86_64/emulator_error_test.c     |   85 +-
 tools/testing/selftests/kvm/x86_64/evmcs_test.c    |   65 +-
 .../selftests/kvm/x86_64/fix_hypercall_test.c      |   47 +-
 .../selftests/kvm/x86_64/get_msr_index_features.c  |  117 +-
 tools/testing/selftests/kvm/x86_64/hyperv_clock.c  |   28 +-
 tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c  |   48 +-
 .../testing/selftests/kvm/x86_64/hyperv_features.c |  406 +++----
 .../testing/selftests/kvm/x86_64/hyperv_svm_test.c |   28 +-
 .../testing/selftests/kvm/x86_64/kvm_clock_test.c  |   32 +-
 tools/testing/selftests/kvm/x86_64/kvm_pv_test.c   |  117 +-
 .../selftests/kvm/x86_64/max_vcpuid_cap_test.c     |   44 +
 .../selftests/kvm/x86_64/mmio_warning_test.c       |   16 +-
 tools/testing/selftests/kvm/x86_64/mmu_role_test.c |  147 ---
 .../selftests/kvm/x86_64/monitor_mwait_test.c      |  131 +++
 .../selftests/kvm/x86_64/nx_huge_pages_test.c      |  269 +++++
 .../selftests/kvm/x86_64/nx_huge_pages_test.sh     |   59 +
 .../selftests/kvm/x86_64/platform_info_test.c      |   51 +-
 .../selftests/kvm/x86_64/pmu_event_filter_test.c   |  117 +-
 .../testing/selftests/kvm/x86_64/set_boot_cpu_id.c |   95 +-
 .../testing/selftests/kvm/x86_64/set_sregs_test.c  |   75 +-
 .../selftests/kvm/x86_64/sev_migrate_tests.c       |  131 +--
 tools/testing/selftests/kvm/x86_64/smm_test.c      |   46 +-
 tools/testing/selftests/kvm/x86_64/state_test.c    |   39 +-
 .../selftests/kvm/x86_64/svm_int_ctl_test.c        |   25 +-
 .../kvm/x86_64/svm_nested_soft_inject_test.c       |  211 ++++
 .../testing/selftests/kvm/x86_64/svm_vmcall_test.c |   20 +-
 .../testing/selftests/kvm/x86_64/sync_regs_test.c  |   62 +-
 .../selftests/kvm/x86_64/triple_fault_event_test.c |   90 ++
 tools/testing/selftests/kvm/x86_64/tsc_msrs_test.c |   39 +-
 .../selftests/kvm/x86_64/tsc_scaling_sync.c        |   25 +-
 .../selftests/kvm/x86_64/ucna_injection_test.c     |  316 +++++
 .../selftests/kvm/x86_64/userspace_io_test.c       |   22 +-
 .../selftests/kvm/x86_64/userspace_msr_exit_test.c |  188 ++-
 .../selftests/kvm/x86_64/vmx_apic_access_test.c    |   32 +-
 .../kvm/x86_64/vmx_close_while_nested_test.c       |   21 +-
 .../selftests/kvm/x86_64/vmx_dirty_log_test.c      |   18 +-
 .../vmx_exception_with_invalid_guest_state.c       |   68 +-
 .../kvm/x86_64/vmx_invalid_nested_guest_state.c    |   22 +-
 tools/testing/selftests/kvm/x86_64/vmx_msrs_test.c |   84 ++
 .../kvm/x86_64/vmx_nested_tsc_scaling_test.c       |   33 +-
 .../selftests/kvm/x86_64/vmx_pmu_caps_test.c       |   54 +-
 .../kvm/x86_64/vmx_preemption_timer_test.c         |   38 +-
 .../kvm/x86_64/vmx_set_nested_state_test.c         |  105 +-
 .../selftests/kvm/x86_64/vmx_tsc_adjust_test.c     |   17 +-
 .../testing/selftests/kvm/x86_64/xapic_ipi_test.c  |   48 +-
 .../selftests/kvm/x86_64/xapic_state_test.c        |   82 +-
 .../testing/selftests/kvm/x86_64/xen_shinfo_test.c |   75 +-
 .../testing/selftests/kvm/x86_64/xen_vmcall_test.c |   27 +-
 tools/testing/selftests/kvm/x86_64/xss_msr_test.c  |   56 +-
 virt/kvm/kvm_main.c                                |  217 +++-
 virt/kvm/pfncache.c                                |  231 ++--
 291 files changed, 14762 insertions(+), 8600 deletions(-)
 create mode 100644 Documentation/virt/kvm/s390/s390-pv-dump.rst
 create mode 100644 arch/arm64/include/asm/stacktrace/common.h
 create mode 100644 arch/arm64/include/asm/stacktrace/nvhe.h
 create mode 100644 arch/arm64/kvm/hyp/nvhe/stacktrace.c
 create mode 100644 arch/arm64/kvm/stacktrace.c
 create mode 100644 arch/riscv/include/asm/kvm_vcpu_insn.h
 create mode 100644 arch/riscv/kvm/vcpu_insn.c
 create mode 100644 arch/s390/kvm/pci.c
 create mode 100644 arch/s390/kvm/pci.h
 delete mode 100644 arch/x86/kvm/mmu/paging.h
 create mode 100644 tools/testing/selftests/kvm/include/x86_64/mce.h
 delete mode 100644 tools/testing/selftests/kvm/lib/kvm_util_internal.h
 create mode 100644 tools/testing/selftests/kvm/x86_64/max_vcpuid_cap_test.c
 delete mode 100644 tools/testing/selftests/kvm/x86_64/mmu_role_test.c
 create mode 100644 tools/testing/selftests/kvm/x86_64/monitor_mwait_test.c
 create mode 100644 tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
 create mode 100755 tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.sh
 create mode 100644 tools/testing/selftests/kvm/x86_64/svm_nested_soft_inject_test.c
 create mode 100644 tools/testing/selftests/kvm/x86_64/triple_fault_event_test.c
 create mode 100644 tools/testing/selftests/kvm/x86_64/ucna_injection_test.c
 create mode 100644 tools/testing/selftests/kvm/x86_64/vmx_msrs_test.c

