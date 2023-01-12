Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D3CB667444
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 15:04:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229903AbjALOEQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 09:04:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235088AbjALODw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 09:03:52 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBE4252765
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 06:03:50 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id 17so20356892pll.0
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 06:03:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2SV/c6O/BfewyDXddCTEPHmA0T8USKv1LA/ENtVmN+U=;
        b=hDGcvz/sl0gJsNu9TRgRCXeffJ9R4lSDlC9wc9PmZbo+OkmFFhTPKkg8zDiYjI61W1
         Z8i6rE35UgSfjbvcCPF3YJQ0K+0Lac1u6DE8fqfFtMhTz0YTj6BVg28Scs24pWrV8Uj4
         IcR2PIgtI1lzgylNgZUARmEDzz1irxFVENV0WTMhe6MxYJVk0y1/hIVqyfirRD9uh51Q
         gLog21l2bPpJO1XsgwujkhGMcmLLuw3uvoHZM+oPPWFw0G2lohAXsP57n5jeytV3TRmm
         bQXN3YgvNyBU0CbgFoYiKQnKAkAPekxvUMS9qNT4vtOPFuCoOo7hW4i5e77YVTbb0Rk/
         aHyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2SV/c6O/BfewyDXddCTEPHmA0T8USKv1LA/ENtVmN+U=;
        b=hAV8ohfQEsXBx7EGtCVEHk8KXJj18GMsgEMc335C4G9fCFbCZRXsJCADebo21aeABv
         Tj/rYMLKxBvkAyYgxQelPYRDEyRzIsrfsuMQhhSjq6ZhWnxXT3dxCkuZibCSsB9WgJts
         o42K4Oi1xJCY/+ImNgXzy5tDNTctgUKghgu1Led6v5QCPHIUIWelQlNqJ7p4YPGaT+i7
         dD/9+BOujYvsLZwL2xmVO1wnPjcNHIgDhJuScfBmbgIyczTzi/3uCiBrIwK3p3pExvSh
         H8hhJWbotmB3REBq5wsOcvFymxrDNl78icC9S04L1h+J62lvsb49wmUukmZLxN3lRIA5
         xbiA==
X-Gm-Message-State: AFqh2kr73biYa6vHxfCAtpqaIB8rFzXlp+x50Z/16B5/ANf+VjUwHI4p
        zFeZEF0k7Rwz8ac0nL08TR5xLg==
X-Google-Smtp-Source: AMrXdXueuCgDH7HhPIyGtFaKN0XR/WX4KFaDUDsVQLipFM131in070443SMcpu6E2wPL2dn0Dq7kmw==
X-Received: by 2002:a17:902:d50a:b0:192:d5cf:ab7e with SMTP id b10-20020a170902d50a00b00192d5cfab7emr49527092plg.32.1673532226956;
        Thu, 12 Jan 2023 06:03:46 -0800 (PST)
Received: from anup-ubuntu-vm.localdomain ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id d11-20020a170902cecb00b001925016e34bsm12351455plg.79.2023.01.12.06.03.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jan 2023 06:03:46 -0800 (PST)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH 4/7] RISC-V: KVM: Initial skeletal support for AIA
Date:   Thu, 12 Jan 2023 19:33:01 +0530
Message-Id: <20230112140304.1830648-5-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230112140304.1830648-1-apatel@ventanamicro.com>
References: <20230112140304.1830648-1-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To incrementally implement AIA support, we first add minimal skeletal
support which only compiles and detects AIA hardware support at the
boot-time but does not provide any functionality.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 arch/riscv/include/asm/kvm_aia.h  | 109 ++++++++++++++++++++++++++++++
 arch/riscv/include/asm/kvm_host.h |   7 ++
 arch/riscv/kvm/Makefile           |   1 +
 arch/riscv/kvm/aia.c              |  66 ++++++++++++++++++
 arch/riscv/kvm/main.c             |  13 ++++
 arch/riscv/kvm/vcpu.c             |  40 ++++++++++-
 arch/riscv/kvm/vcpu_insn.c        |   4 +-
 arch/riscv/kvm/vm.c               |   4 ++
 8 files changed, 240 insertions(+), 4 deletions(-)
 create mode 100644 arch/riscv/include/asm/kvm_aia.h
 create mode 100644 arch/riscv/kvm/aia.c

