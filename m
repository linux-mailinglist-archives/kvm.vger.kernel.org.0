Return-Path: <kvm+bounces-26517-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0626A9754AD
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 15:54:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 396541C254DE
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 13:54:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AE081A76C7;
	Wed, 11 Sep 2024 13:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JJdH6lDr"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEC7B1A38F1;
	Wed, 11 Sep 2024 13:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726062719; cv=none; b=KBQNjKdn5r2y7YLow+M3QSq/5qaEZGmPjzyddCBjzr0t9aPTFK8jLyExNXEqY712jDggQ7A+ywjEyNmNyGyWq3yfXr4Qal6BIUEuS6ZzISuqT8cACaY2sxjT7nMF/9zcWmsTS0jW+gDaq+kzd4yGl5LsizVwNxFmle+4lOGE78M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726062719; c=relaxed/simple;
	bh=EkNOxajA1sXIEet1JDQdUnqLS3wZ1Qi/EB3YjEcrH9g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TI/i2HTAAM1XCErAdGSotIMP+Q931Us+giCF9LtaY1M5wKmDCVyMwknBmvk4IVXfHoGFsQWUkiyxFHbVh1LQQh6Fe6U1ZStsLDmXb5anycMuMfiShihCioiUrfz+p3tFn6NXR/9nznehQmWT/IdoUGeOwuN2Na3C0WpVUVFZe6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JJdH6lDr; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EB28C4CECE;
	Wed, 11 Sep 2024 13:51:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726062719;
	bh=EkNOxajA1sXIEet1JDQdUnqLS3wZ1Qi/EB3YjEcrH9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JJdH6lDr9OKubB4xQ/F9Y+oq7SYRm1CUFeR7Fm5qHGP35S5muTiN9h2Yv+5fCd4jL
	 6/DjHEC4P26TpR1oBWJpPIp/goOHjAf9WTkPwNTjqQvIEiWt5LSdF7SM78hCED2CxZ
	 bYuuY0x7+xwmTUjpAf2zvOQTPLydcB+SClYcjVY9gAZNnc7dcE2uxjeKAIShY857iv
	 KFkGud2+aqLF8beW/cRz6waklO3Q9Xx1lUvnxznGTUSUSaAc+CNvM0VW+kTp+9y6vl
	 rYxEFancpPUCpckRVo7th7UGQP+DAQzyCSy6ZRd2eqOgaLNwkpLQFXdGB8NuRYxuw6
	 trSYl0wWdJgpg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1soNlF-00C7tL-Mc;
	Wed, 11 Sep 2024 14:51:57 +0100
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
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v3 07/24] KVM: arm64: Correctly access TCR2_EL1, PIR_EL1, PIRE0_EL1 with VHE
Date: Wed, 11 Sep 2024 14:51:34 +0100
Message-Id: <20240911135151.401193-8-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240911135151.401193-1-maz@kernel.org>
References: <20240911135151.401193-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com, alexandru.elisei@arm.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

For code that accesses any of the guest registers for emulation
purposes, it is crucial to know where the most up-to-date data is.

While this is pretty clear for nVHE (memory is the sole repository),
things are a lot muddier for VHE, as depending on the SYSREGS_ON_CPU
flag, registers can either be loaded on the HW or be in memory.

Even worse with NV, where the loaded state is by definition partial.

For these reasons, KVM offers the vcpu_read_sys_reg() and
vcpu_write_sys_reg() primitives that always do the right thing.
However, these primitive must know what register to access, and
this is the role of the __vcpu_read_sys_reg_from_cpu() and
__vcpu_write_sys_reg_to_cpu() helpers.

As it turns out, TCR2_EL1, PIR_EL1, PIRE0_EL1 and not described
in the latter helpers, meaning that the AT code cannot use them
to emulate S1PIE.

Add the three registers to the (long) list.

Fixes: 86f9de9db178 ("KVM: arm64: Save/restore PIE registers")
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>
---
 arch/arm64/include/asm/kvm_host.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index a33f5996ca9f1..5265a1a929514 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1012,6 +1012,9 @@ static inline bool __vcpu_read_sys_reg_from_cpu(int reg, u64 *val)
 	case TTBR0_EL1:		*val = read_sysreg_s(SYS_TTBR0_EL12);	break;
 	case TTBR1_EL1:		*val = read_sysreg_s(SYS_TTBR1_EL12);	break;
 	case TCR_EL1:		*val = read_sysreg_s(SYS_TCR_EL12);	break;
+	case TCR2_EL1:		*val = read_sysreg_s(SYS_TCR2_EL12);	break;
+	case PIR_EL1:		*val = read_sysreg_s(SYS_PIR_EL12);	break;
+	case PIRE0_EL1:		*val = read_sysreg_s(SYS_PIRE0_EL12);	break;
 	case ESR_EL1:		*val = read_sysreg_s(SYS_ESR_EL12);	break;
 	case AFSR0_EL1:		*val = read_sysreg_s(SYS_AFSR0_EL12);	break;
 	case AFSR1_EL1:		*val = read_sysreg_s(SYS_AFSR1_EL12);	break;
@@ -1058,6 +1061,9 @@ static inline bool __vcpu_write_sys_reg_to_cpu(u64 val, int reg)
 	case TTBR0_EL1:		write_sysreg_s(val, SYS_TTBR0_EL12);	break;
 	case TTBR1_EL1:		write_sysreg_s(val, SYS_TTBR1_EL12);	break;
 	case TCR_EL1:		write_sysreg_s(val, SYS_TCR_EL12);	break;
+	case TCR2_EL1:		write_sysreg_s(val, SYS_TCR2_EL12);	break;
+	case PIR_EL1:		write_sysreg_s(val, SYS_PIR_EL12);	break;
+	case PIRE0_EL1:		write_sysreg_s(val, SYS_PIRE0_EL12);	break;
 	case ESR_EL1:		write_sysreg_s(val, SYS_ESR_EL12);	break;
 	case AFSR0_EL1:		write_sysreg_s(val, SYS_AFSR0_EL12);	break;
 	case AFSR1_EL1:		write_sysreg_s(val, SYS_AFSR1_EL12);	break;
-- 
2.39.2


