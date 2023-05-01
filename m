Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 711536F2F6A
	for <lists+kvm@lfdr.de>; Mon,  1 May 2023 10:57:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232043AbjEAIyU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 May 2023 04:54:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbjEAIyS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 May 2023 04:54:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 132FAF9
        for <kvm@vger.kernel.org>; Mon,  1 May 2023 01:53:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682931209;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=kscLclbaWDU8qUyny3Gj/nyiCnBuZ7x+v3e1jnJovqQ=;
        b=X3pXtgkhYx4W23ra/8EQxNXTKHu4s/C0MUmAXUN3Et/cIzPmsWjqiWBbbcO+Hx6C7fo5eK
        z86bG1TbjnPARSpX8igBSOyspfNY+4dTop/nn+0gW3yhV8phghoBRHt04LmjdqPOwCrJ1M
        Kvf2J/A49em+9lqZyF1wR019IYiE05M=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-179-592b-8clN4SYzGa2TeemlA-1; Mon, 01 May 2023 04:53:27 -0400
X-MC-Unique: 592b-8clN4SYzGa2TeemlA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7A1C5101A550;
        Mon,  1 May 2023 08:53:27 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 547B72027043;
        Mon,  1 May 2023 08:53:27 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] KVM changes for Linux 6.4
Date:   Mon,  1 May 2023 04:53:26 -0400
Message-Id: <20230501085326.2997739-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit 197b6b60ae7bc51dd0814953c562833143b292aa:

  Linux 6.3-rc4 (2023-03-26 14:40:20 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to b3c98052d46948a8d65d2778c7f306ff38366aac:

  Merge tag 'kvm-x86-vmx-6.4' of https://github.com/kvm-x86/linux into HEAD (2023-04-26 15:56:51 -0400)

RISC-V changes are missing because there were KVM changes in Palmer
Dabbelt's arch pull request; it has just been committed and it has some
conflicts, but I did my tests last week before you had pulled from
Palmer.  I have asked the RISC-V people to use shared topic branches
in the future.

There are two other conflicts in this pull request:

- a trivial one in arch/arm64/kvm/arm.c that is simply due to an extra
"case" label added in 6.3-rc.

- a semantic one that git *won't* catch, due to a function that has
been renamed (hv_remote_flush_tlb -> hv_flush_remote_tlbs).  See end
of this message for the resolution (patch to be squashed into the merge).
If you have CONFIG_HYPERV enabled, incorrect resolution will cause a
compile failure right away.

Thanks,

Paolo

----------------------------------------------------------------
s390:

* More phys_to_virt conversions

* Improvement of AP management for VSIE (nested virtualization)

ARM64:

* Numerous fixes for the pathological lock inversion issue that
  plagued KVM/arm64 since... forever.

* New framework allowing SMCCC-compliant hypercalls to be forwarded
  to userspace, hopefully paving the way for some more features
  being moved to VMMs rather than be implemented in the kernel.

* Large rework of the timer code to allow a VM-wide offset to be
  applied to both virtual and physical counters as well as a
  per-timer, per-vcpu offset that complements the global one.
  This last part allows the NV timer code to be implemented on
  top.

* A small set of fixes to make sure that we don't change anything
  affecting the EL1&0 translation regime just after having having
  taken an exception to EL2 until we have executed a DSB. This
  ensures that speculative walks started in EL1&0 have completed.

* The usual selftest fixes and improvements.

KVM x86 changes for 6.4:

* Optimize CR0.WP toggling by avoiding an MMU reload when TDP is enabled,
  and by giving the guest control of CR0.WP when EPT is enabled on VMX
  (VMX-only because SVM doesn't support per-bit controls)

* Add CR0/CR4 helpers to query single bits, and clean up related code
  where KVM was interpreting kvm_read_cr4_bits()'s "unsigned long" return
  as a bool

* Move AMD_PSFD to cpufeatures.h and purge KVM's definition

* Avoid unnecessary writes+flushes when the guest is only adding new PTEs

* Overhaul .sync_page() and .invlpg() to utilize .sync_page()'s optimizations
  when emulating invalidations

* Clean up the range-based flushing APIs

* Revamp the TDP MMU's reaping of Accessed/Dirty bits to clear a single
  A/D bit using a LOCK AND instead of XCHG, and skip all of the "handle
  changed SPTE" overhead associated with writing the entire entry

* Track the number of "tail" entries in a pte_list_desc to avoid having
  to walk (potentially) all descriptors during insertion and deletion,
  which gets quite expensive if the guest is spamming fork()

* Disallow virtualizing legacy LBRs if architectural LBRs are available,
  the two are mutually exclusive in hardware

* Disallow writes to immutable feature MSRs (notably PERF_CAPABILITIES)
  after KVM_RUN, similar to CPUID features

* Overhaul the vmx_pmu_caps selftest to better validate PERF_CAPABILITIES

* Apply PMU filters to emulated events and add test coverage to the
  pmu_event_filter selftest

x86 AMD:

* Add support for virtual NMIs

* Fixes for edge cases related to virtual interrupts

x86 Intel:

* Don't advertise XTILE_CFG in KVM_GET_SUPPORTED_CPUID if XTILE_DATA is
  not being reported due to userspace not opting in via prctl()

* Fix a bug in emulation of ENCLS in compatibility mode

* Allow emulation of NOP and PAUSE for L2

* AMX selftests improvements

* Misc cleanups

MIPS:

* Constify MIPS's internal callbacks (a leftover from the hardware enabling
  rework that landed in 6.3)

Generic:

* Drop unnecessary casts from "void *" throughout kvm_main.c

* Tweak the layout of "struct kvm_mmu_memory_cache" to shrink the struct
  size by 8 bytes on 64-bit kernels by utilizing a padding hole

Documentation:

* Fix goof introduced by the conversion to rST

----------------------------------------------------------------
Aaron Lewis (14):
      KVM: selftests: Assert that XTILE is XSAVE-enabled
      KVM: selftests: Assert that both XTILE{CFG,DATA} are XSAVE-enabled
      KVM: selftests: Move XSAVE and OSXSAVE CPUID checks into AMX's init_regs()
      KVM: selftests: Check that the palette table exists before using it
      KVM: selftests: Check that XTILEDATA supports XFD
      KVM: x86/pmu: Prevent the PMU from counting disallowed events
      KVM: x86: Add a helper to handle filtering of unpermitted XCR0 features
      KVM: selftests: Move XGETBV and XSETBV helpers to common code
      KVM: selftests: Add all known XFEATURE masks to common code
      KVM: selftests: Add test to verify KVM's supported XCR0
      KVM: selftests: Add a common helper for the PMU event filter guest code
      KVM: selftests: Add helpers for PMC asserts in PMU event filter test
      KVM: selftests: Print detailed info in PMU event filter asserts
      KVM: selftests: Test the PMU event "Instructions retired"

Ackerley Tng (1):
      KVM: selftests: Adjust VM's initial stack address to align with SysV ABI spec

Anish Moorthy (1):
      KVM: selftests: Fix nsec to sec conversion in demand_paging_test

Binbin Wu (5):
      KVM: x86: Add helpers to query individual CR0/CR4 bits
      KVM: x86: Use boolean return value for is_{pae,pse,paging}()
      KVM: SVM: Use kvm_is_cr4_bit_set() to query SMAP/SMEP in "can emulate"
      KVM: x86: Change return type of is_long_mode() to bool
      KVM: VMX: Use is_64_bit_mode() to check 64-bit mode in SGX handler

Colin Ian King (2):
      KVM: selftests: Fix spelling mistake "KVM_HYPERCAL_EXIT_SMC" -> "KVM_HYPERCALL_EXIT_SMC"
      KVM: selftests: Fix spelling mistake "perrmited" -> "permitted"

David Matlack (3):
      KVM: x86/mmu: Collapse kvm_flush_remote_tlbs_with_{range,address}() together
      KVM: x86/mmu: Rename kvm_flush_remote_tlbs_with_address()
      KVM: x86/mmu: Use gfn_t in kvm_flush_remote_tlbs_range()

Emanuele Giuseppe Esposito (3):
      kvm: vmx: Add IA32_FLUSH_CMD guest support
      kvm: svm: Add IA32_FLUSH_CMD guest support
      kvm: x86: Advertise FLUSH_L1D to user space

Hao Ge (1):
      KVM: selftests: Close opened file descriptor in stable_tsc_check_supported()

Ivan Orlov (1):
      KVM: selftests: Add 'malloc' failure check in vcpu_save_state

Jun Miao (1):
      KVM: Fix comments that refer to the non-existent install_new_memslots()

Lai Jiangshan (16):
      KVM: x86/mmu: Detect write #PF to shadow pages during FNAME(fetch) walk
      KVM: x86/mmu: Remove FNAME(is_self_change_mapping)
      KVM: x86/mmu: Use 64-bit address to invalidate to fix a subtle bug
      KVM: x86/mmu: Move the check in FNAME(sync_page) as kvm_sync_page_check()
      KVM: x86/mmu: Check mmu->sync_page pointer in kvm_sync_page_check()
      KVM: x86/mmu: Set mmu->sync_page as NULL for direct paging
      KVM: x86/mmu: Move the code out of FNAME(sync_page)'s loop body into mmu.c
      KVM: x86/mmu: Reduce the update to the spte in FNAME(sync_spte)
      kvm: x86/mmu: Use KVM_MMU_ROOT_XXX for kvm_mmu_invalidate_addr()
      KVM: x86/mmu: Use kvm_mmu_invalidate_addr() in kvm_mmu_invpcid_gva()
      KVM: x86/mmu: Use kvm_mmu_invalidate_addr() in nested_ept_invalidate_addr()
      KVM: x86/mmu: Allow the roots to be invalid in FNAME(invlpg)
      KVM: x86/mmu: Remove FNAME(invlpg) and use FNAME(sync_spte) to update vTLB instead.
      kvm: x86/mmu: Remove @no_dirty_log from FNAME(prefetch_gpte)
      KVM: x86/mmu: Skip calling mmu->sync_spte() when the spte is 0
      KVM: x86/mmu: Track tail count in pte_list_desc to optimize guest fork()

Li kunyu (1):
      kvm: kvm_main: Remove unnecessary (void*) conversions

Like Xu (6):
      KVM: selftests: Add a helper to read kvm boolean module parameters
      KVM: selftests: Report enable_pmu module value when test is skipped
      KVM: x86/pmu: Zero out pmu->all_valid_pmc_idx each time it's refreshed
      KVM: x86/pmu: Rename pmc_is_enabled() to pmc_is_globally_enabled()
      KVM: x86/pmu: Rewrite reprogram_counters() to improve performance
      KVM: x86/pmu: Fix a typo in kvm_pmu_request_counter_reprogam()

Marc Zyngier (33):
      KVM: arm64: timers: Use a per-vcpu, per-timer accumulator for fractional ns
      arm64: Add CNTPOFF_EL2 register definition
      arm64: Add HAS_ECV_CNTPOFF capability
      KVM: arm64: timers: Use CNTPOFF_EL2 to offset the physical timer
      KVM: arm64: timers: Allow physical offset without CNTPOFF_EL2
      KVM: arm64: Expose {un,}lock_all_vcpus() to the rest of KVM
      KVM: arm64: timers: Allow userspace to set the global counter offset
      KVM: arm64: timers: Allow save/restoring of the physical timer
      KVM: arm64: timers: Rationalise per-vcpu timer init
      KVM: arm64: timers: Abstract per-timer IRQ access
      KVM: arm64: timers: Move the timer IRQs into arch_timer_vm_data
      KVM: arm64: Elide kern_hyp_va() in VHE-specific parts of the hypervisor
      KVM: arm64: timers: Fast-track CNTPCT_EL0 trap handling
      KVM: arm64: timers: Abstract the number of valid timers per vcpu
      KVM: arm64: Document KVM_ARM_SET_CNT_OFFSETS and co
      KVM: arm64: nv: timers: Add a per-timer, per-vcpu offset
      KVM: arm64: nv: timers: Support hyp timer emulation
      KVM: arm64: selftests: Add physical timer registers to the sysreg list
      KVM: arm64: selftests: Deal with spurious timer interrupts
      KVM: arm64: selftests: Augment existing timer test to handle variable offset
      KVM: arm64: Expose SMC/HVC width to userspace
      KVM: arm64: nvhe: Synchronise with page table walker on vcpu run
      KVM: arm64: Handle 32bit CNTPCTSS traps
      KVM: arm64: nvhe: Synchronise with page table walker on TLBI
      KVM: arm64: pkvm: Document the side effects of kvm_flush_dcache_to_poc()
      KVM: arm64: vhe: Synchronise with page table walker on MMU update
      KVM: arm64: vhe: Drop extra isb() on guest exit
      Merge branch kvm-arm64/lock-inversion into kvmarm-master/next
      Merge branch kvm-arm64/timer-vm-offsets into kvmarm-master/next
      Merge branch kvm-arm64/selftest/lpa into kvmarm-master/next
      Merge branch kvm-arm64/selftest/misc-6.4 into kvmarm-master/next
      Merge branch kvm-arm64/smccc-filtering into kvmarm-master/next
      Merge branch kvm-arm64/spec-ptw into kvmarm-master/next

Mark Brown (1):
      KVM: selftests: Comment newly defined aarch64 ID registers

Mathias Krause (7):
      KVM: x86/mmu: Fix comment typo
      KVM: x86: Do not unload MMU roots when only toggling CR0.WP with TDP enabled
      KVM: x86: Ignore CR0.WP toggles in non-paging mode
      KVM: x86: Make use of kvm_read_cr*_bits() when testing bits
      KVM: VMX: Make CR0.WP a guest owned bit
      KVM: x86: Shrink struct kvm_pmu
      KVM: Shrink struct kvm_mmu_memory_cache

Maxim Levitsky (2):
      KVM: nSVM: Raise event on nested VM exit if L1 doesn't intercept IRQs
      KVM: SVM: add wrappers to enable/disable IRET interception

Mingwei Zhang (6):
      KVM: selftests: Add a fully functional "struct xstate" for x86
      KVM: selftests: Fix an error in comment of amx_test
      KVM: selftests: Enable checking on xcomp_bv in amx_test
      KVM: selftests: Add check of CR0.TS in the #NM handler in amx_test
      KVM: selftests: Assert that XTILE_DATA is set in IA32_XFD on #NM
      KVM: selftests: Verify XTILE_DATA in XSTATE isn't affected by IA32_XFD

Nico Boehr (2):
      KVM: s390: interrupt: fix virtual-physical confusion for next alert GISA
      KVM: s390: pci: fix virtual-physical confusion on module unload/load

Oliver Upton (20):
      KVM: arm64: Avoid vcpu->mutex v. kvm->lock inversion in CPU_ON
      KVM: arm64: Avoid lock inversion when setting the VM register width
      KVM: arm64: Use config_lock to protect data ordered against KVM_RUN
      KVM: arm64: Use config_lock to protect vgic state
      KVM: x86: Redefine 'longmode' as a flag for KVM_EXIT_HYPERCALL
      KVM: arm64: Add a helper to check if a VM has ran once
      KVM: arm64: Add vm fd device attribute accessors
      KVM: arm64: Rename SMC/HVC call handler to reflect reality
      KVM: arm64: Start handling SMCs from EL1
      KVM: arm64: Refactor hvc filtering to support different actions
      KVM: arm64: Use a maple tree to represent the SMCCC filter
      KVM: arm64: Add support for KVM_EXIT_HYPERCALL
      KVM: arm64: Introduce support for userspace SMCCC filtering
      KVM: arm64: Return NOT_SUPPORTED to guest for unknown PSCI version
      KVM: arm64: Let errors from SMCCC emulation to reach userspace
      KVM: selftests: Add a helper for SMCCC calls with SMC instruction
      KVM: selftests: Add test for SMCCC filter
      KVM: arm64: Prevent userspace from handling SMC64 arch range
      KVM: arm64: Test that SMC64 arch calls are reserved
      KVM: arm64: vgic: Don't acquire its_lock before config_lock

Paolo Bonzini (10):
      KVM: x86/mmu: Avoid indirect call for get_cr3
      Merge tag 'kvm-s390-next-6.4-1' of https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux into HEAD
      Merge tag 'kvmarm-6.4' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD
      Merge tag 'kvm-x86-generic-6.4' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-misc-6.4' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-mmu-6.4' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-pmu-6.4' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-selftests-6.4' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-svm-6.4' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-vmx-6.4' of https://github.com/kvm-x86/linux into HEAD

Pierre Morel (1):
      KVM: s390: vsie: clarifications on setting the APCB

Reiji Watanabe (2):
      KVM: arm64: Acquire mp_state_lock in kvm_arch_vcpu_ioctl_vcpu_init()
      KVM: arm64: Have kvm_psci_vcpu_on() use WRITE_ONCE() to update mp_state

Robert Hoo (1):
      KVM: x86: Remove a redundant guest cpuid check in kvm_set_cr4()

Ryan Roberts (3):
      KVM: selftests: Fixup config fragment for access_tracking_perf_test
      KVM: selftests: arm64: Fix pte encode/decode for PA bits > 48
      KVM: selftests: arm64: Fix ttbr0_el1 encoding for PA bits > 48

Santosh Shukla (5):
      KVM: nSVM: Don't sync vmcb02 V_IRQ back to vmcb12 if KVM (L0) is intercepting VINTR
      KVM: nSVM: Disable intercept of VINTR if saved L1 host RFLAGS.IF is 0
      KVM: SVM: Add definitions for new bits in VMCB::int_ctrl related to vNMI
      KVM: x86: Add support for SVM's Virtual NMI
      KVM: nSVM: Implement support for nested VNMI

Sean Christopherson (54):
      KVM: x86/mmu: Use EMULTYPE flag to track write #PFs to shadow pages
      KVM: nVMX: Move EVMCS1_SUPPORT_* macros to hyperv.c
      KVM: VMX: Stub out enable_evmcs static key for CONFIG_HYPERV=n
      KVM: VMX: Rename "KVM is using eVMCS" static key to match its wrapper
      KVM: x86/mmu: Sanity check input to kvm_mmu_free_roots()
      KVM: x86/mmu: Rename slot rmap walkers to add clarity and clean up code
      KVM: x86/mmu: Replace comment with an actual lockdep assertion on mmu_lock
      KVM: x86/mmu: Clean up mmu.c functions that put return type on separate line
      KVM: SVM: Fix benign "bool vs. int" comparison in svm_set_cr0()
      KVM: x86: Raise an event request when processing NMIs if an NMI is pending
      KVM: x86: Tweak the code and comment related to handling concurrent NMIs
      KVM: x86: Save/restore all NMIs when multiple NMIs are pending
      x86/cpufeatures: Redefine synthetic virtual NMI bit as AMD's "real" vNMI
      KVM: x86: Route pending NMIs from userspace through process_nmi()
      x86: KVM: Add common feature flag for AMD's PSFD
      KVM: x86: Assert that the emulator doesn't load CS with garbage in !RM
      KVM: MIPS: Make kvm_mips_callbacks const
      KVM: x86/pmu: Disallow legacy LBRs if architectural LBRs are available
      KVM: x86: Revert MSR_IA32_FLUSH_CMD.FLUSH_L1D enabling
      KVM: VMX: Passthrough MSR_IA32_PRED_CMD based purely on host+guest CPUID
      KVM: SVM: Passthrough MSR_IA32_PRED_CMD based purely on host+guest CPUID
      KVM: x86: Move MSR_IA32_PRED_CMD WRMSR emulation to common code
      KVM: x86: Virtualize FLUSH_L1D and passthrough MSR_IA32_FLUSH_CMD
      KVM: SVM: Return the local "r" variable from svm_set_msr()
      KVM: x86: Rename kvm_init_msr_list() to clarify it inits multiple lists
      KVM: x86: Add a helper to query whether or not a vCPU has ever run
      KVM: x86: Add macros to track first...last VMX feature MSRs
      KVM: x86: Generate set of VMX feature MSRs using first/last definitions
      KVM: selftests: Split PMU caps sub-tests to avoid writing MSR after KVM_RUN
      KVM: x86: Disallow writes to immutable feature MSRs after KVM_RUN
      KVM: x86/pmu: WARN and bug the VM if PMU is refreshed after vCPU has run
      KVM: x86/pmu: Zero out LBR capabilities during PMU refresh
      KVM: selftests: Move 0/initial value PERF_CAPS checks to dedicated sub-test
      KVM: selftests: Assert that full-width PMC writes are supported if PDCM=1
      KVM: selftests: Print out failing MSR and value in vcpu_set_msr()
      KVM: selftests: Verify KVM preserves userspace writes to "durable" MSRs
      KVM: selftests: Drop now-redundant checks on PERF_CAPABILITIES writes
      KVM: selftests: Test all fungible features in PERF_CAPABILITIES
      KVM: selftests: Test all immutable non-format bits in PERF_CAPABILITIES
      KVM: selftests: Expand negative testing of guest writes to PERF_CAPABILITIES
      KVM: selftests: Test post-KVM_RUN writes to PERF_CAPABILITIES
      KVM: selftests: Drop "all done!" printf() from PERF_CAPABILITIES test
      KVM: selftests: Refactor LBR_FMT test to avoid use of separate macro
      KVM: selftests: Add negative testcase for PEBS format in PERF_CAPABILITIES
      KVM: selftests: Verify LBRs are disabled if vPMU is disabled
      KVM: VMX: Refactor intel_pmu_{g,}set_msr() to align with other helpers
      KVM: x86: Rename Hyper-V remote TLB hooks to match established scheme
      KVM: x86/mmu: Move filling of Hyper-V's TLB range struct into Hyper-V code
      KVM: x86/mmu: Refresh CR0.WP prior to checking for emulated permission faults
      KVM: nVMX: Emulate NOPs in L2, and PAUSE if it's not intercepted
      KVM: x86: Filter out XTILE_CFG if XTILE_DATA isn't permitted
      KVM: selftests: Rework dynamic XFeature helper to take mask, not bit
      KVM: selftests: Use error codes to signal errors in PMU event filter test
      KVM: selftests: Copy full counter values from guest in PMU event filter test

Shaoqin Huang (1):
      KVM: Add the missed title format

Thomas Huth (6):
      KVM: PPC: Standardize on "int" return types in the powerpc KVM code
      KVM: s390: Use "int" as return type for kvm_s390_get/set_skeys()
      KVM: x86: Remove the KVM_GET_NR_MMU_PAGES ioctl
      KVM: arm64: Limit length in kvm_vm_ioctl_mte_copy_tags() to INT_MAX
      KVM: Standardize on "int" return types instead of "long" in kvm_main.c
      KVM: Change return type of kvm_arch_vm_ioctl() to "int"

Tom Rix (1):
      KVM: x86: set "mitigate_smt_rsb" storage-class-specifier to static

Vipin Sharma (13):
      KVM: x86/mmu: Add a helper function to check if an SPTE needs atomic write
      KVM: x86/mmu: Use kvm_ad_enabled() to determine if TDP MMU SPTEs need wrprot
      KVM: x86/mmu: Consolidate Dirty vs. Writable clearing logic in TDP MMU
      KVM: x86/mmu: Atomically clear SPTE dirty state in the clear-dirty-log flow
      KVM: x86/mmu: Drop access tracking checks when clearing TDP MMU dirty bits
      KVM: x86/mmu: Bypass __handle_changed_spte() when clearing TDP MMU dirty bits
      KVM: x86/mmu: Remove "record_dirty_log" in __tdp_mmu_set_spte()
      KVM: x86/mmu: Clear only A-bit (if enabled) when aging TDP MMU SPTEs
      KVM: x86/mmu: Drop unnecessary dirty log checks when aging TDP MMU SPTEs
      KVM: x86/mmu: Bypass __handle_changed_spte() when aging TDP MMU SPTEs
      KVM: x86/mmu: Remove "record_acc_track" in __tdp_mmu_set_spte()
      KVM: x86/mmu: Remove handle_changed_spte_dirty_log()
      KVM: x86/mmu: Merge all handle_changed_pte*() functions

Xinghui Li (1):
      KVM: SVM: Remove a duplicate definition of VMCB_AVIC_APIC_BAR_MASK

Yu Zhang (2):
      KVM: nVMX: Remove outdated comments in nested_vmx_setup_ctls_msrs()
      KVM: nVMX: Add helpers to setup VMX control msr configs

 Documentation/virt/kvm/api.rst                     |  75 ++-
 Documentation/virt/kvm/devices/vm.rst              |  79 +++
 Documentation/virt/kvm/locking.rst                 |   2 +-
 arch/arm64/include/asm/kvm_host.h                  |  29 +-
 arch/arm64/include/asm/kvm_mmu.h                   |   4 +
 arch/arm64/include/asm/sysreg.h                    |   3 +
 arch/arm64/include/uapi/asm/kvm.h                  |  36 ++
 arch/arm64/kernel/cpufeature.c                     |  11 +
 arch/arm64/kvm/arch_timer.c                        | 550 ++++++++++++++++-----
 arch/arm64/kvm/arm.c                               | 150 +++++-
 arch/arm64/kvm/guest.c                             |  39 +-
 arch/arm64/kvm/handle_exit.c                       |  36 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h            |  53 ++
 arch/arm64/kvm/hyp/nvhe/debug-sr.c                 |   2 -
 arch/arm64/kvm/hyp/nvhe/mem_protect.c              |   7 +
 arch/arm64/kvm/hyp/nvhe/switch.c                   |  18 +
 arch/arm64/kvm/hyp/nvhe/timer-sr.c                 |  18 +-
 arch/arm64/kvm/hyp/nvhe/tlb.c                      |  38 +-
 arch/arm64/kvm/hyp/vhe/switch.c                    |   7 +-
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c                 |  12 +
 arch/arm64/kvm/hypercalls.c                        | 189 ++++++-
 arch/arm64/kvm/pmu-emul.c                          |  25 +-
 arch/arm64/kvm/psci.c                              |  37 +-
 arch/arm64/kvm/reset.c                             |  15 +-
 arch/arm64/kvm/sys_regs.c                          |  10 +
 arch/arm64/kvm/trace_arm.h                         |   6 +-
 arch/arm64/kvm/vgic/vgic-debug.c                   |   8 +-
 arch/arm64/kvm/vgic/vgic-init.c                    |  36 +-
 arch/arm64/kvm/vgic/vgic-its.c                     |  33 +-
 arch/arm64/kvm/vgic/vgic-kvm-device.c              |  85 ++--
 arch/arm64/kvm/vgic/vgic-mmio-v3.c                 |   4 +-
 arch/arm64/kvm/vgic/vgic-mmio.c                    |  12 +-
 arch/arm64/kvm/vgic/vgic-v4.c                      |  11 +-
 arch/arm64/kvm/vgic/vgic.c                         |  27 +-
 arch/arm64/kvm/vgic/vgic.h                         |   3 -
 arch/arm64/tools/cpucaps                           |   1 +
 arch/arm64/tools/sysreg                            |   4 +
 arch/mips/include/asm/kvm_host.h                   |   2 +-
 arch/mips/kvm/mips.c                               |   4 +-
 arch/mips/kvm/vz.c                                 |   2 +-
 arch/powerpc/include/asm/kvm_ppc.h                 |  14 +-
 arch/powerpc/kvm/book3s_64_mmu_hv.c                |  14 +-
 arch/powerpc/kvm/book3s_64_vio.c                   |   4 +-
 arch/powerpc/kvm/book3s_hv.c                       |   6 +-
 arch/powerpc/kvm/book3s_pr.c                       |   4 +-
 arch/powerpc/kvm/powerpc.c                         |   5 +-
 arch/riscv/kvm/vm.c                                |   3 +-
 arch/s390/kvm/interrupt.c                          |   4 +-
 arch/s390/kvm/kvm-s390.c                           |   7 +-
 arch/s390/kvm/pci.c                                |   2 +-
 arch/s390/kvm/vsie.c                               |  50 +-
 arch/x86/include/asm/cpufeatures.h                 |   9 +-
 arch/x86/include/asm/kvm-x86-ops.h                 |   6 +-
 arch/x86/include/asm/kvm_host.h                    |  89 ++--
 arch/x86/include/asm/svm.h                         |  10 +-
 arch/x86/include/uapi/asm/kvm.h                    |   3 +
 arch/x86/kvm/cpuid.c                               |  18 +-
 arch/x86/kvm/emulate.c                             |   8 +
 arch/x86/kvm/kvm_cache_regs.h                      |  18 +-
 arch/x86/kvm/kvm_onhyperv.c                        |  33 +-
 arch/x86/kvm/kvm_onhyperv.h                        |   5 +-
 arch/x86/kvm/mmu.h                                 |  28 +-
 arch/x86/kvm/mmu/mmu.c                             | 524 ++++++++++++--------
 arch/x86/kvm/mmu/mmu_internal.h                    |  20 +-
 arch/x86/kvm/mmu/paging_tmpl.h                     | 275 +++--------
 arch/x86/kvm/mmu/spte.c                            |   2 +-
 arch/x86/kvm/mmu/tdp_iter.h                        |  48 +-
 arch/x86/kvm/mmu/tdp_mmu.c                         | 215 +++-----
 arch/x86/kvm/pmu.c                                 |  25 +-
 arch/x86/kvm/pmu.h                                 |   2 +-
 arch/x86/kvm/svm/nested.c                          |  91 +++-
 arch/x86/kvm/svm/pmu.c                             |   2 +-
 arch/x86/kvm/svm/svm.c                             | 195 ++++++--
 arch/x86/kvm/svm/svm.h                             |  29 ++
 arch/x86/kvm/svm/svm_onhyperv.h                    |   5 +-
 arch/x86/kvm/vmx/hyperv.c                          | 107 +++-
 arch/x86/kvm/vmx/hyperv.h                          | 115 +----
 arch/x86/kvm/vmx/nested.c                          | 126 +++--
 arch/x86/kvm/vmx/pmu_intel.c                       | 135 ++---
 arch/x86/kvm/vmx/sgx.c                             |   4 +-
 arch/x86/kvm/vmx/vmx.c                             |  96 ++--
 arch/x86/kvm/vmx/vmx.h                             |  20 +-
 arch/x86/kvm/vmx/vmx_ops.h                         |  22 +-
 arch/x86/kvm/x86.c                                 | 256 ++++++----
 arch/x86/kvm/x86.h                                 |  64 ++-
 include/clocksource/arm_arch_timer.h               |   1 +
 include/kvm/arm_arch_timer.h                       |  34 +-
 include/kvm/arm_hypercalls.h                       |   6 +-
 include/kvm/arm_vgic.h                             |   1 +
 include/linux/kvm_host.h                           |   7 +-
 include/linux/kvm_types.h                          |   2 +-
 include/uapi/linux/kvm.h                           |  14 +-
 tools/include/uapi/linux/kvm.h                     |   2 +-
 tools/testing/selftests/kvm/Makefile               |   2 +
 tools/testing/selftests/kvm/aarch64/arch_timer.c   |  56 ++-
 tools/testing/selftests/kvm/aarch64/get-reg-list.c |  15 +-
 tools/testing/selftests/kvm/aarch64/smccc_filter.c | 268 ++++++++++
 tools/testing/selftests/kvm/config                 |   1 +
 tools/testing/selftests/kvm/demand_paging_test.c   |   2 +-
 .../selftests/kvm/include/aarch64/processor.h      |  13 +
 .../testing/selftests/kvm/include/kvm_util_base.h  |   1 +
 .../selftests/kvm/include/x86_64/processor.h       | 124 ++++-
 .../testing/selftests/kvm/lib/aarch64/processor.c  |  91 ++--
 tools/testing/selftests/kvm/lib/kvm_util.c         |   5 +
 tools/testing/selftests/kvm/lib/x86_64/processor.c |  36 +-
 tools/testing/selftests/kvm/x86_64/amx_test.c      | 118 ++---
 .../selftests/kvm/x86_64/pmu_event_filter_test.c   | 253 +++++-----
 .../kvm/x86_64/vmx_nested_tsc_scaling_test.c       |   8 +-
 .../selftests/kvm/x86_64/vmx_pmu_caps_test.c       | 231 +++++++--
 .../testing/selftests/kvm/x86_64/xcr0_cpuid_test.c | 132 +++++
 virt/kvm/kvm_main.c                                |  30 +-
 111 files changed, 4004 insertions(+), 1850 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/aarch64/smccc_filter.c
 create mode 100644 tools/testing/selftests/kvm/x86_64/xcr0_cpuid_test.c


diff --git a/arch/x86/kvm/kvm_onhyperv.h b/arch/x86/kvm/kvm_onhyperv.h
index 2d5f669c1ea1..f9ca3e7432b2 100644
--- a/arch/x86/kvm/kvm_onhyperv.h
+++ b/arch/x86/kvm/kvm_onhyperv.h
@@ -11,7 +11,7 @@ int hv_flush_remote_tlbs_range(struct kvm *kvm, gfn_t gfn, gfn_t nr_pages);
 int hv_flush_remote_tlbs(struct kvm *kvm);
 void hv_track_root_tdp(struct kvm_vcpu *vcpu, hpa_t root_tdp);
 #else /* !CONFIG_HYPERV */
-static inline int hv_remote_flush_tlb(struct kvm *kvm)
+static inline int hv_flush_remote_tlbs(struct kvm *kvm)
 {
 	return -EOPNOTSUPP;
 }
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index a9c940a31f3a..ca32389f3c36 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3843,13 +3843,13 @@ static void svm_flush_tlb_all(struct kvm_vcpu *vcpu)
 {
 	/*
 	 * When running on Hyper-V with EnlightenedNptTlb enabled, remote TLB
-	 * flushes should be routed to hv_remote_flush_tlb() without requesting
+	 * flushes should be routed to hv_flush_remote_tlbs() without requesting
 	 * a "regular" remote flush.  Reaching this point means either there's
-	 * a KVM bug or a prior hv_remote_flush_tlb() call failed, both of
+	 * a KVM bug or a prior hv_flush_remote_tlbs() call failed, both of
 	 * which might be fatal to the guest.  Yell, but try to recover.
 	 */
 	if (WARN_ON_ONCE(svm_hv_is_enlightened_tlb_enabled(vcpu)))
-		hv_remote_flush_tlb(vcpu->kvm);
+		hv_flush_remote_tlbs(vcpu->kvm);
 
 	svm_flush_tlb_asid(vcpu);
 }

