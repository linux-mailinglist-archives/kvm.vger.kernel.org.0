Return-Path: <kvm+bounces-49980-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 171E9AE066B
	for <lists+kvm@lfdr.de>; Thu, 19 Jun 2025 15:01:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4F0B2189163B
	for <lists+kvm@lfdr.de>; Thu, 19 Jun 2025 13:01:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFBF323E35B;
	Thu, 19 Jun 2025 13:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kMa7OvsJ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E66012B94;
	Thu, 19 Jun 2025 13:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750338073; cv=none; b=EG1EVvSP7Hyjo6cYRqs8aH0XM83LkRnuIz0x7vwZAFdPcUC5T1AKZyNvDbcipBiXIO0XMWL9Pv3SMyRCtR1TgZpv2TSZ4Ft0Fp6t2m/7e6uw/zZnkidQoHXPgiy1T7DFJ+D2ZE5Rmfh9eLVya948DwJG5YOO3+7Sqihi8FgMpD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750338073; c=relaxed/simple;
	bh=/kE+YFpl0J9ThQUvmELPjh8cJ/+9gC716KmHUlheWRU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=mpUpJxwad5EzhDUQSW5iGnMzx0L22LhjluxGrSNByKClAp0VIfW2mbg3OdjpzsnN8ZEBl3S7bP1b4Xx1eK3bFIlnzIgjS7dKF8Fzp2IFJecEEXL4kFEZImvm5xvnvpxkfc3Q3+tPKwkJyRLN52QFSE4IlH+CcCAHyRU9z6hndd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kMa7OvsJ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DAF3C4CEEA;
	Thu, 19 Jun 2025 13:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750338072;
	bh=/kE+YFpl0J9ThQUvmELPjh8cJ/+9gC716KmHUlheWRU=;
	h=From:To:Cc:Subject:Date:From;
	b=kMa7OvsJYPpiI18LMM7gfqrPAVBmJ9s4dXxtORIasVECRmDh6RULdsK+Bwc2oVQWG
	 t6i1DTJFn+6CD7ktY4HGc9rOHW05ih3ofAYbuCZEe1GdPOmqASK4AX1FDVNjDMI4k+
	 0BV+Rc7hIYgmCH3F7Cq2LcSxphJz5J2uJ443Pa6qxIxVlL6nDO8/73/Cp+fk6Dvfm3
	 VcLVWoT5g9ZRQ3rBeeKkkB8zAb3iK9V6Qx5Qp3/uJ2yF4cUxsJ88JxZYOhMJ9q7sOj
	 leVn0OeIhztcC77Itmtl8qnOELWcEoaM07yV8ZMRsh2vJPoFmIvOf1BTsAwJq7oVJa
	 c0DkbXPTXdBdw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1uSEtC-008G3W-Dh;
	Thu, 19 Jun 2025 14:01:10 +0100
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Mark Brown <broonie@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Miguel Luis <miguel.luis@oracle.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Sean Christopherson <seanjc@google.com>,
	Sebastian Ott <sebott@redhat.com>,
	Wei-Lin Chang <r09922117@csie.ntu.edu.tw>,
	Will Deacon <will@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Subject: [GIT PULL] KVM/arm64 fixes, take #3
Date: Thu, 19 Jun 2025 14:00:49 +0100
Message-Id: <20250619130049.3133524-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, catalin.marinas@arm.com, tabba@google.com, broonie@kernel.org, mark.rutland@arm.com, miguel.luis@oracle.com, oliver.upton@linux.dev, seanjc@google.com, sebott@redhat.com, r09922117@csie.ntu.edu.tw, will@kernel.org, yuzenghui@huawei.com, joey.gouly@arm.com, suzuki.poulose@arm.com, kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Paolo,

Here's the third set of KVM/arm64 fixes for 6.16. The most notable
thing is yet another batch of FP/SVE fixes from Mark, this time
addressing NV, and additionally plugging some missing synchronisation.
The rest is a mix of interrupt stuff (routing change, mishandling of
shadow LRs) and selftest fixes.

Please pull,

	M.

The following changes since commit e04c78d86a9699d136910cfc0bdcf01087e3267e:

  Linux 6.16-rc2 (2025-06-15 13:49:41 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-6.16-3

for you to fetch changes up to 04c5355b2a94ff3191ce63ab035fb7f04d036869:

  KVM: arm64: VHE: Centralize ISBs when returning to host (2025-06-19 13:34:59 +0100)

----------------------------------------------------------------
KVM/arm64 fixes for 6.16, take #3

- Fix another set of FP/SIMD/SVE bugs affecting NV, and plugging some
  missing synchronisation

- A small fix for the irqbypass hook fixes, tightening the check and
  ensuring that we only deal with MSI for both the old and the new
  route entry

- Rework the way the shadow LRs are addressed in a nesting
  configuration, plugging an embarrassing bug as well as simplifying
  the whole process

- Add yet another fix for the dreaded arch_timer_edge_cases selftest

----------------------------------------------------------------
Marc Zyngier (1):
      KVM: arm64: nv: Fix tracking of shadow list registers

Mark Rutland (7):
      KVM: arm64: VHE: Synchronize restore of host debug registers
      KVM: arm64: VHE: Synchronize CPTR trap deactivation
      KVM: arm64: Reorganise CPTR trap manipulation
      KVM: arm64: Remove ad-hoc CPTR manipulation from fpsimd_sve_sync()
      KVM: arm64: Remove ad-hoc CPTR manipulation from kvm_hyp_handle_fpsimd()
      KVM: arm64: Remove cpacr_clear_set()
      KVM: arm64: VHE: Centralize ISBs when returning to host

Sean Christopherson (1):
      KVM: arm64: Explicitly treat routing entry type changes as changes

Zenghui Yu (1):
      KVM: arm64: selftests: Close the GIC FD in arch_timer_edge_cases

 arch/arm64/include/asm/kvm_emulate.h               |  62 ---------
 arch/arm64/include/asm/kvm_host.h                  |   6 +-
 arch/arm64/kvm/arm.c                               |   3 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h            | 147 +++++++++++++++++++--
 arch/arm64/kvm/hyp/nvhe/hyp-main.c                 |   5 +-
 arch/arm64/kvm/hyp/nvhe/switch.c                   |  59 ---------
 arch/arm64/kvm/hyp/vhe/switch.c                    | 107 ++-------------
 arch/arm64/kvm/vgic/vgic-v3-nested.c               |  81 ++++++------
 .../selftests/kvm/arm64/arch_timer_edge_cases.c    |  16 ++-
 9 files changed, 215 insertions(+), 271 deletions(-)

