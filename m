Return-Path: <kvm+bounces-24618-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 072DF9584D0
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 12:39:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A5E161F26BF6
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 10:39:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3350518FC80;
	Tue, 20 Aug 2024 10:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iU7Xo/L7"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 485C818F2D8;
	Tue, 20 Aug 2024 10:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724150289; cv=none; b=KzwzSTLBmNlfajplVEeXcrurr//bMsTdOeCE8d/c74vrShMCut/3JX0K5FCn4vQ0oJWTyoeScr3d13qFG4wkCUzNNocrQqEFTLzg8tIv0rEXIlusCeYJmnSsc/5v9UV88JAJBGQYKw74wIawa325ALka8l05dWgU3ORKkpko7Vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724150289; c=relaxed/simple;
	bh=6SeSlBKre70JlYSsR3NUDKXmQLYyayjyrUpmUy8J5ms=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mgcVQHfAq9Fnnj9nmUUQCwiD8hrbM4UE389kK5ILMQ6KX1Rl3YrWjuzP1nyd8Q9t+f/xvAz8fRMwjy+LWBtSEQfHJj0fRsMfZSiJRb30aD5hWO81mO+aUmvujmbS7aD/bCZvjV3Zx1Q+2GRAmQfnFAPPbfp56s8lnum9MDboOnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iU7Xo/L7; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D54EC4AF12;
	Tue, 20 Aug 2024 10:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724150289;
	bh=6SeSlBKre70JlYSsR3NUDKXmQLYyayjyrUpmUy8J5ms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iU7Xo/L7CWmNsbkjFYZHyK3I5D9xPMpNE4FsaG/yBLRXsq02aNZWWJFyOy6yqLcWt
	 sgAsKyndR2QdQZDbfZicpBdv5ydfRGqXeC7MFaVyFMgZGWQJonMYTtB7peWW+T76A3
	 mUNglgCJ567/+ULuH8T5bLDbxXW0taKs8GMrunQHaJtmj3IBXbqATjcZc9uxMArevu
	 w8eZGWj6Mwn4hBE7yTYe6lDNFQq8px7J3AWtw8+DPt7La1PfPDSKnr0FDO46BV+4SU
	 vHX9X3fhg0XVU0T0od49l9YSOtLMQNGnzApJ5haI7xPVCJ+AGI/dNIMc8WnvOTIS/Z
	 owaKKFgc1V/iA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sgMFb-005Ea3-Df;
	Tue, 20 Aug 2024 11:38:07 +0100
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
Subject: [PATCH v4 16/18] KVM: arm64: nv: Make AT+PAN instructions aware of FEAT_PAN3
Date: Tue, 20 Aug 2024 11:37:54 +0100
Message-Id: <20240820103756.3545976-17-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240820103756.3545976-1-maz@kernel.org>
References: <20240820103756.3545976-1-maz@kernel.org>
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

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/at.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index e037eb73738a..60f1ca3a897d 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -731,6 +731,21 @@ static u64 compute_par_s1(struct kvm_vcpu *vcpu, struct s1_walk_result *wr,
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
@@ -797,7 +812,7 @@ static u64 handle_at_slow(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
 			bool pan;
 
 			pan = *vcpu_cpsr(vcpu) & PSR_PAN_BIT;
-			pan &= ur || uw;
+			pan &= ur || uw || (pan3_enabled(vcpu, wi.regime) && ux);
 			pw &= !pan;
 			pr &= !pan;
 		}
-- 
2.39.2


