Return-Path: <kvm+bounces-52882-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 47EC7B0A1A6
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 13:12:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AE3F04E5145
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 11:12:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2502E2C158E;
	Fri, 18 Jul 2025 11:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jJ7kTBPR"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 480CF28B41A;
	Fri, 18 Jul 2025 11:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752837137; cv=none; b=LmVOzniMAYP09OSUQN+RDKYQ0znGuTPGZ3OeB2VFS/IJMpykp0zOsS+/I/M0TbaU3ZjANT27p+9EU/EuacWtnHJVFcSCSzcm9Z2bbm/eFer13eSFE6wBOnFIaU+gZHvZbfSZmUGjuSPTMxmNi8Yif9XWDGGD9Ntef1A4ZfCM7kw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752837137; c=relaxed/simple;
	bh=cX7YrwMk2OOPZPPCwE1KB9e5hHTXFD0hbpP7g6YdzPw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=W0eEhP9hVlVXWtc711w6qZIHQvzI3K4ojiGqHIHJ+R0goB0BR+dEYUdgKYIeZqJFRqGKOM9wO57y0tmD1aUsCahuz7s0+I/CpmHPatJK03ym2smQJPiTTp3YgVo3hbgPmxsO4PJQECcsxzsNeOE+C6YoiMUESrXNFl26JA/KOWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jJ7kTBPR; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB32AC4CEF4;
	Fri, 18 Jul 2025 11:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752837136;
	bh=cX7YrwMk2OOPZPPCwE1KB9e5hHTXFD0hbpP7g6YdzPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jJ7kTBPRDROH/KI3582LtM6d9J6KQ0gQsSxx3MEZetOTzsOg8oOzKErcFR6QkQGk8
	 hLzsoTnLHdc68T4VFoAYv9u8ncqD0Zrp7UQ+/HyTlXn4+xOVs7eDjhGg1ixVWUAPj+
	 nlPtloQbq5RXpXPPRG+MGtUkiRgBruqMnvmFN5c9g4eLDEkig+6qp8KPUBQlIDrU/U
	 3kihL/fkb6zb3c7cXhmhgx8TUBx+gJsS4OwphygGGba/tThOxRHhjjBTvIBacVUiKt
	 8YVYNcjrlTmDl1a5UHdXhSSCXgQOB5j5hbAoYVbknDgzUK4a844w5FjPVG0a4N1t1P
	 HaV8jY9Cks8Ng==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1ucj0g-00Gt2B-Nu;
	Fri, 18 Jul 2025 12:12:14 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>
Subject: [PATCH 1/4] KVM: arm64: vgic-v3: Fix ordering of ICH_HCR_EL2
Date: Fri, 18 Jul 2025 12:11:51 +0100
Message-Id: <20250718111154.104029-2-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250718111154.104029-1-maz@kernel.org>
References: <20250718111154.104029-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, eric.auger@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

The sysreg tables are supposed to be sorted so that a binary search
can easily find them. However, ICH_HCR_EL2 is obviously at the wrong
spot.

Move it where it belongs.

Fixes: 9fe9663e47e21 ("KVM: arm64: Expose GICv3 EL2 registers via KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS")
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic-sys-reg-v3.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/vgic-sys-reg-v3.c b/arch/arm64/kvm/vgic-sys-reg-v3.c
index 75aee0148936f..1850f1727eb93 100644
--- a/arch/arm64/kvm/vgic-sys-reg-v3.c
+++ b/arch/arm64/kvm/vgic-sys-reg-v3.c
@@ -421,8 +421,8 @@ static const struct sys_reg_desc gic_v3_icc_reg_descs[] = {
 	EL2_REG(ICH_AP1R1_EL2, ich_apr),
 	EL2_REG(ICH_AP1R2_EL2, ich_apr),
 	EL2_REG(ICH_AP1R3_EL2, ich_apr),
-	EL2_REG(ICH_HCR_EL2, ich_reg),
 	EL2_REG_RO(ICC_SRE_EL2, icc_sre),
+	EL2_REG(ICH_HCR_EL2, ich_reg),
 	EL2_REG_RO(ICH_VTR_EL2, ich_vtr),
 	EL2_REG(ICH_VMCR_EL2, ich_reg),
 	EL2_REG(ICH_LR0_EL2, ich_reg),
-- 
2.39.2


