Return-Path: <kvm+bounces-21625-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CF282930E60
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2024 08:57:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5F3C31F21651
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2024 06:57:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D44C11836DE;
	Mon, 15 Jul 2024 06:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="VvXVNYYa"
X-Original-To: kvm@vger.kernel.org
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 534721836CF
	for <kvm@vger.kernel.org>; Mon, 15 Jul 2024 06:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721026669; cv=none; b=svBxsABpUdmGYDLhWrajg0yF+lpQEoLleNo1TmPxgqG0fXn3BZE1zsHiFOyJ/CIlGyTUSSvQ92cM/Fc81N0L0aLvTUuR7A/e5cz1UkD38g4JMnUp5pozrXEcp6l58dU6SGCCOai/7GdSFtViUC9NJ20rAH+utweOUGayAMzqm70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721026669; c=relaxed/simple;
	bh=qyqKKupY9E0y841tj2VpyAitxQfjQX8p7N6ZTPi2nfA=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=YQB5k4S/HzSpqwGUVk/UhyEBM2QyTIVsR53lctsYKGBnn7mCWOmctAcBgNBW8w1RSfRHaUgMKfyDFFWU60MhfDC9eaq92zoXxcCZnDlfjUgHn3Prs31c9NoB5CBHjA5oZDm4TOwfpKLXbchnL/fBp5p7UMQXWOiMJUQNS0hA/tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=VvXVNYYa; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: pbonzini@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1721026664;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=0PtvZMxfAKvLK0Mt+7cMdpr/W/nx3zmCRU8SuscmP3Q=;
	b=VvXVNYYal8ZcAyemIgJOD6SceR91tOfTgfXkHu4LdKJSJwoEQCFFSlvgOBWDDRN0Nnl9Uo
	SrLG8FvbPgfqxkNAFkzj9UJLybkz+4Dxq2ssGakH6K1Z4puPGIbFgSqQAWhc7uRQgPfwqa
	xigT5aCPRlbfieVUvYdNqM53+aBERjM=
X-Envelope-To: maz@kernel.org
X-Envelope-To: ptosi@google.com
X-Envelope-To: sebott@redhat.com
X-Envelope-To: sebastianene@google.com
X-Envelope-To: changyuanl@google.com
X-Envelope-To: coltonlewis@google.com
X-Envelope-To: jintack.lim@linaro.org
X-Envelope-To: kvm@vger.kernel.org
X-Envelope-To: kvmarm@lists.linux.dev
X-Envelope-To: james.morse@arm.com
X-Envelope-To: suzuki.poulose@arm.com
X-Envelope-To: yuzenghui@huawei.com
Date: Sun, 14 Jul 2024 23:57:36 -0700
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>,
	=?iso-8859-1?Q?Pierre-Cl=E9ment?= Tosi <ptosi@google.com>,
	Sebastian Ott <sebott@redhat.com>,
	Sebastian Ene <sebastianene@google.com>,
	Changyuan Lyu <changyuanl@google.com>,
	Colton Lewis <coltonlewis@google.com>,
	Jintack Lim <jintack.lim@linaro.org>, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [GIT PULL] KVM/arm64 updates for 6.11
Message-ID: <ZpTIYCFIgvKogfE4@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Hi Paolo,

Apologies for sending this later than usual, I took some vacation at the
end of last week and didn't have the time to send out before.

Details can be found in the tag. Nothing significant to note, though
Catalin reports a trivial conflict in arch/arm64/include/asm/esr.h
between our trees [*].

Please pull.

Thanks,
Oliver

[*] https://lore.kernel.org/linux-arm-kernel/20240711190353.3248426-1-catalin.marinas@arm.com/

