Return-Path: <kvm+bounces-22820-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F79E94369B
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 21:42:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3E05B284782
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 19:42:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED02116D4D8;
	Wed, 31 Jul 2024 19:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CKA95QY0"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F6BE16CD07;
	Wed, 31 Jul 2024 19:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722454858; cv=none; b=oIUFNcS2xYUOuGgH38IEvMHJ0zbaAS19IviyJum3u0IjVEPoImBYkCh9qozBlNrzgTnmvJQ98iInogJ/yD9FTS298cpxjXcM8rHbRdcaP3WYHEV01GkJEfi+yTo2Eanjj36tBBv3B07N8rednxvv9lo0VNP6+2Izismm3PuAD88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722454858; c=relaxed/simple;
	bh=fEKxVbGnTOoetwaAJT1jf6gRsabgi2iICFQ6vbftSiM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Uunp0zD/Dfd0WR/z1n9C41q1goV/2IbldEf1uMlfkJIlYdN9t8a50TcRQepY1pFjxM2R04MShcGIZkBRkysA87pHR1kdVS3K5lB6hCUz+mKnNTv92HEO1wapgEABuknhcPQKZHUoE9h+ujxRdg+rRN9JdQSx8q0W8HdrCEvN96U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CKA95QY0; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBDCFC4AF09;
	Wed, 31 Jul 2024 19:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722454857;
	bh=fEKxVbGnTOoetwaAJT1jf6gRsabgi2iICFQ6vbftSiM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CKA95QY0/NA28EK2lcQWcLDQvIX3AbAWjjISV97+Aib55r9VjTK5ZHpNx3+asI7Ce
	 Gn+vW83JshaEmwTrrFTK/r2nX4lR4NBtFaLJ9Yj49eC5PkdWJRshsRwWi95CnwSOsp
	 BzzJcxOfB6YlZ+KcgI+6RDG6uRCpIYOGEz6T6JKSmqkcQoWRSt3rIxqs0nRlYMbgBU
	 VvD7O/Xu7DsEdNX9YIBS69wjpEcPIQMKl8SlKPWEpDQl6yQtDA5glnfKx6+vwIR3JH
	 Rc5U0Gadv8M18a1QwwPQ7uFIt3qIR9NdMKqOSKTh7o+VfgIXHjYm13hqqtOnJTRnra
	 CdJCL0TprEu9Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sZFBw-00H6Gh-65;
	Wed, 31 Jul 2024 20:40:56 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Przemyslaw Gaj <pgaj@cadence.com>
Subject: [PATCH v2 15/17] KVM: arm64: nv: Make AT+PAN instructions aware of FEAT_PAN3
Date: Wed, 31 Jul 2024 20:40:28 +0100
Message-Id: <20240731194030.1991237-16-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240731194030.1991237-1-maz@kernel.org>
References: <20240731194030.1991237-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com, alexandru.elisei@arm.com, anshuman.khandual@arm.com, pgaj@cadence.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

FEAT_PAN3 added a check for executable permissions to FEAT_PAN2.
Add the required SCTLR_ELx.EPAN and descriptor checks to handle
this correctly.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/at.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index 8e1f0837e309..f620eb69eeea 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -691,6 +691,21 @@ static u64 compute_par_s1(struct kvm_vcpu *vcpu, struct s1_walk_result *wr,
 	return par;
 }
 
+static bool pan3_enabled(struct kvm_vcpu *vcpu, enum trans_regime regime)
+{
+	u64 sctlr;
+
+	if (!kvm_has_feat(vcpu->kvm, ID_AA64MMFR1_EL1, PAN, PAN3))
+		return false;
+
+	if (regime == TR_EL10)
+		sctlr = vcpu_read_sys_reg(vcpu, SCTLR_EL1);
+	else
+		sctlr = vcpu_read_sys_reg(vcpu, SCTLR_EL2);
+
+	return sctlr & SCTLR_EL1_EPAN;
+}
+
 static u64 handle_at_slow(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
 {
 	bool perm_fail, ur, uw, ux, pr, pw, px;
@@ -757,7 +772,7 @@ static u64 handle_at_slow(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
 			bool pan;
 
 			pan = *vcpu_cpsr(vcpu) & PSR_PAN_BIT;
-			pan &= ur || uw;
+			pan &= ur || uw || (pan3_enabled(vcpu, wi.regime) && ux);
 			pw &= !pan;
 			pr &= !pan;
 		}
-- 
2.39.2


