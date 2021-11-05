Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98CC9446B69
	for <lists+kvm@lfdr.de>; Sat,  6 Nov 2021 00:59:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233527AbhKFABp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Nov 2021 20:01:45 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:4775 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233184AbhKFABn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Nov 2021 20:01:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1636156741; x=1667692741;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ry3CefX/Tp4xaLpui45N/sUnV2uYJCRDeodPmHhQp30=;
  b=Y8kSr9VZIveMc/hxAqJ2zmX86loPL2kUVMeT9+U8bgI2jpUKy6f1gv2g
   4F+jbF4QmCpSyHdnREAuDu0mGudZUQjXhPc0H0vIfqZ/WFJYQIr3VawNT
   0Xq3d5fhC6r0lJKGZKbt3wabh9wx8nDxs2+CE3rvfectSbHbH6QS85V49
   jer4KSwdQ0dWXKBilO5EgBsWJILtrVPI39mjF/bE2zbEwmr2TFFh42cc1
   VwOMxaSOwti/f7MojBSJtWrm7giU+6D+6jI2NK6bW37/EVaRZBX69OKiF
   uI0mTOxK+G7i5d77ATzxeC5o3klf1XH83R1mEKbEIFhDx35S5i1faK2+l
   g==;
X-IronPort-AV: E=Sophos;i="5.87,212,1631548800"; 
   d="scan'208";a="189637763"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 06 Nov 2021 07:59:00 +0800
IronPort-SDR: /V2O6IdDKg2ggcNCppBeOBsRP54uOb6LuNgQDgM/h3RqWtL3Ae1ymqYh7YJe6aRTA3pK69biVj
 CBjeYhlnu8J0Fuj7DyjGv5gc4vyckfiv1grRHPg4BcGtcq6VevVyAQ5nn1qJSthsDlajpk0KiU
 U4QB/W4k/lCQyeENtPLpctVqs6VgobVOp0XTax0Z7gVSVw/z/oaCOVNBBcyLcrt6ldu+44NFWl
 uIUEmGqIgQRmNHw9Vf8FiCn5lrU9GId1L9vwZvxKCwgmCUMhrlK52uWljyx+sIJtEFtrF344kx
 AgB56H/KcheuRUxOd7kXVJ3v
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2021 16:32:46 -0700
IronPort-SDR: nPfFgdVx3EqyS/bfu7H2v5XNaDKqbaygz/10P+fMvqqhGn/0V1iDl3bF00LnyxkfaQm9XaEr/g
 neXs+JNseTJBl9wDooouv0o8jYtvJjR8DJb/jyKkghJToE5QBUTLaQrGtAkC8MBhXuzWINwRU5
 u5MYWgpzHVDFPGwElPzqE2zJdeu88HQBbQRoSmnW2mtmMb4G1Aq9XwfYkMAkID977O5O57iD6l
 ij+jfLiFA+OSi/A/jcJHUo3GCV4qn9aqZtZRllKyCQp8D9SRg08//mA97IkIrdy2IO5iNetpSi
 8Fw=
WDCIronportException: Internal
Received: from unknown (HELO hulk.wdc.com) ([10.225.167.48])
  by uls-op-cesaip02.wdc.com with ESMTP; 05 Nov 2021 16:59:03 -0700
From:   Atish Patra <atish.patra@wdc.com>
To:     linux-kernel@vger.kernel.org
Cc:     Atish Patra <atish.patra@wdc.com>, Anup Patel <anup.patel@wdc.com>,
        Heinrich Schuchardt <xypron.glpk@gmx.de>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-riscv@lists.infradead.org,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Vincent Chen <vincent.chen@sifive.com>, pbonzini@redhat.com,
        Sean Christopherson <seanjc@google.com>
