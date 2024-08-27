Return-Path: <kvm+bounces-25168-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DCDF7961212
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 17:26:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0DB4E1C2293E
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 15:26:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 663C41CDFC3;
	Tue, 27 Aug 2024 15:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uvRfkZPg"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 896881CC898;
	Tue, 27 Aug 2024 15:25:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772331; cv=none; b=QzhU41CqcTRi00eSx9+wsAOVoO5qOAo0OFCwTNnQmTrHwqUkyDESFC7E6bjIfzK3aeXw0Eji3bQNqmBKMu1Xva7D24EG6bE145yWC/eRgv4FXMDppTQLzB6IrdlCBJg32lkdDlFYmpxKSivYDeCZWdATgRT2H85xTA6rzJ1V/D0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772331; c=relaxed/simple;
	bh=HoxjbOcruSzMUxx5Syb5tMrTIfQJ2HtLlIW5T1CuApc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MB6ii2mjyGMNIPUQN/fKf2H7GqMlTLp+Vskh0kgeCXR6xV87u/LQT2K4bmYL42Kuj1IQqx2eOW6vEFMOkxHov4MnGRKuMM+Wi7iSb3a+R5L98q9VdHsQothfv05g3uv5iZGU+PGnQdCBJymT1/A2fPeMaI8F3GdMtj9mCoXUvSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uvRfkZPg; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E540C4DE0D;
	Tue, 27 Aug 2024 15:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724772331;
	bh=HoxjbOcruSzMUxx5Syb5tMrTIfQJ2HtLlIW5T1CuApc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uvRfkZPgEgMXXD5xwztNmJzHf4MylV//0QpFqyNUxpJjZbUPCtiiZ0ZNrpmiPLpVb
	 BVRTmK7tNvO1d4TbaPgiJ7WhvQviFT/3dHSrEql+/0fde4plc6q8WSXHuqWdf6/7gB
	 LBwGExNdYpHYr8+hee+mHxvT02vyEopV9qHQTvdTcytLNmmHHb4XIP2ZQha5OfWDog
	 w1i1Dnft/Z3AIAN25yTQFvqkxbXcm5NHaKLQdwPl7Jhz2urliUN/x+XKw5c8jfDRiT
	 P+w8LmWkB/pCD5T3oRJie7vgaKQh2o7UY7vOLz/cTt8vVBDW7kBiACP8cX6586QTWu
	 XQuTDpu8ateqQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1siy4X-007HOs-LE;
	Tue, 27 Aug 2024 16:25:29 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexander Potapenko <glider@google.com>
Subject: [PATCH v2 11/11] KVM: arm64: Add selftest checking how the absence of GICv3 is handled
Date: Tue, 27 Aug 2024 16:25:17 +0100
Message-Id: <20240827152517.3909653-12-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240827152517.3909653-1-maz@kernel.org>
References: <20240827152517.3909653-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, glider@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Given how tortuous and fragile the whole lack-of-GICv3 story is,
add a selftest checking that we don't regress it.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/aarch64/no-vgic-v3.c        | 175 ++++++++++++++++++
 2 files changed, 176 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/aarch64/no-vgic-v3.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 48d32c5aa3eb..f66b37acc0b0 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -163,6 +163,7 @@ TEST_GEN_PROGS_aarch64 += aarch64/vgic_init
 TEST_GEN_PROGS_aarch64 += aarch64/vgic_irq
 TEST_GEN_PROGS_aarch64 += aarch64/vgic_lpi_stress
 TEST_GEN_PROGS_aarch64 += aarch64/vpmu_counter_access
+TEST_GEN_PROGS_aarch64 += aarch64/no-vgic-v3
 TEST_GEN_PROGS_aarch64 += access_tracking_perf_test
 TEST_GEN_PROGS_aarch64 += arch_timer
 TEST_GEN_PROGS_aarch64 += demand_paging_test
