Return-Path: <kvm+bounces-64681-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 59946C8ACC6
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 17:02:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1CE043B901F
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 16:00:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7E0233C1AE;
	Wed, 26 Nov 2025 16:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jghNOWdw"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C370733B96F;
	Wed, 26 Nov 2025 16:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764172801; cv=none; b=tjm9PNtLdKw7qXEIjkRiAW0csm0YNKpPsstrCdAmCQbbviK8AEroZQudfIvef4aIdQfWBLFezWgD25D5dUsFHSAncLNOutvaKDcz5PDFpDQiWCxdytRXi3DhBuEq8taCtZUeTG9EhRs3Zb8SOn0y7ON9DUhAKq8mi23NmZQDzxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764172801; c=relaxed/simple;
	bh=0HAJBmXE+rJLYXs5hMQhZFeGzkrf7YieZyrcWFUBa8g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kmb7Bk7u51/mvGGXQQJIhFYytcbgXEFPiO+pjazdnDY8W9pKkwrb4NJH8ltC/ZFIIPutVyz01qySsyNkrReooaVi++edowSKX1doq08iMmdjQiMABYkokKc7YUyYs0sADcyf59UcQ5qztjH+2itDmzaiTEnL8uo7uRpsSCljXr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jghNOWdw; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E8D1C4AF09;
	Wed, 26 Nov 2025 16:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764172801;
	bh=0HAJBmXE+rJLYXs5hMQhZFeGzkrf7YieZyrcWFUBa8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jghNOWdwoJdAoDEZo7hf5KMUvnNzUpAdlgMNgUpqcoIXj4Qff16+iZEipNSNf3mzF
	 6Dw8zojl6RmpsPUfVjfqiTpkKBXTOyWAIZ+8Xr4aDGrYR5KMn5qaDepCMhq17qJOvL
	 4VijWrIdAzcj1UAfaS/UtG6qn2A6sgg25hgUUNfqZ8d+i6eAd/qUWDZMmMvCAW6UQs
	 g2mJYkwKOAsZUXgtUYeT5cBdP9naMffLbniJgleIQQNERPK7t20yYae227N0+Xs/C5
	 lOaYhOgRggEQbadVmXIFdn3Hgq1TrxP/ZGBpFwwbWCf4Lwl/QLQcBwHA+JQNnTWEb7
	 Ws6t33RlhaGkA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vOHvz-00000008WrH-1qSX;
	Wed, 26 Nov 2025 15:59:59 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Ben Horgan <ben.horgan@arm.com>
Subject: [PATCH v2 5/5] KVM: arm64: selftests: Add a test for FEAT_IDST
Date: Wed, 26 Nov 2025 15:59:51 +0000
Message-ID: <20251126155951.1146317-6-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251126155951.1146317-1-maz@kernel.org>
References: <20251126155951.1146317-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, ben.horgan@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Add a very basic test checking that FEAT_IDST actually works for
the {GMID,SMIDR,CSSIDR2}_EL1 registers.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../testing/selftests/kvm/arm64/idreg-idst.c  | 117 ++++++++++++++++++
 2 files changed, 118 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/arm64/idreg-idst.c

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index 148d427ff24be..fa44e6d9afc35 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -171,6 +171,7 @@ TEST_GEN_PROGS_arm64 += arm64/vgic_irq
 TEST_GEN_PROGS_arm64 += arm64/vgic_lpi_stress
 TEST_GEN_PROGS_arm64 += arm64/vpmu_counter_access
 TEST_GEN_PROGS_arm64 += arm64/no-vgic-v3
+TEST_GEN_PROGS_arm64 += arm64/idreg-idst
 TEST_GEN_PROGS_arm64 += arm64/kvm-uuid
 TEST_GEN_PROGS_arm64 += access_tracking_perf_test
 TEST_GEN_PROGS_arm64 += arch_timer
diff --git a/tools/testing/selftests/kvm/arm64/idreg-idst.c b/tools/testing/selftests/kvm/arm64/idreg-idst.c
new file mode 100644
index 0000000000000..9ca9f125abdb7
--- /dev/null
+++ b/tools/testing/selftests/kvm/arm64/idreg-idst.c
@@ -0,0 +1,117 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/*
+ * Access all FEAT_IDST-handled registers that depend on more than
+ * just FEAT_AA64, and fail if we don't get an a trap with an 0x18 EC.
+ */
+
+#include <test_util.h>
+#include <kvm_util.h>
+#include <processor.h>
+
+static volatile bool sys64, undef;
+
+#define __check_sr_read(r)					\
+	({							\
+		uint64_t val;					\
+								\
+		sys64 = false;					\
+		undef = false;					\
+		dsb(sy);					\
+		val = read_sysreg_s(SYS_ ## r);			\
+		val;						\
+	})
+
+/* Fatal checks */
+#define check_sr_read(r)					\
+	do {							\
+		__check_sr_read(r);				\
+		__GUEST_ASSERT(!undef, #r " unexpected UNDEF");	\
+		__GUEST_ASSERT(sys64, #r " didn't trap");	\
+	} while(0)
+
+
+static void guest_code(void)
+{
+	check_sr_read(CCSIDR2_EL1);
+	check_sr_read(SMIDR_EL1);
+	check_sr_read(GMID_EL1);
+
+	GUEST_DONE();
+}
+
+static void guest_sys64_handler(struct ex_regs *regs)
+{
+	sys64 = true;
+	undef = false;
+	regs->pc += 4;
+}
+
+static void guest_undef_handler(struct ex_regs *regs)
+{
+	sys64 = false;
+	undef = true;
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
+static void test_guest_feat_idst(void)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+
+	/* This VM has no MTE, no SME, no CCIDX */
+	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
+
+	vm_init_descriptor_tables(vm);
+	vcpu_init_descriptor_tables(vcpu);
+
+	vm_install_sync_handler(vm, VECTOR_SYNC_CURRENT,
+				ESR_ELx_EC_SYS64, guest_sys64_handler);
+	vm_install_sync_handler(vm, VECTOR_SYNC_CURRENT,
+				ESR_ELx_EC_UNKNOWN, guest_undef_handler);
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
+	uint64_t mmfr2;
+
+	test_disable_default_vgic();
+
+	vm = vm_create_with_one_vcpu(&vcpu, NULL);
+	mmfr2 = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64MMFR2_EL1));
+	__TEST_REQUIRE(FIELD_GET(ID_AA64MMFR2_EL1_IDS, mmfr2) > 0,
+		       "FEAT_IDST not supported");
+	kvm_vm_free(vm);
+
+	test_guest_feat_idst();
+
+	return 0;
+}
-- 
2.47.3


