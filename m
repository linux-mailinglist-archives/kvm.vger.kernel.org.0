Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00F9D69BA63
	for <lists+kvm@lfdr.de>; Sat, 18 Feb 2023 15:22:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbjBROWi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 18 Feb 2023 09:22:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbjBROWh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 18 Feb 2023 09:22:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB410144A4
        for <kvm@vger.kernel.org>; Sat, 18 Feb 2023 06:22:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1608860B9A
        for <kvm@vger.kernel.org>; Sat, 18 Feb 2023 14:22:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5EE4C433D2;
        Sat, 18 Feb 2023 14:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676730153;
        bh=OwZiAcDCBb/lzlNWR6GAsjb3hzjeX/7N6Auvs11t66k=;
        h=From:To:Cc:Subject:Date:From;
        b=pXNThFCuD4X9od7xrr/t/1UErnKUWLGpPMD+PXDeZS0u1VN9bVAtnjbLXrIf7O4Un
         Fgu7noXzmJf6c2w2kngorOKnLzOGsiVEQvdD4YOwHyM7S2nhusn+GWZlIgwRXKJzPn
         TycosNxruWuzC9el0+FcpA/PTpS7RFbX1Dsyq1hPRcHFaIj1+ySPqdhgnJ1JODb2c7
         qAIoqHx++SkET7EY9J9ueQMFNTCuXkOEBrmbgzJqOfUrmVKcVDGN8brZ9waBvpDlrg
         I2iOf4pRGfDlsCqZZDxyGDYNR4SxmbblJxTPXcBTEMU3FNFNKb8hV8nLtMCLICYOYy
         Ac8MmH6rqFJXg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pTO6g-00BRGn-A7;
        Sat, 18 Feb 2023 14:22:30 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Akihiko Odaki <akihiko.odaki@daynix.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        Anup Patel <anup@brainfault.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Chao Gao <chao.gao@intel.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Cornelia Huck <cohuck@redhat.com>,
        David Matlack <dmatlack@google.com>,
        D Scott Phillips <scott@os.amperecomputing.com>,
        Eric Farman <farman@linux.ibm.com>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Gavin Shan <gshan@redhat.com>,
        Hector Martin <marcan@marcan.st>,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        James Morse <james.morse@arm.com>,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Kai Huang <kai.huang@intel.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Mark Brown <broonie@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Michael Kelley <mikelley@microsoft.com>,
        Nianyao Tang <tangnianyao@huawei.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Paul Durrant <paul@xen.org>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Quentin Perret <qperret@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Sean Christopherson <seanjc@google.com>,
        Shaoqin Huang <shahuang@redhat.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Thomas Huth <thuth@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Will Deacon <will@kernel.org>, Yuan Yao <yuan.yao@intel.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Subject: [GIT PULL] KVM/arm64 updates for 6.3
Date:   Sat, 18 Feb 2023 14:22:18 +0000
Message-Id: <20230218142218.3816630-1-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, akihiko.odaki@daynix.com, alexandru.elisei@arm.com, andre.przywara@arm.com, andrew.jones@linux.dev, anup@brainfault.org, catalin.marinas@arm.com, chao.gao@intel.com, christoffer.dall@arm.com, christophe.jaillet@wanadoo.fr, cohuck@redhat.com, dmatlack@google.com, scott@os.amperecomputing.com, farman@linux.ibm.com, farosas@linux.ibm.com, gankulkarni@os.amperecomputing.com, gshan@redhat.com, marcan@marcan.st, isaku.yamahata@intel.com, james.morse@arm.com, jiapeng.chong@linux.alibaba.com, kai.huang@intel.com, jiangshan.ljs@antgroup.com, broonie@kernel.org, mpe@ellerman.id.au, mikelley@microsoft.com, tangnianyao@huawei.com, oliver.upton@linux.dev, paul@xen.org, philmd@linaro.org, qperret@google.com, reijiw@google.com, rmk+kernel@armlinux.org.uk, seanjc@google.com, shahuang@redhat.com, suzuki.poulose@arm.com, tglx@linutronix.de, thuth@redhat.com, vkuznets@redhat.com, will@kernel.org, yuan.yao@intel.com, yu.c.zhang@linux.intel.com, yuzenghui@huawei.co
 m, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo,

