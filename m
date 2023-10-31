Return-Path: <kvm+bounces-243-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BC107DD64D
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 19:48:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C78821C20CE2
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 18:48:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE79822306;
	Tue, 31 Oct 2023 18:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xEhJ4no/"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42513208B2
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 18:48:32 +0000 (UTC)
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [IPv6:2001:41d0:203:375::b2])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E66D1A6
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 11:48:29 -0700 (PDT)
Date: Tue, 31 Oct 2023 11:48:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1698778107;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=F52dpzxQTPPk/FaCOWtBXUXkQp0gcrrYXYChduY6NvI=;
	b=xEhJ4no/xpHh1E7x2rGc8KVPqJqNHC6p7lvG5dtQyHFojFjOa9ZofLU38I7re2nFTkvtmI
	Y8ISoiSYMTcQQIv+Z3hLLxKtJxVW644xrIuc8mooSVaOgbhGWUYQb+Z4Ew2r0LuLJO+xZG
	ndXNu4y5qGLPrK7ggHCBM1EBztK4Yvg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Jing Zhang <jingzhangos@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Kristina Martsenko <kristina.martsenko@arm.com>,
	Miguel Luis <miguel.luis@oracle.com>
Subject: [GIT PULL] KVM/arm64 updates for 6.7
Message-ID: <ZUFL9AUV36xHGaBE@thinky-boi>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Migadu-Flow: FLOW_OUT

Hi Paolo,

Here's the pile of KVM/arm64 changes for 6.7.

Almost all of these changes have been baking in -next for a while, although
I did need to rebase to back out a broken change last minute.

I'm only aware of a single (trivial) conflict with the arm64 tree resulting
from a moved cpucap check, resolution below.

Please pull.

-- 
Thanks,
Oliver

