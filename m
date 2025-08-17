Return-Path: <kvm+bounces-54855-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 89083B294F1
	for <lists+kvm@lfdr.de>; Sun, 17 Aug 2025 22:22:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5937720349D
	for <lists+kvm@lfdr.de>; Sun, 17 Aug 2025 20:22:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EDF2244664;
	Sun, 17 Aug 2025 20:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JQ/fuZOR"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 961F51E0E1F;
	Sun, 17 Aug 2025 20:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755462125; cv=none; b=jRRY/9CABg2oGHzFxTjUaNutzUmL8pKQgb37Tj8vPu7JFzeljvvybZIv4s1koleAWSIFraf6vgZqBAUfzZXXIchMmRNNo7ZUwmNrmw1YvIP9vIuuiSq/hexLwYUYdPCe0N+3sLCbN7262a2IdUTXXQ+NcXkuGMzO4VvD7fuN5Dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755462125; c=relaxed/simple;
	bh=6IKXewD5unUmBax2L4vHEKjl6ny3rrpHG4F8C3MhAI4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=jiKEbqHG0gCcrRkkDYXWlLq3vSDkxWostp8hVrAmLuv9Jk0HAmbRPbTxX21P+kJGt+CUnAGGF57+LkFTnV5BQMhcg56mX/m4ofJSS3FIgGXcHsVD1eTw76VTKqUrBU/xu/6R729clHLhzBcIWnusv5GtH/isyAfGrHBjTlgsG6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JQ/fuZOR; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33B61C4CEEB;
	Sun, 17 Aug 2025 20:22:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755462125;
	bh=6IKXewD5unUmBax2L4vHEKjl6ny3rrpHG4F8C3MhAI4=;
	h=From:To:Cc:Subject:Date:From;
	b=JQ/fuZORsW19lxI3yCEgGoKsk/eCkdixoVAwGBsuTCHwVrwe125DUvz/ImYQN0m9e
	 SVzyFTelspj4+e3kqbco62jwL8K+Z3KN7wMLOd2C+qGY5vGgcVqZqRCKjX1gjUCO2p
	 i+X64uCFoJGt4yLdEcT5oBHpK9euSaEREzSk2u5ciSUl+K+9WH9mlRH63r2S0t5q+9
	 N7R5fKKqGSAhuqiRGtBJb+yf/LgppqM13bc7GnBfKDYrzv+0+ndzQVV1SzxQlrp38e
	 JlO6O0IbUkM2kC0obukFDaJ5B/iQD+PZRBheP8fNE977hoxWarTEq5polxRzwnPuv1
	 48mhCcwGn+dOA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1unjtC-008PX0-PO;
	Sun, 17 Aug 2025 21:22:02 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Cornelia Huck <cohuck@redhat.com>
Subject: [PATCH v3 0/6] KVM: arm64: FEAT_RASv1p1 support and RAS selection
Date: Sun, 17 Aug 2025 21:21:52 +0100
Message-Id: <20250817202158.395078-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, will@kernel.org, catalin.marinas@arm.com, cohuck@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

This is the next iteration of this series trying to plug some of our
RAS holes (no pun intended...). See [1] for the original series.

The difference with the previous drop is that we don't try to expose a
canonical encoding RASv1p1. Which means you must migrate between
similar implementations for now.

I've also added a cleanup patch at the end, which can be dropped.

Patches on top of v6.17-rc1.

* From v2 [2]:

  - Drop the canonical RASv1p1 advertisement

  - Expose ID_AA64PFR1_EL1.RAS_frac as a writable field

  - Added an extra patch dropping ARM64_FEATURE_MASK(), as it is both
    useless and annoying

  - Pick RB from Joey (thanks!)

* From v1 [1]:

  - Bunch of patches picked by Oliver (thanks!)

  - Added missing SYS_ERXMISC{2,3}_EL1 from the list of handled RAS
    registers

  - Added some rationale about the advertising of RASv1p1 (Cornelia)

  - Picked AB from Catalin (thanks!)

[1] https://lore.kernel.org/kvmarm/20250721101955.535159-1-maz@kernel.org
[2] https://lore.kernel.org/kvmarm/20250806165615.1513164-1-maz@kernel.org

Marc Zyngier (6):
  arm64: Add capability denoting FEAT_RASv1p1
  KVM: arm64: Handle RASv1p1 registers
  KVM: arm64: Ignore HCR_EL2.FIEN set by L1 guest's EL2
  KVM: arm64: Make ID_AA64PFR0_EL1.RAS writable
  KVM: arm64: Make ID_AA64PFR1_EL1.RAS_frac writable
  KVM: arm64: Get rid of ARM64_FEATURE_MASK()

 arch/arm64/include/asm/sysreg.h               |  3 -
 arch/arm64/kernel/cpufeature.c                | 24 ++++++
 arch/arm64/kvm/arm.c                          |  8 +-
 arch/arm64/kvm/hyp/vhe/switch.c               |  5 +-
 arch/arm64/kvm/nested.c                       |  3 +-
 arch/arm64/kvm/sys_regs.c                     | 75 +++++++++++++------
 arch/arm64/tools/cpucaps                      |  1 +
 tools/arch/arm64/include/asm/sysreg.h         |  3 -
 .../selftests/kvm/arm64/aarch32_id_regs.c     |  2 +-
 .../selftests/kvm/arm64/debug-exceptions.c    | 12 +--
 .../testing/selftests/kvm/arm64/no-vgic-v3.c  |  4 +-
 .../selftests/kvm/arm64/page_fault_test.c     |  6 +-
 .../testing/selftests/kvm/arm64/set_id_regs.c |  8 +-
 .../selftests/kvm/arm64/vpmu_counter_access.c |  2 +-
 .../selftests/kvm/lib/arm64/processor.c       |  6 +-
 15 files changed, 107 insertions(+), 55 deletions(-)

-- 
2.39.2


