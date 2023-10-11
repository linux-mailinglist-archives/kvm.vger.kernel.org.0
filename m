Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C45A7C5DEF
	for <lists+kvm@lfdr.de>; Wed, 11 Oct 2023 21:58:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376305AbjJKT6W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Oct 2023 15:58:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347016AbjJKT6U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Oct 2023 15:58:20 -0400
Received: from out-210.mta1.migadu.com (out-210.mta1.migadu.com [IPv6:2001:41d0:203:375::d2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C643E9E
        for <kvm@vger.kernel.org>; Wed, 11 Oct 2023 12:58:14 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1697054293;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=My1z3FlMQev4nTHF/eya3qoj9OufWsVVicOxHVQTNrA=;
        b=p+fJiY1pW7BCXaf/77XKAP4kbxH9Dxldn5LCnl9BQXJi9m8G4G0jCO/QDcxPDl9uIeottr
        pF5Wo2ybpOj4PVsy0+suVwV2+MXS2iyjctKlLsW+Uslwy5qFjEKGYPpxqPXfOQfFSDv3WD
        7kq3P2MJKvQ3biRFq+juolINL0ZbosY=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     kvm@vger.kernel.org
Cc:     kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
        linux-perf-users@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Jing Zhang <jingzhangos@google.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        James Morse <james.morse@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ian Rogers <irogers@google.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v3 4/5] tools headers arm64: Update sysreg.h with kernel sources
Date:   Wed, 11 Oct 2023 19:57:39 +0000
Message-ID: <20231011195740.3349631-5-oliver.upton@linux.dev>
In-Reply-To: <20231011195740.3349631-1-oliver.upton@linux.dev>
References: <20231011195740.3349631-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jing Zhang <jingzhangos@google.com>

The users of sysreg.h (perf, KVM selftests) are now generating the
necessary sysreg-defs.h; sync sysreg.h with the kernel sources and
fix the KVM selftests that use macros which suffered a rename.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 tools/arch/arm64/include/asm/gpr-num.h        |  26 +
 tools/arch/arm64/include/asm/sysreg.h         | 839 ++++--------------
 .../selftests/kvm/aarch64/aarch32_id_regs.c   |   4 +-
 .../selftests/kvm/aarch64/debug-exceptions.c  |  12 +-
 .../selftests/kvm/aarch64/page_fault_test.c   |   6 +-
 .../selftests/kvm/lib/aarch64/processor.c     |   6 +-
 6 files changed, 232 insertions(+), 661 deletions(-)
 create mode 100644 tools/arch/arm64/include/asm/gpr-num.h

diff --git a/tools/arch/arm64/include/asm/gpr-num.h b/tools/arch/arm64/include/asm/gpr-num.h
new file mode 100644
index 000000000000..05da4a7c5788
--- /dev/null
+++ b/tools/arch/arm64/include/asm/gpr-num.h
@@ -0,0 +1,26 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef __ASM_GPR_NUM_H
+#define __ASM_GPR_NUM_H
+
+#ifdef __ASSEMBLY__
+
+	.irp	num,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30
+	.equ	.L__gpr_num_x\num, \num
+	.equ	.L__gpr_num_w\num, \num
+	.endr
+	.equ	.L__gpr_num_xzr, 31
+	.equ	.L__gpr_num_wzr, 31
+
+#else /* __ASSEMBLY__ */
+
+#define __DEFINE_ASM_GPR_NUMS					\
+"	.irp	num,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30\n" \
+"	.equ	.L__gpr_num_x\\num, \\num\n"			\
+"	.equ	.L__gpr_num_w\\num, \\num\n"			\
+"	.endr\n"						\
+"	.equ	.L__gpr_num_xzr, 31\n"				\
+"	.equ	.L__gpr_num_wzr, 31\n"
+
+#endif /* __ASSEMBLY__ */
+
+#endif /* __ASM_GPR_NUM_H */
diff --git a/tools/arch/arm64/include/asm/sysreg.h b/tools/arch/arm64/include/asm/sysreg.h
index 7640fa27be94..ccc13e991376 100644
--- a/tools/arch/arm64/include/asm/sysreg.h
+++ b/tools/arch/arm64/include/asm/sysreg.h
@@ -12,6 +12,8 @@
 #include <linux/bits.h>
 #include <linux/stringify.h>
 
+#include <asm/gpr-num.h>
+
 /*
  * ARMv8 ARM reserves the following encoding for system registers:
  * (Ref: ARMv8 ARM, Section: "System instruction class encoding overview",
@@ -87,20 +89,24 @@
  */
 #define pstate_field(op1, op2)		((op1) << Op1_shift | (op2) << Op2_shift)
 #define PSTATE_Imm_shift		CRm_shift
+#define SET_PSTATE(x, r)		__emit_inst(0xd500401f | PSTATE_ ## r | ((!!x) << PSTATE_Imm_shift))
 
 #define PSTATE_PAN			pstate_field(0, 4)
 #define PSTATE_UAO			pstate_field(0, 3)
 #define PSTATE_SSBS			pstate_field(3, 1)
+#define PSTATE_DIT			pstate_field(3, 2)
 #define PSTATE_TCO			pstate_field(3, 4)
 
-#define SET_PSTATE_PAN(x)		__emit_inst(0xd500401f | PSTATE_PAN | ((!!x) << PSTATE_Imm_shift))
-#define SET_PSTATE_UAO(x)		__emit_inst(0xd500401f | PSTATE_UAO | ((!!x) << PSTATE_Imm_shift))
-#define SET_PSTATE_SSBS(x)		__emit_inst(0xd500401f | PSTATE_SSBS | ((!!x) << PSTATE_Imm_shift))
-#define SET_PSTATE_TCO(x)		__emit_inst(0xd500401f | PSTATE_TCO | ((!!x) << PSTATE_Imm_shift))
+#define SET_PSTATE_PAN(x)		SET_PSTATE((x), PAN)
+#define SET_PSTATE_UAO(x)		SET_PSTATE((x), UAO)
+#define SET_PSTATE_SSBS(x)		SET_PSTATE((x), SSBS)
+#define SET_PSTATE_DIT(x)		SET_PSTATE((x), DIT)
+#define SET_PSTATE_TCO(x)		SET_PSTATE((x), TCO)
 
 #define set_pstate_pan(x)		asm volatile(SET_PSTATE_PAN(x))
 #define set_pstate_uao(x)		asm volatile(SET_PSTATE_UAO(x))
 #define set_pstate_ssbs(x)		asm volatile(SET_PSTATE_SSBS(x))
+#define set_pstate_dit(x)		asm volatile(SET_PSTATE_DIT(x))
 
 #define __SYS_BARRIER_INSN(CRm, op2, Rt) \
 	__emit_inst(0xd5000000 | sys_insn(0, 3, 3, (CRm), (op2)) | ((Rt) & 0x1f))
@@ -108,25 +114,43 @@
 #define SB_BARRIER_INSN			__SYS_BARRIER_INSN(0, 7, 31)
 
 #define SYS_DC_ISW			sys_insn(1, 0, 7, 6, 2)
+#define SYS_DC_IGSW			sys_insn(1, 0, 7, 6, 4)
+#define SYS_DC_IGDSW			sys_insn(1, 0, 7, 6, 6)
 #define SYS_DC_CSW			sys_insn(1, 0, 7, 10, 2)
+#define SYS_DC_CGSW			sys_insn(1, 0, 7, 10, 4)
+#define SYS_DC_CGDSW			sys_insn(1, 0, 7, 10, 6)
 #define SYS_DC_CISW			sys_insn(1, 0, 7, 14, 2)
+#define SYS_DC_CIGSW			sys_insn(1, 0, 7, 14, 4)
+#define SYS_DC_CIGDSW			sys_insn(1, 0, 7, 14, 6)
+
+/*
+ * Automatically generated definitions for system registers, the
+ * manual encodings below are in the process of being converted to
+ * come from here. The header relies on the definition of sys_reg()
+ * earlier in this file.
+ */
+#include "asm/sysreg-defs.h"
 
 /*
  * System registers, organised loosely by encoding but grouped together
  * where the architected name contains an index. e.g. ID_MMFR<n>_EL1.
  */
-#define SYS_OSDTRRX_EL1			sys_reg(2, 0, 0, 0, 2)
-#define SYS_MDCCINT_EL1			sys_reg(2, 0, 0, 2, 0)
-#define SYS_MDSCR_EL1			sys_reg(2, 0, 0, 2, 2)
-#define SYS_OSDTRTX_EL1			sys_reg(2, 0, 0, 3, 2)
-#define SYS_OSECCR_EL1			sys_reg(2, 0, 0, 6, 2)
+#define SYS_SVCR_SMSTOP_SM_EL0		sys_reg(0, 3, 4, 2, 3)
+#define SYS_SVCR_SMSTART_SM_EL0		sys_reg(0, 3, 4, 3, 3)
+#define SYS_SVCR_SMSTOP_SMZA_EL0	sys_reg(0, 3, 4, 6, 3)
+
 #define SYS_DBGBVRn_EL1(n)		sys_reg(2, 0, 0, n, 4)
 #define SYS_DBGBCRn_EL1(n)		sys_reg(2, 0, 0, n, 5)
 #define SYS_DBGWVRn_EL1(n)		sys_reg(2, 0, 0, n, 6)
 #define SYS_DBGWCRn_EL1(n)		sys_reg(2, 0, 0, n, 7)
 #define SYS_MDRAR_EL1			sys_reg(2, 0, 1, 0, 0)
-#define SYS_OSLAR_EL1			sys_reg(2, 0, 1, 0, 4)
+
 #define SYS_OSLSR_EL1			sys_reg(2, 0, 1, 1, 4)
+#define OSLSR_EL1_OSLM_MASK		(BIT(3) | BIT(0))
+#define OSLSR_EL1_OSLM_NI		0
+#define OSLSR_EL1_OSLM_IMPLEMENTED	BIT(3)
+#define OSLSR_EL1_OSLK			BIT(1)
+
 #define SYS_OSDLR_EL1			sys_reg(2, 0, 1, 3, 4)
 #define SYS_DBGPRCR_EL1			sys_reg(2, 0, 1, 4, 4)
 #define SYS_DBGCLAIMSET_EL1		sys_reg(2, 0, 7, 8, 6)
@@ -142,59 +166,12 @@
 #define SYS_MPIDR_EL1			sys_reg(3, 0, 0, 0, 5)
 #define SYS_REVIDR_EL1			sys_reg(3, 0, 0, 0, 6)
 
-#define SYS_ID_PFR0_EL1			sys_reg(3, 0, 0, 1, 0)
-#define SYS_ID_PFR1_EL1			sys_reg(3, 0, 0, 1, 1)
-#define SYS_ID_PFR2_EL1			sys_reg(3, 0, 0, 3, 4)
-#define SYS_ID_DFR0_EL1			sys_reg(3, 0, 0, 1, 2)
-#define SYS_ID_DFR1_EL1			sys_reg(3, 0, 0, 3, 5)
-#define SYS_ID_AFR0_EL1			sys_reg(3, 0, 0, 1, 3)
-#define SYS_ID_MMFR0_EL1		sys_reg(3, 0, 0, 1, 4)
-#define SYS_ID_MMFR1_EL1		sys_reg(3, 0, 0, 1, 5)
-#define SYS_ID_MMFR2_EL1		sys_reg(3, 0, 0, 1, 6)
-#define SYS_ID_MMFR3_EL1		sys_reg(3, 0, 0, 1, 7)
-#define SYS_ID_MMFR4_EL1		sys_reg(3, 0, 0, 2, 6)
-#define SYS_ID_MMFR5_EL1		sys_reg(3, 0, 0, 3, 6)
-
-#define SYS_ID_ISAR0_EL1		sys_reg(3, 0, 0, 2, 0)
-#define SYS_ID_ISAR1_EL1		sys_reg(3, 0, 0, 2, 1)
-#define SYS_ID_ISAR2_EL1		sys_reg(3, 0, 0, 2, 2)
-#define SYS_ID_ISAR3_EL1		sys_reg(3, 0, 0, 2, 3)
-#define SYS_ID_ISAR4_EL1		sys_reg(3, 0, 0, 2, 4)
-#define SYS_ID_ISAR5_EL1		sys_reg(3, 0, 0, 2, 5)
-#define SYS_ID_ISAR6_EL1		sys_reg(3, 0, 0, 2, 7)
-
-#define SYS_MVFR0_EL1			sys_reg(3, 0, 0, 3, 0)
-#define SYS_MVFR1_EL1			sys_reg(3, 0, 0, 3, 1)
-#define SYS_MVFR2_EL1			sys_reg(3, 0, 0, 3, 2)
-
-#define SYS_ID_AA64PFR0_EL1		sys_reg(3, 0, 0, 4, 0)
-#define SYS_ID_AA64PFR1_EL1		sys_reg(3, 0, 0, 4, 1)
-#define SYS_ID_AA64ZFR0_EL1		sys_reg(3, 0, 0, 4, 4)
-
-#define SYS_ID_AA64DFR0_EL1		sys_reg(3, 0, 0, 5, 0)
-#define SYS_ID_AA64DFR1_EL1		sys_reg(3, 0, 0, 5, 1)
-
-#define SYS_ID_AA64AFR0_EL1		sys_reg(3, 0, 0, 5, 4)
-#define SYS_ID_AA64AFR1_EL1		sys_reg(3, 0, 0, 5, 5)
-
-#define SYS_ID_AA64ISAR0_EL1		sys_reg(3, 0, 0, 6, 0)
-#define SYS_ID_AA64ISAR1_EL1		sys_reg(3, 0, 0, 6, 1)
-
-#define SYS_ID_AA64MMFR0_EL1		sys_reg(3, 0, 0, 7, 0)
-#define SYS_ID_AA64MMFR1_EL1		sys_reg(3, 0, 0, 7, 1)
-#define SYS_ID_AA64MMFR2_EL1		sys_reg(3, 0, 0, 7, 2)
-
-#define SYS_SCTLR_EL1			sys_reg(3, 0, 1, 0, 0)
 #define SYS_ACTLR_EL1			sys_reg(3, 0, 1, 0, 1)
-#define SYS_CPACR_EL1			sys_reg(3, 0, 1, 0, 2)
 #define SYS_RGSR_EL1			sys_reg(3, 0, 1, 0, 5)
 #define SYS_GCR_EL1			sys_reg(3, 0, 1, 0, 6)
 
-#define SYS_ZCR_EL1			sys_reg(3, 0, 1, 2, 0)
 #define SYS_TRFCR_EL1			sys_reg(3, 0, 1, 2, 1)
 
-#define SYS_TTBR0_EL1			sys_reg(3, 0, 2, 0, 0)
-#define SYS_TTBR1_EL1			sys_reg(3, 0, 2, 0, 1)
 #define SYS_TCR_EL1			sys_reg(3, 0, 2, 0, 2)
 
 #define SYS_APIAKEYLO_EL1		sys_reg(3, 0, 2, 1, 0)
@@ -230,159 +207,33 @@
 #define SYS_TFSR_EL1			sys_reg(3, 0, 5, 6, 0)
 #define SYS_TFSRE0_EL1			sys_reg(3, 0, 5, 6, 1)
 
-#define SYS_FAR_EL1			sys_reg(3, 0, 6, 0, 0)
 #define SYS_PAR_EL1			sys_reg(3, 0, 7, 4, 0)
 
 #define SYS_PAR_EL1_F			BIT(0)
 #define SYS_PAR_EL1_FST			GENMASK(6, 1)
 
 /*** Statistical Profiling Extension ***/
-/* ID registers */
-#define SYS_PMSIDR_EL1			sys_reg(3, 0, 9, 9, 7)
-#define SYS_PMSIDR_EL1_FE_SHIFT		0
-#define SYS_PMSIDR_EL1_FT_SHIFT		1
-#define SYS_PMSIDR_EL1_FL_SHIFT		2
-#define SYS_PMSIDR_EL1_ARCHINST_SHIFT	3
-#define SYS_PMSIDR_EL1_LDS_SHIFT	4
-#define SYS_PMSIDR_EL1_ERND_SHIFT	5
-#define SYS_PMSIDR_EL1_INTERVAL_SHIFT	8
-#define SYS_PMSIDR_EL1_INTERVAL_MASK	0xfUL
-#define SYS_PMSIDR_EL1_MAXSIZE_SHIFT	12
-#define SYS_PMSIDR_EL1_MAXSIZE_MASK	0xfUL
-#define SYS_PMSIDR_EL1_COUNTSIZE_SHIFT	16
-#define SYS_PMSIDR_EL1_COUNTSIZE_MASK	0xfUL
-
-#define SYS_PMBIDR_EL1			sys_reg(3, 0, 9, 10, 7)
-#define SYS_PMBIDR_EL1_ALIGN_SHIFT	0
-#define SYS_PMBIDR_EL1_ALIGN_MASK	0xfU
-#define SYS_PMBIDR_EL1_P_SHIFT		4
-#define SYS_PMBIDR_EL1_F_SHIFT		5
-
-/* Sampling controls */
-#define SYS_PMSCR_EL1			sys_reg(3, 0, 9, 9, 0)
-#define SYS_PMSCR_EL1_E0SPE_SHIFT	0
-#define SYS_PMSCR_EL1_E1SPE_SHIFT	1
-#define SYS_PMSCR_EL1_CX_SHIFT		3
-#define SYS_PMSCR_EL1_PA_SHIFT		4
-#define SYS_PMSCR_EL1_TS_SHIFT		5
-#define SYS_PMSCR_EL1_PCT_SHIFT		6
-
-#define SYS_PMSCR_EL2			sys_reg(3, 4, 9, 9, 0)
-#define SYS_PMSCR_EL2_E0HSPE_SHIFT	0
-#define SYS_PMSCR_EL2_E2SPE_SHIFT	1
-#define SYS_PMSCR_EL2_CX_SHIFT		3
-#define SYS_PMSCR_EL2_PA_SHIFT		4
-#define SYS_PMSCR_EL2_TS_SHIFT		5
-#define SYS_PMSCR_EL2_PCT_SHIFT		6
-
-#define SYS_PMSICR_EL1			sys_reg(3, 0, 9, 9, 2)
-
-#define SYS_PMSIRR_EL1			sys_reg(3, 0, 9, 9, 3)
-#define SYS_PMSIRR_EL1_RND_SHIFT	0
-#define SYS_PMSIRR_EL1_INTERVAL_SHIFT	8
-#define SYS_PMSIRR_EL1_INTERVAL_MASK	0xffffffUL
-
-/* Filtering controls */
-#define SYS_PMSNEVFR_EL1		sys_reg(3, 0, 9, 9, 1)
-
-#define SYS_PMSFCR_EL1			sys_reg(3, 0, 9, 9, 4)
-#define SYS_PMSFCR_EL1_FE_SHIFT		0
-#define SYS_PMSFCR_EL1_FT_SHIFT		1
-#define SYS_PMSFCR_EL1_FL_SHIFT		2
-#define SYS_PMSFCR_EL1_B_SHIFT		16
-#define SYS_PMSFCR_EL1_LD_SHIFT		17
-#define SYS_PMSFCR_EL1_ST_SHIFT		18
-
-#define SYS_PMSEVFR_EL1			sys_reg(3, 0, 9, 9, 5)
-#define SYS_PMSEVFR_EL1_RES0_8_2	\
+#define PMSEVFR_EL1_RES0_IMP	\
 	(GENMASK_ULL(47, 32) | GENMASK_ULL(23, 16) | GENMASK_ULL(11, 8) |\
 	 BIT_ULL(6) | BIT_ULL(4) | BIT_ULL(2) | BIT_ULL(0))
-#define SYS_PMSEVFR_EL1_RES0_8_3	\
-	(SYS_PMSEVFR_EL1_RES0_8_2 & ~(BIT_ULL(18) | BIT_ULL(17) | BIT_ULL(11)))
-
-#define SYS_PMSLATFR_EL1		sys_reg(3, 0, 9, 9, 6)
-#define SYS_PMSLATFR_EL1_MINLAT_SHIFT	0
-
-/* Buffer controls */
-#define SYS_PMBLIMITR_EL1		sys_reg(3, 0, 9, 10, 0)
-#define SYS_PMBLIMITR_EL1_E_SHIFT	0
-#define SYS_PMBLIMITR_EL1_FM_SHIFT	1
-#define SYS_PMBLIMITR_EL1_FM_MASK	0x3UL
-#define SYS_PMBLIMITR_EL1_FM_STOP_IRQ	(0 << SYS_PMBLIMITR_EL1_FM_SHIFT)
-
-#define SYS_PMBPTR_EL1			sys_reg(3, 0, 9, 10, 1)
+#define PMSEVFR_EL1_RES0_V1P1	\
+	(PMSEVFR_EL1_RES0_IMP & ~(BIT_ULL(18) | BIT_ULL(17) | BIT_ULL(11)))
+#define PMSEVFR_EL1_RES0_V1P2	\
+	(PMSEVFR_EL1_RES0_V1P1 & ~BIT_ULL(6))
 
 /* Buffer error reporting */
-#define SYS_PMBSR_EL1			sys_reg(3, 0, 9, 10, 3)
-#define SYS_PMBSR_EL1_COLL_SHIFT	16
-#define SYS_PMBSR_EL1_S_SHIFT		17
-#define SYS_PMBSR_EL1_EA_SHIFT		18
-#define SYS_PMBSR_EL1_DL_SHIFT		19
-#define SYS_PMBSR_EL1_EC_SHIFT		26
-#define SYS_PMBSR_EL1_EC_MASK		0x3fUL
-
-#define SYS_PMBSR_EL1_EC_BUF		(0x0UL << SYS_PMBSR_EL1_EC_SHIFT)
-#define SYS_PMBSR_EL1_EC_FAULT_S1	(0x24UL << SYS_PMBSR_EL1_EC_SHIFT)
-#define SYS_PMBSR_EL1_EC_FAULT_S2	(0x25UL << SYS_PMBSR_EL1_EC_SHIFT)
-
-#define SYS_PMBSR_EL1_FAULT_FSC_SHIFT	0
-#define SYS_PMBSR_EL1_FAULT_FSC_MASK	0x3fUL
+#define PMBSR_EL1_FAULT_FSC_SHIFT	PMBSR_EL1_MSS_SHIFT
+#define PMBSR_EL1_FAULT_FSC_MASK	PMBSR_EL1_MSS_MASK
 
-#define SYS_PMBSR_EL1_BUF_BSC_SHIFT	0
-#define SYS_PMBSR_EL1_BUF_BSC_MASK	0x3fUL
+#define PMBSR_EL1_BUF_BSC_SHIFT		PMBSR_EL1_MSS_SHIFT
+#define PMBSR_EL1_BUF_BSC_MASK		PMBSR_EL1_MSS_MASK
 
-#define SYS_PMBSR_EL1_BUF_BSC_FULL	(0x1UL << SYS_PMBSR_EL1_BUF_BSC_SHIFT)
+#define PMBSR_EL1_BUF_BSC_FULL		0x1UL
 
 /*** End of Statistical Profiling Extension ***/
 
-/*
- * TRBE Registers
- */
-#define SYS_TRBLIMITR_EL1		sys_reg(3, 0, 9, 11, 0)
-#define SYS_TRBPTR_EL1			sys_reg(3, 0, 9, 11, 1)
-#define SYS_TRBBASER_EL1		sys_reg(3, 0, 9, 11, 2)
-#define SYS_TRBSR_EL1			sys_reg(3, 0, 9, 11, 3)
-#define SYS_TRBMAR_EL1			sys_reg(3, 0, 9, 11, 4)
-#define SYS_TRBTRG_EL1			sys_reg(3, 0, 9, 11, 6)
-#define SYS_TRBIDR_EL1			sys_reg(3, 0, 9, 11, 7)
-
-#define TRBLIMITR_LIMIT_MASK		GENMASK_ULL(51, 0)
-#define TRBLIMITR_LIMIT_SHIFT		12
-#define TRBLIMITR_NVM			BIT(5)
-#define TRBLIMITR_TRIG_MODE_MASK	GENMASK(1, 0)
-#define TRBLIMITR_TRIG_MODE_SHIFT	3
-#define TRBLIMITR_FILL_MODE_MASK	GENMASK(1, 0)
-#define TRBLIMITR_FILL_MODE_SHIFT	1
-#define TRBLIMITR_ENABLE		BIT(0)
-#define TRBPTR_PTR_MASK			GENMASK_ULL(63, 0)
-#define TRBPTR_PTR_SHIFT		0
-#define TRBBASER_BASE_MASK		GENMASK_ULL(51, 0)
-#define TRBBASER_BASE_SHIFT		12
-#define TRBSR_EC_MASK			GENMASK(5, 0)
-#define TRBSR_EC_SHIFT			26
-#define TRBSR_IRQ			BIT(22)
-#define TRBSR_TRG			BIT(21)
-#define TRBSR_WRAP			BIT(20)
-#define TRBSR_ABORT			BIT(18)
-#define TRBSR_STOP			BIT(17)
-#define TRBSR_MSS_MASK			GENMASK(15, 0)
-#define TRBSR_MSS_SHIFT			0
-#define TRBSR_BSC_MASK			GENMASK(5, 0)
-#define TRBSR_BSC_SHIFT			0
-#define TRBSR_FSC_MASK			GENMASK(5, 0)
-#define TRBSR_FSC_SHIFT			0
-#define TRBMAR_SHARE_MASK		GENMASK(1, 0)
-#define TRBMAR_SHARE_SHIFT		8
-#define TRBMAR_OUTER_MASK		GENMASK(3, 0)
-#define TRBMAR_OUTER_SHIFT		4
-#define TRBMAR_INNER_MASK		GENMASK(3, 0)
-#define TRBMAR_INNER_SHIFT		0
-#define TRBTRG_TRG_MASK			GENMASK(31, 0)
-#define TRBTRG_TRG_SHIFT		0
-#define TRBIDR_FLAG			BIT(5)
-#define TRBIDR_PROG			BIT(4)
-#define TRBIDR_ALIGN_MASK		GENMASK(3, 0)
-#define TRBIDR_ALIGN_SHIFT		0
+#define TRBSR_EL1_BSC_MASK		GENMASK(5, 0)
+#define TRBSR_EL1_BSC_SHIFT		0
 
 #define SYS_PMINTENSET_EL1		sys_reg(3, 0, 9, 14, 1)
 #define SYS_PMINTENCLR_EL1		sys_reg(3, 0, 9, 14, 2)
@@ -392,12 +243,6 @@
 #define SYS_MAIR_EL1			sys_reg(3, 0, 10, 2, 0)
 #define SYS_AMAIR_EL1			sys_reg(3, 0, 10, 3, 0)
 
-#define SYS_LORSA_EL1			sys_reg(3, 0, 10, 4, 0)
-#define SYS_LOREA_EL1			sys_reg(3, 0, 10, 4, 1)
-#define SYS_LORN_EL1			sys_reg(3, 0, 10, 4, 2)
-#define SYS_LORC_EL1			sys_reg(3, 0, 10, 4, 3)
-#define SYS_LORID_EL1			sys_reg(3, 0, 10, 4, 7)
-
 #define SYS_VBAR_EL1			sys_reg(3, 0, 12, 0, 0)
 #define SYS_DISR_EL1			sys_reg(3, 0, 12, 1, 1)
 
@@ -429,23 +274,10 @@
 #define SYS_ICC_IGRPEN0_EL1		sys_reg(3, 0, 12, 12, 6)
 #define SYS_ICC_IGRPEN1_EL1		sys_reg(3, 0, 12, 12, 7)
 
-#define SYS_CONTEXTIDR_EL1		sys_reg(3, 0, 13, 0, 1)
-#define SYS_TPIDR_EL1			sys_reg(3, 0, 13, 0, 4)
-
-#define SYS_SCXTNUM_EL1			sys_reg(3, 0, 13, 0, 7)
-
 #define SYS_CNTKCTL_EL1			sys_reg(3, 0, 14, 1, 0)
 
-#define SYS_CCSIDR_EL1			sys_reg(3, 1, 0, 0, 0)
-#define SYS_CLIDR_EL1			sys_reg(3, 1, 0, 0, 1)
-#define SYS_GMID_EL1			sys_reg(3, 1, 0, 0, 4)
 #define SYS_AIDR_EL1			sys_reg(3, 1, 0, 0, 7)
 
-#define SYS_CSSELR_EL1			sys_reg(3, 2, 0, 0, 0)
-
-#define SYS_CTR_EL0			sys_reg(3, 3, 0, 0, 1)
-#define SYS_DCZID_EL0			sys_reg(3, 3, 0, 0, 7)
-
 #define SYS_RNDR_EL0			sys_reg(3, 3, 2, 4, 0)
 #define SYS_RNDRRS_EL0			sys_reg(3, 3, 2, 4, 1)
 
@@ -465,6 +297,7 @@
 
 #define SYS_TPIDR_EL0			sys_reg(3, 3, 13, 0, 2)
 #define SYS_TPIDRRO_EL0			sys_reg(3, 3, 13, 0, 3)
+#define SYS_TPIDR2_EL0			sys_reg(3, 3, 13, 0, 5)
 
 #define SYS_SCXTNUM_EL0			sys_reg(3, 3, 13, 0, 7)
 
@@ -506,6 +339,10 @@
 
 #define SYS_CNTFRQ_EL0			sys_reg(3, 3, 14, 0, 0)
 
+#define SYS_CNTPCT_EL0			sys_reg(3, 3, 14, 0, 1)
+#define SYS_CNTPCTSS_EL0		sys_reg(3, 3, 14, 0, 5)
+#define SYS_CNTVCTSS_EL0		sys_reg(3, 3, 14, 0, 6)
+
 #define SYS_CNTP_TVAL_EL0		sys_reg(3, 3, 14, 2, 0)
 #define SYS_CNTP_CTL_EL0		sys_reg(3, 3, 14, 2, 1)
 #define SYS_CNTP_CVAL_EL0		sys_reg(3, 3, 14, 2, 2)
@@ -515,7 +352,9 @@
 
 #define SYS_AARCH32_CNTP_TVAL		sys_reg(0, 0, 14, 2, 0)
 #define SYS_AARCH32_CNTP_CTL		sys_reg(0, 0, 14, 2, 1)
+#define SYS_AARCH32_CNTPCT		sys_reg(0, 0, 0, 14, 0)
 #define SYS_AARCH32_CNTP_CVAL		sys_reg(0, 2, 0, 14, 0)
+#define SYS_AARCH32_CNTPCTSS		sys_reg(0, 8, 0, 14, 0)
 
 #define __PMEV_op2(n)			((n) & 0x7)
 #define __CNTR_CRm(n)			(0x8 | (((n) >> 3) & 0x3))
@@ -525,26 +364,48 @@
 
 #define SYS_PMCCFILTR_EL0		sys_reg(3, 3, 14, 15, 7)
 
+#define SYS_VPIDR_EL2			sys_reg(3, 4, 0, 0, 0)
+#define SYS_VMPIDR_EL2			sys_reg(3, 4, 0, 0, 5)
+
 #define SYS_SCTLR_EL2			sys_reg(3, 4, 1, 0, 0)
-#define SYS_HFGRTR_EL2			sys_reg(3, 4, 1, 1, 4)
-#define SYS_HFGWTR_EL2			sys_reg(3, 4, 1, 1, 5)
-#define SYS_HFGITR_EL2			sys_reg(3, 4, 1, 1, 6)
-#define SYS_ZCR_EL2			sys_reg(3, 4, 1, 2, 0)
+#define SYS_ACTLR_EL2			sys_reg(3, 4, 1, 0, 1)
+#define SYS_HCR_EL2			sys_reg(3, 4, 1, 1, 0)
+#define SYS_MDCR_EL2			sys_reg(3, 4, 1, 1, 1)
+#define SYS_CPTR_EL2			sys_reg(3, 4, 1, 1, 2)
+#define SYS_HSTR_EL2			sys_reg(3, 4, 1, 1, 3)
+#define SYS_HACR_EL2			sys_reg(3, 4, 1, 1, 7)
+
+#define SYS_TTBR0_EL2			sys_reg(3, 4, 2, 0, 0)
+#define SYS_TTBR1_EL2			sys_reg(3, 4, 2, 0, 1)
+#define SYS_TCR_EL2			sys_reg(3, 4, 2, 0, 2)
+#define SYS_VTTBR_EL2			sys_reg(3, 4, 2, 1, 0)
+#define SYS_VTCR_EL2			sys_reg(3, 4, 2, 1, 2)
+
 #define SYS_TRFCR_EL2			sys_reg(3, 4, 1, 2, 1)
-#define SYS_DACR32_EL2			sys_reg(3, 4, 3, 0, 0)
 #define SYS_HDFGRTR_EL2			sys_reg(3, 4, 3, 1, 4)
 #define SYS_HDFGWTR_EL2			sys_reg(3, 4, 3, 1, 5)
 #define SYS_HAFGRTR_EL2			sys_reg(3, 4, 3, 1, 6)
 #define SYS_SPSR_EL2			sys_reg(3, 4, 4, 0, 0)
 #define SYS_ELR_EL2			sys_reg(3, 4, 4, 0, 1)
+#define SYS_SP_EL1			sys_reg(3, 4, 4, 1, 0)
 #define SYS_IFSR32_EL2			sys_reg(3, 4, 5, 0, 1)
+#define SYS_AFSR0_EL2			sys_reg(3, 4, 5, 1, 0)
+#define SYS_AFSR1_EL2			sys_reg(3, 4, 5, 1, 1)
 #define SYS_ESR_EL2			sys_reg(3, 4, 5, 2, 0)
 #define SYS_VSESR_EL2			sys_reg(3, 4, 5, 2, 3)
 #define SYS_FPEXC32_EL2			sys_reg(3, 4, 5, 3, 0)
 #define SYS_TFSR_EL2			sys_reg(3, 4, 5, 6, 0)
+
 #define SYS_FAR_EL2			sys_reg(3, 4, 6, 0, 0)
+#define SYS_HPFAR_EL2			sys_reg(3, 4, 6, 0, 4)
+
+#define SYS_MAIR_EL2			sys_reg(3, 4, 10, 2, 0)
+#define SYS_AMAIR_EL2			sys_reg(3, 4, 10, 3, 0)
 
-#define SYS_VDISR_EL2			sys_reg(3, 4, 12, 1,  1)
+#define SYS_VBAR_EL2			sys_reg(3, 4, 12, 0, 0)
+#define SYS_RVBAR_EL2			sys_reg(3, 4, 12, 0, 1)
+#define SYS_RMR_EL2			sys_reg(3, 4, 12, 0, 2)
+#define SYS_VDISR_EL2			sys_reg(3, 4, 12, 1, 1)
 #define __SYS__AP0Rx_EL2(x)		sys_reg(3, 4, 12, 8, x)
 #define SYS_ICH_AP0R0_EL2		__SYS__AP0Rx_EL2(0)
 #define SYS_ICH_AP0R1_EL2		__SYS__AP0Rx_EL2(1)
@@ -586,10 +447,14 @@
 #define SYS_ICH_LR14_EL2		__SYS__LR8_EL2(6)
 #define SYS_ICH_LR15_EL2		__SYS__LR8_EL2(7)
 
+#define SYS_CONTEXTIDR_EL2		sys_reg(3, 4, 13, 0, 1)
+#define SYS_TPIDR_EL2			sys_reg(3, 4, 13, 0, 2)
+
+#define SYS_CNTVOFF_EL2			sys_reg(3, 4, 14, 0, 3)
+#define SYS_CNTHCTL_EL2			sys_reg(3, 4, 14, 1, 0)
+
 /* VHE encodings for architectural EL0/1 system registers */
 #define SYS_SCTLR_EL12			sys_reg(3, 5, 1, 0, 0)
-#define SYS_CPACR_EL12			sys_reg(3, 5, 1, 0, 2)
-#define SYS_ZCR_EL12			sys_reg(3, 5, 1, 2, 0)
 #define SYS_TTBR0_EL12			sys_reg(3, 5, 2, 0, 0)
 #define SYS_TTBR1_EL12			sys_reg(3, 5, 2, 0, 1)
 #define SYS_TCR_EL12			sys_reg(3, 5, 2, 0, 2)
@@ -599,11 +464,9 @@
 #define SYS_AFSR1_EL12			sys_reg(3, 5, 5, 1, 1)
 #define SYS_ESR_EL12			sys_reg(3, 5, 5, 2, 0)
 #define SYS_TFSR_EL12			sys_reg(3, 5, 5, 6, 0)
-#define SYS_FAR_EL12			sys_reg(3, 5, 6, 0, 0)
 #define SYS_MAIR_EL12			sys_reg(3, 5, 10, 2, 0)
 #define SYS_AMAIR_EL12			sys_reg(3, 5, 10, 3, 0)
 #define SYS_VBAR_EL12			sys_reg(3, 5, 12, 0, 0)
-#define SYS_CONTEXTIDR_EL12		sys_reg(3, 5, 13, 0, 1)
 #define SYS_CNTKCTL_EL12		sys_reg(3, 5, 14, 1, 0)
 #define SYS_CNTP_TVAL_EL02		sys_reg(3, 5, 14, 2, 0)
 #define SYS_CNTP_CTL_EL02		sys_reg(3, 5, 14, 2, 1)
@@ -612,37 +475,41 @@
 #define SYS_CNTV_CTL_EL02		sys_reg(3, 5, 14, 3, 1)
 #define SYS_CNTV_CVAL_EL02		sys_reg(3, 5, 14, 3, 2)
 
+#define SYS_SP_EL2			sys_reg(3, 6,  4, 1, 0)
+
 /* Common SCTLR_ELx flags. */
+#define SCTLR_ELx_ENTP2	(BIT(60))
 #define SCTLR_ELx_DSSBS	(BIT(44))
 #define SCTLR_ELx_ATA	(BIT(43))
 
-#define SCTLR_ELx_TCF_SHIFT	40
-#define SCTLR_ELx_TCF_NONE	(UL(0x0) << SCTLR_ELx_TCF_SHIFT)
-#define SCTLR_ELx_TCF_SYNC	(UL(0x1) << SCTLR_ELx_TCF_SHIFT)
-#define SCTLR_ELx_TCF_ASYNC	(UL(0x2) << SCTLR_ELx_TCF_SHIFT)
-#define SCTLR_ELx_TCF_MASK	(UL(0x3) << SCTLR_ELx_TCF_SHIFT)
-
+#define SCTLR_ELx_EE_SHIFT	25
 #define SCTLR_ELx_ENIA_SHIFT	31
 
-#define SCTLR_ELx_ITFSB	(BIT(37))
-#define SCTLR_ELx_ENIA	(BIT(SCTLR_ELx_ENIA_SHIFT))
-#define SCTLR_ELx_ENIB	(BIT(30))
-#define SCTLR_ELx_ENDA	(BIT(27))
-#define SCTLR_ELx_EE    (BIT(25))
-#define SCTLR_ELx_IESB	(BIT(21))
-#define SCTLR_ELx_WXN	(BIT(19))
-#define SCTLR_ELx_ENDB	(BIT(13))
-#define SCTLR_ELx_I	(BIT(12))
-#define SCTLR_ELx_SA	(BIT(3))
-#define SCTLR_ELx_C	(BIT(2))
-#define SCTLR_ELx_A	(BIT(1))
-#define SCTLR_ELx_M	(BIT(0))
+#define SCTLR_ELx_ITFSB	 (BIT(37))
+#define SCTLR_ELx_ENIA	 (BIT(SCTLR_ELx_ENIA_SHIFT))
+#define SCTLR_ELx_ENIB	 (BIT(30))
+#define SCTLR_ELx_LSMAOE (BIT(29))
+#define SCTLR_ELx_nTLSMD (BIT(28))
+#define SCTLR_ELx_ENDA	 (BIT(27))
+#define SCTLR_ELx_EE     (BIT(SCTLR_ELx_EE_SHIFT))
+#define SCTLR_ELx_EIS	 (BIT(22))
+#define SCTLR_ELx_IESB	 (BIT(21))
+#define SCTLR_ELx_TSCXT	 (BIT(20))
+#define SCTLR_ELx_WXN	 (BIT(19))
+#define SCTLR_ELx_ENDB	 (BIT(13))
+#define SCTLR_ELx_I	 (BIT(12))
+#define SCTLR_ELx_EOS	 (BIT(11))
+#define SCTLR_ELx_SA	 (BIT(3))
+#define SCTLR_ELx_C	 (BIT(2))
+#define SCTLR_ELx_A	 (BIT(1))
+#define SCTLR_ELx_M	 (BIT(0))
 
 /* SCTLR_EL2 specific flags. */
 #define SCTLR_EL2_RES1	((BIT(4))  | (BIT(5))  | (BIT(11)) | (BIT(16)) | \
 			 (BIT(18)) | (BIT(22)) | (BIT(23)) | (BIT(28)) | \
 			 (BIT(29)))
 
