Return-Path: <kvm+bounces-53007-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 43FAFB0C827
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 17:53:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7D19B6C30C7
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 15:52:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D78D52E0938;
	Mon, 21 Jul 2025 15:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NdejrZHv"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1ECA2E0919;
	Mon, 21 Jul 2025 15:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753113107; cv=none; b=M4tJVmMM5QV3rnebWzFKHAFIYZfYz7NzXG880VFhkW0f67uFjjWcu38CYgQK+O1zq2AjqFhz/i63FsHruEVkfhY4RHmgFXrNAkqh1vRQuKiupFH49eO+1zgay8uR/NeiLjQ3RQGZSQtXhihNy5LtVHUroNm+XR5/843kfs7on7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753113107; c=relaxed/simple;
	bh=VorkCIfYnj7vmwv7ZzNhcKzHZkJ7O3RYK53j5I6L8r8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=OrTjUuAG+uo+AIxtl005UleBwzm7/lyHqVCDC1+f87Gq+WhW1menbEvmE+oVAq8KY4guhawJtOiL3OvUKqNZyZc0nUZz71hz2TXK2n2t+y7TqIeLpuQacTjzdJ5eufY5pVcHuGbRgorlG3Zj3jlYCD0o7VZWODAH2yarVsx6KZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NdejrZHv; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6982CC4CEED;
	Mon, 21 Jul 2025 15:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753113106;
	bh=VorkCIfYnj7vmwv7ZzNhcKzHZkJ7O3RYK53j5I6L8r8=;
	h=From:To:Cc:Subject:Date:From;
	b=NdejrZHvsrvTqLWyUXBZrfvBkmifO+w7JV0xzvU559yvRrMC3HgIkI251X96cBhlX
	 G/7QvuRzgMUnqFP01vKT10CGFvKzLZXyJA09oXTC5BR7PQQFES1WJH3r85MWuPDgf9
	 C4lsKLiiPzBDFWkuLpQcd8/0Toxye0GMMEWuKfxVYYnJW5f9rH/9GV8sdAoUH7VP3v
	 NxZyPA/ix3TmkT8ZjHONCXlldXtrSXENlzdqce9zWTMVqOkRv2bptD0ECE42Pcy8JC
	 IdsfSrvwl/DnLAfzb/p4S3bZoXp8ONu62hDDRZnsJejcOjLRa50DIorxvi0qV2KZ30
	 lSmgIv9zJ5c1A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1udsno-0004Du-F5;
	Mon, 21 Jul 2025 16:51:44 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	jackabt@amazon.com
Subject: [PATCH] KVM: arm64: selftest: Add standalone test checking for KVM's own UUID
Date: Mon, 21 Jul 2025 16:51:36 +0100
Message-Id: <20250721155136.892255-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, will@kernel.org, mark.rutland@arm.com, jackabt@amazon.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Tinkering with UUIDs is a perilious task, and the KVM UUID gets
broken at times. In order to spot this early enough, add a selftest
that will shout if the expected value isn't found.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20250721130558.50823-1-jackabt.amazon@gmail.com
---
 tools/testing/selftests/kvm/Makefile.kvm     |  1 +
 tools/testing/selftests/kvm/arm64/kvm-uuid.c | 67 ++++++++++++++++++++
 2 files changed, 68 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/arm64/kvm-uuid.c

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index ce817a975e50a..e1eb1ba238a2a 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -167,6 +167,7 @@ TEST_GEN_PROGS_arm64 += arm64/vgic_irq
 TEST_GEN_PROGS_arm64 += arm64/vgic_lpi_stress
 TEST_GEN_PROGS_arm64 += arm64/vpmu_counter_access
 TEST_GEN_PROGS_arm64 += arm64/no-vgic-v3
+TEST_GEN_PROGS_arm64 += arm64/kvm-uuid
 TEST_GEN_PROGS_arm64 += access_tracking_perf_test
 TEST_GEN_PROGS_arm64 += arch_timer
 TEST_GEN_PROGS_arm64 += coalesced_io_test
diff --git a/tools/testing/selftests/kvm/arm64/kvm-uuid.c b/tools/testing/selftests/kvm/arm64/kvm-uuid.c
new file mode 100644
index 0000000000000..89d9c8b182ae5
--- /dev/null
+++ b/tools/testing/selftests/kvm/arm64/kvm-uuid.c
@@ -0,0 +1,67 @@
+#include <errno.h>
+#include <linux/arm-smccc.h>
+#include <asm/kvm.h>
+#include <kvm_util.h>
+
+#include "processor.h"
+
+/*
+ * Do NOT redefine these constants, or try to replace them with some
+ * "common" version. They are hardcoded here to detect any potential
+ * breakage happening in the rest of the kernel.
+ *
+ * KVM UID value: 28b46fb6-2ec5-11e9-a9ca-4b564d003a74
+ */
+#define ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_0	0xb66fb428U
+#define ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_1	0xe911c52eU
+#define ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_2	0x564bcaa9U
+#define ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_3	0x743a004dU
+
+static void guest_code(void)
+{
+	struct arm_smccc_res res = {};
+
+	smccc_hvc(ARM_SMCCC_VENDOR_HYP_CALL_UID_FUNC_ID, 0, 0, 0, 0, 0, 0, 0, &res);
+
+	__GUEST_ASSERT(res.a0 != SMCCC_RET_NOT_SUPPORTED, "a0 = %lx\n", res.a0);
+	__GUEST_ASSERT(res.a0 == ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_0 &&
+		       res.a1 == ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_1 &&
+		       res.a2 == ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_2 &&
+		       res.a3 == ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_3,
+		       "Unexpected KVM-specific UID %lx %lx %lx %lx\n", res.a0, res.a1, res.a2, res.a3);
+	GUEST_DONE();
+}
+
+int main (int argc, char *argv[])
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+	struct ucall uc;
+	bool guest_done = false;
+
+	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
+
+	while (!guest_done) {
+		vcpu_run(vcpu);
+
+		switch (get_ucall(vcpu, &uc)) {
+		case UCALL_SYNC:
+			break;
+		case UCALL_DONE:
+			guest_done = true;
+			break;
+		case UCALL_ABORT:
+			REPORT_GUEST_ASSERT(uc);
+			break;
+		case UCALL_PRINTF:
+			printf("%s", uc.buffer);
+			break;
+		default:
+			TEST_FAIL("Unexpected guest exit");
+		}
+	}
+
+	kvm_vm_free(vm);
+
+	return 0;
+}
-- 
2.39.2


