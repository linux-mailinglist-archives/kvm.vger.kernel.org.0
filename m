Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90BC142BF7E
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 14:04:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233175AbhJMMGL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 08:06:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:56236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232711AbhJMMGF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Oct 2021 08:06:05 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D724610F9;
        Wed, 13 Oct 2021 12:04:02 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1maczI-00GTgY-FQ; Wed, 13 Oct 2021 13:04:00 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     will@kernel.org, james.morse@arm.com, alexandru.elisei@arm.com,
        suzuki.poulose@arm.com, mark.rutland@arm.com, pbonzini@redhat.com,
        drjones@redhat.com, oupton@google.com, qperret@google.com,
        kernel-team@android.com, tabba@google.com
Subject: [PATCH v9 19/22] KVM: arm64: pkvm: Consolidate include files
Date:   Wed, 13 Oct 2021 13:03:43 +0100
Message-Id: <20211013120346.2926621-9-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211013120346.2926621-1-maz@kernel.org>
References: <20211010145636.1950948-12-tabba@google.com>
 <20211013120346.2926621-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, will@kernel.org, james.morse@arm.com, alexandru.elisei@arm.com, suzuki.poulose@arm.com, mark.rutland@arm.com, pbonzini@redhat.com, drjones@redhat.com, oupton@google.com, qperret@google.com, kernel-team@android.com, tabba@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvm_fixed_config.h is pkvm specific, and would be better placed
near its users. At the same time, include/nvhe/sys_regs.h is now
almost empty.

Merge the two into arch/arm64/kvm/hyp/include/nvhe/fixed_config.h.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 .../hyp/include/nvhe/fixed_config.h}            |  5 +++++
 arch/arm64/kvm/hyp/include/nvhe/sys_regs.h      | 17 -----------------
 arch/arm64/kvm/hyp/nvhe/pkvm.c                  |  3 +--
 arch/arm64/kvm/hyp/nvhe/setup.c                 |  2 +-
 arch/arm64/kvm/hyp/nvhe/switch.c                |  3 +--
 arch/arm64/kvm/hyp/nvhe/sys_regs.c              |  3 +--
 6 files changed, 9 insertions(+), 24 deletions(-)
 rename arch/arm64/{include/asm/kvm_fixed_config.h => kvm/hyp/include/nvhe/fixed_config.h} (96%)
 delete mode 100644 arch/arm64/kvm/hyp/include/nvhe/sys_regs.h

diff --git a/arch/arm64/include/asm/kvm_fixed_config.h b/arch/arm64/kvm/hyp/include/nvhe/fixed_config.h
similarity index 96%
rename from arch/arm64/include/asm/kvm_fixed_config.h
rename to arch/arm64/kvm/hyp/include/nvhe/fixed_config.h
index 0ed06923f7e9..747fc79ae784 100644
--- a/arch/arm64/include/asm/kvm_fixed_config.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/fixed_config.h
@@ -192,4 +192,9 @@
 	ARM64_FEATURE_MASK(ID_AA64ISAR1_I8MM) \
 	)
 
+u64 pvm_read_id_reg(const struct kvm_vcpu *vcpu, u32 id);
+bool kvm_handle_pvm_sysreg(struct kvm_vcpu *vcpu, u64 *exit_code);
+int kvm_check_pvm_sysreg_table(void);
+void inject_undef64(struct kvm_vcpu *vcpu);
+
 #endif /* __ARM64_KVM_FIXED_CONFIG_H__ */
diff --git a/arch/arm64/kvm/hyp/include/nvhe/sys_regs.h b/arch/arm64/kvm/hyp/include/nvhe/sys_regs.h
deleted file mode 100644
index 8adc13227b1a..000000000000
--- a/arch/arm64/kvm/hyp/include/nvhe/sys_regs.h
+++ /dev/null
@@ -1,17 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-only */
-/*
- * Copyright (C) 2021 Google LLC
- * Author: Fuad Tabba <tabba@google.com>
- */
-
-#ifndef __ARM64_KVM_NVHE_SYS_REGS_H__
-#define __ARM64_KVM_NVHE_SYS_REGS_H__
-
-#include <asm/kvm_host.h>
-
-u64 pvm_read_id_reg(const struct kvm_vcpu *vcpu, u32 id);
-bool kvm_handle_pvm_sysreg(struct kvm_vcpu *vcpu, u64 *exit_code);
-int kvm_check_pvm_sysreg_table(void);
-void inject_undef64(struct kvm_vcpu *vcpu);
-
-#endif /* __ARM64_KVM_NVHE_SYS_REGS_H__ */
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 62377fa8a4cb..99c8d8b73e70 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -6,8 +6,7 @@
 
 #include <linux/kvm_host.h>
 #include <linux/mm.h>
-#include <asm/kvm_fixed_config.h>
-#include <nvhe/sys_regs.h>
+#include <nvhe/fixed_config.h>
 #include <nvhe/trap_handler.h>
 
 /*
diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index c85ff64e63f2..862c7b514e20 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -10,11 +10,11 @@
 #include <asm/kvm_pgtable.h>
 
 #include <nvhe/early_alloc.h>
+#include <nvhe/fixed_config.h>
 #include <nvhe/gfp.h>
 #include <nvhe/memory.h>
 #include <nvhe/mem_protect.h>
 #include <nvhe/mm.h>
-#include <nvhe/sys_regs.h>
 #include <nvhe/trap_handler.h>
 
 struct hyp_pool hpool;
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 481c365ef144..317dba6a018d 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -20,7 +20,6 @@
 #include <asm/kprobes.h>
 #include <asm/kvm_asm.h>
 #include <asm/kvm_emulate.h>
-#include <asm/kvm_fixed_config.h>
 #include <asm/kvm_hyp.h>
 #include <asm/kvm_mmu.h>
 #include <asm/fpsimd.h>
@@ -28,8 +27,8 @@
 #include <asm/processor.h>
 #include <asm/thread_info.h>
 
+#include <nvhe/fixed_config.h>
 #include <nvhe/mem_protect.h>
-#include <nvhe/sys_regs.h>
 
 /* Non-VHE specific context */
 DEFINE_PER_CPU(struct kvm_host_data, kvm_host_data);
diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
index a341bd8ef252..052f885e65b2 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -7,12 +7,11 @@
 #include <linux/irqchip/arm-gic-v3.h>
 
 #include <asm/kvm_asm.h>
-#include <asm/kvm_fixed_config.h>
 #include <asm/kvm_mmu.h>
 
 #include <hyp/adjust_pc.h>
 
-#include <nvhe/sys_regs.h>
+#include <nvhe/fixed_config.h>
 
 #include "../../sys_regs.h"
 
-- 
2.30.2

