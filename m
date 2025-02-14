Return-Path: <kvm+bounces-38158-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E8936A35D37
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2025 12:59:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F2547170954
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2025 11:56:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 159D2263C69;
	Fri, 14 Feb 2025 11:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hChw4ib1"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EC45275408;
	Fri, 14 Feb 2025 11:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739534192; cv=none; b=q0YjkuNGV5DqHX7yzY47XvnOCzkK5yE+i/lQ3ybFm3r3R+JjiFiHflFIbJrNp++JKgFPc+wNH+8Ct/KbFTFSYWYHW8FFmEkwJ2kaz29DfefU86fPpvA1VZ2qSFrZGmcqwqXkSDmzgsOLijkpY+lsS6c3s13UEpGNpYAACbcBup8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739534192; c=relaxed/simple;
	bh=G2ROVBu5b+JAdTaOkWugsekPMRCegXPQ+zbKkmapIF8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=IolLAKB6DM6APPS/JCSC5Atytv6jl3lSOCkG1vMeJDhcXdXA2Hr2UFBGWcF34nbExCGhVTHeBEkSxhMBfiC3G4wMpAalk0QdWRJbC09j6U0L2/1lIyfVS5KIJM+s+ofcn5S/ClK321xn+NAbe696bqQqVYilVoAWwOc24B8TFag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hChw4ib1; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B15DC4CED1;
	Fri, 14 Feb 2025 11:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739534191;
	bh=G2ROVBu5b+JAdTaOkWugsekPMRCegXPQ+zbKkmapIF8=;
	h=From:To:Cc:Subject:Date:From;
	b=hChw4ib1wzFjnSheB50wsKRlt0AMG9/OBJve9zorJIKOVo7Z8RtHLK5BOLH3ckyyV
	 BlzKYsmALZSUUaJozET+t8DP5gPwqdju12qywFSOEwrefUGLGOvWhdlS0vZi1yKwbu
	 wXJAJNtQZEuTBbepTu6nofiPlw7DED4JyBGuq5HPhvMuLHRAuHk5lAz8dVXuQTKX+p
	 y8g4XVRQZro3t7+pM2Z1jtGNivffbzvuVF+0v/nI/JeTIyKUKzMAV3WwjS9zc8n31r
	 Hya56uxXHf5cdQ987/MVFJc3GBgTSIVABUWt0NhKqeNLalmqydVStcJt/My/wCXp7j
	 4RoVALVFTpyuA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tiuJ3-0043Rj-HF;
	Fri, 14 Feb 2025 11:56:29 +0000
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Alexander Potapenko <glider@google.com>,
	Anders Roxell <anders.roxell@linaro.org>,
	Ben Simner <ben.simner@cl.cam.ac.uk>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Eric Auger <eric.auger@redhat.com>,
	Florian Weimer <fweimer@redhat.com>,
	Fuad Tabba <tabba@google.com>,
	Jeremy Linton <jeremy.linton@arm.com>,
	kernel test robot <lkp@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Quentin Perret <qperret@google.com>,
	Wilco Dijkstra <wilco.dijkstra@arm.com>,
	Will Deacon <will@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Subject: [GIT PULL] KVM/arm64 fixes for 6.14, take #2
Date: Fri, 14 Feb 2025 11:56:08 +0000
Message-Id: <20250214115608.2986061-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, glider@google.com, anders.roxell@linaro.org, ben.simner@cl.cam.ac.uk, catalin.marinas@arm.com, eric.auger@redhat.com, fweimer@redhat.com, tabba@google.com, jeremy.linton@arm.com, lkp@intel.com, broonie@kernel.org, mark.rutland@arm.com, oliver.upton@linux.dev, qperret@google.com, wilco.dijkstra@arm.com, will@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Paolo,

Here's the second batch of KVM/arm64 fixes for 6.14.

The most noticeable item here is a rather large rework of our
FP/SIMD/SVE/SME handling, mostly removing a bunch of fairly pointless
and not-quite-thought-out optimisations. This fixes a bunch of
failures reported in the wild, and makes the code far more
maintainable. Thanks to Mark Rutland for doing all the hard work.

The rest is mostly a bunch of fixes cleanups after the merge window
(timers, vgic, pKVM...).

Please pull,

	M.

The following changes since commit 0e459810285503fb354537e84049e212c5917c33:

  KVM: arm64: timer: Don't adjust the EL2 virtual timer offset (2025-02-04 15:10:38 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-6.14-2

for you to fetch changes up to b3aa9283c0c505b5cfd25f7d6cfd720de2adc807:

  KVM: arm64: vgic: Hoist SGI/PPI alloc from vgic_init() to kvm_create_vgic() (2025-02-13 18:03:54 +0000)

----------------------------------------------------------------
KVM/arm64 fixes for 6.14, take #2

- Large set of fixes for vector handling, specially in the interactions
  between host and guest state. This fixes a number of bugs affecting
  actual deployments, and greatly simplifies the FP/SIMD/SVE handling.
  Thanks to Mark Rutland for dealing with this thankless task.

- Fix an ugly race between vcpu and vgic creation/init, resulting in
  unexpected behaviours.

- Fix use of kernel VAs at EL2 when emulating timers with nVHE.

- Small set of pKVM improvements and cleanups.

----------------------------------------------------------------
Marc Zyngier (4):
      KVM: arm64: Fix __pkvm_host_mkyoung_guest() return value
      KVM: arm64: Convert timer offset VA when accessed in HYP code
      KVM: arm64: timer: Drop warning on failed interrupt signalling
      KVM: arm64: vgic: Hoist SGI/PPI alloc from vgic_init() to kvm_create_vgic()

Mark Rutland (9):
      KVM: arm64: Unconditionally save+flush host FPSIMD/SVE/SME state
      KVM: arm64: Remove host FPSIMD saving for non-protected KVM
      KVM: arm64: Remove VHE host restore of CPACR_EL1.ZEN
      KVM: arm64: Remove VHE host restore of CPACR_EL1.SMEN
      KVM: arm64: Refactor CPTR trap deactivation
      KVM: arm64: Refactor exit handlers
      KVM: arm64: Mark some header functions as inline
      KVM: arm64: Eagerly switch ZCR_EL{1,2}
      KVM: arm64: Simplify warning in kvm_arch_vcpu_load_fp()

Quentin Perret (3):
      KVM: arm64: Improve error handling from check_host_shared_guest()
      KVM: arm64: Simplify np-guest hypercalls
      KVM: arm64: Fix alignment of kvm_hyp_memcache allocations

 arch/arm64/include/asm/kvm_emulate.h    |  42 ---------
 arch/arm64/include/asm/kvm_host.h       |  24 ++----
 arch/arm64/kernel/fpsimd.c              |  25 ------
 arch/arm64/kvm/arch_timer.c             |  16 ++--
 arch/arm64/kvm/arm.c                    |   8 --
 arch/arm64/kvm/fpsimd.c                 | 107 ++---------------------
 arch/arm64/kvm/hyp/entry.S              |   5 ++
 arch/arm64/kvm/hyp/include/hyp/switch.h | 148 ++++++++++++++++++++++++--------
 arch/arm64/kvm/hyp/nvhe/hyp-main.c      |  15 ++--
 arch/arm64/kvm/hyp/nvhe/mem_protect.c   |  76 ++++++++--------
 arch/arm64/kvm/hyp/nvhe/switch.c        |  89 +++++++++----------
 arch/arm64/kvm/hyp/vhe/switch.c         |  33 ++++---
 arch/arm64/kvm/vgic/vgic-init.c         |  74 ++++++++--------
 13 files changed, 287 insertions(+), 375 deletions(-)

