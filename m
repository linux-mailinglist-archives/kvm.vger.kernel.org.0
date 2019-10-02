Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75A45C8BF3
	for <lists+kvm@lfdr.de>; Wed,  2 Oct 2019 16:51:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728693AbfJBOvL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Oct 2019 10:51:11 -0400
Received: from foss.arm.com ([217.140.110.172]:46328 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728680AbfJBOvK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Oct 2019 10:51:10 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1428715A1;
        Wed,  2 Oct 2019 07:51:10 -0700 (PDT)
Received: from e112269-lin.arm.com (e112269-lin.cambridge.arm.com [10.1.196.133])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 12BAE3F706;
        Wed,  2 Oct 2019 07:51:07 -0700 (PDT)
From:   Steven Price <steven.price@arm.com>
To:     Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc:     Steven Price <steven.price@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Pouloze <suzuki.poulose@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v5 08/10] arm/arm64: Provide a wrapper for SMCCC 1.1 calls
Date:   Wed,  2 Oct 2019 15:50:35 +0100
Message-Id: <20191002145037.51630-9-steven.price@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191002145037.51630-1-steven.price@arm.com>
References: <20191002145037.51630-1-steven.price@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SMCCC 1.1 calls may use either HVC or SMC depending on the PSCI
conduit. Rather than coding this in every call site provide a macro
which uses the correct instruction. The macro also handles the case
where no PSCI conduit is configured returning a not supported error
in res, along with returning the conduit used for the call.

This allow us to remove some duplicated code and will be useful later
when adding paravirtualized time hypervisor calls.

Signed-off-by: Steven Price <steven.price@arm.com>
Acked-by: Will Deacon <will@kernel.org>
---
 include/linux/arm-smccc.h | 44 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
index e7f129f26ebd..eee1e832221d 100644
--- a/include/linux/arm-smccc.h
+++ b/include/linux/arm-smccc.h
@@ -303,6 +303,50 @@ asmlinkage void __arm_smccc_hvc(unsigned long a0, unsigned long a1,
 #define SMCCC_RET_NOT_SUPPORTED			-1
 #define SMCCC_RET_NOT_REQUIRED			-2
 
+/* Like arm_smccc_1_1* but always returns SMCCC_RET_NOT_SUPPORTED.
+ * Used when the PSCI conduit is not defined. The empty asm statement
+ * avoids compiler warnings about unused variables.
+ */
+#define __fail_smccc_1_1(...)						\
+	do {								\
+		__declare_args(__count_args(__VA_ARGS__), __VA_ARGS__);	\
+		asm ("" __constraints(__count_args(__VA_ARGS__)));	\
+		if (___res)						\
+			___res->a0 = SMCCC_RET_NOT_SUPPORTED;		\
+	} while (0)
+
+/*
+ * arm_smccc_1_1_invoke() - make an SMCCC v1.1 compliant call
+ *
+ * This is a variadic macro taking one to eight source arguments, and
+ * an optional return structure.
+ *
+ * @a0-a7: arguments passed in registers 0 to 7
+ * @res: result values from registers 0 to 3
+ *
+ * This macro will make either an HVC call or an SMC call depending on the
+ * current PSCI conduit. If no valid conduit is available then -1
+ * (SMCCC_RET_NOT_SUPPORTED) is returned in @res.a0 (if supplied).
+ *
+ * The return value also provides the conduit that was used.
+ */
+#define arm_smccc_1_1_invoke(...) ({					\
+		int method = psci_ops.conduit;				\
+		switch (method) {					\
+		case PSCI_CONDUIT_HVC:					\
+			arm_smccc_1_1_hvc(__VA_ARGS__);			\
+			break;						\
+		case PSCI_CONDUIT_SMC:					\
+			arm_smccc_1_1_smc(__VA_ARGS__);			\
+			break;						\
+		default:						\
+			__fail_smccc_1_1(__VA_ARGS__);			\
+			method = PSCI_CONDUIT_NONE;			\
+			break;						\
+		}							\
+		method;							\
+	})
+
 /* Paravirtualised time calls (defined by ARM DEN0057A) */
 #define ARM_SMCCC_HV_PV_FEATURES				\
 	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,			\
-- 
2.20.1

