Return-Path: <kvm+bounces-57943-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C822BB81F31
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 23:24:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AA05D7BDA6C
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 21:21:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48BDD30C35F;
	Wed, 17 Sep 2025 21:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="N+00bxE7"
X-Original-To: kvm@vger.kernel.org
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB84930C365
	for <kvm@vger.kernel.org>; Wed, 17 Sep 2025 21:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758144134; cv=none; b=QaeIvwoevn7PGCzHstad7wGEmVj5t7yV7Mud2SnOEoB4tx7p8oOUUTFNEfebCv5yp092fFjTVFEECO4nB1/Jb+G9FXrR8I2EveN+93/qbhilqIf6gsGUJzXI/aRepkKkzRB+eKjM9koK87R6cMV908bX2Q65/Lx+2wd3yWbkh8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758144134; c=relaxed/simple;
	bh=689/OBfW/C2MrJbZxOFxShzMMLmvXMmlkqVKYAV0c2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B5zs70+uo7mVoak+oNnlPyTPuPWiejdT+N/R739pE25ZIbZoyhluxB6SGMY61vTzV/nRYYa5aSrnq2szePyJeebmlcHSS04S2wtTZqeWyIhy7XkbjEuecicd0pYZU4rU46bHiE33QQmLujoyobgrkKngPpoSBIStbGdDu/YYWlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=N+00bxE7; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758144130;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=K5HYADmHCX472sFeljJ9Tm65HKk4u8deCrxi12j+YTQ=;
	b=N+00bxE7auTffIakMyFatSTKSK4vg3b/Zepi/ODAad0m7xiTZhSmGNl3DoGVDbp++eocmM
	d25IDz1OTCyOE01XVnQIUXcvhV2WWnHCtNFNsw7Y18SUt2lPgDhutS2nCpdbDBOmAFcxd6
	USqnrq+1kw6gj2YTjoAKjfLJOP4g3l4=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 13/13] KVM: arm64: selftests: Add basic test for running in VHE EL2
Date: Wed, 17 Sep 2025 14:20:43 -0700
Message-ID: <20250917212044.294760-14-oliver.upton@linux.dev>
In-Reply-To: <20250917212044.294760-1-oliver.upton@linux.dev>
References: <20250917212044.294760-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Add an embarrassingly simple selftest for sanity checking KVM's VHE EL2
and test that the ID register bits are consistent with HCR_EL2.E2H being
RES1.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 tools/testing/selftests/kvm/Makefile.kvm      |  1 +
 tools/testing/selftests/kvm/arm64/hello_el2.c | 58 +++++++++++++++++++
 2 files changed, 59 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/arm64/hello_el2.c

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index 41b40c676d7f..5d59267d4089 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -156,6 +156,7 @@ TEST_GEN_PROGS_arm64 = $(TEST_GEN_PROGS_COMMON)
 TEST_GEN_PROGS_arm64 += arm64/aarch32_id_regs
 TEST_GEN_PROGS_arm64 += arm64/arch_timer_edge_cases
 TEST_GEN_PROGS_arm64 += arm64/debug-exceptions
+TEST_GEN_PROGS_arm64 += arm64/hello_el2
 TEST_GEN_PROGS_arm64 += arm64/host_sve
 TEST_GEN_PROGS_arm64 += arm64/hypercalls
 TEST_GEN_PROGS_arm64 += arm64/external_aborts
diff --git a/tools/testing/selftests/kvm/arm64/hello_el2.c b/tools/testing/selftests/kvm/arm64/hello_el2.c
new file mode 100644
index 000000000000..3c1f44e43f65
--- /dev/null
+++ b/tools/testing/selftests/kvm/arm64/hello_el2.c
@@ -0,0 +1,58 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * hello_el2 - Basic KVM selftest for VM running at EL2 with E2H=RES1
+ *
+ * Copyright 2025 Google LLC
+ */
+#include "kvm_util.h"
+#include "processor.h"
+#include "test_util.h"
+#include "ucall.h"
+
+#include <asm/sysreg.h>
+
+static void guest_code(void)
+{
+	u64 mmfr1 = read_sysreg_s(SYS_ID_AA64MMFR1_EL1);
+	u64 mmfr4 = read_sysreg_s(SYS_ID_AA64MMFR4_EL1);
+
+	GUEST_ASSERT_EQ(get_current_el(), 2);
+	GUEST_ASSERT(read_sysreg(hcr_el2) & HCR_EL2_E2H);
+	GUEST_ASSERT_EQ(SYS_FIELD_GET(ID_AA64MMFR1_EL1, VH, mmfr1),
+			ID_AA64MMFR1_EL1_VH_IMP);
+	GUEST_ASSERT_EQ(SYS_FIELD_GET(ID_AA64MMFR4_EL1, E2H0, mmfr4),
+			ID_AA64MMFR4_EL1_E2H0_NI_NV1);
+
+	GUEST_DONE();
+}
+
+int main(void)
+{
+	struct kvm_vcpu_init init;
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+	struct ucall uc;
+
+	TEST_REQUIRE(kvm_check_cap(KVM_CAP_ARM_EL2));
+
+	vm = vm_create(1);
+
+	kvm_get_default_vcpu_target(vm, &init);
+	init.features[0] |= BIT(KVM_ARM_VCPU_HAS_EL2);
+	vcpu = aarch64_vcpu_add(vm, 0, &init, guest_code);
+	kvm_arch_vm_finalize_vcpus(vm);
+
+	vcpu_run(vcpu);
+	switch (get_ucall(vcpu, &uc)) {
+	case UCALL_DONE:
+		break;
+	case UCALL_ABORT:
+		REPORT_GUEST_ASSERT(uc);
+		break;
+	default:
+		TEST_FAIL("Unhandled ucall: %ld\n", uc.cmd);
+	}
+
+	kvm_vm_free(vm);
+	return 0;
+}
-- 
2.47.3


