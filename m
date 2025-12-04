Return-Path: <kvm+bounces-65258-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BD9CCA318D
	for <lists+kvm@lfdr.de>; Thu, 04 Dec 2025 10:53:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8459E312E288
	for <lists+kvm@lfdr.de>; Thu,  4 Dec 2025 09:48:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2DAE33858B;
	Thu,  4 Dec 2025 09:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="li9bWD+c"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA72A333420;
	Thu,  4 Dec 2025 09:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764841716; cv=none; b=qCBC1U2QKHe1o1TRAE8gLY62PuYCJXN66Ug+B22POqBcJnJ1pSQ1QUwWO3KkTyRHfIA9z/EvdFY0cxTMf33X50RBK4ZGkg6nl/6m57XUi1SK8//rwyooViIWD+l9v9dOXtEjcNR4JxTPPnU2M1p5w5yToyXVCFQLSUS76vLU2ww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764841716; c=relaxed/simple;
	bh=H60AiTeTzKaEMtMo0Wpw3pM5yVyroEt8ri3eLfcsf7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=t5qrwZbHqutas/exZtovIa3eO1XtOLvgYFz76OCzeqXTWuLTwJ2J/gFpyRtByrQbxRdx9+dcUnE1dyMKU8dB7c7OZfmIV7KYbGYd79h3l/2S081MobrcLMlkozqQi+77dTCaceevysKKrXiExWP/TMxf/R+7zxkov+vnqzTAXmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=li9bWD+c; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50AD6C4CEFB;
	Thu,  4 Dec 2025 09:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764841716;
	bh=H60AiTeTzKaEMtMo0Wpw3pM5yVyroEt8ri3eLfcsf7Y=;
	h=From:To:Cc:Subject:Date:From;
	b=li9bWD+cbvG9uGOLckEFc3UgZon0KhHvVh8y/3Ae7MVyIYkUBakFqf+RQddkTrNlU
	 GkRGomTccrcvp5VT/32wuEOIIdny3etEv1j+TfL4uzdrPSwKHzDnsA/gqEBcuRrrd0
	 sTcCDIJ5NdyhiOVmUShJzUvvA5aEaTNf3+eiP0PQr+Y4j+65ZxLaaBMoVx3BY9Cdl5
	 0nFpUEBuvHOoyhKjuxZV03l49cWfzXqbI543/MU13Q549bUpANloIJQ96yKvwJrgPX
	 ZLREZ3fteSDpWKz/PJKSlrsE/ocB8kFi5zQsZvJCH8JsL/6WSwTWDok+ybdE4mlexq
	 mJ3+Po8VDqgiw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vR5ww-0000000AP90-0fQ6;
	Thu, 04 Dec 2025 09:48:34 +0000
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
Subject: [PATCH v3 0/9] KVM: arm64: Add support for FEAT_IDST
Date: Thu,  4 Dec 2025 09:47:57 +0000
Message-ID: <20251204094806.3846619-1-maz@kernel.org>
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
 arch/arm64/kvm/emulate-nested.c               |  28 +++++
 arch/arm64/kvm/hyp/nvhe/sys_regs.c            |  39 ++++--
 arch/arm64/kvm/inject_fault.c                 |  10 +-
 arch/arm64/kvm/sys_regs.c                     |   4 +-
 arch/arm64/tools/sysreg                       |   4 +-
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../testing/selftests/kvm/arm64/idreg-idst.c  | 117 ++++++++++++++++++
 8 files changed, 189 insertions(+), 15 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/arm64/idreg-idst.c

-- 
2.47.3


