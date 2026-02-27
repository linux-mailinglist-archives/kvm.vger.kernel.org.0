Return-Path: <kvm+bounces-72188-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0E8jDQTPoWn3wQQAu9opvQ
	(envelope-from <kvm+bounces-72188-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 18:06:12 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id B8FC81BB2F6
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 18:06:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A28FE31BDDC7
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 17:00:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 592B235E549;
	Fri, 27 Feb 2026 16:59:59 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F79935CB6B
	for <kvm@vger.kernel.org>; Fri, 27 Feb 2026 16:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772211598; cv=none; b=jNs+28ZGtK3UUTmwcb8fxySwfyeTZaRU6kCHIoNvwxaXpMhbRQTOJltFhu+ccgecT8yQPs/WL3SFiUATM8tYswwvIgea41yB3RhjZU5cMxNnXIJgIA+7wtEh0n6keTAsUkchVLyCt0NhA5O+uBffLXYS7OZ3CDfJitBkfr4Opow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772211598; c=relaxed/simple;
	bh=BvzGUje05ZB+KN1UmGEoAnRfJHb/w/1zL4rddFo/53g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iArM68bAjBxjyzGqWnP8ycsJCJY5wk2B29eVuaVzI7MlW74lND+vHn50g4SmjWl4kTIcmZwMXAECbX++OWi7uO/FbLIcNRD1yToHHwACaxEIk78FB+K7m97MA1UqzE7gzY32m5Q7M+XrFtkmX20ZkYD4sFR7OFhGUKp5mAiCvQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 054301516;
	Fri, 27 Feb 2026 08:59:49 -0800 (PST)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id EF0A93F73B;
	Fri, 27 Feb 2026 08:59:53 -0800 (PST)
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: kvm@vger.kernel.org
Cc: kvmarm@lists.linux.dev,
	will@kernel.org,
	maz@kernel.org,
	tabba@google.com,
	steven.price@arm.com,
	aneesh.kumar@kernel.org,
	alexandru.elisei@arm.com,
	oupton@kernel.org,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [kvmtool PATCH v6 11/17] arm64: Add skeleton implementation for PSCI
Date: Fri, 27 Feb 2026 16:56:18 +0000
Message-ID: <20260227165624.1519865-12-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260227165624.1519865-1-suzuki.poulose@arm.com>
References: <20260227165624.1519865-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.14 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	DMARC_POLICY_SOFTFAIL(0.10)[arm.com : SPF not aligned (relaxed), No valid DKIM,none];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72188-lists,kvm=lfdr.de];
	RCVD_COUNT_FIVE(0.00)[5];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FROM_NEQ_ENVFROM(0.00)[suzuki.poulose@arm.com,kvm@vger.kernel.org];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	R_DKIM_NA(0.00)[];
	NEURAL_HAM(-0.00)[-0.967];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	TO_DN_SOME(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,linux.dev:email,arm.com:mid,arm.com:email]
X-Rspamd-Queue-Id: B8FC81BB2F6
X-Rspamd-Action: no action

From: Oliver Upton <oliver.upton@linux.dev>

Add an extremely barebones implementation for handling PSCI, where the
only supported call is PSCI_VERSION.

Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 Makefile                  |  2 ++
 arm64/include/asm/smccc.h | 65 ++++++++++++++++++++++++++++++++++++
 arm64/kvm-cpu.c           | 19 ++++++++---
 arm64/kvm.c               |  3 ++
 arm64/psci.c              | 69 +++++++++++++++++++++++++++++++++++++++
 arm64/smccc.c             | 44 +++++++++++++++++++++++++
 6 files changed, 197 insertions(+), 5 deletions(-)
 create mode 100644 arm64/include/asm/smccc.h
 create mode 100644 arm64/psci.c
 create mode 100644 arm64/smccc.c

diff --git a/Makefile b/Makefile
index 60e551fd..1c0e7f55 100644
--- a/Makefile
+++ b/Makefile
@@ -181,6 +181,8 @@ ifeq ($(ARCH), arm64)
 	OBJS		+= arm64/arm-cpu.o
 	OBJS		+= arm64/pvtime.o
 	OBJS		+= arm64/pmu.o
+	OBJS		+= arm64/psci.o
+	OBJS		+= arm64/smccc.o
 	ARCH_INCLUDE	:= arm64/include
 
 	ARCH_WANT_LIBFDT := y
