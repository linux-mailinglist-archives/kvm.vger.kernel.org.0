Return-Path: <kvm+bounces-70452-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CPksNnoKhmkRJQQAu9opvQ
	(envelope-from <kvm+bounces-70452-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 16:36:26 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B1C7FFCF5
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 16:36:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3DCF43038284
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 15:33:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B709829E0F8;
	Fri,  6 Feb 2026 15:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ItiOS6aM"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7D9421CFE0;
	Fri,  6 Feb 2026 15:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770392037; cv=none; b=PWWYxSExEym/AbL34GUbmS+DgYAqBT2pBqlMtLDg4PTYvqukTyCDN9MwuUfyQKjMyPz9WZirpTXrrpK7vhq0rCCV687SCqoHySxA5+Ng7451Jjbcja4xtUPUgs4MTAyFmYEOwxVEWRMYoIiLi7vLzkf82VPw4Ebc5G6ASoMKoiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770392037; c=relaxed/simple;
	bh=fn0TyDWl64Skcie8Aa+axc1JPTyygKOE9FMwGpfp09Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=tjz1Aoioj2j/axWN7YaZv917UZkCKP7teZt7y9QOGgRqu9VPdHEBIgbfnPa1ZQWjESJeHn9A0inWm3rWKGJlWu2APRPwNAI/eUPmWf2aEHyly9aKhmWyQZvhxjZvN+u1H/iDO2m4GTFFYe1UkRY+U/H9Q3fqa7EigZOl9YBVXp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ItiOS6aM; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73AFFC116C6;
	Fri,  6 Feb 2026 15:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770392036;
	bh=fn0TyDWl64Skcie8Aa+axc1JPTyygKOE9FMwGpfp09Y=;
	h=From:To:Cc:Subject:Date:From;
	b=ItiOS6aM8gr7Dpe3+Gxja45LP1aDokl5U/JzyBaJXGoLICJdRIIiQMJoZE6Pk+3c4
	 k/BZETonOBz7sPY6iSc8O3DuLr5LPWBL0PmrYKeyJFqwOo6P9lk5HQIOga2vEu/sqb
	 Rj8L9bQbKBQu2RSu60rbqwJ+MJ1KO5e9pE3vrCGA+F9gwCHqJtNHiFufnCDiBaJ5vI
	 kCfH2JsgG2CkYsf7d+p5wL4IXkGd5NFDAU8DsT8KPg6A3xdF/5okwWCoU9Ha5OqCFz
	 DtT+OqMjAp0GBgkznbntZg/bRBy5NB/niv9OfHVySnNgNrBlw0xlDz3hZjQ0Hrle4y
	 0Egu99B2NJ3sw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1voNqD-00000009BjZ-3gcH;
	Fri, 06 Feb 2026 15:33:54 +0000
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Arnd Bergmann <arnd@arndb.de>,
	Ben Dooks <ben.dooks@codethink.co.uk>,
	Ben Horgan <ben.horgan@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dongxu Sun <sundongxu1024@163.com>,
	Fuad Tabba <tabba@google.com>,
	Itaru Kitayama <itaru.kitayama@fujitsu.com>,
	Jinqian Yang <yangjinqian1@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	=?UTF-8?q?Kornel=20Dul=C4=99ba?= <korneld@google.com>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Oliver Upton <oupton@kernel.org>,
	Petteri Kangaslampi <pekangas@google.com>,
	Quentin Perret <qperret@google.com>,
	Sascha Bischoff <sascha.bischoff@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Will Deacon <will@kernel.org>,
	Yicong Yang <yangyicong@hisilicon.com>,
	Yuan Yao <yaoyuan@linux.alibaba.com>,
	Zenghui Yu <zenghui.yu@linux.dev>,
	Zhou Wang <wangzhou1@hisilicon.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Subject: [GIT PULL] KVM/arm64 updates for 7.0
Date: Fri,  6 Feb 2026 15:33:45 +0000
Message-ID: <20260206153345.3582574-1-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, alexandru.elisei@arm.com, andrew.jones@linux.dev, arnd@arndb.de, ben.dooks@codethink.co.uk, ben.horgan@arm.com, catalin.marinas@arm.com, sundongxu1024@163.com, tabba@google.com, itaru.kitayama@fujitsu.com, yangjinqian1@huawei.com, joey.gouly@arm.com, jonathan.cameron@huawei.com, korneld@google.com, lpieralisi@kernel.org, broonie@kernel.org, mark.rutland@arm.com, nathan@kernel.org, oliver.upton@linux.dev, oupton@kernel.org, pekangas@google.com, qperret@google.com, sascha.bischoff@arm.com, suzuki.poulose@arm.com, vdonnefort@google.com, will@kernel.org, yangyicong@hisilicon.com, yaoyuan@linux.alibaba.com, zenghui.yu@linux.dev, wangzhou1@hisilicon.com, yuzenghui@huawei.com, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[34];
	FREEMAIL_CC(0.00)[arm.com,linux.dev,arndb.de,codethink.co.uk,163.com,google.com,fujitsu.com,huawei.com,kernel.org,hisilicon.com,linux.alibaba.com,lists.linux.dev,lists.infradead.org,vger.kernel.org];
	TAGGED_FROM(0.00)[bounces-70452-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[maz@kernel.org,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[hcr_el2.rw:url,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 3B1C7FFCF5
X-Rspamd-Action: no action

[With the various lists on Cc this time around, apologies for the
 noise]

Paolo,

Here's the initial set of updates for 7.0.

This time, the changes are more or less separated in two cagegories:

- a bunch of pKVM fixes, mostly ensuring that features that are not
  exposed to guest or host are indeed out of reach

- a lot of rework of the register sanitisation infrastructure,
  including new registers being sanitised

The rest is a set of random, low key changes -- details in the tag
below.

Note that this pull request also brings two additional branches to
avoid ugly conflicts:

- the kvmarm-fixes-6.19-1 tag, which made it into Linus' tree after
  the base for the kvmarm/next branch was created,

- a shared branch with the arm64 tree (arm64/for-next/cpufeature),
  which also touches KVM

Please pull,

	M.

The following changes since commit 9ace4753a5202b02191d54e9fdf7f9e3d02b85eb:

  Linux 6.19-rc4 (2026-01-04 14:41:55 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-7.0

for you to fetch changes up to 6316366129d2885fae07c2774f4b7ae0a45fb55d:

  Merge branch kvm-arm64/misc-6.20 into kvmarm-master/next (2026-02-05 09:17:58 +0000)

----------------------------------------------------------------
KVM/arm64 updates for 7.0

- Add support for FEAT_IDST, allowing ID registers that are not
  implemented to be reported as a normal trap rather than as an UNDEF
  exception.

- Add sanitisation of the VTCR_EL2 register, fixing a number of
  UXN/PXN/XN bugs in the process.

- Full handling of RESx bits, instead of only RES0, and resulting in
  SCTLR_EL2 being added to the list of sanitised registers.

- More pKVM fixes for features that are not supposed to be exposed to
  guests.

- Make sure that MTE being disabled on the pKVM host doesn't give it
  the ability to attack the hypervisor.

- Allow pKVM's host stage-2 mappings to use the Force Write Back
  version of the memory attributes by using the "pass-through'
  encoding.

- Fix trapping of ICC_DIR_EL1 on GICv5 hosts emulating GICv3 for the
  guest.

- Preliminary work for guest GICv5 support.

- A bunch of debugfs fixes, removing pointless custom iterators stored
  in guest data structures.

- A small set of FPSIMD cleanups.

- Selftest fixes addressing the incorrect alignment of page
  allocation.

- Other assorted low-impact fixes and spelling fixes.

----------------------------------------------------------------
Alexandru Elisei (4):
      KVM: arm64: Copy FGT traps to unprotected pKVM VCPU on VCPU load
      KVM: arm64: Inject UNDEF for a register trap without accessor
      KVM: arm64: Remove extra argument for __pvkm_host_{share,unshare}_hyp()
      KVM: arm64: Remove unused parameter in synchronize_vcpu_pstate()

Ben Dooks (1):
      KVM: arm64: Fix missing <asm/stackpage/nvhe.h> include

Dongxu Sun (1):
      KVM: arm64: Remove unused vcpu_{clear,set}_wfx_traps()

Fuad Tabba (22):
      KVM: arm64: selftests: Disable unused TTBR1_EL1 translations
      KVM: arm64: selftests: Fix incorrect rounding in page_align()
      KVM: riscv: selftests: Fix incorrect rounding in page_align()
      KVM: selftests: Move page_align() to shared header
      KVM: selftests: Fix typos and stale comments in kvm_util
      KVM: arm64: Fix Trace Buffer trapping for protected VMs
      KVM: arm64: Fix Trace Buffer trap polarity for protected VMs
      KVM: arm64: Fix MTE flag initialization for protected VMs
      KVM: arm64: Introduce helper to calculate fault IPA offset
      KVM: arm64: Include VM type when checking VM capabilities in pKVM
      KVM: arm64: Do not allow KVM_CAP_ARM_MTE for any guest in pKVM
      KVM: arm64: Track KVM IOCTLs and their associated KVM caps
      KVM: arm64: Check whether a VM IOCTL is allowed in pKVM
      KVM: arm64: Prevent host from managing timer offsets for protected VMs
      KVM: arm64: Remove dead code resetting HCR_EL2 for pKVM
      KVM: arm64: Trap MTE access and discovery when MTE is disabled
      KVM: arm64: Inject UNDEF when accessing MTE sysregs with MTE disabled
      KVM: arm64: Use kvm_has_mte() in pKVM trap initialization
      KVM: arm64: Use standard seq_file iterator for idregs debugfs
      KVM: arm64: Reimplement vgic-debug XArray iteration
      KVM: arm64: Use standard seq_file iterator for vgic-debug debugfs
      KVM: arm64: nv: Avoid NV stage-2 code when NV is not supported

Jinqian Yang (1):
      arm64: Add support for TSV110 Spectre-BHB mitigation

Kornel Dulęba (1):
      KVM: arm64: Fix error checking for FFA_VERSION

Marc Zyngier (59):
      KVM: arm64: Fix EL2 S1 XN handling for hVHE setups
      KVM: arm64: Don't blindly set set PSTATE.PAN on guest exit
      Merge branch kvmarm-fixes-6.19-1 into kvm-arm64/vtcr
      arm64: Convert ID_AA64MMFR0_EL1.TGRAN{4,16,64}_2 to UnsignedEnum
      arm64: Convert VTCR_EL2 to sysreg infratructure
      KVM: arm64: Account for RES1 bits in DECLARE_FEAT_MAP() and co
      KVM: arm64: Convert VTCR_EL2 to config-driven sanitisation
      KVM: arm64: Honor UX/PX attributes for EL2 S1 mappings
      arm64: Repaint ID_AA64MMFR2_EL1.IDS description
      KVM: arm64: Add trap routing for GMID_EL1
      KVM: arm64: Add a generic synchronous exception injection primitive
      KVM: arm64: Handle FEAT_IDST for sysregs without specific handlers
      KVM: arm64: Handle CSSIDR2_EL1 and SMIDR_EL1 in a generic way
      KVM: arm64: Force trap of GMID_EL1 when the guest doesn't have MTE
      KVM: arm64: pkvm: Add a generic synchronous exception injection primitive
      KVM: arm64: pkvm: Report optional ID register traps with a 0x18 syndrome
      KVM: arm64: selftests: Add a test for FEAT_IDST
      KVM: arm64: Always populate FGT masks at boot time
      arm64: Unconditionally enable LSE support
      arm64: Unconditionally enable PAN support
      KVM: arm64: Add exit to userspace on {LD,ST}64B* outside of memslots
      KVM: arm64: Add documentation for KVM_EXIT_ARM_LDST64B
      Merge branch arm64/for-next/cpufeature into kvmarm-master/next
      Merge branch kvm-arm64/vtcr into kvmarm-master/next
      Merge branch kvm-arm64/selftests-6.20 into kvmarm-master/next
      Merge branch kvm-arm64/feat_idst into kvmarm-master/next
      Merge branch kvm-arm64/pkvm-features-6.20 into kvmarm-master/next
      arm64: Add MT_S2{,_FWB}_AS_S1 encodings
      KVM: arm64: Add KVM_PGTABLE_S2_AS_S1 flag
      KVM: arm64: Switch pKVM host S2 over to KVM_PGTABLE_S2_AS_S1
      KVM: arm64: Kill KVM_PGTABLE_S2_NOFWB
      KVM: arm64: Simplify PAGE_S2_MEMATTR
      arm64: Convert SCTLR_EL2 to sysreg infrastructure
      KVM: arm64: Remove duplicate configuration for SCTLR_EL1.{EE,E0E}
      KVM: arm64: Introduce standalone FGU computing primitive
      KVM: arm64: Introduce data structure tracking both RES0 and RES1 bits
      KVM: arm64: Extend unified RESx handling to runtime sanitisation
      KVM: arm64: Inherit RESx bits from FGT register descriptors
      KVM: arm64: Allow RES1 bits to be inferred from configuration
      KVM: arm64: Correctly handle SCTLR_EL1 RES1 bits for unsupported features
      KVM: arm64: Convert HCR_EL2.RW to AS_RES1
      KVM: arm64: Simplify FIXED_VALUE handling
      KVM: arm64: Add REQUIRES_E2H1 constraint as configuration flags
      KVM: arm64: Add RES1_WHEN_E2Hx constraints as configuration flags
      KVM: arm64: Move RESx into individual register descriptors
      KVM: arm64: Simplify handling of HCR_EL2.E2H RESx
      KVM: arm64: Get rid of FIXED_VALUE altogether
      KVM: arm64: Simplify handling of full register invalid constraint
      KVM: arm64: Remove all traces of FEAT_TME
      KVM: arm64: Remove all traces of HCR_EL2.MIOCNCE
      KVM: arm64: Add sanitisation to SCTLR_EL2
      KVM: arm64: Add debugfs file dumping computed RESx values
      Merge branch kvm-arm64/pkvm-no-mte into kvmarm-master/next
      Merge branch kvm-arm64/fwb-for-all into kvmarm-master/next
      Merge branch kvm-arm64/gicv3-tdir-fixes into kvmarm-master/next
      Merge branch kvm-arm64/gicv5-prologue into kvmarm-master/next
      Merge branch kvm-arm64/debugfs-fixes into kvmarm-master/next
      Merge branch kvm-arm64/resx into kvmarm-master/next
      Merge branch kvm-arm64/misc-6.20 into kvmarm-master/next

Mark Rutland (3):
      KVM: arm64: Fix comment in fpsimd_lazy_switch_to_host()
      KVM: arm64: Shuffle KVM_HOST_DATA_FLAG_* indices
      KVM: arm64: Remove ISB after writing FPEXC32_EL2

Oliver Upton (1):
      KVM: arm64: nv: Respect stage-2 write permssion when setting stage-1 AF

Petteri Kangaslampi (1):
      KVM: arm64: Calculate hyp VA size only once

Sascha Bischoff (7):
      KVM: arm64: gic: Check for vGICv3 when clearing TWI
      KVM: arm64: gic: Enable GICv3 CPUIF trapping on GICv5 hosts if required
      KVM: arm64: Correct test for ICH_HCR_EL2_TDIR cap for GICv5 hosts
      KVM: arm64: gic-v3: Switch vGIC-v3 to use generated ICH_VMCR_EL2
      arm64/sysreg: Drop ICH_HFGRTR_EL2.ICC_HAPR_EL1 and make RES1
      KVM: arm64: gic: Set vgic_model before initing private IRQs
      irqchip/gic-v5: Check if impl is virt capable

Will Deacon (1):
      KVM: arm64: Invert KVM_PGTABLE_WALK_HANDLE_FAULT to fix pKVM walkers

Yicong Yang (4):
      KVM: arm64: Handle DABT caused by LS64* instructions on unsupported memory
      arm64: Provide basic EL2 setup for FEAT_{LS64, LS64_V} usage at EL0/1
      KVM: arm64: Enable FEAT_{LS64, LS64_V} in the supported guest
      arm64: Add support for FEAT_{LS64, LS64_V}

Zenghui Yu (Huawei) (3):
      KVM: arm64: nv: Return correct RES0 bits for FGT registers
      KVM: arm64: nv: Add trap config for DBGWCR<15>_EL1
      KVM: arm64: Fix various comments

 Documentation/arch/arm64/booting.rst               |  12 +
 Documentation/arch/arm64/elf_hwcaps.rst            |   7 +
 Documentation/virt/kvm/api.rst                     |  43 +-
 arch/arm64/Kconfig                                 |  33 --
 arch/arm64/include/asm/cpucaps.h                   |   2 -
 arch/arm64/include/asm/el2_setup.h                 |  13 +-
 arch/arm64/include/asm/esr.h                       |   8 +
 arch/arm64/include/asm/hwcap.h                     |   1 +
 arch/arm64/include/asm/insn.h                      |  23 -
 arch/arm64/include/asm/kvm_arm.h                   |  56 +--
 arch/arm64/include/asm/kvm_emulate.h               |  24 +-
 arch/arm64/include/asm/kvm_host.h                  |  56 ++-
 arch/arm64/include/asm/kvm_mmu.h                   |   3 +-
 arch/arm64/include/asm/kvm_pgtable.h               |  15 +-
 arch/arm64/include/asm/kvm_pkvm.h                  |  32 +-
 arch/arm64/include/asm/lse.h                       |   9 -
 arch/arm64/include/asm/memory.h                    |  11 +-
 arch/arm64/include/asm/pgtable-prot.h              |   4 +-
 arch/arm64/include/asm/sysreg.h                    |  32 +-
 arch/arm64/include/asm/uaccess.h                   |   6 +-
 arch/arm64/include/uapi/asm/hwcap.h                |   1 +
 arch/arm64/kernel/cpufeature.c                     |  42 +-
 arch/arm64/kernel/cpuinfo.c                        |   1 +
 arch/arm64/kernel/head.S                           |   2 +-
 arch/arm64/kernel/proton-pack.c                    |   1 +
 arch/arm64/kvm/arch_timer.c                        |  18 +-
 arch/arm64/kvm/arm.c                               |  64 ++-
 arch/arm64/kvm/at.c                                |  15 +-
 arch/arm64/kvm/config.c                            | 505 +++++++++++++--------
 arch/arm64/kvm/emulate-nested.c                    | 105 +++--
 arch/arm64/kvm/hyp/entry.S                         |   2 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h            |   8 +-
 arch/arm64/kvm/hyp/nvhe/ffa.c                      |   4 +-
 arch/arm64/kvm/hyp/nvhe/hyp-init.S                 |   5 -
 arch/arm64/kvm/hyp/nvhe/hyp-main.c                 |  70 +++
 arch/arm64/kvm/hyp/nvhe/mem_protect.c              |   4 +-
 arch/arm64/kvm/hyp/nvhe/pkvm.c                     |  21 +-
 arch/arm64/kvm/hyp/nvhe/switch.c                   |   2 +-
 arch/arm64/kvm/hyp/nvhe/sys_regs.c                 |  39 +-
 arch/arm64/kvm/hyp/pgtable.c                       |  63 ++-
 arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c           |   2 +-
 arch/arm64/kvm/hyp/vgic-v3-sr.c                    |  69 +--
 arch/arm64/kvm/hyp/vhe/switch.c                    |   2 +-
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c                 |   2 +-
 arch/arm64/kvm/inject_fault.c                      |  46 +-
 arch/arm64/kvm/mmio.c                              |  27 +-
 arch/arm64/kvm/mmu.c                               |  58 +--
 arch/arm64/kvm/nested.c                            | 172 +++----
 arch/arm64/kvm/sys_regs.c                          | 127 ++++--
 arch/arm64/kvm/sys_regs.h                          |  10 +
 arch/arm64/kvm/va_layout.c                         |  33 +-
 arch/arm64/kvm/vgic/vgic-debug.c                   | 108 ++---
 arch/arm64/kvm/vgic/vgic-init.c                    |   8 +-
 arch/arm64/kvm/vgic/vgic-v3-nested.c               |  10 +-
 arch/arm64/kvm/vgic/vgic-v3.c                      |  73 +--
 arch/arm64/kvm/vgic/vgic-v5.c                      |   2 +
 arch/arm64/kvm/vgic/vgic.h                         |   1 +
 arch/arm64/lib/insn.c                              |   2 -
 arch/arm64/net/bpf_jit_comp.c                      |   7 -
 arch/arm64/tools/cpucaps                           |   2 +
 arch/arm64/tools/sysreg                            | 154 ++++++-
 drivers/irqchip/irq-gic-v5-irs.c                   |   2 +
 drivers/irqchip/irq-gic-v5.c                       |  10 +
 include/kvm/arm_vgic.h                             |   4 -
 include/linux/irqchip/arm-gic-v5.h                 |   4 +
 include/uapi/linux/kvm.h                           |   3 +-
 tools/arch/arm64/include/asm/sysreg.h              |   6 -
 tools/perf/Documentation/perf-arm-spe.txt          |   1 -
 tools/testing/selftests/kvm/Makefile.kvm           |   1 +
 tools/testing/selftests/kvm/arm64/idreg-idst.c     | 117 +++++
 tools/testing/selftests/kvm/arm64/set_id_regs.c    |   1 -
 .../selftests/kvm/include/arm64/processor.h        |   4 +
 tools/testing/selftests/kvm/include/kvm_util.h     |   9 +-
 tools/testing/selftests/kvm/lib/arm64/processor.c  |   9 +-
 tools/testing/selftests/kvm/lib/kvm_util.c         |   2 +-
 tools/testing/selftests/kvm/lib/riscv/processor.c  |   7 +-
 76 files changed, 1538 insertions(+), 919 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/arm64/idreg-idst.c

