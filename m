Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 029CC3CA268
	for <lists+kvm@lfdr.de>; Thu, 15 Jul 2021 18:32:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231954AbhGOQfS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jul 2021 12:35:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:43018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231633AbhGOQfM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jul 2021 12:35:12 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B693D613FB;
        Thu, 15 Jul 2021 16:32:18 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1m44HZ-00DYjr-3w; Thu, 15 Jul 2021 17:32:17 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     will@kernel.org, qperret@google.com, dbrazdil@google.com,
        Srivatsa Vaddagiri <vatsa@codeaurora.org>,
        Shanker R Donthineni <sdonthineni@nvidia.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
Subject: [PATCH 07/16] KVM: arm64: Wire MMIO guard hypercalls
Date:   Thu, 15 Jul 2021 17:31:50 +0100
Message-Id: <20210715163159.1480168-8-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210715163159.1480168-1-maz@kernel.org>
References: <20210715163159.1480168-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, will@kernel.org, qperret@google.com, dbrazdil@google.com, vatsa@codeaurora.org, sdonthineni@nvidia.com, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Plumb in the hypercall interface to allow a guest to discover,
enroll, map and unmap MMIO regions.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hypercalls.c | 20 ++++++++++++++++++++
 include/linux/arm-smccc.h   | 28 ++++++++++++++++++++++++++++
 2 files changed, 48 insertions(+)

diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index 30da78f72b3b..a3deeb907fdd 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -5,6 +5,7 @@
 #include <linux/kvm_host.h>
 
 #include <asm/kvm_emulate.h>
+#include <asm/kvm_mmu.h>
 
 #include <kvm/arm_hypercalls.h>
 #include <kvm/arm_psci.h>
@@ -129,10 +130,29 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
 	case ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID:
 		val[0] = BIT(ARM_SMCCC_KVM_FUNC_FEATURES);
 		val[0] |= BIT(ARM_SMCCC_KVM_FUNC_PTP);
+		val[0] |= BIT(ARM_SMCCC_KVM_FUNC_MMIO_GUARD_INFO);
+		val[0] |= BIT(ARM_SMCCC_KVM_FUNC_MMIO_GUARD_ENROLL);
+		val[0] |= BIT(ARM_SMCCC_KVM_FUNC_MMIO_GUARD_MAP);
+		val[0] |= BIT(ARM_SMCCC_KVM_FUNC_MMIO_GUARD_UNMAP);
 		break;
 	case ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID:
 		kvm_ptp_get_time(vcpu, val);
 		break;
+	case ARM_SMCCC_VENDOR_HYP_KVM_MMIO_GUARD_INFO_FUNC_ID:
+		val[0] = PAGE_SIZE;
+		break;
+	case ARM_SMCCC_VENDOR_HYP_KVM_MMIO_GUARD_ENROLL_FUNC_ID:
+		set_bit(KVM_ARCH_FLAG_MMIO_GUARD, &vcpu->kvm->arch.flags);
+		val[0] = SMCCC_RET_SUCCESS;
+		break;
+	case ARM_SMCCC_VENDOR_HYP_KVM_MMIO_GUARD_MAP_FUNC_ID:
+		if (kvm_install_ioguard_page(vcpu, vcpu_get_reg(vcpu, 1)))
+			val[0] = SMCCC_RET_SUCCESS;
+		break;
+	case ARM_SMCCC_VENDOR_HYP_KVM_MMIO_GUARD_UNMAP_FUNC_ID:
+		if (kvm_remove_ioguard_page(vcpu, vcpu_get_reg(vcpu, 1)))
+			val[0] = SMCCC_RET_SUCCESS;
+		break;
 	case ARM_SMCCC_TRNG_VERSION:
 	case ARM_SMCCC_TRNG_FEATURES:
 	case ARM_SMCCC_TRNG_GET_UUID:
diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
index 7d1cabe15262..4aab2078d8d3 100644
--- a/include/linux/arm-smccc.h
+++ b/include/linux/arm-smccc.h
@@ -107,6 +107,10 @@
 /* KVM "vendor specific" services */
 #define ARM_SMCCC_KVM_FUNC_FEATURES		0
 #define ARM_SMCCC_KVM_FUNC_PTP			1
+#define ARM_SMCCC_KVM_FUNC_MMIO_GUARD_INFO	2
+#define ARM_SMCCC_KVM_FUNC_MMIO_GUARD_ENROLL	3
+#define ARM_SMCCC_KVM_FUNC_MMIO_GUARD_MAP	4
+#define ARM_SMCCC_KVM_FUNC_MMIO_GUARD_UNMAP	5
 #define ARM_SMCCC_KVM_FUNC_FEATURES_2		127
 #define ARM_SMCCC_KVM_NUM_FUNCS			128
 
@@ -133,6 +137,30 @@
 #define KVM_PTP_VIRT_COUNTER			0
 #define KVM_PTP_PHYS_COUNTER			1
 
+#define ARM_SMCCC_VENDOR_HYP_KVM_MMIO_GUARD_INFO_FUNC_ID		\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
+			   ARM_SMCCC_SMC_64,				\
+			   ARM_SMCCC_OWNER_VENDOR_HYP,			\
+			   ARM_SMCCC_KVM_FUNC_MMIO_GUARD_INFO)
+
+#define ARM_SMCCC_VENDOR_HYP_KVM_MMIO_GUARD_ENROLL_FUNC_ID		\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
+			   ARM_SMCCC_SMC_64,				\
+			   ARM_SMCCC_OWNER_VENDOR_HYP,			\
+			   ARM_SMCCC_KVM_FUNC_MMIO_GUARD_ENROLL)
+
+#define ARM_SMCCC_VENDOR_HYP_KVM_MMIO_GUARD_MAP_FUNC_ID			\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
+			   ARM_SMCCC_SMC_64,				\
+			   ARM_SMCCC_OWNER_VENDOR_HYP,			\
+			   ARM_SMCCC_KVM_FUNC_MMIO_GUARD_MAP)
+
+#define ARM_SMCCC_VENDOR_HYP_KVM_MMIO_GUARD_UNMAP_FUNC_ID		\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
+			   ARM_SMCCC_SMC_64,				\
+			   ARM_SMCCC_OWNER_VENDOR_HYP,			\
+			   ARM_SMCCC_KVM_FUNC_MMIO_GUARD_UNMAP)
+
 /* Paravirtualised time calls (defined by ARM DEN0057A) */
 #define ARM_SMCCC_HV_PV_TIME_FEATURES				\
 	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,			\
-- 
2.30.2

