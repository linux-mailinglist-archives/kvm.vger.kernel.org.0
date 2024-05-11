Return-Path: <kvm+bounces-17251-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 47C0A8C3077
	for <lists+kvm@lfdr.de>; Sat, 11 May 2024 11:52:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F03C0281EB4
	for <lists+kvm@lfdr.de>; Sat, 11 May 2024 09:52:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 579B253E25;
	Sat, 11 May 2024 09:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VgqxSMHW"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E0012F26;
	Sat, 11 May 2024 09:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715421164; cv=none; b=twrf89uIdVyfSyYmxBEk8UZB2v+Nom1ZpEbRVD0R9ZAoIwH5Zr3SBdGXnqIQ/iSwbpq5fcvhU6ivTGT5OdanQWRNezvHhBtkClZC7NvnmDIj1ZcQGcGS/Xt7FghCcVvG+a31LGAv9wW86tE7jm9t2MoncdFLfectTTnHUHVpvOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715421164; c=relaxed/simple;
	bh=EfOCPy+YGjR9TMmS/P7GdYYWiVntQXd30cf4n9bMViI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=EzEV4RkucooEYmPHHlkO7gBEmo7pukErMu49G3WDJM/qSIQ0NgePEinK1pnI0yBy/u1yQVofMVtjZXrkpp3GDc8W4CTGubfqevo8zJ9Eli9DjfZnRFHvwSxc3cC9Ojf7QCVPxWQVcSRSKoXb85hzFncFYnOLzYxxi8hIzsmEeAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VgqxSMHW; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF3A9C2BBFC;
	Sat, 11 May 2024 09:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715421164;
	bh=EfOCPy+YGjR9TMmS/P7GdYYWiVntQXd30cf4n9bMViI=;
	h=From:To:Cc:Subject:Date:From;
	b=VgqxSMHWVb1KTXlgHVv/V9KYvmLOL7miBiT5Fk2gCGYMn7EPlqqGm3CWQUrTHA1Vg
	 Qz501gsIf4g3eHasW5+VCWAlUGchavqmJV9JpfspKqSjouGZUxgBgf+s6+r+nS+89A
	 esHgx3hUYnAWY3b1dy8QbIzDvBQ/MDJ5Kdcy82mcDLzjNOwh7JkcpP2oCuwlA24nQZ
	 Qv2HCkKY1fFlxbSihl5q5dSI6xYd8VE+OD/lxEVrVvFHBS5MwdN5xeJPPFCHK0XYIg
	 60pLcAHd2l+BziV75DCkidp4GbRuK6MiopkfU/c0w/Spf8+TYhipDLBYVUnWeRduCA
	 m+dF5yUkHBbNg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1s5jPF-00CPmO-KL;
	Sat, 11 May 2024 10:52:41 +0100
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
	Colton Lewis <coltonlewis@google.com>,
	Fuad Tabba <tabba@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Quentin Perret <qperret@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Russell King <rmk+kernel@armlinux.org.uk>,
	Sean Christopherson <seanjc@google.com>,
	Sebastian Ene <sebastianene@google.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Will Deacon <will@kernel.org>,
	Zenghui Yu <zenghui.yu@linux.dev>,
	James Morse <james.morse@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Subject: [GIT PULL] KVM/arm64 updates for 6.10
Date: Sat, 11 May 2024 10:52:37 +0100
Message-Id: <20240511095237.3993387-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, arnd@arndb.de, coltonlewis@google.com, tabba@google.com, joey.gouly@arm.com, broonie@kernel.org, mark.rutland@arm.com, oliver.upton@linux.dev, qperret@google.com, rananta@google.com, rmk+kernel@armlinux.org.uk, seanjc@google.com, sebastianene@google.com, suzuki.poulose@arm.com, will@kernel.org, zenghui.yu@linux.dev, james.morse@arm.com, yuzenghui@huawei.com, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Paolo,

Here's the set of KVM/arm64 updates for 6.10. No new feature exactly,
but a lot of internal rework, improvements and bug fixes, However, it
is pretty good to see that the Android folks are resuming the
upstreaming effort after a long period of silence.

As usual, details in the tag below.

Please pull,

	M.

