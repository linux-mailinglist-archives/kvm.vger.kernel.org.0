Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FA632A33DA
	for <lists+kvm@lfdr.de>; Mon,  2 Nov 2020 20:16:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726625AbgKBTQ0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Nov 2020 14:16:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:60364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725824AbgKBTQT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Nov 2020 14:16:19 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 51900223FB;
        Mon,  2 Nov 2020 19:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604344578;
        bh=C4GctCoQeP0UtgS9icsWKNG04r7fIKZ7Rd5moRwXfkI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=07vQGTmM/Yfvg+MJtrk/bz29xMyZBYg4qoMIU60b2Mg1QH4V94y7gVWCqjLu8bJhe
         zz2p0wfLXUdkwzo5ZMg0TFUzAo7nDnE6Gm9b+MnErFbfCAjoETYVhlO9Dy7e/AnSAW
         d/QYpZ/jiinJ3d4JEfLlWU3V9ZSaqilJ4gRFNECQ=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1kZfJQ-006nxn-Il; Mon, 02 Nov 2020 19:16:16 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com
Subject: [PATCH 8/8] KVM: arm64: Drop kvm_coproc.h
Date:   Mon,  2 Nov 2020 19:16:09 +0000
Message-Id: <20201102191609.265711-9-maz@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201102191609.265711-1-maz@kernel.org>
References: <20201102191609.265711-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvm_coproc.h used to serve as a compatibility layer for the files
shared between the 32 and 64 bit ports.

Another one bites the dust...

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_coproc.h | 38 -----------------------------
 arch/arm64/include/asm/kvm_host.h   | 17 +++++++++++++
 arch/arm64/kvm/arm.c                |  3 +--
 arch/arm64/kvm/guest.c              |  1 -
 arch/arm64/kvm/handle_exit.c        |  1 -
 arch/arm64/kvm/reset.c              |  1 -
 arch/arm64/kvm/sys_regs.c           |  1 -
 7 files changed, 18 insertions(+), 44 deletions(-)
 delete mode 100644 arch/arm64/include/asm/kvm_coproc.h

diff --git a/arch/arm64/include/asm/kvm_coproc.h b/arch/arm64/include/asm/kvm_coproc.h
deleted file mode 100644
index d6bb40122fdb..000000000000
--- a/arch/arm64/include/asm/kvm_coproc.h
+++ /dev/null
@@ -1,38 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-only */
-/*
- * Copyright (C) 2012,2013 - ARM Ltd
- * Author: Marc Zyngier <marc.zyngier@arm.com>
- *
- * Derived from arch/arm/include/asm/kvm_coproc.h
- * Copyright (C) 2012 Rusty Russell IBM Corporation
- */
-
-#ifndef __ARM64_KVM_COPROC_H__
-#define __ARM64_KVM_COPROC_H__
-
-#include <linux/kvm_host.h>
-
-void kvm_reset_sys_regs(struct kvm_vcpu *vcpu);
-
-struct kvm_sys_reg_table {
-	const struct sys_reg_desc *table;
-	size_t num;
-};
-
-int kvm_handle_cp14_load_store(struct kvm_vcpu *vcpu);
-int kvm_handle_cp14_32(struct kvm_vcpu *vcpu);
-int kvm_handle_cp14_64(struct kvm_vcpu *vcpu);
-int kvm_handle_cp15_32(struct kvm_vcpu *vcpu);
-int kvm_handle_cp15_64(struct kvm_vcpu *vcpu);
-int kvm_handle_sys_reg(struct kvm_vcpu *vcpu);
-
-#define kvm_coproc_table_init kvm_sys_reg_table_init
-void kvm_sys_reg_table_init(void);
-
-struct kvm_one_reg;
-int kvm_arm_copy_sys_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices);
-int kvm_arm_sys_reg_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *);
-int kvm_arm_sys_reg_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *);
-unsigned long kvm_arm_num_sys_reg_descs(struct kvm_vcpu *vcpu);
-
-#endif /* __ARM64_KVM_COPROC_H__ */
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index c527f9567713..709f892f7a14 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -533,6 +533,12 @@ unsigned long kvm_arm_num_regs(struct kvm_vcpu *vcpu);
 int kvm_arm_copy_reg_indices(struct kvm_vcpu *vcpu, u64 __user *indices);
 int kvm_arm_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg);
 int kvm_arm_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg);
