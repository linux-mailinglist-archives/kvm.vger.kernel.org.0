Return-Path: <kvm+bounces-26941-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A1389794D9
	for <lists+kvm@lfdr.de>; Sun, 15 Sep 2024 08:46:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7EE881C20D45
	for <lists+kvm@lfdr.de>; Sun, 15 Sep 2024 06:46:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3BD32110E;
	Sun, 15 Sep 2024 06:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fNTu34NF"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B937EA92F
	for <kvm@vger.kernel.org>; Sun, 15 Sep 2024 06:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726382790; cv=none; b=HhJh8cX2bz97qB/4I7Hg4/MxkGtvrhxYKdKli1IWGawrBy5iFO/L0TIdpwkn+DtEK9dxT2oYooRqERMoqTU4VnQiN5nG7Qag3LMlfDvBmzXV6nXi+qHH+sX0dVUGq3ovGdaRsnKt7Y6Q1LTq8SSO7mstvejiWSzQv7aJX3Om8YE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726382790; c=relaxed/simple;
	bh=EHwV3Yvy7Uw3IF/j+DoDcJc+ZAhxWe5YCmrRnJgDsNk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Q5XV27Wde6THPbojwJPw3UFlza3+tYA3JbPuVO2AT5mhKtIZG/yY5Pj2l7IIpn+fLJHcx+v5VhLl88sg+3PGjFOjCBuBBJ9F9ziTjveQ0vSIcoFsj29lOWMJ4oGUUJ5zFzQKSymFY2v+/RbInskvkA/ZfnTlkxXUGydnFTY5eA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fNTu34NF; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1726382787;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=FiU6udXM9eCpZXE02YwzMsgBu5oQJjGB+q0lwtk1vYM=;
	b=fNTu34NF+HZXR4VyXURsFCiSwI8Gbi0c0r36Gsxw2hmVi7sCsEzv3S6ukLTAeXtHnOlZsh
	jW+mScufkbiUehYDGxrdRrrAodEKde0iW0QcaFqVWiEANMfbSaIGCSBL+9oCBLtkHzLalU
	FpdLh51XLwVNkc0eeWYBhVxzqCHfjuA=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-628-Ii7YeiwgNXui0WXzVmtkUA-1; Sun,
 15 Sep 2024 02:46:24 -0400
X-MC-Unique: Ii7YeiwgNXui0WXzVmtkUA-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EDAE81956077;
	Sun, 15 Sep 2024 06:46:22 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 5003C30001AB;
	Sun, 15 Sep 2024 06:46:22 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [GIT PULL] First batch of KVM changes for Linux 6.12
Date: Sun, 15 Sep 2024 02:46:21 -0400
Message-ID: <20240915064621.5268-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Linus,

