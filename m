Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 314B676DBC1
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 01:43:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232869AbjHBXnt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Aug 2023 19:43:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232163AbjHBXnr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Aug 2023 19:43:47 -0400
Received: from out-94.mta1.migadu.com (out-94.mta1.migadu.com [IPv6:2001:41d0:203:375::5e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 817263A80
        for <kvm@vger.kernel.org>; Wed,  2 Aug 2023 16:43:34 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1691019812;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GFoIKDXLVHPWYH6svgMWm2/NieY0BoIPmGB90g61LYg=;
        b=rgUOUeJWyZpUCYGG8J8Ai5T/NOZFtdwB8HfxmuYWt23K7tKRLu7i33iWDnljuDJeLYnqAJ
        n5NWlMnviFCbhGLM6e3HhYG1/i7vJFvokBrxSetnAwvJiU2aYPPZ6y8QkpYDGl0affZ33L
        pPv7/UPL+UTUsVdnYzhKDUt+9H2V0wM=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH kvmtool v3 10/17] aarch64: Add skeleton implementation for PSCI
Date:   Wed,  2 Aug 2023 23:42:48 +0000
Message-ID: <20230802234255.466782-11-oliver.upton@linux.dev>
In-Reply-To: <20230802234255.466782-1-oliver.upton@linux.dev>
References: <20230802234255.466782-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add an extremely barebones implementation for handling PSCI, where the
only supported call is PSCI_VERSION.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 Makefile                        |  4 +-
 arm/aarch32/kvm-cpu.c           |  5 +++
 arm/aarch64/include/asm/smccc.h | 65 +++++++++++++++++++++++++++++++++
 arm/aarch64/kvm-cpu.c           | 14 +++++++
 arm/aarch64/kvm.c               |  2 +
 arm/aarch64/psci.c              | 36 ++++++++++++++++++
 arm/aarch64/smccc.c             | 44 ++++++++++++++++++++++
 arm/kvm-cpu.c                   |  5 ---
 8 files changed, 169 insertions(+), 6 deletions(-)
 create mode 100644 arm/aarch64/include/asm/smccc.h
 create mode 100644 arm/aarch64/psci.c
 create mode 100644 arm/aarch64/smccc.c

diff --git a/Makefile b/Makefile
index e711670d081a..4b71fadd3928 100644
--- a/Makefile
+++ b/Makefile
@@ -192,8 +192,10 @@ ifeq ($(ARCH), arm64)
 	OBJS		+= arm/aarch64/arm-cpu.o
 	OBJS		+= arm/aarch64/kvm-cpu.o
 	OBJS		+= arm/aarch64/kvm.o
-	OBJS		+= arm/aarch64/pvtime.o
 	OBJS		+= arm/aarch64/pmu.o
+	OBJS		+= arm/aarch64/psci.o
+	OBJS		+= arm/aarch64/pvtime.o
+	OBJS		+= arm/aarch64/smccc.o
 	ARCH_INCLUDE	:= $(HDRS_ARM_COMMON)
 	ARCH_INCLUDE	+= -Iarm/aarch64/include
 
diff --git a/arm/aarch32/kvm-cpu.c b/arm/aarch32/kvm-cpu.c
index 95fb1da5ba3d..1063b9e5b6a9 100644
--- a/arm/aarch32/kvm-cpu.c
+++ b/arm/aarch32/kvm-cpu.c
@@ -130,3 +130,8 @@ void kvm_cpu__show_registers(struct kvm_cpu *vcpu)
 		die("KVM_GET_ONE_REG failed (LR_svc)");
 	dprintf(debug_fd, " LR_svc:  0x%x\n", data);
 }
+
+bool kvm_cpu__handle_exit(struct kvm_cpu *vcpu)
+{
+	return false;
+}
diff --git a/arm/aarch64/include/asm/smccc.h b/arm/aarch64/include/asm/smccc.h
new file mode 100644
index 000000000000..c1be21a7d6f6
--- /dev/null
+++ b/arm/aarch64/include/asm/smccc.h
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
diff --git a/arm/aarch64/kvm-cpu.c b/arm/aarch64/kvm-cpu.c
index 1e5a6cfdaf40..4feed9f41cb0 100644
--- a/arm/aarch64/kvm-cpu.c
+++ b/arm/aarch64/kvm-cpu.c
@@ -1,3 +1,4 @@
+#include "asm/smccc.h"
 #include "kvm/kvm-cpu.h"
 #include "kvm/kvm.h"
 #include "kvm/virtio.h"
@@ -261,3 +262,16 @@ void kvm_cpu__show_registers(struct kvm_cpu *vcpu)
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
diff --git a/arm/aarch64/kvm.c b/arm/aarch64/kvm.c
index 4929ce48843b..ce917ed01349 100644
--- a/arm/aarch64/kvm.c
+++ b/arm/aarch64/kvm.c
@@ -1,3 +1,4 @@
+#include "asm/smccc.h"
 #include "kvm/kvm.h"
 #include "kvm/kvm-cpu.h"
 
@@ -165,6 +166,7 @@ static void kvm__arch_enable_mte(struct kvm *kvm)
 void __kvm__arm_init(struct kvm *kvm)
 {
 	kvm__arch_enable_mte(kvm);
+	kvm__setup_smccc(kvm);
 }
 
 struct kvm_cpu *kvm__arch_mpidr_to_vcpu(struct kvm *kvm, u64 target_mpidr)
diff --git a/arm/aarch64/psci.c b/arm/aarch64/psci.c
new file mode 100644
index 000000000000..482b9a7442c6
--- /dev/null
+++ b/arm/aarch64/psci.c
@@ -0,0 +1,36 @@
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
+	case ARM_SMCCC_VERSION_FUNC_ID:
+		res->a0 = PSCI_RET_SUCCESS;
+		break;
+	}
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
+	default:
+		res->a0 = PSCI_RET_NOT_SUPPORTED;
+	}
+}
diff --git a/arm/aarch64/smccc.c b/arm/aarch64/smccc.c
new file mode 100644
index 000000000000..ef986d8c526f
--- /dev/null
+++ b/arm/aarch64/smccc.c
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
diff --git a/arm/kvm-cpu.c b/arm/kvm-cpu.c
index 7934d7994b52..9eebfa6417e3 100644
--- a/arm/kvm-cpu.c
+++ b/arm/kvm-cpu.c
@@ -149,11 +149,6 @@ void kvm_cpu__delete(struct kvm_cpu *vcpu)
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
-- 
2.41.0.585.gd2178a4bd4-goog

