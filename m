Return-Path: <kvm+bounces-26677-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8CEC0976548
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 11:12:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9B042B20E05
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 09:12:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E1A31922EE;
	Thu, 12 Sep 2024 09:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SZsQp90x"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4293F1A28D;
	Thu, 12 Sep 2024 09:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726132356; cv=none; b=BnA5UMNyB8ZfAih0DCwJoMAj5evTCXKhSDg6CAJNHHlWjTjmkHHUplWjPk5UoComjCsE+dbNXpnOU1kq860RRkIGbIBNpPkYCIGQq6oj0EktVjYcgmIMr/1MMXGwueRHr+pkuPh6lSkyHij1FIjhj+QOU0FgQWO7y7NxeuAJBzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726132356; c=relaxed/simple;
	bh=fRjpRgmW7+0CCxzYiPGCqQVYSc3xUiWkTae9V4C6Daw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=BsoesHjvRIJav+Yubcc8+44vMtXVr2aWp2AYyLMxeb+YXHGhWvUn5pHW6S3SeQ6OMzHhOdpuqugDg1FUvEHqlfmNd3Cuu71N815qdlMEm1dD7b1msZlo6CdsYX+4qIOW8uDywwK6PJEnyHfF5hm5iAF1mMKpf3SNpidsjV9Smuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SZsQp90x; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98545C4CEC3;
	Thu, 12 Sep 2024 09:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726132355;
	bh=fRjpRgmW7+0CCxzYiPGCqQVYSc3xUiWkTae9V4C6Daw=;
	h=From:To:Cc:Subject:Date:From;
	b=SZsQp90xDYbKrMMTP2pgPS/OHuy0v1ENGwFjG95pUMWYgrkSX7v9B66VHEjCsgxX1
	 XwHaF8B7KYRG222FaBJLqC+hwVypuoZfFd3Uzy0Hzx7aUycsIEqwW/yQ4ALwgGnybb
	 NzYNhdHOIGfPFypCkPQG21BmOW6UtuY9zCfGkcmTws1TMtsD3bjbgLsRmyAxStcmX6
	 AkcqoKUfmYsyjJqW6jUZ65PefNsXOxOW/qKtWzwQKlqo9rFvOsFMH/MYfdUUqsPQ7s
	 kBwFcMyh3n8wsN1L6q27CyOCO6pKz6Tda6XVYQZMNelwMvV49t3/6NgsbLkTrj3GDx
	 2G+p+QyVydSUw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sofsP-00CNem-5K;
	Thu, 12 Sep 2024 10:12:33 +0100
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Colton Lewis <coltonlewis@google.com>,
	Fuad Tabba <tabba@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Ricardo Koller <ricarkol@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Sebastian Ene <sebastianene@google.com>,
	Snehal Koukuntla <snehalreddy@google.com>,
	Steven Price <steven.price@arm.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Subject: [GIT PULL] KVM/arm64 updates for 6.12
Date: Thu, 12 Sep 2024 10:12:29 +0100
Message-Id: <20240912091229.411782-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, alexandru.elisei@arm.com, anshuman.khandual@arm.com, catalin.marinas@arm.com, coltonlewis@google.com, tabba@google.com, joey.gouly@arm.com, broonie@kernel.org, oliver.upton@linux.dev, ricarkol@google.com, seanjc@google.com, sebastianene@google.com, snehalreddy@google.com, steven.price@arm.com, vdonnefort@google.com, will@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Hi Paolo,

Here's the set of KVM/arm64 changes 6.12. The only two user-visible
features are FP8 support and the new Stage-2 page-table dumper. The NV
onslaught continues with the addition of the address translation
instruction emulation, and we have a bunch of fixes all over the
place (details in the tag text below).

Note that there is a very minor conflict with arm64 in -next, which is
trivially resolved as [1].

Please pull,

	M.

[1] https://lore.kernel.org/linux-next/20240905160856.14e95d14@canb.auug.org.au

