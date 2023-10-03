Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0B517B747B
	for <lists+kvm@lfdr.de>; Wed,  4 Oct 2023 01:04:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234628AbjJCXEy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Oct 2023 19:04:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232736AbjJCXEw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Oct 2023 19:04:52 -0400
Received: from out-202.mta0.migadu.com (out-202.mta0.migadu.com [IPv6:2001:41d0:1004:224b::ca])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88550DA
        for <kvm@vger.kernel.org>; Tue,  3 Oct 2023 16:04:41 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1696374280;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/Y1isXWGvezz1P0bOyEz6lZN897PUg8no+jgQD4aSXY=;
        b=aUkOR2lcKZekXr4Ow5KvS6lRjuwEMAGCMWJPiF3LaHXhA2YemhoPdoHwrL5BAaj5GZbMjh
        VFXMx9relpIjcXXSSgNKEhtOBGbZsED6NtNwfa/UY47WzFsC/Swem00yxieGlqXdc47nO4
        2/q8d278Mk/HhkjZgSndDW6GoFcb4Ns=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Jing Zhang <jingzhangos@google.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v11 11/12] KVM: arm64: selftests: Import automatic generation of sysreg defs
Date:   Tue,  3 Oct 2023 23:04:07 +0000
Message-ID: <20231003230408.3405722-12-oliver.upton@linux.dev>
In-Reply-To: <20231003230408.3405722-1-oliver.upton@linux.dev>
References: <20231003230408.3405722-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jing Zhang <jingzhangos@google.com>

Import automatic system register definition generation from kernel and
update system register usage accordingly.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 tools/arch/arm64/include/.gitignore           |    1 +
 tools/arch/arm64/include/asm/gpr-num.h        |   26 +
 tools/arch/arm64/include/asm/sysreg.h         |  839 ++----
 tools/arch/arm64/tools/gen-sysreg.awk         |  336 +++
 tools/arch/arm64/tools/sysreg                 | 2497 +++++++++++++++++
 tools/testing/selftests/kvm/Makefile          |   14 +-
 .../selftests/kvm/aarch64/aarch32_id_regs.c   |    4 +-
 .../selftests/kvm/aarch64/debug-exceptions.c  |   12 +-
 .../selftests/kvm/aarch64/page_fault_test.c   |    6 +-
 .../selftests/kvm/lib/aarch64/processor.c     |    6 +-
 10 files changed, 3078 insertions(+), 663 deletions(-)
 create mode 100644 tools/arch/arm64/include/.gitignore
 create mode 100644 tools/arch/arm64/include/asm/gpr-num.h
 create mode 100755 tools/arch/arm64/tools/gen-sysreg.awk
 create mode 100644 tools/arch/arm64/tools/sysreg