The following changes since commit 6465e260f48790807eef06b583b38ca9789b6072:

  Linux 6.6-rc3 (2023-09-24 14:31:13 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-6.7

for you to fetch changes up to 123f42f0ad6815014f54d0cc6eb9039c46ee2907:

  Merge branch kvm-arm64/pmu_pmcr_n into kvmarm/next (2023-10-30 20:24:19 +0000)

----------------------------------------------------------------
KVM/arm64 updates for 6.7

 - Generalized infrastructure for 'writable' ID registers, effectively
   allowing userspace to opt-out of certain vCPU features for its guest

 - Optimization for vSGI injection, opportunistically compressing MPIDR
   to vCPU mapping into a table

 - Improvements to KVM's PMU emulation, allowing userspace to select
   the number of PMCs available to a VM

 - Guest support for memory operation instructions (FEAT_MOPS)

 - Cleanups to handling feature flags in KVM_ARM_VCPU_INIT, squashing
   bugs and getting rid of useless code

 - Changes to the way the SMCCC filter is constructed, avoiding wasted
   memory allocations when not in use

 - Load the stage-2 MMU context at vcpu_load() for VHE systems, reducing
   the overhead of errata mitigations

 - Miscellaneous kernel and selftest fixes

----------------------------------------------------------------
Jing Zhang (7):
      KVM: arm64: Allow userspace to get the writable masks for feature ID registers
      KVM: arm64: Document KVM_ARM_GET_REG_WRITABLE_MASKS
      KVM: arm64: Use guest ID register values for the sake of emulation
      KVM: arm64: Allow userspace to change ID_AA64MMFR{0-2}_EL1
      KVM: arm64: Allow userspace to change ID_AA64PFR0_EL1
      tools headers arm64: Update sysreg.h with kernel sources
      KVM: arm64: selftests: Test for setting ID register from usersapce

Kristina Martsenko (2):
      KVM: arm64: Add handler for MOPS exceptions
      KVM: arm64: Expose MOPS instructions to guests

Marc Zyngier (16):
      KVM: arm64: vgic: Make kvm_vgic_inject_irq() take a vcpu pointer
      KVM: arm64: vgic-its: Treat the collection target address as a vcpu_id
      KVM: arm64: vgic-v3: Refactor GICv3 SGI generation
      KVM: arm64: vgic-v2: Use cpuid from userspace as vcpu_id
      KVM: arm64: vgic: Use vcpu_idx for the debug information
      KVM: arm64: Use vcpu_idx for invalidation tracking
      KVM: arm64: Simplify kvm_vcpu_get_mpidr_aff()
      KVM: arm64: Build MPIDR to vcpu index cache at runtime
      KVM: arm64: Fast-track kvm_mpidr_to_vcpu() when mpidr_data is available
      KVM: arm64: vgic-v3: Optimize affinity-based SGI injection
      KVM: arm64: Clarify the ordering requirements for vcpu/RD creation
      KVM: arm64: Restore the stage-2 context in VHE's __tlb_switch_to_host()
      KVM: arm64: Reload stage-2 for VMID change on VHE
      KVM: arm64: Move VTCR_EL2 into struct s2_mmu
      KVM: arm64: Do not let a L1 hypervisor access the *32_EL2 sysregs
      KVM: arm64: Handle AArch32 SPSR_{irq,abt,und,fiq} as RAZ/WI

Miguel Luis (3):
      arm64: Add missing _EL12 encodings
      arm64: Add missing _EL2 encodings
      KVM: arm64: Refine _EL2 system register list that require trap reinjection

Oliver Upton (42):
      KVM: arm64: Don't use kerneldoc comment for arm64_check_features()
      KVM: arm64: Add generic check for system-supported vCPU features
      KVM: arm64: Hoist PMUv3 check into KVM_ARM_VCPU_INIT ioctl handler
      KVM: arm64: Hoist SVE check into KVM_ARM_VCPU_INIT ioctl handler
      KVM: arm64: Hoist PAuth checks into KVM_ARM_VCPU_INIT ioctl
      KVM: arm64: Prevent NV feature flag on systems w/o nested virt
      KVM: arm64: Hoist NV+SVE check into KVM_ARM_VCPU_INIT ioctl handler
      KVM: arm64: Remove unused return value from kvm_reset_vcpu()
      KVM: arm64: Get rid of vCPU-scoped feature bitmap
      arm64: tlbflush: Rename MAX_TLBI_OPS
      KVM: arm64: Avoid soft lockups due to I-cache maintenance
      KVM: arm64: Advertise selected DebugVer in DBGDIDR.Version
      KVM: arm64: Reject attempts to set invalid debug arch version
      KVM: arm64: Bump up the default KVM sanitised debug version to v8p8
      KVM: arm64: Allow userspace to change ID_AA64ISAR{0-2}_EL1
      KVM: arm64: Allow userspace to change ID_AA64ZFR0_EL1
      KVM: arm64: Document vCPU feature selection UAPIs
      KVM: arm64: Add a predicate for testing if SMCCC filter is configured
      KVM: arm64: Only insert reserved ranges when SMCCC filter is used
      KVM: arm64: Use mtree_empty() to determine if SMCCC filter configured
      tools: arm64: Add a Makefile for generating sysreg-defs.h
      perf build: Generate arm64's sysreg-defs.h and add to include path
      KVM: selftests: Generate sysreg-defs.h and add to include path
      KVM: arm64: Don't zero VTTBR in __tlb_switch_to_host()
      KVM: arm64: Rename helpers for VHE vCPU load/put
      KVM: arm64: Load the stage-2 MMU context in kvm_vcpu_load_vhe()
      KVM: arm64: Make PMEVTYPER<n>_EL0.NSH RES0 if EL2 isn't advertised
      KVM: arm64: Add PMU event filter bits required if EL3 is implemented
      KVM: arm64: Always invalidate TLB for stage-2 permission faults
      KVM: arm64: Add tracepoint for MMIO accesses where ISV==0
      Merge branch kvm-arm64/misc into kvmarm/next
      Merge branch kvm-arm64/feature-flag-refactor into kvmarm/next
      Merge branch kvm-arm64/pmevtyper-filter into kvmarm/next
      Merge branch kvm-arm64/smccc-filter-cleanups into kvmarm/next
      Merge branch kvm-arm64/nv-trap-fixes into kvmarm/next
      Merge branch kvm-arm64/stage2-vhe-load into kvmarm/next
      Merge branch kvm-arm64/sgi-injection into kvmarm/next
      tools headers arm64: Fix references to top srcdir in Makefile
      KVM: selftests: Avoid using forced target for generating arm64 headers
      Merge branch kvm-arm64/writable-id-regs into kvmarm/next
      Merge branch kvm-arm64/mops into kvmarm/next
      Merge branch kvm-arm64/pmu_pmcr_n into kvmarm/next

Raghavendra Rao Ananta (5):
      KVM: arm64: PMU: Set PMCR_EL0.N for vCPU based on the associated PMU
      KVM: arm64: Add {get,set}_user for PM{C,I}NTEN{SET,CLR}, PMOVS{SET,CLR}
      KVM: arm64: Sanitize PM{C,I}NTEN{SET,CLR}, PMOVS{SET,CLR} before first run
      tools: Import arm_pmuv3.h
      KVM: selftests: aarch64: vPMU test for validating user accesses

Reiji Watanabe (7):
      KVM: arm64: PMU: Introduce helpers to set the guest's PMU
      KVM: arm64: Select default PMU in KVM_ARM_VCPU_INIT handler
      KVM: arm64: PMU: Add a helper to read a vCPU's PMCR_EL0
      KVM: arm64: PMU: Allow userspace to limit PMCR_EL0.N for the guest
      KVM: selftests: aarch64: Introduce vpmu_counter_access test
      KVM: selftests: aarch64: vPMU register test for implemented counters
      KVM: selftests: aarch64: vPMU register test for unimplemented counters

Vincent Donnefort (1):
      KVM: arm64: Do not transfer page refcount for THP adjustment

Zenghui Yu (2):
      KVM: arm64: selftest: Add the missing .guest_prepare()
      KVM: arm64: selftest: Perform ISB before reading PAR_EL1

 Documentation/virt/kvm/api.rst                     |  52 ++
 Documentation/virt/kvm/arm/index.rst               |   1 +
 Documentation/virt/kvm/arm/vcpu-features.rst       |  48 ++
 Documentation/virt/kvm/devices/arm-vgic-v3.rst     |   7 +
 arch/arm64/include/asm/kvm_arm.h                   |   4 +-
 arch/arm64/include/asm/kvm_emulate.h               |  15 +-
 arch/arm64/include/asm/kvm_host.h                  |  61 +-
 arch/arm64/include/asm/kvm_hyp.h                   |   7 +-
 arch/arm64/include/asm/kvm_mmu.h                   |  45 +-
 arch/arm64/include/asm/kvm_nested.h                |   3 +-
 arch/arm64/include/asm/stage2_pgtable.h            |   4 +-
 arch/arm64/include/asm/sysreg.h                    |  45 ++
 arch/arm64/include/asm/tlbflush.h                  |   8 +-
 arch/arm64/include/asm/traps.h                     |  54 +-
 arch/arm64/include/uapi/asm/kvm.h                  |  32 +
 arch/arm64/kernel/traps.c                          |  48 +-
 arch/arm64/kvm/arch_timer.c                        |   6 +-
 arch/arm64/kvm/arm.c                               | 196 ++++-
 arch/arm64/kvm/emulate-nested.c                    |  77 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h            |  17 +
 arch/arm64/kvm/hyp/include/nvhe/fixed_config.h     |   3 +-
 arch/arm64/kvm/hyp/nvhe/mem_protect.c              |   8 +-
 arch/arm64/kvm/hyp/nvhe/pkvm.c                     |   4 +-
 arch/arm64/kvm/hyp/nvhe/switch.c                   |   2 +
 arch/arm64/kvm/hyp/pgtable.c                       |   4 +-
 arch/arm64/kvm/hyp/vhe/switch.c                    |  34 +-
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c                 |  11 +-
 arch/arm64/kvm/hyp/vhe/tlb.c                       |  18 +-
 arch/arm64/kvm/hypercalls.c                        |  36 +-
 arch/arm64/kvm/mmio.c                              |   4 +-
 arch/arm64/kvm/mmu.c                               |  33 +-
 arch/arm64/kvm/pkvm.c                              |   2 +-
 arch/arm64/kvm/pmu-emul.c                          | 145 +++-
 arch/arm64/kvm/reset.c                             |  56 +-
 arch/arm64/kvm/sys_regs.c                          | 355 +++++++--
 arch/arm64/kvm/trace_arm.h                         |  25 +
 arch/arm64/kvm/vgic/vgic-debug.c                   |   6 +-
 arch/arm64/kvm/vgic/vgic-irqfd.c                   |   2 +-
 arch/arm64/kvm/vgic/vgic-its.c                     |  49 +-
 arch/arm64/kvm/vgic/vgic-kvm-device.c              |  11 +-
 arch/arm64/kvm/vgic/vgic-mmio-v3.c                 | 150 ++--
 arch/arm64/kvm/vgic/vgic.c                         |  12 +-
 arch/arm64/kvm/vmid.c                              |  11 +-
 include/kvm/arm_arch_timer.h                       |   2 +-
 include/kvm/arm_pmu.h                              |  28 +-
 include/kvm/arm_psci.h                             |   2 +-
 include/kvm/arm_vgic.h                             |   4 +-
 include/linux/perf/arm_pmuv3.h                     |   9 +-
 include/uapi/linux/kvm.h                           |   2 +
 tools/arch/arm64/include/.gitignore                |   1 +
 tools/arch/arm64/include/asm/gpr-num.h             |  26 +
 tools/arch/arm64/include/asm/sysreg.h              | 839 +++++----------------
 tools/arch/arm64/tools/Makefile                    |  38 +
 tools/include/perf/arm_pmuv3.h                     | 308 ++++++++
 tools/perf/Makefile.perf                           |  15 +-
 tools/perf/util/Build                              |   2 +-
 tools/testing/selftests/kvm/Makefile               |  24 +-
 .../selftests/kvm/aarch64/aarch32_id_regs.c        |   4 +-
 .../selftests/kvm/aarch64/debug-exceptions.c       |  12 +-
 .../selftests/kvm/aarch64/page_fault_test.c        |  11 +-
 tools/testing/selftests/kvm/aarch64/set_id_regs.c  | 481 ++++++++++++
 .../selftests/kvm/aarch64/vpmu_counter_access.c    | 670 ++++++++++++++++
 .../selftests/kvm/include/aarch64/processor.h      |   1 +
 .../testing/selftests/kvm/lib/aarch64/processor.c  |   6 +-
 64 files changed, 3019 insertions(+), 1177 deletions(-)
 create mode 100644 Documentation/virt/kvm/arm/vcpu-features.rst
 create mode 100644 tools/arch/arm64/include/.gitignore
 create mode 100644 tools/arch/arm64/include/asm/gpr-num.h
 create mode 100644 tools/arch/arm64/tools/Makefile
 create mode 100644 tools/include/perf/arm_pmuv3.h
 create mode 100644 tools/testing/selftests/kvm/aarch64/set_id_regs.c
 create mode 100644 tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c

-- 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 49ce32d3d6f7..e5f75f1f1085 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1298,12 +1298,6 @@ static int kvm_vcpu_init_check_features(struct kvm_vcpu *vcpu,
 	if (!test_bit(KVM_ARM_VCPU_EL1_32BIT, &features))
 		return 0;
 
-<<<<<<< HEAD
-=======
-	if (!cpus_have_final_cap(ARM64_HAS_32BIT_EL1))
-		return -EINVAL;
-
->>>>>>> arm64-upstream
 	/* MTE is incompatible with AArch32 */
 	if (kvm_has_mte(vcpu->kvm))
 		return -EINVAL;

