Return-Path: <kvm+bounces-47576-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 341F2AC21F1
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 13:22:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AF67C7BA182
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 11:19:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06FE222D79F;
	Fri, 23 May 2025 11:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dZyIm82a"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A0CF22A7EF;
	Fri, 23 May 2025 11:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747999222; cv=none; b=Wqp3bqRv68XmvFkilmdnkwGAGsTg12KgCzRc5IeBOHf2ADUlAeY6swTM1vkdTaCvcAePhPInk6M4wFg1frSXxO+CNXj2mhM6+IY1rt1B0OJQ41gGqnE7oxtsOrwHccWOVWF4OVO3HWEOVGvjYQeFvfqjvAXVN2RwTBX0GQVyuS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747999222; c=relaxed/simple;
	bh=RcGgqAaZk/0SBkr2MlLXSc+3IGGjsNtTpWGSzez2kbo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=pbpzoAhgSYj/VT2C8DjLc8aWGfx/AsQHkUiW0ARVYHGY9ICjHFidtHAkxlBiNuialU53sNWUSznHdUR4Y2qmgG9BTektLosJVwFZZ5DDamKFuMkl+aMbsHCP/dN8WYRCXRRlOQGe6Jsj10bGniZNomib88Gli0u5pn8efY0lx5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dZyIm82a; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2038FC4CEE9;
	Fri, 23 May 2025 11:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747999221;
	bh=RcGgqAaZk/0SBkr2MlLXSc+3IGGjsNtTpWGSzez2kbo=;
	h=From:To:Cc:Subject:Date:From;
	b=dZyIm82aQXDdo6EOb1ugTEhsZkUun0NAW086/fsm2q9OmMrxKp/+LL9IY1XH/s4CB
	 zKjXnaCiQiABlLFARP4oMEcx/pWKTxBvrT+nDmaukavRfr++Z7nirpNFrDdfWwFTvv
	 7RtWjSuEmihODGp5nQrVykpIs9KKM5jVbzZ0Q3kezzDSiBqXUVo71lzaXDz4vrF6tr
	 8g+MEyKsLI82W6ITWKOr7R8mkEX4Hy/NMydpXtmpV8RsQJFyHTO/tt/JvbxDz/KShA
	 hu9Pg4nICQbleEJYHQ405CbmaiIuMbHizzWx2pnRIKV7JV7qhOS7Utue6VdMQ9Iuu7
	 l+b6+6dsudWDA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1uIQRm-00HYuf-P2;
	Fri, 23 May 2025 12:20:18 +0100
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Ben Horgan <ben.horgan@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	D Scott Phillips <scott@os.amperecomputing.com>,
	Fuad Tabba <tabba@google.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Gavin Shan <gshan@redhat.com>,
	Jing Zhang <jingzhangos@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Kees Cook <kees@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mostafa Saleh <smostafa@google.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Quentin Perret <qperret@google.com>,
	Seongsu Park <sgsu.park@samsung.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Wei-Lin Chang <r09922117@csie.ntu.edu.tw>,
	Will Deacon <will@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: [GIT PULL] KVM/arm64 updates for 6.16
Date: Fri, 23 May 2025 12:20:15 +0100
Message-Id: <20250523112015.146300-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, anshuman.khandual@arm.com, ben.horgan@arm.com, catalin.marinas@arm.com, scott@os.amperecomputing.com, tabba@google.com, gankulkarni@os.amperecomputing.com, gshan@redhat.com, jingzhangos@google.com, joey.gouly@arm.com, kees@kernel.org, broonie@kernel.org, mark.rutland@arm.com, smostafa@google.com, oliver.upton@linux.dev, qperret@google.com, sgsu.park@samsung.com, vdonnefort@google.com, r09922117@csie.ntu.edu.tw, will@kernel.org, yuzenghui@huawei.com, eric.auger@redhat.com, suzuki.poulose@arm.com, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Paolo,

Here's the initial set of updates for 6.16.

The largest change is actually not a functional one, as it "only"
reworks the way the guest feature set applies to trap bits and
register sanitising. This translates into another (generated) set of
large tables describing the architecture, which is I hope easier to
deal with than ad-hoc code trying to do the same thing.

On the functional front, pKVM gains THP and UBSAN support as well as
some page ownership optimisations, we workaround a couple of really
bad issues on the AmpereOne hardware, and we finally switch on nested
virtualisation support.