diff --git a/tools/arch/arm64/include/.gitignore b/tools/arch/arm64/include/.gitignore
new file mode 100644
index 000000000000..9ab870da897d
--- /dev/null
+++ b/tools/arch/arm64/include/.gitignore
@@ -0,0 +1 @@
+generated/
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
diff --git a/tools/arch/arm64/tools/gen-sysreg.awk b/tools/arch/arm64/tools/gen-sysreg.awk
new file mode 100755
index 000000000000..d1254a056114
--- /dev/null
+++ b/tools/arch/arm64/tools/gen-sysreg.awk
@@ -0,0 +1,336 @@
+#!/bin/awk -f
+# SPDX-License-Identifier: GPL-2.0
+# gen-sysreg.awk: arm64 sysreg header generator
+#
+# Usage: awk -f gen-sysreg.awk sysregs.txt
+
+function block_current() {
+	return __current_block[__current_block_depth];
+}
+
+# Log an error and terminate
+function fatal(msg) {
+	print "Error at " NR ": " msg > "/dev/stderr"
+
+	printf "Current block nesting:"
+
+	for (i = 0; i <= __current_block_depth; i++) {
+		printf " " __current_block[i]
+	}
+	printf "\n"
+
+	exit 1
+}
+
+# Enter a new block, setting the active block to @block
+function block_push(block) {
+	__current_block[++__current_block_depth] = block
+}
+
+# Exit a block, setting the active block to the parent block
+function block_pop() {
+	if (__current_block_depth == 0)
+		fatal("error: block_pop() in root block")
+
+	__current_block_depth--;
+}
+
+# Sanity check the number of records for a field makes sense. If not, produce
+# an error and terminate.
+function expect_fields(nf) {
+	if (NF != nf)
+		fatal(NF " fields found where " nf " expected")
+}
+
+# Print a CPP macro definition, padded with spaces so that the macro bodies
+# line up in a column
+function define(name, val) {
+	printf "%-56s%s\n", "#define " name, val
+}
+
+# Print standard BITMASK/SHIFT/WIDTH CPP definitions for a field
+function define_field(reg, field, msb, lsb) {
+	define(reg "_" field, "GENMASK(" msb ", " lsb ")")
+	define(reg "_" field "_MASK", "GENMASK(" msb ", " lsb ")")
+	define(reg "_" field "_SHIFT", lsb)
+	define(reg "_" field "_WIDTH", msb - lsb + 1)
+}
+
+# Print a field _SIGNED definition for a field
+function define_field_sign(reg, field, sign) {
+	define(reg "_" field "_SIGNED", sign)
+}
+
+# Parse a "<msb>[:<lsb>]" string into the global variables @msb and @lsb
+function parse_bitdef(reg, field, bitdef, _bits)
+{
+	if (bitdef ~ /^[0-9]+$/) {
+		msb = bitdef
+		lsb = bitdef
+	} else if (split(bitdef, _bits, ":") == 2) {
+		msb = _bits[1]
+		lsb = _bits[2]
+	} else {
+		fatal("invalid bit-range definition '" bitdef "'")
+	}
+
+
+	if (msb != next_bit)
+		fatal(reg "." field " starts at " msb " not " next_bit)
+	if (63 < msb || msb < 0)
+		fatal(reg "." field " invalid high bit in '" bitdef "'")
+	if (63 < lsb || lsb < 0)
+		fatal(reg "." field " invalid low bit in '" bitdef "'")
+	if (msb < lsb)
+		fatal(reg "." field " invalid bit-range '" bitdef "'")
+	if (low > high)
+		fatal(reg "." field " has invalid range " high "-" low)
+
+	next_bit = lsb - 1
+}
+
+BEGIN {
+	print "#ifndef __ASM_SYSREG_DEFS_H"
+	print "#define __ASM_SYSREG_DEFS_H"
+	print ""
+	print "/* Generated file - do not edit */"
+	print ""
+
+	__current_block_depth = 0
+	__current_block[__current_block_depth] = "Root"
+}
+
+END {
+	if (__current_block_depth != 0)
+		fatal("Missing terminator for " block_current() " block")
+
+	print "#endif /* __ASM_SYSREG_DEFS_H */"
+}
+
+# skip blank lines and comment lines
+/^$/ { next }
+/^[\t ]*#/ { next }
+
+/^SysregFields/ && block_current() == "Root" {
+	block_push("SysregFields")
+
+	expect_fields(2)
+
+	reg = $2
+
+	res0 = "UL(0)"
+	res1 = "UL(0)"
+	unkn = "UL(0)"
+
+	next_bit = 63
+
+	next
+}
+
+/^EndSysregFields/ && block_current() == "SysregFields" {
+	if (next_bit > 0)
+		fatal("Unspecified bits in " reg)
+
+	define(reg "_RES0", "(" res0 ")")
+	define(reg "_RES1", "(" res1 ")")
+	define(reg "_UNKN", "(" unkn ")")
+	print ""
+
+	reg = null
+	res0 = null
+	res1 = null
+	unkn = null
+
+	block_pop()
+	next
+}
+
+/^Sysreg/ && block_current() == "Root" {
+	block_push("Sysreg")
+
+	expect_fields(7)
+
+	reg = $2
+	op0 = $3
+	op1 = $4
+	crn = $5
+	crm = $6
+	op2 = $7
+
+	res0 = "UL(0)"
+	res1 = "UL(0)"
+	unkn = "UL(0)"
+
+	define("REG_" reg, "S" op0 "_" op1 "_C" crn "_C" crm "_" op2)
+	define("SYS_" reg, "sys_reg(" op0 ", " op1 ", " crn ", " crm ", " op2 ")")
+
+	define("SYS_" reg "_Op0", op0)
+	define("SYS_" reg "_Op1", op1)
+	define("SYS_" reg "_CRn", crn)
+	define("SYS_" reg "_CRm", crm)
+	define("SYS_" reg "_Op2", op2)
+
+	print ""
+
+	next_bit = 63
+
+	next
+}
+
+/^EndSysreg/ && block_current() == "Sysreg" {
+	if (next_bit > 0)
+		fatal("Unspecified bits in " reg)
+
+	if (res0 != null)
+		define(reg "_RES0", "(" res0 ")")
+	if (res1 != null)
+		define(reg "_RES1", "(" res1 ")")
+	if (unkn != null)
+		define(reg "_UNKN", "(" unkn ")")
+	if (res0 != null || res1 != null || unkn != null)
+		print ""
+
+	reg = null
+	op0 = null
+	op1 = null
+	crn = null
+	crm = null
+	op2 = null
+	res0 = null
+	res1 = null
+	unkn = null
+
+	block_pop()
+	next
+}
+
+# Currently this is effectivey a comment, in future we may want to emit
+# defines for the fields.
+/^Fields/ && block_current() == "Sysreg" {
+	expect_fields(2)
+
+	if (next_bit != 63)
+		fatal("Some fields already defined for " reg)
+
+	print "/* For " reg " fields see " $2 " */"
+	print ""
+
+        next_bit = 0
+	res0 = null
+	res1 = null
+	unkn = null
+
+	next
+}
+
+
+/^Res0/ && (block_current() == "Sysreg" || block_current() == "SysregFields") {
+	expect_fields(2)
+	parse_bitdef(reg, "RES0", $2)
+	field = "RES0_" msb "_" lsb
+
+	res0 = res0 " | GENMASK_ULL(" msb ", " lsb ")"
+
+	next
+}
+
+/^Res1/ && (block_current() == "Sysreg" || block_current() == "SysregFields") {
+	expect_fields(2)
+	parse_bitdef(reg, "RES1", $2)
+	field = "RES1_" msb "_" lsb
+
+	res1 = res1 " | GENMASK_ULL(" msb ", " lsb ")"
+
+	next
+}
+
+/^Unkn/ && (block_current() == "Sysreg" || block_current() == "SysregFields") {
+	expect_fields(2)
+	parse_bitdef(reg, "UNKN", $2)
+	field = "UNKN_" msb "_" lsb
+
+	unkn = unkn " | GENMASK_ULL(" msb ", " lsb ")"
+
+	next
+}
+
+/^Field/ && (block_current() == "Sysreg" || block_current() == "SysregFields") {
+	expect_fields(3)
+	field = $3
+	parse_bitdef(reg, field, $2)
+
+	define_field(reg, field, msb, lsb)
+	print ""
+
+	next
+}
+
+/^Raz/ && (block_current() == "Sysreg" || block_current() == "SysregFields") {
+	expect_fields(2)
+	parse_bitdef(reg, field, $2)
+
+	next
+}
+
+/^SignedEnum/ && (block_current() == "Sysreg" || block_current() == "SysregFields") {
+	block_push("Enum")
+
+	expect_fields(3)
+	field = $3
+	parse_bitdef(reg, field, $2)
+
+	define_field(reg, field, msb, lsb)
+	define_field_sign(reg, field, "true")
+
+	next
+}
+
+/^UnsignedEnum/ && (block_current() == "Sysreg" || block_current() == "SysregFields") {
+	block_push("Enum")
+
+	expect_fields(3)
+	field = $3
+	parse_bitdef(reg, field, $2)
+
+	define_field(reg, field, msb, lsb)
+	define_field_sign(reg, field, "false")
+
+	next
+}
+
+/^Enum/ && (block_current() == "Sysreg" || block_current() == "SysregFields") {
+	block_push("Enum")
+
+	expect_fields(3)
+	field = $3
+	parse_bitdef(reg, field, $2)
+
+	define_field(reg, field, msb, lsb)
+
+	next
+}
+
+/^EndEnum/ && block_current() == "Enum" {
+
+	field = null
+	msb = null
+	lsb = null
+	print ""
+
+	block_pop()
+	next
+}
+
+/0b[01]+/ && block_current() == "Enum" {
+	expect_fields(2)
+	val = $1
+	name = $2
+
+	define(reg "_" field "_" name, "UL(" val ")")
+	next
+}
+
+# Any lines not handled by previous rules are unexpected
+{
+	fatal("unhandled statement")
+}
diff --git a/tools/arch/arm64/tools/sysreg b/tools/arch/arm64/tools/sysreg
new file mode 100644
index 000000000000..65866bf819c3
--- /dev/null
+++ b/tools/arch/arm64/tools/sysreg
@@ -0,0 +1,2497 @@
+# SPDX-License-Identifier: GPL-2.0-only
+#
+# System register metadata
+
+# Each System register is described by a Sysreg block:
+
+# Sysreg 	<name>	<op0> 	<op1>	<crn>	<crm>	<op2>
+# <field>
+# ...
+# EndSysreg
+
+# Within a Sysreg block, each field can be described as one of:
+
+# Res0	<msb>[:<lsb>]
+
+# Res1	<msb>[:<lsb>]
+
+# Unkn	<msb>[:<lsb>]
+
+# Field	<msb>[:<lsb>]	<name>
+
+# Enum	<msb>[:<lsb>]	<name>
+#	<enumval>	<enumname>
+#	...
+# EndEnum
+
+# Alternatively if multiple registers share the same layout then
+# a SysregFields block can be used to describe the shared layout
+
+# SysregFields	<fieldsname>
+# <field>
+# ...
+# EndSysregFields
+
+# and referenced from within the Sysreg:
+
+# Sysreg 	<name>	<op0> 	<op1>	<crn>	<crm>	<op2>
+# Fields	<fieldsname>
+# EndSysreg
+
+# For ID registers we adopt a few conventions for translating the
+# language in the ARM into defines:
+#
+# NI  - Not implemented
+# IMP - Implemented
+#
+# In general it is recommended that new enumeration items be named for the
+# feature that introduces them (eg, FEAT_LS64_ACCDATA introduces enumeration
+# item ACCDATA) though it may be more taseful to do something else.
+
+Sysreg	OSDTRRX_EL1	2	0	0	0	2
+Res0	63:32
+Field	31:0	DTRRX
+EndSysreg
+
+Sysreg	MDCCINT_EL1	2	0	0	2	0
+Res0	63:31
+Field	30	RX
+Field	29	TX
+Res0	28:0
+EndSysreg
+
+Sysreg	MDSCR_EL1	2	0	0	2	2
+Res0	63:36
+Field	35	EHBWE
+Field	34	EnSPM
+Field	33	TTA
+Field	32	EMBWE
+Field	31	TFO
+Field	30	RXfull
+Field	29	TXfull
+Res0	28
+Field	27	RXO
+Field	26	TXU
+Res0	25:24
+Field	23:22	INTdis
+Field	21	TDA
+Res0	20
+Field	19	SC2
+Res0	18:16
+Field	15	MDE
+Field	14	HDE
+Field	13	KDE
+Field	12	TDCC
+Res0	11:7
+Field	6	ERR
+Res0	5:1
+Field	0	SS
+EndSysreg
+
+Sysreg	OSDTRTX_EL1	2	0	0	3	2
+Res0	63:32
+Field	31:0	DTRTX
+EndSysreg
+
+Sysreg	OSECCR_EL1	2	0	0	6	2
+Res0	63:32
+Field	31:0	EDECCR
+EndSysreg
+
+Sysreg	OSLAR_EL1	2	0	1	0	4
+Res0	63:1
+Field	0	OSLK
+EndSysreg
+
+Sysreg ID_PFR0_EL1	3	0	0	1	0
+Res0	63:32
+UnsignedEnum	31:28	RAS
+	0b0000	NI
+	0b0001	RAS
+	0b0010	RASv1p1
+EndEnum
+UnsignedEnum	27:24	DIT
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	23:20	AMU
+	0b0000	NI
+	0b0001	AMUv1
+	0b0010	AMUv1p1
+EndEnum
+UnsignedEnum	19:16	CSV2
+	0b0000	UNDISCLOSED
+	0b0001	IMP
+	0b0010	CSV2p1
+EndEnum
+UnsignedEnum	15:12	State3
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+Enum	11:8	State2
+	0b0000	NI
+	0b0001	NO_CV
+	0b0010	CV
+EndEnum
+UnsignedEnum	7:4	State1
+	0b0000	NI
+	0b0001	THUMB
+	0b0010	THUMB2
+EndEnum
+UnsignedEnum	3:0	State0
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+EndSysreg
+
+Sysreg ID_PFR1_EL1	3	0	0	1	1
+Res0	63:32
+UnsignedEnum	31:28	GIC
+	0b0000	NI
+	0b0001	GICv3
+	0b0010	GICv4p1
+EndEnum
+UnsignedEnum	27:24	Virt_frac
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+Enum	23:20	Sec_frac
+	0b0000	NI
+	0b0001	WALK_DISABLE
+	0b0010	SECURE_MEMORY
+EndEnum
+UnsignedEnum	19:16	GenTimer
+	0b0000	NI
+	0b0001	IMP
+	0b0010	ECV
+EndEnum
+UnsignedEnum	15:12	Virtualization
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	11:8	MProgMod
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+Enum	7:4	Security
+	0b0000	NI
+	0b0001	EL3
+	0b0001	NSACR_RFR
+EndEnum
+UnsignedEnum	3:0	ProgMod
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+EndSysreg
+
+Sysreg ID_DFR0_EL1	3	0	0	1	2
+Res0	63:32
+UnsignedEnum	31:28	TraceFilt
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	27:24	PerfMon
+	0b0000	NI
+	0b0001	PMUv1
+	0b0010	PMUv2
+	0b0011	PMUv3
+	0b0100	PMUv3p1
+	0b0101	PMUv3p4
+	0b0110	PMUv3p5
+	0b0111	PMUv3p7
+	0b1000	PMUv3p8
+	0b1111	IMPDEF
+EndEnum
+Enum	23:20	MProfDbg
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+Enum	19:16	MMapTrc
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+Enum	15:12	CopTrc
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+Enum	11:8	MMapDbg
+	0b0000	NI
+	0b0100	Armv7
+	0b0101	Armv7p1
+EndEnum
+Field	7:4	CopSDbg
+Enum	3:0	CopDbg
+	0b0000	NI
+	0b0010	Armv6
+	0b0011	Armv6p1
+	0b0100	Armv7
+	0b0101	Armv7p1
+	0b0110	Armv8
+	0b0111	VHE
+	0b1000	Debugv8p2
+	0b1001	Debugv8p4
+	0b1010	Debugv8p8
+EndEnum
+EndSysreg
+
+Sysreg ID_AFR0_EL1	3	0	0	1	3
+Res0	63:16
+Field	15:12	IMPDEF3
+Field	11:8	IMPDEF2
+Field	7:4	IMPDEF1
+Field	3:0	IMPDEF0
+EndSysreg
+
+Sysreg ID_MMFR0_EL1	3	0	0	1	4
+Res0	63:32
+Enum	31:28	InnerShr
+	0b0000	NC
+	0b0001	HW
+	0b1111	IGNORED
+EndEnum
+UnsignedEnum	27:24	FCSE
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+Enum	23:20	AuxReg
+	0b0000	NI
+	0b0001	ACTLR
+	0b0010	AIFSR
+EndEnum
+Enum	19:16	TCM
+	0b0000	NI
+	0b0001	IMPDEF
+	0b0010	TCM
+	0b0011	TCM_DMA
+EndEnum
+Enum	15:12	ShareLvl
+	0b0000	ONE
+	0b0001	TWO
+EndEnum
+Enum	11:8	OuterShr
+	0b0000	NC
+	0b0001	HW
+	0b1111	IGNORED
+EndEnum
+Enum	7:4	PMSA
+	0b0000	NI
+	0b0001	IMPDEF
+	0b0010	PMSAv6
+	0b0011	PMSAv7
+EndEnum
+Enum	3:0	VMSA
+	0b0000	NI
+	0b0001	IMPDEF
+	0b0010	VMSAv6
+	0b0011	VMSAv7
+	0b0100	VMSAv7_PXN
+	0b0101	VMSAv7_LONG
+EndEnum
+EndSysreg
+
+Sysreg ID_MMFR1_EL1	3	0	0	1	5
+Res0	63:32
+Enum	31:28	BPred
+	0b0000	NI
+	0b0001	BP_SW_MANGED
+	0b0010	BP_ASID_AWARE
+	0b0011	BP_NOSNOOP
+	0b0100	BP_INVISIBLE
+EndEnum
+Enum	27:24	L1TstCln
+	0b0000	NI
+	0b0001	NOINVALIDATE
+	0b0010	INVALIDATE
+EndEnum
+Enum	23:20	L1Uni
+	0b0000	NI
+	0b0001	INVALIDATE
+	0b0010	CLEAN_AND_INVALIDATE
+EndEnum
+Enum	19:16	L1Hvd
+	0b0000	NI
+	0b0001	INVALIDATE_ISIDE_ONLY
+	0b0010	INVALIDATE
+	0b0011	CLEAN_AND_INVALIDATE
+EndEnum
+Enum	15:12	L1UniSW
+	0b0000	NI
+	0b0001	CLEAN
+	0b0010	CLEAN_AND_INVALIDATE
+	0b0011	INVALIDATE
+EndEnum
+Enum	11:8	L1HvdSW
+	0b0000	NI
+	0b0001	CLEAN_AND_INVALIDATE
+	0b0010	INVALIDATE_DSIDE_ONLY
+	0b0011	INVALIDATE
+EndEnum
+Enum	7:4	L1UniVA
+	0b0000	NI
+	0b0001	CLEAN_AND_INVALIDATE
+	0b0010	INVALIDATE_BP
+EndEnum
+Enum	3:0	L1HvdVA
+	0b0000	NI
+	0b0001	CLEAN_AND_INVALIDATE
+	0b0010	INVALIDATE_BP
+EndEnum
+EndSysreg
+
+Sysreg ID_MMFR2_EL1	3	0	0	1	6
+Res0	63:32
+Enum	31:28	HWAccFlg
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+Enum	27:24	WFIStall
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+Enum	23:20	MemBarr
+	0b0000	NI
+	0b0001	DSB_ONLY
+	0b0010	IMP
+EndEnum
+Enum	19:16	UniTLB
+	0b0000	NI
+	0b0001	BY_VA
+	0b0010	BY_MATCH_ASID
+	0b0011	BY_ALL_ASID
+	0b0100	OTHER_TLBS
+	0b0101	BROADCAST
+	0b0110	BY_IPA
+EndEnum
+Enum	15:12	HvdTLB
+	0b0000	NI
+EndEnum
+Enum	11:8	L1HvdRng
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+Enum	7:4	L1HvdBG
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+Enum	3:0	L1HvdFG
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+EndSysreg
+
+Sysreg ID_MMFR3_EL1	3	0	0	1	7
+Res0	63:32
+Enum	31:28	Supersec
+	0b0000	IMP
+	0b1111	NI
+EndEnum
+Enum	27:24	CMemSz
+	0b0000	4GB
+	0b0001	64GB
+	0b0010	1TB
+EndEnum
+Enum	23:20	CohWalk
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+Enum	19:16	PAN
+	0b0000	NI
+	0b0001	PAN
+	0b0010	PAN2
+EndEnum
+Enum	15:12	MaintBcst
+	0b0000	NI
+	0b0001	NO_TLB
+	0b0010	ALL
+EndEnum
+Enum	11:8	BPMaint
+	0b0000	NI
+	0b0001	ALL
+	0b0010	BY_VA
+EndEnum
+Enum	7:4	CMaintSW
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+Enum	3:0	CMaintVA
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+EndSysreg
+
+Sysreg ID_ISAR0_EL1	3	0	0	2	0
+Res0	63:28
+Enum	27:24	Divide
+	0b0000	NI
+	0b0001	xDIV_T32
+	0b0010	xDIV_A32
+EndEnum
+UnsignedEnum	23:20	Debug
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+Enum	19:16	Coproc
+	0b0000	NI
+	0b0001	MRC
+	0b0010	MRC2
+	0b0011	MRRC
+	0b0100	MRRC2
+EndEnum
+UnsignedEnum	15:12	CmpBranch
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	11:8	BitField
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	7:4	BitCount
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	3:0	Swap
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+EndSysreg
+
+Sysreg ID_ISAR1_EL1	3	0	0	2	1
+Res0	63:32
+Enum	31:28	Jazelle
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+Enum	27:24	Interwork
+	0b0000	NI
+	0b0001	BX
+	0b0010	BLX
+	0b0011	A32_BX
+EndEnum
+Enum	23:20	Immediate
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+Enum	19:16	IfThen
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+Enum	15:12	Extend
+	0b0000	NI
+	0b0001	SXTB
+	0b0010	SXTB16
+EndEnum
+Enum	11:8	Except_AR
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+Enum	7:4	Except
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+Enum	3:0	Endian
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+EndSysreg
+
+Sysreg ID_ISAR2_EL1	3	0	0	2	2
+Res0	63:32
+Enum	31:28	Reversal
+	0b0000	NI
+	0b0001	REV
+	0b0010	RBIT
+EndEnum
+Enum	27:24	PSR_AR
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+Enum	23:20	MultU
+	0b0000	NI
+	0b0001	UMULL
+	0b0010	UMAAL
+EndEnum
+Enum	19:16	MultS
+	0b0000	NI
+	0b0001	SMULL
+	0b0010	SMLABB
+	0b0011	SMLAD
+EndEnum
+Enum	15:12	Mult
+	0b0000	NI
+	0b0001	MLA
+	0b0010	MLS
+EndEnum
+Enum	11:8	MultiAccessInt
+	0b0000	NI
+	0b0001	RESTARTABLE
+	0b0010	CONTINUABLE
+EndEnum
+Enum	7:4	MemHint
+	0b0000	NI
+	0b0001	PLD
+	0b0010	PLD2
+	0b0011	PLI
+	0b0100	PLDW
+EndEnum
+Enum	3:0	LoadStore
+	0b0000	NI
+	0b0001	DOUBLE
+	0b0010	ACQUIRE
+EndEnum
+EndSysreg
+
+Sysreg ID_ISAR3_EL1	3	0	0	2	3
+Res0	63:32
+Enum	31:28	T32EE
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+Enum	27:24	TrueNOP
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+Enum	23:20	T32Copy
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+Enum	19:16	TabBranch
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+Enum	15:12	SynchPrim
+	0b0000	NI
+	0b0001	EXCLUSIVE
+	0b0010	DOUBLE
+EndEnum
+Enum	11:8	SVC
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+Enum	7:4	SIMD
+	0b0000	NI
+	0b0001	SSAT
+	0b0011	PKHBT
+EndEnum
+Enum	3:0	Saturate
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+EndSysreg
+
+Sysreg ID_ISAR4_EL1	3	0	0	2	4
+Res0	63:32
+Enum	31:28	SWP_frac
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+Enum	27:24	PSR_M
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+Enum	23:20	SynchPrim_frac
+	0b0000	NI
+	0b0011	IMP
+EndEnum
+Enum	19:16	Barrier
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+Enum	15:12	SMC
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+Enum	11:8	Writeback
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+Enum	7:4	WithShifts
+	0b0000	NI
+	0b0001	LSL3
+	0b0011	LS
+	0b0100	REG
+EndEnum
+Enum	3:0	Unpriv
+	0b0000	NI
+	0b0001	REG_BYTE
+	0b0010	SIGNED_HALFWORD
+EndEnum
+EndSysreg
+
+Sysreg ID_ISAR5_EL1	3	0	0	2	5
+Res0	63:32
+UnsignedEnum	31:28	VCMA
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	27:24	RDM
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+Res0	23:20
+UnsignedEnum	19:16	CRC32
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	15:12	SHA2
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	11:8	SHA1
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	7:4	AES
+	0b0000	NI
+	0b0001	IMP
+	0b0010  VMULL
+EndEnum
+UnsignedEnum	3:0	SEVL
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+EndSysreg
+
+Sysreg ID_ISAR6_EL1	3	0	0	2	7
+Res0	63:28
+UnsignedEnum	27:24	I8MM
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	23:20	BF16
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	19:16	SPECRES
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	15:12	SB
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	11:8	FHM
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	7:4	DP
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	3:0	JSCVT
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+EndSysreg
+
+Sysreg ID_MMFR4_EL1	3	0	0	2	6
+Res0	63:32
+UnsignedEnum	31:28	EVT
+	0b0000	NI
+	0b0001	NO_TLBIS
+	0b0010	TLBIS
+EndEnum
+UnsignedEnum	27:24	CCIDX
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	23:20	LSM
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	19:16	HPDS
+	0b0000	NI
+	0b0001	AA32HPD
+	0b0010	HPDS2
+EndEnum
+UnsignedEnum	15:12	CnP
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	11:8	XNX
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	7:4	AC2
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	3:0	SpecSEI
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+EndSysreg
+
+Sysreg MVFR0_EL1	3	0	0	3	0
+Res0	63:32
+UnsignedEnum	31:28	FPRound
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	27:24	FPShVec
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	23:20	FPSqrt
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	19:16	FPDivide
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	15:12	FPTrap
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	11:8	FPDP
+	0b0000	NI
+	0b0001	VFPv2
+	0b0010	VFPv3
+EndEnum
+UnsignedEnum	7:4	FPSP
+	0b0000	NI
+	0b0001	VFPv2
+	0b0010	VFPv3
+EndEnum
+Enum	3:0	SIMDReg
+	0b0000	NI
+	0b0001	IMP_16x64
+	0b0010	IMP_32x64
+EndEnum
+EndSysreg
+
+Sysreg MVFR1_EL1	3	0	0	3	1
+Res0	63:32
+UnsignedEnum	31:28	SIMDFMAC
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	27:24	FPHP
+	0b0000	NI
+	0b0001	FPHP
+	0b0010	FPHP_CONV
+	0b0011	FP16
+EndEnum
+UnsignedEnum	23:20	SIMDHP
+	0b0000	NI
+	0b0001	SIMDHP
+	0b0010	SIMDHP_FLOAT
+EndEnum
+UnsignedEnum	19:16	SIMDSP
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	15:12	SIMDInt
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	11:8	SIMDLS
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	7:4	FPDNaN
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	3:0	FPFtZ
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+EndSysreg
+
+Sysreg MVFR2_EL1	3	0	0	3	2
+Res0	63:8
+Enum	7:4	FPMisc
+	0b0000	NI
+	0b0001	FP
+	0b0010	FP_DIRECTED_ROUNDING
+	0b0011	FP_ROUNDING
+	0b0100	FP_MAX_MIN
+EndEnum
+Enum	3:0	SIMDMisc
+	0b0000	NI
+	0b0001	SIMD_DIRECTED_ROUNDING
+	0b0010	SIMD_ROUNDING
+	0b0011	SIMD_MAX_MIN
+EndEnum
+EndSysreg
+
+Sysreg ID_PFR2_EL1	3	0	0	3	4
+Res0	63:12
+UnsignedEnum	11:8	RAS_frac
+	0b0000	NI
+	0b0001	RASv1p1
+EndEnum
+UnsignedEnum	7:4	SSBS
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	3:0	CSV3
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+EndSysreg
+
+Sysreg ID_DFR1_EL1	3	0	0	3	5
+Res0	63:8
+UnsignedEnum	7:4	HPMN0
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+Enum	3:0	MTPMU
+	0b0000	IMPDEF
+	0b0001	IMP
+	0b1111	NI
+EndEnum
+EndSysreg
+
+Sysreg ID_MMFR5_EL1	3	0	0	3	6
+Res0	63:8
+UnsignedEnum	7:4	nTLBPA
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	3:0	ETS
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+EndSysreg
+
+Sysreg	ID_AA64PFR0_EL1	3	0	0	4	0
+UnsignedEnum	63:60	CSV3
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	59:56	CSV2
+	0b0000	NI
+	0b0001	IMP
+	0b0010	CSV2_2
+	0b0011	CSV2_3
+EndEnum
+UnsignedEnum	55:52	RME
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	51:48	DIT
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	47:44	AMU
+	0b0000	NI
+	0b0001	IMP
+	0b0010	V1P1
+EndEnum
+UnsignedEnum	43:40	MPAM
+	0b0000	0
+	0b0001	1
+EndEnum
+UnsignedEnum	39:36	SEL2
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	35:32	SVE
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	31:28	RAS
+	0b0000	NI
+	0b0001	IMP
+	0b0010	V1P1
+EndEnum
+UnsignedEnum	27:24	GIC
+	0b0000	NI
+	0b0001	IMP
+	0b0010	V4P1
+EndEnum
+SignedEnum	23:20	AdvSIMD
+	0b0000	IMP
+	0b0001	FP16
+	0b1111	NI
+EndEnum
+SignedEnum	19:16	FP
+	0b0000	IMP
+	0b0001	FP16
+	0b1111	NI
+EndEnum
+UnsignedEnum	15:12	EL3
+	0b0000	NI
+	0b0001	IMP
+	0b0010	AARCH32
+EndEnum
+UnsignedEnum	11:8	EL2
+	0b0000	NI
+	0b0001	IMP
+	0b0010	AARCH32
+EndEnum
+UnsignedEnum	7:4	EL1
+	0b0001	IMP
+	0b0010	AARCH32
+EndEnum
+UnsignedEnum	3:0	EL0
+	0b0001	IMP
+	0b0010	AARCH32
+EndEnum
+EndSysreg
+
+Sysreg	ID_AA64PFR1_EL1	3	0	0	4	1
+UnsignedEnum	63:60	PFAR
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	59:56	DF2
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	55:52	MTEX
+	0b0000	MTE
+	0b0001	MTE4
+EndEnum
+UnsignedEnum	51:48	THE
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	47:44	GCS
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+Enum	43:40	MTE_frac
+	0b0000	ASYNC
+	0b1111	NI
+EndEnum
+UnsignedEnum	39:36	NMI
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	35:32	CSV2_frac
+	0b0000	NI
+	0b0001	CSV2_1p1
+	0b0010	CSV2_1p2
+EndEnum
+UnsignedEnum	31:28	RNDR_trap
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	27:24	SME
+	0b0000	NI
+	0b0001	IMP
+	0b0010	SME2
+EndEnum
+Res0	23:20
+UnsignedEnum	19:16	MPAM_frac
+	0b0000	MINOR_0
+	0b0001	MINOR_1
+EndEnum
+UnsignedEnum	15:12	RAS_frac
+	0b0000	NI
+	0b0001	RASv1p1
+EndEnum
+UnsignedEnum	11:8	MTE
+	0b0000	NI
+	0b0001	IMP
+	0b0010	MTE2
+	0b0011	MTE3
+EndEnum
+UnsignedEnum	7:4	SSBS
+	0b0000	NI
+	0b0001	IMP
+	0b0010	SSBS2
+EndEnum
+UnsignedEnum	3:0	BT
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+EndSysreg
+
+Sysreg	ID_AA64ZFR0_EL1	3	0	0	4	4
+Res0	63:60
+UnsignedEnum	59:56	F64MM
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	55:52	F32MM
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+Res0	51:48
+UnsignedEnum	47:44	I8MM
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	43:40	SM4
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+Res0	39:36
+UnsignedEnum	35:32	SHA3
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+Res0	31:24
+UnsignedEnum	23:20	BF16
+	0b0000	NI
+	0b0001	IMP
+	0b0010	EBF16
+EndEnum
+UnsignedEnum	19:16	BitPerm
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+Res0	15:8
+UnsignedEnum	7:4	AES
+	0b0000	NI
+	0b0001	IMP
+	0b0010	PMULL128
+EndEnum
+UnsignedEnum	3:0	SVEver
+	0b0000	IMP
+	0b0001	SVE2
+	0b0010	SVE2p1
+EndEnum
+EndSysreg
+
+Sysreg	ID_AA64SMFR0_EL1	3	0	0	4	5
+UnsignedEnum	63	FA64
+	0b0	NI
+	0b1	IMP
+EndEnum
+Res0	62:60
+UnsignedEnum	59:56	SMEver
+	0b0000	SME
+	0b0001	SME2
+	0b0010	SME2p1
+	0b0000	IMP
+EndEnum
+UnsignedEnum	55:52	I16I64
+	0b0000	NI
+	0b1111	IMP
+EndEnum
+Res0	51:49
+UnsignedEnum	48	F64F64
+	0b0	NI
+	0b1	IMP
+EndEnum
+UnsignedEnum	47:44	I16I32
+	0b0000	NI
+	0b0101	IMP
+EndEnum
+UnsignedEnum	43	B16B16
+	0b0	NI
+	0b1	IMP
+EndEnum
+UnsignedEnum	42	F16F16
+	0b0	NI
+	0b1	IMP
+EndEnum
+Res0	41:40
+UnsignedEnum	39:36	I8I32
+	0b0000	NI
+	0b1111	IMP
+EndEnum
+UnsignedEnum	35	F16F32
+	0b0	NI
+	0b1	IMP
+EndEnum
+UnsignedEnum	34	B16F32
+	0b0	NI
+	0b1	IMP
+EndEnum
+UnsignedEnum	33	BI32I32
+	0b0	NI
+	0b1	IMP
+EndEnum
+UnsignedEnum	32	F32F32
+	0b0	NI
+	0b1	IMP
+EndEnum
+Res0	31:0
+EndSysreg
+
+Sysreg	ID_AA64DFR0_EL1	3	0	0	5	0
+Enum	63:60	HPMN0
+	0b0000	UNPREDICTABLE
+	0b0001	DEF
+EndEnum
+Res0	59:56
+UnsignedEnum	55:52	BRBE
+	0b0000	NI
+	0b0001	IMP
+	0b0010	BRBE_V1P1
+EndEnum
+Enum	51:48	MTPMU
+	0b0000	NI_IMPDEF
+	0b0001	IMP
+	0b1111	NI
+EndEnum
+UnsignedEnum	47:44	TraceBuffer
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	43:40	TraceFilt
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	39:36	DoubleLock
+	0b0000	IMP
+	0b1111	NI
+EndEnum
+UnsignedEnum	35:32	PMSVer
+	0b0000	NI
+	0b0001	IMP
+	0b0010	V1P1
+	0b0011	V1P2
+	0b0100	V1P3
+EndEnum
+Field	31:28	CTX_CMPs
+Res0	27:24
+Field	23:20	WRPs
+Res0	19:16
+Field	15:12	BRPs
+UnsignedEnum	11:8	PMUVer
+	0b0000	NI
+	0b0001	IMP
+	0b0100	V3P1
+	0b0101	V3P4
+	0b0110	V3P5
+	0b0111	V3P7
+	0b1000	V3P8
+	0b1111	IMP_DEF
+EndEnum
+UnsignedEnum	7:4	TraceVer
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	3:0	DebugVer
+	0b0110	IMP
+	0b0111	VHE
+	0b1000	V8P2
+	0b1001	V8P4
+	0b1010	V8P8
+EndEnum
+EndSysreg
+
+Sysreg	ID_AA64DFR1_EL1	3	0	0	5	1
+Res0	63:0
+EndSysreg
+
+Sysreg	ID_AA64AFR0_EL1	3	0	0	5	4
+Res0	63:32
+Field	31:28	IMPDEF7
+Field	27:24	IMPDEF6
+Field	23:20	IMPDEF5
+Field	19:16	IMPDEF4
+Field	15:12	IMPDEF3
+Field	11:8	IMPDEF2
+Field	7:4	IMPDEF1
+Field	3:0	IMPDEF0
+EndSysreg
+
+Sysreg	ID_AA64AFR1_EL1	3	0	0	5	5
+Res0	63:0
+EndSysreg
+
+Sysreg	ID_AA64ISAR0_EL1	3	0	0	6	0
+UnsignedEnum	63:60	RNDR
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	59:56	TLB
+	0b0000	NI
+	0b0001	OS
+	0b0010	RANGE
+EndEnum
+UnsignedEnum	55:52	TS
+	0b0000	NI
+	0b0001	FLAGM
+	0b0010	FLAGM2
+EndEnum
+UnsignedEnum	51:48	FHM
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	47:44	DP
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	43:40	SM4
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	39:36	SM3
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	35:32	SHA3
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	31:28	RDM
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	27:24	TME
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	23:20	ATOMIC
+	0b0000	NI
+	0b0010	IMP
+EndEnum
+UnsignedEnum	19:16	CRC32
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	15:12	SHA2
+	0b0000	NI
+	0b0001	SHA256
+	0b0010	SHA512
+EndEnum
+UnsignedEnum	11:8	SHA1
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	7:4	AES
+	0b0000	NI
+	0b0001	AES
+	0b0010	PMULL
+EndEnum
+Res0	3:0
+EndSysreg
+
+Sysreg	ID_AA64ISAR1_EL1	3	0	0	6	1
+UnsignedEnum	63:60	LS64
+	0b0000	NI
+	0b0001	LS64
+	0b0010	LS64_V
+	0b0011	LS64_ACCDATA
+EndEnum
+UnsignedEnum	59:56	XS
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	55:52	I8MM
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	51:48	DGH
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	47:44	BF16
+	0b0000	NI
+	0b0001	IMP
+	0b0010	EBF16
+EndEnum
+UnsignedEnum	43:40	SPECRES
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	39:36	SB
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	35:32	FRINTTS
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	31:28	GPI
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	27:24	GPA
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	23:20	LRCPC
+	0b0000	NI
+	0b0001	IMP
+	0b0010	LRCPC2
+EndEnum
+UnsignedEnum	19:16	FCMA
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	15:12	JSCVT
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	11:8	API
+	0b0000	NI
+	0b0001	PAuth
+	0b0010	EPAC
+	0b0011	PAuth2
+	0b0100	FPAC
+	0b0101	FPACCOMBINE
+EndEnum
+UnsignedEnum	7:4	APA
+	0b0000	NI
+	0b0001	PAuth
+	0b0010	EPAC
+	0b0011	PAuth2
+	0b0100	FPAC
+	0b0101	FPACCOMBINE
+EndEnum
+UnsignedEnum	3:0	DPB
+	0b0000	NI
+	0b0001	IMP
+	0b0010	DPB2
+EndEnum
+EndSysreg
+
+Sysreg	ID_AA64ISAR2_EL1	3	0	0	6	2
+Res0	63:56
+UnsignedEnum	55:52	CSSC
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	51:48	RPRFM
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+Res0	47:28
+UnsignedEnum	27:24	PAC_frac
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	23:20	BC
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	19:16	MOPS
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	15:12	APA3
+	0b0000	NI
+	0b0001	PAuth
+	0b0010	EPAC
+	0b0011	PAuth2
+	0b0100	FPAC
+	0b0101	FPACCOMBINE
+EndEnum
+UnsignedEnum	11:8	GPA3
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	7:4	RPRES
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	3:0	WFxT
+	0b0000	NI
+	0b0010	IMP
+EndEnum
+EndSysreg
+
+Sysreg	ID_AA64MMFR0_EL1	3	0	0	7	0
+UnsignedEnum	63:60	ECV
+	0b0000	NI
+	0b0001	IMP
+	0b0010	CNTPOFF
+EndEnum
+UnsignedEnum	59:56	FGT
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+Res0	55:48
+UnsignedEnum	47:44	EXS
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+Enum	43:40	TGRAN4_2
+	0b0000	TGRAN4
+	0b0001	NI
+	0b0010	IMP
+	0b0011	52_BIT
+EndEnum
+Enum	39:36	TGRAN64_2
+	0b0000	TGRAN64
+	0b0001	NI
+	0b0010	IMP
+EndEnum
+Enum	35:32	TGRAN16_2
+	0b0000	TGRAN16
+	0b0001	NI
+	0b0010	IMP
+	0b0011	52_BIT
+EndEnum
+Enum	31:28	TGRAN4
+	0b0000	IMP
+	0b0001	52_BIT
+	0b1111	NI
+EndEnum
+Enum	27:24	TGRAN64
+	0b0000	IMP
+	0b1111	NI
+EndEnum
+Enum	23:20	TGRAN16
+	0b0000	NI
+	0b0001	IMP
+	0b0010	52_BIT
+EndEnum
+UnsignedEnum	19:16	BIGENDEL0
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	15:12	SNSMEM
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	11:8	BIGEND
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+Enum	7:4	ASIDBITS
+	0b0000	8
+	0b0010	16
+EndEnum
+Enum	3:0	PARANGE
+	0b0000	32
+	0b0001	36
+	0b0010	40
+	0b0011	42
+	0b0100	44
+	0b0101	48
+	0b0110	52
+EndEnum
+EndSysreg
+
+Sysreg	ID_AA64MMFR1_EL1	3	0	0	7	1
+UnsignedEnum	63:60	ECBHB
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	59:56	CMOW
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	55:52	TIDCP1
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	51:48	nTLBPA
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	47:44	AFP
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	43:40	HCX
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	39:36	ETS
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	35:32	TWED
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	31:28	XNX
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	27:24	SpecSEI
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	23:20	PAN
+	0b0000	NI
+	0b0001	IMP
+	0b0010	PAN2
+	0b0011	PAN3
+EndEnum
+UnsignedEnum	19:16	LO
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	15:12	HPDS
+	0b0000	NI
+	0b0001	IMP
+	0b0010	HPDS2
+EndEnum
+UnsignedEnum	11:8	VH
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+Enum	7:4	VMIDBits
+	0b0000	8
+	0b0010	16
+EndEnum
+UnsignedEnum	3:0	HAFDBS
+	0b0000	NI
+	0b0001	AF
+	0b0010	DBM
+EndEnum
+EndSysreg
+
+Sysreg	ID_AA64MMFR2_EL1	3	0	0	7	2
+UnsignedEnum	63:60	E0PD
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	59:56	EVT
+	0b0000	NI
+	0b0001	IMP
+	0b0010	TTLBxS
+EndEnum
+UnsignedEnum	55:52	BBM
+	0b0000	0
+	0b0001	1
+	0b0010	2
+EndEnum
+UnsignedEnum	51:48	TTL
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+Res0	47:44
+UnsignedEnum	43:40	FWB
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+Enum	39:36	IDS
+	0b0000	0x0
+	0b0001	0x18
+EndEnum
+UnsignedEnum	35:32	AT
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+Enum	31:28	ST
+	0b0000	39
+	0b0001	48_47
+EndEnum
+UnsignedEnum	27:24	NV
+	0b0000	NI
+	0b0001	IMP
+	0b0010	NV2
+EndEnum
+Enum	23:20	CCIDX
+	0b0000	32
+	0b0001	64
+EndEnum
+Enum	19:16	VARange
+	0b0000	48
+	0b0001	52
+EndEnum
+UnsignedEnum	15:12	IESB
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	11:8	LSM
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	7:4	UAO
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	3:0	CnP
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+EndSysreg
+
+Sysreg	ID_AA64MMFR3_EL1	3	0	0	7	3
+UnsignedEnum	63:60	Spec_FPACC
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	59:56	ADERR
+	0b0000	NI
+	0b0001	DEV_ASYNC
+	0b0010	FEAT_ADERR
+	0b0011	FEAT_ADERR_IND
+EndEnum
+UnsignedEnum	55:52	SDERR
+	0b0000	NI
+	0b0001	DEV_SYNC
+	0b0010	FEAT_ADERR
+	0b0011	FEAT_ADERR_IND
+EndEnum
+Res0	51:48
+UnsignedEnum	47:44	ANERR
+	0b0000	NI
+	0b0001	ASYNC
+	0b0010	FEAT_ANERR
+	0b0011	FEAT_ANERR_IND
+EndEnum
+UnsignedEnum	43:40	SNERR
+	0b0000	NI
+	0b0001	SYNC
+	0b0010	FEAT_ANERR
+	0b0011	FEAT_ANERR_IND
+EndEnum
+UnsignedEnum	39:36	D128_2
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	35:32	D128
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	31:28	MEC
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	27:24	AIE
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	23:20	S2POE
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	19:16	S1POE
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	15:12	S2PIE
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	11:8	S1PIE
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	7:4	SCTLRX
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	3:0	TCRX
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+EndSysreg
+
+Sysreg	SCTLR_EL1	3	0	1	0	0
+Field	63	TIDCP
+Field	62	SPINTMASK
+Field	61	NMI
+Field	60	EnTP2
+Res0	59:58
+Field	57	EPAN
+Field	56	EnALS
+Field	55	EnAS0
+Field	54	EnASR
+Field	53	TME
+Field	52	TME0
+Field	51	TMT
+Field	50	TMT0
+Field	49:46	TWEDEL
+Field	45	TWEDEn
+Field	44	DSSBS
+Field	43	ATA
+Field	42	ATA0
+Enum	41:40	TCF
+	0b00	NONE
+	0b01	SYNC
+	0b10	ASYNC
+	0b11	ASYMM
+EndEnum
+Enum	39:38	TCF0
+	0b00	NONE
+	0b01	SYNC
+	0b10	ASYNC
+	0b11	ASYMM
+EndEnum
+Field	37	ITFSB
+Field	36	BT1
+Field	35	BT0
+Res0	34
+Field	33	MSCEn
+Field	32	CMOW
+Field	31	EnIA
+Field	30	EnIB
+Field	29	LSMAOE
+Field	28	nTLSMD
+Field	27	EnDA
+Field	26	UCI
+Field	25	EE
+Field	24	E0E
+Field	23	SPAN
+Field	22	EIS
+Field	21	IESB
+Field	20	TSCXT
+Field	19	WXN
+Field	18	nTWE
+Res0	17
+Field	16	nTWI
+Field	15	UCT
+Field	14	DZE
+Field	13	EnDB
+Field	12	I
+Field	11	EOS
+Field	10	EnRCTX
+Field	9	UMA
+Field	8	SED
+Field	7	ITD
+Field	6	nAA
+Field	5	CP15BEN
+Field	4	SA0
+Field	3	SA
+Field	2	C
+Field	1	A
+Field	0	M
+EndSysreg
+
+SysregFields	CPACR_ELx
+Res0	63:29
+Field	28	TTA
+Res0	27:26
+Field	25:24	SMEN
+Res0	23:22
+Field	21:20	FPEN
+Res0	19:18
+Field	17:16	ZEN
+Res0	15:0
+EndSysregFields
+
+Sysreg	CPACR_EL1	3	0	1	0	2
+Fields	CPACR_ELx
+EndSysreg
+
+Sysreg	SMPRI_EL1	3	0	1	2	4
+Res0	63:4
+Field	3:0	PRIORITY
+EndSysreg
+
+SysregFields	ZCR_ELx
+Res0	63:9
+Raz	8:4
+Field	3:0	LEN
+EndSysregFields
+
+Sysreg ZCR_EL1	3	0	1	2	0
+Fields ZCR_ELx
+EndSysreg
+
+SysregFields	SMCR_ELx
+Res0	63:32
+Field	31	FA64
+Field	30	EZT0
+Res0	29:9
+Raz	8:4
+Field	3:0	LEN
+EndSysregFields
+
+Sysreg	SMCR_EL1	3	0	1	2	6
+Fields	SMCR_ELx
+EndSysreg
+
+Sysreg	ALLINT	3	0	4	3	0
+Res0	63:14
+Field	13	ALLINT
+Res0	12:0
+EndSysreg
+
+Sysreg	FAR_EL1	3	0	6	0	0
+Field	63:0	ADDR
+EndSysreg
+
+Sysreg	PMSCR_EL1	3	0	9	9	0
+Res0	63:8
+Field	7:6	PCT
+Field	5	TS
+Field	4	PA
+Field	3	CX
+Res0	2
+Field	1	E1SPE
+Field	0	E0SPE
+EndSysreg
+
+Sysreg	PMSNEVFR_EL1	3	0	9	9	1
+Field	63:0	E
+EndSysreg
+
+Sysreg	PMSICR_EL1	3	0	9	9	2
+Field	63:56	ECOUNT
+Res0	55:32
+Field	31:0	COUNT
+EndSysreg
+
+Sysreg	PMSIRR_EL1	3	0	9	9	3
+Res0	63:32
+Field	31:8	INTERVAL
+Res0	7:1
+Field	0	RND
+EndSysreg
+
+Sysreg	PMSFCR_EL1	3	0	9	9	4
+Res0	63:19
+Field	18	ST
+Field	17	LD
+Field	16	B
+Res0	15:4
+Field	3	FnE
+Field	2	FL
+Field	1	FT
+Field	0	FE
+EndSysreg
+
+Sysreg	PMSEVFR_EL1	3	0	9	9	5
+Field	63:0	E
+EndSysreg
+
+Sysreg	PMSLATFR_EL1	3	0	9	9	6
+Res0	63:16
+Field	15:0	MINLAT
+EndSysreg
+
+Sysreg	PMSIDR_EL1	3	0	9	9	7
+Res0	63:25
+Field	24	PBT
+Field	23:20	FORMAT
+Enum	19:16	COUNTSIZE
+	0b0010	12_BIT_SAT
+	0b0011	16_BIT_SAT
+EndEnum
+Field	15:12	MAXSIZE
+Enum	11:8	INTERVAL
+	0b0000	256
+	0b0010	512
+	0b0011	768
+	0b0100	1024
+	0b0101	1536
+	0b0110	2048
+	0b0111	3072
+	0b1000	4096
+EndEnum
+Res0	7
+Field	6	FnE
+Field	5	ERND
+Field	4	LDS
+Field	3	ARCHINST
+Field	2	FL
+Field	1	FT
+Field	0	FE
+EndSysreg
+
+Sysreg	PMBLIMITR_EL1	3	0	9	10	0
+Field	63:12	LIMIT
+Res0	11:6
+Field	5	PMFZ
+Res0	4:3
+Enum	2:1	FM
+	0b00	FILL
+	0b10	DISCARD
+EndEnum
+Field	0	E
+EndSysreg
+
+Sysreg	PMBPTR_EL1	3	0	9	10	1
+Field	63:0	PTR
+EndSysreg
+
+Sysreg	PMBSR_EL1	3	0	9	10	3
+Res0	63:32
+Enum	31:26	EC
+	0b000000	BUF
+	0b100100	FAULT_S1
+	0b100101	FAULT_S2
+	0b011110	FAULT_GPC
+	0b011111	IMP_DEF
+EndEnum
+Res0	25:20
+Field	19	DL
+Field	18	EA
+Field	17	S
+Field	16	COLL
+Field	15:0	MSS
+EndSysreg
+
+Sysreg	PMBIDR_EL1	3	0	9	10	7
+Res0	63:12
+Enum	11:8	EA
+	0b0000	NotDescribed
+	0b0001	Ignored
+	0b0010	SError
+EndEnum
+Res0	7:6
+Field	5	F
+Field	4	P
+Field	3:0	ALIGN
+EndSysreg
+
+SysregFields	CONTEXTIDR_ELx
+Res0	63:32
+Field	31:0	PROCID
+EndSysregFields
+
+Sysreg	CONTEXTIDR_EL1	3	0	13	0	1
+Fields	CONTEXTIDR_ELx
+EndSysreg
+
+Sysreg	TPIDR_EL1	3	0	13	0	4
+Field	63:0	ThreadID
+EndSysreg
+
+Sysreg	SCXTNUM_EL1	3	0	13	0	7
+Field	63:0	SoftwareContextNumber
+EndSysreg
+
+# The bit layout for CCSIDR_EL1 depends on whether FEAT_CCIDX is implemented.
+# The following is for case when FEAT_CCIDX is not implemented.
+Sysreg	CCSIDR_EL1	3	1	0	0	0
+Res0	63:32
+Unkn	31:28
+Field	27:13	NumSets
+Field	12:3	Associativity
+Field	2:0	LineSize
+EndSysreg
+
+Sysreg	CLIDR_EL1	3	1	0	0	1
+Res0	63:47
+Field	46:33	Ttypen
+Field	32:30	ICB
+Field	29:27	LoUU
+Field	26:24	LoC
+Field	23:21	LoUIS
+Field	20:18	Ctype7
+Field	17:15	Ctype6
+Field	14:12	Ctype5
+Field	11:9	Ctype4
+Field	8:6	Ctype3
+Field	5:3	Ctype2
+Field	2:0	Ctype1
+EndSysreg
+
+Sysreg	CCSIDR2_EL1	3	1	0	0	2
+Res0	63:24
+Field	23:0	NumSets
+EndSysreg
+
+Sysreg	GMID_EL1	3	1	0	0	4
+Res0	63:4
+Field	3:0	BS
+EndSysreg
+
+Sysreg	SMIDR_EL1	3	1	0	0	6
+Res0	63:32
+Field	31:24	IMPLEMENTER
+Field	23:16	REVISION
+Field	15	SMPS
+Res0	14:12
+Field	11:0	AFFINITY
+EndSysreg
+
+Sysreg	CSSELR_EL1	3	2	0	0	0
+Res0	63:5
+Field	4	TnD
+Field	3:1	Level
+Field	0	InD
+EndSysreg
+
+Sysreg	CTR_EL0	3	3	0	0	1
+Res0	63:38
+Field	37:32	TminLine
+Res1	31
+Res0	30
+Field	29	DIC
+Field	28	IDC
+Field	27:24	CWG
+Field	23:20	ERG
+Field	19:16	DminLine
+Enum	15:14	L1Ip
+	0b00	VPIPT
+	# This is named as AIVIVT in the ARM but documented as reserved
+	0b01	RESERVED
+	0b10	VIPT
+	0b11	PIPT
+EndEnum
+Res0	13:4
+Field	3:0	IminLine
+EndSysreg
+
+Sysreg	DCZID_EL0	3	3	0	0	7
+Res0	63:5
+Field	4	DZP
+Field	3:0	BS
+EndSysreg
+
+Sysreg	SVCR	3	3	4	2	2
+Res0	63:2
+Field	1	ZA
+Field	0	SM
+EndSysreg
+
+SysregFields	HFGxTR_EL2
+Field	63	nAMAIR2_EL1
+Field	62	nMAIR2_EL1
+Field	61	nS2POR_EL1
+Field	60	nPOR_EL1
+Field	59	nPOR_EL0
+Field	58	nPIR_EL1
+Field	57	nPIRE0_EL1
+Field	56	nRCWMASK_EL1
+Field	55	nTPIDR2_EL0
+Field	54	nSMPRI_EL1
+Field	53	nGCS_EL1
+Field	52	nGCS_EL0
+Res0	51
+Field	50	nACCDATA_EL1
+Field	49	ERXADDR_EL1
+Field	48	ERXPFGCDN_EL1
+Field	47	ERXPFGCTL_EL1
+Field	46	ERXPFGF_EL1
+Field	45	ERXMISCn_EL1
+Field	44	ERXSTATUS_EL1
+Field	43	ERXCTLR_EL1
+Field	42	ERXFR_EL1
+Field	41	ERRSELR_EL1
+Field	40	ERRIDR_EL1
+Field	39	ICC_IGRPENn_EL1
+Field	38	VBAR_EL1
+Field	37	TTBR1_EL1
+Field	36	TTBR0_EL1
+Field	35	TPIDR_EL0
+Field	34	TPIDRRO_EL0
+Field	33	TPIDR_EL1
+Field	32	TCR_EL1
+Field	31	SCXTNUM_EL0
+Field	30	SCXTNUM_EL1
+Field	29	SCTLR_EL1
+Field	28	REVIDR_EL1
+Field	27	PAR_EL1
+Field	26	MPIDR_EL1
+Field	25	MIDR_EL1
+Field	24	MAIR_EL1
+Field	23	LORSA_EL1
+Field	22	LORN_EL1
+Field	21	LORID_EL1
+Field	20	LOREA_EL1
+Field	19	LORC_EL1
+Field	18	ISR_EL1
+Field	17	FAR_EL1
+Field	16	ESR_EL1
+Field	15	DCZID_EL0
+Field	14	CTR_EL0
+Field	13	CSSELR_EL1
+Field	12	CPACR_EL1
+Field	11	CONTEXTIDR_EL1
+Field	10	CLIDR_EL1
+Field	9	CCSIDR_EL1
+Field	8	APIBKey
+Field	7	APIAKey
+Field	6	APGAKey
+Field	5	APDBKey
+Field	4	APDAKey
+Field	3	AMAIR_EL1
+Field	2	AIDR_EL1
+Field	1	AFSR1_EL1
+Field	0	AFSR0_EL1
+EndSysregFields
+
+Sysreg HFGRTR_EL2	3	4	1	1	4
+Fields	HFGxTR_EL2
+EndSysreg
+
+Sysreg HFGWTR_EL2	3	4	1	1	5
+Fields	HFGxTR_EL2
+EndSysreg
+
+Sysreg HFGITR_EL2	3	4	1	1	6
+Res0	63:61
+Field	60	COSPRCTX
+Field	59	nGCSEPP
+Field	58	nGCSSTR_EL1
+Field	57	nGCSPUSHM_EL1
+Field	56	nBRBIALL
+Field	55	nBRBINJ
+Field	54	DCCVAC
+Field	53	SVC_EL1
+Field	52	SVC_EL0
+Field	51	ERET
+Field	50	CPPRCTX
+Field	49	DVPRCTX
+Field	48	CFPRCTX
+Field	47	TLBIVAALE1
+Field	46	TLBIVALE1
+Field	45	TLBIVAAE1
+Field	44	TLBIASIDE1
+Field	43	TLBIVAE1
+Field	42	TLBIVMALLE1
+Field	41	TLBIRVAALE1
+Field	40	TLBIRVALE1
+Field	39	TLBIRVAAE1
+Field	38	TLBIRVAE1
+Field	37	TLBIRVAALE1IS
+Field	36	TLBIRVALE1IS
+Field	35	TLBIRVAAE1IS
+Field	34	TLBIRVAE1IS
+Field	33	TLBIVAALE1IS
+Field	32	TLBIVALE1IS
+Field	31	TLBIVAAE1IS
+Field	30	TLBIASIDE1IS
+Field	29	TLBIVAE1IS
+Field	28	TLBIVMALLE1IS
+Field	27	TLBIRVAALE1OS
+Field	26	TLBIRVALE1OS
+Field	25	TLBIRVAAE1OS
+Field	24	TLBIRVAE1OS
+Field	23	TLBIVAALE1OS
+Field	22	TLBIVALE1OS
+Field	21	TLBIVAAE1OS
+Field	20	TLBIASIDE1OS
+Field	19	TLBIVAE1OS
+Field	18	TLBIVMALLE1OS
+Field	17	ATS1E1WP
+Field	16	ATS1E1RP
+Field	15	ATS1E0W
+Field	14	ATS1E0R
+Field	13	ATS1E1W
+Field	12	ATS1E1R
+Field	11	DCZVA
+Field	10	DCCIVAC
+Field	9	DCCVADP
+Field	8	DCCVAP
+Field	7	DCCVAU
+Field	6	DCCISW
+Field	5	DCCSW
+Field	4	DCISW
+Field	3	DCIVAC
+Field	2	ICIVAU
+Field	1	ICIALLU
+Field	0	ICIALLUIS
+EndSysreg
+
+Sysreg	ZCR_EL2	3	4	1	2	0
+Fields	ZCR_ELx
+EndSysreg
+
+Sysreg	HCRX_EL2	3	4	1	2	2
+Res0	63:23
+Field	22	GCSEn
+Field	21	EnIDCP128
+Field	20	EnSDERR
+Field	19	TMEA
+Field	18	EnSNERR
+Field	17	D128En
+Field	16	PTTWI
+Field	15	SCTLR2En
+Field	14	TCR2En
+Res0	13:12
+Field	11	MSCEn
+Field	10	MCE2
+Field	9	CMOW
+Field	8	VFNMI
+Field	7	VINMI
+Field	6	TALLINT
+Field	5	SMPME
+Field	4	FGTnXS
+Field	3	FnXS
+Field	2	EnASR
+Field	1	EnALS
+Field	0	EnAS0
+EndSysreg
+
+Sysreg	SMPRIMAP_EL2	3	4	1	2	5
+Field	63:60	P15
+Field	59:56	P14
+Field	55:52	P13
+Field	51:48	P12
+Field	47:44	P11
+Field	43:40	P10
+Field	39:36	F9
+Field	35:32	P8
+Field	31:28	P7
+Field	27:24	P6
+Field	23:20	P5
+Field	19:16	P4
+Field	15:12	P3
+Field	11:8	P2
+Field	7:4	P1
+Field	3:0	P0
+EndSysreg
+
+Sysreg	SMCR_EL2	3	4	1	2	6
+Fields	SMCR_ELx
+EndSysreg
+
+Sysreg	DACR32_EL2	3	4	3	0	0
+Res0	63:32
+Field	31:30	D15
+Field	29:28	D14
+Field	27:26	D13
+Field	25:24	D12
+Field	23:22	D11
+Field	21:20	D10
+Field	19:18	D9
+Field	17:16	D8
+Field	15:14	D7
+Field	13:12	D6
+Field	11:10	D5
+Field	9:8	D4
+Field	7:6	D3
+Field	5:4	D2
+Field	3:2	D1
+Field	1:0	D0
+EndSysreg
+
+Sysreg	FAR_EL2	3	4	6	0	0
+Field	63:0	ADDR
+EndSysreg
+
+Sysreg	PMSCR_EL2	3	4	9	9	0
+Res0	63:8
+Enum	7:6	PCT
+	0b00	VIRT
+	0b01	PHYS
+	0b11	GUEST
+EndEnum
+Field	5	TS
+Field	4	PA
+Field	3	CX
+Res0	2
+Field	1	E2SPE
+Field	0	E0HSPE
+EndSysreg
+
+Sysreg	CONTEXTIDR_EL2	3	4	13	0	1
+Fields	CONTEXTIDR_ELx
+EndSysreg
+
+Sysreg	CNTPOFF_EL2	3	4	14	0	6
+Field	63:0	PhysicalOffset
+EndSysreg
+
+Sysreg	CPACR_EL12	3	5	1	0	2
+Fields	CPACR_ELx
+EndSysreg
+
+Sysreg	ZCR_EL12	3	5	1	2	0
+Fields	ZCR_ELx
+EndSysreg
+
+Sysreg	SMCR_EL12	3	5	1	2	6
+Fields	SMCR_ELx
+EndSysreg
+
+Sysreg	FAR_EL12	3	5	6	0	0
+Field	63:0	ADDR
+EndSysreg
+
+Sysreg	CONTEXTIDR_EL12	3	5	13	0	1
+Fields	CONTEXTIDR_ELx
+EndSysreg
+
+SysregFields TTBRx_EL1
+Field	63:48	ASID
+Field	47:1	BADDR
+Field	0	CnP
+EndSysregFields
+
+Sysreg	TTBR0_EL1	3	0	2	0	0
+Fields	TTBRx_EL1
+EndSysreg
+
+Sysreg	TTBR1_EL1	3	0	2	0	1
+Fields	TTBRx_EL1
+EndSysreg
+
+SysregFields	TCR2_EL1x
+Res0	63:16
+Field	15	DisCH1
+Field	14	DisCH0
+Res0	13:12
+Field	11	HAFT
+Field	10	PTTWI
+Res0	9:6
+Field	5	D128
+Field	4	AIE
+Field	3	POE
+Field	2	E0POE
+Field	1	PIE
+Field	0	PnCH
+EndSysregFields
+
+Sysreg	TCR2_EL1	3	0	2	0	3
+Fields	TCR2_EL1x
+EndSysreg
+
+Sysreg	TCR2_EL12	3	5	2	0	3
+Fields	TCR2_EL1x
+EndSysreg
+
+Sysreg	TCR2_EL2	3	4	2	0	3
+Res0	63:16
+Field	15	DisCH1
+Field	14	DisCH0
+Field	13	AMEC1
+Field	12	AMEC0
+Field	11	HAFT
+Field	10	PTTWI
+Field	9:8	SKL1
+Field	7:6	SKL0
+Field	5	D128
+Field	4	AIE
+Field	3	POE
+Field	2	E0POE
+Field	1	PIE
+Field	0	PnCH
+EndSysreg
+
+SysregFields PIRx_ELx
+Field	63:60	Perm15
+Field	59:56	Perm14
+Field	55:52	Perm13
+Field	51:48	Perm12
+Field	47:44	Perm11
+Field	43:40	Perm10
+Field	39:36	Perm9
+Field	35:32	Perm8
+Field	31:28	Perm7
+Field	27:24	Perm6
+Field	23:20	Perm5
+Field	19:16	Perm4
+Field	15:12	Perm3
+Field	11:8	Perm2
+Field	7:4	Perm1
+Field	3:0	Perm0
+EndSysregFields
+
+Sysreg	PIRE0_EL1	3	0	10	2	2
+Fields	PIRx_ELx
+EndSysreg
+
+Sysreg	PIRE0_EL12	3	5	10	2	2
+Fields	PIRx_ELx
+EndSysreg
+
+Sysreg	PIR_EL1		3	0	10	2	3
+Fields	PIRx_ELx
+EndSysreg
+
+Sysreg	PIR_EL12	3	5	10	2	3
+Fields	PIRx_ELx
+EndSysreg
+
+Sysreg	PIR_EL2		3	4	10	2	3
+Fields	PIRx_ELx
+EndSysreg
+
+Sysreg	LORSA_EL1	3	0	10	4	0
+Res0	63:52
+Field	51:16	SA
+Res0	15:1
+Field	0	Valid
+EndSysreg
+
+Sysreg	LOREA_EL1	3	0	10	4	1
+Res0	63:52
+Field	51:48	EA_51_48
+Field	47:16	EA_47_16
+Res0	15:0
+EndSysreg
+
+Sysreg	LORN_EL1	3	0	10	4	2
+Res0	63:8
+Field	7:0	Num
+EndSysreg
+
+Sysreg	LORC_EL1	3	0	10	4	3
+Res0	63:10
+Field	9:2	DS
+Res0	1
+Field	0	EN
+EndSysreg
+
+Sysreg	LORID_EL1	3	0	10	4	7
+Res0	63:24
+Field	23:16	LD
+Res0	15:8
+Field	7:0	LR
+EndSysreg
+
+Sysreg	ISR_EL1	3	0	12	1	0
+Res0	63:11
+Field	10	IS
+Field	9	FS
+Field	8	A
+Field	7	I
+Field	6	F
+Res0	5:0
+EndSysreg
+
+Sysreg	ICC_NMIAR1_EL1	3	0	12	9	5
+Res0	63:24
+Field	23:0	INTID
+EndSysreg
+
+Sysreg	TRBLIMITR_EL1	3	0	9	11	0
+Field	63:12	LIMIT
+Res0	11:7
+Field	6	XE
+Field	5	nVM
+Enum	4:3	TM
+	0b00	STOP
+	0b01	IRQ
+	0b11	IGNR
+EndEnum
+Enum	2:1	FM
+	0b00	FILL
+	0b01	WRAP
+	0b11	CBUF
+EndEnum
+Field	0	E
+EndSysreg
+
+Sysreg	TRBPTR_EL1	3	0	9	11	1
+Field	63:0	PTR
+EndSysreg
+
+Sysreg	TRBBASER_EL1	3	0	9	11	2
+Field	63:12	BASE
+Res0	11:0
+EndSysreg
+
+Sysreg	TRBSR_EL1	3	0	9	11	3
+Res0	63:56
+Field	55:32	MSS2
+Field	31:26	EC
+Res0	25:24
+Field	23	DAT
+Field	22	IRQ
+Field	21	TRG
+Field	20	WRAP
+Res0	19
+Field	18	EA
+Field	17	S
+Res0	16
+Field	15:0	MSS
+EndSysreg
+
+Sysreg	TRBMAR_EL1	3	0	9	11	4
+Res0	63:12
+Enum	11:10	PAS
+	0b00	SECURE
+	0b01	NON_SECURE
+	0b10	ROOT
+	0b11	REALM
+EndEnum
+Enum	9:8	SH
+	0b00	NON_SHAREABLE
+	0b10	OUTER_SHAREABLE
+	0b11	INNER_SHAREABLE
+EndEnum
+Field	7:0	Attr
+EndSysreg
+
+Sysreg	TRBTRG_EL1	3	0	9	11	6
+Res0	63:32
+Field	31:0	TRG
+EndSysreg
+
+Sysreg	TRBIDR_EL1	3	0	9	11	7
+Res0	63:12
+Enum	11:8	EA
+	0b0000	NON_DESC
+	0b0001	IGNORE
+	0b0010	SERROR
+EndEnum
+Res0	7:6
+Field	5	F
+Field	4	P
+Field	3:0	Align
+EndSysreg
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index a3bb36fb3cfc..1cdefbbc728c 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -209,15 +209,16 @@ ifeq ($(ARCH),x86_64)
 LINUX_TOOL_ARCH_INCLUDE = $(top_srcdir)/tools/arch/x86/include
 else
 LINUX_TOOL_ARCH_INCLUDE = $(top_srcdir)/tools/arch/$(ARCH)/include
