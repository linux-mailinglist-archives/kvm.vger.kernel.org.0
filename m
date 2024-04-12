Return-Path: <kvm+bounces-14489-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5391F8A2C66
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 12:34:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 76A951C220B9
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 10:34:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8627143AD8;
	Fri, 12 Apr 2024 10:34:27 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 863C941775
	for <kvm@vger.kernel.org>; Fri, 12 Apr 2024 10:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712918067; cv=none; b=eLEWCBTvu2RFDkaUnyHQ9P7mZy1/CvpCh71YH3J6yg9zfv549TLh3Ug9NecT2XzDa/aboIpPXNofF2SMdSYDl+5uKcbwu37cz+rOVXgS3TE5H+D3B11CRleak/4TFI2FJQ+gmRouUCURz81QTBKnABEvbBh7ITzgDzleook8M94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712918067; c=relaxed/simple;
	bh=FgH/8P4RiCQfQExC4AQHl9664bHgteAsXFIAHF/5Un8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YZBSMH2fYELQdmGc1iHG0wazetbsE7hJ3+n2Ng0XLL5VN/V12lCATMUrVoLkdYD7d/I+DVVR4MVndB6nXQWVhJ/R0fiRz/WMPL1br+JEuwhplxxcddfaRh/6ja6DV2BTF1HsQ5uh9u/5eYEZxenuTDjeT91mMPbFog9EBjEWUIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 41252339;
	Fri, 12 Apr 2024 03:34:54 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 496213F64C;
	Fri, 12 Apr 2024 03:34:23 -0700 (PDT)
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	linux-coco@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	maz@kernel.org,
	alexandru.elisei@arm.com,
	joey.gouly@arm.com,
	steven.price@arm.com,
	james.morse@arm.com,
	oliver.upton@linux.dev,
	yuzenghui@huawei.com,
	andrew.jones@linux.dev,
	eric.auger@redhat.com,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [kvm-unit-tests PATCH 03/33] arm64: Expand SMCCC arguments and return values
Date: Fri, 12 Apr 2024 11:33:38 +0100
Message-Id: <20240412103408.2706058-4-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240412103408.2706058-1-suzuki.poulose@arm.com>
References: <20240412103408.2706058-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alexandru Elisei <alexandru.elisei@arm.com>

PSCI uses the SMC Calling Convention (SMCCC) to communicate with the higher
level software. PSCI uses at most 4 arguments and expend only one return
value. However, SMCCC has provisions for more arguments (upto 17 depending
on the SMCCC version) and upto 10 distinct return values.

We are going to be adding tests that make use of it, so add support for the
extended number of arguments and return values.

Also rename the SMCCC functions to generic, non-PSCI names, so they
can be used for Realm services.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
Co-developed-by: Joey Gouly <joey.gouly@arm.com>
Signed-off-by: Joey Gouly <joey.gouly@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arm/cstart.S              | 49 ++++++++++++++++++++++++++++------
 arm/cstart64.S            | 55 +++++++++++++++++++++++++++++++++------
 arm/selftest.c            |  2 +-
 lib/arm/asm/arm-smccc.h   | 44 +++++++++++++++++++++++++++++++
 lib/arm/asm/psci.h        | 13 +++++----
 lib/arm/psci.c            | 19 +++++++++++---
 lib/arm64/asm/arm-smccc.h |  6 +++++
 7 files changed, 160 insertions(+), 28 deletions(-)
 create mode 100644 lib/arm/asm/arm-smccc.h
 create mode 100644 lib/arm64/asm/arm-smccc.h

diff --git a/arm/cstart.S b/arm/cstart.S
index 3dd71ed9..29961c37 100644
--- a/arm/cstart.S
+++ b/arm/cstart.S
@@ -96,26 +96,59 @@ start:
 .text
 
 /*
- * psci_invoke_hvc / psci_invoke_smc
+ * arm_smccc_hvc / arm_smccc_smc
  *
  * Inputs:
  *   r0 -- function_id
  *   r1 -- arg0
  *   r2 -- arg1
  *   r3 -- arg2
+ *   [sp] - arg3
+ *   [sp + #4] - arg4
+ *   [sp + #8] - arg5
+ *   [sp + #12] - arg6
+ *   [sp + #16] - arg7
+ *   [sp + #20] - arg8
+ *   [sp + #24] - arg9
+ *   [sp + #28] - arg10
+ *   [sp + #32] - result (as a pointer to a struct smccc_result)
  *
  * Outputs:
  *   r0 -- return code
+ *
+ * If result pointer is not NULL:
+ *   result.r0 -- return code
+ *   result.r1 -- r1
+ *   result.r2 -- r2
+ *   result.r3 -- r3
+ *   result.r4 -- r4
+ *   result.r5 -- r5
+ *   result.r6 -- r6
+ *   result.r7 -- r7
+ *   result.r8 -- r8
+ *   result.r9 -- r9
  */
