Return-Path: <kvm+bounces-56177-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BF5C6B3AB31
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 22:00:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D19581C23D52
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 20:00:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65ADC27054A;
	Thu, 28 Aug 2025 20:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="RxURjS2G"
X-Original-To: kvm@vger.kernel.org
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5393A41C63
	for <kvm@vger.kernel.org>; Thu, 28 Aug 2025 20:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756411232; cv=none; b=JTLYtImS7YnB9dPZsy1rQZXPRAOahqObbvRNIkfhwXrTinBauT2ZU1yA3crmg89LTVs0fDNdvmIMYjKszMXqjoOw792L5vzodmdW0wbSo9oUYE8ijRLQB4gPPUcXfprl5hVQ4859gjU+kl7l2/4skLqs47XRrW8ZzyZFV1Z5bQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756411232; c=relaxed/simple;
	bh=tKsfb2YuEZ0dz9MbqmMbKjHXrXdz8Mo6Od335EQZ1HI=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=s64guLvS0fSTxGUEwZwCwW530jetvrD0YRleelXzToucZ7u02p/L7wM7k1qI0UWyu+QZTx9qkPejulNUBRdNiHktOEtYDM41zeemUWbnvuRxzcfTMKBARxpqUgEK6iYwVjaMm9W+yefUJQP+udnXcQxS9VmWKyeg7XVBjGXhvus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=RxURjS2G; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 28 Aug 2025 13:00:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1756411217;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=hxquV2sC6Kv6B0G5Tw0QgybL4q781zKIOmwgcT1utY8=;
	b=RxURjS2GQMPTpmEEhpZN807bfF0kQrTq94UM5b4+TwftaUxvH3TCMOl6qUn8tPVo5FhO+L
	JM9bC5Hg+mazdSKsgDT6I/PHCeP/gX49MhRhe2hY5PYc0gwFNwBQIfC4T9QIWxTktl0Zw6
	ShcLvzWDF78Mg3aQn+ynFnfDygQLmso=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: [GIT PULL] KVM/arm64 changes for 6.17, take #2
Message-ID: <aLC1Su7FEo7XtI0K@linux.dev>
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

Unfortunately work had me sidelined for an extended period of time, so
after much delay here is a pile of fixes for 6.17. This is a bit larger
than I would like, but the handling of on-CPU sysregs has had multiple ugly
bugs and a localized fix would just be unnecessary churn.

Details in the tag; please pull.

Thanks,
Oliver

