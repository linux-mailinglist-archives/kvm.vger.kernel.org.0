Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B68873BA9B
	for <lists+kvm@lfdr.de>; Fri, 23 Jun 2023 16:50:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232271AbjFWOu5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Jun 2023 10:50:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231433AbjFWOuz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Jun 2023 10:50:55 -0400
Received: from out-12.mta1.migadu.com (out-12.mta1.migadu.com [IPv6:2001:41d0:203:375::c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 619BFE42
        for <kvm@vger.kernel.org>; Fri, 23 Jun 2023 07:50:50 -0700 (PDT)
Date:   Fri, 23 Jun 2023 07:50:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1687531848;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=CVPQvaSQbSsoITO5Pk/76mqZwvCi6KvkHD7ry9eK7u0=;
        b=Q2aReBij4fXIxJdvmWlb6Px/2Vo6HwzsB5GR0aK8OLFz4KgtWXvoJ6a8D+ul/0OHZ31eKd
        TF7rJWaQMgcLbhqxNQn9SzrOuUfcksAG8vLHqzR3/OBSbm1ULCIeWFhLll/MfhJnIDpObd
        /2TgKtuRK2nsQi00NeekV34lwsppQko=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        Ricardo Koller <ricarkol@google.com>,
        Fuad Tabba <tabba@google.com>,
        Quentin Perret <qperret@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Dan Carpenter <dan.carpenter@linaro.org>,
        Arnd Bergmann <arnd@kernel.org>, kvmarm@lists.linux.dev,
        kvm@vger.kernel.org
Subject: [GIT PULL] KVM/arm64 updates for 6.5
Message-ID: <ZJWxQuyuWc1AtmEz@thinky-boi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

Here are the KVM/arm64 updates for 6.5. Note that the for-next/module-alloc
branch was merged to resolve a nontrivial conflict with the arm64 tree.

There is still an outstanding conflict with the arm64 tree with a rather
straightforward resolution, I've included mine in the diff at the end.

I will be handling fixes for 6.5, so please expect subsequent pulls to
be coming from me. Marc will take over starting with the 6.6 merge
window.

--
Thanks,
Oliver

The following changes since commit 44c026a73be8038f03dbdeef028b642880cf1511:

  Linux 6.4-rc3 (2023-05-21 14:05:48 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-6.5

for you to fetch changes up to 192df2aa0113ddddee2a93e453ff46610807b425:

  KVM: arm64: Fix misuse of KVM_ARM_VCPU_POWER_OFF bit index (2023-06-22 17:17:14 +0000)

----------------------------------------------------------------
KVM/arm64 updates for 6.5

 - Eager page splitting optimization for dirty logging, optionally
   allowing for a VM to avoid the cost of block splitting in the stage-2
   fault path.

 - Arm FF-A proxy for pKVM, allowing a pKVM host to safely interact with
   services that live in the Secure world. pKVM intervenes on FF-A calls
   to guarantee the host doesn't misuse memory donated to the hyp or a
   pKVM guest.

 - Support for running the split hypervisor with VHE enabled, known as
   'hVHE' mode. This is extremely useful for testing the split
   hypervisor on VHE-only systems, and paves the way for new use cases
   that depend on having two TTBRs available at EL2.

 - Generalized framework for configurable ID registers from userspace.
   KVM/arm64 currently prevents arbitrary CPU feature set configuration
   from userspace, but the intent is to relax this limitation and allow
   userspace to select a feature set consistent with the CPU.

 - Enable the use of Branch Target Identification (FEAT_BTI) in the
   hypervisor.

 - Use a separate set of pointer authentication keys for the hypervisor
   when running in protected mode, as the host is untrusted at runtime.

 - Ensure timer IRQs are consistently released in the init failure
   paths.

 - Avoid trapping CTR_EL0 on systems with Enhanced Virtualization Traps
   (FEAT_EVT), as it is a register commonly read from userspace.

 - Erratum workaround for the upcoming AmpereOne part, which has broken
   hardware A/D state management.

As a consequence of the hVHE series reworking the arm64 software
features framework, the for-next/module-alloc branch from the arm64 tree
comes along for the ride.

----------------------------------------------------------------
Arnd Bergmann (1):
      arm64: kvm: avoid overflow in integer division

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

Mark Rutland (6):
      arm64: module: remove old !KASAN_VMALLOC logic
      arm64: kasan: remove !KASAN_VMALLOC remnants
      arm64: kaslr: split kaslr/module initialization
      arm64: module: move module randomization to module.c
      arm64: module: mandate MODULE_PLTS
      arm64: module: rework module VA range selection

Mostafa Saleh (2):
      KVM: arm64: Use BTI for nvhe
      KVM: arm64: Use different pointer authentication keys for pKVM

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

Will Deacon (8):
      KVM: arm64: Block unsafe FF-A calls from the host
      KVM: arm64: Probe FF-A version and host/hyp partition ID during init
      KVM: arm64: Allocate pages for hypervisor FF-A mailboxes
      KVM: arm64: Handle FFA_RXTX_MAP and FFA_RXTX_UNMAP calls from the host
      KVM: arm64: Add FF-A helpers to share/unshare memory with secure world
      KVM: arm64: Handle FFA_MEM_SHARE calls from the host
      KVM: arm64: Handle FFA_MEM_RECLAIM calls from the host
      KVM: arm64: Handle FFA_MEM_LEND calls from the host

 Documentation/arm64/memory.rst                |   8 +-
 Documentation/arm64/silicon-errata.rst        |   3 +
 Documentation/virt/kvm/api.rst                |  27 +
 arch/arm64/Kconfig                            |  47 +-
 arch/arm64/include/asm/cpufeature.h           |   6 +
 arch/arm64/include/asm/el2_setup.h            |  27 +-
 arch/arm64/include/asm/kvm_arm.h              |   7 +-
 arch/arm64/include/asm/kvm_asm.h              |   4 +
 arch/arm64/include/asm/kvm_emulate.h          |  46 +-
 arch/arm64/include/asm/kvm_host.h             |  61 ++-
 arch/arm64/include/asm/kvm_hyp.h              |  37 +-
 arch/arm64/include/asm/kvm_mmu.h              |   4 +-
 arch/arm64/include/asm/kvm_pgtable.h          |  79 ++-
 arch/arm64/include/asm/kvm_pkvm.h             |  21 +
 arch/arm64/include/asm/memory.h               |  16 +-
 arch/arm64/include/asm/module.h               |   8 -
 arch/arm64/include/asm/module.lds.h           |   2 -
 arch/arm64/include/asm/sysreg.h               |   1 +
 arch/arm64/include/asm/virt.h                 |  12 +-
 arch/arm64/kernel/Makefile                    |   3 +-
 arch/arm64/kernel/cpu_errata.c                |   7 +
 arch/arm64/kernel/cpufeature.c                |  34 +-
 arch/arm64/kernel/ftrace.c                    |   8 +-
 arch/arm64/kernel/head.S                      |   2 +
 arch/arm64/kernel/hyp-stub.S                  |  10 +-
 arch/arm64/kernel/idreg-override.c            |  25 +-
 arch/arm64/kernel/kaslr.c                     |  87 +--
 arch/arm64/kernel/module.c                    | 159 ++++--
 arch/arm64/kernel/setup.c                     |   2 +
 arch/arm64/kvm/arch_timer.c                   |  14 +-
 arch/arm64/kvm/arm.c                          | 201 +++++--
 arch/arm64/kvm/fpsimd.c                       |   4 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h       | 101 +++-
 arch/arm64/kvm/hyp/include/nvhe/ffa.h         |  17 +
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |   3 +
 arch/arm64/kvm/hyp/nvhe/Makefile              |   2 +-
 arch/arm64/kvm/hyp/nvhe/ffa.c                 | 762 ++++++++++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/host.S                |  36 +-
 arch/arm64/kvm/hyp/nvhe/hyp-init.S            |  32 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            |  19 +-
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         |  74 ++-
 arch/arm64/kvm/hyp/nvhe/pkvm.c                |  27 +-
 arch/arm64/kvm/hyp/nvhe/setup.c               |  11 +
 arch/arm64/kvm/hyp/nvhe/switch.c              |  28 +-
 arch/arm64/kvm/hyp/nvhe/timer-sr.c            |  16 +-
 arch/arm64/kvm/hyp/nvhe/tlb.c                 |  52 ++
 arch/arm64/kvm/hyp/pgtable.c                  | 228 +++++++-
 arch/arm64/kvm/hyp/vhe/switch.c               |   2 +-
 arch/arm64/kvm/hyp/vhe/tlb.c                  |  32 ++
 arch/arm64/kvm/mmu.c                          | 207 +++++--
 arch/arm64/kvm/pkvm.c                         |   1 +
 arch/arm64/kvm/reset.c                        |  58 --
 arch/arm64/kvm/sys_regs.c                     | 505 ++++++++++++-----
 arch/arm64/kvm/sys_regs.h                     |  22 +-
 arch/arm64/mm/kasan_init.c                    |  17 +-
 arch/arm64/tools/cpucaps                      |   3 +
 include/kvm/arm_pmu.h                         |   8 +-
 include/linux/arm_ffa.h                       |   8 +
 include/linux/kvm_host.h                      |   2 +
 include/uapi/linux/kvm.h                      |   2 +
 virt/kvm/kvm_main.c                           |   3 +-
 61 files changed, 2631 insertions(+), 619 deletions(-)
 create mode 100644 arch/arm64/kvm/hyp/include/nvhe/ffa.h
 create mode 100644 arch/arm64/kvm/hyp/nvhe/ffa.c

--
diff --cc arch/arm64/kernel/cpufeature.c
index 3d93147179a0,6ea7f23b1287..000000000000
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@@ -2656,23 -2662,27 +2677,44 @@@ static const struct arm64_cpu_capabilit
  		.cpu_enable = cpu_enable_dit,
  		ARM64_CPUID_FIELDS(ID_AA64PFR0_EL1, DIT, IMP)
  	},
+ 	{
+ 		.desc = "Memory Copy and Memory Set instructions",
+ 		.capability = ARM64_HAS_MOPS,
+ 		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
+ 		.matches = has_cpuid_feature,
+ 		.cpu_enable = cpu_enable_mops,
+ 		ARM64_CPUID_FIELDS(ID_AA64ISAR2_EL1, MOPS, IMP)
+ 	},
+ 	{
+ 		.capability = ARM64_HAS_TCR2,
+ 		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
+ 		.matches = has_cpuid_feature,
+ 		ARM64_CPUID_FIELDS(ID_AA64MMFR3_EL1, TCRX, IMP)
+ 	},
+ 	{
+ 		.desc = "Stage-1 Permission Indirection Extension (S1PIE)",
+ 		.capability = ARM64_HAS_S1PIE,
+ 		.type = ARM64_CPUCAP_BOOT_CPU_FEATURE,
+ 		.matches = has_cpuid_feature,
+ 		ARM64_CPUID_FIELDS(ID_AA64MMFR3_EL1, S1PIE, IMP)
+ 	},
 +	{
 +		.desc = "VHE for hypervisor only",
 +		.capability = ARM64_KVM_HVHE,
 +		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
 +		.matches = hvhe_possible,
 +	},
 +	{
 +		.desc = "Enhanced Virtualization Traps",
 +		.capability = ARM64_HAS_EVT,
 +		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
 +		.sys_reg = SYS_ID_AA64MMFR2_EL1,
 +		.sign = FTR_UNSIGNED,
 +		.field_pos = ID_AA64MMFR2_EL1_EVT_SHIFT,
 +		.field_width = 4,
 +		.min_field_value = ID_AA64MMFR2_EL1_EVT_IMP,
 +		.matches = has_cpuid_feature,
 +	},
  	{},
  };
  