Here's the bulk of the KVM/arm64 updates for 6.3, see the tag for the
laundry list. A couple of things to note:

- We drag two branches to avoid ugly conflicts:

  * the common KVM 'kvm-hw-enable-refactor' that you already have in
    your tree

  * the arm64 'for-next/sme2' branch

- The whole thing has been pulled together by Oliver who has, I think,
  done a tremendous job

Please pull,

	M.

The following changes since commit 5dc4c995db9eb45f6373a956eb1f69460e69e6d4:

  Linux 6.2-rc4 (2023-01-15 09:22:43 -0600)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-6.3

for you to fetch changes up to 96a4627dbbd48144a65af936b321701c70876026:

  Merge tag ' https://github.com/oupton/linux tags/kvmarm-6.3' from into kvmarm-master/next (2023-02-18 14:06:10 +0000)

----------------------------------------------------------------
KVM/arm64 updates for 6.3

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

 - Drop the vestiges of the old Columbia mailing list and add myself as
   co-maintainer

This also drags in a couple of branches to avoid conflicts:

 - The shared 'kvm-hw-enable-refactor' branch that reworks
   initialization, as it conflicted with the virtual cache topology
   changes.

 - arm64's 'for-next/sme2' branch, as the PSCI relay changes, as both
   touched the EL2 initialization code.

----------------------------------------------------------------
Akihiko Odaki (6):
      arm64/sysreg: Convert CCSIDR_EL1 to automatic generation
      arm64/sysreg: Add CCSIDR2_EL1
      arm64/cache: Move CLIDR macro definitions
      KVM: arm64: Always set HCR_TID2
      KVM: arm64: Mask FEAT_CCIDX
      KVM: arm64: Normalize cache configuration

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

Christophe JAILLET (1):
      KVM: arm64: vgic-v3: Use kstrtobool() instead of strtobool()

David Matlack (10):
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

Isaku Yamahata (3):
      KVM: Drop kvm_count_lock and instead protect kvm_usage_count with kvm_lock
      KVM: Remove on_each_cpu(hardware_disable_nolock) in kvm_exit()
      KVM: Make hardware_enable_failed a local variable in the "enable all" path

Jiapeng Chong (1):
      arm64/sysreg: clean up some inconsistent indenting

Jintack Lim (7):
      arm64: Add ARM64_HAS_NESTED_VIRT cpufeature
      KVM: arm64: nv: Handle HCR_EL2.NV system register traps
      KVM: arm64: nv: Support virtual EL2 exceptions
      KVM: arm64: nv: Inject HVC exceptions to the virtual EL2
      KVM: arm64: nv: Handle SMCs taken from virtual EL2
      KVM: arm64: nv: Add accessors for SPSR_EL1, ELR_EL1 and VBAR_EL1 from virtual EL2
      KVM: arm64: nv: Emulate EL12 register accesses from the virtual EL2

Lai Jiangshan (1):
      kvm: x86/mmu: Warn on linking when sp->unsync_children

Marc Zyngier (19):
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
      arm64/sme: Fix __finalise_el2 SMEver check
      KVM: arm64: Fix non-kerneldoc comments
      KVM: arm64: Use the S2 MMU context to iterate over S2 table
      KVM: arm64: nv: Add EL2 system registers to vcpu context
      KVM: arm64: nv: Emulate PSTATE.M for a guest hypervisor
      KVM: arm64: nv: Allow a sysreg to be hidden from userspace only
      KVM: arm64: nv: Filter out unsupported features from ID regs
      Merge tag ' https://github.com/oupton/linux tags/kvmarm-6.3' from into kvmarm-master/next

