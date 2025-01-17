Return-Path: <kvm+bounces-35771-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 09337A14ED0
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 12:52:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1CEC27A2717
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 11:52:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 349391FE46C;
	Fri, 17 Jan 2025 11:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NUR3fOnC"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AA7F1FE45D;
	Fri, 17 Jan 2025 11:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737114752; cv=none; b=eFgiG4lPOskrji0ZrlgMR3cWr9TWummVGV31OFD9mStfbTid5t/+Fy/sfhhbwA9h7mg3gdfVXwSSyneCJG27SiQLjAqNKRdNVQ8pCcVgMni1N+jiDeX6nHU3vRrDAIwF9+Hg/FUwVrRDovnA6Eo3sPHibwgVBgbCR4wE9V1jE0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737114752; c=relaxed/simple;
	bh=PpuF3wGZW6giaZR2WJGnt6vMMbjdOGwgsGvo41HpJQo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=HBJ/befD9z7g7CYY3zqgT8xU3W+QI5UIPOe9Cgy9+T3qzpMf2UqC3AVrqiT3HgVkyeTw7TlipedOoLoTki6NmPJ5sT4zksLSCJZDAbIvSFK/ofCBOwYWF1MRb0EnDBYZFv6OxFcVKbaGVfbXwL6ZdMQ2IdiCPwMD3HFP8R8Tz3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NUR3fOnC; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B701C4CEDD;
	Fri, 17 Jan 2025 11:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737114752;
	bh=PpuF3wGZW6giaZR2WJGnt6vMMbjdOGwgsGvo41HpJQo=;
	h=From:To:Cc:Subject:Date:From;
	b=NUR3fOnCZh4leiHXsUcNKy/NeIgaO07hAAuewfN12h/WJna4aEVM7UAsKxC800eCD
	 SkieHmz4v0IMD0TKXFg+ljua+2D17nhDXSF50G+bNkjNifLKsOftbTuOLGKD9nKI5i
	 tFPX8dDn813MMGL+uws3ClU2mZVRs0PotEQWNUfLkmJgjcO9mU6QuM+1t7CpUETlG8
	 2XGjS5jYAweW3xEXXwAAYasCg/pl+WpdRWAlSr2PoT286DLUIO1vPT3JPubGwdBPP2
	 /KXIiJWJdb2r1qypODkRZ8wdzggP7zFbL3WEUWC1ZZMvxOs+kQtKZw+r4JTFgUD/3d
	 7zNmCCMz/d55g==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tYkto-00D70p-R4;
	Fri, 17 Jan 2025 11:52:28 +0000
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Chase Conklin <chase.conklin@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Fuad Tabba <tabba@google.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Hardevsinh Palaniya <hardevsinh.palaniya@siliconsignals.io>,
	James Clark <james.clark@linaro.org>,
	Joey Gouly <Joey.Gouly@arm.com>,
	Kalesh Singh <kaleshsingh@google.com>,
	Mark Brown <broonie@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mostafa Saleh <smostafa@google.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Quentin Perret <qperret@google.com>,
	Rob Herring <robh@kernel.org>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Vincent Donnefort <vdonnefort@google.com>,
	Vladimir Murzin <vladimir.murzin@arm.com>,
	Will Deacon <will@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Subject: [GIT PULL] KVM/arm64 updates for 6.14
Date: Fri, 17 Jan 2025 11:52:08 +0000
Message-Id: <20250117115208.1616503-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, anshuman.khandual@arm.com, catalin.marinas@arm.com, chase.conklin@arm.com, christoffer.dall@arm.com, christophe.jaillet@wanadoo.fr, tabba@google.com, gankulkarni@os.amperecomputing.com, hardevsinh.palaniya@siliconsignals.io, james.clark@linaro.org, Joey.Gouly@arm.com, kaleshsingh@google.com, broonie@kernel.org, mark.rutland@arm.com, smostafa@google.com, oliver.upton@linux.dev, qperret@google.com, robh@kernel.org, sfr@canb.auug.org.au, suzuki.poulose@arm.com, thorsten.blum@linux.dev, vdonnefort@google.com, vladimir.murzin@arm.com, will@kernel.org, joey.gouly@arm.com, yuzenghui@huawei.com, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Paolo,

