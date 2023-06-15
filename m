Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0F077310DA
	for <lists+kvm@lfdr.de>; Thu, 15 Jun 2023 09:35:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244393AbjFOHfb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jun 2023 03:35:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245158AbjFOHe6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jun 2023 03:34:58 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C7352D5F
        for <kvm@vger.kernel.org>; Thu, 15 Jun 2023 00:34:26 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id d9443c01a7336-1b50d7b4aaaso7311595ad.3
        for <kvm@vger.kernel.org>; Thu, 15 Jun 2023 00:34:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1686814466; x=1689406466;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6AICVLlusJyAivo0r9J+PXCIYSOoM2kFh2Aa6kK7Vgk=;
        b=UxrP7uaOj8C8ROn1s+Uv4Ek0LIuiM1UXQaAg55X2nypfDUarnuUYLvDhRIlBYSopY1
         1Je3cYqPVp/Fqlb0zWK86wgla2Ilwxjr/SF7SmBkM8/9SgZd3RCGXJY78qMg0O61TrjV
         HzIIcSIuuY0ZOXVt6xeokaLx7390mHFT/vfUwOq1mXvPXSXxIQud9An4nrtJhVOdVtH9
         Sex2SZ+nOblOyWHFi6vaDQREbKQ2NM/tAlvzARhnrK2t6iQaXN6cFuZqBmIti7w7K8CP
         rnAJNs/sX0LZkY1xNggp/7wYmlB2pE4orGkpmhfJNu2YfrbduJa8r0lH+CblgkYjbBeC
         RSHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686814466; x=1689406466;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6AICVLlusJyAivo0r9J+PXCIYSOoM2kFh2Aa6kK7Vgk=;
        b=Vpfev/FBAMssc2egHeCLfAgFB37bfMngWbdEZ96l8LYziFDN+6zgFxB92IGbW0OyZ3
         YgqkYcEG3D5DpWquJlgozG/sT8fdIwB0pfTd1h/tpzx2O4TWKTCHid8e2LKoW2yu636v
         axngcB0+QJ0gkStF991LD/MiyKqv+MUzqqLH0CrbaoLzok9SlJo+Zrp/pwtQqiCididy
         8GbXk4XgJLgoaJxzQJC8TaEijBStuuz8Hs5lVI8aiWZc5HNGRBz8qWkLeNXUrPEDLPB4
         Y36zZZd/xdCXYyrlCpc2M7Ynh9kiuwx9ZVKglZVkgmYZmNDsyeNeiiKR1qOMZqICWmXc
         WA8w==
X-Gm-Message-State: AC+VfDzbEgPgIQOMIB1tw6gREkj+GNumlXYInG+hAkCXprND1NajpkAf
        ce9DPrNpLm9MWAlt/87g5d71lQ==
X-Google-Smtp-Source: ACHHUZ78d/j1ItizUc10LlcAcjMcancHQIPbNl3wyu44XH5u+VFiOrXlqc3OpkvmcXoOLUiPt5WQCQ==
X-Received: by 2002:a17:902:a416:b0:1ad:edbd:8547 with SMTP id p22-20020a170902a41600b001adedbd8547mr12830881plq.15.1686814465715;
        Thu, 15 Jun 2023 00:34:25 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([106.51.83.242])
        by smtp.gmail.com with ESMTPSA id ji1-20020a170903324100b001b016313b1dsm8049855plb.86.2023.06.15.00.34.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jun 2023 00:34:25 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Andrew Jones <ajones@ventanamicro.com>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH v3 07/10] RISC-V: KVM: Add in-kernel emulation of AIA APLIC
Date:   Thu, 15 Jun 2023 13:03:50 +0530
Message-Id: <20230615073353.85435-8-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230615073353.85435-1-apatel@ventanamicro.com>
References: <20230615073353.85435-1-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There is no virtualization support in AIA APLIC so we add in-kernel
emulation of AIA APLIC which only supports MSI-mode (i.e. wired
interrupts forwarded to AIA IMSIC as MSIs).

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 arch/riscv/include/asm/kvm_aia.h |  17 +-
 arch/riscv/kvm/Makefile          |   1 +
 arch/riscv/kvm/aia_aplic.c       | 576 +++++++++++++++++++++++++++++++
 3 files changed, 580 insertions(+), 14 deletions(-)
 create mode 100644 arch/riscv/kvm/aia_aplic.c