+ARCH_GENERATED_INCLUDE = $(top_srcdir)/tools/arch/$(ARCH)/include/generated
 endif
 CFLAGS += -Wall -Wstrict-prototypes -Wuninitialized -O2 -g -std=gnu99 \
-	-Wno-gnu-variable-sized-type-not-at-end -MD\
+	-Wno-gnu-variable-sized-type-not-at-end -MD \
 	-fno-builtin-memcmp -fno-builtin-memcpy -fno-builtin-memset \
 	-fno-builtin-strnlen \
 	-fno-stack-protector -fno-PIE -I$(LINUX_TOOL_INCLUDE) \
 	-I$(LINUX_TOOL_ARCH_INCLUDE) -I$(LINUX_HDR_PATH) -Iinclude \
 	-I$(<D) -Iinclude/$(ARCH_DIR) -I ../rseq -I.. $(EXTRA_CFLAGS) \
-	$(KHDR_INCLUDES)
+	-I$(ARCH_GENERATED_INCLUDE) $(KHDR_INCLUDES)
 ifeq ($(ARCH),s390)
 	CFLAGS += -march=z10
 endif
@@ -271,9 +272,18 @@ $(LIBKVM_S_OBJ): $(OUTPUT)/%.o: %.S
 $(LIBKVM_STRING_OBJ): $(OUTPUT)/%.o: %.c
 	$(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c -ffreestanding $< -o $@
 
+ifeq ($(ARCH),arm64)
+GEN_SYSREGS := $(ARCH_GENERATED_INCLUDE)/asm/sysreg-defs.h
+ARCH_TOOLS := $(top_srcdir)/tools/arch/$(ARCH)/tools/
+
+$(GEN_SYSREGS): $(ARCH_TOOLS)/gen-sysreg.awk $(ARCH_TOOLS)/sysreg
+	mkdir -p $(dir $@); awk -f $(ARCH_TOOLS)/gen-sysreg.awk $(ARCH_TOOLS)/sysreg > $@
+endif
+
 x := $(shell mkdir -p $(sort $(dir $(TEST_GEN_PROGS))))
 $(TEST_GEN_PROGS): $(LIBKVM_OBJS)
 $(TEST_GEN_PROGS_EXTENDED): $(LIBKVM_OBJS)
+$(TEST_GEN_OBJ): $(GEN_SYSREGS)
 
 cscope: include_paths = $(LINUX_TOOL_INCLUDE) $(LINUX_HDR_PATH) include lib ..
 cscope:
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

