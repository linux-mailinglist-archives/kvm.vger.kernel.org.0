Return-Path: <kvm+bounces-24600-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 10FF295839C
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 12:07:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 927E61F246EB
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 10:07:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 217C518CBE6;
	Tue, 20 Aug 2024 10:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eVeIhAN2"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AE9018E058;
	Tue, 20 Aug 2024 10:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724148381; cv=none; b=AkJzPbBjcC+0tdzhO050CXA81YHsisozz+QIBMjArnzqIlLBkIOsZleLLyqt/OUouGSUA17sfu/zdVvlIxSD7omyhlnmjyKZNCtbedJcK2qLo+jWeiFij5HL5+1UGCpiMQbTFqEfKE8mniOk2+9uuevwuJGT8CTznYjSwVBJgFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724148381; c=relaxed/simple;
	bh=BUHkf+c3mudeJIV5N/nobjDdgJHVFjtxRU6CCxX5VhY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=eVU4sUZ0OkDPkOdsnA0BU6jKvOlSRmuhrPhEV6o4CY2FrlezmQd/RRcwWess8X9IJYMWWLYaE9ZBOlb8yHGT1PJohGDMeLVgL74cFIJkIWw2xqJAtmSA3vQu+RGZTANr2IqNkk9ZARv0NTXRR4FAF11NPylYQcta7zBTt/2vQE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eVeIhAN2; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24F52C4AF0F;
	Tue, 20 Aug 2024 10:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724148381;
	bh=BUHkf+c3mudeJIV5N/nobjDdgJHVFjtxRU6CCxX5VhY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eVeIhAN2amU4feMz/+WDAsOsMzhSoF1NgeIi3/ukHHnZiBSweOj981PwkDVd7Knzk
	 HZGkAyoGI71vX5LbLsouOaj9xQWLbgsKVa4ou8JCYlHoal7HJ39clLCRO66DSY7+fM
	 1B2y1NYAtWHipi1gQiHAzuXozhBTWlto00C6/VNIRbnJEF/MmQBnFJiUSxjBuTLDq/
	 2pQj+tjMs1yMDOx0f0KLcL6vAOZF0e2KBcMa8wBxTu9UNagFmtf9QTzCyysS7cIt1X
	 VOmOZFyk4kHzJFLJsC5U16uixjfJgslLFAhcmTLMaPzeHOJOPj3AUEqCtlw2mt255S
	 ycXjbN2Us/Mew==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sgLkp-005Dk2-4K;
	Tue, 20 Aug 2024 11:06:19 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexander Potapenko <glider@google.com>
Subject: [PATCH 12/12] KVM: arm64: Add selftest checking how the absence of GICv3 is handled
Date: Tue, 20 Aug 2024 11:03:49 +0100
Message-Id: <20240820100349.3544850-13-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240820100349.3544850-1-maz@kernel.org>
References: <20240820100349.3544850-1-maz@kernel.org>
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
 .../selftests/kvm/aarch64/no-vgic-v3.c        | 170 ++++++++++++++++++
 2 files changed, 171 insertions(+)
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
index 000000000000..27169afc94c6
--- /dev/null
+++ b/tools/testing/selftests/kvm/aarch64/no-vgic-v3.c
@@ -0,0 +1,170 @@
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
+	do {							\
+		uint64_t val;					\
+								\
+		handled = false;				\
+		dsb(sy);					\
+		val = read_sysreg_s(SYS_ ## r);			\
+		(void)val;					\
+	} while(0)
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
+/* Non-fatal checks */
+#define check_sr_read_maybe(r)						\
+	do {								\
+		__check_sr_read(r);					\
+		if (!handled)						\
+			GUEST_PRINTF(#r " read not trapping (OK)\n");	\
+	} while(0)
+
+#define check_sr_write_maybe(r)						\
+	do {								\
+		__check_sr_write(r);					\
+		if (!handled)						\
+			GUEST_PRINTF(#r " write not trapping (OK)\n");	\
+	} while(0)
+
+static void guest_code(void)
+{
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
+	 * be RAO/WI
+	 */
+	check_sr_read_maybe(ICC_SRE_EL1);
+	check_sr_write_maybe(ICC_SRE_EL1);
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
+static void test_guest_no_gicv3(void)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+	struct ucall uc;
+
+	/* Create a VM without a GICv3 */
+	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
+
+	vm_init_descriptor_tables(vm);
+	vcpu_init_descriptor_tables(vcpu);
+
+	vm_install_sync_handler(vm, VECTOR_SYNC_CURRENT,
+				ESR_EC_UNKNOWN, guest_undef_handler);
+again:
+	vcpu_run(vcpu);
+
+	switch (get_ucall(vcpu, &uc)) {
+	case UCALL_ABORT:
+		REPORT_GUEST_ASSERT(uc);
+		break;
+	case UCALL_PRINTF:
+		printf("%s", uc.buffer);
+		goto again;
+	case UCALL_DONE:
+		break;
+	default:
+		TEST_FAIL("Unknown ucall %lu", uc.cmd);
+	}
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