diff --git a/arch/riscv/include/asm/kvm_aia.h b/arch/riscv/include/asm/kvm_aia.h
new file mode 100644
index 000000000000..52b5e8aefb30
--- /dev/null
+++ b/arch/riscv/include/asm/kvm_aia.h
@@ -0,0 +1,109 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (C) 2021 Western Digital Corporation or its affiliates.
+ * Copyright (C) 2022 Ventana Micro Systems Inc.
+ *
+ * Authors:
+ *	Anup Patel <apatel@ventanamicro.com>
+ */
+
+#ifndef __KVM_RISCV_AIA_H
+#define __KVM_RISCV_AIA_H
+
+#include <linux/jump_label.h>
+#include <linux/kvm_types.h>
+
+struct kvm_aia {
+	/* In-kernel irqchip created */
+	bool		in_kernel;
+
+	/* In-kernel irqchip initialized */
+	bool		initialized;
+};
+
+struct kvm_vcpu_aia {
+};
+
+#define kvm_riscv_aia_initialized(k)	(!!((k)->arch.aia.initialized))
+
+#define irqchip_in_kernel(k)		(!!((k)->arch.aia.in_kernel))
+
+DECLARE_STATIC_KEY_FALSE(kvm_riscv_aia_available);
+#define kvm_riscv_aia_available() \
+	static_branch_unlikely(&kvm_riscv_aia_available)
+
+static inline void kvm_riscv_vcpu_aia_flush_interrupts(struct kvm_vcpu *vcpu)
+{
+}
+
+static inline void kvm_riscv_vcpu_aia_sync_interrupts(struct kvm_vcpu *vcpu)
+{
+}
+
+static inline bool kvm_riscv_vcpu_aia_has_interrupts(struct kvm_vcpu *vcpu,
+						     u64 mask)
+{
+	return false;
+}
+
+static inline void kvm_riscv_vcpu_aia_update_hvip(struct kvm_vcpu *vcpu)
+{
+}
+
+static inline void kvm_riscv_vcpu_aia_load(struct kvm_vcpu *vcpu, int cpu)
+{
+}
+
+static inline void kvm_riscv_vcpu_aia_put(struct kvm_vcpu *vcpu)
+{
+}
+
+static inline int kvm_riscv_vcpu_aia_get_csr(struct kvm_vcpu *vcpu,
+					     unsigned long reg_num,
+					     unsigned long *out_val)
+{
+	*out_val = 0;
+	return 0;
+}
+
+static inline int kvm_riscv_vcpu_aia_set_csr(struct kvm_vcpu *vcpu,
+					     unsigned long reg_num,
+					     unsigned long val)
+{
+	return 0;
+}
+
+#define KVM_RISCV_VCPU_AIA_CSR_FUNCS
+
+static inline int kvm_riscv_vcpu_aia_update(struct kvm_vcpu *vcpu)
+{
+	return 1;
+}
+
+static inline void kvm_riscv_vcpu_aia_reset(struct kvm_vcpu *vcpu)
+{
+}
+
+static inline int kvm_riscv_vcpu_aia_init(struct kvm_vcpu *vcpu)
+{
+	return 0;
+}
+
+static inline void kvm_riscv_vcpu_aia_deinit(struct kvm_vcpu *vcpu)
+{
+}
+
+static inline void kvm_riscv_aia_init_vm(struct kvm *kvm)
+{
+}
+
+static inline void kvm_riscv_aia_destroy_vm(struct kvm *kvm)
+{
+}
+
+void kvm_riscv_aia_enable(void);
+void kvm_riscv_aia_disable(void);
+int kvm_riscv_aia_init(void);
+void kvm_riscv_aia_exit(void);
+
+#endif
diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index 93f43a3e7886..b71f0e639b39 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -14,6 +14,7 @@
 #include <linux/kvm_types.h>
 #include <linux/spinlock.h>
 #include <asm/hwcap.h>
