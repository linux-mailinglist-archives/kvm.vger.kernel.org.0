Return-Path: <kvm+bounces-42875-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 36C41A7F1A3
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 02:32:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B7C7A174ABF
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 00:32:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1A84288CC;
	Tue,  8 Apr 2025 00:32:28 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A506CAD39
	for <kvm@vger.kernel.org>; Tue,  8 Apr 2025 00:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744072348; cv=none; b=s0mNgmOmx81wdIt9OO2KdcYscCRmiNBESVUY/QowvMoNzTH1BF2shMj5gOirjId7LHcmo8msBB9Frvzxi8RH5oFFUaOjLXECXDmmfKpFzWLDr6sfEJDpMZ+2+4jW4yJMHzhnzhlYOrpN23iIgJRcqy6BmNSmuGUDz6V9MjvJUSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744072348; c=relaxed/simple;
	bh=k0qZyNLY8ZnZaejdK7zNdUB4ts88DmVD2cliAiXr9Ac=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=KVjqZx2RwUpNT60DsU5cnz5chTrfHxAnVrcDGcFboRhjBWz5zhXZpcgpBM+fD/08BLcBkA9UItLhHM+R1STNpoClyfmD8Dr8zMNA+msAphIo7ecfwRLkP6DATYTk6AA44heYeU/7keuV+inBC5fYEc5k5/mTYE7aOG/cz0gdbxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 7 Apr 2025 17:31:40 -0700
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, Raghavendra Rao Ananta <rananta@google.com>,
	Will Deacon <will@kernel.org>
Subject: [GIT PULL] KVM/arm64: First batch of fixes for 6.15
Message-ID: <Z_RubCEp4h7sAdjz@linux.dev>
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

Here's the first set of fixes for 6.15. The biggest change here is the
__get_fault_info() rework where KVM could use stale fault information when
handling a stage-2 abort.

Rest of the details can be found in the tag. Please pull.

Thanks,
Oliver

The following changes since commit 369c0122682c4468a69f2454614eded71c5348f3:

  Merge branch 'kvm-arm64/pmu-fixes' into kvmarm/next (2025-03-19 14:54:52 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git/ tags/kvmarm-fixes-6.15-1

for you to fetch changes up to a344e258acb0a7f0e7ed10a795c52d1baf705164:

  KVM: arm64: Use acquire/release to communicate FF-A version negotiation (2025-04-07 15:03:34 -0700)

----------------------------------------------------------------
KVM/arm64: First batch of fixes for 6.15

 - Rework heuristics for resolving the fault IPA (HPFAR_EL2 v. re-walk
   stage-1 page tables) to align with the architecture. This avoids
   possibly taking an SEA at EL2 on the page table walk or using an
   architecturally UNKNOWN fault IPA.

 - Use acquire/release semantics in the KVM FF-A proxy to avoid reading
   a stale value for the FF-A version.

 - Fix KVM guest driver to match PV CPUID hypercall ABI.

 - Use Inner Shareable Normal Write-Back mappings at stage-1 in KVM
   selftests, which is the only memory type for which atomic
   instructions are architecturally guaranteed to work.

----------------------------------------------------------------
Chen Ni (1):
      smccc: kvm_guest: Remove unneeded semicolon

Oliver Upton (4):
      smccc: kvm_guest: Align with DISCOVER_IMPL_CPUS ABI
      KVM: arm64: Only read HPFAR_EL2 when value is architecturally valid
      arm64: Convert HPFAR_EL2 to sysreg table
      KVM: arm64: Don't translate FAR if invalid/unsafe

Raghavendra Rao Ananta (2):
      KVM: arm64: selftests: Introduce and use hardware-definition macros
      KVM: arm64: selftests: Explicitly set the page attrs to Inner-Shareable

Will Deacon (1):
      KVM: arm64: Use acquire/release to communicate FF-A version negotiation

 arch/arm64/include/asm/esr.h                       | 44 +++++++++++++-
 arch/arm64/include/asm/kvm_emulate.h               |  7 ++-
 arch/arm64/include/asm/kvm_ras.h                   |  2 +-
 arch/arm64/kvm/hyp/include/hyp/fault.h             | 70 +++++++++++++++-------
 arch/arm64/kvm/hyp/nvhe/ffa.c                      |  9 +--
 arch/arm64/kvm/hyp/nvhe/mem_protect.c              |  9 ++-
 arch/arm64/kvm/mmu.c                               | 31 ++++++----
 arch/arm64/tools/sysreg                            |  7 +++
 drivers/firmware/smccc/kvm_guest.c                 |  4 +-
 .../testing/selftests/kvm/arm64/page_fault_test.c  |  2 +-
 .../selftests/kvm/include/arm64/processor.h        | 67 +++++++++++++++++++--
 tools/testing/selftests/kvm/lib/arm64/processor.c  | 60 +++++++++++--------
 12 files changed, 234 insertions(+), 78 deletions(-)

