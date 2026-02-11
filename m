Return-Path: <kvm+bounces-70844-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UKQCBLiAjGl9pwAAu9opvQ
	(envelope-from <kvm+bounces-70844-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 14:14:32 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 66FC9124ADB
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 14:14:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2B7D13018D7D
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 13:13:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03DA8322B6F;
	Wed, 11 Feb 2026 13:13:11 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE58D34EF06
	for <kvm@vger.kernel.org>; Wed, 11 Feb 2026 13:13:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770815590; cv=none; b=pGw96F/tdKeWXAVNiJo4opCv+vVGza58k8LoMVL/ljLfKwYZdeqE7SwKjkfjDsg2U9v9ADTDbK6S8F+KHn4Pziut6XYgUcEl1jFzN0sYw0Ubm4WuKsDQnzsct7nyWS+EY4HXDanMjaB8skyv+tghxj4h/O0LkGlCKvJNNhMTvNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770815590; c=relaxed/simple;
	bh=alrf6TfuhUPofETleLNrR3lGep1rMhDWTYKqFVhS+1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hui1RVUJ0dmDANKm/qT4bXpDNToymw7UT/XWtnjfwZk9MidXu6yIqhGaByePZl2Szbi2DLdODSnspV1eoJznQpZC9HXGKhvHP8RtaXkvM3oFEKlommlxRX/UcwLzQKNxoCt+gz6aHIj+g+wNasVLWBOmfthQx+wf4ZwSidOzTZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 28167339;
	Wed, 11 Feb 2026 05:13:02 -0800 (PST)
Received: from orionap.fritz.box (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C885A3F63F;
	Wed, 11 Feb 2026 05:13:06 -0800 (PST)
From: Andre Przywara <andre.przywara@arm.com>
To: Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>
Cc: Marc Zyngier <maz@kernel.org>,
	Sascha Bischoff <Sascha.Bischoff@arm.com>,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PATCH kvmtool v6 6/6] arm64: Handle virtio endianness reset when running nested
Date: Wed, 11 Feb 2026 13:12:49 +0000
Message-ID: <20260211131249.399019-7-andre.przywara@arm.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260211131249.399019-1-andre.przywara@arm.com>
References: <20260211131249.399019-1-andre.przywara@arm.com>
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
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	DMARC_POLICY_SOFTFAIL(0.10)[arm.com : SPF not aligned (relaxed), No valid DKIM,none];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[kernel.org,gmail.com];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70844-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[andre.przywara@arm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_SEVEN(0.00)[7];
	R_DKIM_NA(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,arm.com:mid,arm.com:email,reg.id:url,sctlr_el1.ee:url]
X-Rspamd-Queue-Id: 66FC9124ADB
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
index 1af394a..85646ad 100644
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
index 5e4f3a7..35e1c63 100644
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
2.47.3


