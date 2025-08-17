Return-Path: <kvm+bounces-54843-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4622DB292ED
	for <lists+kvm@lfdr.de>; Sun, 17 Aug 2025 14:19:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0D194206B2E
	for <lists+kvm@lfdr.de>; Sun, 17 Aug 2025 12:19:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B61BF2417FB;
	Sun, 17 Aug 2025 12:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="an4/VlmT"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA17523958C;
	Sun, 17 Aug 2025 12:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755433174; cv=none; b=mlHrISYcWo3Vl1yvLeIjl3jdompEfF7kx8RQJ6TReJQARDzW6MB61fTBEwLenHQsT5W09mBKnPG10zBvjmU8FsNNdx5oBfkQxWa27B9v5pNmdCS8HSi5F2qyYccjLbs+ogoe7q3itH6d7eF1Oqpj+Eo1Ym6qLK3I+ISD6ftsanI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755433174; c=relaxed/simple;
	bh=Guo97h2eoxZMYb2+Nxi9WRmIP/XlgwvHHwcXipcf8z8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mtiHGxzsTwEaF3Oafla47re7n+FygLUN6wYhHhioj8PVpM9qtW4UZ2oZYewU2wtcAIf32xpyKK7KybBgyYkbIvfFOjoR0d2rKrDlhnacmU9506HVSWsVsl/88Vh32qwDLyUBUiFCt0r0NFLxA4ZycSME7HADr+1dSiasJWRhNg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=an4/VlmT; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 506B4C4CEED;
	Sun, 17 Aug 2025 12:19:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755433173;
	bh=Guo97h2eoxZMYb2+Nxi9WRmIP/XlgwvHHwcXipcf8z8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=an4/VlmTRgclhs8z7ggOTKCObOo8TlcN4AiGAKsozXqR7bQ50HeSrV+IPUEod3H/l
	 WQqR/2aF3JOBdID2wzQypjcZowlccK5O451DNY34sGGaH+0Nb0hxCJmPvUXIZIbzUM
	 JEAshusTRhIbA62z55JkACzTw0j+nTePvS3ilWoyn1rr/DX++3kUTkwlQd2lRrPt9+
	 5RVRh1etm4ULhJ7qcoaSFe291JI7L7SBc0d9ItAoODwDPOdH8UDcvd4sqIuCxebGkV
	 AOth1WhzNR24e2wEjrNf6fRZ4NZzAM1LSwOJrXKmvosmD3pDnOsQhOUNWSsUd0YsrD
	 L9ftc74wcKdeA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1uncMF-008L0z-7g;
	Sun, 17 Aug 2025 13:19:31 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Volodymyr Babchuk <volodymyr_babchuk@epam.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v2 4/4] KVM: arm64: Remove __vcpu_{read,write}_sys_reg_{from,to}_cpu()
Date: Sun, 17 Aug 2025 13:19:26 +0100
Message-Id: <20250817121926.217900-5-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250817121926.217900-1-maz@kernel.org>
References: <20250817121926.217900-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, volodymyr_babchuk@epam.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

There is no point having __vcpu_{read,write}_sys_reg_{from,to}_cpu()
exposed to the rest of the kernel, as the only callers are in
sys_regs.c.

Move them where they below, which is another opportunity to
simplify things a bit.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h | 107 ------------------------------
 arch/arm64/kvm/sys_regs.c         |  84 +++++++++++++++++++++--
 2 files changed, 80 insertions(+), 111 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index a9661d35bfd02..2b07f0a27a7d8 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1163,113 +1163,6 @@ u64 kvm_vcpu_apply_reg_masks(const struct kvm_vcpu *, enum vcpu_sysreg, u64);
 u64 vcpu_read_sys_reg(const struct kvm_vcpu *, enum vcpu_sysreg);
 void vcpu_write_sys_reg(struct kvm_vcpu *, u64, enum vcpu_sysreg);
 