+#include <asm/kvm_aia.h>
 #include <asm/kvm_vcpu_fp.h>
 #include <asm/kvm_vcpu_insn.h>
 #include <asm/kvm_vcpu_sbi.h>
@@ -93,6 +94,9 @@ struct kvm_arch {
 
 	/* Guest Timer */
 	struct kvm_guest_timer timer;
+
+	/* AIA Guest/VM context */
+	struct kvm_aia aia;
 };
 
 struct kvm_cpu_trap {
@@ -220,6 +224,9 @@ struct kvm_vcpu_arch {
 	/* SBI context */
 	struct kvm_vcpu_sbi_context sbi_context;
 
+	/* AIA VCPU context */
+	struct kvm_vcpu_aia aia;
+
 	/* Cache pages needed to program page tables with spinlock held */
 	struct kvm_mmu_memory_cache mmu_page_cache;
 
diff --git a/arch/riscv/kvm/Makefile b/arch/riscv/kvm/Makefile
index 019df9208bdd..adbc85a94364 100644
--- a/arch/riscv/kvm/Makefile
+++ b/arch/riscv/kvm/Makefile
@@ -25,3 +25,4 @@ kvm-y += vcpu_sbi_base.o
 kvm-y += vcpu_sbi_replace.o
 kvm-y += vcpu_sbi_hsm.o
 kvm-y += vcpu_timer.o
+kvm-y += aia.o
diff --git a/arch/riscv/kvm/aia.c b/arch/riscv/kvm/aia.c
new file mode 100644
index 000000000000..e7fa4e014d08
--- /dev/null
+++ b/arch/riscv/kvm/aia.c
@@ -0,0 +1,66 @@
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
+#include <asm/hwcap.h>
+
+DEFINE_STATIC_KEY_FALSE(kvm_riscv_aia_available);
+
+static inline void aia_set_hvictl(bool ext_irq_pending)
+{
+	unsigned long hvictl;
+
+	/*
+	 * HVICTL.IID == 9 and HVICTL.IPRIO == 0 represents
+	 * no interrupt in HVICTL.
+	 */
+
+	hvictl = (IRQ_S_EXT << HVICTL_IID_SHIFT) & HVICTL_IID;
+	hvictl |= (ext_irq_pending) ? 1 : 0;
+	csr_write(CSR_HVICTL, hvictl);
+}
+
+void kvm_riscv_aia_enable(void)
+{
+	if (!kvm_riscv_aia_available())
+		return;
+
+	aia_set_hvictl(false);
+	csr_write(CSR_HVIPRIO1, 0x0);
+	csr_write(CSR_HVIPRIO2, 0x0);
+#ifdef CONFIG_32BIT
+	csr_write(CSR_HVIPH, 0x0);
+	csr_write(CSR_HIDELEGH, 0x0);
+	csr_write(CSR_HVIPRIO1H, 0x0);
+	csr_write(CSR_HVIPRIO2H, 0x0);
+#endif
+}
+
+void kvm_riscv_aia_disable(void)
+{
+	if (!kvm_riscv_aia_available())
+		return;
+
+	aia_set_hvictl(false);
+}
+
+int kvm_riscv_aia_init(void)
+{
+	if (!riscv_isa_extension_available(NULL, SxAIA))
+		return -ENODEV;
+
+	/* Enable KVM AIA support */
+	static_branch_enable(&kvm_riscv_aia_available);
+
+	return 0;
+}
+
+void kvm_riscv_aia_exit(void)
+{
+}
diff --git a/arch/riscv/kvm/main.c b/arch/riscv/kvm/main.c
index 58c5489d3031..d8ff44eb04ca 100644
--- a/arch/riscv/kvm/main.c
+++ b/arch/riscv/kvm/main.c
@@ -53,11 +53,15 @@ int kvm_arch_hardware_enable(void)
 
 	csr_write(CSR_HVIP, 0);
 
+	kvm_riscv_aia_enable();
+
 	return 0;
 }
 
 void kvm_arch_hardware_disable(void)
 {
+	kvm_riscv_aia_disable();
+
 	/*
 	 * After clearing the hideleg CSR, the host kernel will receive
 	 * spurious interrupts if hvip CSR has pending interrupts and the
@@ -72,6 +76,7 @@ void kvm_arch_hardware_disable(void)
 
 int kvm_arch_init(void *opaque)
 {
+	int rc;
 	const char *str;
 
 	if (!riscv_isa_extension_available(NULL, h)) {
@@ -93,6 +98,10 @@ int kvm_arch_init(void *opaque)
 
 	kvm_riscv_gstage_vmid_detect();
 
+	rc = kvm_riscv_aia_init();
+	if (rc && rc != -ENODEV)
+		return rc;
+
 	kvm_info("hypervisor extension available\n");
 
 	switch (kvm_riscv_gstage_mode()) {
@@ -115,11 +124,15 @@ int kvm_arch_init(void *opaque)
 
 	kvm_info("VMID %ld bits available\n", kvm_riscv_gstage_vmid_bits());
 
+	if (kvm_riscv_aia_available())
+		kvm_info("AIA available\n");
+
 	return 0;
 }
 
 void kvm_arch_exit(void)
 {
+	kvm_riscv_aia_exit();
 }
 
 static int __init riscv_kvm_init(void)
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 2260adaf2de8..3cf50eadc8ce 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -135,6 +135,8 @@ static void kvm_riscv_reset_vcpu(struct kvm_vcpu *vcpu)
 
 	kvm_riscv_vcpu_timer_reset(vcpu);
 
+	kvm_riscv_vcpu_aia_reset(vcpu);
+
 	WRITE_ONCE(vcpu->arch.irqs_pending, 0);
 	WRITE_ONCE(vcpu->arch.irqs_pending_mask, 0);
 
@@ -155,6 +157,7 @@ int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
 
 int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 {
+	int rc;
 	struct kvm_cpu_context *cntx;
 	struct kvm_vcpu_csr *reset_csr = &vcpu->arch.guest_reset_csr;
 	unsigned long host_isa, i;
@@ -194,6 +197,11 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	/* Setup VCPU timer */
 	kvm_riscv_vcpu_timer_init(vcpu);
 
+	/* Setup VCPU AIA */
+	rc = kvm_riscv_vcpu_aia_init(vcpu);
+	if (rc)
+		return rc;
+
 	/* Reset VCPU */
 	kvm_riscv_reset_vcpu(vcpu);
 
@@ -213,6 +221,9 @@ void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
 
 void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 {
+	/* Cleanup VCPU AIA context */
+	kvm_riscv_vcpu_aia_deinit(vcpu);
+
 	/* Cleanup VCPU timer */
 	kvm_riscv_vcpu_timer_deinit(vcpu);
 
@@ -730,6 +741,9 @@ void kvm_riscv_vcpu_flush_interrupts(struct kvm_vcpu *vcpu)
 		csr->hvip &= ~mask;
 		csr->hvip |= val;
 	}
+
+	/* Flush AIA high interrupts */
+	kvm_riscv_vcpu_aia_flush_interrupts(vcpu);
 }
 
 void kvm_riscv_vcpu_sync_interrupts(struct kvm_vcpu *vcpu)
@@ -755,6 +769,9 @@ void kvm_riscv_vcpu_sync_interrupts(struct kvm_vcpu *vcpu)
 		}
 	}
 