Mark Brown (23):
      arm64/sme: Rename za_state to sme_state
      arm64: Document boot requirements for SME 2
      arm64/sysreg: Update system registers for SME 2 and 2.1
      arm64/sme: Document SME 2 and SME 2.1 ABI
      arm64/esr: Document ISS for ZT0 being disabled
      arm64/sme: Manually encode ZT0 load and store instructions
      arm64/sme: Enable host kernel to access ZT0
      arm64/sme: Add basic enumeration for SME2
      arm64/sme: Provide storage for ZT0
      arm64/sme: Implement context switching for ZT0
      arm64/sme: Implement signal handling for ZT
      arm64/sme: Implement ZT0 ptrace support
      arm64/sme: Add hwcaps for SME 2 and 2.1 features
      kselftest/arm64: Add a stress test program for ZT0
      kselftest/arm64: Cover ZT in the FP stress test
      kselftest/arm64: Enumerate SME2 in the signal test utility code
      kselftest/arm64: Teach the generic signal context validation about ZT
      kselftest/arm64: Add test coverage for ZT register signal frames
      kselftest/arm64: Add SME2 coverage to syscall-abi
      kselftest/arm64: Add coverage of the ZT ptrace regset
      kselftest/arm64: Add coverage of SME 2 and 2.1 hwcaps
      kselftest/arm64: Remove redundant _start labels from zt-test
      KVM: selftests: Enable USERFAULTFD

Nianyao Tang (1):
      KVM: arm64: Synchronize SMEN on vcpu schedule out

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

Paolo Bonzini (1):
      Merge branch 'kvm-late-6.1' into HEAD

Quentin Perret (4):
      KVM: arm64: Provide sanitized SYS_ID_AA64SMFR0_EL1 to nVHE
      KVM: arm64: Introduce finalise_el2_state macro
      KVM: arm64: Use sanitized values in __check_override in nVHE
      KVM: arm64: Finalise EL2 state from pKVM PSCI relay

Sean Christopherson (46):
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

Shaoqin Huang (1):
      KVM: selftests: Remove redundant setbuf()

Thomas Huth (2):
      KVM: selftests: Use TAP interface in the kvm_binary_stats_test
      KVM: selftests: x86: Use TAP interface in the tsc_msrs_test

Vitaly Kuznetsov (11):
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