The following changes since commit fec50db7033ea478773b159e0e2efb135270e3b7:

  Linux 6.9-rc3 (2024-04-07 13:22:46 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-6.10-1

for you to fetch changes up to eaa46a28d59655aa89a8fb885affa6fc0de44376:

  Merge branch kvm-arm64/mpidr-reset into kvmarm-master/next (2024-05-09 18:44:15 +0100)

----------------------------------------------------------------
KVM/arm64 updates for Linux 6.10

- Move a lot of state that was previously stored on a per vcpu
  basis into a per-CPU area, because it is only pertinent to the
  host while the vcpu is loaded. This results in better state
  tracking, and a smaller vcpu structure.

- Add full handling of the ERET/ERETAA/ERETAB instructions in
  nested virtualisation. The last two instructions also require
  emulating part of the pointer authentication extension.
  As a result, the trap handling of pointer authentication has
  been greattly simplified.

- Turn the global (and not very scalable) LPI translation cache
  into a per-ITS, scalable cache, making non directly injected
  LPIs much cheaper to make visible to the vcpu.

- A batch of pKVM patches, mostly fixes and cleanups, as the
  upstreaming process seems to be resuming. Fingers crossed!

- Allocate PPIs and SGIs outside of the vcpu structure, allowing
  for smaller EL2 mapping and some flexibility in implementing
  more or less than 32 private IRQs.

- Purge stale mpidr_data if a vcpu is created after the MPIDR
  map has been created.

- Preserve vcpu-specific ID registers across a vcpu reset.

- Various minor cleanups and improvements.

----------------------------------------------------------------
Fuad Tabba (13):
      KVM: arm64: Initialize the kvm host data's fpsimd_state pointer in pKVM
      KVM: arm64: Move guest_owns_fp_regs() to increase its scope
      KVM: arm64: Refactor checks for FP state ownership
      KVM: arm64: Do not re-initialize the KVM lock
      KVM: arm64: Rename __tlb_switch_to_{guest,host}() in VHE
      KVM: arm64: Do not map the host fpsimd state to hyp in pKVM
      KVM: arm64: Fix comment for __pkvm_vcpu_init_traps()
      KVM: arm64: Change kvm_handle_mmio_return() return polarity
      KVM: arm64: Move setting the page as dirty out of the critical section
      KVM: arm64: Introduce and use predicates that check for protected VMs
      KVM: arm64: Clarify rationale for ZCR_EL1 value restored on guest exit
      KVM: arm64: Refactor setting the return value in kvm_vm_ioctl_enable_cap()
      KVM: arm64: Restrict supported capabilities for protected VMs

Marc Zyngier (34):
      KVM: arm64: Add accessor for per-CPU state
      KVM: arm64: Exclude host_debug_data from vcpu_arch
      KVM: arm64: Exclude mdcr_el2_host from kvm_vcpu_arch
      KVM: arm64: Exclude host_fpsimd_state pointer from kvm_vcpu_arch
      KVM: arm64: Exclude FP ownership from kvm_vcpu_arch
      KVM: arm64: Improve out-of-order sysreg table diagnostics
      KVM: arm64: Harden __ctxt_sys_reg() against out-of-range values
      KVM: arm64: Add helpers for ESR_ELx_ERET_ISS_ERET*
      KVM: arm64: Constraint PAuth support to consistent implementations
      KVM: arm64: nv: Drop VCPU_HYP_CONTEXT flag
      KVM: arm64: nv: Configure HCR_EL2 for FEAT_NV2
      KVM: arm64: nv: Add trap forwarding for ERET and SMC
      KVM: arm64: nv: Fast-track 'InHost' exception returns
      KVM: arm64: nv: Honor HFGITR_EL2.ERET being set
      KVM: arm64: nv: Handle HCR_EL2.{API,APK} independently
      KVM: arm64: nv: Reinject PAC exceptions caused by HCR_EL2.API==0
      KVM: arm64: nv: Add kvm_has_pauth() helper
      KVM: arm64: nv: Add emulation for ERETAx instructions
      KVM: arm64: nv: Handle ERETA[AB] instructions
      KVM: arm64: nv: Advertise support for PAuth
      KVM: arm64: Drop trapping of PAuth instructions/keys
      KVM: arm64: nv: Work around lack of pauth support in old toolchains
      KVM: arm64: Check for PTE validity when checking for executable/cacheable
      KVM: arm64: Simplify vgic-v3 hypercalls
      KVM: arm64: Force injection of a data abort on NISV MMIO exit
      KVM: arm64: vgic: Allocate private interrupts on demand
      KVM: arm64: Convert kvm_mpidr_index() to bitmap_gather()
      KVM: arm64: Move management of __hyp_running_vcpu to load/put on VHE
      Merge branch kvm-arm64/host_data into kvmarm-master/next
      Merge branch kvm-arm64/nv-eret-pauth into kvmarm-master/next
      Merge branch kvm-arm64/lpi-xa-cache into kvmarm-master/next
      Merge branch kvm-arm64/pkvm-6.10 into kvmarm-master/next
      Merge branch kvm-arm64/misc-6.10 into kvmarm-master/next
      Merge branch kvm-arm64/mpidr-reset into kvmarm-master/next

Oliver Upton (27):
      KVM: Treat the device list as an rculist
      KVM: arm64: vgic-its: Walk LPI xarray in its_sync_lpi_pending_table()
      KVM: arm64: vgic-its: Walk LPI xarray in vgic_its_invall()
      KVM: arm64: vgic-its: Walk LPI xarray in vgic_its_cmd_handle_movall()
      KVM: arm64: vgic-debug: Use an xarray mark for debug iterator
      KVM: arm64: vgic-its: Get rid of vgic_copy_lpi_list()
      KVM: arm64: vgic-its: Scope translation cache invalidations to an ITS
      KVM: arm64: vgic-its: Maintain a translation cache per ITS
      KVM: arm64: vgic-its: Spin off helper for finding ITS by doorbell addr
      KVM: arm64: vgic-its: Use the per-ITS translation cache for injection
      KVM: arm64: vgic-its: Rip out the global translation cache
      KVM: arm64: vgic-its: Get rid of the lpi_list_lock
      KVM: selftests: Align with kernel's GIC definitions
      KVM: selftests: Standardise layout of GIC frames
      KVM: selftests: Add quadword MMIO accessors
      KVM: selftests: Add a minimal library for interacting with an ITS
      KVM: selftests: Add helper for enabling LPIs on a redistributor
      KVM: selftests: Use MPIDR_HWID_BITMASK from cputype.h
      KVM: selftests: Add stress test for LPI injection
      KVM: arm64: Destroy mpidr_data for 'late' vCPU creation
      KVM: arm64: Rename is_id_reg() to imply VM scope
      KVM: arm64: Reset VM feature ID regs from kvm_reset_sys_regs()
      KVM: arm64: Only reset vCPU-scoped feature ID regs once
      KVM: selftests: arm64: Rename helper in set_id_regs to imply VM scope
      KVM: selftests: arm64: Store expected register value in set_id_regs
      KVM: selftests: arm64: Test that feature ID regs survive a reset
      KVM: selftests: arm64: Test vCPU-scoped feature ID registers

Quentin Perret (4):
      KVM: arm64: Issue CMOs when tearing down guest s2 pages
      KVM: arm64: Avoid BUG-ing from the host abort path
      KVM: arm64: Prevent kmemleak from accessing .hyp.data
      KVM: arm64: Add is_pkvm_initialized() helper

Russell King (1):
      KVM: arm64: Remove duplicated AA64MMFR1_EL1 XNX

Sebastian Ene (1):
      KVM: arm64: Remove FFA_MSG_SEND_DIRECT_REQ from the denylist

Will Deacon (7):
      KVM: arm64: Avoid BBM when changing only s/w bits in Stage-2 PTE
      KVM: arm64: Support TLB invalidation in guest context
      KVM: arm64: Reformat/beautify PTP hypercall documentation
      KVM: arm64: Rename firmware pseudo-register documentation file
      KVM: arm64: Document the KVM/arm64-specific calls in hypercalls.rst
      KVM: arm64: Fix hvhe/nvhe early alias parsing
      KVM: arm64: Use hVHE in pKVM by default on CPUs with VHE support

 Documentation/virt/kvm/api.rst                     |   7 +
 Documentation/virt/kvm/arm/fw-pseudo-registers.rst | 138 +++++
 Documentation/virt/kvm/arm/hypercalls.rst          | 180 ++-----
 Documentation/virt/kvm/arm/index.rst               |   1 +
 Documentation/virt/kvm/arm/ptp_kvm.rst             |  38 +-
 arch/arm64/include/asm/esr.h                       |  12 +
 arch/arm64/include/asm/kvm_asm.h                   |   8 +-
 arch/arm64/include/asm/kvm_emulate.h               |  16 +-
 arch/arm64/include/asm/kvm_host.h                  | 156 ++++--
 arch/arm64/include/asm/kvm_hyp.h                   |   4 +-
 arch/arm64/include/asm/kvm_nested.h                |  13 +
 arch/arm64/include/asm/kvm_ptrauth.h               |  21 +
 arch/arm64/include/asm/pgtable-hwdef.h             |   1 +
 arch/arm64/include/asm/virt.h                      |  12 +-
 arch/arm64/kernel/pi/idreg-override.c              |   4 +-
 arch/arm64/kvm/Makefile                            |   1 +
 arch/arm64/kvm/arm.c                               | 209 ++++++--
 arch/arm64/kvm/emulate-nested.c                    |  66 ++-
 arch/arm64/kvm/fpsimd.c                            |  69 ++-
 arch/arm64/kvm/handle_exit.c                       |  36 +-
 arch/arm64/kvm/hyp/include/hyp/debug-sr.h          |   8 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h            |  86 +--
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h             |   6 +
 arch/arm64/kvm/hyp/nvhe/debug-sr.c                 |   8 +-
 arch/arm64/kvm/hyp/nvhe/ffa.c                      |   1 -
 arch/arm64/kvm/hyp/nvhe/hyp-main.c                 |  27 +-
 arch/arm64/kvm/hyp/nvhe/mem_protect.c              |   8 +-
 arch/arm64/kvm/hyp/nvhe/pkvm.c                     |  14 +-
 arch/arm64/kvm/hyp/nvhe/psci-relay.c               |   2 +-
 arch/arm64/kvm/hyp/nvhe/setup.c                    |   4 +-
 arch/arm64/kvm/hyp/nvhe/switch.c                   |  18 +-
 arch/arm64/kvm/hyp/nvhe/tlb.c                      | 115 +++-
 arch/arm64/kvm/hyp/pgtable.c                       |  21 +-
 arch/arm64/kvm/hyp/vgic-v3-sr.c                    |  27 +-
 arch/arm64/kvm/hyp/vhe/switch.c                    | 109 +++-
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c                 |   4 +-
 arch/arm64/kvm/hyp/vhe/tlb.c                       |  26 +-
 arch/arm64/kvm/mmio.c                              |  12 +-
 arch/arm64/kvm/mmu.c                               |   8 +-
 arch/arm64/kvm/nested.c                            |   8 +-
 arch/arm64/kvm/pauth.c                             | 206 ++++++++
 arch/arm64/kvm/pkvm.c                              |   2 +-
 arch/arm64/kvm/pmu.c                               |   2 +-
 arch/arm64/kvm/reset.c                             |   1 -
 arch/arm64/kvm/sys_regs.c                          |  69 ++-
 arch/arm64/kvm/vgic/vgic-debug.c                   |  82 ++-
 arch/arm64/kvm/vgic/vgic-init.c                    |  90 +++-
 arch/arm64/kvm/vgic/vgic-its.c                     | 352 ++++---------
 arch/arm64/kvm/vgic/vgic-mmio-v3.c                 |   2 +-
 arch/arm64/kvm/vgic/vgic-v2.c                      |   9 +-
 arch/arm64/kvm/vgic/vgic-v3.c                      |  23 +-
 arch/arm64/kvm/vgic/vgic.c                         |  17 +-
 arch/arm64/kvm/vgic/vgic.h                         |   8 +-
 include/kvm/arm_vgic.h                             |  16 +-
 tools/testing/selftests/kvm/Makefile               |   2 +
 tools/testing/selftests/kvm/aarch64/arch_timer.c   |   8 +-
 tools/testing/selftests/kvm/aarch64/psci_test.c    |   2 +
 tools/testing/selftests/kvm/aarch64/set_id_regs.c  | 123 ++++-
 tools/testing/selftests/kvm/aarch64/vgic_irq.c     |  15 +-
 .../selftests/kvm/aarch64/vgic_lpi_stress.c        | 410 ++++++++++++++
 .../selftests/kvm/aarch64/vpmu_counter_access.c    |   6 +-
 tools/testing/selftests/kvm/dirty_log_perf_test.c  |   5 +-
 tools/testing/selftests/kvm/include/aarch64/gic.h  |  21 +-
 .../testing/selftests/kvm/include/aarch64/gic_v3.h | 586 +++++++++++++++++++--
 .../selftests/kvm/include/aarch64/gic_v3_its.h     |  19 +
 .../selftests/kvm/include/aarch64/processor.h      |  19 +-
 tools/testing/selftests/kvm/include/aarch64/vgic.h |   5 +-
 tools/testing/selftests/kvm/lib/aarch64/gic.c      |  18 +-
 .../selftests/kvm/lib/aarch64/gic_private.h        |   4 +-
 tools/testing/selftests/kvm/lib/aarch64/gic_v3.c   |  99 ++--
 .../testing/selftests/kvm/lib/aarch64/gic_v3_its.c | 248 +++++++++
 tools/testing/selftests/kvm/lib/aarch64/vgic.c     |  38 +-
 virt/kvm/kvm_main.c                                |  14 +-
 virt/kvm/vfio.c                                    |   2 +
 74 files changed, 2971 insertions(+), 1056 deletions(-)
 create mode 100644 Documentation/virt/kvm/arm/fw-pseudo-registers.rst
 create mode 100644 arch/arm64/kvm/pauth.c
 create mode 100644 tools/testing/selftests/kvm/aarch64/vgic_lpi_stress.c
 create mode 100644 tools/testing/selftests/kvm/include/aarch64/gic_v3_its.h
 create mode 100644 tools/testing/selftests/kvm/lib/aarch64/gic_v3_its.c