+#define SCTLR_EL2_BT	(BIT(36))
 #ifdef CONFIG_CPU_BIG_ENDIAN
 #define ENDIAN_SET_EL2		SCTLR_ELx_EE
 #else
@@ -658,33 +525,6 @@
 	(SCTLR_EL2_RES1 | ENDIAN_SET_EL2)
 
 /* SCTLR_EL1 specific flags. */
-#define SCTLR_EL1_EPAN		(BIT(57))
-#define SCTLR_EL1_ATA0		(BIT(42))
-
-#define SCTLR_EL1_TCF0_SHIFT	38
-#define SCTLR_EL1_TCF0_NONE	(UL(0x0) << SCTLR_EL1_TCF0_SHIFT)
-#define SCTLR_EL1_TCF0_SYNC	(UL(0x1) << SCTLR_EL1_TCF0_SHIFT)
-#define SCTLR_EL1_TCF0_ASYNC	(UL(0x2) << SCTLR_EL1_TCF0_SHIFT)
-#define SCTLR_EL1_TCF0_MASK	(UL(0x3) << SCTLR_EL1_TCF0_SHIFT)
-
-#define SCTLR_EL1_BT1		(BIT(36))
-#define SCTLR_EL1_BT0		(BIT(35))
-#define SCTLR_EL1_UCI		(BIT(26))
-#define SCTLR_EL1_E0E		(BIT(24))
-#define SCTLR_EL1_SPAN		(BIT(23))
-#define SCTLR_EL1_NTWE		(BIT(18))
-#define SCTLR_EL1_NTWI		(BIT(16))
-#define SCTLR_EL1_UCT		(BIT(15))
-#define SCTLR_EL1_DZE		(BIT(14))
-#define SCTLR_EL1_UMA		(BIT(9))
-#define SCTLR_EL1_SED		(BIT(8))
-#define SCTLR_EL1_ITD		(BIT(7))
-#define SCTLR_EL1_CP15BEN	(BIT(5))
-#define SCTLR_EL1_SA0		(BIT(4))
-
-#define SCTLR_EL1_RES1	((BIT(11)) | (BIT(20)) | (BIT(22)) | (BIT(28)) | \
-			 (BIT(29)))
-
 #ifdef CONFIG_CPU_BIG_ENDIAN
 #define ENDIAN_SET_EL1		(SCTLR_EL1_E0E | SCTLR_ELx_EE)
 #else