Yu Zhang (1):
      KVM: MMU: Make the definition of 'INVALID_GPA' common

 Documentation/admin-guide/kernel-parameters.txt    |   7 +-
 Documentation/arm64/booting.rst                    |  10 +
 Documentation/arm64/elf_hwcaps.rst                 |  18 +
 Documentation/arm64/sme.rst                        |  52 ++-
 Documentation/virt/kvm/locking.rst                 |  25 +-
 MAINTAINERS                                        |   3 +-
 arch/arm64/include/asm/cache.h                     |   9 +
 arch/arm64/include/asm/cpufeature.h                |   6 +
 arch/arm64/include/asm/el2_setup.h                 |  99 +++++
 arch/arm64/include/asm/esr.h                       |   5 +
 arch/arm64/include/asm/fpsimd.h                    |  30 +-
 arch/arm64/include/asm/fpsimdmacros.h              |  22 +
 arch/arm64/include/asm/hwcap.h                     |   6 +
 arch/arm64/include/asm/kvm_arm.h                   |  23 +-
 arch/arm64/include/asm/kvm_emulate.h               |  70 +++-
 arch/arm64/include/asm/kvm_host.h                  |  67 ++-
 arch/arm64/include/asm/kvm_hyp.h                   |   1 +
 arch/arm64/include/asm/kvm_mmu.h                   |  15 +-
 arch/arm64/include/asm/kvm_nested.h                |  20 +
 arch/arm64/include/asm/kvm_pgtable.h               |   8 +
 arch/arm64/include/asm/processor.h                 |   2 +-
 arch/arm64/include/asm/sysreg.h                    |  39 +-
 arch/arm64/include/uapi/asm/hwcap.h                |   6 +
 arch/arm64/include/uapi/asm/kvm.h                  |   1 +
 arch/arm64/include/uapi/asm/sigcontext.h           |  19 +
 arch/arm64/kernel/cacheinfo.c                      |   5 -
 arch/arm64/kernel/cpufeature.c                     |  53 +++
 arch/arm64/kernel/cpuinfo.c                        |   6 +
 arch/arm64/kernel/entry-fpsimd.S                   |  30 +-
 arch/arm64/kernel/fpsimd.c                         |  47 ++-
 arch/arm64/kernel/hyp-stub.S                       |  79 +---
 arch/arm64/kernel/idreg-override.c                 |   1 +
 arch/arm64/kernel/process.c                        |  21 +-
 arch/arm64/kernel/ptrace.c                         |  60 ++-
 arch/arm64/kernel/signal.c                         | 113 ++++-
 arch/arm64/kvm/Kconfig                             |   1 +
 arch/arm64/kvm/Makefile                            |   2 +-
 arch/arm64/kvm/arch_timer.c                        | 106 ++---
 arch/arm64/kvm/arm.c                               | 109 ++---
 arch/arm64/kvm/emulate-nested.c                    | 203 +++++++++
 arch/arm64/kvm/fpsimd.c                            |   3 +-
 arch/arm64/kvm/guest.c                             |   6 +
 arch/arm64/kvm/handle_exit.c                       |  47 ++-
 arch/arm64/kvm/hyp/exception.c                     |  48 ++-
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h         |  21 +-
 arch/arm64/kvm/hyp/nvhe/hyp-init.S                 |   1 +
 arch/arm64/kvm/hyp/nvhe/sys_regs.c                 |   1 +
 arch/arm64/kvm/hyp/pgtable.c                       |  43 +-
 arch/arm64/kvm/hyp/vhe/switch.c                    |  26 +-
 arch/arm64/kvm/hypercalls.c                        |   2 +-
 arch/arm64/kvm/inject_fault.c                      |  61 ++-
 arch/arm64/kvm/mmu.c                               |  46 +--
 arch/arm64/kvm/nested.c                            | 161 ++++++++
 arch/arm64/kvm/pvtime.c                            |   8 +-
 arch/arm64/kvm/reset.c                             |  25 +-
 arch/arm64/kvm/sys_regs.c                          | 459 ++++++++++++++++-----
 arch/arm64/kvm/sys_regs.h                          |  14 +-
 arch/arm64/kvm/trace_arm.h                         |  59 +++
 arch/arm64/kvm/vgic/vgic-init.c                    |  21 +-
 arch/arm64/kvm/vgic/vgic-mmio.c                    |  13 +-
 arch/arm64/kvm/vgic/vgic-v3.c                      |   9 +-
 arch/arm64/kvm/vmid.c                              |   6 +-
 arch/arm64/tools/cpucaps                           |   2 +
 arch/arm64/tools/gen-sysreg.awk                    |  20 +-
 arch/arm64/tools/sysreg                            |  44 +-
 arch/mips/include/asm/kvm_host.h                   |   3 +-
 arch/mips/kvm/Kconfig                              |   1 +
 arch/mips/kvm/Makefile                             |   2 +-
 arch/mips/kvm/callback.c                           |  14 -
 arch/mips/kvm/mips.c                               |  34 +-
 arch/mips/kvm/vz.c                                 |   7 +-
 arch/powerpc/include/asm/kvm_host.h                |   3 -
 arch/powerpc/include/asm/kvm_ppc.h                 |   1 -
 arch/powerpc/kvm/book3s.c                          |  12 +-
 arch/powerpc/kvm/e500.c                            |   6 +-
 arch/powerpc/kvm/e500mc.c                          |   6 +-
 arch/powerpc/kvm/powerpc.c                         |  20 -
 arch/riscv/include/asm/kvm_host.h                  |   7 +-
 arch/riscv/kvm/Kconfig                             |   1 +
 arch/riscv/kvm/main.c                              |  23 +-
 arch/riscv/kvm/mmu.c                               |  12 +-
 arch/riscv/kvm/vmid.c                              |   4 +-
 arch/s390/include/asm/kvm_host.h                   |   1 -
 arch/s390/kvm/interrupt.c                          |   2 +-
 arch/s390/kvm/kvm-s390.c                           |  84 ++--
 arch/s390/kvm/kvm-s390.h                           |   2 +-
 arch/s390/kvm/pci.c                                |   2 +-
 arch/s390/kvm/pci.h                                |   2 +-
 arch/x86/include/asm/hyperv-tlfs.h                 |   3 +
 arch/x86/include/asm/kvm-x86-ops.h                 |   1 +
 arch/x86/include/asm/kvm_host.h                    |  24 +-
 arch/x86/kernel/cpu/mshyperv.c                     |   2 +-
 arch/x86/kvm/Kconfig                               |   1 +
 arch/x86/kvm/cpuid.c                               |  12 +-
 arch/x86/kvm/debugfs.c                             |   2 +
 arch/x86/kvm/emulate.c                             |   1 +
 arch/x86/kvm/hyperv.c                              |  20 +
 arch/x86/kvm/hyperv.h                              |  27 ++
 arch/x86/kvm/i8254.c                               |   4 +-
 arch/x86/kvm/i8259.c                               |   4 +-
 arch/x86/kvm/ioapic.c                              |   1 +
 arch/x86/kvm/irq.c                                 |   1 +
 arch/x86/kvm/irq_comm.c                            |   7 +-
 arch/x86/kvm/kvm_onhyperv.c                        |   1 +
 arch/x86/kvm/lapic.c                               |   8 +-
 arch/x86/kvm/mmu.h                                 |   6 +-
 arch/x86/kvm/mmu/mmu.c                             | 277 ++++++++-----
 arch/x86/kvm/mmu/mmu_internal.h                    |   8 +-
 arch/x86/kvm/mmu/page_track.c                      |   1 +
 arch/x86/kvm/mmu/paging_tmpl.h                     |  12 +-
 arch/x86/kvm/mmu/spte.c                            |   4 +-
 arch/x86/kvm/mmu/spte.h                            |   4 +-
 arch/x86/kvm/mmu/tdp_iter.c                        |   1 +
 arch/x86/kvm/mmu/tdp_mmu.c                         |  14 +-
 arch/x86/kvm/mmu/tdp_mmu.h                         |  25 +-
 arch/x86/kvm/mtrr.c                                |   1 +
 arch/x86/kvm/pmu.c                                 |   1 +
 arch/x86/kvm/reverse_cpuid.h                       |   7 +
 arch/x86/kvm/smm.c                                 |   1 +
 arch/x86/kvm/svm/avic.c                            |   2 +-
 arch/x86/kvm/svm/nested.c                          |   2 +-
 arch/x86/kvm/svm/pmu.c                             |   2 +
 arch/x86/kvm/svm/sev.c                             |   1 +
 arch/x86/kvm/svm/svm.c                             |  89 ++--
 arch/x86/kvm/svm/svm_onhyperv.c                    |   1 +
 arch/x86/kvm/svm/svm_onhyperv.h                    |   4 +-
 arch/x86/kvm/vmx/capabilities.h                    |   4 +-
 arch/x86/kvm/vmx/hyperv.c                          |  87 +++-
 arch/x86/kvm/vmx/hyperv.h                          |  97 ++++-
 arch/x86/kvm/vmx/nested.c                          |   3 +-
 arch/x86/kvm/vmx/pmu_intel.c                       |   5 +-
 arch/x86/kvm/vmx/posted_intr.c                     |   2 +
 arch/x86/kvm/vmx/sgx.c                             |   5 +-
 arch/x86/kvm/vmx/vmcs12.c                          |   1 +
 arch/x86/kvm/vmx/vmx.c                             | 441 +++++++++++---------
 arch/x86/kvm/vmx/vmx_ops.h                         |   4 +-
 arch/x86/kvm/x86.c                                 | 252 ++++++-----
 arch/x86/kvm/xen.c                                 |   1 +
 drivers/irqchip/irq-apple-aic.c                    |  53 ++-
 include/kvm/arm_arch_timer.h                       |   6 +-
 include/kvm/arm_vgic.h                             |   4 +
 include/linux/cpuhotplug.h                         |   5 +-
 include/linux/kvm_host.h                           |  13 +-
 include/linux/kvm_types.h                          |   2 +-
 include/uapi/linux/elf.h                           |   1 +
 tools/testing/selftests/arm64/abi/hwcap.c          | 115 ++++++
 .../testing/selftests/arm64/abi/syscall-abi-asm.S  |  43 +-
 tools/testing/selftests/arm64/abi/syscall-abi.c    |  40 +-
 tools/testing/selftests/arm64/fp/.gitignore        |   2 +
 tools/testing/selftests/arm64/fp/Makefile          |   5 +
 tools/testing/selftests/arm64/fp/fp-stress.c       |  29 +-
 tools/testing/selftests/arm64/fp/sme-inst.h        |  20 +
 tools/testing/selftests/arm64/fp/zt-ptrace.c       | 365 ++++++++++++++++
 tools/testing/selftests/arm64/fp/zt-test.S         | 316 ++++++++++++++
 tools/testing/selftests/arm64/signal/.gitignore    |   1 +
 .../testing/selftests/arm64/signal/test_signals.h  |   2 +
 .../selftests/arm64/signal/test_signals_utils.c    |   3 +
 .../selftests/arm64/signal/testcases/testcases.c   |  36 ++
 .../selftests/arm64/signal/testcases/testcases.h   |   1 +
 .../selftests/arm64/signal/testcases/zt_no_regs.c  |  51 +++
 .../selftests/arm64/signal/testcases/zt_regs.c     |  85 ++++
 .../selftests/kvm/aarch64/page_fault_test.c        |   2 -
 tools/testing/selftests/kvm/config                 |   1 +
 .../testing/selftests/kvm/include/x86_64/hyperv.h  | 144 ++++---
 .../selftests/kvm/include/x86_64/processor.h       |   1 +
 .../testing/selftests/kvm/kvm_binary_stats_test.c  |  11 +-
 .../kvm/x86_64/exit_on_emulation_failure_test.c    |   3 -
 .../testing/selftests/kvm/x86_64/hyperv_features.c | 330 +++++++++------
 tools/testing/selftests/kvm/x86_64/tsc_msrs_test.c |  16 +-
 virt/kvm/Kconfig                                   |   3 +
 virt/kvm/kvm_main.c                                | 297 ++++++-------
 171 files changed, 4691 insertions(+), 1593 deletions(-)
 create mode 100644 arch/arm64/include/asm/kvm_nested.h
 create mode 100644 arch/arm64/kvm/emulate-nested.c
 create mode 100644 arch/arm64/kvm/nested.c
 delete mode 100644 arch/mips/kvm/callback.c
 create mode 100644 tools/testing/selftests/arm64/fp/zt-ptrace.c
 create mode 100644 tools/testing/selftests/arm64/fp/zt-test.S
 create mode 100644 tools/testing/selftests/arm64/signal/testcases/zt_no_regs.c
 create mode 100644 tools/testing/selftests/arm64/signal/testcases/zt_regs.c
