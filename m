Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B353298E01
	for <lists+kvm@lfdr.de>; Mon, 26 Oct 2020 14:35:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1780207AbgJZNfL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Oct 2020 09:35:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:37816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1780179AbgJZNfH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Oct 2020 09:35:07 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C20A624650;
        Mon, 26 Oct 2020 13:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603719306;
        bh=Bw8RYaSu4lVX/3CgDwCjtTz5WUN0IrkzwxZidOUEw64=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AKl/3xEOlUvDLpOC4Sob96+NjaAP4VDqs7zFs71V45HaOZ0s+L6ZzKdve3NETV8Tb
         b+DhbdzT8hmQZfPpGpiBMLo6VrlfqIOO9/l48O2u7lOBlh+U5VzzUaA2/fwHzrRpxK
         tK8Yris3bkWsp/2+1R4/4KI+689oCZvyJnyMwNEc=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1kX2eP-004Kjh-19; Mon, 26 Oct 2020 13:35:05 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Andrew Scull <ascull@google.com>,
        Will Deacon <will@kernel.org>,
        Quentin Perret <qperret@google.com>,
        David Brazdil <dbrazdil@google.com>, kernel-team@android.com
Subject: [PATCH 06/11] KVM: arm64: Add basic hooks for injecting exceptions from EL2
Date:   Mon, 26 Oct 2020 13:34:45 +0000
Message-Id: <20201026133450.73304-7-maz@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201026133450.73304-1-maz@kernel.org>
References: <20201026133450.73304-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, ascull@google.com, will@kernel.org, qperret@google.com, dbrazdil@google.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add the basic infrastructure to describe injection of exceptions
into a guest. So far, nothing uses this code path.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h          | 31 ++++++++++++++++++++--
 arch/arm64/kvm/hyp/exception.c             | 17 ++++++++++++
 arch/arm64/kvm/hyp/include/hyp/adjust_pc.h | 10 +++++--
 arch/arm64/kvm/hyp/nvhe/Makefile           |  2 +-
 arch/arm64/kvm/hyp/vhe/Makefile            |  2 +-
 5 files changed, 56 insertions(+), 6 deletions(-)
 create mode 100644 arch/arm64/kvm/hyp/exception.c

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 0ae51093013d..be909377510b 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -406,9 +406,36 @@ struct kvm_vcpu_arch {
 #define KVM_ARM64_GUEST_HAS_SVE		(1 << 5) /* SVE exposed to guest */
 #define KVM_ARM64_VCPU_SVE_FINALIZED	(1 << 6) /* SVE config completed */
 #define KVM_ARM64_GUEST_HAS_PTRAUTH	(1 << 7) /* PTRAUTH exposed to guest */
-#define KVM_ARM64_INCREMENT_PC		(1 << 8) /* Increment PC */
+#define KVM_ARM64_PENDING_EXCEPTION	(1 << 8) /* Exception pending */
+#define KVM_ARM64_EXCEPT_MASK		(7 << 9) /* Target EL/MODE */
 
-#define vcpu_has_sve(vcpu) (system_supports_sve() && \
+/*
+ * When KVM_ARM64_PENDING_EXCEPTION is set, KVM_ARM64_EXCEPT_MASK can
+ * take the following values:
+ *
+ * For AArch32 EL1:
+ */
+#define KVM_ARM64_EXCEPT_AA32_UND	(0 << 9)
+#define KVM_ARM64_EXCEPT_AA32_IABT	(1 << 9)
+#define KVM_ARM64_EXCEPT_AA32_DABT	(2 << 9)
+/* For AArch64 EL1: */
+#define KVM_ARM64_EXCEPT_AA64_EL1_SYNC	(0 << 9)
+#define KVM_ARM64_EXCEPT_AA64_EL1_IRQ	(1 << 9)
+#define KVM_ARM64_EXCEPT_AA64_EL1_FIQ	(2 << 9)
+#define KVM_ARM64_EXCEPT_AA64_EL1_SERR	(3 << 9)
+/* For AArch64 EL2 (with NV): */
+#define KVM_ARM64_EXCEPT_AA64_EL2_SYNC	(4 << 9)
+#define KVM_ARM64_EXCEPT_AA64_EL2_IRQ	(5 << 9)
+#define KVM_ARM64_EXCEPT_AA64_EL2_FIQ	(6 << 9)
+#define KVM_ARM64_EXCEPT_AA64_EL2_SERR	(7 << 9)
+
+/*
+ * Overlaps with KVM_ARM64_EXCEPT_MASK on purpose so that it can't be
+ * set together with an exception...
+ */
+#define KVM_ARM64_INCREMENT_PC		(1 << 9) /* Increment PC */
+
+#define vcpu_has_sve(vcpu) (system_supports_sve() &&			\
 			    ((vcpu)->arch.flags & KVM_ARM64_GUEST_HAS_SVE))
 
 #ifdef CONFIG_ARM64_PTR_AUTH