Subject: [PATCH v4 2/5] RISC-V: KVM: Reorganize SBI code by moving SBI v0.1 to its own file
Date:   Fri,  5 Nov 2021 16:58:49 -0700
Message-Id: <20211105235852.3011900-3-atish.patra@wdc.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211105235852.3011900-1-atish.patra@wdc.com>
References: <20211105235852.3011900-1-atish.patra@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

With SBI v0.2, there may be more SBI extensions in future. It makes more
sense to group related extensions in separate files. Guest kernel will
choose appropriate SBI version dynamically.

Move the existing implementation to a separate file so that it can be
removed in future without much conflict.

Signed-off-by: Atish Patra <atish.patra@wdc.com>
---
 arch/riscv/include/asm/kvm_vcpu_sbi.h |   2 +
 arch/riscv/kvm/Makefile               |   1 +
 arch/riscv/kvm/vcpu_sbi.c             | 151 +++-----------------------
 arch/riscv/kvm/vcpu_sbi_v01.c         | 129 ++++++++++++++++++++++
 4 files changed, 149 insertions(+), 134 deletions(-)
 create mode 100644 arch/riscv/kvm/vcpu_sbi_v01.c

diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi.h b/arch/riscv/include/asm/kvm_vcpu_sbi.h
index 1a4cb0db2d0b..704151969ceb 100644
--- a/arch/riscv/include/asm/kvm_vcpu_sbi.h
+++ b/arch/riscv/include/asm/kvm_vcpu_sbi.h
@@ -25,5 +25,7 @@ struct kvm_vcpu_sbi_extension {
 		       bool *exit);
 };
 
+void kvm_riscv_vcpu_sbi_forward(struct kvm_vcpu *vcpu, struct kvm_run *run);
 const struct kvm_vcpu_sbi_extension *kvm_vcpu_sbi_find_ext(unsigned long extid);
+
 #endif /* __RISCV_KVM_VCPU_SBI_H__ */
diff --git a/arch/riscv/kvm/Makefile b/arch/riscv/kvm/Makefile
index 30cdd1df0098..d3d5ff3a6019 100644
--- a/arch/riscv/kvm/Makefile
+++ b/arch/riscv/kvm/Makefile
@@ -23,4 +23,5 @@ kvm-y += vcpu_exit.o
 kvm-y += vcpu_fp.o
 kvm-y += vcpu_switch.o
 kvm-y += vcpu_sbi.o
+kvm-$(CONFIG_RISCV_SBI_V01) += vcpu_sbi_v01.o
 kvm-y += vcpu_timer.o
diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
index 05cab5f27eee..06b42f6977e1 100644
--- a/arch/riscv/kvm/vcpu_sbi.c
+++ b/arch/riscv/kvm/vcpu_sbi.c
@@ -9,9 +9,7 @@
 #include <linux/errno.h>
 #include <linux/err.h>
 #include <linux/kvm_host.h>
-#include <asm/csr.h>
 #include <asm/sbi.h>
-#include <asm/kvm_vcpu_timer.h>
 #include <asm/kvm_vcpu_sbi.h>
 
 static int kvm_linux_err_map_sbi(int err)
@@ -32,8 +30,21 @@ static int kvm_linux_err_map_sbi(int err)
 	};
 }
 
-static void kvm_riscv_vcpu_sbi_forward(struct kvm_vcpu *vcpu,
-				       struct kvm_run *run)
+#ifdef CONFIG_RISCV_SBI_V01
+extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_v01;
+#else
+static const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_v01 = {
+	.extid_start = -1UL,
+	.extid_end = -1UL,
+	.handler = NULL,
+};
+#endif
+
+static const struct kvm_vcpu_sbi_extension *sbi_ext[] = {
+	&vcpu_sbi_ext_v01,
+};
+
+void kvm_riscv_vcpu_sbi_forward(struct kvm_vcpu *vcpu, struct kvm_run *run)
 {
 	struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
 
@@ -71,126 +82,6 @@ int kvm_riscv_vcpu_sbi_return(struct kvm_vcpu *vcpu, struct kvm_run *run)
 	return 0;
 }
 