@@ -692,14 +532,17 @@
 #endif
 
 #define INIT_SCTLR_EL1_MMU_OFF \
-	(ENDIAN_SET_EL1 | SCTLR_EL1_RES1)
+	(ENDIAN_SET_EL1 | SCTLR_EL1_LSMAOE | SCTLR_EL1_nTLSMD | \
+	 SCTLR_EL1_EIS  | SCTLR_EL1_TSCXT  | SCTLR_EL1_EOS)
 
 #define INIT_SCTLR_EL1_MMU_ON \
-	(SCTLR_ELx_M    | SCTLR_ELx_C    | SCTLR_ELx_SA   | SCTLR_EL1_SA0   | \
-	 SCTLR_EL1_SED  | SCTLR_ELx_I    | SCTLR_EL1_DZE  | SCTLR_EL1_UCT   | \
-	 SCTLR_EL1_NTWE | SCTLR_ELx_IESB | SCTLR_EL1_SPAN | SCTLR_ELx_ITFSB | \
-	 SCTLR_ELx_ATA  | SCTLR_EL1_ATA0 | ENDIAN_SET_EL1 | SCTLR_EL1_UCI   | \
-	 SCTLR_EL1_EPAN | SCTLR_EL1_RES1)
+	(SCTLR_ELx_M      | SCTLR_ELx_C      | SCTLR_ELx_SA    | \
+	 SCTLR_EL1_SA0    | SCTLR_EL1_SED    | SCTLR_ELx_I     | \
+	 SCTLR_EL1_DZE    | SCTLR_EL1_UCT    | SCTLR_EL1_nTWE  | \
+	 SCTLR_ELx_IESB   | SCTLR_EL1_SPAN   | SCTLR_ELx_ITFSB | \
+	 ENDIAN_SET_EL1   | SCTLR_EL1_UCI    | SCTLR_EL1_EPAN  | \
+	 SCTLR_EL1_LSMAOE | SCTLR_EL1_nTLSMD | SCTLR_EL1_EIS   | \
+	 SCTLR_EL1_TSCXT  | SCTLR_EL1_EOS)
 
 /* MAIR_ELx memory attributes (used by Linux) */
 #define MAIR_ATTR_DEVICE_nGnRnE		UL(0x00)
