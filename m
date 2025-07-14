Return-Path: <kvm+bounces-52321-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C624B03E94
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 14:27:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 97D6C1893C24
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 12:27:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 341BE248F5E;
	Mon, 14 Jul 2025 12:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hT19ib0g"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AD022472B0;
	Mon, 14 Jul 2025 12:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752496004; cv=none; b=XDwnL153kTbH5J/5ae2zjDWEeIiVy+7EtOltIdOKWmMX+X7sWKpi38pxVTHqMC7LFfOW/53iK0wE3WSOmO7x46k1aKyl36/X6e4VAoPzH/uXg/gPxM5qMzedW4pGf68XjAV+xM/JLMV+niqWVdGeFogyair0yJW99kmNFeiSPb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752496004; c=relaxed/simple;
	bh=/vMk69jugUdux6Iyc4dtdLKZPTxMcIyoAC9mmbKItVQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gVmZXKE/MtmggHIlnvui07D7tqd3WUpVa0LuYjx/JaBjThphwb1iUkiZC0hlS9F+4QXQdD1pnviVkBbvA1GuKvv8dm1rwru2IcOydllUDQtX5LoxC3U4rxY7VDzEW4OQeVHyWi3vp3J8Os3rn32no6lb8qWVwFLxHWSxisd9LL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hT19ib0g; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 058B8C4CEF7;
	Mon, 14 Jul 2025 12:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752496004;
	bh=/vMk69jugUdux6Iyc4dtdLKZPTxMcIyoAC9mmbKItVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hT19ib0gB87CTcvOTQ4J+9fgrUgk+vestQGaCqyq/xZZYAR4lwnYqUB2IFqSMv24L
	 li3/fefTutw4HDawhjeZ8UOD6rIOHv/aHqpBwXjc00h8CoJGIFa1RlKf4zjT+pw4vr
	 0drrzucrITtmTWMtIH2E6WWa7YKZRCGe26zMle03PpeBKtHQala/PBxU0FTH2Q/rKa
	 RES+P1rBUubCQIv4Y3Dl63/d1jvNgMuvzgomg6IAxymdfRAAgyqlL0q40uVPxAipKj
	 I7zqvYQPtGTDckqC21QoiC+WUkmVVEMf84+cOn2NYLe1KI326hiYGqEIw+MxY0MFbE
	 s61ZSssSzqGcg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1ubIGY-00FW7V-6t;
	Mon, 14 Jul 2025 13:26:42 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH 03/11] KVM: arm64: Define constant value for ICC_SRE_EL2
Date: Mon, 14 Jul 2025 13:26:26 +0100
Message-Id: <20250714122634.3334816-4-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250714122634.3334816-1-maz@kernel.org>
References: <20250714122634.3334816-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, eric.auger@redhat.com, peter.maydell@linaro.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Move the bag of bits defining the value of ICC_SRE_EL2 to a common
spot so that it can be reused by the save/restore code.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c  | 3 +--
 arch/arm64/kvm/vgic/vgic.h | 3 +++
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index dceb4f8f242a7..6981c1b34c2c4 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -532,8 +532,7 @@ static bool access_gic_sre(struct kvm_vcpu *vcpu,
 		return ignore_write(vcpu, p);
 
 	if (p->Op1 == 4) {	/* ICC_SRE_EL2 */
-		p->regval = (ICC_SRE_EL2_ENABLE | ICC_SRE_EL2_SRE |
-			     ICC_SRE_EL1_DIB | ICC_SRE_EL1_DFB);
+		p->regval = KVM_ICC_SRE_EL2;
 	} else {		/* ICC_SRE_EL1 */
 		p->regval = vcpu->arch.vgic_cpu.vgic_v3.vgic_sre;
 	}
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 4349084cb9a6c..af4bf80b785c3 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -64,6 +64,9 @@
 				      KVM_REG_ARM_VGIC_SYSREG_CRM_MASK | \
 				      KVM_REG_ARM_VGIC_SYSREG_OP2_MASK)
 
+#define KVM_ICC_SRE_EL2		(ICC_SRE_EL2_ENABLE | ICC_SRE_EL2_SRE |	\
+				 ICC_SRE_EL1_DIB | ICC_SRE_EL1_DFB)
+
 /*
  * As per Documentation/virt/kvm/devices/arm-vgic-its.rst,
  * below macros are defined for ITS table entry encoding.
-- 
2.39.2