diff --git a/arm64/include/asm/smccc.h b/arm64/include/asm/smccc.h
new file mode 100644
index 00000000..c1be21a7
--- /dev/null
+++ b/arm64/include/asm/smccc.h
@@ -0,0 +1,65 @@
+#ifndef __ARM_SMCCC_H__
+#define __ARM_SMCCC_H__
+
+#include "kvm/kvm-cpu.h"
+
+#include <linux/arm-smccc.h>
+#include <linux/types.h>
+
+static inline bool smccc_is_64bit(struct kvm_cpu *vcpu)
+{
+	return ARM_SMCCC_IS_64(vcpu->kvm_run->hypercall.nr);
+}
+
+static inline bool smccc_calling_conv_allowed(struct kvm_cpu *vcpu, u32 fn)
+{
+	return !(vcpu->kvm->cfg.arch.aarch32_guest && ARM_SMCCC_IS_64(fn));
+}
+
+static inline u64 smccc_get_arg(struct kvm_cpu *vcpu, u8 arg)
+{
+	u64 val;
+	struct kvm_one_reg reg = {
+		.id	= ARM64_CORE_REG(regs.regs[arg]),
+		.addr	= (u64)&val,
+	};
+
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg))
+		die_perror("KVM_GET_ONE_REG failed");
+
+	if (!smccc_is_64bit(vcpu))
+		val = (u32)val;
+
+	return val;
+}
+
+static inline void smccc_return_result(struct kvm_cpu *vcpu, struct arm_smccc_res *res)
+{
+	unsigned long *vals = (unsigned long *)res;
+	unsigned long i;
+
+	/*
+	 * The author was lazy and chose to abuse the layout of struct
+	 * arm_smccc_res to write a loop set the retvals.
+	 */
+	for (i = 0; i < sizeof(*res) / sizeof(unsigned long); i++) {
+		u64 val = vals[i];
+		struct kvm_one_reg reg = {
+			.id	= ARM64_CORE_REG(regs.regs[i]),
+			.addr	= (u64)&val,
+		};
+
+		if (!smccc_is_64bit(vcpu))
+			val = (u32)val;
+
+		if (ioctl(vcpu->vcpu_fd, KVM_SET_ONE_REG, &reg))
+			die_perror("KVM_SET_ONE_REG failed");
+	}
+}
+
+bool handle_hypercall(struct kvm_cpu *vcpu);
+void handle_psci(struct kvm_cpu *vcpu, struct arm_smccc_res *res);
+
+void kvm__setup_smccc(struct kvm *kvm);
+
+#endif /* __ARM_SMCCC_H__ */
diff --git a/arm64/kvm-cpu.c b/arm64/kvm-cpu.c
index f8e08b5d..6cd058fa 100644
--- a/arm64/kvm-cpu.c
+++ b/arm64/kvm-cpu.c
@@ -1,6 +1,7 @@
 #include "kvm/kvm.h"
 #include "kvm/kvm-cpu.h"
 #include "kvm/virtio.h"
+#include "asm/smccc.h"
 
 #include <asm/ptrace.h>
 #include <linux/bitops.h>
@@ -229,11 +230,6 @@ void kvm_cpu__delete(struct kvm_cpu *vcpu)
 	free(vcpu);
 }
 
-bool kvm_cpu__handle_exit(struct kvm_cpu *vcpu)
-{
-	return false;
-}
-
 void kvm_cpu__show_page_tables(struct kvm_cpu *vcpu)
 {
 }
@@ -469,3 +465,16 @@ void kvm_cpu__show_registers(struct kvm_cpu *vcpu)
 		die("KVM_GET_ONE_REG failed (lr)");
 	dprintf(debug_fd, " LR:    0x%lx\n", data);
 }
+
+bool kvm_cpu__handle_exit(struct kvm_cpu *vcpu)
+{
+	struct kvm_run *run = vcpu->kvm_run;
+
+	switch (run->exit_reason) {
+	case KVM_EXIT_HYPERCALL:
+		handle_hypercall(vcpu);
+		return true;
+	default:
+		return false;
+	}
+}
diff --git a/arm64/kvm.c b/arm64/kvm.c
index 41c47b13..56e4f149 100644
--- a/arm64/kvm.c
+++ b/arm64/kvm.c
@@ -7,6 +7,8 @@
 #include "kvm/gic.h"
 #include "kvm/kvm-cpu.h"
 
+#include "asm/smccc.h"
+
 #include <linux/byteorder.h>
 #include <linux/cpumask.h>
 #include <linux/kernel.h>
@@ -127,6 +129,7 @@ void kvm__arch_init(struct kvm *kvm)
 		die("Failed to create virtual GIC");
 
 	kvm__arch_enable_mte(kvm);
+	kvm__setup_smccc(kvm);
 }
 
 