+
+unsigned long kvm_arm_num_sys_reg_descs(struct kvm_vcpu *vcpu);
+int kvm_arm_copy_sys_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices);
+int kvm_arm_sys_reg_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *);
+int kvm_arm_sys_reg_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *);
+
 int __kvm_arm_vcpu_get_events(struct kvm_vcpu *vcpu,
 			      struct kvm_vcpu_events *events);
 
@@ -595,6 +601,17 @@ void kvm_mmu_wp_memory_region(struct kvm *kvm, int slot);
 int handle_exit(struct kvm_vcpu *vcpu, int exception_index);
 void handle_exit_early(struct kvm_vcpu *vcpu, int exception_index);
 
+int kvm_handle_cp14_load_store(struct kvm_vcpu *vcpu);
+int kvm_handle_cp14_32(struct kvm_vcpu *vcpu);
+int kvm_handle_cp14_64(struct kvm_vcpu *vcpu);
+int kvm_handle_cp15_32(struct kvm_vcpu *vcpu);
+int kvm_handle_cp15_64(struct kvm_vcpu *vcpu);
+int kvm_handle_sys_reg(struct kvm_vcpu *vcpu);
+
+void kvm_reset_sys_regs(struct kvm_vcpu *vcpu);
+
+void kvm_sys_reg_table_init(void);
+
 /* MMIO helpers */
 void kvm_mmio_write_buf(void *buf, unsigned int len, unsigned long data);
 unsigned long kvm_mmio_read_buf(const void *buf, unsigned int len);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 5750ec34960e..9d69d2bf6943 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -35,7 +35,6 @@
 #include <asm/kvm_asm.h>
 #include <asm/kvm_mmu.h>
 #include <asm/kvm_emulate.h>
-#include <asm/kvm_coproc.h>
 #include <asm/sections.h>
 
 #include <kvm/arm_hypercalls.h>
@@ -1525,7 +1524,7 @@ static int init_subsystems(void)
 		goto out;
 
 	kvm_perf_init();
-	kvm_coproc_table_init();
+	kvm_sys_reg_table_init();
 
 out:
 	on_each_cpu(_kvm_arch_hardware_disable, NULL, 1);
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 3f23f7478d2a..9bbd30e62799 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -24,7 +24,6 @@
 #include <asm/fpsimd.h>
 #include <asm/kvm.h>
 #include <asm/kvm_emulate.h>
-#include <asm/kvm_coproc.h>
 #include <asm/sigcontext.h>
 
 #include "trace.h"
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index f79137ee4274..cebe39f3b1b6 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -14,7 +14,6 @@
 #include <asm/esr.h>
 #include <asm/exception.h>
 #include <asm/kvm_asm.h>
-#include <asm/kvm_coproc.h>
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_mmu.h>
 #include <asm/debug-monitors.h>
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index f32490229a4c..74ce92a4988c 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -25,7 +25,6 @@
 #include <asm/ptrace.h>
 #include <asm/kvm_arm.h>
 #include <asm/kvm_asm.h>
-#include <asm/kvm_coproc.h>
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_mmu.h>
 #include <asm/virt.h>
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 2048e7e7bd7c..ed7d8d35c2d9 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -20,7 +20,6 @@
 #include <asm/debug-monitors.h>
 #include <asm/esr.h>
 #include <asm/kvm_arm.h>
-#include <asm/kvm_coproc.h>
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_hyp.h>
 #include <asm/kvm_mmu.h>
-- 
2.28.0