@@ -712,387 +555,68 @@
 /* Position the attr at the correct index */
 #define MAIR_ATTRIDX(attr, idx)		((attr) << ((idx) * 8))
 
-/* id_aa64isar0 */
-#define ID_AA64ISAR0_RNDR_SHIFT		60
-#define ID_AA64ISAR0_TLB_SHIFT		56
-#define ID_AA64ISAR0_TS_SHIFT		52
-#define ID_AA64ISAR0_FHM_SHIFT		48
-#define ID_AA64ISAR0_DP_SHIFT		44
-#define ID_AA64ISAR0_SM4_SHIFT		40
-#define ID_AA64ISAR0_SM3_SHIFT		36
-#define ID_AA64ISAR0_SHA3_SHIFT		32
-#define ID_AA64ISAR0_RDM_SHIFT		28
-#define ID_AA64ISAR0_ATOMICS_SHIFT	20
-#define ID_AA64ISAR0_CRC32_SHIFT	16
-#define ID_AA64ISAR0_SHA2_SHIFT		12
-#define ID_AA64ISAR0_SHA1_SHIFT		8
-#define ID_AA64ISAR0_AES_SHIFT		4
-
-#define ID_AA64ISAR0_TLB_RANGE_NI	0x0
-#define ID_AA64ISAR0_TLB_RANGE		0x2
-
-/* id_aa64isar1 */
-#define ID_AA64ISAR1_I8MM_SHIFT		52
-#define ID_AA64ISAR1_DGH_SHIFT		48
-#define ID_AA64ISAR1_BF16_SHIFT		44
-#define ID_AA64ISAR1_SPECRES_SHIFT	40
-#define ID_AA64ISAR1_SB_SHIFT		36
-#define ID_AA64ISAR1_FRINTTS_SHIFT	32
-#define ID_AA64ISAR1_GPI_SHIFT		28
-#define ID_AA64ISAR1_GPA_SHIFT		24
-#define ID_AA64ISAR1_LRCPC_SHIFT	20
-#define ID_AA64ISAR1_FCMA_SHIFT		16
-#define ID_AA64ISAR1_JSCVT_SHIFT	12
-#define ID_AA64ISAR1_API_SHIFT		8
-#define ID_AA64ISAR1_APA_SHIFT		4
-#define ID_AA64ISAR1_DPB_SHIFT		0
-
-#define ID_AA64ISAR1_APA_NI			0x0
-#define ID_AA64ISAR1_APA_ARCHITECTED		0x1
-#define ID_AA64ISAR1_APA_ARCH_EPAC		0x2
-#define ID_AA64ISAR1_APA_ARCH_EPAC2		0x3
-#define ID_AA64ISAR1_APA_ARCH_EPAC2_FPAC	0x4
-#define ID_AA64ISAR1_APA_ARCH_EPAC2_FPAC_CMB	0x5
-#define ID_AA64ISAR1_API_NI			0x0
-#define ID_AA64ISAR1_API_IMP_DEF		0x1
-#define ID_AA64ISAR1_API_IMP_DEF_EPAC		0x2
-#define ID_AA64ISAR1_API_IMP_DEF_EPAC2		0x3
-#define ID_AA64ISAR1_API_IMP_DEF_EPAC2_FPAC	0x4
-#define ID_AA64ISAR1_API_IMP_DEF_EPAC2_FPAC_CMB	0x5
-#define ID_AA64ISAR1_GPA_NI			0x0
-#define ID_AA64ISAR1_GPA_ARCHITECTED		0x1
-#define ID_AA64ISAR1_GPI_NI			0x0
-#define ID_AA64ISAR1_GPI_IMP_DEF		0x1
-
 /* id_aa64pfr0 */
