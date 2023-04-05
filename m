Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D3056D825B
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 17:46:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239060AbjDEPqZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 11:46:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239018AbjDEPqJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 11:46:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 093B93C3E
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 08:46:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8DFB463F09
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 15:46:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8C63C433D2;
        Wed,  5 Apr 2023 15:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680709563;
        bh=WyYOg+yzc7oduQO4QBxWSh44tO70vdaCrw+QhsKcuO4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oO2JNqv4ZAD9y7WGpH5lPYOivB/LD6P668UDAX59Rlh9SvY6NWPdjWbtq6IcgL3MF
         SrvXw0uJm5cMGROae5+DU/YVwmaJPRjjwEGmrK3tX6yd1l9AAAvfA9Rjz4AOwCEtrk
         hGauyL4TC8MTXMbmBH7eEZ8rZpSNDVaSKsgmxO0SVoGsmsVDEDxmJuvbiWvr5iNpHf
         y8Y8QHMHTxSypDsUNal2ovURwtGDRTM1CpoLpopeKG576hZ0mxcGYpJIzgMlidfUjk
         yRplnQSu5z7H93fVviFEuZoDl4v0sLNOS+wT83L+W9Y1gipPhr7SiqcPnPv+u0Ti07
         NBhh3SRZbHLfw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pk5Fk-0062PV-Un;
        Wed, 05 Apr 2023 16:40:54 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Chase Conklin <chase.conklin@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Darren Hart <darren@os.amperecomputing.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Miguel Luis <miguel.luis@oracle.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v9 39/50] KVM: arm64: nv: Map VNCR-capable registers to a separate page
Date:   Wed,  5 Apr 2023 16:39:57 +0100
Message-Id: <20230405154008.3552854-40-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230405154008.3552854-1-maz@kernel.org>
References: <20230405154008.3552854-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com, darren@os.amperecomputing.com, jintack@cs.columbia.edu, rmk+kernel@armlinux.org.uk, miguel.luis@oracle.com, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

With ARMv8.4-NV, registers that can be directly accessed in memory
by the guest have to live at architected offsets in a special page.

Let's annotate the sysreg enum to reflect the offset at which they
are in this page, whith a little twist:

If running on HW that doesn't have the ARMv8.4-NV feature, or even
a VM that doesn't use NV, we store all the system registers in the
usual sys_regs array. The only difference with the pre-8.4
situation is that VNCR-capable registers are at a "similar" offset
as in the VNCR page (we can compute the actual offset at compile
time), and that the sys_regs array is both bigger and sparse.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h | 104 ++++++++++++++++++++----------
 arch/arm64/tools/cpucaps          |   1 +
 2 files changed, 70 insertions(+), 35 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 03268d444801..eb095a9eecba 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -26,6 +26,7 @@
 #include <asm/fpsimd.h>
 #include <asm/kvm.h>
 #include <asm/kvm_asm.h>
+#include <asm/vncr_mapping.h>
 
 #define __KVM_HAVE_ARCH_INTC_INITIALIZED
 
@@ -302,32 +303,33 @@ struct kvm_vcpu_fault_info {
 	u64 disr_el1;		/* Deferred [SError] Status Register */
 };
 
