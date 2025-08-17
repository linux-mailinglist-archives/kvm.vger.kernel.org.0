Return-Path: <kvm+bounces-54860-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FA26B294F4
	for <lists+kvm@lfdr.de>; Sun, 17 Aug 2025 22:22:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C4E502036BC
	for <lists+kvm@lfdr.de>; Sun, 17 Aug 2025 20:22:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFB0E2FC883;
	Sun, 17 Aug 2025 20:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bh66LOfN"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEF0C288525;
	Sun, 17 Aug 2025 20:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755462126; cv=none; b=lgHmbVfOW4CoKltU2e6lZGHE1OZrkupC+mylYApdoHaTGe/1NQinVY/rdmHWVXW4xDmv+XbQV1XB4vnQl/ew2L3J9Wj/lqoe5wM8qMX8AMYXeD32o2l2ghOsCFpHy89UAXt1aYzvn0ecr0qdPp6AG1XZqIYEQ1RFSqGxd+q5RFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755462126; c=relaxed/simple;
	bh=s7uF+PHca6+ybHFGzWtntGL5uX0+2dkCWI/sEaFvDF0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KCERErFKz3sq8/kbcI33bLuPVNR7wndhruOdyVO9r1KtpLHeF/GIOhIoX7j0Hv8SOiO8n/zd1AoAv6aV8ilWTgNsiADYZVq2lBDvNOmslnyT7byMn6t7o9IIlfRlH3zcROFU4VPn+n1WotFmiqWjx5E0uHivkbWT1vQF6ATjX8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bh66LOfN; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43C24C116B1;
	Sun, 17 Aug 2025 20:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755462126;
	bh=s7uF+PHca6+ybHFGzWtntGL5uX0+2dkCWI/sEaFvDF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bh66LOfNJ5E9VvZYJYmkwvp/hDaelJx51+3kIgqZ1Tkn26gFYz+VcZ/1sdVyvnaAF
	 1fgan/WKuwz3iT+O0pL8D3yjZeW8cndzTEhdu+SeTWFAYlBV7gDu7UabKv4OyNDW44
	 b6iLF/990PKPMvR4296DUiUorQCMljCfSzcHXQRTGxK8nxtHG0siV7HZraUUWJ+Yol
	 SqfhWlNKkRgkcS1xH/zsy0KLjgirDol52ekMR8OgbBlI6NQ6BWgt/yeCuhFE2Ilk/1
	 HRtKJt6Rq+0Q/l0V9uelQo3IuvmQc4Sns4CWl0qB3BF6cswltyHsrl1tPJYQmL26Jx
	 yzl2LssahPEig==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1unjtE-008PX0-6u;
	Sun, 17 Aug 2025 21:22:04 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Cornelia Huck <cohuck@redhat.com>
Subject: [PATCH v3 6/6] KVM: arm64: Get rid of ARM64_FEATURE_MASK()
Date: Sun, 17 Aug 2025 21:21:58 +0100
Message-Id: <20250817202158.395078-7-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250817202158.395078-1-maz@kernel.org>
References: <20250817202158.395078-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, will@kernel.org, catalin.marinas@arm.com, cohuck@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

The ARM64_FEATURE_MASK() macro was a hack introduce whilst the
automatic generation of sysreg encoding was introduced, and was
too unreliable to be entirely trusted.

We are in a better place now, and we could really do without this
macro. Get rid of it altogether.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/sysreg.h               |  3 --
 arch/arm64/kvm/arm.c                          |  8 ++--
 arch/arm64/kvm/sys_regs.c                     | 40 +++++++++----------
 tools/arch/arm64/include/asm/sysreg.h         |  3 --
 .../selftests/kvm/arm64/aarch32_id_regs.c     |  2 +-
 .../selftests/kvm/arm64/debug-exceptions.c    | 12 +++---
 .../testing/selftests/kvm/arm64/no-vgic-v3.c  |  4 +-
 .../selftests/kvm/arm64/page_fault_test.c     |  6 +--
 .../testing/selftests/kvm/arm64/set_id_regs.c |  8 ++--
 .../selftests/kvm/arm64/vpmu_counter_access.c |  2 +-
 .../selftests/kvm/lib/arm64/processor.c       |  6 +--
 11 files changed, 44 insertions(+), 50 deletions(-)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index d5b5f2ae1afaa..6604fd6f33f45 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -1142,9 +1142,6 @@
 
 #define ARM64_FEATURE_FIELD_BITS	4
 