diff --git a/tools/testing/selftests/kvm/aarch64/no-vgic-v3.c b/tools/testing/selftests/kvm/aarch64/no-vgic-v3.c
new file mode 100644
index 000000000000..943d65fc6b0b
--- /dev/null
+++ b/tools/testing/selftests/kvm/aarch64/no-vgic-v3.c
@@ -0,0 +1,175 @@
+// SPDX-License-Identifier: GPL-2.0
+
+// Check that, on a GICv3 system, not configuring GICv3 correctly
+// results in all of the sysregs generating an UNDEF exception.
+
+#include <test_util.h>
+#include <kvm_util.h>
+#include <processor.h>
+
+static volatile bool handled;
+
+#define __check_sr_read(r)					\
+	({							\
+		uint64_t val;					\
+								\
+		handled = false;				\
+		dsb(sy);					\
+		val = read_sysreg_s(SYS_ ## r);			\
+		val;						\
+	})
+
+#define __check_sr_write(r)					\
+	do {							\
+		handled = false;				\
+		dsb(sy);					\
+		write_sysreg_s(0, SYS_ ## r);			\
+		isb();						\
+	} while(0)
+
+/* Fatal checks */
+#define check_sr_read(r)					\
+	do {							\
+		__check_sr_read(r);				\
+		__GUEST_ASSERT(handled, #r " no read trap");	\
+	} while(0)
+
+#define check_sr_write(r)					\
+	do {							\
+		__check_sr_write(r);				\
+		__GUEST_ASSERT(handled, #r " no write trap");	\
+	} while(0)
+
+#define check_sr_rw(r)				\
+	do {					\
+		check_sr_read(r);		\
+		check_sr_write(r);		\
+	} while(0)
+
+static void guest_code(void)
+{
+	uint64_t val;
+
+	/*
+	 * Check that we advertise that ID_AA64PFR0_EL1.GIC == 0, having
+	 * hidden the feature at runtime without any other userspace action.
+	 */
+	__GUEST_ASSERT(FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_GIC),
+				 read_sysreg(id_aa64pfr0_el1)) == 0,
+		       "GICv3 wrongly advertised");
+
+	/*
+	 * Access all GICv3 registers, and fail if we don't get an UNDEF.
+	 * Note that we happily access all the APxRn registers without
+	 * checking their existance, as all we want to see is a failure.
+	 */
+	check_sr_rw(ICC_PMR_EL1);
+	check_sr_read(ICC_IAR0_EL1);
+	check_sr_write(ICC_EOIR0_EL1);
+	check_sr_rw(ICC_HPPIR0_EL1);
+	check_sr_rw(ICC_BPR0_EL1);
+	check_sr_rw(ICC_AP0R0_EL1);
+	check_sr_rw(ICC_AP0R1_EL1);
+	check_sr_rw(ICC_AP0R2_EL1);
+	check_sr_rw(ICC_AP0R3_EL1);
+	check_sr_rw(ICC_AP1R0_EL1);
+	check_sr_rw(ICC_AP1R1_EL1);
+	check_sr_rw(ICC_AP1R2_EL1);
+	check_sr_rw(ICC_AP1R3_EL1);
+	check_sr_write(ICC_DIR_EL1);
+	check_sr_read(ICC_RPR_EL1);
+	check_sr_write(ICC_SGI1R_EL1);
+	check_sr_write(ICC_ASGI1R_EL1);
+	check_sr_write(ICC_SGI0R_EL1);
+	check_sr_read(ICC_IAR1_EL1);
+	check_sr_write(ICC_EOIR1_EL1);
+	check_sr_rw(ICC_HPPIR1_EL1);
+	check_sr_rw(ICC_BPR1_EL1);
+	check_sr_rw(ICC_CTLR_EL1);
+	check_sr_rw(ICC_IGRPEN0_EL1);
+	check_sr_rw(ICC_IGRPEN1_EL1);
+
+	/*
+	 * ICC_SRE_EL1 may not be trappable, as ICC_SRE_EL2.Enable can
+	 * be RAO/WI. Engage in non-fatal accesses, starting with a
+	 * write of 0 to try and disable SRE, and let's see if it
+	 * sticks.
+	 */
+	__check_sr_write(ICC_SRE_EL1);
+	if (!handled)
+		GUEST_PRINTF("ICC_SRE_EL1 write not trapping (OK)\n");
+
+	val = __check_sr_read(ICC_SRE_EL1);
+	if (!handled) {
+		__GUEST_ASSERT((val & BIT(0)),
+			       "ICC_SRE_EL1 not trapped but ICC_SRE_EL1.SRE not set\n");
+		GUEST_PRINTF("ICC_SRE_EL1 read not trapping (OK)\n");
+	}
+
+	GUEST_DONE();
+}
+
+static void guest_undef_handler(struct ex_regs *regs)
+{
+	/* Success, we've gracefully exploded! */
+	handled = true;
+	regs->pc += 4;
+}
+
+static void test_run_vcpu(struct kvm_vcpu *vcpu)
+{
+	struct ucall uc;
+
+	do {
+		vcpu_run(vcpu);
+
+		switch (get_ucall(vcpu, &uc)) {
+		case UCALL_ABORT:
+			REPORT_GUEST_ASSERT(uc);
+			break;
+		case UCALL_PRINTF:
+			printf("%s", uc.buffer);
+			break;
+		case UCALL_DONE:
+			break;
+		default:
+			TEST_FAIL("Unknown ucall %lu", uc.cmd);
+		}
+	} while (uc.cmd != UCALL_DONE);
+}
+
+static void test_guest_no_gicv3(void)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+
+	/* Create a VM without a GICv3 */
+	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
+
+	vm_init_descriptor_tables(vm);
+	vcpu_init_descriptor_tables(vcpu);
+
+	vm_install_sync_handler(vm, VECTOR_SYNC_CURRENT,
+				ESR_EC_UNKNOWN, guest_undef_handler);
+
+	test_run_vcpu(vcpu);
+
+	kvm_vm_free(vm);
+}
+
+int main(int argc, char *argv[])
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+	uint64_t pfr0;
+
+	vm = vm_create_with_one_vcpu(&vcpu, NULL);
+	vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64PFR0_EL1), &pfr0);
+	__TEST_REQUIRE(FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_GIC), pfr0),
+		       "GICv3 not supported.");
+	kvm_vm_free(vm);
+
+	test_guest_no_gicv3();
+
+	return 0;
+}
-- 
2.39.2