-static inline bool __vcpu_read_sys_reg_from_cpu(int reg, u64 *val)
-{
-	/*
-	 * *** VHE ONLY ***
-	 *
-	 * System registers listed in the switch are not saved on every
-	 * exit from the guest but are only saved on vcpu_put.
-	 *
-	 * SYSREGS_ON_CPU *MUST* be checked before using this helper.
-	 *
-	 * Note that MPIDR_EL1 for the guest is set by KVM via VMPIDR_EL2 but
-	 * should never be listed below, because the guest cannot modify its
-	 * own MPIDR_EL1 and MPIDR_EL1 is accessed for VCPU A from VCPU B's
-	 * thread when emulating cross-VCPU communication.
-	 */
-	if (!has_vhe())
-		return false;
-
-	switch (reg) {
-	case SCTLR_EL1:		*val = read_sysreg_s(SYS_SCTLR_EL12);	break;
-	case CPACR_EL1:		*val = read_sysreg_s(SYS_CPACR_EL12);	break;
-	case TTBR0_EL1:		*val = read_sysreg_s(SYS_TTBR0_EL12);	break;
-	case TTBR1_EL1:		*val = read_sysreg_s(SYS_TTBR1_EL12);	break;
-	case TCR_EL1:		*val = read_sysreg_s(SYS_TCR_EL12);	break;
-	case TCR2_EL1:		*val = read_sysreg_s(SYS_TCR2_EL12);	break;
-	case PIR_EL1:		*val = read_sysreg_s(SYS_PIR_EL12);	break;
-	case PIRE0_EL1:		*val = read_sysreg_s(SYS_PIRE0_EL12);	break;
-	case POR_EL1:		*val = read_sysreg_s(SYS_POR_EL12);	break;
-	case ESR_EL1:		*val = read_sysreg_s(SYS_ESR_EL12);	break;
-	case AFSR0_EL1:		*val = read_sysreg_s(SYS_AFSR0_EL12);	break;
-	case AFSR1_EL1:		*val = read_sysreg_s(SYS_AFSR1_EL12);	break;
-	case FAR_EL1:		*val = read_sysreg_s(SYS_FAR_EL12);	break;
-	case MAIR_EL1:		*val = read_sysreg_s(SYS_MAIR_EL12);	break;
-	case VBAR_EL1:		*val = read_sysreg_s(SYS_VBAR_EL12);	break;
-	case CONTEXTIDR_EL1:	*val = read_sysreg_s(SYS_CONTEXTIDR_EL12);break;
-	case TPIDR_EL0:		*val = read_sysreg_s(SYS_TPIDR_EL0);	break;
-	case TPIDRRO_EL0:	*val = read_sysreg_s(SYS_TPIDRRO_EL0);	break;
-	case TPIDR_EL1:		*val = read_sysreg_s(SYS_TPIDR_EL1);	break;
-	case AMAIR_EL1:		*val = read_sysreg_s(SYS_AMAIR_EL12);	break;
-	case CNTKCTL_EL1:	*val = read_sysreg_s(SYS_CNTKCTL_EL12);	break;
-	case ELR_EL1:		*val = read_sysreg_s(SYS_ELR_EL12);	break;
-	case SPSR_EL1:		*val = read_sysreg_s(SYS_SPSR_EL12);	break;
-	case PAR_EL1:		*val = read_sysreg_par();		break;
-	case DACR32_EL2:	*val = read_sysreg_s(SYS_DACR32_EL2);	break;
-	case IFSR32_EL2:	*val = read_sysreg_s(SYS_IFSR32_EL2);	break;
-	case DBGVCR32_EL2:	*val = read_sysreg_s(SYS_DBGVCR32_EL2);	break;
-	case ZCR_EL1:		*val = read_sysreg_s(SYS_ZCR_EL12);	break;
-	case SCTLR2_EL1:	*val = read_sysreg_s(SYS_SCTLR2_EL12);	break;
-	default:		return false;
-	}
-
-	return true;
-}
-
-static inline bool __vcpu_write_sys_reg_to_cpu(u64 val, int reg)
-{
-	/*
-	 * *** VHE ONLY ***
-	 *
-	 * System registers listed in the switch are not restored on every
-	 * entry to the guest but are only restored on vcpu_load.
-	 *
-	 * SYSREGS_ON_CPU *MUST* be checked before using this helper.
-	 *
-	 * Note that MPIDR_EL1 for the guest is set by KVM via VMPIDR_EL2 but
-	 * should never be listed below, because the MPIDR should only be set
-	 * once, before running the VCPU, and never changed later.
-	 */
-	if (!has_vhe())
-		return false;
-
-	switch (reg) {
-	case SCTLR_EL1:		write_sysreg_s(val, SYS_SCTLR_EL12);	break;
-	case CPACR_EL1:		write_sysreg_s(val, SYS_CPACR_EL12);	break;
-	case TTBR0_EL1:		write_sysreg_s(val, SYS_TTBR0_EL12);	break;
-	case TTBR1_EL1:		write_sysreg_s(val, SYS_TTBR1_EL12);	break;
-	case TCR_EL1:		write_sysreg_s(val, SYS_TCR_EL12);	break;
-	case TCR2_EL1:		write_sysreg_s(val, SYS_TCR2_EL12);	break;
-	case PIR_EL1:		write_sysreg_s(val, SYS_PIR_EL12);	break;
-	case PIRE0_EL1:		write_sysreg_s(val, SYS_PIRE0_EL12);	break;
-	case POR_EL1:		write_sysreg_s(val, SYS_POR_EL12);	break;
-	case ESR_EL1:		write_sysreg_s(val, SYS_ESR_EL12);	break;
-	case AFSR0_EL1:		write_sysreg_s(val, SYS_AFSR0_EL12);	break;
-	case AFSR1_EL1:		write_sysreg_s(val, SYS_AFSR1_EL12);	break;
-	case FAR_EL1:		write_sysreg_s(val, SYS_FAR_EL12);	break;
-	case MAIR_EL1:		write_sysreg_s(val, SYS_MAIR_EL12);	break;
-	case VBAR_EL1:		write_sysreg_s(val, SYS_VBAR_EL12);	break;
-	case CONTEXTIDR_EL1:	write_sysreg_s(val, SYS_CONTEXTIDR_EL12);break;
-	case TPIDR_EL0:		write_sysreg_s(val, SYS_TPIDR_EL0);	break;
-	case TPIDRRO_EL0:	write_sysreg_s(val, SYS_TPIDRRO_EL0);	break;
-	case TPIDR_EL1:		write_sysreg_s(val, SYS_TPIDR_EL1);	break;
-	case AMAIR_EL1:		write_sysreg_s(val, SYS_AMAIR_EL12);	break;
-	case CNTKCTL_EL1:	write_sysreg_s(val, SYS_CNTKCTL_EL12);	break;
-	case ELR_EL1:		write_sysreg_s(val, SYS_ELR_EL12);	break;
-	case SPSR_EL1:		write_sysreg_s(val, SYS_SPSR_EL12);	break;
-	case PAR_EL1:		write_sysreg_s(val, SYS_PAR_EL1);	break;
-	case DACR32_EL2:	write_sysreg_s(val, SYS_DACR32_EL2);	break;
-	case IFSR32_EL2:	write_sysreg_s(val, SYS_IFSR32_EL2);	break;
-	case DBGVCR32_EL2:	write_sysreg_s(val, SYS_DBGVCR32_EL2);	break;
-	case ZCR_EL1:		write_sysreg_s(val, SYS_ZCR_EL12);	break;
-	case SCTLR2_EL1:	write_sysreg_s(val, SYS_SCTLR2_EL12);	break;
-	default:		return false;
-	}
-
-	return true;
-}
-
 struct kvm_vm_stat {
 	struct kvm_vm_stat_generic generic;
 };
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index b27ddb15d9909..bb61819db7548 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -216,6 +216,82 @@ static void locate_register(const struct kvm_vcpu *vcpu, enum vcpu_sysreg reg,
 	}
 }
 
