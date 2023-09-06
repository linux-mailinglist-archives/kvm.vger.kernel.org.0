Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3486279423C
	for <lists+kvm@lfdr.de>; Wed,  6 Sep 2023 19:49:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242722AbjIFRtk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Sep 2023 13:49:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243296AbjIFRtk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Sep 2023 13:49:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B4821A8
        for <kvm@vger.kernel.org>; Wed,  6 Sep 2023 10:48:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694022529;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=jEuAynF4MWsqLSLYKPLKtqLxdu7STIhU/ZXdeXdzujo=;
        b=PGXuzoWut1QcxcBIx1z27zc/qeXV5lxgsv5evm76pVOnJqDFPnqExmwgNOAYdOZnCC3EXm
        6Hd46pZIAX/p5uAZ5kXfIJxHLRBRsgYE1ZcOwq9qLi7pao07m3oKMEeDwLDoHaE5qLksMN
        mMsQXi9wwpx18G0DVDcdRW3W9LN8D38=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-7-CiVQhAy2N-WuPokVbEh5Ow-1; Wed, 06 Sep 2023 13:48:47 -0400
X-MC-Unique: CiVQhAy2N-WuPokVbEh5Ow-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5FF3B101A529;
        Wed,  6 Sep 2023 17:48:47 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 385731121314;
        Wed,  6 Sep 2023 17:48:47 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] KVM changes for 6.6 merge window