This last bit has been a long time coming, and I would like to express
my thanks to Christoffer, Jintack, Oliver, Eric and everyone else who
helped me getting this monstrosity across the finishing line. Except
it's never really finished!

As usual, details in the tag below.

Please pull,

	M.

The following changes since commit b4432656b36e5cc1d50a1f2dc15357543add530e:

  Linux 6.15-rc4 (2025-04-27 15:19:23 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-6.16

for you to fetch changes up to 1b85d923ba8c9e6afaf19e26708411adde94fba8:

  Merge branch kvm-arm64/misc-6.16 into kvmarm-master/next (2025-05-23 10:59:43 +0100)

----------------------------------------------------------------
KVM/arm64 updates for 6.16

* New features:

  - Add large stage-2 mapping support for non-protected pKVM guests,
    clawing back some performance.

  - Add UBSAN support to the standalone EL2 object used in nVHE/hVHE and
    protected modes.

  - Enable nested virtualisation support on systems that support it
    (yes, it has been a long time coming), though it is disabled by
    default.

* Improvements, fixes and cleanups:

  - Large rework of the way KVM tracks architecture features and links
    them with the effects of control bits. This ensures correctness of
    emulation (the data is automatically extracted from the published
    JSON files), and helps dealing with the evolution of the
    architecture.

  - Significant changes to the way pKVM tracks ownership of pages,
    avoiding page table walks by storing the state in the hypervisor's
    vmemmap. This in turn enables the THP support described above.

  - New selftest checking the pKVM ownership transition rules

  - Fixes for FEAT_MTE_ASYNC being accidentally advertised to guests
    even if the host didn't have it.

  - Fixes for the address translation emulation, which happened to be
    rather buggy in some specific contexts.

  - Fixes for the PMU emulation in NV contexts, decoupling PMCR_EL0.N
    from the number of counters exposed to a guest and addressing a
    number of issues in the process.

  - Add a new selftest for the SVE host state being corrupted by a
    guest.

  - Keep HCR_EL2.xMO set at all times for systems running with the
    kernel at EL2, ensuring that the window for interrupts is slightly
    bigger, and avoiding a pretty bad erratum on the AmpereOne HW.

  - Add workaround for AmpereOne's erratum AC04_CPU_23, which suffers
    from a pretty bad case of TLB corruption unless accesses to HCR_EL2
    are heavily synchronised.

  - Add a per-VM, per-ITS debugfs entry to dump the state of the ITS
    tables in a human-friendly fashion.

  - and the usual random cleanups.

----------------------------------------------------------------
Ben Horgan (3):
      arm64/sysreg: Expose MTE_frac so that it is visible to KVM
      KVM: arm64: Make MTE_frac masking conditional on MTE capability
      KVM: selftests: Confirm exposing MTE_frac does not break migration

D Scott Phillips (1):
      arm64: errata: Work around AmpereOne's erratum AC04_CPU_23

David Brazdil (1):
      KVM: arm64: Add .hyp.data section

Fuad Tabba (1):
      KVM: arm64: Track SVE state in the hypervisor vcpu structure

Gavin Shan (1):
      KVM: arm64: Drop sort_memblock_regions()

Jing Zhang (1):
      KVM: arm64: vgic-its: Add debugfs interface to expose ITS tables

Marc Zyngier (84):
      KVM: arm64: Repaint pmcr_n into nr_pmu_counters
      KVM: arm64: Fix MDCR_EL2.HPMN reset value
      KVM: arm64: Contextualise the handling of PMCR_EL0.P writes
      KVM: arm64: Allow userspace to limit the number of PMU counters for EL2 VMs
      KVM: arm64: Don't let userspace write to PMCR_EL0.N when the vcpu has EL2
      KVM: arm64: Handle out-of-bound write to MDCR_EL2.HPMN
      KVM: arm64: Let kvm_vcpu_read_pmcr() return an EL-dependent value for PMCR_EL0.N
      Merge branch kvm-arm64/nv-pmu-fixes into kvmarm-master/next
      KVM: arm64: Force HCR_EL2.xMO to 1 at all times in VHE mode
      arm64: sysreg: Add ID_AA64ISAR1_EL1.LS64 encoding for FEAT_LS64WB
      arm64: sysreg: Update ID_AA64MMFR4_EL1 description
      arm64: sysreg: Add layout for HCR_EL2
      arm64: sysreg: Replace HFGxTR_EL2 with HFG{R,W}TR_EL2
      arm64: sysreg: Update ID_AA64PFR0_EL1 description
      arm64: sysreg: Update PMSIDR_EL1 description
      arm64: sysreg: Update TRBIDR_EL1 description
      arm64: sysreg: Update CPACR_EL1 description
      arm64: sysreg: Add registers trapped by HFG{R,W}TR2_EL2
      arm64: sysreg: Add registers trapped by HDFG{R,W}TR2_EL2
      arm64: sysreg: Add system instructions trapped by HFGIRT2_EL2
      arm64: Remove duplicated sysreg encodings
      arm64: tools: Resync sysreg.h
      arm64: Add syndrome information for trapped LD64B/ST64B{,V,V0}
      arm64: Add FEAT_FGT2 capability
      KVM: arm64: Tighten handling of unknown FGT groups
      KVM: arm64: Simplify handling of negative FGT bits
      KVM: arm64: Handle trapping of FEAT_LS64* instructions
      KVM: arm64: Restrict ACCDATA_EL1 undef to FEAT_LS64_ACCDATA being disabled
      KVM: arm64: Don't treat HCRX_EL2 as a FGT register
      KVM: arm64: Plug FEAT_GCS handling
      KVM: arm64: Compute FGT masks from KVM's own FGT tables
      KVM: arm64: Add description of FGT bits leading to EC!=0x18
      KVM: arm64: Use computed masks as sanitisers for FGT registers
      KVM: arm64: Propagate FGT masks to the nVHE hypervisor
      KVM: arm64: Use computed FGT masks to setup FGT registers
      KVM: arm64: Remove hand-crafted masks for FGT registers
      KVM: arm64: Use KVM-specific HCRX_EL2 RES0 mask
      KVM: arm64: Handle PSB CSYNC traps
      KVM: arm64: Switch to table-driven FGU configuration
      KVM: arm64: Validate FGT register descriptions against RES0 masks
      KVM: arm64: Fix PAR_EL1.{PTW,S} reporting on AT S1E*
      KVM: arm64: Teach address translation about access faults
      KVM: arm64: Don't feed uninitialised data to HCR_EL2
      arm64: sysreg: Add layout for VNCR_EL2
      KVM: arm64: nv: Allocate VNCR page when required
      KVM: arm64: nv: Extract translation helper from the AT code
      KVM: arm64: nv: Snapshot S1 ASID tagging information during walk
      KVM: arm64: nv: Move TLBI range decoding to a helper
      KVM: arm64: nv: Don't adjust PSTATE.M when L2 is nesting
      KVM: arm64: nv: Add pseudo-TLB backing VNCR_EL2
      KVM: arm64: nv: Add userspace and guest handling of VNCR_EL2
      KVM: arm64: nv: Handle VNCR_EL2-triggered faults
      KVM: arm64: nv: Handle mapping of VNCR_EL2 at EL2
      KVM: arm64: nv: Handle VNCR_EL2 invalidation from MMU notifiers
      KVM: arm64: nv: Program host's VNCR_EL2 to the fixmap address
      KVM: arm64: nv: Add S1 TLB invalidation primitive for VNCR_EL2
      KVM: arm64: nv: Plumb TLBI S1E2 into system instruction dispatch
      KVM: arm64: nv: Remove dead code from ERET handling
      KVM: arm64: Allow userspace to request KVM_ARM_VCPU_EL2*
      KVM: arm64: Document NV caps and vcpu flags
      KVM: arm64: Use FGT feature maps to drive RES0 bits
      KVM: arm64: Allow kvm_has_feat() to take variable arguments
      KVM: arm64: Use HCRX_EL2 feature map to drive fixed-value bits
      KVM: arm64: Use HCR_EL2 feature map to drive fixed-value bits
      KVM: arm64: Add FEAT_FGT2 registers to the VNCR page
      KVM: arm64: Add sanitisation for FEAT_FGT2 registers
      KVM: arm64: Add trap routing for FEAT_FGT2 registers
      KVM: arm64: Add context-switch for FEAT_FGT2 registers
      KVM: arm64: Allow sysreg ranges for FGT descriptors
      KVM: arm64: Add FGT descriptors for FEAT_FGT2
      KVM: arm64: Handle TSB CSYNC traps
      KVM: arm64: nv: Hold mmu_lock when invalidating VNCR SW-TLB before translating
      KVM: arm64: nv: Handle TLBI S1E2 for VNCR invalidation with mmu_lock held
      KVM: arm64: nv: Release faulted-in VNCR page from mmu_lock critical section
      Merge branch kvm-arm64/pkvm-6.16 into kvm-arm64/pkvm-np-thp-6.16
      Merge branch kvm-arm64/pkvm-selftest-6.16 into kvm-arm64/pkvm-np-thp-6.16
      KVM: arm64: Fix documentation for vgic_its_iter_next()
      Merge branch kvm-arm64/pkvm-np-thp-6.16 into kvmarm-master/next
      Merge branch kvm-arm64/ubsan-el2 into kvmarm-master/next
      Merge branch kvm-arm64/mte-frac into kvmarm-master/next
      Merge branch kvm-arm64/fgt-masks into kvmarm-master/next
      Merge branch kvm-arm64/at-fixes-6.16 into kvmarm-master/next
      Merge branch kvm-arm64/nv-nv into kvmarm-master/next
      Merge branch kvm-arm64/misc-6.16 into kvmarm-master/next

Mark Brown (1):
      KVM: arm64: selftests: Add test for SVE host corruption

Mark Rutland (1):
      KVM: arm64: Unconditionally configure fine-grain traps

Mostafa Saleh (4):
      arm64: Introduce esr_is_ubsan_brk()
      ubsan: Remove regs from report_ubsan_failure()
      KVM: arm64: Introduce CONFIG_UBSAN_KVM_EL2
      KVM: arm64: Handle UBSAN faults

Quentin Perret (11):
      KVM: arm64: Fix pKVM page-tracking comments
      KVM: arm64: Use 0b11 for encoding PKVM_NOPAGE
      KVM: arm64: Introduce {get,set}_host_state() helpers
      KVM: arm64: Move hyp state to hyp_vmemmap
      KVM: arm64: Defer EL2 stage-1 mapping on share
      KVM: arm64: Unconditionally cross check hyp state
      KVM: arm64: Don't WARN from __pkvm_host_share_guest()
      KVM: arm64: Selftest for pKVM transitions
      KVM: arm64: Extend pKVM selftest for np-guests
      KVM: arm64: Convert pkvm_mappings to interval tree
      KVM: arm64: Add a range to pkvm_mappings

Seongsu Park (1):
      KVM: arm64: Replace ternary flags with str_on_off() helper

Vincent Donnefort (8):
      KVM: arm64: Handle huge mappings for np-guest CMOs
      KVM: arm64: Introduce for_each_hyp_page
      KVM: arm64: Add a range to __pkvm_host_share_guest()
      KVM: arm64: Add a range to __pkvm_host_unshare_guest()
      KVM: arm64: Add a range to __pkvm_host_wrprotect_guest()
      KVM: arm64: Add a range to __pkvm_host_test_clear_young_guest()
      KVM: arm64: Stage-2 huge mappings for np-guests
      KVM: arm64: np-guest CMOs with PMD_SIZE fixmap

Wei-Lin Chang (1):
      KVM: arm64: nv: Remove clearing of ICH_LR<n>.EOI if ICH_LR<n>.HW == 1

 Documentation/arch/arm64/silicon-errata.rst     |    2 +
 Documentation/virt/kvm/api.rst                  |   14 +-
 Documentation/virt/kvm/devices/vcpu.rst         |   24 +
 arch/arm64/Kconfig                              |   17 +
 arch/arm64/include/asm/el2_setup.h              |   16 +-
 arch/arm64/include/asm/esr.h                    |   17 +-
 arch/arm64/include/asm/fixmap.h                 |    6 +
 arch/arm64/include/asm/hardirq.h                |    4 +-
 arch/arm64/include/asm/kvm_arm.h                |  188 ++--
 arch/arm64/include/asm/kvm_host.h               |   88 +-
 arch/arm64/include/asm/kvm_nested.h             |  100 +++
 arch/arm64/include/asm/kvm_pgtable.h            |    7 +-
 arch/arm64/include/asm/kvm_pkvm.h               |    8 +
 arch/arm64/include/asm/sections.h               |    1 +
 arch/arm64/include/asm/sysreg.h                 |   53 +-
 arch/arm64/include/asm/vncr_mapping.h           |    5 +
 arch/arm64/include/uapi/asm/kvm.h               |    9 +-
 arch/arm64/kernel/cpu_errata.c                  |   14 +
 arch/arm64/kernel/cpufeature.c                  |    8 +
 arch/arm64/kernel/hyp-stub.S                    |    2 +-
 arch/arm64/kernel/image-vars.h                  |    2 +
 arch/arm64/kernel/traps.c                       |    4 +-
 arch/arm64/kernel/vmlinux.lds.S                 |   18 +-
 arch/arm64/kvm/Makefile                         |    2 +-
 arch/arm64/kvm/arm.c                            |   30 +
 arch/arm64/kvm/at.c                             |  186 ++--
 arch/arm64/kvm/config.c                         | 1085 +++++++++++++++++++++++
 arch/arm64/kvm/emulate-nested.c                 |  590 +++++++-----
 arch/arm64/kvm/handle_exit.c                    |   84 ++
 arch/arm64/kvm/hyp/include/hyp/switch.h         |  160 ++--
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h   |   14 +-
 arch/arm64/kvm/hyp/include/nvhe/memory.h        |   58 +-
 arch/arm64/kvm/hyp/include/nvhe/mm.h            |    4 +-
 arch/arm64/kvm/hyp/nvhe/Makefile                |    6 +
 arch/arm64/kvm/hyp/nvhe/host.S                  |    2 +-
 arch/arm64/kvm/hyp/nvhe/hyp-init.S              |    4 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c              |   20 +-
 arch/arm64/kvm/hyp/nvhe/hyp.lds.S               |    2 +
 arch/arm64/kvm/hyp/nvhe/mem_protect.c           |  510 ++++++++---
 arch/arm64/kvm/hyp/nvhe/mm.c                    |   97 +-
 arch/arm64/kvm/hyp/nvhe/pkvm.c                  |   47 +-
 arch/arm64/kvm/hyp/nvhe/setup.c                 |   27 +-
 arch/arm64/kvm/hyp/nvhe/switch.c                |   14 +-
 arch/arm64/kvm/hyp/pgtable.c                    |    6 -
 arch/arm64/kvm/hyp/vgic-v3-sr.c                 |   44 +-
 arch/arm64/kvm/hyp/vhe/switch.c                 |   48 +-
 arch/arm64/kvm/hyp/vhe/tlb.c                    |    4 +-
 arch/arm64/kvm/mmu.c                            |    6 +-
 arch/arm64/kvm/nested.c                         |  846 +++++++++++++-----
 arch/arm64/kvm/pkvm.c                           |  150 ++--
 arch/arm64/kvm/pmu-emul.c                       |   60 +-
 arch/arm64/kvm/reset.c                          |    2 +
 arch/arm64/kvm/sys_regs.c                       |  273 +++---
 arch/arm64/kvm/trace_arm.h                      |    6 +-
 arch/arm64/kvm/vgic/vgic-debug.c                |  224 +++++
 arch/arm64/kvm/vgic/vgic-its.c                  |   39 +-
 arch/arm64/kvm/vgic/vgic-v3-nested.c            |    3 -
 arch/arm64/kvm/vgic/vgic.h                      |   33 +
 arch/arm64/tools/cpucaps                        |    2 +
 arch/arm64/tools/sysreg                         | 1012 ++++++++++++++++++++-
 arch/x86/kernel/traps.c                         |    2 +-
 include/linux/ubsan.h                           |    6 +-
 include/uapi/linux/kvm.h                        |    2 +
 lib/Kconfig.ubsan                               |    9 +
 lib/ubsan.c                                     |    8 +-
 scripts/Makefile.ubsan                          |    5 +-
 tools/arch/arm64/include/asm/sysreg.h           |   65 +-
 tools/testing/selftests/kvm/Makefile.kvm        |    1 +
 tools/testing/selftests/kvm/arm64/host_sve.c    |  127 +++
 tools/testing/selftests/kvm/arm64/set_id_regs.c |   77 +-
 70 files changed, 5370 insertions(+), 1239 deletions(-)
 create mode 100644 arch/arm64/kvm/config.c
 create mode 100644 tools/testing/selftests/kvm/arm64/host_sve.c

