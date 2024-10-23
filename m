Return-Path: <kvm+bounces-29553-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FCA79ACDFD
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 17:04:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B0A101F22548
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 15:04:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8547209F38;
	Wed, 23 Oct 2024 14:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n/+mV154"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0619208D89;
	Wed, 23 Oct 2024 14:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729695237; cv=none; b=rlycsJojLhw7d0sON5Rehmxcr3R7mZWCCkVFT5+3hg09dkZDz+zQbv3tJ3lURjor3DTPngLRuHuAAMCxRYuSVoliyozKirw9VVLUpqGr4zKUEabzo+YBwNMC6D32Z/Epbe7nA/1vrxWc81EQk6qNpiKZLOUmJXK8SXLH7TKp2nY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729695237; c=relaxed/simple;
	bh=cFUROgj0irWvLa9NjPuW8hzFSF84yDju9um7+8iPfLQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FSRAYYM/bZlllJ5UAbCDbSJ7LAn8Oo2D9fLyBapmyP8YtlEItGoNLO7Yfe5NH5eN5uqrmV4PZtd37d8+YisGrqIQu6HPTShT8TjqrsR/fIwDUXy73XF0iTyjIikMa9G9ncxXhWkGO4ApkO36efsw5L23tG9FdpDT49PXmbjZIwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n/+mV154; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2A8DC4CECD;
	Wed, 23 Oct 2024 14:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729695237;
	bh=cFUROgj0irWvLa9NjPuW8hzFSF84yDju9um7+8iPfLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n/+mV154dIlk1SUt8pGG59eLSwCJNzoFwUC1b++UdbAIJ5/8slb9rRINIgIJjCK8j
	 D8CiwVmOPxgFLHUHQ97hEZMeo/qQHRi4rtxIs0e3vKZNYxSfe/rsibjMk0EiE/JqOC
	 AzwWzlTz3GGMvG8UjdoCKAYQO2PJ4HGWAA/aNGT/IdV7rV2Rb0qrP3Og0Ba0DvIoji
	 6vHOTZSxqJFDIjzMDRjHcn3fU3rULSPhT/hfI6P3gNQPFeZ4ZT+Jr98rwqk8Pfr3jz
	 YoV1StypigTuBs3e14IpkGQZEpkEZkvSsFYDcwfH93eIYdUAL8d5VBVpzODs2Vsg+w
	 KyqN+gEAV48kQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1t3ckF-0068vz-Ub;
	Wed, 23 Oct 2024 15:53:56 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v5 31/37] KVM: arm64: Add basic support for POR_EL2
Date: Wed, 23 Oct 2024 15:53:39 +0100
Message-Id: <20241023145345.1613824-32-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20241023145345.1613824-1-maz@kernel.org>
References: <20241023145345.1613824-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, alexandru.elisei@arm.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

S1POE support implies support for POR_EL2, which  we provide by

- adding it to the vcpu_sysreg enum
- advertising it as mapped to its EL1 counterpart in get_el2_to_el1_mapping
- wiring it in the sys_reg_desc table with the correct visibility
- handling POR_EL1 in __vcpu_{read,write}_sys_reg_from_cpu()

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h | 3 +++
 arch/arm64/kvm/sys_regs.c         | 9 +++++++++
 2 files changed, 12 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 3c435e88d74b8..e426c843e7ae7 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -473,6 +473,7 @@ enum vcpu_sysreg {
 	TCR_EL2,	/* Translation Control Register (EL2) */
 	PIRE0_EL2,	/* Permission Indirection Register 0 (EL2) */
 	PIR_EL2,	/* Permission Indirection Register 1 (EL2) */
+	POR_EL2,	/* Permission Overlay Register 2 (EL2) */
 	SPSR_EL2,	/* EL2 saved program status register */
 	ELR_EL2,	/* EL2 exception link register */
 	AFSR0_EL2,	/* Auxiliary Fault Status Register 0 (EL2) */
@@ -1043,6 +1044,7 @@ static inline bool __vcpu_read_sys_reg_from_cpu(int reg, u64 *val)
 	case TCR2_EL1:		*val = read_sysreg_s(SYS_TCR2_EL12);	break;
 	case PIR_EL1:		*val = read_sysreg_s(SYS_PIR_EL12);	break;
 	case PIRE0_EL1:		*val = read_sysreg_s(SYS_PIRE0_EL12);	break;
+	case POR_EL1:		*val = read_sysreg_s(SYS_POR_EL12);	break;
 	case ESR_EL1:		*val = read_sysreg_s(SYS_ESR_EL12);	break;
 	case AFSR0_EL1:		*val = read_sysreg_s(SYS_AFSR0_EL12);	break;
 	case AFSR1_EL1:		*val = read_sysreg_s(SYS_AFSR1_EL12);	break;
@@ -1092,6 +1094,7 @@ static inline bool __vcpu_write_sys_reg_to_cpu(u64 val, int reg)
 	case TCR2_EL1:		write_sysreg_s(val, SYS_TCR2_EL12);	break;
 	case PIR_EL1:		write_sysreg_s(val, SYS_PIR_EL12);	break;
 	case PIRE0_EL1:		write_sysreg_s(val, SYS_PIRE0_EL12);	break;
+	case POR_EL1:		write_sysreg_s(val, SYS_POR_EL12);	break;
 	case ESR_EL1:		write_sysreg_s(val, SYS_ESR_EL12);	break;
 	case AFSR0_EL1:		write_sysreg_s(val, SYS_AFSR0_EL12);	break;
 	case AFSR1_EL1:		write_sysreg_s(val, SYS_AFSR1_EL12);	break;
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index c89a165408498..b493fb7632adc 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -137,6 +137,7 @@ static bool get_el2_to_el1_mapping(unsigned int reg,
 		MAPPED_EL2_SYSREG(TCR2_EL2,    TCR2_EL1,    NULL	     );
 		MAPPED_EL2_SYSREG(PIR_EL2,     PIR_EL1,     NULL	     );
 		MAPPED_EL2_SYSREG(PIRE0_EL2,   PIRE0_EL1,   NULL	     );
+		MAPPED_EL2_SYSREG(POR_EL2,     POR_EL1,     NULL	     );
 		MAPPED_EL2_SYSREG(AMAIR_EL2,   AMAIR_EL1,   NULL	     );
 		MAPPED_EL2_SYSREG(ELR_EL2,     ELR_EL1,	    NULL	     );
 		MAPPED_EL2_SYSREG(SPSR_EL2,    SPSR_EL1,    NULL	     );
@@ -2322,6 +2323,12 @@ static unsigned int s1poe_visibility(const struct kvm_vcpu *vcpu,
 	return REG_HIDDEN;
 }
 
+static unsigned int s1poe_el2_visibility(const struct kvm_vcpu *vcpu,
+					 const struct sys_reg_desc *rd)
+{
+	return __el2_visibility(vcpu, rd, s1poe_visibility);
+}
+
 static unsigned int tcr2_visibility(const struct kvm_vcpu *vcpu,
 				    const struct sys_reg_desc *rd)
 {
@@ -2909,6 +2916,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 			 s1pie_el2_visibility),
 	EL2_REG_FILTERED(PIR_EL2, access_rw, reset_val, 0,
 			 s1pie_el2_visibility),
+	EL2_REG_FILTERED(POR_EL2, access_rw, reset_val, 0,
+			 s1poe_el2_visibility),
 	EL2_REG(AMAIR_EL2, access_rw, reset_val, 0),
 
 	EL2_REG(VBAR_EL2, access_rw, reset_val, 0),
-- 
2.39.2