-.globl psci_invoke_hvc
-psci_invoke_hvc:
-	hvc	#0
+.macro do_smccc_call instr
+	mov	r12, sp
+	push	{r4-r11}
+	ldm	r12, {r4-r11}
+	\instr	#0
+	ldr	r10, [sp, #64]
+	cmp	r10, #0
+	beq	1f
+	stm	r10, {r0-r9}
+1:
+	pop	{r4-r11}
 	mov	pc, lr
+.endm
 
-.globl psci_invoke_smc
-psci_invoke_smc:
-	smc	#0
-	mov	pc, lr
+.globl arm_smccc_hvc
+arm_smccc_hvc:
+	do_smccc_call hvc
+
+.globl arm_smccc_smc
+arm_smccc_smc:
+	do_smccc_call smc
 
 enable_vfp:
 	/* Enable full access to CP10 and CP11: */
diff --git a/arm/cstart64.S b/arm/cstart64.S
index bc2be45a..734b2286 100644
--- a/arm/cstart64.S
+++ b/arm/cstart64.S
@@ -116,26 +116,65 @@ start:
 .text
 
 /*
- * psci_invoke_hvc / psci_invoke_smc
+ * arm_smccc_hvc / arm_smccc_smc
  *
  * Inputs:
  *   w0 -- function_id
  *   x1 -- arg0
  *   x2 -- arg1
  *   x3 -- arg2
+ *   x4 -- arg3
+ *   x5 -- arg4
+ *   x6 -- arg5
+ *   x7 -- arg6
+ *   sp -- { arg7, arg8, arg9, arg10, result }
  *
  * Outputs:
  *   x0 -- return code
+ *
+ * If result pointer is not NULL:
+ *   result.r0 -- return code
+ *   result.r1 -- x1
+ *   result.r2 -- x2
+ *   result.r3 -- x3
+ *   result.r4 -- x4
+ *   result.r5 -- x5
+ *   result.r6 -- x6
+ *   result.r7 -- x7
+ *   result.r8 -- x8
+ *   result.r9 -- x9
  */
-.globl psci_invoke_hvc
-psci_invoke_hvc:
-	hvc	#0
+.macro do_smccc_call instr
+	/* Save x8-x11 on stack */
+	stp	x9, x8,	  [sp, #-16]!
+	stp	x11, x10, [sp, #-16]!
+	/* Load arg7 - arg10 from the stack */
+	ldp	x8, x9,   [sp, #32]
+	ldp	x10, x11, [sp, #48]
+	\instr	#0
+	/* Get the result address */
+	ldr	x10, [sp, #64]
+	cmp	x10, xzr
+	b.eq	1f
+	stp	x0, x1, [x10, #0]
+	stp	x2, x3, [x10, #16]
+	stp	x4, x5, [x10, #32]
+	stp	x6, x7, [x10, #48]
+	stp	x8, x9, [x10, #64]
+1:
+	/* Restore x8-x11 from stack */
+	ldp	x11, x10, [sp], #16
+	ldp	x9, x8,   [sp], #16
 	ret
+.endm
 
-.globl psci_invoke_smc
-psci_invoke_smc:
-	smc	#0
-	ret
+.globl arm_smccc_hvc
+arm_smccc_hvc:
+	do_smccc_call hvc
+
+.globl arm_smccc_smc
+arm_smccc_smc:
+	do_smccc_call smc
 
 get_mmu_off:
 	adrp	x0, auxinfo
diff --git a/arm/selftest.c b/arm/selftest.c
index 007d2309..1553ed8e 100644
--- a/arm/selftest.c
+++ b/arm/selftest.c
@@ -406,7 +406,7 @@ static void psci_print(void)
 	int ver = psci_invoke(PSCI_0_2_FN_PSCI_VERSION, 0, 0, 0);
 	report_info("PSCI version: %d.%d", PSCI_VERSION_MAJOR(ver),
 					  PSCI_VERSION_MINOR(ver));
-	report_info("PSCI method: %s", psci_invoke == psci_invoke_hvc ?
+	report_info("PSCI method: %s", psci_invoke_fn == arm_smccc_hvc ?
 				       "hvc" : "smc");
 }
 
diff --git a/lib/arm/asm/arm-smccc.h b/lib/arm/asm/arm-smccc.h
new file mode 100644
index 00000000..5d85b01a
--- /dev/null
+++ b/lib/arm/asm/arm-smccc.h
@@ -0,0 +1,44 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2022 Arm Limited.
+ * All rights reserved.
+ */
+#ifndef _ASMARM_ARM_SMCCC_H_
+#define _ASMARM_ARM_SMCCC_H_
+
+struct smccc_result {
+	unsigned long r0;
+	unsigned long r1;
+	unsigned long r2;
+	unsigned long r3;
+	unsigned long r4;
+	unsigned long r5;
+	unsigned long r6;
+	unsigned long r7;
+	unsigned long r8;
+	unsigned long r9;
+};
+
+typedef int (*smccc_invoke_fn)(unsigned int function_id, unsigned long arg0,
+			       unsigned long arg1, unsigned long arg2,
+			       unsigned long arg3, unsigned long arg4,
+			       unsigned long arg5, unsigned long arg6,
+			       unsigned long arg7, unsigned long arg8,
+			       unsigned long arg9, unsigned long arg10,
+			       struct smccc_result *result);
+extern int arm_smccc_hvc(unsigned int function_id, unsigned long arg0,
+			 unsigned long arg1, unsigned long arg2,
+			 unsigned long arg3, unsigned long arg4,
+			 unsigned long arg5, unsigned long arg6,
+			 unsigned long arg7, unsigned long arg8,
+			 unsigned long arg9, unsigned long arg10,
+			 struct smccc_result *result);
+extern int arm_smccc_smc(unsigned int function_id, unsigned long arg0,
+			 unsigned long arg1, unsigned long arg2,
+			 unsigned long arg3, unsigned long arg4,
+			 unsigned long arg5, unsigned long arg6,
+			 unsigned long arg7, unsigned long arg8,
+			 unsigned long arg9, unsigned long arg10,
+			 struct smccc_result *result);
+
+#endif /* _ASMARM_ARM_SMCCC_H_ */
diff --git a/lib/arm/asm/psci.h b/lib/arm/asm/psci.h
index cf03449b..6a399621 100644
--- a/lib/arm/asm/psci.h
+++ b/lib/arm/asm/psci.h
@@ -3,13 +3,12 @@
 #include <libcflat.h>
 #include <linux/psci.h>
 
-typedef int (*psci_invoke_fn)(unsigned int function_id, unsigned long arg0,
-			      unsigned long arg1, unsigned long arg2);
-extern psci_invoke_fn psci_invoke;
-extern int psci_invoke_hvc(unsigned int function_id, unsigned long arg0,
-			   unsigned long arg1, unsigned long arg2);
-extern int psci_invoke_smc(unsigned int function_id, unsigned long arg0,
-			   unsigned long arg1, unsigned long arg2);
+#include <asm/arm-smccc.h>
+
+extern smccc_invoke_fn psci_invoke_fn;
+
+extern int psci_invoke(unsigned int function_id, unsigned long arg0,
+		       unsigned long arg1, unsigned long arg2);
 extern void psci_set_conduit(void);
 extern int psci_cpu_on(unsigned long cpuid, unsigned long entry_point);
 extern void psci_system_reset(void);
diff --git a/lib/arm/psci.c b/lib/arm/psci.c
index bddb0787..25a84a4b 100644
--- a/lib/arm/psci.c
+++ b/lib/arm/psci.c
@@ -13,13 +13,24 @@
 #include <asm/smp.h>
 
 static int psci_invoke_none(unsigned int function_id, unsigned long arg0,
-			    unsigned long arg1, unsigned long arg2)
+			    unsigned long arg1, unsigned long arg2,
+			    unsigned long arg3, unsigned long arg4,
+			    unsigned long arg5, unsigned long arg6,
+			    unsigned long arg7, unsigned long arg8,
+			    unsigned long arg9, unsigned long arg10,
+			    struct smccc_result *result)
 {
 	printf("No PSCI method configured! Can't invoke...\n");
 	return PSCI_RET_NOT_PRESENT;
 }
 
-psci_invoke_fn psci_invoke = psci_invoke_none;
+smccc_invoke_fn psci_invoke_fn = psci_invoke_none;
+
+int psci_invoke(unsigned int function_id, unsigned long arg0,
+		unsigned long arg1, unsigned long arg2)
+{
+	return psci_invoke_fn(function_id, arg0, arg1, arg2, 0, 0, 0, 0, 0, 0, 0, 0, NULL);
+}
 
 int psci_cpu_on(unsigned long cpuid, unsigned long entry_point)
 {
@@ -69,9 +80,9 @@ static void psci_set_conduit_fdt(void)
 	assert(method != NULL && len == 4);
 
 	if (strcmp(method->data, "hvc") == 0)
-		psci_invoke = psci_invoke_hvc;
+		psci_invoke_fn = arm_smccc_hvc;
 	else if (strcmp(method->data, "smc") == 0)
-		psci_invoke = psci_invoke_smc;
+		psci_invoke_fn = arm_smccc_smc;
 	else
 		assert_msg(false, "Unknown PSCI conduit: %s", method->data);
 }
diff --git a/lib/arm64/asm/arm-smccc.h b/lib/arm64/asm/arm-smccc.h
new file mode 100644
index 00000000..ab649489
--- /dev/null
+++ b/lib/arm64/asm/arm-smccc.h
@@ -0,0 +1,6 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2022 Arm Limited.
+ * All rights reserved.
+ */
+#include "../../arm/asm/arm-smccc.h"
-- 
2.34.1


