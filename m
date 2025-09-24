Return-Path: <kvm+bounces-58645-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 13EF8B9A19A
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 15:46:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CC4694C6C79
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 13:46:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F8B8304971;
	Wed, 24 Sep 2025 13:45:32 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2AD43054E5
	for <kvm@vger.kernel.org>; Wed, 24 Sep 2025 13:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758721532; cv=none; b=ladrVKHsCwSs0/CySPPcHTC2IzF9sn52ZZ31luUQWo0jpjYFCfBAyHJxDiOncRIIFRAJdyAUB1H+qdE/DfTp1vhHX//dKvV2hEiETo/cbqGZqKT4RTsfvN1YOmF/ubn7lOybt3HAAu1LU7I9bHjnh3pgpOSY65lwdruwY/Py8is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758721532; c=relaxed/simple;
	bh=2mN9XbW7hJTizXzXLHOkcHcxjAwDiWUZNQ85HD/JFA8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kMVGpcsK5nIQu1zqAbevMcawQlUAncy2H8srACJXRImIpYNGDI1UCl/lA2Dycj4whO5pDPa1OF/qTKQ2ToMo0VgnxhGeyWpuSMVJvSlvefAAMvtg3A4YQjAJ13Mxyfu1IZZe3zGRehI5nybDP3DZYM0A4zLySm0qPDxZmhjkeMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 995801CE0;
	Wed, 24 Sep 2025 06:45:21 -0700 (PDT)
Received: from donnerap.arm.com (donnerap.manchester.arm.com [10.33.8.67])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BF5E43F5A1;
	Wed, 24 Sep 2025 06:45:28 -0700 (PDT)
From: Andre Przywara <andre.przywara@arm.com>
To: Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>
Cc: Marc Zyngier <maz@kernel.org>,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PATCH kvmtool v4 7/7] arm64: Handle virtio endianness reset when running nested
Date: Wed, 24 Sep 2025 14:45:11 +0100
Message-Id: <20250924134511.4109935-8-andre.przywara@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250924134511.4109935-1-andre.przywara@arm.com>
References: <20250924134511.4109935-1-andre.przywara@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
index 1af394aa3..85646ad4c 100644
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
index 5e4f3a7dd..35e1c6396 100644
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
2.25.1