-#define ID_AA64PFR0_CSV3_SHIFT		60
-#define ID_AA64PFR0_CSV2_SHIFT		56
-#define ID_AA64PFR0_DIT_SHIFT		48
-#define ID_AA64PFR0_AMU_SHIFT		44
-#define ID_AA64PFR0_MPAM_SHIFT		40
-#define ID_AA64PFR0_SEL2_SHIFT		36
-#define ID_AA64PFR0_SVE_SHIFT		32
-#define ID_AA64PFR0_RAS_SHIFT		28
-#define ID_AA64PFR0_GIC_SHIFT		24
-#define ID_AA64PFR0_ASIMD_SHIFT		20
-#define ID_AA64PFR0_FP_SHIFT		16
-#define ID_AA64PFR0_EL3_SHIFT		12
-#define ID_AA64PFR0_EL2_SHIFT		8
-#define ID_AA64PFR0_EL1_SHIFT		4
-#define ID_AA64PFR0_EL0_SHIFT		0
-
-#define ID_AA64PFR0_AMU			0x1
-#define ID_AA64PFR0_SVE			0x1
-#define ID_AA64PFR0_RAS_V1		0x1
-#define ID_AA64PFR0_RAS_V1P1		0x2
-#define ID_AA64PFR0_FP_NI		0xf
-#define ID_AA64PFR0_FP_SUPPORTED	0x0
-#define ID_AA64PFR0_ASIMD_NI		0xf
-#define ID_AA64PFR0_ASIMD_SUPPORTED	0x0
-#define ID_AA64PFR0_ELx_64BIT_ONLY	0x1
-#define ID_AA64PFR0_ELx_32BIT_64BIT	0x2
-
-/* id_aa64pfr1 */
-#define ID_AA64PFR1_MPAMFRAC_SHIFT	16
-#define ID_AA64PFR1_RASFRAC_SHIFT	12
-#define ID_AA64PFR1_MTE_SHIFT		8
-#define ID_AA64PFR1_SSBS_SHIFT		4
-#define ID_AA64PFR1_BT_SHIFT		0
-
-#define ID_AA64PFR1_SSBS_PSTATE_NI	0
-#define ID_AA64PFR1_SSBS_PSTATE_ONLY	1
-#define ID_AA64PFR1_SSBS_PSTATE_INSNS	2
-#define ID_AA64PFR1_BT_BTI		0x1
-
-#define ID_AA64PFR1_MTE_NI		0x0
-#define ID_AA64PFR1_MTE_EL0		0x1
-#define ID_AA64PFR1_MTE			0x2
-
-/* id_aa64zfr0 */
-#define ID_AA64ZFR0_F64MM_SHIFT		56
-#define ID_AA64ZFR0_F32MM_SHIFT		52
-#define ID_AA64ZFR0_I8MM_SHIFT		44
-#define ID_AA64ZFR0_SM4_SHIFT		40
-#define ID_AA64ZFR0_SHA3_SHIFT		32
-#define ID_AA64ZFR0_BF16_SHIFT		20
-#define ID_AA64ZFR0_BITPERM_SHIFT	16
-#define ID_AA64ZFR0_AES_SHIFT		4
-#define ID_AA64ZFR0_SVEVER_SHIFT	0
-
-#define ID_AA64ZFR0_F64MM		0x1
-#define ID_AA64ZFR0_F32MM		0x1
-#define ID_AA64ZFR0_I8MM		0x1
-#define ID_AA64ZFR0_BF16		0x1
-#define ID_AA64ZFR0_SM4			0x1
-#define ID_AA64ZFR0_SHA3		0x1
-#define ID_AA64ZFR0_BITPERM		0x1
-#define ID_AA64ZFR0_AES			0x1
-#define ID_AA64ZFR0_AES_PMULL		0x2
-#define ID_AA64ZFR0_SVEVER_SVE2		0x1
+#define ID_AA64PFR0_EL1_ELx_64BIT_ONLY		0x1
+#define ID_AA64PFR0_EL1_ELx_32BIT_64BIT		0x2
 
 /* id_aa64mmfr0 */
