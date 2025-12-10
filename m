Return-Path: <kvm+bounces-65664-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BF62FCB3A3C
	for <lists+kvm@lfdr.de>; Wed, 10 Dec 2025 18:36:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id DC57D30120FC
	for <lists+kvm@lfdr.de>; Wed, 10 Dec 2025 17:36:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E777E329396;
	Wed, 10 Dec 2025 17:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bDsnPyx9"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E854832936B;
	Wed, 10 Dec 2025 17:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765387833; cv=none; b=XwEYtlcaEwo599gW/fZxiE2aobi3nSU5oUH/MZXGKL3P0j8FS+o5gaiNiwfGKCcDSUqrYFznfro9jQE9Wr6k9Ft/DfJwWm5wcrPif4XdR7zj4moV96tSJu4+vGfiGE1TImoZru+jCw3eFkf+Qb1h/x9/xI9MzTkISyrXtMP8T8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765387833; c=relaxed/simple;
	bh=UGleA0Eh9dB/KG2M5WoVKVgU7WdtqKRJeeAMH4jDpRQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=a1B277ARWzU6bOxmx5bI6RyRBiaiCdsAL+oBVMTyugglgEH3aRWKTXD5n9JWYufHOx2N/3XZVr/Dem6NJLZg//KW8ds4VHOqt2QN+7nbGDVrxMh2ej/iNevsFLsUUGusI2DukWMtiTxiC4hhLiYVwlihoF80Leo6pClc/zYGUtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bDsnPyx9; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A7ACC116B1;
	Wed, 10 Dec 2025 17:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765387832;
	bh=UGleA0Eh9dB/KG2M5WoVKVgU7WdtqKRJeeAMH4jDpRQ=;
	h=From:To:Cc:Subject:Date:From;
	b=bDsnPyx9MXq/CMaCUHJYcIVElnM0cJf+0nKcKPQmA5bUBHAVq46sOiH4JvLi5ky1r
	 LOkM+n+M9f6dIgWAt0MPYAiZbuAc2ZUDogaSlhKzlJSrZFy3LxBM+Wc80Lhy+k/pMY
	 K/j+fDn8YtqianGX8Fmk0N/zeGkdcfLpLoqmNn4+hyEULex7ipZe4npMK2g3PBvq2X
	 pFwlFbktX1w9jQQRKUWj6TiPbe/V+/4l4ZHzRIiMwTNerBaPTZfCG8qSxBrlDzugwP
	 0QQVwmQaOzHHrb4tFetffghi6IsxI874YqI0nBHoYR1QjLJVdMnoVslNLLs4S0+pU9
	 htReOUHt36N7g==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vTO1G-0000000BnnB-0uzE;
	Wed, 10 Dec 2025 17:30:30 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Sascha Bischoff <Sascha.Bischoff@arm.com>,
	Quentin Perret <qperret@google.com>,
	Fuad Tabba <tabba@google.com>,
	Sebastian Ene <sebastianene@google.com>
Subject: [PATCH v2 0/6] KVM: arm64: VTCR_EL2 conversion to feature dependency framework
Date: Wed, 10 Dec 2025 17:30:18 +0000
Message-ID: <20251210173024.561160-1-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, alexandru.elisei@arm.com, Sascha.Bischoff@arm.com, qperret@google.com, tabba@google.com, sebastianene@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

This is a follow-up on my VTCR_EL2 sanitisation series, with extra
goodies, mostly as a consequence of Alexandru's patches and review.

* From [1]:

  - Added two patches fixing some FEAT_XNX issues: one dating back
    from the hVHE introduction, and the other related to the newer
    stuff in 6.19.

  - Expanded the scope of the RES1 handling in DECLARE_FEAT_MAP() to
    deal with FGTs, as we're about to get quality stuff thanks to
    GICv5.

  - Simplified the S2TGRANx detection slightly.

  - Collected RBs, with thanks

[1] https://lore.kernel.org/r/20251129144525.2609207-1-maz@kernel.org

Marc Zyngier (6):
  KVM: arm64: Fix EL2 S1 XN handling for hVHE setups
  arm64: Convert ID_AA64MMFR0_EL1.TGRAN{4,16,64}_2 to UnsignedEnum
  arm64: Convert VTCR_EL2 to sysreg infratructure
  KVM: arm64: Account for RES1 bits in DECLARE_FEAT_MAP() and co
  KVM: arm64: Convert VTCR_EL2 to config-driven sanitisation
  KVM: arm64: Honor UX/PX attributes for EL2 S1 mappings

 arch/arm64/include/asm/kvm_arm.h     | 52 ++++-----------
 arch/arm64/include/asm/kvm_host.h    |  1 +
 arch/arm64/include/asm/kvm_pgtable.h |  2 +
 arch/arm64/include/asm/sysreg.h      |  1 -
 arch/arm64/kvm/config.c              | 94 ++++++++++++++++++++++++----
 arch/arm64/kvm/emulate-nested.c      | 55 +++++++++-------
 arch/arm64/kvm/hyp/pgtable.c         | 32 +++++++---
 arch/arm64/kvm/nested.c              | 11 ++--
 arch/arm64/tools/sysreg              | 63 ++++++++++++++++++-
 9 files changed, 217 insertions(+), 94 deletions(-)

-- 
2.47.3