The following changes since commit 5be63fc19fcaa4c236b307420483578a56986a37:

  Linux 6.11-rc5 (2024-08-25 19:07:11 +1200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-6.12

for you to fetch changes up to 17a0005644994087794f6552d7a5e105d6976184:

  Merge branch kvm-arm64/visibility-cleanups into kvmarm-master/next (2024-09-12 08:38:17 +0100)

----------------------------------------------------------------
KVM/arm64 updates for 6.12

* New features:

  - Add a Stage-2 page table dumper, reusing the main ptdump
    infrastructure, and allowing easier debugging of the our
    page-table infrastructure

  - Add FP8 support to the KVM/arm64 floating point handling.

  - Add NV support for the AT family of instructions, which mostly
    results in adding a page table walker that deals with most of the
    complexity of the architecture.

* Improvements, fixes and cleanups:

  - Add selftest checks for a bunch of timer emulation corner cases

  - Fix the multiple of cases where KVM/arm64 doesn't correctly handle
    the guest trying to use a GICv3 that isn't advertised

  - Remove REG_HIDDEN_USER from the sysreg infrastructure, making
    things little more simple

  - Prevent MTE tags being restored by userspace if we are actively
    logging writes, as that's a recipe for disaster

  - Correct the refcount on a page that is not considered for MTE tag
    copying (such as a device)

  - Relax the synchronisation when walking a page table to split block
    mappings, moving it at the end the walk, as there is no need to
    perform it on every store.

  - Fix boundary check when transfering memory using FFA

  - Fix pKVM TLB invalidation, only affecting currently out of tree
    code but worth addressing for peace of mind

----------------------------------------------------------------
Colton Lewis (3):
      KVM: arm64: Move data barrier to end of split walk
      KVM: arm64: selftests: Ensure pending interrupts are handled in arch_timer test
      KVM: arm64: selftests: Add arch_timer_edge_cases selftest

Joey Gouly (1):
      KVM: arm64: Make kvm_at() take an OP_AT_*

Marc Zyngier (47):
      KVM: arm64: Move SVCR into the sysreg array
      KVM: arm64: Add predicate for FPMR support in a VM
      KVM: arm64: Move FPMR into the sysreg array
      KVM: arm64: Add save/restore support for FPMR
      KVM: arm64: Honor trap routing for FPMR
      KVM: arm64: Expose ID_AA64FPFR0_EL1 as a writable ID reg
      KVM: arm64: Enable FP8 support when available and configured
      KVM: arm64: Expose ID_AA64PFR2_EL1 to userspace and guests
      Merge branch kvm-arm64/tlbi-fixes-6.12 into kvmarm-master/next
      KVM: arm64: Move GICv3 trap configuration to kvm_calculate_traps()
      KVM: arm64: Force SRE traps when SRE access is not enabled
      KVM: arm64: Force GICv3 trap activation when no irqchip is configured on VHE
      KVM: arm64: Add helper for last ditch idreg adjustments
      KVM: arm64: Zero ID_AA64PFR0_EL1.GIC when no GICv3 is presented to the guest
      KVM: arm64: Add ICH_HCR_EL2 to the vcpu state
      KVM: arm64: Add trap routing information for ICH_HCR_EL2
      KVM: arm64: Honor guest requested traps in GICv3 emulation
      KVM: arm64: Make most GICv3 accesses UNDEF if they trap
      KVM: arm64: Unify UNDEF injection helpers
      KVM: arm64: Add selftest checking how the absence of GICv3 is handled
      arm64: Add missing APTable and TCR_ELx.HPD masks
      arm64: Add PAR_EL1 field description
      arm64: Add system register encoding for PSTATE.PAN
      arm64: Add ESR_ELx_FSC_ADDRSZ_L() helper
      KVM: arm64: nv: Enforce S2 alignment when contiguous bit is set
      KVM: arm64: nv: Turn upper_attr for S2 walk into the full descriptor
      KVM: arm64: nv: Honor absence of FEAT_PAN2
      KVM: arm64: nv: Add basic emulation of AT S1E{0,1}{R,W}
      KVM: arm64: nv: Add basic emulation of AT S1E1{R,W}P
      KVM: arm64: nv: Add basic emulation of AT S1E2{R,W}
      KVM: arm64: nv: Add emulation of AT S12E{0,1}{R,W}
      KVM: arm64: nv: Make ps_to_output_size() generally available
      KVM: arm64: nv: Add SW walker for AT S1 emulation
      KVM: arm64: nv: Sanitise SCTLR_EL1.EPAN according to VM configuration
      KVM: arm64: nv: Make AT+PAN instructions aware of FEAT_PAN3
      KVM: arm64: nv: Plumb handling of AT S1* traps from EL2
      KVM: arm64: nv: Add support for FEAT_ATS1A
      KVM: arm64: Simplify handling of CNTKCTL_EL12
      KVM: arm64: Simplify visibility handling of AArch32 SPSR_*
      KVM: arm64: Get rid of REG_HIDDEN_USER visibility qualifier
      Merge branch kvm-arm64/mmu-misc-6.12 into kvmarm-master/next
      Merge branch kvm-arm64/fpmr into kvmarm-master/next
      Merge branch kvm-arm64/vgic-sre-traps into kvmarm-master/next
      Merge branch kvm-arm64/selftests-6.12 into kvmarm-master/next
      Merge branch kvm-arm64/nv-at-pan into kvmarm-master/next
      Merge branch kvm-arm64/s2-ptdump into kvmarm-master/next
      Merge branch kvm-arm64/visibility-cleanups into kvmarm-master/next

Oliver Upton (1):
      KVM: arm64: selftests: Cope with lack of GICv3 in set_id_regs

Sean Christopherson (2):
      KVM: arm64: Release pfn, i.e. put page, if copying MTE tags hits ZONE_DEVICE
      KVM: arm64: Disallow copying MTE to guest memory while KVM is dirty logging

Sebastian Ene (5):
      KVM: arm64: Move pagetable definitions to common header
      arm64: ptdump: Expose the attribute parsing functionality
      arm64: ptdump: Use the ptdump description from a local context
      arm64: ptdump: Don't override the level when operating on the stage-2 tables
      KVM: arm64: Register ptdump with debugfs on guest creation

Snehal Koukuntla (1):
      KVM: arm64: Add memory length checks and remove inline in do_ffa_mem_xfer

Will Deacon (2):
      KVM: arm64: Invalidate EL1&0 TLB entries for all VMIDs in nvhe hyp init
      KVM: arm64: Ensure TLBI uses correct VMID after changing context

 arch/arm64/include/asm/esr.h                       |    5 +-
 arch/arm64/include/asm/kvm_arm.h                   |    1 +
 arch/arm64/include/asm/kvm_asm.h                   |    6 +-
 arch/arm64/include/asm/kvm_host.h                  |   22 +-
 arch/arm64/include/asm/kvm_mmu.h                   |    6 +
 arch/arm64/include/asm/kvm_nested.h                |   40 +-
 arch/arm64/include/asm/kvm_pgtable.h               |   42 +
 arch/arm64/include/asm/pgtable-hwdef.h             |    9 +
 arch/arm64/include/asm/ptdump.h                    |   43 +-
 arch/arm64/include/asm/sysreg.h                    |   22 +
 arch/arm64/kvm/Kconfig                             |   17 +
 arch/arm64/kvm/Makefile                            |    3 +-
 arch/arm64/kvm/arm.c                               |   15 +-
 arch/arm64/kvm/at.c                                | 1101 ++++++++++++++++++++
 arch/arm64/kvm/emulate-nested.c                    |   81 +-
 arch/arm64/kvm/fpsimd.c                            |    5 +-
 arch/arm64/kvm/guest.c                             |    6 +
 arch/arm64/kvm/hyp/include/hyp/fault.h             |    2 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h            |    3 +
 arch/arm64/kvm/hyp/nvhe/ffa.c                      |   21 +-
 arch/arm64/kvm/hyp/nvhe/hyp-init.S                 |    2 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c                 |    9 +
 arch/arm64/kvm/hyp/nvhe/switch.c                   |    9 +
 arch/arm64/kvm/hyp/nvhe/tlb.c                      |    6 +-
 arch/arm64/kvm/hyp/pgtable.c                       |   48 +-
 arch/arm64/kvm/hyp/vgic-v3-sr.c                    |   97 +-
 arch/arm64/kvm/hyp/vhe/switch.c                    |    3 +
 arch/arm64/kvm/nested.c                            |   55 +-
 arch/arm64/kvm/ptdump.c                            |  268 +++++
 arch/arm64/kvm/sys_regs.c                          |  386 ++++---
 arch/arm64/kvm/sys_regs.h                          |   23 +-
 arch/arm64/kvm/vgic/vgic-v3.c                      |   12 +
 arch/arm64/kvm/vgic/vgic.c                         |   14 +-
 arch/arm64/kvm/vgic/vgic.h                         |    6 +-
 arch/arm64/mm/ptdump.c                             |   70 +-
 tools/testing/selftests/kvm/Makefile               |    2 +
 .../selftests/kvm/aarch64/arch_timer_edge_cases.c  | 1062 +++++++++++++++++++
 tools/testing/selftests/kvm/aarch64/no-vgic-v3.c   |  175 ++++
 tools/testing/selftests/kvm/aarch64/set_id_regs.c  |    1 +
 tools/testing/selftests/kvm/aarch64/vgic_irq.c     |   11 +-
 .../selftests/kvm/include/aarch64/arch_timer.h     |   18 +-
 .../selftests/kvm/include/aarch64/processor.h      |    3 +
 .../testing/selftests/kvm/lib/aarch64/processor.c  |    6 +
 43 files changed, 3405 insertions(+), 331 deletions(-)
 create mode 100644 arch/arm64/kvm/at.c
 create mode 100644 arch/arm64/kvm/ptdump.c
 create mode 100644 tools/testing/selftests/kvm/aarch64/arch_timer_edge_cases.c
 create mode 100644 tools/testing/selftests/kvm/aarch64/no-vgic-v3.c