The following changes since commit 18ec25dd0e97653cdb576bb1750c31acf2513ea7:

  KVM: arm64: selftests: Add FEAT_RAS EL2 registers to get-reg-list (2025-07-28 08:28:05 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git/ tags/kvmarm-fixes-6.17-1

for you to fetch changes up to ee372e645178802be7cb35263de941db7b2c5354:

  KVM: arm64: nv: Fix ATS12 handling of single-stage translation (2025-08-28 12:44:42 -0700)

----------------------------------------------------------------
KVM/arm64 changes for 6.17, take #2

 - Correctly handle 'invariant' system registers for protected VMs

 - Improved handling of VNCR data aborts, including external aborts

 - Fixes for handling of FEAT_RAS for NV guests, providing a sane
   fault context during SEA injection and preventing the use of
   RASv1p1 fault injection hardware

 - Ensure that page table destruction when a VM is destroyed gives an
   opportunity to reschedule

 - Large fix to KVM's infrastructure for managing guest context loaded
   on the CPU, addressing issues where the output of AT emulation
   doesn't get reflected to the guest

 - Fix AT S12 emulation to actually perform stage-2 translation when
   necessary

 - Avoid attempting vLPI irqbypass when GICv4 has been explicitly
   disabled for a VM

 - Minor KVM + selftest fixes

----------------------------------------------------------------
Arnd Bergmann (1):
      kvm: arm64: use BUG() instead of BUG_ON(1)

Fuad Tabba (3):
      KVM: arm64: Handle AIDR_EL1 and REVIDR_EL1 in host for protected VMs
      KVM: arm64: Sync protected guest VBAR_EL1 on injecting an undef exception
      arm64: vgic-v2: Fix guest endianness check in hVHE mode

Marc Zyngier (14):
      KVM: arm64: nv: Properly check ESR_EL2.VNCR on taking a VNCR_EL2 related fault
      KVM: arm64: selftest: Add standalone test checking for KVM's own UUID
      KVM: arm64: Correctly populate FAR_EL2 on nested SEA injection
      arm64: Add capability denoting FEAT_RASv1p1
      KVM: arm64: Handle RASv1p1 registers
      KVM: arm64: Ignore HCR_EL2.FIEN set by L1 guest's EL2
      KVM: arm64: Make ID_AA64PFR0_EL1.RAS writable
      KVM: arm64: Make ID_AA64PFR1_EL1.RAS_frac writable
      KVM: arm64: Get rid of ARM64_FEATURE_MASK()
      KVM: arm64: Check for SYSREGS_ON_CPU before accessing the 32bit state
      KVM: arm64: Simplify sysreg access on exception delivery
      KVM: arm64: Fix vcpu_{read,write}_sys_reg() accessors
      KVM: arm64: Remove __vcpu_{read,write}_sys_reg_{from,to}_cpu()
      KVM: arm64: nv: Fix ATS12 handling of single-stage translation

Mark Brown (1):
      KVM: arm64: selftests: Sync ID_AA64MMFR3_EL1 in set_id_regs

Oliver Upton (1):
      KVM: arm64: nv: Handle SEAs due to VNCR redirection

Raghavendra Rao Ananta (3):
      KVM: arm64: Don't attempt vLPI mappings when vPE allocation is disabled
      KVM: arm64: Split kvm_pgtable_stage2_destroy()
      KVM: arm64: Reschedule as needed when destroying the stage-2 page-tables

 arch/arm64/include/asm/kvm_host.h                  | 111 +-----
 arch/arm64/include/asm/kvm_mmu.h                   |   1 +
 arch/arm64/include/asm/kvm_pgtable.h               |  30 ++
 arch/arm64/include/asm/kvm_pkvm.h                  |   4 +-
 arch/arm64/include/asm/kvm_ras.h                   |  25 --
 arch/arm64/include/asm/sysreg.h                    |   3 -
 arch/arm64/kernel/cpufeature.c                     |  24 ++
 arch/arm64/kvm/arm.c                               |   8 +-
 arch/arm64/kvm/at.c                                |   6 +-
 arch/arm64/kvm/emulate-nested.c                    |   2 +-
 arch/arm64/kvm/hyp/exception.c                     |  20 +-
 arch/arm64/kvm/hyp/nvhe/list_debug.c               |   2 +-
 arch/arm64/kvm/hyp/nvhe/sys_regs.c                 |   5 +
 arch/arm64/kvm/hyp/pgtable.c                       |  25 +-
 arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c           |   2 +-
 arch/arm64/kvm/hyp/vhe/switch.c                    |   5 +-
 arch/arm64/kvm/mmu.c                               |  65 +++-
 arch/arm64/kvm/nested.c                            |   5 +-
 arch/arm64/kvm/pkvm.c                              |  11 +-
 arch/arm64/kvm/sys_regs.c                          | 419 ++++++++++++++-------
 arch/arm64/kvm/vgic/vgic-mmio-v3.c                 |   8 +
 arch/arm64/kvm/vgic/vgic-mmio.c                    |   2 +-
 arch/arm64/kvm/vgic/vgic.h                         |  10 +-
 arch/arm64/tools/cpucaps                           |   1 +
 tools/arch/arm64/include/asm/sysreg.h              |   3 -
 tools/testing/selftests/kvm/Makefile.kvm           |   1 +
 .../testing/selftests/kvm/arm64/aarch32_id_regs.c  |   2 +-
 .../testing/selftests/kvm/arm64/debug-exceptions.c |  12 +-
 tools/testing/selftests/kvm/arm64/kvm-uuid.c       |  70 ++++
 tools/testing/selftests/kvm/arm64/no-vgic-v3.c     |   4 +-
 .../testing/selftests/kvm/arm64/page_fault_test.c  |   6 +-
 tools/testing/selftests/kvm/arm64/set_id_regs.c    |   9 +-
 .../selftests/kvm/arm64/vpmu_counter_access.c      |   2 +-
 tools/testing/selftests/kvm/lib/arm64/processor.c  |   6 +-
 34 files changed, 560 insertions(+), 349 deletions(-)
 delete mode 100644 arch/arm64/include/asm/kvm_ras.h
 create mode 100644 tools/testing/selftests/kvm/arm64/kvm-uuid.c

