Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CA61722B89
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 17:42:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235022AbjFEPme (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 11:42:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234988AbjFEPmQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 11:42:16 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9DA4E55
        for <kvm@vger.kernel.org>; Mon,  5 Jun 2023 08:41:51 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id d2e1a72fcca58-655d1fc8ad8so1025090b3a.1
        for <kvm@vger.kernel.org>; Mon, 05 Jun 2023 08:41:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1685979695; x=1688571695;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=zzVQEtVE9GUiE8tfgntIQRd4M5KNUPh8Pcnqg79C1jo=;
        b=B45UlbrxcY1ZLVhLo0myCimEAnm365MHIqBTv14hVyfrsiTXC/+dYUUCwy9dlKDah9
         8vLvVJewRJh7CPHE9+GVm27886IN/PVmCzmjuq2f5Je7Krz7OSUfAmRnFtdg6PD8QSOb
         53ttiHCl4srUefAKdKB3l71t7Ozq/Foz6OzgGAgJOD6kIT5JpVuWQkYVVq+mNYUO7UD/
         +NOAdjOW8EIsSAEKp0RQrGyuaHEaB19ldCBr6iXl0MMZpVp9X/Gm/VLQKNRzzmahzIxf
         j1d/EfCiJmJm7hqa2qYPqbyIfkmafDAYGEBuUez68v+V9uYqYXkIgx4P9ogfcCRQUMPq
         Ca0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685979695; x=1688571695;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zzVQEtVE9GUiE8tfgntIQRd4M5KNUPh8Pcnqg79C1jo=;
        b=kuint63MgxuvsciKdKFKVpBeTuBsR5NrB5AUvDPmA2wgL2B4fjpgzaB2vtyE95Dxge
         Htk0dxidZBV5/g0RQdYWyRUoy+JsYZ3MA6aq1ePUPaUMbLYt78XHTKUeSO90rWvM7qU2
         U26l6Nm1Yzfce5FjnkgL3tGAx+V94eXrRDFqq01YvtJqkznUkr6V3Vs4oo1Z/J/kJlZ6
         TnEKvNBGA6f+2JBLjXjK7/gAZJ19sLUroOrwSzJeMsjJx40jWytwPOUuOzK7x+Q/sT0K
         WolY27jVzZvGJwHI1119nC3XON/F+K4xsaRG0AikgRdQkf4qScP1yOeRwIGGwHq07p2K
         5RRg==
X-Gm-Message-State: AC+VfDxi4fsdD55MuHcA+jlQjUMWJKqILApW5SOM4HoPg9K6cSog0gm/
        4lHty/7sM0pLUDSaSlNn3kIJWg==
X-Google-Smtp-Source: ACHHUZ6GB1XumMFoVx01X4mEKj4DaHD2fYtPRoAmiRt4NzgID5YLHw4O0l/iOefeWznyOQr79AE/sQ==
X-Received: by 2002:a17:902:c94a:b0:1b1:a4b8:4f23 with SMTP id i10-20020a170902c94a00b001b1a4b84f23mr3927072pla.24.1685979695586;
        Mon, 05 Jun 2023 08:41:35 -0700 (PDT)
Received: from hsinchu26.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id jk19-20020a170903331300b001b0aec3ed59sm6725962plb.256.2023.06.05.08.41.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jun 2023 08:41:34 -0700 (PDT)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Vincent Chen <vincent.chen@sifive.com>,
        Andy Chiu <andy.chiu@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>
Subject: [PATCH -next v21 19/27] riscv: KVM: Add vector lazy save/restore support
Date:   Mon,  5 Jun 2023 11:07:16 +0000
Message-Id: <20230605110724.21391-20-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230605110724.21391-1-andy.chiu@sifive.com>
References: <20230605110724.21391-1-andy.chiu@sifive.com>
X-Spam-Status: No, score=-0.5 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Vincent Chen <vincent.chen@sifive.com>

This patch adds vector context save/restore for guest VCPUs. To reduce the
impact on KVM performance, the implementation imitates the FP context
switch mechanism to lazily store and restore the vector context only when
the kernel enters/exits the in-kernel run loop and not during the KVM
world switch.

Signed-off-by: Vincent Chen <vincent.chen@sifive.com>
Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
Reviewed-by: Anup Patel <anup@brainfault.org>
Acked-by: Anup Patel <anup@brainfault.org>
---
Changelog V19:
 - remap V extension registers as type 9 in uapi/asm/kvm.h
---
 arch/riscv/include/asm/kvm_host.h        |   2 +
 arch/riscv/include/asm/kvm_vcpu_vector.h |  82 ++++++++++
 arch/riscv/include/uapi/asm/kvm.h        |   7 +
 arch/riscv/kvm/Makefile                  |   1 +
 arch/riscv/kvm/vcpu.c                    |  22 +++
 arch/riscv/kvm/vcpu_vector.c             | 186 +++++++++++++++++++++++
 6 files changed, 300 insertions(+)
 create mode 100644 arch/riscv/include/asm/kvm_vcpu_vector.h
 create mode 100644 arch/riscv/kvm/vcpu_vector.c

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index ee0acccb1d3b..bd47a1dc2ff8 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -15,6 +15,7 @@
 #include <linux/spinlock.h>
 #include <asm/hwcap.h>
 #include <asm/kvm_aia.h>
+#include <asm/ptrace.h>
 #include <asm/kvm_vcpu_fp.h>
 #include <asm/kvm_vcpu_insn.h>
 #include <asm/kvm_vcpu_sbi.h>
@@ -145,6 +146,7 @@ struct kvm_cpu_context {
 	unsigned long sstatus;
 	unsigned long hstatus;
 	union __riscv_fp_state fp;
+	struct __riscv_v_ext_state vector;
 };
 
 struct kvm_vcpu_csr {
diff --git a/arch/riscv/include/asm/kvm_vcpu_vector.h b/arch/riscv/include/asm/kvm_vcpu_vector.h
new file mode 100644
index 000000000000..ff994fdd6d0d
--- /dev/null
+++ b/arch/riscv/include/asm/kvm_vcpu_vector.h
@@ -0,0 +1,82 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (C) 2022 SiFive
+ *
+ * Authors:
+ *     Vincent Chen <vincent.chen@sifive.com>
+ *     Greentime Hu <greentime.hu@sifive.com>
+ */
+
+#ifndef __KVM_VCPU_RISCV_VECTOR_H
+#define __KVM_VCPU_RISCV_VECTOR_H
+
+#include <linux/types.h>
+
+#ifdef CONFIG_RISCV_ISA_V
+#include <asm/vector.h>
+#include <asm/kvm_host.h>
+
+static __always_inline void __kvm_riscv_vector_save(struct kvm_cpu_context *context)
+{
+	__riscv_v_vstate_save(&context->vector, context->vector.datap);
+}
+
+static __always_inline void __kvm_riscv_vector_restore(struct kvm_cpu_context *context)
+{
+	__riscv_v_vstate_restore(&context->vector, context->vector.datap);
+}
+
+void kvm_riscv_vcpu_vector_reset(struct kvm_vcpu *vcpu);
+void kvm_riscv_vcpu_guest_vector_save(struct kvm_cpu_context *cntx,
+				      unsigned long *isa);
+void kvm_riscv_vcpu_guest_vector_restore(struct kvm_cpu_context *cntx,
+					 unsigned long *isa);
+void kvm_riscv_vcpu_host_vector_save(struct kvm_cpu_context *cntx);
+void kvm_riscv_vcpu_host_vector_restore(struct kvm_cpu_context *cntx);
+int kvm_riscv_vcpu_alloc_vector_context(struct kvm_vcpu *vcpu,
+					struct kvm_cpu_context *cntx);
+void kvm_riscv_vcpu_free_vector_context(struct kvm_vcpu *vcpu);
+#else
+
+struct kvm_cpu_context;
+
+static inline void kvm_riscv_vcpu_vector_reset(struct kvm_vcpu *vcpu)
+{
+}
+
+static inline void kvm_riscv_vcpu_guest_vector_save(struct kvm_cpu_context *cntx,
+						    unsigned long *isa)
+{
+}
+
+static inline void kvm_riscv_vcpu_guest_vector_restore(struct kvm_cpu_context *cntx,
+						       unsigned long *isa)
+{
+}
+
+static inline void kvm_riscv_vcpu_host_vector_save(struct kvm_cpu_context *cntx)
+{
+}
+
+static inline void kvm_riscv_vcpu_host_vector_restore(struct kvm_cpu_context *cntx)
+{
+}
+
+static inline int kvm_riscv_vcpu_alloc_vector_context(struct kvm_vcpu *vcpu,
+						      struct kvm_cpu_context *cntx)
+{
+	return 0;
+}
+
+static inline void kvm_riscv_vcpu_free_vector_context(struct kvm_vcpu *vcpu)
+{
+}
+#endif
+
+int kvm_riscv_vcpu_get_reg_vector(struct kvm_vcpu *vcpu,
+				  const struct kvm_one_reg *reg,
+				  unsigned long rtype);
+int kvm_riscv_vcpu_set_reg_vector(struct kvm_vcpu *vcpu,
+				  const struct kvm_one_reg *reg,
+				  unsigned long rtype);
+#endif
diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
index 8feb57c4c2e8..855c047e86d4 100644
--- a/arch/riscv/include/uapi/asm/kvm.h
+++ b/arch/riscv/include/uapi/asm/kvm.h
@@ -204,6 +204,13 @@ enum KVM_RISCV_SBI_EXT_ID {
 #define KVM_REG_RISCV_SBI_MULTI_REG_LAST	\
 		KVM_REG_RISCV_SBI_MULTI_REG(KVM_RISCV_SBI_EXT_MAX - 1)
 
+/* V extension registers are mapped as type 9 */
+#define KVM_REG_RISCV_VECTOR		(0x09 << KVM_REG_RISCV_TYPE_SHIFT)
+#define KVM_REG_RISCV_VECTOR_CSR_REG(name)	\
+		(offsetof(struct __riscv_v_ext_state, name) / sizeof(unsigned long))
+#define KVM_REG_RISCV_VECTOR_REG(n)	\
+		((n) + sizeof(struct __riscv_v_ext_state) / sizeof(unsigned long))
+
 #endif
 
 #endif /* __LINUX_KVM_RISCV_H */
diff --git a/arch/riscv/kvm/Makefile b/arch/riscv/kvm/Makefile
index 8031b8912a0d..7b4c21f9aa6a 100644
--- a/arch/riscv/kvm/Makefile
+++ b/arch/riscv/kvm/Makefile
@@ -17,6 +17,7 @@ kvm-y += mmu.o
 kvm-y += vcpu.o
 kvm-y += vcpu_exit.o
 kvm-y += vcpu_fp.o
+kvm-y += vcpu_vector.o
 kvm-y += vcpu_insn.o
 kvm-y += vcpu_switch.o
 kvm-y += vcpu_sbi.o
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index f3282ff371ca..e5e045852e6a 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -22,6 +22,8 @@
 #include <asm/cacheflush.h>
 #include <asm/hwcap.h>
 #include <asm/sbi.h>
+#include <asm/vector.h>
+#include <asm/kvm_vcpu_vector.h>
 
 const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
 	KVM_GENERIC_VCPU_STATS(),
@@ -139,6 +141,8 @@ static void kvm_riscv_reset_vcpu(struct kvm_vcpu *vcpu)
 
 	kvm_riscv_vcpu_fp_reset(vcpu);
 
+	kvm_riscv_vcpu_vector_reset(vcpu);
+
 	kvm_riscv_vcpu_timer_reset(vcpu);
 
 	kvm_riscv_vcpu_aia_reset(vcpu);
@@ -199,6 +203,9 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	cntx->hstatus |= HSTATUS_SPVP;
 	cntx->hstatus |= HSTATUS_SPV;
 
+	if (kvm_riscv_vcpu_alloc_vector_context(vcpu, cntx))
+		return -ENOMEM;
+
 	/* By default, make CY, TM, and IR counters accessible in VU mode */
 	reset_csr->scounteren = 0x7;
 
@@ -242,6 +249,9 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 
 	/* Free unused pages pre-allocated for G-stage page table mappings */
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_cache);
+
+	/* Free vector context space for host and guest kernel */
+	kvm_riscv_vcpu_free_vector_context(vcpu);
 }
 
 int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
@@ -680,6 +690,9 @@ static int kvm_riscv_vcpu_set_reg(struct kvm_vcpu *vcpu,
 		return kvm_riscv_vcpu_set_reg_isa_ext(vcpu, reg);
 	case KVM_REG_RISCV_SBI_EXT:
 		return kvm_riscv_vcpu_set_reg_sbi_ext(vcpu, reg);
+	case KVM_REG_RISCV_VECTOR:
+		return kvm_riscv_vcpu_set_reg_vector(vcpu, reg,
+						 KVM_REG_RISCV_VECTOR);
 	default:
 		break;
 	}
@@ -709,6 +722,9 @@ static int kvm_riscv_vcpu_get_reg(struct kvm_vcpu *vcpu,
 		return kvm_riscv_vcpu_get_reg_isa_ext(vcpu, reg);
 	case KVM_REG_RISCV_SBI_EXT:
 		return kvm_riscv_vcpu_get_reg_sbi_ext(vcpu, reg);
+	case KVM_REG_RISCV_VECTOR:
+		return kvm_riscv_vcpu_get_reg_vector(vcpu, reg,
+						 KVM_REG_RISCV_VECTOR);
 	default:
 		break;
 	}
@@ -1003,6 +1019,9 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	kvm_riscv_vcpu_host_fp_save(&vcpu->arch.host_context);
 	kvm_riscv_vcpu_guest_fp_restore(&vcpu->arch.guest_context,
 					vcpu->arch.isa);
+	kvm_riscv_vcpu_host_vector_save(&vcpu->arch.host_context);
+	kvm_riscv_vcpu_guest_vector_restore(&vcpu->arch.guest_context,
+					    vcpu->arch.isa);
 
 	kvm_riscv_vcpu_aia_load(vcpu, cpu);
 
@@ -1022,6 +1041,9 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 	kvm_riscv_vcpu_host_fp_restore(&vcpu->arch.host_context);
 
 	kvm_riscv_vcpu_timer_save(vcpu);
+	kvm_riscv_vcpu_guest_vector_save(&vcpu->arch.guest_context,
+					 vcpu->arch.isa);
+	kvm_riscv_vcpu_host_vector_restore(&vcpu->arch.host_context);
 
 	csr->vsstatus = csr_read(CSR_VSSTATUS);
 	csr->vsie = csr_read(CSR_VSIE);
diff --git a/arch/riscv/kvm/vcpu_vector.c b/arch/riscv/kvm/vcpu_vector.c
new file mode 100644
index 000000000000..edd2eecbddc2
--- /dev/null
+++ b/arch/riscv/kvm/vcpu_vector.c
@@ -0,0 +1,186 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2022 SiFive
+ *
+ * Authors:
+ *     Vincent Chen <vincent.chen@sifive.com>
+ *     Greentime Hu <greentime.hu@sifive.com>
+ */
+
+#include <linux/errno.h>
+#include <linux/err.h>
+#include <linux/kvm_host.h>
+#include <linux/uaccess.h>
+#include <asm/hwcap.h>
+#include <asm/kvm_vcpu_vector.h>
+#include <asm/vector.h>
+
+#ifdef CONFIG_RISCV_ISA_V
+void kvm_riscv_vcpu_vector_reset(struct kvm_vcpu *vcpu)
+{
+	unsigned long *isa = vcpu->arch.isa;
+	struct kvm_cpu_context *cntx = &vcpu->arch.guest_context;
+
+	cntx->sstatus &= ~SR_VS;
+	if (riscv_isa_extension_available(isa, v)) {
+		cntx->sstatus |= SR_VS_INITIAL;
+		WARN_ON(!cntx->vector.datap);
+		memset(cntx->vector.datap, 0, riscv_v_vsize);
+	} else {
+		cntx->sstatus |= SR_VS_OFF;
+	}
+}
+
+static void kvm_riscv_vcpu_vector_clean(struct kvm_cpu_context *cntx)
+{
+	cntx->sstatus &= ~SR_VS;
+	cntx->sstatus |= SR_VS_CLEAN;
+}
+
+void kvm_riscv_vcpu_guest_vector_save(struct kvm_cpu_context *cntx,
+				      unsigned long *isa)
+{
+	if ((cntx->sstatus & SR_VS) == SR_VS_DIRTY) {
+		if (riscv_isa_extension_available(isa, v))
+			__kvm_riscv_vector_save(cntx);
+		kvm_riscv_vcpu_vector_clean(cntx);
+	}
+}
+
+void kvm_riscv_vcpu_guest_vector_restore(struct kvm_cpu_context *cntx,
+					 unsigned long *isa)
+{
+	if ((cntx->sstatus & SR_VS) != SR_VS_OFF) {
+		if (riscv_isa_extension_available(isa, v))
+			__kvm_riscv_vector_restore(cntx);
+		kvm_riscv_vcpu_vector_clean(cntx);
+	}
+}
+
+void kvm_riscv_vcpu_host_vector_save(struct kvm_cpu_context *cntx)
+{
+	/* No need to check host sstatus as it can be modified outside */
+	if (riscv_isa_extension_available(NULL, v))
+		__kvm_riscv_vector_save(cntx);
+}
+
+void kvm_riscv_vcpu_host_vector_restore(struct kvm_cpu_context *cntx)
+{
+	if (riscv_isa_extension_available(NULL, v))
+		__kvm_riscv_vector_restore(cntx);
+}
+
+int kvm_riscv_vcpu_alloc_vector_context(struct kvm_vcpu *vcpu,
+					struct kvm_cpu_context *cntx)
+{
+	cntx->vector.datap = kmalloc(riscv_v_vsize, GFP_KERNEL);
+	if (!cntx->vector.datap)
+		return -ENOMEM;
+
+	vcpu->arch.host_context.vector.datap = kzalloc(riscv_v_vsize, GFP_KERNEL);
+	if (!vcpu->arch.host_context.vector.datap)
+		return -ENOMEM;
+
+	return 0;
+}
+
+void kvm_riscv_vcpu_free_vector_context(struct kvm_vcpu *vcpu)
+{
+	kfree(vcpu->arch.guest_reset_context.vector.datap);
+	kfree(vcpu->arch.host_context.vector.datap);
+}
+#endif
+
+static void *kvm_riscv_vcpu_vreg_addr(struct kvm_vcpu *vcpu,
+				      unsigned long reg_num,
+				      size_t reg_size)
+{
+	struct kvm_cpu_context *cntx = &vcpu->arch.guest_context;
+	void *reg_val;
+	size_t vlenb = riscv_v_vsize / 32;
+
+	if (reg_num < KVM_REG_RISCV_VECTOR_REG(0)) {
+		if (reg_size != sizeof(unsigned long))
+			return NULL;
+		switch (reg_num) {
+		case KVM_REG_RISCV_VECTOR_CSR_REG(vstart):
+			reg_val = &cntx->vector.vstart;
+			break;
+		case KVM_REG_RISCV_VECTOR_CSR_REG(vl):
+			reg_val = &cntx->vector.vl;
+			break;
+		case KVM_REG_RISCV_VECTOR_CSR_REG(vtype):
+			reg_val = &cntx->vector.vtype;
+			break;
+		case KVM_REG_RISCV_VECTOR_CSR_REG(vcsr):
+			reg_val = &cntx->vector.vcsr;
+			break;
+		case KVM_REG_RISCV_VECTOR_CSR_REG(datap):
+		default:
+			return NULL;
+		}
+	} else if (reg_num <= KVM_REG_RISCV_VECTOR_REG(31)) {
+		if (reg_size != vlenb)
+			return NULL;
+		reg_val = cntx->vector.datap
+			  + (reg_num - KVM_REG_RISCV_VECTOR_REG(0)) * vlenb;
+	} else {
+		return NULL;
+	}
+
+	return reg_val;
+}
+
+int kvm_riscv_vcpu_get_reg_vector(struct kvm_vcpu *vcpu,
+				  const struct kvm_one_reg *reg,
+				  unsigned long rtype)
+{
+	unsigned long *isa = vcpu->arch.isa;
+	unsigned long __user *uaddr =
+			(unsigned long __user *)(unsigned long)reg->addr;
+	unsigned long reg_num = reg->id & ~(KVM_REG_ARCH_MASK |
+					    KVM_REG_SIZE_MASK |
+					    rtype);
+	void *reg_val = NULL;
+	size_t reg_size = KVM_REG_SIZE(reg->id);
+
+	if (rtype == KVM_REG_RISCV_VECTOR &&
+	    riscv_isa_extension_available(isa, v)) {
+		reg_val = kvm_riscv_vcpu_vreg_addr(vcpu, reg_num, reg_size);
+	}
+
+	if (!reg_val)
+		return -EINVAL;
+
+	if (copy_to_user(uaddr, reg_val, reg_size))
+		return -EFAULT;
+
+	return 0;
+}
+
+int kvm_riscv_vcpu_set_reg_vector(struct kvm_vcpu *vcpu,
+				  const struct kvm_one_reg *reg,
+				  unsigned long rtype)
+{
+	unsigned long *isa = vcpu->arch.isa;
+	unsigned long __user *uaddr =
+			(unsigned long __user *)(unsigned long)reg->addr;
+	unsigned long reg_num = reg->id & ~(KVM_REG_ARCH_MASK |
+					    KVM_REG_SIZE_MASK |
+					    rtype);
+	void *reg_val = NULL;
+	size_t reg_size = KVM_REG_SIZE(reg->id);
+
+	if (rtype == KVM_REG_RISCV_VECTOR &&
+	    riscv_isa_extension_available(isa, v)) {
+		reg_val = kvm_riscv_vcpu_vreg_addr(vcpu, reg_num, reg_size);
+	}
+
+	if (!reg_val)
+		return -EINVAL;
+
+	if (copy_from_user(reg_val, uaddr, reg_size))
+		return -EFAULT;
+
+	return 0;
+}
-- 
2.17.1