-/* Defined for compatibility only, do not add new users. */
-#define ARM64_FEATURE_MASK(x)	(x##_MASK)
-
 #ifdef __ASSEMBLY__
 
 	.macro	mrs_s, rt, sreg
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 888f7c7abf547..5bf101c869c9a 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2408,12 +2408,12 @@ static u64 get_hyp_id_aa64pfr0_el1(void)
 	 */
 	u64 val = read_sanitised_ftr_reg(SYS_ID_AA64PFR0_EL1);
 
-	val &= ~(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2) |
-		 ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3));
+	val &= ~(ID_AA64PFR0_EL1_CSV2 |
+		 ID_AA64PFR0_EL1_CSV3);
 
-	val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2),
+	val |= FIELD_PREP(ID_AA64PFR0_EL1_CSV2,
 			  arm64_get_spectre_v2_state() == SPECTRE_UNAFFECTED);
-	val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3),
+	val |= FIELD_PREP(ID_AA64PFR0_EL1_CSV3,
 			  arm64_get_meltdown_state() == SPECTRE_UNAFFECTED);
 
 	return val;
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index e149786f8bde0..00a485180c4eb 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1617,18 +1617,18 @@ static u64 __kvm_read_sanitised_id_reg(const struct kvm_vcpu *vcpu,
 		break;
 	case SYS_ID_AA64ISAR1_EL1:
 		if (!vcpu_has_ptrauth(vcpu))
-			val &= ~(ARM64_FEATURE_MASK(ID_AA64ISAR1_EL1_APA) |
-				 ARM64_FEATURE_MASK(ID_AA64ISAR1_EL1_API) |
-				 ARM64_FEATURE_MASK(ID_AA64ISAR1_EL1_GPA) |
-				 ARM64_FEATURE_MASK(ID_AA64ISAR1_EL1_GPI));
+			val &= ~(ID_AA64ISAR1_EL1_APA |
+				 ID_AA64ISAR1_EL1_API |
+				 ID_AA64ISAR1_EL1_GPA |
+				 ID_AA64ISAR1_EL1_GPI);
 		break;
 	case SYS_ID_AA64ISAR2_EL1:
 		if (!vcpu_has_ptrauth(vcpu))
-			val &= ~(ARM64_FEATURE_MASK(ID_AA64ISAR2_EL1_APA3) |
-				 ARM64_FEATURE_MASK(ID_AA64ISAR2_EL1_GPA3));
+			val &= ~(ID_AA64ISAR2_EL1_APA3 |
+				 ID_AA64ISAR2_EL1_GPA3);
 		if (!cpus_have_final_cap(ARM64_HAS_WFXT) ||
 		    has_broken_cntvoff())
-			val &= ~ARM64_FEATURE_MASK(ID_AA64ISAR2_EL1_WFxT);
+			val &= ~ID_AA64ISAR2_EL1_WFxT;
 		break;
 	case SYS_ID_AA64ISAR3_EL1:
 		val &= ID_AA64ISAR3_EL1_FPRCVT | ID_AA64ISAR3_EL1_FAMINMAX;
@@ -1644,7 +1644,7 @@ static u64 __kvm_read_sanitised_id_reg(const struct kvm_vcpu *vcpu,
 		       ID_AA64MMFR3_EL1_S1PIE;
 		break;
 	case SYS_ID_MMFR4_EL1:
-		val &= ~ARM64_FEATURE_MASK(ID_MMFR4_EL1_CCIDX);
+		val &= ~ID_MMFR4_EL1_CCIDX;
 		break;
 	}
 
@@ -1830,22 +1830,22 @@ static u64 sanitise_id_aa64pfr1_el1(const struct kvm_vcpu *vcpu, u64 val)
 	u64 pfr0 = read_sanitised_ftr_reg(SYS_ID_AA64PFR0_EL1);
 
 	if (!kvm_has_mte(vcpu->kvm)) {
-		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_EL1_MTE);
-		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_EL1_MTE_frac);
+		val &= ~ID_AA64PFR1_EL1_MTE;
+		val &= ~ID_AA64PFR1_EL1_MTE_frac;
 	}
 
 	if (!(cpus_have_final_cap(ARM64_HAS_RASV1P1_EXTN) &&
 	      SYS_FIELD_GET(ID_AA64PFR0_EL1, RAS, pfr0) == ID_AA64PFR0_EL1_RAS_IMP))