+	/* Sync-up AIA high interrupts */
+	kvm_riscv_vcpu_aia_sync_interrupts(vcpu);
+
 	/* Sync-up timer CSRs */
 	kvm_riscv_vcpu_timer_sync(vcpu);
 }
@@ -791,10 +808,15 @@ int kvm_riscv_vcpu_unset_interrupt(struct kvm_vcpu *vcpu, unsigned int irq)
 
 bool kvm_riscv_vcpu_has_interrupts(struct kvm_vcpu *vcpu, unsigned long mask)
 {
-	unsigned long ie = ((vcpu->arch.guest_csr.vsie & VSIP_VALID_MASK)
-			    << VSIP_TO_HVIP_SHIFT) & mask;
+	unsigned long ie;
+
+	ie = ((vcpu->arch.guest_csr.vsie & VSIP_VALID_MASK)
+		<< VSIP_TO_HVIP_SHIFT) & mask;
+	if (READ_ONCE(vcpu->arch.irqs_pending) & ie)
+		return true;
 
-	return (READ_ONCE(vcpu->arch.irqs_pending) & ie) ? true : false;
+	/* Check AIA high interrupts */
+	return kvm_riscv_vcpu_aia_has_interrupts(vcpu, mask);
 }
 
 void kvm_riscv_vcpu_power_off(struct kvm_vcpu *vcpu)
