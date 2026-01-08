Return-Path: <kvm+bounces-67426-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 58932D052BA
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 18:48:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 3F1203062531
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 17:32:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E59E92DCF70;
	Thu,  8 Jan 2026 17:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JiJt+5uT"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DCF5288C3F;
	Thu,  8 Jan 2026 17:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767893559; cv=none; b=o+gSvkxSqM5v+mYWj3wUuWm6RfS55EgxVxZrUSZjXhRitfwkBCx/oHRBhqwZPEZswAN0U9/uBxiCXl829sFQmLMLgbTM+AVHAx9mRDrR5ktTuazz6r2OBuEWZ4C8UTX8sKROM6DXqiKMuJHpm0Fi4eI/YCeW/TNyqH69Gjtvo3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767893559; c=relaxed/simple;
	bh=UuRofox7XCb3cdDnaXYj1PeEoLZTYke+qDQbE9WjKss=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RRkKcLXSFRCCVuce/ME2st57VWAnH/6jwhUvZrjLXnBJpNK8cK6rd3eYNKJNR9Bh/TeydOBXLAgvLJAIzqGPFJRjVDlbDK7dbwY2F9VIFULDCC8EKzGvUsrgfKOYGOcnVvP3AjTMAguqh2tjGHjHf7Yk8dQjm7CuiXyx+nFCRlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JiJt+5uT; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B720DC116D0;
	Thu,  8 Jan 2026 17:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767893558;
	bh=UuRofox7XCb3cdDnaXYj1PeEoLZTYke+qDQbE9WjKss=;
	h=From:To:Cc:Subject:Date:From;
	b=JiJt+5uTJRHY+HzgL59bmQ7c5gOnf1B0TMmN02RUEQ7L7TYrfHPVYCp1oZcE4PBYW
	 EojDLf1Fr+MvQ1T8LttAIXhi2Nyx80mSMpMMiSmpaCCOvpt7OP6ms7b8EdmGAs0vxD
	 obJBe+oW959zSElfZbJINoO8iaR17Q/bxhemsKTQuVJuzw0/jL1m1xkOQvTanrYpGq
	 UEOv+KiYIAfD79S739XVbpCkh5VWmOYSnemuIwOvYBz6kdUO0FBPAyhfBvN4pV+/EM
	 +K2ySN+jhBDJzRvGfidkNUs4SctFmg0MAYha4LUChXNmE/Ekj6eISVYhuAfC8WxxH+
	 q/tmq6MoHNhCA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vdtsC-00000000W9F-1ORF;
	Thu, 08 Jan 2026 17:32:36 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Ben Horgan <ben.horgan@arm.com>,
	Yao Yuan <yaoyuan@linux.alibaba.com>
Subject: [PATCH v4 0/9] KVM: arm64: Add support for FEAT_IDST
Date: Thu,  8 Jan 2026 17:32:24 +0000
Message-ID: <20260108173233.2911955-1-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, ben.horgan@arm.com, yaoyuan@linux.alibaba.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

FEAT_IDST appeared in ARMv8.4, and allows ID registers to be trapped
if they are not implemented. This only concerns 3 registers (GMID_EL1,
CCSIDR2_EL1 and SMIDR_EL1), which are part of features that may not be
exposed to the guest even if present on the host.

For these registers, the HW should report them with EC=0x18, even if
the feature isn't implemented.

Add support for this feature by handling these registers in a specific
way and implementing GMID_EL1 support in the process. A very basic
selftest checks that these registers behave as expected.

* From v3: [3]

  - Added ID_AA64MMFR2_EL1.IDS == EL3 (Ben)

  - Introduced in_feat_id_space() helper (Yao)

  - Collected RBs, with thanks

* From v2: [2]

  - Repainted ID_AA64MMFR2_EL1.IDS description (Oliver)

  - Made the IDST handling more generic in the core KVM code, which
    resulted in the series being restructured a bit

  - Added handling to pKVM (in a slightly different way, as pKVM
    insist on seeing a full enumeration of the trapped registers)

  - Some cleanups

  - Collected RBs, with thanks

* From v1: [1]

  - Fixed commit message in patch #4 (Ben)

  - Collected RB, with thanks (Joey)

[1] https://lore.kernel.org/r/20251120133202.2037803-1-maz@kernel.org
[2] https://lore.kernel.org/r/20251126155951.1146317-1-maz@kernel.org
[3] https://lore.kernel.org/r/20251204094806.3846619-1-maz@kernel.org

Marc Zyngier (9):
  arm64: Repaint ID_AA64MMFR2_EL1.IDS description
  KVM: arm64: Add trap routing for GMID_EL1
  KVM: arm64: Add a generic synchronous exception injection primitive
  KVM: arm64: Handle FEAT_IDST for sysregs without specific handlers
  KVM: arm64: Handle CSSIDR2_EL1 and SMIDR_EL1 in a generic way
  KVM: arm64: Force trap of GMID_EL1 when the guest doesn't have MTE
  KVM: arm64: pkvm: Add a generic synchronous exception injection
    primitive
  KVM: arm64: pkvm: Report optional ID register traps with a 0x18
    syndrome
  KVM: arm64: selftests: Add a test for FEAT_IDST

 arch/arm64/include/asm/kvm_emulate.h          |   1 +
 arch/arm64/kvm/emulate-nested.c               |  21 ++++
 arch/arm64/kvm/hyp/nvhe/sys_regs.c            |  39 ++++--
 arch/arm64/kvm/inject_fault.c                 |  10 +-
 arch/arm64/kvm/sys_regs.c                     |   4 +-
 arch/arm64/kvm/sys_regs.h                     |  10 ++
 arch/arm64/tools/sysreg                       |   7 +-
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../testing/selftests/kvm/arm64/idreg-idst.c  | 117 ++++++++++++++++++
 9 files changed, 194 insertions(+), 16 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/arm64/idreg-idst.c

-- 
2.47.3