The following changes since commit da3ea35007d0af457a0afc87e84fddaebc4e0b63:

  Linux 6.11-rc7 (2024-09-08 14:50:28 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus-non-x86

for you to fetch changes up to 0cdcc99eeaedf2422c80d75760293fdbb476cec1:

  Merge tag 'kvm-riscv-6.12-1' of https://github.com/kvm-riscv/linux into HEAD (2024-09-15 02:43:17 -0400)

These are the non-x86 changes (mostly ARM, as is usually the case).
The generic and x86 changes will come later, in the meanwhile
here is what's ready in case it helps you intersecting the
travelling and pulling schedule.  There is a trivial conflict in
arch/arm64/include/asm/kvm_host.h with the arm64 tree.

I'll also send a revert for 6.11 in a few minutes.

Thanks,

Paolo

----------------------------------------------------------------
ARM:

* New Stage-2 page table dumper, reusing the main ptdump infrastructure

* FP8 support

* Nested virtualization now supports the address translation (FEAT_ATS1A)
  family of instructions

* Add selftest checks for a bunch of timer emulation corner cases

* Fix multiple cases where KVM/arm64 doesn't correctly handle the guest
  trying to use a GICv3 that wasn't advertised

* Remove REG_HIDDEN_USER from the sysreg infrastructure, making
  things little simpler

* Prevent MTE tags being restored by userspace if we are actively
  logging writes, as that's a recipe for disaster

* Correct the refcount on a page that is not considered for MTE tag
  copying (such as a device)

* When walking a page table to split block mappings, synchronize only
  at the end the walk rather than on every store

* Fix boundary check when transfering memory using FFA

* Fix pKVM TLB invalidation, only affecting currently out of tree
  code but worth addressing for peace of mind

LoongArch:

* Revert qspinlock to test-and-set simple lock on VM.

* Add Loongson Binary Translation extension support.

* Add PMU support for guest.

* Enable paravirt feature control from VMM.

* Implement function kvm_para_has_feature().

RISC-V:

* Fix sbiret init before forwarding to userspace

* Don't zero-out PMU snapshot area before freeing data

* Allow legacy PMU access from guest

* Fix to allow hpmcounter31 from the guest

----------------------------------------------------------------
Andrew Jones (1):
      RISC-V: KVM: Fix sbiret init before forwarding to userspace

Anup Patel (1):
      RISC-V: KVM: Don't zero-out PMU snapshot area before freeing data

Atish Patra (2):
      RISC-V: KVM: Allow legacy PMU access from guest
      RISC-V: KVM: Fix to allow hpmcounter31 from the guest

Bibo Mao (6):
      LoongArch: Revert qspinlock to test-and-set simple lock on VM
      LoongArch: KVM: Add VM feature detection function
      LoongArch: KVM: Add Binary Translation extension support
      LoongArch: KVM: Add vm migration support for LBT registers
      LoongArch: KVM: Enable paravirt feature control from VMM
      LoongArch: KVM: Implement function kvm_para_has_feature()

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

Paolo Bonzini (3):
      Merge tag 'kvmarm-6.12' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD
      Merge tag 'loongarch-kvm-6.12' of git://git.kernel.org/pub/scm/linux/kernel/git/chenhuacai/linux-loongson into HEAD
      Merge tag 'kvm-riscv-6.12-1' of https://github.com/kvm-riscv/linux into HEAD

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

Song Gao (1):
      LoongArch: KVM: Add PMU support for guest

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
 arch/arm64/kvm/sys_regs.c                          |  384 ++++---
 arch/arm64/kvm/sys_regs.h                          |   23 +-
 arch/arm64/kvm/vgic/vgic-v3.c                      |   12 +
 arch/arm64/kvm/vgic/vgic.c                         |   14 +-
 arch/arm64/kvm/vgic/vgic.h                         |    6 +-
 arch/arm64/mm/ptdump.c                             |   70 +-
 arch/loongarch/include/asm/Kbuild                  |    1 -
 arch/loongarch/include/asm/kvm_csr.h               |    6 +
 arch/loongarch/include/asm/kvm_host.h              |   37 +-
 arch/loongarch/include/asm/kvm_para.h              |   12 +
 arch/loongarch/include/asm/kvm_vcpu.h              |   11 +
 arch/loongarch/include/asm/loongarch.h             |   11 +-
 arch/loongarch/include/asm/paravirt.h              |    7 +
 arch/loongarch/include/asm/qspinlock.h             |   41 +
 arch/loongarch/include/uapi/asm/Kbuild             |    2 -
 arch/loongarch/include/uapi/asm/kvm.h              |   20 +
 arch/loongarch/include/uapi/asm/kvm_para.h         |   21 +
 arch/loongarch/kernel/paravirt.c                   |   47 +-
 arch/loongarch/kernel/setup.c                      |    2 +
 arch/loongarch/kernel/smp.c                        |    4 +-
 arch/loongarch/kvm/exit.c                          |   46 +-
 arch/loongarch/kvm/vcpu.c                          |  340 +++++-
 arch/loongarch/kvm/vm.c                            |   69 +-
 arch/riscv/include/asm/kvm_vcpu_pmu.h              |   21 +-
 arch/riscv/kvm/vcpu_pmu.c                          |   14 +-
 arch/riscv/kvm/vcpu_sbi.c                          |    4 +-
 tools/testing/selftests/kvm/Makefile               |    2 +
 .../selftests/kvm/aarch64/arch_timer_edge_cases.c  | 1062 +++++++++++++++++++
 tools/testing/selftests/kvm/aarch64/no-vgic-v3.c   |  175 ++++
 tools/testing/selftests/kvm/aarch64/set_id_regs.c  |    1 +
 tools/testing/selftests/kvm/aarch64/vgic_irq.c     |   11 +-
 .../selftests/kvm/include/aarch64/arch_timer.h     |   18 +-
 .../selftests/kvm/include/aarch64/processor.h      |    3 +
 .../testing/selftests/kvm/lib/aarch64/processor.c  |    6 +
 63 files changed, 4041 insertions(+), 409 deletions(-)
 create mode 100644 arch/arm64/kvm/at.c
 create mode 100644 arch/arm64/kvm/ptdump.c
 create mode 100644 arch/loongarch/include/asm/qspinlock.h
 create mode 100644 arch/loongarch/include/uapi/asm/kvm_para.h
 create mode 100644 tools/testing/selftests/kvm/aarch64/arch_timer_edge_cases.c
 create mode 100644 tools/testing/selftests/kvm/aarch64/no-vgic-v3.c