-		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_EL1_RAS_frac);
-
-	val &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_EL1_SME);
-	val &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_EL1_RNDR_trap);
-	val &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_EL1_NMI);
-	val &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_EL1_GCS);
-	val &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_EL1_THE);
-	val &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_EL1_MTEX);
-	val &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_EL1_PFAR);
-	val &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_EL1_MPAM_frac);
+		val &= ~ID_AA64PFR1_EL1_RAS_frac;
+
+	val &= ~ID_AA64PFR1_EL1_SME;
+	val &= ~ID_AA64PFR1_EL1_RNDR_trap;
+	val &= ~ID_AA64PFR1_EL1_NMI;
+	val &= ~ID_AA64PFR1_EL1_GCS;
+	val &= ~ID_AA64PFR1_EL1_THE;
+	val &= ~ID_AA64PFR1_EL1_MTEX;
+	val &= ~ID_AA64PFR1_EL1_PFAR;
+	val &= ~ID_AA64PFR1_EL1_MPAM_frac;
 
 	return val;
 }
diff --git a/tools/arch/arm64/include/asm/sysreg.h b/tools/arch/arm64/include/asm/sysreg.h
index 690b6ebd118f4..65f2759ea27a3 100644
--- a/tools/arch/arm64/include/asm/sysreg.h
+++ b/tools/arch/arm64/include/asm/sysreg.h
@@ -1080,9 +1080,6 @@
 
 #define ARM64_FEATURE_FIELD_BITS	4
 
-/* Defined for compatibility only, do not add new users. */
-#define ARM64_FEATURE_MASK(x)	(x##_MASK)
-
 #ifdef __ASSEMBLY__
 
 	.macro	mrs_s, rt, sreg
diff --git a/tools/testing/selftests/kvm/arm64/aarch32_id_regs.c b/tools/testing/selftests/kvm/arm64/aarch32_id_regs.c
index cef8f7323ceb8..713005b6f508e 100644
--- a/tools/testing/selftests/kvm/arm64/aarch32_id_regs.c
+++ b/tools/testing/selftests/kvm/arm64/aarch32_id_regs.c
@@ -146,7 +146,7 @@ static bool vcpu_aarch64_only(struct kvm_vcpu *vcpu)
 
 	val = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64PFR0_EL1));
 
-	el0 = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_EL0), val);
+	el0 = FIELD_GET(ID_AA64PFR0_EL1_EL0, val);
 	return el0 == ID_AA64PFR0_EL1_EL0_IMP;
 }
 
diff --git a/tools/testing/selftests/kvm/arm64/debug-exceptions.c b/tools/testing/selftests/kvm/arm64/debug-exceptions.c
index e34963956fbc9..1d431de8729c5 100644
--- a/tools/testing/selftests/kvm/arm64/debug-exceptions.c
+++ b/tools/testing/selftests/kvm/arm64/debug-exceptions.c
@@ -116,12 +116,12 @@ static void reset_debug_state(void)
 
 	/* Reset all bcr/bvr/wcr/wvr registers */
 	dfr0 = read_sysreg(id_aa64dfr0_el1);
-	brps = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_BRPs), dfr0);
+	brps = FIELD_GET(ID_AA64DFR0_EL1_BRPs, dfr0);
 	for (i = 0; i <= brps; i++) {
 		write_dbgbcr(i, 0);
 		write_dbgbvr(i, 0);
 	}
-	wrps = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_WRPs), dfr0);
+	wrps = FIELD_GET(ID_AA64DFR0_EL1_WRPs, dfr0);
 	for (i = 0; i <= wrps; i++) {
 		write_dbgwcr(i, 0);
 		write_dbgwvr(i, 0);
@@ -418,7 +418,7 @@ static void guest_code_ss(int test_cnt)
 
 static int debug_version(uint64_t id_aa64dfr0)
 {
-	return FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_DebugVer), id_aa64dfr0);
+	return FIELD_GET(ID_AA64DFR0_EL1_DebugVer, id_aa64dfr0);
 }
 
 static void test_guest_debug_exceptions(uint8_t bpn, uint8_t wpn, uint8_t ctx_bpn)
@@ -539,14 +539,14 @@ void test_guest_debug_exceptions_all(uint64_t aa64dfr0)
 	int b, w, c;
 
 	/* Number of breakpoints */