The following changes since commit 83a7eefedc9b56fe7bfeff13b6c7356688ffa670:

  Linux 6.10-rc3 (2024-06-09 14:19:43 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-6.11

for you to fetch changes up to bb032b2352c33be374136889789103d724f1b613:

  Merge branch kvm-arm64/docs into kvmarm/next (2024-07-14 00:28:57 +0000)

----------------------------------------------------------------
KVM/arm64 changes for 6.11

 - Initial infrastructure for shadow stage-2 MMUs, as part of nested
   virtualization enablement

 - Support for userspace changes to the guest CTR_EL0 value, enabling
   (in part) migration of VMs between heterogenous hardware

 - Fixes + improvements to pKVM's FF-A proxy, adding support for v1.1 of
   the protocol

 - FPSIMD/SVE support for nested, including merged trap configuration
   and exception routing

 - New command-line parameter to control the WFx trap behavior under KVM

 - Introduce kCFI hardening in the EL2 hypervisor

 - Fixes + cleanups for handling presence/absence of FEAT_TCRX

 - Miscellaneous fixes + documentation updates

----------------------------------------------------------------
Changyuan Lyu (3):
      KVM: Documentation: Fix typo `BFD`
      KVM: Documentation: Enumerate allowed value macros of `irq_type`
      KVM: Documentation: Correct the VGIC V2 CPU interface addr space size

Christoffer Dall (2):
      KVM: arm64: nv: Implement nested Stage-2 page table walk logic
      KVM: arm64: nv: Unmap/flush shadow stage 2 page tables

Colton Lewis (1):
      KVM: arm64: Add early_param to control WFx trapping

Jintack Lim (1):
      KVM: arm64: nv: Forward FP/ASIMD traps to guest hypervisor

Marc Zyngier (25):
      KVM: arm64: nv: Fix RESx behaviour of disabled FGTs with negative polarity
      KVM: arm64: nv: Support multiple nested Stage-2 mmu structures
      KVM: arm64: nv: Handle shadow stage 2 page faults
      KVM: arm64: nv: Add Stage-1 EL2 invalidation primitives
      KVM: arm64: nv: Handle EL2 Stage-1 TLB invalidation
      KVM: arm64: nv: Handle TLB invalidation targeting L2 stage-1
      KVM: arm64: nv: Handle TLBI VMALLS12E1{,IS} operations
      KVM: arm64: nv: Handle TLBI ALLE1{,IS} operations
      KVM: arm64: nv: Handle TLBI IPAS2E1{,IS} operations
      KVM: arm64: nv: Handle FEAT_TTL hinted TLB operations
      KVM: arm64: nv: Tag shadow S2 entries with guest's leaf S2 level
      KVM: arm64: nv: Invalidate TLBs based on shadow S2 TTL-like information
      KVM: arm64: nv: Add handling of outer-shareable TLBI operations
      KVM: arm64: nv: Add handling of range-based TLBI operations
      KVM: arm64: nv: Add handling of NXS-flavoured TLBI operations
      KVM: arm64: nv: Handle CPACR_EL1 traps
      KVM: arm64: nv: Add TCPAC/TTA to CPTR->CPACR conversion helper
      KVM: arm64: nv: Add trap description for CPTR_EL2
      KVM: arm64: nv: Add additional trap setup for CPTR_EL2
      KVM: arm64: Correctly honor the presence of FEAT_TCRX
      KVM: arm64: Get rid of HCRX_GUEST_FLAGS
      KVM: arm64: Make TCR2_EL1 save/restore dependent on the VM features
      KVM: arm64: Make PIR{,E0}_EL1 save/restore conditional on FEAT_TCRX
      KVM: arm64: Honor trap routing for TCR2_EL1
      KVM: arm64: nv: Truely enable nXS TLBI operations

Oliver Upton (28):
      KVM: arm64: nv: Use GFP_KERNEL_ACCOUNT for sysreg_masks allocation
      KVM: arm64: Get sys_reg encoding from descriptor in idregs_debug_show()
      KVM: arm64: Make idregs debugfs iterator search sysreg table directly
      KVM: arm64: Use read-only helper for reading VM ID registers
      KVM: arm64: Add helper for writing ID regs
      KVM: arm64: nv: Use accessors for modifying ID registers
      KVM: arm64: nv: Forward SVE traps to guest hypervisor
      KVM: arm64: nv: Handle ZCR_EL2 traps
      KVM: arm64: nv: Load guest hyp's ZCR into EL1 state
      KVM: arm64: nv: Save guest's ZCR_EL2 when in hyp context
      KVM: arm64: nv: Use guest hypervisor's max VL when running nested guest
      KVM: arm64: nv: Ensure correct VL is loaded before saving SVE state
      KVM: arm64: Spin off helper for programming CPTR traps
      KVM: arm64: nv: Load guest FP state for ZCR_EL2 trap
      KVM: arm64: nv: Honor guest hypervisor's FP/SVE traps in CPTR_EL2
      KVM: arm64: Allow the use of SVE+NV
      KVM: arm64: nv: Unfudge ID_AA64PFR0_EL1 masking
      KVM: selftests: Assert that MPIDR_EL1 is unchanged across vCPU reset
      MAINTAINERS: Include documentation in KVM/arm64 entry
      Revert "KVM: arm64: nv: Fix RESx behaviour of disabled FGTs with negative polarity"
      Merge branch kvm-arm64/misc into kvmarm/next
      Merge branch kvm-arm64/ffa-1p1 into kvmarm/next
      Merge branch kvm-arm64/shadow-mmu into kvmarm/next
      Merge branch kvm-arm64/ctr-el0 into kvmarm/next
      Merge branch kvm-arm64/el2-kcfi into kvmarm/next
      Merge branch kvm-arm64/nv-sve into kvmarm/next
      Merge branch kvm-arm64/nv-tcr2 into kvmarm/next
      Merge branch kvm-arm64/docs into kvmarm/next

Pierre-Clément Tosi (8):
      KVM: arm64: Fix clobbered ELR in sync abort/SError
      KVM: arm64: Fix __pkvm_init_switch_pgd call ABI
      KVM: arm64: nVHE: Simplify invalid_host_el2_vect
      KVM: arm64: nVHE: gen-hyprel: Skip R_AARCH64_ABS32
      KVM: arm64: VHE: Mark __hyp_call_panic __noreturn
      arm64: Introduce esr_brk_comment, esr_is_cfi_brk
      KVM: arm64: Introduce print_nvhe_hyp_panic helper
      KVM: arm64: nVHE: Support CONFIG_CFI_CLANG at EL2

Sebastian Ene (4):
      KVM: arm64: Trap FFA_VERSION host call in pKVM
      KVM: arm64: Add support for FFA_PARTITION_INFO_GET
      KVM: arm64: Update the identification range for the FF-A smcs
      KVM: arm64: Use FF-A 1.1 with pKVM

Sebastian Ott (5):
      KVM: arm64: unify code to prepare traps
      KVM: arm64: Treat CTR_EL0 as a VM feature ID register
      KVM: arm64: show writable masks for feature registers
      KVM: arm64: rename functions for invariant sys regs
      KVM: selftests: arm64: Test writes to CTR_EL0

 Documentation/admin-guide/kernel-parameters.txt   |   18 +
 Documentation/virt/kvm/api.rst                    |   10 +-
 Documentation/virt/kvm/devices/arm-vgic.rst       |    2 +-
 MAINTAINERS                                       |    2 +
 arch/arm64/include/asm/esr.h                      |   12 +
 arch/arm64/include/asm/kvm_arm.h                  |    1 -
 arch/arm64/include/asm/kvm_asm.h                  |    2 +
 arch/arm64/include/asm/kvm_emulate.h              |   95 +-
 arch/arm64/include/asm/kvm_host.h                 |   68 +-
 arch/arm64/include/asm/kvm_hyp.h                  |    4 +-
 arch/arm64/include/asm/kvm_mmu.h                  |   26 +
 arch/arm64/include/asm/kvm_nested.h               |  131 ++-
 arch/arm64/include/asm/sysreg.h                   |   17 +
 arch/arm64/kernel/asm-offsets.c                   |    1 +
 arch/arm64/kernel/debug-monitors.c                |    4 +-
 arch/arm64/kernel/traps.c                         |    8 +-
 arch/arm64/kvm/arm.c                              |   86 +-
 arch/arm64/kvm/emulate-nested.c                   |  104 +++
 arch/arm64/kvm/fpsimd.c                           |   19 +-
 arch/arm64/kvm/handle_exit.c                      |   43 +-
 arch/arm64/kvm/hyp/entry.S                        |    8 +
 arch/arm64/kvm/hyp/include/hyp/switch.h           |   29 +-
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h        |   35 +-
 arch/arm64/kvm/hyp/include/nvhe/ffa.h             |    2 +-
 arch/arm64/kvm/hyp/nvhe/Makefile                  |    6 +-
 arch/arm64/kvm/hyp/nvhe/ffa.c                     |  180 +++-
 arch/arm64/kvm/hyp/nvhe/gen-hyprel.c              |    6 +
 arch/arm64/kvm/hyp/nvhe/host.S                    |    6 -
 arch/arm64/kvm/hyp/nvhe/hyp-init.S                |   30 +-
 arch/arm64/kvm/hyp/nvhe/setup.c                   |    4 +-
 arch/arm64/kvm/hyp/vhe/switch.c                   |  202 ++++-
 arch/arm64/kvm/hyp/vhe/tlb.c                      |  147 +++
 arch/arm64/kvm/mmu.c                              |  213 ++++-
 arch/arm64/kvm/nested.c                           | 1002 ++++++++++++++++++---
 arch/arm64/kvm/pmu-emul.c                         |    2 +-
 arch/arm64/kvm/reset.c                            |    6 +
 arch/arm64/kvm/sys_regs.c                         |  593 +++++++++++-
 include/linux/arm_ffa.h                           |    3 +
 tools/testing/selftests/kvm/aarch64/set_id_regs.c |   17 +
 39 files changed, 2764 insertions(+), 380 deletions(-)