diff --git a/arch/riscv/include/asm/kvm_aia.h b/arch/riscv/include/asm/kvm_aia.h
index a1281ebc9b92..f6bd8523395f 100644
--- a/arch/riscv/include/asm/kvm_aia.h
+++ b/arch/riscv/include/asm/kvm_aia.h
@@ -129,20 +129,9 @@ static inline void kvm_riscv_vcpu_aia_imsic_cleanup(struct kvm_vcpu *vcpu)
 {
 }
 
-static inline int kvm_riscv_aia_aplic_inject(struct kvm *kvm,
-					     u32 source, bool level)
-{
-	return 0;
-}
-
-static inline int kvm_riscv_aia_aplic_init(struct kvm *kvm)
-{
-	return 0;
-}
-
-static inline void kvm_riscv_aia_aplic_cleanup(struct kvm *kvm)
-{
-}
+int kvm_riscv_aia_aplic_inject(struct kvm *kvm, u32 source, bool level);
+int kvm_riscv_aia_aplic_init(struct kvm *kvm);
+void kvm_riscv_aia_aplic_cleanup(struct kvm *kvm);
 
 #ifdef CONFIG_32BIT
 void kvm_riscv_vcpu_aia_flush_interrupts(struct kvm_vcpu *vcpu);
diff --git a/arch/riscv/kvm/Makefile b/arch/riscv/kvm/Makefile
index dd69ebe098bd..94c43702c765 100644
--- a/arch/riscv/kvm/Makefile
+++ b/arch/riscv/kvm/Makefile
@@ -28,3 +28,4 @@ kvm-y += vcpu_timer.o
 kvm-$(CONFIG_RISCV_PMU_SBI) += vcpu_pmu.o vcpu_sbi_pmu.o
 kvm-y += aia.o
 kvm-y += aia_device.o
