Return-Path: <kvm+bounces-57930-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 065AEB81EDD
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 23:21:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AA3D91894712
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 21:21:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7551302159;
	Wed, 17 Sep 2025 21:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="S/a30xtA"
X-Original-To: kvm@vger.kernel.org
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50246231A30
	for <kvm@vger.kernel.org>; Wed, 17 Sep 2025 21:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758144061; cv=none; b=PYqeAEh1PTK+lMY2MDI4Wam9POILhocYuyCN3gtBjwAhdA6N/VcrCQAmjM4oaDJfADQsNcQ3J5Nbeb2SvXhk3zBYhaeFX1kfrIawO0Udhw12HYw1JvGKHxKMRT6M7KRHXKaRRHdhJBkKP5MYszHsMmtbcMIL8qgdNXNQbqnPEFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758144061; c=relaxed/simple;
	bh=C6JBU8UQ0J+TDyHKdV4+fcg6PQSDJYVvr3xClRwx3Vw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pSS35zMhCfxTAP6FPnHh39ZsElGFEPTb8wbGC09BoR2xv1dFKc7TtiJI2RXSJ955P/wNFamnv/Vkmj/jp8Qi8i6hqHSzW6+p75wmJDvDiGX37njtmzLkg5ByqYallkuHp1+ycjVgMVq7scyQQlIen8J6BtKDMfjCRUo/AzqJqIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=S/a30xtA; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758144057;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=pd1fhLL+GVsRg46oAn3Js7dlB2NaSHd/8Rv1J0NuXKs=;
	b=S/a30xtARsCmkTyo3bGBxURya23Qgz70j2RC/jO311BRlsh3Bz3MCqREH3mRVBuICGhHS1
	c/aYXmH0aHL4Fs0QG7RJ+rOGpPg/Kpr+rXSkiKWBQQpVwLgJ57FkLzL3H3X11oYTipH6rp
	KrWZ7DYDVD8SGu+HYwfSbSWqBOIq/nQ=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 00/13] KVM: arm64: selftests: Run selftests in VHE EL2
Date: Wed, 17 Sep 2025 14:20:30 -0700
Message-ID: <20250917212044.294760-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

I've been working on some MMU-related features that are unused by KVM
meaning they're somewhat annoying to test. Because of that, I found the
time / patience to port our existing selftests infrastructure over to
running in VHE EL2, opportunistically promoting tests when the stars
align.

Creating a VGIC is a hard requirement of enabling EL2 for a VM. As a
consequence of this, I need to eat my words from my earlier conversation
with Sean on this topic and hammer in a default VGICv3. This requires
some participation from the arch-neutral code given the ordering
constraints on vCPU and VGIC creation.

At the tail end of this series is a sanity test for EL2 but nothing is
actually running nested (yet). Despite that, running in EL2 has proven
valuable already as it has uncovered a bug [*].

This is all _very_ lightly tested on an M2 :) Applies to 6.17-rc4

[*]: https://lore.kernel.org/kvmarm/20250917203125.283116-1-oliver.upton@linux.dev/

Oliver Upton (13):
  KVM: arm64: selftests: Provide kvm_arch_vm_post_create() in library
    code
  KVM: arm64: selftests: Initialize VGICv3 only once
  KVM: arm64: selftests: Add helper to check for VGICv3 support
  KVM: arm64: selftests: Add unsanitised helpers for VGICv3 creation
  KVM: arm64: selftests: Create a VGICv3 for 'default' VMs
  KVM: arm64: selftests: Alias EL1 registers to EL2 counterparts
  KVM: arm64: selftests: Provide helper for getting default vCPU target
  KVM: arm64: selftests: Select SMCCC conduit based on current EL
  KVM: arm64: selftests: Use hyp timer IRQs when test runs at EL2
  KVM: arm64: selftests: Use the vCPU attr for setting nr of PMU
    counters
  KVM: arm64: selftests: Initialize HCR_EL2
  KVM: arm64: selftests: Enable EL2 by default
  KVM: arm64: selftests: Add basic test for running in VHE EL2

 tools/testing/selftests/kvm/Makefile.kvm      |  1 +
 .../testing/selftests/kvm/arm64/arch_timer.c  | 13 +--
 .../kvm/arm64/arch_timer_edge_cases.c         | 13 +--
 tools/testing/selftests/kvm/arm64/hello_el2.c | 58 ++++++++++++
 .../testing/selftests/kvm/arm64/hypercalls.c  |  2 +-
 tools/testing/selftests/kvm/arm64/kvm-uuid.c  |  2 +-
 .../testing/selftests/kvm/arm64/no-vgic-v3.c  |  2 +
 tools/testing/selftests/kvm/arm64/psci_test.c | 13 +--
 .../testing/selftests/kvm/arm64/set_id_regs.c | 20 ++--
 .../selftests/kvm/arm64/smccc_filter.c        | 17 +++-
 tools/testing/selftests/kvm/arm64/vgic_init.c |  2 +
 tools/testing/selftests/kvm/arm64/vgic_irq.c  |  4 +-
 .../selftests/kvm/arm64/vgic_lpi_stress.c     |  8 +-
 .../selftests/kvm/arm64/vpmu_counter_access.c | 75 +++++++--------
 .../selftests/kvm/dirty_log_perf_test.c       | 35 -------
 tools/testing/selftests/kvm/dirty_log_test.c  |  1 +
 tools/testing/selftests/kvm/get-reg-list.c    |  9 +-
 .../selftests/kvm/include/arm64/arch_timer.h  | 24 +++++
 .../kvm/include/arm64/kvm_util_arch.h         |  5 +-
 .../selftests/kvm/include/arm64/processor.h   | 73 +++++++++++++++
 .../selftests/kvm/include/arm64/vgic.h        |  3 +
 .../testing/selftests/kvm/include/kvm_util.h  |  7 +-
 .../selftests/kvm/lib/arm64/processor.c       | 91 ++++++++++++++++---
 tools/testing/selftests/kvm/lib/arm64/vgic.c  | 64 +++++++++----
 tools/testing/selftests/kvm/lib/kvm_util.c    | 15 ++-
 .../testing/selftests/kvm/lib/x86/processor.c |  2 +-
 tools/testing/selftests/kvm/s390/cmma_test.c  |  2 +-
 tools/testing/selftests/kvm/steal_time.c      |  2 +-
 28 files changed, 395 insertions(+), 168 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/arm64/hello_el2.c


base-commit: b320789d6883cc00ac78ce83bccbfe7ed58afcf0
-- 
2.47.3


