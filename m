Return-Path: <kvm+bounces-29555-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E1F869ACDFF
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 17:05:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5E8C4B281E6
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 15:05:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F9ED20A5EA;
	Wed, 23 Oct 2024 14:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CY7jxMtE"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD426209F39;
	Wed, 23 Oct 2024 14:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729695238; cv=none; b=H5xkafjdCPtW8VTRrG5Z6tD30k2E2sD+beidQGGaQQRx3c1GehGXvYKf21X7ndf6//YO9F0QDNBYpBud3UqtJCFcoSJteBAh5ZFhxi9ctuEYxjhMIDruk7/Mb8vxilclZPJgGfkWEEHGd3T+pDEHOWFu2Zmn6lY2U5FcjGVEphY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729695238; c=relaxed/simple;
	bh=n7QHz2ieFv34eW5Zkyhf4MKFxk9bAobNuldVjF/QHxM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gZoY+0fmb8O6MEODQO9vVvZCuUxE6jrmbVdddGsIXqFpmAwF8jVT8e+pvyQqPQMfn3u6A7tvU3SWQFmJJD8zF5qDJjT9kS6PLTo6c3rr+jZS11OC/Gny7Qf99rF3B9Rz0KhjvGyqMk3/VzlRsnp46K23y7ZgEa5VbgqSU+UEsLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CY7jxMtE; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36C3AC4CEC6;
	Wed, 23 Oct 2024 14:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729695238;
	bh=n7QHz2ieFv34eW5Zkyhf4MKFxk9bAobNuldVjF/QHxM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CY7jxMtEKVV1lb5zPSYur8W3AKV8nGKk30puGDAo/W6hY9/exsQwg3dQlvWTvfY9r
	 jHwdkf9xv3XQcfJTDYLFgc+rTxFKrlAPv1fus4Y58ng3yUWAHi2aZbTFO28k4jkHiY
	 X+bAaJwuyQlVsohUu5o/TAOFi7XD1BelSr3yrWKnoXf4axv5aqoGat4FwCUfIt8CwO
	 qqrXw0tbZ/3wyYAQZiBd3oxrFM1XXzPLHZ/6gBpR9HbuWppqwh7aPVrld5H0CKitIA
	 F1J/cdyUfSPnYMKaY6qh9HnfZKnyJ33Kn3P9Fy0kU+XsW/zJVmWsFgviogJWyd5Pvd
	 L7AoBQ+nanK6Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1t3ckG-0068vz-Ax;
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
Subject: [PATCH v5 33/37] KVM: arm64: Add POE save/restore for AT emulation fast-path
Date: Wed, 23 Oct 2024 15:53:41 +0100
Message-Id: <20241023145345.1613824-34-maz@kernel.org>
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

Just like the other extensions affecting address translation,
we must save/restore POE so that an out-of-context translation
context can be restored and used with the AT instructions.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/at.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index de7109111e404..ef1643faedeb4 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -440,6 +440,8 @@ struct mmu_config {
 	u64	tcr2;
 	u64	pir;
 	u64	pire0;
+	u64	por_el0;
+	u64	por_el1;
 	u64	sctlr;
 	u64	vttbr;
 	u64	vtcr;
@@ -458,6 +460,10 @@ static void __mmu_config_save(struct mmu_config *config)
 			config->pir	= read_sysreg_el1(SYS_PIR);
 			config->pire0	= read_sysreg_el1(SYS_PIRE0);
 		}
+		if (system_supports_poe()) {
+			config->por_el1	= read_sysreg_el1(SYS_POR);
+			config->por_el0	= read_sysreg_s(SYS_POR_EL0);
+		}
 	}
 	config->sctlr	= read_sysreg_el1(SYS_SCTLR);
 	config->vttbr	= read_sysreg(vttbr_el2);
@@ -485,6 +491,10 @@ static void __mmu_config_restore(struct mmu_config *config)
 			write_sysreg_el1(config->pir, SYS_PIR);
 			write_sysreg_el1(config->pire0, SYS_PIRE0);
 		}
+		if (system_supports_poe()) {
+			write_sysreg_el1(config->por_el1, SYS_POR);
+			write_sysreg_s(config->por_el0, SYS_POR_EL0);
+		}
 	}
 	write_sysreg_el1(config->sctlr,	SYS_SCTLR);
 	write_sysreg(config->vttbr,	vttbr_el2);
@@ -1105,6 +1115,10 @@ static u64 __kvm_at_s1e01_fast(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
 			write_sysreg_el1(vcpu_read_sys_reg(vcpu, PIR_EL1), SYS_PIR);
 			write_sysreg_el1(vcpu_read_sys_reg(vcpu, PIRE0_EL1), SYS_PIRE0);
 		}
+		if (kvm_has_s1poe(vcpu->kvm)) {
+			write_sysreg_el1(vcpu_read_sys_reg(vcpu, POR_EL1), SYS_POR);
+			write_sysreg_s(vcpu_read_sys_reg(vcpu, POR_EL0), SYS_POR_EL0);
+		}
 	}
 	write_sysreg_el1(vcpu_read_sys_reg(vcpu, SCTLR_EL1),	SYS_SCTLR);
 	__load_stage2(mmu, mmu->arch);
-- 
2.39.2


