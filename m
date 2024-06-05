Return-Path: <kvm+bounces-18849-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AE8DC8FC48F
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 09:28:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5BF43285A7B
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 07:28:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7086D1922E7;
	Wed,  5 Jun 2024 07:28:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sWXaXjIa"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9491E1922D7;
	Wed,  5 Jun 2024 07:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717572499; cv=none; b=hp2wt4ulsffSkbqyGcIu++WVDQErkkqR1Cjakm5vN21szzAFRsFgK7BJS+1QVbCYWMLudXs0q49RAI8+eDfmqDqou/5IqnceJd6Ew+iQhkbIqEiGvSqBJx/rylIQHJoSHkfL8++17AneOnU+527qRBzsiOHUdEJgE9WS6MtOF2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717572499; c=relaxed/simple;
	bh=VDWaPe6jIhISipwILh3CKrMhwSHXzHUPVWVJ6g5hdkc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=SR3hIkr0RNPce/xbTSm7lyM0Fubq9gnoTMVN7j4jmLdz7wT6lLGt4tza0twJK5qX/eXpU2jI6ERYe1uGV80bkGRrbPZ22TxBly6u7fq6t4DD80WvvREyMRYDSwX7FubEO72UeMgapvNJUbF8ASt0NCX9sW2WEtGijnlkTcnRT6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sWXaXjIa; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D647C3277B;
	Wed,  5 Jun 2024 07:28:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717572499;
	bh=VDWaPe6jIhISipwILh3CKrMhwSHXzHUPVWVJ6g5hdkc=;
	h=From:To:Cc:Subject:Date:From;
	b=sWXaXjIavZKQUqRyDIy89bFWtJnv7GcdkwzYtb5+CacYataVZ8woCrSrU8vy+C74E
	 KvUHhR2TvbsleAXUENV/QaDSp8n+MaxPr3a/X5SVefn76F1PCE0nr04YdNPtG34ooJ
	 VPd3gZDVPxR8f5e3m0iMq95vTmRahmT+5JRty3Q7C8QWhx4kHA1SDgGKFMgHS8r0rY
	 qX3ANPuknB1AnFy01z60ihAucAGh/r2fWMOW0Pb010g+V8rRen6yH4C49zeycSXnbY
	 pbkfaIlbKfvgDtjkrhZgsLTMPuv7DAtSTcfXNVaMHkooDx1vqChM5Kl2+kTcGBfGrs
	 WCf+HrYlFmy4g==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sEl4C-000pgW-Ie;
	Wed, 05 Jun 2024 08:28:16 +0100
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Fuad Tabba <tabba@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Subject: [GIT PULL] KVM/arm64 fixes for 6.10, take #1
Date: Wed,  5 Jun 2024 08:28:08 +0100
Message-Id: <20240605072808.1039636-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, tabba@google.com, joey.gouly@arm.com, broonie@kernel.org, nsg@linux.ibm.com, oliver.upton@linux.dev, james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Paolo,

Here's a large-ish set of fixes for 6.10, the bulk of it addressing
the sorry state of pKVM's handling of FP/SVE (kudos to Fuad for sticking
with it and getting the series in shape).

The rest is a more esoteric set of AArch32 and NV fixes, details in the
tag as usual.

Please pull,

        M.

The following changes since commit 1613e604df0cd359cf2a7fbd9be7a0bcfacfabd0:

  Linux 6.10-rc1 (2024-05-26 15:20:12 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-6.10-1

for you to fetch changes up to afb91f5f8ad7af172d993a34fde1947892408f53:

  KVM: arm64: Ensure that SME controls are disabled in protected mode (2024-06-04 15:06:33 +0100)

----------------------------------------------------------------
KVM/arm64 fixes for 6.10, take #1

- Large set of FP/SVE fixes for pKVM, addressing the fallout
  from the per-CPU data rework and making sure that the host
  is not involved in the FP/SVE switching any more

- Allow FEAT_BTI to be enabled with NV now that FEAT_PAUTH
  is copletely supported

- Fix for the respective priorities of Failed PAC, Illegal
  Execution state and Instruction Abort exceptions

- Fix the handling of AArch32 instruction traps failing their
  condition code, which was broken by the introduction of
  ESR_EL2.ISS2

- Allow vpcus running in AArch32 state to be restored in
  System mode

- Fix AArch32 GPR restore that would lose the 64 bit state
  under some conditions

----------------------------------------------------------------
Fuad Tabba (9):
      KVM: arm64: Reintroduce __sve_save_state
      KVM: arm64: Fix prototype for __sve_save_state/__sve_restore_state
      KVM: arm64: Abstract set/clear of CPTR_EL2 bits behind helper
      KVM: arm64: Specialize handling of host fpsimd state on trap
      KVM: arm64: Allocate memory mapped at hyp for host sve state in pKVM
      KVM: arm64: Eagerly restore host fpsimd/sve state in pKVM
      KVM: arm64: Consolidate initializing the host data's fpsimd_state/sve in pKVM
      KVM: arm64: Refactor CPACR trap bit setting/clearing to use ELx format
      KVM: arm64: Ensure that SME controls are disabled in protected mode

Marc Zyngier (5):
      KVM: arm64: Fix AArch32 register narrowing on userspace write
      KVM: arm64: Allow AArch32 PSTATE.M to be restored as System mode
      KVM: arm64: AArch32: Fix spurious trapping of conditional instructions
      KVM: arm64: nv: Fix relative priorities of exceptions generated by ERETAx
      KVM: arm64: nv: Expose BTI and CSV_frac to a guest hypervisor

 arch/arm64/include/asm/el2_setup.h      |  6 +--
 arch/arm64/include/asm/kvm_arm.h        |  6 +++
 arch/arm64/include/asm/kvm_emulate.h    | 71 ++++++++++++++++++++++++++--
 arch/arm64/include/asm/kvm_host.h       | 25 +++++++++-
 arch/arm64/include/asm/kvm_hyp.h        |  4 +-
 arch/arm64/include/asm/kvm_pkvm.h       |  9 ++++
 arch/arm64/kvm/arm.c                    | 76 +++++++++++++++++++++++++++++
 arch/arm64/kvm/emulate-nested.c         | 21 +++++----
 arch/arm64/kvm/fpsimd.c                 | 11 +++--
 arch/arm64/kvm/guest.c                  |  3 +-
 arch/arm64/kvm/hyp/aarch32.c            | 18 ++++++-
 arch/arm64/kvm/hyp/fpsimd.S             |  6 +++
 arch/arm64/kvm/hyp/include/hyp/switch.h | 36 +++++++-------
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h  |  1 -
 arch/arm64/kvm/hyp/nvhe/hyp-main.c      | 84 +++++++++++++++++++++++++++++----
 arch/arm64/kvm/hyp/nvhe/pkvm.c          | 17 ++-----
 arch/arm64/kvm/hyp/nvhe/setup.c         | 25 +++++++++-
 arch/arm64/kvm/hyp/nvhe/switch.c        | 24 ++++++++--
 arch/arm64/kvm/hyp/vhe/switch.c         | 12 +++--
 arch/arm64/kvm/nested.c                 |  6 ++-
 arch/arm64/kvm/reset.c                  |  3 ++
 21 files changed, 391 insertions(+), 73 deletions(-)