-#ifdef CONFIG_RISCV_SBI_V01
-
-static void kvm_sbi_system_shutdown(struct kvm_vcpu *vcpu,
-				    struct kvm_run *run, u32 type)
-{
-	int i;
-	struct kvm_vcpu *tmp;
-
-	kvm_for_each_vcpu(i, tmp, vcpu->kvm)
-		tmp->arch.power_off = true;
-	kvm_make_all_cpus_request(vcpu->kvm, KVM_REQ_SLEEP);
-
-	memset(&run->system_event, 0, sizeof(run->system_event));
-	run->system_event.type = type;
-	run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
-}
-
-static int kvm_sbi_ext_v01_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
-				      unsigned long *out_val,
-				      struct kvm_cpu_trap *utrap,
-				      bool *exit)
-{
-	ulong hmask;
-	int i, ret = 0;
-	u64 next_cycle;
-	struct kvm_vcpu *rvcpu;
-	struct cpumask cm, hm;
-	struct kvm *kvm = vcpu->kvm;
-	struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
-
-	if (!cp)
-		return -EINVAL;
-
-	switch (cp->a7) {
-	case SBI_EXT_0_1_CONSOLE_GETCHAR:
-	case SBI_EXT_0_1_CONSOLE_PUTCHAR:
-		/*
-		 * The CONSOLE_GETCHAR/CONSOLE_PUTCHAR SBI calls cannot be
-		 * handled in kernel so we forward these to user-space
-		 */
-		kvm_riscv_vcpu_sbi_forward(vcpu, run);
-		*exit = true;
-		break;
-	case SBI_EXT_0_1_SET_TIMER:
-#if __riscv_xlen == 32
-		next_cycle = ((u64)cp->a1 << 32) | (u64)cp->a0;
-#else
-		next_cycle = (u64)cp->a0;
-#endif
-		ret = kvm_riscv_vcpu_timer_next_event(vcpu, next_cycle);
-		break;
-	case SBI_EXT_0_1_CLEAR_IPI:
-		ret = kvm_riscv_vcpu_unset_interrupt(vcpu, IRQ_VS_SOFT);
-		break;
-	case SBI_EXT_0_1_SEND_IPI:
-		if (cp->a0)
-			hmask = kvm_riscv_vcpu_unpriv_read(vcpu, false, cp->a0,
-							   utrap);
-		else
-			hmask = (1UL << atomic_read(&kvm->online_vcpus)) - 1;
-		if (utrap->scause)
-			break;
-
-		for_each_set_bit(i, &hmask, BITS_PER_LONG) {
-			rvcpu = kvm_get_vcpu_by_id(vcpu->kvm, i);
-			ret = kvm_riscv_vcpu_set_interrupt(rvcpu, IRQ_VS_SOFT);
-			if (ret < 0)
-				break;
-		}
-		break;
-	case SBI_EXT_0_1_SHUTDOWN:
-		kvm_sbi_system_shutdown(vcpu, run, KVM_SYSTEM_EVENT_SHUTDOWN);
-		*exit = true;
-		break;
-	case SBI_EXT_0_1_REMOTE_FENCE_I:
-	case SBI_EXT_0_1_REMOTE_SFENCE_VMA:
-	case SBI_EXT_0_1_REMOTE_SFENCE_VMA_ASID:
-		if (cp->a0)
-			hmask = kvm_riscv_vcpu_unpriv_read(vcpu, false, cp->a0,
-							   utrap);
-		else
-			hmask = (1UL << atomic_read(&kvm->online_vcpus)) - 1;
-		if (utrap->scause)
-			break;
-
-		cpumask_clear(&cm);
-		for_each_set_bit(i, &hmask, BITS_PER_LONG) {
-			rvcpu = kvm_get_vcpu_by_id(vcpu->kvm, i);
-			if (rvcpu->cpu < 0)
-				continue;
-			cpumask_set_cpu(rvcpu->cpu, &cm);
-		}
-		riscv_cpuid_to_hartid_mask(&cm, &hm);
-		if (cp->a7 == SBI_EXT_0_1_REMOTE_FENCE_I)
-			ret = sbi_remote_fence_i(cpumask_bits(&hm));
-		else if (cp->a7 == SBI_EXT_0_1_REMOTE_SFENCE_VMA)
-			ret = sbi_remote_hfence_vvma(cpumask_bits(&hm),
-						cp->a1, cp->a2);
-		else
-			ret = sbi_remote_hfence_vvma_asid(cpumask_bits(&hm),
-						cp->a1, cp->a2, cp->a3);
-		break;
-	default:
-		ret = -EINVAL;
-		break;
-	}
-
-	return ret;
-}
-
-const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_v01 = {
-	.extid_start = SBI_EXT_0_1_SET_TIMER,
-	.extid_end = SBI_EXT_0_1_SHUTDOWN,
-	.handler = kvm_sbi_ext_v01_handler,
-};
-
-static const struct kvm_vcpu_sbi_extension *sbi_ext[] = {
-	&vcpu_sbi_ext_v01,
-};
-
 const struct kvm_vcpu_sbi_extension *kvm_vcpu_sbi_find_ext(unsigned long extid)
 {
 	int i = 0;
@@ -220,9 +111,11 @@ int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, struct kvm_run *run)
 
 	sbi_ext = kvm_vcpu_sbi_find_ext(cp->a7);
 	if (sbi_ext && sbi_ext->handler) {
+#ifdef CONFIG_RISCV_SBI_V01
 		if (cp->a7 >= SBI_EXT_0_1_SET_TIMER &&
 		    cp->a7 <= SBI_EXT_0_1_SHUTDOWN)
 			ext_is_v01 = true;
+#endif
 		ret = sbi_ext->handler(vcpu, run, &out_val, &utrap, &userspace_exit);
 	} else {
 		/* Return error for unsupported SBI calls */
@@ -262,13 +155,3 @@ int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, struct kvm_run *run)
 
 	return ret;
 }