+kvm-y += aia_aplic.o
diff --git a/arch/riscv/kvm/aia_aplic.c b/arch/riscv/kvm/aia_aplic.c
new file mode 100644
index 000000000000..eecd8f4abe21
--- /dev/null
+++ b/arch/riscv/kvm/aia_aplic.c
@@ -0,0 +1,576 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2021 Western Digital Corporation or its affiliates.
+ * Copyright (C) 2022 Ventana Micro Systems Inc.
+ *
+ * Authors:
+ *	Anup Patel <apatel@ventanamicro.com>
+ */
+
+#include <linux/kvm_host.h>
+#include <linux/math.h>
+#include <linux/spinlock.h>
+#include <linux/swab.h>
+#include <kvm/iodev.h>
+#include <asm/kvm_aia_aplic.h>
+
+struct aplic_irq {
+	raw_spinlock_t lock;
+	u32 sourcecfg;
+	u32 state;
+#define APLIC_IRQ_STATE_PENDING		BIT(0)
+#define APLIC_IRQ_STATE_ENABLED		BIT(1)
+#define APLIC_IRQ_STATE_ENPEND		(APLIC_IRQ_STATE_PENDING | \
+					 APLIC_IRQ_STATE_ENABLED)
+#define APLIC_IRQ_STATE_INPUT		BIT(8)
+	u32 target;
+};
+
+struct aplic {
+	struct kvm_io_device iodev;
+
+	u32 domaincfg;
+	u32 genmsi;
+
+	u32 nr_irqs;
+	u32 nr_words;
+	struct aplic_irq *irqs;
+};
+
+static u32 aplic_read_sourcecfg(struct aplic *aplic, u32 irq)
+{
+	u32 ret;
+	unsigned long flags;
+	struct aplic_irq *irqd;
+
+	if (!irq || aplic->nr_irqs <= irq)
+		return 0;
+	irqd = &aplic->irqs[irq];
+
+	raw_spin_lock_irqsave(&irqd->lock, flags);
+	ret = irqd->sourcecfg;
+	raw_spin_unlock_irqrestore(&irqd->lock, flags);
+
+	return ret;
+}
+
+static void aplic_write_sourcecfg(struct aplic *aplic, u32 irq, u32 val)
+{
+	unsigned long flags;
+	struct aplic_irq *irqd;
+
+	if (!irq || aplic->nr_irqs <= irq)
+		return;
+	irqd = &aplic->irqs[irq];
+
+	if (val & APLIC_SOURCECFG_D)
+		val = 0;
+	else
+		val &= APLIC_SOURCECFG_SM_MASK;
+
+	raw_spin_lock_irqsave(&irqd->lock, flags);
+	irqd->sourcecfg = val;
+	raw_spin_unlock_irqrestore(&irqd->lock, flags);
+}
+
+static u32 aplic_read_target(struct aplic *aplic, u32 irq)
+{
+	u32 ret;
+	unsigned long flags;
+	struct aplic_irq *irqd;
+
+	if (!irq || aplic->nr_irqs <= irq)
+		return 0;
+	irqd = &aplic->irqs[irq];
+
+	raw_spin_lock_irqsave(&irqd->lock, flags);
+	ret = irqd->target;
+	raw_spin_unlock_irqrestore(&irqd->lock, flags);
+
+	return ret;
+}
+
+static void aplic_write_target(struct aplic *aplic, u32 irq, u32 val)
+{
+	unsigned long flags;
+	struct aplic_irq *irqd;
+
+	if (!irq || aplic->nr_irqs <= irq)
+		return;
+	irqd = &aplic->irqs[irq];
+
+	val &= APLIC_TARGET_EIID_MASK |
+	       (APLIC_TARGET_HART_IDX_MASK << APLIC_TARGET_HART_IDX_SHIFT) |
+	       (APLIC_TARGET_GUEST_IDX_MASK << APLIC_TARGET_GUEST_IDX_SHIFT);
+
+	raw_spin_lock_irqsave(&irqd->lock, flags);
+	irqd->target = val;
+	raw_spin_unlock_irqrestore(&irqd->lock, flags);
+}
+
+static bool aplic_read_pending(struct aplic *aplic, u32 irq)
+{
+	bool ret;
+	unsigned long flags;
+	struct aplic_irq *irqd;
+
+	if (!irq || aplic->nr_irqs <= irq)
+		return false;
+	irqd = &aplic->irqs[irq];
+
+	raw_spin_lock_irqsave(&irqd->lock, flags);
+	ret = (irqd->state & APLIC_IRQ_STATE_PENDING) ? true : false;
+	raw_spin_unlock_irqrestore(&irqd->lock, flags);
+
+	return ret;
+}
+
+static void aplic_write_pending(struct aplic *aplic, u32 irq, bool pending)
+{
+	unsigned long flags, sm;
+	struct aplic_irq *irqd;
+
+	if (!irq || aplic->nr_irqs <= irq)
+		return;
+	irqd = &aplic->irqs[irq];
+
+	raw_spin_lock_irqsave(&irqd->lock, flags);
+
+	sm = irqd->sourcecfg & APLIC_SOURCECFG_SM_MASK;
+	if (!pending &&
+	    ((sm == APLIC_SOURCECFG_SM_LEVEL_HIGH) ||
+	     (sm == APLIC_SOURCECFG_SM_LEVEL_LOW)))
+		goto skip_write_pending;
+
+	if (pending)
+		irqd->state |= APLIC_IRQ_STATE_PENDING;
+	else
+		irqd->state &= ~APLIC_IRQ_STATE_PENDING;
+
+skip_write_pending:
+	raw_spin_unlock_irqrestore(&irqd->lock, flags);
+}
+
+static bool aplic_read_enabled(struct aplic *aplic, u32 irq)
+{
+	bool ret;
+	unsigned long flags;
+	struct aplic_irq *irqd;
+
+	if (!irq || aplic->nr_irqs <= irq)
+		return false;
+	irqd = &aplic->irqs[irq];
+
+	raw_spin_lock_irqsave(&irqd->lock, flags);
+	ret = (irqd->state & APLIC_IRQ_STATE_ENABLED) ? true : false;
+	raw_spin_unlock_irqrestore(&irqd->lock, flags);
+
+	return ret;
+}
+
+static void aplic_write_enabled(struct aplic *aplic, u32 irq, bool enabled)
+{
+	unsigned long flags;
+	struct aplic_irq *irqd;
+
+	if (!irq || aplic->nr_irqs <= irq)
+		return;
+	irqd = &aplic->irqs[irq];
+
+	raw_spin_lock_irqsave(&irqd->lock, flags);
+	if (enabled)
+		irqd->state |= APLIC_IRQ_STATE_ENABLED;
+	else
+		irqd->state &= ~APLIC_IRQ_STATE_ENABLED;
+	raw_spin_unlock_irqrestore(&irqd->lock, flags);
+}
+
+static bool aplic_read_input(struct aplic *aplic, u32 irq)
+{
+	bool ret;
+	unsigned long flags;
+	struct aplic_irq *irqd;
+
+	if (!irq || aplic->nr_irqs <= irq)
+		return false;
+	irqd = &aplic->irqs[irq];
+
+	raw_spin_lock_irqsave(&irqd->lock, flags);
+	ret = (irqd->state & APLIC_IRQ_STATE_INPUT) ? true : false;
+	raw_spin_unlock_irqrestore(&irqd->lock, flags);
+
+	return ret;
+}
+
+static void aplic_inject_msi(struct kvm *kvm, u32 irq, u32 target)
+{
+	u32 hart_idx, guest_idx, eiid;
+
+	hart_idx = target >> APLIC_TARGET_HART_IDX_SHIFT;
+	hart_idx &= APLIC_TARGET_HART_IDX_MASK;
+	guest_idx = target >> APLIC_TARGET_GUEST_IDX_SHIFT;
+	guest_idx &= APLIC_TARGET_GUEST_IDX_MASK;
+	eiid = target & APLIC_TARGET_EIID_MASK;
+	kvm_riscv_aia_inject_msi_by_id(kvm, hart_idx, guest_idx, eiid);
+}
+
+static void aplic_update_irq_range(struct kvm *kvm, u32 first, u32 last)
+{
+	bool inject;
+	u32 irq, target;
+	unsigned long flags;
+	struct aplic_irq *irqd;
+	struct aplic *aplic = kvm->arch.aia.aplic_state;
+
+	if (!(aplic->domaincfg & APLIC_DOMAINCFG_IE))
+		return;
+
+	for (irq = first; irq <= last; irq++) {
+		if (!irq || aplic->nr_irqs <= irq)
+			continue;
+		irqd = &aplic->irqs[irq];
+
+		raw_spin_lock_irqsave(&irqd->lock, flags);
+
+		inject = false;
+		target = irqd->target;
+		if ((irqd->state & APLIC_IRQ_STATE_ENPEND) ==
+		    APLIC_IRQ_STATE_ENPEND) {
+			irqd->state &= ~APLIC_IRQ_STATE_PENDING;
+			inject = true;
+		}
+
+		raw_spin_unlock_irqrestore(&irqd->lock, flags);
+
+		if (inject)
+			aplic_inject_msi(kvm, irq, target);
+	}
+}
+
+int kvm_riscv_aia_aplic_inject(struct kvm *kvm, u32 source, bool level)
+{
+	u32 target;
+	bool inject = false, ie;
+	unsigned long flags;
+	struct aplic_irq *irqd;
+	struct aplic *aplic = kvm->arch.aia.aplic_state;
+
+	if (!aplic || !source || (aplic->nr_irqs <= source))
+		return -ENODEV;
+	irqd = &aplic->irqs[source];
+	ie = (aplic->domaincfg & APLIC_DOMAINCFG_IE) ? true : false;
+
+	raw_spin_lock_irqsave(&irqd->lock, flags);
+
+	if (irqd->sourcecfg & APLIC_SOURCECFG_D)
+		goto skip_unlock;
+
+	switch (irqd->sourcecfg & APLIC_SOURCECFG_SM_MASK) {
+	case APLIC_SOURCECFG_SM_EDGE_RISE:
+		if (level && !(irqd->state & APLIC_IRQ_STATE_INPUT) &&
+		    !(irqd->state & APLIC_IRQ_STATE_PENDING))
+			irqd->state |= APLIC_IRQ_STATE_PENDING;
+		break;
+	case APLIC_SOURCECFG_SM_EDGE_FALL:
+		if (!level && (irqd->state & APLIC_IRQ_STATE_INPUT) &&
+		    !(irqd->state & APLIC_IRQ_STATE_PENDING))
+			irqd->state |= APLIC_IRQ_STATE_PENDING;
+		break;
+	case APLIC_SOURCECFG_SM_LEVEL_HIGH:
+		if (level && !(irqd->state & APLIC_IRQ_STATE_PENDING))
+			irqd->state |= APLIC_IRQ_STATE_PENDING;
+		break;
+	case APLIC_SOURCECFG_SM_LEVEL_LOW:
+		if (!level && !(irqd->state & APLIC_IRQ_STATE_PENDING))
+			irqd->state |= APLIC_IRQ_STATE_PENDING;
+		break;
+	}
+
+	if (level)
+		irqd->state |= APLIC_IRQ_STATE_INPUT;
+	else
+		irqd->state &= ~APLIC_IRQ_STATE_INPUT;
+
+	target = irqd->target;
+	if (ie && ((irqd->state & APLIC_IRQ_STATE_ENPEND) ==
+		   APLIC_IRQ_STATE_ENPEND)) {
+		irqd->state &= ~APLIC_IRQ_STATE_PENDING;
+		inject = true;
+	}
+
+skip_unlock:
+	raw_spin_unlock_irqrestore(&irqd->lock, flags);
+
+	if (inject)
+		aplic_inject_msi(kvm, source, target);
+
+	return 0;
+}
+
+static u32 aplic_read_input_word(struct aplic *aplic, u32 word)
+{
+	u32 i, ret = 0;
+
+	for (i = 0; i < 32; i++)
+		ret |= aplic_read_input(aplic, word * 32 + i) ? BIT(i) : 0;
+
+	return ret;
+}
+
+static u32 aplic_read_pending_word(struct aplic *aplic, u32 word)
+{
+	u32 i, ret = 0;
+
+	for (i = 0; i < 32; i++)
+		ret |= aplic_read_pending(aplic, word * 32 + i) ? BIT(i) : 0;
+
+	return ret;
+}
+
+static void aplic_write_pending_word(struct aplic *aplic, u32 word,
+				     u32 val, bool pending)
+{
+	u32 i;
+
+	for (i = 0; i < 32; i++) {
+		if (val & BIT(i))
+			aplic_write_pending(aplic, word * 32 + i, pending);
+	}
+}
+
+static u32 aplic_read_enabled_word(struct aplic *aplic, u32 word)
+{
+	u32 i, ret = 0;
+
+	for (i = 0; i < 32; i++)
+		ret |= aplic_read_enabled(aplic, word * 32 + i) ? BIT(i) : 0;
+
+	return ret;
+}
+
+static void aplic_write_enabled_word(struct aplic *aplic, u32 word,
+				     u32 val, bool enabled)
+{
+	u32 i;
+
+	for (i = 0; i < 32; i++) {
+		if (val & BIT(i))
+			aplic_write_enabled(aplic, word * 32 + i, enabled);
+	}
+}
+
+static int aplic_mmio_read_offset(struct kvm *kvm, gpa_t off, u32 *val32)
+{
+	u32 i;
+	struct aplic *aplic = kvm->arch.aia.aplic_state;
+
+	if ((off & 0x3) != 0)
+		return -EOPNOTSUPP;
+
+	if (off == APLIC_DOMAINCFG) {
+		*val32 = APLIC_DOMAINCFG_RDONLY |
+			 aplic->domaincfg | APLIC_DOMAINCFG_DM;
+	} else if ((off >= APLIC_SOURCECFG_BASE) &&
+		 (off < (APLIC_SOURCECFG_BASE + (aplic->nr_irqs - 1) * 4))) {
+		i = ((off - APLIC_SOURCECFG_BASE) >> 2) + 1;
+		*val32 = aplic_read_sourcecfg(aplic, i);
+	} else if ((off >= APLIC_SETIP_BASE) &&
+		   (off < (APLIC_SETIP_BASE + aplic->nr_words * 4))) {
+		i = (off - APLIC_SETIP_BASE) >> 2;
+		*val32 = aplic_read_pending_word(aplic, i);
+	} else if (off == APLIC_SETIPNUM) {
+		*val32 = 0;
+	} else if ((off >= APLIC_CLRIP_BASE) &&
+		   (off < (APLIC_CLRIP_BASE + aplic->nr_words * 4))) {
+		i = (off - APLIC_CLRIP_BASE) >> 2;
+		*val32 = aplic_read_input_word(aplic, i);
+	} else if (off == APLIC_CLRIPNUM) {
+		*val32 = 0;
+	} else if ((off >= APLIC_SETIE_BASE) &&
+		   (off < (APLIC_SETIE_BASE + aplic->nr_words * 4))) {
+		i = (off - APLIC_SETIE_BASE) >> 2;
+		*val32 = aplic_read_enabled_word(aplic, i);
+	} else if (off == APLIC_SETIENUM) {
+		*val32 = 0;
+	} else if ((off >= APLIC_CLRIE_BASE) &&
+		   (off < (APLIC_CLRIE_BASE + aplic->nr_words * 4))) {
+		*val32 = 0;
+	} else if (off == APLIC_CLRIENUM) {
+		*val32 = 0;
+	} else if (off == APLIC_SETIPNUM_LE) {
+		*val32 = 0;
+	} else if (off == APLIC_SETIPNUM_BE) {
+		*val32 = 0;
+	} else if (off == APLIC_GENMSI) {
+		*val32 = aplic->genmsi;
+	} else if ((off >= APLIC_TARGET_BASE) &&
+		   (off < (APLIC_TARGET_BASE + (aplic->nr_irqs - 1) * 4))) {
+		i = ((off - APLIC_TARGET_BASE) >> 2) + 1;
+		*val32 = aplic_read_target(aplic, i);
+	} else
+		return -ENODEV;
+
+	return 0;
+}
+
+static int aplic_mmio_read(struct kvm_vcpu *vcpu, struct kvm_io_device *dev,
+			   gpa_t addr, int len, void *val)
+{
+	if (len != 4)
+		return -EOPNOTSUPP;
+
+	return aplic_mmio_read_offset(vcpu->kvm,
+				      addr - vcpu->kvm->arch.aia.aplic_addr,
+				      val);
+}
+
+static int aplic_mmio_write_offset(struct kvm *kvm, gpa_t off, u32 val32)
+{
+	u32 i;
+	struct aplic *aplic = kvm->arch.aia.aplic_state;
+
+	if ((off & 0x3) != 0)
+		return -EOPNOTSUPP;
+
+	if (off == APLIC_DOMAINCFG) {
+		/* Only IE bit writeable */
+		aplic->domaincfg = val32 & APLIC_DOMAINCFG_IE;
+	} else if ((off >= APLIC_SOURCECFG_BASE) &&
+		 (off < (APLIC_SOURCECFG_BASE + (aplic->nr_irqs - 1) * 4))) {
+		i = ((off - APLIC_SOURCECFG_BASE) >> 2) + 1;
+		aplic_write_sourcecfg(aplic, i, val32);
+	} else if ((off >= APLIC_SETIP_BASE) &&
+		   (off < (APLIC_SETIP_BASE + aplic->nr_words * 4))) {
+		i = (off - APLIC_SETIP_BASE) >> 2;
+		aplic_write_pending_word(aplic, i, val32, true);
+	} else if (off == APLIC_SETIPNUM) {
+		aplic_write_pending(aplic, val32, true);
+	} else if ((off >= APLIC_CLRIP_BASE) &&
+		   (off < (APLIC_CLRIP_BASE + aplic->nr_words * 4))) {
+		i = (off - APLIC_CLRIP_BASE) >> 2;
+		aplic_write_pending_word(aplic, i, val32, false);
+	} else if (off == APLIC_CLRIPNUM) {
+		aplic_write_pending(aplic, val32, false);
+	} else if ((off >= APLIC_SETIE_BASE) &&
+		   (off < (APLIC_SETIE_BASE + aplic->nr_words * 4))) {
+		i = (off - APLIC_SETIE_BASE) >> 2;
+		aplic_write_enabled_word(aplic, i, val32, true);
+	} else if (off == APLIC_SETIENUM) {
+		aplic_write_enabled(aplic, val32, true);
+	} else if ((off >= APLIC_CLRIE_BASE) &&
+		   (off < (APLIC_CLRIE_BASE + aplic->nr_words * 4))) {
+		i = (off - APLIC_CLRIE_BASE) >> 2;
+		aplic_write_enabled_word(aplic, i, val32, false);
+	} else if (off == APLIC_CLRIENUM) {
+		aplic_write_enabled(aplic, val32, false);
+	} else if (off == APLIC_SETIPNUM_LE) {
+		aplic_write_pending(aplic, val32, true);
+	} else if (off == APLIC_SETIPNUM_BE) {
+		aplic_write_pending(aplic, __swab32(val32), true);
+	} else if (off == APLIC_GENMSI) {
+		aplic->genmsi = val32 & ~(APLIC_TARGET_GUEST_IDX_MASK <<
+					  APLIC_TARGET_GUEST_IDX_SHIFT);
+		kvm_riscv_aia_inject_msi_by_id(kvm,
+				val32 >> APLIC_TARGET_HART_IDX_SHIFT, 0,
+				val32 & APLIC_TARGET_EIID_MASK);
+	} else if ((off >= APLIC_TARGET_BASE) &&
+		   (off < (APLIC_TARGET_BASE + (aplic->nr_irqs - 1) * 4))) {
+		i = ((off - APLIC_TARGET_BASE) >> 2) + 1;
+		aplic_write_target(aplic, i, val32);
+	} else
+		return -ENODEV;
+
+	aplic_update_irq_range(kvm, 1, aplic->nr_irqs - 1);
+
+	return 0;
+}
+
+static int aplic_mmio_write(struct kvm_vcpu *vcpu, struct kvm_io_device *dev,
+			    gpa_t addr, int len, const void *val)
+{
+	if (len != 4)
+		return -EOPNOTSUPP;
+
+	return aplic_mmio_write_offset(vcpu->kvm,
+				       addr - vcpu->kvm->arch.aia.aplic_addr,
+				       *((const u32 *)val));
+}
+
+static struct kvm_io_device_ops aplic_iodoev_ops = {
+	.read = aplic_mmio_read,
+	.write = aplic_mmio_write,
+};
+
+int kvm_riscv_aia_aplic_init(struct kvm *kvm)
+{
+	int i, ret = 0;
+	struct aplic *aplic;
+
+	/* Do nothing if we have zero sources */
+	if (!kvm->arch.aia.nr_sources)
+		return 0;
+
+	/* Allocate APLIC global state */
+	aplic = kzalloc(sizeof(*aplic), GFP_KERNEL);
+	if (!aplic)
+		return -ENOMEM;
+	kvm->arch.aia.aplic_state = aplic;
+
+	/* Setup APLIC IRQs */
+	aplic->nr_irqs = kvm->arch.aia.nr_sources + 1;
+	aplic->nr_words = DIV_ROUND_UP(aplic->nr_irqs, 32);
+	aplic->irqs = kcalloc(aplic->nr_irqs,
+			      sizeof(*aplic->irqs), GFP_KERNEL);
+	if (!aplic->irqs) {
+		ret = -ENOMEM;
+		goto fail_free_aplic;
+	}
+	for (i = 0; i < aplic->nr_irqs; i++)
+		raw_spin_lock_init(&aplic->irqs[i].lock);
+
+	/* Setup IO device */
+	kvm_iodevice_init(&aplic->iodev, &aplic_iodoev_ops);
+	mutex_lock(&kvm->slots_lock);
+	ret = kvm_io_bus_register_dev(kvm, KVM_MMIO_BUS,
+				      kvm->arch.aia.aplic_addr,
+				      KVM_DEV_RISCV_APLIC_SIZE,
+				      &aplic->iodev);
+	mutex_unlock(&kvm->slots_lock);
+	if (ret)
+		goto fail_free_aplic_irqs;
+
+	/* Setup default IRQ routing */
+	ret = kvm_riscv_setup_default_irq_routing(kvm, aplic->nr_irqs);
+	if (ret)
+		goto fail_unreg_iodev;
+
+	return 0;
+
+fail_unreg_iodev:
+	mutex_lock(&kvm->slots_lock);
+	kvm_io_bus_unregister_dev(kvm, KVM_MMIO_BUS, &aplic->iodev);
+	mutex_unlock(&kvm->slots_lock);
+fail_free_aplic_irqs:
+	kfree(aplic->irqs);
+fail_free_aplic:
+	kvm->arch.aia.aplic_state = NULL;
+	kfree(aplic);
+	return ret;
+}
+
+void kvm_riscv_aia_aplic_cleanup(struct kvm *kvm)
+{
+	struct aplic *aplic = kvm->arch.aia.aplic_state;
+
+	if (!aplic)
+		return;
+
+	mutex_lock(&kvm->slots_lock);
+	kvm_io_bus_unregister_dev(kvm, KVM_MMIO_BUS, &aplic->iodev);
+	mutex_unlock(&kvm->slots_lock);
+
+	kfree(aplic->irqs);
+
+	kvm->arch.aia.aplic_state = NULL;
+	kfree(aplic);
+}
-- 
2.34.1