-#define ID_AA64MMFR0_ECV_SHIFT		60
-#define ID_AA64MMFR0_FGT_SHIFT		56
-#define ID_AA64MMFR0_EXS_SHIFT		44
-#define ID_AA64MMFR0_TGRAN4_2_SHIFT	40
-#define ID_AA64MMFR0_TGRAN64_2_SHIFT	36
-#define ID_AA64MMFR0_TGRAN16_2_SHIFT	32
-#define ID_AA64MMFR0_TGRAN4_SHIFT	28
-#define ID_AA64MMFR0_TGRAN64_SHIFT	24
-#define ID_AA64MMFR0_TGRAN16_SHIFT	20
-#define ID_AA64MMFR0_BIGENDEL0_SHIFT	16
-#define ID_AA64MMFR0_SNSMEM_SHIFT	12
-#define ID_AA64MMFR0_BIGENDEL_SHIFT	8
-#define ID_AA64MMFR0_ASID_SHIFT		4
-#define ID_AA64MMFR0_PARANGE_SHIFT	0
-
-#define ID_AA64MMFR0_ASID_8		0x0
-#define ID_AA64MMFR0_ASID_16		0x2
-
-#define ID_AA64MMFR0_TGRAN4_NI			0xf
-#define ID_AA64MMFR0_TGRAN4_SUPPORTED_MIN	0x0
-#define ID_AA64MMFR0_TGRAN4_SUPPORTED_MAX	0x7
-#define ID_AA64MMFR0_TGRAN64_NI			0xf
-#define ID_AA64MMFR0_TGRAN64_SUPPORTED_MIN	0x0
-#define ID_AA64MMFR0_TGRAN64_SUPPORTED_MAX	0x7
-#define ID_AA64MMFR0_TGRAN16_NI			0x0
-#define ID_AA64MMFR0_TGRAN16_SUPPORTED_MIN	0x1
-#define ID_AA64MMFR0_TGRAN16_SUPPORTED_MAX	0xf
-
-#define ID_AA64MMFR0_PARANGE_32		0x0
-#define ID_AA64MMFR0_PARANGE_36		0x1
-#define ID_AA64MMFR0_PARANGE_40		0x2
-#define ID_AA64MMFR0_PARANGE_42		0x3
-#define ID_AA64MMFR0_PARANGE_44		0x4
-#define ID_AA64MMFR0_PARANGE_48		0x5
-#define ID_AA64MMFR0_PARANGE_52		0x6
+#define ID_AA64MMFR0_EL1_TGRAN4_SUPPORTED_MIN	0x0
+#define ID_AA64MMFR0_EL1_TGRAN4_SUPPORTED_MAX	0x7
+#define ID_AA64MMFR0_EL1_TGRAN64_SUPPORTED_MIN	0x0
+#define ID_AA64MMFR0_EL1_TGRAN64_SUPPORTED_MAX	0x7
+#define ID_AA64MMFR0_EL1_TGRAN16_SUPPORTED_MIN	0x1
+#define ID_AA64MMFR0_EL1_TGRAN16_SUPPORTED_MAX	0xf
 
 #define ARM64_MIN_PARANGE_BITS		32
 
-#define ID_AA64MMFR0_TGRAN_2_SUPPORTED_DEFAULT	0x0
-#define ID_AA64MMFR0_TGRAN_2_SUPPORTED_NONE	0x1
-#define ID_AA64MMFR0_TGRAN_2_SUPPORTED_MIN	0x2
-#define ID_AA64MMFR0_TGRAN_2_SUPPORTED_MAX	0x7
+#define ID_AA64MMFR0_EL1_TGRAN_2_SUPPORTED_DEFAULT	0x0
+#define ID_AA64MMFR0_EL1_TGRAN_2_SUPPORTED_NONE		0x1
+#define ID_AA64MMFR0_EL1_TGRAN_2_SUPPORTED_MIN		0x2
+#define ID_AA64MMFR0_EL1_TGRAN_2_SUPPORTED_MAX		0x7
 
 #ifdef CONFIG_ARM64_PA_BITS_52
-#define ID_AA64MMFR0_PARANGE_MAX	ID_AA64MMFR0_PARANGE_52
+#define ID_AA64MMFR0_EL1_PARANGE_MAX	ID_AA64MMFR0_EL1_PARANGE_52
 #else
-#define ID_AA64MMFR0_PARANGE_MAX	ID_AA64MMFR0_PARANGE_48
+#define ID_AA64MMFR0_EL1_PARANGE_MAX	ID_AA64MMFR0_EL1_PARANGE_48
 #endif
 
-/* id_aa64mmfr1 */
-#define ID_AA64MMFR1_ETS_SHIFT		36
-#define ID_AA64MMFR1_TWED_SHIFT		32
-#define ID_AA64MMFR1_XNX_SHIFT		28
-#define ID_AA64MMFR1_SPECSEI_SHIFT	24
-#define ID_AA64MMFR1_PAN_SHIFT		20
-#define ID_AA64MMFR1_LOR_SHIFT		16
-#define ID_AA64MMFR1_HPD_SHIFT		12
-#define ID_AA64MMFR1_VHE_SHIFT		8
-#define ID_AA64MMFR1_VMIDBITS_SHIFT	4
-#define ID_AA64MMFR1_HADBS_SHIFT	0
-
-#define ID_AA64MMFR1_VMIDBITS_8		0
-#define ID_AA64MMFR1_VMIDBITS_16	2
-
-/* id_aa64mmfr2 */
-#define ID_AA64MMFR2_E0PD_SHIFT		60
-#define ID_AA64MMFR2_EVT_SHIFT		56
-#define ID_AA64MMFR2_BBM_SHIFT		52
-#define ID_AA64MMFR2_TTL_SHIFT		48
-#define ID_AA64MMFR2_FWB_SHIFT		40
-#define ID_AA64MMFR2_IDS_SHIFT		36
-#define ID_AA64MMFR2_AT_SHIFT		32
-#define ID_AA64MMFR2_ST_SHIFT		28
-#define ID_AA64MMFR2_NV_SHIFT		24
-#define ID_AA64MMFR2_CCIDX_SHIFT	20
-#define ID_AA64MMFR2_LVA_SHIFT		16
-#define ID_AA64MMFR2_IESB_SHIFT		12
-#define ID_AA64MMFR2_LSM_SHIFT		8
-#define ID_AA64MMFR2_UAO_SHIFT		4
-#define ID_AA64MMFR2_CNP_SHIFT		0
-
-/* id_aa64dfr0 */
-#define ID_AA64DFR0_MTPMU_SHIFT		48
-#define ID_AA64DFR0_TRBE_SHIFT		44
-#define ID_AA64DFR0_TRACE_FILT_SHIFT	40
-#define ID_AA64DFR0_DOUBLELOCK_SHIFT	36
-#define ID_AA64DFR0_PMSVER_SHIFT	32
-#define ID_AA64DFR0_CTX_CMPS_SHIFT	28
-#define ID_AA64DFR0_WRPS_SHIFT		20
-#define ID_AA64DFR0_BRPS_SHIFT		12
-#define ID_AA64DFR0_PMUVER_SHIFT	8
-#define ID_AA64DFR0_TRACEVER_SHIFT	4
-#define ID_AA64DFR0_DEBUGVER_SHIFT	0
-
-#define ID_AA64DFR0_PMUVER_8_0		0x1
-#define ID_AA64DFR0_PMUVER_8_1		0x4
-#define ID_AA64DFR0_PMUVER_8_4		0x5
-#define ID_AA64DFR0_PMUVER_8_5		0x6
-#define ID_AA64DFR0_PMUVER_IMP_DEF	0xf
-
-#define ID_AA64DFR0_PMSVER_8_2		0x1
-#define ID_AA64DFR0_PMSVER_8_3		0x2
-
-#define ID_DFR0_PERFMON_SHIFT		24
-
-#define ID_DFR0_PERFMON_8_0		0x3
-#define ID_DFR0_PERFMON_8_1		0x4
-#define ID_DFR0_PERFMON_8_4		0x5
-#define ID_DFR0_PERFMON_8_5		0x6
-
-#define ID_ISAR4_SWP_FRAC_SHIFT		28
-#define ID_ISAR4_PSR_M_SHIFT		24
-#define ID_ISAR4_SYNCH_PRIM_FRAC_SHIFT	20
-#define ID_ISAR4_BARRIER_SHIFT		16
-#define ID_ISAR4_SMC_SHIFT		12
-#define ID_ISAR4_WRITEBACK_SHIFT	8
-#define ID_ISAR4_WITHSHIFTS_SHIFT	4
-#define ID_ISAR4_UNPRIV_SHIFT		0
-
-#define ID_DFR1_MTPMU_SHIFT		0
-
-#define ID_ISAR0_DIVIDE_SHIFT		24
-#define ID_ISAR0_DEBUG_SHIFT		20
-#define ID_ISAR0_COPROC_SHIFT		16
-#define ID_ISAR0_CMPBRANCH_SHIFT	12
-#define ID_ISAR0_BITFIELD_SHIFT		8
-#define ID_ISAR0_BITCOUNT_SHIFT		4
-#define ID_ISAR0_SWAP_SHIFT		0
-
-#define ID_ISAR5_RDM_SHIFT		24
-#define ID_ISAR5_CRC32_SHIFT		16
-#define ID_ISAR5_SHA2_SHIFT		12
-#define ID_ISAR5_SHA1_SHIFT		8
-#define ID_ISAR5_AES_SHIFT		4
-#define ID_ISAR5_SEVL_SHIFT		0
-
-#define ID_ISAR6_I8MM_SHIFT		24
-#define ID_ISAR6_BF16_SHIFT		20
-#define ID_ISAR6_SPECRES_SHIFT		16
-#define ID_ISAR6_SB_SHIFT		12
-#define ID_ISAR6_FHM_SHIFT		8
-#define ID_ISAR6_DP_SHIFT		4
-#define ID_ISAR6_JSCVT_SHIFT		0
-
-#define ID_MMFR0_INNERSHR_SHIFT		28
-#define ID_MMFR0_FCSE_SHIFT		24
-#define ID_MMFR0_AUXREG_SHIFT		20
-#define ID_MMFR0_TCM_SHIFT		16
-#define ID_MMFR0_SHARELVL_SHIFT		12
-#define ID_MMFR0_OUTERSHR_SHIFT		8
-#define ID_MMFR0_PMSA_SHIFT		4
-#define ID_MMFR0_VMSA_SHIFT		0
-
-#define ID_MMFR4_EVT_SHIFT		28
-#define ID_MMFR4_CCIDX_SHIFT		24
-#define ID_MMFR4_LSM_SHIFT		20
-#define ID_MMFR4_HPDS_SHIFT		16
-#define ID_MMFR4_CNP_SHIFT		12
-#define ID_MMFR4_XNX_SHIFT		8
-#define ID_MMFR4_AC2_SHIFT		4
-#define ID_MMFR4_SPECSEI_SHIFT		0
-
-#define ID_MMFR5_ETS_SHIFT		0
-
-#define ID_PFR0_DIT_SHIFT		24
-#define ID_PFR0_CSV2_SHIFT		16
-#define ID_PFR0_STATE3_SHIFT		12
-#define ID_PFR0_STATE2_SHIFT		8
-#define ID_PFR0_STATE1_SHIFT		4
-#define ID_PFR0_STATE0_SHIFT		0
-
-#define ID_DFR0_PERFMON_SHIFT		24
-#define ID_DFR0_MPROFDBG_SHIFT		20
-#define ID_DFR0_MMAPTRC_SHIFT		16
-#define ID_DFR0_COPTRC_SHIFT		12
-#define ID_DFR0_MMAPDBG_SHIFT		8
-#define ID_DFR0_COPSDBG_SHIFT		4
-#define ID_DFR0_COPDBG_SHIFT		0
-
-#define ID_PFR2_SSBS_SHIFT		4
-#define ID_PFR2_CSV3_SHIFT		0
-
-#define MVFR0_FPROUND_SHIFT		28
-#define MVFR0_FPSHVEC_SHIFT		24
-#define MVFR0_FPSQRT_SHIFT		20
-#define MVFR0_FPDIVIDE_SHIFT		16
-#define MVFR0_FPTRAP_SHIFT		12
-#define MVFR0_FPDP_SHIFT		8
-#define MVFR0_FPSP_SHIFT		4
-#define MVFR0_SIMD_SHIFT		0
-
-#define MVFR1_SIMDFMAC_SHIFT		28
-#define MVFR1_FPHP_SHIFT		24
-#define MVFR1_SIMDHP_SHIFT		20
-#define MVFR1_SIMDSP_SHIFT		16
-#define MVFR1_SIMDINT_SHIFT		12
-#define MVFR1_SIMDLS_SHIFT		8
-#define MVFR1_FPDNAN_SHIFT		4
-#define MVFR1_FPFTZ_SHIFT		0
-
-#define ID_PFR1_GIC_SHIFT		28
-#define ID_PFR1_VIRT_FRAC_SHIFT		24
-#define ID_PFR1_SEC_FRAC_SHIFT		20
-#define ID_PFR1_GENTIMER_SHIFT		16
-#define ID_PFR1_VIRTUALIZATION_SHIFT	12
-#define ID_PFR1_MPROGMOD_SHIFT		8
-#define ID_PFR1_SECURITY_SHIFT		4
-#define ID_PFR1_PROGMOD_SHIFT		0
-
 #if defined(CONFIG_ARM64_4K_PAGES)