Here's the initial set of KVM/arm64 changes for 6.14. The bulk of the
changes are around debug and protect mode, both of which are being
radically cleaned up. On the feature side, we gain support for
non-protected guests in protected mode, EL2 timer support, and some
better CoreSight support.

The rest is the usual mix of cleanups and bug fixes. Note that this
drags two other branches:

- arm64's for-next/cpufeature to resolve conflicts that were not
  trivial to resolve

- kvmarm-fixes-6.13-3 which was only merged in 6.13-rc7, while this
  branch is firmly based on -rc3, and we had some dependencies with
  it.

As usual, gory details in the tag below.

Please pull,

	M.

The following changes since commit 78d4f34e2115b517bcbfe7ec0d018bbbb6f9b0b8:

  Linux 6.13-rc3 (2024-12-15 15:58:23 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-6.14

for you to fetch changes up to 01009b06a6b52d8439c55b530633a971c13b6cb2:

  arm64/sysreg: Get rid of TRFCR_ELx SysregFields (2025-01-17 11:07:55 +0000)

----------------------------------------------------------------
KVM/arm64 updates for 6.14

* New features:

  - Support for non-protected guest in protected mode, achieving near
    feature parity with the non-protected mode

  - Support for the EL2 timers as part of the ongoing NV support

  - Allow control of hardware tracing for nVHE/hVHE

* Improvements, fixes and cleanups:

  - Massive cleanup of the debug infrastructure, making it a bit less
    awkward and definitely easier to maintain. This should pave the
    way for further optimisations

  - Complete rewrite of pKVM's fixed-feature infrastructure, aligning
    it with the rest of KVM and making the code easier to follow

  - Large simplification of pKVM's memory protection infrastructure

  - Better handling of RES0/RES1 fields for memory-backed system
    registers

  - Add a workaround for Qualcomm's Snapdragon X CPUs, which suffer
    from a pretty nasty timer bug

  - Small collection of cleanups and low-impact fixes

* Dependencies

  - Merge arm64/for-next/cpufeature to resolve conflicts

  - Merge kvmarm-fixes-6.13-3 on which the non-protected memory
    management depends

----------------------------------------------------------------
Fuad Tabba (16):
      KVM: arm64: Group setting traps for protected VMs by control register
      KVM: arm64: Move checking protected vcpu features to a separate function
      KVM: arm64: Remove KVM_ARM_VCPU_POWER_OFF from protected VMs allowed features in pKVM
      KVM: arm64: Use KVM extension checks for allowed protected VM capabilities
      KVM: arm64: Initialize feature id registers for protected VMs
      KVM: arm64: Fix RAS trapping in pKVM for protected VMs
      KVM: arm64: Set protected VM traps based on its view of feature registers
      KVM: arm64: Rework specifying restricted features for protected VMs
      KVM: arm64: Remove fixed_config.h header
      KVM: arm64: Remove redundant setting of HCR_EL2 trap bit
      KVM: arm64: Calculate cptr_el2 traps on activating traps
      KVM: arm64: Refactor kvm_reset_cptr_el2()
      KVM: arm64: Fix the value of the CPTR_EL2 RES1 bitmask for nVHE
      KVM: arm64: Remove PtrAuth guest vcpu flag
      KVM: arm64: Convert the SVE guest vcpu flag to a vm flag
      KVM: arm64: Use kvm_vcpu_has_feature() directly for struct kvm

Hardevsinh Palaniya (1):
      arm64/cpufeature: Refactor conditional logic in init_cpu_ftr_reg()

James Clark (6):
      tools: arm64: Update sysreg.h header files
      arm64/sysreg/tools: Move TRFCR definitions to sysreg
      coresight: trbe: Remove redundant disable call
      KVM: arm64: coresight: Give TRBE enabled state to KVM
      KVM: arm64: Support trace filtering for guests
      coresight: Pass guest TRFCR value to KVM

Kalesh Singh (1):
      arm64: kvm: Introduce nvhe stack size constants

Marc Zyngier (35):
      arm64/sysreg: Allow a 'Mapping' descriptor for system registers
      arm64/sysreg: Get rid of the TCR2_EL1x SysregFields
      arm64/sysreg: Convert *_EL12 accessors to Mapping
      arm64/sysreg: Get rid of CPACR_ELx SysregFields
      KVM: arm64: Manage software step state at load/put
      KVM: arm64: Introduce __pkvm_vcpu_{load,put}()
      KVM: arm64: Consolidate allowed and restricted VM feature checks
      KVM: arm64: nv: Advertise the lack of AArch32 EL0 support
      KVM: arm64: nv: Add handling of EL2-specific timer registers
      KVM: arm64: nv: Sync nested timer state with FEAT_NV2
      KVM: arm64: nv: Publish emulated timer interrupt state in the in-memory state
      KVM: arm64: nv: Use FEAT_ECV to trap access to EL0 timers
      KVM: arm64: nv: Accelerate EL0 timer read accesses when FEAT_ECV in use
      KVM: arm64: nv: Accelerate EL0 counter accesses from hypervisor context
      KVM: arm64: Handle counter access early in non-HYP context
      KVM: arm64: nv: Add trap routing for CNTHCTL_EL2.EL1{NVPCT,NVVCT,TVT,TVCT}
      KVM: arm64: nv: Propagate CNTHCTL_EL2.EL1NV{P,V}CT bits
      KVM: arm64: nv: Sanitise CNTHCTL_EL2
      KVM: arm64: Work around x1e's CNTVOFF_EL2 bogosity
      KVM: arm64: nv: Document EL2 timer API
      Merge remote-tracking branch 'arm64/for-next/cpufeature' into kvm-arm64/pkvm-fixed-features-6.14
      Merge branch kvm-arm64/debug-6.14 into kvmarm-master/next
      Merge branch kvm-arm64/pkvm-np-guest into kvmarm-master/next
      Merge branch kvm-arm64/pkvm-fixed-features-6.14 into kvmarm-master/next
      Merge branch 'kvmarm-fixes-6.13-3'
      KVM: arm64: Fix selftests after sysreg field name update
      KVM: arm64: nv: Always evaluate HCR_EL2 using sanitising accessors
      KVM: arm64: nv: Apply RESx settings to sysreg reset values
      KVM: arm64: nv: Fix doc header layout for timers
      Merge branch kvm-arm64/nv-timers into kvmarm-master/next
      Merge branch kvm-arm64/pkvm-memshare-declutter into kvmarm-master/next
      Merge branch kvm-arm64/coresight-6.14 into kvmarm-master/next
      Merge branch kvm-arm64/nv-resx-fixes-6.14 into kvmarm-master/next
      Merge branch kvm-arm64/misc-6.14 into kvmarm-master/next
      arm64/sysreg: Get rid of TRFCR_ELx SysregFields

Mark Brown (1):
      KVM: arm64: Fix set_id_regs selftest for ASIDBITS becoming unwritable

Mark Rutland (2):
      arm64: cpufeature: Add HAFT to cpucap_is_possible()
      KVM: arm64: Explicitly handle BRBE traps as UNDEFINED

Mostafa Saleh (1):
      Documentation: Update the behaviour of "kvm-arm.mode"

Oliver Upton (22):
      KVM: arm64: Add unified helper for reprogramming counters by mask
      KVM: arm64: Use KVM_REQ_RELOAD_PMU to handle PMCR_EL0.E change
      KVM: arm64: nv: Reload PMU events upon MDCR_EL2.HPME change
      KVM: arm64: Only apply PMCR_EL0.P to the guest range of counters
      KVM: arm64: Drop MDSCR_EL1_DEBUG_MASK
      KVM: arm64: Get rid of __kvm_get_mdcr_el2() and related warts
      KVM: arm64: Track presence of SPE/TRBE in kvm_host_data instead of vCPU
      KVM: arm64: Move host SME/SVE tracking flags to host data
      KVM: arm64: Write MDCR_EL2 directly from kvm_arm_setup_mdcr_el2()
      KVM: arm64: Evaluate debug owner at vcpu_load()
      KVM: arm64: Clean up KVM_SET_GUEST_DEBUG handler
      KVM: arm64: Select debug state to save/restore based on debug owner
      KVM: arm64: Remove debug tracepoints
      KVM: arm64: Remove vestiges of debug_ptr
      KVM: arm64: Use debug_owner to track if debug regs need save/restore
      KVM: arm64: Reload vCPU for accesses to OSLAR_EL1
      KVM: arm64: Compute MDCR_EL2 at vcpu_load()
      KVM: arm64: Don't hijack guest context MDSCR_EL1
      KVM: arm64: nv: Honor MDCR_EL2.TDE routing for debug exceptions
      KVM: arm64: Avoid reading ID_AA64DFR0_EL1 for debug save/restore
      KVM: arm64: Fold DBGxVR/DBGxCR accessors into common set
      KVM: arm64: Promote guest ownership for DBGxVR/DBGxCR reads

Quentin Perret (21):
      KVM: arm64: Always check the state from hyp_ack_unshare()
      KVM: arm64: Change the layout of enum pkvm_page_state
      KVM: arm64: Move enum pkvm_page_state to memory.h
      KVM: arm64: Make hyp_page::order a u8
      KVM: arm64: Move host page ownership tracking to the hyp vmemmap
      KVM: arm64: Pass walk flags to kvm_pgtable_stage2_mkyoung
      KVM: arm64: Pass walk flags to kvm_pgtable_stage2_relax_perms
      KVM: arm64: Make kvm_pgtable_stage2_init() a static inline function
      KVM: arm64: Add {get,put}_pkvm_hyp_vm() helpers
      KVM: arm64: Introduce __pkvm_host_share_guest()
      KVM: arm64: Introduce __pkvm_host_unshare_guest()
      KVM: arm64: Introduce __pkvm_host_relax_guest_perms()
      KVM: arm64: Introduce __pkvm_host_wrprotect_guest()
      KVM: arm64: Introduce __pkvm_host_test_clear_young_guest()
      KVM: arm64: Introduce __pkvm_host_mkyoung_guest()
      KVM: arm64: Introduce __pkvm_tlb_flush_vmid()
      KVM: arm64: Introduce the EL1 pKVM MMU
      KVM: arm64: Plumb the pKVM MMU in KVM
      KVM: arm64: Drop pkvm_mem_transition for FF-A
      KVM: arm64: Drop pkvm_mem_transition for host/hyp sharing
      KVM: arm64: Drop pkvm_mem_transition for host/hyp donations

Thorsten Blum (1):
      KVM: arm64: vgic: Use str_enabled_disabled() in vgic_v3_probe()

Vincent Donnefort (1):
      KVM: arm64: Fix nVHE stacktrace VA bits mask

Vladimir Murzin (1):
      KVM: arm64: Fix FEAT_MTE in pKVM

 Documentation/admin-guide/kernel-parameters.txt    |  16 +-
 Documentation/virt/kvm/devices/vcpu.rst            |  14 +-
 arch/arm64/include/asm/cpucaps.h                   |   2 +
 arch/arm64/include/asm/cpufeature.h                |   3 +-
 arch/arm64/include/asm/cputype.h                   |   2 +
 arch/arm64/include/asm/el2_setup.h                 |   6 +-
 arch/arm64/include/asm/kvm_arm.h                   |   4 +-
 arch/arm64/include/asm/kvm_asm.h                   |  14 +-
 arch/arm64/include/asm/kvm_emulate.h               | 105 ++-
 arch/arm64/include/asm/kvm_host.h                  | 136 ++--
 arch/arm64/include/asm/kvm_mmu.h                   |  18 +
 arch/arm64/include/asm/kvm_nested.h                |  11 +-
 arch/arm64/include/asm/kvm_pgtable.h               |  38 +-
 arch/arm64/include/asm/kvm_pkvm.h                  |  51 ++
 arch/arm64/include/asm/memory.h                    |   5 +-
 arch/arm64/include/asm/stacktrace/nvhe.h           |   2 +-
 arch/arm64/include/asm/sysreg.h                    |  16 +-
 arch/arm64/kernel/cpu_errata.c                     |   8 +
 arch/arm64/kernel/cpufeature.c                     |  17 +-
 arch/arm64/kernel/image-vars.h                     |   3 +
 arch/arm64/kvm/arch_timer.c                        | 179 ++++-
 arch/arm64/kvm/arm.c                               |  86 +-
 arch/arm64/kvm/at.c                                |   6 +-
 arch/arm64/kvm/debug.c                             | 416 ++++------
 arch/arm64/kvm/emulate-nested.c                    |  83 +-
 arch/arm64/kvm/fpsimd.c                            |  14 +-
 arch/arm64/kvm/guest.c                             |  31 +-
 arch/arm64/kvm/handle_exit.c                       |   5 +-
 arch/arm64/kvm/hyp/include/hyp/debug-sr.h          |  42 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h            |  43 +-
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h         |  43 +-
 arch/arm64/kvm/hyp/include/nvhe/fixed_config.h     | 223 ------
 arch/arm64/kvm/hyp/include/nvhe/gfp.h              |   6 +-
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h      |  39 +-
 arch/arm64/kvm/hyp/include/nvhe/memory.h           |  50 +-
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h             |  23 +
 arch/arm64/kvm/hyp/nvhe/debug-sr.c                 |  72 +-
 arch/arm64/kvm/hyp/nvhe/host.S                     |   4 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c                 | 213 ++++-
 arch/arm64/kvm/hyp/nvhe/mem_protect.c              | 887 ++++++++-------------
 arch/arm64/kvm/hyp/nvhe/mm.c                       |  12 +-
 arch/arm64/kvm/hyp/nvhe/page_alloc.c               |  14 +-
 arch/arm64/kvm/hyp/nvhe/pkvm.c                     | 410 +++++-----
 arch/arm64/kvm/hyp/nvhe/setup.c                    |   8 +-
 arch/arm64/kvm/hyp/nvhe/stacktrace.c               |   4 +-
 arch/arm64/kvm/hyp/nvhe/switch.c                   |  54 +-
 arch/arm64/kvm/hyp/nvhe/sys_regs.c                 | 404 ++++++----
 arch/arm64/kvm/hyp/nvhe/timer-sr.c                 |  16 +-
 arch/arm64/kvm/hyp/pgtable.c                       |  13 +-
 arch/arm64/kvm/hyp/vhe/debug-sr.c                  |   5 -
 arch/arm64/kvm/hyp/vhe/switch.c                    | 123 ++-
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c                 |   4 +-
 arch/arm64/kvm/mmu.c                               | 108 ++-
 arch/arm64/kvm/nested.c                            |  38 +-
 arch/arm64/kvm/pkvm.c                              | 201 +++++
 arch/arm64/kvm/pmu-emul.c                          |  89 +--
 arch/arm64/kvm/reset.c                             |   6 +-
 arch/arm64/kvm/stacktrace.c                        |   9 +-
 arch/arm64/kvm/sys_regs.c                          | 443 +++++-----
 arch/arm64/kvm/trace_handle_exit.h                 |  75 --
 arch/arm64/kvm/vgic/vgic-v3.c                      |  11 +-
 arch/arm64/mm/proc.S                               |   5 +-
 arch/arm64/tools/cpucaps                           |   1 +
 arch/arm64/tools/gen-sysreg.awk                    |   2 +-
 arch/arm64/tools/sysreg                            |  76 +-
 drivers/hwtracing/coresight/coresight-etm4x-core.c |  55 +-
 .../hwtracing/coresight/coresight-etm4x-sysfs.c    |  10 +-
 drivers/hwtracing/coresight/coresight-etm4x.h      |   2 +-
 drivers/hwtracing/coresight/coresight-priv.h       |   3 +
 .../coresight/coresight-self-hosted-trace.h        |   9 -
 drivers/hwtracing/coresight/coresight-trbe.c       |  15 +-
 include/clocksource/arm_arch_timer.h               |   6 +
 include/kvm/arm_arch_timer.h                       |  23 +
 include/kvm/arm_pmu.h                              |   6 +-
 tools/arch/arm64/include/asm/sysreg.h              | 410 +++++++++-
 tools/include/linux/kasan-tags.h                   |  15 +
 .../selftests/kvm/aarch64/aarch32_id_regs.c        |   2 +-
 tools/testing/selftests/kvm/aarch64/set_id_regs.c  |   3 +-
 78 files changed, 3256 insertions(+), 2370 deletions(-)
 delete mode 100644 arch/arm64/kvm/hyp/include/nvhe/fixed_config.h
 create mode 100644 tools/include/linux/kasan-tags.h