+static u64 read_sr_from_cpu(enum vcpu_sysreg reg)
+{
+	u64 val = 0x8badf00d8badf00d;
+
+	switch (reg) {
+	case SCTLR_EL1:		val = read_sysreg_s(SYS_SCTLR_EL12);	break;
+	case CPACR_EL1:		val = read_sysreg_s(SYS_CPACR_EL12);	break;
+	case TTBR0_EL1:		val = read_sysreg_s(SYS_TTBR0_EL12);	break;
+	case TTBR1_EL1:		val = read_sysreg_s(SYS_TTBR1_EL12);	break;
+	case TCR_EL1:		val = read_sysreg_s(SYS_TCR_EL12);	break;
+	case TCR2_EL1:		val = read_sysreg_s(SYS_TCR2_EL12);	break;
+	case PIR_EL1:		val = read_sysreg_s(SYS_PIR_EL12);	break;
+	case PIRE0_EL1:		val = read_sysreg_s(SYS_PIRE0_EL12);	break;
+	case POR_EL1:		val = read_sysreg_s(SYS_POR_EL12);	break;
+	case ESR_EL1:		val = read_sysreg_s(SYS_ESR_EL12);	break;
+	case AFSR0_EL1:		val = read_sysreg_s(SYS_AFSR0_EL12);	break;
+	case AFSR1_EL1:		val = read_sysreg_s(SYS_AFSR1_EL12);	break;
+	case FAR_EL1:		val = read_sysreg_s(SYS_FAR_EL12);	break;
+	case MAIR_EL1:		val = read_sysreg_s(SYS_MAIR_EL12);	break;
+	case VBAR_EL1:		val = read_sysreg_s(SYS_VBAR_EL12);	break;
+	case CONTEXTIDR_EL1:	val = read_sysreg_s(SYS_CONTEXTIDR_EL12);break;
+	case AMAIR_EL1:		val = read_sysreg_s(SYS_AMAIR_EL12);	break;
+	case CNTKCTL_EL1:	val = read_sysreg_s(SYS_CNTKCTL_EL12);	break;
+	case ELR_EL1:		val = read_sysreg_s(SYS_ELR_EL12);	break;
+	case SPSR_EL1:		val = read_sysreg_s(SYS_SPSR_EL12);	break;
+	case ZCR_EL1:		val = read_sysreg_s(SYS_ZCR_EL12);	break;
+	case SCTLR2_EL1:	val = read_sysreg_s(SYS_SCTLR2_EL12);	break;
+	case TPIDR_EL0:		val = read_sysreg_s(SYS_TPIDR_EL0);	break;
+	case TPIDRRO_EL0:	val = read_sysreg_s(SYS_TPIDRRO_EL0);	break;
+	case TPIDR_EL1:		val = read_sysreg_s(SYS_TPIDR_EL1);	break;
+	case PAR_EL1:		val = read_sysreg_par();		break;
+	case DACR32_EL2:	val = read_sysreg_s(SYS_DACR32_EL2);	break;
+	case IFSR32_EL2:	val = read_sysreg_s(SYS_IFSR32_EL2);	break;
+	case DBGVCR32_EL2:	val = read_sysreg_s(SYS_DBGVCR32_EL2);	break;
+	default:		WARN_ON_ONCE(1);
+	}
+
+	return val;
+}
+
+static void write_sr_to_cpu(enum vcpu_sysreg reg, u64 val)
+{
+	switch (reg) {
+	case SCTLR_EL1:		write_sysreg_s(val, SYS_SCTLR_EL12);	break;
+	case CPACR_EL1:		write_sysreg_s(val, SYS_CPACR_EL12);	break;
+	case TTBR0_EL1:		write_sysreg_s(val, SYS_TTBR0_EL12);	break;
+	case TTBR1_EL1:		write_sysreg_s(val, SYS_TTBR1_EL12);	break;
+	case TCR_EL1:		write_sysreg_s(val, SYS_TCR_EL12);	break;
+	case TCR2_EL1:		write_sysreg_s(val, SYS_TCR2_EL12);	break;
+	case PIR_EL1:		write_sysreg_s(val, SYS_PIR_EL12);	break;
+	case PIRE0_EL1:		write_sysreg_s(val, SYS_PIRE0_EL12);	break;
+	case POR_EL1:		write_sysreg_s(val, SYS_POR_EL12);	break;
+	case ESR_EL1:		write_sysreg_s(val, SYS_ESR_EL12);	break;
+	case AFSR0_EL1:		write_sysreg_s(val, SYS_AFSR0_EL12);	break;
+	case AFSR1_EL1:		write_sysreg_s(val, SYS_AFSR1_EL12);	break;
+	case FAR_EL1:		write_sysreg_s(val, SYS_FAR_EL12);	break;
+	case MAIR_EL1:		write_sysreg_s(val, SYS_MAIR_EL12);	break;
+	case VBAR_EL1:		write_sysreg_s(val, SYS_VBAR_EL12);	break;
+	case CONTEXTIDR_EL1:	write_sysreg_s(val, SYS_CONTEXTIDR_EL12);break;
+	case AMAIR_EL1:		write_sysreg_s(val, SYS_AMAIR_EL12);	break;
+	case CNTKCTL_EL1:	write_sysreg_s(val, SYS_CNTKCTL_EL12);	break;
+	case ELR_EL1:		write_sysreg_s(val, SYS_ELR_EL12);	break;
+	case SPSR_EL1:		write_sysreg_s(val, SYS_SPSR_EL12);	break;
+	case ZCR_EL1:		write_sysreg_s(val, SYS_ZCR_EL12);	break;
+	case SCTLR2_EL1:	write_sysreg_s(val, SYS_SCTLR2_EL12);	break;
+	case TPIDR_EL0:		write_sysreg_s(val, SYS_TPIDR_EL0);	break;
+	case TPIDRRO_EL0:	write_sysreg_s(val, SYS_TPIDRRO_EL0);	break;
+	case TPIDR_EL1:		write_sysreg_s(val, SYS_TPIDR_EL1);	break;
+	case PAR_EL1:		write_sysreg_s(val, SYS_PAR_EL1);	break;
+	case DACR32_EL2:	write_sysreg_s(val, SYS_DACR32_EL2);	break;
+	case IFSR32_EL2:	write_sysreg_s(val, SYS_IFSR32_EL2);	break;
+	case DBGVCR32_EL2:	write_sysreg_s(val, SYS_DBGVCR32_EL2);	break;
+	default:		WARN_ON_ONCE(1);
+	}
+}
+
 u64 vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, enum vcpu_sysreg reg)
 {
 	struct sr_loc loc = {};
@@ -246,13 +322,13 @@ u64 vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, enum vcpu_sysreg reg)
 
 	if (loc.loc & SR_LOC_LOADED) {
 		enum vcpu_sysreg map_reg = reg;
-		u64 val = 0x8badf00d8badf00d;
 
 		if (loc.loc & SR_LOC_MAPPED)
 			map_reg = loc.map_reg;
 
-		if (!(loc.loc & SR_LOC_XLATED) &&
-		    __vcpu_read_sys_reg_from_cpu(map_reg, &val)) {
+		if (!(loc.loc & SR_LOC_XLATED)) {
+			u64 val = read_sr_from_cpu(map_reg);
+
 			if (reg >= __SANITISED_REG_START__)
 				val = kvm_vcpu_apply_reg_masks(vcpu, reg, val);
 
@@ -304,7 +380,7 @@ void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, enum vcpu_sysreg reg)
 		else
 			xlated_val = val;
 
-		__vcpu_write_sys_reg_to_cpu(xlated_val, map_reg);
+		write_sr_to_cpu(map_reg, xlated_val);
 
 		/*
 		 * Fall through to write the backing store anyway, which
-- 
2.39.2