diff --git a/arch/arm64/kvm/hyp/exception.c b/arch/arm64/kvm/hyp/exception.c
new file mode 100644
index 000000000000..6533a9270850
--- /dev/null
+++ b/arch/arm64/kvm/hyp/exception.c
@@ -0,0 +1,17 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Fault injection for both 32 and 64bit guests.
+ *
+ * Copyright (C) 2012,2013 - ARM Ltd
+ * Author: Marc Zyngier <marc.zyngier@arm.com>
+ *
+ * Based on arch/arm/kvm/emulate.c
+ * Copyright (C) 2012 - Virtual Open Systems and Columbia University
+ * Author: Christoffer Dall <c.dall@virtualopensystems.com>
+ */
+
+#include <hyp/adjust_pc.h>
+
+void kvm_inject_exception(struct kvm_vcpu *vcpu)
+{
+}
diff --git a/arch/arm64/kvm/hyp/include/hyp/adjust_pc.h b/arch/arm64/kvm/hyp/include/hyp/adjust_pc.h
index 4ecaf5cb2633..c14e71f1c404 100644
--- a/arch/arm64/kvm/hyp/include/hyp/adjust_pc.h
+++ b/arch/arm64/kvm/hyp/include/hyp/adjust_pc.h
@@ -13,6 +13,8 @@
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_host.h>
 
+void kvm_inject_exception(struct kvm_vcpu *vcpu);
+
 static inline void kvm_skip_instr(struct kvm_vcpu *vcpu)
 {
 	if (vcpu_mode_is_32bit(vcpu)) {
@@ -43,11 +45,15 @@ static inline void __kvm_skip_instr(struct kvm_vcpu *vcpu)
 
 /*
  * Adjust the guest PC on entry, depending on flags provided by EL1
- * for the purpose of emulation (MMIO, sysreg).
+ * for the purpose of emulation (MMIO, sysreg) or exception injection.
  */
 static inline void __adjust_pc(struct kvm_vcpu *vcpu)
 {
-	if (vcpu->arch.flags & KVM_ARM64_INCREMENT_PC) {
+	if (vcpu->arch.flags & KVM_ARM64_PENDING_EXCEPTION) {
+		kvm_inject_exception(vcpu);
+		vcpu->arch.flags &= ~(KVM_ARM64_PENDING_EXCEPTION |
+				      KVM_ARM64_EXCEPT_MASK);
+	} else 	if (vcpu->arch.flags & KVM_ARM64_INCREMENT_PC) {
 		kvm_skip_instr(vcpu);
 		vcpu->arch.flags &= ~KVM_ARM64_INCREMENT_PC;
 	}
diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index ddde15fe85f2..77b8c4e06f2f 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -8,7 +8,7 @@ ccflags-y := -D__KVM_NVHE_HYPERVISOR__
 
 obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o host.o hyp-main.o
 obj-y += ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.o \
-	 ../fpsimd.o ../hyp-entry.o
+	 ../fpsimd.o ../hyp-entry.o ../exception.o
 
 ##
 ## Build rules for compiling nVHE hyp code
diff --git a/arch/arm64/kvm/hyp/vhe/Makefile b/arch/arm64/kvm/hyp/vhe/Makefile
index 461e97c375cc..96bec0ecf9dd 100644
--- a/arch/arm64/kvm/hyp/vhe/Makefile
+++ b/arch/arm64/kvm/hyp/vhe/Makefile
@@ -8,4 +8,4 @@ ccflags-y := -D__KVM_VHE_HYPERVISOR__
 
 obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o
 obj-y += ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.o \
-	 ../fpsimd.o ../hyp-entry.o
+	 ../fpsimd.o ../hyp-entry.o ../exception.o
-- 
2.28.0