Date:   Wed,  6 Sep 2023 13:48:46 -0400
Message-Id: <20230906174846.234274-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit 2dde18cd1d8fac735875f2e4987f11817cc0bc2c:

  Linux 6.5 (2023-08-27 14:49:51 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to d011151616e73de20c139580b73fa4c7042bd861:

  Merge branch 'kvm-x86-mmu-6.6' into HEAD (2023-09-01 15:50:38 -0400)

There are no conflict, just one remark below about a late-ish rebase
of a topic branch.

----------------------------------------------------------------
ARM:

* Clean up vCPU targets, always returning generic v8 as the preferred target

* Trap forwarding infrastructure for nested virtualization (used for traps
  that are taken from an L2 guest and are needed by the L1 hypervisor)

* FEAT_TLBIRANGE support to only invalidate specific ranges of addresses
  when collapsing a table PTE to a block PTE.  This avoids that the guest
  refills the TLBs again for addresses that aren't covered by the table PTE.

* Fix vPMU issues related to handling of PMUver.

* Don't unnecessary align non-stack allocations in the EL2 VA space

* Drop HCR_VIRT_EXCP_MASK, which was never used...

* Don't use smp_processor_id() in kvm_arch_vcpu_load(),
  but the cpu parameter instead

* Drop redundant call to kvm_set_pfn_accessed() in user_mem_abort()

* Remove prototypes without implementations

RISC-V:

* Zba, Zbs, Zicntr, Zicsr, Zifencei, and Zihpm support for guest

* Added ONE_REG interface for SATP mode

* Added ONE_REG interface to enable/disable multiple ISA extensions

* Improved error codes returned by ONE_REG interfaces

* Added KVM_GET_REG_LIST ioctl() implementation for KVM RISC-V

* Added get-reg-list selftest for KVM RISC-V

s390:

* PV crypto passthrough enablement (Tony, Steffen, Viktor, Janosch)
  Allows a PV guest to use crypto cards. Card access is governed by
  the firmware and once a crypto queue is "bound" to a PV VM every
  other entity (PV or not) looses access until it is not bound
  anymore. Enablement is done via flags when creating the PV VM.

* Guest debug fixes (Ilya)

x86:

* Clean up KVM's handling of Intel architectural events

* Intel bugfixes

* Add support for SEV-ES DebugSwap, allowing SEV-ES guests to use debug
  registers and generate/handle #DBs

* Clean up LBR virtualization code

* Fix a bug where KVM fails to set the target pCPU during an IRTE update

* Fix fatal bugs in SEV-ES intrahost migration

* Fix a bug where the recent (architecturally correct) change to reinject
  #BP and skip INT3 broke SEV guests (can't decode INT3 to skip it)

* Retry APIC map recalculation if a vCPU is added/enabled

* Overhaul emergency reboot code to bring SVM up to par with VMX, tie the
  "emergency disabling" behavior to KVM actually being loaded, and move all of
  the logic within KVM

* Fix user triggerable WARNs in SVM where KVM incorrectly assumes the TSC
  ratio MSR cannot diverge from the default when TSC scaling is disabled
  up related code

* Add a framework to allow "caching" feature flags so that KVM can check if
  the guest can use a feature without needing to search guest CPUID

* Rip out the ancient MMU_DEBUG crud and replace the useful bits with
  CONFIG_KVM_PROVE_MMU

* Fix KVM's handling of !visible guest roots to avoid premature triple fault
  injection

* Overhaul KVM's page-track APIs, and KVMGT's usage, to reduce the API surface
  that is needed by external users (currently only KVMGT), and fix a variety
  of issues in the process

This last item had a silly one-character bug in the topic branch that
was sent to me.  Because it caused pretty bad selftest failures in
some configurations, I decided to squash in the fix.  So, while the
exact commit ids haven't been in linux-next before the merge window,
the code has.

Generic:

* Wrap kvm_{gfn,hva}_range.pte in a union to allow mmu_notifier events to pass
  action specific data without needing to constantly update the main handlers.

* Drop unused function declarations

Selftests:

* Add testcases to x86's sync_regs_test for detecting KVM TOCTOU bugs

* Add support for printf() in guest code and covert all guest asserts to use
  printf-based reporting

* Clean up the PMU event filter test and add new testcases

* Include x86 selftests in the KVM x86 MAINTAINERS entry

----------------------------------------------------------------
Aaron Lewis (5):
      KVM: selftests: Add strnlen() to the string overrides
      KVM: selftests: Add guest_snprintf() to KVM selftests
      KVM: selftests: Add additional pages to the guest to accommodate ucall
      KVM: selftests: Add string formatting options to ucall
      KVM: selftests: Add a selftest for guest prints and formatted asserts

Alexey Kardashevskiy (6):
      KVM: SEV: move set_dr_intercepts/clr_dr_intercepts from the header
      KVM: SEV: Move SEV's GP_VECTOR intercept setup to SEV
      KVM: SEV-ES: explicitly disable debug
      KVM: SVM/SEV/SEV-ES: Rework intercepts
      KVM: SEV: Enable data breakpoints in SEV-ES
      KVM: SEV-ES: Eliminate #DB intercept when DebugSwap enabled

Andrew Jones (9):
      RISC-V: KVM: Improve vector save/restore errors
      RISC-V: KVM: Improve vector save/restore functions
      KVM: arm64: selftests: Replace str_with_index with strdup_printf
      KVM: arm64: selftests: Drop SVE cap check in print_reg
      KVM: arm64: selftests: Remove print_reg's dependency on vcpu_config
      KVM: arm64: selftests: Rename vcpu_config and add to kvm_util.h
      KVM: arm64: selftests: Delete core_reg_fixup
      KVM: arm64: selftests: Split get-reg-list test code
      KVM: arm64: selftests: Finish generalizing get-reg-list

Anup Patel (5):
      RISC-V: KVM: Factor-out ONE_REG related code to its own source file
      RISC-V: KVM: Extend ONE_REG to enable/disable multiple ISA extensions
      RISC-V: KVM: Allow Zba and Zbs extensions for Guest/VM
      RISC-V: KVM: Allow Zicntr, Zicsr, Zifencei, and Zihpm for Guest/VM
      RISC-V: KVM: Sort ISA extensions alphabetically in ONE_REG interface

Bibo Mao (1):
      KVM: selftests: use unified time type for comparison

Daniel Henrique Barboza (10):
      RISC-V: KVM: provide UAPI for host SATP mode
      RISC-V: KVM: return ENOENT in *_one_reg() when reg is unknown
      RISC-V: KVM: use ENOENT in *_one_reg() when extension is unavailable
      RISC-V: KVM: do not EOPNOTSUPP in set_one_reg() zicbo(m|z)
      RISC-V: KVM: do not EOPNOTSUPP in set KVM_REG_RISCV_TIMER_REG
      RISC-V: KVM: use EBUSY when !vcpu->arch.ran_atleast_once
      RISC-V: KVM: avoid EBUSY when writing same ISA val
      RISC-V: KVM: avoid EBUSY when writing the same machine ID val
      RISC-V: KVM: avoid EBUSY when writing the same isa_ext val
      docs: kvm: riscv: document EBUSY in KVM_SET_ONE_REG

David Matlack (3):
      KVM: Rename kvm_arch_flush_remote_tlb() to kvm_arch_flush_remote_tlbs()
      KVM: Allow range-based TLB invalidation from common code
      KVM: Move kvm_arch_flush_remote_tlbs_memslot() to common code

Fuad Tabba (1):
      KVM: arm64: Remove redundant kvm_set_pfn_accessed() from user_mem_abort()

Haibo Xu (6):
      KVM: arm64: selftests: Move reject_set check logic to a function
      KVM: arm64: selftests: Move finalize_vcpu back to run_test
      KVM: selftests: Only do get/set tests on present blessed list
      KVM: selftests: Add skip_set facility to get_reg_list test
      KVM: riscv: Add KVM_GET_REG_LIST API support
      KVM: riscv: selftests: Add get-reg-list test

Ilya Leoshkevich (6):
      KVM: s390: interrupt: Fix single-stepping into interrupt handlers
      KVM: s390: interrupt: Fix single-stepping into program interrupt handlers
      KVM: s390: interrupt: Fix single-stepping kernel-emulated instructions
      KVM: s390: interrupt: Fix single-stepping userspace-emulated instructions
      KVM: s390: interrupt: Fix single-stepping keyless mode exits
      KVM: s390: selftests: Add selftest for single-stepping

Janosch Frank (2):
      Merge tag 'kvm-x86-selftests-immutable-6.6' into next
      Merge remote-tracking branch 'vfio-ap' into next

Jinrong Liang (6):
      KVM: selftests: Add x86 properties for Intel PMU in processor.h
      KVM: selftests: Drop the return of remove_event()
      KVM: selftests: Introduce "struct __kvm_pmu_event_filter" to manipulate filter
      KVM: selftests: Add test cases for unsupported PMU event filter input values
      KVM: selftests: Test if event filter meets expectations on fixed counters
      KVM: selftests: Test gp event filters don't affect fixed event filters

Li zeming (1):
      x86: kvm: x86: Remove unnecessary initial values of variables

Like Xu (3):
      KVM: x86: Use sysfs_emit() instead of sprintf()
      KVM: x86: Remove break statements that will never be executed
      KVM: x86/mmu: Move the lockdep_assert of mmu_lock to inside clear_dirty_pt_masked()

Manali Shukla (1):
      KVM: SVM: correct the size of spec_ctrl field in VMCB save area

Marc Zyngier (35):
      Merge branch kvm-arm64/6.6/generic-vcpu into kvmarm-master/next
      arm64: Add missing VA CMO encodings
      arm64: Add missing ERX*_EL1 encodings
      arm64: Add missing DC ZVA/GVA/GZVA encodings
      arm64: Add TLBI operation encodings
      arm64: Add AT operation encodings
      arm64: Add debug registers affected by HDFGxTR_EL2
      arm64: Add missing BRB/CFP/DVP/CPP instructions
      arm64: Add HDFGRTR_EL2 and HDFGWTR_EL2 layouts
      KVM: arm64: Correctly handle ACCDATA_EL1 traps
      KVM: arm64: Add missing HCR_EL2 trap bits
      KVM: arm64: nv: Add FGT registers
      KVM: arm64: Restructure FGT register switching
      KVM: arm64: nv: Add trap forwarding infrastructure
      KVM: arm64: nv: Add trap forwarding for HCR_EL2
      KVM: arm64: nv: Expose FEAT_EVT to nested guests
      KVM: arm64: nv: Add trap forwarding for MDCR_EL2
      KVM: arm64: nv: Add trap forwarding for CNTHCTL_EL2
      KVM: arm64: nv: Add fine grained trap forwarding infrastructure
      KVM: arm64: nv: Add trap forwarding for HFGxTR_EL2
      KVM: arm64: nv: Add trap forwarding for HFGITR_EL2
      KVM: arm64: nv: Add trap forwarding for HDFGxTR_EL2
      KVM: arm64: nv: Add SVC trap forwarding
      KVM: arm64: nv: Expand ERET trap forwarding to handle FGT
      KVM: arm64: nv: Add switching support for HFGxTR/HDFGxTR
      KVM: arm64: nv: Expose FGT to nested guests
      KVM: arm64: Move HCRX_EL2 switch to load/put on VHE systems
      KVM: arm64: nv: Add support for HCRX_EL2
      KVM: arm64: pmu: Resync EL0 state on counter rotation
      KVM: arm64: pmu: Guard PMU emulation definitions with CONFIG_KVM
      KVM: arm64: nv: Add trap description for SPSR_EL2 and ELR_EL2
      Merge branch kvm-arm64/nv-trap-forwarding into kvmarm-master/next
      Merge branch kvm-arm64/tlbi-range into kvmarm-master/next
      Merge branch kvm-arm64/6.6/pmu-fixes into kvmarm-master/next
      Merge branch kvm-arm64/6.6/misc into kvmarm-master/next

Mark Brown (1):
      arm64: Add feature detection for fine grained traps

Michal Luczaj (5):
      KVM: x86: Fix KVM_CAP_SYNC_REGS's sync_regs() TOCTOU issues
      KVM: selftests: Extend x86's sync_regs_test to check for CR4 races
      KVM: selftests: Extend x86's sync_regs_test to check for event vector races
      KVM: selftests: Extend x86's sync_regs_test to check for exception races
      KVM: x86: Remove x86_emulate_ops::guest_has_long_mode

Mingwei Zhang (1):
      KVM: x86/mmu: Plumb "struct kvm" all the way to pte_list_remove()

Minjie Du (1):
      KVM: selftests: Remove superfluous variable assignment

Oliver Upton (4):
      KVM: arm64: Delete pointless switch statement in kvm_reset_vcpu()
      KVM: arm64: Remove pointless check for changed init target
      KVM: arm64: Replace vCPU target with a configuration flag
      KVM: arm64: Always return generic v8 as the preferred target

Paolo Bonzini (10):
      Merge tag 'kvmarm-6.6' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD
      Merge tag 'kvm-x86-generic-6.6' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-selftests-6.6' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-s390-next-6.6-1' of https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux into HEAD
      Merge tag 'kvm-riscv-6.6-1' of https://github.com/kvm-riscv/linux into HEAD
      Merge tag 'kvm-x86-pmu-6.6' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-vmx-6.6' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-svm-6.6' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-misc-6.6' of https://github.com/kvm-x86/linux into HEAD
      Merge branch 'kvm-x86-mmu-6.6' into HEAD

Raghavendra Rao Ananta (11):
      KVM: Declare kvm_arch_flush_remote_tlbs() globally
      KVM: arm64: Use kvm_arch_flush_remote_tlbs()
      KVM: Remove CONFIG_HAVE_KVM_ARCH_TLB_FLUSH_ALL
      arm64: tlb: Refactor the core flush algorithm of __flush_tlb_range
      arm64: tlb: Implement __flush_s2_tlb_range_op()
      KVM: arm64: Implement __kvm_tlb_flush_vmid_range()
      KVM: arm64: Define kvm_tlb_flush_vmid_range()
      KVM: arm64: Implement kvm_arch_flush_remote_tlbs_range()
      KVM: arm64: Flush only the memslot after write-protect
      KVM: arm64: Invalidate the table entries upon a range
      KVM: arm64: Use TLBI range-based instructions for unmap

Randy Dunlap (1):
      KVM: arm64: nv: Select XARRAY_MULTI to fix build error

Reiji Watanabe (4):
      KVM: arm64: PMU: Disallow vPMU on non-uniform PMUVer
      KVM: arm64: PMU: Avoid inappropriate use of host's PMUVer
      KVM: arm64: PMU: Don't advertise the STALL_SLOT event
      KVM: arm64: PMU: Don't advertise STALL_SLOT_{FRONTEND,BACKEND}

Sean Christopherson (139):
      KVM: SVM: Rewrite sev_es_prepare_switch_to_guest()'s comment about swap types
      KVM: SVM: Don't defer NMI unblocking until next exit for SEV-ES guests
      KVM: SVM: Don't try to pointlessly single-step SEV-ES guests for NMI window
      KVM: selftests: Make TEST_ASSERT_EQ() output look like normal TEST_ASSERT()
      KVM: selftests: Add a shameful hack to preserve/clobber GPRs across ucall
      KVM: selftests: Add formatted guest assert support in ucall framework
      KVM: selftests: Add arch ucall.h and inline simple arch hooks
      KVM: selftests: Add #define of expected KVM exit reason for ucall
      KVM: selftests: Convert aarch_timer to printf style GUEST_ASSERT
      KVM: selftests: Convert debug-exceptions to printf style GUEST_ASSERT
      KVM: selftests: Convert ARM's hypercalls test to printf style GUEST_ASSERT
      KVM: selftests: Convert ARM's page fault test to printf style GUEST_ASSERT
      KVM: selftests: Convert ARM's vGIC IRQ test to printf style GUEST_ASSERT
      KVM: selftests: Convert the memslot performance test to printf guest asserts
      KVM: selftests: Convert s390's memop test to printf style GUEST_ASSERT
      KVM: selftests: Convert s390's tprot test to printf style GUEST_ASSERT
      KVM: selftests: Convert set_memory_region_test to printf-based GUEST_ASSERT
      KVM: selftests: Convert steal_time test to printf style GUEST_ASSERT
      KVM: selftests: Convert x86's CPUID test to printf style GUEST_ASSERT
      KVM: selftests: Convert the Hyper-V extended hypercalls test to printf asserts
      KVM: selftests: Convert the Hyper-V feature test to printf style GUEST_ASSERT
      KVM: selftests: Convert x86's KVM paravirt test to printf style GUEST_ASSERT
      KVM: selftests: Convert the MONITOR/MWAIT test to use printf guest asserts
      KVM: selftests: Convert x86's nested exceptions test to printf guest asserts
      KVM: selftests: Convert x86's set BSP ID test to printf style guest asserts
      KVM: selftests: Convert the nSVM software interrupt test to printf guest asserts
      KVM: selftests: Convert x86's TSC MSRs test to use printf guest asserts
      KVM: selftests: Convert the x86 userspace I/O test to printf guest assert
      KVM: selftests: Convert VMX's PMU capabilities test to printf guest asserts
      KVM: selftests: Convert x86's XCR0 test to use printf-based guest asserts
      KVM: selftests: Rip out old, param-based guest assert macros
      KVM: selftests: Print out guest RIP on unhandled exception
      KVM: selftests: Use GUEST_FAIL() in ARM's arch timer helpers
      KVM: x86: Snapshot host's MSR_IA32_ARCH_CAPABILITIES
      KVM: VMX: Drop unnecessary vmx_fb_clear_ctrl_available "cache"
      KVM: VMX: Drop manual TLB flush when migrating vmcs.APIC_ACCESS_ADDR
      KVM: SVM: Fix dead KVM_BUG() code in LBR MSR virtualization
      KVM: SVM: Clean up handling of LBR virtualization enabled
      KVM: SVM: Use svm_get_lbr_vmcb() helper to handle writes to DEBUGCTL
      KVM: x86/pmu: Use enums instead of hardcoded magic for arch event indices
      KVM: x86/pmu: Simplify intel_hw_event_available()
      KVM: x86/pmu: Require nr fixed_pmc_events to match nr max fixed counters
      KVM: x86/pmu: Move .hw_event_available() check out of PMC filter helper
      KVM: x86: Retry APIC optimized map recalc if vCPU is added/enabled
      x86/reboot: VMCLEAR active VMCSes before emergency reboot
      x86/reboot: Harden virtualization hooks for emergency reboot
      x86/reboot: KVM: Handle VMXOFF in KVM's reboot callback
      x86/reboot: KVM: Disable SVM during reboot via virt/KVM reboot callback
      x86/reboot: Assert that IRQs are disabled when turning off virtualization
      x86/reboot: Hoist "disable virt" helpers above "emergency reboot" path
      x86/reboot: Disable virtualization during reboot iff callback is registered
      x86/reboot: Expose VMCS crash hooks if and only if KVM_{INTEL,AMD} is enabled
      x86/virt: KVM: Open code cpu_has_vmx() in KVM VMX
      x86/virt: KVM: Move VMXOFF helpers into KVM VMX
      KVM: SVM: Make KVM_AMD depend on CPU_SUP_AMD or CPU_SUP_HYGON
      x86/virt: Drop unnecessary check on extended CPUID level in cpu_has_svm()
      x86/virt: KVM: Open code cpu_has_svm() into kvm_is_svm_supported()
      KVM: SVM: Check that the current CPU supports SVM in kvm_is_svm_supported()
      KVM: VMX: Ensure CPU is stable when probing basic VMX support
      x86/virt: KVM: Move "disable SVM" helper into KVM SVM
      KVM: x86: Force kvm_rebooting=true during emergency reboot/crash
      KVM: SVM: Use "standard" stgi() helper when disabling SVM
      KVM: VMX: Skip VMCLEAR logic during emergency reboots if CR4.VMXE=0
      KVM: nSVM: Check instead of asserting on nested TSC scaling support
      KVM: nSVM: Load L1's TSC multiplier based on L1 state, not L2 state
      KVM: nSVM: Use the "outer" helper for writing multiplier to MSR_AMD64_TSC_RATIO
      KVM: SVM: Clean up preemption toggling related to MSR_AMD64_TSC_RATIO
      KVM: x86: Always write vCPU's current TSC offset/ratio in vendor hooks
      KVM: nSVM: Skip writes to MSR_AMD64_TSC_RATIO if guest state isn't loaded
      KVM: Wrap kvm_{gfn,hva}_range.pte in a per-action union
      KVM: x86: Remove WARN sanity check on hypervisor timer vs. UNINITIALIZED vCPU
      KVM: SVM: Take and hold ir_list_lock when updating vCPU's Physical ID entry
      KVM: SVM: Set target pCPU during IRTE update if target vCPU is running
      KVM: x86: Add a framework for enabling KVM-governed x86 features
      KVM: x86/mmu: Use KVM-governed feature framework to track "GBPAGES enabled"
      KVM: VMX: Recompute "XSAVES enabled" only after CPUID update
      KVM: VMX: Check KVM CPU caps, not just VMX MSR support, for XSAVE enabling
      KVM: VMX: Rename XSAVES control to follow KVM's preferred "ENABLE_XYZ"
      KVM: x86: Use KVM-governed feature framework to track "XSAVES enabled"
      KVM: nVMX: Use KVM-governed feature framework to track "nested VMX enabled"
      KVM: nSVM: Use KVM-governed feature framework to track "NRIPS enabled"
      KVM: nSVM: Use KVM-governed feature framework to track "TSC scaling enabled"
      KVM: nSVM: Use KVM-governed feature framework to track "vVM{SAVE,LOAD} enabled"
      KVM: nSVM: Use KVM-governed feature framework to track "LBRv enabled"
      KVM: nSVM: Use KVM-governed feature framework to track "Pause Filter enabled"
      KVM: nSVM: Use KVM-governed feature framework to track "vGIF enabled"
      KVM: nSVM: Use KVM-governed feature framework to track "vNMI enabled"
      KVM: x86: Disallow guest CPUID lookups when IRQs are disabled
      KVM: SVM: Get source vCPUs from source VM for SEV-ES intrahost migration
      KVM: SVM: Skip VMSA init in sev_es_init_vmcb() if pointer is NULL
      KVM: SVM: Don't inject #UD if KVM attempts to skip SEV guest insn
      KVM: SVM: Require nrips support for SEV guests (and beyond)
      KVM: selftests: Reload "good" vCPU state if vCPU hits shutdown
      KVM: selftests: Explicit set #UD when *potentially* injecting exception
      KVM: x86: Update MAINTAINTERS to include selftests
      KVM: VMX: Delete ancient pr_warn() about KVM_SET_TSS_ADDR not being set
      KVM: VMX: Refresh available regs and IDT vectoring info before NMI handling
      KVM: x86/mmu: Guard against collision with KVM-defined PFERR_IMPLICIT_ACCESS
      KVM: x86/mmu: Delete pgprintk() and all its usage
      KVM: x86/mmu: Delete rmap_printk() and all its usage
      KVM: x86/mmu: Delete the "dbg" module param
      KVM: x86/mmu: Avoid pointer arithmetic when iterating over SPTEs
      KVM: x86/mmu: Cleanup sanity check of SPTEs at SP free
      KVM: x86/mmu: Rename MMU_WARN_ON() to KVM_MMU_WARN_ON()
      KVM: x86/mmu: Convert "runtime" WARN_ON() assertions to WARN_ON_ONCE()
      KVM: x86/mmu: Bug the VM if a vCPU ends up in long mode without PAE enabled
      KVM: x86/mmu: Replace MMU_DEBUG with proper KVM_PROVE_MMU Kconfig
      KVM: x86/mmu: Use BUILD_BUG_ON_INVALID() for KVM_MMU_WARN_ON() stub
      KVM: x86/mmu: BUG() in rmap helpers iff CONFIG_BUG_ON_DATA_CORRUPTION=y
      drm/i915/gvt: Verify pfn is "valid" before dereferencing "struct page"
      drm/i915/gvt: Verify hugepages are contiguous in physical address space
      drm/i915/gvt: Put the page reference obtained by KVM's gfn_to_pfn()
      drm/i915/gvt: Explicitly check that vGPU is attached before shadowing
      drm/i915/gvt: Error out on an attempt to shadowing an unknown GTT entry type
      drm/i915/gvt: Don't rely on KVM's gfn_to_pfn() to query possible 2M GTT
      drm/i915/gvt: Use an "unsigned long" to iterate over memslot gfns
      drm/i915/gvt: Drop unused helper intel_vgpu_reset_gtt()
      drm/i915/gvt: Protect gfn hash table with vgpu_lock
      KVM: x86/mmu: Move kvm_arch_flush_shadow_{all,memslot}() to mmu.c
      KVM: x86/mmu: Don't rely on page-track mechanism to flush on memslot change
      KVM: x86/mmu: Don't bounce through page-track mechanism for guest PTEs
      KVM: drm/i915/gvt: Drop @vcpu from KVM's ->track_write() hook
      KVM: x86: Reject memslot MOVE operations if KVMGT is attached
      drm/i915/gvt: Don't bother removing write-protection on to-be-deleted slot
      KVM: x86/mmu: Move KVM-only page-track declarations to internal header
      KVM: x86/mmu: Use page-track notifiers iff there are external users
      KVM: x86/mmu: Drop infrastructure for multiple page-track modes
      KVM: x86/mmu: Rename page-track APIs to reflect the new reality
      KVM: x86/mmu: Assert that correct locks are held for page write-tracking
      KVM: x86/mmu: Bug the VM if write-tracking is used but not enabled
      KVM: x86/mmu: Drop @slot param from exported/external page-track APIs
      KVM: x86/mmu: Handle KVM bookkeeping in page-track APIs, not callers
      drm/i915/gvt: Drop final dependencies on KVM internal details
      KVM: x86/mmu: Add helper to convert root hpa to shadow page
      KVM: x86/mmu: Harden new PGD against roots without shadow pages
      KVM: x86/mmu: Harden TDP MMU iteration against root w/o shadow page
      KVM: x86/mmu: Disallow guest from using !visible slots for page tables
      KVM: x86/mmu: Use dummy root, backed by zero page, for !visible guest roots
      KVM: x86/mmu: Include mmu.h in spte.h

Shaoqin Huang (1):
      KVM: arm64: Use the known cpu id instead of smp_processor_id()

Shiyuan Gao (1):
      KVM: VMX: Rename vmx_get_max_tdp_level() to vmx_get_max_ept_level()

Steffen Eiden (3):
      s390/uv: UV feature check utility
      KVM: s390: Add UV feature negotiation
      KVM: s390: pv: Allow AP-instructions for pv-guests

Takahiro Itazuri (1):
      KVM: x86: Advertise host CPUID 0x80000005 in KVM_GET_SUPPORTED_CPUID

Tao Su (1):
      KVM: x86: Advertise AMX-COMPLEX CPUID to userspace

Thomas Huth (1):
      KVM: selftests: Rename the ASSERT_EQ macro

Viktor Mihajlovski (1):
      KVM: s390: pv: relax WARN_ONCE condition for destroy fast

Vincent Donnefort (1):
      KVM: arm64: Remove size-order align in the nVHE hyp private VA range

Yan Zhao (5):
      drm/i915/gvt: remove interface intel_gvt_is_valid_gfn
      drm/i915/gvt: Don't try to unpin an empty page range
      KVM: x86: Add a new page-track hook to handle memslot deletion
      drm/i915/gvt: switch from ->track_flush_slot() to ->track_remove_region()
      KVM: x86: Remove the unused page-track hook track_flush_slot()

Yue Haibing (3):
      KVM: arm64: Remove unused declarations
      KVM: Remove unused kvm_device_{get,put}() declarations
      KVM: Remove unused kvm_make_cpus_request_mask() declaration

Zenghui Yu (1):
      KVM: arm64: Drop HCR_VIRT_EXCP_MASK

 Documentation/virt/kvm/api.rst                     |    4 +-
 MAINTAINERS                                        |    2 +
 arch/arm/include/asm/arm_pmuv3.h                   |    2 +
 arch/arm64/include/asm/kvm_arm.h                   |   51 +-
 arch/arm64/include/asm/kvm_asm.h                   |    3 +
 arch/arm64/include/asm/kvm_host.h                  |   24 +-
 arch/arm64/include/asm/kvm_mmu.h                   |    1 +
 arch/arm64/include/asm/kvm_nested.h                |    2 +
 arch/arm64/include/asm/kvm_pgtable.h               |   10 +
 arch/arm64/include/asm/sysreg.h                    |  268 ++-
 arch/arm64/include/asm/tlbflush.h                  |  122 +-
 arch/arm64/kernel/cpufeature.c                     |    7 +
 arch/arm64/kvm/Kconfig                             |    2 +-
 arch/arm64/kvm/arm.c                               |   65 +-
 arch/arm64/kvm/emulate-nested.c                    | 1852 ++++++++++++++++++++
 arch/arm64/kvm/guest.c                             |   15 -
 arch/arm64/kvm/handle_exit.c                       |   29 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h            |  139 +-
 arch/arm64/kvm/hyp/include/nvhe/mm.h               |    1 +
 arch/arm64/kvm/hyp/nvhe/hyp-main.c                 |   11 +
 arch/arm64/kvm/hyp/nvhe/mm.c                       |   83 +-
 arch/arm64/kvm/hyp/nvhe/setup.c                    |   27 +-
 arch/arm64/kvm/hyp/nvhe/switch.c                   |    2 +-
 arch/arm64/kvm/hyp/nvhe/tlb.c                      |   30 +
 arch/arm64/kvm/hyp/pgtable.c                       |   63 +-
 arch/arm64/kvm/hyp/vhe/tlb.c                       |   28 +
 arch/arm64/kvm/mmu.c                               |  104 +-
 arch/arm64/kvm/nested.c                            |   11 +-
 arch/arm64/kvm/pmu-emul.c                          |   37 +-
 arch/arm64/kvm/pmu.c                               |   18 +
 arch/arm64/kvm/reset.c                             |   23 +-
 arch/arm64/kvm/sys_regs.c                          |   15 +
 arch/arm64/kvm/trace_arm.h                         |   26 +
 arch/arm64/kvm/vgic/vgic.h                         |    2 -
 arch/arm64/tools/cpucaps                           |    1 +
 arch/arm64/tools/sysreg                            |  129 ++
 arch/mips/include/asm/kvm_host.h                   |    3 +-
 arch/mips/kvm/mips.c                               |   12 +-
 arch/mips/kvm/mmu.c                                |    2 +-
 arch/riscv/include/asm/csr.h                       |    2 +
 arch/riscv/include/asm/kvm_host.h                  |    9 +
 arch/riscv/include/asm/kvm_vcpu_vector.h           |    6 +-
 arch/riscv/include/uapi/asm/kvm.h                  |   16 +
 arch/riscv/kvm/Makefile                            |    1 +
 arch/riscv/kvm/aia.c                               |    4 +-
 arch/riscv/kvm/mmu.c                               |    8 +-
 arch/riscv/kvm/vcpu.c                              |  547 +-----
 arch/riscv/kvm/vcpu_fp.c                           |   12 +-
 arch/riscv/kvm/vcpu_onereg.c                       | 1051 +++++++++++
 arch/riscv/kvm/vcpu_sbi.c                          |   16 +-
 arch/riscv/kvm/vcpu_timer.c                        |   11 +-
 arch/riscv/kvm/vcpu_vector.c                       |   72 +-
 arch/s390/include/asm/kvm_host.h                   |    5 +
 arch/s390/include/asm/uv.h                         |   25 +-
 arch/s390/include/uapi/asm/kvm.h                   |   16 +
 arch/s390/kernel/uv.c                              |    5 +-
 arch/s390/kvm/intercept.c                          |   38 +-
 arch/s390/kvm/interrupt.c                          |   14 +
 arch/s390/kvm/kvm-s390.c                           |  102 +-
 arch/s390/kvm/kvm-s390.h                           |   12 -
 arch/s390/kvm/pv.c                                 |   23 +-
 arch/s390/mm/fault.c                               |    2 +-
 arch/x86/include/asm/cpufeatures.h                 |    1 +
 arch/x86/include/asm/kexec.h                       |    2 -
 arch/x86/include/asm/kvm_host.h                    |   46 +-
 arch/x86/include/asm/kvm_page_track.h              |   71 +-
 arch/x86/include/asm/reboot.h                      |    7 +
 arch/x86/include/asm/svm.h                         |    5 +-
 arch/x86/include/asm/virtext.h                     |  154 --
 arch/x86/include/asm/vmx.h                         |    2 +-
 arch/x86/kernel/crash.c                            |   31 -
 arch/x86/kernel/reboot.c                           |   66 +-
 arch/x86/kvm/Kconfig                               |   15 +-
 arch/x86/kvm/cpuid.c                               |   40 +-
 arch/x86/kvm/cpuid.h                               |   46 +
 arch/x86/kvm/emulate.c                             |    2 -
 arch/x86/kvm/governed_features.h                   |   21 +
 arch/x86/kvm/hyperv.c                              |    1 -
 arch/x86/kvm/kvm_emulate.h                         |    1 -
 arch/x86/kvm/lapic.c                               |   29 +-
 arch/x86/kvm/mmu.h                                 |    2 +
 arch/x86/kvm/mmu/mmu.c                             |  371 ++--
 arch/x86/kvm/mmu/mmu_internal.h                    |   27 +-
 arch/x86/kvm/mmu/page_track.c                      |  292 +--
 arch/x86/kvm/mmu/page_track.h                      |   58 +
 arch/x86/kvm/mmu/paging_tmpl.h                     |   41 +-
 arch/x86/kvm/mmu/spte.c                            |    6 +-
 arch/x86/kvm/mmu/spte.h                            |   21 +-
 arch/x86/kvm/mmu/tdp_iter.c                        |   11 +-
 arch/x86/kvm/mmu/tdp_mmu.c                         |   37 +-
 arch/x86/kvm/pmu.c                                 |    4 +-
 arch/x86/kvm/reverse_cpuid.h                       |    1 +
 arch/x86/kvm/svm/avic.c                            |   59 +-
 arch/x86/kvm/svm/nested.c                          |   57 +-
 arch/x86/kvm/svm/sev.c                             |  100 +-
 arch/x86/kvm/svm/svm.c                             |  327 ++--
 arch/x86/kvm/svm/svm.h                             |   61 +-
 arch/x86/kvm/vmx/capabilities.h                    |    2 +-
 arch/x86/kvm/vmx/hyperv.c                          |    2 +-
 arch/x86/kvm/vmx/nested.c                          |   13 +-
 arch/x86/kvm/vmx/nested.h                          |    2 +-
 arch/x86/kvm/vmx/pmu_intel.c                       |   81 +-
 arch/x86/kvm/vmx/vmx.c                             |  228 +--
 arch/x86/kvm/vmx/vmx.h                             |    3 +-
 arch/x86/kvm/x86.c                                 |   85 +-
 arch/x86/kvm/x86.h                                 |    1 +
 drivers/gpu/drm/i915/gvt/gtt.c                     |  102 +-
 drivers/gpu/drm/i915/gvt/gtt.h                     |    1 -
 drivers/gpu/drm/i915/gvt/gvt.h                     |    3 +-
 drivers/gpu/drm/i915/gvt/kvmgt.c                   |  120 +-
 drivers/gpu/drm/i915/gvt/page_track.c              |   10 +-
 drivers/perf/arm_pmuv3.c                           |    2 +
 drivers/s390/crypto/vfio_ap_ops.c                  |  172 +-
 drivers/s390/crypto/vfio_ap_private.h              |    6 +-
 include/kvm/arm_pmu.h                              |    4 +-
 include/linux/kvm_host.h                           |   53 +-
 tools/arch/x86/include/asm/cpufeatures.h           |    1 +
 tools/testing/selftests/kvm/Makefile               |   20 +-
 .../selftests/kvm/aarch64/aarch32_id_regs.c        |    8 +-
 tools/testing/selftests/kvm/aarch64/arch_timer.c   |   22 +-
 .../selftests/kvm/aarch64/debug-exceptions.c       |    8 +-
 tools/testing/selftests/kvm/aarch64/get-reg-list.c |  554 +-----
 tools/testing/selftests/kvm/aarch64/hypercalls.c   |   20 +-
 .../selftests/kvm/aarch64/page_fault_test.c        |   17 +-
 tools/testing/selftests/kvm/aarch64/vgic_irq.c     |    3 +-
 tools/testing/selftests/kvm/get-reg-list.c         |  401 +++++
 tools/testing/selftests/kvm/guest_print_test.c     |  219 +++
 .../selftests/kvm/include/aarch64/arch_timer.h     |   12 +-
 .../testing/selftests/kvm/include/aarch64/ucall.h  |   20 +
 .../testing/selftests/kvm/include/kvm_util_base.h  |   21 +
 .../selftests/kvm/include/riscv/processor.h        |    3 +
 tools/testing/selftests/kvm/include/riscv/ucall.h  |   20 +
 tools/testing/selftests/kvm/include/s390x/ucall.h  |   19 +
 tools/testing/selftests/kvm/include/test_util.h    |   20 +-
 tools/testing/selftests/kvm/include/ucall_common.h |   98 +-
 .../selftests/kvm/include/x86_64/processor.h       |    5 +
 tools/testing/selftests/kvm/include/x86_64/ucall.h |   13 +
 tools/testing/selftests/kvm/kvm_page_table_test.c  |    8 +-
 tools/testing/selftests/kvm/lib/aarch64/ucall.c    |   11 +-
 tools/testing/selftests/kvm/lib/guest_sprintf.c    |  307 ++++
 tools/testing/selftests/kvm/lib/kvm_util.c         |    6 +-
 tools/testing/selftests/kvm/lib/riscv/ucall.c      |   11 -
 tools/testing/selftests/kvm/lib/s390x/ucall.c      |   10 -
 tools/testing/selftests/kvm/lib/sparsebit.c        |    1 -
 tools/testing/selftests/kvm/lib/string_override.c  |    9 +
 tools/testing/selftests/kvm/lib/test_util.c        |   15 +
 tools/testing/selftests/kvm/lib/ucall_common.c     |   44 +
 tools/testing/selftests/kvm/lib/x86_64/processor.c |   18 +-
 tools/testing/selftests/kvm/lib/x86_64/ucall.c     |   36 +-
 .../testing/selftests/kvm/max_guest_memory_test.c  |    2 +-
 tools/testing/selftests/kvm/memslot_perf_test.c    |    4 +-
 tools/testing/selftests/kvm/riscv/get-reg-list.c   |  872 +++++++++
 tools/testing/selftests/kvm/s390x/cmma_test.c      |   62 +-
 tools/testing/selftests/kvm/s390x/debug_test.c     |  160 ++
 tools/testing/selftests/kvm/s390x/memop.c          |   13 +-
 tools/testing/selftests/kvm/s390x/tprot.c          |   11 +-
 .../testing/selftests/kvm/set_memory_region_test.c |   21 +-
 tools/testing/selftests/kvm/steal_time.c           |   20 +-
 tools/testing/selftests/kvm/x86_64/cpuid_test.c    |   12 +-
 .../kvm/x86_64/dirty_log_page_splitting_test.c     |   18 +-
 .../kvm/x86_64/exit_on_emulation_failure_test.c    |    2 +-
 .../kvm/x86_64/hyperv_extended_hypercalls.c        |    3 +-
 .../testing/selftests/kvm/x86_64/hyperv_features.c |   29 +-
 tools/testing/selftests/kvm/x86_64/kvm_pv_test.c   |    8 +-
 .../selftests/kvm/x86_64/monitor_mwait_test.c      |   35 +-
 .../selftests/kvm/x86_64/nested_exceptions_test.c  |   16 +-
 .../selftests/kvm/x86_64/pmu_event_filter_test.c   |  317 +++-
 .../selftests/kvm/x86_64/recalc_apic_map_test.c    |    6 +-
 .../testing/selftests/kvm/x86_64/set_boot_cpu_id.c |    6 +-
 .../kvm/x86_64/svm_nested_soft_inject_test.c       |   22 +-
 .../testing/selftests/kvm/x86_64/sync_regs_test.c  |  132 ++
 tools/testing/selftests/kvm/x86_64/tsc_msrs_test.c |   34 +-
 .../selftests/kvm/x86_64/userspace_io_test.c       |   10 +-
 .../vmx_exception_with_invalid_guest_state.c       |    2 +-
 .../selftests/kvm/x86_64/vmx_pmu_caps_test.c       |   31 +-
 .../selftests/kvm/x86_64/xapic_state_test.c        |    8 +-
 .../testing/selftests/kvm/x86_64/xcr0_cpuid_test.c |   29 +-
 .../testing/selftests/kvm/x86_64/xen_vmcall_test.c |   20 +-
 virt/kvm/Kconfig                                   |    3 -
 virt/kvm/kvm_main.c                                |   54 +-
 180 files changed, 8839 insertions(+), 3231 deletions(-)
 create mode 100644 arch/riscv/kvm/vcpu_onereg.c
 delete mode 100644 arch/x86/include/asm/virtext.h
 create mode 100644 arch/x86/kvm/governed_features.h
 create mode 100644 arch/x86/kvm/mmu/page_track.h
 create mode 100644 tools/testing/selftests/kvm/get-reg-list.c
 create mode 100644 tools/testing/selftests/kvm/guest_print_test.c
 create mode 100644 tools/testing/selftests/kvm/include/aarch64/ucall.h
 create mode 100644 tools/testing/selftests/kvm/include/riscv/ucall.h
 create mode 100644 tools/testing/selftests/kvm/include/s390x/ucall.h
 create mode 100644 tools/testing/selftests/kvm/include/x86_64/ucall.h
 create mode 100644 tools/testing/selftests/kvm/lib/guest_sprintf.c
 create mode 100644 tools/testing/selftests/kvm/riscv/get-reg-list.c
 create mode 100644 tools/testing/selftests/kvm/s390x/debug_test.c