+/*
+ * VNCR() just places the VNCR_capable registers in the enum after
+ * __VNCR_START__, and the value (after correction) to be an 8-byte offset
+ * from the VNCR base. As we don't require the enum to be otherwise ordered,
+ * we need the terrible hack below to ensure that we correctly size the
+ * sys_regs array, no matter what.
+ *
+ * The __MAX__ macro has been lifted from Sean Eron Anderson's wonderful
+ * treasure trove of bit hacks:
+ * https://graphics.stanford.edu/~seander/bithacks.html#IntegerMinOrMax
+ */
+#define __MAX__(x,y)	((x) ^ (((x) ^ (y)) & -((x) < (y))))
+#define VNCR(r)						\
+	__before_##r,					\
+	r = __VNCR_START__ + ((VNCR_ ## r) / 8),	\
+	__after_##r = __MAX__(__before_##r - 1, r)
+
 enum vcpu_sysreg {
 	__INVALID_SYSREG__,   /* 0 is reserved as an invalid value */
 	MPIDR_EL1,	/* MultiProcessor Affinity Register */
 	CLIDR_EL1,	/* Cache Level ID Register */
 	CSSELR_EL1,	/* Cache Size Selection Register */
-	SCTLR_EL1,	/* System Control Register */
-	ACTLR_EL1,	/* Auxiliary Control Register */
-	CPACR_EL1,	/* Coprocessor Access Control */
-	ZCR_EL1,	/* SVE Control */
-	TTBR0_EL1,	/* Translation Table Base Register 0 */
-	TTBR1_EL1,	/* Translation Table Base Register 1 */
-	TCR_EL1,	/* Translation Control Register */
-	ESR_EL1,	/* Exception Syndrome Register */
-	AFSR0_EL1,	/* Auxiliary Fault Status Register 0 */
-	AFSR1_EL1,	/* Auxiliary Fault Status Register 1 */
-	FAR_EL1,	/* Fault Address Register */
-	MAIR_EL1,	/* Memory Attribute Indirection Register */
-	VBAR_EL1,	/* Vector Base Address Register */
-	CONTEXTIDR_EL1,	/* Context ID Register */
 	TPIDR_EL0,	/* Thread ID, User R/W */
 	TPIDRRO_EL0,	/* Thread ID, User R/O */
 	TPIDR_EL1,	/* Thread ID, Privileged */
-	AMAIR_EL1,	/* Aux Memory Attribute Indirection Register */
 	CNTKCTL_EL1,	/* Timer Control Register (EL1) */
 	PAR_EL1,	/* Physical Address Register */
-	MDSCR_EL1,	/* Monitor Debug System Control Register */
 	MDCCINT_EL1,	/* Monitor Debug Comms Channel Interrupt Enable Reg */
 	OSLSR_EL1,	/* OS Lock Status Register */
 	DISR_EL1,	/* Deferred Interrupt Status Register */
@@ -358,20 +360,9 @@ enum vcpu_sysreg {
 	APGAKEYLO_EL1,
 	APGAKEYHI_EL1,
 
-	ELR_EL1,
-	SP_EL1,
-	SPSR_EL1,
-
-	CNTVOFF_EL2,
-	CNTV_CVAL_EL0,
-	CNTV_CTL_EL0,
-	CNTP_CVAL_EL0,
-	CNTP_CTL_EL0,
-
 	/* Memory Tagging Extension registers */
 	RGSR_EL1,	/* Random Allocation Tag Seed Register */
 	GCR_EL1,	/* Tag Control Register */
-	TFSR_EL1,	/* Tag Fault Status Register (EL1) */
 	TFSRE0_EL1,	/* Tag Fault Status Register (EL0) */
 
 	/* 32bit specific registers. */
@@ -381,20 +372,14 @@ enum vcpu_sysreg {
 	DBGVCR32_EL2,	/* Debug Vector Catch Register */
 
 	/* EL2 registers */
-	VPIDR_EL2,	/* Virtualization Processor ID Register */
-	VMPIDR_EL2,	/* Virtualization Multiprocessor ID Register */
 	SCTLR_EL2,	/* System Control Register (EL2) */
 	ACTLR_EL2,	/* Auxiliary Control Register (EL2) */
-	HCR_EL2,	/* Hypervisor Configuration Register */
 	MDCR_EL2,	/* Monitor Debug Configuration Register (EL2) */
 	CPTR_EL2,	/* Architectural Feature Trap Register (EL2) */
-	HSTR_EL2,	/* Hypervisor System Trap Register */
 	HACR_EL2,	/* Hypervisor Auxiliary Control Register */
 	TTBR0_EL2,	/* Translation Table Base Register 0 (EL2) */
 	TTBR1_EL2,	/* Translation Table Base Register 1 (EL2) */
 	TCR_EL2,	/* Translation Control Register (EL2) */
-	VTTBR_EL2,	/* Virtualization Translation Table Base Register */
-	VTCR_EL2,	/* Virtualization Translation Control Register */
 	SPSR_EL2,	/* EL2 saved program status register */
 	ELR_EL2,	/* EL2 exception link register */
 	AFSR0_EL2,	/* Auxiliary Fault Status Register 0 (EL2) */
@@ -407,7 +392,6 @@ enum vcpu_sysreg {
 	VBAR_EL2,	/* Vector Base Address Register (EL2) */
 	RVBAR_EL2,	/* Reset Vector Base Address Register */
 	CONTEXTIDR_EL2,	/* Context ID Register (EL2) */
-	TPIDR_EL2,	/* EL2 Software Thread ID Register */
 	CNTHCTL_EL2,	/* Counter-timer Hypervisor Control register */
 	SP_EL2,		/* EL2 Stack Pointer */
 	CNTHP_CTL_EL2,
@@ -415,6 +399,42 @@ enum vcpu_sysreg {
 	CNTHV_CTL_EL2,
 	CNTHV_CVAL_EL2,
 
+	__VNCR_START__,	/* Any VNCR-capable reg goes after this point */
+
+	VNCR(SCTLR_EL1),/* System Control Register */
+	VNCR(ACTLR_EL1),/* Auxiliary Control Register */
+	VNCR(CPACR_EL1),/* Coprocessor Access Control */
+	VNCR(ZCR_EL1),	/* SVE Control */
+	VNCR(TTBR0_EL1),/* Translation Table Base Register 0 */
+	VNCR(TTBR1_EL1),/* Translation Table Base Register 1 */
+	VNCR(TCR_EL1),	/* Translation Control Register */
+	VNCR(ESR_EL1),	/* Exception Syndrome Register */
+	VNCR(AFSR0_EL1),/* Auxiliary Fault Status Register 0 */
+	VNCR(AFSR1_EL1),/* Auxiliary Fault Status Register 1 */
+	VNCR(FAR_EL1),	/* Fault Address Register */
+	VNCR(MAIR_EL1),	/* Memory Attribute Indirection Register */
+	VNCR(VBAR_EL1),	/* Vector Base Address Register */
+	VNCR(CONTEXTIDR_EL1),	/* Context ID Register */
+	VNCR(AMAIR_EL1),/* Aux Memory Attribute Indirection Register */
+	VNCR(MDSCR_EL1),/* Monitor Debug System Control Register */
+	VNCR(ELR_EL1),
+	VNCR(SP_EL1),
+	VNCR(SPSR_EL1),
+	VNCR(TFSR_EL1),	/* Tag Fault Status Register (EL1) */
+	VNCR(VPIDR_EL2),/* Virtualization Processor ID Register */
+	VNCR(VMPIDR_EL2),/* Virtualization Multiprocessor ID Register */
+	VNCR(HCR_EL2),	/* Hypervisor Configuration Register */
+	VNCR(HSTR_EL2),	/* Hypervisor System Trap Register */
+	VNCR(VTTBR_EL2),/* Virtualization Translation Table Base Register */
+	VNCR(VTCR_EL2),	/* Virtualization Translation Control Register */
+	VNCR(TPIDR_EL2),/* EL2 Software Thread ID Register */
+
+	VNCR(CNTVOFF_EL2),
+	VNCR(CNTV_CVAL_EL0),
+	VNCR(CNTV_CTL_EL0),
+	VNCR(CNTP_CVAL_EL0),
+	VNCR(CNTP_CTL_EL0),
+
 	NR_SYS_REGS	/* Nothing after this line! */
 };
 
@@ -431,6 +451,9 @@ struct kvm_cpu_context {
 	u64 sys_regs[NR_SYS_REGS];
 
 	struct kvm_vcpu *__hyp_running_vcpu;
+
+	/* This pointer has to be 4kB aligned. */
+	u64 *vncr_array;
 };
 
 struct kvm_host_data {
@@ -772,8 +795,19 @@ struct kvm_vcpu_arch {
  * accessed by a running VCPU.  For example, for userspace access or
  * for system registers that are never context switched, but only
  * emulated.
+ *
+ * Don't bother with VNCR-based accesses in the nVHE code, it has no
+ * business dealing with NV.
  */
-#define __ctxt_sys_reg(c,r)	(&(c)->sys_regs[(r)])
+static inline u64 *__ctxt_sys_reg(const struct kvm_cpu_context *ctxt, int r)
+{
+#if !defined (__KVM_NVHE_HYPERVISOR__)
+	if (unlikely(cpus_have_final_cap(ARM64_HAS_ENHANCED_NESTED_VIRT) &&
+		     r >= __VNCR_START__ && ctxt->vncr_array))
+		return &ctxt->vncr_array[r - __VNCR_START__];
+#endif
+	return (u64 *)&ctxt->sys_regs[r];
+}
 
 #define ctxt_sys_reg(c,r)	(*__ctxt_sys_reg(c,r))
 
diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
index 40ba95472594..fc29a6400f02 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -24,6 +24,7 @@ HAS_DIT
 HAS_E0PD
 HAS_ECV
 HAS_ECV_CNTPOFF
+HAS_ENHANCED_NESTED_VIRT
 HAS_EPAN
 HAS_GENERIC_AUTH
 HAS_GENERIC_AUTH_ARCH_QARMA3
-- 
2.34.1