diff --git a/arm64/psci.c b/arm64/psci.c
new file mode 100644
index 00000000..72429b36
--- /dev/null
+++ b/arm64/psci.c
@@ -0,0 +1,69 @@
+#include "asm/smccc.h"
+#include "kvm/kvm.h"
+#include "kvm/kvm-cpu.h"
+#include "kvm/util.h"
+
+#include <linux/psci.h>
+#include <linux/types.h>
+
+static void psci_features(struct kvm_cpu *vcpu, struct arm_smccc_res *res)
+{
+	u32 arg = smccc_get_arg(vcpu, 1);
+
+	res->a0 = PSCI_RET_NOT_SUPPORTED;
+	if (!smccc_calling_conv_allowed(vcpu, arg))
+		return;
+
+	switch (arg) {
+	case PSCI_0_2_FN_CPU_SUSPEND:
+	case PSCI_0_2_FN64_CPU_SUSPEND:
+	case PSCI_0_2_FN_CPU_OFF:
+	case ARM_SMCCC_VERSION_FUNC_ID:
+		res->a0 = PSCI_RET_SUCCESS;
+		break;
+	}
+}
+
+static void cpu_suspend(struct kvm_cpu *vcpu, struct arm_smccc_res *res)
+{
+	struct kvm_mp_state mp_state = {
+		.mp_state	= KVM_MP_STATE_SUSPENDED,
+	};
+
+	/* Rely on in-kernel emulation of a 'suspended' (i.e. WFI) state. */
+	if (ioctl(vcpu->vcpu_fd, KVM_SET_MP_STATE, &mp_state))
+		die_perror("KVM_SET_MP_STATE failed");
+
+	res->a0 = PSCI_RET_SUCCESS;
+}
+
+static void cpu_off(struct kvm_cpu *vcpu, struct arm_smccc_res *res)
+{
+	struct kvm_mp_state mp_state = {
+		.mp_state	= KVM_MP_STATE_STOPPED,
+	};
+
+	if (ioctl(vcpu->vcpu_fd, KVM_SET_MP_STATE, &mp_state))
+		die_perror("KVM_SET_MP_STATE failed");
+}
+
+void handle_psci(struct kvm_cpu *vcpu, struct arm_smccc_res *res)
+{
+	switch (vcpu->kvm_run->hypercall.nr) {
+	case PSCI_0_2_FN_PSCI_VERSION:
+		res->a0 = PSCI_VERSION(1, 0);
+		break;
+	case PSCI_1_0_FN_PSCI_FEATURES:
+		psci_features(vcpu, res);
+		break;
+	case PSCI_0_2_FN_CPU_SUSPEND:
+	case PSCI_0_2_FN64_CPU_SUSPEND:
+		cpu_suspend(vcpu, res);
+		break;
+	case PSCI_0_2_FN_CPU_OFF:
+		cpu_off(vcpu, res);
+		break;
+	default:
+		res->a0 = PSCI_RET_NOT_SUPPORTED;
+	}
+}
diff --git a/arm64/smccc.c b/arm64/smccc.c
new file mode 100644
index 00000000..ef986d8c
--- /dev/null
+++ b/arm64/smccc.c
@@ -0,0 +1,44 @@
+#include "asm/smccc.h"
+#include "kvm/kvm.h"
+#include "kvm/kvm-cpu.h"
+#include "kvm/util.h"
+
+#include <linux/types.h>
+
+static void handle_std_call(struct kvm_cpu *vcpu, struct arm_smccc_res *res)
+{
+	u32 fn = vcpu->kvm_run->hypercall.nr;
+
+	switch (ARM_SMCCC_FUNC_NUM(fn)) {
+	/* PSCI */
+	case 0x00 ... 0x1F:
+		handle_psci(vcpu, res);
+		break;
+	}
+}
+
+bool handle_hypercall(struct kvm_cpu *vcpu)
+{
+	u32 fn = vcpu->kvm_run->hypercall.nr;
+	struct arm_smccc_res res = {
+		.a0	= SMCCC_RET_NOT_SUPPORTED,
+	};
+
+	if (!smccc_calling_conv_allowed(vcpu, fn))
+		goto out;
+
+	switch (ARM_SMCCC_OWNER_NUM(fn)) {
+	case ARM_SMCCC_OWNER_STANDARD:
+		handle_std_call(vcpu, &res);
+		break;
+	}
+
+out:
+	smccc_return_result(vcpu, &res);
+	return true;
+}
+
+void kvm__setup_smccc(struct kvm *kvm)
+{
+
+}
-- 
2.43.0