-#define ID_AA64MMFR0_TGRAN_SHIFT		ID_AA64MMFR0_TGRAN4_SHIFT
-#define ID_AA64MMFR0_TGRAN_SUPPORTED_MIN	ID_AA64MMFR0_TGRAN4_SUPPORTED_MIN
-#define ID_AA64MMFR0_TGRAN_SUPPORTED_MAX	ID_AA64MMFR0_TGRAN4_SUPPORTED_MAX
-#define ID_AA64MMFR0_TGRAN_2_SHIFT		ID_AA64MMFR0_TGRAN4_2_SHIFT
+#define ID_AA64MMFR0_EL1_TGRAN_SHIFT		ID_AA64MMFR0_EL1_TGRAN4_SHIFT
+#define ID_AA64MMFR0_EL1_TGRAN_SUPPORTED_MIN	ID_AA64MMFR0_EL1_TGRAN4_SUPPORTED_MIN
+#define ID_AA64MMFR0_EL1_TGRAN_SUPPORTED_MAX	ID_AA64MMFR0_EL1_TGRAN4_SUPPORTED_MAX
+#define ID_AA64MMFR0_EL1_TGRAN_2_SHIFT		ID_AA64MMFR0_EL1_TGRAN4_2_SHIFT
 #elif defined(CONFIG_ARM64_16K_PAGES)
-#define ID_AA64MMFR0_TGRAN_SHIFT		ID_AA64MMFR0_TGRAN16_SHIFT
-#define ID_AA64MMFR0_TGRAN_SUPPORTED_MIN	ID_AA64MMFR0_TGRAN16_SUPPORTED_MIN
-#define ID_AA64MMFR0_TGRAN_SUPPORTED_MAX	ID_AA64MMFR0_TGRAN16_SUPPORTED_MAX
-#define ID_AA64MMFR0_TGRAN_2_SHIFT		ID_AA64MMFR0_TGRAN16_2_SHIFT
+#define ID_AA64MMFR0_EL1_TGRAN_SHIFT		ID_AA64MMFR0_EL1_TGRAN16_SHIFT
+#define ID_AA64MMFR0_EL1_TGRAN_SUPPORTED_MIN	ID_AA64MMFR0_EL1_TGRAN16_SUPPORTED_MIN
+#define ID_AA64MMFR0_EL1_TGRAN_SUPPORTED_MAX	ID_AA64MMFR0_EL1_TGRAN16_SUPPORTED_MAX
+#define ID_AA64MMFR0_EL1_TGRAN_2_SHIFT		ID_AA64MMFR0_EL1_TGRAN16_2_SHIFT
 #elif defined(CONFIG_ARM64_64K_PAGES)
-#define ID_AA64MMFR0_TGRAN_SHIFT		ID_AA64MMFR0_TGRAN64_SHIFT
-#define ID_AA64MMFR0_TGRAN_SUPPORTED_MIN	ID_AA64MMFR0_TGRAN64_SUPPORTED_MIN
-#define ID_AA64MMFR0_TGRAN_SUPPORTED_MAX	ID_AA64MMFR0_TGRAN64_SUPPORTED_MAX
-#define ID_AA64MMFR0_TGRAN_2_SHIFT		ID_AA64MMFR0_TGRAN64_2_SHIFT
+#define ID_AA64MMFR0_EL1_TGRAN_SHIFT		ID_AA64MMFR0_EL1_TGRAN64_SHIFT
+#define ID_AA64MMFR0_EL1_TGRAN_SUPPORTED_MIN	ID_AA64MMFR0_EL1_TGRAN64_SUPPORTED_MIN
+#define ID_AA64MMFR0_EL1_TGRAN_SUPPORTED_MAX	ID_AA64MMFR0_EL1_TGRAN64_SUPPORTED_MAX
+#define ID_AA64MMFR0_EL1_TGRAN_2_SHIFT		ID_AA64MMFR0_EL1_TGRAN64_2_SHIFT
 #endif
 
-#define MVFR2_FPMISC_SHIFT		4
-#define MVFR2_SIMDMISC_SHIFT		0
-
-#define DCZID_DZP_SHIFT			4
-#define DCZID_BS_SHIFT			0
+#define CPACR_EL1_FPEN_EL1EN	(BIT(20)) /* enable EL1 access */
+#define CPACR_EL1_FPEN_EL0EN	(BIT(21)) /* enable EL0 access, if EL1EN set */
 
-/*
- * The ZCR_ELx_LEN_* definitions intentionally include bits [8:4] which
- * are reserved by the SVE architecture for future expansion of the LEN
- * field, with compatible semantics.
- */
-#define ZCR_ELx_LEN_SHIFT	0
-#define ZCR_ELx_LEN_SIZE	9
-#define ZCR_ELx_LEN_MASK	0x1ff
+#define CPACR_EL1_SMEN_EL1EN	(BIT(24)) /* enable EL1 access */
+#define CPACR_EL1_SMEN_EL0EN	(BIT(25)) /* enable EL0 access, if EL1EN set */
 
 #define CPACR_EL1_ZEN_EL1EN	(BIT(16)) /* enable EL1 access */
 #define CPACR_EL1_ZEN_EL0EN	(BIT(17)) /* enable EL0 access, if EL1EN set */
-#define CPACR_EL1_ZEN		(CPACR_EL1_ZEN_EL1EN | CPACR_EL1_ZEN_EL0EN)
-
-/* TCR EL1 Bit Definitions */
-#define SYS_TCR_EL1_TCMA1	(BIT(58))
-#define SYS_TCR_EL1_TCMA0	(BIT(57))
 
 /* GCR_EL1 Definitions */
 #define SYS_GCR_EL1_RRND	(BIT(16))
 #define SYS_GCR_EL1_EXCL_MASK	0xffffUL
 
+#define KERNEL_GCR_EL1		(SYS_GCR_EL1_RRND | KERNEL_GCR_EL1_EXCL)
+
 /* RGSR_EL1 Definitions */
 #define SYS_RGSR_EL1_TAG_MASK	0xfUL
 #define SYS_RGSR_EL1_SEED_SHIFT	8
 #define SYS_RGSR_EL1_SEED_MASK	0xffffUL
 
-/* GMID_EL1 field definitions */
-#define SYS_GMID_EL1_BS_SHIFT	0
-#define SYS_GMID_EL1_BS_SIZE	4
-
 /* TFSR{,E0}_EL1 bit definitions */
 #define SYS_TFSR_EL1_TF0_SHIFT	0
 #define SYS_TFSR_EL1_TF1_SHIFT	1
@@ -1103,6 +627,7 @@
 #define SYS_MPIDR_SAFE_VAL	(BIT(31))
 
 #define TRFCR_ELx_TS_SHIFT		5
+#define TRFCR_ELx_TS_MASK		((0x3UL) << TRFCR_ELx_TS_SHIFT)
 #define TRFCR_ELx_TS_VIRTUAL		((0x1UL) << TRFCR_ELx_TS_SHIFT)
 #define TRFCR_ELx_TS_GUEST_PHYSICAL	((0x2UL) << TRFCR_ELx_TS_SHIFT)
 #define TRFCR_ELx_TS_PHYSICAL		((0x3UL) << TRFCR_ELx_TS_SHIFT)