-	brp_num = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_BRPs), aa64dfr0) + 1;
+	brp_num = FIELD_GET(ID_AA64DFR0_EL1_BRPs, aa64dfr0) + 1;
 	__TEST_REQUIRE(brp_num >= 2, "At least two breakpoints are required");
 
 	/* Number of watchpoints */
-	wrp_num = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_WRPs), aa64dfr0) + 1;
+	wrp_num = FIELD_GET(ID_AA64DFR0_EL1_WRPs, aa64dfr0) + 1;
 
 	/* Number of context aware breakpoints */
-	ctx_brp_num = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_CTX_CMPs), aa64dfr0) + 1;
+	ctx_brp_num = FIELD_GET(ID_AA64DFR0_EL1_CTX_CMPs, aa64dfr0) + 1;
 
 	pr_debug("%s brp_num:%d, wrp_num:%d, ctx_brp_num:%d\n", __func__,
 		 brp_num, wrp_num, ctx_brp_num);
diff --git a/tools/testing/selftests/kvm/arm64/no-vgic-v3.c b/tools/testing/selftests/kvm/arm64/no-vgic-v3.c
index ebd70430c89de..f222538e60841 100644
--- a/tools/testing/selftests/kvm/arm64/no-vgic-v3.c
+++ b/tools/testing/selftests/kvm/arm64/no-vgic-v3.c
@@ -54,7 +54,7 @@ static void guest_code(void)
 	 * Check that we advertise that ID_AA64PFR0_EL1.GIC == 0, having
 	 * hidden the feature at runtime without any other userspace action.
 	 */
-	__GUEST_ASSERT(FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_GIC),
+	__GUEST_ASSERT(FIELD_GET(ID_AA64PFR0_EL1_GIC,
 				 read_sysreg(id_aa64pfr0_el1)) == 0,
 		       "GICv3 wrongly advertised");
 
@@ -165,7 +165,7 @@ int main(int argc, char *argv[])
 
 	vm = vm_create_with_one_vcpu(&vcpu, NULL);
 	pfr0 = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64PFR0_EL1));
-	__TEST_REQUIRE(FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_GIC), pfr0),
+	__TEST_REQUIRE(FIELD_GET(ID_AA64PFR0_EL1_GIC, pfr0),
 		       "GICv3 not supported.");
 	kvm_vm_free(vm);
 
diff --git a/tools/testing/selftests/kvm/arm64/page_fault_test.c b/tools/testing/selftests/kvm/arm64/page_fault_test.c
index dc6559dad9d86..4ccbd389d1336 100644
--- a/tools/testing/selftests/kvm/arm64/page_fault_test.c
+++ b/tools/testing/selftests/kvm/arm64/page_fault_test.c
@@ -95,14 +95,14 @@ static bool guest_check_lse(void)
 	uint64_t isar0 = read_sysreg(id_aa64isar0_el1);
 	uint64_t atomic;
 
-	atomic = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64ISAR0_EL1_ATOMIC), isar0);
+	atomic = FIELD_GET(ID_AA64ISAR0_EL1_ATOMIC, isar0);
 	return atomic >= 2;
 }
 
 static bool guest_check_dc_zva(void)
 {
 	uint64_t dczid = read_sysreg(dczid_el0);
-	uint64_t dzp = FIELD_GET(ARM64_FEATURE_MASK(DCZID_EL0_DZP), dczid);
+	uint64_t dzp = FIELD_GET(DCZID_EL0_DZP, dczid);
 
 	return dzp == 0;
 }
@@ -195,7 +195,7 @@ static bool guest_set_ha(void)
 	uint64_t hadbs, tcr;
 
 	/* Skip if HA is not supported. */
-	hadbs = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64MMFR1_EL1_HAFDBS), mmfr1);
+	hadbs = FIELD_GET(ID_AA64MMFR1_EL1_HAFDBS, mmfr1);
 	if (hadbs == 0)
 		return false;
 
diff --git a/tools/testing/selftests/kvm/arm64/set_id_regs.c b/tools/testing/selftests/kvm/arm64/set_id_regs.c
index d3bf9204409c3..36d40c267b994 100644
--- a/tools/testing/selftests/kvm/arm64/set_id_regs.c
+++ b/tools/testing/selftests/kvm/arm64/set_id_regs.c
@@ -594,8 +594,8 @@ static void test_user_set_mte_reg(struct kvm_vcpu *vcpu)
 	 */
 	val = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64PFR1_EL1));
 
