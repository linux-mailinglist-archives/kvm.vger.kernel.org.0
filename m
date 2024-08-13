Return-Path: <kvm+bounces-23971-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 484D4950210
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 12:08:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0AC8128707C
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 10:08:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EC3919D078;
	Tue, 13 Aug 2024 10:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jbTqKpK7"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6087119D062;
	Tue, 13 Aug 2024 10:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723543587; cv=none; b=DNRFiXolFFkx7rsljqdkM0LkugL1vQg1CcANtEvQj9F/Jap9BuG+xYsXV60y9ds3WWGi7QYH99HK1MPCRAAGWeOP34yH5oDp5Y3J2+7qsvFvK4xNJk6OdxHAcNo1j001iQbI/phAJ1IxolRJbb2Ybc+L4VxN3Q46R4j+gwZBXAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723543587; c=relaxed/simple;
	bh=9mdkinhl2LH71GlqtWIUfQT9XRURynjNzc/O94RFrjk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ehaRu8sC0RNRmp3xFOmKh4tyr35khh8fu1BDbsdUIE5XiTVUc9+JwXC1s4fhsOnyFkUW+6d7pkQdL9MaB8v6Qs6PZLMERj54vWjZKY2ohSvryTtypkWq7l0khmM86M4+jkOR8W92cS3RzUQdi6Y4+ULG+zmGX9iWhGcUyRCWto0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jbTqKpK7; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3914DC4AF0B;
	Tue, 13 Aug 2024 10:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723543587;
	bh=9mdkinhl2LH71GlqtWIUfQT9XRURynjNzc/O94RFrjk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jbTqKpK7oYSqeI9I5eMZczPVlW/58zRIpuvD4jASfthpAxeitcPPvlPJt3rV5GCoO
	 OqoM6Sia+w5JL11FAUNqzUpX1ubBYT6zYmcF4R1dhg0rgWFSaQc2+VYOzVzn5Fiudf
	 WQZv7TjekM9Ay6VMxH0IYLGPKHzC2/n/nHKyN5Kedqldqp4kAxKFTkxfBHWXl8kLXw
	 iH99ChBIjMN+PIYNt8LPuQnWZF6sMuRgp3P4mizrwjLOIjcypC3+KOOJANz27rsaPy
	 DOjSbxHM0AJFg/xvwc8+HCFyzi9zg0xnt05b0VcnySF7at+oFumpji5zSQ7dkpHqfr
	 v+ggI/KjugDhg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sdoQ5-003INM-1u;
	Tue, 13 Aug 2024 11:06:25 +0100
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
Subject: [PATCH v3 16/18] KVM: arm64: nv: Make AT+PAN instructions aware of FEAT_PAN3
Date: Tue, 13 Aug 2024 11:05:38 +0100
Message-Id: <20240813100540.1955263-17-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240813100540.1955263-1-maz@kernel.org>
References: <20240813100540.1955263-1-maz@kernel.org>
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
index 6d5555e98557..c134bcd0338d 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -728,6 +728,21 @@ static u64 compute_par_s1(struct kvm_vcpu *vcpu, struct s1_walk_result *wr,
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
@@ -794,7 +809,7 @@ static u64 handle_at_slow(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
 			bool pan;
 
 			pan = *vcpu_cpsr(vcpu) & PSR_PAN_BIT;
-			pan &= ur || uw;
+			pan &= ur || uw || (pan3_enabled(vcpu, wi.regime) && ux);
 			pw &= !pan;
 			pr &= !pan;
 		}
-- 
2.39.2