@@ -890,6 +912,8 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	kvm_riscv_vcpu_guest_fp_restore(&vcpu->arch.guest_context,
 					vcpu->arch.isa);
 
+	kvm_riscv_vcpu_aia_load(vcpu, cpu);
+
 	vcpu->cpu = cpu;
 }
 
@@ -899,6 +923,8 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 
 	vcpu->cpu = -1;
 
+	kvm_riscv_vcpu_aia_put(vcpu);
+
 	kvm_riscv_vcpu_guest_fp_save(&vcpu->arch.guest_context,
 				     vcpu->arch.isa);
 	kvm_riscv_vcpu_host_fp_restore(&vcpu->arch.host_context);
@@ -966,6 +992,7 @@ static void kvm_riscv_update_hvip(struct kvm_vcpu *vcpu)
 	struct kvm_vcpu_csr *csr = &vcpu->arch.guest_csr;
 
 	csr_write(CSR_HVIP, csr->hvip);
+	kvm_riscv_vcpu_aia_update_hvip(vcpu);
 }
 
 /*
@@ -1040,6 +1067,13 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 
 		local_irq_disable();
 
+		/* Update AIA HW state before entering guest */
+		ret = kvm_riscv_vcpu_aia_update(vcpu);
+		if (ret <= 0) {
+			local_irq_enable();
+			continue;
+		}
+
 		/*
 		 * Ensure we set mode to IN_GUEST_MODE after we disable
 		 * interrupts and before the final VCPU requests check.
diff --git a/arch/riscv/kvm/vcpu_insn.c b/arch/riscv/kvm/vcpu_insn.c
index 0bb52761a3f7..07e8c121922b 100644
--- a/arch/riscv/kvm/vcpu_insn.c
+++ b/arch/riscv/kvm/vcpu_insn.c
@@ -213,7 +213,9 @@ struct csr_func {
 		    unsigned long wr_mask);
 };
 
-static const struct csr_func csr_funcs[] = { };
+static const struct csr_func csr_funcs[] = {
+	KVM_RISCV_VCPU_AIA_CSR_FUNCS
+};
 
 /**
  * kvm_riscv_vcpu_csr_return -- Handle CSR read/write after user space
diff --git a/arch/riscv/kvm/vm.c b/arch/riscv/kvm/vm.c
index 65a964d7e70d..bc03d2ddcb51 100644
--- a/arch/riscv/kvm/vm.c
+++ b/arch/riscv/kvm/vm.c
@@ -41,6 +41,8 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 		return r;
 	}
 
+	kvm_riscv_aia_init_vm(kvm);
+
 	kvm_riscv_guest_timer_init(kvm);
 
 	return 0;
@@ -49,6 +51,8 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 void kvm_arch_destroy_vm(struct kvm *kvm)
 {
 	kvm_destroy_vcpus(kvm);
+
+	kvm_riscv_aia_destroy_vm(kvm);
 }
 
 int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
-- 
2.34.1

