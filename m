Return-Path: <kvm+bounces-68972-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uFleA/yFc2krxAAAu9opvQ
	(envelope-from <kvm+bounces-68972-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 15:30:20 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CA3F77137
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 15:30:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 715533047DD9
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 14:28:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E02732C93B;
	Fri, 23 Jan 2026 14:28:30 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF0AF32860E
	for <kvm@vger.kernel.org>; Fri, 23 Jan 2026 14:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769178509; cv=none; b=R4XjIfjp5UtoVpGlJNyFjSVXsOAaUvXD6I/7OoBYJP7nmNeHZjcuw+xQLCgonin3EKpQueCyZ+kv6Al5w8Idk3cr53HZ0hCHybTb3Gs+XgnT5spCA9io8Rt49LeEAUi/WBwlwJHa5a0sKQKlLJKex86B3ztC2MFJnNIt8wiBtjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769178509; c=relaxed/simple;
	bh=eq1t1+g9UJ3juuwCMJmc7estKsJWG6W1oyB8JBKlOW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M0TcH6UdL6cRawHnDqUeLIL14dsK3mpEW0U0M+yLwxZGDfw3J28S977nkt6hscMgJioP7PmU0p8rHFcw1w0Vz0siHMkpiJv8tgmu87DU6rtVnBNmyc7u3UPFR4RhceKw4vBabAscCNjCPsWw7JD0mG8RZVDeMocH1RqbptjOGYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C05E61476;
	Fri, 23 Jan 2026 06:28:17 -0800 (PST)
Received: from e134369.cambridge.arm.com (e134369.arm.com [10.1.34.161])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B656E3F740;
	Fri, 23 Jan 2026 06:28:22 -0800 (PST)
From: Andre Przywara <andre.przywara@arm.com>
To: Julien Thierry <julien.thierry.kdev@gmail.com>,
	Will Deacon <will@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Sascha Bischoff <sascha.bischoff@arm.com>
Subject: [PATCH kvmtool v5 7/7] arm64: Handle virtio endianness reset when running nested
Date: Fri, 23 Jan 2026 14:27:29 +0000
Message-ID: <20260123142729.604737-8-andre.przywara@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260123142729.604737-1-andre.przywara@arm.com>
References: <20260123142729.604737-1-andre.przywara@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.64 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	DMARC_POLICY_SOFTFAIL(0.10)[arm.com : SPF not aligned (relaxed), No valid DKIM,none];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com,kernel.org];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-68972-lists,kvm=lfdr.de];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[andre.przywara@arm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	R_DKIM_NA(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	RCPT_COUNT_SEVEN(0.00)[7];
	DBL_BLOCKED_OPENRESOLVER(0.00)[reg.id:url,arm.com:mid,arm.com:email,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 7CA3F77137
X-Rspamd-Action: no action

From: Marc Zyngier <maz@kernel.org>

When running an EL2 guest, we need to make sure we don't sample
SCTLR_EL1 to work out the virtio endianness, as this is likely
to be a bit random.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 arm64/include/kvm/kvm-cpu-arch.h |  5 ++--
 arm64/kvm-cpu.c                  | 47 +++++++++++++++++++++++++-------
 2 files changed, 40 insertions(+), 12 deletions(-)

diff --git a/arm64/include/kvm/kvm-cpu-arch.h b/arm64/include/kvm/kvm-cpu-arch.h
index 1af394aa..85646ad4 100644
--- a/arm64/include/kvm/kvm-cpu-arch.h
+++ b/arm64/include/kvm/kvm-cpu-arch.h
@@ -10,8 +10,9 @@
 #define ARM_MPIDR_HWID_BITMASK	0xFF00FFFFFFUL
 #define ARM_CPU_ID		3, 0, 0, 0
 #define ARM_CPU_ID_MPIDR	5
-#define ARM_CPU_CTRL		3, 0, 1, 0
-#define ARM_CPU_CTRL_SCTLR_EL1	0
+#define SYS_SCTLR_EL1		3, 4, 1, 0, 0
+#define SYS_SCTLR_EL2		3, 4, 1, 0, 0
+#define SYS_HCR_EL2		3, 4, 1, 1, 0
 
 struct kvm_cpu {
 	pthread_t	thread;
diff --git a/arm64/kvm-cpu.c b/arm64/kvm-cpu.c
index 5e4f3a7d..35e1c639 100644
--- a/arm64/kvm-cpu.c
+++ b/arm64/kvm-cpu.c
@@ -12,6 +12,7 @@
 
 #define SCTLR_EL1_E0E_MASK	(1 << 24)
 #define SCTLR_EL1_EE_MASK	(1 << 25)
+#define HCR_EL2_TGE		(1 << 27)
 
 static int debug_fd;
 
@@ -408,7 +409,8 @@ int kvm_cpu__get_endianness(struct kvm_cpu *vcpu)
 {
 	struct kvm_one_reg reg;
 	u64 psr;
-	u64 sctlr;
+	u64 sctlr, bit;
+	u64 hcr = 0;
 
 	/*
 	 * Quoting the definition given by Peter Maydell:
@@ -419,8 +421,9 @@ int kvm_cpu__get_endianness(struct kvm_cpu *vcpu)
 	 * We first check for an AArch32 guest: its endianness can
 	 * change when using SETEND, which affects the CPSR.E bit.
 	 *
-	 * If we're AArch64, use SCTLR_EL1.E0E if access comes from
-	 * EL0, and SCTLR_EL1.EE if access comes from EL1.
+	 * If we're AArch64, determine which SCTLR register to use,
+	 * depending on NV being used or not. Then use either the E0E
+	 * bit for EL0, or the EE bit for EL1/EL2.
 	 */
 	reg.id = ARM64_CORE_REG(regs.pstate);
 	reg.addr = (u64)&psr;
@@ -430,16 +433,40 @@ int kvm_cpu__get_endianness(struct kvm_cpu *vcpu)
 	if (psr & PSR_MODE32_BIT)
 		return (psr & COMPAT_PSR_E_BIT) ? VIRTIO_ENDIAN_BE : VIRTIO_ENDIAN_LE;
 
-	reg.id = ARM64_SYS_REG(ARM_CPU_CTRL, ARM_CPU_CTRL_SCTLR_EL1);
+	if (vcpu->kvm->cfg.arch.nested_virt) {
+		reg.id = ARM64_SYS_REG(SYS_HCR_EL2);
+		reg.addr = (u64)&hcr;
+		if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+			die("KVM_GET_ONE_REG failed (HCR_EL2)");
+	}
+
+	switch (psr & PSR_MODE_MASK) {
+	case PSR_MODE_EL0t:
+		if (hcr & HCR_EL2_TGE)
+			reg.id = ARM64_SYS_REG(SYS_SCTLR_EL2);
+		else
+			reg.id = ARM64_SYS_REG(SYS_SCTLR_EL1);
+		bit = SCTLR_EL1_E0E_MASK;
+		break;
+	case PSR_MODE_EL1t:
+	case PSR_MODE_EL1h:
+		reg.id = ARM64_SYS_REG(SYS_SCTLR_EL1);
+		bit = SCTLR_EL1_EE_MASK;
+		break;
+	case PSR_MODE_EL2t:
+	case PSR_MODE_EL2h:
+		reg.id = ARM64_SYS_REG(SYS_SCTLR_EL2);
+		bit = SCTLR_EL1_EE_MASK;
+		break;
+	default:
+		die("What's that mode???\n");
+	}
+
 	reg.addr = (u64)&sctlr;
 	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
-		die("KVM_GET_ONE_REG failed (SCTLR_EL1)");
+		die("KVM_GET_ONE_REG failed (SCTLR_ELx)");
 
-	if ((psr & PSR_MODE_MASK) == PSR_MODE_EL0t)
-		sctlr &= SCTLR_EL1_E0E_MASK;
-	else
-		sctlr &= SCTLR_EL1_EE_MASK;
-	return sctlr ? VIRTIO_ENDIAN_BE : VIRTIO_ENDIAN_LE;
+	return (sctlr & bit) ? VIRTIO_ENDIAN_BE : VIRTIO_ENDIAN_LE;
 }
 
 void kvm_cpu__show_code(struct kvm_cpu *vcpu)
-- 
2.43.0