@@ -1110,7 +635,6 @@
 #define TRFCR_ELx_ExTRE			BIT(1)
 #define TRFCR_ELx_E0TRE			BIT(0)
 
-
 /* GIC Hypervisor interface registers */
 /* ICH_MISR_EL2 bit definitions */
 #define ICH_MISR_EOI		(1 << 0)
@@ -1137,6 +661,7 @@
 #define ICH_HCR_TC		(1 << 10)
 #define ICH_HCR_TALL0		(1 << 11)
 #define ICH_HCR_TALL1		(1 << 12)
+#define ICH_HCR_TDIR		(1 << 14)
 #define ICH_HCR_EOIcount_SHIFT	27
 #define ICH_HCR_EOIcount_MASK	(0x1f << ICH_HCR_EOIcount_SHIFT)
 
@@ -1169,49 +694,60 @@
 #define ICH_VTR_SEIS_MASK	(1 << ICH_VTR_SEIS_SHIFT)
 #define ICH_VTR_A3V_SHIFT	21
 #define ICH_VTR_A3V_MASK	(1 << ICH_VTR_A3V_SHIFT)
+#define ICH_VTR_TDS_SHIFT	19
+#define ICH_VTR_TDS_MASK	(1 << ICH_VTR_TDS_SHIFT)
+
+/*
+ * Permission Indirection Extension (PIE) permission encodings.
+ * Encodings with the _O suffix, have overlays applied (Permission Overlay Extension).
+ */
+#define PIE_NONE_O	0x0
+#define PIE_R_O		0x1
+#define PIE_X_O		0x2
+#define PIE_RX_O	0x3
+#define PIE_RW_O	0x5
+#define PIE_RWnX_O	0x6
+#define PIE_RWX_O	0x7
+#define PIE_R		0x8
+#define PIE_GCS		0x9
+#define PIE_RX		0xa
+#define PIE_RW		0xc
+#define PIE_RWX		0xe
+
+#define PIRx_ELx_PERM(idx, perm)	((perm) << ((idx) * 4))
 
 #define ARM64_FEATURE_FIELD_BITS	4
 
-/* Create a mask for the feature bits of the specified feature. */
-#define ARM64_FEATURE_MASK(x)	(GENMASK_ULL(x##_SHIFT + ARM64_FEATURE_FIELD_BITS - 1, x##_SHIFT))
+/* Defined for compatibility only, do not add new users. */
+#define ARM64_FEATURE_MASK(x)	(x##_MASK)
 
 #ifdef __ASSEMBLY__
 
-	.irp	num,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30
-	.equ	.L__reg_num_x\num, \num
-	.endr
-	.equ	.L__reg_num_xzr, 31
-
 	.macro	mrs_s, rt, sreg
-	 __emit_inst(0xd5200000|(\sreg)|(.L__reg_num_\rt))
+	 __emit_inst(0xd5200000|(\sreg)|(.L__gpr_num_\rt))
 	.endm
 
 	.macro	msr_s, sreg, rt
-	__emit_inst(0xd5000000|(\sreg)|(.L__reg_num_\rt))
+	__emit_inst(0xd5000000|(\sreg)|(.L__gpr_num_\rt))
 	.endm
 
 #else
 
+#include <linux/bitfield.h>
 #include <linux/build_bug.h>
 #include <linux/types.h>
 #include <asm/alternative.h>
 
-#define __DEFINE_MRS_MSR_S_REGNUM				\
-"	.irp	num,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30\n" \
-"	.equ	.L__reg_num_x\\num, \\num\n"			\
-"	.endr\n"						\
-"	.equ	.L__reg_num_xzr, 31\n"
-
 #define DEFINE_MRS_S						\
-	__DEFINE_MRS_MSR_S_REGNUM				\
+	__DEFINE_ASM_GPR_NUMS					\
 "	.macro	mrs_s, rt, sreg\n"				\
-	__emit_inst(0xd5200000|(\\sreg)|(.L__reg_num_\\rt))	\
+	__emit_inst(0xd5200000|(\\sreg)|(.L__gpr_num_\\rt))	\
 "	.endm\n"
 
 #define DEFINE_MSR_S						\
-	__DEFINE_MRS_MSR_S_REGNUM				\
+	__DEFINE_ASM_GPR_NUMS					\
 "	.macro	msr_s, sreg, rt\n"				\
-	__emit_inst(0xd5000000|(\\sreg)|(.L__reg_num_\\rt))	\
+	__emit_inst(0xd5000000|(\\sreg)|(.L__gpr_num_\\rt))	\
 "	.endm\n"
 
 #define UNDEFINE_MRS_S						\
@@ -1291,6 +827,15 @@
 	par;								\
 })
 
+#define SYS_FIELD_GET(reg, field, val)		\
+		 FIELD_GET(reg##_##field##_MASK, val)
+
+#define SYS_FIELD_PREP(reg, field, val)		\
+		 FIELD_PREP(reg##_##field##_MASK, val)
+
+#define SYS_FIELD_PREP_ENUM(reg, field, val)		\
+		 FIELD_PREP(reg##_##field##_MASK, reg##_##field##_##val)
+
 #endif
 
 #endif	/* __ASM_SYSREG_H */
diff --git a/tools/testing/selftests/kvm/aarch64/aarch32_id_regs.c b/tools/testing/selftests/kvm/aarch64/aarch32_id_regs.c
index b90580840b22..8e5bd07a3727 100644
--- a/tools/testing/selftests/kvm/aarch64/aarch32_id_regs.c
+++ b/tools/testing/selftests/kvm/aarch64/aarch32_id_regs.c
@@ -146,8 +146,8 @@ static bool vcpu_aarch64_only(struct kvm_vcpu *vcpu)
 
 	vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64PFR0_EL1), &val);
 
-	el0 = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL0), val);
-	return el0 == ID_AA64PFR0_ELx_64BIT_ONLY;
+	el0 = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_EL0), val);
+	return el0 == ID_AA64PFR0_EL1_ELx_64BIT_ONLY;
 }
 
 int main(void)
diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
index f5b6cb3a0019..866002917441 100644
--- a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
+++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
@@ -116,12 +116,12 @@ static void reset_debug_state(void)
 
 	/* Reset all bcr/bvr/wcr/wvr registers */
 	dfr0 = read_sysreg(id_aa64dfr0_el1);
-	brps = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_BRPS), dfr0);
+	brps = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_BRPs), dfr0);
 	for (i = 0; i <= brps; i++) {
 		write_dbgbcr(i, 0);
 		write_dbgbvr(i, 0);
 	}
-	wrps = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_WRPS), dfr0);
+	wrps = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_WRPs), dfr0);
 	for (i = 0; i <= wrps; i++) {
 		write_dbgwcr(i, 0);
 		write_dbgwvr(i, 0);
@@ -418,7 +418,7 @@ static void guest_code_ss(int test_cnt)
 
 static int debug_version(uint64_t id_aa64dfr0)
 {
-	return FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_DEBUGVER), id_aa64dfr0);
+	return FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_DebugVer), id_aa64dfr0);
 }
 
 static void test_guest_debug_exceptions(uint8_t bpn, uint8_t wpn, uint8_t ctx_bpn)
@@ -539,14 +539,14 @@ void test_guest_debug_exceptions_all(uint64_t aa64dfr0)
 	int b, w, c;
 
 	/* Number of breakpoints */
-	brp_num = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_BRPS), aa64dfr0) + 1;
+	brp_num = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_BRPs), aa64dfr0) + 1;
 	__TEST_REQUIRE(brp_num >= 2, "At least two breakpoints are required");
 
 	/* Number of watchpoints */
-	wrp_num = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_WRPS), aa64dfr0) + 1;
+	wrp_num = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_WRPs), aa64dfr0) + 1;
 
 	/* Number of context aware breakpoints */
-	ctx_brp_num = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_CTX_CMPS), aa64dfr0) + 1;
+	ctx_brp_num = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_CTX_CMPs), aa64dfr0) + 1;
 
 	pr_debug("%s brp_num:%d, wrp_num:%d, ctx_brp_num:%d\n", __func__,
 		 brp_num, wrp_num, ctx_brp_num);
diff --git a/tools/testing/selftests/kvm/aarch64/page_fault_test.c b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
index 47bb914ab2fa..975d28be3cca 100644
--- a/tools/testing/selftests/kvm/aarch64/page_fault_test.c
+++ b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
@@ -96,14 +96,14 @@ static bool guest_check_lse(void)
 	uint64_t isar0 = read_sysreg(id_aa64isar0_el1);
 	uint64_t atomic;
 
-	atomic = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64ISAR0_ATOMICS), isar0);
+	atomic = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64ISAR0_EL1_ATOMIC), isar0);
 	return atomic >= 2;
 }
 
 static bool guest_check_dc_zva(void)
 {
 	uint64_t dczid = read_sysreg(dczid_el0);
-	uint64_t dzp = FIELD_GET(ARM64_FEATURE_MASK(DCZID_DZP), dczid);
+	uint64_t dzp = FIELD_GET(ARM64_FEATURE_MASK(DCZID_EL0_DZP), dczid);
 
 	return dzp == 0;
 }
@@ -196,7 +196,7 @@ static bool guest_set_ha(void)
 	uint64_t hadbs, tcr;
 
 	/* Skip if HA is not supported. */
-	hadbs = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64MMFR1_HADBS), mmfr1);
+	hadbs = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64MMFR1_EL1_HAFDBS), mmfr1);
 	if (hadbs == 0)
 		return false;
 
diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
index 3a0259e25335..6fe12e985ba5 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
@@ -518,9 +518,9 @@ void aarch64_get_supported_page_sizes(uint32_t ipa,
 	err = ioctl(vcpu_fd, KVM_GET_ONE_REG, &reg);
 	TEST_ASSERT(err == 0, KVM_IOCTL_ERROR(KVM_GET_ONE_REG, vcpu_fd));
 
-	*ps4k = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64MMFR0_TGRAN4), val) != 0xf;
-	*ps64k = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64MMFR0_TGRAN64), val) == 0;
-	*ps16k = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64MMFR0_TGRAN16), val) != 0;
+	*ps4k = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64MMFR0_EL1_TGRAN4), val) != 0xf;
+	*ps64k = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64MMFR0_EL1_TGRAN64), val) == 0;
+	*ps16k = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64MMFR0_EL1_TGRAN16), val) != 0;
 
 	close(vcpu_fd);
 	close(vm_fd);
-- 
2.42.0.609.gbb76f46606-goog