-
-#else
-
-int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, struct kvm_run *run)
-{
-	kvm_riscv_vcpu_sbi_forward(vcpu, run);
-	return 0;
-}
-
-#endif
diff --git a/arch/riscv/kvm/vcpu_sbi_v01.c b/arch/riscv/kvm/vcpu_sbi_v01.c
new file mode 100644
index 000000000000..5a8e2afc8a57
--- /dev/null
+++ b/arch/riscv/kvm/vcpu_sbi_v01.c
@@ -0,0 +1,129 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2021 Western Digital Corporation or its affiliates.
+ *
+ * Authors:
+ *     Atish Patra <atish.patra@wdc.com>
+ */
+
+#include <linux/errno.h>
+#include <linux/err.h>
+#include <linux/kvm_host.h>
+#include <asm/csr.h>
+#include <asm/sbi.h>
+#include <asm/kvm_vcpu_timer.h>
+#include <asm/kvm_vcpu_sbi.h>
+
+static void kvm_sbi_system_shutdown(struct kvm_vcpu *vcpu,
+				    struct kvm_run *run, u32 type)
+{
+	int i;
+	struct kvm_vcpu *tmp;
+
+	kvm_for_each_vcpu(i, tmp, vcpu->kvm)
+		tmp->arch.power_off = true;
+	kvm_make_all_cpus_request(vcpu->kvm, KVM_REQ_SLEEP);
+
+	memset(&run->system_event, 0, sizeof(run->system_event));
+	run->system_event.type = type;
+	run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
+}
+
+static int kvm_sbi_ext_v01_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
+				      unsigned long *out_val,
+				      struct kvm_cpu_trap *utrap,
+				      bool *exit)
+{
+	ulong hmask;
+	int i, ret = 0;
+	u64 next_cycle;
+	struct kvm_vcpu *rvcpu;
+	struct cpumask cm, hm;
+	struct kvm *kvm = vcpu->kvm;
+	struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
+
+	if (!cp)
+		return -EINVAL;
+
+	switch (cp->a7) {
+	case SBI_EXT_0_1_CONSOLE_GETCHAR:
+	case SBI_EXT_0_1_CONSOLE_PUTCHAR:
+		/*
+		 * The CONSOLE_GETCHAR/CONSOLE_PUTCHAR SBI calls cannot be
+		 * handled in kernel so we forward these to user-space
+		 */
+		kvm_riscv_vcpu_sbi_forward(vcpu, run);
+		*exit = true;
+		break;
+	case SBI_EXT_0_1_SET_TIMER:
+#if __riscv_xlen == 32
+		next_cycle = ((u64)cp->a1 << 32) | (u64)cp->a0;
+#else
+		next_cycle = (u64)cp->a0;
+#endif
+		ret = kvm_riscv_vcpu_timer_next_event(vcpu, next_cycle);
+		break;
+	case SBI_EXT_0_1_CLEAR_IPI:
+		ret = kvm_riscv_vcpu_unset_interrupt(vcpu, IRQ_VS_SOFT);
+		break;
+	case SBI_EXT_0_1_SEND_IPI:
+		if (cp->a0)
+			hmask = kvm_riscv_vcpu_unpriv_read(vcpu, false, cp->a0,
+							   utrap);
+		else
+			hmask = (1UL << atomic_read(&kvm->online_vcpus)) - 1;
+		if (utrap->scause)
+			break;
+
+		for_each_set_bit(i, &hmask, BITS_PER_LONG) {
+			rvcpu = kvm_get_vcpu_by_id(vcpu->kvm, i);
+			ret = kvm_riscv_vcpu_set_interrupt(rvcpu, IRQ_VS_SOFT);
+			if (ret < 0)
+				break;
+		}
+		break;
+	case SBI_EXT_0_1_SHUTDOWN:
+		kvm_sbi_system_shutdown(vcpu, run, KVM_SYSTEM_EVENT_SHUTDOWN);
+		*exit = true;
+		break;
+	case SBI_EXT_0_1_REMOTE_FENCE_I:
+	case SBI_EXT_0_1_REMOTE_SFENCE_VMA:
+	case SBI_EXT_0_1_REMOTE_SFENCE_VMA_ASID:
+		if (cp->a0)
+			hmask = kvm_riscv_vcpu_unpriv_read(vcpu, false, cp->a0,
+							   utrap);
+		else
+			hmask = (1UL << atomic_read(&kvm->online_vcpus)) - 1;
+		if (utrap->scause)
+			break;
+
+		cpumask_clear(&cm);
+		for_each_set_bit(i, &hmask, BITS_PER_LONG) {
+			rvcpu = kvm_get_vcpu_by_id(vcpu->kvm, i);
+			if (rvcpu->cpu < 0)
+				continue;
+			cpumask_set_cpu(rvcpu->cpu, &cm);
+		}
+		riscv_cpuid_to_hartid_mask(&cm, &hm);
+		if (cp->a7 == SBI_EXT_0_1_REMOTE_FENCE_I)
+			ret = sbi_remote_fence_i(cpumask_bits(&hm));
+		else if (cp->a7 == SBI_EXT_0_1_REMOTE_SFENCE_VMA)
+			ret = sbi_remote_hfence_vvma(cpumask_bits(&hm),
+						cp->a1, cp->a2);
+		else
+			ret = sbi_remote_hfence_vvma_asid(cpumask_bits(&hm),
+						cp->a1, cp->a2, cp->a3);
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	};
+
+	return ret;
+}
+
+const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_v01 = {
+	.extid_start = SBI_EXT_0_1_SET_TIMER,
+	.extid_end = SBI_EXT_0_1_SHUTDOWN,
+	.handler = kvm_sbi_ext_v01_handler,
+};
-- 
2.31.1

