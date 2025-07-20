Return-Path: <kvm+bounces-52953-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5EEF9B0B4DF
	for <lists+kvm@lfdr.de>; Sun, 20 Jul 2025 12:22:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8AB983BD3E1
	for <lists+kvm@lfdr.de>; Sun, 20 Jul 2025 10:22:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30D8F1F1306;
	Sun, 20 Jul 2025 10:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LR/nh38i"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51F8E3BB48;
	Sun, 20 Jul 2025 10:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753006961; cv=none; b=byP/GDh2KODUdnYLYQGnIw9Lzwq4VfqiefXxDUZZuuVPPRGfeihrPFuEVk7OwiALJPoSvrsWAzuzhCO0cI0nO/iXhgZisG91SSNbXEOKhTJd/hBFHFJMcL+fx0PC4mcF0O5ix99B82XWqW3Kbm2I2nEidWjqv9vutc5ScbMHCJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753006961; c=relaxed/simple;
	bh=VpZbHWYgkCPsYBiMifOdXB7lfxAfU+gfPFO1mJoJXAI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=KssVlwQOjQx+VttBA3sdgWLyVS1rN87KDEYvPGj6ijjObxbGlVh41oVhcGDN3MFXL6MnyxOFE6EUp4dnhN+kQ6BWSC0ZpuoSl6iyuAIni/Da7DhYBpMgyUB99Tu1DplrIX4A58adVDD7IzCf2EkLjCanDK/mktKuRUYqJbY4++o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LR/nh38i; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 287A9C4CEE7;
	Sun, 20 Jul 2025 10:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753006961;
	bh=VpZbHWYgkCPsYBiMifOdXB7lfxAfU+gfPFO1mJoJXAI=;
	h=From:To:Cc:Subject:Date:From;
	b=LR/nh38iNvbpoq3ZhjVChs/kEPTbSrQ5C0G6YuoH0DL1QQhe4qvdPu1ZD3SXi7iSQ
	 y0VWHkw+xBAv+JW3grp5ML+5y17yBTHFvw7Ps7Uhtgs6EK1pe5S8/eJWim+47Z8VRt
	 dPFBPfM/AICssAE2YuHMStTczw60L0Rggqab1syQJc6BSMfiMn9j7sCaIxXqWYbYO0
	 2btb6KBWCAXBv6C+c87q5FhC7zWq0jP1EWkjIKwLibcbBWSC1QZpcRgWFjGDjcrgmV
	 2Ju9M+O7y8I2Ym8CPrfOQK5fBRWIgV3Jgv6U+cHbbOsJND5Ly5biQuc61VOP4LRYnj
	 cLgI+kEaCueZw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1udRBm-00HIBV-Ox;
	Sun, 20 Jul 2025 11:22:38 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH] KVM: arm64: Check for SYSREGS_ON_CPU before accessing the CPU state
Date: Sun, 20 Jul 2025 11:22:29 +0100
Message-Id: <20250720102229.179114-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, broonie@kernel.org, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Mark Brown reports that since we commit to making exceptions
visible without the vcpu being loaded, the external abort selftest
fails.

Upon investigation, it turns out that the code that makes registers
affected by an exception visible to the guest is completely broken
on VHE, as we don't check whether the system registers are loaded
on the CPU at this point. We managed to get away with this so far,
but that's obviously as bad as it gets,

Add the required checksm and document the absolute need to check
for the SYSREGS_ON_CPU flag before calling into any of the
__vcpu_write_sys_reg_to_cpu()__vcpu_read_sys_reg_from_cpu() helpers.

Reported-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/18535df8-e647-4643-af9a-bb780af03a70@sirena.org.uk
---
 arch/arm64/include/asm/kvm_host.h | 4 ++++
 arch/arm64/kvm/hyp/exception.c    | 6 ++++--
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index df9c1e1e52025..831cec0e1239e 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1169,6 +1169,8 @@ static inline bool __vcpu_read_sys_reg_from_cpu(int reg, u64 *val)
 	 * System registers listed in the switch are not saved on every
 	 * exit from the guest but are only saved on vcpu_put.
 	 *
+	 * SYSREGS_ON_CPU *MUST* be checked before using this helper.
+	 *
 	 * Note that MPIDR_EL1 for the guest is set by KVM via VMPIDR_EL2 but
 	 * should never be listed below, because the guest cannot modify its
 	 * own MPIDR_EL1 and MPIDR_EL1 is accessed for VCPU A from VCPU B's
@@ -1221,6 +1223,8 @@ static inline bool __vcpu_write_sys_reg_to_cpu(u64 val, int reg)
 	 * System registers listed in the switch are not restored on every
 	 * entry to the guest but are only restored on vcpu_load.
 	 *
+	 * SYSREGS_ON_CPU *MUST* be checked before using this helper.
+	 *
 	 * Note that MPIDR_EL1 for the guest is set by KVM via VMPIDR_EL2 but
 	 * should never be listed below, because the MPIDR should only be set
 	 * once, before running the VCPU, and never changed later.
diff --git a/arch/arm64/kvm/hyp/exception.c b/arch/arm64/kvm/hyp/exception.c
index 7dafd10e52e8c..95d186e0bf54f 100644
--- a/arch/arm64/kvm/hyp/exception.c
+++ b/arch/arm64/kvm/hyp/exception.c
@@ -26,7 +26,8 @@ static inline u64 __vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, int reg)
 
 	if (unlikely(vcpu_has_nv(vcpu)))
 		return vcpu_read_sys_reg(vcpu, reg);
-	else if (__vcpu_read_sys_reg_from_cpu(reg, &val))
+	else if (vcpu_get_flag(vcpu, SYSREGS_ON_CPU) &&
+		 __vcpu_read_sys_reg_from_cpu(reg, &val))
 		return val;
 
 	return __vcpu_sys_reg(vcpu, reg);
@@ -36,7 +37,8 @@ static inline void __vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg)
 {
 	if (unlikely(vcpu_has_nv(vcpu)))
 		vcpu_write_sys_reg(vcpu, val, reg);
-	else if (!__vcpu_write_sys_reg_to_cpu(val, reg))
+	else if (!vcpu_get_flag(vcpu, SYSREGS_ON_CPU) ||
+		 !__vcpu_write_sys_reg_to_cpu(val, reg))
 		__vcpu_assign_sys_reg(vcpu, reg, val);
 }
 
-- 
2.39.2