-	mte = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR1_EL1_MTE), val);
-	mte_frac = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR1_EL1_MTE_frac), val);
+	mte = FIELD_GET(ID_AA64PFR1_EL1_MTE, val);
+	mte_frac = FIELD_GET(ID_AA64PFR1_EL1_MTE_frac, val);
 	if (mte != ID_AA64PFR1_EL1_MTE_MTE2 ||
 	    mte_frac != ID_AA64PFR1_EL1_MTE_frac_NI) {
 		ksft_test_result_skip("MTE_ASYNC or MTE_ASYMM are supported, nothing to test\n");
@@ -612,7 +612,7 @@ static void test_user_set_mte_reg(struct kvm_vcpu *vcpu)
 	}
 
 	val = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64PFR1_EL1));
-	mte_frac = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR1_EL1_MTE_frac), val);
+	mte_frac = FIELD_GET(ID_AA64PFR1_EL1_MTE_frac, val);
 	if (mte_frac == ID_AA64PFR1_EL1_MTE_frac_NI)
 		ksft_test_result_pass("ID_AA64PFR1_EL1.MTE_frac=0 accepted and still 0xF\n");
 	else
@@ -774,7 +774,7 @@ int main(void)
 
 	/* Check for AARCH64 only system */
 	val = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64PFR0_EL1));
-	el0 = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_EL0), val);
+	el0 = FIELD_GET(ID_AA64PFR0_EL1_EL0, val);
 	aarch64_only = (el0 == ID_AA64PFR0_EL1_EL0_IMP);
 
 	ksft_print_header();
diff --git a/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c b/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c
index f16b3b27e32ed..a0c4ab8391559 100644
--- a/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c
+++ b/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c
@@ -441,7 +441,7 @@ static void create_vpmu_vm(void *guest_code)
 
 	/* Make sure that PMUv3 support is indicated in the ID register */
 	dfr0 = vcpu_get_reg(vpmu_vm.vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64DFR0_EL1));
-	pmuver = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer), dfr0);
+	pmuver = FIELD_GET(ID_AA64DFR0_EL1_PMUVer, dfr0);
 	TEST_ASSERT(pmuver != ID_AA64DFR0_EL1_PMUVer_IMP_DEF &&
 		    pmuver >= ID_AA64DFR0_EL1_PMUVer_IMP,
 		    "Unexpected PMUVER (0x%x) on the vCPU with PMUv3", pmuver);
diff --git a/tools/testing/selftests/kvm/lib/arm64/processor.c b/tools/testing/selftests/kvm/lib/arm64/processor.c
index 9d69904cb6084..eb115123d7411 100644
--- a/tools/testing/selftests/kvm/lib/arm64/processor.c
+++ b/tools/testing/selftests/kvm/lib/arm64/processor.c
@@ -573,15 +573,15 @@ void aarch64_get_supported_page_sizes(uint32_t ipa, uint32_t *ipa4k,
 	err = ioctl(vcpu_fd, KVM_GET_ONE_REG, &reg);
 	TEST_ASSERT(err == 0, KVM_IOCTL_ERROR(KVM_GET_ONE_REG, vcpu_fd));
 
-	gran = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64MMFR0_EL1_TGRAN4), val);
+	gran = FIELD_GET(ID_AA64MMFR0_EL1_TGRAN4, val);
 	*ipa4k = max_ipa_for_page_size(ipa, gran, ID_AA64MMFR0_EL1_TGRAN4_NI,
 					ID_AA64MMFR0_EL1_TGRAN4_52_BIT);
 
-	gran = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64MMFR0_EL1_TGRAN64), val);
+	gran = FIELD_GET(ID_AA64MMFR0_EL1_TGRAN64, val);
 	*ipa64k = max_ipa_for_page_size(ipa, gran, ID_AA64MMFR0_EL1_TGRAN64_NI,
 					ID_AA64MMFR0_EL1_TGRAN64_IMP);
 
-	gran = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64MMFR0_EL1_TGRAN16), val);
+	gran = FIELD_GET(ID_AA64MMFR0_EL1_TGRAN16, val);
 	*ipa16k = max_ipa_for_page_size(ipa, gran, ID_AA64MMFR0_EL1_TGRAN16_NI,
 					ID_AA64MMFR0_EL1_TGRAN16_52_BIT);
 
-- 
2.39.2


